/* This file is part of Mura CMS. 

	Mura CMS is free software: you can redistribute it and/or modify 
	it under the terms of the GNU General Public License as published by 
	the Free Software Foundation, Version 2 of the License. 

	Mura CMS is distributed in the hope that it will be useful, 
	but WITHOUT ANY WARRANTY; without even the implied warranty of 
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
	GNU General Public License for more details. 

	You should have received a copy of the GNU General Public License 
	along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. 

	Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
	Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.
	
	However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
	or libraries that are released under the GNU Lesser General Public License version 2.1.
	
	In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
	independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
	Mura CMS under the license of your choice, provided that you follow these specific guidelines: 
	
	Your custom code 
	
	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories.
	
	 /admin/
	 /tasks/
	 /config/
	 /requirements/mura/
	 /Application.cfc
	 /index.cfm
	 /MuraProxy.cfc
	
	You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
	under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
	requires distribution of source code.
	
	For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
	modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
	version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS. */
if(window.Prototype) {
    delete Object.prototype.toJSON;
    delete Array.prototype.toJSON;
    delete Hash.prototype.toJSON;
    delete String.prototype.toJSON;
}

if(!this.JSON){JSON=function(){function f(n){return n<10?'0'+n:n;}
Date.prototype.toJSON=function(key){return this.getUTCFullYear()+'-'+
f(this.getUTCMonth()+1)+'-'+
f(this.getUTCDate())+'T'+
f(this.getUTCHours())+':'+
f(this.getUTCMinutes())+':'+
f(this.getUTCSeconds())+'Z';};var cx=/[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,escapeable=/[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,gap,indent,meta={'\b':'\\b','\t':'\\t','\n':'\\n','\f':'\\f','\r':'\\r','"':'\\"','\\':'\\\\'},rep;function quote(string){escapeable.lastIndex=0;return escapeable.test(string)?'"'+string.replace(escapeable,function(a){var c=meta[a];if(typeof c==='string'){return c;}
return'\\u'+('0000'+
(+(a.charCodeAt(0))).toString(16)).slice(-4);})+'"':'"'+string+'"';}
function str(key,holder){var i,k,v,length,mind=gap,partial,value=holder[key];if(value&&typeof value==='object'&&typeof value.toJSON==='function'){value=value.toJSON(key);}
if(typeof rep==='function'){value=rep.call(holder,key,value);}
switch(typeof value){case'string':return quote(value);case'number':return isFinite(value)?String(value):'null';case'boolean':case'null':return String(value);case'object':if(!value){return'null';}
gap+=indent;partial=[];if(typeof value.length==='number'&&!(value.propertyIsEnumerable('length'))){length=value.length;for(i=0;i<length;i+=1){partial[i]=str(i,value)||'null';}
v=partial.length===0?'[]':gap?'[\n'+gap+
partial.join(',\n'+gap)+'\n'+
mind+']':'['+partial.join(',')+']';gap=mind;return v;}
if(rep&&typeof rep==='object'){length=rep.length;for(i=0;i<length;i+=1){k=rep[i];if(typeof k==='string'){v=str(k,value,rep);if(v){partial.push(quote(k)+(gap?': ':':')+v);}}}}else{for(k in value){if(Object.hasOwnProperty.call(value,k)){v=str(k,value,rep);if(v){partial.push(quote(k)+(gap?': ':':')+v);}}}}
v=partial.length===0?'{}':gap?'{\n'+gap+partial.join(',\n'+gap)+'\n'+
mind+'}':'{'+partial.join(',')+'}';gap=mind;return v;}}
return{stringify:function(value,replacer,space){var i;gap='';indent='';if(typeof space==='number'){for(i=0;i<space;i+=1){indent+=' ';}}else if(typeof space==='string'){indent=space;}
rep=replacer;if(replacer&&typeof replacer!=='function'&&(typeof replacer!=='object'||typeof replacer.length!=='number')){throw new Error('JSON.stringify');}
return str('',{'':value});},parse:function(text,reviver){var j;function walk(holder,key){var k,v,value=holder[key];if(value&&typeof value==='object'){for(k in value){if(Object.hasOwnProperty.call(value,k)){v=walk(value,k);if(v!==undefined){value[k]=v;}else{delete value[k];}}}}
return reviver.call(holder,key,value);}
cx.lastIndex=0;if(cx.test(text)){text=text.replace(cx,function(a){return'\\u'+('0000'+
(+(a.charCodeAt(0))).toString(16)).slice(-4);});}
if(/^[\],:{}\s]*$/.test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,'@').replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,']').replace(/(?:^|:|,)(?:\s*\[)+/g,''))){j=eval('('+text+')');return typeof reviver==='function'?walk({'':j},''):j;}
throw new SyntaxError('JSON.parse');}};}();}

