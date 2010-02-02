<cfsilent>

<cfset request.singletons = createObject("component", "cfspec.lib.Singletons").init()>
<cfset specRunner = createObject("component", "cfspec.lib.SpecRunner").init()>
<cfset htmlReport = createObject("component", "cfspec.lib.HtmlReport").init()>
<cfset specStats = createObject("component", "cfspec.lib.SpecStats").init()>
<cfset specRunner.setReport(htmlReport)>
<cfset specRunner.setSpecStats(specStats)>
<cfset specRunner.runSpecSuite(getDirectoryFromPath(getBaseTemplatePath()))>
<cfset writeOutput(htmlReport.getOutput())>
<cfabort>

</cfsilent>
