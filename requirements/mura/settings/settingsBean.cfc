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
<cfcomponent extends="mura.bean.beanExtendable" entityName="site" table="tsettings" output="false" hint="Site settings bean">

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
<cfproperty name="EmailBroadcaster" type="numeric" default="0" required="false" />
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
<cfproperty name="filePoolID" type="string" default=""/>
<cfproperty name="placeholderImgID" type="string" default=""/>
<cfproperty name="feedManager" type="numeric" default="1" required="true" />
<cfproperty name="largeImageHeight" type="string" default="AUTO" required="true" />
<cfproperty name="largeImageWidth" type="numeric" default="600" required="true" />
<cfproperty name="smallImageHeight" type="string" default="80" required="true" />
<cfproperty name="smallImageWidth" type="numeric" default="80" required="true" />
<cfproperty name="mediumImageHeight" type="string" default="180" required="true" />
<cfproperty name="mediumImageWidth" type="numeric" default="180" required="true" />
<cfproperty name="sendLoginScript" type="string" default=""/>
<cfproperty name="sendAuthCodeScript" type="string" default=""/>
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
<cfproperty name="contentPendingScript" type="string" default=""/>
<cfproperty name="contentApprovalScript" type="string" default=""/>
<cfproperty name="contentRejectionScript" type="string" default=""/>
<cfproperty name="contentCanceledScript" type="string" default=""/>
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
<cfproperty name="showDashboard" type="numeric" default="0" />

<cfset variables.primaryKey = 'siteid'>
<cfset variables.entityName = 'site'>
<cfset variables.instanceName= 'site'>

<cffunction name="init" output="false">

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
	<cfset variables.instance.FilePoolID=""/>
	<cfset variables.instance.placeholderImgID="">
	<cfset variables.instance.feedManager=1/>
	<cfset variables.instance.largeImageHeight='AUTO'/>
	<cfset variables.instance.largeImageWidth='600'/>
	<cfset variables.instance.smallImageHeight='80'/>
	<cfset variables.instance.smallImageWidth='80'/>
	<cfset variables.instance.mediumImageHeight='180'/>
	<cfset variables.instance.mediumImageWidth='180'/>
	<cfset variables.instance.sendLoginScript=""/>
	<cfset variables.instance.sendAuthCodeScript=""/>
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
	<cfset variables.instance.contentPendingScript=""/>
	<cfset variables.instance.contentApprovalScript=""/>
	<cfset variables.instance.contentRejectionScript=""/>
	<cfset variables.instance.contentCanceledScript=""/>
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
	<cfset variables.instance.contentTypeFilePathLookup={}>
	<cfset variables.instance.contentTypeLoopUpArray=[]>
	<cfset variables.instance.displayObjectLookup={}/>
	<cfset variables.instance.displayObjectFilePathLookup={}/>
	<cfset variables.instance.displayObjectLoopUpArray=[]>
	<cfset variables.instance.showDashboard=0/>

	<cfreturn this />
</cffunction>

<cffunction name="validate" output="false">
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

<cffunction name="set" output="false">
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

<cffunction name="getDomain" output="false">
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

<cffunction name="setEnforcePrimaryDomain" output="false">
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

<cffunction name="setEnforceChangesets" output="false">
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

<cffunction name="setExportLocation" output="false">
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

<cffunction name="setMailServerUsernameEmail" output="false">
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

<cffunction name="getMailServerUsername" output="false">
	<cfargument name="forLogin" default="false" required="true">
	<cfif not arguments.forLogin or len(variables.instance.mailServerPassword)>
		<cfreturn variables.instance.mailServerUsername />
	<cfelse>
		<cfreturn ""/>
	</cfif>
</cffunction>

<cffunction name="setMailServerUsername" output="false">
	<cfargument name="MailServerUsername" type="String" />
	<cfset setMailServerUsernameEmail(arguments.MailServerUsername) />
	<cfset variables.instance.mailServerUsername = arguments.MailServerUsername />
	<cfreturn this>
</cffunction>

<cffunction name="setCacheCapacity" output="false">
	<cfargument name="cacheCapacity" />
	<cfif isNumeric(arguments.cacheCapacity)>
	<cfset variables.instance.cacheCapacity = arguments.cacheCapacity />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setCacheFreeMemoryThreshold" output="false">
	<cfargument name="cacheFreeMemoryThreshold" />
	<cfif isNumeric(arguments.cacheFreeMemoryThreshold) and arguments.cacheFreeMemoryThreshold>
	<cfset variables.instance.cacheFreeMemoryThreshold = arguments.cacheFreeMemoryThreshold />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setSmallImageWidth" output="true">
	<cfargument name="smallImageWidth" type="any" required="yes" default="0" />
	<cfif isNumeric(arguments.smallImageWidth) and arguments.smallImageWidth or arguments.smallImageWidth eq 'AUTO'>
		<cfset variables.instance.smallImageWidth = arguments.smallImageWidth />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setSmallImageHeight" output="true">
	<cfargument name="smallImageHeight" type="any" required="yes" default="0" />
	<cfif isNumeric(arguments.smallImageHeight) and arguments.smallImageHeight or arguments.smallImageHeight eq 'AUTO'>
		<cfset variables.instance.smallImageHeight = arguments.smallImageHeight />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMediumImageWidth" output="true">
	<cfargument name="mediumImageWidth" type="any" required="yes" default="0" />
	<cfif isNumeric(arguments.mediumImageWidth) and arguments.mediumImageWidth or arguments.mediumImageWidth eq 'AUTO'>
		<cfset variables.instance.mediumImageWidth = arguments.mediumImageWidth />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMediumImageHeight" output="true">
	<cfargument name="mediumImageHeight" type="any" required="yes" default="0" />
	<cfif isNumeric(arguments.mediumImageHeight) and arguments.mediumImageHeight or arguments.mediumImageHeight eq 'AUTO'>
		<cfset variables.instance.mediumImageHeight = arguments.mediumImageHeight />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setLargeImageWidth" output="true">
	<cfargument name="largeImageWidth" type="any" required="yes" default="0" />
	<cfif isNumeric(arguments.largeImageWidth) and  arguments.largeImageWidth or arguments.largeImageWidth eq 'AUTO'>
		<cfset variables.instance.largeImageWidth = arguments.largeImageWidth />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setLargeImageHeight" output="true">
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

