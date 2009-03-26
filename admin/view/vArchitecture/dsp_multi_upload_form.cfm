<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->
<cfhtmlhead text="#session.dateKey#">
<cfset attributes.type="File">
<cfsilent>
<cfset request.perm=application.permUtility.getnodePerm(request.crumbdata)>

<cfset fileExt=''/>

</cfsilent>

<!--- check to see if the site has reached it's maximum amount of pages --->
<cfif (request.rsPageCount.counter lt application.settingsManager.getSite(attributes.siteid).getpagelimit() and  attributes.contentid eq '') or attributes.contentid neq ''>
<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.mullifileupload")#</h2>
<cfif attributes.compactDisplay neq "true">
#application.contentRenderer.dspZoom(request.crumbdata,fileExt)#
</cfif>
<form action="index.cfm?fuseaction=cArch.update" method="post" enctype="multipart/form-data" name="contentForm" onsubmit="return validateForm(this);" id="contentForm">
	
<dl>
<dt class="first">	
<cfif attributes.ptype eq 'Gallery' or attributes.type neq 'File'><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectimages')#<span>#application.rbFactory.getKeyValue(session.rb,'tooltip.selectimage')#</span></a><cfelse>
#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectfiles')#
</cfif>	
</dt>
<cfloop from="1" to="10" index=f>
<dd><input type="file" id="file#f#" name="NewFile#f#" class="text" <cfif attributes.ptype eq 'Gallery' or attributes.type neq 'File'>accept="image/jpeg" validate="regex" regex="(.+)(\.)(png|PNG|JPG|jpg|jpeg|JPEG)" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.newimagevalidate')#"</cfif>></dd>
</dd>
</cfloop>
</dl>
	<a class="submit" href="javascript:;" onclick="javascript:document.contentForm.approved.value=0;document.contentForm.submit();return false;"><span>#jsStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savedraft"))#</span></a>
	<cfif request.perm eq 'editor'>
	<a class="submit" href="javascript:;" onclick="document.contentForm.approved.value=1;document.contentForm.submit();return false;"><span>#jsStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.publish"))#</span></a>
	</cfif>
	
		<input name="action" type="hidden" value="multiFileUpload">
		<input type="hidden" name="siteid" value="#attributes.siteid#">
		<input type="hidden" name="moduleid" value="#attributes.moduleid#">
		<input type="hidden" name="return" value="#attributes.return#">
		<input type="hidden" name="topid" value="#attributes.topid#">
		<input type="hidden" name="ptype" value="#attributes.ptype#">
		<input type="hidden" name="parentid" value="#attributes.parentid#">
		<input type="hidden" name="contentid"  value="" />
		<input type="hidden" name="type"  value="File" />
		<input type="hidden" name="subtype" value="Default">
		<input type="hidden" name="startrow" value="#attributes.startrow#">
		<input name="OrderNo" type="hidden" value="0">
		<input type="hidden" name="approved"  value="0" />
		<cfif attributes.compactDisplay eq "true">
		<input type="hidden" name="closeCompactDisplay" value="true" />
		</cfif>
</div>

</cfoutput>
</form>
<cfelse>
<div>
<cfinclude template="form/dsp_full.cfm">
</div>
</cfif>