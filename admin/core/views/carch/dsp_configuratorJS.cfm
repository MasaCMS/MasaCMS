<cfoutput>
<script>
var customtaggroups=#serializeJSON(listToArray($.siteConfig('customTagGroups')))#;

var remoteFeedConfiguratorTitle='#tempEncodeForJavascript(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.remotefeedtitle"))#';
var localIndexConfiguratorTitle='#tempEncodeForJavascript(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.localindextitle"))#';
var tagCloudConfiguratorTitle='#tempEncodeForJavascript(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.tagcloudtitle"))#';
var categorySummaryConfiguratorTitle='#tempEncodeForJavascript(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.categorysummarytitle"))#';	
var slideShowConfiguratorTitle='#tempEncodeForJavascript(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.slideshowtitle"))#';	
var relatedContentConfiguratorTitle='#tempEncodeForJavascript(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.relatedcontenttitle"))#';	
var siteMapConfiguratorTitle='#tempEncodeForJavascript(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.sitemaptitle"))#';		
var genericConfiguratorTitle='#tempEncodeForJavascript(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.generictitle"))#';	
var genericConfiguratorMessage='#tempEncodeForJavascript(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.genericmessage"))#';
var contentid='#rc.contentid#';
var parentid='#rc.parentid#';
var contenthistid='#rc.contentBean.getContentHistID()#';
var allowopenfeeds=#application.configBean.getValue(property='allowopenfeeds',defaultValue=false)#;
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