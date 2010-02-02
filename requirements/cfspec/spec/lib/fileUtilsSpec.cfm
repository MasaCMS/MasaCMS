<cfimport taglib="/cfspec" prefix="">

<describe hint="FileUtils">

  <before>
    <cfset $fileUtils = $(createObject("component", "cfspec.lib.FileUtils").init())>
  </before>

  <describe hint="relativePath">

    <it should="find a relative path within the web root">
      <cfset $fileUtils.relativePath(expandPath("/cfspec-relativePath-test.cfm"))
                       .shouldEqual("/cfspec-relativePath-test.cfm")>
    </it>

    <it should="find a relative path based on coldfusion runtime mappings">
      <cfswitch expression="#server.coldfusion.productName#">
        <cfcase value="Railo">
          <!--- Railo doesn't allow manipulation of mappings without a password,
                so skip this test--->
          <cfset $(true).shouldBeTrue()>
        </cfcase>
        <cfdefaultcase>
          <cfset serviceFactory = createObject("java", "coldfusion.server.ServiceFactory")>
          <cfset mappings = serviceFactory.getRuntimeService().getMappings()>
          <cfset key = "/cfspec-relativePath-test-mapping">
          <cfset mappings[key] = "/cfspec-relativePath-test-path">
          <cfset exception = "">

          <cftry>
            <cfset $fileUtils.relativePath("\\cfspec-relativePath-test-path\to\Component.cfc")
                             .shouldEqual("/cfspec-relativePath-test-mapping/to/Component.cfc")>
            <cfcatch type="any">
              <cfset exception = cfcatch>
            </cfcatch>
          </cftry>

          <cfset structDelete(mappings, key)>

          <cfif not isSimpleValue(exception)>
            <cfthrow object="#exception#">
          </cfif>
        </cfdefaultcase>
      </cfswitch>
    </it>

    <it should="throw an exception when the relative path cannot be determined">
      <cfset $fileUtils.relativePath("/cfspec-relativePath-test/that/does/not/exist.cfc")
                       .shouldThrow("Application", "Unable to determine the relative path")>
    </it>

  </describe>

  <describe hint="normalizePath">

    <it should="convert all slashes to single forward slashes">
      <cfset $fileUtils.normalizePath("C:\\path\to\Component.cfc")
                       .shouldEqual("C:/path/to/Component.cfc")>
    </it>

  </describe>

</describe>
