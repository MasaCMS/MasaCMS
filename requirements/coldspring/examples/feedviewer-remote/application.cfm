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
		
			
 $Id: application.cfm,v 1.2 2005/09/26 02:01:04 rossd Exp $

--->

<cfapplication name="CFfeedviewer-REMOTE" sessionmanagement="yes" sessiontimeout="#createtimespan(0,0,75,0)#" />


<!--- create service factory on application startup --->

<cfparam name="url.rl" type="string" default="false" />

<cfif not structKeyExists( application, 'appInitialized' ) or url.rl>
	<cflock name="appInitBlock" type="exclusive" timeout="10">
		<cfif not structKeyExists( application, 'appInitialized' ) or url.rl>
			
			<cfset application.defaultProperties = structnew()/>
			
			<!--- dstype would be "xml" for xml storage, "rdbms" for MSSQL/MYSQL storage --->
			<cfset application.defaultProperties.dstype = "xml" />
			
			<!--- properties needed for xml storage --->
			<cfset application.defaultProperties.xmlstoragepath = expandPath('../feedviewer/data/xml/') />
			
			<!--- properties needed for rdbms storage --->
			<cfset application.defaultProperties.dsn = "dbAggregator_mssql"/>
			<cfset application.defaultProperties.dsvendor = "mssql"/>
			
			
			<cfset application.defaultProperties.styleSheetPath = "../feedviewer/view/css/style.css"/>
			
 			<cfset application.serviceDefinitionLocation = expandPath('../') & "feedviewer/services.xml"/>
			
			<cfset application.serviceFactory = createObject( 'component', 
				   		'coldspring.beans.DefaultXmlBeanFactory').init(structnew(),application.defaultProperties)/>
			
			
			<cfset application.serviceFactory.loadBeansFromXmlFile(application.serviceDefinitionLocation)/>
			
			<cfset application.appInitialized = true />
		</cfif>
	</cflock>
</cfif>


<cffunction name="getProperty" returntype="any" output="no">
	<cfargument name="propertyName" required="true" type="string"/>
	<cfargument name="defaultValue" required="false" default="" type="any"/>
	
	<cfif structKeyExists(application.defaultProperties,arguments.propertyName)>
		<cfreturn application.defaultProperties[arguments.propertyName]/>
	<cfelse>
		<cfreturn arguments.defaultValue/>
	</cfif>
	
</cffunction>




