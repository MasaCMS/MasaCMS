/**
* Guards against a cross-engine difference in file writes.
*
* Adobe ColdFusion's fileWrite(path, string) and fileAppend(path, string) append a newline
* (an ACF-only 4th argument, addNewLine, defaults to true). Lucee writes the string as given
* and has no such argument. Measured on ACF 2025 and Lucee 6.2:
*
*   fileWrite(path, string[, charset])       ACF: +newline   Lucee: exact
*   fileAppend(path, string)                 ACF: +newline   Lucee: exact
*   fileWrite(path, binary)                  exact on both
*   fileWrite(fileHandle, string)            exact on both
*   cffile / fileWriter.writeFile(), default +newline on both
*   ... with addNewLine=false                exact on both
*
* Rule: don't pass a string to fileWrite()/fileAppend() with a path. When the content must be
* exact, use fileWriter.writeFile(..., addNewLine=false) in application code, or
* fileWrite(path, charsetDecode(text, "utf-8")) in specs. Calls where a trailing newline is
* harmless, the data is binary, or the target is a file handle go in the allowlist below.
*
* The scan fails on every engine, so a violation shows up in a Lucee run instead of only on ACF.
*/
component extends="testbox.system.BaseSpec" {

	function beforeAll() {
		variables.root = replace(expandPath("/muraWRM/"), "\", "/", "all");
		variables.tmp = getTempDirectory() & "portableFileWrites_" & createUUID() & "/";
		directoryCreate(variables.tmp);

		// Reviewed calls, keyed by path from the web root. Each entry is a distinctive part of
		// the call's code (not a line number), so unrelated edits to the file don't affect it.
		variables.allowlist = {
			'core/mura/bean/beanFactory.cfc': [
				'fileWrite(filePath,arguments.code)',                       // generated CFC
				'dynamic_entities/config.xml.cfm'                           // generated config
			],
			'core/mura/formBuilder/formBuilderManager.cfc': [
				',con );'                                                   // generated CFCs
			],
			'core/mura/resourceBundle/resourceBundle.cfc': [
				'fileWrite(arguments.rbfile,rbString'                       // generated resource bundle
			],
			'core/mura/fileStorage/localStorageService.cfc': [
				'fileWrite(fp, arguments.data)'                             // binary data
			],
			'core/mura/plugin/pluginManager.cfc': [
				'fileWrite(pluginFileLocation, myResult.filecontent)'       // binary download
			],
			'core/mura/fileWriter.cfc': [
				'FileWrite(new, x'                                          // file handle
			],
			'admin/core/controllers/carch.cfc': [
				'fileWrite(tempDir & "/component.json",componentJSON)'      // JSON export
			],
			'admin/core/controllers/cform.cfc': [
				'fileWrite(tempDir & "/form.json",formJSON)'                // JSON export
			]
		};
	}

	function afterAll() {
		try {
			directoryDelete(variables.tmp, true);
		} catch (any e) {}
	}

	// True when the line calls fileWrite()/fileAppend() without converting the data to binary.
	private boolean function isUnsafeWriteLine(required string line) {
		var trimmed = trim(arguments.line);
		// The tag-comment opener is split up: Lucee starts a comment at it even inside a string.
		if (reFind("^(//|/\*|\*|<!" & "---)", trimmed)) {
			return false;
		}
		if (!reFindNoCase("\bfile(Write|Append)\s*\(", trimmed)) {
			return false;
		}
		return !findNoCase("charsetDecode(", trimmed);
	}

	function run() {

		describe("Portable file writes", function() {

			it("source contains no newline-sensitive fileWrite()/fileAppend() calls", function() {
				var self = replace(getCurrentTemplatePath(), "\", "/", "all");
				var offenders = [];
				var unused = {};
				for (var key in variables.allowlist) {
					for (var code in variables.allowlist[key]) {
						unused[key & " -> " & code] = true;
					}
				}

				for (var dir in ["core", "admin", "modules"]) {
					if (!directoryExists(variables.root & dir)) {
						continue;
					}
					var files = directoryList(variables.root & dir, true, "path", "*.cfc|*.cfm");
					for (var f in files) {
						var path = replace(f, "\", "/", "all");
						if (path == self || findNoCase("/vendor/", path) || findNoCase("/node_modules/", path)) {
							continue;
						}
						var rel = replace(path, variables.root, "");
						var allowed = structKeyExists(variables.allowlist, rel) ? variables.allowlist[rel] : [];
						var lines = listToArray(fileRead(path), chr(10), true);
						for (var i = 1; i <= arrayLen(lines); i++) {
							if (!isUnsafeWriteLine(lines[i])) {
								continue;
							}
							var isAllowed = false;
							for (var code in allowed) {
								if (find(code, lines[i])) {
									isAllowed = true;
									structDelete(unused, rel & " -> " & code);
								}
							}
							if (!isAllowed) {
								arrayAppend(offenders, rel & ":" & i & ": " & trim(lines[i]));
							}
						}
					}
				}

				expect(offenders).toBeEmpty(
					"fileWrite()/fileAppend() with a string appends a newline on Adobe ColdFusion but not on Lucee. "
					& "Use fileWriter.writeFile(..., addNewLine=false) or fileWrite(path, charsetDecode(text, 'utf-8')), "
					& "or, if a trailing newline is harmless, add the call to the allowlist in portableFileWrites.cfc. "
					& "Offending lines: " & arrayToList(offenders, " | ")
				);
				expect(structKeyArray(unused)).toBeEmpty(
					"Allowlist entries in portableFileWrites.cfc no longer match any call; remove them: "
					& arrayToList(structKeyArray(unused), " | ")
				);
			});

			it("flags string writes and accepts the approved forms", function() {
				expect(isUnsafeWriteLine("fileWrite(p, 'abc');")).toBeTrue();
				expect(isUnsafeWriteLine("	<cfset fileAppend(p, x)>")).toBeTrue();
				expect(isUnsafeWriteLine("FILEWRITE (p, x, 'utf-8');")).toBeTrue();
				expect(isUnsafeWriteLine("fileWrite(p, charsetDecode('abc', 'utf-8'));")).toBeFalse();
				expect(isUnsafeWriteLine("// fileWrite() appends a newline on ACF")).toBeFalse();
				expect(isUnsafeWriteLine("masaFileWriteHelper(p, x);")).toBeFalse();
			});

			it("approved write forms store content exactly on every engine", function() {
				var p = variables.tmp & "exact.txt";

				fileWrite(p, charsetDecode("abc", "utf-8"));
				expect(fileRead(p)).toBe("abc");

				application.serviceFactory.getBean("fileWriter").writeFile(file=p, output="abc", addNewLine=false);
				expect(fileRead(p)).toBe("abc");
			});

		});

	}

}
