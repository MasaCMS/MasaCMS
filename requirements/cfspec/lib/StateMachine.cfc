<cfcomponent output="false">



  <cffunction name="init" output="false">
    <cfargument name="name" default="(state machine)">
    <cfset _name = name>
    <cfset _state = "">
    <cfreturn this>
  </cffunction>



  <cffunction name="getName" output="false">
    <cfreturn _name>
  </cffunction>



  <cffunction name="getState" output="false">
    <cfreturn _state>
  </cffunction>



  <cffunction name="setState" output="false">
    <cfargument name="state">
    <cfset _state = state>
  </cffunction>



  <cffunction name="startsAs" output="false">
    <cfargument name="state">
    <cfset setState(state)>
    <cfreturn this>
  </cffunction>



  <cffunction name="is" output="false">
    <cfargument name="state">
    <cfreturn createObject("component", "cfspec.lib.StateMachineCondition").init(this, state)>
  </cffunction>



  <cffunction name="becomes" output="false">
    <cfargument name="state">
    <cfreturn createObject("component", "cfspec.lib.StateMachineTransition").init(this, state)>
  </cffunction>



</cfcomponent>
