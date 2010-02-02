<!---
  BeSame expects the exact same object (not just one that is equal).
--->
<cfcomponent extends="cfspec.lib.Matcher" output="false">



  <cffunction name="setArguments">
    <cfset requireArgs(arguments, 1)>
    <cfset _expected = arguments[1]>
  </cffunction>



  <cffunction name="isMatch">
    <cfargument name="target">
    <cfset var system = createObject("java", "java.lang.System")>
    <cfreturn system.identityHashCode(target) eq system.identityHashCode(_expected)>
  </cffunction>



  <cffunction name="getFailureMessage">
    <cfreturn "expected to be the same, got different (native arrays are always different)">
  </cffunction>



  <cffunction name="getNegativeFailureMessage">
    <cfreturn "expected not to be different, got the same (equivalent simple values are usually the same)">
  </cffunction>



  <cffunction name="getDescription">
    <cfreturn "be the same">
  </cffunction>



</cfcomponent>
