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
<cfsilent>
<cfparam name="attributes.jsLib" default="prototype">
<cfparam name="attributes.jsLibLoaded" default="false">
<cfparam name="attributes.activetab" default="0">
<cfparam name="attributes.activepanel" default="0">
<cfparam name="attributes.siteid" default="#session.siteID#">
<cfparam name="attributes.frontEndProxyLoc" default="">
<cfparam name="session.frontEndProxyLoc" default="#attributes.frontEndProxyLoc#">

<cfif len(attributes.frontEndProxyLoc)>
	<cfset session.frontEndProxyLoc=attributes.frontEndProxyLoc>
</cfif>
</cfsilent>
<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>#application.configBean.getTitle()#</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate">
<cfheader name="expires" value="06 Nov 1994 08:37:34 GMT">
<meta http-equiv="cache control" content="no-cache, no-store, must-revalidate" />
<script src="#application.configBean.getContext()#/admin/js/admin.min.js" type="text/javascript" language="Javascript"></script>
<script src="#application.configBean.getContext()#/admin/js/jquery/jquery.js?coreversion=#application.coreversion#" type="text/javascript"></script>
<script src="#application.configBean.getContext()#/admin/js/jquery/jquery.collapsibleCheckboxTree.js?coreversion=#application.coreversion#" type="text/javascript"></script>
<script src="#application.configBean.getContext()#/admin/js/jquery/jquery-ui.js?coreversion=#application.coreversion#" type="text/javascript"></script>
<script src="#application.configBean.getContext()#/admin/js/jquery/jquery-ui-i18n.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>
<link href="#application.configBean.getContext()#/admin/css/jquery/default/jquery.ui.all.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
<script src="#application.configBean.getContext()#/admin/js/jquery/jquery-resize.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>
<cfif not attributes.jsLibLoaded and attributes.jsLib eq "prototype">
<script src="#application.configBean.getContext()#/admin/js/prototype.js" type="text/javascript" language="Javascript"></script>
</cfif>
<cfif application.configBean.getValue("htmlEditorType") eq "fckeditor">
<script type="text/javascript" src="#application.configBean.getContext()#/wysiwyg/fckeditor.js"></script>
<cfelse>
<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/ckeditor/adapters/jquery.js"></script>
<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/ckfinder/ckfinder.js"></script>
</cfif>
<script src="#application.configBean.getContext()#/admin/js/json2.js" type="text/javascript" language="Javascript"></script>
<script src="#application.configBean.getContext()#/admin/js/porthole/porthole.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>
<script type="text/javascript">
var htmlEditorType='#application.configBean.getValue("htmlEditorType")#';
var context='#application.configBean.getContext()#';
var themepath='#application.settingsManager.getSite(attributes.siteID).getThemeAssetPath()#';
var rb='#lcase(session.rb)#';
var siteid='#session.siteid#';
</script>
<style type="text/css"> html { overflow:hidden; } </style>
#session.dateKey#
<script type="text/javascript">
	var frontEndProxy;
	
	jQuery(document).ready(
		function(){
			setDatePickers(".datepicker",dtLocale);
			setTabs(".tabs",#attributes.activeTab#);
			setHTMLEditors();
			setAccordions(".accordion",#attributes.activePanel#);
			setCheckboxTrees();
			if (top.location != self.location) {
				frontEndProxy = new Porthole.WindowProxy("#session.frontEndProxyLoc##application.configBean.getContext()#/admin/js/porthole/proxy.html");
				frontEndProxy.postMessage("cmd=resizeFrontEndToolsModal&frameHeight=" + Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight));
				jQuery(this).resize(function(e){
					frontEndProxy.postMessage("cmd=resizeFrontEndToolsModal&frameHeight=" + Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight));
				});
					
									
			}	
		}
	);
</script>
	#fusebox.ajax#
	<link href="#application.configBean.getContext()#/admin/css/admin.min.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
	<!--[if IE]>
	<link href="#application.configBean.getContext()#/admin/css/ie.min.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
	<![endif]-->
		<!--[if IE 6]>
	<link href="#application.configBean.getContext()#/admin/css/ie6.cs?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
	<![endif]-->
	<!---<cfif myfusebox.originalcircuit eq "cArch" and (myfusebox.originalfuseaction eq "list" or myfusebox.originalfuseaction eq "search") and (attributes.moduleid eq '00000000000000000000000000000000000' or attributes.moduleid eq '')>
	<cfinclude template="../../view/vArchitecture/dsp_content_nav.cfm">
	</cfif>--->
	<cfinclude template="dialog.cfm">
	</head>
	<body id="#myfusebox.originalcircuit#" class="compact">
	<!---<cfinclude template="header.cfm">--->
	<div id="container">
		<!---<div id="navigation" class="sidebar">
			<cfset hidelist="cLogin">
			<!---<cfif not listfind(hidelist,myfusebox.originalcircuit)><cfinclude template="dsp_secondary_menu_main.cfm"></cfif>--->
			<!---<p id="blueriver"><img src="images/blueriver.gif" border="0" /></p>--->
			<p id="copyright">
				<cfif application.configBean.getMode() eq 'Staging' and session.siteid neq '' and not listfind(hidelist,myfusebox.originalcircuit)>
					Last Deployment:<br/>
					#LSDateFormat(application.settingsManager.getSite(session.siteid).getLastDeployment(),session.dateKeyFormat)# #LSTimeFormat(application.settingsManager.getSite(session.siteid).getLastDeployment())# 					<br />
					<br />
					<br />
				</cfif>
				Version #application.configBean.getVersion()# </p>
		</div>--->
		<div id="content">#fusebox.layout# </div>
	</div>
	<cfif myfusebox.originalcircuit neq 'cLogin' and myfusebox.originalcircuit neq 'cFilemanager'>
		<script type="text/javascript" language="javascript">
			if(document.forms[2] != undefined && !document.forms[2].elements[0].disabled && document.forms[2].elements[0].focus){
			document.forms[2].elements[0].focus();
			}
		</script>
	<cfelseif  myfusebox.originalcircuit neq 'cFilemanager'>
		<script type="text/javascript" language="javascript">
			document.forms[0].elements[0].focus();
		</script>
	</cfif>
	<script type="text/javascript" language="javascript">
		stripe('stripe');
	</script>
	</body>
	</html>
</cfoutput>