<!---
  EvalExpectations acts like Expectations but it wraps an expression which is evaluated within
  the matcher. This allows the matcher to evaluate it one or more times in order to determine
  if the expectation is met.
--->
<cfcomponent extends="Expectations" output="false">



  <cffunction name="eval">
    <cfargument name="expression">
    <cfset var context = createObject("component", "EvalContext")>
    <cfset var bindings = _runner.getBindings(true)>
    <cfset var result = context.__cfspecEval(bindings, expression)>
    <cfset _runner.setBindings(bindings)>
    <cfreturn result>
  </cffunction>



</cfcomponent>
