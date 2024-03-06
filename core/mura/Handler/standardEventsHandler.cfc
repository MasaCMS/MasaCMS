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

  Linking Mura CMS statically or dynamically with other modules constitutes
  the preparation of a derivative work based on Mura CMS. Thus, the terms
  and conditions of the GNU General Public License version 2 ("GPL") cover
  the entire combined work.

  However, as a special exception, the copyright holders of Mura CMS grant
  you permission to combine Mura CMS with programs or libraries that are
  released under the GNU Lesser General Public License version 2.1.

  In addition, as a special exception, the copyright holders of Mura CMS
  grant you permission to combine Mura CMS with independent software modules
  (plugins, themes and bundles), and to distribute these plugins, themes and
  bundles without Mura CMS under the license of your choice, provided that
  you follow these specific guidelines:

  Your custom code

  • Must not alter any default objects in the Mura CMS database and
  • May not alter the default display of the Mura CMS logo within Mura CMS and
  • Must not alter any files in the following directories:

   	/admin/
	/core/
	/Application.cfc
	/index.cfm

  You may copy and distribute Mura CMS with a plug-in, theme or bundle that
  meets the above guidelines as a combined work under the terms of GPL for
  Mura CMS, provided that you include the source code of that other code when
  and as the GNU GPL requires distribution of source code.

  For clarity, if you create a modified version of Mura CMS, you are not
  obligated to grant this special exception for your modified version; it is
  your choice whether to do so, or to make such modified version available
  under the GNU General Public License version 2 without this exception.  You
  may, if you choose, apply this exception to your own modified versions of
  Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false" hint="This provides default implementation for standard events that can be overridden through event system">

<!---- HANDLERS --->
<cffunction name="standardEnableLockdownHandler" output="false">
	<cfargument name="event" required="true">

	<cfif fileExists(expandPath('/muraWRM/config/lockdown.cfm'))>
		<cfinclude template="/muraWRM/config/lockdown.cfm">
	<cfelse>
		<cfinclude template="/muraWRM/core/templates/lockdown.cfm">
	</cfif>
</cffunction>

<cffunction name="standardWrongDomainHandler" output="false">
	<cfargument name="event" required="true">
	<cfset var $=arguments.event.getValue('muraScope')>

	<cfif request.returnFormat eq 'JSON'>
		<cfset request.muraJSONRedirectURL=$.getCurrentURL(complete=true,domain=$.siteConfig('domain'))>
	<cfelse>
		<cflocation addtoken="no" url="#$.getCurrentURL(complete=true,domain=$.siteConfig('domain'))#" statuscode="301">
	</cfif>
</cffunction>

<cffunction name="standardTranslationHandler" output="false">
	<cfargument name="$" required="true">
	<cfscript>
		param name="request.returnFormat" default="HTML";

		if(!listFindNoCase("HTML,JSON,AMP",request.returnFormat)){
			request.returnFormat="HTML";
		}

		$.event().getTranslator('standard#uCase(request.returnFormat)#').translate(arguments.$);
	</cfscript>
</cffunction>

<cffunction name="standardTrackSessionHandler" output="false">
	<cfargument name="event" required="true">

	<cfset application.sessionTrackingManager.trackRequest(arguments.event.getValue('siteID'),arguments.event.getValue('path'),arguments.event.getValue('keywords'),arguments.event.getValue('contentBean').getcontentID()) />

</cffunction>

<cffunction name="standardSetPreviewHandler" output="false">
	<cfargument name="event" required="true">

	<cfset arguments.event.setValue('track',0)>
	<cfset arguments.event.setValue('nocache',1)>
	<cfset arguments.event.setValue('contentBean',application.contentManager.getcontentVersion(arguments.event.getValue('previewID'),arguments.event.getValue('siteID'),true)) />

</cffunction>

<cffunction name="standardSetPermissionsHandler" output="false">
	<cfargument name="event" required="true">

	<cfset getBean("userUtility").returnLoginCheck(arguments.event.getValue("MuraScope"))>

	<cfif isArray(arguments.event.getValue('crumbdata')) and arrayLen(arguments.event.getValue('crumbdata'))>
		<cfset arguments.event.setValue('r',application.permUtility.setRestriction(arguments.event.getValue('crumbdata')))>
		<cfif arguments.event.getValue('r').restrict>
			<cfset arguments.event.setValue('nocache',1)>
		</cfif>
	</cfif>
</cffunction>

<cffunction name="standardSetCommentPermissionsHandler" output="false">
	<cfargument name="event" required="true">

	<cfset arguments.event.setValue('muraAllowComments', 1)>
</cffunction>

<cffunction name="standardSetCommenterHandler" output="false">
	<cfargument name="event" required="true">
	<cfset var remoteID = "">
	<cfset var commenter = event.getValue('commenterBean')>
	<cfset var comment = event.getValue('commentBean')>

	<cfif not comment.getIsNew()>
		<!--- update existing commenter --->
		<cfset commenter.loadBy(commenterID=comment.getUserID())>
	<cfelse>
		<!--- set up new commenter --->
		<cfif getCurrentUser().isLoggedIn()>
			<cfset remoteID = getCurrentUser().getUserID()>
		<cfelseif len(comment.getEmail()) gt 0>
			<cfset remoteID = comment.getEmail()>
		</cfif>
		<cfset commenter.loadBy(remoteID=remoteID)>
		<cfset commenter.setRemoteID(remoteID)>
	</cfif>

	<cfset commenter.setName(comment.getName())>
	<cfset commenter.setEmail(comment.getEmail())>
	<cfset commenter.save()>

	<cfset comment.setUserID(commenter.getCommenterID())>
</cffunction>

<cffunction name="standardGetCommenterHandler" output="false">
	<cfargument name="event" required="true">
	<cfset var commenter = event.getValue('commenterBean')>
	<cfset var comment = event.getValue('commentBean')>

	<cfset commenter.loadBy(commenterID=comment.getUserID())>
</cffunction>

