/**
* Creating a site bundle reads a theme from the global themes folder and leaves that folder alone.
*
* settingsBundleBean.bundleFiles() used to extract the theme from the new archive into the theme's
* own folder, which nested a copy under themes/<theme>/themes/<theme>, one level deeper with
* every bundle.
*
* Needs the default site to use a theme from the global themes folder.
*/
component extends="testbox.system.BaseSpec" {

	function beforeAll() {
		variables.theme = application.settingsManager.getSite("default").getTheme();
		variables.themeDir = application.configBean.getWebRoot() & "/themes/" & variables.theme;
		variables.marker = "bundleSpec_" & createUUID() & ".txt";
		variables.copy = variables.themeDir & "/themes/" & variables.theme & "/" & variables.marker;
		variables.hasGlobalTheme = len(variables.theme) && directoryExists(variables.themeDir);

		if (variables.hasGlobalTheme) {
			fileWrite(variables.themeDir & "/" & variables.marker, charsetDecode("x", "utf-8"));
		}
	}

	function afterAll() {
		for (var path in [ variables.themeDir & "/" & variables.marker, variables.copy ]) {
			if (variables.hasGlobalTheme && fileExists(path)) {
				fileDelete(path);
			}
		}
	}

	function run() {

		describe("settingsBundleBean.bundleFiles() with a theme in the global themes folder", function(){

			it(title="does not copy the theme into itself", skip=function(){
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

					expect(fileExists(variables.copy)).toBeFalse();
				} finally {
					if (directoryExists(backupDir)) {
						directoryDelete(backupDir, true);
					}
				}
			});

		});
	}
}
