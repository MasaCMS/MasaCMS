/**
* Tests for how the JSON API returns the result of an entity's remote function
* (/_api/json/v1/{siteid}/{entityname}/{remotefunction}).
*
* CKEditor posts dragged/pasted images to filebrowser/ckeditor_quick_upload and
* expects { uploaded, fileName, url } or { uploaded: 0, error: { message } } at
* the top level of the response body. That method returns a pre-serialized JSON
* string, which the API used to wrap (double-encoded) in its
* { apiversion, method, data } envelope, so CKEditor reported "undefined" and
* dropped the image.
*/
component extends="testbox.system.BaseSpec"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		session.siteid = 'default';
		variables.$ = application.serviceFactory.getBean('$').init('default');
		variables.apiUtility = $.siteConfig().getApi('json','v1');

		application.serviceFactory.getBean('configBean').registerModelDir(dir="/muraWRM/core/tests/resources/model",siteid="default");

		// Make sure the remote functions are registered in application.objectMappings,
		// which is what the API checks before routing to them.
		$.getBean('filebrowser');
		$.getBean('testRemoteProbe');

		// The arguments CKEditor sends with every upload (see filebrowserImageUploadUrl
		// in core/vendor/ckeditor/config.js.cfm). The API builds the method's
		// arguments from the url and form scopes.
		param name="cookie.ckcsrftoken" default="test";
		form.ckcsrftoken = "test";
		form.resourcepath = "User_Assets";
		form.directory = "/Image";

		// Without a module permission, ckeditor_quick_upload() returns its
		// "Not allowed." response before touching the upload, so no multipart
		// request is needed. Snapshot so we don't leak state into other specs.
		param name="session.mura" default={};
		param name="session.mura.memberships" default="";
		variables.originalMemberships = session.mura.memberships;
		session.mura.memberships = '';
	}

	function afterAll(){
		session.mura.memberships = variables.originalMemberships;
		structDelete(form, 'ckcsrftoken');
		structDelete(form, 'resourcepath');
		structDelete(form, 'directory');
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe("JSON API remote function responses", function(){

			it("returns ckeditor_quick_upload's response unwrapped, in the shape CKEditor expects", function(){
				var response = deserializeJSON(apiUtility.processRequest(path='/_api/json/v1/default/filebrowser/ckeditor_quick_upload'));

				expect(response).notToHaveKey('apiversion');
				expect(response).toHaveKey('uploaded');
				expect(response.uploaded).toBe(0);
				expect(response.error.message).toBe('Not allowed.');
			});

			it("returns any JSON object string from a remote function unwrapped", function(){
				var response = deserializeJSON(apiUtility.processRequest(path='/_api/json/v1/default/testRemoteProbe/returnsJSONObjectString'));

				expect(response).toBe({"probe": 1});
			});

			it("still wraps a scalar result, even when it is valid JSON", function(){
				var response = deserializeJSON(apiUtility.processRequest(path='/_api/json/v1/default/testRemoteProbe/returnsBooleanString'));

				expect(response).toHaveKey('apiversion');
				expect(response.data).toBe("true");
			});

			it("still wraps a struct result", function(){
				var response = deserializeJSON(apiUtility.processRequest(path='/_api/json/v1/default/user/pollState'));

				expect(response).toHaveKey('apiversion');
				expect(response.method).toBe('pollState');
			});

		});

	}

}
