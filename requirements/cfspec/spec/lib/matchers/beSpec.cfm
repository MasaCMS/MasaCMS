<cfimport taglib="/cfspec" prefix="">

<describe hint="Be True">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("True"))>
  </before>

  <it should="match when actual is true">
    <cfset $matcher.isMatch(true).shouldBeTrue()>
  </it>

  <it should="not match when actual is false">
    <cfset $matcher.isMatch(false).shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch(false)>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to be true, got false")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset $matcher.isMatch(true)>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to be true, got true")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("be true")>
  </it>

  <describe hint="bad types">

    <it should="provide a useful failure message if actual is non-boolean">
      <cfset $matcher.isMatch(stub()).shouldThrow("cfspec.fail", "BeTrue expected a boolean, got")>
    </it>

  </describe>

</describe>

<describe hint="Be False">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("False"))>
  </before>

  <it should="match when actual is false">
    <cfset $matcher.isMatch(false).shouldBeTrue()>
  </it>

  <it should="not match when actual is true">
    <cfset $matcher.isMatch(true).shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch(true)>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to be false, got true")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset $matcher.isMatch(false)>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to be false, got false")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("be false")>
  </it>

  <describe hint="bad types">

    <it should="provide a useful failure message if actual is non-boolean">
      <cfset $matcher.isMatch("").shouldThrow("cfspec.fail", "BeFalse expected a boolean, got")>
    </it>

  </describe>

</describe>

<describe hint="Be SimpleValue">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("SimpleValue"))>
  </before>

  <it should="match when actual is a simple value">
    <cfset $matcher.isMatch("foo").shouldBeTrue()>
  </it>

  <it should="not match when actual is not a simple value">
    <cfset $matcher.isMatch(stub()).shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch(stub())>
    <cfset $matcher.getFailureMessage().shouldMatch("expected to be a simple value, got &lt;(cfspec\.lib\.)?Mock:\?\?\?&gt;")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset $matcher.isMatch("foo")>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to be a simple value, got 'foo'")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("be a simple value")>
  </it>

</describe>

<describe hint="Be Numeric">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("Numeric"))>
  </before>

  <it should="match when actual is numeric">
    <cfset $matcher.isMatch(42).shouldBeTrue()>
  </it>

  <it should="not match when actual is not numeric">
    <cfset $matcher.isMatch("foo").shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch("foo")>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to be numeric, got 'foo'")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset $matcher.isMatch(42)>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to be numeric, got 42")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("be numeric")>
  </it>

</describe>

<describe hint="Be Date">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("Date"))>
  </before>

  <it should="match when actual is a date">
    <cfset $matcher.isMatch(now()).shouldBeTrue()>
  </it>

  <it should="not match when actual is not a date">
    <cfset $matcher.isMatch("foo").shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch("foo")>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to be a date, got 'foo'")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset $matcher.isMatch(createDate(2009, 1, 6))>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to be a date, got 2009-01-06 12:00 AM")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("be a date")>
  </it>

</describe>

<describe hint="Be Boolean">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("Boolean"))>
  </before>

  <it should="match when actual is a boolean">
    <cfset $matcher.isMatch(true).shouldBeTrue()>
  </it>

  <it should="not match when actual is not a boolean">
    <cfset $matcher.isMatch("foo").shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch("foo")>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to be a boolean, got 'foo'")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset $matcher.isMatch(false)>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to be a boolean, got false")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("be a boolean")>
  </it>

</describe>

<describe hint="Be Object">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("Object"))>
  </before>

  <it should="match when actual is an object">
    <cfset $matcher.isMatch(stub()).shouldBeTrue()>
  </it>

  <it should="not match when actual is not an object">
    <cfset $matcher.isMatch("foo").shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch("foo")>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to be an object, got 'foo'")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset $matcher.isMatch(stub())>
    <cfset $matcher.getNegativeFailureMessage().shouldMatch("expected not to be an object, got &lt;(cfspec\.lib\.)?Mock:\?\?\?&gt;")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("be an object")>
  </it>

</describe>

<describe hint="Be Struct">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("Struct"))>
  </before>

  <it should="match when actual is a struct">
    <cfset s = {foo=1, bar=2}>
    <cfset $matcher.isMatch(s).shouldBeTrue()>
  </it>

  <it should="not match when actual is not a struct">
    <cfset $matcher.isMatch("foo").shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch("foo")>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to be a struct, got 'foo'")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset s = {foo=1, bar=2}>
    <cfset $matcher.isMatch(s)>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to be a struct, got {BAR=2,FOO=1}")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("be a struct")>
  </it>

</describe>

