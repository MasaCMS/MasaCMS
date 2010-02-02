<cfimport taglib="/cfspec" prefix="">

<describe hint="Singletons">

  <before>
    <cfset singletons = createObject("component", "cfspec.lib.Singletons").init()>
  </before>

  <it should="have a MatcherManager singleton">
    <cfset matcherManager = singletons.getMatcherManager()>
    <cfset $(matcherManager).shouldBe(singletons.getMatcherManager())>
    <cfset $(matcherManager).shouldBeAnInstanceOf("cfspec.lib.MatcherManager")>
  </it>

  <it should="have a FileUtils singleton">
    <cfset fileUtils = singletons.getFileUtils()>
    <cfset $(fileUtils).shouldBe(singletons.getFileUtils())>
    <cfset $(fileUtils).shouldBeAnInstanceOf("cfspec.lib.FileUtils")>
  </it>

  <it should="have an Inflector singleton">
    <cfset inflector = singletons.getInflector()>
    <cfset $(inflector).shouldBe(singletons.getInflector())>
    <cfset $(inflector).shouldBeAnInstanceOf("cfspec.util.Inflector")>
  </it>

  <it should="have a JavaLoader singleton">
    <cfset javaLoader = singletons.getJavaLoader()>
    <cfset $(javaLoader).shouldBe(singletons.getJavaLoader())>
    <cfset $(javaLoader).shouldBeAnInstanceOf("cfspec.external.javaloader.JavaLoader")>
  </it>

  <it should="have a DocBuilder singleton">
    <cfset docBuilder = singletons.getDocBuilder()>
    <cfset $(docBuilder).shouldBe(singletons.getDocBuilder())>
    <cfset $(getMetaData(docBuilder).name).shouldEqual("nu.xom.Builder")>
  </it>

</describe>
