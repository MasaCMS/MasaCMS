/**
* Tests that bundles include the code of the selected plugins (issue #466).
*
* Bundle() exports a plugin's database rows as wddx files and its code as
* pluginfiles.zip, which holds a copy of plugins/<directory>/. These specs register
* two throwaway plugins (a folder plus a tplugins row each), build bundles into a
* temp directory, and unzip them to check which plugin files they contain.
*/
component extends="testbox.system.BaseSpec" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		session.siteid = 'default';
		variables.siteID = 'default';
		variables.workDir = getTempDirectory() & "bundleplugins_" & createUUID() & "/";
		directoryCreate(variables.workDir);

		variables.selected = createPlugin();
		variables.other = createPlugin();
	}

	function afterAll() {
		for (var plugin in [variables.selected, variables.other]) {
			queryExecute("delete from tcontent where moduleID = :moduleID and type = 'Plugin'", {moduleID = plugin.moduleID});
			queryExecute("delete from tplugins where moduleID = :moduleID", {moduleID = plugin.moduleID});
			try {
				directoryDelete(plugin.path, true);
			} catch (any e) {}
		}
		try {
			directoryDelete(variables.workDir, true);
		} catch (any e) {}
	}

	/*********************************** HELPERS ***********************************/

	// Register a plugin assigned to the site: a folder under the plugin directory
	// with a file at its root and one in a subfolder, plus its database rows.
	private struct function createPlugin() {
		var plugin = {
			moduleID = createUUID(),
			directory = "bundlePluginFilesSpec_" & replace(createUUID(), "-", "", "all")
		};
		plugin.path = application.configBean.getPluginDir() & "/" & plugin.directory;

		queryExecute("
			insert into tplugins (moduleID, name, deployed, created, loadPriority, directory)
			values (:moduleID, :name, 0, :created, 5, :directory)
		", {
			moduleID = plugin.moduleID,
			name = "Bundle spec plugin",
			created = {value = now(), cfsqltype = "cf_sql_timestamp"},
			directory = plugin.directory
		});

		// Assign the plugin to the site, as pluginManager does
		queryExecute("
			insert into tcontent (siteID, moduleID, contentID, contentHistID, parentID, type, subType, title,
				display, approved, isNav, active, forceSSL, searchExclude)
			values (:siteID, :moduleID, :moduleID, :moduleID, :moduleID, 'Plugin', 'Default', 'Bundle spec plugin',
				1, 1, 1, 1, 1, 1)
		", {siteID = variables.siteID, moduleID = plugin.moduleID});

		directoryCreate(plugin.path & "/includes");
		fileWrite(plugin.path & "/readme.txt", "readme");
		fileWrite(plugin.path & "/includes/display.cfm", "display");
		return plugin;
	}

	// Build a bundle with the given arguments and unzip it, and the
	// pluginfiles.zip inside it when there is one. Returns the unzip folder.
	private string function buildAndUnzip(required struct args) {
		var outDir = variables.workDir & createUUID() & "/";
		directoryCreate(outDir);
		var bundleArgs = {saveFile = true, saveFileDir = outDir};
		structAppend(bundleArgs, arguments.args);
		var bundlePath = application.serviceFactory.getBean("Bundle").Bundle(argumentCollection = bundleArgs);

		var unzipDir = outDir & "unzipped/";
		directoryCreate(unzipDir);
		cfzip(action = "unzip", file = bundlePath, destination = unzipDir);
		if (fileExists(unzipDir & "pluginfiles.zip")) {
			directoryCreate(unzipDir & "pluginfiles/");
			cfzip(action = "unzip", file = unzipDir & "pluginfiles.zip", destination = unzipDir & "pluginfiles/");
		}
		return unzipDir;
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {

		describe("Plugin bundle (Create and Download Plugin Bundle)", function() {

			it("includes the plugin's files", function() {
				var dir = buildAndUnzip({siteID = '', moduleID = variables.selected.moduleID, bundleMode = 'plugin'});

				expect(fileExists(dir & "pluginfiles.zip")).toBeTrue("pluginfiles.zip is missing from the bundle");
				expect(fileExists(dir & "pluginfiles/#variables.selected.directory#/readme.txt")).toBeTrue();
				expect(fileExists(dir & "pluginfiles/#variables.selected.directory#/includes/display.cfm")).toBeTrue();
			});

			it("includes only the selected plugin", function() {
				var dir = buildAndUnzip({siteID = '', moduleID = variables.selected.moduleID, bundleMode = 'plugin'});

				expect(directoryExists(dir & "pluginfiles/#variables.other.directory#")).toBeFalse();
			});

		});

		describe("Site bundle with plugins selected", function() {

			it("includes the selected plugins' files", function() {
				var dir = buildAndUnzip({siteID = variables.siteID, moduleID = variables.selected.moduleID & "," & variables.other.moduleID});

				expect(fileExists(dir & "pluginfiles.zip")).toBeTrue("pluginfiles.zip is missing from the bundle");
				expect(fileExists(dir & "pluginfiles/#variables.selected.directory#/readme.txt")).toBeTrue();
				expect(fileExists(dir & "pluginfiles/#variables.other.directory#/includes/display.cfm")).toBeTrue();
			});

		});

	}

}
