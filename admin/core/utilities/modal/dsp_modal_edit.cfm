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
	
<cfif FindNoCase('Opera','#CGI.HTTP_USER_AGENT#') LESS THAN 1>
<cfparam name="Cookie.fetDisplay" default="">
<cfoutput>
<link href="#application.configBean.getContext()#/admin/assets/css/dialog-min.css" rel="stylesheet" type="text/css" />

<!--- <link href="#application.configBean.getContext()#/admin/assets/css/dialog.css" rel="stylesheet" type="text/css" /> --->
	
<script type="text/javascript" src="#application.configBean.getContext()#/admin/assets/js/porthole/porthole.min.js?coreversion=#application.coreversion#"></script>
<script type="text/javascript" src="#application.configBean.getContext()#/admin/assets/js/dialog.js.cfm?siteid=#URLEncodedFormat(variables.$.event('siteid'))#&coreversion=#application.coreversion#"></script>

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
			<cfset variables.adminBase="https://#application.configBean.getAdminDomain()##application.configBean.getServerPort()#"/>
		<cfelse>
			<cfset variables.adminBase="http://#application.configBean.getAdminDomain()##application.configBean.getServerPort()#"/>
		</cfif>
	<cfelse>
		<cfset variables.adminBase=""/>
	</cfif>
	
	<cfset variables.targetHook=generateEditableHook()>
	
	<cfset variables.editLink = variables.adminBase & "#application.configBean.getContext()#/admin/index.cfm?muraAction=cArch.edit">
	<cfif structKeyExists(request,"previewID") and len(request.previewID)>
		<cfset variables.editLink = variables.editLink & "&amp;contenthistid=" & request.previewID>
	<cfelse>
		<cfset variables.editLink = variables.editLink & "&amp;contenthistid=" & request.contentBean.getContentHistID()>
	</cfif>
	<cfset variables.editLink = variables.editLink & "&amp;siteid=" & request.contentBean.getSiteID()>
	<cfset variables.editLink = variables.editLink & "&amp;contentid=" & request.contentBean.getContentID()>
	<cfset variables.editLink = variables.editLink & "&amp;topid=00000000000000000000000000000000001">
	<cfset variables.editLink = variables.editLink & "&amp;type=" & request.contentBean.getType()>
	<cfset variables.editLink = variables.editLink & "&amp;parentid=" & request.contentBean.getParentID()>
	<cfset variables.editLink = variables.editLink & "&amp;moduleid=" & request.contentBean.getModuleID()>
	<cfset variables.editLink = variables.editLink & "&amp;compactDisplay=true">
	
	<cfset variables.newLink = variables.adminBase & "#application.configBean.getContext()#/admin/index.cfm?muraAction=cArch.loadnewcontentmenu">
	<cfset variables.newLink = variables.newLink & "&amp;contentid=" & request.contentBean.getContentID()>
	<cfset variables.newLink = variables.newLink & "&amp;topid=00000000000000000000000000000000001">
	<cfset variables.newLink = variables.newLink & "&amp;siteid=" & request.contentBean.getSiteID()>
	<cfset variables.newLink = variables.newLink & "&amp;moduleid=" & "00000000000000000000000000000000000">
	<cfset variables.newLink = variables.newLink & "&amp;ptype=" & request.contentBean.getType()>
	<cfset variables.newLink = variables.newLink & "&amp;compactDisplay=true">

	<!---
	'muraAction=cArch.loadnewcontentmenu&compactDisplay=true&siteid=' + siteid +'&contentid=' + contentid + '&parentid=' + parentid + '&topid=' + parentid + '&ptype=' + type +'&cacheid=' + Math.random();

	<cfset variables.newMultiLink = variables.adminBase & "#application.configBean.getContext()#/admin/index.cfm?muraAction=cArch.multiFileUpload">
	<cfset variables.newMultiLink = variables.newMultiLink & "&amp;contentid=">
	<cfset variables.newMultiLink = variables.newMultiLink & "&amp;parentid=" & request.contentBean.getContentID()>
	<cfset variables.newMultiLink = variables.newMultiLink & "&amp;topid=00000000000000000000000000000000001">
	<cfset variables.newMultiLink = variables.newMultiLink & "&amp;siteid=" & request.contentBean.getSiteID()>
	<cfset variables.newMultiLink = variables.newMultiLink & "&amp;moduleid=" & "00000000000000000000000000000000000">
	<cfset variables.newMultiLink = variables.newMultiLink & "&amp;ptype=" & request.contentBean.getType()>
	<cfset variables.newMultiLink = variables.newMultiLink & "&amp;compactDisplay=true">
	--->
	<cfset variables.historyLink = variables.adminBase & "#application.configBean.getContext()#/admin/index.cfm?muraAction=cArch.hist">
	<cfset variables.historyLink = variables.historyLink & "&amp;siteid=" & request.contentBean.getSiteID()>
	<cfset variables.historyLink = variables.historyLink & "&amp;contentid=" & request.contentBean.getContentID()>
	<cfset variables.historyLink = variables.historyLink & "&amp;topid=00000000000000000000000000000000001">
	<cfset variables.historyLink = variables.historyLink & "&amp;type=" & request.contentBean.getType()>
	<cfset variables.historyLink = variables.historyLink & "&amp;parentid=" & request.contentBean.getParentID()>
	<cfset variables.historyLink = variables.historyLink & "&amp;moduleid=" & request.contentBean.getModuleID()>
	<cfset variables.historyLink = variables.historyLink & "&amp;startrow=1">
	<cfset variables.historyLink = variables.historyLink & "&amp;compactDisplay=true">
	
	<cfset variables.adminLink = variables.adminBase & "#application.configBean.getContext()#/admin/index.cfm?muraAction=cArch.list">
	<cfset variables.adminLink = variables.adminLink & "&amp;siteid=" & request.contentBean.getSiteID()>
	<cfset variables.adminLink = variables.adminLink & "&amp;topid=" & request.contentBean.getContentID()>
	<cfset variables.adminLink = variables.adminLink & "&amp;ptype=" & request.contentBean.getType()>
	<cfset variables.adminLink = variables.adminLink & "&amp;parentid=" & request.contentBean.getParentID()>
	<cfset variables.adminLink = variables.adminLink & "&amp;moduleid=" & request.contentBean.getModuleID()>
	<cfset variables.adminLink = variables.adminLink & "&amp;activeTab=0">
	
	<cfset variables.deleteLink = variables.adminBase & "#application.configBean.getContext()#/admin/index.cfm?muraAction=cArch.update">
	<cfset variables.deleteLink = variables.deleteLink & "&amp;siteid=" & request.contentBean.getSiteID()>
	<cfset variables.deleteLink = variables.deleteLink & "&amp;contentid=" & request.contentBean.getContentID()>
	<cfset variables.deleteLink = variables.deleteLink & "&amp;topid=00000000000000000000000000000000001">
	<cfset variables.deleteLink = variables.deleteLink & "&amp;type=" & request.contentBean.getType()>
	<cfset variables.deleteLink = variables.deleteLink & "&amp;parentid=" & request.contentBean.getParentID()>
	<cfset variables.deleteLink = variables.deleteLink & "&amp;moduleid=" & request.contentBean.getModuleID()>
	<cfset variables.deleteLink = variables.deleteLink & "&amp;compactDisplay=true">
	<cfset variables.deleteLink = variables.deleteLink & "&amp;closeCompactDisplay=true">
	<cfset variables.deleteLink = variables.deleteLink & "&amp;action=deleteall">
	<cfset variables.deleteLink = variables.deleteLink & "&amp;startrow=1">
