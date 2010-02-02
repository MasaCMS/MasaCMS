<cfimport taglib="/cfspec" prefix="">

<describe hint="MockReturnException">

  <before>
    <cfset $mockReturnException =
             $(createObject("component", "cfspec.lib.MockReturnException")
             .init("foo", "bar", "baz"))>
  </before>

  <it should="throw the exception that it was initialized with">
    <cfset $mockReturnException.eval().shouldThrow("foo", "bar", "baz")>
  </it>

</describe>
