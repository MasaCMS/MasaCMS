<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->

<cfparam name="url.groupid" default="">
<cfparam name="url.s2" default="0">
<cfparam name="form.search" default="">
<cfquery name="rsList" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
Select userid, fname, lname, company from tusers where type=2 and siteid='#application.settingsManager.getSite(url.siteid).getPublicUserPoolID()#' and ispublic=1 and 
<cfif trim(form.search) neq ''>
(lname like '%#form.search#%' or company like '%#form.search#%' )
<cfelse>
0=1
</cfif>
order by lname
</cfquery>

<html>

<head><cfoutput>
<title>#application.rbFactory.getKeyValue(session.rb,'user.selectuser')#</title>

<script src="#application.configBean.getContext()#/admin/js/admin.js" type="text/javascript" language="Javascript">
<!--
//-->
</script>
<script src="#application.configBean.getContext()#/admin/js/prototype.js" type="text/javascript" language="Javascript"></script>
<script language="JavaScript" type="text/javascript">
<!--

if (window.opener)	{
	mainwin = window.opener;
}

function goAndClose(userid)	{
	<cfoutput>
	mainwin.location.href='../../index.cfm?fuseaction=cPublicUsers.addtogroup&groupid=#url.groupid#&routeid=#url.groupid#&siteid=#url.siteid#&userid='+userid;
	</cfoutput>
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
<form name="form1" method="post" action="" id="siteSearch" onSubmit="return validate(this);"><label>#application.rbFactory.getKeyValue(session.rb,'user.lastnameorcompany')#</label>
<input name="search" style="width: 208px;" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'user.lastnameorcompanyrequired')#"> <a class="submit" href="javascript:;" onClick="return submitForm(document.forms.form1);"><span>#application.rbFactory.getKeyValue(session.rb,'user.search')#</span></a></form></cfoutput>
<cfif rslist.recordcount>
<div class="separate"></div>
<table id="metadata"><cfoutput>
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
<table id="metadata"><cfoutput>
<tr><th>#application.rbFactory.getKeyValue(session.rb,'user.name')#</th></tr>
    <tr>
        <td class="title"><em>#application.rbFactory.getKeyValue(session.rb,'user.nosearchresults')#.</em></td>
    </tr></cfoutput>
</table>
</cfif>
</body>
</html>