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
<cfoutput>

<!-- Favicons -->
	<link rel="icon" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/ico/favicon.ico" type="image/x-icon" />
	<link rel="shortcut icon" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/ico/favicon.ico" type="image/x-icon" />
	<link rel="apple-touch-icon-precomposed" sizes="144x144" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/ico/apple-touch-icon-144-precomposed.png">
	<link rel="apple-touch-icon-precomposed" sizes="114x114" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/ico/apple-touch-icon-114-precomposed.png">
	<link rel="apple-touch-icon-precomposed" sizes="72x72" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/ico/apple-touch-icon-72-precomposed.png">
	<link rel="apple-touch-icon-precomposed" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/ico/apple-touch-icon-57-precomposed.png">

	<!-- Spinner JS -->
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/spin.min.js" type="text/javascript"></script>

	<!-- jQuery -->
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/jquery/jquery.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>

	<!-- OneUI Core JS: Bootstrap, slimScroll, scrollLock, Appear, CountTo, Placeholder, Cookie and App.js -->
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/oneui.min.js"></script>

	<!-- jQuery UI components -->
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/jquery/jquery-ui.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/jquery/jquery-ui-i18n.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/jquery/jquery.collapsibleCheckboxTree.js?coreversion=#application.coreversion#" type="text/javascript"></script>
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/jquery/jquery.spin.js" type="text/javascript"></script>

	<!-- Masa js -->
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/mura.js?coreversion=#application.coreversion#" type="text/javascript"></script>

	<!-- Masa Admin JS -->
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/admin.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>

	<!-- CK Editor -->
	<script type="text/javascript" src="#application.configBean.getContext()#/core/vendor/ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="#application.configBean.getContext()#/core/vendor/ckeditor/adapters/jquery.js"></script>

	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/filebrowser/filebrowser.js"></script>
	<link href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/filebrowser/assets/css/filebrowser.css" link rel="stylesheet" type="text/css"></script>

	<!-- JSON -->
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/json2.js" type="text/javascript"></script>

	<!-- Color Picker -->
	<script type="text/javascript" src="#application.configBean.getContext()#/core/vendor/colorpicker/js/bootstrap-colorpicker.js?coreversion=#application.coreversion#"></script>
	<link href="#application.configBean.getContext()#/core/vendor/colorpicker/css/bootstrap-colorpicker.min.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />

	<script type="text/javascript">
	var htmlEditorType='#application.configBean.getValue("htmlEditorType")#';
	var context='#application.configBean.getContext()#';
	var themepath='#application.settingsManager.getSite(rc.siteID).getThemeAssetPath()#';
	var rb='#lcase(esapiEncode('javascript',session.rb))#';
	var siteid='#esapiEncode('javascript',session.siteid)#';
	var sessionTimeout=#evaluate("application.configBean.getValue('sessionTimeout') * 60")#;
	var activepanel=#esapiEncode('javascript',rc.activepanel)#;
	var activetab=#esapiEncode('javascript',rc.activetab)#;
	<cfif $.currentUser().isLoggedIn()>var webroot='#esapiEncode('javascript',left($.globalConfig("webroot"),len($.globalConfig("webroot"))-len($.globalConfig("context"))))#';</cfif>
	var fileDelim='#esapiEncode('javascript',$.globalConfig("fileDelim"))#';
	</script>

	<!-- nice-select: select box replacement (sidebar controls) -->
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/jquery.nice-select.min.js" type="text/javascript"></script>

</cfoutput>
