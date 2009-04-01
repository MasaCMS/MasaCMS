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
<cfset variables.instance=structNew()/>
<cfset variables.instance.mode=""/>
<cfset variables.instance.version="5.1"/>
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
<cfset variables.instance.debuggingEnabled="false"/>
<cfset variables.instance.compiler="adobe"/>
<cfset variables.instance.serverPort=""/>
<cfset variables.instance.fileDir=""/>
<cfset variables.instance.assetPath="/tasks/sites"/>
<cfset variables.instance.productionDatasource=""/>
<cfset variables.instance.productionAssetPath=""/>
<cfset variables.instance.productionWebroot=""/>
<cfset variables.instance.productionFiledir=""/>
<cfset variables.instance.fileStore=""/>
<cfset variables.instance.fileStoreAccessInfo=""/>
<cfset variables.instance.tooltips=structNew()/>
<cfset variables.instance.sessionHistory=30 />
<cfset variables.instance.extensionManager=""/>
<cfset variables.instance.reactorDbType=""/>
<cfset variables.instance.reactor=""/>
<cfset variables.instance.locale="Server" />
<cfset variables.instance.imageInterpolation="highestQuality" />
<cfset variables.instance.clusterIPList="" />
<cfset variables.instance.appreloadKey=application.appreloadKey />
<cffunction name="init" returntype="any" output="true" access="public">
	<cfargument name="config" type="struct"> 	
	
	<cfset setMode(config.mode)/>
	<!--- <cfset setVersion(config.version)/> --->
	<cfset setTitle(config.title)/>
	<cfset setWebRoot(config.webroot)/>
	<cfset setWebRootMap(config.webrootmap)/>
	<cfset setMapDir(config.mapdir)/>
	<cfset setDatasource(config.datasource)/>
	<cfset setStub(config.stub)/>
	<cfset setContext(config.context)/>
	<cfset setAdminDomain(config.admindomain)/>
	<cfset setIndexFile(config.indexfile)/>
	<cfset setAdminEmail(config.adminemail)/>
	<cfset setMailServerIP(config.mailserverip)/>
	<cfset setMailServerUsername(config.mailserverusername)/>
	<cfset setMailServerPassword(config.mailserverpassword)/>
	<cfset setUseDefaultSMTPServer(config.useDefaultSMTPServer)/>
	<cfset setAdminSSL(config.adminssl)/>
	<cfset setLogEvents(config.logEvents)/>
	<cfset setFileDelim()/>
	<cfset setDbType(config.dbType)/>
	<cfset setDbUsername(config.dbUsername)/>
	<cfset setDbPassword(config.dbPassword)/>
	<cfset setDebuggingEnabled(config.debuggingEnabled)/>
	<cfset setServerPort(config.port)/>
	<cfset setAssetPath(config.assetPath)/>
	<!--- setFileDir must be after setWebRoot and setFileDelim ans setAssetPath--->
	<cfset setFileDir(config.fileDir)/>
	<cfset setProductionDatasource(config.productionDatasource)/>
	<cfset setProductionAssetPath(config.productionAssetPath)/>
	<cfset setProductionWebroot(config.productionWebroot)/>
	<cfset setProductionFiledir(config.productionFiledir)/>
	<cfset setFileStore(config.fileStore)/>
	<cfset setFileStoreAccessInfo(config.fileStoreAccessInfo)/>
	<cfset setSessionHistory(config.sessionHistory)/>
	
	<cfif structKeyExists(config,"locale")>
	<cfset setDefaultLocale(config.locale)/>
	</cfif>
	
	<cfif structKeyExists(config,"imageInterpolation")>
	<cfset setImageInterpolation(config.imageInterpolation)/>
	</cfif>
	
	<cfif structKeyExists(config,"mailserversmtpport")>
	<cfset setMailServerSMTPPort(config.mailserversmtpport)/>
	</cfif>
	
	<cfif structKeyExists(config,"mailserverpopport")>
	<cfset setMailServerPOPPort(config.mailserverpopport)/>
	</cfif>
	
	<cfif structKeyExists(config,"mailservertls")>
	<cfset setMailServerTLS(config.mailservertls)/>
	</cfif>
	
	<cfif structKeyExists(config,"mailserverSSL")>
	<cfset setMailServerSSL(config.mailserverSSL)/>
	</cfif>
	
	<cfif structKeyExists(config,"clusterIPList")>
	<cfset setClusterIPList(config.clusterIPList)/>
	</cfif>
	
	<cfif structKeyExists(config,"appreloadKey")>
	<cfset setAppreloadKey(config.appreloadKey)/>
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


	<cfset variables.instance.reactorDBType=config.dbType>
	<cfset applyDbUpdates() />
	<cfset loadClassExtensionManager()/>
	
	<cfreturn this />
