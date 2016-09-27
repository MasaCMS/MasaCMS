<cfscript>
    applicationKey=listLast(GetDirectoryFromPath(GetCurrentTemplatePath()),m.globalConfig('fileDelim'));

    fw1Config={
        applicationKey=applicationKey,

        usingSubsystems=true,

        defaultSubsystem="public",

        defaultSection = 'main',

        defaultItem = 'default',

        trace = false,

        siloSubsystems = true,

    	debugMode = true, // if TRUE, then additional information is returned by the Application.onError() method

    	reloadApplicationOnEveryRequest = true, // change to TRUE if you're developing the plugin so you can see changes in your controllers, etc. ... otherwise, set to FALSE for production

        base = m.siteConfig().getThemeIncludePath() & "/display_objects/#applicationKey#",

        cfcbase=m.siteConfig().getThemeAssetMap() & ".display_objects.#applicationKey#",

    	trace = false, // if true, will print out debugging/tracing info at the bottom of ea. page (within the Plugin's Administration area only)

    	// the 'action' defaults to your packageNameAction, (e.g., 'MuraFW1action') you may want to update this to something else.
    	// please try to avoid using simply 'action' so as not to conflict with other FW1 plugins
    	action = applicationKey & 'action',

    	// dependency injection framework
    	diEngine = 'di1',

        diComponent="mura.bean.ioc"
    };
</cfscript>
