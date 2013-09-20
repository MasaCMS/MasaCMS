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
<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" returntype="any" access="public" output="false">
		<cfargument name="configBean" type="any" required="yes"/>
		<cfargument name="settingsManager" type="any" required="yes"/>
		<cfargument name="pluginManager" type="any" required="yes"/>
		<cfargument name="fileWriter" required="true" default=""/>
		
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.pluginManager=arguments.pluginManager />
		<cfset variables.fileWriter=arguments.fileWriter>
		<cfif variables.configBean.getFileStoreAccessInfo() neq ''>
			<cfset variables.s3=createObject("component","s3").init(
							listFirst(variables.configBean.getFileStoreAccessInfo(),'^'),
							listGetAt(variables.configBean.getFileStoreAccessInfo(),2,'^'),
							"#application.configBean.getFileDir()##application.configBean.getFileDelim()#s3cache#application.configBean.getFileDelim()#",
							variables.configBean.getFileStoreEndPoint())>
			<cfif listLen(variables.configBean.getFileStoreAccessInfo(),"^") eq 3>
				<cfset variables.bucket=listLast(variables.configBean.getFileStoreAccessInfo(),"^") />
			<cfelse>
				<cfset variables.bucket="sava" />
			</cfif>
		<cfelse>
			<cfset variables.s3=""/>
			<cfset variables.bucket=""/>		
		</cfif>
		
<cfreturn this />
</cffunction>

<cffunction name="getS3" returntype="any" access="public" output="false">
	<cfreturn variables.s3 />
</cffunction>

