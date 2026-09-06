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
		             | "traversal"
		siteid     = site id (default "default")
		directory  = target directory, filebrowser/ckeditor only, relative
		             to the resourcePath root (default "/")
		fileUrl    = traversal only - the "file.url" value passed to
		             filebrowser.rotate()
		file       = the multipart file field - see FILEFIELD below

	"traversal" is a second reason this harness exists beyond real
	multipart uploads: the filebrowser call it exercises can terminate its
	own request outright, so it must stay isolated here rather than run
	inside the main test suite's own request.
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

		<cfset fb3 = application.serviceFactory.getBean('filebrowser')>
		<cfset m3 = application.serviceFactory.getBean('$').init(form.siteid)>
		<cfset csrf3 = m3.generateCSRFTokens(context='rotate')>
		<cfset url.csrf_token = csrf3.token>
		<cfset url.csrf_token_expires = csrf3.expires>

		<cfset traversalResponse = fb3.rotate(
			resourcePath       = "User_Assets",
			file               = { url: form.fileUrl, ext: form.ext },
			direction          = "clock",
			siteid             = form.siteid,
			csrf_token         = csrf3.token,
			csrf_token_expires = csrf3.expires
		)>

		<cfset result.success = true>
		<cfset result.response = traversalResponse>

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
