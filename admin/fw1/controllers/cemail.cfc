<cfcomponent extends="controller" output="false">

<cffunction name="setEmailManager" output="false">
	<cfargument name="emailManager">
	<cfset variables.emailManager=arguments.emailManager>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">
	
	<cfif (not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(arguments.rc.siteid).getPrivateUserPoolID()#;0') and not listFind(session.mura.memberships,'S2')) and not ( variables.permUtility.getModulePerm('00000000000000000000000000000000005',arguments.rc.siteid) and variables.permUtility.getModulePerm('00000000000000000000000000000000000',arguments.rc.siteid))>
		<cfset secure(arguments.rc)>
	</cfif>
	
	<cfset session.moduleID="00000000000000000000000000000000005">
	
	<cfparam name="arguments.rc.fuseaction" default="list" />
	<cfparam name="arguments.rc.subject" default="" />
	<cfparam name="arguments.rc.bodytext" default="" />
	<cfparam name="arguments.rc.bodyhtml" default="" />
	<cfparam name="arguments.rc.createddate" default="" />
	<cfparam name="arguments.rc.deliverydate" default="" />
	<cfparam name="arguments.rc.grouplist" default="" />
	<cfparam name="arguments.rc.groupid" default="" />
	<cfparam name="arguments.rc.emailid" default="" />
	<cfparam name="arguments.rc.status" default="2" />
	<cfparam name="arguments.rc.lastupdatebyid" default="" />
	<cfparam name="arguments.rc.lastupdateby" default="" />
	
	<cfparam name="session.emaillist.status" default="2" />
	<cfparam name="session.emaillist.groupid" default="" />
	<cfparam name="session.emaillist.subject" default="" />
	<cfparam name="session.emaillist.dontshow" default="1" />
	
</cffunction>

<cffunction name="list" output="false">
<cfargument name="rc">
	<cfset arguments.rc.rsList=variables.emailManager.getList(arguments.rc) />
	<cfset arguments.rc.rsPrivateGroups=variables.emailManager.getPrivateGroups(arguments.rc.siteid) />
	<cfset arguments.rc.rsPublicGroups=variables.emailManager.getPublicGroups(arguments.rc.siteid) />
	<cfset arguments.rc.rsMailingLists=variables.emailManager.getMailingLists(arguments.rc.siteid) />
</cffunction>

<cffunction name="edit" output="false">
<cfargument name="rc">
	<cfset arguments.rc.emailBean=variables.emailManager.read(arguments.rc.emailid) />
	<cfset arguments.rc.rsPrivateGroups=variables.emailManager.getPrivateGroups(arguments.rc.siteid) />
	<cfset arguments.rc.rsPublicGroups=variables.emailManager.getPublicGroups(arguments.rc.siteid) />
	<cfset arguments.rc.rsMailingLists=variables.emailManager.getMailingLists(arguments.rc.siteid) />
</cffunction>

<cffunction name="update" output="false">
<cfargument name="rc">
	<cfset variables.emailManager.update(arguments.rc) />
	<cfset variables.fw.redirect(action="cEmail.list",append="siteid",path="")>
</cffunction>

<cffunction name="showAllBounces" output="false">
<cfargument name="rc">
	<cfset arguments.rc.rsBounces=variables.emailManager.getAllBounces(arguments.rc) />
</cffunction>

<cffunction name="showBounces" output="false">
<cfargument name="rc">
	<cfset arguments.rc.rsBounces=variables.emailManager.getBounces(arguments.rc.emailid) />
</cffunction>

<cffunction name="showReturns" output="false">
<cfargument name="rc">
	<cfset arguments.rc.rsReturns=variables.emailManager.getReturns(arguments.rc.emailid) />
	<cfset arguments.rc.rsReturnsByUser=variables.emailManager.getReturnsByUser(arguments.rc.emailid) />
</cffunction>

<cffunction name="deleteBounces" output="false">
<cfargument name="rc">
	<cfset variables.emailManager.deleteBounces(arguments.rc)>
	<cflocation url="index.cfm?fuseaction=cEmail.showAllBounces&siteid=#arguments.rc.siteid#">
</cffunction>

</cfcomponent>