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
<cfif attributes.action eq "add">
<p><a href="javascript:;" id="#HTMLEditFormat(attributes.formName)#open" onclick="jQuery('###HTMLEditFormat(attributes.formName)#container').slideDown();this.style.display='none';jQuery('###HTMLEditFormat(attributes.formName)#close').show();return false;">[Add New Attribute]</a></p>
<p><a href="javascript:;" style="display:none;" id="#HTMLEditFormat(attributes.formName)#close" onclick="jQuery('###HTMLEditFormat(attributes.formName)#container').slideUp();this.style.display='none';jQuery('###HTMLEditFormat(attributes.formName)#open').show();return false;">[Close]</a></p>
</cfif>
<cfif attributes.action eq "add">
<div style="display:none;" id="#HTMLEditFormat(attributes.formName)#container">
</cfif>
<form novalidate="novalidate" method="post" name="#HTMLEDitFormat(attributes.formName)#" action="index.cfm" onsubmit="return validateForm(this);">
<dl class="oneColumn separate">
<cfif attributes.action neq "add">
<dt>Attribute ID</dt>
<dd>#attributes.attributeBean.getAttributeID()#</dd>
</cfif>
<dt <cfif attributes.action eq "add">class="first"</cfif>>Name</dt>
<dd><input type="text" name="name" required="true" value="#HTMLEditFormat(attributes.attributeBean.getName())#" /></dd>
<dt>Label</dt>
<dd><input type="text" name="label" value="#HTMLEditFormat(attributes.attributeBean.getLabel())#" /></dd>

<dt>Hint</dt>
<dd><input type="text" name="hint"  value="#HTMLEditFormat(attributes.attributeBean.getHint())#" /></dd>
<dt>Input Type</dt>
<dd><select name="type">
	<cfloop list="#typelist#" index="t"><option value="#t#" <cfif attributes.attributeBean.getType() eq t>selected</cfif>>#t#</option></cfloop>
	</select>
</dd>
<dt>Default Value</dt>
<dd><input type="text" name="defaultValue"  value="#HTMLEditFormat(attributes.attributeBean.getDefaultvalue())#" /></dd>
<dt>Required</dt>
<dd><select name="required">
	<option value="false" <cfif attributes.attributeBean.getRequired() eq "false">selected</cfif>>False</option>
	<option value="true" <cfif attributes.attributeBean.getRequired() eq "true">selected</cfif>>True</option>
	</select>
</dd>
<dt>Validate</dt>
<dd><select name="validation">
	<option value="" <cfif attributes.attributeBean.getValidation() eq "">selected</cfif>>None</option>
	<option value="Date" <cfif attributes.attributeBean.getValidation() eq "Date">selected</cfif>>Date</option>
	<option value="Numeric" <cfif attributes.attributeBean.getValidation() eq "Numeric">selected</cfif>>Numeric</option>
	<option value="Email" <cfif attributes.attributeBean.getValidation() eq "Email">selected</cfif>>Email</option>
	<option value="Regex" <cfif attributes.attributeBean.getValidation() eq "Regex">selected</cfif>>Regex</option>
	</select>
</dd>
<dt>Regex</dt>
<dd><input type="text" name="regex"  value="#HTMLEditFormat(attributes.attributeBean.getRegex())#" /></dd>
<dt>Validation Message</dt>
<dd><input type="text" name="message"  value="#HTMLEditFormat(attributes.attributeBean.getMessage())#" /></dd>
<dt>Option List ("^" Delimiter)</dt>
<dd><input type="text" name="optionList"  value="#HTMLEditFormat(attributes.attributeBean.getOptionList())#" /></dd>
<dt>Option Label List (Optional, "^" Delimiter)</dt>
<dd><input type="text" name="optionLabelList"  value="#HTMLEditFormat(attributes.attributeBean.getOptionLabelList())#" /></dd>
</dl>

<div id="actionButtons">
<cfif attributes.action eq "add">
<input type="button" class="submit" onclick="submitForm(document.forms.#HTMLEditFormat(attributes.formName)#,'add');" value="Add" />
<input type="button" class="submit" onclick="jQuery('###HTMLEditFormat(attributes.formName)#container').slideUp();jQuery('###HTMLEditFormat(attributes.formName)#close').hide();jQuery('###HTMLEditFormat(attributes.formName)#open').show();" value="Cancel" />
<cfelse>
<input type="button" class="submit" onclick="submitForm(document.forms.#HTMLEditFormat(attributes.formName)#,'update');" value="Update" />
<input type="button" class="submit" onclick="submitForm(document.forms.#HTMLEditFormat(attributes.formName)#,'delete','Delete Attribute?');" value="Delete" />
<input type="button" class="submit" onclick="jQuery('###HTMLEditFormat(attributes.formName)#container'));jQuery('###HTMLEditFormat(attributes.formName)#close').hide();jQuery('###HTMLEditFormat(attributes.formName)#open').show();" value="Cancel" />
</cfif>
</div>
<input name="orderno" type="hidden" value="#attributes.attributeBean.getOrderno()#"/>
<input name="isActive" type="hidden" value="#attributes.attributeBean.getIsActive()#"/>
<input name="siteID" type="hidden" value="#attributes.attributeBean.getSiteID()#"/>
<input name="fuseaction" type="hidden" value="cExtend.updateAttribute"/>
<input name="action" type="hidden" value="#HTMLEditFormat(attributes.action)#"/>
<input name="extendSetID" type="hidden" value="#HTMLEditFormat(attributes.attributeBean.getExtendSetID())#"/>
<input name="subTypeID" type="hidden" value="#HTMLEditFormat(attributes.subTypeID)#"/>
<input name="attributeID" type="hidden" value="#attributes.attributeBean.getAttributeID()#"/>
</form><cfif attributes.action eq "add"></div></cfif>
</cfoutput>