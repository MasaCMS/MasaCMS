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
<cfparam name="request.action" default="core:cplugin.plugin">
<cfparam name="rc.originalfuseaction" default="#listLast(listLast(request.action,":"),".")#">
<cfparam name="rc.originalcircuit"  default="#listFirst(listLast(request.action,":"),".")#">
<cfparam name="rc.moduleid" default="">
<cfif not application.configBean.getSessionHistory() or application.configBean.getSessionHistory() gte 180>
	<cfparam name="session.dashboardSpan" default="30">
<cfelse>
	<cfparam name="session.dashboardSpan" default="#application.configBean.getSessionHistory()#">
</cfif>
<cfoutput>
<cfparam name="Cookie.fetDisplay" default="">

<cfif not arguments.jsLibLoaded>
<cfif arguments.jsLib eq "jquery">
<script src="#application.configBean.getContext()#/#application.settingsmanager.getSite(session.siteid).getDisplayPoolID()#/js/jquery/jquery.js" type="text/javascript"></script>
<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/jquery/jquery.collapsibleCheckboxTree.js?coreversion=#application.coreversion#" type="text/javascript"></script>
<cfelse>
<script src="#application.configBean.getContext()#/#application.settingsmanager.getSite(session.siteid).getDisplayPoolID()#/js/prototype.js" type="text/javascript"></script>
<script type="text/javascript" src="#application.configBean.getContext()#/#application.settingsmanager.getSite(session.siteid).getDisplayPoolID()#/js/scriptaculous/src/scriptaculous.js?load=effects"></script>
</cfif>
</cfif>
<!-- JSON -->
<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/json2.js" type="text/javascript"></script>
<script type="text/javascript" src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/admin.min.js"></script>
<link href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/css/admin.min.css" rel="stylesheet" type="text/css" />
<link href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/css/admin-frontend.min.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">
function toggleAdminToolbar(){
	<cfif arguments.jslib eq "jquery">
		$("##frontEndTools").animate({opacity: "toggle"});
		<cfelse>Effect.toggle("frontEndTools", "appear");
	</cfif>
	}
</script>

	<img src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/images/masa-logo-fe@2x.png" id="frontEndToolsHandle" onclick="if (document.getElementById('frontEndTools').style.display == 'none') { createCookie('FETDISPLAY','',5); } else { createCookie('FETDISPLAY','none',5); } toggleAdminToolbar();" />
	<div id="frontEndTools" class="pluginHdr" style="display: #Cookie.fetDisplay#">
			<ul>
				<li id="adminPlugIns"><a href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cPlugins.list&siteid=#session.siteid#"><i class="mi-cogs"></i> #rc.$.rbKey("layout.plugins")#</a></li>
				<li id="adminSiteManager"><a href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cArch.list&siteid=#session.siteid#&moduleid=00000000000000000000000000000000000&topid=00000000000000000000000000000000001"><i class="mi-sitemap"></i> #rc.$.rbKey("layout.sitemanager")#</a></li>
				<li id="adminDashboard"><a href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cDashboard.main&siteid=#session.siteid#&span=#session.dashboardSpan#"><i class="mi-dashboard"></i> #rc.$.rbKey("layout.dashboard")#</a></li>
				<li id="adminLogOut"><a href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cLogin.logout"><i class="mi-sign-out"></i> #rc.$.rbKey("layout.logout")#</a></li>
				<li id="adminWelcome">#rc.$.rbKey("layout.welcome")#, #esapiEncode("html","#session.mura.fname# #session.mura.lname#")#.</li>
			</ul>
		</div>
</cfoutput>