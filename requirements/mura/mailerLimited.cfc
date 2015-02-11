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
<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" returntype="any" access="public" output="false">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>
<cfargument name="contentRenderer" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.contentRenderer=arguments.contentRenderer />
<cfreturn this />
</cffunction>

<cffunction name="send" returntype="void" output="false">
<cfargument name="args" type="struct" default="#structNew()#">
<cfargument name="sendto" type="string" default="">
<cfargument name="from" type="string" default="">
<cfargument name="subject" type="string" default="">
<cfargument name="siteid" type="string" default="">
<cfargument name="replyto" type="string" default="">
<cfargument name="bcc" type="string" required="true" default="">

<cfset var mailserverUsername=""/>
<cfset var mailserverIP=""/>
<cfset var mailserverPassword=""/>
<cfset var mailserverUsernameEmail=""/>
<cfset var mailserverPort=80/>
<cfset var tmt_mail_body=""/>
<cfset var tmt_cr=""/>
<cfset var tmt_mail_head=""/>
<cfset var form_element= "" />
<cfset var attachments=arrayNew(1) />
<cfset var a =1  />
<cfset var redirectID=""/>
<cfset var reviewLink=""/>
<cfset var fields=""/>
<cfset var fn=""/>
<cfset var useDefaultSMTPServer=0/>

	<cfif arguments.siteid neq ''>
		<cfset useDefaultSMTPServer=variables.settingsManager.getSite(arguments.siteid).getUseDefaultSMTPServer()>
		<cfset mailServerUsername=variables.settingsManager.getSite(arguments.siteid).getMailserverUsername(true)/>
		<cfset mailServerUsernameEmail=variables.settingsManager.getSite(arguments.siteid).getMailserverUsernameEmail()/>
		<cfset mailServerIP=variables.settingsManager.getSite(arguments.siteid).getMailserverIP()/>
		<cfset mailServerPassword=variables.settingsManager.getSite(arguments.siteid).getMailserverPassword()/>
		<cfset mailServerPort=variables.settingsManager.getSite(arguments.siteid).getMailserverSMTPPort()/>
	<cfelse>
		<cfset useDefaultSMTPServer=variables.configBean.getUseDefaultSMTPServer()>
		<cfset mailServerUsername=variables.configBean.getMailserverUsername(true)/>
		<cfset mailServerUsernameEmail=variables.configBean.getMailserverUsernameEmail()/>
		<cfset mailServerIP=variables.configBean.getMailserverIP()/>
		<cfset mailServerPassword=variables.configBean.getMailserverPassword()/>
		<cfset mailServerPort=variables.configBean.getMailserverSMTPPort()/>
	</cfif>

<cfif isStruct(arguments.args) and REFindNoCase("^[^@%*<>' ]+@[^@%*<>' ]{1,255}\.[^@%*<>' ]{2,5}", trim(arguments.sendto)) neq 0>
	
	<cfset fields=arguments.args>
	
	<cfif not structKeyExists(fields,"fieldnames")>
	<cfset fields.fieldnames=""/>
	<cfloop collection="#fields#" item="fn">
		<cfset fields.fieldnames=listAppend(fields.fieldnames,fn) />
	</cfloop>
	</cfif>


	<cfset tmt_mail_body = "">
	<cfset tmt_cr = Chr(13) & Chr(10)>
	<cfset tmt_mail_head = "This form was sent at: #LSDateFormat(Now())# #LSTimeFormat(Now(),'short')#">
	<cfloop index="form_element" list="#fields.fieldnames#">
	
		<cfif form_element neq 'siteid' 
				and right(form_element,2) neq ".X" 
				and right(form_element,2) neq ".Y" 
				and form_element neq 'doaction' 
				and form_element neq 'userid' 
				and  form_element neq 'password2' 
				and form_element neq 'submit' 
				and form_element neq 'sendto'
				and form_element neq 'HKEY'
				and form_element neq 'UKEY'>
			
			<cfif findNoCase('attachment',form_element) and isValid("UUID",fields['#form_element#'])>
				
				<cfset redirectID=createUUID() />
				<cfset reviewLink='#application.settingsManager.getSite(arguments.siteID).getScheme()#://#application.settingsManager.getSite(arguments.siteID).getDomain()##variables.configBean.getServerPort()##application.configBean.getContext()#/index.cfm/_api/render/file/?fileID=#fields["#form_element#"]#&method=attachment' />
	
				<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				insert into tredirects (redirectID,URL,created) values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#redirectID#" >,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#reviewLink#" >,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				)
				</cfquery>
				
				<cfset tmt_mail_body = tmt_mail_body & form_element & ": " & "#application.settingsManager.getSite(arguments.siteID).getScheme()#://#application.settingsManager.getSite(arguments.siteID).getDomain()##variables.configBean.getServerPort()##application.configBean.getContext()##variables.contentRenderer.getURLStem(arguments.siteID,redirectID)#" & tmt_cr>
				
			<cfelse>
				<cfset tmt_mail_body = tmt_mail_body & form_element & ": " & fields['#form_element#'] & tmt_cr>
			</cfif>
		
		</cfif>
	
	</cfloop>
