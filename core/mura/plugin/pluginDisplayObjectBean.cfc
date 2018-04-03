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
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.bean.bean" output="false" hint="This provides CRUD functionality to legacy config.xml display objects">
<cfproperty name="objectID" type="string" default="" required="true">
<cfproperty name="moduleID" type="string" default="" required="true">
<cfproperty name="name" type="string" default="" required="true">
<cfproperty name="location" type="string" default="" required="true">
<cfproperty name="displayMethod" type="string" default="" required="true">
<cfproperty name="displayMethodFile" type="string" default="" required="true">
<cfproperty name="doCache" type="string" default="false" required="true">
<cfproperty name="configuratorInit" type="string" default="false" required="true">
<cfproperty name="configuratorJS" type="string" default="false" required="true">

<cfscript>

function init() output=false {
	super.init(argumentCollection=arguments);
	variables.instance.objectID="";
	variables.instance.moduleID="";
	variables.instance.name="";
	variables.instance.location="global";
	variables.instance.displayMethod="";
	variables.instance.displayObjectFile="";
	variables.instance.docache="false";
	variables.instance.configuratorInit="";
	variables.instance.configuratorJS="";
	return this;
}

function setConfigBean(configBean) output=false {
	variables.configBean=arguments.configBean;
	return this;
}

function getObjectID() output=false {
	if ( !len(variables.instance.objectID) ) {
		variables.instance.objectID = createUUID();
	}
	return variables.instance.objectID;
}

function setObjectID(String objectID) output=false {
	variables.instance.objectID = trim(arguments.objectID);
	return this;
}

function getModuleID() output=false {
	return variables.instance.moduleID;
}

function setModuleID(String moduleID) output=false {
	variables.instance.moduleID = trim(arguments.moduleID);
	return this;
}

function getName() output=false {
	return variables.instance.name;
}

function setName(String name) output=false {
	variables.instance.name = trim(arguments.name);
	return this;
}

function getDisplayObjectFile() output=false {
	return variables.instance.displayObjectFile;
}

function setDisplayObjectFile(String displayObjectFile) output=false {
	variables.instance.displayObjectFile = trim(arguments.displayObjectFile);
	return this;
}

function getDisplayMethod() output=false {
	return variables.instance.displayMethod;
}

function setDisplayMethod(String displayMethod) output=false {
	variables.instance.displayMethod = trim(arguments.displayMethod);
	return this;
}

function getLocation() output=false {
	return variables.instance.location;
}

function setLocation(String location) output=false {
	if ( len(arguments.location) ) {
		variables.instance.location = trim(arguments.location);
	}
	return this;
}

function getDoCache() output=false {
	return variables.instance.docache;
}

function setDoCache(String docache) output=false {
	if ( isBoolean(arguments.docache) ) {
		variables.instance.docache = arguments.docache;
	}
	return this;
}

function getConfiguratorInit() output=false {
	return variables.instance.configuratorInit;
}

function setConfiguratorInit(String configuratorInit) output=false {
	variables.instance.configuratorInit = trim(arguments.configuratorInit);
	return this;
}

function getconfiguratorJS() output=false {
	return variables.instance.configuratorJS;
}

function setconfiguratorJS(String configuratorJS) output=false {
	variables.instance.configuratorJS = trim(arguments.configuratorJS);
	return this;
}

function load() output=false {
	set(getQuery());
	return this;
}
</cfscript>


<cffunction name="loadByName"  output="false">
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

<cffunction name="getQuery"  output="false">
	<cfset var rs=""/>
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select objectID,moduleID,name,location,displayobjectfile,displaymethod, docache, configuratorInit, configuratorJS
	from tplugindisplayobjects
	where objectID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getObjectID()#">
	</cfquery>

	<cfreturn rs/>
</cffunction>

<cffunction name="delete">
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tplugindisplayobjects
	where objectID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getObjectID()#">
	</cfquery>
</cffunction>

<cffunction name="save"  output="false">
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