</cffunction>


<cffunction name="startReactor" output="false" returnType="void">
	<cfset var reactorXML = "" />
	<cfset var reactorDir = "" />
	
	<cfset reactorDir="#getDirectoryFromPath(getCurrentTemplatePath())#reactor#getFileDelim()##getDatasource()#" />
	
	<cfif not DirectoryExists(reactorDir)>
		<cfdirectory action="create" directory="#reactorDir#">
	</cfif>
	
<cfsavecontent variable="reactorXML">
<cfoutput><reactor>
	<config>
		<project value="#getDatasource()#" />
		<dsn value="#getDatasource()#" />
		<type value="#variables.instance.reactorDBType#" />
		<Username value="#getDBUsername()#" />
		<password value="#getDBpassword()#" />
		<mapping value="/#getMapDir()#/reactor/#getDatasource()#" />	
		<cfif getMode() eq 'Development'><mode value="development" /><cfelse><mode value="production" /></cfif>	
	</config>
	<objects/>		
</reactor></cfoutput>
</cfsavecontent>
	
	<cffile action="write" file="#getTempDirectory()##getDatasource()#.xml"	output="#reactorXML#">
	<cfset variables.instance.reactor = createObject("component","reactor.reactorFactory").init("#getTempDirectory()##getDatasource()#.xml") />
	<cffile action="delete" file="#getTempDirectory()##getDatasource()#.xml">
	
</cffunction>

<cffunction name="getMode" returntype="String" access="public" output="false">
	<cfreturn variables.instance.mode />
</cffunction>

<cffunction name="setMode" access="public" output="false">
	<cfargument name="Mode" type="String" />
	<cfset variables.instance.Mode = arguments.Mode />
</cffunction>

<cffunction name="getVersion" returntype="String" access="public" output="false">
	<cfreturn variables.instance.version />
</cffunction>

<cffunction name="setVersion" access="public" output="false">
	<cfargument name="Version" type="String" />
	<cfset variables.instance.version = arguments.Version />
</cffunction>

<cffunction name="getTitle" returntype="String" access="public" output="false">
	<cfreturn variables.instance.title />
</cffunction>

<cffunction name="setTitle" access="public" output="false">
	<cfargument name="Title" type="String" />
	<cfset variables.instance.Title = arguments.Title />
</cffunction>

<cffunction name="getWebRoot" returntype="String" access="public" output="false">
	<cfreturn variables.instance.webroot />
</cffunction>

<cffunction name="setWebRoot" access="public" output="false">
	<cfargument name="webroot" type="String" />
	<cfset variables.instance.webroot = arguments.webroot />
</cffunction>

<cffunction name="getWebRootMap" returntype="String" access="public" output="false">
	<cfreturn variables.instance.webrootmap />
</cffunction>

<cffunction name="setWebRootMap" access="public" output="false">
	<cfargument name="webrootmap" type="String" />
	<cfset variables.instance.webrootmap = arguments.webrootmap />
</cffunction>

<cffunction name="getMapDir" returntype="String" access="public" output="false">
	<cfreturn variables.instance.mapDir />
</cffunction>

<cffunction name="setMapDir" access="public" output="false">
	<cfargument name="MapDir" type="String" />
	<cfset variables.instance.mapDir = arguments.MapDir />
