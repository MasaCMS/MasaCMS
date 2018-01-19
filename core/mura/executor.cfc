component extends="mura.cfobject" hint="This provides a utility to execute cfm file with tread safety"{

	function execute(filepath){
		var result='';

		savecontent variable="result"{
			include "#filepath#";
		}

		return result;
	}

}
