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
provided that these modules (a) may only modify the /plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/admin/
/tasks/
/config/
/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Close</title>
</head>
<body onload="">
<cfoutput>
<cfset contentRenderer=application.settingsManager.getSite(event.getValue("siteID")).getContentRenderer()>
<cfset href = "">
<cfif attributes.action eq "add">
	<cfif request.contentBean.getActive()>
		<cfset currentBean = application.contentManager.getActiveContent(request.contentBean.getContentID(), request.contentBean.getSiteID())>
	<cfelse>
		<cfset currentBean=request.contentBean>
	</cfif>
</cfif>
	
<cfif len(attributes.homeID) gt 0>
	<cfset homeBean = application.contentManager.getActiveContent(event.getValue('homeID'), event.getValue('siteID'))>
	<cfset href = contentRenderer.createHREF(homeBean.getType(), homeBean.getFilename(), homeBean.getSiteId(), homeBean.getcontentId())>
	<cfoutput>
		<script>
			var editForm = window.parent.document.getElementById('editForm');
			window.parent.location = '#href#';
			editForm.hide();
		</script>
	</cfoutput>
<cfelseif attributes.action eq "add" and request.contentBean.getType() neq "File" and request.contentBean.getType() neq "Link">
	<cfset href = contentRenderer.createHREF(currentBean.getType(), currentBean.getFilename(), currentBean.getSiteId(), currentBean.getcontentId())>
	<script>
		var editForm = window.parent.document.getElementById('editForm');
		<cfif attributes.preview eq 1>
		window.parent.location = '#href#?contentID=#request.contentBean.getContentID()#&previewID=#request.contentBean.getContentHistID()#';
		<cfelse>
		window.parent.location = '#href#';
		</cfif>
		editForm.hide();
	</script>
<cfelseif attributes.action eq "add" and (request.contentBean.getType() eq "File" or request.contentBean.getType() eq "Link")>	
	<cfset parentBean = application.contentManager.getActiveContent(currentBean.getParentID(), currentBean.getSiteID())>
	<cfset href = contentRenderer.createHREF(parentBean.getType(), parentBean.getFilename(), parentBean.getSiteId(), parentBean.getcontentId())>
	<script>
		var editForm = window.parent.document.getElementById('editForm');
		<cfif attributes.preview eq 1>
		window.parent.location = '#href#?contentID=#request.contentBean.getContentID()#&previewID=#request.contentBean.getContentHistID()#';
		<cfelse>
		window.parent.location = '#href#';
		</cfif>
		editForm.hide();
	</script>
<cfelseif attributes.action eq "multiFileUpload">
	<cfset parentBean = application.contentManager.getActiveContent(attributes.parentID, attributes.siteID)>
	<cfset href = contentRenderer.createHREF(parentBean.getType(), parentBean.getFilename(), parentBean.getSiteId(), parentBean.getcontentId())>
	<script>
		var editForm = window.parent.document.getElementById('editForm');
	
		window.parent.location = '#href#';
	
		editForm.hide();
	</script>
<cfelse>
	<cfset request.contentBean = application.contentManager.getActiveContent(attributes.parentid, attributes.siteid)>
	<cfset href = contentRenderer.createHREF(request.contentBean.getType(), request.contentBean.getFilename(), request.contentBean.getSiteId(), request.contentBean.getcontentId())>
	<script>
		window.location = '#href#';
	</script>
</cfif>
</cfoutput>
</body>
</html>
  