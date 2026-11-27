/**
* dataCollectionManager.update() stores a form attachment as a file (MASA-482).
*
* update() uploads every field whose name contains "attachment" and replaces its value
* with the ID of the stored file. It read the upload details from the implicit "file"
* variable, which BoxLang doesn't set; the error was swallowed and the response kept the
* upload temp path. The spec posts a real multipart upload through
* core/tests/uploadHarness.cfm, which calls update() and cleans up after itself.
*/
component extends="testbox.system.BaseSpec" {

	function beforeAll() {
		variables.tmp = getTempDirectory() & "formResponseAttachment_" & createUUID() & "/";
		directoryCreate(variables.tmp);
		variables.harnessUrl = "http://localhost:" & new muraWRM.core.tests.resources.localServer().port()
			& "/core/tests/uploadHarness.cfm";
	}

	function afterAll() {
		if (directoryExists(variables.tmp)) {
			directoryDelete(variables.tmp, true);
		}
	}

	private struct function submitWithAttachment(required string fileName) {
		var filePath = variables.tmp & arguments.fileName;
		fileWrite(filePath, charsetDecode("form response attachment", "utf-8"));
		var httpResult = "";
		cfhttp(url=variables.harnessUrl, method="post", result="httpResult", timeout=30, throwonerror=false){
			cfhttpparam(type="formfield", name="target", value="formResponse");
			cfhttpparam(type="file", name="upload_attachment", file=filePath);
		}
		expect(httpResult.statusCode).toInclude("200");
		var json = deserializeJSON(httpResult.fileContent);
		expect(json.success).toBeTrue(serializeJSON(json));
		return json.response;
	}

	function run() {

		describe("dataCollectionManager.update() with an attachment - real HTTP upload", function(){

			it("stores the attachment as a file and keeps its ID in the response", function(){
				var response = submitWithAttachment("note.txt");
				expect(response.isFileID).toBeTrue("stored value: " & response.storedValue);
				expect(response.fileStored).toBeTrue();
				expect(response.fileName).toBe("note.txt");
			});

		});
	}
}
