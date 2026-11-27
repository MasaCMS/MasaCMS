/**
* fileManager.streamFile() serves text and binary files (MASA-482).
*
* streamFile() opened the file with FileOpen(…, "readBinary") only to read its size for
* Content-Length. BoxLang refuses to open a text file that way, so serving a text form
* attachment returned 500. streamFile() ends the request, so the spec streams through
* core/tests/uploadHarness.cfm over real HTTP.
*/
component extends="testbox.system.BaseSpec" {

	function beforeAll() {
		variables.harnessUrl = "http://localhost:" & new muraWRM.core.tests.resources.localServer().port()
			& "/core/tests/uploadHarness.cfm";
	}

	private struct function stream(required string content, required string ext, boolean binary=false) {
		var httpResult = "";
		cfhttp(url=variables.harnessUrl, method="post", result="httpResult", timeout=30, throwonerror=false, getAsBinary="yes"){
			cfhttpparam(type="formfield", name="target", value="streamFile");
			cfhttpparam(type="formfield", name="content", value=arguments.content);
			cfhttpparam(type="formfield", name="ext", value=arguments.ext);
			cfhttpparam(type="formfield", name="binary", value=arguments.binary);
		}
		return httpResult;
	}

	function run() {

		describe("fileManager.streamFile() - real HTTP", function(){

			it("serves a text file with its content and length", function(){
				var expected = charsetDecode("form response attachment", "utf-8");
				var httpResult = stream(content="form response attachment", ext="txt");
				var body = isBinary(httpResult.fileContent) ? httpResult.fileContent : charsetDecode(httpResult.fileContent, "utf-8");

				expect(httpResult.statusCode).toInclude("200", charsetEncode(body, "utf-8"));
				expect(toBase64(body)).toBe(toBase64(expected));
				expect(httpResult.responseHeader["Content-Length"]).toBe(arrayLen(expected));
			});

			it("serves a binary file with its content and length", function(){
				var gif = "R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==";
				var httpResult = stream(content=gif, ext="gif", binary=true);

				expect(httpResult.statusCode).toInclude("200");
				expect(toBase64(httpResult.fileContent)).toBe(gif);
				expect(httpResult.responseHeader["Content-Length"]).toBe(arrayLen(binaryDecode(gif, "base64")));
			});

		});
	}
}
