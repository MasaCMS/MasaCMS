<cfimport taglib="/cfspec" prefix="">

<describe hint="Mock (in sequence)">

  <before>
    <cfset seq = sequence("mySequence")>
    <cfset mock = createObject("component", "cfspec.lib.Mock").__cfspecInit("myStub")>
  </before>

  <it should="enforce sequences that overlap themselves">
    <cfset mock.expects("a").times(3)>
    <cfset mock.expects("b").times(3)>

    <cfset mock.expects("a").atLeastOnce().inSequence(seq).returns(1)>
    <cfset mock.expects("b").atLeastOnce().inSequence(seq).returns(2)>
    <cfset mock.expects("a").atLeastOnce().inSequence(seq).returns(3)>
    <cfset mock.expects("b").atLeastOnce().inSequence(seq).returns(4)>

    <cfset $(mock.a()).shouldEqual(1)>
    <cfset $(mock.b()).shouldEqual(2)>
    <cfset $(mock.b()).shouldEqual(2)>
    <cfset $(mock.a()).shouldEqual(3)>
    <cfset $(mock.a()).shouldEqual(3)>
    <cfset $(mock.b()).shouldEqual(4)>

    <cfset $(mock.__cfspecGetFailureMessages()).shouldBeEmpty()>
  </it>

</describe>
