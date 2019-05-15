<cfcontent reset="yes" type="text/javascript">
/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
<cfsetting showdebugoutput="no">
<cfset $=application.serviceFactory.getBean('$').init(session.siteID)>
<cfset renderer=$.getContentRenderer()>
CKEDITOR.editorConfig = function( config )
{

	<cfoutput>
	<!---
	var LITE = {
		Events : {
			INIT : "lite:init",
			ACCEPT : "lite:accept",
			REJECT : "lite:reject",
			SHOW_HIDE : "lite:showHide",
			TRACKING : "lite:tracking",
			CHANGE: "lite:change"
		},

		Commands : {
			TOGGLE_TRACKING : "lite_ToggleTracking",
			TOGGLE_SHOW : "lite_ToggleShow",
			ACCEPT_ALL : "lite_AcceptAll",
			REJECT_ALL : "lite_RejectAll",
			ACCEPT_ONE : "lite_AcceptOne",
			REJECT_ONE : "lite_RejectOne",
			TOGGLE_TOOLTIPS: "lite_ToggleTooltips"
		}
	};

	var lite =  config.lite = config.lite|| {};
	lite.isTracking = false;

	lite.userName='#JSStringFormat($.currentUser().getFullName())#';
	lite.userId='#JSStringFormat($.currentUser().getUserID())#';
	--->

	CKEditorBasePath='#application.configBean.getContext()#/core/modules/v1';
	CKFinderBasePath='#application.configBean.getContext()#/core/modules/v1';
	</cfoutput>

	<cfoutput>
	<cfif renderer.getheadline() eq "h1">
		// Mura page title set to h1
		config.format_tags = 'p;h1;h2;h3;h4;h5;pre;address;div';
		config.format_h1 = { element : '#renderer.getHeaderTag('subHead1')#' };
		config.format_h2 = { element : '#renderer.getHeaderTag('subHead2')#' };
		config.format_h3 = { element : '#renderer.getHeaderTag('subHead3')#' };
		config.format_h4 = { element : '#renderer.getHeaderTag('subHead4')#' };
		config.format_h5 = { element : '#renderer.getHeaderTag('subHead5')#' };
	<cfelse>
		// Mura page title set to h2
		config.format_tags = 'p;h1;h2;h3;h4;pre;address;div';
		config.format_h1 = { element : '#renderer.getHeaderTag('subHead1')#' };
		config.format_h2 = { element : '#renderer.getHeaderTag('subHead2')#' };
		config.format_h3 = { element : '#renderer.getHeaderTag('subHead3')#' };
		config.format_h4 = { element : '#renderer.getHeaderTag('subHead4')#' };
	</cfif>
	</cfoutput>

	config.disableNativeSpellChecker = false;
	config.startupFocus = false;
	config.skin = 'moono-lisa'; // 'bootstrapck'
	config.allowedContent = {
		$1: {
		// specify elements as an object
		elements: CKEDITOR.dtd,
		attributes: true,
		styles: true,
		classes: true
		}
	};
	config.disallowedContent = 'table[cellspacing,cellpadding,border]';

	//config.uiColor = '#ff3405';
	//config.ignoreEmptyParagraph = false;

	/* Pasting into Editor Options */
	//config.forcePasteAsPlainText = true;
	config.pasteFromWordPromptCleanup = true;
	config.pasteFromWordNumberedHeadingToList = true;
	config.pasteFromWordRemoveFontStyles = true;
	config.pasteFromWordRemoveStyles = true;
 	config.floatSpacePinnedOffsetY = 32;
	config.toolbarStartupExpanded=true;
	config.toolbarCanCollapse = true;
	config.startupShowBorders = false;
	// Hide title attriute
	config.title = false;

	<!--- Toolbars --->

		config.toolbar_Default = [
			{name: 'group1', items:['A11ychecker','Source']},
			{name: 'group2', items:['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print']},
			{name: 'group3', items:['Undo','Redo','-','Find','Replace','-','RemoveFormat']},
			{name: 'group4', items:['BidiLtr','BidiRtl']},
			{name: 'group5', items:['Bold','Italic','Underline','Strike','-','Subscript','Superscript']},'/',
			{name: 'group6', items:['NumberedList','BulletedList','Outdent','Indent','-','Blockquote','CreateDiv']},
			{name: 'group7', items:['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock']},
			{name: 'group8', items:['Link','Unlink','Anchor']},
			{name: 'group9', items:['Image','oembed','leaflet','-','Table','HorizontalRule','SpecialChar','PageBreak','-','Selectlink','SelectComponent','Templates'<cfif application.configBean.getEnableMuraTag()>,'muratag'</cfif>]},
			{name: 'group10', items:['Styles','Format','-','Maximize','ShowBlocks','About']}
		];

		config.toolbar_QuickEdit = [
			{name: 'group1', items:['A11ychecker','Sourcedialog']},
			{name: 'group2', items:['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print']},
			{name: 'group3', items:['Undo','Redo','-','Find','Replace','-','RemoveFormat']},
			{name: 'group4', items:['BidiLtr','BidiRtl']},
			{name: 'group5', items:['Bold','Italic','Underline','Strike','-','Subscript','Superscript']},'/',
			{name: 'group6', items:['NumberedList','BulletedList','Outdent','Indent','-','Blockquote','CreateDiv']},
			{name: 'group7', items:['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock']},
			{name: 'group8', items:['Link','Unlink','Anchor']},
			{name: 'group9', items: ['Image','oembed','leaflet','-','Table','HorizontalRule','SpecialChar','PageBreak']},'/',
			{name: 'group10', items: ['Selectlink','SelectComponent','Templates'<cfif application.configBean.getEnableMuraTag()>,'muratag'</cfif>]},
			{name: 'group11', items: ['Styles','Format','-','Maximize','ShowBlocks','About']}
		];

		config.toolbar_Summary = [
			{name: 'group1', items: ['A11ychecker','Source']},
			{name: 'group2', items: ['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print']},
			{name: 'group3', items: ['Undo','Redo','-','Find','Replace','-','RemoveFormat']},
			{name: 'group4', items: ['BidiLtr','BidiRtl']},
			{name: 'group5', items: ['Bold','Italic','Underline','Strike','-','Subscript','Superscript']},'/',
			{name: 'group6', items: ['NumberedList','BulletedList','Outdent','Indent','-','Blockquote','CreateDiv']},
			{name: 'group7', items: ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock']},
			{name: 'group8', items: ['Link','Unlink','Anchor']},
			{name: 'group9', items: ['Image','oembed','leaflet','-','Table','HorizontalRule','SpecialChar','PageBreak']},'/',
			{name: 'group10', items: ['Selectlink','SelectComponent','Templates'<cfif application.configBean.getEnableMuraTag()>,'muratag'</cfif>]},
			{name: 'group11', items: ['Styles','Format','-','Maximize','ShowBlocks','About']}
		];

		config.toolbar_Form = [
			{name: 'group1', items: ['A11ychecker','Source']},
			{name: 'group2', items: ['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print']},
			{name: 'group3', items: ['Undo','Redo','-','Find','Replace','-','RemoveFormat']},
			{name: 'group4', items: ['BidiLtr','BidiRtl']},
			{name: 'group5', items: ['Bold','Italic','Underline','Strike','-','Subscript','Superscript']},'/',
			{name: 'group6', items: ['NumberedList','BulletedList','Outdent','Indent','-','Blockquote','CreateDiv']},
			{name: 'group7', items: ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock']},
			{name: 'group8', items: ['Link','Unlink','Anchor']},
			{name: 'group9', items: ['Image','oembed','leaflet','-','Table','HorizontalRule','SpecialChar','PageBreak']},'/',
			{name: 'group10', items: ['Selectlink','SelectComponent','Templates'<cfif application.configBean.getEnableMuraTag()>,'muratag'</cfif>]},
			{name: 'group11', items: ['Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField']},
			{name: 'group12', items: ['Styles','Format','-','Maximize','ShowBlocks','About']}
		];

		config.toolbar_Basic = [
			{name: 'group1', items: ['Bold','Italic','RemoveFormat','-','NumberedList','BulletedList','-','Link','Unlink']}
		];

		config.toolbar_FormBuilder = [
			{name: 'group1', items: ['A11ychecker','Source']},
			{name: 'group2', items: ['Bold','Italic','RemoveFormat','-','NumberedList','BulletedList','-','Link','Unlink','Format']}
		];

		config.toolbar_htmlEditor = [
			{name: 'group0', items:['Styles','Format']},
			{name: 'group1', items: ['A11ychecker','Source']},
			{name: 'group2', items: ['Cut','Copy','Paste','PasteText','PasteFromWord']},
			{name: 'group3', items: ['Bold','Italic','RemoveFormat','-','NumberedList','BulletedList','-','Link','Unlink','-','Image']},
			{name: 'group4', items: ['Selectlink','SelectComponent','Templates']},
		];

		config.toolbar_bbcode = [
			{name: 'group1', items: ['Source','Bold','Italic','-','NumberedList','BulletedList','-','Link','Unlink','-','Image']}
		];

	<!--- /Toolbars --->

	config.extraPlugins = 'SelectComponent,Selectlink,leaflet,tableresize,onchange,justify,find,bidi,div,showblocks,forms,templates,pagebreak,codemirror,widget,lineutils,dialog,oembed,sourcedialog,fakeobjects,dialogui,showprotected,balloonpanel,dialogadvtab,a11ychecker';

	if(typeof jQuery == 'undefined'){
		config.toolbar_QuickEdit[0].items.shift()
		config.toolbar_htmlEditor[0].items.shift()
		config.toolbar_FormBuilder[0].items.shift()
		config.toolbar_Form[0].items.shift()
		config.toolbar_Default[0].items.shift()
		var ep=config.extraPlugins.split(",");
		ep.pop();
		config.extraPlugins=ep.join()
	}

	<cfif len($.siteConfig().getRazunaSettings().getApiKey())>
		config.extraPlugins += ',razuna';
	</cfif>

	<cfif application.configBean.getEnableMuraTag()>
		config.extraPlugins += ',muratag';
	</cfif>

	//config.ProtectedTags = 'i';
	config.protectedSource.push( /<i[^>]*><\/i>/g );
	config.protectedSource.push( /<div.*?class=".*?mura\-object.*?">.*?<\/div>/g );
	config.protectedSource.push( /<script.*?>.*?<\/script>/g );
	config.protectedSource.push( /<ins[\s|\S]+?<\/ins>/g); // Protects <INS> tags

	// Remove the Resize plugin as it does not make sense to use it in conjunction with the AutoGrow plugin.
	//removePlugins : 'resize';

	config.entities_additional = "";

	// Code Mirror Plugin - http://ckeditor.com/addon/codemirror
	config.codemirror = {
		autoCloseTags: false
	};

	// Classes applied based on 'Alignment' selection on the Image Properities window
	//config.image2_alignClasses = [ 'image-left', 'image-center', 'image-right' ];
	//config.image2_captionedClass = 'image-captioned';

	// oEmbed Plugin - http://ckeditor.com/addon/oembed + http://w8tcha.github.io/CKEditor-oEmbed-Plugin/
	//config.oembed_maxWidth = '560';
	//config.oembed_maxHeight = '315';
	config.oembed_WrapperClass = 'embeddedContent';

<cfoutput>
	<cfif isDefined('session.siteid') and application.permUtility.getModulePerm("00000000000000000000000000000000000",session.siteid)>
		// filebrowser settings needed for inline edit mode
		var connectorpath = '#application.configBean.getContext()#/core/vendor/ckfinder/ckfinder.html';
		config.filebrowserBrowseUrl = connectorpath;
		config.filebrowserImageBrowseUrl = connectorpath + '?type=Images';
		config.filebrowserUploadUrl = '#application.configBean.getContext()#/core/vendor/ckfinder/core/connector/cfm/connector.cfm?command=QuickUpload&type=#URLEncodedFormat(session.siteid)#_User_Assets&currentFolder=%2Files%2F';
		config.filebrowserImageUploadUrl ='#application.configBean.getContext()#/core/vendor/ckfinder/core/connector/cfm/connector.cfm?command=QuickUpload&type=#URLEncodedFormat(session.siteid)#_User_Assets&currentFolder=%2FImage%2F';
	</cfif>

	<cfset secure=$.getBean('utility').isHTTPS()>

	<!--- contentsCss --->
		config.contentsCss = [];

		<cfif fileExists(expandPath($.siteConfig("themeIncludePath") & '/css/editor/editor.css.cfm') )>
			config.contentsCss.push('#$.siteConfig().getThemeAssetPath(useProtocol=0,secure=secure,complete=1,domain=cgi.server_name)#/css/editor/editor.css.cfm');
		</cfif>

		<cfif fileExists(expandPath($.siteConfig("themeIncludePath") & '/css/editor/editor.css') )>
			config.contentsCss.push('#$.siteConfig().getThemeAssetPath(useProtocol=0,secure=secure,complete=1,domain=cgi.server_name)#/css/editor/editor.css');
		</cfif>

		<cfif fileExists(expandPath($.siteConfig("themeIncludePath") & '/css/editor.css.cfm') )>
			config.contentsCss.push('#$.siteConfig().getThemeAssetPath(useProtocol=0,secure=secure,complete=1,domain=cgi.server_name)#/css/editor.css.cfm');
		</cfif>

		<cfif fileExists(expandPath($.siteConfig("themeIncludePath") & '/css/editor.css') )>
			config.contentsCss.push('#$.siteConfig().getThemeAssetPath(useProtocol=0,secure=secure,complete=1,domain=cgi.server_name)#/css/editor.css');
		</cfif>

	<!--- templates --->
		<cfif fileExists(expandPath($.siteConfig("themeIncludePath") & '/js/editor/templates/default.js.cfm') )>
			config.templates='default';
			config.templates_files= ['#$.siteConfig().getThemeAssetPath(useProtocol=0,secure=secure,complete=1,domain=cgi.server_name)#/js/editor/templates/default.js.cfm'];
		<cfelseif fileExists(expandPath($.siteConfig("themeIncludePath") & '/js/editor/templates/default.js') )>
			config.templates='default';
			config.templates_files= ['#$.siteConfig().getThemeAssetPath(useProtocol=0,secure=secure,complete=1,domain=cgi.server_name)#/js/editor/templates/default.js'];
		</cfif>

	<!--- styleSet --->
		<cfif fileExists(expandPath($.siteConfig("themeIncludePath") & '/js/editor/styles.js.cfm') )>
			config.stylesSet='default:#$.siteConfig().getThemeAssetPath(useProtocol=0,secure=secure,complete=1,domain=cgi.server_name)#/js/editor/styles.js.cfm';
		<cfelseif fileExists(expandPath($.siteConfig("themeIncludePath") & '/js/editor/styles.js') )>
			config.stylesSet='default:#$.siteConfig().getThemeAssetPath(useProtocol=0,secure=secure,complete=1,domain=cgi.server_name)#/js/editor/styles.js';
		</cfif>

	<!--- customConfig --->
		<cfif fileExists(expandPath($.siteConfig("themeIncludePath") & '/js/editor/config.js.cfm') )>
			config.customConfig='#$.siteConfig().getThemeAssetPath(useProtocol=0,secure=secure,complete=1,domain=cgi.server_name)#/js/editor/config.js.cfm';
		<cfelseif fileExists(expandPath($.siteConfig("themeIncludePath") & '/js/editor/config.js') )>
			config.customConfig='#$.siteConfig().getThemeAssetPath(useProtocol=0,secure=secure,complete=1,domain=cgi.server_name)#/js/editor/config.js';
		<cfelseif fileExists(expandPath($.siteConfig("includePath") & '/js/editor/config.js.cfm') )>
			config.customConfig='#$.siteConfig().getAssetPath(useProtocol=0,secure=secure,complete=1,domain=cgi.server_name)#/js/editor/config.js.cfm';
		<cfelseif fileExists(expandPath($.siteConfig("includePath") & '/js/editor/config.js') )>
			config.customConfig='#$.siteConfig().getAssetPath(useProtocol=0,secure=secure,complete=1,domain=cgi.server_name)#/js/editor/config.js';
		</cfif>


	config.defaultLanguage='#listFirst($.siteConfig('JavaLocale'),'_')#';

	#$.renderEvent("onSiteCKEditorConfigRender")#
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

CKEDITOR.on( 'dialogDefinition', function( ev ) {
		var dialogdef = ev.data.definition;
    dialogdef.removeContents('Upload');
    dialogdef.removeContents('upload');
    dialogdef.dialog.on('show',function() { // position dialog windows e.g. image, link

			//Check to make sure that it has access to parent window, import for crossdomain restristions
			try{
				var pwEl=parent.document.getElementById(window.name);
			} catch(e){
				var pwEl=null;
			}

    	if (pwEl != null){ // if iframe/full edit
				var currentPosition = this.getPosition();
				var windowScrolledTo = $(top).scrollTop();
				var modalContainerPosition = $(pwEl).parent().position();
				var modalContainerHeight = $(pwEl).parent().height();
				var dialogHeight = this.getSize().height;
				var viewPortHeight = $(top).innerHeight();

				// calculate the range the dialog can be
				var modalContainerTopVisible = windowScrolledTo - modalContainerPosition.top <= 0;
				var topEdge = modalContainerTopVisible ? 0 : windowScrolledTo - modalContainerPosition.top;
				var modalContainerBottomVisible = (windowScrolledTo + viewPortHeight) >= (modalContainerPosition.top + modalContainerHeight);
				var bottomEdge = modalContainerBottomVisible ? modalContainerHeight : (windowScrolledTo + viewPortHeight) - modalContainerPosition.top;

				// position the dialog
				if ( (currentPosition.y < topEdge )  ) { // align with the top edge of the modal continer
					this.move(currentPosition.x,topEdge,false);
				}

				if ( currentPosition.y + dialogHeight > bottomEdge ) { // align with the bottom edge
					// make sure not to move it out at the top
					var newPosition = bottomEdge - dialogHeight < topEdge ? topEdge : bottomEdge - dialogHeight;
					this.move(currentPosition.x,newPosition,false);
				}

			 	this._.moved = 1; // prevent ck location memory
    	}
    });
});
