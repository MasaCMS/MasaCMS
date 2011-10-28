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
<cfcomponent extends="mura.bean.bean" output="false">

<cfproperty name="siteID" type="string" default="" required="true" />
<cfproperty name="site" type="string" default="" required="true" />
<cfproperty name="tagLine" type="string" default="" required="true" />
<cfproperty name="pageLimit" type="string" default="1000" required="true" />
<cfproperty name="locking" type="string" default="none" required="true" />
<cfproperty name="domain" type="string" default="" required="true" />
<cfproperty name="domainAlias" type="string" default="" required="true" />
<cfproperty name="contact" type="string" default="" required="true" />
<cfproperty name="mailServerIP" type="string" default="" required="true" />
<cfproperty name="mailServerSMTPPort" type="string" default="25" required="true" />
<cfproperty name="mailServerPOPPort" type="string" default="110" required="true" />
<cfproperty name="mailserverTLS" type="string" default="false" required="true" />
<cfproperty name="mailserverSSL" type="string" default="false" required="true" />
<cfproperty name="mailServerUsername" type="string" default="" required="true" />
<cfproperty name="mailServerUsernameEmail" type="string" default="" required="true" />
<cfproperty name="mailServerPassword" type="string" default="" required="true" />
<cfproperty name="useDefaultSMTPServer" type="numeric" default="1" required="true" />
<cfproperty name="EmailBroadcaster" type="numeric" default="0" required="true" />
<cfproperty name="EmailBroadcasterLimit" type="numeric" default="0" required="true" />
<cfproperty name="extranet" type="numeric" default="0" required="true" />
<cfproperty name="extranetSSL" type="numeric" default="0" required="true" />
<cfproperty name="cache" type="numeric" default="0" required="true" />
<cfproperty name="cacheCapacity" type="numeric" default="0" required="true" />
<cfproperty name="cacheFreeMemoryThreshold" type="numeric" default="60" required="true" />
<cfproperty name="viewDepth" type="numeric" default="1" required="true" />
<cfproperty name="nextN" type="numeric" default="20" required="true" />
<cfproperty name="dataCollection" type="numeric" default="0" required="true" />
<cfproperty name="columnCount" type="numeric" default="3" required="true" />
<cfproperty name="columnNames" type="string" default="Left Column^Main Content^Right Column" required="true" />
<cfproperty name="ExtranetPublicReg" type="numeric" default="0" required="true" />
<cfproperty name="primaryColumn" type="numeric" default="2" required="true" />
<cfproperty name="contactName" type="string" default="" required="true" />
<cfproperty name="contactAddress" type="string" default="" required="true" />
<cfproperty name="contactCity" type="string" default="" required="true" />
<cfproperty name="contactState" type="string" default="" required="true" />
<cfproperty name="contactZip" type="string" default="" required="true" />
<cfproperty name="contactEmail" type="string" default="" required="true" />
<cfproperty name="contactPhone" type="string" default="" required="true" />
<cfproperty name="publicUserPoolID" type="string" default="" required="true" />
<cfproperty name="privateUserPoolID" type="string" default="" required="true" />
<cfproperty name="advertiserUserPoolID" type="string" default="" required="true" />
<cfproperty name="displayPoolID" type="string" default="" required="true" />
<cfproperty name="feedManager" type="numeric" default="0" required="true" />
<cfproperty name="galleryMainScaleBy" type="string" default="y" required="true" />
<cfproperty name="galleryMainScale" type="numeric" default="600" required="true" />
<cfproperty name="gallerySmallScaleBy" type="string" default="s" required="true" />
<cfproperty name="gallerySmallScale" type="numeric" default="80" required="true" />
<cfproperty name="galleryMediumScaleBy" type="string" default="s" required="true" />
<cfproperty name="galleryMediumScale" type="numeric" default="180" required="true" />
<cfproperty name="sendLoginScript" type="string" default="" required="true" />
<cfproperty name="mailingListConfirmScript" type="string" default="" required="true" />
<cfproperty name="reminderScript" type="string" default="" required="true" />
<cfproperty name="ExtranetPublicRegNotify" type="string" default="" required="true" />
<cfproperty name="exportLocation" type="string" default="" required="true" />
<cfproperty name="loginURL" type="string" default="" required="true" />
<cfproperty name="editProfileURL" type="string" default="" required="true" />
<cfproperty name="commentApprovalDefault" type="numeric" default="1" required="true" />
<cfproperty name="display" type="numeric" default="1" required="true" />
<cfproperty name="lastDeployment" type="date" default="" required="true" />
<cfproperty name="accountActivationScript" type="string" default="" required="true" />
<cfproperty name="googleAPIKey" type="string" default="" required="true" />
<cfproperty name="siteLocale" type="string" default="" required="true" />
<cfproperty name="hasChangesets" type="numeric" default="0" required="true" />
<cfproperty name="theme" type="string" default="" required="true" />
<cfproperty name="javaLocale" type="string" default="" required="true" /> 