<cffunction name="getLoginURL" output="false">
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

<cffunction name="getEditProfileURL" output="false">
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

<cffunction name="setLastDeployment" output="false">
	<cfargument name="LastDeployment" type="String" />
	<cfset variables.instance.LastDeployment = parseDateArg(arguments.LastDeployment)/>
	<cfreturn this>
</cffunction>

<cffunction name="setHasComments" output="false">
	<cfargument name="hasComments"  />
	<cfif isNumeric(arguments.hasComments)>
		<cfset variables.instance.hasComments = arguments.hasComments />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setUseDefaultSMTPServer" output="false">
	<cfargument name="UseDefaultSMTPServer"  />
	<cfif isNumeric(arguments.UseDefaultSMTPServer)>
		<cfset variables.instance.UseDefaultSMTPServer = arguments.UseDefaultSMTPServer />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMailServerSMTPPort" output="false">
	<cfargument name="MailServerSMTPPort" type="String" />
	<cfif isNumeric(arguments.MailServerSMTPPort)>
	<cfset variables.instance.mailServerSMTPPort = arguments.MailServerSMTPPort />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMailServerPOPPort" output="false">
	<cfargument name="MailServerPOPPort" type="String" />
	<cfif isNumeric(arguments.MailServerPOPPort)>
	<cfset variables.instance.mailServerPOPPort = arguments.MailServerPOPPort />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMailServerTLS" output="false">
	<cfargument name="mailServerTLS" type="String" />
	<cfif isBoolean(arguments.mailServerTLS)>
	<cfset variables.instance.mailServerTLS = arguments.mailServerTLS />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMailServerSSL" output="false">
	<cfargument name="mailServerSSL" type="String" />
	<cfif isBoolean(arguments.mailServerSSL)>
	<cfset variables.instance.mailServerSSL = arguments.mailServerSSL />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getCacheFactory" output="false">
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

<cffunction name="purgeCache" output="false">
	<cfargument name="name" default="output" hint="data, output or both">
	<cfargument name="broadcast" default="true">
	<cfset getCacheFactory(name=arguments.name).purgeAll()>
	<cfif arguments.broadcast>
		<cfset getBean("clusterManager").purgeCache(siteID=variables.instance.siteID,name=arguments.name)>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getJavaLocale" output="false">
	<cfif len(variables.instance.siteLocale)>
		<cfset variables.instance.javaLocale=application.rbFactory.CF2Java(variables.instance.siteLocale)>
	<cfelse>
		<cfset variables.instance.javaLocale=application.rbFactory.CF2Java(variables.configBean.getDefaultLocale())>
	</cfif>
	<cfreturn variables.instance.javaLocale />
</cffunction>

<cffunction name="getRBFactory" output="false">
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

<cffunction name="setRBFactory" output="false">
	<cfargument name="rbFactory">
	<cfif not isObject(arguments.rbFactory)>
		<cfset variables.instance.rbFactory=arguments.rbFactory />
	</cfif>
	<cfreturn this />
</cffunction>

<cffunction name="getJSDateKey" output="false">
	<cfif not len(variables.instance.jsDateKey)>
		<cfset variables.instance.jsDateKey=getLocaleUtils().getJSDateKey()>
	</cfif>
	<cfreturn variables.instance.jsDateKey />
</cffunction>

<cffunction name="getJSDateKeyObjInc" output="false">
	<cfif not len(variables.instance.jsDateKeyObjInc)>
		<cfset variables.instance.jsDateKeyObjInc=getLocaleUtils().getJsDateKeyObjInc()>
	</cfif>
	<cfreturn variables.instance.jsDateKeyObjInc />
</cffunction>

<cffunction name="getLocaleUtils" output="false">
	<cfreturn getRBFactory().getUtils() />
</cffunction>

<cffunction name="getAssetPath" output="false">
	<cfargument name="complete" default=0>
	<cfargument name="domain" default="#getValue('domain')#">
	<cfreturn getResourcePath(argumentCollection=arguments) & "/#variables.instance.displayPoolID#" />
</cffunction>

<cffunction name="getFileAssetPath" output="false">
	<cfargument name="complete" default=0>
	<cfargument name="domain" default="#getValue('domain')#">
	<cfreturn getResourcePath(argumentCollection=arguments) & "/#variables.instance.filePoolID#" />
</cffunction>

<cffunction name="getIncludePath" output="false">
	<cfreturn "/#variables.configBean.getWebRootMap()#/#variables.instance.displayPoolID#" />
