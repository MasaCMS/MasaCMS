component extends="mura.cfobject" {

	function execute(filepath){
		var result='';

		if(fileExists(arguments.filepath)){
			var tempfile=createUUID() & '.cfm';
			var tempDir=expandPath('/mura/temp');

			if(!directoryExists(tempDir)){
				directoryCreate(tempDir);
			}

			var temp=fileRead(arguments.filepath);

			if(findNoCase('cfoutput', temp) || findNoCase('writeoutput', temp)){

				fileWrite(tempDir & "/" & tempfile,temp);

				savecontent variable="result"{
					include "/mura/temp/#tempfile#";
				}

				fileDelete(tempDir & "/" & tempfile);
			} else {
				result=temp;
			}
		} else {
			savecontent variable="result"{
				include "#filepath#";
			}
		}

		return result;
	}

}
