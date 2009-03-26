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

  $Id: Record.cfc,v 1.1 2005/10/09 20:12:05 scottc Exp $
  $Log: Record.cfc,v $
  Revision 1.1  2005/10/09 20:12:05  scottc
  First commit of the record store example app. Contains a hopefully detailed readme file on usage.

  Revision 1.2  2005/10/09 19:01:32  chris
  Added proper licensing and switched to MethodInterceptor Araound Advice for logging

  Revision 1.1  2005/09/25 18:09:56  chris
  Adding Klondike Records aop demo app

--->

<cfcomponent displayname="Record" output="false">

	<cffunction name="init" access="public" returntype="net.klondike.component.Record" output="false">
		<cfargument name="recordID" type="numeric" required="false" default="0" />
		<cfargument name="artistID" type="numeric" required="false" default="0" />
		<cfargument name="genreID" type="numeric" required="false" default="0" />
		<cfargument name="title" type="string" required="false" default="" />
		<cfargument name="releaseDate" type="string" required="false" default="" />
		<cfargument name="image" type="string" required="false" default="" />
		<cfargument name="price" type="numeric" required="false" default="9.99" />
		<cfargument name="featured" type="boolean" required="false" default="false" />
		<cfset setRecordID(arguments.recordID) />
		<cfset setArtistID(arguments.artistID) />
		<cfset setGenreID(arguments.genreID) />
		<cfset setTitle(arguments.title) />
		<cfset setReleaseDate(arguments.releaseDate) />
		<cfset setImage(arguments.image) />
		<cfset setPrice(arguments.price) />
		<cfset setFeatured(arguments.featured) />
		<cfreturn this />
	</cffunction>

	<cffunction name="setRecordID" access="public" output="false" returntype="void" hint="I set the recordID in this instance">
		<cfargument name="recordID" type="numeric" required="true" />
		<cfset variables.recordID = arguments.recordID />
	</cffunction>

	<cffunction name="getRecordID" access="public" output="false" returntype="numeric" hint="I retrieve the recordID from this instance">
		<cfreturn variables.recordID />
	</cffunction>

	<cffunction name="hasId" access="public" output="false" returntype="boolean" hint="I retrieve whether this instance has an ID (whether it's new or not)">
		<cfreturn structKeyExists(this,"recordID") and variables.recordID gt 0/>
	</cffunction>

	<cffunction name="setArtistID" access="public" output="false" returntype="void" hint="I set the artistID in this instance">
		<cfargument name="artistID" type="numeric" required="true" />
		<cfset variables.artistID = arguments.artistID />
	</cffunction>

	<cffunction name="getArtistID" access="public" output="false" returntype="numeric" hint="I retrieve the artistID from this instance">
		<cfreturn variables.artistID />
	</cffunction>

	<cffunction name="setGenreID" access="public" output="false" returntype="void" hint="I set the genreID in this instance">
		<cfargument name="genreID" type="numeric" required="true" />
		<cfset variables.genreID = arguments.genreID />
	</cffunction>

	<cffunction name="getGenreID" access="public" output="false" returntype="numeric" hint="I retrieve the genreID from this instance">
		<cfreturn variables.genreID />
	</cffunction>

	<cffunction name="setTitle" access="public" output="false" returntype="void" hint="I set the title in this instance">
		<cfargument name="title" type="string" required="true" />
		<cfset variables.title = arguments.title />
	</cffunction>

	<cffunction name="getTitle" access="public" output="false" returntype="string" hint="I retrieve the title from this instance">
		<cfreturn variables.title />
	</cffunction>

	<cffunction name="setReleaseDate" access="public" output="false" returntype="void" hint="I set the releaseDate in this instance">
		<cfargument name="releaseDate" type="string" required="true" />
		<cfset variables.releaseDate = arguments.releaseDate />
	</cffunction>

	<cffunction name="getReleaseDate" access="public" output="false" returntype="string" hint="I retrieve the releaseDate from this instance">
		<cfreturn variables.releaseDate />
	</cffunction>

	<cffunction name="setImage" access="public" output="false" returntype="void" hint="I set the image in this instance">
		<cfargument name="image" type="string" required="true" />
		<cfset variables.image = arguments.image />
	</cffunction>

	<cffunction name="getImage" access="public" output="false" returntype="string" hint="I retrieve the image from this instance">
		<cfreturn variables.image />
	</cffunction>

	<cffunction name="setPrice" access="public" output="false" returntype="void" hint="I set the price in this instance">
		<cfargument name="price" type="string" required="true" />
		<cfset variables.price = arguments.price />
	</cffunction>

	<cffunction name="getPrice" access="public" output="false" returntype="string" hint="I retrieve the price from this instance">
		<cfreturn variables.price />
	</cffunction>

	<cffunction name="setFeatured" access="public" output="false" returntype="void" hint="I set the featured flag in this instance">
		<cfargument name="featured" type="boolean" required="true" />
		<cfset variables.featured = YesNoFormat(arguments.featured) />
	</cffunction>

	<cffunction name="isFeatured" access="public" output="false" returntype="boolean" hint="I retrieve the featured flag from this instance">
		<cfreturn variables.featured />
	</cffunction>

</cfcomponent>