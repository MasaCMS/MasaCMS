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

<cfset typeList="TextBox,TextArea,SelectBox,MultiSelectBox,RadioGroup,File"/>
<cfoutput>
<cfif attributes.action eq "add">
<a href="javascript:;" id="#attributes.formName#open" onclick="new Effect.SlideDown($('#attributes.formName#container'));this.style.display='none';$('#attributes.formName#close').style.display='';return false;">[Add New Attribute]</a>
<a href="javascript:;" style="display:none;" id="#attributes.formName#close" onclick="new Effect.SlideUp($('#attributes.formName#container'));this.style.display='none';$('#attributes.formName#open').style.display='';return false;">[Close]</a>
<br/>
</cfif>
<cfif attributes.action eq "add">
<div style="display:none;" id="#attributes.formName#container">
</cfif>
<form method="post" name="#attributes.formName#" action="index.cfm" onsubmit="return validateForm(this);">
<dl class="oneColumn">
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

<cfif attributes.action eq "add">
<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.#attributes.formName#,'add');"><span>Add</span></a>
<a class="submit" href="javascript:;" onclick="new Effect.SlideUp($('#attributes.formName#container'));$('#attributes.formName#close').style.display='none';$('#attributes.formName#open').style.display='';return false;"><span>Cancel</span></a>
<cfelse>
<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.#attributes.formName#,'update');"><span>Update</span></a>
<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.#attributes.formName#,'delete','This');"><span>Delete</span></a>
<a class="submit" href="javascript:;" onclick="new Effect.SlideUp($('#attributes.formName#container'));$('#attributes.formName#close').style.display='none';$('#attributes.formName#open').style.display='';return false;"><span>Cancel</span></a>
</cfif>

<input name="orderno" type="hidden" value="#attributes.attributeBean.getOrderno()#"/>
<input name="isActive" type="hidden" value="#attributes.attributeBean.getIsActive()#"/>
<input name="siteID" type="hidden" value="#attributes.attributeBean.getSiteID()#"/>
<input name="fuseaction" type="hidden" value="cExtend.updateAttribute"/>
<input name="action" type="hidden" value="#attributes.action#"/>
<input name="extendSetID" type="hidden" value="#attributes.attributeBean.getExtendSetID()#"/>
<input name="subTypeID" type="hidden" value="#attributes.subTypeID#"/>
<input name="attributeID" type="hidden" value="#attributes.attributeBean.getAttributeID()#"/>
</form><cfif attributes.action eq "add"></div></cfif>
</cfoutput>