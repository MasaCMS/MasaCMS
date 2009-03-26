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

<cfset rslist=application.classExtensionManager.getSubTypes(attributes.siteID) />
<h2>Class Extension Attribute Sets</h2>

<cfoutput>


<cfset subType=application.classExtensionManager.getSubTypeByID(attributes.subTypeID)>
<cfset extendSets=subType.getExtendSets()/>

<ul class="metadata">
		<li><strong>Class Extension:</strong> #application.classExtensionManager.getTypeAsString(subType.getType())# / #subType.getSubType()#</li>
</ul>

<ul id="navTask">
<li><a href="index.cfm?fuseaction=cExtend.listSubTypes&siteid=#attributes.siteid#">List All Class Extensions</a></li>
<li><a href="index.cfm?fuseaction=cExtend.editSubType&subTypeID=#attributes.subTypeID#&siteid=#attributes.siteid#">Edit Class Extension</a></li>
<li><a href="index.cfm?fuseaction=cExtend.editSet&subTypeID=#attributes.subTypeID#&siteid=#attributes.siteid#&extendSetID=">Add Attribute Set</a></li>
</ul>

</cfoutput>
<cfif arrayLen(extendSets)>
<a href="javascript:;" style="display:none;" id="saveSort" onclick="saveExtendSetSort('setList');return false;">[Save Order]</a>
<a href="javascript:;"  id="showSort" onclick="showSaveSort('setList');return false;">[Reorder]</a>
</cfif>

<p>
<cfif arrayLen(extendSets)>

<ul id="setList">
<cfloop from="1" to="#arrayLen(extendSets)#" index="s">	
<cfset extendSetBean=extendSets[s]/>
<cfoutput>
	<li extendSetID="#extendSetBean.getExtendSetID()#">
	<span id="handle#s#" class="handle" style="display:none;">[Drag]</span>
	#extendSetBean.getName()#
		<a title="Edit" href="index.cfm?fuseaction=cExtend.editAttributes&subTypeID=#attributes.subTypeID#&extendSetID=#extendSetBean.getExtendSetID()#&siteid=#attributes.siteid#">[Edit]</a>
		<a title="Delete" href="index.cfm?fuseaction=cExtend.updateSet&action=delete&subTypeID=#attributes.subTypeID#&extendSetID=#extendSetBean.getExtendSetID()#&siteid=#attributes.siteid#" onclick="return confirm('Delete  #jsStringFormat("'#extendSetBean.getname()#'")#?')">[Delete]</a>
		</li>
</cfoutput>
</cfloop>
</ul>
 
<cfelse>
<em>There are currently no available extension sets.</em>
</cfif>
</p>
