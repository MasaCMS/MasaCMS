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
		
			
 $Id: categoryListener.cfc,v 1.2 2005/09/26 02:01:04 rossd Exp $

--->

<cfcomponent name="categoryListener.cfc" extends="MachII.framework.listener" output="false">
	<cffunction name="configure" access="public" returntype="void" output="false">
		<cfset var sf = getProperty('serviceFactory')/>
		<cfset variables.m_categoryService = sf.getBean('categoryService')/>
	</cffunction>
	
	<cffunction name="getAllCategories" returntype="query" access="public" output="false" hint="I retrieve all existing categories">
		<cfreturn variables.m_categoryService.getAllCategories()/>
	</cffunction>
	
	
	<cffunction name="getCategoryById" access="public" returntype="coldspring.examples.feedviewer.model.category.category" output="false" hint="I retrieve a category">
		<cfargument name="event" type="MachII.framework.Event" required="yes" displayname="Event"/>
	
		<cfreturn variables.m_categoryService.getById(arguments.event.getArg('categoryId'))/>
	
	</cffunction>
	
	<cffunction name="saveCategory" access="public" returntype="void" output="false" hint="I save a category">
		<cfargument name="event" type="MachII.framework.Event" required="yes" displayname="Event"/>
		
		<cftry>
			<cfset variables.m_categoryService.save(arguments.event.getArg('category'))/>
			<cfcatch>
				<cfset arguments.event.setArg('message','save failed... fix it! (#cfcatch.message#)')/>
				<cfset announceEvent('renderCategory', arguments.event.getArgs())/>
				<cfreturn/>
			</cfcatch>
		</cftry>	

		<cfset arguments.event.setArg('message','category saved!')/>
		<cfset announceEvent('c.showHome', arguments.event.getArgs())/>

	
	</cffunction>
	<cffunction name="removeCategory" access="public" returntype="void" output="false" hint="I save a category">
		<cfargument name="event" type="MachII.framework.Event" required="yes" displayname="Event"/>
		
		<cftry>
			<cfset variables.m_categoryService.remove(arguments.event.getArg('category'))/>
			<cfcatch>
				<cfset arguments.event.setArg('message','remove failed... fix it!')/>
				<cfset announceEvent('renderCategory', arguments.event.getArgs())/>
				<cfreturn/>
			</cfcatch>
		</cftry>	

		<cfset arguments.event.setArg('message','category removed!')/>
		<cfset announceEvent('c.showHome', arguments.event.getArgs())/>

	
	</cffunction>	
</cfcomponent>
			
