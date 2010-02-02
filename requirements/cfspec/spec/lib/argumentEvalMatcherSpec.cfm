<cfimport taglib="/cfspec" prefix="">

<describe hint="ArgumentEvalMatcher">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.ArgumentEvalMatcher").init())>
    <cfset $matcher.setExpression("arguments[1] eq 'foo'")>
  </before>

  <it should="match when expression evaluates to true">
    <cfset args = structNew()>
    <cfset args[1] = "foo"><cfset args[2] = "bar">
    <cfset $matcher.isMatch(args).shouldBeTrue()>
  </it>

  <it should="match when expression evaluates to false">
    <cfset args = structNew()>
    <cfset args[1] = "bar"><cfset args[2] = "none">
    <cfset $matcher.isMatch(args).shouldBeFalse()>
  </it>

  <it should="flatten to a unique string for the expression">
    <cfset $matcher.asString().shouldEqual("eval(#chr(34)#arguments[1] eq 'foo'#chr(34)#)")>
  </it>

</describe>
