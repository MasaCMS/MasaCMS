<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. �See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. �If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (�GPL�) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, �the copyright holders of Mura CMS grant you permission
to combine Mura CMS �with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the �/trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 �without this exception. �You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" returntype="any">
<cfargument name="configBean">
<cfargument name="settingsManager">

	<cfset variables.configBean=arguments.configBean/>
	<cfset variables.settingsManager=arguments.settingsManager/>
	<cfset variables.instance.imageInterpolation=arguments.configBean.getImageInterpolation()>
	
	<cfreturn this />
</cffunction>

<cffunction name="touchDir" returntype="void" output="no">
	<cfargument name="dir" required="Yes" type="string">
		<cfargument name="mode" required="no" type="string" default="777">
		<cfif not directoryExists(dir)>
			<cfdirectory directory="#dir#" action="create" mode="#arguments.mode#">
		</cfif>
</cffunction>

<cffunction name="resizeImage" returntype="void" output="no">
		<cfargument name="source" required="Yes" type="string">
		<cfargument name="target" required="Yes" type="string">
		<cfargument name="scaleBy" required="Yes" type="string">
		<cfargument name="scale" required="Yes" type="string">
		<cfargument name="serverDirectory" required="Yes" type="string">
		
		<cfset var img = "">
		<cfset var fromX = "">
		<cfset var fromY = "">
		<cfset var tempFile = "">
		
		<cfif arguments.source eq arguments.target>
			<cfset tempFile= "#serverDirectory##createUUID()#.#listLast(source,'.')#"/>
			<cffile action="copy" source="#arguments.source#" destination="#tempFile#"/>
			<cfimage action="READ" source="#tempFile#" name="img">
		<cfelse>		
			<cfimage action="READ" source="#arguments.source#" name="img">
		</cfif>
		

		<cfswitch expression="#arguments.scaleBy#">
		<cfcase value="square,s">
			<cfif img.height GT img.width>
			<cfset ImageResize(img,arguments.scale,'',variables.instance.imageInterpolation)>
					
				<cfset fromX = img.Height / 2 - ceiling(arguments.scale/2)>
				
				<cfif fromX gt 0>		
					<cfset ImageCrop(img,0,fromX,arguments.scale,arguments.scale)>
				</cfif>
			<cfelseif img.width GT img.height>
									
				<cfset ImageResize(img,'',arguments.scale,variables.instance.imageInterpolation)>
						
				<cfset fromY = img.Width / 2 - ceiling(arguments.scale/2)>
				
				<cfif fromY gt 0>		
					<cfset ImageCrop(img,fromY,0,arguments.scale,arguments.scale)>
				</cfif>				
			<cfelse>
						
				<cfset ImageResize(img,'',arguments.scale,variables.instance.imageInterpolation)>
						
				<cfset ImageCrop(img,0,0,arguments.scale,arguments.scale)>
					
			</cfif> 
		</cfcase>
		<cfcase value="width,x">
			<cfif img.width gt arguments.scale>
				<cfset ImageResize(img,arguments.scale,'',variables.instance.imageInterpolation)>
			</cfif>
		</cfcase>
		<cfcase value="height,y">
			<cfif img.height gt arguments.scale>
				<cfset ImageResize(img,'',arguments.scale,variables.instance.imageInterpolation)>
			</cfif>
		</cfcase>
		</cfswitch>
		
			
		<cfset ImageWrite(img,arguments.target)>

		<cfif len(tempFile)>
			<cfimage action="READ" source="#arguments.target#" name="img">
			<cftry><cffile action="delete" file="#tempFile#"><cfcatch></cfcatch></cftry>
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
	<cfset var refused=false />
	<cfset var serverFilename=arguments.file.serverfilename />
	<cfset var serverDirectory=arguments.file.serverDirectory & "/"/>
	
	<cfset fileStruct.fileObj = '' />
	<cfset fileStruct.fileObjSmall = '' />
	<cfset fileStruct.fileObjMedium =  ''/>

	<cfset touchDir("#variables.configBean.getFileDir()##variables.configBean.getFileDelim()##arguments.siteID#")> 
				
			
			<cfif listLen(serverfilename," ") gt 1>
				<cfset serverFilename=replace(serverFilename," ","-","ALL") />
				
				<cfif fileExists("#serverDirectory##serverFilename#.#arguments.file.serverFileExt#")>
					<cffile action="delete" file="#serverDirectory##serverFilename#.#arguments.file.serverFileExt#">
				</cfif>
				<cffile action="rename" source="#serverDirectory##arguments.file.serverfile#" destination="#serverDirectory##serverFilename#.#arguments.file.serverFileExt#" attributes="normal">
			</cfif>
	
			<cfset theFile = "#serverDirectory##serverFilename#.#arguments.file.serverFileExt#" />
				
			<!--- BEGIN IMAGE MANIPULATION --->
			<cfif listFindNoCase('jpg,jpeg,png,gif',arguments.file.ServerFileExt)>
				
					<cfset resizeImage(theFile,theFile,variables.settingsManager.getSite(arguments.siteID).getGalleryMainScaleBy(),variables.settingsManager.getSite(arguments.siteID).getGalleryMainScale(),serverDirectory) />			
					<cfset theSmall = "#serverDirectory##serverFilename#_small.#arguments.file.serverFileExt#" />
			
					<cfset resizeImage(theFile,theSmall,variables.settingsManager.getSite(arguments.siteID).getGallerySmallScaleBy(),variables.settingsManager.getSite(arguments.siteID).getGallerySmallScale(),serverDirectory) />
					<cfset fileStruct.fileObjSmall=fromPath2Binary(theSmall,false) />
					
					<cfset theMedium = "#serverDirectory##serverFilename#_medium.#arguments.file.serverFileExt#" />
					<cfset resizeImage(theFile,theMedium,variables.settingsManager.getSite(arguments.siteID).getGalleryMediumScaleBy(),variables.settingsManager.getSite(arguments.siteID).getGalleryMediumScale(),serverDirectory) />
					<cfset fileStruct.fileObjMedium=fromPath2Binary(theMedium,false) />
	
					<cftry><cffile action="delete" file="#theMedium#"><cfcatch></cfcatch></cftry>
					<cftry><cffile action="delete" file="#theSmall#"><cfcatch></cfcatch></cftry>
	
			</cfif>
			<!--- END IMAGE MANIPULATION --->
			
			<cfset fileStruct.fileObj=fromPath2Binary(theFile,false) />
			<cfset fileStruct.theFile=theFile/>
			<cftry><cffile action="delete" file="#theFile#"><cfcatch></cfcatch></cftry>
			
			<cfreturn fileStruct>
		
</cffunction>

</cfcomponent>
