<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Hindi language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'आपकी रिक्वेस्ट क्मप्लित नही कर सकते. (एरर %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'इन्वेलीड कमांड.';
	CKFLang.Errors[11] = 'यह रिसोर्स टाईप उपलब्ध नहीं है.';
	CKFLang.Errors[12] = 'यह रिसोर्स टाईप वेलिड नही हैं.';
	CKFLang.Errors[102] = 'फाएल या फोल्डर का नाम वेलिड नहीं है.';
	CKFLang.Errors[103] = 'ओथोरिसेसंन रिस्त्रिक्सं की वजह से, आपकी रिक्वेस्ट पूरी नही कर सकते.';
	CKFLang.Errors[104] = 'सिस्टम परमिशन रिस्त्रिक्सं की वजह से, आपकी रिक्वेस्ट पूरी नही कर सकते..';
	CKFLang.Errors[105] = 'फाएल एक्स्त्न्सं गलत है.';
	CKFLang.Errors[109] = 'इन्वेलीड रिक्वेस्ट.';
	CKFLang.Errors[110] = 'अननोन एरर.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'सेम नाम का फाएल या फोल्डर मोजूद है.';
	CKFLang.Errors[116] = 'फोल्डर नही मिला. रिफ्रेस करके वापिस प्रयत्न करे.';
	CKFLang.Errors[117] = 'फाएल नही मिला. फाएल लिस्टको रिफ्रेस करके वापिस प्रयत्न करे.';
	CKFLang.Errors[118] = 'सोर्स और टारगेट के पाथ एक जैसे है.';
	CKFLang.Errors[201] = 'वहि नाम की फाएल मोजोद है. अपलोड फाएल का नया नाम "%1".';
	CKFLang.Errors[202] = 'इन्वेलीड फाएल.';
	CKFLang.Errors[203] = 'इन्वेलीड फाएल. फाएल बहुत बड़ी है.';
	CKFLang.Errors[204] = 'अपलोडकी गयी फाएल करप्ट हो गयी है.';
	CKFLang.Errors[205] = 'फाएल अपलोड करनेके लिये, सर्वरपे टेम्पररी फोल्डर उपलब्थ नही है..';
	CKFLang.Errors[206] = 'सिक्योरिटी कारण वष, फाएल अपलोड केन्सल किया है. फाएलमें HTML-जैसे डेटा है.';
	CKFLang.Errors[207] = 'अपलोडेड फाएल का नया नाम "%1".';
	CKFLang.Errors[300] = 'फाएल मूव नहीं कर सके.';
	CKFLang.Errors[301] = 'फाएल कोपी नहीं कर सके.';
	CKFLang.Errors[500] = 'सिक्योरिटी कारण वष, फाएल ब्राउजर डिसेबल किया गया है. आपके सिस्टम एडमिनिस्ट्रेटर का सम्पर्क करे और CKFinder कोंफिग्युरेसन फाएल तपासे.';
	CKFLang.Errors[501] = 'थम्बनेल सपोर्ट डिसेबल किया है.';
</cfscript>
</cfsilent>
