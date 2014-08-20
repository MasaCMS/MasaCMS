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

<cfset subType=application.classExtensionManager.getSubTypeByID(rc.subTypeID) />
<cfset extendSet=subType.loadSet(rc.extendSetID)/>
<cfset attributesArray=extendSet.getAttributes() />

<h1>Manage Extended Attribute Set</h1>

<cfoutput>

<div id="nav-module-specific" class="btn-group">
	<div class="btn-group">
      <a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
         <i class="icon-circle-arrow-left"></i> Back <span class="caret"></span>
       </a>
       <ul class="dropdown-menu">
          <li><a href="./?muraAction=cExtend.listSubTypes&siteid=#esapiEncode('url',rc.siteid)#">&hellip;to Class Extensions</a></li>
          <li><a href="./?muraAction=cExtend.listSets&subTypeID=#esapiEncode('url',rc.subTypeID)#&siteid=#esapiEncode('url',rc.siteid)#">&hellip;to Class Extension Overview</a></li>
       </ul>
       </div>
       <div class="btn-group">
       <a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
         <i class="icon-pencil"></i> Edit <span class="caret"></span>
       </a>
       <ul class="dropdown-menu">
          <li><a href="./?muraAction=cExtend.editSubType&subTypeID=#esapiEncode('url',rc.subTypeID)#&siteid=#esapiEncode('url',rc.siteid)#">Class Extension</a></li>
          <li><a href="./?muraAction=cExtend.editSet&subTypeID=#esapiEncode('url',rc.subTypeID)#&extendSetID=#esapiEncode('url',rc.extendSetID)#&siteid=#esapiEncode('url',rc.siteid)#">Attribute Set</a></li>
       </ul>
       </div>
</div>

<h2><i class="#subtype.getIconClass(includeDefault=true)# icon-large"></i> #application.classExtensionManager.getTypeAsString(subType.getType())# / #subType.getSubType()#</h2>

<h3><strong>Attributes Set:</strong> #extendSet.getName()#</h3>

<cfset newAttribute=extendSet.getAttributeBean() />
<cfset newAttribute.setSiteID(rc.siteID) />
<cfset newAttribute.setOrderno(arrayLen(attributesArray)+1) />
<cf_dsp_attribute_form attributesArray="#attributesArray#" attributeBean="#newAttribute#" action="add" subTypeID="#rc.subTypeID#" formName="newFrm" muraScope="#rc.$#">

<cfif arrayLen(attributesArray)>
<ul id="attributesList" class="attr-list">
<cfloop from="1" to="#arrayLen(attributesArray)#" index="a">	
<cfset attributeBean=attributesArray[a]/>
<cfoutput>
	<li test attributeID="#attributeBean.getAttributeID()#">
		<span id="handle#a#" class="handle" style="display:none;"><i class="icon-move"></i></span>
		<p>#attributeBean.getName()#</p>
		<div class="btns">
		<a title="Edit" href="javascript:;" id="editFrm#a#open" onclick="jQuery('##editFrm#a#container').slideDown();this.style.display='none';jQuery('##editFrm#a#close').show();;$('li[attributeID=#attributeBean.getAttributeID()#]').addClass('attr-edit');return false;"><i class="icon-pencil"></i></a>
		<a title="Edit" href="javascript:;" style="display:none;" id="editFrm#a#close" onclick="jQuery('##editFrm#a#container').slideUp();this.style.display='none';jQuery('##editFrm#a#open').show();$('li[attributeID=#attributeBean.getAttributeID()#]').removeClass('attr-edit');return false;"><i class="icon-ok"></i></a>
		<a title="Delete" href="./?muraAction=cExtend.updateAttribute&action=delete&subTypeID=#esapiEncode('url',rc.subTypeID)#&extendSetID=#attributeBean.getExtendSetID()#&siteid=#esapiEncode('url',rc.siteid)#&attributeID=#attributeBean.getAttributeID()##rc.$.renderCSRFTokens(context=attributeBean.getAttributeID(),format='url')#" onClick="return confirmDialog('Delete the attribute #esapiEncode("javascript","'#attributeBean.getname()#'")#?',this.href)"><i class="icon-remove-sign"></i></a>
		</div>
	<div style="display:none;" id="editFrm#a#container">
		<cf_dsp_attribute_form attributeBean="#attributeBean#" action="edit" subTypeID="#rc.subTypeID#" formName="editFrm#a#" muraScope="#rc.$#">
	</div>
	</li>
</cfoutput>
</cfloop>
</ul>

<cfelse>
<p class="alert">This set has no attributes.</p>
</cfif>
</cfoutput>