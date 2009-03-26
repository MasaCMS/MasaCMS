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

<cffunction name="init" returntype="any" output="false" access="public">
<cfargument name="configBean" type="any" required="yes"/>
	<cfset variables.instance.configBean=arguments.configBean />
	<cfreturn this />
</cffunction>

<cffunction name="getBean" access="public" returntype="any">
	<cfreturn createObject("component","#variables.instance.configBean.getMapDir()#.advertising.adZone.adZoneBean").init()>
</cffunction>

<cffunction name="create" returntype="void" access="public" output="false">
	<cfargument name="adZoneBean" type="any" />
	 
	<cfquery datasource="#variables.instance.configBean.getDatasource()#" username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	insert into tadzones (adZoneID,siteid,dateCreated, lastupdate,lastupdateBy,name,creativeType,notes,isActive,height,width)
	values (
	'#arguments.adZoneBean.getAdZoneID()#',
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.adZoneBean.getSiteID() neq '',de('no'),de('yes'))#" value="#arguments.adZoneBean.getsiteID()#">,
	<cfif isDate(arguments.adZoneBean.getDateCreated()) >#createODBCDateTime(arguments.adZoneBean.getDateCreated())#<cfelse>null</cfif>,
	<cfif isDate(arguments.adZoneBean.getLastUpdate()) >#createODBCDateTime(arguments.adZoneBean.getLastUpdate())#<cfelse>null</cfif>,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.adZoneBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.adZoneBean.getLastUpdateBy()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.adZoneBean.getName() neq '',de('no'),de('yes'))#" value="#arguments.adZoneBean.getName()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.adZoneBean.getCreativeType() neq '',de('no'),de('yes'))#" value="#arguments.adZoneBean.getCreativeType()#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.adZoneBean.getNotes() neq '',de('no'),de('yes'))#" value="#arguments.adZoneBean.getNotes()#">,
	#arguments.adZoneBean.getIsActive()#,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(arguments.adZoneBean.getHeight()),de(arguments.adZoneBean.getHeight()),de(0))#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(arguments.adZoneBean.getWidth()),de(arguments.adZoneBean.getWidth()),de(0))#">
	)
	</cfquery>

</cffunction> 

<cffunction name="read" access="public" output="false" returntype="any" >
	<cfargument name="AdZoneID" type="string" />

	<cfset var adZoneBean=getBean() />
	<cfset var rs ="" />
	
	<cfquery name="rs" datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	Select * from tadzones where 
	adZoneID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.adZoneID#" />
	</cfquery>
	
	<cfif rs.recordcount>
	<cfset adZoneBean.set(rs) />
	</cfif>
	
	<cfreturn adZoneBean />
</cffunction>

<cffunction name="update" access="public" output="false" returntype="void" >
	<cfargument name="adZoneBean" type="any" />
	
	<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	update tadzones set
	lastUpdate = <cfif isDate(arguments.adZoneBean.getLastUpdate()) >#createODBCDateTime(arguments.adZoneBean.getLastUpdate())#<cfelse>null</cfif>,
	lastupdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.adZoneBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.adZoneBean.getLastUpdateBy()#">,
	name = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.adZoneBean.getName() neq '',de('no'),de('yes'))#" value="#arguments.adZoneBean.getName()#">,
	creativeType = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.adZoneBean.getCreativeType() neq '',de('no'),de('yes'))#" value="#arguments.adZoneBean.getCreativeType()#">,
	isActive = #arguments.adZoneBean.getIsActive()#,
	notes= <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.adZoneBean.getNotes() neq '',de('no'),de('yes'))#" value="#arguments.adZoneBean.getNotes()#">,
	height = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(arguments.adZoneBean.getHeight()),de(arguments.adZoneBean.getHeight()),de(0))#">,
	width = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(arguments.adZoneBean.getWidth()),de(arguments.adZoneBean.getWidth()),de(0))#">
	where adZoneID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.adZoneBean.getAdZoneID()#" />
	</cfquery>

</cffunction>

<cffunction name="delete" access="public" output="false" returntype="void" >
	<cfargument name="adZoneID" type="String" />
	
	<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	delete from tadzones 
	where adZoneID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.adZoneID#" />
	</cfquery>

</cffunction>

</cfcomponent>