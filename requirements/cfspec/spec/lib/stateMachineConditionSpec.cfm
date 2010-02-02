<cfimport taglib="/cfspec" prefix="">

<describe hint="StateMachineCondition">

  <before>
    <cfset machine = stub("myStateMachine")>
    <cfset condition = createObject("component", "cfspec.lib.StateMachineCondition")
		                      .init(machine, "test")>
  </before>

  <it should="verify that the condition is active">
    <cfset machine.stubs("getState").returns("test")>
    <cfset $(condition).shouldBeActive()>
  </it>

  <it should="verify that the condition is not active">
    <cfset machine.stubs("getState").returns("other")>
    <cfset $(condition).shouldNotBeActive()>
  </it>

  <it should="print as a string">
    <cfset machine.stubs("getName").returns("myStateMachine")>
    <cfset $(condition).asString().shouldEqual("myStateMachine=test")>
  </it>

</describe>
