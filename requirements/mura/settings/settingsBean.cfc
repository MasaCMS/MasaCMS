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
<cfcomponent extends="mura.bean.beanExtendable" entityName="site" table="tsettings" output="false">
 
<cfproperty name="siteID" fieldtype="id" type="string" default="" required="true" />
<cfproperty name="site" type="string" default=""/>
<cfproperty name="tagLine" type="string" default=""/>
<cfproperty name="pageLimit" type="string" default="1000" required="true" />
<cfproperty name="locking" type="string" default="none" required="true" />
<cfproperty name="domain" type="string" default=""/>
<cfproperty name="domainAlias" type="string" default=""/>
<cfproperty name="enforcePrimaryDomain" type="int" default="0" required="true" />
<cfproperty name="contact" type="string" default=""/>
<cfproperty name="mailServerIP" type="string" default=""/>
<cfproperty name="mailServerSMTPPort" type="string" default="25" required="true" />
<cfproperty name="mailServerPOPPort" type="string" default="110" required="true" />
<cfproperty name="mailserverTLS" type="string" default="false" required="true" />
<cfproperty name="mailserverSSL" type="string" default="false" required="true" />
<cfproperty name="mailServerUsername" type="string" default=""/>
<cfproperty name="mailServerUsernameEmail" type="string" default=""/>
<cfproperty name="mailServerPassword" type="string" default=""/>
<cfproperty name="useDefaultSMTPServer" type="numeric" default="1" required="true" />
<cfproperty name="EmailBroadcaster" type="numeric" default="0" required="true" />
<cfproperty name="EmailBroadcasterLimit" type="numeric" default="0" required="true" />
<cfproperty name="extranet" type="numeric" default="1" required="true" />
<cfproperty name="extranetSSL" type="numeric" default="0" required="true" hint="deprecated"/>
<cfproperty name="cache" type="numeric" default="0" required="true" />
<cfproperty name="cacheCapacity" type="numeric" default="0" required="true" />
<cfproperty name="cacheFreeMemoryThreshold" type="numeric" default="60" required="true" />
<cfproperty name="viewDepth" type="numeric" default="1" required="true" />
<cfproperty name="nextN" type="numeric" default="20" required="true" />
<cfproperty name="dataCollection" type="numeric" default="1" required="true" />
<cfproperty name="columnCount" type="numeric" default="3" required="true" />
<cfproperty name="columnNames" type="string" default="Left Column^Main Content^Right Column" required="true" />
<cfproperty name="ExtranetPublicReg" type="numeric" default="0" required="true" />
<cfproperty name="primaryColumn" type="numeric" default="2" required="true" />
<cfproperty name="contactName" type="string" default=""/>
<cfproperty name="contactAddress" type="string" default=""/>
<cfproperty name="contactCity" type="string" default=""/>
<cfproperty name="contactState" type="string" default=""/>
<cfproperty name="contactZip" type="string" default=""/>
<cfproperty name="contactEmail" type="string" default=""/>
<cfproperty name="contactPhone" type="string" default=""/>
<cfproperty name="publicUserPoolID" type="string" default=""/>
<cfproperty name="privateUserPoolID" type="string" default=""/>
<cfproperty name="advertiserUserPoolID" type="string" default=""/>
<cfproperty name="displayPoolID" type="string" default=""/>
<cfproperty name="contentPoolID" type="string" default=""/>
<cfproperty name="categoryPoolID" type="string" default=""/>
<cfproperty name="feedManager" type="numeric" default="1" required="true" />
<cfproperty name="largeImageHeight" type="string" default="AUTO" required="true" />
<cfproperty name="largeImageWidth" type="numeric" default="600" required="true" />
<cfproperty name="smallImageHeight" type="string" default="80" required="true" />
<cfproperty name="smallImageWidth" type="numeric" default="80" required="true" />
<cfproperty name="mediumImageHeight" type="string" default="180" required="true" />
<cfproperty name="mediumImageWidth" type="numeric" default="180" required="true" />
<cfproperty name="sendLoginScript" type="string" default=""/>
<cfproperty name="mailingListConfirmScript" type="string" default=""/>
<cfproperty name="reminderScript" type="string" default=""/>
<cfproperty name="ExtranetPublicRegNotify" type="string" default=""/>
<cfproperty name="exportLocation" type="string" default=""/>
<cfproperty name="loginURL" type="string" default=""/>
<cfproperty name="editProfileURL" type="string" default=""/>
<cfproperty name="commentApprovalDefault" type="numeric" default="1" required="true" />
<cfproperty name="display" type="numeric" default="1" required="true" />
<cfproperty name="lastDeployment" type="date" default=""/>
<cfproperty name="accountActivationScript" type="string" default=""/>
<cfproperty name="googleAPIKey" type="string" default=""/>
<cfproperty name="siteLocale" type="string" default=""/>
<cfproperty name="hasChangesets" type="numeric" default="1" required="true" />
<cfproperty name="theme" type="string" default=""/>
<cfproperty name="javaLocale" type="string" default=""/> 
<cfproperty name="orderno" type="numeric" default="0" required="true" />
<cfproperty name="enforceChangesets" type="numeric" default="0" required="true" />
<cfproperty name="contentApprovalScript" type="string" default=""/>
<cfproperty name="contentRejectionScript" type="string" default=""/>
<cfproperty name="enableLockdown" type="string" default="" />
<cfproperty name="customTagGroups" type="string" default="" />
<cfproperty name="hasComments" type="numeric" default="1" required="true" />
<cfproperty name="hasLockableNodes" type="numeric" default="0" required="true" />
<cfproperty name="reCAPTCHASiteKey" type="string" default="" />
<cfproperty name="reCAPTCHASecret" type="string" default="" />
<cfproperty name="reCAPTCHALanguage" type="string" default="en" />
<cfproperty name="JSONApi" type="numeric" default="0" />
<cfproperty name="useSSL" type="numeric" default="0" />
<cfproperty name="isRemote" type="numeric" default="0" />
<cfproperty name="RemoteContext" type="string" default="" />
<cfproperty name="RemotePort" type="numeric" default="0" />
<cfproperty name="resourceSSL" type="numeric" default="0" />
<cfproperty name="resourceDomain" type="string" default="" />

