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

<cfproperty name="scriptID" type="string" default="" required="true" />
<cfproperty name="moduleID" type="string" default="" required="true" />
<cfproperty name="runAt" type="string" default="" required="true" />
<cfproperty name="scriptFile" type="string" default="" required="true" />
<cfproperty name="doCache" type="boolean" default="false" required="true" />

<cffunction name="init" returntype="any" output="false" access="public">
	<cfset super.init(argumentCollection=arguments)>
	
	<cfset variables.instance.scriptID="" />
	<cfset variables.instance.moduleID=""/>
	<cfset variables.instance.runat=""/>
	<cfset variables.instance.scriptfile=""/>
	<cfset variables.instance.docache="false"/>
	
	<cfreturn this />
</cffunction>
  

<cffunction name="getScriptID" returntype="String" access="public" output="false">
	<cfif not len(variables.instance.scriptID)>
		<cfset variables.instance.scriptID = createUUID() />
	</cfif>
	<cfreturn variables.instance.scriptID />
</cffunction>

<cffunction name="setDoCache" access="public" output="false">
	<cfargument name="docache" type="String" />
	<cfif isBoolean(arguments.docache)>
		<cfset variables.instance.docache = arguments.docache />
	</cfif>
</cffunction>

<cffunction name="load"  access="public" output="false" returntype="void">
	<cfset set(getQuery()) />
</cffunction>

<cffunction name="getQuery"  access="public" output="false" returntype="query">
	<cfset var rs=""/>
	<cfquery name="rs" datasource="#getBean('configBean').getDatasource()#" username="#getBean('configBean').getDBUsername()#" password="#getBean('configBean').getDBPassword()#">
	select scriptID, moduleID, scriptfile, runat, docache from tpluginscripts where scriptID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getScriptID()#">
	</cfquery>
	
	<cfreturn rs/>
</cffunction>

<cffunction name="delete" access="public" returntype="void">
	<cfquery datasource="#getBean('configBean').getDatasource()#" username="#getBean('configBean').getDBUsername()#" password="#getBean('configBean').getDBPassword()#">
	delete from tpluginscripts
	where scriptID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getScriptID()#">
	</cfquery>
</cffunction>

<cffunction name="save"  access="public" output="false" returntype="void">
<cfset var rs=""/>
<cfset var rsLocation=""/>
<cfset var pluginXML=""/>
	
	<cfif getQuery().recordcount>
		
		<cfquery datasource="#getBean('configBean').getDatasource()#" username="#getBean('configBean').getDBUsername()#" password="#getBean('configBean').getDBPassword()#">
		update tpluginscripts set
			moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.moduleID#">,
			runat=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.runAt#">,
			scriptFile=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.scriptFile#">,
			docache=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.doCache#">
		where scriptID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getScriptID()#">
		</cfquery>
		
	<cfelse>
	
		<cfquery datasource="#getBean('configBean').getDatasource()#" username="#getBean('configBean').getDBUsername()#" password="#getBean('configBean').getDBPassword()#">
			insert into tpluginscripts (scriptID,moduleID,runat,scriptfile,docache) values (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getScriptID()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.moduleID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.runAt#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.scriptFile#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.doCache#">
			)
		</cfquery>
		
	</cfif>
	
</cffunction>

</cfcomponent>