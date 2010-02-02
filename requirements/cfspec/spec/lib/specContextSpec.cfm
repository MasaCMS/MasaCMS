<cfimport taglib="/cfspec" prefix="">

<describe hint="SpecContext">

  <before>
    <cfset $context = $(createObject("component", "cfspec.lib.SpecContext").__cfspecInit())>
  </before>

  <it should="start with a status of 'pass'">
    <cfset $context.__cfspecGetStatus().shouldEqual("pass")>
  </it>

</describe>
