<cfcomponent extends="controller" output="false">

<cffunction name="setUserManager" output="false">
	<cfargument name="userManager">
	<cfset variables.userManager=arguments.userManager>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">

	<cfif (not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') and not listFind(session.mura.memberships,'S2')) and not ( variables.permUtility.getModulePerm('00000000000000000000000000000000008','#rc.siteid#') and variables.permUtility.getModulePerm('00000000000000000000000000000000000','#rc.siteid#'))>
		<cfset secure(rc)>
	</cfif>
	
	<cfparam name="rc.error" default="#structnew()#" />
	<cfparam name="rc.startrow" default="1" />
	<cfparam name="rc.userid" default="" />
	<cfparam name="rc.routeid" default="" />
	<cfparam name="rc.categoryid" default="" />
	<cfparam name="rc.Type" default="0" />
	<cfparam name="rc.ContactForm" default="0" />
	<cfparam name="rc.isPublic" default="1" />
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
	<cfparam name="rc.newsearch" default="false" />
	<cfparam name="rc.error" default="#structnew()#" />
	
	<cfif rc.userid eq ''>
		<cfparam name="rc.action" default="Add" />
	<cfelse>
	  	<cfparam name="rc.action" default="Update" />
	</cfif>

	
</cffunction>

<cffunction name="list" output="false">
	<cfargument name="rc">
	<cfset rc.rsgroups=variables.userManager.getUserGroups(rc.siteid,1) />
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
	
	<cfif rc.routeid eq ''>
		<cfset variables.fw.redirect(action="cPublicUsers.list",append="siteid",path="")>
	</cfif>
	<cfif rc.routeid eq 'adManager' and rc.action neq 'delete'>
		<cfset variables.fw.redirect(action="cAdvertising.viewAdvertiser",append="siteid,userid",path="")>
	</cfif>
	<cfif rc.routeid eq 'adManager' and rc.action eq 'delete'>
		<cfset variables.fw.redirect(action="cAdvertising.listAdvertisers",append="siteid,",path="")>
	</cfif>
	<cfif rc.routeid neq '' and rc.routeid neq 'adManager'>
		<cfset rc.userid=rc.routeid>
		<cfset variables.fw.redirect(action="cPublicUsers.editgroup",append="siteid,userid",path="")>
	</cfif>
	
	<cfset variables.fw.redirect(action="cPublicUsers.list",append="siteid",path="")>
		
</cffunction>

<cffunction name="search" output="false">
	<cfargument name="rc">
	
	<cfset rc.rslist=variables.userManager.getSearch(rc.search,rc.siteid,1) />
	<cfif rc.rslist.recordcount eq 1>
		<cfset rc.userID=rc.rslist.userid>
		<cfset variables.fw.redirect(action="cPublicUsers.editUser",append="siteid,userid",path="")>
	</cfif>
	<cfset rc.nextn=variables.utility.getNextN(rc.rsList,15,rc.startrow) />
</cffunction>

<cffunction name="advancedSearch" output="false">
	<cfargument name="rc">
	<cfset rc.rsGroups=variables.userManager.getPublicGroups(rc.siteid,1) />
</cffunction>

<cffunction name="advancedSearchToCSV" output="false">
	<cfargument name="rc">
	<cfset rc.rsGroups=variables.userManager.getPublicGroups(rc.siteid,1) />
</cffunction>

<cffunction name="editUser" output="false">
	<cfargument name="rc">
	<cfif not isdefined('rc.userBean')>
		<cfset rc.userBean=variables.userManager.read(rc.userid) />
	</cfif>
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
	  	<cfset variables.fw.redirect(action="cPublicUsers.editgroup",preserve="all",path="")>
	  <cfelseif rc.action neq  'delete' and not structIsEmpty(rc.userBean.getErrors()) and rc.type eq 2>
	    <cfset variables.fw.redirect(action="cPublicUsers.edituser",preserve="all",path="")>
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
	  
	  <cfset variables.fw.redirect(action="cPublicUsers.edituser",preserve="siteid,userid,routeid",path="")>
</cffunction>
	
</cfcomponent>