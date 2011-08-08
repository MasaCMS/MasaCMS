<cfcomponent extends="mura.bean.bean" output="false">

<cfproperty name="contentID" type="string" default="" required="true" />
<cfproperty name="userID" type="string" default="" required="true" />
<cfproperty name="siteID" type="string" default="" required="true" />
<cfproperty name="entered" type="date" default="" required="true" />
<cfproperty name="rate" type="numeric" default="0" required="true" />
	
<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="configBean">
	
	<cfset super.init(argumentCollection=arguments)>
	
	<cfset variables.configBean=arguments.configBean />
	<cfset variables.dsn=variables.configBean.getDatasource()/>
	
	<cfset variables.instance.contentID="" />
	<cfset variables.instance.userID=""/>
	<cfset variables.instance.siteID=""/>
	<cfset variables.instance.entered=now()/>
	<cfset variables.instance.rate=0/>

	<cfreturn this />
</cffunction>

<cffunction name="setRate" access="public" output="false">
	<cfargument name="rate" />
	<cfif isNumeric(arguments.rate)>
	<cfset variables.instance.rate = arguments.rate />
	</cfif>
</cffunction>

<cffunction name="setEntered" access="public" output="false">
	<cfargument name="entered" />
	<cfif isDate(arguments.entered)>
	<cfset variables.instance.entered = arguments.entered />
	</cfif>
</cffunction>

<cffunction name="load"  access="public" output="false" returntype="void">
	<cfset var rs=getQuery()>
	<cfif rs.recordcount>
		<cfset set(rs) />
	</cfif>
</cffunction>

<cffunction name="getQuery"  access="public" output="false" returntype="query">
	<cfset var rs=""/>
	<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select * from tcontentratings where 
	contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">
	and userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.userID#">
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">
	</cfquery>
	
	<cfreturn rs/>
</cffunction>

<cffunction name="delete" access="public" returntype="void">
	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentratings
	where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">
	and userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.userID#">
	and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">
	</cfquery>
</cffunction>

<cffunction name="save"  access="public" output="false" returntype="void">
<cfset var rs=""/>
	
	<cfif getQuery().recordcount>
		
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tcontentratings set
		rate=#variables.instance.rate#,
		entered=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#variables.instance.entered#">
		where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">
		and userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.userID#">
		and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">
		</cfquery>
		
	<cfelse>
	
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		insert into tcontentratings (contentID,userID,siteID,rate,entered)
		values(
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.contentID neq '',de('no'),de('yes'))#" value="#variables.instance.contentID#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.userID neq '',de('no'),de('yes'))#" value="#variables.instance.userID#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.siteID neq '',de('no'),de('yes'))#" value="#variables.instance.siteID#">,
		#variables.instance.rate#,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#variables.instance.entered#">
		)
		</cfquery>
		
	</cfif>
	
</cffunction>

</cfcomponent>