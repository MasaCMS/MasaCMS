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
<cfinclude template="../act_defaults.cfm">
<cfoutput>
<table class="mura-table-grid stripe" id="recentActivity">
<tr>
	<th colspan="2">#application.rbFactory.getKeyValue(session.rb,"dashboard.recentactivity")#</th>
</tr>
<tr class="alt">
	<th class="alt"><a href="index.cfm?fuseaction=cDashboard.listSessions&siteid=#URLEncodedFormat(attributes.siteid)#&membersOnly=false&visitorStatus=All&spanType=n&span=15">#application.rbFactory.getKeyValue(session.rb,"dashboard.currentvisitors")#</a> <span>(#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.spannow"),15)#)</span></th><td>#application.dashboardManager.getSiteSessionCount(attributes.siteID,false,"All",15,"n")# </td>
</tr>
<tr>
	<th class="alt"><!--- <a href="index.cfm?fuseaction=cDashboard.listSessions&siteid=#URLEncodedFormat(attributes.siteid)#&membersOnly=false&spanType=#spanType#&span=#spanUnits#"> --->#application.rbFactory.getKeyValue(session.rb,"dashboard.visits")#<!--- </a> --->  <span>(#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.span"),attributes.span)#)</span></th><td>#application.dashboardManager.getSiteSessionCount(attributes.siteID,false,"All",spanUnits,spanType)#</td>
</tr>
<tr class="alt">
	<th class="alt">#application.rbFactory.getKeyValue(session.rb,"dashboard.returnvisits")# <span>(#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.span"),attributes.span)#)</span></th><td>#application.dashboardManager.getSiteSessionCount(attributes.siteID,false,"Return",spanUnits,spanType)#</td>
</tr>
</table>
<cfif application.settingsManager.getSite(attributes.siteID).getExtranet() eq 1>
<table class="mura-table-grid stripe" id="memberActivity">
<tr>
	<th colspan="2">#application.rbFactory.getKeyValue(session.rb,"dashboard.memberactivity")#</th>
</tr>
<tr class="alt">
	<th class="alt"><a href="index.cfm?fuseaction=cDashboard.listSessions&siteid=#URLEncodedFormat(attributes.siteid)#&membersOnly=true&visitorStatus=All&spanType=n&span=15">#application.rbFactory.getKeyValue(session.rb,"dashboard.currentmembers")#</a><span> (#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.spannow"),15)#)</span></th><td>#application.dashboardManager.getSiteSessionCount(attributes.siteID,true,false,15,"n")# </td>
</tr>
<tr>
	<th class="alt"><!--- <a href="index.cfm?fuseaction=cDashboard.listSessions&siteid=#URLEncodedFormat(attributes.siteid)#&membersOnly=true&spanType=#spanType#&span=#spanUnits#"> --->#application.rbFactory.getKeyValue(session.rb,"dashboard.membervisits")#<!--- </a> ---><span> (#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.span"),attributes.span)#)</span></th><td>#application.dashboardManager.getSiteSessionCount(attributes.siteID,true,false,spanUnits,spanType)#</td>
</tr>
<cfif application.settingsManager.getSite(attributes.siteID).getExtranetPublicReg() eq 1>
<tr class="alt">
	<th class="alt"><cfif application.permUtility.getModulePerm('00000000000000000000000000000000008','#attributes.siteid#')><a href="index.cfm?fuseaction=cPublicUsers.advancedSearch&siteid=#URLEncodedFormat(attributes.siteid)#&param=1&paramField1=#urlEncodedFormat('tusers.created^date')#&paramCondition1=GTE&paramCriteria1=#urlEncodedFormat(attributes.startDate)#&paramRelationship1=and&inActive=">#application.rbFactory.getKeyValue(session.rb,"dashboard.memberregistrations")#</a><cfelse>#application.rbFactory.getKeyValue(session.rb,"dashboard.memberregistrations")#</cfif><span> (#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.span"),attributes.span)#)</span></th><td>#application.dashboardManager.getCreatedMembers(attributes.siteID,attributes.startDate,attributes.stopDate)#</td>
</tr>
</cfif>
<!--- <tr>
	<th class="alt">#application.rbFactory.getKeyValue(session.rb,"dashboard.mostactiveusers")#</th><td>##</td>
</tr> --->
</table>
</cfif></cfoutput>