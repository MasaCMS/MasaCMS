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

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Close</title>
</head>
<body onload="">
<cfoutput>
<cfset href = "">
<cfif attributes.action eq "add" and request.contentBean.getType() neq "File" and request.contentBean.getType() neq "Link">
	<cfset href = application.contentRenderer.createHREF(request.contentBean.getType(), request.contentBean.getFilename(), request.contentBean.getSiteId(), request.contentBean.getcontentId())>
	<script>
		var editForm = window.parent.document.getElementById('editForm');
		window.parent.location = '#href#';
		editForm.hide();
	</script>
<cfelseif attributes.action eq "add" and (request.contentBean.getType() eq "File" or request.contentBean.getType() eq "Link")>
	<cfset request.contentBean = application.contentManager.getActiveContent(attributes.parentid, attributes.siteid)>
	<cfset href = application.contentRenderer.createHREF(request.contentBean.getType(), request.contentBean.getFilename(), request.contentBean.getSiteId(), request.contentBean.getcontentId())>
	<script>
		var editForm = window.parent.document.getElementById('editForm');
		window.parent.location = '#href#';
		editForm.hide();
	</script>
<cfelseif attributes.action eq "multiFileUpload">
	<cfset request.contentBean = application.contentManager.getActiveContent(attributes.parentid, attributes.siteid)>
	<cfset href = application.contentRenderer.createHREF(request.contentBean.getType(), request.contentBean.getFilename(), request.contentBean.getSiteId(), request.contentBean.getcontentId())>
	<script>
		var editForm = window.parent.document.getElementById('editForm');
		window.parent.location = '#href#';
		editForm.hide();
	</script>
<cfelse>
	<cfset request.contentBean = application.contentManager.getActiveContent(attributes.parentid, attributes.siteid)>
	<cfset href = application.contentRenderer.createHREF(request.contentBean.getType(), request.contentBean.getFilename(), request.contentBean.getSiteId(), request.contentBean.getcontentId())>
	<script>
		window.location = '#href#';
	</script>
</cfif>
</cfoutput>
</body>
</html>
  