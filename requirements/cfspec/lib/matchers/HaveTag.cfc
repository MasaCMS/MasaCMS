<!---
  HaveTag expects the target to contain at least one of the specified XPath tag.
--->
<cfcomponent extends="cfspec.lib.Matcher" output="false">



  <cffunction name="setArguments">
    <cfset requireArgs(arguments, 1, "at least")>
    <cfset requireArgs(arguments, 3, "at most")>
    <cfset _selector = arguments[1]>
    <cfset verifyArg(isSimpleValue(_selector), "selector", "should be a valid xpath selector")>
    <cfswitch expression="#arrayLen(arguments)#">
      <cfcase value="1">
        <cfset _minCount = 1>
        <cfset _maxCount = 0>
      </cfcase>
      <cfcase value="2">
        <cfset _minCount = arguments[2]>
        <cfset _maxCount = arguments[2]>
        <cfset verifyArg(isNumeric(_minCount), "count", "should be numeric")>
      </cfcase>
      <cfcase value="3">
        <cfset _minCount = arguments[2]>
        <cfset _maxCount = arguments[3]>
        <cfset verifyArg(isNumeric(_minCount), "minCount", "should be numeric")>
        <cfset verifyArg(isNumeric(_maxCount), "maxCount", "should be numeric")>
      </cfcase>
    </cfswitch>
  </cffunction>



  <cffunction name="isMatch">
    <cfargument name="target">
    <cfset var xpath = _selector>
    <cfset var results = "">
    <cfset var doc = buildDoc(target)>
    <cfif find("/", xpath) neq 1>
      <cfset xpath = "//#xpath#">
    </cfif>
    <cfset results = xmlSearch(xmlParse(doc.toXml()), xpath)>
    <cfset _actual = arrayLen(results)>
    <cfreturn _actual ge _minCount and (_maxCount eq 0 or _actual le _maxCount)>
  </cffunction>



  <cffunction name="getFailureMessage">
    <cfreturn "expected to #getDescription()#, got #_actual#">
  </cffunction>



  <cffunction name="getNegativeFailureMessage">
    <cfreturn "expected not to #getDescription()#, got #_actual#">
  </cffunction>



  <cffunction name="getDescription">
    <cfset var range = "">
    <cfif _maxCount gt 0>
      <cfif _minCount eq _maxCount>
        <cfset range = " (#_minCount#)">
      <cfelse>
        <cfset range = " (#_minCount#-#_maxCount#)">
      </cfif>
    </cfif>
    <cfreturn "have tag #inspect(_selector)#" & range>
  </cffunction>



  <cffunction name="buildDoc">
    <cfargument name="target">
    <cfset var targetAsBytes = createObject("java", "java.lang.String").init(target).getBytes()>
    <cfset var targetAsStream = createobject("java","java.io.ByteArrayInputStream").init(targetAsBytes)>
    <cfreturn request.singletons.getDocBuilder().build(targetAsStream)>
  </cffunction>



</cfcomponent>
