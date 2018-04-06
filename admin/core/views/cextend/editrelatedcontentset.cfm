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
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->

<cfset subType = application.classExtensionManager.getSubTypeByID(rc.subTypeID)>
<cfset rcsBean = $.getBean('relatedContentSet').loadBy(relatedContentSetID=rc.relatedContentSetID)>


<cfoutput>
<div class="mura-header">
	<h1><cfif len(rc.relatedContentSetID)>Edit<cfelse>Add</cfif> Related Content Set</h1>

	<div class="nav-module-specific btn-group">
	<a class="btn" href="./?muraAction=cExtend.listSubTypes&siteid=#esapiEncode('url',rc.siteid)#"><i class="mi-arrow-circle-left"></i> Back to Class Extensions</a>
	<a class="btn" href="./?muraAction=cExtend.listSets&subTypeID=#esapiEncode('url',rc.subTypeID)#&siteid=#esapiEncode('url',rc.siteid)#"><i class="mi-arrow-circle-left"></i> Back to Extension Overview</a>
	</div>

</div> <!-- /.mura-header -->

<div class="block block-constrain">
		<div class="block block-bordered">
		  <div class="block-content">

			<h2><i class="#subtype.getIconClass(includeDefault=true)# mi-lg"></i> #application.classExtensionManager.getTypeAsString(subType.getType())# / #esapiEncode('html',subType.getSubType())#</h2>


			<form novalidate="novalidate" name="form1" method="post" action="index.cfm" onsubit="return validateForm(this);">


	<div class="mura-control-group">
	<label>Related Content Set Name</label>
	<input name="name" type="text" value="#esapiEncode('html_attr',rcsBean.getName())#" required="true"/>
	</div>
		<cfset rsSubTypes=application.classExtensionManager.getSubTypes(siteID=rc.siteID,activeOnly=true) />
	<div class="mura-control-group availableSubTypesContainer" >
		<label>Allow users to add only specific subtypes?</label>
			<label class="radio inline" ><input name="hasAvailableSubTypes" type="radio" class="radio inline" value="1" <cfif len(rcsBean.getAvailableSubTypes())>checked </cfif>onclick="javascript:toggleDisplay2('rg',true);">Yes</label>
			<label class="radio inline"><input name="hasAvailableSubTypes" type="radio" class="radio inline" value="0" <cfif not len(rcsBean.getAvailableSubtypes())>checked </cfif>
			onclick="javascript:toggleDisplay2('rg',false);">No</label>
		</div>
		<div class="mura-control-group" id="rg"<cfif not len(rcsBean.getAvailableSubTypes())> style="display:none;"</cfif>>
				<label>Select Subtypes</label>
			<select name="availableSubTypes" size="8" multiple="multiple" class="multiSelect" id="availableSubTypes">
			<cfloop list="Page,Folder,Calendar,Gallery,File,Link" index="i">
				<option value="#i#/Default" <cfif listFindNoCase(rcsBean.getAvailableSubTypes(),'#i#/Default')> selected</cfif>>#i#/Default</option>
				<cfquery name="rsItemTypes" dbtype="query">
				select * from rsSubTypes where lower(type)='#lcase(i)#' and lower(subtype) != 'default'
				</cfquery>
				<cfset _AvailableSubTypes=rcsBean.getAvailableSubTypes()>
				<cfloop query="rsItemTypes">
				<option value="#i#/#rsItemTypes.subType#" <cfif listFindNoCase(_AvailableSubTypes,'#i#/#rsItemTypes.subType#')> selected</cfif>>#i#/#rsItemTypes.subType#</option>
				</cfloop>
			</cfloop>
			</select>
		</div>

			<div class="mura-actions">
				<div class="form-actions">
					<cfif not len(rc.relatedContentSetID)>
						<cfset rc.relatedContentSetID=createUUID()>
						<button class="btn mura-primary" type="button" onclick="submitForm(document.forms.form1,'add');"><i class="mi-check-circle"></i>Add</button>
						<input type=hidden name="relatedContentSetID" value="#rc.relatedContentSetID#">
					<cfelse>
						<button class="btn" type="button" onclick="submitForm(document.forms.form1,'delete','Delete Related Content Set?');"><i class="mi-trash"></i>Delete</button>
						<button class="btn mura-primary" type="button" onclick="submitForm(document.forms.form1,'update');"><i class="mi-check-circle"></i>Update</button>
						<input type=hidden name="relatedContentSetID" value="#esapiEncode('html_attr',rcsBean.getRelatedContentSetID())#">
					</cfif>
				</div>
			</div>

			<input type="hidden" name="action" value="">
			<input name="muraAction" value="cExtend.updateRelatedContentSet" type="hidden">
			<input name="siteID" value="#esapiEncode('html_attr',rc.siteid)#" type="hidden">
			<input name="subTypeID" value="#subType.getSubTypeID()#" type="hidden">
			#rc.$.renderCSRFTokens(context=rc.relatedContentSetID,format="form")#
			</form>

		</div> <!-- /.block-content -->
	</div> <!-- /.block-bordered -->
</div> <!-- /.block-constrain -->

</cfoutput>
