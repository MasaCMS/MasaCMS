<cfif isDefined('request.muraSysEnv.MURA_DATABASE')>
    <!--- MYSQL ONLY AT THE MOMENT --->
    <cfquery name="checkForDB">
        SELECT IF('#request.muraSysEnv.MURA_DATABASE#' IN(SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA), 1, 0) AS found;
    </cfquery>

    <cfif not checkForDB.found>
        <cfquery>
            CREATE DATABASE #request.muraSysEnv.MURA_DATABASE#;
        </cfquery>

        <cfset FORM['#application.setupSubmitButton#']=true>
        <cfset FORM['#application.setupSubmitButtonComplete#']=true>
        <cfset FORM['setupSubmitButton']=true>
        <cfset FORM['action']='doSetup'>
    </cfif>

    <cfquery name="checkForTCONTENT">
        SELECT IF('tcontent' IN(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '#request.muraSysEnv.MURA_DATABASE#' AND TABLE_NAME = 'tcontent'), 1, 0) AS found;
    </cfquery>

    <cfif not checkForTCONTENT.found>
        <cfset FORM['#application.setupSubmitButton#']=true>
        <cfset FORM['#application.setupSubmitButtonComplete#']=true>
        <cfset FORM['setupSubmitButton']=true>
        <cfset FORM['action']='doSetup'>
    </cfif>
</cfif>
