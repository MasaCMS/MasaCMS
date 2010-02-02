<!---
  SpecStats keeps tracks of how many tests have passed, failed or pended, and how long it took.
--->
<cfcomponent output="false">



  <cffunction name="init" output="false">
    <cfset reset()>
    <cfreturn this>
  </cffunction>



  <cffunction name="reset" output="false">
    <cfset _startTime = getTickCount()>
    <cfset _exampleCount = 0>
    <cfset _passCount = 0>
    <cfset _pendCount = 0>
  </cffunction>


  <cffunction name="incrementExampleCount" output="false">
    <cfset _exampleCount = _exampleCount + 1>
  </cffunction>



  <cffunction name="incrementPassCount" output="false">
    <cfset _passCount = _passCount + 1>
  </cffunction>



  <cffunction name="incrementPendCount" output="false">
    <cfset _pendCount = _pendCount + 1>
  </cffunction>



  <cffunction name="getStatus" output="false">
    <cfset var failCount = _exampleCount - _passCount - _pendCount>
    <cfset var status = "pass">
    <cfif failCount>
      <cfset status = "fail">
    <cfelseif _pendCount>
      <cfset status = "pend">
    </cfif>
    <cfreturn status>
  </cffunction>



  <cffunction name="getCounterSummary" output="false">
    <cfset var failCount = _exampleCount - _passCount - _pendCount>
    <cfset var summary = "#_exampleCount# example">
    <cfif _exampleCount neq 1>
      <cfset summary = summary & "s">
    </cfif>
    <cfset summary = summary & ", #failCount# failure">
    <cfif failCount neq 1>
      <cfset summary = summary & "s">
    </cfif>
    <cfset summary = summary & ", #_pendCount# pending">
    <cfreturn summary>
  </cffunction>



  <cffunction name="getTimerSummary" output="false">
    <cfreturn ((getTickCount() - _startTime) / 1000) & " seconds">
  </cffunction>



</cfcomponent>
