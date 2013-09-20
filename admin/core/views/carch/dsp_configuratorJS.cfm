<cfoutput>
<script>
var customtaggroups=#serializeJSON(listToArray($.siteConfig('customTagGroups')))#;

var remoteFeedConfiguratorTitle='#JSStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.remotefeedtitle"))#';
var localIndexConfiguratorTitle='#JSStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.localindextitle"))#';
var tagCloudConfiguratorTitle='#JSStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.tagcloudtitle"))#';
var categorySummaryConfiguratorTitle='#JSStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.categorysummarytitle"))#';	
var slideShowConfiguratorTitle='#JSStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.slideshowtitle"))#';	
var relatedContentConfiguratorTitle='#JSStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.relatedcontenttitle"))#';		
var genericConfiguratorTitle='#JSStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.generictitle"))#';	
var genericConfiguratorMessage='#JSStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.genericmessage"))#';
var contentid='#rc.contentid#';
var parentid='#rc.parentid#';
var contenthistid='#rc.contentBean.getContentHistID()#';
<cfset rsPluginDisplayObjects=application.pluginManager.getDisplayObjectsBySiteID(siteID=session.siteID,configuratorsOnly=true)>
var pluginConfigurators=new Array();
<cfloop query="rsPluginDisplayObjects">
pluginConfigurators.push({'objectid':'#rsPluginDisplayObjects.objectid#','init':'#rsPluginDisplayObjects.configuratorInit#'});
</cfloop>
</script>
<cfloop query="rsPluginDisplayObjects">
<cfif len(rsPluginDisplayObjects.configuratorJS)>
<script type="text/javascript" src="#application.configBean.getContext()#/plugins/#rsPluginDisplayObjects.directory#/#rsPluginDisplayObjects.configuratorJS#"></script>
</cfif>
</cfloop>
</cfoutput>