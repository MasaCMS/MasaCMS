<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->
<form action="getCoding.cfm" method="post">
	Latitude: <input type="Text" name="Latitude"><br>
	Longitude:  <input type="Text" name="Longitude"><br>
	Radius: <input type="text" name="radius"><br>
	<input type="submit" value="check">
</form>

<cfif isDefined("form.latitude")>
	<cfset qry = getPerimeterMatches(form.longitude, form.latitude, form.radius)>
	<cfdump eval=qry>
</cfif>

<cffunction name="getPerimeterMatches" hint="Returns all Records that match a certain radius from a given location" returntype="query">
	<cfargument name="centerLongitude" type="numeric" required="Yes">
	<cfargument name="centerLatitude" type="numeric" required="Yes">
	<cfargument name="radius" type="numeric" required="Yes">
	<!--- This is the length of on degree at the equator. In KM it's 111.12 and in miles I guess 69 --->
	<!--- <cfset var oneDegree = 111.12> --->
	<cfset var oneDegree = 69>
	<!--- This query is quite sophisticated. It assumes that the database has five fields (therefore just adjust it accordingly)
		- ID
		- Name
		- address
		- longitude
		- latitude
		In addition we assume that below a range of 500 Miles the Earth can be considered as flat, so that we can use Pythagoras
	 --->
	 <cfset var getMatches = "">
	 <cfset var getSortedMatches = "">
	 <cfquery name="getMatches" datasource="addresses">
	 	SELECT	ID, name, address,
				sqrt(
					power(abs(latitude - #arguments.centerLatitude#), 2) + 
					power(abs(longitude - #arguments.centerLongitude#), 2) * 
					power(cos(longitude + #arguments.centerLongitude# / 2), 2)
					) * #oneDegree# As Distance
		FROM	addresses
		WHERE	
			sqrt(
				power(abs(latitude - #arguments.centerLatitude#), 2) + 
				power(abs(longitude - #arguments.centerLongitude#), 2) * 
				power(cos(longitude + #arguments.centerLongitude# / 2), 2)
				) * #oneDegree# <= #arguments.radius#
	 </cfquery>
	<cfquery name="getSortedMatches" dbtype="query">
		Select * from getMatches Order by Distance
	</cfquery>
	<cfreturn getSortedMatches>
</cffunction>