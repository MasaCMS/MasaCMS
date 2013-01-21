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
<cfset variables.instance=structNew()/>
<cfset variables.instance.mode=""/>
<cfset variables.instance.version="6.0"/> 
<cfset variables.instance.title=""/>
<cfset variables.instance.webroot=""/>
<cfset variables.instance.webrootmap=""/>
<cfset variables.instance.mapdir=""/>
<cfset variables.instance.datasource=""/>
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
<cfset variables.instance.MailServerSMTPPort="110"/>
<cfset variables.instance.MailServerTLS="false"/>
<cfset variables.instance.MailServerSSL="false" />
<cfset variables.instance.useDefaultSMTPServer=0/>
<cfset variables.instance.adminssl=0/>
<cfset variables.instance.logEvents=0/>
<cfset variables.instance.fileDelim="\" />
<cfset variables.instance.dbType="mssql"/>
<cfset variables.instance.dbUsername=""/>
<cfset variables.instance.dbPassword=""/>
<cfset variables.instance.dbtablespace="USERS"/>
<!--- <cfset variables.instance.dbTransactionLevel="read_committed"/> --->
<cfset variables.instance.debuggingEnabled="false"/>
<cfset variables.instance.compiler="adobe"/>
<cfset variables.instance.serverPort=""/>
<cfset variables.instance.fileDir=""/>
<cfset variables.instance.assetDir=""/>
<cfset variables.instance.assetPath="/tasks/sites"/>
<cfset variables.instance.pluginDir=""/>
<cfset variables.instance.productionDatasource=""/>
<cfset variables.instance.productionAssetPath=""/>
<cfset variables.instance.productionWebroot=""/>
<cfset variables.instance.productionFiledir=""/>
<cfset variables.instance.productionAssetdir=""/>
<cfset variables.instance.productionPushMode="full"/>
<cfset variables.instance.fileStore=""/>
<cfset variables.instance.fileStoreAccessInfo=""/>
<cfset variables.instance.tooltips=structNew()/>
<cfset variables.instance.sessionHistory=1 />
<cfset variables.instance.clearSessionHistory=1 />
<cfset variables.instance.extensionManager=""/>
<cfset variables.instance.locale="Server" />
<cfset variables.instance.imageInterpolation="highestQuality" />
<cfset variables.instance.clusterIPList="" />
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
<cfset variables.instance.strictExtendedData=false />
<cfset variables.instance.purgeDrafts=true />
<cfset variables.instance.createRequiredDirectories=true />
<cfset variables.instance.confirmSaveAsDraft=true />
<cfset variables.instance.notifyWithVersionLink=true />
<cfset variables.instance.scriptProtect=true />
<cfset variables.instance.appreloadKey=application.appreloadKey />
<cfset variables.instance.loginStrikes=4 />
<cfset variables.instance.encryptPasswords=true />
<cfset variables.instance.sessionTimeout=180 />
<cfset variables.instance.tempDir=getTempDirectory() />
<cfset variables.instance.autoresetpasswords=true />
<cfset variables.instance.encryptionKey=hash(getCurrentTemplatePath()) />
<cfset variables.instance.uselegacysessions=true />
<cfset variables.instance.customUrlVarDelimiters="_">
<cfset variables.instance.strongPasswordRegex="(?=^.{7,15}$)(?=.*\d)(?![.\n])(?=.*[a-zA-Z]).*$">
<cfset variables.instance.duplicateTransients=false>
<cfset variables.instance.maxArchivedVersions=0 />
<cfset variables.instance.postBundles=true />
<cfset variables.instance.applyDBUpdates=true />
<cfset variables.instance.broadcastCachePurges=true />
<cfset variables.instance.broadcastAppreloads=true />
<cfset variables.instance.broadcastWithProxy=true />
<cfset variables.instance.readOnlyDatasource="" />
<cfset variables.instance.readOnlyDbUsername="" />
<cfset variables.instance.readOnlyDbPassword="" />
<cfset variables.instance.MYSQLEngine="InnoDB" />
<cfset variables.instance.autoDiscoverPlugins=false />
<cfset variables.instance.trackSessionInNewThread=1 />
<cfset variables.instance.cfStaticJavaLoaderScope="application">
<cfset variables.instance.URLTitleDelim="-">
<cfset variables.instance.BCryptLogRounds=10>
<cfset variables.instance.maxSourceImageWIdth=3000>
<cfset variables.dbUtility="">
<cfset variables.instance.allowAutoUpdates=1>
<cfset variables.instance.CFFPConfigFilename="cffp.ini.cfm">

<cffunction name="OnMissingMethod" access="public" returntype="any" output="false" hint="Handles missing method exceptions.">
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
		<cfreturn setValue(argumentCollection=arguments.MissingMethodArguments)>
	<cfelse>
		<cfthrow message="The method '#arguments.MissingMethodName#' is not defined">
	</cfif>

<cfelse>
	<cfreturn "">
</cfif>

</cffunction>

