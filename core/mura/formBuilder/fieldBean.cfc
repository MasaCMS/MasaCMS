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
provided that these modules (a) may only modify the /plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/admin/
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfcomponent displayname="fieldBean" output="false" extends="mura.cfobject" hint="This provides fieldBean functionality">

	<cfproperty name="FieldID" type="uuid" default="" required="true" maxlength="35" />
	<cfproperty name="FormID" type="uuid" default="" required="true" maxlength="35" />
	<cfproperty name="FieldTypeID" type="uuid" default="" required="true" maxlength="35" />
	<cfproperty name="DatasetID" type="uuid" default="" maxlength="35" />
	<cfproperty name="Name" type="string" default="" maxlength="50" />
	<cfproperty name="Label" type="string" default="" maxlength="50" />
	<cfproperty name="displaylegend" type="numeric" default="1" />
	<cfproperty name="OrderNo" type="numeric" default="0" required="true" />
	<cfproperty name="IsActive" type="boolean" default="0" required="true" />
	<cfproperty name="IsDeleted" type="boolean" default="0" required="true" />
	<cfproperty name="IsRequired" type="boolean" default="0" required="true" />
	<cfproperty name="Type" type="string" default="COMMON" required="true" maxlength="20" />
	<cfproperty name="IsEntryType" type="string" default="SINGLE" required="true" maxlength="50" />

	<cfproperty name="Rblabel" type="string" default="" maxlength="100" />
	<cfproperty name="Cssstyle" type="string" default="" maxlength="50" />
	<cfproperty name="placeholder" type="string" default="" maxlength="255" />
	<cfproperty name="ToolTip" type="string" default="" maxlength="250" />
	<cfproperty name="ValidateType" type="string" default="" maxlength="35" />
	<cfproperty name="IsLocked" type="boolean" default="0" required="true" />
	<cfproperty name="ValidateRegex" type="string" default="" maxlength="100" />
	<cfproperty name="ValidateMessage" type="string" default="" maxlength="200" />
	<cfproperty name="SectionID" type="uuid" default="00000000-0000-0000-0000000000000000" required="true" maxlength="35" />
	<cfproperty name="RelatedID" type="uuid" default="" maxlength="35" />
	<cfproperty name="Params" type="string" default="" />
	<cfproperty name="RemoteID" type="string" default="" maxlength="35" />
	<cfproperty name="DateCreate" type="date" default="" required="true" />
	<cfproperty name="DateLastUpdate" type="date" default="" required="true" />
	<cfproperty name="FieldType" type="any" default="" required="true" maxlength="35" />
	<cfproperty name="Value" type="string" default="" required="false" maxlength="250" />
	<cfproperty name="Config" type="Any" default="" required="true" />

	<cfset variables.instance = StructNew() />

	<!--- INIT --->
	<cffunction name="init" returntype="fieldBean" output="false">

		<cfargument name="FieldID" type="uuid" required="false" default="#CreateUUID()#" />
		<cfargument name="FormID" type="string" required="false" default="" />
		<cfargument name="FieldTypeID" type="string" required="false" default="" />
		<cfargument name="DatasetID" type="string" required="false" default="" />
		<cfargument name="Name" type="string" required="false" default="" />
		<cfargument name="Label" type="string" required="false" default="" />
		<cfargument name="Rblabel" type="string" required="false" default="" />
		<cfargument name="Cssstyle" type="string" required="false" default="" />
		<cfargument name="placeholder" type="string" required="false" default="" />
		<cfargument name="ToolTip" type="string" required="false" default="" />
		<cfargument name="OrderNo" type="numeric" required="false" default="0" />
		<cfargument name="IsLocked" type="boolean" required="false" default="0" />
		<cfargument name="IsActive" type="boolean" required="false" default="1" />
		<cfargument name="IsDeleted" type="boolean" required="false" default="0" />
		<cfargument name="IsRequired" type="boolean" required="false" default="0" />
		<cfargument name="Type" type="string" required="false" default="COMMON" />
		<cfargument name="IsEntryType" type="string" required="false" default="SINGLE" />
		<cfargument name="ValidateType" type="string" required="false" default="" />
		<cfargument name="ValidateRegex" type="string" required="false" default="" />
		<cfargument name="ValidateMessage" type="string" required="false" default="" />
		<cfargument name="SectionID" type="string" required="false" default="00000000-0000-0000-0000000000000000" />
		<cfargument name="RelatedID" type="string" required="false" default="" />
		<cfargument name="Params" type="string" required="false" default="" />
		<cfargument name="RemoteID" type="string" required="false" default="" />
		<cfargument name="DateCreate" type="string" required="false" default="" />
		<cfargument name="DateLastUpdate" type="string" required="false" default="" />

		<cfargument name="BeanExists" type="boolean" required="false" default="false" />
		<cfargument name="FieldType" type="any" required="false" default="" />
		<cfargument name="value" type="string" required="false" default="" />
		<cfargument name="Config" type="Any" required="false" default="#StructNew()#" />

		<cfset super.init( argumentcollection=arguments ) />


		<cfset setFieldID( arguments.FieldID ) />
		<cfset setFormID( arguments.FormID ) />
		<cfset setFieldTypeID( arguments.FieldTypeID ) />
		<cfset setDatasetID( arguments.DatasetID ) />
		<cfset setName( arguments.Name ) />
		<cfset setLabel( arguments.Label ) />
		<cfset setOrderNo( arguments.OrderNo ) />
		<cfset setIsActive( arguments.IsActive ) />
		<cfset setIsRequired( arguments.IsRequired ) />
		<cfset setType( arguments.Type ) />
		<cfset setIsEntryType( arguments.IsEntryType ) />
		<cfset setSectionID( arguments.SectionID ) />
		<cfset setRemoteID( arguments.RemoteID ) />


		<cfset setDateCreate( arguments.DateCreate ) />
		<cfset setDateLastUpdate( arguments.DateLastUpdate ) />
		<cfset setIsDeleted( arguments.IsDeleted ) />
		<cfset setRblabel( arguments.Rblabel ) />
		<cfset setCssstyle( arguments.Cssstyle ) />
		<cfset setPlaceHolder( arguments.placeholder ) />
		<cfset setToolTip( arguments.ToolTip ) />
		<cfset setIsLocked( arguments.IsLocked ) />
		<cfset setValidateType( arguments.ValidateType ) />
		<cfset setValidateMessage( arguments.ValidateMessage ) />
		<cfset setValidateRegex( arguments.ValidateRegex ) />
		<cfset setSectionID( arguments.SectionID ) />
		<cfset setRelatedID( arguments.RelatedID ) />
		<cfset setParams( arguments.Params ) />

		<cfset setFieldType( arguments.FieldType ) />
		<cfset setValue( arguments.Value ) />
		<cfset setConfig( arguments.Config ) />

		<cfreturn this />
	</cffunction>

	<cffunction name="setAllValues" returntype="FieldtypeBean" output="false">
		<cfargument name="values" type="struct" required="yes"/>
		<cfset variables.instance = arguments.values />
		<cfreturn this />
	</cffunction>
	<cffunction name="getAllValues" returntype="struct" output="false">
		<cfreturn variables.instance />
	</cffunction>

	<cffunction name="setFieldID" output="false">
		<cfargument name="FieldID" type="uuid" required="true" />
		<cfset variables.instance['fieldid'] = arguments.FieldID />
	</cffunction>
	<cffunction name="getFieldID" returntype="uuid" output="false">
		<cfreturn variables.instance.FieldID />
	</cffunction>

	<cffunction name="setFormID" output="false">
		<cfargument name="FormID" type="string" required="true" />
		<cfset variables.instance['formid'] = arguments.FormID />
	</cffunction>
	<cffunction name="getFormID" output="false">
		<cfreturn variables.instance.FormID />
	</cffunction>

	<cffunction name="setFieldTypeID" output="false">
		<cfargument name="FieldTypeID" type="string" required="true" />
		<cfset variables.instance['fieldtypeid'] = arguments.FieldTypeID />
	</cffunction>
	<cffunction name="getFieldTypeID" output="false">
		<cfreturn variables.instance.FieldTypeID />
	</cffunction>

	<cffunction name="setDatasetID" output="false">
		<cfargument name="DatasetID" type="string" required="true" />
		<cfset variables.instance['datasetid'] = arguments.DatasetID />
	</cffunction>
	<cffunction name="getDatasetID" output="false">
		<cfreturn variables.instance.DatasetID />
	</cffunction>

	<cffunction name="setName" output="false">
		<cfargument name="Name" type="string" required="true" />
		<cfset variables.instance['name'] = arguments.Name />
	</cffunction>
	<cffunction name="getName" output="false">
		<cfreturn variables.instance.Name />
	</cffunction>

	<cffunction name="setLabel" output="false">
		<cfargument name="Label" type="string" required="true" />
		<cfset variables.instance['label'] = arguments.Label />
	</cffunction>
	<cffunction name="getLabel" output="false">
		<cfreturn variables.instance.Label />
	</cffunction>

	<cffunction name="setRblabel" output="false">
		<cfargument name="Rblabel" type="string" required="true" />
		<cfset variables.instance['rblabel'] = arguments.Rblabel />
	</cffunction>
	<cffunction name="getRblabel" output="false">
		<cfreturn variables.instance.Rblabel />
	</cffunction>

	<cffunction name="setCssstyle" output="false">
		<cfargument name="Cssstyle" type="string" required="true" />
		<cfset variables.instance['cssstyle'] = arguments.Cssstyle />
	</cffunction>
	<cffunction name="getCssstyle" output="false">
		<cfreturn variables.instance.Cssstyle />
	</cffunction>

	<cffunction name="setPlaceHolder" output="false">
		<cfargument name="placeholder" type="string" required="true" />
		<cfset variables.instance['placeholder'] = arguments.placeholder />
	</cffunction>
	<cffunction name="getPlaceHolder" output="false">
		<cfreturn variables.instance.placeholder />
	</cffunction>

	<cffunction name="setToolTip" output="false">
		<cfargument name="ToolTip" type="string" required="true" />
		<cfset variables.instance['tooltip'] = arguments.ToolTip />
	</cffunction>
	<cffunction name="getToolTip" output="false">
		<cfreturn variables.instance.ToolTip />
	</cffunction>

	<cffunction name="setOrderNo" output="false">
		<cfargument name="OrderNo" type="numeric" required="true" />
		<cfset variables.instance['orderno'] = arguments.OrderNo />
	</cffunction>
	<cffunction name="getOrderNo" output="false">
		<cfreturn variables.instance.OrderNo />
	</cffunction>

	<cffunction name="setIsLocked" output="false">
		<cfargument name="IsLocked" type="boolean" required="true" />
		<cfset variables.instance['islocked'] = arguments.IsLocked />
	</cffunction>
	<cffunction name="getIsLocked" returntype="boolean" output="false">
		<cfreturn variables.instance.IsLocked />
	</cffunction>

	<cffunction name="setIsActive" output="false">
		<cfargument name="IsActive" type="boolean" required="true" />
		<cfset variables.instance['isactive'] = arguments.IsActive />
	</cffunction>
	<cffunction name="getIsActive" returntype="boolean" output="false">
		<cfreturn variables.instance.IsActive />
	</cffunction>

	<cffunction name="setIsDeleted" output="false">
		<cfargument name="IsDeleted" type="boolean" required="true" />
		<cfset variables.instance['isdeleted'] = arguments.IsDeleted />
	</cffunction>
	<cffunction name="getIsDeleted" returntype="boolean" output="false">
		<cfreturn variables.instance.IsDeleted />
	</cffunction>

	<cffunction name="setIsRequired" output="false">
		<cfargument name="IsRequired" type="boolean" required="true" />
		<cfset variables.instance['isrequired'] = arguments.IsRequired />
	</cffunction>
	<cffunction name="getIsRequired" returntype="boolean" output="false">
		<cfreturn variables.instance.IsRequired />
	</cffunction>

	<cffunction name="setType" output="false">
		<cfargument name="Type" type="string" required="true" />
		<cfset variables.instance['type'] = arguments.Type />
	</cffunction>
	<cffunction name="getType" output="false">
		<cfreturn variables.instance.Type />
	</cffunction>

	<cffunction name="setIsEntryType" output="false">
		<cfargument name="IsEntryType" type="string" required="true" />
		<cfset variables.instance['isentrytype'] = arguments.IsEntryType />
	</cffunction>
	<cffunction name="getIsEntryType" output="false">
		<cfreturn variables.instance.IsEntryType />
	</cffunction>

	<cffunction name="setValidateType" output="false">
		<cfargument name="ValidateType" type="string" required="true" />
		<cfset variables.instance['validatetype'] = arguments.ValidateType />
	</cffunction>
	<cffunction name="getValidateType" output="false">
		<cfreturn variables.instance.ValidateType />
	</cffunction>

	<cffunction name="setValidateMessage" output="false">
		<cfargument name="ValidateMessage" type="string" required="true" />
		<cfset variables.instance['validatemessage'] = arguments.ValidateMessage />
	</cffunction>
	<cffunction name="getValidateMessage" output="false">
		<cfreturn variables.instance.ValidateMessage />
	</cffunction>

	<cffunction name="setValidateRegex" output="false">
		<cfargument name="ValidateRegex" type="string" required="true" />
		<cfset variables.instance['validateregex'] = arguments.ValidateRegex />
	</cffunction>
	<cffunction name="getValidateRegex" output="false">
		<cfreturn variables.instance.ValidateRegex />
	</cffunction>

	<cffunction name="setSectionID" output="false">
		<cfargument name="SectionID" type="string" required="true" />
		<cfset variables.instance['sectionid'] = arguments.SectionID />
	</cffunction>
	<cffunction name="getSectionID" output="false">
		<cfreturn variables.instance.SectionID />
	</cffunction>

	<cffunction name="setRelatedID" output="false">
		<cfargument name="RelatedID" type="string" required="true" />
		<cfset variables.instance['relatedid'] = arguments.RelatedID />
	</cffunction>
	<cffunction name="getRelatedID" output="false">
		<cfreturn variables.instance.RelatedID />
	</cffunction>

	<cffunction name="setParams" output="false">
		<cfargument name="Params" type="string" required="true" />
		<cfset variables.instance['params'] = arguments.Params />
	</cffunction>
	<cffunction name="getParams" output="false">
		<cfreturn variables.instance.Params />
	</cffunction>

	<cffunction name="setRemoteID" output="false">
		<cfargument name="RemoteID" type="string" required="true" />
		<cfset variables.instance['remoteid'] = arguments.RemoteID />
	</cffunction>
	<cffunction name="getRemoteID" output="false">
		<cfreturn variables.instance.RemoteID />
	</cffunction>

	<cffunction name="setDateCreate" output="false">
		<cfargument name="DateCreate" type="string" required="true" />
		<cfset variables.instance['datecreate'] = arguments.DateCreate />
	</cffunction>
	<cffunction name="getDateCreate" output="false">
		<cfreturn variables.instance.DateCreate />
	</cffunction>

	<cffunction name="setDateLastUpdate" output="false">
		<cfargument name="DateLastUpdate" type="string" required="true" />
		<cfset variables.instance['datelastupdate'] = arguments.DateLastUpdate />
	</cffunction>
	<cffunction name="getDateLastUpdate" output="false">
		<cfreturn variables.instance.DateLastUpdate />
	</cffunction>

	<cffunction name="getParamsData" returntype="struct" output="false">
		<cfif not len( getParams() )>
			<cfreturn StructNew() />
		<cfelse>
			<cfreturn deserializeJSON( getParams() )>
		</cfif>
	</cffunction>
	<cffunction name="setParamsData" output="false">
		<cfargument name="ParamsData" type="struct" required="true" />
		<cfif not structCount( arguments.ParamsData )>
			<cfset setParams( "{}" )>
		<cfelse>
			<cfset setParams( serializeJSON( arguments.ParamsData ) )>
		</cfif>
	</cffunction>

	<cffunction name="getConfig" returntype="struct" output="false">
		<cfargument name="mode" type="string" required="false" default="json" />

		<cfif arguments.mode eq "object">
			<cfreturn deserializeJSON( variables.instance.config ) />
		<cfelse>
			<cfreturn variables.instance.config />
		</cfif>
	</cffunction>
	<cffunction name="setConfig" output="false">
		<cfargument name="Config" type="struct" required="true" />
		<cfif isJSON( arguments.Config )>
			<cfset variables.instance['config'] = arguments.config>
		<cfelse>
			<cfset variables.instance['config'] = serializeJSON( arguments.config )>
		</cfif>
	</cffunction>

	<cffunction name="setFieldType" output="false">
		<cfargument name="FieldType" type="any" required="true" />
		<cfset variables.instance['fieldtype'] = arguments.FieldType />
	</cffunction>
	<cffunction name="getFieldType" output="false">
		<cfif len( getFieldTypeID() ) eq 35 and not isInstanceOf(variables.instance['fieldtype'],"FieldTypeBean")>
			<cfset setFieldType( getFieldService().getFieldTypeService().getBeanByAttributes( fieldTypeID = getFieldTypeID() ) ) />
		</cfif>
		<cfreturn variables.instance.FieldType />
	</cffunction>

	<cffunction name="setValue" output="false">
		<cfargument name="Value" type="any" required="true" />
		<cfset variables.instance['value'] = arguments.Value />
	</cffunction>
	<cffunction name="getValue" output="false">
		<cfreturn variables.instance.Value />
	</cffunction>
</cfcomponent>
