component extends="mura.cfobject" {

    function onRenderstart(m){
        if(!yesNoFormat(m.event('amp'))){
          m.addToHTMLFootQueue('<script src="#m.siteConfig().getRootPath(complete=true,useProtocol=false)#/core/modules/v1/cta/js/mura.displayobject.cta.min.js" #m.getMuraJSDeferredString()#></script>');
        }
    }

}