<cffunction name="set" returntype="any" output="true" access="public">
	<cfargument name="config" type="struct"> 	
	<cfset var prop="">
	<cfset setWebRoot(arguments.config.webroot)/>
	<cfset setContext(arguments.config.context)/>
	<cfset setAssetPath(arguments.config.assetPath)/>
	<cfset setFileDelim()/>
	<!--- setFileDir must be after setWebRoot and setFileDelim and setAssetPath--->
	<cfset setFileDir(arguments.config.fileDir)/>
	<cfset setDefaultLocale(arguments.config.locale)>
	<cfset setServerPort(arguments.config.port)>
	
	<cfloop collection="#arguments.config#" item="prop">
		<cfif not listFindNoCase("webroot,filedir,plugindir,locale,port,assetpath,context",prop)>
			<cfif structKeyExists(this,"set#prop#")>
				<cfset evaluate("set#prop#(arguments.config.#prop#)")>
			<cfelse>
				<cfset setValue(prop,arguments.config[prop])>
			</cfif>
		</cfif>
	</cfloop>
	
	<cfif structKeyExists(arguments.config,"assetDir")>
		<cfset setAssetDir(arguments.config.assetDir)/>
	<cfelse>
		<cfset setAssetDir(arguments.config.fileDir)/>
	</cfif>
	
	<cfif structKeyExists(arguments.config,"pluginDir") and len(trim(arguments.config.pluginDir))>
		<cfset setPluginDir(arguments.config.pluginDir)/>
	<cfelse>
		<cfset setPluginDir("#getWebRoot()##getFileDelim()#plugins")/>
	</cfif>
	
	<cfswitch expression="#server.coldfusion.productName#">
	<cfcase value="Railo">
		<cfset setCompiler("Railo")/>	
	</cfcase>
	<cfcase value="Open BlueDragon">
		<cfset setCompiler("Open BlueDragon")/>	
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

	<cfset variables.dbUtility=getBean("dbUtility")>

	<cfreturn this />
</cffunction>

<cffunction name="getMode" returntype="any" access="public" output="false">
	<cfreturn variables.instance.mode />
</cffunction>

<cffunction name="setMode" access="public" output="false">
	<cfargument name="Mode" type="String" />
	<cfset variables.instance.Mode = arguments.Mode />
	<cfreturn this>
</cffunction>

<cffunction name="getVersion" returntype="any" access="public" output="false">
	<cfreturn variables.instance.version />
</cffunction>

<cffunction name="setVersion" access="public" output="false">
	<cfargument name="Version" type="String" />
	<cfset variables.instance.version = arguments.Version />
	<cfreturn this>
</cffunction>

<cffunction name="getTitle" returntype="any" access="public" output="false">
	<cfreturn variables.instance.title />
</cffunction>

<cffunction name="setTitle" access="public" output="false">
	<cfargument name="Title" type="String" />
	<cfset variables.instance.Title = arguments.Title />
	<cfreturn this>
</cffunction>

<cffunction name="getWebRoot" returntype="any" access="public" output="false">
	<cfreturn variables.instance.webroot />
</cffunction>

<cffunction name="setWebRoot" access="public" output="false">
	<cfargument name="webroot" type="String" />
	<cfset variables.instance.webroot = cleanFilePath(arguments.webroot) />
	<cfreturn this>
</cffunction>

<cffunction name="getWebRootMap" returntype="any" access="public" output="false">
	<cfreturn variables.instance.webrootmap />
</cffunction>

<cffunction name="setWebRootMap" access="public" output="false">
	<cfargument name="webrootmap" type="String" />
	<cfset variables.instance.webrootmap = arguments.webrootmap />
	<cfreturn this>
</cffunction>

<cffunction name="getMapDir" returntype="any" access="public" output="false">
	<cfreturn variables.instance.mapDir />
</cffunction>

<cffunction name="setMapDir" access="public" output="false">
	<cfargument name="MapDir" type="String" />
	<cfset variables.instance.mapDir = arguments.MapDir />
	<cfreturn this>
</cffunction>

<cffunction name="getDatasource" returntype="any" access="public" output="false">
	<cfargument name="mode" default="" />
	<cfreturn variables.instance.datasource />
</cffunction>

<cffunction name="setDatasource" access="public" output="false">
	<cfargument name="Datasource" type="String" />
	<cfset variables.instance.Datasource = arguments.Datasource />
	<cfreturn this>
</cffunction>

<cffunction name="getReadOnlyDatasource" returntype="any" access="public" output="false">
	<cfargument name="mode" default="" />
	<cfreturn variables.instance.readOnlyDatasource />
</cffunction>

<cffunction name="setReadOnlyDatasource" access="public" output="false">
	<cfargument name="readOnlyDatasource" type="String" />
	<cfset variables.instance.readOnlyDatasource = arguments.readOnlyDatasource />
	<cfreturn this>
</cffunction>

<cffunction name="getReadOnlyDbPassword" returntype="any" access="public" output="false">
	<cfreturn variables.instance.readOnlyDbPassword />
</cffunction>

<cffunction name="setReadOnlyDbPassword" access="public" output="false">
	<cfargument name="readOnlyDbPassword" type="String" />
	<cfset variables.instance.readOnlyDbPassword = arguments.readOnlyDbPassword />
	<cfreturn this>
</cffunction>

<cffunction name="getReadOnlyDbUsername" returntype="any" access="public" output="false">
	<cfreturn variables.instance.readOnlyDbUsername />
</cffunction>

<cffunction name="setReadOnlyDbUsername" access="public" output="false">
	<cfargument name="readOnlyDbUsername" type="String" />
	<cfset variables.instance.readOnlyDbUsername = arguments.readOnlyDbUsername />
	<cfreturn this>
