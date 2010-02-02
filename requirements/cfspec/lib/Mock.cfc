<!---
  Mock object.  Method name space should be kept clean.
--->
<cfcomponent output="false">



  <cfset _stubbedMethods = structNew()>
  <cfset _stubsMissingMethod = false>



  <cffunction name="__cfspecInit" output="false">
    <cfargument name="__cfspecMockName" default="(unknown)">
    <cfargument name="__cfspecMockType" default="stub">
    <cfset var method = "">
    <cfset _name = __cfspecMockName>
    <cfloop collection="#arguments#" item="method">
      <cfif len(method) lt 8 or left(method, 8) neq "__cfspec">
        <cfif __cfspecMockType eq "stub">
          <cfset stubs(method).returns(arguments[method])>
        <cfelse>
          <cfset expects(method).returns(arguments[method])>
        </cfif>
      </cfif>
    </cfloop>
    <cfreturn this>
  </cffunction>



  <cffunction name="stubs" output="false">
    <cfargument name="method">
    <cfreturn __cfspecAddExpectations(method, false)>
  </cffunction>



  <cffunction name="expects" output="false">
    <cfargument name="method">
    <cfreturn __cfspecAddExpectations(method, true)>
  </cffunction>



  <cffunction name="stubsMissingMethod" output="false">
    <cfset _stubsMissingMethod = createObject("component", "cfspec.lib.MockExpectations").init(this)>
    <cfreturn _stubsMissingMethod>
  </cffunction>



  <cffunction name="onMissingMethod">
    <cfargument name="missingMethodName">
    <cfargument name="missingMethodArguments">
    <cfset var expectations = "">
    <cfset var updates = arrayNew(1)>
    <cfset var result = "">
    <cfset var resultIndex = "">
    <cfset var isDone = false>
    <cfset var i = "">
    <cfif structKeyExists(_stubbedMethods, missingMethodName)>
      <cfset expectations = _stubbedMethods[missingMethodName]>
      <cfloop index="i" from="1" to="#arrayLen(expectations)#">
        <cfif expectations[i].isActive(missingMethodArguments)>
          <cfset arrayAppend(updates, expectations[i])>
          <cfif isDone>
            <cfif result.isEqualTo(expectations[i], false) and expectations[i].isInSequence()>
              <cfif result.isInSequence()>
                <cfset arrayDeleteAt(updates, resultIndex)>
                <cfset resultIndex = arrayLen(updates)>
              </cfif>
              <cfset result = expectations[i]>
            </cfif>
          <cfelse>
            <cfset result = expectations[i]>
            <cfset resultIndex = arrayLen(updates)>
            <cfset isDone = true>
          </cfif>
        </cfif>
      </cfloop>
      <cfif isDone>
        <cfloop index="i" from="1" to="#arrayLen(updates)#">
          <cfset updates[i].incrementCallCount()>
        </cfloop>
        <cfreturn result.getReturn()>
      </cfif>
    </cfif>
    <cfif isObject(_stubsMissingMethod)>
      <cfreturn _stubsMissingMethod.getReturn()>
    </cfif>
    <cfif isDefined("_obj.__cfspecOriginalOnMissingMethod")>
      <cfreturn _obj.__cfspecOriginalOnMissingMethod(missingMethodName, missingMethodArguments)>
    </cfif>
    <cfthrow message="The method #missingMethodName# was not found.">
  </cffunction>



  <cffunction name="__cfspecGetFailureMessages" output="false">
    <cfset var expectations = "">
    <cfset var messages = arrayNew(1)>
    <cfset var message = "">
    <cfset var method = "">
    <cfset var i = "">
    <cfloop collection="#_stubbedMethods#" item="method">
      <cfset expectations = _stubbedMethods[method]>
      <cfloop index="i" from="1" to="#arrayLen(expectations)#">
        <cfset message = expectations[i].getFailureMessage()>
        <cfif message neq "">
          <cfset arrayAppend(messages, "#_name#: #message#")>
        </cfif>
      </cfloop>
    </cfloop>
    <cfreturn messages>
  </cffunction>



  <cffunction name="__cfspecInternExpectations" output="false">
    <cfargument name="method">
    <cfargument name="expectations">
    <cfset var existingExpectations = "">
    <cfset var previous = "">
    <cfset var garbage = "">
    <cfset var i = "">
    <cfif not structKeyExists(_stubbedMethods, method)>
      <cfreturn expectations>
    </cfif>
    <cfset existingExpectations = _stubbedMethods[method]>
    <cfloop index="i" from="1" to="#arrayLen(existingExpectations)#">
      <cfif existingExpectations[i].isEqualTo(expectations)>
        <cfset expectations = existingExpectations[i]>
        <cfset garbage = listPrepend(garbage, previous)>
        <cfset previous = i>
      </cfif>
    </cfloop>
    <cfif garbage neq "">
      <cfloop list="#garbage#" index="i">
        <cfset arrayDeleteAt(_stubbedMethods[method], i)>
      </cfloop>
    </cfif>
    <cfreturn expectations>
  </cffunction>



  <cffunction name="__cfspecGetName" output="false">
    <cfreturn _name>
  </cffunction>



  <!--- PRIVATE --->



  <cffunction name="__cfspecAddExpectations" access="private" output="false">
    <cfargument name="method">
    <cfargument name="isExpected">
    <cfset var expectations = createObject("component", "cfspec.lib.MockExpectations")
                              .init(this, method, isExpected)>
    <cfif not structKeyExists(_stubbedMethods, method)>
      <cfset _stubbedMethods[method] = arrayNew(1)>
    </cfif>
    <cfset arrayPrepend(_stubbedMethods[method], expectations)>
    <cfreturn expectations>
  </cffunction>



</cfcomponent>
