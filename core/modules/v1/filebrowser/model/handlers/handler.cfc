component
	extends="mura.cfobject"
	output=false
  {

		function onRenderStart(m){
			//m.addToHTMLHeadQueue('<script src="#m.globalConfig('baseURL')#/core/modules/v1/filebrowser/assets/js/filebrowser.js" #m.getMuraJSDeferredString()#></script>');

		}

    function onApplicationLoad() {
    }

	/*
	fileBrowser event listener example
    function onAfterFileUpload( m,event ) {
		dump(arguments.event.getValue('fileBrowser'));
		abort;
    }
	*/

}
