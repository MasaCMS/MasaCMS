<!---<cfcontent type="application/json">--->
<cfif rc.$.validateCSRFTokens(context=rc.fileid)>
	<cfset application.serviceFactory.getBean('fileManager').rotate(argumentCollection=rc)>
</cfif>
<cfabort>