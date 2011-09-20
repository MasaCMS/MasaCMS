<!---
	  
  Copyright (c) 2005, Chris Scott, David Ross, Kurt Wiersma, Sean Corfield
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

 $Id: RegexMethodPointcut.cfc,v 1.1 2006/07/07 02:24:40 scottc Exp $
 $Log: RegexMethodPointcut.cfc,v $
 Revision 1.1  2006/07/07 02:24:40  scottc
 CSP-65: First commit for RegexMethodPointcut/Advisor. I'm gonna play with it and do a little catching of bat patters, but then again, the exception passes through good enough right now and is readable.Ê

 Revision 1.8  2005/11/16 16:16:10  rossd
 updates to license in all framework code

 Revision 1.7  2005/11/01 03:48:21  scottc
 Some fixes to around advice as well as isRunnable in Method class so that advice cannot directly call method.proceed(). also some unitTests

 Revision 1.6  2005/10/09 22:45:24  scottc
 Forgot to add Dave to AOP license

	
---> 
 
<cfcomponent name="RegexMethodPointcut" 
			displayname="RegexMethodPointcut" 
			extends="coldspring.aop.Pointcut" 
			hint="Pointcut to match method names (with regex)" 
			output="false">
			
	<cfset variables.pattern = 0 />
	
	<cffunction name="init" access="public" returntype="coldspring.aop.Pointcut" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setPattern" access="public" returntype="void" output="false">
		<cfargument name="pattern" type="string" required="true" />
		<cfset variables.pattern = arguments.pattern />
	</cffunction>
	
	<cffunction name="getPattern" access="public" returntype="string" output="false">
		<cfreturn variables.pattern />
	</cffunction>
	
	<cffunction name="matches" access="public" returntype="boolean" output="true">
		<cfargument name="methodName" type="string" required="true" />
		<cfset var mappedName = '' />
		<cfset var ix = 0 />
		
		<cfif len(variables.pattern)>
			<cfreturn REFind(variables.pattern,arguments.methodName) GT 0 />
		<cfelse>
			<cfthrow type="coldspring.aop.InvalidRegexPattern" 
					message="You must provide the RegexMethodPointcut with a regex pattern. Use '*' of you would like to match all methods!" />
		</cfif>
	</cffunction>
				
</cfcomponent>