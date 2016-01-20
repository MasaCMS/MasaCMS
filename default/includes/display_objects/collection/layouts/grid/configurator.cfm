 <!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfoutput>
<cfset renderer=$.getContentRenderer()>
<cfset gridStyles=(isdefined('renderer.contentGridStyleMap')) ? renderer.contentGridStyleMap : ''>
<cfif isStruct(gridStyles)>
<cfset gridStyles=listSort(structKeyList(gridStyles),'TextNoCase')>
<div class="control-group">	
  	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'collections.gridstyle')#</label>
	<div class="controls">
		<select name="gridstyle" data-displayobjectparam="gridstyle" class="objectParam span12">
			<cfloop list="#gridStyles#" index="style">
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
					<option value="#lcase(i)#"<cfif i eq feed.getImageSize()> selected</cfif>>#i#</option>
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