<cffunction name="init" returntype="any" output="false" access="public">
	
	<cfset super.init(argumentCollection=arguments)>
	
	<cfset variables.instance.SiteID=""/>
	<cfset variables.instance.Site=""/>
	<cfset variables.instance.TagLine=""/>
	<cfset variables.instance.pageLimit=1000/>
	<cfset variables.instance.Locking="None"/>
	<cfset variables.instance.Domain=""/>
	<cfset variables.instance.DomainAlias="">
	<cfset variables.instance.Contact=""/>
	<cfset variables.instance.MailServerIP=""/>
	<cfset variables.instance.MailServerSMTPPort="25"/>
	<cfset variables.instance.MailServerPOPPort="110"/>
	<cfset variables.instance.MailServerTLS="false"/>
	<cfset variables.instance.MailServerSSL="false" />
	<cfset variables.instance.MailServerUsername=""/>
	<cfset variables.instance.MailServerUsernameEmail=""/>
	<cfset variables.instance.MailServerPassword=""/>
	<cfset variables.instance.useDefaultSMTPServer=1/>
	<cfset variables.instance.EmailBroadcaster=0/>
	<cfset variables.instance.EmailBroadcasterLimit=0/>
	<cfset variables.instance.Extranet=0/>
	<cfset variables.instance.ExtranetSSL=0/>
	<cfset variables.instance.cache=0/>
	<cfset variables.instance.cacheFactories=structNew()/>
	<cfset variables.instance.cacheCapacity=0/>
	<cfset variables.instance.cacheFreeMemoryThreshold=60/>
	<cfset variables.instance.ViewDepth=1/>
	<cfset variables.instance.nextN=20/>
	<cfset variables.instance.DataCollection=0/>
	<cfset variables.instance.ColumnCount=3/>
	<cfset variables.instance.ColumnNames="Left Column^Main Content^Right Column"/>
	<cfset variables.instance.ExtranetPublicReg=0/>
	<cfset variables.instance.PrimaryColumn=2/>
	<cfset variables.instance.PublicSubmission=0/>
	<cfset variables.instance.adManager=0/>
	<cfset variables.instance.ContactName=""/>
	<cfset variables.instance.ContactAddress=""/>
	<cfset variables.instance.ContactCity=""/>
	<cfset variables.instance.ContactState=""/>
	<cfset variables.instance.ContactZip=""/>
	<cfset variables.instance.ContactEmail=""/>
	<cfset variables.instance.ContactPhone=""/>
	<cfset variables.instance.PublicUserPoolID=""/>
	<cfset variables.instance.PrivateUserPoolID=""/>
	<cfset variables.instance.AdvertiserUserPoolID=""/>
	<cfset variables.instance.DisplayPoolID=""/>
	<cfset variables.instance.feedManager=0/>
	<cfset variables.instance.galleryMainScaleBy="y"/>
	<cfset variables.instance.galleryMainScale=600/>
	<cfset variables.instance.gallerySmallScaleBy="s"/>
	<cfset variables.instance.gallerySmallScale=80/>
	<cfset variables.instance.galleryMediumScaleBy="s"/>
	<cfset variables.instance.galleryMediumScale=180/>
	<cfset variables.instance.sendLoginScript=""/>
	<cfset variables.instance.mailingListConfirmScript=""/>
	<cfset variables.instance.publicSubmissionApprovalScript=""/>
	<cfset variables.instance.reminderScript=""/>
	<cfset variables.instance.ExtranetPublicRegNotify=""/>
	<cfset variables.instance.exportLocation=""/>
	<cfset variables.instance.loginURL=""/>
	<cfset variables.instance.editProfileURL=""/>
	<cfset variables.instance.commentApprovalDefault=1/>  
	<cfset variables.instance.deploy=1/>  
	<cfset variables.instance.lastDeployment=""/>
	<cfset variables.instance.accountActivationScript=""/>
	<cfset variables.instance.googleAPIKey=""/>
	<cfset variables.instance.siteLocale=""/>
	<cfset variables.instance.rbFactory=""/>    
	<cfset variables.instance.javaLocale=""/>
	<cfset variables.instance.jsDateKey=""/>  
	<cfset variables.instance.theme=""/> 
	<cfset variables.instance.contentRenderer=""/>
	<cfset variables.instance.themeRenderer=""/>
	<cfset variables.instance.hasChangesets=0/>
	
	<cfreturn this />
