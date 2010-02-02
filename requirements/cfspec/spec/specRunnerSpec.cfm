<cfimport taglib="/cfspec" prefix="">

<!---
  This spec is implementation specific.

  Technically, a spec should not rely on side-effects of the expections code, nor is there a guarantee that
  the expectations are run in a specific order.

  Until cfSpec is mature enough to handle output parsing when testing itself, this will have to do.  It assumes
  that all 'it' tags are run in order from top to bottom (interjecting befores & afters as appropriate).
--->

<describe hint="SpecRunner">

  <beforeAll>
    <cfset level1BeforeAllVar = 1>
  </beforeAll>

  <before>
    <cfset level1BeforeAllVar++>
    <cfset level1BeforeVar = 1>
  </before>

  <it should="see variables from 'beforeAll'">
    <cfset $(isDefined("level1BeforeAllVar")).shouldBeTrue()>
    <cfset $(level1BeforeAllVar).shouldEqual(1+1)>
  </it>

  <it should="see updates to variables from 'beforeAll' that were made in 'before' tags">
    <cfset $(level1BeforeAllVar).shouldEqual(1+1+1)>
    <cfset level1BeforeAllVar = 1000>
  </it>

  <it should="see updates to variables from 'beforeAll' that were made in other 'it' tags">
    <cfset $(level1BeforeAllVar).shouldEqual(1000+1)>
  </it>

  <it should="see updates to variables from 'beforeAll' that were made in 'after' tags">
    <cfset $(level1BeforeAllVar).shouldEqual(5+1)>
  </it>

  <it should="not see updates to variables from 'beforeAll' that are yet to made in 'afterAll' tags">
    <cfset $(level1BeforeAllVar).shouldEqual(5+1+1)>
  </it>

  <it should="see variables from 'before'">
    <cfset $(isDefined("level1BeforeVar")).shouldBeTrue()>
    <cfset $(level1BeforeVar).shouldEqual(1)>
    <cfset level1BeforeVar = 99>
  </it>

  <it should="not see updates to variables from 'before' that were made in other tags">
    <cfset $(level1BeforeVar).shouldEqual(1)>
    <cfset level1ItVar = "foo">
  </it>

  <it should="not see variables from other 'it' tags">
    <cfset $(isDefined("level1ItVar")).shouldBeFalse()>
    <cfset level1BeforeAllVar = 500>
  </it>

  <describe hint="nested context">

    <beforeAll>
      <cfset level2BeforeAllVar = "foo">
    </beforeAll>

    <before>
      <cfset level2BeforeVar = "bar">
      <cfset level1BeforeVar++>
    </before>

    <it should="see variables from 'beforeAll' and 'before' (level 1 & 2)">
      <cfset $(isDefined("level1BeforeAllVar")).shouldBeTrue()>
      <cfset $(isDefined("level1BeforeVar")).shouldBeTrue()>
      <cfset $(isDefined("level2BeforeAllVar")).shouldBeTrue()>
      <cfset $(isDefined("level2BeforeVar")).shouldBeTrue()>
    </it>

    <it should="see updates to variables from level 1 that were made in 'before' (level 1)">
      <cfset $(level1BeforeAllVar).shouldEqual(500+1+1)>
    </it>

    <it should="see updates to variables from level 1 that were made in 'before' (level 2)">
      <cfset $(level1BeforeVar).shouldEqual(1+1)>
    </it>

    <afterAll>
      <cfset level1BeforeAllVar = 1001>
    </afterAll>

  </describe>

  <it should="have run this context's 'before' and 'after' tags around each 'it' of the nested describe along with 'beforeAll', 'before', 'after', and 'afterAll' when appropriate">
    <cfset $(level1BeforeAllVar).shouldEqual(5+1)>
  </it>

  <it should="not see variables from nested 'describe' tags">
    <cfset $(isDefined("level2BeforeAllVar")).shouldBeFalse()>
    <cfset $(isDefined("level2BeforeAll")).shouldBeFalse()>
  </it>

  <it should="do setup for the multiple nesting 'describe' block">
    <cfset $(true).shouldBeTrue()><!--- so we don't pend --->
    <cfset level1BeforeAllVar = 1000>    
  </it>

  <describe hint="multiple nesting without before/afters">
    <describe hint="nested">
      <describe hint="nested">
        <describe hint="nested">

          <it should="not see variables from a previous nested 'descibe'">
            <cfset $(isDefined("level2BeforeAllVar")).shouldBeFalse()>
            <cfset $(isDefined("level2BeforeVar")).shouldBeFalse()>
          </it>

        </describe>
      </describe>
    </describe>
  </describe>

  <it should="see updates made through the previous nested 'describe'">
    <cfset $(level1BeforeAllVar).shouldEqual(5+1)>
  </it>

  <after>
    <cfif level1BeforeAllVar gt 1000>
      <cfset level1BeforeAllVar -= 996>
    </cfif>
    <cfset level1BeforeVar = 99>
  </after>

  <afterAll>
    <cfset level1BeforeAllVar = -99>
    <cfset level1BeforeVar = 99>
  </afterAll>

</describe>

<describe hint="SpecRunner (context spill over)">

  <it should="not see variables from previous 'describe' tags">
    <cfset $(isDefined("level1BeforeAllVar")).shouldBeFalse()>
    <cfset $(isDefined("level1BeforeAll")).shouldBeFalse()>
  </it>

</describe>