</cfsilent>

	<img src="#application.configBean.getContext()#/admin/assets/images/logo_small_feTools.png" id="frontEndToolsHandle" onclick="if (document.getElementById('frontEndTools').style.display == 'none') { createCookie('FETDISPLAY','',5); } else { createCookie('FETDISPLAY','none',5); } toggleAdminToolbar();" />
	<div id="frontEndTools" style="display: #Cookie.fetDisplay#">

		<ul>
		<cfif not request.contentBean.getIsNew()>
			<cfif ListFindNoCase('editor,author',request.r.perm) or listFind(session.mura.memberships,'S2')>
			<li id="adminEditPage"><a href="#variables.editLink#" #variables.targetHook#><i class="icon-pencil"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit')#</a></li>
				<cfif listFind("Page,LocalRepo,Calendar,Gallery,File,Link",request.contentBean.getType())>
												
						<li id="adminAddContent"><a href="#variables.newLink#" #variables.targethook# data-configurator="true"><i class="icon-plus"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.add')#</a>						
						<!---	
						<ul id="addMenuDropDown" class="dropdown-menu">
						<cfif request.contentBean.getType() neq 'Gallery'>
						<li id="adminNewPage"><a href="#variables.newLink#&amp;type=Page" #variables.targethook#><i class="icon-file"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.page')#</a></li>
						<li id="adminNewLink"><a href="#variables.newLink#&amp;type=Link" #variables.targethook# ><i class="icon-globe"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.link')#</a></li>
						<li id="adminNewFile"><a href="#variables.newLink#&amp;type=File" #variables.targethook#><i class="icon-file"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.file')#</a></li>
						<li id="adminNewLocalRepo"><a href="#variables.newLink#&amp;type=LocalRepo" #variables.targethook#><i class="icon-folder-close"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.LocalRepo')#</a></li>
						<li id="adminNewCalendar"><a href="#variables.newLink#&amp;type=Calendar" #variables.targethook# ><i class="icon-calendar"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.calendar')#</a></li>
						<li id="adminNewGallery"><a href="#variables.newLink#&amp;type=Gallery" #variables.targethook#><i class="icon-th"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.gallery')#</a></li>
						<cfelse>
							<li id="adminNewGalleryItem"><a href="#variables.newLink#&amp;type=File" #variables.targethook#><i class="icon-picture"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.galleryitem')#</a></li>
							<li id="adminNewGalleryItemMulti"><a href="#variables.newMultiLink#&amp;type=File" #variables.targethook#><i class="icon-th-list"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.addmultiitems')#</a></li>
						</cfif>			
						#application.pluginManager.renderScripts("onFEToolbarAddRender",request.contentBean.getSiteID())#
						#application.pluginManager.renderScripts("onFEToolbar#request.contentBean.getType()#AddRender",request.contentBean.getSiteID())#
						#application.pluginManager.renderScripts("onFEToolbar#request.contentBean.getType()##request.contentBean.getSubType()#AddRender",request.contentBean.getSiteID())#
						</ul>--->
					</li>
				</cfif>
				<li id="adminVersionHistory"><a href="#variables.historyLink#" #variables.targethook#><i class="icon-book"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.versionhistory')#</a></li>
			</cfif>
			<cfif (request.r.perm eq 'editor' or listFind(session.mura.memberships,'S2')) and request.contentBean.getFilename() neq "" and not request.contentBean.getIslocked()>
				<li id="adminDelete"><a href="#variables.deleteLink#" onclick="return confirm('#jsStringFormat(application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentrecursiveconfirm'),request.contentBean.getMenutitle()))#');"><i class="icon-remove-sign"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#</a></li>
			</cfif>
			<cfif listFind(session.mura.memberships,'S2IsPrivate')><li id="adminSiteManager"><a href="#variables.adminLink#" target="admin"><i class="icon-list-alt"></i> #application.rbFactory.getKeyValue(session.rb,'layout.sitemanager')#</a></li></cfif>
		<cfelse>
			<cfif listFind(session.mura.memberships,'S2IsPrivate')>
				<li id="adminSiteManager404"><a href="#adminLink#" target="admin">
					<i class="icon-list-alt"></i> #application.rbFactory.getKeyValue(session.rb,'layout.sitemanager')#</a>
				</li>
			</cfif>	
		</cfif>
		<li id="adminLogOut"><a href="?doaction=logout"><i class="icon-signout"></i>#application.rbFactory.getKeyValue(session.rb,'layout.logout')#</a></li>
		<li id="adminWelcome">#application.rbFactory.getKeyValue(session.rb,'layout.welcome')#, #HTMLEditFormat("#session.mura.fname# #session.mura.lname#")#.</li>
		</ul>
		
	</div>
	
	<cfif getJSLib() eq "jquery">
		<div id="frontEndToolsModalTarget"></div>
	</cfif>
</cfoutput>
</cfif>

