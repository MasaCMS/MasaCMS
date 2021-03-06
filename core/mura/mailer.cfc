<!--- 
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the  
same licensing model. It is, therefore, licensed under the Gnu General Public License 
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing 
notice set out below. That exception is also granted by the copyright holders of Masa CMS 
also applies to this file and Masa CMS in general. 

This file has been modified from the original version received from Mura CMS. The 
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright 
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained 
only to ensure software compatibility, and compliance with the terms of the GPLv2 and 
the exception set out below. That use is not intended to suggest any commercial relationship 
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa. 

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com  

Masa CMS is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, Version 2 of the License. 
Masa CMS is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>. 

The original complete licensing notice from the Mura CMS version of this file is as 
follows: 

This file is part of Mura CMS.

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
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false" hint="This provides a utility to send emails with site of global config settings">

<cffunction name="init" output="false">
	<cfargument name="configBean" type="any" required="yes"/>
	<cfargument name="settingsManager" type="any" required="yes"/>
	<cfargument name="contentRenderer" type="any" required="yes"/>
	<cfset variables.configBean=arguments.configBean />
	<cfset variables.settingsManager=arguments.settingsManager />
	<cfset variables.contentRenderer=arguments.contentRenderer />
	<cfset variables.sendFromMailServerUserName=variables.configBean.getSendFromMailServerUserName()>
	<cfreturn this />
</cffunction>

