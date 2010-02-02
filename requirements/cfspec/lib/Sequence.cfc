<cfcomponent output="false">



  <cffunction name="init" output="false">
    <cfargument name="name" default="(sequence)">
    <cfset _name = name>
    <cfset _expectations = arrayNew(1)>
    <cfset _expectationsIds = arrayNew(1)>
    <cfset _expectationsIndex = 1>
    <cfset _callCount = 0>
    <cfset _failureMessages = arrayNew(1)>
    <cfreturn this>
  </cffunction>



  <cffunction name="addExpectation" output="false">
    <cfargument name="expectation">
    <cfset var system = createObject("java", "java.lang.System")>
    <cfset arrayAppend(_expectations, expectation)>
    <cfset arrayAppend(_expectationsIds, system.identityHashCode(expectation))>
  </cffunction>



  <cffunction name="called" output="false">
    <cfargument name="expectation">
    <cfset var system = createObject("java", "java.lang.System")>
    <cfset var next = "">
    <cfif arrayLen(_expectations) gt 0>
      <cfset next = _expectations[1]>
      <cfif system.identityHashCode(next) eq system.identityHashCode(expectation)>
        <cfset _callCount = _callCount + 1>
        <cfif next.getMaxCallCount() eq _callCount>
          <cfset arrayDeleteAt(_expectations, 1)>
          <cfset _expectationsIndex = _expectationsIndex + 1>
          <cfset _callCount = 0>
        </cfif>
      <cfelseif next.getMinCallCount() le _callCount>
        <cfset arrayDeleteAt(_expectations, 1)>
        <cfset _expectationsIndex = _expectationsIndex + 1>
        <cfset _callCount = 0>
        <cfreturn called(expectation)>
      <cfelse>
        <cfset arrayAppend(_failureMessages, "#_name#: expected #next.getMockName()#.#next.asString()#,"
                                           & " got #expectation.getMockName()#.#expectation.asString()#.")>
      </cfif>
    </cfif>
  </cffunction>



  <cffunction name="asString" output="false">
    <cfargument name="expectations">
    <cfset var system = createObject("java", "java.lang.System")>
    <cfset var thisId = system.identityHashCode(expectations)>
    <cfset var i = "">
    <cfloop index="i" from="1" to="#arrayLen(_expectationsIds)#">
      <cfif thisId eq _expectationsIds[i]>
        <cfreturn _name & ":" & i>
      </cfif>
    </cfloop>
    <cfreturn _name & ":???">
  </cffunction>



  <cffunction name="isPossible" output="false">
    <cfargument name="expectations">
    <cfset var system = createObject("java", "java.lang.System")>
    <cfset var thisId = system.identityHashCode(expectations)>
    <cfset var i = "">
    <cfloop index="i" from="1" to="#arrayLen(_expectationsIds)#">
      <cfif thisId eq _expectationsIds[i]>
        <cfreturn i ge _expectationsIndex>
      </cfif>
    </cfloop>
    <cfreturn true>
  </cffunction>



  <cffunction name="__cfspecGetFailureMessages" output="false">
    <cfreturn _failureMessages>
  </cffunction>



</cfcomponent>
