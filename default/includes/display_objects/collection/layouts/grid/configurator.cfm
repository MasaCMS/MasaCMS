<cfoutput>
<cfset gridStyles=$.getContentRenderer().get('contentGridStyleMap')>
<cfif isStruct(gridStyles)>
<div class="control-group">	
  	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'collections.gridstyle')#</label>
	<div class="controls">
		<select name="gridstyle" data-displayobjectparam="gridstyle" class="objectParam span12">
			<cfloop collection="#gridStyles#" item="style">
				<option value="#style#"<cfif feed.getGridStyle() eq style> selected</cfif>>#style#</option>
			</cfloop>
		</select>
	</div>
</div>
</cfif>

<div class="control-group">	
  	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'collections.imagesize')#</label>
	<div class="controls">
			<select name="imageSize" data-displayobjectparam="imageSize" class="objectParam span12">
				<cfloop list="Small,Medium,Large" index="i">
					<option value="#lcase(i)#"<cfif i eq feed.getImageSize()> selected</cfif>>#I#</option>
				</cfloop>
		
				<cfset imageSizes=application.settingsManager.getSite(rc.siteid).getCustomImageSizeIterator()>
										
				<cfloop condition="imageSizes.hasNext()">
					<cfset image=imageSizes.next()>
					<option value="#lcase(image.getName())#"<cfif image.getName() eq feed.getImageSize()> selected</cfif>>#esapiEncode('html',image.getName())#</option>
				</cfloop>
					<option value="custom"<cfif "custom" eq feed.getImageSize()> selected</cfif>>Custom</option>
			</select>
	</div>
</div>

<div id="imageoptionscontainer" class="control-group span12" style="display:none">
	<div class="span6">	
		<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'collections.imageheight')#</label>
		<div class="controls">
      		<input class="objectParam span12" name="imageHeight" data-displayobjectparam="imageHeight" type="text" value="#feed.getImageHeight()#" />
      	</div>
    </div>
	<div class="span6">						
		<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'collections.imagewidth')#</label>
		<div class="controls">
			<input class="objectParam span12" name="imageWidth" data-displayobjectparam="imageWidth" type="text" value="#feed.getImageWidth()#" />
		</div>
	</div>	
</div>
<div class="control-group" id="availableFields">
	<label class="control-label">
		<span class="span6">Selected Fields</span>
		<button id="editFields" class="btn">Edit</button>	
	</label>
	<div id="sortableFields" class="controls sortable-sidebar">
		<cfset displayList=feed.getDisplayList()>
		<ul id="displayListSort" class="displayListSortOptions">
			<cfloop list="#displayList#" index="i">
				<li class="ui-state-highlight">#trim(i)#</li>
			</cfloop>
		</ul>
		
		<input type="hidden" id="displayList" class="objectParam" value="#esapiEncode('html_attr',feed.getDisplayList())#" name="displayList"  data-displayobjectparam="displayList"/>
	</div>	
</div>
<script>
	$(function(){
		$('##editFields').click(function(){
			frontEndProxy.post({
				cmd:'openModal',
				src:'?muraAction=cArch.selectfields&siteid=#esapiEncode("url",rc.siteid)#&contenthistid=#esapiEncode("url",rc.contenthistid)#&instanceid=#esapiEncode("url",rc.instanceid)#&compactDisplay=true&displaylist=' + $("##displayList").val()
				}
			);
		});

		$("##displayListSort").sortable({
			update: function(event) {
				event.stopPropagation();
				$("##displayList").val("");
				$("##displayListSort > li").each(function() {
					var current = $("##displayList").val();

					if(current != '') {
						$("##displayList").val(current + "," + $(this).html());
					} else {
						$("##displayList").val($(this).html());
					}

					updateDraft();
				});

				siteManager.updateObjectPreview();
				
			}
		}).disableSelection();

		$('##layoutoptionscontainer').show();

		function handleImageSizeChange(){
			if($('select[name="imageSize"]').val()=='custom'){
				$('##imageoptionscontainer').show()
			}else{
				$('##imageoptionscontainer').hide();
				$('##imageoptionscontainer').find(':input').val('AUTO');
			}
		}

		$('select[name="imageSize"]').change(handleImageSizeChange);

		handleImageSizeChange();
	});
</script>
</cfoutput>