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

  $Id: CatalogGateway.cfc,v 1.1 2005/10/09 20:12:05 scottc Exp $
  $Log: CatalogGateway.cfc,v $
  Revision 1.1  2005/10/09 20:12:05  scottc
  First commit of the record store example app. Contains a hopefully detailed readme file on usage.

  Revision 1.5  2005/10/09 19:05:04  chris
  Small gateway fix, not getting featured property

  Revision 1.4  2005/10/09 19:01:32  chris
  Added proper licensing and switched to MethodInterceptor Araound Advice for logging

  Revision 1.3  2005/09/26 01:26:06  chris
  added selecting artists / genres

  Revision 1.2  2005/09/25 19:43:07  chris
  Started a Caching Service, but gave up

  Revision 1.1  2005/09/25 18:09:56  chris
  Adding Klondike Records aop demo app
	
--->

<cfcomponent displayname="CatalogGateway" output="false">
	
	<cfset variables.m_dsn = "" />
	<cfset variables.cacheTimeLong = CreateTimeSpan(0, 0, 30, 0)>
	<cfset variables.cacheTimeShort = CreateTimeSpan(0, 0, 20, 0)>
	
	<cffunction name="init" access="public" returntype="net.klondike.component.CatalogGateway" output="false">
		<cfreturn this />
	</cffunction>
	
	<!--- setters for dependencies --->
	<cffunction name="setDsn" returntype="void" access="public" output="false" hint="Dependency: datasource name">
		<cfargument name="dsn" type="string" required="true"/>
		<cfset variables.m_dsn = arguments.dsn />
	</cffunction>
	
	<!--- dao methods --->
	<cffunction name="getGenres" returntype="struct" access="public" output="false">
		<cfset var qryGenres = 0 />
		<cfset var genres = StructNew() />
		<cfset genres.order = ArrayNew(1) />
		<cfset genres.data = StructNew() />
		
		<cfquery name="qryGenres" datasource="#variables.m_dsn#">
		SELECT * FROM genres
		</cfquery>
		
		<cfloop query="qryGenres">
			<cfset genres.data[genreID] = genre />
			<cfset ArrayAppend(genres.order, genreID) />
		</cfloop>
		
		<cfreturn genres />
	</cffunction>
	
	<cffunction name="getArtists" returntype="struct" access="public" output="false">
		<cfset var qryArtists = 0 />
		<cfset var artists = StructNew() />
		<cfset artists.order = ArrayNew(1) />
		<cfset artists.data = StructNew() />
		
		<cfquery name="qryArtists" datasource="#variables.m_dsn#">
		SELECT * FROM artists ORDER BY artistName
		</cfquery>
		
		<cfloop query="qryArtists">
			<cfset artists.data[artistID] = artistName />
			<cfset ArrayAppend(artists.order, artistID) />
		</cfloop>
		
		<cfreturn artists />
	</cffunction>
	
	<cffunction name="getHighlights" returntype="Array" access="public" output="false">
		<cfargument name="flush" type="boolean" required="false" default="false" />
		<cfset var cacheTime = variables.cacheTimeLong />
		<cfset var highlights = ArrayNew(1) />
		<cfset var qryHignlights = 0 />
		<cfif flush>
			<cfset cacheTime = 0 />
		</cfif>
		
		<cfquery name="qryHignlights" datasource="#variables.m_dsn#" cachedwithin="#cacheTime#">
		SELECT a.artistID, a.artistName, g.genreID, g.genre, r.recordID, r.title, r.releaseDate, 
			r.image, r.price, r.featured
		FROM records r INNER JOIN artists a ON r.artistID = a.artistID
			INNER JOIN genres g ON r.genreID = g.genreID
		WHERE r.featured = 1 
		ORDER BY a.artistName, r.title
		</cfquery>
		
		<!--- convert to array of objects --->
		<cfloop query="qryHignlights">
			<cfset ArrayAppend(highlights,
				   CreateObject('component','net.klondike.component.Record').init(
						recordID,artistID,genreID,title,releaseDate,image,price,featured
				 			  ) ) />
		</cfloop>
		
		<cfreturn highlights />
	</cffunction>
	
	<cffunction name="getRecords" returntype="Array" access="public" output="false">
		<cfargument name="artist" type="numeric" required="true" default="false" />
		<cfargument name="genre" type="numeric" required="true" default="false" />
		<cfargument name="flush" type="boolean" required="false" default="false" />
		<cfset var cacheTime = variables.cacheTimeLong />
		<cfset var highlights = ArrayNew(1) />
		<cfset var qryRecords = 0 />
		<cfif flush>
			<cfset cacheTime = 0 />
		</cfif>
		
		<cfquery name="qryRecords" datasource="#variables.m_dsn#">
		SELECT a.artistID, a.artistName, g.genreID, g.genre, r.recordID, r.title, r.releaseDate, 
			r.image, r.price, r.featured
		FROM records r INNER JOIN artists a ON r.artistID = a.artistID
			INNER JOIN genres g ON r.genreID = g.genreID
		WHERE 1=1
			<cfif arguments.artist GT 0>
			AND r.artistID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.artist#" /> 
			</cfif>
			<cfif arguments.genre GT 0>
			AND r.genreID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.genre#" /> 
			</cfif>
		ORDER BY a.artistName, r.title
		</cfquery>
		
		<!--- convert to array of objects --->
		<cfloop query="qryRecords">
			<cfset ArrayAppend(highlights,
				   CreateObject('component','net.klondike.component.Record').init(
						recordID,artistID,genreID,title,releaseDate,image,price,featured
				 			  ) ) />
		</cfloop>
		
		<cfreturn highlights />
	</cffunction>
	
	<cffunction name="flushRecords" access="public" returntype="void" output="false">
		<cfset getHighlights(true) />
	</cffunction>
	
</cfcomponent>