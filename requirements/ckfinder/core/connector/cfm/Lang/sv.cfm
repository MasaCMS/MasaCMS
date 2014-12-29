<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Swedish language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Begäran kunde inte utföras eftersom ett fel uppstod. (Fel %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Ogiltig begäran.';
	CKFLang.Errors[11] = 'Resursens typ var inte specificerad i förfrågan.';
	CKFLang.Errors[12] = 'Den efterfrågade resurstypen är inte giltig.';
	CKFLang.Errors[102] = 'Ogiltigt fil- eller mappnamn.';
	CKFLang.Errors[103] = 'Begäran kunde inte utföras p.g.a. restriktioner av rättigheterna.';
	CKFLang.Errors[104] = 'Begäran kunde inte utföras p.g.a. restriktioner av rättigheter i filsystemet.';
	CKFLang.Errors[105] = 'Ogiltig filändelse.';
	CKFLang.Errors[109] = 'Ogiltig begäran.';
	CKFLang.Errors[110] = 'Okänt fel.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'En fil eller mapp med aktuellt namn finns redan.';
	CKFLang.Errors[116] = 'Mappen kunde inte hittas. Var god uppdatera sidan och försök igen.';
	CKFLang.Errors[117] = 'Filen kunde inte hittas. Var god uppdatera sidan och försök igen.';
	CKFLang.Errors[118] = 'Sökväg till källa och mål är identisk.';
	CKFLang.Errors[201] = 'En fil med aktuellt namn fanns redan. Den uppladdade filen har döpts om till "%1".';
	CKFLang.Errors[202] = 'Ogiltig fil.';
	CKFLang.Errors[203] = 'Ogiltig fil. Filen var för stor.';
	CKFLang.Errors[204] = 'Den uppladdade filen var korrupt.';
	CKFLang.Errors[205] = 'En tillfällig mapp för uppladdning är inte tillgänglig på servern.';
	CKFLang.Errors[206] = 'Uppladdningen stoppades av säkerhetsskäl. Filen innehåller HTML-liknande data.';
	CKFLang.Errors[207] = 'Den uppladdade filen har döpts om till "%1".';
	CKFLang.Errors[300] = 'Flytt av fil(er) misslyckades.';
	CKFLang.Errors[301] = 'Kopiering av fil(er) misslyckades.';
	CKFLang.Errors[500] = 'Filhanteraren har stoppats av säkerhetsskäl. Var god kontakta administratören för att kontrollera konfigurationsfilen för CKFinder.';
	CKFLang.Errors[501] = 'Stöd för tumnaglar har stängts av.';
</cfscript>
</cfsilent>
