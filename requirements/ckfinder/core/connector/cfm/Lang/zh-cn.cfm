<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Chinese-Simplified language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = '请求的操作未能完成. (错误 %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = '无效的指令。';
	CKFLang.Errors[11] = '文件类型不在许可范围之内。';
	CKFLang.Errors[12] = '文件类型无效。';
	CKFLang.Errors[102] = '无效的文件名或文件夹名称。';
	CKFLang.Errors[103] = '由于作者限制，该请求不能完成。';
	CKFLang.Errors[104] = '由于文件系统的限制，该请求不能完成。';
	CKFLang.Errors[105] = '无效的扩展名。';
	CKFLang.Errors[109] = '无效请求。';
	CKFLang.Errors[110] = '未知错误。';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = '存在重名的文件或文件夹。';
	CKFLang.Errors[116] = '文件夹不存在. 请刷新后再试。';
	CKFLang.Errors[117] = '文件不存在. 请刷新列表后再试。';
	CKFLang.Errors[118] = '目标位置与当前位置相同。';
	CKFLang.Errors[201] = '文件与现有的重名. 新上传的文件改名为 "%1"。';
	CKFLang.Errors[202] = '无效的文件。';
	CKFLang.Errors[203] = '无效的文件. 文件尺寸太大。';
	CKFLang.Errors[204] = '上传文件已损失。';
	CKFLang.Errors[205] = '服务器中的上传临时文件夹无效。';
	CKFLang.Errors[206] = '因为安全原因，上传中断. 上传文件包含不能 HTML 类型数据。';
	CKFLang.Errors[207] = '新上传的文件改名为 "%1"。';
	CKFLang.Errors[300] = '移动文件失败。';
	CKFLang.Errors[301] = '复制文件失败。';
	CKFLang.Errors[500] = '因为安全原因，文件不可浏览. 请联系系统管理员并检查CKFinder配置文件。';
	CKFLang.Errors[501] = '不支持缩略图方式。';
</cfscript>
</cfsilent>
