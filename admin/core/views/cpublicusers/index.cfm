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

<cfparam name="url.groupid" default="">
<cfparam name="url.s2" default="0">
<cfparam name="form.search" default="">
<cfset rsList = application.serviceFactory.getBean('userGateway').getSearch(form.search, url.siteid, 1)>
<html>

<head><cfoutput>
<title>#application.rbFactory.getKeyValue(session.rb,'user.selectuser')#</title>
<link href="#application.configBean.getContext()#/admin/assets/css/admin.min.css" rel="stylesheet" type="text/css" />

<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery.js?coreversion=#application.coreversion#" type="text/javascript"></script>
<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery-ui.js?coreversion=#application.coreversion#" type="text/javascript"></script>
<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery-ui-i18n.js?coreversion=#application.coreversion#" type="text/javascript"></script>
<!--- <link href="#application.configBean.getContext()#/admin/assets/less/jquery.ui.less" rel="stylesheet/less" type="text/css" /> --->
<script src="#application.configBean.getContext()#/admin/assets/js/admin.js?coreversion=#application.coreversion#" type="text/javascript"></script>
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
var sessionTimeout=#evaluate("application.configBean.getValue('sessionTimeout') * 60")#;
</script>
#session.dateKey#
<script type="text/javascript">
	jQuery(document).ready(
		function(){
			setDatePickers(".datepicker",dtLocale);
			setTabs(".tabs",0);
			setHTMLEditors();
			setAccordions(".accordion",0);
			setToolTips(".container");
		});
</script>
<script type="text/javascript">
<!--

if (window.opener)	{
	mainwin = window.opener;
}

function goAndClose(userid)	{
	<cfoutput>
	mainwin.location.href='../../index.cfm?muraAction=cPublicUsers.addtogroup&groupid=#URLEncodedFormat(url.groupid)#&routeid=#URLEncodedFormat(url.groupid)#&siteid=#URLEncodedFormat(url.siteid)#&userid='+userid;
	</cfoutput>
	window.close();
}

//-->
</script>
</cfoutput>
<link href="../../css/admin.min.css" rel="stylesheet" type="text/css">
<!--[if IE]>
<link href="../../css/ie.css" rel="stylesheet" type="text/css" />
<![endif]-->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body id="popUp"><cfoutput>
<h1>#application.rbFactory.getKeyValue(session.rb,'user.selectuser')#</h1>
<form novalidate="novalidate" name="form1" method="post" action="" id="siteSearch" onSubmit="return validate(this);">

	<div class="input-append">
	    <input name="search" style="width: 208px;" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'user.lastnameorcompanyrequired')#" type="text" />
	    <button type="button" class="btn" onclick="submitForm(document.forms.form1);" value="#application.rbFactory.getKeyValue(session.rb,'user.search')#" /><i class="icon-search"></i></button>
	</div>

<!---
<input name="search" style="width: 208px;" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'user.lastnameorcompanyrequired')#">
<input type="button" class="submit" onClick="submitForm(document.forms.form1);" value="#application.rbFactory.getKeyValue(session.rb,'user.search')#" />
--->

</form></cfoutput>
<cfif rslist.recordcount>
<table class="mura-table-grid"><cfoutput>
<tr><th>#application.rbFactory.getKeyValue(session.rb,'user.name')#</th>
</tr></cfoutput>
  <cfoutput query="rslist"> 
    <tr <cfif not rslist.currentrow mod 2>class="alt"</cfif>>
        <td class="title"><a href="" target="mainwin" onClick="goAndClose('#userid#'); return(false);">#lname#, #fname# <cfif company neq ''> (#company#)</cfif></a></td>
    </tr>
  </cfoutput> 
</table>
<cfelseif form.search neq ''>
<div class="separate"></div>
<cfoutput>
<div class="alert">#application.rbFactory.getKeyValue(session.rb,'user.nosearchresults')#.</div></cfoutput>
</cfif>
</body>
</html>