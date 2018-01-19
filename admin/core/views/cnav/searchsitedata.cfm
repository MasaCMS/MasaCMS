<cfcontent type="application/json">
<cfset data = arrayNew(1) />
<cfloop query="rc.rsList">
	<cfset tmp = structNew() />
	<cfset tmp["id"] = rc.rsList.siteid />
	<cfset tmp["value"] = rc.rsList.Site />
	<cfset arrayAppend(data, tmp) />
</cfloop>

<cfoutput>#createObject("component","mura.json").encode(data)#</cfoutput>
<cfabort>
