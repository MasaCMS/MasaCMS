component extends="mura.cfobject" {

	// Event handler that intercepts deprecation warnings and write them to a seperate log file
	// It runs in the global context, so covers ALL Mura sites that are running

	variables.deprecationLogDescription = {
		muraTag = "Deprecated tags like '[mura]' or '[sava]' are used. Please update your content to only use the '[m]' tag instead."
		, muraScope = "Deprecated scopes like '$' (dollar) or 'mura' are used. Please update your content to only use the 'm' scope instead."
		, setCustomMuraScopeKey = "The function 'setCustomMuraScopeKey' has been deprecated. Please use the function 'setCustomMasaScopeKey' instead."
		, MuraScopeObject = "The MuraScope.cfc object has been initialized. This will be replaced by the MasaScope.cfc object."
		, SimpleHTMLForms = "A Simple Form has been created. Simple Forms are deprecated. Please use Forms (with the form builder) instead."
		, Razuna = "Razuna is enabled on this MasaCMS istallation. Razuna is deprecated. Migrate to different Digital Asset Management system."
		, UnSupportedLocale =  'A site is using an unsupported Locale. These Locales will be removed from Masa in the future. Use a supported Locale instead.'
	};

	public void function onLogDeprecation() {
		local.deprecationType = arguments.event.getValue('deprecationType');
		local.deprecationCallStack = callStackGet();

		if(local.deprecationType == ''){
			local.deprecationType = 'Unknow Deprecation Type';
		}

		if(!isArray(local.deprecationCallStack)) {
			local.deprecationCallStack = [];
			local.deprecationCallStack[1] =
			{
				lineNumber =  "-1"
				, template = "Unknown template"
			};
		}

		writeDeprecationToLog(local.deprecationType, local.deprecationCallStack);
	}

	private void function writeDeprecationToLog(required string deprecationType, required array deprecationCallStack) {
		local.deprecationwarningsenabled = application.configBean.getValue(property='deprecationwarningsenabled');
		local.deprecationlogfile = application.configBean.getValue(property='deprecationlogfile');
		local.logType = 'information';
		local.numberOfStackTraceLines = 10;
		local.counter = 1;
		local.linesPrinted = 1;
		local.stackTrace = '';
		local.deprecationDescription = "No deprecation description found.";

		if(structKeyExists(variables.deprecationLogDescription,arguments.deprecationType)){
			local.deprecationDescription = variables.deprecationLogDescription[arguments.deprecationType];
		}

		for(line in arguments.deprecationCallStack){
			local.line = arguments.deprecationCallStack[counter];
			local.template = local.line.template;

			// Do not print items in the stacktrace that are from this handler or the pluginManager.cfc
			if( local.template != '/app/core/modules/v1/deprecation/model/handlers/handler.cfc'
				&& local.template != '/app/core/mura/plugin/pluginManager.cfc'){
				local.stackTrace = local.stackTrace & '#chr(10)##chr(13)#Linenumber: #local.line.lineNumber#: Template: #local.line.template#: Function: #local.line.Function#';
				local.linesPrinted++;
			}

			local.counter++;

			if(local.linesPrinted > local.numberOfStackTraceLines){
				break;
			}
		}

		// Assemble the log text
		local.logText = 'Deprecation warning: #arguments.deprecationType#: #local.deprecationDescription# #local.stackTrace#';

		if(local.deprecationwarningsenabled){
			// Write the log file
			writeLog(type=local.logType, file=local.deprecationlogfile, text=local.logText, application="no");
		}
	}
}