<describe hint="Be Array">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("Array"))>
  </before>

  <it should="match when actual is an array">
    <cfset a = [1, 2, 3]>
    <cfset $matcher.isMatch(a).shouldBeTrue()>
  </it>

  <it should="not match when actual is not an array">
    <cfset $matcher.isMatch("foo").shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch("foo")>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to be an array, got 'foo'")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset a = [1, 2, 3]>
    <cfset $matcher.isMatch(a)>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to be an array, got [1,2,3]")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("be an array")>
  </it>

</describe>

<describe hint="Be Query">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("Query"))>
  </before>

  <it should="match when actual is a query">
    <cfset q = queryNew("")>
    <cfset queryAddColumn(q, "foo", listToArray("1,2"))>
    <cfset queryAddColumn(q, "bar", listToArray("3,4"))>
    <cfset $matcher.isMatch(q).shouldBeTrue()>
  </it>

  <it should="not match when actual is not a query">
    <cfset $matcher.isMatch("foo").shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch("foo")>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to be a query, got 'foo'")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset q = queryNew("")>
    <cfset queryAddColumn(q, "foo", listToArray("1,2"))>
    <cfset queryAddColumn(q, "bar", listToArray("3,4"))>
    <cfset $matcher.isMatch(q)>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to be a query, got {COLUMNS=['BAR','FOO'],DATA=[[3,1],[4,2]]}")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("be a query")>
  </it>

</describe>

<describe hint="Be Binary">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("Binary"))>
    <cfset binaryFoo = toBinary(toBase64("foo"))>
  </before>

  <it should="match when actual is binary">
    <cfset $matcher.isMatch(binaryFoo).shouldBeTrue()>
  </it>

  <it should="not match when actual is not binary">
    <cfset $matcher.isMatch("foo").shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch("foo")>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to be binary, got 'foo'")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset $matcher.isMatch(binaryFoo)>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to be binary, got [102,111,111]")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("be binary")>
  </it>

</describe>

<describe hint="Be GUID">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("GUID"))>
    <cfset myGUID = "01234567-89AB-CDEF-0123-456789ABCDEF">
  </before>

  <it should="match when actual is a GUID">
    <cfset $matcher.isMatch(myGUID).shouldBeTrue()>
  </it>

  <it should="not match when actual is not a GUID">
    <cfset $matcher.isMatch("foo").shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch("foo")>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to be a valid guid, got 'foo'")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset $matcher.isMatch(myGUID)>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to be a valid guid, got '#myGUID#'")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("be a valid guid")>
  </it>

</describe>

<describe hint="Be UUID">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("UUID"))>
    <cfset myUUID = "01234567-89AB-CDEF-0123456789ABCDEF">
  </before>

  <it should="match when actual is a UUID">
    <cfset $matcher.isMatch(myUUID).shouldBeTrue()>
  </it>

  <it should="not match when actual is not a UUID">
    <cfset $matcher.isMatch("foo").shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch("foo")>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to be a valid uuid, got 'foo'")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset $matcher.isMatch(myUUID)>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to be a valid uuid, got '#myUUID#'")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("be a valid uuid")>
  </it>

</describe>

<describe hint="Be Empty">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("Empty"))>
  </before>

  <it should="match when target is a string of whitespace characters">
    <cfset $matcher.isMatch("#chr(9)#  #chr(10)##chr(13)#").shouldBeTrue()>
  </it>

  <it should="not match when target is a string with non-whitespace characters">
    <cfset $matcher.isMatch("  x  ").shouldBeFalse()>
  </it>

  <it should="match when actual is an object with isEmpty() == true">
    <cfset target = stub(isEmpty=true)>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="not match when actual is an object with isEmpty() == false">
    <cfset target = stub(isEmpty=false)>
    <cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="match when actual is a struct with no keys">
    <cfset target = {}>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="not match when actual is a struct with 1+ keys">
    <cfset target = {foo=1}>
    <cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="match when actual is an array with no elements">
    <cfset target = []>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="not match when actual is an array with 1+ elements">
    <cfset target = [1]>
    <cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="match when actual is a query with no records">
    <cfset target = queryNew("foo")>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="not match when actual is a query with 1+ records">
    <cfset target = queryNew("")>
    <cfset queryAddColumn(target, "foo", listToArray("1"))>
    <cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch("abc")>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to be empty, got 'abc'")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset $matcher.isMatch("   ")>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to be empty, got '   '")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("be empty")>
  </it>

  <describe hint="bad types">

    <it should="provide a useful failure message if target.isEmpty() returns a non-boolean">
      <cfset $matcher.isMatch(stub(isEmpty="foo")).shouldThrow("cfspec.fail", "BeEmpty expected target.isEmpty() to return a boolean, got")>
    </it>

    <it should="provide a useful failure message if actual doesn't implement isEmpty">
      <cfset $matcher.isMatch(stub()).shouldThrow("cfspec.fail", "BeEmpty expected target.isEmpty() to return a boolean, but the method was not found.")>
    </it>

  </describe>

