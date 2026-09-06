/**
* Regression suite for LOCAL filesystem storage of File-type content
* (the "attach a file to a content item" path: fileBean -> fileManager ->
* fileDAO -> fileWriter -> localStorageService).
*
* Deliberately written against the stable public surface of fileBean.cfc /
* fileManager.cfc / fileDAO.cfc rather than any internal storage
* implementation detail, so it keeps working regardless of which storage
* backend is registered underneath (local disk, or any custom
* IUserAssetStorageService implementation swapped in via the
* fileStorageService bean alias).
*
* Out of scope on purpose:
*   - Any cloud/S3/GCS backend. That ships (and gets tested) as its own
*     module, not as part of MasaCMS core's suite.
*   - ensureCachedImageSize()'s custom-size cache regeneration - it's a
*     distinct capability that belongs in its own focused test rather than
*     this general lifecycle pass.
*   - fileWriter.cfc's standalone wrapper methods (readFile, deleteFile,
*     checkFileExists, checkDirectoryExists, resolveToLocal, writeFromLocal,
*     getAssetUrl) - fileWriter is exercised here only indirectly, as the
*     thing fileManager/fileDAO already route through.
*   - fileManager.readSmall()/readMedium(): their SQL queries a legacy
*     `imageSmall`/`imageMedium` blob column on `tfiles` that is only ever
*     populated in the old "database" storage mode (see
*     core/setup/db/*.sql.cfm) - in "fileDir" mode (what this suite
*     exercises) those columns are always NULL, so both methods always
*     return 0 rows regardless of whether cached variants actually exist
*     on disk. This suite checks cached-variant existence on disk instead,
*     which is what "fileDir" mode actually uses.
*/
component extends="testbox.system.BaseSpec" {

	function beforeAll(){
		session.siteid = "default";
		variables.siteid = "default";

		variables.$ = application.serviceFactory.getBean('$').init(variables.siteid);
		variables.fileManager = application.serviceFactory.getBean('fileManager');

		// Mura's canonical root/home content id - same fixture value already
		// used by core/tests/specs/mura/core/content.cfc, so it's known-good
		// and known to already exist on the "default" site.
		variables.parentID = "00000000000000000000000000000000001";

		// Unique per run so a crashed prior run's leftovers can never make
		// this run silently pass or fail for the wrong reason. Resetting
		// site content between runs is out of scope here (handled
		// separately) - this is the safety net in its place.
		variables.runTag = lCase(replace(createUUID(), "-", "", "all"));

		// A small, self-contained fixture owned by the test suite itself
		// (core/tests/resources/fileStorage/fixture.png) rather than a
		// borrowed application asset - keeps this suite from depending on
		// a file that exists for unrelated reasons and could move or
		// change independently of these tests. It's a 40x100 four-quadrant
		// checkerboard (white/dark-gray), not a flat single color, so a
		// horizontal or vertical flip, a 90-degree rotation, or a crop
		// into any one quadrant all produce genuinely different pixel
		// data - a flat swatch would make some of those a byte-identical
		// no-op.
		variables.fixtureSourceImage = expandPath('/core/tests/resources/fileStorage/fixture.png');
		variables.fixtureImage = application.configBean.getTempDir() & "/fstest-" & variables.runTag & ".png";
		fileCopy(variables.fixtureSourceImage, variables.fixtureImage);

		// Same reasoning for the non-image fixtures below: pre-generated,
		// checked-in files under the test suite's own resources, copied to
		// a uniquely-named temp path per test rather than built with
		// fileWrite() at run time. Their content is fixed and arbitrary -
		// these tests only care that a file of the right extension exists.
		variables.fixtureSourceText = expandPath('/core/tests/resources/fileStorage/fixture.txt');
		variables.fixtureSourceFlv = expandPath('/core/tests/resources/fileStorage/fixture.flv');
		variables.fixtureHash = hash(fileReadBinary(variables.fixtureSourceImage), "MD5");

		// fileBean.save(processFile=true) - i.e. exactly what a real upload
		// form submits to - refuses a plain local filesystem path via its
		// own getAllowLocalFiles() config gate (default false; confirmed
		// live: it silently no-ops, leaving fileID/contentid empty, rather
		// than throwing). Toggling configBean.setValue("allowLocalFiles",
		// true) at runtime did NOT change what fileBean.save() observed
		// (confirmed live), so that gate isn't reachable from here. Seeding
		// instead drives fileManager's own emulateUpload()+Process()+
		// create() chain directly - exactly what fileDAO.create() does
		// internally - which is real, already-shipped, non-HTTP behavior,
		// not a test-only shortcut.
		variables.fileID = "";
		variables.contentID = "";

		// Belt-and-braces cleanup registries for the per-extension tests
		// below: an assertion failure aborts the rest of that it() block,
		// so anything created has to be registered here *before* the
		// assertions that could throw, or afterAll() below is the only
		// thing left to clean it up.
		variables.extraContentIDs = [];
		variables.extraTempFiles = [];
	}

	function afterAll(){
		// Belt-and-braces cleanup even if an assertion failed partway
		// through the suite and left the content record in place.
		// deleteAll() only soft-deletes (tfiles.deleted=1) - purgeDeleted()
		// is the step that actually removes the row and its cache files.
		try {
			if (len(variables.contentID)) {
				variables.fileManager.deleteAll(contentID=variables.contentID);
			}
			for (var cid in variables.extraContentIDs) {
				variables.fileManager.deleteAll(contentID=cid);
			}
			variables.fileManager.purgeDeleted(siteid=variables.siteid);
		} catch (any e) {}

		try {
			if (fileExists(variables.fixtureImage)) {
				fileDelete(variables.fixtureImage);
			}
		} catch (any e) {}

		for (var tempFile in variables.extraTempFiles) {
			try {
				if (fileExists(tempFile)) {
					fileDelete(tempFile);
				}
			} catch (any e) {}
		}
	}

	// "fileDir" storage mode's cache-file naming convention, matching what
	// fileDAO.create()'s fileDir cfcase writes.
	function cacheFilePath(fileID, suffix, ext){
		return application.configBean.getFileDir() & "/" & variables.siteid & "/cache/file/"
			& arguments.fileID & arguments.suffix & "." & arguments.ext;
	}

	// Creates a fresh, independent File content item (its own contentid and
	// fileid, fully linked and cached) for tests that need a real fixture
	// but shouldn't depend on - or interfere with - variables.fileID's own
	// lifecycle (which the main "File content lifecycle" describe block
	// ends by soft- then hard-deleting). Registers the content record in
	// extraContentIDs for afterAll() cleanup.
	function createTestFile(titleSuffix){
		var uploaded = variables.fileManager.emulateUpload(filePath=variables.fixtureImage);
		var processed = variables.fileManager.Process(file=uploaded, siteID=variables.siteid);

		var owner = variables.$.getBean('content');
		owner.setValue('siteid', variables.siteid);
		owner.setValue('parentid', variables.parentID);
		owner.setValue('title', arguments.titleSuffix & " " & variables.runTag);
		owner.setValue('type', 'File');
		owner.save();
		var newContentID = owner.getValue('contentid');
		arrayAppend(variables.extraContentIDs, newContentID);

		var newFileID = variables.fileManager.create(
			fileObj        = processed.fileObj,
			contentid      = newContentID,
			siteid         = variables.siteid,
			filename       = uploaded.clientFile,
			contentType    = uploaded.contentType,
			contentSubType = uploaded.contentSubType,
			fileSize       = uploaded.fileSize,
			moduleID       = "00000000000000000000000000000000000",
			fileExt        = uploaded.serverFileExt,
			fileObjSmall   = processed.fileObjSmall,
			fileObjMedium  = processed.fileObjMedium,
			fileObjSource  = processed.fileObjSource
		);

		owner.setValue('fileid', newFileID);
		owner.save();

		return { contentID: newContentID, fileID: newFileID, owner: owner };
	}

	function run(){

		describe("Local file storage - File content lifecycle", function(){

			it("should create a File content item from a local-path emulated upload", function(){
				var uploaded = variables.fileManager.emulateUpload(filePath=variables.fixtureImage);
				var processed = variables.fileManager.Process(file=uploaded, siteID=variables.siteid);

				// Create the owning content record first, exactly like the
				// existing content.cfc spec does for its own fixture, then
				// link it back to the file record afterwards (tcontent.
				// fileid). fileManager.deleteAll() relies on that back-
				// reference to find "is this file still referenced by any
				// content item" before removing it - confirmed live that
				// without it, deleteAll() silently no-ops (it can never
				// find the file via tcontent, so nothing looks unused).
				var contentBean = variables.$.getBean('content');
				contentBean.setValue('siteid', variables.siteid);
				contentBean.setValue('parentid', variables.parentID);
				contentBean.setValue('title', 'File storage test ' & variables.runTag);
				contentBean.setValue('type', 'File');
				contentBean.save();
				variables.contentID = contentBean.getValue('contentid');

				variables.fileID = variables.fileManager.create(
					fileObj        = processed.fileObj,
					contentid      = variables.contentID,
					siteid         = variables.siteid,
					filename       = uploaded.clientFile,
					contentType    = uploaded.contentType,
					contentSubType = uploaded.contentSubType,
					fileSize       = uploaded.fileSize,
					moduleID       = "00000000000000000000000000000000000",
					fileExt        = uploaded.serverFileExt,
					fileObjSmall   = processed.fileObjSmall,
					fileObjMedium  = processed.fileObjMedium,
					fileObjSource  = processed.fileObjSource
				);

				contentBean.setValue('fileid', variables.fileID);
				contentBean.save();

				expect(len(variables.fileID)).toBeGT(0);
				expect(len(variables.contentID)).toBeGT(0);
			});

			it("should be readable back via fileManager.read() with matching metadata", function(){
				var rs = variables.fileManager.read(variables.fileID);

				expect(rs.recordCount).toBe(1);
				expect(rs.contentType).toBe("image");
				expect(rs.contentSubType).toBe("png");
			});

			it("should have small and medium cached variants on disk", function(){
				expect(fileExists(cacheFilePath(variables.fileID, "_small", "png"))).toBeTrue();
				expect(fileExists(cacheFilePath(variables.fileID, "_medium", "png"))).toBeTrue();
			});

			it("should resolve to a public render URL for this file", function(){
				// fileBean.getURL() exists but returned a struct rather
				// than the documented string on this call - building the
				// same "render" URL its own source uses sidesteps that
				// rather than depending on it.
				//
				// Named "renderUrl", not "url" - `url` is Lucee's built-in
				// querystring scope (a real struct here, since runner.cfm is
				// invoked with ?reporter=json), and confirmed live that
				// `var url = "..."` does not fully shadow it inside a
				// describe()/it() closure: cfhttp(url=url, ...) picked up
				// the built-in struct instead of the local string.
				var renderUrl = "http://localhost:" & getPageContext().getRequest().getLocalPort()
					& application.configBean.getContext()
					& "/index.cfm/render/?fileid=" & variables.fileID
					& "&siteid=" & variables.siteid & "&method=inline";

				// This bare-path /index.cfm hit trips Mura's own canonical-
				// URL redirect (contentServer.cfc, gated by
				// getSiteIDInURLS()) to insert the site's path segment, e.g.
				// /index.cfm/default/render/?fileid=... - confirmed live via
				// the Location header. Following that redirect a further
				// hop turned out to need more of contentServer's own routing
				// context than a bare self-connect provides (404s on a
				// direct hit even with the path corrected), which is a
				// self-connect/routing wrinkle rather than something worth
				// chasing further here - this test settles for the redirect
				// itself as proof the file resolves to a URL at all, and
				// verifies actual byte content the same reliable way the
				// rotate test below does: reading the cache file fileManager
				// wrote directly.
				var httpResult = "";
				cfhttp(url=renderUrl, method="get", result="httpResult", timeout=15, throwonerror=false, redirect=false);

				expect(left(httpResult.statusCode, 1)).toBe("3");
				expect(httpResult.responseHeader.Location).toInclude(variables.fileID);

				var sourcePath = cacheFilePath(variables.fileID, "_source", "png");
				expect(hash(fileReadBinary(sourcePath), "MD5")).toBe(variables.fixtureHash);
			});

			it("should rotate without error and change the cached source image", function(){
				// rotate() operates on the "_source" cache file specifically
				// (confirmed by reading its implementation), not "_small" -
				// it rewrites that file in place via imageRead/ImageRotate/
				// imageWrite.
				var sourcePath = cacheFilePath(variables.fileID, "_source", "png");
				var beforeHash = hash(fileReadBinary(sourcePath), "MD5");

				variables.fileManager.rotate(fileID=variables.fileID, degrees=90);

				expect(fileExists(sourcePath)).toBeTrue();
				// A 90-degree rotation of a non-square image must produce a
				// different cached image - this is a light-touch "did the
				// operation actually do something" check, not a pixel-level
				// correctness check.
				expect(hash(fileReadBinary(sourcePath), "MD5")).notToBe(beforeHash);
			});

			it("should flip without error and change the cached source image", function(){
				// flip() does the same read/transform/rewrite-in-place on
				// the "_source" cache file that rotate() does above, just
				// via ImageFlip instead of ImageRotate. Unlike rotate(),
				// flip() doesn't change the image's dimensions, so this
				// relies on the fixture's checkerboard content (rather
				// than a flat single color) to make a horizontal flip
				// produce genuinely different pixel data.
				var sourcePath = cacheFilePath(variables.fileID, "_source", "png");
				var beforeHash = hash(fileReadBinary(sourcePath), "MD5");

				variables.fileManager.flip(fileID=variables.fileID, transpose="horizontal");

				expect(fileExists(sourcePath)).toBeTrue();
				expect(hash(fileReadBinary(sourcePath), "MD5")).notToBe(beforeHash);
			});

			it("should soft-delete on deleteAll(), restore via restoreVersion(), then hard-delete on purgeDeleted()", function(){
				// fileManager.deleteAll() -> fileDAO.deleteIfNotUsed() only
				// soft-deletes (sets tfiles.deleted=1) once nothing else
				// still references the file - confirmed live by reading its
				// SQL. read()'s query never filters on `deleted`, so the row
				// is still findable immediately after deleteAll(); this is
				// real, characterized behavior, not a test bug.
				variables.fileManager.deleteAll(contentID=variables.contentID);

				var rsAfterSoftDelete = variables.fileManager.readAll(variables.fileID);
				expect(rsAfterSoftDelete.recordCount).toBe(1);
				expect(rsAfterSoftDelete.deleted).toBe(1);

				// restoreVersion() is the inverse of the soft-delete above -
				// a plain `deleted=0` flag flip, undoing deleteAll() without
				// needing to re-create anything.
				variables.fileManager.restoreVersion(fileID=variables.fileID);

				var rsAfterRestore = variables.fileManager.readAll(variables.fileID);
				expect(rsAfterRestore.recordCount).toBe(1);
				expect(rsAfterRestore.deleted).toBe(0);

				// Soft-delete it again so the rest of this test (hard-delete
				// via purgeDeleted()) still applies.
				variables.fileManager.deleteAll(contentID=variables.contentID);

				// purgeDeleted() is the separate, explicit step that actually
				// removes soft-deleted rows (and their cached files) - note
				// it purges every deleted=1 row for the whole site, not just
				// this fixture, which is fine in an isolated test run but
				// worth knowing if this site has other genuinely-deleted
				// content sitting in the trash.
				variables.fileManager.purgeDeleted(siteid=variables.siteid);

				var rsAfterPurge = variables.fileManager.read(variables.fileID);
				expect(rsAfterPurge.recordCount).toBe(0);

				// Already cleaned up - afterAll should not try again.
				variables.contentID = "";
			});

			it("should mark a file deleted via deleteVersion() directly, independent of any reference check", function(){
				// deleteAll() only ever exercises deleteVersion() indirectly,
				// gated behind fileDAO.deleteIfNotUsed()'s "is this file
				// still referenced" check (see the shared-reference test
				// below). Calling fileManager.deleteVersion() directly
				// confirms its own behavior in isolation: an unconditional
				// `deleted=1` flag flip, with no reference check at all.
				// Uses its own independent fixture (via createTestFile()),
				// not variables.fileID, since this soft-delete is permanent
				// for the rest of the suite.
				var testFile = createTestFile("deleteVersion test");

				variables.fileManager.deleteVersion(fileID=testFile.fileID);

				var rs = variables.fileManager.readAll(testFile.fileID);
				expect(rs.recordCount).toBe(1);
				expect(rs.deleted).toBe(1);
			});

			it("should keep a file's row and cache intact when only one of two referencing content records is deleted", function(){
				// fileDAO.deleteIfNotUsed() - deleteAll()'s own cleanup step
				// - only soft-deletes a file once NO other tcontent record
				// still references it. This suite's other delete tests all
				// use a file referenced by exactly one content record, so
				// they never actually exercise that "still referenced
				// elsewhere" branch - only ever the "safe to delete" one.
				// This attaches the same fileid to two independent content
				// records (its own fixture, via createTestFile(), not
				// variables.fileID) and confirms deleting one alone leaves
				// the file alone.
				var testFile = createTestFile("Shared file owner A");

				// A second, independent content record pointing at the same
				// fileid - the "still referenced elsewhere" case.
				var ownerB = variables.$.getBean('content');
				ownerB.setValue('siteid', variables.siteid);
				ownerB.setValue('parentid', variables.parentID);
				ownerB.setValue('title', 'Shared file owner B ' & variables.runTag);
				ownerB.setValue('type', 'File');
				ownerB.setValue('fileid', testFile.fileID);
				ownerB.save();
				var contentIdB = ownerB.getValue('contentid');
				arrayAppend(variables.extraContentIDs, contentIdB);

				var smallPath = cacheFilePath(testFile.fileID, "_small", "png");

				// Deleting owner A alone must not touch the shared file:
				// owner B's tcontent row still references it.
				variables.fileManager.deleteAll(contentID=testFile.contentID);

				var rsAfterFirstDelete = variables.fileManager.readAll(testFile.fileID);
				expect(rsAfterFirstDelete.recordCount).toBe(1);
				expect(rsAfterFirstDelete.deleted).toBe(0);
				expect(fileExists(smallPath)).toBeTrue();

				// Deliberately not going further to "delete owner B too and
				// confirm the file finally soft-deletes": confirmed live
				// that fileManager.deleteAll(contentID) never removes the
				// tcontent row itself (that's contentBean.delete(), a
				// separate flow through contentManager.deleteAll(), not
				// this one) - so owner A's tcontent row is still sitting
				// there regardless of its now-irrelevant tfiles.deleted
				// flag, and deleteIfNotUsed() (which checks tcontent rows,
				// not tfiles.deleted) would still see it as "referenced" no
				// matter what's called on owner B. Reproducing the real
				// "both owners actually gone" case needs the full content-
				// deletion flow, not fileManager.deleteAll() alone - out of
				// scope for this test, which is about the file-level guard,
				// not content deletion.
				//
				// Cleanup: since deleteAll() can't converge here (both
				// owners' tcontent rows are still present, each keeping the
				// other's deleteAll() call from ever seeing the file as
				// unreferenced), soft-delete it directly via deleteVersion()
				// - already proven elsewhere to bypass the reference check
				// entirely - so afterAll()'s purgeDeleted() can still remove
				// it for real.
				variables.fileManager.deleteVersion(fileID=testFile.fileID);
			});

		});

		describe("Local file storage - cache-maintenance utilities", function(){

			it("should remove an orphaned cache file via cleanFileCache() without touching a real one", function(){
				// cleanFileCache() deletes any file directly under .../cache/
				// file/ whose leading 35 characters don't match a real
				// tfiles.fileID for that site - i.e. cleans up cache files
				// left behind with no owning DB row. skipCleanFileCache
				// defaults to false, so this isn't a no-op by default. Uses
				// its own fixture (via createTestFile()) rather than
				// variables.fileID, which the very first describe block
				// already hard-deleted (and its cache files with it) by the
				// time this one runs.
				var testFile = createTestFile("cleanFileCache test");
				var realSmallPath = cacheFilePath(testFile.fileID, "_small", "png");
				expect(fileExists(realSmallPath)).toBeTrue();

				var orphanFileID = createUUID();
				var orphanPath = cacheFilePath(orphanFileID, "", "png");
				fileCopy(variables.fixtureSourceImage, orphanPath);

				variables.fileManager.cleanFileCache(siteID=variables.siteid);

				expect(fileExists(orphanPath)).toBeFalse();
				// The real fixture's own cache file, backed by a live
				// tfiles row, must survive the same cleanup pass.
				expect(fileExists(realSmallPath)).toBeTrue();
			});

			it("should remove an old custom-size cache file via deleteCustomImageCache() without touching the small/medium cache", function(){
				// deleteCustomImageCache() targets a specific legacy naming
				// convention - a "_H" marker with a numeric segment right
				// after the first underscore - and an age threshold. A
				// threshold of 0 days makes "just written" already count as
				// old enough, so this doesn't need to fake file timestamps.
				var testFile = createTestFile("deleteCustomImageCache test");
				var realSmallPath = cacheFilePath(testFile.fileID, "_small", "png");
				expect(fileExists(realSmallPath)).toBeTrue();

				var customSizeName = testFile.fileID & "_100_H.png";
				var customSizePath = application.configBean.getFileDir() & "/" & variables.siteid & "/cache/file/" & customSizeName;
				fileCopy(variables.fixtureSourceImage, customSizePath);

				variables.fileManager.deleteCustomImageCache(siteID=variables.siteid, threshold=0);

				expect(fileExists(customSizePath)).toBeFalse();
				expect(fileExists(realSmallPath)).toBeTrue();
			});

			it("should regenerate missing small/medium cache files via rebuildImageCache()", function(){
				var testFile = createTestFile("rebuildImageCache test");
				var smallPath = cacheFilePath(testFile.fileID, "_small", "png");
				var mediumPath = cacheFilePath(testFile.fileID, "_medium", "png");
				fileDelete(smallPath);
				fileDelete(mediumPath);
				expect(fileExists(smallPath)).toBeFalse();
				expect(fileExists(mediumPath)).toBeFalse();

				variables.fileManager.rebuildImageCache(siteID=variables.siteid);

				expect(fileExists(smallPath)).toBeTrue();
				expect(fileExists(mediumPath)).toBeTrue();
			});

		});

		describe("Local file storage - fileDAO.create() per-extension branches", function(){

			it("should store a plain non-image file with no small/medium/source cache variants", function(){
				// fileDAO.create()'s fileDir cfcase only writes _small/
				// _medium/_source siblings for jpg/jpeg/png/gif (image) and
				// flv extensions - every other extension only ever gets the
				// main file written. imageProcessor.Process() itself only
				// does any image manipulation for jpg/jpeg/png/gif too, so
				// a plain file's fileObjSmall/fileObjMedium/fileObjSource
				// come back empty from Process() - this exercises that
				// "neither branch applies" path end to end.
				var plainFixture = application.configBean.getTempDir() & "/fstest-plain-" & variables.runTag & ".txt";
				fileCopy(variables.fixtureSourceText, plainFixture);
				arrayAppend(variables.extraTempFiles, plainFixture);

				var uploaded = variables.fileManager.emulateUpload(filePath=plainFixture);
				var processed = variables.fileManager.Process(file=uploaded, siteID=variables.siteid);

				var contentBean = variables.$.getBean('content');
				contentBean.setValue('siteid', variables.siteid);
				contentBean.setValue('parentid', variables.parentID);
				contentBean.setValue('title', 'Plain file test ' & variables.runTag);
				contentBean.setValue('type', 'File');
				contentBean.save();
				var plainContentID = contentBean.getValue('contentid');
				arrayAppend(variables.extraContentIDs, plainContentID);

				var plainFileID = variables.fileManager.create(
					fileObj        = processed.fileObj,
					contentid      = plainContentID,
					siteid         = variables.siteid,
					filename       = uploaded.clientFile,
					contentType    = uploaded.contentType,
					contentSubType = uploaded.contentSubType,
					fileSize       = uploaded.fileSize,
					moduleID       = "00000000000000000000000000000000000",
					fileExt        = uploaded.serverFileExt,
					fileObjSmall   = processed.fileObjSmall,
					fileObjMedium  = processed.fileObjMedium,
					fileObjSource  = processed.fileObjSource
				);

				contentBean.setValue('fileid', plainFileID);
				contentBean.save();

				var rs = variables.fileManager.read(plainFileID);
				expect(rs.recordCount).toBe(1);
				expect(fileExists(cacheFilePath(plainFileID, "", uploaded.serverFileExt))).toBeTrue();
				expect(fileExists(cacheFilePath(plainFileID, "_small", uploaded.serverFileExt))).toBeFalse();
				expect(fileExists(cacheFilePath(plainFileID, "_medium", uploaded.serverFileExt))).toBeFalse();
				expect(fileExists(cacheFilePath(plainFileID, "_source", uploaded.serverFileExt))).toBeFalse();

				variables.fileManager.deleteAll(contentID=plainContentID);
			});

			it("should write a .jpg small thumbnail for a flv-extension file", function(){
				// A real .flv upload never reaches this branch with
				// anything to write: Process()'s image-manipulation step
				// only fires for jpg/jpeg/png/gif, so fileObjSmall/
				// fileObjMedium always come back empty for a real flv file
				// going through emulateUpload()+Process(). This calls
				// create() directly with a real, pre-made "poster frame"
				// image instead, to exercise the flv branch's own logic in
				// isolation - it writes whatever small image it's given as
				// "_small.jpg" regardless of the main file's own extension.
				//
				// fileObjMedium is deliberately NOT provided: this branch's
				// own medium-thumbnail line (fileDAO.cfc, the non-binary/
				// fileDir "flv" case) calls fileWriter.writeFile() with
				// moveFile()'s argument names (destination=/source=) rather
				// than writeFile()'s actual ones (file=/output=) - confirmed
				// live, it throws "[.../core/mura] is not a file" the
				// moment fileObjMedium is non-empty. A real pre-existing
				// bug, near-certainly never hit in production (nothing
				// upstream ever populates a non-empty fileObjMedium for a
				// real flv upload through this pipeline either) - worth
				// fixing, but not something to paper over by making this
				// test avoid it silently.
				var posterSmall = application.configBean.getTempDir() & "/fstest-flvsmall-" & variables.runTag & ".png";
				var mainFlv = application.configBean.getTempDir() & "/fstest-video-" & variables.runTag & ".flv";
				fileCopy(variables.fixtureSourceImage, posterSmall);
				fileCopy(variables.fixtureSourceFlv, mainFlv);
				arrayAppend(variables.extraTempFiles, posterSmall);
				arrayAppend(variables.extraTempFiles, mainFlv);

				var contentBean = variables.$.getBean('content');
				contentBean.setValue('siteid', variables.siteid);
				contentBean.setValue('parentid', variables.parentID);
				contentBean.setValue('title', 'FLV branch test ' & variables.runTag);
				contentBean.setValue('type', 'File');
				contentBean.save();
				var flvContentID = contentBean.getValue('contentid');
				arrayAppend(variables.extraContentIDs, flvContentID);

				var flvFileID = variables.fileManager.create(
					fileObj        = mainFlv,
					contentid      = flvContentID,
					siteid         = variables.siteid,
					filename       = "test-video.flv",
					contentType    = "video",
					contentSubType = "x-flv",
					fileSize       = getFileInfo(mainFlv).size,
					moduleID       = "00000000000000000000000000000000000",
					fileExt        = "flv",
					fileObjSmall   = posterSmall,
					// Required by create()'s own signature (no default) -
					// left empty on purpose so its `len(fileObjMedium) AND
					// FileExists(...)` guard evaluates false and the known-
					// broken medium-thumbnail line never executes.
					fileObjMedium  = ""
				);

				contentBean.setValue('fileid', flvFileID);
				contentBean.save();

				// create() moves fileObj/fileObjSmall into place rather than
				// copying them, so the temp paths registered above are
				// already gone at this point - no double-cleanup needed.
				expect(fileExists(cacheFilePath(flvFileID, "", "flv"))).toBeTrue();
				expect(fileExists(cacheFilePath(flvFileID, "_small", "jpg"))).toBeTrue();

				variables.fileManager.deleteAll(contentID=flvContentID);
			});

		});

		describe("Local file storage - real HTTP upload smoke test", function(){

			it("should accept a genuine multipart upload through fileManager.upload()", function(){
				// The one code path in this whole surface that literally
				// cannot be exercised without a real HTTP multipart request
				// (cffile action="upload" is parsed by the CF engine off the
				// actual request body). See uploadHarness.cfm for why this
				// goes through a small dedicated harness page rather than
				// the real admin controller, and why core/Application.cfc
				// needed its allowlist extended for it to be reachable at
				// all (that file only allows direct access to "runner.cfm"
				// under core/ by default).
				//
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
					cfhttpparam(type="formfield", name="target", value="fileManager");
					cfhttpparam(type="file", name="file", file=variables.fixtureImage, mimetype="image/png");
				}

				expect(httpResult.statusCode).toInclude("200");

				var json = deserializeJSON(httpResult.fileContent);
				expect(json.success).toBeTrue();
				expect(json.response.contentSubType).toBe("png");

				// Clean up the temp file the harness's fileManager.upload()
				// left behind - it never became a real content item, so
				// nothing else will clean it up.
				try {
					var tempUploadPath = json.response.serverDirectory & "/" & json.response.serverFile;
					if (fileExists(tempUploadPath)) {
						fileDelete(tempUploadPath);
					}
				} catch (any e) {}
			});

		});
	}
}