</cffunction>

<cffunction name="getDatasource" returntype="String" access="public" output="false">
	<cfreturn variables.instance.datasource />
</cffunction>

<cffunction name="setDatasource" access="public" output="false">
	<cfargument name="Datasource" type="String" />
	<cfset variables.instance.Datasource = arguments.Datasource />
</cffunction>

<cffunction name="getContext" returntype="String" access="public" output="false">
	<cfreturn variables.instance.context />
</cffunction>

<cffunction name="setContext" access="public" output="false">
	<cfargument name="Context" type="String" />
	<cfset variables.instance.Context = arguments.Context />
</cffunction>

<cffunction name="getStub" returntype="String" access="public" output="false">
	<cfreturn variables.instance.stub />
</cffunction>

<cffunction name="setStub" access="public" output="false">
	<cfargument name="Stub" type="String" />
	<cfset variables.instance.stub = arguments.Stub />
</cffunction>

<cffunction name="getAdminDomain" returntype="String" access="public" output="false">
	<cfreturn variables.instance.adminDomain />
</cffunction>

<cffunction name="setAdminDomain" access="public" output="false">
	<cfargument name="AdminDomain" type="String" />
	<cfset variables.instance.AdminDomain = arguments.AdminDomain />
</cffunction>

<cffunction name="getIndexFile" returntype="String" access="public" output="false">
	<cfreturn variables.instance.indexFile />
</cffunction>

<cffunction name="setIndexFile" access="public" output="false">
	<cfargument name="IndexFile" type="String" />
	<cfset variables.instance.IndexFile = arguments.IndexFile />
</cffunction>

<cffunction name="getAdminEmail" returntype="String" access="public" output="false">
	<cfreturn variables.instance.adminEmail />
</cffunction>

<cffunction name="setAdminEmail" access="public" output="false">
	<cfargument name="AdminEmail" type="String" />
	<cfset variables.instance.adminEmail = arguments.AdminEmail />
</cffunction>

<cffunction name="setMailServerUsernameEmail" returntype="String" access="public" output="false">
	<cfargument name="MailServerUsernameEmail" type="String" />

	<cfif find("@",arguments.MailServerUsernameEmail)>	
		<cfset variables.instance.MailServerUsernameEmail=arguments.MailServerUsernameEmail />	
	<cfelseif find("+",arguments.MailServerUsernameEmail)>		
			<cfset variables.instance.MailServerUsernameEmail=replace(arguments.MailServerUsernameEmail,"+","@") />
	<cfelse>
		<cfset variables.instance.MailServerUsernameEmail=arguments.MailServerUsernameEmail & "@" & listRest(variables.instance.MailServerIP,".") />
	</cfif>
</cffunction>

<cffunction name="getMailServerUsernameEmail" returntype="String" access="public" output="false">
		<cfreturn variables.instance.mailServerUsernameEmail />
</cffunction>

<cffunction name="setMailServerUsername" access="public" output="false">
	<cfargument name="MailServerUsername" type="String" />
	<cfset setMailServerUsernameEmail(arguments.MailServerUsername) />
	<cfset variables.instance.mailServerUsername = arguments.MailServerUsername />
</cffunction>

<cffunction name="getMailServerUsername" returntype="String" access="public" output="false">
	<cfargument name="forLogin" default="false" required="true">
	<cfif not arguments.forLogin or len(getMailServerPassword())>
		<cfreturn variables.instance.mailServerUsername />
	<cfelse>
		<cfreturn ""/>
	</cfif>
</cffunction>

<cffunction name="getMailServerPassword" returntype="String" access="public" output="false">
	<cfreturn variables.instance.mailServerPassword />
</cffunction>

<cffunction name="setMailServerPassword" access="public" output="false">
	<cfargument name="MailServerPassword" type="String" />
	<cfset variables.instance.mailServerPassword = arguments.MailServerPassword />
</cffunction>

<cffunction name="getMailServerIP" returntype="String" access="public" output="false">
	<cfreturn variables.instance.mailServerIP />
