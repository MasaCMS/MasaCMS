<!---
  RespondTo expectes the target object to have methods defined with the given names
  (not using onMissingMethod). Parents of the target object may also have the methods.
--->
<cfcomponent extends="cfspec.lib.Matcher" output="false">


  <cffunction name="setArguments">
    <cfset var i = "">
    <cfset requireArgs(arguments, 1, "at least")>
    <cfset _methodNames = arrayNew(1)>
    <cfloop index="i" from="1" to="#arrayLen(arguments)#">
      <cfset arrayAppend(_methodNames, arguments[i])>
      <cfset verifyArg(isSimpleValue(_methodNames[i]), "methodName (## #i#)", "must be a simple value")>
    </cfloop>
  </cffunction>



  <cffunction name="isMatch">
    <cfargument name="target">

    <cfif not isObject(target)>
      <cfset _runner.fail("RespondTo expected an object, got #inspect(target)#")>
    </cfif>

    <cfloop index="i" from="1" to="#arrayLen(_methodNames)#">
      <cfset _methodName = _methodNames[i]>
      <cfif not hasMethod(target, _methodName)>
        <cfreturn false>
      </cfif>
    </cfloop>

    <cfreturn true>
  </cffunction>



  <cffunction name="getFailureMessage">
    <cfreturn "expected to respond to #inspect(_methodName)#, but the method was not found">
  </cffunction>



  <cffunction name="getNegativeFailureMessage">
    <cfreturn "expected not to respond to #inspect(_methodName)#, but the method was found">
  </cffunction>



  <cffunction name="getDescription">
    <cfreturn "respond to #prettyPrint(_methodNames)#">
  </cffunction>



</cfcomponent>
