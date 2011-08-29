<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfsilent>
<cfparam name="attributes.jsLib" default="prototype">
<cfparam name="attributes.jsLibLoaded" default="false">
<cfparam name="attributes.activetab" default="0">
<cfparam name="attributes.activepanel" default="0">
<cfparam name="attributes.siteid" default='#session.siteID#'>
<cfparam name="application.coreversion" default="#application.serviceFactory.getBean('autoUpdater').getCurrentVersion()#">
<!--- This code is just to prevent errors when people update past version 5.2.2652 --->
<cfif not len(attributes.siteID)>
<cfset attributes.siteID="default">
</cfif>
</cfsilent>
<cfoutput><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<cfsilent>
<cfparam name="moduleTitle" default="">
<cfif not len(moduleTitle)>
<cfswitch expression="#myfusebox.originalcircuit#">
<cfcase value="cArch">
	<cfswitch expression="#attributes.moduleID#">
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
</cfsilent>

<title>#application.configBean.getTitle()#<cfif len(moduleTitle)> - #HTMLEditFormat(moduleTitle)#</cfif></title>
<link rel="icon" href="#application.configBean.getContext()#/admin/images/favicon.ico" type="image/x-icon" />
<link rel="shortcut icon" href="#application.configBean.getContext()#/admin/images/favicon.ico" type="image/x-icon" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate"> 
<cfheader name="expires" value="06 Nov 1994 08:37:34 GMT"> 
<meta name="robots" content="noindex, nofollow, noarchive" />
<meta http-equiv="cache control" content="no-cache, no-store, must-revalidate" />
<script src="#application.configBean.getContext()#/admin/js/jquery/jquery.js?coreversion=#application.coreversion#" type="text/javascript"></script>
<script src="#application.configBean.getContext()#/admin/js/jquery/jquery.collapsibleCheckboxTree.js?coreversion=#application.coreversion#" type="text/javascript"></script>
<script src="#application.configBean.getContext()#/admin/js/jquery/jquery-ui.js?coreversion=#application.coreversion#" type="text/javascript"></script>
<script src="#application.configBean.getContext()#/admin/js/jquery/jquery-ui-i18n.js?coreversion=#application.coreversion#" type="text/javascript"></script>
<link href="#application.configBean.getContext()#/admin/css/jquery/default/jquery.ui.all.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
<cfif not attributes.jsLibLoaded and attributes.jsLib eq "prototype">
<script src="#application.configBean.getContext()#/admin/js/prototype.js" type="text/javascript" language="Javascript"></script>
</cfif>
<script src="#application.configBean.getContext()#/admin/js/admin.js?coreversion=#application.coreversion#" type="text/javascript" language="Javascript"></script>
<cfif application.configBean.getValue("htmlEditorType") eq "fckeditor">
<script type="text/javascript" src="#application.configBean.getContext()#/wysiwyg/fckeditor.js"></script>
<cfelse>
<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/ckeditor/adapters/jquery.js"></script>
<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/ckfinder/ckfinder.js"></script>
</cfif>
<script type="text/javascript">
var htmlEditorType='#application.configBean.getValue("htmlEditorType")#';
var context='#application.configBean.getContext()#';
var themepath='#application.settingsManager.getSite(attributes.siteID).getThemeAssetPath()#';
var rb='#lcase(session.rb)#';
var siteid='#session.siteid#';
var sessionTimeout=<cfif isNumeric(application.configBean.getValue('sessionTimeout'))>#evaluate("application.configBean.getValue('sessionTimeout') * 60")#<cfelse>180</cfif>;
</script>
#session.dateKey#
<script type="text/javascript">
	jQuery(document).ready(function(){setDatePickers(".datepicker",dtLocale);setTabs(".tabs",#attributes.activeTab#);setHTMLEditors();setAccordions(".accordion",#attributes.activePanel#);setCheckboxTrees();});
</script>
#fusebox.ajax#
<cfif myfusebox.originalcircuit neq "cLogin">
<script language="JavaScript">
if (top.location != self.location) {
    top.location.replace(self.location)
}
</script>

</cfif>
<link href="#application.configBean.getContext()#/admin/css/admin.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
<cfif cgi.http_user_agent contains 'msie'>
<!--[if LTE IE 7]>
	<link href="#application.configBean.getContext()#/admin/css/ie.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
<![endif]-->
<!--[if IE 6]>
	<script src="#application.configBean.getContext()#/admin/js/DD_belatedPNG.js"></script>
	<script>
		//DD_belatedPNG.fix('##header h1,##navUtility ##navAdminUsers a,##navUtility ##navSiteSettings a,##navUtility ##navEditProfile a,##navUtility ##navHelp a');
		DD_belatedPNG.fix('##header h1');
	</script>
<![endif]-->
</cfif>
<cfif myfusebox.originalcircuit eq "cArch" and (myfusebox.originalfuseaction eq "list" or myfusebox.originalfuseaction eq "search") and (attributes.moduleid eq '00000000000000000000000000000000000' or attributes.moduleid eq '')>
<cfinclude template="../../view/vArchitecture/dsp_content_nav.cfm">
</cfif>
<cfinclude template="dialog.cfm">
</head>
<body id="#myfusebox.originalcircuit#" >
<cfinclude template="header.cfm">

<div id="container"><div id="navigation" class="sidebar">
<cfset hidelist="cLogin">
<cfif not listfindNoCase(hidelist,myfusebox.originalcircuit)><cfinclude template="dsp_secondary_menu_main.cfm"></cfif>
<cfif session.mura.isLoggedIn>
<p id="copyright"><!--- &copy; 2001-#year(now())#<br /> --->
Core Version #application.autoUpdater.getCurrentCompleteVersion()#<br />
Site Version #application.autoUpdater.getCurrentCompleteVersion(session.siteid)#<br /><br />
<cfif application.configBean.getMode() eq 'Staging' and session.siteid neq '' and not listfind(hidelist,myfusebox.originalcircuit)>
Last Deployment:<br/>
<cftry>
#LSDateFormat(application.settingsManager.getSite(session.siteid).getLastDeployment(),session.dateKeyFormat)# #LSTimeFormat(application.settingsManager.getSite(session.siteid).getLastDeployment(),"short")#
<cfcatch>
Never
</cfcatch>
</cftry>
</cfif>
</p><cfelse>&nbsp;</cfif></div>
<div id="content">#fusebox.layout#
</div></div>
<script type="text/javascript" language="javascript">
stripe('stripe');
</script>
<cfif  myfusebox.originalcircuit neq 'cLogin' and yesNoFormat(application.configBean.getValue("sessionTimeout"))>
<script type="text/javascript" language="javascript">
window.setTimeout('CountDown()',100);
</script>
</cfif>
<cfif cgi.http_user_agent contains 'msie'>
<!--[if IE 6]>
<script type="text/javascript" src="#application.configBean.getContext()#/admin/js/ie6notice.js"></script>
<![endif]-->
</cfif>
</body>
</html></cfoutput>