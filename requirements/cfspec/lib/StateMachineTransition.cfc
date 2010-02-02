<cfcomponent output="false">



  <cffunction name="init" output="false">
    <cfargument name="stateMachine">
    <cfargument name="nextState">
    <cfset _stateMachine = stateMachine>
    <cfset _nextState = nextState>
    <cfreturn this>
  </cffunction>



  <cffunction name="run" output="false">
    <cfset _stateMachine.setState(_nextState)>
  </cffunction>



</cfcomponent>