</cffunction>

<cffunction name="setMailServerIP" access="public" output="false">
	<cfargument name="MailServerIP" type="String" />
	<cfset variables.instance.MailServerIP = arguments.MailServerIP />
</cffunction>


<cffunction name="getAdminSSL" returntype="Numeric" access="public" output="false">
	<cfreturn variables.instance.adminSSL />
</cffunction>

<cffunction name="setAdminSSL" access="public" output="false">
	<cfargument name="AdminSSL" type="Numeric" />
	<cfset variables.instance.ddminSSL = arguments.AdminSSL />
</cffunction>

<cffunction name="getLogEvents" returntype="Numeric" access="public" output="false">
	<cfreturn variables.instance.logEvents />
</cffunction>

<cffunction name="setLogEvents" access="public" output="false">
	<cfargument name="logEvents" type="Numeric" />
	<cfset variables.instance.logEvents = arguments.logEvents />
</cffunction>

<cffunction name="getFileDelim" returntype="string" access="public" output="false">
	<cfreturn variables.instance.fileDelim />
</cffunction>

<cffunction name="setFileDelim" access="public" output="false">
	
	 <cfset var fileObj = createObject("java", "java.io.File")/>
     <cfset variables.instance.fileDelim = fileObj.separator />
      
</cffunction>

<cffunction name="getDbType" returntype="string" access="public" output="false">
	<cfreturn variables.instance.dbType />
</cffunction>

<cffunction name="setDbType" access="public" output="false">
	<cfargument name="dbType" type="string" />
	<cfif left(arguments.dbType,5) eq "mysql">
		<cfset variables.instance.dbType = "mysql" />
	<cfelse>
		<cfset variables.instance.dbType = arguments.dbType />
	</cfif>
</cffunction>

<cffunction name="getDbPassword" returntype="string" access="public" output="false">
	<cfreturn variables.instance.dbPassword />
</cffunction>

<cffunction name="setDbPassword" access="public" output="false">
	<cfargument name="dbPassword" type="string" />
	<cfset variables.instance.dbPassword = arguments.dbPassword />
</cffunction>

<cffunction name="getDbUsername" returntype="string" access="public" output="false">
	<cfreturn variables.instance.dbUsername />
</cffunction>

<cffunction name="setDbUsername" access="public" output="false">
	<cfargument name="dbUsername" type="string" />
	<cfset variables.instance.dbUsername = arguments.dbUsername />
</cffunction>

<cffunction name="getReactor" access="public" output="false" returntype="any">
	
	<cfif not isObject(variables.instance.reactor)>
		<cfset startReactor() />
	</cfif>
	
	<cfreturn variables.instance.reactor />
</cffunction>

<cffunction name="getDebuggingEnabled" returntype="string" access="public" output="false">
	<cfreturn variables.instance.debuggingEnabled />
</cffunction>

<cffunction name="setDebuggingEnabled" access="public" output="false">
	<cfargument name="debuggingEnabled" type="string" />
	<cfset variables.instance.debuggingEnabled = arguments.debuggingEnabled />
</cffunction>

<cffunction name="getCompiler" returntype="string" access="public" output="false">
	<cfreturn variables.instance.compiler />
</cffunction>

<cffunction name="setCompiler" access="public" output="false">
	<cfargument name="compiler" type="string" />
	<cfset variables.instance.compiler = arguments.compiler />
</cffunction>

<cffunction name="getServerPort" returntype="string" access="public" output="false">
	<cfreturn variables.instance.serverPort />
</cffunction>

<cffunction name="setServerPort" access="public" output="false">
	<cfargument name="ServerPort" type="string" />
	<cfif arguments.serverPort neq "80">
	<cfset variables.instance.ServerPort = ":#arguments.ServerPort#" />
	<cfelse>
	<cfset variables.instance.ServerPort = "" />
	</cfif>
</cffunction>

<cffunction name="getFileDir" returntype="string" access="public" output="false">
	<cfreturn variables.instance.fileDir />
