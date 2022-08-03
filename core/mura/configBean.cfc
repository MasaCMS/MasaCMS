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

<cfcomponent extends="mura.cfobject" output="false" hint="This provides access the global configuration">
<cfset variables.instance=structNew()/>
<cfset variables.instance.mode=""/>
<cfset variables.autoupdateurl="https://github.com/MasaCMS/MasaCMS/archive/main.zip"/>
<cfset variables.instance.version="7.2.4"/>
<cfset variables.instance.title="Masa CMS"/>
<cfset variables.instance.projectname="Masa CMS"/>
<cfset variables.instance.projectname="Masa CMS"/>
<cfset variables.instance.webroot=""/>
<cfset variables.instance.webrootmap="muraWRM"/>
<cfset variables.instance.mapdir="mura"/>
<cfset variables.instance.datasource=""/>
<cfset variables.instance.defaultthemeurl="https://github.com/MasaCMS/MasaBootstrap4/archive/main.zip">
<cfset variables.instance.stub=""/>
<cfset variables.instance.context=""/>
<cfset variables.instance.admindomain=""/>
<cfset variables.instance.indexfile=""/>
<cfset variables.instance.contact=""/>
<cfset variables.instance.sendfrommailserverusername=true/>
<cfset variables.instance.mailserverusername=""/>
<cfset variables.instance.mailserverusernameemail=""/>
<cfset variables.instance.mailserverpassword=""/>
<cfset variables.instance.mailserverip=""/>
<cfset variables.instance.MailServerSMTPPort="25"/>
<cfset variables.instance.MailServerPOPPort="110"/>
<cfset variables.instance.MailServerTLS="false"/>
<cfset variables.instance.MailServerSSL="false" />
<cfset variables.instance.useDefaultSMTPServer=false/>
<cfset variables.instance.adminssl=false/>
<cfset variables.instance.forceAdminSSL=true>
<cfset variables.instance.logEvents=false/>
<cfset variables.instance.fileDelim="\" />
<cfset variables.instance.dbType="mssql"/>
<cfset variables.instance.dbUsername=""/>
<cfset variables.instance.dbPassword=""/>
<cfset variables.instance.dbtablespace="USERS"/>
<cfset variables.instance.dbCaseSensitive=false>
<cfset variables.instance.dbSchema=""/>
<!--- <cfset variables.instance.dbTransactionLevel="read_committed"/> --->
<cfset variables.instance.debuggingEnabled="false"/>
<cfset variables.instance.compiler="adobe"/>
<cfset variables.instance.serverPort=""/>
<cfset variables.instance.fileDir=""/>
<cfset variables.instance.assetDir=""/>
<cfset variables.instance.assetPath="/tasks/sites"/>
<cfset variables.instance.corepath=""/>
<cfset variables.instance.pluginspath=""/>
<cfset variables.instance.pluginDir=""/>
<cfset variables.instance.productionDatasource=""/>
<cfset variables.instance.productionAssetPath=""/>
<cfset variables.instance.productionWebroot=""/>
<cfset variables.instance.productionFiledir=""/>
<cfset variables.instance.productionAssetdir=""/>
<cfset variables.instance.productionPushMode="full"/>
<cfset variables.instance.fileStore="fileDir"/>
<cfset variables.instance.fileStoreAccessInfo=""/>
<cfset variables.instance.fileStoreEndPoint="http://s3.amazonaws.com"/>
<cfset variables.instance.tooltips=structNew()/>
<cfset variables.instance.sessionHistory=1 />
<cfset variables.instance.clearSessionHistory=1 />
<cfset variables.instance.extensionManager=""/>
<cfset variables.instance.locale="Server" />
<cfset variables.instance.imageInterpolation="highQuality" />
<cfset variables.instance.imageQuality=.95 />
<cfset variables.instance.clusterIPList="" />
<cfset variables.instance.enableDynamicContent=true />
<cfset variables.instance.enableMuraTag=true />
<cfset variables.instance.dashboard=true />
<cfset variables.instance.sortPermission="" />
<cfset variables.instance.proxyUser="" />
<cfset variables.instance.proxyPassword="" />
<cfset variables.instance.proxyServer="" />
<cfset variables.instance.proxyPort="80" />
<cfset variables.instance.sharableRemoteSessions=true />
<cfset variables.instance.siteIDInURLS=true />
<cfset variables.instance.indexFileInURLS=true />
<cfset variables.instance.hashURLs=false />
<cfset variables.instance.strictExtendedData=true />
<cfset variables.instance.purgeDrafts=true />
<cfset variables.instance.createRequiredDirectories=true />
<cfset variables.instance.confirmSaveAsDraft=true />
<cfset variables.instance.notifyWithVersionLink=true />
<cfset variables.instance.scriptProtect=true />
<cfset variables.instance.scriptProtectExceptions="body,source,params" />
<cfset variables.instance.appreloadKey="appreload" />
<cfset variables.instance.loginStrikes=4 />
<cfset variables.instance.encryptPasswords=true />
<cfset variables.instance.sessionTimeout=180 />
<cfset variables.instance.tempDir="" />
<cfset variables.instance.autoresetpasswords=true />
<cfset variables.instance.encryptionKey=hash(getCurrentTemplatePath()) />
<cfset variables.instance.uselegacysessions=false />
<cfset variables.instance.customUrlVarDelimiters="_">
<cfset variables.instance.strongPasswordRegex="(?=^.{7,15}$)(?=.*\d)(?![.\n])(?=.*[a-z])(?=.*[A-Z]).*$">
<cfset variables.instance.duplicateTransients=false>
<cfset variables.instance.maxArchivedVersions=0 />
<cfset variables.instance.postBundles=false />
<cfset variables.instance.applyDBUpdates=true />
<cfset variables.instance.broadcastCachePurges=true />
<cfset variables.instance.broadcastAppreloads=true />
<cfset variables.instance.broadcastWithProxy=true />
<cfset variables.instance.clearOldBroadcastCommands=true>
<cfset variables.instance.readOnlyDatasource="" />
<cfset variables.instance.readOnlyDbUsername="" />
<cfset variables.instance.readOnlyDbPassword="" />
<cfset variables.instance.MYSQLEngine="InnoDB" />
<cfset variables.instance.autoDiscoverPlugins=false />
<cfset variables.instance.trackSessionInNewThread=true />
<cfset variables.instance.cfStaticJavaLoaderScope="application">
<cfset variables.instance.URLTitleDelim="-">
<cfset variables.instance.BCryptLogRounds=10>
<cfset variables.instance.BCryptReseedFrequency=60>
<cfset variables.instance.maxSourceImageWidth=4000>
<cfset variables.dbUtility="">
<cfset variables.instance.allowAutoUpdates=false>
<cfset variables.instance.CFFPConfigFilename="cffp.ini.cfm">
<cfset variables.instance.loadcontentby='filename'/>
<cfset variables.instance.strictfactory=false/>
<cfset variables.instance.managelinks=true/>
<cfset variables.instance.hasRazuna=false>
<cfset variables.instance.purgecomments=true />
<cfset variables.instance.defaultflatviewrange=0 />
<cfset variables.instance.defaultflatviewtable="" />
<cfset variables.instance.showadminloginhelp=true/>
<cfset variables.instance.allowUnicodeInFilenames=false/>
<cfset variables.instance.dashboardcomments=true/>
<cfset variables.instance.lockableNodes=false/>
<cfset variables.instance.allowLocalFiles=false/>
<cfset variables.instance.dataCollection=true/>
<cfset variables.instance.adManager=false/>
<cfset variables.instance.emailBroadcaster=false/>
<cfset variables.instance.allowSimpleHTMLForms=true/>
<cfset variables.instance.manageSessionCookies=true/>
<cfset variables.instance.securecookies=false/>
<cfset variables.instance.sessioncookiesexpires="never"/>
<cfset variables.instance.cookiedomain=""/>
<cfset variables.instance.cookiepath=""/>
<cfset variables.instance.javaEnabled=true/>
<cfset variables.instance.bCryptPasswords=true/>
<cfset variables.instance.allowQueryCaching=true/>
<cfset variables.instance.skipCleanFileCache=false/>
<cfset variables.instance.saveEmptyExtendedValues=true/>
<cfset variables.instance.MFAPerDeviceEnabled=false/>
<cfset variables.instance.MFAEnabled=false/>
<cfset variables.instance.MFASendAuthCode=true/>
<cfset variables.instance.FMAllowedExtensions='7z,aiff,asf,avi,bmp,csv,doc,docx,eps,fla,flv,gif,gz,gzip,ics,jpeg,jpg,json,key,keynote,mid,mov,mp3,mp4,mpc,mpeg,mpg,numbers,ods,odt,pages,pdf,png,ppt,pptx,ppsx,pxd,qt,ram,rar,rm,rmi,rmvb,rtf,sdc,sitd,swf,sxc,sxw,svg,tar,tgz,tif,tiff,txt,vsd,wav,wma,wmv,xls,xlsx,xml,zip,m4v,less'>
<cfset variables.instance.FMPublicAllowedExtensions='7z,aiff,asf,avi,bmp,csv,doc,docx,eps,fla,flv,gif,gz,gzip,ics,jpeg,jpg,json,key,keynote,mid,mov,mp3,mp4,mpc,mpeg,mpg,numbers,ods,odt,pages,pdf,png,ppt,pptx,ppsx,pxd,qt,ram,rar,rm,rmi,rmvb,rtf,sdc,sitd,swf,sxc,sxw,svg,tar,tgz,tif,tiff,txt,vsd,wav,wma,wmv,xls,xlsx,xml,zip,m4v,less'>
<cfset variables.instance.adminDir="/admin"/>
<cfset variables.instance.allowedIndexFiles="index.cfm,index.json,index.html"/>
<cfset variables.instance.HSTSMaxAge=1200/>
<cfset variables.instance.siteDir="sites"/>
<cfset variables.instance.legacyAppcfcSupport=false>
<cfset variables.instance.showUsageTags=true>
<cfset variables.instance.offline404=true>
<cfset variables.instance.externalConfig="">
<cfset variables.instance.forceDirectoryStructure=true>
<cfset variables.instance.suppressAPIParams=true>
<cfset variables.instance.sessionBasedLockdown=true>
<cfset variables.instance.autoPurgeOutputCache=true>
<cfset variables.instance.filemanagerEnabled=false>
<cfset variables.instance.CKFinderlicenseName="">
<cfset variables.instance.CKFinderlicenseKey="">

