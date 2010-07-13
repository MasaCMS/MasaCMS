<cfcomponent extends="controller" output="false">

<cffunction name="before" output="false">
	<cfargument name="rc">
	
	<cfif not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(arguments.rc.siteid).getPrivateUserPoolID()#;0') and not listFind(session.mura.memberships,'S2')>
		<cfset secure(arguments.rc)>
	</cfif>
	
	<cfparam name="arguments.rc.parentid" default="" />
	<cfparam name="arguments.rc.topid" default="" />
	<cfparam name="arguments.rc.contentid" default="" />
	<cfparam name="arguments.rc.body" default="" />
	<cfparam name="arguments.rc.Contentid" default="" />
	<cfparam name="arguments.rc.groupid" default="" />
	<cfparam name="arguments.rc.url" default="" />
	<cfparam name="arguments.rc.type" default="" />
	<cfparam name="arguments.rc.startrow" default="1" />
	<cfparam name="arguments.rc.siteid" default="" />
	<cfparam name="arguments.rc.topid" default="00000000000000000000000000000000001" />
</cffunction>

<cffunction name="update" output="false">
	<cfargument name="rc">
	<cfset variables.permUtility.update(arguments.rc)  />
	<cfset variables.fw.redirect(action="cArch.list",append="siteid,moduleid,startrow,topid",path="")>
</cffunction>

<cffunction name="updategroup" output="false">
	<cfargument name="rc">
	<cfset variables.permUtility.updateGroup(arguments.rc)  />
	<cfset variables.fw.redirect(action="cPrivateUsers.list",append="siteid",path="")>
</cffunction>

<cffunction name="main" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.rscontent=variables.permUtility.getcontent(arguments.rc) />
</cffunction>

<cffunction name="module" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.groups=variables.permUtility.getGrouplist(arguments.rc) />
	<cfset arguments.rc.rsContent=variables.permUtility.getModule(arguments.rc) />
</cffunction>

<cffunction name="updatemodule" output="false">
	<cfargument name="rc">
	<cfset variables.permUtility.updateModule(arguments.rc) />
	<cfif arguments.rc.moduleid eq '00000000000000000000000000000000004'>
		<cfset variables.fw.redirect(action="cPrivateUsers.list",append="siteid",path="")>
	</cfif>
	 <cfif arguments.rc.moduleid eq '00000000000000000000000000000000005'>
		 <cfset variables.fw.redirect(action="cEmail.list",append="siteid",path="")>
	</cfif>
	 <cfif arguments.rc.moduleid eq '00000000000000000000000000000000007'>
		 <cfset variables.fw.redirect(action="cForm.list",append="siteid",path="")>
	</cfif>
	 <cfif arguments.rc.moduleid eq '00000000000000000000000000000000008'>
		 <cfset variables.fw.redirect(action="cPublicUsers.list",append="siteid",path="")>
	</cfif>
	 <cfif arguments.rc.moduleid eq '00000000000000000000000000000000009'>
		 <cfset variables.fw.redirect(action="cMailingList.list",append="siteid",path="")>
	</cfif>
	  <cfif arguments.rc.moduleid eq '00000000000000000000000000000000000'>
		 <cfset arguments.rc.moduleid="00000000000000000000000000000000000">
		 <cfset arguments.rc.topid="00000000000000000000000000000000001">
		 <cfset variables.fw.redirect(action="cArch.list",append="siteid,topid,moduleid",path="")>
	</cfif>
	  <cfif arguments.rc.moduleid eq '00000000000000000000000000000000006'>
		 <cfset variables.fw.redirect(action="cAdvertising.listAdvertisers",append="siteid",path="")>
	</cfif>
	<cfif arguments.rc.moduleid eq '00000000000000000000000000000000010'>
	 	<cfset variables.fw.redirect(action="cCategory.list",append="siteid",path="")>
	</cfif>
	 <cfif arguments.rc.moduleid eq '00000000000000000000000000000000011'>
		<cfset variables.fw.redirect(action="cFeed.list",append="siteid",path="")>
	</cfif>
	
	 <cfset variables.fw.redirect(action="cPlugins.list",append="siteid",path="")>
</cffunction>

</cfcomponent>