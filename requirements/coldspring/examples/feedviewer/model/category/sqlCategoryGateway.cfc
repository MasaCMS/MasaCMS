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
		
			
 $Id: sqlCategoryGateway.cfc,v 1.2 2005/09/26 02:01:05 rossd Exp $

--->

<cfcomponent name="MySql Category Gateway" extends="coldspring.examples.feedviewer.model.category.categoryGateway" output="false">
	
	<cffunction name="init" access="public" returntype="coldspring.examples.feedviewer.model.category.sqlCategoryGateway">
		<cfargument name="datasourceSettings" type="coldspring.examples.feedviewer.model.datasource.datasourceSettings" required="true"/>
		<cfset variables.dss = arguments.datasourceSettings/>
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="getAll" returntype="query" output="false" hint="I retrieve all existing categories" access="public">
		<cfset var qGetCat = 0/>
		
		<cfquery name="qGetCat" datasource="#variables.dss.getDatasourceName()#">
		select c.id, c.name, c.description, ch.channelCount
		from category c
		left outer join (
        select count(fk_channel_id) as channelCount, fk_category_id
        from category_channels
        group by fk_category_id) ch on c.id = ch.fk_category_id
		</cfquery>
		
		<cfreturn qGetCat> 
		
	</cffunction>
	
</cfcomponent>