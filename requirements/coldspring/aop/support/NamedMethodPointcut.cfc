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

 $Id: NamedMethodPointcut.cfc,v 1.8 2005/11/16 16:16:10 rossd Exp $
 $Log: NamedMethodPointcut.cfc,v $
 Revision 1.8  2005/11/16 16:16:10  rossd
 updates to license in all framework code

 Revision 1.7  2005/11/01 03:48:21  scottc
 Some fixes to around advice as well as isRunnable in Method class so that advice cannot directly call method.proceed(). also some unitTests

 Revision 1.6  2005/10/09 22:45:24  scottc
 Forgot to add Dave to AOP license

	
---> 
 
<cfcomponent name="NamedMethodPointcutAdvisor" 
			displayname="NamedMethodPointcutAdvisor" 
			extends="coldspring.aop.Pointcut" 
			hint="Pointcut to match method names (with wildcard)" 
			output="false">
			
	<cfset variables.mappedNames = 0 />
	
	<cffunction name="init" access="public" returntype="coldspring.aop.support.NamedMethodPointcut" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setMappedName" access="public" returntype="void" output="false">
		<cfargument name="mappedName" type="string" required="true" />
		<cfset setMappedNames(arguments.mappedName) />
	</cffunction>
	
	<cffunction name="setMappedNames" access="public" returntype="void" output="false">
		<cfargument name="mappedNames" type="string" required="true" />
		<cfset var name = '' />
		<cfset variables.mappedNames = ArrayNew(1) />
		<cfloop list="#arguments.mappedNames#" index="name">
			<cfset ArrayAppend(variables.mappedNames, name) />
		</cfloop>
	</cffunction>
	
	<cffunction name="matches" access="public" returntype="boolean" output="true">
		<cfargument name="methodName" type="string" required="true" />
		<cfset var mappedName = '' />
		<cfset var ix = 0 />
		
		<cfif isArray(variables.mappedNames) and ArrayLen(variables.mappedNames)>
			<cfloop from="1" to="#ArrayLen(variables.mappedNames)#" index="ix">
				<cfset mappedName = variables.mappedNames[ix] />
				<cfif (arguments.methodName EQ mappedName) OR
					  isMatch(arguments.methodName, mappedName) >
					<cfreturn true />	  
				</cfif>
			</cfloop>
			<cfreturn false />
		<cfelse>
			<cfthrow type="coldspring.aop.InvalidMappedNames" message="You must provide the NamedMethodPointcutAdvisor with a list of method names to match. Use '*' of you would like to match all methods!" />
		</cfif>
	</cffunction>
			
	<cffunction name="isMatch" access="private" returntype="boolean" output="true">
		<cfargument name="methodName" type="string" required="true" />
		<cfargument name="mappedName" type="string" required="true" />
		<cfif mappedName EQ "*">
			<cfreturn true />
		<cfelseif mappedName.startsWith('*')>
			<cfreturn methodName.endsWith(Right(mappedName,mappedName.length()-1)) />
		<cfelseif mappedName.endsWith('*')>
			<cfreturn methodName.startsWith(Left(mappedName, mappedName.length()-1)) />
		</cfif>
		<cfreturn false />
	</cffunction>
				
</cfcomponent>