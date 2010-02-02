<cfimport taglib="/cfspec" prefix="">

<describe hint="Contain">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Contain").init(""))>
    <cfset $matcher.setArguments("in")>
  </before>

  <it should="match when actual contains expected">
    <cfset $matcher.isMatch("splinter").shouldBeTrue()>
  </it>

  <it should="not match when actual does not contain expected">
    <cfset $matcher.isMatch("Interest").shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch("Interest")>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to contain 'in', got 'Interest'")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset $matcher.isMatch("splinter")>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to contain 'in', got 'splinter'")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("contain 'in'")>
  </it>

  <describe hint="NoCase">

    <before>
      <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Contain").init("NoCase"))>
      <cfset $matcher.setArguments("in")>
    </before>

    <it should="match when target matches actual (case-insensitive)">
      <cfset $matcher.isMatch("Interest").shouldBeTrue()>
    </it>

  </describe>

</describe>

<describe hint="Contain (complex types)">

  <it should="match when an array contains the expected value">
    <cfset a = [1, 2, 3]>
    <cfset $(a).shouldContain(3)>
  </it>

  <it should="not match when an array does not contain the expected value">
    <cfset a = [1, 2, 3]>
    <cfset $(a).shouldNotContain(4)>
  </it>

  <it should="match when an object contains the expected value">
    <cfset $(stub(hasElement=true)).shouldContain(3)>
  </it>

  <it should="not match when an object does not contain the expected value">
    <cfset $(stub(hasElement=false)).shouldNotContain(4)>
  </it>

  <it should="match when a struct contains the expected key">
    <cfset s = {foo=1, bar=2, baz=3}>
    <cfset $(s).shouldContain("bar")>
  </it>

  <it should="not match when a struct does not contain the expected key">
    <cfset s = {foo=1, bar=2, baz=3}>
    <cfset $(s).shouldNotContain("bat")>
  </it>

  <it should="match when a struct contains the expected key/value pairs">
    <cfset s = {foo=1, bar=2, baz=3}>
    <cfset e = {foo=1, baz=3}>
    <cfset $(s).shouldContain(e)>
  </it>

  <it should="not match when a struct does not contain the expected key/value pairs (because of missing key)">
    <cfset s = {foo=1, bar=2, baz=3}>
    <cfset e = {foo=1, bat=3}>
    <cfset $(s).shouldNotContain(e)>
  </it>

  <it should="not match when a struct does not contain the expected key/value pairs (because of incorrect value)">
    <cfset s = {foo=1, bar=2, baz=3}>
    <cfset e = {foo=1, bar=3}>
    <cfset $(s).shouldNotContain(e)>
  </it>

  <it should="match when a query contains the expected colunn">
    <cfset q = queryNew("foo,bar,baz")>
    <cfset $(q).shouldContain("bar")>
  </it>

  <it should="not match when a query does not contain the expected colunn">
    <cfset q = queryNew("foo,bar,baz")>
    <cfset $(q).shouldNotContain("bat")>
  </it>

  <it should="match when a query contains the expected struct">
    <cfset q = queryNew("")>
    <cfset queryAddColumn(q, "foo", listToArray("1,2,3"))>
    <cfset queryAddColumn(q, "bar", listToArray("4,5,6"))>
    <cfset queryAddColumn(q, "baz", listToArray("7,8,9"))>
    <cfset s = {foo=2, bar=5, baz=8}>
    <cfset $(q).shouldContain(s)>
  </it>

  <it should="not match when a query does not contain the expected struct (because column name)">
    <cfset q = queryNew("")>
    <cfset queryAddColumn(q, "foo", listToArray("1,2,3"))>
    <cfset queryAddColumn(q, "bar", listToArray("4,5,6"))>
    <cfset queryAddColumn(q, "baz", listToArray("7,8,9"))>
    <cfset s = {foo=2, bar=5, bat=8}>
    <cfset $(q).shouldNotContain(s)>
  </it>

  <it should="not match when a query does not contain the expected struct (because values)">
    <cfset q = queryNew("")>
    <cfset queryAddColumn(q, "foo", listToArray("1,2,3"))>
    <cfset queryAddColumn(q, "bar", listToArray("4,5,6"))>
    <cfset queryAddColumn(q, "baz", listToArray("7,8,9"))>
    <cfset s = {foo=2, bar=5, baz=7}>
    <cfset $(q).shouldNotContain(s)>
  </it>

</describe>

<describe hint="Contain (multiple, arguments)">

  <it should="match when actual contains each of the expected arguments">
    <cfset $("california").shouldContain("if", "for", "cali")>
    <cfset a = [1, 2, 3]>
    <cfset $(a).shouldContain(1, 2, 3)>
    <cfset s = {foo=1, bar=2, baz=3}>
    <cfset $(s).shouldContain("foo", "bar", "baz")>
    <cfset e = {foo=1, baz=3}>
    <cfset $(s).shouldContain("foo", e)>
  </it>

  <it should="not match when actual does not contain all of the expected arguments">
    <cfset $("california").shouldNotContain("if", "foo", "cali")>
    <cfset a = [1, 2, 3]>
    <cfset $(a).shouldNotContain(1, 2, 4)>
    <cfset s = {foo=1, bar=2, baz=3}>
    <cfset $(s).shouldNotContain("foo", "bar", "bat")>
    <cfset e = {foo=1, bar=3}>
    <cfset $(s).shouldNotContain("foo", e)>
  </it>

</describe>
