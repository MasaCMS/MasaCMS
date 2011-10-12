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
	<cfset var serverDirectory=arguments.file.serverDirectory & "/"/>
	
	<cfset fileStruct.fileObj = '' />
	<cfset fileStruct.fileObjSmall = '' />
	<cfset fileStruct.fileObjMedium = '' />
	<cfset fileStruct.fileObjSource = '' />

	<cfif not directoryExists("#variables.configBean.getFileDir()##variables.configBean.getFileDelim()##arguments.siteID#")> 
		<cfdirectory action="create" directory="#variables.configBean.getFileDir()##variables.configBean.getFileDelim()##arguments.siteID#"> 
	</cfif>
				
			<!--- BEGIN IMAGE MANIPULATION --->
			<cfif listFindNoCase('jpg,jpeg,png',arguments.file.ServerFileExt)>
				
				<cfif find(serverfilename," ")>
					<cfset serverFilename=replace(serverFilename," ","-","ALL") />
					<cffile action="rename" source="#serverDirectory##arguments.file.serverfile#" destination="#serverDirectory##serverFilename#.#arguments.file.serverFileExt#">
				</cfif>
	
				
				<cfset imageCFC=getBean('image')/>
				<cfset imageData = imageCFC.getImageInfo("", "#serverDirectory##serverFilename#.#arguments.file.serverFileExt#")>
				
			
				<!--- BEGIN MAIN --->
				<cfif variables.settingsManager.getSite(arguments.siteID).getGalleryMainScaleBy() eq 'x'
				and imageData.width gt variables.settingsManager.getSite(arguments.siteID).getGalleryMainScale()>
					
					<cfset theFile = imageCFC.scaleWidth("", "#serverDirectory##serverFilename#.#arguments.file.serverFileExt#", "#serverDirectory##serverFilename#.#arguments.file.serverFileExt#", variables.settingsManager.getSite(arguments.siteID).getGalleryMainScale())>
				
				<cfelseif imageData.height gt variables.settingsManager.getSite(arguments.siteID).getGalleryMainScale()>
					
					<cfset theFile = imageCFC.scaleHeight("", "#serverDirectory##serverFilename#.#arguments.file.serverFileExt#", "#serverDirectory##serverFilename#.#arguments.file.serverFileExt#", variables.settingsManager.getSite(arguments.siteID).getGalleryMainScale())>	
				
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