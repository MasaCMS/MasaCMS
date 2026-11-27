/**
* fileManager.isPostedFile() and getPostedClientFileName() across engines (MASA-469).
*
* The form value of a file field is the path of the engine's upload temp file, and its
* name differs per engine: Lucee "*.upload", Adobe "*.tmp", BoxLang (Undertow)
* "undertow<digits>upload" without a dot. The HTTP specs post a real multipart upload
* through core/tests/uploadHarness.cfm, so each engine is tested with its own temp file.
*/
component extends="testbox.system.BaseSpec" {

	function beforeAll() {
		variables.fileManager = application.serviceFactory.getBean('fileManager');
		variables.tmp = getTempDirectory() & "postedFileDetection_" & createUUID() & "/";
		directoryCreate(variables.tmp);
		variables.harnessUrl = "http://localhost:" & new muraWRM.core.tests.resources.localServer().port()
			& "/core/tests/uploadHarness.cfm";
	}

	function afterAll() {
		if (directoryExists(variables.tmp)) {
			directoryDelete(variables.tmp, true);
		}
	}

	private struct function postFile(required string fileName) {
		var filePath = variables.tmp & arguments.fileName;
		fileWrite(filePath, charsetDecode("posted file detection", "utf-8"));
		var httpResult = "";
		cfhttp(url=variables.harnessUrl, method="post", result="httpResult", timeout=30, throwonerror=false){
			cfhttpparam(type="formfield", name="target", value="postedFile");
			cfhttpparam(type="file", name="file", file=filePath);
		}
		expect(httpResult.statusCode).toInclude("200");
		var json = deserializeJSON(httpResult.fileContent);
		expect(json.success).toBeTrue(serializeJSON(json));
		return json.response;
	}

	function run() {

		describe("fileManager.isPostedFile() temp file names", function(){

			it("recognises the upload temp file names of Lucee, Adobe and BoxLang", function(){
				expect(variables.fileManager.isPostedFile("/opt/lucee/temp/tmp-123.upload")).toBeTrue();
				expect(variables.fileManager.isPostedFile("C:\ColdFusion\runtime\work\neotmp123.tmp")).toBeTrue();
				expect(variables.fileManager.isPostedFile("/tmp/undertow4271970800421256794upload")).toBeTrue();
			});

			it("does not treat other local paths as uploads", function(){
				expect(variables.fileManager.isPostedFile("/var/data/image.png")).toBeFalse();
				expect(variables.fileManager.isPostedFile("/var/data/myupload")).toBeFalse();
				expect(variables.fileManager.isPostedFile("/var/data/backup.tmp.png")).toBeFalse();
			});

		});

		describe("fileManager posted file detection - real HTTP upload", function(){

			it("recognises a posted file by field name and by value", function(){
				var response = postFile("sample.png");
				expect(response.isPostedFile).toBeTrue();
				expect(response.isPostedFileByValue).toBeTrue();
			});

			it("returns the client file name of a posted file", function(){
				var response = postFile("sample.png");
				expect(response.postedClientFileName).toBe("sample.png");
				expect(response.requestHasRestrictedFiles).toBeFalse();
			});

			it("flags a posted file with a restricted extension", function(){
				var response = postFile("sample.cfm");
				expect(response.postedClientFileName).toBe("sample.cfm");
				expect(response.requestHasRestrictedFiles).toBeTrue();
			});

		});
	}
}
