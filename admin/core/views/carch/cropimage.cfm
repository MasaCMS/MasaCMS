<!---<cfcontent type="application/json">--->
<cfparam name="session.mura.allowphotocropper" default="false">
<cfif rc.$.validateCSRFTokens(context=rc.fileid) or session.mura.allowphotocropper>
<cfset session.mura.allowphotocropper=true>
<cfoutput>#createObject("component","mura.json").encode(application.serviceFactory.getBean('fileManager').cropAndScale(argumentCollection=rc))#</cfoutput>
</cfif>
<cfabort>