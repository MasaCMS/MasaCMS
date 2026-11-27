/**
* Array-style query parameters of the JSON API, as Mura.js sends feed filters
* ("title[0]=Home").
*
* Masa reads these keys literally. Lucee 8 turns them into nested structs unless
* this.formUrlAsStruct is false, and then ignored the filters.
*/
component extends="testbox.system.BaseSpec" {

	function beforeAll() {
		variables.apiUrl = "http://localhost:" & new muraWRM.core.tests.resources.localServer().port()
			& application.configBean.getContext() & "/index.cfm/_api/json/v1/default/content/"
			// So that the home page, which every site has, can be found
			& "?includehomepage=1&shownavonly=0&showexcludesearch=1";
	}

	private array function titlesFound(required string filter) {
		var httpResult = "";
		cfhttp(url=variables.apiUrl & "&" & arguments.filter, result="httpResult", timeout=60, throwonerror=false);
		expect(val(httpResult.statusCode)).toBe(200, httpResult.fileContent);

		var titles = [];
		for (var item in deserializeJSON(httpResult.fileContent).data.items) {
			arrayAppend(titles, item.title);
		}
		return titles;
	}

	function run() {

		describe("JSON API filters with array-style keys", function(){

			it("finds the content that matches", function(){
				// title[0]=Home
				expect(titlesFound("title%5B0%5D=Home")).toBe(["Home"]);
			});

			it("finds nothing when nothing matches", function(){
				// title[0]=<unknown>
				expect(titlesFound("title%5B0%5D=" & createUUID())).toBeEmpty();
			});

			it("applies a condition", function(){
				// title[0]=neq^Home
				expect(titlesFound("title%5B0%5D=neq%5EHome")).notToInclude("Home");
			});

		});

	}

}
