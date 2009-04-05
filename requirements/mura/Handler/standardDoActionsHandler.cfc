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
						<cfset event.setValue('userBean',application.userManager.update(request,iif(event.valueExists('groupID'),de('true'),de('false')),true,event.getValue('siteID'))) />
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


</cfcomponent>