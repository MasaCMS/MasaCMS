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
<h3>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.searchforcontent')#</h3>
	<input id="parentSearch" name="parentSearch" value="#attributes.keywords#" type="text" class="text" maxlength="50"/><a class="submit" href="javascript:;" onclick="loadSiteParents('#attributes.siteid#','#attributes.contentid#','#attributes.parentid#',document.getElementById('parentSearch').value,0);return false;"><span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.search')#</span></a>
</cfoutput>
<br/><br/><cfif not attributes.isNew>
<cfset request.rsList=application.contentManager.getPrivateSearch(attributes.siteid,attributes.keywords)/>
<cfset parentCrumb=application.contentManager.getCrumbList(attributes.parentid, attributes.siteid)/>
 <table class="stripe">
    <tr> 
      <th class="varWidth"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectnewcontentparent')#</cfoutput></th>
	  <th class="administration">&nbsp;</th>
    </tr><cfif request.rslist.recordcount>
	<tr class="alt"><cfoutput>  
         <td class="varWidth">#application.contentRenderer.dspZoomNoLinks(parentCrumb)#</td>
		  <td class="administration"><input type="radio" name="parentid" value="#attributes.parentid#" checked="checked"></td>
		</tr></cfoutput>
     <cfoutput query="request.rslist" startrow="1" maxrows="100">
		<cfif request.rslist.contentid neq attributes.parentid and request.rslist.type neq 'File' and request.rslist.type neq 'Link'>
		<cfset crumbdata=application.contentManager.getCrumbList(request.rslist.contentid, attributes.siteid)/>
        <cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
		<cfif verdict neq 'none' and not listFind(arraytolist(crumbdata[1].parentArray),attributes.contentid) and request.rslist.type neq 'Link' and request.rslist.type neq 'File'>
		<cfset counter=counter+1/>
		<tr <cfif not(counter mod 2)>class="alt"</cfif>>  
          <td class="varWidth">#application.contentRenderer.dspZoomNoLinks(crumbdata,request.rslist.fileExt)#</td>
		  <td class="administration"><input type="radio" name="parentid" value="#request.rslist.contentid#"></td>
		</tr>
	 	</cfif></cfif>
       </cfoutput>
	 	</cfif>
	 	<cfif not counter>
		<tr class="alt"><cfoutput>  
		  <td class="noResults" colspan="2">#application.rbFactory.getKeyValue(session.rb,'sitemanager.noresults')#<input type="hidden" name="parentid" value="#attributes.parentid#" /> </td>
		</tr></cfoutput>
		</cfif>
  </table>
</td></tr></table>
<cfelse>
<cfoutput><input type="hidden" name="parentid" value="#attributes.parentid#" /></cfoutput>
</cfif>