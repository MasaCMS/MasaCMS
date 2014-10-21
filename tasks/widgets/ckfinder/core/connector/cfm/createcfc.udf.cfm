<cfsilent>
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

<!--- function that allow us to create/call components inside subdirectories --->
<cffunction name="CreateCFC" access="public" returntype="any" output="false"
hint="Creates a CFC Creation proxy. Does NOT initialize the component, only creates it.">
<!--- Define arguments. --->
<cfargument name="Path" type="string" required="true" />
<!--- Return the created component. --->
<cfif ARGUMENTS.Path eq "Utils.Folder" and APPLICATION.CFVersion lte 6>
	<cfreturn CreateObject("component", ARGUMENTS.Path & "6") />
<cfelseif ARGUMENTS.Path eq "Utils.Folder" and APPLICATION.CFVersion gte 7>
	<cfreturn CreateObject("component", ARGUMENTS.Path & "7") />
<cfelseif ARGUMENTS.Path eq "Utils.Thumbnail" and APPLICATION.CFVersion gte 8>
	<cfreturn CreateObject("component", ARGUMENTS.Path & "8") />
<cfelseif ARGUMENTS.Path eq "Utils.Thumbnail">
	<cfreturn CreateObject("component", ARGUMENTS.Path & "7") />
<cfelse>
	<cfreturn CreateObject("component", ARGUMENTS.Path) />
</cfif>
</cffunction>
</cfsilent>
