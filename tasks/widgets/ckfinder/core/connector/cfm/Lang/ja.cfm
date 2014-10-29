<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Japanese language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'リクエストの処理に失敗しました。 (Error %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = '不正なコマンドです。';
	CKFLang.Errors[11] = 'リソースタイプが特定できませんでした。';
	CKFLang.Errors[12] = '要求されたリソースのタイプが正しくありません。';
	CKFLang.Errors[102] = 'ファイル名/フォルダ名が正しくありません。';
	CKFLang.Errors[103] = 'リクエストを完了できませんでした。認証エラーです。';
	CKFLang.Errors[104] = 'リクエストを完了できませんでした。ファイルのパーミッションが許可されていません。';
	CKFLang.Errors[105] = '拡張子が正しくありません。';
	CKFLang.Errors[109] = '不正なリクエストです。';
	CKFLang.Errors[110] = '不明なエラーが発生しました。';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = '同じ名前のファイル/フォルダがすでに存在しています。';
	CKFLang.Errors[116] = 'フォルダが見つかりませんでした。ページを更新して再度お試し下さい。';
	CKFLang.Errors[117] = 'ファイルが見つかりませんでした。ページを更新して再度お試し下さい。';
	CKFLang.Errors[118] = '対象が移動元と同じ場所を指定されています。';
	CKFLang.Errors[201] = '同じ名前のファイルがすでに存在しています。"%1" にリネームして保存されました。';
	CKFLang.Errors[202] = '不正なファイルです。';
	CKFLang.Errors[203] = 'ファイルのサイズが大きすぎます。';
	CKFLang.Errors[204] = 'アップロードされたファイルは壊れています。';
	CKFLang.Errors[205] = 'サーバ内の一時作業フォルダが利用できません。';
	CKFLang.Errors[206] = 'セキュリティ上の理由からアップロードが取り消されました。このファイルにはHTMLに似たデータが含まれています。';
	CKFLang.Errors[207] = 'ファイルは "%1" にリネームして保存されました。';
	CKFLang.Errors[300] = 'ファイルの移動に失敗しました。';
	CKFLang.Errors[301] = 'ファイルのコピーに失敗しました。';
	CKFLang.Errors[500] = 'ファイルブラウザはセキュリティ上の制限から無効になっています。システム担当者に連絡をして、CKFinderの設定をご確認下さい。';
	CKFLang.Errors[501] = 'サムネイル機能は無効になっています。';
</cfscript>
</cfsilent>
