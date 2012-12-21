<cfset event=request.event>
<cfinclude template="js.cfm">
<cfsilent>
	<cfset rsDisplayObject=application.contentManager.readContentObject(rc.contentHistID,rc.regionID,rc.orderno)>
	<cfset rc.siteid=rsDisplayObject.siteid>
	<cfif rsDisplayObject.object eq "plugin">
	<cfset displayObjectBean=application.serviceFactory.getBean('pluginDisplayObjectBean').setObjectID(rsDisplayObject.objectid).load()>
		<cfset displayObjectBean.load()>
		<cfset hasConfigurator=len(displayObjectBean.getConfiguratorJS())>
	</cfif>
	<cfset rc.contentBean=application.contentManager.getContentVersion(contentHistID=rsDisplayObject.contenthistid,siteID=rsDisplayObject.siteid)>
	<cfset rc.perm=application.permUtility.getNodePerm(application.contentGateway.getCrumblist(rc.contentBean.getContentID(),rc.contentBean.getSiteID()))>
	<cfset rc.homeBean=application.contentManager.getActiveContent(contentID=rc.homeID,siteID=rsDisplayObject.siteid)>
	<cfset hasChangesets=application.settingsManager.getSite(rsDisplayObject.siteID).getHasChangesets()>
	<cfif hasChangesets>
		<cfset currentChangeset=application.changesetManager.read(rc.contentBean.getChangesetID())>
		<cfset pendingChangesets=application.changesetManager.getPendingByContentID(rc.contentBean.getContentID(),rc.siteID)>
	</cfif>
	<cfset assignChangesets=rc.perm eq 'editor' and hasChangesets>
	<cfset $=event.getValue("MuraScope")>
</cfsilent>
<cfoutput>
<cfif rc.compactDisplay eq "true">
<script type="text/javascript">
jQuery(document).ready(function(){
	if (top.location != self.location) {
		if(jQuery("##ProxyIFrame").length){
			jQuery("##ProxyIFrame").load(
				function(){
					frontEndProxy.post({cmd:'setWidth',width:'standard'});
				}
			);	
		} else {
			frontEndProxy.post({cmd:'setWidth',width:'standard'});
		}
	}
});
</script>
</cfif> 

<div id="configuratorContainer">
	<h1 id="configuratorHeader">Loading...</h1>
	<div id="configuratorNotices" style="display:none;">
	<cfif not rc.contentBean.getIsNew()>
	<cfset draftcheck=application.contentManager.getDraftPromptData(rc.contentBean.getContentID(),rc.contentBean.getSiteID())>
	
	<cfif yesNoFormat(draftcheck.showdialog) and draftcheck.historyid neq rc.contentBean.getContentHistID()>
	<p class="alert">
	#application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.inline')#: <strong><a href="?muraAction=cArch.edit&moduleID=#URLEncodedFormat(rc.contentBean.getModuleID())#&siteID=#URLEncodedFormat(rc.contentBean.getSiteID())#&topID=#URLEncodedFormat(rc.contentBean.getContentID())#&contentID=#URLEncodedFormat(rc.contentBean.getContentID())#&return=#URLEncodedFormat(rc.return)#&contentHistID=#draftcheck.historyID#&parentID=#URLEncodedFormat(rc.contentBean.getParentID())#&startrow=#URLEncodedFormat(rc.startrow)#&compactDisplay=true&homeID=#HTMLEditFormat(rc.homeBean.getContentID())#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.gotolatest')#</a></strong>
	<p>
	</cfif>
	</cfif>
	
	<cfif hasChangesets and (not currentChangeset.getIsNew() or pendingChangesets.recordcount)>
	<p class="alert">
	<cfif pendingChangesets.recordcount>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.changesetnodenotify")#: 
	<cfloop query="pendingChangesets"><a href="?muraAction=cArch.edit&moduleID=#URLEncodedFormat(rc.contentBean.getModuleID())#&siteID=#URLEncodedFormat(rc.contentBean.getSiteID())#&topID=#URLEncodedFormat(rc.contentBean.getContentID())#&contentID=#URLEncodedFormat(rc.contentBean.getContentID())#&return=#URLEncodedFormat(rc.return)#&contentHistID=#pendingChangesets.contentHistID#&parentID=#URLEncodedFormat(rc.contentBean.getParentID())#&startrow=#URLEncodedFormat(rc.startrow)#&compactDisplay=true&homeID=#HTMLEditFormat(rc.homeBean.getContentID())#">"#HTMLEditFormat(pendingChangesets.changesetName)#"</a><cfif pendingChangesets.currentrow lt pendingChangesets.recordcount>, </cfif></cfloop><br/></cfif>
	<cfif not currentChangeset.getIsNew()>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.changesetversionnotify")#: "#HTMLEditFormat(currentChangeset.getName())#"</cfif>
	</p>
	</cfif>
	</div>
	<div id="configurator">
		<div class="load-inline"></div>
	</div>	

	<cfif assignChangesets>
		<cfinclude template="form/dsp_changesets.cfm">
	</cfif>

	<div class="form-actions">	
		<input type="button" class="btn" id="saveConfigDraft" value="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savedraft"))#"/>
		<input type="button" class="btn" id="previewConfigDraft" value="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.preview"))#"/>
		<cfif assignChangesets>
			<input type="button" class="btn" onclick="saveToChangeset('#rc.contentBean.getChangesetID()#','#HTMLEditFormat(rsDisplayObject.siteid)#','');return false;" value="#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savetochangeset")#" />	
		</cfif>
		<cfif rc.perm eq 'editor' and not $.siteConfig('EnforceChangesets')>
			<input type="button" class="btn" id="publishConfig" value="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.publish"))#"/>
		</cfif>
	</div>
