<cfcomponent output="false" extends="cfspec.lib.ArgumentMatcher">



  <cffunction name="isMatch" output="false">
    <cfargument name="args">
    <cfset var key = "">
    <cfif structIsEmpty(args)>
      <cfreturn false>
    </cfif>
    <cfset key = listFirst(listSort(structKeyList(args), "textnocase"))>
    <cfset structDelete(args, key)>
    <cfreturn true>
  </cffunction>



  <cffunction name="inspect" output="false">
    <cfreturn "anything()">
  </cffunction>



</cfcomponent>