<cffunction name="create" returntype="string" access="public" output="false">
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
		
		<cfset var ct=arguments.contentType & "/" & arguments.contentSubType />
		<cfset var pluginEvent = createObject("component","mura.event").init(arguments) />
		<cfset var fileBean=getBean('file')>
	
		<cfset arguments.fileExt=lcase(arguments.fileExt)>
		<cfset fileBean.set(arguments)>
		<cfset pluginEvent.setValue('fileBean',fileBean)>
		<cfset variables.pluginManager.announceEvent("onBeforeFileCache",pluginEvent)>
		
		
		<cfswitch expression="#variables.configBean.getFileStore()#">
			<cfcase value="fileDir">		
				<cfif isBinary(arguments.fileObj)>
				
					<cfset variables.fileWriter.writeFile(mode="774", file="#application.configBean.getFileDir()##application.configBean.getFileDelim()##arguments.siteid##application.configBean.getFileDelim()#cache#application.configBean.getFileDelim()#file#application.configBean.getFileDelim()##arguments.fileID#.#arguments.fileExt#", output="#arguments.fileObj#")>
				
					<cfif listFindNoCase("png,gif,jpg,jpeg",arguments.fileExt)>					
						<cfif isBinary(arguments.fileObjSource)>
							<cfset variables.fileWriter.writeFile(mode="774", file="#application.configBean.getFileDir()##application.configBean.getFileDelim()##arguments.siteid##application.configBean.getFileDelim()#cache#application.configBean.getFileDelim()#file#application.configBean.getFileDelim()##arguments.fileID#_source.#arguments.fileExt#", output="#arguments.fileObjSource#")>
						</cfif>
						<cfif isBinary(arguments.fileObjSmall)>
							<cfset variables.fileWriter.writeFile(mode="774", file="#application.configBean.getFileDir()##application.configBean.getFileDelim()##arguments.siteid##application.configBean.getFileDelim()#cache#application.configBean.getFileDelim()#file#application.configBean.getFileDelim()##arguments.fileID#_small.#arguments.fileExt#", output="#arguments.fileObjSmall#")>
						</cfif>
						<cfif isBinary(arguments.fileObjMedium)>
							<cfset variables.fileWriter.writeFile(mode="774", file="#application.configBean.getFileDir()##application.configBean.getFileDelim()##arguments.siteid##application.configBean.getFileDelim()#cache#application.configBean.getFileDelim()#file#application.configBean.getFileDelim()##arguments.fileID#_medium.#arguments.fileExt#", output="#arguments.fileObjMedium#")/>
						</cfif>
					<cfelseif arguments.fileExt eq 'flv'>
						<cfif isBinary(arguments.fileObjSmall)>
							<cfset variables.fileWriter.writeFile(mode="774", file="#application.configBean.getFileDir()##application.configBean.getFileDelim()##arguments.siteid##application.configBean.getFileDelim()#cache#application.configBean.getFileDelim()#file#application.configBean.getFileDelim()##arguments.fileID#_small.jpg", output="#arguments.fileObjSmall#")>
						</cfif>
						<cfif isBinary(arguments.fileObjMedium)>
							<cfset variables.fileWriter.writeFile( mode="774",  file="#application.configBean.getFileDir()##application.configBean.getFileDelim()##arguments.siteid##application.configBean.getFileDelim()#cache#application.configBean.getFileDelim()#file#application.configBean.getFileDelim()##arguments.fileID#_medium.jpg", output="#arguments.fileObjMedium#")>
						</cfif>
					</cfif>			
				<cfelse>				
					<cfset variables.fileWriter.moveFile(mode="774", destination="#application.configBean.getFileDir()##application.configBean.getFileDelim()##arguments.siteid##application.configBean.getFileDelim()#cache#application.configBean.getFileDelim()#file#application.configBean.getFileDelim()##arguments.fileID#.#arguments.fileExt#", source="#arguments.fileObj#")>
				
					<cfif listFindNoCase("png,gif,jpg,jpeg",arguments.fileExt)>	
						<cfif len(arguments.fileObjSource)>
							<cfset variables.fileWriter.moveFile(mode="774", destination="#application.configBean.getFileDir()##application.configBean.getFileDelim()##arguments.siteid##application.configBean.getFileDelim()#cache#application.configBean.getFileDelim()#file#application.configBean.getFileDelim()##arguments.fileID#_source.#arguments.fileExt#", source="#arguments.fileObjSource#")>
						</cfif>
						<cfif len(arguments.fileObjSmall)>
							<cfset variables.fileWriter.moveFile(mode="774", destination="#application.configBean.getFileDir()##application.configBean.getFileDelim()##arguments.siteid##application.configBean.getFileDelim()#cache#application.configBean.getFileDelim()#file#application.configBean.getFileDelim()##arguments.fileID#_small.#arguments.fileExt#", source="#arguments.fileObjSmall#")>
						</cfif>
						<cfif len(arguments.fileObjMedium)>
							<cfset variables.fileWriter.moveFile(mode="774", destination="#application.configBean.getFileDir()##application.configBean.getFileDelim()##arguments.siteid##application.configBean.getFileDelim()#cache#application.configBean.getFileDelim()#file#application.configBean.getFileDelim()##arguments.fileID#_medium.#arguments.fileExt#", source="#arguments.fileObjMedium#")/>
						</cfif>
					<cfelseif arguments.fileExt eq 'flv'>
						<cfif len(arguments.fileObjSmall)>
							<cfset variables.fileWriter.moveFile(mode="774", destination="#application.configBean.getFileDir()##application.configBean.getFileDelim()##arguments.siteid##application.configBean.getFileDelim()#cache#application.configBean.getFileDelim()#file#application.configBean.getFileDelim()##arguments.fileID#_small.jpg", source="#arguments.fileObjSmall#")>
						</cfif>
						<cfif len(arguments.fileObjMedium)>
							<cfset variables.fileWriter.writeFile( mode="774",  destination="#application.configBean.getFileDir()##application.configBean.getFileDelim()##arguments.siteid##application.configBean.getFileDelim()#cache#application.configBean.getFileDelim()#file#application.configBean.getFileDelim()##arguments.fileID#_medium.jpg", source="#arguments.fileObjMedium#")>
						</cfif>
					</cfif>			
				</cfif>	
			</cfcase>
			<cfcase value="s3">
				<cfset variables.s3.putFileOnS3(arguments.fileObj,ct,variables.bucket,'#arguments.siteid#/#arguments.fileid#.#arguments.fileExt#') />
		        <cfset var s3_path = "#arguments.siteid#/cache/file/">
		        <cfset variables.s3.putFileOnS3(arguments.fileObj,ct,variables.bucket,'#s3_path##arguments.fileid#.#arguments.fileExt#') />
		        <cfif arguments.fileExt eq 'jpg' or arguments.fileExt eq 'jpeg' or arguments.fileExt eq 'png' or arguments.fileExt eq 'gif'>
		       	 	<cfif isBinary(fileObjSmall)><cfset variables.s3.putFileOnS3(arguments.fileObjSmall,ct,variables.bucket,'#s3_path##arguments.fileid#_small.#arguments.fileExt#') /></cfif>
		          	<cfif isBinary(fileObjMedium)><cfset variables.s3.putFileOnS3(arguments.fileObjMedium,ct,variables.bucket,'#s3_path##arguments.fileid#_medium.#arguments.fileExt#') /></cfif>
		         <cfelseif arguments.fileExt eq 'flv'>
		          	<cfif isBinary(fileObjSmall)><cfset variables.s3.putFileOnS3(arguments.fileObjSmall,'image/jpeg',variables.bucket,'#s3_path##arguments.fileid#_small.jpg') /></cfif>
		          	<cfif isBinary(fileObjMedium)><cfset variables.s3.putFileOnS3(arguments.fileObjMedium,'image/jpeg',variables.bucket,'#s3_path##arguments.fileid#_medium.jpg') /></cfif>
		         </cfif>
			</cfcase>
		</cfswitch>

		<cfset fileBean.save(processFile=false)>

		<cfset variables.pluginManager.announceEvent("onFileCache", pluginEvent)>
		<cfset variables.pluginManager.announceEvent("onAfterFileCache",pluginEvent)>

		<cfif listFindNoCase('jpg,jpeg,png',fileBean.getFileExt()) and isDefined('request.newImageIDList')>
			<cfset request.newImageIDList=listAppend(request.newImageIDList,fileid)>
		</cfif>

		<cfreturn fileid />
