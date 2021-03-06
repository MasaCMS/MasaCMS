 <!--- 
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the  
same licensing model. It is, therefore, licensed under the Gnu General Public License 
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing 
notice set out below. That exception is also granted by the copyright holders of Masa CMS 
also applies to this file and Masa CMS in general. 

This file has been modified from the original version received from Mura CMS. The 
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright 
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained 
only to ensure software compatibility, and compliance with the terms of the GPLv2 and 
the exception set out below. That use is not intended to suggest any commercial relationship 
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa. 

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com  

Masa CMS is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, Version 2 of the License. 
Masa CMS is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>. 

The original complete licensing notice from the Mura CMS version of this file is as 
follows: 

This file is part of Mura CMS.

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
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfset event=request.event>
<cfinclude template="js.cfm">
<cfset started=false>
<cfparam name="application.sessionTrackingThrottle" default="false">
<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>
<cfset dashboardReplacemanent=$.renderEvent('onDashboardReplacement')>

<cfif len(dashboardReplacemanent)>
	<cfoutput>#dashboardReplacemanent#</cfoutput>
<cfelse>
	<cfinclude template="act_defaults.cfm"/>
	<cfoutput>

<div class="mura-header">
	<h1>#application.rbFactory.getKeyValue(session.rb,"dashboard.dashboard")#</h1>

	<cfinclude template="dsp_secondary_menu.cfm">

</div> <!-- /.mura-header -->