</cffunction>

<cffunction name="getAssetMap" output="false">
	<cfreturn "#variables.configBean.getWebRootMap()#.#variables.instance.displayPoolID#" />
</cffunction>

<cffunction name="getThemeAssetPath" output="false">
	<cfargument name="theme" default="#request.altTheme#">
	<cfargument name="complete" default=0>
	<cfargument name="domain" default="#getValue('domain')#">

	<cfif len(arguments.theme) and directoryExists(getTemplateIncludeDir(arguments.theme))>
		<cfreturn getAssetPath(argumentCollection=arguments) & "/includes/themes/#arguments.theme#" />
	<cfelseif len(variables.instance.theme)>
		<cfreturn  getAssetPath(argumentCollection=arguments) & "/includes/themes/#variables.instance.theme#" />
	<cfelse>
		<cfreturn getAssetPath(argumentCollection=arguments) />
	</cfif>
</cffunction>

<cffunction name="getThemeIncludePath" output="false">
	<cfargument name="theme" default="#request.altTheme#">

	<cfif len(arguments.theme) and directoryExists(getTemplateIncludeDir(arguments.theme))>
		<cfreturn "#getIncludePath()#/includes/themes/#arguments.theme#" />
	<cfelseif len(variables.instance.theme)>
		<cfreturn "#getIncludePath()#/includes/themes/#variables.instance.theme#" />
	<cfelse>
		<cfreturn getIncludePath() />
	</cfif>
</cffunction>

<cffunction name="getThemeAssetMap" output="false">
	<cfargument name="theme" default="#request.altTheme#">

	<cfif len(arguments.theme) and directoryExists(getTemplateIncludeDir(arguments.theme))>
		<cfreturn "#getAssetMap()#.includes.themes.#arguments.theme#" />
	<cfelseif len(variables.instance.theme)>
		<cfreturn "#getAssetMap()#.includes.themes.#variables.instance.theme#" />
	<cfelse>
		<cfreturn getAssetMap() />
	</cfif>
</cffunction>

<cffunction name="getTemplateIncludePath" output="false">
	<cfargument name="theme" default="#request.altTheme#">

	<cfif len(arguments.theme) and directoryExists(getTemplateIncludeDir(arguments.theme))>
		<cfreturn "#getIncludePath()#/includes/themes/#arguments.theme#/templates" />
	<cfelseif len(variables.instance.theme)>
		<cfreturn "#getIncludePath()#/includes/themes/#variables.instance.theme#/templates" />
	<cfelse>
		<cfreturn "#getIncludePath()#/includes/templates" />
	</cfif>
</cffunction>

<cffunction name="hasNonThemeTemplates" output="false">
	<cfreturn directoryExists(expandPath("#getIncludePath()#/includes/templates")) />
</cffunction>

<cffunction name="getTemplateIncludeDir" output="false">
	<cfargument name="theme" default="#request.altTheme#">

	<cfif len(arguments.theme)>
		<cfreturn "#expandPath('/#variables.configBean.getWebRootMap()#')#/#variables.instance.displayPoolID#/includes/themes/#arguments.theme#/templates">
	<cfelseif len(variables.instance.theme)>
		<cfreturn "#expandPath('/#variables.configBean.getWebRootMap()#')#/#variables.instance.displayPoolID#/includes/themes/#variables.instance.theme#/templates">
	<cfelse>
		<cfreturn "#expandPath('/#variables.configBean.getWebRootMap()#')#/#variables.instance.displayPoolID#/includes/templates">
	</cfif>
</cffunction>

<cffunction name="getThemes" output="false">
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

<cffunction name="getTemplates" output="false">
	<cfargument name="type" required="true" default="">
	<cfset var rs = "">
	<cfset var dir="">

	<cfswitch expression="#arguments.type#">
	<cfcase value="Component,Email">

		<cfset dir="#getTemplateIncludeDir()#/#lcase(arguments.type)#s">

		<cfif directoryExists(dir)>
			<cfdirectory action="list" directory="#dir#" name="rs" filter="*.cfm|*.html|*.htm|*.hbs">
			<cfquery name="rs" dbType="query">
			select * from rs order by name
			</cfquery>
		<cfelse>
			<cfset rs=queryNew("empty")>
		</cfif>
	</cfcase>
	<cfdefaultcase>

		<cfdirectory action="list" directory="#getTemplateIncludeDir()#" name="rs" filter="*.cfm|*.html|*.htm|*.hbs">
		<cfquery name="rs" dbType="query">
			select * from rs order by name
		</cfquery>
	</cfdefaultcase>
	</cfswitch>

	<cfreturn rs />
</cffunction>

<cffunction name="getLayouts" output="false">
	<cfargument name="type" required="true" default="collection/layouts">

	<cfparam name="variables.instance.collectionLayouts" default="">

	<cfif not isQuery(variables.instance.collectionLayouts)>

		<cfset var rsFinal = queryNew('name','varchar')>
		<cfset var rs = "">
		<cfset var dir = "">

		<cfloop array="#variables.instance.displayObjectLoopUpArray#" index="dir">
			<cfset dir=expandPath('#dir##trim(arguments.type)#')>

			<cfif directoryExists(dir)>
				<cfdirectory action="list" directory="#dir#" name="rs" type="dir">

				<cfif rs.recordcount>
					<cfquery name="rsFinal" dbType="query">
						select name from rsFinal

						union

						select name from rs
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>

		<cfquery name="rsFinal" dbType="query">
			select distinct name from rsFinal
			order by name asc
		</cfquery>

		<cfset variables.instance.collectionLayouts=rsFinal>
	</cfif>

	<cfreturn variables.instance.collectionLayouts />
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
	<cfif not isObject(variables.instance.contentRenderer)>
		<cfset arguments.$=getBean("$").init(getValue('siteid'))>
		<cfset variables.instance.contentRenderer=arguments.$.getContentRenderer(force=true)>
	</cfif>
	<cfreturn variables.instance.contentRenderer>
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
	<cfreturn getContentRenderer()>
