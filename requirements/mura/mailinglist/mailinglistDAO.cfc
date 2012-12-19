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

<cffunction name="init" access="public" returntype="any" output="false">
<cfargument name="configBean" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfreturn this />
</cffunction>

<cffunction name="create" returntype="void" access="public" output="false">
<cfargument name="listBean" type="any" />
 
<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
insert into tmailinglist (mlid,name,lastupdate,siteid,isPublic,description,ispurge)
values (
<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listBean.getMLID()#">,
<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.listBean.getName() neq '',de('no'),de('yes'))#" value="#arguments.listBean.getName()#">,
<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.listBean.getSiteID() neq '',de('no'),de('yes'))#" value="#arguments.listBean.getsiteID()#">,
#arguments.listBean.getisPublic()#,
<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.listBean.getDescription() neq '',de('no'),de('yes'))#" value="#arguments.listBean.getDescription()#">,
0)
</cfquery>

</cffunction> 

<cffunction name="read" access="public" output="false" returntype="any" >
	<cfargument name="MLID" type="string" />
	<cfargument name="mailingListBean" default="" />
	<cfset var rs ="" />
	<cfset var bean=arguments.mailinglistBean />
	
	<cfif not isObject(bean)>
		<cfset bean=getBean("mailingList")>
	</cfif>
	
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	Select * from tmailinglist where 
	mlid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MLID#">
	</cfquery>
	
	<cfif rs.recordcount>
		<cfset bean.set(rs) />
		<cfset bean.setIsNew(0)>
	</cfif>
	
	<cfreturn bean />
</cffunction>

<cffunction name="readByName" access="public" output="false" returntype="any" >
	<cfargument name="name" type="string" />
	<cfargument name="mailingListBean" default="" />
	<cfset var rs ="" />
	<cfset var beanArray=arrayNew(1)>
	<cfset var bean=arguments.mailinglistBean />
	<cfset var utility=""/>
	<cfif not isObject(bean)>
		<cfset bean=getBean("mailingList")>
	</cfif>
	
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	Select * from tmailinglist where 
	name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">
	and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
	</cfquery>
	
	<cfif rs.recordcount gt 1>
		<cfset utility=getBean("utility")>
		<cfloop query="rs">
			<cfset bean=getBean("mailingList").set(utility.queryRowToStruct(rs,rs.currentrow))>
			<cfset bean.setIsNew(0)>
			<cfset arrayAppend(beanArray,bean)>		
		</cfloop>
		<cfreturn beanArray>
	<cfelseif rs.recordcount>
		<cfset bean.set(rs) />
		<cfset bean.setIsNew(0)>
	<cfelse>
		<cfset bean.setSiteID(arguments.siteID) />
	</cfif>
	
	<cfreturn bean />
</cffunction>

<cffunction name="update" access="public" output="false" returntype="void" >
	<cfargument name="listBean" type="any" />
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tmailinglist set name=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.listBean.getName() neq '',de('no'),de('yes'))#" value="#arguments.listBean.getName()#">,
	lastupdate=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
	isPublic=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.listBean.getIsPublic()#">,
	description=<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.listBean.getDescription() neq '',de('no'),de('yes'))#" value="#arguments.listBean.getDescription()#">
	where mlid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listBean.getMLID()#"> and
	siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listBean.getSiteID()#">
	</cfquery>

</cffunction>

<cffunction name="delete" access="public" output="false" returntype="void" >
	<cfargument name="mlid" type="string" />
	<cfargument name="siteid" type="string" />
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tmailinglist where mlid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mlid#"> and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#">
	</cfquery>

</cffunction>

<cffunction name="deleteMembers" access="public" output="false" returntype="void" >
	<cfargument name="mlid" type="string" />
	<cfargument name="siteid" type="string" />

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tmailinglistmembers where mlid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mlid#"> and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#">
	</cfquery>

</cffunction>
</cfcomponent>
