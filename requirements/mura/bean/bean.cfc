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
<cfcomponent extends="mura.cfobject" output="false">

<cfproperty name="errors" type="struct" default="{}" required="true" />
<cfproperty name="siteID" type="String" default="" required="true" />
<cfproperty name="fromMuraCache" type="boolean" default="false" required="true" />

<cffunction name="init" output="false">
	<cfset super.init(argumentCollection=arguments)>
	<cfset variables.instance=structNew()>
	<cfset variables.instance.siteID=""/>
	<cfset variables.instance.errors=structNew()/>
	<cfset variables.instance.fromMuraCache = false />
	<cfreturn this>
</cffunction>

<cffunction name="OnMissingMethod" access="public" returntype="any" output="false" hint="Handles missing method exceptions.">
<cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method." />
<cfargument name="MissingMethodArguments" type="struct" required="true" />
<cfset var prop="">
<cfset var prefix=left(arguments.MissingMethodName,3)>
<cfset var bean="">

<cfif len(arguments.MissingMethodName)>
	<cfif listFindNoCase("set,get",prefix) and len(arguments.MissingMethodName) gt 3>
		<cfset prop=right(arguments.MissingMethodName,len(arguments.MissingMethodName)-3)>	
		<cfif prefix eq "get">
			<cfreturn getValue(prop)>
		<cfelseif prefix eq "set" and not structIsEmpty(arguments.MissingMethodArguments)>
			<cfset setValue(prop,arguments.MissingMethodArguments[1])>	
			<cfreturn this>
		</cfif>
	<cfelse>
		<cfthrow message="The method '#arguments.MissingMethodName#' is not defined">
	</cfif>
<cfelse>
	<cfreturn "">
</cfif>
</cffunction>

<cffunction name="parseDateArg" output="false" access="public">
    <cfargument name="arg" type="string" required="true">
	<cfif lsisDate(arguments.arg)>
		<cftry>
		<cfreturn lsparseDateTime(arguments.arg) />
		<cfcatch>
			<cfreturn arguments.arg />
		</cfcatch>
		</cftry>
	<cfelseif isDate(arguments.arg)>
		<cftry>
		<cfreturn parseDateTime(arguments.arg) />
		<cfcatch>
			<cfreturn arguments.arg />
		</cfcatch>
		</cftry>
	<cfelse>
		<cfreturn "" />
	</cfif>
</cffunction>

<cffunction name="setSiteID" output="false" access="public">
    <cfargument name="siteID" type="string" required="true">
    <cfset variables.instance.siteID=arguments.siteID>
	<cfreturn this>
</cffunction>

<cffunction name="set" output="false" access="public">
		<cfargument name="data" type="any" required="true">

		<cfset var prop=""/>
		
		<cfif isQuery(arguments.data) and arguments.data.recordcount>
			<cfloop list="#arguments.data.columnlist#" index="prop">
				<cfset setValue(prop,arguments.data[prop][1]) />
			</cfloop>
			
		<cfelseif isStruct(arguments.data)>
			<cfloop collection="#arguments.data#" item="prop">
				<cfset setValue(prop,arguments.data[prop]) />
			</cfloop>
				
		</cfif>
		
		<cfreturn this>
</cffunction>

<cffunction name="setValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="propertyValue" default="" >
	
	<cfif isSimpleValue(arguments.propertyValue)>
		<cfset arguments.propertyValue=trim(arguments.propertyValue)>
	</cfif>
	
	<cfif structKeyExists(this,"set#arguments.property#")>
		<cfset evaluate("set#property#(arguments.propertyValue)") />
	<cfelse>
		<cfset variables.instance["#arguments.property#"]=arguments.propertyValue />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="defaultValue">
	
	<cfif structKeyExists(this,"get#arguments.property#")>
		<cfreturn evaluate("get#arguments.property#()") />
	<cfelseif structKeyExists(variables.instance,"#arguments.property#")>
		<cfreturn variables.instance["#arguments.property#"] />
	<cfelseif structKeyExists(arguments,"defaultValue")>
		<cfset variables.instance["#arguments.property#"]=arguments.defaultValue />
		<cfreturn variables.instance["#arguments.property#"] />
	<cfelse>
		<cfreturn "" />
	</cfif>

</cffunction>

<cffunction name="setAllValues" returntype="any" access="public" output="false">
	<cfargument name="instance">
	<cfset init()>
	<cfset structAppend(variables.instance,arguments.instance,true)/>
	<cfreturn this>
</cffunction>

<cffunction name="getAllValues" access="public" returntype="struct" output="false">
	<cfreturn variables.instance />
</cffunction>

<cffunction name="valueExists" access="public" output="false">
	<cfargument name="valueKey">
	<cfreturn structKeyExists(variables.instance,arguments.valueKey) />
</cffunction>

<cffunction name="validate" access="public" output="false">
	<cfset variables.instance.errors=structnew() />
	<cfreturn this>
</cffunction>

<cffunction name="setErrors" output="false" access="public">
  <cfargument name="errors"> 
	<cfif isStruct(arguments.errors)>
	 <cfset variables.instance.errors = arguments.errors />
	</cfif> 
	<cfreturn this>
</cffunction>

<cffunction name="getErrors" output="false" access="public">
	<cfreturn variables.instance.errors>
</cffunction>

<cffunction name="setlastUpdateBy" access="public" output="false">
	<cfargument name="lastUpdateBy" type="String" />
	<cfset variables.instance.lastUpdateBy = left(trim(arguments.lastUpdateBy),50) />
	<cfreturn this>
</cffunction>

</cfcomponent>