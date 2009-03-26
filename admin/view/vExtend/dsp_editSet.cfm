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

<cfset subType=application.classExtensionManager.getSubTypeByID(attributes.subTypeID)>
<cfset extendSetBean=subType.loadSet(attributes.extendSetID) />
<h2><cfif len(attributes.extendSetID)>Edit<cfelse>Add</cfif> Attribute Set</h2>
<cfoutput>
	
<ul class="metadata">
<li><strong>Class Extension:</strong> #application.classExtensionManager.getTypeAsString(subType.getType())# / #subType.getSubType()#</li>
</ul>

<ul id="navTask">
<li><a href="index.cfm?fuseaction=cExtend.listSubTypes&siteid=#attributes.siteid#">Class Extension Manager</a></li>
<li><a href="index.cfm?fuseaction=cExtend.listSets&subTypeID=#attributes.subTypeID#&siteid=#attributes.siteid#">Back to Attribute Sets</a></li>
</ul>


<form name="form1" method="post" action="index.cfm" onsubit="return validateForm(this);">
<dl class="oneColumn">
<dt class="first">Attribute Set Name</dt>
<dd><input name="name" value="#HTMLEditFormat(extendSetBean.getName())#" required="true"/></dd>
<cfif subType.getType() neq  "1" and application.categoryManager.getCategoryCount(attributes.siteID)>
<dt>Available Category Dependencies</dt>
<dd class="categoryAssignment"><cf_dsp_categories_nest siteID="#attributes.siteID#" parentID="" nestLevel="0" extendSetBean="#extendSetBean#"></dd>
</cfif></dl>
<cfif not len(attributes.extendSetID)>
<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'add');"><span>Add</span></a><input type=hidden name="extendSetID" value="#createuuid()#"><cfelse> <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'delete','This');"><span>Delete</span></a> <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'update');"><span>Update</span></a>

<input type=hidden name="extendSetID" value="#extendSetBean.getExtendSetID()#"></cfif><input type="hidden" name="action" value="">
<input name="fuseaction" value="cExtend.updateSet" type="hidden">
<input name="siteID" value="#attributes.siteID#" type="hidden">
<input name="subTypeID" value="#subType.getSubTypeID()#" type="hidden">
</form>
</cfoutput>