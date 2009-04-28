var oEditor = window.parent.InnerDialogLoaded() ;
var FCK		= oEditor.FCK ;

// Set the language direction.
window.document.dir = oEditor.FCKLang.Dir ;

// Set the Skin CSS.
document.write( '<link href="' + oEditor.FCKConfig.SkinPath + 'fck_dialog.css" type="text/css" rel="stylesheet">' ) ;

var sAgent = navigator.userAgent.toLowerCase() ;

var is_ie = (sAgent.indexOf("msie") != -1); // FCKBrowserInfo.IsIE
var is_gecko = !is_ie; // FCKBrowserInfo.IsGecko

var oMedia = null;


function window_onload()
{
	// Translate the dialog box texts.
	oEditor.FCKLanguageManager.TranslatePage(document) ;

	// Load the selected element information (if any).
	LoadSelection() ;

	// Show/Hide the "Browse Server" button.
	GetE('tdBrowse').style.display = oEditor.FCKConfig.FlashBrowser ? '' : 'none' ;

	// Activate the "OK" button.
	window.parent.SetOkButton( true ) ;
}


function getSelectedMovie(){
	var oSel = null;

	// explorer..
	if (is_ie){
		oSel = FCK.Selection.GetSelectedElement( 'OBJECT' );
	}
	
	// gecko
	else if (is_gecko){
		var o = FCK.EditorWindow.getSelection() ;

		if ((o != null) && (o.anchorNode.tagName == 'OBJECT')){
			oSel = o.anchorNode;
		}
	}
	
	// other
	else {
		alert ("Browser Not Supported");
	}

	return oSel;
}

function updatePlaylistOption () {
	if (GetE('selDispPlaylist').value == "right" || GetE('selDispPlaylist').value == "below") {
		GetE('chkPLThumbs').disabled=false;
		GetE('chkPLThumbs').checked=true;
		GetE('txtPLDim').disabled=false;
		GetE('txtPLDim').style.background='#ffffff';
		GetE('spanDimText').style.display='none';
		if (GetE('selDispPlaylist').value == "right") {
			GetE('spanDimWText').style.display='';
			GetE('spanDimHText').style.display='none';
		} else if (GetE('selDispPlaylist').value == "below") {
			GetE('spanDimWText').style.display='none';
			GetE('spanDimHText').style.display='';
		}
	} else {
		GetE('chkPLThumbs').disabled=true;
		GetE('chkPLThumbs').checked=false;
		GetE('txtPLDim').value = "";
		GetE('txtPLDim').disabled=true;
		GetE('txtPLDim').style.background='transparent';
		GetE('spanDimText').style.display='';
		GetE('spanDimWText').style.display='none';
		GetE('spanDimHText').style.display='none';
	}
}


function LoadSelection()
{
	oMedia = new Media();
	oMedia.setObjectElement(getSelectedMovie());
	//alert('test');
/*	
	alert (
		"id: " + oMedia.id +
		"\nUrl: " + oMedia.url + 
		"\nWidth: " + oMedia.width +
		"\nHeight: " + oMedia.height +
		"\nQuality: " + oMedia.quality +
		"\nScale: " + oMedia.scale +
		"\nVSpace: " + oMedia.vspace +
		"\nHSpace: " + oMedia.hspace +
		"\nAlign: " + oMedia.align +
		"\nBgcolor: " + oMedia.bgcolor +
		"\nLoop: " + oMedia.loop +
		"\nPlay: " + oMedia.play
	);
*/
	GetE('rbFileType').value	= oMedia.fileType;
	GetE('txtURL').value    	= oMedia.url;
	GetE('txtPlaylist').value   = oMedia.purl;
	GetE('txtImgURL').value    	= oMedia.iurl;
	GetE('txtWMURL').value    	= oMedia.wmurl;
	GetE('txtWidth').value		= oMedia.width;
	GetE('txtHeight').value		= oMedia.height;
	GetE('chkLoop').value		= oMedia.loop;
	GetE('chkAutoplay').value	= oMedia.play;
	GetE('chkDownload').value	= oMedia.downloadable;
	GetE('chkFullscreen').value	= oMedia.fullscreen;
	GetE('txtBgColor').value	= oMedia.bgcolor;
	GetE('txtToolbarColor').value	= oMedia.toolcolor;
	GetE('txtToolbarTxtColor').value	= oMedia.tooltcolor;
	GetE('txtToolbarTxtRColor').value	= oMedia.tooltrcolor;
	GetE('chkShowNavigation').value	= oMedia.displayNavigation;
	GetE('chkShowDigits').value	= oMedia.displayDigits;
	GetE('selAlign').value		= oMedia.align;
	GetE('selDispPlaylist').value = oMedia.dispPlaylist;
	GetE('txtRURL').value = oMedia.rurl;
	GetE('txtPLDim').value = oMedia.playlistDim;
	GetE('chkPLThumbs').value = oMedia.playlistThumbs;

	//updatePreview();
}

