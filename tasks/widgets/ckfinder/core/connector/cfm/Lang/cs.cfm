<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license


--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Nebylo možno dokončit příkaz. (Error %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Neplatný příkaz.';
	CKFLang.Errors[11] = 'Požadovaný typ prostředku nebyl specifikován v dotazu.';
	CKFLang.Errors[12] = 'Požadovaný typ prostředku není validní.';
	CKFLang.Errors[102] = 'Šatné jméno souboru, nebo složky.';
	CKFLang.Errors[103] = 'Nebylo možné dokončit příkaz kvůli autorizačním omezením.';
	CKFLang.Errors[104] = 'Nebylo možné dokončit příkaz kvůli omezeným přístupovým právům k souborům.';
	CKFLang.Errors[105] = 'Špatná přípona souboru.';
	CKFLang.Errors[109] = 'Neplatný příkaz.';
	CKFLang.Errors[110] = 'Neznámá chyba.';
	CKFLang.Errors[115] = 'Již existuje soubor nebo složka se stejným jménem.';
	CKFLang.Errors[116] = 'Složka nenalezena, prosím obnovte stránku.';
	CKFLang.Errors[117] = 'Soubor nenalezen, prosím obnovte stránku.';
	CKFLang.Errors[118] = 'Source and target paths are equal.';
	CKFLang.Errors[201] = 'Již existoval soubor se stejným jménem, nahraný soubor byl přejmenován na "%1"';
	CKFLang.Errors[202] = 'Špatný soubor';
	CKFLang.Errors[203] = 'Špatný soubor. Příliš velký.';
	CKFLang.Errors[204] = 'Nahraný soubor je poškozen.';
	CKFLang.Errors[205] = 'Na serveru není dostupná dočasná složka.';
	CKFLang.Errors[206] = 'Nahrávání zrušeno z bezpečnostních důvodů. Soubor obsahuje data podobná HTML.';
	CKFLang.Errors[207] = 'Nahraný soubor byl přejmenován na "%1"';
	CKFLang.Errors[300] = 'Moving file(s) failed.';
	CKFLang.Errors[301] = 'Copying file(s) failed.';
	CKFLang.Errors[500] = 'Nahrávání zrušeno z bezpečnostních důvodů. Zdělte to prosím administrátorovi a zkontrolujte nastavení CKFinderu.';
	CKFLang.Errors[501] = 'Podpora náhledů je vypnuta.';
</cfscript>
</cfsilent>
