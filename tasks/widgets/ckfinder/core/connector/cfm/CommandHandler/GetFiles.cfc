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
<cfset THIS.command = "GetFiles" >
<!---
Hack for CF 6.1 bug in localised datelastmodified
http://livedocs.adobe.com/coldfusion/6.1/htmldocs/tags-a20.htm
--->
<cffunction access="public" name="udflsparsedatetime" return="date">
	<cfargument name="str" required="yes">
	<cfobject type="java" class="java.text.DateFormat" action="create" name="df">
	<cfset fulldf = df.getDateTimeInstance(df.FULL, df.FULL)>
	<cfreturn fulldf.parse(str)>
</cffunction>

<cffunction access="public" name="buildXml" hint="send XML response" returntype="boolean" description="send response" output="true">

	<cfset var modified = arrayNew(1) />
	<cfset var i = 1 />
	<cfset var nodefile = "" />
	<cfset var folderPath = THIS.currentFolder.getServerPath() />
	<cfset var nodeFiles = XMLElemNew(THIS.xmlObject, "Files") />
	<cfset var utils = APPLICATION.CreateCFC("Utils.Misc") />
	<cfset var datemodified="" />
	<cfset var fileSystem = APPLICATION.CreateCFC("Utils.FileSystem") />
	<cfset var coreConfig = APPLICATION.CreateCFC("Core.Config") />
	<cfset var thumbsPath = "" />
	<cfset var thumbName = "" />
	<cfset var directThumbAccess = false />
	<cfset var showThumbs = false />
	<cfif not THIS.currentFolder.checkAcl(REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_VIEW) >
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED#" type="ckfinder" />
	</cfif>

	<cfif not directoryexists(folderPath)>
		<cftry>
			<cfset fileSystem.createDirectoryRecursively(folderPath)>
			<cfcatch type="any">
			</cfcatch>
		</cftry>
		<cfif not directoryexists(folderPath)>
			<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_FOLDER_NOT_FOUND#" type="ckfinder">
		</cfif>
	</cfif>

	<cftry>
		<cfdirectory action="list" directory="#folderPath#" name="qDir" sort="type,name">
		<cfcatch>
			<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED#" type="ckfinder">
		</cfcatch>
	</cftry>

	<cfif REQUEST.config.thumbnails.enabled>
		<cfif structkeyexists(REQUEST.config.thumbnails, "directAccess") and REQUEST.config.thumbnails.directAccess>
			<cfset directThumbAccess = true>
		</cfif>
		<cfif structkeyexists(URL, "showThumbs") and URL.showThumbs eq 1>
			<cfset showThumbs = true>
		</cfif>
		<cfif showThumbs or directThumbAccess>
			<cfset thumbsPath = THIS.currentFolder.getThumbsServerPath()>
		</cfif>
	</cfif>

	<cfscript>
		i=1;

		while( i lte qDir.recordCount ) {
			if (compareNoCase( qDir.type[i], "DIR" ) and not listFind(".,..", qDir.name[i])) {

				result = THIS.currentFolder.checkExtension(qDir.name[i]);
				if ((not result[1]) or (result[2] neq qDir.name[i])) {
					i = i+1;
					continue;
				}
				if (coreConfig.checkIsHiddenFile(qDir.name[i])) {
					i = i+1;
					continue;
				}

				nodeFile = XMLElemNew(THIS.xmlObject, "File");
				nodeFile.xmlAttributes["name"] = qDir.name[i];
				try {
					modified[i] = lsparsedatetime(qDir.dateLastModified[i]);
				}
				catch(Any e) {
					modified[i] = THIS.udflsparsedatetime(qDir.dateLastModified[i]);
				}
				datemodified = DateFormat(modified[i], "yyyymmdd");
				datemodified = datemodified & TimeFormat(modified[i],'HHmm');

				nodeFile.xmlAttributes["date"] = datemodified;
				//nodeFile.xmlAttributes["date"] = "20070807121212";
				if ( Len(thumbsPath) gt 0 and refindnocase(REQUEST.constants.CKFINDER_REGEX_IMAGES_EXT, qDir.name[i])) {
					thumbName = filesystem.getThumbFileName(qDir.name[i]);
					if ( fileexists( thumbsPath & thumbName ) ) {
						nodeFile.xmlAttributes["thumb"] = thumbName;
					}
					else if ( showThumbs ) {
						nodeFile.xmlAttributes["thumb"] = "?" & thumbName;
					}
				}
				nodeFile.xmlAttributes["size"] = round(qDir.size[i]/1024);
				if (qDir.size[i] and not nodeFile.xmlAttributes["size"]) {
					nodeFile.xmlAttributes["size"] = "1";
				}
				ArrayAppend(nodeFiles.xmlChildren, nodeFile);
			}
			i=i+1;
		}
		ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, nodeFiles);
	</cfscript>

	<cfreturn true>
</cffunction>

</cfcomponent>
