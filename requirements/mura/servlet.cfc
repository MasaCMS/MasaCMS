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
				<cfset createObject("component","#application.configBean.getWebRootMap()#.#request.siteid#.includes.loginHandler").init().handleLogin(request)>
			</cfcase>
			
			<cfcase value="return">
				<cfset application.emailManager.track(request.emailid,request.email,'returnClick')>
			</cfcase>
			
			<cfcase value="logout">
				<cfset application.loginManager.logout()>
				<cflocation url="#application.contentRenderer.getCurrentURL()#">
			</cfcase>
			
			<cfcase value="updateprofile">
				<cfif getAuthUser() neq ''>
					<cfif isDefined('request.addressAction')>
						<cfif request.addressAction eq "create">
							<cfset application.userManager.createAddress(request)>
						<cfelseif request.addressAction eq "update">
							<cfset application.userManager.updateAddress(request)>
						<cfelseif request.addressAction eq "delete">
							<cfset application.userManager.deleteAddress(request.addressID)>
						</cfif>
						<!--- reset the form --->
						<cfset request.addressID = "">
						<cfset request.addressAction = "">
					<cfelse>
						<cfset request.userBean=application.userManager.update(request,iif(isdefined('request.groupid'),de('true'),de('false')),iif(isdefined('request.categoryid'),de('true'),de('false')),request.siteid) />
						<cfif structIsEmpty(request.userBean.getErrors())>
							<cfset application.loginManager.loginByUserID(request)>
						</cfif>
					</cfif>
				</cfif>
			</cfcase>
			
			<cfcase value="createprofile">
				<cfif application.settingsManager.getSite(request.siteid).getextranetpublicreg() eq 1>
					<cfset request.userBean=application.userManager.create(request) />		
					<cfif structIsEmpty(request.userBean.getErrors()) and not isDefined('request.passwordNoCache')>
						<cfset application.userManager.sendLoginByUser(request.userBean,request.siteid,application.contentRenderer.getCurrentURL(),true) />
					<cfelseif structIsEmpty(request.userBean.getErrors()) and isDefined('request.passwordNoCache') and request.userBean.getInactive() eq 0>	
						<cfset request.userID=request.userBean.getUserID() />
						<cfset application.loginManager.loginByUserID(request)>
					</cfif>
				</cfif>
			</cfcase>
			
			<cfcase value="contactsend">
				<cfparam name="request.company" default="">
				<cfset application.serviceFactory.getBean("mailer").send(request,'#request.sendto#','#iif(request.fname eq '' and request.lname eq '',de('#request.company#'),de('#request.fname# #request.lname#'))#','#request.subject#','#request.siteid#','#request.email#')>
			</cfcase>
			
			<cfcase value="subscribe">
				<cfset application.mailinglistManager.createMember(request)>
			</cfcase>
			
			<cfcase value="unsubscribe">
				<cfset application.mailinglistManager.deleteMember(request)>
			</cfcase>
			
			<cfcase value="masterSubscribe">
				<cfset application.mailinglistManager.masterSubscribe(request)/>
			</cfcase>
			
			<cfcase value="setReminder">
				<cfset application.contentManager.setReminder(request.contentBean.getcontentid(),request.siteid,request.email,request.contentBean.getdisplaystart(),request.interval) />
			</cfcase>
			
			<cfcase value="forwardEmail">
				<cfset request.to=request.to1/>
				<cfset request.to=listAppend(request.to,request.to2)/>
				<cfset request.to=listAppend(request.to,request.to3)/>
				<cfset request.to=listAppend(request.to,request.to4)/>
				<cfset request.to=listAppend(request.to,request.to5)/>
				<cfset application.emailManager.forward(request) />
			</cfcase>
			
		</cfswitch>



</cffunction> 

<cffunction name="doRequest" returntype="any"  access="public" output="false">
	<cfset var a=""/>
		
	<cfif structKeyExists(request,'previewid')>
		<cfset request.track=0>
		<cfset request.nocache=1>
		<cfset request.contentBean=application.contentManager.getcontentVersion(request.previewID,request.siteid) />
	<cfelse>
		<cfif request.trackSession>
			<cfset request.track=1>
		<cfelse>
			<cfset request.track=0>
		</cfif>
		<cfif len(request.linkServID)>
			<cfset request.contentBean=application.contentManager.getActiveContent(request.linkServID,request.siteid) />
		<cfelse>
			<cfset request.contentBean=application.contentManager.getActiveContentByFilename(request.currentFilename,request.siteid) />
		</cfif>
	</cfif>
	
	<cfif request.contentBean.getIsNew() eq 1>
		<cfset request.contentBean=application.contentManager.getActiveContentByFilename("404",request.siteid,true) />
		<cfheader statuscode="404" statustext="Content Not Found" /> 
	</cfif>
	
	<cfif (application.configBean.getMode() eq 'production' and cgi.SERVER_NAME neq application.settingsManager.getSite(request.siteID).getDomain()) and not (cgi.SERVER_NAME eq 'LOCALHOST' and cgi.HTTP_USER_AGENT eq 'vspider')> 
		<cflocation addtoken="no" url="http://#application.settingsManager.getSite(request.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(request.siteid,request.contentBean.getFilename())#">
	</cfif>	
	
	<cfif request.trackSession and (len(request.contentBean.getcontentID()) and not request.contentBean.getIsNew() eq 1 and not structKeyExists(request,'previewid'))>
		<cfset application.sessionTrackingManager.trackRequest(request.siteid,request.path,request.keywords,request.contentBean.getcontentID()) />
	</cfif>
	<!--- <cfif trim(application.sessionTrackingManager.trackRequest(request.siteid,cgi.SCRIPT_NAME,request.contentBean.getcontentID())) eq "killSession" or session.REMOTE_ADDR neq cgi.REMOTE_ADDR>
		<cflocation url="?doaction=logout">
	</cfif> --->

	<cfset request.crumbdata=application.contentGateway.getCrumbList(request.contentBean.getcontentid(),request.siteid,true) />
	<cfif request.doaction neq ''><cfloop list="#request.doaction#" index="a"><cfset doAction(a)></cfloop></cfif>

	<cfset request.forceSSL = request.contentBean.getForceSSL() />
	
	<cfset request.r=application.permUtility.setRestriction(request.crumbdata)>
	
	<cfif structKeyExists(request,'previewid')>
		<cfset request.isOnDisplay=1>
	<cfelseif request.contentBean.getapproved() eq 0>
		<cfset request.track=0>
		<cfset request.nocache=1>
		<cfset request.isOnDisplay=0>
	<cfelseif arrayLen(request.crumbdata) gt 1>
		<cfset request.isOnDisplay=application.contentUtility.isOnDisplay(request.contentBean.getdisplay(),request.contentBean.getdisplaystart(),request.contentBean.getdisplaystop(),request.siteid,request.contentBean.getparentid(),request.crumbdata[2].type)>
	<cfelse>
		<cfset request.isOnDisplay=1>
	</cfif>
 	
	<cfif request.isOnDisplay and request.r.restrict and not request.r.loggedIn and (request.display neq 'login' and request.display neq 'editProfile')>
		<cflocation addtoken="no" url="#application.settingsManager.getSite(request.siteid).getLoginURL()#&returnURL=#URLEncodedFormat(application.contentRenderer.getCurrentURL())#">
	</cfif>
	
 	<cfreturn doResponse() />
	
	
</cffunction>

<cffunction name="doResponse" access="public" returntype="any" output="false">
	<cfset var renderer=""/>
	
	<cfif request.exportHtmlSite>
			<cfset renderer = createObject("component","#application.configBean.getWebRootMap()#.#request.siteid#.includes.staticContentRenderer").init() />
		<cfelse>
			<cfset renderer = createObject("component","#application.configBean.getWebRootMap()#.#request.siteid#.includes.contentRenderer").init() />
	</cfif>
	
	<cfset request.contentRenderer=renderer />
	
	<cfset application.pluginManager.executeScripts('onRenderStart',request.siteID,request.servletEvent)/>
	
	<cfswitch expression="#request.contentBean.getType()#">
	<cfcase value="File,Link">
	
		<cfif request.isOnDisplay and ((not request.r.restrict) or (request.r.restrict and request.r.allow))>			
			<cfif request.showMeta neq 1>
				<cfswitch expression="#request.contentBean.getType()#">
					<cfcase value="Link">
						<cfif not renderer.showItemMeta("Link") or request.showMeta eq 2>
							<cflocation addtoken="no" url="#renderer.setDynamicContent(request.contentBean.getFilename())#">
						<cfelse>
							<cfreturn doHTML(renderer) />	
						</cfif>
					</cfcase>
					<cfcase value="File">
						<cfif not renderer.showItemMeta(request.contentBean.getFileExt()) or request.showMeta eq 2>
							<cftry>
							<cfset renderer.renderFile(request.contentBean.getFileID()) />
							<cfreturn ""/>
							<cfcatch>
								<cfset request.contentBean=application.contentManager.getActiveContentByFilename("404",request.siteid) />
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
			<cfinclude template="/#application.configBean.getWebRootMap()#/#request.siteid#/includes/templates/#arguments.renderer.getTemplate()#">
		</cfsavecontent>
		
		<cfif request.exportHtmlSite>
			<cfset page=replace(page,"#application.configBean.getContext()##renderer.getURLStem(request.siteid,'')#","/#application.settingsManager.getSite(request.siteid).getExportLocation()#/","ALL")> 
			<cfset page=replace(page,"/#request.siteid#/","/#application.settingsManager.getSite(request.siteid).getExportLocation()#/","ALL")> 
		</cfif>
		
		
		
			<cfif (request.forceSSL or (request.r.restrict and application.settingsManager.getSite(request.siteid).getExtranetSSL() eq 1)) and listFindNoCase('Off,False',cgi.https)>
				<cflocation addtoken="no" url="https://#application.settingsManager.getSite(request.siteid).getDomain()##application.configBean.getServerPort()##arguments.renderer.getCurrentURL(false)#">
			</cfif>
	
			<cfif not (request.r.restrict or request.forceSSL) and listFindNoCase('On,True',cgi.https)>
				<cflocation addtoken="no" url="http://#application.settingsManager.getSite(request.siteid).getDomain()##application.configBean.getServerPort()##arguments.renderer.getCurrentURL(false)#">
			</cfif>
			
		<cfset arguments.renderer.renderHTMLHeadQueue() />
		<cfreturn page>
		
</cffunction>

</cfcomponent>
