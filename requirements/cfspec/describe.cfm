<cfsilent>

<cfif not isDefined("caller.__cfspecRunner")>
  <cfset request.singletons = createObject("component", "cfspec.lib.Singletons").init()>
  <cfset specRunner = createObject("component", "cfspec.lib.SpecRunner").init()>
  <cfset htmlReport = createObject("component", "cfspec.lib.HtmlReport").init()>
  <cfset specStats = createObject("component", "cfspec.lib.SpecStats").init()>
  <cfset specRunner.setReport(htmlReport)>
  <cfset specRunner.setSpecStats(specStats)>
  <cfset specRunner.runSpecFile(getBaseTemplatePath())>
  <cfset writeOutput(htmlReport.getOutput())>
  <cfabort>
</cfif>

<cfif thisTag.executionMode eq "start">
  <cfset exitMethod = caller.__cfspecRunner.describeStartTag(attributes)>
  <cfif exitMethod neq "">
    <cfexit method="#exitMethod#">
  </cfif>
<cfelse>
  <cfset exitMethod = caller.__cfspecRunner.describeEndTag(attributes)>
  <cfif exitMethod neq "">
    <cfexit method="#exitMethod#">
  </cfif>
</cfif>

</cfsilent>
