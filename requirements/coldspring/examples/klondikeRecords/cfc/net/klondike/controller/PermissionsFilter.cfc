<cfcomponent 
	displayname="PermissionsFilter" 
	extends="MachII.filters.PermissionsFilter"
	output="false"
	hint="This permissions filter extends the built in permissions filter supplied with Mach II. I only need simple permissions (group) based security. The user's group is in session.userData">
	
	<!--- PUBLIC FUNCTIONS --->
	<cffunction name="configure" access="public" returntype="void" output="false">
	</cffunction>
	
	<cffunction name="getUserPermissions" 
			    access="public" 
			    returntype="any" 
			    hint="Retrieve the users's rolls (permissions) from session.userData via getRolls, call validatePermissions to check against requiredPemissions list" >
		<cfset var userPermissions = session.userData.getRoll() />
		<cfif len(userPermissions)>
			<cfreturn userPermissions />
		<cfelse>
			<cfreturn '' />
		</cfif>
	</cffunction>
	
	<cffunction name="validatePermissions" access="public" returntype="boolean">
		<cfargument name="requiredPermissions" type="string" required="true" />
		<cfargument name="userPermissions" type="string" required="true" />
		
		<cfset var isValidated = false />
		<cfset var permission = 0 />
		
		<cfloop index="permission" list="#requiredPermissions#" delimiters=",">
			<cfif ListContainsNoCase(arguments.userPermissions,permission)>
				<cfset isValidated = true />
			</cfif>
		</cfloop>
		
		<cfreturn isValidated />
	</cffunction>
	
</cfcomponent>