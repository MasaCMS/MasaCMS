/**
* Security regression tests for the site-member profile photo SSRF (GHSA-5f94-56xw-97rh).
*
* The front-end createprofile/updateprofile actions copy request values into the
* user bean, including newFile and File extended attributes. When such a value
* is not a posted upload, userManager.setPhotoFile() and
* extendManager.saveExtendedData() used to hand it to fileManager.emulateUpload(),
* which fetches URLs with cfhttp and reads server filesystem paths.
*
* The fix only lets callers with the Users module permission import a file from
* a URL or path. These specs swap emulateUpload() on the fileManager singleton for
* a stub that throws, so they assert that no fetch is attempted without needing
* network access. A member caller pins memberships to empty, so the permission
* is false deterministically; the authorized caller uses 'S2', which
* getModulePerm() short-circuits without a database lookup.
*/
component extends="testbox.system.BaseSpec" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		session.siteid = 'default';
		variables.siteid = 'default';
		variables.userManager = application.serviceFactory.getBean('userManager');
		variables.fileManager = application.serviceFactory.getBean('fileManager');
		variables.classExtensionManager = application.serviceFactory.getBean('configBean').getClassExtensionManager();
		variables.originalMemberships = session.mura.memberships;
		variables.createdUserIDs = [];

		session.mura.memberships = 'S2';

		// A User subtype with a File attribute, for the extended-attribute entry point.
		variables.subType = classExtensionManager.getSubTypeBean();
		subType.setType('User');
		subType.setSubType('SSRFPhotoTest');
		subType.setSiteID(siteid);
		subType.load();
		subType.save();

		variables.extendSet = subType.getExtendSetBean();
		extendSet.setName('SSRF Photo Test');
		extendSet.save();

		var attribute = extendSet.getAttributeBean();
		attribute.setName('ssrfPhotoTestFile');
		attribute.setLabel('SSRF Photo Test File');
		attribute.setType('File');
		attribute.save();

		// The member whose profile the update specs edit.
		variables.member = userManager.create(memberData('existing'));
		arrayAppend(createdUserIDs, member.getUserID());

		session.mura.memberships = originalMemberships;
	}

	function afterAll() {
		restoreEmulateUpload();
		session.mura.memberships = 'S2';
		for (var userID in createdUserIDs) {
			userManager.read(userID).delete();
		}
		subType.delete();
		session.mura.memberships = originalMemberships;
	}

	// Values an attacker would put in newFile. Each ends in .png so the
	// restricted-extension check does not reject the request before the sink.
	private array function attackerFileValues() {
		return [
			'http://127.0.0.1:9/ssrf-probe.png',
			'https://169.254.169.254/latest/meta-data/ssrf-probe.png',
			'/etc/ssrf-probe.png',
			'file:///etc/ssrf-probe.png',
			'\\attacker.invalid\share\ssrf-probe.png'
		];
	}

	private struct function memberData(required string suffix) {
		var token = left(replace(createUUID(), '-', '', 'all'), 12);
		return {
			userid = '',
			siteid = siteid,
			type = 2,
			fname = 'SSRF',
			lname = 'Photo #arguments.suffix#',
			username = 'ssrfphoto#token#',
			email = 'ssrfphoto#token#@example.invalid'
		};
	}

	// Replace emulateUpload() with a stub that throws instead of fetching, so a
	// call fails the member specs with the requested value in the message and
	// the authorized specs can assert the call was made.
	private void function stubEmulateUpload() {
		if (!structKeyExists(variables, 'originalEmulateUpload')) {
			variables.originalEmulateUpload = fileManager.emulateUpload;
		}
		fileManager.emulateUpload = function(filePath) {
			throw(type='ssrf.emulateUploadCalled', message='emulateUpload() was called with #arguments.filePath#');
		};
	}

	private void function restoreEmulateUpload() {
		if (structKeyExists(variables, 'originalEmulateUpload')) {
			fileManager.emulateUpload = variables.originalEmulateUpload;
		}
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {

		describe("Profile photo SSRF hardening (newFile)", function() {

			beforeEach(function() {
				stubEmulateUpload();
			});

			afterEach(function() {
				restoreEmulateUpload();
				session.mura.memberships = originalMemberships;
			});

			describe("member caller (no Users module permission)", function() {

				beforeEach(function() {
					session.mura.memberships = '';
				});

				it("does not fetch newFile on create (createprofile)", function() {
					for (var value in attackerFileValues()) {
						var data = memberData('create');
						data.newFile = value;
						var userBean = userManager.create(data);
						arrayAppend(createdUserIDs, userBean.getUserID());

						expect(structIsEmpty(userBean.getErrors())).toBeTrue("create should succeed for '#value#': #serializeJSON(userBean.getErrors())#");
						expect(userBean.getPhotoFileID()).toBe('', "no photo should be set from '#value#'");
					}
				});

				it("does not fetch newFile on update (updateprofile)", function() {
					for (var value in attackerFileValues()) {
						var data = userManager.read(member.getUserID()).getAllValues();
						data.newFile = value;
						var userBean = userManager.update(data, false, true, siteid);

						expect(structIsEmpty(userBean.getErrors())).toBeTrue("update should succeed for '#value#': #serializeJSON(userBean.getErrors())#");
						expect(userBean.getPhotoFileID()).toBe('', "no photo should be set from '#value#'");
					}
				});

				it("does not fetch a File extended attribute", function() {
					for (var value in attackerFileValues()) {
						var data = userManager.read(member.getUserID()).getAllValues();
						data.subType = 'SSRFPhotoTest';
						data.extendSetID = extendSet.getExtendSetID();
						data.ssrfPhotoTestFile = value;
						var userBean = userManager.update(data, false, true, siteid);

						expect(structIsEmpty(userBean.getErrors())).toBeTrue("update should succeed for '#value#': #serializeJSON(userBean.getErrors())#");
					}
					expect(userManager.read(member.getUserID()).getValue('ssrfPhotoTestFile')).toBe('', "no file should be stored on the attribute");
				});

			});

			describe("authorized caller (holds Users module permission)", function() {

				beforeEach(function() {
					session.mura.memberships = 'S2';
				});

				it("still imports newFile from a URL", function() {
					var data = userManager.read(member.getUserID()).getAllValues();
					data.newFile = 'http://127.0.0.1:9/ssrf-probe.png';

					expect(function() {
						userManager.update(data, false, true, siteid);
					}).toThrow(type='ssrf.emulateUploadCalled');
				});

				it("still imports a File extended attribute from a URL", function() {
					var data = userManager.read(member.getUserID()).getAllValues();
					data.subType = 'SSRFPhotoTest';
					data.extendSetID = extendSet.getExtendSetID();
					data.ssrfPhotoTestFile = 'http://127.0.0.1:9/ssrf-probe.png';

					expect(function() {
						userManager.update(data, false, true, siteid);
					}).toThrow(type='ssrf.emulateUploadCalled');
				});

			});

		});

	}

}
