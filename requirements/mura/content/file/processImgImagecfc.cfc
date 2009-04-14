<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->
<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" returntype="any">
<cfargument name="configBean">
<cfargument name="settingsManager">

	<cfset variables.configBean=arguments.configBean />
	<cfset variables.settingsManager=arguments.settingsManager />
	<cfreturn this />
</cffunction>

<cffunction name="getBlur" returnType="struct" outout="false">
	<cfargument name="source">
	<cfargument name="target">
		
	<cfset var blurMe=structNew() />
	<cfset var ratio=1-(arguments.target/arguments.source) />
	<cfset var diff=arguments.source-arguments.target  />

	<cfif ratio gt .7>
			<cfset blurMe.amount = 7 />
		 	<cfset blurMe.times =  2 />
		 <!---<cfif diff gt 2500>	
			<cfset blurMe.amount = 1 />
 			<cfset blurMe.times =  ceiling(ratio  * 3) />
		<cfelseif diff gt 2250>
			<cfset blurMe.amount = 1 />
	 		<cfset blurMe.times =  ceiling(ratio  * 2) />
	 	<cfelseif diff gt 2000>
			<cfset blurMe.amount = 1 />
	 		<cfset blurMe.times =  ceiling(ratio  * 1) />
		<cfelseif diff gt 1750>
			<cfset blurMe.amount = 1 />
	 		<cfset blurMe.times =  ceiling(ratio  * 1) />	
	 	<cfelseif diff gt 1500>
			<cfset blurMe.amount = 1 />
	 		<cfset blurMe.times =  ceiling(ratio  * 1) />
	 	<cfelseif diff gt 1250>
			<cfset blurMe.amount = 1 />
	 		<cfset blurMe.times =  ceiling(ratio  * 1) />
	 	<cfelseif diff gt 500>
			<cfset blurMe.amount = 1 />
	 		<cfset blurMe.times =  ceiling(ratio  * 1) />
	 	<cfelse>
	 		<cfset blurMe.amount = 0 />
		 	<cfset blurMe.times =  0 />
		</cfif> --->
	<cfelse>
		<cfset blurMe.amount = 0 />
	 	<cfset blurMe.times =  0 />
	</cfif>

	<cfreturn blurMe />
</cffunction>


