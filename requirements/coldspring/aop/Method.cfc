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

  $Id: Method.cfc,v 1.10 2005/11/17 19:59:38 scottc Exp $
  $Log: Method.cfc,v $
  Revision 1.10  2005/11/17 19:59:38  scottc
  tweeked aopProxyBean and Method to make the setRunnable a package method

  Revision 1.9  2005/11/16 16:16:10  rossd
  updates to license in all framework code

  Revision 1.8  2005/11/01 03:48:21  scottc
  Some fixes to around advice as well as isRunnable in Method class so that advice cannot directly call method.proceed(). also some unitTests

  Revision 1.7  2005/10/10 18:40:10  scottc
  Lots of fixes pertaining to returning and not returning values with afterAdvice, also added the security for method invocation that we discussed

  Revision 1.6  2005/10/09 22:45:24  scottc
  Forgot to add Dave to AOP license


---> 
 
<cfcomponent name="Methood" 
			displayname="Methood" 
			hint="Base Class for Methods" 
			output="false">
			
	<cffunction name="init" access="public" returntype="coldspring.aop.Method" output="false">
		<cfargument name="target" type="any" required="true" />
		<cfargument name="method" type="string" required="true" />
		<cfargument name="args" type="struct" required="true" />
		
		<cfset variables.target = arguments.target />
		<cfset variables.method = arguments.method />
		<cfset variables.args = arguments.args />
		<cfset variables.runnable = false />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="proceed" access="public" returntype="any" output="false" 
				hint="Executes captured method on target object">
		
		<cfset var rtn = 0 />
		
		<cfif isRunnable()>
			<cfinvoke component="#variables.target#"
					  method="#variables.method#" 
					  argumentcollection="#variables.args#" 
					  returnvariable="rtn">
			</cfinvoke>	
			<cfset variables.runnable = false />
			<cfif isDefined('rtn')>
				<cfreturn rtn />
			</cfif>
		</cfif>
		
	</cffunction>
	
	<cffunction name="getMethodName" access="public" returntype="string" output="false">
		<cfreturn variables.method />
	</cffunction>
	
	<cffunction name="setRunnable" access="package" returntype="void" output="false">
		<cfset variables.runnable = true />
	</cffunction>
	
	<cffunction name="isRunnable" access="private" returntype="boolean" output="false">
		<cfreturn variables.runnable />
	</cffunction>
	
</cfcomponent>