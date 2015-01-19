<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Brazilian Portuguese language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Não foi possível completer o seu pedido. (Erro %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Comando inválido.';
	CKFLang.Errors[11] = 'O tipo de recurso não foi especificado na solicitação.';
	CKFLang.Errors[12] = 'O recurso solicitado não é válido.';
	CKFLang.Errors[102] = 'Nome do arquivo ou pasta inválido.';
	CKFLang.Errors[103] = 'Não foi possível completar a solicitação por restrições de acesso.';
	CKFLang.Errors[104] = 'Não foi possível completar a solicitação por restrições de acesso do sistema de arquivos.';
	CKFLang.Errors[105] = 'Extensão de arquivo inválida.';
	CKFLang.Errors[109] = 'Solicitação inválida.';
	CKFLang.Errors[110] = 'Erro desconhecido.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'Uma arquivo ou pasta já existe com esse nome.';
	CKFLang.Errors[116] = 'Pasta não encontrada. Atualize e tente novamente.';
	CKFLang.Errors[117] = 'Arquivo não encontrado. Atualize a lista de arquivos e tente novamente.';
	CKFLang.Errors[118] = 'Origem e destino são iguais.';
	CKFLang.Errors[201] = 'Um arquivo com o mesmo nome já está disponível. O arquivo enviado foi renomeado para "%1".';
	CKFLang.Errors[202] = 'Arquivo inválido.';
	CKFLang.Errors[203] = 'Arquivo inválido. O tamanho é muito grande.';
	CKFLang.Errors[204] = 'O arquivo enviado está corrompido.';
	CKFLang.Errors[205] = 'Nenhuma pasta temporária para envio está disponível no servidor.';
	CKFLang.Errors[206] = 'Transmissão cancelada por razões de segurança. O arquivo contem dados HTML.';
	CKFLang.Errors[207] = 'O arquivo enviado foi renomeado para "%1".';
	CKFLang.Errors[300] = 'Não foi possível mover o(s) arquivo(s).';
	CKFLang.Errors[301] = 'Não foi possível copiar o(s) arquivos(s).';
	CKFLang.Errors[500] = 'A navegação de arquivos está desativada por razões de segurança. Contacte o administrador do sistema.';
	CKFLang.Errors[501] = 'O suporte a miniaturas está desabilitado.';
</cfscript>
</cfsilent>
