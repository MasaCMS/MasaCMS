<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->

<cfset typeList="1^tusers^userID^tclassextenddatauseractivity,2^tusers^userID^tclassextenddatauseractivity,Address^tuseraddresses^addressID^tclassextenddatauseractivity,Page^tcontent^contentHistID^tclassextenddata,Portal^tcontent^contentHistID^tclassextenddata,File^tcontent^contentHistID^tclassextenddata,Calendar^tcontent^contentHistID^tclassextenddata,Gallery^tcontent^contentHistID^tclassextenddata,Link^tcontent^contentHistID^tclassextenddata,Component^tcontent^contentHistID^tclassextenddata,Custom^custom^ID^tclassextenddata"/>
<cfset subType=application.classExtensionManager.getSubTypeByID(attributes.subTypeID)>
<h2><cfif len(attributes.subTypeID)>Edit<cfelse>Add</cfif> Class Extension</h2>
<cfoutput>
<ul id="navTask">
<li><a href="index.cfm?fuseaction=cExtend.listSubTypes&siteid=#URLEncodedFormat(attributes.siteid)#">Class Extension Manager</a></li>
</ul>

<form novalidate="novalidate" name="subTypeFrm" method="post" action="index.cfm" onsubit="return validateForm(this);">
<dl class="oneColumn separate">
<dt class="first">Base Type</dt>
<dd><select name="typeSelector" required="true" message="The BASE CLASS field is required." onchange="setBaseInfo(this.value);">
	<option value="">Select</option>
	<cfloop list="#typeList#" index="t"><option value="#t#" <cfif listFirst(t,'^') eq subType.getType()>selected</cfif>>#application.classExtensionManager.getTypeAsString(listFirst(t,'^'))#</option></cfloop>
	</select>
<!--- 	
	<input name="type" value="#HTMLEditFormat(subType.getType())#" required="true"/> ---></dd>
<dt>Sub Type</dt>
<dd><input name="subType" value="#HTMLEditFormat(subType.getSubType())#" required="true" maxlength="25"/></dd>
<dt>Active</dt>
<dd><ul class="radioGroup"><li><input name="isActive" type="radio" class="radio" value="1"<cfif subType.getIsActive() eq 1 >Checked</cfif>>Yes</li><li><input name="isActive" type="radio" class="radio" value="0"<cfif subType.getIsActive() eq 0 >Checked</cfif>>No</li></ul></dd>
</dl>
<div id="actionButtons">
<cfif not len(attributes.subTypeID)>
<input type="button" class="submit" onclick="submitForm(document.forms.subTypeFrm,'add');" value="Add" /><input type=hidden name="subTypeID" value="#createuuid()#"><cfelse> <input type="button" class="submit" onclick="submitForm(document.forms.subTypeFrm,'delete','Delete Class Extension?');" value="Delete" /> <input type="button" class="submit" onclick="submitForm(document.forms.subTypeFrm,'update');" value="Update" />

<input type=hidden name="subTypeID" value="#subType.getsubtypeID()#"></div></cfif><input type="hidden" name="action" value="">
<input name="fuseaction" value="cExtend.updateSubType" type="hidden">
<input name="siteID" value="#HTMLEditFormat(attributes.siteid)#" type="hidden">
<input type="hidden" name="baseTable" value="#subType.getBaseTable()#"/>
<input type="hidden" name="baseKeyField" value="#subType.getBaseKeyField()#" />
<input type="hidden" name="type" value="#subType.getType()#"/>
<input type="hidden" name="dataTable" value="#subType.getDataTable()#" />

</form>
</cfoutput>