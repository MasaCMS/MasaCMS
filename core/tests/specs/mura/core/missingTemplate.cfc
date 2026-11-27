/**
* Requests for a .cfm file that does not exist, handled by onMissingTemplate().
*
* Masa redirects them to the site's 404 page. The redirect ends in an abort, which
* Lucee reports to onError() as the requested template being missing.
*/
component extends="testbox.system.BaseSpec" {

	function beforeAll() {
		variables.baseUrl = "http://localhost:" & new muraWRM.core.tests.resources.localServer().port()
			& application.configBean.getContext();
	}

	private struct function getWithoutRedirect(required string path) {
		var httpResult = "";
		cfhttp(url=variables.baseUrl & arguments.path, result="httpResult", redirect=false, timeout=30, throwonerror=false);
		return httpResult;
	}

	private void function expectRedirectTo404(required string path) {
		var response = getWithoutRedirect(arguments.path);

		expect(val(response.statusCode)).toBe(302, arguments.path);
		expect(response.responseHeader.location).toInclude("/404/", arguments.path);
	}

	function run() {

		describe("A request for a missing template", function(){

			it("redirects to the 404 page", function(){
				expectRedirectTo404("/missing-" & createUUID() & ".cfm");
			});

			it("redirects to the 404 page with a trailing slash", function(){
				expectRedirectTo404("/missing-" & createUUID() & ".cfm/");
			});

			it("redirects to the 404 page inside a site folder", function(){
				expectRedirectTo404("/default/missing-" & createUUID() & ".cfm");
			});

			it("redirects with extra path info", function(){
				// Where to differs per engine: Lucee goes to the 404 page, the others keep the path.
				var response = getWithoutRedirect("/missing-" & createUUID() & ".cfm/a/");

				expect(val(response.statusCode)).toBe(302);
				expect(response.responseHeader).toHaveKey("location");
			});

		});

	}

}
