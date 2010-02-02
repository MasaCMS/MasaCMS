<cfimport taglib="/cfspec" prefix="">

<describe hint="PartialMock (basic stubbing)">

  <describe hint="on a plain object">

    <before>
      <cfset mockee = createObject("component", "cfspec.spec.assets.Widget")>
      <cfset mocker = createObject("component", "cfspec.lib.PartialMock").init(mockee)>
      <cfset $mockee = $(mockee)>
    </before>

    <it should="return the supplied value for a given method">
      <cfset mocker.stubs("foo").returns("bar")>
      <cfset $mockee.foo().shouldEqual("bar")>
    </it>

    <it should="return the value from an underlying method">
      <cfset mocker.stubs("foo").returns("bar")>
      <cfset $mockee.getName().shouldEqual("Widget")>
    </it>

    <it should="return the supplied value by overriding an underlying method">
      <cfset mocker.stubs("getName").returns("bar")>
      <cfset $mockee.getName().shouldEqual("bar")>
    </it>

    <it should="throw a method not found exception">
      <cfset mocker.stubs("foo").returns("bar")>
      <cfset $mockee.nonExistantMethod().shouldThrow("Application", "The method nonExistantMethod was not found")>
    </it>

  </describe>

  <describe hint="an object with onMissingMethod">

    <before>
      <cfset mockee = createObject("component", "cfspec.spec.assets.PartialMockee")>
      <cfset mocker = createObject("component", "cfspec.lib.PartialMock").init(mockee)>
      <cfset $mockee = $(mockee)>
    </before>

    <it should="return the supplied value for a given method">
      <cfset mocker.stubs("foo").returns("bar")>
      <cfset $mockee.foo().shouldEqual("bar")>
    </it>

    <it should="return the value from an underlying method">
      <cfset mocker.stubs("foo").returns("bar")>
      <cfset $mockee.getName().shouldEqual("My Name")>
    </it>

    <it should="return the supplied value by overriding an underlying method">
      <cfset mocker.stubs("getName").returns("bar")>
      <cfset $mockee.getName().shouldEqual("bar")>
    </it>

    <it should="return the value from the underlying object's onMM handler">
      <cfset mocker.stubs("foo").returns("bar")>
      <cfset $mockee.nonExistantMethod().shouldEqualNoCase("You called nonExistantMethod!")>
    </it>

  </describe>

  <describe hint="on a child object's super-class methods">

    <before>
      <cfset mockee = createObject("component", "cfspec.spec.assets.SpecialWidget")>
      <cfset mocker = createObject("component", "cfspec.lib.PartialMock").init(mockee)>
      <cfset $mockee = $(mockee)>
    </before>

    <it should="return the supplied value for a given method">
      <cfset mocker.stubs("foo").returns("bar")>
      <cfset $mockee.foo().shouldEqual("bar")>
    </it>

    <it should="return the value from an underlying method">
      <cfset mocker.stubs("foo").returns("bar")>
      <cfset $mockee.getName().shouldEqual("Widget")>
    </it>

    <it should="return the supplied value by overriding an underlying method">
      <cfset mocker.stubs("getName").returns("bar")>
      <cfset $mockee.getName().shouldEqual("bar")>
    </it>

    <it should="throw a method not found exception">
      <cfset mocker.stubs("foo").returns("bar")>
      <cfset $mockee.nonExistantMethod().shouldThrow("Application", "The method nonExistantMethod was not found")>
    </it>

  </describe>

  <describe hint="on a child object's super-class methods with onMissingMethod">

    <before>
      <cfset mockee = createObject("component", "cfspec.spec.assets.PartialMockeeChild")>
      <cfset mocker = createObject("component", "cfspec.lib.PartialMock").init(mockee)>
      <cfset $mockee = $(mockee)>
    </before>

    <it should="return the supplied value for a given method">
      <cfset mocker.stubs("foo").returns("bar")>
      <cfset $mockee.foo().shouldEqual("bar")>
    </it>

    <it should="return the value from an underlying method">
      <cfset mocker.stubs("foo").returns("bar")>
      <cfset $mockee.getName().shouldEqual("My Name")>
    </it>

    <it should="return the supplied value by overriding an underlying method">
      <cfset mocker.stubs("getName").returns("bar")>
      <cfset $mockee.getName().shouldEqual("bar")>
    </it>

    <it should="return the value from the underlying object's onMM handler">
      <cfset mocker.stubs("foo").returns("bar")>
      <cfset $mockee.nonExistantMethod().shouldEqualNoCase("You called nonExistantMethod!")>
    </it>

  </describe>

</describe>

<describe hint="PartialMock (basic mocking)">

  <describe hint="on a plain object">

    <before>
      <cfset mockee = createObject("component", "cfspec.spec.assets.Widget")>
      <cfset mocker = createObject("component", "cfspec.lib.PartialMock").init(mockee)>
      <cfset $mockee = $(mockee)>
    </before>

    <it should="not report any failures when no expectations are set">
      <cfset $(mocker.__cfspecGetFailureMessages()).shouldBeEmpty()>
    </it>

    <it should="report a failure if the method is never called">
      <cfset mocker.expects("foo")>
      <cfset $(mocker.__cfspecGetFailureMessages()).shouldNotBeEmpty()>
      <!--- next line prevents the framework from reporting the mock's failed expectations --->
      <cfset $(mocker).stubs("__cfspecGetFailureMessages")>
    </it>

    <it should="not report a failure if the method is called exactly once">
      <cfset mocker.expects("foo")>
      <cfset $mockee.foo()>
      <cfset $(mocker.__cfspecGetFailureMessages()).shouldBeEmpty()>
    </it>

    <it should="report a failure if the method is called more than once">
      <cfset mocker.expects("foo")>
      <cfset $mockee.foo()>
      <cfset $mockee.foo()>
      <cfset $(mocker.__cfspecGetFailureMessages()).shouldNotBeEmpty()>
      <!--- next line prevents the framework from reporting the mock's failed expectations --->
      <cfset $(mocker).stubs("__cfspecGetFailureMessages")>
    </it>

  </describe>

</describe>
