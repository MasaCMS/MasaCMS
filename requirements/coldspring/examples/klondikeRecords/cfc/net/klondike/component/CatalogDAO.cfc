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

  $Id: CatalogDAO.cfc,v 1.1 2005/10/09 20:12:05 scottc Exp $
  $Log: CatalogDAO.cfc,v $
  Revision 1.1  2005/10/09 20:12:05  scottc
  First commit of the record store example app. Contains a hopefully detailed readme file on usage.

  Revision 1.2  2005/10/09 19:01:32  chris
  Added proper licensing and switched to MethodInterceptor Araound Advice for logging

  Revision 1.1  2005/09/25 18:09:56  chris
  Adding Klondike Records aop demo app
	
--->

<cfcomponent displayname="CatalogDAO" output="false">
	
	<cfset variables.m_dsn = "" />
	<cfset variables.cacheTimeLong = CreateTimeSpan(0, 0, 30, 0)>
	<cfset variables.cacheTimeShort = CreateTimeSpan(0, 0, 20, 0)>
	
	<cffunction name="init" access="public" returntype="Any" output="false">
		<cfreturn this />
	</cffunction>
	
	<!--- setters for dependencies --->
	<cffunction name="setDsn" returntype="void" access="public" output="false" hint="Dependency: datasource name">
		<cfargument name="dsn" type="string" required="true"/>
		<cfset variables.m_dsn = arguments.dsn />
	</cffunction>
	
	<!--- dao methods --->
	<cffunction name="fetch" returntype="net.klondike.component.Record" access="public" output="false">
		<cfargument name="recordID" type="numeric" required="true" />
		<cfset var record = CreateObject('component','net.klondike.component.Record').init() />
		<cfset var qrySelect = 0 />
		
		<cfquery name="qrySelect" maxrows="1" datasource="#variables.m_dsn#">
		SELECT * FROM records WHERE recordID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.recordID#" />
		</cfquery>
		
		<cfif qrySelect.RecordCount LT 1>
			<cfthrow message="Record not found for recordID: #arguments.recordID#!">
		</cfif>
		
		<cfset record.setRecordID(qrySelect.recordID) />
		<cfset record.setArtistID(qrySelect.artistID) />
		<cfset record.setGenreID(qrySelect.genreID) />
		<cfset record.setTitle(qrySelect.title) />
		<cfset record.setReleaseDate(qrySelect.releaseDate) />
		<cfset record.setImage(qrySelect.image) />
		<cfset record.setPrice(qrySelect.price) />
		<cfset record.setFeatured(qrySelect.featured) />
		
		<cfreturn record />
		
	</cffunction>
	
	<cffunction name="save" returntype="void" access="public" output="false">
		<cfargument name="record" type="net.klondike.component.Record" required="true" />
		
		<cfif arguments.record.hasId()>
			<cfset update(arguments.record)/>
		<cfelse>
			<cfset create(arguments.record)/>
		</cfif>		

	</cffunction>
	
	<cffunction name="create" returntype="void" access="private" output="false">
		<cfargument name="record" type="net.klondike.component.Record" required="true" />

		<cfset var qryInsert = 0 />
		
		<!--- insert the record --->
		<cfquery name="qryInsert" datasource="#variables.m_dsn#">
		INSERT INTO records (
			artistID,
			genreID,
			title,
			releaseDate,
			image,
			price,
			featured 
			)
		VALUES (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#record.getArtistID()#" />,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#record.getGenreID()#" />,
			<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#record.getTitle()#" />,
			<cfqueryparam cfsqltype="cf_sql_char" maxlength="4" value="#record.getReleaseDate()#" />,
			<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#record.getImage()#" />,
			<cfqueryparam cfsqltype="cf_sql_decimal" value="#record.getPrice()#" />,
			<cfqueryparam cfsqltype="cf_sql_tinyint" value="#record.isFeatured()#" />
			)
		</cfquery>
		
	</cffunction>
	
	<cffunction name="update" returntype="void" access="private" output="false">
		<cfargument name="record" type="net.klondike.component.Record" required="true" />

		<cfset var qryUpdate = 0 />
		
		<!--- update the record --->
		<cfquery name="qryUpdate" datasource="#variables.m_dsn#">
		UPDATE records SET
			artistID = <cfqueryparam cfsqltype="cf_sql_integer" value="#record.getArtistID()#" />,
			genreID = <cfqueryparam cfsqltype="cf_sql_integer" value="#record.getGenreID()#" />,
			title = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#record.getTitle()#" />,
			releaseDate = <cfqueryparam cfsqltype="cf_sql_char" maxlength="4" value="#record.getReleaseDate()#" />,
			image = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#record.getImage()#" />,
			price = <cfqueryparam cfsqltype="cf_sql_decimal" value="#record.getPrice()#" />,
			featured =  <cfqueryparam cfsqltype="cf_sql_tinyint" value="#record.isFeatured()#" />
		WHERE recordID = <cfqueryparam cfsqltype="cf_sql_integer" value="#record.getRecordID()#" />
		</cfquery>
		
	</cffunction>
	
</cfcomponent>