<cffunction name="OnMissingMethod" output="false" hint="Handles missing method exceptions.">
<cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method." />
<cfargument name="MissingMethodArguments" type="struct" required="true" />
<cfset var prop="">
<cfset var prefix=left(arguments.MissingMethodName,3)>

<cfif len(arguments.MissingMethodName)>
	<!--- forward normal getters to the default getValue method --->
	<cfif prefix eq "get" and len(arguments.MissingMethodName)gt 3>
		<cfset prop=right(arguments.MissingMethodName,len(arguments.MissingMethodName)-3)>
		<cfreturn getValue(prop)>

	<cfelseif prefix eq "set" and len(arguments.MissingMethodName)gt 3>
		<cfset prop=right(arguments.MissingMethodName,len(arguments.MissingMethodName)-3)>
		<cfreturn setValue(prop,arguments.MissingMethodArguments[1])>
	<cfelse>
		<cfthrow message="The method '#arguments.MissingMethodName#' is not defined">
	</cfif>

<cfelse>
	<cfreturn "">
</cfif>

</cffunction>

<cffunction name="passwordsExpire" output="false">
	<cfset var expireIn=getValue(property="expirePasswords", defaultValue=0)>

	<cfif not isNumeric(expireIn) or expireIn eq 0>	
		<cfreturn false>
	<cfelse>
		<cfreturn true>
	</cfif>
</cffunction>

<cffunction name="set" output="true">
	<cfargument name="property" required="true">
	<cfargument name="propertyValue">

	<cfif not isDefined('arguments.config')>
		<cfif isSimpleValue(arguments.property)>
			<cfreturn setValue(argumentCollection=arguments)>
		</cfif>

		<cfset arguments.config=arguments.property>
	</cfif>

	<cfset var prop="">
	<cfset var tempFunc="">

	<cfloop collection="#arguments.config#" item="prop">
		<cfif not listFindNoCase("webroot,filedir,plugindir,locale,port,assetpath,context",prop)>
			<cfif isDefined("this.set#prop#")>
				<cfset tempFunc=this["set#prop#"]>
				<cfset tempFunc(arguments.config['#prop#'])>
			<cfelse>
				<cfset setValue(prop,arguments.config[prop])>
			</cfif>
		</cfif>
	</cfloop>

	<cfif not directoryExists(expandPath('/muraWRM/sites/')) and directoryExists(expandPath('/muraWRM/default/'))>
		<cfset variables.instance.siteDir=''>
	</cfif>

	<cfset variables.instance.version=getVersionFromFile()>

	<cfif isDefined('arguments.config.s3assets') and len(arguments.config.s3assets)>
		<cfif right(arguments.config.s3assets,1) neq "/">
			<cfset arguments.config.s3assets=arguments.config.s3assets & "/">
		</cfif>
		<cfset arguments.config.fileDir=arguments.config.s3assets & listRest(arguments.config.fileDir,"/")>
		<cfif isDefined('arguments.config.assetdir')>
			<cfset arguments.config.assetdir=arguments.config.s3assets & listRest(arguments.config.assetdir,"/")>
		</cfif>
	</cfif>

	<cfset setWebRoot(arguments.config.webroot)/>
	<cfset setContext(arguments.config.context)/>
	<cfset setAssetPath(arguments.config.assetPath)/>
	<cfset setFileDir(arguments.config.fileDir)/>
	<cfset setDefaultLocale(arguments.config.locale)>
	<cfset setServerPort(arguments.config.port)>

	<cfif not len(getAssetPath())>
		<cfset setAssetPath(getSiteAssetPath())/>
	</cfif>

	<cfif not len(variables.instance.tempDir)>
		<cfset variables.instance.tempDir=getTempDirectory()>
	</cfif>

	<cfif structKeyExists(arguments.config,"assetDir")>
		<cfset setAssetDir(arguments.config.assetDir)/>
	<cfelse>
		<cfset setAssetDir(arguments.config.fileDir)/>
	</cfif>

	<cfif structKeyExists(arguments.config,"pluginDir") and len(trim(arguments.config.pluginDir))>
		<cfset setPluginDir(arguments.config.pluginDir)/>
	<cfelse>
		<cfset setPluginDir("#getWebRoot()#/plugins")/>
	</cfif>

	<cfswitch expression="#server.coldfusion.productName#">
	<cfcase value="Railo">
		<cfset setCompiler("Railo")/>
	</cfcase>
	<cfcase value="Lucee">
		<cfset setCompiler("Lucee")/>
	</cfcase>
	<cfdefaultcase>
		<cfset setCompiler("Adobe")/>
	</cfdefaultcase>
	</cfswitch>

	<cfif not len(variables.instance.readOnlyDatasource)>
		<cfset variables.instance.readOnlyDatasource=variables.instance.datasource>
	</cfif>

	<cfif not len(variables.instance.readOnlyDbPassword)>
		<cfset variables.instance.readOnlyDbPassword=variables.instance.dbPassword>
	</cfif>

	<cfif not len(variables.instance.readOnlyDbUsername)>
		<cfset variables.instance.readOnlyDbUsername=variables.instance.dbUsername>
	</cfif>

	<cfif not IsBoolean(variables.instance.allowAutoUpdates)>
		<cfset variables.instance.allowAutoUpdates=false>
	</cfif>

	<cfreturn this />
</cffunction>

<cffunction name="getMode" output="false">
	<cfreturn variables.instance.mode />
</cffunction>

<cffunction name="setMode" output="false">
	<cfargument name="Mode" type="String" />
	<cfset variables.instance.Mode = arguments.Mode />
	<cfreturn this>
</cffunction>

<cffunction name="getVersion" output="false">
	<cfreturn variables.instance.version />
</cffunction>

<cffunction name="setVersion" output="false">
	<cfargument name="Version" type="String" />
	<cfset variables.instance.version = arguments.Version />
	<cfreturn this>
</cffunction>

<cffunction name="getTitle" output="false">
	<cfreturn variables.instance.title />
</cffunction>

<cffunction name="setTitle" output="false">
	<cfargument name="Title" type="String" />
	<cfset variables.instance.Title = arguments.Title />
	<cfreturn this>
</cffunction>

<cffunction name="getWebRoot" output="false">
	<cfreturn variables.instance.webroot />
</cffunction>

<cffunction name="setWebRoot" output="false">
	<cfargument name="webroot" type="String" />
	<cfset variables.instance.webroot = cleanFilePath(arguments.webroot) />
	<cfreturn this>
</cffunction>

<cffunction name="getWebRootMap" output="false">
	<cfreturn variables.instance.webrootmap />
</cffunction>

<cffunction name="setWebRootMap" output="false">
	<cfargument name="webrootmap" type="String" />
	<cfset variables.instance.webrootmap = arguments.webrootmap />
	<cfreturn this>
</cffunction>

<cffunction name="getMapDir" output="false">
	<cfreturn variables.instance.mapDir />
</cffunction>

<cffunction name="setMapDir" output="false">
	<cfargument name="MapDir" type="String" />
	<cfset variables.instance.mapDir = arguments.MapDir />
	<cfreturn this>
</cffunction>

<cffunction name="getDatasource" output="false">
	<cfargument name="mode" default="" />
	<cfreturn variables.instance.datasource />
</cffunction>

<cffunction name="setDatasource" output="false">
	<cfargument name="Datasource" type="String" />
	<cfset variables.instance.Datasource = arguments.Datasource />
	<cfreturn this>
</cffunction>

<cffunction name="getReadOnlyDatasource" output="false">
	<cfargument name="mode" default="" />
	<cfreturn variables.instance.readOnlyDatasource />
</cffunction>

<cffunction name="setReadOnlyDatasource" output="false">
	<cfargument name="readOnlyDatasource" type="String" />
	<cfset variables.instance.readOnlyDatasource = arguments.readOnlyDatasource />
	<cfreturn this>
</cffunction>

<cffunction name="getReadOnlyDbPassword" output="false">
	<cfreturn variables.instance.readOnlyDbPassword />
</cffunction>

<cffunction name="setReadOnlyDbPassword" output="false">
	<cfargument name="readOnlyDbPassword" type="String" />
	<cfset variables.instance.readOnlyDbPassword = arguments.readOnlyDbPassword />
	<cfreturn this>
</cffunction>

<cffunction name="getReadOnlyDbUsername" output="false">
	<cfif len(variables.instance.readOnlyDbPassword)>
		<cfreturn variables.instance.readOnlyDbUsername />
	<cfelse>
		<cfreturn ''>
	</cfif>
</cffunction>

<cffunction name="setReadOnlyDbUsername" output="false">
	<cfargument name="readOnlyDbUsername" type="String" />
	<cfset variables.instance.readOnlyDbUsername = arguments.readOnlyDbUsername />
	<cfreturn this>
</cffunction>

<cffunction name="getContext" output="false">
	<cfreturn variables.instance.context />
</cffunction>

<cffunction name="setContext" output="false">
	<cfargument name="Context" type="String" />
	<cfset arguments.Context=cleanFilePath(arguments.Context) />
	<cfif getContextRoot() NEQ "/" and getContextRoot() NEQ getValue('adminDir')>
		<cfset arguments.Context = getContextRoot() & arguments.Context />
	</cfif>
	<cfset variables.instance.Context = arguments.Context />

	<cfreturn this>
</cffunction>

<cffunction name="getStub" output="false">
	<cfreturn variables.instance.stub />
</cffunction>

<cffunction name="setStub" output="false">
	<cfargument name="Stub" type="String" />
	<cfset variables.instance.stub = cleanFilePath(arguments.Stub) />
	<cfreturn this>
</cffunction>

<cffunction name="getAdminDomain" output="false">
	<cfreturn variables.instance.adminDomain />
