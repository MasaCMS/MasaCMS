<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the German language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Ihre Anfrage konnte nicht bearbeitet werden. (Fehler %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Unbekannter Befehl.';
	CKFLang.Errors[11] = 'Der Ressourcentyp wurde nicht spezifiziert.';
	CKFLang.Errors[12] = 'Der Ressourcentyp ist nicht gültig.';
	CKFLang.Errors[102] = 'Ungültiger Datei oder Verzeichnisname.';
	CKFLang.Errors[103] = 'Ihre Anfrage konnte wegen Authorisierungseinschränkungen nicht durchgeführt werden.';
	CKFLang.Errors[104] = 'Ihre Anfrage konnte wegen Dateisystemeinschränkungen nicht durchgeführt werden.';
	CKFLang.Errors[105] = 'Invalid file extension.';
	CKFLang.Errors[109] = 'Unbekannte Anfrage.';
	CKFLang.Errors[110] = 'Unbekannter Fehler.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'Es existiert bereits eine Datei oder ein Ordner mit dem gleichen Namen.';
	CKFLang.Errors[116] = 'Verzeichnis nicht gefunden. Bitte aktualisieren Sie die Anzeige und versuchen es noch einmal.';
	CKFLang.Errors[117] = 'Datei nicht gefunden. Bitte aktualisieren Sie die Dateiliste und versuchen es noch einmal.';
	CKFLang.Errors[118] = 'Quell- und Zielpfad sind gleich.';
	CKFLang.Errors[201] = 'Es existiert bereits eine Datei unter gleichem Namen. Die hochgeladene Datei wurde unter "%1" gespeichert.';
	CKFLang.Errors[202] = 'Ungültige Datei.';
	CKFLang.Errors[203] = 'ungültige Datei. Die Dateigröße ist zu groß.';
	CKFLang.Errors[204] = 'Die hochgeladene Datei ist korrupt.';
	CKFLang.Errors[205] = 'Es existiert kein temp. Ordner für das Hochladen auf den Server.';
	CKFLang.Errors[206] = 'Das Hochladen wurde aus Sicherheitsgründen abgebrochen. Die Datei enthält HTML-Daten.';
	CKFLang.Errors[207] = 'Die hochgeladene Datei wurde unter "%1" gespeichert.';
	CKFLang.Errors[300] = 'Verschieben der Dateien fehlgeschlagen.';
	CKFLang.Errors[301] = 'Kopieren der Dateien fehlgeschlagen.';
	CKFLang.Errors[500] = 'Der Dateibrowser wurde aus Sicherheitsgründen deaktiviert. Bitte benachrichtigen Sie Ihren Systemadministrator und prüfen Sie die Konfigurationsdatei.';
	CKFLang.Errors[501] = 'Die Miniaturansicht wurde deaktivert.';
</cfscript>
</cfsilent>