</cffunction>

<cffunction name="exportHTML" output="false">
	<cfargument name="exportDir" default="">
	<cfif len(arguments.exportdir)>
		<cfset getBean("HTMLExporter").export(variables.instance.siteID,arguments.exportDir)>
	<cfelse>
		<cfset getBean("HTMLExporter").export(variables.instance.siteID,variables.instance.exportLocation)>
	</cfif>
</cffunction>

<cffunction name="save" output="false">
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
<cffunction name="delete" output="false">
	<cfset application.settingsManager.delete(variables.instance.siteID) />
</cffunction>
--->

<cffunction name="loadBy" output="false">
	<cfif not structKeyExists(arguments,"siteID")>
		<cfset arguments.siteID=variables.instance.siteID>
	</cfif>

	<cfset arguments.settingsBean=this>

	<cfreturn application.settingsManager.read(argumentCollection=arguments)>
</cffunction>

<cffunction name="getScheme" output="false">
	<cfreturn YesNoFormat(getValue('useSSL')) ? 'https' : 'http' />
</cffunction>

<cffunction name="getProtocol" output="false">
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

<cffunction name="setHasLockableNodes" output="false">
	<cfargument name="hasLockableNodes" type="String" />
	<cfif isNumeric(arguments.hasLockableNodes)>
	<cfset variables.instance.hasLockableNodes = arguments.hasLockableNodes />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setJSONApi" output="false">
	<cfargument name="JSONApi" type="String" />
	<cfif isNumeric(arguments.JSONApi)>
	<cfset variables.instance.JSONApi = arguments.JSONApi />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setIsRemote" output="false">
	<cfargument name="isRemote" type="String" />
	<cfif isNumeric(arguments.isRemote)>
	<cfset variables.instance.isRemote = arguments.isRemote />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setResourceSSL" output="false">
	<cfargument name="resourceSSL" type="String" />
	<cfif isNumeric(arguments.resourceSSL)>
	<cfset variables.instance.resourceSSL = arguments.resourceSSL />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setRemotePort" output="false">
	<cfargument name="RemotePort" type="String" />
	<cfif isNumeric(arguments.RemotePort)>
	<cfset variables.instance.RemotePort = arguments.RemotePort />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setUseSSL" output="false">
	<cfargument name="useSSL">

	<cfif isBoolean(arguments.useSSL)>
		<cfif arguments.useSSL>
			<cfset variables.instance.useSSL=1>
			<cfset variables.instance.extranetSSL=1>
		<cfelse>
			<cfset variables.instance.useSSL=0>
			<cfset variables.instance.extranetSSL=0>
		</cfif>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setShowDashboard" output="false">
	<cfargument name="showDashboard">

	<cfif isBoolean(arguments.showDashboard)>
		<cfif arguments.showDashboard>
			<cfset variables.instance.showDashboard=1>
		<cfelse>
			<cfset variables.instance.showDashboard=0>
		</cfif>
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
		<cfif isNumeric(port) and !ListFind('80,443', port)>
			<cfreturn ":" & port>
		<cfelse>
			<cfreturn "">
		</cfif>
	<cfelse>
		<cfreturn application.configBean.getServerPort()>
	</cfif>
</cffunction>

<cffunction name="getAdminPath" output="false">
	<cfargument name="useProtocol" default="1">
	<cfreturn getBean('configBean').getAdminPath(argumentCollection=arguments)>
</cffunction>

<cffunction name="getWebPath" output="false">
	<cfargument name="secure" default="#getValue('useSSL')#">
	<cfargument name="complete" default=0>
	<cfargument name="domain" default="">
	<cfargument name="useProtocol" default="1">

	<cfif arguments.secure or arguments.complete>

		<cfif len(request.muraPreviewDomain) and isValidDomain(domain=request.muraPreviewDomain,mode='complete')>
			<cfset arguments.domain=request.muraPreviewDomain>
		</cfif>

		<cfif not isDefined('arguments.domain') or not len(arguments.domain)>
			<cfif len(cgi.server_name) and isValidDomain(domain=cgi.server_name,mode='complete')>
				<cfset arguments.domain=cgi.server_name>
			<cfelse>
				<cfset arguments.domain=getValue('domain')>
			</cfif>
		</cfif>

		<cfif arguments.useProtocol>
			<cfif arguments.secure>
				<cfreturn 'https://' & arguments.domain & getServerPort() & getContext()>
			<cfelse>
				<cfreturn getScheme() & '://' & arguments.domain & getServerPort() & getContext()>
			</cfif>
		<cfelse>
			<cfreturn '//' & arguments.domain & getServerPort() & getContext()>
		</cfif>

	<cfelse>
		<cfreturn getContext()>
	</cfif>

</cffunction>

