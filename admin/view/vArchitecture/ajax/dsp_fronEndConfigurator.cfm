<cfsilent>
	<cfset rsDisplayObject=application.contentManager.readContentObject(attributes.contentHistID,attributes.regionID,attributes.orderno)>
	<cfif rsDisplayObject.object eq "plugin">
	<cfset displayObjectBean=createObject("component","mura.plugin.pluginDisplayObjectBean").init().setObjectID(rsDisplayObject.objectid).load()>
		<cfset displayObjectBean.load()>
		<cfset hasConfigurator=len(displayObjectBean.getConfiguratorJS())>
	</cfif>
	<cfset request.contentBean=application.contentManager.getContentVersion(contentHistID=rsDisplayObject.contenthistid,siteID=rsDisplayObject.siteid)>
	<cfset perm=application.permUtility.getNodePerm(application.contentGateway.getCrumblist(request.contentBean.getContentID(),request.contentBean.getSiteID()))>
	<cfset request.homeBean=application.contentManager.getActiveContent(contentID=attributes.homeID,siteID=rsDisplayObject.siteid)>
</cfsilent>
<cfoutput>
<div id="configuratorContainer" style="width: 400px;">
	<h2 id="configuratorHeader">Loading...</h2>
	<div id="configurator">
		<img src="images/progress_bar.gif">
	</div>	
	<div id="configuratorActions"  style="display:none">
		<input type="button" id="saveConfigDraft" value="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savedraft"))#"/>
		<cfif perm eq "Editor"><input type="button" id="publishConfig" value="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.publish"))#"/></cfif>
	</div>
	
</div>
<script>
var configuratorMode='frontEnd';

jQuery(document).ready(function(){
	if(jQuery("##ProxyIFrame").length){
		jQuery("##ProxyIFrame").load(
			function(){
				frontEndProxy.postMessage("cmd=setWindowMode&mode=configurator");
			}
		);	
	} else {
		frontEndProxy.postMessage("cmd=setWindowMode&mode=configurator");
	}
	
	<cfswitch expression="#rsDisplayObject.object#">
		<cfcase value="feed,feed_no_summary,remoteFeed">	
			initFeedConfigurator({
						'object':'#JSStringFormat(rsDisplayObject.object)#',
						'objectid':'#JSStringFormat(rsDisplayObject.objectid)#',
						'name':'#JSStringFormat(rsDisplayObject.name)#',
						'regionid':'#JSStringFormat(rsDisplayObject.columnid)#',
						'context':'#application.configBean.getContext()#',
						'params':'#JSStringFormat(rsDisplayObject.params)#'		
					});
		</cfcase>
		<cfcase value="feed_slideshow,feed_slideshow_no_summary">	
			initSlideShowConfigurator({
						'object':'#JSStringFormat(rsDisplayObject.object)#',
						'objectid':'#JSStringFormat(rsDisplayObject.objectid)#',
						'name':'#JSStringFormat(rsDisplayObject.name)#',
						'regionid':'#JSStringFormat(rsDisplayObject.columnid)#',
						'context':'#application.configBean.getContext()#',
						'params':'#JSStringFormat(rsDisplayObject.params)#'		
					});
		</cfcase>
		<cfcase value="category_summary,category_summary_rss">	
			initCategorySummaryConfigurator({
						'object':'#JSStringFormat(rsDisplayObject.object)#',
						'objectid':'#JSStringFormat(rsDisplayObject.objectid)#',
						'name':'#JSStringFormat(rsDisplayObject.name)#',
						'regionid':'#JSStringFormat(rsDisplayObject.columnid)#',
						'context':'#application.configBean.getContext()#',
						'params':'#JSStringFormat(rsDisplayObject.params)#'		
					});
		</cfcase>
		<cfcase value="related_content,related_section_content">	
			initRelatedContentConfigurator({
						'object':'#JSStringFormat(rsDisplayObject.object)#',
						'objectid':'#JSStringFormat(rsDisplayObject.objectid)#',
						'name':'#JSStringFormat(rsDisplayObject.name)#',
						'regionid':'#JSStringFormat(rsDisplayObject.columnid)#',
						'context':'#application.configBean.getContext()#',
						'params':'#JSStringFormat(rsDisplayObject.params)#'		
					});
		</cfcase>
		<cfcase value="plugin">	
			var configurator=getPluginConfigurator('#JSStringFormat(rsDisplayObject.objectid)#');
			window[configurator](
				{
					'object':'#JSStringFormat(rsDisplayObject.object)#',
					'objectid':'#JSStringFormat(rsDisplayObject.objectid)#',
					'name':'#JSStringFormat(rsDisplayObject.name)#',
					'regionid':'#JSStringFormat(rsDisplayObject.columnid)#',
					'context':'#application.configBean.getContext()#',
					'params':'#JSStringFormat(rsDisplayObject.params)#'		
				}
			);
			jQuery("##configuratorHeader").html('#JSStringFormat(rsDisplayObject.name)#');
		</cfcase>
	</cfswitch>
		
	jQuery("##publishConfig").bind("click",
		function(){
			
			updateAvailableObject();
				
			jQuery("##configurator").html('<img src="images/progress_bar.gif">');
			jQuery("##configuratorActions").hide();
			
			jQuery.post("./index.cfm?fuseaction=cArch.updateObjectParams",
			{
				'contenthistid':'#JSStringFormat(rsDisplayObject.contentHistID)#',
				'objectid':'#JSStringFormat(rsDisplayObject.objectid)#',
				'regionid':'#JSStringFormat(rsDisplayObject.columnid)#',
				'orderno':'#JSStringFormat(rsDisplayObject.orderno)#',
				'siteid':'#JSStringFormat(rsDisplayObject.siteid)#',
				'params': JSON.stringify(availableObject.params),
				'approved':1,
				'object':'#JSStringFormat(rsDisplayObject.object)#',
				'name': '#JSStringFormat(rsDisplayObject.name)#'		
			},

			function(data){
				frontEndProxy.postMessage("cmd=setLocation&location=#jsStringFormat(request.homeBean.getURL())#");
			}
		
			);
		});
	
	jQuery("##saveConfigDraft").bind("click",
		function(){
			
			updateAvailableObject();
				
			jQuery("##configurator").html('<img src="images/progress_bar.gif">');
			jQuery("##configuratorActions").hide();
			
			jQuery.post("./index.cfm?fuseaction=cArch.updateObjectParams",
			{
				'contenthistid':'#JSStringFormat(rsDisplayObject.contentHistID)#',
				'objectid':'#JSStringFormat(rsDisplayObject.objectid)#',
				'regionid':'#JSStringFormat(rsDisplayObject.columnid)#',
				'orderno':'#JSStringFormat(rsDisplayObject.orderno)#',
				'siteid':'#JSStringFormat(rsDisplayObject.siteid)#',
				'params': JSON.stringify(availableObject.params),
				'approved':0,
				'object':'#JSStringFormat(rsDisplayObject.object)#',
				'name': '#JSStringFormat(rsDisplayObject.name)#'	
			},

			function(){
				frontEndProxy.postMessage("cmd=setLocation&location=#jsStringFormat(request.homeBean.getURL())#");
			}
		
			);
		});
});
</script>
<cfinclude template="dsp_configuratorJS.cfm">
</cfoutput>