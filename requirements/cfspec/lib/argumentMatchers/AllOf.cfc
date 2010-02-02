<cfcomponent output="false" extends="cfspec.lib.ArgumentMatcher">



  <cffunction name="isMatch" output="false">
    <cfargument name="args">
    <cfset var finalArgs = "">
    <cfset var arg = "">
    <cfset var key = "">
    <cfset var i = "">
    <cfif structIsEmpty(args)>
      <cfreturn false>
    </cfif>
    <cfset key = listFirst(listSort(structKeyList(args), "textnocase"))>
    <cfset arg = args[key]>
    <cfloop index="i" from="1" to="#arrayLen(_args)#">
      <cfset finalArgs = structCopy(args)>
      <cfif not isArgMatch(_args[i], finalArgs, arg)>
        <cfreturn false>
      </cfif>
    </cfloop>
    <cfset structClear(args)>
    <cfset structAppend(args, finalArgs)>
    <cfreturn true>
  </cffunction>



  <cffunction name="inspect" output="false">
    <cfreturn "allOf(" & _equalMatcher.inspect(_args) & ")">
  </cffunction>



</cfcomponent>
