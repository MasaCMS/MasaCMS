<cfsilent>
<cfparam name="attributes.location" default="" />
<cfparam name="session.location" default="assets" />
<cfparam name="session.siteID" default="">
<cffunction name="dumpArgs">
<cfdump var="#arguments#"><cfabort>
</cffunction>

<cfif attributes.location neq ''>
<cfset session.location=attributes.location />
</cfif>

<cfswitch expression="#session.location#">
<cfcase value="files">
<cfset attributes.fmTitle="Site Files" />
<cfset attributes.includeDir="#application.configBean.getWebRoot()##application.configBean.getFileDelim()##session.siteid##application.configBean.getFileDelim()#" />
<cfset attributes.includeDirWeb="#application.configBean.getContext()#/#session.siteid#" />
</cfcase>
<cfcase value="assets">
<cfset attributes.fmTitle="User Assets" />
<cfset attributes.includeDir="#application.configBean.getFileDir()##application.configBean.getFileDelim()##session.siteid##application.configBean.getFileDelim()#assets#application.configBean.getFileDelim()#" />
<cfset attributes.includeDirWeb="#application.configBean.getAssetPath()#/#session.siteid#/assets" />
</cfcase>
<cfcase value="root">
<cfif listFindNoCase(session.mura.memberships,'S2')>
<cfset attributes.fmTitle="Application Root" />
<cfset attributes.includeDir="#application.configBean.getWebRoot()##application.configBean.getFileDelim()#" />
<cfset attributes.includeDirWeb="#application.configBean.getContext()#" />
<cfelse>
<cflocation addtoken="false" url="#application.configBean.getContext()#/admin/">
</cfif>
</cfcase>
</cfswitch>
</cfsilent>
<cfsetting enablecfoutputonly="yes">
<!---
	CFFM 1.1
	Written by Rick Root (rick@webworksllc.com)
	See LICENSE.TXT for copyright and redistribution restrictions.	

	File:  cffm.cfm
--->
<!---		**************************************************
			LOAD THE RESOURCE BUNDLE FIRST
			**************************************************
--->
<cfscript>
	variables.rbm = createObject('component','javaRB');
	variables.defaultJavaLocale = "en_US";
	variables.rbDir=ExpandPath("/#application.configBean.getWebRootMap()#/admin/filemanager/");
	variables.rbFile= rbDir & "cffm.properties"; //base resource file
	variables.resourceKit = variables.rbm.getResourceBundle("#variables.rbFile#","#variables.defaultJavaLocale#");
</cfscript>

<!---		**************************************************
			INITIALIZE the CFC
			**************************************************
--->
<cfset cffm = createObject("component","cffm")>
<cfinvoke component="#cffm#" method="init">
	<!--- includeDir = You can and probably should hard code this... by default, the directory is a 
		directory named "custom" located in the same directory as this file. --->
	<cfinvokeargument name="includeDir" value="#attributes.includeDir#">
	<!--- includeDirWeb = web path to the directory specified above. --->
	<cfinvokeargument name="includeDirWeb" value="#attributes.includeDirWeb#">
	<!--- disallowedExtensions = file extensions you don't want people to upload --->
	<cfinvokeargument name="disallowedExtensions" value="">
	<!---
	// allowedExtensions = 
	// as an alternative to disallowing extensions, you can allow 
	// only certain extensions.  This overrides the disallowedExtensions
	// setting.  You might use this to restrict the user to uploading
	// images or something.
	--->
	<cfinvokeargument name="allowedExtensions" value="">
	<!--- editableExtensions:  specifies what kind of files can be edited with the simple text editor --->
	<cfinvokeargument name="editableExtensions" value="cfm,cfml,cfc,dbm,dbml,php,php3,php4,asp,aspx,pl,plx,pls,cgi,jsp,txt,html,htm,log,csv,js,css">
	<!---
	// overwriteDefault = 
	// There are several places where a checkbox appears to overwrite
	// existing.  This controls what it defaults to.  On or off.
	--->
	<cfinvokeargument name="overwriteDefault" value="false">
	<!--- iconPath = web path to the location of the icons used by CFFM --->
	<cfinvokeargument name="iconPath" value="images/cffmIcons">

	<cfinvokeargument name="debug" value="0">
	<!--- file to be cfincluded above all CFFM output --->
	<cfinvokeargument name="templateWrapperAbove" value="">
	<!--- file to be cfincluded below all CFFM output --->
	<cfinvokeargument name="templateWrapperBelow" value="">
	<!--- name of this file.  You should not change this. --->
	<cfinvokeargument name="cffmFilename" value="#GetfileFromPath(getBaseTemplatePath())#">
</cfinvoke>
<!--- place the resource kit in the cffm object --->
<cfset cffm.resourceKit = variables.resourceKit>

<!---	**************************************************
		END OF CONFIGURATION SECTION.
		YOU DO NOT NEED TO MAKE ANY CHANGES BELOW HERE
		**************************************************

		**************************************************
		BEGIN UDF SECTION
		These functions could not be included in the CFC
		for various reasons.  
		**************************************************
--->

<cffunction name="uploadMultipleFiles" output="no" returntype="struct">
	<cfargument name="destination" type="string" required="yes">
	<cfargument name="overwriteExisting" type="boolean" required="yes">
	<cfargument name="scopeForm" type="Struct" required="yes">
	
	<cfset var retVal = StructNew()>
	<cfset var cnt = 1>

	<cfset retVal.errorCode = 0>
	<cfset retVal.errorMessage = "">
	
	<cfloop from="1" to="20" index="cnt" step="1">
		<cfif isDefined("Form.uploadFile#cnt#") and Evaluate("Form.uploadFile#cnt#") neq "">
			<cftry>
				<cffile action="UPLOAD" filefield="Form.uploadFile#cnt#" destination="#arguments.destination#" nameconflict="#iif(arguments.overwriteExisting, DE("OVERWRITE"), DE("ERROR"))#">
				<cfif NOT cffm.checkExtension(cffile.clientFileExt)>
					<cffile action="delete" file="#cffile.serverDirectory##variables.dirSep##cffile.serverFile#">
					<cfset retVal.errorCode = 1>
					<cfset retVal.errorMessage = retVal.errorMessage & "#cffm.resourceKit['errorMsg.t11']#.<br>">
				</cfif>
				<cfcatch type="any">
					<cfset retVal.errorCode = 1>
					<cfset retVal.errorMessage = retVal.errorMessage & "#cffm.resourceKit['errorMsg.t10']#:  #cfcatch.message# - #cfcatch.detail#<br>">
				</cfcatch>
			</cftry>
		</cfif>
	</cfloop>
	<cfreturn retVal>
	
</cffunction>

<cffunction name="DebugOutput" output="yes" returntype="void">
	<cfargument name="debugContent" default="" required="no" type="any">
	<cfif cffm.debug><cfoutput>#arguments.debugContent#</cfoutput></cfif>
</cffunction>

<cffunction name="FatalError" output="yes" returntype="void">
	<cfargument name="errorContent" default="" required="no" type="any">
	<cfoutput>#arguments.errorContent#</cfoutput>
	<cfabort>
</cffunction>

<cffunction name="relocate" output="yes" returntype="void">
	<cfargument name="newlocation" required="yes" type="string">
	<cflocation url="#arguments.newlocation#" addtoken="false">
</cffunction>