</cffunction>

<cffunction name="validate" access="public" output="false">
	<cfset variables.instance.errors=structnew() />
	
	<cfif variables.instance.siteID eq "">
		<cfset variables.instance.errors.siteid="The 'SiteID' variable is required." />
	</cfif>
	
	<cfif variables.instance.siteID eq "admin" or variables.instance.siteID eq "tasks">
		<cfset variables.instance.errors.siteid="The 'SiteID' variable is invalid." />
	</cfif>
	
	<!---
	<cfif not getBean('utility').isValidCFVariableName(variables.instance.siteID)>
		<cfset variables.instance.errors.siteid="The 'SiteID' variable is invalid." />
	</cfif>
	--->
	<cfreturn this>
</cffunction>

<cffunction name="set" output="false" access="public">
	<cfargument name="data" type="any" required="true">
	<cfset var prop="">
	<cfif isQuery(arguments.data) and arguments.data.recordcount>
		<cfloop list="#arguments.data.columnlist#" index="prop">
			<cfset setValue(prop,arguments.data[prop][1]) />
		</cfloop>
			
	<cfelseif isStruct(arguments.data)>
		<cfloop collection="#arguments.data#" item="prop">
			<cfset setValue(prop,arguments.data[prop]) />
		</cfloop>
				
	</cfif>
		
	<cfif variables.instance.privateUserPoolID eq ''>
		<cfset variables.instance.privateUserPoolID=variables.instance.siteID />
	</cfif>
			
	<cfif variables.instance.publicUserPoolID eq ''>
		<cfset variables.instance.publicUserPoolID=variables.instance.siteID />
	</cfif>
			
	<cfif variables.instance.advertiserUserPoolID eq ''>
		<cfset variables.instance.advertiserUserPoolID=variables.instance.siteID />
	</cfif>
			
	<cfif variables.instance.displayPoolID eq ''>
		<cfset variables.instance.displayPoolID=variables.instance.siteID />
	</cfif>

	<cfreturn this>
 </cffunction>

<cffunction name="setTheme" output="false">
	<cfargument name="theme">
	<cfif arguments.theme neq variables.instance.theme>
		<cfset variables.instance.theme=arguments.theme>
	</cfif>
</cffunction>

<cffunction name="getDomain" returntype="String" access="public" output="false">
	<cfargument name="mode" type="String" required="true" default="#application.configBean.getMode()#" />
	
	<cfif arguments.mode eq 'Staging'>
		<cfif len(application.configBean.getAdminDomain())>
			<cfreturn application.configBean.getAdminDomain() />
		<cfelse>
			<cfreturn cgi.server_name />
		</cfif>
	<cfelse>
		<cfreturn variables.instance.Domain />
	</cfif>
</cffunction>

<cffunction name="setHasFeedManager" output="false">
	<cfargument name="feedManager" />
	<cfset variables.instance.feedManager=arguments.feedManager>
	<cfreturn this>
</cffunction>

<cffunction name="getHasFeedManager" output="false">
	<cfreturn variables.instance.feedManager>
</cffunction>

