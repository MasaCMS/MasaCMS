<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfset typeList="1^tusers^userID^tclassextenddatauseractivity,2^tusers^userID^tclassextenddatauseractivity,Address^tuseraddresses^addressID^tclassextenddatauseractivity,Page^tcontent^contentHistID^tclassextenddata,Portal^tcontent^contentHistID^tclassextenddata,File^tcontent^contentHistID^tclassextenddata,Calendar^tcontent^contentHistID^tclassextenddata,Gallery^tcontent^contentHistID^tclassextenddata,Link^tcontent^contentHistID^tclassextenddata"/>
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
<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.subTypeFrm,'add');"><span>Add</span></a><input type=hidden name="subTypeID" value="#createuuid()#"><cfelse> <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.subTypeFrm,'delete','Delete Class Extension?');"><span>Delete</span></a> <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.subTypeFrm,'update');"><span>Update</span></a>

<input type=hidden name="subTypeID" value="#subType.getsubtypeID()#"></cfif><input type="hidden" name="action" value="">
<input name="fuseaction" value="cExtend.updateSubType" type="hidden">
<input name="siteID" value="#attributes.siteID#" type="hidden">
<input type="hidden" name="baseTable" value="#subType.getBaseTable()#"/>
<input type="hidden" name="baseKeyField" value="#subType.getBaseKeyField()#" />
<input type="hidden" name="type" value="#subType.getType()#"/>
<input type="hidden" name="dataTable" value="#subType.getDataTable()#" />

</form>
</cfoutput>