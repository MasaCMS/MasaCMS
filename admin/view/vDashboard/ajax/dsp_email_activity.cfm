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

<cfinclude template="../act_defaults.cfm">
<cfsilent>
	  <cfset emailStart=createDate(year(now()),month(now()),1)>
	  <cfset emailStop=createDate(year(now()),month(now()),day(now()))>
	  <cfset rsList = application.emailManager.getEmailActivity(attributes.siteID,3,emailStart,emailStop) >
	  <cfset emailLimit = application.settingsManager.getSite(attributes.siteID).getEmailBroadcasterLimit()>
	  <cfset emailsSent = application.emailManager.getSentCount(attributes.siteID,emailStart,emailStop)>
	  <cfif emailLimit eq 0>
	  	<cfset emailLimitText = application.rbFactory.getKeyValue(session.rb,"dashboard.unlimited")>
		<cfset emailsRemainingText = application.rbFactory.getKeyValue(session.rb,"dashboard.unlimited")>
	  <cfelse>
	  	<cfset emailLimitText = emailLimit>
		<cfset emailsRemainingText = emailLimit - emailsSent>
	  </cfif>
</cfsilent>  

<cfoutput><div id="emailBroadcasts" class="separate">
<h3>#application.rbFactory.getKeyValue(session.rb,"dashboard.emailbroadcasts")# <span>(#lsDateFormat(emailStart,session.dateKeyFormat)# - #lsDateFormat(emailStop,session.dateKeyFormat)#)</span></h3>
<dl><dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.emailssent")#:</dt><dd>#emailsSent#</dd><dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.emailsalloted")#:</dt><dd>#emailLimitText#</dd><dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.emailsremaining")#:</dt><dd>#emailsRemainingText#</dd></dl>

<!---<h4>Recent Campaign Activity</h4>--->
<table>
<tr>
	<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.title")#</th><th>#application.rbFactory.getKeyValue(session.rb,"dashboard.sent")#</th><th>#application.rbFactory.getKeyValue(session.rb,"dashboard.opens")#</th><th>#application.rbFactory.getKeyValue(session.rb,"dashboard.clicks")#</th><th>#application.rbFactory.getKeyValue(session.rb,"dashboard.bounces")#</th>
</tr>
<cfif rslist.recordcount>
<cfloop query="rsList">
<cfsilent>
<cfset clicks=application.emailManager.getStat(rslist.emailid,'returnClick')/>
<cfset opens=application.emailManager.getStat(rslist.emailid,'emailOpen')/>
<cfset sent=application.emailManager.getStat(rslist.emailid,'sent')/>
<cfset bounces=application.emailManager.getStat(rslist.emailid,'bounce')/>
</cfsilent>				  
<tr<cfif rslist.currentrow mod 2> class="alt"</cfif>>
<td class="title"><a href="index.cfm?fuseaction=cEmail.edit&siteID=#attributes.siteID#&emailID=#rslist.emailID#">#rsList.subject#</td><td>#sent#</td><td>#opens#</td><td>#clicks#</td><td>#bounces#</td>
</tr>
</cfloop>
<cfelse>
<tr class="alt"><td class="noResults" colspan="5">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.noemails"),attributes.span)#</td></tr>
</cfif>
</table></div></cfoutput>