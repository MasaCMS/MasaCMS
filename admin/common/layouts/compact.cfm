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
<cfparam name="request.action" default="core:cplugin.plugin">
<cfparam name="rc.originalfuseaction" default="#listLast(listLast(request.action,":"),".")#">
<cfparam name="rc.originalcircuit"  default="#listFirst(listLast(request.action,":"),".")#">
<cfparam name="rc.jsLib" default="jquery">
<cfparam name="rc.jsLibLoaded" default="false">
<cfparam name="rc.activetab" default="0">
<cfparam name="rc.activepanel" default="0">
<cfparam name="rc.siteid" default="#session.siteID#">
<cfparam name="rc.frontEndProxyLoc" default="">
<cfparam name="session.frontEndProxyLoc" default="#rc.frontEndProxyLoc#">

<cfif len(rc.frontEndProxyLoc)>
	<cfset session.frontEndProxyLoc=rc.frontEndProxyLoc>
</cfif>

<cfif not structKeyExists(rc,"$")>
	<cfset rc.$=application.serviceFactory.getBean('$').init(session.siteid)>
</cfif> 
</cfsilent>
<cfoutput>
<!DOCTYPE html>
<cfif cgi.http_user_agent contains 'msie'>
<meta content="IE=8; IE=9" http-equiv="X-UA-Compatible" />
<!--[if lt IE 7 ]><html class="mura ie ie6" lang="#HTMLEditFormat(session.locale)#"> <![endif]-->
<!--[if IE 7 ]><html class="mura ie ie7" lang="#HTMLEditFormat(session.locale)#"> <![endif]-->
<!--[if IE 8 ]><html class="mura ie ie8" lang="#HTMLEditFormat(session.locale)#"> <![endif]-->
<!--[if (gte IE 9)|!(IE)]><!--><html lang="#HTMLEditFormat(session.locale)#" class="mura ie"><!--<![endif]-->
<cfelse>
<html lang="#HTMLEditFormat(session.locale)#" class="mura">
</cfif>
	<head>
		<title>#application.configBean.getTitle()#</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta name="description" content="">
		<meta name="author" content="">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="robots" content="noindex, nofollow, noarchive" />
		<meta http-equiv="cache control" content="no-cache, no-store, must-revalidate" />

		<!--- <link href="#application.configBean.getContext()#/admin/assets/bootstrap/css/bootstrap.min.css" rel="stylesheet">
		<link href="#application.configBean.getContext()#/admin/assets/bootstrap/css/bootstrap-responsive.min.css" rel="stylesheet"> --->

		<!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
		<!--[if lt IE 9]>
		   <script src="#application.configBean.getContext()#/admin/assets/js/html5.js"></script>
		<![endif]-->

		<!-- Le fav and touch icons -->
		<link rel="shortcut icon" href="#application.configBean.getContext()#/admin/assets/ico/favicon.ico">
		<link rel="apple-touch-icon-precomposed" sizes="144x144" href="#application.configBean.getContext()#/admin/assets/ico/apple-touch-icon-144-precomposed.png">
		<link rel="apple-touch-icon-precomposed" sizes="114x114" href="#application.configBean.getContext()#/admin/assets/ico/apple-touch-icon-114-precomposed.png">
		<link rel="apple-touch-icon-precomposed" sizes="72x72" href="#application.configBean.getContext()#/admin/assets/ico/apple-touch-icon-72-precomposed.png">
		<link rel="apple-touch-icon-precomposed" href="#application.configBean.getContext()#/admin/assets/ico/apple-touch-icon-57-precomposed.png">

		 <!-- Spinner JS -->
		<script src="#application.configBean.getContext()#/admin/assets/js/spin.min.js" type="text/javascript"></script>

		<!-- Mura Admin JS -->
		<script src="#application.configBean.getContext()#/admin/assets/js/admin.min.js" type="text/javascript"></script>

		 <!-- jQuery -->
		<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery.js?coreversion=#application.coreversion#" type="text/javascript"></script>
		<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery.spin.js" type="text/javascript"></script>
		<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery.collapsibleCheckboxTree.js?coreversion=#application.coreversion#" type="text/javascript"></script>
		<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery-ui.js?coreversion=#application.coreversion#" type="text/javascript"></script>
		<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery-ui-i18n.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>
		
		<!-- CK Editor/Finder -->
		<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/ckeditor/ckeditor.js"></script>
		<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/ckeditor/adapters/jquery.js"></script>
		<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/ckfinder/ckfinder.js"></script>

		<!-- Color Picker -->
		<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/colorpicker/js/bootstrap-colorpicker.js?coreversion=#application.coreversion#"></script>
		<link href="#application.configBean.getContext()#/tasks/widgets/colorpicker/css/colorpicker.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />

		<!-- JSON -->
		<script src="#application.configBean.getContext()#/admin/assets/js/json2.js" type="text/javascript"></script>

		<!-- Utilities to support iframe communication -->
		<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery-resize.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>
		<script src="#application.configBean.getContext()#/admin/assets/js/porthole/porthole.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>

		<script type="text/javascript">
		var htmlEditorType='#application.configBean.getValue("htmlEditorType")#';
		var context='#application.configBean.getContext()#';
		var themepath='#application.settingsManager.getSite(rc.siteID).getThemeAssetPath()#';
		var rb='#lcase(session.rb)#';
		var siteid='#session.siteid#';
		</script>
		
		<link href="#application.configBean.getContext()#/admin/assets/css/admin.min.css" rel="stylesheet" type="text/css" />
		#session.dateKey#
		<script type="text/javascript">
			var frontEndProxy;
			jQuery(document).ready(function(){
				setDatePickers(".datepicker",dtLocale);
				setTabs(".tabs",#rc.activeTab#);
				setHTMLEditors();
				setAccordions(".accordion",#rc.activePanel#);
				setCheckboxTrees();
				setColorPickers(".colorpicker");
				setToolTips(".container");

				if (top.location != self.location) {
					frontEndProxy = new Porthole.WindowProxy("#session.frontEndProxyLoc##application.configBean.getContext()#/admin/assets/js/porthole/proxy.html");
					frontEndProxy.post({cmd:
											'setHeight',
											height:Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight)
										});
					jQuery(this).resize(function(e){
						frontEndProxy.post({cmd:
											'setHeight',
											height:Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight)
										});
					});					
				};
			});

			preloadimages(['#application.configBean.getContext()#/admin/assets/images/ajax-loader.gif'])
		</script>
		#rc.ajax#
		
		<cfif cgi.http_user_agent contains 'msie'>
		<!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
	    <!--[if lt IE 9]>
	      <script src="#application.configBean.getContext()#/admin/assets/js/html5.js"></script>
	    <![endif]-->
		
		<!--[if lte IE 8]>
		<link href="#application.configBean.getContext()#/admin/assets/css/ie/ie.min.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
		<![endif]-->
		
		<!--[if lte IE 7]>
		<script src="#application.configBean.getContext()#/admin/assets/js/upgrade-notification.min.js" type="text/javascript"></script>
		<link rel="stylesheet" href="#application.configBean.getContext()#/admin/assets/css/font-awesome-ie7.css">
		<script src="#application.configBean.getContext()#/admin/assets/js/mura-font-lte-ie7.js" type="text/javascript"></script>
		<![endif]-->
		</cfif>
		
	</head>
	<body id="#rc.originalcircuit#" class="compact">
		<cfinclude template="includes/dialog.cfm">
		<div class="main row-fluid">#body#</div>
		
		<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery-tagselector.js?coreversion=#application.coreversion#"></script>
		<script src="#application.configBean.getContext()#/admin/assets/bootstrap/js/bootstrap.min.js"></script>
	</body>
</html>
</cfoutput>