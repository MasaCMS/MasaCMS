/**
* Security tests for the CSRF check in filebrowser.ckeditor_quick_upload().
*
* CKEditor protects uploads with a double-submit cookie: it sends a ckCsrfToken
* request field whose value must match the ckCsrfToken cookie it set on the
* same origin (CKEDITOR.tools.getCsrfToken()). The method must reject a request
* whose submitted token does not match the cookie, or where either is missing,
* before doing any upload work - and it must do so with a CKEditor-shaped error
* response rather than throwing.
*
* These specs call the bean directly with a non-privileged session, so a
* request that passes the token check stops at the permission gate
* ("Not allowed.") instead of attempting a real multipart upload.
*/
component extends="testbox.system.BaseSpec"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		session.siteid = 'default';
		variables.fb = application.serviceFactory.getBean('$').init('default').getBean('filebrowser');

		// A non-super-user session: a request that clears the CSRF gate is then
		// stopped by checkPerms() with "Not allowed.", which lets these specs
		// tell "rejected for CSRF" apart from "passed the CSRF check".
		param name="session.mura" default={};
		param name="session.mura.memberships" default="";
		variables.originalMemberships = session.mura.memberships;
		session.mura.memberships = '';
	}

	function afterAll(){
		session.mura.memberships = variables.originalMemberships;
		structDelete(cookie, 'ckcsrftoken');
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe("filebrowser.ckeditor_quick_upload() CSRF protection", function(){

			it("rejects a request whose submitted token does not match the cookie", function(){
				cookie.ckcsrftoken = "the-real-cookie-value";

				var response = deserializeJSON(fb.ckeditor_quick_upload(
					siteid       = 'default',
					directory    = '/Image',
					resourcePath = 'User_Assets',
					ckcsrftoken  = 'a-forged-value'
				));

				expect(response.uploaded).toBe(0);
				expect(response.error.message).toBe('Invalid CSRF token.');
			});

			it("rejects a request with no submitted token", function(){
				cookie.ckcsrftoken = "the-real-cookie-value";

				var response = deserializeJSON(fb.ckeditor_quick_upload(
					siteid       = 'default',
					directory    = '/Image',
					resourcePath = 'User_Assets'
				));

				expect(response.uploaded).toBe(0);
				expect(response.error.message).toBe('Invalid CSRF token.');
			});

			it("rejects a request when no token cookie is present", function(){
				structDelete(cookie, 'ckcsrftoken');

				var response = deserializeJSON(fb.ckeditor_quick_upload(
					siteid       = 'default',
					directory    = '/Image',
					resourcePath = 'User_Assets',
					ckcsrftoken  = 'any-value'
				));

				expect(response.uploaded).toBe(0);
				expect(response.error.message).toBe('Invalid CSRF token.');
			});

			it("passes the CSRF gate when the submitted token matches the cookie", function(){
				cookie.ckcsrftoken = "matching-token";

				var response = deserializeJSON(fb.ckeditor_quick_upload(
					siteid       = 'default',
					directory    = '/Image',
					resourcePath = 'User_Assets',
					ckcsrftoken  = 'matching-token'
				));

				// Non-super-user session: stopped by the permission gate, which
				// only runs once the token check has been cleared.
				expect(response.uploaded).toBe(0);
				expect(response.error.message).toBe('Not allowed.');
			});

		});

	}

}
