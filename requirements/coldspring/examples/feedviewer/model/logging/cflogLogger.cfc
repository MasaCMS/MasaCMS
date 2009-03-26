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
		
			
 $Id: cflogLogger.cfc,v 1.2 2005/09/26 02:01:07 rossd Exp $

--->

<cfcomponent name="CFLOG Logger" output="false" extends="coldspring.examples.feedviewer.model.logging.logger">
	
	<!--- internal log levels: 
		
		debug:4
		info:3
		warning:2
		error:1
		fatal:0
		
		--->
	
	<cffunction name="init" access="public" returntype="coldspring.examples.feedviewer.model.logging.cfloglogger" output="false">
		<cfargument name="logFileName" type="string" required="false" default=""/>
		<cfargument name="logLevel" type="string" required="false" default="error"/>
		
		<cfif not len(arguments.logFileName) and isDefined("application.applicationName")>
			<cfset arguments.logFileName = application.applicationName/>
		</cfif>
		
		
		<cfset variables.logLevels = structnew()>
		<cfset variables.logLevels["debug"]   = 4 />
		<cfset variables.logLevels["info"]    = 3 />
		<cfset variables.logLevels["warning"] = 2 />
		<cfset variables.logLevels["error"]   = 1 />
		<cfset variables.logLevels["fatal"]   = 0 />
		
		<cfset variables.logLevelTypes = structnew()>
		<cfset variables.logLevelTypes["debug"]   = "Information" />
		<cfset variables.logLevelTypes["info"]    = "Information" />
		<cfset variables.logLevelTypes["warning"] = "Warning" />
		<cfset variables.logLevelTypes["error"]   = "Error" />
		<cfset variables.logLevelTypes["fatal"]   = "Fatal" />	
		
		<cfset setLogName(arguments.logFileName)/>
		<cfset setLogLevel(arguments.logLevel)/>
		
		<cfreturn this/>
	
	</cffunction>
	
	<cffunction name="setLogName" returntype="void" output="false" hint="I set the name of the log file" access="public">
		<cfargument name="logFileName" type="string" required="true"/>
				
		<cfset variables.logName = arguments.logFileName/>
		
	</cffunction>
	
	<cffunction name="setLogLevel" returntype="void" output="false" hint="I set the amount of information to be logged" access="public">
		<cfargument name="logLevel" type="string" required="true"/>
		<cfif structKeyExists(variables.logLevels,arguments.logLevel)>
			<cfset variables.logLevelSetting = variables.logLevels[arguments.logLevel]/>
		<cfelse>
			<cfthrow message="Log.InvalidLogLevel"/>		
		</cfif>
	</cffunction>
	
	<cffunction name="debug" returntype="void" output="false" hint="I send debug information to the log" access="public">
		<cfargument name="message" type="string" required="true" hint="I am the message to be logged"/>
		<cfset writeLog("debug", "DEBUG: #arguments.message#")/>
	</cffunction>
	
	<cffunction name="info" returntype="void" output="false" hint="I send information to the log" access="public">
		<cfargument name="message" type="string" required="true" hint="I am the message to be logged"/>
		<cfset writeLog("info", arguments.message)/>
	</cffunction>

	<cffunction name="warning" returntype="void" output="false" hint="I send warning information to the log" access="public">
		<cfargument name="message" type="string" required="true" hint="I am the message to be logged"/>
		<cfset writeLog("warning", arguments.message)/>
	</cffunction>

	<cffunction name="error" returntype="void" output="false" hint="I send warning information to the log" access="public">
		<cfargument name="message" type="string" required="true" hint="I am the message to be logged"/>
		<cfset writeLog("error", arguments.message)/>
	</cffunction>
		
	<cffunction name="fatal" returntype="void" output="false" hint="I send fatal error information to the log" access="public">
		<cfargument name="message" type="string" required="true" hint="I am the message to be logged"/>
		<cfset writeLog("fatal", arguments.message)/>
	</cffunction>	
	
	<cffunction name="writeLog" access="private" returntype="void">
		<cfargument name="level" type="string" required="true" hint="I am the level of the supplied logging information"/>
		<cfargument name="message" type="string" required="true" hint="I am the message to be logged"/>
		
		<cfif variables.logLevels[arguments.level] LTE variables.logLevelSetting>
			<cflog application="true"
					type="#variables.logLevelTypes[arguments.level]#"
					file="#variables.logName#"
					text="#arguments.message#"/>
		</cfif>
	
	</cffunction>
	 
	
	
</cfcomponent>
