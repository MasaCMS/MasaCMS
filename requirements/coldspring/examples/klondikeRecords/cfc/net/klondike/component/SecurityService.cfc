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

  $Id: SecurityService.cfc,v 1.1 2005/10/09 20:12:05 scottc Exp $
  $Log: SecurityService.cfc,v $
  Revision 1.1  2005/10/09 20:12:05  scottc
  First commit of the record store example app. Contains a hopefully detailed readme file on usage.

  Revision 1.2  2005/10/09 19:01:32  chris
  Added proper licensing and switched to MethodInterceptor Araound Advice for logging


--->
 
<cfcomponent name="SecurityService"
			extends="net.klondike.service.SecurityService" displayname="SecurityService" hint="Service for Security">

	<cffunction name="init" returntype="net.klondike.service.SecurityService" access="public" output="false">
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="hasPermissions" access="public" returntype="boolean" output="false">
		<cfreturn StructKeyExists(session,"user") />
	</cffunction>
	
</cfcomponent>