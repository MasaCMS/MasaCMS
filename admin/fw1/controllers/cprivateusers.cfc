<cfcomponent extends="controller" output="false">

<cffunction name="setUserManager" output="false">
	<cfargument name="userManager">
	<cfset variables.userManager=arguments.userManager>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">
	
	<cfif not (listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') or  listFind(session.mura.memberships,'S2'))
	and not (listFindNoCase('cPrivateUsers.editAddress,cPrivateUsers.updateAddress',rc.fuseaction) and  rc.userID eq session.mura.userID)>
		<cfset secure(rc)>
	</cfif>
	
	<cfparam name="rc.error" default="#structnew()#" />
	<cfparam name="rc.startrow" default="1" />
	<cfparam name="rc.userid" default="" />
	<cfparam name="rc.routeid" default="" />
	<cfparam name="rc.categoryid" default="" />
	<cfparam name="rc.Type" default="0" />
	<cfparam name="rc.ContactForm" default="0" />
	<cfparam name="rc.isPublic" default="0" />
	<cfparam name="rc.email" default="" />
	<cfparam name="rc.jobtitle" default="" />
	<cfparam name="rc.lastupdate" default="" />
	<cfparam name="rc.lastupdateby" default="" />
	<cfparam name="rc.lastupdatebyid" default="0" />
	<cfparam name="rc.rsGrouplist.recordcount" default="0" />
	<cfparam name="rc.groupname" default="" />
	<cfparam name="rc.fname" default="" />
	<cfparam name="rc.lname" default="" />
	<cfparam name="rc.address" default="" />
	<cfparam name="rc.city" default="" />
	<cfparam name="rc.state" default="" />
	<cfparam name="rc.zip" default="" />
	<cfparam name="rc.phone1" default="" />
	<cfparam name="rc.phone2" default="" />
	<cfparam name="rc.fax" default="" />
	<cfparam name="rc.perm" default="0" />
	<cfparam name="rc.groupid" default="" />
	<cfparam name="rc.routeid" default="" />
	<cfparam name="rc.s2" default="0" />
	<cfparam name="rc.InActive" default="0" />
	<cfparam name="rc.startrow" default="1" />
	<cfparam name="rc.error" default="#structnew()#" />
	
	<cfif rc.userid eq ''>
		<cfparam name="rc.action" default="Add" />
	<cfelse>
	  	<cfparam name="rc.action" default="Update" />
	</cfif>

	
</cffunction>

<cffunction name="list" output="false">
	<cfargument name="rc">
	<cfset rc.rsgroups=variables.userManager.getUserGroups(rc.siteid,0) />
</cffunction>

<cffunction name="editGroup" output="false">
	<cfargument name="rc">
	
	<cfif not isdefined('rc.userBean')>
		<cfset rc.userBean=variables.userManager.read(rc.userid) />
	</cfif>
	<cfset rc.rsSiteList=variables.settingsManager.getList() />
	<cfset rc.rsGroupList=variables.userManager.readGroupMemberships(rc.userid) />
	<cfset rc.nextn=variables.utility.getNextN(rc.rsGroupList,15,rc.startrow) />
</cffunction>

<cffunction name="addtogroup" output="false">
	<cfargument name="rc">
	<cfset variables.userManager.createUserInGroup(rc.userid,rc.groupid) />
	<cfset route(rc)>
</cffunction>

<cffunction name="removefromgroup" output="false">
	<cfargument name="rc">
	<cfset variables.userManager.deleteUserFromGroup(rc.userid,rc.groupid) />
	<cfset route(rc)>
</cffunction>

<cffunction name="route" output="false">
	<cfargument name="rc">
	
	<cfif rc.routeid eq '' or rc.routeid eq 'adManager'>
		<cfset variables.fw.redirect(action="cPrivateUsers.list",append="siteid",path="")>
	</cfif>
	<cfset rc.routeBean=variables.userManager.read(rc.routeid) />
	
	<cfset rc.userid=rc.routeid>
	
	<cfif routeBean.getIsPublic() neq 0>
		<cfset rc.siteID=rc.routeBean.getSiteid()>
	</cfif>
	
	<cfset variables.fw.redirect(action="cPrivateUsers.editgroup",append="siteid,userid",path="")>
</cffunction>

<cffunction name="search" output="false">
	<cfargument name="rc">
	
	<cfset rc.rslist=variables.userManager.getSearch(rc.search,rc.siteid,0) />
	<cfif rc.rslist.recordcount eq 1>
		<cfset rc.userID=rc.rslist.userid>
		<cfset variables.fw.redirect(action="cPrivateUsers.editUser",append="siteid,userid",path="")>
	</cfif>
	<cfset rc.nextn=variables.utility.getNextN(rc.rsList,15,rc.startrow) />
</cffunction>

<cffunction name="editUser" output="false">
	<cfargument name="rc">
	<cfif not isdefined('rc.userBean')>
		<cfset rc.userBean=variables.userManager.read(rc.userid) />
	</cfif>
	<cfset rc.rsPrivateGroups=variables.userManager.getPrivateGroups(rc.siteid)  />
	<cfset rc.rsPublicGroups=variables.userManager.getPublicGroups(rc.siteid) />
</cffunction>

<cffunction name="editAddress" output="false">
	<cfargument name="rc">
	<cfif not isdefined('rc.userBean')>
		<cfset rc.userBean=variables.userManager.read(rc.userid) />
	</cfif>
</cffunction>

<cffunction name="update" output="false">
	<cfargument name="rc">
	
	  <cfif rc.action eq 'Update'>
	  	<cfset rc.userBean=variables.userManager.update(rc) />
	  </cfif>
  
	  <cfif rc.action eq 'Delete'>
	  	<cfset variables.userManager.delete(rc.userid,rc.type) />
	  </cfif>
  
	  <cfif rc.action eq 'Add'>
	  	<cfset rc.userBean=variables.userManager.create(rc)/> 
	  </cfif>
	  
	   <cfif rc.action eq 'Add' and structIsEmpty(rc.userBean.getErrors())>
	   	<cfset rc.userid=rc.userBean.getUserID() />
	   </cfif>
	   
	  <cfif (rc.action neq 'delete' and structIsEmpty(rc.userBean.getErrors())) or rc.action eq 'delete'>
	    <cfset route(rc)>
	  </cfif>
	 
	  <cfif rc.action neq 'delete' and  not structIsEmpty(rc.userBean.getErrors()) and rc.type eq 1>
	  	<cfset variables.fw.redirect(action="cPrivateUsers.editgroup",preserve="all",path="")>
	  <cfelseif rc.action neq  'delete' and not structIsEmpty(rc.userBean.getErrors()) and rc.type eq 2>
	    <cfset variables.fw.redirect(action="cPrivateUsers.edituser",preserve="all",path="")>
	  </cfif>
</cffunction>

<cffunction name="updateAddress" output="false">
	<cfargument name="rc">
	  <cfif rc.action eq 'Update'>
	  	<cfset variables.userManager.updateAddress(rc) />
	  </cfif>
  
	  <cfif rc.action eq 'Delete'>
	  	<cfset variables.userManager.deleteAddress(rc.addressid) />
	  </cfif>
  
	  <cfif rc.action eq 'Add'>
	  	<cfset variables.userManager.createAddress(rc) /> 
	  </cfif>
	  
	  <cflocation url="index.cfm?#rc.returnURL#" addtoken="false"/>
</cffunction>
	
</cfcomponent>