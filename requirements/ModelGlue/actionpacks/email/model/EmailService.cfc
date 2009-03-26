<!---
LICENSE INFORMATION:

Copyright 2007, Joe Rinehart
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of Model-Glue Model-Glue: ColdFusion (2.0.304).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->


<cfcomponent displayname="EmailService" output="false" hint="I live to authenticate users.">

<cffunction name="init" returntype="EmailService" output="false" hint="Constructor">
	<cfargument name="emailConfiguration" required="true" />
	
	<cfset variables._config = arguments.emailConfiguration />
	<cfreturn this />
</cffunction>

<cffunction name="GetConfigSetting" access="private" returntype="string" output="false">
	<cfargument name="name" required="true" type="string" />
	<cfreturn variables._config.getConfigSetting(arguments.name) />
</cffunction>

<cffunction name="createEmail" access="public" returntype="any" output="false">
	<cfset var email = createObject("component", "Email").init(this) />
	<cfset email.setFrom(getConfigSetting("defaultFrom")) />
	<cfset email.setType(getConfigSetting("defaultType")) />
	
	<cfreturn email />
</cffunction>

<cffunction name="sendEmail" access="public" returntype="void" output="false">
	<cfargument name="email" required="true">
	
	<cfset var server = getConfigSetting("server") />
	<cfset var port = getConfigSetting("port") />
	<cfset var username = getConfigSetting("username") />
	<cfset var password = getConfigSetting("password") />
	<cfset var dev = getConfigSetting("developmentMode") />
	<cfset var devto = getConfigSetting("developmentEmailAddress") />
	<cfset var to = arguments.email.getTo() />
	<cfset var bcc = arguments.email.getBcc() />
	<cfset var cc = arguments.email.getCC() />
	<cfset var attachments = arguments.email.getAttachments() />
	<cfset var headers = arguments.email.getHeaders() />
	<cfset var i = "" />
	
	<cfif dev>
		<cfset bcc = "" />
		<cfset cc = "" />
		<cfset to = devto />
	</cfif>
	
	<cfmail 
	   to = "#to#"
	   from = "#arguments.email.getFrom()#"
	   cc = "#cc#"
	   bcc = "#bcc#"
	   subject = "#arguments.email.getSubject()#"
	   replyto = "#arguments.email.getReplyTo()#"
	   type = "#arguments.email.getType()#"
	   username = "#username#"
	   password = "#password#"
	   server = "#server#"
	   port = "#port#"
	>#arguments.email.getBody()#<cfloop from="1" to="#arrayLen(attachments)#" index="i"><cfmailparam file="#attachments[i]#" /></cfloop><cfloop from="1" to="#arrayLen(headers)#" index="i"><cfmailparam name="#headers[i].name#" value="#headers[i].value#" /></cfloop></cfmail>
	
	
</cffunction>

</cfcomponent>