<cfset variables.primaryKey = 'siteid'>
<cfset variables.entityName = 'site'>
<cfset variables.instanceName= 'site'>

<cffunction name="init" returntype="any" output="false" access="public">
	
	<cfset super.init(argumentCollection=arguments)>
	
	<cfset variables.instance.SiteID=""/>
	<cfset variables.instance.Site=""/>
	<cfset variables.instance.TagLine=""/>
	<cfset variables.instance.pageLimit=1000/>
	<cfset variables.instance.Locking="None"/>
	<cfset variables.instance.Domain=""/>
	<cfset variables.instance.DomainAlias="">
	<cfset variables.instance.enforcePrimaryDomain=0>
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
	<cfset variables.instance.Extranet=1/>
	<cfset variables.instance.ExtranetSSL=0/>
	<cfset variables.instance.cache=0/>
	<cfset variables.instance.cacheFactories=structNew()/>
	<cfset variables.instance.cacheCapacity=0/>
	<cfset variables.instance.cacheFreeMemoryThreshold=60/>
	<cfset variables.instance.ViewDepth=1/>
	<cfset variables.instance.nextN=20/>
	<cfset variables.instance.DataCollection=1/>
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
	<cfset variables.instance.ContentPoolID=""/>
	<cfset variables.instance.CategoryPoolID=""/>
	<cfset variables.instance.feedManager=1/>
	<cfset variables.instance.largeImageHeight='AUTO'/>
	<cfset variables.instance.largeImageWidth='600'/>
	<cfset variables.instance.smallImageHeight='80'/>
	<cfset variables.instance.smallImageWidth='80'/>
	<cfset variables.instance.mediumImageHeight='180'/>
	<cfset variables.instance.mediumImageWidth='180'/>
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
	<cfset variables.instance.jsDateKeyObjInc=""/>   
	<cfset variables.instance.theme=""/> 
	<cfset variables.instance.contentRenderer=""/>
	<cfset variables.instance.themeRenderer=""/>
	<cfset variables.instance.hasChangesets=1/>
	<cfset variables.instance.type="Site"/>
	<cfset variables.instance.subtype="Default"/>
	<cfset variables.instance.baseID=createUUID()/>
	<cfset variables.instance.orderno=0/>
	<cfset variables.instance.enforceChangesets=0/>
	<cfset variables.instance.contentApprovalScript=""/>
	<cfset variables.instance.contentRejectionScript=""/>
	<cfset variables.instance.enableLockdown=""/>
	<cfset variables.instance.customTagGroups=""/>
	<cfset variables.instance.hasSharedFilePool=""/>
	<cfset variables.instance.hasComments=1/>
	<cfset variables.instance.hasLockableNodes=0/>
	<cfset variables.instance.reCAPTCHASiteKey=""/>
	<cfset variables.instance.reCAPTCHASecret=""/>
	<cfset variables.instance.reCAPTCHALanguage="en"/>
	<cfset variables.instance.JSONApi=0/>
	<cfset variables.instance.useSSL=0/>
	<cfset variables.instance.isRemote=0/>
	<cfset variables.instance.RemoteContext=""/>
	<cfset variables.instance.RemotePort=80/>
	<cfset variables.instance.resourceSSL=0/>
	<cfset variables.instance.resourceDomain=""/>

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
	<cfargument name="property" required="true">
    <cfargument name="propertyValue">
    
    <cfif not isDefined('arguments.config')>
	    <cfif isSimpleValue(arguments.property)>
	      <cfreturn setValue(argumentCollection=arguments)>
	    </cfif>

	    <cfset arguments.data=arguments.property>
    </cfif>

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

	<cfif variables.instance.filePoolID eq ''>
		<cfset variables.instance.filePoolID=variables.instance.siteID />
	</cfif>

	<cfif variables.instance.categoryPoolID eq ''>
		<cfset variables.instance.categoryPoolID=variables.instance.siteID />
	</cfif>

	<cfif variables.instance.contentPoolID eq ''>
		<cfset variables.instance.contentPoolID=variables.instance.siteID />
	</cfif>

	<cfreturn this>
 </cffunction>

