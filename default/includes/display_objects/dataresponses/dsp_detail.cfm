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
<cfset rsData=application.dataCollectionManager.read(request.responseid)/>
<cfif request.contentBean.getResponseDisplayFields() neq ''>
<cfset fieldnames=replace(listLast(request.contentBean.getResponseDisplayFields(),"~"),"^",",","ALL")/>
<cfelse>
<cfset fieldnames=application.dataCollectionManager.getCurrentFieldList(request.contentBean.getcontentId())/>
</cfif>
<cfwddx action="wddx2cfml" input="#rsdata.data#" output="info">
</cfsilent>
<cfoutput>
<div id="dsp_detail" class="dataResponses">
<h3>#request.contentBean.getTitle()#</h3>
<a class="actionItem" href="#application.configBean.getIndexFile()#">Return to List</a>
<dl>
<cfloop list="#fieldnames#" index="f">
	<cftry><cfset fValue=info['#f#']><cfcatch><cfset fValue=""></cfcatch></cftry>
	<dt>#f#</dt>
	<dd>#fvalue#</dd>
</cfloop>
</dl>
</cfoutput>
</div>