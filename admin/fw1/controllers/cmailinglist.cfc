<cfcomponent extends="controller" output="false">

<cffunction name="setMailingListManager" output="false">
	<cfargument name="mailingListManager">
	<cfset variables.mailingListManager=arguments.mailingListManager>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">
	
	<cfif (not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(arguments.rc.siteid).getPrivateUserPoolID()#;0') and not listFind(session.mura.memberships,'S2')) and not ( variables.permUtility.getModulePerm('00000000000000000000000000000000009','#rc.siteid#') and variables.permUtility.getModulePerm('00000000000000000000000000000000000','#rc.siteid#'))>
		<cfset secure(arguments.rc)>
	</cfif>
	<cfparam name="arguments.rc.startrow" default="1" />
</cffunction>

<cffunction name="list" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.rslist=variables.mailinglistManager.getList(arguments.rc.siteid) />
</cffunction>

<cffunction name="edit" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.listBean=variables.mailinglistManager.read(arguments.rc.mlid,arguments.rc.siteid) />
</cffunction>

<cffunction name="listmembers" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.listBean=variables.mailinglistManager.read(arguments.rc.mlid,arguments.rc.siteid) />
	<cfset arguments.rc.rslist=variables.mailinglistManager.getListMembers(arguments.rc.mlid,arguments.rc.siteid) />
	<cfset arguments.rc.nextn=variables.utility.getNextN(arguments.rc.rslist,30,arguments.rc.startrow) />
</cffunction>

<cffunction name="update" output="false">
	<cfargument name="rc">
	
	<cfif arguments.rc.action eq 'add'>
		<cfset arguments.rc.listBean=variables.mailinglistManager.create(arguments.rc) />
		<cfset arguments.rc.mlid= rc.listBean.getMLID() />
	</cfif>
			
	<cfif arguments.rc.action eq 'update'>
		<cfset variables.mailinglistManager.update(arguments.rc) />
	</cfif>
	
	<cfif arguments.rc.action eq 'delete'>
		<cfset variables.mailinglistManager.delete(arguments.rc.mlid,arguments.rc.siteid) />
	</cfif>
			
	<cfif arguments.rc.action eq 'delete'>
		<cfset variables.fw.redirect(action="cMailingList.list",append="siteid",path="")>
	<cfelse>
		<cfset variables.fw.redirect(action="cMailingList.listmembers",append="siteid,mlid",path="")>
	</cfif>
</cffunction>

<cffunction name="updatemember" output="false">
	<cfargument name="rc">
	
	<cfif arguments.rc.action eq 'add'>
		<cfset variables.mailinglistManager.createMember(arguments.rc) />
	</cfif>
		
	<cfif arguments.rc.action eq 'delete'>
		<cfset variables.mailinglistManager.deleteMember(arguments.rc) />
	</cfif>
	
	<cfset variables.fw.redirect(action="cMailingList.listmembers",append="siteid,mlid",path="")>
</cffunction>

<cffunction name="download" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.listBean=variables.mailinglistManager.read(arguments.rc.mlid,arguments.rc.siteid) />
	<cfset arguments.rc.rslist=variables.mailinglistManager.getListMembers(arguments.rc.mlid,arguments.rc.siteid) />
</cffunction>

</cfcomponent>