<cffunction name="standardSetLocaleHandler" output="false">
	<cfargument name="event" required="true">
	<cfset var sessionData=getSession()>
	<cfparam name="sessionData.siteID" default="">
	<cfset setLocale(application.settingsManager.getSite(arguments.event.getValue('siteid')).getJavaLocale())>
	<cfif (not request.mura404 and arguments.event.getValue('contentBean').exists() and sessionData.siteid neq arguments.event.getValue('siteid')) or not structKeyExists(sessionData,"locale")>
		<!---These are use for admin purposes--->
		<cfset sessionData.siteID=arguments.event.getValue('siteid')>
		<cfset sessionData.userFilesPath = "#application.configBean.getAssetPath()#/#arguments.event.getValue('siteid')#/assets/">
		<cfset application.rbFactory.resetSessionLocale()>
	</cfif>
</cffunction>

<cffunction name="standardSetIsOnDisplayHandler" output="false">
	<cfargument name="event" required="true">
	<cfset var crumbdata="">
	<cfset var previewData=getCurrentUser().getValue("ChangesetPreviewData")>

	<cfif isStruct(previewData) and listFind(previewData.contentIdList,"'#arguments.event.getValue("contentBean").getContentID()#'")>
		<cfif arrayLen(arguments.event.getValue('crumbData')) gt 1>
			<cfset crumbdata=arguments.event.getValue('crumbdata')>
			<cfset arguments.event.setValue('isOnDisplay',application.contentUtility.isOnDisplay(arguments.event.getValue('contentBean').getdisplay(),arguments.event.getValue('contentBean').getdisplaystart(),arguments.event.getValue('contentBean').getdisplaystop(),arguments.event.getValue('siteID'),arguments.event.getValue('contentBean').getparentid(),crumbdata[2].type))>
		<cfelse>
			<cfset arguments.event.setValue('isOnDisplay',application.contentUtility.isOnDisplay(arguments.event.getValue('contentBean').getdisplay(),arguments.event.getValue('contentBean').getdisplaystart(),arguments.event.getValue('contentBean').getdisplaystop(),arguments.event.getValue('siteID'),arguments.event.getValue('contentBean').getparentid(),"Page"))>
		</cfif>
	<cfelseif arguments.event.valueExists('previewID')>
		<cfset arguments.event.setValue('isOnDisplay',1)>
	<cfelseif arguments.event.getValue('contentBean').getapproved() eq 0>
		<cfset arguments.event.setValue('track',0)>
		<cfset arguments.event.setValue('nocache',1)>
		<cfset arguments.event.setValue('isOnDisplay',0)>
	<cfelseif arrayLen(arguments.event.getValue('crumbData')) gt 1>
		<cfset crumbdata=arguments.event.getValue('crumbdata')>
		<cfset arguments.event.setValue('isOnDisplay',application.contentUtility.isOnDisplay(arguments.event.getValue('contentBean').getdisplay(),arguments.event.getValue('contentBean').getdisplaystart(),arguments.event.getValue('contentBean').getdisplaystop(),arguments.event.getValue('siteID'),arguments.event.getValue('contentBean').getparentid(),crumbdata[2].type))>
	<cfelse>
		<cfset arguments.event.setValue('isOnDisplay',1)>
	</cfif>

</cffunction>

<cffunction name="standardSetContentRendererHandler" output="false">
	<cfargument name="event" required="true">
	<cfset arguments.event.getValue("muraScope").getContentRenderer()>
</cffunction>

<cffunction name="standardSetContentHandler" output="false">
	<cfargument name="event" required="true">

	<cfset var renderer=arguments.event.getValue("contentRenderer")>
	<cfset var themeRenderer=renderer>
	<cfset var contentArray="">

	<cfif arguments.event.valueExists('previewID')>
		<cfset arguments.event.getHandler("standardSetPreview").handle(arguments.event)>
		<cfset arguments.event.setValue('showMeta',1)>
	<cfelse>
		<cfset arguments.event.getHandler("standardSetAdTracking").handle(arguments.event)>

		<cfif not arguments.event.valueExists('contentBean')>
			<cfif len(arguments.event.getValue('linkServID'))>
				<cfset arguments.event.setValue('contentBean',application.contentManager.getActiveContent(listFirst(arguments.event.getValue('linkServID')),arguments.event.getValue('siteid'),true)) />
			<cfelseif len(arguments.event.getValue('currentFilenameAdjusted')) and  application.configBean.getLoadContentBy() eq 'urltitle'>
				<cfset arguments.event.setValue('contentBean',application.contentManager.getActiveByURLTitle(listLast(arguments.event.getValue('currentFilenameAdjusted'),'/'),arguments.event.getValue('siteid'),true)) />
			<cfelse>

				<cfset arguments.event.setValue('contentBean',application.contentManager.getActiveContentByFilename(arguments.event.getValue('currentFilenameAdjusted'),arguments.event.getValue('siteid'),true)) />
			</cfif>
		</cfif>
	</cfif>

	<cfif isArray(arguments.event.getValue('contentBean'))>
		<cfset contentArray=arguments.event.getValue('contentBean')>
		<cfset arguments.event.setValue('contentBean',contentArray[1])>
	</cfif>

	<cfif arguments.event.getValue('contentBean').getType() neq 'Variation'>
		<cfset arguments.event.getValidator("standardWrongFilename").validate(arguments.event)>
		<cfset arguments.event.getValidator("standard404").validate(arguments.event)>


		<cfif application.settingsManager.getSite(arguments.event.getValue('siteid')).getUseSSL()>
			<cfset arguments.event.setValue('forcessl', true) />
		<cfelseif arguments.event.getValue('contentBean').getForceSSL()>
			<cfset arguments.event.setValue('forceSSL',arguments.event.getValue('contentBean').getForceSSL())/>
		</cfif>
	</cfif>

	<cfif not isArray(arguments.event.getValue('crumbdata'))>
		<cfset arguments.event.setValue('crumbdata',arguments.event.getValue('contentBean').getCrumbArray(setInheritance=true)) />
	</cfif>

	<cfset renderer.injectMethod('crumbdata',arguments.event.getValue("crumbdata"))>

	<cfif isObject(themeRenderer)>
		<cfset themeRenderer.injectMethod('crumbdata',arguments.event.getValue("crumbdata"))>
	</cfif>
