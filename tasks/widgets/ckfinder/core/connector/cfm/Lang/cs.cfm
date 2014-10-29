<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Czech language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Příkaz nebylo možné dokončit. (Chyba %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Neplatný příkaz.';
	CKFLang.Errors[11] = 'Typ zdroje nebyl v požadavku určen.';
	CKFLang.Errors[12] = 'Požadovaný typ zdroje není platný.';
	CKFLang.Errors[102] = 'Špatné název souboru, nebo složky.';
	CKFLang.Errors[103] = 'Nebylo možné příkaz dokončit kvůli omezení oprávnění.';
	CKFLang.Errors[104] = 'Nebylo možné příkaz dokončit kvůli omezení oprávnění souborového systému.';
	CKFLang.Errors[105] = 'Neplatná přípona souboru.';
	CKFLang.Errors[109] = 'Neplatný požadavek.';
	CKFLang.Errors[110] = 'Neznámá chyba.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'Soubor nebo složka se stejným názvem již existuje.';
	CKFLang.Errors[116] = 'Složka nenalezena, prosím obnovte a zkuste znovu.';
	CKFLang.Errors[117] = 'Soubor nenalezen, prosím obnovte seznam souborů a zkuste znovu.';
	CKFLang.Errors[118] = 'Cesty zdroje a cíle jsou stejné.';
	CKFLang.Errors[201] = 'Soubor se stejným názvem je již dostupný, nahraný soubor byl přejmenován na "%1".';
	CKFLang.Errors[202] = 'Neplatný soubor.';
	CKFLang.Errors[203] = 'Neplatný soubor. Velikost souboru je příliš velká.';
	CKFLang.Errors[204] = 'Nahraný soubor je poškozen.';
	CKFLang.Errors[205] = 'Na serveru není dostupná dočasná složka pro nahrávání.';
	CKFLang.Errors[206] = 'Nahrávání zrušeno z bezpečnostních důvodů. Soubor obsahuje data podobná HTML.';
	CKFLang.Errors[207] = 'Nahraný soubor byl přejmenován na "%1".';
	CKFLang.Errors[300] = 'Přesunování souboru(ů) selhalo.';
	CKFLang.Errors[301] = 'Kopírování souboru(ů) selhalo.';
	CKFLang.Errors[500] = 'Průzkumník souborů je z bezpečnostních důvodů zakázán. Zdělte to prosím správci systému a zkontrolujte soubor nastavení CKFinder.';
	CKFLang.Errors[501] = 'Podpora náhledů je zakázána.';
</cfscript>
</cfsilent>
