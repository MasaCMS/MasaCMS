<cfcomponent output="false" extends="cfspec.lib.ArgumentMatcher">



  <cffunction name="isMatch" output="false">
    <cfargument name="args">
    <cfset var arg = "">
    <cfset var key = "">
    <cfset var i = "">
    <cfif structIsEmpty(args)>
      <cfreturn false>
    </cfif>
    <cfset key = listFirst(listSort(structKeyList(args), "textnocase"))>
    <cfset arg = args[key]>
    <cfif isDate(arg)>
      <cfset structDelete(args, key)>
      <cfreturn true>
    </cfif>
    <cfreturn false>
  </cffunction>



  <cffunction name="inspect" output="false">
    <cfreturn "anyDate()">
  </cffunction>



</cfcomponent>
