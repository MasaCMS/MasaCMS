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
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<cfsilent>
<cfparam name="session.frontEndProxyLoc" default="">
<cfparam name="rc.parenthistid" default="">
<cfset event=request.event>
<cfset href = "">
<cfif rc.action eq "add">
	<cfif rc.contentBean.getActive()>
		<cfset currentBean = application.contentManager.getActiveContent(rc.contentBean.getContentID(), rc.contentBean.getSiteID())>
	<cfelse>
		<cfset currentBean=rc.contentBean>
	</cfif>
</cfif>
<cfif rc.contentBean.getType() eq 'Variation'>
	<cfset href = rc.contentBean.getRemoteURL()>
<cfelseif len(rc.homeID) gt 0>
	<cfset homeBean = application.contentManager.getActiveContent(event.getValue('homeID'), event.getValue('siteID'))>
	<cfset href = homeBean.getURL()>
<cfelseif rc.action eq "add" and rc.contentBean.getType() neq "File" and rc.contentBean.getType() neq "Link">
	<cfif rc.preview eq 1>
		<cfset href =currentBean.getURL(queryString='previewID=#rc.contentBean.getContentHistID()#')>
	<cfelseif currentBean.getActive() and currentBean.getIsOnDisplay()>
		<cfset href =currentBean.getURL()>
	<cfelse>
		<cfset href =currentBean.getURL(queryString="previewid=#currentBean.getContentHistID()#")>
	</cfif>
<cfelseif rc.action eq "add" and (rc.contentBean.getType() eq "File" or rc.contentBean.getType() eq "Link")>
	<cfset parentBean = application.contentManager.getActiveContent(currentBean.getParentID(), currentBean.getSiteID())>
	<cfif len(rc.parenthistid)
		and parentBean.getContentHistID() neq rc.parenthistid
		and rc.$.getBean('content').loadBy(contenthistid=rc.parenthistid).exists()>
		<cfset href = parentBean.getURL(queryString="previewid=#rc.parenthistid#")>
	<cfelseif parentBean.getActive() and parentBean.getIsOnDisplay()>
		<cfset href = parentBean.getURL()>
	<cfelse>
		<cfset href = parentBean.getURL(queryString="previewid=#parentBean.getContentHistID()#")>
	</cfif>
<cfelseif rc.action eq "multiFileUpload">
	<cfset parentBean = application.contentManager.getActiveContent(rc.parentID, rc.siteID)>
	<cfif len(rc.parenthistid)
		and parentBean.getContentHistID() neq rc.parenthistid
		and rc.$.getBean('content').loadBy(contenthistid=rc.parenthistid).exists()>
		<cfset href = parentBean.getURL(queryString="previewid=#rc.parenthistid#")>
	<cfelseif parentBean.getActive() and parentBean.getIsOnDisplay()>
		<cfset href = parentBean.getURL()>
	<cfelse>
		<cfset href = parentBean.getURL(queryString="previewid=#parentBean.getContentHistID()#")>
	</cfif>
<cfelse>
	<cfset rc.contentBean = application.contentManager.getActiveContent(rc.parentid, rc.siteid)>
	<cfif rc.contentBean.getActive() and rc.contentBean.getIsOnDisplay()>
		<cfset href = rc.contentBean.getURL()>
	<cfelse>
		<cfset href = rc.contentBean.getURL(queryString="previewid=#rc.contentBean.getContentHistID()#")>
	</cfif>
</cfif>
</cfsilent>
<cfoutput>
<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/jquery/jquery.js?coreversion=#application.coreversion#" type="text/javascript"></script>
<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/porthole/porthole.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>
<script>
	<cfparam name="session.mura.objectInstanceId" default="">
	<cfif rc.$.getContentRenderer().useLayoutmanager() and len(session.mura.objectInstanceId)>
		<cfif rc.contentBean.getType() eq 'Form'>
			var cmd={cmd:'setObjectParams',reinit:true,instanceid:'#session.mura.objectInstanceId#',params:{objectid:'#rc.contentBean.getContentId()#'}};
		<cfelseif rc.contentBean.getType() eq 'Component'>
			var cmd={cmd:'setObjectParams',reinit:true,instanceid:'#session.mura.objectInstanceId#',params:{objectid:'#rc.contentBean.getContentId()#'}};
		<cfelse>
			var cmd={cmd:'setLocation',location:encodeURIComponent("#esapiEncode('javascript',href)#")};
		</cfif>

	<cfelse>
		var cmd={cmd:'setLocation',location:encodeURIComponent("#esapiEncode('javascript',href)#")};
	</cfif>
	<cfset session.mura.objectInstanceId=''>
	function reload(){
		if (top.location != self.location) {
			frontEndProxy = new Porthole.WindowProxy("#esapiEncode('javascript',session.frontEndProxyLoc)##application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/porthole/proxy.html");
			if (jQuery("##ProxyIFrame").length) {
				jQuery("##ProxyIFrame").load(function(){
					frontEndProxy.post({cmd:'scrollToTop'});
					frontEndProxy.post(cmd);
				});
			}
			else {
				frontEndProxy.post({cmd:'scrollToTop'});
				frontEndProxy.post(cmd);
			}

		} else {
			location.href="#esapiEncode('javascript',href)#";
		}
	}
</script>
</cfoutput>
</head>
<body onload="reload()">
</body>
</html>
