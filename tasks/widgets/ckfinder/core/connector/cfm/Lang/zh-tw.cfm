<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Chinese (Taiwan) language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = '無法連接到伺服器 ! (錯誤代碼 %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = '不合法的指令.';
	CKFLang.Errors[11] = '連接過程中 , 未指定資源形態 !';
	CKFLang.Errors[12] = '連接過程中出現不合法的資源形態 !';
	CKFLang.Errors[102] = '不合法的檔案或目錄名稱 !';
	CKFLang.Errors[103] = '無法連接：可能是使用者權限設定錯誤 !';
	CKFLang.Errors[104] = '無法連接：可能是伺服器檔案權限設定錯誤 !';
	CKFLang.Errors[105] = '無法上傳：不合法的副檔名 !';
	CKFLang.Errors[109] = '不合法的請求 !';
	CKFLang.Errors[110] = '不明錯誤 !';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = '檔案或目錄名稱重複 !';
	CKFLang.Errors[116] = '找不到目錄 ! 請先重新整理 , 然後再試一次 !';
	CKFLang.Errors[117] = '找不到檔案 ! 請先重新整理 , 然後再試一次 !';
	CKFLang.Errors[118] = 'Source and target paths are equal.';
	CKFLang.Errors[201] = '伺服器上已有相同的檔案名稱 ! 您上傳的檔案名稱將會自動更改為 "%1".';
	CKFLang.Errors[202] = '不合法的檔案 !';
	CKFLang.Errors[203] = '不合法的檔案 ! 檔案大小超過預設值 !';
	CKFLang.Errors[204] = '您上傳的檔案已經損毀 !';
	CKFLang.Errors[205] = '伺服器上沒有預設的暫存目錄 !';
	CKFLang.Errors[206] = '檔案上傳程序因為安全因素已被系統自動取消 ! 可能是上傳的檔案內容包含 HTML 碼 !';
	CKFLang.Errors[207] = '您上傳的檔案名稱將會自動更改為 "%1".';
	CKFLang.Errors[300] = 'Moving file(s) failed.';
	CKFLang.Errors[301] = 'Copying file(s) failed.';
	CKFLang.Errors[500] = '因為安全因素 , 檔案瀏覽器已被停用 ! 請聯絡您的系統管理者並檢查 CKFinder 的設定檔 config.php !';
	CKFLang.Errors[501] = '縮圖預覽功能已被停用 !';
</cfscript>
</cfsilent>
