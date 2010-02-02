<cfcomponent extends="controller" output="false">

<cffunction name="before" output="false">
	<cfargument name="rc">
	<cfparam name="rc.siteid" default="#session.siteid#"/>
	
	<cfif not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') and not listFind(session.mura.memberships,'S2')>
		<cfset secure(rc)>
	</cfif>
</cffunction>

</cfcomponent>