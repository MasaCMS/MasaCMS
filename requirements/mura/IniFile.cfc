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

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfcomponent output="false">

	<!--- CONSTRUCTOR --->

	<cffunction name="init" output="false">
		<cfargument name="iniPath" type="string" required="true" hint="Mapped Path to an ini file." />
	
		<cfset var file = "" />
		<cfset var line = "" />
		<cfset var currentSection = "" />
		<cfset var entry = "" />
		<cfset var value = "" />

		
		<cfset variables.iniPath = arguments.iniPath />
		<cfset variables.ini = structNew() />


		<cffile variable="file" action="read" file="#variables.iniPath#"  />
		
		<!---
		<cfif NOT fileExists( variables.iniPath )>
			<cffile variable="file" action="write" file="#variables.iniPath#" output="" addnewline="false" />
			<cfreturn this />
		</cfif>
		
		<!--- Remove any pre-existing cfaborts--->
		<cfset cleanIni()>
		
		<cfsavecontent variable="file"><cfoutput><cfinclude template="#arguments.iniPath#"></cfoutput></cfsavecontent>
		--->
		<cfloop list="#file#" index="line" delimiters="#chr(10)##chr(13)#">
			<cfset line = trim( line ) />
			<cfif NOT ( startsWith( line, ";" ) OR startsWith( line, "##" ) OR startsWith( line, "<" ) )>
				<cfif startsWith( line, "[" ) AND find( "]", line, 2 ) GT 2>
					<cfset currentSection = mid( line, 2, find( "]", line, 2 ) - 2 ) />
					<cfset setSection( currentSection ) />
				<cfelseif find( "=", line ) GT 1 AND len( currentSection )>
					<cfset entry = trim( listFirst( line, "=" ) ) />
					<cfset value = "" />
					<cfif listLen( line, "=" ) GT 1>
						<cfset value = trim( listRest( line, "=" ) ) />
					</cfif>
					<cfset set( currentSection, entry, value ) />
				</cfif>
			</cfif>
		</cfloop>

		<cfreturn this />
	</cffunction>


	<!--- PUBLIC --->

	<cffunction name="get" output="false" hint="Get all INI data (no arguments); a section's data, as a struct (one argument, section name); or an entry's value (section and entry name arguments). Optionally pass a third argument to set/get a default value if requested entry doesn't exist.">
		<cfargument name="section" type="string" required="false" hint="Section name." />
		<cfargument name="entry" type="string" required="false" hint="Entry name." />
		<cfargument name="default" type="string" required="false" />

		<cfif NOT structKeyExists( arguments, "section" )>
			<cfreturn variables.ini />
		</cfif>

		<cfif NOT structKeyExists( arguments, "entry" )>
			<cfreturn variables.ini[ arguments.section ] />
		</cfif>

		<cfif structKeyExists( variables.ini[ arguments.section ], arguments.entry )>
			<cfreturn variables.ini[ arguments.section ][ arguments.entry ] />
		<cfelseif ( structKeyExists( arguments, "default" ) )>
			<cfset set( arguments.section, arguments.entry, arguments.default ) />
			<cfreturn arguments.default />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>


	<cffunction name="getSections" returntype="struct" output="false" hint="Returns a struct with section names and values set to list of section entry names. This behaves much like the CF built-in function getProfileSections().">
		<cfset var sections = structNew() />
		<cfset var sectionName = "" />

		<cfloop list="#structKeyList( variables.ini )#" index="sectionName">
			<cfset sections[ sectionName ] = structKeyList( variables.ini[ sectionName ] ) />
		</cfloop>

		<cfreturn sections />
	</cffunction>


	<cffunction name="set" output="false">
		<cfargument name="section" type="string" required="true" hint="Section name." />
		<cfargument name="entry" type="string" required="true" hint="Entry name." />
		<cfargument name="value" type="any" required="false" default="" hint="Property value" />

		<cfset setSection( arguments.section ) />

		<cfset variables.ini[ arguments.section ][ arguments.entry ] = arguments.value />
		<cfset setProfileString( variables.iniPath, arguments.section, arguments.entry, arguments.value ) />
	
		<cfreturn this />
	</cffunction>


	<!--- PRIVATE --->

	<cffunction name="setSection" returntype="void" output="false">
		<cfargument name="section" type="string" required="true" hint="Section name." />

		<cfif NOT structKeyExists( variables.ini, arguments.section )>
			<cfset variables.ini[ arguments.section ] = structNew() />
		</cfif>
	</cffunction>


	<cffunction name="startsWith" returntype="boolean" access="private" output="false">
		<cfargument name="str" type="string" required="true" hint="String to check." />
		<cfargument name="char" type="string" required="true" hint="Character to check for." />

		<cfreturn left( arguments.str, 1 ) EQ arguments.char />
	</cffunction>


	<cffunction name="cleanIni" returntype="void" output="false">
		<cfset var settingsFileContent = "" />
		
		<cffile action="read" file="#variables.iniPath#" variable="settingsFileContent" />
		
		<cfif findNoCase("cfabort",settingsFileContent)>
			<cfset settingsFileContent=replaceNoCase(settingsFileContent,"<cfabort>","","ALL")>
			<cfset settingsFileContent=replaceNoCase(settingsFileContent,"<cfabort/>","","ALL")>
			
			<!--- write the settings file back --->
			<cffile action="write" file="#variables.iniPath#" output="#trim( settingsFileContent )#">
		</cfif>
		
	</cffunction>
</cfcomponent>