</cffunction>

<cffunction name="standardSetAdTrackingHandler" output="false">
	<cfargument name="event" required="true">

	<cfif arguments.event.getValue('trackSession')>
		<cfset arguments.event.setValue('track',1)>
	<cfelse>
		<cfset arguments.event.setValue('track',0)>
	</cfif>

</cffunction>

<cffunction name="standardRequireLoginHandler" output="false">
	<cfargument name="event" required="true">

	<cfset var loginURL = "" />

	<cfif arguments.event.getValue('isOnDisplay') and arguments.event.getValue('r').restrict and not arguments.event.getValue('r').loggedIn and not listFindNoCase('login,editProfile',arguments.event.getValue('display'))>
		<cfset loginURL = application.settingsManager.getSite(request.siteid).getLoginURL() />
		<cfif find('?', loginURL)>
			<cfset loginURL &= "&returnURL=#URLEncodedFormat(arguments.event.getValue('contentRenderer').getCurrentURL())#" />
		<cfelse>
			<cfset loginURL &= "?returnURL=#URLEncodedFormat(arguments.event.getValue('contentRenderer').getCurrentURL())#" />
		</cfif>

		<cfif request.returnFormat eq 'JSON'>
			<cfset request.muraJSONRedirectURL=loginURL>
		<cfelse>
			<cflocation addtoken="no" url="#loginURL#">
		</cfif>
	</cfif>

</cffunction>

<cffunction name="standardPostLogoutHandler" output="false">
	<cfargument name="event" required="true">
	<cfif request.returnFormat eq 'JSON'>
		<cfset request.muraJSONRedirectURL=arguments.event.getValue('contentRenderer').getCurrentURL()>
	<cfelse>
		<cflocation url="#arguments.event.getValue('contentRenderer').getCurrentURL()#" addtoken="false">
	</cfif>
</cffunction>

<cffunction name="standardMobileHandler" output="false">
	<cfargument name="event" required="true">
	<cfset var renderer=arguments.event.getValue("contentRenderer")>

	<cfif fileExists(ExpandPath( "#arguments.event.getSite().getThemeIncludePath()#/templates/mobile.cfm"))>
		<cfset arguments.event.getValue("contentBean").setTemplate("mobile.cfm")>
		<cfset renderer.showAdminToolbar=false>
		<cfset renderer.showMemberToolbar=false>
		<cfset renderer.showEditableObjects=false>
		<cfset renderer.contentListPropertyTagMap={containerEl="ul",itemEl="li",title="h3",default="p"}>
		<cfset arguments.event.setValue("muraMobileTemplate",true)>
	</cfif>

</cffunction>

<cffunction name="standardWrongFilenameHandler" output="false">
	<cfargument name="event" required="true">
	<cfset var currentFilename=arguments.event.getValue('currentFilename')>
	<cfset var currentFilenameAdjusted=arguments.event.getValue('currentFilenameAdjusted')>

	<cfif not arguments.event.getValue('muraSiteIDRedirect')>
		<cfif len(currentFilename) and currentFilename neq currentFilenameAdjusted>
			<cfset arguments.event.setValue('currentFilename',arguments.event.getValue('contentBean').getFilename() & right(currentFilename,len(currentFilename)-len(currentFilenameAdjusted)))>
		<cfelse>
			<cfset arguments.event.setValue('currentFilename',arguments.event.getValue('contentBean').getFilename())>
		</cfif>
	</cfif>

	<cfif request.returnFormat eq 'JSON'>
		<cfset request.muraJSONRedirectURL=arguments.event.getValue('contentRenderer').getCurrentURL(complete=true)>
	<cfelse>
		<cflocation addtoken="no" url="#arguments.event.getValue('contentRenderer').getCurrentURL(complete=true)#">
	</cfif>

	<cflocation url="#arguments.event.getValue('contentRenderer').getCurrentURL(complete=true)#" addtoken="false" statuscode="301">
</cffunction>

<cffunction name="standardLinkTranslationHandler" output="false">
	<cfargument name="event" required="true">

	<cfset arguments.event.getTranslator('standardLink').translate(arguments.event) />
</cffunction>

<cffunction name="standardForceSSLHandler" output="false">
	<cfargument name="$" required="true">

	<cfif request.returnFormat eq 'JSON'>
		<cfif not application.utility.isHTTPS()>
			<cfset request.muraJSONRedirectURL="https://#arguments.$.siteConfig('domain')##arguments.$.siteConfig('serverPort')##arguments.$.siteConfig('context')##arguments.$.getCurrentURL(complete=false,filterVars=false)#">
		</cfif>
	<cfelse>
		<cfif not application.utility.isHTTPS()>
			<cflocation statuscode="301" addtoken="no" url="https://#arguments.$.siteConfig('domain')##arguments.$.siteConfig('serverPort')##arguments.$.siteConfig('context')##arguments.$.getCurrentURL(complete=false,filterVars=false)#">
		</cfif>
	</cfif>
</cffunction>

<cffunction name="standardFileTranslationHandler" output="false">
	<cfargument name="event" required="true">

	<cfset arguments.event.getTranslator('standardFile').translate(arguments.event) />
</cffunction>

