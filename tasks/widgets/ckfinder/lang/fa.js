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
 * @fileOverview Defines the {@link CKFinder.lang} object for the Persian
 *		language.
 */

/**
 * Contains the dictionary of language entries.
 * @namespace
 */
CKFinder.lang['fa'] =
{
	appTitle : 'CKFinder',

	// Common messages and labels.
	common :
	{
		// Put the voice-only part of the label in the span.
		unavailable		: '%1<span class="cke_accessibility">, غیر قابل دسترس</span>',
		confirmCancel	: 'برخی از گزینهها تغییر یافتهاند. آیا مطمئن هستید که قصد بستن این پنجره را دارید؟',
		ok				: 'قبول',
		cancel			: 'لغو',
		confirmationTitle	: 'تأییدیه',
		messageTitle	: 'اطلاعات',
		inputTitle		: 'پرسش',
		undo			: 'واچیدن',
		redo			: 'دوباره چیدن',
		skip			: 'عبور',
		skipAll			: 'عبور از همه',
		makeDecision	: 'چه تصمیمی خواهید گرفت؟',
		rememberDecision: 'یادآوری تصمیم من'
	},


	dir : 'rtl',
	HelpLang : 'en',
	LangCode : 'fa',

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
	DateTime : 'yyyy/mm/dd h:MM aa',
	DateAmPm : ['ق.ظ', 'ب.ظ'],

	// Folders
	FoldersTitle	: 'پوشهها',
	FolderLoading	: 'بارگیری...',
	FolderNew		: 'لطفا نام پوشه جدید را درج کنید: ',
	FolderRename	: 'لطفا نام پوشه جدید را درج کنید: ',
	FolderDelete	: 'آیا اطمینان دارید که قصد حذف کردن پوشه "%1" را دارید؟',
	FolderRenaming	: ' (در حال تغییر نام...)',
	FolderDeleting	: ' (در حال حذف...)',

	// Files
	FileRename		: 'لطفا نام جدید فایل را درج کنید: ',
	FileRenameExt	: 'آیا اطمینان دارید که قصد تغییر نام پسوند این فایل را دارید؟ ممکن است فایل غیر قابل استفاده شود',
	FileRenaming	: 'در حال تغییر نام...',
	FileDelete		: 'آیا اطمینان دارید که قصد حذف نمودن فایل "%1" را دارید؟',
	FilesLoading	: 'بارگیری...',
	FilesEmpty		: 'این پوشه خالی است',
	FilesMoved		: 'فایل %1 به مسیر %2:%3 منتقل شد.',
	FilesCopied		: 'فایل %1 در مسیر %2:%3 کپی شد.',

	// Basket
	BasketFolder		: 'سبد',
	BasketClear			: 'پاک کردن سبد',
	BasketRemove		: 'حذف از سبد',
	BasketOpenFolder	: 'باز نمودن پوشه والد',
	BasketTruncateConfirm : 'آیا واقعا قصد جابجا کردن همه فایلها از سبد را دارید؟',
	BasketRemoveConfirm	: 'آیا واقعا قصد جابجایی فایل "%1" از سبد را دارید؟',
	BasketEmpty			: 'هیچ فایلی در سبد نیست، یکی را بکشید و رها کنید.',
	BasketCopyFilesHere	: 'کپی فایلها از سبد',
	BasketMoveFilesHere	: 'جابجایی فایلها از سبد',

	BasketPasteErrorOther	: 'خطای فایل %s: %e',
	BasketPasteMoveSuccess	: 'فایلهای مقابل جابجا شدند: %s',
	BasketPasteCopySuccess	: 'این فایلها کپی شدند: %s',

	// Toolbar Buttons (some used elsewhere)
	Upload		: 'آپلود',
	UploadTip	: 'آپلود فایل جدید',
	Refresh		: 'بروزرسانی',
	Settings	: 'تنظیمات',
	Help		: 'راهنما',
	HelpTip		: 'راهنما',

	// Context Menus
	Select			: 'انتخاب',
	SelectThumbnail : 'انتخاب انگشتی',
	View			: 'نمایش',
	Download		: 'دانلود',

	NewSubFolder	: 'زیرپوشه جدید',
	Rename			: 'تغییر نام',
	Delete			: 'حذف',

	CopyDragDrop	: 'کپی فایل به اینجا',
	MoveDragDrop	: 'انتقال فایل به اینجا',

	// Dialogs
	RenameDlgTitle		: 'تغییر نام',
	NewNameDlgTitle		: 'نام جدید',
	FileExistsDlgTitle	: 'فایل از قبل وجود دارد',
	SysErrorDlgTitle : 'خطای سیستم',

	FileOverwrite	: 'رونویسی',
	FileAutorename	: 'تغییر نام خودکار',

	// Generic
	OkBtn		: 'قبول',
	CancelBtn	: 'لغو',
	CloseBtn	: 'بستن',

	// Upload Panel
	UploadTitle			: 'آپلود فایل جدید',
	UploadSelectLbl		: 'انتخاب فابل برای آپلود',
	UploadProgressLbl	: '(آپلود در حال انجام است، لطفا صبر کنید...)',
	UploadBtn			: 'آپلود فایل انتخاب شده',
	UploadBtnCancel		: 'لغو',

	UploadNoFileMsg		: 'لطفا یک فایل از رایانه خود انتخاب کنید',
	UploadNoFolder		: 'لطفا پیش از آپلود کردن یک پوشه انتخاب کنید.',
	UploadNoPerms		: 'آپلود فایل مجاز نیست.',
	UploadUnknError		: 'در حال ارسال خطای فایل.',
	UploadExtIncorrect	: 'پسوند فایل برای این پوشه مجاز نیست.',

	// Flash Uploads
	UploadLabel			: 'فایل برای آپلود',
	UploadTotalFiles	: 'مجموع فایلها:',
	UploadTotalSize		: 'مجموع حجم:',
	UploadAddFiles		: 'افزودن فایلها',
	UploadClearFiles	: 'پاک کردن فایلها',
	UploadCancel		: 'لغو آپلود',
	UploadRemove		: 'جابجا نمودن',
	UploadRemoveTip		: '!f جابجایی',
	UploadUploaded		: '!n% آپلود شد',
	UploadProcessing	: 'در حال پردازش...',

	// Settings Panel
	SetTitle		: 'تنظیمات',
	SetView			: 'نمایش:',
	SetViewThumb	: 'انگشتیها',
	SetViewList		: 'فهرست',
	SetDisplay		: 'نمایش:',
	SetDisplayName	: 'نام فایل',
	SetDisplayDate	: 'تاریخ',
	SetDisplaySize	: 'اندازه فایل',
	SetSort			: 'مرتبسازی:',
	SetSortName		: 'با نام فایل',
	SetSortDate		: 'با تاریخ',
	SetSortSize		: 'با اندازه',

	// Status Bar
	FilesCountEmpty : '<پوشه خالی>',
	FilesCountOne	: '1 فایل',
	FilesCountMany	: '%1 فایل',

	// Size and Speed
	Kb				: '%1 kB',
	KbPerSecond		: '%1 kB/s',

	// Connector Error Messages.
	ErrorUnknown	: 'امکان تکمیل درخواست وجود ندارد. (خطا %1)',
	Errors :
	{
	 10 : 'دستور نامعتبر.',
	 11 : 'نوع منبع در درخواست تعریف نشده است.',
	 12 : 'نوع منبع درخواست شده معتبر نیست.',
	102 : 'نام فایل یا پوشه نامعتبر است.',
	103 : 'امکان اجرای درخواست تا زمانیکه محدودیت مجوز وجود دارد، مقدور نیست.',
	104 : 'امکان اجرای درخواست تا زمانیکه محدودیت مجوز سیستمی فایل وجود دارد،\u200bمقدور نیست.',
	105 : 'پسوند فایل نامعتبر.',
	109 : 'درخواست نامعتبر.',
	110 : 'خطای ناشناخته.',
	115 : 'یک فایل یا پوشه با همین نام از قبل وجود دارد.',
	116 : 'پوشه یافت نشد. لطفا بروزرسانی کرده و مجددا تلاش کنید.',
	117 : 'فایل یافت نشد. لطفا فهرست فایلها را بروزرسانی کرده و مجددا تلاش کنید.',
	118 : 'منبع و مقصد مسیر یکی است.',
	201 : 'یک فایل با همان نام از قبل موجود است. فایل آپلود شده به "%1" تغییر نام یافت.',
	202 : 'فایل نامعتبر',
	203 : 'فایل نامعتبر. اندازه فایل بیش از حد بزرگ است.',
	204 : 'فایل آپلود شده خراب است.',
	205 : 'هیچ پوشه موقتی برای آپلود فایل در سرور موجود نیست.',
	206 : 'آپلود به دلایل امنیتی متوقف شد. فایل محتوی اطلاعات HTML است.',
	207 : 'فایل آپلود شده به "%1" تغییر نام یافت.',
	300 : 'جابجایی فایل(ها) ناموفق ماند.',
	301 : 'کپی کردن فایل(ها) ناموفق ماند.',
	500 : 'مرورگر فایل به دلایل امنیتی غیر فعال است. لطفا با مدیر سامانه تماس بگیرید تا تنظیمات این بخش را بررسی نماید.',
	501 : 'پشتیبانی انگشتیها غیر فعال است.'
	},

	// Other Error Messages.
	ErrorMsg :
	{
		FileEmpty		: 'نام فایل نمیتواند خالی باشد',
		FileExists		: 'فایل %s از قبل وجود دارد',
		FolderEmpty		: 'نام پوشه نمیتواند خالی باشد',

		FileInvChar		: 'نام فایل نمیتواند دارای نویسههای مقابل باشد: \n\\ / : * ? " < > |',
		FolderInvChar	: 'نام پوشه نمیتواند دارای نویسههای مقابل باشد: \n\\ / : * ? " < > |',

		PopupBlockView	: 'امکان بازگشایی فایل در پنجره جدید نیست. لطفا به بخش تنظیمات مرورگر خود مراجعه کنید و امکان بازگشایی پنجرههای بازشور را برای این سایت فعال کنید.',
		XmlError		: 'امکان بارگیری صحیح پاسخ XML از سرور مقدور نیست.',
		XmlEmpty		: 'امکان بارگیری صحیح پاسخ XML از سرور مقدور نیست. سرور پاسخ خالی بر میگرداند.',
		XmlRawResponse	: 'پاسخ اولیه از سرور: %s'
	},

	// Imageresize plugin
	Imageresize :
	{
		dialogTitle		: 'تغییر اندازه %s',
		sizeTooBig		: 'امکان تغییر مقادیر ابعاد طول و عرض تصویر به مقداری بیش از ابعاد اصلی ممکن نیست (%size).',
		resizeSuccess	: 'تصویر با موفقیت تغییر اندازه یافت.',
		thumbnailNew	: 'ایجاد انگشتی جدید',
		thumbnailSmall	: 'کوچک (%s)',
		thumbnailMedium	: 'متوسط (%s)',
		thumbnailLarge	: 'بزرگ (%s)',
		newSize			: 'تنظیم اندازه جدید',
		width			: 'پهنا',
		height			: 'ارتفاع',
		invalidHeight	: 'ارتفاع نامعتبر.',
		invalidWidth	: 'پهنا نامعتبر.',
		invalidName		: 'نام فایل نامعتبر.',
		newImage		: 'ایجاد تصویر جدید',
		noExtensionChange : 'نام پسوند فایل نمیتواند تغییر کند.',
		imageSmall		: 'تصویر اصلی خیلی کوچک است',
		contextMenuName	: 'تغییر اندازه',
		lockRatio		: 'قفل کردن تناسب.',
		resetSize		: 'بازنشانی اندازه.'
	},

	// Fileeditor plugin
	Fileeditor :
	{
		save			: 'ذخیره',
		fileOpenError	: 'قادر به گشودن فایل نیست.',
		fileSaveSuccess	: 'فایل با موفقیت ذخیره شد.',
		contextMenuName	: 'ویرایش',
		loadingFile		: 'در حال بارگیری فایل، لطفا صبر کنید...'
	},

	Maximize :
	{
		maximize : 'حداکثر نمودن',
		minimize : 'حداقل نمودن'
	}
};
