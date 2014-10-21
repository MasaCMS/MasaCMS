<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Persian language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'امکان تکمیل درخواست فوق وجود ندارد (خطا: %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'دستور نامعتبر.';
	CKFLang.Errors[11] = 'نوع منبع در درخواست تعریف نشده است.';
	CKFLang.Errors[12] = 'نوع منبع درخواست شده معتبر نیست.';
	CKFLang.Errors[102] = 'نام فایل یا پوشه نامعتبر است.';
	CKFLang.Errors[103] = 'امکان کامل کردن این درخواست بخاطر محدودیت اختیارات وجود ندارد.';
	CKFLang.Errors[104] = 'امکان کامل کردن این درخواست بخاطر محدودیت دسترسی وجود ندارد.';
	CKFLang.Errors[105] = 'پسوند فایل نامعتبر  است.';
	CKFLang.Errors[109] = 'درخواست نامعتبر است.';
	CKFLang.Errors[110] = 'خطای ناشناخته.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'فایل یا پوشه ای با این نام وجود دارد';
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
	CKFLang.Errors[300] = 'انتقال فایل (ها) شکست خورد.';
	CKFLang.Errors[301] = 'کپی فایل (ها) شکست خورد.';
	CKFLang.Errors[500] = 'مرورگر فایل به دلایل امنیتی غیر فعال است. لطفا با مدیر سامانه تماس بگیرید تا تنظیمات این بخش را بررسی نماید.';
	CKFLang.Errors[501] = 'پشتیبانی از تصاویر کوچک غیرفعال شده است';
</cfscript>
</cfsilent>
