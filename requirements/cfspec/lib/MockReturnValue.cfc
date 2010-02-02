<!---
  This holds a return value that a mock will supply in its execution chain.
--->
<cfcomponent output="false">



  <cffunction name="init" output="false">
    <cfargument name="value">
    <cfset _value = value>
    <cfreturn this>
  </cffunction>



  <cffunction name="eval" output="false">
    <cfreturn _value>
  </cffunction>



</cfcomponent>
