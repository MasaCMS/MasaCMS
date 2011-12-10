/*
 * CKFinder
 * ========
 * http://ckfinder.com
 * Copyright (C) 2007-2011, CKSource - Frederico Knabben. All rights reserved.
 *
 * The software, this file, and its contents are subject to the CKFinder
 * License. Please read the license.txt file before using, installing, copying,
 * modifying, or distributing this file or part of its contents. The contents of
 * this file is part of the Source Code of CKFinder.
 *
 */

/**
 * @fileOverview Defines the {@link CKFinder.lang} object for the Norwegian
 *		Nynorsk language.
 */

/**
 * Contains the dictionary of language entries.
 * @namespace
 */
CKFinder.lang['no'] =
{
	appTitle : 'CKFinder',

	// Common messages and labels.
	common :
	{
		// Put the voice-only part of the label in the span.
		unavailable		: '%1<span class="cke_accessibility">, utilgjenglig</span>',
		confirmCancel	: 'Noen av valgene har blitt endret. Er du sikker på at du vil lukke dialogen?',
		ok				: 'OK',
		cancel			: 'Avbryt',
		confirmationTitle	: 'Confirmation', // MISSING
		messageTitle	: 'Information', // MISSING
		inputTitle		: 'Question', // MISSING
		undo			: 'Angre',
		redo			: 'Gjør om',
		skip			: 'Skip', // MISSING
		skipAll			: 'Skip all', // MISSING
		makeDecision	: 'What action should be taken?', // MISSING
		rememberDecision: 'Remember my decision' // MISSING
	},


	dir : 'ltr', // MISSING
	HelpLang : 'en',
	LangCode : 'no',

	// Date Format
	//		d    : Day
	//		dd   : Day (padding zero)
	//		m    : Month
	//		mm   : Month (padding zero)
	//		yy   : Year (two digits)
	//		yyyy : Year (four digits)
	//		h    : Hour (12 hour clock)
	//		hh   : Hour (12 hour clock, padding zero)
	//		H    : Hour (24 hour clock)
	//		HH   : Hour (24 hour clock, padding zero)
	//		M    : Minute
	//		MM   : Minute (padding zero)
	//		a    : Firt char of AM/PM
	//		aa   : AM/PM
	DateTime : 'dd/mm/yyyy HH:MM',
	DateAmPm : ['AM', 'PM'],

	// Folders
	FoldersTitle	: 'Mapper',
	FolderLoading	: 'Laster...',
	FolderNew		: 'Skriv inn det nye mappenavnet: ',
	FolderRename	: 'Skriv inn det nye mappenavnet: ',
	FolderDelete	: 'Er du sikker på at du vil slette mappen "%1"?',
	FolderRenaming	: ' (Endrer mappenavn...)',
	FolderDeleting	: ' (Sletter...)',

	// Files
	FileRename		: 'Skriv inn det nye filnavnet: ',
	FileRenameExt	: 'Er du sikker på at du vil endre filtypen? Filen kan bli ubrukelig.',
	FileRenaming	: 'Endrer filnavn...',
	FileDelete		: 'Er du sikker på at du vil slette denne filen "%1"?',
	FilesLoading	: 'Laster...',
	FilesEmpty		: 'The folder is empty.', // MISSING
	FilesMoved		: 'File %1 moved to %2:%3.', // MISSING
	FilesCopied		: 'File %1 copied to %2:%3.', // MISSING

	// Basket
	BasketFolder		: 'Basket', // MISSING
	BasketClear			: 'Clear Basket', // MISSING
	BasketRemove		: 'Remove from Basket', // MISSING
	BasketOpenFolder	: 'Open Parent Folder', // MISSING
	BasketTruncateConfirm : 'Do you really want to remove all files from the basket?', // MISSING
	BasketRemoveConfirm	: 'Do you really want to remove the file "%1" from the basket?', // MISSING
	BasketEmpty			: 'No files in the basket, drag and drop some.', // MISSING
	BasketCopyFilesHere	: 'Copy Files from Basket', // MISSING
	BasketMoveFilesHere	: 'Move Files from Basket', // MISSING

	BasketPasteErrorOther	: 'File %s error: %e', // MISSING
	BasketPasteMoveSuccess	: 'The following files were moved: %s', // MISSING
	BasketPasteCopySuccess	: 'The following files were copied: %s', // MISSING

	// Toolbar Buttons (some used elsewhere)
	Upload		: 'Last opp',
	UploadTip	: 'Last opp en ny fil',
	Refresh		: 'Oppdater',
	Settings	: 'Innstillinger',
	Help		: 'Hjelp',
	HelpTip		: 'Hjelp finnes kun på engelsk',

	// Context Menus
	Select			: 'Velg',
	SelectThumbnail : 'Velg Miniatyr',
	View			: 'Vis fullversjon',
	Download		: 'Last ned',

	NewSubFolder	: 'Ny Undermappe',
	Rename			: 'Endre navn',
	Delete			: 'Slett',

	CopyDragDrop	: 'Copy File Here', // MISSING
	MoveDragDrop	: 'Move File Here', // MISSING

	// Dialogs
	RenameDlgTitle		: 'Rename', // MISSING
	NewNameDlgTitle		: 'New Name', // MISSING
	FileExistsDlgTitle	: 'File Already Exists', // MISSING
	SysErrorDlgTitle : 'System Error', // MISSING

	FileOverwrite	: 'Overwrite', // MISSING
	FileAutorename	: 'Auto-rename', // MISSING

	// Generic
	OkBtn		: 'OK',
	CancelBtn	: 'Avbryt',
	CloseBtn	: 'Lukk',

	// Upload Panel
	UploadTitle			: 'Last opp ny fil',
	UploadSelectLbl		: 'Velg filen du vil laste opp',
	UploadProgressLbl	: '(Laster opp filen, vennligst vent...)',
	UploadBtn			: 'Last opp valgt fil',
	UploadBtnCancel		: 'Avbryt',

	UploadNoFileMsg		: 'Du må velge en fil fra din datamaskin',
	UploadNoFolder		: 'Please select a folder before uploading.', // MISSING
	UploadNoPerms		: 'File upload not allowed.', // MISSING
	UploadUnknError		: 'Error sending the file.', // MISSING
	UploadExtIncorrect	: 'File extension not allowed in this folder.', // MISSING

	// Flash Uploads
	UploadLabel			: 'Files to Upload', // MISSING
	UploadTotalFiles	: 'Total Files:', // MISSING
	UploadTotalSize		: 'Total Size:', // MISSING
	UploadAddFiles		: 'Add Files', // MISSING
	UploadClearFiles	: 'Clear Files', // MISSING
	UploadCancel		: 'Cancel Upload', // MISSING
	UploadRemove		: 'Remove', // MISSING
	UploadRemoveTip		: 'Remove !f', // MISSING
	UploadUploaded		: 'Uploaded !n%', // MISSING
	UploadProcessing	: 'Processing...', // MISSING

	// Settings Panel
	SetTitle		: 'Innstillinger',
	SetView			: 'Filvisning:',
	SetViewThumb	: 'Miniatyrbilder',
	SetViewList		: 'Liste',
	SetDisplay		: 'Vis:',
	SetDisplayName	: 'Filnavn',
	SetDisplayDate	: 'Dato',
	SetDisplaySize	: 'Filstørrelse',
	SetSort			: 'Sorter etter:',
	SetSortName		: 'Filnavn',
	SetSortDate		: 'Dato',
	SetSortSize		: 'Størrelse',

	// Status Bar
	FilesCountEmpty : '<Tom Mappe>',
	FilesCountOne	: '1 fil',
	FilesCountMany	: '%1 filer',

	// Size and Speed
	Kb				: '%1 kB',
	KbPerSecond		: '%1 kB/s',

	// Connector Error Messages.
	ErrorUnknown	: 'Det var ikke mulig å utføre forespørselen. (Feil %1)',
	Errors :
	{
	 10 : 'Ugyldig kommando.',
	 11 : 'Ressurstypen ble ikke spesifisert i forepørselen.',
	 12 : 'Ugyldig ressurstype.',
	102 : 'Ugyldig fil- eller mappenavn.',
	103 : 'Kunne ikke utføre forespørselen pga manglende autorisasjon.',
	104 : 'Kunne ikke utføre forespørselen pga manglende tilgang til filsystemet.',
	105 : 'Ugyldig filtype.',
	109 : 'Ugyldig forespørsel.',
	110 : 'Ukjent feil.',
	115 : 'Det finnes allerede en fil eller mappe med dette navnet.',
	116 : 'Kunne ikke finne mappen. Oppdater vinduet og prøv igjen.',
	117 : 'Kunne ikke finne filen. Oppdater vinduet og prøv igjen.',
	118 : 'Source and target paths are equal.', // MISSING
	201 : 'Det fantes allerede en fil med dette navnet. Den opplastede filens navn har blitt endret til "%1".',
	202 : 'Ugyldig fil.',
	203 : 'Ugyldig fil. Filen er for stor.',
	204 : 'Den opplastede filen er korrupt.',
	205 : 'Det finnes ingen midlertidig mappe for filopplastinger.',
	206 : 'Opplastingen ble avbrutt av sikkerhetshensyn. Filen inneholder HTML-aktig data.',
	207 : 'Den opplastede filens navn har blitt endret til "%1".',
	300 : 'Moving file(s) failed.', // MISSING
	301 : 'Copying file(s) failed.', // MISSING
	500 : 'Filvelgeren ikke tilgjengelig av sikkerhetshensyn. Kontakt systemansvarlig og be han sjekke CKFinder\'s konfigurasjonsfil.',
	501 : 'Funksjon for minityrbilder er skrudd av.'
	},

	// Other Error Messages.
	ErrorMsg :
	{
		FileEmpty		: 'Filnavnet kan ikke være tomt.',
		FileExists		: 'File %s already exists.', // MISSING
		FolderEmpty		: 'Mappenavnet kan ikke være tomt.',

		FileInvChar		: 'Filnavnet kan ikke inneholde følgende tegn: \n\\ / : * ? " < > |',
		FolderInvChar	: 'Mappenavnet kan ikke inneholde følgende tegn: \n\\ / : * ? " < > |',

		PopupBlockView	: 'Du må skru av popup-blockeren for å se bildet i nytt vindu.',
		XmlError		: 'It was not possible to properly load the XML response from the web server.', // MISSING
		XmlEmpty		: 'It was not possible to load the XML response from the web server. The server returned an empty response.', // MISSING
		XmlRawResponse	: 'Raw response from the server: %s' // MISSING
	},

	// Imageresize plugin
	Imageresize :
	{
		dialogTitle		: 'Resize %s', // MISSING
		sizeTooBig		: 'Cannot set image height or width to a value bigger than the original size (%size).', // MISSING
		resizeSuccess	: 'Image resized successfully.', // MISSING
		thumbnailNew	: 'Create a new thumbnail', // MISSING
		thumbnailSmall	: 'Small (%s)', // MISSING
		thumbnailMedium	: 'Medium (%s)', // MISSING
		thumbnailLarge	: 'Large (%s)', // MISSING
		newSize			: 'Set a new size', // MISSING
		width			: 'Bredde',
		height			: 'Høyde',
		invalidHeight	: 'Invalid height.', // MISSING
		invalidWidth	: 'Invalid width.', // MISSING
		invalidName		: 'Invalid file name.', // MISSING
		newImage		: 'Create a new image', // MISSING
		noExtensionChange : 'File extension cannot be changed.', // MISSING
		imageSmall		: 'Source image is too small.', // MISSING
		contextMenuName	: 'Resize', // MISSING
		lockRatio		: 'Lås forhold',
		resetSize		: 'Tilbakestill størrelse'
	},

	// Fileeditor plugin
	Fileeditor :
	{
		save			: 'Lagre',
		fileOpenError	: 'Unable to open file.', // MISSING
		fileSaveSuccess	: 'File saved successfully.', // MISSING
		contextMenuName	: 'Edit', // MISSING
		loadingFile		: 'Loading file, please wait...' // MISSING
	},

	Maximize :
	{
		maximize : 'Maksimer',
		minimize : 'Minimer'
	}
};
