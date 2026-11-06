/**
* Tests for the CSRF check in the admin cSettings.createBundle() action (issue #465).
*
* Two screens post to this action, each with its own token context:
* - Site Settings > Create Site Bundle (selectbundleoptions.cfm) renders a token
*   for 'createbundle' & siteID and may send any number of ticked plugins as moduleID.
* - The plugin's "Create and Download Plugin Bundle" link (editplugin.cfm) renders
*   a token for 'createbundle' & moduleID and sends bundleMode=plugin with no siteID.
*
* These specs call the real controller with real tokens and a stub framework that
* records redirects. Requests that pass the check build a real bundle into a temp
* directory (the "Server Directory" option), so the zip is written to disk instead
* of being streamed into the response.
*/
component extends="testbox.system.BaseSpec" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		session.siteid = 'default';
		variables.siteID = 'default';
		variables.saveFileDir = getTempDirectory() & "createbundlecsrf_" & createUUID() & "/";
		directoryCreate(variables.saveFileDir);

		variables.redirects = [];
		var fw = {};
		fw.redirect = function(action, append="", path="") {
			arrayAppend(variables.redirects, arguments.action);
		};
		variables.controller = createObject("component", "muraWRM.admin.core.controllers.csettings");
		variables.controller.init(fw=fw);
	}

	function afterAll() {
		try {
			directoryDelete(variables.saveFileDir, true);
		} catch (any e) {}
	}

	/*********************************** HELPERS ***********************************/

	// Build the request the browser sends: a token for tokenContext plus the given
	// fields, and the matching Mura scope the controller validates the token against.
	// Also clears the recorded redirects, so each spec sees only its own.
	private struct function buildRequest(required string tokenContext, struct fields={}) {
		arrayClear(variables.redirects);
		var $ = application.serviceFactory.getBean('$').init(variables.siteID);
		var csrf = $.generateCSRFTokens(context=arguments.tokenContext);
		var rc = {
			siteID = variables.siteID,
			saveFileDir = variables.saveFileDir,
			csrf_token = csrf.token,
			csrf_token_expires = csrf.expires
		};
		structAppend(rc, arguments.fields, true);
		for (var key in rc) {
			$.event(key, rc[key]);
		}
		rc.$ = $;
		return rc;
	}

	private function expectBundleCreated(required struct rc) {
		expect(variables.redirects).toBeEmpty();
		expect(arguments.rc).toHaveKey('bundleFilePath');
		expect(fileExists(arguments.rc.bundleFilePath)).toBeTrue();
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {

		describe("cSettings.createBundle() from the site bundle form", function() {

			it("creates the bundle when no plugins are ticked", function() {
				var rc = buildRequest('createbundle' & variables.siteID);

				variables.controller.createBundle(rc);

				expectBundleCreated(rc);
			});

			it("creates the bundle when one plugin is ticked", function() {
				var rc = buildRequest('createbundle' & variables.siteID, {moduleID = createUUID()});

				variables.controller.createBundle(rc);

				expectBundleCreated(rc);
			});

			it("creates the bundle when several plugins are ticked", function() {
				var rc = buildRequest('createbundle' & variables.siteID, {moduleID = createUUID() & "," & createUUID()});

				variables.controller.createBundle(rc);

				expectBundleCreated(rc);
			});

			it("rejects an invalid token and returns to the bundle options screen", function() {
				var rc = buildRequest('createbundle' & variables.siteID, {moduleID = createUUID()});
				rc.$.event('csrf_token', 'forged');

				variables.controller.createBundle(rc);

				expect(variables.redirects).toBe(['cSettings.selectBundleOptions']);
				expect(rc).notToHaveKey('bundleFilePath');
			});

			it("rejects a plugin bundle token", function() {
				var moduleID = createUUID();
				var rc = buildRequest('createbundle' & moduleID, {moduleID = moduleID});

				variables.controller.createBundle(rc);

				expect(variables.redirects).toBe(['cSettings.selectBundleOptions']);
				expect(rc).notToHaveKey('bundleFilePath');
			});

		});

		describe("cSettings.createBundle() from the plugin bundle link", function() {

			it("creates the plugin bundle", function() {
				var moduleID = createUUID();
				var rc = buildRequest('createbundle' & moduleID, {moduleID = moduleID, siteID = '', bundleMode = 'plugin'});

				variables.controller.createBundle(rc);

				expectBundleCreated(rc);
			});

			it("rejects an invalid token and returns to the plugin screen", function() {
				var moduleID = createUUID();
				var rc = buildRequest('createbundle' & moduleID, {moduleID = moduleID, siteID = '', bundleMode = 'plugin'});
				rc.$.event('csrf_token', 'forged');

				variables.controller.createBundle(rc);

				expect(variables.redirects).toBe(['cSettings.editPlugin']);
				expect(rc).notToHaveKey('bundleFilePath');
			});

			it("rejects a site bundle token", function() {
				var rc = buildRequest('createbundle' & variables.siteID, {moduleID = createUUID(), bundleMode = 'plugin'});

				variables.controller.createBundle(rc);

				expect(variables.redirects).toBe(['cSettings.editPlugin']);
				expect(rc).notToHaveKey('bundleFilePath');
			});

		});

	}

}