<cftry>
<cfif useDefaultSMTPServer>
<cfmail to="#arguments.sendto#" 
		from='"#arguments.from#" <#MailServerUsernameEmail#>' 
		subject="#arguments.subject#" 
		replyto="#arguments.replyto#"
		bcc="#arguments.bcc#">#tmt_mail_head#
#trim(tmt_mail_body)#
</cfmail>
<cfelse>
<cfmail to="#arguments.sendto#" 
		from='"#arguments.from#" <#MailServerUsernameEmail#>' 
		subject="#arguments.subject#" 
		server="#MailServerIp#" 
		username="#MailServerUsername#" 
		password="#MailServerPassword#"
		port="#mailserverPort#"
		replyto="#arguments.replyto#"
		bcc="#arguments.bcc#">#tmt_mail_head#
#trim(tmt_mail_body)#
</cfmail>
</cfif>
<cfcatch>
<cfif len(arguments.siteid)>
<cfthrow type="Invalid Mail Settings" 
            message="The current mail server settings for the site '#arguments.siteID#'are not valid.">
			
<cfelse>
<cfthrow type="Invalid Mail Settings" 
            message="The current mail server settings in the settings.ini are not valid.">
</cfif>
</cfcatch>
</cftry>

</cfif>
</cffunction>

<cffunction name="sendText" returntype="void" output="false">
<cfargument name="text" type="string" default="">
<cfargument name="sendto" type="string" default="">
<cfargument name="from" type="string" default="">
<cfargument name="subject" type="string" default="">
<cfargument name="siteid" type="string" default="">
<cfargument name="replyTo" type="string" default="">
<cfargument name="mailerID" type="string" default="">
<cfargument name="bcc" type="string" required="true" default="">

<cfset var mailserverUsername=""/>
<cfset var mailserverIP=""/>
<cfset var mailserverPassword=""/>
<cfset var mailserverUsernameEmail=""/>
<cfset var useDefaultSMTPServer=0/>
<cfset var mailserverPort=80/>

<cfif REFindNoCase("^[^@%*<>' ]+@[^@%*<>' ]{1,255}\.[^@%*<>' ]{2,5}", trim(arguments.sendto)) neq 0>
	<cfif arguments.siteid neq ''>
		<cfset useDefaultSMTPServer=variables.settingsManager.getSite(arguments.siteid).getUseDefaultSMTPServer()>
		<cfset mailServerUsername=variables.settingsManager.getSite(arguments.siteid).getMailserverUsername(true)/>
		<cfset mailServerUsernameEmail=variables.settingsManager.getSite(arguments.siteid).getMailserverUsernameEmail()/>
		<cfset mailServerIP=variables.settingsManager.getSite(arguments.siteid).getMailserverIP()/>
		<cfset mailServerPassword=variables.settingsManager.getSite(arguments.siteid).getMailserverPassword()/>
		<cfset mailServerPort=variables.settingsManager.getSite(arguments.siteid).getMailserverSMTPPort()/>
	<cfelse>
		<cfset useDefaultSMTPServer=variables.configBean.getUseDefaultSMTPServer()>
		<cfset mailServerUsername=variables.configBean.getMailserverUsername(true)/>
		<cfset mailServerUsernameEmail=variables.configBean.getMailserverUsernameEmail()/>
		<cfset mailServerIP=variables.configBean.getMailserverIP()/>
		<cfset mailServerPassword=variables.configBean.getMailserverPassword()/>
		<cfset mailServerPort=variables.configBean.getMailserverSMTPPort()/>
	</cfif>

	<cftry>
	<cfif useDefaultSMTPServer>
		<cfmail to="#arguments.sendto#" 
				from='"#arguments.from#" <#MailServerUsernameEmail#>' 
				subject="#arguments.subject#" 
				replyto="#arguments.replyto#"
				failto="#mailServerUsernameEmail#"
				type="text"
				mailerid="#arguments.mailerID#"
				bcc="#arguments.bcc#">#trim(arguments.text)#</cfmail>
	<cfelse>
		<cfmail to="#arguments.sendto#" 
				from='"#arguments.from#" <#MailServerUsernameEmail#>' 
				subject="#arguments.subject#" 
				server="#MailServerIp#" 
				username="#MailServerUsername#" 
				password="#MailServerPassword#"
				port="#mailserverPort#"
				replyto="#arguments.replyto#"
				failto="#mailServerUsernameEmail#"
				type="text"
				mailerid="#arguments.mailerID#"
				bcc="#arguments.bcc#">#trim(arguments.text)#</cfmail>
	</cfif>
	<cfcatch>
		<cfif len(arguments.siteid)>
			<cfthrow type="Invalid Mail Settings" 
	            message="The current mail server settings for the site '#arguments.siteID#'are not valid.">
				
		<cfelse>
			<cfthrow type="Invalid Mail Settings" 
	            message="The current mail server settings in the settings.ini are not valid.">
		</cfif>
	</cfcatch>
	</cftry>

