component
	extends="mura.cfobject"
	output=false
  {

		function onRenderStart(m){
			m.addToHTMLHeadQueue('<script src="#m.globalConfig('baseURL')#/core/modules/v1/filebrowser/assets/js/filebrowser.js"></script>');

		}

    function onApplicationLoad() {
    }

}
