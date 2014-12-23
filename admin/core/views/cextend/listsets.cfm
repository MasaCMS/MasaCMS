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
<cfinclude template="js.cfm">
<cfset rslist=application.classExtensionManager.getSubTypes(siteID=rc.siteID,activeOnly=false) />
<cfset subType=application.classExtensionManager.getSubTypeByID(rc.subTypeID)>
<cfset extendSets=subType.getExtendSets()/>

<cfset showRelatedContentSets = not listFindNoCase("1,2,User,Group,Address,Site,Component,Form", subType.getType())>

<cfif showRelatedContentSets>
	<cfset relatedContentsets = subType.getRelatedContentSets(includeInheritedSets=false)>
</cfif>

<cfoutput>
	<h1>#rbKey('sitemanager.extension.classextensionoverview')#</h1>

	<div id="nav-module-specific" class="btn-group">
		<a class="btn" href="./?muraAction=cExtend.listSubTypes&amp;siteid=#esapiEncode('url',rc.siteid)#">
			<i class="icon-circle-arrow-left"></i> 
			#rbKey('sitemanager.extension.backtoclassextensions')#
		</a>
		<a class="btn" href="./?muraAction=cExtend.editSubType&amp;subTypeID=#esapiEncode('url',rc.subTypeID)#&amp;siteid=#esapiEncode('url',rc.siteid)#">
			<i class="icon-pencil"></i> 
			#rbKey('sitemanager.extension.editclassextension')#
		</a>

		<!--- Export --->
		<cfif rc.$.currentUser().isSuperUser()>
			<a class="btn" href="./?muraAction=cExtend.export&amp;exportClassExtensionID=#esapiEncode('url',rc.subTypeID)#&amp;siteid=#esapiEncode('url',rc.siteid)#">
				<i class="icon-signout"></i> 
				#rbKey('sitemanager.extension.exportclassextension')#
			</a>
		</cfif>

		<cfif showRelatedContentSets>
			<div class="btn-group">
				<a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
					<i class="icon-plus-sign"></i> 
					#rbKey('sitemanager.extension.add')# 
					<span class="caret"></span>
				</a>
				<ul class="dropdown-menu">
					<li>
						<a href="./?muraAction=cExtend.editSet&subTypeID=#esapiEncode('url',rc.subTypeID)#&siteid=#esapiEncode('url',rc.siteid)#&extendSetID=">
							#rbKey('sitemanager.extension.addattributeset')#
						</a>
					</li>
					<li>
						<a href="./?muraAction=cExtend.editRelatedContentSet&subTypeID=#esapiEncode('url',rc.subTypeID)#&siteid=#esapiEncode('url',rc.siteid)#&relatedContentSetID=">
							#rbKey('sitemanager.extension.addrelatedcontentset')#
						</a>
					</li>
				</ul>
			</div>
		<cfelse>
			<a class="btn" href="./?muraAction=cExtend.editSet&subTypeID=#esapiEncode('url',rc.subTypeID)#&siteid=#esapiEncode('url',rc.siteid)#&extendSetID=">
				<i class="icon-plus-sign"></i> 
				#rbKey('sitemanager.extension.addattributeset')#
			</a>
		</cfif>
	</div>

	<h2>
		<i class="#subtype.getIconClass(includeDefault=true)# icon-large"></i> 
		#application.classExtensionManager.getTypeAsString(subType.getType())# / #subType.getSubType()#
	</h2>

	<h3>
		#rbKey('sitemanager.extension.extendedattributesets')# 
		<cfif arrayLen(extendSets) gt 1>
			(
				<a href="javascript:;" style="display:none;" id="saveSort" onclick="extendManager.saveExtendSetSort('attr-set');return false;">
					<i class="icon-check"></i> 
					#rbKey('sitemanager.extension.saveorder')#
				</a>
				<a href="javascript:;" id="showSort" onclick="extendManager.showSaveSort('attr-set');return false;">
					<i class="icon-move"></i> 
					#rbKey('sitemanager.extension.reorder')#
				</a>
			)
		</cfif>
	</h3>
