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

<cffunction name="init" access="public" returntype="any" output="false">
<cfargument name="userUtility" type="any" required="yes"/>
<cfargument name="userDAO" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>
<cfargument name="permUtility" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>
		<cfset variables.userUtility=arguments.userUtility />
		<cfset variables.userDAO=arguments.userDAO />
		<cfset variables.globalUtility=arguments.utility />
		<cfset variables.permUtility=arguments.permUtility />
		<cfset variables.settingsManager=arguments.settingsManager />
		
<cfreturn this />
</cffunction>

<cffunction name="rememberMe" access="public" returntype="boolean" output="false">
	<cfargument name="userid" required="yes" type="string" default="" />
	<cfargument name="userHash" required="yes" type="string" default="" />
	
	<cfset var rsUser=variables.userDAO.readUserHash(arguments.userid)/>
	<cfset var isLoggedin=0/>
	
	<cfif not len(arguments.userHash) or arguments.userHash eq rsUser.userHash>
		<cfset isloggedin=variables.userUtility.loginByUserID(rsUser.userID,rsUser.siteID)>
	</cfif>
	
	<cfif isloggedin>
		<cfset session.rememberMe=1>
		<cfreturn true />
	<cfelse>
		<cfset structDelete(cookie,"userid")>
		<cfset structDelete(cookie,"userhash")>
		<cfset session.rememberMe=0>
		<cfreturn false />
	</cfif>
	
</cffunction>

<cffunction name="handleSuccess" output="false">
	<cfargument name="returnUrl" default="">
	<cfargument name="rememberMe" default="0">
	<cfargument name="contentid" default="">
	<cfargument name="linkServID" default="">
	<cfargument name="isAdminLogin"default="false">
	<cfargument name="compactDisplay" default="false">
	<cfargument name="deviceid" default="">
	<cfargument name="publicDevice" default="false">
	
	<cfset var isloggedin =false />
	<cfset var site=""/>
	<cfset var returnDomain="">
	<cfset var returnProtocol="">
	<cfset var indexFile="./">
	<cfset var loginURL="" />

	<cfif isDefined('session.mfa')>
		<cfset structDelete(session,'mfa')>
	</cfif>

	<cfif arguments.isAdminLogin>
		<cfset indexFile="./">
	</cfif>

	<cfset session.rememberMe=arguments.rememberMe />

	<cfif listFind(session.mura.memberships,'S2IsPrivate')>

		<cfset session.siteArray=arrayNew(1) />
			<cfloop collection="#variables.settingsManager.getSites()#" item="site">
			<cfif variables.permUtility.getModulePerm("00000000000000000000000000000000000","#site#")>
					<cfset arrayAppend(session.siteArray,site) />
			</cfif>
		</cfloop>
	
		<cfif arguments.returnUrl eq ''>				
			<cfif len(arguments.linkServID)>
				<cfset arguments.returnURL="#indexFile#?LinkServID=#arguments.linkServID#">
			<cfelse>
				<cfset arguments.returnURL="#indexFile#">
			</cfif>	
		<cfelse>
			<cfset arguments.returnURL = getBean('utility').sanitizeHREF(replace(arguments.returnUrl, 'doaction=logout', '', 'ALL'))>
		</cfif>
	<cfelseif arguments.returnUrl neq ''>
		<cfset arguments.returnURL = getBean('utility').sanitizeHREF(replace(arguments.returnUrl, 'doaction=logout', '', 'ALL'))>
	<cfelse>
		<cfif len(arguments.linkServID)>
			<cfset arguments.returnURL="#indexFile#?LinkServID=#arguments.linkServID#">
		<cfelse>
			<cfset arguments.returnURL="#indexFile#">
		</cfif>
	</cfif>

	<cfset structDelete(session,'mfa')>

	<cfif request.muraAPIRequest>
		<cfset request.muraJSONRedirectURL=arguments.returnURL>
	<cfelse>
		<cflocation url="#arguments.returnURL#" addtoken="false">
	</cfif>

</cffunction>

<cffunction name="sendAuthCode" output="false">
	<cfset sendAuthCodeByEmail()>
</cffunction>

