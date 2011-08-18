<cfcomponent extends="controller" output="false">

	<cffunction name="setFormBuilderManager" output="false">
		<cfargument name="formBuilderManager">
		<cfset variables.formBuilderManager=arguments.formBuilderManager>
	</cffunction>

	<cffunction name="getDialog" access="public" returntype="string" output="false">
		<cfargument name="rc" type="struct" required="false" default="#StructNew()#">
		
		<cfset rc.return	= variables.formBuilderManager.getDialog( dialog=rc.dialog ) />
	</cffunction>

	<cffunction name="getForm" access="public" returntype="string" output="false">
		<cfargument name="rc" type="struct" required="false" default="#StructNew()#">
		
		<cfset var formBean	= "" />

		<cfif not StructKeyExists( rc,"formID" )>
			<cfset formID = createUUID() />
		</cfif>
		
		<cfset formBean	= variables.formBuilderManager.getFormBean( formID=formID ) />
		<cfset rc.return = formBean.getAsJSON() />
	</cffunction>

	<cffunction name="getField" access="public" returntype="string" output="false">
		<cfargument name="rc" type="struct" required="false" default="#StructNew()#">
		
		<cfset var fieldBean	= "" />

		<cfif not StructKeyExists( rc,"fieldID" )>
			<cfset fieldID = createUUID() />
		</cfif>
		<cfif not StructKeyExists( rc,"fieldType" )>
			<cfset rc.fieldType = "field-textfield" />
		</cfif>
	
		<cfset fieldBean	= variables.FormBuilderManager.getfieldBean( fieldID=fieldID,formID=rc.formID,fieldtype=rc.fieldType ) />
		<cfset rc.return = fieldBean.getAsJSON() />
	</cffunction>

	<cffunction name="getFieldType" access="public" returntype="string" output="false">
		<cfargument name="rc" type="struct" required="false" default="#StructNew()#">
		
		<cfset var fieldTypeBean	= "" />

		<cfif not StructKeyExists( rc,"fieldTypeID" )>
			<cfset rc.fieldTypeID = createUUID() />
		</cfif>
		<cfif not StructKeyExists( rc,"fieldType" )>
			<cfset rc.fieldType = "field-textfield" />
		</cfif>
		
		<cfset fieldTypeBean	= variables.FormBuilderManager.getfieldTypeBean( fieldTypeID=rc.fieldTypeID,fieldType=rc.fieldType ) />
		<cfset rc.return = fieldTypeBean.getAsJSON() />
	</cffunction>

	<cffunction name="getFieldTemplate" access="public" returntype="string" output="false">
		<cfargument name="rc" type="struct" required="false" default="#StructNew()#">
		
		<cfset var fieldTemplate	= variables.FormBuilderManager.getFieldTemplate( rc.fieldtype ) />

		<cfset rc.return = fieldTemplate />
	</cffunction>

	<cffunction name="getDataset" access="public" returntype="string" output="false">
		<cfargument name="rc" type="struct" required="false" default="#StructNew()#">
		
		<cfset var datasetBean	= "" />

		<cfif not StructKeyExists( rc,"datasetID" ) or not len(rc.datasetID)>
			<cfset rc.datasetID = createUUID() />
		</cfif>
	
		<cfset datasetBean	= variables.FormBuilderManager.getdatasetBean( datasetID=rc.datasetID,fieldID=rc.fieldID ) />

		<cfset rc.return = datasetBean.getAsJSON() />
	</cffunction>

</cfcomponent>