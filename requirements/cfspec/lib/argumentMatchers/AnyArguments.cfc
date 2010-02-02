<cfcomponent output="false" extends="cfspec.lib.ArgumentMatcher">



  <cffunction name="isMatch" output="false">
    <cfargument name="args">
    <cfset structClear(args)>
    <cfreturn true>
  </cffunction>



  <cffunction name="inspect" output="false">
    <cfreturn "anyArguments()">
  </cffunction>



</cfcomponent>
