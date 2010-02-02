<!---
  Matcher is the parent class for all other matchers, which takes care of the boilerplate code,
  and provides some utility functions that are useful in a matcher.
--->
<cfcomponent extends="Base" output="false">



  <cffunction name="init" output="false">
    <cfset _matcherName = listLast(getMetaData(this).name, ".")>
    <cfreturn this>
  </cffunction>



  <cffunction name="setRunner" output="false">
    <cfargument name="runner">
    <cfset _runner = runner>
  </cffunction>



  <cffunction name="setExpectations" output="false">
    <cfargument name="expectations">
    <cfset _expectations = expectations>
  </cffunction>



  <cffunction name="setArguments" output="false">
  </cffunction>



  <cffunction name="isDelayed" output="false">
    <cfset _runner.flagDelayedMatcher(false)>
    <cfreturn false>
  </cffunction>



  <cffunction name="isChained" output="false">
    <cfreturn false>
  </cffunction>



  <cffunction name="requireArgs" output="false">
    <cfargument name="args">
    <cfargument name="count">
    <cfargument name="relation" default="">
    <cfset var argCount = arrayLen(args)>
    <cfset var op = "eq">
    <cfif relation eq "at least"><cfset op = "ge"></cfif>
    <cfif relation eq "at most"> <cfset op = "le"></cfif>

    <cfif not evaluate("argCount #op# count")>
      <cfthrow message="The #_matcherName# matcher expected #trim(relation & ' ' & count)# argument(s), got #argCount#.">
    </cfif>
  </cffunction>



  <cffunction name="verifyArg" output="false">
    <cfargument name="verified">
    <cfargument name="argName">
    <cfargument name="message">
    <cfif not verified>
      <cfthrow message="The #uCase(argName)# parameter to the #_matcherName# matcher #message#.">
    </cfif>
  </cffunction>



  <cffunction name="inspect" output="false">
    <cfargument name="value">
    <cfif isSimpleValue(value)>  <cfreturn inspectSimpleValue(value)>  </cfif>
    <cfif isObject(value)>       <cfreturn inspectObject(value)>       </cfif>
    <cfif isStruct(value)>       <cfreturn inspectStruct(value)>       </cfif>
    <cfif isArray(value)>        <cfreturn inspectArray(value)>        </cfif>
    <cfif isQuery(value)>        <cfreturn inspectQuery(value)>        </cfif>
    <cfreturn serializeJson(value)>
  </cffunction>



  <cffunction name="inspectSimpleValue" output="false">
    <cfargument name="value">
    <cfif isNumeric(value)>
      <cfreturn value>
    </cfif>
    <cfif isDate(value)>
      <cfreturn dateFormat(value, "yyyy-mm-dd") & " " & timeFormat(value, "hh:mm tt")>
    </cfif>
    <cfif listFindNoCase("true,false,yes,no", value)>
      <cfreturn iif(value, de("true"), de("false"))>
    </cfif>
    <cfreturn "'" & replace(replace(value, "\", "\\", "all"), "'", "\'", "all") & "'">
  </cffunction>



  <cffunction name="inspectObject" output="false">
    <cfargument name="value">
    <cftry>
      <cfset value = value.inspect()>
      <cfif isSimpleValue(value)>
        <cfreturn value>
      </cfif>
      <cfcatch type="any"></cfcatch>
    </cftry>
    <cfreturn "&lt;#getMetaData(value).name#:???&gt;">
  </cffunction>



  <cffunction name="inspectStruct" output="false">
    <cfargument name="value">
    <cfset var keys = listToArray(listSort(structKeyList(value), "textnocase"))>
    <cfset var s = "">
    <cfset var i = "">
    <cfloop index="i" from="1" to="#arrayLen(keys)#">
      <cfset s = listAppend(s, keys[i] & "=" & inspect(value[keys[i]]))>
    </cfloop>
    <cfreturn "{#s#}">
  </cffunction>



  <cffunction name="inspectArray" output="false">
    <cfargument name="value">
    <cfset var s = "">
    <cfset var i = "">
    <cfloop index="i" from="1" to="#arrayLen(value)#">
      <cfset s = listAppend(s, inspect(value[i]))>
    </cfloop>
    <cfreturn "[#s#]">
  </cffunction>



  <cffunction name="inspectQuery" output="false">
    <cfargument name="value">
    <cfset var keys = listToArray(listSort(value.columnList, "textnocase"))>
    <cfset var cols = "">
    <cfset var data = "">
    <cfset var row = "">
    <cfset var i = "">
    <cfset var j = "">
    <cfloop index="i" from="1" to="#arrayLen(keys)#">
      <cfset cols = listAppend(cols, inspect(keys[i]))>
    </cfloop>
    <cfloop index="i" from="1" to="#value.recordCount#">
      <cfset row = "">
      <cfloop index="j" from="1" to="#arrayLen(keys)#">
        <cfset row = listAppend(row, inspect(value[keys[j]][i]))>
      </cfloop>
      <cfset data = listAppend(data, "[#row#]")>
    </cfloop>
    <cfreturn "{COLUMNS=[#cols#],DATA=[#data#]}">
  </cffunction>



  <cffunction name="prettyPrint" output="false">
    <cfargument name="value">
    <cfset var s = inspect(value[1])>
    <cfset var l = arrayLen(value)>
    <cfset var i = "">
    <cfloop index="i" from="2" to="#(l - 1)#">
      <cfset s = s & ", " & inspect(value[i])>
    </cfloop>
    <cfif l gt 1>
      <cfset s = s & " and " & inspect(value[l])>
    </cfif>
    <cfreturn s>
  </cffunction>



</cfcomponent>