</cfoutput>

<cfif arrayLen(extendSets)>

	<ul id="attr-set" class="attr-list">
		<cfloop from="1" to="#arrayLen(extendSets)#" index="s">	
			<cfset extendSetBean=extendSets[s]/>
			<cfoutput>
				<li extendSetID="#extendSetBean.getExtendSetID()#">
					<span id="handle#s#" class="handle" style="display:none;"><i class="icon-move"></i></span>
					<p>#extendSetBean.getName()#</p>
					<div class="btns">
						<a title="Edit" href="./?muraAction=cExtend.editAttributes&subTypeID=#esapiEncode('url',rc.subTypeID)#&extendSetID=#extendSetBean.getExtendSetID()#&siteid=#esapiEncode('url',rc.siteid)#"><i class="icon-pencil"></i></a>
						<a title="Delete" href="./?muraAction=cExtend.updateSet&action=delete&subTypeID=#esapiEncode('url',rc.subTypeID)#&extendSetID=#extendSetBean.getExtendSetID()#&siteid=#esapiEncode('url',rc.siteid)##rc.$.renderCSRFTokens(context=extendSetBean.getExtendSetID(),format='url')#" onclick="return confirmDialog('Delete  #esapiEncode("javascript","'#extendSetBean.getname()#'")#?',this.href)"><i class="icon-remove-sign"></i></a>
					</div>
				</li>
			</cfoutput>
		</cfloop>
	</ul>
 <cfelse>
	<p class="alert">#rbKey('sitemanager.extension.noattributesets')#</p>
</cfif>

<cfif showRelatedContentSets>
	<cfif arrayLen(relatedContentsets)>
		<hr />
		<h3>#rbKey('sitemanager.extension.relatedcontentsets')# <cfif arrayLen(relatedContentsets) gt 1>(<a href="javascript:;" style="display:none;" id="saveRelatedSort" onclick="extendManager.saveRelatedSetSort('related-set');return false;"><i class="icon-check"></i> #rbKey('sitemanager.extension.saveorder')#</a><a href="javascript:;"  id="showRelatedSort" onclick="extendManager.showRelatedSaveSort('related-set');return false;"><i class="icon-move"></i> #rbKey('sitemanager.extension.reorder')#</a>)</cfif></h3>
		
		<ul id="related-set" class="attr-list">
			<cfloop from="1" to="#arrayLen(relatedContentsets)#" index="s">	
				<cfset rcsBean=relatedContentsets[s]/>
				<cfoutput>
					<li relatedContentSetID="#rcsBean.getRelatedContentSetID()#">
						<span id="handleRelated#s#" class="handleRelated" style="display:none;"><i class="icon-move"></i></span>
						<p>#rcsBean.getName()#</p>
						<div class="btns">
							<a title="Edit" href="./?muraAction=cExtend.editRelatedContentSet&subTypeID=#esapiEncode('url',rc.subTypeID)#&relatedContentSetID=#rcsBean.getRelatedContentSetID()#&siteid=#esapiEncode('url',rc.siteid)#"><i class="icon-pencil"></i></a>
							<a title="Delete" href="./?muraAction=cExtend.updateRelatedContentSet&action=delete&subTypeID=#esapiEncode('url',rc.subTypeID)#&relatedContentSetID=#rcsBean.getRelatedContentSetID()#&siteid=#esapiEncode('url',rc.siteid)##rc.$.renderCSRFTokens(context=rcsBean.getRelatedContentSetID(),format='url')#" onclick="return confirmDialog('Delete  #esapiEncode("javascript","'#rcsBean.getname()#'")#?',this.href)"><i class="icon-remove-sign"></i></a>
						</div>
					</li>
				</cfoutput>
			</cfloop>
		</ul>
	<cfelse>
		<p class="alert">#rbKey('sitemanager.extension.norelatedcontentsets')#</p>
	</cfif>
</cfif>

