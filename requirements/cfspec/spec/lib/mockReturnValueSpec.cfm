<cfimport taglib="/cfspec" prefix="">

<describe hint="MockReturnValue">

  <before>
    <cfset $mockReturnValue =
             $(createObject("component", "cfspec.lib.MockReturnValue")
             .init("foo"))>
  </before>

  <it should="evaluate to the value it was initialized with">
    <cfset $mockReturnValue.eval().shouldEqual("foo")>
  </it>

</describe>
