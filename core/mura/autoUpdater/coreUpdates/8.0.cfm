<cfscript>
    var dbEngines = ["h2", "mssql", "mysql", "nuodb", "oracle", "postgresql"];
    sqlScriptsFolder = "../../../setup/db/";

    for(i=1; i LTE arrayLen(dbEngines); i++){
        removeOldFilePath = sqlScriptsFolder & dbEngines[i] & ".sql";       
        if(fileExists(removeOldFilePath)){
            file action="delete" file="#removeOldFilePath#";
        }
    }
</cfscript>
