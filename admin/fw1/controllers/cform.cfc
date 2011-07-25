<cfcomponent extends="controller" output="false">

	<cffunction name="setFormBuilderManager" access="public" returntype="string" output="false">
		<cfargument name="rc" type="struct" required="false" default="#StructNew()#">
		
		<cfset rc.FormBuilderManager	= getBeanFactory().getBean('FormBuilderManager') />

	</cffunction>

	<cffunction name="setFormBuilderManager" output="false">
		<cfargument name="formBuilderManager">
		<cfset variables.formBuilderManager=arguments.formBuilderManager>
	</cffunction>

	<cffunction name="getForm" access="public" returntype="string" output="false">
		<cfargument name="rc" type="struct" required="false" default="#StructNew()#">
		
		<cfif not StructKeyExists( rc,"formID" )>
			<cfset formID = createUUID() />
		</cfif>
		
		<cfset var formBean	= variables.formBuilderManager.getFormBean( formID=formID ) />
		<cfset rc.return = formBean.getAsJSON() />
	</cffunction>

	<cffunction name="getField" access="public" returntype="string" output="false">
		<cfargument name="rc" type="struct" required="false" default="#StructNew()#">
		
		<cfif not StructKeyExists( rc,"fieldID" )>
			<cfset fieldID = createUUID() />
		</cfif>
		<cfif not StructKeyExists( rc,"fieldType" )>
			<cfset rc.fieldType = "field-textfield" />
		</cfif>
	
		<cfset var fieldBean	= variables.FormBuilderManager.getfieldBean( fieldID=fieldID,formID=rc.formID,fieldtype=rc.fieldType ) />
		<cfset rc.return = fieldBean.getAsJSON() />
	</cffunction>

	<cffunction name="getFieldType" access="public" returntype="string" output="false">
		<cfargument name="rc" type="struct" required="false" default="#StructNew()#">
		
		<cfif not StructKeyExists( rc,"fieldTypeID" )>
			<cfset rc.fieldTypeID = createUUID() />
		</cfif>
		<cfif not StructKeyExists( rc,"fieldType" )>
			<cfset rc.fieldType = "field-textfield" />
		</cfif>
		
		<cfset var fieldTypeBean	= variables.FormBuilderManager.getfieldTypeBean( fieldTypeID=rc.fieldTypeID,fieldType=rc.fieldType ) />
		<cfset rc.return = fieldTypeBean.getAsJSON() />
	</cffunction>

	<cffunction name="getFieldTemplate" access="public" returntype="string" output="false">
		<cfargument name="rc" type="struct" required="false" default="#StructNew()#">
		
		<cfset var fieldTemplate	= variables.FormBuilderManager.getFieldTemplate( rc.fieldtype ) />

		<cfset rc.return = fieldTemplate />
	</cffunction>
</cfcomponent>