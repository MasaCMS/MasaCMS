<cfscript>
    if ( left(server.coldfusion.productversion,5) == "9,0,0" || listFirst(server.coldfusion.productversion) < 9 ) {
        writeOutput("Masa CMS requires Adobe Coldfusion 9.0.1 or greater compatibility");
        abort;
    }

    function logError(e){
        writeLog(type="Error", log="exception", text="#serializeJSON(arguments.e)#");
    }

    function parseXML(required string xmlString){
        return xmlParse(xmlString, false, {allowExternalEntities: false});
    }

    function masaFileWrite(required string filePath, required string data) {
        fileWrite(filePath, data);
    }

    function masaFileCopy(required string source, required string destination) {
        fileCopy(source, destination);
    }
</cfscript>