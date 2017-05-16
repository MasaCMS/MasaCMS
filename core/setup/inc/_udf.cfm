<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. ?See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. ?If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and
conditions of the GNU General Public License version 2 (?GPL?) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, ?the copyright holders of Mura CMS grant you permission
to combine Mura CMS ?with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the ?/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/admin/
/tasks/
/config/
/core/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 ?without this exception. ?You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<!--- few minor functions --->
<cffunction name="cleanIni" returntype="void" output="false">
  <cfargument name="iniPath" type="string" required="true" />
  <cfset var abort = "" />
  <cfset var settingsFileContent = "" />
  <cfset var newSettingsFileContent = "" />
  <!--- read ini --->
  <cffile action="read" file="#arguments.iniPath#" variable="settingsFileContent" />
  <!--- rewrite the settings file if necessary --->
  <cfset abort = "<cf" & "abort/>" />
  <!--- check to see if cfabort is in the file --->
  <cfif left( trim( settingsFileContent ), len( abort ) ) IS NOT "<cfabort/>">
    <!--- prepend content --->
    <cfsavecontent variable="newSettingsFileContent">
      <cfoutput>#abort##chr(10)##settingsFileContent#</cfoutput>
    </cfsavecontent>
    <!--- write the settings file back --->
    <cffile action="write" file="#arguments.iniPath#" output="#trim( newSettingsFileContent )#">
  </cfif>
</cffunction>
<cffunction name="keepSingleQuotes" returntype="string" output="false">
  <cfargument name="str">
  <cfreturn preserveSingleQuotes(arguments.str)>
</cffunction>
<cffunction name="mssqlFormat" returntype="string" output="false">
  <cfargument name="str">
  <cfargument name="version">
  <cfif arguments.version eq 8>

    <!--- mssql 2000 does not support nvarchar(max) or varbinary(max)--->

    <cfset arguments.str=replaceNoCase(arguments.str,"[nvarchar] (max)","[ntext]","ALL")>
    <cfset arguments.str=replaceNoCase(arguments.str,"[varbinary] (max) null","[image] null","ALL")>
  </cfif>
  <cfreturn preserveSingleQuotes(arguments.str)>
</cffunction>
<cffunction name="recordError" returntype="string" output="false">
  <cfargument name="data" type="any" required="true" />
  <cfset var str = "" />
  <cfset var errorFile = "" />
  <cfset var dir = "" />
  <cfif server.coldfusion.productname eq "BlueDragon">
    <cfset errorFile = "#ExpandPath('.')#/core/setup/errors/#createUUID()#_error.html" />
    <cfelse>
    <cfset errorFile = "#getDirectoryFromPath( getCurrentTemplatePath() )#errors/#createUUID()#_error.html" />
  </cfif>
  <!--- make sure the error directory exists --->
  <cfset dir = getDirectoryFromPath(errorFile) />
  <cfif not directoryExists(dir)>
    <cfdirectory action="create" directory="#dir#" />
  </cfif>
  <!--- dump the error into a variable --->
  <cfsavecontent variable="str">
    <cfdump var="#arguments.data#">
  </cfsavecontent>
  <!--- write the file --->
  <cffile action="write" file="#errorFile#" output="#str#" />
  <!--- send back the location --->
  <cfreturn errorFile />
</cffunction>