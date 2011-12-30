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

<!---- HANDLERS --->
<cffunction name="standardWrongDomainHandler" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cflocation addtoken="no" url="http://#application.settingsManager.getSite(request.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(event.getValue('siteID'),event.getValue('contentBean').getFilename())#">

</cffunction>

<cffunction name="standardTranslationHandler" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfset event.getTranslator('standardHTML').translate(event)/>

</cffunction>

<cffunction name="standardTrackSessionHandler" output="false" returnType="any">
	<cfargument name="event" required="true">	
	
	<cfset application.sessionTrackingManager.trackRequest(event.getValue('siteID'),event.getValue('path'),event.getValue('keywords'),event.getValue('contentBean').getcontentID()) />
		
</cffunction>

<cffunction name="standardSetPreviewHandler" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfset event.setValue('track',0)>
	<cfset event.setValue('nocache',1)>
	<cfset event.setValue('contentBean',application.contentManager.getcontentVersion(event.getValue('previewID'),event.getValue('siteID'),true)) />

</cffunction>

<cffunction name="standardSetPermissionsHandler" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfset getBean("userUtility").returnLoginCheck(arguments.event.getValue("MuraScope"))>
	
	<cfset event.setValue('r',application.permUtility.setRestriction(event.getValue('crumbdata')))>
	<cfif event.getValue('r').restrict>
		<cfset event.setValue('nocache',1)>
	</cfif>
	
</cffunction>

<cffunction name="standardSetLocaleHandler" output="false" returnType="any">
	<cfargument name="event" required="true">
	<cfparam name="session.siteID" default="">
	<cfset setLocale(application.settingsManager.getSite(event.getValue('siteid')).getJavaLocale()) />
	<cfif session.siteid neq event.getValue('siteid') or not structKeyExists(session,"locale")>
		<!---These are use for admin purposes--->
		<cfset session.siteID=event.getValue('siteid')>
		<cfset session.userFilesPath = "#application.configBean.getAssetPath()#/#event.getValue('siteid')#/assets/">
		<cfset application.rbFactory.resetSessionLocale()>
	</cfif>
</cffunction>

<cffunction name="standardSetIsOnDisplayHandler" output="false" returnType="any">
	<cfargument name="event" required="true">
	<cfset var crumbdata="">
	<cfset var previewData=getCurrentUser().getValue("ChangesetPreviewData")>
	
	<cfif isStruct(previewData) and listFind(previewData.contentIdList,"'#event.getValue("contentBean").getContentID()#'")>
		<cfif arrayLen(event.getValue('crumbData')) gt 1>
			<cfset crumbdata=event.getValue('crumbdata')>
			<cfset event.setValue('isOnDisplay',application.contentUtility.isOnDisplay(event.getValue('contentBean').getdisplay(),event.getValue('contentBean').getdisplaystart(),event.getValue('contentBean').getdisplaystop(),event.getValue('siteID'),event.getValue('contentBean').getparentid(),crumbdata[2].type))>
		<cfelse>
			<cfset event.setValue('isOnDisplay',application.contentUtility.isOnDisplay(event.getValue('contentBean').getdisplay(),event.getValue('contentBean').getdisplaystart(),event.getValue('contentBean').getdisplaystop(),event.getValue('siteID'),event.getValue('contentBean').getparentid(),"Page"))>
		</cfif>
	<cfelseif event.valueExists('previewID')>
		<cfset event.setValue('isOnDisplay',1)>
	<cfelseif event.getValue('contentBean').getapproved() eq 0>
		<cfset event.setValue('track',0)>
		<cfset event.setValue('nocache',1)>
		<cfset event.setValue('isOnDisplay',0)>
	<cfelseif arrayLen(event.getValue('crumbData')) gt 1>
		<cfset crumbdata=event.getValue('crumbdata')>
		<cfset event.setValue('isOnDisplay',application.contentUtility.isOnDisplay(event.getValue('contentBean').getdisplay(),event.getValue('contentBean').getdisplaystart(),event.getValue('contentBean').getdisplaystop(),event.getValue('siteID'),event.getValue('contentBean').getparentid(),crumbdata[2].type))>
	<cfelse>
		<cfset event.setValue('isOnDisplay',1)>
	</cfif>
	
</cffunction>