</cffunction>

<cffunction name="setAdminDomain" output="false">
	<cfargument name="AdminDomain" type="String" />
	<cfset variables.instance.AdminDomain = arguments.AdminDomain />
	<cfreturn this>
</cffunction>

<cffunction name="getIndexFile" output="false">
	<cfreturn variables.instance.indexFile />
</cffunction>

<cffunction name="setIndexFile" output="false">
	<cfargument name="IndexFile" type="String" />
	<cfset variables.instance.IndexFile = arguments.IndexFile />
	<cfreturn this>
</cffunction>

<cffunction name="getAdminEmail" output="false">
	<cfreturn variables.instance.adminEmail />
</cffunction>

<cffunction name="setAdminEmail" output="false">
	<cfargument name="AdminEmail" type="String" />
	<cfset variables.instance.adminEmail = arguments.AdminEmail />
	<cfreturn this>
</cffunction>

<cffunction name="setSendFromMailServerUsername" output="false">
	<cfargument name="sendFromMailServerUsername"/>
	<cfif isBoolean(arguments.sendFromMailServerUsername)>
		<cfset variables.instance.sendFromMailServerUsername = arguments.sendFromMailServerUsername />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getSendFromMailServerUsername" output="false">
	<cfreturn variables.instance.SendFromMailServerUsername />
</cffunction>

<cffunction name="setMailServerUsernameEmail" output="false">
	<cfargument name="MailServerUsernameEmail" type="String" />

	<cfif find("@",arguments.MailServerUsernameEmail)>
		<cfset variables.instance.MailServerUsernameEmail=arguments.MailServerUsernameEmail />
	<cfelseif find("+",arguments.MailServerUsernameEmail)>
			<cfset variables.instance.MailServerUsernameEmail=replace(arguments.MailServerUsernameEmail,"+","@") />
	<cfelse>
		<cfset variables.instance.MailServerUsernameEmail=arguments.MailServerUsernameEmail & "@" & listRest(variables.instance.MailServerIP,".") />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getMailServerUsernameEmail" output="false">
		<cfreturn variables.instance.mailServerUsernameEmail />
</cffunction>

<cffunction name="setMailServerUsername" output="false">
	<cfargument name="MailServerUsername" type="String" />
	<cfset setMailServerUsernameEmail(arguments.MailServerUsername) />
	<cfset variables.instance.mailServerUsername = arguments.MailServerUsername />
	<cfreturn this>
</cffunction>

<cffunction name="getMailServerUsername" output="false">
	<cfargument name="forLogin" default="false" required="true">
	<cfif not arguments.forLogin or len(getMailServerPassword())>
		<cfreturn variables.instance.mailServerUsername />
	<cfelse>
		<cfreturn ""/>
	</cfif>
</cffunction>

<cffunction name="getMailServerPassword" output="false">
	<cfreturn variables.instance.mailServerPassword />
</cffunction>

<cffunction name="setMailServerPassword" output="false">
	<cfargument name="MailServerPassword" type="String" />
	<cfset variables.instance.mailServerPassword = arguments.MailServerPassword />
	<cfreturn this>
</cffunction>

<cffunction name="getMailServerIP" output="false">
	<cfreturn variables.instance.mailServerIP />
</cffunction>

<cffunction name="setMailServerIP" output="false">
	<cfargument name="MailServerIP" type="String" />
	<cfset variables.instance.MailServerIP = arguments.MailServerIP />
	<cfreturn this>
</cffunction>

<cffunction name="getAdminSSL" output="false">
	<cfreturn variables.instance.adminSSL />
</cffunction>

<cffunction name="setAdminSSL" output="false">
	<cfargument name="AdminSSL" />
	<cfset variables.instance.adminSSL = arguments.AdminSSL />
	<cfreturn this>
</cffunction>

<cffunction name="getLogEvents" output="false">
	<cfreturn variables.instance.logEvents />
</cffunction>

<cffunction name="setLogEvents" output="false">
	<cfargument name="logEvents"/>
	<cfset variables.instance.logEvents = arguments.logEvents />
	<cfreturn this>
</cffunction>

<cffunction name="getFileDelim" output="false">
	<cfreturn variables.instance.fileDelim />
</cffunction>

<cffunction name="setFileDelim" output="false">
	<cfargument name="fileDelim" default="" />
	<cfif Len(arguments.fileDelim)>
		<cfset variables.instance.fileDelim = arguments.fileDelim />
	<cfelseif FindNoCase("Windows", server.os.name)>
		 <cfset variables.instance.fileDelim = "\" />
	<cfelse>
		<cfset variables.instance.fileDelim = "/" />
	</cfif>
    <cfreturn this>
</cffunction>

<cffunction name="getDbType" output="false">
	<cfreturn variables.instance.dbType />
</cffunction>

<cffunction name="setDbType" output="false">
	<cfargument name="dbType" type="string" />
	<cfif left(arguments.dbType,5) eq "mysql" or arguments.dbType eq "h2">
		<cfset variables.instance.dbType = "mysql" />
	<cfelse>
		<cfset variables.instance.dbType = arguments.dbType />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getDbPassword" output="false">
	<cfargument name="mode" default="" />
	<cfreturn variables.instance.dbPassword />
</cffunction>

<cffunction name="setDbPassword" output="false">
	<cfargument name="dbPassword" type="string" />
	<cfset variables.instance.dbPassword = arguments.dbPassword />
	<cfreturn this>
</cffunction>

<cffunction name="getDbUsername" output="false">
	<cfargument name="mode" default="" />
	<cfif len(variables.instance.DbPassword)>
		<cfreturn variables.instance.DbUsername />
	<cfelse>
		<cfreturn ''>
	</cfif>
</cffunction>

<cffunction name="setDbUsername" output="false">
	<cfargument name="dbUsername" type="string" />
	<cfset variables.instance.dbUsername = arguments.dbUsername />
	<cfreturn this>
</cffunction>

<cffunction name="getDbTablespace" output="false">
	<cfreturn variables.instance.dbTablespace />
</cffunction>

<cffunction name="setDbTablespace" output="false">
	<cfargument name="dbTablespace" type="string" />
	<cfset arguments.dbTablespace=trim(ucase(arguments.dbTablespace))>
	<cfif len(arguments.dbTablespace)>
		<cfset variables.instance.dbTablespace = arguments.dbTablespace/>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getDebuggingEnabled" output="false">
	<cfreturn variables.instance.debuggingEnabled />
</cffunction>

<cffunction name="setDebuggingEnabled" output="false">
	<cfargument name="debuggingEnabled" type="string" />
	<cfset variables.instance.debuggingEnabled = arguments.debuggingEnabled />
	<cfreturn this>
</cffunction>

<cffunction name="getCompiler" output="false">
	<cfreturn variables.instance.compiler />
</cffunction>

<cffunction name="setCompiler" output="false">
	<cfargument name="compiler" type="string" />
	<cfset variables.instance.compiler = arguments.compiler />
	<cfreturn this>
</cffunction>

<cffunction name="getServerPort" output="false">
	<cfreturn variables.instance.serverPort />
</cffunction>

<cffunction name="setServerPort" output="false">
	<cfargument name="ServerPort" type="string" />
	<cfif !ListFind('80,443', arguments.serverPort) and len(trim(arguments.serverPort))>
		<cfset variables.instance.ServerPort = ":#arguments.ServerPort#" />
	<cfelse>
		<cfset variables.instance.ServerPort = "" />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getFileDir" output="false">
	<cfreturn variables.instance.fileDir />
</cffunction>

<cffunction name="setFileDir" output="false">
	<cfargument name="fileDir" type="string" default="" />

	<cfset var ap=variables.instance.assetPath/>

	<cfset arguments.fileDir=cleanFilePath(arguments.fileDir)>

	<cfif len(arguments.fileDir)>
		<cfset variables.instance.fileDir = arguments.fileDir />
	<cfelse>
		<cfif len(variables.instance.context) and len(ap)>
			<cfset ap=replaceNoCase(ap,variables.instance.context,"") />
		</cfif>
		<cfif len(ap)>
			<cfset variables.instance.fileDir = variables.instance.webroot & replace(ap,"/",variables.instance.filedelim,"all") />
		<cfelse>
			<cfset variables.instance.fileDir = getSiteDir()  />
		</cfif>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="getAssetDir" output="false">
	<cfreturn variables.instance.assetDir />
</cffunction>

<cffunction name="setAssetDir" output="false">
	<cfargument name="assetDir" type="string" default="" />

	<cfset var ap=variables.instance.assetPath/>

	<cfset arguments.assetDir=cleanFilePath(arguments.assetDir)>

	<cfif len(arguments.assetDir)>
		<cfset variables.instance.assetDir = arguments.assetDir />
	<cfelse>
		<cfif len(variables.instance.context) and len(ap)>
			<cfset ap=replaceNoCase(ap,variables.instance.context,"") />
		</cfif>
		<cfif len(ap)>
			<cfset variables.instance.assetDir = variables.instance.webroot & replace(ap,"/",variables.instance.filedelim,"all") />
		<cfelse>
			<cfset variables.instance.assetDir = getSiteDir()  />
		</cfif>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="getAssetPath" output="false">
	<cfreturn variables.instance.assetPath />
</cffunction>

<cffunction name="setAssetPath" output="false">
	<cfargument name="assetPath" type="String" default="" />
	<cfset variables.instance.assetPath =cleanFilePath(arguments.assetPath) />
	<cfreturn this>
</cffunction>

<cffunction name="getProductionDatasource" output="false">
	<cfreturn variables.instance.productionDatasource />
</cffunction>

<cffunction name="setProductionDatasource" output="false">
	<cfargument name="ProductionDatasource" type="String" />
	<cfset variables.instance.productionDatasource = arguments.ProductionDatasource />
	<cfreturn this>
</cffunction>

<cffunction name="getProductionAssetPath" output="false">
	<cfreturn variables.instance.productionAssetPath />
</cffunction>

