<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the French language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'La demande n''a pas abouti. (Erreur %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Commande invalide.';
	CKFLang.Errors[11] = 'Le type de ressource n''a pas été spécifié dans la commande.';
	CKFLang.Errors[12] = 'Le type de ressource n''est pas valide.';
	CKFLang.Errors[102] = 'Nom de fichier ou de dossier invalide.';
	CKFLang.Errors[103] = 'La demande n''a pas abouti : problème d''autorisations.';
	CKFLang.Errors[104] = 'La demande n''a pas abouti : problème de restrictions de permissions.';
	CKFLang.Errors[105] = 'Extension de fichier invalide.';
	CKFLang.Errors[109] = 'Demande invalide.';
	CKFLang.Errors[110] = 'Erreur inconnue.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'Un fichier ou un dossier avec ce nom existe déjà.';
	CKFLang.Errors[116] = 'Ce dossier n''existe pas. Veuillez rafraîchir la page et réessayer.';
	CKFLang.Errors[117] = 'Ce fichier n''existe pas. Veuillez rafraîchir la page et réessayer.';
	CKFLang.Errors[118] = 'Les chemins vers la source et la cible sont les mêmes.';
	CKFLang.Errors[201] = 'Un fichier avec ce nom existe déjà. Le fichier téléversé a été renommé en "%1".';
	CKFLang.Errors[202] = 'Fichier invalide.';
	CKFLang.Errors[203] = 'Fichier invalide. La taille est trop grande.';
	CKFLang.Errors[204] = 'Le fichier téléversé est corrompu.';
	CKFLang.Errors[205] = 'Aucun dossier temporaire n''est disponible sur le serveur.';
	CKFLang.Errors[206] = 'Envoi interrompu pour raisons de sécurité. Le fichier contient des données de type HTML.';
	CKFLang.Errors[207] = 'Le fichier téléchargé a été renommé "%1".';
	CKFLang.Errors[300] = 'Le déplacement des fichiers a échoué.';
	CKFLang.Errors[301] = 'La copie des fichiers a échoué.';
	CKFLang.Errors[500] = 'L''interface de gestion des fichiers est désactivé. Contactez votre administrateur et vérifier le fichier de configuration de CKFinder.';
	CKFLang.Errors[501] = 'La fonction "miniatures" est désactivée.';
</cfscript>
</cfsilent>