<cffunction name="standardDoResponseHandler" output="false">
	<cfargument name="event" required="true">

	<cfset var showMeta=0>
	<cfset var renderer=arguments.event.getContentRenderer()>
	<cfset var translator="">

	<cfset arguments.event.getValidator('standardForceSSL').validate(arguments.event)>

	<!---
	<cfif listFindNoCase('author,editor',arguments.event.getValue('r').perm) and arguments.event.getValue('showMeta') neq 2>
		<cfset arguments.event.setValue('showMeta',1)>
	</cfif>
	--->

	<cfset application.pluginManager.announceEvent(eventToAnnounce='onRenderStart', currentEventObject=arguments.event,objectid=arguments.event.getValue('contentBean').getContentID())/>

	<cfswitch expression="#arguments.event.getValue('contentBean').getType()#">
	<cfcase value="File,Link">

		<cfif arguments.event.getValue('isOnDisplay') and ((not arguments.event.getValue('r').restrict) or (arguments.event.getValue('r').restrict and arguments.event.getValue('r').allow))>
			<cfif arguments.event.getValue('showMeta') neq 1 and not arguments.event.getValue('contentBean').getKidsQuery(size=1).recordcount>
				<cfswitch expression="#arguments.event.getValue('contentBean').getType()#">
					<cfcase value="Link">
						<cfif not renderer.showItemMeta("Link") or arguments.event.getValue('showMeta') eq 2>
							<cfset translator=arguments.event.getHandler('standardLinkTranslation')>
						<cfelse>
							<cfset translator=arguments.event.getHandler('standardTranslation')>
						</cfif>
					</cfcase>
					<cfcase value="File">
						<cfif not (renderer.showItemMeta(arguments.event.getValue('contentBean').getFileExt()) or renderer.showItemMeta('File') ) or arguments.event.getValue('showMeta') eq 2 or listFindNoCase('attachment,inline',arguments.event.getValue('method'))>
							<!---<cftry>--->
							<cfset translator=arguments.event.getHandler('standardFileTranslation')>
							<!---
							<cfcatch>
								<cfset arguments.event.setValue('contentBean',application.contentManager.getActiveContentByFilename("404",arguments.event.getValue('siteID'))) />
								<cfset arguments.event.getHandler('standardTranslation').handle(arguments.event) />
							</cfcatch>
							</cftry>
							--->
						<cfelse>
							<cfset translator=arguments.event.getHandler('standardTranslation')>
						</cfif>
					</cfcase>
				</cfswitch>
			<cfelse>
				<cfset translator=arguments.event.getHandler('standardTranslation')>
			</cfif>
		<cfelse>
			<cfset translator=arguments.event.getHandler('standardTranslation')>
		</cfif>
	</cfcase>
	<cfdefaultcase>
		<cfset translator=arguments.event.getHandler('standardTranslation')>
	</cfdefaultcase>
	</cfswitch>

	<cfset translator.handle(arguments.event) />

	<cfset application.pluginManager.announceEvent(eventToAnnounce='onRenderEnd',currentEventObject=arguments.event,objectid=arguments.event.getValue('contentBean').getContentID())/>
</cffunction>

<cffunction name="standard404Handler" output="false">
	<cfargument name="event" required="true">
	<cfargument name="$" required="true">

	<cfif arguments.event.getValue("contentBean").getIsNew()>
		<cfset getPluginManager().announceEvent(eventToAnnounce="onSite404",currentEventObject=arguments.event,objectid=arguments.event.getValue('contentBean').getContentID())>
	</cfif>

	<cfif arguments.event.getValue("contentBean").getIsNew()>
		<cfset request.mura404=true>
		<cfset var local.filename=arguments.event.getValue('currentFilenameAdjusted')>

		<cfloop condition="listLen(local.filename,'/')">
			<cfset var archived=getBean('contentFilenameArchive').loadBy(filename=local.filename,siteid=event.getValue('siteid'))>
			<cfif not archived.getIsNew()>
				<cfset var archiveBean=getBean('content').loadBy(contentid=archived.getContentID(),siteid=event.getValue('siteid'))>
				<cfif not archiveBean.getIsNew()>
					<cfif local.filename eq event.getValue('currentFilenameAdjusted')>
						<cfif request.returnFormat eq 'JSON'>
							<cfset request.muraJSONRedirectURL=archiveBean.getURL()>
							<cfreturn true>
						<cfelse>
							<cflocation url="#archiveBean.getURL()#" addtoken="false" statuscode="301">
						</cfif>
					<cfelse>
						<cfset archiveBean=getBean('content').loadBy(filename=replace(arguments.event.getValue('currentFilenameAdjusted'),local.filename,archiveBean.getFilename()),siteid=event.getValue('siteid'))>
						<cfif not archiveBean.getIsNew()>
							<cfif request.returnFormat eq 'JSON'>
								<cfset request.muraJSONRedirectURL=archiveBean.getURL()>
								<cfreturn true>
							<cfelse>
								<cflocation url="#archiveBean.getURL()#" addtoken="false" statuscode="301">
							</cfif>
						</cfif>
					</cfif>
				<cfelse>
					<cfset archived.delete()>
				</cfif>
			</cfif>

			<cfset local.filename=listDeleteAt(local.filename,listLen(local.filename,'/'),'/')>
		</cfloop>
	</cfif>

	<cfif not isdefined('request.muraJSONRedirectURL') and arguments.event.getValue("contentBean").getIsNew()>
		<cfset arguments.event.setValue('contentBean',application.contentManager.getActiveContentByFilename("404",arguments.event.getValue('siteid'),true)) />

		<cfif len(arguments.event.getValue('previewID'))>
			<cfset arguments.event.getContentBean().setBody("The requested version of this content could not be found.")>
		</cfif>
		<cfif request.returnFormat neq 'json' and request.muraFrontEndRequest >
			<cfheader statuscode="404" statustext="Content Not Found" />
		</cfif>

		<cfset var renderer=arguments.$.getContentRenderer()>
		<cfif isDefined('renderer.noIndex')>
			<cfset renderer.noIndex()>
		</cfif>
	</cfif>

</cffunction>

<cffunction name="standardDoActionsHandler" output="false">
	<cfargument name="event" required="true">
	<cfargument name="$" />

	<cfset var a=""/>

	<cfif arguments.event.getValue('doaction') neq ''>
		<cfloop list="#arguments.event.getValue('doaction')#" index="a">
			<cfset doAction(a,arguments.event,arguments.$)>
		</cfloop>
	</cfif>
</cffunction>