<cffunction name="sendAuthCodeByEmail" output="false">
<cfset var site=getBean('settingsManager').getSite(session.mfa.siteid)>
<cfset var contactEmail=site.getContact()>
<cfset var contactName=site.getSite()>
<cfset var mailText=site.getSendAuthCodeScript()>
<cfset var user=getBean('user').loadBy(userid=session.mfa.userid,siteid=session.mfa.siteid)>
<cfset var firstName=user.getFname()>
<cfset var lastName=user.getLname()>
<cfset var email=user.getEmail()>
<cfset var username=user.getUsername()>
<cfset var authcode=session.mfa.authcode>
<cfset var mailer=getBean('mailer')>

<cfif getBean('configBean').getValue(property='MFAPerDevice',defaultValue=false)>
	<cfset var emailtitle=application.rbFactory.getKeyValue(session.rb,'login.deviceauthorizationcode')>
<cfelse>
	<cfset var emailtitle=application.rbFactory.getKeyValue(session.rb,'login.authorizationcode')>
</cfif>

<cfif not len(mailText)>
<cfsavecontent variable="mailText">
<cfoutput>#firstName#,

Here is the authorization code you requested for username: #username#. It expires in the next 3 hours.

Authorization Code: #authcode#

If you did not request a new authorization, contact #contactEmail#.
</cfoutput>
</cfsavecontent>

<cfelse>
	<cfset var finder=refind('##.+?##',mailText,1,"true")>
	<cfloop condition="#finder.len[1]#">
		<cftry>
			<cfset mailText=replace(mailText,mid(mailText, finder.pos[1], finder.len[1]),'#trim(evaluate(mid(mailText, finder.pos[1], finder.len[1])))#')>
			<cfcatch>
				<cfset mailText=replace(mailText,mid(mailText, finder.pos[1], finder.len[1]),'')>
			</cfcatch>
		</cftry>
		<cfset finder=refind('##.+?##',mailText,1,"true")>
	</cfloop>
</cfif>

<cfset mailer.sendText(trim(mailText),
	email,
	contactEmail,
	emailtitle,
	user.getSiteID()
	) />

</cffunction>

<cffunction name="handleChallenge" output="false">
	<cfargument name="rememberMe" default="0">
	<cfargument name="contentid" default="">
	<cfargument name="linkServID" default="">
	<cfargument name="isAdminLogin" default="false">
	<cfargument name="compactDisplay" default="false">
	<cfargument name="deviceid" default="">
	<cfargument name="publicDevice" default="false">

	<cfset session.mfa.authcode=userUtility.getRandomPassword()>

	<cfif getBean('configBean').getValue(property='MFASendAuthCode',defaultValue=true)>
		<cfset sendAuthCode()>
	</cfif>

	<cfif arguments.isAdminLogin>
		<cflocation url="./?muraAction=cLogin.main&display=login&status=challenge&rememberMe=#arguments.rememberMe#&contentid=#arguments.contentid#&LinkServID=#arguments.linkServID#&returnURL=#urlEncodedFormat(arguments.returnUrl)#&compactDisplay=#urlEncodedFormat(arguments.compactDisplay)#" addtoken="false">
	<cfelse>
		<cfset loginURL = application.settingsManager.getSite(request.siteid).getLoginURL() />
		<cfif find('?', loginURL)>
			<cfset loginURL &= "&status=challenge&rememberMe=#arguments.rememberMe#&contentid=#arguments.contentid#&LinkServID=#arguments.linkServID#&returnURL=#urlEncodedFormat(arguments.returnUrl)#" />
		<cfelse>
			<cfset loginURL &= "?status=challenge&rememberMe=#arguments.rememberMe#&contentid=#arguments.contentid#&LinkServID=#arguments.linkServID#&returnURL=#urlEncodedFormat(arguments.returnUrl)#" />
		</cfif>
		<cfif request.muraAPIRequest>
			<cfset request.muraJSONRedirectURL=loginURL>
		<cfelse>
			<cflocation url="#loginURL#" addtoken="false">
		</cfif>
	</cfif>

</cffunction>