</div>
<script>
siteManager.configuratorMode='frontEnd';

jQuery(document).ready(function(){
	if(jQuery("##ProxyIFrame").length){
		jQuery("##ProxyIFrame").load(
			function(){
				frontEndProxy.post({cmd:'setWidth',width:'configurator'});
			}
		);	
	} else {
		frontEndProxy.post({cmd:'setWidth',width:'configurator'});
	}
	
	<cfswitch expression="#rsDisplayObject.object#">
		<cfcase value="feed,feed_no_summary,remoteFeed">	
			siteManager.initFeedConfigurator({
						'object':'#JSStringFormat(rsDisplayObject.object)#',
						'objectid':'#JSStringFormat(rsDisplayObject.objectid)#',
						'name':'#JSStringFormat(rsDisplayObject.name)#',
						'regionid':'#JSStringFormat(rsDisplayObject.columnid)#',
						'context':'#application.configBean.getContext()#',
						'params':'#JSStringFormat(rsDisplayObject.params)#',
						'siteid':'#JSStringFormat(rsDisplayObject.siteid)#',
						'contenthistid':'#JSStringFormat(rc.contentBean.getContentHistID())#',
						'contentid':'#JSStringFormat(rc.contentBean.getContentID())#',
						'parentid':'#JSStringFormat(rc.contentBean.getParentID())#'		
					});
		</cfcase>
		<cfcase value="feed_slideshow,feed_slideshow_no_summary">	
			siteManager.initSlideShowConfigurator({
						'object':'#JSStringFormat(rsDisplayObject.object)#',
						'objectid':'#JSStringFormat(rsDisplayObject.objectid)#',
						'name':'#JSStringFormat(rsDisplayObject.name)#',
						'regionid':'#JSStringFormat(rsDisplayObject.columnid)#',
						'context':'#application.configBean.getContext()#',
						'params':'#JSStringFormat(rsDisplayObject.params)#',
						'siteid':'#JSStringFormat(rsDisplayObject.siteid)#',
						'contenthistid':'#JSStringFormat(rc.contentBean.getContentHistID())#',
						'contentid':'#JSStringFormat(rc.contentBean.getContentID())#',
						'parentid':'#JSStringFormat(rc.contentBean.getParentID())#'
					});
		</cfcase>
		<cfcase value="category_summary,category_summary_rss">	
			siteManager.initCategorySummaryConfigurator({
						'object':'#JSStringFormat(rsDisplayObject.object)#',
						'objectid':'#JSStringFormat(rsDisplayObject.objectid)#',
						'name':'#JSStringFormat(rsDisplayObject.name)#',
						'regionid':'#JSStringFormat(rsDisplayObject.columnid)#',
						'context':'#application.configBean.getContext()#',
						'params':'#JSStringFormat(rsDisplayObject.params)#',
						'siteid':'#JSStringFormat(rsDisplayObject.siteid)#',
						'contenthistid':'#JSStringFormat(rc.contentBean.getContentHistID())#',
						'contentid':'#JSStringFormat(rc.contentBean.getContentID())#',
						'parentid':'#JSStringFormat(rc.contentBean.getParentID())#'		
					});
		</cfcase>
		<cfcase value="related_content,related_section_content">	
			siteManager.initRelatedContentConfigurator({
						'object':'#JSStringFormat(rsDisplayObject.object)#',
						'objectid':'#JSStringFormat(rsDisplayObject.objectid)#',
						'name':'#JSStringFormat(rsDisplayObject.name)#',
						'regionid':'#JSStringFormat(rsDisplayObject.columnid)#',
						'context':'#application.configBean.getContext()#',
						'params':'#JSStringFormat(rsDisplayObject.params)#',
						'siteid':'#JSStringFormat(rsDisplayObject.siteid)#',
						'contenthistid':'#JSStringFormat(rc.contentBean.getContentHistID())#',
						'contentid':'#JSStringFormat(rc.contentBean.getContentID())#',
						'parentid':'#JSStringFormat(rc.contentBean.getParentID())#'		
					});
		</cfcase>
		<cfcase value="plugin">	
			var configurator=siteManager.getPluginConfigurator('#JSStringFormat(rsDisplayObject.objectid)#');
			window[configurator](
				{
					'object':'#JSStringFormat(rsDisplayObject.object)#',
					'objectid':'#JSStringFormat(rsDisplayObject.objectid)#',
					'name':'#JSStringFormat(rsDisplayObject.name)#',
					'regionid':'#JSStringFormat(rsDisplayObject.columnid)#',
					'context':'#application.configBean.getContext()#',
					'params':'#JSStringFormat(rsDisplayObject.params)#',
					'siteid':'#JSStringFormat(rc.contentBean.getSiteID())#',
					'contenthistid':'#JSStringFormat(rc.contentBean.getContentHistID())#',
					'contentid':'#JSStringFormat(rc.contentBean.getContentID())#',
					'parentid':'#JSStringFormat(rc.contentBean.getParentID())#'
				}
			);
			jQuery("##configuratorHeader").html('#JSStringFormat(rsDisplayObject.name)#');
		</cfcase>
	</cfswitch>
		
	jQuery("##publishConfig").bind("click",
		function(){
			
			if (draftremovalnotice != "" &&
			!confirm(draftremovalnotice)) {
				return false;
			}
			
			siteManager.updateAvailableObject();
			
			if (siteManager.availableObjectValidate(siteManager.availableObject.params)) {
				jQuery("##configurator").html('<div class="load-inline"></div>');
				jQuery(".form-actions").hide();
				jQuery("##configuratorNotices").hide();
				
				jQuery.post("./index.cfm?muraAction=cArch.updateObjectParams", {
					'contenthistid': '#JSStringFormat(rsDisplayObject.contentHistID)#',
					'objectid': '#JSStringFormat(rsDisplayObject.objectid)#',
					'regionid': '#JSStringFormat(rsDisplayObject.columnid)#',
					'orderno': '#JSStringFormat(rsDisplayObject.orderno)#',
					'siteid': '#JSStringFormat(rsDisplayObject.siteid)#',
					'params': JSON.stringify(siteManager.availableObject.params),
					'approved': 1,
					'object': '#JSStringFormat(rsDisplayObject.object)#',
					'name': '#JSStringFormat(rsDisplayObject.name)#',
					'changesetid': '',
					'removepreviouschangeset': false,
					'preview': 0
				}, function(){
					frontEndProxy.post({cmd:'setLocation',location:'#jsStringFormat(rc.homeBean.getURL())#'});
				});
			}
		});
	
	jQuery("##saveConfigDraft").bind("click",
		function(){
			
			siteManager.updateAvailableObject();
			
			if (siteManager.availableObjectValidate(siteManager.availableObject.params)) {
				jQuery("##configurator").html('<div class="load-inline"></div>');
				jQuery(".form-actions").hide();
				jQuery("##configuratorNotices").hide();
				
				jQuery.post("./index.cfm?muraAction=cArch.updateObjectParams", {
					'contenthistid': '#JSStringFormat(rsDisplayObject.contentHistID)#',
					'objectid': '#JSStringFormat(rsDisplayObject.objectid)#',
					'regionid': '#JSStringFormat(rsDisplayObject.columnid)#',
					'orderno': '#JSStringFormat(rsDisplayObject.orderno)#',
					'siteid': '#JSStringFormat(rsDisplayObject.siteid)#',
					'params': JSON.stringify(siteManager.availableObject.params),
					'approved': 0,
					'object': '#JSStringFormat(rsDisplayObject.object)#',
					'name': '#JSStringFormat(rsDisplayObject.name)#',
					'changesetid': '',
					'removepreviouschangeset': false,
					'preview': 0
				}, function(){
					frontEndProxy.post({cmd:'setLocation',location:'#jsStringFormat(rc.homeBean.getURL())#'});
				});
			}
		});
		
		jQuery("##previewConfigDraft").bind("click",
		function(){
			
			siteManager.updateAvailableObject();
				
			if (siteManager.availableObjectValidate(siteManager.availableObject.params)) {
				jQuery("##configurator").html('<div class="load-inline"></div>');
				jQuery(".form-actions").hide();
				jQuery("##configuratorNotices").hide();
				
				jQuery.post("./index.cfm?muraAction=cArch.updateObjectParams",
				{
					'contenthistid':'#JSStringFormat(rsDisplayObject.contentHistID)#',
					'objectid':'#JSStringFormat(rsDisplayObject.objectid)#',
					'regionid':'#JSStringFormat(rsDisplayObject.columnid)#',
					'orderno':'#JSStringFormat(rsDisplayObject.orderno)#',
					'siteid':'#JSStringFormat(rsDisplayObject.siteid)#',
					'params': JSON.stringify(siteManager.availableObject.params),
					'approved':0,
					'object':'#JSStringFormat(rsDisplayObject.object)#',
					'name': '#JSStringFormat(rsDisplayObject.name)#',
					'changesetid':'',
					'removepreviouschangeset':false,
					'preview':1	
				},
	
				function(raw){
					var resp=eval( "(" + raw + ")" );
					<cfset str=rc.homeBean.getURL()>
					var loc="#JSStringFormat(str)#";
					<cfif find("?",str)>
					loc=loc + "&";
					<cfelse>
					loc=loc + "?";
					</cfif>
					//loc=loc + "contentID=" + resp.contentid;
					loc=loc + "previewID=" + resp.contenthistid;
					frontEndProxy.post({cmd:'setLocation',location:encodeURIComponent(loc)});
				}
			
				);
			}
		});
	
});