<cffunction name="_dump" output="yes" returntype="void">
	<cfargument name="vartodump" required="yes" type="any">
	<cfargument name="abort" required="no" default="yes" type="boolean">
	<cfoutput>Dumping data:<br></cfoutput>
	<cfdump var="#vartodump#">
	<cfif abort><cfabort></cfif>
</cffunction>

<cffunction name="setCookie" output="yes" returntype="void">
	<cfargument name="cookieName" type="string" required="yes">
	<cfargument name="cookieValue" type="any" required="yes">
	<cfcookie name="#cookieName#" value="#cookieValue#">
</cffunction>

<!---
		**************************************************
		ACTUAL CODE BEGINS HERE... 
		
		FIRST WE MUST DO VARIABLE INITIALIZATION
		
		IMPORTANT NOTE:  Session Management on the server or cookies
		on the browser are required in order for CFFM to be used as
		a file browser for HTML editors such as FCKeditor or TinyMCE
		**************************************************
--->

<cftry>
    <cfset session.test = 1>
    <cfset variables.sessionEnabled = "true">
    <cfcatch type="any">
       <cfset variables.sessionEnabled = "false">
    </cfcatch>
</cftry>

<cfscript>
	if (isDefined("url.EDITOR_RESOURCE_TYPE")) {
		variables.EDITOR_RESOURCE_TYPE = url.EDITOR_RESOURCE_TYPE;
	} else if (variables.sessionEnabled AND isDefined("session.EDITOR_RESOURCE_TYPE")) {
		variables.EDITOR_RESOURCE_TYPE = session.EDITOR_RESOURCE_TYPE;
	} else if (isDefined("cookie.EDITOR_RESOURCE_TYPE")) {
		variables.EDITOR_RESOURCE_TYPE = cookie.EDITOR_RESOURCE_TYPE;
	} else {
		variables.EDITOR_RESOURCE_TYPE = "file";
	}
	if (variables.sessionEnabled) {
		session.EDITOR_RESOURCE_TYPE = variables.EDITOR_RESOURCE_TYPE;
	} else {
		setCookie("EDITOR_RESOURCE_TYPE", variables.EDITOR_RESOURCE_TYPE);
	}

	if (isDefined("url.editorType")) {
		variables.editorType = url.editorType;
	} else if (variables.sessionEnabled AND isDefined("session.editorType")) {
		variables.editorType = session.editorType;
	} else if (isDefined("cookie.editorType")) {
		variables.editorType = cookie.editorType;
	} else {
		variables.editorType = "";
	}
	if (variables.sessionEnabled) {
		session.editorType = variables.editorType;
	} else {
		setCookie("editorType", variables.editorType);
	}

	if (isDefined("url.subdir")) {
		variables.subdir = url.subdir;
	} else if (isDefined("form.subdir")) {
		variables.subdir = form.subdir;
	} else if (variables.sessionEnabled AND isDefined("session.subdir")) {
		variables.subdir = session.subdir;
	} else if (isDefined("cookie.subdir")) {
		variables.subdir = cookie.subdir;
	} else {
		variables.subdir = "";
	}
	if (variables.sessionEnabled) {
		session.subdir = variables.subdir;
	} else {
		setCookie("subdir", variables.subdir);
	}
	
</cfscript>




<cfscript>
	/* determine the proper directory separator */
	variables.dirSep = cffm.getDirectorySeparator();
	if (not DirectoryExists(cffm.includeDir)) {
		FatalError(cffm.resourceKit['errorMsg.t1']);
	}

	variables = cffm.createVariables(variables, form, url, "action,subdir,deleteFilename,renameOldFilename,renameNewFilename,editFilename,viewFilename,editFileContent,createNewFilename,createNewFileType,unzipFilename,moveToSubdir,moveFilename,unzipToSubdir,overWrite,rotateDegrees,resizeWidthValue,resizeHeightValue,showTotalUsage");
	if (variables.action eq "") { 
		variables.action = "list"; 
	}
	if (variables.overWrite eq "") {
		variables.overWrite = false;
	}

</cfscript>
<cfscript>
	// some vars are being passed to java methods and MUST be cast to double using javacast
	variables = cffm.forceNumeric(variables, "resizeWidthValue,resizeHeightValue,rotateDegrees");

	/* strip leading and trailing slashes first */
	variables.subdir = trim(REReplace(variables.subdir,"[\\\/]*(.*?)[\\\/]*$","\1","ONE"));
	/* 
	** there should never be ./ or ../ or /../ or /./ in the subdir
	** we don't like that kinda stuff
	*/
	variables.subdir = cffm.checkSubdirValue(variables.subdir);
	DebugOutput("cffm.includeDir = " & cffm.includeDir & "<P>");
	// set the physical path to our current working directory.
	variables.workingDirectory = cffm.createServerPath(variables.subdir);
	// set the logical URL path to our current working directory.
	variables.workingDirectoryWeb = cffm.createWebPath(variables.subdir);
	variables.errorMessage = "";
	DebugOutput("variables.workingDirectory = " & variables.workingDirectory & "<P>");
	DebugOutput("variables.workingDirectoryWeb = " & variables.workingDirectoryWeb & "<P>");
</cfscript>
<cfscript>
	if ( variables.moveToSubdir neq cffm.checkSubdirValue(variables.moveToSubdir) )
	{
		variables.action = "list";
		variables.errorMessage = variables.errorMessage & "<li>#cffm.resourceKit['errorMsg.t2']#</li>#Chr(10)#";
	}
</cfscript>
<cfscript>
	if ( variables.unzipToSubdir neq cffm.checkSubdirValue(variables.unzipToSubdir) )
	{
		variables.action = "list";
		variables.errorMessage = variables.errorMessage & "<li>#cffm.resourceKit['errorMsg.t3']#</li>#chr(10)#";
	}
</cfscript>
<cfscript>
	if (NOT DirectoryExists(variables.workingDirectory) ) {
		/* oops!  Reset everything and return to the home directory */
		variables.errorMessage = variables.errorMessage & "<li>#cffm.resourceKit['errorMsg.t4']#</li>#Chr(10)#";
		variables.workingDirectory = cffm.includeDir;
		variables.workingDirectoryWeb = cffm.includeDirWeb;
		variables.subdir = "";
		variables.action = "list";
	}
