<cfimport taglib="/cfspec" prefix="">

<describe hint="MatcherManager">

  <before>
    <cfset $manager = $(createObject("component", "cfspec.lib.MatcherManager").init())>
  </before>

  <it should="start with built-in matchers registered">
    <cfset $manager.getMatchers().shouldContain(listToArray("Be,cfspec.lib.matchers.BeSame"))>
  </it>

  <it should="allow a custom matcher to be registered">
    <cfset $manager.registerMatcher("FooBar", "path.to.FooBar")>
    <cfset $manager.getMatchers().shouldContain(listToArray("FooBar,path.to.FooBar"))>
  </it>

  <it should="allow a simple matcher to be registered">
    <cfset $manager.simpleMatcher("FooBaz", "A is A")>
    <cfset $manager.getMatchers().shouldContain(listToArray("(FooBaz),cfspec.lib.matchers.Simple"))>
    <cfset $manager.getSimpleMatcherExpression("FooBaz").shouldEqual("A is A")>
  </it>

</describe>
