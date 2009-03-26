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

<cfoutput><h2>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.sessionhistory")#</h2>
<cfsilent>
<cfset lastAccessed=application.dashboardManager.getLastSessionDate(request.rslist.urlToken,request.rslist.originalUrlToken,request.rslist.entered) />
</cfsilent>

<ul class="metadata">
<li><strong>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.user")#:</strong> #application.dashboardManager.getUserFromSessionQuery(request.rslist)#</li>
<li><strong>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.lastaccessed")#:</strong> <cfif LSisDate(lastAccessed)>#LSDateFormat(lastAccessed,session.dateKeyFormat)#<cfelse>Not Available</cfif></li>
<cfif LSisDate(lastAccessed)><li><strong>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.timebetweenvisit")#:</strong> #application.dashboardManager.getTimespan(lastAccessed,request.rslist.entered,"long")#</li></cfif> 
<li><strong>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.lengthofvisit")#:</strong> #application.dashboardManager.getTimespan(request.rslist.entered[request.rslist.recordcount],request.rslist.entered[1])#</li>
</ul>


<table class="stripe"> 
<tr>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.user")#</th>
<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.content")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.requesttime")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.keywords")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.locale")#</th>
<th>&nbsp;</th>
</tr>
<cfloop query="request.rslist">
<cfset crumbdata=application.contentManager.getCrumbList(request.rslist.contentid, attributes.siteid)/>
<tr>
<td><cfif request.rslist.userid eq ''>Anonymous<cfelse>#HTMLEditFormat(request.rslist.fname)# #HTMLEditFormat(request.rslist.lname)#<cfif request.rslist.company neq ''> (#HTMLEditFormat(request.rslist.company)#)</cfif></cfif></td>
<td class="varWidth">#application.contentRenderer.dspZoom(crumbdata,request.rslist.fileEXT)#</td>

<td>#LSDateFormat(request.rslist.entered,session.dateKeyFormat)# #LSTimeFormat(request.rslist.entered,"short")#</td>
<td><cfif request.rslist.keywords neq ''>#HTMLEditFormat(request.rslist.keywords)#<cfelse>&mdash;</cfif></td>
<td>#request.rslist.locale#</td>
<td class="administration"><ul class="one"><li class="preview"><cfswitch expression="#request.rslist.type#">
		<cfcase value="Page,Portal,Calendar,Gallery">
		<a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,request.rsList.filename)#','#request.rslist.targetParams#');">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#</a>
		</cfcase>
		<cfcase value="Link">
		<a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#" href="javascript:preview('#request.rslist.filename#','#request.rslist.targetParams#');">#application.rbFactory.getKeyValue(session.rb,"dashboard.view")#</a>
		</cfcase>
		<cfcase value="File">
		<a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,"")#?LinkServID=#request.rslist.contentid#','#request.rslist.targetParams#');">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#</a>
		</cfcase>
		</cfswitch></li></ul></td>
</tr></cfloop>

</table>
</cfoutput>