<cffunction name="send" output="false">
	<cfargument name="args" type="struct" default="#structNew()#">
	<cfargument name="sendto" type="string" default="">
	<cfargument name="from" type="string" default="">
	<cfargument name="subject" type="string" default="">
	<cfargument name="siteid" type="string" default="">
	<cfargument name="replyto" type="string" default="">
	<cfargument name="bcc" type="string" required="true" default="">
	<cfargument name="mailParamArray" type="array" required="false" hint='You can pass the attributes for the cfMailParam tag as an array of structured keys.'>

	<cfset var mailserverUsername="" />
	<cfset var mailserverIP="" />
	<cfset var mailserverPassword="" />
	<cfset var mailserverPort=80 />
	<cfset var mailServerTLS=false />
	<cfset var mailServerSSL=false />
	<cfset var tmt_mail_body="" />
	<cfset var tmt_cr="" />
	<cfset var tmt_mail_head="" />
	<cfset var form_element= "" />
	<cfset var attachments=arrayNew(1) />
	<cfset var a =1  />
	<cfset var redirectID="" />
	<cfset var reviewLink="" />
	<cfset var fields="" />
	<cfset var fn="" />
	<cfset var useDefaultSMTPServer=0 />
	<cfset var fromEmail="" />
	<cfset var filteredSendto=filterEmails(arguments.sendto) />
	<cfset var mailServerFailto="" />
	<cfset var site="">

	<cfif len(arguments.siteid) and not len(arguments.from)>
		<cfset arguments.from=getFromEmail(arguments.siteid)>
	</cfif>

	<cfscript>
		useDefaultSMTPServer = getUseDefaultSMTPServer(arguments.siteid);
		mailServerUsername = getMailserverUsername(arguments.siteid);
		mailServerIP = getMailserverIP(arguments.siteid);
		mailServerPassword = getMailserverPassword(arguments.siteid);
		mailServerPort = getMailServerPort(arguments.siteid);
		mailServerTLS = getMailserverTLS(arguments.siteid);
		mailServerSSL = getMailserverSSL(arguments.siteid);
		fromEmail = getFromEmail(arguments.siteid);
		mailServerFailto = IsValidEmailFormat(fromEmail) ? fromEmail : '';
	</cfscript>

	<cfif isStruct(arguments.args) and len(filteredSendto)>
		<cfset fields=arguments.args>
		<cfif not structKeyExists(fields,"fieldnames")>
			<cfset fields.fieldnames=""/>
			<cfloop collection="#fields#" item="fn">
				<cfset fields.fieldnames=listAppend(fields.fieldnames,fn) />
			</cfloop>
		</cfif>

		<cfset tmt_mail_body = "">
		<cfset tmt_cr = Chr(13) & Chr(10)>
		<cfset tmt_mail_head = "Submitted: #LSDateFormat(Now())# #LSTimeFormat(Now(),'short')# #tmt_cr#">
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
					and form_element neq 'UKEY'
					and structkeyexists(fields, form_element)>

				<cfif findNoCase('attachment',form_element) and isValid("UUID",fields['#form_element#'])>

					<cfset redirectID=createUUID() />
					<cfset site=variables.settingsManager.getSite(arguments.siteid)>
					<cfset reviewLink='#site.getResourcePath(complete=1)#/index.cfm/_api/render/file/?fileID=#fields["#form_element#"]#&method=attachment' />

					<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
					insert into tredirects (redirectID,URL,created) values(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#redirectID#" >,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#reviewLink#" >,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					)
					</cfquery>

					<cfset tmt_mail_body = tmt_mail_body & form_element & ": " & "#site.getWebPath(complete=1)##site.getContentRenderer().getURLStem(arguments.siteID,redirectID)#" & tmt_cr>

				<cfelse>
					<cfset tmt_mail_body = tmt_mail_body & form_element & ": " & fields['#form_element#'] & tmt_cr>
				</cfif>

			</cfif>
		</cfloop>

		<cftry>
			<cfif useDefaultSMTPServer>
				<cfmail to="#filteredSendTo#"
						from="#arguments.from# <#fromEmail#>"
						subject="#arguments.subject#"
						replyto="#arguments.replyto#"
						failto="#mailServerFailto#"
						bcc="#arguments.bcc#">#tmt_mail_head##Chr(13)##Chr(10)##trim(tmt_mail_body)#
						<cfif isDefined('arguments.mailParamArray') and isArray(arguments.mailParamArray)>
							<cfloop array="#arguments.mailParamArray#" index="local.mailParamIndex">
								<cfmailparam attributeCollection='#local.mailParamIndex#'/>
							</cfloop>
						</cfif>
				</cfmail>
			<cfelse>
				<cfmail to="#filteredSendTo#"
						from="#arguments.from# <#fromEmail#>"
						subject="#arguments.subject#"
						server="#MailServerIp#"
						username="#MailServerUsername#"
						password="#MailServerPassword#"
						port="#mailserverPort#"
						useTLS="#mailserverTLS#"
						useSSL="#mailserverSSL#"
						replyto="#arguments.replyto#"
						failto="#mailServerFailto#"
						bcc="#arguments.bcc#">#tmt_mail_head##Chr(13)##Chr(10)##trim(tmt_mail_body)#
						<cfif isDefined('arguments.mailParamArray') and isArray(arguments.mailParamArray)>
							<cfloop array="#arguments.mailParamArray#" index="local.mailParamIndex">
								<cfmailparam attributeCollection='#local.mailParamIndex#'/>
							</cfloop>
						</cfif>
				</cfmail>

			</cfif>
			<cfcatch>
				<cfif len(arguments.siteid)>
					<cflog type="Error" file="exception" text="The current mail server settings for the site '#arguments.siteID#' are not valid.">
				<cfelse>
					<cflog type="Error" file="exception" text="The current mail server settings in the settings.ini are not valid.">
				</cfif>
			</cfcatch>
		</cftry>
	</cfif>
</cffunction>

<cffunction name="sendText" output="false">
	<cfargument name="text" type="string" default="">
	<cfargument name="sendto" type="string" default="">
	<cfargument name="from" type="string" default="">
	<cfargument name="subject" type="string" default="">
	<cfargument name="siteid" type="string" default="">
	<cfargument name="replyTo" type="string" default="">
	<cfargument name="mailerID" type="string" default="">
	<cfargument name="bcc" type="string" required="true" default="">
	<cfargument name="mailParamArray" type="array" required="false" hint='You can pass the attributes for the cfMailParam tag as an array of structured keys.'>

	<cfset var mailserverUsername=""/>
	<cfset var mailserverIP=""/>
	<cfset var mailserverPassword=""/>
	<cfset var useDefaultSMTPServer=0/>
	<cfset var mailserverPort=80/>
	<cfset var mailServerTLS=false />
	<cfset var mailServerSSL=false />
	<cfset var mailServerFailto="" />
	<cfset var fromEmail="" />
	<cfset var filteredSendto=filterEmails(arguments.sendto)>

	<cfif len(arguments.siteid) and not len(arguments.from)>
		<cfset arguments.from=getFromEmail(arguments.siteid)>
	</cfif>

	<cfif len(filteredSendto)>

		<cfscript>
			useDefaultSMTPServer = getUseDefaultSMTPServer(arguments.siteid);
			mailServerUsername = getMailserverUsername(arguments.siteid);
			mailServerIP = getMailserverIP(arguments.siteid);
			mailServerPassword = getMailserverPassword(arguments.siteid);
			mailServerPort = getMailServerPort(arguments.siteid);
			mailServerTLS = getMailserverTLS(arguments.siteid);
			mailServerSSL = getMailserverSSL(arguments.siteid);
			fromEmail = getFromEmail(arguments.siteid);
			mailServerFailto = IsValidEmailFormat(fromEmail) ? fromEmail : '';
		</cfscript>

		<cftry>
			<cfif useDefaultSMTPServer>
				<cfmail to="#filteredSendTo#"
						from='"#arguments.from#" <#fromEmail#>'
						subject="#arguments.subject#"
						replyto="#arguments.replyto#"
						failto="#mailServerFailto#"
						type="text"
						mailerid="#arguments.mailerID#"
						bcc="#arguments.bcc#">#trim(arguments.text)#
						<cfif isDefined('arguments.mailParamArray') and isArray(arguments.mailParamArray)>
							<cfloop array="#arguments.mailParamArray#" index="local.mailParamIndex">
								<cfmailparam attributeCollection='#local.mailParamIndex#'/>
							</cfloop>
						</cfif>
				</cfmail>
			<cfelse>
				<cfmail to="#filteredSendTo#"
						from='"#arguments.from#" <#fromEmail#>'
						subject="#arguments.subject#"
						server="#MailServerIp#"
						username="#MailServerUsername#"
						password="#MailServerPassword#"
						port="#mailserverPort#"
						useTLS="#mailserverTLS#"
						useSSL="#mailserverSSL#"
						replyto="#arguments.replyto#"
						failto="#mailServerFailto#"
						type="text"
						mailerid="#arguments.mailerID#"
						bcc="#arguments.bcc#">#trim(arguments.text)#
						<cfif isDefined('arguments.mailParamArray') and isArray(arguments.mailParamArray)>
							<cfloop array="#arguments.mailParamArray#" index="local.mailParamIndex">
								<cfmailparam attributeCollection='#local.mailParamIndex#'/>
							</cfloop>
						</cfif>
				</cfmail>
			</cfif>
		<cfcatch>
			<cfif len(arguments.siteid)>
				<cflog type="Error" file="exception" text="The current mail server settings for the site '#arguments.siteID#' are not valid: #serializeJSON(cfcatch)#">
			<cfelse>
				<cflog type="Error" file="exception" text="The current mail server settings in the settings.ini are not valid: #serializeJSON(cfcatch)#">
			</cfif>
		</cfcatch>
		</cftry>
	</cfif>
</cffunction>

<cffunction name="sendHTML" output="false">
	<cfargument name="html" type="string" default="">
	<cfargument name="sendto" type="string" default="">
	<cfargument name="from" type="string" default="">
	<cfargument name="subject" type="string" default="">
	<cfargument name="siteid" type="string" default="">
	<cfargument name="replyTo" type="string" default="">
	<cfargument name="mailerID" type="string" default="">
	<cfargument name="bcc" type="string" required="true" default="">
	<cfargument name="mailParamArray" type="array" required="false" hint='You can pass the attributes for the cfMailParam tag as an array of structured keys.'>

	<cfset var mailserverUsername=""/>
	<cfset var mailserverIP=""/>
	<cfset var mailserverPassword=""/>
	<cfset var useDefaultSMTPServer=0/>
	<cfset var mailserverPort=80/>
	<cfset var mailServerTLS=false />
	<cfset var mailServerSSL=false />
	<cfset var mailServerFailto="" />
	<cfset var fromEmail="" />
	<cfset var filteredSendto=filterEmails(arguments.sendto)>

	<cfif len(arguments.siteid) and not len(arguments.from)>
		<cfset arguments.from=getFromEmail(arguments.siteid)>
	</cfif>

	<cfif len(filteredSendto)>
		<cfscript>
			useDefaultSMTPServer = getUseDefaultSMTPServer(arguments.siteid);
			mailServerUsername = getMailserverUsername(arguments.siteid);
			mailServerIP = getMailserverIP(arguments.siteid);
			mailServerPassword = getMailserverPassword(arguments.siteid);
			mailServerPort = getMailServerPort(arguments.siteid);
			mailServerTLS = getMailserverTLS(arguments.siteid);
			mailServerSSL = getMailserverSSL(arguments.siteid);
			fromEmail = getFromEmail(arguments.siteid);
			mailServerFailto = IsValidEmailFormat(fromEmail) ? fromEmail : '';
		</cfscript>

		<cftry>
			<cfif useDefaultSMTPServer>
				<cfmail to="#filteredSendTo#"
						from='"#arguments.from#" <#fromEmail#>'
						subject="#arguments.subject#"
						replyto="#arguments.replyto#"
						failto="#mailServerFailto#"
						type="html"
						mailerid="#arguments.mailerID#"
						bcc="#arguments.bcc#">#trim(arguments.html)#
						<cfif isDefined('arguments.mailParamArray') and isArray(arguments.mailParamArray)>
							<cfloop array="#arguments.mailParamArray#" index="local.mailParamIndex">
								<cfmailparam attributeCollection='#local.mailParamIndex#'/>
							</cfloop>
						</cfif>
				</cfmail>
			<cfelse>
				<cfmail to="#filteredSendTo#"
						from='"#arguments.from#" <#fromEmail#>'
						subject="#arguments.subject#"
						server="#MailServerIp#"
						username="#MailServerUsername#"
						password="#MailServerPassword#"
						port="#mailserverPort#"
						useTLS="#mailserverTLS#"
						useSSL="#mailserverSSL#"
						replyto="#arguments.replyto#"
						failto="#mailServerFailto#"
						type="html"
						mailerid="#arguments.mailerID#"
						bcc="#arguments.bcc#">#trim(arguments.html)#
						<cfif isDefined('arguments.mailParamArray') and isArray(arguments.mailParamArray)>
							<cfloop array="#arguments.mailParamArray#" index="local.mailParamIndex">
								<cfmailparam attributeCollection='#local.mailParamIndex#'/>
							</cfloop>
						</cfif>
				</cfmail>
			</cfif>
		<cfcatch>
			<cfif len(arguments.siteid)>
				<cflog type="Error" file="exception" text="The current mail server settings for the site '#arguments.siteID#' are not valid: #serializeJSON(cfcatch)#">
			<cfelse>
				<cflog type="Error" file="exception" text="The current mail server settings in the settings.ini are not valid: #serializeJSON(cfcatch)#">
			</cfif>
		</cfcatch>
		</cftry>
	</cfif>
</cffunction>

<cffunction name="sendTextAndHTML" output="false">
	<cfargument name="text" type="string" default="">
	<cfargument name="html" type="string" default="">
	<cfargument name="sendto" type="string" default="">
	<cfargument name="from" type="string" default="">
	<cfargument name="subject" type="string" default="">
	<cfargument name="siteid" type="string" default="">
	<cfargument name="replyTo" type="string" default="">
	<cfargument name="mailerID" type="string" default="">
	<cfargument name="bcc" type="string" required="true" default="">
	<cfargument name="mailParamArray" type="array" required="false" hint='You can pass the attributes for the cfMailParam tag as an array of structured keys.'>

	<cfset var mailserverUsername=""/>
	<cfset var mailserverIP=""/>
	<cfset var mailserverPassword=""/>
	<cfset var useDefaultSMTPServer=0/>
	<cfset var mailserverPort=80/>
	<cfset var mailServerTLS=false />
	<cfset var mailServerSSL=false />
	<cfset var mailServerFailto="" />
	<cfset var fromEmail="" />
	<cfset var filteredSendto=filterEmails(arguments.sendto)>

	<cfif len(arguments.siteid) and not len(arguments.from)>
		<cfset arguments.from=getFromEmail(arguments.siteid)>
	</cfif>

	<cfif len(filteredSendto)>

		<cfscript>
			useDefaultSMTPServer = getUseDefaultSMTPServer(arguments.siteid);
			mailServerUsername = getMailserverUsername(arguments.siteid);
			mailServerIP = getMailserverIP(arguments.siteid);
			mailServerPassword = getMailserverPassword(arguments.siteid);
			mailServerPort = getMailServerPort(arguments.siteid);
			mailServerTLS = getMailserverTLS(arguments.siteid);
			mailServerSSL = getMailserverSSL(arguments.siteid);
			fromEmail = getFromEmail(arguments.siteid);
			mailServerFailto = IsValidEmailFormat(fromEmail) ? fromEmail : '';
		</cfscript>

		<cftry>
		<cfif useDefaultSMTPServer>
			<cfmail to="#filteredSendTo#"
					from='"#arguments.from#" <#fromEmail#>'
					subject="#arguments.subject#"
					replyto="#arguments.replyto#"
					failto="#mailServerFailto#"
					type="html"
					mailerid="#arguments.mailerID#"
					bcc="#arguments.bcc#">
				<cfmailpart type="text/plain">#trim(arguments.text)#</cfmailpart>
				<cfmailpart type="text/html">#trim(arguments.html)#</cfmailpart>
				<cfif isDefined('arguments.mailParamArray') and isArray(arguments.mailParamArray)>
					<cfloop array="#arguments.mailParamArray#" index="local.mailParamIndex">
						<cfmailparam attributeCollection='#local.mailParamIndex#'/>
					</cfloop>
				</cfif>
			</cfmail>
		<cfelse>
			<cfmail to="#filteredSendTo#"
					from='"#arguments.from#" <#fromEmail#>'
					subject="#arguments.subject#"
					server="#MailServerIp#"
					username="#MailServerUsername#"
					password="#MailServerPassword#"
					port="#mailserverPort#"
					useTLS="#mailserverTLS#"
					useSSL="#mailserverSSL#"
					replyto="#arguments.replyto#"
					failto="#mailServerFailto#"
					type="html"
					mailerid="#arguments.mailerID#"
					bcc="#arguments.bcc#">
				<cfmailpart type="text/plain">#trim(arguments.text)#</cfmailpart>
				<cfmailpart type="text/html">#trim(arguments.html)#</cfmailpart>
				<cfif isDefined('arguments.mailParamArray') and isArray(arguments.mailParamArray)>
					<cfloop array="#arguments.mailParamArray#" index="local.mailParamIndex">
						<cfmailparam attributeCollection='#local.mailParamIndex#'/>
					</cfloop>
				</cfif>
			</cfmail>
		</cfif>
		<cfcatch>
			<cfif len(arguments.siteid)>
				<cflog type="Error" file="exception" text="The current mail server settings for the site '#arguments.siteID#' are not valid: #serializeJSON(cfcatch)#">
			<cfelse>
				<cflog type="Error" file="exception" text="The current mail server settings in the settings.ini are not valid: #serializeJSON(cfcatch)#">
			</cfif>
		</cfcatch>
		</cftry>
	</cfif>
</cffunction>

<cffunction name="isValidEmailFormat" output="false">
	<cfargument name="email">
	<cfreturn REFindNoCase("^[^@%*<>' ]+@[^@%*<>' ]{1,255}\.[^@%*<>' ]{2,5}", trim(arguments.email)) neq 0>
</cffunction>

<cffunction name="filterEmails" output="false">
	<cfargument name="emails">
	<cfset var returnList="">
	<cfset var i="">
	<cfif len(arguments.emails)>
		<cfloop list="#arguments.emails#" index="i">
			<cfif isValidEmailFormat(i)>
				<cfset returnList=listAppend(returnList,i)>
			</cfif>
		</cfloop>
	</cfif>
	<cfreturn returnList>
</cffunction>

<cfscript>
	public any function getFromEmail(string siteid='default') {
		var defaultFrom = 'no-reply@' & variables.settingsManager.getSite(arguments.siteid).getDomain();
		return variables.sendFromMailServerUserName && Len(getMailServerUsername(arguments.siteid)) && IsValid('email', getMailServerUsername(arguments.siteid))
			? getMailServerUsername(arguments.siteid)
			: Len(variables.settingsManager.getSite(arguments.siteid).getContact()) && IsValid('email', variables.settingsManager.getSite(arguments.siteid).getContact())
				? variables.settingsManager.getSite(arguments.siteid).getContact()
				: Len(variables.configBean.getAdminEmail()) && IsValid('email', variables.configBean.getAdminEmail())
					? variables.configBean.getAdminEmail()
					: defaultFrom;
	}

	public string function getUseDefaultSMTPServer(string siteid='') {
		return Len(arguments.siteid)
			? variables.settingsManager.getSite(arguments.siteid).getUseDefaultSMTPServer()
			: variables.configBean.getUseDefaultSMTPServer();
	}

	public string function getMailServerUsername(string siteid='') {
		return Len(arguments.siteid)
			? variables.settingsManager.getSite(arguments.siteid).getMailServerUsername(true)
			: variables.configBean.getMailServerUsername(true);
	}

	public string function getMailServerIP(string siteid='') {
		return Len(arguments.siteid)
			? variables.settingsManager.getSite(arguments.siteid).getMailServerIP()
			: variables.configBean.getMailServerIP();
	}

	public string function getMailServerPassword(string siteid='') {
		return Len(arguments.siteid)
			? variables.settingsManager.getSite(arguments.siteid).getMailServerPassword()
			: variables.configBean.getMailServerPassword();
	}

	public string function getMailServerPort(string siteid='') {
		return Len(arguments.siteid)
			? variables.settingsManager.getSite(arguments.siteid).getMailServerSMTPPort()
			: variables.configBean.getMailServerSMTPPort();
	}

	public string function getMailServerTLS(string siteid='') {
		return Len(arguments.siteid)
			? variables.settingsManager.getSite(arguments.siteid).getMailServerTLS()
			: variables.configBean.getMailServerTLS();
	}

	public string function getMailServerSSL(string siteid='') {
		return Len(arguments.siteid)
			? variables.settingsManager.getSite(arguments.siteid).getMailServerSSL()
			: variables.configBean.getMailServerSSL();
	}
</cfscript>

</cfcomponent>
