<cfimport taglib="/cfspec" prefix="">

<describe hint="StateMachine">

  <before>
    <cfset $machine = $(createObject("component", "cfspec.lib.StateMachine").init("power"))>
  </before>

  <it should="start in a blank state">
    <cfset $machine.getState().shouldEqual("")>
  </it>

  <it should="have the name given">
    <cfset $machine.getName().shouldEqual("power")>
  </it>

  <describe hint="setState">

    <it should="change the state">
      <cfset $machine.setState("new")>
      <cfset $machine.getState().shouldEqual("new")>
    </it>

  </describe>


  <describe hint="startsAs">

    <it should="change the state">
      <cfset $machine.startsAs("first")>
      <cfset $machine.getState().shouldEqual("first")>
    </it>

  </describe>

  <describe hint="is">

    <it should="return a StateMachineCondition">
      <cfset $machine.is("on").shouldBeAnInstanceOf("cfspec.lib.StateMachineCondition")>
    </it>

    <it should="return a non-active condition">
      <cfset $machine.is("on").shouldNotBeActive()>
    </it>

    <it should="return an active condition">
      <cfset $condition = $machine.is("on")>
      <cfset $machine.setState("on")>
      <cfset $condition.shouldBeActive()>
    </it>

  </describe>

  <describe hint="becomes">

    <it should="return a StateMachineTransition">
      <cfset $machine.becomes("on").shouldBeAnInstanceOf("cfspec.lib.StateMachineTransition")>
    </it>

    <it should="not change the current state">
      <cfset $machine.becomes("on")>
      <cfset $machine.getState().shouldNotEqual("on")>
    </it>

    <it should="change to the transition state when the transition is run">
      <cfset $machine.becomes("on").run()>
      <cfset $machine.getState().shouldEqual("on")>
    </it>

  </describe>

</describe>
