<cfcomponent extends="mura.bean.bean" output="false">

<cfproperty name="contentID" type="string" default="" required="true" />
<cfproperty name="userID" type="string" default="" required="true" />
<cfproperty name="siteID" type="string" default="" required="true" />
<cfproperty name="entered" type="date" default="" required="true" />
<cfproperty name="rate" type="numeric" default="0" required="true" />
	
<cffunction name="init" returntype="any" output="false" access="public">
	
	<cfset super.init(argumentCollection=arguments)>
	
	<cfset variables.instance.contentID="" />
	<cfset variables.instance.userID=""/>
	<cfset variables.instance.siteID=""/>
	<cfset variables.instance.entered=now()/>
	<cfset variables.instance.rate=0/>

	<cfreturn this />
</cffunction>

<cffunction name="setConfigBean">
	<cfargument name="configBean">
	<cfset variables.configBean=arguments.configBean>
	<cfreturn this>
</cffunction>

<cffunction name="getRate" access="public" output="false">
	<cfif not isNumeric(variables.instance.rate)>
		<cfset variables.instance.rate = 0 />
	</cfif>
	<cfreturn variables.instance.rate>
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
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	select * from tcontentratings where 
	contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">
	and userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.userID#">
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">
	</cfquery>
	
	<cfreturn rs/>
</cffunction>

<cffunction name="delete" access="public" returntype="void">
	<cfquery>
	delete from tcontentratings
	where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">
	and userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.userID#">
	and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">
	</cfquery>
</cffunction>

<cffunction name="save"  access="public" output="false" returntype="void">
<cfset var rs=""/>
	
	<cfif getQuery().recordcount>
		
		<cfquery>
		update tcontentratings set
		rate=#getRate()#,
		entered=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#variables.instance.entered#">
		where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">
		and userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.userID#">
		and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">
		</cfquery>
		
	<cfelse>
	
		<cfquery>
		insert into tcontentratings (contentID,userID,siteID,rate,entered)
		values(
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.contentID neq '',de('no'),de('yes'))#" value="#variables.instance.contentID#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.userID neq '',de('no'),de('yes'))#" value="#variables.instance.userID#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.siteID neq '',de('no'),de('yes'))#" value="#variables.instance.siteID#">,
		#getRate()#,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#variables.instance.entered#">
		)
		</cfquery>
		
	</cfif>
	
</cffunction>

</cfcomponent>