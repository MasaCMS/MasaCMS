<!---
  Have expects the correct number of child elements.
--->
<cfcomponent extends="cfspec.lib.Matcher" output="false">



  <cffunction name="init">
    <cfargument name="relativity">
    <cfset _matcherName = "Have#relativity#">
    <cfset _relativity = relativity>
    <cfreturn this>
  </cffunction>



  <cffunction name="setArguments">
    <cfset requireArgs(arguments, 1)>
    <cfset _expected = arguments[1]>
    <cfset verifyArg(isNumeric(_expected), "expected", "must be numeric")>
  </cffunction>



  <cffunction name="isMatch">
    <cfargument name="collectionOwner">
    <cfset var collection = determineCollection(collectionOwner)>

    <cfif isSimpleValue(collection)>
      <cfset _actual = len(collection)>

    <cfelseif isObject(collection)>
      <cfif hasMethod(collection, "length")>
        <cfset _actual = collection.length()>
      <cfelseif hasMethod(collection, "size")>
        <cfset _actual = collection.size()>
      <cfelse>
        <cfthrow type="cfspec.fail" message="Have#_relativity# expected target.size() or target.length() to return a number, but the method was not found.">
      </cfif>
      <cfif not isNumeric(_actual)>
        <cfthrow type="cfspec.fail" message="Have#_relativity# expected target.size() or target.length() to return a number, got #inspect(_actual)#.">
      </cfif>

    <cfelseif isStruct(collection)>
      <cfset _actual = structCount(collection)>

    <cfelseif isArray(collection)>
      <cfset _actual = arrayLen(collection)>

    <cfelseif isQuery(collection)>
      <cfset _actual = collection.recordCount>

    </cfif>

    <cfswitch expression="#_relativity#">
      <cfcase value="AtLeast">  <cfreturn _actual ge _expected>         </cfcase>
      <cfcase value="AtMost">   <cfreturn _actual le _expected>         </cfcase>
      <cfdefaultcase>           <cfreturn _actual eq _expected>  </cfdefaultcase>
    </cfswitch>
  </cffunction>



  <cffunction name="getFailureMessage">
    <cfreturn "expected #relativeExpectation()# #_collectionName#, got #inspect(_actual)#.">
  </cffunction>



  <cffunction name="getDescription">
    <cfreturn "have #relativeExpectation()# #_collectionName#">
  </cffunction>



  <cffunction name="onMissingMethod">
    <cfargument name="missingMethodName">
    <cfargument name="missingMethodArguments">
    <cfset _collectionName = missingMethodName>
    <cfif isDefined("_expectations")>
      <cfset _expectations.__cfspecEvalMatcher(this)>
    </cfif>
    <cfreturn this>
  </cffunction>



  <cffunction name="isDelayed">
    <cfset var delayed = not isDefined("_collectionName")>
    <cfset _runner.flagDelayedMatcher(delayed)>
    <cfreturn delayed>
  </cffunction>



  <cffunction name="relativeExpectation">
    <cfset var n = inspect(_expected)>
    <cfswitch expression="#_relativity#">
      <cfcase value="AtLeast">  <cfreturn "at least #n#">  </cfcase>
      <cfcase value="AtMost">   <cfreturn "at most #n#">   </cfcase>
      <cfdefaultcase>           <cfreturn n>        </cfdefaultcase>
    </cfswitch>
  </cffunction>



  <cffunction name="determineCollection">
    <cfargument name="collectionOwner">
    <cfset var pluralCollectionName = "">
    <cfif isObject(collectionOwner)>
      <cfif hasMethod(collectionOwner, "get#_collectionName#")>
        <cfreturn evaluate("collectionOwner.get#_collectionName#()")>
      </cfif>
      <cfset pluralCollectionName = request.singletons.getInflector().pluralize(_collectionName)>
      <cfif pluralCollectionName neq _collectionName and hasMethod(collectionOwner, "get#pluralCollectionName#")>
        <cfreturn evaluate("collectionOwner.get#pluralCollectionName#()")>
      <cfelseif hasMethod(collectionOwner, "length") or hasMethod(collectionOwner, "size")>
        <cfreturn collectionOwner>
      </cfif>
      <cftry>
        <cfreturn evaluate("collectionOwner.get#_collectionName#()")>
        <cfcatch type="Application">
          <cfif cfcatch.message does not contain "get#_collectionName# was not found"><cfrethrow></cfif>
        </cfcatch>
      </cftry>
    </cfif>
    <cfreturn collectionOwner>
  </cffunction>



</cfcomponent>
