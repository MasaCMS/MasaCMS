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
<cfsilent><cfparam name="request.action" default="core:cplugin.plugin">
<cfparam name="rc.originalfuseaction" default="#listLast(listLast(request.action,":"),".")#">
<cfparam name="rc.originalcircuit"  default="#listFirst(listLast(request.action,":"),".")#">
<cfparam name="rc.jsLib" default="jquery">
<cfparam name="rc.jsLibLoaded" default="false">
<cfparam name="rc.activetab" default="0">
<cfparam name="rc.activepanel" default="0">
<cfparam name="rc.siteid" default="#session.siteID#"><cfoutput></cfoutput>
<cfparam name="rc.frontEndProxyLoc" default="">
<cfparam name="session.frontEndProxyLoc" default="#rc.frontEndProxyLoc#">
<cfparam name="rc.sourceFrame" default="modal">

<cfif len(rc.frontEndProxyLoc)>
	<cfset session.frontEndProxyLoc=rc.frontEndProxyLoc>
</cfif>
</cfsilent><cfoutput><cfprocessingdirective suppressWhitespace="true"><!DOCTYPE html>
<cfif cgi.http_user_agent contains 'msie'>
	<!--[if IE 8 ]><html class="mura ie ie8" lang="#esapiEncode('html_attr',session.locale)#"><![endif]-->
	<!--[if (gte IE 9)|!(IE)]><!--><html lang="#esapiEncode('html_attr',session.locale)#" class="mura ie"><!--<![endif]-->
