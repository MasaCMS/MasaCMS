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
	<title>CKFinder - Sample - Standalone</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="robots" content="noindex, nofollow" />
	<link href="../sample.css" rel="stylesheet" type="text/css" />
	<style type="text/css">

		/* By defining CKFinderFrame, you are able to customize the CKFinder frame style */
		.CKFinderFrame
		{
			border: solid 2px ##e3e3c7;
			background-color: ##f1f1e3;
		}

	</style>
	<script type="text/javascript">

// This is a sample function which is called when a file is selected in CKFinder.
function ShowFileInfo( fileUrl, data )
{
	var msg = 'The selected URL is: ' + fileUrl + '\n\n';
	// Display additional information available in the "data" object.
	// For example, the size of a file (in KB) is available in the data["fileSize"] variable.
	if ( fileUrl != data['fileUrl'] )
		msg += 'File url: ' + data['fileUrl'] + '\n';
	msg += 'File size: ' + data['fileSize'] + 'KB\n';
	msg += 'Last modifed: ' + data['fileDate'];

	alert( msg );
}

	</script>
</head>
<body>
	<h1>
		CKFinder - Sample - Standalone
	</h1>
	<hr />
	<p>
		CKFinder may be used in standalone mode inside any page, to create a repository
		manager with easy. You may define a custom JavaScript function to be called when
		an image is selected (double-clicked).</p>
	<p style="padding-left: 30px; padding-right: 30px;">
</cfoutput>
<cfscript>
	// Calculate basepath for CKFinder. It's in the folder right above _samples
	basePath = Left( cgi.script_name, FindNoCase( '_samples', cgi.script_name ) - 1 ) ;

	ckfinder = createObject( "component", "#basePath#ckfinder" ) ;
	ckfinder.BasePath = "../../" ;
	ckfinder.SelectFunction = 'ShowFileInfo' ;
	ckfinder.Create() ;
</cfscript>
<cfoutput>
	</p>
</body>
</html>
</cfoutput>
<cfsetting enablecfoutputonly="false">
