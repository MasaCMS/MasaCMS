<cfsilent>
	<cfset rsDisplayObject=application.contentManager.readContentObject(attributes.contentHistID,attributes.regionID,attributes.orderno)>
	<cfset dislpayObjectBean=createObject("component","mura.plugin.pluginDisplayObjectBean").init().setObjectID(rsDisplayObject.objectid).load()>
	<cfset dislpayObjectBean.load()>
	<cfset hasConfigurator=len(dislpayObjectBean.getConfiguratorJS())>
	<cfset request.contentBean=application.contentManager.getContentVersion(contentHistID=rsDisplayObject.contenthistid,siteID=rsDisplayObject.siteid)>
</cfsilent>
<cfoutput>
<div id="configuratorContainer" style="width: 400px;">
	<h2 style="width: 400px;"><cfif hasConfigurator>#HTMLEditFormat(rsDisplayObject.name)#<cfelse>#HTMLEditFormat(dislpayObjectBean.getName())#</cfif></h2>
	<div id="configurator">
		<cfif hasConfigurator>
		<img src="images/progress_bar.gif">
		<cfelse>
		<p>#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.genericmessage"))#</p>
		</cfif>
	</div>
	<cfif hasConfigurator>
	<div>
		<input id="saveConfig" type="button" value="save" style="display:none"/>
	</div>
	</cfif>
</div>
<cfif hasConfigurator>
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
	
	var configurator=getPluginConfigurator('#JSStringFormat(rsDisplayObject.objectid)#');
	if (configurator != '') {
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
	}
	
	jQuery("##saveConfig").bind("click",
		function(){
			
			updateAvailableObject();
				
			jQuery("##configurator").html('<img src="images/progress_bar.gif">');
			jQuery(this).hide();
			
			jQuery.post("./index.cfm?fuseaction=cArch.updateObjectParams",
			{
				'contenthistid':'#JSStringFormat(rsDisplayObject.contentHistID)#',
				'objectid':'#JSStringFormat(rsDisplayObject.objectid)#',
				'regionid':'#JSStringFormat(rsDisplayObject.columnid)#',
				'orderno':'#JSStringFormat(rsDisplayObject.orderno)#',
				'siteid':'#JSStringFormat(rsDisplayObject.siteid)#',
				'params': JSON.stringify(availableObject.params)	
			},

			function(){
				frontEndProxy.postMessage("cmd=setLocation&location=#jsStringFormat(request.contentBean.getURL())#");
			}
		
			);
		});
	
});
</script>
<cfinclude template="dsp_configuratorJS.cfm">
</cfif>
</cfoutput>