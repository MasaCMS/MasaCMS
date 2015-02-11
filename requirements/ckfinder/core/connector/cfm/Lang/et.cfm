<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Estonian language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Päringu täitmine ei olnud võimalik. (Viga %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Vigane käsk.';
	CKFLang.Errors[11] = 'Allika liik ei olnud päringus määratud.';
	CKFLang.Errors[12] = 'Päritud liik ei ole sobiv.';
	CKFLang.Errors[102] = 'Sobimatu faili või kausta nimi.';
	CKFLang.Errors[103] = 'Piiratud õiguste tõttu ei olnud võimalik päringut lõpetada.';
	CKFLang.Errors[104] = 'Failisüsteemi piiratud õiguste tõttu ei olnud võimalik päringut lõpetada.';
	CKFLang.Errors[105] = 'Sobimatu faililaiend.';
	CKFLang.Errors[109] = 'Vigane päring.';
	CKFLang.Errors[110] = 'Tundmatu viga.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'Sellenimeline fail või kaust on juba olemas.';
	CKFLang.Errors[116] = 'Kausta ei leitud. Palun värskenda lehte ja proovi uuesti.';
	CKFLang.Errors[117] = 'Faili ei leitud. Palun värskenda lehte ja proovi uuesti.';
	CKFLang.Errors[118] = 'Lähte- ja sihtasukoht on sama.';
	CKFLang.Errors[201] = 'Samanimeline fail on juba olemas. Üles laaditud faili nimeks pandi "%1".';
	CKFLang.Errors[202] = 'Vigane fail.';
	CKFLang.Errors[203] = 'Vigane fail. Fail on liiga suur.';
	CKFLang.Errors[204] = 'Üleslaaditud fail on rikutud.';
	CKFLang.Errors[205] = 'Serverisse üleslaadimiseks pole ühtegi ajutiste failide kataloogi.';
	CKFLang.Errors[206] = 'Üleslaadimine katkestati turvakaalutlustel. Fail sisaldab HTMLi sarnaseid andmeid.';
	CKFLang.Errors[207] = 'Üleslaaditud faili nimeks pandi "%1".';
	CKFLang.Errors[300] = 'Faili(de) liigutamine nurjus.';
	CKFLang.Errors[301] = 'Faili(de) kopeerimine nurjus.';
	CKFLang.Errors[500] = 'Failide sirvija on turvakaalutlustel keelatud. Palun võta ühendust oma süsteemi administraatoriga ja kontrolli CKFinderi seadistusfaili.';
	CKFLang.Errors[501] = 'Pisipiltide tugi on keelatud.';
</cfscript>
</cfsilent>
