<cfcomponent output="false" extends="service">

<cffunction name="call">
	<cfargument name="Event">
	<cfif not (listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(event.getValue("siteID")).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2'))>
		<cfset event.setValue("__response__", format("access denied",event.getValue("responseFormat")))>
	<cfelse>
		<cfset proceed( event ) >
	</cfif>
	
</cffunction>

<cffunction name="getBean" output="false">
	<cfargument name="event">
	
	<cfset var user="">
	
	<cfif len(event.getValue("userID"))>
		<cfset user=application.userManager.read(event.getValue("userID"),event.getValue("siteid"))>
	<cfelseif len(event.getValue("groupname"))>
		<cfset user=application.userManager.readByGroupName(event.getValue("groupname"),event.getValue("siteid"))>
	<cfelseif len(event.getValue("username"))>
		<cfset user=application.userManager.readByUsername(event.getValue("username"),event.getValue("siteid"))>
	<cfelseif len(event.getValue("remoteID"))>
		<cfset user=application.userManager.readByRemoteID(event.getValue("remoteid"),event.getValue("siteid"))>
	<cfelseif len(event.getValue("email"))>
		<cfset user=application.userManager.readByEmail(event.getValue("email"),event.getValue("siteid"))>
	</cfif>
	
	<cfset event.setValue('user',user)>
	
	<cfreturn user>
	
</cffunction>

<cffunction name="getAddressBean" output="false">
	<cfargument name="event">
	
	<cfset var address=application.serviceFactory.getBean("userDAO").readAddress(event.getValue("addressID"))>
	<cfreturn address>
	
</cffunction>

<cffunction name="read" output="false">
	<cfargument name="event">
	<cfset var user=getBean(event)>
	
	<cfset event.setValue("__response__", removeObjects(user.getAllValues()))>
</cffunction>

<cffunction name="save" output="false">
	<cfargument name="event">
	<cfset var user=getBean(event)>
	
	<cfset user.set(event.getAllValues())>
	<cfset user.save()>
	<cfset event.setValue("__response__", removeObjects(user.getAllValues()))>

</cffunction>

<cffunction name="delete" output="false">
	<cfargument name="event">
	<cfset var user=getBean(event)>

	<cfset user.delete()>
	<cfset event.setValue("__response__", "true")>
</cffunction>

<cffunction name="saveAddress" output="false">
	<cfargument name="event">
	<cfset var address=getAddressBean(event)>
	
	<cfset address.set(event.getAllValues())>
	<cfset address.save()>
	<cfset event.setValue("__response__", removeObjects(address.getAllValues()))>

</cffunction>

<cffunction name="deleteAddress" output="false">
	<cfargument name="event">
	<cfset var address=getAddressBean(event)>

	<cfset address.delete()>
	<cfset event.setValue("__response__", "true")>
</cffunction>

<cffunction name="getMemberships" output="false">
	<cfargument name="event">
	<cfset var user=getBean(event)>
	
	<cfset event.setValue("__response__",user.getMembershipsQuery())>
	
</cffunction>

<cffunction name="getMembers" output="false">
	<cfargument name="event">
	<cfset var user=getBean(event)>
	
	<cfset event.setValue("__response__",user.getMembersQuery())>
	
</cffunction>

<cffunction name="getAddresses" output="false">
	<cfargument name="event">
	<cfset var user=getBean(event)>
	
	<cfset event.setValue("__response__", user.getAddressesQuery())>
	
</cffunction>

<cffunction name="getInterestGroups" output="false">
	<cfargument name="event">
	<cfset var user=getBean(event)>
	
	<cfset event.setValue("__response__", user.getInterestGroupsQuery())>
	
</cffunction>

<cffunction name="createUserInGroup" output="false">
	<cfargument name="event">
	
	<cfif isValid('UUID',event.getValue("userID")) and isValid('UUID',event.getValue("groupID")) >
		<cfset application.userManager.createUserInGroup(event.getValue("userID"),event.getValue("groupID"))>
		<cfset event.setValue("__response__", "true")>
	<cfelse>
		<cfset event.setValue("__response__", "false")>
	</cfif>
</cffunction>

<cffunction name="deleteUserFromGroup" output="false">
	<cfargument name="event">
	
	<cfif isValid('UUID',event.getValue("userID")) and isValid('UUID',event.getValue("groupID")) >
		<cfset application.userManager.deleteUserFromGroup(event.getValue("userID"),event.getValue("groupID"))>
		<cfset event.setValue("__response__", "true")>
	<cfelse>
		<cfset event.setValue("__response__", "false")>
	</cfif>
</cffunction>

</cfcomponent>