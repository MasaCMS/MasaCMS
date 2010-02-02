<cfimport taglib="/cfspec" prefix="">

<describe hint="Mock (basic stubbing)">

  <before>
    <cfset $mock = $(createObject("component", "cfspec.lib.Mock").__cfspecInit("myStub"))>
  </before>

  <it should="throw an exception on an unspecified method call">
    <cfset $mock.undefinedMethod().shouldThrow()>
  </it>

  <it should="return a new stub on an unspecified method call">
    <cfset $mock.stubsMissingMethod()>
    <cfset $mock.undefinedMethod().shouldBeAnInstanceOf("cfspec.lib.Mock")>
  </it>

  <it should="return the specified value on an unspecified method call">
    <cfset $mock.stubsMissingMethod().returns("foo")>
    <cfset $mock.undefinedMethod().shouldEqual("foo")>
  </it>

  <it should="return the correct value for a method that was supplied on init">
    <cfset $mock = $(createObject("component", "cfspec.lib.Mock").__cfspecInit(getName="John Doe", getAge=21, isMale=true))>
    <cfset $mock.getName().shouldEqual("John Doe")>
    <cfset $mock.getAge().shouldEqual(21)>
    <cfset $mock.shouldBeMale()>
  </it>

  <it should="return the supplied value for a given method">
    <cfset $mock.stubs("foo").returns("bar")>
    <cfset $mock.foo().shouldEqual("bar")>
  </it>

  <it should="throw the supplied exception for a given method">
    <cfset $mock.stubs("foo").throws("NoFooAllowed")>
    <cfset $mock.foo().shouldThrow("NoFooAllowed")>
  </it>

  <it should="throw the supplied exception for a given method with a message">
    <cfset $mock.stubs("foo").throws("NoFooAllowed", "message")>
    <cfset $mock.foo().shouldThrow("NoFooAllowed", "message")>
  </it>

  <it should="throw the supplied exception for a given method with a message and details">
    <cfset $mock.stubs("foo").throws("NoFooAllowed", "message", "details")>
    <cfset $mock.foo().shouldThrow("NoFooAllowed", "message", "details")>
  </it>

  <describe hint="multiple return values or throws">

    <it should="return supplied values in succession if a given method is expected multiple times">
      <cfset $mock.stubs("next").returns("one")>
      <cfset $mock.stubs("next").returns("two")>
      <cfset $mock.stubs("next").returns("more")>
      <cfset $mock.next().shouldEqual("one")>
      <cfset $mock.next().shouldEqual("two")>
      <cfset $mock.next().shouldEqual("more")>
      <cfset $mock.next().shouldEqual("more")>
    </it>

    <it should="return supplied values in succession if multiple returns are chained">
      <cfset $mock.stubs("next").returns("one").returns("two").returns("more")>
      <cfset $mock.next().shouldEqual("one")>
      <cfset $mock.next().shouldEqual("two")>
      <cfset $mock.next().shouldEqual("more")>
      <cfset $mock.next().shouldEqual("more")>
    </it>

    <it should="return supplied values in succession if multiple return values are supplied">
      <cfset $mock.stubs("next").returns("one", "two", "more")>
      <cfset $mock.next().shouldEqual("one")>
      <cfset $mock.next().shouldEqual("two")>
      <cfset $mock.next().shouldEqual("more")>
      <cfset $mock.next().shouldEqual("more")>
    </it>

    <it should="throw supplied exceptions in succession if a given method is expected multiple times">
      <cfset $mock.stubs("next").throws("one")>
      <cfset $mock.stubs("next").throws("two")>
      <cfset $mock.stubs("next").throws("more")>
      <cfset $mock.next().shouldThrow("one")>
      <cfset $mock.next().shouldThrow("two")>
      <cfset $mock.next().shouldThrow("more")>
      <cfset $mock.next().shouldThrow("more")>
    </it>

    <it should="return supplied values in succession if multiple returns are chained">
      <cfset $mock.stubs("next").throws("one").throws("two").throws("more")>
      <cfset $mock.next().shouldThrow("one")>
      <cfset $mock.next().shouldThrow("two")>
      <cfset $mock.next().shouldThrow("more")>
      <cfset $mock.next().shouldThrow("more")>
    </it>

    <it should="return supplied values or throw supplied exceptions in succession if there are multiple expectations setup in different ways">
      <cfset $mock.stubs("next").returns("one").throws("boo").returns("two", "three")>
      <cfset $mock.stubs("next").throws("yah")>
      <cfset $mock.stubs("next").returns("four")>
      <cfset $mock.stubs("next").throws("done")>
      <cfset $mock.next().shouldEqual("one")>
      <cfset $mock.next().shouldThrow("boo")>
      <cfset $mock.next().shouldEqual("two")>
      <cfset $mock.next().shouldEqual("three")>
      <cfset $mock.next().shouldThrow("yah")>
      <cfset $mock.next().shouldEqual("four")>
      <cfset $mock.next().shouldThrow("done")>
      <cfset $mock.next().shouldThrow("done")>
    </it>

  </describe>

