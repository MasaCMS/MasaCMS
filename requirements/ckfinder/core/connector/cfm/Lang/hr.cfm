<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Croatian language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Nije moguće završiti zahtjev. (Greška %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Nepoznata naredba.';
	CKFLang.Errors[11] = 'Nije navedena vrsta u zahtjevu.';
	CKFLang.Errors[12] = 'Zatražena vrsta nije važeća.';
	CKFLang.Errors[102] = 'Neispravno naziv datoteke ili direktoija.';
	CKFLang.Errors[103] = 'Nije moguće izvršiti zahtjev zbog ograničenja pristupa.';
	CKFLang.Errors[104] = 'Nije moguće izvršiti zahtjev zbog ograničenja postavka sustava.';
	CKFLang.Errors[105] = 'Nedozvoljena vrsta datoteke.';
	CKFLang.Errors[109] = 'Nedozvoljen zahtjev.';
	CKFLang.Errors[110] = 'Nepoznata greška.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'Datoteka ili direktorij s istim nazivom već postoji.';
	CKFLang.Errors[116] = 'Direktorij nije pronađen. Osvježite stranicu i pokušajte ponovo.';
	CKFLang.Errors[117] = 'Datoteka nije pronađena. Osvježite listu datoteka i pokušajte ponovo.';
	CKFLang.Errors[118] = 'Putanje izvora i odredišta su jednake.';
	CKFLang.Errors[201] = 'Datoteka s istim nazivom već postoji. Poslana datoteka je promjenjena u "%1".';
	CKFLang.Errors[202] = 'Neispravna datoteka.';
	CKFLang.Errors[203] = 'Neispravna datoteka. Veličina datoteke je prevelika.';
	CKFLang.Errors[204] = 'Poslana datoteka je neispravna.';
	CKFLang.Errors[205] = 'Ne postoji privremeni direktorij za slanje na server.';
	CKFLang.Errors[206] = 'Slanje je poništeno zbog sigurnosnih postavki. Naziv datoteke sadrži HTML podatke.';
	CKFLang.Errors[207] = 'Poslana datoteka je promjenjena u "%1".';
	CKFLang.Errors[300] = 'Premještanje datoteke(a) nije uspjelo.';
	CKFLang.Errors[301] = 'Kopiranje datoteke(a) nije uspjelo.';
	CKFLang.Errors[500] = 'Pretraživanje datoteka nije dozvoljeno iz sigurnosnih razloga. Molimo kontaktirajte administratora sustava kako bi provjerili postavke CKFinder konfiguracijske datoteke.';
	CKFLang.Errors[501] = 'The thumbnails support is disabled.';
</cfscript>
</cfsilent>