<cffunction name="setConfigBean" output="false">
	<cfargument name="configBean">
	<cfset variables.configBean=arguments.configBean>
	<cfreturn this>
</cffunction>

<cffunction name="setBaseID" output="false">
	<cfargument name="baseID">
	<cfif len(arguments.baseID)>
		<cfset variables.instance.baseID=arguments.baseID>
	</cfif>
</cffunction>

<cffunction name="getExtendBaseID" output="false">
	<cfreturn variables.instance.baseID>
</cffunction>

<cffunction name="setTheme" output="false">
	<cfargument name="theme">
	<cfif arguments.theme neq variables.instance.theme>
		<cfset variables.instance.theme=arguments.theme>
	</cfif>
</cffunction>

<cffunction name="getDomain" returntype="String" access="public" output="false">
	<cfargument name="mode" type="String" required="true" default="" />
	<cfset var temp="">

	<cfif arguments.mode eq 'preview'>
		<cfif len(request.muraPreviewDomain)>
			<cfreturn request.muraPreviewDomain />
		<cfelse>
			<cfreturn variables.instance.Domain />
		</cfif>
	<cfelse>
		<cfreturn variables.instance.Domain />
	</cfif>
</cffunction>

<cffunction name="setEnforcePrimaryDomain" access="public" output="false">
	<cfargument name="enforcePrimaryDomain" />
	<cfif isNumeric(arguments.enforcePrimaryDomain)>
	<cfset variables.instance.enforcePrimaryDomain = arguments.enforcePrimaryDomain />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getUseSSL" output="false">
	<cfif variables.instance.useSSL or variables.instance.extranetSSL>
		<cfreturn 1>
	<cfelse>
		<cfreturn 0>
	</cfif>
</cffunction>

<cffunction name="setEnforceChangesets" access="public" output="false">
	<cfargument name="enforceChangesets" />
	<cfif isNumeric(arguments.enforceChangesets)>
		<cfset variables.instance.enforceChangesets = arguments.enforceChangesets />
	</cfif>
	<cfreturn this>
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

<cffunction name="getDataCollection" output="false">
	<cfif not variables.configBean.getDataCollection()>
		<cfreturn 0>
	<cfelse>
		<cfreturn variables.instance.dataCollection>
	</cfif>
</cffunction>

<cffunction name="getAdManager" output="false">
	<cfif not variables.configBean.getAdManager()>
		<cfreturn 0>
	<cfelse>
		<cfreturn variables.instance.adManager>
	</cfif>
