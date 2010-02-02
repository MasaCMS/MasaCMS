<!---
  Throw expects the target to throw an exception of the given type with message and detail that
  match the given regexps (optional).  Note that the negated matcher will still throw any
  non-matching exceptions.  For example:

    obj.nonExistantMethod().shouldNotThrow("Application")
      will fail because it does throw an Application exception but

    obj.nonExistantMethod().shouldNotThrow("SomethingElse")
      will pass AND THROW AN APPLICATION EXCEPTION

    obj.nonExistantMethod().shouldNotThrow("SomethingElse").shouldThrow()
      will pass verifying that SomethingElse was not thrown, but not complaining about the 
      Application exception that was thrown
--->
<cfcomponent extends="cfspec.lib.Matcher" output="false">



  <cfset _type = "Any">



  <cffunction name="setArguments">
    <cfset requireArgs(arguments, 3, "at most")>

    <cfif arrayLen(arguments) ge 1>
      <cfset _type = arguments[1]>
      <cfset verifyArg(isSimpleValue(_type), "type", "must be a simple value")>
    </cfif>

    <cfif arrayLen(arguments) ge 2>
      <cfset _message = arguments[2]>
      <cfset verifyArg(isSimpleValue(_message), "message", "must be a valid regular expression")>
    </cfif>

    <cfif arrayLen(arguments) ge 3>
      <cfset _detail = arguments[3]>
      <cfset verifyArg(isSimpleValue(_detail), "detail", "must be a valid regular expression")>
    </cfif>
  </cffunction>



  <cffunction name="isMatch">
    <cfargument name="target">
    <cfif isInstanceOf(_expectations, "cfspec.lib.EvalExpectations")>
      <cfset tryEval(target)>
    </cfif>

    <cfset _exception = _runner.getPendingException()>
    <cfif isSimpleValue(_exception)>
      <cfreturn false>
    </cfif>

    <cfif not isMatchException()>
      <cfif not _expectations.__cfspecIsNegated()>
        <cfset _runner.clearPendingException()>
      </cfif>
      <cfreturn false>
    </cfif>

    <cfset _runner.clearPendingException()>
    <cfreturn true>
  </cffunction>



  <cffunction name="isMatchException">
    <cfif isDefined("_type") and not isMatchType(_exception.type, _type)>
      <cfreturn false>
    </cfif>
    <cfif isDefined("_message") and not findNoCase(_message, _exception.message) and not reFindNoCase(_message, _exception.message)>
      <cfreturn false>
    </cfif>
    <cfif isDefined("_detail") and not findNoCase(_detail, _exception.detail) and not reFindNoCase(_detail, _exception.detail)>
      <cfreturn false>
    </cfif>
    <cfreturn true>
  </cffunction>



  <cffunction name="isMatchType">
    <cfargument name="target">
    <cfargument name="expected">
    <cfset var pos = "">
    <cfif expected eq "Any">
      <cfreturn true>
    </cfif>
    <cfset pos = findNoCase(expected, target)>
    <cfif pos eq 1 and (len(expected) eq len(target) or mid(target, len(expected) + 1, 1) eq ".")>
      <cfreturn true>
    </cfif>
    <cfreturn false>
  </cffunction>



  <cffunction name="getFailureMessage">
    <cfset var actual = "no exception">
    <cfif not isSimpleValue(_exception)>
      <cfset actual = inspectException(_exception)>
    </cfif>
    <cfreturn "expected to #getDescription()#, got #actual#">
  </cffunction>



  <cffunction name="getNegativeFailureMessage">
    <cfset var actual = "no exception">
    <cfif not isSimpleValue(_exception)>
      <cfset actual = inspectException(_exception)>
    </cfif>
    <cfreturn "expected not to #getDescription()#, got #actual#">
  </cffunction>



  <cffunction name="getDescription">
    <cfset var description = "throw #_type#">
    <cfset var params = "">
    <cfif isDefined("_message")>
      <cfset params = listAppend(params, "message=" & inspect(_message))>
    </cfif>
    <cfif isDefined("_detail")>
      <cfset params = listAppend(params, "detail=" & inspect(_detail))>
    </cfif>
    <cfif params neq "">
      <cfset description = description & " (#params#)">
    </cfif>
    <cfreturn description>
  </cffunction>



  <cffunction name="inspectException">
    <cfargument name="e">
    <cfset var description = "">
    <cfset var params = "">
    <cfif isDefined("e.type")>
      <cfset description = e.type>
    </cfif>
    <cfif isDefined("e.message")>
      <cfset params = listAppend(params, "message=" & inspect(e.message))>
    </cfif>
    <cfif isDefined("e.detail")>
      <cfset params = listAppend(params, "detail=" & inspect(e.detail))>
    </cfif>
    <cfif params neq "">
      <cfset description = description & " (#params#)">
    </cfif>
    <cfreturn description>
  </cffunction>



  <cffunction name="tryEval">
    <cfargument name="target">
    <cfset var result = "">
    <cftry>
      <cfset result = _expectations.eval(target)>
      <cfcatch type="any">
        <cfset _runner.setPendingException(cfcatch)>
      </cfcatch>
    </cftry>
  </cffunction>



</cfcomponent>
