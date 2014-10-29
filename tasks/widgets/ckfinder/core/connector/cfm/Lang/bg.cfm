<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Bulgarian language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Не е възможно да се извърши заявката. (ГРЕШКА %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Невалидна команда.';
	CKFLang.Errors[11] = 'Типът на ресурса не е определен в заявката.';
	CKFLang.Errors[12] = 'Заявеният тип на ресурса не е намерен.';
	CKFLang.Errors[102] = 'Невалиден файл или име на папка.';
	CKFLang.Errors[103] = 'Не е възможно да се извърши действието заради проблем с идентификацията.';
	CKFLang.Errors[104] = 'Не е възможно да се извърши действието заради проблем с правата.';
	CKFLang.Errors[105] = 'Невалидно файлово разширение.';
	CKFLang.Errors[109] = 'Невалидна заявка.';
	CKFLang.Errors[110] = 'Неизвестна грешка.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'Файл или папка със същото име вече съществува.';
	CKFLang.Errors[116] = 'Папката не е намерена, опреснете и опитайте отново.';
	CKFLang.Errors[117] = 'Файлът не е намерен, опреснете и опитайте отново.';
	CKFLang.Errors[118] = 'Пътищата за цел и източник трябва да са еднакви.';
	CKFLang.Errors[201] = 'Файл с такова име съществува, каченият файл е преименуван на "%1".';
	CKFLang.Errors[202] = 'Невалиден файл.';
	CKFLang.Errors[203] = 'Невалиден файл. Размерът е прекалено голям.';
	CKFLang.Errors[204] = 'Каченият файл е повреден.';
	CKFLang.Errors[205] = 'Няма временна папка за качените файлове.';
	CKFLang.Errors[206] = 'Качването е спряно заради проблеми със сигурността. Файлът съдържа HTML данни.';
	CKFLang.Errors[207] = 'Каченият файл е преименуван на "%1".';
	CKFLang.Errors[300] = 'Преместването на файловете пропадна.';
	CKFLang.Errors[301] = 'Копирането на файловете пропадна.';
	CKFLang.Errors[500] = 'Файловият браузър е изключен заради проблеми със сигурността. Моля свържете се с Вашия системен администратор и проверете конфигурацията.';
	CKFLang.Errors[501] = 'Поддръжката за миниатюри е изключена.';
</cfscript>
</cfsilent>
