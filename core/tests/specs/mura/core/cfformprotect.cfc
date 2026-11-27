/**
* Loading the CFFormProtect config (MASA-468). BoxLang returns an INI section
* from getProfileSections() as a struct, Lucee and ACF as a list of entry names.
*/
component extends="testbox.system.BaseSpec"{

	function run(){
		describe("CFFormProtect config", function() {

			it(
				title="cffpVerify loads every entry of the ini section",
				body=function() {
					var config = createObject("component", "cfformprotect.cffpVerify").init().getConfig();

					expect(config).toHaveKey("mouseMovement");
					expect(config).toHaveKey("failureLimit");
					expect(config.failureLimit).toBeNumeric();
					expect(config.logFile).notToBeEmpty();
				}
			);

			it(
				title="cffp.cfm renders the protection fields of a form",
				body=function() {
					var output = "";

					savecontent variable="output" {
						include "/cfformprotect/cffp.cfm";
					}

					expect(output).toInclude("cffm_applied");
				}
			);

		});
	}

}