</cfif>
</cffunction>

<cffunction name="sendHTML" returntype="void" output="false">
<cfargument name="html" type="string" default="">
<cfargument name="sendto" type="string" default="">
<cfargument name="from" type="string" default="">
<cfargument name="subject" type="string" default="">
<cfargument name="siteid" type="string" default="">
<cfargument name="replyTo" type="string" default="">
<cfargument name="mailerID" type="string" default="">
<cfargument name="bcc" type="string" required="true" default="">

<cfset var mailserverUsername=""/>
<cfset var mailserverIP=""/>
<cfset var mailserverPassword=""/>
<cfset var mailserverUsernameEmail=""/>
<cfset var useDefaultSMTPServer=0/>
<cfset var mailserverPort=80/>

<cfif REFindNoCase("^[^@%*<>' ]+@[^@%*<>' ]{1,255}\.[^@%*<>' ]{2,5}", trim(arguments.sendto)) neq 0>
	<cfif arguments.siteid neq ''>
		<cfset useDefaultSMTPServer=variables.settingsManager.getSite(arguments.siteid).getUseDefaultSMTPServer()>
		<cfset mailServerUsername=variables.settingsManager.getSite(arguments.siteid).getMailserverUsername(true)/>
		<cfset mailServerUsernameEmail=variables.settingsManager.getSite(arguments.siteid).getMailserverUsernameEmail()/>
		<cfset mailServerIP=variables.settingsManager.getSite(arguments.siteid).getMailserverIP()/>
		<cfset mailServerPassword=variables.settingsManager.getSite(arguments.siteid).getMailserverPassword()/>
		<cfset mailServerPort=variables.settingsManager.getSite(arguments.siteid).getMailserverSMTPPort()/>
	<cfelse>
		<cfset useDefaultSMTPServer=variables.configBean.getUseDefaultSMTPServer()>
		<cfset mailServerUsername=variables.configBean.getMailserverUsername(true)/>
		<cfset mailServerUsernameEmail=variables.configBean.getMailserverUsernameEmail()/>
		<cfset mailServerIP=variables.configBean.getMailserverIP()/>
		<cfset mailServerPassword=variables.configBean.getMailserverPassword()/>
		<cfset mailServerPort=variables.configBean.getMailserverSMTPPort()/>
	</cfif>

	<cftry>
	<cfif useDefaultSMTPServer>
		<cfmail to="#arguments.sendto#" 
				from='"#arguments.from#" <#MailServerUsernameEmail#>' 
				subject="#arguments.subject#" 
				replyto="#arguments.replyto#"
				failto="#mailServerUsernameEmail#"
				type="html"
				mailerid="#arguments.mailerID#"
				bcc="#arguments.bcc#">#trim(arguments.html)#</cfmail>
	<cfelse>
		<cfmail to="#arguments.sendto#" 
				from='"#arguments.from#" <#MailServerUsernameEmail#>' 
				subject="#arguments.subject#" 
				server="#MailServerIp#" 
				username="#MailServerUsername#" 
				password="#MailServerPassword#"
				port="#mailserverPort#"
				replyto="#arguments.replyto#"
				failto="#mailServerUsernameEmail#"
				type="html"
				mailerid="#arguments.mailerID#"
				bcc="#arguments.bcc#">#trim(arguments.html)#</cfmail>
	</cfif>
	<cfcatch>
		<cfif len(arguments.siteid)>
			<cfthrow type="Invalid Mail Settings" 
	            message="The current mail server settings for the site '#arguments.siteID#'are not valid.">
				
		<cfelse>
			<cfthrow type="Invalid Mail Settings" 
	            message="The current mail server settings in the settings.ini are not valid.">
		</cfif>
	</cfcatch>
	</cftry>

