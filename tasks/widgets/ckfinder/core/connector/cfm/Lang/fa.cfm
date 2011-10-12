<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Persian language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'امکان تکمیل درخواست وجود ندارد. (خطا %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'دستور نامعتبر.';
	CKFLang.Errors[11] = 'نوع منبع در درخواست تعریف نشده است.';
	CKFLang.Errors[12] = 'نوع منبع درخواست شده معتبر نیست.';
	CKFLang.Errors[102] = 'نام فایل یا پوشه نامعتبر است.';
	CKFLang.Errors[103] = 'امکان اجرای درخواست تا زمانیکه محدودیت مجوز وجود دارد، مقدور نیست.';
	CKFLang.Errors[104] = 'امکان اجرای درخواست تا زمانیکه محدودیت مجوز سیستمی فایل وجود دارد،​مقدور نیست.';
	CKFLang.Errors[105] = 'پسوند فایل نامعتبر.';
	CKFLang.Errors[109] = 'درخواست نامعتبر.';
	CKFLang.Errors[110] = 'خطای ناشناخته.';
	CKFLang.Errors[115] = 'یک فایل یا پوشه با همین نام از قبل وجود دارد.';
	CKFLang.Errors[116] = 'پوشه یافت نشد. لطفا بروزرسانی کرده و مجددا تلاش کنید.';
	CKFLang.Errors[117] = 'فایل یافت نشد. لطفا فهرست فایلها را بروزرسانی کرده و مجددا تلاش کنید.';
	CKFLang.Errors[118] = 'منبع و مقصد مسیر یکی است.';
	CKFLang.Errors[201] = 'یک فایل با همان نام از قبل موجود است. فایل آپلود شده به "%1" تغییر نام یافت.';
	CKFLang.Errors[202] = 'فایل نامعتبر';
	CKFLang.Errors[203] = 'فایل نامعتبر. اندازه فایل بیش از حد بزرگ است.';
	CKFLang.Errors[204] = 'فایل آپلود شده خراب است.';
	CKFLang.Errors[205] = 'هیچ پوشه موقتی برای آپلود فایل در سرور موجود نیست.';
	CKFLang.Errors[206] = 'آپلود به دلایل امنیتی متوقف شد. فایل محتوی اطلاعات HTML است.';
	CKFLang.Errors[207] = 'فایل آپلود شده به "%1" تغییر نام یافت.';
	CKFLang.Errors[300] = 'جابجایی فایل(ها) ناموفق ماند.';
	CKFLang.Errors[301] = 'کپی کردن فایل(ها) ناموفق ماند.';
	CKFLang.Errors[500] = 'مرورگر فایل به دلایل امنیتی غیر فعال است. لطفا با مدیر سامانه تماس بگیرید تا تنظیمات این بخش را بررسی نماید.';
	CKFLang.Errors[501] = 'پشتیبانی انگشتیها غیر فعال است.';
</cfscript>
</cfsilent>
