<!---
  ArgumentMatcher is responsible for checking arguments signatures passed
  into a stub or mock.  This default implementation matches anything.
--->
<cfcomponent output="false">



  <cffunction name="init" output="false">
    <cfset _equalMatcher = createObject("component", "cfspec.lib.matchers.Equal").init("", "")>
    <cfreturn this>
  </cffunction>



  <cffunction name="setArguments" output="false">
    <cfargument name="args">
    <cfset _args = args>
  </cffunction>



  <cffunction name="isMatch" output="false">
    <cfargument name="args">
    <cfset var key = "">
    <cfset var argsLeft = "">
    <cfset var argKey = "">
    <cfset var arg = "">
    <cfif structIsEmpty(_args)>
      <cfreturn structIsEmpty(args)>
    </cfif>
    <cfset argsLeft = duplicate(args)>
    <cfif structIsEmpty(argsLeft)>
      <cfset argKey = "">
      <cfset arg = "">
    <cfelse>
      <cfset argKey = listFirst(listSort(structKeyList(argsLeft), "textnocase"))>
      <cfset arg = argsLeft[argKey]>
    </cfif>
    <cfloop list="#listSort(structKeyList(_args), "textnocase")#" index="key">
      <cfif isArgMatch(_args[key], argsLeft, arg)>
        <cfset structDelete(argsLeft, argKey)>
        <cfif structIsEmpty(argsLeft)>
          <cfset argKey = "">
          <cfset arg = "">
        <cfelse>
          <cfset argKey = listFirst(listSort(structKeyList(argsLeft), "textnocase"))>
          <cfset arg = argsLeft[argKey]>
        </cfif>
      <cfelse>
        <cfreturn false>
      </cfif>
    </cfloop>
    <cfreturn structIsEmpty(argsLeft)>
  </cffunction>



  <cffunction name="asString" output="false">
    <cfreturn _equalMatcher.inspect(_args)>
  </cffunction>



  <!--- PRIVATE --->



  <cffunction name="isArgMatch" access="private" output="false">
    <cfargument name="matcher">
    <cfargument name="args">
    <cfargument name="arg">
    <cfif isInstanceOf(matcher, "cfspec.lib.ArgumentMatcher")>
      <cfreturn matcher.isMatch(args)>
    <cfelse>
      <cfset _equalMatcher.setArguments(matcher)>
      <cfreturn _equalMatcher.isMatch(arg)>
    </cfif>
  </cffunction>



</cfcomponent>