</cfif>
</cffunction>

<cffunction name="sendTextAndHTML" returntype="void" output="false">
<cfargument name="text" type="string" default="">
<cfargument name="html" type="string" default="">
<cfargument name="sendto" type="string" default="">
<cfargument name="from" type="string" default="">
<cfargument name="subject" type="string" default="">
<cfargument name="siteid" type="string" default="">
<cfargument name="replyTo" type="string" default="">
<cfargument name="mailerID" type="string" default="">
<cfargument name="bcc" type="string" required="true" default="">

<cfset var mailserverUsername=""/>
<cfset var mailserverIP=""/>
<cfset var mailserverPassword=""/>
<cfset var mailserverUsernameEmail=""/>
<cfset var useDefaultSMTPServer=0/>
<cfset var mailserverPort=80/>

<cfif REFindNoCase("^[^@%*<>' ]+@[^@%*<>' ]{1,255}\.[^@%*<>' ]{2,5}", trim(arguments.sendto)) neq 0>
	<cfif arguments.siteid neq ''>
		<cfset useDefaultSMTPServer=variables.settingsManager.getSite(arguments.siteid).getUseDefaultSMTPServer()>
		<cfset mailServerUsername=variables.settingsManager.getSite(arguments.siteid).getMailserverUsername(true)/>
		<cfset mailServerUsernameEmail=variables.settingsManager.getSite(arguments.siteid).getMailserverUsernameEmail()/>
		<cfset mailServerIP=variables.settingsManager.getSite(arguments.siteid).getMailserverIP()/>
		<cfset mailServerPassword=variables.settingsManager.getSite(arguments.siteid).getMailserverPassword()/>
		<cfset mailServerPort=variables.settingsManager.getSite(arguments.siteid).getMailserverSMTPPort()/>
	<cfelse>
		<cfset useDefaultSMTPServer=variables.configBean.getUseDefaultSMTPServer()>
		<cfset mailServerUsername=variables.configBean.getMailserverUsername(true)/>
		<cfset mailServerUsernameEmail=variables.configBean.getMailserverUsernameEmail()/>
		<cfset mailServerIP=variables.configBean.getMailserverIP()/>
		<cfset mailServerPassword=variables.configBean.getMailserverPassword()/>
		<cfset mailServerPort=variables.configBean.getMailserverSMTPPort()/>
	</cfif>

	<cftry>
	<cfif useDefaultSMTPServer>
		<cfmail to="#arguments.sendto#" 
				from='"#arguments.from#" <#MailServerUsernameEmail#>' 
				subject="#arguments.subject#" 
				replyto="#arguments.replyto#"
				failto="#mailServerUsernameEmail#"
				type="html"
				mailerid="#arguments.mailerID#"
				bcc="#arguments.bcc#">
					<cfmailpart type="text/plain">#trim(arguments.text)#</cfmailpart>
					<cfmailpart type="text/html">#trim(arguments.html)#</cfmailpart>
				</cfmail>
	<cfelse>
		<cfmail to="#arguments.sendto#" 
				from='"#arguments.from#" <#MailServerUsernameEmail#>' 
				subject="#arguments.subject#" 
				server="#MailServerIp#" 
				username="#MailServerUsername#" 
				password="#MailServerPassword#"
				port="#mailserverPort#"
				replyto="#arguments.replyto#"
				failto="#mailServerUsernameEmail#"
				type="html"
				mailerid="#arguments.mailerID#"
				bcc="#arguments.bcc#">
					<cfmailpart type="text/plain">#trim(arguments.text)#</cfmailpart>
					<cfmailpart type="text/html">#trim(arguments.html)#</cfmailpart>
				</cfmail>
	</cfif>
	<cfcatch>
		<cfif len(arguments.siteid)>
			<cfthrow type="Invalid Mail Settings" 
	            message="The current mail server settings for the site '#arguments.siteID#'are not valid.">
				
		<cfelse>
			<cfthrow type="Invalid Mail Settings" 
	            message="The current mail server settings in the settings.ini are not valid.">
		</cfif>
	</cfcatch>
	</cftry>

</cfif>
</cffunction>

<cffunction name="isValidEmailFormat" output="false">
<cfargument name="email">
<cfreturn REFindNoCase("^[^@%*<>' ]+@[^@%*<>' ]{1,255}\.[^@%*<>' ]{2,5}", trim(arguments.email)) neq 0>
</cffunction>
</cfcomponent>