<cfcomponent extends="controller" output="false">

<cffunction name="before" output="false">
	<cfargument name="rc">
	<cfif not session.mura.isLoggedin or not listFind(session.mura.memberships,'S2IsPrivate')>
		<cflocation url="#application.configBean.getContext()#/" addtoken="false">
	</cfif>
</cffunction>

</cfcomponent>