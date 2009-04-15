<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfsilent>
<cfset data.sortby=request.contentBean.getSortBy()/>
<cfset data.sortDirection=request.contentBean.getSortDirection()/>
<cfset data.siteid=request.contentBean.getsiteId()/>
<cfset data.contentid=request.contentBean.getcontentId()/>
<cfset data.keywords=request.keywords />
<cfset data.fieldnames=application.dataCollectionManager.getCurrentFieldList(data.contentid)/>
<cfset rsData=application.dataCollectionManager.getData(data)/>
</cfsilent>
<cfif rsData.recordcount>
<cfsilent>
<cfset nextN=application.utility.getNextN(rsData,request.contentBean.getNextN(),request.StartRow)>
			
<cfif request.contentBean.getResponseDisplayFields() neq ''>
<cfset data.fieldnames=replace(listFirst(request.contentBean.getResponseDisplayFields(),"~"),"^",",","ALL")/>
</cfif>
</cfsilent>
<div id="dsp_list" class="dataResponses">
<cfoutput><h3>#request.contentBean.getTitle()#</h3></cfoutput>
<table class="stripe">
<tr>
<cfloop list="#data.fieldnames#" index="f">
<th><cfoutput>#f#</cfoutput></th>
</cfloop>

</tr>
<cfoutput query="rsData" startrow="#request.startRow#" maxrows="#nextN.RecordsPerPage#">
<tr>
<cfsilent><cfwddx action="wddx2cfml" input="#rsdata.data#" output="info"></cfsilent>
<cfloop list="#data.fieldnames#" index="f">
	<cftry><cfset fValue=info['#f#']><cfcatch><cfset fValue=""></cfcatch></cftry>
<td><a href="#application.configBean.getIndexFile()#?fuseaction=detail&responseid=#rsdata.responseid#">#fvalue#</a></td>
</cfloop>

</tr>
</cfoutput>
</table>
<cfif nextN.numberofpages gt 1>
			<div class="moreResults"><h4>More Results:</h4> 
			<cfoutput><ul>
			<cfif nextN.currentpagenumber gt 1>
				<li><a href="#application.configBean.getIndexFile()#?startrow=#nextN.previous#&categoryID=#request.categoryID#&relatedID=#request.relatedID#">&laquo;&nbsp;Prev</a></li>
			</cfif>
			<cfloop from="#nextn.firstPage#"  to="#nextn.lastPage#" index="i">
			<cfif nextn.currentpagenumber eq i><li class="current">#i#</li><cfelse><li><a href="#application.configBean.getIndexFile()#?startrow=#evaluate('(#i#*#nextn.recordsperpage#)-#nextn.recordsperpage#+1')#&categoryID=#request.categoryID#&relatedID=#request.relatedID#">#i#</a></li></cfif>
			</cfloop>
			<cfif nextN.currentpagenumber lt nextN.NumberOfPages>
				<li><a href="#application.configBean.getIndexFile()#?startrow=#nextN.next#&categoryID=#request.categoryID#&relatedID=#request.relatedID#">Next&nbsp;&raquo;</a></li>
			</cfif>
			</ul></cfoutput>
			</div>
</cfif>
<cfelse>
<em>There is currently no data collected</em>
</cfif>
</div>