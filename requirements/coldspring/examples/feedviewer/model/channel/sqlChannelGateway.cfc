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
		
			
 $Id: sqlChannelGateway.cfc,v 1.2 2005/09/26 02:01:05 rossd Exp $

--->

<cfcomponent name="Sql Channel Gateway" extends="coldspring.examples.feedviewer.model.channel.channelGateway" output="false">
	
	<cffunction name="init" access="public" returntype="coldspring.examples.feedviewer.model.channel.sqlChannelGateway">
		<cfargument name="datasourceSettings" type="coldspring.examples.feedviewer.model.datasource.datasourceSettings" required="true"/>
		<cfset variables.dss = arguments.datasourceSettings/>
		<cfreturn this/>
	</cffunction>

	<cffunction name="setLogger" returntype="void" access="public" output="false" hint="dependency: logger">
		<cfargument name="logger" type="coldspring.examples.feedviewer.model.logging.logger" required="true"/>
		<cfset variables.m_Logger = arguments.logger/>
	</cffunction>	
	
	<cffunction name="getAll" returntype="query" output="false" hint="I retrieve all existing channels" access="public">
		<cfset var qGetChannel = 0/>
		
		<cfset variables.m_Logger.info("sqlchannelGateway: fetching all channels")/>
		
		<cfquery name="qGetChannel" datasource="#variables.dss.getDatasourceName()#">
		select ch.id, ch.url, ch.title, ch.description, e.entryCount
		from channel ch
		left outer join (
        select count(fk_channel_id) as entryCount, fk_channel_id
        from entry
        group by fk_channel_id) e on ch.id = e.fk_channel_id
        order by ch.title
		</cfquery>
		
		<cfreturn qGetChannel> 
		
	</cffunction>
	
	<cffunction name="getAllByCategories" returntype="query" output="false" hint="I retrieve all existing channels" access="public">
		<cfargument name="categoryIds" type="array" required="true" hint="array of Ids of the categories restrict to"/>
		
		<cfset var qGetChannel = 0/>
		
		<cfset variables.m_Logger.info("sqlchannelGateway: fetching channels by category ids: #arrayToList(arguments.categoryIds)#")/>
		
		<cfquery name="qGetChannel" datasource="#variables.dss.getDatasourceName()#">
		select ch.id, ch.url, ch.title, ch.description, e.entryCount
		from channel ch
        inner join category_channels c on ch.id = c.fk_channel_id
		left outer join (
        select count(fk_channel_id) as entryCount, fk_channel_id
        from entry
        group by fk_channel_id) e on ch.id = e.fk_channel_id
        where c.fk_category_id in (<cfqueryparam cfsqltype="cf_sql_integer" value="#arrayToList(arguments.categoryIds)#" list="yes"/>)									  
        order by ch.title
		</cfquery>
		
		<cfreturn qGetChannel> 
		
	</cffunction>	
	
</cfcomponent>