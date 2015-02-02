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
<cfinclude template="js.cfm">
<cfset typeList="1^tusers^userID^tclassextenddatauseractivity,2^tusers^userID^tclassextenddatauseractivity,Address^tuseraddresses^addressID^tclassextenddatauseractivity,Page^tcontent^contentHistID^tclassextenddata,Folder^tcontent^contentHistID^tclassextenddata,File^tcontent^contentHistID^tclassextenddata,Calendar^tcontent^contentHistID^tclassextenddata,Gallery^tcontent^contentHistID^tclassextenddata,Link^tcontent^contentHistID^tclassextenddata,Component^tcontent^contentHistID^tclassextenddata,Form^tcontent^contentHistID^tclassextenddata,Custom^custom^ID^tclassextenddata,Site^tsettings^baseID^tclassextenddata,Base^tcontent^contentHistID^tclassextenddata"/>
<cfset subType=application.classExtensionManager.getSubTypeByID(rc.subTypeID)>
<h1><cfif len(rc.subTypeID)>Edit<cfelse>Add</cfif> Class Extension</h1>

<cfoutput>
   <div id="nav-module-specific" class="btn-group">
   <cfif not subType.getIsNew()>
      <a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
         <i class="icon-circle-arrow-left"></i> Back <span class="caret"></span>
       </a>
       <ul class="dropdown-menu">
          <li><a href="./?muraAction=cExtend.listSubTypes&siteid=#esapiEncode('url',rc.siteid)#">&hellip;to Class Extensions</a></li>
          <li><a href="./?muraAction=cExtend.listSets&subTypeID=#esapiEncode('url',rc.subTypeID)#&siteid=#esapiEncode('url',rc.siteid)#">&hellip;to Class Extension Overview</a></li>
       </ul>
<cfelse>
	<a class="btn" href="./?muraAction=cExtend.listSubTypes&siteid=#esapiEncode('url',rc.siteid)#"><i class="icon-circle-arrow-left"></i> Back to Class Extension Overview</a>
</cfif>
</div>

<form class="fieldset-wrap" novalidate="novalidate" name="subTypeFrm" method="post" action="index.cfm" onsubit="return validateForm(this);">

