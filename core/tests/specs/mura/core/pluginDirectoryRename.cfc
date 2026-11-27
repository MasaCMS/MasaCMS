/**
* Deploying a plugin renames its folder to the package name, inside the plugins folder (MASA-479).
*
* pluginManager.updateSettings() used to pass only the new folder name to a cfdirectory
* rename. Lucee and ACF resolve that name against the folder being
* renamed, BoxLang against the calling template (core/mura/fileWriter.cfc), so on BoxLang the
* plugin moved to core/mura/<package>.
*/
component extends="testbox.system.BaseSpec" {

	function beforeAll() {
		variables.pluginManager = application.pluginManager;
		variables.pluginDir = application.configBean.getPluginDir();
		variables.package = "MasaSpecRename" & left(replace(createUUID(), "-", "", "all"), 8);
		variables.wrongDir = getDirectoryFromPath(expandPath("/mura/fileWriter.cfc")) & variables.package;
		variables.tmp = getTempDirectory() & "pluginDirectoryRename_" & createUUID() & "/";
		// deploy() flags the app for a reload; left that way, the next HTTP request from a later
		// bundle reinitialises Masa in the middle of the suite
		variables.appInitialized = application.appInitialized;
		// deploy() can fail after it has added the plugin; afterAll() removes everything newer
		variables.lastPluginID = val(queryExecute("select max(pluginID) as id from tplugins").id);

		directoryCreate(variables.tmp & "src/plugin");
		fileWrite(variables.tmp & "src/plugin/config.xml", charsetDecode(
			'<plugin><name>#variables.package#</name><package>#variables.package#</package>'
			& '<directoryFormat>packageOnly</directoryFormat><loadPriority>5</loadPriority><version>1.0</version>'
			& '<provider>spec</provider><providerURL>https://www.masacms.com</providerURL>'
			& '<category>Application</category></plugin>', "utf-8"));
		variables.zipFile = variables.tmp & variables.package & ".zip";
		cfzip(action="zip", file=variables.zipFile, source=variables.tmp & "src");
	}

	function afterAll() {
		var added = queryExecute("select moduleID from tplugins where pluginID > :id", { id: variables.lastPluginID });
		for (var row in added) {
			variables.pluginManager.deletePlugin(row.moduleID);
		}
		application.appInitialized = variables.appInitialized;
		if (directoryExists(variables.wrongDir)) {
			directoryDelete(variables.wrongDir, true);
		}
		if (directoryExists(variables.tmp)) {
			directoryDelete(variables.tmp, true);
		}
	}

	function run() {

		describe("pluginManager.deploy() with a package name", function(){

			it("renames the plugin folder inside the plugins folder", function(){
				var moduleID = variables.pluginManager.deploy(pluginFile=variables.zipFile, useDefaultSettings=true);

				expect(variables.pluginManager.getPlugin(moduleID).directory).toBe(variables.package);
				expect(directoryExists(variables.pluginDir & "/" & variables.package)).toBeTrue();
				expect(directoryExists(variables.wrongDir)).toBeFalse();
			});

		});
	}
}
