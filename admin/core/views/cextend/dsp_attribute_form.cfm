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

<cfset typeList="TextBox,TextArea,HTMLEditor,SelectBox,MultiSelectBox,RadioGroup,File,Hidden"/>
<cfoutput>


<ul class="nav nav-pills">

<cfif attributes.action eq "add">
<li>
<a href="javascript:;" id="#HTMLEditFormat(attributes.formName)#open" class="btn" onclick="$('###HTMLEditFormat(attributes.formName)#container').slideDown();this.style.display='none';$('###HTMLEditFormat(attributes.formName)#close').show();return false;"><i class="icon-plus-sign"></i> Add New Attribute</a></li>
<li><a href="javascript:;" class="btn" style="display:none;" id="#HTMLEditFormat(attributes.formName)#close" onclick="$('###HTMLEditFormat(attributes.formName)#container').slideUp();this.style.display='none';$('###HTMLEditFormat(attributes.formName)#open').show();return false;"><i class="icon-eye-close"></i> Close</a></li>
<cfif isDefined('attributes.attributesArray') and ArrayLen(attributes.attributesArray)>
<li><a href="javascript:;" class="btn" style="display:none;" id="saveSort" onclick="extendManager.saveAttributeSort('attributesList');return false;"><i class="icon-check"></i> Save Order</a></li>
<li><a href="javascript:;" class="btn" id="showSort" onclick="extendManager.showSaveSort('attributesList');return false;"><i class="icon-move"></i> Reorder</a></li>
</cfif>
</cfif>
</ul>

<cfif attributes.action eq "add">
<div style="display:none;" id="#HTMLEditFormat(attributes.formName)#container" class="attr-add">
</cfif>
<form <cfif attributes.action eq "add"> class="fieldset-wrap"</cfif> novalidate="novalidate" method="post" name="#HTMLEDitFormat(attributes.formName)#" action="index.cfm" onsubmit="return validateForm(this);">
<div class="fieldset">
<cfif attributes.action neq "add">
<div class="control-group">
	<label class="control-label">Attribute ID</label>
	<div class="controls">
		#attributes.attributeBean.getAttributeID()#
	</div>
</div>
</cfif>

<div class="control-group">
<div class="span4">
	<label class="control-label">Name (No spaces)</label>
	<div class="controls">
		<input class="span12" type="text" name="name" required="true" value="#HTMLEditFormat(attributes.attributeBean.getName())#" />
	</div>
</div>
<div class="span4">
	<label class="control-label">Label</label>
	<div class="controls">
		<input class="span12" type="text" name="label" value="#HTMLEditFormat(attributes.attributeBean.getLabel())#" />
	</div>
</div>
<div class="span4">
	<label class="control-label">Input Type</label>
	<div class="controls">
		<select name="type" class="span12">
		<cfloop list="#typelist#" index="t">
			<option value="#t#" <cfif attributes.attributeBean.getType() eq t>selected</cfif>>#t#</option>
		</cfloop>
		</select>
	</div>
</div>
</div>

<div class="control-group">
<div class="span4">
	<label class="control-label">Default Value</label>
	<div class="controls">
		<input class="span12" type="text" name="defaultValue"  value="#HTMLEditFormat(attributes.attributeBean.getDefaultvalue())#" />
	</div>
</div>
<div class="span4">
	<label class="control-label">Tooltip</label>
	<div class="controls">
		<input class="span12" type="text" name="hint" value="#HTMLEditFormat(attributes.attributeBean.getHint())#" />
	</div>
</div>
<div class="span4">
	<label class="control-label">Required</label>
	<div class="controls">
		<select name="required" class="span12">
			<option value="false" <cfif attributes.attributeBean.getRequired() eq "false">selected</cfif>>False</option>
			<option value="true" <cfif attributes.attributeBean.getRequired() eq "true">selected</cfif>>True</option>
		</select>
	</div>