<div class="fieldset">
	<div class="control-group">
			<div class="span3">
				<label class="control-label">Base Type</label>
				<div class="controls">
					<select class="span12" name="typeSelector" id="typeSelector" required="true" message="The BASE CLASS field is required." onchange="extendManager.setBaseInfo(this.value);">
					<option value="">Select</option>
						<cfloop list="#typeList#" index="t">
							<option value="#t#" <cfif listFirst(t,'^') eq subType.getType()>selected</cfif>>#application.classExtensionManager.getTypeAsString(listFirst(t,'^'))#</option>
						</cfloop>
					</select>
				</div>
			</div>
			<div class="span3 subTypeContainer"<cfif subtype.getType() eq "Site"> style="display:none;"</cfif>>
				<label class="control-label">Sub Type</label>
				<div class="controls">
					<input class="span12" name="subType" id="subType" type="text" value="#esapiEncode('html_attr',subType.getSubType())#" required="true" maxlength="25"/>
				</div>
			</div>
			<div class="span3 SubTypeIconSelect"<cfif subtype.getType() eq "Site"> style="display:none;"</cfif>>
				<label class="control-label">Icon</label>
				<div class="btn-toolbar">
	              <div class="btn-group">
	              	<cfset currentIcon=subtype.getIconClass(includeDefault=true)>
	              	<cfset defaultIcon=subtype.getDefaultIconClass()>
	                <button class="btn" type="button"><i id="iconcurrent" class="#currentIcon# icon-large"></i></button>
	                <button class="btn dropdown-toggle" data-toggle="dropdown"><span class="caret"></span></button>
					    <ul id="icon-selector" class="dropdown-menu">
					      <cfloop list="#subtype.getIconClasses()#" index="i">
					      	  <li class="icon-selector" data-icon="#i#"><i class="#i#<cfif i eq currentIcon> icon-current</cfif><cfif i eq defaultIcon> icon-default</cfif>"></i></li>
			     		 </cfloop>      
					    </ul>
	              </div>
	              <button type="button" class="btn" id="iconreset"><i class="icon-undo"></i> Reset</button>
				 </div>
	              <input name="iconclass" type="hidden" value="#esapiEncode('html_attr',subtype.getIconClass())#" id="iconclass"/>
	              <script>
	              	$(function(){
	              		var defaultIcon='#defaultIcon#';
	              		var currentIcon='#currentIcon#';

	              		$('.icon-selector').click(function(){
	              			var selectedClass=$(this).attr('data-icon');
	              			$('##iconclass').val(selectedClass);
	              			$('##iconcurrent').attr('class',selectedClass + ' icon-large');
	              			$('.icon-current').removeClass('icon-current');
	              			$('.' + selectedClass).addClass('icon-current');
	              		});

	              		$('##iconreset').click(function(){
	              			$('##iconclass').val('');
	              			$('##iconcurrent').attr('class',defaultIcon + ' icon-large');
	              			$('.icon-current').removeClass('icon-current');
	              		});
	              	});
	              </script>
			</div>	
	</div>
	<div class="control-group">
		<label class="control-label">Description</label>
		<div class="controls"><textarea name="description" id="description" rows="6" class="span12">#esapiEncode('html',subtype.getDescription())#</textarea></div>
		</div>
			
	<div class="control-group hasRow1Container" >
		<div class="span4 hasSummaryContainer">
			<label class="control-label">Show "Summary" field when editing?</label>
			<div class="controls">
			<label class="radio inline"><input name="hasSummary" type="radio" class="radio inline" value="1"<cfif subType.gethasSummary() eq 1 >Checked</cfif>>Yes</label>
			<label class="radio inline"><input name="hasSummary" type="radio" class="radio inline" value="0"<cfif subType.gethasSummary() eq 0 >Checked</cfif>>No</label>
			</div>
		</div>
		
		<div class="span4 hasBodyContainer">
			<label class="control-label">Show "Body" field when editing?</label>
			<div class="controls"> 
				<label class="radio inline"><input name="hasBody" type="radio" class="radio inline" value="1"<cfif subType.gethasBody() eq 1 >Checked</cfif>>Yes</label>
				<label class="radio inline"><input name="hasBody" type="radio" class="radio inline" value="0"<cfif subType.gethasBody() eq 0 >Checked</cfif>>No</label>
			</div>
		</div>

		<div class="span4 hasAssocFileContainer">
			<label class="control-label">Show "Associated Image" field when editing?</label>
			<div class="controls"> 
				<label class="radio inline"><input name="hasAssocFile" type="radio" class="radio inline" value="1"<cfif subType.gethasAssocFile() eq 1 >Checked</cfif>>Yes</label>
				<label class="radio inline"><input name="hasAssocFile" type="radio" class="radio inline" value="0"<cfif subType.gethasAssocFile() eq 0 >Checked</cfif>>No</label>
			</div>
		</div>
	</div>		
	<div class="control-group">
		<cfset rsSubTypes=application.classExtensionManager.getSubTypes(siteID=rc.siteID,activeOnly=true) />
		<div class="span4 availableSubTypesContainer" >
			<label class="control-label">Allow users to add only specific subtypes?</label>
			<div class="controls"> 
				<label class="radio inline" ><input name="hasAvailableSubTypes" type="radio" class="radio inline" value="1" <cfif len(subType.getAvailableSubTypes())>checked </cfif>
				onclick="javascript:toggleDisplay2('rg',true);">Yes</label>
				<label class="radio inline"><input name="hasAvailableSubTypes" type="radio" class="radio inline" value="0" <cfif not len(subType.getAvailableSubtypes())>checked </cfif>
				onclick="javascript:toggleDisplay2('rg',false);">No</label>
			</div>
			<div class="controls" id="rg"<cfif not len(subType.getAvailableSubTypes())> style="display:none;"</cfif>>
				<select name="availableSubTypes" size="8" multiple="multiple" class="multiSelect" id="availableSubTypes">
				<cfloop list="Page,Folder,Calendar,Gallery,File,Link" index="i">
					<option value="#i#/Default" <cfif listFindNoCase(subType.getAvailableSubTypes(),'#i#/Default')> selected</cfif>>#i#/Default</option>
					<cfquery name="rsItemTypes" dbtype="query">
					select * from rsSubTypes where lower(type)='#lcase(i)#' and lower(subtype) != 'default'
					</cfquery>
					<cfset _AvailableSubTypes=subType.getAvailableSubTypes()>
					<cfloop query="rsItemTypes">
					<option value="#i#/#rsItemTypes.subType#" <cfif listFindNoCase(_AvailableSubTypes,'#i#/#rsItemTypes.subType#')> selected</cfif>>#i#/#rsItemTypes.subType#</option>
					</cfloop>
				</cfloop>
				</select>			
			</div>
		</div>
		<div class="span4 hasConfiguratorContainer">
			<label class="control-label">Show "List Display Options" when editing?</label>
			<div class="controls"> 
				<label class="radio inline"><input name="hasConfigurator" type="radio" class="radio inline" value="1"<cfif subType.gethasConfigurator() eq 1 >Checked</cfif>>Yes</label>
				<label class="radio inline"><input name="hasConfigurator" type="radio" class="radio inline" value="0"<cfif subType.gethasConfigurator() eq 0 >Checked</cfif>>No</label>
			</div>
		</div>
		<div class="span4">
			<label class="control-label">Status</label>
			<div class="controls">
					<label class="radio inline"><input name="isActive" type="radio" class="radio inline" value="1"<cfif subType.getIsActive() eq 1 >Checked</cfif>>Active</label>
				<label class="radio inline"><input name="isActive" type="radio" class="radio inline" value="0"<cfif subType.getIsActive() eq 0 >Checked</cfif>>Inactive</label>
			</div>
		</div>
	</div>