<cffunction name="setExportLocation" access="public" output="false">
	<cfargument name="ExportLocation" type="String" />
	<cfif arguments.ExportLocation neq "export1">
	<cfset variables.instance.ExportLocation = arguments.ExportLocation />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMailServerUsernameEmail" access="public" output="false">
	<cfargument name="MailServerUsernameEmail" type="String" />

	<cfif find("@",arguments.MailServerUsernameEmail)>	
		<cfset variables.instance.MailServerUsernameEmail=arguments.MailServerUsernameEmail />	
	<cfelseif find("+",arguments.MailServerUsernameEmail)>		
			<cfset variables.instance.MailServerUsernameEmail=replace(arguments.MailServerUsernameEmail,"+","@") />
	<cfelseif len(arguments.MailServerUsernameEmail)>
		<cfset variables.instance.MailServerUsernameEmail=arguments.MailServerUsernameEmail & "@" & listRest(variables.instance.MailServerIP,".") />
	<cfelse>
		<cfset variables.instance.MailServerUsernameEmail=variables.instance.contact />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getMailServerUsername" returntype="String" access="public" output="false">
	<cfargument name="forLogin" default="false" required="true">
	<cfif not arguments.forLogin or len(variables.instance.mailServerPassword)>
		<cfreturn variables.instance.mailServerUsername />
	<cfelse>
		<cfreturn ""/>
	</cfif>
</cffunction>

<cffunction name="setMailServerUsername" access="public" output="false">
	<cfargument name="MailServerUsername" type="String" />
	<cfset setMailServerUsernameEmail(arguments.MailServerUsername) />
	<cfset variables.instance.mailServerUsername = arguments.MailServerUsername />
	<cfreturn this>
</cffunction>

<cffunction name="setCacheCapacity" access="public" output="false">
	<cfargument name="cacheCapacity" />
	<cfif isNumeric(arguments.cacheCapacity)>
	<cfset variables.instance.cacheCapacity = arguments.cacheCapacity />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setCacheFreeMemoryThreshold" access="public" output="false">
	<cfargument name="cacheFreeMemoryThreshold" />
	<cfif isNumeric(arguments.cacheFreeMemoryThreshold) and arguments.cacheFreeMemoryThreshold>
	<cfset variables.instance.cacheFreeMemoryThreshold = arguments.cacheFreeMemoryThreshold />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setGalleryMainScale" access="public" output="true">
	<cfargument name="GalleryMainScale" type="any" required="yes" default="0" />
	<cfif isNumeric(arguments.GalleryMainScale)>
		<cfset variables.instance.GalleryMainScale = arguments.GalleryMainScale />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setGallerySmallScale" access="public" output="true">
	<cfargument name="GallerySmallScale" type="any" required="yes" default="0" />
	<cfif isNumeric(arguments.GallerySmallScale)>
		<cfset variables.instance.GallerySmallScale = arguments.GallerySmallScale />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setGalleryMediumScale" access="public" output="true">
	<cfargument name="GalleryMediumScale" type="any" required="yes" default="0" />
	<cfif isNumeric(arguments.GalleryMediumScale)>
		<cfset variables.instance.GalleryMediumScale = arguments.GalleryMediumScale />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getLoginURL" returntype="String" access="public" output="false">
	<cfif variables.instance.loginURL neq ''>
	<cfreturn variables.instance.LoginURL />
	<cfelse>
	<cfreturn "#application.configBean.getIndexFile()#?display=login" />
	</cfif>
</cffunction>

<cffunction name="getEditProfileURL" returntype="String" access="public" output="false">
	<cfif variables.instance.EditProfileURL neq ''>
	<cfreturn variables.instance.EditProfileURL />
	<cfelse>
	<cfreturn "#application.configBean.getIndexFile()#?display=editProfile" />
	</cfif>
</cffunction>

<cffunction name="setLastDeployment" access="public" output="false">
	<cfargument name="LastDeployment" type="String" />
	<cfset variables.instance.LastDeployment = parseDateArg(arguments.LastDeployment)/>
	<cfreturn this>
</cffunction>

