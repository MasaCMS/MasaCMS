<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Italian language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Impossibile completare la richiesta. (Errore %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Commando non valido.';
	CKFLang.Errors[11] = 'Il tipo di risorsa non è stato specificato nella richiesta.';
	CKFLang.Errors[12] = 'Il tipo di risorsa richiesto non è valido.';
	CKFLang.Errors[102] = 'Nome di file o cartella non valido.';
	CKFLang.Errors[103] = 'Non è stato possibile completare la richiesta a causa di restrizioni di autorizazione.';
	CKFLang.Errors[104] = 'Non è stato possibile completare la richiesta a causa di restrizioni nei permessi del file system.';
	CKFLang.Errors[105] = 'L''estensione del file non è valida.';
	CKFLang.Errors[109] = 'Richiesta invalida.';
	CKFLang.Errors[110] = 'Errore sconosciuto.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'Un file o cartella con lo stesso nome è già esistente.';
	CKFLang.Errors[116] = 'Cartella non trovata. Prego aggiornare e riprovare.';
	CKFLang.Errors[117] = 'File non trovato. Prego aggirnare la lista dei file e riprovare.';
	CKFLang.Errors[118] = 'Il percorso di origine e di destino sono uguali.';
	CKFLang.Errors[201] = 'Un file con lo stesso nome è già disponibile. Il file caricato è stato rinominato in "%1".';
	CKFLang.Errors[202] = 'File invalido.';
	CKFLang.Errors[203] = 'File invalido. La dimensione del file eccede i limiti del sistema.';
	CKFLang.Errors[204] = 'Il file caricato è corrotto.';
	CKFLang.Errors[205] = 'Il folder temporario non è disponibile new server.';
	CKFLang.Errors[206] = 'Upload annullato per motivi di sicurezza. Il file contiene dati in formatto HTML.';
	CKFLang.Errors[207] = 'Il file caricato è stato rinominato a "%1".';
	CKFLang.Errors[300] = 'Non è stato possibile muovere i file.';
	CKFLang.Errors[301] = 'Non è stato possibile copiare i file.';
	CKFLang.Errors[500] = 'Questo programma è disabilitato per motivi di sicurezza. Prego contattare l''amministratore del sistema e verificare le configurazioni di CKFinder.';
	CKFLang.Errors[501] = 'Il supporto alle anteprime non è attivo.';
</cfscript>
</cfsilent>
