/**
* Security Tests for the shared bundle-archive validator (utility.validateBundleArchive).
* Verifies that unsafe bundle entries are rejected before extraction: executables in
* data archives, executables under web-served asset/cache paths in site archives, and
* server-configuration files in any archive; while legitimate theme templates in a site
* archive are allowed. This covers the bundle-import link of the reported RCE chain.
*/
component extends="testbox.system.BaseSpec" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		session.siteid = 'default';
		utility = application.serviceFactory.getBean('utility');
		variables.tmp = getTempDirectory() & "/bundlevalidator_" & createUUID() & "/";
		directoryCreate(variables.tmp);
	}

	function afterAll() {
		try {
			directoryDelete(variables.tmp, true);
		} catch (any e) {}
	}

	/*********************************** HELPERS ***********************************/

	// Build a zip at tmp/<name> whose entries are the given relative paths.
	private string function makeZip(required string name, required array files) {
		var zipPath = variables.tmp & arguments.name;
		var srcDir = variables.tmp & createUUID() & "/";
		directoryCreate(srcDir);
		for (var f in arguments.files) {
			var full = srcDir & f;
			var dir = getDirectoryFromPath(full);
			if (!directoryExists(dir)) {
				directoryCreate(dir, true);
			}
			fileWrite(full, "x");
		}
		cfzip(action="zip", file=zipPath, source=srcDir, recurse=true);
		return zipPath;
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {

		describe("Bundle archive validator", function() {

			it("allows a safe data archive (images, json)", function() {
				var z = makeZip("safe.zip", ["images/logo.png", "data.json"]);
				expect(function(){ utility.validateBundleArchive(z); }).notToThrow();
			});

			it("rejects an executable in a data archive", function() {
				var z = makeZip("dataexec.zip", ["shell.cfm"]);
				expect(function(){ utility.validateBundleArchive(z); }).toThrow(type="mura.security.unsafeBundleEntry");
			});

			it("allows a theme template in a site archive", function() {
				var z = makeZip("theme.zip", ["index.cfm", "layouts/default.cfm"]);
				expect(function(){ utility.validateBundleArchive(z, true); }).notToThrow();
			});

			it("rejects an executable under assets even in a site archive", function() {
				var z = makeZip("siteexec.zip", ["assets/shell.cfm"]);
				expect(function(){ utility.validateBundleArchive(z, true); }).toThrow(type="mura.security.unsafeBundleEntry");
			});

			it("rejects a server-configuration file in a site archive", function() {
				var z = makeZip("htaccess.zip", [".htaccess"]);
				expect(function(){ utility.validateBundleArchive(z, true); }).toThrow(type="mura.security.unsafeBundleEntry");
			});

			it("rejects a server-configuration file in a data archive", function() {
				var z = makeZip("webconfig.zip", ["web.config"]);
				expect(function(){ utility.validateBundleArchive(z); }).toThrow(type="mura.security.unsafeBundleEntry");
			});

		});

	}

}
