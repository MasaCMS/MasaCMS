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

<cfoutput><h2>#application.rbFactory.getKeyValue(session.rb,"categorymanager")#</h2>
<ul id="navTask"><li><a  title="#application.rbFactory.getKeyValue(session.rb,"categorymanager.addnewcategory")#" href="index.cfm?fuseaction=cCategory.edit&categoryID=&parentID=&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,"categorymanager.addnewcategory")#</a></li></ul>
<table class="stripe"> 
<tr>
<th class="add">&nbsp;</td>
<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,"categorymanager.category")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"categorymanager.assignable")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"categorymanager.interestgroup")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"categorymanager.active")#</th>
<th class="administration">&nbsp;</th>
</tr>
<cf_dsp_nest siteID="#attributes.siteID#" parentID="" nestLevel="0" >
</table>
</cfoutput>