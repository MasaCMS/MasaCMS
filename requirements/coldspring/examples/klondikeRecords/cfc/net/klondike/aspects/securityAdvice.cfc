<!--- 
	  
  Copyright (c) 2005, Chris Scott, David Ross
  All rights reserved.
	
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
       http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

  $Id: securityAdvice.cfc,v 1.1 2005/10/09 20:12:06 scottc Exp $
  $Log: securityAdvice.cfc,v $
  Revision 1.1  2005/10/09 20:12:06  scottc
  First commit of the record store example app. Contains a hopefully detailed readme file on usage.

  Revision 1.4  2005/10/09 19:01:32  chris
  Added proper licensing and switched to MethodInterceptor Araound Advice for logging


--->
 
<cfcomponent name="securityAdvice" extends="coldspring.aop.BeforeAdvice">

	<!--- setters for dependencies --->
	<cffunction name="setSecurityService" returntype="void" access="public" output="false" hint="Dependency: security service">
		<cfargument name="securityService" type="net.klondike.service.SecurityService" required="true"/>
		<cfset variables.m_securityService = arguments.securityService />
	</cffunction>
	
	<cffunction name="getSecurityService" returntype="net.klondike.service.SecurityService" access="public" output="false" hint="Dependency: security service">
		<cfreturn variables.m_securityService />
	</cffunction>
	
	<cffunction name="before" access="public" returntype="any">
		<cfargument name="method" type="coldspring.aop.Method" required="true" />
		<cfargument name="args" type="struct" required="true" />
		<cfargument name="target" type="any" required="true" />
		
		<!--- this will throw a SecurityException exception, which will be caught by 
			  mach-ii, you can see that being handled with a redirect in views/exception.cfm --->
		<cfif not variables.m_securityService.hasPermissions()>
			<cfthrow type="SecurityException" message="Access denied. You must be logged in as an editor to add or edit records!">
		</cfif>
		
	</cffunction>
	
</cfcomponent>