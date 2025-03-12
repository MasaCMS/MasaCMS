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
<cfoutput><cfprocessingdirective suppressWhitespace="true"><!DOCTYPE html>
<cfif not isdefined('request.backported')>
	<cfscript>
		if(server.coldfusion.productname != 'ColdFusion Server'){
			backportdir='';
			include "/mura/backport/backport.cfm";
		} else {
			backportdir='/mura/backport/';
			include "#backportdir#backport.cfm";
		}
	</cfscript>
</cfif>
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
	<cfsilent>
		<cfparam name="request.action" default="core:cplugin.plugin">
		<cfparam name="rc.originalfuseaction" default="#listLast(listLast(request.action,":"),".")#">
		<cfparam name="rc.originalcircuit"  default="#listFirst(listLast(request.action,":"),".")#">
		<cfparam name="rc.jsLib" default="jquery">
		<cfparam name="rc.jsLibLoaded" default="false">
		<cfparam name="rc.activetab" default="0">
		<cfparam name="rc.renderMuraAlerts" default="#application.configBean.getValue(property='renderMuraAlerts',defaultValue=true)#">
		<cfparam name="rc.activepanel" default="0">
		<cfparam name="rc.siteid" default="#session.siteID#">
		<cfparam name="rc.bodyclass" default="">
		<cfparam name="application.coreversion" default="#application.configBean.getVersion()#">
		<!--- default site id --->
		<cfif not len(rc.siteID)>
		<cfset rc.siteID="default">
		</cfif>
		<!--- admin titles --->
		<cfparam name="moduleTitle" default="">
		<cfif not len(moduleTitle)>
			<cfswitch expression="#rc.originalcircuit#">
				<cfcase value="cArch">
				<cfswitch expression="#rc.moduleID#">
				<cfcase value="00000000000000000000000000000000000,00000000000000000000000000000000003,00000000000000000000000000000000004,00000000000000000000000000000000099">
					<cfset moduleTitle="Site Content"/>
					<cfset rc.bodyclass = 'sidebar-tab'>
				</cfcase>
				<cfdefaultcase>
					<cfif rc.originalfuseaction eq "imagedetails">
						<cfset moduleTitle="Image Details">
				  <cfelseif rc.muraAction eq 'core:carch.export'>
				    <cfset moduleTitle="Export Content">
				  <cfelseif rc.muraAction eq 'core:carch.import'>
				    <cfset moduleTitle="Import Content">
					<cfelse>
						<cfset moduleTitle="Drafts">
					</cfif>
				</cfdefaultcase>
				</cfswitch>
				</cfcase>
				<cfcase value="cSettings">
				<cfset moduleTitle="Settings"/>
				</cfcase>
				<cfcase value="cPrivateUsers">
				<cfset moduleTitle="Admin Users"/>
				</cfcase>
				<cfcase value="cPublicUsers">
				<cfset moduleTitle="Site Members"/>
				</cfcase>
				<cfcase value="cEmail">
				<cfset moduleTitle="Email Broadcaster"/>
				</cfcase>
				<cfcase value="cLogin">
				<cfset moduleTitle="Login"/>
				</cfcase>
				<cfcase value="cMailingList">
				<cfset moduleTitle="Mailing Lists"/>
				</cfcase>
				<cfcase value="cMessage">
				<cfset moduleTitle="Message"/>
				</cfcase>
				<cfcase value="cEditProfile">
				<cfset moduleTitle="Edit Profile"/>
				</cfcase>
				<cfcase value="cFeed">
				<cfset moduleTitle="Collections"/>
				</cfcase>
				<cfcase value="cFilemanager">
				<cfset moduleTitle="File Manager"/>
				</cfcase>
				<cfcase value="cDashboard">
				<cfset moduleTitle="Dashboard"/>
				</cfcase>
				<cfcase value="cCategory">
				<cfset moduleTitle="Categories"/>
				</cfcase>
				<cfcase value="cChain">
				<cfset moduleTitle="Approval Chains"/>
				</cfcase>
				<cfcase value="cChangesets">
				<cfset moduleTitle="Content Staging"/>
				</cfcase>
				<cfcase value="cComments">
				<cfset moduleTitle="Comments"/>
				</cfcase>
				<cfcase value="cExtend">
				<cfset moduleTitle="Class Extensions"/>
				</cfcase>
				<cfcase value="cPerm">
				<cfset moduleTitle="Permissions"/>
				</cfcase>
				<cfcase value="cPlugin">
				<cfset moduleTitle="Plugins"/>
				</cfcase>
				<cfcase value="cPlugins">
				<cfset moduleTitle="Plugins"/>
				</cfcase>
				<cfcase value="cTrash">
				<cfset moduleTitle="Trash Bin"/>
				</cfcase>
				<cfcase value="cUsers">
				<cfset moduleTitle="Users"/>
				</cfcase>
				<cfdefaultcase>
				<cfset moduleTitle="">
				</cfdefaultcase>
			</cfswitch>
		</cfif>
		<cfheader name="cache-control" value="no-cache, no-store, must-revalidate">
		<cfheader name="expires" value="06 Nov 1994 08:37:34 GMT">
	</cfsilent>

	<title>#esapiEncode('html',application.configBean.getTitle())#<cfif len(moduleTitle)> - #esapiEncode('html',moduleTitle)#</cfif></title>
	<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1.0">
	<meta name="author" content="blueriver & We Are North Groep BV">
	<meta name="robots" content="noindex, nofollow, noarchive">
	<meta http-equiv="cache control" content="no-cache, no-store, must-revalidate">

	<!-- Admin CSS -->
	<link href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/css/admin.min.css" rel="stylesheet" type="text/css" />

    <!--- global admin scripts --->
    <cfinclude template="includes/html_head.cfm">

	<cfif cgi.http_user_agent contains 'msie'>
		<!--[if lte IE 8]>
		<link href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/css/ie.min.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
		<![endif]-->
	</cfif>

	#session.dateKey#
	#rc.ajax#

	<cfif rc.originalcircuit neq "cLogin">
		<script>
		if (top.location != self.location) {
		    	top.location.replace(self.location)
			}
		</script>
	</cfif>
	<cfif structKeyExists(rc,'$')>
		 #rc.$.renderEvent('onAdminHTMLHeadRender')#
	</cfif>
