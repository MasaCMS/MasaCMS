<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Serbian Translation for the Serbian language: Goran Markovic, University Computer Center of Banja Luka
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Није могуће завршити захтјев. (Грешка %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Непозната наредба.';
	CKFLang.Errors[11] = 'Није наведена врста у захтјеву.';
	CKFLang.Errors[12] = 'Затражена врста није важећа.';
	CKFLang.Errors[102] = 'Неисправан назив датотеке или фасцикле.';
	CKFLang.Errors[103] = 'Није могуће извршити захтјев због ограничења приступа.';
	CKFLang.Errors[104] = 'Није могуће извршити захтјев због ограничења поставке система.';
	CKFLang.Errors[105] = 'Недозвољена врста датотеке.';
	CKFLang.Errors[109] = 'Недозвољен захтјев.';
	CKFLang.Errors[110] = 'Непозната грешка.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'Датотека или фасцикла с истим називом већ постоји.';
	CKFLang.Errors[116] = 'Фасцикла није пронађена. Освјежите страницу и покушајте поново.';
	CKFLang.Errors[117] = 'Датотека није пронађена. Освјежите листу датотека и покушајте поново.';
	CKFLang.Errors[118] = 'Путања извора и одредишта су исте.';
	CKFLang.Errors[201] = 'Датотека с истим називом већ постоји. Отпремљена датотека је промјењена у "%1".';
	CKFLang.Errors[202] = 'Неисправна датотека.';
	CKFLang.Errors[203] = 'Неисправна датотека. Величина датотеке је превелика.';
	CKFLang.Errors[204] = 'Отпремљена датотека је неисправна.';
	CKFLang.Errors[205] = 'Не постоји привремена фасцикла за отпремање на серверe.';
	CKFLang.Errors[206] = 'Слање је поништено због сигурносних поставки. Назив датотеке садржи HTML податке.';
	CKFLang.Errors[207] = 'Отпремљена датотека је промјењена у "%1".';
	CKFLang.Errors[300] = 'Премјештање датотеке(а) није успјело.';
	CKFLang.Errors[301] = 'Копирање датотеке(а) није успјело.';
	CKFLang.Errors[500] = 'Претраживање датотека није дозвољено из сигурносних разлога. Молимо контактирајте администратора система како би провјерили поставке CKFinder конфигурационе датотеке.';
	CKFLang.Errors[501] = 'Thumbnail подршка није омогућена.';
</cfscript>
</cfsilent>