</cffunction>

<cffunction name="getEmailBroadcaster" output="false">
	<cfif not variables.configBean.getEmailBroadcaster()>
		<cfreturn 0>
	<cfelse>
		<cfreturn variables.instance.EmailBroadcaster>
	</cfif>
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

<cffunction name="setSmallImageWidth" access="public" output="true">
	<cfargument name="smallImageWidth" type="any" required="yes" default="0" />
	<cfif isNumeric(arguments.smallImageWidth) and arguments.smallImageWidth or arguments.smallImageWidth eq 'AUTO'>
		<cfset variables.instance.smallImageWidth = arguments.smallImageWidth />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setSmallImageHeight" access="public" output="true">
	<cfargument name="smallImageHeight" type="any" required="yes" default="0" />
	<cfif isNumeric(arguments.smallImageHeight) and arguments.smallImageHeight or arguments.smallImageHeight eq 'AUTO'>
		<cfset variables.instance.smallImageHeight = arguments.smallImageHeight />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMediumImageWidth" access="public" output="true">
	<cfargument name="mediumImageWidth" type="any" required="yes" default="0" />
	<cfif isNumeric(arguments.mediumImageWidth) and arguments.mediumImageWidth or arguments.mediumImageWidth eq 'AUTO'>
		<cfset variables.instance.mediumImageWidth = arguments.mediumImageWidth />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMediumImageHeight" access="public" output="true">
	<cfargument name="mediumImageHeight" type="any" required="yes" default="0" />
	<cfif isNumeric(arguments.mediumImageHeight) and arguments.mediumImageHeight or arguments.mediumImageHeight eq 'AUTO'>
		<cfset variables.instance.mediumImageHeight = arguments.mediumImageHeight />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setLargeImageWidth" access="public" output="true">
	<cfargument name="largeImageWidth" type="any" required="yes" default="0" />
	<cfif isNumeric(arguments.largeImageWidth) and  arguments.largeImageWidth or arguments.largeImageWidth eq 'AUTO'>
		<cfset variables.instance.largeImageWidth = arguments.largeImageWidth />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setLargeImageHeight" access="public" output="true">
	<cfargument name="largeImageHeight" type="any" required="yes" default="0" />
	<cfif isNumeric(arguments.largeImageHeight) and  arguments.largeImageHeight or arguments.largeImageHeight eq 'AUTO'>
		<cfset variables.instance.largeImageHeight = arguments.largeImageHeight />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getGallerySmallScale" output="false" hint="for legacy compatability">
	<cfreturn variables.instance.smallImageWidth>
</cffunction>

<cffunction name="getGalleryMediumScale" output="false" hint="for legacy compatability">
	<cfreturn variables.instance.mediumImageWidth>
</cffunction>

<cffunction name="getGalleryMainScale" output="false" hint="for legacy compatability">
	<cfreturn variables.instance.largeImageWidth>
</cffunction>

<cffunction name="getLoginURL" returntype="String" access="public" output="false">
	<cfargument name="parseMuraTag" default="true">
	
	<cfif variables.instance.loginURL neq ''> 
		<cfif arguments.parseMuraTag>	
			<cfreturn getContentRenderer().setDynamicContent(variables.instance.LoginURL) />
		<cfelse>
			<cfreturn variables.instance.LoginURL />
		</cfif>
	<cfelse>
	<cfreturn "#variables.configBean.getIndexFile()#?display=login" />
	</cfif>
</cffunction>

<cffunction name="getEditProfileURL" returntype="String" access="public" output="false">
	<cfargument name="parseMuraTag" default="true"> 
	<cfif variables.instance.EditProfileURL neq ''>
		<cfif arguments.parseMuraTag>	
			<cfreturn getContentRenderer().setDynamicContent(variables.instance.EditProfileURL) />
		<cfelse>
			<cfreturn variables.instance.EditProfileURL />
		</cfif>
	<cfelse>
	<cfreturn "#variables.configBean.getIndexFile()#?display=editProfile" />
	</cfif>
</cffunction>

<cffunction name="setLastDeployment" access="public" output="false">
	<cfargument name="LastDeployment" type="String" />
	<cfset variables.instance.LastDeployment = parseDateArg(arguments.LastDeployment)/>
	<cfreturn this>
