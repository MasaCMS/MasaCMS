<!---
  MockExpectations is responsible for handling the setup and evaluation
  of the expectations that are put onto a mock object.
--->
<cfcomponent output="false">



  <cffunction name="init" output="false">
    <cfargument name="parent" default="">
    <cfargument name="name" default="(missing method)">
    <cfargument name="isExpected" default="false">
    <cfset _parent = parent>
    <cfset _name = name>
    <cfset _callCount = 0>
    <cfset _returns = arrayNew(1)>
    <cfset _sequences = arrayNew(1)>
    <cfif isExpected>
      <cfset once()>
    <cfelse>
      <cfset times(0, -1)>
    </cfif>
    <cfreturn this>
  </cffunction>



  <cffunction name="with" output="false">
    <cfset _argumentMatcher = createObject("component", "cfspec.lib.ArgumentMatcher").init()>
    <cfset _argumentMatcher.setArguments(arguments)>
    <cfreturn this>
  </cffunction>



  <cffunction name="withEval" output="false">
    <cfargument name="expression">
    <cfset _argumentMatcher = createObject("component", "cfspec.lib.ArgumentEvalMatcher").init()>
    <cfset _argumentMatcher.setExpression(expression)>
    <cfreturn this>
  </cffunction>



  <cffunction name="times" output="false">
    <cfargument name="minCount">
    <cfargument name="maxCount" default="#minCount#">
    <cfset _minCount = minCount>
    <cfset _maxCount = maxCount>
    <cfreturn this>
  </cffunction>



  <cffunction name="never" output="false">
    <cfreturn times(0)>
  </cffunction>



  <cffunction name="once" output="false">
    <cfreturn times(1)>
  </cffunction>



  <cffunction name="twice" output="false">
    <cfreturn times(2)>
  </cffunction>



  <cffunction name="atLeast" output="false">
    <cfargument name="minCount">
    <cfreturn times(minCount, -1)>
  </cffunction>



  <cffunction name="atLeastOnce" output="false">
    <cfreturn times(1, -1)>
  </cffunction>



  <cffunction name="atMost" output="false">
    <cfargument name="maxCount">
    <cfreturn times(0, maxCount)>
  </cffunction>



  <cffunction name="atMostOnce" output="false">
    <cfreturn times(0, 1)>
  </cffunction>



  <cffunction name="inSequence" output="false">
    <cfargument name="sequence">
    <cfset arrayAppend(_sequences, sequence)>
    <cfset sequence.addExpectation(this)>
    <cfreturn this>
  </cffunction>



  <cffunction name="when" output="false">
    <cfargument name="condition">
    <cfset _stateMachineCondition = condition>
    <cfreturn this>
  </cffunction>



  <cffunction name="then" output="false">
    <cfargument name="transition">
    <cfset _stateMachineTransition = transition>
    <cfreturn this>
  </cffunction>



  <cffunction name="returns" output="false">
    <cfset var i = "">
    <cfset var entry = "">
    <cfset var intern = this>
    <cfif isObject(_parent)>
      <cfset intern = _parent.__cfspecInternExpectations(_name, this)>
    </cfif>
    <cfreturn intern.__cfspecReturns(arguments)>
  </cffunction>



  <cffunction name="__cfspecReturns" output="false">
    <cfargument name="args">
    <cfset var entry = "">
    <cfset var i = "">
    <cfloop index="i" from="1" to="#arrayLen(args)#">
      <cfset entry = createObject("component", "MockReturnValue").init(args[i])>
      <cfset arrayAppend(_returns, entry)>
    </cfloop>
    <cfreturn this>
  </cffunction>



  <cffunction name="throws" output="false">
    <cfargument name="type">
    <cfargument name="message" default="">
    <cfargument name="detail" default="">
    <cfset var intern = this>
    <cfif isObject(_parent)>
      <cfset intern = _parent.__cfspecInternExpectations(_name, this)>
    </cfif>
    <cfreturn intern.__cfspecThrows(type, message, detail)>
  </cffunction>



  <cffunction name="__cfspecThrows" output="false">
    <cfargument name="type">
    <cfargument name="message" default="">
    <cfargument name="detail" default="">
    <cfset var entry = createObject("component", "MockReturnException").init(type, message, detail)>
    <cfset arrayAppend(_returns, entry)>
    <cfreturn this>
  </cffunction>



  <cffunction name="isActive" output="false">
    <cfargument name="args">
    <cfset var active = true>
    <cfset var i = "">
    <cfif isDefined("_argumentMatcher")>
      <cfset active = _argumentMatcher.isMatch(args)>
    </cfif>
    <cfif active and isDefined("_stateMachineCondition")>
      <cfset active = _stateMachineCondition.isActive()>
    </cfif>
    <cfif active and arrayLen(_sequences)>
      <cfloop index="i" from="1" to="#arrayLen(_sequences)#">
        <cfset active = active and _sequences[i].isPossible(this)>
      </cfloop>
    </cfif>
    <cfreturn active>
  </cffunction>



  <cffunction name="asString" output="false">
    <cfargument name="useSequences" default="true">
    <cfset var s = _name>
    <cfset var i = "">
    <cfif isDefined("_argumentMatcher")>
      <cfset s = s & "(" & _argumentMatcher.asString() & ")">
    <cfelse>
      <cfset s = s & "()">
    </cfif>
    <cfif isDefined("_stateMachineCondition")>
      <cfset s = s & "[" & _stateMachineCondition.asString() & "]">
    </cfif>
    <cfif useSequences and arrayLen(_sequences) gt 0>
      <cfloop index="i" from="1" to="#arrayLen(_sequences)#">
        <cfset s = s & "[" & _sequences[i].asString(this) & "]">
      </cfloop>
    </cfif>
    <cfreturn s>
  </cffunction>



  <cffunction name="isEqualTo" output="false">
    <cfargument name="expectations">
    <cfargument name="useSequences" default="true">
    <cfreturn compare(asString(useSequences), expectations.asString(useSequences)) eq 0>
  </cffunction>



  <cffunction name="incrementCallCount" output="false">
    <cfset var i = "">
    <cfset _callCount = _callCount + 1>
    <cfloop index="i" from="1" to="#arrayLen(_sequences)#">
      <cfset _sequences[i].called(this)>
    </cfloop>
    <cfif isDefined("_stateMachineTransition")>
      <cfset _stateMachineTransition.run()>
    </cfif>
  </cffunction>



  <cffunction name="getMinCallCount" output="false">
    <cfreturn _minCount>
  </cffunction>



  <cffunction name="getMaxCallCount" output="false">
    <cfreturn _maxCount>
  </cffunction>



  <cffunction name="getReturn" output="false">
    <cfset var entry = "">
    <cfif not arrayIsEmpty(_returns)>
      <cfset entry = _returns[1]>
      <cfif arrayLen(_returns) gt 1>
        <cfset arrayDeleteAt(_returns, 1)>
      </cfif>
      <cfreturn entry.eval()>
    </cfif>
    <cfreturn createObject("component", "cfspec.lib.Mock").__cfspecInit()>
  </cffunction>



  <cffunction name="getFailureMessage" output="false">
    <cfset var message = "">
    <cfif (_callCount lt _minCount) or (_maxCount ge 0 and _callCount gt _maxCount)>
      <cfset message = 'expected "#_name#" to be invoked #expectedText()#, but it was #actualText()#.'>
    </cfif>
    <cfreturn message>
  </cffunction>



  <cffunction name="getMockName" output="false">
    <cfif isObject(_parent)>
      <cfreturn _parent.__cfspecGetName()>
    </cfif>
    <cfreturn "(unknown)">
  </cffunction>



  <cffunction name="isInSequence" output="false">
    <cfset var i = "">
    <cfif arrayLen(_sequences) eq 0>
      <cfreturn false>
    </cfif>
    <cfloop index="i" from="1" to="#arrayLen(_sequences)#">
      <cfif not _sequences[i].isPossible(this)>
        <cfreturn false>
      </cfif>
    </cfloop>
    <cfreturn true>
  </cffunction>



  <!--- PRIVATE --->



  <cffunction name="expectedText" access="private" output="false">
    <cfset var expected = "">
    <cfif _minCount eq _maxCount>
      <cfif _minCount eq 0>
        <cfset expected = "never">
      <cfelseif _minCount eq 1>
        <cfset expected = "once">
      <cfelseif _minCount eq 2>
        <cfset expected = "twice">
      <cfelse>
        <cfset expected = "#_minCount# times">
      </cfif>
    <cfelseif _minCount lt _maxCount>
      <cfif _maxCount eq 1>
        <cfset expected = "at most once">
      <cfelseif _minCount eq 0>
        <cfset expected = "at most #_maxCount# times">
      <cfelse>
        <cfset expected = "#_minCount# to #_maxCount# times">
      </cfif>
    <cfelse>
      <cfif _minCount eq 0>
        <cfset expected = "any number of times">
      <cfelseif _minCount eq 1>
        <cfset expected = "at least once">
      <cfelse>
        <cfset expected = "at least #_minCount# times">
      </cfif>
    </cfif>
    <cfreturn expected>
  </cffunction>



  <cffunction name="actualText" access="private" output="false">
    <cfset var actual = "">
    <cfif _callCount eq 0>
      <cfset actual = "never invoked">
    <cfelseif _callCount eq 1>
      <cfset actual = "invoked once">
    <cfelseif _callCount eq 2>
      <cfset actual = "invoked twice">
    <cfelse>
      <cfset actual = "invoked #_callCount# times">
    </cfif>
    <cfreturn actual>
  </cffunction>



</cfcomponent>
