<cfscript>
    function logError(e){
        writeLog(type="Error", log="exception", text="#serializeJSON(arguments.e)#");
    }

    function parseXML(xmlString){
        return xmlParse(xmlString, false, {allowExternalEntities: false});
    }
</cfscript>