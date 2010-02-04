<cfcomponent extends="controller" output="false">

<cffunction name="setEmailManager" output="false">
	<cfargument name="emailManager">
	<cfset variables.emailManager=arguments.emailManager>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">
	
	<cfif (not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') and not listFind(session.mura.memberships,'S2')) and not ( variables.permUtility.getModulePerm('00000000000000000000000000000000005',rc.siteid) and variables.permUtility.getModulePerm('00000000000000000000000000000000000',rc.siteid))>
		<cfset secure(rc)>
	</cfif>
	
	<cfset session.moduleID="00000000000000000000000000000000005">
	
	<cfparam name="rc.fuseaction" default="list" />
	<cfparam name="rc.subject" default="" />
	<cfparam name="rc.bodytext" default="" />
	<cfparam name="rc.bodyhtml" default="" />
	<cfparam name="rc.createddate" default="" />
	<cfparam name="rc.deliverydate" default="" />
	<cfparam name="rc.grouplist" default="" />
	<cfparam name="rc.groupid" default="" />
	<cfparam name="rc.emailid" default="" />
	<cfparam name="rc.status" default="2" />
	<cfparam name="rc.lastupdatebyid" default="" />
	<cfparam name="rc.lastupdateby" default="" />
	
	<cfparam name="session.emaillist.status" default="2" />
	<cfparam name="session.emaillist.groupid" default="" />
	<cfparam name="session.emaillist.subject" default="" />
	<cfparam name="session.emaillist.dontshow" default="1" />
	
</cffunction>

<cffunction name="list" output="false">
<cfargument name="rc">
	<cfset rc.rsList=variables.emailManager.getList(rc) />
	<cfset rc.rsPrivateGroups=variables.emailManager.getPrivateGroups(rc.siteid) />
	<cfset rc.rsPublicGroups=variables.emailManager.getPublicGroups(rc.siteid) />
	<cfset rc.rsMailingLists=variables.emailManager.getMailingLists(rc.siteid) />
</cffunction>

<cffunction name="edit" output="false">
<cfargument name="rc">
	<cfset rc.emailBean=variables.emailManager.read(rc.emailid) />
	<cfset rc.rsPrivateGroups=variables.emailManager.getPrivateGroups(rc.siteid) />
	<cfset rc.rsPublicGroups=variables.emailManager.getPublicGroups(rc.siteid) />
	<cfset rc.rsMailingLists=variables.emailManager.getMailingLists(rc.siteid) />
</cffunction>

<cffunction name="update" output="false">
<cfargument name="rc">
	<cfset variables.emailManager.update(rc) />
	<cfset variables.fw.redirect(action="cEmail.list",append="siteid",path="")>
</cffunction>

<cffunction name="showALLBounces" output="false">
<cfargument name="rc">
	<cfset rc.rsBounces=variables.emailManager.getBounces(rc.emailid) />
</cffunction>

<cffunction name="showReturns" output="false">
<cfargument name="rc">
	<cfset rc.rsReturns=variables.emailManager.getReturns(rc.emailid) />
	<cfset rc.rsReturnsByUser=variables.emailManager.getReturnsByUser(rc.emailid) />
</cffunction>

</cfcomponent>