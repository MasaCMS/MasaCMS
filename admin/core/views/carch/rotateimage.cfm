<!---<cfcontent type="application/json">--->
<cfset application.serviceFactory.getBean('fileManager').rotate(argumentCollection=rc)>
<cfabort>