</cffunction>

<cffunction name="setFileDir" access="public" output="false">
	<cfargument name="fileDir" type="string" default="" />
	
	<cfset var ap=variables.instance.assetPath/>
		
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
</cffunction>

<cffunction name="getAssetPath" returntype="String" access="public" output="false">
	<cfreturn variables.instance.assetPath />
</cffunction>

<cffunction name="setAssetPath" access="public" output="false">
	<cfargument name="assetPath" type="String" default="" />
	<cfset variables.instance.assetPath = arguments.assetPath />
</cffunction>

<cffunction name="getProductionDatasource" returntype="String" access="public" output="false">
	<cfreturn variables.instance.productionDatasource />
</cffunction>

<cffunction name="setProductionDatasource" access="public" output="false">
	<cfargument name="ProductionDatasource" type="String" />
	<cfset variables.instance.productionDatasource = arguments.ProductionDatasource />
</cffunction>

<cffunction name="getProductionAssetPath" returntype="String" access="public" output="false">
	<cfreturn variables.instance.productionAssetPath />
</cffunction>

<cffunction name="setProductionAssetPath" access="public" output="false">
	<cfargument name="ProductionAssetPath" type="String" />
	<cfset variables.instance.productionAssetPath = arguments.ProductionAssetPath />
</cffunction>

<cffunction name="getProductionWebroot" returntype="String" access="public" output="false">
	<cfreturn variables.instance.productionWebroot />
</cffunction>

<cffunction name="setProductionWebroot" access="public" output="false">
	<cfargument name="ProductionWebroot" type="String" />
	<cfset variables.instance.ProductionWebroot = arguments.ProductionWebroot />
</cffunction>

<cffunction name="getProductionFiledir" returntype="String" access="public" output="false">
	<cfreturn variables.instance.productionFiledir />
</cffunction>

<cffunction name="setProductionFiledir" access="public" output="false">
	<cfargument name="ProductionFiledir" type="String" />
	<cfset variables.instance.productionFiledir = arguments.ProductionFiledir />
</cffunction>

<cffunction name="getFileStore" returntype="String" access="public" output="false">
	<cfreturn variables.instance.fileStore />
</cffunction>

<cffunction name="setFileStore" access="public" output="false">
	<cfargument name="fileStore" type="String" />
	<cfset variables.instance.fileStore = arguments.fileStore />
</cffunction>

<cffunction name="setFileStoreAccessInfo" access="public" output="false">
	<cfargument name="fileStoreAccessInfo" type="String" />
	<cfset variables.instance.fileStoreAccessInfo = arguments.fileStoreAccessInfo />
</cffunction>

<cffunction name="getFileStoreAccessInfo" returntype="String" access="public" output="false">
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
</cffunction>

<!---
<cffunction name="createGUID" access="public" output="false" returntype="string">
   <cfreturn insert("-", CreateUUID(), 23) />
</cffunction>
--->

<cffunction name="loadClassExtensionManager" returntype="void" access="public" output="false">
	<cfset variables.instance.extensionManager=createObject("component","#getMapDir()#.extend.extendManager").init(this) />
</cffunction>

<cffunction name="applyDbUpdates" returntype="void" access="public" output="false">

	<cfset var rsCheck ="" />
	<cfset var rsUpdates ="" />

	<cfdirectory action="list" directory="#getDirectoryFromPath(getCurrentTemplatePath())#dbUpdates" name="rsUpdates" filter="*.cfm" sort="name asc">

	<cfloop query="rsUpdates">
		<cfinclude template="dbUpdates/#rsUpdates.name#">
	</cfloop>
	
</cffunction>

<cffunction name="getClassExtensionManager" returntype="any" access="public" output="false">
	<cfreturn variables.instance.extensionManager />
</cffunction>

<cffunction name="setDefaultLocale" access="public" output="false">
	<cfargument name="locale" type="String" />
	
	<cfif len(arguments.locale)>
		<cfset variables.instance.locale = arguments.locale />
	</cfif>
</cffunction>

