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
<cftry>		
		<cffile action="write" file="#variables.baseDir#/plugins/mappings.cfm" output="<!--- Do Not Edit --->" addnewline="true" mode="775">
		<cffile action="append" file="#variables.baseDir#/plugins/mappings.cfm" output="<cfif not isDefined('this.name')>" addnewline="true" mode="775">
		<cffile action="append" file="#variables.baseDir#/plugins/mappings.cfm" output="<cfoutput>Access Restricted.</cfoutput>" addnewline="true" mode="775">
		<cffile action="append" file="#variables.baseDir#/plugins/mappings.cfm" output="<cfabort>" addnewline="true" mode="775">
		<cffile action="append" file="#variables.baseDir#/plugins/mappings.cfm" output="</cfif>" addnewline="true" mode="775">
		<cfcatch>
			<cfset canWriteMode=false>
			<cftry>
				<cffile action="write" file="#variables.baseDir#/plugins/mappings.cfm" output="<!--- Do Not Edit --->" addnewline="true">
				<cffile action="append" file="#variables.baseDir#/plugins/mappings.cfm" output="<cfif not isDefined('this.name')>" addnewline="true">
				<cffile action="append" file="#variables.baseDir#/plugins/mappings.cfm" output="<cfoutput>Access Restricted.</cfoutput>" addnewline="true">
				<cffile action="append" file="#variables.baseDir#/plugins/mappings.cfm" output="<cfabort>" addnewline="true">
				<cffile action="append" file="#variables.baseDir#/plugins/mappings.cfm" output="</cfif>" addnewline="true">
				<cfcatch>
					<cfset canWriteMappings=false>
				</cfcatch>
			</cftry>
		</cfcatch>
</cftry>
				
<cfdirectory action="list" directory="#variables.baseDir#/plugins/" name="rsRequirements">
				
<cfloop query="rsRequirements">
	<cfif rsRequirements.type eq "dir" and rsRequirements.name neq '.svn'>
		<cfset m=listFirst(rsRequirements.name,"_")>
		<cfif not isNumeric(m) and not structKeyExists(this.mappings,m)>
			<cfif canWriteMode>
				<cffile action="append" file="#variables.baseDir#/plugins/mappings.cfm" output='<cfset this.mappings["/#m#"] = variables.mapPrefix & variables.BaseDir & "/plugins/#rsRequirements.name#">' mode="775">
			<cfelseif canWriteMappings>
				<cffile action="append" file="#variables.baseDir#/plugins/mappings.cfm" output='<cfset this.mappings["/#m#"] = variables.mapPrefix & variables.BaseDir & "/plugins/#rsRequirements.name#">'>		
			</cfif>
			<cfset this.mappings["/#m#"] = variables.mapPrefix & rsRequirements.directory & "/" & rsRequirements.name>
		</cfif>
		
		<cfset currentDir="#variables.baseDir#/plugins/#rsRequirements.name#">
		<cfset currentConfigFile="#currentDir#/plugin/config.xml">
		<cfif fileExists(currentConfigFile)>
			<cffile action="read" variable="currentConfig" file="#currentConfigFile#">
			<cftry>
				<cfset currentConfig=xmlParse(currentConfig)>
				<cfcatch>
					<cfset currentConfig=structNew()>
				</cfcatch>
			</cftry>
		<cfelse>
			<cfset currentConfigFile="#currentDir#/plugin/config.xml.cfm">
			<cfif fileExists(currentConfigFile)>
				<cftry>
					<cfsavecontent variable="currentConfig"><cfoutput><cfinclude template="../plugins/#rsRequirements.name#/plugin/config.xml.cfm"></cfoutput></cfsavecontent>
					<cfset currentConfig=xmlParse(currentConfig)>
					<cfcatch>
						<cfset currentConfig=structNew()>
					</cfcatch>
				</cftry>
			<cfelse>
				<cfset currentConfig=structNew()>
			</cfif>
		</cfif>
		<cfif isDefined("currentConfig.plugin.mappings.mapping") and arrayLen(currentConfig.plugin.mappings.mapping)>
			<cfloop from="1" to="#arrayLen(currentConfig.plugin.mappings.mapping)#" index="m">
			<cfif structkeyExists(currentConfig.plugin.mappings.mapping[m].xmlAttributes,"directory")
			and len(currentConfig.plugin.mappings.mapping[m].xmlAttributes.directory)
			and structkeyExists(currentConfig.plugin.mappings.mapping[m].xmlAttributes,"name")
			and len(currentConfig.plugin.mappings.mapping[m].xmlAttributes.name)>
				<cfset p=currentConfig.plugin.mappings.mapping[m].xmlAttributes.directory>
				<cfif listFind("/,\",left(p,1))>
					<cfif len(p) gt 1>
						<cfset p=right(p,len(p)-1)>
					<cfelse>
						<cfset p="">
					</cfif>
				</cfif>
				<cfset currentPath=currentDir & "/" & p>
				<cfif len(p) and directoryExists(currentPath)>
					<cfset pluginmapping=currentConfig.plugin.mappings.mapping[m].xmlAttributes.name>
					<cfif canWriteMode>
						<cffile action="append" file="#variables.baseDir#/plugins/mappings.cfm" output='<cfif not structKeyExists(this.mappings,"/#pluginmapping#")><cfset this.mappings["/#pluginmapping#"] = variables.mapPrefix & variables.baseDir & "/plugins/#rsRequirements.name#/#p#"></cfif>' mode="775">
					<cfelseif canWriteMappings>
						<cffile action="append" file="#variables.baseDir#/plugins/mappings.cfm" output='<cfif not structKeyExists(this.mappings,"/#pluginmapping#")><cfset this.mappings["/#pluginmapping#"] = variables.mapPrefix & variables.baseDir & "/plugins/#rsRequirements.name#/#p#"></cfif>'>		
					</cfif>
				</cfif>
			</cfif>
			</cfloop>
		</cfif>
	</cfif>
</cfloop>