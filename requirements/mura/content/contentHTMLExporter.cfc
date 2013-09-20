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

<cfset variables.configBean="">
<cfset variables.settingsManager="">
<cfset variables.contentManager="">
<cfset variables.utility="">

<cffunction name="init">
	<cfargument name="configBean" />
	<cfargument name="settingsManager" />
	<cfargument name="contentManager" />
	<cfargument name="utility" />
	<cfargument name="filewriter" 
	/>
	<cfargument name="contentServer" />
	<cfset variables.configBean=arguments.configBean>
	<cfset variables.settingsManager=arguments.settingsManager>
	<cfset variables.contentManager=arguments.contentManager>
	<cfset variables.utility=arguments.utility>
	<cfset variables.filewriter=arguments.filewriter>
	<cfset variables.contentServer=arguments.contentServer>
	<cfreturn this>	
</cffunction>

<cffunction name="export">
	<cfargument name="siteid" type="string" required="true" />
	<cfargument name="exportDir" type="string" required="true" />
	
	<cfset var $=getBean("MuraScope").init(arguments.siteID)>
	<cfset var fileDelim = variables.configBean.getFileDelim()>
	<cfset var localval="">
	
	<cfsetting requestTimeout = "7200">
	
	<cfif listFind("/,\",right(arguments.exportDir,1))>
		<cfset arguments.exportDir=left(arguments.exportDir, len(arguments.exportDir)-1 )>
	</cfif>
	
	<cfif directoryExists("#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.siteID##fileDelim#")>
		<cfset variables.fileWriter.deleteDir("#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.siteID##fileDelim#")>
	</cfif>
	
	<cfif len($.globalConfig("context"))>
		<cfset variables.fileWriter.createDir("#arguments.exportDir##$.globalConfig("context")#")>
	</cfif>
	
	<cfset variables.fileWriter.createDir("#arguments.exportDir##$.globalConfig("context")##fileDelim##arguments.siteID#")>
	<cfset localval = "#$.globalConfig('webroot')##fileDelim##arguments.siteid##fileDelim#css#fileDelim#">
	<cfset localval = localval & " to " & "#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.siteID##fileDelim#css#fileDelim#">
	
	<cfset variables.fileWriter.copyDir("#$.globalConfig('webroot')##fileDelim##arguments.siteid##fileDelim#css#fileDelim#", "#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.siteID##fileDelim#css#fileDelim#") />
	<cfset variables.fileWriter.copyDir("#$.globalConfig('webroot')##fileDelim##arguments.siteid##fileDelim#flash#fileDelim#", "#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.siteID##fileDelim#flash#fileDelim#") />
	<cfset variables.fileWriter.copyDir("#$.globalConfig('webroot')##fileDelim##arguments.siteid##fileDelim#images#fileDelim#", "#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.siteID##fileDelim#images#fileDelim#") />
	<cfset variables.fileWriter.copyDir("#$.globalConfig('webroot')##fileDelim##arguments.siteid##fileDelim#js#fileDelim#", "#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.siteID##fileDelim#js#fileDelim#") />
	<cfset variables.fileWriter.copyDir("#$.globalConfig('assetDir')##fileDelim##arguments.siteid##fileDelim#assets#fileDelim#", "#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.siteID##fileDelim#assets#fileDelim#") />
	<!--- Add jquery to the export --->
	<cfset variables.fileWriter.copyDir("#$.globalConfig('assetDir')##fileDelim##arguments.siteid##fileDelim#jquery#fileDelim#", "#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.siteID##fileDelim#jquery#fileDelim#") />
	
	<cfset variables.fileWriter.createDir("#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.siteID##fileDelim#includes")>
	<cfset variables.fileWriter.createDir("#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.siteID##fileDelim#includes#fileDelim#themes")>

	<!---<cfset variables.fileWriter.createDir("#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.siteID##fileDelim#includes#fileDelim#themes#fileDelim##$.siteConfig('theme')#")>--->
	<cfset variables.fileWriter.copyDir(expandPath("#$.siteConfig('themeIncludePath')##fileDelim#"), "#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.siteID##fileDelim#includes#fileDelim#themes#fileDelim##$.siteConfig('theme')##fileDelim#") />
	
	<cfset variables.fileWriter.createDir("#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.siteID##fileDelim#cache")>
	<cfset variables.fileWriter.createDir("#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.siteID##fileDelim#cache#fileDelim#file")>

	<cfif directoryExists("#$.siteConfig('themeIncludePath')##fileDelim#css")>
		<cfset variables.fileWriter.copyDir(expandPath("#$.siteConfig('themeIncludePath')##fileDelim#css#fileDelim#"), "#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.siteID##fileDelim#includes#fileDelim#themes#fileDelim##$.siteConfig('theme')##fileDelim#css#fileDelim#") />
	</cfif>
	<cfif directoryExists("#$.siteConfig('themeIncludePath')##fileDelim#flash")>
		<cfset variables.fileWriter.copyDir(expandPath("#$.siteConfig('themeIncludePath')##fileDelim#flash#fileDelim#"), "#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.siteID##fileDelim#includes#fileDelim#themes#fileDelim##$.siteConfig('theme')##fileDelim#flash#fileDelim#") />
	</cfif>
	<cfif directoryExists("#$.siteConfig('themeIncludePath')##fileDelim#images")>
		<cfset variables.fileWriter.copyDir(expandPath("#$.siteConfig('themeIncludePath')##fileDelim#images#fileDelim#"), "#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.siteID##fileDelim#includes#fileDelim#themes#fileDelim##$.siteConfig('theme')##fileDelim#images#fileDelim#") />
	</cfif>
	<cfif directoryExists("#$.siteConfig('themeIncludePath')##fileDelim#js")>
		<cfset variables.fileWriter.copyDir(expandPath("#$.siteConfig('themeIncludePath')##fileDelim#js#fileDelim#"), "#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.siteID##fileDelim#includes#fileDelim#themes#fileDelim##$.siteConfig('theme')##fileDelim#js#fileDelim#") />
	</cfif>
	<cfset localval = expandPath("#$.siteConfig('themeIncludePath')##fileDelim#images#fileDelim#")>
	
	<cfset traverseSite('00000000000000000000000000000000END', arguments.siteid, arguments.exportDir) />
	
</cffunction>
	
<cffunction name="traverseSite">
	<cfargument name="contentid" type="string" required="true" />
	<cfargument name="siteid" type="string" required="true" />
	<cfargument name="exportDir" type="string" required="true" />
	<cfargument name="sortBy" type="string" required="yes" default="orderno" />
	<cfargument name="sortDirection" type="string" required="yes" default="asc" />
	<cfset var rs = "" />
	<cfset var contentBean = "" />
	<cfset var it=getBean('contentIterator')>
		
	<cfset rs=variables.contentManager.getNest(arguments.contentid,arguments.siteid,arguments.sortBy,arguments.sortDirection) />
	<cfset it.setQuery(rs)>	
	<cfloop condition="it.hasNext()">
		<cfset contentBean=it.next()>
	 	
	 	<cfif contentBean.getHasKids()>
			<cfset traverseSite(contentBean.getContentID(), contentBean.getSiteID(), arguments.exportDir,contentBean.getSortBy(), contentBean.getSortDirection()) />	
		</cfif>
		
		<cfset exportNode(contentBean,arguments.exportDir)>
		
	</cfloop>
	
</cffunction>

<cffunction name="exportNode" output="false">
	<cfargument name="contentBean" type="any" required="true"/>
	<cfargument name="exportDir" type="string" required="true" />
	<cfset var fileOutput = "" />
	<cfset var rsFile = "" />
	<cfset var filepath = "" />
	<cfset var basepath = "" />
	<cfset var servlet = "" />
	<cfset var nextn = "" />
	<cfset var rsSection = "" />
	<cfset var rsFiles = "" />
	<cfset var filedir = "" />
	<cfset var i = "" />
	<cfset var $=getBean("MuraScope").init(arguments.contentBean.getSiteID())>
	<cfset var newdir="">
	<cfset var fileDelim = variables.configBean.getFileDelim()>
	
	<cfif listFind("/,\",right(arguments.exportDir,1))>
		<cfset arguments.exportDir=left(arguments.exportDir, len(arguments.exportDir)-1 )>
	</cfif>
	
	<cfset request.muraValidateDomain=false>
	<cfset request.muraExportHtml = true>
	<cfset request.siteid = arguments.contentBean.getSiteID()>

	<cfif not listFindNoCase("Link,File",arguments.contentBean.getType())>		
			<cfset request.currentFilename = arguments.contentBean.getFilename()>
			<cfset request.currentFilenameAdjusted=request.currentFilename>		
			<cfset request.contentBean=arguments.contentBean>

			<cfset request.servletEvent = createObject("component","mura.servletEvent").init() />
			<cfset structDelete(request.servletEvent.getAllValues(),"crumbdata")>
			<cfset fileOutput=variables.contentServer.doRequest(request.servletEvent)>
			
			<cfif variables.configBean.getSiteIDInURLS()>
				<cfset filePath = "#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.contentBean.getSiteID()##fileDelim##arguments.contentBean.getFilename()##fileDelim#index.html">
			<cfelse>
				<cfset filePath = "#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.contentBean.getFilename()##fileDelim#index.html">
			</cfif>
			
			<cfif variables.configBean.getSiteIDInURLS()>
				<cfset newdir="#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.contentBean.getSiteID()##fileDelim##arguments.contentBean.getFilename()#">
			<cfelse>
				<cfset newdir="#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.contentBean.getFilename()#">
			</cfif>
			
			<cfif not directoryExists(newdir)>
				<cfset variables.fileWriter.createDir(newdir)>
			</cfif>
			
			<cfif fileExists(filepath)>
				<cffile action="delete" file="#filepath#">
			</cfif>
					
			<cfset variables.fileWriter.writeFile(file = "#filepath#",output = "#fileOutput#")>
	</cfif>		
	
	<cfif len(arguments.contentBean.getFileID())>
			<cfif arguments.contentBean.getType() eq "File">
				<cfset variables.fileWriter.createDir("#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.contentBean.getSiteID()##fileDelim#cache#fileDelim#file#fileDelim##arguments.contentBean.getFileID()#")>
				<cfset variables.fileWriter.copyFile(source="#$.globalConfig('fileDir')##fileDelim##arguments.contentBean.getSiteID()##fileDelim#cache#fileDelim#file#fileDelim##arguments.contentBean.getFileID()#.#arguments.contentBean.getFileEXT()#", destination="#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.contentBean.getSiteID()##fileDelim#cache#fileDelim#file#fileDelim##arguments.contentBean.getFileID()##fileDelim##arguments.contentBean.getAssocFilename()#")>
			</cfif>
			
			<cfif listFindNoCase("jpg,jpeg,gif,png",arguments.contentBean.getFileEXT())>
				<cfdirectory action="list" directory="#$.globalConfig('fileDir')##fileDelim##arguments.contentBean.getSiteID()##fileDelim#cache#fileDelim#file" filter="#arguments.contentBean.getFileID()#*" name="rsFiles">
				<cfloop query="rsFiles">
					<cfset variables.fileWriter.copyFile(source="#$.globalConfig('fileDir')##fileDelim##arguments.contentBean.getSiteID()##fileDelim#cache#fileDelim#file#fileDelim##rsFiles.name#", destination="#arguments.exportDir##$.globalConfig('context')##fileDelim##arguments.contentBean.getSiteID()##fileDelim#cache#fileDelim#file#fileDelim##rsFiles.name#")>
				</cfloop>
			</cfif>
	</cfif>
			
	<cfif listFindNoCase("Folder,Gallery",arguments.contentBean.getType())>
			<cfset rsSection=contentBean.getKidsQuery()>
			<cfset nextN=application.utility.getNextN(rsSection,arguments.contentBean.getNextN(),1)>
			
			<cfif nextN.numberofpages gt 1>
				
				<cfloop from="2" to="#nextN.numberofpages#" index="i">
					<cfset request.currentFilename = arguments.contentBean.getFilename()>
					<cfset request.servletEvent = createObject("component","mura.servletEvent").init() />
					<cfset request.servletEvent.setValue("startrow",(i*nextN.recordsperpage)-nextN.recordsperpage+1)>
					<cfset request.servletEvent.setValue("nextNID",arguments.contentBean.getContentID())>
					
					<cfset fileOutput=variables.contentServer.doRequest(request.servletEvent)>
					
					<cfif variables.configBean.getSiteIDInURLS()>
						<cfset filePath = "#arguments.exportDir##variables.configBean.getContext()#/#arguments.contentBean.getSiteID()#/#arguments.contentBean.getFilename()#/index#i#.html">
					<cfelse>
						<cfset filePath = "#arguments.exportDir##variables.configBean.getContext()#/#arguments.contentBean.getFilename()#/index#i#.html">
					</cfif>
					
					<cfif fileExists(filepath)>
						<cffile action="delete" file="#filepath#">
					</cfif>
					
					<cfset variables.fileWriter.writeFile(file = "#filepath#",output = "#fileOutput#")>
					
				</cfloop>
				
			</cfif>		
		
	</cfif>
		
	<cfset request.startRow=1>
	<cfset request.muraExportHtml = false>
	
</cffunction>

</cfcomponent>