<cffunction name="Process" returnType="struct">
<cfargument name="file">
<cfargument name="siteID">

	<cfset var fileStruct = structNew() >
	<cfset var imageCFC=""/>
	<cfset var theFile=""/>
	<cfset var theSmall=""/>
	<cfset var theMedium=""/>
	<cfset var fileObj=""/>
	<cfset var fileObjSmall=""/>
	<cfset var fileObjMedium=""/>
	<cfset var refused=false />
	<cfset var blurMe=structNew() />
	<cfset var imageData="" />
	<cfset var serverFilename=arguments.file.serverfilename />
	<cfset var serverDirectory=arguments.file.arguments.file.serverDirectory & "/"/>
	
	<cfset fileStruct.fileObj = '' />
	<cfset fileStruct.fileObjSmall = '' />
	<cfset fileStruct.fileObjMedium = '' />

	<cfif not directoryExists("#variables.configBean.getFileDir()##variables.configBean.getFileDelim()##arguments.siteID#")> 
		<cfdirectory action="create" directory="#variables.configBean.getFileDir()##variables.configBean.getFileDelim()##arguments.siteID#"> 
	</cfif>
				
			<!--- BEGIN IMAGE MANIPULATION --->
			<cfif listFindNoCase('jpg,jpeg,png',arguments.file.ServerFileExt) and  arguments.file.contentType eq "Image">
				
				<cfif find(serverfilename," ")>
					<cfset serverFilename=replace(serverFilename," ","-","ALL") />
					<cffile action="rename" source="#serverDirectory##arguments.file.serverfile#" destination="#serverDirectory##serverFilename#.#arguments.file.serverFileExt#">
				</cfif>
	
				
				<cfset imageCFC=application.serviceFactory.getBean('image')/>
				<cfset imageData = imageCFC.getImageInfo("", "#serverDirectory##serverFilename#.#arguments.file.serverFileExt#")>
				
			
				<!--- BEGIN MAIN --->
				<cfif variables.settingsManager.getSite(arguments.siteID).getGalleryMainScaleBy() eq 'x'
				and imageData.width gt variables.settingsManager.getSite(arguments.siteID).getGalleryMainScale()>
					
					<cfset theFile = imageCFC.scaleWidth("", "#serverDirectory##serverFilename#.#arguments.file.serverFileExt#", "#getserverDirectoryectory()##serverFilename#.#arguments.file.serverFileExt#", variables.settingsManager.getSite(arguments.siteID).getGalleryMainScale())>
				
				<cfelseif imageData.height gt variables.settingsManager.getSite(arguments.siteID).getGalleryMainScale()>
					
					<cfset theFile = imageCFC.scaleHeight("", "#serverDirectory##serverFilename#.#arguments.file.serverFileExt#", "#getserverDirectoryectory()##serverFilename#.#arguments.file.serverFileExt#", variables.settingsManager.getSite(arguments.siteID).getGalleryMainScale())>	
				
			</cfif>
				
				<!--- BEGIN SMALL --->
				<!--- <cfset blurMe=getBlur(imageData.width ,variables.settingsManager.getSite(arguments.siteID).getGallerySmallScale()) />
				<cfset theSmall = imageCFC.filterFastBlur("", "#serverDirectory##serverFilename#.#arguments.file.serverFileExt#", "#serverDirectory##serverFilename#_Small.#arguments.file.serverFileExt#",blurMe.amount,blurMe.times,100)>
				 --->
				<cfif variables.settingsManager.getSite(arguments.siteID).getGallerySmallScaleBy() eq 'x' 
				and imageData.width gt variables.settingsManager.getSite(arguments.siteID).getGallerySmallScale()> 
					
					<cfset blurMe=getBlur(imageData.width ,variables.settingsManager.getSite(arguments.siteID).getGallerySmallScale()) />
					<cfset theSmall = imageCFC.filterFastBlur("", "#serverDirectory##serverFilename#.#arguments.file.serverFileExt#", "#serverDirectory##serverFilename#_Small.#arguments.file.serverFileExt#",blurMe.amount,blurMe.times,100)>
					<cfset theSmall = imageCFC.scaleWidth("", "#serverDirectory##serverFilename#_Small.#arguments.file.serverFileExt#", "#serverDirectory##serverFilename#_Small.#arguments.file.serverFileExt#", variables.settingsManager.getSite(arguments.siteID).getGallerySmallScale(),100)>
					<cffile action="readBinary" file="#serverDirectory##serverFilename#_Small.#arguments.file.serverFileExt#" variable="fileObjSmall">
					<cfset fileStruct.fileObjSmall=fileObjSmall />
					
				<cfelseif variables.settingsManager.getSite(arguments.siteID).getGallerySmallScaleBy() eq 'y'
				and imageData.height gt variables.settingsManager.getSite(arguments.siteID).getGallerySmallScale()>
					
					<cfset blurMe=getBlur(imageData.height ,variables.settingsManager.getSite(arguments.siteID).getGallerySmallScale()) />
					<cfset theSmall = imageCFC.filterFastBlur("", "#serverDirectory##serverFilename#.#arguments.file.serverFileExt#", "#serverDirectory##serverFilename#_Small.#arguments.file.serverFileExt#",blurMe.amount,blurMe.times,100)>
					<cfset theSmall = imageCFC.scaleHeight("", "#serverDirectory##serverFilename#_Small.#arguments.file.serverFileExt#", "#serverDirectory##serverFilename#_Small.#arguments.file.serverFileExt#", variables.settingsManager.getSite(arguments.siteID).getGallerySmallScale(),100)>
					<cffile action="readBinary" file="#serverDirectory##serverFilename#_Small.#arguments.file.serverFileExt#" variable="fileObjSmall">
					<cfset fileStruct.fileObjSmall=fileObjSmall />
					
				<cfelseif variables.settingsManager.getSite(arguments.siteID).getGallerySmallScaleBy() eq 's'
				and (imageData.height gt variables.settingsManager.getSite(arguments.siteID).getGallerySmallScale()
				or imageData.width gt variables.settingsManager.getSite(arguments.siteID).getGallerySmallScale())>
					
					<!---<cfset blurMe=getBlur((imageData.height+imageData.width)/2 ,variables.settingsManager.getSite(arguments.siteID).getGallerySmallScale()) />
					<cfset theSmall = imageCFC.filterFastBlur("", "#serverDirectory##serverFilename#.#arguments.file.serverFileExt#", "#serverDirectory##serverFilename#_Small.#arguments.file.serverFileExt#",blurMe.amount,blurMe.times,100)>--->
					<cfset theSmall = imageCFC.resize("", "#serverDirectory##serverFilename#.#arguments.file.serverFileExt#", "#serverDirectory##serverFilename#_Small.#arguments.file.serverFileExt#", variables.settingsManager.getSite(arguments.siteID).getGallerySmallScale(), variables.settingsManager.getSite(arguments.siteID).getGallerySmallScale(),true,true,100)>
					<cffile action="readBinary" file="#serverDirectory##serverFilename#_Small.#arguments.file.serverFileExt#" variable="fileObjSmall">
					<cfset fileStruct.fileObjSmall=fileObjSmall />
					
				<cfelse>
					<cffile action="readBinary" file="#serverDirectory##serverFilename#.#arguments.file.serverFileExt#" variable="fileObjSmall">
					<cfset fileStruct.fileObjSmall=fileObjSmall />
				</cfif>

			
				<!--- BEGIN MEDIUM --->
				<cfif variables.settingsManager.getSite(arguments.siteID).getGalleryMediumScaleBy() eq 'x' 
				and imageData.width gt variables.settingsManager.getSite(arguments.siteID).getGalleryMediumScale()> 
					
					<cfset blurMe=getBlur((imageData.height+imageData.width)/2 ,variables.settingsManager.getSite(arguments.siteID).getGalleryMediumScale()) />
					<cfset theMedium = imageCFC.filterFastBlur("", "#serverDirectory##serverFilename#.#arguments.file.serverFileExt#", "#serverDirectory##serverFilename#_Medium.#arguments.file.serverFileExt#",blurMe.amount,blurMe.times,100)>
					<cfset theMedium = imageCFC.scaleWidth("", "#serverDirectory##serverFilename#.#arguments.file.serverFileExt#", "#serverDirectory##serverFilename#_Medium.#arguments.file.serverFileExt#", variables.settingsManager.getSite(arguments.siteID).getGalleryMediumScale())>
					<cffile action="readBinary" file="#serverDirectory##serverFilename#_Medium.#arguments.file.serverFileExt#" variable="fileObjMedium">
					<cfset fileStruct.fileObjMedium=fileObjMedium />
				
				<cfelseif variables.settingsManager.getSite(arguments.siteID).getGalleryMediumScaleBy() eq 'y'
				and imageData.height gt variables.settingsManager.getSite(arguments.siteID).getGalleryMediumScale()>
					
					<cfset blurMe=getBlur((imageData.height+imageData.width)/2 ,variables.settingsManager.getSite(arguments.siteID).getGalleryMediumScale()) />
					<cfset theMedium = imageCFC.filterFastBlur("", "#serverDirectory##serverFilename#.#arguments.file.serverFileExt#", "#serverDirectory##serverFilename#_Medium.#arguments.file.serverFileExt#",blurMe.amount,blurMe.times,100)>
					<cfset theMedium = imageCFC.scaleHeight("", "#serverDirectory##serverFilename#.#arguments.file.serverFileExt#", "#serverDirectory##serverFilename#_Medium.#arguments.file.serverFileExt#", variables.settingsManager.getSite(arguments.siteID).getGalleryMediumScale())>
					<cffile action="readBinary" file="#serverDirectory##serverFilename#_Medium.#arguments.file.serverFileExt#" variable="fileObjMedium">
					<cfset fileStruct.fileObjMedium=fileObjMedium />
					
				<cfelseif variables.settingsManager.getSite(arguments.siteID).getGalleryMediumScaleBy() eq 's'
				and (imageData.height gt variables.settingsManager.getSite(arguments.siteID).getGalleryMediumScale()
				or imageData.width gt variables.settingsManager.getSite(arguments.siteID).getGalleryMediumScale())>
					
					<!---<cfset blurMe=getBlur((imageData.height+imageData.width)/2 ,variables.settingsManager.getSite(arguments.siteID).getGalleryMediumScale()) />
					<cfset theMedium = imageCFC.filterFastBlur("", "#serverDirectory##serverFilename#.#arguments.file.serverFileExt#", "#serverDirectory##serverFilename#_Medium.#arguments.file.serverFileExt#",blurMe.amount,blurMe.times,100)>--->
					<cfset theMedium = imageCFC.resize("", "#serverDirectory##serverFilename#.#arguments.file.serverFileExt#", "#serverDirectory##serverFilename#_Medium.#arguments.file.serverFileExt#", variables.settingsManager.getSite(arguments.siteID).getGalleryMediumScale(), variables.settingsManager.getSite(arguments.siteID).getGalleryMediumScale(),true,true,100)>
					<cffile action="readBinary" file="#serverDirectory##serverFilename#_Medium.#arguments.file.serverFileExt#" variable="fileObjMedium">
					<cfset fileStruct.fileObjMedium=fileObjMedium />
				
				<cfelse>
					<cffile action="readBinary" file="#serverDirectory##serverFilename#.#arguments.file.serverFileExt#" variable="fileObjMedium">
					<cfset fileStruct.fileObjMedium=fileObjMedium />
				</cfif>
			</cfif>
			
			<cffile action="readBinary" file="#serverDirectory##serverFilename#.#arguments.file.serverFileExt#" variable="fileObj">
			<cfset fileStruct.fileObj=fileObj />
			
			<cfif file.ServerFileExt eq 'gif'>	
				<cfset fileStruct.fileObjSmall=fileObj />
				<cfset fileStruct.fileObjMedium=fileObj />
			</cfif>
			<!--- END BEGIN IMAGE MANIPULATION --->
			
			<cffile action="delete" file="#serverDirectory##serverFilename#.#arguments.file.serverFileExt#">
			
			<cfif listFindNoCase('jpg,jpeg,png',arguments.file.ServerFileExt)>
						
				<cftry>
					<cffile action="delete" file="#serverDirectory##serverFilename#_Small.#arguments.file.serverFileExt#">
					<cfcatch></cfcatch></cftry>
				<cftry>
					<cffile action="delete" file="#serverDirectory##serverFilename#_Medium.#arguments.file.serverFileExt#">
					<cfcatch></cfcatch></cftry>
				
			</cfif>
			
			<cfreturn fileStruct>
		
</cffunction>		

</cfcomponent>