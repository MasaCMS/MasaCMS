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
<cfset event=request.event>
<cfif rc.action neq  'delete' and not structIsEmpty(rc.feedBean.getErrors())>
<cfinclude template="edit.cfm">
<cfelse>
<cfset request.layout=false>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Close</title>
<cfset contentRenderer=application.settingsManager.getSite(event.getValue("siteID")).getContentRenderer()>
<cfset homeBean = application.contentManager.getActiveContent(event.getValue('homeID'), event.getValue('siteID'))>
<cfset href = contentRenderer.createHREF(homeBean.getType(), homeBean.getFilename(), homeBean.getSiteId(), homeBean.getcontentId())>
<cfoutput>
<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery.js?coreversion=#application.coreversion#" type="text/javascript"></script>
<script src="#application.configBean.getContext()#/admin/assets/js/porthole/porthole.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>
<script>
	function reload(){
		if (top.location != self.location) {
			frontEndProxy = new Porthole.WindowProxy("#session.frontEndProxyLoc##application.configBean.getContext()#/admin/assets/js/porthole/proxy.html");
			if (jQuery("##ProxyIFrame").length) {
				jQuery("##ProxyIFrame").load(function(){
					frontEndProxy.post({cmd:'setLocation',location: encodeURIComponent("#JSStringFormat(href)#")});
				});
			}
			else {
				frontEndProxy.post({cmd:'setLocation',location: encodeURIComponent("#JSStringFormat(href)#")});
			}
		} else {
			location.href="#JSStringFormat(href)#";
		}
	}
	
</script>
</cfoutput>
</head>
<body onload="reload()">
</body>
</html>
</cfif>