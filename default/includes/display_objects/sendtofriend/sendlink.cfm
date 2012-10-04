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

<cfsilent>
<cfset $=application.serviceFactory.getBean('MuraScope').init(form.siteID)>
<cfset rbFactory=$.siteConfig('RBFactory') />
<cfparam name="form.ccself" default=0>
<cfif form.sendto2 neq ''><cfset form.sendto1=listappend(form.sendto1,form.sendto2)></cfif>
<cfif form.sendto3 neq ''><cfset form.sendto1=listappend(form.sendto1,form.sendto3)></cfif>
<cfif form.ccself><cfset form.sendto1=listappend(form.sendto1,form.email)></cfif>
<cfset newline=Chr(13) & Chr(10)>
<cfset success=true/>
<cfset passedProtect=false/>
<cftry>
<cfif not $.currentUser().isLoggedIn()>
	<cfthrow message="User must be logged in">
</cfif>
<cfset variables.cffp = CreateObject("component","cfformprotect.cffpVerify").init() />
<cfif $.siteConfig().getContactEmail() neq "">
	<cfset variables.cffp.updateConfig('emailServer', $.siteConfig().getMailServerIP())>
	<cfset variables.cffp.updateConfig('emailUserName', $.siteConfig().getMailserverUsername(true))>
	<cfset variables.cffp.updateConfig('emailPassword', $.siteConfig().getMailserverPassword())>
	<cfset variables.cffp.updateConfig('emailFromAddress', $.siteConfig().getMailserverUsernameEmail())>
	<cfset variables.cffp.updateConfig('emailToAddress', $.siteConfig().getContactEmail())>
	<cfset variables.cffp.updateConfig('emailSubject', 'Spam form submission')>
</cfif>

<cfset passedProtect=variables.cffp.testSubmission(form)>
<cfif not passedProtect>
	<cfthrow message="Spam form submission">
</cfif>

<cfsavecontent variable="notifyText"><cfoutput>
<cfif form.comments neq ''>
#form.comments##newline##newline#</cfif>
#rbFactory.getResourceBundle().messageFormat($.rbKey('stf.sentence1'),'#form.fname# #form.lname#')#

#link#

#$.rbKey('stf.sentence2')#
</cfoutput>
</cfsavecontent>

<cfset email=application.serviceFactory.getBean('mailer') />
<cfset email.sendText(notifyText,
				form.sendto1,
				form.email,
				$.siteConfig('site'),
				$.event('siteID'),
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
		<title>#$.siteConfig('site')# - #$.rbKey('stf.sendtoafriend')#</title>
		<link rel="stylesheet" href="#$.siteConfig('assetPath')#/css/mura.min.css" type="text/css" media="all" />
	</head>

	<body id="svSendToFriend">
		<cfif not passedProtect>
			<h1 class="success">#$.rbKey('captcha.spam')#</h1>
		<cfelse>
			<cfif success>
				<h1 class="success">#$.rbKey('stf.yourlinkhasbeensent')#</h1>   
			<cfelse>
				<h1 class="error">#$.rbKey('stf.error')#</h1>  
			</cfif>
		</cfif>
	</body>
</html>
</cfoutput>