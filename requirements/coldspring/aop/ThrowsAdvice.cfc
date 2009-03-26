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

 $Id: ThrowsAdvice.cfc,v 1.3 2005/11/16 16:16:10 rossd Exp $
 $Log: ThrowsAdvice.cfc,v $
 Revision 1.3  2005/11/16 16:16:10  rossd
 updates to license in all framework code

 Revision 1.2  2005/11/12 19:01:07  scottc
 Many fixes in new advice type Interceptors, which now don't require parameters to be defined for the afterReturning and before methods. Advice objects are now NOT cloned, so they can be used as real objects and retrieved from the factory, if needed. Implemented the afterThrowing advice which now can be used to create a full suite of exception mapping methods. Also afterReturning does not need to (and shouldn't) return or act on the return value

 Revision 1.1  2005/11/03 02:09:22  scottc
 Initial classes to support throwsAdvice, as well as implementing interceptors to make before and after advice (as well as throws advice) all part of the method invocation chain. This is very much in line with the method invocation used in Spring, seems very necessary for throws advice to be implemented. Also should simplify some issues with not returning null values. These classes are not yet implemented in the AopProxyBean, so nothing works yet!


---> 
 
<cfcomponent name="ThrowsAdvice" 
			displayname="ThrowsAdvice" 
			extends="coldspring.aop.Advice" 
			hint="Interface (Abstract Class) for Throws Advice implimentations" 
			output="false">
			
	<cfset variables.adviceType = 'throws' />
			
	<cffunction name="init" access="private" returntype="void" output="false">
		<cfthrow message="Abstract CFC. Cannot be initialized" />
	</cffunction>
	
	<cffunction name="afterThrowing" access="public" returntype="void">
		<cfargument name="method" type="coldspring.aop.Method" required="false" />
		<cfargument name="args" type="struct" required="false" />
		<cfargument name="target" type="any" required="false" />
		<cfargument name="exception" type="coldspring.aop.Exception" required="true" />
		<cfthrow type="Method.NotImplemented">
	</cffunction>
	
</cfcomponent>