</head>
<!--- use class no-constrain to remove fixed-width on inner containers --->
<body id="#rc.originalcircuit#" class="mura-admin header-navbar-fixed no-constrain #trim(rc.bodyclass)#">

	<!-- Page Container -->
	<div id="page-container" class="<cfif session.siteid neq ''  and rc.$.currentUser().isLoggedIn() and rc.$.currentUser().isPrivateUser()>sidebar-l</cfif> sidebar-o <cfif cookie.ADMINSIDEBAR is 'off'> sidebar-mini</cfif> side-overlay-hover side-scroll header-navbar-fixed">

		<cfif session.siteid neq ''  and rc.$.currentUser().isLoggedIn() and rc.$.currentUser().isPrivateUser()>
			<cfinclude template="includes/nav.cfm">
			<cfinclude template="includes/header.cfm">
		</cfif>

		<!-- Main Container -->
		<main id="main-container" class="<cfif session.siteid neq '' and rc.$.currentUser().isLoggedIn() and rc.$.currentUser().isPrivateUser()>block-constrain</cfif>">

		    <!-- Page Content -->
		    <div class="content">

		     	<cfif request.action neq "core:cLogin.main" and isdefined('session.siteID')
		     		and (listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2'))>
					<cfparam name="session.mura.alerts" default="#structNew()#">
					<cfif not structKeyExists(session.mura.alerts,'#session.siteid#')>
						<cfset session.mura.alerts['#session.siteid#']={}>
					</cfif>

		 			<cfif not structIsEmpty(session.mura.alerts['#session.siteid#'])>
		 				<cfset alerts=session.mura.alerts['#session.siteid#']>
		 				<cfloop collection="#alerts#" item="alert">
		 					<cfif not listFindNoCase('defaultpasswordnotice,cachenotice',alert)>
		 						<div<cfif len(alerts['#alert#'].type)> class="alert alert-#esapiEncode('html',alerts['#alert#'].type)#"<cfelse> class="alert alert-error"</cfif>>
		     						<span>
							           	<a data-alertid="#alert#" class="close alert-dismiss" data-dismiss="alert"><i class="mi-close"></i></a>
			   							</span>
			     					#alerts['#alert#'].text#
								</div>
			     			</cfif>
		 				</cfloop>
		 			</cfif>

					<cfif rc.renderMuraAlerts>
						<cfset expirePasswordsIn=rc.$.getBean('configBean').getValue(property="expirePasswords", defaultValue=0)>
						<cfif isNumeric(expirePasswordsIn) and expirePasswordsIn and rc.$.currentUser().get('passwordExpired') and not structKeyExists(session.mura.alerts['#session.siteID#'],'passwordexpirednotice')>
							<div class="alert alert-error">
								<span>
									<a data-alertid="passwordexpirednotice" class="close alert-dismiss" data-dismiss="alert"><i class="mi-close"></i></a>
										#rc.$.rbKey("layout.passwordexpirednotice")#
								</span>
							</div>
						</cfif>

						<cfif isdefined('session.hasdefaultpassword') and not structKeyExists(session.mura.alerts['#session.siteID#'],'defaultpasswordnotice')>
							<div class="alert alert-error">
								<span>
									<a data-alertid="defaultpasswordnotice" class="close alert-dismiss" data-dismiss="alert"><i class="mi-close"></i></a>
										#rc.$.rbKey("layout.defaultpasswordnotice")#
								</span>
							</div>
						</cfif>
						<cfif not len(application.settingsManager.getSite(session.siteID).getEnableLockdown())
							and not application.settingsManager.getSite(session.siteID).getCache()
							and not structKeyExists(session.mura.alerts['#session.siteID#'],'cachenotice')>
							<div class="alert alert-warning">
								<span>
									<a data-alertid="cachenotice" class="close alert-dismiss" data-dismiss="alert"><i class="mi-close"></i></a>
									#rc.$.rbKey("layout.cachenotice")#
								</span>
							</div>
						</cfif>
					</cfif>
		 		</cfif>
		 		<cfif request.action neq "core:cLogin.main">
		 			<div id="mura-content">
		 		</cfif>
		 		</cfprocessingdirective>#body#<cfprocessingdirective suppressWhitespace="true">
		 		<cfif request.action neq "core:cLogin.main">
		 			</div> <!-- /##mura-content -->
		 		</cfif>

			</div>  <!-- /.content -->

		</main>

		<cfif request.action neq "core:cLogin.main" and isDefined("session.siteid")>

			<script>
			$(document).on('click', '.selectAssocImageResults ul li', function(e){
				if(e.target.tagName != 'INPUT'){
					$(this).find('input[type=radio]').prop('checked',true);
					return false;
				}
			});

			// set width of pane relative to side controls
			var resizeTabPane = function(offsetVal=17){
				if ($('##mura-content-body-block').length){

					var blockW = $('##mura-content-body-block').width();
					var controlW = $('##mura-content-body-block .mura__edit__controls').width();
					var newW = (blockW - controlW) - offsetVal;

					$('##mura-content-body-block .block-content.tab-content').css('width',newW + 'px');
					setTimeout(function(){
						resizeBodyEditor();
					}, 50)
				}
			}

			// set height of ckeditor content area - called by resizeTabPane()
			var resizeBodyEditor = function(){
				if ($('##mura-content-body-render .cke_contents').length){
					var ckeTopH = $('##mura-content-body-render .cke_top').height();
					var adminHeaderH = $('##mura-content .mura-header').height();
					var offsetH = ckeTopH + adminHeaderH;
					// also adjust cke height
					$('##mura-content-body-render .cke_contents').css('height','calc((100vh - ' + offsetH +  'px) - 283px)');
				}
			}

			$(window).on("load", function() {
				resizeTabPane();
				$('##mura-content-body-render').show();
			});

			$(document).ready(function(){

				// resizable editing panel
				$('##mura-content .mura__edit__controls').resizable({
					handles:'w',
					maxWidth: 640,
					minWidth: 300,
					resize: function (event,ui) {
		                // overlay prevents ckeditor iframe from stealing cursor focus
		                var frameParent = $('##mura-content-body-render');
		                var overlay = $(frameParent).find('.hidden-dialog-overlay');
				        if (!overlay.length) {
				            overlay = $('<div class="hidden-dialog-overlay" style="position:absolute;top:0;left:0;right:0;bottom:0;z-index:100000; width: 100%; height: 100%;"></div>');
				            overlay.appendTo(frameParent);
				        } else {
				            overlay.show();
				        }
				        resizeTabPane();
				        ui.position.left = ui.originalPosition.left;
			     	},
					stop: function(event,ui){
						var acw = $(this).width();
		                var frameParent = $('##mura-content-body-render');
			 			$(frameParent).find('.hidden-dialog-overlay').hide();
			        	resizeTabPane();
			 			createCookie('ADMINCONTROLWIDTH',acw,5);
					}
				});

				// persist side navigation expand/collapse
				$('*[data-action=sidebar_mini_toggle]').click(function(){
					var asb = 'on';
					// adjust sidebar as needed
					resizeTabPane();
					// set adminsidebar cookie
					if($('##page-container').hasClass('sidebar-mini')){
						asb = 'off';
					}
		 			createCookie('ADMINSIDEBAR',asb,5);
				});

				// persist open nav items
				$('##sidebar .nav-main li ul li a.active').parents('li').parents('ul').parents('li').addClass('open');

				//nice-select
				$('.mura__edit__controls .mura-control-group select').niceSelect();

				// header-search
				$('##mura-header-search-reveal').click(
				function(){
					$(this).hide();
					$('##mura-header-search').show();
				});

				// site list filter
				var sitefilter = jQuery('##site-list-filter');
				var sitelist = jQuery('ul##site-selector-list');
				var sitelistw = jQuery(sitelist).width();
				jQuery(sitelist).find('.ui-widget').click(function(){
					return false;
				})
				jQuery(sitefilter).click(function(){
					return false;
				});
				jQuery(sitelist).css('width',sitelistw);
				jQuery(sitefilter).keyup(function(){
					var str = jQuery(this).val();
					jQuery(sitelist).find('li').hide();
					if (str == ''){
						jQuery(sitelist).find('li').show();
					} else {
						jQuery(sitelist).find('li:contains(' + str + ')').show();
					}
				});

				// min-height for page content area
				var setBlockHeight = function(){
					var bc = $('##mura-content .block-constrain');
					var minFooterH = 15;
					var paddingH = 70;
					var windowH = $(window).height();
					var navbarH = $('##header-navbar:first').height();
					var headerH = $('.mura-header:first').height();
					var footerH = $('.mura-actions:first').height();
					if (footerH <= minFooterH){ footerH = minFooterH;}
					if ($(bc).length > 1){
						$.each(bc,function(){
							if($(this)[0] !== $(bc).last()[0]){
								footerH = footerH + $(this).height();
							}
						});
					}
					var subtr = paddingH + navbarH + headerH + footerH;
					var h = windowH - subtr;

					$(bc).last().css('min-height',h + 'px');
				};
				// run on page load
				setBlockHeight();
				// run on window resize
				$(window).on('resize',function(){
					setBlockHeight();
					resizeTabPane();
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

				// dismiss alerts
				$('.alert-dismiss').click(
					function(){
						var _alert=this;
						$.ajax(
							{
								url:'./',
								data:{
									siteid:'#esapiEncode('javascript',session.siteid)#',
									alertid:$(_alert).attr('data-alertid'),
									muraaction:'cdashboard.dismissAlert'
								},
								success: function(){
									$(_alert).parent('.alert').fadeOut();
								}
							}
						);
					}
				);

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

		</cfif>

		<cfinclude template="includes/html_foot.cfm">

		<cfif rc.originalcircuit eq "cArch" and (rc.originalfuseaction eq "list" or rc.originalfuseaction eq "search") and (listFind(',00000000000000000000000000000000099,00000000000000000000000000000000000,00000000000000000000000000000000003,00000000000000000000000000000000004',rc.moduleid) or rc.moduleid eq '')>
			<cfinclude template="/muraWRM#application.configBean.getAdminDir()#/core/views/carch/dsp_content_nav.cfm">
		</cfif>

		<cfinclude template="includes/dialog.cfm">

		<cfif structKeyExists(rc,'$')>
			#rc.$.renderEvent('onAdminHTMLFootRender')#
		</cfif>

	</div><!-- /.page-container -->

</body>
</html></cfprocessingdirective>
</cfoutput>
