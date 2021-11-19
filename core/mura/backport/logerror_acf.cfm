<cfscript>
    function logError(e){
        writeLog(type="Error", file="exception", text="#serializeJSON(arguments.e)#");
    }
</cfscript>