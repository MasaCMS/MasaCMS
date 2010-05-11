<cfcomponent extends="controller" output="false">

<cffunction name="before" output="false">
	<cfargument name="rc">
	
	<cfif not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') and not listFind(session.mura.memberships,'S2')>
		<cfset secure(rc)>
	</cfif>
	
	<cfparam name="rc.parentid" default="" />
	<cfparam name="rc.topid" default="" />
	<cfparam name="rc.contentid" default="" />
	<cfparam name="rc.body" default="" />
	<cfparam name="rc.Contentid" default="" />
	<cfparam name="rc.groupid" default="" />
	<cfparam name="rc.url" default="" />
	<cfparam name="rc.type" default="" />
	<cfparam name="rc.startrow" default="1" />
	<cfparam name="rc.siteid" default="" />
	<cfparam name="rc.topid" default="00000000000000000000000000000000001" />
</cffunction>

<cffunction name="update" output="false">
	<cfargument name="rc">
	<cfset variables.permUtility.update(rc)  />
	<cfset variables.fw.redirect(action="cArch.list",append="siteid,moduleid,startrow,topid",path="")>
</cffunction>

<cffunction name="updategroup" output="false">
	<cfargument name="rc">
	<cfset variables.permUtility.updateGroup(rc)  />
	<cfset variables.fw.redirect(action="cPrivateUsers.list",append="siteid",path="")>
</cffunction>

<cffunction name="main" output="false">
	<cfargument name="rc">
	<cfset rc.rscontent=variables.permUtility.getcontent(rc) />
</cffunction>

<cffunction name="module" output="false">
	<cfargument name="rc">
	<cfset rc.groups=variables.permUtility.getGrouplist(rc) />
	<cfset rc.rsContent=variables.permUtility.getModule(rc) />
</cffunction>

<cffunction name="updatemodule" output="false">
	<cfargument name="rc">
	<cfset variables.permUtility.updateModule(rc) />
	<cfif rc.moduleid eq '00000000000000000000000000000000004'>
		<cfset variables.fw.redirect(action="cPrivateUsers.list",append="siteid",path="")>
	</cfif>
	 <cfif rc.moduleid eq '00000000000000000000000000000000005'>
		 <cfset variables.fw.redirect(action="cEmail.list",append="siteid",path="")>
	</cfif>
	 <cfif rc.moduleid eq '00000000000000000000000000000000007'>
		 <cfset variables.fw.redirect(action="cForm.list",append="siteid",path="")>
	</cfif>
	 <cfif rc.moduleid eq '00000000000000000000000000000000008'>
		 <cfset variables.fw.redirect(action="cPublicUsers.list",append="siteid",path="")>
	</cfif>
	 <cfif rc.moduleid eq '00000000000000000000000000000000009'>
		 <cfset variables.fw.redirect(action="cMailingList.list",append="siteid",path="")>
	</cfif>
	  <cfif rc.moduleid eq '00000000000000000000000000000000000'>
		 <cfset rc.moduleid="00000000000000000000000000000000000">
		 <cfset rc.topid="00000000000000000000000000000000001">
		 <cfset variables.fw.redirect(action="cArch.list",append="siteid,topid,moduleid",path="")>
	</cfif>
	  <cfif rc.moduleid eq '00000000000000000000000000000000006'>
		 <cfset variables.fw.redirect(action="cAdvertising.listAdvertisers",append="siteid",path="")>
	</cfif>
	<cfif rc.moduleid eq '00000000000000000000000000000000010'>
	 	<cfset variables.fw.redirect(action="cCategory.list",append="siteid",path="")>
	</cfif>
	 <cfif rc.moduleid eq '00000000000000000000000000000000011'>
		<cfset variables.fw.redirect(action="cFeed.list",append="siteid",path="")>
	</cfif>
	
	 <cfset variables.fw.redirect(action="cPlugins.list",append="siteid",path="")>
</cffunction>

</cfcomponent>