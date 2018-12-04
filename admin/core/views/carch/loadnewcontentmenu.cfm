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
<!--- removing galleries
<cfset typeList="Page,Link,File,Folder,Calendar,Gallery">
--->
<cfset $=application.serviceFactory.getBean('$').init(rc.siteID)>
<cfset renderer=$.getContentRenderer()>
<cfif isDefined('renderer.primaryContentTypes') and len(renderer.primaryContentTypes)>
	<cfset typeList=renderer.primaryContentTypes>
<cfelse>
	<cfset typeList="Page,Link,File,Folder,Calendar">
</cfif>
<cfset parentBean=$.getBean('content').loadBy(contentID=rc.contentID)>
<cfset $availableSubTypes=application.classExtensionManager.getSubTypeByName(parentBean.getType(),parentBean.getSubType(),parentBean.getSiteID()).getAvailableSubTypes()>
<cfset rsSubTypes=application.classExtensionManager.getSubTypes(siteID=rc.siteID,activeOnly=true) />
<cfif not isDefined('rc.frontEndProxyLoc')>
	<cfset request.layout=false>
</cfif>
<cfset $=request.event.getValue("MuraScope")>
<cfoutput>
<div class="mura">
	<cfif isDefined('rc.frontEndProxyLoc')>
	<div class="mura-header">
	<h1>#application.rbFactory.getKeyValue(session.rb,"sitemanager.selectcontenttype")#</h1>
	</div>
	<script>
		$(document).ready(function(){setToolTips('.add-content-ui');});
	</script>
	</cfif>
	<div class="add-content-ui">
		<ul>
		<cfif rc.moduleid eq '00000000000000000000000000000000004'>
			<cfloop list="Form,Folder" index="i">
				<cfquery name="rsItemTypes" dbtype="query">
					select * from rsSubTypes where
					lower(type)='#lcase(i)#' and lower(subtype) = 'default'
				</cfquery>
				<cfif not rsItemTypes.recordcount or rsItemTypes.recordcount and (rsItemTypes.adminonly neq 1 or (
					rc.$.currentUser().isAdminUser()
					or rc.$.currentUser().isSuperUser()
					))>
					<cfif not len($availableSubTypes) or listFindNoCase($availableSubTypes,'#i#/Default')>
						<cfif i neq 'Form'>
							<li class="new#i#">
								<cfif len(rsItemTypes.description)>
									<a href="##" rel="tooltip" data-original-title="#esapiEncode('html_attr',rsItemTypes.description)#"><i class="mi-question-circle"></i></a>
								</cfif>
								<a href="./?muraAction=cArch.edit&contentid=&parentid=#esapiEncode('url',rc.contentid)#&parenthistid=#esapiEncode('url',rc.contenthistid)#&type=#i#&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteID)#&moduleid=#esapiEncode('url',rc.moduleid)#&ptype=#esapiEncode('url',rc.ptype)#&compactDisplay=#esapiEncode('url',rc.compactDisplay)#" id="new#i#Link"><i class="#$.iconClassByContentType(type=i,subtype='default',siteid=rc.siteid)#"></i> <span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.add#lcase(i)#")#</span></a>
							</li>
						<cfelse>
							<li class="new#i#">
								<cfif len(rsItemTypes.description)>
									<a href="##" rel="tooltip" data-original-title="#esapiEncode('html_attr',rsItemTypes.description)#"><i class="mi-question-circle"></i></a>
								</cfif>
								<a href="./?muraAction=cArch.edit&contentid=&parentid=#esapiEncode('url',rc.contentid)#&parenthistid=#esapiEncode('url',rc.contenthistid)#&type=#i#&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteID)#&moduleid=#esapiEncode('url',rc.moduleid)#&ptype=#esapiEncode('url',rc.ptype)#&compactDisplay=#esapiEncode('url',rc.compactDisplay)#&formType=builder" id="new#i#Link"><i class="#$.iconClassByContentType(type=i,subtype='default',siteid=rc.siteid)#"></i> <span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.addform")#</span></a>
							</li>
							<cfif application.configBean.getValue('allowSimpleHTMLForms')>
							<li class="new#i#simple">
								<cfif len(rsItemTypes.description)>
									<a href="##" rel="tooltip" data-original-title="#esapiEncode('html_attr',rsItemTypes.description)#"><i class="mi-question-circle"></i></a>
								</cfif>
								<a href="./?muraAction=cArch.edit&contentid=&parentid=#esapiEncode('url',rc.contentid)#&parenthistid=#esapiEncode('url',rc.contenthistid)#&type=#i#&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteID)#&moduleid=#esapiEncode('url',rc.moduleid)#&ptype=#esapiEncode('url',rc.ptype)#&compactDisplay=#esapiEncode('url',rc.compactDisplay)#&formType=editor" id="new#i#Link"><i class="#$.iconClassByContentType(type=i,subtype='default',siteid=rc.siteid)#"></i> <span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.addformsimple")#</span></a>
							</li>
							</cfif>
						</cfif>
					</cfif>
				</cfif>
				<cfif i eq 'Form'>
					<cfquery name="rsItemTypes" dbtype="query">
					select * from rsSubTypes where lower(type)='#lcase(i)#' and lower(subtype) != 'default'
					<cfif not (
							rc.$.currentUser().isAdminUser()
							or rc.$.currentUser().isSuperUser()
							)>
							and adminonly !=1
						</cfif>
					</cfquery>
					<cfloop query="rsItemTypes">
						<cfif not len($availableSubTypes) or listFindNoCase($availableSubTypes,'#i#/#rsItemTypes.subType#')>
							<cfset output = $.renderEvent('on#i##rsItemTypes.subType#NewContentMenuRender')>
							<cfif len(output)>
								#output#
							<cfelse>
								<li class="new#i#">
									<cfif len(rsItemTypes.description)><a href="##" rel="tooltip" data-original-title="#esapiEncode('html_attr',rsItemTypes.description)#"><i class="mi-question-circle"></i></a></cfif>
									<a href="./?muraAction=cArch.edit&contentid=&parentid=#esapiEncode('url',rc.contentid)#&parenthistid=#esapiEncode('url',rc.contenthistid)#&type=#i#&subType=#rsItemTypes.subType#&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteID)#&moduleid=#esapiEncode('url',rc.moduleid)#&ptype=#esapiEncode('url',rc.ptype)#&compactDisplay=#esapiEncode('url',rc.compactDisplay)#" id="new#i#Link"><i class="#$.iconClassByContentType(type=i,subtype=rsItemTypes.subtype,siteid=rc.siteID)#"></i> <span> <!--- #application.rbFactory.getKeyValue(session.rb,"sitemanager.add#lcase(i)#")#/ --->#rsItemTypes.subType#</span></a>
								</li>
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
			</cfloop>
		<cfelseif rc.moduleid eq '00000000000000000000000000000000003'>
			<cfloop list="Component,Folder" index="i">
				<cfquery name="rsItemTypes" dbtype="query">
					select * from rsSubTypes where lower(type)='#lcase(i)#' and lower(subtype) = 'default'
				</cfquery>
				<cfif not rsItemTypes.recordcount or rsItemTypes.recordcount and (rsItemTypes.adminonly neq 1 or (
					rc.$.currentUser().isAdminUser()
					or rc.$.currentUser().isSuperUser()
					))>
					<cfif not len($availableSubTypes) or listFindNoCase($availableSubTypes,'#i#/Default')>
						<li class="new#i#">
							<cfif len(rsItemTypes.description)>
								<a href="##" rel="tooltip" data-original-title="#esapiEncode('html_attr',rsItemTypes.description)#"><i class="mi-question-circle"></i></a>
							</cfif>
							<a href="./?muraAction=cArch.edit&contentid=&parentid=#esapiEncode('url',rc.contentid)#&parenthistid=#esapiEncode('url',rc.contenthistid)#&type=#i#&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteID)#&moduleid=#esapiEncode('url',rc.moduleid)#&ptype=#esapiEncode('url',rc.ptype)#&compactDisplay=#esapiEncode('url',rc.compactDisplay)#" id="new#i#Link"><i class="#$.iconClassByContentType(type=i,subtype='default',siteid=rc.siteid)#"></i> <span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.add#lcase(i)#")#</span></a>
						</li>
					</cfif>
				</cfif>
				<cfif i eq 'Component'>
					<cfquery name="rsItemTypes" dbtype="query">
					select * from rsSubTypes where lower(type)='#lcase(i)#' and lower(subtype) != 'default'
					<cfif not (
							rc.$.currentUser().isAdminUser()
							or rc.$.currentUser().isSuperUser()
							)>
							and adminonly !=1
						</cfif>
					</cfquery>
					<cfloop query="rsItemTypes">
						<cfif not len($availableSubTypes) or listFindNoCase($availableSubTypes,'#i#/#rsItemTypes.subType#')>
							<cfset output = $.renderEvent('on#i##rsItemTypes.subType#NewContentMenuRender')>
							<cfif len(output)>
								#output#
							<cfelse>
								<li class="new#i#">
									<cfif len(rsItemTypes.description)><a href="##" rel="tooltip" data-original-title="#esapiEncode('html_attr',rsItemTypes.description)#"><i class="mi-question-circle"></i></a></cfif>
									<a href="./?muraAction=cArch.edit&contentid=&parentid=#esapiEncode('url',rc.contentid)#&parenthistid=#esapiEncode('url',rc.contenthistid)#&type=#i#&subType=#rsItemTypes.subType#&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteID)#&moduleid=#esapiEncode('url',rc.moduleid)#&ptype=#esapiEncode('url',rc.ptype)#&compactDisplay=#esapiEncode('url',rc.compactDisplay)#" id="new#i#Link"><i class="#$.iconClassByContentType(type=i,subtype=rsItemTypes.subtype,siteid=rc.siteID)#"></i> <span> <!--- #application.rbFactory.getKeyValue(session.rb,"sitemanager.add#lcase(i)#")#/ --->#rsItemTypes.subType#</span></a>
								</li>
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
			</cfloop>
			<cfelseif rc.moduleid eq '00000000000000000000000000000000099'>
				<cfloop list="Folder,File" index="i">
					<cfquery name="rsItemTypes" dbtype="query">
						select * from rsSubTypes where lower(type)='#lcase(i)#' and lower(subtype) = 'default'
					</cfquery>
					<cfif not rsItemTypes.recordcount or rsItemTypes.recordcount and (rsItemTypes.adminonly neq 1 or (
						rc.$.currentUser().isAdminUser()
						or rc.$.currentUser().isSuperUser()
						))>
						<cfif not len($availableSubTypes) or listFindNoCase($availableSubTypes,'#i#/Default')>
							<li class="new#i#">
								<cfif len(rsItemTypes.description)>
									<a href="##" rel="tooltip" data-original-title="#esapiEncode('html_attr',rsItemTypes.description)#"><i class="mi-question-circle"></i></a>
								</cfif>
								<a href="./?muraAction=cArch.edit&contentid=&parentid=#esapiEncode('url',rc.contentid)#&parenthistid=#esapiEncode('url',rc.contenthistid)#&type=#i#&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteID)#&moduleid=#esapiEncode('url',rc.moduleid)#&ptype=#esapiEncode('url',rc.ptype)#&compactDisplay=#esapiEncode('url',rc.compactDisplay)#" id="new#i#Link"><i class="#$.iconClassByContentType(type=i,subtype='default',siteid=rc.siteid)#"></i> <span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.add#lcase(i)#")#</span></a>
							</li>
						</cfif>
					</cfif>
					<cfif i eq 'Variation'>
						<cfquery name="rsItemTypes" dbtype="query">
						select * from rsSubTypes where lower(type)='#lcase(i)#' and lower(subtype) != 'default'
						<cfif not (
								rc.$.currentUser().isAdminUser()
								or rc.$.currentUser().isSuperUser()
								)>
								and adminonly !=1
							</cfif>
						</cfquery>
						<cfloop query="rsItemTypes">
							<cfif not len($availableSubTypes) or listFindNoCase($availableSubTypes,'#i#/#rsItemTypes.subType#')>
								<cfset output = $.renderEvent('on#i##rsItemTypes.subType#NewContentMenuRender')>
								<cfif len(output)>
									#output#
								<cfelse>
									<li class="new#i#">
										<cfif len(rsItemTypes.description)><a href="##" rel="tooltip" data-original-title="#esapiEncode('html_attr',rsItemTypes.description)#"><i class="mi-question-circle"></i></a></cfif>
										<a href="./?muraAction=cArch.edit&contentid=&parentid=#esapiEncode('url',rc.contentid)#&parenthistid=#esapiEncode('url',rc.contenthistid)#&type=#i#&subType=#rsItemTypes.subType#&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteID)#&moduleid=#esapiEncode('url',rc.moduleid)#&ptype=#esapiEncode('url',rc.ptype)#&compactDisplay=#esapiEncode('url',rc.compactDisplay)#" id="new#i#Link"><i class="#$.iconClassByContentType(type=i,subtype=rsItemTypes.subtype,siteid=rc.siteID)#"></i> <span> <!--- #application.rbFactory.getKeyValue(session.rb,"sitemanager.add#lcase(i)#")#/ --->#rsItemTypes.subType#</span></a>
									</li>
								</cfif>
							</cfif>
						</cfloop>
					</cfif>
				</cfloop>
				<cfif application.configBean.getValue(property='allowmultiupload',defaultValue=true) and not len($availableSubTypes) or listFindNoCase($availableSubTypes,'File/Default')>
					<li class="newGalleryItemMulti">
						<!---<a href="##" rel="tooltip" data-original-title="Description goes here."><i class="mi-question-circle"></i></a>--->
						<a href="./?muraAction=cArch.multiFileUpload&contentid=&parentid=#esapiEncode('url',rc.contentid)#&parenthistid=#esapiEncode('url',rc.contenthistid)#&type=File&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteID)#&moduleid=00000000000000000000000000000000000&ptype=#esapiEncode('url',rc.ptype)#&compactDisplay=#esapiEncode('url',rc.compactDisplay)#" id="newGalleryItemMultiLink"><i class="#$.iconClassByContentType(type='Quick',subtype='default',siteid=rc.siteid)#"></i> <span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.addmultiitems")#</span></a>
					</li>
				</cfif>
		<cfelseif rc.ptype neq 'Gallery'>
			<cfloop list="#typeList#" index="i">
				<cfquery name="rsItemTypes" dbtype="query">
					select * from rsSubTypes where lower(type)='#lcase(i)#' and lower(subtype) = 'default'
				</cfquery>
				<cfif not rsItemTypes.recordcount or rsItemTypes.recordcount and (rsItemTypes.adminonly neq 1 or (
					rc.$.currentUser().isAdminUser()
					or rc.$.currentUser().isSuperUser()
					))>
					<cfif not len($availableSubTypes) or listFindNoCase($availableSubTypes,'#i#/Default')>
						<li class="new#i#">
							<cfif len(rsItemTypes.description)>
								<a href="##" rel="tooltip" data-original-title="#esapiEncode('html_attr',rsItemTypes.description)#"><i class="mi-question-circle"></i></a>
							</cfif>
							<a href="./?muraAction=cArch.edit&contentid=&parentid=#esapiEncode('url',rc.contentid)#&parenthistid=#esapiEncode('url',rc.contenthistid)#&type=#i#&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteID)#&moduleid=00000000000000000000000000000000000&ptype=#esapiEncode('url',rc.ptype)#&compactDisplay=#esapiEncode('url',rc.compactDisplay)#" id="new#i#Link"><i class="#$.iconClassByContentType(type=i,subtype='default',siteid=rc.siteid)#"></i> <span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.add#lcase(i)#")#</span></a>
						</li>
					</cfif>
				</cfif>
				<cfquery name="rsItemTypes" dbtype="query">
				select * from rsSubTypes where lower(type)='#lcase(i)#' and lower(subtype) != 'default'
				<cfif not (
						rc.$.currentUser().isAdminUser()
						or rc.$.currentUser().isSuperUser()
						)>
						and adminonly !=1
					</cfif>
				</cfquery>
				<cfloop query="rsItemTypes">
					<cfif not len($availableSubTypes) or listFindNoCase($availableSubTypes,'#i#/#rsItemTypes.subType#')>
						<cfset output = $.renderEvent('on#i##rsItemTypes.subType#NewContentMenuRender')>
						<cfif len(output)>
							#output#
						<cfelse>
							<li class="new#i#">
								<cfif len(rsItemTypes.description)><a href="##" rel="tooltip" data-original-title="#esapiEncode('html_attr',rsItemTypes.description)#"><i class="mi-question-circle"></i></a></cfif>
								<a href="./?muraAction=cArch.edit&contentid=&parentid=#esapiEncode('url',rc.contentid)#&parenthistid=#esapiEncode('url',rc.contenthistid)#&type=#i#&subType=#rsItemTypes.subType#&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteID)#&moduleid=00000000000000000000000000000000000&ptype=#esapiEncode('url',rc.ptype)#&compactDisplay=#esapiEncode('url',rc.compactDisplay)#" id="new#i#Link"><i class="#$.iconClassByContentType(type=i,subtype=rsItemTypes.subtype,siteid=rc.siteID)#"></i> <span> <!--- #application.rbFactory.getKeyValue(session.rb,"sitemanager.add#lcase(i)#")#/ --->#rsItemTypes.subType#</span></a>
							</li>
						</cfif>
					</cfif>
				</cfloop>
			</cfloop>
			<cfif application.configBean.getValue(property='allowmultiupload',defaultValue=true) and not len($availableSubTypes) or listFindNoCase($availableSubTypes,'File/Default')>
				<li class="newGalleryItemMulti">
					<!---<a href="##" rel="tooltip" data-original-title="Description goes here."><i class="mi-question-circle"></i></a>--->
					<a href="./?muraAction=cArch.multiFileUpload&contentid=&parentid=#esapiEncode('url',rc.contentid)#&parenthistid=#esapiEncode('url',rc.contenthistid)#&type=File&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteID)#&moduleid=00000000000000000000000000000000000&ptype=#esapiEncode('url',rc.ptype)#&compactDisplay=#esapiEncode('url',rc.compactDisplay)#" id="newGalleryItemMultiLink"><i class="#$.iconClassByContentType(type='Quick',subtype='default',siteid=rc.siteid)#"></i> <span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.addmultiitems")#</span></a>
				</li>
			</cfif>
		<cfelse>
			<cfquery name="rsItemTypes" dbtype="query">
				select * from rsSubTypes where lower(type)='file' and lower(subtype) != 'default'
				<cfif not (
					rc.$.currentUser().isAdminUser()
					or rc.$.currentUser().isSuperUser()
					)>
					and adminonly !=1
				</cfif>
			</cfquery>
			<cfif not len($availableSubTypes) or listFindNoCase($availableSubTypes,'File/Default')>
				<li class="newGalleryItem">
					<cfif len(rsItemTypes.description)><a href="##" rel="tooltip" data-original-title="#esapiEncode('html_attr',rsItemTypes.description)#"><i class="mi-question-circle"></i></a></cfif>
					<a href="./?muraAction=cArch.edit&contentid=&parentid=#esapiEncode('url',rc.contentid)#&parenthistid=#esapiEncode('url',rc.contenthistid)#&type=File&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteID)#&moduleid=00000000000000000000000000000000000&ptype=#esapiEncode('url',rc.ptype)#&compactDisplay=#esapiEncode('url',rc.compactDisplay)#" id="newGalleryItemLink"><i class="#$.iconClassByContentType(type='GalleryItem',subtype='default',siteid=rc.siteid)#"></i> <span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.addgalleryitem")#</span></a>
				</li>
			</cfif>
			<cfloop query="rsItemTypes">
				<cfif not len($availableSubTypes) or listFindNoCase($availableSubTypes,'File/#rsItemTypes.subType#')>
					<cfset output = $.renderEvent('onFile#rsItemTypes.subType#NewContentMenuRender')>
					<cfif len(output)>
						#output#
					<cfelse>
						<li class="newFile">
							<cfif len(rsItemTypes.description)>
								<a href="##" rel="tooltip" data-original-title="#esapiEncode('html_attr',rsItemTypes.description)#"><i class="mi-question-circle"></i></a>
							</cfif>
							<a href="./?muraAction=cArch.edit&contentid=&parentid=#esapiEncode('url',rc.contentid)#&parenthistid=#esapiEncode('url',rc.contenthistid)#&type=File&subType=#rsItemTypes.subType#&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteID)#&moduleid=00000000000000000000000000000000000&ptype=#esapiEncode('url',rc.ptype)#&compactDisplay=#esapiEncode('url',rc.compactDisplay)#" id="newGalleryItem"><i class="#$.iconClassByContentType(type='GalleryItem',subtype='default',siteid=rc.siteid)#"></i> <span><!--- #application.rbFactory.getKeyValue(session.rb,"sitemanager.addgalleryItem")#/ --->#rsItemTypes.subType#</span></a>
						</li>
					</cfif>
				</cfif>
			</cfloop>
			<cfif application.configBean.getValue(property='allowmultiupload',defaultValue=true) and not len($availableSubTypes) or listFindNoCase($availableSubTypes,'File/Default')>
				<li class="newGalleryItemMulti">
					<!---<a href="##" rel="tooltip" data-original-title="Description goes here."><i class="mi-question-circle"></i></a>--->
					<a href="./?muraAction=cArch.multiFileUpload&contentid=&parentid=#esapiEncode('url',rc.contentid)#&parenthistid=#esapiEncode('url',rc.contenthistid)#&type=File&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteID)#&moduleid=00000000000000000000000000000000000&ptype=#esapiEncode('url',rc.ptype)#&compactDisplay=#esapiEncode('url',rc.compactDisplay)#" id="newGalleryItemMultiLink"><i class="#$.iconClassByContentType(type='Quick',subtype='default',siteid=rc.siteid)#"></i> <span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.addmultiitems")#</span></a>
				</li>
			</cfif>
		</cfif>
		</ul>
	</div>
</div>

#$.renderEvent('onNewContentMenuRender')#

</cfoutput>
