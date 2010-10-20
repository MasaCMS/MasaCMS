<cfsetting enablecfoutputonly="true">
<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--
 * CKFinder
 * ========
 * http://ckfinder.com
 * Copyright (C) 2007-2010, CKSource - Frederico Knabben. All rights reserved.
 *
 * The software, this file and its contents are subject to the CKFinder
 * License. Please read the license.txt file before using, installing, copying,
 * modifying or distribute this file or part of its contents. The contents of
 * this file is part of the Source Code of CKFinder.
-->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>CKFinder - Sample - FCKeditor Integration</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="robots" content="noindex, nofollow" />
	<link href="../sample.css" rel="stylesheet" type="text/css" />
</head>
<body>
	<h1>
		CKFinder - Sample - FCKeditor Integration
	</h1>
	<hr />
	<p>
		CKFinder can be easily integrated with FCKeditor. Try it now, by clicking
		the "Image" or "Link" icons and then the "<strong>Browse Server</strong>" button.</p>
	<p>
</cfoutput>

<cfif listFirst( server.coldFusion.productVersion ) LT 6>
	<cfoutput><br><em class="error">This sample works only with a ColdFusion MX server and higher.</em></cfoutput>
	<cfabort>
</cfif>

<cfscript>
	// Calculate basepath for CKFinder. It's in the folder right above _samples
	basePath = Left( cgi.script_name, FindNoCase( '_samples', cgi.script_name ) - 1 ) ;
	//basePath = '/ckfinder/' ;

	// Calculate basepath for FCKeditor.
	basePathFCKeditor = mid( basePath, 1, Len(basePath) - Find("/", Reverse(basePath), 2) + 1) & "fckeditor/" ;
	// Uncomment to set the path to FCKeditor manually
	//basePathFCKeditor = '/fckeditor/' ;
</cfscript>

<!--- This is a check for the FCKeditor component. If not found, the paths must be checked --->
<cfif not fileexists(ExpandPath(basePathFCKeditor) & "fckeditor.cfc")>
	<cfoutput>
	<br><strong><span class="error">Error</span>: FCKeditor not found</strong>.
	This sample assumes that FCKeditor (not included with CKFinder) is installed in
	the "fckeditor" sibling folder of the CKFinder installation folder. If you have it installed in
	a different place, just edit this file, changing the wrong basePathFCKeditor
	(line 32).
	</cfoutput>
</cfif>

<cfscript>
	fckEditor = createObject( "component", "#basePathFCKeditor#fckeditor") ;
	fckEditor.instanceName	= "myEditor" ;
	fckEditor.value			= '<p>Just click the <b>Image</b> or <b>Link</b> button, and then <b>&quot;Browse Server&quot;</b>.</p>' ;
	fckEditor.basePath		= basePathFCKeditor ;

	ckfinder = createObject( "component", "#basePath#ckfinder" ) ;
	ckfinder.editorObj = fckEditor ;
	ckfinder.basePath = basePath ;
	ckfinder.SetupFCKeditor() ;

	fckEditor.Create() ; // create the editor.
</cfscript>

<cfoutput>
	</p>
</body>
</html>
</cfoutput>

<cfsetting enablecfoutputonly="false">
