<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.instance.contentID="" />
<cfset variables.instance.siteID=""/>
<cfset variables.instance.views=0/>
<cfset variables.instance.rating=0/>
<cfset variables.instance.totalVotes=0/>
<cfset variables.instance.upVotes=0/>
<cfset variables.instance.downVotes=0/>
<cfset variables.instance.comments=0/>
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
				<cfset setContentID(arguments.data.ContentID) />
				<cfset setSiteID(arguments.data.siteID) />
				<cfset setViews(arguments.data.views) />
				<cfset setRating(arguments.data.rating) />
				<cfset setTotalVotes(arguments.data.totalVotes) />
				<cfset setUpVotes(arguments.data.upVotes) />
				<cfset setDownVotes(arguments.data.downVotes) />
				<cfset setComments(arguments.data.comments) />
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

<cffunction name="getSiteID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.SiteID />
</cffunction>

<cffunction name="setSiteID" access="public" output="false">
	<cfargument name="SiteID" type="String" />
	<cfset variables.instance.SiteID = trim(arguments.SiteID) />
</cffunction>

<cffunction name="getViews" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.views />
</cffunction>

<cffunction name="setViews" access="public" output="false">
	<cfargument name="views" />
	<cfif isNumeric(arguments.views)>
	<cfset variables.instance.ColumnNumber = arguments.views />
	</cfif>
</cffunction>

<cffunction name="getRating" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.rating />
</cffunction>

<cffunction name="setRating" access="public" output="false">
	<cfargument name="rating" />
	<cfif isNumeric(arguments.rating)>
	<cfset variables.instance.rating = arguments.rating />
	</cfif>
</cffunction>

<cffunction name="getTotalVotes" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.TotalVotes />
</cffunction>

<cffunction name="setTotalVotes" access="public" output="false">
	<cfargument name="TotalVotes" />
	<cfif isNumeric(arguments.TotalVotes)>
	<cfset variables.instance.TotalVotes = arguments.TotalVotes />
	</cfif>
</cffunction>

<cffunction name="getUpVotes" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.UpVotes />
</cffunction>

<cffunction name="setUpVotes" access="public" output="false">
	<cfargument name="UpVotes" />
	<cfif isNumeric(arguments.UpVotes)>
	<cfset variables.instance.UpVotes = arguments.UpVotes />
	</cfif>
</cffunction>

<cffunction name="getDownVotes" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.DownVotes />
</cffunction>

<cffunction name="setDownVotes" access="public" output="false">
	<cfargument name="DownVotes" />
	<cfif isNumeric(arguments.DownVotes)>
	<cfset variables.instance.DownVotes = arguments.DownVotes />
	</cfif>
</cffunction>

<cffunction name="getComments" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.Comments />
</cffunction>

<cffunction name="setComments" access="public" output="false">
	<cfargument name="Comments" />
	<cfif isNumeric(arguments.Comments)>
	<cfset variables.instance.Comments = arguments.Comments />
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
	select * from tcontentstats 
	where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getContentID()#">
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getSiteID()#">
	</cfquery>
	
	<cfreturn rs/>
</cffunction>

<cffunction name="delete" access="public" returntype="void">
	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentstats
	where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getContentID()#">
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getSiteID()#">
	</cfquery>
</cffunction>

<cffunction name="save"  access="public" output="false" returntype="void">
<cfset var rs=""/>
	
	
	<cfif getQuery().recordcount>
		
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tcontentstats set
		rating=<cfqueryparam cfsqltype="cf_sql_float" value="#getRating()#">,
		views=#getViews()#,
		totalVotes=#getTotalVotes()#,
		upVotes=#getUpVotes()#,
		downVotes=#getDownVotes()#,
		comments=#getComments()#
		where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getContentID()#">
		and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getSiteID()#">
		</cfquery>
		
	<cfelse>
	
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		insert into tcontentstats (contentID,siteID,rating,views,totalVotes,upVotes,downVotes,comments)
		values(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#getContentID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#getSiteID()#">,
		<cfqueryparam cfsqltype="cf_sql_float" value="#getRating()#">,
		#getViews()#,
		#getTotalVotes()#,
		#getUpVotes()#,
		#getDownVotes()#,
		#getComments()#
		)
		</cfquery>
		
	</cfif>
	
</cffunction>

</cfcomponent>