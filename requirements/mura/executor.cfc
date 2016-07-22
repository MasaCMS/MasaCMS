component extends="mura.cfobject" {

	function execute(filepath){
		var result='';

		savecontent variable="result"{
			include "#filepath#";
		}

		return result;
	}

}
