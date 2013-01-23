<!---
 * Frostburg State University
 * Jonathan E Yoder
 * 07 March 2011
--->

<!--- Extend the XmlCommandHandlerBase --->
<cfcomponent output="false" extends="CKFinder_Connector.CommandHandler.XmlCommandHandlerBase">

	<!--- JEYODER function to check for permissions --->
    <cffunction name="hasPermission" access="public" hint="returns true if user has permissions of at least the specified level for the specified file/folder" returntype="boolean" output="false">
        <cfargument name="folderPath" required="true" type="String">
        <cfargument name="permLevel" required="true" type="String">

		<cfset var assetpath = application.configBean.getAssetPath() & "/" & session.siteid & "/assets/">
        <cfset arguments.folderPath = replace(arguments.folderPath, assetpath, "", "all")>
        <cfset var permis = application.permUtility.getFilePermissions(session.siteid, arguments.folderPath)>
        
        <cfset var bRet = false>
        <cfswitch expression="#arguments.permLevel#">
            <cfcase value="editor">
                <cfset bRet = FindNoCase(permis, "editor") gt 0>
            </cfcase>
            <cfcase value="author">
                <cfset bRet = FindNoCase(permis, "editor,author") gt 0>
            </cfcase>
            <cfcase value="read">
                <cfset bRet = FindNoCase(permis, "editor,author,read") gt 0>
            </cfcase>
            <cfcase value="deny">
                <cfset bRet = FindNoCase(permis, "editor,author,read,deny") gt 0>
            </cfcase>
        </cfswitch>
        
        <cfreturn bRet>
    
    </cffunction>
    
    <!--- JEYODER function to check if a folder is empty --->
    <cffunction name="isFolderEmpty" access="public" hint="returns true if the specified folder is empty" returntype="boolean" output="false">
        <cfargument name="folderPath" required="true" type="String">
    
        <cfdirectory directory="#folderPath#" name="test">
        <cfset var bRet =  test.recordCount lte 0>
        
        <cfreturn bRet>
    
    </cffunction>
    
    <cffunction name="checkPerms">
    	<cfargument name="command" required="true" type="string">

		<cfset var fileSystem = APPLICATION.CreateCFC("Utils.FileSystem") />
	    <cfif listFindNoCase("CreateFolder,DeleteFiles", arguments.command)>
			<cfif not hasPermission(THIS.currentFolder.getURL(), "editor")>
                <cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED#" type="ckfinder" />
            </cfif>
         <cfelseif arguments.command eq 'CopyFiles'>
            <cfif not (hasPermission(THIS.currentFolder.getURL(), "editor") and hasPermission("#APPLICATION.CreateCFC("Core.Config").getResourceTypeConfig(url.type).url##form['FILES[0][FOLDER]']#","read"))>
                <cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED#" type="ckfinder" />
            </cfif>
        <cfelseif arguments.command eq "DeleteFolder">
            <cfif not hasPermission(THIS.currentFolder.getURL(), "editor")>
                <cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED#" type="ckfinder" />
            </cfif>
            <cfif not isFolderEmpty(THIS.currentFolder.getServerPath())>
                <cfthrow message="Cannot delete folder since it is not empty." />
            </cfif>        	
        <cfelseif listFindNoCase("FileUpload,RenameFile,RenameFolder",arguments.command)>
			<cfif not hasPermission(THIS.currentFolder.getURL(), "author")>
                <cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED#" type="ckfinder" />
            </cfif>
        <cfelseif arguments.command eq "GetFiles">
			<cfif not hasPermission(THIS.currentFolder.getURL(), "read")>
                <cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED#" type="ckfinder" />
            </cfif>
        <cfelseif arguments.command eq "MoveFiles">
            <cfif not (hasPermission(THIS.currentFolder.getURL(), "editor") and hasPermission("#APPLICATION.CreateCFC("Core.Config").getResourceTypeConfig(url.type).url##form['FILES[0][FOLDER]']#","editor"))>
                <cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED#" type="ckfinder" />
            </cfif>
         <cfelseif arguments.command eq "Permissions">
            <cfif not(application.permUtility.isUserInGroup('Admin',session.siteid,1) or application.permUtility.isS2())>
                <cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED#" type="ckfinder" />
            </cfif>
         </cfif>
    </cffunction>
    
    
    <cffunction access="public" name="buildXml" hint="send XML response" returntype="boolean" description="send response" output="false">
    
    	<!--- Gather directory information --->
        <cfscript>
			var nodeFolder = XMLElemNew(THIS.xmlObject, "Path");
			var assetpath = application.configBean.getAssetPath() & "/" & session.siteid & "/assets/";
			var subdir = replace(THIS.currentFolder.getURL(), assetpath, "");
			if (right(subdir, 1) == "/") subdir = left(subdir, len(subdir)-1);
			var editFileName = reverse(spanexcluding(reverse(subdir), "/"));
			if (len(subdir) > len(editFileName))
				subdir = left(subdir, len(subdir) - len(editFileName) - 1);
			else
				subdir = "";
            nodeFolder.xmlAttributes["subdir"] = subdir;
			nodeFolder.xmlAttributes["editFileName"] = editFileName;
            ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, nodeFolder);
        </cfscript>
        
		<!--- Build list of attributes for looking up directory --->        
        <cfset var attributes = structnew()>
        <cfset attributes.siteid = session.siteid>
        <cfset attributes.subdir = subdir>
        <cfset attributes.editFileName = editFileName>
    
    	<!--- List groups --->
		<cfset request.groups=application.permUtility.getGroupList(attributes) />
		<cfset request.rslist=request.groups.privateGroups />

		<!--- Get content id for file --->
        <cfset attributes.contentid = application.permUtility.getDirectoryId(attributes) />

		<!--- Labels --->
		<cfscript>
			var nodeLabels = XMLElemNew(THIS.xmlObject, "Labels");
			nodeLabels.xmlAttributes["admingroups"] = application.rbFactory.getKeyValue(session.rb,'user.admingroups');
			nodeLabels.xmlAttributes["membergroups"] = application.rbFactory.getKeyValue(session.rb,'user.membergroups');
			nodeLabels.xmlAttributes["permissions"] = application.rbFactory.getKeyValue(session.rb,'permissions');
			nodeLabels.xmlAttributes["editor"] = application.rbFactory.getKeyValue(session.rb,'permissions.editor');
			nodeLabels.xmlAttributes["author"] = application.rbFactory.getKeyValue(session.rb,'permissions.author');
			nodeLabels.xmlAttributes["inherit"] = application.rbFactory.getKeyValue(session.rb,'permissions.inherit');
			nodeLabels.xmlAttributes["readonly"] = application.rbFactory.getKeyValue(session.rb,'permissions.readonly');
			nodeLabels.xmlAttributes["deny"] = application.rbFactory.getKeyValue(session.rb,'permissions.deny');
			nodeLabels.xmlAttributes["group"] = application.rbFactory.getKeyValue(session.rb,'permissions.group');
			nodeLabels.xmlAttributes["dircontentid"] = attributes.contentid;
			ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, nodeLabels);
		</cfscript>

		<!--- Private Groups --->
		<cfset var private = XMLElemNew(THIS.xmlObject, "Private")>
        <cfif request.rslist.recordcount>
            <cfloop query="request.rslist">
                <cfset var perm=application.permUtility.getGroupPerm(request.rslist.userid,attributes.contentid,attributes.siteid)/>
                <cfscript>
					var node = XMLElemNew(THIS.xmlObject, "Group");
					node.xmlText = request.rslist.GroupName;
					node.xmlAttributes["perm"] = perm;
					node.xmlAttributes["groupid"] = request.rslist.UserID;
					ArrayAppend(private.xmlChildren, node);
				</cfscript>
            </cfloop>
        </cfif>
        <cfset ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, private)>
        
		<!--- Public Groups --->
        <cfset request.rslist=request.groups.publicGroups />
		<cfset var private = XMLElemNew(THIS.xmlObject, "Public")>
        <cfif request.rslist.recordcount>
            <cfloop query="request.rslist">
                <cfset var perm=application.permUtility.getGroupPerm(request.rslist.userid,attributes.contentid,attributes.siteid)/>
                <cfscript>
					var node = XMLElemNew(THIS.xmlObject, "Group");
					node.xmlText = request.rslist.GroupName;
					node.xmlAttributes["perm"] = perm;
					node.xmlAttributes["groupid"] = request.rslist.UserID;
					ArrayAppend(private.xmlChildren, node);
				</cfscript>
            </cfloop>
        </cfif>
        <cfset ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, private)>
        
        <cfreturn true>
    </cffunction>    
    
</cfcomponent>


