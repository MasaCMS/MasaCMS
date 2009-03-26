<!--- 
	  
  Copyright (c) 2005, Chris Scott, David Ross
  All rights reserved.
	
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
       http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

  $Id: CatalogListener.cfc,v 1.1 2005/10/10 02:03:15 rossd Exp $
  $Log: CatalogListener.cfc,v $
  Revision 1.1  2005/10/10 02:03:15  rossd
  ok, moved all controller cfcs into net/klondike/controller

  Revision 1.1  2005/10/10 01:52:05  rossd
  renamed /model to /controller to reflect best practice

  Revision 1.1  2005/10/09 20:12:06  scottc
  First commit of the record store example app. Contains a hopefully detailed readme file on usage.

  Revision 1.5  2005/10/09 19:01:32  chris
  Added proper licensing and switched to MethodInterceptor Araound Advice for logging


--->
 
<cfcomponent displayname="CatalogListener" 
			extends="MachII.framework.Listener" 
			output="false">
	
	<cffunction name="configure" access="public" returntype="void" output="false">
		<cfset var sf = getProperty( 'serviceFactory' ) />
		<cfset variables.catalogService = sf.getBean('catalogService') />
	</cffunction>
	
	<cffunction name="getGenres" access="public" returntype="struct" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		<cfreturn variables.catalogService.getGenres() />
	</cffunction>
	
	<cffunction name="getArtists" access="public" returntype="struct" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		<cfreturn variables.catalogService.getArtists() />
	</cffunction>
	
	<cffunction name="getHighlights" access="public" returntype="array" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		<cfreturn variables.catalogService.getHighlights() />
	</cffunction>
	
	<cffunction name="getRecords" access="public" returntype="array" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		<cfset var artist = event.getArg('arID',0) />
		<cfset var genre = event.getArg('gnID',0) />
		<cfreturn variables.catalogService.getRecords(artist,genre) />
	</cffunction>
	
	<cffunction name="getRecordForID" access="public" returntype="net.klondike.component.Record" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		<cfset recordID = event.getArg('rdID') />
		<cfreturn variables.catalogService.fetchRecord(recordID) />
	</cffunction>
	
	<cffunction name="saveRecord" access="public" returntype="void" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		<cfset record = event.getArg('record') />
		<cfreturn variables.catalogService.saveRecord(record) />
	</cffunction>

</cfcomponent>