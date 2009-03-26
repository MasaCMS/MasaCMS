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
<cfsilent>
<cfscript>
	if (NOT IsDefined("request"))
	 request=structNew();
	StructAppend(request, url, "no");
	StructAppend(request, form, "no");
</cfscript>
<cfset rbFactory=application.settingsManager.getSite(request.siteid).getRBFactory() />
</cfsilent>
<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />

<title>#application.settingsManager.getSite(request.siteID).getSite()# - #rbFactory.getKey('stf.sendtoafriend')#</title>

<link rel="stylesheet" href="#application.configBean.getContext()#/#request.siteid#/css/style.css" type="text/css" media="all" />
</head>

<body id="svSendToFriend">

<cfform name="sendtofriend" method="post" action="sendlink.cfm">
<fieldset>
<legend>#rbFactory.getKey('stf.sendtoafriend')#</legend>
<input type="hidden" name="link" value="#url.link#">
<ol>
<li class="req"><label>#rbFactory.getKey('stf.fname')#<ins> (#rbFactory.getKey('stf.required')#)</ins></label><cfinput type="text"  name="fname" required="yes" message="#rbFactory.getKey('stf.fnamerequired')#" size="20" maxlength="16" value="" class="text"></li>
<li class="req"><label>#rbFactory.getKey('stf.lname')#<ins> (#rbFactory.getKey('stf.required')#)</ins></label><cfinput type="text" name="lname" message="#rbFactory.getKey('stf.lnamerequired')#" required="yes" size="20" maxlength="16" value="" class="text" /></li>
<li class="req"><label>#rbFactory.getKey('stf.email')#<ins> (#rbFactory.getKey('stf.required')#)</ins></label><cfinput type="text" name="email" message="#rbFactory.getKey('stf.emailrequired')#"  required="yes" size="20" maxlength="47" value="" class="text" /></li>
<li><label>#rbFactory.getKey('stf.copyme')#</label><input type="checkbox" name="ccself" value="1"></li>
<li><label>#rbFactory.getKey('stf.recipientaddresses')#</label>
	<ul class="multiInputs">
	<li><span class="req"><cfinput type="text" name="sendto1" size="20" required="yes" message="#rbFactory.getKey('stf.recipientrequired')#" maxlength="47" value="" class="text" /><ins> (#rbFactory.getKey('stf.required')#)</ins></span></li>
	<li><input type="text" name="sendto2" size="20" maxlength="47" value="" class="text" /></li>
	<li><input type="text" name="sendto3" size="20" maxlength="47" value="" class="text" /></li>
	</ul>
</li>
<li><label>#rbFactory.getKey('stf.message')#</label><textarea rows="3" name="comments" cols="35"></textarea></li>
</ol>
<input type="hidden" name="siteID" value="#request.siteID#"/>
</fieldset>
<div class="buttons"><input type="submit" name="btn_submit" value="#htmlEditFormat(rbFactory.getKey('stf.send'))#" alt="send" class="submit"></div>
</cfform>
<script type="text/javascript"><!-- document.sendtofriend.fname.focus(); // --></script>

</body>
</html>
</cfoutput>