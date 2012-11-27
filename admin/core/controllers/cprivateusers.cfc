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
<cfcomponent extends="controller" output="false">

<cffunction name="setUserManager" output="false">
	<cfargument name="userManager">
	<cfset variables.userManager=arguments.userManager>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">
	
	<cfif not (listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(arguments.rc.siteid).getPrivateUserPoolID()#;0') or  listFind(session.mura.memberships,'S2'))
	and not (listFindNoCase('cPrivateUsers.editAddress,cPrivateUsers.updateAddress',listLast(arguments.rc.muraAction,":")) and  rc.userID eq session.mura.userID)>
		<cfset secure(arguments.rc)>
	</cfif>
	
	<cfparam name="arguments.rc.error" default="#structnew()#" />
	<cfparam name="arguments.rc.startrow" default="1" />
	<cfparam name="arguments.rc.userid" default="" />
	<cfparam name="arguments.rc.routeid" default="" />
	<cfparam name="arguments.rc.categoryid" default="" />
	<cfparam name="arguments.rc.Type" default="0" />
	<cfparam name="arguments.rc.ContactForm" default="0" />
	<cfparam name="arguments.rc.isPublic" default="0" />
	<cfparam name="arguments.rc.email" default="" />
	<cfparam name="arguments.rc.jobtitle" default="" />
	<cfparam name="arguments.rc.lastupdate" default="" />
	<cfparam name="arguments.rc.lastupdateby" default="" />
	<cfparam name="arguments.rc.lastupdatebyid" default="0" />
	<cfparam name="arguments.rc.rsGrouplist.recordcount" default="0" />
	<cfparam name="arguments.rc.groupname" default="" />
	<cfparam name="arguments.rc.fname" default="" />
	<cfparam name="arguments.rc.lname" default="" />
	<cfparam name="arguments.rc.address" default="" />
	<cfparam name="arguments.rc.city" default="" />
	<cfparam name="arguments.rc.state" default="" />
	<cfparam name="arguments.rc.zip" default="" />
	<cfparam name="arguments.rc.phone1" default="" />
	<cfparam name="arguments.rc.phone2" default="" />
	<cfparam name="arguments.rc.fax" default="" />
	<cfparam name="arguments.rc.perm" default="0" />
	<cfparam name="arguments.rc.groupid" default="" />
	<cfparam name="arguments.rc.routeid" default="" />
	<cfparam name="arguments.rc.s2" default="0" />
	<cfparam name="arguments.rc.InActive" default="0" />
	<cfparam name="arguments.rc.startrow" default="1" />
	<cfparam name="arguments.rc.error" default="#structnew()#" />
	<cfparam name="arguments.rc.returnurl" default="" />
	<cfparam name="arguments.rc.search" default="" />
	
	
	<cfif arguments.rc.userid eq ''>
		<cfparam name="arguments.rc.action" default="Add" />
	<cfelse>
	  	<cfparam name="arguments.rc.action" default="Update" />
	</cfif>

	
</cffunction>

<cffunction name="list" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.rsgroups=variables.userManager.getUserGroups(arguments.rc.siteid,0) />
</cffunction>

<cffunction name="editGroup" output="false">
	<cfargument name="rc">
	
	<cfif not isdefined('arguments.rc.userBean')>
		<cfset arguments.rc.userBean=variables.userManager.read(arguments.rc.userid) />
	</cfif>
	<cfset arguments.rc.rsSiteList=variables.settingsManager.getList() />
	<cfset arguments.rc.rsGroupList=variables.userManager.readGroupMemberships(arguments.rc.userid) />
	<cfset arguments.rc.nextn=variables.utility.getNextN(arguments.rc.rsGroupList,15,arguments.rc.startrow) />
	
	<!--- This is here for backward plugin compatibility--->
	<cfset appendRequestScope(arguments.rc)>

</cffunction>

<cffunction name="addtogroup" output="false">
	<cfargument name="rc">
	<cfset variables.userManager.createUserInGroup(arguments.rc.userid,arguments.rc.groupid) />
	<cfset route(arguments.rc)>
</cffunction>

<cffunction name="removefromgroup" output="false">
	<cfargument name="rc">
	<cfset variables.userManager.deleteUserFromGroup(arguments.rc.userid,arguments.rc.groupid) />
	<cfset route(arguments.rc)>
</cffunction>

<cffunction name="route" output="false">
	<cfargument name="rc">
	
	<cfset structDelete(session.mura,"editBean")>

	<cfif not len(arguments.rc.routeid) or arguments.rc.routeid eq 'adManager'>
		<cfif len(arguments.rc.returnurl)>	
			<cflocation url="#arguments.rc.returnurl#" addtoken="false">
		<cfelse>
			<cfset variables.fw.redirect(action="cPrivateUsers.list",append="siteid")>
		</cfif>
	</cfif>
	<cfset arguments.rc.routeBean=variables.userManager.read(arguments.rc.routeid) />
	
	<cfset arguments.rc.userid=rc.routeid>
	
	<cfif arguments.rc.routeBean.getIsPublic() neq 0>
		<cfset arguments.rc.siteID=rc.routeBean.getSiteid()>
	</cfif>
	
	<cfset variables.fw.redirect(action="cPrivateUsers.editgroup",append="siteid,userid")>
</cffunction>

<cffunction name="search" output="false">
	<cfargument name="rc">
	
	<cfset arguments.rc.rslist=variables.userManager.getSearch(arguments.rc.search,arguments.rc.siteid,0) />
	<cfif arguments.rc.rslist.recordcount eq 1>
		<cfset arguments.rc.userID=rc.rslist.userid>
		<cfset variables.fw.redirect(action="cPrivateUsers.editUser",append="siteid,userid")>
	</cfif>
	<cfset arguments.rc.nextn=variables.utility.getNextN(arguments.rc.rsList,15,arguments.rc.startrow) />
</cffunction>

<cffunction name="editUser" output="false">
	<cfargument name="rc">
	<cfif not isdefined('arguments.rc.userBean')>
		<cfset arguments.rc.userBean=variables.userManager.read(arguments.rc.userid) />
	</cfif>
	<cfset arguments.rc.rsPrivateGroups=variables.userManager.getPrivateGroups(arguments.rc.siteid)  />
	<cfset arguments.rc.rsPublicGroups=variables.userManager.getPublicGroups(arguments.rc.siteid) />

	<!--- This is here for backward plugin compatibility--->
	<cfset appendRequestScope(arguments.rc)>

</cffunction>

<cffunction name="editAddress" output="false">
	<cfargument name="rc">
	<cfif not isdefined('rc.userBean')>
		<cfset arguments.rc.userBean=variables.userManager.read(arguments.rc.userid) />
	</cfif>
</cffunction>

<cffunction name="update" output="false">
	<cfargument name="rc">
	
	  <cfset var origSiteID=arguments.rc.siteID>	
	
	  <cfset request.newImageIDList="">

	  <cfif arguments.rc.action eq 'Update'>
	  	<cfset arguments.rc.userBean=variables.userManager.update(arguments.rc) />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Delete'>
	  	<cfset variables.userManager.delete(arguments.rc.userid,arguments.rc.type) />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Add'>
	  	<cfset arguments.rc.userBean=variables.userManager.create(arguments.rc)/> 
	  </cfif>
	  
	   <cfif arguments.rc.action eq 'Add' and structIsEmpty(arguments.rc.userBean.getErrors())>
	   	<cfset arguments.rc.userid=rc.userBean.getUserID() />
	   </cfif>
	   
	   <cfset arguments.rc.siteID=origSiteID>
	   
	   <cfif len(request.newImageIDList)>
			<cfset rc.fileid=request.newImageIDList>
			<cfset rc.userid=arguments.rc.userBean.getUserID()>
			<cfset variables.fw.redirect(action="cArch.imagedetails",append="userid,siteid,fileid,compactDisplay")>
		</cfif>
		
	  <cfif (arguments.rc.action neq 'delete' and structIsEmpty(arguments.rc.userBean.getErrors())) or arguments.rc.action eq 'delete'>
	    <cfset route(arguments.rc)>
	  </cfif>
	 
	  <cfif arguments.rc.action neq 'delete' and  not structIsEmpty(arguments.rc.userBean.getErrors()) and arguments.rc.type eq 1>
	  	<cfset variables.fw.redirect(action="cPrivateUsers.editgroup",preserve="all")>
	  <cfelseif arguments.rc.action neq  'delete' and not structIsEmpty(arguments.rc.userBean.getErrors()) and arguments.rc.type eq 2>
	  	<cfset session.mura.editBean=arguments.rc.userBean>
	    <cfset variables.fw.redirect(action="cPrivateUsers.edituser",preserve="all")>
	  </cfif>
</cffunction>

<cffunction name="updateAddress" output="false">
	<cfargument name="rc">
	  <cfif arguments.rc.action eq 'Update'>
	  	<cfset variables.userManager.updateAddress(arguments.rc) />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Delete'>
	  	<cfset variables.userManager.deleteAddress(arguments.rc.addressid) />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Add'>
	  	<cfset variables.userManager.createAddress(arguments.rc) /> 
	  </cfif>
	  
	  <cflocation url="index.cfm?#rc.returnURL#" addtoken="false"/>
</cffunction>
	
</cfcomponent>