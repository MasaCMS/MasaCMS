<cfimport taglib="/cfspec" prefix="">

<describe hint="Mock (with state machine)">

  <before>
    <cfset radio = stateMachine("radio").startsAs("off")>
    <cfset mock = createObject("component", "cfspec.lib.Mock").__cfspecInit("myStub")>
  </before>

  <it should="return different values for different machine states">
    <cfset mock.stubs("foo").when(radio.is("on")).returns("channel 2")>
    <cfset mock.stubs("foo").when(radio.is("off")).returns("white noise")>
    <cfset $(mock.foo()).shouldEqual("white noise")>
    <cfset radio.setState("on")>
    <cfset $(mock.foo()).shouldEqual("channel 2")>
  </it>

  <it should="throw an exception if machine is not in a known state">
    <cfset mock.stubs("foo").when(radio.is("on")).returns("channel 2")>
    <cfset $(mock).foo().shouldThrow()>
  </it>

  <it should="change the machine state">
    <cfset mock.stubs("turnOn").when(radio.is("off")).then(radio.becomes("on"))>
    <cfset $(radio).getState().shouldEqual("off")>
    <cfset mock.turnOn()>
    <cfset $(radio).getState().shouldEqual("on")>
  </it>

</describe>
