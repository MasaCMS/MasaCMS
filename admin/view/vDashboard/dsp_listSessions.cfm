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

<cfsilent>
<cfif attributes.spanType eq 'n'>
<cfset spanLabel='Minutes' />
<cfelse>
<cfif attributes.span eq 1>
	<cfset spanLabel='Day' />
<cfelse>
	<cfset spanLabel='Days' />
</cfif>
</cfif>
</cfsilent>

<cfoutput><h2><cfif attributes.membersOnly>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.membersessions")#<cfelse>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.allsessions")#</cfif>
<span>
	(<cfif attributes.spanType eq 'n'>#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.spannow"),attributes.span)#<cfelse>#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.spannow"),attributes.span)#</cfif>)
</span></h2>

<h3>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.totalsessions")#: <strong>#request.rslist.recordcount#</strong></h3>
<div>
<cfif attributes.contentid neq ''>
<cfset crumbdata=application.contentManager.getCrumbList(attributes.contentid, attributes.siteid)/>
<h4>#application.contentRenderer.dspZoom(crumbdata)#</h4>
</cfif>

<table class="stripe"> 
<tr>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.user")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.locale")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.lastrequest")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.views")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.lengthofvisit")#</th>
<th class="administration">&nbsp;</th>
</tr>
<cfif request.rslist.recordcount>
<cfset request.nextN=application.utility.getNextN(request.rsList,20,attributes.startrow)/>
<cfset endrow=(attributes.startrow+request.nextN.recordsperpage)-1/>
<cfloop query="request.rslist" startrow="#attributes.startRow#" endrow="#endRow#">
<tr>
<td><a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#" href="index.cfm?fuseaction=cDashboard.viewSession&urlToken=#urlEncodedFormat(request.rslist.urlToken)#&siteid=#attributes.siteid#"><cfif request.rslist.userid eq ''>Anonymous<cfelse>#HTMLEditFormat(request.rslist.fname)# #HTMLEditFormat(request.rslist.lname)#<cfif request.rslist.company neq ''> (#HTMLEditFormat(request.rslist.company)#)</cfif></cfif></a></td>
<td>#request.rslist.locale#</td>
<td>#LSDateFormat(request.rslist.lastRequest,session.dateKeyFormat)# #LSTimeFormat(request.rslist.lastRequest,"short")#</td>
<td>#request.rslist.views#</td>
<td>#application.dashboardManager.getTimespan(request.rslist.firstRequest,request.rslist.lastRequest)#</td>
<td class="administration"><ul class="one"><li class="viewDetails"><a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#" href="index.cfm?fuseaction=cDashboard.viewSession&urlToken=#urlEncodedFormat(request.rslist.urlToken)#&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#</a></li></ul></td>
</tr></cfloop>
<cfelse>
<tr>
<td class="noResults"colspan="6">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.session.spannoresults"),"#attributes.span# #spanLabel#")#.</td>
</tr>
</cfif>
</table>

<cfif request.rslist.recordcount and request.nextN.numberofpages gt 1>
#application.rbFactory.getKeyValue(session.rb,"dashboard.session.moreresults")#: <cfif request.nextN.currentpagenumber gt 1> <a href="index.cfm?fuseaction=cDashboard.listSessions&startrow=#request.nextN.previous#&siteid=#attributes.siteid#&direction=#attributes.direction#&orderBy=#attributes.orderBy#&spanType=#attributes.spanType#&span=#attributes.span#">&laquo;&nbsp;#application.rbFactory.getKeyValue(session.rb,"dashboard.session.prev")#</a></cfif>
<cfloop from="#request.nextN.firstPage#"  to="#request.nextN.lastPage#" index="i">
	<cfif request.nextN.currentpagenumber eq i> #i# <cfelse> <a href="index.cfm?fuseaction=cDashBoard.listSessions&startrow=#evaluate('(#i#*#request.nextN.recordsperpage#)-#request.nextN.recordsperpage#+1')#&siteid=#attributes.siteid#&direction=#attributes.direction#&orderBy=#attributes.orderBy#&spanType=#attributes.spanType#&span=#attributes.span#">#i#</a> </cfif></cfloop>
	<cfif request.nextN.currentpagenumber lt request.nextN.NumberOfPages><a href="index.cfm?fuseaction=cDashboard.listSessions&startrow=#request.nextN.next#&siteid=#attributes.siteid#&direction=#attributes.direction#&orderBy=#attributes.orderBy#&spanType=#attributes.spanType#&span=#attributes.span#">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.next")#&nbsp;&raquo;</a></cfif> 

</cfif>	  
</div>
</cfoutput>