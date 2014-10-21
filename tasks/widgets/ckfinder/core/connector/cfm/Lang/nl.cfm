<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Dutch language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Het was niet mogelijk om deze actie uit te voeren. (Fout %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Ongeldig commando.';
	CKFLang.Errors[11] = 'Het bestandstype komt niet voor in de aanvraag.';
	CKFLang.Errors[12] = 'Het gevraagde brontype is niet geldig.';
	CKFLang.Errors[102] = 'Ongeldige bestands- of mapnaam.';
	CKFLang.Errors[103] = 'Het verzoek kon niet worden voltooid vanwege autorisatie beperkingen.';
	CKFLang.Errors[104] = 'Het verzoek kon niet worden voltooid door beperkingen in de rechten op het bestandssysteem.';
	CKFLang.Errors[105] = 'Ongeldige bestandsextensie.';
	CKFLang.Errors[109] = 'Ongeldige aanvraag.';
	CKFLang.Errors[110] = 'Onbekende fout.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'Er bestaat al een bestand of map met deze naam.';
	CKFLang.Errors[116] = 'Map niet gevonden, vernieuw de mappenlijst of kies een andere map.';
	CKFLang.Errors[117] = 'Bestand niet gevonden, vernieuw de mappenlijst of kies een andere map.';
	CKFLang.Errors[118] = 'Bron- en doelmap zijn gelijk.';
	CKFLang.Errors[201] = 'Er bestaat al een bestand met dezelfde naam. Het geüploade bestand is hernoemd naar: "%1".';
	CKFLang.Errors[202] = 'Ongeldige bestand.';
	CKFLang.Errors[203] = 'Ongeldige bestand. Het bestand is te groot.';
	CKFLang.Errors[204] = 'De geüploade file is kapot.';
	CKFLang.Errors[205] = 'Er is geen hoofdmap gevonden.';
	CKFLang.Errors[206] = 'Het uploaden van het bestand is om veiligheidsredenen afgebroken. Er is HTML code in het bestand aangetroffen.';
	CKFLang.Errors[207] = 'Het geüploade bestand is hernoemd naar: "%1".';
	CKFLang.Errors[300] = 'Bestand(en) verplaatsen is mislukt.';
	CKFLang.Errors[301] = 'Bestand(en) kopiëren is mislukt.';
	CKFLang.Errors[500] = 'Het uploaden van een bestand is momenteel niet mogelijk. Contacteer de beheerder en controleer het CKFinder configuratiebestand.';
	CKFLang.Errors[501] = 'De ondersteuning voor miniatuurafbeeldingen is uitgeschakeld.';
</cfscript>
</cfsilent>
