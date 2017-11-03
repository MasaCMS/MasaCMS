/**
 * Create an instance of the FCKeditor.
 */
component output="false" displayname="FCKeditor" hint="Create an instance of the FCKeditor." {
	/*
 * FCKeditor - The text editor for Internet - http://www.fckeditor.net
 * Copyright (C) 2003-2009 Frederico Caldeira Knabben
 *
 * == BEGIN LICENSE ==
 *
 * Licensed under the terms of any of the following licenses at your
 * choice:
 *
 *  - GNU General Public License Version 2 or later (the "GPL")
 *    http://www.gnu.org/licenses/gpl.html
 *
 *  - GNU Lesser General Public License Version 2.1 or later (the "LGPL")
 *    http://www.gnu.org/licenses/lgpl.html
 *
 *  - Mozilla Public License Version 1.1 or later (the "MPL")
 *    http://www.mozilla.org/MPL/MPL-1.1.html
 *
 * == END LICENSE ==
 *
 * ColdFusion MX integration.
 * Note this CFC is created for use only with Coldfusion MX and above.
 * For older version, check the fckeditor.cfm.
 *
 * Syntax:
 *

 *
 * See your macromedia coldfusion mx documentation for more info.
 *
 * *** Note:
 * Do not use path names with a "." (dot) in the name. This is a coldfusion
 * limitation with the cfc invocation.
*/
	include "fckutils.cfm";

	/**
	 * Outputs the editor HTML in the place where the function is called
	 */
	public void function Create() output=false {

		return CreateHtml();

	}

	/**
	 * Retrieves the editor HTML
	 */
	public string function CreateHtml() output=false {
		cfparam( name="this.instanceName", type="string" );
		cfparam( default="100%", name="this.width", type="string" );
		cfparam( default=200, name="this.height", type="string" );
		cfparam( default="Default", name="this.toolbarSet", type="string" );
		cfparam( default="", name="this.value", type="string" );
		cfparam( default="/fckeditor/", name="this.basePath", type="string" );
		cfparam( default=true, name="this.checkBrowser", type="boolean" );
		cfparam( default=structNew(), name="this.config", type="struct" );

		// display the html editor or a plain textarea?
	if( isCompatible() )
		return getHtmlEditor();
	else
		return getTextArea();
	}

	/**
	 * Check browser compatibility via HTTP_USER_AGENT, if checkBrowser is true
	 */
	private boolean function isCompatible() output=false {

		var sAgent = lCase( cgi.HTTP_USER_AGENT );
	var stResult = "";
	var sBrowserVersion = "";

	// do not check if argument "checkBrowser" is false
	if( not this.checkBrowser )
		return true;

	return FCKeditor_IsCompatibleBrowser();
	}

	/**
	 * Create a textarea field for non-compatible browsers.
	 */
	private string function getTextArea() output=false {
		var result = "";
		var sWidthCSS = "";
		var sHeightCSS = "";

		if( Find( "%", this.width ) gt 0)
		sWidthCSS = this.width;
	else
		sWidthCSS = this.width & "px";

	if( Find( "%", this.width ) gt 0)
		sHeightCSS = this.height;
	else
		sHeightCSS = this.height & "px";

	result = "<textarea name=""#this.instanceName#"" rows=""4"" cols=""40"" style=""width: #sWidthCSS#; height: #sHeightCSS#"">#HTMLEditFormat(this.value)#</textarea>" & chr(13) & chr(10);
		return result;
	}

	/**
	 * Create the html editor instance for compatible browsers.
	 */
	private string function getHtmlEditor() output=false {
		var sURL = "";
		var result = "";

		// try to fix the basePath, if ending slash is missing
	if( len( this.basePath) and right( this.basePath, 1 ) is not "/" )
		this.basePath = this.basePath & "/";

	// construct the url
	sURL = this.basePath & "editor/fckeditor.html?InstanceName=" & this.instanceName;

	// append toolbarset name to the url
	if( len( this.toolbarSet ) )
		sURL = sURL & "&amp;Toolbar=" & this.toolbarSet;

		result = result & "<input type=""hidden"" id=""#this.instanceName#"" name=""#this.instanceName#"" value=""#HTMLEditFormat(this.value)#"" style=""display:none"" />" & chr(13) & chr(10);
	result = result & "<input type=""hidden"" id=""#this.instanceName#___Config"" value=""#GetConfigFieldString()#"" style=""display:none"" />" & chr(13) & chr(10);
	result = result & "<invalidTag id=""#this.instanceName#___Frame"" src=""#sURL#"" width=""#this.width#"" height=""#this.height#"" frameborder=""0"" scrolling=""no""></iframe>" & chr(13) & chr(10);
		return result;
	}

	/**
	 * Create configuration string: Key1=Value1&Key2=Value2&... (Key/Value:HTML encoded)
	 */
	private string function GetConfigFieldString() output=false {
		var sParams = "";
		var key = "";
		var fieldValue = "";
		var fieldLabel = "";
		var lConfigKeys = "";
		var iPos = "";

		/**
	 * CFML doesn't store casesensitive names for structure keys, but the configuration names must be casesensitive for js.
	 * So we need to find out the correct case for the configuration keys.
	 * We "fix" this by comparing the caseless configuration keys to a list of all available configuration options in the correct case.
	 * changed 20041206 hk@lwd.de (improvements are welcome!)
	 */
	lConfigKeys = lConfigKeys & "CustomConfigurationsPath,EditorAreaCSS,ToolbarComboPreviewCSS,DocType";
	lConfigKeys = lConfigKeys & ",BaseHref,FullPage,Debug,AllowQueryStringDebug,SkinPath";
	lConfigKeys = lConfigKeys & ",PreloadImages,PluginsPath,AutoDetectLanguage,DefaultLanguage,ContentLangDirection";
	lConfigKeys = lConfigKeys & ",ProcessHTMLEntities,IncludeLatinEntities,IncludeGreekEntities,ProcessNumericEntities,AdditionalNumericEntities";
	lConfigKeys = lConfigKeys & ",FillEmptyBlocks,FormatSource,FormatOutput,FormatIndentator";
	lConfigKeys = lConfigKeys & ",StartupFocus,ForcePasteAsPlainText,AutoDetectPasteFromWord,ForceSimpleAmpersand";
	lConfigKeys = lConfigKeys & ",TabSpaces,ShowBorders,SourcePopup,ToolbarStartExpanded,ToolbarCanCollapse";
	lConfigKeys = lConfigKeys & ",IgnoreEmptyParagraphValue,FloatingPanelsZIndex,TemplateReplaceAll,TemplateReplaceCheckbox";
	lConfigKeys = lConfigKeys & ",ToolbarLocation,ToolbarSets,EnterMode,ShiftEnterMode,Keystrokes";
	lConfigKeys = lConfigKeys & ",ContextMenu,BrowserContextMenuOnCtrl,FontColors,FontNames,FontSizes";
	lConfigKeys = lConfigKeys & ",FontFormats,StylesXmlPath,TemplatesXmlPath,SpellChecker,IeSpellDownloadUrl";
	lConfigKeys = lConfigKeys & ",SpellerPagesServerScript,FirefoxSpellChecker,MaxUndoLevels,DisableObjectResizing,DisableFFTableHandles";
	lConfigKeys = lConfigKeys & ",LinkDlgHideTarget,LinkDlgHideAdvanced,ImageDlgHideLink,ImageDlgHideAdvanced,FlashDlgHideAdvanced";
	lConfigKeys = lConfigKeys & ",ProtectedTags,BodyId,BodyClass,DefaultLinkTarget,CleanWordKeepsStructure";
	lConfigKeys = lConfigKeys & ",LinkBrowser,LinkBrowserURL,LinkBrowserWindowWidth,LinkBrowserWindowHeight,ImageBrowser";
	lConfigKeys = lConfigKeys & ",ImageBrowserURL,ImageBrowserWindowWidth,ImageBrowserWindowHeight,FlashBrowser,FlashBrowserURL";
	lConfigKeys = lConfigKeys & ",FlashBrowserWindowWidth,FlashBrowserWindowHeight,LinkUpload,LinkUploadURL,LinkUploadWindowWidth";
	lConfigKeys = lConfigKeys & ",LinkUploadWindowHeight,LinkUploadAllowedExtensions,LinkUploadDeniedExtensions,ImageUpload,ImageUploadURL";
	lConfigKeys = lConfigKeys & ",ImageUploadAllowedExtensions,ImageUploadDeniedExtensions,FlashUpload,FlashUploadURL,FlashUploadAllowedExtensions";
	lConfigKeys = lConfigKeys & ",FlashUploadDeniedExtensions,SmileyPath,SmileyImages,SmileyColumns,SmileyWindowWidth,SmileyWindowHeight,GoogleMaps_Key,DynamicToolbar_buttons";

	for( key in this.config )
	{
		iPos = listFindNoCase( lConfigKeys, key );
		if( iPos GT 0 )
		{
			if( len( sParams ) )
				sParams = sParams & "&amp;";

			fieldValue = this.config[key];
			fieldName = listGetAt( lConfigKeys, iPos );

			// set all boolean possibilities in CFML to true/false values
			if( isBoolean( fieldValue) and fieldValue )
				fieldValue = "true";
			else if( isBoolean( fieldValue) )
				fieldValue = "false";

			sParams = sParams & HTMLEditFormat( fieldName ) & '=' & HTMLEditFormat( fieldValue );
		}
	}
	return sParams;
	}

}
