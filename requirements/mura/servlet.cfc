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
<cfcomponent output="false">
<cfset msg="">
	
<cffunction name="init" returntype="any" access="public" output="false">
<cfargument name="_event">
<cfset variables.event=arguments._event>
<cfreturn this />
</cffunction>

<cffunction name="onRequestStart" access="public" returnType="void" output="false">
</cffunction>

<cffunction name="onRequestEnd" access="public" returnType="void" output="false">
</cffunction>

<cffunction name="doAction" output="false">
<cfargument name="theaction" type="string" default="">

		<cfswitch expression="#arguments.theaction#">
			<cfcase value="login">
				<cfset createObject("component","#application.configBean.getWebRootMap()#.#request.siteid#.includes.loginHandler").init().handleLogin(event.getAllValues())>
			</cfcase>
			
			<cfcase value="return">
				<cfset application.emailManager.track(event.getValue('emailID'),event.getValue('email'),'returnClick')>
			</cfcase>
			
			<cfcase value="logout">
				<cfset application.loginManager.logout()>
				<cflocation url="#event.getValue('contentRenderer').getCurrentURL()#">
			</cfcase>
			
			<cfcase value="updateprofile">
				<cfif getAuthUser() neq ''>
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
						<cfset event.setValue('userBean',application.userManager.update(request,iif(event.valueExists('groupID'),de('true'),de('false')),iif(event.getValue('categoryID'),de('true'),de('false')),event.getValue('siteID'))) />
						<cfif structIsEmpty(event.getValue('userBean').getErrors())>
							<cfset application.loginManager.loginByUserID(event.getAllValues())>
						</cfif>
					</cfif>
				</cfif>
			</cfcase>
			
			<cfcase value="createprofile">
				<cfif application.settingsManager.getSite(event.getValue('siteid')).getextranetpublicreg() eq 1>
					<cfset event.setValue('userBean',application.userManager.create(event.getAllValues())) />		
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
				<cfset application.serviceFactory.getBean("mailer").send(event.getAllValues(),event.getValue('sendTo'),'#iif(event.getValue('fname') eq '' and event.getValue('lname') eq '',de('#event.getValue('company')#'),de('#event.getValue('fname')# #event.getValue('lname')#'))#',event.getValue('subject'),event.getValue('siteID'),event.getValue('email'))>
			</cfcase>
			
			<cfcase value="subscribe">
				<cfset application.mailinglistManager.createMember(event.getAllValues())>
			</cfcase>
			
			<cfcase value="unsubscribe">
				<cfset application.mailinglistManager.deleteMember(event.getAllValues())>
			</cfcase>
			
			<cfcase value="masterSubscribe">
				<cfset application.mailinglistManager.masterSubscribe(event.getAllValues())/>
			</cfcase>
			
			<cfcase value="setReminder">
				<cfset application.contentManager.setReminder(event.getValue('contentBean').getcontentid(),event.getValue('siteID'),event.getValue('email'),event.getValue('contentBean').getdisplaystart(),event.getValue('interval')) />
			</cfcase>
			
			<cfcase value="forwardEmail">
				<cfset event.setValue('to',event.getValue('to1'))/>
				<cfset event.setValue('to',listAppend(event.getValue('to'),event.getValue('to2'))) />
				<cfset event.setValue('to',listAppend(event.getValue('to'),event.getValue('to3'))) />
				<cfset event.setValue('to',listAppend(event.getValue('to'),event.getValue('to4'))) />
				<cfset event.setValue('to',listAppend(event.getValue('to'),event.getValue('to5'))) />
				<cfset application.emailManager.forward(event.getAllValues()) />
			</cfcase>
			
		</cfswitch>



</cffunction> 

<cffunction name="doRequest" returntype="any"  access="public" output="false">
	<cfset var a=""/>
	<cfset var crumbdata=""/>
		
	<cfif event.valueExists('previewID')>
		<cfset event.setValue('track',0)>
		<cfset event.setValue('nocache',1)>
		<cfset event.setValue('contentBean',application.contentManager.getcontentVersion(event.getValue('previewID'),event.getValue('siteID'))) />
	<cfelse>
		<cfif event.getValue('trackSession')>
			<cfset event.setValue('track',1)>
		<cfelse>
			<cfset event.setValue('track',0)>
		</cfif>
		<cfif len(event.getValue('linkServID'))>
			<cfset event.setValue('contentBean',application.contentManager.getActiveContent(event.getValue('linkServID'),event.getValue('siteid'))) />
		<cfelse>
			<cfset event.setValue('contentBean',application.contentManager.getActiveContentByFilename(event.getValue('currentFilename'),event.getValue('siteid'))) />
		</cfif>
	</cfif>
	
	<cfif event.getValue('contentBean').getIsNew() eq 1>
		<cfset event.setValue('contentBean',application.contentManager.getActiveContentByFilename("404",event.getValue('siteid'),true)) />
		<cfheader statuscode="404" statustext="Content Not Found" /> 
	</cfif>
	
	<cfif (application.configBean.getMode() eq 'production' and cgi.SERVER_NAME neq application.settingsManager.getSite(request.siteID).getDomain()) and not (cgi.SERVER_NAME eq 'LOCALHOST' and cgi.HTTP_USER_AGENT eq 'vspider')> 
		<cflocation addtoken="no" url="http://#application.settingsManager.getSite(request.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(request.siteid,request.contentBean.getFilename())#">
	</cfif>	
	
	<cfif event.getValue('trackSession') and (len(event.getValue('contentBean').getcontentID()) and not event.getValue('contentBean').getIsNew() eq 1 and not event.valueExists('previewID'))>
		<cfset application.sessionTrackingManager.trackRequest(event.getValue('siteID'),event.getValue('path'),event.getValue('keywords'),event.getValue('contentBean').getcontentID()) />
	</cfif>
	<!--- <cfif trim(application.sessionTrackingManager.trackRequest(request.siteid,cgi.SCRIPT_NAME,request.contentBean.getcontentID())) eq "killSession" or session.REMOTE_ADDR neq cgi.REMOTE_ADDR>
		<cflocation url="?doaction=logout">
	</cfif> --->

	<cfset event.setValue('crumbData',application.contentGateway.getCrumbList(event.getValue('contentBean').getcontentid(),event.getValue('siteid'),true,event.getValue('contentBean').getPath())) />
	<cfif event.getValue('doaction') neq ''><cfloop list="#event.getValue('doaction')#" index="a"><cfset doAction(a)></cfloop></cfif>

	<cfset event.setValue('forceSSL',event.getValue('contentBean').getForceSSL())/>
	
	<cfset event.setValue('r',application.permUtility.setRestriction(event.getValue('crumbData')))>
	
	<cfif event.valueExists('previewID')>
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
 
	<cfif event.getValue('isOnDisplay') and event.getValue('r').restrict and not event.getValue('r').loggedIn and (event.getValue('display') neq 'login' and event.getValue('display') neq 'editProfile')>
		<cflocation addtoken="no" url="#application.settingsManager.getSite(request.siteid).getLoginURL()#&returnURL=#URLEncodedFormat(application.contentRenderer.getCurrentURL())#">
	</cfif>

	<cfset request.rb=application.settingsManager.getSite(event.getValue('siteid')).getJavaLocale() />
	<cfset setLocale(request.rb) />
	
 	<cfreturn doResponse() />
	
	
</cffunction>

<cffunction name="doResponse" access="public" returntype="any" output="false">
	<cfset var renderer=""/>
	
	<cfif event.getValue('exportHtmlSite')>
			<cfset renderer = createObject("component","#application.configBean.getWebRootMap()#.#request.siteid#.includes.staticContentRenderer").init(event) />
		<cfelse>
			<cfset renderer = createObject("component","#application.configBean.getWebRootMap()#.#request.siteid#.includes.contentRenderer").init(event) />
	</cfif>
	
	<cfset event.setValue('contentRenderer',renderer) />
	
	<cfset application.pluginManager.executeScripts('onRenderStart',event.getValue('siteID'), event)/>
	
	<cfswitch expression="#event.getValue('contentBean').getType()#">
	<cfcase value="File,Link">
	
		<cfif event.getValue('isOnDisplay') and ((not event.getValue('r').restrict) or (event.getValue('r').restrict and event.getValue('r').allow))>			
			<cfif request.showMeta neq 1>
				<cfswitch expression="#event.getValue('contentBean').getType()#">
					<cfcase value="Link">
						<cfif not renderer.showItemMeta("Link") or event.getValue('showMeta') eq 2>
							<cflocation addtoken="no" url="#renderer.setDynamicContent(event.getValue('contentBean').getFilename())#">
						<cfelse>
							<cfreturn doHTML(renderer) />	
						</cfif>
					</cfcase>
					<cfcase value="File">
						<cfif not renderer.showItemMeta(event.getValue('contentBean').getFileExt()) or event.getValue('showMeta') eq 2>
							<cftry>
							<cfset renderer.renderFile(event.getValue('contentBean').getFileID()) />
							<cfreturn ""/>
							<cfcatch>
								<cfset event.setValue('contentBean',application.contentManager.getActiveContentByFilename("404",event.getValue('siteID'))) />
								<cfreturn doHTML(renderer) />
							</cfcatch>
						</cftry>
						<cfelse>
							<cfreturn doHTML(renderer) />
						</cfif>
					</cfcase>
				</cfswitch>
			<cfelse>
				<cfreturn doHTML(renderer) />
			</cfif>
		<cfelse>
			<cfreturn doHTML(renderer) />
		</cfif>
		
	</cfcase>
	
	<cfdefaultcase>
		<cfreturn doHTML(renderer) />
	</cfdefaultcase>
	
	</cfswitch> 
	
</cffunction>

<cffunction name="doHTML" returntype="string" access="public">
	<cfargument name="renderer">
		
		<cfset var page = "" />
		
		<cfsavecontent variable="page">
			<cfinclude template="/#application.configBean.getWebRootMap()#/#event.getValue('siteID')#/includes/templates/#arguments.renderer.getTemplate()#">
		</cfsavecontent>
		
		<cfif request.exportHtmlSite>
			<cfset page=replace(page,"#application.configBean.getContext()##renderer.getURLStem(event.getValue('siteID'),'')#","/#application.settingsManager.getSite(event.getValue('siteID')).getExportLocation()#/","ALL")> 
			<cfset page=replace(page,"/#event.getValue('siteID')#/","/#application.settingsManager.getSite(event.getValue('siteID')).getExportLocation()#/","ALL")> 
		</cfif>
		
		<cfif (event.getValue('forceSSL') or (event.getValue('r').restrict and application.settingsManager.getSite(event.getValue('siteID')).getExtranetSSL() eq 1)) and listFindNoCase('Off,False',cgi.https)>
			<cflocation addtoken="no" url="https://#application.settingsManager.getSite(event.getValue('siteID')).getDomain()##application.configBean.getServerPort()##arguments.renderer.getCurrentURL(false)#">
		</cfif>
	
		<cfif not (event.getValue('r').restrict or event.getValue('forceSSL')) and listFindNoCase('On,True',cgi.https)>
			<cflocation addtoken="no" url="http://#application.settingsManager.getSite(event.getValue('siteID')).getDomain()##application.configBean.getServerPort()##arguments.renderer.getCurrentURL(false)#">
		</cfif>
			
		<cfset arguments.renderer.renderHTMLHeadQueue() />
		<cfreturn page>
		
</cffunction>

</cfcomponent>