</cfscript>
<cfscript>
	// **************************************************
	// ARE WE PERFORMING SOME KIND OF ACTION? //
	// **************************************************
	if (variables.action eq "delete") {
		if (variables.deleteFilename contains "/" or variables.deleteFilename contains "\") {
			variables.errorMessage = variables.errorMessage & "<li>#cffm.resourceKit['errorMsg.t5']#</li>#Chr(10)#";
		} else {
			variables.deleteResults = "";
			variables.fileToDelete = variables.workingDirectory & variables.dirsep & variables.deleteFilename;
			if (cffm.getPathType(fileToDelete) eq "file")
			{
				variables.deleteResults = cffm.deleteFile(variables.fileToDelete);
			} else {
				variables.deleteResults = cffm.deleteDirectory(variables.fileToDelete, "True");
			}
			if (variables.deleteResults.errorCode neq 0) 
			{
				variables.errorMessage = variables.errorMessage & "<li>#variables.deleteResults.errorMessage#</li>#Chr(10)#";
			} else {
				relocate(cffm.cffmFilename & "?fuseaction=cFilemanager.default&siteid=#session.siteid#&subdir=" & urlEncodedFormat(variables.subdir));
			}
		}
		variables.action = "list";
	} else if (variables.action eq "unzip") {
		if (variables.unzipFilename contains "/" or variables.unzipFilename contains "\") {
			variables.errorMessage = variables.errorMessage & "<li>#cffm.resourceKit['errorMsg.t5']#</li>#Chr(10)#";
		} else {
			variables.unzipResults = "";
			variables.fileToUnzip = variables.workingDirectory & variables.dirsep & variables.unzipFilename;
			variables.unzipResults = cffm.unzipFile(variables.fileToUnzip,cffm.createServerPath(variables.unzipToSubdir),variables.overwrite);
			if (isStruct(variables.unzipResults) and variables.unzipResults.errorCode neq 0) 
			{
				variables.errorMessage = variables.errorMessage & "<li>#variables.unzipResults.errorMessage#</li>#Chr(10)#";
			} else {
				variables.subdir = variables.unzipToSubdir;
				relocate(cffm.cffmFilename & "?fuseaction=cFilemanager.default&siteid=#session.siteid#&subdir=" & urlEncodedFormat(variables.subdir));
			}
		}
		variables.action = "list";
	} else if (variables.action eq "rename") {
		if (variables.renameNewFilename contains "/" or variables.renameNewFilename contains "\") {
			variables.errorMessage = variables.errorMessage & "<li>#cffm.resourceKit['errorMsg.t5']#</li>#Chr(10)#";
		} else {
			variables.renameResults = "";
			variables.oldFilename = variables.workingDirectory & variables.dirsep & variables.renameOldFilename;
			variables.newFilename = variables.workingDirectory & variables.dirsep & variables.renameNewFilename;
			variables.renameResults = cffm.renameFile(variables.oldFilename,variables.newFilename,"rename",variables.overWrite);
			if (isStruct(variables.renameResults) and variables.renameResults.errorCode neq 0) 
			{
				variables.errorMessage = variables.errorMessage & "<li>#variables.renameResults.errorMessage#</li>#Chr(10)#";
			} else {
				relocate(cffm.cffmFilename & "?fuseaction=cFilemanager.default&siteid=#session.siteid#&subdir=" & urlEncodedFormat(variables.subdir));
			}
		}
		variables.action = "list";
	} else if (variables.action eq "move" or variables.action eq "copy") {
		if (variables.moveFilename contains "/" or variables.moveFilename contains "\") 
		{
			variables.errorMessage = variables.errorMessage & "<li>#cffm.resourceKit['errorMsg.t5']#</li>#Chr(10)#";
		} else {
			variables.moveFromPath = cffm.createServerPath(variables.subdir,variables.moveFilename);
			variables.moveToPath = cffm.createServerPath(variables.moveToSubdir,variables.moveFilename);
			if (cffm.getPathType(variables.moveFromPath) eq "directory" AND variables.moveFromPath eq variables.moveToPath)
			{
				variables.errorMessage = variables.errorMessage & "<li>#cffm.resourceKit['errorMsg.t6']#</li>#Chr(10)#";
			} else if (cffm.getPathType(variables.moveFromPath) eq "directory" and Find(variables.moveFromPath,variables.moveToPath) eq 1) {
				variables.errorMessage = variables.errorMessage & "<li>#cffm.resourceKit['errorMessage.t7']#</li>#Chr(10)#";
			} else if (cffm.getPathType(variables.moveFromPath) eq "file" AND getDirectoryFromPath(variables.moveFromPath) eq variables.moveToPath ) {
				/* don't do anything, because they selected to move the file to the directory it's already in! */
			} else {
				variables.moveResults = "";
				variables.moveResults = cffm.renameFile(variables.moveFromPath,variables.moveToPath,variables.action, variables.overWrite);
				if (isStruct(variables.moveResults) and variables.moveResults.errorCode neq 0)
				{
					variables.errorMessage = variables.errorMessage & "<li>#variables.moveResults.errorMessage#</li>#Chr(10)#";
				} else {
					relocate(cffm.cffmFilename & "?fuseaction=cFilemanager.default&siteid=#session.siteid#&subdir=" & urlEncodedFormat(variables.subdir));
				}
			}
		}
		variables.action = "list";

	} else if (variables.action eq "upload") {
		variables.uploadResults = "";
		variables.uploadResults = uploadMultipleFiles(variables.workingDirectory, variables.overwrite, form);
		if (isStruct(variables.uploadResults) and variables.uploadResults.errorCode neq 0) 
		{
			variables.errorMessage = variables.errorMessage & "<li>#variables.uploadResults.errorMessage#</li>#Chr(10)#";
		} else {
			relocate(cffm.cffmFilename & "?fuseaction=cFilemanager.default&siteid=#session.siteid#&subdir=" & urlEncodedFormat(variables.subdir));
		}
		variables.action = "list";
	} else if (variables.action eq "viewSource" or action eq "edit") {
		if (variables.editFilename contains "/" or variables.editFilename contains "\") {
			variables.errorMessage = variables.errorMessage & "<li>#cffm.resourceKit['errorMsg.t5']#</li>#Chr(10)#";
			action = "list";
		} else if (cffm.getPathType(cffm.createServerPath(variables.subdir,variables.editFilename)) neq "file")	{
			variables.errorMessage = variables.errorMessage & "<li>#cffm.resourceKit['errorMsg.t8']#  #cffm.createServerPath(variables.subdir, variables.editFilename)#</li>#Chr(10)#";		
			variables.action = "list";
		} else {
			variables.fileToRead = variables.workingDirectory & variables.dirsep & variables.editFilename;
			variables.readResults = cffm.readFile(variables.fileToRead);
			if (variables.readResults.errorCode is 0) {
				variables.content = variables.readResults.fileContent;
			} else {
				variables.errorMessage = variables.errorMessage & "<li>#variables.readResults.errorMessage#</li>#Chr(10)#";
				action = "list";
			}
		}
	} else if (variables.action eq "save") {
		variables.fileToWrite = variables.workingDirectory & variables.dirsep & variables.editFilename;
		variables.saveResults = cffm.saveFile(variables.fileToWrite, variables.editFileContent);
		if (variables.saveResults.errorCode gt 0)
		{
			variables.errorMessage = variables.errorMessage & "<li>#variables.saveResults.errorMessage#</li>#Chr(10)#";		
		} else {
			relocate(cffm.cffmFilename & "?fuseaction=cFilemanager.default&siteid=#session.siteid#&subdir=" & urlEncodedFormat(variables.subdir));
		}
	} else if (variables.action eq "create") {
		if (variables.createNewFilename contains "/" or variables.createNewFilename contains "\") {
			variables.errorMessage = variables.errorMessage & "<li>#cffm.resourceKit['errorMsg.t5']#</li>#Chr(10)#";
		} else if (variables.createNewFilename eq "") {
			variables.errorMessage = variables.errorMessage & "<li>#cffm.resourceKit['errorMsg.t22']#</li>#Chr(10)#";
		} else {
			variables.fileToCreate = variables.workingDirectory & variables.dirsep & variables.createNewFilename;
			variables.createResults = cffm.createFile(variables.fileToCreate,variables.createNewFileType);
			if (variables.createResults.errorCode gt 0)
			{
				variables.errorMessage = variables.errorMessage & "<li>#variables.createResults.errorMessage#</li>#Chr(10)#";		
			} else {
				relocate(cffm.cffmFilename & "?fuseaction=cFilemanager.default&siteid=#session.siteid#&subdir=" & urlEncodedFormat(variables.subdir));
			}
		}
		variables.action = "list";
	} else if (listFind("flip,flop,resize,rotate,manipulateForm",action) gt 0) {
		if (variables.editFilename contains "/" or variables.editFilename contains "\") {
			variables.errorMessage = variables.errorMessage & "<li>#cffm.resourceKit.errorMsg.t5#</li>#Chr(10)#";
			action = "list";
		} else if (cffm.getPathType(cffm.createServerPath(variables.subdir,variables.editFilename)) neq "file")	{
			variables.errorMessage = variables.errorMessage & "<li>#cffm.resourceKit['errorMsg.t8']#  #cffm.createServerPath(variables.subdir, variables.editFilename)#</li>#Chr(10)#";		
			variables.action = "list";
		} else {
			variables.image = CreateObject("component","image");
			variables.imagePath = cffm.createServerPath(variables.subdir, variables.editFilename);
			if (NOT variables.image.readImage("FILE", variables.imagePath))
			{
				variables.errorMessage = variables.errorMessage & "<li>#cffm.resourceKit['errorMsg.t9']#</li>#Chr(10)#";
				variables.action = "list";
			} else {
				if (variables.action eq "flip") {
					
					DebugOutput("Flipping image");
					variables.image.flip();
					DebugOutput("Writing image");
					
					if (not variables.image.writeImage(variables.imagePath))
					{
						variables.errorMessage = variables.errorMessage & "<li>The image file was not written.  Either the format is unsupported or the original image was corrupt.</li>#Chr(10)#";
						variables.action = "list";
					} else {
						relocate(cffm.cffmFilename & "?action=manipulateForm&subdir=" & urlEncodedFormat(variables.subdir) & "&editFilename=" & urlEncodedFormat(variables.editFilename) & "&fuseaction=cFilemanager.default&siteid=#session.siteid#");
					}
				} else if (variables.action eq "flop") {
					variables.image.flop();
					variables.image.writeImage(variables.imagePath);
					relocate(cffm.cffmFilename & "?action=manipulateForm&subdir=" & urlEncodedFormat(variables.subdir) & "&editFilename=" & urlEncodedFormat(variables.editFilename) & "&fuseaction=cFilemanager.default&siteid=#session.siteid#");
				} else if (variables.action eq "rotate") {
					variables.image.rotate(variables.rotateDegrees);
					variables.image.writeImage(variables.imagePath);
					relocate(cffm.cffmFilename & "?action=manipulateForm&subdir=" & urlEncodedFormat(variables.subdir) & "&editFilename=" & urlEncodedFormat(variables.editFilename) & "&fuseaction=cFilemanager.default&siteid=#session.siteid#");
				} else if (variables.action eq "resize") {
					variables.image.resize(variables.resizeWidthValue, variables.resizeHeightValue);
					variables.image.writeImage(variables.imagePath);
					relocate(cffm.cffmFilename & "?action=manipulateForm&subdir=" & urlEncodedFormat(variables.subdir) & "&editFilename=" & urlEncodedFormat(variables.editFilename) & "&fuseaction=cFilemanager.default&siteid=#session.siteid#");
				}
			}
		}
	}
	
	// **************************************************
	// LET'S GET IT STARTED
	// **************************************************
	variables.dirlist = "";
</cfscript>
<cfsetting enablecfoutputonly="no">
<cfif cffm.templateWrapperAbove neq "">
	<cfinclude template="#cffm.templateWrapperAbove#">
</cfif>
<!--- Custom --->
<cfif variables.editorType neq "" and (not application.permUtility.getModulePerm("00000000000000000000000000000000000","#session.siteid#") or session.siteid eq '')>
	<script language="javascript">
		window.close() ;
	</script>
</cfif>
<!--- --->
<cfif variables.editorType eq "fck">
	<script language="javascript">
	function OpenFile( fileUrl )
	{
		window.opener.SetUrl( fileUrl ) ;
		window.close() ;
		window.opener.focus() ;
	}
	</script>
<cfelseif variables.editorType eq "mce">
	<script language="javascript">
	function OpenFile( fileUrl )
	{
		//window.opener.SetUrl( fileUrl ) ;
		srcInput = window.opener.win2.document.getElementById('<cfif variables.EDITOR_RESOURCE_TYPE eq "file">href<cfelseif variables.EDITOR_RESOURCE_TYPE eq "flash">file<cfelse>src</cfif>');		
		srcInput.value = fileUrl;

		window.close() ;
		window.opener.focus() ;
	}
	</script>
</cfif>
<cfoutput>
<h2><!---File Manager &raquo; --->#attributes.fmTitle#</h2>

<!---<ul id="navTask">

<li><a href="index.cfm?fuseaction=cFilemanager.default&siteid=#session.siteid#&subdir=&location=files">System Files</a></li>

<li><a href="index.cfm?fuseaction=cFilemanager.default&siteid=#session.siteid#&subdir=&location=assets">Site Assets</a></li>
<cfif listFind(session.mura.memberships,'S2')>
<li><a href="index.cfm?fuseaction=cFilemanager.default&siteid=#session.siteid#&subdir=&location=root">Application Root</a></li>
</cfif>
</ul>--->

#debugOutput("<p>Physical Directory: #variables.workingDirectory#</p>")#
<!---<h3>#attributes.fmTitle#</h3>--->
</cfoutput>
<cfif listFind("edit,viewsource,viewzip,renameForm,copymoveForm,manipulateForm",action) gt 0>
	<cfoutput><p>Working with #cffm.getPathType(cffm.createServerPath(variables.subdir,variables.editFilename))#:  #variables.workingDirectoryWeb#/#editFilename# </p></cfoutput>
</cfif>
<cfset variables.listAllFiles = cffm.DirectoryListCFFM(cffm.includeDir,"true")>
<cfif variables.listAllFiles.RecordCount gt 0>
	<cfquery name="variables.listAllDirectories" dbtype="query">
		select * from variables.listAllFiles
		where type = 'Dir'
	</cfquery>
<cfelse>
	<!--- this is a workaround for CFMX --->
	<cfset variables.listAllDirectories = QueryNew("IGNORE")>
</cfif>
<cfif isDefined("variables.errorMessage") and variables.errorMessage neq "">
	<fieldset class="cffm_errorMessage">
	<legend><cfoutput>#cffm.resourceKit["Msg.t3"]#</cfoutput></legend>
	<ul>
	<cfoutput>#variables.errorMessage#</cfoutput>
	</ul>
	</fieldset>
</cfif>
<cfif variables.action eq "viewSource" or variables.action eq "edit">
	<cfoutput><ul id="navTask"><li><a href="#cffm.cffmFilename#?subdir=#urlEncodedFormat(variables.subdir)#&fuseaction=cFilemanager.default&siteid=#session.siteid#">#cffm.resourceKit["Msg.t14"]#</a></li></ul></cfoutput>
	<form method="post" action="<cfoutput>#cffm.cffmFilename#</cfoutput>" name="form1">
	<input type="hidden" name="action" value="save">
	<input type="hidden" name="fuseaction" value="cFilemanager.default">
	<input type="hidden" name="subdir" value="<cfoutput>#variables.subdir#</cfoutput>">
	<input type="hidden" name="editFilename" value="<cfoutput>#variables.editFilename#</cfoutput>">
	<dl class="oneColumn"><dt class="first"><cfif variables.action eq "edit">Edit Source<cfelse>View Source</cfif></dt><dd class="tall"><textarea name="editFileContent"><cfoutput>#variables.content#</cfoutput></textarea></dd></dl>

	<cfif variables.action eq "edit">
	<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1);"><span><cfoutput>#cffm.resourceKit['buttonText.t1']#</cfoutput></span></a>
	<a class="submit" href="javascript:;"  onclick="javascript:history.go(-1);"><span><cfoutput>#cffm.resourceKit['buttonText.t2']#</cfoutput></span></a>
	</cfif>
	</form>
