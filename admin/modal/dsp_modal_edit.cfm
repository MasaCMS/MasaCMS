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
<!---------------------------------------------->
<!--- LET'S FIGURE OUT IF THE BROWSER IS IE6 --->
<!---------------------------------------------->
<cfset variables.isIeSix=FindNoCase('MSIE 6','#CGI.HTTP_USER_AGENT#') GREATER THAN 0>
	
<cfif FindNoCase('Opera','#CGI.HTTP_USER_AGENT#') LESS THAN 1>
<cfparam name="Cookie.fetDisplay" default="">
<cfoutput>
<link href="#application.configBean.getContext()#/admin/css/dialog.min.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="#application.configBean.getContext()#/admin/js/porthole/porthole.min.js?coreversion=#application.coreversion#"></script>
<script type="text/javascript" src="#application.configBean.getContext()#/admin/js/dialog.js.cfm?siteid=#URLEncodedFormat($.event('siteid'))#&coreversion=#application.coreversion#"></script>
<!---[if LT IE9]>

   <style type="text/css">

   ##frontEndToolsModalContainer {
         background: transparent;
          filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=##00000085,endColorstr=##00000085);
          zoom: 1;
       } 

    </style>

<![endif]--->

<cfsilent>
	<cfif len(application.configBean.getAdminDomain())>
		<cfif application.configBean.getAdminSSL()>
			<cfset adminBase="https://#application.configBean.getAdminDomain()##application.configBean.getServerPort()#"/>
		<cfelse>
			<cfset adminBase="http://#application.configBean.getAdminDomain()##application.configBean.getServerPort()#"/>
		</cfif>
	<cfelse>
		<cfset adminBase=""/>
	</cfif>
	
	<cfset targetHook=generateEditableHook()>
	
	<cfset editLink = adminBase & "#application.configBean.getContext()#/admin/index.cfm?fuseaction=cArch.edit">
	<cfif structKeyExists(request,"previewID") and len(request.previewID)>
		<cfset editLink = editLink & "&amp;contenthistid=" & request.previewID>
	<cfelse>
		<cfset editLink = editLink & "&amp;contenthistid=" & request.contentBean.getContentHistID()>
	</cfif>
	<cfset editLink = editLink & "&amp;siteid=" & request.contentBean.getSiteID()>
	<cfset editLink = editLink & "&amp;contentid=" & request.contentBean.getContentID()>
	<cfset editLink = editLink & "&amp;topid=00000000000000000000000000000000001">
	<cfset editLink = editLink & "&amp;type=" & request.contentBean.getType()>
	<cfset editLink = editLink & "&amp;parentid=" & request.contentBean.getParentID()>
	<cfset editLink = editLink & "&amp;moduleid=" & request.contentBean.getModuleID()>
	<cfset editLink = editLink & "&amp;compactDisplay=true">
	
	<cfset newLink = adminBase & "#application.configBean.getContext()#/admin/index.cfm?fuseaction=cArch.edit">
	<cfset newLink = newLink & "&amp;contentid=">
	<cfset newLink = newLink & "&amp;parentid=" & request.contentBean.getContentID()>
	<cfset newLink = newLink & "&amp;topid=00000000000000000000000000000000001">
	<cfset newLink = newLink & "&amp;siteid=" & request.contentBean.getSiteID()>
	<cfset newLink = newLink & "&amp;moduleid=" & "00000000000000000000000000000000000">
	<cfset newLink = newLink & "&amp;ptype=" & request.contentBean.getType()>
	<cfset newLink = newLink & "&amp;compactDisplay=true">
	
	<cfset newMultiLink = adminBase & "#application.configBean.getContext()#/admin/index.cfm?fuseaction=cArch.multiFileUpload">
	<cfset newMultiLink = newMultiLink & "&amp;contentid=">
	<cfset newMultiLink = newMultiLink & "&amp;parentid=" & request.contentBean.getContentID()>
	<cfset newMultiLink = newMultiLink & "&amp;topid=00000000000000000000000000000000001">
	<cfset newMultiLink = newMultiLink & "&amp;siteid=" & request.contentBean.getSiteID()>
	<cfset newMultiLink = newMultiLink & "&amp;moduleid=" & "00000000000000000000000000000000000">
	<cfset newMultiLink = newMultiLink & "&amp;ptype=" & request.contentBean.getType()>
	<cfset newMultiLink = newMultiLink & "&amp;compactDisplay=true">
	
	<cfset historyLink = adminBase & "#application.configBean.getContext()#/admin/index.cfm?fuseaction=cArch.hist">
	<cfset historyLink = historyLink & "&amp;siteid=" & request.contentBean.getSiteID()>
	<cfset historyLink = historyLink & "&amp;contentid=" & request.contentBean.getContentID()>
	<cfset historyLink = historyLink & "&amp;topid=00000000000000000000000000000000001">
	<cfset historyLink = historyLink & "&amp;type=" & request.contentBean.getType()>
	<cfset historyLink = historyLink & "&amp;parentid=" & request.contentBean.getParentID()>
	<cfset historyLink = historyLink & "&amp;moduleid=" & request.contentBean.getModuleID()>
	<cfset historyLink = historyLink & "&amp;startrow=1">
	<cfset historyLink = historyLink & "&amp;compactDisplay=true">
	
	<cfset adminLink = adminBase & "#application.configBean.getContext()#/admin/index.cfm?fuseaction=cArch.list">
	<cfset adminLink = adminLink & "&amp;siteid=" & request.contentBean.getSiteID()>
	<cfset adminLink = adminLink & "&amp;topid=" & request.contentBean.getContentID()>
	<cfset adminLink = adminLink & "&amp;ptype=" & request.contentBean.getType()>
	<cfset adminLink = adminLink & "&amp;parentid=" & request.contentBean.getParentID()>
	<cfset adminLink = adminLink & "&amp;moduleid=" & request.contentBean.getModuleID()>
	<cfset adminLink = adminLink & "&amp;activeTab=0">
	
	<cfset deleteLink = adminBase & "#application.configBean.getContext()#/admin/index.cfm?fuseaction=cArch.update">
	<cfset deleteLink = deleteLink & "&amp;siteid=" & request.contentBean.getSiteID()>
	<cfset deleteLink = deleteLink & "&amp;contentid=" & request.contentBean.getContentID()>
	<cfset deleteLink = deleteLink & "&amp;topid=00000000000000000000000000000000001">
	<cfset deleteLink = deleteLink & "&amp;type=" & request.contentBean.getType()>
	<cfset deleteLink = deleteLink & "&amp;parentid=" & request.contentBean.getParentID()>
	<cfset deleteLink = deleteLink & "&amp;moduleid=" & request.contentBean.getModuleID()>
	<cfset deleteLink = deleteLink & "&amp;compactDisplay=true">
	<cfset deleteLink = deleteLink & "&amp;closeCompactDisplay=true">
	<cfset deleteLink = deleteLink & "&amp;action=deleteall">
	<cfset deleteLink = deleteLink & "&amp;startrow=1">