</cffunction>

<cffunction name="getContext" returntype="any" access="public" output="false">
	<cfreturn variables.instance.context />
</cffunction>

<cffunction name="setContext" access="public" output="false">
	<cfargument name="Context" type="String" />
	<cfset arguments.Context=cleanFilePath(arguments.Context) />
	<cfif getContextRoot() NEQ "/">
		<cfset arguments.Context = getContextRoot() & arguments.Context />
	</cfif>
	<cfset variables.instance.Context = arguments.Context />
	<cfreturn this>
</cffunction>

<cffunction name="getStub" returntype="any" access="public" output="false">
	<cfreturn variables.instance.stub />
</cffunction>

<cffunction name="setStub" access="public" output="false">
	<cfargument name="Stub" type="String" />
	<cfset variables.instance.stub = cleanFilePath(arguments.Stub) />
	<cfreturn this>
</cffunction>

<cffunction name="getAdminDomain" returntype="any" access="public" output="false">
	<cfreturn variables.instance.adminDomain />
</cffunction>

<cffunction name="setAdminDomain" access="public" output="false">
	<cfargument name="AdminDomain" type="String" />
	<cfset variables.instance.AdminDomain = arguments.AdminDomain />
	<cfreturn this>
</cffunction>

<cffunction name="getIndexFile" returntype="any" access="public" output="false">
	<cfreturn variables.instance.indexFile />
</cffunction>

<cffunction name="setIndexFile" access="public" output="false">
	<cfargument name="IndexFile" type="String" />
	<cfset variables.instance.IndexFile = arguments.IndexFile />
	<cfreturn this>
</cffunction>

<cffunction name="getAdminEmail" returntype="any" access="public" output="false">
	<cfreturn variables.instance.adminEmail />
</cffunction>

<cffunction name="setAdminEmail" access="public" output="false">
	<cfargument name="AdminEmail" type="String" />
	<cfset variables.instance.adminEmail = arguments.AdminEmail />
	<cfreturn this>
</cffunction>

<cffunction name="setSendFromMailServerUsername" access="public" output="false">
	<cfargument name="sendFromMailServerUsername"/>
	<cfif isBoolean(arguments.sendFromMailServerUsername)>
		<cfset variables.instance.sendFromMailServerUsername = arguments.sendFromMailServerUsername />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getSendFromMailServerUsername" returntype="any" access="public" output="false">
	<cfreturn variables.instance.SendFromMailServerUsername />
</cffunction>

<cffunction name="setMailServerUsernameEmail" returntype="any" access="public" output="false">
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

<cffunction name="getMailServerUsernameEmail" returntype="any" access="public" output="false">
		<cfreturn variables.instance.mailServerUsernameEmail />
</cffunction>

<cffunction name="setMailServerUsername" access="public" output="false">
	<cfargument name="MailServerUsername" type="String" />
	<cfset setMailServerUsernameEmail(arguments.MailServerUsername) />
	<cfset variables.instance.mailServerUsername = arguments.MailServerUsername />
	<cfreturn this>
</cffunction>

<cffunction name="getMailServerUsername" returntype="any" access="public" output="false">
	<cfargument name="forLogin" default="false" required="true">
	<cfif not arguments.forLogin or len(getMailServerPassword())>
		<cfreturn variables.instance.mailServerUsername />
	<cfelse>
		<cfreturn ""/>
	</cfif>
</cffunction>

<cffunction name="getMailServerPassword" returntype="any" access="public" output="false">
	<cfreturn variables.instance.mailServerPassword />
</cffunction>

<cffunction name="setMailServerPassword" access="public" output="false">
	<cfargument name="MailServerPassword" type="String" />
	<cfset variables.instance.mailServerPassword = arguments.MailServerPassword />
	<cfreturn this>
</cffunction>

<cffunction name="getMailServerIP" returntype="any" access="public" output="false">
	<cfreturn variables.instance.mailServerIP />
</cffunction>

<cffunction name="setMailServerIP" access="public" output="false">
	<cfargument name="MailServerIP" type="String" />
	<cfset variables.instance.MailServerIP = arguments.MailServerIP />
	<cfreturn this>
</cffunction>

<cffunction name="getAdminSSL" returntype="Numeric" access="public" output="false">
	<cfreturn variables.instance.adminSSL />
</cffunction>

<cffunction name="setAdminSSL" access="public" output="false">
	<cfargument name="AdminSSL" type="Numeric" />
	<cfset variables.instance.adminSSL = arguments.AdminSSL />
	<cfreturn this>
</cffunction>

<cffunction name="getLogEvents" returntype="Numeric" access="public" output="false">
	<cfreturn variables.instance.logEvents />
</cffunction>

<cffunction name="setLogEvents" access="public" output="false">
	<cfargument name="logEvents" type="Numeric" />
	<cfset variables.instance.logEvents = arguments.logEvents />
	<cfreturn this>
</cffunction>

<cffunction name="getFileDelim" returntype="any" access="public" output="false">
	<cfreturn variables.instance.fileDelim />
</cffunction>

<cffunction name="setFileDelim" access="public" output="false">
	
	 <cfset var fileObj = createObject("java", "java.io.File")/>
     <cfset variables.instance.fileDelim = fileObj.separator />
      <cfreturn this>