</cffunction>

<cffunction name="setHasComments" access="public" output="false">
	<cfargument name="hasComments"  />
	<cfif isNumeric(arguments.hasComments)>
		<cfset variables.instance.hasComments = arguments.hasComments />
	</cfif>
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
	<cfargument name="MailServerSMTPPort" type="String" />
	<cfif isNumeric(arguments.MailServerSMTPPort)>
	<cfset variables.instance.mailServerSMTPPort = arguments.MailServerSMTPPort />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMailServerPOPPort" access="public" output="false">
	<cfargument name="MailServerPOPPort" type="String" />
	<cfif isNumeric(arguments.MailServerPOPPort)>
	<cfset variables.instance.mailServerPOPPort = arguments.MailServerPOPPort />
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
		<!---<cfif not variables.instance.cacheCapacity>--->
			<cfset variables.instance.cacheFactories["#arguments.name#"]=application.settingsManager.createCacheFactory(freeMemoryThreshold=variables.instance.cacheFreeMemoryThreshold,name=arguments.name,siteID=variables.instance.siteID)>
		<!---
		<cfelse>
			<cfset variables.instance.cacheFactories["#arguments.name#"]=application.settingsManager.createCacheFactory(capacity=variables.instance.cacheCapacity,freeMemoryThreshold=variables.instance.cacheFreeMemoryThreshold,name=arguments.name,siteID=variables.instance.siteID)>
		</cfif>
		--->
		<cfreturn variables.instance.cacheFactories["#arguments.name#"] />
	</cfif>
	
</cffunction>

<cffunction name="purgeCache" access="public" output="false">
	<cfargument name="name" default="output" hint="data, output or both">
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
		<cfset variables.instance.javaLocale=application.rbFactory.CF2Java(variables.configBean.getDefaultLocale())>
	</cfif>
	<cfreturn variables.instance.javaLocale />
</cffunction>

<cffunction name="getRBFactory" returntype="any" access="public" output="false">
	<cfset var tmpFactory="">
	<cfset var themeRBDir="">
	<cfif not isObject(variables.instance.rbFactory)>
		<cfset tmpFactory=createObject("component","mura.resourceBundle.resourceBundleFactory").init(application.rbFactory,"#expandPath('/#variables.configBean.getWebRootMap()#')#/#variables.instance.displayPoolID#/includes/resourceBundles/",getJavaLocale())>
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

<cffunction name="getJSDateKeyObjInc" returntype="String" access="public" output="false">
	<cfif not len(variables.instance.jsDateKeyObjInc)>
		<cfset variables.instance.jsDateKeyObjInc=getLocaleUtils().getJsDateKeyObjInc()>
	</cfif>
	<cfreturn variables.instance.jsDateKeyObjInc />
</cffunction>

<cffunction name="getLocaleUtils" returntype="any" access="public" output="false">
	<cfreturn getRBFactory().getUtils() />
</cffunction>
s
<cffunction name="getAssetPath" returntype="any" access="public" output="false">
	<cfreturn getResourcePath() & "/#variables.instance.displayPoolID#" />
</cffunction>

<cffunction name="getIncludePath" returntype="any" access="public" output="false">
	<cfreturn "/#variables.configBean.getWebRootMap()#/#variables.instance.displayPoolID#" />
</cffunction>

<cffunction name="getAssetMap" returntype="any" access="public" output="false">
	<cfreturn "#variables.configBean.getWebRootMap()#.#variables.instance.displayPoolID#" />
</cffunction>

<cffunction name="getThemeAssetPath" returntype="any" access="public" output="false">
	<cfargument name="theme" default="#request.altTheme#">
	
	<cfif len(arguments.theme) and directoryExists(getTemplateIncludeDir(arguments.theme))>
		<cfreturn getAssetPath() & "/includes/themes/#arguments.theme#" />
	<cfelseif len(variables.instance.theme)>
		<cfreturn  getAssetPath() & "/includes/themes/#variables.instance.theme#" />
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
		<cfreturn "#expandPath('/#variables.configBean.getWebRootMap()#')#/#variables.instance.displayPoolID#/includes/themes/#arguments.theme#/templates">
	<cfelseif len(variables.instance.theme)>
		<cfreturn "#expandPath('/#variables.configBean.getWebRootMap()#')#/#variables.instance.displayPoolID#/includes/themes/#variables.instance.theme#/templates">
	<cfelse>
		<cfreturn "#expandPath('/#variables.configBean.getWebRootMap()#')#/#variables.instance.displayPoolID#/includes/templates">
	</cfif>
