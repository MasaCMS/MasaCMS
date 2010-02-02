<!---
  BeComparison expects the given number to be related to the target accorging to the named
  comparison relationship.
--->
<cfcomponent extends="cfspec.lib.Matcher" output="false">



  <cfset _validDateParts = "yyyy,q,m,ww,w,y,d,h,n,s,l">



  <cffunction name="init">
    <cfargument name="comparison">
    <cfset _matcherName = "Be#comparison#">
    <cfset _comparison = comparison>
    <cfreturn this>
  </cffunction>



  <cffunction name="setArguments">
    <cfif listFindNoCase("before,after", _comparison)>
      <cfset requireArgs(arguments, 1, "at least")>
      <cfset requireArgs(arguments, 2, "at most")>
      <cfset _expected = arguments[1]>
      <cfset _datePart = "">
      <cfset verifyArg(isDate(_expected), "expected", "must be a date")>
      <cfif arrayLen(arguments) eq 2>
        <cfset _datePart = arguments[2]>
        <cfset verifyArg(listFindNoCase(_validDateParts, _datePart), "datePart", "must be a valid date part")>
      </cfif>
    <cfelse>
      <cfset requireArgs(arguments, 1)>
      <cfset _expected = arguments[1]>
      <cfset verifyArg(isNumeric(_expected), "expected", "must be numeric")>
    </cfif>
  </cffunction>



  <cffunction name="isMatch">
    <cfargument name="target">
    <cfset _target = target>
    <cfif listFindNoCase("before,after", _comparison)>
      <cfreturn isMatchDate(target)>
    <cfelse>
      <cfreturn isMatchNumeric(target)>
    </cfif>
  </cffunction>



  <cffunction name="isMatchDate">
    <cfargument name="target">
    <cfset var dp = _datePart>
    <cfif not isDate(target)>
      <cfthrow type="cfspec.fail" message="Be#_comparison# expected a date, got #inspect(target)#">
    </cfif>
    <cfif dp eq ""><cfset dp = "s"></cfif>
    <cfswitch expression="#_comparison#">
      <cfcase value="Before">  <cfreturn dateDiff(dp, target, _expected) ge 1>  </cfcase>
      <cfcase value="After">   <cfreturn dateDiff(dp, _expected, target) ge 1>  </cfcase>
    </cfswitch>
    <cfthrow message="Internal Sytem Bug">
  </cffunction>



  <cffunction name="isMatchNumeric">
    <cfargument name="target">
    <cfif not isNumeric(target)>
      <cfthrow type="cfspec.fail" message="Be#_comparison# expected a number, got #inspect(target)#">
    </cfif>
    <cfswitch expression="#_comparison#">
      <cfcase value="LessThan">              <cfreturn target lt _expected>  </cfcase>
      <cfcase value="LessThanOrEqualTo">     <cfreturn target le _expected>  </cfcase>
      <cfcase value="GreaterThanOrEqualTo">  <cfreturn target ge _expected>  </cfcase>
      <cfcase value="GreaterThan">           <cfreturn target gt _expected>  </cfcase>
    </cfswitch>
    <cfthrow message="Internal Sytem Bug">
  </cffunction>



  <cffunction name="getFailureMessage">
    <cfreturn "expected to #getDescription()#, got #inspect(_target)#">
  </cffunction>



  <cffunction name="getNegativeFailureMessage">
    <cfreturn "expected not to #getDescription()#, got #inspect(_target)#">
  </cffunction>



  <cffunction name="getDescription">
    <cfif isDefined("_datePart")>
      <cfreturn "be #lCase(_comparison)# #inspect(_expected)#" & iif(_datePart neq "", de(" (#_datePart#)"), de(""))>
    <cfelse>
      <cfreturn "be #_shorthand[_comparison]# #inspect(_expected)#">
    </cfif>
  </cffunction>



  <cfset _shorthand = structNew()>
  <cfset _shorthand.lessThan             = "<"  >
  <cfset _shorthand.lessThanOrEqualTo    = "<=" >
  <cfset _shorthand.greaterThanOrEqualTo = ">=" >
  <cfset _shorthand.greaterThan          = ">"  >



</cfcomponent>
