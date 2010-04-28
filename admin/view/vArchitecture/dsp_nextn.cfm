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
		  <cfif nextN.currentpagenumber gt 1><a href="index.cfm?fuseaction=cArch.list&siteid=#URLEncodedFormat(attributes.siteid)#&topid=#URLEncodedFormat(attributes.topid)#&moduleid=00000000000000000000000000000000000&startrow=#nextN.previous#">&laquo;&nbsp;Prev</a> </cfif>
		  <cfloop from="#nextN.firstPage#"  to="#nextN.lastPage#" index="i">
		  <cfif nextN.currentpagenumber eq i> <strong>#i#</strong><cfelse>  <a href="index.cfm?fuseaction=cArch.list&siteid=#URLEncodedFormat(attributes.siteid)#&topid=#URLEncodedFormat(attributes.topid)#&moduleid=00000000000000000000000000000000000&startrow=#evaluate('(#i#*#nextN.recordsperpage#)-#nextN.recordsperpage#+1')#">#i#</a> </cfif>
	     </cfloop>
		 <cfif nextN.currentpagenumber lt nextN.NumberOfPages><a href="index.cfm?fuseaction=cArch.list&siteid=#URLEncodedFormat(attributes.siteid)#&topid=#URLEncodedFormat(attributes.topid)#&moduleid=00000000000000000000000000000000000&startrow=#nextN.next#">Next&nbsp;&raquo;</a> </cfif>
		</td>
          </tr></cfoutput>
</cfsavecontent>

</cfif>
