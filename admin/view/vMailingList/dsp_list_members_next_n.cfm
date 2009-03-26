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

 <cfif request.nextN.numberofpages gt 1>
<tr> <cfoutput>
      <td colspan="7" class="results">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.moreresults')#: 
		<cfif request.nextN.currentpagenumber gt 1> <a href="index.cfm?fuseaction=cMailingList.listmembers&mlid=#attributes.mlid#&startrow=#request.nextN.previous#&siteid=#attributes.siteid#">&laquo;&nbsp;#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.prev')#</a></cfif>	
		<cfloop from="#request.nextN.lastPage#"  to="#request.nextN.lastPage#" index="i"><cfif request.nextN.currentpagenumber eq i> <strong>#i#</strong> <cfelse> <a href="index.cfm?fuseaction=cMailingList.listmembers&mlid=#attributes.mlid#&startrow=#evaluate('(#i#*#request.nextN.recordsperpage#)-#request.nextN.recordsperpage#+1')#&siteid=#attributes.siteid#">#i#</a> </cfif></cfloop>
		<cfif request.nextN.currentpagenumber lt request.nextN.NumberOfPages><a href="index.cfm?fuseaction=cMailingList.listmembers&mlid=#attributes.mlid#&startrow=#request.nextN.next#&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.next')#&nbsp;&raquo;</a></cfif> 
		</td></tr></cfoutput>
</cfif>