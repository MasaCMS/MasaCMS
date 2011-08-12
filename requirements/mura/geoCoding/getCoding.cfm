<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<form action="getCoding.cfm" method="post">
	Latitude: <input type="Text" name="Latitude"><br>
	Longitude:  <input type="Text" name="Longitude"><br>
	Radius: <input type="text" name="radius"><br>
	<input type="submit" value="check">
</form>

<cfif isDefined("form.latitude")>
	<cfset qry = getPerimeterMatches(form.longitude, form.latitude, form.radius)>
	<cfdump var="#qry#">
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