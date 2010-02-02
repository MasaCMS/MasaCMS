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
    <cfloop index="i" from="1" to="#arrayLen(_args)#">
      <cfif isArgMatch(_args[i], args, arg)>
        <cfset structDelete(args, key)>
        <cfreturn true>
      </cfif>
    </cfloop>
    <cfreturn false>
  </cffunction>



  <cffunction name="inspect" output="false">
    <cfreturn "anyOf(" & _equalMatcher.inspect(_args) & ")">
  </cffunction>



</cfcomponent>