<cffunction name="getEndpoint" output="false">
	<cfargument name="secure" default="#getValue('useSSL')#">
	<cfargument name="complete" default=0>
	<cfargument name="domain" default="">
	<cfargument name="useProtocol" default="1">
	<cfreturn getWebPath(argumentCollection=arguments)>
</cffunction>

<cffunction name="getRootPath" output="false">
	<cfargument name="secure" default="#getValue('useSSL')#">
	<cfargument name="complete" default=0>
	<cfargument name="domain" default="">
	<cfargument name="useProtocol" default="1">
	<cfreturn getWebPath(argumentCollection=arguments)>
</cffunction>

<cffunction name="getResourcePath" output="false">
	<cfargument name="complete" default=0>
	<cfargument name="domain" default="">
	<cfargument name="useProtocol" default="1">

	<cfif len(request.muraPreviewDomain) and isValidDomain(domain=request.muraPreviewDomain,mode='complete')>
		<cfset arguments.domain=request.muraPreviewDomain>
	</cfif>

	<cfif not isDefined('arguments.domain') or not len(arguments.domain)>
		<cfif len(cgi.server_name) and isValidDomain(domain=cgi.server_name,mode='complete')>
			<cfset arguments.domain=cgi.server_name>
		<cfelse>
			<cfset arguments.domain=getValue('domain')>
		</cfif>
	</cfif>

	<cfif getValue('isRemote') and len(getValue('resourceDomain'))>
		<cfset var configBean=getBean('configBean')>

		<cfif arguments.useProtocol>
			<cfif getValue('resourceSSL')>
				<cfreturn "https://" & getValue('resourceDomain') & configBean.getServerPort() & configBean.getContext()>
			<cfelse>
				<cfreturn "http://" & getValue('resourceDomain') & configBean.getServerPort() & configBean.getContext()>
			</cfif>
		<cfelse>
			<cfreturn "//" & getValue('resourceDomain') & configBean.getServerPort() & configBean.getContext()>
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
	<cfargument name="useProtocol" default="1">
	<cfreturn getResourcePath(argumentCollection=arguments) & "/requirements">
</cffunction>

<cffunction name="getPluginsPath" output="false">
	<cfargument name="secure" default="#getValue('useSSL')#">
	<cfargument name="complete" default=0>
	<cfargument name="useProtocol" default="1">
	<cfreturn getResourcePath(argumentCollection=arguments) & "/plugins">
</cffunction>

<cffunction name="getAccessControlOriginList" output="false">
	<cfset var thelist="http://#getValue('domain')#,https://#getValue('domain')#">
	<cfset var adminSSL=application.configBean.getAdminSSL()>
	<cfset var i="">
	<cfset var lineBreak=chr(13)&chr(10)>
	<cfset var theurl = "#getValue('domain')##application.configBean.getServerPort()#">

	<cfif not ListFindNoCase(thelist, 'http://#theurl#')>
		<cfset thelist = listAppend(thelist,'http://#theurl#')>
	</cfif>
	<cfif not ListFindNoCase(thelist, 'https://#theurl#')>
		<cfset thelist = listAppend(thelist,'https://#theurl#')>
	</cfif>

	<cfset theurl = "#getValue('domain')#:#cgi.server_port#">
	<cfif not ListFindNoCase(thelist, 'http://#theurl#')>
		<cfset thelist = listAppend(thelist,'http://#theurl#')>
	</cfif>
	<cfif not ListFindNoCase(thelist, 'https://#theurl#')>
		<cfset thelist = listAppend(thelist,'https://#theurl#')>
	</cfif>

	<cfif len(application.configBean.getAdminDomain())>
		<cfset theurl="#application.configBean.getAdminDomain()#">
		<cfif not ListFindNoCase(thelist, 'http://#theurl#')>
			<cfset thelist = listAppend(thelist,theurl)>
		</cfif>
		<cfif not ListFindNoCase(thelist, 'https://#theurl#')>
			<cfset thelist = listAppend(thelist,theurl)>
		</cfif>

		<cfset theurl="#application.configBean.getAdminDomain()##application.configBean.getServerPort()#">
		<cfif not ListFindNoCase(thelist, 'http://#theurl#')>
			<cfset thelist = listAppend(thelist,theurl)>
		</cfif>
		<cfif not ListFindNoCase(thelist, 'https://#theurl#')>
			<cfset thelist = listAppend(thelist,theurl)>
		</cfif>

		<cfset theurl="#application.configBean.getAdminDomain()#:#cgi.server_port#">
		<cfif not ListFindNoCase(thelist, 'http://#theurl#')>
			<cfset thelist = listAppend(thelist,theurl)>
		</cfif>
		<cfif not ListFindNoCase(thelist, 'https://#theurl#')>
			<cfset thelist = listAppend(thelist,theurl)>
		</cfif>

	</cfif>

	<cfif len(getValue('domainAlias'))>
		<cfloop list="#getValue('domainAlias')#" delimiters="#lineBreak#" index="i">
			<cfset theurl = "#i##getServerPort()#" />
			<cfif not ListFindNoCase(thelist, 'http://#theurl#')>
				<cfset thelist = listAppend(thelist,"http://#theurl#")>
			</cfif>
			<cfif not ListFindNoCase(thelist, 'https://#theurl#')>
				<cfset thelist = listAppend(thelist,"https://#theurl#")>
			</cfif>

			<cfset theurl = "#i#:#cgi.server_port#" />
			<cfif not ListFindNoCase(thelist, 'http://#theurl#')>
				<cfset thelist = listAppend(thelist,"http://#theurl#")>
			</cfif>
			<cfif not ListFindNoCase(thelist, 'https://#theurl#')>
				<cfset thelist = listAppend(thelist,"https://#theurl#")>
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn thelist>
</cffunction>

