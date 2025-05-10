<cfscript>
    function logError(e){
        cflog(type="Error", log="exception", exception=arguments.e);
    }

    function parseXML(equired string xmlString){
        return xmlParse(xmlString);
    }

    function masaFileWrite(required string filePath, required string data) {
        var writer = createObject("java", "java.io.BufferedWriter")
            .init(createObject("java", "java.io.FilterWriter")
                .init(arguments.filePath)
            );
        writer.write(data);
        writer.close();
    }

    function masaFileCopy(required string source, required string destination) {
        masaFileWrite(destination, fileRead(source));
    }
</cfscript>