<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Slovenian language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Prišlo je do napake. (Napaka %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Napačen ukaz.';
	CKFLang.Errors[11] = 'V poizvedbi ni bil jasen tip (resource type).';
	CKFLang.Errors[12] = 'Tip datoteke ni primeren.';
	CKFLang.Errors[102] = 'Napačno ime mape ali datoteke.';
	CKFLang.Errors[103] = 'Vašega ukaza se ne da izvesti zaradi težav z avtorizacijo.';
	CKFLang.Errors[104] = 'Vašega ukaza se ne da izvesti zaradi težav z nastavitvami pravic v datotečnem sistemu.';
	CKFLang.Errors[105] = 'Napačna končnica datoteke.';
	CKFLang.Errors[109] = 'Napačna zahteva.';
	CKFLang.Errors[110] = 'Neznana napaka.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'Datoteka ali mapa s tem imenom že obstaja.';
	CKFLang.Errors[116] = 'Mapa ni najdena. Prosimo osvežite okno in poskusite znova.';
	CKFLang.Errors[117] = 'Datoteka ni najdena. Prosimo osvežite seznam datotek in poskusite znova.';
	CKFLang.Errors[118] = 'Začetna in končna pot je ista.';
	CKFLang.Errors[201] = 'Datoteka z istim imenom že obstaja. Naložena datoteka je bila preimenovana v "%1".';
	CKFLang.Errors[202] = 'Neprimerna datoteka.';
	CKFLang.Errors[203] = 'Datoteka je prevelika in zasede preveč prostora.';
	CKFLang.Errors[204] = 'Naložena datoteka je okvarjena.';
	CKFLang.Errors[205] = 'Na strežniku ni na voljo začasna mapa za prenos datotek.';
	CKFLang.Errors[206] = 'Nalaganje je bilo prekinjeno zaradi varnostnih razlogov. Datoteka vsebuje podatke, ki spominjajo na HTML kodo.';
	CKFLang.Errors[207] = 'Naložena datoteka je bila preimenovana v "%1".';
	CKFLang.Errors[300] = 'Premikanje datotek(e) ni uspelo.';
	CKFLang.Errors[301] = 'Kopiranje datotek(e) ni uspelo.';
	CKFLang.Errors[500] = 'Brskalnik je onemogočen zaradi varnostnih razlogov. Prosimo kontaktirajte upravljalca spletnih strani.';
	CKFLang.Errors[501] = 'Ni podpore za majhne sličice (predogled).';
</cfscript>
</cfsilent>
