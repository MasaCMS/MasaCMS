<cfimport taglib="/cfspec" prefix="">

<describe hint="Custom Matcher">

  <beforeAll>
    <cfset registerMatcher("Say", "cfspec.spec.assets.SimonSaysMatcher")>
    <cfset simpleMatcher("BeEven", "target mod 2 eq 0")>
    <cfset simpleMatcher("BeOdd", "target mod 2 eq 1")>
  </beforeAll>

  <before>
    <cfset $simon = $(createObject("component", "cfspec.spec.assets.Simon").init("Hello World!"))>
  </before>

  <it should="do what simon says">
    <cfset $simon.shouldSay("Hello World!")>
  </it>

  <it should="not do what simon doesn't say">
    <cfset $simon.shouldNotSay("Goodbye!")>
  </it>

  <it should="be even, not odd">
    <cfset $(2).shouldBeEven().shouldNotBeOdd()>
  </it>

  <it should="be odd, not even">
    <cfset $(3).shouldBeOdd().shouldNotBeEven()>
  </it>

</describe>
