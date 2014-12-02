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
<cfcomponent extends="controller" output="false">

<cffunction name="before" output="false">
	<cfargument name="rc">

	<cfif not (
				listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(arguments.rc.siteid).getPrivateUserPoolID()#;0') 
				or listFind(session.mura.memberships,'S2')
				)>
		<cfset secure(arguments.rc)>
	</cfif>
	
	<cfset application.classExtensionManager=variables.configBean.getClassExtensionManager()>
	
	<cfparam name="arguments.rc.subTypeID" default="" />
	<cfparam name="arguments.rc.extendSetID" default="" />
	<cfparam name="arguments.rc.attibuteID" default="" />
	<cfparam name="arguments.rc.siteID" default="" />
	<cfparam name="arguments.rc.hasAvailableSubTypes" default="0" />
</cffunction>

<cffunction name="exportsubtype" output="false">
	<cfargument name="rc">
	
	<cfparam name="arguments.rc.action" default="list" />
	
	  <cfif arguments.rc.action eq 'export'>
		<cfset variables.fw.redirect(action="cExtend.export",append="siteid",path="./")>
	  </cfif>

	<cfset arguments.rc.subtypes = application.classExtensionManager.getSubTypes(arguments.rc.siteID,false) />

</cffunction>

<cffunction name="importsubtypes" output="false">
	<cfargument name="rc">
	
	<cfset var file = "" />
	<cfset var fileContent = "" />
	<cfset var fileManager=getBean("fileManager")>
	
	<cfparam name="arguments.rc.action" default="" />

	<cfif arguments.rc.action eq 'import' and arguments.rc.$.validateCSRFTokens(context=arguments.rc.moduleid)>
		<cfif structKeyExists(arguments.rc,"newfile") and len(arguments.rc.newfile)>
			<cfset file = fileManager.upload( "newFile" ) />

			<cffile action="read" variable="fileContent" file="#file.serverdirectory#/#file.serverfile#" >
			
			<cfset application.classExtensionManager.loadConfigXML( xmlParse(filecontent) ,arguments.rc.siteid) />
			<cfset variables.fw.redirect(action="cExtend.listSubTypes",append="siteid",path="./")>
		</cfif>
	</cfif>

</cffunction>

<cffunction name="export" output="false">
	<cfargument name="rc">
	
	<cfset extendArray = ArrayNew(1)>	
	<cfset arguments.rc.exportXML = "" />
	
	<cfif structKeyExists(arguments.rc,"exportClassExtensionID") and len(arguments.rc.exportClassExtensionID)>
		<cfset extendArray = listToArray( arguments.rc.exportClassExtensionID ) />
		<cfset arguments.rc.exportXML = application.classExtensionManager.getSubTypesAsXML( extendArray,false ) />		
	</cfif>

</cffunction>
<cffunction name="updateSubType" output="false">
	<cfargument name="rc">
	
	<cfif not arguments.rc.hasAvailableSubTypes>
		<cfset arguments.rc.availableSubTypes="">
	</cfif>
	
	<cfset arguments.rc.subtypeBean=application.classExtensionManager.getSubTypeByID(arguments.rc.subTypeID) />
		  <cfset arguments.rc.subtypeBean.set(arguments.rc) />
		  
		  <cfif arguments.rc.$.validateCSRFTokens(context=arguments.rc.subtypeid)>
		  <cfif arguments.rc.action eq 'Update'>
		  		<cfset arguments.rc.subtypeBean.save() />
		  </cfif>
	  
		  <cfif arguments.rc.action eq 'Delete'>
		  		<cfset arguments.rc.subtypeBean.delete() />
		  </cfif>
	  
		  <cfif arguments.rc.action eq 'Add'>
		  		<cfset arguments.rc.subtypeBean.save() />
		  </cfif> 
	</cfif>
	  
  <cfif arguments.rc.action neq 'delete'>
	  <cfset arguments.rc.subTypeID=rc.subtypeBean.getSubTypeID()>
	  <cfset variables.fw.redirect(action="cExtend.listSets",append="subTypeID,siteid",path="./")>
  <cfelse>
  	  <cfset variables.fw.redirect(action="cExtend.listSubTypes",append="siteid",path="./")>
  </cfif>
	  
</cffunction>

<cffunction name="updateSet" output="false">
	<cfargument name="rc">
	
	<cfset arguments.rc.extendSetBean=application.classExtensionManager.getSubTypeBean().getExtendSetBean() />
	<cfset arguments.rc.extendSetBean.set(arguments.rc) />

	<cfif arguments.rc.$.validateCSRFTokens(context=arguments.rc.extendsetid)>
	  <cfif arguments.rc.action eq 'Update'>
	  	<cfset arguments.rc.extendSetBean.save() />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Delete'>
	  	<cfset arguments.rc.extendSetBean.delete() />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Add'>
	  	<cfset arguments.rc.extendSetBean.save() />
	  </cfif> 
	</cfif>

	  <cfif arguments.rc.action neq 'delete'>
		<cfset variables.fw.redirect(action="cExtend.editAttributes",append="subTypeId,extendSetID,siteid",path="./")>
	  <cfelse>
	  	<cfset variables.fw.redirect(action="cExtend.listSets",append="subTypeId,siteid",path="./")>
	  </cfif>
</cffunction>	  	


<cffunction name="updateRelatedContentSet" output="false">
	<cfargument name="rc">

	
	<cfset arguments.rc.rcsBean = getBean('relatedContentSet').loadBy(relatedContentSetID=arguments.rc.relatedContentSetID)>
		
		<cfif not arguments.rc.hasAvailableSubTypes>
			<cfset arguments.rc.availableSubTypes="">
		</cfif>
		
		<cfset arguments.rc.rcsBean.set(arguments.rc) />
		
		<cfif arguments.rc.$.validateCSRFTokens(context=arguments.rc.relatedContentSetID)>

			<cfif listFindNoCase("Update,Add", arguments.rc.action)>
				<cfset arguments.rc.rcsBean.save() />
			</cfif>
			
			<cfif arguments.rc.action eq 'Delete'>
				<cfset arguments.rc.rcsBean.delete() />
			</cfif>
		</cfif>
	<cfset variables.fw.redirect(action="cExtend.listSets",append="subTypeId,siteid",path="./")>
</cffunction>	

<cffunction name="updateAttribute" output="false">
	<cfargument name="rc">
	 
		<cfset arguments.rc.attributeBean=application.classExtensionManager.getSubTypeBean().getExtendSetBean().getattributeBean() />
		<cfset arguments.rc.attributeBean.set(arguments.rc) />

		<cfif arguments.rc.$.validateCSRFTokens(context=arguments.rc.attributeid)>
		  <cfif arguments.rc.action eq 'Update'>
		  	<cfset arguments.rc.attributeBean.save() />
		  </cfif>
	  
		  <cfif arguments.rc.action eq 'Delete'>
		  	<cfset arguments.rc.attributeBean.delete() />
		  </cfif>
	  
		  <cfif arguments.rc.action eq 'Add'>
		  	<cfset arguments.rc.attributeBean.save() />
		  </cfif> 
	  </cfif>
	 <cfset variables.fw.redirect(action="cExtend.editAttributes",append="subTypeId,extendSetID,siteid",path="./")>
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

<cffunction name="saveRelatedSetSort" output="false">
	<cfargument name="rc">
	<cfset application.classExtensionManager.saveRelatedSetSort(arguments.rc.relatedContentSetID) />
	<cfabort>
</cffunction>
</cfcomponent>