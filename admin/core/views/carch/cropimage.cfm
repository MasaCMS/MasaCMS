<!---<cfcontent type="application/json">--->
<cfif rc.$.validateCSRFTokens(context=rc.fileid)>
<cfoutput>#createObject("component","mura.json").encode(application.serviceFactory.getBean('fileManager').cropAndScale(argumentCollection=rc))#</cfoutput>
</cfif>
<cfabort>