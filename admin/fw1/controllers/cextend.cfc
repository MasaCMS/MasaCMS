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

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfcomponent extends="controller" output="false">

<cffunction name="before" output="false">
	<cfargument name="rc">

	<cfif not listFind(session.mura.memberships,'S2')>
		<cfset secure(arguments.rc)>
	</cfif>
	
	<cfset application.classExtensionManager=variables.configBean.getClassExtensionManager()>
	
	<cfparam name="arguments.rc.subTypeID" default="" />
	<cfparam name="arguments.rc.extendSetID" default="" />
	<cfparam name="arguments.rc.attibuteID" default="" />
	<cfparam name="arguments.rc.siteID" default="" />
</cffunction>

<cffunction name="updateSubType" output="false">
	<cfargument name="rc">
	
	 <cfset arguments.rc.subtypeBean=application.classExtensionManager.getSubTypeByID(arguments.rc.subTypeID) />
	  <cfset arguments.rc.subtypeBean.set(arguments.rc) />
	  
	  <cfif arguments.rc.action eq 'Update'>
	  		<cfset arguments.rc.subtypeBean.save() />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Delete'>
	  		<cfset arguments.rc.subtypeBean.delete() />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Add'>
	  		<cfset arguments.rc.subtypeBean.save() />
	  </cfif> 
	
	  <cfif arguments.rc.action neq 'delete'>
		  <cfset arguments.rc.subTypeID=rc.subtypeBean.getSubTypeID()>
		  <cfset variables.fw.redirect(action="cExtend.listSets",append="subTypeID,siteid",path="")>
	  <cfelse>
	  	  <cfset variables.fw.redirect(action="cExtend.listSubTypes",append="siteid",path="")>
	  </cfif>
	  
</cffunction>

<cffunction name="updateSet" output="false">
	<cfargument name="rc">
	 <cfset arguments.rc.extendSetBean=application.classExtensionManager.getSubTypeBean().getExtendSetBean() />
	 <cfset arguments.rc.extendSetBean.set(arguments.rc) />
	  
	  <cfif arguments.rc.action eq 'Update'>
	  	<cfset arguments.rc.extendSetBean.save() />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Delete'>
	  	<cfset arguments.rc.extendSetBean.delete() />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Add'>
	  	<cfset arguments.rc.extendSetBean.save() />
	  </cfif> 
	
	  <cfif arguments.rc.action neq 'delete'>
		<cfset variables.fw.redirect(action="cExtend.editAttributes",append="subTypeId,extendSetID,siteid",path="")>
	  <cfelse>
	  	<cfset variables.fw.redirect(action="cExtend.listSets",append="subTypeId,siteid",path="")>
	  </cfif>
</cffunction>	  	

<cffunction name="updateAttribute" output="false">
	<cfargument name="rc">
	  <cfset arguments.rc.attributeBean=application.classExtensionManager.getSubTypeBean().getExtendSetBean().getattributeBean() />
	  <cfset arguments.rc.attributeBean.set(arguments.rc) />

	  <cfif arguments.rc.action eq 'Update'>
	  	<cfset arguments.rc.attributeBean.save() />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Delete'>
	  	<cfset arguments.rc.attributeBean.delete() />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Add'>
	  	<cfset arguments.rc.attributeBean.save() />
	  </cfif> 
	  
	 <cfset variables.fw.redirect(action="cExtend.editAttributes",append="subTypeId,extendSetID,siteid",path="")>
</cffunction>

<cffunction name="saveAttributeSort" output="false">
	<cfargument name="rc">
	<cfset application.classExtensionManager.saveAttributeSort(arguments.rc.attributeID) />
	<cfabort>
</cffunction>

<cffunction name="saveExtendSetSort" output="false">
	<cfargument name="rc">
	<cfset application.classExtensionManager.saveExtendSetSort(arguments.rc.extendSetID) />
	<cfabort>
</cffunction>
</cfcomponent>