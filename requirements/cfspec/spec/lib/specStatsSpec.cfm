<cfimport taglib="/cfspec" prefix="">

<describe hint="SpecStats">

  <before>
    <cfset $specStats = $(createObject("component", "cfspec.lib.SpecStats").init())>
  </before>

  <it should="have a timer summary with between 0 and 1 seconds">
    <cfset sleep(100)>
    <cfset $specStats.getTimerSummary().shouldMatch("^0.\d+ seconds$")>
  </it>

  <describe hint="with no examples">

    <it should="have a status of 'pass'">
      <cfset $specStats.getStatus().shouldEqual("pass")>
    </it>

    <it should="have a counter summary that shows 0 examples">
      <cfset $specStats.getCounterSummary()
                       .shouldEqual("0 examples, 0 failures, 0 pending")>
    </it>

  </describe>

  <describe hint="with 1 passing example">

    <before>
      <cfset $specStats.incrementExampleCount()>
      <cfset $specStats.incrementPassCount()>
    </before>

    <it should="have a status of 'pass'">
      <cfset $specStats.getStatus().shouldEqual("pass")>
    </it>

    <it should="have a counter summary that shows 1 passing examples">
      <cfset $specStats.getCounterSummary()
                       .shouldEqual("1 example, 0 failures, 0 pending")>
    </it>

  </describe>

  <describe hint="with 1 pending example">

    <before>
      <cfset $specStats.incrementExampleCount()>
      <cfset $specStats.incrementPendCount()>
    </before>

    <it should="have a status of 'pend'">
      <cfset $specStats.getStatus().shouldEqual("pend")>
    </it>

    <it should="have a counter summary that shows 1 pending examples">
      <cfset $specStats.getCounterSummary()
                       .shouldEqual("1 example, 0 failures, 1 pending")>
    </it>

  </describe>

  <describe hint="with 1 failing example">

    <before>
      <cfset $specStats.incrementExampleCount()>
    </before>

    <it should="have a status of 'fail'">
      <cfset $specStats.getStatus().shouldEqual("fail")>
    </it>

    <it should="have a counter summary that shows 1 failing examples">
      <cfset $specStats.getCounterSummary()
                       .shouldEqual("1 example, 1 failure, 0 pending")>
    </it>

  </describe>

  <describe hint="with all 3 types of examples">

    <before>
      <cfset $specStats.incrementExampleCount()>
      <cfset $specStats.incrementPassCount()>
      <cfset $specStats.incrementExampleCount()>
      <cfset $specStats.incrementPassCount()>
      <cfset $specStats.incrementExampleCount()>
      <cfset $specStats.incrementPendCount()>
      <cfset $specStats.incrementExampleCount()>
      <cfset $specStats.incrementPendCount()>
      <cfset $specStats.incrementExampleCount()>
      <cfset $specStats.incrementExampleCount()>
    </before>

    <it should="have a status of 'fail'">
      <cfset $specStats.getStatus().shouldEqual("fail")>
    </it>

    <it should="have a counter summary that shows 2 passing, 2 failing and 2 pending examples">
      <cfset $specStats.getCounterSummary()
                       .shouldEqual("6 examples, 2 failures, 2 pending")>
    </it>

  </describe>

  <it should="reset all counters">
    <cfset $specStats.incrementExampleCount()>
    <cfset $specStats.incrementPassCount()>
    <cfset $specStats.incrementExampleCount()>
    <cfset $specStats.incrementPendCount()>
    <cfset $specStats.incrementExampleCount()>
    <cfset $specStats.reset()>
    <cfset $specStats.getCounterSummary()
                     .shouldEqual("0 examples, 0 failures, 0 pending")>
  </it>

</describe>
