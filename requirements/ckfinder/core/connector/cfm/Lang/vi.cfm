<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Vietnamese language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Không thể hoàn tất yêu cầu. (Lỗi %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Lệnh không hợp lệ.';
	CKFLang.Errors[11] = 'Kiểu tài nguyên không được chỉ định trong yêu cầu.';
	CKFLang.Errors[12] = 'Kiểu tài nguyên yêu cầu không hợp lệ.';
	CKFLang.Errors[102] = 'Tên tập tin hay thư mục không hợp lệ.';
	CKFLang.Errors[103] = 'Không thể hoàn tất yêu cầu vì giới hạn quyền.';
	CKFLang.Errors[104] = 'Không thể hoàn tất yêu cầu vì giới hạn quyền của hệ thống tập tin.';
	CKFLang.Errors[105] = 'Phần mở rộng tập tin không hợp lệ.';
	CKFLang.Errors[109] = 'Yêu cầu không hợp lệ.';
	CKFLang.Errors[110] = 'Lỗi không xác định.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'Tập tin hoặc thư mục cùng tên đã tồn tại.';
	CKFLang.Errors[116] = 'Không thấy thư mục. Hãy làm tươi và thử lại.';
	CKFLang.Errors[117] = 'Không thấy tập tin. Hãy làm tươi và thử lại.';
	CKFLang.Errors[118] = 'Đường dẫn nguồn và đích giống nhau.';
	CKFLang.Errors[201] = 'Tập tin cùng tên đã tồn tại. Tập tin vừa tải lên được đổi tên thành "%1".';
	CKFLang.Errors[202] = 'Tập tin không hợp lệ.';
	CKFLang.Errors[203] = 'Tập tin không hợp lệ. Dung lượng quá lớn.';
	CKFLang.Errors[204] = 'Tập tin tải lên bị hỏng.';
	CKFLang.Errors[205] = 'Không có thư mục tạm để tải tập tin.';
	CKFLang.Errors[206] = 'Huỷ tải lên vì lí do bảo mật. Tập tin chứa dữ liệu giống HTML.';
	CKFLang.Errors[207] = 'Tập tin được đổi tên thành "%1".';
	CKFLang.Errors[300] = 'Di chuyển tập tin thất bại.';
	CKFLang.Errors[301] = 'Chép tập tin thất bại.';
	CKFLang.Errors[500] = 'Trình duyệt tập tin bị vô hiệu vì lí do bảo mật. Xin liên hệ quản trị hệ thống và kiểm tra tập tin cấu hình CKFinder.';
	CKFLang.Errors[501] = 'Chức năng hỗ trợ ảnh mẫu bị vô hiệu.';
</cfscript>
</cfsilent>
