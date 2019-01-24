<!---
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

<cfsilent>
	<cfparam name="rc.originalfuseAction" default="">
	<cfparam name="rc.originalcircuit" default="">
	<cfparam name="rc.moduleid" default="">
	<cfif not application.configBean.getSessionHistory() or application.configBean.getSessionHistory() gte 180>
		<cfparam name="session.dashboardSpan" default="30">
	<cfelse>
		<cfparam name="session.dashboardSpan" default="#application.configBean.getSessionHistory()#">
	</cfif>
	<cfif not isDefined("session.mura.memberships")>
	  <cflocation url="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cLogin.logout" addtoken="false">
	</cfif>
	<cfset rc.siteBean=application.settingsManager.getSite(session.siteID)>
	<cfset rc.currentUser=rc.$.currentUser()>
	<cfset theSiteList=application.settingsManager.getUserSites(session.siteArray,listFind(session.mura.memberships,'S2')) />
</cfsilent>
<cfoutput>

<header id="header-navbar" class="content-mini content-mini-full">

  <!-- Header Navigation Left -->
  <ul class="nav-header pull-left">
	   <!-- toggle sidebar -->
	   <li class="hidden-xs hidden-sm">
	      <!-- Layout API, functionality initialized in App() -> uiLayoutApi() -->
	      <button id="mura-sidebar-toggle" class="btn btn-default" data-toggle="layout" data-action="sidebar_mini_toggle" type="button">
	          <i class="mi-navicon"></i>
	      </button>

	      <button id="mura-sidebar-toggle-open" class="btn btn-default" data-toggle="layout" data-action="sidebar_mini_toggle" type="button">
	          <i class="mi-navicon"></i>
	      </button>
	  </li>

	  <li class="hidden-md hidden-lg">
	      <!-- Layout API, functionality initialized in App() -> uiLayoutApi() -->
	      <button class="btn btn-default" data-toggle="layout" data-action="sidebar_toggle" type="button">
	          <i class="mi-navicon"></i>
	      </button>
	  </li>

    <!--- site selector  --->
    <li id="site-selector">
      <div class="btn-group">
     		<a id="select-site-btn" class="btn btn-default" href="#rc.$.createHref(filename='',complete=1)#" target="_blank"><i class="mi-globe"></i> #esapiEncode('html', application.settingsManager.getSite(session.siteid).getSite())#</a>
        <button type="button" class="btn btn-default dropdown-toggle" id="site-selector-trigger" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          <span class="caret"></span>
        </button>
        <ul  id="site-selector-list" class="dropdown-menu">
				<cfif theSiteList.recordCount gt 10>
					<div class="ui-widget">
						<input name="site-list-filter" id="site-list-filter" class="form-control input-sm" type="text" placeholder="#rc.$.rbKey("dashboard.search")#...">
					</div>
				</cfif>
				<cfset settingsManager=rc.$.getBean('settingsManager')>
				<cfloop query="theSiteList" startrow="1" endrow="100">
					<cfsilent>
						<cfif settingsManager.getSite(theSiteList.siteID).getValue(property='showDashboard',defaultValue=0)>
							<cfset baseURL="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cDashboard.main">
						<cfelse>
							<cfset baseURL="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cArch.list&amp;moduleID=00000000000000000000000000000000000&amp;topID=00000000000000000000000000000000001">
						</cfif>
					</cfsilent>
          			<li<cfif session.siteID eq theSiteList.siteID> class="active"</cfif>>
						<a href="#baseURL#&amp;siteID=#theSiteList.siteID#"><i class="mi-globe"></i> #esapiEncode('html',theSiteList.site)#</a>
        			</li>
				</cfloop>
        </ul>
      </div>
    </li>

  </ul>
  <!-- END Header Navigation Left -->

  <!-- Header Navigation Right -->
  <ul class="nav-header pull-right">
      <li class="visible-xs">
          <!-- Toggle class helper (for .js-header-search below), functionality initialized in App() -> uiToggleClass() -->
          <button class="btn btn-default" data-toggle="class-toggle" data-target=".js-header-search" data-class="header-search-xs-visible" type="button">
              <i class="mi-search"></i>
          </button>
      </li>
			<!--- header search --->
      <li class="js-header-search header-search">
				<form class="form-horizontal" action="##" novalidate="novalidate" id="globalSearch" name="globalSearch" method="get">
          <div class="form-material form-material-primary input-group remove-margin-t remove-margin-b">
              <input class="form-control" type="text" id="mura-search-keywords" name="keywords" value="#esapiEncode('html_attr',session.keywords)#" placeholder="#rc.$.rbKey('dashboard.search')#">
              <span onclick="submitForm(document.forms.globalSearch);" class="input-group-addon" id="mura-search-submit"><i class="mi-search"></i></span>
          </div>
					<input type="hidden" name="muraAction" value="cArch.list">
					<input type="hidden" name="activetab" value="1">
					<input type="hidden" name="siteid" value="#esapiEncode('html_attr',rc.siteid)#">
					<input type="hidden" name="moduleid" value="00000000000000000000000000000000000">
				</form>
				<!--- /end header search --->
      </li>

      <!--- admin user tools --->
      <cfparam name="local.prompttally" default="0">
      <cfsavecontent variable="local.userprompt">

				<!--- drafts --->
				<cfset local.promptcount=$.getBean('contentManager').getMyDraftsCount(siteid=session.siteid,startdate=dateAdd('m',-3,now()))>
				<cfif local.promptcount>
					<cfset local.prompttally += local.promptcount>
					<li>
					 	<a href="./?muraAction=cArch.list&moduleid=00000000000000000000000000000000000&activeTab=1&report=mydrafts&siteID=#session.siteid#&reportSortby=lastupdate&reportSortDirection=desc&refreshFlatview=true"><span class="badge">#local.promptcount#</span> Drafts</a>
					</li>
				</cfif>
				<!--- /drafts --->

				<!--- submissions --->
				<cfset local.promptcount=$.getBean('contentManager').getMySubmissionsCount(session.siteid)>
				<cfif local.promptcount>
					<cfset local.prompttally += local.promptcount>
					<li>
					 <a href="./?muraAction=cArch.list&moduleid=00000000000000000000000000000000000&activeTab=1&report=mysubmissions&siteID=#session.siteid#&reportSortby=duedate&reportSortDirection=desc&refreshFlatview=true"><span class="badge">#local.promptcount#</span> Submissions</a>
					</li>
				</cfif>
				<!--- /submissions --->

				<!--- approvals --->
				<cfset local.promptcount=$.getBean('contentManager').getMyApprovalsCount(session.siteid)>
				<cfif local.promptcount>
					<cfset local.prompttally += local.promptcount>
					<li>
					 <a href="./?muraAction=cArch.list&moduleid=00000000000000000000000000000000000&activeTab=1&report=myapprovals&siteID=#session.siteid#&reportSortby=duedate&reportSortDirection=desc&refreshFlatview=true"><span class="badge">#local.promptcount#</span> Approvals </a>
					</li>
				</cfif>
				<!--- /approvals --->

				<!--- expiring --->
				<cfset local.promptcount=$.getBean('contentManager').getMyExpiresCount(session.siteid)>
				<cfif local.promptcount>
					<cfset local.prompttally += local.promptcount>
					<li>
					 <a href="./?muraAction=cArch.list&moduleid=00000000000000000000000000000000000&activeTab=1&report=myexpires&siteID=#session.siteid#&reportSortby=duedate&reportSortDirection=desc&refreshFlatview=true"><span class="badge">#local.promptcount#</span> Expiring</a>
					</li>
				</cfif>
				<!--- /expiring --->

				<!--- changesets --->
				 <cfif $.siteConfig('hasChangesets')
					 and application.permUtility.getModulePerm('00000000000000000000000000000000014',rc.siteid)
					 and application.permUtility.getModulePerm('00000000000000000000000000000000000',rc.siteid)>

					 <cfset rsChangesets=application.changesetManager.getQuery(siteID=$.event('siteID'),published=0,sortby="PublishDate")>

					 <cfset queryAddColumn(rsChangesets, "pending", 'integer', [])>

					 <cfloop query="rsChangesets">
						 <cfset querySetCell(rsChangesets, "pending", $.getBean('changesetManager').hasPendingApprovals(rsChangesets.changesetid), rsChangesets.currentrow)>
					 </cfloop>

					 <cfset  totalpending="">

					 <cfquery name="totalpending" dbtype="query">
						 select sum(pending) as totalpending from rsChangesets
					 </cfquery>

					 <cfif rsChangesets.recordcount and totalpending.totalpending>
						<cfset local.prompttally += totalpending.totalpending>
					 	<li>
						   <a href="./?muraAction=cChangesets.list&siteid=#session.siteid#"><span class="badge">#totalpending.totalpending#</span> Changesets</a>
						</li>
					 </cfif>
				 </cfif>
				<!--- /changesets --->
			</cfsavecontent>
			<!--- /local.userprompt --->

      <li id="user-tools-selector">
          <div class="btn-group">

            <a tabindex="-1" class="btn btn-default" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cEditProfile.edit"> <i class="mi-user"></i> #esapiEncode("html","#session.mura.fname# #session.mura.lname#")#</a>

              <button type="button" class="btn btn-default dropdown-toggle" id="site-selector-trigger" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <cfif local.prompttally> <span class="badge">#local.prompttally#</span></cfif><span class="caret"></span>
              </button>

              <ul class="dropdown-menu dropdown-menu-right mura-user-tools">
                  <!--- output user prompts --->
                  <cfif local.prompttally>
	                  #local.userprompt#
	                  <li class="divider"></li>
									</cfif>

                  <li>
                      <a tabindex="-1" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cEditProfile.edit"><i class="mi-cog"></i> #rc.$.rbKey('layout.editprofile')#</a>
                  </li>
                  <li>
                      <a tabindex="-1" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cLogin.logout"><i class="mi-sign-out"></i> #rc.$.rbKey("layout.logout")#</a>
                  </li>


              </ul>
          </div>
      </li>
      <!--- /admin user tools --->

  </ul>
  <!-- END Header Navigation Right -->
</header>
</cfoutput>