</cffunction>

<cffunction name="getDbType" returntype="any" access="public" output="false">
	<cfreturn variables.instance.dbType />
</cffunction>

<cffunction name="setDbType" access="public" output="false">
	<cfargument name="dbType" type="string" />
	<cfif left(arguments.dbType,5) eq "mysql" or arguments.dbType eq "h2">
		<cfset variables.instance.dbType = "mysql" />
	<cfelse>
		<cfset variables.instance.dbType = arguments.dbType />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getDbPassword" returntype="any" access="public" output="false">
	<cfargument name="mode" default="" />
	<cfreturn variables.instance.dbPassword />
</cffunction>

<cffunction name="setDbPassword" access="public" output="false">
	<cfargument name="dbPassword" type="string" />
	<cfset variables.instance.dbPassword = arguments.dbPassword />
	<cfreturn this>
</cffunction>

<cffunction name="getDbUsername" returntype="any" access="public" output="false">
	<cfargument name="mode" default="" />
	<cfreturn variables.instance.dbUsername />
</cffunction>

<cffunction name="setDbUsername" access="public" output="false">
	<cfargument name="dbUsername" type="string" />
	<cfset variables.instance.dbUsername = arguments.dbUsername />
	<cfreturn this>
</cffunction>

<cffunction name="getDbTablespace" returntype="any" access="public" output="false">
	<cfreturn variables.instance.dbTablespace />
</cffunction>

<cffunction name="setDbTablespace" access="public" output="false">
	<cfargument name="dbTablespace" type="string" />
	<cfset arguments.dbTablespace=trim(ucase(arguments.dbTablespace))>
	<cfif len(arguments.dbTablespace)>
		<cfset variables.instance.dbTablespace = arguments.dbTablespace/>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getDebuggingEnabled" returntype="any" access="public" output="false">
	<cfreturn variables.instance.debuggingEnabled />
</cffunction>

<cffunction name="setDebuggingEnabled" access="public" output="false">
	<cfargument name="debuggingEnabled" type="string" />
	<cfset variables.instance.debuggingEnabled = arguments.debuggingEnabled />
	<cfreturn this>
</cffunction>

<cffunction name="getCompiler" returntype="any" access="public" output="false">
	<cfreturn variables.instance.compiler />
</cffunction>

<cffunction name="setCompiler" access="public" output="false">
	<cfargument name="compiler" type="string" />
	<cfset variables.instance.compiler = arguments.compiler />
	<cfreturn this>
</cffunction>

<cffunction name="getServerPort" returntype="any" access="public" output="false">
	<cfreturn variables.instance.serverPort />
</cffunction>

<cffunction name="setServerPort" access="public" output="false">
	<cfargument name="ServerPort" type="string" />
	<cfif arguments.serverPort neq "80" and len(trim(arguments.serverPort))>
		<cfset variables.instance.ServerPort = ":#arguments.ServerPort#" />
	<cfelse>
		<cfset variables.instance.ServerPort = "" />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getFileDir" returntype="any" access="public" output="false">
	<cfreturn variables.instance.fileDir />
</cffunction>

<cffunction name="setFileDir" access="public" output="false">
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
			<cfset variables.instance.fileDir = variables.instance.webroot  />
		</cfif>
	</cfif>
	
	<cfreturn this>
</cffunction>

<cffunction name="getAssetDir" returntype="any" access="public" output="false">
	<cfreturn variables.instance.assetDir />
</cffunction>

<cffunction name="setAssetDir" access="public" output="false">
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
			<cfset variables.instance.assetDir = variables.instance.webroot  />
		</cfif>
	</cfif>
	
	<cfreturn this>
</cffunction>

<cffunction name="getAssetPath" returntype="any" access="public" output="false">
	<cfreturn variables.instance.assetPath />
</cffunction>

<cffunction name="setAssetPath" access="public" output="false">
	<cfargument name="assetPath" type="String" default="" />
	<cfset variables.instance.assetPath =cleanFilePath(arguments.assetPath) />
	<cfreturn this>
</cffunction>

<cffunction name="getProductionDatasource" returntype="any" access="public" output="false">
	<cfreturn variables.instance.productionDatasource />
</cffunction>

<cffunction name="setProductionDatasource" access="public" output="false">
	<cfargument name="ProductionDatasource" type="String" />
	<cfset variables.instance.productionDatasource = arguments.ProductionDatasource />
	<cfreturn this>
</cffunction>

<cffunction name="getProductionAssetPath" returntype="any" access="public" output="false">
	<cfreturn variables.instance.productionAssetPath />
</cffunction>

<cffunction name="setProductionAssetPath" access="public" output="false">
	<cfargument name="ProductionAssetPath" type="String" />
	<cfset variables.instance.ProductionAssetPath=cleanFilePath(arguments.ProductionAssetPath) />
	<cfreturn this>
</cffunction>

<cffunction name="getProductionWebroot" returntype="any" access="public" output="false">
	<cfreturn variables.instance.productionWebroot />
</cffunction>

<cffunction name="setProductionWebroot" access="public" output="false">
	<cfargument name="ProductionWebroot" type="String" />
	<cfset variables.instance.ProductionWebroot=cleanFilePath(arguments.ProductionWebroot) />
	<cfreturn this>
