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

<cfparam name="request.copyEmail" default="false">
<cfparam name="request.sendto" default="">
<cfparam name="request.email" default="">
<cfparam name="request.hkey" default="">
<cfparam name="request.ukey" default="">
<cfparam name="acceptError" default="">

<cfset variables.passedProtect = true>
<cfscript>
	variables.myRequest = structNew();
	StructAppend(variables.myRequest, url, "no");
	StructAppend(variables.myRequest, form, "no");
</cfscript>

<cfif structKeyExists(variables.myRequest, "useProtect")>
	<cfset variables.cffp = CreateObject("component","cfformprotect.cffpVerify").init() />
	<cfif len(variables.rsform.responseSendTo)>
		<cfset variables.cffp.updateConfig('emailServer', application.settingsManager.getSite($.event('siteID')).getMailServerIP())>
		<cfset cffp.updateConfig('emailUserName', application.settingsManager.getSite($.event('siteID')).getMailserverUsername(true))>
		<cfset variables.cffp.updateConfig('emailPassword', application.settingsManager.getSite($.event('siteID')).getMailserverPassword())>
		<cfset variables.cffp.updateConfig('emailFromAddress', application.settingsManager.getSite($.event('siteID')).getMailserverUsernameEmail())>
		<cfset variables.cffp.updateConfig('emailToAddress', variables.rsform.responseSendTo)>
		<cfset variables.cffp.updateConfig('emailSubject', 'Spam form submission')>
	</cfif>
	<cfset variables.passedProtect = variables.cffp.testSubmission(variables.myRequest)>
</cfif>

<cfif (request.hkey eq '' or request.hKey eq hash(lcase(request.ukey))) and variables.passedProtect>
	<cfif variables.rsform.responseChart>
		<cfif refind("Mac",cgi.HTTP_USER_AGENT) and refind("MSIE 5",cgi.HTTP_USER_AGENT)>
			<cfset variables.acceptdata=0>
			<cfset variables.acceptError="Browser">  
		<cfelse>
			<cfif not isdefined('cookie.poll')>
				<cfset cookie.poll="#arguments.objectid#">
			<cfelseif isdefined('cookie.poll') and listfind(cookie.poll,arguments.objectid)>
				<cfset variables.acceptdata=0> 
				<cfset variables.acceptError="Duplicate"> 
			<cfelseif isdefined('cookie.poll') and not listfind(cookie.poll,arguments.objectid)>
				<cfset variables.templist=cookie.poll>
				<cfif listlen(variables.templist) eq 6>
					<cfset variables.templist=listdeleteat(variables.templist,1)>
				</cfif>
				<cfset variables.templist=listappend(variables.templist,arguments.objectid)>
				<cfset cookie.poll="#templist#">
			</cfif>
		</cfif>
	</cfif>
<cfelse>
	<cfset variables.acceptdata=0>
	<cfif variables.passedProtect>
		<cfset variables.acceptError="Captcha"> 
	<cfelse>
		<cfset variables.acceptError="Spam">	
	</cfif>
</cfif>

<cfif structKeyExists(request,"fieldnameOrder")>
	<cfset request.fieldnames=""/>
	
	<cfloop list="#request.fieldnameOrder#" index="variables.i">
		<cfif structKeyExists(form, i)>
			<cfset request.fieldnames = listAppend(request.fieldnames, variables.i)>
		</cfif>
	</cfloop>
	
	<cfset form = structDelete(form, "fieldnameOrder")>
	
<cfelseif application.configBean.getCompiler() eq "Railo" >
	<cfset request.fieldnames=""/>
	<cfset variables.aRawForm = form.getRaw()>
    
    <cfloop from="1" to="#arrayLen(variables.aRawForm)#" index="variables.k">
        <cfset request.fieldnames = listAppend(request.fieldnames, variables.aRawForm[variables.k].getName())>
    </cfloop>

<cfelseif not structKeyExists(request,"fieldnames")>
	<cfset request.fieldnames=""/>
	
	<cfloop collection="#form#" item="variables.fn">
		<cfset request.fieldnames=listAppend(request.fieldnames,variables.fn) />
	</cfloop>
	
</cfif>

<cfif variables.acceptdata>
	<cfset application.pluginManager.announceEvent("onBeforeFormSubmitSave",variables.event)>
	<cfset variables.info=application.dataCollectionManager.update(structCopy(request))/>
	<cfset variables.event.setValue("formResult",variables.info)>
	<cfset application.pluginManager.announceEvent("onAfterFormSubmitSave",variables.event)>
	
	<cfset variables.mailer=variables.$.getBean('mailer')/>
	
	<cfif request.copyEmail eq 'true' and mailer.isValidEmailFormat(request.email)>
		<cfset request.sendto=listappend(request.sendto,request.email) />
	</cfif>
	
	<cfif variables.mailer.isValidEmailFormat(request.sendto)>
		<cfset variables.sendto=listappend(variables.rsform.responsesendto,request.sendto) />
	<cfelse>
		<cfset variables.sendto=variables.rsform.responsesendto />
	</cfif>
	
	<cfparam name="request.subject" default="#variables.rsform.title#">
			
	<cfif not StructIsEmpty(variables.info) and variables.sendto neq ''> 
		<cfset variables.mailer=variables.$.getBean('mailer')/>
		<cfif variables.mailer.isValidEmailFormat(request.email)>
			<cfset variables.mailer.send(info,'#variables.sendto#','#variables.rsform.title#','#request.subject#','#variables.$.event('siteID')#','#request.email#')>
		<cfelse>
			<cfset variables.mailer.send(variables.info,'#variables.sendto#','#variables.rsform.title#','#request.subject#','#variables.$.event('siteID')#','')>
		</cfif>
	</cfif>
			
</cfif>