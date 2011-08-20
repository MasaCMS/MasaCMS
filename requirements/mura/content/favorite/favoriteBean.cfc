<cfcomponent extends="mura.bean.bean" output="false">

<cfproperty name="favoriteID" type="string" default="" required="true" />
<cfproperty name="userID" type="string" default="" required="true" />
<cfproperty name="favoriteName" type="string" default="" required="true" />
<cfproperty name="favorite" type="string" default="" required="true" />
<cfproperty name="type" type="string" default="" required="true" />
<cfproperty name="siteID" type="string" default="" required="true" />
<cfproperty name="dateCreated" type="date" default="" required="true" />
<cfproperty name="columnNumber" type="numeric" default="0" required="true" />
<cfproperty name="rowNumber" type="numeric" default="0" required="true" />
<cfproperty name="maxRSSItems" type="numeric" default="0" required="true" />
<cfproperty name="isNew" type="numeric" default="1" required="true" />

<cffunction name="init" returntype="any" output="false" access="public">
	<cfset super.init(argumentCollection=arguments)>
	
	<cfset variables.instance.favoriteID="" />
	<cfset variables.instance.userID=""/>
	<cfset variables.instance.favoriteName=""/>
	<cfset variables.instance.favorite=""/>
	<cfset variables.instance.type=""/>
	<cfset variables.instance.siteID=""/>
	<cfset variables.instance.dateCreated=now()/>
	<cfset variables.instance.columnNumber=0/>
	<cfset variables.instance.rowNumber=0/>
	<cfset variables.instance.maxRSSItems=0/>
	<cfset variables.instance.isNew=1/>
	
	<cfreturn this />
</cffunction>

<cffunction name="getFavoriteID" returntype="String" access="public" output="false">
	<cfif not len(variables.instance.favoriteID)>
		<cfset variables.instance.favoriteID = createUUID() />
	</cfif>
	<cfreturn variables.instance.favoriteID />
</cffunction>

<cffunction name="setColumnNumber" access="public" output="false">
	<cfargument name="ColumnNumber" />
	<cfif isNumeric(arguments.ColumnNumber)>
	<cfset variables.instance.ColumnNumber = arguments.ColumnNumber />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setRowNumber" access="public" output="false">
	<cfargument name="RowNumber" />
	<cfif isNumeric(arguments.RowNumber)>
	<cfset variables.instance.RowNumber = arguments.RowNumber />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMaxRSSItems" access="public" output="false">
	<cfargument name="MaxRSSItems" />
	<cfif isNumeric(arguments.MaxRSSItems)>
	<cfset variables.instance.MaxRSSItems = arguments.MaxRSSItems />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setDateCreated" access="public" output="false">
	<cfargument name="DateCreated" />
	<cfif isDate(arguments.DateCreated)>
	<cfset variables.instance.DateCreated = arguments.DateCreated />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="load"  access="public" output="false" returntype="void">
	<cfset var rs=getQuery(argumentcollection=arguments)>
	<cfif rs.recordcount>
		<cfset set(rs) />
	</cfif>
</cffunction>

<cffunction name="loadBy" returnType="any" output="false" access="public">
	<cfset var response="">
	
	<cfif not structKeyExists(arguments,"siteID")>
		<cfset arguments.siteID=variables.instance.siteID>
	</cfif>
	
	<cfif not structKeyExists(arguments,"userID")>
		<cfset arguments.userID=variables.instance.userID>
	</cfif>
	
	<cfset load(argumentCollection=arguments)>
	<cfreturn this>
</cffunction>

<cffunction name="getQuery"  access="public" output="false" returntype="query">
	<cfset var rs=""/>
	<cfquery name="rs" datasource="#getBean("configBean").getDatasource()#" username="#getBean("configBean").getDBUsername()#" password="#getBean("configBean").getDBPassword()#">
	select * from tusersfavorites 
	where 
	<cfif structKeyExists(arguments,"favoriteID")>
	favoriteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.favoriteID#">
	<cfelseif structKeyExists(arguments,"favorite")>
		siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">
		and favorite=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.favorite#">
		<cfif structKeyExists(arguments,"userID")>
			and userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
		<cfelse>
			and userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.userID#">
		</cfif>
	<cfelse>
	favoriteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getFavoriteID()#">
	</cfif>
	</cfquery>
	
	<cfreturn rs/>
</cffunction>

<cffunction name="delete" access="public" returntype="void">
	<cfquery datasource="#getBean("configBean").getDatasource()#" username="#getBean("configBean").getDBUsername()#" password="#getBean("configBean").getDBPassword()#">
	delete from tusersfavorites
	where favoriteID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getFavoriteID()#">
	</cfquery>
</cffunction>

<cffunction name="save"  access="public" output="false" returntype="void">
	<cfset var rs=""/>

	<cfif getQuery().recordcount>
		
		<cfquery datasource="#getBean("configBean").getDatasource()#" username="#getBean("configBean").getDBUsername()#" password="#getBean("configBean").getDBPassword()#">
		update tusersfavorites set
		favoriteName=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.favoriteName neq '',de('no'),de('yes'))#" value="#variables.instance.favoriteName#">,
		favorite=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.favorite neq '',de('no'),de('yes'))#" value="#variables.instance.favorite#">,
		type=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.type neq '',de('no'),de('yes'))#" value="#variables.instance.type#">,
		siteID=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.siteID neq '',de('no'),de('yes'))#" value="#variables.instance.siteID#">,
		columnNumber=#variables.instance.columnNumber#,
		rowNumber=#variables.instance.rowNumber#,
		maxRSSItems=#variables.instance.maxRssItems#,
		dateCreated=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#variables.instance.dateCreated#">
		where favoriteID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getFavoriteID()#">
		</cfquery>
		
	<cfelse>
	
		<cfquery datasource="#getBean("configBean").getDatasource()#" username="#getBean("configBean").getDBUsername()#" password="#getBean("configBean").getDBPassword()#">
		insert into tusersfavorites (favoriteID,userID,favoriteName,favorite,type,siteID,columnNumber,rowNumber,maxRSSItems,dateCreated)
		values(
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getFavoriteID() neq '',de('no'),de('yes'))#" value="#getFavoriteID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.userID neq '',de('no'),de('yes'))#" value="#variables.instance.userID#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.favoriteName neq '',de('no'),de('yes'))#" value="#variables.instance.favoriteName#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.favorite neq '',de('no'),de('yes'))#" value="#variables.instance.favorite#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.type neq '',de('no'),de('yes'))#" value="#variables.instance.type#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.siteID neq '',de('no'),de('yes'))#" value="#variables.instance.siteID#">,
		#variables.instance.columnNumber#,
		#variables.instance.rowNumber#,
		#variables.instance.maxRssItems#,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#variables.instance.dateCreated#">
		)
		</cfquery>
		
	</cfif>
	
</cffunction>

<cffunction name="getFavoritesByUser" returntype="any" access="public" output="false">
	<cfargument name="userID">
	<cfargument name="type">
	<cfreturn variables.instance>
</cffunction>

<cffunction name="getUsersByFavorite" returntype="any" access="public" output="false">
	<cfargument name="favorite">
	<cfargument name="type">
	<cfreturn variables.instance>
</cffunction>

</cfcomponent>