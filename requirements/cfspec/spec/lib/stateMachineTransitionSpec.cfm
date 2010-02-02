<cfimport taglib="/cfspec" prefix="">

<describe hint="StateMachineTransition">

  <before>
    <cfset machine = stub("state machine")>
    <cfset transition = createObject("component", "cfspec.lib.StateMachineTransition")
		                      .init(machine, "next")>
  </before>

  <it should="tells the machine to change state on run">
    <cfset machine.expects("setState").with("next")>
		<cfset transition.run()>
  </it>

</describe>