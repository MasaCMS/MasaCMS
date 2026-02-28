<cfsetting showdebugoutput="false" >
<cfparam name="url.reporter" default="simple">

<cfparam name="url.directory" 			default="tests.specs">
<cfparam name="url.recurse" 			default="true" type="boolean">
<cfparam name="url.bundles" 			default="">
<cfparam name="url.labels" 				default="">
<cfparam name="url.excludes" 			default="">
<cfparam name="url.reportpath" 			default="#expandPath( "/tests/results" )#">
<cfparam name="url.propertiesFilename" 	default="TEST.properties">
<cfparam name="url.propertiesSummary" 	default="false" type="boolean">
<cfparam name="url.editor" 				default="vscode">
<cfparam name="url.bundlesPattern" 		default="*.cfc">

<cfparam name="url.coverageEnabled"					default="true" type="boolean">
<cfparam name="url.coverageSonarQubeXMLOutputPath"	default="">
<cfparam name="url.coveragePathToCapture"			default="#expandPath( '/testbox/system/' )#">
<cfparam name="url.coverageWhitelist"				default="">
<cfparam name="url.coverageBlacklist"				default="/stubs/**,/modules/**,/coverage/**,Application.cfc">
<!--- Enable batched code coverage reporter, useful for large test bundles which require spreading over multiple testbox run commands. --->
<cfparam name="url.isBatched"						default="false">

<!--- FYI the "coverageBrowserOutputDir" folder will be DELETED and RECREATED each time
	  you generate the report. Don't point this setting to a folder that has other important
	  files. Pick a blank, essentially "temp" folder somewhere. Brad may or may not have
	  learned this the hard way. Learn from his mistakes. :) --->
<cfparam name="url.coverageBrowserOutputDir"		default="#expandPath( '/tests/results/coverageReport' )#">

<cfset sessionData=application.mura.getSession()>
<cfif not isDefined('sessionData.mura')>
    <cfset application.mura.getBean('userUtility').setUserStruct()>
</cfif>

<cfif application.mura.getBean('configBean').getValue(property='testbox',defaultValue=false) and directoryExists(Expandpath("/testbox"))>
    <cfset testbox = new testbox.system.TestBox( 
        labels   = url.labels,
        excludes = url.excludes,
        options  =  {
            coverage : {
                enabled       	: url.coverageEnabled,
                pathToCapture 	: url.coveragePathToCapture,
                whitelist     	: url.coverageWhitelist,
                blacklist     	: url.coverageBlacklist,
                isBatched		: url.isBatched,
                sonarQube     	: {
                    XMLOutputPath : url.coverageSonarQubeXMLOutputPath
                },
                browser			: {
                    outputDir : url.coverageBrowserOutputDir
                }
            }
        },
        bundlesPattern = url.bundlesPattern,
        directory = { 
            mapping = "muraWRM.core.tests.specs",
            recurse = true 
        }
    ) >
    <cfoutput>#testbox.run(reporter=url.reporter)#</cfoutput>
<cfelse>
    <h1>Access Restricted.</h1>
    <cfoutput>
      <br/>Testbox enabled: #application.mura.getBean('configBean').getValue(property='testbox',defaultValue=false)#
      <br/>Testbox installed: #directoryExists(Expandpath("/testbox"))#
    </cfoutput>
</cfif>