function saveConfiguratorToChangeset(changesetid,removepreviouschangeset){

	confirmDialog(publishitemfromchangeset, 
		function() {
			siteManager.updateAvailableObject();
			
			if (siteManager.availableObjectValidate(siteManager.availableObject.params)) {
				jQuery("##configurator").html('<div class="load-inline"></div>');
				jQuery(".form-actions").hide();
				
				jQuery.post("./index.cfm?muraAction=cArch.updateObjectParams", {
					'contenthistid': '#JSStringFormat(rsDisplayObject.contentHistID)#',
					'objectid': '#JSStringFormat(rsDisplayObject.objectid)#',
					'regionid': '#JSStringFormat(rsDisplayObject.columnid)#',
					'orderno': '#JSStringFormat(rsDisplayObject.orderno)#',
					'siteid': '#JSStringFormat(rsDisplayObject.siteid)#',
					'params': JSON.stringify(siteManager.availableObject.params),
					'approved': 0,
					'object': '#JSStringFormat(rsDisplayObject.object)#',
					'name': '#JSStringFormat(rsDisplayObject.name)#',
					'changesetid': changesetid,
					'removepreviouschangeset': removepreviouschangeset,
					'preview': 0
				}, function(){
					frontEndProxy.post({cmd:'setLocation',location:'#jsStringFormat(rc.homeBean.getURL())#'});
				});
				
			}
			 						
	});	
	
}

var draftremovalnotice=<cfif application.configBean.getPurgeDrafts() and event.getValue("suppressDraftNotice") neq "true" and rc.contentBean.hasDrafts()><cfoutput>'#jsStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.draftremovalnotice"))#'</cfoutput><cfelse>""</cfif>;
</script>
<cfinclude template="dsp_configuratorJS.cfm">
</cfoutput>