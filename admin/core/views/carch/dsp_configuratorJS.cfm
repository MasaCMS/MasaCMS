<cfoutput>
<script>
var customtaggroups=#serializeJSON(listToArray($.siteConfig('customTagGroups')))#;

var remoteFeedConfiguratorTitle='#encodeForJavascript(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.remotefeedtitle"))#';
var localIndexConfiguratorTitle='#encodeForJavascript(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.localindextitle"))#';
var tagCloudConfiguratorTitle='#encodeForJavascript(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.tagcloudtitle"))#';
var categorySummaryConfiguratorTitle='#encodeForJavascript(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.categorysummarytitle"))#';	
var slideShowConfiguratorTitle='#encodeForJavascript(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.slideshowtitle"))#';	
var relatedContentConfiguratorTitle='#encodeForJavascript(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.relatedcontenttitle"))#';	
var siteMapConfiguratorTitle='#encodeForJavascript(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.sitemaptitle"))#';		
var genericConfiguratorTitle='#encodeForJavascript(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.generictitle"))#';	
var genericConfiguratorMessage='#encodeForJavascript(application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.genericmessage"))#';
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