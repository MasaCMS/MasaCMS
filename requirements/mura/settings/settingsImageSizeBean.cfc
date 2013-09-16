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
 
<cfproperty name="siteID" type="string" default="" required="true" />
<cfproperty name="sizeID" type="string" default="" required="true" />
<cfproperty name="name" type="string" default="" required="true" />
<cfproperty name="height" type="string" default="AUTO" required="true" />
<cfproperty name="width" type="string" default="AUT0" required="true" />
<cfproperty name="isNew" type="numeric" default="1" required="true" />

<cffunction name="init" returntype="any" output="false" access="public">
	
	<cfset super.init(argumentCollection=arguments)>
	
	<cfset variables.instance.siteID=""/>
	<cfset variables.instance.name=""/>
	<cfset variables.instance.sizeID=createUUID()/>
	<cfset variables.instance.width="AUTO"/>
	<cfset variables.instance.height="AUTO"/>
	<cfset variables.instance.isNew=1/>

	<cfset variables.primaryKey = 'sizeid'>
	<cfset variables.entityName = 'imageSize'>

	<cfreturn this>
</cffunction>

<cffunction name="setConfigBean" output="false">
	<cfargument name="configBean">
	<cfset variables.configBean=arguments.configBean>
	<cfreturn this>
</cffunction>

<cffunction name="setHeight" output="false">
<cfargument name="height">
	<cfif isNumeric(arguments.height) or arguments.height eq "AUTO">
		<cfset variables.instance.height=arguments.height>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setWidth" output="false">
<cfargument name="width">
	<cfif isNumeric(arguments.width) or arguments.width eq "AUTO">
		<cfset variables.instance.width=arguments.width>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="loadBy" access="public" output="false">
	<cfargument name="sizeID">
	<cfargument name="name">
	<cfargument name="siteID" default="#variables.instance.siteID#">
	
	<cfset variables.instance.isNew=1/>
	<cfset var rs=getQuery(argumentCollection=arguments)>

	<cfif rs.recordcount>
		<cfset set(rs) />
		<cfset variables.instance.isNew=0/>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="getQuery"  access="public" output="false" returntype="query">


	<cfset var rs=""/>
	<cfquery name="rs" cachedwithin="#createTimeSpan(0, 0, 0, 1)#" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select * from timagesizes 
	where
	<cfif structKeyExists(arguments,'sizeid')>
	sizeid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sizeID#">
	<cfelseif structKeyExists(arguments,"name") and structKeyExists(arguments,"siteid")>
	name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">
	and 
	siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
	<cfelse>
	sizeid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.sizeID#">
	</cfif>
	
	</cfquery>
	
	<cfreturn rs/>
</cffunction>

<cffunction name="save"  access="public" output="false">
	<cfset var rs=""/>

	<cfif getQuery().recordcount>
		
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update timagesizes set
		siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">,
		name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getBean('contentUtility').formatFilename(variables.instance.name)#">,
		height=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.height#">,
		width=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.width#">
		where sizeid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.sizeID#">
		</cfquery>
		
	<cfelse>
		
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		insert into timagesizes (sizeid,siteid,name,height,width) values(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.sizeID#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#getBean('contentUtility').formatFilename(variables.instance.name)#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.height#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.width#">
		)
		</cfquery>

	</cfif>

	<cfset variables.instance.isNew=0/>

	<cfreturn this>
</cffunction>

<cffunction name="delete"  access="public" output="false">

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from timagesizes 
		where sizeid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.sizeID#">
	</cfquery>
	
	<cfset variables.instance.isNew=1/>

	<cfreturn this>
</cffunction>

</cfcomponent>