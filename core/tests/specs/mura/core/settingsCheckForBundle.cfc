/**
* Tests for settingsManager.checkForBundle() handling of the "Select Bundle File From Server"
* path. A path that does not exist on the server must be reported instead of silently
* skipping the bundle deploy.
*/
component extends="testbox.system.BaseSpec" {

	/*********************************** BDD SUITES ***********************************/

	function run() {

		describe("checkForBundle server bundle path", function() {

			it("reports a server bundle path that does not exist", function() {
				var errors = {};
				var path = getTempDirectory() & createUUID() & "/<missing>.zip";
				application.settingsManager.checkForBundle({ siteID: "default", serverBundlePath: path }, errors);
				expect(errors).toHaveKey("serverBundlePath");
				expect(errors.serverBundlePath).toInclude("could not be found");
				expect(errors.serverBundlePath).toInclude("&lt;missing&gt;.zip");
			});

			it("does nothing when no bundle path or file is given", function() {
				var errors = {};
				application.settingsManager.checkForBundle({ siteID: "default", serverBundlePath: "" }, errors);
				expect(errors).toBeEmpty();
			});

		});

	}

}
