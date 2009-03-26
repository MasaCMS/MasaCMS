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

<cfset typeList="1^tusers^userID^tclassextenddatauseractivity,2^tusers^userID^tclassextenddatauseractivity,Page^tcontent^contentHistID^tclassextenddata,Portal^tcontent^contentHistID^tclassextenddata,File^tcontent^contentHistID^tclassextenddata,Calendar^tcontent^contentHistID^tclassextenddata,Gallery^tcontent^contentHistID^tclassextenddata,Link^tcontent^contentHistID^tclassextenddata"/>
<cfset subType=application.classExtensionManager.getSubTypeByID(attributes.subTypeID)>
<h2><cfif len(attributes.subTypeID)>Edit<cfelse>Add</cfif> Class Extension</h2>
<cfoutput>
<ul id="navTask">
<li><a href="index.cfm?fuseaction=cExtend.listSubTypes&siteid=#attributes.siteid#">Class Extension Manager</a></li>
</ul>

<form name="subTypeFrm" method="post" action="index.cfm" onsubit="return validateForm(this);">
<dl class="oneColumn">
<dt class="first">Base Type</dt>
<dd><select name="typeSelector" required="true" message="The BASE CLASS field is required." onchange="setBaseInfo(this.value);">
	<option value="">Select</option>
	<cfloop list="#typeList#" index="t"><option value="#t#" <cfif listFirst(t,'^') eq subType.getType()>selected</cfif>>#application.classExtensionManager.getTypeAsString(listFirst(t,'^'))#</option></cfloop>
	</select>
<!--- 	
	<input name="type" value="#HTMLEditFormat(subType.getType())#" required="true"/> ---></dd>
<dt>Sub Type</dt>
<dd><input name="subType" value="#HTMLEditFormat(subType.getSubType())#" required="true"/></dd>
</dl>
<cfif not len(attributes.subTypeID)>
<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.subTypeFrm,'add');"><span>Add</span></a><input type=hidden name="subTypeID" value="#createuuid()#"><cfelse> <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.subTypeFrm,'delete','This');"><span>Delete</span></a> <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.subTypeFrm,'update');"><span>Update</span></a>

<input type=hidden name="subTypeID" value="#subType.getsubtypeID()#"></cfif><input type="hidden" name="action" value="">
<input name="fuseaction" value="cExtend.updateSubType" type="hidden">
<input name="siteID" value="#attributes.siteID#" type="hidden">
<input type="hidden" name="baseTable" value="#subType.getBaseTable()#"/>
<input type="hidden" name="baseKeyField" value="#subType.getBaseKeyField()#" />
<input type="hidden" name="type" value="#subType.getType()#"/>
<input type="hidden" name="dataTable" value="#subType.getDataTable()#" />

</form>
</cfoutput>