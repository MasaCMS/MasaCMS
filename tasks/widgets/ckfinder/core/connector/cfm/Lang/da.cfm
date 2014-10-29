<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Danish language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Det var ikke muligt at fuldføre handlingen. (Fejl: %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Ugyldig handling.';
	CKFLang.Errors[11] = 'Ressourcetypen blev ikke angivet i anmodningen.';
	CKFLang.Errors[12] = 'Ressourcetypen er ikke gyldig.';
	CKFLang.Errors[102] = 'Ugyldig fil eller mappenavn.';
	CKFLang.Errors[103] = 'Det var ikke muligt at fuldføre handlingen på grund af en begrænsning i rettigheder.';
	CKFLang.Errors[104] = 'Det var ikke muligt at fuldføre handlingen på grund af en begrænsning i filsystem rettigheder.';
	CKFLang.Errors[105] = 'Ugyldig filtype.';
	CKFLang.Errors[109] = 'Ugyldig anmodning.';
	CKFLang.Errors[110] = 'Ukendt fejl.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'En fil eller mappe med det samme navn eksisterer allerede.';
	CKFLang.Errors[116] = 'Mappen blev ikke fundet. Opdatér listen eller prøv igen.';
	CKFLang.Errors[117] = 'Filen blev ikke fundet. Opdatér listen eller prøv igen.';
	CKFLang.Errors[118] = 'Originalplacering og destination er ens.';
	CKFLang.Errors[201] = 'En fil med det samme filnavn eksisterer allerede. Den uploadede fil er blevet omdøbt til "%1".';
	CKFLang.Errors[202] = 'Ugyldig fil.';
	CKFLang.Errors[203] = 'Ugyldig fil. Filstørrelsen er for stor.';
	CKFLang.Errors[204] = 'Den uploadede fil er korrupt.';
	CKFLang.Errors[205] = 'Der er ikke en midlertidig mappe til upload til rådighed på serveren.';
	CKFLang.Errors[206] = 'Upload annulleret af sikkerhedsmæssige årsager. Filen indeholder HTML-lignende data.';
	CKFLang.Errors[207] = 'Den uploadede fil er blevet omdøbt til "%1".';
	CKFLang.Errors[300] = 'Flytning af fil(er) fejlede.';
	CKFLang.Errors[301] = 'Kopiering af fil(er) fejlede.';
	CKFLang.Errors[500] = 'Filbrowseren er deaktiveret af sikkerhedsmæssige årsager. Kontakt systemadministratoren eller kontrollér CKFinders konfigurationsfil.';
	CKFLang.Errors[501] = 'Understøttelse af thumbnails er deaktiveret.';
</cfscript>
</cfsilent>
