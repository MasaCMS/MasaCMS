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


<table class="mura-table-grid stripe"> 
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