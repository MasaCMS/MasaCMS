component
	extends="mura.cfobject"
	output=false
  {

		function onRenderStart(m){
			m.addToHTMLHeadQueue('<script src="#m.globalConfig('baseURL')#/core/modules/v1/vuefm/assets/js/vuefm.js"></script>');

		}

    function onApplicationLoad() {
    }

}