</cffunction>

<cffunction name="getThemes" returntype="query" access="public" output="false">
	<cfset var rs = "">
	<cfset var themeDir="">
	
	<cfif len(variables.instance.displayPoolID)>
		<cfset themeDir="#expandPath('/#variables.configBean.getWebRootMap()#')#/#variables.instance.displayPoolID#/includes/themes">
	<cfelse>
		<cfset themeDir="#expandPath('/#variables.configBean.getWebRootMap()#')#/default/includes/themes">
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
	<cfcase value="Component,Email">
		
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
	<cfargument name="enforcePrimaryDomain" default="false">
	<cfset var i="">
	<cfset var lineBreak=chr(13)&chr(10)>
	
	<cfif arguments.enforcePrimaryDomain and variables.instance.enforcePrimaryDomain>
		<cfif arguments.domain eq getDomain()>
			<cfreturn true>
		</cfif>
	<cfelse>
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
	</cfif>

	<cfreturn false>
</cffunction>

<cffunction name="getLocalHandler" output="false">
	<cfset var localHandler="">
	<cfif fileExists(expandPath("/#application.configBean.getWebRootMap()#") & "/#getValue('siteid')#/includes/eventHandler.cfc")>
		<cfset localHandler=createObject("component","#application.configBean.getWebRootMap()#.#getValue('siteid')#.includes.eventHandler").init()>
		<cfset localHandler.setValue("_objectName","#application.configBean.getWebRootMap()#.#getValue('siteid')#.includes.eventHandler")>
	<cfelseif getValue('displaypoolid') neq getValue('siteid') and fileExists(expandPath("/#application.configBean.getWebRootMap()#") & "/#getValue('displaypoolid')#/includes/eventHandler.cfc")>
		<cfset localHandler=createObject("component","#application.configBean.getWebRootMap()#.#getValue('displaypoolid')#.includes.eventHandler").init()>
		<cfset localHandler.setValue("_objectName","#application.configBean.getWebRootMap()#.#getValue('displaypoolid')#.includes.eventHandler")>
	</cfif>
	<cfreturn localHandler>
</cffunction>

<cffunction name="getContentRenderer" output="false">
<cfargument name="$" default="">
<cfif not isObject(arguments.$)>
	<cfif not isObject(variables.instance.contentRenderer)>
		<cfset arguments.$=getBean("$").init(getValue('siteid'))>
		<cfset variables.instance.contentRenderer=arguments.$.getContentRenderer()>
	</cfif>
	<cfreturn variables.instance.contentRenderer>
<cfelse>
	<cfreturn arguments.$.getContentRenderer()>
</cfif>
</cffunction>

<cffunction name="getApi" output="false">
<cfargument name="type" default="json">
<cfargument name="version" default="v1">
	<cfif not isDefined('variables.instance.api#arguments.type##arguments.version#')>
		<cfset variables.instance['api#arguments.type##arguments.version#']=evaluate('new mura.client.api.#arguments.type#.#arguments.version#.apiUtility(siteid=getValue("siteid"))')>
	</cfif>

	<cfreturn variables.instance['api#arguments.type##arguments.version#']>
</cffunction>

<cffunction name="getThemeRenderer" output="false" hint="deprecated: use getContentRenderer()">
<cfargument name="$" default="">
	<cfreturn getContentRenderer(arguments.$)>
</cffunction>

<cffunction name="exportHTML" output="false">
	<cfargument name="exportDir" default="">
	<cfif len(arguments.exportdir)>
		<cfset getBean("HTMLExporter").export(variables.instance.siteID,arguments.exportDir)>
	<cfelse>
		<cfset getBean("HTMLExporter").export(variables.instance.siteID,variables.instance.exportLocation)>
	</cfif>
</cffunction>

<cffunction name="save" returnType="any" output="false" access="public">
	<cfset setAllValues(application.settingsManager.save(this).getAllValues())>
	<cfreturn this />
