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
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfcomponent output="false" extends="service" hint="Deprecated">

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
		<cfset user=application.userManager.read(userid=event.getValue("userID"),siteid=event.getValue("siteid"))>
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

	<cfset var address=super.getBean("userDAO").readAddress(event.getValue("addressID"))>
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