<cfelseif action eq "manipulateForm">
	<!--- variables.image was created earlier --->
	<cfset variables.imageHeight = variables.image.height()>
	<cfset variables.imageWidth = variables.image.width()>
	<cfoutput>
	<ul id="navTask"><li><a href="#cffm.cffmFilename#?fuseaction=cFilemanager.default&subdir=#urlEncodedFormat(variables.subdir)#&siteid=#session.siteid#">#cffm.ResourceKit["Msg.t14"]#</a></li></ul>
	<ul class="overview">
	 <li>Image Size:  #variables.imageWidth# x #variables.imageHeight# <cfif variables.imageWidth gt 400>
		<cfset variables.scale = 400 / variables.imageWidth>
		<cfset variables.displaywidth = 400>
		<cfset variables.displayHeight = Round(variables.imageHeight * variables.scale)>
	<cfelse>
		<cfset variables.scale = 1>
		<cfset variables.displayWidth = variables.imageWidth>
		<cfset variables.displayHeight = variables.imageHeight>
	</cfif>
	<li><img class="fmImage" src="#variables.workingDirectoryWeb#/#editFilename#?x=#RandRange(1,50000)#" width="#variables.displayWidth#" height="#variables.displayHeight#"></li>
	<cfif variables.scale lt 1>
		</li><li>(#cffm.resourceKit["Msg.t11"]# #NumberFormat(variables.scale*100,"__")# #cffm.resourceKit["Msg.t12"]#) <a target="_blank" href="#variables.workingDirectoryWeb#/#variables.editFilename#">#cffm.resourceKit["Msg.t13"]#</a></li>
	</cfif></ul>
	<script language="javascript">
	function rotate(degrees)
	{
		document.frmRotate.rotateDegrees.value = degrees;
		document.frmRotate.submit();
	}
	</script>
	<dl class="oneColumn">
	<dt class="first">Flip / Rotate: </dt>
	<dd><ul id="navTask"><li><a href="javascript:document.frmFlipVertical.submit()">Flip Vertical</a></li>
	<li><a href="javascript:document.frmFlipHorizontal.submit()">Flip Horizontal</a></li>
	<li><a href="javascript:rotate(90)">Rotate 90 Degrees</a></li>
	<li><a href="javascript:rotate(180)">Rotate 180 Degrees</a></li>
	<li><a href="javascript:rotate(270)">Rotate 270 Degrees</a></li></ul>

	<form name="frmFlipVertical" method="post" action="#cffm.cffmFilename#">
	<input type="hidden" name="subdir" value="#variables.subdir#">
	<input type="hidden" name="editFilename" value="#variables.editFilename#">
	<input type="hidden" name="action" value="flip">
	<input type="hidden" name="fuseaction" value="cFilemanager.default">
	<input type="hidden" name="siteid" value="#session.siteid#">
	</form>

	<form name="frmFlipHorizontal" method="post" action="#cffm.cffmFilename#">
	<input type="hidden" name="subdir" value="#variables.subdir#">
	<input type="hidden" name="editFilename" value="#variables.editFilename#">
	<input type="hidden" name="action" value="flop">
	<input type="hidden" name="fuseaction" value="cFilemanager.default">
	<input type="hidden" name="siteid" value="#session.siteid#">
	</form>
	
	<form name="frmRotate" method="post" action="#cffm.cffmFilename#">
	<input type="hidden" name="subdir" value="#variables.subdir#">
	<input type="hidden" name="editFilename" value="#variables.editFilename#">
	<input type="hidden" name="action" value="rotate">
	<input type="hidden" name="rotateDegrees" value="90">
	<input type="hidden" name="fuseaction" value="cFilemanager.default">
	<input type="hidden" name="siteid" value="#session.siteid#">
	</form></dd>
	
	<dt>#cffm.resourceKit["Msg.t5"]#</dt>	
	<dd><form name="frmScaleWidth" method="post" action="#cffm.cffmFilename#">
	<input type="hidden" name="subdir" value="#variables.subdir#">
	<input type="hidden" name="editFilename" value="#variables.editFilename#">
	<input type="hidden" name="action" value="resize">
	<input name="resizeWidthValue" type="text" class="textShort" value="0" size="4" maxlength="4"> #cffm.resourceKit["Msg.t6"]#
	<input type="hidden" name="resizeHeightvalue" value="0">
	<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.frmScaleWidth);"><span>#cffm.resourceKit["buttonText.t3"]#</span></a>
	<input type="hidden" name="fuseaction" value="cFilemanager.default">
	<input type="hidden" name="siteid" value="#session.siteid#">
	</form></dd>
	
	<dt>#cffm.resourceKit["Msg.t9"]#</dt>
	<dd><form name="frmScaleHeight" method="post" action="#cffm.cffmFilename#">
	<input type="hidden" name="subdir" value="#variables.subdir#">
	<input type="hidden" name="editFilename" value="#variables.editFilename#">
	<input type="hidden" name="action" value="resize">
	<input name="resizeHeightValue" type="text" class="textShort" value="0" size="4" maxlength="4"> #cffm.resourceKit["Msg.t6"]#
	<input type="hidden" name="resizeWidthvalue" value="0">
	<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.frmScaleHeight);"><span>#cffm.resourceKit["buttonText.t3"]#</span></a>
	<input type="hidden" name="fuseaction" value="cFilemanager.default">
	<input type="hidden" name="siteid" value="#session.siteid#">
	</form></dd>
	<dt>#cffm.resourceKit["Msg.t10"]#</dt>
	<dd><form name="frmResize" method="post" action="#cffm.cffmFilename#">
	<input type="hidden" name="subdir" value="#variables.subdir#">
	<input type="hidden" name="editFilename" value="#variables.editFilename#">
	<input type="hidden" name="action" value="resize">
	
	<input name="resizeWidthValue" type="text" class="textShort" value="0" size="4" maxlength="4"> #cffm.resourceKit["Msg.t7"]#
	<input name="resizeHeightValue" type="text" class="textShort" value="0" size="4" maxlength="4"> #cffm.resourceKit["Msg.t8"]#
	<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.frmResize);"><span>#cffm.resourceKit["buttonText.t3"]#</span></a>
	<input type="hidden" name="fuseaction" value="cFilemanager.default">
	<input type="hidden" name="siteid" value="#session.siteid#">
	</form></dd>
	</dl>
	</cfoutput>

