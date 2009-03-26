<!--- Fusebox.org thanks Massimo Foti for contributing this code --->
<cfscript>
/**
 * @param startFile 	 First file. (Required)
 * @param endFile 	 Second file. (Required)
 * @return Returns a string. 
 */
function fb_relativeFilePath(startFile,endFile){
	//In case we have absolute local paths, turn backward to forward slashes
	var startpath = Replace(startFile,"\","/","ALL"); 
	var endPath = Replace(endFile,"\","/","ALL"); 
	//Declare variables
	var i = 1;
	var j = 1;
	var endStr = "";
	var commonStr = "";
	var retVal = "";
	var whatsLeft = "";
	var slashPos = "";
	var slashCount = 0;
	var dotDotSlash = "";
	//Be sure the paths aren't equal
	if(startpath NEQ endPath){
		//If the starting path is longer, the destination path is our starting point
		if(len(startpath) GT len(endPath)){
			endStr = len(endPath);
		}
		//Else the starting point is the start path
		else{
			endStr = len(startpath);
		}
		//Check if the two paths share a base path and store it into the commonStr variable
		for(i;i LT endStr; i=i+1){
			//Compare one character at time
			if(mid(startpath,i,1) EQ mid(endPath,i,1)){
				commonStr = commonStr & mid(startpath,i,1);
			}
			else{
				break;
			}
		}
		//We just need the base directory
		commonStr=REReplaceNoCase(commonStr,"[^/]*$","");
		//If there is a common base path, remove it
		if(len(commonStr) GT 0){
			whatsLeft = mid(startpath,len(commonStr)+1,len(startpath));
		}
		else{
			whatsLeft = startpath;
		}
		slashPos = find("/",startpath);
		//Count how many directories we have to climb
		while(slashPos NEQ 0){
			slashCount = slashCount + 1;
			slashPos = find("/",whatsLeft,slashPos+1);
		}
		//Append "../" for each directory we have to climb
		for(j;j LT slashCount; j=j+1){
			dotDotSlash = dotDotSlash & "../";
		}
		//Assemble the final path
		retVal = dotDotSlash & mid(endPath,len(commonStr)+1,len(endPath));
		
		if (find("/", retVal) EQ 0)
			retVal = "./" & retVal;
	}
	//Paths are the same
	else{
		retVal = "";
	}
	return retVal;
}
</cfscript>