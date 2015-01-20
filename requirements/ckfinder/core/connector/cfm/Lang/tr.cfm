<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object, for the Turkish language. Turkish translation by Abdullah M CEYLAN a.k.a. Kenan Balamir. Updated. Günce BEKTAŞ update tr.js file and translate help folder.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'İsteğinizi yerine getirmek mümkün değil. (Hata %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Geçersiz komut.';
	CKFLang.Errors[11] = 'İstekte kaynak türü belirtilmemiş.';
	CKFLang.Errors[12] = 'Talep edilen kaynak türü geçersiz.';
	CKFLang.Errors[102] = 'Geçersiz dosya ya da klasör adı.';
	CKFLang.Errors[103] = 'Kimlik doğrulama kısıtlamaları nedeni ile talebinizi yerine getiremiyoruz.';
	CKFLang.Errors[104] = 'Dosya sistemi kısıtlamaları nedeni ile talebinizi yerine getiremiyoruz.';
	CKFLang.Errors[105] = 'Geçersiz dosya uzantısı.';
	CKFLang.Errors[109] = 'Geçersiz istek.';
	CKFLang.Errors[110] = 'Bilinmeyen hata.';
	CKFLang.Errors[111] = 'Dosya boyutundan dolayı bu işlemin yapılması mümkün değil.';
	CKFLang.Errors[115] = 'Aynı isimde bir dosya ya da klasör zaten var.';
	CKFLang.Errors[116] = 'Klasör bulunamadı. Lütfen yenileyin ve tekrar deneyin.';
	CKFLang.Errors[117] = 'Dosya bulunamadı. Lütfen dosya listesini yenileyin ve tekrar deneyin.';
	CKFLang.Errors[118] = 'Kaynak ve hedef yol aynı!';
	CKFLang.Errors[201] = 'Aynı ada sahip bir dosya zaten var. Yüklenen dosyanın adı "%1" olarak değiştirildi.';
	CKFLang.Errors[202] = 'Geçersiz dosya';
	CKFLang.Errors[203] = 'Geçersiz dosya. Dosya boyutu çok büyük.';
	CKFLang.Errors[204] = 'Yüklenen dosya bozuk.';
	CKFLang.Errors[205] = 'Dosyaları yüklemek için gerekli geçici klasör sunucuda bulunamadı.';
	CKFLang.Errors[206] = 'Güvenlik nedeni ile yükleme iptal edildi. Dosya HTML benzeri veri içeriyor.';
	CKFLang.Errors[207] = 'Yüklenen dosyanın adı "%1" olarak değiştirildi.';
	CKFLang.Errors[300] = 'Dosya taşıma işlemi başarısız.';
	CKFLang.Errors[301] = 'Dosya kopyalama işlemi başarısız.';
	CKFLang.Errors[500] = 'Güvenlik nedeni ile dosya gezgini devredışı bırakıldı. Lütfen sistem yöneticiniz ile irtibata geçin ve CKFinder yapılandırma dosyasını kontrol edin.';
	CKFLang.Errors[501] = 'Önizleme desteği devredışı.';
</cfscript>
</cfsilent>
