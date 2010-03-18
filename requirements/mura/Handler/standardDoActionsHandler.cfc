<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.
	
	As a special exception to the terms and conditions of version 2.0 of
	the GPL, you may redistribute this Program as described in Mura CMS'
	Plugin exception. You should have recieved a copy of the text describing
	this exception, and it is also available here:
	'http://www.getmura.com/exceptions.txt"

	 --->
<cfcomponent extends="Handler" output="false">
	
<cffunction name="handle" output="false" returnType="any">
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
				<cfset createObject("component","#application.configBean.getWebRootMap()#.#event.getValue('siteid')#.includes.loginHandler").init().handleLogin(event.getAllValues())>
			</cfcase>
			
			<cfcase value="return">
				<cfset application.emailManager.track(event.getValue('emailID'),event.getValue('email'),'returnClick')>
			</cfcase>
			
			<cfcase value="logout">
				<cfset application.loginManager.logout()>
				<cfset event.getValue('HandlerFactory').get("standardPostLogout").handle(event)>
			</cfcase>
			
			<cfcase value="updateprofile">
				<cfif session.mura.isLoggedIn>
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
				<cfset application.serviceFactory.getBean("mailer").send(event.getAllValues(),event.getValue('sendTo'),'#iif(event.getValue('fname') eq '' and event.getValue('lname') eq '',de('#event.getValue('company')#'),de('#event.getValue('fname')# #event.getValue('lname')#'))#',event.getValue('subject'),event.getValue('siteID'),event.getValue('email'))>
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

</cfcomponent>