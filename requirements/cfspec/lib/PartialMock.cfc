<!---
  PartialMock object.  Used to inject methods into an underlying object.
--->
<cfcomponent extends="Mock" output="false">



  <cffunction name="init" output="false">
    <cfargument name="obj">
    <cfset var name = listLast(getMetaData(obj).name, ".")>
    <cfset _obj = obj>
    <cfset obj.__cfspecPartialMock = this>
    <cfif isDefined("obj.onMissingMethod")>
      <cfset obj.__cfspecOriginalOnMissingMethod = obj.onMissingMethod>
    </cfif>
    <cfset obj.onMissingMethod = __cfspecOnMissingMethod>
    <cfreturn __cfspecInit(name)>
  </cffunction>



  <cffunction name="stubs" output="false">
    <cfargument name="method">
    <cfset structDelete(_obj, method)>
    <cfreturn super.stubs(method)>
  </cffunction>



  <cffunction name="__cfspecOnMissingMethod" output="false">
    <cfargument name="missingMethodName">
    <cfargument name="missingMethodArguments">
    <cfreturn this.__cfspecPartialMock.onMissingMethod(missingMethodName, missingMethodArguments)>
  </cffunction>



</cfcomponent>
