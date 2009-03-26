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
<cfparam name="form.ccself" default=0>
<cfif form.sendto2 neq ''><cfset form.sendto1=listappend(form.sendto1,form.sendto2)></cfif>
<cfif form.sendto3 neq ''><cfset form.sendto1=listappend(form.sendto1,form.sendto3)></cfif>
<cfif form.ccself><cfset form.sendto1=listappend(form.sendto1,form.email)></cfif>
<cfset newline=Chr(13) & Chr(10)>
<cfset site = application.settingsManager.getSite(request.siteID) />
<cfset success=true/>
<cftry>
<cfsavecontent variable="notifyText"><cfoutput>
<cfif form.comments neq ''>
#form.comments##newline##newline#</cfif>
#form.fname# #form.lname# would like to share this article with you. Just click the link below to view the selection.

#link#

If the link doesn't work, copy and paste the full URL of the link (with no line breaks or carriage returns) into your browser's address field and hit Enter.
</cfoutput></cfsavecontent>
<cfset email=application.serviceFactory.getBean('mailer') />
<cfset email.sendText(notifyText,
				form.sendto1,
				form.email,
				site.getSite(),
				request.siteid,
				form.email) />
<cfcatch>
<cfset success=false/>
</cfcatch>
</cftry>
</cfsilent>
<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<title>#application.settingsManager.getSite(request.siteID).getSite()# - Send to a Friend</title>
<link rel="stylesheet" href="#application.configBean.getContext()#/#request.siteid#/css/style.css" type="text/css" media="all" />
</head>

<body id="svSendToFriend">
<cfif success>
<h1 class="success">Your Link Has Been Sent.</h1>   
<cfelse>
<h1 class="error">An Error has Occured, Please Check Site Settings.</h1>  
</cfif>
</body>
</html>
</cfoutput>