<cfelse>
<!--[if IE 9]> <html lang="en_US" class="ie9 mura no-focus"> <![endif]-->
<!--[if gt IE 9]><!--> <html lang="#esapiEncode('html_attr',session.locale)#" class="mura no-focus"><!--<![endif]-->
</cfif>
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

		<title>#esapiEncode('html', application.configBean.getTitle())#</title>
    	<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1.0">
		<meta name="author" content="blueriver & We Are North Groep BV">
		<meta name="robots" content="noindex, nofollow, noarchive">
		<meta http-equiv="cache control" content="no-cache, no-store, must-revalidate">

		<cfif Len(application.configBean.getWindowDocumentDomain())>
			<script type="text/javascript">
				window.document.domain = '#application.configBean.getWindowDocumentDomain()#';
			</script>
		</cfif>

		<cfif cgi.http_user_agent contains 'msie'>
			<!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
			<!--[if lt IE 9]>
			   <script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/html5.js"></script>
			<![endif]-->
		</cfif>

		<!--- global admin scripts --->
		<cfinclude template="includes/html_head.cfm">

		<!-- nice-select: select box replacement (sidebar controls) -->
		<cfif rc.sourceFrame neq 'modal'>
			<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/jquery.nice-select.min.js" type="text/javascript"></script>
		</cfif>
		<!-- /nice-select -->

		<!-- Utilities to support iframe communication -->
		<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/jquery/jquery-resize.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>
		<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/porthole/porthole.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>

		<link href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/css/admin.min.css" rel="stylesheet" type="text/css" />
		#session.dateKey#
		<script type="text/javascript">

			var resizeTabPane = function(offsetVal=17){

				// set width of pane relative to side controls
				if ($('##mura-content-body-block').length){

					var blockW = $('##mura-content-body-block').width();
					var controlW = $('##mura-content-body-block .mura__edit__controls').width();
					var newW = (blockW - controlW) - offsetVal;

					$('##mura-content-body-block .block-content.tab-content').css('width',newW + 'px');
					setTimeout(function(){
						resizeBodyEditor();
					}, 50)
				}
				// set heights, accounting for header
				if ($('##dspStatusContainer').length){
					var tabContent = $('##mura-content-body-block>.tab-content');
					var controls = $('##mura-content-body-block .mura__edit__controls');
					var statusH = $('##dspStatusContainer').height();
					var origBlockH = $('##mura-content-body-block').height();
					var origTabH = $(tabContent).height();
					var origControlsH = $(controls).height();
					var newBlockH = origBlockH - statusH;
					var newTabH = origTabH - statusH + 90;
					var newControlsH = origControlsH - statusH + 12;

					$('##mura-content-body-block').css('height',newBlockH);
					$(tabContent).css('height',newTabH);
					$(controls).css('height',newControlsH);
				}

			}

			// set height of ckeditor content area - called by resizeTabPane()
			var resizeBodyEditor = function(){
				if ($('##mura-content-body-render .cke_contents').length){
					var ckeTopH = $('##mura-content-body-render .cke_top').height();
					var statusH = 0;
					var topH = 0;

					if ($("##dspStatusContainer").length){
						statusH = $("##dspStatusContainer").height();
					};

				 	topH = statusH + ckeTopH;

					$('##mura-content-body-render .cke_contents').css('height','calc((100vh - ' + topH +  'px) - 260px)');
				}
			}

			$(window).on("load", function() {
				resizeTabPane();
				$('##mura-content-body-render').show();
			});

			var frontEndProxy;
			jQuery(document).ready(function(){


				//nice-select
				Mura(function(){
					$('.mura__edit__controls .mura-control-group select').niceSelect();
				});

				// tabdrop: trigger on page load w/ slight delay
				if ( $( '.mura-tabs').length ) {
					var triggerTabDrop = function(){
						setTimeout(function(){
							$('.mura-tabs').tabdrop({text: '<i class="mi-chevron-down"></i>'});
								$('.tabdrop .dropdown-toggle').parents('.nav-tabs').css('overflow-y','visible');
								$('.tabdrop a.dropdown-toggle .display-tab').html('<i class="mi-chevron-down"></i>');
						}, 10);
					}
					// run on page load
					triggerTabDrop();
					// run on resize
					$(window).on('resize',function(){
						$('.nav-tabs').css('overflow-y','hidden').find('li.tabdrop').removeClass('open').find('.dropdown-backdrop').remove();
							triggerTabDrop();
					});
					$('.tabdrop .dropdown-toggle').on('click',function(){
						$(this).parents('.nav-tabs').css('overflow-y','visible');
					});
				}
				// /tabdrop

				if (top.location != self.location) {

					function getHeight(){
						if(document.all){
							return Math.max(document.body.scrollHeight, document.body.offsetHeight,160);
						} else {
							return Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight,160);
						}
					}

					frontEndProxy = new Porthole.WindowProxy("#esapiEncode('javascript',session.frontEndProxyLoc)##application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/porthole/proxy.html");
					frontEndProxy.post({cmd:
											'setHeight',
											height:getHeight(),
											'targetFrame': '#esapiEncode("javascript",rc.sourceFrame)#'
										});
					jQuery(this).resize(function(e){
						frontEndProxy.post({cmd:
											'setHeight',
											height:getHeight(),
											'targetFrame': '#esapiEncode("javascript",rc.sourceFrame)#'
										});
					});

					if(typeof siteManager != 'undefined'){
						frontEndProxy.addEventListener(siteManager.frontEndProxyListener);
					}
				};

				// click to close new table actions, category selector filter
				document.onclick = function(e) {
				if (jQuery('##newContentMenu').length > 0){
				  if(!(jQuery(e.target).parents().hasClass('addNew')) && !(jQuery(e.target).parents().hasClass('add')) && !(jQuery(e.target).hasClass('add'))){
			     	jQuery('##newContentMenu').addClass('hide');
		    	}
				};

				if (jQuery('.actions-menu').length > 0){
			    if(!(jQuery(e.target).parents().hasClass('actions-menu')) && !(jQuery(e.target).parents().hasClass('actions-list')) && !(jQuery(e.target).parents().hasClass('show-actions')) && !(jQuery(e.target).hasClass('actions-list'))){
			       jQuery('.actions-menu').addClass('hide');
		     	}
				};

				if(jQuery('##category-select-list').length > 0){
			    if(!(jQuery(e.target).parents().hasClass('category-select')) && !(jQuery(e.target).parents().hasClass('categories'))){
			    	jQuery('##category-select-list').slideUp('fast');
				    }
					}
				};
				// /click to close

			});

			<cfif isDefined('session.siteid') and len(session.siteid)>
				<cfset site=$.getBean('settingsManager').getSite(session.siteid)>
			<cfelse>
				<cfset site=$.getBean('settingsManager').getSite('default')>
			</cfif>
			Mura.init({
				inAdmin:true,
				context:'#esapiEncode("javascript",rc.$.globalConfig('context'))#',
				themepath:'#esapiEncode("javascript",site.getThemeAssetPath(complete=1))#',
				siteid:'#esapiEncode("javascript",site.getSiteID())#',
				assetpath:'#esapiEncode("javascript",site.getAssetPath(complete=1))#',
				sitespath:'#esapiEncode("javascript",site.getSitesPath(complete=1))#',
				corepath:'#esapiEncode("javascript",site.getCorePath(complete=1))#',
				fileassetpath:'#esapiEncode("javascript",site.getFileAssetPath(complete=1))#',
				adminpath:'#esapiEncode("javascript",site.getAdminPath(complete=1))#',
				themepath:'#esapiEncode("javascript",site.getThemeAssetPath(complete=1))#',
				pluginspath:'#esapiEncode("javascript",site.getPluginsPath(complete=1))#',
				rootpath:'#esapiEncode("javascript",site.getRootPath(complete=1))#',
				indexfileinapi: #rc.$.globalConfig('indexfileinapi')#
			});
		</script>
		#rc.ajax#

		<cfif cgi.http_user_agent contains 'msie'>
			<!--[if lte IE 8]>
			<link href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/css/ie.min.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
			<![endif]-->
		</cfif>
	</head>
	<body id="#esapiEncode('html_attr',rc.originalcircuit)#" class="compact <cfif rc.sourceFrame eq 'modal'>modal-wrapper<cfelse>configurator-wrapper</cfif>">
		<div id="mura-content">
		<cfif rc.sourceFrame eq 'modal'>
			<a id="frontEndToolsModalClose" href="javascript:frontEndProxy.post({cmd:'close'});"><i class="mi-close"></i></a>
			<cfinclude template="includes/dialog.cfm">
		</cfif>

		<div class="main mura-layout-row"></cfprocessingdirective>#body#<cfprocessingdirective suppressWhitespace="true"></div>

		</div> <!-- /mura-content -->

		<cfinclude template="includes/html_foot.cfm">

	</body>
</html></cfprocessingdirective>
</cfoutput>
