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
		
			
 $Id: channel.cfc,v 1.2 2005/09/26 02:01:05 rossd Exp $

--->


<cfcomponent name="channel" output="false">
	<cffunction name="init" returntype="coldspring.examples.feedviewer.model.channel.channel" access="public" output="false">
		<cfargument name="id" type="numeric" required="no" default="-1"/>		
		<cfargument name="title" type="string" required="no" default=""/>
		<cfargument name="url" type="string" required="no" default=""/>		
		<cfargument name="description" type="string" required="no" default=""/>	
		<cfargument name="categoryIds" type="string" required="no" default=""/>	
		
		<cfset variables.instanceData = structnew()/>
		
		<cfif arguments.id gt 0>
			<cfset setId(arguments.id)/>
		</cfif>
		<cfset setTitle(arguments.title)/>
		<cfset setUrl(arguments.url)/>		
		<cfset setDescription(arguments.description)/>
		<cfset setCategoryIds(arguments.categoryIds)/>
		
		<cfreturn this/>		
	</cffunction>

	<cffunction name="setInstanceData" access="public" output="false" returntype="void">
		<cfargument name="data" type="struct" required="true"/>		
		<cfset variables.instanceData = arguments.data/>	
	</cffunction>

	<cffunction name="getInstanceData" access="public" output="false" returntype="struct">		
		<cfreturn variables.instanceData/>	
	</cffunction>
	
	<cffunction name="getId" access="public" output="false" returntype="numeric" hint="I retrieve the Id from this instance's data">
		<cfreturn variables.instanceData.Id/>
	</cffunction>

	<cffunction name="setId" access="public" output="false" returntype="void"  hint="I set the Id in this instance's data">
		<cfargument name="Id" type="numeric" required="true"/>
		<cfset variables.instanceData.Id = arguments.Id/>
	</cffunction>

	<cffunction name="hasId" access="public" output="false" returntype="boolean" hint="I retrieve whether the channel has an id (false indicates it's a new channel)">
		<cfreturn structKeyExists(variables.instanceData,'Id')/>
	</cffunction>
	
	<cffunction name="getUrl" access="public" output="false" returntype="string" hint="I retrieve the Url from this instance's data">
		<cfreturn variables.instanceData.Url/>
	</cffunction>

	<cffunction name="setUrl" access="public" output="false" returntype="void"  hint="I set the Url in this instance's data">
		<cfargument name="Url" type="string" required="true"/>
		<cfset variables.instanceData.Url = arguments.Url/>
	</cffunction>

	<cffunction name="getTitle" access="public" output="false" returntype="string" hint="I retrieve the Title from this instance's data">
		<cfreturn variables.instanceData.Title/>
	</cffunction>

	<cffunction name="setTitle" access="public" output="false" returntype="void"  hint="I set the Title in this instance's data">
		<cfargument name="Title" type="string" required="true"/>
		<cfset variables.instanceData.Title = arguments.Title/>
	</cffunction>

	
	<cffunction name="getDescription" access="public" output="false" returntype="string" hint="I retrieve the Description from this instance's data">
		<cfreturn variables.instanceData.Description/>
	</cffunction>

	<cffunction name="setDescription" access="public" output="false" returntype="void"  hint="I set the Description in this instance's data">
		<cfargument name="Description" type="string" required="true"/>
		<cfset variables.instanceData.Description = arguments.Description/>
	</cffunction>

	<cffunction name="getCategoryIds" access="public" output="false" returntype="string" hint="I retrieve the CategoryIds from this instance's data">
		<cfreturn variables.instanceData.CategoryIds/>
	</cffunction>

	<cffunction name="setCategoryIds" access="public" output="false" returntype="void"  hint="I set the CategoryIds in this instance's data">
		<cfargument name="CategoryIds" type="string" required="true"/>
		<cfset variables.instanceData.CategoryIds = arguments.CategoryIds/>
	</cffunction>

	
</cfcomponent>
