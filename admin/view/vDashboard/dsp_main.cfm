<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfset started=false>
<cfparam name="application.sessionTrackingThrottle" default="false">
<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>
<cfinclude template="act_defaults.cfm"/>
<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,"dashboard.dashboard")#</h2>

<div class="wrap">

<div id="contentPrimary">
</cfoutput>
<cfset rsPluginScripts=application.pluginManager.getScripts("onDashboardPrimaryTop",attributes.siteID)>
<cfoutput query="rsPluginScripts" group="pluginID">
<cfset rsPluginScript=application.pluginManager.getScripts("onDashboardPrimaryTop",attributes.siteID,rsPluginScripts.moduleID)>
<div<cfif not started> class="separate"</cfif>>
	<h3>#HTMLEditformat(rsPluginScripts.name)#</h3>
	<cfoutput>
	#application.pluginManager.renderScripts("onDashboardPrimaryTop",attributes.siteid,pluginEvent,rsPluginScript)#
	</cfoutput>
</div>
<cfset started=true>
</cfoutput>
<cfoutput>
<cfif application.configBean.getSessionHistory() >	
<cfif not application.sessionTrackingThrottle>
<div id="userActivity"<cfif started> class="separate"</cfif>>
<h3>#application.rbFactory.getKeyValue(session.rb,"dashboard.useractivity")# <span><a href="index.cfm?fuseaction=cDashboard.sessionSearch&siteid=#URLEncodedFormat(attributes.siteid)#&newSearch=true">(#application.rbFactory.getKeyValue(session.rb,"dashboard.advancedsessionsearch")#)</a></span></h3>
<span id="userActivityData"></span>
</div>
<script type="text/javascript">loadUserActivity('#attributes.siteid#');</script>
<cfset started=true>

<div id="popularContent"<cfif started> class="separate"</cfif>>
<h3>#application.rbFactory.getKeyValue(session.rb,"dashboard.popularcontent")# <span>(#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.span"),attributes.span)#)</span></h3>
<span id="popularContentData"></span>
</div>
<script type="text/javascript">loadPopularContent('#attributes.siteid#');</script>
<cfset started=true>
<cfelse>
<div id="userActivity"<cfif started> class="separate"</cfif>>
<h3>#application.rbFactory.getKeyValue(session.rb,"dashboard.useractivity")#</h3>
<p>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.trackingthrottled")# </p>
</div>
<cfset started=true>
</cfif>
</cfif>

<cfif application.contentManager.getRecentCommentsQuery(session.siteID,1,false).recordCount>
<div id="recentComments"<cfif started> class="separate"</cfif>>
<h3>#application.rbFactory.getKeyValue(session.rb,"dashboard.comments")# <span><a href="?fuseaction=cDashboard.recentComments&siteID=#session.siteID#">(#application.rbFactory.getKeyValue(session.rb,"dashboard.comments.last100")#)</a></span></h3>
<span id="recentCommentsData"></span>
</div>
<script type="text/javascript">loadRecentComments('#attributes.siteid#');</script>
<cfset started=true>
</cfif>

<cfif application.settingsManager.getSite(session.siteid).getdatacollection() and  application.permUtility.getModulePerm("00000000000000000000000000000000004","#session.siteid#")>
<div id="recentFormActivity"<cfif started> class="separate"</cfif>>
<h3>#application.rbFactory.getKeyValue(session.rb,"dashboard.formactivity")#</h3>
<span id="recentFormActivityData"></span>
</div>
<script type="text/javascript">loadFormActivity('#attributes.siteid#');</script>
<cfset started=true>
</cfif>

<cfif application.settingsManager.getSite(session.siteid).getemailbroadcaster() and  application.permUtility.getModulePerm("00000000000000000000000000000000009","#session.siteid#")>
<span id="emailBroadcastsData">
<div id="emailBroadcasts"<cfif started> class="separate"</cfif>>

</div>
</span>
<script type="text/javascript">loadEmailActivity('#attributes.siteid#');</script>
<cfset started=true>
</cfif>
</cfoutput>
<cfset rsPluginScripts=application.pluginManager.getScripts("onDashboardPrimaryBottom",attributes.siteID)>
<cfoutput query="rsPluginScripts" group="pluginID">
<cfset rsPluginScript=application.pluginManager.getScripts("onDashboardPrimaryBottom",attributes.siteID,rsPluginScripts.moduleID)>
<div<cfif started> class="separate"</cfif>>
	<h3>#HTMLEditformat(rsPluginScripts.name)#</h3>
	<cfoutput>
	#application.pluginManager.renderScripts("onDashboardPrimaryBottom",attributes.siteid,pluginEvent,rsPluginScript)#
	</cfoutput>
</div>
<cfset started=true>
</cfoutput>
</div>
<!---- I there's nothing in the main body of the dashboard just move on the the site manager--->
<cfif not started>
<cflocation url="index.cfm?fuseaction=cArch.list&siteid=#session.siteID#&moduleid=00000000000000000000000000000000000&topid=00000000000000000000000000000000001" addtoken="false">
</cfif>
<cfoutput>
<div id="contentSecondary" class="sidebar">

