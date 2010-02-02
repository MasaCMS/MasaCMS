<!---
  Match expects the target to be a simple value that matches the given regular expression.
--->
<cfcomponent extends="cfspec.lib.Matcher" output="false">



  <cfset _validDateParts = "yyyy,q,m,ww,w,y,d,h,n,s,l">



  <cffunction name="init">
    <cfargument name="noCase">
    <cfset _matcherName = "Match">
    <cfset _noCase = len(noCase) gt 0>
    <cfreturn this>
  </cffunction>



  <cffunction name="setArguments">
    <cfset requireArgs(arguments, 1, "at least")>
    <cfset requireArgs(arguments, 2, "at most")>
    <cfif arrayLen(arguments) eq 1>
      <cfset _regexp = arguments[1]>
      <cfset verifyArg(isSimpleValue(_regexp), "regExp", "must be a valid regular expression")>
    <cfelse>
      <cfset _expected = arguments[1]>
      <cfset _datePart = arguments[2]>
      <cfset verifyArg(isDate(_expected), "expected", "must be a date")>
      <cfset verifyArg(listFindNoCase(_validDateParts, _datePart), "regExp", "must be a valid date part")>
    </cfif>
  </cffunction>



  <cffunction name="isMatch">
    <cfargument name="target">
    <cfset _target = target>
    <cfif isDefined("_regexp")>
      <cfreturn isMatchRegExp(target)>
    <cfelse>
      <cfreturn isMatchDate(target)>
    </cfif>
  </cffunction>



  <cffunction name="isMatchRegExp">
    <cfargument name="target">
    <cfif not isSimpleValue(target)>
      <cfthrow type="cfspec.fail" message="Match expected a simple value, got #inspect(target)#">
    </cfif>
    <cfif _noCase>
      <cfreturn reFindNoCase(_regexp, target) gt 0>
    <cfelse>
      <cfreturn reFind(_regexp, target) gt 0>
    </cfif>
  </cffunction>



  <cffunction name="isMatchDate">
    <cfargument name="target">
    <cfset var dp = "">
    <cfif not isDate(target)>
      <cfthrow type="cfspec.fail" message="Match expected a date, got #inspect(target)#">
    </cfif>

    <cfloop list="#_validDateParts#" index="dp">
      <cfif datePart(dp, target) neq datePart(dp, _expected)>
        <cfreturn false>
      </cfif>
      <cfif dp eq _datePart>
        <cfbreak>
      </cfif>
    </cfloop>

    <cfreturn true>
  </cffunction>



  <cffunction name="getFailureMessage">
    <cfif isDefined("_regexp")>
      <cfreturn "expected to match #inspect(_regexp)#, got #inspect(_target)#">
    <cfelse>
      <cfreturn "expected to match #inspect(_expected)# (#_datePart#), got #inspect(_target)#">
    </cfif>
  </cffunction>



  <cffunction name="getNegativeFailureMessage">
    <cfif isDefined("_regexp")>
      <cfreturn "expected not to match #inspect(_regexp)#, got #inspect(_target)#">
    <cfelse>
      <cfreturn "expected not to match #inspect(_expected)# (#_datePart#), got #inspect(_target)#">
    </cfif>
  </cffunction>



  <cffunction name="getDescription">
    <cfif isDefined("_regexp")>
      <cfreturn "match #inspect(_regexp)#">
    <cfelse>
      <cfreturn "match #inspect(_expected)# (#_datePart#)">
    </cfif>
  </cffunction>



</cfcomponent>
