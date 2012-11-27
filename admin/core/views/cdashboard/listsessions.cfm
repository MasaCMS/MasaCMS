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

<cfsilent>
<cfif rc.spanType eq 'n'>
<cfset spanLabel='Minutes' />
<cfelse>
<cfif rc.span eq 1>
	<cfset spanLabel='Day' />
<cfelse>
	<cfset spanLabel='Days' />
</cfif>
</cfif>
</cfsilent>

<cfoutput><h1><cfif rc.membersOnly>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.membersessions")#<cfelse>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.allsessions")#</cfif>
<span>
	(<cfif rc.spanType eq 'n'>#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.spannow"),rc.span)#<cfelse>#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.spannow"),rc.span)#</cfif>)
</span></h1>

<cfinclude template="dsp_secondary_menu.cfm">

<h2>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.totalsessions")#: <strong>#rc.rslist.recordcount#</strong></h2>
<div>
<cfif rc.contentid neq ''>
<cfset crumbdata=application.contentManager.getCrumbList(rc.contentid, rc.siteid)/>
<h3>#application.contentRenderer.dspZoom(crumbdata)#</h3>
</cfif>

<table class="table table-striped table-condensed table-bordered mura-table-grid"> 
<tr>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.user")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.locale")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.lastrequest")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.views")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.lengthofvisit")#</th>
<th class="actions">&nbsp;</th>
</tr>
<cfif rc.rslist.recordcount>
<cfset rc.nextN=application.utility.getNextN(rc.rsList,20,rc.startrow)/>
<cfset endrow=(rc.startrow+rc.nextN.recordsperpage)-1/>
<cfloop query="rc.rslist" startrow="#rc.startRow#" endrow="#endRow#">
<tr>
<td><a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#" href="index.cfm?muraAction=cDashboard.viewSession&urlToken=#urlEncodedFormat(rc.rslist.urlToken)#&siteid=#URLEncodedFormat(rc.siteid)#"><cfif rc.rslist.userid eq ''>Anonymous<cfelse>#HTMLEditFormat(rc.rslist.fname)# #HTMLEditFormat(rc.rslist.lname)#<cfif rc.rslist.company neq ''> (#HTMLEditFormat(rc.rslist.company)#)</cfif></cfif></a></td>
<td>#rc.rslist.locale#</td>
<td>#LSDateFormat(rc.rslist.lastRequest,session.dateKeyFormat)# #LSTimeFormat(rc.rslist.lastRequest,"short")#</td>
<td>#rc.rslist.views#</td>
<td>#application.dashboardManager.getTimespan(rc.rslist.firstRequest,rc.rslist.lastRequest)#</td>
<td class="actions"><ul class="one"><li class="viewDetails"><a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#" href="index.cfm?muraAction=cDashboard.viewSession&urlToken=#urlEncodedFormat(rc.rslist.urlToken)#&siteid=#URLEncodedFormat(rc.siteid)#"><i class="icon-pencil"></i></a></li></ul></td>
</tr></cfloop>
<cfelse>
<tr>
<td class="noResults"colspan="6">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.session.spannoresults"),"#rc.span# #spanLabel#")#.</td>
</tr>
</cfif>
</table>

<cfif rc.rslist.recordcount and rc.nextN.numberofpages gt 1>
#application.rbFactory.getKeyValue(session.rb,"dashboard.session.moreresults")#: <cfif rc.nextN.currentpagenumber gt 1> <a href="index.cfm?muraAction=cDashboard.listSessions&startrow=#rc.nextN.previous#&siteid=#URLEncodedFormat(rc.siteid)#&direction=#rc.direction#&orderBy=#rc.orderBy#&spanType=#rc.spanType#&span=#rc.span#">&laquo;&nbsp;#application.rbFactory.getKeyValue(session.rb,"dashboard.session.prev")#</a></cfif>
<cfloop from="#rc.nextN.firstPage#"  to="#rc.nextN.lastPage#" index="i">
	<cfif rc.nextN.currentpagenumber eq i> #i# <cfelse> <a href="index.cfm?muraAction=cDashBoard.listSessions&startrow=#evaluate('(#i#*#rc.nextN.recordsperpage#)-#rc.nextN.recordsperpage#+1')#&siteid=#URLEncodedFormat(rc.siteid)#&direction=#rc.direction#&orderBy=#rc.orderBy#&spanType=#rc.spanType#&span=#rc.span#">#i#</a> </cfif></cfloop>
	<cfif rc.nextN.currentpagenumber lt rc.nextN.NumberOfPages><a href="index.cfm?muraAction=cDashboard.listSessions&startrow=#rc.nextN.next#&siteid=#URLEncodedFormat(rc.siteid)#&direction=#rc.direction#&orderBy=#rc.orderBy#&spanType=#rc.spanType#&span=#rc.span#">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.next")#&nbsp;&raquo;</a></cfif> 

</cfif>	  
</div>
</cfoutput>