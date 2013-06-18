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
	<cfif application.settingsManager.getSite(site).getEmailBroadcaster()>
		<cfif not listFind(emailList,theEmail)>
			<cfset application.emailManager.trackBounces(site) />
			<cfset listAppend(emailList,theEmail) />
		</cfif>
	</cfif>
	<cfif application.settingsManager.getSite(site).getFeedManager()>
		<cfset application.feedManager.doAutoImport(site)>
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
	select tcontent.siteid, tcontent.contentid from tcontent inner join tcontent tcontent2 on tcontent.parentid=tcontent2.contentid 
	where tcontent.approved=1 and tcontent.active=1 and tcontent.display=2 and tcontent2.type <> 'Calendar'
	and ((tcontent.displaystart >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#application.lastmonitored#">
	and tcontent.displaystart <=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#theTime#">)
	or
	(tcontent.displaystop >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#application.lastmonitored#">
	and tcontent.displaystop <=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#theTime#">))
	group by tcontent.siteid, tcontent.contentid
	</cfquery>
	
	<cfif rsChanges.recordcount>
		<cfloop query="rsChanges">
			<cfset application.serviceFactory
				.getBean('contentManager')
					.purgeContentCache(
						contentBean=application.serviceFactory
							.getBean('content')
							.loadBy(
								contentID=rsChanges.contentid,
								siteid=rsChanges.siteid
							)
					)>
		</cfloop>

		<cfquery name="rsChanges" dbtype="query">
			select distinct siteid from rsChanges
		</cfquery>
		<cfloop query="rsChanges">
			<cfset application.settingsManager.getSite(rsChanges.siteid).purgeCache() />
		</cfloop>
	</cfif>
</cfif>
<!--- clear out old temp files --->
<cfdirectory name="tmpFiles" action="list" directory="#application.configBean.getTempDir()#" >

 <cfloop query="tmpFiles">
  <cfif tmpFiles.type eq "File" and DateDiff('n',tmpFiles.datelastmodified,now()) gt 30>
  <cffile action="delete" file="#application.configBean.getTempDir()##tmpFiles.name#">
  </cfif>
</cfloop> 

<cfset pluginEvent = createObject("component","#application.configBean.getMapDir()#.event") />
<cfset application.pluginManager.executeScripts('onSiteMonitor','',pluginEvent)/>

<cfset application.lastMonitored=theTime/>