<cffunction name="setProductionAssetPath" output="false">
	<cfargument name="ProductionAssetPath" type="String" />
	<cfset variables.instance.ProductionAssetPath=cleanFilePath(arguments.ProductionAssetPath) />
	<cfreturn this>
</cffunction>

<cffunction name="getProductionWebroot" output="false">
	<cfreturn variables.instance.productionWebroot />
</cffunction>

<cffunction name="setProductionWebroot" output="false">
	<cfargument name="ProductionWebroot" type="String" />
	<cfset variables.instance.ProductionWebroot=cleanFilePath(arguments.ProductionWebroot) />
	<cfreturn this>
</cffunction>

<cffunction name="getProductionFiledir" output="false">
	<cfreturn variables.instance.productionFiledir />
</cffunction>

<cffunction name="setProductionFiledir" output="false">
	<cfargument name="ProductionFiledir" type="String" />
	<cfset variables.instance.productionFiledir=cleanFilePath(arguments.ProductionFiledir)/>
	<cfreturn this>
</cffunction>

<cffunction name="getProductionAssetdir" output="false">
	<cfreturn variables.instance.productionAssetdir />
</cffunction>

<cffunction name="setProductionAssetdir" output="false">
	<cfargument name="ProductionAssetdir" type="String" />
	<cfset variables.instance.productionAssetdir=cleanFilePath(arguments.ProductionAssetdir)/>
	<cfreturn this>
</cffunction>

<cffunction name="getProductionPushMode" output="false">
	<cfreturn variables.instance.ProductionPushMode />
</cffunction>

<cffunction name="setProductionPushMode" output="false">
	<cfargument name="productionPushMode" type="String" />
	<cfset variables.instance.productionPushMode=arguments.productionPushMode/>
	<cfreturn this>
</cffunction>

<cffunction name="getFileStore" output="false">
	<cfreturn variables.instance.fileStore />
</cffunction>

<cffunction name="setFileStore" output="false">
	<cfargument name="fileStore" type="String" />
	<cfset variables.instance.fileStore = arguments.fileStore />
	<cfreturn this>
</cffunction>

<cffunction name="setFileStoreAccessInfo" output="false">
	<cfargument name="fileStoreAccessInfo" type="String" />
	<cfset variables.instance.fileStoreAccessInfo = arguments.fileStoreAccessInfo />
	<cfreturn this>
</cffunction>

<cffunction name="getFileStoreAccessInfo" output="false">
	<cfreturn variables.instance.fileStoreAccessInfo />
</cffunction>

<cffunction name="setFileStoreEndPoint" output="false">
  	<cfargument name="fileStoreEndPoint" type="String" />
  	<cfset variables.instance.fileStoreEndPoint = arguments.fileStoreEndPoint />
  	<cfreturn this>
</cffunction>

<cffunction name="getFileStoreEndPoint" output="false">
  	<cfreturn variables.instance.fileStoreEndPoint />
</cffunction>

<cffunction name="getSessionHistory" output="false">
	<cfreturn variables.instance.sessionHistory />
</cffunction>

<cffunction name="setSessionHistory" output="false">
	<cfargument name="SessionHistory" type="String" />
	<cfif isNumeric(arguments.SessionHistory)>
		<cfset variables.instance.sessionHistory = arguments.SessionHistory />
	</cfif>
	<cfreturn this>
</cffunction>

<!---
<cffunction name="createGUID" output="false">
   <cfreturn insert("-", CreateUUID(), 23) />
</cffunction>
--->

<cffunction name="loadClassExtensionManager" output="false">
	<cfset variables.instance.extensionManager=createObject("component","mura.extend.extendManager").init(this) />
	<cfreturn this>
</cffunction>

<cffunction name="applyDbUpdates" output="false">
	<cfset var rsCheck ="" />
	<cfset var rsSubCheck ="" />
	<cfset var rsUpdates ="" />
	<cfset var dbUtility=getBean("dbUtility") />
	<cfset var i ="" />
	<cfset var MSSQLversion=0 />
	<cfset var MSSQLlob="[nvarchar](max)" />

	<cfif getValue(property="applyDbUpdates",defaultValue=true)>
		<cfif variables.instance.dbtype eq 'MSSQL'>
			<cftry>
				<cfquery attributeCollection="#getQueryAttrs(name='MSSQLversion')#">
					SELECT CONVERT(varchar(100), SERVERPROPERTY('ProductVersion')) as version
				</cfquery>
				<cfset MSSQLversion=listFirst(MSSQLversion.version,".")>
				<cfcatch></cfcatch>
			</cftry>

			<cftry>
				<cfif not MSSQLversion>
					<cfquery attributeCollection="#getQueryAttrs(name='MSSQLversion')#">
						EXEC sp_MSgetversion
					</cfquery>

					<cftry>
						<cfset MSSQLversion=left(MSSQLversion.CHARACTER_VALUE,1)>
						<cfcatch>
							<cfset MSSQLversion=mid(MSSQLversion.COMPUTED_COLUMN_1,1,find(".",MSSQLversion.COMPUTED_COLUMN_1)-1)>
						</cfcatch>
					</cftry>
				</cfif>

				<cfif MSSQLversion neq 8>
					<cfset MSSQLlob="[nvarchar](max)">
				<cfelse>
					<cfset MSSQLlob="[ntext]">
				</cfif>
			<cfcatch>
				<cfset MSSQLlob="[nvarchar](max)">
			</cfcatch>
			</cftry>
		</cfif>

		<cfdirectory action="list" directory="#getDirectoryFromPath(getCurrentTemplatePath())#dbUpdates" name="rsUpdates" filter="*.cfm" sort="name asc">

		<cfloop query="rsUpdates">
			<cfinclude template="dbUpdates/#rsUpdates.name#">
		</cfloop>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="qualifySchema" output="false" hint="Add schema to table name where required">
	<cfargument name="table">
	<cfset var rs = "">

	<cfif getDbType() eq "postgresql">
		<cfif variables.instance.dbSchema eq "">
			<cfquery attributeCollection="#getQueryAttrs(name='rs')#">
				SELECT current_schema() AS schema
			</cfquery>
			<cfset variables.instance.dbSchema = rs.schema>
		</cfif>
		<cfset arguments.table = variables.instance.dbSchema & "." & arguments.table>
	</cfif>

	<cfreturn arguments.table>
</cffunction>

<cffunction name="dbTableColumns" output="false" hint="deprecated, use dbUtility">
	<cfargument name="table">
	<cfset var rs ="">

	<cfswitch expression="#getDbType()#">
			<cfcase value="oracle">
				<cfquery attributeCollection="#getQueryAttrs(name='rs')#">
					SELECT column_name,
					data_length column_size,
					data_type type_name,
					nullable is_nullable,
					 data_precision
					FROM user_tab_cols
					WHERE table_name=UPPER('#arguments.table#')
			</cfquery>
			</cfcase>
			<!---
			<cfcase value="nuodb">
				<cfquery
				name="rs"
				datasource="#getDatasource()#"
				username="#getDbUsername()#"
				password="#getDbPassword()#">
					SELECT field ,
					length,
					datatype ,
					defaultvalue,
					1  is_nullable,
					precision
					FROM system.fields
					WHERE tablename='#ucase(arguments.table)#'
			</cfquery>
			<cfquery
				name="rs"
				dbtype="query">
					SELECT field column_name,
					length column_size,
					datatype type_name,
					defaultvalue column_default_value,
					is_nullable,
					precision data_precision
					FROM rs
			</cfquery>
			</cfcase>
			--->
			<cfcase value="mssql">
			<cfquery attributeCollection="#getQueryAttrs(name='rs')#">
					select column_name,
					character_maximum_length column_size,
					data_type type_name,
					column_default column_default_value,
					is_nullable,
					numeric_precision data_precision
					from INFORMATION_SCHEMA.COLUMNS
					where TABLE_NAME='#arguments.table#'
			</cfquery>
			</cfcase>
			<cfdefaultcase>
				<cfdbinfo attributeCollection="#getQueryAttrs(name='rs',table=qualifySchema(arguments.table),type='columns')#">
			</cfdefaultcase>
		</cfswitch>

	<cfreturn rs>
</cffunction>

<cffunction name="dbCreateIndex" output="false" hint="deprecated, use dbUtility">
	<cfargument name="table">
	<cfargument name="column" default="">

	<cfset var rsCheck="">

	<cfdbinfo
		name="rsCheck"
		datasource="#getDatasource()#"
		username="#getDbUsername()#"
		password="#getDbPassword()#"
		table="#qualifySchema(arguments.table)#"
		type="index">

	<cfquery name="rsCheck" dbtype="query">
		select * from rsCheck where lower(rsCheck.column_name) like '#arguments.column#'
	</cfquery>

	<cfif not rsCheck.recordcount>
	<cftry>
		<cfswitch expression="#getDbType()#">
		<cfcase value="mssql">
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE INDEX IX_#arguments.table#_#arguments.column# ON #arguments.table# (#arguments.column#)
			</cfquery>
		</cfcase>
		<cfcase value="mysql">
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE INDEX IX_#arguments.table#_#arguments.column# ON #arguments.table# (#arguments.column#)
			</cfquery>
		</cfcase>
		<cfcase value="postgresql">
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE INDEX IX_#arguments.table#_#arguments.column# ON #arguments.table# (#arguments.column#)
			</cfquery>
		</cfcase>
		<cfcase value="oracle">
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE INDEX #right("IX_#arguments.table#_#arguments.column#",30)# ON #arguments.table# (#arguments.column#)
			</cfquery>
		</cfcase>
		</cfswitch>
	<cfcatch></cfcatch>
	</cftry>
	</cfif>
</cffunction>

