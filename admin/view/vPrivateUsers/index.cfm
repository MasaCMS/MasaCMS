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

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfparam name="url.groupid" default="">
<cfparam name="url.s2" default="0">
<cfparam name="form.search" default="">
<cfset rsList = application.serviceFactory.getBean('userGateway').getSearch(form.search, url.siteid, 0)>
<html>

<head><cfoutput>
<title>#application.rbFactory.getKeyValue(session.rb,'user.selectuser')#</title>
<script src="#application.configBean.getContext()#/admin/js/jquery/jquery.js?coreversion=#application.coreversion#" type="text/javascript"></script>
<script src="#application.configBean.getContext()#/admin/js/jquery/jquery-ui.js?coreversion=#application.coreversion#" type="text/javascript"></script>
<script src="#application.configBean.getContext()#/admin/js/jquery/jquery-ui-i18n.js?coreversion=#application.coreversion#" type="text/javascript"></script>
<link href="#application.configBean.getContext()#/admin/css/jquery/default/jquery.ui.all.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
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
var themepath='#application.settingsManager.getSite(session.siteID).getThemeAssetPath()#';
var rb='#lcase(session.rb)#';
var sessionTimeout=<cfif isNumeric(application.configBean.getValue('sessionTimeout'))>#evaluate("application.configBean.getValue('sessionTimeout') * 60")#<cfelse>180</cfif>;
</script>
#session.dateKey#
<script type="text/javascript">
	jQuery(document).ready(function(){setDatePickers(".datepicker",dtLocale);setTabs(".tabs",0);setHTMLEditors();setAccordions(".accordion",0)});
</script>
<script language="JavaScript" type="text/javascript">
<!--

if (window.opener)	{
	mainwin = window.opener;
}

function goAndClose(userid)	{

	mainwin.location.href='../../index.cfm?fuseaction=cPrivateUsers.addtogroup&siteid=#URLEncodedFormat(url.siteid)#&groupid=#URLEncodedFormat(url.groupid)#&routeid=#URLEncodedFormat(url.groupid)#&userid='+userid;

	window.close();
}

//-->
</script>
</cfoutput>
<link href="../../css/admin.css" rel="stylesheet" type="text/css">
<!--[if IE]>
<link href="../../css/ie.css" rel="stylesheet" type="text/css" />
<![endif]-->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>
<body id="popUp"><cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,'user.selectuser')#</h2>
<form novalidate="novalidate" name="form1" method="post" action="" id="siteSearch" onSubmit="return validate(this);"><label>#application.rbFactory.getKeyValue(session.rb,'user.lastnameorcompany')#</label>
<input name="search"style="width: 208px;" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'user.lastnameorcompanyrequired')#"> <a class="submit" href="javascript:;" onClick="return submitForm(document.forms.form1);"><span>#application.rbFactory.getKeyValue(session.rb,'user.search')#</span></a>
</form></cfoutput>
<cfif rslist.recordcount>
<div class="separate"></div>
<table id="metadata"><cfoutput>
<tr><th>#application.rbFactory.getKeyValue(session.rb,'user.name')#</th></tr></cfoutput>
  <cfoutput query="rslist">
    <tr <cfif not rslist.currentrow mod 2>class="alt"</cfif>>
        <td class="title"><a href="" target="mainwin" onClick="goAndClose('#userid#'); return(false);">#lname#, #fname# <cfif company neq ''> (#company#)</cfif></a></td>
    </tr>
  </cfoutput> 
</table>
<cfelseif form.search neq ''>
<div class="separate"></div>
<table id="metadata"><cfoutput>
<tr><th>#application.rbFactory.getKeyValue(session.rb,'user.name')#</th></tr>
    <tr>
        <td class="title"><em>#application.rbFactory.getKeyValue(session.rb,'user.nosearchresults')#</em></td>
    </tr></cfoutput>
</table>
</cfif>
</body>
</html>