<cffunction name="standardSetContentRendererHandler" output="false" returnType="any">
	<cfargument name="event" required="true">
	<cfset var $=event.getValue("muraScope")>
	<cfset var themeRenderer="">
	<cfset event.setValue('contentRenderer',createObject("component","#event.getSite().getAssetMap()#.includes.contentRenderer").init(event=event,$=$,mura=$))/>
	<cfif fileExists(expandPath(event.getSite().getThemeIncludePath()) & "/contentRenderer.cfc")>
		<cfset themeRenderer=createObject("component","#event.getSite().getThemeAssetMap()#.contentRenderer").init()>
		<cfset themeRenderer.injectMethod("mura",$)>
		<cfset themeRenderer.injectMethod("$",$)>
		<cfset themeRenderer.injectMethod("event",event)>
		<cfset event.setValue("themeRenderer",themeRenderer)>
	</cfif>
</cffunction>

<cffunction name="standardSetContentHandler" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfset var renderer=event.getValue("contentRenderer")>
	<cfset var themeRenderer=event.getValue("themeRenderer")>
	
	<cfif event.valueExists('previewID')>
		<cfset event.getHandler("standardSetPreview").handle(event)>
	<cfelse>
		<cfset event.getHandler("standardSetAdTracking").handle(event)>
		
		<cfif not event.valueExists('contentBean')>
			<cfif len(event.getValue('linkServID'))>
				<cfset event.setValue('contentBean',application.contentManager.getActiveContent(listFirst(event.getValue('linkServID')),event.getValue('siteid'),true)) />
			<cfelse>
				<cfset event.setValue('contentBean',application.contentManager.getActiveContentByFilename(event.getValue('currentFilenameAdjusted'),event.getValue('siteid'),true)) />
			</cfif>
		</cfif>
	</cfif>
	
	<cfset event.getValidator("standard404").validate(event)>
	
	<cfset event.setValue('forceSSL',event.getValue('contentBean').getForceSSL())/>
	
	<cfif not event.valueExists('crumbdata')>
		<cfset event.setValue('crumbdata',application.contentGateway.getCrumbList(event.getValue('contentBean').getcontentid(),event.getContentBean().getSiteID(),true,event.getValue('contentBean').getPath())) />
	</cfif>
	
	<cfset renderer.crumbdata=event.getValue("crumbdata")>
	
	<cfif isObject(themeRenderer)>
		<cfset themeRenderer.crumbdata=event.getValue("crumbdata")>
	</cfif>
</cffunction>

<cffunction name="standardSetAdTrackingHandler" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfif event.getValue('trackSession')>
		<cfset event.setValue('track',1)>
	<cfelse>
		<cfset event.setValue('track',0)>
	</cfif>
	
</cffunction>

<cffunction name="standardRequireLoginHandler" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfset var loginURL = "" />
	
	<cfif event.getValue('isOnDisplay') and event.getValue('r').restrict and not event.getValue('r').loggedIn and (event.getValue('display') neq 'login' and event.getValue('display') neq 'editProfile')>
		<cfset loginURL = application.settingsManager.getSite(request.siteid).getLoginURL() />
		<cfif find('?', loginURL)>
			<cfset loginURL &= "&returnURL=#URLEncodedFormat(event.getValue('contentRenderer').getCurrentURL())#" />
		<cfelse>
			<cfset loginURL &= "?returnURL=#URLEncodedFormat(event.getValue('contentRenderer').getCurrentURL())#" />
		</cfif>
		<cflocation addtoken="no" url="#loginURL#">
	</cfif>

</cffunction>

<cffunction name="standardPostLogoutHandler" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cflocation url="#event.getValue('contentRenderer').getCurrentURL()#" addtoken="false">

</cffunction>

<cffunction name="standardMobileHandler" output="false" returnType="any">
	<cfargument name="event" required="true">
	<cfset var renderer=event.getValue("contentRenderer")>
	
	<cfif fileExists(ExpandPath( "#event.getSite().getThemeIncludePath()#/templates/mobile.cfm"))>
		<cfset renderer.listFormat="ul">
		<cfset event.getValue("contentBean").setTemplate("mobile.cfm")>
		<cfset renderer.showAdminToolbar=false>
		<cfset renderer.showMemberToolbar=false>
		<cfset renderer.showEditableObjects=false>
	<cfelse>
		<cfcookie name="mobileFormat" value="false" />
	</cfif>
</cffunction>

<cffunction name="standardLinkTranslationHandler" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfset event.getTranslator('standardLink').translate(event) />

</cffunction>

<cffunction name="standardForceSSLHandler" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfif application.utility.isHTTPS()>
		<cflocation addtoken="no" url="http://#application.settingsManager.getSite(event.getValue('siteID')).getDomain()##application.configBean.getServerPort()##event.getContentRenderer().getCurrentURL(false)#">
	<cfelse>
		<cflocation addtoken="no" url="https://#application.settingsManager.getSite(event.getValue('siteID')).getDomain()##application.configBean.getServerPort()##event.getContentRenderer().getCurrentURL(false)#">
	</cfif>
