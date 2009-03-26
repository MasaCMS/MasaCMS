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

  $Id: CatalogService.cfc,v 1.1 2005/10/09 20:12:05 scottc Exp $
  $Log: CatalogService.cfc,v $
  Revision 1.1  2005/10/09 20:12:05  scottc
  First commit of the record store example app. Contains a hopefully detailed readme file on usage.

  Revision 1.4  2005/10/09 19:01:32  chris
  Added proper licensing and switched to MethodInterceptor Araound Advice for logging


--->
 
<cfcomponent name="CatalogService"
			extends="net.klondike.service.CatalogService" displayname="CatalogService" hint="Service for record Catalog">

	<cffunction name="init" returntype="net.klondike.service.CatalogService" access="public" output="false">
		<cfreturn this/>
	</cffunction>
	
	<!--- setters for dependencies --->
	<cffunction name="setCatalogDAO" returntype="void" access="public" output="false" hint="Dependency: ">
		<cfargument name="catalogDAO" type="net.klondike.component.CatalogDAO" required="true"/>
		<cfset variables.catalogDAO  = arguments.catalogDAO />
	</cffunction>
	
	<cffunction name="setCatalogGateway" returntype="void" access="public" output="false" hint="Dependency: ">
		<cfargument name="catalogGateway" type="net.klondike.component.CatalogGateway" required="true"/>
		<cfset variables.catalogGateway  = arguments.catalogGateway />
	</cffunction>
	
	<!--- service methods --->
	
	<cffunction name="getGenres" access="public" returntype="struct" output="false">
		<cfif not structKeyExists(variables,"genres")>
			<cflock name="CatelogService.genres" type="readonly" timeout="10">
				<cfset variables.genres = variables.catalogGateway.getGenres() />
			</cflock>
		</cfif>
		<cfreturn variables.genres />
	</cffunction>
	
	<cffunction name="getArtists" access="public" returntype="struct" output="false">
		<cfif not structKeyExists(variables,"artists")>
			<cflock name="CatelogService.artists" type="exclusive" timeout="10">
				<cfset variables.artists = variables.catalogGateway.getArtists() />
			</cflock>
		</cfif>
		<cfreturn variables.artists />
	</cffunction>
	
	<cffunction name="getHighlights" access="public" returntype="array" output="false">
		<cfreturn variables.catalogGateway.getHighlights() />
	</cffunction>
	
	<cffunction name="getRecords" access="public" returntype="array" output="false">
		<cfargument name="artist" type="numeric" required="true"/>
		<cfargument name="genre" type="numeric" required="true"/>
		<cfreturn variables.catalogGateway.getRecords(artist,genre) />
	</cffunction>
	
	<cffunction name="fetchRecord" access="public" returntype="net.klondike.component.Record" output="false">
		<cfargument name="recordID" type="numeric" required="true"/>
		<cfreturn variables.catalogDAO.fetch(arguments.recordID) />
	</cffunction>
	
	<cffunction name="saveRecord" access="public" returntype="void" output="false">
		<cfargument name="record" type="net.klondike.component.Record" required="true"/>
		<cfset variables.catalogDAO.save(arguments.record) />
		<cfset variables.catalogGateway.flushRecords() />
	</cffunction>
	
</cfcomponent>