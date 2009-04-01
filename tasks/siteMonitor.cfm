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

<cfset theTime=now()/>
<cfparam name="application.lastMonitored" default="#dateadd('n',-1,theTime)#"/>
<cfset addPrev=minute(application.lastMonitored) neq minute(dateadd("n",-30,theTime))/>

<cfif addPrev>
<cfset application.contentManager.sendReminders(dateadd("n",-30,theTime)) />
</cfif>
<cfset application.contentManager.sendReminders(theTime) />

<!---<cfif hour(theTime) eq 2 and (minute(theTime) eq 0 or (addPrev and minute(application.lastMonitored) eq 0))>
<cfset application.advertiserManager.compact() />
</cfif>--->

<cfset application.emailManager.send() />

<cfset emailList="" />
<cfloop collection="#application.settingsManager.getSites()#" item="site"> 
<cfset theEmail = application.settingsManager.getSite(site).getMailServerUsername() />
	<cfif not listFind(emailList,theEmail)>
		<cfset application.emailManager.trackBounces(site) />
		<cfset listAppend(emailList,theEmail) />
	</cfif>
</cfloop>

<cfif (minute(theTime) eq 0 and hour(theTime) eq 0) or (addPrev and (minute(application.lastMonitored) eq 0 and hour(application.lastmonitored) eq 0))>
	<cfset application.settingsManager.purgeAllCache() />
	<cftry>
	<cfset application.projectManager.sendReminders() />
	<cfcatch></cfcatch>
	</cftry>
<cfelse>
	<cfquery name="rsChanges" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	select distinct tcontent.siteid from tcontent inner join tcontent tcontent2 on tcontent.parentid=tcontent2.contentid 
	where tcontent.approved=1 and tcontent.active=1 and tcontent.display=2 and tcontent2.type <> 'Calendar'
	and ((tcontent.displaystart >=#createodbcdatetime(application.lastmonitored)#
	and tcontent.displaystart <=#createodbcdatetime(theTime)#)
	or
	(tcontent.displaystop >=#createodbcdatetime(application.lastmonitored)#
	and tcontent.displaystop <=#createodbcdatetime(theTime)#))
	group by tcontent.siteid
	</cfquery>
	
	<cfif rsChanges.recordcount>
		<cfloop query="rsChanges">
			<cfset application.settingsManager.getSite(rsChanges.siteid).purgeCache() />
		</cfloop>
	</cfif>
</cfif>
<!--- clear out old temp files --->
<cfdirectory name="tmpFiles" action="list" directory="#GetTempDirectory()#" >

 <cfloop query="tmpFiles">
  <cfif tmpFiles.type eq "File" and DateDiff('n',tmpFiles.datelastmodified,now()) gt 30>
  <cffile action="delete" file="#GetTempDirectory()##tmpFiles.name#">
  </cfif>
</cfloop> 

<cfset pluginEvent = createObject("component","#application.configBean.getMapDir()#.event") />
<cfset application.pluginManager.executeScripts('onSiteMonitor','',pluginEvent)/>

<cfset application.lastMonitored=theTime/>