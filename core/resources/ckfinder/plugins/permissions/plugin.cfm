<!---
 * Frostburg State University
 * Jonathan E Yoder
 * 07 March 2011
--->
<cffunction name="CheckCommand" returntype="Boolean" output="true">
	<cfargument name="command" required="true" type="String">

	<!--- Check permissions, if necessary. --->
	<cfif listcontains("CopyFiles,CreateFolder,DeleteFiles,DeleteFolder,FileUpload,GetFiles,MoveFiles,RenameFile,RenameFolder", command)>
    	<cfset oPerm = CreateObject("component", "Permission")>
        <cfset oPerm.checkPerms(arguments.command)>
    <cfelseif command eq "GetDefaultPath">
    	<cfset oPath = CreateObject("component", "GetDefaultPath")>
        <cfset oPath.sendResponse()>
        <cfreturn false />
    <cfelseif command eq "Permissions">
    	<cfset oPerm = CreateObject("component", "Permission")>
        <cfset oPerm.checkPerms(arguments.command)>
        <cfset oPerm.sendResponse()>
        <cfreturn false />
    <cfelseif command eq "PermChange">
    	<cfset oPerm = CreateObject("component", "PermChange")>
        <cfset oPerm.sendResponse()>
        <cfreturn false />
   	</cfif>

    <cfreturn true />
    
</cffunction>

<cfset REQUEST.CheckCommand = CheckCommand>

<cfset hook = arrayNew(1)>
<cfif not structkeyexists(config, "plugins")>
	<cfset config.plugins = arrayNew(1)>
</cfif>
<cfif not structkeyexists(config, "hooks")>
	<cfset config.hooks = arrayNew(1)>
</cfif>

<cfset ArrayAppend(config.plugins, 'permissions')>
<cfset hook[1] = "BeforeExecuteCommand">
<cfset hook[2] = "CheckCommand">
<cfset ArrayAppend(config.hooks, hook)>

