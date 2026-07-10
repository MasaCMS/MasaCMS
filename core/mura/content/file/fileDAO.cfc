<!--- 
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the  
same licensing model. It is, therefore, licensed under the Gnu General Public License 
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing 
notice set out below. That exception is also granted by the copyright holders of Masa CMS 
also applies to this file and Masa CMS in general. 

This file has been modified from the original version received from Mura CMS. The 
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright 
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained 
only to ensure software compatibility, and compliance with the terms of the GPLv2 and 
the exception set out below. That use is not intended to suggest any commercial relationship 
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa. 

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com  

Masa CMS is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, Version 2 of the License. 
Masa CMS is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>. 

The original complete licensing notice from the Mura CMS version of this file is as 
follows: 

This file is part of Mura CMS.

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
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false" hint="This provides file CRUD logic">

<cffunction name="init" output="false">
		<cfargument name="configBean" type="any" required="yes"/>
		<cfargument name="settingsManager" type="any" required="yes"/>
		<cfargument name="pluginManager" type="any" required="yes"/>
		<cfargument name="fileWriter" required="true" default=""/>

		<cfset variables.configBean=arguments.configBean />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.pluginManager=arguments.pluginManager />
		<cfset variables.fileWriter=arguments.fileWriter>

<cfreturn this />
</cffunction>

<cffunction name="getS3" output="false">
	<cfreturn variables.s3 />
</cffunction>

<cffunction name="create" output="false">
		<cfargument name="fileObj" type="any" required="yes"/>
		<cfargument name="contentid" type="any" required="yes"/>
		<cfargument name="siteid" type="any" required="yes"/>
		<cfargument name="filename" type="any" required="yes"/>
		<cfargument name="contentType" type="string" required="yes"/>
		<cfargument name="contentSubType" type="string" required="yes"/>
		<cfargument name="fileSize" type="numeric" required="yes"/>
		<cfargument name="moduleID" type="string" required="yes"/>
		<cfargument name="fileExt" type="string" required="yes"/>
		<cfargument name="fileObjSmall" type="any" required="yes"/>
		<cfargument name="fileObjMedium" type="any" required="yes"/>
		<cfargument name="fileID" type="any" required="yes" default="#createUUID()#"/>
		<cfargument name="fileObjSource" type="any" default=""/>
		<cfargument name="credits" type="string" required="yes" default=""/>
		<cfargument name="caption" type="string" required="yes" default=""/>
		<cfargument name="alttext" type="string" required="yes" default=""/>
		<cfargument name="remoteid" type="string" required="yes" default=""/>
		<cfargument name="remoteURL" type="string" required="yes" default=""/>
		<cfargument name="remotePubDate" type="string" required="yes" default=""/>
		<cfargument name="remoteSource" default=""/>
		<cfargument name="remoteSourceURL" type="string" required="yes" default=""/>
		<!---<cfargument name="gpsaltitude" type="string" required="yes" default=""/>
		<cfargument name="gpsaltiuderef" type="string" required="yes" default=""/>
		<cfargument name="gpslatitude" type="string" required="yes" default=""/>
		<cfargument name="gpslatituderef" type="string" required="yes" default=""/>
		<cfargument name="gpslongitude" type="string" required="yes" default=""/>
		<cfargument name="gpslongituderef" type="string" required="yes" default=""/>
		<cfargument name="gpsimgdirection" type="string" required="yes" default=""/>
		<cfargument name="gpstimestamp" type="string" required="yes" default=""/>--->
		<cfargument name="exif" type="string" required="yes" default=""/>

		<cfset var ct=arguments.contentType & "/" & arguments.contentSubType />
		<cfset var pluginEvent = createObject("component","mura.event").init(arguments) />
		<cfset var fileBean=getBean('file')>

		<cfset arguments.fileExt=lcase(arguments.fileExt)>
		<cfset fileBean.set(arguments)>
		<cfset pluginEvent.setValue('fileBean',fileBean)>
		<cfset variables.pluginManager.announceEvent("onBeforeFileCache",pluginEvent)>


		<cfscript>
			var storageService = getBean('fileStorageService');
			var cachePath = arguments.siteid & "/cache/file/";

			if (isBinary(arguments.fileObj)) {
				storageService.uploadBinary(arguments.fileObj, ct, cachePath & arguments.fileid & "." & arguments.fileExt);
			} else {
				storageService.writeFromLocal(arguments.fileObj, cachePath & arguments.fileid & "." & arguments.fileExt);
			}

			if (listFindNoCase("png,gif,jpg,jpeg", arguments.fileExt)) {
				if (isBinary(arguments.fileObjSource)) {
					storageService.uploadBinary(arguments.fileObjSource, ct, cachePath & arguments.fileid & "_source." & arguments.fileExt);
				} else if (len(arguments.fileObjSource) && fileExists(arguments.fileObjSource)) {
					storageService.writeFromLocal(arguments.fileObjSource, cachePath & arguments.fileid & "_source." & arguments.fileExt);
				}
				if (isBinary(arguments.fileObjSmall)) {
					storageService.uploadBinary(arguments.fileObjSmall, ct, cachePath & arguments.fileid & "_small." & arguments.fileExt);
				} else if (len(arguments.fileObjSmall) && fileExists(arguments.fileObjSmall)) {
					storageService.writeFromLocal(arguments.fileObjSmall, cachePath & arguments.fileid & "_small." & arguments.fileExt);
				}
				if (isBinary(arguments.fileObjMedium)) {
					storageService.uploadBinary(arguments.fileObjMedium, ct, cachePath & arguments.fileid & "_medium." & arguments.fileExt);
				} else if (len(arguments.fileObjMedium) && fileExists(arguments.fileObjMedium)) {
					storageService.writeFromLocal(arguments.fileObjMedium, cachePath & arguments.fileid & "_medium." & arguments.fileExt);
				}
			} else if (arguments.fileExt eq "flv") {
				if (isBinary(arguments.fileObjSmall)) {
					storageService.uploadBinary(arguments.fileObjSmall, "image/jpeg", cachePath & arguments.fileid & "_small.jpg");
				} else if (len(arguments.fileObjSmall) && fileExists(arguments.fileObjSmall)) {
					storageService.writeFromLocal(arguments.fileObjSmall, cachePath & arguments.fileid & "_small.jpg");
				}
				if (isBinary(arguments.fileObjMedium)) {
					storageService.uploadBinary(arguments.fileObjMedium, "image/jpeg", cachePath & arguments.fileid & "_medium.jpg");
				} else if (len(arguments.fileObjMedium) && fileExists(arguments.fileObjMedium)) {
					storageService.writeFromLocal(arguments.fileObjMedium, cachePath & arguments.fileid & "_medium.jpg");
				}
			}
		</cfscript>

		<cfset fileBean.save(processFile=false)>

		<cfset variables.pluginManager.announceEvent("onFileCache", pluginEvent)>
		<cfset variables.pluginManager.announceEvent("onAfterFileCache",pluginEvent)>

		<cfif listFindNoCase('jpg,jpeg,png',fileBean.getFileExt()) and isDefined('request.newImageIDList')>
			<cfset request.newImageIDList=listAppend(request.newImageIDList,fileid)>
		</cfif>

		<cfreturn fileid />
