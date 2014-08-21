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
<cfset request.layout="false">
<cfinclude template="act_defaults.cfm">
<cfsilent>
	  <cfset emailStart=createDate(year(now()),month(now()),1)>
	  <cfset emailStop=createDate(year(now()),month(now()),day(now()))>
	  <cfset rsList = application.emailManager.getEmailActivity(rc.siteID,3,emailStart,emailStop) >
	  <cfset emailLimit = application.settingsManager.getSite(rc.siteID).getEmailBroadcasterLimit()>
	  <cfset emailsSent = application.emailManager.getSentCount(rc.siteID,emailStart,emailStop)>
	  <cfif emailLimit eq 0>
	  	<cfset emailLimitText = application.rbFactory.getKeyValue(session.rb,"dashboard.unlimited")>
		<cfset emailsRemainingText = application.rbFactory.getKeyValue(session.rb,"dashboard.unlimited")>
	  <cfelse>
	  	<cfset emailLimitText = emailLimit>
		<cfset emailsRemainingText = emailLimit - emailsSent>
	  </cfif>
</cfsilent>  

<cfoutput>
<h2><i class="icon-envelope"></i> #application.rbFactory.getKeyValue(session.rb,"dashboard.emailbroadcasts")# <span>(#lsDateFormat(emailStart,session.dateKeyFormat)# - #lsDateFormat(emailStop,session.dateKeyFormat)#)</span></h2>
<dl><dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.emailssent")#:</dt><dd>#emailsSent#</dd><dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.emailsalloted")#:</dt><dd>#emailLimitText#</dd><dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.emailsremaining")#:</dt><dd>#emailsRemainingText#</dd></dl>

<!---<h3>Recent Campaign Activity</h3>--->
<table class="mura-table-grid">
<thead>
<tr>
	<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.title")#</th><th>#application.rbFactory.getKeyValue(session.rb,"dashboard.sent")#</th><th>#application.rbFactory.getKeyValue(session.rb,"dashboard.opens")#</th><th>#application.rbFactory.getKeyValue(session.rb,"dashboard.clicks")#</th><th>#application.rbFactory.getKeyValue(session.rb,"dashboard.bounces")#</th>
</tr>
</thead>
<tbody>
<cfif rslist.recordcount>
<cfloop query="rsList">
<cfsilent>
<cfset clicks=application.emailManager.getStat(rslist.emailid,'returnClick')/>
<cfset opens=application.emailManager.getStat(rslist.emailid,'emailOpen')/>
<cfset sent=application.emailManager.getStat(rslist.emailid,'sent')/>
<cfset bounces=application.emailManager.getStat(rslist.emailid,'bounce')/>
</cfsilent>				  
<tr>
<td class="title"><a href="./?muraAction=cEmail.edit&siteid=#esapiEncode('url',rc.siteid)#&emailID=#rslist.emailID#">#rsList.subject#</td><td>#sent#</td><td>#opens#</td><td>#clicks#</td><td>#bounces#</td>
</tr>
</cfloop>
<cfelse>
<tr><td class="noResults" colspan="5">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.noemails"),rc.span)#</td></tr>
</cfif>
</tbody>
</table></cfoutput>