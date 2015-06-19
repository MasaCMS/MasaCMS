;(function(window){
	
	var evalScripts=function(el) {
	    if(typeof el=='string'){
	    	el=parseHTML(el);
	    }

	    var scripts = [];
	    var ret = el.childNodes;
			    
	    for ( var i = 0; ret[i]; i++ ) {
	      if ( scripts && nodeName( ret[i], "script" ) && (!ret[i].type || ret[i].type.toLowerCase() === "text/javascript") ) {
	            scripts.push( ret[i].parentNode ? ret[i].parentNode.removeChild( ret[i] ) : ret[i] );
	        } else if(ret[i].nodeType==1){
	        	evalScripts(ret[i]);
	        }
	    }

	    for(script in scripts){
	      evalScript(scripts[script]);
	    }
	}

	var nodeName=function( el, name ) {
	    return el.nodeName && el.nodeName.toUpperCase() === name.toUpperCase();
	}

  	var evalScript=function(el) {
	    var data = ( el.text || el.textContent || el.innerHTML || "" );

	    var head = document.getElementsByTagName("head")[0] || document.documentElement,
	    script = document.createElement("script");
	    script.type = "text/javascript";
	    script.appendChild( document.createTextNode( data ) );
	    head.insertBefore( script, head.firstChild );
	    head.removeChild( script );

	    if ( el.parentNode ) {
	        el.parentNode.removeChild( el );
	    }
	}

	var changeElementType=function(el, to) {
		var newEl = document.createElement(to);

		// Try to copy attributes across
		for (var i = 0, a = el.attributes, n = a.length; i < n; ++i)
		oldEl.setAttribute(a[i].name, a[i].value);

		// Try to move children across
		while (el.hasChildNodes())
		newEl.appendChild(el.firstChild);

		// Replace the old element with the new one
		el.parentNode.replaceChild(newEl, oldEl);

		// Return the new element, for good measure.
		return newEl;
	}

	var ready=function(fn) {
	  if(document.readyState != 'loading'){
	    fn.call(document);
	  } else {
	    document.addEventListener('DOMContentLoaded',function(event){
			fn.call(event.target,event);
		});
	  }
	}

	var get=function(url,data){
		return new Promise(function(resolve, reject) {
			return ajax({
					type:'get',
					url:url,
					data:data,
					success:function(resp){
						resolve(resp);
					},
					error:function(resp){
						reject(resp);
					}
				}
			);	
 		});
		
	}

	var post=function(url,data){
		return new Promise(function(resolve, reject) {
			return ajax({
					type:'post',
					url:url,
					data:data,
					success:function(resp){
						resolve(resp);
					},
					error:function(resp){
						reject(resp);
					}
				}
			);	
 		});
		
	}

	var ajax=function(params){
		
		//params=params || {};

		if(!('type' in params)){
			params.type='GET';
		}

		if(!('success' in params)){
			params.success=function(){};
		}

		if(!('error' in params)){
			params.error=function(){};
		}

		if(!('data' in params)){
			params.data={};
		}

		if(!('xhrFields' in params)){
			params.xhrFields={ withCredentials: true };
		}

		if(!('crossDomain' in params)){
			params.crossDomain=true;
		}

		if(!('async' in params)){
			params.async=true;
		}

		if(!('headers' in params)){
			params.headers={};
		}

		var request = new XMLHttpRequest();


		if (params.crossDomain 
			&& !("withCredentials" in request) 
			&& typeof XDomainRequest != "undefined") {

		    // Check if the XMLHttpRequest object has a "withCredentials" property.
		    // "withCredentials" only exists on XMLHTTPRequest2 objects.
		    // Otherwise, check if XDomainRequest.
		    // XDomainRequest only exists in IE, and is IE's way of making CORS requests.
		    request =new XDomainRequest();

		} 
		
		request.onload = function() {
		  if (request.status >= 200 && request.status < 400) {
		  
		    try{
		    	var data = JSON.parse(request.responseText);
		    } catch(e){
		    	var data = request.responseText;
		    }

		    params.success(data);
		  } else {
		   	params.error(request);
		  }
		}

		request.onerror = params.onerror;			

		if(params.type.toLowerCase()=='post'){
			request.open(params.type.toUpperCase(), params.url, params.async);

			for(var p in params.xhrFields){
				if(p in request){
					request[p]=params.xhrFields[p];
				}
			}

			for(var h in params.headers){
				request.setRequestHeader(p,params.headers[h]);		
			}

			//if(params.data.constructor.name == 'FormData'){
			if(params.data instanceof FormData){
				request.send(params.data);
			} else {
				request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
				var query = [];

			    for (var key in params.data) {
			        query.push(encodeURIComponent(key) + '=' + encodeURIComponent(params.data[key]));
			    }

			    query=query.join('&');

				request.send(query);
			}
		} else {
			if(params.url.indexOf('?') == -1){
				params.url += '?';
			}

			var query = [];

		    for (var key in params.data) {
		        query.push(encodeURIComponent(key) + '=' + encodeURIComponent(params.data[key]));
		    }

		    query=query.join('&');
			
			request.open(params.type.toUpperCase(), params.url + '&' +  query, params.async);

			for(var p in params.xhrFields){
				if(p in request){
					request[p]=params.xhrFields[p];
				}
			}

			for(var h in params.headers){
				request.setRequestHeader(p,params.headers[h]);		
			}

			request.send();
		}

	}

	var each=function(selector,fn){
		select(selector).each(fn);
	}

	var on=function(el,eventName,fn){
		if(eventName=='ready'){
			ready(fn);
		} else {
			if(typeof el.addEventListener == 'function'){
				el.addEventListener(
					eventName,
					function(event){
						fn.call(el,event);
					},
					true
				);
			}
		}
	}

	var off=function(el,eventName){
		el.removeEventListener(eventName);
	}

	var parseSelection=function(selector){
		if(typeof selector == 'object' && Array.isArray(selector)){
			var selection=selector;
		} else if(typeof selector== 'string'){
			var selection=nodeListToArray(window.mura.Sizzle(selector));
		} else {
			//var classname=selector.constructor.name;
			//if(classname=='NodeList' || classname=='HTMLCollection'){
			//if(typeof selector.length != 'undefined'){
			if(selector instanceof NodeList || selector instanceof HTMLCollection){
				var selection=nodeListToArray(selector);
			} else {
				var selection=[selector];
			}
		}

		if(typeof selection.length == 'undefined'){
			selection=[];
		}

		return selection;
	}

	var isEmptyObject=function(obj){
		return (typeof obj != 'object' || Object.keys(obj).length == 0);
	}

	var filter=function(selector,fn){
		return select(parseSelection(selector)).filter(fn);
	}

	var nodeListToArray=function(nodeList){
		var arr = [];
		for(var i = nodeList.length; i--; arr.unshift(nodeList[i]));
		return arr;
	}

	var select=function(selector){
		return new MuraSelectionWrapper(parseSelection(selector),selector);
	}


	/**
	 * Fire an event handler to the specified node. Event handlers can detect that the event was fired programatically
	 * by testing for a 'synthetic=true' property on the event object
	 * @param {HTMLNode} node The node to fire the event handler on.
	 * @param {String} eventName The name of the event without the "on" (e.g., "focus")
	 */
	var trigger=function(el, eventName) {
	    // Make sure we use the ownerDocument from the provided node to avoid cross-window problems
	    var doc;
	    if (el.ownerDocument) {
	        doc = el.ownerDocument;
	    } else if (el.nodeType == 9){
	        // the node may be the document itself, nodeType 9 = DOCUMENT_NODE
	        doc = el;
	    } else {
	        throw new Error("Invalid node passed to fireEvent: " + el.id);
	    }

	    if (el.dispatchEvent) {
	        // Gecko-style approach (now the standard) takes more work
	        var eventClass = "";

	        // Different events have different event classes.
	        // If this switch statement can't map an eventName to an eventClass,
	        // the event firing is going to fail.
	        switch (eventName) {
	            case "click": // Dispatching of 'click' appears to not work correctly in Safari. Use 'mousedown' or 'mouseup' instead.
	            case "mousedown":
	            case "mouseup":
	                eventClass = "MouseEvents";
	                break;

	            case "focus":
	            case "change":
	            case "blur":
	            case "select":
	                eventClass = "HTMLEvents";
	                break;

	            default:
	                eventClass = "Custom";
	                break;
	        }

	        if(eventClass=='Custom'){
	        	var event = new Event('Event');
	        } else {
	        	var event = doc.createEvent(eventClass);
	        }

	        var bubbles = eventName == "change" ? false : true;
	        event.initEvent(eventName, bubbles, true); // All events created as bubbling and cancelable.

	        event.synthetic = true; // allow detection of synthetic events
	        el.dispatchEvent(event, true);
	    } else  if (node.fireEvent) {
	        // IE-old school style
	        var event = doc.createEventObject();
	        event.synthetic = true; // allow detection of synthetic events
	        el.fireEvent("on" + eventName, event);
	    }
	};

	var parseHTML = function(str) {
	  var tmp = document.implementation.createHTMLDocument();
	  tmp.body.innerHTML = str;
	  return tmp.body.children;
	};

	var getDataAttributes=function(el){
		var data = {};
		Array.prototype.forEach.call(el.attributes, function(attr) {
		    if (/^data-/.test(attr.name)) {
		        data[attr.name.substr(5)] = attr.value;
		    }
		});

		return data;
	}

	var getAttributes=function(el){
		var data = {};
		Array.prototype.forEach.call(el.attributes, function(attr) {
		       data[attr.name] = attr.value;
		});

		return data;
	}

	var formToObject=function(form) {
	    var field, s = {};
	    if (typeof form == 'object' && form.nodeName == "FORM") {
	        var len = form.elements.length;
	        for (i=0; i<len; i++) {
	            field = form.elements[i];
	            if (field.name && !field.disabled && field.type != 'file' && field.type != 'reset' && field.type != 'submit' && field.type != 'button') {
	                if (field.type == 'select-multiple') {
	                    for (j=form.elements[i].options.length-1; j>=0; j--) {
	                        if(field.options[j].selected)
	                            s[s.name] = field.options[j].value;
	                    }
	                } else if ((field.type != 'checkbox' && field.type != 'radio') || field.checked) {
	                    s[field.name ] =field.value;
	                }
	            }
	        }
	    }
	    return s;
	}

	//http://youmightnotneedjquery.com/
	var extend=function(out) {
	  out = out || {};

	  for (var i = 1; i < arguments.length; i++) {
	    if (!arguments[i])
	      continue;

	    for (var key in arguments[i]) {
	      if (arguments[i].hasOwnProperty(key))
	        out[key] = arguments[i][key];
	    }
	  }

	  return out;
	};

	var deepExtend = function(out) {
	  out = out || {};

	  for (var i = 1; i < arguments.length; i++) {
	    var obj = arguments[i];

	    if (!obj)
	      continue;

	    for (var key in obj) {
	      if (obj.hasOwnProperty(key)) {
	        if (typeof obj[key] === 'object')
	          deepExtend(out[key], obj[key]);
	        else
	          out[key] = obj[key];
	      }
	    }
	  }

	  return out;
	}

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

	var $escape=function(value){
		return escape(value).replace( 
       	 	new RegExp( "\\+", "g" ), 
        	"%2B" 
        );
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

	var noSpam=function(user,domain) {
		locationstring = "mailto:" + user + "@" + domain;
		window.location = locationstring;
	}

	var setHTMLEditor=function(el) {

		var initEditor=function(){
			var instance=window.CKEDITOR.instances[el.getAttribute('id')];
			var conf={height:200,width:'70%'};
			
			if(el.getAttribute('data-editorconfig')){
				extend(conf,el.getAttribute('data-editorconfig'));
			}
				
			if (instance) {
				instance.destroy();
				CKEDITOR.remove(instance);
			} 

			window.CKEDITOR.replace( el.getAttribute('id'),getHTMLEditorConfig(conf),htmlEditorOnComplete);			
		}

		var htmlEditorOnComplete=function( editorInstance ) {     
			//var instance=jQuery(editorInstance).ckeditorGet();
			//instance.resetDirty();
			editorInstance.resetDirty();
			var totalIntances=window.CKEDITOR.instances;
			//CKFinder.setupCKEditor( instance, { basePath : context + '/requirements/ckfinder/', rememberLastFolder : false } ) ;  
		}

		var getHTMLEditorConfig=function(customConfig) {
			var attrname='';
			var htmlEditorConfig={
				toolbar:'htmlEditor',
				customConfig : 'config.js.cfm'
				}
			
			if(typeof(customConfig)== 'object'){  
				extend(htmlEditorConfig,customConfig);
			}
			
			return htmlEditorConfig;
		}

		loader().loadjs(
			window.mura.requirementspath + '/ckeditor/ckeditor.js'
			,
			function(){
				initEditor();
			}
		);

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
			var lu='';
			var ru='';

			if (aux.indexOf('2776') != -1 && location.search.indexOf("display=login") == -1) {
				
				if(typeof(window.mura.loginURL) != "undefined"){
					lu=window.mura.loginURL;
				} else if(typeof(window.mura.loginurl) != "undefined"){
					lu=window.mura.loginurl;
				} else{
					lu="?display=login";
				}
				
				if(typeof(window.mura.returnURL) != "undefined"){
					ru=window.mura.returnURL;
				} else if(typeof(window.mura.returnurl) != "undefined"){
					ru=window.mura.returnURL;
				} else{
					ru=location.href;
				}
				pressed_keys = "";
				
				lu = new String(lu);
				if(lu.indexOf('?') != -1){
					location.href=lu + "&returnUrl=" + $escape(ru);
				} else {
					location.href=lu + "?returnUrl=" + $escape(ru);
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
		var dtArray= dtStr.split(window.mura.dtCh);
		
		if (dtArray.length != 3){
			//alert("The date format for the "+fldName+" field should be : short")
			return false
		}
		var strMonth=dtArray[window.mura.dtFormat[0]];
		var strDay=dtArray[window.mura.dtFormat[1]];
		var strYear=dtArray[window.mura.dtFormat[2]];
		
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
		if (strYear.length != 4 || year==0 || year<window.mura.minYear || year>window.mura.maxYear){
			//alert("Please enter a valid 4 digit year between "+window.mura.minYear+" and "+window.mura.maxYear +" in the "+fldName+" field")
			return false
		}
		if (isInteger(stripCharsInBag(dtStr, window.mura.dtCh))==false){
			//alert("Please enter a valid date in the "+fldName+" field")
			return false
		}

		return true;
	}

	var isEmail=function(cur){
		var string1=cur
		if (string1.indexOf("@") == -1 || string1.indexOf(".") == -1){
			return false;
		}else{
			return true;
		}
	}

	var initShadowBox=function(el){

		if(select(el).find('[data-rel^="shadowbox"],[rel^="shadowbox"]').length){
			loader().load(
				window.mura.assetpath +'/css/shadowbox.min.css',
				window.mura.assetpath +'/js/adapter/shadowbox-jquery.min.js',
				window.mura.assetpath +'/js/shadowbox.min.js',
					function(){
						window.Shadowbox.init();
					}
				);
		} 
			
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
			console.log(data);
			console.log(validations);
			ajax(
				{
					type: 'post',
					url: window.mura.apiEndpoint + '?method=validate',
					data: {
							data: $escape(JSON.stringify(data)),
							validations: $escape(JSON.stringify(validations)),
							version: 4
						},
					success: function(resp) {
						
						data=resp.data;
				
						if(Object.keys(data).length === 0){
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
		for(var key in obj){ 
			 if (key !== key.toLowerCase()) { // might already be in its lower case version
						obj[key.toLowerCase()] = obj[key] // swap the value to a new lower case key
						delete obj[key] // delete the old key
				}
				if(typeof obj[key.toLowerCase()] == 'object'){
					setLowerCaseKeys(obj[key.toLowerCase()]);
				}
		}

		return (obj);
	}

	var loader=function(){return window.ljs;}

	var processMarkup=function(scope){
		scope=select(scope);

		var processors=[
			function(){
				scope.find(".mura-async-object").each(function(){
					processAsyncObject(this);
				});
			},

			function(){
				scope.find(".htmlEditor").each(function(){
					setHTMLEditor(this);
				});
			},

			function(){
				if(scope.find(".cffp_applied  .cffp_mm .cffp_kp").length){
					var fileref=document.createElement('script')
				        fileref.setAttribute("type","text/javascript")
				        fileref.setAttribute("src", window.mura.requirementspath + '/cfformprotect/js/cffp.js')

					document.getElementsByTagName("head")[0].appendChild(fileref)
				}
			},

			function(){
				if(scope.find(".g-recaptcha" ).length){
					var fileref=document.createElement('script')
				        fileref.setAttribute("type","text/javascript")
				        fileref.setAttribute("src", "https://www.google.com/recaptcha/api.js?hl=" + window.mura.reCAPTCHALanguage)

					document.getElementsByTagName("head")[0].appendChild(fileref)

				}

				if(scope.find(".g-recaptcha-container" ).length){
					loader().loadjs(
						'https://www.google.com/recaptcha/api.js?hl=' + window.mura.reCAPTCHALanguage,
						function(){
							each(scope.find(".g-recaptcha-container" ),function(el){
								var self=el;
								var checkForReCaptcha=function()
									{
									   if (typeof grecaptcha == 'object' )
									   {
									     grecaptcha.render(self.getAttribute('id'), {
									          'sitekey' : self.getAttribute('data-sitekey'),
									          'theme' : self.getAttribute('data-theme'),
									          'type' : self.getAttribute('data-type')
									        });
									   }
									   else
									   {
									      window.setTimeout(function(){checkForReCaptcha();},10);
									   }
									}

								checkForReCaptcha();
								
							});
						}
					);
					
				}
			},

			function(){
				if(typeof resizeEditableObject == 'function' ){
					
					scope.closest('.editableObject').each(function(){ 
						resizeEditableObject(this);
					}); 
					
					scope.find(".frontEndToolsModal").each(
						function(){
							on(this,'click',function(event){
								event.preventDefault();
								openFrontEndToolsModal(this);
							});
						}
					);

					scope.find(".editableObject").each(function(){
						resizeEditableObject(this);
					});
	
				}
			},

			function(){
				initShadowBox(scope.node);
			},

			function(){
				if(window.mura.adminpreview=='yes' || window.mura.adminpreview=='true'){
					select("a").each(function() {
						var h=this.getAttribute('href');
						if(h.indexOf('muraadminpreview')==-1){
							h=h + (h.indexOf('?') != -1 ? "&muraadminpreview&mobileformat=" + window.mura.mobileformat : "?muraadminpreview&muraadminpreview&mobileformat=" + window.mura.mobileformat);
							this.setAttribute('href',h);
						}
					});
				}
			}
		];

		for(var h=0;h<processors.length;h++){
			processors[h]();
		}
	}

	var addEventHandler=function(eventName,fn){
		if(typeof eventName == 'object'){
			for(var h in eventName){
				on(document,h,eventName[h]);
			}
		} else {
			on(document,eventName,fn);
		}	
	}

	var processAsyncObject=function(el){
		var self=el;

		var handleResponse=function(resp){
			
			var wireUpObject=function(html){
				select(self).html(html);

				processMarkup(self);
				
				each(self.getElementsByTagName('FORM'),function(el,i){
					el.onsubmit=function(){return validateFormAjax(this);};
				});

				select(self).trigger('asyncObjectRendered');

			};

			if('html' in resp.data){
				wireUpObject(resp.data.html);
			} else if('redirect' in resp.data){
				location.href=resp.data.redirect;
			} else if('render' in resp.data){
				ajax({ 
			        type:"POST",
			        xhrFields:{ withCredentials: true },
			        crossDomain:true,
			        url:resp.data.render,
			        data:resp.data,
			        success:function(data){
			        	if(typeof data=='string'){
			        		wireUpObject(data);
			        	} else if (typeof data=='object' && 'html' in data) {
			        		wireUpObject(data.html);
			        	} else if (typeof data=='object' && 'data' in data && 'html' in data.data) {
			        		wireUpObject(data.data.html);
			        	}
			        }
		   		});
			}
		};

		var validateFormAjax=function(frm) {
			
			if(typeof FormData != 'undefined' && $(frm).attr('enctype')=='multipart/form-data'){

				var data=new FormData(frm);
				var checkdata=setLowerCaseKeys(formToObject(frm));
				var keys=deepExtend({siteid:window.mura.siteid,contentid:window.mura.contentid,contenthistid:window.mura.contenthistid,nocache:1},setLowerCaseKeys(getDataAttributes(self)));
				
				for(var k in keys){
					if(!(k in checkdata)){
						data.append(k,keys[k]);
					}
				}

				if('objectparams' in checkdata){
					data.append('objectparams2', $escape(JSON.stringify(self.getAttribute('data-objectparams'))));
				}

				if('nocache' in checkdata){
					data.append('nocache',1);
				}
				
				var postconfig={
							url:  window.mura.apiEndpoint + '?method=processAsyncObject',
							type: 'POST',
							data: data,
							success:handleResponse
						} 
			
			} else {
				var data=deepExtend(setLowerCaseKeys(formToObject(frm)),{siteid:window.mura.siteid,contentid:window.mura.contentid,contenthistid:window.mura.contenthistid,nocache:1},setLowerCaseKeys(getDataAttributes(self)));

				if(!('g-recaptcha-response' in data) && document.querySelectorAll("#g-recaptcha-response").length){
					data['g-recaptcha-response']=document.getElementById('recaptcha-response').value;
				}

				if('objectparams' in data){
					data['objectparams']= $escape(JSON.stringify(data['objectparams']));
				}

				var postconfig={
							url: window.mura.apiEndpoint + '?method=processAsyncObject',
							type: 'POST',
							data: data,
							success:handleResponse
						} 
			}

			validateForm(frm,
				function(frm){
					self.innerHTML=window.mura.preloaderMarkup;
					ajax(postconfig);
				}
			);

			return false;
			
		}

		var data=deepExtend({siteid:window.mura.siteid,contentid:window.mura.contentid,contenthistid:window.mura.contenthistid,nocache:window.mura.nocache},setLowerCaseKeys(getDataAttributes(self)));
		
		if('objectparams' in data){
			data['objectparams']= $escape(JSON.stringify(data['objectparams']));
		}

		self.innerHTML=window.mura.preloaderMarkup;

		ajax({url:window.mura.apiEndpoint + '?method=processAsyncObject',type:'get',data:data,success:handleResponse});
		
		/*
		ajax({
			type:'get',
			url:window.mura.apiEndpoint + '?method=processAsyncObject',
			data:data,
			success:handleResponse}
		);
		*/

	}
	
	var init=function(config){
		if(!config.context){
			config.context='';
		}

		if(!config.assetpath){
			config.assetpath=config.context;
		}

		if(!config.apiEndpoint){
			config.apiEndpoint=config.context + '/index.cfm/_api/json/v1/';
		}

		if(!config.requirementspath){
			config.requirementspath=config.context + '/requirements';
		}

		if(typeof config.adminpreview == 'undefined'){
			config.adminpreview=false;
		}

		if(typeof config.mobileformat == 'undefined'){
			config.mobileformat=false;
		}

		if(typeof config.windowdocumentdomain != 'undefined' && config.windowdocumentdomain != ''){
			window.document.domain=config.windowdocumentdomain;
		}
		
		extend(window.mura,config);

		ready(function(){
			processMarkup(document);
			
			select(document).on("keydown", function(event){
				loginCheck(event.which);
			});

			/*
			addEventHandler(
				{
					asyncObjectRendered:function(event){
						alert(this.innerHTML);
					}
				}
			);
			*/
					
			select(document).trigger('muraReady');
			
		});

	    return window.mura
	}	

	extend(window,{
		mura:extend(
			function(selector){
				return select(selector);
			},
			{
			processAsyncObject:processAsyncObject,
			setLowerCaseKeys:setLowerCaseKeys,
			noSpam:noSpam,
			addLoadEvent:addLoadEvent,
			loader:loader,
			addEventHandler:addEventHandler,
			trigger:trigger,
			ready:ready,
			on:on,
			off:off,
			extend:extend,
			post:post,
			get:get,
			deepExtend:deepExtend,
			ajax:ajax,
			changeElementType:changeElementType,
			each:each,
			parseHTML:parseHTML,
			getDataAttributes:getDataAttributes,
			isEmptyObject:isEmptyObject,
			evalScripts:evalScripts
			}
		),
		validateForm:validateForm,
		setHTMLEditor:setHTMLEditor,
		createCookie:createCookie,
		addLoadEvent:addLoadEvent,
		noSpam:noSpam,
		initMura:init
	});

	//for some reason this can't be added via extend
	window.validateForm=validateForm;

})(window);