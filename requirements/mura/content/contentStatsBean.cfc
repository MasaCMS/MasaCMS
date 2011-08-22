<cfcomponent extends="mura.bean.bean" output="false">

<cfproperty name="contenID" type="string" default="" required="true" />
<cfproperty name="siteID" type="string" default="" required="true" />
<cfproperty name="views" type="numeric" default="0" required="true" />
<cfproperty name="rating" type="numeric" default="0" required="true" />
<cfproperty name="totalVotes" type="numeric" default="0" required="true" />
<cfproperty name="upVotes" type="numeric" default="0" required="true" />
<cfproperty name="downVotes" type="numeric" default="0" required="true" />
<cfproperty name="comments" type="numeric" default="0" required="true" />

<cffunction name="init" returntype="any" output="false" access="public">
	
	<cfset variables.instance.contentID="" />
	<cfset variables.instance.siteID=""/>
	<cfset variables.instance.views=0/>
	<cfset variables.instance.rating=0/>
	<cfset variables.instance.totalVotes=0/>
	<cfset variables.instance.upVotes=0/>
	<cfset variables.instance.downVotes=0/>
	<cfset variables.instance.comments=0/>
	
	<cfreturn this />
</cffunction>

<cffunction name="setViews" access="public" output="false">
	<cfargument name="views" />
	<cfif isNumeric(arguments.views)>
	<cfset variables.instance.views = arguments.views />
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

<cffunction name="setTotalVotes" access="public" output="false">
	<cfargument name="TotalVotes" />
	<cfif isNumeric(arguments.TotalVotes)>
	<cfset variables.instance.TotalVotes = arguments.TotalVotes />
	</cfif>
</cffunction>

<cffunction name="setUpVotes" access="public" output="false">
	<cfargument name="UpVotes" />
	<cfif isNumeric(arguments.UpVotes)>
	<cfset variables.instance.UpVotes = arguments.UpVotes />
	</cfif>
</cffunction>

<cffunction name="setDownVotes" access="public" output="false">
	<cfargument name="DownVotes" />
	<cfif isNumeric(arguments.DownVotes)>
	<cfset variables.instance.DownVotes = arguments.DownVotes />
	</cfif>
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
	<cfquery name="rs" datasource="#getBean('configBean').getDatasource()#" username="#getBean('configBean').getDBUsername()#" password="#getBean('configBean').getDBPassword()#">
	select * from tcontentstats 
	where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">
	</cfquery>
	
	<cfreturn rs/>
</cffunction>

<cffunction name="delete" access="public" returntype="void">
	<cfquery datasource="#getBean('configBean').getDatasource()#" username="#getBean('configBean').getDBUsername()#" password="#getBean('configBean').getDBPassword()#">
	delete from tcontentstats
	where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">
	</cfquery>
</cffunction>

<cffunction name="save"  access="public" output="false" returntype="void">
<cfset var rs=""/>
	
	
	<cfif getQuery().recordcount>
		
		<cfquery datasource="#getBean('configBean').getDatasource()#" username="#getBean('configBean').getDBUsername()#" password="#getBean('configBean').getDBPassword()#">
		update tcontentstats set
		rating=<cfqueryparam cfsqltype="cf_sql_float" value="#variables.instance.rating#">,
		views=#variables.instance.views#,
		totalVotes=#variables.instance.totalVotes#,
		upVotes=#variables.instance.upVotes#,
		downVotes=#variables.instance.downVotes#,
		comments=#variables.instance.comments#
		where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">
		and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">
		</cfquery>
		
	<cfelse>
	
		<cfquery datasource="#getBean('configBean').getDatasource()#" username="#getBean('configBean').getDBUsername()#" password="#getBean('configBean').getDBPassword()#">
		insert into tcontentstats (contentID,siteID,rating,views,totalVotes,upVotes,downVotes,comments)
		values(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">,
		<cfqueryparam cfsqltype="cf_sql_float" value="#variables.instance.rating#">,
		#variables.instance.views#,
		#variables.instance.totalVotes#,
		#variables.instance.upVotes#,
		#variables.instance.downVotes#,
		#variables.instance.comments#
		)
		</cfquery>
		
	</cfif>
	
</cffunction>

</cfcomponent>