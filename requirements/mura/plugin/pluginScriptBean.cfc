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

<cfset variables.instance.scriptID="" />
<cfset variables.instance.moduleID=""/>
<cfset variables.instance.runat=""/>
<cfset variables.instance.scriptfile=""/>

<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="configBean">
	
	<cfset variables.configBean=arguments.configBean />
	<cfset variables.dsn=variables.configBean.getDatasource()/>
	<cfreturn this />
</cffunction>

<cffunction name="set" returnType="void" output="false" access="public">
		<cfargument name="data" type="any" required="true">

		<cfset var prop=""/>
		
		<cfif isquery(arguments.data)>
			
			<cfif arguments.data.recordcount>
				<cfset setScriptID(arguments.data.scriptID) />
				<cfset setRunAt(arguments.data.runAt) />
				<cfset setScriptFile(arguments.data.scriptFile) />
				<cfset setModuleID(arguments.data.moduleID) />
			</cfif>
			
		<cfelseif isStruct(arguments.data)>
		
			<cfloop collection="#arguments.data#" item="prop">
				<cfif isdefined("variables.instance.#prop#")>
					<cfset evaluate("set#prop#(arguments.data[prop])") />
				</cfif>
			</cfloop>
	
			
		</cfif>
		
		<cfset validate() />
		
</cffunction>
  
<cffunction name="validate" access="public" output="false" returntype="void">
	<cfset variables.instance.errors=structnew() />
</cffunction>

<cffunction name="getErrors" returnType="struct" output="false" access="public">
    <cfreturn variables.instance.errors />
</cffunction>

<cffunction name="getScriptID" returntype="String" access="public" output="false">
	<cfif not len(variables.instance.scriptID)>
		<cfset variables.instance.scriptID = createUUID() />
	</cfif>
	<cfreturn variables.instance.scriptID />
</cffunction>

<cffunction name="setScriptID" access="public" output="false">
	<cfargument name="scriptID" type="String" />
	<cfset variables.instance.scriptID = trim(arguments.scriptID) />
</cffunction>


<cffunction name="getModuleID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.moduleID />
</cffunction>

<cffunction name="setModuleID" access="public" output="false">
	<cfargument name="moduleID" type="String" />
	<cfset variables.instance.moduleID = trim(arguments.moduleID) />
</cffunction>

<cffunction name="getRunAt" returntype="String" access="public" output="false">
	<cfreturn variables.instance.runAt />
</cffunction>

<cffunction name="setRunAt" access="public" output="false">
	<cfargument name="runAt" type="String" />
	<cfset variables.instance.runAt = trim(arguments.runAt) />
</cffunction>

<cffunction name="getScriptFile" returntype="String" access="public" output="false">
	<cfreturn variables.instance.scriptFile />
</cffunction>

<cffunction name="setScriptFile" access="public" output="false">
	<cfargument name="scriptFile" type="String" />
	<cfset variables.instance.scriptFile = trim(arguments.scriptFile) />
</cffunction>

<cffunction name="load"  access="public" output="false" returntype="void">
	<cfset set(getQuery()) />
</cffunction>

<cffunction name="getQuery"  access="public" output="false" returntype="query">
	<cfset var rs=""/>
	<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select * from tpluginscripts where scriptID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getScriptID()#">
	</cfquery>
	
	<cfreturn rs/>
</cffunction>

<cffunction name="delete" access="public" returntype="void">
	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tpluginscripts
	where scriptID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getScriptID()#">
	</cfquery>
</cffunction>

<cffunction name="save"  access="public" output="false" returntype="void">
<cfset var rs=""/>
<cfset var rsLocation=""/>
<cfset var pluginXML=""/>
	
	<cfif getQuery().recordcount>
		
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tpluginscripts set
			moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getModuleID()#">,
			runat=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getRunAt()#">,
			scriptFile=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getScriptFile()#">
		where scriptID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getScriptID()#">
		</cfquery>
		
	<cfelse>
	
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			insert into tpluginscripts (scriptID,moduleID,runat,scriptfile) values (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getScriptID()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getModuleID()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getRunAt()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getScriptFile()#">
			)
		</cfquery>
		
	</cfif>
	
</cffunction>

</cfcomponent>