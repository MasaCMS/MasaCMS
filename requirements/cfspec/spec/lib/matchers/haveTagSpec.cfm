<cfimport taglib="/cfspec" prefix="">

<describe hint="HaveTag">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.HaveTag").init())>
    <cfset $matcher.setArguments("h1")>
    <cfset $matcher.setRunner(__cfspecRunner)>
  </before>

  <it should="match when target has the expected tag">
    <cfset $matcher.isMatch("<h1>The Page Title</h1><p>Para1<p>Para2<p>Para3").shouldBeTrue()>
  </it>

  <it should="not match when target does not have the expected tag">
    <cfset $matcher.isMatch("<h2>The Page Title</h2><p>Para1<p>Para2<p>Para3").shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch("<h2>The Page Title</h2><p>Para1<p>Para2<p>Para3").shouldBeFalse()>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to have tag 'h1', got 0")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset $matcher.isMatch("<h1>The Page Title</h1><p>Para1<p>Para2<p>Para3").shouldBeTrue()>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to have tag 'h1', got 1")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("have tag 'h1'")>
  </it>

  <describe hint="using xpath">

    <before>
      <cfset $matcher.setArguments("p[@class='foo']/a")>
    </before>

    <it should="match when the target has a tag that matches the given xpath">
      <cfset $matcher.isMatch("<p class='foo'>Click <a href='bar'>here</a></p>").shouldBeTrue()>
    </it>

    <it should="not match when the target does not have a tag that matches the given xpath">
      <cfset $matcher.isMatch("<p class='food'>Click <a href='bar'>here</a></p>").shouldBeFalse()>
    </it>

  </describe>

  <describe hint="with a specified count">

    <before>
      <cfset $matcher.setArguments("p", 2)>
    </before>

    <it should="not match when the target has fewer matching tags than expected">
      <cfset $matcher.isMatch("<p>one").shouldBeFalse()>
    </it>

    <it should="match when the target has the expected number of matching tags">
      <cfset $matcher.isMatch("<p>one<p>two").shouldBeTrue()>
    </it>

    <it should="not match when the target has more matching tags than expected">
      <cfset $matcher.isMatch("<p>one<p>two<p>three").shouldBeFalse()>
    </it>

    <it should="describe itself">
      <cfset $matcher.getDescription().shouldEqual("have tag 'p' (2)")>
    </it>

  </describe>

  <describe hint="with a specified range">

    <before>
      <cfset $matcher.setArguments("p", 2, 4)>
    </before>

    <it should="not match when the target has fewer matching tags than expected">
      <cfset $matcher.isMatch("<p>one").shouldBeFalse()>
    </it>

    <it should="match when the target has the least expected number of matching tags">
      <cfset $matcher.isMatch("<p>one<p>two").shouldBeTrue()>
    </it>

    <it should="match when the target has the median expected number of matching tags">
      <cfset $matcher.isMatch("<p>one<p>two<p>three").shouldBeTrue()>
    </it>

    <it should="match when the target has the most expected number of matching tags">
      <cfset $matcher.isMatch("<p>one<p>two<p>three<p>four").shouldBeTrue()>
    </it>

    <it should="not match when the target has more matching tags than expected">
      <cfset $matcher.isMatch("<p>one<p>two<p>three<p>four<p>five").shouldBeFalse()>
    </it>

    <it should="describe itself">
      <cfset $matcher.getDescription().shouldEqual("have tag 'p' (2-4)")>
    </it>

  </describe>

</describe>
