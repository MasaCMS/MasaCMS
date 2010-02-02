<cfimport taglib="/cfspec" prefix="">

<describe hint="Sequence">

  <before>
    <cfset seq = createObject("component", "cfspec.lib.Sequence").init("mySeq")>
    <cfset $seq = $(seq)>
  </before>

  <it should="report no failed expectations">
    <cfset $seq.__cfspecGetFailureMessages().shouldBeEmpty()>
  </it>

  <describe hint="with a simple expectation sequence">

    <before>
      <cfset foo = stub("foo")>
      <cfset bar = stub("bar")>
      <cfset foo.expects("a").inSequence(seq)>
      <cfset foo.expects("b").inSequence(seq)>
      <cfset bar.expects("c").inSequence(seq)>
      <cfset foo.expects("d").inSequence(seq)>
      <cfset bar.expects("e").inSequence(seq)>
    </before>

    <it should="report a failed expectation when mocks are called out of sequence">
      <cfset foo.a()><cfset foo.b()><cfset foo.d()><cfset bar.c()><cfset bar.e()>
      <cfset $seq.__cfspecGetFailureMessages().shouldNotBeEmpty()>
      <!--- next line prevents the framework from reporting the sequence's failed expectations --->
      <cfset $seq.stubs("__cfspecGetFailureMessages")>
    </it>

    <it should="report nothing when all expectations are called in sequence">
      <cfset foo.a()><cfset foo.b()><cfset bar.c()><cfset foo.d()><cfset bar.e()>
      <cfset $seq.__cfspecGetFailureMessages().shouldBeEmpty()>
    </it>

    <it should="give a helpful error message when a sequence is violated">
      <cfset foo.a()><cfset foo.b()><cfset foo.d()><cfset bar.c()><cfset bar.e()>
      <cfset $seq.__cfspecGetFailureMessages().shouldContain("mySeq: expected bar.c()[mySeq:3], got foo.d()[mySeq:4].")>
      <!--- next line prevents the framework from reporting the sequence's failed expectations --->
      <cfset $seq.stubs("__cfspecGetFailureMessages")>
    </it>

  </describe>

  <describe hint="with an expectation sequence containing optional steps">

    <before>
      <cfset foo = stub("foo")>
      <cfset bar = stub("bar")>
      <cfset foo.expects("a").atLeast(2).inSequence(seq)>
      <cfset foo.stubs("b").inSequence(seq)>
      <cfset bar.expects("c").atMostOnce().inSequence(seq)>
      <cfset foo.stubs("d").inSequence(seq)>
      <cfset bar.expects("e").twice().inSequence(seq)>
    </before>

    <it should="report nothing when optional expectations are left out of the sequence">
      <cfset foo.a()><cfset foo.a()><cfset bar.e()><cfset bar.e()>
      <cfset $seq.__cfspecGetFailureMessages().shouldBeEmpty()>
    </it>

    <it should="report nothing when optional expectations are included in the sequence">
      <cfset foo.a()><cfset foo.a()><cfset foo.a()><cfset foo.b()><cfset bar.c()>
      <cfset foo.d()><cfset foo.d()><cfset foo.d()><cfset bar.e()><cfset bar.e()>
      <cfset $seq.__cfspecGetFailureMessages().shouldBeEmpty()>
    </it>

    <it should="report failure when expectations are called fewer than the required number of times">
      <cfset foo.a()><cfset bar.e()><cfset bar.e()>
      <cfset $seq.__cfspecGetFailureMessages().shouldNotBeEmpty()>
      <!--- next line prevents the framework from reporting the mock's failed expectations --->
      <cfset $seq.stubs("__cfspecGetFailureMessages")>
      <cfset $(foo).stubs("__cfspecGetFailureMessages")>
    </it>

  </describe>

</describe>
