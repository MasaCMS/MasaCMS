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
<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="configBean" type="any" required="yes"/>
	<cfargument name="settingsManager" type="any" required="yes"/>
	<cfargument name="contentRenderer" type="any" required="yes"/>
	<cfargument name="mailer" type="any" required="yes"/>
		<cfset variables.instance.configBean=arguments.configBean />
		<cfset variables.instance.settingsManager=arguments.settingsManager />
		<cfset variables.instance.contentRenderer=arguments.contentRenderer />
		<cfset variables.instance.mailer=arguments.mailer />
	<cfreturn this />
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

<cfset returnURL=variables.instance.contentRenderer.createHREF('Page',arguments.rsReminders.filename,arguments.rsReminders.siteid,'','','','',variables.instance.configBean.getContext(),variables.instance.configBean.getStub(),variables.instance.configBean.getIndexFile(),true) />
<cfset eventTitle="#arguments.rsReminders.title#"/>
<cfset startDate="#lsdateformat(arguments.rsReminders.displayStart,session.dateKeyFormat)#"/>
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
				request.siteid) />
			
<cfquery datasource="#variables.instance.configBean.getDatasource()#">
update tcontenteventreminders set isSent=1 where 
siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.rsReminders.siteid#"/>
and contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.rsReminders.contentid#"/>
and email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.rsReminders.email#"/>
</cfquery>

</cfloop>

	

</cffunction> 
</cfcomponent>