</cffunction>

<cffunction name="getProductionFiledir" returntype="any" access="public" output="false">
	<cfreturn variables.instance.productionFiledir />
</cffunction>

<cffunction name="setProductionFiledir" access="public" output="false">
	<cfargument name="ProductionFiledir" type="String" />
	<cfset variables.instance.productionFiledir=cleanFilePath(arguments.ProductionFiledir)/>
	<cfreturn this>
</cffunction>

<cffunction name="getProductionAssetdir" returntype="any" access="public" output="false">
	<cfreturn variables.instance.productionAssetdir />
</cffunction>

<cffunction name="setProductionAssetdir" access="public" output="false">
	<cfargument name="ProductionAssetdir" type="String" />
	<cfset variables.instance.productionAssetdir=cleanFilePath(arguments.ProductionAssetdir)/>
	<cfreturn this>
</cffunction>

<cffunction name="getProductionPushMode" returntype="any" access="public" output="false">
	<cfreturn variables.instance.ProductionPushMode />
</cffunction>

<cffunction name="setProductionPushMode" access="public" output="false">
	<cfargument name="productionPushMode" type="String" />
	<cfset variables.instance.productionPushMode=arguments.productionPushMode/>
	<cfreturn this>
</cffunction>

<cffunction name="getFileStore" returntype="any" access="public" output="false">
	<cfreturn variables.instance.fileStore />
</cffunction>

<cffunction name="setFileStore" access="public" output="false">
	<cfargument name="fileStore" type="String" />
	<cfset variables.instance.fileStore = arguments.fileStore />
	<cfreturn this>
</cffunction>

<cffunction name="setFileStoreAccessInfo" access="public" output="false">
	<cfargument name="fileStoreAccessInfo" type="String" />
	<cfset variables.instance.fileStoreAccessInfo = arguments.fileStoreAccessInfo />
	<cfreturn this>
</cffunction>

<cffunction name="getFileStoreAccessInfo" returntype="any" access="public" output="false">
	<cfreturn variables.instance.fileStoreAccessInfo />
</cffunction>

<cffunction name="getSessionHistory" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.sessionHistory />
</cffunction>

<cffunction name="setSessionHistory" access="public" output="false">
	<cfargument name="SessionHistory" type="String" />
	<cfif isNumeric(arguments.SessionHistory)>
		<cfset variables.instance.sessionHistory = arguments.SessionHistory />
	</cfif>
	<cfreturn this>
</cffunction>

<!---
<cffunction name="createGUID" access="public" output="false" returntype="any">
   <cfreturn insert("-", CreateUUID(), 23) />
</cffunction>
--->

<cffunction name="loadClassExtensionManager" returntype="any" access="public" output="false">
	<cfset variables.instance.extensionManager=createObject("component","mura.extend.extendManager").init(this) />
	<cfreturn this>
</cffunction>

<cffunction name="applyDbUpdates" returntype="any" access="public" output="false">

	<cfset var rsCheck ="" />
	<cfset var rsSubCheck ="" />
	<cfset var rsUpdates ="" />
	<cfset var dbUtility=getBean("dbUtility") />
	<cfset var i ="" />
	<cfset var MSSQLversion=0 />
	<cfset var MSSQLlob="[nvarchar](max) NULL" />

	<cfif variables.instance.dbtype eq 'MSSQL'>

		<cftry>
			<cfquery name="MSSQLversion"  datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
				SELECT CONVERT(varchar(100), SERVERPROPERTY('ProductVersion')) as version
			</cfquery>
			<cfset MSSQLversion=listFirst(MSSQLversion.version,".")>
			<cfcatch></cfcatch>
		</cftry>

		<cfif not MSSQLversion>
			<cfquery name="MSSQLversion" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
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
	</cfif>
	
	<cfdirectory action="list" directory="#getDirectoryFromPath(getCurrentTemplatePath())#dbUpdates" name="rsUpdates" filter="*.cfm" sort="name asc">

	<cfloop query="rsUpdates">
		<cfinclude template="dbUpdates/#rsUpdates.name#">
	</cfloop>
	<cfreturn this>
</cffunction>

<cffunction name="dbTableColumns" output="false" hint="deprecated, use dbUtility">
	<cfargument name="table">
	<cfset var rs ="">
	
	<cfswitch expression="#getDbType()#">
			<cfcase value="oracle">
				<cfquery
				name="rs" 
				datasource="#getDatasource()#"
				username="#getDbUsername()#"
				password="#getDbPassword()#">
					SELECT column_name, 
					data_length column_size, 
					data_type type_name, 
					data_default column_default_value,
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
			<cfquery
				name="rs" 
				datasource="#getDatasource()#"
				username="#getDbUsername()#"
				password="#getDbPassword()#">
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
				<cfdbinfo 
				name="rs"
				datasource="#getDatasource()#"
				username="#getDbUsername()#"
				password="#getDbPassword()#"
				table="#table#"
				type="columns">	
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
		table="#arguments.table#"
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
		table="#arguments.table#"
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
	 
	<cfdbinfo 
		name="rsCheck"
		datasource="#getDatasource()#"
		username="#getDbUsername()#"
		password="#getDbPassword()#"
		table="#arguments.table#"
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
	<cfcase value="oracle">
		<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		ALTER TABLE #arguments.table# DROP COLUMN #arguments.column#
		</cfquery>
	</cfcase>
	</cfswitch>	
	</cfif>