<cffunction name="handleFailure" output="false">
	<cfargument name="rememberMe" default="0">
	<cfargument name="contentid" default="">
	<cfargument name="linkServID" default="">
	<cfargument name="isAdminLogin" default="false">
	<cfargument name="compactDisplay" default="false">
	<cfargument name="deviceid" default="">
	<cfargument name="publicDevice" default="false">

	<cfset structDelete(session,'mfa')>

	<cfif arguments.isAdminLogin>
		<cflocation url="./?muraAction=cLogin.main&display=login&status=failed&rememberMe=#arguments.rememberMe#&contentid=#arguments.contentid#&LinkServID=#arguments.linkServID#&returnURL=#urlEncodedFormat(arguments.returnUrl)#&compactDisplay=#urlEncodedFormat(arguments.compactDisplay)#" addtoken="false">
	<cfelse>
		<cfset loginURL = application.settingsManager.getSite(request.siteid).getLoginURL() />
		<cfif find('?', loginURL)>
			<cfset loginURL &= "&status=failed&rememberMe=#arguments.rememberMe#&contentid=#arguments.contentid#&LinkServID=#arguments.linkServID#&returnURL=#urlEncodedFormat(arguments.returnUrl)#" />
		<cfelse>
			<cfset loginURL &= "?status=failed&rememberMe=#arguments.rememberMe#&contentid=#arguments.contentid#&LinkServID=#arguments.linkServID#&returnURL=#urlEncodedFormat(arguments.returnUrl)#" />
		</cfif>
		<cfif request.muraAPIRequest>
			<cfset request.muraJSONRedirectURL=loginURL>
		<cfelse>
			<cflocation url="#loginURL#" addtoken="false">
		</cfif>
	</cfif>
</cffunction>

<cffunction name="attemptChallenge" output="false">
	<cfargument name="$">
	<cfreturn len(arguments.$.event('authcode')) and isDefined('session.mfa.authcode') and arguments.$.event('authcode') eq session.mfa.authcode>
</cffunction>

<cffunction name="handleChallengeAttempt" output="false">
	<cfargument name="$">
	<cfif isBoolean(arguments.$.event('attemptChallenge')) and arguments.$.event('attemptChallenge')>
		<cfset var strikes = createObject("component","mura.user.userstrikes").init(session.mfa.username,getBean('configBean'))>
		<cfparam name="session.blockLoginUntil" type="string" default="#strikes.blockedUntil()#" />
		<cfif attemptChallenge($=arguments.$)>
			<cfset strikes.clear()>
			<cfreturn true>
		<cfelse>
			<cfset strikes.addStrike()>
		</cfif>
	</cfif>
	<cfreturn false>
</cffunction>

<cffunction name="completedChallenge" output="false">
	<cfargument name="$">
	<cfif isDefined('session.mfa')>
		<cfif getBean('configBean').getValue(property='MFA',defaultValue=false) and isBoolean(arguments.$.event('rememberdevice')) and arguments.$.event('rememberdevice')>
			<cfset var userDevice=getBean('userDevice')
						.loadBy(
							userid=session.mfa.userid,
							deviceid=session.mfa.deviceid,
							siteid=session.mfa.siteid
						)
						.setLastLogin(now())
						.save()>
		</cfif>
		<cfset variables.userUtility.loginByUserID(argumentCollection=session.mfa)>
		<cfset handleSuccess(argumentCollection=session.mfa)>
	</cfif>	
</cffunction>