</cffunction>

<cffunction name="deleteVersion" output="false">
		<cfargument name="fileID" type="any" required="yes"/>

		<cfquery>
		update tfiles set deleted=1 where fileid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#">
		</cfquery>

</cffunction>

<cffunction name="deleteAll" output="false">
		<cfargument name="contentID" type="string" required="yes"/>
		<cfset var rs='' />

		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
		select contentHistID, fileID from tcontent
		where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#">
		and fileID is not null
		</cfquery>

		<cfset deleteIfNotUsed(valueList(rs.fileID),valueList(rs.contentHistID))>

</cffunction>

<cffunction name="read" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
		<cfset var rs=""/>
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
		SELECT fileID, contentID, siteID, moduleID, filename, fileSize, contentType, contentSubType, fileExt,image, created, alttext, caption, credits FROM tfiles where fileid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#">
		</cfquery>

		<cfreturn rs />

</cffunction>

<cffunction name="readAll" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
		<cfset var rs=""/>
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
		SELECT * FROM tfiles where fileid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#">
		</cfquery>

		<cfreturn rs />

</cffunction>

<cffunction name="readMeta" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
		<cfset var rs=""/>
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
		SELECT fileID, contentID, siteID, moduleID, filename, fileSize, contentType, contentSubType, fileExt, created, alttext, caption, credits  FROM tfiles where fileid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#">
		</cfquery>

		<cfreturn rs />

</cffunction>

<cffunction name="readSmall" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
		<cfset var rs=""/>
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
		SELECT fileID, contentID, siteID, moduleID, filename, fileSize, contentType, contentSubType, fileExt, imageSmall, created, alttext, caption, credits  FROM tfiles where fileid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#"> and imageSmall is not null
		</cfquery>

		<cfreturn rs />

</cffunction>

<cffunction name="readMedium" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
		<cfset var rs=""/>
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
		SELECT fileID, contentID, siteID, moduleID, filename, fileSize, contentType, contentSubType, fileExt, imageMedium, created  FROM tfiles where fileid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#"> and imageMedium is not null
		</cfquery>

		<cfreturn rs />

</cffunction>