</cffunction>
<cffunction name="getClassExtensionManager" returntype="any" access="public" output="false">
	
	<cfif not isObject(variables.instance.extensionManager)>
		<cfset loadClassExtensionManager()/>
	</cfif>
	<cfreturn variables.instance.extensionManager />
</cffunction>

<cffunction name="setDefaultLocale" access="public" output="false">
	<cfargument name="locale" type="String" />
	
	<cfif len(arguments.locale)>
		<cfset variables.instance.locale = arguments.locale />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getDefaultLocale" returntype="any" access="public" output="false">
	<cfreturn variables.instance.locale />
</cffunction>

<cffunction name="setUseDefaultSMTPServer" access="public" output="false">
	<cfargument name="UseDefaultSMTPServer"  />
	
	<cfif isNumeric(arguments.UseDefaultSMTPServer)>
		<cfset variables.instance.UseDefaultSMTPServer = arguments.UseDefaultSMTPServer />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getUseDefaultSMTPServer" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.UseDefaultSMTPServer />
</cffunction>

<cffunction name="setAdminDir" access="public" output="false">
	<cfargument name="adminDir" type="String" />
	
	<cfif len(arguments.adminDir)>
		<cfset variables.instance.adminDir = arguments.adminDir />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getAdminDir" returntype="any" access="public" output="false">
	<cfreturn variables.instance.adminDir />
</cffunction>

<cffunction name="setImageInterpolation" access="public" output="false">
	<cfargument name="imageInterpolation" type="String" />
	
	<cfif len(arguments.imageInterpolation)>
		<cfset variables.instance.imageInterpolation = arguments.imageInterpolation />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getImageInterpolation" returntype="any" access="public" output="false">
	<cfreturn variables.instance.imageInterpolation />
</cffunction>

<cffunction name="getMailServerSMTPPort" returntype="any" access="public" output="false">
	<cfreturn variables.instance.mailServerSMTPPort />
</cffunction>

<cffunction name="setMailServerSMTPPort" access="public" output="false">
	<cfargument name="mailServerPort" type="String" />
	<cfif isNumeric(arguments.mailServerPort)>
	<cfset variables.instance.mailServerSMTPPort = arguments.mailServerPort />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getMailServerPOPPort" returntype="any" access="public" output="false">
	<cfreturn variables.instance.mailServerPOPPort />
</cffunction>

<cffunction name="setMailServerPOPPort" access="public" output="false">
	<cfargument name="mailServerPort" type="String" />
	<cfif isNumeric(arguments.mailServerPort)>
	<cfset variables.instance.mailServerPOPPort = arguments.mailServerPort />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getMailServerTLS" returntype="any" access="public" output="false">
	<cfreturn variables.instance.mailServerTLS />
</cffunction>

<cffunction name="setMailServerTLS" access="public" output="false">
	<cfargument name="mailServerTLS" type="String" />
	<cfif isBoolean(arguments.mailServerTLS)>
	<cfset variables.instance.mailServerTLS = arguments.mailServerTLS />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getMailServerSSL" returntype="any" access="public" output="false">
	<cfreturn variables.instance.mailServerSSL />
</cffunction>

<cffunction name="setMailServerSSL" access="public" output="false">
	<cfargument name="mailServerSSL" type="String" />
	<cfif isBoolean(arguments.mailServerSSL)>
	<cfset variables.instance.mailServerSSL = arguments.mailServerSSL />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getEnableMuraTag" returntype="any" access="public" output="false">
	<cfreturn variables.instance.enableMuraTag />
</cffunction>

<cffunction name="setEnableMuraTag" access="public" output="false">
	<cfargument name="enableMuraTag" type="String" />
	<cfif isBoolean(arguments.enableMuraTag)>
	<cfset variables.instance.enableMuraTag = arguments.enableMuraTag />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getDashboard" returntype="any" access="public" output="false">
	<cfset var i="">
	<cfset var currentUser=getCurrentUser()>
	<cfif isBoolean(variables.instance.dashboard)>
		<cfreturn variables.instance.dashboard />
	<cfelseif isdefined("session.mura") and len(session.mura.siteID) and len(variables.instance.dashboard)>
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

<cffunction name="setDashboard" access="public" output="false">
	<cfargument name="dashboard" type="String" />
	<cfset variables.instance.dashboard = arguments.dashboard />
	<cfreturn this>
</cffunction>

<cffunction name="getClusterIPList" returntype="any" access="public" output="false">
	<cfreturn variables.instance.clusterIPList />
</cffunction>

<cffunction name="setClusterIPList" access="public" output="false">
	<cfargument name="clusterIPList" type="String" />
	<cfset variables.instance.clusterIPList = trim(arguments.clusterIPList) />
	<cfreturn this>
</cffunction>

<cffunction name="getAppreloadKey" returntype="any" access="public" output="false">
	<cfreturn variables.instance.appreloadKey />
</cffunction>

<cffunction name="setAppreloadKey" access="public" output="false">
	<cfargument name="AppreloadKey" type="String" />
	<cfset variables.instance.appreloadKey = arguments.appreloadKey />
	<cfreturn this>
</cffunction>

