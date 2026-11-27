/**
* A site bundle includes a theme from the global themes folder in sitefiles.zip (MASA-473).
*
* bundleFiles() writes the site files to sitefiles.zip first and then adds the theme. It used
* cfzip action="zip" on the existing archive, which Lucee and ACF add to, but BoxLang refuses
* with "Destination file already exists".
*
* Needs the default site to use a theme from the global themes folder.
*/
component extends="testbox.system.BaseSpec" {

	function beforeAll() {
		variables.theme = application.settingsManager.getSite("default").getTheme();
		variables.themeDir = application.configBean.getWebRoot() & "/themes/" & variables.theme;
		variables.marker = "bundleSpec_" & createUUID() & ".txt";
		variables.hasGlobalTheme = len(variables.theme) && directoryExists(variables.themeDir);

		if (variables.hasGlobalTheme) {
			fileWrite(variables.themeDir & "/" & variables.marker, charsetDecode("x", "utf-8"));
		}
	}

	function afterAll() {
		if (variables.hasGlobalTheme && fileExists(variables.themeDir & "/" & variables.marker)) {
			fileDelete(variables.themeDir & "/" & variables.marker);
		}
	}

	function run() {

		describe("settingsBundleBean.bundleFiles() with a theme in the global themes folder", function(){

			it(title="adds the theme to sitefiles.zip next to the site files", skip=function(){
				return !application.settingsManager.getSite("default").getTheme().len()
					|| !directoryExists(application.configBean.getWebRoot() & "/themes/"
						& application.settingsManager.getSite("default").getTheme());
			}, body=function(){
				var bundle = application.serviceFactory.getBean("settingsBundle");
				var backupDir = prepareMock(bundle).$getProperty(name="backupDir", scope="variables");

				try {
					directoryCreate(backupDir);
					bundle.setValue("rstfiles", queryNew("fileID"));
					bundle.bundleFiles(siteID="default");

					var entries = "";
					cfzip(action="list", file=backupDir & "sitefiles.zip", name="entries");
					var names = [];
					for (var row in entries) {
						names.append(replace(row.name, "\", "/", "all"));
					}
					var siteFiles = names.filter(function(name){ return !reFindNoCase("(^|/)themes/", name); });

					expect(names.toList(", ")).toInclude("themes/" & variables.theme & "/" & variables.marker);
					expect(siteFiles.len()).toBeGT(0, "site files are missing: #names.toList(', ')#");
					expect(directoryExists(backupDir & "sitefiles")).toBeFalse("the staging folder is left behind");
				} finally {
					if (directoryExists(backupDir)) {
						directoryDelete(backupDir, true);
					}
				}
			});

		});
	}
}