<cffunction name="doAction" output="false">
	<cfargument name="theaction" type="string" default="">
	<cfargument name="event" required="true">
	<cfargument name="$" />

	<cfswitch expression="#arguments.theaction#">
		<cfcase value="login">
			<cfif fileExists(expandPath("/#application.configBean.getWebRootMap()#/#arguments.event.getValue('siteid')#/includes/loginHandler.cfc"))>
				<cfset createObject("component","#application.configBean.getWebRootMap()#.#arguments.event.getValue('siteid')#.includes.loginHandler").init().handleLogin(arguments.event.getAllValues())>
			<cfelse>
				<cfif not arguments.$.getContentRenderer().validateCSRFTokens or arguments.$.validateCSRFTokens(context='login')>
					<cfset var loginManager=arguments.$.getBean('loginManager')>
					<cfif isBoolean(arguments.$.event('attemptChallenge')) and arguments.$.event('attemptChallenge')>
						<cfset arguments.$.event('failedchallenge', !loginManager.handleChallengeAttempt(arguments.$)) />
						<cfset loginManager.completedChallenge(arguments.$)>
					<cfelseif isDefined('form.username') and isDefined('form.password')>
						<cfset loginManager.login(arguments.$.event().getAllValues(),'')>
					</cfif>
				</cfif>
			</cfif>
		</cfcase>

		<cfcase value="return">
			<cfset application.emailManager.track(arguments.event.getValue('emailID'),arguments.event.getValue('email'),'returnClick')>
		</cfcase>

		<cfcase value="logout">
			<cfset application.loginManager.logout()>
			<cfset arguments.event.getHandler("standardPostLogout").handle(arguments.event)>
		</cfcase>

		<cfcase value="updateprofile">
			<cfset var sessionData=getSession()>
			<cfif sessionData.mura.isLoggedIn>
				<cfset var eventStruct=arguments.event.getAllValues()>
				<cfset structDelete(eventStruct,'isPublic')>
				<cfset structDelete(eventStruct,'s2')>
				<cfset structDelete(eventStruct,'type')>
				<cfset structDelete(eventStruct,'groupID')>
				<cfset eventStruct.userid=sessionData.mura.userID>
				<cfset arguments.event.setValue("userID",sessionData.mura.userID)>

				<cfif not arguments.$.getContentRenderer().validateCSRFTokens or arguments.$.validateCSRFTokens(context='editprofile')>
					<cfset arguments.event.setValue('passedProtect', arguments.$.getBean('utility').isHuman(arguments.event)) />
					<cfif isDefined('request.addressAction')>
						<cfif arguments.event.getValue('addressAction') eq "create">
							<cfset application.userManager.createAddress(eventStruct)>
						<cfelseif arguments.event.getValue('addressAction') eq "update">
							<cfset application.userManager.updateAddress(eventStruct)>
						<cfelseif arguments.event.getValue('addressAction') eq "delete">
							<cfset application.userManager.deleteAddress(arguments.event.getValue('addressID'))>
						</cfif>
						<!--- reset the form --->
						<cfset arguments.event.setValue('addressID','')>
						<cfset arguments.event.setValue('addressAction','')>
					<cfelse>
						<cfset arguments.event.setValue('userBean',application.userManager.update( getBean("user").loadBy(userID=arguments.event.getValue("userID")).set(eventStruct).getAllValues() , iif(event.valueExists('groupID'),de('true'),de('false')),true,arguments.event.getValue('siteID'))) />
						<cfif structIsEmpty(arguments.event.getValue('userBean').getErrors())>
							<cfset application.loginManager.loginByUserID(eventStruct)>
						</cfif>
					</cfif>
				<cfelse>
					<cfset var userBean=arguments.$.getBean('userBean').loadBy(userid=sessionData.mura.userID).set(eventStruct)>
					<cfset userBean.validate()>
					<cfset userBean.getErrors().csfr='Your request contained invalid tokens'>
					<cfset arguments.event.setValue('userBean',userBean)>
				</cfif>
			</cfif>
		</cfcase>

		<cfcase value="createprofile">
			<cfif application.settingsManager.getSite(arguments.event.getValue('siteid')).getextranetpublicreg() eq 1>
				<cfset var eventStruct=arguments.event.getAllValues()>
				<cfset structDelete(eventStruct,'isPublic')>
				<cfset structDelete(eventStruct,'s2')>
				<cfset structDelete(eventStruct,'type')>
				<cfset structDelete(eventStruct,'groupID')>
				<cfset eventStruct.userid=''>

				<cfif not arguments.$.getContentRenderer().validateCSRFTokens or arguments.$.validateCSRFTokens(context='editprofile')>
					<cfset arguments.event.setValue('passedProtect', arguments.$.getBean('utility').isHuman(arguments.event)) />
					<cfset arguments.event.setValue('userBean',  getBean("user").loadBy(userID=arguments.event.getValue("userID")).set(eventStruct).save() ) />
					<cfif structIsEmpty(arguments.event.getValue('userBean').getErrors()) and not arguments.event.valueExists('passwordNoCache')>
						<cfset application.userManager.sendLoginByUser(arguments.event.getValue('userBean'),arguments.event.getValue('siteid'),arguments.event.getValue('contentRenderer').getCurrentURL(),true) />
					<cfelseif structIsEmpty(arguments.event.getValue('userBean').getErrors()) and arguments.event.valueExists('passwordNoCache') and arguments.event.getValue('userBean').getInactive() eq 0>
						<cfset arguments.event.setValue('userID',arguments.event.getValue('userBean').getUserID()) />
						<cfset application.loginManager.loginByUserID(eventStruct)>
					</cfif>
				<cfelse>
					<cfset var userBean=arguments.$.getBean('userBean').set(eventStruct)>
					<cfset userBean.validate()>
					<cfset userBean.getErrors().csfr='Your request contained invalid tokens'>
					<cfset arguments.event.setValue('userBean',userBean)>
				</cfif>
			</cfif>
		</cfcase>

		<!---
		<cfcase value="contactsend">
			<cfparam name="request.company" default="">
			<cfset getBean("mailer").send(arguments.event.getAllValues(),arguments.event.getValue('sendTo'),'#iif(arguments.event.getValue('fname') eq '' and arguments.event.getValue('lname') eq '',de('#arguments.event.getValue('company')#'),de('#arguments.event.getValue('fname')# #arguments.event.getValue('lname')#'))#',arguments.event.getValue('subject'),arguments.event.getValue('siteID'),arguments.event.getValue('email'))>
		</cfcase>
		--->

		<cfcase value="subscribe">
			<cfset arguments.event.setValue('passedProtect', arguments.$.getBean('utility').isHuman(arguments.event)) />

			<cfif arguments.event.getValue("passedProtect")>
				<cfset application.mailinglistManager.createMember(arguments.event.getAllValues())>
			</cfif>
		</cfcase>

		<cfcase value="unsubscribe">
			<cfset application.mailinglistManager.deleteMember(arguments.event.getAllValues())>
		</cfcase>

		<cfcase value="masterSubscribe">
			<cfset arguments.event.setValue('passedProtect', arguments.$.getBean('utility').isHuman(arguments.event)) />

			<cfif arguments.event.getValue("passedProtect")>
				<cfset application.mailinglistManager.masterSubscribe(arguments.event.getAllValues())/>
			</cfif>
		</cfcase>

		<cfcase value="setReminder">
			<cfset arguments.event.setValue('passedProtect', arguments.$.getBean('utility').isHuman(arguments.event)) />

			<cfif arguments.event.getValue("passedProtect")>
				<cfset application.contentManager.setReminder(arguments.event.getValue('contentBean').getcontentid(),arguments.event.getValue('siteID'),arguments.event.getValue('email'),arguments.event.getValue('contentBean').getdisplaystart(),arguments.event.getValue('interval')) />
			</cfif>
		</cfcase>

		<cfcase value="forwardEmail">
			<cfset arguments.event.setValue('passedProtect', arguments.$.getBean('utility').isHuman(arguments.event)) />

			<cfif arguments.event.getValue("passedProtect")>
				<cfset arguments.event.setValue('to',arguments.event.getValue('to1'))/>
				<cfset arguments.event.setValue('to',listAppend(arguments.event.getValue('to'),arguments.event.getValue('to2'))) />
				<cfset arguments.event.setValue('to',listAppend(arguments.event.getValue('to'),arguments.event.getValue('to3'))) />
				<cfset arguments.event.setValue('to',listAppend(arguments.event.getValue('to'),arguments.event.getValue('to4'))) />
				<cfset arguments.event.setValue('to',listAppend(arguments.event.getValue('to'),arguments.event.getValue('to5'))) />
				<cfset application.emailManager.forward(arguments.event.getAllValues()) />
			</cfif>
		</cfcase>

	</cfswitch>
</cffunction>

<!--- VALIDATORS --->
<cffunction name="standardEnableLockdownValidator" output="false">
	<cfargument name="event" required="true">
	<cfset var valid = false>
	<cfset var enableLockdown = application.settingsManager.getSite(request.siteID).getEnableLockdown()>

	<cfif (enableLockdown eq "development" and not getCurrentUser().isPassedLockdown()) or (enableLockdown eq "maintenance" and not getCurrentUser().isLoggedIn())>
		<cfif event.getValue('locks') eq "true">
			<cfif enableLockdown eq "development">
				<!--- all member types, set 'passedLockdown' cookie --->
				<cfset valid = getBean('userUtility').login(event.getValue('locku'), event.getValue('lockp'), request.siteID, true, event.getValue('expires'))>
			<cfelseif enableLockdown eq "maintenance">
				<!--- only admin users, log user in --->
				<cfset valid = getBean('userUtility').login(event.getValue('locku'), event.getValue('lockp'), '', false, '')>
			</cfif>
		</cfif>

		<cfif not valid>
			<cfset arguments.event.getHandler("standardEnableLockdown").handle(arguments.event)>
		</cfif>
	</cfif>

</cffunction>

<cffunction name="standardWrongDomainValidator" output="false">
	<cfargument name="event" required="true">

	<cfif request.returnFormat eq 'HTML' and not len(arguments.event.getValue("previewID")) and (application.configBean.getMode() eq 'production' and yesNoFormat(arguments.event.getValue("muraValidateDomain"))
		and not application.settingsManager.getSite(request.siteID).isValidDomain(domain:listFirst(cgi.http_host,":"), mode: "either",enforcePrimaryDomain=true))>
		<cfset arguments.event.getHandler("standardWrongDomain").handle(arguments.event)>
	</cfif>
</cffunction>

<cffunction name="standardTrackSessionValidator" output="false">
	<cfargument name="$" required="true">

	<cfif arguments.event.getValue('trackSession')
			and len(arguments.$.content().getcontentID())
			and arguments.$.content().getIsNew() eq 0
			and not arguments.$.event().valueExists('previewID')
			and arguments.$.siteConfig().getShowDashboard()
			and arguments.$.globalConfig().getSessionHistory()>
			<cfset arguments.$.event().getHandler("standardTrackSession").handle(arguments.event)>
	</cfif>
</cffunction>

<cffunction name="standardRequireLoginValidator" output="false">
	<cfargument name="event" required="true">

	<cfif request.returnFormat eq 'HTML' and arguments.event.getValue('isOnDisplay') and arguments.event.getValue('r').restrict
			and not arguments.event.getValue('r').loggedIn
			and (arguments.event.getValue('display') neq 'login' and arguments.event.getValue('display') neq 'editProfile')>
			<cfset arguments.event.getHandler("standardRequireLogin").handle(arguments.event)>
	</cfif>
</cffunction>

<cffunction name="standardMobileValidator" output="false">
	<cfargument name="event" required="true">
	<cfif not isBoolean(request.muraMobileRequest)>
		<cfset request.muraMobileRequest=false>
	</cfif>
	<cfif request.muraMobileRequest and not len(arguments.event.getValue('altTheme'))>
		<cfset arguments.event.getHandler("standardMobile").handle(arguments.event)>
	</cfif>
</cffunction>

<cffunction name="standardWrongFilenameValidator" output="false">
	<cfargument name="event" required="true">
	<cfset var requestedfilename=arguments.event.getValue('currentFilenameAdjusted')>
	<cfset var contentFilename=arguments.event.getValue('contentBean').getFilename()>
	<cfset var renderer=arguments.event.getContentRenderer()>

	<cfset arguments.event.setValue(
		'muraSiteIDRedirect',
		(isBoolean(renderer.siteIDInURLS)
		and (
				renderer.siteIDInURLS and not request.muraSiteIDInURL
				or not renderer.siteIDInURLS and request.muraSiteIDInURL
			))
		)>

	<cfif (
			request.returnFormat neq 'JSON'
				and  arguments.event.getValue('muraForceFilename')
				and contentFilename neq '404'
				and len(requestedfilename)
				and requestedfilename neq contentFilename

			) or arguments.event.getValue('muraSiteIDRedirect')>
		<cfset arguments.event.getHandler("standardWrongFilename").handle(arguments.event)>
	</cfif>
</cffunction>

<cffunction name="standardForceSSLValidator" output="false">
	<cfargument name="event" required="true">
	<cfset var isHTTPS=application.utility.isHTTPS()>

	<cfif application.settingsManager.getSite(arguments.event.getValue('siteID')).getUseSSL()
		or (
			request.returnFormat eq 'HTML'
			and not (len(arguments.event.getValue('previewID')) and isHTTPS)
			and (
				arguments.event.getValue("contentBean").getFilename() neq "404"
				and
				(
					arguments.event.getValue('forceSSL') and not isHTTPS
				)
				or	(
					not (arguments.event.getValue('r').restrict or arguments.event.getValue('forceSSL')) and application.utility.isHTTPS()
				)
			)
		)>
		<cfset arguments.event.getHandler("standardForceSSL").handle(arguments.event)>
	</cfif>
</cffunction>

<cffunction name="standard404Validator" output="false">
	<cfargument name="event" required="true">

	<cfif arguments.event.getValue('contentBean').getIsNew() eq 1>
		<cfset arguments.event.getHandler("standard404").handle(arguments.event)>
	</cfif>
</cffunction>

<!--- TRANSLATORS --->
<cffunction name="standardFileTranslator" output="false">
	<cfargument name="$" required="true">

	<cfif request.returnFormat eq 'JSON'>
		<cfset var apiUtility=$.siteConfig().getApi('json','v1')>
		<cfset request.muraJSONRedirectURL = $.siteConfig().getResourcePath(complete=true) & '/index.cfm/_api/render/file/?fileid=' & $.content('fileid')>
		<cfset $.event('__MuraResponse__',apiUtility.getSerializer().serialize({'apiversion'=apiUtility.getApiVersion(),'method'='findOne','params'=apiUtility.getParamsWithOutMethod(form),data={redirect=request.muraJSONRedirectURL}}))>
	<cfelse>
		<cfset $.getContentRenderer().renderFile($.content('fileid'),$.event('method'),$.event('size')) />
	</cfif>

</cffunction>

<cffunction name="standardLinkTranslator" output="false">
	<cfargument name="$" required="true">
	<cfset var theLink=$.getContentRenderer().setDynamicContent($.content('body'))>

	<cfif left(theLink,1) eq "?">
		<cfset theLink="/" & theLink>
	</cfif>

	<cfif request.returnFormat eq 'JSON'>
		<cfset var apiUtility=$.siteConfig().getApi('json','v1')>
		<cfset $.event('__MuraResponse__',apiUtility.getSerializer().serialize({'apiversion'=apiUtility.getApiVersion(),'method'='findOne','params'=apiUtility.getParamsWithOutMethod(form),data={redirect=thelink}}))>
	<cfelse>
		<cflocation url="#theLink#" addtoken="false" statuscode="301">
	</cfif>

</cffunction>

<cffunction name="standardJSONTranslator" output="false">
	<cfargument name="$">
	<cfscript>
		try{

			if($.content('type')=='Variation'){
				$.content('isnew',0);
			}

			var apiUtility=$.siteConfig().getApi('json','v1');
			var result=structCopy($.content().getAllValues());
			var renderer=$.getContentRenderer();
			var editableAttributes=(isdefined('renderer.editableAttributesArray') && isArray(renderer.editableAttributesArray)) ? renderer.editableAttributesArray : [];

			request.cffpJS=true;

			result.template=renderer.getTemplate();
			result.conanicalURL=renderer.getConanicalURL();
			result.metadesc=renderer.getMetaDesc();

			for(var attr in editableAttributes){
				result['#attr.attribute#']=$.renderEditableAttribute(argumentCollection=attr);
			}

			$.event('response',result);

			result.displayRegions={};
			result.displayRegionNames=listToArray($.siteConfig('columnNames'),'^');
			for(var r =1;r<=ListLen($.siteConfig('columnNames'),'^');r++){
				var regionName='#replace(listGetAt($.siteConfig('columnNames'),r,'^'),' ','','all')#';

				result.displayRegions[regionName]=$.dspObjects(columnid=r,returnFormat='array');
			}

			if(result.type != 'Variation'){
				result.body=apiUtility.applyRemoteFormat($.dspBody(body=$.content('body'),crumblist=false,renderKids=true,showMetaImage=false));
			}

			result.links=apiUtility.getLinks($.content());

			if(len($.event('expand'))){
				var p='';
				var expandParams={};
				var entity=$.content();
				var expand=$.event('expand');
				var expandAll=(expand=='all' || expand=='*');
				var expanded=1;
				if(arrayLen(entity.getHasManyPropArray())){
					for(p in entity.getHasManyPropArray()){
						if(expandAll || listFindNoCase(expand,p.name)){
							expandParams={maxitems=0,itemsperpage=0};
							expandParams['#entity.translatePropKey(p.loadkey)#']=entity.getValue(entity.translatePropKey(p.column));

							if(p.cfc=='content'){
								if(isDefined('url.showexcludesearch')){
									expandParams.showexcludesearch=url.showexcludesearch;
								}
								if(isDefined('url.includeHomePage')){
									expandParams.includeHomePage=url.includeHomePage;
								}
								if(isDefined('url.shownavonly')){
									expandParams.shownavonly=url.shownavonly;
								}

								expandParams.sortBy=entity.get('sortBy');
								expandParams.sortDirection=entity.get('sortDirection');
							}

							if(isDefined('url.maxitems')){
								expandParams.maxitems=url.maxitems;
							}
							if(isDefined('url.cachedWithin')){
								expandParams.cachedWithin=url.cachedWithin;
							}
							if(isDefined('url.itemsPerPage')){
								expandParams.itemsPerPage=url.itemsPerPage;
							}

							try{
								result[p.name]=apiUtility.findQuery(entityName=p.cfc,siteid=$.event('siteid'),params=expandParams,expand=expand,expanded=expanded,expandedProp=p.name);
							} catch(any e){/*WriteDump(p); abort;*/}
						}
					}
				}

				if(arrayLen(entity.getHasOnePropArray())){
					for(p in entity.getHasOnePropArray()){
						if(expandAll || listFindNoCase(expand,p.name)){
							try{
								if(p.name=='site'){
									result[p.name]=apiUtility.findOne(entityName='site',id=$.event('siteid'),siteid=$.event('siteid'),render=false,variation=false,expand=expand,expanded=expanded,expandedProp=p.name);
								} else {
									result[p.name]=apiUtility.findOne(entityName=p.cfc,id=entity.getValue(entity.translatePropKey(p.column)),siteid=$.event('siteid'),render=false,variation=false,expand=expand,expanded=expanded,expandedProp=p.name);
								}
							} catch(any e){/*WriteDump(p); abort;*/}
						}
					}
				}

				if(expandAll || listFindNoCase(expand,'crumbs')){
					result.crumbs=apiUtility.findCrumbArray(entityName='content',id=entity.getContentID(),siteid=$.event('siteid'),iterator=entity.getCrumbIterator(),expand='',expanded=1,expandedProp='crumbs');
				}

				if(expandAll || listFindNoCase(expand,'relatedcontent')){
					result.relatedcontent=apiUtility.findRelatedContent(entity=entity,siteid=$.event('siteid'),expand='',expanded=1,expandedProp='relatedcontent');
				}
			}

			result.config={
				loginURL=$.siteConfig('LoginURL'),
				siteid=$.event('siteID'),
				contentid=$.content('contentid'),
				contenthistid=$.content('contenthistid'),
				changesetid=$.content('changesetid'),
				siteID=$.event('siteID'),
				context=$.siteConfig().getRootPath(complete=1),
				nocache=$.event('nocache'),
				assetpath=$.siteConfig().getAssetPath(complete=1),
				sitespath=$.siteConfig().getSitesPath(complete=1),
				corepath=$.siteConfig().getCorePath(complete=1),
				fileassetpath=$.siteConfig().getFileAssetPath(complete=1),
				adminpath=$.siteConfig().getAdminPath(complete=1),
				themepath=$.siteConfig().getThemeAssetPath(complete=1),
				pluginspath=$.siteConfig().getPluginsPath(complete=1),
				rootpath=$.siteConfig().getRootPath(complete=1),
				rb=lcase(listFirst($.siteConfig('JavaLocale'),"_")),
				reCAPTCHALanguage=$.siteConfig('reCAPTCHALanguage'),
				preloaderMarkup=esapiEncode('javascript',renderer.preloaderMarkup),
				mobileformat=esapiEncode('javascript',$.event('muraMobileRequest')),
				adminpreview=lcase(structKeyExists(url,'muraadminpreview')),
				windowdocumentdomain=$.globalConfig('WindowDocumentDomain'),
				perm=$.event('r').perm,
				apiEndpoint=apiUtility.getEndPoint()
			};

			result.HTMLHeadQueue=$.renderHTMLQueue('head');
			result.HTMLFootQueue=$.renderHTMLQueue('foot');

			result.id=result.contentid;
			result.links=apiUtility.getLinks($.content());
			result.images=apiUtility.setImageUrls($.content(),'fileid',$);

			var imageAttributes=(isdefined('renderer.imageAttributesArray') && isArray(renderer.imageAttributesArray)) ? renderer.imageAttributesArray : [];
			for(var img in imageAttributes){
				if(isValid('uuid',$.content(img))){
					result['#img#images']=apiUtility.setImageUrls($.content(),img,$);
				}
			}

			getpagecontext().getresponse().setcontenttype('application/json; charset=utf-8');

			$.announceEvent(eventName='onapiresponse',objectid=$.content('contentid'));
			$.announceEvent(eventName='on#result.type#apiresponse',objectid=$.content('contentid'));
			$.announceEvent(eventName='on#result.type##result.subtype#apiresponse',objectid=$.content('contentid'));

			structDelete(result,'addObjects');
			structDelete(result,'removeObjects');
			structDelete(result,'frommuracache');
			structDelete(result,'errors');
			structDelete(result,'instanceid');
			structDelete(result,'primaryKey');
			structDelete(result,'metakeywords');
			structDelete(result,'extenddatatable');
			structDelete(result,'extenddata');
			structDelete(result,'meta');
			structDelete(result,'extendAutoComplete');
			structDelete(result,'lastupdateby');
			structDelete(result,'lastupdatebyid');

			if($.content('type')=='Variation'){
				var variationTargeting=$.content().getVariationTargeting();
				result.initjs=variationTargeting.getInitJS();
				result.targetingjs=variationTargeting.getTargetingJS();
			}

			if(isDefined('request.muraJSONRedirectURL') && len(request.muraJSONRedirectURL)){
				result.redirect=request.muraJSONRedirectURL;
			}

			$.event('__MuraResponse__',apiUtility.serializeResponse(response={'apiversion'=apiUtility.getApiVersion(),'method'='findOne','params'={filename=result.filename,siteid=result.siteid,rendered=true},data=result},statuscode=200));

		} catch (any e){
			result.error = e;
			$.announceEvent(eventName='onapierror',objectid=$.content('contentid'));
			$.event('__MuraResponse__',apiUtility.serializeResponse(response={error=result.error.stacktrace},statuscode=500));
		}

	</cfscript>

	<cfcontent reset="true">
</cffunction>

<cffunction name="standardAMPTranslator" output="false">
	<cfargument name="$">
	<cfscript>
		$.event().getTranslator('standardHTML').translate(arguments.$);
	</cfscript>
</cffunction>
</cfcomponent>