<cffunction name="getSortPermission" returntype="any" access="public" output="false">
	<cfreturn variables.instance.sortPermission />
</cffunction>

<cffunction name="setSortPermission" access="public" output="false">
	<cfargument name="sortPermission" type="String" />
	<cfset variables.instance.sortPermission = arguments.sortPermission />
	<cfreturn this>
</cffunction>

<cffunction name="getProxyUser" returntype="any" access="public" output="false">
	<cfreturn variables.instance.proxyUser />
</cffunction>

<cffunction name="setProxyUser" access="public" output="false">
	<cfargument name="proxyUser" type="String" />
	<cfset variables.instance.proxyUser = arguments.proxyUser />
	<cfreturn this>
</cffunction>

<cffunction name="getProxyPassword" returntype="any" access="public" output="false">
	<cfreturn variables.instance.proxyPassword />
</cffunction>

<cffunction name="setProxyPassword" access="public" output="false">
	<cfargument name="proxyPassword" type="String" />
	<cfset variables.instance.proxyPassword = arguments.proxyPassword />
	<cfreturn this>
</cffunction>

<cffunction name="getProxyServer" returntype="any" access="public" output="false">
	<cfreturn variables.instance.proxyServer />
</cffunction>

<cffunction name="setProxyServer" access="public" output="false">
	<cfargument name="proxyServer" type="String" />
	<cfset variables.instance.proxyServer = arguments.proxyServer />
	<cfreturn this>
</cffunction>

<cffunction name="getProxyPort" returntype="any" access="public" output="false">
	<cfreturn variables.instance.proxyPort />
</cffunction>

