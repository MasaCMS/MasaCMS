/**
* Tests for filebrowser.ckeditor_quick_upload(), the endpoint CKEditor posts
* dragged/pasted images to (filebrowserImageUploadUrl in
* core/vendor/ckeditor/config.js.cfm).
*
* fileUpload() only sees a file the engine parsed off a genuine multipart POST,
* so the upload specs cfhttp a real file to the JSON API endpoint. That request
* shares this request's session (via its CFID/CFTOKEN cookies), which is how it
* gets the 'S2' membership checkPerms() requires.
*/
component extends="testbox.system.BaseSpec"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		session.siteid = 'default';
		variables.$ = application.serviceFactory.getBean('$').init('default');
		variables.imageDir = $.siteConfig().getAssetDir() & '/assets/Image';

		param name="session.mura" default={};
		param name="session.mura.memberships" default="";
		variables.originalMemberships = session.mura.memberships;
		session.mura.memberships = 'S2';

		// A real PNG whose name contains characters the upload cleans up.
		variables.fixtureDir = getTempDirectory() & 'ckeditorQuickUpload' & createUUID();
		directoryCreate(fixtureDir);
		variables.fixtureFile = fixtureDir & '/my photo (1).png';
		imageWrite(imageNew('', 2, 2, 'rgb', 'red'), fixtureFile);
	}

	function afterAll(){
		session.mura.memberships = variables.originalMemberships;
		directoryDelete(fixtureDir, true);
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe("filebrowser.ckeditor_quick_upload()", function(){

			it("returns a url and fileName that match the file it saved", function(){
				var endpoint = "http://localhost:" & getPageContext().getRequest().getLocalPort()
					& "/index.cfm/_api/json/v1/default/filebrowser/ckeditor_quick_upload?resourcepath=User_Assets&directory=/Image&responseType=json";

				cfhttp(url=endpoint, method="post", result="local.httpResult", timeout=30, throwonerror=false){
					cfhttpparam(type="cookie", name="CFID", value=session.cfid);
					cfhttpparam(type="cookie", name="CFTOKEN", value=session.cftoken);
					cfhttpparam(type="cookie", name="ckCsrfToken", value="test");
					cfhttpparam(type="formfield", name="ckCsrfToken", value="test");
					cfhttpparam(type="file", name="upload", file=fixtureFile, mimetype="image/png");
				}

				var response = deserializeJSON(httpResult.fileContent);

				try {
					expect(response.uploaded).toBe(1, httpResult.fileContent);
					expect(response.fileName).notToInclude(' ');
					expect(listLast(response.url, '/')).toBe(response.fileName);
					expect(response.url).notToInclude('\');
					expect(fileExists(imageDir & '/' & response.fileName)).toBeTrue(response.url);
				} finally {
					if(structKeyExists(response, 'fileName') && fileExists(imageDir & '/' & response.fileName)){
						fileDelete(imageDir & '/' & response.fileName);
					}
				}
			});

			it("returns a CKEditor error response for an illegal path instead of throwing", function(){
				var fb = prepareMock($.getBean('filebrowser'));
				fb.$("isPathLegal", false);
				cookie.ckcsrftoken = "test";

				var response = deserializeJSON(fb.ckeditor_quick_upload(
					siteid       = 'default',
					directory    = '/Image',
					resourcePath = 'User_Assets',
					ckcsrftoken  = 'test'
				));

				expect(response.uploaded).toBe(0);
				expect(response.error.message).toBe('Illegal file path.');
			});

		});

	}

}
