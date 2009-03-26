<cfcomponent extends="mura.cfobject" output="false">

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
<cfset variables.instance.errors=structnew() />

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
				<cfset setFavoriteID(arguments.data.favoriteID) />
				<cfset setUserID(arguments.data.userID) />
				<cfset setFavoriteName(arguments.data.favoriteName) />
				<cfset setFavorite(arguments.data.favorite) />
				<cfset setType(arguments.data.type) />
				<cfset setSiteID(arguments.data.siteID) />
				<cfset setDateCreated(arguments.data.dateCreated) />
				<cfset setColumnNumber(arguments.data.columnNumber) />
				<cfset setRowNumber(arguments.data.rowNumber) />
				<cfset setMaxRSSItems(arguments.data.maxRssItems) />
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

<cffunction name="getFavoriteID" returntype="String" access="public" output="false">
	<cfif not len(variables.instance.favoriteID)>
		<cfset variables.instance.favoriteID = createUUID() />
	</cfif>
	<cfreturn variables.instance.favoriteID />
</cffunction>

<cffunction name="setFavoriteID" access="public" output="false">
	<cfargument name="favoriteID" type="String" />
	<cfset variables.instance.favoriteID = trim(arguments.favoriteID) />
</cffunction>

<cffunction name="getUserID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.userID />
</cffunction>

<cffunction name="setUserID" access="public" output="false">
	<cfargument name="userID" type="String" />
	<cfset variables.instance.userID = trim(arguments.userID) />
</cffunction>

<cffunction name="getFavoriteName" returntype="String" access="public" output="false">
	<cfreturn variables.instance.FavoriteName />
</cffunction>

<cffunction name="setFavoriteName" access="public" output="false">
	<cfargument name="FavoriteName" type="String" />
	<cfset variables.instance.FavoriteName = trim(arguments.FavoriteName) />
</cffunction>

<cffunction name="getFavorite" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Favorite />
</cffunction>

<cffunction name="setFavorite" access="public" output="false">
	<cfargument name="Favorite" type="String" />
	<cfset variables.instance.Favorite = trim(arguments.Favorite) />
</cffunction>

<cffunction name="getType" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Type />
</cffunction>

<cffunction name="setType" access="public" output="false">
	<cfargument name="Type" type="String" />
	<cfset variables.instance.Type = trim(arguments.Type) />
</cffunction>

<cffunction name="getSiteID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.SiteID />
</cffunction>

<cffunction name="setSiteID" access="public" output="false">
	<cfargument name="SiteID" type="String" />
	<cfset variables.instance.SiteID = trim(arguments.SiteID) />
</cffunction>

<cffunction name="getColumnNumber" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.ColumnNumber />
</cffunction>

<cffunction name="setColumnNumber" access="public" output="false">
	<cfargument name="ColumnNumber" />
	<cfif isNumeric(arguments.ColumnNumber)>
	<cfset variables.instance.ColumnNumber = arguments.ColumnNumber />
	</cfif>
</cffunction>

<cffunction name="getRowNumber" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.rowNumber />
</cffunction>

<cffunction name="setRowNumber" access="public" output="false">
	<cfargument name="RowNumber" />
	<cfif isNumeric(arguments.RowNumber)>
	<cfset variables.instance.RowNumber = arguments.RowNumber />
	</cfif>
</cffunction>

<cffunction name="getMaxRSSItems" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.MaxRSSItems />
</cffunction>

<cffunction name="setMaxRSSItems" access="public" output="false">
	<cfargument name="MaxRSSItems" />
	<cfif isNumeric(arguments.MaxRSSItems)>
	<cfset variables.instance.MaxRSSItems = arguments.MaxRSSItems />
	</cfif>
</cffunction>

<cffunction name="getDateCreated" returntype="string" access="public" output="false">
	<cfreturn variables.instance.dateCreated />
</cffunction>

<cffunction name="setDateCreated" access="public" output="false">
	<cfargument name="DateCreated" />
	<cfif isDate(arguments.DateCreated)>
	<cfset variables.instance.DateCreated = arguments.DateCreated />
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
	select * from tusersfavorites where favoriteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getFavoriteID()#">
	</cfquery>
	
	<cfreturn rs/>
</cffunction>

<cffunction name="delete" access="public" returntype="void">
	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tusersfavorites
	where favoriteID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getFavoriteID()#">
	</cfquery>
</cffunction>

<cffunction name="save"  access="public" output="false" returntype="void">
<cfset var rs=""/>
	
	
	<cfif getQuery().recordcount>
		
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tusersfavorites set
		favoriteName=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getFavoriteName() neq '',de('no'),de('yes'))#" value="#getFavoriteName()#">,
		favorite=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getFavorite() neq '',de('no'),de('yes'))#" value="#getFavorite()#">,
		type=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getType() neq '',de('no'),de('yes'))#" value="#getType()#">,
		siteID=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSiteID() neq '',de('no'),de('yes'))#" value="#getSiteID()#">,
		columnNumber=#getColumnNumber()#,
		rowNumber=#getRowNumber()#,
		maxRSSItems=#getMaxRssItems()#,
		dateCreated=#createODBCDateTime(getDateCreated())#
		where favoriteID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getFavoriteID()#">
		</cfquery>
		
	<cfelse>
	
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		insert into tusersfavorites (favoriteID,userID,favoriteName,favorite,type,siteID,columnNumber,rowNumber,maxRSSItems,dateCreated)
		values(
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getFavoriteID() neq '',de('no'),de('yes'))#" value="#getFavoriteID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getUserID() neq '',de('no'),de('yes'))#" value="#getUserID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getFavoriteName() neq '',de('no'),de('yes'))#" value="#getFavoriteName()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getFavorite() neq '',de('no'),de('yes'))#" value="#getFavorite()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getType() neq '',de('no'),de('yes'))#" value="#getType()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSiteID() neq '',de('no'),de('yes'))#" value="#getSiteID()#">,
		#getColumnNumber()#,
		#getRowNumber()#,
		#getMaxRssItems()#,
		#createODBCDateTime(getDateCreated())#
		)
		</cfquery>
		
	</cfif>
	
</cffunction>

</cfcomponent>