<cffunction name="setUseDefaultSMTPServer" access="public" output="false">
	<cfargument name="UseDefaultSMTPServer"  />
	<cfif isNumeric(arguments.UseDefaultSMTPServer)>
		<cfset variables.instance.UseDefaultSMTPServer = arguments.UseDefaultSMTPServer />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMailServerSMTPPort" access="public" output="false">
	<cfargument name="mailServerPort" type="String" />
	<cfif isNumeric(arguments.mailServerPort)>
	<cfset variables.instance.mailServerSMTPPort = arguments.mailServerPort />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMailServerPOPPort" access="public" output="false">
	<cfargument name="mailServerPort" type="String" />
	<cfif isNumeric(arguments.mailServerPort)>
	<cfset variables.instance.mailServerPOPPort = arguments.mailServerPort />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMailServerTLS" access="public" output="false">
	<cfargument name="mailServerTLS" type="String" />
	<cfif isBoolean(arguments.mailServerTLS)>
	<cfset variables.instance.mailServerTLS = arguments.mailServerTLS />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMailServerSSL" access="public" output="false">
	<cfargument name="mailServerSSL" type="String" />
	<cfif isBoolean(arguments.mailServerSSL)>
	<cfset variables.instance.mailServerSSL = arguments.mailServerSSL />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getCacheFactory" returntype="any" access="public" output="false">
	<cfargument name="name"default="output" hint="data or output">
		
	<cfif not isDefined("arguments.name")>
		<cfset arguments.name="output">
	</cfif>
	
	<cfif not isDefined("variables.instance.cacheFactories")>
		<cfset variables.instance.cacheFactories=structNew()>
	</cfif>
	
	<cfif structKeyExists(variables.instance.cacheFactories,arguments.name)>
		<cfreturn variables.instance.cacheFactories["#arguments.name#"] />
	<cfelse>
		<cfif not variables.instance.cacheCapacity>
			<cfset variables.instance.cacheFactories["#arguments.name#"]=getBean("settingsManager").createCacheFactory(freeMemoryThreshold=variables.instance.cacheFreeMemoryThreshold,name=arguments.name,siteID=variables.instance.siteID)>
		<cfelse>
			<cfset variables.instance.cacheFactories["#arguments.name#"]=getBean("settingsManager").createCacheFactory(capacity=variables.instance.cacheCapacity,freeMemoryThreshold=variables.instance.cacheFreeMemoryThreshold,name=arguments.name,siteID=variables.instance.siteID)>
		</cfif>
		<cfreturn variables.instance.cacheFactories["#arguments.name#"] />
	</cfif>
	
</cffunction>

<cffunction name="purgeCache" access="public" output="false">
	<cfargument name="name" default="data" hint="data, output or both">
	<cfargument name="broadcast" default="true">
	<cfset getCacheFactory(name=arguments.name).purgeAll()>
	<cfif arguments.broadcast>
		<cfset getBean("clusterManager").purgeCache(siteID=variables.instance.siteID,name=arguments.name)>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getJavaLocale" returntype="String" access="public" output="false">
	<cfif len(variables.instance.siteLocale)>
		<cfset variables.instance.javaLocale=application.rbFactory.CF2Java(variables.instance.siteLocale)>
	<cfelse>
		<cfset variables.instance.javaLocale=application.rbFactory.CF2Java(getBean("configBean").getDefaultLocale())>
	</cfif>
	<cfreturn variables.instance.javaLocale />
</cffunction>

<cffunction name="getRBFactory" returntype="any" access="public" output="false">
	<cfset var tmpFactory="">
	<cfset var themeRBDir="">
	<cfif not isObject(variables.instance.rbFactory)>
		<cfset tmpFactory=createObject("component","mura.resourceBundle.resourceBundleFactory").init(application.rbFactory,"#expandPath('/#getBean("configBean").getWebRootMap()#')#/#variables.instance.displayPoolID#/includes/resourceBundles/",getJavaLocale())>
		<cfset themeRBDir=expandPath(getThemeIncludePath()) & "/resourceBundles/">
		<cfif directoryExists(themeRBDir)>
			<cfset variables.instance.rbFactory=createObject("component","mura.resourceBundle.resourceBundleFactory").init(tmpFactory,themeRBDir,getJavaLocale()) />
		<cfelse>
			<cfset variables.instance.rbFactory=tmpFactory />
		</cfif>
	</cfif>
	<cfreturn variables.instance.rbFactory />
</cffunction>

<cffunction name="setRBFactory" returntype="any" access="public" output="false">
	<cfargument name="rbFactory">
	<cfif not isObject(arguments.rbFactory)>
		<cfset variables.instance.rbFactory=arguments.rbFactory />
	</cfif>
	<cfreturn this />
</cffunction>

<cffunction name="getJSDateKey" returntype="String" access="public" output="false">
	<cfif not len(variables.instance.jsDateKey)>
		<cfset variables.instance.jsDateKey=getLocaleUtils().getJSDateKey()>
	</cfif>
	<cfreturn variables.instance.jsDateKey />
</cffunction>

<cffunction name="getLocaleUtils" returntype="any" access="public" output="false">
	<cfreturn getRBFactory().getUtils() />
