<cfimport taglib="/cfspec" prefix="">

<describe hint="spec with failing mock expectation">

  <it should="fail because there is an unfulfilled mock expectation">
    <cfset $myMock = mock("myMock")>
    <cfset $myMock.expects("foo")>
  </it>

  <it should="pass because there is a fulfilled mock expectation">
    <cfset $myMock = mock("myMock")>
    <cfset $myMock.expects("foo")>
    <cfset $myMock.foo()>
  </it>

  <it should="fail because there is an overfulfilled mock expectation">
    <cfset $myMock = mock("myMock")>
    <cfset $myMock.expects("foo")>
    <cfset $myMock.foo()>
    <cfset $myMock.foo()>
  </it>

  <it should="fail because there is an implicit unfulfilled mock expectation">
    <cfset $myMock = mock(foo="bar")>
  </it>

  <it should="pass because there is an implicit fulfilled mock expectation">
    <cfset $myMock = mock(foo="bar")>
    <cfset $myMock.foo()>
  </it>

  <it should="fail because there is an implicit overfulfilled mock expectation">
    <cfset $myMock = mock(foo="bar")>
    <cfset $myMock.foo()>
    <cfset $myMock.foo()>
  </it>

</describe>
