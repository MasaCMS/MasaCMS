<!---
  EvalContext is used to evaluate expressions within a specific binding context. To the extent
  possible, it is a clean environment where no other variables or methods can interfere.
--->
<cfcomponent output="false">



  <cffunction name="__cfspecEval" output="false">
    <cfargument name="__cfspecEvalBindings">
    <cfargument name="__cfspecEvalExpression">
    <cfset var __cfspecEvalResult = "">
    <cfset var __cfspecKey = "">

    <cfset structAppend(variables, __cfspecEvalBindings)>
    <cfset __cfspecEvalResult = evaluate(__cfspecEvalExpression)>
    <cfloop collection="#variables#" item="__cfspecKey">
      <cfif __cfspecKey neq "this" and findNoCase("__cfspec", __cfspecKey) neq 1>
        <cfset __cfspecEvalBindings[__cfspecKey] = variables[__cfspecKey]>
      </cfif>
    </cfloop>

    <cfreturn iif(isDefined("__cfspecEvalResult"), "__cfspecEvalResult", "false")>
  </cffunction>



</cfcomponent>
