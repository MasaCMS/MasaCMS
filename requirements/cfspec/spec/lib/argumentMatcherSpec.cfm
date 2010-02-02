<cfimport taglib="/cfspec" prefix="">

<describe hint="ArgumentMatcher">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.ArgumentMatcher").init())>
    <cfset args = structNew()>
    <cfset args[1] = "foo"><cfset args[2] = 42><cfset args[3] = true>
    <cfset $matcher.setArguments(args)>
  </before>

  <it should="match when arguments are equal to those passed in">
    <cfset args = structNew()>
    <cfset args[1] = "foo"><cfset args[2] = 42><cfset args[3] = true>
    <cfset $matcher.isMatch(args).shouldBeTrue()>
  </it>

  <it should="match when arguments are not equal to those passed in">
    <cfset args = structNew()>
    <cfset args[1] = "foo"><cfset args[2] = 43><cfset args[3] = true>
    <cfset $matcher.isMatch(args).shouldBeFalse()>
  </it>

  <it should="flatten to a unique string for the arguments">
    <cfset $matcher.asString().shouldEqual("{1='foo',2=42,3=true}")>
  </it>

</describe>
