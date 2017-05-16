<cfcomponent extends="mura.cfobject" output="false" hint="This handles user login strikes persistence">
<cfset variables.instance.userID="">
<cfset variables.instance.strikes=0>
<cfset variables.instance.lastAttempt="">
<cfset variables.configBean="">
<cfset variables.allowedStrikes=4>
<cfset variables.blockedDuration=10>
<cfset variables.loaded=false>

<cffunction name="init" output="false">
	<cfargument name="username">
	<cfargument name="configBean">
	<cfset setUsername(arguments.username)>
	<cfset variables.configBean=arguments.configBean>
	<cfset variables.allowedStrikes=variables.configBean.getLoginStrikes()>
	<cfset load()>
	<cfreturn this>
</cffunction>

<cffunction name="getQuery" output="false">
	<cfset var rs="">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	select * from tuserstrikes where username=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.username#">
	</cfquery>

	<cfif not rs.recordcount>
		<cfquery>
		insert into tuserstrikes (username,strikes,lastAttempt) values (
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.username#">,
		0,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd("n",-1,now())#">
		)
		</cfquery>

		<cfreturn getQuery()>
	<cfelse>
		<cfreturn rs>
	</cfif>

</cffunction>

<cffunction name="load" output="false">
	<cfset var rs=getQuery()>

	<cfif isDate(rs.lastAttempt) and rs.lastAttempt gte dateAdd("n",-variables.blockedDuration,now())>
		<cfset setLastAttempt(rs.lastAttempt)>
		<cfset setStrikes(rs.strikes)>
	<cfelse>
		<cfset setLastAttempt(dateAdd("n",-1,now()))>
		<cfset setStrikes(0)>
		<cfquery>
		update tuserstrikes set
		strikes=0,
		lastAttempt=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#getLastAttempt()#">
		where username=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getUsername()#">
	</cfquery>
	</cfif>

	<cfset variables.loaded=true>
</cffunction>

<cffunction name="setLastAttempt" output="false">
	<cfargument name="lastAttempt">
	<cfset variables.instance.lastAttempt=arguments.lastAttempt>
</cffunction>

<cffunction name="setStrikes" output="false">
	<cfargument name="strikes">
	<cfset variables.instance.strikes=arguments.strikes>
</cffunction>

<cffunction name="setUsername" output="false">
	<cfargument name="username">
	<cfset variables.instance.username=arguments.username>
</cffunction>

<cffunction name="getLastAttempt" output="false">
	<cfreturn variables.instance.lastAttempt>
</cffunction>

<cffunction name="getStrikes" output="false">
	<cfreturn variables.instance.strikes>
</cffunction>

<cffunction name="getUsername" output="false">
	<cfreturn variables.instance.username>
</cffunction>

<cffunction name="addStrike" output="false">
	<cfquery>
		update tuserstrikes set
		strikes=strikes + 1,
		lastAttempt=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		where username=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getUsername()#">
	</cfquery>

	<cfset load()>
</cffunction>

<cffunction name="isBlocked" output="false">
	<cfreturn getStrikes() gt variables.allowedStrikes >
</cffunction>

<cffunction name="blockedUntil" output="false">
	<cfif isBlocked()>
		<cfreturn dateAdd("n",variables.blockedDuration,getLastAttempt()) >
	<cfelse>
		<cfreturn dateAdd("n",-1,now()) >
	</cfif>
</cffunction>

<cffunction name="clear" output="false">
	<cfquery>
		update tuserstrikes set
		strikes=0,
		lastAttempt=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd("n",-1,now())#">
		where username=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getUsername()#">
	</cfquery>

	<cfset load()>
</cffunction>
</cfcomponent>
