component extends="mura.cfobject" {

	// Event handler that intercepts deprecation warnings and write them to a seperate log file
	// It runs in the global context, so covers ALL Mura sites that are running
	
	public void function onLogDeprecation() {			
		local.deprecationType = arguments.event.getValue('deprecationType');
		local.deprecationCallStack = arguments.event.getValue('deprecationCallStack');

		if(local.deprecationType == ''){
			local.deprecationType = 'Unknow Deprecation Type';
		}
		
		if(!isArray(local.deprecationCallStack)) {
			local.deprecationCallStack = [];			
			local.deprecationCallStack[1] = 
			{			
				function = "No Deprecation CallStack Set"
				, lineNumber =  "-1" 
				, template = "Unknown template"
			};
		}		
		
		writeDeprecationToLog(local.deprecationType, local.deprecationCallStack);
	}	

	private void function writeDeprecationToLog(required string deprecationType, required array deprecationCallStack) {				
		local.logType = 'information';		
		local.numberOfStackTraceLines = 5;
		local.counter = 1;
		local.stackTrace = '';	

		for(line in arguments.deprecationCallStack){	
			local.stackTrace = local.stackTrace & '#chr(10)##chr(13)#Linenumber: #arguments.deprecationCallStack[counter].lineNumber#: Template: #arguments.deprecationCallStack[counter].template#: Function: #arguments.deprecationCallStack[counter].Function#';
			local.counter++;			
			if(local.counter > local.numberOfStackTraceLines){
				break;
			}
		}

		// Assemble the log text
		local.logText = 'Deprecation warning: #arguments.deprecationType#: #local.stackTrace#';		
		// Write the log file
		writeLog(type=local.logType, file='mura-deprecations', text=local.logText, application="no");
	}
}