<cffunction name="CheckCSRF" returntype="Boolean" output="true">
	<cfargument name="command" required="true" type="String">
	<!--- Check permissions, if necessary. --->
	<cfif listcontains("CopyFiles,CreateFolder,DeleteFiles,DeleteFolder,FileUpload,MoveFiles,RenameFile,RenameFolder,QuickUpload,SaveFile", command)>
		<cfset var $=application.serviceFactory.getBean('$').init(session.siteid)>
		<cfif not $.validateCSRFTokens(context='')>
			<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED#" type="ckfinder" />
		</cfif>
   	</cfif>

    <cfreturn true />
    
</cffunction>

<cfset REQUEST.CheckCSRF = CheckCSRF>

<cfset hook = arrayNew(1)>
<cfif not structkeyexists(config, "plugins")>
	<cfset config.plugins = arrayNew(1)>
</cfif>
<cfif not structkeyexists(config, "hooks")>
	<cfset config.hooks = arrayNew(1)>
</cfif>

<cfset ArrayAppend(config.plugins, 'csrf')>
<cfset hook[1] = "BeforeExecuteCommand">
<cfset hook[2] = "CheckCSRF">
<cfset ArrayAppend(config.hooks, hook)>
