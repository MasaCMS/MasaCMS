<cfcomponent output="false">
<!---
 * CKFinder
 * ========
 * http://cksource.com/ckfinder
 * Copyright (C) 2007-2014, CKSource - Frederico Knabben. All rights reserved.
 *
 * The software, this file and its contents are subject to the CKFinder
 * License. Please read the license.txt file before using, installing, copying,
 * modifying or distribute this file or part of its contents. The contents of
 * this file is part of the Source Code of CKFinder.
--->

<cffunction name="run" output="true" returntype="Boolean">
	<cfargument name="event" required="true" type="String">
	<cfargument name="arg1" required="false" type="any" default=false>
	<cfargument name="arg2" required="false" type="any" default=false>

	<cfset var result = true>
	<cfif structkeyexists(REQUEST.config, "hooks") and arrayLen(REQUEST.config.hooks)>
		<cfloop from="1" to="#arrayLen(REQUEST.config.hooks)#" step="1" index="i">
			<cfif REQUEST.config.hooks[i][1] eq event>
				<cfset callback = "#REQUEST[REQUEST.config.hooks[i][2]]#">
				<cfset result = result and callback(arg1, arg2)>
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn result>
</cffunction>

</cfcomponent>