(function($){
    $.fn.serializeObject = function(){

        var self = this,
            json = {},
            push_counters = {},
            patterns = {
                "validate": /^[a-zA-Z][a-zA-Z0-9_]*(?:\[(?:\d*|[a-zA-Z0-9_]+)\])*$/,
                "key":      /[a-zA-Z0-9_]+|(?=\[\])/g,
                "push":     /^$/,
                "fixed":    /^\d+$/,
                "named":    /^[a-zA-Z0-9_]+$/
            };


        this.build = function(base, key, value){
            base[key] = value;
            return base;
        };

        this.push_counter = function(key){
            if(push_counters[key] === undefined){
                push_counters[key] = 0;
            }
            return push_counters[key]++;
        };

        $.each($(this).serializeArray(), function(){

            // skip invalid keys
            if(!patterns.validate.test(this.name)){
                return;
            }

            var k,
                keys = this.name.match(patterns.key),
                merge = this.value,
                reverse_key = this.name;

            while((k = keys.pop()) !== undefined){

                // adjust reverse_key
                reverse_key = reverse_key.replace(new RegExp("\\[" + k + "\\]$"), '');

                // push
                if(k.match(patterns.push)){
                    merge = self.build([], self.push_counter(reverse_key), merge);
                }

                // fixed
                else if(k.match(patterns.fixed)){
                    merge = self.build([], k, merge);
                }

                // named
                else if(k.match(patterns.named)){
                    merge = self.build({}, k, merge);
                }
            }

            json = $.extend(true, json, merge);
        });

        return json;
    };
})(jQuery);

$.fn.changeElementType = function(newType) {
    var attrs = {};

    $.each(this[0].attributes, function(idx, attr) {
        attrs[attr.nodeName] = attr.value;
    });

    var newelement = $("<" + newType + "/>", attrs).append($(this).contents());
    this.replaceWith(newelement);
    return newelement;
};

if (!Object.keys) {
  Object.keys = (function () {
    'use strict';
    var hasOwnProperty = Object.prototype.hasOwnProperty,
        hasDontEnumBug = !({toString: null}).propertyIsEnumerable('toString'),
        dontEnums = [
          'toString',
          'toLocaleString',
          'valueOf',
          'hasOwnProperty',
          'isPrototypeOf',
          'propertyIsEnumerable',
          'constructor'
        ],
        dontEnumsLength = dontEnums.length;

    return function (obj) {
      if (typeof obj !== 'object' && (typeof obj !== 'function' || obj === null)) {
        throw new TypeError('Object.keys called on non-object');
      }

      var result = [], prop, i;

      for (prop in obj) {
        if (hasOwnProperty.call(obj, prop)) {
          result.push(prop);
        }
      }

      if (hasDontEnumBug) {
        for (i = 0; i < dontEnumsLength; i++) {
          if (hasOwnProperty.call(obj, dontEnums[i])) {
            result.push(dontEnums[i]);
          }
        }
      }
      return result;
    };
  }());
} 

