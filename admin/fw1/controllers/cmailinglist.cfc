<cfcomponent extends="controller" output="false">

<cffunction name="setMailingListManager" output="false">
	<cfargument name="mailingListManager">
	<cfset variables.mailingListManager=arguments.mailingListManager>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">
	
	<cfif (not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') and not listFind(session.mura.memberships,'S2')) and not ( variables.permUtility.getModulePerm('00000000000000000000000000000000009','#rc.siteid#') and variables.permUtility.getModulePerm('00000000000000000000000000000000000','#rc.siteid#'))>
		<cfset secure(rc)>
	</cfif>
	<cfparam name="rc.startrow" default="1" />
</cffunction>

<cffunction name="list" output="false">
	<cfargument name="rc">
	<cfset rc.rslist=variables.mailinglistManager.getList(rc.siteid) />
</cffunction>

<cffunction name="edit" output="false">
	<cfargument name="rc">
	<cfset rc.listBean=variables.mailinglistManager.read(rc.mlid,rc.siteid) />
</cffunction>

<cffunction name="listmembers" output="false">
	<cfargument name="rc">
	<cfset rc.listBean=variables.mailinglistManager.read(rc.mlid,rc.siteid) />
	<cfset rc.rslist=variables.mailinglistManager.getListMembers(rc.mlid,rc.siteid) />
	<cfset rc.nextn=variables.utility.getNextN(rc.rslist,30,rc.startrow) />
</cffunction>

<cffunction name="update" output="false">
	<cfargument name="rc">
	
	<cfif rc.action eq 'add'>
		<cfset rc.listBean=variables.mailinglistManager.create(rc) />
		<cfset rc.mlid= rc.listBean.getMLID() />
	</cfif>
			
	<cfif rc.action eq 'update'>
		<cfset variables.mailinglistManager.update(rc) />
	</cfif>
	
	<cfif rc.action eq 'delete'>
		<cfset variables.mailinglistManager.delete(rc.mlid,rc.siteid) />
	</cfif>
			
	<cfif rc.action eq 'delete'>
		<cfset variables.fw.redirect(action="cMailingList.list",append="siteid",path="")>
	<cfelse>
		<cfset variables.fw.redirect(action="cMailingList.listmembers",append="siteid,mlid",path="")>
	</cfif>
</cffunction>

<cffunction name="updatemember" output="false">
	<cfargument name="rc">
	
	<cfif rc.action eq 'add'>
		<cfset variables.mailinglistManager.createMember(rc) />
	</cfif>
		
	<cfif rc.action eq 'delete'>
		<cfset variables.mailinglistManager.deleteMember(rc) />
	</cfif>
	
	<cfset variables.fw.redirect(action="cMailingList.listmembers",append="siteid,mlid",path="")>
</cffunction>

<cffunction name="download" output="false">
	<cfargument name="rc">
	<cfset rc.listBean=variables.mailinglistManager.read(rc.mlid,rc.siteid) />
	<cfset rc.rslist=variables.mailinglistManager.getListMembers(rc.mlid,rc.siteid) />
</cffunction>

</cfcomponent>