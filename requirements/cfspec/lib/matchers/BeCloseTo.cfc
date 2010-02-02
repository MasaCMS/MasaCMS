<!---
  BeCloseTo expected numeric arguments to fall within a given delta of the target.
--->
<cfcomponent extends="cfspec.lib.Matcher" output="false">



  <cfset _validDateParts = "yyyy,q,m,ww,w,y,d,h,n,s,l">



  <cffunction name="setArguments">
    <cfset requireArgs(arguments, 2, "at least")>
    <cfset requireArgs(arguments, 3, "at most")>
    <cfset _expected = arguments[1]>
    <cfset _delta = arguments[2]>
    <cfset _datePart = "">
    <cfif arrayLen(arguments) eq 2>
      <cfset verifyArg(isNumeric(_expected), "expected", "must be numeric")>
      <cfset verifyArg(isNumeric(_delta), "delta", "must be numeric")>
    <cfelse>
      <cfset _datePart = arguments[3]>
      <cfset verifyArg(isDate(_expected), "expected", "must be a date")>
      <cfset verifyArg(isNumeric(_delta), "delta", "must be numeric")>
      <cfset verifyArg(listFindNoCase(_validDateParts, _datePart), "datePart", "must be a valid date part")>
    </cfif>
  </cffunction>



  <cffunction name="isMatch">
    <cfargument name="target">
    <cfset _target = target>
    <cfif _datePart eq "">
      <cfreturn isMatchNumeric(target)>
    <cfelse>
      <cfreturn isMatchDate(target)>
    </cfif>
  </cffunction>



  <cffunction name="isMatchNumeric">
    <cfargument name="target">
    <cfif not isNumeric(target)>
      <cfthrow type="cfspec.fail" message="BeCloseTo expected a number, got #inspect(target)#">
    </cfif>
    <cfreturn abs(target - _expected) lt _delta>
  </cffunction>



  <cffunction name="isMatchDate">
    <cfargument name="target">
    <cfif not isDate(target)>
      <cfthrow type="cfspec.fail" message="BeCloseTo expected a date, got #inspect(target)#">
    </cfif>
    <cfreturn abs(dateDiff(_datePart, target, _expected)) lt _delta>
  </cffunction>



  <cffunction name="getFailureMessage">
    <cfreturn "expected #inspect(_expected)# +/- (< #inspect(_delta)##_datePart#), got #inspect(_target)#">
  </cffunction>



  <cffunction name="getNegativeFailureMessage">
    <cfreturn "expected #inspect(_expected)# +/- (>= #inspect(_delta)##_datePart#), got #inspect(_target)#">
  </cffunction>



  <cffunction name="getDescription">
    <cfreturn "be close to #inspect(_expected)# (within +/- #inspect(_delta)##_datePart#)">
  </cffunction>



</cfcomponent>
