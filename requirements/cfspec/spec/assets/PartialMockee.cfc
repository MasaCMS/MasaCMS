<cfcomponent output="false">

  <cffunction name="getName">
    <cfreturn "My Name">
  </cffunction>

  <cffunction name="onMissingMethod">
    <cfargument name="methodName">
    <cfargument name="methodArguments">
    <cfreturn "You called #methodName#!">
  </cffunction>

</cfcomponent>
