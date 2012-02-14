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
<cfcomponent extends="mura.bean.bean" output="false">

<cfproperty name="objectID" type="string" default="" required="true" />
<cfproperty name="moduleID" type="string" default="" required="true" />
<cfproperty name="name" type="string" default="" required="true" />
<cfproperty name="location" type="string" default="" required="true" />
<cfproperty name="displayMethod" type="string" default="" required="true" />
<cfproperty name="displayMethodFile" type="string" default="" required="true" />
<cfproperty name="doCache" type="string" default="false" required="true" />
<cfproperty name="configuratorInit" type="string" default="false" required="true" />
<cfproperty name="configuratorJS" type="string" default="false" required="true" />

<cffunction name="init" returntype="any" output="false" access="public">
	<cfset super.init(argumentCollection=arguments)>
	
	<cfset variables.instance.objectID="" />
	<cfset variables.instance.moduleID=""/>
	<cfset variables.instance.name=""/>
	<cfset variables.instance.location="global"/>
	<cfset variables.instance.displayMethod=""/>
	<cfset variables.instance.displayObjectFile=""/>
	<cfset variables.instance.docache="false"/>
	<cfset variables.instance.configuratorInit=""/>
	<cfset variables.instance.configuratorJS=""/>
	
	<cfreturn this />
</cffunction>

<cffunction name="setConfigBean" output="false">
	<cfargument name="configBean">
	<cfset variables.configBean=arguments.configBean>
	<cfreturn this>
</cffunction>

<cffunction name="getObjectID" returntype="String" access="public" output="false">
	<cfif not len(variables.instance.objectID)>
		<cfset variables.instance.objectID = createUUID() />
	</cfif>
	<cfreturn variables.instance.objectID />
</cffunction>

<cffunction name="setObjectID" access="public" output="false">
	<cfargument name="objectID" type="String" />
	<cfset variables.instance.objectID = trim(arguments.objectID) />
	<cfreturn this>
</cffunction>

<cffunction name="getModuleID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.moduleID />
</cffunction>

<cffunction name="setModuleID" access="public" output="false">
	<cfargument name="moduleID" type="String" />
	<cfset variables.instance.moduleID = trim(arguments.moduleID) />
	<cfreturn this>
</cffunction>

<cffunction name="getName" returntype="String" access="public" output="false">
	<cfreturn variables.instance.name />
</cffunction>

<cffunction name="setName" access="public" output="false">
	<cfargument name="name" type="String" />
	<cfset variables.instance.name = trim(arguments.name) />
	<cfreturn this>
</cffunction>

<cffunction name="getDisplayObjectFile" returntype="String" access="public" output="false">
	<cfreturn variables.instance.displayObjectFile />
</cffunction>

<cffunction name="setDisplayObjectFile" access="public" output="false">
	<cfargument name="displayObjectFile" type="String" />
	<cfset variables.instance.displayObjectFile = trim(arguments.displayObjectFile) />
	<cfreturn this>
</cffunction>

<cffunction name="getDisplayMethod" returntype="String" access="public" output="false">
	<cfreturn variables.instance.displayMethod />
</cffunction>

<cffunction name="setDisplayMethod" access="public" output="false">
	<cfargument name="displayMethod" type="String" />
	<cfset variables.instance.displayMethod = trim(arguments.displayMethod) />
	<cfreturn this>
</cffunction>

<cffunction name="getLocation" returntype="String" access="public" output="false">
	<cfreturn variables.instance.location />
</cffunction>

<cffunction name="setLocation" access="public" output="false">
	<cfargument name="location" type="String" />
	<cfif len(arguments.location)>
	<cfset variables.instance.location = trim(arguments.location) />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getDoCache" returntype="String" access="public" output="false">
	<cfreturn variables.instance.docache />
</cffunction>

<cffunction name="setDoCache" access="public" output="false">
	<cfargument name="docache" type="String" />
	<cfif isBoolean(arguments.docache)>
		<cfset variables.instance.docache = arguments.docache />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getConfiguratorInit" returntype="String" access="public" output="false">
	<cfreturn variables.instance.configuratorInit />
</cffunction>

<cffunction name="setConfiguratorInit" access="public" output="false">
	<cfargument name="configuratorInit" type="String" />
	<cfset variables.instance.configuratorInit = trim(arguments.configuratorInit) />
	<cfreturn this>
</cffunction>

<cffunction name="getconfiguratorJS" returntype="String" access="public" output="false">
	<cfreturn variables.instance.configuratorJS />
</cffunction>

<cffunction name="setconfiguratorJS" access="public" output="false">
	<cfargument name="configuratorJS" type="String" />
	<cfset variables.instance.configuratorJS = trim(arguments.configuratorJS) />
	<cfreturn this>
</cffunction>

<cffunction name="load"  access="public" output="false" returntype="any">
	<cfset set(getQuery()) />
	<cfreturn this>
</cffunction>

<cffunction name="loadByName"  access="public" output="false" returntype="any">
	<cfset var rs=""/>
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select objectID,moduleID,name,location,displayobjectfile,displaymethod, docache, configuratorInit, configuratorJS
	from tplugindisplayobjects 
	where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getModuleID()#">
	and name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getName()#">
	</cfquery>
	
	<cfset set(rs) />
	<cfreturn this>
</cffunction>

<cffunction name="getQuery"  access="public" output="false" returntype="query">
	<cfset var rs=""/>
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select objectID,moduleID,name,location,displayobjectfile,displaymethod, docache, configuratorInit, configuratorJS
	from tplugindisplayobjects 
	where objectID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getObjectID()#">
	</cfquery>
	
	<cfreturn rs/>
</cffunction>

<cffunction name="delete" access="public" returntype="any">
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tplugindisplayobjects
	where objectID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getObjectID()#">
	</cfquery>
</cffunction>

<cffunction name="save"  access="public" output="false" returntype="any">
<cfset var rs=""/>
<cfset var rsLocation=""/>
<cfset var pluginXML=""/>

	<cfif not len(getLocation())>
		<cfquery name="rsLocation" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		select location from tplugindisplayobjects
		where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getModuleID()#">
		</cfquery>
		
		<cfif len(rsLocation.location)>
			<cfset setLocation(rsLocation.location)>
		<cfelse>
			<cfset pluginXML=getBean('pluginManager').getPluginXML(getModuleID())/>
			<cfif structKeyExists(pluginXML.plugin.displayobjects.xmlAttributes,"location")>
				<cfset setLocation(pluginXML.plugin.displayobjects.xmlAttributes.location) />
			<cfelse>
				<cfset setLocation("global") />
			</cfif>
		</cfif>
	</cfif>
	
	<cfif getQuery().recordcount>
		
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tplugindisplayobjects set
			moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getModuleID()#">,
			name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(getName(),50)#">,
			location=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getLocation()#">,
			displayObjectFile=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getDisplayObjectFile()#">,
			displayMethod=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getDisplayMethod()#">,
			docache=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getDoCache()#">,
			configuratorInit=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getConfiguratorInit()#">,
			configuratorJS=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getconfiguratorJS()#">
		where objectID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getObjectID()#">
		</cfquery>
		
	<cfelse>
	
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			insert into tplugindisplayobjects (objectID,moduleID,name,location,displayobjectfile,displaymethod,docache,configuratorInit,configuratorJS) values (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getObjectID()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getModuleID()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(getName(),50)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getLocation()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getDisplayObjectFile()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getDisplayMethod()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getDoCache()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getConfiguratorInit()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getconfiguratorJS()#">
			)
		</cfquery>
		
	</cfif>
	<cfreturn this>
</cffunction>

</cfcomponent>