<cfimport taglib="/cfspec" prefix="">

<describe hint="RespondTo">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.RespondTo").init())>
    <cfset $matcher.setArguments("getName")>
    <cfset widget = createObject("component", "cfspec.spec.assets.Widget")>
    <cfset specialWidget = createObject("component", "cfspec.spec.assets.SpecialWidget")>
  </before>

  <it should="match when target responds to method">
    <cfset $matcher.isMatch(widget).shouldBeTrue()>
  </it>

  <it should="match when target's superclass responds to method">
    <cfset $matcher.isMatch(specialWidget).shouldBeTrue()>
  </it>

  <it should="not match when target does not respond to method">
    <cfset $matcher.isMatch(stub()).shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch(stub())>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to respond to 'getName', but the method was not found")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset $matcher.isMatch(widget)>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to respond to 'getName', but the method was found")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("respond to 'getName'")>
  </it>

  <describe hint="multiple arguments">

    <before>
      <cfset $matcher.setArguments("getName", "getSpecial")>
    </before>

    <it should="match when target responds to all methods listed">
      <cfset $matcher.isMatch(specialWidget).shouldBeTrue()>
    </it>

    <it should="not match when target does not responds to one of the methods listed">
      <cfset $matcher.isMatch(widget).shouldBeFalse()>
    </it>

  </describe>

</describe>
