<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Lithuanian language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Užklausos įvykdyti nepavyko. (Klaida %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Neteisinga komanda.';
	CKFLang.Errors[11] = 'Resurso rūšis nenurodyta užklausoje.';
	CKFLang.Errors[12] = 'Neteisinga resurso rūšis.';
	CKFLang.Errors[102] = 'Netinkamas failas arba segtuvo pavadinimas.';
	CKFLang.Errors[103] = 'Nepavyko įvykdyti užklausos dėl autorizavimo apribojimų.';
	CKFLang.Errors[104] = 'Nepavyko įvykdyti užklausos dėl failų sistemos leidimų apribojimų.';
	CKFLang.Errors[105] = 'Netinkamas failo plėtinys.';
	CKFLang.Errors[109] = 'Netinkama užklausa.';
	CKFLang.Errors[110] = 'Nežinoma klaida.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'Failas arba segtuvas su tuo pačiu pavadinimu jau yra.';
	CKFLang.Errors[116] = 'Segtuvas nerastas. Pabandykite atnaujinti.';
	CKFLang.Errors[117] = 'Failas nerastas. Pabandykite atnaujinti failų sąrašą.';
	CKFLang.Errors[118] = 'Šaltinio ir nurodomos vietos nuorodos yra vienodos.';
	CKFLang.Errors[201] = 'Failas su tuo pačiu pavadinimu jau tra. Įkeltas failas buvo pervadintas į "%1"';
	CKFLang.Errors[202] = 'Netinkamas failas';
	CKFLang.Errors[203] = 'Netinkamas failas. Failo apimtis yra per didelė.';
	CKFLang.Errors[204] = 'Įkeltas failas yra pažeistas.';
	CKFLang.Errors[205] = 'Nėra laikinojo segtuvo skirto failams įkelti.';
	CKFLang.Errors[206] = 'Įkėlimas bus nutrauktas dėl saugumo sumetimų. Šiame faile yra HTML duomenys.';
	CKFLang.Errors[207] = 'Įkeltas failas buvo pervadintas į "%1"';
	CKFLang.Errors[300] = 'Failų perkėlimas nepavyko.';
	CKFLang.Errors[301] = 'Failų kopijavimas nepavyko.';
	CKFLang.Errors[500] = 'Failų naršyklė yra išjungta dėl saugumo nustaymų. Prašau susisiekti su sistemų administratoriumi ir patikrinkite CKFinder konfigūracinį failą.';
	CKFLang.Errors[501] = 'Miniatiūrų palaikymas išjungtas.';
</cfscript>
</cfsilent>