<cffunction name="login" access="public" output="false">
	<cfargument name="data" type="struct" />
	<cfargument name="loginObject" type="any"  required="true" default=""/>

	<cfset var isloggedin =false />
	<cfset var returnUrl ="" />
	<cfset var site=""/>
	<cfset var returnDomain="">
	<cfset var returnProtocol="">
	<cfset var indexFile="./">
	<cfset var loginURL="" />

	<cfset structDelete(session,'mfa')>

	<cfparam name="arguments.data.returnUrl" default="" />
	<cfparam name="arguments.data.rememberMe" default="0" />
	<cfparam name="arguments.data.contentid" default="" />
	<cfparam name="arguments.data.linkServID" default="" />
	<cfparam name="arguments.data.isAdminLogin" default="false" />
	<cfparam name="arguments.data.compactDisplay" default="false" />

	<cfif not isdefined('arguments.data.username')>
		<cfif request.muraAPIRequest>
			<cfset request.muraJSONRedirectURL="#indexFile#?muraAction=clogin.main&linkServID=#arguments.data.linkServID#">
			<cfreturn false>
		<cfelse>
			<cflocation url="#indexFile#?muraAction=clogin.main&linkServID=#arguments.data.linkServID#" addtoken="false">
		</cfif>
	<cfelse>
		
		<cfif getBean('configBean').getValue(property='MFA',defaultValue=false)>
			<cfset var rsUser=variables.userUtility.lookupByCredentials(arguments.data.username,arguments.data.password,arguments.data.siteid)>

			<cfif rsUser.recordcount>
			
				<cfset var $=getBean('$').init(arguments.data.siteid)>

				<cfset session.mfa={
					userid=rsuser.userid,
					siteid=rsuser.siteid,
					username=rsuser.username,
					returnUrl=arguments.data.returnURL,
					rememberMe=arguments.data.rememberMe,
					contentid=arguments.data.contentid,
					linkServID=arguments.data.linkServID,
					isAdminLogin=arguments.data.isAdminLogin,
					compactDisplay=arguments.data.compactDisplay,
					deviceid=cookie.originalurltoken}>

				<!--- if the deviceid is supplied then check to see if the user has validated the device--->
				<cfif getBean('configBean').getValue(property='MFAPerDevice',defaultValue=false)>	

					<cfset var userDevice=$.getBean('userDevice').loadBy(userid=session.mfa.userid,deviceid=session.mfa.deviceid,siteid=session.mfa.siteid)>
					
					<cfif userDevice.exists()>
						<cfset userDevice.setLastLogin(now()).save()>
						<cfset userUtility.loginByUserId(siteid=rsuser.siteid,userid=rsuser.userid)>
						<cfset handleSuccess(argumentCollection=session.mfa)>
						<cfreturn true>
					</cfif>	
				</cfif>

				<cfset handleChallenge(argumentCollection=arguments.data)>
				<cfreturn false>
			<cfelse>
				<cfset handleFailure(argumentCollection=arguments.data)>
				<cfreturn false>
			</cfif>
		<cfelse>

			<cfif not isObject(arguments.loginObject)>
				<cfset isloggedin=variables.userUtility.login(arguments.data.username,arguments.data.password,arguments.data.siteid)>
			<cfelse>
				<cfset isloggedin=arguments.loginObject.login(arguments.data.username,arguments.data.password,arguments.data.siteid)>
			</cfif>
			
			<cfif isloggedin>
				<cfset handleSuccess(argumentCollection=arguments.data)>
				<cfreturn true>
			<cfelse>
				<cfset handleFailure(argumentCollection=arguments.data)>
				<cfreturn false>
			</cfif>

		</cfif>
	</cfif>

</cffunction>

<cffunction name="remoteLogin" access="public" output="false" returntype="any">
	<cfargument name="data" type="struct" />
	<cfargument name="loginObject" type="any"  required="true" default=""/>

	<cfset var isloggedin =false />
	<cfset var returnUrl ="" />
	<cfset var site=""/>

	<cfif not isdefined('arguments.data.username')
		or not isdefined('arguments.data.password')
		or not isdefined('arguments.data.siteid')>

		<cfreturn false>

	<cfelse>	
		<cfreturn login(data=arguments.data)>
	</cfif>

</cffunction>