<cfelseif action eq "renameForm">
	<cfoutput>
	<ul id="navTask"><li><a href="#cffm.cffmFilename#?fuseaction=cFilemanager.default&subdir=#urlEncodedFormat(variables.subdir)#&siteid=#session.siteid#">#cffm.ResourceKit["Msg.t14"]#</a></li></ul>

	<form name="frmRename" method="post" action="#cffm.cffmFilename#">
	<input type="hidden" name="action" value="rename">
	<input type="hidden" name="subdir" value="#variables.subdir#">
	<input type="hidden" name="renameOldFilename" value="#editFilename#">
	
	<dl><dt class="first"><input name="renameNewFilename" type="text" class="text" value="#editFilename#" size="40" maxlength="200"> <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.frmRename);"><span>#cffm.resourceKit['buttonText.t4']#</span></a></dt>
	<dd><input name="overWrite" type="checkbox" class="checkbox" value="true"<cfif cffm.overwriteDefault> CHECKED</cfif>> #cffm.resourceKit["Msg.t15"]#</dd></dl>
	<input type="hidden" name="fuseaction" value="cFilemanager.default">
	<input type="hidden" name="siteid" value="#session.siteid#">
	</form>
	</cfoutput>

<cfelseif action eq "uploadForm">
	<cfoutput>
		<ul id="navTask"><li><a href="#cffm.cffmFilename#?fuseaction=cFilemanager.default&subdir=#urlEncodedFormat(variables.subdir)#&siteid=#session.siteid#">#cffm.ResourceKit["Msg.t14"]#</a></li></ul>
		<p>
	</cfoutput>

	<form name="frmUpload" enctype="multipart/form-data" method="post" action="<cfoutput>#cffm.cffmFilename#</cfoutput>">
	<input type="hidden" name="action" value="upload">
	<input type="hidden" name="subdir" value="<cfoutput>#variables.subdir#</cfoutput>">
	
	<p><cfoutput>#cffm.resourceKit["Msg.t16"]#</cfoutput>:</p>
	<cfloop from="1" to="20" index="cnt" step="2">
	<input type="file" name="uploadFile<cfoutput>#cnt#</cfoutput>">
	<input type="file" name="uploadFile<cfoutput>#cnt+1#</cfoutput>"><br>
	</cfloop>
	<br>
	<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.frmUpload);"><span><cfoutput>#cffm.resourceKit['buttonText.t5']#</cfoutput></span></a>
	<input name="overwrite" type="checkbox" class="checkbox" value="true"<cfif cffm.overwriteDefault> CHECKED</cfif>>
	Overwrite&nbsp;Existing
	<input type="hidden" name="fuseaction" value="cFilemanager.default">
	<cfoutput><input type="hidden" name="siteid" value="#session.siteid#"></cfoutput>
	</form>

