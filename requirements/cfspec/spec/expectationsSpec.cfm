<cfimport taglib="/cfspec" prefix="">

<describe hint="Expectations">

  <describe hint="Be">

    <it should="expect shouldBeTrue to return true">
      <cfset $(true).shouldBeTrue()>
    </it>

    <it should="expect shouldBeFalse to return true">
      <cfset $(false).shouldBeFalse()>
    </it>

    <it should="expect shouldBeSimpleValue to return true">
      <cfset $("foo").shouldBeSimpleValue()>
    </it>

    <it should="expect shouldBeNumeric to return true">
      <cfset $(42).shouldBeNumeric()>
    </it>

    <it should="expect shouldBeDate to return true">
      <cfset $(now()).shouldBeDate()>
    </it>

    <it should="expect shouldBeBoolean to return true">
      <cfset $(false).shouldBeBoolean()>
    </it>

    <it should="expect shouldBeObject to return true">
      <cfset $(stub()).shouldBeObject()>
    </it>

    <it should="expect shouldBeStruct to return true">
      <cfset s = {foo=1, bar=2}>
      <cfset $(s).shouldBeStruct()>
    </it>

    <it should="expect shouldBeArray to return true">
      <cfset a = [1, 2, 3]>
      <cfset $(a).shouldBeArray()>
    </it>

    <it should="expect shouldBeQuery to return true">
      <cfset q = queryNew("")>
      <cfset queryAddColumn(q, "foo", listToArray("1,2"))>
      <cfset queryAddColumn(q, "bar", listToArray("3,4"))>
      <cfset $(q).shouldBeQuery()>
    </it>

    <it should="expect shouldBeBinary to return true">
      <cfset $(toBinary(toBase64("foo"))).shouldBeBinary()>
    </it>

    <it should="expect shouldBeGUID to return true">
      <cfset $("01234567-89AB-CDEF-0123-456789ABCDEF").shouldBeGUID()>
    </it>

    <it should="expect shouldBeUUID to return true">
      <cfset $("01234567-89AB-CDEF-0123456789ABCDEF").shouldBeUUID()>
    </it>

    <it should="expect shouldBeEmpty to return true">
      <cfset $("").shouldBeEmpty()>
    </it>

    <it should="expect shouldBeDefined to return true">
      <cfset foo = 1>
      <cfset $("foo").shouldBeDefined()>
    </it>

    <it should="expect shouldBeAnInstanceOf to return true">
      <cfset target = createObject("component", "cfspec.spec.assets.Widget")>
      <cfset $(target).shouldBeAnInstanceOf("cfspec.spec.assets.Widget")>
    </it>

    <it should="expect shouldBeArbitraryPredicate to return true">
      <cfset target = stub(isHappy=true)>
      <cfset $(target).shouldBeHappy()>
    </it>

  </describe>

  <describe hint="BeCloseTo">

    <it should="expect shouldBeCloseTo to return true">
      <cfset $(4.51).shouldBeCloseTo(5, 0.5)>
    </it>

  </describe>

  <describe hint="BeComparison">

    <it should="expect shouldBeLessThan to return true">
      <cfset $(5).shouldBeLessThan(6)>
    </it>

    <it should="expect shouldBeLessThanOrEqualTo to return true">
      <cfset $(5).shouldBeLessThanOrEqualTo(6)>
    </it>

    <it should="expect shouldBeGreaterThanOrEqualTo to return true">
      <cfset $(5).shouldBeGreaterThanOrEqualTo(4)>
    </it>

    <it should="expect shouldBeGreaterThan to return true">
      <cfset $(5).shouldBeGreaterThan(4)>
    </it>

    <it should="expect shouldBeBefore to return true">
      <cfset $("2001-03-15").shouldBeBefore("2001-08-05")>
    </it>

    <it should="expect shouldBeAfter to return true">
      <cfset $("2001-08-05").shouldBeAfter("2001-03-15")>
    </it>

  </describe>

  <describe hint="BeSame">

    <it should="expect shouldBe to return true">
      <cfset s = { foo=1, bar=2, baz=3 }>
      <cfset $(s).shouldBe(s)>
    </it>

  </describe>

  <describe hint="Change">

    <it should="expect shouldChange to return true">
      <cfset foo = "bar">
      <cfset $eval("foo = 'BAR'").shouldChange("foo")>
    </it>

    <it should="expect shouldChangeNoCase to return true">
      <cfset foo = "bar">
      <cfset $eval("foo = foo & foo").shouldChangeNoCase("foo")>
    </it>

    <it should="expect shouldChange.by(3) to return true">
      <cfset foo = 42>
      <cfset $eval("foo = 45").shouldChange("foo").by(3)>
    </it>

    <it should="expect shouldChange.byAtLeast(2) to return true">
      <cfset foo = 42>
      <cfset $eval("foo = 45").shouldChange("foo").byAtLeast(2)>
    </it>

    <it should="expect shouldChange.byAtMost(4) to return true">
      <cfset foo = 42>
      <cfset $eval("foo = 45").shouldChange("foo").byAtMost(4)>
    </it>

    <it should="expect shouldChange.from('bar').to('baz') to return true">
      <cfset foo = "bar">
      <cfset $eval("foo = 'baz'").shouldChange("foo").from("bar").to("baz")>
    </it>

    <it should="expect shouldChange multiple to return true">
      <cfset foo = "bar">
      <cfset $eval("foo = 'batz'").shouldChange("foo", "len(foo)")>
    </it>

  </describe>

  <describe hint="Contain">

    <it should="expect shouldContain to return true">
      <cfset $("life").shouldContain("if")>
    </it>

    <it should="expect shouldContainNoCase to return true">
      <cfset $("life").shouldContainNoCase("IF")>
    </it>

  </describe>

  <describe hint="Equal">

    <it should="expect shouldEqual to return true">
      <cfset $("foo").shouldEqual("foo")>
    </it>

    <it should="expect shouldEqualNoCase to return true">
      <cfset $("foo").shouldEqualNoCase("FOO")>
    </it>

    <it should="expect shouldEqualNumeric to return true">
      <cfset $(123).shouldEqualNumeric("123.0")>
    </it>

    <it should="expect shouldEqualDate to return true">
      <cfset $(createDate(1999, 12, 31)).shouldEqualDate("1999-12-31")>
    </it>

    <it should="expect shouldEqualBoolean to return true">
      <cfset $(true).shouldEqualBoolean(1)>
    </it>

    <it should="expect shouldEqualString to return true">
      <cfset $("foo").shouldEqualString("foo")>
    </it>

    <it should="expect shouldEqualStringNoCase to return true">
      <cfset $("foo").shouldEqualStringNoCase("FOO")>
    </it>

    <it should="expect shouldEqualObject to return true">
      <cfset target = createObject("component", "cfspec.spec.assets.SupportsEquals").init("foo")>
      <cfset actual = createObject("component", "cfspec.spec.assets.SupportsEquals").init("foo")>
      <cfset $(actual).shouldEqualObject(target)>
    </it>

    <it should="expect shouldEqualStruct to return true">
      <cfset target = {foo=1,bar='a',baz=true}>
      <cfset actual = {foo=1,bar='a',baz=true}>
      <cfset $(actual).shouldEqualStruct(target)>
    </it>

    <it should="expect shouldEqualStructNoCase to return true">
      <cfset target = {foo=1,bar='a',baz=true}>
      <cfset actual = {foo=1,bar='A',baz=true}>
      <cfset $(actual).shouldEqualStructNoCase(target)>
    </it>

    <it should="expect shouldEqualArray to return true">
      <cfset target = [1,'a',true]>
      <cfset actual = [1,'a',true]>
      <cfset $(actual).shouldEqualArray(target)>
    </it>

    <it should="expect shouldEqualArrayNoCase to return true">
      <cfset target = [1,'a',true]>
      <cfset actual = [1,'A',true]>
      <cfset $(actual).shouldEqualArrayNoCase(target)>
    </it>

    <it should="expect shouldEqualQuery to return true">
      <cfset target = queryNew("")>
      <cfset queryAddColumn(target, "foo", listToArray("a,b,c"))>
      <cfset queryAddColumn(target, "bar", listToArray("d,e,f"))>
      <cfset queryAddColumn(target, "baz", listToArray("g,h,i"))>
      <cfset actual = queryNew("")>
      <cfset queryAddColumn(actual, "foo", listToArray("a,b,c"))>
      <cfset queryAddColumn(actual, "bar", listToArray("d,e,f"))>
      <cfset queryAddColumn(actual, "baz", listToArray("g,h,i"))>
      <cfset $(actual).shouldEqualQuery(target)>
    </it>

    <it should="expect shouldEqualQueryNoCase to return true">
      <cfset target = queryNew("")>
      <cfset queryAddColumn(target, "foo", listToArray("a,b,c"))>
      <cfset queryAddColumn(target, "bar", listToArray("d,e,f"))>
      <cfset queryAddColumn(target, "baz", listToArray("g,h,i"))>
      <cfset actual = queryNew("")>
      <cfset queryAddColumn(actual, "foo", listToArray("a,b,c"))>
      <cfset queryAddColumn(actual, "bar", listToArray("d,E,f"))>
      <cfset queryAddColumn(actual, "baz", listToArray("g,h,i"))>
      <cfset $(actual).shouldEqualQueryNoCase(target)>
    </it>

  </describe>

  <describe hint="Have">

    <it should="expect shouldHave(n) to return a delayed matcher, and true when items() is called on it">
      <cfset $(listToArray("a,b,c")).shouldHave(3).items()>
    </it>

    <it should="expect shouldHaveExactly(n) to return a delayed matcher, and true when items() is called on it">
      <cfset $(listToArray("a,b,c")).shouldHaveExactly(3).items()>
    </it>

    <it should="expect shouldHaveAtLeast(n) to return a delayed matcher, and true when items() is called on it">
      <cfset $(listToArray("a,b,c")).shouldHaveAtLeast(3).items()>
    </it>

    <it should="expect shouldHaveAtMost(n) to return a delayed matcher, and true when items() is called on it">
      <cfset $(listToArray("a,b,c")).shouldHaveAtMost(3).items()>
    </it>

  </describe>

  <describe hint="Match">

    <it should="expect shouldMatch to return true">
      <cfset $("The quick brown fox...").shouldMatch("quick (\w+) fox")>
    </it>

    <it should="expect shouldMatchNoCase to return true">
      <cfset $("The quick brown fox...").shouldMatchNoCase("QUICK (\w+) FOX")>
    </it>

  </describe>

  <describe hint="RespondTo">

    <it should="expect shouldRespondTo to return true">
      <cfset $(stub()).shouldRespondTo("onMissingMethod")>
    </it>

  </describe>

  <describe hint="Negated Expectations (one example should be sufficient)">

    <it should="expect shouldNotEqual to return true">
      <cfset $("foo").shouldNotEqual("FOO")>
    </it>

  </describe>

  <describe hint="Pending">

    <it should="pend explicitly">
      <cfset $eval("pend('This test is not yet implemented ;-)')").shouldThrow("cfspec.pend")>
    </it>

    <it should="pend because there are no expectations">
      <cfset runner = createObject("component", "cfspec.lib.SpecRunner").init()>
      <cfset report = createObject("component", "cfspec.lib.HtmlReport").init()>
      <cfset stats = createObject("component", "cfspec.lib.SpecStats").init()>
      <cfset runner.setReport(report)>
      <cfset runner.setSpecStats(stats)>
      <cfset runner.runSpecFile(expandPath("/cfspec/spec/assets/specWithoutExpectation.cfm"))>
      <cfset $(report.getOutput()).shouldHaveTag("div[@class='summary' and text()='1 example, 0 failures, 1 pending']")>
    </it>

  </describe>

  <describe hint="Failures">

    <it should="expect shouldEqual to fail">
      <cfset $eval("$('foo').shouldEqual('FOO')").shouldThrow("cfspec.fail")>
    </it>

    <it should="expect shouldNotEqualNoCase to fail">
      <cfset $eval("$('foo').shouldNotEqualNoCase('FOO')").shouldThrow("cfspec.fail")>
    </it>

    <it should="expect shouldHave(n).items() to fail">
      <cfset $eval("$(listToArray('a,b,c')).shouldHave(4).items()").shouldThrow("cfspec.fail")>
    </it>

    <it should="fail because there is a delayed matcher without completion">
      <cfset runner = createObject("component", "cfspec.lib.SpecRunner").init()>
      <cfset report = createObject("component", "cfspec.lib.HtmlReport").init()>
      <cfset stats = createObject("component", "cfspec.lib.SpecStats").init()>
      <cfset runner.setReport(report)>
      <cfset runner.setSpecStats(stats)>
      <cfset runner.runSpecFile(expandPath("/cfspec/spec/assets/specWithPendingDelayedMatcher.cfm"))>
      <cfset $(report.getOutput()).shouldHaveTag("div[@class='summary' and text()='1 example, 1 failure, 0 pending']")>
    </it>

    <it should="fail because there is a mock expectation that is never called">
      <cfset runner = createObject("component", "cfspec.lib.SpecRunner").init()>
      <cfset report = createObject("component", "cfspec.lib.HtmlReport").init()>
      <cfset stats = createObject("component", "cfspec.lib.SpecStats").init()>
      <cfset runner.setReport(report)>
      <cfset runner.setSpecStats(stats)>
      <cfset runner.runSpecFile(expandPath("/cfspec/spec/assets/specWithFailingMockExpectation.cfm"))>
      <cfset $(report.getOutput()).shouldHaveTag("div[@class='summary' and text()='6 examples, 4 failures, 0 pending']")>
    </it>

  </describe>

  <describe hint="Exceptions">

    <it should="expect nonExistantMethod() on an object to throw an exception">
      <cfset target = createObject("component", "cfspec.spec.assets.Widget")>
      <cfset $eval("$(target).nonExistantMethod()").shouldThrow("Application")>
    </it>

    <it should="expect nonExistantMethod() on an object chained by another expectation to throw an exception">
      <cfset target = createObject("component", "cfspec.spec.assets.Widget")>
      <cfset $eval("$(target).nonExistantMethod().shouldBeAnInstanceOf('cfspec.spec.assets.Widget')").shouldThrow("Application")>
    </it>

    <it should="expect nonExistantMethod() on an object followed by another met expectation to throw an exception">
      <cfset target = createObject("component", "cfspec.spec.assets.Widget")>
      <cfset $(target).nonExistantMethod()>
      <cfset $eval("$(target).shouldBeAnInstanceOf('cfspec.spec.assets.Widget')").shouldThrow("Application")>
    </it>

    <it should="expect nonExistantMethod() on a simple value to throw an exception">
      <cfset $eval("$('foo').nonExistantMethod()").shouldThrow("Application")>
    </it>

  </describe>

</describe>