//#### The OK button was hit.
function Ok()
{
	var rbFileTypeVal = "single";
	if (GetE('rbFileType').checked == false) {
		rbFileTypeVal = "list";
	}

	if ( rbFileTypeVal == "single") {
		if ( GetE('txtURL').value.length == 0 )
		{
			GetE('txtURL').focus() ;	

			alert( oEditor.FCKLang.DlgFLVPlayerAlertUrl ) ;
			return false ;
		}
	}

	if (rbFileTypeVal == "list") {
		if ( GetE('txtPlaylist').value.length == 0 )
		{
			GetE('txtPlaylist').focus() ;	

			alert( oEditor.FCKLang.DlgFLVPlayerAlertPlaylist ) ;
			return false ;
		}
	}


	if ( GetE('txtWidth').value.length == 0 )
	{
		GetE('txtWidth').focus() ;	

		alert( oEditor.FCKLang.DlgFLVPlayerAlertWidth ) ;
		return false ;
	}

	if ( GetE('txtHeight').value.length == 0 )
	{
		GetE('txtHeight').focus() ;	

		alert( oEditor.FCKLang.DlgFLVPlayerAlertHeight ) ;
		return false ;
	}


	var e = (oMedia || new Media()) ;

	updateMovie(e) ;

	FCK.InsertHtml(e.getInnerHTML()) ;

	return true ;
}


function updateMovie(e){
	e.fileType = GetE('rbFileType').value;
	e.url = GetE('txtURL').value;
	e.purl = GetE('txtPlaylist').value;
	e.iurl = GetE('txtImgURL').value;
	e.wmurl = GetE('txtWMURL').value;
	e.bgcolor = GetE('txtBgColor').value;
	e.toolcolor = GetE('txtToolbarColor').value;
	e.tooltcolor = GetE('txtToolbarTxtColor').value;
	e.tooltrcolor = GetE('txtToolbarTxtRColor').value;
	e.width = (isNaN(GetE('txtWidth').value)) ? 0 : parseInt(GetE('txtWidth').value);
	e.height = (isNaN(GetE('txtHeight').value)) ? 0 : parseInt(GetE('txtHeight').value);
	e.loop = (GetE('chkLoop').checked) ? 'true' : 'false';
	e.play = (GetE('chkAutoplay').checked) ? 'true' : 'false';
	e.downloadable = (GetE('chkDownload').checked) ? 'true' : 'false';
	e.fullscreen = (GetE('chkFullscreen').checked) ? 'true' : 'false';
	e.displayNavigation = (GetE('chkShowNavigation').checked) ? 'true' : 'false';
	e.displayDigits = (GetE('chkShowDigits').checked) ? 'true' : 'false';
	e.align =	GetE('selAlign').value;
	e.dispPlaylist =	GetE('selDispPlaylist').value;
	e.rurl = GetE('txtRURL').value;
	e.playlistDim = GetE('txtPLDim').value;
	e.playlistThumbs = (GetE('chkPLThumbs').checked) ? 'true' : 'false';
}


function BrowseServer()
{
	OpenServerBrowser(
		'flv',
		oEditor.FCKConfig.LinkBrowserURL,
		oEditor.FCKConfig.LinkBrowserWindowWidth,
		oEditor.FCKConfig.LinkBrowserWindowHeight ) ;
}


function LnkBrowseServer()
{
	OpenServerBrowser(
		'link',
		oEditor.FCKConfig.LinkBrowserURL,
		oEditor.FCKConfig.LinkBrowserWindowWidth,
		oEditor.FCKConfig.LinkBrowserWindowHeight ) ;
}

function Lnk2BrowseServer()
{
	OpenServerBrowser(
		'link2',
		oEditor.FCKConfig.LinkBrowserURL,
		oEditor.FCKConfig.LinkBrowserWindowWidth,
		oEditor.FCKConfig.LinkBrowserWindowHeight ) ;
}

function img1BrowseServer()
{
	OpenServerBrowser(
		'img1',
		oEditor.FCKConfig.ImageBrowserURL,
		oEditor.FCKConfig.ImageBrowserWindowWidth,
		oEditor.FCKConfig.ImageBrowserWindowHeight ) ;
}

function img2BrowseServer()
{
	OpenServerBrowser(
		'img2',
		oEditor.FCKConfig.ImageBrowserURL,
		oEditor.FCKConfig.ImageBrowserWindowWidth,
		oEditor.FCKConfig.ImageBrowserWindowHeight ) ;
}


