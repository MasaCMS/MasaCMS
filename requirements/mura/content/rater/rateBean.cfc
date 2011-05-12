<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.instance.contentID="" />
<cfset variables.instance.userID=""/>
<cfset variables.instance.siteID=""/>
<cfset variables.instance.entered=now()/>
<cfset variables.instance.rate=0/>
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
				<cfset setContentID(arguments.data.contentID) />
				<cfset setUserID(arguments.data.userID) />
				<cfset setRate(arguments.data.rate) />
				<cfset setEntered(arguments.data.entered) />
				<cfset setSiteID(arguments.data.siteID) />
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

<cffunction name="getContentID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.contentID />
</cffunction>

<cffunction name="setContentID" access="public" output="false">
	<cfargument name="ContentID" type="String" />
	<cfset variables.instance.ContentID = trim(arguments.ContentID) />
</cffunction>

<cffunction name="getUserID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.userID />
</cffunction>

<cffunction name="setUserID" access="public" output="false">
	<cfargument name="userID" type="String" />
	<cfset variables.instance.userID = trim(arguments.userID) />
</cffunction>

<cffunction name="getSiteID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.SiteID />
</cffunction>

<cffunction name="setSiteID" access="public" output="false">
	<cfargument name="SiteID" type="String" />
	<cfset variables.instance.SiteID = trim(arguments.SiteID) />
</cffunction>

<cffunction name="getRate" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.rate />
</cffunction>

<cffunction name="setRate" access="public" output="false">
	<cfargument name="rate" />
	<cfif isNumeric(arguments.rate)>
	<cfset variables.instance.rate = arguments.rate />
	</cfif>
</cffunction>


<cffunction name="getEntered" returntype="string" access="public" output="false">
	<cfreturn variables.instance.entered />
</cffunction>

<cffunction name="setAllValues" returntype="any" access="public" output="false">
	<cfargument name="instance">
	<cfset variables.instance=arguments.instance/>
	<cfreturn this>
</cffunction>

<cffunction name="getAllValues" returntype="any" access="public" output="false">
	<cfreturn variables.instance>
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
	contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getcontentID()#">
	and userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getUserID()#">
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getsiteID()#">
	</cfquery>
	
	<cfreturn rs/>
</cffunction>

<cffunction name="delete" access="public" returntype="void">
	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentratings
	where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getcontentID()#">
	and userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getUserID()#">
	and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getSiteID()#">
	</cfquery>
</cffunction>

<cffunction name="save"  access="public" output="false" returntype="void">
<cfset var rs=""/>
	
	
	<cfif getQuery().recordcount>
		
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tcontentratings set
		rate=#getRate()#,
		entered=#createODBCDateTime(getEntered())#
		where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getcontentID()#">
		and userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getUserID()#">
		and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getSiteID()#">
		</cfquery>
		
	<cfelse>
	
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		insert into tcontentratings (contentID,userID,siteID,rate,entered)
		values(
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getContentID() neq '',de('no'),de('yes'))#" value="#getContentID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getUserID() neq '',de('no'),de('yes'))#" value="#getUserID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSiteID() neq '',de('no'),de('yes'))#" value="#getSiteID()#">,
		#getRate()#,
		#createODBCDateTime(getEntered())#
		)
		</cfquery>
		
	</cfif>
	
</cffunction>

</cfcomponent>