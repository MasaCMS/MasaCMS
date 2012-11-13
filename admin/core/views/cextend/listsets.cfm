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
<h1>Class Extension Attribute Sets</h1>

<cfoutput>


<cfset subType=application.classExtensionManager.getSubTypeByID(rc.subTypeID)>
<cfset extendSets=subType.getExtendSets()/>

<div id="nav-module-specific" class="btn-group">
<a class="btn" href="index.cfm?muraAction=cExtend.listSubTypes&siteid=#URLEncodedFormat(rc.siteid)#"><i class="icon-circle-arrow-left"></i> Back to Class Extensions</a>

<a class="btn" href="index.cfm?muraAction=cExtend.editSubType&subTypeID=#rc.subTypeID#&siteid=#URLEncodedFormat(rc.siteid)#"><i class="icon-pencil"></i> Edit Class Extension</a>
<a class="btn" href="index.cfm?muraAction=cExtend.editSet&subTypeID=#rc.subTypeID#&siteid=#URLEncodedFormat(rc.siteid)#&extendSetID="><i class="icon-plus-sign"></i> Add Attribute Set</a>
</div>

<h2><i class="#application.settingsManager.getSite(rc.siteID).getContentRenderer().iconClassByContentType(type=subType.getType(),subtype=subType.getSubType())#"></i> #application.classExtensionManager.getTypeAsString(subType.getType())#/#subType.getSubType()#</h2>

</cfoutput>
<cfif arrayLen(extendSets)>
<ul class="nav nav-pills">
<li><a href="javascript:;" style="display:none;" id="saveSort" onclick="extendManager.saveExtendSetSort('attr-set');return false;"><i class="icon-check"></i> Save Order</a></li>
<li><a href="javascript:;"  id="showSort" onclick="extendManager.showSaveSort('attr-set');return false;"><i class="icon-move"></i> Reorder</a></li>
</ul>
</cfif>

<cfif arrayLen(extendSets)>

<ul id="attr-set" class="attr-list">
<cfloop from="1" to="#arrayLen(extendSets)#" index="s">	
<cfset extendSetBean=extendSets[s]/>
<cfoutput>
	<li extendSetID="#extendSetBean.getExtendSetID()#">
		<span id="handle#s#" class="handle" style="display:none;"><i class="icon-move"></i></span>
		<p>#extendSetBean.getName()#</p>
		<div class="btns">
			<a title="Edit" href="index.cfm?muraAction=cExtend.editAttributes&subTypeID=#rc.subTypeID#&extendSetID=#extendSetBean.getExtendSetID()#&siteid=#URLEncodedFormat(rc.siteid)#"><i class="icon-pencil"></i></a>
			<a title="Delete" href="index.cfm?muraAction=cExtend.updateSet&action=delete&subTypeID=#rc.subTypeID#&extendSetID=#extendSetBean.getExtendSetID()#&siteid=#URLEncodedFormat(rc.siteid)#" onclick="return confirmDialog('Delete  #jsStringFormat("'#extendSetBean.getname()#'")#?',this.href)"><i class="icon-remove-sign"></i></a>
		</div>
	</li>
</cfoutput>
</cfloop>
</ul>
 
<cfelse>
<p class="alert">There are currently no available attribute sets.</p>
</cfif>

