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

<cfset subType=application.classExtensionManager.getSubTypeByID(rc.subTypeID)>
<cfset extendSetBean=subType.loadSet(rc.extendSetID) />
<h1><cfif len(rc.extendSetID)>Edit<cfelse>Add</cfif> Attribute Set</h1>
<cfoutput>

<div id="nav-module-specific" class="btn-group">
<a class="btn" href="index.cfm?muraAction=cExtend.listSubTypes&siteid=#URLEncodedFormat(rc.siteid)#"><i class="icon-circle-arrow-left"></i> Back to Class Extensions</a>
<a class="btn" href="index.cfm?muraAction=cExtend.listSets&subTypeID=#rc.subTypeID#&siteid=#URLEncodedFormat(rc.siteid)#"><i class="icon-circle-arrow-left"></i> Back to Attribute Sets</a>
</div>

<ul class="metadata">
<li><strong>Class Extension:</strong> #application.classExtensionManager.getTypeAsString(subType.getType())# / #subType.getSubType()#</li>
</ul>

<form class="fieldset-wrap" novalidate="novalidate" name="form1" method="post" action="index.cfm" onsubit="return validateForm(this);">

<div class="fieldset">

<div class="control-group">
	<label class="control-label">Attribute Set Name</label>
	<div class="controls">
	<input name="name" type="text" value="#HTMLEditFormat(extendSetBean.getName())#" required="true"/>
	</div>
</div>

<cfif subType.getType() neq "Custom">
	<div class="control-group">
		<label class="control-label">Container (Tab)</label>
		<div class="controls">
			<select name="container">
				<option value="Default">Extended Attributes</option>			
				<cfif listFindNoCase('Page,Folder,File,Gallery,Calender,Link',subType.getType())>
					<cfloop list="#application.contentManager.getTabList()#" index="t">
					<cfif t neq 'Extended Attributes'>
					<option value="#t#"<cfif extendSetBean.getContainer() eq t> selected</cfif>>
					</cfif>
	      			#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.#REreplace(t, "[^\\\w]", "", "all")#")#
	      			</option>
	      		</cfloop>
	      		<cfelseif listFindNoCase('Component,Form',subType.getType())>
					<cfloop list="Basic,Categorization,Usage Report" index="t">
					<option value="#t#"<cfif extendSetBean.getContainer() eq t> selected</cfif>>
	      			#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.#REreplace(t, "[^\\\w]", "", "all")#")#
	      			</option>
	      		</cfloop>
	      		<cfelseif subType.getType() neq 'site'>
					<option value="Basic"<cfif extendSetBean.getContainer() eq "Basic"> selected</cfif>>Basic Tab</option>
				</cfif>
				<option value="Custom"<cfif extendSetBean.getContainer() eq "Custom"> selected</cfif>>Custom UI</option>
			</select>
		</div>
	</div>
<cfelse>
	<input name="container" value="Custom" type="hidden"/>	
</cfif>

<!---
<cfif  not listFindNoCase("1,Site,Custom", subtype.getType()) and application.categoryManager.getCategoryCount(rc.siteID)>
	<div class="control-group">
		<label class="control-label">Available Category Dependencies</label>
		<div class="controls categoryAssignment"><cf_dsp_categories_nest siteID="#rc.siteID#" parentID="" nestLevel="0" extendSetBean="#extendSetBean#">
		</div>
	</div>
</cfif>
--->

</div>
<div class="form-actions">
<cfif not len(rc.extendSetID)>
	<input type="button" class="btn" onclick="submitForm(document.forms.form1,'add');" value="Add" />
	<input type=hidden name="extendSetID" value="#createuuid()#">
<cfelse>
	<input type="button" class="btn" onclick="submitForm(document.forms.form1,'delete','Delete Attribute Set?');" value="Delete" />
	<input type="button" class="btn" onclick="submitForm(document.forms.form1,'update');" value="Update" />
	<input type=hidden name="extendSetID" value="#extendSetBean.getExtendSetID()#">
</cfif>
</div>

<input type="hidden" name="action" value="">
<input name="muraAction" value="cExtend.updateSet" type="hidden">
<input name="siteID" value="#HTMLEditFormat(rc.siteid)#" type="hidden">
<input name="subTypeID" value="#subType.getSubTypeID()#" type="hidden">
</form>
</cfoutput>