</cffunction>
s
<cffunction name="getAssetPath" returntype="any" access="public" output="false">
	<cfreturn "#getBean("configBean").getContext()#/#variables.instance.displayPoolID#" />
</cffunction>

<cffunction name="getIncludePath" returntype="any" access="public" output="false">
	<cfreturn "/#getBean("configBean").getWebRootMap()#/#variables.instance.displayPoolID#" />
</cffunction>

<cffunction name="getAssetMap" returntype="any" access="public" output="false">
	<cfreturn "#getBean("configBean").getWebRootMap()#.#variables.instance.displayPoolID#" />
</cffunction>

<cffunction name="getThemeAssetPath" returntype="any" access="public" output="false">
	<cfargument name="theme" default="#request.altTheme#">
	
	<cfif len(arguments.theme) and directoryExists(getTemplateIncludeDir(arguments.theme))>
		<cfreturn "#getAssetPath()#/includes/themes/#arguments.theme#" />
	<cfelseif len(variables.instance.theme)>
		<cfreturn "#getAssetPath()#/includes/themes/#variables.instance.theme#" />
	<cfelse>
		<cfreturn getAssetPath() />
	</cfif>
</cffunction>

<cffunction name="getThemeIncludePath" returntype="any" access="public" output="false">
	<cfargument name="theme" default="#request.altTheme#">
	
	<cfif len(arguments.theme) and directoryExists(getTemplateIncludeDir(arguments.theme))>
		<cfreturn "#getIncludePath()#/includes/themes/#theme#" />
	<cfelseif len(variables.instance.theme)>
		<cfreturn "#getIncludePath()#/includes/themes/#variables.instance.theme#" />
	<cfelse>
		<cfreturn getIncludePath() />
	</cfif>
</cffunction>

<cffunction name="getThemeAssetMap" returntype="any" access="public" output="false">
	<cfargument name="theme" default="#request.altTheme#">
	
	<cfif len(arguments.theme) and directoryExists(getTemplateIncludeDir(arguments.theme))>
		<cfreturn "#getAssetMap()#.includes.themes.#arguments.theme#" />
	<cfelseif len(variables.instance.theme)>
		<cfreturn "#getAssetMap()#.includes.themes.#variables.instance.theme#" />
	<cfelse>
		<cfreturn getAssetMap() />
	</cfif>
</cffunction>

<cffunction name="getTemplateIncludePath" returntype="any" access="public" output="false">
	<cfargument name="theme" default="#request.altTheme#">
	
	<cfif len(arguments.theme) and directoryExists(getTemplateIncludeDir(arguments.theme))>
		<cfreturn "#getIncludePath()#/includes/themes/#arguments.theme#/templates" />
	<cfelseif len(variables.instance.theme)>
		<cfreturn "#getIncludePath()#/includes/themes/#variables.instance.theme#/templates" />
	<cfelse>
		<cfreturn "#getIncludePath()#/includes/templates" />
	</cfif>
</cffunction>

<cffunction name="hasNonThemeTemplates" returntype="any" access="public" output="false">
	<cfreturn directoryExists(expandPath("#getIncludePath()#/includes/templates")) />
</cffunction>

<cffunction name="getTemplateIncludeDir" returntype="any" access="public" output="false">
	<cfargument name="theme" default="#request.altTheme#">
	
	<cfif len(arguments.theme)>
		<cfreturn "#expandPath('/#getBean("configBean").getWebRootMap()#')#/#variables.instance.displayPoolID#/includes/themes/#arguments.theme#/templates">
	<cfelseif len(variables.instance.theme)>
		<cfreturn "#expandPath('/#getBean("configBean").getWebRootMap()#')#/#variables.instance.displayPoolID#/includes/themes/#variables.instance.theme#/templates">
	<cfelse>
		<cfreturn "#expandPath('/#getBean("configBean").getWebRootMap()#')#/#variables.instance.displayPoolID#/includes/templates">
	</cfif>
</cffunction>