</div>	
<div class="form-actions">
	<cfif not len(rc.subTypeID)>
		<cfset rc.subTypeID=createUUID()>
		<input type="button" class="btn" onclick="submitForm(document.forms.subTypeFrm,'add');" value="Add" />
		<input type=hidden name="subTypeID" value="#esapiEncode('html_attr',rc.subTypeID)#">
	<cfelse>
		<input type="button" class="btn" onclick="submitForm(document.forms.subTypeFrm,'delete','Delete Class Extension?');" value="Delete" />
		<input type="button" class="btn" onclick="submitForm(document.forms.subTypeFrm,'update');" value="Update" />
		<input type=hidden name="subTypeID" value="#esapiEncode('html_attr',subType.getsubtypeID())#">
	</cfif>
</div>

<input type="hidden" name="action" value="">
<input name="muraAction" value="cExtend.updateSubType" type="hidden">
<input name="siteID" value="#esapiEncode('html_attr',rc.siteid)#" type="hidden">
<input type="hidden" name="baseTable" value="#esapiEncode('html_attr',subType.getBaseTable())#"/>
<input type="hidden" name="baseKeyField" value="#esapiEncode('html_attr',subType.getBaseKeyField())#" />
<input type="hidden" name="type" value="#esapiEncode('html_attr',subType.getType())#"/>
<input type="hidden" name="dataTable" value="#esapiEncode('html_attr',subType.getDataTable())#" />
#rc.$.renderCSRFTokens(context=rc.subtypeid,format="form")#
</form>

<script>
extendManager.setBaseInfo(jQuery('##typeSelector').val());
</script>
</cfoutput>
