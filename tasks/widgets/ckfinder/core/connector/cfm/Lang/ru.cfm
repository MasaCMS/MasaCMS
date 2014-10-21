<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Russian language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Невозможно завершить запрос. (Ошибка %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Неверная команда.';
	CKFLang.Errors[11] = 'Тип ресурса не указан в запросе.';
	CKFLang.Errors[12] = 'Неверный запрошенный тип ресурса.';
	CKFLang.Errors[102] = 'Неверное имя файла или папки.';
	CKFLang.Errors[103] = 'Невозможно завершить запрос из-за ограничений авторизации.';
	CKFLang.Errors[104] = 'Невозможно завершить запрос из-за ограничения разрешений файловой системы.';
	CKFLang.Errors[105] = 'Неверное расширение файла.';
	CKFLang.Errors[109] = 'Неверный запрос.';
	CKFLang.Errors[110] = 'Неизвестная ошибка.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'Файл или папка с таким именем уже существует.';
	CKFLang.Errors[116] = 'Папка не найдена. Пожалуйста, обновите вид папок и попробуйте еще раз.';
	CKFLang.Errors[117] = 'Файл не найден. Пожалуйста, обновите список файлов и попробуйте еще раз.';
	CKFLang.Errors[118] = 'Исходное расположение файла совпадает с указанным.';
	CKFLang.Errors[201] = 'Файл с таким именем уже существует. Загруженный файл был переименован в "%1".';
	CKFLang.Errors[202] = 'Неверный файл.';
	CKFLang.Errors[203] = 'Неверный файл. Размер файла слишком большой.';
	CKFLang.Errors[204] = 'Загруженный файл поврежден.';
	CKFLang.Errors[205] = 'Недоступна временная папка для загрузки файлов на сервер.';
	CKFLang.Errors[206] = 'Загрузка отменена из-за соображений безопасности. Файл содержит похожие на HTML данные.';
	CKFLang.Errors[207] = 'Загруженный файл был переименован в "%1".';
	CKFLang.Errors[300] = 'Произошла ошибка при перемещении файла(ов).';
	CKFLang.Errors[301] = 'Произошла ошибка при копировании файла(ов).';
	CKFLang.Errors[500] = 'Браузер файлов отключен из-за соображений безопасности. Пожалуйста, сообщите вашему системному администратру и проверьте конфигурационный файл CKFinder.';
	CKFLang.Errors[501] = 'Поддержка миниатюр отключена.';
</cfscript>
</cfsilent>
