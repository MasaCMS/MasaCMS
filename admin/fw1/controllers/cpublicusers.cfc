<cfcomponent extends="controller" output="false">

<cffunction name="setUserManager" output="false">
	<cfargument name="userManager">
	<cfset variables.userManager=arguments.userManager>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">

	<cfif (not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(arguments.rc.siteid).getPrivateUserPoolID()#;0') and not listFind(session.mura.memberships,'S2')) and not ( variables.permUtility.getModulePerm('00000000000000000000000000000000008','#rc.siteid#') and variables.permUtility.getModulePerm('00000000000000000000000000000000000','#rc.siteid#'))>
		<cfset secure(arguments.rc)>
	</cfif>
	
	<cfparam name="arguments.rc.error" default="#structnew()#" />
	<cfparam name="arguments.rc.startrow" default="1" />
	<cfparam name="arguments.rc.userid" default="" />
	<cfparam name="arguments.rc.routeid" default="" />
	<cfparam name="arguments.rc.categoryid" default="" />
	<cfparam name="arguments.rc.Type" default="0" />
	<cfparam name="arguments.rc.ContactForm" default="0" />
	<cfparam name="arguments.rc.isPublic" default="1" />
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
	<cfparam name="arguments.rc.search" default="" />
	<cfparam name="arguments.rc.newsearch" default="false" />
	<cfparam name="arguments.rc.error" default="#structnew()#" />
	
	<cfif arguments.rc.userid eq ''>
		<cfparam name="arguments.rc.action" default="Add" />
	<cfelse>
	  	<cfparam name="arguments.rc.action" default="Update" />
	</cfif>

	
</cffunction>

<cffunction name="list" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.rsgroups=variables.userManager.getUserGroups(arguments.rc.siteid,1) />
</cffunction>

<cffunction name="editGroup" output="false">
	<cfargument name="rc">
	
	<cfif not isdefined('rc.userBean')>
		<cfset arguments.rc.userBean=variables.userManager.read(arguments.rc.userid) />
	</cfif>
	<cfset arguments.rc.rsSiteList=variables.settingsManager.getList() />
	<cfset arguments.rc.rsGroupList=variables.userManager.readGroupMemberships(arguments.rc.userid) />
	<cfset arguments.rc.nextn=variables.utility.getNextN(arguments.rc.rsGroupList,15,arguments.rc.startrow) />
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
	
	<cfif arguments.rc.routeid eq ''>
		<cfset variables.fw.redirect(action="cPublicUsers.list",append="siteid",path="")>
	</cfif>
	<cfif arguments.rc.routeid eq 'adManager' and arguments.rc.action neq 'delete'>
		<cfset variables.fw.redirect(action="cAdvertising.viewAdvertiser",append="siteid,userid",path="")>
	</cfif>
	<cfif arguments.rc.routeid eq 'adManager' and arguments.rc.action eq 'delete'>
		<cfset variables.fw.redirect(action="cAdvertising.listAdvertisers",append="siteid,",path="")>
	</cfif>
	<cfif arguments.rc.routeid neq '' and arguments.rc.routeid neq 'adManager'>
		<cfset arguments.rc.userid=rc.routeid>
		<cfset variables.fw.redirect(action="cPublicUsers.editgroup",append="siteid,userid",path="")>
	</cfif>
	
	<cfset variables.fw.redirect(action="cPublicUsers.list",append="siteid",path="")>
		
</cffunction>

<cffunction name="search" output="false">
	<cfargument name="rc">
	
	<cfset arguments.rc.rslist=variables.userManager.getSearch(arguments.rc.search,arguments.rc.siteid,1) />
	<cfif arguments.rc.rslist.recordcount eq 1>
		<cfset arguments.rc.userID=rc.rslist.userid>
		<cfset variables.fw.redirect(action="cPublicUsers.editUser",append="siteid,userid",path="")>
	</cfif>
	<cfset arguments.rc.nextn=variables.utility.getNextN(arguments.rc.rsList,15,arguments.rc.startrow) />
</cffunction>

<cffunction name="advancedSearch" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.rsGroups=variables.userManager.getPublicGroups(arguments.rc.siteid,1) />
</cffunction>

<cffunction name="advancedSearchToCSV" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.rsGroups=variables.userManager.getPublicGroups(arguments.rc.siteid,1) />
</cffunction>

<cffunction name="editUser" output="false">
	<cfargument name="rc">
	<cfif not isdefined('arguments.rc.userBean')>
		<cfset arguments.rc.userBean=variables.userManager.read(arguments.rc.userid) />
	</cfif>
	<cfset arguments.rc.rsPublicGroups=variables.userManager.getPublicGroups(arguments.rc.siteid) />
</cffunction>

<cffunction name="editAddress" output="false">
	<cfargument name="rc">
	<cfif not isdefined('arguments.rc.userBean')>
		<cfset arguments.rc.userBean=variables.userManager.read(arguments.rc.userid) />
	</cfif>
</cffunction>

<cffunction name="update" output="false">
	<cfargument name="rc">
	
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
	   
	  <cfif (arguments.rc.action neq 'delete' and structIsEmpty(arguments.rc.userBean.getErrors())) or arguments.rc.action eq 'delete'>
	    <cfset route(arguments.rc)>
	  </cfif>
	 
	  <cfif arguments.rc.action neq 'delete' and  not structIsEmpty(arguments.rc.userBean.getErrors()) and arguments.rc.type eq 1>
	  	<cfset variables.fw.redirect(action="cPublicUsers.editgroup",preserve="all",path="")>
	  <cfelseif arguments.rc.action neq  'delete' and not structIsEmpty(arguments.rc.userBean.getErrors()) and arguments.rc.type eq 2>
	    <cfset variables.fw.redirect(action="cPublicUsers.edituser",preserve="all",path="")>
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
	  
	  <cfset variables.fw.redirect(action="cPublicUsers.edituser",preserve="siteid,userid,routeid",path="")>
</cffunction>
	
</cfcomponent>