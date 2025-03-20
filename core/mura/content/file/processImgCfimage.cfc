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

  Linking Mura CMS statically or dynamically with other modules constitutes
  the preparation of a derivative work based on Mura CMS. Thus, the terms
  and conditions of the GNU General Public License version 2 ("GPL") cover
  the entire combined work.

  However, as a special exception, the copyright holders of Mura CMS grant
  you permission to combine Mura CMS with programs or libraries that are
  released under the GNU Lesser General Public License version 2.1.

  In addition, as a special exception, the copyright holders of Mura CMS
  grant you permission to combine Mura CMS with independent software modules
  (plugins, themes and bundles), and to distribute these plugins, themes and
  bundles without Mura CMS under the license of your choice, provided that
  you follow these specific guidelines:

  Your custom code

  • Must not alter any default objects in the Mura CMS database and
  • May not alter the default display of the Mura CMS logo within Mura CMS and
  • Must not alter any files in the following directories:

   	/admin/
	/core/
	/Application.cfc
	/index.cfm

  You may copy and distribute Mura CMS with a plug-in, theme or bundle that
  meets the above guidelines as a combined work under the terms of GPL for
  Mura CMS, provided that you include the source code of that other code when
  and as the GNU GPL requires distribution of source code.

  For clarity, if you create a modified version of Mura CMS, you are not
  obligated to grant this special exception for your modified version; it is
  your choice whether to do so, or to make such modified version available
  under the GNU General Public License version 2 without this exception.  You
  may, if you choose, apply this exception to your own modified versions of
  Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false" hint="This provides image processing functionality">

	<cffunction name="init">
		<cfargument name="configBean">
		<cfargument name="settingsManager">

		<cfset variables.configBean=arguments.configBean/>
		<cfset variables.settingsManager=arguments.settingsManager/>
		<cfset variables.instance.imageInterpolation=arguments.configBean.getImageInterpolation()>
		<cfset variables.fileWriter=getBean("fileWriter")>
		<cfset variables.instance.imageQuality=arguments.configBean.getImageQuality()>

		<cfif StructKeyExists(SERVER,"bluedragon") and not listFindNoCase("bicubic,bilinear,nearest",variables.instance.imageInterpolation)>
			<cfset variables.instance.imageInterpolation="bicubic">
		</cfif>

		<cfset variables.imageFileLookup={}>

		<cfreturn this />
	</cffunction>

	<cffunction name="touchDir" output="false">
		<cfargument name="dir" required="Yes" type="string">
		<cfargument name="mode" required="no" type="string" default="#variables.configBean.getDefaultfilemode()#">

		<!--- Skip if using Amazon S3 --->
		<!--- fileExists will return true with Lucee s3 mapping  --->
		<cfif not (directoryExists(dir) or fileExists(dir)) and not ListFindNoCase('s3', Left(arguments.dir, 2))>
			<cfif variables.configBean.getUseFileMode()>
				<cfdirectory directory="#dir#" action="create" mode="#arguments.mode#">
			<cfelse>
				<cfdirectory directory="#dir#" action="create">
			</cfif>
		</cfif>

		<cfreturn this />
	</cffunction>

	<cffunction name="doesImageFileExist" output="false">
		<cfargument name="filePath">
		<cfargument name="attempt" default="1">

		<cfif variables.configBean.getValue(property="cacheImageFileLookups", defaultValue=false)>
			<cfparam name="variables.imageFileLookup" default="#structNew()#">

			<cftry>
				<cfif arguments.attempt neq 1>
					<cfset structDelete(variables.imageFileLookup,'#arguments.filepath#')>
				</cfif>

				<cfif not structKeyExists(variables.imageFileLookup,'#arguments.filepath#')>
					<cfif fileExists(arguments.filePath)>
						<cfset variables.imageFileLookup['#arguments.filepath#']=true>
						<cfreturn true>
					<cfelse>
						<cfreturn false>
					</cfif>
				<cfelse>
					<cfreturn true>
				</cfif>
				<cfcatch>
					<cfreturn fileExists(arguments.filePath)>
				</cfcatch>
			</cftry>
		<cfelse>
			<cfreturn fileExists(arguments.filePath)>
		</cfif>

	</cffunction>

	<cffunction name="resetImageFileLookUp" output="false">
		<cfset variables.imageFileLookup={}>
	</cffunction>

	<cffunction name="getCustomImage" output="false">
		<cfargument name="Image" required="true" />
		<cfargument name="Height" default="AUTO" />
		<cfargument name="Width" default="AUTO" />
		<cfargument name="size" default="" />
		<cfargument name="siteID" default="" />
		<cfargument name="attempt" default="1" />

		<cfset var NewImageSource = "">
		<cfset var NewImageLocal = "">
		<cfset var ReturnImageHTML = "">
		<cfset var OriginalImageFilename = "" />
		<cfset var OriginalImageType = "" />
		<cfset var OriginalImageFile = trim(arguments.Image) />
		<cfset var OriginalImagePath = GetDirectoryFromPath(OriginalImageFile) />
		<cfset var customImageSize="">

		<cfif not len(arguments.image)
			or not listFindNoCase("png,gif,jpg,jpeg",listLast(arguments.image,"."))>
			<cfreturn "">
		</cfif>

		<cfif not doesImageFileExist(OriginalImageFile,arguments.attempt)>
			<cfset OriginalImageFile = expandPath(OriginalImageFile) />
			<cfset OriginalImagePath = GetDirectoryFromPath(OriginalImageFile) />
		</cfif>

		<cfset OriginalImageType = listLast(OriginalImageFile,".") />
		<cfset OriginalImageFilename = Replace(OriginalImageFile, ".#OriginalImageType#", "", "all") />

		<cfif len(arguments.size)>
			<cfset NewImageSource = "#OriginalImageFilename#_#lcase(arguments.size)#.#OriginalImageType#" />
			<cfset NewImageLocal = Replace(OriginalImageFile, ".#OriginalImageType#", "_#lcase(arguments.size)#.#OriginalImageType#") />
		<cfelse>
			<cfif arguments.Width eq "AUTO" and arguments.Height eq "AUTO">
				<cfset NewImageSource = OriginalImageFile />
				<cfset NewImageLocal = arguments.Image />
			<cfelse>
				<cfset arguments.Width = trim(replaceNoCase(arguments.Width,"px","","all")) />
				<cfset arguments.Height = trim(replaceNoCase(arguments.Height,"px","","all")) />
				<cfset NewImageSource = "#OriginalImageFilename#_W#arguments.Width#_H#arguments.Height#.#OriginalImageType#" />
				<cfset NewImageLocal = Replace(OriginalImageFile, ".#OriginalImageType#", "_W#arguments.width#_H#arguments.height#.#OriginalImageType#") />
			</cfif>
		</cfif>

		<cfset NewImageLocal = listLast(replace(NewImageLocal,"\","/","all"),'/')>

		<cfif not doesImageFileExist(NewImageSource,arguments.attempt)>

			<cfset OriginalImageFile = Replace(OriginalImageFile, ".#OriginalImageType#", "_source.#OriginalImageType#", "all") />

			<cfif not doesImageFileExist(OriginalImageFile,arguments.attempt)>
				<cfset OriginalImageFile = Replace(OriginalImageFile, "_source.#OriginalImageType#", ".#OriginalImageType#", "all") />
			</cfif>

			<!--- If the original file does not exist then it can't create the custom image.--->
			<cfif not doesImageFileExist(OriginalImageFile,arguments.attempt)>
				<cfreturn NewImageLocal>
			</cfif>

			<cfif len(arguments.size)>
				<cfset customImageSize=getBean('imageSize').loadBy(name=arguments.size,siteID=arguments.siteID)>
				<cfset arguments.Width = customImageSize.getWidth() />
				<cfset arguments.Height = customImageSize.getHeight() />
			</cfif>

			<!--- If the custom image size is not valid return the small --->
			<cfif not isNumeric(arguments.Width) and not isNumeric(arguments.Height)>
				<cfreturn "">
			</cfif>

			<cftry>
				<cfset variables.fileWriter.copyFile(source=OriginalImageFile,destination=NewImageSource,mode="744")>

				<cfset resizeImage(height=arguments.height,width=arguments.width,image=NewImageSource)>

				<cfif listFirst(expandPath(NewImageSource),':') eq 's3' and len(arguments.siteID) and getBean('settingsManager').getSite(arguments.siteid).getContentRenderer().directImages>
					<cftry>
					<cfset storeSetACL(expandPath(NewImageSource),[{group="all", permission="read"}])>
					<!--- Create deprecation warning when setting ACL on AWS bucket --->
					<cfset var pluginManager=getBean('pluginManager')>
					<cfset var current$ = getBean('$').init()>
					<cfset current$.event().setValue("deprecationType","StoreSetACL")>
					<cfset pluginManager.announceEvent(eventToAnnounce='LogDeprecation',currentEventObject=current$)>
					<cfcatch></cfcatch>
					</cftry>
				</cfif>

				<cfif not doesImageFileExist(NewImageSource,arguments.attempt)>
					<cfset variables.fileWriter.copyFile(source=OriginalImageFile,destination=NewImageSource,mode="744")>
				</cfif>

				<cfcatch>
					<cfif arguments.attempt eq 1>
						<cfset arguments.attempt=2>
						<cfset getCustomImage(argumentCollection=arguments)>
					<cfelse>
						<cfrethrow>
					</cfif>
				</cfcatch>
			</cftry>
		</cfif>

		<cfreturn NewImageLocal />
	</cffunction>

	<cffunction name="resizeImage" output="false">
		<cfargument name="Image" required="true" />
		<cfargument name="Height" default="AUTO" />
		<cfargument name="Width" default="AUTO" />
		<cfset var ThisImage=imageRead(arguments.image)>
		<cfset var ImageAspectRatio=0>
		<cfset var NewAspectRatio=0>
		<cfset var CropX=0>
		<cfset var CropY=0>

		<!---
			This a workaround to ensure jpegs can be process
			https://luceeserver.atlassian.net/browse/LDEV-1874
		--->
		<cfif listFindNoCase('jpg,jpeg',listLast(ThisImage.source,'.')) >
			<cfset var origImage=ThisImage>
			<cfset ThisImage = imageNew("", ThisImage.width, ThisImage.height, "rgb") />
			<cfset imagePaste(ThisImage, origImage, 0, 0) />
		</cfif>


		<cfif arguments.Width eq "AUTO">
			<cfif ThisImage.height gt arguments.height>
				<cfset ImageResize(ThisImage,'',arguments.height,variables.instance.imageInterpolation)>
				<cfset ImageWrite(ThisImage,arguments.image,variables.instance.imageQuality)>
			</cfif>
		<cfelseif arguments.Height eq "AUTO">
			<cfif ThisImage.width gt arguments.width>
				<cfset ImageResize(ThisImage,arguments.width,'',variables.instance.imageInterpolation)>
				<cfset ImageWrite(ThisImage,arguments.image,variables.instance.imageQuality)>
			</cfif>
		<cfelse>
			<cfset ImageAspectRatio = ThisImage.Width / ThisImage.height />
			<cfset NewAspectRatio = arguments.Width / arguments.height />

			<cfif ImageAspectRatio eq NewAspectRatio>
				<cfif ThisImage.width gt arguments.width>
					<cfset ImageResize(ThisImage,arguments.width,'',variables.instance.imageInterpolation)>
					<cfset ImageWrite(ThisImage,arguments.image,variables.instance.imageQuality)>
				</cfif>
			<cfelseif ImageAspectRatio lt NewAspectRatio>
				<cfset ImageResize(ThisImage,arguments.width,'',variables.instance.imageInterpolation)>
				<cfset CropY = (ThisImage.height - arguments.height)/2 />
				<cfset ImageCrop(ThisImage, 0, CropY, arguments.Width, arguments.height) />
				<cfset ImageWrite(ThisImage,arguments.image,variables.instance.imageQuality)>
			<cfelseif ImageAspectRatio gt NewAspectRatio>
				<cfset ImageResize(ThisImage,'',arguments.height,variables.instance.imageInterpolation)>
				<cfset CropX = (ThisImage.width - arguments.width)/2 />
				<cfset ImageCrop(ThisImage, CropX, 0, arguments.width, arguments.height) />
				<cfset ImageWrite(ThisImage,arguments.image,variables.instance.imageQuality)>
			</cfif>
		</cfif>

		<cfreturn this />
	</cffunction>

	<cffunction name="fromPath2Binary" output="false">
		<cfargument name="path" type="string" required="yes">
		<cfargument name="delete" type="boolean" required="no" default="yes">

		<cfset var rtn="">

		<cffile action="readbinary" file="#arguments.path#" variable="rtn">
		<cfif arguments.delete><cftry><cffile action="delete" file="#arguments.path#"><cfcatch></cfcatch></cftry></cfif>
		<cfreturn rtn>
	</cffunction>

	<cffunction name="Process" returnType="struct">
		<cfargument name="file">
		<cfargument name="siteID">

		<cfset var fileStruct = structNew() />
		<cfset var imageCFC=""/>
		<cfset var theFile=""/>
		<cfset var theSmall=""/>
		<cfset var theMedium=""/>
		<cfset var fileObj=""/>
		<cfset var fileObjSmall=""/>
		<cfset var fileObjMedium=""/>
		<cfset var fileObjSource=""/>
		<cfset var refused=false />
		<cfset var serverFilename=arguments.file.serverfilename />
		<cfset var serverDirectory=arguments.file.serverDirectory & "/" />
		<cfset var site=variables.settingsManager.getSite(arguments.siteID)>
		<cfset var pid=createUUID()>

		<cfset fileStruct.fileObj = '' />
		<cfset fileStruct.fileObjSmall = '' />
		<cfset fileStruct.fileObjMedium =  ''/>
		<cfset fileStruct.fileObjSource =  ''/>

		<cfset touchDir("#variables.configBean.getFileDir()#/#arguments.siteID#")>

		<cfif listLen(serverfilename," ") gt 1>
			<cfset serverFilename=replace(serverFilename," ","-","ALL") />

			<cfif fileExists("#serverDirectory##serverFilename#.#arguments.file.serverFileExt#")>
				<cffile action="delete" file="#serverDirectory##serverFilename#.#arguments.file.serverFileExt#">
			</cfif>
			<cffile action="rename" source="#serverDirectory##arguments.file.serverfile#" destination="#serverDirectory##serverFilename#.#arguments.file.serverFileExt#" attributes="normal">
		</cfif>

		<cffile action="rename" source="#serverDirectory##serverFilename#.#arguments.file.serverFileExt#" destination="#serverDirectory##pid#-#serverFilename#.#arguments.file.serverFileExt#" attributes="normal">
		<cfset fileStruct.fileObj = "#serverDirectory##pid#-#serverFilename#.#arguments.file.serverFileExt#" />

		<!--- BEGIN IMAGE MANIPULATION --->
		<cfif listFindNoCase('jpg,jpeg,png,gif',arguments.file.ServerFileExt)>

			<cfif variables.configBean.getFileStore() eq "fileDir">
				<cfset fileStruct.fileObjSource = '#serverDirectory##getCustomImage(image=fileStruct.fileObj,height='Auto',width=variables.configBean.getMaxSourceImageWidth())#'/>
			<cfelse>
				<cfset fileStruct.fileObjSource = fileStruct.fileObj>
			</cfif>

			<!--- Small --->
				<cfset fileStruct.fileObjSmall = "#serverDirectory##getCustomImage(image=fileStruct.fileObjSource,height=site.getSmallImageHeight(),width=site.getSmallImageWidth())#" />

				<cfif variables.configBean.getFileStore() neq "fileDir">
					<cfset fileStruct.fileObjSmall=fromPath2Binary(fileStruct.fileObjSmall,false) />
					<cftry><cffile action="delete" file="#fileStruct.fileObjSmall#"><cfcatch></cfcatch></cftry>
				</cfif>

			<!--- Medium --->
				<cfset fileStruct.fileObjMedium = "#serverDirectory##getCustomImage(image=fileStruct.fileObjSource,height=site.getMediumImageHeight(),width=site.getMediumImageWidth())#" />

				<cfif variables.configBean.getFileStore() neq "fileDir">
					<cfset fileStruct.fileObjMedium=fromPath2Binary(fileStruct.fileObjMedium,false) />
					<cftry><cffile action="delete" file="#fileStruct.fileObjMedium#"><cfcatch></cfcatch></cftry>
				</cfif>

			<!--- Large --->
				<cfset fileStruct.fileObjLarge = "#serverDirectory##getCustomImage(image=fileStruct.fileObjSource,height=site.getLargeImageHeight(),width=site.getLargeImageWidth())#" />
				<cftry><cffile action="delete" file="#fileStruct.fileObj#"><cfcatch></cfcatch></cftry>
				<cfset variables.fileWriter.copyFile(source=fileStruct.fileObjLarge,destination=fileStruct.fileObj) />
				<cftry><cffile action="delete" file="#fileStruct.fileObjLarge#"><cfcatch></cfcatch></cftry>
				<cfset StructDelete(fileStruct,"fileObjLarge")>

			<cfif variables.configBean.getFileStore() neq "fileDir">
				<!--- clean up source--->
				<cffile action="delete" file="#fileStruct.fileObjSource#">
			</cfif>

		</cfif>

		<cfset fileStruct.theFile=fileStruct.fileObj/>

		<cfif variables.configBean.getFileStore() neq "fileDir">
			<cfset fileStruct.fileObj=fromPath2Binary(fileStruct.fileObj,false) />
			<cftry><cffile action="delete" file="#fileStruct.fileObj#"><cfcatch></cfcatch></cftry>
		</cfif>

		<!--- END IMAGE MANIPULATION --->

		<cfreturn fileStruct>
	</cffunction>

</cfcomponent>
