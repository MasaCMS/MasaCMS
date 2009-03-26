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
<cfoutput>
<table id="recentActivity">
<tr>
	<th colspan="2">#application.rbFactory.getKeyValue(session.rb,"dashboard.recentactivity")#</th>
</tr>
<tr class="alt">
	<th class="alt"><a href="index.cfm?fuseaction=cDashboard.listSessions&siteID=#attributes.siteID#&membersOnly=false&visitorStatus=All&spanType=n&span=15">#application.rbFactory.getKeyValue(session.rb,"dashboard.currentvisitors")#</a> <span>(#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.spannow"),15)#)</span></th><td>#application.dashboardManager.getSiteSessionCount(attributes.siteID,false,"All",15,"n")# </td>
</tr>
<tr>
	<th class="alt"><!--- <a href="index.cfm?fuseaction=cDashboard.listSessions&siteID=#attributes.siteID#&membersOnly=false&spanType=#spanType#&span=#spanUnits#"> --->#application.rbFactory.getKeyValue(session.rb,"dashboard.visits")#<!--- </a> --->  <span>(#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.span"),attributes.span)#)</span></th><td>#application.dashboardManager.getSiteSessionCount(attributes.siteID,false,"All",spanUnits,spanType)#</td>
</tr>
<tr class="alt">
	<th class="alt">#application.rbFactory.getKeyValue(session.rb,"dashboard.returnvisits")# <span>(#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.span"),attributes.span)#)</span></th><td>#application.dashboardManager.getSiteSessionCount(attributes.siteID,false,"Return",spanUnits,spanType)#</td>
</tr>
</table>
<cfif application.settingsManager.getSite(attributes.siteID).getExtranet() eq 1>
<table class="stripe" id="memberActivity">
<tr>
	<th colspan="2">#application.rbFactory.getKeyValue(session.rb,"dashboard.memberactivity")#</th>
</tr>
<tr class="alt">
	<th class="alt"><a href="index.cfm?fuseaction=cDashboard.listSessions&siteID=#attributes.siteID#&membersOnly=true&visitorStatus=All&spanType=n&span=15">#application.rbFactory.getKeyValue(session.rb,"dashboard.currentmembers")#</a><span> (#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.spannow"),15)#)</span></th><td>#application.dashboardManager.getSiteSessionCount(attributes.siteID,true,false,15,"n")# </td>
</tr>
<tr>
	<th class="alt"><!--- <a href="index.cfm?fuseaction=cDashboard.listSessions&siteID=#attributes.siteID#&membersOnly=true&spanType=#spanType#&span=#spanUnits#"> --->#application.rbFactory.getKeyValue(session.rb,"dashboard.membervisits")#<!--- </a> ---><span> (#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.span"),attributes.span)#)</span></th><td>#application.dashboardManager.getSiteSessionCount(attributes.siteID,true,false,spanUnits,spanType)#</td>
</tr>
<cfif application.settingsManager.getSite(attributes.siteID).getExtranetPublicReg() eq 1>
<tr class="alt">
	<th class="alt"><cfif application.permUtility.getModulePerm('00000000000000000000000000000000008','#attributes.siteid#')><a href="index.cfm?fuseaction=cPublicUsers.advancedSearch&siteid=#attributes.siteid#&param=1&paramField1=#urlEncodedFormat('tusers.created^date')#&paramCondition1=GTE&paramCriteria1=#urlEncodedFormat(attributes.startDate)#&paramRelationship1=and&inActive=">#application.rbFactory.getKeyValue(session.rb,"dashboard.memberregistrations")#</a><cfelse>#application.rbFactory.getKeyValue(session.rb,"dashboard.memberregistrations")#</cfif><span> (#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.span"),attributes.span)#)</span></th><td>#application.dashboardManager.getCreatedMembers(attributes.siteID,attributes.startDate,attributes.stopDate)#</td>
</tr>
</cfif>
<!--- <tr>
	<th class="alt">#application.rbFactory.getKeyValue(session.rb,"dashboard.mostactiveusers")#</th><td>##</td>
</tr> --->
</table>
</cfif></cfoutput>