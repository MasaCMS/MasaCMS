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

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,'advertising.creativeassetdetails')#</h2>
<ul id="navTask">
<li><a href="index.cfm?fuseaction=cAdvertising.viewAdvertiser&&siteid=#URLEncodedFormat(attributes.siteid)#&userid=#URLEncodedFormat(attributes.userid)#">#application.rbFactory.getKeyValue(session.rb,'advertising.backtoadvertiser')#</a></li>
</ul>

<h3>#application.rbFactory.getKeyValue(session.rb,'advertising.creativeassetinformation')#</h3>
#application.utility.displayErrors(request.creativeBean.getErrors())#
<form novalidate="novalidate" action="index.cfm?fuseaction=cAdvertising.updateCreative&siteid=#URLEncodedFormat(attributes.siteid)#&userid=#URLEncodedFormat(attributes.userid)#" enctype="multipart/form-data" method="post" name="form1" onsubmit="return validate(this);">
<dl class="oneColumn">
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'advertising.name')#</dt>
<dd><input name="name" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'advertising.namerequired')#" value="#HTMLEditFormat(request.creativeBean.getName())#" maxlength="50"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.assettype')#</dt>
<dd><select name="creativeType">
<cfloop list="#application.advertiserManager.getCreativeTypes()#" index="ct">
<option value="#ct#" <cfif request.creativeBean.getCreativeType() eq ct>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'advertising.creativetype.#ct#')#</option>
</cfloop>
</select></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.mediatype')#</dt>
<dd><select name="mediaType" onchange="jQuery('##textBodyContainer').css('display',(this.value=='Text')?'':'none');jQuery('##newMediaContainer').css('display',(this.value=='Text')?'none':'');">
<cfloop list="#application.advertiserManager.getMediaTypes()#" index="m">
<option value="#m#" <cfif request.creativeBean.getMediaType() eq m>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'advertising.mediatype.#m#')#</option>
</cfloop>
</select></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,"advertising.target")#</dt>
<dd><select name="target">
<option value="_blank">#application.rbFactory.getKeyValue(session.rb,"advertising.yes")#</option>
<option value="_self"<cfif request.creativeBean.getTarget() eq "_self"> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"advertising.no")#</option>
</select></dd>
<span id="textBodyContainer" <cfif request.creativeBean.getMediaType() neq 'Text'>style="display:none;"</cfif>>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.textbody')#</dt>
<dd><textarea name="textBody" id="textBody" class="textArea htmlEditor">#HTMLEditFormat(request.creativeBean.getTextBody())#</textarea></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.title')#</dt>
<dd><input name="title" class="text"  value="#HTMLEditFormat(request.creativeBean.getTitle())#" maxlength="200"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.linktitle')#</dt>
<dd><input name="linkTitle" class="text"  value="#HTMLEditFormat(request.creativeBean.getLinkTitle())#" maxlength="100"></dd>
</span>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.height')#</dt>
<dd><input name="height" validate="numeric" class="text" message="#application.rbFactory.getKeyValue(session.rb,'advertising.heightvalidate')#" value="#request.creativeBean.getHeight()#"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.width')#</dt>
<dd><input name="width" validate="numeric" class="text" message="#application.rbFactory.getKeyValue(session.rb,'advertising.widthvalidate')#" value="#request.creativeBean.getWidth()#"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.advertisementurl')#</dt>
<dd><input name="redirectURL" class="text" value="#HTMLEditFormat(request.creativeBean.getRedirectURL())#" maxlength="200"></dd>
<span id="newMediaContainer" <cfif request.creativeBean.getMediaType() eq 'Text'>style="display:none;"</cfif>>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.alttext')#</dt>
<dd><input name="altText" class="text"  value="#HTMLEditFormat(request.creativeBean.getAltText())#" maxlength="200"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.uploadmedia')#</dt>
<dd><input type="file" name="newFile"></dd>
</span>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.isactive')#</dt>
<dd>
<input name="isActive" type="radio" value="1" <cfif request.creativeBean.getIsActive()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'advertising.yes')# 
<input name="isActive" type="radio" value="0" <cfif not request.creativeBean.getIsActive()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'advertising.no')# 
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.notes')#</dt>
<dd><textarea name="notes" class="textArea">#HTMLEditFormat(request.creativeBean.getNotes())#</textarea></dd>
</dl>
<cfif attributes.creativeid eq ''>
<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'add');"><span>#application.rbFactory.getKeyValue(session.rb,'advertising.add')#</span></a><input type=hidden name="creativeID" value=""><cfelse> <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'delete','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'advertising.deletecreativeconfirm'))#');"><span>#application.rbFactory.getKeyValue(session.rb,'advertising.delete')#</span></a> <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'update');"><span>#application.rbFactory.getKeyValue(session.rb,'advertising.update')#</span></a>
<input type=hidden name="creativeid" value="#request.creativeBean.getCreativeID()#"></cfif><input type="hidden" name="action" value=""></form>

<cfif attributes.creativeid neq ''>
<h3 class="divide">#application.rbFactory.getKeyValue(session.rb,'advertising.currentasset')#</h3>
<cfoutput>#application.advertiserManager.renderCreative(request.creativeBean)#</cfoutput>
</cfif></cfoutput>
<script type="text/javascript" language="Javascript">
	var loadEditorCount = 0;
	jQuery('#textBody').ckeditor(
	{ toolbar:'Default',
	height:'150',
	customConfig : 'config.js.cfm' },htmlEditorOnComplete);	 
</script>