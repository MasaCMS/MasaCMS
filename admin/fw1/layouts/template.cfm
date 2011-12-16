<cfif not isdefined("rc.layout") or not len(rc.layout)>
	<cfset rc.layout=body>
</cfif>
<cfoutput>#doFBInclude("/muraWRM/admin/view/layouts/template.cfm")#</cfoutput>