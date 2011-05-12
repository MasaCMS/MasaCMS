<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object, for the Slovak language. This is the base file for all translations.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Server nemohol dokončiť spracovanie požiadavky. (Chyba %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Neplatný príkaz.';
	CKFLang.Errors[11] = 'V požiadavke nebol špecifikovaný typ súboru.';
	CKFLang.Errors[12] = 'Nepodporovaný typ súboru.';
	CKFLang.Errors[102] = 'Neplatný názov súboru alebo adresára.';
	CKFLang.Errors[103] = 'Nebolo možné dokončiť spracovanie požiadavky kvôli nepostačujúcej úrovni oprávnení.';
	CKFLang.Errors[104] = 'Nebolo možné dokončiť spracovanie požiadavky kvôli obmedzeniam v prístupových právach ku súborom.';
	CKFLang.Errors[105] = 'Neplatná prípona súboru.';
	CKFLang.Errors[109] = 'Neplatná požiadavka.';
	CKFLang.Errors[110] = 'Neidentifikovaná chyba.';
	CKFLang.Errors[115] = 'Zadaný súbor alebo adresár už existuje.';
	CKFLang.Errors[116] = 'Adresár nebol nájdený. Aktualizujte obsah adresára (Znovunačítať) a skúste znovu.';
	CKFLang.Errors[117] = 'Súbor nebol nájdený. Aktualizujte obsah adresára (Znovunačítať) a skúste znovu.';
	CKFLang.Errors[118] = 'Source and target paths are equal.';
	CKFLang.Errors[201] = 'Súbor so zadaným názvom už existuje. Prekopírovaný súbor bol premenovaný na "%1"';
	CKFLang.Errors[202] = 'Neplatný súbor';
	CKFLang.Errors[203] = 'Neplatný súbor - súbor presahuje maximálnu povolenú veľkosť.';
	CKFLang.Errors[204] = 'Kopírovaný súbor je poškodený.';
	CKFLang.Errors[205] = 'Server nemá špecifikovaný dočasný adresár pre kopírované súbory.';
	CKFLang.Errors[206] = 'Kopírovanie prerušené kvôli nedostatočnému zabezpečeniu. Súbor obsahuje HTML data.';
	CKFLang.Errors[207] = 'Prekopírovaný súbor bol premenovaný na "%1"';
	CKFLang.Errors[300] = 'Moving file(s) failed.';
	CKFLang.Errors[301] = 'Copying file(s) failed.';
	CKFLang.Errors[500] = 'Prehliadanie súborov je zakázané kvôli bezpečnosti. Kontaktujte prosím administrátora a overte nastavenia v konfiguračnom súbore pre CKFinder.';
	CKFLang.Errors[501] = 'Momentálne nie je zapnutá podpora pre generáciu miniobrázkov.';
</cfscript>
</cfsilent>
