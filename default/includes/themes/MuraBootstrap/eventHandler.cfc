<!--- Be sure to reload Mura after making any changes or adding methods here. A site's local eventHandler.cfc does not need to be reinitialized via appreload, only theme-specific ones (like this) --->
<cfcomponent extends="mura.cfobject" output="false">

	<cffunction name="onSiteRequestStart" output="false">
		<cfargument name="$" hint="mura scope" />
		<cfscript>
			// http://dominicwatson.github.com/cfstatic/full-guide.html
			// minifyMode: none,file,package,all
			// if in production, set checkForUpdates=false
			arguments.$.static(
				outputDirectory = 'compiled'
				, minifyMode = 'package' 
				, checkForUpdates = !arguments.$.siteConfig('cache')
			);
		</cfscript>
	</cffunction>

	<cffunction name="onSiteCKEditorConfigRender" access="public" output="false" returntype="any">
		<cfargument name="$" hint="mura scope" />
		<cfset var str = '' />
		<cfsavecontent variable="str"><cfoutput>
			// heading vars
			config.format_h1 = { element : 'h2' };
			config.format_h2 = { element : 'h3' };
			config.format_h3 = { element : 'h4' };
			config.format_h4 = { element : 'h5' };
			config.format_h5 = { element : 'h6' };
		</cfoutput></cfsavecontent>
		<cfreturn str />
	</cffunction>

	<cffunction name="onRenderStart" output="false">
		<cfargument name="$" hint="mura scope" />
		<cfscript>
			var renderer = arguments.$.getContentRenderer();

			// general vars
			renderer.jsLibLoaded = true;
			renderer.generalWrapperClass = 'well';

			// nav and list item vars
			renderer.navWrapperClass = 'well';
			renderer.liHasKidsClass = '';
			renderer.liHasKidsCustomString = '';
			renderer.liCurrentClass = 'active';
			renderer.liCurrentCustomString = '';
			renderer.aHasKidsClass = '';
			renderer.aHasKidsCustomString = '';
			renderer.aCurrentClass = 'active';
			renderer.aCurrentCustomString = '';
			renderer.ulTopClass = 'nav nav-list';
			renderer.ulNestedClass = 'nav nav-list';
			renderer.ulNestedCustomString = '';
			renderer.liNestedClass = '';

			// pagination vars
			renderer.ulPaginationClass = '';
			renderer.ulPaginationWrapperClass = 'pagination';

			// form vars
			renderer.formWrapperClass = 'well';
		</cfscript>
	</cffunction>

</cfcomponent>