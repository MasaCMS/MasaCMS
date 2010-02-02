<cfimport taglib="/cfspec" prefix="">

<describe hint="Mock (stubbing with arguments)">

  <before>
    <cfset $mock = $(createObject("component", "cfspec.lib.Mock").__cfspecInit("myStub"))>
  </before>

  <it should="return different values for different arguments">
    <cfset $mock.stubs("foo").with(true).returns("bar")>
    <cfset $mock.stubs("foo").with(false).returns("baz")>
    <cfset $mock.foo(false).shouldEqual("baz")>
    <cfset $mock.foo(true).shouldEqual("bar")>
  </it>

  <it should="throw an exception if arguments do not match">
    <cfset $mock.stubs("foo").with(true).returns("bar")>
    <cfset $mock.foo(false).shouldThrow()>
  </it>

  <it should="throw an exception if too many arguments">
    <cfset $mock.stubs("foo").with().returns("bar")>
    <cfset $mock.foo(true).shouldThrow()>
  </it>

  <it should="throw an exception if too few arguments">
    <cfset $mock.stubs("foo").with(true).returns("bar")>
    <cfset $mock.foo().shouldThrow()>
  </it>

  <it should="meet multiple expectations when called with more specific arguments">
    <cfset $mock.expects("foo").returns("bar")>
    <cfset $mock.expects("foo").with(true).returns("baz")>
    <cfset $mock.foo(true).shouldEqual("baz")>
    <cfset $mock.__cfspecGetFailureMessages().shouldBeEmpty()>
  </it>

  <it should="recognize an eval-based argument matcher">
    <cfset $mock.stubs("foo").withEval("arrayLen(arguments) mod 2 eq 0").returns("even")>
    <cfset $mock.stubs("foo").withEval("arrayLen(arguments) mod 2 eq 1").returns("odd")>
    <cfset $mock.foo().shouldEqual("even")>
    <cfset $mock.foo(0).shouldEqual("odd")>
    <cfset $mock.foo(0, 0).shouldEqual("even")>
    <cfset $mock.foo(0, 0, 0).shouldEqual("odd")>
  </it>

  <describe hint="anyArguments">

    <it should="return different values for different arguments">
      <cfset $mock.stubs("foo").with(1, anyArguments()).returns("one")>
      <cfset $mock.stubs("foo").with(2, anyArguments()).returns("two")>
      <cfset $mock.foo(1, 2, 3, 4).shouldEqual("one")>
      <cfset $mock.foo(2, 3, 4).shouldEqual("two")>
    </it>

    <it should="allow no arguments">
      <cfset $mock.stubs("foo").with(anyArguments()).returns("one")>
      <cfset $mock.foo().shouldEqual("one")>
    </it>

    <it should="allow no extra arguments">
      <cfset $mock.stubs("foo").with(1, anyArguments()).returns("one")>
      <cfset $mock.foo(1).shouldEqual("one")>
    </it>

    <it should="throw an exception if too few arguments">
      <cfset $mock.stubs("foo").with(1, anyArguments()).returns("one")>
      <cfset $mock.foo().shouldThrow()>
    </it>

    <it should="meet multiple expectations when called with more specific arguments">
      <cfset $mock.expects("foo").returns("bar")>
      <cfset $mock.expects("foo").with(anyArguments()).returns("baz")>
      <cfset $mock.foo(2).shouldEqual("baz")>
      <cfset $mock.__cfspecGetFailureMessages().shouldBeEmpty()>
    </it>

  </describe>

  <describe hint="anything">

    <it should="return different values for different arguments">
      <cfset $mock.stubs("foo").with(anything()).returns("one")>
      <cfset $mock.stubs("foo").with(anything(), anything()).returns("two")>
      <cfset $mock.foo(1, 2).shouldEqual("two")>
      <cfset $mock.foo(1).shouldEqual("one")>
    </it>

    <it should="throw an exception if too many arguments">
      <cfset $mock.stubs("foo").with(anything()).returns("one")>
      <cfset $mock.foo(2, true).shouldThrow()>
    </it>

    <it should="throw an exception if too few arguments">
      <cfset $mock.stubs("foo").with(anything()).returns("one")>
      <cfset $mock.foo().shouldThrow()>
    </it>

    <it should="meet multiple expectations when called with more specific arguments">
      <cfset $mock.expects("foo").returns("bar")>
      <cfset $mock.expects("foo").with(anything()).returns("baz")>
      <cfset $mock.foo(2).shouldEqual("baz")>
      <cfset $mock.__cfspecGetFailureMessages().shouldBeEmpty()>
    </it>

  </describe>

  <describe hint="anyOf">

    <it should="return different values for different arguments">
      <cfset $mock.stubs("foo").with(anyOf(1, 3, 5)).returns("odd")>
      <cfset $mock.stubs("foo").with(anyOf(2, 4, 6)).returns("even")>
      <cfset $mock.foo(5).shouldEqual("odd")>
      <cfset $mock.foo(2).shouldEqual("even")>
    </it>

    <it should="throw an exception if arguments do not match">
      <cfset $mock.stubs("foo").with(anyOf(1, 2, 3)).returns("bar")>
      <cfset $mock.foo(4).shouldThrow()>
    </it>

    <it should="throw an exception if too many arguments">
      <cfset $mock.stubs("foo").with(anyOf(1, 2, 3)).returns("bar")>
      <cfset $mock.foo(2, true).shouldThrow()>
    </it>

    <it should="throw an exception if too few arguments">
      <cfset $mock.stubs("foo").with(anyOf(1, 2, 3)).returns("bar")>
      <cfset $mock.foo().shouldThrow()>
    </it>

    <it should="meet multiple expectations when called with more specific arguments">
      <cfset $mock.expects("foo").returns("bar")>
      <cfset $mock.expects("foo").with(anyOf(1, 2, 3)).returns("baz")>
      <cfset $mock.foo(2).shouldEqual("baz")>
      <cfset $mock.__cfspecGetFailureMessages().shouldBeEmpty()>
    </it>

  </describe>

  <describe hint="allOf">

    <before>
      <cfset $mock.stubs("foo").with(allOf(anyNumeric(), anyOf(1, 3, 5)), anything()).returns("odd")>
      <cfset $mock.stubs("foo").with(allOf(anyNumeric(), anyOf(2, 4, 6)), anything()).returns("even")>
    </before>

    <it should="return different values for different arguments">
      <cfset $mock.foo(5, 0).shouldEqual("odd")>
      <cfset $mock.foo(2, 0).shouldEqual("even")>
    </it>

    <it should="throw an exception if arguments do not match">
      <cfset $mock.foo("foo", 0).shouldThrow()>
    </it>

    <it should="throw an exception if one condition is violated">
      <cfset $mock.foo(9, 0).shouldThrow()>
    </it>

    <it should="throw an exception if too many arguments">
      <cfset $mock.foo(2, 0, true).shouldThrow()>
    </it>

    <it should="throw an exception if too few arguments">
      <cfset $mock.foo().shouldThrow()>
    </it>

    <it should="throw an exception if too few arguments afterwards">
      <cfset $mock.foo(2).shouldThrow()>
    </it>

  </describe>

  <describe hint="anyObject">

    <before>
      <cfset $mock.stubs("foo").returns("unknown")>
      <cfset $mock.stubs("foo").with(anyObject()).returns("object")>
    </before>

    <it should="match an object">
      <cfset obj = createObject("component", "cfspec.spec.assets.Widget")>
      <cfset $mock.foo(obj).shouldEqual("object")>
    </it>

    <it should="not match a simple value">
      <cfset $mock.foo("foo").shouldEqual("unknown")>
    </it>

  </describe>

  <describe hint="anyInstanceOf">

    <before>
      <cfset $mock.stubs("foo").returns("unknown")>
      <cfset $mock.stubs("foo").with(anyInstanceOf("cfspec.spec.assets.Widget")).returns("widget")>
    </before>

    <it should="match an instance of Widget">
      <cfset obj = createObject("component", "cfspec.spec.assets.Widget")>
      <cfset $mock.foo(obj).shouldEqual("widget")>
    </it>

    <it should="match an instance of SpecialWidget">
      <cfset obj = createObject("component", "cfspec.spec.assets.SpecialWidget")>
      <cfset $mock.foo(obj).shouldEqual("widget")>
    </it>

    <it should="not match an instance of something else">
      <cfset obj = createObject("component", "cfspec.spec.assets.Simon")>
      <cfset $mock.foo(obj).shouldEqual("unknown")>
    </it>

  </describe>

  <describe hint="basic type checks">

    <before>
      <cfset $mock.stubs("foo").returns("unknown")>
      <cfset $mock.stubs("foo").with(anyBoolean()).returns("boolean")>
      <cfset $mock.stubs("foo").with(anyNumeric()).returns("numeric")>
      <cfset $mock.stubs("foo").with(anyDate()).returns("date")>
      <cfset $mock.stubs("foo").with(anyStruct()).returns("struct")>
      <cfset $mock.stubs("foo").with(anyArray()).returns("array")>
      <cfset $mock.stubs("foo").with(anyQuery()).returns("query")>
      <cfset $mock.stubs("foo").with(anyBinary()).returns("binary")>
      <cfset $mock.stubs("foo").with(anyGUID()).returns("guid")>
      <cfset $mock.stubs("foo").with(anyUUID()).returns("uuid")>
      <cfset $mock.stubs("foo").with(anything(), anything()).returns("doubleUnknown")>
      <cfset $mock.stubs("foo").with(1, anySimpleValue()).returns("simpleValue")>
      <cfset $mock.stubs("foo").with(2, anyString()).returns("string")>
    </before>

    <it should="match a boolean">
      <cfset $mock.foo(true).shouldEqual("boolean")>
    </it>

    <it should="match a numeric">
      <cfset $mock.foo(42).shouldEqual("numeric")>
    </it>

    <it should="match a date">
      <cfset $mock.foo(now()).shouldEqual("date")>
    </it>

    <it should="match a struct">
      <cfset $mock.foo(structNew()).shouldEqual("struct")>
    </it>

    <it should="match an array">
      <cfset $mock.foo(arrayNew(1)).shouldEqual("array")>
    </it>

    <it should="match a query">
      <cfset $mock.foo(queryNew("")).shouldEqual("query")>
    </it>

    <it should="match a binary">
      <cfset $mock.foo(toBinary(toBase64("foo"))).shouldEqual("binary")>
    </it>

    <it should="match a guid">
      <cfset $mock.foo("01234567-89AB-CDEF-0123-456789ABCDEF").shouldEqual("guid")>
    </it>

    <it should="match an uuid">
      <cfset $mock.foo(createUUID()).shouldEqual("uuid")>
    </it>

    <it should="match nothing">
      <cfset $mock.foo().shouldEqual("unknown")>
    </it>

    <it should="match a simple value">
      <cfset $mock.foo(1, now()).shouldEqual("simpleValue")>
    </it>

    <it should="match a string">
      <cfset $mock.foo(2, "foo").shouldEqual("string")>
    </it>

    <it should="not match a simpleValue">
      <cfset $mock.foo(1, structNew()).shouldEqual("doubleUnknown")>
    </it>

  </describe>

</describe>
