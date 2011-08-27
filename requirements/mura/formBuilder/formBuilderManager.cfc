<cfcomponent displayname="FormBuilderManager" output="false">
	<cfset variables.fields		= StructNew()>

	<cffunction name="init" access="public" output="false" returntype="FormBuilderManager">
		<cfset variables.filePath = "#expandPath("/muraWRM")#/admin/formbuilder/templates" />
		<cfset variables.templatePath = "/muraWRM/admin/formbuilder/templates" />
		<cfset variables.fields["en"] = StructNew()>
		
		<cfreturn this/>
	</cffunction>

	<cffunction name="createJSONForm" access="public" output="false" returntype="any">
		<cfargument name="formID" required="false" type="uuid" default="#createUUID()#" />

		<cfset var formStruct	= StructNew() />
		<cfset var formBean		= createObject('component','formBean').init(formID=formID) />

		<cfset formStruct['datasets']	= StructNew() />
		<cfset formStruct['form']		= formBean.getAsStruct() />

		<cfreturn serializeJSON( formStruct ) />
	</cffunction>

	<cffunction name="getFormBean" access="public" output="false" returntype="any">
		<cfargument name="formID" required="false" type="uuid" default="#createUUID()#" />
		<cfargument name="asJSON" required="false" type="boolean" default="false" />

		<cfset var formBean		= createObject('component','formBean').init(formID=arguments.formID) />

		<cfif arguments.asJSON>
			<cfreturn formBean.getasJSON() />
		<cfelse>
			<cfreturn formBean  />
		</cfif>
		
	</cffunction>

	<cffunction name="getFieldBean" access="public" output="false" returntype="any">
		<cfargument name="formID" required="true" type="uuid" />
		<cfargument name="fieldID" required="false" type="uuid" default="#createUUID()#" />
		<cfargument name="fieldType" required="false" type="string" default="field-textfield" />
		<cfargument name="asJSON" required="false" type="boolean" default="false" />

		<cfset var fieldBean		= createObject('component','fieldBean').init(formID=arguments.formID,fieldID=arguments.fieldID,isdirty=1) />
		<cfset var fieldTypeBean	= "" />
		<cfset var mmRBF			= application.rbFactory />
		<cfset var fieldTypeName	= rereplace(arguments.fieldType,".[^\-]*-","") />

		<cfset fieldTypeBean	= getFieldTypeBean( fieldType=fieldType,asJSON=arguments.asJSON ) />
		<cfset fieldBean.setFieldType( fieldTypeBean ) />
		<cfset fieldBean.setLabel( mmRBF.getKeyValue(session.rb,'formbuilder.new') & " " & mmRBF.getKeyValue(session.rb,'formbuilder.field.#fieldTypeName#') ) />

		<cfif arguments.asJSON>
			<cfreturn fieldBean.getasJSON() />
		<cfelse>
			<cfreturn fieldBean  />
		</cfif>
	</cffunction>

	<cffunction name="getDatasetBean" access="public" output="false" returntype="any">
		<cfargument name="datasetID" required="true" type="uuid" />
		<cfargument name="fieldID" required="false" type="uuid" default="#createUUID()#" />
		<cfargument name="asJSON" required="false" type="boolean" default="false" />
		<cfargument name="modelBean" required="false" type="any" />

		<cfset var datasetBean		= createObject('component','datasetBean').init(datasetID=arguments.datasetID,fieldID=arguments.fieldID) />
		<cfset var mBean			= "" />

		<cfif not StructKeyExists( arguments,"modelBean" ) or isSimpleValue(arguments.modelBean)>
			<cfset mBean	= createObject('component','datarecordBean').init(datasetID=arguments.datasetID) />
		<cfelse>
			<cfset mBean	= arguments.modelBean />
		</cfif>

		<cfset datasetBean.setModel( mBean ) />

		<cfif arguments.asJSON>
			<cfreturn datasetBean.getasJSON() />
		<cfelse>
			<cfreturn datasetBean  />
		</cfif>
	</cffunction>

	<cffunction name="getFieldTypeBean" access="public" output="false" returntype="any">
		<cfargument name="fieldTypeID" required="false" type="uuid" default="#createUUID()#" />
		<cfargument name="fieldType" required="false" type="string" default="field-textfield" />
		<cfargument name="asJSON" required="false" type="boolean" default="false" />

		<cfset var aFieldTemplate		= ListToArray(rereplace(arguments.fieldType,"[^[:alnum:]|-]","","all"),"-") />
		<cfset var displayName			= lcase( aFieldTemplate[1] ) />
		<cfset var typeName				= lcase( aFieldTemplate[2] ) />
		<cfset var fieldTypeBean		= createObject('component','fieldTypeBean').init(fieldTypeID=arguments.fieldTypeID,fieldtype=typeName,displayType=displayName) />

		<cfswitch expression="#fieldTypeBean.getFieldType()#">
			<cfcase value="dropdown,checkbox,radio" >
				<cfset fieldTypeBean.setIsData( 1 ) />
			</cfcase>	
			<cfcase value="textarea,htmleditor" >
				<cfset fieldTypeBean.setIsLong( 1 ) />
			</cfcase>	
		</cfswitch>

		<cfif arguments.asJSON>
			<cfreturn fieldTypeBean.getasJSON() />
		<cfelse>
			<cfreturn fieldTypeBean  />
		</cfif>
	</cffunction>

	<cffunction name="getFieldTemplate" access="public" output="false" returntype="string">
		<cfargument name="fieldType" required="true" type="string" />
		<cfargument name="locale" required="false" type="string" default="en" />
		<cfargument name="reload" required="false" type="boolean" default="false" />

		<cfset var fieldTemplate		= lcase( rereplace(arguments.fieldType,"[^[:alnum:]|-]","","all") & ".cfm" ) />
		<cfset var filePath				= "#variables.filePath#/#fieldTemplate#" />
		<cfset var templatePath			= "#variables.templatePath#/#fieldTemplate#" />
		<cfset var strField				= "" />
		<cfset var mmRBF				= application.rbFactory />
		
		<cfif not StructKeyExists( variables.fields,arguments.locale)>
			<cfset variables.fields[arguments.locale] = StructNew()>
		</cfif>
		
		<cfif arguments.reload or not StructKeyExists( variables.fields[arguments.locale],fieldTemplate)>
			<cfif not fileExists( filePath )>
				<cfreturn mmRBF.getKeyValue(session.rb,'formbuilder.missingfieldtemplatefile') & ": " & fieldTemplate />
			</cfif>
			<cfsavecontent variable="strField"><cfinclude template="#templatePath#"></cfsavecontent>
			<cfset variables.fields[arguments.locale][arguments.fieldType] = trim(strField) />
		</cfif>
	
		<cfreturn variables.fields[arguments.locale][arguments.fieldType] />
	</cffunction>

	<cffunction name="getDialog" access="public" output="false" returntype="string">
		<cfargument name="dialog" required="true" type="string" />
		<cfargument name="locale" required="false" type="string" default="en" />
		<cfargument name="reload" required="false" type="boolean" default="false" />

		<cfset var dialogTemplate		= lcase( rereplace(arguments.dialog,"[^[:alnum:]|-]","","all") & ".cfm" ) />
		<cfset var filePath				= "#variables.filePath#/#dialogTemplate#" />
		<cfset var templatePath			= "#variables.templatePath#/#dialogTemplate#" />
		<cfset var strField				= "" />
		<cfset var mmRBF				= application.rbFactory />
		
		<cfif not StructKeyExists( variables.fields,arguments.locale)>
			<cfset variables.fields[arguments.locale] = StructNew()>
		</cfif>
		
		<cfif arguments.reload or not StructKeyExists( variables.fields[arguments.locale],dialogTemplate)>
			<cfif not fileExists( filePath )>
				<cfreturn mmRBF.getKeyValue(session.rb,'formbuilder.missingfieldtemplatefile') & ": " & dialogTemplate />
			</cfif>
			<cfsavecontent variable="strField"><cfinclude template="#templatePath#"></cfsavecontent>
			<cfset variables.fields[arguments.locale][arguments.dialog] = trim(strField) />
		</cfif>
	
		<cfreturn variables.fields[arguments.locale][arguments.dialog] />
	</cffunction>

	<cffunction name="renderFormJSON" access="public" output="false" returntype="struct">
		<cfargument name="formJSON" required="true" type="string" />

		<cfset var formStruct		= StructNew() />
		<cfset var dataStruct		= StructNew() />
		<cfset var return			= StructNew() />
		<cfset var formBean			= "" />
		<cfset var fieldBean		= "" />
		<cfset var mmRBF			= application.rbFactory />

		<cfif not isJSON( arguments.formJSON )>
			<cfthrow message="#mmRBF.getKeyValue(session.rb,"formbuilder.mustbejson")#" >
		</cfif>

		<cfset formStruct = deserializeJSON(arguments.formJSON) />

		<cfreturn formStruct />
	</cffunction>

</cfcomponent>