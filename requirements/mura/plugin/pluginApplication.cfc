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

<cfset variables.properties=structNew() />
<cfset variables.wired=structNew() />
<cfset variables.pluginConfig="" />

<cffunction name="init" returntype="any" access="public" output="false">
	<cfargument name="data"  type="any" default="#structNew()#">
	
	<cfset variables.properties=arguments.data />
	
	<cfreturn this />
</cffunction>

<cffunction name="setPluginConfig" returntype="any" access="public" output="false">
<cfargument name="pluginConfig" >

	<cfset variables.pluginConfig=arguments.pluginConfig />

</cffunction>

<cffunction name="setValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="propertyValue" default="" required="true">
<cfargument name="autowire" default="false" required="true">
	
	
	<cfset variables.properties[arguments.property]=arguments.propertyValue />
	<cfset structDelete(variables.wired,arguments.property)>
	
	<cfif arguments.autowire and isObject(arguments.propertyValue)>
		<cfset doAutowire(variables.properties[arguments.property])>
		<cfset variables.wired[arguments.property]=true>
	</cfif>

</cffunction>

<cffunction name="doAutowire" output="false">
<cfargument name="cfc">
	<cfset var i="">
	<cfset var item="">
	<cfset var args=structNew()>
	
	<cfloop collection="#arguments.cfc#" item="i">
		<cfif len(i) gt 3 and left(i,3) eq "set">
			<cfset item=right(i,len(i)-3)>
			<cfif item eq "pluginConfig">
				<cfset args=structNew()>
				<cfset args[item] = variables.pluginConfig />
				<cfinvoke component="#arguments.cfc#" method="#i#" argumentCollection="#args#" />
			<cfelseif structKeyExists(variables.properties,item)>
				<cfset args=structNew()>
				<cfset args[item] = variables.properties[item] />
				<cfinvoke component="#arguments.cfc#" method="#i#" argumentCollection="#args#" />
			<cfelseif getServiceFactory().containsBean(item)>
				<cfset args=structNew()>
				<cfset args[item] = getBean(item) />
				<cfinvoke component="#arguments.cfc#" method="#i#" argumentCollection="#args#" />
			</cfif>
		</cfif>
	</cfloop>
	<cfreturn arguments.cfc>
</cffunction>

<cffunction name="getValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="defaultValue" default="" required="true">
<cfargument name="autowire" default="true" required="true" >
	<cfset var returnValue="">
	
	<cfif structKeyExists(variables.properties,arguments.property)>
		<cfset returnValue=variables.properties[arguments.property] />
	<cfelse>
		<cfset variables.properties[arguments.property]=arguments.defaultValue />
		<cfset returnValue=variables.properties[arguments.property] />
	</cfif>
	
	<cfif arguments.autowire and isObject(returnValue) and not structKeyExists(variables.wired,arguments.property)>
		<cfset doAutowire(returnValue)>
		<cfset variables.wired[arguments.property]=true>
	</cfif>
	<cfreturn returnValue>
</cffunction>

<cffunction name="getAllValues" returntype="any" access="public" output="false">
		<cfreturn variables.properties />
</cffunction>

<cffunction name="valueExists" returntype="any" access="public" output="false">
	<cfargument name="property" type="string" required="true">
		<cfreturn structKeyExists(variables.properties,arguments.property) />
</cffunction>

<cffunction name="removeValue" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="true"/>
		<cfset structDelete(variables.properties,arguments.property) />
		<cfset structDelete(variables.wired,arguments.property) />
</cffunction>

<cffunction name="containsBean" returntype="any" access="public" output="false" hint="This is for fw1 autowiring">
	<cfargument name="property" type="string" required="true">
	<cfreturn (structKeyExists(variables.properties,arguments.property) and isObject(variables.properties[arguments.property]))
	 or getServiceFactory().containsBean(arguments.property) or arguments.property eq "pluginConfig">		
</cffunction>

<cffunction name="getBean" returntype="any" access="public" output="false" hint="This is for fw1 autowiring">
	<cfargument name="property" type="string" required="true">	
	<cfif arguments.property eq "pluginConfig">
		<cfreturn variables.pluginConfig>
	<cfelseif getServiceFactory().containsBean(arguments.property)>
		<cfreturn getServiceFactory().getBean(arguments.property)>
	<cfelse>
		<cfreturn getValue(arguments.property)>
	</cfif>
</cffunction>

</cfcomponent>


