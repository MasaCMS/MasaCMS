<cfimport taglib="/cfspec" prefix="">

<describe hint="Base.hasMethod(object, methodName)">

  <before>
    <cfset $base = $(createObject("component", "cfspec.lib.Base"))>
  </before>

  <it should="agree that Widget has method 'getName'">
    <cfset $base.hasMethod(createObject("component", "cfspec.spec.assets.Widget"), "getName").shouldBeTrue()>
  </it>

  <it should="agree that SpecialWidget has method 'getName'">
    <cfset $base.hasMethod(createObject("component", "cfspec.spec.assets.SpecialWidget"), "getName").shouldBeTrue()>
  </it>

  <it should="agree that Stub does not have method 'getName', even if explicitly setup">
    <cfset $base.hasMethod(stub(getName="Joe"), "getName").shouldBeFalse()>
  </it>

</describe>