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

<cfparam name="attributes.keywords" default="">
<cfparam name="attributes.isNew" default="1">
<cfset counter=0 />
<cfoutput>
<div id="contentSearch">
<h3>Content Search</h3>
	<input id="parentSearch" name="parentSearch" value="#attributes.keywords#" type="text" class="text" maxlength="50"/><a class="submit" href="javascript:;" onclick="loadSiteFilters('#attributes.siteid#',document.getElementById('parentSearch').value,0);return false;"><span>Search</span></a>
	</div>
</cfoutput>
<cfif not attributes.isNew>
<cfset request.rsList=application.contentManager.getPrivateSearch(attributes.siteid,attributes.keywords)/>
 <table class="stripe">
    <tr> 
	  <th class="add">&nbsp;</th>
      <th class="title">Select New Section</th>
    </tr><cfif request.rslist.recordcount>
     <cfoutput query="request.rslist" startrow="1" maxrows="100">	
		<cfset crumbdata=application.contentManager.getCrumbList(request.rslist.contentid, attributes.siteid)/>
        <cfif not listFind(arraytolist(crumbdata[1].parentArray),attributes.contentid)>
		<cfset counter=counter+1/>
		<tr <cfif not(counter mod 2)>class="alt"</cfif>>
		<td class="add"><a title="Add" href="javascript:;" onClick="addContentFilter('#request.rslist.contentid#','#request.rslist.type#','#JSStringFormat(request.rslist.menuTitle)#'); return false;">&nbsp;</a>
		  </td>
          <td class="title">#application.contentRenderer.dspZoomNoLinks(crumbdata)#</td>
		</tr>
	 	</cfif>
       </cfoutput>
	 	<cfelse>
		<tr class="alt"><cfoutput>  
		  <td class="title" colspan="2"><em>Your search returned no results.</em></td>
		</tr></cfoutput>
		</cfif>
  </table>
</td></tr></table>
</cfif>