function OpenServerBrowser( type, url, width, height )
{
	sActualBrowser = type ;
	OpenFileBrowser( url, width, height ) ;
}

var sActualBrowser ;


function SetUrl( url ) {
	if ( sActualBrowser == 'flv' ) {
		document.getElementById('txtURL').value = url ;
		GetE('txtHeight').value = GetE('txtWidth').value = '' ;
	} else if ( sActualBrowser == 'link' ) {
		document.getElementById('txtPlaylist').value = url ;
	} else if ( sActualBrowser == 'link2' ) {
		document.getElementById('txtRURL').value = url ;
	} else if ( sActualBrowser == 'img1' ) {
		document.getElementById('txtImgURL').value = url ;
	} else if ( sActualBrowser == 'img2' ) {
		document.getElementById('txtWMURL').value = url ;
	}
}




var Media = function (o){
	this.fileType = '';
	this.url = '';
	this.purl = '';
	this.iurl = '';
	this.wmurl = '';
	this.width = '';
	this.height = '';
	this.loop = '';
	this.play = '';
	this.downloadable = '';
	this.fullscreen = '';
	this.bgcolor = '';
	this.toolcolor = '';
	this.tooltcolor = '';
	this.tooltrcolor = '';
	this.displayNavigation = '';
	this.displayDigits = '';
	this.align = '';
	this.dispPlaylist = '';
	this.rurl = '';
	this.playlistDim = '';
	this.playlistThumbs = '';

	if (o) 
		this.setObjectElement(o);
};

Media.prototype.setObjectElement = function (e){
	if (!e) return ;
	this.width = GetAttribute( e, 'width', this.width );
	this.height = GetAttribute( e, 'height', this.height );
};


Media.prototype.getInnerHTML = function (objectId){
	var randomnumber = Math.floor(Math.random()*1000001);
	var thisWidth = this.width;
	var thisHeight = this.height;

	var thisMediaType = "single";
	if (GetE('rbFileType').checked == false) {
		thisMediaType = "mpl";
	}

	var s = "";
	s+= '<script src="' + oEditor.FCKConfig.PluginsPath + 'flvPlayer/swfobject.js" type="text/javascript"></script>';
	s+= '<table class="svFlvPlayer" align="' + this.align + '"><tr><td><p id="player' + randomnumber + '"><a href="http://www.macromedia.com/go/getflashplayer">Get the Flash Player</a> to see this player.</p></td></tr></table>';
	s+= '<script type="text/javascript">\n';
	s+= '	//NOTE: FOR LIST OF POSSIBLE SETTINGS GOTO http://www.jeroenwijering.com/extras/readme.html\n';
	s+= '	var s1 = new SWFObject("' + oEditor.FCKConfig.PluginsPath + 'flvPlayer/mediaplayer.swf","' + thisMediaType + '","' + thisWidth + '","' + thisHeight + '","7");\n';
	s+= '	s1.addVariable("width","' + thisWidth + '");\n';
	s+= '	s1.addVariable("height","' + thisHeight + '");\n';
	s+= '	s1.addVariable("autostart","' + this.play + '");\n';

	if (thisMediaType == 'mpl') {
		s+= '	s1.addVariable("file","' + this.purl + '");\n';
		s+= '	s1.addVariable("autoscroll","true");\n';
		s+= '	s1.addParam("allowscriptaccess","always");\n';

		var dispWidth = thisWidth
		var dispHeight = thisHeight
		var dispThumbs = false

		if (this.dispPlaylist != "none") {
			if (this.dispPlaylist == "right") {

				if (this.playlistDim.length > 0) {
					dispWidth = thisWidth - this.playlistDim
					if (this.playlistDim < 100) {
						dispThumbs = false
					} else {
						dispThumbs = true
					}
				} else {
					if (thisWidth >= 550) {
						dispWidth = thisWidth - 200
						dispThumbs = true
					} else if (thisWidth >= 450) {
						dispWidth = thisWidth - 100
						dispThumbs = false
					} else if (thisWidth >= 350) {
						dispWidth = thisWidth - 50
						dispThumbs = false
					}
				}

				s+= '	s1.addVariable("displaywidth","' + dispWidth + '");\n';
			} else if (this.dispPlaylist == "below") {
				dispThumbs = true
				
				if (this.playlistDim.length > 0) {
					dispHeight = thisWidth - this.playlistDim
				} else {
					if (thisHeight >= 550) {
						dispHeight = thisWidth - 200
					} else if (thisHeight >= 450) {
						dispHeight = thisHeight - 150
					} else if (thisHeight >= 350) {
						dispHeight = thisHeight - 100
					}
				}

				s+= '	s1.addVariable("displayheight","' + dispHeight + '");\n';
			}

			if (this.playlistThumbs == "false") {
				dispThumbs = false;
			}
				
			s+= '	s1.addVariable("thumbsinplaylist","' + dispThumbs + '");\n';
		}

		s+= '	s1.addVariable("shuffle","false");\n';
		if (this.loop == true) {
			s+= '	s1.addVariable("repeat","list");\n';
		} else {
			s+= '	s1.addVariable("repeat","' + this.loop + '");\n';
		}
		s+= '	//s1.addVariable("transition","bgfade");\n';
	} else {
		s+= '	s1.addVariable("file","' + this.url + '");\n';
		s+= '	s1.addVariable("repeat","' + this.loop + '");\n';
		s+= '	s1.addVariable("image","' + this.iurl + '");\n';
	}

	s+= '	s1.addVariable("showdownload","' + this.downloadable + '");\n';
	s+= '	s1.addVariable("link","' + this.url + '");\n';
	s+= '	s1.addParam("allowfullscreen","' + this.fullscreen + '");\n';
	s+= '	s1.addVariable("showdigits","' + this.displayDigits + '");\n';
	s+= '	s1.addVariable("shownavigation","' + this.displayNavigation + '");\n';

	// SET THE COLOR OF THE TOOLBAR
	var colorChoice1 = this.toolcolor
	if (colorChoice1.length > 0) {
		colorChoice1 = colorChoice1.replace("#","0x")
		s+= '	s1.addVariable("backcolor","' + colorChoice1 + '");\n';
	}
	// SET THE COLOR OF THE TOOLBARS TEXT AND BUTTONS
	var colorChoice2 = this.tooltcolor
	if (colorChoice2.length > 0) {
		colorChoice2 = colorChoice2.replace("#","0x")
		s+= '	s1.addVariable("frontcolor","' + colorChoice2 + '");\n';
	}
	//SET COLOR OF ROLLOVER TEXT AND BUTTONS
	var colorChoice3 = this.tooltrcolor
	if (colorChoice3.length > 0) {
		colorChoice3 = colorChoice3.replace("#","0x")
		s+= '	s1.addVariable("lightcolor","' + colorChoice3 + '");\n';
	}
	//SET COLOR OF BACKGROUND
	var colorChoice4 = this.bgcolor
	if (colorChoice4.length > 0) {
		colorChoice4 = colorChoice4.replace("#","0x")
		s+= '	s1.addVariable("screencolor","' + colorChoice4 + '");\n';
	}

	s+= '	s1.addVariable("logo","' + this.wmurl + '");\n';
	if (this.rurl.length > 0) {
		s+= '	s1.addVariable("recommendations","' + this.rurl + '");\n';
	}

	s+= '	//s1.addVariable("largecontrols","true");\n';
	s+= '	//s1.addVariable("bufferlength","3");\n';
	s+= '	//s1.addVariable("audio","http://www.jeroenwijering.com/extras/readme.html");\n';


	
	s+= '	s1.write("player' + randomnumber + '");\n';
	s+= '</script>\n';

	return s;
};















