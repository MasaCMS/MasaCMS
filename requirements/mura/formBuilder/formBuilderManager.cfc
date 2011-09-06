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