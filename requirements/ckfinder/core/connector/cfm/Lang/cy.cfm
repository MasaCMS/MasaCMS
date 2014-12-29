<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Welsh language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Does dim modd cwblhau''r cais. (Gwall %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Gorchymyn annilys.';
	CKFLang.Errors[11] = 'Doedd math yr adnodd heb ei benodi yn y cais.';
	CKFLang.Errors[12] = 'Dyw math yr adnodd ddim yn ddilys.';
	CKFLang.Errors[102] = 'Enw ffeil neu ffolder annilys.';
	CKFLang.Errors[103] = 'Doedd dim modd cwblhau''r cais oherwydd cyfyngiadau awdurdodi.';
	CKFLang.Errors[104] = 'Doedd dim modd cwblhau''r cais oherwydd cyfyngiadau i hawliau''r system ffeilio.';
	CKFLang.Errors[105] = 'Estyniad ffeil annilys.';
	CKFLang.Errors[109] = 'Cais annilys.';
	CKFLang.Errors[110] = 'Gwall anhysbys.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'Mae ffeil neu ffolder gyda''r un enw yn bodoli yn barod.';
	CKFLang.Errors[116] = 'Methu â darganfod y ffolder. Adfywiwch a cheisio eto.';
	CKFLang.Errors[117] = 'Methu â darganfod y ffeil. Adfywiwch y rhestr ffeiliau a cheisio eto.';
	CKFLang.Errors[118] = 'Mae''r llwybrau gwreiddiol a tharged yn unfath.';
	CKFLang.Errors[201] = 'Mae ffeil â''r enw hwnnw yn bodoli yn barod. Cafodd y ffeil a lanlwythwyd ei hailenwi i "%1".';
	CKFLang.Errors[202] = 'Ffeil annilys.';
	CKFLang.Errors[203] = 'Ffeil annilys. Mae maint y ffeil yn rhy fawr.';
	CKFLang.Errors[204] = 'Mae''r ffeil a lanwythwyd wedi chwalu.';
	CKFLang.Errors[205] = 'Does dim ffolder dros dro ar gael er mwyn lanlwytho ffeiliau iddo ar y gweinydd hwn.';
	CKFLang.Errors[206] = 'Cafodd y lanlwythiad ei ddiddymu oherwydd rhesymau diogelwch. Mae''r ffeil yn cynnwys data yn debyg i HTML.';
	CKFLang.Errors[207] = 'Cafodd y ffeil a lanlwythwyd ei hailenwi i "%1".';
	CKFLang.Errors[300] = 'Methodd symud y ffeil(iau).';
	CKFLang.Errors[301] = 'Methodd copïo''r ffeil(iau).';
	CKFLang.Errors[500] = 'Cafodd y porwr ffeiliau ei anallogi oherwydd rhesymau diogelwch. Cysylltwch â''ch gweinyddwr system a gwirio''ch ffeil ffurfwedd CKFinder.';
	CKFLang.Errors[501] = 'Mae cynhaliaeth bawdluniau wedi''i hanalluogi.';
</cfscript>
</cfsilent>
