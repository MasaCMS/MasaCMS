<cfif request.muraInDocker>
    <cfif request.muraSysEnv.MURA_DBTYPE eq 'mssql'>
      <cfquery name="rs" datasource="nodatabase">
          select * from sys.databases where name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.muraSysEnv.database#">
      </cfquery>
      <cfif not rs.recordcount>
        <cfquery datasource="nodatabase">
            CREATE DATABASE <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.muraSysEnv.database#">
        </cfquery>

        <cfset FORM['#application.setupSubmitButton#']=true>
        <cfset FORM['#application.setupSubmitButtonComplete#']=true>
        <cfset FORM['setupSubmitButton']=true>
        <cfset FORM['action']='doSetup'>
      </cfif>
    <cfelseif request.muraSysEnv.MURA_DBTYPE eq 'mysql'>
      <cfquery name="rs" datasource="nodatabase">
          SELECT IF('#request.muraSysEnv.MURA_DATABASE#' IN(SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA), 1, 0) AS found;
      </cfquery>

      <cfif not rs.found>
          <cfquery datasource="nodatabase">
              CREATE DATABASE #request.muraSysEnv.MURA_DATABASE#;
          </cfquery>

          <cfset FORM['#application.setupSubmitButton#']=true>
          <cfset FORM['#application.setupSubmitButtonComplete#']=true>
          <cfset FORM['setupSubmitButton']=true>
          <cfset FORM['action']='doSetup'>
      </cfif>
    <cfelseif request.muraSysEnv.MURA_DBTYPE eq 'postgres'>
        <cfquery name="rs" datasource="nodatabase">
          SELECT datname FROM pg_catalog.pg_database WHERE lower(datname) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(request.muraSysEnv.database)#">;
        </cfquery>

        <cfif not rs.recordcount>
          <cfquery datasource="nodatabase">
              CREATE DATABASE <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.muraSysEnv.database#">
          </cfquery>

          <cfset FORM['#application.setupSubmitButton#']=true>
          <cfset FORM['#application.setupSubmitButtonComplete#']=true>
          <cfset FORM['setupSubmitButton']=true>
          <cfset FORM['action']='doSetup'>
        </cfif>
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
