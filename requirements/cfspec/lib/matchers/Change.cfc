<!---
  Change expects the evaluated statement to cause the specified changes.
--->
<cfcomponent extends="cfspec.lib.Matcher" output="false">



  <cffunction name="init">
    <cfargument name="noCase">
    <cfset _matcherName = "Change">
    <cfset _noCase = len(noCase) gt 0>
    <cfreturn this>
  </cffunction>



  <cffunction name="setArguments">
    <cfset var i = "">
    <cfset requireArgs(arguments, 1, "at least")>
    <cfset _isMultiple = arrayLen(arguments) gt 1>
    <cfset _changee = arrayNew(1)>
    <cfloop index="i" from="1" to="#arrayLen(arguments)#">
      <cfset arrayAppend(_changee, arguments[i])>
    </cfloop>
  </cffunction>



  <cffunction name="isMatch">
    <cfargument name="target">
    <cfset var eqMatcher = createObject("component", "cfspec.lib.matchers.Equal").init("", iif(_noCase, de("NoCase"), de("")))>
    <cfset var before = arrayNew(1)>
    <cfset var i = "">
    <cfloop index="i" from="1" to="#arrayLen(_changee)#">
      <cfset before[i] = _expectations.eval(_changee[i])>
    </cfloop>
    <cfset _expectations.eval(target)>
    <cfloop index="i" from="1" to="#arrayLen(_changee)#">
      <cfset _before = before[i]>
      <cfset _after = _expectations.eval(_changee[i])>
      <cfset eqMatcher.setArguments(_before)>
      <cfif eqMatcher.isMatch(_after)>
        <cfreturn false>
      </cfif>
    </cfloop>
    <cfreturn true>
  </cffunction>



  <cffunction name="getFailureMessage">
    <cfreturn "expected to change #prettyPrint(_changee)#, got unchanged">
  </cffunction>



  <cffunction name="getNegativeFailureMessage">
    <cfreturn "expected not to change #prettyPrint(_changee)#, got changed">
  </cffunction>



  <cffunction name="getDescription">
    <cfreturn "change #prettyPrint(_changee)#">
  </cffunction>



  <cffunction name="isChained">
    <cfreturn not (_expectations.__cfspecIsNegated() or _isMultiple)>
  </cffunction>



  <cffunction name="by">
    <cfargument name="delta">
    <cfset var difference = getDifferenceAndScreenParams("", delta)>
    <cfif difference neq delta>
      <cfthrow type="cfspec.fail" message="expected to change #prettyPrint(_changee)# by #inspect(delta)#, got #inspect(difference)#">
    </cfif>
    <cfreturn this>
  </cffunction>



  <cffunction name="byAtLeast">
    <cfargument name="delta">
    <cfset var difference = getDifferenceAndScreenParams("AtLeast", delta)>
    <cfif difference lt delta>
      <cfthrow type="cfspec.fail" message="expected to change #prettyPrint(_changee)# by at least #inspect(delta)#, got #inspect(difference)#">
    </cfif>
    <cfreturn this>
  </cffunction>



  <cffunction name="byAtMost">
    <cfargument name="delta">
    <cfset var difference = getDifferenceAndScreenParams("AtMost", delta)>
    <cfif difference gt delta>
      <cfthrow type="cfspec.fail" message="expected to change #prettyPrint(_changee)# by at most #inspect(delta)#, got #inspect(difference)#">
    </cfif>
    <cfreturn this>
  </cffunction>



  <cffunction name="from">
    <cfargument name="before">
    <cfset var eqMatcher = createObject("component", "cfspec.lib.matchers.Equal").init("", iif(_noCase, de("NoCase"), de("")))>
    <cfset var pass = "">
    <cfset eqMatcher.setArguments(before)>
    <cfset pass = eqMatcher.isMatch(_before)>
    <cfif not pass>
      <cfthrow type="cfspec.fail" message="expected to change #prettyPrint(_changee)# from #inspect(before)#, was #inspect(_before)#">
    </cfif>
    <cfreturn this>
  </cffunction>



  <cffunction name="to">
    <cfargument name="after">
    <cfset var eqMatcher = createObject("component", "cfspec.lib.matchers.Equal").init("", iif(_noCase, de("NoCase"), de("")))>
    <cfset var pass = "">
    <cfset eqMatcher.setArguments(after)>
    <cfset pass = eqMatcher.isMatch(_after)>
    <cfif not pass>
      <cfthrow type="cfspec.fail" message="expected to change #prettyPrint(_changee)# to #inspect(after)#, got #inspect(_after)#">
    </cfif>
    <cfreturn this>
  </cffunction>



  <cffunction name="getDifferenceAndScreenParams">
    <cfargument name="relativity">
    <cfargument name="delta">
    <cfset verifyArg(isNumeric(delta), "delta", "must be numeric")>
    <cfset verifyArg(isNumeric(_before), "before", "must be numeric")>
    <cfset verifyArg(isNumeric(_after), "after", "must be numeric")>
    <cfreturn _after - _before>
  </cffunction>



</cfcomponent>
