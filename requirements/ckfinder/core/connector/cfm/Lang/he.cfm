<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Hebrew language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'לא היה ניתן להשלים את הבקשה. (שגיאה %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'הוראה לא תקינה.';
	CKFLang.Errors[11] = 'סוג המשאב לא צויין בבקשה לשרת.';
	CKFLang.Errors[12] = 'סוג המשאב המצויין לא תקין.';
	CKFLang.Errors[102] = 'שם הקובץ או התיקיה לא תקין.';
	CKFLang.Errors[103] = 'לא היה ניתן להשלים את הבקשה בשל הרשאות מוגבלות.';
	CKFLang.Errors[104] = 'לא היה ניתן להשלים את הבקשה בשל הרשאות מערכת קבצים מוגבלות.';
	CKFLang.Errors[105] = 'סיומת הקובץ לא תקינה.';
	CKFLang.Errors[109] = 'בקשה לא תקינה.';
	CKFLang.Errors[110] = 'שגיאה לא ידועה.';
	CKFLang.Errors[111] = 'לא ניתן היה להשלים את הבקשה בשל הגודל החריג של הקובץ הנוצר.';
	CKFLang.Errors[115] = 'כבר קיים/ת קובץ או תיקיה באותו השם.';
	CKFLang.Errors[116] = 'התיקיה לא נמצאה. נא לרענן ולנסות שוב.';
	CKFLang.Errors[117] = 'הקובץ לא נמצא. נא לרענן ולנסות שוב.';
	CKFLang.Errors[118] = 'כתובות המקור והיעד זהות.';
	CKFLang.Errors[201] = 'קובץ עם אותו השם כבר קיים. שם הקובץ שהועלה שונה ל "%1"';
	CKFLang.Errors[202] = 'הקובץ לא תקין.';
	CKFLang.Errors[203] = 'הקובץ לא תקין. גודל הקובץ גדול מדי.';
	CKFLang.Errors[204] = 'הקובץ המועלה לא תקין';
	CKFLang.Errors[205] = 'לא קיימת בשרת תיקיה זמנית להעלאת קבצים.';
	CKFLang.Errors[206] = 'ההעלאה בוטלה מסיבות אבטחה. הקובץ מכיל תוכן שדומה ל-HTML.';
	CKFLang.Errors[207] = 'שם הקובץ שהועלה שונה ל "%1"';
	CKFLang.Errors[300] = 'העברת הקבצים נכשלה.';
	CKFLang.Errors[301] = 'העתקת הקבצים נכשלה.';
	CKFLang.Errors[500] = 'דפדפן הקבצים מנוטרל מסיבות אבטחה. יש לפנות למנהל המערכת ולבדוק את קובץ התצורה של CKFinder.';
	CKFLang.Errors[501] = 'התמיכה בתמונות מוקטנות מבוטלת.';
</cfscript>
</cfsilent>
