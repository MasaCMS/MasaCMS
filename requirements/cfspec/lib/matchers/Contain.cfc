<!---
  Contain expects each of its arguments to be contained within the target.
--->
<cfcomponent extends="cfspec.lib.Matcher" output="false">



  <cffunction name="init">
    <cfargument name="noCase">
    <cfset _matcherName = "Contain">
    <cfset _noCase = len(noCase) gt 0>
    <cfreturn this>
  </cffunction>



  <cffunction name="setArguments">
    <cfset var i = "">
    <cfset requireArgs(arguments, 1, "at least")>
    <cfset _expected = arrayNew(1)>
    <cfloop index="i" from="1" to="#arrayLen(arguments)#">
      <cfset arrayAppend(_expected, arguments[i])>
    </cfloop>
  </cffunction>



  <cffunction name="isMatch">
    <cfargument name="target">
    <cfset _actual = target>
    <cfif isSimpleValue(target)>  <cfreturn isMatchSimpleValue(target)>  </cfif>
    <cfif isObject(target)>       <cfreturn isMatchObject(target)>       </cfif>
    <cfif isStruct(target)>       <cfreturn isMatchStruct(target)>       </cfif>
    <cfif isArray(target)>        <cfreturn isMatchArray(target)>        </cfif>
    <cfif isQuery(target)>        <cfreturn isMatchQuery(target)>        </cfif>
    <cfreturn false>
  </cffunction>



  <cffunction name="isMatchSimpleValue">
    <cfargument name="target">
    <cfset var i = "">
    <cfloop index="i" from="1" to="#arrayLen(_expected)#">
      <cfset verifyArg(isSimpleValue(_expected[i]), "expected (###i#)", "must be a simple value")>
      <cfif _noCase>
        <cfif not reFindNoCase(_expected[i], target)><cfreturn false></cfif>
      <cfelse>
        <cfif not reFind(_expected[i], target)><cfreturn false></cfif>
      </cfif>
    </cfloop>
    <cfreturn true>
  </cffunction>



  <cffunction name="isMatchObject">
    <cfargument name="target">
    <cfset var result = "">
    <cfset var i = "">
    <cfloop index="i" from="1" to="#arrayLen(_expected)#">
      <cftry>
        <cfset result = target.hasElement(_expected[i])>
        <cfcatch type="Application">
          <cfif cfcatch.message does not contain "hasElement was not found"><cfrethrow></cfif>
          <cftry>
            <cfset result = target.contains(_expected[i])>
            <cfcatch type="Application">
              <cfif cfcatch.message does not contain "contains was not found"><cfrethrow></cfif>
              <cfthrow type="cfspec.fail" message="Contain expected target.hasElement(expected) or target.contains(expected) to return a boolean, but neither method was found.">
            </cfcatch>
          </cftry>
        </cfcatch>
      </cftry>
      <cfif not isBoolean(result)>
        <cfthrow type="cfspec.fail" message="Contain expected target.hasElement(expected) or target.contains(expected) to return a boolean, got #inspect(result)#">
      </cfif>
      <cfif not result>
        <cfreturn false>
      </cfif>
    </cfloop>
    <cfreturn true>
  </cffunction>



  <cffunction name="isMatchStruct">
    <cfargument name="target">
    <cfset var eqMatcher = createObject("component", "cfspec.lib.matchers.Equal").init("", iif(_noCase, de("NoCase"), de("")))>
    <cfset var key = "">
    <cfset var i = "">
    <cfloop index="i" from="1" to="#arrayLen(_expected)#">
      <cfif isSimpleValue(_expected[i])>
        <cfif not structKeyExists(target, _expected[i])>
          <cfreturn false>
        </cfif>
      <cfelseif isStruct(_expected[i])>
        <cfloop collection="#_expected[i]#" item="key">
          <cfif not structKeyExists(target, key)>
            <cfreturn false>
          </cfif>
          <cfset eqMatcher.setArguments(_actual[key])>
          <cfif not eqMatcher.isMatch(_expected[i][key])>
            <cfreturn false>
          </cfif>
        </cfloop>
      <cfelse>
        <cfset verifyArg(false, "expected (###i#)", "must be a simple value or struct")>
      </cfif>
    </cfloop>
    <cfreturn true>
  </cffunction>



  <cffunction name="isMatchArray">
    <cfargument name="target">
    <cfset var eqMatcher = createObject("component", "cfspec.lib.matchers.Equal").init("", iif(_noCase, de("NoCase"), de("")))>
    <cfset var result = "">
    <cfset var i = "">
    <cfset var j = "">
    <cfloop index="i" from="1" to="#arrayLen(_expected)#">
      <cfset result = false>
      <cfloop index="j" from="1" to="#arrayLen(target)#">
        <cfset eqMatcher.setArguments(target[j])>
        <cfif eqMatcher.isMatch(_expected[i])>
          <cfset result = true>
          <cfbreak>
        </cfif>
      </cfloop>
      <cfif not result>
        <cfreturn false>
      </cfif>
    </cfloop>
    <cfreturn true>
  </cffunction>



  <cffunction name="isMatchQuery">
    <cfargument name="target">
    <cfset var eqMatcher = createObject("component", "cfspec.lib.matchers.Equal").init("", iif(_noCase, de("NoCase"), de("")))>
    <cfset var result = "">
    <cfset var rowResult = "">
    <cfset var key = "">
    <cfset var i = "">
    <cfset var j = "">
    <cfloop index="i" from="1" to="#arrayLen(_expected)#">
      <cfif isSimpleValue(_expected[i])>
        <cfif not listFindNoCase(target.columnList, _expected[i])>
          <cfreturn false>
        </cfif>
      <cfelseif isStruct(_expected[i])>
        <cfloop collection="#_expected[i]#" item="key">
          <cfif not listFindNoCase(target.columnList, key)>
            <cfreturn false>
          </cfif>
        </cfloop>
        <cfset result = false>
        <cfloop index="j" from="1" to="#target.recordCount#">
          <cfset rowResult = true>
          <cfloop collection="#_expected[i]#" item="key">
            <cfset eqMatcher.setArguments(target[key][j])>
            <cfif not eqMatcher.isMatch(_expected[i][key])>
              <cfset rowResult = false>
              <cfbreak>
            </cfif>
          </cfloop>
          <cfif rowResult>
            <cfset result = true>
            <cfbreak>
          </cfif>
        </cfloop>
        <cfif not result>
          <cfreturn false>
        </cfif>
      <cfelse>
        <cfset verifyArg(false, "expected (###i#)", "must be a simple value or struct")>
      </cfif>
    </cfloop>
    <cfreturn true>
  </cffunction>



  <cffunction name="getFailureMessage">
    <cfreturn "expected to contain #prettyPrint(_expected)#, got #inspect(_actual)#">
  </cffunction>



  <cffunction name="getNegativeFailureMessage">
    <cfreturn "expected not to contain #prettyPrint(_expected)#, got #inspect(_actual)#">
  </cffunction>



  <cffunction name="getDescription">
    <cfreturn "contain #prettyPrint(_expected)#">
  </cffunction>



</cfcomponent>