<cfelseif action eq "copymoveForm">
	<cfoutput>
	<ul id="navTask"><li><a href="#cffm.cffmFilename#?fuseaction=cFilemanager.default&subdir=#urlEncodedFormat(variables.subdir)#&siteid=#session.siteid#">#cffm.ResourceKit["Msg.t14"]#</a></li></ul>
	<cfset variables.workingFileType = cffm.getPathType(cffm.createServerPath(variables.subdir,variables.editFilename))>

	<form name="frmCopyMove" method="post" action="#cffm.cffmFilename#">
	<input type="hidden" name="subdir" value="#variables.subdir#">
	<input type="hidden" name="moveFilename" value="#variables.editFilename#">
	<dl><dt class="first"><input type="radio" class="radio" name="action" value="move" checked>Move
	<input type="radio" class="radio" name="action" value="copy">Copy to:
	<cfset options = 0>
	<select name="moveToSubdir" size="1">
		<cfif variables.subdir neq "">
			<cfset options = options + 1>
			<option value="">#cffm.resourceKit["Msg.t27"]#</option>
		</cfif>
		<cfloop query="variables.listAllDirectories">
			<cfset webPath = Replace(ReplaceNoCase(fullPath,cffm.includeDir & variables.dirSep,"","ALL"),"\","/","all")>
			<cfset compare = variables.subdir & iif(len(subdir) gt 0,DE("/"),DE("")) & variables.editFilename>
			<cfif findNoCase(compare, webpath) neq 1>
				<cfset options = options + 1>
				<option value="#webPath#">#cffm.createWebPath(webPath)#</option>
			</cfif>
		</cfloop>
	</select>
	<cfif options neq 0>
		<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.frmCopyMove);"><span>#cffm.resourceKit['buttonText.t3']#</span></a>
	<cfelse>
		<a class="submit" href="javascript:;" onclick="history.go(-1);"><span>#cffm.resourceKit["buttonText.t2"]#</span></a>
		#cffm.resourceKit["Msg.t17"]#
	</cfif></dt>
	<dd>
	<input name="overWrite" type="checkbox" class="checkbox" value="true"<cfif cffm.overwriteDefault> CHECKED</cfif>> #cffm.resourceKit["Msg.t15"]#</dd></dl>
	<input type="hidden" name="fuseaction" value="cFilemanager.default">
	<input type="hidden" name="siteid" value="#session.siteid#">
	</form>
	</cfoutput>
<cfelseif action eq "viewzip">
	<cfoutput><ul id="navTask"><li><a href="#cffm.cffmFilename#?fuseaction=cFilemanager.default&subdir=#urlEncodedFormat(variables.subdir)#&siteid=#session.siteid#">#cffm.ResourceKit["Msg.t14"]#</a></li></ul></cfoutput>
	<form method="post" action="<cfoutput>#cffm.cffmFilename#</cfoutput>" name="form2">
	<input type="hidden" name="action" value="unzip">
	<input type="hidden" name="subdir" value="<cfoutput>#variables.subdir#</cfoutput>">
	<input type="hidden" name="unzipFilename" value="<cfoutput>#editFilename#</cfoutput>">
	<dl><dt class="first">Unzip to: 
<select name="unzipToSubdir" size="1">
<cfoutput>
<option value="#variables.subdir#">#cffm.resourceKit["Msg.t1"]# (#cffm.createWebPath(variables.subdir)#)</option>
<cfif variables.subdir neq ""><option value="">#cffm.resourceKit["Msg.t27"]# (#cffm.includeDirWeb#)</option></cfif>
<cfloop query="variables.listAllDirectories">
<cfset webPath = Replace(ReplaceNoCase(fullPath,cffm.includeDir & variables.dirSep,"","ALL"),"\",variables.dirsep,"all")>
<cfif webpath neq variables.subdir>
	<option value="#webPath#">#cffm.createWebPath(webPath)#</option>
</cfif>
</cfloop>
</cfoutput>
</select> <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form2);"><span><cfoutput>#cffm.resourceKit['buttonText.t6']#</cfoutput></span></a>
</dt>
<dd><input type="checkbox" value="true" name="overwrite" class="checkbox"<cfif cffm.overwriteDefault> CHECKED</cfif>><cfoutput>#cffm.resourceKit["Msg.t15"]#</cfoutput></dd></dl>
<input type="hidden" name="fuseaction" value="cFilemanager.default">
<cfoutput><input type="hidden" name="siteid" value="#session.siteid#"></cfoutput>
</form>
<cfif cffm.allowedExtensions neq "">
	<p><cfoutput><b>#cffm.resourceKit["Msg.t18"]#</b>:  #cffm.resourceKit["Msg.t20"]#</cfoutput>
	<ul>
	<cfloop list="#cffm.allowedExtensions#" index="thisExt">
		<li><cfoutput>#thisExt#</cfoutput></li>
	</cfloop>
	</ul>
	</p>
<cfelseif cffm.disallowedExtensions neq "">
	<cfoutput><p><b>#cffm.resourceKit["Msg.t18"]#</b>:  #cffm.resourceKit["Msg.t21"]#</p></cfoutput>
