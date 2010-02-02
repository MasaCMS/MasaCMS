<!---
  HtmlReport is an HTML version of the SpecRunner's output report.
--->
<cfcomponent output="false">



  <cffunction name="init" output="false">
    <cfset reset()>
    <cfreturn this>
  </cffunction>



  <cffunction name="reset" output="false">
    <cfset _blockStatus = arrayNew(1)>
    <cfset _block = arrayNew(1)>
    <cfset arrayAppend(_blockStatus, "pass")>
    <cfset arrayAppend(_block, "")>
  </cffunction>



  <cffunction name="setSpecStats" output="false">
    <cfargument name="specStats">
    <cfset _specStats = specStats>
  </cffunction>



  <cffunction name="getOutput" output="false">
    <cfset var head = "<head><title>cfSpec</title>#getStyle()##getScripts()#</head>">
    <cfset var body = "<body>#getSpecStatsSummary()##_block[1]#</body>">
    <cfreturn "<html>#head##body#</html>">
  </cffunction>



  <cffunction name="enterBlock" output="false">
    <cfargument name="hint">
    <cfset arrayPrepend(_blockStatus, "pass")>
    <cfset arrayPrepend(_block, '#hint#</h2><div>')>
  </cffunction>



  <cffunction name="addExample" output="false">
    <cfargument name="status">
    <cfargument name="expectation">
    <cfargument name="exception" default="">
    <cfset var s = '<div class="it #status#">#expectation#'>
    <cfif (_blockStatus[1] eq "pass") or (_blockStatus[1] eq "pend" and status neq "pass")>
      <cfset _blockStatus[1] = status>
    </cfif>
    <cfif not isSimpleValue(exception)>
      <cfset s = s & '<br /><br />' & formatException(exception)>
    </cfif>
    <cfset s = s & '</div>'>
    <cfset _block[1] = _block[1] & s>
  </cffunction>



  <cffunction name="exitBlock" output="false">
    <cfset _block[2] = _block[2] & '<h2 class="#_blockStatus[1]#">#_block[1]#</div>'>
    <cfif (_blockStatus[2] eq "pass") or (_blockStatus[2] eq "pend" and _blockStatus[1] neq "pass")>
      <cfset _blockStatus[2] = _blockStatus[1]>
    </cfif>
    <cfset arrayDeleteAt(_blockStatus, 1)>
    <cfset arrayDeleteAt(_block, 1)>
  </cffunction>



  <!--- PRIVATE --->



  <cffunction name="getStyle" access="private" output="false">
    <cfset var style = "">
    <cffile action="read" file="#expandPath('/cfspec/includes/style.css')#" variable="style">
    <cfset style = trim(reReplace(style, "\s+", " ", "all"))>
    <cfreturn "<style> #style# </style>">
  </cffunction>



  <cffunction name="getScripts" access="private" output="false">
    <cfset var scripts = "">
    <cfset var script = "">
    <cfset var jsFile = "">
    <cfloop list="jquery-1.3.1.min,application" index="jsFile">
      <cffile action="read" file="#expandPath('/cfspec/includes/#jsFile#.js')#" variable="script">
      <cfset scripts = scripts & script>
    </cfloop>
    <cfreturn "<script language='JavaScript'>#scripts#</script>">
  </cffunction>



  <cffunction name="getSpecStatsSummary" access="private" output="false">
    <cfset var title = '<span>cfSpec Results</span>'>
    <cfset var summary = '<div class="summary">#_specStats.getCounterSummary()#</div>'>
    <cfset var timer = '<strong>#_specStats.getTimerSummary()#</strong>'>
    <cfset timer = '<div class="timer">Finished in #timer#</div>'>
    <cfreturn '<div class="header #_specStats.getStatus()#">#summary##timer##title#</div>'>
  </cffunction>



  <cffunction name="formatException" access="private" output="false">
    <cfargument name="e">
    <cfset var context = "">
    <cfset var s = "">
    <cfset var i = "">
    <cfset s = "<u>#e.type#</u><br />Message: #e.message#<br />Detail: #e.detail#<br />Stack Trace:">
    <cfloop index="i" from="1" to="#arrayLen(e.tagContext)#">
      <cfset context = e.tagContext[i]>
      <cfset s = s & "<pre>  ">
      <cfset s = s & iif(isDefined("context.id"), "context.id", de("???"))>
      <cfset s = s & " at #context.template#(#context.line#,#context.column#)</pre>">
    </cfloop>
    <cfreturn "<small>#s#</small>">
  </cffunction>



</cfcomponent>
