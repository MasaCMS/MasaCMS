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

	<cffunction name="setFormBuilderManager" output="false">
		<cfargument name="formBuilderManager">
		<cfset variables.formBuilderManager=arguments.formBuilderManager>
	</cffunction>

	<cffunction name="getDialog" access="public" returntype="string" output="false">
		<cfargument name="rc" type="struct" required="false" default="#StructNew()#">
		
		<cfset arguments.rc.return	= variables.formBuilderManager.getDialog( dialog=arguments.rc.dialog ) />
	</cffunction>

	<cffunction name="getForm" access="public" returntype="string" output="false">
		<cfargument name="rc" type="struct" required="false" default="#StructNew()#">
		
		<cfset var formBean	= "" />

		<cfif not StructKeyExists( arguments.rc,"formID" )>
			<cfset arguments.rc.formID = createUUID() />
		</cfif>
		
		<cfset formBean	= variables.formBuilderManager.getFormBean( formID=arguments.rc.formID ) />
		<cfset arguments.rc.return = formBean.getAsJSON() />
	</cffunction>

	<cffunction name="getField" access="public" returntype="string" output="false">
		<cfargument name="rc" type="struct" required="false" default="#StructNew()#">
		
		<cfset var fieldBean	= "" />

		<cfif not StructKeyExists( arguments.rc,"fieldID" )>
			<cfset arguments.rc.fieldID = createUUID() />
		</cfif>
		<cfif not StructKeyExists( arguments.rc,"fieldType" )>
			<cfset arguments.rc.fieldType = "field-textfield" />
		</cfif>
	
		<cfset fieldBean	= variables.FormBuilderManager.getfieldBean( fieldID=arguments.rc.fieldID,formID=arguments.rc.formID,fieldtype=arguments.rc.fieldType ) />
		<cfset arguments.rc.return = fieldBean.getAsJSON() />
	</cffunction>

	<cffunction name="getFieldType" access="public" returntype="string" output="false">
		<cfargument name="rc" type="struct" required="false" default="#StructNew()#">
		
		<cfset var fieldTypeBean	= "" />

		<cfif not StructKeyExists( rc,"fieldTypeID" )>
			<cfset arguments.rc.fieldTypeID = createUUID() />
		</cfif>
		<cfif not StructKeyExists( rc,"fieldType" )>
			<cfset arguments.rc.fieldType = "field-textfield" />
		</cfif>
		
		<cfset fieldTypeBean	= variables.FormBuilderManager.getfieldTypeBean( fieldTypeID=arguments.rc.fieldTypeID,fieldType=arguments.rc.fieldType ) />
		<cfset arguments.rc.return = fieldTypeBean.getAsJSON() />
	</cffunction>

	<cffunction name="getFieldTemplate" access="public" returntype="string" output="false">
		<cfargument name="rc" type="struct" required="false" default="#StructNew()#">
		
		<cfset var fieldTemplate	= variables.FormBuilderManager.getFieldTemplate( arguments.rc.fieldtype ) />

		<cfset arguments.rc.return = fieldTemplate />
	</cffunction>

	<cffunction name="getDataset" access="public" returntype="string" output="false">
		<cfargument name="rc" type="struct" required="false" default="#StructNew()#">
		
		<cfset var datasetBean	= "" />

		<cfif not StructKeyExists( arguments.rc,"datasetID" ) or not len(arguments.rc.datasetID)>
			<cfset arguments.rc.datasetID = createUUID() />
		</cfif>
	
		<cfset datasetBean	= variables.FormBuilderManager.getdatasetBean( datasetID=arguments.rc.datasetID,fieldID=arguments.rc.fieldID ) />

		<cfset arguments.rc.return = datasetBean.getAsJSON() />
	</cffunction>

</cfcomponent>