<cffunction name="dbDropIndex" output="false" hint="deprecated, use dbUtility">
	<cfargument name="table">
	<cfargument name="column" default="">

	<cfset var rsCheck="">

	<cfdbinfo
		name="rsCheck"
		datasource="#getDatasource()#"
		username="#getDbUsername()#"
		password="#getDbPassword()#"
		table="#qualifySchema(arguments.table)#"
		type="index">

	<cfquery name="rsCheck" dbtype="query">
		select * from rsCheck where lower(rsCheck.column_name) like '#arguments.column#'
	</cfquery>

	<cfif not rsCheck.recordcount>
	<cfswitch expression="#getDbType()#">
	<cfcase value="mssql">
		<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		DROP INDEX IX_#arguments.table#_#arguments.column# on #arguments.table#
		</cfquery>
	</cfcase>
	<cfcase value="mysql">
		<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		DROP INDEX IX_#arguments.table#_#arguments.column# on #arguments.table#
		</cfquery>
	</cfcase>
	<cfcase value="postgresql">
		<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		DROP INDEX IX_#arguments.table#_#arguments.column# on #arguments.table#
		</cfquery>
	</cfcase>
	<cfcase value="oracle">
		<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		DROP INDEX IX_#arguments.table#_#arguments.column#
		</cfquery>
	</cfcase>
	</cfswitch>
	</cfif>
</cffunction>

<cffunction name="dbDropColumn" access="private" hint="deprecated, use dbUtility">
	<cfargument name="table">
	<cfargument name="column" default="">

	<cfset var rsCheck="">

	<cfdbinfo attributeCollection="#getQueryAttrs(name='rs')#"
		name="rsCheck"
		datasource="#getDatasource()#"
		username="#getDbUsername()#"
		password="#getDbPassword()#"
		table="#qualifySchema(arguments.table)#"
		type="index">

	<cfquery name="rsCheck" dbtype="query">
		select * from rsCheck where lower(rsCheck.column_name) like '#arguments.column#'
	</cfquery>

	<cfif not rsCheck.recordcount>
	<cfswitch expression="#getDbType()#">
	<cfcase value="mssql">
		<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		ALTER TABLE #arguments.table# DROP COLUMN #arguments.column#
		</cfquery>
	</cfcase>
	<cfcase value="mysql">
		<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		ALTER TABLE #arguments.table# DROP COLUMN #arguments.column#
		</cfquery>
	</cfcase>
	<cfcase value="postgresql">
		<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		ALTER TABLE #arguments.table# DROP COLUMN #arguments.column#
		</cfquery>
	</cfcase>
	<cfcase value="oracle">
		<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		ALTER TABLE #arguments.table# DROP COLUMN #arguments.column#
		</cfquery>
	</cfcase>
	</cfswitch>
	</cfif>
</cffunction>
<cffunction name="getClassExtensionManager" output="false">

	<cfif not isObject(variables.instance.extensionManager)>
		<cfset loadClassExtensionManager()/>
	</cfif>
	<cfreturn variables.instance.extensionManager />
</cffunction>

<cffunction name="setDefaultLocale" output="false">
	<cfargument name="locale" type="String" />

	<cfif len(arguments.locale)>
		<cfset variables.instance.locale = arguments.locale />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getDefaultLocale" output="false">
	<cfreturn variables.instance.locale />
</cffunction>

<cffunction name="setUseDefaultSMTPServer" output="false">
	<cfargument name="UseDefaultSMTPServer"  />

	<cfif isNumeric(arguments.UseDefaultSMTPServer)>
		<cfset variables.instance.UseDefaultSMTPServer = arguments.UseDefaultSMTPServer />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getUseDefaultSMTPServer" output="false">
	<cfreturn variables.instance.UseDefaultSMTPServer />
</cffunction>

<cffunction name="setAdminDir" output="false">
	<cfargument name="adminDir" type="String" />
	<cfif len(arguments.adminDir) and arguments.adminDir neq '/'>
		<cfif left(arguments.adminDir,1) neq '/'>
			<cfset arguments.adminDir="/" & arguments.adminDir>
		</cfif>
		<cfset variables.instance.adminDir = arguments.adminDir />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getAdminDir" output="false">
	<cfparam name="variables.instance.adminDir" default="/admin">
	<cfreturn variables.instance.adminDir />
</cffunction>

<cffunction name="setImageInterpolation" output="false">
	<cfargument name="imageInterpolation" type="String" />

	<cfif len(arguments.imageInterpolation)>
		<cfset variables.instance.imageInterpolation = arguments.imageInterpolation />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getImageInterpolation" output="false">
	<cfreturn variables.instance.imageInterpolation />
</cffunction>

<cffunction name="setImageQuality" output="false">
	<cfargument name="imageQuality" type="numeric" />

	<cfif val(arguments.imageQuality)>
		<cfset variables.instance.imageQuality = arguments.imageQuality />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getImageQuality" output="false">
	<cfreturn variables.instance.imageQuality />
</cffunction>

<cffunction name="getMailServerSMTPPort" output="false">
	<cfreturn variables.instance.mailServerSMTPPort />
</cffunction>

<cffunction name="setMailServerSMTPPort" output="false">
	<cfargument name="mailServerSMTPPort" type="String" />
	<cfif isNumeric(arguments.mailServerSMTPPort)>
	<cfset variables.instance.mailServerSMTPPort = arguments.mailServerSMTPPort />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getMailServerPOPPort" output="false">
	<cfreturn variables.instance.mailServerPOPPort />
</cffunction>

<cffunction name="setMailServerPOPPort" output="false">
	<cfargument name="MailServerPOPPort" type="String" />
	<cfif isNumeric(arguments.MailServerPOPPort)>
	<cfset variables.instance.mailServerPOPPort = arguments.MailServerPOPPort />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getMailServerTLS" output="false">
	<cfreturn variables.instance.mailServerTLS />
</cffunction>

<cffunction name="setMailServerTLS" output="false">
	<cfargument name="mailServerTLS" type="String" />
	<cfif isBoolean(arguments.mailServerTLS)>
	<cfset variables.instance.mailServerTLS = arguments.mailServerTLS />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getMailServerSSL" output="false">
	<cfreturn variables.instance.mailServerSSL />
</cffunction>

<cffunction name="setMailServerSSL" output="false">
	<cfargument name="mailServerSSL" type="String" />
	<cfif isBoolean(arguments.mailServerSSL)>
	<cfset variables.instance.mailServerSSL = arguments.mailServerSSL />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getEnableMuraTag" output="false">
	<cfreturn variables.instance.enableMuraTag />
</cffunction>

<cffunction name="setEnableMuraTag" output="false">
	<cfargument name="enableMuraTag" type="String" />
	<cfif isBoolean(arguments.enableMuraTag)>
	<cfset variables.instance.enableMuraTag = arguments.enableMuraTag />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getDashboard" output="false">
	<cfset var i="">
	<cfset var currentUser=getCurrentUser()>
	<cfset var sessionData=getSession()>

	<cfif isBoolean(variables.instance.dashboard)>
		<cfreturn variables.instance.dashboard />
	<cfelseif isdefined("sessionData.mura") and len(sessionData.mura.siteID) and len(variables.instance.dashboard)>
		<cfif currentUser.isSuperUser()>
			<cfreturn true>
		</cfif>
		<cfloop list="#variables.instance.dashboard#" index="i">
			<cfif currentUser.isInGroup(group=i,isPublic=0)>
				<cfreturn true>
			</cfif>
		</cfloop>
		<cfreturn false>
	<cfelse>
		<cfreturn true>
	</cfif>
</cffunction>

<cffunction name="setDashboard" output="false">
	<cfargument name="dashboard" type="String" />
	<cfset variables.instance.dashboard = arguments.dashboard />
	<cfreturn this>
</cffunction>

<cffunction name="getClusterIPList" output="false">
	<cfreturn variables.instance.clusterIPList />
</cffunction>

<cffunction name="setClusterIPList" output="false">
	<cfargument name="clusterIPList" type="String" />
	<cfset variables.instance.clusterIPList = trim(arguments.clusterIPList) />
	<cfreturn this>
</cffunction>

<cffunction name="getAppreloadKey" output="false">
	<cfreturn variables.instance.appreloadKey />
</cffunction>

<cffunction name="setAppreloadKey" output="false">
	<cfargument name="AppreloadKey" type="String" />
	<cfset variables.instance.appreloadKey = arguments.appreloadKey />
	<cfreturn this>
</cffunction>

<cffunction name="getSortPermission" output="false">
	<cfreturn variables.instance.sortPermission />
</cffunction>

<cffunction name="setSortPermission" output="false">
	<cfargument name="sortPermission" type="String" />
	<cfset variables.instance.sortPermission = arguments.sortPermission />
	<cfreturn this>
</cffunction>

<cffunction name="getProxyUser" output="false">
	<cfreturn variables.instance.proxyUser />
</cffunction>

<cffunction name="setProxyUser" output="false">
	<cfargument name="proxyUser" type="String" />
	<cfset variables.instance.proxyUser = arguments.proxyUser />
	<cfreturn this>
</cffunction>

<cffunction name="getProxyPassword" output="false">
	<cfreturn variables.instance.proxyPassword />
</cffunction>

<cffunction name="setProxyPassword" output="false">
	<cfargument name="proxyPassword" type="String" />
	<cfset variables.instance.proxyPassword = arguments.proxyPassword />
	<cfreturn this>
</cffunction>

<cffunction name="getProxyServer" output="false">
	<cfreturn variables.instance.proxyServer />
</cffunction>

<cffunction name="setProxyServer" output="false">
	<cfargument name="proxyServer" type="String" />
	<cfset variables.instance.proxyServer = arguments.proxyServer />
	<cfreturn this>
</cffunction>

<cffunction name="getProxyPort" output="false">
	<cfreturn variables.instance.proxyPort />
</cffunction>

