<cfimport taglib="/cfspec" prefix="">

<describe hint="Be Same">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.BeSame").init())>
  </before>

  <it should="match when actual and expected are equivalent simple values">
    <cfset $matcher.setArguments("foo")>
    <cfset $matcher.isMatch("foo").shouldBeTrue()>
  </it>

  <it should="not match when actual and expected are different simple values">
    <cfset $matcher.setArguments("foo")>
    <cfset $matcher.isMatch("bar").shouldBeFalse()>
  </it>

  <it should="match when actual and expected are the exact same object">
    <cfset o = stub()>
    <cfset $matcher.setArguments(o)>
    <cfset $matcher.isMatch(o).shouldBeTrue()>
  </it>

  <it should="not match when actual and expected are different objects that are equal">
    <cfset o1 = stub(isEqualTo=true)>
    <cfset o2 = stub(isEqualTo=true)>
    <cfset $matcher.setArguments(o1)>
    <cfset $matcher.isMatch(o2).shouldBeFalse()>
  </it>

  <it should="match when actual and expected are the exact same struct">
    <cfset s = { foo=1, bar=2, baz=3 }>
    <cfset $matcher.setArguments(s)>
    <cfset $matcher.isMatch(s).shouldBeTrue()>
  </it>

  <it should="not match when actual and expected are different structs that are equal">
    <cfset s1 = { foo=1, bar=2, baz=3 }>
    <cfset s2 = { foo=1, bar=2, baz=3 }>
    <cfset $matcher.setArguments(s1)>
    <cfset $matcher.isMatch(s2).shouldBeFalse()>
  </it>

  <it should="match when actual and expected are the exact same array">
    <cfset a = createObject("java", "java.util.ArrayList").init()>
    <cfset a.add("foo")><cfset a.add("bar")><cfset a.add("baz")>
    <cfset $matcher.setArguments(a)>
    <cfset $matcher.isMatch(a).shouldBeTrue()>
  </it>

  <it should="not match when actual and expected are different arrays that are equal">
    <cfset a1 = createObject("java", "java.util.ArrayList").init()>
    <cfset a1.add("foo")><cfset a1.add("bar")><cfset a1.add("baz")>
    <cfset a2 = createObject("java", "java.util.ArrayList").init()>
    <cfset a2.add("foo")><cfset a2.add("bar")><cfset a2.add("baz")>
    <cfset $matcher.setArguments(a1)>
    <cfset $matcher.isMatch(a2).shouldBeFalse()>
  </it>

  <it should="match when actual and expected are the exact same query">
    <cfset q = queryNew("foo,bar,baz")>
    <cfset $matcher.setArguments(q)>
    <cfset $matcher.isMatch(q).shouldBeTrue()>
  </it>

  <it should="not match when actual and expected are different queries that are equal">
    <cfset q1 = queryNew("foo,bar,baz")>
    <cfset q2 = queryNew("foo,bar,baz")>
    <cfset $matcher.setArguments(q1)>
    <cfset $matcher.isMatch(q2).shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset s1 = { foo=1, bar=2, baz=3 }>
    <cfset s2 = { foo=1, bar=2, baz=3 }>
    <cfset $matcher.setArguments(s1)>
    <cfset $matcher.isMatch(s2)>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to be the same, got different (native arrays are always different)")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset s = { foo=1, bar=2, baz=3 }>
    <cfset $matcher.setArguments(s)>
    <cfset $matcher.isMatch(s)>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to be different, got the same (equivalent simple values are usually the same)")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("be the same")>
  </it>

</describe>