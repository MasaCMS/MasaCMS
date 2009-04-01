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
<cfcomponent output="false" extends="mura.Factory">
	
	<cffunction name="get" access="public" returntype="any" output="false">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="context" type="any" required="false" />
		
		<cfset var hashKey = getHashKey( arguments.key ) />
		
		<!--- if the key cannot be found and context is passed then push it in --->
		<cfif NOT has( arguments.key ) AND isDefined( "arguments.context" )>
			<!--- create object --->
			<cfset variables.collection[ hashKey ] = arguments.context />
		</cfif>
		
		<!--- if the key cannot be found then throw an error --->
		<cfif NOT has( arguments.key )>
			<cfthrow message="Context not found for '#arguments.key#'" />
		</cfif>

		<!--- return cached context --->		
		<cfreturn variables.collection[ hashKey ] />

	</cffunction>

</cfcomponent>