</div>
</div>
</div>
<div class="fieldset">
<div class="control-group">
<div class="span4">
	<label class="control-label">Validate</label>
	<div class="controls">
		<select name="validation" class="span12">
			<option value="" <cfif attributes.attributeBean.getValidation() eq "">selected</cfif>>None</option>
			<option value="Date" <cfif attributes.attributeBean.getValidation() eq "Date">selected</cfif>>Date</option>
			<option value="Numeric" <cfif attributes.attributeBean.getValidation() eq "Numeric">selected</cfif>>Numeric</option>
			<option value="Email" <cfif attributes.attributeBean.getValidation() eq "Email">selected</cfif>>Email</option>
			<option value="Regex" <cfif attributes.attributeBean.getValidation() eq "Regex">selected</cfif>>Regex</option>
			<option value="Color" <cfif attributes.attributeBean.getValidation() eq "Color">selected</cfif>>Color</option>
		</select>
	</div>
</div>
<div class="span4">
	<label class="control-label">Regex</label>
	<div class="controls">
		<input class="span12" type="text" name="regex"  value="#HTMLEditFormat(attributes.attributeBean.getRegex())#" />
	</div>
</div>
<div class="span4">
	<label class="control-label">Validation Message</label>
	<div class="controls">
		<input class="span12" type="text" name="message"  value="#HTMLEditFormat(attributes.attributeBean.getMessage())#" />
	</div>
</div>
</div>

</div>
<div class="fieldset">
<div class="control-group">
<div class="span4">
	<label class="control-label">Option List ("^" Delimiter)</label>
	<div class="controls">
		<input class="span12" type="text" name="optionList"  value="#HTMLEditFormat(attributes.attributeBean.getOptionList())#" />
	</div>
</div>
<div class="span8">
	<label class="control-label">Option Label List (Optional, "^" Delimiter)</label>
	<div class="controls">
		<input class="span12" type="text" name="optionLabelList"  value="#HTMLEditFormat(attributes.attributeBean.getOptionLabelList())#" />
	</div>
</div>
</div>
</div>

<div class="form-actions">
<cfif attributes.action eq "add">
	<input type="button" class="btn" onclick="submitForm(document.forms.#HTMLEditFormat(attributes.formName)#,'add');" value="Add" />
	<input type="button" class="btn" onclick="$('###HTMLEditFormat(attributes.formName)#container').slideUp();$('###HTMLEditFormat(attributes.formName)#close').hide();$('###HTMLEditFormat(attributes.formName)#open').show();" value="Cancel" />
<cfelse>
	<input type="button" class="btn" onclick="submitForm(document.forms.#HTMLEditFormat(attributes.formName)#,'update');" value="Update" />
	<input type="button" class="btn" onclick="submitForm(document.forms.#HTMLEditFormat(attributes.formName)#,'delete','Delete Attribute?');" value="Delete" />
	<input type="button" class="btn" onclick="$('###HTMLEditFormat(attributes.formName)#container').slideUp();$('###HTMLEditFormat(attributes.formName)#close').hide();$('###HTMLEditFormat(attributes.formName)#open').show();$('li[attributeid=#attributes.attributeBean.getAttributeID()#]').removeClass('attr-edit');" value="Cancel" />
</cfif>
</div>
<input name="orderno" type="hidden" value="#attributes.attributeBean.getOrderno()#"/>
<input name="isActive" type="hidden" value="#attributes.attributeBean.getIsActive()#"/>
<input name="siteID" type="hidden" value="#attributes.attributeBean.getSiteID()#"/>
<input name="muraAction" type="hidden" value="cExtend.updateAttribute"/>
<input name="action" type="hidden" value="#HTMLEditFormat(attributes.action)#"/>
<input name="extendSetID" type="hidden" value="#HTMLEditFormat(attributes.attributeBean.getExtendSetID())#"/>
<input name="subTypeID" type="hidden" value="#HTMLEditFormat(attributes.subTypeID)#"/>
<input name="attributeID" type="hidden" value="#attributes.attributeBean.getAttributeID()#"/>
</form><cfif attributes.action eq "add"></div></cfif>
</cfoutput>