<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. ?See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. ?If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and
conditions of the GNU General Public License version 2 (?GPL?) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, ?the copyright holders of Mura CMS grant you permission
to combine Mura CMS ?with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the ?/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/admin/
/tasks/
/config/
/core/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 ?without this exception. ?You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfoutput>

<!DOCTYPE html>
<!--[if IE 9]> <html lang="en_US" class="ie9 mura no-focus"> <![endif]-->
<!--[if gt IE 9]><!--> <html lang="en_US" class="mura no-focus"><!--<![endif]-->
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Mura CMS - Setup</title>
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1.0">
<meta name="author" content="blueriver">
<meta name="robots" content="noindex, nofollow, noarchive">
<meta http-equiv="cache control" content="no-cache, no-store, must-revalidate">
<!-- Favicons -->
<link rel="icon" href="#context#/admin/assets/ico/favicon.ico" type="image/x-icon" />
<link rel="shortcut icon" href="#context#/admin/assets/ico/favicon.ico" type="image/x-icon" />
<link rel="apple-touch-icon-precomposed" sizes="144x144" href="#context#/admin/assets/ico/apple-touch-icon-144-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="114x114" href="#context#/admin/assets/ico/apple-touch-icon-114-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="72x72" href="#context#/admin/assets/ico/apple-touch-icon-72-precomposed.png">
<link rel="apple-touch-icon-precomposed" href="#context#/admin/assets/ico/apple-touch-icon-57-precomposed.png">
<!-- Stylesheets -->
<!-- Web fonts -->
<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400italic,600,700%7COpen+Sans:300,400,400italic,600,700">
<!-- Admin CSS -->
<link href="#context#/admin/assets/css/admin.min.css" rel="stylesheet" type="text/css" />
<!-- jQuery -->
<script src="#context#/admin/assets/js/jquery/jquery.min.js"></script>
<!-- OneUI Core JS: Bootstrap, slimScroll, scrollLock, Appear, CountTo, Placeholder, Cookie and App.js -->
<script src="#context#/admin/assets/js/oneui.min.js"></script>
</head>
<body id="csetup" class="header-navbar-fixed">
	<!-- Page Container -->
	<div id="page-container" class=" sidebar-o side-overlay-hover side-scroll header-navbar-fixed">
		<!-- Main Container -->
		<main id="main-container">
			<!-- Page Content -->
			<div class="content">
				<div id="mura-setup">
					<div class="block mura-focus-block" id="mura-login-panel">
					  <div class="focus-block-header">
					  	<img src="#context#/admin/assets/images/mura-logo-black@2x.png" class="mura-logo">
					  </div><!-- /focus-block-header -->
			  	     <div class="block-content">
				  	 <h3 class="center mura-login-auth-heading">Installation</h3>

</cfoutput>