</describe>

<describe hint="Mock (basic mocking)">

  <before>
    <cfset $mock = $(createObject("component", "cfspec.lib.Mock").__cfspecInit("myMock"))>
  </before>

  <it should="return the supplied value for a given method">
    <cfset $mock.expects("foo").returns("bar")>
    <cfset $mock.foo().shouldEqual("bar")>
  </it>

  <it should="throw the supplied exception for a given method">
    <cfset $mock.expects("foo").throws("NoFooAllowed")>
    <cfset $mock.foo().shouldThrow("NoFooAllowed")>
  </it>

  <it should="throw the supplied exception for a given method with a message">
    <cfset $mock.expects("foo").throws("NoFooAllowed", "message")>
    <cfset $mock.foo().shouldThrow("NoFooAllowed", "message")>
  </it>

  <it should="throw the supplied exception for a given method with a message and details">
    <cfset $mock.expects("foo").throws("NoFooAllowed", "message", "details")>
    <cfset $mock.foo().shouldThrow("NoFooAllowed", "message", "details")>
  </it>

  <it should="not report any failures when no expectations are set">
    <cfset $mock.__cfspecGetFailureMessages().shouldBeEmpty()>
  </it>

  <it should="report a failure if the method is never called">
    <cfset $mock.expects("foo")>
    <cfset $mock.__cfspecGetFailureMessages().shouldNotBeEmpty()>
  </it>

  <it should="not report a failure if the method is called exactly once">
    <cfset $mock.expects("foo")>
    <cfset $mock.foo()>
    <cfset $mock.__cfspecGetFailureMessages().shouldBeEmpty()>
  </it>

  <it should="report a failure if the method is called more than once">
    <cfset $mock.expects("foo")>
    <cfset $mock.foo()>
    <cfset $mock.foo()>
    <cfset $mock.__cfspecGetFailureMessages().shouldNotBeEmpty()>
  </it>

  <describe hint="times(3)">

    <it should="report a failure if the method is never called">
      <cfset $mock.expects("foo").times(3)>
      <cfset $mock.__cfspecGetFailureMessages().shouldNotBeEmpty()>
    </it>

    <it should="report a failure if the method is called less than 3 times">
      <cfset $mock.expects("foo").times(3)>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.__cfspecGetFailureMessages().shouldNotBeEmpty()>
    </it>

    <it should="not report a failure if the method is called exactly 3 times">
      <cfset $mock.expects("foo").times(3)>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.__cfspecGetFailureMessages().shouldBeEmpty()>
    </it>

    <it should="report a failure if the method is called more than 3 times">
      <cfset $mock.expects("foo").times(3)>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.__cfspecGetFailureMessages().shouldNotBeEmpty()>
    </it>

  </describe>

  <describe hint="times(3, 5)">

    <it should="report a failure if the method is never called">
      <cfset $mock.expects("foo").times(3, 5)>
      <cfset $mock.__cfspecGetFailureMessages().shouldNotBeEmpty()>
    </it>

    <it should="report a failure if the method is called less than 3 times">
      <cfset $mock.expects("foo").times(3, 5)>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.__cfspecGetFailureMessages().shouldNotBeEmpty()>
    </it>

    <it should="not report a failure if the method is called exactly 3 times">
      <cfset $mock.expects("foo").times(3, 5)>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.__cfspecGetFailureMessages().shouldBeEmpty()>
    </it>

    <it should="not report a failure if the method is called exactly 4 times">
      <cfset $mock.expects("foo").times(3, 5)>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.__cfspecGetFailureMessages().shouldBeEmpty()>
    </it>

    <it should="not report a failure if the method is called exactly 5 times">
      <cfset $mock.expects("foo").times(3, 5)>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.__cfspecGetFailureMessages().shouldBeEmpty()>
    </it>

    <it should="report a failure if the method is called more than 5 times">
      <cfset $mock.expects("foo").times(3, 5)>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.__cfspecGetFailureMessages().shouldNotBeEmpty()>
    </it>

  </describe>

  <describe hint="never()">

    <it should="not report a failure if the method is never called">
      <cfset $mock.expects("foo").never()>
      <cfset $mock.__cfspecGetFailureMessages().shouldBeEmpty()>
    </it>

    <it should="report a failure if the method is called">
      <cfset $mock.expects("foo").never()>
      <cfset $mock.foo()>
      <cfset $mock.__cfspecGetFailureMessages().shouldNotBeEmpty()>
    </it>

  </describe>

  <describe hint="once()">

    <it should="report a failure if the method is never called">
      <cfset $mock.expects("foo").once()>
      <cfset $mock.__cfspecGetFailureMessages().shouldNotBeEmpty()>
    </it>

    <it should="not report a failure if the method is called exactly once">
      <cfset $mock.expects("foo").once()>
      <cfset $mock.foo()>
      <cfset $mock.__cfspecGetFailureMessages().shouldBeEmpty()>
    </it>

    <it should="report a failure if the method is called more than once">
      <cfset $mock.expects("foo").once()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.__cfspecGetFailureMessages().shouldNotBeEmpty()>
    </it>

  </describe>

  <describe hint="twice()">

    <it should="report a failure if the method is never called">
      <cfset $mock.expects("foo").twice()>
      <cfset $mock.__cfspecGetFailureMessages().shouldNotBeEmpty()>
    </it>

    <it should="report a failure if the method is called less than twice">
      <cfset $mock.expects("foo").twice()>
      <cfset $mock.foo()>
      <cfset $mock.__cfspecGetFailureMessages().shouldNotBeEmpty()>
    </it>

    <it should="not report a failure if the method is called exactly twice">
      <cfset $mock.expects("foo").twice()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.__cfspecGetFailureMessages().shouldBeEmpty()>
    </it>

    <it should="report a failure if the method is called more than twice">
      <cfset $mock.expects("foo").twice()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.__cfspecGetFailureMessages().shouldNotBeEmpty()>
    </it>

  </describe>

  <describe hint="atLeast(3)">

    <it should="report a failure if the method is never called">
      <cfset $mock.expects("foo").atLeast(3)>
      <cfset $mock.__cfspecGetFailureMessages().shouldNotBeEmpty()>
    </it>

    <it should="report a failure if the method is called less than 3 times">
      <cfset $mock.expects("foo").atLeast(3)>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.__cfspecGetFailureMessages().shouldNotBeEmpty()>
    </it>

    <it should="not report a failure if the method is called exactly 3 times">
      <cfset $mock.expects("foo").atLeast(3)>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.__cfspecGetFailureMessages().shouldBeEmpty()>
    </it>

    <it should="not report a failure if the method is called more than 3 times">
      <cfset $mock.expects("foo").atLeast(3)>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.__cfspecGetFailureMessages().shouldBeEmpty()>
    </it>

    <it should="not report a failure if the method is called 100 times">
      <cfset $mock.expects("foo").atLeast(3)>
      <cfloop index="i" from="1" to="100">
        <cfset $mock.foo()>
      </cfloop>
      <cfset $mock.__cfspecGetFailureMessages().shouldBeEmpty()>
    </it>

  </describe>

  <describe hint="atLeastOnce()">

    <it should="report a failure if the method is never called">
      <cfset $mock.expects("foo").atLeastOnce()>
      <cfset $mock.__cfspecGetFailureMessages().shouldNotBeEmpty()>
    </it>

    <it should="not report a failure if the method is called exactly once">
      <cfset $mock.expects("foo").atLeastOnce()>
      <cfset $mock.foo()>
      <cfset $mock.__cfspecGetFailureMessages().shouldBeEmpty()>
    </it>

    <it should="not report a failure if the method is called 100 times">
      <cfset $mock.expects("foo").atLeastOnce()>
      <cfloop index="i" from="1" to="100">
        <cfset $mock.foo()>
      </cfloop>
      <cfset $mock.__cfspecGetFailureMessages().shouldBeEmpty()>
    </it>

  </describe>

  <describe hint="atMost(3)">

    <it should="not report a failure if the method is never called">
      <cfset $mock.expects("foo").atMost(3)>
      <cfset $mock.__cfspecGetFailureMessages().shouldBeEmpty()>
    </it>

    <it should="not report a failure if the method is called exactly 3 times">
      <cfset $mock.expects("foo").atMost(3)>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.__cfspecGetFailureMessages().shouldBeEmpty()>
    </it>

    <it should="report a failure if the method is called more than 3 times">
      <cfset $mock.expects("foo").atMost(3)>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.__cfspecGetFailureMessages().shouldNotBeEmpty()>
    </it>

  </describe>

  <describe hint="atMostOnce()">

    <it should="not report a failure if the method is never called">
      <cfset $mock.expects("foo").atMostOnce()>
      <cfset $mock.__cfspecGetFailureMessages().shouldBeEmpty()>
    </it>

    <it should="not report a failure if the method is called exactly once">
      <cfset $mock.expects("foo").atMostOnce()>
      <cfset $mock.foo()>
      <cfset $mock.__cfspecGetFailureMessages().shouldBeEmpty()>
    </it>

    <it should="report a failure if the method is called more than once">
      <cfset $mock.expects("foo").atMostOnce()>
      <cfset $mock.foo()>
      <cfset $mock.foo()>
      <cfset $mock.__cfspecGetFailureMessages().shouldNotBeEmpty()>
    </it>

  </describe>

  <describe hint="failure messages">

    <it should="report a failure with meaningful details about the method involved">
      <cfset $mock.expects("foo")>
      <cfset $mock.__cfspecGetFailureMessages().shouldContain('myMock: expected "foo" to be invoked once, but it was never invoked.')>
    </it>

    <it should="report a failure with meaningful details about the expected & actual number of times invoked">
      <cfset $mock.expects("foo").times(3, 5).returns("bar")>
      <cfset $mock.foo()>
      <cfset $mock.__cfspecGetFailureMessages().shouldContain('myMock: expected "foo" to be invoked 3 to 5 times, but it was invoked once.')>
    </it>

  </describe>

</describe>