<cffunction name="getVersion" output="false">
	<cfreturn getBean('autoUpdater').getCurrentVersion(getValue('siteid'))>
</cffunction>

<cffunction name="registerDisplayObject" output="false">
	<cfargument name="object">
	<cfargument name="name" default="">
	<cfargument name="displaymethod" default="">
	<cfargument name="displayObjectFile" default="">
	<cfargument name="configuratorInit" default="">
	<cfargument name="configuratorJS" default="">
	<cfargument name="contenttypes" default="">
	<cfargument name="omitcontenttypes" default="">
	<cfargument name="condition" default="true">
    <cfargument name="legacyObjectFile" default="">
	<cfargument name="custom" default="true">
	<cfargument name="iconclass" default="mi-cog">
	<cfargument name="cacheoutput" default="true">
	<cfset arguments.objectid=arguments.object>
	<cfset variables.instance.displayObjectLookup['#arguments.object#']=arguments>
	<cfreturn this>
</cffunction>

<cffunction name="clearFilePaths" output="false">
	<cfset variables.instance.displayObjectFilePathLookup=structNew()>
	<cfset variables.instance.contentTypeFilePathLookup=structNew()>
</cffunction>

<cffunction name="lookupContentTypeFilePath" output="false">
	<cfargument name="filePath">
	<cfargument name="customOnly" default="false">

	<cfset arguments.filePath=REReplace(listFirst(Replace(arguments.filePath, "\", "/", "ALL"),"/"), "[^a-zA-Z0-9_]", "", "ALL") & "/index.cfm">

	<cfif len(request.altTheme)>
		<cfset var altThemePath=getThemeIncludePath(request.altTheme) & "/content_types/" & arguments.filePath>
		<cfif fileExists(expandPath(altThemePath))>
			<cfreturn altThemePath>
		</cfif>
	</cfif>

	<cfif hasContentTypeFilePath(arguments.filePath)>
		<cfreturn getContentTypeFilePath(arguments.filePath)>
	</cfif>

	<cfset var dir="">
	<cfset var result="">
	<cfset var coreIndex=arrayLen(variables.instance.contentTypeLoopUpArray)-2>
	<cfset var dirIndex=0>

	<cfloop array="#variables.instance.contentTypeLoopUpArray#" index="dir">
		<cfset dirIndex=dirIndex+1>
		<cfif not arguments.customonly or dirIndex lt coreIndex>
			<cfset result=dir & arguments.filePath>
			<cfif fileExists(expandPath(result))>
				<cfset setContentTypeFilePath(arguments.filePath,result)>
				<cfreturn result>
			</cfif>
		</cfif>
	</cfloop>

	<cfset setContentTypeFilePath(arguments.filePath,"")>
	<cfreturn "">
</cffunction>

<cffunction name="hasContentTypeFilePath" output="false">
	<cfargument name="filepath">
	<cfreturn structKeyExists(variables.instance.contentTypeFilePathLookup,'#arguments.filepath#')>
</cffunction>

<cffunction name="getContentTypeFilePath" output="false">
	<cfargument name="filepath">
	<cfreturn variables.instance.contentTypeFilePathLookup['#arguments.filepath#']>
</cffunction>

<cffunction name="setContentTypeFilePath" output="false">
	<cfargument name="filepath">
	<cfargument name="result">
	<cfset variables.instance.contentTypeFilePathLookup['#arguments.filepath#']=arguments.result>
	<cfreturn this>
</cffunction>

<cffunction name="registerContentTypeDirs" output="false">
	<cfset var lookupArray=[
		getIncludePath()  & "/includes/content_types",
		getThemeIncludePath(getValue('theme')) & "/content_types"
	]>

	<cfset var dir="">
	<cfloop array="#lookupArray#" index="dir">
		<cfset registerContentTypeDir(dir=dir)>
	</cfloop>

	<cfset var rs="">

	<cfquery name="rs">
		select tplugins.package
		from tplugins inner join tcontent on tplugins.moduleid = tcontent.contentid
		where tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getValue('siteid')#">
		and tplugins.deployed=1
		order by tplugins.loadPriority desc
	</cfquery>

	<cfloop query="rs">
		<cfset registerContentTypeDir('/' & rs.package & '/content_types')>
	</cfloop>

	<cfreturn this>
</cffunction>

<cffunction name="registerContentTypeDir" output="false">
	<cfargument name="dir">

	<cfset var rs="">
	<cfset var config="">
	<cfset var expandedDir=expandPath(arguments.dir)>

	<cfif directoryExists(expandedDir)>
		<cfdirectory name="rs" directory="#expandedDir#" action="list" type="dir">
		<cfloop query="rs">

			<cfif fileExists('#expandedDir#/#rs.name#/config.xml.cfm')>
				<cfset config=new mura.executor().execute('#arguments.dir#/#rs.name#/config.xml.cfm')>
				<!---<cffile action="read" file="#rs.directory#/#rs.name#/config.xml.cfm" variable="config">--->
			<cfelseif fileExists('#expandedDir#/#rs.name#/config.xml')>
				<cffile action="read" file="#rs.directory#/#rs.name#/config.xml" variable="config">
			<cfelse>
				<cfset config="">
			</cfif>

			<cfif isXML(config)>
				<cfset config=xmlParse(config)>
				<cfset getBean('configBean').getClassExtensionManager().loadConfigXML(config,getValue('siteid'))>
			</cfif>

            <cfif directoryExists('#rs.directory#/#rs.name#/model')>
                <cfset variables.configBean.registerBeanDir(dir='#arguments.dir#/#rs.name#/model',siteid=getValue('siteid'))>
            </cfif>

			<cfif directoryExists('#rs.directory#/#rs.name#/display_objects')>
                <cfset registerDisplayObjectDir(dir='#arguments.dir#/#rs.name#/display_objects')>
            </cfif>

			<cfif directoryExists('#rs.directory#/#rs.name#/modules')>
                <cfset registerDisplayObjectDir(dir='#arguments.dir#/#rs.name#/modules',conditional=true)>
            </cfif>

			<cfif directoryExists('#rs.directory#/#rs.name#/content_types')>
                <cfset registerContentTypeDir(dir='#arguments.dir#/#rs.name#/content_types')>
            </cfif>

		</cfloop>

		<cfif not listFind('/,\',right(arguments.dir,1))>
			<cfset arguments.dir=arguments.dir & getBean('configBean').getFileDelim()>
		</cfif>
		<cfset arrayPrepend(variables.instance.contentTypeLoopUpArray,arguments.dir)>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="registerDisplayObjectDir" output="false">
	<cfargument name="dir">
	<cfargument name="conditional" default="true">
    <cfargument name="package" default="">
	<cfargument name="custom" default="true">
	<cfset var rs="">
	<cfset var config="">
	<cfset var objectArgs={}>
	<cfset var o="">
	<cfset var objectfound=(arguments.conditional) ? false : true>
	<cfset var expandedDir=expandPath(arguments.dir)>

	<cfif directoryExists(expandedDir)>
		<cfdirectory name="rs" directory="#expandedDir#" action="list" type="dir">
		<cfloop query="rs">
			<cfif fileExists('#expandedDir#/#rs.name#/config.xml.cfm')>
				<cfset config=new mura.executor().execute('#arguments.dir#/#rs.name#/config.xml.cfm')>
				<!---<cffile action="read" file="#rs.directory#/#rs.name#/config.xml.cfm" variable="config">---->
			<cfelseif fileExists('#expandedDir#/#rs.name#/config.xml')>
				<cffile action="read" file="#expandedDir#/#rs.name#/config.xml" variable="config">
			<cfelse>
				<cfset config="">
			</cfif>

			<cfif isXML(config)>

				<cfset config=xmlParse(config)>

				<cfif isDefined('config.displayobject.xmlAttributes.name') or isDefined('config.mura.xmlAttributes.name')>
					<cfset objectArgs={
						object=rs.name,
						custom=arguments.custom
						}>
					<cfif isDefined('config.displayobject.xmlAttributes.name')>
						<cfset var baseXML=config.displayobject>
					<cfelse>
						<cfset var baseXML=config.mura>
					</cfif>
                    <cfif isDefined('baseXML.xmlAttributes.legacyObjectFile')>
    					<cfset objectArgs.legacyObjectFile=rs.name & "/" & baseXML.xmlAttributes.legacyObjectFile>
                    </cfif>
					<cfif isDefined('baseXML.xmlAttributes.displayObjectFile')>
						<cfset objectArgs.displayObjectFile=rs.name & "/" & baseXML.xmlAttributes.displayObjectFile>
					<cfelseif isDefined('baseXML.xmlAttributes.component')>
						<cfset objectArgs.displayObjectFile=baseXML.xmlAttributes.component>
					<cfelse>
						<cfset objectArgs.displayObjectFile=rs.name & "/index.cfm">
					</cfif>
					<cfloop collection="#baseXML.xmlAttributes#" item="o">
                        <cfif not structKeyExists(objectArgs,o)>
					       <cfset objectArgs[o]=baseXML.xmlAttributes[o]>
                        </cfif>
					</cfloop>
					<cfset registerDisplayObject(
						argumentCollection=objectArgs
					)>
					<cfset objectfound=true>
					<cfset getBean('configBean').getClassExtensionManager().loadConfigXML(config,getValue('siteid'))>
				</cfif>

			</cfif>

            <cfif directoryExists('#rs.directory#/#rs.name#/model')>
                <cfset variables.configBean.registerBeanDir(dir='#arguments.dir#/#rs.name#/model',siteid=getValue('siteid'),package=arguments.package)>
            </cfif>

			<cfif directoryExists('#rs.directory#/#rs.name#/display_objects')>
                <cfset registerDisplayObjectDir(dir='#arguments.dir#/#rs.name#/display_objects')>
            </cfif>

			<cfif directoryExists('#rs.directory#/#rs.name#/modules')>
                <cfset registerDisplayObjectDir(dir='#arguments.dir#/#rs.name#/modules',conditional=true)>
            </cfif>

			<cfif directoryExists('#rs.directory#/#rs.name#/content_types')>
                <cfset registerContentTypeDir(dir='#arguments.dir#/#rs.name#/content_types')>
            </cfif>

		</cfloop>

		<cfif objectfound>
			<cfif not listFind('/,\',right(arguments.dir,1))>
				<cfset arguments.dir=arguments.dir & getBean('configBean').getFileDelim()>
			</cfif>
			<cfset arrayPrepend(variables.instance.displayObjectLoopUpArray,arguments.dir)>
		</cfif>

	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="registerModuleDir" output="false">
	<cfargument name="dir">
	<cfargument name="conditional" default="true">
    <cfargument name="package" default="">
	<cfargument name="custom" default="true">
    <cfreturn registerDisplayObjectDir(arguments=arguments)>
</cffunction>

<cffunction name="lookupDisplayObjectFilePath" output="false">
	<cfargument name="filePath">
	<cfargument name="customOnly" default="false">
	<cfset arguments.filePath=Replace(arguments.filePath, "\", "/", "ALL")>

	<cfif len(request.altTheme)>
		<cfset var altThemePath=getThemeIncludePath(request.altTheme) & "/display_objects/" & arguments.filePath>
		<cfif fileExists(expandPath(altThemePath))>
			<cfreturn altThemePath>
		</cfif>
	</cfif>

	<cfif hasDisplayObjectFilePath(arguments.filePath)>
		<cfreturn getDisplayObjectFilePath(arguments.filePath)>
	</cfif>

	<cfset var dir="">
	<cfset var result="">
	<cfset var coreIndex=arrayLen(variables.instance.displayObjectLoopUpArray)-2>
	<cfset var dirIndex=0>

	<cfloop array="#variables.instance.displayObjectLoopUpArray#" index="dir">
		<cfset dirIndex=dirIndex+1>
		<cfif not arguments.customonly or dirIndex lt coreIndex>
			<cfset result=dir & arguments.filePath>
			<cfif fileExists(expandPath(result))>
				<cfset setDisplayObjectFilePath(arguments.filePath,result)>
				<cfreturn result>
			</cfif>
		</cfif>
	</cfloop>

	<cfset setDisplayObjectFilePath(arguments.filePath,"")>
	<cfreturn "">
</cffunction>

<cffunction name="hasDisplayObject" output="false">
	<cfargument name="object">
	<cfreturn structKeyExists(variables.instance.displayObjectLookup,'#arguments.object#')>
</cffunction>

<cffunction name="getDisplayObject" output="false">
	<cfargument name="object">
	<cfreturn variables.instance.displayObjectLookup['#arguments.object#']>
</cffunction>

<cffunction name="hasDisplayObjectFilePath" output="false">
	<cfargument name="filepath">
	<cfreturn structKeyExists(variables.instance.displayObjectFilePathLookup,'#arguments.filepath#')>
</cffunction>

<cffunction name="getDisplayObjectFilePath" output="false">
	<cfargument name="filepath">
	<cfreturn variables.instance.displayObjectFilePathLookup['#arguments.filepath#']>
</cffunction>

<cffunction name="setDisplayObjectFilePath" output="false">
	<cfargument name="filepath">
	<cfargument name="result">
	<cfset variables.instance.displayObjectFilePathLookup['#arguments.filepath#']=arguments.result>
	<cfreturn this>
</cffunction>

<cffunction name="discoverDisplayObjects" output="false">
	<cfset var lookupArray=[
		'/muraWRM/admin/core/views/carch/objectclass',
		getIncludePath()  & "/includes/display_objects",
		getIncludePath()  & "/includes/display_objects/custom",
		getThemeIncludePath(getValue('theme')) & "/display_objects",
		getIncludePath()  & "/includes/modules",
		getThemeIncludePath(getValue('theme')) & "/modules"
	]>

	<cfset var dir="">
	<cfset var dirIndex=0>
	<cfset var custom=true>
	<cfset var conditional=false>

	<cfloop array="#lookupArray#" index="dir">
		<cfset dirIndex=dirIndex+1>
		<cfset custom=dirIndex gt 2>
		<cfset conditional=dirIndex gt 2>
		<cfset registerDisplayObjectDir(dir=dir,conditional=conditional,custom=custom)>
	</cfloop>

	<cfset var rs="">

	<cfquery name="rs">
		select tplugins.package
		from tplugins inner join tcontent on tplugins.moduleid = tcontent.contentid
		where tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getValue('siteid')#">
		and tplugins.deployed=1
		order by tplugins.loadPriority desc
	</cfquery>

	<cfloop query="rs">
		<cfset registerDisplayObjectDir('/' & rs.package & '/display_objects',true)>
		<cfset registerDisplayObjectDir('/' & rs.package & '/modules',true)>
	</cfloop>

	<cfreturn this>
</cffunction>

<cffunction name="getDisplayObjects">
	<cfreturn variables.instance.displayObjectLookup>
</cffunction>

<cffunction name="discoverBeans" output="false">
	<cfset var lookups=[
		'/muraWRM/#getValue('siteid')#/includes',
		'/muraWRM/#getValue('siteid')#/includes/themes/#getValue('theme')#'
		]>
	<cfset var i=1>
	<cfloop array="#lookups#" index="i">
		<cfset variables.configBean.registerBeanDir(dir='#i#/model',siteid=getValue('siteid'))>
	</cfloop>
	<cfreturn this>
</cffunction>

<cffunction name="getFileMetaData" output="false">
	<cfargument name="property" default="fileid">
	<cfreturn getBean('fileMetaData').loadBy(siteID=getValue('siteid'),fileid=getValue(arguments.property))>
</cffunction>

</cfcomponent>
