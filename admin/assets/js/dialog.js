/*-------------------------------GLOBAL VARIABLES------------------------------------*/

var detect = navigator.userAgent.toLowerCase();
var OS,browser,version,total,thestring;

/*-----------------------------------------------------------------------------------------------*/

//Browser detect script origionally created by Peter Paul Koch at http://www.quirksmode.org/

function getBrowserInfo() {
	if (checkIt('konqueror')) {
		browser = "Konqueror";
		OS = "Linux";
	}
	else if (checkIt('safari')) browser 	= "Safari"
	else if (checkIt('omniweb')) browser 	= "OmniWeb"
	else if (checkIt('opera')) browser 		= "Opera"
	else if (checkIt('webtv')) browser 		= "WebTV";
	else if (checkIt('icab')) browser 		= "iCab"
	else if (checkIt('msie')) browser 		= "Internet Explorer"
	else if (!checkIt('compatible')) {
		browser = "Netscape Navigator"
		version = detect.charAt(8);
	}
	else browser = "An unknown browser";

	if (!version) version = detect.charAt(place + thestring.length);

	if (!OS) {
		if (checkIt('linux')) OS 		= "Linux";
		else if (checkIt('x11')) OS 	= "Unix";
		else if (checkIt('mac')) OS 	= "Mac"
		else if (checkIt('win')) OS 	= "Windows"
		else OS 								= "an unknown operating system";
	}
}

function checkIt(string) {
	place = detect.indexOf(string) + 1;
	thestring = string;
	return place;
}

/*-----------------------------------------------------------------------------------------------*/



//Event.observe(window, 'load', getBrowserInfo, false);
//Event.observe(window, 'unload', Event.unloadCache, false);


var Dialog = {};
Dialog.Box = Class.create();
Object.extend(Dialog.Box.prototype, {
  initialize: function(id) {
    this.createOverlay();

    this.dialog_box = $(id);
    this.dialog_box.show = this.show.bind(this);
    this.dialog_box.hide = this.hide.bind(this);

	this.parent_element = this.dialog_box.parentNode;
	this.dialog_container = document.getElementsByTagName('body')[0];

	var e_dims = Element.getDimensions(this.dialog_box);
    var b_dims = Element.getDimensions(this.overlay);
    this.dialog_box.style.left = ((b_dims.width/2) - (e_dims.width/2)) + 'px';
  },

  createOverlay: function() {
	if($('dialog_overlay')) {
      this.overlay = $('dialog_overlay');
    } else {
      this.overlay = document.createElement('div');
      this.overlay.id = 'dialog_overlay';
      document.body.insertBefore(this.overlay, document.body.childNodes[0]);
    }
  },

  moveDialogBox: function(where) {
    Element.remove(this.dialog_box);
    if(where == 'back')
      this.dialog_box = this.parent_element.appendChild(this.dialog_box);
    else
      this.dialog_box = this.overlay.parentNode.insertBefore(this.dialog_box, this.overlay);
  },

  show: function() {
    this.moveDialogBox('out');
    this.overlay.onclick = this.hide.bind(this);
	
	if (browser == 'Internet Explorer' && version <= 6){
		this.getScroll();
		this.prepareIE('100%', 'hidden');
		this.setScroll(0,0);
		this.selectBoxes('hide');
	}

	this.overlay.style.display='block';
	
	var e_dims = Element.getDimensions(this.dialog_box);
    var b_dims = Element.getDimensions(this.overlay);
    this.dialog_box.style.left = ((b_dims.width/2) - (e_dims.width/2)) + 'px';
	/*if (b_dims.height < e_dims.height + 48) {
		this.dialog_box.style.height = b_dims.height - 84 + 'px';
		this.dialog_box.style.overflow = 'auto';
	}*/
	this.dialog_box.style.display = 'block';
  },

  hide: function() {
    if (browser == "Internet Explorer"){
		this.setScroll(0,this.yPos);
		this.prepareIE("auto", "auto");
		this.selectBoxes('show');
	}
	this.overlay.style.display='none';
    this.dialog_box.style.display = 'none';
    this.dialog_box.style.height = '';
	this.dialog_box.style.overflow = '';
	this.moveDialogBox('back');
	
	/* hack, fix me */
	$('editFormIframe').src = null;
	
	$A(this.dialog_box.getElementsByTagName('input')).each(function(e){if(e.type!='submit'&&e.type!='hidden')e.value=''});
  },
  
  resize: function() {
	if (this.dialog_box.style.overflow != 'auto') {
		var e_dims = Element.getDimensions(this.dialog_box);
		var b_dims = Element.getDimensions(this.overlay);
		if (b_dims.height < e_dims.height + 48) {
			this.dialog_box.style.height = b_dims.height - 84 + 'px';
			this.dialog_box.style.overflow = 'auto';
		}
	}
  },
  
  selectBoxes: function(what) {
    $A(document.getElementsByTagName('select')).each(function(select) {
      Element[what](select);
    });

    if(what == 'hide')
      $A(this.dialog_box.getElementsByTagName('select')).each(function(select){Element.show(select)})
  },
  
  prepareIE: function(height, overflow){
	bod = document.getElementsByTagName('body')[0];
	bod.style.height = height;
	bod.style.overflow = overflow;
	
	htm = document.getElementsByTagName('html')[0];
	htm.style.height = height;
	htm.style.overflow = overflow; 
  },
  
  getScroll: function(){
	if (self.pageYOffset) {
		this.yPos = self.pageYOffset;
	} else if (document.documentElement && document.documentElement.scrollTop){
		this.yPos = document.documentElement.scrollTop; 
	} else if (document.body) {
		this.yPos = document.body.scrollTop;
	}
  },
	
  setScroll: function(x, y){
	window.scrollTo(x, y); 
  }
});

