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
		
			
 $Id: categoryManager.cfc,v 1.2 2005/09/26 02:01:04 rossd Exp $

--->

<cfcomponent name="categoryManager.cfc" output="false">
	<cffunction name="init" access="public" returntype="coldspring.examples.feedviewer-fb4.controller.categoryManager"  output="false">
		<cfargument name="serviceFactory" type="coldspring.beans.BeanFactory" required="yes"/>
		<cfset variables.m_categoryService = arguments.serviceFactory.getBean('categoryService')/>
		<cfreturn this/>
	</cffunction>

	<cffunction name="getAllCategories" returntype="query" access="public" output="false" hint="I retrieve all existing categories">
		<cfreturn variables.m_categoryService.getAllCategories()/>
	</cffunction>
	
	
	<cffunction name="getCategoryById" access="public" returntype="coldspring.examples.feedviewer.model.category.category" output="false" hint="I retrieve a category">
		<cfargument name="event" type="coldspring.examples.feedviewer-fb4.plugins.event" required="yes" displayname="Event"/>
	
		<cfreturn variables.m_categoryService.getById(arguments.event.getArg('categoryId'))/>
	
	</cffunction>
	
	<cffunction name="saveCategory" access="public" returntype="boolean" output="false" hint="I save a category">
		<cfargument name="event" type="coldspring.examples.feedviewer-fb4.plugins.event" required="yes" displayname="Event"/>
		
		<cftry>
			<cfset variables.m_categoryService.save(arguments.event.getArg('category'))/>
			<cfcatch>
				<cfset arguments.event.setArg('message','save failed... fix it!')/>
				<cfreturn false/>
			</cfcatch>
		</cftry>	

		<cfset arguments.event.setArg('message','category saved!')/>
		<cfreturn true/>
	</cffunction>
	
	
	<cffunction name="removeCategory" access="public" returntype="boolean" output="false" hint="I save a category">
		<cfargument name="event" type="coldspring.examples.feedviewer-fb4.plugins.event" required="yes" displayname="Event"/>
		
		<cftry>
			<cfset variables.m_categoryService.remove(arguments.event.getArg('category'))/>
			<cfcatch>
				<cfset arguments.event.setArg('message','remove failed... fix it!')/>
				<cfreturn false/>
			</cfcatch>
		</cftry>	

		<cfset arguments.event.setArg('message','category removed!')/>
		<cfreturn true/>
	
	</cffunction>	
</cfcomponent>
			
