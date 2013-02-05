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
  	<cfsilent>
  		<cfparam name="request.action" default="core:cplugin.plugin">
  		<cfparam name="rc.originalfuseaction" default="#listLast(listLast(request.action,":"),".")#">
		<cfparam name="rc.originalcircuit"  default="#listFirst(listLast(request.action,":"),".")#">
	  	<cfparam name="rc.jsLib" default="jquery">
		<cfparam name="rc.jsLibLoaded" default="false">
		<cfparam name="rc.activetab" default="0">
		<cfparam name="rc.activepanel" default="0">
		<cfparam name="rc.renderMuraAlerts" default="true">
		<cfparam name="rc.siteid" default='#session.siteID#'>
		<cfparam name="application.coreversion" default="#application.serviceFactory.getBean('autoUpdater').getCurrentVersion()#">
		
		<!--- This code is just to prevent errors when people update past version 5.2.2652 --->
		<cfif not len(rc.siteID)>
			<cfset rc.siteID="default">
		</cfif>

		<cfif not structKeyExists(rc,"$")>
			<cfset rc.$=application.serviceFactory.getBean('$').init(session.siteid)>
		</cfif>  

		<cfparam name="moduleTitle" default="">
		<cfif not len(moduleTitle)>
		<cfswitch expression="#rc.originalcircuit#">
		<cfcase value="cArch">
			<cfswitch expression="#rc.moduleID#">
			<cfcase value="00000000000000000000000000000000003">
				<cfset moduleTitle="Components Manager"/>
			</cfcase>
			<cfcase value="00000000000000000000000000000000004">
				<cfset moduleTitle="Forms Manager"/>
			</cfcase>
			<cfcase value="00000000000000000000000000000000000">
				<cfset moduleTitle="Site Manager"/>
			</cfcase>
			<cfdefaultcase>
				<cfif rc.originalfuseaction eq "imagedetails">
					<cfset moduleTitle="Image Details">
				<cfelse>
					<cfset moduleTitle="Drafts">
				</cfif>	
			</cfdefaultcase>
			</cfswitch>
		</cfcase>
		<cfcase value="cSettings">
		<cfset moduleTitle="Settings Manager"/>
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
		<cfset moduleTitle="Content Collections"/>
		</cfcase>
		<cfcase value="cFilemanager">
		<cfset moduleTitle="File Manager"/>
		</cfcase>
		<cfcase value="cDashboard">
		<cfset moduleTitle="Dashboard"/>
		</cfcase>
		<cfcase value="cCategory">
		<cfset moduleTitle="Category Manager"/>
		</cfcase>
		<cfcase value="cExtend">
		<cfset moduleTitle="Class Extension Manager"/>
		</cfcase>
		<cfcase value="cPerm">
		<cfset moduleTitle="Permissions"/>
		</cfcase>
		<cfcase value="cPlugin">
		<cfset moduleTitle="Plugins"/>
		</cfcase>
		<cfdefaultcase>
		<cfset moduleTitle="">
		</cfdefaultcase>
		</cfswitch>
		</cfif>
		<cfheader name="cache-control" value="no-cache, no-store, must-revalidate"> 
		<cfheader name="expires" value="06 Nov 1994 08:37:34 GMT"> 
	</cfsilent>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta charset="utf-8">
    <title>#application.configBean.getTitle()#<cfif len(moduleTitle)> - #HTMLEditFormat(moduleTitle)#</cfif></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="author" content="Blue River Interactive Group">
	<meta name="robots" content="noindex, nofollow, noarchive" />
	<meta http-equiv="cache control" content="no-cache, no-store, must-revalidate" />

    <!-- Le fav and touch icons -->
    <link rel="shortcut icon" href="#application.configBean.getContext()#/admin/assets/ico/favicon.ico">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="#application.configBean.getContext()#/admin/assets/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="#application.configBean.getContext()#/admin/assets/ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="#application.configBean.getContext()#/admin/assets/ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="#application.configBean.getContext()#/admin/assets/ico/apple-touch-icon-57-precomposed.png">
  
    <link rel="icon" href="#application.configBean.getContext()#/admin/images/favicon.ico" type="image/x-icon" />
	<link rel="shortcut icon" href="#application.configBean.getContext()#/admin/images/favicon.ico" type="image/x-icon" />

	<!-- CSS -->
	<link href="#application.configBean.getContext()#/admin/assets/css/admin.min.css" rel="stylesheet" type="text/css" />

    <!-- Spinner JS -->
	<script src="#application.configBean.getContext()#/admin/assets/js/spin.min.js" type="text/javascript"></script>

	<!-- Mura Admin JS -->
	<script src="#application.configBean.getContext()#/admin/assets/js/admin.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>
	
    <!-- jQuery -->
    <script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery.js?coreversion=#application.coreversion#" type="text/javascript"></script>
    <script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery.spin.js" type="text/javascript"></script>
	<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery.collapsibleCheckboxTree.js?coreversion=#application.coreversion#" type="text/javascript"></script>
	<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery-ui.js?coreversion=#application.coreversion#" type="text/javascript"></script>
	<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery-ui-i18n.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>		
	
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
		
	<!-- CK Editor/Finder -->
	<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/ckeditor/adapters/jquery.js"></script>
	<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/ckfinder/ckfinder.js"></script>
	
	<!-- Color Picker -->
	<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/colorpicker/js/bootstrap-colorpicker.js?coreversion=#application.coreversion#"></script>
	<link href="#application.configBean.getContext()#/tasks/widgets/colorpicker/css/colorpicker.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />

	<!-- JSON -->
	<script src="#application.configBean.getContext()#/admin/assets/js/json2.js" type="text/javascript"></script>
	
	<!-- Mura Vars -->
	<script type="text/javascript">
	var htmlEditorType='#application.configBean.getValue("htmlEditorType")#';
	var context='#application.configBean.getContext()#';
	var themepath='#application.settingsManager.getSite(rc.siteID).getThemeAssetPath()#';
	var rb='#lcase(session.rb)#';
	var siteid='#session.siteid#';
	var sessionTimeout=#evaluate("application.configBean.getValue('sessionTimeout') * 60")#;
	</script>
	
	#session.dateKey#
	
	<script type="text/javascript">
		jQuery(document).ready(function(){
				setDatePickers(".datepicker",dtLocale);
				setTabs(".tabs",#rc.activeTab#);
				setHTMLEditors();
				setAccordions(".accordion",#rc.activePanel#);
				setCheckboxTrees();
				setColorPickers(".colorpicker");
				setToolTips(".container");
			});

		preloadimages(['#application.configBean.getContext()#/admin/assets/images/ajax-loader.gif']);
	</script>

	#rc.ajax#

	<cfif rc.originalcircuit neq "cLogin">
		<script>
		if (top.location != self.location) {
		    	top.location.replace(self.location)
			}
		</script>
	</cfif>

	<!--- <cfif cgi.http_user_agent contains 'msie'> --->
	<!--[if IE]>
		<link href="#application.configBean.getContext()#/admin/assets/css/ie/ie.min.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
		<script src="#application.configBean.getContext()#/admin/assets/js/mura-font-lte-ie7.js" type="text/javascript"></script>
	<![endif]-->
	
	<!--[if IE 7]>
	<link rel="stylesheet" href="#application.configBean.getContext()#/admin/assets/css/font-awesome-ie7.css">
	<![endif]-->
	
	<!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="#application.configBean.getContext()#/admin/assets/js/html5.js"></script>
    <![endif]-->
	<!--- </cfif> --->
    #rc.$.renderEvent('onAdminHTMLHeadRender')#
  </head>
  <body id="#rc.originalcircuit#">
    <cfinclude template="includes/header.cfm">
    <div class="main">
      <div class="main-inner">
         <div class="container">
         		<cfif request.action neq "core:cLogin.main" and rc.renderMuraAlerts>
	         		<cfif isdefined('session.siteID') and isdefined('session.alerts') and structKeyExists(session.alerts,'#session.siteid#')
	         			and (listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2'))>
	         			
	         			<cfif isdefined('session.hasdefaultpassword') and not structKeyExists(session.alerts['#session.siteID#'],'defaultpasswordnotice')>
	         					<div class="alert alert-error">#application.rbFactory.getKeyValue(session.rb,"layout.defaultpasswordnotice")#
				           	<a href="##" data-alertid="defaultpasswordnotice" class="close alert-dismiss" data-dismiss="alert"><i class="icon-remove-sign"></i></a></div>
	         			</cfif>
	         			<cfif not application.settingsManager.getSite(session.siteID).getCache() and not structKeyExists(session.alerts['#session.siteID#'],'cachenotice')>
				           	<div class="alert">#application.rbFactory.getKeyValue(session.rb,"layout.cachenotice")#
				           	<a href="##" data-alertid="cachenotice" class="close alert-dismiss" data-dismiss="alert"><i class="icon-remove-sign"></i></a></div>
			           	</cfif>
			           	<script>
			           		$(document).ready(function(){
			           			$('.alert-dismiss').click(
			           				function(){
			           					var _alert=this;
			           					$.ajax(
			           						{
				           						url:'./index.cfm',
				           						data:{
				           							siteid:'#JSStringFormat(session.siteid)#',
				           							alertid:$(_alert).attr('data-alertid'),
				           							muraaction:'cdashboard.dismissAlert'
				           						},
				           						success: function(){
				           							$(_alert).parent('.alert').fadeOut();
				           							//$('##system-notice').html(data);
			           							}
			           						}
			           					);
			           				}
			           			);
			           		});
			           	</script>
	         			
	         		</cfif>
         		</cfif>
         	<div class="row-fluid">
         		<cfif request.action neq "core:cDashboard.main" 
         			and request.action neq "core:cLogin.main">
         			<div class="span12">
         		</cfif>
         		#body#
         		<cfif request.action neq "core:cDashboard.main"
         			and request.action neq "core:cLogin.main">
         			</div>
         		</cfif>
         	</div> <!-- /row -->
         </div> <!-- /container -->
      </div> <!-- /main-inner -->
    </div> <!-- /main -->  
    
    <!---
    <script type="text/javascript">
		stripe('stripe');
	</script>
	
	<cfif rc.originalcircuit neq 'cLogin' and yesNoFormat(application.configBean.getValue("sessionTimeout"))>
		<script type="text/javascript">
			window.setTimeout('CountDown()',100);
		</script>
	</cfif>	
	--->
	<cfif cgi.http_user_agent contains 'msie'>
		<!--[if LTE IE 7]>
		<script type="text/javascript" src="#application.configBean.getContext()#/admin/assets/js/uprgade-notification.min.js"></script>
		<![endif]-->
	</cfif>
    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="#application.configBean.getContext()#/admin/assets/bootstrap/js/bootstrap.min.js"></script>
    <script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery-tagselector.js?coreversion=#application.coreversion#"></script>
  	<cfif rc.originalcircuit eq "cArch" and (rc.originalfuseaction eq "list" or rc.originalfuseaction eq "search") and (rc.moduleid eq '00000000000000000000000000000000000' or rc.moduleid eq '')>
	<cfinclude template="/muraWRM/admin/core/views/carch/dsp_content_nav.cfm">
	</cfif>
	<cfinclude template="includes/dialog.cfm">
	#rc.$.renderEvent('onAdminHTMLFootRender')#
  </body>
</html>
</cfoutput>
