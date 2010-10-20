/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
    
    config.startupFocus = 'false';
    
	//config.uiColor = '#AADC6E';
	CKEditorBasePath=context + '/tasks/widgets';
	CKFinderBasePath=context + '/tasks/widgets';
	
	config.skin = 'mura';
	
	config.format_h1 = { element : 'h2' };
	config.format_h2 = { element : 'h3' };
	config.format_h3 = { element : 'h4' };
	config.format_h4 = { element : 'h5' };
	config.format_h5 = { element : 'h6' };
	config.format_h6 = { element : '' };
	
	// config.stylesCombo_stylesSet = 'default:' + '/[siteid]/includes/themes/[theme]/js/editor/styles.js'
	
	config.templates_files = [ CKEditorBasePath + '/ckeditor/plugins/templates/templates/default.js' ];
    // config.templates_files = [ '/[siteid]/includes/themes/[theme]/js/editor/templates/default.js' ];
	config.templates = 'default';
    
    // config.ignoreEmptyParagraph = 'false';
    
    /* Pasting into Editor Options */
    // config.forcePasteAsPlainText = 'true';
    config.pasteFromWordPromptCleanup = 'true';
    config.pasteFromWordNumberedHeadingToList = 'true';
    config.pasteFromWordRemoveFontStyles = 'true';
    config.pasteFromWordRemoveStyles = 'true';

	
	config.toolbar_Default = [
	                                	['Source'],
	                                	['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print','SpellChecker','Scayt'],
	                                	['Undo','Redo','-','Find','Replace','-','RemoveFormat'],
	                                	['BidiLtr','BidiRtl'],
	                                	['Bold','Italic','Underline','StrikeThrough','-','Subscript','Superscript'],
	                                	['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
	                                	['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
	                                	['Link','Unlink','Anchor'],
	                                	['Image','Flash','Media','-','Table','Rule','SpecialChar','PageBreak'],
	                                	['Selectlink','SelectComponent','Templates','-','Styles','Format','-','Maximize','ShowBlocks','-','About']	
	                                ] ;

	config.toolbar_Summary = [
										['Source'],
										['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print','SpellChecker','Scayt'],
										['Undo','Redo','-','Find','Replace','-','RemoveFormat'],
										['BidiLtr','BidiRtl'],
										['Bold','Italic','Underline','StrikeThrough','-','Subscript','Superscript'],
										['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
										['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
										['Link','Unlink','Anchor'],
										['Image','Flash','Media','-','Table','HorizontalRule','SpecialChar','PageBreak'],
										['Selectlink','SelectComponent','Templates','-','Styles','Format','-','Maximize','ShowBlocks','-','About']	
	                                ] ;

	config.toolbar_Form = [
										['Source'],
										['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print','SpellChecker','Scayt'],
										['Undo','Redo','-','Find','Replace','-','RemoveFormat'],
										['BidiLtr','BidiRtl'],
										['Bold','Italic','Underline','StrikeThrough','-','Subscript','Superscript'],
										['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
										['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
										['Link','Unlink','Anchor'],
										['Image','Flash','Media','-','Table','Rule','SpecialChar','PageBreak'],
										['Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField'],
										['Selectlink','SelectComponent','Templates','-','Styles','Format','-','Maximize','ShowBlocks','-','About']	
	                                ] ;

	config.toolbar_Basic = [
	                                	['Bold','Italic','-','NumberedList','BulletedList','-','Link','Unlink']
	                                ] ;

	config.toolbar_htmlEditor = [
	                                	['Bold','Italic','-','NumberedList','BulletedList','-','Link','Unlink','-','Image']
	                                ] ;

	config.extraPlugins = 'SelectComponent,Media,Selectlink';
	config.entities_additional = "";
	//config.protectedSource.push( /\[mura\][\s\S]*?\[\/mura\]/g );
	
	// Media Plugin - http://forge.clermont-universite.fr/projects/show/ckmedia
	config.menu_groups = 'clipboard,form,tablecell,tablecellproperties,tablerow,tablecolumn,table,anchor,link,image,flash,checkbox,radio,textfield,hiddenfield,imagebutton,button,select,textarea,removeMedia';
 

};
