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

<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="configBean" type="any" required="yes"/>
	<cfargument name="settingsManager" type="any" required="yes"/>
	<cfargument name="contentRenderer" type="any" required="yes"/>
	
		<cfset variables.instance.configBean=arguments.configBean />
		<cfset variables.instance.settingsManager=arguments.settingsManager />
		<cfset variables.instance.contentRenderer=arguments.contentRenderer />
		
	<cfreturn this />
</cffunction>

<cffunction name="setMailer" returntype="any" access="public" output="false">
<cfargument name="mailer"  required="true">

	<cfset variables.instance.mailer=arguments.mailer />

</cffunction>

<cffunction name="sendReminders" returntype="void" access="public" output="false">
<cfargument name="rsReminders" type="query">

<cfset var returnURL=""/>
<cfset var startDate=""/>
<cfset var startTime=""/>
<cfset var siteName=""/>
<cfset var eventTitle=""/>
<cfset var eventContactName=""/>
<cfset var eventContactAddress=""/>
<cfset var eventContactCity=""/>
<cfset var eventContactState=""/>
<cfset var eventContactZip=""/>
<cfset var eventContactPhone=""/>
<cfset var finder=""/>
<cfset var reminderScript=""/>
<cfset var thestring=""/>
<cfset var mailtext=""/>

<cfloop query="arguments.rsReminders">

<cfset setLocale(variables.instance.settingsManager.getSite(rsReminders.siteID).getJavaLocale())>

<cfset returnURL=variables.instance.contentRenderer.createHREF('Page',arguments.rsReminders.filename,arguments.rsReminders.siteid,'','','','',variables.instance.configBean.getContext(),variables.instance.configBean.getStub(),variables.instance.configBean.getIndexFile(),true) />
<cfset eventTitle="#arguments.rsReminders.title#"/>
<cfset startDate="#lsdateformat(arguments.rsReminders.displayStart,'long')#"/>
<cfset startTime="#lstimeformat(arguments.rsReminders.displayStart,'short')#"/>
<cfset siteName="#arguments.rsReminders.site#"/>
<cfset eventContactName="#arguments.rsReminders.contactName#"/>
<cfset eventContactAddress="#arguments.rsReminders.contactName#"/>
<cfset eventContactCity="#arguments.rsReminders.contactCity#"/>
<cfset eventContactState="#arguments.rsReminders.contactState#"/>
<cfset eventContactZip="#arguments.rsReminders.contactZip#"/>
<cfset eventContactPhone="#arguments.rsReminders.contactPhone#"/>
<cfset finder=""/>
<cfset reminderScript=variables.instance.settingsManager.getSite(arguments.rsReminders.siteid).getReminderScript() />

<cfif reminderScript neq ''>

	<cfset theString = reminderScript/>
	<cfset finder=refind('##.+?##',theString,1,"true")>
	<cfloop condition="#finder.len[1]#">
		<cftry>
			<cfset theString=replace(theString,mid(theString, finder.pos[1], finder.len[1]),'#trim(evaluate(mid(theString, finder.pos[1], finder.len[1])))#')>
			<cfcatch>
				<cfset theString=replace(theString,mid(theString, finder.pos[1], finder.len[1]),'')>
			</cfcatch>
		</cftry>
		<cfset finder=refind('##.+?##',theString,1,"true")>
	</cfloop>
	<cfset reminderScript = theString/>
	

	<cfsavecontent variable="mailText">
<cfoutput>#reminderScript#</cfoutput>
	</cfsavecontent>

<cfelse>
	<cfsavecontent variable="mailText">
<cfoutput>Just a quick note from #siteName# to remind you that the #eventTitle# will take place on #startDate# (#startTime#). 
 
If you would like to view more information on the event, click here:
#returnURL#

We hope to see you there!

#eventContactName#
#eventContactAddress# 
#eventContactCity#, #eventContactState# #eventContactZip# 
Phone #eventContactPhone#</cfoutput>
	</cfsavecontent>
</cfif>
		  
<cfset variables.instance.mailer.sendText(mailText,
				arguments.rsReminders.email,
				arguments.rsReminders.site,
				"Event Reminder from #arguments.rsReminders.site#",
				arguments.rsReminders.siteid) />
			
<cfquery>
update tcontenteventreminders set isSent=1 where 
siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.rsReminders.siteid#"/>
and contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.rsReminders.contentid#"/>
and email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.rsReminders.email#"/>
</cfquery>

</cfloop>

	

</cffunction> 

</cfcomponent>