</cffunction>

<cffunction name="getCustomImageSizeQuery" output="false">
	<cfargument name="reset" default="false">
	<cfset var rsCustomImageSizeQuery="">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsCustomImageSizeQuery')#">
		select sizeid,siteid,name,height,width from timagesizes where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteid#">
	</cfquery>
	
	<cfreturn rsCustomImageSizeQuery>
</cffunction>

<cffunction name="getCustomImageSizeIterator" output="false">
	<cfreturn getBean("imageSizeIterator").setQuery(getCustomImageSizeQuery())>
</cffunction>

<!---
	Not sure I want to expose this.
<cffunction name="delete" output="false" access="public">
	<cfset application.settingsManager.delete(variables.instance.siteID) />
</cffunction>
--->

<cffunction name="loadBy" returnType="any" output="false" access="public">
	<cfif not structKeyExists(arguments,"siteID")>
		<cfset arguments.siteID=variables.instance.siteID>
	</cfif>
	
	<cfset arguments.settingsBean=this>
	
	<cfreturn application.settingsManager.read(argumentCollection=arguments)>
</cffunction>

<cffunction name="getScheme" returntype="string" output="false">
	<cfreturn YesNoFormat(getValue('useSSL')) ? 'https' : 'http' />
</cffunction>

<cffunction name="getProtocol" returntype="string" output="false">
	<cfreturn UCase(getScheme()) />
</cffunction>

<cffunction name="getRazunaSettings" output="false">
	<cfif not structKeyExists(variables,'razunaSettings')>
		<cfset variables.razunaSettings=getBean('razunaSettings').loadBy(siteid=getValue('siteid'))>
	</cfif>
	<cfreturn variables.razunaSettings>
</cffunction>

<cffunction name="getContentPoolID" output="false">

	<cfif not listFindNoCase(variables.instance.contentPoolID,getValue('siteid'))>
		<!---<cfset variables.instance.contentPoolID=listAppend(arguments.contentPoolID,getValue('siteid'))>--->
	</cfif>

	<cfreturn variables.instance.contentPoolID>
</cffunction>

<cffunction name="getHasSharedFilePool" output="false">
	<cfif not isBoolean(variables.instance.hasSharedFilePool)>
		<cfif getValue('siteid') neq getValue('filePoolID')>
			<cfset variables.instance.hasSharedFilePool=true/>
		<cfelse>
			<cfset var rs="">
			<cfquery name="rs">
				select count(*) as counter from tsettings
				where filePoolID=<cfqueryparam cfsqltype="cf_sql_varchar" value='#getValue('siteid')#'>
				and siteid!=<cfqueryparam cfsqltype="cf_sql_varchar" value='#getValue('siteid')#'>
			</cfquery>
			<cfset variables.instance.hasSharedFilePool=rs.counter/>
		</cfif>
	</cfif>
	<cfreturn variables.instance.hasSharedFilePool>
</cffunction>

<cffunction name="setHasLockableNodes" access="public" output="false">
	<cfargument name="hasLockableNodes" type="String" />
	<cfif isNumeric(arguments.hasLockableNodes)>
	<cfset variables.instance.hasLockableNodes = arguments.hasLockableNodes />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setJSONApi" access="public" output="false">
	<cfargument name="JSONApi" type="String" />
	<cfif isNumeric(arguments.JSONApi)>
	<cfset variables.instance.JSONApi = arguments.JSONApi />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setIsRemote" access="public" output="false">
	<cfargument name="isRemote" type="String" />
	<cfif isNumeric(arguments.isRemote)>
	<cfset variables.instance.isRemote = arguments.isRemote />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setResourceSSL" access="public" output="false">
	<cfargument name="resourceSSL" type="String" />
	<cfif isNumeric(arguments.resourceSSL)>
	<cfset variables.instance.resourceSSL = arguments.resourceSSL />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setRemotePort" access="public" output="false">
	<cfargument name="RemotePort" type="String" />
	<cfif isNumeric(arguments.RemotePort)>
	<cfset variables.instance.RemotePort = arguments.RemotePort />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setUseSSL" access="public" output="false">
	<cfargument name="useSSL"  />
	<cfif isNumeric(arguments.useSSL)>
		<cfset variables.instance.useSSL = arguments.useSSL />
	</cfif>
	<cfreturn this>
