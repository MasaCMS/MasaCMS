<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the English language. This is the base file for all translations.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'It was not possible to complete the request. (Error %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Invalid command.';
	CKFLang.Errors[11] = 'The resource type was not specified in the request.';
	CKFLang.Errors[12] = 'The requested resource type is not valid.';
	CKFLang.Errors[102] = 'Invalid file or folder name.';
	CKFLang.Errors[103] = 'It was not possible to complete the request due to authorization restrictions.';
	CKFLang.Errors[104] = 'It was not possible to complete the request due to file system permission restrictions.';
	CKFLang.Errors[105] = 'Invalid file extension.';
	CKFLang.Errors[109] = 'Invalid request.';
	CKFLang.Errors[110] = 'Unknown error.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'A file or folder with the same name already exists.';
	CKFLang.Errors[116] = 'Folder not found. Please refresh and try again.';
	CKFLang.Errors[117] = 'File not found. Please refresh the files list and try again.';
	CKFLang.Errors[118] = 'Source and target paths are equal.';
	CKFLang.Errors[201] = 'A file with the same name is already available. The uploaded file was renamed to "%1".';
	CKFLang.Errors[202] = 'Invalid file.';
	CKFLang.Errors[203] = 'Invalid file. The file size is too big.';
	CKFLang.Errors[204] = 'The uploaded file is corrupt.';
	CKFLang.Errors[205] = 'No temporary folder is available for upload in the server.';
	CKFLang.Errors[206] = 'Upload cancelled due to security reasons. The file contains HTML-like data.';
	CKFLang.Errors[207] = 'The uploaded file was renamed to "%1".';
	CKFLang.Errors[300] = 'Moving file(s) failed.';
	CKFLang.Errors[301] = 'Copying file(s) failed.';
	CKFLang.Errors[500] = 'The file browser is disabled for security reasons. Please contact your system administrator and check the CKFinder configuration file.';
	CKFLang.Errors[501] = 'The thumbnails support is disabled.';
</cfscript>
</cfsilent>
