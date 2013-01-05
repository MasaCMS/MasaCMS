<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Catalan language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'No ha estat possible completar la solicitut. (Error %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Ordre incorrecte.';
	CKFLang.Errors[11] = 'El tipus de recurs no ha estat especificat a la solicitut.';
	CKFLang.Errors[12] = 'El tipus de recurs solicitat no és vàlid.';
	CKFLang.Errors[102] = 'Nom de fitxer o carpeta no vàlids.';
	CKFLang.Errors[103] = 'No s''ha pogut completar la solicitut degut a les restriccions d''autorització.';
	CKFLang.Errors[104] = 'No s''ha pogut completar la solicitut degut a les restriccions en el sistema de fitxers.';
	CKFLang.Errors[105] = 'La extensió del fitxer no es vàlida.';
	CKFLang.Errors[109] = 'Petició invàlida.';
	CKFLang.Errors[110] = 'Error desconegut.';
	CKFLang.Errors[111] = 'No ha estat possible completar l''operació a causa de la grandària del fitxer resultant.';
	CKFLang.Errors[115] = 'Ja existeix un fitxer o carpeta amb aquest nom.';
	CKFLang.Errors[116] = 'No s''ha trobat la carpeta. Si us plau, actualitzi i torni-ho a provar.';
	CKFLang.Errors[117] = 'No s''ha trobat el fitxer. Si us plau, actualitzi i torni-ho a provar.';
	CKFLang.Errors[118] = 'Les rutes origen i destí són iguals.';
	CKFLang.Errors[201] = 'Ja existeix un fitxer amb aquest nom. El fitxer pujat ha estat renombrat com a "%1".';
	CKFLang.Errors[202] = 'Fitxer invàlid.';
	CKFLang.Errors[203] = 'Fitxer invàlid. El pes és massa gran.';
	CKFLang.Errors[204] = 'El fitxer pujat està corrupte.';
	CKFLang.Errors[205] = 'La carpeta temporal no està disponible en el servidor per poder realitzar pujades.';
	CKFLang.Errors[206] = 'La pujada s''ha cancel·lat per raons de seguretat. El fitxer conté codi HTML.';
	CKFLang.Errors[207] = 'El fitxer pujat ha estat renombrat com a "%1".';
	CKFLang.Errors[300] = 'Ha fallat el moure el(s) fitxer(s).';
	CKFLang.Errors[301] = 'Ha fallat el copiar el(s) fitxer(s).';
	CKFLang.Errors[500] = 'El navegador de fitxers està deshabilitat per raons de seguretat. Si us plau, contacti amb l''administrador del sistema i comprovi el fitxer de configuració de CKFinder.';
	CKFLang.Errors[501] = 'El suport per a icones està deshabilitat.';
</cfscript>
</cfsilent>
