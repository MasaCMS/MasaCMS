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
		
			
 $Id: cfhttpRetrievalService.cfc,v 1.2 2005/09/26 02:01:07 rossd Exp $

--->

<cfcomponent name="cfhttp Retrieval Service" extends="coldspring.examples.feedviewer.model.retrieval.retrievalService" output="false">
	
	<cffunction name="init" access="public" output="false" returntype="coldspring.examples.feedviewer.model.retrieval.cfhttpRetrievalService">
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="retrieve" returntype="string" output="false" hint="Returns content contained in a remote url" access="public">
		<cfargument name="url" type="string" required="true" hint="url to be retrieved"/>
		<cfset var cfhttp = structnew()/>
		<!--- we may end up having to lock here --->
		<cfhttp method="get" url="#arguments.url#" />
		<cfreturn cfhttp.FileContent/>
	</cffunction>
	
</cfcomponent>