<cffunction name="getDefaultLocale" returntype="String" access="public" output="false">
	<cfreturn variables.instance.locale />
</cffunction>

<cffunction name="setUseDefaultSMTPServer" access="public" output="false">
	<cfargument name="UseDefaultSMTPServer"  />
	
	<cfif isNumeric(arguments.UseDefaultSMTPServer)>
		<cfset variables.instance.UseDefaultSMTPServer = arguments.UseDefaultSMTPServer />
	</cfif>
</cffunction>

<cffunction name="getUseDefaultSMTPServer" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.UseDefaultSMTPServer />
</cffunction>

<cffunction name="setAdminDir" access="public" output="false">
	<cfargument name="adminDir" type="String" />
	
	<cfif len(arguments.adminDir)>
		<cfset variables.instance.adminDir = arguments.adminDir />
	</cfif>
</cffunction>

<cffunction name="getAdminDir" returntype="String" access="public" output="false">
	<cfreturn variables.instance.adminDir />
</cffunction>

<cffunction name="setImageInterpolation" access="public" output="false">
	<cfargument name="imageInterpolation" type="String" />
	
	<cfif len(arguments.imageInterpolation)>
		<cfset variables.instance.imageInterpolation = arguments.imageInterpolation />
	</cfif>
</cffunction>

<cffunction name="getImageInterpolation" returntype="String" access="public" output="false">
	<cfreturn variables.instance.imageInterpolation />
</cffunction>

<cffunction name="getMailServerSMTPPort" returntype="String" access="public" output="false">
	<cfreturn variables.instance.mailServerSMTPPort />
</cffunction>

<cffunction name="setMailServerSMTPPort" access="public" output="false">
	<cfargument name="mailServerPort" type="String" />
	<cfif isNumeric(arguments.mailServerPort)>
	<cfset variables.instance.mailServerSMTPPort = arguments.mailServerPort />
	</cfif>
</cffunction>

<cffunction name="getMailServerPOPPort" returntype="String" access="public" output="false">
	<cfreturn variables.instance.mailServerPOPPort />
</cffunction>

<cffunction name="setMailServerPOPPort" access="public" output="false">
	<cfargument name="mailServerPort" type="String" />
	<cfif isNumeric(arguments.mailServerPort)>
	<cfset variables.instance.mailServerPOPPort = arguments.mailServerPort />
	</cfif>
</cffunction>

<cffunction name="getMailServerTLS" returntype="String" access="public" output="false">
	<cfreturn variables.instance.mailServerTLS />
</cffunction>

<cffunction name="setMailServerTLS" access="public" output="false">
	<cfargument name="mailServerTLS" type="String" />
	<cfif isBoolean(arguments.mailServerTLS)>
	<cfset variables.instance.mailServerTLS = arguments.mailServerTLS />
	</cfif>
</cffunction>

<cffunction name="getMailServerSSL" returntype="String" access="public" output="false">
	<cfreturn variables.instance.mailServerSSL />
</cffunction>

<cffunction name="setMailServerSSL" access="public" output="false">
	<cfargument name="mailServerSSL" type="String" />
	<cfif isBoolean(arguments.mailServerSSL)>
	<cfset variables.instance.mailServerSSL = arguments.mailServerSSL />
	</cfif>
</cffunction>

<cffunction name="getClusterIPList" returntype="String" access="public" output="false">
	<cfreturn variables.instance.clusterIPList />
</cffunction>

<cffunction name="setClusterIPList" access="public" output="false">
	<cfargument name="clusterIPList" type="String" />
	<cfset variables.instance.clusterIPList = trim(arguments.clusterIPList) />
</cffunction>

<cffunction name="getAppreloadKey" returntype="String" access="public" output="false">
	<cfreturn variables.instance.appreloadKey />
</cffunction>

<cffunction name="setAppreloadKey" access="public" output="false">
	<cfargument name="AppreloadKey" type="String" />
	<cfset variables.instance.appreloadKey = arguments.appreloadKey />
</cffunction>
</cfcomponent>