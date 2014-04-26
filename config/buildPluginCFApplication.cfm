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
<!---
Build a temporary file, and swap it out at the end, to reduce the potential for
the rest of the app to read a half-written file.
--->
<cflock name="buildPluginCFApplication" type="exclusive" throwontimeout="true" timeout="5" >
<cfset pluginCfapplicationFilePathName = "#variables.baseDir#/plugins/cfapplication.cfm" /> 
<cfset pluginCfapplicationTempFilePathName = "#variables.baseDir#/plugins/cfapplication.tmp.cfm" /> 
<cftry>

		<cfif not directoryExists("#variables.baseDir#/plugins")>
    		<cfdirectory action="create" directory="#variables.baseDir#/plugins">
		</cfif>
		
		<cffile action="write" file="#pluginCfapplicationTempFilePathName#" output="<!--- Do Not Edit --->" addnewline="true" mode="775">
		<cffile action="append" file="#pluginCfapplicationTempFilePathName#" output="<cfif not isDefined('this.name')>" addnewline="true" mode="775">
		<cffile action="append" file="#pluginCfapplicationTempFilePathName#" output="<cfoutput>Access Restricted.</cfoutput>" addnewline="true" mode="775">
		<cffile action="append" file="#pluginCfapplicationTempFilePathName#" output="<cfabort>" addnewline="true" mode="775">
		<cffile action="append" file="#pluginCfapplicationTempFilePathName#" output="</cfif>" addnewline="true" mode="775">
		<cffile action="append" file="#pluginCfapplicationTempFilePathName#" output="<cfset pluginDir=getDirectoryFromPath(getCurrentTemplatePath())/>" addnewline="true" mode="775">
		<cfcatch>
			<cfset canWriteMode=false>
			<cftry>
				<cffile action="write" file="#pluginCfapplicationTempFilePathName#" output="<!--- Do Not Edit --->" addnewline="true">
				<cffile action="append" file="#pluginCfapplicationTempFilePathName#" output="<cfif not isDefined('this.name')>" addnewline="true">
				<cffile action="append" file="#pluginCfapplicationTempFilePathName#" output="<cfoutput>Access Restricted.</cfoutput>">
				<cffile action="append" file="#pluginCfapplicationTempFilePathName#" output="<cfabort>" addnewline="true">
				<cffile action="append" file="#pluginCfapplicationTempFilePathName#" output="</cfif>" addnewline="true">
				<cffile action="append" file="#pluginCfapplicationTempFilePathName#" output="<cfset pluginDir=getDirectoryFromPath(getCurrentTemplatePath())/>" addnewline="true">
				<cfcatch>
					<cfset canWriteMappings=false>
				</cfcatch>
			</cftry>
		</cfcatch>
</cftry>
				
<cfdirectory action="list" directory="#variables.baseDir#/plugins/" name="rsRequirements">
				
<cfloop query="rsRequirements">
	<cfif rsRequirements.type eq "dir" and rsRequirements.name neq '.svn'>
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
				<cffile action="read" variable="currentConfig" file="#currentConfigFile#">
				<cftry>
					<cfset currentConfig=xmlParse(currentConfig)>
					<cfcatch>
						<cfset currentConfig=structNew()>
					</cfcatch>
				</cftry>
			<cfelse>
				<cfset currentConfig=structNew()>
			</cfif>
		</cfif>	
		<cfif isDefined("currentConfig.plugin.customtagpaths.xmlText") and len(currentConfig.plugin.customtagpaths.xmlText)>
			<cfloop list="#currentConfig.plugin.customtagpaths.xmlText#" index="p">
			<cfif listFind("/,\",left(p,1))>
				<cfif len(p) gt 1>
					<cfset p=right(p,len(p)-1)>
				<cfelse>
					<cfset p="">
				</cfif>
			</cfif>
			<cfset currentPath=currentDir & "/" & p>
			<cfif len(p) and directoryExists(currentPath)>
				<cfif canWriteMode>
					<cffile action="append" file="#pluginCfapplicationTempFilePathName#" output='<cfset this.customtagpaths = listAppend(this.customtagpaths, pluginDir & "/#rsRequirements.name#/#p#")>' mode="775">
				<cfelseif canWriteMappings>
					<cffile action="append" file="#pluginCfapplicationTempFilePathName#" output='<cfset this.customtagpaths = listAppend(this.customtagpaths,pluginDir & "/#rsRequirements.name#/#p#")>'>		
				</cfif>
				<cfset this.customtagpaths = listAppend(this.customtagpaths,variables.BaseDir & "/plugins/#rsRequirements.name#/#p#")>
			</cfif>
			</cfloop>
		</cfif>
		<cfif isDefined("currentConfig.plugin.ormcfclocation.xmlText") and len(currentConfig.plugin.ormcfclocation.xmlText)>
			<cfloop list="#currentConfig.plugin.ormcfclocation.xmlText#" index="p">
			<cfif listFind("/,\",left(p,1))>
				<cfif len(p) gt 1>
					<cfset p=right(p,len(p)-1)>
				<cfelse>
					<cfset p="">
				</cfif>
			</cfif>
			<cfset currentPath=currentDir & "/" & p>
			<cfif len(p) and directoryExists(currentPath)>
				<cfif canWriteMode>
					<cffile action="append" file="#pluginCfapplicationTempFilePathName#" output='<cfset arrayAppend(this.ormsettings.cfclocation,pluginDir & "/#rsRequirements.name#/#p#")>' mode="775">
				<cfelseif canWriteMappings>
					<cffile action="append" file="#pluginCfapplicationTempFilePathName#" output='<cfset arrayAppend(this.ormsettings.cfclocation,pluginDir & "/#rsRequirements.name#/#p#")>'>		
				</cfif>
				<cfset arrayAppend(this.ormsettings.cfclocation,variables.baseDir & "/plugins/#rsRequirements.name#/#p#")>
			</cfif>
			</cfloop>
		</cfif>
	</cfif>
</cfloop>

<!--- Swap out the real file with the temporary file. --->
<cffile action="rename" source="#pluginCfapplicationTempFilePathName#" destination="#pluginCfapplicationFilePathName#" />

</cflock>