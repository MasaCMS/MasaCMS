<!---
	Real-HTTP multipart upload harness for the local file storage test suite
	(core/tests/specs/mura/core/fileStorageLocal.cfc and fileBrowserLocal.cfc).

	cffile action="upload" (and Mura's fileUploadAll()) can only see a file that
	the CF engine itself parsed off a genuine multipart/form-data POST body -
	there is no way to fake that by just setting the `form` scope from CFML.
	Every other test in the suite calls beans directly in-process; this one
	page exists purely so a test can cfhttp a real file to something and get
	a real cffile-upload result back to assert on.

	Lives here (next to runner.cfm) rather than under core/tests/resources/ -
	that directory's own Application.cfc unconditionally blocks direct web
	access ("Access Restricted."), which is the right call for test fixtures
	but means anything meant to be reached over real HTTP can't live there.
	Gated behind the same `testbox` configBean flag runner.cfm itself checks,
	so this endpoint exists only where the rest of this test suite already
	does - never as a permanently-open, unauthenticated upload endpoint.

	Deliberately bypasses admin login/CSRF beyond what's needed to get past
	Mura's permission gate - what's being characterized here is the storage
	behavior behind the upload, not the admin authentication layer sitting in
	front of it in production.

	POST params:
		target     = "fileManager" (default) | "filebrowser" | "ckeditor"
		             | "traversal" | "postedFile" | "formResponse" | "streamFile"
		siteid     = site id (default "default")
		directory  = target directory, filebrowser/ckeditor only, relative
		             to the resourcePath root (default "/")
		operation  = traversal only - the filebrowser image method to call:
		             "rotate" (default) | "resize" | "duplicate" | "processCrop"
		fileUrl    = traversal only - the "file.url" value passed to it
		file       = the multipart file field - see FILEFIELD below
		             ("upload_attachment" for formResponse)
		content    = streamFile only - the file's content (text, or base64)
		binary     = streamFile only - "true" when content is base64
		ext        = streamFile only - the file's extension

	"traversal" runs one image method per request with an attacker-chosen
	file.url, so each call gets its own CSRF token and its rejection comes
	back as this page's JSON error.
--->
<cfsetting showdebugoutput="false">

<cfif not (application.mura.getBean('configBean').getValue(property='testbox', defaultValue=false) and directoryExists(expandPath("/testbox")))>
	<cfcontent type="text/plain" reset="true"><cfoutput>Access Restricted.</cfoutput><cfabort>
</cfif>

<cfparam name="form.target" default="fileManager">
<cfparam name="form.siteid" default="default">
<cfparam name="form.directory" default="/">
<cfparam name="form.fileUrl" default="">
<cfparam name="form.ext" default="png">
<cfparam name="form.operation" default="rotate">

<cfset FILEFIELD = "file">
<cfset result = { success: false }>

<cftry>

	<cfif form.target eq "filebrowser">

		<!--- checkPerms()'s first gate (getModulePerm) checks
		      session.mura.memberships for an Admin/S2 role regardless of
		      resourcePath - see fileBrowserLocal.cfc's beforeAll() for the
		      full explanation. Same fix needed here since this harness
		      calls filebrowser directly too. --->
		<cfif not structKeyExists(session, "mura")>
			<cfset session.mura = {}>
		</cfif>
		<cfif not structKeyExists(session.mura, "memberships") or not len(session.mura.memberships)>
			<cfset session.mura.memberships = "S2">
		<cfelseif not listFindNoCase(session.mura.memberships, "S2")>
			<cfset session.mura.memberships = listAppend(session.mura.memberships, "S2")>
		</cfif>

		<cfset fb = application.serviceFactory.getBean('filebrowser')>
		<cfset m = application.serviceFactory.getBean('$').init(form.siteid)>
		<cfset csrf = m.generateCSRFTokens(context='upload')>

		<!--- validateCSRFTokens() reads the token back via $.event(),
		      Mura's request-scoped event object - not the plain CFML
		      `arguments` scope of this call. mura.event.cfc seeds itself
		      from url/form scope at construction, so seeding url here
		      reaches every event object built afterwards, including
		      inside filebrowser.upload() itself. --->
		<cfset url.csrf_token = csrf.token>
		<cfset url.csrf_token_expires = csrf.expires>

		<cfset uploadResponse = fb.upload(
			siteid             = form.siteid,
			directory          = form.directory,
			formData           = "",
			resourcePath       = "User_Assets",
			fieldnames         = FILEFIELD,
			uploadfiles        = FILEFIELD,
			csrf_token         = csrf.token,
			csrf_token_expires = csrf.expires
		)>

		<cfset result.success = true>
		<cfset result.response = uploadResponse>

	<cfelseif form.target eq "ckeditor">

		<!--- Same session-membership fix as the filebrowser branch above. --->
		<cfif not structKeyExists(session, "mura")>
			<cfset session.mura = {}>
		</cfif>
		<cfif not structKeyExists(session.mura, "memberships") or not len(session.mura.memberships)>
			<cfset session.mura.memberships = "S2">
		<cfelseif not listFindNoCase(session.mura.memberships, "S2")>
			<cfset session.mura.memberships = listAppend(session.mura.memberships, "S2")>
		</cfif>

		<!--- ckeditor_quick_upload() doesn't call validateCSRFTokens() at
		      all - it has its own, separate cookie-based check
		      (cookie.ckcsrftoken compared against arguments.ckcsrftoken)
		      that is never actually enforced: the comparison in its source
		      is `cookieCSRF != cookieCSRF` (the same value compared to
		      itself), which is always false, so the "Not supported" branch
		      it guards can never fire. cookie.ckcsrftoken still has to
		      exist to avoid an undefined-key error evaluating it. --->
		<cfset cookie.ckcsrftoken = "test">

		<cfset fb2 = application.serviceFactory.getBean('filebrowser')>
		<cfset ckResponse = fb2.ckeditor_quick_upload(
			siteid       = form.siteid,
			directory    = form.directory,
			formData     = "",
			resourcePath = "User_Assets",
			fieldnames   = FILEFIELD,
			uploadfiles  = FILEFIELD,
			ckcsrftoken  = "test"
		)>

		<cfset result.success = true>
		<!--- ckeditor_quick_upload() returns a pre-serialized JSON string
		      (unlike every other filebrowser method here, which returns a
		      struct) - deserialize it before nesting it into this
		      response, or it would come back double-encoded. --->
		<cfset result.response = deserializeJSON(ckResponse)>

	<cfelseif form.target eq "traversal">

		<!--- Same session-membership fix as the filebrowser branch above -
		      resize()/duplicate()/rotate()/processCrop() share
		      filebrowser.cfc's checkPerms() gate. --->
		<cfif not structKeyExists(session, "mura")>
			<cfset session.mura = {}>
		</cfif>
		<cfif not structKeyExists(session.mura, "memberships") or not len(session.mura.memberships)>
			<cfset session.mura.memberships = "S2">
		<cfelseif not listFindNoCase(session.mura.memberships, "S2")>
			<cfset session.mura.memberships = listAppend(session.mura.memberships, "S2")>
		</cfif>

		<cfif not listFindNoCase("rotate,resize,duplicate,processCrop", form.operation)>
			<cfthrow message="Unknown traversal operation: #form.operation#">
		</cfif>

		<cfset fb3 = application.serviceFactory.getBean('filebrowser')>
		<cfset m3 = application.serviceFactory.getBean('$').init(form.siteid)>
		<cfset csrf3 = m3.generateCSRFTokens(context=form.operation)>
		<cfset url.csrf_token = csrf3.token>
		<cfset url.csrf_token_expires = csrf3.expires>

		<!--- Valid arguments for each method (same values as the in-process
		      image specs in fileBrowserLocal.cfc), so only file.url is hostile. --->
		<cfset traversalArgs = {
			resourcePath       = "User_Assets",
			file               = { url: form.fileUrl, ext: form.ext },
			siteid             = form.siteid,
			csrf_token         = csrf3.token,
			csrf_token_expires = csrf3.expires
		}>
		<cfif form.operation eq "rotate">
			<cfset traversalArgs.direction = "clock">
		<cfelseif form.operation eq "resize">
			<cfset traversalArgs.dimensions = { aspect: "within", width: 20, height: 20 }>
		<cfelseif form.operation eq "processCrop">
			<cfset traversalArgs.size = { width: 40, height: 100 }>
			<cfset traversalArgs.crop = { x: 0, y: 0, width: 10, height: 10 }>
		</cfif>

		<cfinvoke component="#fb3#" method="#form.operation#" argumentCollection="#traversalArgs#" returnVariable="traversalResponse">

		<cfset result.success = true>
		<cfset result.response = traversalResponse>

	<cfelseif form.target eq "postedFile">

		<!--- Upload detection only: what fileManager sees for the posted
		      file field, without saving the file anywhere. --->
		<cfset fmCheck = application.serviceFactory.getBean('fileManager')>
		<cfset result.success = true>
		<cfset result.response = {
			isPostedFile             = fmCheck.isPostedFile(FILEFIELD),
			isPostedFileByValue      = fmCheck.isPostedFile(form[FILEFIELD]),
			postedClientFileName     = fmCheck.getPostedClientFileName(FILEFIELD),
			requestHasRestrictedFiles = fmCheck.requestHasRestrictedFiles(scope={ "#FILEFIELD#" = form[FILEFIELD], "siteid" = form.siteid }, allowedExtensions="png")
		}>

	<cfelseif form.target eq "streamFile">

		<!--- Streams a file through fileManager.streamFile(), which ends the
		      request with cfcontent, so a spec can only check it over HTTP.
		      "content" is written to a temp file with extension "ext", as text,
		      or decoded from base64 when "binary" is true; streamFile()
		      deletes the file afterwards. --->
		<cfparam name="form.content" default="">
		<cfparam name="form.binary" default="false">
		<cfset streamPath = getTempDirectory() & "streamFile_" & createUUID() & "." & form.ext>
		<cfset fileWrite(streamPath, form.binary ? binaryDecode(form.content, "base64") : charsetDecode(form.content, "utf-8"))>
		<cfset application.serviceFactory.getBean('fileManager').streamFile(
			filePath   = streamPath,
			filename   = "streamed." & form.ext,
			mimetype   = fileGetMimeType(streamPath),
			deleteFile = true
		)>

	<cfelseif form.target eq "formResponse">

		<!--- A form response with an attachment field, as a visitor's submit
		      stores it (MASA-482). The file is posted as "upload_attachment":
		      dataCollectionManager.update() only uploads fields whose name
		      contains "attachment". The response, its file record and the
		      stored file are removed again before the result is returned. --->
		<cfset dcm = application.serviceFactory.getBean('dataCollectionManager')>
		<cfset responseData = {
			formid           = createUUID(),
			siteid           = form.siteid,
			fieldnames       = "name,upload_attachment",
			name             = "MASA-482",
			upload_attachment = form.upload_attachment
		}>
		<cfset info = dcm.update(responseData)>
		<cfset storedValue = info.upload_attachment>
		<cfset rsFile = queryExecute(
			"select filename from tfiles where fileid = :fileid",
			{ fileid = { value = storedValue, cfsqltype = "cf_sql_varchar" } }
		)>

		<cfset dcm.delete(info.responseid, true)>
		<cfif rsFile.recordCount>
			<cfset application.serviceFactory.getBean('fileDAO').deleteCachedFile(storedValue)>
			<cfset queryExecute(
				"delete from tfiles where fileid = :fileid",
				{ fileid = { value = storedValue, cfsqltype = "cf_sql_varchar" } }
			)>
		</cfif>

		<cfset result.success = true>
		<cfset result.response = {
			storedValue = storedValue,
			isFileID    = isValid("UUID", storedValue),
			fileStored  = rsFile.recordCount eq 1,
			fileName    = rsFile.recordCount ? rsFile.filename : ""
		}>

	<cfelse>

		<cfset fm = application.serviceFactory.getBean('fileManager')>
		<cfset uploadResponse = fm.upload(FILEFIELD)>

		<cfset result.success = true>
		<cfset result.response = uploadResponse>

	</cfif>

	<cfcatch type="any">
		<cfset result.success = false>
		<cfset result.error = { type: cfcatch.type, message: cfcatch.message, detail: cfcatch.detail }>
	</cfcatch>
</cftry>

<cfcontent type="application/json" reset="true"><cfoutput>#serializeJSON(result)#</cfoutput>
