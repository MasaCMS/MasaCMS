<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Latvian language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Nebija iespējams pabeigt pieprasījumu. (Kļūda %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Nederīga komanda.';
	CKFLang.Errors[11] = 'Resursa veids netika norādīts pieprasījumā.';
	CKFLang.Errors[12] = 'Pieprasītais resursa veids nav derīgs.';
	CKFLang.Errors[102] = 'Nederīgs faila vai mapes nosaukums.';
	CKFLang.Errors[103] = 'Nav iespējams pabeigt pieprasījumu, autorizācijas aizliegumu dēļ.';
	CKFLang.Errors[104] = 'Nav iespējams pabeigt pieprasījumu, failu sistēmas atļauju ierobežojumu dēļ.';
	CKFLang.Errors[105] = 'Neatļauts faila paplašinājums.';
	CKFLang.Errors[109] = 'Nederīgs pieprasījums.';
	CKFLang.Errors[110] = 'Nezināma kļūda.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'Fails vai mape ar šādu nosaukumu jau pastāv.';
	CKFLang.Errors[116] = 'Mape nav atrasta. Lūdzu pārlādējiet šo logu un mēģiniet vēlreiz.';
	CKFLang.Errors[117] = 'Fails nav atrasts. Lūdzu pārlādējiet failu sarakstu un mēģiniet vēlreiz.';
	CKFLang.Errors[118] = 'Source and target paths are equal.';
	CKFLang.Errors[201] = 'Fails ar šādu nosaukumu jau eksistē. Augšupielādētais fails tika pārsaukts par "%1".';
	CKFLang.Errors[202] = 'Nederīgs fails.';
	CKFLang.Errors[203] = 'Nederīgs fails. Faila izmērs pārsniedz pieļaujamo.';
	CKFLang.Errors[204] = 'Augšupielādētais fails ir bojāts.';
	CKFLang.Errors[205] = 'Neviena pagaidu mape nav pieejama priekš augšupielādēšanas uz servera.';
	CKFLang.Errors[206] = 'Augšupielāde atcelta drošības apsvērumu dēļ. Fails satur HTML veida datus.';
	CKFLang.Errors[207] = 'Augšupielādētais fails tika pārsaukts par "%1".';
	CKFLang.Errors[300] = 'Moving file(s) failed.';
	CKFLang.Errors[301] = 'Copying file(s) failed.';
	CKFLang.Errors[500] = 'Failu pārlūks ir atslēgts drošības apsvērumu dēļ. Lūdzu sazinieties ar šīs sistēmas tehnisko administratoru vai pārbaudiet CKFinder konfigurācijas failu.';
	CKFLang.Errors[501] = 'Sīkbilžu atbalsts ir atslēgts.';
</cfscript>
</cfsilent>
