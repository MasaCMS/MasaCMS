<cfscript>
    function logError(e){
        cflog(type="Error", log="exception", exception=arguments.e);
    }

    function parseXML(required string xmlString){
        return xmlParse(xmlString);
    }

    function masaFileWrite(required string filePath, required string data) {
        fileWrite(filePath, data);
    }

    function masaFileCopy(required string source, required string destination) {
        fileCopy(source, destination);
    }
</cfscript>