var initMura=function(config){
	var hashtable={};

	var createCookie=function(name,value,days) {
		if (days) {
			var date = new Date();
			date.setTime(date.getTime()+(days*24*60*60*1000));
			var expires = "; expires="+date.toGMTString();
		}
		else var expires = "";
		document.cookie = name+"="+value+expires+"; path=/";
	}

	var readCookie=function(name) {
		var nameEQ = name + "=";
		var ca = document.cookie.split(';');
		for(var i=0;i < ca.length;i++) {
			var c = ca[i];
			while (c.charAt(0)==' ') c = c.substring(1,c.length);
			if (c.indexOf(nameEQ) == 0) return unescape(c.substring(nameEQ.length,c.length));
		}
		return "";
	}

	var eraseCookie=function(name) {
		createCookie(name,"",-1);
	}

	var addLoadEvent=function(func) {
	   var oldonload = window.onload;
	   if (typeof window.onload != 'function') {
	    window.onload = func;
	   } else {
	    window.onload = function() {
	     oldonload();
	     func();
	    }
	   }
	}
 
	var hash=function(string) {
	  var RotateLeft=function(lValue, iShiftBits) {
	    return (lValue<<iShiftBits) | (lValue>>>(32-iShiftBits));
	  }

	  var AddUnsigned=function(lX,lY) {
	    var lX4,lY4,lX8,lY8,lResult;
	    lX8 = (lX & 0x80000000);
	    lY8 = (lY & 0x80000000);
	    lX4 = (lX & 0x40000000);
	    lY4 = (lY & 0x40000000);
	    lResult = (lX & 0x3FFFFFFF)+(lY & 0x3FFFFFFF);
	    if (lX4 & lY4) {
	      return (lResult ^ 0x80000000 ^ lX8 ^ lY8);
	    }
	    if (lX4 | lY4) {
	      if (lResult & 0x40000000) {
	        return (lResult ^ 0xC0000000 ^ lX8 ^ lY8);
	      } else {
	        return (lResult ^ 0x40000000 ^ lX8 ^ lY8);
	      }
	    } else {
	      return (lResult ^ lX8 ^ lY8);
	    }
	   }

	   var F=function(x,y,z) { return (x & y) | ((~x) & z); }
	   var G=function(x,y,z) { return (x & z) | (y & (~z)); }
	   var H=function(x,y,z) { return (x ^ y ^ z); }
	   var I=function(x,y,z) { return (y ^ (x | (~z))); }
	 
	   var FF=function(a,b,c,d,x,s,ac) {
	    a = AddUnsigned(a, AddUnsigned(AddUnsigned(F(b, c, d), x), ac));
	    return AddUnsigned(RotateLeft(a, s), b);
	  };

	  var GG=function(a,b,c,d,x,s,ac) {
	    a = AddUnsigned(a, AddUnsigned(AddUnsigned(G(b, c, d), x), ac));
	    return AddUnsigned(RotateLeft(a, s), b);
	  };

	  var HH=function(a,b,c,d,x,s,ac) {
	    a = AddUnsigned(a, AddUnsigned(AddUnsigned(H(b, c, d), x), ac));
	    return AddUnsigned(RotateLeft(a, s), b);
	  };

	  var II=function(a,b,c,d,x,s,ac) {
	    a = AddUnsigned(a, AddUnsigned(AddUnsigned(I(b, c, d), x), ac));
	    return AddUnsigned(RotateLeft(a, s), b);
	  };

	  var ConvertToWordArray=function(string) {
	    var lWordCount;
	    var lMessageLength = string.length;
	    var lNumberOfWords_temp1=lMessageLength + 8;
	    var lNumberOfWords_temp2=(lNumberOfWords_temp1-(lNumberOfWords_temp1 % 64))/64;
	    var lNumberOfWords = (lNumberOfWords_temp2+1)*16;
	    var lWordArray=Array(lNumberOfWords-1);
	    var lBytePosition = 0;
	    var lByteCount = 0;
	    while ( lByteCount < lMessageLength ) {
	      lWordCount = (lByteCount-(lByteCount % 4))/4;
	      lBytePosition = (lByteCount % 4)*8;
	      lWordArray[lWordCount] = (lWordArray[lWordCount] | (string.charCodeAt(lByteCount)<<lBytePosition));
	      lByteCount++;
	    }
	    lWordCount = (lByteCount-(lByteCount % 4))/4;
	    lBytePosition = (lByteCount % 4)*8;
	    lWordArray[lWordCount] = lWordArray[lWordCount] | (0x80<<lBytePosition);
	    lWordArray[lNumberOfWords-2] = lMessageLength<<3;
	    lWordArray[lNumberOfWords-1] = lMessageLength>>>29;
	    return lWordArray;
	  };

	  var WordToHex=function(lValue) {
	    var WordToHexValue="",WordToHexValue_temp="",lByte,lCount;
	    for (lCount = 0;lCount<=3;lCount++) {
	      lByte = (lValue>>>(lCount*8)) & 255;
	      WordToHexValue_temp = "0" + lByte.toString(16);
	      WordToHexValue = WordToHexValue + WordToHexValue_temp.substr(WordToHexValue_temp.length-2,2);
	    }
	    return WordToHexValue;
	  };

	  var Utf8Encode=function(string) {
	    string = string.replace(/\r\n/g,"\n");
	    var utftext = "";

	    for (var n = 0; n < string.length; n++) {
	      var c = string.charCodeAt(n);

	      if (c < 128) {
	        utftext += String.fromCharCode(c);
	      }
	      else if((c > 127) && (c < 2048)) {
	        utftext += String.fromCharCode((c >> 6) | 192);
	        utftext += String.fromCharCode((c & 63) | 128);
	      }
	      else {
	        utftext += String.fromCharCode((c >> 12) | 224);
	        utftext += String.fromCharCode(((c >> 6) & 63) | 128);
	        utftext += String.fromCharCode((c & 63) | 128);
	      }
	    }

	    return utftext;
	  };

	  var x=Array();
	  var k,AA,BB,CC,DD,a,b,c,d;
	  var S11=7, S12=12, S13=17, S14=22;
	  var S21=5, S22=9 , S23=14, S24=20;
	  var S31=4, S32=11, S33=16, S34=23;
	  var S41=6, S42=10, S43=15, S44=21;

	  string = Utf8Encode(string);

	  x = ConvertToWordArray(string);

	  a = 0x67452301; b = 0xEFCDAB89; c = 0x98BADCFE; d = 0x10325476;

	  for (k=0;k<x.length;k+=16) {
	    AA=a; BB=b; CC=c; DD=d;
	    a=FF(a,b,c,d,x[k+0], S11,0xD76AA478);
	    d=FF(d,a,b,c,x[k+1], S12,0xE8C7B756);
	    c=FF(c,d,a,b,x[k+2], S13,0x242070DB);
	    b=FF(b,c,d,a,x[k+3], S14,0xC1BDCEEE);
	    a=FF(a,b,c,d,x[k+4], S11,0xF57C0FAF);
	    d=FF(d,a,b,c,x[k+5], S12,0x4787C62A);
	    c=FF(c,d,a,b,x[k+6], S13,0xA8304613);
	    b=FF(b,c,d,a,x[k+7], S14,0xFD469501);
	    a=FF(a,b,c,d,x[k+8], S11,0x698098D8);
	    d=FF(d,a,b,c,x[k+9], S12,0x8B44F7AF);
	    c=FF(c,d,a,b,x[k+10],S13,0xFFFF5BB1);
	    b=FF(b,c,d,a,x[k+11],S14,0x895CD7BE);
	    a=FF(a,b,c,d,x[k+12],S11,0x6B901122);
	    d=FF(d,a,b,c,x[k+13],S12,0xFD987193);
	    c=FF(c,d,a,b,x[k+14],S13,0xA679438E);
	    b=FF(b,c,d,a,x[k+15],S14,0x49B40821);
	    a=GG(a,b,c,d,x[k+1], S21,0xF61E2562);
	    d=GG(d,a,b,c,x[k+6], S22,0xC040B340);
	    c=GG(c,d,a,b,x[k+11],S23,0x265E5A51);
	    b=GG(b,c,d,a,x[k+0], S24,0xE9B6C7AA);
	    a=GG(a,b,c,d,x[k+5], S21,0xD62F105D);
	    d=GG(d,a,b,c,x[k+10],S22,0x2441453);
	    c=GG(c,d,a,b,x[k+15],S23,0xD8A1E681);
	    b=GG(b,c,d,a,x[k+4], S24,0xE7D3FBC8);
	    a=GG(a,b,c,d,x[k+9], S21,0x21E1CDE6);
	    d=GG(d,a,b,c,x[k+14],S22,0xC33707D6);
	    c=GG(c,d,a,b,x[k+3], S23,0xF4D50D87);
	    b=GG(b,c,d,a,x[k+8], S24,0x455A14ED);
	    a=GG(a,b,c,d,x[k+13],S21,0xA9E3E905);
	    d=GG(d,a,b,c,x[k+2], S22,0xFCEFA3F8);
	    c=GG(c,d,a,b,x[k+7], S23,0x676F02D9);
	    b=GG(b,c,d,a,x[k+12],S24,0x8D2A4C8A);
	    a=HH(a,b,c,d,x[k+5], S31,0xFFFA3942);
	    d=HH(d,a,b,c,x[k+8], S32,0x8771F681);
	    c=HH(c,d,a,b,x[k+11],S33,0x6D9D6122);
	    b=HH(b,c,d,a,x[k+14],S34,0xFDE5380C);
	    a=HH(a,b,c,d,x[k+1], S31,0xA4BEEA44);
	    d=HH(d,a,b,c,x[k+4], S32,0x4BDECFA9);
	    c=HH(c,d,a,b,x[k+7], S33,0xF6BB4B60);
	    b=HH(b,c,d,a,x[k+10],S34,0xBEBFBC70);
	    a=HH(a,b,c,d,x[k+13],S31,0x289B7EC6);
	    d=HH(d,a,b,c,x[k+0], S32,0xEAA127FA);
	    c=HH(c,d,a,b,x[k+3], S33,0xD4EF3085);
	    b=HH(b,c,d,a,x[k+6], S34,0x4881D05);
	    a=HH(a,b,c,d,x[k+9], S31,0xD9D4D039);
	    d=HH(d,a,b,c,x[k+12],S32,0xE6DB99E5);
	    c=HH(c,d,a,b,x[k+15],S33,0x1FA27CF8);
	    b=HH(b,c,d,a,x[k+2], S34,0xC4AC5665);
	    a=II(a,b,c,d,x[k+0], S41,0xF4292244);
	    d=II(d,a,b,c,x[k+7], S42,0x432AFF97);
	    c=II(c,d,a,b,x[k+14],S43,0xAB9423A7);
	    b=II(b,c,d,a,x[k+5], S44,0xFC93A039);
	    a=II(a,b,c,d,x[k+12],S41,0x655B59C3);
	    d=II(d,a,b,c,x[k+3], S42,0x8F0CCC92);
	    c=II(c,d,a,b,x[k+10],S43,0xFFEFF47D);
	    b=II(b,c,d,a,x[k+1], S44,0x85845DD1);
	    a=II(a,b,c,d,x[k+8], S41,0x6FA87E4F);
	    d=II(d,a,b,c,x[k+15],S42,0xFE2CE6E0);
	    c=II(c,d,a,b,x[k+6], S43,0xA3014314);
	    b=II(b,c,d,a,x[k+13],S44,0x4E0811A1);
	    a=II(a,b,c,d,x[k+4], S41,0xF7537E82);
	    d=II(d,a,b,c,x[k+11],S42,0xBD3AF235);
	    c=II(c,d,a,b,x[k+2], S43,0x2AD7D2BB);
	    b=II(b,c,d,a,x[k+9], S44,0xEB86D391);
	    a=AddUnsigned(a,AA);
	    b=AddUnsigned(b,BB);
	    c=AddUnsigned(c,CC);
	    d=AddUnsigned(d,DD);
	  }

	  var temp = WordToHex(a)+WordToHex(b)+WordToHex(c)+WordToHex(d);

	  return temp.toLowerCase();
	}

	var getScript=function(script,callback){
		var hashcode=hash(script);
    	
    	if(typeof hashtable[hashcode] == 'undefined'){
			$.getScript(script, function(){
    			hashtable[hashcode]=true;
    			callback();
    		}); 
    	} else {
    		callback();
    	}
	}

	var getScripts=function(scripts, callback) {
	    var progress = 0;
	    var internalCallback = function () {
	        if (++progress == scripts.length) { callback(); }
	    };

	    for(var s=0;s < scripts.length;s++){
	    	getScript(scripts[s],internalCallback);
	    }
	};

	var noSpam=function(user,domain) {
		locationstring = "mailto:" + user + "@" + domain;
		window.location = locationstring;
	}

	var setHTMLEditor=function(el) {
		getScripts(
			[
				config.context + '/requirements/ckeditor/ckeditor.js',
				config.context + '/requirements/ckeditor/adapters/jquery.js'
			],
				function(){
					initEditor();
				}
		);

		var initEditor=function(){
			var instance=CKEDITOR.instances[$(el).attr('id')];
			var conf={height:200,width:'70%'};
			
			if($(el).data('editorconfig')){
				$.extend(conf,$(el).data('editorconfig'));
			}
				
			if (instance) {
				CKEDITOR.remove(instance);
			} 

			$('#' + $(el).attr('id')).ckeditor(getHTMLEditorConfig(conf),htmlEditorOnComplete);	

			
		}

		var htmlEditorOnComplete=function( editorInstance ) { 		
			var instance=jQuery(editorInstance).ckeditorGet();
			instance.resetDirty();
			var totalIntances=CKEDITOR.instances;
			//CKFinder.setupCKEditor( instance, { basePath : context + '/requirements/ckfinder/', rememberLastFolder : false } ) ;	
		}

		var getHTMLEditorConfig=function(customConfig) {
			var attrname='';
			var htmlEditorConfig={
				toolbar:'htmlEditor',
				customConfig : 'config.js.cfm'
				}
			
			if(typeof(customConfig)== 'object'){	
				$.extend(htmlEditorConfig,customConfig);
			}
			
			return htmlEditorConfig;
		}

	}

	var pressed_keys='';

	var loginCheck=function(key){
		
		if(key==27){
			pressed_keys = key.toString();
			
		} else if(key == 76){
			pressed_keys = pressed_keys + "" + key.toString();
		}

		if (key !=27  && key !=76) {
		pressed_keys = "";
		}

		if (pressed_keys != "") {
		
		var aux = pressed_keys;
		
		if (aux.indexOf('2776') != -1 && location.search.indexOf("display=login") == -1) {
			
			if(typeof(config.loginURL) == "undefined"){
				lu="?display=login";
			} else{
				lu=config.loginURL;
			}
			
			if(typeof(config.returnURL) == "undefined"){
				ru=location.href;
			} else{
				ru=config.returnURL;
			}
			pressed_keys = "";
			
			lu = new String(lu);
			if(lu.indexOf('?') != -1){
				location.href=lu + "&returnUrl=" + escape(ru);
			} else {
				location.href=lu + "?returnUrl=" + escape(ru);
			}
		}
	    }
	}

	var isInteger=function(s){
		var i;
	    for (i = 0; i < s.length; i++){   
	        // Check that current character is number.
	        var c = s.charAt(i);
	        if (((c < "0") || (c > "9"))) return false;
	    }
	    // All characters are numbers.
	    return true;
	}

	var createDate=function(str){
						
		var valueArray = str.split("/");
					
		var mon = valueArray[0];
		var dt = valueArray[1];
		var yr = valueArray[2];
				
		var date = new Date(yr, mon-1, dt);
						
		if(!isNaN(date.getMonth())){
			return date;
		} else {
			return new Date();	
		}
							
	}
					
	var dateToString=function(date){
		var mon   = date.getMonth()+1;
		var dt  = date.getDate();
		var yr   = date.getFullYear();
				
		if(mon < 10){ mon="0" + mon;}
		if(dt < 10){ dt="0" + dt;}
						
						
		return mon + "/" + dt + "/20" + new String(yr).substring(2,4);			
	}
					

	var stripCharsInBag=function(s, bag){
		var i;
	    var returnString = "";
	    // Search through string's characters one by one.
	    // If character is not in bag, append to returnString.
	    for (i = 0; i < s.length; i++){   
	        var c = s.charAt(i);
	        if (bag.indexOf(c) == -1) returnString += c;
	    }
	    return returnString;
	}

	var daysInFebruary=function(year){
		// February has 29 days in any year evenly divisible by four,
	    // EXCEPT for centurial years which are not also divisible by 400.
	    return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
	}

	var DaysArray=function(n) {
		for (var i = 1; i <= n; i++) {
			this[i] = 31
			if (i==4 || i==6 || i==9 || i==11) {this[i] = 30}
			if (i==2) {this[i] = 29}
	   } 
	   return this
	}

	var isDate=function(dtStr,fldName){
		var daysInMonth = DaysArray(12);
		var dtArray= dtStr.split(config.dtCh);
		
		if (dtArray.length != 3){
			//alert("The date format for the "+fldName+" field should be : short")
			return false
		}
		var strMonth=dtArray[config.dtFormat[0]];
		var strDay=dtArray[config.dtFormat[1]];
		var strYear=dtArray[config.dtFormat[2]];
		
		/*
		if(strYear.length == 2){
			strYear="20" + strYear;
		}
		*/
		strYr=strYear;
		
		if (strDay.charAt(0)=="0" && strDay.length>1) strDay=strDay.substring(1)
		if (strMonth.charAt(0)=="0" && strMonth.length>1) strMonth=strMonth.substring(1)
		for (var i = 1; i <= 3; i++) {
			if (strYr.charAt(0)=="0" && strYr.length>1) strYr=strYr.substring(1)
		}
		
		month=parseInt(strMonth)
		day=parseInt(strDay)
		year=parseInt(strYr)
			
		if (month<1 || month>12){
			//alert("Please enter a valid month in the "+fldName+" field")
			return false
		}
		if (day<1 || day>31 || (month==2 && day>daysInFebruary(year)) || day > daysInMonth[month]){
			//alert("Please enter a valid day  in the "+fldName+" field")
			return false
		}
		if (strYear.length != 4 || year==0 || year<config.minYear || year>config.maxYear){
			//alert("Please enter a valid 4 digit year between "+config.minYear+" and "+config.maxYear +" in the "+fldName+" field")
			return false
		}
		if (isInteger(stripCharsInBag(dtStr, config.dtCh))==false){
			//alert("Please enter a valid date in the "+fldName+" field")
			return false
		}

		return true;
	}

	var isEmail=function(cur){
				var string1=cur
				if (string1.indexOf("@") == -1 || string1.indexOf(".") == -1)
				{
				return false;
				}else{
				return true;}

	}

	var createUUID= function() {
	    var s = [], itoh = '0123456789ABCDEF';
	   
	    // Make array of random hex digits. The UUID only has 32 digits in it, but we
	    // allocate an extra items to make room for the '-'s we'll be inserting.
	    for (var i = 0; i < 35; i++) s[i] = Math.floor(Math.random()*0x10);
	   
	    // Conform to RFC-4122, section 4.4
	    s[14] = 4;  // Set 4 high bits of time_high field to version
	    s[19] = (s[19] & 0x3) | 0x8;  // Specify 2 high bits of clock sequence
	   
	    // Convert to hex chars
	    for (var i = 0; i < 36; i++) s[i] = itoh[s[i]];
	   
	    // Insert '-'s
	    s[8] = s[13] = s[18] = '-';
	   
	    return s.join('');
  	}

	var validateForm=function(frm,customaction) {

			var getValidationFieldName=function(theField){
				if(theField.getAttribute('data-label')!=undefined){
					return theField.getAttribute('data-label');
				}else if(theField.getAttribute('label')!=undefined){
					return theField.getAttribute('label');
				}else{
					return theField.getAttribute('name');
				}
			}

			var getValidationIsRequired=function(theField){
				if(theField.getAttribute('data-required')!=undefined){
					return (theField.getAttribute('data-required').toLowerCase() =='true');
				}else if(theField.getAttribute('required')!=undefined){
					return (theField.getAttribute('required').toLowerCase() =='true');
				}else{
					return false;
				}
			}

			var getValidationMessage=function(theField, defaultMessage){
				if(theField.getAttribute('data-message') != undefined){
					return theField.getAttribute('data-message');
				} else if(theField.getAttribute('message') != undefined){
					return theField.getAttribute('message') ;
				} else {
					return getValidationFieldName(theField).toUpperCase() + defaultMessage;
				}	
			}

			var getValidationType=function(theField){
				if(theField.getAttribute('data-validate')!=undefined){
					return theField.getAttribute('data-validate').toUpperCase();
				}else if(theField.getAttribute('validate')!=undefined){
					return theField.getAttribute('validate').toUpperCase();
				}else{
					return '';
				}
			}

			var hasValidationMatchField=function(theField){
				if(theField.getAttribute('data-matchfield')!=undefined && theField.getAttribute('data-matchfield') != ''){
					return true;
				}else if(theField.getAttribute('matchfield')!=undefined && theField.getAttribute('matchfield') != ''){
					return true;
				}else{
					return false;
				}
			}

			var getValidationMatchField=function (theField){
				if(theField.getAttribute('data-matchfield')!=undefined){
					return theField.getAttribute('data-matchfield');
				}else if(theField.getAttribute('matchfield')!=undefined){
					return theField.getAttribute('matchfield');
				}else{
					return '';
				}
			}

			var hasValidationRegex=function(theField){
				if(theField.value != undefined){
					if(theField.getAttribute('data-regex')!=undefined && theField.getAttribute('data-regex') != ''){
						return true;
					}else if(theField.getAttribute('regex')!=undefined && theField.getAttribute('regex') != ''){
						return true;
					}
				}else{
					return false;
				}
			}

			var getValidationRegex=function(theField){
				if(theField.getAttribute('data-regex')!=undefined){
					return theField.getAttribute('data-regex');
				}else if(theField.getAttribute('regex')!=undefined){
					return theField.getAttribute('regex');
				}else{
					return '';
				}
			}

			var theForm=frm;
			var errors="";
			var setFocus=0;
			var started=false;
			var startAt;
			var firstErrorNode;
			var validationType='';
			var validations={properties:{}};
			var frmInputs = theForm.getElementsByTagName("input");	
			var rules=new Array();
			var data={};
			var $customaction=customaction;
			
			for (var f=0; f < frmInputs.length; f++) {
			 var theField=frmInputs[f];
			 validationType=getValidationType(theField).toUpperCase();
			
				rules=new Array();
		
				if(theField.style.display==""){
					if(getValidationIsRequired(theField))
						{	
							rules.push({
								required: true,
								message: getValidationMessage(theField,' is required.')
							});
							
							 			
						}
					if(validationType != ''){
							
						if(validationType=='EMAIL' && theField.value != '')
						{	
							rules.push({
								dataType: 'EMAIL',
								message: getValidationMessage(theField,' must be a valid email address.')
							});
							
									
						}
		
						else if(validationType=='NUMERIC' && theField.value != '')
						{	
							rules.push({
								dataType: 'NUMERIC',
								message: getValidationMessage(theField,' must be numeric.')
							});
										
						}
						
						else if(validationType=='REGEX' && theField.value !='' && hasValidationRegex(theField))
						{	
							rules.push({
								regex: getValidationRegex(theField),
								message: getValidationMessage(theField,' is not valid.')
							});
											
						}
						
						else if(validationType=='MATCH' 
								&& hasValidationMatchField(theField) && theField.value != theForm[getValidationMatchField(theField)].value)
						{	
							rules.push({
								eq: theForm[getValidationMatchField(theField)].value,
								message: getValidationMessage(theField, ' must match' + getValidationMatchField(theField) + '.' )
							});
										
						}
						
						else if(validationType=='DATE' && theField.value != '')
						{
							rules.push({
								dataType: 'DATE',
								message: getValidationMessage(theField, ' must be a valid date [MM/DD/YYYY].' )
							});
							 
						}
					}
					
					if(rules.length){
						validations.properties[theField.getAttribute('name')]=rules;
						data[theField.getAttribute('name')]=theField.value;
					}
				}
			}
			var frmTextareas = theForm.getElementsByTagName("textarea");	
			for (f=0; f < frmTextareas.length; f++) {
			
				
					theField=frmTextareas[f];
					validationType=getValidationType(theField);

					rules=new Array();
					 
					if(theField.style.display=="" && getValidationIsRequired(theField))
					{	
						rules.push({
							required: true,
							message: getValidationMessage(theField, ' is required.' )
						});
						
					}	

					else if(validationType != ''){
						if(validationType=='REGEX' && theField.value !='' && hasValidationRegex(theField))
						{	
							rules.push({
								regex: getValidationRegex(theField),
								message: getValidationMessage(theField, ' is not valid.' )
							});
											
						}
					}

					if(rules.length){
						validations.properties[theField.getAttribute('name')]=rules;
						data[theField.getAttribute('name')]=theField.value;
					}
			}
			
			var frmSelects = theForm.getElementsByTagName("select");	
			for (f=0; f < frmSelects.length; f++) {
					theField=frmSelects[f];
					validationType=getValidationType(theField);

					rules=new Array();

					if(theField.style.display=="" && getValidationIsRequired(theField))
					{	
						rules.push({
							required: true,
							message: getValidationMessage(theField, ' is required.' )
						});
					}

					if(rules.length){
						validations.properties[theField.getAttribute('name')]=rules;
						data[theField.getAttribute('name')]=theField.value;
					}	
			}

			try{
				//alert(JSON.stringify(validations));

				jQuery.ajax(
					{
						type: 'post',
						url: config.apiEndpoint + '?method=validate',
						dataType: 'text',
						data: {
								data: escape(JSON.stringify(data)),
								validations: escape(JSON.stringify(validations)),
								version: 4
							},
						success: function(resp) {
	 				 		var _data=eval('(' + resp + ')');
	 				 		
	 				 		data=_data.data;
	 				 		
	 				 		if(jQuery.isEmptyObject(data)){
	 				 			if(typeof $customaction == 'function'){
	 				 				$customaction(theForm);
	 				 				return false;
	 				 			} else {
	 				 				theForm.submit();
	 				 			}
	 				 		} else {
		 				 		var msg='';
		 				 		for(var e in data){
		 				 			msg=msg + data[e] + '\n';
		 				 		}

		 				 		alert(msg);
	 				 		}
						},
						error: function(resp) {
	 				 		
	 				 		alert(JSON.stringify(resp));
						}

					}		 
				);
			} 
			catch(err){ 
				console.log(err);

			}

		return false;
			
	}

	var setLowerCaseKeys=function (obj) {
		$.map(obj, function(value, key) {
	   
		   if (key !== key.toLowerCase()) { // might already be in its lower case version
		        obj[key.toLowerCase()] = obj[key] // swap the value to a new lower case key
		        delete obj[key] // delete the old key
		    }
		   	if(typeof obj[key.toLowerCase()] == 'object'){
		   		setLowerCaseKeys(obj[key.toLowerCase()]);
		   	}
		});

		return (obj);
	}


	if(!config.apiEndpoint){
		config.apiEndpoint=config.context + '/index.cfm/_api/ajax/v1/';
	}

	var processAsyncObject=function(frm){
		var self=frm;

		var handleResponse=function(resp){
 			
 			if('redirect' in resp.data){
	    		location.href=resp.data.redirect;
	    	} else {
	    		$(self).html(resp.data.html);

	 			if($(self).data('objectscript')){
	 				getScript(
						$(self).data('objectscript'),
						function(){
							if($(self).data('objectinit')){
					    		var params=$(self).data('objectparams') ?  eval('('+ unescape($(self).data('objectparams')) + ')' ) : {};
					   			eval('(' + $(self).data('objectinit') + '(params)' + ')');
				    		}
						}
					);
	 			} else if($(self).data('objectinit')){
	 				var params=$(self).data('objectparams') ?  eval('('+ unescape($(self).data('objectparams')) + ')' ) : {};
				    eval('(' + $(self).data('objectinit') + '(params)' + ')');
				}

				$(self).find( ".mura-async-object" ).each( function(){
					processAsyncObject(this);
				});

				$(self).find( ".htmlEditor" ).each( function() {
					setHTMLEditor(this);
				});

				if($(self).find( ".ffp_mm" ).length){
					getScript(config.context + '/requirements/cfformprotect/js/cffp.js');
				}

				if($(self).find( ".g-recaptcha" ).length){
					getScript('https://www.google.com/recaptcha/api.js?hl=' + config.reCAPTCHALanguage);
				}

				$(self).find('form').each(function(){
	 				$(this).removeAttr('onsubmit');
	 				$(this).on('submit',function(){return validateFormAjax(document.getElementById($(this).attr('id')));});
	 			});

	 			if(typeof resizeEditableObject == 'function' ){
	 				$(self).closest('.editableObject').each(function(){ 
	 					resizeEditableObject(this);
	 				});	

	 				$(self).find(".frontEndToolsModal").each(
						function(){
							jQuery(this).click(function(event){
								event.preventDefault();
								openFrontEndToolsModal(this);
							}
						);
					});

					$(self).find(".editableObject").each(function(){
						resizeEditableObject(this);
					});
	 			}
	 		}
		};

		var validateFormAjax=function(frm) {

			if(FormData && $(frm).attr('enctype')=='multipart/form-data'){
				var data=new FormData(frm);
				var checkdata=setLowerCaseKeys($(frm).serializeObject());
				var keys=['contentid','contenthistid','siteid','object','objectid'];

				for(var k in keys){
					if(!(keys[k] in checkdata)){
						data.append(keys[k], $(self).data(keys[k]));
					}
				}

				if('objectparams' in checkdata){
					data.append('objectparams2', escape(JSON.stringify($(self).data('objectparams'))));
				}

				if('nocache' in checkdata){
					data.append('nocache',1);
				}
				
				var postconfig={
				      url:  config.apiEndpoint + '?method=processAsyncObject',
				      type: 'POST',
				      data: data,
				      processData: false,
				      contentType: false,
				      dataType: 'JSON'
				    } 
			
			} else {
				var data=$.extend(setLowerCaseKeys($( frm ).serializeObject()),setLowerCaseKeys($(self).data()),{siteid:config.siteid,contentid:config.contentid,contenthistid:config.contenthistid,nocache:1});

				if('objectparams' in data){
					data['objectparams']= escape(JSON.stringify(data['objectparams']));
				}

				var postconfig={
				      url:  config.apiEndpoint + '?method=processAsyncObject',
				      type: 'POST',
				      data: data,
				      dataType: 'JSON'
				    } 
			}

			validateForm(frm,
				function(frm){
					$(self).html(config.preloaderMarkup);
					$.ajax(postconfig).then(handleResponse);
				}
			);

			return false;
			
		}

		var data=$.extend($(self).data(),{siteid:config.siteid,contentid:config.contentid,contenthistid:config.contenthistid,nocache:config.nocache});
		
		if('objectparams' in data){
			data['objectparams']= escape(JSON.stringify(data['objectparams']));
		}

		$(self).html(config.preloaderMarkup);

		$.ajax({
	      url:  config.apiEndpoint + '?method=processAsyncObject',
	      type: 'GET',
	      data: data,
	      dataType: 'JSON'
		}).then(handleResponse);
	}

	$.extend(config,{
		vaildateForm:validateForm,
		processAsyncObject:processAsyncObject,
		setLowerCaseKeys:setLowerCaseKeys,
		noSpam:noSpam,
		getScripts:getScripts,
		getScript:getScript
	});

	$.extend(window,{
		mura:config,
		validateForm:validateForm,
		createCookie:createCookie
	});

	
	$(function(){
		$( ".mura-async-object" ).each( function(){
			processAsyncObject(this);
		});


		$(document).on('keydown',function(event){
			loginCheck(event.which);
		});

		$(document).trigger('muraReady');
	});

};