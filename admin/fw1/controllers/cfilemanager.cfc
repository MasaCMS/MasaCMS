<cfcomponent extends="controller" output="false">

<cffunction name="before" output="false">
	<cfargument name="rc">
	<cfparam name="arguments.rc.siteid" default="#session.siteid#"/>
	
	<cfif not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0') and not listFind(session.mura.memberships,'S2')>
		<cfset secure(arguments.rc)>
	</cfif>
	
	<cfparam name="session.resourceType" default="assets">

	<cfif not listFindNoCase(session.mura.memberships,'S2')>
	<cflocation addtoken="false" url="#application.configBean.getContext()#/admin/">
	</cfif>
</cffunction>

</cfcomponent>