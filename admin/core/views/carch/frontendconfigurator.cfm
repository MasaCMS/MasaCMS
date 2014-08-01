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
	
	<cfif isDefined('arguments.rc.locknode') and arguments.rc.locknode>
		<cfset stats=arguments.rc.contentBean.getStats()>
		<cfif not len(stats.getLockID()) or stats.getLockID() eq session.mura.userid>
			<cfset stats.setLockID(session.mura.userID).setLockType('node').save()>
		</cfif>
	</cfif>
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
	#application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.inline')#: <strong><a href="?muraAction=cArch.edit&moduleID=#encodeForURL(rc.contentBean.getModuleID())#&siteID=#encodeForURL(rc.contentBean.getSiteID())#&topID=#encodeForURL(rc.contentBean.getContentID())#&contentID=#encodeForURL(rc.contentBean.getContentID())#&return=#encodeForURL(rc.return)#&contentHistID=#draftcheck.historyID#&parentID=#encodeForURL(rc.contentBean.getParentID())#&startrow=#encodeForURL(rc.startrow)#&compactDisplay=true&homeID=#encodeForHTML(rc.homeBean.getContentID())#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.gotolatest')#</a></strong>
	<p>
	</cfif>
	</cfif>
	
	<cfif hasChangesets and (not currentChangeset.getIsNew() or pendingChangesets.recordcount)>
	<p class="alert">
	<cfif pendingChangesets.recordcount>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.changesetnodenotify")#: 
	<cfloop query="pendingChangesets"><a href="?muraAction=cArch.edit&moduleID=#encodeForURL(rc.contentBean.getModuleID())#&siteID=#encodeForURL(rc.contentBean.getSiteID())#&topID=#encodeForURL(rc.contentBean.getContentID())#&contentID=#encodeForURL(rc.contentBean.getContentID())#&return=#encodeForURL(rc.return)#&contentHistID=#pendingChangesets.contentHistID#&parentID=#encodeForURL(rc.contentBean.getParentID())#&startrow=#encodeForURL(rc.startrow)#&compactDisplay=true&homeID=#encodeForHTML(rc.homeBean.getContentID())#">"#encodeForHTMLAttribute(pendingChangesets.changesetName)#"</a><cfif pendingChangesets.currentrow lt pendingChangesets.recordcount>, </cfif></cfloop><br/></cfif>
	<cfif not currentChangeset.getIsNew()>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.changesetversionnotify")#: "#encodeForHTMLAttribute(currentChangeset.getName())#"</cfif>
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
		<input type="button" class="btn" id="saveConfigDraft" value="#encodeForHTMLAttribute(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savedraft"))#"/>
		<input type="button" class="btn" id="previewConfigDraft" value="#encodeForHTMLAttribute(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.preview"))#"/>
		<cfif assignChangesets>
			<input type="button" class="btn" onclick="saveToChangeset('#rc.contentBean.getChangesetID()#','#encodeForHTML(rsDisplayObject.siteid)#','');return false;" value="#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savetochangeset")#" />	
		</cfif>
		<cfif rc.perm eq 'editor' and not $.siteConfig('EnforceChangesets')>
			<input type="button" class="btn" id="publishConfig" value="#encodeForHTMLAttribute(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.publish"))#"/>
		</cfif>
	</div>
</div>
<script>
siteManager.configuratorMode='frontEnd';