function SelectColor1()
{
	oEditor.FCKDialog.OpenDialog( 'FCKDialog_Color', oEditor.FCKLang.DlgColorTitle, 'dialog/fck_colorselector.html', 400, 330, SelectBackColor, window ) ;
}

function SelectColor2()
{
	oEditor.FCKDialog.OpenDialog( 'FCKDialog_Color', oEditor.FCKLang.DlgColorTitle, 'dialog/fck_colorselector.html', 400, 330, SelectToolColor, window ) ;
}

function SelectColor3()
{
	oEditor.FCKDialog.OpenDialog( 'FCKDialog_Color', oEditor.FCKLang.DlgColorTitle, 'dialog/fck_colorselector.html', 400, 330, SelectToolTextColor, window ) ;
}

function SelectColor4()
{
	oEditor.FCKDialog.OpenDialog( 'FCKDialog_Color', oEditor.FCKLang.DlgColorTitle, 'dialog/fck_colorselector.html', 400, 330, SelectToolTextRColor, window ) ;
}

function SelectBackColor( color )
{
	if ( color && color.length > 0 ) {
		GetE('txtBgColor').value = color ;
		//updatePreview()
	}
}

function SelectToolColor( color )
{
	if ( color && color.length > 0 ) {
		GetE('txtToolbarColor').value = color ;
		//updatePreview()
	}
}

function SelectToolTextColor( color )
{
	if ( color && color.length > 0 ) {
		GetE('txtToolbarTxtColor').value = color ;
		//updatePreview()
	}
}

function SelectToolTextRColor( color )
{
	if ( color && color.length > 0 ) {
		GetE('txtToolbarTxtRColor').value = color ;
		//updatePreview()
	}
}
