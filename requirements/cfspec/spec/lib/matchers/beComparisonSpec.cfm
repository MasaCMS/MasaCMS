<cfimport taglib="/cfspec" prefix="">

<describe hint="BeComparison">

  <describe hint="less than">

    <before>
      <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.BeComparison").init("LessThan"))>
      <cfset $matcher.setArguments(5)>
    </before>

    <it should="match when target < actual">
      <cfset $matcher.isMatch(4).shouldBeTrue()>
    </it>

    <it should="not match when target == actual">
      <cfset $matcher.isMatch(5).shouldBeFalse()>
    </it>

    <it should="not match when target > actual">
      <cfset $matcher.isMatch(6).shouldBeFalse()>
    </it>

    <it should="provide a useful failure message">
      <cfset $matcher.isMatch(6)>
      <cfset $matcher.getFailureMessage().shouldEqual("expected to be < 5, got 6")>
    </it>

    <it should="provide a useful negative failure message">
      <cfset $matcher.isMatch(4)>
      <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to be < 5, got 4")>
    </it>

    <it should="describe itself">
      <cfset $matcher.getDescription().shouldEqual("be < 5")>
    </it>

  </describe>

  <describe hint="less than or equal to">

    <before>
      <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.BeComparison").init("LessThanOrEqualTo"))>
      <cfset $matcher.setArguments(5)>
    </before>

    <it should="match when target < actual">
      <cfset $matcher.isMatch(4).shouldBeTrue()>
    </it>

    <it should="match when target == actual">
      <cfset $matcher.isMatch(5).shouldBeTrue()>
    </it>

    <it should="not match when target > actual">
      <cfset $matcher.isMatch(6).shouldBeFalse()>
    </it>

    <it should="provide a useful failure message">
      <cfset $matcher.isMatch(6)>
      <cfset $matcher.getFailureMessage().shouldEqual("expected to be <= 5, got 6")>
    </it>

    <it should="provide a useful negative failure message">
      <cfset $matcher.isMatch(4)>
      <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to be <= 5, got 4")>
    </it>

    <it should="describe itself">
      <cfset $matcher.getDescription().shouldEqual("be <= 5")>
    </it>

  </describe>

  <describe hint="greater than or equal to">

    <before>
      <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.BeComparison").init("GreaterThanOrEqualTo"))>
      <cfset $matcher.setArguments(5)>
    </before>

    <it should="not match when target < actual">
      <cfset $matcher.isMatch(4).shouldBeFalse()>
    </it>

    <it should="match when target == actual">
      <cfset $matcher.isMatch(5).shouldBeTrue()>
    </it>

    <it should="match when target > actual">
      <cfset $matcher.isMatch(6).shouldBeTrue()>
    </it>

    <it should="provide a useful failure message">
      <cfset $matcher.isMatch(4)>
      <cfset $matcher.getFailureMessage().shouldEqual("expected to be >= 5, got 4")>
    </it>

    <it should="provide a useful negative failure message">
      <cfset $matcher.isMatch(6)>
      <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to be >= 5, got 6")>
    </it>

    <it should="describe itself">
      <cfset $matcher.getDescription().shouldEqual("be >= 5")>
    </it>

  </describe>

  <describe hint="greater than">

    <before>
      <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.BeComparison").init("GreaterThan"))>
      <cfset $matcher.setArguments(5)>
    </before>

    <it should="not match when target < actual">
      <cfset $matcher.isMatch(4).shouldBeFalse()>
    </it>

    <it should="not match when target == actual">
      <cfset $matcher.isMatch(5).shouldBeFalse()>
    </it>

    <it should="match when target > actual">
      <cfset $matcher.isMatch(6).shouldBeTrue()>
    </it>

    <it should="provide a useful failure message">
      <cfset $matcher.isMatch(4)>
      <cfset $matcher.getFailureMessage().shouldEqual("expected to be > 5, got 4")>
    </it>

    <it should="provide a useful negative failure message">
      <cfset $matcher.isMatch(6)>
      <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to be > 5, got 6")>
    </it>

    <it should="describe itself">
      <cfset $matcher.getDescription().shouldEqual("be > 5")>
    </it>

  </describe>

  <describe hint="date comparisons">

    <before>
      <cfset today = createDate(2001, 3, 15)>
      <cfset lastMonth = dateAdd("m", -1, today)>
      <cfset yesterday = dateAdd("d", -1, today)>
      <cfset anHourAgo = dateAdd("h", -1, today)>
      <cfset anHourFromNow = dateAdd("h", 1, today)>
      <cfset tomorrow = dateAdd("d", 1, today)>
      <cfset nextMonth = dateAdd("m", 1, today)>
    </before>

    <describe hint="before">

      <before>
        <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.BeComparison").init("Before"))>
        <cfset $matcher.setArguments(today)>
      </before>

      <it should="match when target is before actual">
        <cfset $matcher.isMatch(lastMonth).shouldBeTrue()>
      </it>

      <it should="not match when target == actual">
        <cfset $matcher.isMatch(today).shouldBeFalse()>
      </it>

      <it should="not match when target is after actual">
        <cfset $matcher.isMatch(nextMonth).shouldBeFalse()>
      </it>

      <it should="provide a useful failure message">
        <cfset $matcher.isMatch(nextMonth)>
        <cfset $matcher.getFailureMessage().shouldEqual("expected to be before 2001-03-15 12:00 AM, got 2001-04-15 12:00 AM")>
      </it>

      <it should="provide a useful negative failure message">
        <cfset $matcher.isMatch(lastMonth)>
        <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to be before 2001-03-15 12:00 AM, got 2001-02-15 12:00 AM")>
      </it>

      <it should="describe itself">
        <cfset $matcher.getDescription().shouldEqual("be before 2001-03-15 12:00 AM")>
      </it>

      <describe hint="using different date parts">

        <before>
          <cfset $matcher.setArguments(today, "d")>
        </before>

        <it should="not match when target is before actual by less than the specified date part">
          <cfset $matcher.isMatch(anHourAgo).shouldBeFalse()>
        </it>

        <it should="match when target is before actual by more than the specified date part">
          <cfset $matcher.isMatch(lastMonth).shouldBeTrue()>
        </it>

      </describe>

    </describe>

    <describe hint="after">

      <before>
        <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.BeComparison").init("After"))>
        <cfset $matcher.setArguments(today)>
      </before>

      <it should="not match when target is before actual">
        <cfset $matcher.isMatch(lastMonth).shouldBeFalse()>
      </it>

      <it should="not match when target == actual">
        <cfset $matcher.isMatch(today).shouldBeFalse()>
      </it>

      <it should="match when target is after actual">
        <cfset $matcher.isMatch(nextMonth).shouldBeTrue()>
      </it>

      <it should="provide a useful failure message">
        <cfset $matcher.isMatch(lastMonth)>
        <cfset $matcher.getFailureMessage().shouldEqual("expected to be after 2001-03-15 12:00 AM, got 2001-02-15 12:00 AM")>
      </it>

      <it should="provide a useful negative failure message">
        <cfset $matcher.isMatch(nextMonth)>
        <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to be after 2001-03-15 12:00 AM, got 2001-04-15 12:00 AM")>
      </it>

      <it should="describe itself">
        <cfset $matcher.getDescription().shouldEqual("be after 2001-03-15 12:00 AM")>
      </it>

      <describe hint="using different date parts">

        <before>
          <cfset $matcher.setArguments(today, "d")>
        </before>

        <it should="not match when target is after actual by less than the specified date part">
          <cfset $matcher.isMatch(anHourFromNow).shouldBeFalse()>
        </it>

        <it should="match when target is after actual by more than the specified date part">
          <cfset $matcher.isMatch(nextMonth).shouldBeTrue()>
        </it>

      </describe>

    </describe>

  </describe>

  <describe hint="bad types">

    <it should="provide a useful failure message if actual is non-numeric">
      <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.BeComparison").init("LessThan"))>
      <cfset $matcher.setArguments(5)>
      <cfset $matcher.isMatch(stub()).shouldThrow("cfspec.fail", "BeLessThan expected a number, got")>
    </it>

  </describe>

</describe>
