<cfif not isdefined("rc.layout") or not len(rc.layout)>
	<cfset rc.layout=body>
</cfif>
<cfoutput>#doFBInclude("/muraWRM/admin/common/layouts/includes/template.cfm")#</cfoutput>