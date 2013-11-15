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
/tasks/
/config/
/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfcomponent displayname="formBean" output="false" extends="mura.cfobject">
	
	<cfproperty name="FormID" type="uuid" default="" required="true" maxlength="35" />
	<cfproperty name="Name" type="string" default="" maxlength="150" />
	<cfproperty name="Package" type="string" default="" maxlength="50" />
	<cfproperty name="IsActive" type="boolean" default="0" required="true" />
	<cfproperty name="IsCurrent" type="boolean" default="0" required="true" />
	<cfproperty name="StatusCode" type="numeric" default="0" required="true" />
	<cfproperty name="Notes" type="string" default="" />
	<cfproperty name="SiteID" type="string" default="" required="true" maxlength="25" />
	<cfproperty name="RemoteID" type="string" default="" maxlength="35" />
	<cfproperty name="DateCreate" type="date" default="" required="true" />
	<cfproperty name="DateLastUpdate" type="date" default="" required="true" />
	<cfproperty name="Fields" type="Struct" default="" required="true" />
	<cfproperty name="FormAttributes" type="Struct" default="" required="true" />
	<cfproperty name="FieldOrder" type="Array" default="" required="true" />
	<cfproperty name="DeletedFields" type="Struct" default="" required="false" />
	<cfproperty name="Config" type="Any" default="" required="true" />

	<cfset variables.instance		= StructNew() />
	<cfset variables.fieldsChecked	= false />

	<!--- INIT --->
	<cffunction name="init" access="public" returntype="FormBean" output="false">
		
		<cfargument name="FormID" type="string" required="false" default="" />
		<cfargument name="Name" type="string" required="false" default="" />
		<cfargument name="Package" type="string" required="false" default="" />
		<cfargument name="IsActive" type="boolean" required="false" default="0" />
		<cfargument name="IsCurrent" type="boolean" required="false" default="0" />
		<cfargument name="StatusCode" type="numeric" required="false" default="0" />
		<cfargument name="Notes" type="string" required="false" default="" />
		<cfargument name="SiteID" type="string" required="false" default="" />
		<cfargument name="RemoteID" type="string" required="false" default="" />
		<cfargument name="DateCreate" type="string" required="false" default="" />
		<cfargument name="DateLastUpdate" type="string" required="false" default="" />
		
		<cfargument name="FormAttributes" type="Struct" required="false" default="#StructNew()#" />
		<cfargument name="Fields" type="Struct" required="false" default="#StructNew()#" />
		<cfargument name="FieldOrder" type="Array" required="false" default="#ArrayNew(1)#" />
		<cfargument name="DeletedFields" type="Struct" required="false" default="#StructNew()#" />
		<cfargument name="Config" type="Any" required="false" default="#StructNew()#" />

		<cfset super.init( argumentcollection=arguments ) />

		
		<cfset setFormID( arguments.FormID ) />
		<cfset setName( arguments.Name ) />
		<cfset setPackage( arguments.Package ) />
		<cfset setIsActive( arguments.IsActive ) />
		<cfset setIsCurrent( arguments.IsCurrent ) />
		<cfset setStatusCode( arguments.StatusCode ) />
		<cfset setNotes( arguments.Notes ) />
		<cfset setSiteID( arguments.SiteID ) />
		<cfset setRemoteID( arguments.RemoteID ) />
		<cfset setDateCreate( arguments.DateCreate ) />
		<cfset setDateLastUpdate( arguments.DateLastUpdate ) />

		<cfset setFormAttributes( arguments.FormAttributes ) />
		<cfset setFields( arguments.Fields ) />
		<cfset setFieldOrder( arguments.FieldOrder ) />
		<cfset setDeletedFields( arguments.DeletedFields ) />
		<cfset setConfig( arguments.Config ) />

		
		<cfreturn this />
	</cffunction>

	<cffunction name="setAllValues" access="public" returntype="FieldtypeBean" output="false">
		<cfargument name="values" type="struct" required="yes"/>
		<cfset variables.instance = arguments.values />
		<cfreturn this />
	</cffunction>
	<cffunction name="getAllValues" access="public" returntype="struct" output="false" >
		<cfreturn variables.instance />
	</cffunction>
	
	<cffunction name="setFormID" access="public" returntype="void" output="false">
		<cfargument name="FormID" type="string" required="true" />
		<cfset variables.instance['formid'] = arguments.FormID />
	</cffunction>
	<cffunction name="getFormID" access="public" returntype="string" output="false">
		<cfreturn variables.instance.FormID />
	</cffunction>
	
	<cffunction name="setName" access="public" returntype="void" output="false">
		<cfargument name="Name" type="string" required="true" />
		<cfset variables.instance['name'] = arguments.Name />
	</cffunction>
	<cffunction name="getName" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Name />
	</cffunction>
	
	<cffunction name="setPackage" access="public" returntype="void" output="false">
		<cfargument name="Package" type="string" required="true" />
		<cfset variables.instance['package'] = arguments.Package />
	</cffunction>
	<cffunction name="getPackage" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Package />
	</cffunction>
	
	<cffunction name="setIsActive" access="public" returntype="void" output="false">
		<cfargument name="IsActive" type="boolean" required="true" />
		<cfset variables.instance['isactive'] = arguments.IsActive />
	</cffunction>
	<cffunction name="getIsActive" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsActive />
	</cffunction>
	
	<cffunction name="setIsCurrent" access="public" returntype="void" output="false">
		<cfargument name="IsCurrent" type="boolean" required="true" />
		<cfset variables.instance['iscurrent'] = arguments.IsCurrent />
	</cffunction>
	<cffunction name="getIsCurrent" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsCurrent />
	</cffunction>
	
	<cffunction name="setStatusCode" access="public" returntype="void" output="false">
		<cfargument name="StatusCode" type="numeric" required="true" />
		<cfset variables.instance['statuscode'] = arguments.StatusCode />
	</cffunction>
	<cffunction name="getStatusCode" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.StatusCode />
	</cffunction>
	
	<cffunction name="setNotes" access="public" returntype="void" output="false">
		<cfargument name="Notes" type="string" required="true" />
		<cfset variables.instance['notes'] = arguments.Notes />
	</cffunction>
	<cffunction name="getNotes" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Notes />
	</cffunction>
	
	<cffunction name="setSiteID" access="public" returntype="void" output="false">
		<cfargument name="SiteID" type="string" required="true" />
		<cfset variables.instance['siteid'] = arguments.SiteID />
	</cffunction>
	<cffunction name="getSiteID" access="public" returntype="string" output="false">
		<cfreturn variables.instance.SiteID />
	</cffunction>
	
	<cffunction name="setRemoteID" access="public" returntype="void" output="false">
		<cfargument name="RemoteID" type="string" required="true" />
		<cfset variables.instance['remoteid'] = arguments.RemoteID />
	</cffunction>
	<cffunction name="getRemoteID" access="public" returntype="string" output="false">
		<cfreturn variables.instance.RemoteID />
	</cffunction>
	
	<cffunction name="setDateCreate" access="public" returntype="void" output="false">
		<cfargument name="DateCreate" type="string" required="true" />
		<cfset variables.instance['datecreate'] = arguments.DateCreate />
	</cffunction>
	<cffunction name="getDateCreate" access="public" returntype="string" output="false">
		<cfreturn variables.instance.DateCreate />
	</cffunction>
	
	<cffunction name="setDateLastUpdate" access="public" returntype="void" output="false">
		<cfargument name="DateLastUpdate" type="string" required="true" />
		<cfset variables.instance['datelastupdate'] = arguments.DateLastUpdate />
	</cffunction>
	<cffunction name="getDateLastUpdate" access="public" returntype="string" output="false">
		<cfreturn variables.instance.DateLastUpdate />
	</cffunction>
	<!--- Services --->
	<cffunction name="setFormAttributes" access="public" returntype="void" output="false">
		<cfargument name="FormAttributes" type="struct" required="true" />
		<cfset variables.instance['formattributes'] = arguments.FormAttributes />
	</cffunction>
	<cffunction name="getFormAttributes" access="public" returntype="struct" output="false">
		<cfif not variables.FormAttributesChecked and not structCount( variables.instance.FormAttributes )>
			<cfset setFormAttributes( getFormService().getFormAttributeservice().getFormAttributes( formID = getFormID() ) ) />
			<cfset variables.FormAttributesChecked = true />
		</cfif>

		<cfreturn variables.instance.FormAttributes />
	</cffunction>
	
	<cffunction name="setFields" access="public" returntype="void" output="false">
		<cfargument name="Fields" type="struct" required="true" />
		<cfset variables.instance['fields'] = arguments.Fields />
	</cffunction>
	<cffunction name="getFields" access="public" returntype="struct" output="false">
		<cfif not variables.fieldsChecked and not structCount( variables.instance.Fields )>
			<cfset setFields( getFormService().getFieldService().getFields( formID = getFormID() ) ) />
			<cfset variables.fieldsChecked = true />
		</cfif>

		<cfreturn variables.instance.Fields />
	</cffunction>
	
	<cffunction name="getField" access="public" returntype="any" output="false">
		<cfargument name="FieldID" type="struct" required="true" />

		<cfif StructKeyExists( variables.instance.Fields,arguments.FieldID )>
			<cfreturn variables.instance.Fields[arguments.FieldID] />
		</cfif>
		
		<cfreturn false />
	</cffunction>

	<cffunction name="getConfig" access="public" returntype="struct" output="false">
		<cfargument name="mode" type="string" required="false" default="json" />

		<cfif arguments.mode eq "object">
			<cfreturn deserializeJSON( variables.instance.config ) />
		<cfelse>
			<cfreturn variables.instance.config />
		</cfif>
	</cffunction>
	<cffunction name="setConfig" access="public" returntype="void" output="false">
		<cfargument name="Config" type="struct" required="true" />
		<cfif isJSON( arguments.Config )>
			<cfset variables.instance['config'] = arguments.config>
		<cfelse>
			<cfset variables.instance['config'] = serializeJSON( arguments.config )>
		</cfif>		
	</cffunction>

	<cffunction name="setFieldOrder" access="public" returntype="void" output="false">
		<cfargument name="FieldOrder" type="Array" required="true" />
		<cfset variables.instance['fieldorder'] = arguments.FieldOrder />
	</cffunction>
	<cffunction name="getFieldOrder" access="public" returntype="Array" output="false">
		<cfreturn variables.instance.FieldOrder />
	</cffunction>

	<cffunction name="setDeletedFields" access="public" returntype="void" output="false">
		<cfargument name="DeletedFields" type="struct" required="true" />
		<cfset variables.instance['deletedfields'] = arguments.DeletedFields />
	</cffunction>
	<cffunction name="getDeletedFields" access="public" returntype="struct" output="false">
		<cfreturn variables.instance.DeletedFields />
	</cffunction>


</cfcomponent>	





