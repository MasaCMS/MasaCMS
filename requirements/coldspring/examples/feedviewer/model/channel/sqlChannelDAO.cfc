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
		
			
 $Id: sqlChannelDAO.cfc,v 1.2 2005/09/26 02:01:05 rossd Exp $

--->

<cfcomponent name="MySQL channel DAO" output="false" extends="coldspring.examples.feedviewer.model.channel.channelDAO">
	
	<cffunction name="init" access="public" output="false" returntype="coldspring.examples.feedviewer.model.channel.sqlchannelDAO">
		<cfargument name="datasourceSettings" type="coldspring.examples.feedviewer.model.datasource.datasourceSettings" required="true"/>
		<cfset variables.dss = arguments.datasourceSettings/>
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="setLogger" returntype="void" access="public" output="false" hint="dependency: logger">
		<cfargument name="logger" type="coldspring.examples.feedviewer.model.logging.logger" required="true"/>
		<cfset variables.m_Logger = arguments.logger/>
	</cffunction>	
	
	<cffunction name="fetch" returntype="coldspring.examples.feedviewer.model.channel.channel" output="false" access="public" hint="I retrieve a channel">
		<cfargument name="channelIdentifier" type="any" required="true" hint="I am the unique ID of the channel to be retrieved"/>
		<cfset var qGetchannel = 0/>
		<cfset var channel = createObject("component","coldspring.examples.feedviewer.model.channel.channel").init()/>
		
		<cfset variables.m_Logger.info("sqlchannelDAO: fetching channel with id = #arguments.channelIdentifier#")/>
		
		<cfquery name="qGetchannel" datasource="#variables.dss.getDatasourceName()#">
		select ch.id, ch.url, ch.title, ch.description, c.fk_category_id
		from channel ch
		left outer join category_channels c ON ch.id = c.fk_channel_id
		where ch.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.channelIdentifier#"/>
		</cfquery>
		
		<cfset channel.setID(qGetchannel.id[1])/>
		<cfset channel.setUrl(qGetchannel.url[1])/>
		<cfset channel.setTitle(qGetchannel.title[1])/>
		<cfset channel.setDescription(qGetchannel.description[1])/>
		<cfset channel.setCategoryIds(valuelist(qGetchannel.fk_category_id))/>
	
		<cfreturn channel/>

	</cffunction>

	<cffunction name="save" returntype="void" output="false" access="public" hint="I save a channel">
		<cfargument name="channel" type="coldspring.examples.feedviewer.model.channel.channel" hint="I am the channel to be saved" required="true"/>
		<cfif arguments.channel.hasId()>
			<cfset update(arguments.channel)/>
		<cfelse>
			<cfset create(arguments.channel)/>
		</cfif>
		<cfset refreshCategories(arguments.channel)/>
	</cffunction>
	
	<cffunction name="remove" returntype="void" output="false" access="public" hint="I remove a channel">
		<cfargument name="channel" type="coldspring.examples.feedviewer.model.channel.channel" hint="I am the channel to be removed" required="true"/>
		<cfset var qRemChannel = 0/>
		
		<cfquery name="qRemChannel" datasource="#variables.dss.getDatasourceName()#">
			delete from channel
			where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.channel.getId()#"/>	
		</cfquery>
		
		<!--- kill any category associations  --->
		<cfquery name="qRemChannel" datasource="#variables.dss.getDatasourceName()#">
			delete from category_channels
			where fk_channel_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.channel.getId()#"/>	
		</cfquery>

		<!--- should we kill all the channel's entries now too? I'm not so sure... 
			  I think if they were aggregated we should keep them --->
	</cffunction>
	
	<cffunction name="create" returntype="void" output="false" access="private" hint="I create a channel">
		<cfargument name="channel" type="coldspring.examples.feedviewer.model.channel.channel" hint="I am the channel to be saved" required="true"/>
		<cfset var qInsChannel = 0/>
		<cfset var qGetNewChannelId = 0/>		
		
		<cftransaction>
			<cfquery name="qInsChannel" datasource="#variables.dss.getDatasourceName()#">
				insert into channel
				(title,url,description)
				values
				(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.channel.getTitle()#"/>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.channel.getUrl()#"/>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.channel.getDescription()#"/>)	
			</cfquery>
			
			<cfquery name="qGetNewChannelId" datasource="#variables.dss.getDatasourceName()#">
				select 
				<cfswitch expression="#variables.dss.getVendor()#">
					<cfcase value="mysql">
						LAST_INSERT_ID()
					</cfcase>
					<cfcase value="mssql">
						@@identity
					</cfcase>
					<cfdefaultcase>
						<cfthrow message="Unknown Datasource Vendor!">
					</cfdefaultcase>
				</cfswitch>  as newChannelId
				from channel
			</cfquery>
			
		</cftransaction>
		
		<cfset arguments.channel.setId(qGetNewChannelId.newChannelId)/>
		
	</cffunction>
	
	<cffunction name="update" returntype="void" output="false" access="private" hint="I create a channel">
		<cfargument name="channel" type="coldspring.examples.feedviewer.model.channel.channel" hint="I am the channel to be saved" required="true"/>
		<cfset var qUdChannel = 0/>	
		
		<cfquery name="qUdChannel" datasource="#variables.dss.getDatasourceName()#">
			update channel
			set title=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.channel.getTitle()#"/>,
			url=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.channel.getUrl()#"/>,
			description=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.channel.getDescription()#"/>
			where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.channel.getId()#"/>
		</cfquery>

	</cffunction>	
	
	<cffunction name="refreshCategories" returntype="void" output="false" access="private" hint="I create a channel">
		<cfargument name="channel" type="coldspring.examples.feedviewer.model.channel.channel" hint="I am the channel to be saved" required="true"/>
		<cfset var qClearChannelCats = 0/>
		<cfset var qInsChannelCats = 0/>		
				
		<cfquery name="qClearChannelCats" datasource="#variables.dss.getDatasourceName()#">
			delete from category_channels
			where fk_channel_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.channel.getId()#"/>
		</cfquery>
		<cfif listlen(arguments.channel.getCategoryIds())>
			<cfquery name="qClearChannelCats" datasource="#variables.dss.getDatasourceName()#">
				insert into category_channels
				(fk_channel_id, fk_category_id)
				select <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.channel.getId()#"/> as channelID, c.id
				from category c
				where c.id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.channel.getCategoryIds()#" list="yes"/>)
			</cfquery>
		</cfif>

	</cffunction>	
	
</cfcomponent>