</describe>

<describe hint="Be Defined">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("Defined"))>
    <cfset $matcher.setRunner(__cfspecRunner)>
  </before>

  <it should="match if target is a defined variable name">
    <cfset foo = 1>
    <cfset $matcher.isMatch("foo").shouldBeTrue()>
  </it>

  <it should="not match if target is not a defined variable name">
    <cfset $matcher.isMatch("foo").shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch("foo")>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to be defined, got false")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset foo = 1>
    <cfset $matcher.isMatch("foo")>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to be defined, got true")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("be defined")>
  </it>

</describe>

<describe hint="Be AnInstanceOf">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("AnInstanceOf"))>
    <cfset $matcher.setArguments("cfspec.spec.assets.Widget")>
  </before>

  <it should="match if target is an instance of the expected class">
    <cfset target = createObject("component", "cfspec.spec.assets.Widget")>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match if target is an instance of a decendant class">
    <cfset target = createObject("component", "cfspec.spec.assets.SpecialWidget")>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="not match if target is not an instance of the expected class">
    <cfset target = stub()>
    <cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset target = stub()>
    <cfset $matcher.isMatch(target)>
    <cfset $matcher.getFailureMessage().shouldMatch("expected to be an instance of 'cfspec\.spec\.assets\.Widget', got '(cfspec\.lib\.)?Mock'")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset target = createObject("component", "cfspec.spec.assets.Widget")>
    <cfset $matcher.isMatch(target)>
    <cfset $matcher.getNegativeFailureMessage().shouldMatch("expected not to be an instance of 'cfspec.spec.assets.Widget', got '(cfspec\.spec\.assets\.)?Widget'")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("be an instance of 'cfspec.spec.assets.Widget'")>
  </it>

</describe>

<describe hint="Be ArbitraryPredicate">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("Happy"))>
  </before>

  <it should="match when target.isHappy() returns true">
    <cfset target = stub(isHappy=true)>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="not match when target.isHappy() returns false">
    <cfset target = stub(isHappy=false)>
    <cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset target = stub(isHappy=false)>
    <cfset $matcher.isMatch(target)>
    <cfset $matcher.getFailureMessage().shouldEqual("expected isHappy() to be true, got false")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset target = stub(isHappy=true)>
    <cfset $matcher.isMatch(target)>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected isHappy() to be false, got true")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("isHappy() to be true")>
  </it>

  <describe hint="with arguments">

    <before>
      <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("InMood"))>
      <cfset $matcher.setArguments("happy", 42)>
    </before>

    <it should="match when target.isInMood('happy', 42) returns true">
      <cfset target = createObject("component", "cfspec.spec.assets.HappyGuy")>
      <cfset $matcher.isMatch(target).shouldBeTrue()>
    </it>

    <it should="not match when target.isInMood('happy', 42) returns false">
      <cfset target = createObject("component", "cfspec.spec.assets.SadGuy")>
      <cfset $matcher.isMatch(target).shouldBeFalse()>
    </it>

    <it should="provide a useful failure message">
      <cfset target = createObject("component", "cfspec.spec.assets.SadGuy")>
      <cfset $matcher.isMatch(target)>
      <cfset $matcher.getFailureMessage().shouldEqual("expected isInMood('happy',42) to be true, got false")>
    </it>

    <it should="provide a useful negative failure message">
      <cfset target = createObject("component", "cfspec.spec.assets.HappyGuy")>
      <cfset $matcher.isMatch(target)>
      <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected isInMood('happy',42) to be false, got true")>
    </it>

    <it should="describe itself">
      <cfset $matcher.getDescription().shouldEqual("isInMood('happy',42) to be true")>
    </it>

    <describe hint="bad types">

      <it should="provide a useful failure message if target.isPredicate() returns a non-boolean">
        <cfset $matcher.isMatch(stub(isInMood="foo")).shouldThrow("cfspec.fail", "BeInMood expected target.isInMood('happy',42) to return a boolean, got")>
      </it>

      <it should="provide a useful failure message if actual doesn't implement isPredicate">
        <cfset $matcher.isMatch(stub()).shouldThrow("cfspec.fail", "BeInMood expected target.isInMood('happy',42) to return a boolean, but the method was not found.")>
      </it>

    </describe>

  </describe>

</describe>
