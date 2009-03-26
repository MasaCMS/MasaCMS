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
<cfoutput><cfset rsList=application.dashboardManager.getTopContent(attributes.siteID,3,false,"All",attributes.startDate,attributes.stopDate,true) />
<cfset count=rsList.recordcount>
<table id="topPages">
<tr>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.pages")# <a href="index.cfm?fuseaction=cDashboard.topContent&siteID=#attributes.siteID#&startDate=#URLEncodedFormat(attributes.startDate)#&stopDate=#URLEncodedFormat(attributes.stopDate)#">(#application.rbFactory.getKeyValue(session.rb,"dashboard.viewreport")#)</a></th>
</tr>
<cfloop query="rslist">
<tr<cfif rslist.currentrow mod 2> class="alt"</cfif>>
	<td><cfswitch expression="#rslist.type#">
		<cfcase value="Page,Portal,Calendar,Gallery">
		<a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.view")#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,rsList.filename)#','#rslist.targetParams#');">#HTMLEditFormat(left(rslist.menutitle,30-len(rsList.hits)))#</a>
		</cfcase>
		<cfcase value="Link">
		<a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.view")#" href="javascript:preview('#rslist.filename#','#rslist.targetParams#');">#HTMLEditFormat(left(rslist.menutitle,30-len(rsList.hits)))#</a>
		</cfcase>
		<cfcase value="File">
		<a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.view")#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,"")#?LinkServID=#rslist.contentid#','#rslist.targetParams#');">#HTMLEditFormat(left(rslist.menutitle,30-len(rsList.hits)))#</a>
		</cfcase>
		</cfswitch> <span>(#rsList.hits# #application.rbFactory.getKeyValue(session.rb,"dashboard.views")#)</span></td>
</tr>
</cfloop>
<cfif count eq 0><tr class="alt"><td>&mdash;</td></tr></cfif>
<cfif count lt 2><tr><td>&mdash;</td></tr></cfif>
<cfif count lt 3><tr class="alt"><td>&mdash;</td></tr></cfif>
</table>

<cfset rsList=application.dashboardManager.getTopReferers(attributes.siteID,3,attributes.startDate,attributes.stopDate) />
<cfset count=rsList.recordcount>
<table id="topReferrers">
<tr>
	<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.topreferrers")# <a href="index.cfm?fuseaction=cDashboard.topReferers&siteID=#attributes.siteID#&startDate=#URLEncodedFormat(attributes.startDate)#&stopDate=#URLEncodedFormat(attributes.stopDate)#">(#application.rbFactory.getKeyValue(session.rb,"dashboard.viewreport")#)</a></th>
</tr>
<cfloop query="rslist">
<tr<cfif rslist.currentrow mod 2> class="alt"</cfif>>
	<td><cfif rsList.referer neq 'Unknown'><a title="View" href="javascript:preview('#rsList.referer#','');">#left(rsList.referer,30-len(rslist.referals))#&hellip;</a><cfelse>#rsList.referer#</cfif> <span>(#rslist.referals# #application.rbFactory.getKeyValue(session.rb,"dashboard.referrals")#)</span></td>
</tr>
</cfloop>
<cfif count eq 0><tr class="alt"><td>&mdash;</td></tr></cfif>
<cfif count lt 2><tr><td>&mdash;</td></tr></cfif>
<cfif count lt 3><tr class="alt"><td>&mdash;</td></tr></cfif>
</table>

<cfset rsList=application.dashboardManager.getTopKeywords(attributes.siteID,3,false,"All",attributes.startDate,attributes.stopDate) />
<cfset count=rsList.recordcount>
<table id="topSearches">
<tr>
	<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.topsearches")# <a href="index.cfm?fuseaction=cDashboard.topSearches&siteID=#attributes.siteID#&startDate=#URLEncodedFormat(attributes.startDate)#&stopDate=#URLEncodedFormat(attributes.stopDate)#">(View Report)</a></th>
</tr>
<cfloop query="rslist">
<tr<cfif rslist.currentrow mod 2> class="alt"</cfif>>
	<td>#left(rsList.keywords,30-len(rsList.keywordCount))# <span>(#rsList.keywordCount# #application.rbFactory.getKeyValue(session.rb,"dashboard.searches")#)</span></td>
</tr>
</cfloop>
<cfif count eq 0><tr class="alt"><td>&mdash;</td></tr></cfif>
<cfif count lt 2><tr><td>&mdash;</td></tr></cfif>
<cfif count lt 3><tr class="alt"><td>&mdash;</td></tr></cfif>
</table>

<cfset rsList=application.dashboardManager.getTopRated(attributes.siteID,attributes.threshold,3,attributes.startDate,attributes.stopDate) />
<cfset count=rsList.recordcount>
<table id="topRated">
<tr>
	<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.toprated")# <a href="index.cfm?fuseaction=cDashboard.topRated&siteID=#attributes.siteID#&startDate=#URLEncodedFormat(attributes.startDate)#&stopDate=#URLEncodedFormat(attributes.stopDate)#">(View Report)</a></th>
</tr>
<cfloop query="rslist">
<tr<cfif rslist.currentrow mod 2> class="alt"</cfif>>
	<td><cfswitch expression="#rslist.type#">
		<cfcase value="Page,Portal,Calendar,Gallery">
		<a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.view")#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,rsList.filename)#','#rslist.targetParams#');">#HTMLEditFormat(left(rslist.menutitle,28))#</a>
		</cfcase>
		<cfcase value="Link">
		<a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.view")#" href="javascript:preview('#rslist.filename#','#rslist.targetParams#');">#HTMLEditFormat(left(rslist.menutitle,28))#</a>
		</cfcase>
		<cfcase value="File">
		<a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.view")#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,"")#?LinkServID=#rslist.contentid#','#rslist.targetParams#');">#HTMLEditFormat(left(rslist.menutitle,28))#</a>
		</cfcase>
		</cfswitch> <img src="images/rater/star_#application.raterManager.getStarText(rslist.theAvg)#.gif"/></td>
</tr>
</cfloop>
<cfif count eq 0><tr class="alt"><td>&mdash;</td></tr></cfif>
<cfif count lt 2><tr><td>&mdash;</td></tr></cfif>
<cfif count lt 3><tr class="alt"><td>&mdash;</td></tr></cfif>
</table>
</cfoutput>

