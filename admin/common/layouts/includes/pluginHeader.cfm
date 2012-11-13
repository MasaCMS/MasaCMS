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
<cfparam name="request.action" default="core:cplugin.plugin">
<cfparam name="rc.originalfuseaction" default="#listLast(listLast(request.action,":"),".")#">
<cfparam name="rc.originalcircuit"  default="#listFirst(listLast(request.action,":"),".")#">
<cfparam name="rc.moduleid" default="">
<cfif not application.configBean.getSessionHistory() or application.configBean.getSessionHistory() gte 30>
	<cfparam name="session.dashboardSpan" default="30">
<cfelse>
	<cfparam name="session.dashboardSpan" default="#application.configBean.getSessionHistory()#">
</cfif>
<cfoutput>
<cfparam name="Cookie.fetDisplay" default="">

<cfif not arguments.jsLibLoaded>
<cfif arguments.jsLib eq "jquery">
<script src="#application.configBean.getContext()#/#application.settingsmanager.getSite(session.siteid).getDisplayPoolID()#/js/jquery/jquery.js" type="text/javascript"></script>
<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery.collapsibleCheckboxTree.js?coreversion=#application.coreversion#" type="text/javascript"></script>
<cfelse>
<script src="#application.configBean.getContext()#/#application.settingsmanager.getSite(session.siteid).getDisplayPoolID()#/js/prototype.js" type="text/javascript"></script>
<script type="text/javascript" src="#application.configBean.getContext()#/#application.settingsmanager.getSite(session.siteid).getDisplayPoolID()#/js/scriptaculous/src/scriptaculous.js?load=effects"></script>
</cfif>
</cfif>
<script type="text/javascript" src="#application.configBean.getContext()#/admin/assets/js/admin.js"></script>
<link href="#application.configBean.getContext()#/admin/assets/css/admin.min.css" rel="stylesheet" type="text/css" />
<link href="#application.configBean.getContext()#/admin/assets/css/dialog.min.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">
function toggleAdminToolbar(){
	<cfif arguments.jslib eq "jquery">
		$("##frontEndTools").animate({opacity: "toggle"});
		<cfelse>Effect.toggle("frontEndTools", "appear");
	</cfif>
	}
</script>

	<img src="#application.configBean.getContext()#/admin/assets/images/logo_small_feTools.png" id="frontEndToolsHandle" onclick="if (document.getElementById('frontEndTools').style.display == 'none') { createCookie('FETDISPLAY','',5); } else { createCookie('FETDISPLAY','none',5); } toggleAdminToolbar();" />
	<div id="frontEndTools" class="pluginHdr" style="display: #Cookie.fetDisplay#">
			<ul>
				<li id="adminPlugIns"><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cPlugins.list&siteid=#session.siteid#"><i class="icon-cogs"></i> #application.rbFactory.getKeyValue(session.rb,"layout.plugins")#</a></li>
				<li id="adminSiteManager"><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cArch.list&siteid=#session.siteid#&moduleid=00000000000000000000000000000000000&topid=00000000000000000000000000000000001"><i class="icon-list-alt"></i> #application.rbFactory.getKeyValue(session.rb,"layout.sitemanager")#</a></li>
				<li id="adminDashboard"><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cDashboard.main&siteid=#session.siteid#&span=#session.dashboardSpan#"><i class="icon-dashboard"></i> #application.rbFactory.getKeyValue(session.rb,"layout.dashboard")#</a></li>
				<li id="adminLogOut"><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cLogin.logout"><i class="icon-signout"></i> #application.rbFactory.getKeyValue(session.rb,"layout.logout")#</a></li>
				<li id="adminWelcome">#application.rbFactory.getKeyValue(session.rb,"layout.welcome")#, #HTMLEditFormat("#session.mura.fname# #session.mura.lname#")#.</li>
			</ul>
		</div>
</cfoutput>