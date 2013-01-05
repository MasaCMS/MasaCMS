<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Esperanto language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Ne eblis plenumi la peton. (Eraro %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Nevalida komando.';
	CKFLang.Errors[11] = 'La risurctipo ne estas indikita en la komando.';
	CKFLang.Errors[12] = 'La risurctipo ne estas valida.';
	CKFLang.Errors[102] = 'La dosier- aŭ dosierujnomo ne estas valida.';
	CKFLang.Errors[103] = 'Ne eblis plenumi la peton pro rajtaj limigoj.';
	CKFLang.Errors[104] = 'Ne eblis plenumi la peton pro atingopermesaj limigoj.';
	CKFLang.Errors[105] = 'Nevalida dosiernoma finaĵo.';
	CKFLang.Errors[109] = 'Nevalida peto.';
	CKFLang.Errors[110] = 'Nekonata eraro.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'Dosiero aŭ dosierujo kun tiu nomo jam ekzistas.';
	CKFLang.Errors[116] = 'Tiu dosierujo ne ekzistas. Bonvolu aktualigi kaj reprovi.';
	CKFLang.Errors[117] = 'Tiu dosiero ne ekzistas. Bonvolu aktualigi kaj reprovi.';
	CKFLang.Errors[118] = 'La vojoj al la fonto kaj al la celo estas samaj.';
	CKFLang.Errors[201] = 'Dosiero kun la sama nomo jam ekzistas. La alŝutita dosiero estas renomita al "%1".';
	CKFLang.Errors[202] = 'Nevalida dosiero.';
	CKFLang.Errors[203] = 'Nevalida dosiero. La grando estas tro alta.';
	CKFLang.Errors[204] = 'La alŝutita dosiero estas difektita.';
	CKFLang.Errors[205] = 'Neniu provizora dosierujo estas disponebla por alŝuto al la servilo.';
	CKFLang.Errors[206] = 'Alŝuto nuligita pro kialoj pri sekureco. La dosiero entenas datenojn de HTMLtipo.';
	CKFLang.Errors[207] = 'La alŝutita dosiero estas renomita al "%1".';
	CKFLang.Errors[300] = 'La movo de la dosieroj malsukcesis.';
	CKFLang.Errors[301] = 'La kopio de la dosieroj malsukcesis.';
	CKFLang.Errors[500] = 'La dosieradministra sistemo estas malvalidigita. Kontaktu vian administranton kaj kontrolu la agordodosieron de CKFinder.';
	CKFLang.Errors[501] = 'La eblo de miniaturoj estas malvalidigita.';
</cfscript>
</cfsilent>
