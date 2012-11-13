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

<cfoutput>
<h1>#application.rbFactory.getKeyValue(session.rb,'advertising.creativeassetdetails')#</h1>

<cfinclude template="dsp_secondary_menu.cfm">

<h2>#application.rbFactory.getKeyValue(session.rb,'advertising.creativeassetinformation')#</h2>
#application.utility.displayErrors(rc.creativeBean.getErrors())#
<form class="fieldset-wrap" novalidate="novalidate" action="index.cfm?muraAction=cAdvertising.updateCreative&siteid=#URLEncodedFormat(rc.siteid)#&userid=#URLEncodedFormat(rc.userid)#" enctype="multipart/form-data" method="post" name="form1" onsubmit="return validate(this);">
<div class="fieldset">
<div class="control-group">
	<label class="control-label">
		#application.rbFactory.getKeyValue(session.rb,'advertising.name')#
	</label>
	<div class="controls">
		<input name="name" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'advertising.namerequired')#" value="#HTMLEditFormat(rc.creativeBean.getName())#" maxlength="50">
	</div>
</div>

<div class="control-group">
	<label class="control-label">
		#application.rbFactory.getKeyValue(session.rb,'advertising.assettype')#
	</label>
	<div class="controls"><select name="creativeType">
		<cfloop list="#application.advertiserManager.getCreativeTypes()#" index="ct">
		<option value="#ct#" <cfif rc.creativeBean.getCreativeType() eq ct>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'advertising.creativetype.#replace(ct,' ', '','all')#')#</option>
		</cfloop>
		</select>
	</div>
</div>

<div class="control-group">
	<label class="control-label">
		#application.rbFactory.getKeyValue(session.rb,'advertising.mediatype')#
	</label>
	<div class="controls"><select name="mediaType" onchange="jQuery('##textBodyContainer').css('display',(this.value=='Text')?'':'none');jQuery('##newMediaContainer').css('display',(this.value=='Text')?'none':'');">
		<cfloop list="#application.advertiserManager.getMediaTypes()#" index="m">
		<option value="#m#" <cfif rc.creativeBean.getMediaType() eq m>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'advertising.mediatype.#m#')#</option>
		</cfloop>
		</select>
	</div>
</div>

<div class="control-group">
	<label class="control-label">
		#application.rbFactory.getKeyValue(session.rb,"advertising.target")#
	</label>
	<div class="controls"><select name="target">
		<option value="_blank">#application.rbFactory.getKeyValue(session.rb,"advertising.yes")#</option>
		<option value="_self"<cfif rc.creativeBean.getTarget() eq "_self"> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"advertising.no")#</option>
		</select>
	</div>
</div>

<span id="textBodyContainer" <cfif rc.creativeBean.getMediaType() neq 'Text'>style="display:none;"</cfif>>

<div class="control-group">
	<label class="control-label">
		#application.rbFactory.getKeyValue(session.rb,'advertising.textbody')#
	</label>
	<div class="controls"><textarea name="textBody" id="textBody" class="textArea htmlEditor">#HTMLEditFormat(rc.creativeBean.getTextBody())#</textarea>
	</div>
</div>

<div class="control-group">
	<label class="control-label">
		#application.rbFactory.getKeyValue(session.rb,'advertising.title')#
	</label>
	<div class="controls"><input name="title" class="text"  value="#HTMLEditFormat(rc.creativeBean.getTitle())#" maxlength="200">
	</div>
</div>

<div class="control-group">
	<label class="control-label">
		#application.rbFactory.getKeyValue(session.rb,'advertising.linktitle')#
	</label>
	<div class="controls"><input name="linkTitle" class="text"  value="#HTMLEditFormat(rc.creativeBean.getLinkTitle())#" maxlength="100">
	</div>
</div>
</span>

<div class="control-group">
	<label class="control-label">
		#application.rbFactory.getKeyValue(session.rb,'advertising.height')#
	</label>
	<div class="controls">
		<input name="height" validate="numeric" class="text" message="#application.rbFactory.getKeyValue(session.rb,'advertising.heightvalidate')#" value="#rc.creativeBean.getHeight()#">
	</div>
</div>

<div class="control-group">
	<label class="control-label">
		#application.rbFactory.getKeyValue(session.rb,'advertising.width')#
	</label>
	<div class="controls">
	<input name="width" validate="numeric" class="text" message="#application.rbFactory.getKeyValue(session.rb,'advertising.widthvalidate')#" value="#rc.creativeBean.getWidth()#">
	</div>
</div>

<div class="control-group">
	<label class="control-label">
		#application.rbFactory.getKeyValue(session.rb,'advertising.advertisementurl')#
	</label>
	<div class="controls">
		<input name="redirectURL" class="text" value="#HTMLEditFormat(rc.creativeBean.getRedirectURL())#" maxlength="200">
	</div>
</div>

<span id="newMediaContainer" <cfif rc.creativeBean.getMediaType() eq 'Text'>style="display:none;"</cfif>>

<div class="control-group">
	<label class="control-label">
		#application.rbFactory.getKeyValue(session.rb,'advertising.alttext')#
	</label>
	<div class="controls"><input name="altText" class="text"  value="#HTMLEditFormat(rc.creativeBean.getAltText())#" maxlength="200">
	</div>
</div>

<div class="control-group">
	<label class="control-label">
		#application.rbFactory.getKeyValue(session.rb,'advertising.uploadmedia')#
	</label>
	<div class="controls"><input type="file" name="newFile">
	</div>
</div>
</span>

<div class="control-group">
	<label class="control-label">
		#application.rbFactory.getKeyValue(session.rb,'advertising.isactive')#</label>
	<div class="controls">
		<input name="isActive" type="radio" value="1" <cfif rc.creativeBean.getIsActive()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'advertising.yes')# 
		<input name="isActive" type="radio" value="0" <cfif not rc.creativeBean.getIsActive()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'advertising.no')# 
	</div>
</div>

<div class="control-group">
	<label class="control-label">
		#application.rbFactory.getKeyValue(session.rb,'advertising.notes')#
	</label>
	<div class="controls"><textarea name="notes" class="textArea">#HTMLEditFormat(rc.creativeBean.getNotes())#</textarea>
	</div>
</div>
</div>
<div class="form-actions">
<cfif rc.creativeid eq ''>
	<input type="button" class="btn" onclick="submitForm(document.forms.form1,'add');" value="#application.rbFactory.getKeyValue(session.rb,'advertising.add')#" />
	<input type=hidden name="creativeID" value="">
<cfelse> 
	<input type="button" class="submit btn btn-delete" onclick="submitForm(document.forms.form1,'delete','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'advertising.deletecreativeconfirm'))#');" value="#application.rbFactory.getKeyValue(session.rb,'advertising.delete')#" />
	<input type="button" class="btn" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'advertising.update')#" />
	<input type=hidden name="creativeid" value="#rc.creativeBean.getCreativeID()#">
</cfif><input type="hidden" name="action" value="">
</div>
</form>

<cfif rc.creativeid neq ''>
<h3 class="divide">#application.rbFactory.getKeyValue(session.rb,'advertising.currentasset')#</h3>
<cfoutput>#application.advertiserManager.renderCreative(rc.creativeBean)#</cfoutput>
</cfif></cfoutput>
<script type="text/javascript">
	var loadEditorCount = 0;
	jQuery('#textBody').ckeditor(
	{ toolbar:'Default',
	height:'150',
	customConfig : 'config.js.cfm' },htmlEditorOnComplete);	 
</script>