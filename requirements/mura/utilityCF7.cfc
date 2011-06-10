<cfcomponent extend="mura.utility" output="false">

<cffunction name="checkForInstanceOf" output="false">
	<cfargument name="obj">
	<cfargument name="name">
	<cfreturn getMetaData(arguments.obj).name eq arguments.name>
</cffunction>

</cfcomponent>