<cffunction name="setProxyPort" access="public" output="false">
	<cfargument name="proxyPort" type="String" />
	<cfif isnumeric(arguments.proxyPort)>
	<cfset variables.instance.proxyPort = arguments.proxyPort />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMaxSourceImageWidth" access="public" output="false">
	<cfargument name="maxSourceImageWidth" type="String" />
	<cfif isnumeric(arguments.maxSourceImageWidth)>
	<cfset variables.instance.maxSourceImageWidth = arguments.maxSourceImageWidth />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setTempDir" returntype="any" access="public" output="false">
	<cfargument name="tempDir" />
	<cfif len(arguments.tempDir) and directoryExists(arguments.tempDir)>
		<cfset variables.instance.tempDir = arguments.tempDir />
		<cfif not listFind("/,\",right(variables.instance.tempDir,1))>
			<cfset variables.instance.tempDir = variables.instance.tempDir & getFileDelim() />
		</cfif>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getTempDir" returntype="any" access="public" output="false">
	<cfreturn variables.instance.tempDir />
</cffunction>

<cffunction name="setPluginDir" access="public" output="false">
	<cfargument name="pluginDir" type="String" />
	<cfset arguments.pluginDir=cleanFilePath(arguments.pluginDir)>
	<cfif len(arguments.pluginDir)>
		<cfset variables.instance.pluginDir = arguments.pluginDir />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getPluginDir" returntype="any" access="public" output="false">
	<cfreturn variables.instance.pluginDir />
</cffunction>

<cffunction name="setSharableRemoteSessions" access="public" output="false">
	<cfargument name="sharableRemoteSessions" />
	<cfif isBoolean(arguments.sharableRemoteSessions)>
		<cfset variables.instance.sharableRemoteSessions = arguments.sharableRemoteSessions />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getSharableRemoteSessions" returntype="boolean" access="public" output="false">
	<cfreturn variables.instance.sharableRemoteSessions />
</cffunction>

<cffunction name="setSiteIDInURLS" access="public" output="false">
	<cfargument name="siteIDInURLS" />
	<cfif isBoolean(arguments.siteIDInURLS)>
		<cfset variables.instance.siteIDInURLS = arguments.siteIDInURLS />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getSiteIDInURLS" returntype="boolean" access="public" output="false">
	<cfreturn variables.instance.siteIDInURLS />
</cffunction>

<cffunction name="setIndexFileInURLS" access="public" output="false">
	<cfargument name="indexFileInURLS" />
	<cfif isBoolean(arguments.indexFileInURLS)>
		<cfset variables.instance.indexFileInURLS = arguments.indexFileInURLS />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getIndexFileInURLS" returntype="boolean" access="public" output="false">
	<cfreturn variables.instance.indexFileInURLS />
</cffunction>

<cffunction name="setStrictExtendedData" access="public" output="false">
	<cfargument name="strictExtendedData" />
	<cfif isBoolean(arguments.strictExtendedData)>
		<cfset variables.instance.strictExtendedData = arguments.strictExtendedData />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getStrictExtendedData" returntype="boolean" access="public" output="false">
	<cfreturn variables.instance.strictExtendedData />
</cffunction>

<cffunction name="setLoginStrikes" access="public" output="false">
	<cfargument name="loginStrikes" />
	<cfif isNumeric(arguments.loginStrikes)>
		<cfset variables.instance.loginStrikes = arguments.loginStrikes />
	</cfif>
</cffunction>

<cffunction name="getLoginStrikes" returntype="any" access="public" output="false">
	<cfreturn variables.instance.loginStrikes />
	<cfreturn this>
</cffunction>

<cffunction name="setPurgeDrafts" access="public" output="false">
	<cfargument name="purgeDrafts" />
	<cfif isBoolean(arguments.purgeDrafts)>
		<cfset variables.instance.purgeDrafts = arguments.purgeDrafts />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getPurgeDrafts" returntype="boolean" access="public" output="false">
	<cfreturn variables.instance.purgeDrafts />
</cffunction>

<cffunction name="setConfirmSaveAsDraft" access="public" output="false">
	<cfargument name="ConfirmSaveAsDraft" />
	<cfif isBoolean(arguments.confirmSaveAsDraft)>
		<cfset variables.instance.confirmSaveAsDraft = arguments.confirmSaveAsDraft />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getConfirmSaveAsDraft" returntype="boolean" access="public" output="false">
	<cfreturn variables.instance.confirmSaveAsDraft />
</cffunction>

<cffunction name="getNotifyWithVersionLink" returntype="boolean" access="public" output="false">
	<cfreturn variables.instance.notifyWithVersionLink />
</cffunction>

<cffunction name="setNotifyWithVersionLink" access="public" output="false">
	<cfargument name="notifyWithVersionLink" />
	<cfif isBoolean(arguments.notifyWithVersionLink)>
		<cfset variables.instance.notifyWithVersionLink = arguments.notifyWithVersionLink />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setScriptProtect" access="public" output="false">
	<cfargument name="scriptProtect" />
	<cfif isBoolean(arguments.scriptProtect)>
		<cfset variables.instance.scriptProtect = arguments.scriptProtect />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getCreateRequiredDirectories" returntype="boolean" access="public" output="false">
	<cfreturn variables.instance.createRequiredDirectories />
</cffunction>

<cffunction name="setCreateRequiredDirectories" access="public" output="false">
	<cfargument name="createRequiredDirectories" />
	<cfif isBoolean(arguments.createRequiredDirectories)>
		<cfset variables.instance.createRequiredDirectories = arguments.createRequiredDirectories />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getScriptProtect" returntype="boolean" access="public" output="false">
	<cfreturn variables.instance.scriptProtect />
</cffunction>

<cffunction name="setEncryptPasswords" access="public" output="false">
	<cfargument name="encryptPasswords" />
	<cfif isBoolean(arguments.encryptPasswords)>
		<cfset variables.instance.encryptPasswords = arguments.encryptPasswords />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getEncryptPasswords" returntype="boolean" access="public" output="false">
	<cfreturn variables.instance.encryptPasswords />
</cffunction> 

<cffunction name="setAutoResetPasswords" access="public" output="false">
	<cfargument name="autoresetpasswords" />
	<cfif isBoolean(arguments.autoresetpasswords)>
		<cfset variables.instance.autoresetpasswords = arguments.autoresetpasswords />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getAutoResetPasswords" returntype="boolean" access="public" output="false">
	<cfreturn variables.instance.autoresetpasswords />
</cffunction>

<cffunction name="setEncryptionKey" access="public" output="false">
	<cfargument name="encryptionKey" />
	<cfif len(arguments.encryptionKey)>
		<cfset variables.instance.encryptionKey = arguments.encryptionKey />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getEncryptionKey" returntype="any" access="public" output="false">
	<cfreturn variables.instance.encryptionKey />
</cffunction> 

<cffunction name="setMaxArchivedVersions" access="public" output="false">
	<cfargument name="maxArchivedVersions" />
	<cfif isNumeric(arguments.maxArchivedVersions)>
		<cfset variables.instance.maxArchivedVersions = arguments.maxArchivedVersions />
	</cfif>
</cffunction>

<cffunction name="setPostBundles" access="public" output="false">
	<cfargument name="postBundles" type="string" />
	<cfif isBoolean(arguments.postBundles)>
		<cfset variables.instance.postBundles = arguments.postBundles />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getMaxArchivedVersions" returntype="any" access="public" output="false">
	<cfreturn variables.instance.maxArchivedVersions />
	<cfreturn this>
</cffunction>

<cffunction name="setTrackSessionInNewThread" access="public" output="false">
	<cfargument name="trackSessionInNewThread" type="string" />
	<cfif isBoolean(arguments.trackSessionInNewThread)>
		<cfset variables.instance.trackSessionInNewThread = arguments.trackSessionInNewThread />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getBCryptLogRounds" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.BCryptLogRounds />
</cffunction>

<cffunction name="setBCryptLogRounds" access="public" output="false">
	<cfargument name="BCryptLogRounds" type="String" />
	<cfif isNumeric(arguments.BCryptLogRounds)>
		<cfset variables.instance.BCryptLogRounds = arguments.BCryptLogRounds />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setAllowAutoUpdates" access="public" output="false">
	<cfargument name="allowAutoUpdates" />
	<cfif isBoolean(arguments.allowAutoUpdates)>
		<cfset variables.instance.allowAutoUpdates = arguments.allowAutoUpdates />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getAllowAutoUpdates" returntype="boolean" access="public" output="false">
	<cfreturn variables.instance.allowAutoUpdates />
</cffunction>

<cffunction name="getAllValues" returntype="any" access="public" output="false">
	<cfreturn variables.instance />
</cffunction>

<cffunction name="setValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="propertyValue" default="" >

	<cfset variables.instance["#arguments.property#"]=arguments.propertyValue />

</cffunction>

<cffunction name="getValue" returntype="any" access="public" output="false">
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

</cfcomponent>