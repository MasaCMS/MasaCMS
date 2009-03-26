<cfscript>
		// must enable implicit (no-XML) mode!
		FUSEBOX_PARAMETERS.allowImplicitFusebox = true;
		FUSEBOX_APPLICATION_KEY	 ="FBNoXML";
		// the rest is taken straight from the traditional fusebox.xml skeleton:
		FUSEBOX_PARAMETERS.defaultFuseaction = "app.welcome";
		// you may want to change this to development-full-load mode:
		FUSEBOX_PARAMETERS.mode = "development-circuit-load";
		FUSEBOX_PARAMETERS.conditionalParse = true;
		// change this to something more secure:
		FUSEBOX_PARAMETERS.password = "skeleton";
		FUSEBOX_PARAMETERS.strictMode = true;
		FUSEBOX_PARAMETERS.debug = true;
		// we use the core file error templates:
		FUSEBOX_PARAMETERS.errortemplatesPath = "/fusebox5/errortemplates/";
		
		// These are all default values that can be overridden:
		// FUSEBOX_PARAMETERS.fuseactionVariable = "fuseaction";
		// FUSEBOX_PARAMETERS.precedenceFormOrUrl = "form";
		// FUSEBOX_PARAMETERS.scriptFileDelimiter = "cfm";
		// FUSEBOX_PARAMETERS.maskedFileDelimiters = "htm,cfm,cfml,php,php4,asp,aspx";
		// FUSEBOX_PARAMETERS.characterEncoding = "utf-8";
		// FUSEBOX_PARAMETERS.strictMode = false;
		// FUSEBOX_PARAMETERS.allowImplicitCircuits = false;

		// force the directory in which we start to ensure CFC initialization works:
		FUSEBOX_CALLER_PATH = getDirectoryFromPath(getCurrentTemplatePath());
	</cfscript>

<cfinclude template="/fusebox5/fusebox5.cfm" />
