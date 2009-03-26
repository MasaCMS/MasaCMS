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

<cfset subType=application.classExtensionManager.getSubTypeByID(attributes.subTypeID) />
<cfset extendSet=subType.loadSet(attributes.extendSetID)/>
<cfset attributesArray=extendSet.getAttributes() />
<h2>Manage Attributes Set</h2>
<cfoutput>
<ul class="metadata">
		<li><strong>Class Extension:</strong> #application.classExtensionManager.getTypeAsString(subType.getType())# / #subType.getSubType()#</li>
		<li><strong>Attributes Set:</strong> #extendSet.getName()#</li>
</ul>

<ul id="navTask">
<li><a href="index.cfm?fuseaction=cExtend.listSubTypes&siteid=#attributes.siteid#">List All Class Extensions</a></li>
<li><a href="index.cfm?fuseaction=cExtend.editSubType&subTypeID=#attributes.subTypeID#&siteid=#attributes.siteid#">Edit Class Extension</a></li>
<li><a href="index.cfm?fuseaction=cExtend.editSet&subTypeID=#attributes.subTypeID#&extendSetID=#attributes.extendSetID#&siteid=#attributes.siteid#">Edit Attribute Set</a></li>
<li><a href="index.cfm?fuseaction=cExtend.listSets&subTypeID=#attributes.subTypeID#&siteid=#attributes.siteid#">Back to Attribute Sets</a></li>
<!--- <li><a href="index.cfm?fuseaction=cExtend.editSet&subTypeID=#attributes.subTypeID#&&extendSetID=#attributes.extendSetID#&siteid=#attributes.siteid#&attributeID=">Add Attribute</a></li> --->
</ul>

<cfset newAttribute=extendSet.getAttributeBean() />
<cfset newAttribute.setSiteID(attributes.siteID) />
<cfset newAttribute.setOrderno(arrayLen(attributesArray)+1) />
<cf_dsp_attribute_form attributeBean="#newAttribute#" action="add" subTypeID="#attributes.subTypeID#" formName="newFrm">

<cfif arrayLen(attributesArray)>
<a href="javascript:;" style="display:none;" id="saveSort" onclick="saveAttributeSort('attributesList');return false;">[Save Order]</a>
<a href="javascript:;"  id="showSort" onclick="showSaveSort('attributesList');return false;">[Reorder]</a>
</cfif>

<p>
<cfif arrayLen(attributesArray)>
<ul id="attributesList">
<cfloop from="1" to="#arrayLen(attributesArray)#" index="a">	
<cfset attributeBean=attributesArray[a]/>
<cfoutput>
	<li attributeID="#attributeBean.getAttributeID()#">
		<span id="handle#a#" class="handle" style="display:none;">[Drag]</span>
		#attributeBean.getName()#
		<a title="Edit" href="javascript:;" id="editFrm#a#open" onclick="new Effect.SlideDown($('editFrm#a#container'));this.style.display='none';$('editFrm#a#close').style.display='';return false;">[Edit]</a>
		<a title="Edit" href="javascript:;" style="display:none;" id="editFrm#a#close" onclick="new Effect.SlideUp($('editFrm#a#container'));this.style.display='none';$('editFrm#a#open').style.display='';return false;">[Close]</a>
		<a title="Delete" href="index.cfm?fuseaction=cExtend.updateAttribute&action=delete&subTypeID=#attributes.subTypeID#&extendSetID=#attributeBean.getExtendSetID()#&siteid=#attributes.siteid#&attributeID=#attributeBean.getAttributeID()#" onClick="return confirm('Delete the attribute #jsStringFormat("'#attributeBean.getname()#'")#?')">[Delete]</a>

	<div style="display:none;" id="editFrm#a#container">
		<cf_dsp_attribute_form attributeBean="#attributeBean#" action="edit" subTypeID="#attributes.subTypeID#" formName="editFrm#a#">
	</div>
	</li>
</cfoutput>
</cfloop>
</ul>

<cfelse>
<br/>
<em>This set has no attributes.</em>
</cfif>
</p>
</cfoutput>