</cffunction>

<cffunction name="standardFileTranslationHandler" output="false" returnType="any">
	<cfargument name="event" required="true">

	<cfset event.getTranslator('standardFile').translate(event) />

</cffunction>

<cffunction name="standardDoResponseHandler" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfset var showMeta=0>
	<cfset var renderer="">
	<cfset var siteRenderer=arguments.event.getContentRenderer()>
	<cfset var themeRenderer=arguments.event.getThemeRenderer()>
	<cfset var translator="">
	<cfif isObject(themeRenderer) and structKeyExists(themeRenderer,"showItemMeta")>
		<cfset renderer=themeRenderer>
	<cfelse>
		<cfset renderer=siteRenderer>
	</cfif>
	
	<cfset application.pluginManager.announceEvent('onRenderStart', event)/>
	
	<cfswitch expression="#event.getValue('contentBean').getType()#">
	<cfcase value="File,Link">
			
		<cfif event.getValue('isOnDisplay') and ((not event.getValue('r').restrict) or (event.getValue('r').restrict and event.getValue('r').allow))>			
			<cfif event.getValue('showMeta') neq 1>
				<cfswitch expression="#event.getValue('contentBean').getType()#">
					<cfcase value="Link">
						<cfif not renderer.showItemMeta("Link") or event.getValue('showMeta') eq 2>
							<cfset translator=event.getHandler('standardLinkTranslation')>
						<cfelse>
							<cfset translator=event.getHandler('standardTranslation')>
						</cfif>
					</cfcase>
					<cfcase value="File">		
						<cfif not renderer.showItemMeta(event.getValue('contentBean').getFileExt()) or event.getValue('showMeta') eq 2>
							<!---<cftry>--->
							<cfset translator=event.getHandler('standardFileTranslation')>
							<!---
							<cfcatch>
								<cfset event.setValue('contentBean',application.contentManager.getActiveContentByFilename("404",event.getValue('siteID'))) />
								<cfset event.getHandler('standardTranslation').handle(event) />
							</cfcatch>
							</cftry>
							--->
						<cfelse>
							<cfset translator=event.getHandler('standardTranslation')>	
						</cfif>
					</cfcase>
				</cfswitch>
			<cfelse>
				<cfset translator=event.getHandler('standardTranslation')>	
			</cfif>
		<cfelse>
			<cfset translator=event.getHandler('standardTranslation')>	
		</cfif>	
	</cfcase>
	<cfdefaultcase>
		<cfset translator=event.getHandler('standardTranslation')>
	</cfdefaultcase>
	</cfswitch>
	
	<cfset translator.handle(event) />
	
	<cfset application.pluginManager.announceEvent('onRenderEnd', event)/>
	<cfset event.getValidator('standardForceSSL').validate(event)>

</cffunction>

<cffunction name="standard404Handler" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfif event.getValue("contentBean").getIsNew()>
		<cfset getPluginManager().announceEvent("onSite404",arguments.event)>
	</cfif>

	<cfif event.getValue("contentBean").getIsNew()>
		<cfset arguments.event.setValue('contentBean',application.contentManager.getActiveContentByFilename("404",arguments.event.getValue('siteid'),true)) />
			
		<cfif len(arguments.event.getValue('previewID'))>
			<cfset arguments.event.getContentBean().setBody("The requested version of this content could not be found.")>
		</cfif>
		<cfheader statuscode="404" statustext="Content Not Found" /> 
	</cfif>
	
</cffunction>

<cffunction name="standardDoActionsHandler" output="false" returnType="any">
<cfargument name="event" required="true">

<cfset var a=""/>

<cfif event.getValue('doaction') neq ''>
<cfloop list="#event.getValue('doaction')#" index="a">
<cfset doAction(a,event)>
</cfloop>
</cfif>

</cffunction>

