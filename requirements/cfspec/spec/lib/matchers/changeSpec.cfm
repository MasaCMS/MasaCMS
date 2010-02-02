<cfimport taglib="/cfspec" prefix="">

<describe hint="Change">

  <before>
    <cfset expectations = createObject("component", "cfspec.lib.EvalExpectations").__cfspecInit(__cfspecRunner, false)>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Change").init(""))>
    <cfset $matcher.setExpectations(expectations)>
    <cfset $matcher.setArguments("foo")>
    <cfset $matcher.setRunner(__cfspecRunner)>
  </before>

  <it should="match when the expression causes a change in the changee">
    <cfset foo = 1>
    <cfset $matcher.isMatch("foo = foo & foo").shouldBeTrue()>
  </it>

  <it should="not match when the expression does not cause a change in the changee">
    <cfset foo = 1>
    <cfset $matcher.isMatch("true").shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset foo = 1>
    <cfset $matcher.isMatch("true")>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to change 'foo', got unchanged")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset foo = 1>
    <cfset $matcher.isMatch("foo = foo & foo")>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to change 'foo', got changed")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("change 'foo'")>
  </it>

  <it should="match when results are the same except for case">
    <cfset foo = "bar">
    <cfset $matcher.isMatch("foo = uCase(foo)").shouldBeTrue()>
  </it>

  <describe hint="NoCase">

    <before>
      <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Change").init("NoCase"))>
      <cfset $matcher.setExpectations(expectations)>
      <cfset $matcher.setArguments("foo")>
      <cfset $matcher.setRunner(__cfspecRunner)>
    </before>

    <it should="not match when results are the same except for case">
      <cfset foo = "bar">
      <cfset $matcher.isMatch("foo = uCase(foo)").shouldBeFalse()>
    </it>

  </describe>

</describe>