</cfif>
<cfset variables.viewzipResults = cffm.viewZipFile(cffm.createServerPath(variables.subdir,variables.editFilename))>
<table id="metadata" class="stripe">
<cfoutput>
<tr>
	<th class="varWidth">#cffm.resourceKit["Msg.t22"]#</th>
	<th>#cffm.resourceKit["Msg.t23"]#</th>
	<th>#cffm.resourceKit["Msg.t24"]#</th>
</tr>
</cfoutput>
<cfoutput query="variables.viewzipResults">
<tr>
	<td class="varWidth">#name#</td>
	<td>#type#</td>
	<td>#size#</td>
</tr>
</cfoutput>
</table>

<cfelseif action eq "list">
<cfdirectory action="LIST" directory="#variables.workingDirectory#" name="variables.dirList">

<script language="javascript">
function preview(fileUrl) 
{
if (fileUrl == "") {
	alert('Nothing to preview');
} else {
	if (fileUrl.indexOf('/') != 0)
	{
		fileUrl = '/' + fileUrl;
	}
	fileUrl = "file://" + fileUrl;
	newWindow = window.open(fileUrl,"","width=300,height=300,left=20,top=20,bgcolor=white,resizable,scrollbars");
	if ( newWindow != null )
	{
		newWindow.focus();
	}
}
}
</script>
<form name="frmUpload" id="frmUpload" class="alt" enctype="multipart/form-data" method="post" action="<cfoutput>#cffm.cffmFilename#</cfoutput>">
<input type="hidden" name="action" value="upload">
<input type="hidden" name="subdir" value="<cfoutput>#variables.subdir#</cfoutput>">

