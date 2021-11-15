<!---<cfcontent type="application/json">--->
<cfsilent>
    <cfparam name="session.mura.allowphotocropper" default="false">
</cfsilent>
<cfif rc.$.validateCSRFTokens(context=rc.fileid) or session.mura.allowphotocropper>
    <cfsilent>
    <cfset cropper=application.serviceFactory.getBean('fileManager').cropAndScale(argumentCollection=rc)>
    <cfset structDelete(cropper,'source')>
    <cfset session.mura.allowphotocropper=true>
    </cfsilent> 
    <cfoutput>#createObject("component","mura.json").encode(cropper)#</cfoutput>
</cfif>
<cfabort>