<div id="editcontent">
<h3>#application.rbFactory.getKeyValue(session.rb,"dashboard.keywordsearch")#</h3>
<dl>
<dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.searchtext")#:</dt>
<dd><form novalidate="novalidate" id="siteSearch" name="siteSearch" method="get"><input name="keywords" value="#HTMLEditFormat(session.keywords)#" type="text" class="text" align="absmiddle" />  
	<input type="button" class="submit" onclick="submitForm(document.forms.siteSearch);" value="Search" />
	<input type="hidden" name="fuseaction" value="cArch.list">
	<input type="hidden" name="activetab" value="1">
	<input type="hidden" name="siteid" value="#HTMLEditFormat(attributes.siteid)#">
	<input type="hidden" name="moduleid" value="00000000000000000000000000000000000">
</form></dd>
</dl>
</div> 
</cfoutput>
<cfset rsPluginScripts=application.pluginManager.getScripts("onDashboardSidebarTop",attributes.siteID)>
<cfoutput query="rsPluginScripts" group="pluginID">
<cfset rsPluginScript=application.pluginManager.getScripts("onDashboardSidebarTop",attributes.siteID,rsPluginScripts.moduleID)>
<div class="divide">
	<h3>#HTMLEditformat(rsPluginScripts.name)#</h3>
	<cfoutput>
	#application.pluginManager.renderScripts("onDashboardSidebarTop",attributes.siteid,pluginEvent,rsPluginScript)#
	</cfoutput>
</div>
</cfoutput>
<cfoutput>
<div id="siteSummary" class="divide">
<h3>#application.rbFactory.getKeyValue(session.rb,"dashboard.sitesummary")#</h3>
<dl>
<dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.activepages")#</dt><dd>#application.dashboardManager.getcontentTypeCount(attributes.siteID,"Page").total#</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.files")#</dt><dd>#application.dashboardManager.getcontentTypeCount(attributes.siteID,"File").total#</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.links")#</dt><dd>#application.dashboardManager.getcontentTypeCount(attributes.siteID,"Link").total#</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.internalfeeds")#</dt><dd>#application.dashboardManager.getFeedTypeCount(attributes.siteID,"Local").total#</dd>
<cfif application.settingsManager.getSite(attributes.siteID).getExtranet() eq 1><dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.sitemembers")#</dt><dd>#application.dashboardManager.getTotalMembers(attributes.siteID)#</dd></cfif>
<dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.administrativeusers")#</dt><dd>#application.dashboardManager.getTotalAdministrators(attributes.siteID)#</dd>
</dl>
</div>

<div id="recentcontent" class="divide">
<h3>#application.rbFactory.getKeyValue(session.rb,"dashboard.recentcontent")#</h3>
<cfset rsList=application.dashboardManager.getRecentUpdates(attributes.siteID,5) />
<ul>
	<cfloop query="rslist">
	<cfset crumbdata=application.contentManager.getCrumbList(rslist.contentid, attributes.siteid)/>
	<cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
	<cfif verdict neq 'none'>
	<li><a title="Version History" href="index.cfm?fuseaction=cArch.hist&contentid=#rslist.ContentID#&type=#rslist.type#&parentid=#rslist.parentID#&topid=#rslist.contentID#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#rslist.moduleid#">#HTMLEditFormat(rsList.menuTitle)#</a> #application.rbFactory.getKeyValue(session.rb,"dashboard.by")# #HTMLEditFormat(rsList.lastUpdateBy)# (#LSDateFormat(rsList.lastUpdate,session.dateKeyFormat)#)</li>
	<cfelse><li>#HTMLEditFormat(rslist.menuTitle)# #application.rbFactory.getKeyValue(session.rb,"dashboard.by")# #HTMLEditFormat(rsList.lastUpdateBy)# (#LSDateFormat(rsList.lastUpdate,session.dateKeyFormat)#)</li>
	</cfif>
	</cfloop>
</ul>
</div>

<cfset rsList=application.dashboardManager.getDraftList(attributes.siteID,session.mura.userID,5) />
<div id="drafts" class="divide">
<h3>#application.rbFactory.getKeyValue(session.rb,"dashboard.draftsforreview")#</h3>
<ul><cfif rsList.recordcount>
	<cfloop query="rslist">
	<li><a title="Version History" href="index.cfm?fuseaction=cArch.hist&contentid=#rslist.ContentID#&type=#rslist.type#&parentid=#rslist.parentID#&topid=#rslist.contentID#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#rslist.moduleid#">#HTMLEditFormat(rsList.menuTitle)#</a> #application.rbFactory.getKeyValue(session.rb,"dashboard.by")# #HTMLEditFormat(rsList.lastUpdateBy)# (#LSDateFormat(rsList.lastUpdate,session.dateKeyFormat)#)</li>
	</cfloop>
	<cfelse>
	<li>#application.rbFactory.getKeyValue(session.rb,"dashboard.nodrafts")#</li>
	</cfif>
</ul>
</div>
</cfoutput>
<cfset rsPluginScripts=application.pluginManager.getScripts("onDashboardSidebarBottom",attributes.siteID)>
<cfoutput query="rsPluginScripts" group="pluginID">
<cfset rsPluginScript=application.pluginManager.getScripts("onDashboardSidebarBottom",attributes.siteID,rsPluginScripts.moduleID)>
<div class="divide">
	<h3>#HTMLEditformat(rsPluginScripts.name)#</h3>
	<cfoutput>
	#application.pluginManager.renderScripts("onDashboardSidebarBottom",attributes.siteid,pluginEvent,rsPluginScript)#
	</cfoutput>
</div>
</cfoutput>
</div></div>