</cffunction>

<cffunction name="deleteVersion" returntype="void" access="public" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
		
		<cfquery>
		update tfiles set deleted=1 where fileid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#">
		</cfquery>
	
</cffunction>

<cffunction name="deleteAll" returntype="void" access="public" output="false">
		<cfargument name="contentID" type="string" required="yes"/>
		<cfset var rs='' />
		
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
		select contentHistID, fileID from tcontent 
		where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#">
		and fileID is not null
		</cfquery>

		<cfset deleteIfNotUsed(valueList(rs.fileID),valueList(rs.contentHistID))>

</cffunction>

<cffunction name="read" returntype="query" access="public" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
		<cfset var rs=""/>
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
		SELECT fileID, contentID, siteID, moduleID, filename, fileSize, contentType, contentSubType, fileExt,image, created, alttext, caption, credits FROM tfiles where fileid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#">
		</cfquery>
		
		<cfreturn rs />
	
</cffunction>

<cffunction name="readAll" returntype="query" access="public" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
		<cfset var rs=""/>
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
		SELECT * FROM tfiles where fileid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#">
		</cfquery>
		
		<cfreturn rs />
	
</cffunction>

<cffunction name="readMeta" returntype="query" access="public" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
		<cfset var rs=""/>
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
		SELECT fileID, contentID, siteID, moduleID, filename, fileSize, contentType, contentSubType, fileExt, created, alttext, caption, credits  FROM tfiles where fileid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#">
		</cfquery>
		
		<cfreturn rs />
	
</cffunction>

<cffunction name="readSmall" returntype="query" access="public" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
		<cfset var rs=""/>
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
		SELECT fileID, contentID, siteID, moduleID, filename, fileSize, contentType, contentSubType, fileExt, imageSmall, created, alttext, caption, credits  FROM tfiles where fileid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#"> and imageSmall is not null
		</cfquery>
		
		<cfreturn rs />
	
</cffunction>

<cffunction name="readMedium" returntype="query" access="public" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
		<cfset var rs=""/>
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
		SELECT fileID, contentID, siteID, moduleID, filename, fileSize, contentType, contentSubType, fileExt, imageMedium, created  FROM tfiles where fileid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#"> and imageMedium is not null
		</cfquery>
		
		<cfreturn rs />
	
</cffunction>

<cffunction name="deleteIfNotUsed" returntype="void" access="public" output="false">
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

<cffunction name="deleteCachedFile" returntype="void" access="public">
<cfargument name="fileID" type="string" required="yes"/>
		<cfset var delim=variables.configBean.getFileDelim() />
		<cfset var rsFile=readMeta(arguments.fileID) />
		<cfset var pluginEvent = createObject("component","mura.event") />
		<cfset var data=arguments />
		<cfset var filePath="#application.configBean.getFileDir()#/#rsfile.siteID#/cache/file/"/>
		<cfset var rsDir=""/>
		<cfset data.siteID=rsFile.siteID />
		<cfset data.rsFile=rsFile />
		<cfset pluginEvent.init(data)>
		
		<cfset variables.pluginManager.announceEvent("onFileCacheDelete",pluginEvent)>
		<cfset variables.pluginManager.announceEvent("onBeforeFileCacheDelete",pluginEvent)>
		
		<cfswitch expression="#variables.configBean.getFileStore()#">
		<cfcase value="fileDir">
			<cfdirectory action="list" name="rsDIR" directory="#filepath#" filter="#arguments.fileid#*">
			<cfloop query="rsDir">
				<cffile action="delete" file="#filepath##rsDir.name#">
			</cfloop>		
		</cfcase>
		
		<cfcase value="s3">
			<cfset variables.s3.deleteS3File(variables.bucket,'#rsFile.siteID#/#arguments.fileid#.#rsFile.fileExt#') />
			<cfif listFindNoCase("png,gif,jpg,jpeg",rsFile.fileExt)>
				<cfset variables.s3.deleteS3File(variables.bucket,'#rsFile.siteID#/#arguments.fileid#_small.#rsFile.fileExt#') />
				<cfset variables.s3.deleteS3File(variables.bucket,'#rsFile.siteID#/#arguments.fileid#_medium.#rsFile.fileExt#') />
			<cfelseif rsFile.fileEXT eq "flv">
				<cfset variables.s3.deleteS3File(variables.bucket,'#rsFile.siteID#/#arguments.fileid#_small.jpg') />
				<cfset variables.s3.deleteS3File(variables.bucket,'#rsFile.siteID#/#arguments.fileid#_medium.jpg') />
			</cfif>
		</cfcase>
		
		</cfswitch>
		
		<cfset variables.pluginManager.announceEvent("onAfterFileCacheDelete",pluginEvent)>
</cffunction>

</cfcomponent>