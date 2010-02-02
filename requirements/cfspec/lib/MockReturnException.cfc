<!---
  This holds an exception that will be thrown within a mocks execution chain.
--->
<cfcomponent output="false">



  <cffunction name="init" output="false">
    <cfargument name="type">
    <cfargument name="message">
    <cfargument name="detail">
    <cfset _type = type>
    <cfset _message = message>
    <cfset _detail = detail>
    <cfreturn this>
  </cffunction>



  <cffunction name="eval" output="false">
    <cfthrow type="#_type#" message="#_message#" detail="#_detail#">
  </cffunction>



</cfcomponent>
