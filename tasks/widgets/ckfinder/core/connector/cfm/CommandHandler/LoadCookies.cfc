<cfcomponent output="false" extends="XmlCommandHandlerBase">
<!---
 * CKFinder
 * ========
 * http://ckfinder.com
 * Copyright (C) 2007-2012, CKSource - Frederico Knabben. All rights reserved.
 *
 * The software, this file and its contents are subject to the CKFinder
 * License. Please read the license.txt file before using, installing, copying,
 * modifying or distribute this file or part of its contents. The contents of
 * this file is part of the Source Code of CKFinder.
--->
<cfset THIS.command = "LoadCookies" >

<cffunction access="public" name="buildXml" hint="send XML response" returntype="boolean" description="send response" output="true">
	<cfset var nodeCookies = XMLElemNew(THIS.xmlObject, "Cookies") />

	<cfif not structkeyexists(FORM, "CKFinderCommand") or FORM.CKFinderCommand neq "true">
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder" />
	</cfif>

	<cfif not THIS.currentFolder.checkAcl(REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_VIEW) >
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED#" type="ckfinder" />
	</cfif>

	<cfloop collection="#cookie#" item="cname">
		<cfif find('CKFinder_', cname) neq 1>
			<cfset nodeCookie = XMLElemNew(THIS.xmlObject, "Cookie") />
			<cfset nodeCookie.xmlAttributes["name"] = cname />
			<cfset nodeCookie.xmlAttributes["value"] = cookie[cname] />
			<cfset ArrayAppend(nodeCookies.xmlChildren, nodeCookie) />
		</cfif>
	</cfloop>
	<cfset ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, nodeCookies)>
	<cfreturn true>
</cffunction>

</cfcomponent>
