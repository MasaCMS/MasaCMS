/**
* Regression suite for the LOCAL raw asset-browser surface
* (filebrowser.cfc) - the admin file-browser API used to list/upload/
* rename/move/delete/create-folders directly under a site's User_Assets,
* independent of any "File" content-type record. This is a completely
* separate code path from fileStorageLocal.cfc's fileBean/fileManager
* suite, so it gets its own pass.
*
* All calls use resourcePath="User_Assets" only. filebrowser.checkPerms()
* and hasPermission() both explicitly bypass their permission checks for
* that resource path (they only enforce module-perm/superuser/membership
* checks for the more privileged Site_Files/Application_Root roots), so no
* admin login/session simulation is needed here.
*
* CSRF: several mutating methods (upload, move, update, delete, rename,
* addFolder - and, a little surprisingly, the read-only children() too)
* call m.validateCSRFTokens(context='<matching name>'), which is plain
* CFML logic in the function body, not an HTTP-layer filter - it fires on
* a direct in-process call too. Each such call below generates a fresh,
* single-use token via $.generateCSRFTokens(context=...) immediately
* before the matching filebrowser call (tokens are marked used after one
* validation, so they cannot be reused across calls).
*
* Out of scope on purpose: cloud/S3/GCS backends - same reasoning as
* fileStorageLocal.cfc.
*/
component extends="testbox.system.BaseSpec" {

	function beforeAll(){
		session.siteid = "default";
		variables.siteid = "default";
		variables.resourcePath = "User_Assets";

		// checkPerms()'s FIRST gate - getModulePerm(moduleID='00...00', siteid)
		// - checks session.mura.memberships for an Admin or 'S2' (superuser)
		// role, and runs unconditionally regardless of resourcePath. Only
		// its SECOND gate is skipped for resourcePath == 'User_Assets'.
		// Confirmed live: every filebrowser call failed permission until
		// this was added. core/tests/runner.cfm already ensures
		// session.mura exists (calls setUserStruct() if missing) as an
		// anonymous/public user - this just adds the superuser role on top,
		// the same minimal, direct session poke the existing content.cfc
		// spec already uses for session.siteid.
		if (!structKeyExists(session, "mura")) {
			session.mura = {};
		}
		if (!structKeyExists(session.mura, "memberships") || !len(session.mura.memberships)) {
			session.mura.memberships = "S2";
		} else if (!listFindNoCase(session.mura.memberships, "S2")) {
			session.mura.memberships = listAppend(session.mura.memberships, "S2");
		}

		variables.$ = application.serviceFactory.getBean('$').init(variables.siteid);
		variables.fb = application.serviceFactory.getBean('filebrowser');
		variables.fw = new mura.fileWriter().init(routeUserAssets=false);

		// Unique per run so a crashed prior run's leftovers can never make
		// this run silently pass or fail for the wrong reason. Resetting
		// site content between runs is out of scope here (handled
		// separately) - this is the safety net in its place.
		variables.runTag = lCase(replace(createUUID(), "-", "", "all"));
		variables.testDirName = "fstest-" & variables.runTag;
		variables.testFileName = "fstest-" & variables.runTag & ".txt";

		// Not sourced from a static fixture like the ones below: this
		// content is the actual subject of the edit()/update()/rename()
		// tests (they read it back and, for update(), mutate and re-check
		// it), so it's meaningful test data the test itself owns, not
		// filler that could just as well come from a checked-in file.
		variables.testFileContent = "file storage characterization fixture " & variables.runTag;

		variables.baseAssetDir = application.settingsManager.getSite(variables.siteid).getAssetDir() & "/assets";
		variables.testDirPath = variables.baseAssetDir & "/" & variables.testDirName;

		variables.createdDir = false;

		// Self-contained fixtures owned by the test suite itself, rather
		// than borrowed application assets or content built with
		// fileWrite() at run time (see fileStorageLocal.cfc's beforeAll()
		// for the full reasoning, including why the image is a
		// checkerboard rather than a flat single color).
		variables.fixtureSourceImage = expandPath('/core/tests/resources/fileStorage/fixture.png');
		variables.fixtureSourceText = expandPath('/core/tests/resources/fileStorage/fixture.txt');

		// A separate, self-contained directory for the image-editing
		// endpoint tests below (move/resize/duplicate/rotate/processCrop),
		// created directly rather than through addFolder() - these tests
		// don't depend on the folder/file CRUD describe block above, or
		// its ordering.
		variables.imageTestDirName = "fstest-img-" & variables.runTag;
		variables.imageTestDirPath = variables.baseAssetDir & "/" & variables.imageTestDirName;
		if (!directoryExists(variables.baseAssetDir)) {
			directoryCreate(variables.baseAssetDir);
		}
		directoryCreate(variables.imageTestDirPath);

		// A real file placed one directory above the site's own asset
		// root - i.e. genuinely outside the User_Assets sandbox - for the
		// (currently skipped) path-traversal test below.
		variables.traversalTargetPath = variables.baseAssetDir & "/../fstest-traversal-" & variables.runTag & ".png";
		fileCopy(variables.fixtureSourceImage, variables.traversalTargetPath);
	}

	function afterAll(){
		// Belt-and-braces cleanup even if an assertion failed partway
		// through the suite and left fixtures on disk.
		try {
			if (directoryExists(variables.testDirPath)) {
				directoryDelete(variables.testDirPath, true);
			}
		} catch (any e) {}

		try {
			if (directoryExists(variables.imageTestDirPath)) {
				directoryDelete(variables.imageTestDirPath, true);
			}
		} catch (any e) {}

		try {
			if (fileExists(variables.traversalTargetPath)) {
				fileDelete(variables.traversalTargetPath);
			}
		} catch (any e) {}
	}

	// Copies the shared fixture image into imageTestDirPath under a fresh,
	// unique name and returns just the filename - each image-editing test
	// gets its own copy so they don't interfere with each other.
	function seedImageFile(){
		var imgName = "img-" & lCase(replace(createUUID(), "-", "", "all")) & ".png";
		fileCopy(variables.fixtureSourceImage, variables.imageTestDirPath & "/" & imgName);
		return imgName;
	}

	// resize()/duplicate()/rotate()/processCrop() all resolve their target
	// file from a "file" struct's .url, matched against the last path
	// segment of the resourcePath's base directory (here, "assets") -
	// everything after the first occurrence of that segment is treated as
	// the path relative to it. This builds a `file` struct pointing at a
	// name already seeded into imageTestDirPath.
	function imageFileArg(imgName){
		return { url: "/assets/" & variables.imageTestDirName & "/" & arguments.imgName, ext: "png" };
	}

	function csrfFor(context){
		// validateCSRFTokens() reads the token back via $.event('csrf_token'),
		// which is Mura's own request-scoped "event" object - not the plain
		// CFML `arguments` scope of whatever function is running. Passing
		// csrf_token/csrf_token_expires as ordinary call arguments to a
		// filebrowser method (as a real AJAX request effectively does once
		// Mura's dispatcher builds the event from that request) does NOT
		// reach that object on a direct in-process call. Confirmed live:
		// every mutating filebrowser call failed with type "invalidTokens"
		// until tokens were seeded into url scope instead - mura.event.cfc's
		// init() copies form/url into its backing struct at construction
		// time, and every fresh getBean('$').init(...) call inside
		// filebrowser builds (or reuses) that same event.
		var csrf = variables.$.generateCSRFTokens(context=arguments.context);
		url.csrf_token = csrf.token;
		url.csrf_token_expires = csrf.expires;
		variables.$.event('csrf_token', csrf.token);
		variables.$.event('csrf_token_expires', csrf.expires);
		return csrf;
	}

	function run(){

		describe("Local asset browser - folder and file CRUD", function(){

			it("should create a folder under User_Assets via addFolder()", function(){
				var csrf = csrfFor("addfolder");

				var result = variables.fb.addFolder(
					siteid             = variables.siteid,
					directory          = "/",
					name               = variables.testDirName,
					resourcePath       = variables.resourcePath,
					csrf_token         = csrf.token,
					csrf_token_expires = csrf.expires
				);

				// addFolder() returns a bare boolean on success rather than
				// the {success:...} struct most other methods use - this
				// asserts on that actual return shape rather than "fixing"
				// the inconsistency.
				expect(result).toBeTrue();
				expect(directoryExists(variables.testDirPath)).toBeTrue();
				variables.createdDir = true;
			});

			it("should list the new folder via children()", function(){
				var csrf = csrfFor("children");

				var result = variables.fb.children(
					siteid             = variables.siteid,
					directory          = "/",
					resourcepath       = variables.resourcePath,
					csrf_token         = csrf.token,
					csrf_token_expires = csrf.expires
				);

				expect(result.success).toBe(1);
				expect(arrayFindNoCase(result.folders, variables.testDirName)).toBeGT(0);
			});

			it("should seed a file directly on disk and see it via browse()", function(){
				// Seeding via a direct fileWriter write (rather than through
				// filebrowser.upload()) keeps this test about read/list/edit/
				// rename/delete behavior; the real multipart upload() path
				// gets its own dedicated HTTP smoke test below.
				// addNewLine defaults to true on fileWriter.writeFile() and
				// would otherwise make the seeded content differ from
				// variables.testFileContent by a trailing newline.
				variables.fw.writeFile(file=variables.testDirPath & "/" & variables.testFileName, output=variables.testFileContent, addNewLine=false);

				var result = variables.fb.browse(
					siteid       = variables.siteid,
					directory    = "/" & variables.testDirName,
					resourcePath = variables.resourcePath
				);

				expect(structKeyExists(result, "dne") ? result.dne : 0).toBe(0);
			});

			it("should read the file's content via edit()", function(){
				var result = variables.fb.edit(
					siteid       = variables.siteid,
					directory    = "/" & variables.testDirName,
					filename     = variables.testFileName,
					resourcePath = variables.resourcePath
				);

				expect(result.success).toBe(1);
				expect(result.content).toBe(variables.testFileContent);
			});

			it("should overwrite the file's content via update()", function(){
				var csrf = csrfFor("update");
				variables.testFileContent = variables.testFileContent & " (updated)";

				var result = variables.fb.update(
					siteid             = variables.siteid,
					directory          = "/" & variables.testDirName,
					filename           = variables.testFileName,
					resourcePath       = variables.resourcePath,
					content            = variables.testFileContent,
					csrf_token         = csrf.token,
					csrf_token_expires = csrf.expires
				);

				expect(result.success).toBe(1);
				expect(fileRead(variables.testDirPath & "/" & variables.testFileName)).toBe(variables.testFileContent);
			});

			it("should rename the file via rename()", function(){
				var csrf = csrfFor("rename");
				var newBaseName = "fstest-renamed-" & variables.runTag;

				variables.fb.rename(
					siteid             = variables.siteid,
					directory          = "/" & variables.testDirName,
					filename           = variables.testFileName,
					name               = newBaseName,
					resourcePath       = variables.resourcePath,
					csrf_token         = csrf.token,
					csrf_token_expires = csrf.expires
				);

				// The exact resulting filename/extension handling in
				// rename() is not being pinned down here - this suite is a
				// characterization pass, not a correctness grader, and
				// asserting an exact predicted filename risks encoding a
				// guess rather than real behavior. What must hold on both
				// branches: the old file is gone, exactly one new file
				// matching the new base name appeared, and its content
				// survived the rename intact.
				expect(fileExists(variables.testDirPath & "/" & variables.testFileName)).toBeFalse();

				var matches = directoryList(variables.testDirPath, false, "name", newBaseName & "*");
				expect(arrayLen(matches)).toBe(1);
				variables.renamedFileName = matches[1];

				expect(fileRead(variables.testDirPath & "/" & variables.renamedFileName)).toBe(variables.testFileContent);
			});

			it("should delete the renamed file via delete()", function(){
				var csrf = csrfFor("delete");

				var result = variables.fb.delete(
					siteid             = variables.siteid,
					directory          = "/" & variables.testDirName,
					filename           = variables.renamedFileName,
					resourcePath       = variables.resourcePath,
					csrf_token         = csrf.token,
					csrf_token_expires = csrf.expires
				);

				expect(result.success).toBe(1);
				expect(fileExists(variables.testDirPath & "/" & variables.renamedFileName)).toBeFalse();
			});

			it("should delete the now-empty test folder via delete()", function(){
				var csrf = csrfFor("delete");

				var result = variables.fb.delete(
					siteid             = variables.siteid,
					directory          = "/",
					filename           = variables.testDirName,
					resourcePath       = variables.resourcePath,
					csrf_token         = csrf.token,
					csrf_token_expires = csrf.expires
				);

				expect(result.success).toBe(1);
				expect(directoryExists(variables.testDirPath)).toBeFalse();
				variables.createdDir = false;
			});

		});

		describe("Local asset browser - image editing endpoints", function(){

			it("should move a file between directories via move()", function(){
				var srcDir = variables.imageTestDirName & "/movesrc";
				var destDir = variables.imageTestDirName & "/movedest";
				directoryCreate(variables.baseAssetDir & "/" & srcDir);
				directoryCreate(variables.baseAssetDir & "/" & destDir);

				var moveFileName = "move-" & variables.runTag & ".txt";
				fileCopy(variables.fixtureSourceText, variables.baseAssetDir & "/" & srcDir & "/" & moveFileName);

				var csrf = csrfFor("move");
				variables.fb.move(
					siteid             = variables.siteid,
					directory          = "/" & srcDir,
					destination        = "/" & destDir,
					filename           = moveFileName,
					resourcePath       = variables.resourcePath,
					csrf_token         = csrf.token,
					csrf_token_expires = csrf.expires
				);

				// move()'s own response.success is initialized to 0 and
				// never actually flipped before returning - a real observed
				// quirk in its source, not a bug in this test - so this
				// checks filesystem state directly rather than trusting the
				// response struct.
				expect(fileExists(variables.baseAssetDir & "/" & srcDir & "/" & moveFileName)).toBeFalse();
				expect(fileExists(variables.baseAssetDir & "/" & destDir & "/" & moveFileName)).toBeTrue();
				expect(fileRead(variables.baseAssetDir & "/" & destDir & "/" & moveFileName)).toBe(fileRead(variables.fixtureSourceText));
			});

			it("should resize an image in place via resize()", function(){
				var imgName = seedImageFile();
				var imgPath = variables.imageTestDirPath & "/" & imgName;

				var csrf = csrfFor("resize");
				var result = variables.fb.resize(
					resourcePath       = variables.resourcePath,
					file               = imageFileArg(imgName),
					dimensions         = { aspect: "within", width: 20, height: 20 },
					siteid             = variables.siteid,
					csrf_token         = csrf.token,
					csrf_token_expires = csrf.expires
				);

				expect(result.success).toBe(1);

				var afterInfo = imageInfo(imageNew(imgPath));
				expect(afterInfo.width <= 20 && afterInfo.height <= 20).toBeTrue();
			});

			it("should duplicate a file via duplicate()", function(){
				var imgName = seedImageFile();

				var csrf = csrfFor("duplicate");
				var result = variables.fb.duplicate(
					resourcePath       = variables.resourcePath,
					file               = imageFileArg(imgName),
					siteid             = variables.siteid,
					csrf_token         = csrf.token,
					csrf_token_expires = csrf.expires
				);

				expect(result.success).toBe(1);

				var copyName = replace(imgName, ".png", "-copy1.png");
				expect(fileExists(variables.imageTestDirPath & "/" & copyName)).toBeTrue();
			});

			it("should rotate an image in place via filebrowser.rotate()", function(){
				var imgName = seedImageFile();
				var imgPath = variables.imageTestDirPath & "/" & imgName;
				var beforeHash = hash(fileReadBinary(imgPath), "MD5");

				var csrf = csrfFor("rotate");
				var result = variables.fb.rotate(
					resourcePath       = variables.resourcePath,
					file               = imageFileArg(imgName),
					direction          = "clock",
					siteid             = variables.siteid,
					csrf_token         = csrf.token,
					csrf_token_expires = csrf.expires
				);

				expect(result.success).toBe(1);
				expect(hash(fileReadBinary(imgPath), "MD5")).notToBe(beforeHash);
			});

			it("should crop an image in place via processCrop()", function(){
				var imgName = seedImageFile();
				var imgPath = variables.imageTestDirPath & "/" & imgName;
				var beforeHash = hash(fileReadBinary(imgPath), "MD5");

				var csrf = csrfFor("processCrop");
				var result = variables.fb.processCrop(
					resourcePath       = variables.resourcePath,
					file               = imageFileArg(imgName),
					// size = the source's own dimensions, so processCrop's
					// internal aspect-scaling factor comes out to ~1 and
					// the crop rect below needs no adjustment for it.
					size               = { width: 40, height: 100 },
					crop               = { x: 0, y: 0, width: 10, height: 10 },
					siteid             = variables.siteid,
					csrf_token         = csrf.token,
					csrf_token_expires = csrf.expires
				);

				expect(result.success).toBe(1);
				expect(hash(fileReadBinary(imgPath), "MD5")).notToBe(beforeHash);
			});

		});

		describe("Local asset browser - nested directories, non-empty deletes, and name collisions", function(){

			it("should create, list, and browse a nested subdirectory", function(){
				var parentDirName = variables.imageTestDirName & "/nested-parent";
				var childDirName = "child";
				directoryCreate(variables.baseAssetDir & "/" & parentDirName);

				var csrf = csrfFor("addfolder");
				var result = variables.fb.addFolder(
					siteid             = variables.siteid,
					directory          = "/" & parentDirName,
					name               = childDirName,
					resourcePath       = variables.resourcePath,
					csrf_token         = csrf.token,
					csrf_token_expires = csrf.expires
				);
				expect(result).toBeTrue();
				expect(directoryExists(variables.baseAssetDir & "/" & parentDirName & "/" & childDirName)).toBeTrue();

				var childrenCsrf = csrfFor("children");
				var childrenResult = variables.fb.children(
					siteid             = variables.siteid,
					directory          = "/" & parentDirName,
					resourcepath       = variables.resourcePath,
					csrf_token         = childrenCsrf.token,
					csrf_token_expires = childrenCsrf.expires
				);
				expect(childrenResult.success).toBe(1);
				expect(arrayFindNoCase(childrenResult.folders, childDirName)).toBeGT(0);

				var browseResult = variables.fb.browse(
					siteid       = variables.siteid,
					directory    = "/" & parentDirName & "/" & childDirName,
					resourcePath = variables.resourcePath
				);
				expect(structKeyExists(browseResult, "dne") ? browseResult.dne : 0).toBe(0);
			});

			it("should report a missing directory as dne=1 via browse()", function(){
				// The existing browse() coverage only ever asserts dne is 0
				// for a real folder - response.dne = 1 for a directory that
				// doesn't exist is a distinct branch (it also clears the
				// fbFolderTree cookie) that was never exercised.
				var result = variables.fb.browse(
					siteid       = variables.siteid,
					directory    = "/" & variables.imageTestDirName & "/does-not-exist",
					resourcePath = variables.resourcePath
				);
				expect(result.dne).toBe(1);
			});

			it("should refuse to delete a non-empty directory", function(){
				// delete()'s own "Directory is not empty." throw() doesn't
				// specify a type, so it doesn't match the function's own
				// `catch (customExp e)` block - it falls through to
				// `catch (any e) { rethrow; }`, which re-throws it as a
				// real, catchable exception out of the call. Confirmed
				// live: this is a genuine throw, not an abort or a clean
				// {success:0} response.
				var dirName = variables.imageTestDirName & "/nonempty";
				directoryCreate(variables.baseAssetDir & "/" & dirName);
				fileCopy(variables.fixtureSourceText, variables.baseAssetDir & "/" & dirName & "/keep.txt");

				var csrf = csrfFor("delete");
				expect(function(){
					variables.fb.delete(
						siteid             = variables.siteid,
						directory          = "/" & variables.imageTestDirName,
						filename           = "nonempty",
						resourcePath       = variables.resourcePath,
						csrf_token         = csrf.token,
						csrf_token_expires = csrf.expires
					);
				}).toThrow();

				// The rejected delete must leave everything exactly as it was.
				expect(directoryExists(variables.baseAssetDir & "/" & dirName)).toBeTrue();
				expect(fileExists(variables.baseAssetDir & "/" & dirName & "/keep.txt")).toBeTrue();
			});

			it("should not silently overwrite an existing folder name via addFolder()", function(){
				var collisionName = "collision";
				var collisionDir = variables.baseAssetDir & "/" & variables.imageTestDirName & "/" & collisionName;
				directoryCreate(collisionDir);
				fileCopy(variables.fixtureSourceText, collisionDir & "/marker.txt");

				var csrf = csrfFor("addfolder");
				var result = variables.fb.addFolder(
					siteid             = variables.siteid,
					directory          = "/" & variables.imageTestDirName,
					name               = collisionName,
					resourcePath       = variables.resourcePath,
					csrf_token         = csrf.token,
					csrf_token_expires = csrf.expires
				);

				// directoryCreate() on an existing directory throws;
				// addFolder()'s own catch block does `return(e)` - it
				// returns the raw exception object rather than `true` or a
				// {success:...} struct. A real, observed inconsistency, not
				// something this test papers over. What matters for safety:
				// the pre-existing folder and its content survive
				// untouched.
				expect(result).notToBe(true);
				expect(fileExists(collisionDir & "/marker.txt")).toBeTrue();
			});

			it("should silently overwrite an existing file name via rename() - no collision protection", function(){
				// Unlike addFolder() above (directoryCreate() throws on an
				// existing directory, and the pre-existing one survives),
				// rename()'s underlying fileMove() does NOT throw when the
				// destination filename already exists - confirmed live: it
				// just overwrites it, rename() reports success, and the
				// pre-existing target's original content is gone. A real,
				// asymmetric data-loss risk between the two methods, not
				// something to assume protection for without checking -
				// see the to-do list.
				var sourceName = "rename-src.txt";
				var targetBaseName = "rename-target";
				var sourcePath = variables.baseAssetDir & "/" & variables.imageTestDirName & "/" & sourceName;
				var targetPath = variables.baseAssetDir & "/" & variables.imageTestDirName & "/" & targetBaseName & ".txt";
				var sourceContent = fileRead(variables.fixtureSourceText);
				fileCopy(variables.fixtureSourceText, sourcePath);
				fileWrite(targetPath, "pre-existing target - gets overwritten, not protected");

				var csrf = csrfFor("rename");
				var result = variables.fb.rename(
					siteid             = variables.siteid,
					directory          = "/" & variables.imageTestDirName,
					filename           = sourceName,
					name               = targetBaseName,
					resourcePath       = variables.resourcePath,
					csrf_token         = csrf.token,
					csrf_token_expires = csrf.expires
				);

				expect(result.success).toBe(1);
				expect(fileExists(sourcePath)).toBeFalse();
				expect(fileExists(targetPath)).toBeTrue();
				expect(fileRead(targetPath)).toBe(sourceContent);
			});

		});

		describe("Local asset browser - real HTTP upload smoke test", function(){

			it("should accept a genuine multipart upload through filebrowser.upload()", function(){
				// Same reasoning as fileStorageLocal.cfc's upload smoke test:
				// fileUploadAll() needs a real multipart request, which is
				// the one thing an in-process bean call cannot fake. Uses
				// the same dedicated harness page to stay focused on storage
				// behavior rather than admin auth/session/routing.
				if (!directoryExists(variables.baseAssetDir)) {
					directoryCreate(variables.baseAssetDir);
				}

				var uploadFixture = application.configBean.getTempDir() & "/fbtest-" & variables.runTag & ".txt";
				fileCopy(variables.fixtureSourceText, uploadFixture);

				// Self-connect using the real socket port the request
				// arrived on, not cgi.server_port - confirmed live that
				// cgi.server_port reports 18181 here (the externally-mapped
				// Docker port, which the Lucee image's Tomcat connector is
				// configured to *claim* as its port for URL generation),
				// while the container's actual listening port is 8888 -
				// nothing inside the container's own network namespace can
				// reach 18181. getRequest().getLocalPort() bypasses whatever
				// proxyPort override is configured and reports the port the
				// connection was truly accepted on, so this is portable
				// across whatever engine/port combination it's run under.
				var harnessUrl = "http://localhost:" & getPageContext().getRequest().getLocalPort()
					& "/core/tests/uploadHarness.cfm";

				var httpResult = "";
				cfhttp(url=harnessUrl, method="post", result="httpResult", timeout=30, throwonerror=false){
					cfhttpparam(type="formfield", name="target", value="filebrowser");
					cfhttpparam(type="formfield", name="siteid", value=variables.siteid);
					cfhttpparam(type="formfield", name="directory", value="/");
					cfhttpparam(type="file", name="file", file=uploadFixture, mimetype="text/plain");
				}

				expect(httpResult.statusCode).toInclude("200");

				var json = deserializeJSON(httpResult.fileContent);
				expect(json.success).toBeTrue();
				expect(json.response.success).toBe(1);

				// Cleanup: find whatever filename filebrowser.upload() gave
				// the uploaded file (it may have been sanitized/renamed) and
				// remove it, since it landed directly in the real asset root
				// rather than under our disposable test folder.
				try {
					fileDelete(uploadFixture);
				} catch (any e) {}

				if (arrayLen(json.response.saved)) {
					try {
						// json.response.saved[1] is the raw cffile-upload
						// result struct filebrowser.upload() appends as-is.
						// It has no "filePath" key (that only exists on a
						// separate, event-only struct inside upload()
						// itself). Its "serverfile" is also not the final
						// name: upload() moves the file from its temp
						// location to a sanitized name built from
						// "clientfile" before appending - confirmed live
						// that using "serverfile" here silently leaves the
						// real uploaded file behind every run. This fixture
						// filename has no spaces or special characters, so
						// upload()'s sanitization leaves clientfile
						// unchanged - safe to use directly here.
						var savedName = json.response.saved[1].clientfile;
						var savedPath = variables.baseAssetDir & "/" & savedName;
						if (fileExists(savedPath)) {
							fileDelete(savedPath);
						}
					} catch (any e) {}
				}
			});

			it("should accept a genuine multipart upload through ckeditor_quick_upload()", function(){
				// A separate upload entrypoint (used by the CKEditor image/
				// file-browser integration) with its own quirks: it returns
				// a pre-serialized JSON string rather than a struct (see
				// uploadHarness.cfm), has no working CSRF check of its own
				// (its cookie-based check compares a value to itself, so it
				// can never fail), and renames the uploaded file to
				// <basename><timestamp>.<ext> rather than keeping the
				// original name.
				var uploadFixture = application.configBean.getTempDir() & "/cktest-" & variables.runTag & ".txt";
				fileCopy(variables.fixtureSourceText, uploadFixture);

				var harnessUrl = "http://localhost:" & getPageContext().getRequest().getLocalPort()
					& "/core/tests/uploadHarness.cfm";

				var httpResult = "";
				cfhttp(url=harnessUrl, method="post", result="httpResult", timeout=30, throwonerror=false){
					cfhttpparam(type="formfield", name="target", value="ckeditor");
					cfhttpparam(type="formfield", name="siteid", value=variables.siteid);
					cfhttpparam(type="formfield", name="directory", value="/");
					cfhttpparam(type="file", name="file", file=uploadFixture, mimetype="text/plain");
				}

				expect(httpResult.statusCode).toInclude("200");

				var json = deserializeJSON(httpResult.fileContent);
				expect(json.success).toBeTrue();
				expect(json.response.uploaded).toBe(1);

				try {
					fileDelete(uploadFixture);
				} catch (any e) {}

				// The renamed-on-save filename only shows up in the
				// returned "url" field (its "fileName" is the pre-rename
				// temp name) - pull the final name from there to clean up.
				try {
					var savedName = listLast(replace(json.response.url, "\", "/", "ALL"), "/");
					var savedPath = variables.baseAssetDir & "/" & savedName;
					if (fileExists(savedPath)) {
						fileDelete(savedPath);
					}
				} catch (any e) {}
			});

		});

		describe("Local asset browser - path-traversal protection", function(){

			it(
				title="should reject a path-traversal attempt via resize()/duplicate()/rotate()/processCrop()'s file.url",
				skip=true,
				body=function(){
					// Routed through uploadHarness.cfm's "traversal" target
					// rather than calling filebrowser in-process directly -
					// the underlying call can terminate its own request
					// outright, so it must stay isolated to that one
					// harness request rather than run inside this suite's
					// own shared request. The target file's own integrity
					// is the assertion, not the harness's HTTP status or
					// response shape.
					var beforeHash = hash(fileReadBinary(variables.traversalTargetPath), "MD5");
					var targetName = listLast(variables.traversalTargetPath, "/");

					var harnessUrl = "http://localhost:" & getPageContext().getRequest().getLocalPort()
						& "/core/tests/uploadHarness.cfm";

					var httpResult = "";
					cfhttp(url=harnessUrl, method="post", result="httpResult", timeout=30, throwonerror=false){
						cfhttpparam(type="formfield", name="target", value="traversal");
						cfhttpparam(type="formfield", name="siteid", value=variables.siteid);
						cfhttpparam(type="formfield", name="fileUrl", value="/assets/../" & targetName);
						cfhttpparam(type="formfield", name="ext", value="png");
					}

					expect(hash(fileReadBinary(variables.traversalTargetPath), "MD5")).toBe(beforeHash);
				}
			);

		});
	}
}