<div class="block block-constrain">
		<div class="block block-bordered">
		  <div class="block-content">

			<div id="main">

			<cfset eventMappings=$.getBean('pluginManager').getEventMappings('onDashboardPrimaryTop',rc.siteid)>
			<cfif arrayLen(eventMappings)>
				<cfloop from="1" to="#arrayLen(eventMappings)#"	index="i">
					<cfset renderedEvent=$.renderEvent(eventName='onDashboardPrimaryTop',index=i)>
					<cfif len(trim(renderedEvent))>
						<div<cfif started> class="divide"</cfif>>
							<h2><i class="mi-cog"></i> #esapiEncode('html',eventMappings[i].pluginName)#</h2>
							#renderedEvent#
						</div>
						<cfset started=true>
					</cfif>
				</cfloop>
			</cfif>

			<cfif application.configBean.getSessionHistory() >	
			<cfif not application.sessionTrackingThrottle>
			<div id="userActivity"<cfif started> class="divide"</cfif>>
			<h2><i class="mi-group"></i> #application.rbFactory.getKeyValue(session.rb,"dashboard.useractivity")# <span><a href="./?muraAction=cDashboard.sessionSearch&siteid=#esapiEncode('url',rc.siteid)#&newSearch=true">(#application.rbFactory.getKeyValue(session.rb,"dashboard.advancedsessionsearch")#)</a></span></h2>
			<span id="userActivityData"></span>
			</div>
			<script type="text/javascript">dashboardManager.loadUserActivity('#esapiEncode('javascript',rc.siteid)#');</script>
			<cfset started=true>

			<div id="popularContent"<cfif started> class="divide"</cfif>>
			<h2><i class="mi-thumbs-up"></i> #application.rbFactory.getKeyValue(session.rb,"dashboard.popularcontent")# <span>(#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.span"),rc.span)#)</span></h2>
			<span id="popularContentData"></span>
			</div>
			<script type="text/javascript">dashboardManager.loadPopularContent('#esapiEncode('javascript',rc.siteid)#');</script>
			<cfset started=true>
			<cfelse>
			<div id="userActivity"<cfif started> class="divide"</cfif>>
			<h2>#application.rbFactory.getKeyValue(session.rb,"dashboard.useractivity")#</h2>
			<p>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.trackingthrottled")# </p>
			</div>
			<cfset started=true>
			</cfif>
			</cfif>

			<cfif yesNoFormat(application.configBean.getDashboardComments()) and application.settingsManager.getSite(session.siteid).getHasComments() 
				and application.permUtility.getModulePerm('00000000000000000000000000000000015',rc.siteid)
				and application.contentManager.getRecentCommentsQuery(session.siteID,1,false).recordCount>
			<div id="recentComments"<cfif started> class="divide"</cfif>>
			<h2><i class="mi-comments"></i> #application.rbFactory.getKeyValue(session.rb,"dashboard.comments")# <span><a href="?muraAction=cComments.default&siteID=#session.siteID#">(#application.rbFactory.getKeyValue(session.rb,"dashboard.viewall")#)</a></span></h2>
			<span id="recentCommentsData"></span>
			</div>
			<script type="text/javascript">dashboardManager.loadRecentComments('#esapiEncode('javascript',rc.siteid)#');</script>
			<cfset started=true>
			</cfif>

			<cfif application.settingsManager.getSite(session.siteid).getdatacollection() and  application.permUtility.getModulePerm("00000000000000000000000000000000004","#session.siteid#")>
			<div id="recentFormActivity"<cfif started> class="divide"</cfif>>
			<h2><i class="mi-list-alt"></i> #application.rbFactory.getKeyValue(session.rb,"dashboard.formactivity")#</h2>
			<span id="recentFormActivityData"></span>
			</div>
			<script type="text/javascript">dashboardManager.loadFormActivity('#esapiEncode('javascript',rc.siteid)#');</script>
			<cfset started=true>
			</cfif>

			<cfif application.settingsManager.getSite(session.siteid).getemailbroadcaster() and  application.permUtility.getModulePerm("00000000000000000000000000000000009","#session.siteid#")>

			<div id="emailBroadcasts" class="divide">
			<span id="emailBroadcastsData"></span>
			</div>

			<script type="text/javascript">dashboardManager.loadEmailActivity('#esapiEncode('javascript',rc.siteid)#');</script>
			<cfset started=true>
			</cfif>

			<cfif arrayLen(eventMappings)>
				<cfloop from="1" to="#arrayLen(eventMappings)#"	index="i">
					<cfset renderedEvent=$.renderEvent(eventName='onDashboardPrimaryBottom',index=i)>
					<cfif len(trim(renderedEvent))>
						<div<cfif started> class="divide"</cfif>>
							<h2><i class="mi-cog"></i> #esapiEncode('html',eventMappings[i].pluginName)#</h2>
							#renderedEvent#
						</div>
						<cfset started=true>
					</cfif>
				</cfloop>
			</cfif>

			</div>
			<!---- If there's nothing in the main body of the dashboard just move on the the site manager--->
			<!--- <cfif not started>
				<cflocation url="./?muraAction=cArch.list&siteid=#session.siteID#&moduleid=00000000000000000000000000000000000&topid=00000000000000000000000000000000001" addtoken="false">
			</cfif> --->

			<div id="contentSecondary" class="sidebar">

			<cfset eventMappings=$.getBean('pluginManager').getEventMappings('onDashboardSideBarTop',rc.siteid)>
			<cfif arrayLen(eventMappings)>
				<cfloop from="1" to="#arrayLen(eventMappings)#"	index="i">
					<cfset renderedEvent=$.renderEvent(eventName='onDashboardSideBarTop',index=i)>
					<cfif len(trim(renderedEvent))>
						<div class="divide">
							<h2><i class="mi-cog"></i> #esapiEncode('html',eventMappings[i].pluginName)#</h2>
							#renderedEvent#
						</div>
					</cfif>
				</cfloop>
			</cfif>

			<div id="siteSummary" class="well">
			<h2>#application.rbFactory.getKeyValue(session.rb,"dashboard.sitesummary")#</h2>
			<dl>
				<dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.activepages")#</dt>
				<dd><span class="badge">#application.dashboardManager.getcontentTypeCount(rc.siteID,"Page").total#</span></dd>
				<dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.files")#</dt>
				<dd><span class="badge">#application.dashboardManager.getcontentTypeCount(rc.siteID,"File").total#</span></dd>
				<dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.links")#</dt>
				<dd><span class="badge">#application.dashboardManager.getcontentTypeCount(rc.siteID,"Link").total#</span></dd>
				<dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.internalfeeds")#</dt>
				<dd><span class="badge">#application.dashboardManager.getFeedTypeCount(rc.siteID,"Local").total#</span></dd>
				<cfif application.settingsManager.getSite(rc.siteID).getExtranet() eq 1><dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.sitemembers")#</dt>
				<dd><span class="badge">#application.dashboardManager.getTotalMembers(rc.siteID)#</span></dd></cfif>
				<dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.administrativeusers")#</dt>
				<dd><span class="badge">#application.dashboardManager.getTotalAdministrators(rc.siteID)#</span></dd>
			</dl>
			</div>

			<div id="recentcontent" class="well">
			<h2>#application.rbFactory.getKeyValue(session.rb,"dashboard.recentcontent")#</h2>
			<cfset rsList=application.dashboardManager.getRecentUpdates(rc.siteID,5) />
			<ul>
				<cfloop query="rslist">
				<cfset crumbdata=application.contentManager.getCrumbList(rslist.contentid, rc.siteid)/>
				<cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
				<cfif verdict neq 'none'>
				<li><a title="Version History" href="./?muraAction=cArch.hist&contentid=#rslist.ContentID#&type=#rslist.type#&parentid=#rslist.parentID#&topid=#rslist.contentID#&siteid=#esapiEncode('url',rc.siteid)#&moduleid=#rslist.moduleid#">#esapiEncode('html',rsList.menuTitle)#</a> #application.rbFactory.getKeyValue(session.rb,"dashboard.by")# #esapiEncode('html',rsList.lastUpdateBy)# <span>(#LSDateFormat(rsList.lastUpdate,session.dateKeyFormat)#)</span></li>
				<cfelse><li>#esapiEncode('html',rslist.menuTitle)# #application.rbFactory.getKeyValue(session.rb,"dashboard.by")# #esapiEncode('html',rsList.lastUpdateBy)# <span>(#LSDateFormat(rsList.lastUpdate,session.dateKeyFormat)#)</span></li>
				</cfif>
				</cfloop>
			</ul>
			</div>

			<cfset eventMappings=$.getBean('pluginManager').getEventMappings('onDashboardSideBarBottom',rc.siteid)>
			<cfif arrayLen(eventMappings)>
				<cfloop from="1" to="#arrayLen(eventMappings)#"	index="i">
					<cfset renderedEvent=$.renderEvent(eventName='onDashboardSideBarBottom',index=i)>
					<cfif len(trim(renderedEvent))>
						<div class="divide">
							<h2><i class="mi-cog"></i> #esapiEncode('html',eventMappings[i].pluginName)#</h2>
							#renderedEvent#
						</div>
					</cfif>
				</cfloop>
			</cfif>
			</div> <!-- ./sidebar -->

			<div class="clearfix"></div>
		</div> <!-- /.block-content -->
	</div> <!-- /.block-bordered -->
</div> <!-- /.block-constrain -->

	</cfoutput>
</cfif>
