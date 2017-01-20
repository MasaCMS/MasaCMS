<cfoutput>
<script>
siteManager.customtaggroups=#serializeJSON(listToArray($.siteConfig('customTagGroups')))#;

var remoteFeedConfiguratorTitle='#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.remotefeedtitle"))#';
var localIndexConfiguratorTitle='#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.localindextitle"))#';
var tagCloudConfiguratorTitle='#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.tagcloudtitle"))#';
var categorySummaryConfiguratorTitle='#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.categorysummarytitle"))#';	
var slideShowConfiguratorTitle='#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.slideshowtitle"))#';	
var relatedContentConfiguratorTitle='#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.relatedcontenttitle"))#';	
var siteMapConfiguratorTitle='#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.sitemaptitle"))#';		
var genericConfiguratorTitle='#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.generictitle"))#';	
var genericConfiguratorMessage='#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"sitemanager.configurator.genericmessage"))#';
var contentid='#esapiEncode("javascript",rc.contentid)#';
var parentid='#esapiEncode("javascript",rc.parentid)#';
<cfif isDefined('rc.contentBean')>
var contenthistid='#rc.contentBean.getContentHistID()#';
<cfelse>
var contenthistid='#esapiEncode("javascript",rc.contenthistid)#';
</cfif>

siteManager.allowopenfeeds=#application.configBean.getValue(property='allowopenfeeds',defaultValue=false)#;
<cfset rsPluginDisplayObjects=application.pluginManager.getDisplayObjectsBySiteID(siteID=session.siteID,configuratorsOnly=true)>
<cfset nonPluginDisplayObjects=$.siteConfig().getDisplayObjectLookup()>
var pluginConfigurators=new Array();
<cfloop query="rsPluginDisplayObjects">
pluginConfigurators.push({'objectid':'#rsPluginDisplayObjects.objectid#','init':'#rsPluginDisplayObjects.configuratorInit#'});
</cfloop>
<cfloop item="i" collection="#nonPluginDisplayObjects#">
<cfif len(nonPluginDisplayObjects[i].configuratorInit)>
	pluginConfigurators.push({'objectid':'#nonPluginDisplayObjects[i].objectid#','init':'#nonPluginDisplayObjects[i].configuratorInit#'});
</cfif>
</cfloop>
<cfif isDefined('rc.contentBean') and rc.$.getContentRenderer().useLayoutManager()>
	siteManager.layoutmanager=true;
</cfif>
</script>
<cfloop query="rsPluginDisplayObjects">
<cfif len(rsPluginDisplayObjects.configuratorJS)>
<script type="text/javascript" src="#application.configBean.getContext()#/plugins/#rsPluginDisplayObjects.directory#/#rsPluginDisplayObjects.configuratorJS#"></script>
</cfif>
</cfloop>
<cfloop item="i" collection="#nonPluginDisplayObjects#">
<cfif len(nonPluginDisplayObjects[i].configuratorInit)>
<script type="text/javascript" src="#$.siteConfig().getAssetPath()#/#nonPluginDisplayObjects[i].configuratorJS#"></script>
</cfif>
</cfloop>
</cfoutput>