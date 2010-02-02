<!---
  Be expects the target to match the specified predicate.
--->
<cfcomponent extends="cfspec.lib.Matcher" output="false">



  <cffunction name="init">
    <cfargument name="predicate">
    <cfset _matcherName = "Be#predicate#">
    <cfset _predicate = predicate>
    <cfset _args = arrayNew(1)>
    <cfset _flatArgs = "">
    <cfreturn this>
  </cffunction>



  <cffunction name="setArguments">
    <cfset var i = "">
    <cfset _args = arrayNew(1)>
    <cfset _flatArgs = "">
    <cfloop index="i" from="1" to="#arrayLen(arguments)#">
      <cfset arrayAppend(_args, arguments[i])>
      <cfset _flatArgs = listAppend(_flatArgs, "_args[#i#]")>
    </cfloop>
  </cffunction>



  <cffunction name="isMatch">
    <cfargument name="target">
    <cfset _target = target>
    <cfswitch expression="#_predicate#">
      <cfcase value="True">          <cfreturn isMatchTrue(target)>             </cfcase>
      <cfcase value="False">         <cfreturn isMatchFalse(target)>            </cfcase>
      <cfcase value="SimpleValue">   <cfreturn isMatchSimpleValue(target)>      </cfcase>
      <cfcase value="Numeric">       <cfreturn isMatchNumeric(target)>          </cfcase>
      <cfcase value="Date">          <cfreturn isMatchDate(target)>             </cfcase>
      <cfcase value="Boolean">       <cfreturn isMatchBoolean(target)>          </cfcase>
      <cfcase value="Object">        <cfreturn isMatchObject(target)>           </cfcase>
      <cfcase value="Struct">        <cfreturn isMatchStruct(target)>           </cfcase>
      <cfcase value="Array">         <cfreturn isMatchArray(target)>            </cfcase>
      <cfcase value="Query">         <cfreturn isMatchQuery(target)>            </cfcase>
      <cfcase value="Binary">        <cfreturn isMatchBinary(target)>           </cfcase>
      <cfcase value="GUID">          <cfreturn isMatchGUID(target)>             </cfcase>
      <cfcase value="UUID">          <cfreturn isMatchUUID(target)>             </cfcase>
      <cfcase value="Empty">         <cfreturn isMatchEmpty(target)>            </cfcase>
      <cfcase value="Defined">       <cfreturn isMatchDefined(target)>          </cfcase>
      <cfcase value="AnInstanceOf">  <cfreturn isMatchAnInstanceOf(target)>     </cfcase>
      <cfdefaultcase>
        <cfreturn isMatchCustomPredicate(target)>
      </cfdefaultcase>
    </cfswitch>
  </cffunction>



  <cffunction name="isMatchTrue">
    <cfargument name="target">
    <cfset requireArgs(_args, 0)>
    <cfif not isBoolean(target)>
      <cfthrow type="cfspec.fail" message="#_matcherName# expected a boolean, got #inspect(target)#.">
    </cfif>
    <cfreturn target eq true>
  </cffunction>



  <cffunction name="isMatchFalse">
    <cfargument name="target">
    <cfset requireArgs(_args, 0)>
    <cfif not isBoolean(target)>
      <cfthrow type="cfspec.fail" message="#_matcherName# expected a boolean, got #inspect(target)#.">
    </cfif>
    <cfreturn target eq false>
  </cffunction>



  <cffunction name="isMatchSimpleValue">
    <cfargument name="target">
    <cfset requireArgs(_args, 0)>
    <cfreturn isSimpleValue(target)>
  </cffunction>



  <cffunction name="isMatchNumeric">
    <cfargument name="target">
    <cfset requireArgs(_args, 0)>
    <cfreturn isNumeric(target)>
  </cffunction>



  <cffunction name="isMatchDate">
    <cfargument name="target">
    <cfset requireArgs(_args, 0)>
    <cfreturn isDate(target)>
  </cffunction>



  <cffunction name="isMatchBoolean">
    <cfargument name="target">
    <cfset requireArgs(_args, 0)>
    <cfreturn isBoolean(target)>
  </cffunction>



  <cffunction name="isMatchObject">
    <cfargument name="target">
    <cfset requireArgs(_args, 0)>
    <cfreturn isObject(target)>
  </cffunction>



  <cffunction name="isMatchStruct">
    <cfargument name="target">
    <cfset requireArgs(_args, 0)>
    <cfreturn isStruct(target)>
  </cffunction>



  <cffunction name="isMatchArray">
    <cfargument name="target">
    <cfset requireArgs(_args, 0)>
    <cfreturn isArray(target)>
  </cffunction>



  <cffunction name="isMatchQuery">
    <cfargument name="target">
    <cfset requireArgs(_args, 0)>
    <cfreturn isQuery(target)>
  </cffunction>



  <cffunction name="isMatchBinary">
    <cfargument name="target">
    <cfset requireArgs(_args, 0)>
    <cfreturn isBinary(target)>
  </cffunction>



  <cffunction name="isMatchGUID">
    <cfargument name="target">
    <cfset requireArgs(_args, 0)>
    <cfreturn isValid("guid", target)>
  </cffunction>



  <cffunction name="isMatchUUID">
    <cfargument name="target">
    <cfset requireArgs(_args, 0)>
    <cfreturn isValid("uuid", target)>
  </cffunction>



  <cffunction name="isMatchEmpty">
    <cfargument name="target">
    <cfset requireArgs(_args, 0)>
    <cfif isSimpleValue(target)><cfreturn trim(target) eq ""></cfif>
    <cfif isQuery(target)><cfreturn target.recordCount eq 0></cfif>
    <cftry>
      <cfset _target = target.isEmpty()>
      <cfcatch type="Application">
        <cfif cfcatch.message does not contain "isEmpty was not found"><cfrethrow></cfif>
        <cfthrow type="cfspec.fail" message="#_matcherName# expected target.isEmpty() to return a boolean, but the method was not found.">
      </cfcatch>
    </cftry>
    <cfif not isBoolean(_target)>
      <cfthrow type="cfspec.fail" message="#_matcherName# expected target.isEmpty() to return a boolean, got #inspect(_target)#.">
    </cfif>
    <cfreturn _target>
  </cffunction>



  <cffunction name="isMatchDefined">
    <cfargument name="target">
    <cfset requireArgs(_args, 0)>
    <cfset _target = structKeyExists(_runner.getBindings(), target)>
    <cfreturn _target>
  </cffunction>



  <cffunction name="isMatchAnInstanceOf">
    <cfargument name="target">
    <cfset requireArgs(_args, 1)>
    <cfset verifyArg(isSimpleValue(_args[1]), "className", "must be a simple value")>
    <cftry>
      <cfset _target = getMetaData(target).name>
      <cfcatch type="any">
        <cfset _target = "???">
      </cfcatch>
    </cftry>
    <cfreturn isInstanceOf(target, _args[1])>
  </cffunction>



  <cffunction name="isMatchCustomPredicate">
    <cfargument name="target">
    <cftry>
      <cfset _target = evaluate("target.is#_predicate#(#_flatArgs#)")>
      <cfcatch type="Application">
        <cfif cfcatch.message does not contain "is#_predicate# was not found"><cfrethrow></cfif>
        <cfthrow type="cfspec.fail" message="#_matcherName# expected target.#predicateMethod()# to return a boolean, but the method was not found.">
      </cfcatch>
    </cftry>
    <cfif not isBoolean(_target)>
      <cfthrow type="cfspec.fail" message="#_matcherName# expected target.#predicateMethod()# to return a boolean, got #inspect(_target)#.">
    </cfif>
    <cfreturn _target>
  </cffunction>



  <cffunction name="getFailureMessage">
    <cfreturn "expected #predicateExpectation(false)#, got #inspect(_target)#">
  </cffunction>



  <cffunction name="getNegativeFailureMessage">
    <cfreturn "expected #predicateExpectation(true)#, got #inspect(_target)#">
  </cffunction>



  <cffunction name="getDescription">
    <cfreturn reReplace(predicateExpectation(false), "^to\s+", "")>
  </cffunction>



  <cffunction name="predicateExpectation">
    <cfargument name="negative">
    <cfset var hamlet = iif(negative, de('not '), de('')) & "to be">
    <cfswitch expression="#_predicate#">
      <cfcase value="True">          <cfreturn "#hamlet# true">                                </cfcase>
      <cfcase value="False">         <cfreturn "#hamlet# false">                               </cfcase>
      <cfcase value="SimpleValue">   <cfreturn "#hamlet# a simple value">                      </cfcase>
      <cfcase value="Numeric">       <cfreturn "#hamlet# numeric">                             </cfcase>
      <cfcase value="Date">          <cfreturn "#hamlet# a date">                              </cfcase>
      <cfcase value="Boolean">       <cfreturn "#hamlet# a boolean">                           </cfcase>
      <cfcase value="Object">        <cfreturn "#hamlet# an object">                           </cfcase>
      <cfcase value="Struct">        <cfreturn "#hamlet# a struct">                            </cfcase>
      <cfcase value="Array">         <cfreturn "#hamlet# an array">                            </cfcase>
      <cfcase value="Query">         <cfreturn "#hamlet# a query">                             </cfcase>
      <cfcase value="Binary">        <cfreturn "#hamlet# binary">                              </cfcase>
      <cfcase value="GUID">          <cfreturn "#hamlet# a valid guid">                        </cfcase>
      <cfcase value="UUID">          <cfreturn "#hamlet# a valid uuid">                        </cfcase>
      <cfcase value="Empty">         <cfreturn "#hamlet# empty">                               </cfcase>
      <cfcase value="Defined">       <cfreturn "#hamlet# defined">                             </cfcase>
      <cfcase value="AnInstanceOf">  <cfreturn "#hamlet# an instance of #inspect(_args[1])#">  </cfcase>
      <cfdefaultcase>
        <cfreturn "#predicateMethod()# to be " & iif(negative, de('false'), de('true'))>
      </cfdefaultcase>
    </cfswitch>
  </cffunction>



  <cffunction name="predicateMethod">
    <cfreturn "is#_predicate#(#reReplace(inspect(_args), '^\[(.*)\]$', '\1')#)">
  </cffunction>



</cfcomponent>