</cffunction>


<cffunction name="getContext" output="false">
	<cfif getValue('isRemote')>
		<cfreturn getValue('RemoteContext')>
	<cfelse>
		<cfreturn application.configBean.getContext()>
	</cfif> 
</cffunction>

<cffunction name="getServerPort" output="false">
	<cfif getValue('isRemote')>
		<cfset var port=getValue('RemotePort')>
		<cfif isNumeric(port) and port neq 80>
			<cfreturn ":" & port>
		<cfelse>
			<cfreturn "">
		</cfif>
	<cfelse>
		<cfreturn application.configBean.getServerPort()>
	</cfif> 
</cffunction>

<cffunction name="getAdminPath" output="false">
	<cfreturn getBean('configBean').getAdminPath()>
</cffunction>

<cffunction name="getWebPath" output="false">
	<cfargument name="secure" default="#getValue('useSSL')#">
	<cfargument name="complete" default=0>
	<cfif arguments.secure or arguments.complete>
		<cfif arguments.secure>
			<cfreturn 'https://' & getValue('domain') & getServerPort() & getContext()>
		<cfelse>
			<cfreturn getScheme() & '://' & getValue('domain') & getServerPort() & getContext()>
		</cfif>
	<cfelse>
		<cfreturn getContext()>
	</cfif>
	
</cffunction>

<cffunction name="getResourcePath" output="false">
	<cfargument name="complete" default=0>
	<cfif getValue('isRemote') and len(getValue('resourceDomain'))>
		<cfset var configBean=getBean('configBean')>
		<cfif getValue('resourceSSL')>
			<cfreturn "https://" & getValue('resourceDomain') & configBean.getServerPort() & configBean.getContext()>
		<cfelse>
			<cfreturn "http://" & getValue('resourceDomain') & configBean.getServerPort() & configBean.getContext()>
		</cfif>
	<cfelseif arguments.complete>
		<cfreturn getWebPath(argumentCollection=arguments)>
	<cfelse>
		<cfreturn getContext()>
	</cfif>	
</cffunction>

<cffunction name="getRequirementsPath" output="false">
	<cfargument name="secure" default="#getValue('useSSL')#">
	<cfargument name="complete" default=0>
	<cfreturn getResourcePath(argumentCollection=arguments) & "/requirements">
</cffunction>

<cffunction name="getPluginsPath" output="false">
	<cfargument name="secure" default="#getValue('useSSL')#">
	<cfargument name="complete" default=0>
	<cfreturn getResourcePath(argumentCollection=arguments) & "/plugins">
</cffunction>

<cffunction name="getAccessControlOriginList" output="false">
	<cfset var thelist="#getScheme()#://#getValue('domain')#">
	<cfset var adminSSL=application.configBean.getAdminSSL()>
	<cfset var i="">
	<cfset var lineBreak=chr(13)&chr(10)>

	<cfif adminSSL and not YesNoFormat(getValue('useSSL'))>
		<cfset thelist = listAppend(thelist,"https://#getValue('domain')#")>
	</cfif>

	<cfif len(application.configBean.getAdminDomain())>
		<cfset thelist = listAppend(thelist,"#getScheme()#://#application.configBean.getAdminDomain()##application.configBean.getServerPort()#")>
		<cfif adminSSL and not YesNoFormat(getValue('useSSL'))>
			<cfset thelist = listAppend(thelist,"https://#application.configBean.getAdminDomain()##application.configBean.getServerPort()#")>
		</cfif>
	</cfif>
	
	<cfif len(getValue('domainAlias'))>
		<cfloop list="#getValue('domainAlias')#" delimiters="#lineBreak#" index="i">
			<cfset thelist = listAppend(thelist,"#getScheme()#://#i##getServerPort()#")>
			<cfif adminSSL and not YesNoFormat(getValue('useSSL'))>
				<cfset thelist = listAppend(thelist,"https://#i##getServerPort()#")>
			</cfif>	
		</cfloop>
	</cfif>

	<cfreturn thelist>
</cffunction>

<cffunction name="getVersion" output="false">
	<cfreturn getBean('autoUpdater').getCurrentVersion(getValue('siteid'))>
</cffunction>

</cfcomponent>
