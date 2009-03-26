<cfcomponent name="Application" output="false">

	<cfscript>
	this.name = '#Hash(GetCurrentTemplatePath())#';
	this.applicationTimeout = CreateTimeSpan( 2, 0, 0, 0 );
	this.clientManagement = false;
	this.clientStorage = '';
	this.loginStorage = 'session';
	this.sessionManagement = true;
	this.sessionTimeout = CreateTimeSpan( 0, 0, 30, 0 );
	this.setClientCookies = true;
	this.setDomainCookies = true;
	this.scriptProtect = true;
	</cfscript>

	<cffunction name="onApplicationStart" hint="" output="false" access="public" returntype="boolean">
		<cfreturn true />
	</cffunction>
	
	<cffunction name="onSessionStart" hint="" output="false" access="public" returntype="void">
	</cffunction>

	<cffunction name="onRequestStart" hint="" output="false" access="public" returntype="boolean">
		<cfargument name="theTargetPage" type="String" required="true"/>
		<cfreturn true />
	</cffunction>

	<cffunction name="onRequestEnd" hint="" output="false" access="public" returntype="void">
		<cfargument name="theTargetPage" type="String" required="true"/>
	</cffunction>	
	
	<cffunction name="onSessionEnd" hint="" output="false" access="public" returntype="void">
		<cfargument name="sessionScope" required="true" />
		<cfargument name="applicationScope" required="false" />
	</cffunction>
	
	<cffunction name="onApplicationEnd" hint="" output="false" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="onError" hint="" access="public" returntype="void">
		<cfargument name="theException" required="true" />
   		<cfargument name="theEventName" type="String" required="true" />
		<cfdump var="#arguments.theException#" label="onError Exception Dump">
		<cfdump var="#arguments.theEventName#" label="onError Event Name">
		<cfabort>   	
	</cffunction>
		
</cfcomponent>