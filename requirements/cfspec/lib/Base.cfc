<!---
  Base holds convenience methods that are available to certain objects, such as matchers.
--->
<cfcomponent output="false">



  <cffunction name="hasMethod" output="false">
    <cfargument name="obj">
    <cfargument name="methodName">
    <cfset var metaData = getMetaData(obj)>
    <cfset var funcs = "">
    <cfset var func = "">

    <cfloop condition="structKeyExists(metaData, 'extends')">
      <cfif isDefined("metaData.functions")>
        <cfset funcs = metaData.functions>
        <cfloop array="#funcs#" index="func">
          <cfif func.name eq methodName>
            <cfreturn true>
          </cfif>
        </cfloop>
      </cfif>
      <cfset metaData = metaData.extends>
    </cfloop>

    <cfreturn false>
  </cffunction>



</cfcomponent>