<cffunction name="deleteIfNotUsed" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
		<cfargument name="baseID" type="any" required="yes"/>
		<cfset var rs1 = "" />
		<cfset var rs2 = "" />
		<cfset var rs3 = "" />
		<cfset var rs4 = "" />

		<cfif len(arguments.fileID)>
			<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs1')#">
			SELECT fileId FROM tcontent where
			fileid in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#arguments.fileID#">)
			and contenthistId not in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#arguments.baseID#">)
			</cfquery>

			<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs2')#">
			SELECT attributeValue FROM tclassextenddata where
			stringValue in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#arguments.fileID#">)
			and baseId not in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#arguments.baseID#">)
			</cfquery>

			<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs3')#">
			SELECT attributeValue FROM tclassextenddatauseractivity where
			stringValue in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#arguments.fileID#">)
			and baseId not in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#arguments.baseID#">)
			</cfquery>

			<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs4')#">
			SELECT photoFileID FROM tusers where
			photoFileID in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#arguments.fileID#">)
			and userId not in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#arguments.baseID#">)
			</cfquery>

			<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs4')#">
			SELECT placeholderImgID FROM tsettings where
			placeholderImgID in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#arguments.fileID#">)
			</cfquery>

			<cfif not rs1.recordcount and not rs2.recordcount and not rs3.recordcount and not rs4.recordcount>
				<cfset deleteVersion(arguments.fileID) />
			</cfif>
		</cfif>

</cffunction>

<cffunction name="purgeDeleted" output="false">
<cfargument name="siteid" default="">
<cfset var rs="">

<cflock type="exclusive" name="purgingDeletedFile#application.instanceID#" timeout="1000">
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	select fileID from tfiles where deleted=1
	<cfif len(arguments.siteID)>
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
	</cfif>
	</cfquery>

	<cfloop query="rs">
		<cfset deleteCachedFile(rs.fileID)>
	</cfloop>

	<cfquery>
	delete from tfiles where deleted=1
	<cfif len(arguments.siteID)>
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
	</cfif>
	</cfquery>
</cflock>

</cffunction>

<cffunction name="restoreVersion" output="false">
	<cfargument name="fileID">
	<cfquery>
	update tfiles set deleted=0 where fileID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#">
	</cfquery>
</cffunction>

<cffunction name="deleteCachedFile">
<cfargument name="fileID" type="string" required="yes"/>
		<cfset var rsFile=readMeta(arguments.fileID) />
		<cfset var pluginEvent = createObject("component","mura.event") />
		<cfset var data=arguments />
		<cfset data.siteID=rsFile.siteID />
		<cfset data.rsFile=rsFile />
		<cfset pluginEvent.init(data)>

		<cfset variables.pluginManager.announceEvent("onFileCacheDelete",pluginEvent)>
		<cfset variables.pluginManager.announceEvent("onBeforeFileCacheDelete",pluginEvent)>

		<cfscript>
			var storageService = getBean('fileStorageService');
			var cachePath = rsFile.siteID & "/cache/file/";
			var cacheKeyPrefix = cachePath & arguments.fileID;
			var cachedObjects = [];
			var cachedObject = "";
			var objectKey = "";

			// Delete every cached variant for this fileID, including custom sizes
			// generated by image manipulation methods.
			try {
				cachedObjects = storageService.listObjects(cachePath, arguments.fileID);

				for (cachedObject in cachedObjects) {
					if (isSimpleValue(cachedObject)) {
						objectKey = cachedObject;
					} else if (isStruct(cachedObject) and structKeyExists(cachedObject, "key")) {
						objectKey = cachedObject.key;
					} else if (isStruct(cachedObject) and structKeyExists(cachedObject, "name")) {
						objectKey = cachedObject.name;
					} else {
						objectKey = "";
					}

					if (len(objectKey)) {
						if (left(objectKey, len(cacheKeyPrefix)) neq cacheKeyPrefix) {
							objectKey = cachePath & objectKey;
						}
						storageService.deleteObject(objectKey);
					}
				}
			} catch(any e) {
				// Fallback for storage providers without list support: preserve the
				// previous explicit deletions for default cache variants.
				storageService.deleteObject(cachePath & arguments.fileID & "." & rsFile.fileExt);
				storageService.deleteObject(cachePath & arguments.fileID & "_source." & rsFile.fileExt);
				if (listFindNoCase("png,gif,jpg,jpeg", rsFile.fileExt)) {
					storageService.deleteObject(cachePath & arguments.fileID & "_small." & rsFile.fileExt);
					storageService.deleteObject(cachePath & arguments.fileID & "_medium." & rsFile.fileExt);
				} else if (rsFile.fileExt eq "flv") {
					storageService.deleteObject(cachePath & arguments.fileID & "_small.jpg");
					storageService.deleteObject(cachePath & arguments.fileID & "_medium.jpg");
				}
			}
		</cfscript>

		<cfset variables.pluginManager.announceEvent("onAfterFileCacheDelete",pluginEvent)>
</cffunction>

</cfcomponent>
