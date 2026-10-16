component extends="mura.cfobject" {
    function onUnitTestNormal($){
        $.event('response','success');
    }

    function onUnitTestRender($){
        return 'success';
    }

    // Records filebrowser.delete()'s event data for fileBrowserLocal.cfc,
    // keyed by filePath so a handler registered more than once records once.
    function onAfterFileDelete($){
        var info = $.event('fileBrowser');
        if (isStruct(info) && structKeyExists(info, 'filePath')) {
            param name="request.fileBrowserDeleteEvents" default={};
            request.fileBrowserDeleteEvents[info.filePath] = duplicate(info);
        }
    }
}
