/**
* A site bundle leaves the site's assets and cache folders out of sitefiles.zip unless structured
* assets are included (MASA-483).
*
* bundleFiles() passes excludeDirs="assets|cache" to zipTool.AddFiles(), which filters the
* site folder's listing in Zip.cfc FilesList().
*/
component extends="testbox.system.BaseSpec" {

	function beforeAll() {
		variables.siteRoot = application.configBean.getSiteDir() & "/default";
		variables.markers = [];

		// Make sure both folders hold a file, so leaving them out is observable
		for (var dir in [ "assets", "cache" ]) {
			if (!directoryExists(variables.siteRoot & "/" & dir)) {
				directoryCreate(variables.siteRoot & "/" & dir);
			}
			var marker = variables.siteRoot & "/" & dir & "/bundleSpec_" & createUUID() & ".txt";
			fileWrite(marker, charsetDecode("x", "utf-8"));
			variables.markers.append(marker);
		}
	}

	function afterAll() {
		for (var marker in variables.markers) {
			if (fileExists(marker)) {
				fileDelete(marker);
			}
		}
	}

	function run() {

		describe("settingsBundleBean.bundleFiles() without structured assets", function(){

			it("leaves the site's assets and cache folders out of sitefiles.zip", function(){
				var bundle = application.serviceFactory.getBean("settingsBundle");
				var backupDir = prepareMock(bundle).$getProperty(name="backupDir", scope="variables");

				try {
					directoryCreate(backupDir);
					bundle.setValue("rstfiles", queryNew("fileID"));
					bundle.bundleFiles(siteID="default", includeStructuredAssets=false);

					var entries = "";
					cfzip(action="list", file=backupDir & "sitefiles.zip", name="entries");
					var names = [];
					for (var row in entries) {
						names.append(replace(row.name, "\", "/", "all"));
					}
					var excluded = names.filter(function(name){ return reFindNoCase("^(assets|cache)/", name); });

					expect(names.len()).toBeGT(0, "sitefiles.zip is empty");
					expect(excluded.len()).toBe(0, "excluded folders in sitefiles.zip: #excluded.toList(', ')#");
				} finally {
					if (directoryExists(backupDir)) {
						directoryDelete(backupDir, true);
					}
				}
			});

		});
	}
}
