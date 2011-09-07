<!---
 
  Copyright (c) 2005, David Ross, Chris Scott, Kurt Wiersma, Sean Corfield
  
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
       http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
		
			
 $Id: TransactionAdvice.cfc,v 1.2 2007/11/25 18:05:00 scottc Exp $

--->

<cfcomponent name="TransactionAdvice" 
			 extends="coldspring.aop.MethodInterceptor">
	
	<cffunction name="invokeMethod" access="public" returntype="any">
		<cfargument name="mi" type="coldspring.aop.MethodInvocation" required="true" />
		<cfset var target = arguments.mi.getTarget() />
		<cfset var commit = false />
		<cfset var rtn = 0 />
		<cfset var sys = CreateObject('java','java.lang.System') />
		
		<cftransaction action="begin">
			<cfset sys.out.println("BEGINING TRANSACTION...")>
			<cfset rtn =  arguments.mi.proceed() />
			<!--- get the commit flag on the target object (if we can) --->
			<cftry>
				<cfset commit = target.getCommit() />
				<cfcatch></cfcatch>
			</cftry>
			
			<cfif commit>
				<cfset sys.out.println("COMMITTING TRANSACTION...")>
				<cftransaction action="commit" />
			<cfelse>
				<cfset sys.out.println("ROLLING BACK TRANSACTION...")>
				<cftransaction action="rollback" />
			</cfif>
			<cfset sys.out.println("ENDING TRANSACTION...")>
		</cftransaction>
		
		<!--- reset the commit flag on the target object (if we can) --->
		<cftry>
			<cfset commit = target.setCommit(false) />
			<cfcatch></cfcatch>
		</cftry>
		
		<cfif isDefined("rtn")>
			<cfreturn rtn />
		</cfif>
		
	</cffunction>
	
</cfcomponent>