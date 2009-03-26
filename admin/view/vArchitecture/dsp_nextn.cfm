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

<cfset isMore=rsNext.recordcount gt session.nextN>

<cfif isMore>

<cfset nextN=application.utility.getNextN(rsNext,session.nextN,attributes.startRow,5)>
<!--- <cfset TotalRecords=rsNext.RecordCount>
<cfset RecordsPerPage=session.nextN> 
<cfset NumberOfPages=Ceiling(TotalRecords/RecordsPerPage)>
<cfset CurrentPageNumber=Ceiling(attributes.StartRow/RecordsPerPage)> --->

<cfif application.settingsManager.getSite(attributes.siteid).getlocking() neq 'all'>
<cfset numRows=8>
<cfelse>
<cfset numRows=4>
</cfif>
<cfsavecontent variable="pagelist"><cfoutput> 
<tr>
           <td class="add">&nbsp;</td>
            <td class="title" colspan="#numRows#">
      More: 
		  <cfif nextN.currentpagenumber gt 1><a href="index.cfm?fuseaction=cArch.list&siteid=#attributes.siteid#&topid=#attributes.topid#&moduleid=00000000000000000000000000000000000&startrow=#nextN.previous#">&laquo;&nbsp;Prev</a> </cfif>
		  <cfloop from="#nextN.firstPage#"  to="#nextN.lastPage#" index="i">
		  <cfif nextN.currentpagenumber eq i> <strong>#i#</strong><cfelse>  <a href="index.cfm?fuseaction=cArch.list&siteid=#attributes.siteid#&topid=#attributes.topid#&moduleid=00000000000000000000000000000000000&startrow=#evaluate('(#i#*#nextN.recordsperpage#)-#nextN.recordsperpage#+1')#">#i#</a> </cfif>
	     </cfloop>
		 <cfif nextN.currentpagenumber lt nextN.NumberOfPages><a href="index.cfm?fuseaction=cArch.list&siteid=#attributes.siteid#&topid=#attributes.topid#&moduleid=00000000000000000000000000000000000&startrow=#nextN.next#">Next&nbsp;&raquo;</a> </cfif>
		</td>
          </tr></cfoutput>
</cfsavecontent>

</cfif>
