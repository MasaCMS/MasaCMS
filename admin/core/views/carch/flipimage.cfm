<!---<cfcontent type="application/json">--->
<cfset application.serviceFactory.getBean('fileManager').flip(argumentCollection=rc)>
<cfabort>