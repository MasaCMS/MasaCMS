<cfoutput><html lang="#HTMLEditFormat(session.locale)#">
  <head>
  	<cfsilent>
  		<cfparam name="request.action" default="core:cplugin.plugin">
  		<cfparam name="rc.originalfuseaction" default="#listLast(listLast(request.action,":"),".")#">
		<cfparam name="rc.originalcircuit"  default="#listFirst(listLast(request.action,":"),".")#">
	  	<cfparam name="rc.jsLib" default="jquery">
		<cfparam name="rc.jsLibLoaded" default="false">
		<cfparam name="rc.activetab" default="0">
		<cfparam name="rc.activepanel" default="0">
		<cfparam name="rc.siteid" default='#session.siteID#'>
		<cfparam name="application.coreversion" default="#application.serviceFactory.getBean('autoUpdater').getCurrentVersion()#">
		<!--- This code is just to prevent errors when people update past version 5.2.2652 --->
		<cfif not len(rc.siteID)>
		<cfset rc.siteID="default">
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
			<cfset moduleTitle="Drafts">
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
    <meta charset="utf-8">
    <title>#application.configBean.getTitle()#<cfif len(moduleTitle)> - #HTMLEditFormat(moduleTitle)#</cfif></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="robots" content="noindex, nofollow, noarchive" />
	<meta http-equiv="cache control" content="no-cache, no-store, must-revalidate" />

    <!-- Le styles -->
    <link href="#application.configBean.getContext()#/admin/assets/css/bootstrap.css" rel="stylesheet">
    <link href="#application.configBean.getContext()#/admin/assets/css/bootstrap-responsive.css" rel="stylesheet">

    <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <!-- Le fav and touch icons -->
    <link rel="shortcut icon" href="#application.configBean.getContext()#/admin/assets/ico/favicon.ico">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="#application.configBean.getContext()#/admin/assets/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="#application.configBean.getContext()#/admin/assets/ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="#application.configBean.getContext()#/admin/assets/ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="#application.configBean.getContext()#/admin/assets/ico/apple-touch-icon-57-precomposed.png">
    <!-- -->
    
    <script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery.js?coreversion=#application.coreversion#" type="text/javascript"></script>
	<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery.collapsibleCheckboxTree.js?coreversion=#application.coreversion#" type="text/javascript"></script>
	<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery-ui.js?coreversion=#application.coreversion#" type="text/javascript"></script>
	<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery-ui-i18n.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>
	<link href="#application.configBean.getContext()#/admin/assets/css/jquery/default/jquery.ui.all.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
	<script src="#application.configBean.getContext()#/admin/assets/js/admin.js?coreversion=#application.coreversion#" type="text/javascript" language="Javascript"></script>
	<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/ckeditor/adapters/jquery.js"></script>
	<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/ckfinder/ckfinder.js"></script>
	<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/miniColors/jquery.miniColors.min.js?coreversion=#application.coreversion#"></script>
	<link href="#application.configBean.getContext()#/tasks/widgets/miniColors/jquery.miniColors.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
	<script src="#application.configBean.getContext()#/admin/assets/js/json2.js" type="text/javascript" language="Javascript"></script>
	

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
				setTabs(".nav-tabs",#rc.activeTab#);
				setHTMLEditors();
				setAccordions(".accordion",#rc.activePanel#);
				setCheckboxTrees();
				setColorPickers(".colorpicker");
				setToolTips(".container");
			});
	</script>

	#rc.ajax#

	<cfif rc.originalcircuit neq "cLogin">
		<script language="JavaScript">
		if (top.location != self.location) {
		    	top.location.replace(self.location)
			}
		</script>
	</cfif>

	<!---
	<link href="#application.configBean.getContext()#/admin/assets/css/admin.min.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
	<cfif cgi.http_user_agent contains 'msie'>
	<!--[if LTE IE 7]>
		<link href="#application.configBean.getContext()#/admin/assets/css/ie.min.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
	<![endif]-->
	<!--[if IE 6]>
		<script src="#application.configBean.getContext()#/admin/assets/js/DD_belatedPNG.js"></script>
		<script>
			//DD_belatedPNG.fix('##header h1,##navUtility ##navAdminUsers a,##navUtility ##navSiteSettings a,##navUtility ##navEditProfile a,##navUtility ##navHelp a');
			DD_belatedPNG.fix('##header h1');
		</script>
	<![endif]-->
	</cfif>
	--->
  </head>
  <body id="#rc.originalcircuit#">
    <cfinclude template="includes/header.cfm">
    <div class="container">

      <div class="row">
        <div class="span12">
        <cfif rc.originalcircuit neq 'cLogin'>
	         <cftry><cfset siteName=application.settingsManager.getSite(session.siteid).getSite()><cfif len(siteName)><p id="currentSite">#application.rbFactory.getKeyValue(session.rb,"layout.currentsite")# &rarr; <a href="http://#application.settingsManager.getSite(session.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.configBean.getStub()#/<cfif application.configBean.getSiteIDInURLS()>#session.siteid#/</cfif>" target="_blank">#application.settingsManager.getSite(session.siteid).getSite()#</a></p></cfif><cfcatch></cfcatch></cftry>
	        <p id="welcome">
	          <strong>#application.rbFactory.getKeyValue(session.rb,"layout.welcome")#, #HTMLEditFormat("#session.mura.fname# #session.mura.lname#")#.</strong>
	          <cfif yesNoFormat(application.configBean.getValue("sessionTimeout"))> 
	              #application.rbFactory.getKeyValue(session.rb,"layout.loggedoutin")# <span id="clock">0:00:00</span>.
	          </cfif>
	        </p>
        </cfif>
          #body#
        </div>  
      </div>

      <hr>

      <footer>
        <p>&copy; Company 2012</p>
      </footer>

    </div> <!-- /container -->  
    <script type="text/javascript" language="javascript">
		stripe('stripe');
	</script>
	<cfif rc.originalcircuit neq 'cLogin' and yesNoFormat(application.configBean.getValue("sessionTimeout"))>
		<script type="text/javascript" language="javascript">
			window.setTimeout('CountDown()',100);
		</script>
	</cfif>	
	<cfif cgi.http_user_agent contains 'msie'>
		<!--[if IE 6]>
		<script type="text/javascript" src="#application.configBean.getContext()#/admin/assets/js/ie6notice.js"></script>
		<![endif]-->
	</cfif>
    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="#application.configBean.getContext()#/admin/assets/bootstrap/js/bootstrap-transition.js"></script>
    <script src="#application.configBean.getContext()#/admin/assets/bootstrap/js/bootstrap-alert.js"></script>
    <script src="#application.configBean.getContext()#/admin/assets/bootstrap/js/bootstrap-modal.js"></script>
    <script src="#application.configBean.getContext()#/admin/assets/bootstrap/js/bootstrap-dropdown.js"></script>
    <script src="#application.configBean.getContext()#/admin/assets/bootstrap/js/bootstrap-scrollspy.js"></script>
    <script src="#application.configBean.getContext()#/admin/assets/bootstrap/js/bootstrap-tab.js"></script>
    <script src="#application.configBean.getContext()#/admin/assets/bootstrap/js/bootstrap-tooltip.js"></script>
    <script src="#application.configBean.getContext()#/admin/assets/bootstrap/js/bootstrap-popover.js"></script>
    <script src="#application.configBean.getContext()#/admin/assets/bootstrap/js/bootstrap-button.js"></script>
    <script src="#application.configBean.getContext()#/admin/assets/bootstrap/js/bootstrap-collapse.js"></script>
    <script src="#application.configBean.getContext()#/admin/assets/bootstrap/js/bootstrap-carousel.js"></script>
    <script src="#application.configBean.getContext()#/admin/assets/bootstrap/js/bootstrap-typeahead.js"></script>
  	<cfif rc.originalcircuit eq "cArch" and (rc.originalfuseaction eq "list" or rc.originalfuseaction eq "search") and (rc.moduleid eq '00000000000000000000000000000000000' or rc.moduleid eq '')>
		<cfinclude template="/muraWRM/admin/core/views/carch/dsp_content_nav.cfm">
	</cfif>
	<cfinclude template="includes/dialog.cfm">
  </body>
</html>
</cfoutput>
