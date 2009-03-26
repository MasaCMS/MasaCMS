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
		
			
 $Id: channelDAO.cfc,v 1.2 2005/09/26 02:01:05 rossd Exp $

--->

<cfcomponent name="Abstract channel DAO" output="false">
	
	<cffunction name="init" access="private">
		<cfthrow type="Method.NotImplemented">
	</cffunction>
	
	<cffunction name="fetch" returntype="coldspring.examples.feedviewer.model.channel.channel" output="false" access="public" hint="I retrieve a channel">
		<cfargument name="channelIdentifier" type="any" required="true" hint="I am the unique ID of the channel to be retrieved"/>
		<cfthrow message="Method.NotImplemented"/>
	</cffunction>

	<cffunction name="save" returntype="void" output="false" access="public" hint="I save a channel">
		<cfargument name="channel" type="coldspring.examples.feedviewer.model.channel.channel" hint="I am the channel to be saved" required="true"/>
		<cfthrow message="Method.NotImplemented"/>
	</cffunction>
	
	<cffunction name="remove" returntype="void" output="false" access="public" hint="I remove a channel">
		<cfargument name="channel" type="coldspring.examples.feedviewer.model.channel.channel" hint="I am the channel to be removed" required="true"/>
		<cfthrow message="Method.NotImplemented"/>
	</cffunction>
	
</cfcomponent>