<cffunction name="setProxyPort" output="false">
	<cfargument name="proxyPort" type="String" />
	<cfif isnumeric(arguments.proxyPort)>
	<cfset variables.instance.proxyPort = arguments.proxyPort />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMaxSourceImageWidth" output="false">
	<cfargument name="maxSourceImageWidth" type="String" />
	<cfif isnumeric(arguments.maxSourceImageWidth)>
	<cfset variables.instance.maxSourceImageWidth = arguments.maxSourceImageWidth />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setTempDir" output="false">
	<cfargument name="tempDir" />
	<cfif len(arguments.tempDir) and directoryExists(arguments.tempDir)>
		<cfset variables.instance.tempDir = arguments.tempDir />
		<cfif not listFind("/,\",right(variables.instance.tempDir,1))>
			<cfset variables.instance.tempDir = variables.instance.tempDir & getFileDelim() />
		</cfif>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getTempDir" output="false">
	<cfreturn variables.instance.tempDir />
</cffunction>

<cffunction name="setPluginDir" output="false">
	<cfargument name="pluginDir" type="String" />
	<cfset arguments.pluginDir=cleanFilePath(arguments.pluginDir)>
	<cfif len(arguments.pluginDir)>
		<cfset variables.instance.pluginDir = arguments.pluginDir />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getPluginDir" output="false">
	<cfreturn variables.instance.pluginDir />
</cffunction>

<cffunction name="setSharableRemoteSessions" output="false">
	<cfargument name="sharableRemoteSessions" />
	<cfif isBoolean(arguments.sharableRemoteSessions)>
		<cfset variables.instance.sharableRemoteSessions = arguments.sharableRemoteSessions />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getSharableRemoteSessions" returntype="boolean" output="false">
	<cfreturn variables.instance.sharableRemoteSessions />
</cffunction>

<cffunction name="setSiteIDInURLS" output="false">
	<cfargument name="siteIDInURLS" />
	<cfif isBoolean(arguments.siteIDInURLS)>
		<cfset variables.instance.siteIDInURLS = arguments.siteIDInURLS />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getSiteIDInURLS" returntype="boolean" output="false">
	<cfreturn variables.instance.siteIDInURLS />
</cffunction>

<cffunction name="setIndexFileInURLS" output="false">
	<cfargument name="indexFileInURLS" />
	<cfif isBoolean(arguments.indexFileInURLS)>
		<cfset variables.instance.indexFileInURLS = arguments.indexFileInURLS />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getIndexFileInURLS" returntype="boolean" output="false">
	<cfreturn variables.instance.indexFileInURLS />
</cffunction>

<cffunction name="setStrictExtendedData" output="false">
	<cfargument name="strictExtendedData" />
	<cfif isBoolean(arguments.strictExtendedData)>
		<cfset variables.instance.strictExtendedData = arguments.strictExtendedData />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getStrictExtendedData" returntype="boolean" output="false">
	<cfreturn variables.instance.strictExtendedData />
</cffunction>

<cffunction name="setLoginStrikes" output="false">
	<cfargument name="loginStrikes" />
	<cfif isNumeric(arguments.loginStrikes)>
		<cfset variables.instance.loginStrikes = arguments.loginStrikes />
	</cfif>
</cffunction>

<cffunction name="getLoginStrikes" output="false">
	<cfreturn variables.instance.loginStrikes />
	<cfreturn this>
</cffunction>

<cffunction name="setPurgeDrafts" output="false">
	<cfargument name="purgeDrafts" />
	<cfif isBoolean(arguments.purgeDrafts)>
		<cfset variables.instance.purgeDrafts = arguments.purgeDrafts />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getPurgeDrafts" returntype="boolean" output="false">
	<cfreturn variables.instance.purgeDrafts />
</cffunction>

<cffunction name="setConfirmSaveAsDraft" output="false">
	<cfargument name="ConfirmSaveAsDraft" />
	<cfif isBoolean(arguments.confirmSaveAsDraft)>
		<cfset variables.instance.confirmSaveAsDraft = arguments.confirmSaveAsDraft />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getConfirmSaveAsDraft" returntype="boolean" output="false">
	<cfreturn variables.instance.confirmSaveAsDraft />
</cffunction>

<cffunction name="getNotifyWithVersionLink" returntype="boolean" output="false">
	<cfreturn variables.instance.notifyWithVersionLink />
</cffunction>

<cffunction name="setNotifyWithVersionLink" output="false">
	<cfargument name="notifyWithVersionLink" />
	<cfif isBoolean(arguments.notifyWithVersionLink)>
		<cfset variables.instance.notifyWithVersionLink = arguments.notifyWithVersionLink />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setScriptProtect" output="false">
	<cfargument name="scriptProtect" />
	<cfif isBoolean(arguments.scriptProtect)>
		<cfset variables.instance.scriptProtect = arguments.scriptProtect />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getCreateRequiredDirectories" returntype="boolean" output="false">
	<cfreturn variables.instance.createRequiredDirectories />
</cffunction>

<cffunction name="setCreateRequiredDirectories" output="false">
	<cfargument name="createRequiredDirectories" />
	<cfif isBoolean(arguments.createRequiredDirectories)>
		<cfset variables.instance.createRequiredDirectories = arguments.createRequiredDirectories />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getScriptProtect" returntype="boolean" output="false">
	<cfreturn variables.instance.scriptProtect />
</cffunction>

<cffunction name="setEncryptPasswords" output="false">
	<cfargument name="encryptPasswords" />
	<cfif isBoolean(arguments.encryptPasswords)>
		<cfset variables.instance.encryptPasswords = arguments.encryptPasswords />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getEncryptPasswords" returntype="boolean" output="false">
	<cfreturn variables.instance.encryptPasswords />
</cffunction>

<cffunction name="setAutoResetPasswords" output="false">
	<cfargument name="autoresetpasswords" />
	<cfif isBoolean(arguments.autoresetpasswords)>
		<cfset variables.instance.autoresetpasswords = arguments.autoresetpasswords />
	</cfif>
	<cfreturn this>
</cffunction>


<cffunction name="getDataCollection" output="false">
	<cfif isDefined('variables.instance.datacollection') and isBoolean(variables.instance.datacollection)>
		<cfreturn variables.instance.datacollection>
	<cfelse>
		<cfreturn true>
	</cfif>
</cffunction>

<cffunction name="getAutoResetPasswords" returntype="boolean" output="false">
	<cfreturn variables.instance.autoresetpasswords />
</cffunction>

<cffunction name="setEncryptionKey" output="false">
	<cfargument name="encryptionKey" />
	<cfif len(arguments.encryptionKey)>
		<cfset variables.instance.encryptionKey = arguments.encryptionKey />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getEncryptionKey" output="false">
	<cfreturn variables.instance.encryptionKey />
</cffunction>
<cffunction name="setFilemanagerEnabled" output="false">
	<cfargument name="filemanagerEnabled" />
	<cfif len(arguments.filemanagerEnabled)>
		<cfset variables.instance.filemanagerEnabled = arguments.filemanagerEnabled />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getFilemanagerEnabled" output="false">
	<cfreturn variables.instance.filemanagerEnabled />
</cffunction>

<cffunction name="setCKFinderLicenseName" output="false">
	<cfargument name="CKFinderLicenseName" />
	<cfif len(arguments.CKFinderLicenseName)>
		<cfset variables.instance.CKFinderLicenseName = arguments.CKFinderLicenseName />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getCKFinderLicenseName" output="false">
	<cfreturn variables.instance.CKFinderLicenseName />
</cffunction>

<cffunction name="setCKFinderLicenseKey" output="false">
	<cfargument name="CKFinderLicenseKey" />
	<cfif len(arguments.CKFinderLicenseKey)>
		<cfset variables.instance.CKFinderLicenseKey = arguments.CKFinderLicenseKey />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getCKFinderLicenseKey" output="false">
	<cfreturn variables.instance.CKFinderLicenseKey />
</cffunction>

<cffunction name="setMaxArchivedVersions" output="false">
	<cfargument name="maxArchivedVersions" />
	<cfif isNumeric(arguments.maxArchivedVersions)>
		<cfset variables.instance.maxArchivedVersions = arguments.maxArchivedVersions />
	</cfif>
</cffunction>

<cffunction name="setPostBundles" output="false">
	<cfargument name="postBundles" type="string" />
	<cfif isBoolean(arguments.postBundles)>
		<cfset variables.instance.postBundles = arguments.postBundles />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getMaxArchivedVersions" output="false">
	<cfreturn variables.instance.maxArchivedVersions />
	<cfreturn this>
</cffunction>

<cffunction name="setTrackSessionInNewThread" output="false">
	<cfargument name="trackSessionInNewThread" type="string" />
	<cfif isBoolean(arguments.trackSessionInNewThread)>
		<cfset variables.instance.trackSessionInNewThread = arguments.trackSessionInNewThread />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getBCryptLogRounds" output="false">
	<cfreturn variables.instance.BCryptLogRounds />
</cffunction>

<cffunction name="setBCryptLogRounds" output="false">
	<cfargument name="BCryptLogRounds" type="String" />
	<cfif isNumeric(arguments.BCryptLogRounds)>
		<cfset variables.instance.BCryptLogRounds = arguments.BCryptLogRounds />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getBCryptReseedFrequency" output="false">
        <cfreturn variables.instance.BCryptReseedFrequency />
</cffunction>

<cffunction name="setBCryptReseedFrequency" output="false">
        <cfargument name="BCryptReseedFrequency" type="String" />
        <cfif isNumeric(arguments.BCryptReseedFrequency)>
                <cfset variables.instance.BCryptReseedFrequency = arguments.BCryptReseedFrequency />
        </cfif>
        <cfreturn this>
</cffunction>

<cffunction name="setAllowAutoUpdates" output="false">
	<cfargument name="allowAutoUpdates" />
	<cfif isBoolean(arguments.allowAutoUpdates)>
		<cfset variables.instance.allowAutoUpdates = arguments.allowAutoUpdates />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getAllowAutoUpdates" returntype="boolean" output="false">
	<cfreturn variables.instance.allowAutoUpdates />
</cffunction>

<cffunction name="getAllValues" output="false">
	<cfreturn variables.instance />
</cffunction>

<cffunction name="setValue" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="propertyValue" default="" >

	<cfset variables.instance["#arguments.property#"]=arguments.propertyValue />

</cffunction>

<cffunction name="getValue" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="defaultValue">

	<cfif structKeyExists(variables.instance,"#arguments.property#")>
		<cfreturn variables.instance["#arguments.property#"] />
	<cfelseif structKeyExists(arguments,"defaultValue")>
		<cfset variables.instance["#arguments.property#"]=arguments.defaultValue />
		<cfreturn variables.instance["#arguments.property#"] />
	<cfelse>
		<cfreturn "" />
	</cfif>

</cffunction>

<cffunction name="get" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="defaultValue">
	<cfreturn getValue(argumentCollection=arguments)>
</cffunction>

<cffunction name="cleanFilePath" output="false">
<cfargument name="filePath">
	<cfset var last="">
	<cfset var theLen=len(arguments.filePath)>
	<cfset var returnStr=arguments.filePath>

	<cfif theLen>
		<cfset last=right(arguments.filePath,1)>
		<cfif listFind("/,\",last)>
			<cfif theLen gt 1>
				<cfset returnStr=left(returnStr,theLen-1) >
			<cfelse>
				<cfset returnStr="">
			</cfif>
		</cfif>
	</cfif>

	<cfreturn returnStr>

</cffunction>

<cffunction name="addCustomUrlVarDelimiter" output="false">
<cfargument name="delim">
	<cfset variables.instance.customUrlVarDelimiters=listAppend(variables.instance.customUrlVarDelimiters,arguments.delim,"^")>
</cffunction>

<cffunction name="getCustomVarDelimiters" output="false">
	<cfreturn variables.instance.customUrlVarDelimiters>
</cffunction>

<cffunction name="getDbColumnCFType" output="false">
	<cfargument name="column">
	<cfargument name="table">
	<cfset var datatype=variables.dbUtility.columnMetaData(argumentCollection=arguments).datatype>
	<cfset var columnArgs={}>

	<cfswitch expression="#arguments.rs.type_name#">
			<cfcase value="varchar,nvarchar,varchar2">
				<!--- Add MSSQL nvarchar(max)--->
				<cfset columnArgs.datatype="varchar">
				<cfset columnArgs.length=arguments.rs.column_size>
			</cfcase>
			<cfcase value="char">
				<cfset columnArgs.datatype="char">
				<cfset columnArgs.length=arguments.rs.column_size>
			</cfcase>
			<cfcase value="int">
				<cfset columnArgs.datatype="int">
			</cfcase>
			<cfcase value="number">
				<cfif arguments.rs.data_precision eq 3>
					<cfset columnArgs.datatype="tinyint">
				<cfelse>
					<cfset columnArgs.datatype="int">
				</cfif>
			</cfcase>
			<cfcase value="tinyint">
				<cfset columnArgs.datatype="tinyint">
			</cfcase>
			<cfcase value="date,datetime">
				<cfset columnArgs.datatype="datetime">
			</cfcase>
			<cfcase value="ntext,longtext,clob">
				<cfset columnArgs.datatype="longtext">
			</cfcase>
			<cfcase value="text">
				<cfset columnArgs.datatype="text">
			</cfcase>
			<cfcase value="float,binary_float">
				<cfset columnArgs.datatype="float">
			</cfcase>
			<cfcase value="double,decimal,binary_double">
				<cfset columnArgs.datatype="double">
			</cfcase>
		</cfswitch>

</cffunction>

<cffunction name="getReadOnlyQRYAttrs" output="false">
	<cfif not request.muratransaction>
		<cfset structAppend(arguments,
				{datasource=getReadOnlyDatasource(),
				 username=getReadOnlyDbUsername(),
				 password=getReadOnlyDbPassword()},
				 false)>

		<cfif not (len(arguments.username) and len(arguments.password))>
			<cfset structDelete(arguments,'username')>
			<cfset structDelete(arguments,'password')>
		</cfif>
	</cfif>

	<cfif not getValue(property='allowQueryCaching',defaultValue=true)>
		<cfset structDelete(arguments,'cachedWithin')>
	</cfif>

	<cfset structDelete(arguments,'readOnly')>
	<cfreturn arguments>
</cffunction>

<cffunction name="getScheme" output="false">
	<cfargument name="secure" default="#getValue('adminSSL')#">
	<cfreturn (arguments.secure || YesNoFormat(getValue('adminSSL')) || getBean('utility').isHTTPS()) ? 'https' : 'http' />
</cffunction>

<cffunction name="getAdminPath" output="false">
	<cfargument name="useProtocol" default="1">
	<cfargument name="domain" default="#getValue('admindomain')#">

	<cfif len( arguments.domain )>
		<cfif arguments.useProtocol>
			<cfreturn getScheme() & '://' & arguments.domain & getServerPort() & getValue('context') & getValue('adminDir')>
		<cfelse>
			<cfreturn '//' & arguments.domain & getServerPort() & getValue('context') & getValue('adminDir')>
		</cfif>
	<cfelse>
		<cfreturn getValue('context') &  getValue('adminDir')>
	</cfif>
</cffunction>

<cffunction name="getPluginsPath" output="false">
	<cfargument name="useProtocol" default="1">
	<cfargument name="secure" default="#getValue('adminSSL')#">
	<cfif len(variables.instance.pluginsPath)>
		<cfreturn variables.instance.pluginsPath>
	<cfelse>
		<cfif len( getValue('admindomain') )>
			<cfif arguments.useProtocol>
				<cfreturn getScheme(arguments.secure) & '://' & getValue('admindomain') & getServerPort() & getValue('context') & "/plugins">
			<cfelse>
				<cfreturn '//' & getValue('admindomain') & getServerPort() & getValue('context') & "/plugins">
			</cfif>
		<cfelse>
			<cfreturn getValue('context') & "/plugins">
		</cfif>
	</cfif>
</cffunction>

<cffunction name="getCorePath" output="false">
	<cfargument name="useProtocol" default="1">
	<cfargument name="secure" default="#getValue('adminSSL')#">

	<cfif len(variables.instance.corepath)>
		<cfreturn variables.instance.corepath>
	<cfelse>
		<cfif len( getValue('admindomain') )>
			<cfif arguments.useProtocol>
				<cfreturn getScheme(arguments.secure) & '://' & getValue('admindomain') & getServerPort() & getValue('context') & "/core">
			<cfelse>
				<cfreturn '//' & getValue('admindomain') & getServerPort() & getValue('context') & "/core">
			</cfif>
		<cfelse>
			<cfreturn getValue('context') & "/core">
		</cfif>
	</cfif>
</cffunction>

<cffunction name="getRequirementsPath" output="false">
	<cfargument name="useProtocol" default="1">
	<cfargument name="secure" default="#getValue('adminSSL')#">
	<cfreturn getCorePath(argumentCollection=arguments) & "/externals">
</cffunction>

<cffunction name="registerModelDir" output="false">
	<cfargument name="dir">
	<cfargument name="package">
	<cfargument name="siteid" hint="Can be a list" default="">
	<cfargument name="moduleid" default="00000000000000000000000000000000000">
	<cfset registerBeanDir(argumentCollection=arguments)>
</cffunction>

<cffunction name="registerBeanDir" output="false">
	<cfargument name="dir">
	<cfargument name="package">
	<cfargument name="siteid" hint="Can be a list" default="">
	<cfargument name="moduleid" default="00000000000000000000000000000000000">
	<cfargument name="forceSchemaCheck" default="false">

	<cfset var rs="">
	<cfset var expandedDir="">

	<cfif reFindNoCase("^[a-zA-Z]:\\",arguments.dir)>
		<cfset expandedDir=arguments.dir>
	<cfelse>
		<cfset expandedDir=expandPath(arguments.dir)>
	</cfif>

	<cfif directoryExists(expandedDir)>
		<cfif not isDefined('arguments.package') or isDefined('arguments.package') and not len(arguments.package)>
			<cfset arguments.package=replace(replace(right(arguments.dir, len(arguments.dir)-1), "\", "/", "ALL"),"/",".","ALL")>
		</cfif>
		<cfdirectory name="rs" directory="#expandedDir#" action="list" filter="">
		<cfloop query="rs">
			<!--- Registers handlers last so that that all entities defined will be available --->
			<cfif rs.type eq 'dir' and not listFindNoCase('archived,archive,handlers,eventhandlers,event_handlers',rs.name)>
				<cfset registerBeanDir(dir=listAppend(arguments.dir,rs.name,'/'),package=arguments.package & "." & rs.name,siteid=arguments.siteid,moduleid=arguments.moduleid,forceSchemaCheck=arguments.forceSchemaCheck)>
			<cfelseif rs.type neq 'dir' and listLast(rs.name,'.') eq 'cfc'>
				<cfset registerBean(componentPath="#package#.#listFirst(rs.name,'.')#",siteid=arguments.siteid,moduleid=arguments.moduleid,forceSchemaCheck=arguments.forceSchemaCheck)>
			</cfif>
		</cfloop>

		<!--- Registers handlers last so that that all entities defined will be available --->
		<cfloop query="rs">
			<cfif rs.type eq 'dir' and listFindNoCase('handlers,eventhandlers,event_handlers',rs.name)>
				<cfset registerHandlerDir(dir=listAppend(arguments.dir,rs.name,'/'),package=arguments.package & "." & rs.name,siteid=arguments.siteid,moduleid=arguments.moduleid)>
			</cfif>
		</cfloop>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="registerBean" output="false">
	<cfargument name="componentPath">
	<cfargument name="siteid" hint="Can be a list" default="">
	<cfargument name="moduleid" default="00000000000000000000000000000000000">
	<cfargument name="forceSchemaCheck" default="false">

	<cfparam name="request.muraORMchecked" default="#structNew()#">

	<cfset var checkKey='b#hash(arguments.componentPath)#'>
	<cfset var ioc=getServiceFactory()>
	<cfset var checkSchema=isDefined('url.applydbupdates') and not structKeyExists(request.muraORMchecked,'#checkKey#') OR arguments.forceSchemaCheck>
	<cfset var isSingleton=not listFindNoCase(arguments.componentPath,'entities','.') and not listFindNoCase(arguments.componentPath,'beans','.')>
	<cfset var isORM=false>
	<cfset var isPublic=false>
	<cfset var isPublicFound=false>
	<cfset var fieldsFound=false>
	<cfset var fields=''>
	<cfset var beanName=listLast(arguments.componentPath,'.')>
	<cfset var entity="">


	<cfif not structKeyExists(request.muraORMchecked,'#checkKey#')>
		<!--- Catch instantiation errors --->
		<cfset var tracePoint=initTracepoint("Loading bean: #arguments.componentPath#")>
		<cftry>
			<cfset var metadata=getMetaData(createObject('component','#arguments.componentPath#'))>

			<cfset var levelObj=metadata>

			<cfloop condition="structKeyExists(levelObj,'extends')">
				<cfif not isPublicFound and (isdefined('levelObj.public') and isBoolean(levelObj.public) and levelObj.public or isdefined('levelObj.access') && levelObj.access eq 'remote')>
					<cfset isPublic=true>
					<cfset isPublicFound=true>
				</cfif>
				<cfif not fieldsFound and isdefined('levelObj.fields') and len(levelObj.fields)>
					<cfset fields=levelObj.fields>
					<cfset fieldsFound=true>
				</cfif>
				<cfif listFindNoCase('beanORM,beanORMVersioned',listLast(levelObj.fullname,'.'))>
					<cfset isORM=true>
					<cfbreak>
				</cfif>
				<cfset levelObj=levelObj.extends>
			</cfloop>
			<cfset ioc.declareBean(beanName=beanName, dottedPath='#arguments.componentPath#', isSingleton =isSingleton )>
			<cfif isDefined('metadata.entityname') and metadata.entityname neq beanName>
				<cfset ioc.addAlias(metadata.entityname,beanName)>
				<cfset beanName=metadata.entityname>
			</cfif>

			<cfset structDelete(application.objectMappings,beanName)>

			<cfset entity=ioc.getBean(beanName)>

			<cfif isORM>

					<cfset entity.registerAsEntity()>

					<cfif checkSchema>
						<cfset entity.checkSchema()>
					</cfif>

					<cfloop list="#arguments.siteid#" index="local.i">
						<cfif false and  entity.getEntityName() eq 'test'>
							<cfdump var="#siteid#">
							<cfdump var="#isPublic#">
							<cfdump var="#arguments.moduleid#">
							<cfdump var="#entity.getPublicAPI()#">
							<cfdump var="#isORM#">
							<cfdump var="#beanName#">
							<cfabort>
						</cfif>
						<cfset getBean('settingsManager').getSite(local.i).getApi('json','v1').registerEntity(beanName,{
							moduleid=arguments.moduleid,
							public=isPublic,
							fields=fields,
							registered=true,
							beanInstance=entity
						})>
					</cfloop>

					<cfset request.muraORMchecked['#checkkey#']=true>
			</cfif>
			<cfcatch>
				<cfparam name="request.muraDeferredModuleErrors" default="#arrayNew(1)#">
				<cfset ArrayAppend(request.muraDeferredModuleErrors,cfcatch)>
				<cfset writeLog(type="Error", file="exception", text="Error Registering Bean #arguments.componentPath#: #serializeJSON(cfcatch)#")>
				<cfset commitTracepoint(initTracepoint("Error Registering Bean #arguments.componentPath#"))>
				<cfif isBoolean(getValue('debuggingEnabled')) and getValue('debuggingEnabled')>
					<cfrethrow>
				<cfelse>
					<cfreturn this>
				</cfif>
			</cfcatch>
		</cftry>
		<cfset commitTracepoint(tracepoint)>
	<cfelseif getServiceFactory().containsBean(beanName)>
		<cfset var entity=getBean(beanName)>
		<cfif isDefined('entity.isORM') and entity.isOrm()>
			<cfloop list="#arguments.siteid#" index="local.i">
				<cfset getBean('settingsManager').getSite(local.i).getApi('json','v1').registerEntity(
					entityName=beanName,
					config={
					moduleid=arguments.moduleid,
					public=application.objectMappings['#entity.getEntityName()#'].public,
					fields=fields
					},
					beanInstance=entity,
					registered=true
				)>
			</cfloop>
		</cfif>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="registerHandlerDir" output="false">
	<cfargument name="dir">
	<cfargument name="package">
	<cfargument name="siteid" hint="Can be a list">
	<cfargument name="moduleid" default="00000000000000000000000000000000000">
	<cfset var rs="">
	<cfif directoryExists(expandPath(arguments.dir))>
		<cfif not isDefined('arguments.package')>
			<cfset arguments.package=replace(replace(right(arguments.dir, len(arguments.dir)-1), "\", "/", "ALL"),"/",".","ALL")>
		</cfif>
		<cfset var beanName=''>
		<cfset var beanInstance=''>
		<cfset var $=''>
		<cfset var applyGlobal=false>
	
		<cfdirectory name="rs" directory="#expandPath(arguments.dir)#" action="list" filter="">
		<cfloop query="rs">
			<cfif rs.type eq 'dir'>
				<cfif listFindNoCase('handlers,eventHandlers',rs.name)>
					<cfset registerHandlerDir(dir=listAppend(arguments.dir,rs.name,'/'),package=arguments.package & "." & rs.name,siteid=arguments.siteid,moduleid=arguments.moduleid)>
				<cfelse>
					<cfset registerBeanDir(dir=listAppend(arguments.dir,rs.name,'/'),package=arguments.package & "." & rs.name,siteid=arguments.siteid,moduleid=arguments.moduleid)>
				</cfif>
			<cfelseif listLast(rs.name,'.') eq 'cfc'>
				<cfset var tracePoint=initTracepoint("Registering Eventhandler: #package#.#beanName#")>
				<cftry>
					<cfset beanName=listFirst(rs.name,'.')>
					
					<cfif not structKeyExists(application.appHandlerLookUp,'#package#.#beanName#')>
						<cfset beanInstance=createObject('component','#package#.#beanName#').init()>
						<cfset application.appHandlerLookUp['#package#.#beanName#']=beanInstance>
					<cfelse>
						<cfset beanInstance=application.appHandlerLookUp['#package#.#beanName#']>
					</cfif>

					<cfparam name="beanInstance.appliedSites" default="#structNew()#">
					<cfparam name="beanInstance.appliedGlobal" default=false>
					<cfparam name="beanInstance.appliedAppLoad" default=false>

					<cfloop list="#arguments.siteid#" index="local.i">
						<cfif not structKeyExists(beanInstance.appliedSites,'#local.i#')>
							<cfif beanInstance.appliedGlobal>
								<cfset applyGlobal=false>
							<cfelse>
								<cfset applyGlobal=true>
							</cfif>
							<cfset getBean('pluginManager').addEventHandler(component=beanInstance,siteid=local.i,applyglobal=applyGlobal)>
							<cfset beanInstance.appliedGlobal=true>
							<cfif isDefined('beanInstance.onApplicationLoad') and not beanInstance.appliedAppLoad>
								<cfset $=getBean('$').init()>
								<cfset beanInstance.onApplicationLoad($=$,m=$,Mura=$,event=$.event())>
								<cfset beanInstance.appliedAppLoad=true>
							</cfif>
						</cfif>
					</cfloop>
					<cfcatch>
						<cfparam name="request.muraDeferredModuleErrors" default="#arrayNew(1)#">
						<cfset ArrayAppend(request.muraDeferredModuleErrors,cfcatch)>
						<cfset commitTracepoint(initTracepoint("Error Registering Handler #package#.#beanName#"))>
						<cfset writeLog(type="Error", file="exception", text="Error Registering Handler #package#.#beanName#: #serializeJSON(cfcatch)#")>
						<cfif isBoolean(getValue('debuggingEnabled')) and getValue('debuggingEnabled')>
							<cfrethrow>
						</cfif>
					</cfcatch>
				</cftry>
				<cfset commitTracepoint(tracepoint)>
			</cfif>
		</cfloop>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getSiteDir" output="false">
	<cfreturn expandPath(getSiteIncludePath())>
</cffunction>

<cffunction name="getSiteIncludePath" output="false">
	<cfif len(variables.instance.siteDir)>
		<cfreturn '/muraWRM/#variables.instance.siteDir#'>
	<cfelse>
		<cfreturn'/muraWRM'>
	</cfif>
</cffunction>

<cffunction name="getSiteMap" output="false">
	<cfif len(variables.instance.siteDir)>
		<cfreturn 'muraWRM.#variables.instance.siteDir#'>
	<cfelse>
		<cfreturn'muraWRM'>
	</cfif>
</cffunction>

<cffunction name="getSiteAssetPath" output="false">
	<cfif len(variables.instance.siteDir)>
		<cfreturn "/#variables.instance.siteDir#">
	<cfelse>
		<cfreturn "">
	</cfif>
</cffunction>

<cffunction name="getVersionFromFile" output="false">
	<cfif fileExists(expandPath('/muraWRM/box.json'))>
		<cfset var boxConfig=fileRead(expandPath('/muraWRM/box.json'))>

		<cfif isJSON(boxConfig)>
			<cfset boxConfig=deserializeJSON(boxConfig)>
			<cfif isDefined('boxConfig.version')>
				<cfreturn boxConfig.version>
			</cfif>
		</cfif>
	</cfif>

	<cfreturn variables.instance.version>
</cffunction>

<cfscript>

//Make sure queries set with configBean don't act like Masa CMS ORM customDatasoure.
function hasCustomDatasource(){
	return false;
}

function addEventHandler(component){
	if(!isObject(arguments.component) && isStruct(arguments.component)){
		for(var e in arguments.component){
			on(e,component[e]);
		}
	} else {
		getBean('pluginManager').addEventHandler(component=arguments.component,siteid="");
	}
	return this;
}

function on(eventName,fn){
	var handler=new mura.cfobject();

	if(left(arguments.eventName,2)!='on' && left(arguments.eventName,8)!='standard'){
		arguments.eventName="on" & arguments.eventName;
	}

	handler.injectMethod(arguments.eventName,arguments.fn);
	getBean('pluginManager').addEventHandler(component=handler,siteid="");
	return this;
}

function trigger(eventName){
	if(left(arguments.eventName,2)!='on'){
		arguments.eventName="on" & arguments.eventName;
	}
	getBean('pluginManager').announceEvent(
		eventToAnnounce=arguments.eventName,
		currentEventObject=new mura.event()
		);

	return this;
}
</cfscript>

</cfcomponent>