</cfsilent>

<cfif variables.isIeSix>
<!--------------------------------------------------------------------------------------------------------------->
<!--- IE6 COMPATIBILITY FOR FRONT END TOOLS ----------->
<!--------------------------------------------------------------------------------------------------------------->
<link href="#application.configBean.getContext()#/admin/css/dialogIE6.css" rel="stylesheet" type="text/css" />	
</cfif>

<cfif variables.isIeSix>
	<!--- NAMED DIFFERENTLY TO USE THE IE6 COMPATIBLE dialogIE6.css --->
	<img src="#application.configBean.getContext()#/admin/images/ie6/logo_small_feTools.gif" id="frontEndToolsHandleIE6" onclick="if (document.getElementById('frontEndToolsIE6').style.display == 'none') { createCookie('FETDISPLAY','',5); } else { createCookie('FETDISPLAY','none',5); } toggleAdminToolbarIE6();" />
	<div id="frontEndToolsIE6" style="display: #Cookie.fetDisplay#">						
<cfelse>
	<!--- USES STANDARD dialog.css --->
	<img src="#application.configBean.getContext()#/admin/images/logo_small_feTools.png" id="frontEndToolsHandle" onclick="if (document.getElementById('frontEndTools').style.display == 'none') { createCookie('FETDISPLAY','',5); } else { createCookie('FETDISPLAY','none',5); } toggleAdminToolbar();" />
	<div id="frontEndTools" style="display: #Cookie.fetDisplay#">
