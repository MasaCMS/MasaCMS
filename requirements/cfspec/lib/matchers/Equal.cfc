<!---
  Equal expects the the target to have the same value.
--->
<cfcomponent extends="cfspec.lib.Matcher" output="false">



  <cffunction name="init">
    <cfargument name="type">
    <cfargument name="noCase">
    <cfset _matcherName = "Equal#type#">
    <cfset _type = type>
    <cfset _noCase = len(noCase) gt 0>
    <cfreturn this>
  </cffunction>



  <cffunction name="setArguments">
    <cfset requireArgs(arguments, 1)>
    <cfset _expected = arguments[1]>
  </cffunction>



  <cffunction name="isMatch">
    <cfargument name="target">
    <cfset var result = "">
    <cfset _target = target>
    <cfswitch expression="#_type#">
      <cfcase value="Numeric">  <cfreturn isMatchNumeric(target)>  </cfcase>
      <cfcase value="Date">     <cfreturn isMatchDate(target)>     </cfcase>
      <cfcase value="Boolean">  <cfreturn isMatchBoolean(target)>  </cfcase>
      <cfcase value="String">   <cfreturn isMatchString(target)>   </cfcase>
      <cfcase value="Object">   <cfreturn isMatchObject(target)>   </cfcase>
      <cfcase value="Struct">   <cfreturn isMatchStruct(target)>   </cfcase>
      <cfcase value="Array">    <cfreturn isMatchArray(target)>    </cfcase>
      <cfcase value="Query">    <cfreturn isMatchQuery(target)>    </cfcase>
      <cfdefaultcase>
        <cfreturn isEqual(target, _expected)>
      </cfdefaultcase>
    </cfswitch>
  </cffunction>



  <cffunction name="isMatchNumeric">
    <cfargument name="target">
    <cfset verifyArg(isNumeric(_expected), "expected", "must be numeric")>
    <cfif not isNumeric(target)>
      <cfthrow type="cfspec.fail" message="#_matcherName# expected a number, got #inspect(target)#.">
    </cfif>
    <cfreturn isEqualNumeric(target, _expected)>
  </cffunction>



  <cffunction name="isMatchDate">
    <cfargument name="target">
    <cfset verifyArg(isDate(_expected), "expected", "must be a date")>
    <cfif not isDate(target)>
      <cfthrow type="cfspec.fail" message="#_matcherName# expected a date, got #inspect(target)#.">
    </cfif>
    <cfreturn isEqualDate(target, _expected)>
  </cffunction>



  <cffunction name="isMatchBoolean">
    <cfargument name="target">
    <cfset verifyArg(isBoolean(_expected), "expected", "must be a boolean")>
    <cfif not isBoolean(target)>
      <cfthrow type="cfspec.fail" message="#_matcherName# expected a boolean, got #inspect(target)#.">
    </cfif>
    <cfreturn isEqualBoolean(target, _expected)>
  </cffunction>



  <cffunction name="isMatchString">
    <cfargument name="target">
    <cfset verifyArg(isSimpleValue(_expected), "expected", "must be a string")>
    <cfif not isSimpleValue(target)>
      <cfthrow type="cfspec.fail" message="#_matcherName# expected a string, got #inspect(target)#.">
    </cfif>
    <cfreturn isEqualString(target, _expected)>
  </cffunction>



  <cffunction name="isMatchObject">
    <cfargument name="target">
    <cfset verifyArg(isObject(_expected), "expected", "must be an object")>
    <cfif not isObject(target)>
      <cfthrow type="cfspec.fail" message="#_matcherName# expected an object, got #inspect(target)#.">
    </cfif>
    <cftry>
      <cfset result = isEqualObject(target, _expected)>
      <cfcatch type="Application">
        <cfif cfcatch.message does not contain "isEqualTo was not found"><cfrethrow></cfif>
        <cfthrow type="cfspec.fail" message="#_matcherName# expected target.isEqualTo(expected) to return a boolean, but the method was not found.">
      </cfcatch>
    </cftry>
    <cfif not isBoolean(result)>
      <cfthrow type="cfspec.fail" message="#_matcherName# expected target.isEqualTo(expected) to return a boolean, got #inspect(result)#.">
    </cfif>
    <cfreturn result>
  </cffunction>



  <cffunction name="isMatchStruct">
    <cfargument name="target">
    <cfset verifyArg(isStruct(_expected), "expected", "must be a struct")>
    <cfif not isStruct(target)>
      <cfthrow type="cfspec.fail" message="#_matcherName# expected a struct, got #inspect(target)#.">
    </cfif>
    <cfreturn isEqualStruct(target, _expected)>
  </cffunction>



  <cffunction name="isMatchArray">
    <cfargument name="target">
    <cfset verifyArg(isArray(_expected), "expected", "must be an array")>
    <cfif not isArray(target)>
      <cfthrow type="cfspec.fail" message="#_matcherName# expected an array, got #inspect(target)#.">
    </cfif>
    <cfreturn isEqualArray(target, _expected)>
  </cffunction>



  <cffunction name="isMatchQuery">
    <cfargument name="target">
    <cfset verifyArg(isQuery(_expected), "expected", "must be a query")>
    <cfif not isQuery(target)>
      <cfthrow type="cfspec.fail" message="#_matcherName# expected a query, got #inspect(target)#.">
    </cfif>
    <cfreturn isEqualQuery(target, _expected)>
  </cffunction>



  <cffunction name="getFailureMessage">
    <cfreturn "expected #inspect(_expected)#, got #inspect(_target)#">
  </cffunction>



  <cffunction name="getNegativeFailureMessage">
    <cfreturn "expected not to equal #inspect(_expected)#, got #inspect(_target)#">
  </cffunction>



  <cffunction name="getDescription">
    <cfreturn "equal #inspect(_expected)#">
  </cffunction>



  <cffunction name="isEqualNumeric">
    <cfargument name="a">
    <cfargument name="b">
    <cfreturn val(a) eq val(b)>
  </cffunction>



  <cffunction name="isEqualDate">
    <cfargument name="a">
    <cfargument name="b">
    <cfreturn dateCompare(a, b) eq 0>
  </cffunction>



  <cffunction name="isEqualBoolean">
    <cfargument name="a">
    <cfargument name="b">
    <cfreturn a eqv b>
  </cffunction>



  <cffunction name="isEqualString">
    <cfargument name="a">
    <cfargument name="b">
    <cfreturn iif(_noCase, 'compareNoCase(a, b)', 'compare(a, b)') eq 0>
  </cffunction>



  <cffunction name="isEqualObject">
    <cfargument name="a">
    <cfargument name="b">
    <cfreturn a.isEqualTo(b)>
  </cffunction>



  <cffunction name="isEqualStruct">
    <cfargument name="a">
    <cfargument name="b">
    <cfset var keys = "">
    <cfset var i = "">
    <cfif structCount(a) neq structCount(b)>
      <cfreturn false>
    </cfif>
    <cfset keys = listSort(structKeyList(a), "textnocase")>
    <cfif keys neq listSort(structKeyList(b), "textnocase")>
      <cfreturn false>
    </cfif>
    <cfset keys = listToArray(keys)>
    <cfloop index="i" from="1" to="#arrayLen(keys)#">
      <cfif not isEqual(a[keys[i]], b[keys[i]])>
        <cfreturn false>
      </cfif>
    </cfloop>
    <cfreturn true>
  </cffunction>



  <cffunction name="isEqualArray">
    <cfargument name="a">
    <cfargument name="b">
    <cfset var i = "">
    <cfif arrayLen(a) neq arrayLen(b)>
      <cfreturn false>
    </cfif>
    <cfloop index="i" from="1" to="#arrayLen(a)#">
      <cfif not isEqual(a[i], b[i])>
        <cfreturn false>
      </cfif>
    </cfloop>
    <cfreturn true>
  </cffunction>



  <cffunction name="isEqualQuery">
    <cfargument name="a">
    <cfargument name="b">
    <cfset var keys = "">
    <cfset var i = "">
    <cfset var j = "">
    <cfif a.recordCount neq b.recordCount>
      <cfreturn false>
    </cfif>
    <cfset keys = listSort(a.columnList, "textnocase")>
    <cfif keys neq listSort(b.columnList, "textnocase")>
      <cfreturn false>
    </cfif>
    <cfset keys = listToArray(keys)>
    <cfloop index="i" from="1" to="#a.recordCount#">
      <cfloop index="j" from="1" to="#arrayLen(keys)#">
        <cfif not isEqual(a[keys[i]][j], b[keys[i]][j])>
          <cfreturn false>
        </cfif>
      </cfloop>
    </cfloop>
    <cfreturn true>
  </cffunction>



  <cffunction name="isEqual">
    <cfargument name="a">
    <cfargument name="b">
    <cfset var result = "">
    <cfif isSimpleValue(a) and isSimpleValue(b)>
      <cfif isNumeric(a) and isNumeric(b)>
        <cfreturn isEqualNumeric(a, b)>
      </cfif>
      <cfif isDate(a) and isDate(b)>
        <cfreturn isEqualDate(a, b)>
      </cfif>
      <cfif listFindNoCase("true,false,yes,no", a) and listFindNoCase("true,false,yes,no", b)>
        <cfreturn isEqualBoolean(a, b)>
      </cfif>
      <cfreturn isEqualString(a, b)>
    <cfelseif isObject(a) and isObject(b)>
      <cftry>
        <cfset result = isEqualObject(a, b)>
        <cfcatch type="Application">
          <cfif cfcatch.message does not contain "isEqualTo was not found"><cfrethrow></cfif>
          <cfthrow type="cfspec.fail" message="Equal#_type# expected target.isEqualTo(expected) to return a boolean, but the method was not found.">
        </cfcatch>
      </cftry>
      <cfif not isBoolean(result)>
        <cfthrow type="cfspec.fail" message="Equal#_type# expected target.isEqualTo(expected) to return a boolean, got #inspect(result)#.">
      </cfif>
      <cfreturn result>
    <cfelseif isStruct(a) and isStruct(b)>
      <cfreturn isEqualStruct(a, b)>
    <cfelseif isArray(a) and isArray(b)>
      <cfreturn isEqualArray(a, b)>
    <cfelseif isQuery(a) and isQuery(b)>
      <cfreturn isEqualQuery(a, b)>
    </cfif>
    <cfreturn false>
  </cffunction>



</cfcomponent>
