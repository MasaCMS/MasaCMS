<cfscript>
    function logError(e){
        cflog(type="Error", log="exception", exception=arguments.e);
    }

    function parseXML(xmlString){
        return xmlParse(xmlString);
    }
</cfscript>