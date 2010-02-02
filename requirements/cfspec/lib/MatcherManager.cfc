<cfcomponent output="false">



  <cffunction name="init" output="false">
    <cffile action="read" file="#expandPath('/cfspec/config/matchers.json')#" variable="_matchers">
    <cfset _matchers = deserializeJson(_matchers)>
    <cfset _simpleMatchers = structNew()>
    <cfreturn this>
  </cffunction>



  <cffunction name="registerMatcher" output="false">
    <cfargument name="pattern">
    <cfargument name="type">
    <cfset var matcher = arrayNew(1)>
    <cfset arrayAppend(matcher, pattern)>
    <cfset arrayAppend(matcher, type)>
    <cfset arrayPrepend(_matchers, matcher)>
  </cffunction>



  <cffunction name="getMatchers" output="false">
    <cfreturn _matchers>
  </cffunction>



  <cffunction name="simpleMatcher" output="false">
    <cfargument name="pattern">
    <cfargument name="expression">
    <cfset var matcher = arrayNew(1)>
    <cfset arrayAppend(matcher, "(#pattern#)")>
    <cfset arrayAppend(matcher, "cfspec.lib.matchers.Simple")>
    <cfset arrayPrepend(_matchers, matcher)>
    <cfset _simpleMatchers[pattern] = expression>
  </cffunction>



  <cffunction name="getSimpleMatcherExpression" output="false">
    <cfargument name="pattern">
    <cfreturn _simpleMatchers[pattern]>
  </cffunction>



</cfcomponent>
