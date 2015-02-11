<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Norwegian Bokmål language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Det var ikke mulig å utføre forespørselen. (Feil %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Ugyldig kommando.';
	CKFLang.Errors[11] = 'Ressurstypen ble ikke spesifisert i forepørselen.';
	CKFLang.Errors[12] = 'Ugyldig ressurstype.';
	CKFLang.Errors[102] = 'Ugyldig fil- eller mappenavn.';
	CKFLang.Errors[103] = 'Kunne ikke utføre forespørselen pga manglende autorisasjon.';
	CKFLang.Errors[104] = 'Kunne ikke utføre forespørselen pga manglende tilgang til filsystemet.';
	CKFLang.Errors[105] = 'Ugyldig filtype.';
	CKFLang.Errors[109] = 'Ugyldig forespørsel.';
	CKFLang.Errors[110] = 'Ukjent feil.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'Det finnes allerede en fil eller mappe med dette navnet.';
	CKFLang.Errors[116] = 'Kunne ikke finne mappen. Oppdater vinduet og prøv igjen.';
	CKFLang.Errors[117] = 'Kunne ikke finne filen. Oppdater vinduet og prøv igjen.';
	CKFLang.Errors[118] = 'Kilde- og mål-bane er like.';
	CKFLang.Errors[201] = 'Det fantes allerede en fil med dette navnet. Den opplastede filens navn har blitt endret til "%1".';
	CKFLang.Errors[202] = 'Ugyldig fil.';
	CKFLang.Errors[203] = 'Ugyldig fil. Filen er for stor.';
	CKFLang.Errors[204] = 'Den opplastede filen er korrupt.';
	CKFLang.Errors[205] = 'Det finnes ingen midlertidig mappe for filopplastinger.';
	CKFLang.Errors[206] = 'Opplastingen ble avbrutt av sikkerhetshensyn. Filen inneholder HTML-aktig data.';
	CKFLang.Errors[207] = 'Den opplastede filens navn har blitt endret til "%1".';
	CKFLang.Errors[300] = 'Klarte ikke å flytte fil(er).';
	CKFLang.Errors[301] = 'Klarte ikke å kopiere fil(er).';
	CKFLang.Errors[500] = 'Filvelgeren ikke tilgjengelig av sikkerhetshensyn. Kontakt systemansvarlig og be han sjekke CKFinder''s konfigurasjonsfil.';
	CKFLang.Errors[501] = 'Funksjon for minityrbilder er skrudd av.';
</cfscript>
</cfsilent>
