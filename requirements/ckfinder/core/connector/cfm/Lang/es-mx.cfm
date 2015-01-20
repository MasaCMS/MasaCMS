<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Latin American Spanish language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'No ha sido posible completar la solicitud. (Error %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Comando incorrecto.';
	CKFLang.Errors[11] = 'El tipo de recurso no ha sido especificado en la solicitud.';
	CKFLang.Errors[12] = 'El tipo de recurso solicitado no es válido.';
	CKFLang.Errors[102] = 'Nombre de archivo o carpeta no válido.';
	CKFLang.Errors[103] = 'No se ha podido completar la solicitud debido a las restricciones de autorización.';
	CKFLang.Errors[104] = 'No ha sido posible completar la solicitud debido a restricciones en el sistema de archivos.';
	CKFLang.Errors[105] = 'La extensión del archivo no es válida.';
	CKFLang.Errors[109] = 'Petición inválida.';
	CKFLang.Errors[110] = 'Error desconocido.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'Ya existe un archivo o carpeta con ese nombre.';
	CKFLang.Errors[116] = 'No se ha encontrado la carpeta. Por favor, actualice y pruebe de nuevo.';
	CKFLang.Errors[117] = 'No se ha encontrado el archivo. Por favor, actualice la lista de archivos y pruebe de nuevo.';
	CKFLang.Errors[118] = 'Las rutas origen y destino son iguales.';
	CKFLang.Errors[201] = 'Ya existía un archivo con ese nombre. El archivo subido ha sido renombrado como "%1".';
	CKFLang.Errors[202] = 'Archivo inválido.';
	CKFLang.Errors[203] = 'Archivo inválido. El tamaño es demasiado grande.';
	CKFLang.Errors[204] = 'El archivo subido está corrupto.';
	CKFLang.Errors[205] = 'La carpeta temporal no está disponible en el servidor para las subidas.';
	CKFLang.Errors[206] = 'La subida se ha cancelado por razones de seguridad. El archivo contenía código HTML.';
	CKFLang.Errors[207] = 'El archivo subido ha sido renombrado como "%1".';
	CKFLang.Errors[300] = 'Ha fallado el mover el(los) archivo(s).';
	CKFLang.Errors[301] = 'Ha fallado el copiar el(los) archivo(s).';
	CKFLang.Errors[500] = 'El navegador de archivos está deshabilitado por razones de seguridad. Por favor, contacte con el administrador de su sistema y compruebe el archivo de configuración de CKFinder.';
	CKFLang.Errors[501] = 'El soporte para iconos está deshabilitado.';
</cfscript>
</cfsilent>