<cffunction name="getThemes" returntype="query" access="public" output="false">
	<cfset var rs = "">
	<cfset var themeDir="">
	
	<cfif len(variables.instance.displayPoolID)>
		<cfset themeDir="#expandPath('/#getBean("configBean").getWebRootMap()#')#/#variables.instance.displayPoolID#/includes/themes">
	<cfelse>
		<cfset themeDir="#expandPath('/#getBean("configBean").getWebRootMap()#')#/default/includes/themes">
	</cfif>
	
	<cfdirectory action="list" directory="#themeDir#" name="rs">
	
	<cfquery name="rs" dbtype="query">
	select * from rs where type='Dir' and name not like '%.svn'
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="getTemplates" returntype="query" access="public" output="false">
	<cfargument name="type" required="true" default="">
	<cfset var rs = "">
	<cfset var dir="">
	
	<cfswitch expression="#arguments.type#">
	<cfcase value="Component">
		
		<cfset dir="#getTemplateIncludeDir()#/#lcase(arguments.type)#s">
		
		<cfif directoryExists(dir)>
			<cfdirectory action="list" directory="#dir#" name="rs" filter="*.cfm">
			<cfquery name="rs" dbType="query">
			select * from rs order by name
			</cfquery>
		<cfelse>
			<cfset rs=queryNew("empty")>
		</cfif>
	</cfcase>
	<cfdefaultcase>
		
		<cfdirectory action="list" directory="#getTemplateIncludeDir()#" name="rs" filter="*.cfm">
		<cfquery name="rs" dbType="query">
			select * from rs order by name
		</cfquery>
	</cfdefaultcase>
	</cfswitch>
	
	<cfreturn rs />
</cffunction>

<cffunction name="isValidDomain" output="false" returntype="boolean">
	<cfargument name="domain">
	<cfargument name="mode" required="true" default="either">
	<cfset var i="">
	<cfset var lineBreak=chr(13)&chr(10)>
	
	<cfif arguments.mode neq "partial">
		<cfif arguments.domain eq getDomain()>
			<cfreturn true>
		<cfelseif len(variables.instance.domainAlias)>
			<cfloop list="#variables.instance.domainAlias#" delimiters="#lineBreak#" index="i">
				<cfif arguments.domain eq i>
					<cfreturn true>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
	
	<cfif arguments.mode neq "complete">
		<cfif find(arguments.domain,getDomain())>
			<cfreturn true>
		<cfelseif len(variables.instance.domainAlias)>
			<cfloop list="#variables.instance.domainAlias#" delimiters="#lineBreak#" index="i">
				<cfif find(arguments.domain,i)>
					<cfreturn true>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>

	<cfreturn false>
</cffunction>

<cffunction name="getContentRenderer" output="false">
<cfif not isObject(variables.instance.contentRenderer)>
	<cfset variables.instance.contentRenderer=createObject("component","#getAssetMap()#.includes.contentRenderer")>
</cfif>
<cfreturn variables.instance.contentRenderer>
</cffunction>

<cffunction name="getThemeRenderer" output="false">
	<cfif not isObject(variables.instance.themeRenderer)>
		<cfif fileExists(expandPath(getThemeIncludePath()) & "/contentRenderer.cfc")>
			<cfset variables.instance.themeRenderer=createObject("component","#getThemeAssetMap()#.contentRenderer")>
		<cfelse>
			<cfset variables.instance.themeRenderer=createObject("component","mura.cfobject").init()>
		</cfif>
	</cfif>
	<cfreturn variables.instance.themeRenderer>
</cffunction>

<cffunction name="exportHTML" output="false">
	<cfargument name="exportDir">
	<cfif isDefined("arguments.exportDir")>
		<cfset getBean("HTMLExporter").export(variables.instance.siteID,arguments.exportDir)>
	<cfelse>
		<cfset getBean("HTMLExporter").export(variables.instance.siteID,variables.instance.exportLocation)>
	</cfif>
</cffunction>

<cffunction name="save" returnType="any" output="false" access="public">
	<cfset setAllValues(getBean("settingsManager").save(this).getAllValues())>
	<cfreturn this />
</cffunction>

<!---
	Not sure I want to expose this.
<cffunction name="delete" output="false" access="public">
	<cfset getBean("settingsManager").delete(variables.instance.siteID) />
</cffunction>
--->

<cffunction name="loadBy" returnType="any" output="false" access="public">
	<cfif not structKeyExists(arguments,"siteID")>
		<cfset arguments.siteID=variables.instance.siteID>
	</cfif>
	
	<cfset arguments.settingsBean=this>
	
	<cfreturn getBean("settingsManager").read(argumentCollection=arguments)>
</cffunction>

</cfcomponent>
