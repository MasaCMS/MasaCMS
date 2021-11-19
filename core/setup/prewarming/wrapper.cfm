<cfscript>
    function getDirectoryList(path){
        if(directoryExists(path)){
            return directoryList(path);
        } else {
            return [];
        }
    }

    request.compiled=[];

    function compileItem(item,mapping) output=false {
        var cfc="";

        if(directoryExists(arguments.item)){
            if(len(arguments.mapping)){
                compileDirectory(arguments.item,arguments.mapping & "." & listLast(arguments.item,"/"));
            } else {
                compileDirectory(arguments.item,listLast(arguments.item,"/"));
            }
        } else if (listlast(arguments.item,'.')=='cfc'){
                cfc=listFirst(listLast(arguments.item,'/'),'.');
                arrayAppend(request.compiled,arguments.item);
                try{
                    if(len(arguments.mapping)){
                        createObject(arguments.mapping & "." & cfc);
                    } else {
                        createObject(cfc);
                    }
                } catch (any e){}
        } else if (listlast(arguments.item,'.')=='cfm'){
            arrayAppend(request.compiled,arguments.item);
            try{
                if(len(arguments.mapping)){
                    include "/#replace(arguments.mapping,".","/","all")#/#listlast(arguments.item,'/')#";
                } else {
                    include "/#listlast(arguments.item,'/')#";
                }
            } catch (any e){}
        }
    }
    function compileDirectory(directory='',mapping=""){
        var items=getDirectoryList(arguments.directory);
        if(arrayLen(items)){
            for(var i=1;i<=arrayLen(items);i++){
                compileItem(items[i],arguments.mapping);
            }
        }
    }

    include "./prewarm.cfm";

    writeOutput(serializeJSON(request.compiled));
    abort;
</cfscript>