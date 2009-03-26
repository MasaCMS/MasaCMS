<!---
 
  Copyright (c) 2002-2005	David Ross,	Chris Scott
  
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
       http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
		
			
 $Id: entryGateway.cfc,v 1.2 2005/09/26 02:01:05 rossd Exp $

--->

<cfcomponent name="Abstract entry gateway" output="false">
	
	<cffunction name="init" access="private">
		<cfthrow type="Method.NotImplemented">
	</cffunction>
	
	<cffunction name="getAll" returntype="query" output="false" access="public" hint="I retrieve a entry">
		<cfthrow message="Method.NotImplemented"/>
	</cffunction>

	<cffunction name="getByChannelID" returntype="query" output="false" access="public" hint="I retrieve a entry">
		<cfthrow message="Method.NotImplemented"/>
	</cffunction>
	
	<cffunction name="getByCategoryID" returntype="query" output="false" access="public" hint="I retrieve a entry">
		<cfthrow message="Method.NotImplemented"/>
	</cffunction>
</cfcomponent>