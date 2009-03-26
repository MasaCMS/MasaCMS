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


<cfcomponent output="false" name="EmailBean" hint="I am a Email.">

<!--- CONSTRUCTOR --->
<cffunction name="init" returnType="Email" access="public" output="false" hint="I build a new EmailBean">
	<cfargument name="emailService" required="true">
	
	<cfset variables._emailService = arguments.emailService />
	
	<!--- Instance Variables --->
	<cfset variables._instance = structNew() />
	<cfset variables._instance.To = "" />
	<cfset variables._instance.From = "" />
	<cfset variables._instance.ReplyTo = "" />
	<cfset variables._instance.CC = "" />
	<cfset variables._instance.BCC = "" />
	<cfset variables._instance.Subject = "" />
	<cfset variables._instance.Body = "" />
	<cfset variables._instance.Type = "" />
	<cfset variables._instance.Attachments = arrayNew(1) />
	<cfset variables._instance.Headers = arrayNew(1) />
	<cfreturn this />
</cffunction>

<!--- Send: use the assigned service to send this email --->
<cffunction name="Send" returntype="void" access="public" output="false" hint="I send the email.">
	<cfset variables._emailService.sendEmail(this) />
</cffunction>

<!--- Memento: takes a snapshot of data --->
<cffunction name="GetInstance" returntype="struct" access="public" output="false" hint="I return the instance data for this instance via a duplicate().">
	<cfreturn duplicate(variables._instance) />
</cffunction>

<!--- Instance Properties --->
<!--- SetTo() --->
<cffunction name="SetTo" returntype="void" access="public" output="false" hint="Sets the To property">
	<cfargument name="To" type="string" required="true" />
	<cfset variables._instance.To = arguments.To />
</cffunction>
<!--- GetTo() --->
<cffunction name="GetTo" returntype="string" access="public" output="false" hint="Gets the To property">
	<cfreturn variables._instance.To  />
</cffunction>

<!--- SetFrom() --->
<cffunction name="SetFrom" returntype="void" access="public" output="false" hint="Sets the From property">
	<cfargument name="From" type="string" required="true" />
	<cfset variables._instance.From = arguments.From />
</cffunction>
<!--- GetFrom() --->
<cffunction name="GetFrom" returntype="string" access="public" output="false" hint="Gets the From property">
	<cfreturn variables._instance.From  />
</cffunction>

<!--- SetReplyTo() --->
<cffunction name="SetReplyTo" returntype="void" access="public" output="false" hint="Sets the ReplyTo property">
	<cfargument name="ReplyTo" type="string" required="true" />
	<cfset variables._instance.ReplyTo = arguments.ReplyTo />
</cffunction>
<!--- GetReplyTo() --->
<cffunction name="GetReplyTo" returntype="string" access="public" output="false" hint="Gets the ReplyTo property">
	<cfreturn variables._instance.ReplyTo  />
</cffunction>

<!--- SetCC() --->
<cffunction name="SetCC" returntype="void" access="public" output="false" hint="Sets the CC property">
	<cfargument name="CC" type="string" required="true" />
	<cfset variables._instance.CC = arguments.CC />
</cffunction>
<!--- GetCC() --->
<cffunction name="GetCC" returntype="string" access="public" output="false" hint="Gets the CC property">
	<cfreturn variables._instance.CC  />
</cffunction>

<!--- SetBCC() --->
<cffunction name="SetBCC" returntype="void" access="public" output="false" hint="Sets the BCC property">
	<cfargument name="BCC" type="string" required="true" />
	<cfset variables._instance.BCC = arguments.BCC />
</cffunction>
<!--- GetBCC() --->
<cffunction name="GetBCC" returntype="string" access="public" output="false" hint="Gets the BCC property">
	<cfreturn variables._instance.BCC  />
</cffunction>

<!--- SetSubject() --->
<cffunction name="SetSubject" returntype="void" access="public" output="false" hint="Sets the Subject property">
	<cfargument name="Subject" type="string" required="true" />
	<cfset variables._instance.Subject = arguments.Subject />
</cffunction>
<!--- GetSubject() --->
<cffunction name="GetSubject" returntype="string" access="public" output="false" hint="Gets the Subject property">
	<cfreturn variables._instance.Subject  />
</cffunction>

<!--- SetBody() --->
<cffunction name="SetBody" returntype="void" access="public" output="false" hint="Sets the Body property">
	<cfargument name="Body" type="string" required="true" />
	<cfset variables._instance.Body = arguments.Body />
</cffunction>
<!--- GetBody() --->
<cffunction name="GetBody" returntype="string" access="public" output="false" hint="Gets the Body property">
	<cfreturn variables._instance.Body  />
</cffunction>

<!--- SetType() --->
<cffunction name="SetType" returntype="void" access="public" output="false" hint="Sets the Type property">
	<cfargument name="Type" type="string" required="true" />
	<cfset variables._instance.Type = arguments.Type />
</cffunction>
<!--- GetType() --->
<cffunction name="GetType" returntype="string" access="public" output="false" hint="Gets the Type property">
	<cfreturn variables._instance.Type  />
</cffunction>

<!--- AddAttachment() --->
<cffunction name="AddAttachment" returntype="void" access="public" output="false" hint="Sets the Attachments property">
	<cfargument name="Attachment" type="string" required="true" />
	
	<cfif not fileExists(arguments.attachment)>
		<cfthrow type="Email.InvalidAttachment" message="The attachment passed, #arguments.Attachment#, is not a file that exists." />
	</cfif>
	
	<cfset arrayAppend(variables._instance.Attachments, arguments.Attachment) />
</cffunction>
<!--- GetAttachments() --->
<cffunction name="GetAttachments" returntype="array" access="public" output="false" hint="Gets the Attachments property">
	<cfreturn variables._instance.Attachments  />
</cffunction>

<!--- AddHeader() --->
<cffunction name="AddHeader" returntype="void" access="public" output="false" hint="Sets the Headers property">
	<cfargument name="Name" type="string" required="true" />
	<cfargument name="Value" type="string" required="true" />
	
	<cfset arrayAppend(variables._instance.Headers, arguments) />
</cffunction>
<!--- GetHeaders() --->
<cffunction name="GetHeaders" returntype="array" access="public" output="false" hint="Gets the Headers property">
	<cfreturn variables._instance.Headers  />
</cffunction>

</cfcomponent>
	
