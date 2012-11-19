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
<cfset typeList="Page,Link,File,Folder,Calendar,Gallery">
<cfset $=application.serviceFactory.getBean('$').init(rc.siteID)>

<cfset parentBean=$.getBean('content').loadBy(contentID=rc.contentID)>
<cfset $availableSubTypes=application.classExtensionManager.getSubTypeByName(parentBean.getType(),parentBean.getSubType(),parentBean.getSiteID()).getAvailableSubTypes()>
<cfset rsSubTypes=application.classExtensionManager.getSubTypes(siteID=rc.siteID,activeOnly=true) />
<cfif not isDefined('rc.frontEndProxyLoc')>
	<cfset request.layout=false>
</cfif>
<cfset $=request.event.getValue("MuraScope")>
<cfoutput>
<cfif isDefined('rc.frontEndProxyLoc')>
<h1>#application.rbFactory.getKeyValue(session.rb,"sitemanager.selectcontenttype")#</h1>
<script>
	$(document).ready(function(){setToolTips('.add-content-ui');});
</script>
</cfif>
<div class="add-content-ui">
<ul>
<cfif rc.ptype neq 'Gallery'>
	<cfloop list="#typeList#" index="i">
		<cfquery name="rsItemTypes" dbtype="query">
		select * from rsSubTypes where lower(type)='#lcase(i)#' and lower(subtype) = 'default'
		</cfquery>
		<cfif not len($availableSubTypes) or listFindNoCase($availableSubTypes,'#i#/Default')>
			<li class="new#i#">
				<cfif len(rsItemTypes.description)>
					<a href="##" rel="tooltip" data-original-title="#HTMLEditFormat(rsItemTypes.description)#"><i class="icon-question-sign"></i></a>
				</cfif>
				<a href="index.cfm?muraAction=cArch.edit&contentid=&parentid=#URLEncodedFormat(rc.contentid)#&type=#i#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteID)#&moduleid=00000000000000000000000000000000000&ptype=#URLEncodedFormat(rc.ptype)#&compactDisplay=#URLEncodedFormat(rc.compactDisplay)#" id="new#i#Link"><i class="#$.iconClassByContentType(i)#"></i> <span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.add#lcase(i)#")#</span></a>
			</li>
		</cfif>
		<cfquery name="rsItemTypes" dbtype="query">
		select * from rsSubTypes where lower(type)='#lcase(i)#' and lower(subtype) != 'default'
		</cfquery>
		<cfloop query="rsItemTypes">
			<cfif not len($availableSubTypes) or listFindNoCase($availableSubTypes,'#i#/#rsItemTypes.subType#')>
				<li class="new#i#">
					<cfif len(rsItemTypes.description)><a href="##" rel="tooltip" data-original-title="#HTMLEditFormat(rsItemTypes.description)#"><i class="icon-question-sign"></i></a></cfif>
					<a href="index.cfm?muraAction=cArch.edit&contentid=&parentid=#URLEncodedFormat(rc.contentid)#&type=#i#&subType=#rsItemTypes.subType#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteID)#&moduleid=00000000000000000000000000000000000&ptype=#URLEncodedFormat(rc.ptype)#&compactDisplay=#URLEncodedFormat(rc.compactDisplay)#" id="new#i#Link"><i class="#$.iconClassByContentType(i)#"></i> <span> #application.rbFactory.getKeyValue(session.rb,"sitemanager.add#lcase(i)#")#/#rsItemTypes.subType#</span></a>
				</li>
			</cfif>
		</cfloop>
	</cfloop>
	<cfif not len($availableSubTypes) or listFindNoCase($availableSubTypes,'File/Default')>
		<li class="newGalleryItemMulti">
			<!---<a href="##" rel="tooltip" data-original-title="Description goes here."><i class="icon-question-sign"></i></a>--->
			<a href="index.cfm?muraAction=cArch.multiFileUpload&contentid=&parentid=#URLEncodedFormat(rc.contentid)#&type=File&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteID)#&moduleid=00000000000000000000000000000000000&ptype=#URLEncodedFormat(rc.ptype)#&compactDisplay=#URLEncodedFormat(rc.compactDisplay)#" id="newGalleryItemMultiLink"><i class="#$.iconClassByContentType('Quick')#"></i> <span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.addmultiitems")#</span></a>
		</li>
	</cfif>
<cfelse>	
	<cfquery name="rsItemTypes" dbtype="query">
		select * from rsSubTypes where lower(type)='file' and lower(subtype) != 'default'
	</cfquery>
	<cfif not len($availableSubTypes) or listFindNoCase($availableSubTypes,'File/Default')>
		<li class="newGalleryItem">
			<cfif len(rsItemTypes.description)><a href="##" rel="tooltip" data-original-title="#HTMLEditFormat(rsItemTypes.description)#"><i class="icon-question-sign"></i></a></cfif>
			<a href="index.cfm?muraAction=cArch.edit&contentid=&parentid=#URLEncodedFormat(rc.contentid)#&type=File&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteID)#&moduleid=00000000000000000000000000000000000&ptype=#URLEncodedFormat(rc.ptype)#&compactDisplay=#URLEncodedFormat(rc.compactDisplay)#" id="newGalleryItemLink"><i class="#$.iconClassByContentType('GalleryItem')#"></i> <span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.addgalleryitem")#</span></a>
		</li>
	</cfif>
	<cfloop query="rsItemTypes">
	<cfif not len($availableSubTypes) or listFindNoCase($availableSubTypes,'File/#rsItemTypes.subType#')>
		<li class="newFile">
			<cfif len(rsItemTypes.description)>
				<a href="##" rel="tooltip" data-original-title="#HTMLEditFormat(rsItemTypes.description)#"><i class="icon-question-sign"></i></a>
			</cfif>
			<a href="index.cfm?muraAction=cArch.edit&contentid=&parentid=#URLEncodedFormat(rc.contentid)#&type=File&subType=#rsItemTypes.subType#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteID)#&moduleid=00000000000000000000000000000000000&ptype=#URLEncodedFormat(rc.ptype)#&compactDisplay=#URLEncodedFormat(rc.compactDisplay)#" id="newGalleryItem"><i class="i#$.iconClassByContentType('GalleryItem')#"></i> <span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.addgalleryItem")#/#rsItemTypes.subType#</span></a>
		</li>
	</cfif>
	</cfloop>
	<cfif not len($availableSubTypes) or listFindNoCase($availableSubTypes,'File/Default')>
		<li class="newGalleryItemMulti">
			<!---<a href="##" rel="tooltip" data-original-title="Description goes here."><i class="icon-question-sign"></i></a>--->
			<a href="index.cfm?muraAction=cArch.multiFileUpload&contentid=&parentid=#URLEncodedFormat(rc.contentid)#&type=File&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteID)#&moduleid=00000000000000000000000000000000000&ptype=#URLEncodedFormat(rc.ptype)#&compactDisplay=#URLEncodedFormat(rc.compactDisplay)#" id="newGalleryItemMultiLink"><i class="#$.iconClassByContentType('Quick')#"></i> <span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.addmultiitems")#</span></a>
		</li>
	</cfif>
</cfif> 
  </ul>
</div>
</cfoutput>

