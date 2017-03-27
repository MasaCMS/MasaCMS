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
<cfscript>
	if(server.coldfusion.productname != 'ColdFusion Server'){
		backportdir='';
		include "/mura/backport/backport.cfm";
	} else {
		backportdir='/mura/backport/';
		include "#backportdir#backport.cfm";
	}
</cfscript>
<cfset typeList="TextBox,TextArea,HTMLEditor,SelectBox,MultiSelectBox,RadioGroup,File,Hidden"/>
<cfoutput>


<ul class="nav nav-pills">

<cfif attributes.action eq "add">
<li>
<a href="javascript:;" id="#esapiEncode('html_attr',attributes.formName)#open" class="btn" onclick="$('###esapiEncode('html',attributes.formName)#container').slideDown();this.style.display='none';$('###esapiEncode('html',attributes.formName)#close').show();return false;"><i class="mi-plus-circle"></i> Add New Attribute</a></li>
<li><a href="javascript:;" class="btn" style="display:none;" id="#esapiEncode('html_attr',attributes.formName)#close" onclick="$('###esapiEncode('html',attributes.formName)#container').slideUp();this.style.display='none';$('###esapiEncode('html',attributes.formName)#open').show();return false;"><i class="mi-minus-circle"></i> Close</a></li>
<cfif isDefined('attributes.attributesArray') and ArrayLen(attributes.attributesArray)>
<li><a href="javascript:;" class="btn" style="display:none;" id="saveSort" onclick="extendManager.saveAttributeSort('attributesList');return false;"><i class="mi-check"></i> Save Order</a></li>
<li><a href="javascript:;" class="btn" id="showSort" onclick="extendManager.showSaveSort('attributesList');return false;"><i class="mi-arrows"></i> Reorder</a></li>
</cfif>
</cfif>
</ul>

<cfif attributes.action eq "add">
<div style="display:none;" id="#esapiEncode('html_attr',attributes.formName)#container" class="attr-add">
</cfif>
<form novalidate="novalidate" method="post" name="#esapiEncode('html_attr',attributes.formName)#" action="index.cfm" onsubmit="return validateForm(this);">
<cfif attributes.action neq "add">
<div class="mura-control-group">
	<label>Attribute ID: #attributes.attributeBean.getAttributeID()#</label>
</div>
</cfif>

<div class="mura-control-group">
	<label>Name (No spaces)</label>
		<input type="text" name="name" data-required="true" value="#esapiEncode('html_attr',attributes.attributeBean.getName())#" />
</div>
<div class="mura-control-group">
	<label>Label</label>
		<input type="text" name="label" value="#esapiEncode('html_attr',attributes.attributeBean.getLabel())#" />
</div>
<div class="mura-control-group">
	<label>Input Type</label>
		<select name="type">
		<cfloop list="#typelist#" index="t">
			<option value="#t#" <cfif attributes.attributeBean.getType() eq t>selected</cfif>>#t#</option>
		</cfloop>
		</select>
</div>

<div class="mura-control-group">
	<label>Default Value</label>
		<input type="text" name="defaultValue"  value="#esapiEncode('html_attr',attributes.attributeBean.getDefaultvalue())#" />
</div>
<div class="mura-control-group">
	<label>Tooltip</label>
		<input type="text" name="hint" value="#esapiEncode('html_attr',attributes.attributeBean.getHint())#" />
</div>
<div class="mura-control-group">
	<label>Required</label>
		<select name="required">
			<option value="false" <cfif attributes.attributeBean.getRequired() eq "false">selected</cfif>>False</option>
			<option value="true" <cfif attributes.attributeBean.getRequired() eq "true">selected</cfif>>True</option>
		</select>
</div>

<div class="mura-control-group">
	<label>Validate</label>
		<select name="validation">
			<option value="" <cfif attributes.attributeBean.getValidation() eq "">selected</cfif>>None</option>
			<option value="Date" <cfif attributes.attributeBean.getValidation() eq "Date">selected</cfif>>Date</option>
			<option value="DateTime" <cfif attributes.attributeBean.getValidation() eq "DateTime">selected</cfif>>DateTime</option>
			<option value="Numeric" <cfif attributes.attributeBean.getValidation() eq "Numeric">selected</cfif>>Numeric</option>
			<option value="Email" <cfif attributes.attributeBean.getValidation() eq "Email">selected</cfif>>Email</option>
			<option value="Regex" <cfif attributes.attributeBean.getValidation() eq "Regex">selected</cfif>>Regex</option>
			<option value="Color" <cfif attributes.attributeBean.getValidation() eq "Color">selected</cfif>>Color</option>
			<option value="URL" <cfif attributes.attributeBean.getValidation() eq "URL">selected</cfif>>URL</option>
		</select>