<dl>
<dt class="first"><cfoutput>#cffm.resourceKit["Msg.t41"]#</dt>
<dd><input type="file" name="uploadFile1" ></dd>
<dd><a class="submit" href="javascript:;" onclick="return submitForm(document.forms.frmUpload);"><span>#cffm.resourceKit['buttonText.t5']#</span></a></dd>
<dd><input name="overwrite" type="checkbox" class="checkbox" value="true"<cfif cffm.overwriteDefault> CHECKED</cfif>>
Overwrite&nbsp;Existing</dd>
</cfoutput>
<dd class="uploadMultiple">
<cfoutput><a href="#cffm.cffmFilename#?fuseaction=cFilemanager.default&subdir=#urlEncodedFormat(subdir)#&action=uploadForm&siteid=#session.siteid#">[#cffm.resourceKit["Msg.t25"]#]</a>
</dd>
<!---<input type="button" class="button" value="Preview" onClick="preview(document.frmUpload.uploadFile.value);">--->
</dl>

<input type="hidden" name="fuseaction" method="post"  value="cFilemanager.default">
<input type="hidden" name="siteid" value="#session.siteid#">
</form></cfoutput>

<form name="frmCreateNew" id="frmCreateNew" method="post" action="<cfoutput>#cffm.cffmFilename#</cfoutput>">
<input type="hidden" name="action" value="create">
<input type="hidden" name="subdir" value="<cfoutput>#variables.subdir#</cfoutput>">
<input type="hidden" name="createNewFileType" value="">
<dl>
<dt class="firstAlt"><cfoutput>#cffm.resourceKit["Msg.t26"]#</dt>
<dd><input name="createNewFilename" type="text" class="text" onfocus="select();" size="20"></dd>
<dd><a class="submit" href="javascript:;"  onclick="document.frmCreateNew.createNewFileType.value='file';return submitForm(document.frmCreateNew);"><span>#cffm.resourceKit['buttonText.t7']#</span></a> <a class="submit" href="javascript:;" onclick="document.frmCreateNew.createNewFileType.value='directory';return submitForm(document.frmCreateNew);"><span>#cffm.resourceKit['buttonText.t8']#</span></a></dd>
</dl>
<input type="hidden" name="fuseaction" value="cFilemanager.default">
<input type="hidden" name="siteid" value="#session.siteid#">
</form></cfoutput>

<cfoutput>
<!---<h3>#cffm.resourceKit['msg.t1']#:  <strong>#variables.workingDirectoryWeb#</strong></h3>--->
<ul id="navTask">
<li><a href="#cffm.cffmFilename#?fuseaction=cFilemanager.default&siteid=#session.siteid#&subdir=">#cffm.resourceKit["Msg.t27"]#</a></li>
<li><a href="#cffm.cffmFilename#?fuseaction=cFilemanager.default&siteid=#session.siteid#&subdir=#variables.subdir#">#cffm.resourceKit["Msg.t28"]#</a></li>
</ul>
</cfoutput>
<table id="metadata" class="stripe">
<cfoutput>
<tr>
<th>&nbsp;</th>
	<th class="varWidth"><!---#cffm.resourceKit['msg.t1']#: --->#variables.workingDirectoryWeb#</th>
	<th>Size</th>
	<th>Update</th>
	<th>Time</th>
	<th class="administration">&nbsp;</th>
</tr>
</cfoutput>
<cfif variables.subdir neq "">
<!--- include link to parent directory --->
<cfset variables.linkToFile = cffm.cffmFilename & "?subdir=" & ListDeleteAt(variables.subdir,listlen(variables.subdir,"/"),"/") & "&fuseaction=cFilemanager.default">
<tr>
<td><a href="<cfoutput>#variables.linkToFile#</cfoutput>" target="_self"><img src="<cfoutput>#cffm.iconPath#/</cfoutput>folder_up.gif" border="0"></a></td>
<td class="varWidth">
	<cfoutput><a href="#variables.linkToFile#" target="_self">#cffm.resourceKit["Msg.t31"]#</a></cfoutput>
</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>

</cfif>
<cfset cnt = 0>
<cfset variables.totalDirectories = 0>
<cfset variables.totalFiles = 0>
<cfset variables.totalSize = 0>
<cfquery name="sortedDirList" dbtype="query">
	<cfswitch expression="#application.configBean.getCompiler()#">
	<cfcase value="railo">
	select variables.dirlist.*, lower(variables.dirlist.name) as sortname
	FROM variables.dirlist
	order by variables.dirlist.type, sortname
	</cfcase>
	<cfdefaultcase>
	select *, lower(name) as sortname
	FROM variables.dirlist
	order by type, sortname
	</cfdefaultcase>
	</cfswitch> 
</cfquery>
<cfoutput query="variables.sortedDirList">
<cfset cnt = cnt + 1>
<cfscript>
variables.editable = 0;
variables.zipFile = 0;
variables.editableImage = 0;
variables.fileIcon = "spacer.gif";
variables.dimensions = "";
variables.image = createObject("component","image");
if (listLen(name,".") gt 1) {
	variables.extension = lcase(listLast(name,"."));
	if (listFind(cffm.editableExtensions, variables.extension) gt 0 and type eq "file") {
		variables.editable = 1;
		variables.fileIcon = "documenticon.gif";
	} else if (listFind("zip",variables.extension) gt 0) {
		variables.zipFile = 1;
	}
} else {
	variables.extension = "";
	variables.editable = 0;
}
if (type eq "dir") {
	variables.totalDirectories = variables.totalDirectories + 1;
	variables.fileIcon = "folder_closed.gif";
	variables.linkTarget = "_self";
	variables.linkToFile = cffm.cffmFilename & "?fuseaction=cFilemanager.default&subdir=";
	if (variables.subdir eq "") {
		variables.linkToFile = variables.linkToFile & name;
	} else {
		variables.linkToFile = variables.linkToFile & variables.subdir & "/" & name;
	}
} else {
	variables.totalFiles = variables.totalFiles + 1;
	variables.totalSize = variables.totalSize + size;
	if (listFind("gif,jpg,png",variables.extension) gt 0)
	{
		variables.fileIcon = "imgicon.gif";
		if (variables.extension eq "jpg")
		{
			variables.editableImage = 1;
		}
	}
	if (variables.editorType eq "")
	{
		// editorType is empty when CFFM is being used as a plain ol' file manager.
		variables.linkTarget = "_blank";
		variables.linkToFile = "#variables.workingDirectoryWeb#/#name#";
	} else {
		// editor type is "fck" or "mce" or something so we should perform some action when
		// a file is clicked on.
		variables.linkTarget = "_self";
		if ( variables.EDITOR_RESOURCE_TYPE eq "image" AND listFindNoCase("jpg,gif,png",extension) eq 0 )
		{
			// we can only perform the action if the file is an image.
			variables.linkToFile="javascript:alert('#cffm.resourceKit["Msg.t32"]#.');";
		} else if ( variables.EDITOR_RESOURCE_TYPE eq "flash" AND lcase(extension) neq "swf") {
			// we can only perform the action if the file is a flash document.
			variables.linkToFile="javascript:alert('Sorry, but this file is not a Flash document.  Flash documents have a .SWF extension.');";
		} else {
			// we're inserting a link to a file, so any file would be fine.
			variables.linkToFile = "#variables.workingDirectoryWeb#/#name#";
			variables.linkToFile = Replace(variables.linkToFile,"'","\'","ALL");
			variables.linkToFile = "javascript:OpenFile('#variables.linkToFile#');";
		}
	}
}</cfscript>
<tr>
<td><a href="#variables.linkToFile#" target="#variables.linkTarget#"><img src="#cffm.iconPath#/#variables.fileIcon#" border="0"></a></td>
<td class="varWidth"><a href="#variables.linkToFile#" target="#variables.linkTarget#">#name#</a></td>
<td><cfif size lt 10000>#size#&nbsp;bytes<cfelseif size lt 1000000>#round(size/1024)#&nbsp;KB<cfelse>#round(size/1024/1024)#&nbsp;MB</cfif><cfif variables.dimensions neq ""><br>#variables.dimensions#</cfif></td>
<td>#replace(LSDateFormat(dateLastModified,session.dateKeyFormat)," ","&nbsp;","ALL")#</td>
<td>#replace(LSTimeFormat(dateLastModified)," ","&nbsp;","ALL")#</td>
<td class="administration"><ul class="seven">
<cfif variables.editable eq 1><li class="edit"><a href="#cffm.cffmFilename#?action=edit&subdir=#urlEncodedFormat(variables.subdir)#&editFilename=#urlEncodedFormat(name)#&fuseaction=cFilemanager.default&siteid=#session.siteid#" alt="Edit" title="Edit">#cffm.resourceKit["Msg.t53"]#</a></li><cfelse><li class="editOff">#cffm.resourceKit["Msg.t53"]#</li></cfif>
<li class="rename"><a href="#cffm.cffmFilename#?action=renameForm&subdir=#urlEncodedFormat(variables.subdir)#&editFilename=#urlEncodedFormat(name)#&fuseaction=cFilemanager.default&siteid=#session.siteid#" alt="Rename" title="Rename">#cffm.resourceKit["Msg.t51"]#</a></li>
<li class="moveCopy"><a href="#cffm.cffmFilename#?action=copymoveForm&subdir=#UrlEncodedFormat(variables.subdir)#&editFilename=#urlEncodedFormat(name)#&fuseaction=cFilemanager.default&siteid=#session.siteid#" alt="Move/Copy" title="Move/Copy">#cffm.resourceKit["Msg.t52"]#</a></li>
<cfif variables.editable eq 1><li class="source"><a href="#cffm.cffmFilename#?fuseaction=cFilemanager.default&siteid=#session.siteid#&action=viewSource&subdir=#urlEncodedFormat(variables.subdir)#&editFilename=#urlEncodedFormat(name)#" alt="View Source" title="View Source">#cffm.resourceKit["Msg.t54"]#</a></li><cfelse><li class="sourceOff">#cffm.resourceKit["Msg.t54"]#</li></cfif>
<cfif variables.zipfile eq 1><li class="viewUnzip"><a href="#cffm.cffmFilename#?action=viewzip&subdir=#urlEncodedFormat(variables.subdir)#&editFilename=#urlEncodedFormat(name)#&fuseaction=cFilemanager.default&siteid=#session.siteid#" alt="View/Unzip" title="View/Update">#cffm.resourceKit["Msg.t55"]#</a></li><cfelse><li class="viewUnzipOff">#cffm.resourceKit["Msg.t55"]#</li></cfif>
<cfif variables.editableImage><li class="manipulate"><a href="#cffm.cffmFilename#?action=manipulateForm&subdir=#urlEncodedFormat(variables.subdir)#&editFilename=#urlEncodedFormat(name)#&fuseaction=cFilemanager.default&siteid=#session.siteid#" alt="Manipulate" title="Manipulate">#cffm.resourceKit["Msg.t56"]#</a></li><cfelse><li class="manipulateOff">#cffm.resourceKit["Msg.t56"]#</li></cfif>
<li class="delete"><a href="javascript:if(confirm('Delete #cffm.getPathType(cffm.createServerPath(variables.subdir,name))# \'#replace(name,"'","\'","ALL")#\'?')){window.location.href='#cffm.cffmFilename#?fuseaction=cFilemanager.default&siteid=#session.siteid#&action=delete&subdir=' + escape('#replace(variables.subdir,"'","\'","ALL")#') +'&deleteFilename=' + escape('#replace(name,"'","\'","ALL")#');}" alt="Delete" title="Delete">#cffm.resourceKit["Msg.t50"]#</a></li></ul>
</td>
</tr>
</cfoutput>
</table>
<cfoutput>
#cffm.resourceKit["Msg.t33"]# #variables.totalDirectories# <cfif variables.totalDirectories IS 1>#cffm.resourceKit["Msg.t34"]#<cfelse>#cffm.resourceKit["Msg.t35"]#</cfif> 

#cffm.resourceKit["Msg.t36"]# #variables.totalFiles# <cfif variables.totalFiles eq 1>#cffm.resourceKit["Msg.t37"]#<cfelse>#cffm.resourceKit["Msg.t38"]#</cfif>.<br>
#cffm.resourceKit["Msg.t39"]# #NumberFormat(variables.totalSize,"_,___")# bytes.<br>
<cfif variables.showTotalUsage eq 1>
	<cfset variables.metadata = cffm.getDirectoryMetadata(variables.listAllFiles)>
	#cffm.resourceKit["Msg.t40"]#:  #variables.metadata.totalSize# bytes
<cfelse>
	<a href="#cffm.cffmFilename#?subdir=#variables.subdir#&showTotalUsage=1&fuseaction=cFilemanager.default&siteid=#session.siteid#">#cffm.resourceKit["Msg.t45"]#</a>
</cfif>

</cfoutput>
</cfif>
<!---<p>
<cfoutput>#cffm.resourceKit.Msg.t46# <a href="http://www.webworksllc.com/cffm">CFFM v.#cffm.version#</A></cfoutput>
<p>--->
<cfif cffm.templateWrapperBelow neq "">
	<cfinclude template="#cffm.templateWrapperBelow#">
</cfif>
