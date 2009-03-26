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

<!--- <cfoutput>
<cfswitch expression="#attributes.classid#">
<cfcase value="examples">
<cfset request.rsExamples=application.exampleManager.getExampleBySiteID(attributes.siteid,'') />
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfloop query="request.rsExamples">
<option value="[component type]~#request.rsExample.name#~[uniqueID]">#request.rsExample.name#</option>	
</cfloop>
</select>
</cfcase>
</cfswitch>
</cfoutput> --->