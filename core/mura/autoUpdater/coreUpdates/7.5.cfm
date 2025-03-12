<cfscript>
    removeOldFilePath1 = "../../../mura/client/api/feed/v1/apiUtility.cfc";
    if(fileExists(removeOldFilePath1)){
       file action="delete" file="#removeOldFilePath1#";
    }

    removeOldFilePath2 = "../../../mura/client/api/json/v1/apiUtility.cfc";
    if(fileExists(removeOldFilePath2)){
       file action="delete" file="#removeOldFilePath2#";
    }
</cfscript>
