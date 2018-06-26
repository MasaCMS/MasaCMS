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
		<cfif not IsDefined("cookie.ADMINSIDEBAR")>
			<cfset application.utility.setCookie(name="ADMINSIDEBAR",value="off")>
		</cfif>
		<cfparam name="request.action" default="core:cplugin.plugin">
		<cfparam name="rc.originalfuseaction" default="#listLast(listLast(request.action,":"),".")#">
		<cfparam name="rc.originalcircuit"  default="#listFirst(listLast(request.action,":"),".")#">
		<cfparam name="rc.jsLib" default="jquery">
		<cfparam name="rc.jsLibLoaded" default="false">
		<cfparam name="rc.activetab" default="0">
		<cfparam name="rc.renderMuraAlerts" default="#application.configBean.getValue(property='renderMuraAlerts',defaultValue=true)#">
		<cfparam name="rc.activepanel" default="0">
		<cfparam name="rc.siteid" default="#session.siteID#">
		<cfparam name="application.coreversion" default="#application.serviceFactory.getBean('autoUpdater').getCurrentVersion()#">
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
				<cfcase value="cAdvertising">
				<cfset moduleTitle="Advertising Manager"/>
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
	<meta name="author" content="Blue River Interactive Group">
	<meta name="robots" content="noindex, nofollow, noarchive">
	<meta http-equiv="cache control" content="no-cache, no-store, must-revalidate">

    <!-- Favicons -->
	<link rel="icon" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/ico/favicon.ico" type="image/x-icon" />
	<link rel="shortcut icon" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/ico/favicon.ico" type="image/x-icon" />
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/ico/apple-touch-icon-57-precomposed.png">

    <!-- Stylesheets -->
    <!-- Web fonts, stored locally -->
    <link rel="stylesheet" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/css/fonts.min.css">

	<!-- Admin CSS -->
	<link href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/css/admin.min.css" rel="stylesheet" type="text/css" />

	<!-- Spinner JS -->
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/spin.min.js" type="text/javascript"></script>

	<!-- jQuery -->
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/jquery/jquery.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>

	<!-- OneUI Core JS: Bootstrap, slimScroll, scrollLock, Appear, CountTo, Placeholder, Cookie and App.js -->
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/oneui.js"></script>

   	<!-- jQuery UI components -->
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/jquery/jquery-ui.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/jquery/jquery-ui-i18n.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/jquery/jquery.collapsibleCheckboxTree.js?coreversion=#application.coreversion#" type="text/javascript"></script>
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/jquery/jquery.spin.js" type="text/javascript"></script>

	<!-- Mura js -->
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/mura.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>

	<!-- Mura Admin JS -->
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/admin.js?coreversion=#application.coreversion#" type="text/javascript"></script>

	<cfif cgi.http_user_agent contains 'msie'>
		<!--[if lte IE 8]>
		<link href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/css/ie.min.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
		<![endif]-->
	</cfif>

	<!-- CK Editor/Finder -->
	<script type="text/javascript" src="#application.configBean.getContext()#/requirements/ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="#application.configBean.getContext()#/requirements/ckeditor/adapters/jquery.js"></script>
	<script type="text/javascript" src="#application.configBean.getContext()#/requirements/ckfinder/ckfinder.js"></script>

	<!-- Color Picker -->
	<script type="text/javascript" src="#application.configBean.getContext()#/requirements/colorpicker/js/bootstrap-colorpicker.js?coreversion=#application.coreversion#"></script>
	<link href="#application.configBean.getContext()#/requirements/colorpicker/css/colorpicker.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />

	<!-- JSON -->
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/json2.js" type="text/javascript"></script>

	<!-- Mura Vars -->
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
  <body id="#rc.originalcircuit#" class="mura-admin header-navbar-fixed<!-- no-constrain-->">

    <!-- Page Container -->
    <div id="page-container" class="<cfif session.siteid neq ''  and rc.$.currentUser().isLoggedIn() and rc.$.currentUser().isPrivateUser()>sidebar-l</cfif> sidebar-o <cfif cookie.ADMINSIDEBAR is 'off'> sidebar-mini</cfif> side-overlay-hover side-scroll header-navbar-fixed">

		<cfif session.siteid neq ''  and rc.$.currentUser().isLoggedIn() and rc.$.currentUser().isPrivateUser()>
    <cfinclude template="includes/nav.cfm">
    <cfinclude template="includes/header.cfm">
		</cfif>

    <!-- Main Container -->
    <main id="main-container" class="<cfif session.siteid neq ''  and rc.$.currentUser().isLoggedIn() and rc.$.currentUser().isPrivateUser()>block-constrain</cfif>">

    <!-- Page Content -->
    <div class="content">

         	<cfif request.action neq "core:cLogin.main" and isdefined('session.siteID')
         		and (
         		listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')
         		)
         	>
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
		            </div>
		     				#alerts['#alert#'].text#
		     			</cfif>
     				</cfloop>
     			</cfif>

     			<cfif rc.renderMuraAlerts>
     				<cfif isdefined('session.hasdefaultpassword') and not structKeyExists(session.mura.alerts['#session.siteID#'],'defaultpasswordnotice')>
     					<div class="alert alert-error">
     						<span>
			           	<a data-alertid="defaultpasswordnotice" class="close alert-dismiss" data-dismiss="alert"><i class="mi-close"></i></a>
     						#application.rbFactory.getKeyValue(session.rb,"layout.defaultpasswordnotice")#
     						</span>
							</div>
	     			</cfif>

	     			<cfif not len(application.settingsManager.getSite(session.siteID).getEnableLockdown())
	     						and not application.settingsManager.getSite(session.siteID).getCache()
	     						and not structKeyExists(session.mura.alerts['#session.siteID#'],'cachenotice')>
			           	<div class="alert alert-warning">
		     						<span>
					           	<a data-alertid="cachenotice" class="close alert-dismiss" data-dismiss="alert"><i class="mi-close"></i></a>
			           		#application.rbFactory.getKeyValue(session.rb,"layout.cachenotice")#
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
				$(document).ready(function(){
					// persist sidebar selection
					$('*[data-action=sidebar_mini_toggle]').click(function(){
						if($('##page-container').hasClass('sidebar-mini')){
			 			createCookie('ADMINSIDEBAR','off',5);
						} else {
			 			createCookie('ADMINSIDEBAR','on',5);
						}
					});

					// persist open nav items
					$('##sidebar .nav-main li ul li a.active').parents('li').parents('ul').parents('li').addClass('open');

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

					// make :contains selector case-insensitive
					jQuery.expr[":"].contains = jQuery.expr.createPseudo(function(arg) {
					    return function( elem ) {
				        return jQuery(elem).text().toUpperCase().indexOf(arg.toUpperCase()) >= 0;
					    };
					});

					// min-height for page content area
					var setBlockHeight = function(){
						var bc = $('##mura-content .block-constrain');
						var minFooterH = 15;
						var windowH = $(window).height();
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
						var h = windowH - headerH - footerH -110;
						$(bc).last().css('min-height',h + 'px');
					};
					// run on page load
					setBlockHeight();
					// run on window resize
					$(window).on('resize',function(){
						setBlockHeight();
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

			mura.init({
			context:'#esapiEncode("javascript",rc.$.globalConfig('context'))#',
			themepath:'#application.settingsManager.getSite(rc.siteID).getThemeAssetPath()#',
			siteid:<cfif isDefined('session.siteid') and len(session.siteid)>'#esapiEncode("javascript",session.siteid)#'<cfelse>'default'</cfif>
			});
			</script>

		</cfif>

		<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/jquery/jquery-tagselector.js?coreversion=#application.coreversion#"></script>

		<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/bootstrap-tabdrop.js"></script>

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
