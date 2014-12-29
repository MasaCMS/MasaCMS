<!---
 * Frostburg State University
 * Jonathan E Yoder
 * 07 March 2011
--->

<cfcomponent output="false" extends="CKFinder_Connector.CommandHandler.XmlCommandHandlerBase">

<cffunction access="public" name="buildXml" hint="send XML response" returntype="boolean" description="send response" output="false">

	<cfset var nodeFolder = XMLElemNew(THIS.xmlObject, "DefaultFolder") />
    <cfset var defaultDir = "" />
    <cfset var newFolderPath = "" />


	<!--- Find default image directory --->
    <cfset var usrGroups = application.usermanager.readMemberships(application.usermanager.getCurrentUserID())> 
    <cfif usrGroups.RecordCount gt 0>
        <cfset var usrBean = application.usermanager.read(usrGroups.groupid)>
            <cfset defaultDir = usrBean.getExtendedAttribute('defaultImageDir')>
    </cfif>
    
    <!--- Create default folder if it does not exist --->
	<cfif defaultDir neq "">
		<cfset newFolderPath = fileSystem.CombinePaths(THIS.currentFolder.getServerPath(), defaultDir) />
        <cfthrow message="#newFolderPath#"/>
	    <cfif not directoryExists(newFolderPath)>	
			<cfdirectory action="create" directory="#defaultDir#" mode="755">
        </cfif>
    </cfif>
    
    <cfscript>
		nodeFolder.xmlAttributes["path"] = defaultDir;
		ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, nodeFolder);
	</cfscript>

	<cfreturn true>
</cffunction>

</cfcomponent>