<cffunction name="loginByUserID" access="public" output="true">
	<cfargument name="data" type="struct" />
	<cfset var isloggedin =false />
	<cfset var returnURL=""/>
	<cfset var site=""/>
	<cfset var returnDomain=""/> 

	<cfparam name="arguments.data.redirect" default="" />
	<cfparam name="arguments.data.returnUrl" default="" />
	<cfparam name="arguments.data.rememberMe" default="0" />
	<cfparam name="arguments.data.contentid" default="" />
	<cfparam name="arguments.data.linkServID" default="" />
	<cfparam name="arguments.data.contentid" default="" />
	<cfparam name="arguments.data.compactDisplay" default="false" />
	<cfparam name="arguments.data.isAdminLogin" default="false" />

	<cfset session.rememberMe=arguments.data.rememberMe />

	<cfif not isdefined('arguments.data.userid')>

		<cflocation url="./?muraAction=clogin.main&linkServID=#arguments.data.linkServID#" addtoken="false">

	<cfelse>
		<cfif getBean('configBean').getValue(property='MFA',defaultValue=false)>
			<cfset var $=getBean('$').init(arguments.data.siteid)>

			<cfset var user=$.getBean('user').loadBy(userid=arguments.data.userid,siteid=arguments.data.siteid)>

			<cfif user.exists()>
			
				<cfset session.mfa={
					userid=user.getUserID(),
					siteid=user.getSiteID(),
					username=user.getUsername(),
					returnUrl=arguments.data.returnURL,
					redirect=arguments.data.redirect,
					rememberMe=arguments.data.rememberMe,
					contentid=arguments.data.contentid,
					linkServID=arguments.data.linkServID,
					isAdminLogin=arguments.data.isAdminLogin,
					compactDisplay=arguments.data.compactDisplay,
					deviceid=session.trackingID}>

				<!--- if the deviceid is supplied then check to see if the user has validated the device--->
				<cfif getBean('configBean').getValue(property='MFAPerDevice',defaultValue=false)>	

					<cfset var userDevice=$.getBean('userDevice').loadBy(userid=arguments.data.userid,deviceid=session.mfa.deviceid)>
					
					<cfif userDevice.exists()>
						<cfset userDevice.setLastLogin(now()).save()>
						<cfset userUtility.loginByUserId(siteid=rsuser.siteid,userid=rsuser.userid)>
						<cfset handleSuccess(argumentCollection=session.mfa)>
						<cfreturn true>
					</cfif>	
				</cfif>

				<cfset handleChallenge(argumentCollection=arguments.data)>
				<cfreturn false>
			<cfelse>
				<cfset handleFailure(argumentCollection=arguments.data)>
				<cfreturn false>
			</cfif>
		<cfelse>
			<cfset isloggedin=variables.userUtility.loginByUserID(arguments.data.userID,arguments.data.siteid)>
			
			<cfif isloggedin>
				<cfset handleSuccess(argumentCollection=arguments.data)>
				<cfreturn true>
			<cfelse>
				<cfset handleFailure(argumentCollection=arguments.data)>
				<cfreturn false>
			</cfif>
		</cfif>
	</cfif>

</cffunction>


<cffunction name="logout" returntype="void" access="public" output="false">
	<cfset var pluginEvent="">

	<cfif structKeyExists(request,"servletEvent")>
		<cfset pluginEvent=request.servletEvent>
	<cfelseif structKeyExists(request,"event")>
		<cfset pluginEvent=request.event>
	<cfelse>
		<cfset pluginEvent = new mura.event() />
	</cfif>

	<cfif len(pluginEvent.getValue("siteID"))>
		<cfset getPluginManager().announceEvent('onSiteLogout',pluginEvent)/>
		<cfset getPluginManager().announceEvent('onBeforeSiteLogout',pluginEvent)/>
	<cfelse>
		<cfset getPluginManager().announceEvent('onGlobalLogout',pluginEvent)/>
		<cfset getPluginManager().announceEvent('onBeforeGlobalLogout',pluginEvent)/>
	</cfif>

	<cflogout>

	<cfif getBean('configBean').getValue(property='rotateSessions',defaultValue='false')>
		<cfset sessionInvalidate()>
	</cfif>

	<cfset structclear(session) />
	<cfset structDelete(cookie,"userid")>
	<cfset structDelete(cookie,"userhash")>
	<cfset variables.userUtility.setUserStruct()/>
	<cfset getBean('changesetManager').removeSessionPreviewData()>

	<cfif len(pluginEvent.getValue("siteID"))>
		<cfset getPluginManager().announceEvent('onAfterSiteLogout',pluginEvent)/>
	<cfelse>
		<cfset getPluginManager().announceEvent('onAfterGlobalLogout',pluginEvent)/>
	</cfif>
</cffunction>

</cfcomponent>