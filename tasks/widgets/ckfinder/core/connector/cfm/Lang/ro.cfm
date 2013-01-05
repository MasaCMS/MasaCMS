<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Romanian language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Nu a fost posibilă finalizarea cererii. (Eroare %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Comandă invalidă.';
	CKFLang.Errors[11] = 'Tipul de resursă nu a fost specificat în cerere.';
	CKFLang.Errors[12] = 'Tipul de resursă cerut nu este valid.';
	CKFLang.Errors[102] = 'Nume fișier sau nume dosar invalid.';
	CKFLang.Errors[103] = 'Nu a fost posibiliă finalizarea cererii din cauza restricțiilor de autorizare.';
	CKFLang.Errors[104] = 'Nu a fost posibiliă finalizarea cererii din cauza restricțiilor de permisiune la sistemul de fișiere.';
	CKFLang.Errors[105] = 'Extensie fișier invalidă.';
	CKFLang.Errors[109] = 'Cerere invalidă.';
	CKFLang.Errors[110] = 'Eroare necunoscută.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'Există deja un fișier sau un dosar cu același nume.';
	CKFLang.Errors[116] = 'Dosar negăsit. Te rog împrospătează și încearcă din nou.';
	CKFLang.Errors[117] = 'Fișier negăsit. Te rog împrospătează lista de fișiere și încearcă din nou.';
	CKFLang.Errors[118] = 'Calea sursei și a țintei sunt egale.';
	CKFLang.Errors[201] = 'Un fișier cu același nume este deja disponibil. Fișierul încărcat a fost redenumit cu "%1".';
	CKFLang.Errors[202] = 'Fișier invalid.';
	CKFLang.Errors[203] = 'Fișier invalid. Mărimea fișierului este prea mare.';
	CKFLang.Errors[204] = 'Fișierul încărcat este corupt.';
	CKFLang.Errors[205] = 'Niciun dosar temporar nu este disponibil pentru încărcarea pe server.';
	CKFLang.Errors[206] = 'Încărcare anulată din motive de securitate. Fișierul conține date asemănătoare cu HTML.';
	CKFLang.Errors[207] = 'Fișierul încărcat a fost redenumit cu "%1".';
	CKFLang.Errors[300] = 'Mutare fișier(e) eșuată.';
	CKFLang.Errors[301] = 'Copiere fișier(e) eșuată.';
	CKFLang.Errors[500] = 'Browser-ul de fișiere este dezactivat din motive de securitate. Te rog contactează administratorul de sistem și verifică configurarea de fișiere CKFinder.';
	CKFLang.Errors[501] = 'Funcționalitatea de creat thumbnails este dezactivată.';
</cfscript>
</cfsilent>
