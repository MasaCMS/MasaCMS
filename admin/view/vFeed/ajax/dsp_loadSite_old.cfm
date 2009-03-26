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

<cf_siteGenerate siteid="#attributes.siteid#" moduleid="00000000000000000000000000000000000"  parentid="00000000000000000000000000000000END" nestlevel=0 parentlabels="parentlabels" parentlist="parentlist" >
<cfoutput>
<br/>
<select id="contentSelector" name="filterid" class="dropdown">
<cfloop from="1" to="#listlen(request.parentlist)#" index="I">
<cfif not(application.settingsManager.getSite(attributes.siteid).getlocking() eq 'top' and listgetat(request.parentlist,I) eq '00000000000000000000000000000000001') >
<option value="#listgetat(request.parentlist,I)#">#listgetat(request.parentlabels,I)#</option>
</cfif>
</cfloop>
</select><input name="addFilter" type="button" onClick="addContentFilter();" value="Add Content Filter"/>
<a href="##" onclick="loadSiteFeed('#attributes.siteid#');return false;">Refresh</a>
</cfoutput>
