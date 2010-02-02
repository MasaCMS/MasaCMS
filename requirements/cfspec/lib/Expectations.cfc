<!---
  Expectations wrap an object or expression.  It provides a hook for matchers via the 'should' or
  'shouldNot' method prefixes.  Since everything else is passed through to the underlying object,
  the public method namespace should be kept very clean.
--->
<cfcomponent output="false">



  <cffunction name="__cfspecInit">
    <cfargument name="runner">
    <cfargument name="target">

    <cfset _runner = runner>
    <cfset _target = target>
    <cfset _matchers = request.singletons.getMatcherManager().getMatchers()>

    <cfreturn this>
  </cffunction>



  <cffunction name="stubs">
    <cfargument name="method">
    <cfif not isDefined("_target.__cfspecPartialMock")>
      <cfset createObject("component", "cfspec.lib.PartialMock").init(_target)>
    </cfif>
    <cfreturn _target.__cfspecPartialMock.stubs(method)>
  </cffunction>



  <cffunction name="__cfspecEvalMatcher">
    <cfargument name="matcher">
    <cfset var result = "">

    <cfif matcher.isDelayed()>
      <cfreturn matcher>
    </cfif>

    <cfset result = matcher.isMatch(_target)>
    <cfif result eqv _negated>
      <cfif _negated>
        <cfreturn _runner.fail(matcher.getNegativeFailureMessage())>
      <cfelse>
        <cfreturn _runner.fail(matcher.getFailureMessage())>
      </cfif>
    </cfif>

    <cfif matcher.isChained()>
      <cfreturn matcher>
    </cfif>

    <cfreturn this>
  </cffunction>



  <cffunction name="__cfspecIsNegated">
    <cfreturn _negated>
  </cffunction>



  <cffunction name="onMissingMethod">
    <cfargument name="missingMethodName">
    <cfargument name="missingMethodArguments">

    <cfif not listFindNoCase("shouldThrow,shouldNotThrow", missingMethodName)>
      <cfset _runner.ensureNoExceptionsArePending()>
    </cfif>
    <cfset _runner.ensureNoDelayedMatchersArePending()>

    <cfset matcher = findMatcher(missingMethodName)>
    <cfif isObject(matcher)>
      <cfset _runner.flagExpectationEncountered()>
      <cfset matcher.setRunner(_runner)>
      <cfset matcher.setExpectations(this)>
      <cfset evaluate("matcher.setArguments(#flatArgs(missingMethodArguments)#)")>
      <cfreturn __cfspecEvalMatcher(matcher)>
    </cfif>

    <cfif isObject(_target)>
      <cfreturn passItOn(missingMethodName, missingMethodArguments)>
    </cfif>

    <cfthrow message="The method #missingMethodName# was not found.">
  </cffunction>



  <cffunction name="findMatcher" access="private">
    <cfargument name="methodName">
    <cfset var matchData = "">
    <cfset var matcher = "">
    <cfset var i = "">

    <cfloop index="i" from="1" to="#arrayLen(_matchers)#">
      <cfset matchData = reFindNoCase("^should(Not)?#_matchers[i][1]#$", methodName, 1, true)>
      <cfif matchData.len[1]>
        <cfset matcher = createObject("component", _matchers[i][2])>
        <cfset _negated = matchData.len[2] gt 0>
        <cfset evaluate("matcher.init(#flatArgsFromMatchData(methodName, matchData)#)")>
        <cfreturn matcher>
      </cfif>
    </cfloop>

    <cfreturn false>
  </cffunction>



  <cffunction name="passItOn" access="private">
    <cfargument name="methodName">
    <cfargument name="args">
    <cfset var result = "">

    <cftry>
      <cfset result = evaluate("_target.#methodName#(#flatArgs(args)#)")>
      <cfcatch type="any" >
        <cfset _runner.setPendingException(cfcatch)>
        <cfreturn createObject("component", "Expectations").__cfspecInit(_runner, this)>
      </cfcatch>
    </cftry>

    <cfif not isDefined("result")>
      <cfset result = false>
    </cfif>

    <cfreturn createObject("component", "Expectations").__cfspecInit(_runner, result)>
  </cffunction>



  <cffunction name="flatArgs" access="private">
    <cfargument name="args">

    <cfif arrayLen(args) eq 0>
      <cfreturn "">
    </cfif>

    <cfif listFind(structKeyList(args), "1")>
      <cfreturn flatArgsFromArray(args)>
    <cfelse>
      <cfreturn flatArgsFromStruct(args)>
    </cfif>
  </cffunction>



  <cffunction name="flatArgsFromArray" access="private">
    <cfargument name="args">
    <cfset var flatArgs = "">
    <cfset var i = "">

    <cfset _args = arrayNew(1)>
    <cfloop index="i" from="1" to="#arrayLen(args)#">
      <cfset arrayAppend(_args, args[i])>
      <cfset flatArgs = listAppend(flatArgs, "_args[#i#]")>
    </cfloop>

    <cfreturn flatArgs>
  </cffunction>



  <cffunction name="flatArgsFromStruct" access="private">
    <cfargument name="args">
    <cfset var flatArgs = "">
    <cfset var key = "">

    <cfset _args = structNew()>
    <cfloop item="key" collection="#args#">
      <cfset _args[key] = args[key]>
      <cfset flatArgs = listAppend(flatArgs, "#key#=_args.#key#")>
    </cfloop>

    <cfreturn flatArgs>
  </cffunction>



  <cffunction name="flatArgsFromMatchData" access="private">
    <cfargument name="string">
    <cfargument name="matchData">
    <cfset var flatArgs = "">
    <cfset var i = "">

    <cfset _args = arrayNew(1)>
    <cfloop index="i" from="3" to="#arrayLen(matchData.len)#">
      <cfif matchData.len[i]>
        <cfset arrayAppend(_args, mid(string, matchData.pos[i], matchData.len[i]))>
      <cfelse>
        <cfset arrayAppend(_args, "")>
      </cfif>
      <cfset flatArgs = listAppend(flatArgs, "_args[#(i-2)#]")>
    </cfloop>

    <cfreturn flatArgs>
  </cffunction>



  <cffunction name="value" output="false">
    <cfreturn _target>
  </cffunction>


</cfcomponent>