jQuery(document).ready(function(){

	$('##configurator .load-inline').spin(spinnerArgs2);

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
						'object':'#encodeForJavascript(rsDisplayObject.object)#',
						'objectid':'#encodeForJavascript(rsDisplayObject.objectid)#',
						'name':'#encodeForJavascript(rsDisplayObject.name)#',
						'regionid':'#encodeForJavascript(rsDisplayObject.columnid)#',
						'context':'#application.configBean.getContext()#',
						'params':'#encodeForJavascript(rsDisplayObject.params)#',
						'siteid':'#encodeForJavascript(rsDisplayObject.siteid)#',
						'contenthistid':'#encodeForJavascript(rc.contentBean.getContentHistID())#',
						'contentid':'#encodeForJavascript(rc.contentBean.getContentID())#',
						'parentid':'#encodeForJavascript(rc.contentBean.getParentID())#'		
					});
		</cfcase>
		<cfcase value="feed_slideshow,feed_slideshow_no_summary">	
			siteManager.initSlideShowConfigurator({
						'object':'#encodeForJavascript(rsDisplayObject.object)#',
						'objectid':'#encodeForJavascript(rsDisplayObject.objectid)#',
						'name':'#encodeForJavascript(rsDisplayObject.name)#',
						'regionid':'#encodeForJavascript(rsDisplayObject.columnid)#',
						'context':'#application.configBean.getContext()#',
						'params':'#encodeForJavascript(rsDisplayObject.params)#',
						'siteid':'#encodeForJavascript(rsDisplayObject.siteid)#',
						'contenthistid':'#encodeForJavascript(rc.contentBean.getContentHistID())#',
						'contentid':'#encodeForJavascript(rc.contentBean.getContentID())#',
						'parentid':'#encodeForJavascript(rc.contentBean.getParentID())#'
					});
		</cfcase>
		<cfcase value="category_summary,category_summary_rss">	
			siteManager.initCategorySummaryConfigurator({
						'object':'#encodeForJavascript(rsDisplayObject.object)#',
						'objectid':'#encodeForJavascript(rsDisplayObject.objectid)#',
						'name':'#encodeForJavascript(rsDisplayObject.name)#',
						'regionid':'#encodeForJavascript(rsDisplayObject.columnid)#',
						'context':'#application.configBean.getContext()#',
						'params':'#encodeForJavascript(rsDisplayObject.params)#',
						'siteid':'#encodeForJavascript(rsDisplayObject.siteid)#',
						'contenthistid':'#encodeForJavascript(rc.contentBean.getContentHistID())#',
						'contentid':'#encodeForJavascript(rc.contentBean.getContentID())#',
						'parentid':'#encodeForJavascript(rc.contentBean.getParentID())#'		
					});
		</cfcase>
		<cfcase value="tag_cloud">	
			siteManager.initTagCloudConfigurator({
						'object':'#encodeForJavascript(rsDisplayObject.object)#',
						'objectid':'#encodeForJavascript(rsDisplayObject.objectid)#',
						'name':'#encodeForJavascript(rsDisplayObject.name)#',
						'regionid':'#encodeForJavascript(rsDisplayObject.columnid)#',
						'context':'#application.configBean.getContext()#',
						'params':'#encodeForJavascript(rsDisplayObject.params)#',
						'siteid':'#encodeForJavascript(rsDisplayObject.siteid)#',
						'contenthistid':'#encodeForJavascript(rc.contentBean.getContentHistID())#',
						'contentid':'#encodeForJavascript(rc.contentBean.getContentID())#',
						'parentid':'#encodeForJavascript(rc.contentBean.getParentID())#'		
					});
		</cfcase>
		<cfcase value="site_map">	
			siteManager.initSiteMapConfigurator({
						'object':'#encodeForJavascript(rsDisplayObject.object)#',
						'objectid':'#encodeForJavascript(rsDisplayObject.objectid)#',
						'name':'#encodeForJavascript(rsDisplayObject.name)#',
						'regionid':'#encodeForJavascript(rsDisplayObject.columnid)#',
						'context':'#application.configBean.getContext()#',
						'params':'#encodeForJavascript(rsDisplayObject.params)#',
						'siteid':'#encodeForJavascript(rsDisplayObject.siteid)#',
						'contenthistid':'#encodeForJavascript(rc.contentBean.getContentHistID())#',
						'contentid':'#encodeForJavascript(rc.contentBean.getContentID())#',
						'parentid':'#encodeForJavascript(rc.contentBean.getParentID())#'		
					});
		</cfcase>
		<cfcase value="related_content,related_section_content">	
			siteManager.initRelatedContentConfigurator({
						'object':'#encodeForJavascript(rsDisplayObject.object)#',
						'objectid':'#encodeForJavascript(rsDisplayObject.objectid)#',
						'name':'#encodeForJavascript(rsDisplayObject.name)#',
						'regionid':'#encodeForJavascript(rsDisplayObject.columnid)#',
						'context':'#application.configBean.getContext()#',
						'params':'#encodeForJavascript(rsDisplayObject.params)#',
						'siteid':'#encodeForJavascript(rsDisplayObject.siteid)#',
						'contenthistid':'#encodeForJavascript(rc.contentBean.getContentHistID())#',
						'contentid':'#encodeForJavascript(rc.contentBean.getContentID())#',
						'parentid':'#encodeForJavascript(rc.contentBean.getParentID())#'		
					});
		</cfcase>
		<cfcase value="plugin">	
			var configurator=siteManager.getPluginConfigurator('#encodeForJavascript(rsDisplayObject.objectid)#');
			window[configurator](
				{
					'object':'#encodeForJavascript(rsDisplayObject.object)#',
					'objectid':'#encodeForJavascript(rsDisplayObject.objectid)#',
					'name':'#encodeForJavascript(rsDisplayObject.name)#',
					'regionid':'#encodeForJavascript(rsDisplayObject.columnid)#',
					'context':'#application.configBean.getContext()#',
					'params':'#encodeForJavascript(rsDisplayObject.params)#',
					'siteid':'#encodeForJavascript(rc.contentBean.getSiteID())#',
					'contenthistid':'#encodeForJavascript(rc.contentBean.getContentHistID())#',
					'contentid':'#encodeForJavascript(rc.contentBean.getContentID())#',
					'parentid':'#encodeForJavascript(rc.contentBean.getParentID())#'
				}
			);
			jQuery("##configuratorHeader").html('#encodeForJavascript(rsDisplayObject.name)#');
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
				$('##configurator .load-inline').spin(spinnerArgs2);
				jQuery(".form-actions").hide();
				jQuery("##configuratorNotices").hide();
				
				jQuery.post("./index.cfm?muraAction=cArch.updateObjectParams#rc.$.renderCSRFTokens(context=rsDisplayObject.contentHistID & 'add',format='url')#", {
					'contenthistid': '#encodeForJavascript(rsDisplayObject.contentHistID)#',
					'objectid': '#encodeForJavascript(rsDisplayObject.objectid)#',
					'regionid': '#encodeForJavascript(rsDisplayObject.columnid)#',
					'orderno': '#encodeForJavascript(rsDisplayObject.orderno)#',
					'siteid': '#encodeForJavascript(rsDisplayObject.siteid)#',
					'params': JSON.stringify(siteManager.availableObject.params),
					'approved': 1,
					'object': '#encodeForJavascript(rsDisplayObject.object)#',
					'name': '#encodeForJavascript(rsDisplayObject.name)#',
					'changesetid': '',
					'removepreviouschangeset': false,
					'preview': 0
				}, function(){
					frontEndProxy.post({cmd:'setLocation',location:'#encodeForJavascript(rc.homeBean.getURL())#'});
				});
			}
		});
	
	jQuery("##saveConfigDraft").bind("click",
		function(){
			
			siteManager.updateAvailableObject();
			
			if (siteManager.availableObjectValidate(siteManager.availableObject.params)) {
				jQuery("##configurator").html('<div class="load-inline"></div>');
				$('##configurator .load-inline').spin(spinnerArgs2);
				jQuery(".form-actions").hide();
				jQuery("##configuratorNotices").hide();
				
				jQuery.post("./index.cfm?muraAction=cArch.updateObjectParams", {
					'contenthistid': '#encodeForJavascript(rsDisplayObject.contentHistID)#',
					'objectid': '#encodeForJavascript(rsDisplayObject.objectid)#',
					'regionid': '#encodeForJavascript(rsDisplayObject.columnid)#',
					'orderno': '#encodeForJavascript(rsDisplayObject.orderno)#',
					'siteid': '#encodeForJavascript(rsDisplayObject.siteid)#',
					'params': JSON.stringify(siteManager.availableObject.params),
					'approved': 0,
					'object': '#encodeForJavascript(rsDisplayObject.object)#',
					'name': '#encodeForJavascript(rsDisplayObject.name)#',
					'changesetid': '',
					'removepreviouschangeset': false,
					'preview': 0
				}, function(){
					frontEndProxy.post({cmd:'setLocation',location:'#encodeForJavascript(rc.homeBean.getURL())#'});
				});
			}
		});
		
		jQuery("##previewConfigDraft").bind("click",
		function(){
			
			siteManager.updateAvailableObject();
				
			if (siteManager.availableObjectValidate(siteManager.availableObject.params)) {
				jQuery("##configurator").html('<div class="load-inline"></div>');
				$('##configurator .load-inline').spin(spinnerArgs2);
				jQuery(".form-actions").hide();
				jQuery("##configuratorNotices").hide();
				
				jQuery.post("./index.cfm?muraAction=cArch.updateObjectParams",
				{
					'contenthistid':'#encodeForJavascript(rsDisplayObject.contentHistID)#',
					'objectid':'#encodeForJavascript(rsDisplayObject.objectid)#',
					'regionid':'#encodeForJavascript(rsDisplayObject.columnid)#',
					'orderno':'#encodeForJavascript(rsDisplayObject.orderno)#',
					'siteid':'#encodeForJavascript(rsDisplayObject.siteid)#',
					'params': JSON.stringify(siteManager.availableObject.params),
					'approved':0,
					'object':'#encodeForJavascript(rsDisplayObject.object)#',
					'name': '#encodeForJavascript(rsDisplayObject.name)#',
					'changesetid':'',
					'removepreviouschangeset':false,
					'preview':1	
				},
	
				function(raw){
					var resp=eval( "(" + raw + ")" );
					<cfset str=rc.homeBean.getURL()>
					var loc="#encodeForJavascript(str)#";
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
				$('##configurator .load-inline').spin(spinnerArgs2);
				jQuery(".form-actions").hide();
				
				jQuery.post("./index.cfm?muraAction=cArch.updateObjectParams", {
					'contenthistid': '#encodeForJavascript(rsDisplayObject.contentHistID)#',
					'objectid': '#encodeForJavascript(rsDisplayObject.objectid)#',
					'regionid': '#encodeForJavascript(rsDisplayObject.columnid)#',
					'orderno': '#encodeForJavascript(rsDisplayObject.orderno)#',
					'siteid': '#encodeForJavascript(rsDisplayObject.siteid)#',
					'params': JSON.stringify(siteManager.availableObject.params),
					'approved': 0,
					'object': '#encodeForJavascript(rsDisplayObject.object)#',
					'name': '#encodeForJavascript(rsDisplayObject.name)#',
					'changesetid': changesetid,
					'removepreviouschangeset': removepreviouschangeset,
					'preview': 0
				}, function(){
					frontEndProxy.post({cmd:'setLocation',location:'#encodeForJavascript(rc.homeBean.getURL())#'});
				});
				
			}
			 						
	});	
	
}

var draftremovalnotice=<cfif application.configBean.getPurgeDrafts() and event.getValue("suppressDraftNotice") neq "true" and rc.contentBean.hasDrafts()><cfoutput>'#encodeForJavascript(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.draftremovalnotice"))#'</cfoutput><cfelse>""</cfif>;
</script>
<cfinclude template="dsp_configuratorJS.cfm">
</cfoutput>