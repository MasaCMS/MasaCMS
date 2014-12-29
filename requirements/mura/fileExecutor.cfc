component extends="mura.cfobject" {
	
	function execute(filepath){
		savecontent variable="local.returnString"{
			include arguments.filepath;
		}
		return local.returnString;
	}

}