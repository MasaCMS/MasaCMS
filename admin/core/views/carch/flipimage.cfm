<!---<cfcontent type="application/json">--->
<cfparam name="session.mura.allowphotocropper" default="false">
<cfif rc.$.validateCSRFTokens(context=rc.fileid) or session.mura.allowphotocropper>
<cfset session.mura.allowphotocropper=true>
<cfset application.serviceFactory.getBean('fileManager').flip(argumentCollection=rc)>
</cfif>
<cfabort>