<cfcomponent output="false" extends="XmlCommandHandlerBase">
<!---
 * CKFinder
 * ========
 * http://cksource.com/ckfinder
 * Copyright (C) 2007-2014, CKSource - Frederico Knabben. All rights reserved.
 *
 * The software, this file and its contents are subject to the CKFinder
 * License. Please read the license.txt file before using, installing, copying,
 * modifying or distribute this file or part of its contents. The contents of
 * this file is part of the Source Code of CKFinder.
--->

<cfset THIS.mustCheckRequest = false>
<cfset THIS.mustAddCurrentFolderNode = false>
<cfset THIS.command = "Init" >

<cffunction access="public" name="buildXml" hint="send XML response" returntype="boolean" description="send response" output="true">

	<cfset var nodeConnectorInfo = XMLElemNew(THIS.xmlObject, "ConnectorInfo") />
	<cfset var acl = APPLICATION.CreateCFC("Core.AccessControlConfig") />
	<cfset var fileSystem = APPLICATION.CreateCFC("Utils.FileSystem") />
	<cfset var coreConfig = APPLICATION.CreateCFC("Core.Config")>
	<cfset var aclMask = 0 />
	<cfset var view = "" />
	<cfset var ln = "" />
	<cfset var lc = "" />
	<cfset var c = "" />
	<cfset var nodeResourcetype = "" />
	<cfset var thumbsUrl = "" />
	<cfset var maxSize = "0" />

	<cfset nodeConnectorInfo.xmlAttributes["enabled"] = REQUEST.CheckAuthentication() >
	<cfset nodeConnectorInfo.xmlAttributes["thumbsEnabled"] = THIS.config.thumbnails.enabled >

	<cfif THIS.config.thumbnails.enabled>
		<cfset nodeConnectorInfo.xmlAttributes["thumbsUrl"] = THIS.currentFolder.getThumbsUrl()>
		<cfset nodeConnectorInfo.xmlAttributes["thumbsDirectAccess"] = IIF((structkeyexists(REQUEST.config.thumbnails, "directAccess") and REQUEST.config.thumbnails.directAccess), "true", "false")>
		<cfif structkeyexists(REQUEST.config.thumbnails, "maxWidth") and REQUEST.config.thumbnails.maxWidth>
			<cfset nodeConnectorInfo.xmlAttributes["thumbsWidth"] = REQUEST.config.thumbnails.maxWidth>
		</cfif>
		<cfif structkeyexists(REQUEST.config.thumbnails, "maxHeight") and REQUEST.config.thumbnails.maxHeight>
			<cfset nodeConnectorInfo.xmlAttributes["thumbsHeight"] = REQUEST.config.thumbnails.maxHeight>
		</cfif>
	</cfif>

	<cfif structkeyexists(THIS.config, "plugins") and ArrayLen(THIS.config.plugins) gt 0>
		<cfset nodeConnectorInfo.xmlAttributes["plugins"] = ArrayToList(THIS.config.plugins) >
	</cfif>

	<cfscript>
		if (structkeyexists(THIS.config,"licenseKey") and issimplevalue(THIS.config.licenseKey)) {
			lc = THIS.config.licenseKey;
			c = (find(left(lc,1), REQUEST.constants.CKFINDER_CHARS) - 1) MOD 5;
			if ((c eq 1) or (c eq 4)) {
				ln = THIS.config.licenseName;
			}
			c = "";
		}
		if (Len(lc) gte 13) {
			c = Mid(lc, 12, 1) & Mid(lc, 1, 1) & Mid(lc, 9, 1) & Mid(lc, 13, 1) & Mid(lc, 27, 1) & Mid(lc, 3, 1) & Mid(lc, 4, 1) & Mid(lc, 26, 1) & Mid(lc, 2, 1);
		}

		nodeConnectorInfo.xmlAttributes["s"] = ln;
		nodeConnectorInfo.xmlAttributes["c"] = c;
		nodeConnectorInfo.xmlAttributes["imgWidth"] = THIS.config.images.maxWidth;
		nodeConnectorInfo.xmlAttributes["imgHeight"] = THIS.config.images.maxHeight;
		if (THIS.config.checkSizeAfterScaling) {
			nodeConnectorInfo.xmlAttributes["uploadCheckImages"] = "false";
		}
		else {
			nodeConnectorInfo.xmlAttributes["uploadCheckImages"] = "true";
		}
		ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, nodeConnectorInfo);
		nodeResourceTypes = XMLElemNew(THIS.xmlObject, "ResourceTypes");
		nodePluginsInfo = XMLElemNew(THIS.xmlObject, "PluginsInfo");
	</cfscript>

	<cfloop from="1" to="#arrayLen(THIS.config.resourceType)#" step="1" index="i">
		<cfif not ListLen(THIS.config.defaultResourceTypes) or ListContains(THIS.config.defaultResourceTypes,THIS.config.resourceType[i].name)>
			<cfif structkeyexists(THIS.config.resourceType[i], "maxSize")>
				<cfset maxSize = APPLICATION.CreateCFC("Utils.Misc").returnBytes(THIS.config.resourceType[i].maxSize) />
			<cfelse>
				<cfset maxSize = 0 />
			</cfif>
			<cfscript>
				if (not isDefined("URL.type") or URL.type eq THIS.config.resourceType[i].name) {
				aclMask = acl.getComputedMask(THIS.config.resourceType[i].name, "/");

				nodeResourceType = XMLElemNew(THIS.xmlObject, "ResourceType");
				nodeResourceType.xmlAttributes["name"] = THIS.config.resourceType[i].name;
				nodeResourceType.xmlAttributes["url"] = fileSystem.FixUrl(THIS.config.resourceType[i].url);
				nodeResourceType.xmlAttributes["hasChildren"] = fileSystem.hasChildren(coreConfig, "/", THIS.config.resourceType[i].directory, THIS.config.resourceType[i].name);
				nodeResourceType.xmlAttributes["allowedExtensions"] = THIS.config.resourceType[i].allowedExtensions;
				nodeResourceType.xmlAttributes["deniedExtensions"] = THIS.config.resourceType[i].deniedExtensions;
				nodeResourceType.xmlAttributes["hash"] = Mid(Hash(THIS.currentFolder.getServerPath(THIS.config.resourceType[i])), 1, 16);
				nodeResourceType.xmlAttributes["acl"] = aclMask;
				nodeResourceType.xmlAttributes["maxSize"] = maxSize;
				ArrayAppend(nodeResourceTypes.xmlChildren, nodeResourceType);
				}
			</cfscript>
		</cfif>
	</cfloop>

	<cfscript>
		ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, nodeResourceTypes);
		ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, nodePluginsInfo);
	</cfscript>

	<cfset REQUEST.oHooks.run('InitCommand', THIS.xmlObject)>

	<cfreturn true>
</cffunction>

</cfcomponent>
