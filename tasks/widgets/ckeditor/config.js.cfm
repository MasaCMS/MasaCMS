<cfcontent reset="yes" type="text/javascript">
/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
<cfsetting showdebugoutput="no">
<cfset $=application.serviceFactory.getBean("MuraScope").init(session.siteID)>
<cfset renderer=$.getContentRenderer()>
CKEDITOR.editorConfig = function( config )
{
    
    config.startupFocus = 'false';
    
	//config.uiColor = '#AADC6E';
	<cfoutput>
	CKEditorBasePath='#application.configBean.getContext()#/tasks/widgets';
	CKFinderBasePath='#application.configBean.getContext()#/tasks/widgets';
	</cfoutput>
	
	config.skin = 'mura';
	
	<!--- If the page title is an <h2> (the Mura default), output the Format Dropdown list like this --->
	<!---
config.format_tags = 'p;h1;h2;h3;h4;pre;address;div';
	
	<cfoutput>
	config.format_h1 = { element : '#renderer.getHeaderTag('subHead1')#' };
	config.format_h2 = { element : '#renderer.getHeaderTag('subHead2')#' };
	config.format_h3 = { element : '#renderer.getHeaderTag('subHead3')#' };
	config.format_h4 = { element : '#renderer.getHeaderTag('subHead4')#' };
	</cfoutput>
--->
	
	
	<!--- Else, output it like this --->
	config.format_tags = 'p;h1;h2;h3;h4;h5;pre;address;div';
	
	<cfoutput>
	config.format_h1 = { element : '#renderer.getHeaderTag('headline')#' };
	config.format_h2 = { element : '#renderer.getHeaderTag('subHead1')#' };
	config.format_h3 = { element : '#renderer.getHeaderTag('subHead2')#' };
	config.format_h4 = { element : '#renderer.getHeaderTag('subHead3')#' };
	config.format_h5 = { element : '#renderer.getHeaderTag('subHead4')#' };
	// config.format_h6 = { element : '#renderer.getHeaderTag('subHead5')#' };
	</cfoutput>
	
    // config.ignoreEmptyParagraph = 'false';
    
    /* Pasting into Editor Options */
    // config.forcePasteAsPlainText = 'true';
    config.pasteFromWordPromptCleanup = 'true';
    config.pasteFromWordNumberedHeadingToList = 'true';
    config.pasteFromWordRemoveFontStyles = 'true';
    config.pasteFromWordRemoveStyles = 'true';
	config.startupFocus=false;
	
	config.toolbar_Default = [
	                                	['Source'],
	                                	['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print','SpellChecker','Scayt'],
	                                	['Undo','Redo','-','Find','Replace','-','RemoveFormat'],
	                                	['BidiLtr','BidiRtl'],
	                                	['Bold','Italic','Underline','StrikeThrough','-','Subscript','Superscript'],
	                                	['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
	                                	['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
	                                	['Link','Unlink','Anchor'],
	                                	['Image','Flash','Media','gmap','-','Table','HorizontalRule','SpecialChar','PageBreak','-','Selectlink','SelectComponent','Templates'<cfif application.configBean.getEnableMuraTag()>,'muratag'</cfif>],
										['Styles','Format','-','Maximize','ShowBlocks','About']
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
										['Image','Flash','Media','gmap','-','Table','HorizontalRule','SpecialChar','PageBreak','-','Selectlink','SelectComponent','Templates'<cfif application.configBean.getEnableMuraTag()>,'muratag'</cfif>],
										['Styles','Format','-','Maximize','ShowBlocks','About']
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
										['Image','Flash','Media','gmap','-','Table','HorizontalRule','SpecialChar','PageBreak','-','Selectlink','SelectComponent','Templates'<cfif application.configBean.getEnableMuraTag()>,'muratag'</cfif>],
										['Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField'],
										['Styles','Format','-','Maximize','ShowBlocks','About']
	                                ] ;

	config.toolbar_Basic = [
	                                	['Bold','Italic','-','NumberedList','BulletedList','-','Link','Unlink']
	                                ] ;

	config.toolbar_htmlEditor = [
	                                	['Bold','Italic','-','NumberedList','BulletedList','-','Link','Unlink','-','Image']
	                                ] ;

	config.extraPlugins = <cfif application.configBean.getEnableMuraTag()>'SelectComponent,media,Selectlink,muratag,gmap'<cfelse>'SelectComponent,media,Selectlink,gmap'</cfif>;
	config.entities_additional = "";
	//config.protectedSource.push( /\[mura\][\s\S]*?\[\/mura\]/g );
	
	// Media Plugin - http://forge.clermont-universite.fr/projects/show/ckmedia
	config.menu_groups = 'clipboard,form,tablecell,tablecellproperties,tablerow,tablecolumn,table,anchor,link,image,flash,checkbox,radio,textfield,hiddenfield,imagebutton,button,select,textarea,removeMedia';
	
	//Google Maps plugin - https://github.com/cakemail/GoogleMap-CKeditor-Plugin
	
	
	<cfoutput>
	<cfif len($.siteConfig('GoogleAPIKey'))>
		config.GoogleMaps_Key='#$.siteConfig('GoogleAPIKey')#';
	<cfelse>
		config.GoogleMaps_Key='none';
	</cfif>	
	
	<cfif fileExists(expandPath($.siteConfig("themeIncludePath") & '/css/editor/editor.css.cfm') )>
		config.contentsCss='#$.siteConfig('themeAssetPath')#/css/editor/editor.css.cfm';
	<cfelseif fileExists(expandPath($.siteConfig("themeIncludePath") & '/css/editor/editor.css') )>
		config.contentsCss='#$.siteConfig('themeAssetPath')#/css/editor/editor.css';	
	<cfelseif fileExists(expandPath($.siteConfig("themeIncludePath") & '/css/editor.css.cfm') )>
		config.contentsCss='#$.siteConfig('themeAssetPath')#/css/editor.css.cfm';
	<cfelse>		
		config.contentsCss='#$.siteConfig('themeAssetPath')#/css/editor.css';
	</cfif>
	
	<cfif fileExists(expandPath($.siteConfig("themeIncludePath") & '/js/editor/templates/default.js.cfm') )>
		config.templates='default';
		config.templates_files= ['#$.siteConfig('themeAssetPath')#/js/editor/templates/default.js.cfm'];
	<cfelseif fileExists(expandPath($.siteConfig("themeIncludePath") & '/js/editor/templates/default.js') )>
		config.templates='default';
		config.templates_files= ['#$.siteConfig('themeAssetPath')#/js/editor/templates/default.js'];
	</cfif>
	
	<cfif fileExists(expandPath($.siteConfig("themeIncludePath") & '/js/editor/styles.js.cfm') )>
		config.stylesSet='default:#$.siteConfig('themeAssetPath')#/js/editor/styles.js.cfm';
	<cfelseif fileExists(expandPath($.siteConfig("themeIncludePath") & '/js/editor/styles.js') )>
		config.stylesSet='default:#$.siteConfig('themeAssetPath')#/js/editor/styles.js';
	</cfif>
	
	<cfif fileExists(expandPath($.siteConfig("themeIncludePath") & '/js/editor/config.js.cfm') )>
		config.customConfig='#$.siteConfig('themeAssetPath')#/js/editor/config.js.cfm';
	<cfelseif fileExists(expandPath($.siteConfig("themeIncludePath") & '/js/editor/config.js') )>
		config.customConfig='#$.siteConfig('themeAssetPath')#/js/editor/config.js';
	</cfif>
	
	config.defaultLanguage='#listFirst($.siteConfig('JavaLocale'),'_')#';
    </cfoutput>


};

// keep CKEDITOR from putting a line break and indentation after each tag in 'Source' view
CKEDITOR.on('instanceReady', function(ev){
	var dtd = CKEDITOR.dtd;
	var tags = CKEDITOR.tools.extend( {}, dtd.$nonBodyContent, dtd.$block, dtd.$listItem, dtd.$tableContent );

	for ( var tag in tags )	{
		if ( tag == 'pre' )	{
			continue;
		} else {
			ev.editor.dataProcessor.writer.setRules(
				tag
				, {
					indent: true
					, breakBeforeOpen: true
					, breakAfterOpen: false
					, breakBeforeClose: false
					, breakAfterClose: true
				}
			);	
		};
	};
});
