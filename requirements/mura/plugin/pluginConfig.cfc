<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->
<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.settings=structNew() />
<cfset variables.name="" />
<cfset variables.deployed=0 />
<cfset variables.pluginID=0 />
<cfset variables.moduleID="" />
<cfset variables.provider="" />
<cfset variables.providerURL="" />
<cfset variables.created="" />
<cfset variables.category="" />
<cfset variables.version="" />

<cffunction name="initSettings" returntype="any" access="public" output="false">
	<cfargument name="data"  type="any" default="#structNew()#">
	
	<cfset variables.settings=arguments.data />
	
	<cfreturn this />
</cffunction>

<cffunction name="getModuleID" returntype="String" access="public" output="false">
	<cfreturn variables.moduleID />
</cffunction>

<cffunction name="setModuleID" access="public" output="false">
	<cfargument name="moduleID" type="String" />
	<cfset variables.moduleID = trim(arguments.moduleID) />
</cffunction>

<cffunction name="setPluginID" access="public" output="false">
	<cfargument name="pluginID" />
	<cfif isnumeric(arguments.pluginID)>
	<cfset variables.pluginID = arguments.pluginID />
	</cfif>
</cffunction>

<cffunction name="getPluginID" returntype="numeric" access="public" output="false">
	<cfreturn variables.pluginID />
</cffunction>

<cffunction name="setName" access="public" output="false">
	<cfargument name="name" type="String" />
	<cfset variables.name = trim(arguments.name) />
</cffunction>

<cffunction name="getName" returntype="String" access="public" output="false">
	<cfreturn variables.name />
</cffunction>

<cffunction name="setProvider" access="public" output="false">
	<cfargument name="provider" type="String" />
	<cfset variables.provider = trim(arguments.provider) />
</cffunction>

<cffunction name="getProvider" returntype="String" access="public" output="false">
	<cfreturn variables.provider />
</cffunction>

<cffunction name="setProviderURL" access="public" output="false">
	<cfargument name="providerURL" type="String" />
	<cfset variables.providerURL = trim(arguments.providerURL) />
</cffunction>

<cffunction name="getProviderURL" returntype="String" access="public" output="false">
	<cfreturn variables.providerURL />
</cffunction>

<cffunction name="setCategory" access="public" output="false">
	<cfargument name="category" type="String" />
	<cfset variables.category = trim(arguments.category) />
</cffunction>

<cffunction name="getCategory" returntype="String" access="public" output="false">
	<cfreturn variables.category />
</cffunction>

<cffunction name="setCreated" access="public" output="false">
	<cfargument name="created" type="String" />
	<cfset variables.created = trim(arguments.created) />
</cffunction>

<cffunction name="getCreated" returntype="String" access="public" output="false">
	<cfreturn variables.created />
</cffunction>

<cffunction name="setDeployed" access="public" output="false">
	<cfargument name="deployed" />
	<cfif isNumeric(arguments.deployed)>
	<cfset variables.deployed = arguments.deployed />
	</cfif>
</cffunction>

<cffunction name="getDeployed" returntype="numeric" access="public" output="false">
	<cfreturn variables.deployed />
</cffunction>

<cffunction name="setVersion" access="public" output="false">
	<cfargument name="version" type="String" />
	<cfset variables.version = trim(arguments.version) />
</cffunction>

<cffunction name="getVersion" returntype="String" access="public" output="false">
	<cfreturn variables.version />
</cffunction>

<cffunction name="setSetting" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="propertyValue" default="" >
	
	<cfset variables.settings["#arguments.property#"]=arguments.propertyValue />

</cffunction>

<cffunction name="getSetting" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
	
	<cfif structKeyExists(variables.settings,"#arguments.property#")>
		<cfreturn variables.settings["#arguments.property#"] />
	<cfelse>
		<cfreturn "" />
	</cfif>

</cffunction>

<cffunction name="getSettings" returntype="any" access="public" output="false">
		<cfreturn variables.settings />
</cffunction>

<cffunction name="addToHTMLHeadQueue" output="false">
<cfargument name="text">
	
<cfset var headerStr=""/>
	
<cfif getSetting("pluginMode") eq "object" and structKeyExists(request,"contentRenderer")>
	<cfset request.contentRenderer.addtoHTMLHeadQueue(getPluginID() & "/" & arguments.text) />
<cfelse>
<cfsavecontent variable="headerStr">
<cfinclude template="/#application.configBean.getWebRootMap()#/plugins/#getPluginID()#/#arguments.text#">
</cfsavecontent>
<cfhtmlhead text="#headerStr#">	
</cfif>
	
</cffunction>

<cffunction name="getApplication" returntype="any" access="public" output="false">
	
		<cfif not structKeyExists(application,"plugins")>
			<cfset application.plugins=structNew()>
		</cfif>
		
		<cfif not structKeyExists(application.plugins,"sp#getPluginID()#")>
			<cfset application.plugins["sp#getPluginID()#"]=createObject("component","pluginApplication")>
		</cfif>
		
		<cfreturn application.plugins["sp#getPluginID()#"] />
</cffunction>

<cffunction name="getSession" returntype="any" access="public" output="false">
	
		<cfif not structKeyExists(session,"plugins")>
			<cfset session.plugins=structNew()>
		</cfif>
		
		<cfif not structKeyExists(session.plugins,"sp#getPluginID()#")>
			<cfset session.plugins["sp#getPluginID()#"]=createObject("component","pluginSession")>
		</cfif>
		
		<cfreturn session.plugins["sp#getPluginID()#"] />
</cffunction>

</cfcomponent>

