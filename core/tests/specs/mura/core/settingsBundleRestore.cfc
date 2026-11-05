/**
* Tests for settingsBundleBean.restore() / restorePartial() deserializing the bundle's
* wddx_*.xml files. NUL characters are stripped before cfwddx runs; this must work on
* every engine's regex implementation (ACF's Java engine rejected the old '[\x0]').
*/
component extends="testbox.system.BaseSpec" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		variables.tmp = getTempDirectory() & "/bundlerestore_" & createUUID() & "/";
		directoryCreate(variables.tmp);
	}

	function afterAll() {
		try {
			directoryDelete(variables.tmp, true);
		} catch (any e) {}
	}

	/*********************************** HELPERS ***********************************/

	// Build a bundle zip holding the marker archive plus wddx_test.xml with a NUL inside the value.
	private string function makeBundle(required string markerEntry) {
		var srcDir = variables.tmp & createUUID() & "/";
		directoryCreate(srcDir);

		var innerDir = variables.tmp & createUUID() & "/";
		directoryCreate(innerDir);
		fileWrite(innerDir & "readme.txt", "x");
		cfzip(action="zip", file=srcDir & arguments.markerEntry, source=innerDir);

		var wddx = "";
		cfwddx(action="cfml2wddx", input={ title: "before|after" }, output="wddx");
		fileWrite(srcDir & "wddx_test.xml", replace(wddx, "|", chr(0)), "utf-8");

		var zipPath = variables.tmp & createUUID() & ".zip";
		cfzip(action="zip", file=zipPath, source=srcDir);
		return zipPath;
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {

		describe("Bundle restore WDDX deserialization", function() {

			it("strips NUL characters in restore()", function() {
				var bundle = application.serviceFactory.getBean('settingsBundle');
				try {
					expect(bundle.restore(makeBundle("sitefiles.zip"))).toBeTrue();
					expect(bundle.getValue("test").title).toBe("beforeafter");
				} finally {
					bundle.cleanUp();
				}
			});

			it("strips NUL characters in restorePartial()", function() {
				var bundle = application.serviceFactory.getBean('settingsBundle');
				try {
					expect(bundle.restorePartial(makeBundle("assetfiles.zip"))).toBeTrue();
					expect(bundle.getValue("test").title).toBe("beforeafter");
				} finally {
					bundle.cleanUp();
				}
			});

		});

	}

}