<cffunction name="doAction" output="false">
<cfargument name="theaction" type="string" default="">
<cfargument name="event" required="true">

		<cfswitch expression="#arguments.theaction#">
			<cfcase value="login">
				<cfif fileExists(expandPath("/#application.configBean.getWebRootMap()#/#event.getValue('siteid')#/includes/loginHandler.cfc"))>
					<cfset createObject("component","#application.configBean.getWebRootMap()#.#event.getValue('siteid')#.includes.loginHandler").init().handleLogin(event.getAllValues())>
				<cfelse>
					<cfset application.loginManager.login(event.getAllValues(),'') />
				</cfif>
			</cfcase>
			
			<cfcase value="return">
				<cfset application.emailManager.track(event.getValue('emailID'),event.getValue('email'),'returnClick')>
			</cfcase>
			
			<cfcase value="logout">
				<cfset application.loginManager.logout()>
				<cfset event.getHandler("standardPostLogout").handle(event)>
			</cfcase>
			
			<cfcase value="updateprofile">
				<cfif session.mura.isLoggedIn>
					<cfset arguments.event.setValue("userID",session.mura.userID)>
					<cfif isDefined('request.addressAction')>
						<cfif event.getValue('addressAction') eq "create">
							<cfset application.userManager.createAddress(event.getAllValues())>
						<cfelseif event.getValue('addressAction') eq "update">
							<cfset application.userManager.updateAddress(event.getAllValues())>
						<cfelseif event.getValue('addressAction') eq "delete">
							<cfset application.userManager.deleteAddress(event.getValue('addressID'))>
						</cfif>
						<!--- reset the form --->
						<cfset event.setValue('addressID','')>
						<cfset event.setValue('addressAction','')>
					<cfelse>
						<cfset event.setValue('userBean',application.userManager.update( getBean("user").loadBy(userID=event.getValue("userID")).set(event.getAllValues()).getAllValues() , iif(event.valueExists('groupID'),de('true'),de('false')),true,event.getValue('siteID'))) />
						<cfif structIsEmpty(event.getValue('userBean').getErrors())>
							<cfset application.loginManager.loginByUserID(event.getAllValues())>
						</cfif>
					</cfif>
				</cfif>
			</cfcase>
			
			<cfcase value="createprofile">
				<cfif application.settingsManager.getSite(event.getValue('siteid')).getextranetpublicreg() eq 1>
					<cfset arguments.event.setValue("userID","")>
					
					<cfif event.valueExists("useProtect")>
						<cfset event.setValue("passedProtect",application.utility.cfformprotect(event))>
					</cfif>
					
					<cfset event.setValue('userBean',  getBean("user").loadBy(userID=event.getValue("userID")).set(event.getAllValues()).save() ) />		
					<cfif structIsEmpty(event.getValue('userBean').getErrors()) and not event.valueExists('passwordNoCache')>
						<cfset application.userManager.sendLoginByUser(event.getValue('userBean'),event.getValue('siteid'),event.getValue('contentRenderer').getCurrentURL(),true) />
					<cfelseif structIsEmpty(event.getValue('userBean').getErrors()) and event.valueExists('passwordNoCache') and event.getValue('userBean').getInactive() eq 0>	
						<cfset event.setValue('userID',event.getValue('userBean').getUserID()) />
						<cfset application.loginManager.loginByUserID(event.getAllValues())>
					</cfif>
				</cfif>
			</cfcase>
			
			<cfcase value="contactsend">
				<cfparam name="request.company" default="">
				<cfset getBean("mailer").send(event.getAllValues(),event.getValue('sendTo'),'#iif(event.getValue('fname') eq '' and event.getValue('lname') eq '',de('#event.getValue('company')#'),de('#event.getValue('fname')# #event.getValue('lname')#'))#',event.getValue('subject'),event.getValue('siteID'),event.getValue('email'))>
			</cfcase>
			
			<cfcase value="subscribe">
				<cfif event.valueExists("useProtect")>
					<cfset event.setValue("passedProtect",application.utility.cfformprotect(event))>
				<cfelse>
					<cfset event.setValue("passedProtect",true)>
				</cfif>
				
				<cfif event.getValue("passedProtect")>
					<cfset application.mailinglistManager.createMember(event.getAllValues())>
				</cfif>
			</cfcase>
			
			<cfcase value="unsubscribe">
				<cfset application.mailinglistManager.deleteMember(event.getAllValues())>
			</cfcase>
			
			<cfcase value="masterSubscribe">
				<cfif event.valueExists("useProtect")>
					<cfset event.setValue("passedProtect",application.utility.cfformprotect(event))>
				<cfelse>
					<cfset event.setValue("passedProtect",true)>
				</cfif>
				
				<cfif event.getValue("passedProtect")>
					<cfset application.mailinglistManager.masterSubscribe(event.getAllValues())/>
				</cfif>
			</cfcase>
			
			<cfcase value="setReminder">
				<cfif event.valueExists("useProtect")>
					<cfset event.setValue("passedProtect",application.utility.cfformprotect(event))>
				<cfelse>
					<cfset event.setValue("passedProtect",true)>
				</cfif>
				
				<cfif event.getValue("passedProtect")>
					<cfset application.contentManager.setReminder(event.getValue('contentBean').getcontentid(),event.getValue('siteID'),event.getValue('email'),event.getValue('contentBean').getdisplaystart(),event.getValue('interval')) />
				</cfif>
			</cfcase>
			
			<cfcase value="forwardEmail">
				<cfif event.valueExists("useProtect")>
					<cfset event.setValue("passedProtect",application.utility.cfformprotect(event))>
				<cfelse>
					<cfset event.setValue("passedProtect",true)>
				</cfif>
				
				<cfif event.getValue("passedProtect")>
					<cfset event.setValue('to',event.getValue('to1'))/>
					<cfset event.setValue('to',listAppend(event.getValue('to'),event.getValue('to2'))) />
					<cfset event.setValue('to',listAppend(event.getValue('to'),event.getValue('to3'))) />
					<cfset event.setValue('to',listAppend(event.getValue('to'),event.getValue('to4'))) />
					<cfset event.setValue('to',listAppend(event.getValue('to'),event.getValue('to5'))) />
					<cfset application.emailManager.forward(event.getAllValues()) />
				</cfif>
			</cfcase>
			
		</cfswitch>

</cffunction> 

<!--- VALIDATORS --->
<cffunction name="standardWrongDomainValidator" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfif (application.configBean.getMode() eq 'production' and yesNoFormat(event.getValue("muraValidateDomain"))
				and not application.settingsManager.getSite(request.siteID).isValidDomain(domain:listFirst(cgi.http_host,":"), mode: "either")) 
				and not (listFirst(cgi.http_host,":") eq 'LOCALHOST' and cgi.HTTP_USER_AGENT eq 'vspider')>
			<cfset event.getHandler("standardWrongDomain").handle(event)>
		</cfif>
</cffunction>

<cffunction name="standardTrackSessionValidator" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfif event.getValue('trackSession') 
			and len(event.getValue('contentBean').getcontentID()) 
			and event.getValue('contentBean').getIsNew() eq 0 
			and event.getValue('contentBean').getActive() eq 1
			and not event.valueExists('previewID')>
			<cfset event.getHandler("standardTrackSession").handle(event)>
	</cfif>
</cffunction>

<cffunction name="standardRequireLoginValidator" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfif event.getValue('isOnDisplay') and event.getValue('r').restrict 
			and not event.getValue('r').loggedIn 
			and (event.getValue('display') neq 'login' and event.getValue('display') neq 'editProfile')>
			<cfset event.getHandler("standardRequireLogin").handle(event)>
	</cfif>
</cffunction>

<cffunction name="standardMobileValidator" output="false" returnType="any">
	<cfargument name="event" required="true">
	<cfif request.muraMobileRequest and not len(event.getValue('altTheme'))>
		<cfset event.getHandler("standardMobile").handle(event)>
	</cfif>
</cffunction>

<cffunction name="standardForceSSLValidator" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfif event.getValue("contentBean").getFilename() neq "404" 
			and 
			(
				(event.getValue('forceSSL') or (event.getValue('r').restrict and application.settingsManager.getSite(event.getValue('siteID')).getExtranetSSL() eq 1)) and not application.utility.isHTTPS()
				)
			or	(
				not (event.getValue('r').restrict or event.getValue('forceSSL')) and application.utility.isHTTPS()	
			)>
		<cfset event.getHandler("standardForceSSL").handle(event)>
	</cfif>
</cffunction>

<cffunction name="standard404Validator" output="false" returnType="any">
	<cfargument name="event" required="true">

	<cfif event.getValue('contentBean').getIsNew() eq 1>
		<cfset event.getHandler("standard404").handle(event)>
	</cfif>

</cffunction>

<!--- TRANSLATORS --->
<cffunction name="standardFileTranslator" output="false" returnType="any">
	<cfargument name="event" required="true">
	<cfset event.getValue('contentRenderer').renderFile(event.getValue('contentBean').getFileID()) />
</cffunction>

<cffunction name="standardLinkTranslator" output="false" returnType="any">
	<cfargument name="event" required="true">
	<cfset var theLink=event.getValue('contentRenderer').setDynamicContent(event.getValue('contentBean').getFilename())>
	
	<cfif left(theLink,1) eq "?">
		<cfset theLink="/" & theLink>
	</cfif>
	<cflocation addtoken="no" statuscode="301" url="#theLink#">
</cffunction>

</cfcomponent>