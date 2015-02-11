<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Finnish language. Translated into Finnish 2010-12-15 by Petteri Salmela, updated.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Pyyntöä ei voitu suorittaa. (Virhe %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Virheellinen komento.';
	CKFLang.Errors[11] = 'Pyynnön resurssityyppi on määrittelemättä.';
	CKFLang.Errors[12] = 'Pyynnön resurssityyppi on virheellinen.';
	CKFLang.Errors[102] = 'Virheellinen tiedosto- tai kansionimi.';
	CKFLang.Errors[103] = 'Oikeutesi eivät riitä pyynnön suorittamiseen.';
	CKFLang.Errors[104] = 'Tiedosto-oikeudet eivät riitä pyynnön suorittamiseen.';
	CKFLang.Errors[105] = 'Virheellinen tiedostotarkenne.';
	CKFLang.Errors[109] = 'Virheellinen pyyntö.';
	CKFLang.Errors[110] = 'Tuntematon virhe.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'Samanniminen tiedosto tai kansio on jo olemassa.';
	CKFLang.Errors[116] = 'Kansiota ei löydy. Yritä uudelleen kansiopäivityksen jälkeen.';
	CKFLang.Errors[117] = 'Tiedostoa ei löydy. Yritä uudelleen kansiopäivityksen jälkeen.';
	CKFLang.Errors[118] = 'Lähde- ja kohdekansio on sama!';
	CKFLang.Errors[201] = 'Samanniminen tiedosto on jo olemassa. Palvelimelle ladattu tiedosto on nimetty: "%1".';
	CKFLang.Errors[202] = 'Virheellinen tiedosto.';
	CKFLang.Errors[203] = 'Virheellinen tiedosto. Tiedostokoko on liian suuri.';
	CKFLang.Errors[204] = 'Palvelimelle ladattu tiedosto on vioittunut.';
	CKFLang.Errors[205] = 'Väliaikaishakemistoa ei ole määritetty palvelimelle lataamista varten.';
	CKFLang.Errors[206] = 'Palvelimelle lataaminen on peruttu turvallisuussyistä. Tiedosto sisältää HTML-tyylistä dataa.';
	CKFLang.Errors[207] = 'Palvelimelle ladattu tiedosto on  nimetty: "%1".';
	CKFLang.Errors[300] = 'Tiedostosiirto epäonnistui.';
	CKFLang.Errors[301] = 'Tiedostokopiointi epäonnistui.';
	CKFLang.Errors[500] = 'Tiedostoselain on kytketty käytöstä turvallisuussyistä. Pyydä pääkäyttäjää tarkastamaan CKFinderin asetustiedosto.';
	CKFLang.Errors[501] = 'Esikatselukuvien tuki on kytketty toiminnasta.';
</cfscript>
</cfsilent>
