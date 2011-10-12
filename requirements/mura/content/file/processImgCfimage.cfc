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

	<cffunction name="init" returntype="any">
		<cfargument name="configBean">
		<cfargument name="settingsManager">

		<cfset variables.configBean=arguments.configBean/>
		<cfset variables.settingsManager=arguments.settingsManager/>
		<cfset variables.instance.imageInterpolation=arguments.configBean.getImageInterpolation()> 
		
		<cfif StructKeyExists(SERVER,"bluedragon") and not listFindNoCase("bicubic,bilinear,nearest",variables.instance.imageInterpolation)>
			<cfset variables.instance.imageInterpolation="bicubic">
		</cfif>
		
		<cfreturn this />
	</cffunction>

	<cffunction name="touchDir" returntype="void" output="false">
		<cfargument name="dir" required="Yes" type="string">
		<cfargument name="mode" required="no" type="string" default="777">
		
		<cfif not directoryExists(dir)>
			<cfdirectory directory="#dir#" action="create" mode="#arguments.mode#">
		</cfif>
	</cffunction>

	<cffunction name="getCustomImage" output="false">
	<cfargument name="Image" required="true" />
	<cfargument name="Height" default="AUTO" />
	<cfargument name="Width" default="AUTO" />

	<cfset var NewImageSource = "">
	<cfset var NewImageLocal = "">
	<cfset var ReturnImageHTML = "">
	<cfset var OriginalImageFilename = "" />
	<cfset var OriginalImageType = "" />
	<cfset var thisImage="">
	<cfset var OriginalImageFile = trim(arguments.Image) />
	<cfset var OriginalImagePath = GetDirectoryFromPath(OriginalImageFile) />
	<cfset var ImageAspectRatio=0>
	<cfset var NewAspectRatio=0>
	<cfset var CropX=0>
	<cfset var CropY=0>
	
	<cfif not len(arguments.image) 
		or not listFindNoCase("png,gif,jpg,jpeg",listLast(arguments.image,"."))>
		<cfreturn "">
	</cfif>
	
	<cfset arguments.Width = trim(replaceNoCase(arguments.Width,"px","","all")) />
	<cfset arguments.Height = trim(replaceNoCase(arguments.Height,"px","","all")) />
	
	<cfif not fileExists(OriginalImageFile)>
		<cfset OriginalImageFile = expandPath(OriginalImageFile) />
		<cfset OriginalImagePath = GetDirectoryFromPath(OriginalImageFile) />
	</cfif>
	
	<cfset OriginalImageType = listLast(OriginalImageFile,".") />
	<cfset OriginalImageFilename = Replace(OriginalImageFile, ".#OriginalImageType#", "", "all") />
	
	<cfif arguments.Width eq "AUTO" and arguments.Height eq "AUTO">
		<cfset NewImageSource = OriginalImageFile />
		<cfset NewImageLocal = arguments.Image />
	<cfelse>
		<cfset NewImageSource = "#OriginalImageFilename#_H#arguments.Height#_W#arguments.Width#.#OriginalImageType#" />
		<cfset NewImageLocal = Replace(OriginalImageFile, ".#OriginalImageType#", "_H#arguments.height#_W#arguments.width#.#OriginalImageType#") />
	</cfif>
	
	<cfset NewImageLocal = listLast(NewImageLocal,variables.configBean.getFileDelim())>
		
	<cfif not FileExists(NewImageSource)>
	
		<cfset OriginalImageFile = Replace(OriginalImageFile, ".#OriginalImageType#", "_source.#OriginalImageType#", "all") />
		
		<cfif not fileExists(OriginalImageFile)>
			<cfset OriginalImageFile = Replace(OriginalImageFile, "_source.#OriginalImageType#", ".#OriginalImageType#", "all") />
		</cfif>
	
		<cfset ThisImage=imageRead(OriginalImageFile)>

		<cfif arguments.Width eq "AUTO">
			<cfif ThisImage.height gt arguments.height>
				<cfset ImageResize(ThisImage,'',arguments.height,variables.instance.imageInterpolation)>
				<cfset ImageWrite(ThisImage,NewImageSource,1)>
			</cfif>
		<cfelseif arguments.Height eq "AUTO">
			<cfif ThisImage.width gt arguments.width>
				<cfset ImageResize(ThisImage,arguments.width,'',variables.instance.imageInterpolation)>
				<cfset ImageWrite(ThisImage,NewImageSource,1)>
			</cfif>
		<cfelse>
			<cfset ImageAspectRatio = ThisImage.Width / ThisImage.height />
			<cfset NewAspectRatio = arguments.Width / arguments.height />
				
			<cfif ImageAspectRatio eq NewAspectRatio>
				<cfif ThisImage.width gt arguments.width>
					<cfset ImageResize(ThisImage,arguments.width,'',variables.instance.imageInterpolation)>
					<cfset ImageWrite(ThisImage,NewImageSource,1)>
				</cfif>
			<cfelseif ImageAspectRatio lt NewAspectRatio>
				<cfset ImageResize(ThisImage,arguments.width,'',variables.instance.imageInterpolation)>
				<cfset CropY = (ThisImage.height - arguments.height)/2 />
				<cfset ImageCrop(ThisImage, 0, CropY, arguments.Width, arguments.height) />
				<cfset ImageWrite(ThisImage,NewImageSource,1)>
			<cfelseif ImageAspectRatio gt NewAspectRatio>
				<cfset ImageResize(ThisImage,'',arguments.height,variables.instance.imageInterpolation)>
				<cfset CropX = (ThisImage.width - arguments.width)/2 />
				<cfset ImageCrop(ThisImage, CropX, 0, arguments.width, arguments.height) />
				<cfset ImageWrite(ThisImage,NewImageSource,1)>
			</cfif>
		</cfif>
		
		<cfif not fileExists(NewImageSource)>
			<cfset getBean("fileWriter").copyFile(source=OriginalImageFile,destination=NewImageSource)>
		</cfif>
	</cfif>
	
	<cfreturn NewImageLocal />
	</cffunction>

	<cffunction name="resizeImage" returntype="void" x>
		<cfargument name="source" required="Yes" type="string">
		<cfargument name="target" required="Yes" type="string">
		<cfargument name="scaleBy" required="Yes" type="string">
		<cfargument name="scale" required="Yes" type="string">
		<cfargument name="serverDirectory" required="Yes" type="string">
		
		<cfset var img = "">
		<cfset var fromX = "">
		<cfset var fromY = "">
		<cfset var isTempSource=false> 
		<cfset var isResized = false>
		<cfset var sourceFile="">
		
		<cfif arguments.source eq arguments.target>
			<cfset sourceFile= "#serverDirectory##createUUID()#.#listLast(source,'.')#"/>
			<cfset isTempSource=true/>
			<cffile action="copy" source="#arguments.source#" destination="#sourceFile#"/>
			<cfset img=imageRead(sourceFile)>
		<cfelse>
			<cfset sourceFile=arguments.source>
			<cfset img=imageRead(arguments.source)>		
		</cfif>
	
		<cfswitch expression="#arguments.scaleBy#">
			<cfcase value="square,s">
				<cfif img.height GT img.width>
					<cfif img.width gt arguments.scale>
						<cfset ImageResize(img,arguments.scale,'',variables.instance.imageInterpolation)>
						<cfset isResized=true>
					</cfif>	
					
					<cfset fromX = img.Height / 2 - ceiling(arguments.scale/2)>
					
					<cfif fromX gt 0>		
						<cfset ImageCrop(img,0,fromX,arguments.scale,arguments.scale)>
						<cfset isResized=true>
					</cfif>
				<cfelseif img.width GT img.height>
					<cfif img.height gt arguments.scale>					
						<cfset ImageResize(img,'',arguments.scale,variables.instance.imageInterpolation)>
						<cfset isResized=true>
					</cfif>
							
					<cfset fromY = img.Width / 2 - ceiling(arguments.scale/2)>
					
					<cfif fromY gt 0>		
						<cfset ImageCrop(img,fromY,0,arguments.scale,arguments.scale)>
						<cfset isResized=true>
					</cfif>				
				<cfelse>
					<cfif img.height gt arguments.scale>			
						<cfset ImageResize(img,'',arguments.scale,variables.instance.imageInterpolation)>
						<cfset ImageCrop(img,0,0,arguments.scale,arguments.scale)>
						<cfset isResized=true>
					</cfif>	
				</cfif> 
			</cfcase>
			<cfcase value="width,x">
				<cfif img.width gt arguments.scale>
					<cfset ImageResize(img,arguments.scale,'',variables.instance.imageInterpolation)>
					<cfset isResized=true>
				</cfif>
			</cfcase>
			<cfcase value="height,y">
				<cfif img.height gt arguments.scale>
					<cfset ImageResize(img,'',arguments.scale,variables.instance.imageInterpolation)>
					<cfset isResized=true>
				</cfif>
			</cfcase>
		</cfswitch>
		
		<cfif isResized>
			<cfset ImageWrite(img,arguments.target,1)>
		<cfelseif arguments.source neq arguments.target>
			<cfset getBean("fileWriter").copyFile(source=arguments.source,destination=arguments.target)>
		</cfif>

		<cfif isTempSource and len(sourceFile)>
			<cftry><cffile action="delete" file="#sourceFile#"><cfcatch></cfcatch></cftry>
		</cfif>		
						
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
		<cfset var serverDirectory=arguments.file.serverDirectory & "/"/>
		<cfset var sourceImageScale=variables.configBean.getValue("sourceImageScale")>
		<cfset var sourceImageScaleBy=variables.configBean.getValue("sourceImageScaleBy")>
				
		<cfset fileStruct.fileObj = '' />
		<cfset fileStruct.fileObjSmall = '' />
		<cfset fileStruct.fileObjMedium =  ''/>
		<cfset fileStruct.fileObjSource =  ''/>
	
		<cfset touchDir("#variables.configBean.getFileDir()##variables.configBean.getFileDelim()##arguments.siteID#")> 
				
		<cfif listLen(serverfilename," ") gt 1>
			<cfset serverFilename=replace(serverFilename," ","-","ALL") />
			
			<cfif fileExists("#serverDirectory##serverFilename#.#arguments.file.serverFileExt#")>
				<cffile action="delete" file="#serverDirectory##serverFilename#.#arguments.file.serverFileExt#">
			</cfif>
			<cffile action="rename" source="#serverDirectory##arguments.file.serverfile#" destination="#serverDirectory##serverFilename#.#arguments.file.serverFileExt#" attributes="normal">
		</cfif>

		<cfset fileStruct.fileObj = "#serverDirectory##serverFilename#.#arguments.file.serverFileExt#" />
			
		<!--- BEGIN IMAGE MANIPULATION --->
		<cfif listFindNoCase('jpg,jpeg,png,gif',arguments.file.ServerFileExt)>
			
			<cfif variables.configBean.getFileStore() eq "fileDir">
				<cfif not isNumeric(sourceImageScale)>
					<cfset sourceImageScale=3000>
				</cfif>
				
				<cfif not len(sourceImageScaleBy) or sourceImageScaleBy eq "w" or sourceImageScaleBy eq "width">
					<cfset sourceImageScaleBy="x">
				<cfelseif sourceImageScaleBy eq "h" or sourceImageScaleBy eq "Height">
					<cfset sourceImageScaleBy="y">
				</cfif>

				<cfif listFindNoCase("x,y",sourceImageScaleBy)>
					<cfset sourceImageScaleBy="x">
				</cfif>
				
				<cfset fileStruct.fileObjSource =  '#serverDirectory##serverFilename#_source.#arguments.file.serverFileExt#'/>
				<cfset resizeImage(fileStruct.fileObj,fileStruct.fileObjSource,sourceImageScaleBy,sourceImageScale,serverDirectory) />			
			</cfif>
		
			<cfset fileStruct.fileObjSmall = "#serverDirectory##serverFilename#_small.#arguments.file.serverFileExt#" />
			<cfset resizeImage(fileStruct.fileObj,fileStruct.fileObjSmall,variables.settingsManager.getSite(arguments.siteID).getGallerySmallScaleBy(),variables.settingsManager.getSite(arguments.siteID).getGallerySmallScale(),serverDirectory) />
			
			<cfif variables.configBean.getFileStore() neq "fileDir">
				<cfset fileStruct.fileObjSmall=fromPath2Binary(fileStruct.fileObjSmall,false) />
				<cftry><cffile action="delete" file="#fileStruct.fileObjSmall#"><cfcatch></cfcatch></cftry>
			</cfif>
			
			<cfset fileStruct.fileObjMedium = "#serverDirectory##serverFilename#_medium.#arguments.file.serverFileExt#" />
			<cfset resizeImage(fileStruct.fileObj,fileStruct.fileObjMedium,variables.settingsManager.getSite(arguments.siteID).getGalleryMediumScaleBy(),variables.settingsManager.getSite(arguments.siteID).getGalleryMediumScale(),serverDirectory) />
			
			<cfif variables.configBean.getFileStore() neq "fileDir">
				<cfset fileStruct.fileObjMedium=fromPath2Binary(fileStruct.fileObjMedium,false) />
				<cftry><cffile action="delete" file="#fileStruct.fileObjMedium#"><cfcatch></cfcatch></cftry>
			</cfif>

			<cfset resizeImage(fileStruct.fileObj,fileStruct.fileObj,variables.settingsManager.getSite(arguments.siteID).getGalleryMainScaleBy(),variables.settingsManager.getSite(arguments.siteID).getGalleryMainScale(),serverDirectory) />			
		
		</cfif>
		
		<cfset fileStruct.theFile=fileStruct.fileObj/>
		
		<cfif variables.configBean.getFileStore() neq "fileDir">
			<cfset fileStruct.fileObj=fromPath2Binary(fileStruct.fileObj,false) />
			<cftry><cffile action="delete" file="#fileStruct.fileObj#"><cfcatch></cfcatch></cftry>
		</cfif>
		
		
		<!---<cftry><cffile action="delete" file="#theFile#"><cfcatch></cfcatch></cftry>--->
		
		<!--- END IMAGE MANIPULATION --->
	
		<cfreturn fileStruct>
		
	</cffunction>

</cfcomponent>