</div>

<div class="mura-control-group">
	<label>Regex</label>
		<input type="text" name="regex"  value="#esapiEncode('html_attr',attributes.attributeBean.getRegex())#" />
</div>

<div class="mura-control-group">
	<label>Validation Message</label>
		<input type="text" name="message"  value="#esapiEncode('html_attr',attributes.attributeBean.getMessage())#" />
</div>

<div class="mura-control-group">
	<label>Option List ("^" Delimiter)</label>
		<input type="text" name="optionList"  value="#esapiEncode('html_attr',attributes.attributeBean.getOptionList())#" />
</div>

<div class="mura-control-group">
	<label>Option Label List (Optional, "^" Delimiter)</label>
	<input type="text" name="optionLabelList"  value="#esapiEncode('html_attr',attributes.attributeBean.getOptionLabelList())#" />
</div>

<div class="mura-control-group">
	<label>For administrative Use Only?</label>
		<label class="radio inline"><input name="adminonly" type="radio" class="radio inline" value="1"<cfif attributes.attributeBean.getAdminOnly() eq 1 >Checked</cfif>>Yes</label>
		<label class="radio inline"><input name="adminonly" type="radio" class="radio inline" value="0"<cfif attributes.attributeBean.getAdminOnly() eq 0 >Checked</cfif>>No</label>
</div>

<div class="mura-actions">
	<div class="form-actions">
	<cfif attributes.action eq "add">
		<button class="btn mura-primary" type="button" onclick="submitForm(document.forms.#esapiEncode('html',attributes.formName)#,'add');"><i class="mi-check-circle"></i>Add</button>
		<button class="btn" type="button" onclick="$('###esapiEncode('html',attributes.formName)#container').slideUp();$('###esapiEncode('html',attributes.formName)#close').hide();$('###esapiEncode('html',attributes.formName)#open').show();"><i class="mi-times-circle"></i>Cancel</button>
	<cfelse>
		<button class="btn mura-primary" type="button" onclick="submitForm(document.forms.#esapiEncode('html',attributes.formName)#,'update');"><i class="mi-check-circle"></i>Update</button>
		<button class="btn" type="button" onclick="submitForm(document.forms.#esapiEncode('html',attributes.formName)#,'delete','Delete Attribute?');"><i class="mi-trash"></i>Delete</button>
		<button class="btn" type="button" onclick="$('###esapiEncode('html',attributes.formName)#container').slideUp();$('###esapiEncode('html',attributes.formName)#close').hide();$('###esapiEncode('html',attributes.formName)#open').show();$('li[attributeid=#attributes.attributeBean.getAttributeID()#]').removeClass('attr-edit');"><i class="mi-times-circle"></i>Cancel</button>
	</cfif>
	</div>
</div>

<input name="orderno" type="hidden" value="#attributes.attributeBean.getOrderno()#"/>
<input name="isActive" type="hidden" value="#attributes.attributeBean.getIsActive()#"/>
<input name="siteID" type="hidden" value="#attributes.attributeBean.getSiteID()#"/>
<input name="muraAction" type="hidden" value="cExtend.updateAttribute"/>
<input name="action" type="hidden" value="#esapiEncode('html_attr',attributes.action)#"/>
<input name="extendSetID" type="hidden" value="#esapiEncode('html_attr',attributes.attributeBean.getExtendSetID())#"/>
<input name="subTypeID" type="hidden" value="#esapiEncode('html_attr',attributes.subTypeID)#"/>
<input name="attributeID" type="hidden" value="#attributes.attributeBean.getAttributeID()#"/>
#attributes.muraScope.renderCSRFTokens(context=attributes.attributeBean.getAttributeID(),format="form")#
</form><cfif attributes.action eq "add"></div></cfif>
</cfoutput>
