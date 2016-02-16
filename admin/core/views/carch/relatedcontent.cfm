<cfsilent>
	<cfset content=rc.$.getBean('content').loadBy(contenthistid=rc.contenthistid)>
	<cfparam name="rc.relatedcontentsetid" default="">
	<cfparam name="rc.relateditems" default="[]">
</cfsilent>
<cfinclude template="js.cfm">
<cfoutput>

<div class="mura-header">
	<cfif rc.relatedcontentsetid eq 'calendar'>
		<h1>Select Additional Calendars</h1>
	<cfelse>
		<h1>Select Content</h1>
	</cfif>

	<div class="mura-item-metadata">
		<div class="label-group">

	<!-- optional - the view might use dsp_secondary_menu.cfm instead -->
	<div id="nav-module-specific" class="btn-toolbar">
		<a class="btn" href="javascript:frontEndProxy.post({cmd:'close'});"><i class="mi-arrow-circle-left"></i>  #application.rbFactory.getKeyValue(session.rb,'collections.back')#
		</a>
	</div>
	<!-- /optional nav-module-specific -->

		</div><!-- /.label-group -->
	</div><!-- /.mura-item-metadata -->
</div> <!-- /.mura-header -->

<div class="block block-constrain">
	<div class="block block-bordered">
		<div class="block-content">
			<div id="selectRelatedContent"><!--- target for ajax ---></div>
			<div id="selectedRelatedContent" class="control-group">
			</div>
			<input id="relatedContentSetData" type="hidden" name="relatedContentSetData" value="" />

			<div class="form-actions">
				<button class="btn" id="updateBtn">Update</button>
			</div>
		</div> <!-- /.block-content -->
	</div> <!-- /.block-bordered -->
</div> <!-- /.block-constrain -->

<script>
$(function(){

	function getItems(){
		var raw=$('##relatedContentSetData').val();
		if(raw){
			var parsed=JSON.parse(raw);
			return parsed[0].items;
		} else {
			return [];
		}
	}

	$('##updateBtn').click(function(){
		//alert(JSON.stringify(getItems()))
		//return;
		frontEndProxy.post({
			cmd:'setObjectParams',
			reinit:true,
			instanceid:'#esapiEncode("javascript",rc.instanceid)#',
			params:{
				source:'#esapiEncode("javascript",rc.relatedcontentsetid)#',
				sourcetype:'relatedcontent',
				items: JSON.stringify(getItems())
				}
			});
	});

	if($("##ProxyIFrame").length){
		$("##ProxyIFrame").load(
			function(){
				frontEndProxy.post({cmd:'setWidth',width:'standard'});
			}
		);
	} else {
		frontEndProxy.post({cmd:'setWidth',width:'standard'});
	}


	siteManager.loadRelatedContentSets(
		'#esapiEncode("javascript",content.getContentID())#',
		'#esapiEncode("javascript",content.getContentHistID())#',
		'#esapiEncode("javascript",content.getType())#',
		'#esapiEncode("javascript",content.getSubType())#',
		'#esapiEncode("javascript",content.getSiteID())#',
		'#esapiEncode("javascript",rc.relatedcontentsetid)#',
		'#esapiEncode("javascript",rc.items)#',
		false
	);

});
</script>
</cfoutput>
