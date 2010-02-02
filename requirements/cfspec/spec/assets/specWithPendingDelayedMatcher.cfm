<cfimport taglib="/cfspec" prefix="">

<describe hint="spec with pending delayed matcher">

  <it should="fail because there is a pending delayed matcher">
    <cfset $(stub()).shouldHave(4)>
  </it>

</describe>
