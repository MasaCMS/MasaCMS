<!---
  SpecRunner is the primary controlling object for the duration of the spec.
--->
<cfcomponent output="false">



  <cffunction name="init" output="false">
    <cfset _fileUtils = request.singletons.getFileUtils()>
    <cfset _suiteNumber = 0>
    <cfset resetContext()>
    <cfreturn this>
  </cffunction>



  <cffunction name="setReport" output="false">
    <cfargument name="report">
    <cfset _report = report>
  </cffunction>



  <cffunction name="setSpecStats" output="false">
    <cfargument name="specStats">
    <cfset _specStats = specStats>
    <cfif isDefined("_report")>
      <cfset _report.setSpecStats(specStats)>
    </cfif>
  </cffunction>



  <cffunction name="runSpecSuite" output="false">
    <cfargument name="specPath">
    <cfset var files = "">
    <cfdirectory action="list" directory="#specPath#" name="files">
    <cfloop query="files">
      <cfif type eq "dir" and left(name, 1) neq ".">
        <cfset runSpecSuite("#specPath#/#name#")>
      <cfelseif type eq "file" and reFindNoCase("spec\.cfm$", name)>
        <cfset _suiteNumber = _suiteNumber + 1>
        <cfset resetContext()>
        <cfset runSpecFile("#specPath#/#name#")>
      </cfif>
    </cfloop>
  </cffunction>



  <cffunction name="runSpecFile" output="false">
    <cfargument name="specPath">
    <cfset var specFile = _fileUtils.relativePath(specPath)>
    <cfset resetCurrent()>
    <cfset _context.__cfspecRun(this, specFile)>
    <cfloop condition="nextTarget()">
      <cftry>
        <cfset _context.__cfspecRun(this, specFile)>
        <cfset ensureNoDelayedMatchersArePending()>
        <cfcatch type="cfspec">
          <cfset _report.addExample(listLast(cfcatch.type, '.'), "should #cfcatch.message#")>
          <cfset recoverFromException(listLast(cfcatch.type, "."))>
        </cfcatch>
        <cfcatch type="any">
          <cfset _report.addExample("fail", "should #_hint#", cfcatch)>
          <cfset recoverFromException("fail")>
        </cfcatch>
      </cftry>
      <cfset _context.__cfspecScrub()>
    </cfloop>
  </cffunction>



  <cffunction name="clearPendingException" output="false">
    <cfset _pendingException = "">
  </cffunction>



  <cffunction name="getPendingException" output="false">
    <cfreturn _pendingException>
  </cffunction>



  <cffunction name="setPendingException" output="false">
    <cfargument name="e">
    <cfset _pendingException = e>
  </cffunction>



  <cffunction name="flagDelayedMatcher" output="false">
    <cfargument name="flag" default="true">
    <cfset _inDelayedMatcher = flag>
  </cffunction>



  <cffunction name="flagExpectationEncountered" output="false">
    <cfargument name="flag" default="true">
    <cfset _hadAnExpectation = flag>
  </cffunction>



  <cffunction name="ensureNoExceptionsArePending" output="false">
    <cfif hasPendingException()>
      <cfthrow object="#getPendingException()#">
    </cfif>
  </cffunction>



  <cffunction name="ensureNoDelayedMatchersArePending" output="false">
    <cfif isInDelayedMatcher()>
      <cfset fail("encountered an incomplete expectation")>
    </cfif>
  </cffunction>



  <cffunction name="getBindings" output="false">
    <cfargument name="includeHidden" default="false">
    <cfreturn _context.__cfspecGetBindings(includeHidden)>
  </cffunction>



  <cffunction name="setBindings" output="false">
    <cfargument name="bindings">
    <cfset _context.__cfspecSetBindings(bindings)>
  </cffunction>



  <cffunction name="fail" output="false">
    <cfargument name="msg" default="">
    <cfif msg eq "">
      <cfset msg = _hint>
    <cfelse>
      <cfset msg = "#_hint#: #msg#">
    </cfif>
    <cfthrow type="cfspec.fail" message="#msg#">
  </cffunction>



  <cffunction name="pend" output="false">
    <cfargument name="msg" default="">
    <cfif msg eq "">
      <cfset msg = _hint>
    <cfelse>
      <cfset msg = "#_hint#: #msg#">
    </cfif>
    <cfthrow type="cfspec.pend" message="#msg#">
  </cffunction>



  <cffunction name="describeStartTag" output="false">
    <cfargument name="attributes">
    <cfset pushCurrent()>

    <cfif isTrial()>
      <cfreturn "exitTemplate">
    </cfif>

    <cfif not isInsideRunnable()>
      <cfset popCurrent()>
      <cfreturn "exitTag">
    </cfif>

    <cfif isStartRunnable()>
      <cfset _context.__cfspecPush()>
      <cfset _report.enterBlock(attributes.hint)>
    </cfif>

    <cfreturn "exitTemplate">
  </cffunction>



  <cffunction name="beforeAllStartTag" output="false">
    <cfargument name="attributes">
    <cfset _currentTag = "beforeAll">
    <cfif isTrial() or not isStartRunnable()>
      <cfreturn "exitTag">
    </cfif>
    <cfreturn "">
  </cffunction>



  <cffunction name="beforeAllEndTag" output="false">
    <cfargument name="attributes">
    <cfset _context.__cfspecSaveBindings()>
    <cfreturn "">
  </cffunction>



  <cffunction name="beforeStartTag" output="false">
    <cfargument name="attributes">
    <cfset _currentTag = "before">
    <cfif isTrial() or not isInsideRunnable()>
      <cfreturn "exitTag">
    </cfif>
    <cfreturn "">
  </cffunction>



  <cffunction name="beforeEndTag" output="false">
    <cfargument name="attributes">
    <cfreturn "">
  </cffunction>



  <cffunction name="itStartTag" output="false">
    <cfargument name="attributes">
    <cfset _currentTag = "it">
    <cfset stepCurrent()>

    <cfif isTrial()>
      <cfset makeTarget()>
      <cfreturn "exitTag">
    </cfif>

    <cfif _target eq _current>
      <cfset flagExpectationEncountered(false)>
    <cfelse>
      <cfreturn "exitTag">
    </cfif>

    <cfset _hint = attributes.should>
    <cfreturn "">
  </cffunction>



  <cffunction name="itEndTag" output="false">
    <cfargument name="attributes">
    <cfif not hasPendingException()>
      <cfset ensureNoDelayedMatchersArePending()>
      <cfset ensureAllMockExpectationsArePassing()>
      <cfif hadAnExpectation()>
        <cfset _specStats.incrementPassCount()>
        <cfset _report.addExample("pass", "should #attributes.should#")>
      <cfelse>
        <cfset pend("There were no expectations.")>
      </cfif>
    </cfif>
    <cfreturn "">
  </cffunction>



  <cffunction name="afterStartTag" output="false">
    <cfargument name="attributes">
    <cfset _currentTag = "after">
    <cfif isTrial() or not isInsideRunnable()>
      <cfreturn "exitTag">
    </cfif>
    <cfreturn "">
  </cffunction>



  <cffunction name="afterEndTag" output="false">
    <cfargument name="attributes">
    <cfreturn "">
  </cffunction>



  <cffunction name="afterAllStartTag" output="false">
    <cfargument name="attributes">
    <cfset _currentTag = "afterAll">
    <cfif isTrial() or not isEndRunnable()>
      <cfreturn "exitTag">
    </cfif>
    <cfreturn "">
  </cffunction>



  <cffunction name="afterAllEndTag" output="false">
    <cfargument name="attributes">
    <cfreturn "">
  </cffunction>



  <cffunction name="describeEndTag" output="false">
    <cfargument name="attributes">
    <cfset var status = "">

    <cfset ensureNoExceptionsArePending()>
    <cfset popCurrent()>

    <cfif isTrial() or not isEndRunnable()>
      <cfreturn "exitTag">
    </cfif>

    <cfset status = _context.__cfspecGetStatus()>
    <cfset _context.__cfspecPop()>
    <cfset _context.__cfspecMergeStatus(status)>

    <cfset _report.exitBlock()>
    <cfreturn "">
  </cffunction>



  <!--- PRIVATE --->



  <cffunction name="recoverFromException" access="private" output="false">
    <cfargument name="status">
    <cfset var level = "">

    <cfif status eq "pend">
      <cfset _specStats.incrementPendCount()>
      <cfset _context.__cfspecMergeStatus("pend")>
    </cfif>

    <cfset skipBrokenTargetsAfterException()>
    <cfset level = determineBadNestingLevelAfterException()>
    <cfset _context.__cfspecMergeStatus(status)>

    <cfloop condition="level gt 0">
      <cfset _context.__cfspecPop()>
      <cfset popCurrent()>
      <cfset _report.exitBlock()>
      <cfset level = level - 1>
    </cfloop>
  </cffunction>



  <cffunction name="skipBrokenTargetsAfterException" access="private" output="false">
    <cfif listFind("beforeAll,before,after,afterAll", _currentTag)>
      <cfloop condition="arrayLen(_targets) and find(reReplace(_current, '\d+$', ''), _targets[1]) eq 1">
        <cfset arrayDeleteAt(_targets, 1)>
      </cfloop>
    </cfif>
  </cffunction>



  <cffunction name="determineBadNestingLevelAfterException" access="private" output="false">
    <cfset var condition = "">
    <cfset var target = "">
    <cfset var i = 0>
    <cfif arrayLen(_targets)>
      <cfset target = _targets[1]>
    </cfif>

    <cfset condition = "(listLen(_current) gt i) and " &
                       "(listLen(target) gt i) and " &
                       "(listGetAt(_current, i + 1) eq listGetAt(target, i + 1))">

    <cfloop condition="#evaluate(condition)#">
      <cfset i = i + 1>
    </cfloop>
    <cfreturn listLen(_current) - i - 1>
  </cffunction>



  <cffunction name="resetContext" access="private" output="false">
    <cfset _context = createObject("component", "cfspec.lib.SpecContext").__cfspecInit()>
    <cfset _targets = arrayNew(1)>
    <cfset _target = "">
    <cfset _hint = "">
    <cfset resetCurrent()>
    <cfset clearPendingException()>
  </cffunction>



  <cffunction name="isTrial" access="private" output="false">
    <cfreturn _target eq "">
  </cffunction>



  <cffunction name="makeTarget" access="private" output="false">
    <cfset _specStats.incrementExampleCount()>
    <cfset arrayAppend(_targets, _current)>
  </cffunction>



  <cffunction name="nextTarget" access="private" output="false">
    <cfif arrayIsEmpty(_targets)>
      <cfreturn false>
    </cfif>
    <cfset resetCurrent()>
    <cfset flagDelayedMatcher(false)>
    <cfset _target = _targets[1]>
    <cfset arrayDeleteAt(_targets, 1)>
    <cfreturn true>
  </cffunction>



  <cffunction name="resetCurrent" access="private" output="false">
    <cfset _current = "0">
  </cffunction>



  <cffunction name="pushCurrent" access="private" output="false">
    <cfset stepCurrent()>
    <cfset _current = _current & ",0">
  </cffunction>



  <cffunction name="stepCurrent" access="private" output="false">
    <cfset var n = val(listLast(_current)) + 1>
    <cfset popCurrent()>
    <cfset _current = listAppend(_current, n)>
  </cffunction>



  <cffunction name="popCurrent" access="private" output="false">
    <cfset _current = reReplace(_current, "(^|,)\d+$", "")>
  </cffunction>



  <cffunction name="hasPendingException" access="private" output="false">
    <cfreturn not isSimpleValue(_pendingException)>
  </cffunction>



  <cffunction name="isInDelayedMatcher" access="private" output="false">
    <cfreturn _inDelayedMatcher>
  </cffunction>



  <cffunction name="hadAnExpectation" access="private" output="false">
    <cfreturn _hadAnExpectation>
  </cffunction>



  <cffunction name="ensureAllMockExpectationsArePassing" access="private" output="false">
    <cfset var bindings = getBindings()>
    <cfset var fullMessages = "">
    <cfset var messages = "">
    <cfset var key = "">
    <cfset var i = "">
    <cfloop collection="#bindings#" item="key">
      <cfif isObject(bindings[key]) and structKeyExists(bindings[key], "__cfspecGetFailureMessages")>
        <cfset flagExpectationEncountered()>
        <cfset messages = bindings[key].__cfspecGetFailureMessages()>
        <cfloop index="i" from="1" to="#arrayLen(messages)#">
          <cfset fullMessages = listAppend(fullMessages, messages[i], "<br />")>
        </cfloop>
      </cfif>
    </cfloop>
    <cfif fullMessages neq "">
      <cfset fail(fullMessages)>
    </cfif>
  </cffunction>



  <cffunction name="isStartRunnable" access="private" output="false">
    <cfset var base = reReplace(_current, "\d+$", "")>
    <cfreturn reFind(base & "1(,1)*$", _target) eq 1>
  </cffunction>



  <cffunction name="isInsideRunnable" access="private" output="false">
    <cfset var base = reReplace(_current, "\d+$", "")>
    <cfreturn find(base, _target) eq 1>
  </cffunction>



  <cffunction name="isEndRunnable" access="private" output="false">
    <cfif find(_current, _target) neq 1>
      <cfreturn false>
    </cfif>
    <cfif arrayLen(_targets) eq 0>
      <cfreturn true>
    </cfif>
    <cfreturn find(_current, _targets[1]) neq 1>
  </cffunction>



</cfcomponent>
