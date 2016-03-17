<cfsilent>
<cfset $=application.serviceFactory.getBean("muraScope").init(rc.siteID)>
<cfset feed=$.getBean("feed")>
<cfset feed.set(url)>

</cfsilent>
<cfinclude template="js.cfm">
<cfoutput>

<div class="mura-header">
	<h1>Select Fields</h1>

	<!---
	<div class="nav-module-specific btn-toolbar">
		<div class="btn-group">
			<a class="btn" href="javascript:frontEndProxy.post({cmd:'close'});"><i class="mi-arrow-circle-left"></i>  #application.rbFactory.getKeyValue(session.rb,'collections.back')#</a>
		</div>
	</div> <!-- /.nav-module-specific -->
	--->

</div> <!-- /.mura-header -->
<div class="block block-constrain">
	<div class="block block-bordered">
	  <div class="block-content">
			<div class="mura-control-group" id="availableFields">
				<!---
				<label class="mura-control-label">
					<span class="span6">Available Fields</span> <span class="span6">Selected Fields</span>
				</label>
				--->
				<div id="sortableFields" class="mura-control justify">
					<p class="dragMsg">
						<span class="dragFrom span6">Drag Fields from Here&hellip;</span><span class="span6">&hellip;and Drop Them Here.</span>
					</p>

					<cfset displayList=feed.getDisplayList()>
					<cfset availableList=feed.getAvailableDisplayList()>

					<ul id="availableListSort" class="displayListSortOptions">
						<cfloop list="#availableList#" index="i">
							<li class="ui-state-default">#trim(i)#</li>
						</cfloop>
					</ul>

					<ul id="displayListSort" class="displayListSortOptions">
						<cfloop list="#displayList#" index="i">
							<li class="ui-state-highlight">#trim(i)#</li>
						</cfloop>
					</ul>
					<input type="hidden" id="displayList" class="objectParam" value="#displayList#" name="displayList"  data-displayobjectparam="displayList"/>
				</div>
			</div>

			<div class="form-actions">
				<button class="btn" id="updateBtn">Update</button>
			</div>
		</div> <!-- /.block-content -->
	</div> <!-- /.block-bordered -->
</div> <!-- /.block-constrain -->

<script>

$(function(){
	if($("##ProxyIFrame").length){
		$("##ProxyIFrame").load(
			function(){
				frontEndProxy.post({cmd:'setWidth',width:600});
			}
		);
	} else {
		frontEndProxy.post({cmd:'setWidth',width:600});
	}



	$('##updateBtn').click(function(){
		frontEndProxy.post({
			cmd:'setObjectParams',
			reinit:true,
			instanceid:'#esapiEncode("javascript",rc.instanceid)#',
			params:{
				displayList:$('##displayList').val()
				}
			});
	});

	$("##availableListSort, ##displayListSort").sortable({
		connectWith: ".displayListSortOptions",
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

			});

		}
	}).disableSelection();

});
</script>
</cfoutput>
