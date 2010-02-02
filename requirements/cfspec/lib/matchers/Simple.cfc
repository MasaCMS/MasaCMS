<!--- 
  SimpleMatcher allows the quick setup of a custom matcher using syntax like:
    simpleMatcher(pattern, booleanExpression)

  For example:
    simpleMatcher("BeEven", "target mod 2 eq 0")
      allows
    $(42).shouldBeEven()
--->
<cfcomponent extends="cfspec.lib.Matcher" output="false">



  <cffunction name="init">
    <cfargument name="pattern">
    <cfset _matcherName = "Simple">
    <cfset _pattern = pattern>
    <cfset _args = structNew()>
    <cfreturn this>
  </cffunction>



  <cffunction name="setArguments">
    <cfset _args = arguments>
  </cffunction>



  <cffunction name="isMatch">
    <cfargument name="target">
    <cfset var matchers = request.singletons.getMatcherManager()>
    <cfset var expression = matchers.getSimpleMatcherExpression(_pattern)>
    <cfset var context = createObject("component", "cfspec.lib.EvalContext")>
    <cfset var bindings = structNew()>
    <cfset var result = "">

    <cfset bindings.target = target>
    <cfset bindings.args = _args>

    <cfset result = context.__cfspecEval(bindings, expression)>
    <cfif not isDefined("result")>
      <cfset result = false>
    </cfif>

    <cfreturn result>
  </cffunction>



  <cffunction name="getFailureMessage">
    <cfreturn "expected to #_pattern#, failed">
  </cffunction>



  <cffunction name="getNegativeFailureMessage">
    <cfreturn "expected not to #_pattern#, failed">
  </cffunction>



  <cffunction name="getDescription">
    <cfreturn _pattern>
  </cffunction>



</cfcomponent>
