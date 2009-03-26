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
		
			
 $Id: sqlEntryGateway.cfc,v 1.2 2005/09/26 02:01:07 rossd Exp $

--->

<cfcomponent name="Sql entry Gateway" extends="coldspring.examples.feedviewer.model.entry.entryGateway" output="false">
	
	<cffunction name="init" access="public" returntype="coldspring.examples.feedviewer.model.entry.sqlEntryGateway">
		<cfargument name="datasourceSettings" type="coldspring.examples.feedviewer.model.datasource.datasourceSettings" required="true"/>
		<cfset variables.dss = arguments.datasourceSettings/>
		<cfreturn this/>
	</cffunction>

	<cffunction name="setLogger" returntype="void" access="public" output="false" hint="dependency: logger">
		<cfargument name="logger" type="coldspring.examples.feedviewer.model.logging.logger" required="true"/>
		<cfset variables.m_Logger = arguments.logger/>
	</cffunction>	
	
	<cffunction name="getAll" returntype="query" output="false" hint="I retrieve all existing entrys" access="public">
		<cfargument name="start" type="numeric" required="false" hint="start" default="0"/>
		<cfargument name="maxEntries" type="numeric" required="false" hint="number of records to fetch" default="50"/>
		
		<cfset var qGetentry = 0/>
		
		<cfset variables.m_Logger.info("sqlentryGateway: fetching all entrys starting at: #arguments.start#")/>
		
		<cfswitch expression="#variables.dss.getVendor()#">
			<!--- normally I would this inside cfquery, but
				  since emulating paging in mssql is so ugly
				  i'm splitting out the mySql query! --->
			<cfcase value="mysql">
				<cfquery name="qGetentry" datasource="#variables.dss.getDatasourceName()#">
				select ch.title as blogTitle, ch.url as xmlUrl, ch.id as channel_id, e.url, e.authored_by, e.authored_on, e.title, e.body, e.id, e.guid
				from entry e inner join channel ch on e.fk_channel_id = ch.id
      		 	order by e.retrieved_on desc
        		limit <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.start#"/>, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.maxEntries#"/>
				</cfquery>
			</cfcase>
			<cfcase value="mssql">
				<cfquery name="qGetentry" datasource="#variables.dss.getDatasourceName()#">
				select	t2.blogTitle, t2.xmlUrl, t2.channel_id, t2.url, t2.authored_by, 
						t2.authored_on, t2.title, t2.body, t2.id, t2.guid, CAST ( t2.retrieved_on AS smalldatetime) as retrieved_on
				from (
					select TOP #arguments.maxEntries#
						t1.blogTitle, t1.xmlUrl, t1.channel_id, t1.url, t1.authored_by, 
						t1.authored_on, t1.title, t1.body, t1.id, t1.guid, t1.retrieved_on
					from (
						select TOP #(arguments.start + arguments.maxEntries)#
							ch.title as blogTitle, ch.url as xmlUrl, ch.id as channel_id, e.url, e.authored_by, 
							e.authored_on, e.title, e.body, e.id, e.guid, e.retrieved_on
						from entry e inner join channel ch on e.fk_channel_id = ch.id
      		 			order by e.retrieved_on desc
      		 			) t1
      		 			order by t1.retrieved_on
      		 		) t2
      		 		order by t2.retrieved_on desc, t2.authored_on desc
        		</cfquery>	
			</cfcase>
			<cfdefaultcase>
				<cfthrow message="Unknown Datasource Vendor!">
			</cfdefaultcase>
		</cfswitch>
		<cfreturn qGetentry> 
	</cffunction>
	
	<cffunction name="getByChannelID" returntype="query" output="false" hint="I retrieve all existing entrys" access="public">
		<cfargument name="channelID" type="numeric" required="true" hint="aIds of the channel to restrict to"/>
		<cfargument name="maxEntries" type="numeric" required="false" default="50" hint="max number of entries to retrieve" />
		
		<cfset var qGetEntrys = 0/>
		
		<cfset variables.m_Logger.info("sqlentryGateway: fetching entrys by channel id: #arguments.channelId#")/>
		
		<cfquery name="qGetEntrys" datasource="#variables.dss.getDatasourceName()#">
		select 
		<cfif variables.dss.getVendor() eq "mssql">
			TOP #arguments.maxEntries#
		</cfif>
		*
		from entry e
        where e.fk_channel_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.channelId#"/>
        order by e.authored_on desc, e.retrieved_on desc
        <cfif variables.dss.getVendor() eq "mysql">
        	limit 0,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.maxEntries#"/>
		</cfif>
		</cfquery>
		
		<cfreturn qGetEntrys> 
		
	</cffunction>	
	
</cfcomponent>