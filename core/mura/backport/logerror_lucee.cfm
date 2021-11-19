<cfscript>
    function logError(e){
        cflog(type="Error", file="exception", exception=arguments.e);
    }
</cfscript>