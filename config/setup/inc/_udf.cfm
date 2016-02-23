
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
    <cfset errorFile = "#ExpandPath('.')#/config/setup/errors/#createUUID()#_error.html" />
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