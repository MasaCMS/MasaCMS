component extends="mura.cfobject" {
    function onUnitTestNormal($){
        $.event('response','success');
    }

    function onUnitTestRender($){
        return 'success';
    }
}