</cfif>
		<ul>
		<cfif not request.contentBean.getIsNew()>
			<cfif ListFindNoCase('editor,author',request.r.perm) or listFind(session.mura.memberships,'S2')>
			<li id="adminEditPage"><a href="#editLink#" #targetHook#>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit')#</a></li>
				<cfif listFind("Page,Portal,Calendar,Gallery",request.contentBean.getType())>
						<cfif variables.isIeSix>
						<!--- USES JAVASCRIPT TO SHOW AND HIDE THE ADD MENU AS IT PLAYS NICE WITH IE6 --->
						<li id="adminAddContent" onmouseover="showSubMenuIE6(this.id,'addMenuDropDown')" onmouseout="hideObjIE6('addMenuDropDown')"><a href="##" onclick="return false;">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.add')#&hellip;</a>																						
						<cfelse>							
						<li id="adminAddContent"><a href="##" onclick="return false;">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.add')#&hellip;</a>						
							
						</cfif><ul id="addMenuDropDown">
						<cfif request.contentBean.getType() neq 'Gallery'>
						<li id="adminNewPage"><a href="#newLink#&amp;type=Page" #targetHook#>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.page')#</a></li>
						<li id="adminNewLink"><a href="#newLink#&amp;type=Link" #targetHook# >#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.link')#</a></li>
						<li id="adminNewFile"><a href="#newLink#&amp;type=File" #targetHook#>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.file')#</a></li>
						<li id="adminNewPortal"><a href="#newLink#&amp;type=Portal" #targetHook#>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.portal')#</a></li>
						<li id="adminNewCalendar"><a href="#newLink#&amp;type=Calendar" #targetHook# >#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.calendar')#</a></li>
						<li id="adminNewGallery"><a href="#newLink#&amp;type=Gallery" #targetHook#>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.gallery')#</a></li>
						<cfelse>
							<li id="adminNewGalleryItem"><a href="#newLink#&amp;type=File" #targetHook#>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.galleryitem')#</a></li>
							<li id="adminNewGalleryItemMulti"><a href="#newMultiLink#&amp;type=File" #targetHook#>#application.rbFactory.getKeyValue(session.rb,'sitemanager.addmultiitems')#</a></li>
						</cfif>			
						#application.pluginManager.renderScripts("onFEToolbarAddRender",request.contentBean.getSiteID())#
						#application.pluginManager.renderScripts("onFEToolbar#request.contentBean.getType()#AddRender",request.contentBean.getSiteID())#
						#application.pluginManager.renderScripts("onFEToolbar#request.contentBean.getType()##request.contentBean.getSubType()#AddRender",request.contentBean.getSiteID())#
						</ul>
					</li>
				</cfif>
				<li id="adminVersionHistory"><a href="#historyLink#" #targetHook#>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.versionhistory')#</a></li>
			</cfif>
			<cfif (request.r.perm eq 'editor' or listFind(session.mura.memberships,'S2')) and request.contentBean.getFilename() neq "" and not request.contentBean.getIslocked()>
				<li id="adminDelete"><a href="#deleteLink#" onclick="return confirm('#jsStringFormat(application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentrecursiveconfirm'),request.contentBean.getMenutitle()))#');">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#</a></li>
			</cfif>
			<cfif listFind(session.mura.memberships,'S2IsPrivate')><li id="adminSiteManager"><a href="#adminLink#" target="admin">#application.rbFactory.getKeyValue(session.rb,'layout.sitemanager')#</a></li></cfif>
		<cfelse>
			<cfif listFind(session.mura.memberships,'S2IsPrivate')><li id="adminSiteManager404"><a href="#adminLink#" target="admin">#application.rbFactory.getKeyValue(session.rb,'layout.sitemanager')#</li></cfif>	
		</cfif>
		<li id="adminLogOut"><a href="?doaction=logout">#application.rbFactory.getKeyValue(session.rb,'layout.logout')#</a></li>
		<li id="adminWelcome">#application.rbFactory.getKeyValue(session.rb,'layout.welcome')#, #HTMLEditFormat("#session.mura.fname# #session.mura.lname#")#.</li>
		</ul>
		
	</div>
	
	<cfif getJSLib() eq "jquery">
		<div id="frontEndToolsModalTarget"></div>
	</cfif>
</cfoutput>
</cfif>

