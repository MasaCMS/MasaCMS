/**
* pluginManager.createAppCFCIncludes() runs on every engine (MASA-478).
*
* It ends with a Lucee-only inspectTemplates() call. bx-compat-cfml defines server.lucee on
* BoxLang too, so a server.lucee guard let BoxLang call a function it doesn't have, and every
* plugin deploy or delete failed there.
*/
component extends="testbox.system.BaseSpec" {

	function run() {

		describe("pluginManager.createAppCFCIncludes()", function(){

			it("rebuilds the plugin includes without an error", function(){
				var pluginDir = application.configBean.getPluginDir();

				application.pluginManager.createAppCFCIncludes();

				expect(fileExists(pluginDir & "/mappings.cfm")).toBeTrue();
				expect(fileExists(pluginDir & "/cfapplication.cfm")).toBeTrue();
			});

		});
	}
}
