<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Spanish language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'No ha sido posible completar la solicitud. (Error %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Comando incorrecto.';
	CKFLang.Errors[11] = 'El tipo de recurso no ha sido especificado en la solicitud.';
	CKFLang.Errors[12] = 'El tipo de recurso solicitado no es válido.';
	CKFLang.Errors[102] = 'Nombre de fichero o carpeta no válido.';
	CKFLang.Errors[103] = 'No se ha podido completar la solicitud debido a las restricciones de autorización.';
	CKFLang.Errors[104] = 'No ha sido posible completar la solicitud debido a restricciones en el sistema de ficheros.';
	CKFLang.Errors[105] = 'La extensión del archivo no es válida.';
	CKFLang.Errors[109] = 'Petición inválida.';
	CKFLang.Errors[110] = 'Error desconocido.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'Ya existe un fichero o carpeta con ese nombre.';
	CKFLang.Errors[116] = 'No se ha encontrado la carpeta. Por favor, actualice y pruebe de nuevo.';
	CKFLang.Errors[117] = 'No se ha encontrado el fichero. Por favor, actualice la lista de ficheros y pruebe de nuevo.';
	CKFLang.Errors[118] = 'Las rutas origen y destino son iguales.';
	CKFLang.Errors[201] = 'Ya existía un fichero con ese nombre. El fichero subido ha sido renombrado como "%1".';
	CKFLang.Errors[202] = 'Fichero inválido.';
	CKFLang.Errors[203] = 'Fichero inválido. El peso es demasiado grande.';
	CKFLang.Errors[204] = 'El fichero subido está corrupto.';
	CKFLang.Errors[205] = 'La carpeta temporal no está disponible en el servidor para las subidas.';
	CKFLang.Errors[206] = 'La subida se ha cancelado por razones de seguridad. El fichero contenía código HTML.';
	CKFLang.Errors[207] = 'El fichero subido ha sido renombrado como "%1".';
	CKFLang.Errors[300] = 'Ha fallado el mover el(los) fichero(s).';
	CKFLang.Errors[301] = 'Ha fallado el copiar el(los) fichero(s).';
	CKFLang.Errors[500] = 'El navegador de archivos está deshabilitado por razones de seguridad. Por favor, contacte con el administrador de su sistema y compruebe el fichero de configuración de CKFinder.';
	CKFLang.Errors[501] = 'El soporte para iconos está deshabilitado.';
</cfscript>
</cfsilent>
