<cfcomponent output="false">



  <cffunction name="init" output="false">
    <cfargument name="stateMachine">
    <cfargument name="testState">
    <cfset _stateMachine = stateMachine>
    <cfset _testState = testState>
    <cfreturn this>
  </cffunction>



  <cffunction name="isActive" output="false">
    <cfset var state = _stateMachine.getState()>
    <cfreturn compare(state, _testState) eq 0>
  </cffunction>



  <cffunction name="asString" output="false">
    <cfreturn _stateMachine.getName() & "=" & _testState>
  </cffunction>



</cfcomponent>
