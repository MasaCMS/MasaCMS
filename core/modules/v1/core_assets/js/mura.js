(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory();
	else if(typeof define === 'function' && define.amd)
		define("Mura", [], factory);
	else if(typeof exports === 'object')
		exports["Mura"] = factory();
	else
		root["Mura"] = factory();
})(window, function() {
return /******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 138);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

var global = __webpack_require__(2);
var core = __webpack_require__(19);
var hide = __webpack_require__(12);
var redefine = __webpack_require__(13);
var ctx = __webpack_require__(20);
var PROTOTYPE = 'prototype';

var $export = function (type, name, source) {
  var IS_FORCED = type & $export.F;
  var IS_GLOBAL = type & $export.G;
  var IS_STATIC = type & $export.S;
  var IS_PROTO = type & $export.P;
  var IS_BIND = type & $export.B;
  var target = IS_GLOBAL ? global : IS_STATIC ? global[name] || (global[name] = {}) : (global[name] || {})[PROTOTYPE];
  var exports = IS_GLOBAL ? core : core[name] || (core[name] = {});
  var expProto = exports[PROTOTYPE] || (exports[PROTOTYPE] = {});
  var key, own, out, exp;
  if (IS_GLOBAL) source = name;
  for (key in source) {
    // contains in native
    own = !IS_FORCED && target && target[key] !== undefined;
    // export native or passed
    out = (own ? target : source)[key];
    // bind timers to global for call from export context
    exp = IS_BIND && own ? ctx(out, global) : IS_PROTO && typeof out == 'function' ? ctx(Function.call, out) : out;
    // extend global
    if (target) redefine(target, key, out, type & $export.U);
    // export
    if (exports[key] != out) hide(exports, key, exp);
    if (IS_PROTO && expProto[key] != out) expProto[key] = out;
  }
};
global.core = core;
// type bitmap
$export.F = 1;   // forced
$export.G = 2;   // global
$export.S = 4;   // static
$export.P = 8;   // proto
$export.B = 16;  // bind
$export.W = 32;  // wrap
$export.U = 64;  // safe
$export.R = 128; // real proto method for `library`
module.exports = $export;


/***/ }),
/* 1 */
/***/ (function(module, exports, __webpack_require__) {

var isObject = __webpack_require__(4);
module.exports = function (it) {
  if (!isObject(it)) throw TypeError(it + ' is not an object!');
  return it;
};


/***/ }),
/* 2 */
/***/ (function(module, exports) {

// https://github.com/zloirock/core-js/issues/86#issuecomment-115759028
var global = module.exports = typeof window != 'undefined' && window.Math == Math
  ? window : typeof self != 'undefined' && self.Math == Math ? self
  // eslint-disable-next-line no-new-func
  : Function('return this')();
if (typeof __g == 'number') __g = global; // eslint-disable-line no-undef


/***/ }),
/* 3 */
/***/ (function(module, exports) {

module.exports = function (exec) {
  try {
    return !!exec();
  } catch (e) {
    return true;
  }
};


/***/ }),
/* 4 */
/***/ (function(module, exports) {

module.exports = function (it) {
  return typeof it === 'object' ? it !== null : typeof it === 'function';
};


/***/ }),
/* 5 */
/***/ (function(module, exports, __webpack_require__) {

var store = __webpack_require__(50)('wks');
var uid = __webpack_require__(35);
var Symbol = __webpack_require__(2).Symbol;
var USE_SYMBOL = typeof Symbol == 'function';

var $exports = module.exports = function (name) {
  return store[name] || (store[name] =
    USE_SYMBOL && Symbol[name] || (USE_SYMBOL ? Symbol : uid)('Symbol.' + name));
};

$exports.store = store;


/***/ }),
/* 6 */
/***/ (function(module, exports, __webpack_require__) {

// 7.1.15 ToLength
var toInteger = __webpack_require__(22);
var min = Math.min;
module.exports = function (it) {
  return it > 0 ? min(toInteger(it), 0x1fffffffffffff) : 0; // pow(2, 53) - 1 == 9007199254740991
};


/***/ }),
/* 7 */
/***/ (function(module, exports, __webpack_require__) {

// Thank's IE8 for his funny defineProperty
module.exports = !__webpack_require__(3)(function () {
  return Object.defineProperty({}, 'a', { get: function () { return 7; } }).a != 7;
});


/***/ }),
/* 8 */
/***/ (function(module, exports, __webpack_require__) {

var anObject = __webpack_require__(1);
var IE8_DOM_DEFINE = __webpack_require__(97);
var toPrimitive = __webpack_require__(24);
var dP = Object.defineProperty;

exports.f = __webpack_require__(7) ? Object.defineProperty : function defineProperty(O, P, Attributes) {
  anObject(O);
  P = toPrimitive(P, true);
  anObject(Attributes);
  if (IE8_DOM_DEFINE) try {
    return dP(O, P, Attributes);
  } catch (e) { /* empty */ }
  if ('get' in Attributes || 'set' in Attributes) throw TypeError('Accessors not supported!');
  if ('value' in Attributes) O[P] = Attributes.value;
  return O;
};


/***/ }),
/* 9 */
/***/ (function(module, exports, __webpack_require__) {

/* WEBPACK VAR INJECTION */(function(process) {
//require("babel-polyfill");
//require("./polyfill");

/**
 * Creates a new Mura
 * @name Mura
 * @class
 * @global
 */

var Mura=(function(){
	"use strict";

	/**
	 * login - Logs user into Mura
	 *
	 * @param	{string} username Username
	 * @param	{string} password Password
	 * @param	{string} siteid	 Siteid
	 * @return {Promise}
	 * @memberof {class} Mura
	 */
	function login(username, password, siteid) {
		return Mura._requestcontext.login(username, password, siteid);
	}


	/**
	 * logout - Logs user out
	 *
	 * @param	{type} siteid Siteid
	 * @return {Promise}
	 * @memberof {class} Mura
	 */
	function logout(siteid) {
		return Mura._requestcontext.logout(siteid);
	}

	function escapeHTML(str) {
		var div = document.createElement('div');
		div.appendChild(document.createTextNode(str));
		return div.innerHTML;
	};

	// UNSAFE with unsafe strings; only use on previously-escaped ones!
	function unescapeHTML(escapedStr) {
			var div = document.createElement('div');
			div.innerHTML = escapedStr;
			var child = div.childNodes[0];
			return child ? child.nodeValue : '';
	};

	/**
	 * trackEvent - This is for Mura Experience Platform. It has no use with Mura standard
	 *
	 * @param	{object} data event data
	 * @return {Promise}
	 * @memberof {class} Mura
	 */
	function trackEvent(eventData) {
		if(typeof Mura.editing != 'undefined' && Mura.editing){
			return new Promise(function(resolve, reject) {
				resolve = resolve || function() {};
				resolve();
			});
		}

		var data={};
		var isMXP=(typeof Mura.MXP != 'undefined');
		var trackingVars = {
			ga:{
				trackingvars:{}
			}
		};
		var gaFound = false;
		var trackingComplete = false;
		var attempt=0;

		data.category = eventData.eventCategory || eventData.category || '';
		data.action = eventData.eventAction || eventData.action || '';
		data.label = eventData.eventLabel || eventData.label || '';
		data.type =	eventData.hitType || eventData.type || 'event';
		data.value =	eventData.eventValue || eventData.value || undefined;

		if (typeof eventData.nonInteraction == 'undefined') {
			data.nonInteraction = false;
		} else {
			data.nonInteraction = eventData.nonInteraction;
		}

		data.contentid = eventData.contentid || Mura.contentid;
		data.objectid = eventData.objectid || '';

		function track() {
			if(!attempt){
				trackingVars.ga.trackingvars.eventCategory = data.category;
				trackingVars.ga.trackingvars.eventAction = data.action;
				trackingVars.ga.trackingvars.nonInteraction = data.nonInteraction;
				trackingVars.ga.trackingvars.hitType = data.type;

				if (typeof data.value != 'undefined' && Mura.isNumeric(data.value)) {
					trackingVars.ga.trackingvars.eventValue = data.value;
				}

				if (data.label) {
					trackingVars.ga.trackingvars.eventLabel = data.label;
				 } else if(isMXP) {
					if(typeof trackingVars.object != 'undefined'){
						trackingVars.ga.trackingvars.eventLabel = trackingVars.object.title;
					} else {
						trackingVars.ga.trackingvars.eventLabel = trackingVars.content.title;
					}

					data.label=trackingVars.object.title;
				 }

				Mura(document).trigger('muraTrackEvent',trackingVars);
				Mura(document).trigger('muraRecordEvent',trackingVars);
			}

			if (typeof ga != 'undefined') {
				if(isMXP){
					ga('mxpGATracker.send', data.type, trackingVars.ga.trackingvars);
				} else {
					ga('send', data.type, trackingVars.ga.trackingvars);
				 }

				gaFound = true;
				trackingComplete = true;
			}

			attempt++;

			if (!gaFound && attempt <250) {
				setTimeout(track, 1);
			} else {
				trackingComplete = true;
			}

		}

		if(isMXP){
			var trackingID = data.contentid + data.objectid;

			if(typeof Mura.trackingMetadata[trackingID] != 'undefined'){
				Mura.deepExtend(trackingVars,Mura.trackingMetadata[trackingID]);
				trackingVars.eventData=data;
				track();
			} else {
				Mura.get(Mura.apiEndpoint, {
					method: 'findTrackingProps',
					siteid: Mura.siteid,
					contentid: data.contentid,
					objectid: data.objectid
				}).then(function(response) {
					Mura.deepExtend(trackingVars,response.data);
					trackingVars.eventData=data;

					 for(var p in trackingVars.ga.trackingprops){
						if(trackingVars.ga.trackingprops.hasOwnProperty(p) && p.substring(0,1)=='d' && typeof trackingVars.ga.trackingprops[p] != 'string'){
							trackingVars.ga.trackingprops[p]=new String(trackingVars.ga[p]);
						}
					 }

					Mura.trackingMetadata[trackingID]={};
					Mura.deepExtend(Mura.trackingMetadata[trackingID],response.data);
					track();
				});
			}
		} else {
			track();
		}

		return new Promise(function(resolve, reject) {

			resolve = resolve || function() {};

			function checkComplete() {
				if (trackingComplete) {
					resolve();
				 } else {
					setTimeout(checkComplete, 1);
				}
			}

			checkComplete();

		 });

	 }

	/**
	* renderFilename - Returns "Rendered" JSON object of content
	*
	* @param	{type} filename Mura content filename
	* @param	{type} params Object
	* @return {Promise}
	* @memberof {class} Mura
	*/
	function renderFilename(filename, params) {
		return Mura._requestcontext.renderFilename(filename, params);
	}

	/**
	 * declareEntity - Declare Entity with in service factory
	 *
	 * @param	{object} entityConfig Entity config object
	 * @return {Promise}
	 * @memberof {class} Mura
	 */
	function declareEntity(entityConfig) {
		return Mura._requestcontext.declareEntity(entityConfig);
	}

	/**
	 * undeclareEntity - Deletes entity class from Mura
	 *
	 * @param	{object} entityName
	 * @return {Promise}
	 * @memberof {class} Mura
	 */
	function undeclareEntity(entityName,deleteSchema) {
		deleteSchema=deleteSchema || false;
		return Mura._requestcontext.undeclareEntity(entityName,deleteSchema);
	}

	/**
	 * openGate - Open's content gate when using MXP
	 *
	 * @param	{string} contentid Optional: default's to Mura.contentid
	 * @return {Promise}
	 * @memberof {class} Mura
	 */
	function openGate(contentid) {
		return Mura._requestcontext.openGate(contentid);
	}

	/**
	 * logout - Logs user out
	 *
	 * @param	{type} siteid Siteid
	 * @return {Promise}
	 * @memberof {class} Mura
	 */
	function logout(siteid) {
		return Mura._requestcontext.logout(siteid);
	}


	/**
	 * getEntity - Returns Mura.Entity instance
	 *
	 * @param	{string} entityname Entity Name
	 * @param	{string} siteid		 Siteid
	 * @return {Mura.Entity}
	 * @memberof {class} Mura
	 */
	function getEntity(entityname, siteid) {
		siteid=siteid || Mura.siteid;
		if(typeof Mura._requestcontext=='undefined'){
			return Mura.getRequestContext().getEntity(entityname, siteid);
		} else {
			return Mura._requestcontext.getEntity(entityname, siteid);
		}
	}

	/**
	 * getFeed - Return new instance of Mura.Feed
	 *
	 * @param	{type} entityname Entity name
	 * @return {Mura.Feed}
	 * @memberof {class} Mura
	 */
	function getFeed(entityname,siteid) {
		siteid=siteid || Mura.siteid;
		return Mura._requestcontext.getFeed(entityname,siteid);
	}

	/**
	 * getCurrentUser - Return Mura.Entity for current user
	 *
	 * @param	{object} params Load parameters, fields:listoffields
	 * @return {Promise}
	 * @memberof {class} Mura
	 */
	function getCurrentUser(params) {
		return Mura._requestcontext.getCurrentUser(params);
	}

	/**
	 * findQuery - Returns Mura.EntityCollection with properties that match params
	 *
	 * @param	{object} params Object of matching params
	 * @return {Promise}
	 * @memberof {class} Mura
	 */
	function findQuery(params) {
		return Mura._requestcontext.findQuery(params);
	}

	function evalScripts(el) {
		if (typeof el == 'string') {
				el = parseHTML(el);
		}

		var scripts = [];
		var ret = el.childNodes;

		for (var i = 0; ret[i]; i++) {
			if (scripts && nodeName(ret[i], "script") && (!ret[i].type || ret[i].type.toLowerCase() === "text/javascript")) {
				if (ret[i].src) {
					scripts.push(ret[i]);
				} else {
					scripts.push(ret[i].parentNode ? ret[i].parentNode.removeChild(ret[i]) : ret[i]);
				}
			} else if (ret[i].nodeType == 1 || ret[i].nodeType == 9 ||
				ret[i].nodeType == 11) {
				evalScripts(ret[i]);
			}
		}

		for (var $script in scripts) {
			evalScript(scripts[$script]);
		}
	}

	function nodeName(el, name) {
		return el.nodeName && el.nodeName.toUpperCase() === name.toUpperCase();
	}

	function evalScript(el) {
		if (el.src) {
			Mura.loader().load(el.src);
			Mura(el).remove();
		} else {
			var data = (el.text || el.textContent || el.innerHTML || "");

			var head = document.getElementsByTagName("head")[0] ||
				document.documentElement,
				script = document.createElement("script");
			script.type = "text/javascript";
			//script.appendChild( document.createTextNode( data ) );
			script.text = data;
			head.insertBefore(script, head.firstChild);
			head.removeChild(script);

			if (el.parentNode) {
				el.parentNode.removeChild(el);
			}
		}
	}

	function changeElementType(el, to) {
		var newEl = document.createElement(to);

		// Try to copy attributes across
		for (var i = 0, a = el.attributes, n = a.length; i < n; ++i)
			el.setAttribute(a[i].name, a[i].value);

		// Try to move children across
		while (el.hasChildNodes())
			newEl.appendChild(el.firstChild);

		// Replace the old element with the new one
		el.parentNode.replaceChild(newEl, el);

		// Return the new element, for good measure.
		return newEl;
	}

	/*
	Defaults to holdReady is true so that everything
	is queued up until the DOMContentLoaded is fired
	*/
	var holdingReady = true;
	var holdingReadyAltered = false;
	var holdingQueueReleased = false;
	var holdingQueue = [];
	var holdingPreInitQueue =[];

	/*
	if(typeof jQuery != 'undefined' && typeof jQuery.holdReady != 'undefined'){
			jQuery.holdReady(true);
	}
	*/

	/*
	When DOMContentLoaded is fired check to see it the
	holdingReady has been altered by custom code.
	If it hasn't then fire holding functions.
	*/
	function initReadyQueue() {
		if (!holdingReadyAltered) {
			/*
			if(typeof jQuery != 'undefined' && typeof jQuery.holdReady != 'undefined'){
					jQuery.holdReady(false);
			}
			*/
			releaseReadyQueue();
		}
	};

	function releaseReadyQueue() {
		holdingQueueReleased = true;
		holdingReady = false;

		holdingQueue.forEach(function(fn) {
			readyInternal(fn);
		});

		holdingQueue=[];
	}

	function holdReady(hold) {
		if (!holdingQueueReleased) {
			holdingReady = hold;
			holdingReadyAltered = true;

			/*
			if(typeof jQuery != 'undefined' && typeof jQuery.holdReady != 'undefined'){
					jQuery.holdReady(hold);
			}
			*/

			if (!holdingReady) {
				releaseReadyQueue();
			}
		}
	}

	function ready(fn) {
		if (!holdingQueueReleased) {
			holdingQueue.push(fn);
		} else {
			readyInternal(fn);
		}
	}


	function readyInternal(fn) {
		if(typeof document != 'undefined'){
		if (document.readyState != 'loading') {
			//IE set the readyState to interative too early
			setTimeout(function() {
				fn(Mura);
			}, 1);
		} else {
			document.addEventListener('DOMContentLoaded', function() {
				fn(Mura);
			});
		}
		} else {
			fn(Mura);
		}
	}

	/**
	 * get - Make GET request
	 *
	 * @param	{url} url	URL
	 * @param	{object} data Data to send to url
	 * @return {Promise}
	 * @memberof {class} Mura
	 */
	function get(url, data, eventHandler) {
		return Mura._requestcontext.get(url, data, eventHandler);
	}

	/**
	 * post - Make POST request
	 *
	 * @param	{url} url	URL
	 * @param	{object} data Data to send to url
	 * @return {Promise}
	 * @memberof {class} Mura
	 */
	function post(url, data, eventHandler) {
		return Mura._requestcontext.post(url, data, eventHandler);
	}

	/**
	 * ajax - Make ajax request
	 *
	 * @param	{object} params
	 * @return {Promise}
	 * @memberof {class} Mura
	 */
	function ajax(params) {
		return Mura._requestcontext.request(params);
	}

	/**
	 * normalizeRequestHandler - Standardizes request handler objects
	 *
	 * @param	{object} eventHandler
	 * @memberof {object} eventHandler
	 */
	function normalizeRequestHandler(eventHandler) {
		eventHandler.progress=eventHandler.progress || eventHandler.onProgress || eventHandler.onUploadProgress || function(){};
		eventHandler.abort=eventHandler.abort || eventHandler.onAbort|| function(){};
		eventHandler.success=eventHandler.success || eventHandler.onSuccess || function(){};
		eventHandler.error=eventHandler.error || eventHandler.onError || function(){};
		return eventHandler;
	}

	/**
	 * getRequestContext - Returns a new Mura.RequestContext;
	 *
	 * @name getRequestContext
	 * @param	{object} request		 Siteid
	 * @param	{object} response Entity name
	 * @return {Mura.RequestContext}	 Mura.RequestContext
	 * @memberof {class} Mura
	 */
	function getRequestContext(request,response) {
		return new Mura.RequestContext(request,response);
	}

	/**
	 * getDefaultRequestContext - Returns the default Mura.RequestContext;
	 *
	 * @name getDefaultRequestContext
	 * @return {Mura.RequestContext}	 Mura.RequestContext
	 * @memberof {class} Mura
	 */
	function getDefaultRequestContext() {
		return	Mura._requestcontext;
	}

	/**
	 * generateOAuthToken - Generate Outh toke for REST API
	 *
	 * @param	{string} grant_type	Grant type (Use client_credentials)
	 * @param	{type} client_id		 Client ID
	 * @param	{type} client_secret Secret Key
	 * @return {Promise}
	 * @memberof {class} Mura
	 */
	function generateOAuthToken(grant_type, client_id, client_secret) {
			return new Promise(function(resolve, reject) {
				get(Mura.apiEndpoint.replace('/json/', '/rest/') + 'oauth?grant_type=' +
					encodeURIComponent(grant_type) + '&client_id=' + encodeURIComponent(client_id) + '&client_secret=' +
					encodeURIComponent(client_secret) + '&_cacheid=' + Math.random()).then(
					function(resp) {
						if (resp.data != 'undefined') {
							resolve(resp.data);
						} else {
							if (typeof resp.error != 'undefined' && typeof reject == 'function') {
								reject(resp);
							} else {
								resolve(resp);
							}
						}
					}
				)
			});
	}

	function each(selector, fn) {
		select(selector).each(fn);
	}

	function on(el, eventName, fn) {
		if (eventName == 'ready') {
			Mura.ready(fn);
		} else {
			if (typeof el.addEventListener == 'function') {
				el.addEventListener(
					eventName,
					function(event) {
						if(typeof fn.call == 'undefined'){
							fn(event);
						} else {
							fn.call(el, event);
						}
					},
					true
				);
			}
		}
	}

	function trigger(el, eventName, eventDetail) {
		if(typeof document != 'undefined'){
			var bubbles = eventName == "change" ? false : true;
			if (document.createEvent) {
				if(eventDetail && !isEmptyObject(eventDetail)){
					var event = document.createEvent('CustomEvent');
					event.initCustomEvent(eventName, bubbles, true,eventDetail);
				} else {

					var eventClass = "";

					switch (eventName) {
						case "click":
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
							eventClass = "Event";
							break;
					}

					var event = document.createEvent(eventClass);
					event.initEvent(eventName, bubbles, true);
				}

				event.synthetic = true;
				el.dispatchEvent(event);

			} else {
					try {
							document.fireEvent("on" + eventName);
					} catch (e) {
							console.warn(
									"Event failed to fire due to legacy browser: on" +
									eventName);
					}
			}
		}
	};

	function off(el, eventName, fn) {
		el.removeEventListener(eventName, fn);
	}

	function parseSelection(selector) {
		if (typeof selector == 'object' && Array.isArray(selector)) {
			var selection = selector;
		} else if (typeof selector == 'string') {
			var selection = nodeListToArray(document.querySelectorAll(selector));
		} else {
			if ( (typeof StaticNodeList != 'undefined' && selector instanceof StaticNodeList) ||
				(typeof NodeList != 'undefined' && selector instanceof NodeList) || (typeof HTMLCollection != 'undefined' &&	selector instanceof HTMLCollection)
			) {
				var selection = nodeListToArray(selector);
			} else {
				var selection = [selector];
			}
		}

		if (typeof selection.length == 'undefined') {
			selection = [];
		}

		return selection;
	}

	function isEmptyObject(obj) {
		return (typeof obj != 'object' || Object.keys(obj).length == 0);
	}

	function filter(selector, fn) {
		return select(parseSelection(selector)).filter(fn);
	}

	function nodeListToArray(nodeList) {
		var arr = [];
		for (var i = nodeList.length; i--; arr.unshift(nodeList[i]));
		return arr;
	}

	function select(selector) {
		return new Mura.DOMSelection(parseSelection(selector),selector);
	}

	function parseHTML(str) {
		var tmp = document.implementation.createHTMLDocument();
		tmp.body.innerHTML = str;
		return tmp.body.children;
	};

	function getData(el) {
		var data = {};
		Array.prototype.forEach.call(el.attributes, function(attr) {
			if (/^data-/.test(attr.name)) {
				data[attr.name.substr(5)] = parseString(attr.value);
			}
		});

		return data;
	}

	function getProps(el) {
		var data = {};
		Array.prototype.forEach.call(el.attributes, function(attr) {
			if (/^data-/.test(attr.name)) {
				data[attr.name.substr(5)] = parseString(attr.value);
			}
		});

		return data;
	}


	/**
	 * isNumeric - Returns if the value is numeric
	 *
	 * @name isNumeric
	 * @param	{*} val description
	 * @return {boolean}
	 * @memberof {class} Mura
	 */
	function isNumeric(val) {
			return Number(parseFloat(val)) == val;
	}

	/**
	* buildDisplayRegion - Renders display region data returned from Mura.renderFilename()
	*
	* @param	{any} data Region data to build string from
	* @return {string}
	*/
	function buildDisplayRegion(data){

		if(typeof data == 'undefined'){
			return '';
		}

		var str = data.header;



		if(data.inherited.items.length){
			str += data.inherited.header;
			for(var i in data.inherited.items){
				str += data.inherited.items[i].header;
				if(typeof data.inherited.items[i].html != 'undefined' && data.inherited.items[i].html){
					str += data.inherited.items[i].html;
				}
				str += data.inherited.items[i].footer;
			}
			str += data.inherited.footer;
		}

		str += data.local.header;

		if(data.local.items.length){
			for(var i in data.local.items){
				str += data.local.items[i].header;
				if(typeof data.local.items[i].html != 'undefined' && data.local.items[i].html){
					str += data.local.items[i].html;
				}
				str += data.local.items[i].footer;
			}
		}

		str += data.local.footer;

		str += data.footer;

		return str;
	}

	function parseString(val) {
			if (typeof val == 'string') {
				var lcaseVal = val.toLowerCase();

				if (lcaseVal == 'false') {
					return false;
				} else if (lcaseVal == 'true') {
					return true;
				} else {
					if (!(typeof val == 'string' && val.length == 35) &&
						isNumeric(val)) {
						var numVal = parseFloat(val);
						if (numVal == 0 || !isNaN(1 / numVal)) {
							return numVal;
						}
					}

					try {
						var jsonVal = JSON.parse(val);
						return jsonVal;
					} catch (e) {
						return val;
					}
				}
			} else {
				return val;
			}

	}

	function getAttributes(el) {
			var data = {};
			Array.prototype.forEach.call(el.attributes, function(attr) {
				data[attr.name] = attr.value;
			});

			return data;
	}

	/**
	 * formToObject - Returns if the value is numeric
	 *
	 * @name formToObject
	 * @param	{form} form Form to serialize
	 * @return {object}
	 * @memberof {class} Mura
	 */
	function formToObject(form) {
		var field, s = {};
		if (typeof form == 'object' && form.nodeName == "FORM") {
			var len = form.elements.length;
			for (var i = 0; i < len; i++) {
				field = form.elements[i];
				if (field.name && !field.disabled && field.type !=
					'file' && field.type != 'reset' && field.type !=
					'submit' && field.type != 'button') {
					if (field.type == 'select-multiple') {
							for (j = form.elements[i].options.length - 1; j >= 0; j--) {
								if (field.options[j].selected)
									s[s.name] = field.options[j].value;
							}
					} else if ((field.type != 'checkbox' && field.type != 'radio') || field.checked) {
						if (typeof s[field.name] == 'undefined') {
							s[field.name] = field.value;
						} else {
							s[field.name] = s[field.name] + ',' + field.value;
						}

					}
				}
			}
		}
		return s;
	}

	//http://youmightnotneedjquery.com/
	/**
	 * extend - Extends object one level
	 *
	 * @name extend
	 * @return {object}
	 * @memberof {class} Mura
	 */
	function extend(out) {
		out = out || {};

		for (var i = 1; i < arguments.length; i++) {
			if (!arguments[i])
				continue;

			for (var key in arguments[i]) {
				if (key != '__proto__' && typeof arguments[i].hasOwnProperty != 'undefined' && arguments[i].hasOwnProperty(key) )
					out[key] = arguments[i][key];
			}
		}

		return out;
	};

	/**
	 * deepExtend - Extends object to full depth
	 *
	 * @name deepExtend
	 * @return {object}
	 * @memberof {class} Mura
	 */
	function deepExtend(out) {
		out = out || {};

		for (var i = 1; i < arguments.length; i++) {
			var obj = arguments[i];

			if (!obj)
				continue;

			for (var key in obj) {
				if ( key != '__proto__' && typeof arguments[i].hasOwnProperty != 'undefined' && arguments[i].hasOwnProperty(key) ) {
					if (Array.isArray(obj[key])) {
						out[key] = obj[key].slice(0);
					} else if (typeof obj[key] === 'object') {
						out[key] = deepExtend({}, obj[key]);
					} else {
						out[key] = obj[key];
					}
				}
			}
		}

		return out;
	}


	/**
	 * createCookie - Creates cookie
	 *
	 * @name createCookie
	 * @param	{string} name	Name
	 * @param	{*} value Value
	 * @param	{number} days	Days
	 * @return {void}
	 * @memberof {class} Mura
	 */
	 function createCookie(name, value, days, domain) {
 		if(days) {
 			var date = new Date();
 			date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
 			var expires = "; expires=" + date.toGMTString();
 		} else {
 			var expires = "";
 		}
 		if(typeof location != 'undefined' && location.protocol == 'https:'){
 			var secure='; secure; samesite=None';
 		} else {
 			var secure='';
 		}
		if(typeof domain != 'undefined'){
			domain='; domain=' + domain;
		} else {
			domain='';
		}
 		document.cookie = name + "=" + value + expires + "; path=/" + secure + domain;
 	}

	/**
	 * readCookie - Reads cookie value
	 *
	 * @name readCookie
	 * @param	{string} name Name
	 * @return {*}
	 * @memberof {class} Mura
	 */
	function readCookie(name) {
		var nameEQ = name + "=";
		var ca = document.cookie.split(';');
		for (var i = 0; i < ca.length; i++) {
			var c = ca[i];
			while (c.charAt(0) == ' ') c = c.substring(1, c.length);
			if (c.indexOf(nameEQ) == 0) return unescape(c.substring(
				nameEQ.length, c.length));
		}
		return "";
	}

	/**
	 * eraseCookie - Removes cookie value
	 *
	 * @name eraseCookie
	 * @param	{type} name description
	 * @return {type}			description
	 * @memberof {class} Mura
	 */
	function eraseCookie(name) {
		createCookie(name, "", -1);
	}

	function $escape(value) {
		if (typeof encodeURIComponent != 'undefined') {
			return encodeURIComponent(value)
		} else {
			return escape(value).replace(
				new RegExp("\\+", "g"),
				"%2B"
			).replace(/[\x00-\x1F\x7F-\x9F]/g, "");
		}
	}

	function $unescape(value) {
		return unescape(value);
	}

	//deprecated
	function addLoadEvent(func) {
		var oldonload = onload;
		if (typeof onload != 'function') {
			onload = func;
		} else {
			onload = function() {
				oldonload();
				func();
			}
		}
	}

	function noSpam(user, domain) {
		locationstring = "mailto:" + user + "@" + domain;
		location = locationstring;
	}

	/**
	 * isUUID - description
	 *
	 * @name isUUID
	 * @param	{*} value Value
	 * @return {boolean}
	 * @memberof {class} Mura
	 */
	function isUUID(value) {
		if (
			typeof value == 'string' &&
			(
					value.length == 35 && value[8] == '-' && value[13] ==
					'-' && value[18] == '-' || value ==
					'00000000000000000000000000000000001' || value ==
					'00000000000000000000000000000000000' || value ==
					'00000000000000000000000000000000003' || value ==
					'00000000000000000000000000000000005' || value ==
					'00000000000000000000000000000000099'
			)
		) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * createUUID - Create UUID
	 *
	 * @name createUUID
	 * @return {string}
	 * @memberof {class} Mura
	 */
	function createUUID() {
		var s = [], itoh = '0123456789ABCDEF';

		// Make array of random hex digits. The UUID only has 32 digits in it, but we
		// allocate an extra items to make room for the '-'s we'll be inserting.
		for (var i = 0; i < 35; i++) s[i] = Math.floor(Math.random() * 0x10);

		// Conform to RFC-4122, section 4.4
		s[14] = 4; // Set 4 high bits of time_high field to version
		s[19] = (s[19] & 0x3) | 0x8; // Specify 2 high bits of clock sequence

		// Convert to hex chars
		for (var i = 0; i < 36; i++) s[i] = itoh[s[i]];

		// Insert '-'s
		s[8] = s[13] = s[18] = '-';

		return s.join('');
	}

	/**
	 * setHTMLEditor - Set Html Editor
	 *
	 * @name setHTMLEditor
	 * @param	{dom.element} el Dom Element
	 * @return {void}
	 * @memberof {class} Mura
	 */
	function setHTMLEditor(el) {

		function initEditor() {
			var instance = CKEDITOR.instances[el.getAttribute('id')];
			var conf = {
				height: 200,
				width: '70%'
			};

			extend(conf, Mura(el).data());

			if (instance) {
				instance.destroy();
				CKEDITOR.remove(instance);
			}

			CKEDITOR.replace(el.getAttribute('id'), getHTMLEditorConfig(conf), htmlEditorOnComplete);
		}

		function htmlEditorOnComplete(editorInstance) {
			editorInstance.resetDirty();
			var totalIntances = CKEDITOR.instances;
		}

		function getHTMLEditorConfig(customConfig) {
			var attrname = '';
			var htmlEditorConfig = {
				toolbar: 'htmlEditor',
				customConfig: 'config.js.cfm'
			}

			if (typeof(customConfig) == 'object') {
				extend(htmlEditorConfig, customConfig);
			}

			return htmlEditorConfig;
		}

		loader().loadjs(
			Mura.corepath + '/vendor/ckeditor/ckeditor.js',
			function() {
				initEditor();
			}
	);

	}

	var pressed_keys = '';

	var loginCheck = function(key) {
		if (key == 27) {
			pressed_keys = key.toString();

		} else if (key == 76) {
			pressed_keys = pressed_keys + "" + key.toString();
		}

		if (key != 27 && key != 76) {
			pressed_keys = "";
		}

		if (pressed_keys != "") {

			var aux = pressed_keys;
			var lu = '';
			var ru = '';

			if (aux.indexOf('2776') != -1 && location.search.indexOf(
							"display=login") == -1) {

				if (typeof(Mura.loginURL) != "undefined") {
					lu = Mura.loginURL;
				} else if (typeof(Mura.loginurl) != "undefined") {
					lu = Mura.loginurl;
				} else {
					lu = "?display=login";
				}

				if (typeof(Mura.returnURL) != "undefined") {
					ru = Mura.returnURL;
				} else if (typeof(Mura.returnurl) != "undefined") {
					ru = Mura.returnurl;
				} else {
					ru = location.href;
				}
				pressed_keys = "";

				lu = new String(lu);
				if (lu.indexOf('?') != -1) {
					location.href = lu + "&returnUrl=" + encodeURIComponent(ru);
				} else {
					location.href = lu + "?returnUrl=" + encodeURIComponent(ru);
				}
			}
		}
	}

	/**
	 * isInteger - Returns if the value is an integer
	 *
	 * @name isInteger
	 * @param	{*} Value to check
	 * @return {boolean}
	 * @memberof {class} Mura
	 */
	function isInteger(s) {
		var i;
		for (i = 0; i < s.length; i++) {
			// Check that current character is number.
			var c = s.charAt(i);
			if (((c < "0") || (c > "9"))) return false;
		}
		// All characters are numbers.
		return true;
	}

	function createDate(str) {

		var valueArray = str.split("/");

		var mon = valueArray[0];
		var dt = valueArray[1];
		var yr = valueArray[2];

		var date = new Date(yr, mon - 1, dt);

		if (!isNaN(date.getMonth())) {
			return date;
		} else {
			return new Date();
		}

	}

	function dateToString(date) {
		var mon = date.getMonth() + 1;
		var dt = date.getDate();
		var yr = date.getFullYear();

		if (mon < 10) {
				mon = "0" + mon;
		}
		if (dt < 10) {
				dt = "0" + dt;
		}


		return mon + "/" + dt + "/20" + new String(yr).substring(2, 4);
	}


	function stripCharsInBag(s, bag) {
		var i;
		var returnString = "";
		// Search through string's characters one by one.
		// If character is not in bag, append to returnString.
		for (i = 0; i < s.length; i++) {
			var c = s.charAt(i);
			if (bag.indexOf(c) == -1) returnString += c;
		}
		return returnString;
	}

	function daysInFebruary(year) {
		// February has 29 days in any year evenly divisible by four,
		// EXCEPT for centurial years which are not also divisible by 400.
		return (((year % 4 == 0) && ((!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28);
	}

	function DaysArray(n) {
		for (var i = 1; i <= n; i++) {
			this[i] = 31
			if (i == 4 || i == 6 || i == 9 || i == 11) {
				this[i] = 30
			}
			if (i == 2) {
				this[i] = 29
			}
		}
		return this
	}

	/**
	 * generateDateFormat - dateformt for input type="date"
	 *
	 * @name generateDateFormat
	 * @return {string}
	 */
		function generateDateFormat(dtStr, fldName) {
			var formatArray=['mm','dd','yyyy'];

			return [
				formatArray[Mura.dtFormat[0]],
				formatArray[Mura.dtFormat[1]],
				formatArray[Mura.dtFormat[2]]
			].join(Mura.dtCh);

		}

	/**
	 * isDate - Returns if the value is a data
	 *
	 * @name isDate
	 * @param	{*}	Value to check
	 * @return {boolean}
	 * @memberof {class} Mura
	 */
	function isDate(dtStr, fldName) {
		var daysInMonth = DaysArray(12);
		var dtArray = dtStr.split(Mura.dtCh);

		if (dtArray.length != 3) {
			//alert("The date format for the "+fldName+" field should be : short")
			return false
		}
		var strMonth = dtArray[Mura.dtFormat[0]];
		var strDay = dtArray[Mura.dtFormat[1]];
		var strYear = dtArray[Mura.dtFormat[2]];

		/*
		if(strYear.length == 2){
			strYear="20" + strYear;
		}
		*/
		strYr = strYear;

		if (strDay.charAt(0) == "0" && strDay.length > 1) strDay = strDay.substring(1)
		if (strMonth.charAt(0) == "0" && strMonth.length > 1) strMonth = strMonth.substring(1)
		for (var i = 1; i <= 3; i++) {
			if (strYr.charAt(0) == "0" && strYr.length > 1) strYr = strYr.substring(1)
		}

		month = parseInt(strMonth)
		day = parseInt(strDay)
		year = parseInt(strYr)

		if (month < 1 || month > 12) {
			//alert("Please enter a valid month in the "+fldName+" field")
			return false
		}
		if (day < 1 || day > 31 || (month == 2 && day > daysInFebruary(year)) || day > daysInMonth[month]) {
			//alert("Please enter a valid day	in the "+fldName+" field")
			return false
		}
		if (strYear.length != 4 || year == 0 || year < Mura.minYear || year > Mura.maxYear) {
			//alert("Please enter a valid 4 digit year between "+Mura.minYear+" and "+Mura.maxYear +" in the "+fldName+" field")
			return false
		}
		if (isInteger(stripCharsInBag(dtStr, Mura.dtCh)) == false) {
			//alert("Please enter a valid date in the "+fldName+" field")
			return false
		}

		return true;
	}

	/**
	 * isEmail - Returns if value is valid email
	 *
	 * @param	{string} str String to parse for email
	 * @return {boolean}
	 * @memberof {class} Mura
	 */
	function isEmail(e) {
		return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(e);
	}

	function initShadowBox(el) {
		if(typeof window =='undefined' || typeof window.document == 'undefined'){
			return;
		};

		if (Mura(el).find('[data-rel^="shadowbox"],[rel^="shadowbox"]').length) {
			loader().load(
				[
					Mura.context + '/core/modules/v1/core_assets/css/shadowbox.min.css',
					Mura.context + '/core/modules/v1/core_assets/js/shadowbox.js'
				],
				function() {
					Mura('#shadowbox_overlay,#shadowbox_container').remove();
					window.Shadowbox.init();
					}
			);
		}
	}

	/**
	 * validateForm - Validates Mura form
	 *
	 * @name validateForm
	 * @param	{type} frm					Form element to validate
	 * @param	{function} customaction Custom action (optional)
	 * @return {boolean}
	 * @memberof {class} Mura
	 */
	function validateForm(frm, customaction) {

		function getValidationFieldName(theField) {
			if (theField.getAttribute('data-label') != undefined) {
				return theField.getAttribute('data-label');
			} else if (theField.getAttribute('label') != undefined) {
				return theField.getAttribute('label');
			} else {
				return theField.getAttribute('name');
			}
		}

		function getValidationIsRequired(theField) {
			if (theField.getAttribute('data-required') != undefined) {
				return (theField.getAttribute('data-required').toLowerCase() == 'true');
			} else if (theField.getAttribute('required') != undefined) {
				return (theField.getAttribute('required').toLowerCase() == 'true');
			} else {
				return false;
			}
		}

		function getValidationMessage(theField, defaultMessage) {
			if (theField.getAttribute('data-message') != undefined) {
				return theField.getAttribute('data-message');
			} else if (theField.getAttribute('message') != undefined) {
				return theField.getAttribute('message');
			} else {
				return getValidationFieldName(theField).toUpperCase() + defaultMessage;
			}
		}

		function getValidationType(theField) {
			if (theField.getAttribute('data-validate') != undefined) {
				return theField.getAttribute('data-validate').toUpperCase();
			} else if (theField.getAttribute('validate') != undefined) {
				return theField.getAttribute('validate').toUpperCase();
			} else {
				return '';
			}
		}

		function hasValidationMatchField(theField) {
			if (theField.getAttribute('data-matchfield') != undefined &&
				theField.getAttribute('data-matchfield') != '') {
				return true;
			} else if (theField.getAttribute('matchfield') != undefined &&
				theField.getAttribute('matchfield') != '') {
				return true;
			} else {
				return false;
			}
		}

		function getValidationMatchField(theField) {
			if (theField.getAttribute('data-matchfield') != undefined) {
				return theField.getAttribute('data-matchfield');
			} else if (theField.getAttribute('matchfield') != undefined) {
				return theField.getAttribute('matchfield');
			} else {
				return '';
			}
		}

		function hasValidationRegex(theField) {
			if (theField.value != undefined) {
				if (theField.getAttribute('data-regex') != undefined &&
					theField.getAttribute('data-regex') != '') {
					return true;
				} else if (theField.getAttribute('regex') != undefined &&
					theField.getAttribute('regex') != '') {
					return true;
				}
			} else {
				return false;
			}
		}

		function getValidationRegex(theField) {
				if (theField.getAttribute('data-regex') != undefined) {
						return theField.getAttribute('data-regex');
				} else if (theField.getAttribute('regex') != undefined) {
						return theField.getAttribute('regex');
				} else {
						return '';
				}
		}

		var theForm = frm;
		var errors = "";
		var setFocus = 0;
		var started = false;
		var startAt;
		var firstErrorNode;
		var validationType = '';
		var validations = {
				properties: {}
		};
		var frmInputs = theForm.getElementsByTagName("input");
		var rules = new Array();
		var data = {};
		var $customaction = customaction;

		for (var f = 0; f < frmInputs.length; f++) {
			var theField = frmInputs[f];
			validationType = getValidationType(theField).toUpperCase();

			rules = new Array();

			if (theField.style.display == "") {
				if (getValidationIsRequired(theField)) {
					rules.push({
						required: true,
						message: getValidationMessage(theField,
								' is required.')
					});
				}
				if (validationType != '') {
					if (validationType == 'EMAIL' && theField.value != 	'') {
						rules.push({
							dataType: 'EMAIL',
							message: getValidationMessage(
									theField,
									' must be a valid email address.'
							)
						});
					} else if (validationType == 'NUMERIC' && theField.value !=
						'') {
						rules.push({
								dataType: 'NUMERIC',
								message: getValidationMessage(
										theField,
										' must be numeric.')
						});
					} else if (validationType == 'REGEX' && theField.value != '' && hasValidationRegex(theField)) {
						rules.push({
							regex: getValidationRegex(theField),
							message: getValidationMessage(
									theField, ' is not valid.')
						});
					} else if (validationType == 'MATCH' &&
						hasValidationMatchField(theField) && theField.value !=
						theForm[getValidationMatchField(theField)].value
					) {
						rules.push({
							eq: theForm[getValidationMatchField(theField)].value,
							message: getValidationMessage(
								theField, ' must match' +
								getValidationMatchField(
										theField) + '.')
						});
					} else if (validationType == 'DATE' && theField.value != '') {
						rules.push({
							dataType: 'DATE',
							message: getValidationMessage(
								theField,
								' must be a valid date [MM/DD/YYYY].'
							)
						});
					}
				}

				if (rules.length) {
					validations.properties[theField.getAttribute('name')] = rules;

					//if(!Array.isArray(data[theField.getAttribute('name')])){
						data[theField.getAttribute('name')]=[];
					//}

					for (var v = 0; v < frmInputs.length; v++) {
						if(frmInputs[v].getAttribute('name')==theField.getAttribute('name')){
							if(frmInputs[v].getAttribute('type').toLowerCase()=='checkbox'
								|| frmInputs[v].getAttribute('type').toLowerCase()=='radio'
							) {

								if(frmInputs[v].checked){
										data[theField.getAttribute('name')].push(frmInputs[v].value);
								}

							} else if(typeof frmInputs[v].value != 'undefined' && frmInputs[v].value != '') {
								data[theField.getAttribute('name')].push(frmInputs[v].value)
							}
						}
					}
				}
			}
		}

		for(var p in data){
			if(data.hasOwnProperty(p)){
				data[p]=data[p].join();
			}
		}

		var frmTextareas = theForm.getElementsByTagName("textarea");
		for (f = 0; f < frmTextareas.length; f++) {
			theField = frmTextareas[f];
			validationType = getValidationType(theField);

			rules = new Array();

			if (theField.style.display == "" && getValidationIsRequired(theField)) {
				rules.push({
					required: true,
					message: getValidationMessage(theField,' is required.')
				});

			} else if (validationType != '') {
				if (validationType == 'REGEX' && theField.value != '' &&
					hasValidationRegex(theField)) {
					rules.push({
						regex: getValidationRegex(theField),
						message: getValidationMessage(theField,' is not valid.')
					});
				}
			}

			if (rules.length) {
					validations.properties[theField.getAttribute('name')] =
							rules;
					data[theField.getAttribute('name')] = theField.value;
			}
		}

		var frmSelects = theForm.getElementsByTagName("select");
		for (f = 0; f < frmSelects.length; f++) {
			theField = frmSelects[f];
			validationType = getValidationType(theField);

			rules = new Array();

			if (theField.style.display == "" && getValidationIsRequired(theField)) {
				rules.push({
					required: true,
					message: getValidationMessage(theField,' is required.')
				});
			}

			if (rules.length) {
				validations.properties[theField.getAttribute('name')] =	rules;
				data[theField.getAttribute('name')] = theField.value;
			}
		}

		try {
			//alert(JSON.stringify(validations));
			//console.log(data);
			//console.log(validations);
			ajax({
				type: 'post',
				url: Mura.apiEndpoint + '?method=validate',
				data: {
					data: encodeURIComponent(JSON.stringify(data)),
					validations: encodeURIComponent(JSON.stringify(validations)),
					version: 4
				},
				success: function(resp) {

					data = resp.data;

					if (Object.keys(data).length === 0) {
						if (typeof $customaction ==
							'function') {
							$customaction(theForm);
							return false;
						} else {
							document.createElement('form').submit.call(theForm);
						}
					} else {
							var msg = '';
						for (var e in data) {
							msg = msg + data[e] + '\n';
						}

						alert(msg);
					}
				},
				error: function(resp) {
					alert(JSON.stringify(resp));
				}

			});
		} catch (err) {
				console.log(err);
		}

		return false;

	}

	function setLowerCaseKeys(obj) {
		for (var key in obj) {
			if (key !== key.toLowerCase()) { // might already be in its lower case version
				obj[key.toLowerCase()] = obj[key] // swap the value to a new lower case key
				delete obj[key] // delete the old key
			}
			if (typeof obj[key.toLowerCase()] == 'object') {
				setLowerCaseKeys(obj[key.toLowerCase()]);
			}
		}

		return (obj);
	}

	function isScrolledIntoView(el) {
		if (typeof window =='undefined' || typeof window.document == 'undefined' || window.innerHeight) {
			true;
		}

		try {
			var elemTop = el.getBoundingClientRect().top;
			var elemBottom = el.getBoundingClientRect().bottom;
		} catch (e) {
			return true;
		}

		var isVisible = elemTop < window.innerHeight && elemBottom >= 0;
		return isVisible;

	}

	/**
	 * loader - Returns Mura.Loader
	 *
	 * @name loader
	 * @return {Mura.Loader}
	 * @memberof {class} Mura
	 */
	function loader() {
		return Mura.ljs;
	}


	var layoutmanagertoolbar =
			'<span class="mura-fetborder mura-fetborder-left"></span><span class="mura-fetborder mura-fetborder-right"></span><span class="mura-fetborder mura-fetborder-top"></span><span class="mura-fetborder mura-fetborder-bottom"></span><div class="frontEndToolsModal mura"><span class="mura-edit-icon"></span><span class="mura-edit-label"></span></div>';

	function processMarkup(scope) {

		return new Promise(function(resolve, reject) {
			if (!(scope instanceof Mura.DOMSelection)) {
				scope = select(scope);
			}

			function find(selector) {
				return scope.find(selector);
			}

			var processors = [

				function(){
					//if layout manager UI exists check for rendered regions and remove them from additional regions
					if(Mura('.mura__layout-manager__display-regions').length){
						find('.mura-region').each(function(){
							var region=Mura(this);
							var isEditRegion=region.closest('.mura-region__item');
							if(!isEditRegion.length){
								Mura('.mura-region__item[data-regionid="' + region.data('regionid') + '"]').remove()
							}
						})

						if(!Mura('.mura__layout-manager__display-regions .mura-region__item').length){
							Mura('#mura-objects-openregions-btn, .mura__layout-manager__display-regions').remove();
						}
					}
				},

				function() {
					find('.mura-object, .mura-async-object')
						.each(function() {
							processDisplayObject(this,
								Mura.queueObjects).then(
								resolve);
						});
				},

				function() {
					find(".htmlEditor").each(function(el) {
						setHTMLEditor(this);
					});
				},

				function() {
					if (find(".cffp_applied,	.cffp_mm, .cffp_kp").length) {
						var fileref = document.createElement('script')
						fileref.setAttribute("type","text/javascript")
						fileref.setAttribute("src", Mura.corepath + '/vendor/cfformprotect/js/cffp.js')

						document.getElementsByTagName("head")[0].appendChild(fileref )
					}
				},

				function() {
					Mura.reCAPTCHALanguage = Mura.reCAPTCHALanguage || 'en';

					if (find(".g-recaptcha").length) {
						var fileref = document.createElement('script')
						fileref.setAttribute("type","text/javascript");
						fileref.setAttribute(
							"src",
							"https://www.recaptcha.net/recaptcha/api.js?onload=MuraCheckForReCaptcha&render=explicit&hl=" +	Mura.reCAPTCHALanguage
						);

						document.getElementsByTagName("head")[0].appendChild(fileref);
					}

					if (find(".g-recaptcha-container").length) {
						loader().loadjs("https://www.recaptcha.net/recaptcha/api.js?onload=MuraCheckForReCaptcha&render=explicit&hl=" + Mura.reCAPTCHALanguage,
							function() {
								find(".g-recaptcha-container").each(function(el) {
									var notready=0;;
								
									window.MuraCheckForReCaptcha=function() {
										Mura('.g-recaptcha-container').each(function(){
											var self=this;

											if (
												typeof grecaptcha ==	'object'
												&& typeof grecaptcha.render != 'undefined'
												&&	!self.innerHTML
											) {

												self
													.setAttribute(
														'data-widgetid',
														grecaptcha
														.render(
															self.getAttribute('id'),
															{
																'sitekey': self.getAttribute('data-sitekey'),
																'theme': self.getAttribute('data-theme'),
																'type': self.getAttribute('data-type')
															}
														)
													);
											} else {
												notready++;
											}
										})
											
										if(notready){
											setTimeout(
												function() {
													window.MuraCheckForReCaptcha();
												},
												10
											);
										}
		
									}

									window.MuraCheckForReCaptcha();
								});
							}
						);

					}
				},

				function() {
					if (typeof resizeEditableObject == 'function') {

						scope.closest('.editableObject').each(
						function() {
							resizeEditableObject(this);
						});

						find(".editableObject").each(
						function() {
							resizeEditableObject(this);
						});

					}
				},

				function() {
					if (Mura.handleObjectClick == 'function') {
						find('.mura-object, .frontEndToolsModal').on('click',Mura.handleObjectClick);
					}
					
					if (typeof window !='undefined' && typeof window.document != 'undefined'	&& window.MuraInlineEditor
							&& window.MuraInlineEditor.checkforImageCroppers) {
							find("img").each(function() {
									window.muraInlineEditor.checkforImageCroppers(
											this);
							});

					}

				},

				function() {
					initShadowBox(scope.node);
				},

				function() {
					if (typeof urlparams.muraadminpreview != 'undefined') {
						find("a").each(function() {
							var h = this.getAttribute('href');
							if (typeof h ==
								'string' && h.indexOf(
										'muraadminpreview'
								) == -1) {
								h = h + (h.indexOf(
										'?') !=
									-1 ?
									"&muraadminpreview&mobileformat=" +
									Mura.mobileformat :
									"?muraadminpreview&muraadminpreview&mobileformat=" +
									Mura.mobileformat
								);
								this.setAttribute('href', h);
							}
						});
					}
				}
			];


			for (var h = 0; h < processors.length; h++) {
				processors[h]();
			}

		});

	}

	function addEventHandler(eventName, fn) {
		if (typeof eventName == 'object') {
			for (var h in eventName) {
				if(eventName.hasOwnProperty(h)){
					on(document, h, eventName[h]);
				}
			}
		} else {
			on(document, eventName, fn);
		}
	}


	function submitForm(frm, obj) {
		frm = (frm.node) ? frm.node : frm;

		if (obj) {
			obj = (obj.node) ? obj : Mura(obj);
		} else {
			obj = Mura(frm).closest('.mura-async-object');
		}

		if (!obj.length) {
			Mura(frm).trigger('formSubmit', formToObject(frm));
			frm.submit();
		}

		if (Mura.formdata	&& frm.getAttribute('enctype') == 'multipart/form-data') {

			var data = new FormData(frm);
			var checkdata = setLowerCaseKeys(formToObject(frm));
			var keys = filterUnwantedParams(
					deepExtend(
						setLowerCaseKeys(obj.data()),
						urlparams,
						{
						siteid: Mura.siteid,
						contentid: Mura.contentid,
						contenthistid: Mura.contenthistid,
						nocache: 1
						}
					)
			);

			if(obj.data('siteid')){
				keys.siteid=obj.data('siteid');
			}

			for (var k in keys) {
				if (!(k in checkdata)) {
					data.append(k, keys[k]);
				}
			}

			if ('objectparams' in checkdata) {
				data.append('objectparams2', encodeURIComponent(JSON.stringify(obj.data('objectparams'))));
			}

			if ('nocache' in checkdata) {
				data.append('nocache', 1);
			}

			/*
			if(data.object=='container' && data.content){
				delete data.content;
			}
			*/

			var postconfig = {
				url: Mura.apiEndpoint + '?method=processAsyncObject',
				type: 'POST',
				data: data,
				success: function(resp) {
					//obj=Mura('div[data-instanceid="' + obj.data('instanceid') + '"]');
					setTimeout(function(){handleResponse(obj, resp)},0);
				}
			}

		} else {

			var data = filterUnwantedParams(
				deepExtend(
					setLowerCaseKeys(obj.data()),
					urlparams,
					setLowerCaseKeys(formToObject(frm)),
					{
						siteid: Mura.siteid,
						contentid: Mura.contentid,
						contenthistid: Mura.contenthistid,
						nocache: 1
					}
				));
			
			if(obj.data('siteid')){
				data.siteid=obj.data('siteid');
			}

			if (data.object == 'container' && data.content) {
				delete data.content;
			}

			if (!('g-recaptcha-response' in data)) {
				var reCaptchaCheck = Mura(frm).find("#g-recaptcha-response");

				if (reCaptchaCheck.length && typeof reCaptchaCheck.val() != 'undefined') {
					data['g-recaptcha-response'] = eCaptchaCheck.val();
				}
			}

			if ('objectparams' in data) {
				data['objectparams'] = encodeURIComponent(JSON.stringify(data['objectparams']));
			}

			var postconfig = {
				url: Mura.apiEndpoint + '?method=processAsyncObject',
				type: 'POST',
				data: data,
				success: function(resp) {
					//obj=Mura('div[data-instanceid="' + obj.data('instanceid') + '"]');
					setTimeout(function(){handleResponse(obj, resp)},0);
				}
			}
		}

		var self = obj.node;
		self.prevInnerHTML = self.innerHTML;
		self.prevData = filterUnwantedParams(obj.data());

		if(typeof self.prevData != 'undefined' && typeof self.prevData.preloadermarkup != 'undefined'){
			self.innerHTML = self.prevData.preloadermarkup;
		} else {
			self.innerHTML = Mura.preloaderMarkup;
		}

		Mura(frm).trigger('formSubmit', data);

		ajax(postconfig);
	}

	function firstToUpperCase(str) {
		return str.substr(0, 1).toUpperCase() + str.substr(1);
	}

	function resetAsyncObject(el,empty) {
		var self = Mura(el);

		if(self.data('transient')){
			self.remove();
		} else { 
		
			if(typeof empty =='undefined'){
				empty=true;
			}
			self.removeClass('mura-active');
			self.removeAttr('data-perm');
			self.removeAttr('data-runtime');
			self.removeAttr('draggable');
			self.removeAttr('style');
			self.removeAttr('data-inited');
			self.removeAttr('data-startrow');
			self.removeAttr('data-pagenum');
			self.removeAttr('data-nextnid');
			self.removeAttr('data-origininstanceid');

			var data=self.data();

			for(var p in data){
				if(data.hasOwnProperty(p) && (typeof p == 'undefined' || data[p] === '')){
					self.removeAttr('data-' + p);
				}
			}

			if (self.data('object') == 'container') {
				self.find('.mura-object:not([data-object="container"])').html('');
				self.find('.frontEndToolsModal').remove();
				self.find('.mura-object').each(function() {
					var self = Mura(this);
					self.removeClass('mura-active');
					self.removeAttr('data-perm');
					self.removeAttr('data-runtime');
					self.removeAttr('draggable');
					self.removeAttr('style');
					self.removeAttr('data-inited');
					self.removeAttr('data-startrow');
					self.removeAttr('data-pagenum');
					self.removeAttr('data-nextnid');
					self.removeAttr('data-origininstanceid');
				});

				self.find('.mura-object[data-object="container"]').each(
					function() {
						resetAsyncObject(this,empty);
						
					});

				self.find('.mura-object-meta').html('');
				var content = self.children('div.mura-object-content');

				if (content.length) {
					self.data('content', content.html());
				}
			}
			if(empty){
				self.html('');
			}
		}
	}

	function processAsyncObject(el,usePreloaderMarkup) {
			var obj = Mura(el);
			if (obj.data('async') === null) {
					obj.data('async', true);
			}

			if(typeof usePreloaderMarkup == 'undefined'){
				usePreloaderMarkup=true;
			}

			return processDisplayObject(obj, false, true,false,usePreloaderMarkup);
	}

	function filterUnwantedParams(params){

		//Strip out unwanted attributes
		var unwanted=['iconclass','objectname','inited','params','stylesupport','cssstyles','metacssstyles','contentcssstyles',
			'cssclass','cssid','metacssclass','metacssid','contentcssclass','contentcssid','transient','draggable'];

		for(var c=0; c<unwanted.length;c++){
			delete params[unwanted[c]];
		}

		return params;
	}

	function destroyDisplayObjects(){
		for (var property in Mura.displayObjectInstances) {
			if (Mura.displayObjectInstances.hasOwnProperty(property)) {
				var obj=Mura.displayObjectInstances[property];
				if(typeof obj.destroy == 'function'){
					obj.destroy();
				}
				delete Mura.displayObjectInstances[property];
			}
		}
	}

	function destroyModules(){
		destroyDisplayObjects();
	}

	function wireUpObject(obj, response, attempt) {

		attempt= attempt || 0;
		attempt++;

		obj = (obj.node) ? obj : Mura(obj);

		obj.data('inited', true);

		if (response) {
				if (typeof response == 'string') {
					obj.html(trim(response));
				} else if (typeof response.html == 'string' && response.render != 'client') {
					obj.html(trim(response.html));
				} else {
					if (obj.data('object') == 'container') {
						var context = filterUnwantedParams(deepExtend(obj.data(), response));
						context.targetEl = obj.node;
						obj.prepend(Mura.templates.meta(context));
					} else {
						var context = filterUnwantedParams(deepExtend(obj.data(), response));
						var template = obj.data('clienttemplate') || obj.data('object');
						var properNameCheck = firstToUpperCase(template);

						if (typeof Mura.DisplayObject[properNameCheck] != 'undefined') {
							template = properNameCheck;
						}

						if (typeof context.async != 'undefined') {
							obj.data('async', context.async);
						}

						if (typeof context.render != 'undefined') {
							obj.data('render', context.render);
						}

						if (typeof context.rendertemplate != 'undefined') {
							obj.data('rendertemplate', context.rendertemplate);
						}

						if (typeof Mura.DisplayObject[template] != 'undefined') {
							context.html = '';
							if(typeof Mura.displayObjectInstances[obj.data('instanceid')] != 'undefined'){
								Mura.displayObjectInstances[obj.data('instanceid')].destroy();
							}
							obj.html(Mura.templates.content({html:''}));
							obj.prepend(Mura.templates.meta(context));
							context.targetEl = obj.children('.mura-object-content').node;
							Mura.displayObjectInstances[obj.data('instanceid')]=new Mura.DisplayObject[template](context);
							Mura.displayObjectInstances[obj.data('instanceid')].trigger('beforeRender');
							Mura.displayObjectInstances[obj.data('instanceid')].renderClient();
						} else if (typeof Mura.templates[template] !=	'undefined') {
							context.html = '';
							obj.html(Mura.templates.content(context));
							obj.prepend(Mura.templates.meta(context));
							context.targetEl = obj.children('.mura-object-content').node;
							Mura.templates[template](context);
						} else {
							if(attempt < 1000){
								setTimeout(
									function(){
											wireUpObject(obj,response,attempt);
									},
									1
								);
							} else {
								console.log('Missing Client Template for:');
								console.log(obj.data());
							}
						}
					}
				}
		} else {
			var context = filterUnwantedParams(obj.data());
			if (obj.data('object') == 'container') {
				obj.prepend(Mura.templates.meta(context));
			} else {
				var template = obj.data('clienttemplate') || obj.data('object');
				var properNameCheck = firstToUpperCase(template);

				if (typeof Mura.DisplayObject[properNameCheck] !=	'undefined') {
					template = properNameCheck;
				}

				if (typeof Mura.DisplayObject[template] == 'function') {
					context.html = '';
					if(typeof Mura.displayObjectInstances[obj.data('instanceid')] != 'undefined'){
						Mura.displayObjectInstances[obj.data('instanceid')].destroy();
					}
					obj.html(Mura.templates.content({html:''}));
					obj.prepend(Mura.templates.meta(context));
					context.targetEl = obj.children('.mura-object-content').node;
					Mura.displayObjectInstances[obj.data('instanceid')]=new Mura.DisplayObject[template](context);
					Mura.displayObjectInstances[obj.data('instanceid')].trigger('beforeRender');
					Mura.displayObjectInstances[obj.data('instanceid')].renderClient();
				} else if (typeof Mura.templates[template] !=	'undefined') {
					context.html = '';
					obj.html(Mura.templates.content(context));
					obj.prepend(Mura.templates.meta(context));
					context.targetEl = obj.children('.mura-object-content').node;
					Mura.templates[template](context);
				} else {
					if(attempt < 1000){
						setTimeout(
							function(){
								wireUpObject(obj,response,attempt);
							},
							1
						);
					} else {
						console.log('Missing Client Template for:');
						console.log(obj.data());
					}
				}
			}
		}

		obj.calculateDisplayObjectStyles();

		obj.hide().show();

		if (Mura.layoutmanager && Mura.editing) {
			if (obj.hasClass('mura-body-object') || obj.is('div.mura-object[data-targetattr]')) {
				obj.children('.frontEndToolsModal').remove();
				obj.prepend(Mura.layoutmanagertoolbar);
				if(obj.data('objectname')){
					obj.children('.frontEndToolsModal').children('.mura-edit-label').html(obj.data('objectname'));
				} else {
					obj.children('.frontEndToolsModal').children('.mura-edit-label').html(Mura.firstToUpperCase(obj.data('object')));
				}
				if(obj.data('objecticonclass')){
					obj.children('.frontEndToolsModal').children('.mura-edit-label').addClass(obj.data('objecticonclass'));
				}

				MuraInlineEditor.setAnchorSaveChecks(obj.node);

				obj.addClass('mura-active')
					.hover(
						Mura.initDraggableObject_hoverin,
						Mura.initDraggableObject_hoverin
					);
			} else {
				if (Mura.type == 'Variation') {
					var objectData = obj.data();
					if (MuraInlineEditor && (MuraInlineEditor.objectHasConfigurator(obj) || (!Mura.layoutmanager && MuraInlineEditor.objectHasEditor(objectData)))) {
						obj.children('.frontEndToolsModal').remove();
						obj.prepend(Mura.layoutmanagertoolbar);
						if(obj.data('objectname')){
							obj.children('.frontEndToolsModal').children('.mura-edit-label').html(obj.data('objectname'));
						} else {
							obj.children('.frontEndToolsModal').children('.mura-edit-label').html(Mura.firstToUpperCase(obj.data('object')));
						}
						if(obj.data('objecticonclass')){
							obj.children('.frontEndToolsModal').children('.mura-edit-label').addClass(obj.data('objecticonclass'));
						}

						MuraInlineEditor.setAnchorSaveChecks(obj.node);

						obj.off('click',Mura.handleObjectClick).on('click',Mura.handleObjectClick);
							
						obj.find("img").each(function(){MuraInlineEditor.checkforImageCroppers(this);});
						
						obj
							.addClass('mura-active')
							.hover(
								function(e) {
									e.stopPropagation();
									Mura('.mura-active-target').removeClass('mura-active-target');
									Mura(this).addClass('mura-active-target');
								},
								function(e) {
									e.stopPropagation();
									Mura(this).removeClass('mura-active-target');
								}
							);

						Mura.initDraggableObject(obj.node);
					}
				} else {
					var lcaseObject=obj.data('object');
					if(typeof lcaseObject=='string'){
						lcaseObject=lcaseObject.toLowerCase();
					}
					var region = Mura(obj.node).closest(".mura-region-local");
					if (region && region.length) {
						if (region.data('perm')) {
							var objectData = obj.data();

							if (MuraInlineEditor && (MuraInlineEditor.objectHasConfigurator(obj) || (!Mura.layoutmanager && MuraInlineEditor.objectHasEditor(objectData)))) {
								obj.children('.frontEndToolsModal').remove();
								obj.prepend(Mura.layoutmanagertoolbar);
								if(obj.data('objectname')){
									obj.children('.frontEndToolsModal').children('.mura-edit-label').html(obj.data('objectname'));
								} else {
									obj.children('.frontEndToolsModal').children('.mura-edit-label').html(Mura.firstToUpperCase(obj.data('object')));
								}
								if(obj.data('objecticonclass')){
									obj.children('.frontEndToolsModal').children('.mura-edit-label').addClass(obj.data('objecticonclass'));
								}

								obj.off('click',Mura.handleObjectClick).on('click',Mura.handleObjectClick);
							
								obj.find("img").each(function(){MuraInlineEditor.checkforImageCroppers(this);});

								MuraInlineEditor.setAnchorSaveChecks(obj.node);

								obj
									.addClass('mura-active')
									.hover(
										function(e) {
											e.stopPropagation();
											Mura('.mura-active-target').removeClass('mura-active-target');
											Mura(this).addClass('mura-active-target');
										},
										function(e) {
											e.stopPropagation();
											Mura(this).removeClass('mura-active-target');
										}
									);

								Mura.initDraggableObject(obj.node);
							}
						}
					} else if (lcaseObject=='form' || lcaseObject=='component'){

						if(obj.data('perm')){
							var objectData=obj.data();
							if(window.MuraInlineEditor.objectHasConfigurator(obj) || (!window.Mura.layoutmanager && window.MuraInlineEditor.objectHasEditor(objectData)) ){
								obj.addClass('mura-active');
								obj.hover(
									Mura.initDraggableObject_hoverin,
									Mura.initDraggableObject_hoverout
								);
								obj.data('notconfigurable',true);
								obj.children('.frontEndToolsModal').remove();
								obj.prepend(Mura.layoutmanagertoolbar);
								if(obj.data('objectname')){
									obj.children('.frontEndToolsModal').children('.mura-edit-label').html(obj.data('objectname'));
								} else {
									obj.children('.frontEndToolsModal').children('.mura-edit-label').html(Mura.firstToUpperCase(obj.data('object')));
								}
								if(obj.data('objecticonclass')){
									obj.children('.frontEndToolsModal').children('.mura-edit-label').addClass(obj.data('objecticonclass'));
								}
								
								obj.off('click',Mura.handleObjectClick).on('click',Mura.handleObjectClick);
							
								obj.find("img").each(function(){MuraInlineEditor.checkforImageCroppers(this);});

								obj
									.addClass('mura-active')
									.hover(
										function(e) {
											//e.stopPropagation();
											Mura('.mura-active-target').removeClass('mura-active-target');
											Mura(this).addClass('mura-active-target');
										},
										function(e) {
											//e.stopPropagation();
											Mura(this).removeClass('mura-active-target');
										}
									);
								}
							}
						}
				}
			}
		}

		obj.hide().show();
		
		processMarkup(obj.node);

		obj.find('a[href="javascript:history.back();"]').each(function() {
			Mura(this).off("click").on("click", function(e) {
				if (obj.node.prevInnerHTML) {
					e.preventDefault();
					wireUpObject(obj, obj.node.prevInnerHTML);

					if (obj.node.prevData) {
						for (var p in obj.node.prevData) {
							select('[name="' + p + '"]').val(obj.node.prevData[p]);
						}
					}
					obj.node.prevInnerHTML = false;
					obj.node.prevData = false;
				}
			});
		});
		
		obj.find('form').each(function() {
			var form = Mura(this);
			if(form.closest('.mura-object').data('instanceid')==obj.data('instanceid')) {		
				if(form.data('async') || !(form.hasData('async') &&
					!form.data('async')) && !(form.hasData(
					'autowire') && !form.data('autowire')) && !
					form.attr('action') && !form.attr('onsubmit') &&
					!form.attr('onSubmit')) {
					form.on('submit', function(e) {
						e.preventDefault();
						validateForm(this,
							function(frm) {
								submitForm(frm,obj);
							}
						);

						return false;
					});
				}
			}
		});

		obj.trigger('asyncObjectRendered');

	}

	function handleResponse(obj, resp) {
		obj = (obj.node) ? obj : Mura(obj);

		// handle HTML response
		resp = (!resp.data) ? {
			data: resp
		} : resp;

		if (typeof resp.data.redirect != 'undefined') {
			if (resp.data.redirect && resp.data.redirect != location.href) {
				location.href = resp.data.redirect;
			} else {
				location.reload(true);
			}
		} else if (resp.data.apiEndpoint) {
			ajax({
				type: "POST",
				xhrFields: {
						withCredentials: true
				},
				crossDomain: true,
				url: resp.data.apiEndpoint,
				data: resp.data,
				success: function(data) {
						if (typeof data == 'string') {
								wireUpObject(obj, data);
						} else if (typeof data == 'object' &&
								'html' in data) {
								wireUpObject(obj, data.html);
						} else if (typeof data == 'object' &&
								'data' in data && 'html' in data.data
						) {
								wireUpObject(obj, data.data.html);
						} else {
								wireUpObject(obj, data.data);
						}
				}
			});
		} else {
			wireUpObject(obj, resp.data);
		}
	}

	function processDisplayObject(el, queue, rerender, resolveFn, usePreloaderMarkup) {
		var obj = (el.node) ? el : Mura(el);

		if (obj.data('queue') != null) {
			queue = obj.data('queue');

			if(typeof queue == 'string'){
				queue=queue.toLowerCase();
				if(queue=='no' || queue=='false'){
					queue=false;
				} else {
					queue==true;
				}
			}
		}

		var rendered = (rerender && !obj.data('async')) ? false : obj.children('.mura-object-content').length

		queue = (queue == null || rendered) ? false : queue;
		
		if (document.createEvent && queue && !isScrolledIntoView(obj.node)) {
			if (!resolveFn) {
				return new Promise(function(resolve, reject) {

					resolve = resolve || function() {};

					setTimeout(
						function() {
							processDisplayObject(obj.node, true, false, resolve, usePreloaderMarkup);
						}, 10
					);
				});
			} else {
				setTimeout(
					function() {
						var resp = processDisplayObject(obj.node, true, false, resolveFn, usePreloaderMarkup);
						if (typeof resp == 'object' && typeof resolveFn == 'function') {
							resp.then(resolveFn);
						}
					}, 10
				);

				return;
			}
		}

		if (!obj.node.getAttribute('data-instanceid')) {
			obj.node.setAttribute('data-instanceid', createUUID());
		}

		//if(obj.data('async')){
		obj.addClass("mura-async-object");
		//}

		if (obj.data('object') == 'container') {
			obj.html(Mura.templates.content(obj.data()));

			obj.find('.mura-object').each(function() {
				this.innerHTML=obj.data('preloadermarkup') || Mura.preloaderMarkup;
				this.setAttribute('data-instanceid', createUUID());
			});
		}

		if (rendered && !obj.data('async')) {
			
			return new Promise(function(resolve, reject) {

				obj.calculateDisplayObjectStyles();

				if(!rerender && obj.data('render')=='client' && obj.children('.mura-object-content').length){
					
					var context=filterUnwantedParams(obj.data());
					if(typeof context.instanceid != 'undefined' && typeof Mura.hydrationData[context.instanceid] != 'undefined'){
						Mura.extend(context,Mura.hydrationData[context.instanceid]);
					}
					var template=obj.data('clienttemplate') || obj.data('object');
					var properNameCheck = firstToUpperCase(template);

					if (typeof Mura.DisplayObject[properNameCheck] != 'undefined') {
						template = properNameCheck;
					}

					if(typeof Mura.DisplayObject[template] != 'undefined'){
						context.targetEl = obj.children('.mura-object-content').node;
						Mura.displayObjectInstances[obj.data('instanceid')]=new Mura.DisplayObject[template](context);
						Mura.displayObjectInstances[obj.data('instanceid')].trigger('beforeRender');
						Mura.displayObjectInstances[obj.data('instanceid')].hydrate();
					} else {
						console.log('Missing Client Template for:');
						console.log(obj.data());
					}
				}

				obj.find('form').each(function() {
					var form = Mura(this);
					if(form.closest('.mura-object').data('instanceid')==obj.data('instanceid')) {
						if(form.data('async')
							|| !(form.hasData('async')
							&& !form.data('async'))
							&& !(form.hasData('autowire')
							&& !form.data('autowire'))
							&& !form.attr('action')
							&& !form.attr('onsubmit')
							&& !form.attr('onSubmit')) {
								form.on('submit', function(e) {
									e.preventDefault();
									validateForm(this,
										function(frm) {
											submitForm(frm,obj);
										}
									);

									return false;
								});
						}
					}
				});
	
				if (typeof resolve == 'function') {
					resolve(obj);
				}

			});
		}
	
		return new Promise(function(resolve, reject) {
			
			var data = deepExtend(setLowerCaseKeys(obj.data()),
				urlparams, {
					siteid: Mura.siteid,
					contentid: Mura.contentid,
					contenthistid: Mura.contenthistid
				});
			
			if (obj.data('siteid')) {
				data.siteid = obj.node.getAttribute('data-siteid');
			}

			if (obj.data('contentid')) {
				data.contentid = obj.node.getAttribute('data-contentid');
			}

			if (obj.data('contenthistid')) {
				data.contenthistid = obj.node.getAttribute('data-contenthistid');
			}

			if ('objectparams' in data) {
				data['objectparams'] = encodeURIComponent(JSON.stringify(data['objectparams']));
			}

			if (obj.data('object') == 'container') {
				wireUpObject(obj);
				if (typeof resolve == 'function') {
					if(typeof resolve.call == 'undefined'){
						resolve(obj);
					} else {
						resolve.call(obj.node, obj);
					}
				}
			} else {
				if (!obj.data('async') && obj.data('render') == 'client') {
					wireUpObject(obj);
						if (typeof resolve == 'function') {
							if(typeof resolve.call == 'undefined'){
								resolve(obj);
							} else {
								resolve.call(obj.node, obj);
							}
						}
				} else {
					//console.log(data);
					if(usePreloaderMarkup){
						if(typeof data.preloadermarkup != 'undefined'){
							obj.node.innerHTML = data.preloadermarkup;
							delete data.preloadermarkup;
						} else {
							obj.node.innerHTML = Mura.preloaderMarkup;
						}
					}

					var requestType='get';
					var requestData=filterUnwantedParams(data);
					var postCheck=new RegExp(/<\/?[a-z][\s\S]*>/i);

					for(var p in requestData){
						if(requestData.hasOwnProperty(p) 
							&& requestData[p]
							&& postCheck.test(requestData[p])
						){
							requestType='post';
							break;
						}
					}
				
					ajax({
						url: Mura.apiEndpoint + '?method=processAsyncObject',
						type: requestType,
						data: requestData,
						success: function(resp) {
							//obj=Mura('div[data-instanceid="' + obj.data('instanceid') + '"]');
							setTimeout(function(){
								handleResponse(obj, resp)
								if (typeof resolve =='function') {
									if(typeof resolve.call == 'undefined'){
										resolve(obj);
									} else {
										resolve.call(obj.node, obj);
									}
								}
							},0)
						}
							
					});
				}

			}
		});

	}

	function processModule(el, queue, rerender, resolveFn, usePreloaderMarkup) {
		return processDisplayObject(el, queue, rerender, resolveFn, usePreloaderMarkup);
	}

	var hashparams = {};
	var urlparams = {};

	function handleHashChange() {

		if(typeof location != 'undefined'){
			var hash = location.hash;
		} else {
			var hash = '';
		}

		if (hash) {
			hash = hash.substring(1);
		}

		if (hash) {
			hashparams = getQueryStringParams(hash);
			if (hashparams.nextnid) {
				Mura('.mura-async-object[data-nextnid="' + hashparams.nextnid + '"]')
					.each(function() {
						Mura(this).data(hashparams);
						processAsyncObject(this);
				});
			} else if (hashparams.objectid) {
				Mura('.mura-async-object[data-objectid="' + hashparams.objectid + '"]')
				.each(function() {
						Mura(this).data(hashparams);
						processAsyncObject(this);
				});
			}
		}
		
	}

	/**
	 * trim - description
	 *
	 * @param	{string} str Trims string
	 * @return {string}		 Trimmed string
	 * @memberof {class} Mura
	 */
	function trim(str) {
		return str.replace(/^\s+|\s+$/gm, '');
	}


	function extendClass(baseClass, subClass) {
		var muraObject = function() {
			this.init.apply(this, arguments);
		}

		muraObject.prototype = Object.create(baseClass.prototype);
		muraObject.prototype.constructor = muraObject;
		muraObject.prototype.handlers = {};

		muraObject.reopen = function(subClass) {
				Mura.extend(muraObject.prototype, subClass);
		};

		muraObject.reopenClass = function(subClass) {
			Mura.extend(muraObject, subClass);
		};

		muraObject.on = function(eventName, fn) {
			eventName = eventName.toLowerCase();

			if (typeof muraObject.prototype.handlers[eventName] == 'undefined') {
				muraObject.prototype.handlers[eventName] = [];
			}

			if (!fn) {
				return muraObject;
			}

			for (var i = 0; i < muraObject.prototype.handlers[eventName].length; i++) {
				if (muraObject.prototype.handlers[eventName][i] == handler) {
					return muraObject;
				}
			}


			muraObject.prototype.handlers[eventName].push(fn);
			return muraObject;
		};

		muraObject.off = function(eventName, fn) {
			eventName = eventName.toLowerCase();

			if (typeof muraObject.prototype.handlers[eventName] =='undefined') {
				muraObject.prototype.handlers[eventName] = [];
			}

			if (!fn) {
				muraObject.prototype.handlers[eventName] = [];
				return muraObject;
			}

			for (var i = 0; i < muraObject.prototype.handlers[
				eventName].length; i++) {
				if (muraObject.prototype.handlers[eventName][i] ==handler) {
					muraObject.prototype.handlers[eventName].splice(i, 1);
				}
			}
			return muraObject;
		}

		Mura.extend(muraObject.prototype, subClass);

		return muraObject;
	}


	/**
	 * getQueryStringParams - Returns object of params in string
	 *
	 * @name getQueryStringParams
	 * @param	{string} queryString Query String
	 * @return {object}
	 * @memberof {class} Mura
	 */
	function getQueryStringParams(queryString) {

		if(typeof location == 'undefined'){
			return {};
		}

		queryString = queryString || location.search;
		var params = {};
		var e,
			a = /\+/g, // Regex for replacing addition symbol with a space
			r = /([^&;=]+)=?([^&;]*)/g,
			d = function(s) {
					return decodeURIComponent(s.replace(a, " "));
			};

		if (queryString.substring(0, 1) == '?') {
			var q = queryString.substring(1);
		} else {
			var q = queryString;
		}


		while (e = r.exec(q))
			params[d(e[1]).toLowerCase()] = d(e[2]);

		return params;
	}

	/**
	 * getHREFParams - Returns object of params in string
	 *
	 * @name getHREFParams
	 * @param	{string} href
	 * @return {object}
	 * @memberof {class} Mura
	 */
	function getHREFParams(href) {
		var a = href.split('?');

		if (a.length == 2) {
			return getQueryStringParams(a[1]);
		} else {
			return {};
		}
	}

	function inArray(elem, array, i) {
		var len;
		if (array) {
			if (array.indexOf) {
				return array.indexOf.call(array, elem, i);
			}
			len = array.length;
			i = i ? i < 0 ? Math.max(0, len + i) : i : 0;
			for (; i < len; i++) {
				// Skip accessing in sparse arrays
				if (i in array && array[i] === elem) {
					return i;
				}
			}
		}
		return -1;
	}

	/**
	 * getStyleSheet - Returns a stylesheet object;
	 *
	 * @param	{string} id Text string
	 * @return {object}						Self
	 */
	function getStyleSheet(id) {
		var sheet=Mura('#' + id);
		if(sheet.length){
			return sheet.get(0).sheet;
		} else {
			Mura('HEAD').append('<style id="' + id +'" type="text/css"></style>');
			return Mura('#' + id).get(0).sheet;
		}
	}

	/**
	 * setRequestHeader - Initialiazes feed
	 *
	 * @name setRequestHeader
	 * @param	{string} headerName	Name of header
	 * @param	{string} value Header value
	 * @return {Mura.RequestContext} Self
	 * @memberof {class} Mura
	 */
	function setRequestHeader(headerName,value){
		Mura.requestHeaders[headerName]=value;
		return this;
	}

	/**
	 * getRequestHeader - Returns a request header value
	 *
	 * @name getRequestHeader
	 * @param	{string} headerName	Name of header
	 * @return {string} header Value
	 * @memberof {class} Mura
	 */
	 function getRequestHeader(headerName){
			if(typeof Mura.requestHeaders[headerName] != 'undefined'){
				return Mura.requestHeaders[headerName];
			} else {
				return null;
			}
	 }

	/**
	 * getRequestHeaders - Returns a request header value
	 *
	 * @name getRequestHeaders
	 * @return {object} All Headers
	 * @memberof {class} Mura
	 */
	 function getRequestHeaders(){
		 return Mura.requestHeaders;
	 }

	//http://werxltd.com/wp/2010/05/13/javascript-implementation-of-javas-string-hashcode-method/

	/**
	 * hashCode - description
	 *
	 * @name hashCode
	 * @param	{string} s String to hash
	 * @return {string}
	 * @memberof {class} Mura
	 */
	function hashCode(s) {
		var hash = 0,
			strlen = s.length,
			i, c;

		if (strlen === 0) {
			return hash;
		}
		for (i = 0; i < strlen; i++) {
			c = s.charCodeAt(i);
			hash = ((hash << 5) - hash) + c;
			hash = hash & hash; // Convert to 32bit integer
		}
		return (hash >>> 0);
	}

	/**
	 * Returns if the current request s running in Node.js
	**/
	function isInNode(){
		return typeof process !== 'undefined' && {}.toString.call(process) === '[object process]' || typeof document =='undefined';
	}

	/**
	 * Global Request Headers
	**/
	var requestHeaders={};

	function getBreakpoint(){
		if(typeof document != 'undefined'){
			var width=document.documentElement.clientWidth;
			
			if(Mura.editing){
				width=width-300;
			}
		
			if(width >=1200){
				return 'lg';
			} else if(width >=992){
				return 'md';
			} else if(width >=769){
				return 'sm';
			} else {
				return 'xs';
			}
		} else {
			return '';
		}
	}

	function throttle (func, interval) {
		var timeout;
		return function() {
		  var context = this, args = arguments;
		  var later = function () {
			timeout = false;
		  };
		  if (!timeout) {
			func.apply(context, args)
			timeout = true;
			setTimeout(later, interval)
		  }
		}
	}

	function debounce (func, interval) {
		var timeout;
		return function () {
		  var context = this, args = arguments;
		  var later = function () {
			timeout = null;
			func.apply(context, args);
		  };
		  clearTimeout(timeout);
		  timeout = setTimeout(later, interval || 200);
		}
	  }
	  
	//Mura.init
	function init(config) {

		if(typeof config.content != 'undefined'){
			if(typeof config.content.get == 'undefined'){
				config.content=getEntity('content').set(config.content);
			}
			Mura.extend(config,config.content.get('config'));
			
		}

		if (config.rootpath) {
			config.context = config.rootpath;
		}

		if (config.endpoint) {
			config.context = config.endpoint;
		}

		if (!config.context) {
			config.context = '';
		}

		if (!config.rootpath) {
			config.rootpath = config.context;
		}

		if (!config.assetpath) {
			config.assetpath = config.context + "/sites/" + config.siteid;
		}

		if (!config.siteassetpath) {
			config.siteassetpath = config.assetpath;
		}

		if (!config.fileassetpath) {
			config.fileassetpath = config.assetpath;
		}

		if (!config.apiEndpoint) {
			config.apiEndpoint = config.context +	'/index.cfm/_api/json/v1/' + config.siteid + '/';
		}

		if (!config.pluginspath) {
			config.pluginspath = config.context + '/plugins';
		}

		if (!config.corepath) {
			config.corepath = config.context + '/core';
		}

		if (!config.jslib) {
			config.jslib = 'jquery';
		}

		if (!config.perm) {
			config.perm = 'none';
		}

		if (typeof config.layoutmanager == 'undefined') {
			config.layoutmanager = false;
		}

		if (typeof config.mobileformat == 'undefined') {
			config.mobileformat = false;
		}

		if (typeof config.queueObjects == 'undefined') {
			config.queueObjects = true;
		}

		if (typeof config.rootdocumentdomain != 'undefined' && config.rootdocumentdomain != '') {
			document.domain = config.rootdocumentdomain;
		}

		if (typeof config.preloaderMarkup == 'undefined') {
			config.preloaderMarkup = '';
		}

		if (typeof config.rb == 'undefined') {
			config.rb={};
		}

		if (typeof config.dtExample == 'undefined') {
			config.dtExample="11/10/2018";
		}

		if (typeof config.dtCh == 'undefined') {
			config.dtCh="/";
		}

		if (typeof config.dtFormat == 'undefined') {
			config.dtFormat=[0,1,2];
		}

		if (typeof config.dtLocale == 'undefined') {
			config.dtLocale="en-US";
		}

		if (typeof config.useHTML5DateInput == 'undefined') {
			config.useHTML5DateInput=false;
		}

		if (typeof config.cookieConsentEnabled == 'undefined') {
			config.cookieConsentEnabled=false;
		}

		config.formdata=(typeof FormData != 'undefined') ? true : false;


		var initForDataOnly=false;

		if(typeof config.processMarkup != 'undefined'){
			initForDataOnly=typeof config.processMarkup != 'function' && !config.processMarkup;
			delete config.processMarkup;
		}

		extend(Mura, config);

		Mura.trackingMetadata={};
		Mura.hydrationData={}

		if(typeof config.content != 'undefined' && typeof config.content.get != 'undefined'  && config.content.get('displayregions')){
			for(var r in config.content.properties.displayregions){
				if( config.content.properties.displayregions.hasOwnProperty(r)){
					var data=config.content.properties.displayregions[r];
					if(typeof data.inherited != 'undefined' && typeof data.inherited.items != 'undefined'){
						for(var d in data.inherited.items){
							Mura.hydrationData[data.inherited.items[d].instanceid]=data.inherited.items[d];
						}
					}
					if(typeof data.local != 'undefined' && typeof data.local.items != 'undefined'){
						for(var d in data.local.items){
							Mura.hydrationData[data.local.items[d].instanceid]=data.local.items[d];
						}
					}
				}
			}
		}

		Mura.dateformat=generateDateFormat();

		if(Mura.mode.toLowerString=='rest'){
				Mura.apiEndpoint=Mura.apiEndpoint.replace('/json/', '/rest/');
		}

		if(typeof XMLHttpRequest == 'undefined'
			&& typeof Mura.request != 'undefined'
			&& typeof Mura.response != 'undefined'){

			Mura._requestcontext=Mura.getRequestContext(Mura.request,Mura.response);
		} else {
			Mura._requestcontext=Mura.getRequestContext();
		}

		if(typeof window !='undefined' &&typeof window.document != 'undefined'){
			if(Array.isArray(window.queuedMuraCmds) && window.queuedMuraCmds.length){
				holdingQueue=window.queuedMuraCmds.concat(holdingQueue);
				window.queuedMuraCmds=[];
			}

			if(Array.isArray(window.queuedMuraPreInitCmds) && window.queuedMuraPreInitCmds.length){
				holdingPreInitQueue=window.queuedMuraPreInitCmds.concat(holdingPreInitQueue);
				window.queuedMuraPreInitCmds=[];
			}
		}

		if(!initForDataOnly){

			destroyDisplayObjects();

			Mura(function() {
				for(var cmd in holdingPreInitQueue){
					if(typeof holdingPreInitQueue[cmd] == 'function'){
						holdingPreInitQueue[cmd](Mura);
					} else {
						console.log("PreInit queue item not a function");
						console.log(holdingPreInitQueue[cmd]);
					}
				}

				if(typeof window !='undefined' && typeof window.document != 'undefined'){
				
					var hash = location.hash;

					if (hash) {
						hash = hash.substring(1);
					}

					urlparams = setLowerCaseKeys(getQueryStringParams(location.search));
					
					if (hashparams.nextnid) {
						Mura('.mura-async-object[data-nextnid="' +
							hashparams.nextnid + '"]').each(
							function() {
								Mura(this).data(hashparams);
							});
					} else if (hashparams.objectid) {
						Mura('.mura-async-object[data-nextnid="' +hashparams.objectid + '"]').each(
						function() {
							Mura(this).data(hashparams);
						});
					}

					Mura(window).on('hashchange', handleHashChange);
					
					Mura(document).on('click','div.mura-object .mura-next-n a,div.mura-object .mura-search-results div.moreResults a,div.mura-object div.mura-pagination a',function(e){
						e.preventDefault();
						var href=Mura(e.target).attr('href');
						if(href!='#'){
							var hArray=href.split('?');
							var source=Mura(e.target);
							var data=setLowerCaseKeys(getQueryStringParams(hArray[hArray.length-1]));
							var obj=source.closest('div.mura-object');
							obj.data(data);
							processAsyncObject(obj.node).then(function(){
								try {
									if(typeof window != 'undefined' && typeof document != 'undefined'){
										var rect=obj.node.getBoundingClientRect();
										var elemTop = rect.top;
										if(elemTop < 0){
											window.scrollTo(0, Mura(document).scrollTop() + elemTop);
										}
									}
								} catch (e) {
									console.log(e)
								}							
							});	
						}
					})

					if(!Mura.inAdmin){
						processMarkup(document);
					}

					
					Mura.markupInitted=true;

					if(Mura.cookieConsentEnabled){Mura(function(){Mura('body').appendDisplayObject({object:'cookie_consent',queue:false,statsid:'cookie_consent'});});}

					Mura(document).on("keydown", function(event) {
						loginCheck(event.which);
					});
					
					Mura.breakpoint=getBreakpoint();
					Mura.windowResponsiveModules={};

					window.addEventListener("resize", function(){
			    	clearTimeout(Mura.windowResizeID);
			    	Mura.windowResizeID = setTimeout(doneResizing, 250);

						function doneResizing(){
							var breakpoint=getBreakpoint();
							if(breakpoint!=Mura.breakpoint){
								Mura.breakpoint=breakpoint;
							 	Mura('.mura-object').each(function(){
									var obj=Mura(this);
									var instanceid=obj.data('instanceid');
									if(typeof Mura.windowResponsiveModules[instanceid] == 'undefined' || Mura.windowResponsiveModules[instanceid]){
										obj.calculateDisplayObjectStyles(true);
									}
								});
							}
							delete Mura.windowResizeID;
						}
					});

					Mura(document).trigger('muraReady');
				}
			});

			readyInternal(initReadyQueue);
		}

		return Mura
	}

	var Mura=extend(
		function(selector, context) {
			if (typeof selector == 'function') {
				Mura.ready(selector);
				return this;
			} else {
				if (typeof context == 'undefined') {
					return select(selector);
				} else {
					return select(context).find(selector);
				}
			}
		}, {
			preInit:function(fn){if(holdingReady){holdingPreInitQueue.push(fn)}else{Mura(fn)}},
			generateOAuthToken: generateOAuthToken,
			entities: {},
			submitForm: submitForm,
			escapeHTML: escapeHTML,
			unescapeHTML: unescapeHTML,
			processDisplayObject: processDisplayObject,
			processModule:processModule,
			processAsyncObject: processAsyncObject,
			resetAsyncObject: resetAsyncObject,
			setLowerCaseKeys: setLowerCaseKeys,
			throttle:throttle,
			debounce:debounce,
			noSpam: noSpam,
			addLoadEvent: addLoadEvent,
			loader: loader,
			addEventHandler: addEventHandler,
			trigger: trigger,
			ready: ready,
			on: on,
			off: off,
			extend: extend,
			inArray: inArray,
			isNumeric: isNumeric,
			post: post,
			get: get,
			deepExtend: deepExtend,
			ajax: ajax,
			changeElementType: changeElementType,
			setHTMLEditor: setHTMLEditor,
			each: each,
			parseHTML: parseHTML,
			getData: getData,
			getProps: getProps,
			isEmptyObject: isEmptyObject,
			isScrolledIntoView: isScrolledIntoView,
			evalScripts: evalScripts,
			validateForm: validateForm,
			escape: $escape,
			unescape: $unescape,
			getBean: getEntity,
			getEntity: getEntity,
			getCurrentUser: getCurrentUser,
			renderFilename: renderFilename,
			findQuery: findQuery,
			getFeed: getFeed,
			login: login,
			logout: logout,
			extendClass: extendClass,
			init: init,
			formToObject: formToObject,
			createUUID: createUUID,
			isUUID: isUUID,
			processMarkup: processMarkup,
			getQueryStringParams: getQueryStringParams,
			layoutmanagertoolbar: layoutmanagertoolbar,
			parseString: parseString,
			createCookie: createCookie,
			readCookie: readCookie,
			trim: trim,
			hashCode: hashCode,
			DisplayObject: {},
			displayObjectInstances: {},
			destroyDisplayObjects: destroyDisplayObjects,
			destroyModules: destroyModules,
			holdReady: holdReady,
			trackEvent: trackEvent,
			recordEvent: trackEvent,
			isInNode: isInNode,
			getRequestContext: getRequestContext,
			getDefaultRequestContext: getDefaultRequestContext,
			requestHeaders:requestHeaders,
			setRequestHeader:setRequestHeader,
			getRequestHeader:getRequestHeaders,
			getRequestHeaders:getRequestHeaders,
			mode: 'json',
			declareEntity:declareEntity,
			undeclareEntity:undeclareEntity,
			buildDisplayRegion:buildDisplayRegion,
			openGate:openGate,
			firstToUpperCase:firstToUpperCase,
			normalizeRequestHandler:normalizeRequestHandler,
			getStyleSheet:getStyleSheet,
			getBreakpoint:getBreakpoint,
			inAdmin:false,
			lmv:2,
			homeid: '00000000000000000000000000000000001'
		}
	);

	Mura.Module=Mura.DisplayObject;
	return Mura;

})();

module.exports=Mura;

/* WEBPACK VAR INJECTION */}.call(this, __webpack_require__(133)))

/***/ }),
/* 10 */
/***/ (function(module, exports, __webpack_require__) {

// 7.1.13 ToObject(argument)
var defined = __webpack_require__(25);
module.exports = function (it) {
  return Object(defined(it));
};


/***/ }),
/* 11 */
/***/ (function(module, exports) {

module.exports = function (it) {
  if (typeof it != 'function') throw TypeError(it + ' is not a function!');
  return it;
};


/***/ }),
/* 12 */
/***/ (function(module, exports, __webpack_require__) {

var dP = __webpack_require__(8);
var createDesc = __webpack_require__(34);
module.exports = __webpack_require__(7) ? function (object, key, value) {
  return dP.f(object, key, createDesc(1, value));
} : function (object, key, value) {
  object[key] = value;
  return object;
};


/***/ }),
/* 13 */
/***/ (function(module, exports, __webpack_require__) {

var global = __webpack_require__(2);
var hide = __webpack_require__(12);
var has = __webpack_require__(15);
var SRC = __webpack_require__(35)('src');
var $toString = __webpack_require__(142);
var TO_STRING = 'toString';
var TPL = ('' + $toString).split(TO_STRING);

__webpack_require__(19).inspectSource = function (it) {
  return $toString.call(it);
};

(module.exports = function (O, key, val, safe) {
  var isFunction = typeof val == 'function';
  if (isFunction) has(val, 'name') || hide(val, 'name', key);
  if (O[key] === val) return;
  if (isFunction) has(val, SRC) || hide(val, SRC, O[key] ? '' + O[key] : TPL.join(String(key)));
  if (O === global) {
    O[key] = val;
  } else if (!safe) {
    delete O[key];
    hide(O, key, val);
  } else if (O[key]) {
    O[key] = val;
  } else {
    hide(O, key, val);
  }
// add fake Function#toString for correct work wrapped methods / constructors with methods like LoDash isNative
})(Function.prototype, TO_STRING, function toString() {
  return typeof this == 'function' && this[SRC] || $toString.call(this);
});


/***/ }),
/* 14 */
/***/ (function(module, exports, __webpack_require__) {

var $export = __webpack_require__(0);
var fails = __webpack_require__(3);
var defined = __webpack_require__(25);
var quot = /"/g;
// B.2.3.2.1 CreateHTML(string, tag, attribute, value)
var createHTML = function (string, tag, attribute, value) {
  var S = String(defined(string));
  var p1 = '<' + tag;
  if (attribute !== '') p1 += ' ' + attribute + '="' + String(value).replace(quot, '&quot;') + '"';
  return p1 + '>' + S + '</' + tag + '>';
};
module.exports = function (NAME, exec) {
  var O = {};
  O[NAME] = exec(createHTML);
  $export($export.P + $export.F * fails(function () {
    var test = ''[NAME]('"');
    return test !== test.toLowerCase() || test.split('"').length > 3;
  }), 'String', O);
};


/***/ }),
/* 15 */
/***/ (function(module, exports) {

var hasOwnProperty = {}.hasOwnProperty;
module.exports = function (it, key) {
  return hasOwnProperty.call(it, key);
};


/***/ }),
/* 16 */
/***/ (function(module, exports, __webpack_require__) {

// to indexed object, toObject with fallback for non-array-like ES3 strings
var IObject = __webpack_require__(51);
var defined = __webpack_require__(25);
module.exports = function (it) {
  return IObject(defined(it));
};


/***/ }),
/* 17 */
/***/ (function(module, exports, __webpack_require__) {

var pIE = __webpack_require__(52);
var createDesc = __webpack_require__(34);
var toIObject = __webpack_require__(16);
var toPrimitive = __webpack_require__(24);
var has = __webpack_require__(15);
var IE8_DOM_DEFINE = __webpack_require__(97);
var gOPD = Object.getOwnPropertyDescriptor;

exports.f = __webpack_require__(7) ? gOPD : function getOwnPropertyDescriptor(O, P) {
  O = toIObject(O);
  P = toPrimitive(P, true);
  if (IE8_DOM_DEFINE) try {
    return gOPD(O, P);
  } catch (e) { /* empty */ }
  if (has(O, P)) return createDesc(!pIE.f.call(O, P), O[P]);
};


/***/ }),
/* 18 */
/***/ (function(module, exports, __webpack_require__) {

// 19.1.2.9 / 15.2.3.2 Object.getPrototypeOf(O)
var has = __webpack_require__(15);
var toObject = __webpack_require__(10);
var IE_PROTO = __webpack_require__(72)('IE_PROTO');
var ObjectProto = Object.prototype;

module.exports = Object.getPrototypeOf || function (O) {
  O = toObject(O);
  if (has(O, IE_PROTO)) return O[IE_PROTO];
  if (typeof O.constructor == 'function' && O instanceof O.constructor) {
    return O.constructor.prototype;
  } return O instanceof Object ? ObjectProto : null;
};


/***/ }),
/* 19 */
/***/ (function(module, exports) {

var core = module.exports = { version: '2.6.11' };
if (typeof __e == 'number') __e = core; // eslint-disable-line no-undef


/***/ }),
/* 20 */
/***/ (function(module, exports, __webpack_require__) {

// optional / simple context binding
var aFunction = __webpack_require__(11);
module.exports = function (fn, that, length) {
  aFunction(fn);
  if (that === undefined) return fn;
  switch (length) {
    case 1: return function (a) {
      return fn.call(that, a);
    };
    case 2: return function (a, b) {
      return fn.call(that, a, b);
    };
    case 3: return function (a, b, c) {
      return fn.call(that, a, b, c);
    };
  }
  return function (/* ...args */) {
    return fn.apply(that, arguments);
  };
};


/***/ }),
/* 21 */
/***/ (function(module, exports) {

var toString = {}.toString;

module.exports = function (it) {
  return toString.call(it).slice(8, -1);
};


/***/ }),
/* 22 */
/***/ (function(module, exports) {

// 7.1.4 ToInteger
var ceil = Math.ceil;
var floor = Math.floor;
module.exports = function (it) {
  return isNaN(it = +it) ? 0 : (it > 0 ? floor : ceil)(it);
};


/***/ }),
/* 23 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var fails = __webpack_require__(3);

module.exports = function (method, arg) {
  return !!method && fails(function () {
    // eslint-disable-next-line no-useless-call
    arg ? method.call(null, function () { /* empty */ }, 1) : method.call(null);
  });
};


/***/ }),
/* 24 */
/***/ (function(module, exports, __webpack_require__) {

// 7.1.1 ToPrimitive(input [, PreferredType])
var isObject = __webpack_require__(4);
// instead of the ES6 spec version, we didn't implement @@toPrimitive case
// and the second argument - flag - preferred type is a string
module.exports = function (it, S) {
  if (!isObject(it)) return it;
  var fn, val;
  if (S && typeof (fn = it.toString) == 'function' && !isObject(val = fn.call(it))) return val;
  if (typeof (fn = it.valueOf) == 'function' && !isObject(val = fn.call(it))) return val;
  if (!S && typeof (fn = it.toString) == 'function' && !isObject(val = fn.call(it))) return val;
  throw TypeError("Can't convert object to primitive value");
};


/***/ }),
/* 25 */
/***/ (function(module, exports) {

// 7.2.1 RequireObjectCoercible(argument)
module.exports = function (it) {
  if (it == undefined) throw TypeError("Can't call method on  " + it);
  return it;
};


/***/ }),
/* 26 */
/***/ (function(module, exports, __webpack_require__) {

// most Object methods by ES6 should accept primitives
var $export = __webpack_require__(0);
var core = __webpack_require__(19);
var fails = __webpack_require__(3);
module.exports = function (KEY, exec) {
  var fn = (core.Object || {})[KEY] || Object[KEY];
  var exp = {};
  exp[KEY] = exec(fn);
  $export($export.S + $export.F * fails(function () { fn(1); }), 'Object', exp);
};


/***/ }),
/* 27 */
/***/ (function(module, exports, __webpack_require__) {

// 0 -> Array#forEach
// 1 -> Array#map
// 2 -> Array#filter
// 3 -> Array#some
// 4 -> Array#every
// 5 -> Array#find
// 6 -> Array#findIndex
var ctx = __webpack_require__(20);
var IObject = __webpack_require__(51);
var toObject = __webpack_require__(10);
var toLength = __webpack_require__(6);
var asc = __webpack_require__(88);
module.exports = function (TYPE, $create) {
  var IS_MAP = TYPE == 1;
  var IS_FILTER = TYPE == 2;
  var IS_SOME = TYPE == 3;
  var IS_EVERY = TYPE == 4;
  var IS_FIND_INDEX = TYPE == 6;
  var NO_HOLES = TYPE == 5 || IS_FIND_INDEX;
  var create = $create || asc;
  return function ($this, callbackfn, that) {
    var O = toObject($this);
    var self = IObject(O);
    var f = ctx(callbackfn, that, 3);
    var length = toLength(self.length);
    var index = 0;
    var result = IS_MAP ? create($this, length) : IS_FILTER ? create($this, 0) : undefined;
    var val, res;
    for (;length > index; index++) if (NO_HOLES || index in self) {
      val = self[index];
      res = f(val, index, O);
      if (TYPE) {
        if (IS_MAP) result[index] = res;   // map
        else if (res) switch (TYPE) {
          case 3: return true;             // some
          case 5: return val;              // find
          case 6: return index;            // findIndex
          case 2: result.push(val);        // filter
        } else if (IS_EVERY) return false; // every
      }
    }
    return IS_FIND_INDEX ? -1 : IS_SOME || IS_EVERY ? IS_EVERY : result;
  };
};


/***/ }),
/* 28 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;
exports.extend = extend;
exports.indexOf = indexOf;
exports.escapeExpression = escapeExpression;
exports.isEmpty = isEmpty;
exports.createFrame = createFrame;
exports.blockParams = blockParams;
exports.appendContextPath = appendContextPath;
var escape = {
  '&': '&amp;',
  '<': '&lt;',
  '>': '&gt;',
  '"': '&quot;',
  "'": '&#x27;',
  '`': '&#x60;',
  '=': '&#x3D;'
};

var badChars = /[&<>"'`=]/g,
    possible = /[&<>"'`=]/;

function escapeChar(chr) {
  return escape[chr];
}

function extend(obj /* , ...source */) {
  for (var i = 1; i < arguments.length; i++) {
    for (var key in arguments[i]) {
      if (Object.prototype.hasOwnProperty.call(arguments[i], key)) {
        obj[key] = arguments[i][key];
      }
    }
  }

  return obj;
}

var toString = Object.prototype.toString;

exports.toString = toString;
// Sourced from lodash
// https://github.com/bestiejs/lodash/blob/master/LICENSE.txt
/* eslint-disable func-style */
var isFunction = function isFunction(value) {
  return typeof value === 'function';
};
// fallback for older versions of Chrome and Safari
/* istanbul ignore next */
if (isFunction(/x/)) {
  exports.isFunction = isFunction = function (value) {
    return typeof value === 'function' && toString.call(value) === '[object Function]';
  };
}
exports.isFunction = isFunction;

/* eslint-enable func-style */

/* istanbul ignore next */
var isArray = Array.isArray || function (value) {
  return value && typeof value === 'object' ? toString.call(value) === '[object Array]' : false;
};

exports.isArray = isArray;
// Older IE versions do not directly support indexOf so we must implement our own, sadly.

function indexOf(array, value) {
  for (var i = 0, len = array.length; i < len; i++) {
    if (array[i] === value) {
      return i;
    }
  }
  return -1;
}

function escapeExpression(string) {
  if (typeof string !== 'string') {
    // don't escape SafeStrings, since they're already safe
    if (string && string.toHTML) {
      return string.toHTML();
    } else if (string == null) {
      return '';
    } else if (!string) {
      return string + '';
    }

    // Force a string conversion as this will be done by the append regardless and
    // the regex test will do this transparently behind the scenes, causing issues if
    // an object's to string has escaped characters in it.
    string = '' + string;
  }

  if (!possible.test(string)) {
    return string;
  }
  return string.replace(badChars, escapeChar);
}

function isEmpty(value) {
  if (!value && value !== 0) {
    return true;
  } else if (isArray(value) && value.length === 0) {
    return true;
  } else {
    return false;
  }
}

function createFrame(object) {
  var frame = extend({}, object);
  frame._parent = object;
  return frame;
}

function blockParams(params, ids) {
  params.path = ids;
  return params;
}

function appendContextPath(contextPath, id) {
  return (contextPath ? contextPath + '.' : '') + id;
}
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL3V0aWxzLmpzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7Ozs7Ozs7Ozs7QUFBQSxJQUFNLE1BQU0sR0FBRztBQUNiLEtBQUcsRUFBRSxPQUFPO0FBQ1osS0FBRyxFQUFFLE1BQU07QUFDWCxLQUFHLEVBQUUsTUFBTTtBQUNYLEtBQUcsRUFBRSxRQUFRO0FBQ2IsS0FBRyxFQUFFLFFBQVE7QUFDYixLQUFHLEVBQUUsUUFBUTtBQUNiLEtBQUcsRUFBRSxRQUFRO0NBQ2QsQ0FBQzs7QUFFRixJQUFNLFFBQVEsR0FBRyxZQUFZO0lBQzNCLFFBQVEsR0FBRyxXQUFXLENBQUM7O0FBRXpCLFNBQVMsVUFBVSxDQUFDLEdBQUcsRUFBRTtBQUN2QixTQUFPLE1BQU0sQ0FBQyxHQUFHLENBQUMsQ0FBQztDQUNwQjs7QUFFTSxTQUFTLE1BQU0sQ0FBQyxHQUFHLG9CQUFvQjtBQUM1QyxPQUFLLElBQUksQ0FBQyxHQUFHLENBQUMsRUFBRSxDQUFDLEdBQUcsU0FBUyxDQUFDLE1BQU0sRUFBRSxDQUFDLEVBQUUsRUFBRTtBQUN6QyxTQUFLLElBQUksR0FBRyxJQUFJLFNBQVMsQ0FBQyxDQUFDLENBQUMsRUFBRTtBQUM1QixVQUFJLE1BQU0sQ0FBQyxTQUFTLENBQUMsY0FBYyxDQUFDLElBQUksQ0FBQyxTQUFTLENBQUMsQ0FBQyxDQUFDLEVBQUUsR0FBRyxDQUFDLEVBQUU7QUFDM0QsV0FBRyxDQUFDLEdBQUcsQ0FBQyxHQUFHLFNBQVMsQ0FBQyxDQUFDLENBQUMsQ0FBQyxHQUFHLENBQUMsQ0FBQztPQUM5QjtLQUNGO0dBQ0Y7O0FBRUQsU0FBTyxHQUFHLENBQUM7Q0FDWjs7QUFFTSxJQUFJLFFBQVEsR0FBRyxNQUFNLENBQUMsU0FBUyxDQUFDLFFBQVEsQ0FBQzs7Ozs7O0FBS2hELElBQUksVUFBVSxHQUFHLG9CQUFTLEtBQUssRUFBRTtBQUMvQixTQUFPLE9BQU8sS0FBSyxLQUFLLFVBQVUsQ0FBQztDQUNwQyxDQUFDOzs7QUFHRixJQUFJLFVBQVUsQ0FBQyxHQUFHLENBQUMsRUFBRTtBQUNuQixVQU9PLFVBQVUsR0FQakIsVUFBVSxHQUFHLFVBQVMsS0FBSyxFQUFFO0FBQzNCLFdBQ0UsT0FBTyxLQUFLLEtBQUssVUFBVSxJQUMzQixRQUFRLENBQUMsSUFBSSxDQUFDLEtBQUssQ0FBQyxLQUFLLG1CQUFtQixDQUM1QztHQUNILENBQUM7Q0FDSDtRQUNRLFVBQVUsR0FBVixVQUFVOzs7OztBQUlaLElBQU0sT0FBTyxHQUNsQixLQUFLLENBQUMsT0FBTyxJQUNiLFVBQVMsS0FBSyxFQUFFO0FBQ2QsU0FBTyxLQUFLLElBQUksT0FBTyxLQUFLLEtBQUssUUFBUSxHQUNyQyxRQUFRLENBQUMsSUFBSSxDQUFDLEtBQUssQ0FBQyxLQUFLLGdCQUFnQixHQUN6QyxLQUFLLENBQUM7Q0FDWCxDQUFDOzs7OztBQUdHLFNBQVMsT0FBTyxDQUFDLEtBQUssRUFBRSxLQUFLLEVBQUU7QUFDcEMsT0FBSyxJQUFJLENBQUMsR0FBRyxDQUFDLEVBQUUsR0FBRyxHQUFHLEtBQUssQ0FBQyxNQUFNLEVBQUUsQ0FBQyxHQUFHLEdBQUcsRUFBRSxDQUFDLEVBQUUsRUFBRTtBQUNoRCxRQUFJLEtBQUssQ0FBQyxDQUFDLENBQUMsS0FBSyxLQUFLLEVBQUU7QUFDdEIsYUFBTyxDQUFDLENBQUM7S0FDVjtHQUNGO0FBQ0QsU0FBTyxDQUFDLENBQUMsQ0FBQztDQUNYOztBQUVNLFNBQVMsZ0JBQWdCLENBQUMsTUFBTSxFQUFFO0FBQ3ZDLE1BQUksT0FBTyxNQUFNLEtBQUssUUFBUSxFQUFFOztBQUU5QixRQUFJLE1BQU0sSUFBSSxNQUFNLENBQUMsTUFBTSxFQUFFO0FBQzNCLGFBQU8sTUFBTSxDQUFDLE1BQU0sRUFBRSxDQUFDO0tBQ3hCLE1BQU0sSUFBSSxNQUFNLElBQUksSUFBSSxFQUFFO0FBQ3pCLGFBQU8sRUFBRSxDQUFDO0tBQ1gsTUFBTSxJQUFJLENBQUMsTUFBTSxFQUFFO0FBQ2xCLGFBQU8sTUFBTSxHQUFHLEVBQUUsQ0FBQztLQUNwQjs7Ozs7QUFLRCxVQUFNLEdBQUcsRUFBRSxHQUFHLE1BQU0sQ0FBQztHQUN0Qjs7QUFFRCxNQUFJLENBQUMsUUFBUSxDQUFDLElBQUksQ0FBQyxNQUFNLENBQUMsRUFBRTtBQUMxQixXQUFPLE1BQU0sQ0FBQztHQUNmO0FBQ0QsU0FBTyxNQUFNLENBQUMsT0FBTyxDQUFDLFFBQVEsRUFBRSxVQUFVLENBQUMsQ0FBQztDQUM3Qzs7QUFFTSxTQUFTLE9BQU8sQ0FBQyxLQUFLLEVBQUU7QUFDN0IsTUFBSSxDQUFDLEtBQUssSUFBSSxLQUFLLEtBQUssQ0FBQyxFQUFFO0FBQ3pCLFdBQU8sSUFBSSxDQUFDO0dBQ2IsTUFBTSxJQUFJLE9BQU8sQ0FBQyxLQUFLLENBQUMsSUFBSSxLQUFLLENBQUMsTUFBTSxLQUFLLENBQUMsRUFBRTtBQUMvQyxXQUFPLElBQUksQ0FBQztHQUNiLE1BQU07QUFDTCxXQUFPLEtBQUssQ0FBQztHQUNkO0NBQ0Y7O0FBRU0sU0FBUyxXQUFXLENBQUMsTUFBTSxFQUFFO0FBQ2xDLE1BQUksS0FBSyxHQUFHLE1BQU0sQ0FBQyxFQUFFLEVBQUUsTUFBTSxDQUFDLENBQUM7QUFDL0IsT0FBSyxDQUFDLE9BQU8sR0FBRyxNQUFNLENBQUM7QUFDdkIsU0FBTyxLQUFLLENBQUM7Q0FDZDs7QUFFTSxTQUFTLFdBQVcsQ0FBQyxNQUFNLEVBQUUsR0FBRyxFQUFFO0FBQ3ZDLFFBQU0sQ0FBQyxJQUFJLEdBQUcsR0FBRyxDQUFDO0FBQ2xCLFNBQU8sTUFBTSxDQUFDO0NBQ2Y7O0FBRU0sU0FBUyxpQkFBaUIsQ0FBQyxXQUFXLEVBQUUsRUFBRSxFQUFFO0FBQ2pELFNBQU8sQ0FBQyxXQUFXLEdBQUcsV0FBVyxHQUFHLEdBQUcsR0FBRyxFQUFFLENBQUEsR0FBSSxFQUFFLENBQUM7Q0FDcEQiLCJmaWxlIjoidXRpbHMuanMiLCJzb3VyY2VzQ29udGVudCI6WyJjb25zdCBlc2NhcGUgPSB7XG4gICcmJzogJyZhbXA7JyxcbiAgJzwnOiAnJmx0OycsXG4gICc+JzogJyZndDsnLFxuICAnXCInOiAnJnF1b3Q7JyxcbiAgXCInXCI6ICcmI3gyNzsnLFxuICAnYCc6ICcmI3g2MDsnLFxuICAnPSc6ICcmI3gzRDsnXG59O1xuXG5jb25zdCBiYWRDaGFycyA9IC9bJjw+XCInYD1dL2csXG4gIHBvc3NpYmxlID0gL1smPD5cIidgPV0vO1xuXG5mdW5jdGlvbiBlc2NhcGVDaGFyKGNocikge1xuICByZXR1cm4gZXNjYXBlW2Nocl07XG59XG5cbmV4cG9ydCBmdW5jdGlvbiBleHRlbmQob2JqIC8qICwgLi4uc291cmNlICovKSB7XG4gIGZvciAobGV0IGkgPSAxOyBpIDwgYXJndW1lbnRzLmxlbmd0aDsgaSsrKSB7XG4gICAgZm9yIChsZXQga2V5IGluIGFyZ3VtZW50c1tpXSkge1xuICAgICAgaWYgKE9iamVjdC5wcm90b3R5cGUuaGFzT3duUHJvcGVydHkuY2FsbChhcmd1bWVudHNbaV0sIGtleSkpIHtcbiAgICAgICAgb2JqW2tleV0gPSBhcmd1bWVudHNbaV1ba2V5XTtcbiAgICAgIH1cbiAgICB9XG4gIH1cblxuICByZXR1cm4gb2JqO1xufVxuXG5leHBvcnQgbGV0IHRvU3RyaW5nID0gT2JqZWN0LnByb3RvdHlwZS50b1N0cmluZztcblxuLy8gU291cmNlZCBmcm9tIGxvZGFzaFxuLy8gaHR0cHM6Ly9naXRodWIuY29tL2Jlc3RpZWpzL2xvZGFzaC9ibG9iL21hc3Rlci9MSUNFTlNFLnR4dFxuLyogZXNsaW50LWRpc2FibGUgZnVuYy1zdHlsZSAqL1xubGV0IGlzRnVuY3Rpb24gPSBmdW5jdGlvbih2YWx1ZSkge1xuICByZXR1cm4gdHlwZW9mIHZhbHVlID09PSAnZnVuY3Rpb24nO1xufTtcbi8vIGZhbGxiYWNrIGZvciBvbGRlciB2ZXJzaW9ucyBvZiBDaHJvbWUgYW5kIFNhZmFyaVxuLyogaXN0YW5idWwgaWdub3JlIG5leHQgKi9cbmlmIChpc0Z1bmN0aW9uKC94LykpIHtcbiAgaXNGdW5jdGlvbiA9IGZ1bmN0aW9uKHZhbHVlKSB7XG4gICAgcmV0dXJuIChcbiAgICAgIHR5cGVvZiB2YWx1ZSA9PT0gJ2Z1bmN0aW9uJyAmJlxuICAgICAgdG9TdHJpbmcuY2FsbCh2YWx1ZSkgPT09ICdbb2JqZWN0IEZ1bmN0aW9uXSdcbiAgICApO1xuICB9O1xufVxuZXhwb3J0IHsgaXNGdW5jdGlvbiB9O1xuLyogZXNsaW50LWVuYWJsZSBmdW5jLXN0eWxlICovXG5cbi8qIGlzdGFuYnVsIGlnbm9yZSBuZXh0ICovXG5leHBvcnQgY29uc3QgaXNBcnJheSA9XG4gIEFycmF5LmlzQXJyYXkgfHxcbiAgZnVuY3Rpb24odmFsdWUpIHtcbiAgICByZXR1cm4gdmFsdWUgJiYgdHlwZW9mIHZhbHVlID09PSAnb2JqZWN0J1xuICAgICAgPyB0b1N0cmluZy5jYWxsKHZhbHVlKSA9PT0gJ1tvYmplY3QgQXJyYXldJ1xuICAgICAgOiBmYWxzZTtcbiAgfTtcblxuLy8gT2xkZXIgSUUgdmVyc2lvbnMgZG8gbm90IGRpcmVjdGx5IHN1cHBvcnQgaW5kZXhPZiBzbyB3ZSBtdXN0IGltcGxlbWVudCBvdXIgb3duLCBzYWRseS5cbmV4cG9ydCBmdW5jdGlvbiBpbmRleE9mKGFycmF5LCB2YWx1ZSkge1xuICBmb3IgKGxldCBpID0gMCwgbGVuID0gYXJyYXkubGVuZ3RoOyBpIDwgbGVuOyBpKyspIHtcbiAgICBpZiAoYXJyYXlbaV0gPT09IHZhbHVlKSB7XG4gICAgICByZXR1cm4gaTtcbiAgICB9XG4gIH1cbiAgcmV0dXJuIC0xO1xufVxuXG5leHBvcnQgZnVuY3Rpb24gZXNjYXBlRXhwcmVzc2lvbihzdHJpbmcpIHtcbiAgaWYgKHR5cGVvZiBzdHJpbmcgIT09ICdzdHJpbmcnKSB7XG4gICAgLy8gZG9uJ3QgZXNjYXBlIFNhZmVTdHJpbmdzLCBzaW5jZSB0aGV5J3JlIGFscmVhZHkgc2FmZVxuICAgIGlmIChzdHJpbmcgJiYgc3RyaW5nLnRvSFRNTCkge1xuICAgICAgcmV0dXJuIHN0cmluZy50b0hUTUwoKTtcbiAgICB9IGVsc2UgaWYgKHN0cmluZyA9PSBudWxsKSB7XG4gICAgICByZXR1cm4gJyc7XG4gICAgfSBlbHNlIGlmICghc3RyaW5nKSB7XG4gICAgICByZXR1cm4gc3RyaW5nICsgJyc7XG4gICAgfVxuXG4gICAgLy8gRm9yY2UgYSBzdHJpbmcgY29udmVyc2lvbiBhcyB0aGlzIHdpbGwgYmUgZG9uZSBieSB0aGUgYXBwZW5kIHJlZ2FyZGxlc3MgYW5kXG4gICAgLy8gdGhlIHJlZ2V4IHRlc3Qgd2lsbCBkbyB0aGlzIHRyYW5zcGFyZW50bHkgYmVoaW5kIHRoZSBzY2VuZXMsIGNhdXNpbmcgaXNzdWVzIGlmXG4gICAgLy8gYW4gb2JqZWN0J3MgdG8gc3RyaW5nIGhhcyBlc2NhcGVkIGNoYXJhY3RlcnMgaW4gaXQuXG4gICAgc3RyaW5nID0gJycgKyBzdHJpbmc7XG4gIH1cblxuICBpZiAoIXBvc3NpYmxlLnRlc3Qoc3RyaW5nKSkge1xuICAgIHJldHVybiBzdHJpbmc7XG4gIH1cbiAgcmV0dXJuIHN0cmluZy5yZXBsYWNlKGJhZENoYXJzLCBlc2NhcGVDaGFyKTtcbn1cblxuZXhwb3J0IGZ1bmN0aW9uIGlzRW1wdHkodmFsdWUpIHtcbiAgaWYgKCF2YWx1ZSAmJiB2YWx1ZSAhPT0gMCkge1xuICAgIHJldHVybiB0cnVlO1xuICB9IGVsc2UgaWYgKGlzQXJyYXkodmFsdWUpICYmIHZhbHVlLmxlbmd0aCA9PT0gMCkge1xuICAgIHJldHVybiB0cnVlO1xuICB9IGVsc2Uge1xuICAgIHJldHVybiBmYWxzZTtcbiAgfVxufVxuXG5leHBvcnQgZnVuY3Rpb24gY3JlYXRlRnJhbWUob2JqZWN0KSB7XG4gIGxldCBmcmFtZSA9IGV4dGVuZCh7fSwgb2JqZWN0KTtcbiAgZnJhbWUuX3BhcmVudCA9IG9iamVjdDtcbiAgcmV0dXJuIGZyYW1lO1xufVxuXG5leHBvcnQgZnVuY3Rpb24gYmxvY2tQYXJhbXMocGFyYW1zLCBpZHMpIHtcbiAgcGFyYW1zLnBhdGggPSBpZHM7XG4gIHJldHVybiBwYXJhbXM7XG59XG5cbmV4cG9ydCBmdW5jdGlvbiBhcHBlbmRDb250ZXh0UGF0aChjb250ZXh0UGF0aCwgaWQpIHtcbiAgcmV0dXJuIChjb250ZXh0UGF0aCA/IGNvbnRleHRQYXRoICsgJy4nIDogJycpICsgaWQ7XG59XG4iXX0=


/***/ }),
/* 29 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

if (__webpack_require__(7)) {
  var LIBRARY = __webpack_require__(31);
  var global = __webpack_require__(2);
  var fails = __webpack_require__(3);
  var $export = __webpack_require__(0);
  var $typed = __webpack_require__(66);
  var $buffer = __webpack_require__(96);
  var ctx = __webpack_require__(20);
  var anInstance = __webpack_require__(41);
  var propertyDesc = __webpack_require__(34);
  var hide = __webpack_require__(12);
  var redefineAll = __webpack_require__(43);
  var toInteger = __webpack_require__(22);
  var toLength = __webpack_require__(6);
  var toIndex = __webpack_require__(125);
  var toAbsoluteIndex = __webpack_require__(37);
  var toPrimitive = __webpack_require__(24);
  var has = __webpack_require__(15);
  var classof = __webpack_require__(47);
  var isObject = __webpack_require__(4);
  var toObject = __webpack_require__(10);
  var isArrayIter = __webpack_require__(85);
  var create = __webpack_require__(38);
  var getPrototypeOf = __webpack_require__(18);
  var gOPN = __webpack_require__(39).f;
  var getIterFn = __webpack_require__(87);
  var uid = __webpack_require__(35);
  var wks = __webpack_require__(5);
  var createArrayMethod = __webpack_require__(27);
  var createArrayIncludes = __webpack_require__(56);
  var speciesConstructor = __webpack_require__(54);
  var ArrayIterators = __webpack_require__(90);
  var Iterators = __webpack_require__(49);
  var $iterDetect = __webpack_require__(61);
  var setSpecies = __webpack_require__(40);
  var arrayFill = __webpack_require__(89);
  var arrayCopyWithin = __webpack_require__(114);
  var $DP = __webpack_require__(8);
  var $GOPD = __webpack_require__(17);
  var dP = $DP.f;
  var gOPD = $GOPD.f;
  var RangeError = global.RangeError;
  var TypeError = global.TypeError;
  var Uint8Array = global.Uint8Array;
  var ARRAY_BUFFER = 'ArrayBuffer';
  var SHARED_BUFFER = 'Shared' + ARRAY_BUFFER;
  var BYTES_PER_ELEMENT = 'BYTES_PER_ELEMENT';
  var PROTOTYPE = 'prototype';
  var ArrayProto = Array[PROTOTYPE];
  var $ArrayBuffer = $buffer.ArrayBuffer;
  var $DataView = $buffer.DataView;
  var arrayForEach = createArrayMethod(0);
  var arrayFilter = createArrayMethod(2);
  var arraySome = createArrayMethod(3);
  var arrayEvery = createArrayMethod(4);
  var arrayFind = createArrayMethod(5);
  var arrayFindIndex = createArrayMethod(6);
  var arrayIncludes = createArrayIncludes(true);
  var arrayIndexOf = createArrayIncludes(false);
  var arrayValues = ArrayIterators.values;
  var arrayKeys = ArrayIterators.keys;
  var arrayEntries = ArrayIterators.entries;
  var arrayLastIndexOf = ArrayProto.lastIndexOf;
  var arrayReduce = ArrayProto.reduce;
  var arrayReduceRight = ArrayProto.reduceRight;
  var arrayJoin = ArrayProto.join;
  var arraySort = ArrayProto.sort;
  var arraySlice = ArrayProto.slice;
  var arrayToString = ArrayProto.toString;
  var arrayToLocaleString = ArrayProto.toLocaleString;
  var ITERATOR = wks('iterator');
  var TAG = wks('toStringTag');
  var TYPED_CONSTRUCTOR = uid('typed_constructor');
  var DEF_CONSTRUCTOR = uid('def_constructor');
  var ALL_CONSTRUCTORS = $typed.CONSTR;
  var TYPED_ARRAY = $typed.TYPED;
  var VIEW = $typed.VIEW;
  var WRONG_LENGTH = 'Wrong length!';

  var $map = createArrayMethod(1, function (O, length) {
    return allocate(speciesConstructor(O, O[DEF_CONSTRUCTOR]), length);
  });

  var LITTLE_ENDIAN = fails(function () {
    // eslint-disable-next-line no-undef
    return new Uint8Array(new Uint16Array([1]).buffer)[0] === 1;
  });

  var FORCED_SET = !!Uint8Array && !!Uint8Array[PROTOTYPE].set && fails(function () {
    new Uint8Array(1).set({});
  });

  var toOffset = function (it, BYTES) {
    var offset = toInteger(it);
    if (offset < 0 || offset % BYTES) throw RangeError('Wrong offset!');
    return offset;
  };

  var validate = function (it) {
    if (isObject(it) && TYPED_ARRAY in it) return it;
    throw TypeError(it + ' is not a typed array!');
  };

  var allocate = function (C, length) {
    if (!(isObject(C) && TYPED_CONSTRUCTOR in C)) {
      throw TypeError('It is not a typed array constructor!');
    } return new C(length);
  };

  var speciesFromList = function (O, list) {
    return fromList(speciesConstructor(O, O[DEF_CONSTRUCTOR]), list);
  };

  var fromList = function (C, list) {
    var index = 0;
    var length = list.length;
    var result = allocate(C, length);
    while (length > index) result[index] = list[index++];
    return result;
  };

  var addGetter = function (it, key, internal) {
    dP(it, key, { get: function () { return this._d[internal]; } });
  };

  var $from = function from(source /* , mapfn, thisArg */) {
    var O = toObject(source);
    var aLen = arguments.length;
    var mapfn = aLen > 1 ? arguments[1] : undefined;
    var mapping = mapfn !== undefined;
    var iterFn = getIterFn(O);
    var i, length, values, result, step, iterator;
    if (iterFn != undefined && !isArrayIter(iterFn)) {
      for (iterator = iterFn.call(O), values = [], i = 0; !(step = iterator.next()).done; i++) {
        values.push(step.value);
      } O = values;
    }
    if (mapping && aLen > 2) mapfn = ctx(mapfn, arguments[2], 2);
    for (i = 0, length = toLength(O.length), result = allocate(this, length); length > i; i++) {
      result[i] = mapping ? mapfn(O[i], i) : O[i];
    }
    return result;
  };

  var $of = function of(/* ...items */) {
    var index = 0;
    var length = arguments.length;
    var result = allocate(this, length);
    while (length > index) result[index] = arguments[index++];
    return result;
  };

  // iOS Safari 6.x fails here
  var TO_LOCALE_BUG = !!Uint8Array && fails(function () { arrayToLocaleString.call(new Uint8Array(1)); });

  var $toLocaleString = function toLocaleString() {
    return arrayToLocaleString.apply(TO_LOCALE_BUG ? arraySlice.call(validate(this)) : validate(this), arguments);
  };

  var proto = {
    copyWithin: function copyWithin(target, start /* , end */) {
      return arrayCopyWithin.call(validate(this), target, start, arguments.length > 2 ? arguments[2] : undefined);
    },
    every: function every(callbackfn /* , thisArg */) {
      return arrayEvery(validate(this), callbackfn, arguments.length > 1 ? arguments[1] : undefined);
    },
    fill: function fill(value /* , start, end */) { // eslint-disable-line no-unused-vars
      return arrayFill.apply(validate(this), arguments);
    },
    filter: function filter(callbackfn /* , thisArg */) {
      return speciesFromList(this, arrayFilter(validate(this), callbackfn,
        arguments.length > 1 ? arguments[1] : undefined));
    },
    find: function find(predicate /* , thisArg */) {
      return arrayFind(validate(this), predicate, arguments.length > 1 ? arguments[1] : undefined);
    },
    findIndex: function findIndex(predicate /* , thisArg */) {
      return arrayFindIndex(validate(this), predicate, arguments.length > 1 ? arguments[1] : undefined);
    },
    forEach: function forEach(callbackfn /* , thisArg */) {
      arrayForEach(validate(this), callbackfn, arguments.length > 1 ? arguments[1] : undefined);
    },
    indexOf: function indexOf(searchElement /* , fromIndex */) {
      return arrayIndexOf(validate(this), searchElement, arguments.length > 1 ? arguments[1] : undefined);
    },
    includes: function includes(searchElement /* , fromIndex */) {
      return arrayIncludes(validate(this), searchElement, arguments.length > 1 ? arguments[1] : undefined);
    },
    join: function join(separator) { // eslint-disable-line no-unused-vars
      return arrayJoin.apply(validate(this), arguments);
    },
    lastIndexOf: function lastIndexOf(searchElement /* , fromIndex */) { // eslint-disable-line no-unused-vars
      return arrayLastIndexOf.apply(validate(this), arguments);
    },
    map: function map(mapfn /* , thisArg */) {
      return $map(validate(this), mapfn, arguments.length > 1 ? arguments[1] : undefined);
    },
    reduce: function reduce(callbackfn /* , initialValue */) { // eslint-disable-line no-unused-vars
      return arrayReduce.apply(validate(this), arguments);
    },
    reduceRight: function reduceRight(callbackfn /* , initialValue */) { // eslint-disable-line no-unused-vars
      return arrayReduceRight.apply(validate(this), arguments);
    },
    reverse: function reverse() {
      var that = this;
      var length = validate(that).length;
      var middle = Math.floor(length / 2);
      var index = 0;
      var value;
      while (index < middle) {
        value = that[index];
        that[index++] = that[--length];
        that[length] = value;
      } return that;
    },
    some: function some(callbackfn /* , thisArg */) {
      return arraySome(validate(this), callbackfn, arguments.length > 1 ? arguments[1] : undefined);
    },
    sort: function sort(comparefn) {
      return arraySort.call(validate(this), comparefn);
    },
    subarray: function subarray(begin, end) {
      var O = validate(this);
      var length = O.length;
      var $begin = toAbsoluteIndex(begin, length);
      return new (speciesConstructor(O, O[DEF_CONSTRUCTOR]))(
        O.buffer,
        O.byteOffset + $begin * O.BYTES_PER_ELEMENT,
        toLength((end === undefined ? length : toAbsoluteIndex(end, length)) - $begin)
      );
    }
  };

  var $slice = function slice(start, end) {
    return speciesFromList(this, arraySlice.call(validate(this), start, end));
  };

  var $set = function set(arrayLike /* , offset */) {
    validate(this);
    var offset = toOffset(arguments[1], 1);
    var length = this.length;
    var src = toObject(arrayLike);
    var len = toLength(src.length);
    var index = 0;
    if (len + offset > length) throw RangeError(WRONG_LENGTH);
    while (index < len) this[offset + index] = src[index++];
  };

  var $iterators = {
    entries: function entries() {
      return arrayEntries.call(validate(this));
    },
    keys: function keys() {
      return arrayKeys.call(validate(this));
    },
    values: function values() {
      return arrayValues.call(validate(this));
    }
  };

  var isTAIndex = function (target, key) {
    return isObject(target)
      && target[TYPED_ARRAY]
      && typeof key != 'symbol'
      && key in target
      && String(+key) == String(key);
  };
  var $getDesc = function getOwnPropertyDescriptor(target, key) {
    return isTAIndex(target, key = toPrimitive(key, true))
      ? propertyDesc(2, target[key])
      : gOPD(target, key);
  };
  var $setDesc = function defineProperty(target, key, desc) {
    if (isTAIndex(target, key = toPrimitive(key, true))
      && isObject(desc)
      && has(desc, 'value')
      && !has(desc, 'get')
      && !has(desc, 'set')
      // TODO: add validation descriptor w/o calling accessors
      && !desc.configurable
      && (!has(desc, 'writable') || desc.writable)
      && (!has(desc, 'enumerable') || desc.enumerable)
    ) {
      target[key] = desc.value;
      return target;
    } return dP(target, key, desc);
  };

  if (!ALL_CONSTRUCTORS) {
    $GOPD.f = $getDesc;
    $DP.f = $setDesc;
  }

  $export($export.S + $export.F * !ALL_CONSTRUCTORS, 'Object', {
    getOwnPropertyDescriptor: $getDesc,
    defineProperty: $setDesc
  });

  if (fails(function () { arrayToString.call({}); })) {
    arrayToString = arrayToLocaleString = function toString() {
      return arrayJoin.call(this);
    };
  }

  var $TypedArrayPrototype$ = redefineAll({}, proto);
  redefineAll($TypedArrayPrototype$, $iterators);
  hide($TypedArrayPrototype$, ITERATOR, $iterators.values);
  redefineAll($TypedArrayPrototype$, {
    slice: $slice,
    set: $set,
    constructor: function () { /* noop */ },
    toString: arrayToString,
    toLocaleString: $toLocaleString
  });
  addGetter($TypedArrayPrototype$, 'buffer', 'b');
  addGetter($TypedArrayPrototype$, 'byteOffset', 'o');
  addGetter($TypedArrayPrototype$, 'byteLength', 'l');
  addGetter($TypedArrayPrototype$, 'length', 'e');
  dP($TypedArrayPrototype$, TAG, {
    get: function () { return this[TYPED_ARRAY]; }
  });

  // eslint-disable-next-line max-statements
  module.exports = function (KEY, BYTES, wrapper, CLAMPED) {
    CLAMPED = !!CLAMPED;
    var NAME = KEY + (CLAMPED ? 'Clamped' : '') + 'Array';
    var GETTER = 'get' + KEY;
    var SETTER = 'set' + KEY;
    var TypedArray = global[NAME];
    var Base = TypedArray || {};
    var TAC = TypedArray && getPrototypeOf(TypedArray);
    var FORCED = !TypedArray || !$typed.ABV;
    var O = {};
    var TypedArrayPrototype = TypedArray && TypedArray[PROTOTYPE];
    var getter = function (that, index) {
      var data = that._d;
      return data.v[GETTER](index * BYTES + data.o, LITTLE_ENDIAN);
    };
    var setter = function (that, index, value) {
      var data = that._d;
      if (CLAMPED) value = (value = Math.round(value)) < 0 ? 0 : value > 0xff ? 0xff : value & 0xff;
      data.v[SETTER](index * BYTES + data.o, value, LITTLE_ENDIAN);
    };
    var addElement = function (that, index) {
      dP(that, index, {
        get: function () {
          return getter(this, index);
        },
        set: function (value) {
          return setter(this, index, value);
        },
        enumerable: true
      });
    };
    if (FORCED) {
      TypedArray = wrapper(function (that, data, $offset, $length) {
        anInstance(that, TypedArray, NAME, '_d');
        var index = 0;
        var offset = 0;
        var buffer, byteLength, length, klass;
        if (!isObject(data)) {
          length = toIndex(data);
          byteLength = length * BYTES;
          buffer = new $ArrayBuffer(byteLength);
        } else if (data instanceof $ArrayBuffer || (klass = classof(data)) == ARRAY_BUFFER || klass == SHARED_BUFFER) {
          buffer = data;
          offset = toOffset($offset, BYTES);
          var $len = data.byteLength;
          if ($length === undefined) {
            if ($len % BYTES) throw RangeError(WRONG_LENGTH);
            byteLength = $len - offset;
            if (byteLength < 0) throw RangeError(WRONG_LENGTH);
          } else {
            byteLength = toLength($length) * BYTES;
            if (byteLength + offset > $len) throw RangeError(WRONG_LENGTH);
          }
          length = byteLength / BYTES;
        } else if (TYPED_ARRAY in data) {
          return fromList(TypedArray, data);
        } else {
          return $from.call(TypedArray, data);
        }
        hide(that, '_d', {
          b: buffer,
          o: offset,
          l: byteLength,
          e: length,
          v: new $DataView(buffer)
        });
        while (index < length) addElement(that, index++);
      });
      TypedArrayPrototype = TypedArray[PROTOTYPE] = create($TypedArrayPrototype$);
      hide(TypedArrayPrototype, 'constructor', TypedArray);
    } else if (!fails(function () {
      TypedArray(1);
    }) || !fails(function () {
      new TypedArray(-1); // eslint-disable-line no-new
    }) || !$iterDetect(function (iter) {
      new TypedArray(); // eslint-disable-line no-new
      new TypedArray(null); // eslint-disable-line no-new
      new TypedArray(1.5); // eslint-disable-line no-new
      new TypedArray(iter); // eslint-disable-line no-new
    }, true)) {
      TypedArray = wrapper(function (that, data, $offset, $length) {
        anInstance(that, TypedArray, NAME);
        var klass;
        // `ws` module bug, temporarily remove validation length for Uint8Array
        // https://github.com/websockets/ws/pull/645
        if (!isObject(data)) return new Base(toIndex(data));
        if (data instanceof $ArrayBuffer || (klass = classof(data)) == ARRAY_BUFFER || klass == SHARED_BUFFER) {
          return $length !== undefined
            ? new Base(data, toOffset($offset, BYTES), $length)
            : $offset !== undefined
              ? new Base(data, toOffset($offset, BYTES))
              : new Base(data);
        }
        if (TYPED_ARRAY in data) return fromList(TypedArray, data);
        return $from.call(TypedArray, data);
      });
      arrayForEach(TAC !== Function.prototype ? gOPN(Base).concat(gOPN(TAC)) : gOPN(Base), function (key) {
        if (!(key in TypedArray)) hide(TypedArray, key, Base[key]);
      });
      TypedArray[PROTOTYPE] = TypedArrayPrototype;
      if (!LIBRARY) TypedArrayPrototype.constructor = TypedArray;
    }
    var $nativeIterator = TypedArrayPrototype[ITERATOR];
    var CORRECT_ITER_NAME = !!$nativeIterator
      && ($nativeIterator.name == 'values' || $nativeIterator.name == undefined);
    var $iterator = $iterators.values;
    hide(TypedArray, TYPED_CONSTRUCTOR, true);
    hide(TypedArrayPrototype, TYPED_ARRAY, NAME);
    hide(TypedArrayPrototype, VIEW, true);
    hide(TypedArrayPrototype, DEF_CONSTRUCTOR, TypedArray);

    if (CLAMPED ? new TypedArray(1)[TAG] != NAME : !(TAG in TypedArrayPrototype)) {
      dP(TypedArrayPrototype, TAG, {
        get: function () { return NAME; }
      });
    }

    O[NAME] = TypedArray;

    $export($export.G + $export.W + $export.F * (TypedArray != Base), O);

    $export($export.S, NAME, {
      BYTES_PER_ELEMENT: BYTES
    });

    $export($export.S + $export.F * fails(function () { Base.of.call(TypedArray, 1); }), NAME, {
      from: $from,
      of: $of
    });

    if (!(BYTES_PER_ELEMENT in TypedArrayPrototype)) hide(TypedArrayPrototype, BYTES_PER_ELEMENT, BYTES);

    $export($export.P, NAME, proto);

    setSpecies(NAME);

    $export($export.P + $export.F * FORCED_SET, NAME, { set: $set });

    $export($export.P + $export.F * !CORRECT_ITER_NAME, NAME, $iterators);

    if (!LIBRARY && TypedArrayPrototype.toString != arrayToString) TypedArrayPrototype.toString = arrayToString;

    $export($export.P + $export.F * fails(function () {
      new TypedArray(1).slice();
    }), NAME, { slice: $slice });

    $export($export.P + $export.F * (fails(function () {
      return [1, 2].toLocaleString() != new TypedArray([1, 2]).toLocaleString();
    }) || !fails(function () {
      TypedArrayPrototype.toLocaleString.call([1, 2]);
    })), NAME, { toLocaleString: $toLocaleString });

    Iterators[NAME] = CORRECT_ITER_NAME ? $nativeIterator : $iterator;
    if (!LIBRARY && !CORRECT_ITER_NAME) hide(TypedArrayPrototype, ITERATOR, $iterator);
  };
} else module.exports = function () { /* empty */ };


/***/ }),
/* 30 */
/***/ (function(module, exports, __webpack_require__) {

var Map = __webpack_require__(120);
var $export = __webpack_require__(0);
var shared = __webpack_require__(50)('metadata');
var store = shared.store || (shared.store = new (__webpack_require__(123))());

var getOrCreateMetadataMap = function (target, targetKey, create) {
  var targetMetadata = store.get(target);
  if (!targetMetadata) {
    if (!create) return undefined;
    store.set(target, targetMetadata = new Map());
  }
  var keyMetadata = targetMetadata.get(targetKey);
  if (!keyMetadata) {
    if (!create) return undefined;
    targetMetadata.set(targetKey, keyMetadata = new Map());
  } return keyMetadata;
};
var ordinaryHasOwnMetadata = function (MetadataKey, O, P) {
  var metadataMap = getOrCreateMetadataMap(O, P, false);
  return metadataMap === undefined ? false : metadataMap.has(MetadataKey);
};
var ordinaryGetOwnMetadata = function (MetadataKey, O, P) {
  var metadataMap = getOrCreateMetadataMap(O, P, false);
  return metadataMap === undefined ? undefined : metadataMap.get(MetadataKey);
};
var ordinaryDefineOwnMetadata = function (MetadataKey, MetadataValue, O, P) {
  getOrCreateMetadataMap(O, P, true).set(MetadataKey, MetadataValue);
};
var ordinaryOwnMetadataKeys = function (target, targetKey) {
  var metadataMap = getOrCreateMetadataMap(target, targetKey, false);
  var keys = [];
  if (metadataMap) metadataMap.forEach(function (_, key) { keys.push(key); });
  return keys;
};
var toMetaKey = function (it) {
  return it === undefined || typeof it == 'symbol' ? it : String(it);
};
var exp = function (O) {
  $export($export.S, 'Reflect', O);
};

module.exports = {
  store: store,
  map: getOrCreateMetadataMap,
  has: ordinaryHasOwnMetadata,
  get: ordinaryGetOwnMetadata,
  set: ordinaryDefineOwnMetadata,
  keys: ordinaryOwnMetadataKeys,
  key: toMetaKey,
  exp: exp
};


/***/ }),
/* 31 */
/***/ (function(module, exports) {

module.exports = false;


/***/ }),
/* 32 */
/***/ (function(module, exports, __webpack_require__) {

var META = __webpack_require__(35)('meta');
var isObject = __webpack_require__(4);
var has = __webpack_require__(15);
var setDesc = __webpack_require__(8).f;
var id = 0;
var isExtensible = Object.isExtensible || function () {
  return true;
};
var FREEZE = !__webpack_require__(3)(function () {
  return isExtensible(Object.preventExtensions({}));
});
var setMeta = function (it) {
  setDesc(it, META, { value: {
    i: 'O' + ++id, // object ID
    w: {}          // weak collections IDs
  } });
};
var fastKey = function (it, create) {
  // return primitive with prefix
  if (!isObject(it)) return typeof it == 'symbol' ? it : (typeof it == 'string' ? 'S' : 'P') + it;
  if (!has(it, META)) {
    // can't set metadata to uncaught frozen object
    if (!isExtensible(it)) return 'F';
    // not necessary to add metadata
    if (!create) return 'E';
    // add missing metadata
    setMeta(it);
  // return object ID
  } return it[META].i;
};
var getWeak = function (it, create) {
  if (!has(it, META)) {
    // can't set metadata to uncaught frozen object
    if (!isExtensible(it)) return true;
    // not necessary to add metadata
    if (!create) return false;
    // add missing metadata
    setMeta(it);
  // return hash weak collections IDs
  } return it[META].w;
};
// add metadata on freeze-family methods calling
var onFreeze = function (it) {
  if (FREEZE && meta.NEED && isExtensible(it) && !has(it, META)) setMeta(it);
  return it;
};
var meta = module.exports = {
  KEY: META,
  NEED: false,
  fastKey: fastKey,
  getWeak: getWeak,
  onFreeze: onFreeze
};


/***/ }),
/* 33 */
/***/ (function(module, exports, __webpack_require__) {

// 22.1.3.31 Array.prototype[@@unscopables]
var UNSCOPABLES = __webpack_require__(5)('unscopables');
var ArrayProto = Array.prototype;
if (ArrayProto[UNSCOPABLES] == undefined) __webpack_require__(12)(ArrayProto, UNSCOPABLES, {});
module.exports = function (key) {
  ArrayProto[UNSCOPABLES][key] = true;
};


/***/ }),
/* 34 */
/***/ (function(module, exports) {

module.exports = function (bitmap, value) {
  return {
    enumerable: !(bitmap & 1),
    configurable: !(bitmap & 2),
    writable: !(bitmap & 4),
    value: value
  };
};


/***/ }),
/* 35 */
/***/ (function(module, exports) {

var id = 0;
var px = Math.random();
module.exports = function (key) {
  return 'Symbol('.concat(key === undefined ? '' : key, ')_', (++id + px).toString(36));
};


/***/ }),
/* 36 */
/***/ (function(module, exports, __webpack_require__) {

// 19.1.2.14 / 15.2.3.14 Object.keys(O)
var $keys = __webpack_require__(99);
var enumBugKeys = __webpack_require__(73);

module.exports = Object.keys || function keys(O) {
  return $keys(O, enumBugKeys);
};


/***/ }),
/* 37 */
/***/ (function(module, exports, __webpack_require__) {

var toInteger = __webpack_require__(22);
var max = Math.max;
var min = Math.min;
module.exports = function (index, length) {
  index = toInteger(index);
  return index < 0 ? max(index + length, 0) : min(index, length);
};


/***/ }),
/* 38 */
/***/ (function(module, exports, __webpack_require__) {

// 19.1.2.2 / 15.2.3.5 Object.create(O [, Properties])
var anObject = __webpack_require__(1);
var dPs = __webpack_require__(100);
var enumBugKeys = __webpack_require__(73);
var IE_PROTO = __webpack_require__(72)('IE_PROTO');
var Empty = function () { /* empty */ };
var PROTOTYPE = 'prototype';

// Create object with fake `null` prototype: use iframe Object with cleared prototype
var createDict = function () {
  // Thrash, waste and sodomy: IE GC bug
  var iframe = __webpack_require__(70)('iframe');
  var i = enumBugKeys.length;
  var lt = '<';
  var gt = '>';
  var iframeDocument;
  iframe.style.display = 'none';
  __webpack_require__(74).appendChild(iframe);
  iframe.src = 'javascript:'; // eslint-disable-line no-script-url
  // createDict = iframe.contentWindow.Object;
  // html.removeChild(iframe);
  iframeDocument = iframe.contentWindow.document;
  iframeDocument.open();
  iframeDocument.write(lt + 'script' + gt + 'document.F=Object' + lt + '/script' + gt);
  iframeDocument.close();
  createDict = iframeDocument.F;
  while (i--) delete createDict[PROTOTYPE][enumBugKeys[i]];
  return createDict();
};

module.exports = Object.create || function create(O, Properties) {
  var result;
  if (O !== null) {
    Empty[PROTOTYPE] = anObject(O);
    result = new Empty();
    Empty[PROTOTYPE] = null;
    // add "__proto__" for Object.getPrototypeOf polyfill
    result[IE_PROTO] = O;
  } else result = createDict();
  return Properties === undefined ? result : dPs(result, Properties);
};


/***/ }),
/* 39 */
/***/ (function(module, exports, __webpack_require__) {

// 19.1.2.7 / 15.2.3.4 Object.getOwnPropertyNames(O)
var $keys = __webpack_require__(99);
var hiddenKeys = __webpack_require__(73).concat('length', 'prototype');

exports.f = Object.getOwnPropertyNames || function getOwnPropertyNames(O) {
  return $keys(O, hiddenKeys);
};


/***/ }),
/* 40 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var global = __webpack_require__(2);
var dP = __webpack_require__(8);
var DESCRIPTORS = __webpack_require__(7);
var SPECIES = __webpack_require__(5)('species');

module.exports = function (KEY) {
  var C = global[KEY];
  if (DESCRIPTORS && C && !C[SPECIES]) dP.f(C, SPECIES, {
    configurable: true,
    get: function () { return this; }
  });
};


/***/ }),
/* 41 */
/***/ (function(module, exports) {

module.exports = function (it, Constructor, name, forbiddenField) {
  if (!(it instanceof Constructor) || (forbiddenField !== undefined && forbiddenField in it)) {
    throw TypeError(name + ': incorrect invocation!');
  } return it;
};


/***/ }),
/* 42 */
/***/ (function(module, exports, __webpack_require__) {

var ctx = __webpack_require__(20);
var call = __webpack_require__(112);
var isArrayIter = __webpack_require__(85);
var anObject = __webpack_require__(1);
var toLength = __webpack_require__(6);
var getIterFn = __webpack_require__(87);
var BREAK = {};
var RETURN = {};
var exports = module.exports = function (iterable, entries, fn, that, ITERATOR) {
  var iterFn = ITERATOR ? function () { return iterable; } : getIterFn(iterable);
  var f = ctx(fn, that, entries ? 2 : 1);
  var index = 0;
  var length, step, iterator, result;
  if (typeof iterFn != 'function') throw TypeError(iterable + ' is not iterable!');
  // fast case for arrays with default iterator
  if (isArrayIter(iterFn)) for (length = toLength(iterable.length); length > index; index++) {
    result = entries ? f(anObject(step = iterable[index])[0], step[1]) : f(iterable[index]);
    if (result === BREAK || result === RETURN) return result;
  } else for (iterator = iterFn.call(iterable); !(step = iterator.next()).done;) {
    result = call(iterator, f, step.value, entries);
    if (result === BREAK || result === RETURN) return result;
  }
};
exports.BREAK = BREAK;
exports.RETURN = RETURN;


/***/ }),
/* 43 */
/***/ (function(module, exports, __webpack_require__) {

var redefine = __webpack_require__(13);
module.exports = function (target, src, safe) {
  for (var key in src) redefine(target, key, src[key], safe);
  return target;
};


/***/ }),
/* 44 */
/***/ (function(module, exports, __webpack_require__) {

var isObject = __webpack_require__(4);
module.exports = function (it, TYPE) {
  if (!isObject(it) || it._t !== TYPE) throw TypeError('Incompatible receiver, ' + TYPE + ' required!');
  return it;
};


/***/ }),
/* 45 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;
var errorProps = ['description', 'fileName', 'lineNumber', 'endLineNumber', 'message', 'name', 'number', 'stack'];

function Exception(message, node) {
  var loc = node && node.loc,
      line = undefined,
      endLineNumber = undefined,
      column = undefined,
      endColumn = undefined;

  if (loc) {
    line = loc.start.line;
    endLineNumber = loc.end.line;
    column = loc.start.column;
    endColumn = loc.end.column;

    message += ' - ' + line + ':' + column;
  }

  var tmp = Error.prototype.constructor.call(this, message);

  // Unfortunately errors are not enumerable in Chrome (at least), so `for prop in tmp` doesn't work.
  for (var idx = 0; idx < errorProps.length; idx++) {
    this[errorProps[idx]] = tmp[errorProps[idx]];
  }

  /* istanbul ignore else */
  if (Error.captureStackTrace) {
    Error.captureStackTrace(this, Exception);
  }

  try {
    if (loc) {
      this.lineNumber = line;
      this.endLineNumber = endLineNumber;

      // Work around issue under safari where we can't directly set the column value
      /* istanbul ignore next */
      if (Object.defineProperty) {
        Object.defineProperty(this, 'column', {
          value: column,
          enumerable: true
        });
        Object.defineProperty(this, 'endColumn', {
          value: endColumn,
          enumerable: true
        });
      } else {
        this.column = column;
        this.endColumn = endColumn;
      }
    }
  } catch (nop) {
    /* Ignore if the browser is very particular */
  }
}

Exception.prototype = new Error();

exports['default'] = Exception;
module.exports = exports['default'];
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL2V4Y2VwdGlvbi5qcyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOzs7QUFBQSxJQUFNLFVBQVUsR0FBRyxDQUNqQixhQUFhLEVBQ2IsVUFBVSxFQUNWLFlBQVksRUFDWixlQUFlLEVBQ2YsU0FBUyxFQUNULE1BQU0sRUFDTixRQUFRLEVBQ1IsT0FBTyxDQUNSLENBQUM7O0FBRUYsU0FBUyxTQUFTLENBQUMsT0FBTyxFQUFFLElBQUksRUFBRTtBQUNoQyxNQUFJLEdBQUcsR0FBRyxJQUFJLElBQUksSUFBSSxDQUFDLEdBQUc7TUFDeEIsSUFBSSxZQUFBO01BQ0osYUFBYSxZQUFBO01BQ2IsTUFBTSxZQUFBO01BQ04sU0FBUyxZQUFBLENBQUM7O0FBRVosTUFBSSxHQUFHLEVBQUU7QUFDUCxRQUFJLEdBQUcsR0FBRyxDQUFDLEtBQUssQ0FBQyxJQUFJLENBQUM7QUFDdEIsaUJBQWEsR0FBRyxHQUFHLENBQUMsR0FBRyxDQUFDLElBQUksQ0FBQztBQUM3QixVQUFNLEdBQUcsR0FBRyxDQUFDLEtBQUssQ0FBQyxNQUFNLENBQUM7QUFDMUIsYUFBUyxHQUFHLEdBQUcsQ0FBQyxHQUFHLENBQUMsTUFBTSxDQUFDOztBQUUzQixXQUFPLElBQUksS0FBSyxHQUFHLElBQUksR0FBRyxHQUFHLEdBQUcsTUFBTSxDQUFDO0dBQ3hDOztBQUVELE1BQUksR0FBRyxHQUFHLEtBQUssQ0FBQyxTQUFTLENBQUMsV0FBVyxDQUFDLElBQUksQ0FBQyxJQUFJLEVBQUUsT0FBTyxDQUFDLENBQUM7OztBQUcxRCxPQUFLLElBQUksR0FBRyxHQUFHLENBQUMsRUFBRSxHQUFHLEdBQUcsVUFBVSxDQUFDLE1BQU0sRUFBRSxHQUFHLEVBQUUsRUFBRTtBQUNoRCxRQUFJLENBQUMsVUFBVSxDQUFDLEdBQUcsQ0FBQyxDQUFDLEdBQUcsR0FBRyxDQUFDLFVBQVUsQ0FBQyxHQUFHLENBQUMsQ0FBQyxDQUFDO0dBQzlDOzs7QUFHRCxNQUFJLEtBQUssQ0FBQyxpQkFBaUIsRUFBRTtBQUMzQixTQUFLLENBQUMsaUJBQWlCLENBQUMsSUFBSSxFQUFFLFNBQVMsQ0FBQyxDQUFDO0dBQzFDOztBQUVELE1BQUk7QUFDRixRQUFJLEdBQUcsRUFBRTtBQUNQLFVBQUksQ0FBQyxVQUFVLEdBQUcsSUFBSSxDQUFDO0FBQ3ZCLFVBQUksQ0FBQyxhQUFhLEdBQUcsYUFBYSxDQUFDOzs7O0FBSW5DLFVBQUksTUFBTSxDQUFDLGNBQWMsRUFBRTtBQUN6QixjQUFNLENBQUMsY0FBYyxDQUFDLElBQUksRUFBRSxRQUFRLEVBQUU7QUFDcEMsZUFBSyxFQUFFLE1BQU07QUFDYixvQkFBVSxFQUFFLElBQUk7U0FDakIsQ0FBQyxDQUFDO0FBQ0gsY0FBTSxDQUFDLGNBQWMsQ0FBQyxJQUFJLEVBQUUsV0FBVyxFQUFFO0FBQ3ZDLGVBQUssRUFBRSxTQUFTO0FBQ2hCLG9CQUFVLEVBQUUsSUFBSTtTQUNqQixDQUFDLENBQUM7T0FDSixNQUFNO0FBQ0wsWUFBSSxDQUFDLE1BQU0sR0FBRyxNQUFNLENBQUM7QUFDckIsWUFBSSxDQUFDLFNBQVMsR0FBRyxTQUFTLENBQUM7T0FDNUI7S0FDRjtHQUNGLENBQUMsT0FBTyxHQUFHLEVBQUU7O0dBRWI7Q0FDRjs7QUFFRCxTQUFTLENBQUMsU0FBUyxHQUFHLElBQUksS0FBSyxFQUFFLENBQUM7O3FCQUVuQixTQUFTIiwiZmlsZSI6ImV4Y2VwdGlvbi5qcyIsInNvdXJjZXNDb250ZW50IjpbImNvbnN0IGVycm9yUHJvcHMgPSBbXG4gICdkZXNjcmlwdGlvbicsXG4gICdmaWxlTmFtZScsXG4gICdsaW5lTnVtYmVyJyxcbiAgJ2VuZExpbmVOdW1iZXInLFxuICAnbWVzc2FnZScsXG4gICduYW1lJyxcbiAgJ251bWJlcicsXG4gICdzdGFjaydcbl07XG5cbmZ1bmN0aW9uIEV4Y2VwdGlvbihtZXNzYWdlLCBub2RlKSB7XG4gIGxldCBsb2MgPSBub2RlICYmIG5vZGUubG9jLFxuICAgIGxpbmUsXG4gICAgZW5kTGluZU51bWJlcixcbiAgICBjb2x1bW4sXG4gICAgZW5kQ29sdW1uO1xuXG4gIGlmIChsb2MpIHtcbiAgICBsaW5lID0gbG9jLnN0YXJ0LmxpbmU7XG4gICAgZW5kTGluZU51bWJlciA9IGxvYy5lbmQubGluZTtcbiAgICBjb2x1bW4gPSBsb2Muc3RhcnQuY29sdW1uO1xuICAgIGVuZENvbHVtbiA9IGxvYy5lbmQuY29sdW1uO1xuXG4gICAgbWVzc2FnZSArPSAnIC0gJyArIGxpbmUgKyAnOicgKyBjb2x1bW47XG4gIH1cblxuICBsZXQgdG1wID0gRXJyb3IucHJvdG90eXBlLmNvbnN0cnVjdG9yLmNhbGwodGhpcywgbWVzc2FnZSk7XG5cbiAgLy8gVW5mb3J0dW5hdGVseSBlcnJvcnMgYXJlIG5vdCBlbnVtZXJhYmxlIGluIENocm9tZSAoYXQgbGVhc3QpLCBzbyBgZm9yIHByb3AgaW4gdG1wYCBkb2Vzbid0IHdvcmsuXG4gIGZvciAobGV0IGlkeCA9IDA7IGlkeCA8IGVycm9yUHJvcHMubGVuZ3RoOyBpZHgrKykge1xuICAgIHRoaXNbZXJyb3JQcm9wc1tpZHhdXSA9IHRtcFtlcnJvclByb3BzW2lkeF1dO1xuICB9XG5cbiAgLyogaXN0YW5idWwgaWdub3JlIGVsc2UgKi9cbiAgaWYgKEVycm9yLmNhcHR1cmVTdGFja1RyYWNlKSB7XG4gICAgRXJyb3IuY2FwdHVyZVN0YWNrVHJhY2UodGhpcywgRXhjZXB0aW9uKTtcbiAgfVxuXG4gIHRyeSB7XG4gICAgaWYgKGxvYykge1xuICAgICAgdGhpcy5saW5lTnVtYmVyID0gbGluZTtcbiAgICAgIHRoaXMuZW5kTGluZU51bWJlciA9IGVuZExpbmVOdW1iZXI7XG5cbiAgICAgIC8vIFdvcmsgYXJvdW5kIGlzc3VlIHVuZGVyIHNhZmFyaSB3aGVyZSB3ZSBjYW4ndCBkaXJlY3RseSBzZXQgdGhlIGNvbHVtbiB2YWx1ZVxuICAgICAgLyogaXN0YW5idWwgaWdub3JlIG5leHQgKi9cbiAgICAgIGlmIChPYmplY3QuZGVmaW5lUHJvcGVydHkpIHtcbiAgICAgICAgT2JqZWN0LmRlZmluZVByb3BlcnR5KHRoaXMsICdjb2x1bW4nLCB7XG4gICAgICAgICAgdmFsdWU6IGNvbHVtbixcbiAgICAgICAgICBlbnVtZXJhYmxlOiB0cnVlXG4gICAgICAgIH0pO1xuICAgICAgICBPYmplY3QuZGVmaW5lUHJvcGVydHkodGhpcywgJ2VuZENvbHVtbicsIHtcbiAgICAgICAgICB2YWx1ZTogZW5kQ29sdW1uLFxuICAgICAgICAgIGVudW1lcmFibGU6IHRydWVcbiAgICAgICAgfSk7XG4gICAgICB9IGVsc2Uge1xuICAgICAgICB0aGlzLmNvbHVtbiA9IGNvbHVtbjtcbiAgICAgICAgdGhpcy5lbmRDb2x1bW4gPSBlbmRDb2x1bW47XG4gICAgICB9XG4gICAgfVxuICB9IGNhdGNoIChub3ApIHtcbiAgICAvKiBJZ25vcmUgaWYgdGhlIGJyb3dzZXIgaXMgdmVyeSBwYXJ0aWN1bGFyICovXG4gIH1cbn1cblxuRXhjZXB0aW9uLnByb3RvdHlwZSA9IG5ldyBFcnJvcigpO1xuXG5leHBvcnQgZGVmYXVsdCBFeGNlcHRpb247XG4iXX0=


/***/ }),
/* 46 */
/***/ (function(module, exports, __webpack_require__) {

var def = __webpack_require__(8).f;
var has = __webpack_require__(15);
var TAG = __webpack_require__(5)('toStringTag');

module.exports = function (it, tag, stat) {
  if (it && !has(it = stat ? it : it.prototype, TAG)) def(it, TAG, { configurable: true, value: tag });
};


/***/ }),
/* 47 */
/***/ (function(module, exports, __webpack_require__) {

// getting tag from 19.1.3.6 Object.prototype.toString()
var cof = __webpack_require__(21);
var TAG = __webpack_require__(5)('toStringTag');
// ES3 wrong here
var ARG = cof(function () { return arguments; }()) == 'Arguments';

// fallback for IE11 Script Access Denied error
var tryGet = function (it, key) {
  try {
    return it[key];
  } catch (e) { /* empty */ }
};

module.exports = function (it) {
  var O, T, B;
  return it === undefined ? 'Undefined' : it === null ? 'Null'
    // @@toStringTag case
    : typeof (T = tryGet(O = Object(it), TAG)) == 'string' ? T
    // builtinTag case
    : ARG ? cof(O)
    // ES3 arguments fallback
    : (B = cof(O)) == 'Object' && typeof O.callee == 'function' ? 'Arguments' : B;
};


/***/ }),
/* 48 */
/***/ (function(module, exports, __webpack_require__) {

var $export = __webpack_require__(0);
var defined = __webpack_require__(25);
var fails = __webpack_require__(3);
var spaces = __webpack_require__(76);
var space = '[' + spaces + ']';
var non = '\u200b\u0085';
var ltrim = RegExp('^' + space + space + '*');
var rtrim = RegExp(space + space + '*$');

var exporter = function (KEY, exec, ALIAS) {
  var exp = {};
  var FORCE = fails(function () {
    return !!spaces[KEY]() || non[KEY]() != non;
  });
  var fn = exp[KEY] = FORCE ? exec(trim) : spaces[KEY];
  if (ALIAS) exp[ALIAS] = fn;
  $export($export.P + $export.F * FORCE, 'String', exp);
};

// 1 -> String#trimLeft
// 2 -> String#trimRight
// 3 -> String#trim
var trim = exporter.trim = function (string, TYPE) {
  string = String(defined(string));
  if (TYPE & 1) string = string.replace(ltrim, '');
  if (TYPE & 2) string = string.replace(rtrim, '');
  return string;
};

module.exports = exporter;


/***/ }),
/* 49 */
/***/ (function(module, exports) {

module.exports = {};


/***/ }),
/* 50 */
/***/ (function(module, exports, __webpack_require__) {

var core = __webpack_require__(19);
var global = __webpack_require__(2);
var SHARED = '__core-js_shared__';
var store = global[SHARED] || (global[SHARED] = {});

(module.exports = function (key, value) {
  return store[key] || (store[key] = value !== undefined ? value : {});
})('versions', []).push({
  version: core.version,
  mode: __webpack_require__(31) ? 'pure' : 'global',
  copyright: '© 2019 Denis Pushkarev (zloirock.ru)'
});


/***/ }),
/* 51 */
/***/ (function(module, exports, __webpack_require__) {

// fallback for non-array-like ES3 and non-enumerable old V8 strings
var cof = __webpack_require__(21);
// eslint-disable-next-line no-prototype-builtins
module.exports = Object('z').propertyIsEnumerable(0) ? Object : function (it) {
  return cof(it) == 'String' ? it.split('') : Object(it);
};


/***/ }),
/* 52 */
/***/ (function(module, exports) {

exports.f = {}.propertyIsEnumerable;


/***/ }),
/* 53 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// 21.2.5.3 get RegExp.prototype.flags
var anObject = __webpack_require__(1);
module.exports = function () {
  var that = anObject(this);
  var result = '';
  if (that.global) result += 'g';
  if (that.ignoreCase) result += 'i';
  if (that.multiline) result += 'm';
  if (that.unicode) result += 'u';
  if (that.sticky) result += 'y';
  return result;
};


/***/ }),
/* 54 */
/***/ (function(module, exports, __webpack_require__) {

// 7.3.20 SpeciesConstructor(O, defaultConstructor)
var anObject = __webpack_require__(1);
var aFunction = __webpack_require__(11);
var SPECIES = __webpack_require__(5)('species');
module.exports = function (O, D) {
  var C = anObject(O).constructor;
  var S;
  return C === undefined || (S = anObject(C)[SPECIES]) == undefined ? D : aFunction(S);
};


/***/ }),
/* 55 */
/***/ (function(module, exports) {

var g;

// This works in non-strict mode
g = (function() {
	return this;
})();

try {
	// This works if eval is allowed (see CSP)
	g = g || new Function("return this")();
} catch (e) {
	// This works if the window reference is available
	if (typeof window === "object") g = window;
}

// g can still be undefined, but nothing to do about it...
// We return undefined, instead of nothing here, so it's
// easier to handle this case. if(!global) { ...}

module.exports = g;


/***/ }),
/* 56 */
/***/ (function(module, exports, __webpack_require__) {

// false -> Array#indexOf
// true  -> Array#includes
var toIObject = __webpack_require__(16);
var toLength = __webpack_require__(6);
var toAbsoluteIndex = __webpack_require__(37);
module.exports = function (IS_INCLUDES) {
  return function ($this, el, fromIndex) {
    var O = toIObject($this);
    var length = toLength(O.length);
    var index = toAbsoluteIndex(fromIndex, length);
    var value;
    // Array#includes uses SameValueZero equality algorithm
    // eslint-disable-next-line no-self-compare
    if (IS_INCLUDES && el != el) while (length > index) {
      value = O[index++];
      // eslint-disable-next-line no-self-compare
      if (value != value) return true;
    // Array#indexOf ignores holes, Array#includes - not
    } else for (;length > index; index++) if (IS_INCLUDES || index in O) {
      if (O[index] === el) return IS_INCLUDES || index || 0;
    } return !IS_INCLUDES && -1;
  };
};


/***/ }),
/* 57 */
/***/ (function(module, exports) {

exports.f = Object.getOwnPropertySymbols;


/***/ }),
/* 58 */
/***/ (function(module, exports, __webpack_require__) {

// 7.2.2 IsArray(argument)
var cof = __webpack_require__(21);
module.exports = Array.isArray || function isArray(arg) {
  return cof(arg) == 'Array';
};


/***/ }),
/* 59 */
/***/ (function(module, exports, __webpack_require__) {

var toInteger = __webpack_require__(22);
var defined = __webpack_require__(25);
// true  -> String#at
// false -> String#codePointAt
module.exports = function (TO_STRING) {
  return function (that, pos) {
    var s = String(defined(that));
    var i = toInteger(pos);
    var l = s.length;
    var a, b;
    if (i < 0 || i >= l) return TO_STRING ? '' : undefined;
    a = s.charCodeAt(i);
    return a < 0xd800 || a > 0xdbff || i + 1 === l || (b = s.charCodeAt(i + 1)) < 0xdc00 || b > 0xdfff
      ? TO_STRING ? s.charAt(i) : a
      : TO_STRING ? s.slice(i, i + 2) : (a - 0xd800 << 10) + (b - 0xdc00) + 0x10000;
  };
};


/***/ }),
/* 60 */
/***/ (function(module, exports, __webpack_require__) {

// 7.2.8 IsRegExp(argument)
var isObject = __webpack_require__(4);
var cof = __webpack_require__(21);
var MATCH = __webpack_require__(5)('match');
module.exports = function (it) {
  var isRegExp;
  return isObject(it) && ((isRegExp = it[MATCH]) !== undefined ? !!isRegExp : cof(it) == 'RegExp');
};


/***/ }),
/* 61 */
/***/ (function(module, exports, __webpack_require__) {

var ITERATOR = __webpack_require__(5)('iterator');
var SAFE_CLOSING = false;

try {
  var riter = [7][ITERATOR]();
  riter['return'] = function () { SAFE_CLOSING = true; };
  // eslint-disable-next-line no-throw-literal
  Array.from(riter, function () { throw 2; });
} catch (e) { /* empty */ }

module.exports = function (exec, skipClosing) {
  if (!skipClosing && !SAFE_CLOSING) return false;
  var safe = false;
  try {
    var arr = [7];
    var iter = arr[ITERATOR]();
    iter.next = function () { return { done: safe = true }; };
    arr[ITERATOR] = function () { return iter; };
    exec(arr);
  } catch (e) { /* empty */ }
  return safe;
};


/***/ }),
/* 62 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var classof = __webpack_require__(47);
var builtinExec = RegExp.prototype.exec;

 // `RegExpExec` abstract operation
// https://tc39.github.io/ecma262/#sec-regexpexec
module.exports = function (R, S) {
  var exec = R.exec;
  if (typeof exec === 'function') {
    var result = exec.call(R, S);
    if (typeof result !== 'object') {
      throw new TypeError('RegExp exec method returned something other than an Object or null');
    }
    return result;
  }
  if (classof(R) !== 'RegExp') {
    throw new TypeError('RegExp#exec called on incompatible receiver');
  }
  return builtinExec.call(R, S);
};


/***/ }),
/* 63 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

__webpack_require__(116);
var redefine = __webpack_require__(13);
var hide = __webpack_require__(12);
var fails = __webpack_require__(3);
var defined = __webpack_require__(25);
var wks = __webpack_require__(5);
var regexpExec = __webpack_require__(91);

var SPECIES = wks('species');

var REPLACE_SUPPORTS_NAMED_GROUPS = !fails(function () {
  // #replace needs built-in support for named groups.
  // #match works fine because it just return the exec results, even if it has
  // a "grops" property.
  var re = /./;
  re.exec = function () {
    var result = [];
    result.groups = { a: '7' };
    return result;
  };
  return ''.replace(re, '$<a>') !== '7';
});

var SPLIT_WORKS_WITH_OVERWRITTEN_EXEC = (function () {
  // Chrome 51 has a buggy "split" implementation when RegExp#exec !== nativeExec
  var re = /(?:)/;
  var originalExec = re.exec;
  re.exec = function () { return originalExec.apply(this, arguments); };
  var result = 'ab'.split(re);
  return result.length === 2 && result[0] === 'a' && result[1] === 'b';
})();

module.exports = function (KEY, length, exec) {
  var SYMBOL = wks(KEY);

  var DELEGATES_TO_SYMBOL = !fails(function () {
    // String methods call symbol-named RegEp methods
    var O = {};
    O[SYMBOL] = function () { return 7; };
    return ''[KEY](O) != 7;
  });

  var DELEGATES_TO_EXEC = DELEGATES_TO_SYMBOL ? !fails(function () {
    // Symbol-named RegExp methods call .exec
    var execCalled = false;
    var re = /a/;
    re.exec = function () { execCalled = true; return null; };
    if (KEY === 'split') {
      // RegExp[@@split] doesn't call the regex's exec method, but first creates
      // a new one. We need to return the patched regex when creating the new one.
      re.constructor = {};
      re.constructor[SPECIES] = function () { return re; };
    }
    re[SYMBOL]('');
    return !execCalled;
  }) : undefined;

  if (
    !DELEGATES_TO_SYMBOL ||
    !DELEGATES_TO_EXEC ||
    (KEY === 'replace' && !REPLACE_SUPPORTS_NAMED_GROUPS) ||
    (KEY === 'split' && !SPLIT_WORKS_WITH_OVERWRITTEN_EXEC)
  ) {
    var nativeRegExpMethod = /./[SYMBOL];
    var fns = exec(
      defined,
      SYMBOL,
      ''[KEY],
      function maybeCallNative(nativeMethod, regexp, str, arg2, forceStringMethod) {
        if (regexp.exec === regexpExec) {
          if (DELEGATES_TO_SYMBOL && !forceStringMethod) {
            // The native String method already delegates to @@method (this
            // polyfilled function), leasing to infinite recursion.
            // We avoid it by directly calling the native @@method method.
            return { done: true, value: nativeRegExpMethod.call(regexp, str, arg2) };
          }
          return { done: true, value: nativeMethod.call(str, regexp, arg2) };
        }
        return { done: false };
      }
    );
    var strfn = fns[0];
    var rxfn = fns[1];

    redefine(String.prototype, KEY, strfn);
    hide(RegExp.prototype, SYMBOL, length == 2
      // 21.2.5.8 RegExp.prototype[@@replace](string, replaceValue)
      // 21.2.5.11 RegExp.prototype[@@split](string, limit)
      ? function (string, arg) { return rxfn.call(string, this, arg); }
      // 21.2.5.6 RegExp.prototype[@@match](string)
      // 21.2.5.9 RegExp.prototype[@@search](string)
      : function (string) { return rxfn.call(string, this); }
    );
  }
};


/***/ }),
/* 64 */
/***/ (function(module, exports, __webpack_require__) {

var global = __webpack_require__(2);
var navigator = global.navigator;

module.exports = navigator && navigator.userAgent || '';


/***/ }),
/* 65 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var global = __webpack_require__(2);
var $export = __webpack_require__(0);
var redefine = __webpack_require__(13);
var redefineAll = __webpack_require__(43);
var meta = __webpack_require__(32);
var forOf = __webpack_require__(42);
var anInstance = __webpack_require__(41);
var isObject = __webpack_require__(4);
var fails = __webpack_require__(3);
var $iterDetect = __webpack_require__(61);
var setToStringTag = __webpack_require__(46);
var inheritIfRequired = __webpack_require__(77);

module.exports = function (NAME, wrapper, methods, common, IS_MAP, IS_WEAK) {
  var Base = global[NAME];
  var C = Base;
  var ADDER = IS_MAP ? 'set' : 'add';
  var proto = C && C.prototype;
  var O = {};
  var fixMethod = function (KEY) {
    var fn = proto[KEY];
    redefine(proto, KEY,
      KEY == 'delete' ? function (a) {
        return IS_WEAK && !isObject(a) ? false : fn.call(this, a === 0 ? 0 : a);
      } : KEY == 'has' ? function has(a) {
        return IS_WEAK && !isObject(a) ? false : fn.call(this, a === 0 ? 0 : a);
      } : KEY == 'get' ? function get(a) {
        return IS_WEAK && !isObject(a) ? undefined : fn.call(this, a === 0 ? 0 : a);
      } : KEY == 'add' ? function add(a) { fn.call(this, a === 0 ? 0 : a); return this; }
        : function set(a, b) { fn.call(this, a === 0 ? 0 : a, b); return this; }
    );
  };
  if (typeof C != 'function' || !(IS_WEAK || proto.forEach && !fails(function () {
    new C().entries().next();
  }))) {
    // create collection constructor
    C = common.getConstructor(wrapper, NAME, IS_MAP, ADDER);
    redefineAll(C.prototype, methods);
    meta.NEED = true;
  } else {
    var instance = new C();
    // early implementations not supports chaining
    var HASNT_CHAINING = instance[ADDER](IS_WEAK ? {} : -0, 1) != instance;
    // V8 ~  Chromium 40- weak-collections throws on primitives, but should return false
    var THROWS_ON_PRIMITIVES = fails(function () { instance.has(1); });
    // most early implementations doesn't supports iterables, most modern - not close it correctly
    var ACCEPT_ITERABLES = $iterDetect(function (iter) { new C(iter); }); // eslint-disable-line no-new
    // for early implementations -0 and +0 not the same
    var BUGGY_ZERO = !IS_WEAK && fails(function () {
      // V8 ~ Chromium 42- fails only with 5+ elements
      var $instance = new C();
      var index = 5;
      while (index--) $instance[ADDER](index, index);
      return !$instance.has(-0);
    });
    if (!ACCEPT_ITERABLES) {
      C = wrapper(function (target, iterable) {
        anInstance(target, C, NAME);
        var that = inheritIfRequired(new Base(), target, C);
        if (iterable != undefined) forOf(iterable, IS_MAP, that[ADDER], that);
        return that;
      });
      C.prototype = proto;
      proto.constructor = C;
    }
    if (THROWS_ON_PRIMITIVES || BUGGY_ZERO) {
      fixMethod('delete');
      fixMethod('has');
      IS_MAP && fixMethod('get');
    }
    if (BUGGY_ZERO || HASNT_CHAINING) fixMethod(ADDER);
    // weak collections should not contains .clear method
    if (IS_WEAK && proto.clear) delete proto.clear;
  }

  setToStringTag(C, NAME);

  O[NAME] = C;
  $export($export.G + $export.W + $export.F * (C != Base), O);

  if (!IS_WEAK) common.setStrong(C, NAME, IS_MAP);

  return C;
};


/***/ }),
/* 66 */
/***/ (function(module, exports, __webpack_require__) {

var global = __webpack_require__(2);
var hide = __webpack_require__(12);
var uid = __webpack_require__(35);
var TYPED = uid('typed_array');
var VIEW = uid('view');
var ABV = !!(global.ArrayBuffer && global.DataView);
var CONSTR = ABV;
var i = 0;
var l = 9;
var Typed;

var TypedArrayConstructors = (
  'Int8Array,Uint8Array,Uint8ClampedArray,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array'
).split(',');

while (i < l) {
  if (Typed = global[TypedArrayConstructors[i++]]) {
    hide(Typed.prototype, TYPED, true);
    hide(Typed.prototype, VIEW, true);
  } else CONSTR = false;
}

module.exports = {
  ABV: ABV,
  CONSTR: CONSTR,
  TYPED: TYPED,
  VIEW: VIEW
};


/***/ }),
/* 67 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// Forced replacement prototype accessors methods
module.exports = __webpack_require__(31) || !__webpack_require__(3)(function () {
  var K = Math.random();
  // In FF throws only define methods
  // eslint-disable-next-line no-undef, no-useless-call
  __defineSetter__.call(null, K, function () { /* empty */ });
  delete __webpack_require__(2)[K];
});


/***/ }),
/* 68 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// https://tc39.github.io/proposal-setmap-offrom/
var $export = __webpack_require__(0);

module.exports = function (COLLECTION) {
  $export($export.S, COLLECTION, { of: function of() {
    var length = arguments.length;
    var A = new Array(length);
    while (length--) A[length] = arguments[length];
    return new this(A);
  } });
};


/***/ }),
/* 69 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// https://tc39.github.io/proposal-setmap-offrom/
var $export = __webpack_require__(0);
var aFunction = __webpack_require__(11);
var ctx = __webpack_require__(20);
var forOf = __webpack_require__(42);

module.exports = function (COLLECTION) {
  $export($export.S, COLLECTION, { from: function from(source /* , mapFn, thisArg */) {
    var mapFn = arguments[1];
    var mapping, A, n, cb;
    aFunction(this);
    mapping = mapFn !== undefined;
    if (mapping) aFunction(mapFn);
    if (source == undefined) return new this();
    A = [];
    if (mapping) {
      n = 0;
      cb = ctx(mapFn, arguments[2], 2);
      forOf(source, false, function (nextItem) {
        A.push(cb(nextItem, n++));
      });
    } else {
      forOf(source, false, A.push, A);
    }
    return new this(A);
  } });
};


/***/ }),
/* 70 */
/***/ (function(module, exports, __webpack_require__) {

var isObject = __webpack_require__(4);
var document = __webpack_require__(2).document;
// typeof document.createElement is 'object' in old IE
var is = isObject(document) && isObject(document.createElement);
module.exports = function (it) {
  return is ? document.createElement(it) : {};
};


/***/ }),
/* 71 */
/***/ (function(module, exports, __webpack_require__) {

var global = __webpack_require__(2);
var core = __webpack_require__(19);
var LIBRARY = __webpack_require__(31);
var wksExt = __webpack_require__(98);
var defineProperty = __webpack_require__(8).f;
module.exports = function (name) {
  var $Symbol = core.Symbol || (core.Symbol = LIBRARY ? {} : global.Symbol || {});
  if (name.charAt(0) != '_' && !(name in $Symbol)) defineProperty($Symbol, name, { value: wksExt.f(name) });
};


/***/ }),
/* 72 */
/***/ (function(module, exports, __webpack_require__) {

var shared = __webpack_require__(50)('keys');
var uid = __webpack_require__(35);
module.exports = function (key) {
  return shared[key] || (shared[key] = uid(key));
};


/***/ }),
/* 73 */
/***/ (function(module, exports) {

// IE 8- don't enum bug keys
module.exports = (
  'constructor,hasOwnProperty,isPrototypeOf,propertyIsEnumerable,toLocaleString,toString,valueOf'
).split(',');


/***/ }),
/* 74 */
/***/ (function(module, exports, __webpack_require__) {

var document = __webpack_require__(2).document;
module.exports = document && document.documentElement;


/***/ }),
/* 75 */
/***/ (function(module, exports, __webpack_require__) {

// Works with __proto__ only. Old v8 can't work with null proto objects.
/* eslint-disable no-proto */
var isObject = __webpack_require__(4);
var anObject = __webpack_require__(1);
var check = function (O, proto) {
  anObject(O);
  if (!isObject(proto) && proto !== null) throw TypeError(proto + ": can't set as prototype!");
};
module.exports = {
  set: Object.setPrototypeOf || ('__proto__' in {} ? // eslint-disable-line
    function (test, buggy, set) {
      try {
        set = __webpack_require__(20)(Function.call, __webpack_require__(17).f(Object.prototype, '__proto__').set, 2);
        set(test, []);
        buggy = !(test instanceof Array);
      } catch (e) { buggy = true; }
      return function setPrototypeOf(O, proto) {
        check(O, proto);
        if (buggy) O.__proto__ = proto;
        else set(O, proto);
        return O;
      };
    }({}, false) : undefined),
  check: check
};


/***/ }),
/* 76 */
/***/ (function(module, exports) {

module.exports = '\x09\x0A\x0B\x0C\x0D\x20\xA0\u1680\u180E\u2000\u2001\u2002\u2003' +
  '\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u202F\u205F\u3000\u2028\u2029\uFEFF';


/***/ }),
/* 77 */
/***/ (function(module, exports, __webpack_require__) {

var isObject = __webpack_require__(4);
var setPrototypeOf = __webpack_require__(75).set;
module.exports = function (that, target, C) {
  var S = target.constructor;
  var P;
  if (S !== C && typeof S == 'function' && (P = S.prototype) !== C.prototype && isObject(P) && setPrototypeOf) {
    setPrototypeOf(that, P);
  } return that;
};


/***/ }),
/* 78 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var toInteger = __webpack_require__(22);
var defined = __webpack_require__(25);

module.exports = function repeat(count) {
  var str = String(defined(this));
  var res = '';
  var n = toInteger(count);
  if (n < 0 || n == Infinity) throw RangeError("Count can't be negative");
  for (;n > 0; (n >>>= 1) && (str += str)) if (n & 1) res += str;
  return res;
};


/***/ }),
/* 79 */
/***/ (function(module, exports) {

// 20.2.2.28 Math.sign(x)
module.exports = Math.sign || function sign(x) {
  // eslint-disable-next-line no-self-compare
  return (x = +x) == 0 || x != x ? x : x < 0 ? -1 : 1;
};


/***/ }),
/* 80 */
/***/ (function(module, exports) {

// 20.2.2.14 Math.expm1(x)
var $expm1 = Math.expm1;
module.exports = (!$expm1
  // Old FF bug
  || $expm1(10) > 22025.465794806719 || $expm1(10) < 22025.4657948067165168
  // Tor Browser bug
  || $expm1(-2e-17) != -2e-17
) ? function expm1(x) {
  return (x = +x) == 0 ? x : x > -1e-6 && x < 1e-6 ? x + x * x / 2 : Math.exp(x) - 1;
} : $expm1;


/***/ }),
/* 81 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var LIBRARY = __webpack_require__(31);
var $export = __webpack_require__(0);
var redefine = __webpack_require__(13);
var hide = __webpack_require__(12);
var Iterators = __webpack_require__(49);
var $iterCreate = __webpack_require__(82);
var setToStringTag = __webpack_require__(46);
var getPrototypeOf = __webpack_require__(18);
var ITERATOR = __webpack_require__(5)('iterator');
var BUGGY = !([].keys && 'next' in [].keys()); // Safari has buggy iterators w/o `next`
var FF_ITERATOR = '@@iterator';
var KEYS = 'keys';
var VALUES = 'values';

var returnThis = function () { return this; };

module.exports = function (Base, NAME, Constructor, next, DEFAULT, IS_SET, FORCED) {
  $iterCreate(Constructor, NAME, next);
  var getMethod = function (kind) {
    if (!BUGGY && kind in proto) return proto[kind];
    switch (kind) {
      case KEYS: return function keys() { return new Constructor(this, kind); };
      case VALUES: return function values() { return new Constructor(this, kind); };
    } return function entries() { return new Constructor(this, kind); };
  };
  var TAG = NAME + ' Iterator';
  var DEF_VALUES = DEFAULT == VALUES;
  var VALUES_BUG = false;
  var proto = Base.prototype;
  var $native = proto[ITERATOR] || proto[FF_ITERATOR] || DEFAULT && proto[DEFAULT];
  var $default = $native || getMethod(DEFAULT);
  var $entries = DEFAULT ? !DEF_VALUES ? $default : getMethod('entries') : undefined;
  var $anyNative = NAME == 'Array' ? proto.entries || $native : $native;
  var methods, key, IteratorPrototype;
  // Fix native
  if ($anyNative) {
    IteratorPrototype = getPrototypeOf($anyNative.call(new Base()));
    if (IteratorPrototype !== Object.prototype && IteratorPrototype.next) {
      // Set @@toStringTag to native iterators
      setToStringTag(IteratorPrototype, TAG, true);
      // fix for some old engines
      if (!LIBRARY && typeof IteratorPrototype[ITERATOR] != 'function') hide(IteratorPrototype, ITERATOR, returnThis);
    }
  }
  // fix Array#{values, @@iterator}.name in V8 / FF
  if (DEF_VALUES && $native && $native.name !== VALUES) {
    VALUES_BUG = true;
    $default = function values() { return $native.call(this); };
  }
  // Define iterator
  if ((!LIBRARY || FORCED) && (BUGGY || VALUES_BUG || !proto[ITERATOR])) {
    hide(proto, ITERATOR, $default);
  }
  // Plug for library
  Iterators[NAME] = $default;
  Iterators[TAG] = returnThis;
  if (DEFAULT) {
    methods = {
      values: DEF_VALUES ? $default : getMethod(VALUES),
      keys: IS_SET ? $default : getMethod(KEYS),
      entries: $entries
    };
    if (FORCED) for (key in methods) {
      if (!(key in proto)) redefine(proto, key, methods[key]);
    } else $export($export.P + $export.F * (BUGGY || VALUES_BUG), NAME, methods);
  }
  return methods;
};


/***/ }),
/* 82 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var create = __webpack_require__(38);
var descriptor = __webpack_require__(34);
var setToStringTag = __webpack_require__(46);
var IteratorPrototype = {};

// 25.1.2.1.1 %IteratorPrototype%[@@iterator]()
__webpack_require__(12)(IteratorPrototype, __webpack_require__(5)('iterator'), function () { return this; });

module.exports = function (Constructor, NAME, next) {
  Constructor.prototype = create(IteratorPrototype, { next: descriptor(1, next) });
  setToStringTag(Constructor, NAME + ' Iterator');
};


/***/ }),
/* 83 */
/***/ (function(module, exports, __webpack_require__) {

// helper for String#{startsWith, endsWith, includes}
var isRegExp = __webpack_require__(60);
var defined = __webpack_require__(25);

module.exports = function (that, searchString, NAME) {
  if (isRegExp(searchString)) throw TypeError('String#' + NAME + " doesn't accept regex!");
  return String(defined(that));
};


/***/ }),
/* 84 */
/***/ (function(module, exports, __webpack_require__) {

var MATCH = __webpack_require__(5)('match');
module.exports = function (KEY) {
  var re = /./;
  try {
    '/./'[KEY](re);
  } catch (e) {
    try {
      re[MATCH] = false;
      return !'/./'[KEY](re);
    } catch (f) { /* empty */ }
  } return true;
};


/***/ }),
/* 85 */
/***/ (function(module, exports, __webpack_require__) {

// check on default Array iterator
var Iterators = __webpack_require__(49);
var ITERATOR = __webpack_require__(5)('iterator');
var ArrayProto = Array.prototype;

module.exports = function (it) {
  return it !== undefined && (Iterators.Array === it || ArrayProto[ITERATOR] === it);
};


/***/ }),
/* 86 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $defineProperty = __webpack_require__(8);
var createDesc = __webpack_require__(34);

module.exports = function (object, index, value) {
  if (index in object) $defineProperty.f(object, index, createDesc(0, value));
  else object[index] = value;
};


/***/ }),
/* 87 */
/***/ (function(module, exports, __webpack_require__) {

var classof = __webpack_require__(47);
var ITERATOR = __webpack_require__(5)('iterator');
var Iterators = __webpack_require__(49);
module.exports = __webpack_require__(19).getIteratorMethod = function (it) {
  if (it != undefined) return it[ITERATOR]
    || it['@@iterator']
    || Iterators[classof(it)];
};


/***/ }),
/* 88 */
/***/ (function(module, exports, __webpack_require__) {

// 9.4.2.3 ArraySpeciesCreate(originalArray, length)
var speciesConstructor = __webpack_require__(231);

module.exports = function (original, length) {
  return new (speciesConstructor(original))(length);
};


/***/ }),
/* 89 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
// 22.1.3.6 Array.prototype.fill(value, start = 0, end = this.length)

var toObject = __webpack_require__(10);
var toAbsoluteIndex = __webpack_require__(37);
var toLength = __webpack_require__(6);
module.exports = function fill(value /* , start = 0, end = @length */) {
  var O = toObject(this);
  var length = toLength(O.length);
  var aLen = arguments.length;
  var index = toAbsoluteIndex(aLen > 1 ? arguments[1] : undefined, length);
  var end = aLen > 2 ? arguments[2] : undefined;
  var endPos = end === undefined ? length : toAbsoluteIndex(end, length);
  while (endPos > index) O[index++] = value;
  return O;
};


/***/ }),
/* 90 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var addToUnscopables = __webpack_require__(33);
var step = __webpack_require__(115);
var Iterators = __webpack_require__(49);
var toIObject = __webpack_require__(16);

// 22.1.3.4 Array.prototype.entries()
// 22.1.3.13 Array.prototype.keys()
// 22.1.3.29 Array.prototype.values()
// 22.1.3.30 Array.prototype[@@iterator]()
module.exports = __webpack_require__(81)(Array, 'Array', function (iterated, kind) {
  this._t = toIObject(iterated); // target
  this._i = 0;                   // next index
  this._k = kind;                // kind
// 22.1.5.2.1 %ArrayIteratorPrototype%.next()
}, function () {
  var O = this._t;
  var kind = this._k;
  var index = this._i++;
  if (!O || index >= O.length) {
    this._t = undefined;
    return step(1);
  }
  if (kind == 'keys') return step(0, index);
  if (kind == 'values') return step(0, O[index]);
  return step(0, [index, O[index]]);
}, 'values');

// argumentsList[@@iterator] is %ArrayProto_values% (9.4.4.6, 9.4.4.7)
Iterators.Arguments = Iterators.Array;

addToUnscopables('keys');
addToUnscopables('values');
addToUnscopables('entries');


/***/ }),
/* 91 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var regexpFlags = __webpack_require__(53);

var nativeExec = RegExp.prototype.exec;
// This always refers to the native implementation, because the
// String#replace polyfill uses ./fix-regexp-well-known-symbol-logic.js,
// which loads this file before patching the method.
var nativeReplace = String.prototype.replace;

var patchedExec = nativeExec;

var LAST_INDEX = 'lastIndex';

var UPDATES_LAST_INDEX_WRONG = (function () {
  var re1 = /a/,
      re2 = /b*/g;
  nativeExec.call(re1, 'a');
  nativeExec.call(re2, 'a');
  return re1[LAST_INDEX] !== 0 || re2[LAST_INDEX] !== 0;
})();

// nonparticipating capturing group, copied from es5-shim's String#split patch.
var NPCG_INCLUDED = /()??/.exec('')[1] !== undefined;

var PATCH = UPDATES_LAST_INDEX_WRONG || NPCG_INCLUDED;

if (PATCH) {
  patchedExec = function exec(str) {
    var re = this;
    var lastIndex, reCopy, match, i;

    if (NPCG_INCLUDED) {
      reCopy = new RegExp('^' + re.source + '$(?!\\s)', regexpFlags.call(re));
    }
    if (UPDATES_LAST_INDEX_WRONG) lastIndex = re[LAST_INDEX];

    match = nativeExec.call(re, str);

    if (UPDATES_LAST_INDEX_WRONG && match) {
      re[LAST_INDEX] = re.global ? match.index + match[0].length : lastIndex;
    }
    if (NPCG_INCLUDED && match && match.length > 1) {
      // Fix browsers whose `exec` methods don't consistently return `undefined`
      // for NPCG, like IE8. NOTE: This doesn' work for /(.?)?/
      // eslint-disable-next-line no-loop-func
      nativeReplace.call(match[0], reCopy, function () {
        for (i = 1; i < arguments.length - 2; i++) {
          if (arguments[i] === undefined) match[i] = undefined;
        }
      });
    }

    return match;
  };
}

module.exports = patchedExec;


/***/ }),
/* 92 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var at = __webpack_require__(59)(true);

 // `AdvanceStringIndex` abstract operation
// https://tc39.github.io/ecma262/#sec-advancestringindex
module.exports = function (S, index, unicode) {
  return index + (unicode ? at(S, index).length : 1);
};


/***/ }),
/* 93 */
/***/ (function(module, exports, __webpack_require__) {

var ctx = __webpack_require__(20);
var invoke = __webpack_require__(105);
var html = __webpack_require__(74);
var cel = __webpack_require__(70);
var global = __webpack_require__(2);
var process = global.process;
var setTask = global.setImmediate;
var clearTask = global.clearImmediate;
var MessageChannel = global.MessageChannel;
var Dispatch = global.Dispatch;
var counter = 0;
var queue = {};
var ONREADYSTATECHANGE = 'onreadystatechange';
var defer, channel, port;
var run = function () {
  var id = +this;
  // eslint-disable-next-line no-prototype-builtins
  if (queue.hasOwnProperty(id)) {
    var fn = queue[id];
    delete queue[id];
    fn();
  }
};
var listener = function (event) {
  run.call(event.data);
};
// Node.js 0.9+ & IE10+ has setImmediate, otherwise:
if (!setTask || !clearTask) {
  setTask = function setImmediate(fn) {
    var args = [];
    var i = 1;
    while (arguments.length > i) args.push(arguments[i++]);
    queue[++counter] = function () {
      // eslint-disable-next-line no-new-func
      invoke(typeof fn == 'function' ? fn : Function(fn), args);
    };
    defer(counter);
    return counter;
  };
  clearTask = function clearImmediate(id) {
    delete queue[id];
  };
  // Node.js 0.8-
  if (__webpack_require__(21)(process) == 'process') {
    defer = function (id) {
      process.nextTick(ctx(run, id, 1));
    };
  // Sphere (JS game engine) Dispatch API
  } else if (Dispatch && Dispatch.now) {
    defer = function (id) {
      Dispatch.now(ctx(run, id, 1));
    };
  // Browsers with MessageChannel, includes WebWorkers
  } else if (MessageChannel) {
    channel = new MessageChannel();
    port = channel.port2;
    channel.port1.onmessage = listener;
    defer = ctx(port.postMessage, port, 1);
  // Browsers with postMessage, skip WebWorkers
  // IE8 has postMessage, but it's sync & typeof its postMessage is 'object'
  } else if (global.addEventListener && typeof postMessage == 'function' && !global.importScripts) {
    defer = function (id) {
      global.postMessage(id + '', '*');
    };
    global.addEventListener('message', listener, false);
  // IE8-
  } else if (ONREADYSTATECHANGE in cel('script')) {
    defer = function (id) {
      html.appendChild(cel('script'))[ONREADYSTATECHANGE] = function () {
        html.removeChild(this);
        run.call(id);
      };
    };
  // Rest old browsers
  } else {
    defer = function (id) {
      setTimeout(ctx(run, id, 1), 0);
    };
  }
}
module.exports = {
  set: setTask,
  clear: clearTask
};


/***/ }),
/* 94 */
/***/ (function(module, exports, __webpack_require__) {

var global = __webpack_require__(2);
var macrotask = __webpack_require__(93).set;
var Observer = global.MutationObserver || global.WebKitMutationObserver;
var process = global.process;
var Promise = global.Promise;
var isNode = __webpack_require__(21)(process) == 'process';

module.exports = function () {
  var head, last, notify;

  var flush = function () {
    var parent, fn;
    if (isNode && (parent = process.domain)) parent.exit();
    while (head) {
      fn = head.fn;
      head = head.next;
      try {
        fn();
      } catch (e) {
        if (head) notify();
        else last = undefined;
        throw e;
      }
    } last = undefined;
    if (parent) parent.enter();
  };

  // Node.js
  if (isNode) {
    notify = function () {
      process.nextTick(flush);
    };
  // browsers with MutationObserver, except iOS Safari - https://github.com/zloirock/core-js/issues/339
  } else if (Observer && !(global.navigator && global.navigator.standalone)) {
    var toggle = true;
    var node = document.createTextNode('');
    new Observer(flush).observe(node, { characterData: true }); // eslint-disable-line no-new
    notify = function () {
      node.data = toggle = !toggle;
    };
  // environments with maybe non-completely correct, but existent Promise
  } else if (Promise && Promise.resolve) {
    // Promise.resolve without an argument throws an error in LG WebOS 2
    var promise = Promise.resolve(undefined);
    notify = function () {
      promise.then(flush);
    };
  // for other environments - macrotask based on:
  // - setImmediate
  // - MessageChannel
  // - window.postMessag
  // - onreadystatechange
  // - setTimeout
  } else {
    notify = function () {
      // strange IE + webpack dev server bug - use .call(global)
      macrotask.call(global, flush);
    };
  }

  return function (fn) {
    var task = { fn: fn, next: undefined };
    if (last) last.next = task;
    if (!head) {
      head = task;
      notify();
    } last = task;
  };
};


/***/ }),
/* 95 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// 25.4.1.5 NewPromiseCapability(C)
var aFunction = __webpack_require__(11);

function PromiseCapability(C) {
  var resolve, reject;
  this.promise = new C(function ($$resolve, $$reject) {
    if (resolve !== undefined || reject !== undefined) throw TypeError('Bad Promise constructor');
    resolve = $$resolve;
    reject = $$reject;
  });
  this.resolve = aFunction(resolve);
  this.reject = aFunction(reject);
}

module.exports.f = function (C) {
  return new PromiseCapability(C);
};


/***/ }),
/* 96 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var global = __webpack_require__(2);
var DESCRIPTORS = __webpack_require__(7);
var LIBRARY = __webpack_require__(31);
var $typed = __webpack_require__(66);
var hide = __webpack_require__(12);
var redefineAll = __webpack_require__(43);
var fails = __webpack_require__(3);
var anInstance = __webpack_require__(41);
var toInteger = __webpack_require__(22);
var toLength = __webpack_require__(6);
var toIndex = __webpack_require__(125);
var gOPN = __webpack_require__(39).f;
var dP = __webpack_require__(8).f;
var arrayFill = __webpack_require__(89);
var setToStringTag = __webpack_require__(46);
var ARRAY_BUFFER = 'ArrayBuffer';
var DATA_VIEW = 'DataView';
var PROTOTYPE = 'prototype';
var WRONG_LENGTH = 'Wrong length!';
var WRONG_INDEX = 'Wrong index!';
var $ArrayBuffer = global[ARRAY_BUFFER];
var $DataView = global[DATA_VIEW];
var Math = global.Math;
var RangeError = global.RangeError;
// eslint-disable-next-line no-shadow-restricted-names
var Infinity = global.Infinity;
var BaseBuffer = $ArrayBuffer;
var abs = Math.abs;
var pow = Math.pow;
var floor = Math.floor;
var log = Math.log;
var LN2 = Math.LN2;
var BUFFER = 'buffer';
var BYTE_LENGTH = 'byteLength';
var BYTE_OFFSET = 'byteOffset';
var $BUFFER = DESCRIPTORS ? '_b' : BUFFER;
var $LENGTH = DESCRIPTORS ? '_l' : BYTE_LENGTH;
var $OFFSET = DESCRIPTORS ? '_o' : BYTE_OFFSET;

// IEEE754 conversions based on https://github.com/feross/ieee754
function packIEEE754(value, mLen, nBytes) {
  var buffer = new Array(nBytes);
  var eLen = nBytes * 8 - mLen - 1;
  var eMax = (1 << eLen) - 1;
  var eBias = eMax >> 1;
  var rt = mLen === 23 ? pow(2, -24) - pow(2, -77) : 0;
  var i = 0;
  var s = value < 0 || value === 0 && 1 / value < 0 ? 1 : 0;
  var e, m, c;
  value = abs(value);
  // eslint-disable-next-line no-self-compare
  if (value != value || value === Infinity) {
    // eslint-disable-next-line no-self-compare
    m = value != value ? 1 : 0;
    e = eMax;
  } else {
    e = floor(log(value) / LN2);
    if (value * (c = pow(2, -e)) < 1) {
      e--;
      c *= 2;
    }
    if (e + eBias >= 1) {
      value += rt / c;
    } else {
      value += rt * pow(2, 1 - eBias);
    }
    if (value * c >= 2) {
      e++;
      c /= 2;
    }
    if (e + eBias >= eMax) {
      m = 0;
      e = eMax;
    } else if (e + eBias >= 1) {
      m = (value * c - 1) * pow(2, mLen);
      e = e + eBias;
    } else {
      m = value * pow(2, eBias - 1) * pow(2, mLen);
      e = 0;
    }
  }
  for (; mLen >= 8; buffer[i++] = m & 255, m /= 256, mLen -= 8);
  e = e << mLen | m;
  eLen += mLen;
  for (; eLen > 0; buffer[i++] = e & 255, e /= 256, eLen -= 8);
  buffer[--i] |= s * 128;
  return buffer;
}
function unpackIEEE754(buffer, mLen, nBytes) {
  var eLen = nBytes * 8 - mLen - 1;
  var eMax = (1 << eLen) - 1;
  var eBias = eMax >> 1;
  var nBits = eLen - 7;
  var i = nBytes - 1;
  var s = buffer[i--];
  var e = s & 127;
  var m;
  s >>= 7;
  for (; nBits > 0; e = e * 256 + buffer[i], i--, nBits -= 8);
  m = e & (1 << -nBits) - 1;
  e >>= -nBits;
  nBits += mLen;
  for (; nBits > 0; m = m * 256 + buffer[i], i--, nBits -= 8);
  if (e === 0) {
    e = 1 - eBias;
  } else if (e === eMax) {
    return m ? NaN : s ? -Infinity : Infinity;
  } else {
    m = m + pow(2, mLen);
    e = e - eBias;
  } return (s ? -1 : 1) * m * pow(2, e - mLen);
}

function unpackI32(bytes) {
  return bytes[3] << 24 | bytes[2] << 16 | bytes[1] << 8 | bytes[0];
}
function packI8(it) {
  return [it & 0xff];
}
function packI16(it) {
  return [it & 0xff, it >> 8 & 0xff];
}
function packI32(it) {
  return [it & 0xff, it >> 8 & 0xff, it >> 16 & 0xff, it >> 24 & 0xff];
}
function packF64(it) {
  return packIEEE754(it, 52, 8);
}
function packF32(it) {
  return packIEEE754(it, 23, 4);
}

function addGetter(C, key, internal) {
  dP(C[PROTOTYPE], key, { get: function () { return this[internal]; } });
}

function get(view, bytes, index, isLittleEndian) {
  var numIndex = +index;
  var intIndex = toIndex(numIndex);
  if (intIndex + bytes > view[$LENGTH]) throw RangeError(WRONG_INDEX);
  var store = view[$BUFFER]._b;
  var start = intIndex + view[$OFFSET];
  var pack = store.slice(start, start + bytes);
  return isLittleEndian ? pack : pack.reverse();
}
function set(view, bytes, index, conversion, value, isLittleEndian) {
  var numIndex = +index;
  var intIndex = toIndex(numIndex);
  if (intIndex + bytes > view[$LENGTH]) throw RangeError(WRONG_INDEX);
  var store = view[$BUFFER]._b;
  var start = intIndex + view[$OFFSET];
  var pack = conversion(+value);
  for (var i = 0; i < bytes; i++) store[start + i] = pack[isLittleEndian ? i : bytes - i - 1];
}

if (!$typed.ABV) {
  $ArrayBuffer = function ArrayBuffer(length) {
    anInstance(this, $ArrayBuffer, ARRAY_BUFFER);
    var byteLength = toIndex(length);
    this._b = arrayFill.call(new Array(byteLength), 0);
    this[$LENGTH] = byteLength;
  };

  $DataView = function DataView(buffer, byteOffset, byteLength) {
    anInstance(this, $DataView, DATA_VIEW);
    anInstance(buffer, $ArrayBuffer, DATA_VIEW);
    var bufferLength = buffer[$LENGTH];
    var offset = toInteger(byteOffset);
    if (offset < 0 || offset > bufferLength) throw RangeError('Wrong offset!');
    byteLength = byteLength === undefined ? bufferLength - offset : toLength(byteLength);
    if (offset + byteLength > bufferLength) throw RangeError(WRONG_LENGTH);
    this[$BUFFER] = buffer;
    this[$OFFSET] = offset;
    this[$LENGTH] = byteLength;
  };

  if (DESCRIPTORS) {
    addGetter($ArrayBuffer, BYTE_LENGTH, '_l');
    addGetter($DataView, BUFFER, '_b');
    addGetter($DataView, BYTE_LENGTH, '_l');
    addGetter($DataView, BYTE_OFFSET, '_o');
  }

  redefineAll($DataView[PROTOTYPE], {
    getInt8: function getInt8(byteOffset) {
      return get(this, 1, byteOffset)[0] << 24 >> 24;
    },
    getUint8: function getUint8(byteOffset) {
      return get(this, 1, byteOffset)[0];
    },
    getInt16: function getInt16(byteOffset /* , littleEndian */) {
      var bytes = get(this, 2, byteOffset, arguments[1]);
      return (bytes[1] << 8 | bytes[0]) << 16 >> 16;
    },
    getUint16: function getUint16(byteOffset /* , littleEndian */) {
      var bytes = get(this, 2, byteOffset, arguments[1]);
      return bytes[1] << 8 | bytes[0];
    },
    getInt32: function getInt32(byteOffset /* , littleEndian */) {
      return unpackI32(get(this, 4, byteOffset, arguments[1]));
    },
    getUint32: function getUint32(byteOffset /* , littleEndian */) {
      return unpackI32(get(this, 4, byteOffset, arguments[1])) >>> 0;
    },
    getFloat32: function getFloat32(byteOffset /* , littleEndian */) {
      return unpackIEEE754(get(this, 4, byteOffset, arguments[1]), 23, 4);
    },
    getFloat64: function getFloat64(byteOffset /* , littleEndian */) {
      return unpackIEEE754(get(this, 8, byteOffset, arguments[1]), 52, 8);
    },
    setInt8: function setInt8(byteOffset, value) {
      set(this, 1, byteOffset, packI8, value);
    },
    setUint8: function setUint8(byteOffset, value) {
      set(this, 1, byteOffset, packI8, value);
    },
    setInt16: function setInt16(byteOffset, value /* , littleEndian */) {
      set(this, 2, byteOffset, packI16, value, arguments[2]);
    },
    setUint16: function setUint16(byteOffset, value /* , littleEndian */) {
      set(this, 2, byteOffset, packI16, value, arguments[2]);
    },
    setInt32: function setInt32(byteOffset, value /* , littleEndian */) {
      set(this, 4, byteOffset, packI32, value, arguments[2]);
    },
    setUint32: function setUint32(byteOffset, value /* , littleEndian */) {
      set(this, 4, byteOffset, packI32, value, arguments[2]);
    },
    setFloat32: function setFloat32(byteOffset, value /* , littleEndian */) {
      set(this, 4, byteOffset, packF32, value, arguments[2]);
    },
    setFloat64: function setFloat64(byteOffset, value /* , littleEndian */) {
      set(this, 8, byteOffset, packF64, value, arguments[2]);
    }
  });
} else {
  if (!fails(function () {
    $ArrayBuffer(1);
  }) || !fails(function () {
    new $ArrayBuffer(-1); // eslint-disable-line no-new
  }) || fails(function () {
    new $ArrayBuffer(); // eslint-disable-line no-new
    new $ArrayBuffer(1.5); // eslint-disable-line no-new
    new $ArrayBuffer(NaN); // eslint-disable-line no-new
    return $ArrayBuffer.name != ARRAY_BUFFER;
  })) {
    $ArrayBuffer = function ArrayBuffer(length) {
      anInstance(this, $ArrayBuffer);
      return new BaseBuffer(toIndex(length));
    };
    var ArrayBufferProto = $ArrayBuffer[PROTOTYPE] = BaseBuffer[PROTOTYPE];
    for (var keys = gOPN(BaseBuffer), j = 0, key; keys.length > j;) {
      if (!((key = keys[j++]) in $ArrayBuffer)) hide($ArrayBuffer, key, BaseBuffer[key]);
    }
    if (!LIBRARY) ArrayBufferProto.constructor = $ArrayBuffer;
  }
  // iOS Safari 7.x bug
  var view = new $DataView(new $ArrayBuffer(2));
  var $setInt8 = $DataView[PROTOTYPE].setInt8;
  view.setInt8(0, 2147483648);
  view.setInt8(1, 2147483649);
  if (view.getInt8(0) || !view.getInt8(1)) redefineAll($DataView[PROTOTYPE], {
    setInt8: function setInt8(byteOffset, value) {
      $setInt8.call(this, byteOffset, value << 24 >> 24);
    },
    setUint8: function setUint8(byteOffset, value) {
      $setInt8.call(this, byteOffset, value << 24 >> 24);
    }
  }, true);
}
setToStringTag($ArrayBuffer, ARRAY_BUFFER);
setToStringTag($DataView, DATA_VIEW);
hide($DataView[PROTOTYPE], $typed.VIEW, true);
exports[ARRAY_BUFFER] = $ArrayBuffer;
exports[DATA_VIEW] = $DataView;


/***/ }),
/* 97 */
/***/ (function(module, exports, __webpack_require__) {

module.exports = !__webpack_require__(7) && !__webpack_require__(3)(function () {
  return Object.defineProperty(__webpack_require__(70)('div'), 'a', { get: function () { return 7; } }).a != 7;
});


/***/ }),
/* 98 */
/***/ (function(module, exports, __webpack_require__) {

exports.f = __webpack_require__(5);


/***/ }),
/* 99 */
/***/ (function(module, exports, __webpack_require__) {

var has = __webpack_require__(15);
var toIObject = __webpack_require__(16);
var arrayIndexOf = __webpack_require__(56)(false);
var IE_PROTO = __webpack_require__(72)('IE_PROTO');

module.exports = function (object, names) {
  var O = toIObject(object);
  var i = 0;
  var result = [];
  var key;
  for (key in O) if (key != IE_PROTO) has(O, key) && result.push(key);
  // Don't enum bug & hidden keys
  while (names.length > i) if (has(O, key = names[i++])) {
    ~arrayIndexOf(result, key) || result.push(key);
  }
  return result;
};


/***/ }),
/* 100 */
/***/ (function(module, exports, __webpack_require__) {

var dP = __webpack_require__(8);
var anObject = __webpack_require__(1);
var getKeys = __webpack_require__(36);

module.exports = __webpack_require__(7) ? Object.defineProperties : function defineProperties(O, Properties) {
  anObject(O);
  var keys = getKeys(Properties);
  var length = keys.length;
  var i = 0;
  var P;
  while (length > i) dP.f(O, P = keys[i++], Properties[P]);
  return O;
};


/***/ }),
/* 101 */
/***/ (function(module, exports, __webpack_require__) {

// fallback for IE11 buggy Object.getOwnPropertyNames with iframe and window
var toIObject = __webpack_require__(16);
var gOPN = __webpack_require__(39).f;
var toString = {}.toString;

var windowNames = typeof window == 'object' && window && Object.getOwnPropertyNames
  ? Object.getOwnPropertyNames(window) : [];

var getWindowNames = function (it) {
  try {
    return gOPN(it);
  } catch (e) {
    return windowNames.slice();
  }
};

module.exports.f = function getOwnPropertyNames(it) {
  return windowNames && toString.call(it) == '[object Window]' ? getWindowNames(it) : gOPN(toIObject(it));
};


/***/ }),
/* 102 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// 19.1.2.1 Object.assign(target, source, ...)
var DESCRIPTORS = __webpack_require__(7);
var getKeys = __webpack_require__(36);
var gOPS = __webpack_require__(57);
var pIE = __webpack_require__(52);
var toObject = __webpack_require__(10);
var IObject = __webpack_require__(51);
var $assign = Object.assign;

// should work with symbols and should have deterministic property order (V8 bug)
module.exports = !$assign || __webpack_require__(3)(function () {
  var A = {};
  var B = {};
  // eslint-disable-next-line no-undef
  var S = Symbol();
  var K = 'abcdefghijklmnopqrst';
  A[S] = 7;
  K.split('').forEach(function (k) { B[k] = k; });
  return $assign({}, A)[S] != 7 || Object.keys($assign({}, B)).join('') != K;
}) ? function assign(target, source) { // eslint-disable-line no-unused-vars
  var T = toObject(target);
  var aLen = arguments.length;
  var index = 1;
  var getSymbols = gOPS.f;
  var isEnum = pIE.f;
  while (aLen > index) {
    var S = IObject(arguments[index++]);
    var keys = getSymbols ? getKeys(S).concat(getSymbols(S)) : getKeys(S);
    var length = keys.length;
    var j = 0;
    var key;
    while (length > j) {
      key = keys[j++];
      if (!DESCRIPTORS || isEnum.call(S, key)) T[key] = S[key];
    }
  } return T;
} : $assign;


/***/ }),
/* 103 */
/***/ (function(module, exports) {

// 7.2.9 SameValue(x, y)
module.exports = Object.is || function is(x, y) {
  // eslint-disable-next-line no-self-compare
  return x === y ? x !== 0 || 1 / x === 1 / y : x != x && y != y;
};


/***/ }),
/* 104 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var aFunction = __webpack_require__(11);
var isObject = __webpack_require__(4);
var invoke = __webpack_require__(105);
var arraySlice = [].slice;
var factories = {};

var construct = function (F, len, args) {
  if (!(len in factories)) {
    for (var n = [], i = 0; i < len; i++) n[i] = 'a[' + i + ']';
    // eslint-disable-next-line no-new-func
    factories[len] = Function('F,a', 'return new F(' + n.join(',') + ')');
  } return factories[len](F, args);
};

module.exports = Function.bind || function bind(that /* , ...args */) {
  var fn = aFunction(this);
  var partArgs = arraySlice.call(arguments, 1);
  var bound = function (/* args... */) {
    var args = partArgs.concat(arraySlice.call(arguments));
    return this instanceof bound ? construct(fn, args.length, args) : invoke(fn, args, that);
  };
  if (isObject(fn.prototype)) bound.prototype = fn.prototype;
  return bound;
};


/***/ }),
/* 105 */
/***/ (function(module, exports) {

// fast apply, http://jsperf.lnkit.com/fast-apply/5
module.exports = function (fn, args, that) {
  var un = that === undefined;
  switch (args.length) {
    case 0: return un ? fn()
                      : fn.call(that);
    case 1: return un ? fn(args[0])
                      : fn.call(that, args[0]);
    case 2: return un ? fn(args[0], args[1])
                      : fn.call(that, args[0], args[1]);
    case 3: return un ? fn(args[0], args[1], args[2])
                      : fn.call(that, args[0], args[1], args[2]);
    case 4: return un ? fn(args[0], args[1], args[2], args[3])
                      : fn.call(that, args[0], args[1], args[2], args[3]);
  } return fn.apply(that, args);
};


/***/ }),
/* 106 */
/***/ (function(module, exports, __webpack_require__) {

var $parseInt = __webpack_require__(2).parseInt;
var $trim = __webpack_require__(48).trim;
var ws = __webpack_require__(76);
var hex = /^[-+]?0[xX]/;

module.exports = $parseInt(ws + '08') !== 8 || $parseInt(ws + '0x16') !== 22 ? function parseInt(str, radix) {
  var string = $trim(String(str), 3);
  return $parseInt(string, (radix >>> 0) || (hex.test(string) ? 16 : 10));
} : $parseInt;


/***/ }),
/* 107 */
/***/ (function(module, exports, __webpack_require__) {

var $parseFloat = __webpack_require__(2).parseFloat;
var $trim = __webpack_require__(48).trim;

module.exports = 1 / $parseFloat(__webpack_require__(76) + '-0') !== -Infinity ? function parseFloat(str) {
  var string = $trim(String(str), 3);
  var result = $parseFloat(string);
  return result === 0 && string.charAt(0) == '-' ? -0 : result;
} : $parseFloat;


/***/ }),
/* 108 */
/***/ (function(module, exports, __webpack_require__) {

var cof = __webpack_require__(21);
module.exports = function (it, msg) {
  if (typeof it != 'number' && cof(it) != 'Number') throw TypeError(msg);
  return +it;
};


/***/ }),
/* 109 */
/***/ (function(module, exports, __webpack_require__) {

// 20.1.2.3 Number.isInteger(number)
var isObject = __webpack_require__(4);
var floor = Math.floor;
module.exports = function isInteger(it) {
  return !isObject(it) && isFinite(it) && floor(it) === it;
};


/***/ }),
/* 110 */
/***/ (function(module, exports) {

// 20.2.2.20 Math.log1p(x)
module.exports = Math.log1p || function log1p(x) {
  return (x = +x) > -1e-8 && x < 1e-8 ? x - x * x / 2 : Math.log(1 + x);
};


/***/ }),
/* 111 */
/***/ (function(module, exports, __webpack_require__) {

// 20.2.2.16 Math.fround(x)
var sign = __webpack_require__(79);
var pow = Math.pow;
var EPSILON = pow(2, -52);
var EPSILON32 = pow(2, -23);
var MAX32 = pow(2, 127) * (2 - EPSILON32);
var MIN32 = pow(2, -126);

var roundTiesToEven = function (n) {
  return n + 1 / EPSILON - 1 / EPSILON;
};

module.exports = Math.fround || function fround(x) {
  var $abs = Math.abs(x);
  var $sign = sign(x);
  var a, result;
  if ($abs < MIN32) return $sign * roundTiesToEven($abs / MIN32 / EPSILON32) * MIN32 * EPSILON32;
  a = (1 + EPSILON32 / EPSILON) * $abs;
  result = a - (a - $abs);
  // eslint-disable-next-line no-self-compare
  if (result > MAX32 || result != result) return $sign * Infinity;
  return $sign * result;
};


/***/ }),
/* 112 */
/***/ (function(module, exports, __webpack_require__) {

// call something on iterator step with safe closing on error
var anObject = __webpack_require__(1);
module.exports = function (iterator, fn, value, entries) {
  try {
    return entries ? fn(anObject(value)[0], value[1]) : fn(value);
  // 7.4.6 IteratorClose(iterator, completion)
  } catch (e) {
    var ret = iterator['return'];
    if (ret !== undefined) anObject(ret.call(iterator));
    throw e;
  }
};


/***/ }),
/* 113 */
/***/ (function(module, exports, __webpack_require__) {

var aFunction = __webpack_require__(11);
var toObject = __webpack_require__(10);
var IObject = __webpack_require__(51);
var toLength = __webpack_require__(6);

module.exports = function (that, callbackfn, aLen, memo, isRight) {
  aFunction(callbackfn);
  var O = toObject(that);
  var self = IObject(O);
  var length = toLength(O.length);
  var index = isRight ? length - 1 : 0;
  var i = isRight ? -1 : 1;
  if (aLen < 2) for (;;) {
    if (index in self) {
      memo = self[index];
      index += i;
      break;
    }
    index += i;
    if (isRight ? index < 0 : length <= index) {
      throw TypeError('Reduce of empty array with no initial value');
    }
  }
  for (;isRight ? index >= 0 : length > index; index += i) if (index in self) {
    memo = callbackfn(memo, self[index], index, O);
  }
  return memo;
};


/***/ }),
/* 114 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
// 22.1.3.3 Array.prototype.copyWithin(target, start, end = this.length)

var toObject = __webpack_require__(10);
var toAbsoluteIndex = __webpack_require__(37);
var toLength = __webpack_require__(6);

module.exports = [].copyWithin || function copyWithin(target /* = 0 */, start /* = 0, end = @length */) {
  var O = toObject(this);
  var len = toLength(O.length);
  var to = toAbsoluteIndex(target, len);
  var from = toAbsoluteIndex(start, len);
  var end = arguments.length > 2 ? arguments[2] : undefined;
  var count = Math.min((end === undefined ? len : toAbsoluteIndex(end, len)) - from, len - to);
  var inc = 1;
  if (from < to && to < from + count) {
    inc = -1;
    from += count - 1;
    to += count - 1;
  }
  while (count-- > 0) {
    if (from in O) O[to] = O[from];
    else delete O[to];
    to += inc;
    from += inc;
  } return O;
};


/***/ }),
/* 115 */
/***/ (function(module, exports) {

module.exports = function (done, value) {
  return { value: value, done: !!done };
};


/***/ }),
/* 116 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var regexpExec = __webpack_require__(91);
__webpack_require__(0)({
  target: 'RegExp',
  proto: true,
  forced: regexpExec !== /./.exec
}, {
  exec: regexpExec
});


/***/ }),
/* 117 */
/***/ (function(module, exports, __webpack_require__) {

// 21.2.5.3 get RegExp.prototype.flags()
if (__webpack_require__(7) && /./g.flags != 'g') __webpack_require__(8).f(RegExp.prototype, 'flags', {
  configurable: true,
  get: __webpack_require__(53)
});


/***/ }),
/* 118 */
/***/ (function(module, exports) {

module.exports = function (exec) {
  try {
    return { e: false, v: exec() };
  } catch (e) {
    return { e: true, v: e };
  }
};


/***/ }),
/* 119 */
/***/ (function(module, exports, __webpack_require__) {

var anObject = __webpack_require__(1);
var isObject = __webpack_require__(4);
var newPromiseCapability = __webpack_require__(95);

module.exports = function (C, x) {
  anObject(C);
  if (isObject(x) && x.constructor === C) return x;
  var promiseCapability = newPromiseCapability.f(C);
  var resolve = promiseCapability.resolve;
  resolve(x);
  return promiseCapability.promise;
};


/***/ }),
/* 120 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var strong = __webpack_require__(121);
var validate = __webpack_require__(44);
var MAP = 'Map';

// 23.1 Map Objects
module.exports = __webpack_require__(65)(MAP, function (get) {
  return function Map() { return get(this, arguments.length > 0 ? arguments[0] : undefined); };
}, {
  // 23.1.3.6 Map.prototype.get(key)
  get: function get(key) {
    var entry = strong.getEntry(validate(this, MAP), key);
    return entry && entry.v;
  },
  // 23.1.3.9 Map.prototype.set(key, value)
  set: function set(key, value) {
    return strong.def(validate(this, MAP), key === 0 ? 0 : key, value);
  }
}, strong, true);


/***/ }),
/* 121 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var dP = __webpack_require__(8).f;
var create = __webpack_require__(38);
var redefineAll = __webpack_require__(43);
var ctx = __webpack_require__(20);
var anInstance = __webpack_require__(41);
var forOf = __webpack_require__(42);
var $iterDefine = __webpack_require__(81);
var step = __webpack_require__(115);
var setSpecies = __webpack_require__(40);
var DESCRIPTORS = __webpack_require__(7);
var fastKey = __webpack_require__(32).fastKey;
var validate = __webpack_require__(44);
var SIZE = DESCRIPTORS ? '_s' : 'size';

var getEntry = function (that, key) {
  // fast case
  var index = fastKey(key);
  var entry;
  if (index !== 'F') return that._i[index];
  // frozen object case
  for (entry = that._f; entry; entry = entry.n) {
    if (entry.k == key) return entry;
  }
};

module.exports = {
  getConstructor: function (wrapper, NAME, IS_MAP, ADDER) {
    var C = wrapper(function (that, iterable) {
      anInstance(that, C, NAME, '_i');
      that._t = NAME;         // collection type
      that._i = create(null); // index
      that._f = undefined;    // first entry
      that._l = undefined;    // last entry
      that[SIZE] = 0;         // size
      if (iterable != undefined) forOf(iterable, IS_MAP, that[ADDER], that);
    });
    redefineAll(C.prototype, {
      // 23.1.3.1 Map.prototype.clear()
      // 23.2.3.2 Set.prototype.clear()
      clear: function clear() {
        for (var that = validate(this, NAME), data = that._i, entry = that._f; entry; entry = entry.n) {
          entry.r = true;
          if (entry.p) entry.p = entry.p.n = undefined;
          delete data[entry.i];
        }
        that._f = that._l = undefined;
        that[SIZE] = 0;
      },
      // 23.1.3.3 Map.prototype.delete(key)
      // 23.2.3.4 Set.prototype.delete(value)
      'delete': function (key) {
        var that = validate(this, NAME);
        var entry = getEntry(that, key);
        if (entry) {
          var next = entry.n;
          var prev = entry.p;
          delete that._i[entry.i];
          entry.r = true;
          if (prev) prev.n = next;
          if (next) next.p = prev;
          if (that._f == entry) that._f = next;
          if (that._l == entry) that._l = prev;
          that[SIZE]--;
        } return !!entry;
      },
      // 23.2.3.6 Set.prototype.forEach(callbackfn, thisArg = undefined)
      // 23.1.3.5 Map.prototype.forEach(callbackfn, thisArg = undefined)
      forEach: function forEach(callbackfn /* , that = undefined */) {
        validate(this, NAME);
        var f = ctx(callbackfn, arguments.length > 1 ? arguments[1] : undefined, 3);
        var entry;
        while (entry = entry ? entry.n : this._f) {
          f(entry.v, entry.k, this);
          // revert to the last existing entry
          while (entry && entry.r) entry = entry.p;
        }
      },
      // 23.1.3.7 Map.prototype.has(key)
      // 23.2.3.7 Set.prototype.has(value)
      has: function has(key) {
        return !!getEntry(validate(this, NAME), key);
      }
    });
    if (DESCRIPTORS) dP(C.prototype, 'size', {
      get: function () {
        return validate(this, NAME)[SIZE];
      }
    });
    return C;
  },
  def: function (that, key, value) {
    var entry = getEntry(that, key);
    var prev, index;
    // change existing entry
    if (entry) {
      entry.v = value;
    // create new entry
    } else {
      that._l = entry = {
        i: index = fastKey(key, true), // <- index
        k: key,                        // <- key
        v: value,                      // <- value
        p: prev = that._l,             // <- previous entry
        n: undefined,                  // <- next entry
        r: false                       // <- removed
      };
      if (!that._f) that._f = entry;
      if (prev) prev.n = entry;
      that[SIZE]++;
      // add to index
      if (index !== 'F') that._i[index] = entry;
    } return that;
  },
  getEntry: getEntry,
  setStrong: function (C, NAME, IS_MAP) {
    // add .keys, .values, .entries, [@@iterator]
    // 23.1.3.4, 23.1.3.8, 23.1.3.11, 23.1.3.12, 23.2.3.5, 23.2.3.8, 23.2.3.10, 23.2.3.11
    $iterDefine(C, NAME, function (iterated, kind) {
      this._t = validate(iterated, NAME); // target
      this._k = kind;                     // kind
      this._l = undefined;                // previous
    }, function () {
      var that = this;
      var kind = that._k;
      var entry = that._l;
      // revert to the last existing entry
      while (entry && entry.r) entry = entry.p;
      // get next entry
      if (!that._t || !(that._l = entry = entry ? entry.n : that._t._f)) {
        // or finish the iteration
        that._t = undefined;
        return step(1);
      }
      // return step by kind
      if (kind == 'keys') return step(0, entry.k);
      if (kind == 'values') return step(0, entry.v);
      return step(0, [entry.k, entry.v]);
    }, IS_MAP ? 'entries' : 'values', !IS_MAP, true);

    // add [@@species], 23.1.2.2, 23.2.2.2
    setSpecies(NAME);
  }
};


/***/ }),
/* 122 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var strong = __webpack_require__(121);
var validate = __webpack_require__(44);
var SET = 'Set';

// 23.2 Set Objects
module.exports = __webpack_require__(65)(SET, function (get) {
  return function Set() { return get(this, arguments.length > 0 ? arguments[0] : undefined); };
}, {
  // 23.2.3.1 Set.prototype.add(value)
  add: function add(value) {
    return strong.def(validate(this, SET), value = value === 0 ? 0 : value, value);
  }
}, strong);


/***/ }),
/* 123 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var global = __webpack_require__(2);
var each = __webpack_require__(27)(0);
var redefine = __webpack_require__(13);
var meta = __webpack_require__(32);
var assign = __webpack_require__(102);
var weak = __webpack_require__(124);
var isObject = __webpack_require__(4);
var validate = __webpack_require__(44);
var NATIVE_WEAK_MAP = __webpack_require__(44);
var IS_IE11 = !global.ActiveXObject && 'ActiveXObject' in global;
var WEAK_MAP = 'WeakMap';
var getWeak = meta.getWeak;
var isExtensible = Object.isExtensible;
var uncaughtFrozenStore = weak.ufstore;
var InternalMap;

var wrapper = function (get) {
  return function WeakMap() {
    return get(this, arguments.length > 0 ? arguments[0] : undefined);
  };
};

var methods = {
  // 23.3.3.3 WeakMap.prototype.get(key)
  get: function get(key) {
    if (isObject(key)) {
      var data = getWeak(key);
      if (data === true) return uncaughtFrozenStore(validate(this, WEAK_MAP)).get(key);
      return data ? data[this._i] : undefined;
    }
  },
  // 23.3.3.5 WeakMap.prototype.set(key, value)
  set: function set(key, value) {
    return weak.def(validate(this, WEAK_MAP), key, value);
  }
};

// 23.3 WeakMap Objects
var $WeakMap = module.exports = __webpack_require__(65)(WEAK_MAP, wrapper, methods, weak, true, true);

// IE11 WeakMap frozen keys fix
if (NATIVE_WEAK_MAP && IS_IE11) {
  InternalMap = weak.getConstructor(wrapper, WEAK_MAP);
  assign(InternalMap.prototype, methods);
  meta.NEED = true;
  each(['delete', 'has', 'get', 'set'], function (key) {
    var proto = $WeakMap.prototype;
    var method = proto[key];
    redefine(proto, key, function (a, b) {
      // store frozen objects on internal weakmap shim
      if (isObject(a) && !isExtensible(a)) {
        if (!this._f) this._f = new InternalMap();
        var result = this._f[key](a, b);
        return key == 'set' ? this : result;
      // store all the rest on native weakmap
      } return method.call(this, a, b);
    });
  });
}


/***/ }),
/* 124 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var redefineAll = __webpack_require__(43);
var getWeak = __webpack_require__(32).getWeak;
var anObject = __webpack_require__(1);
var isObject = __webpack_require__(4);
var anInstance = __webpack_require__(41);
var forOf = __webpack_require__(42);
var createArrayMethod = __webpack_require__(27);
var $has = __webpack_require__(15);
var validate = __webpack_require__(44);
var arrayFind = createArrayMethod(5);
var arrayFindIndex = createArrayMethod(6);
var id = 0;

// fallback for uncaught frozen keys
var uncaughtFrozenStore = function (that) {
  return that._l || (that._l = new UncaughtFrozenStore());
};
var UncaughtFrozenStore = function () {
  this.a = [];
};
var findUncaughtFrozen = function (store, key) {
  return arrayFind(store.a, function (it) {
    return it[0] === key;
  });
};
UncaughtFrozenStore.prototype = {
  get: function (key) {
    var entry = findUncaughtFrozen(this, key);
    if (entry) return entry[1];
  },
  has: function (key) {
    return !!findUncaughtFrozen(this, key);
  },
  set: function (key, value) {
    var entry = findUncaughtFrozen(this, key);
    if (entry) entry[1] = value;
    else this.a.push([key, value]);
  },
  'delete': function (key) {
    var index = arrayFindIndex(this.a, function (it) {
      return it[0] === key;
    });
    if (~index) this.a.splice(index, 1);
    return !!~index;
  }
};

module.exports = {
  getConstructor: function (wrapper, NAME, IS_MAP, ADDER) {
    var C = wrapper(function (that, iterable) {
      anInstance(that, C, NAME, '_i');
      that._t = NAME;      // collection type
      that._i = id++;      // collection id
      that._l = undefined; // leak store for uncaught frozen objects
      if (iterable != undefined) forOf(iterable, IS_MAP, that[ADDER], that);
    });
    redefineAll(C.prototype, {
      // 23.3.3.2 WeakMap.prototype.delete(key)
      // 23.4.3.3 WeakSet.prototype.delete(value)
      'delete': function (key) {
        if (!isObject(key)) return false;
        var data = getWeak(key);
        if (data === true) return uncaughtFrozenStore(validate(this, NAME))['delete'](key);
        return data && $has(data, this._i) && delete data[this._i];
      },
      // 23.3.3.4 WeakMap.prototype.has(key)
      // 23.4.3.4 WeakSet.prototype.has(value)
      has: function has(key) {
        if (!isObject(key)) return false;
        var data = getWeak(key);
        if (data === true) return uncaughtFrozenStore(validate(this, NAME)).has(key);
        return data && $has(data, this._i);
      }
    });
    return C;
  },
  def: function (that, key, value) {
    var data = getWeak(anObject(key), true);
    if (data === true) uncaughtFrozenStore(that).set(key, value);
    else data[that._i] = value;
    return that;
  },
  ufstore: uncaughtFrozenStore
};


/***/ }),
/* 125 */
/***/ (function(module, exports, __webpack_require__) {

// https://tc39.github.io/ecma262/#sec-toindex
var toInteger = __webpack_require__(22);
var toLength = __webpack_require__(6);
module.exports = function (it) {
  if (it === undefined) return 0;
  var number = toInteger(it);
  var length = toLength(number);
  if (number !== length) throw RangeError('Wrong length!');
  return length;
};


/***/ }),
/* 126 */
/***/ (function(module, exports, __webpack_require__) {

// all object keys, includes non-enumerable and symbols
var gOPN = __webpack_require__(39);
var gOPS = __webpack_require__(57);
var anObject = __webpack_require__(1);
var Reflect = __webpack_require__(2).Reflect;
module.exports = Reflect && Reflect.ownKeys || function ownKeys(it) {
  var keys = gOPN.f(anObject(it));
  var getSymbols = gOPS.f;
  return getSymbols ? keys.concat(getSymbols(it)) : keys;
};


/***/ }),
/* 127 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// https://tc39.github.io/proposal-flatMap/#sec-FlattenIntoArray
var isArray = __webpack_require__(58);
var isObject = __webpack_require__(4);
var toLength = __webpack_require__(6);
var ctx = __webpack_require__(20);
var IS_CONCAT_SPREADABLE = __webpack_require__(5)('isConcatSpreadable');

function flattenIntoArray(target, original, source, sourceLen, start, depth, mapper, thisArg) {
  var targetIndex = start;
  var sourceIndex = 0;
  var mapFn = mapper ? ctx(mapper, thisArg, 3) : false;
  var element, spreadable;

  while (sourceIndex < sourceLen) {
    if (sourceIndex in source) {
      element = mapFn ? mapFn(source[sourceIndex], sourceIndex, original) : source[sourceIndex];

      spreadable = false;
      if (isObject(element)) {
        spreadable = element[IS_CONCAT_SPREADABLE];
        spreadable = spreadable !== undefined ? !!spreadable : isArray(element);
      }

      if (spreadable && depth > 0) {
        targetIndex = flattenIntoArray(target, original, element, toLength(element.length), targetIndex, depth - 1) - 1;
      } else {
        if (targetIndex >= 0x1fffffffffffff) throw TypeError();
        target[targetIndex] = element;
      }

      targetIndex++;
    }
    sourceIndex++;
  }
  return targetIndex;
}

module.exports = flattenIntoArray;


/***/ }),
/* 128 */
/***/ (function(module, exports, __webpack_require__) {

// https://github.com/tc39/proposal-string-pad-start-end
var toLength = __webpack_require__(6);
var repeat = __webpack_require__(78);
var defined = __webpack_require__(25);

module.exports = function (that, maxLength, fillString, left) {
  var S = String(defined(that));
  var stringLength = S.length;
  var fillStr = fillString === undefined ? ' ' : String(fillString);
  var intMaxLength = toLength(maxLength);
  if (intMaxLength <= stringLength || fillStr == '') return S;
  var fillLen = intMaxLength - stringLength;
  var stringFiller = repeat.call(fillStr, Math.ceil(fillLen / fillStr.length));
  if (stringFiller.length > fillLen) stringFiller = stringFiller.slice(0, fillLen);
  return left ? stringFiller + S : S + stringFiller;
};


/***/ }),
/* 129 */
/***/ (function(module, exports, __webpack_require__) {

var DESCRIPTORS = __webpack_require__(7);
var getKeys = __webpack_require__(36);
var toIObject = __webpack_require__(16);
var isEnum = __webpack_require__(52).f;
module.exports = function (isEntries) {
  return function (it) {
    var O = toIObject(it);
    var keys = getKeys(O);
    var length = keys.length;
    var i = 0;
    var result = [];
    var key;
    while (length > i) {
      key = keys[i++];
      if (!DESCRIPTORS || isEnum.call(O, key)) {
        result.push(isEntries ? [key, O[key]] : O[key]);
      }
    }
    return result;
  };
};


/***/ }),
/* 130 */
/***/ (function(module, exports, __webpack_require__) {

// https://github.com/DavidBruant/Map-Set.prototype.toJSON
var classof = __webpack_require__(47);
var from = __webpack_require__(131);
module.exports = function (NAME) {
  return function toJSON() {
    if (classof(this) != NAME) throw TypeError(NAME + "#toJSON isn't generic");
    return from(this);
  };
};


/***/ }),
/* 131 */
/***/ (function(module, exports, __webpack_require__) {

var forOf = __webpack_require__(42);

module.exports = function (iter, ITERATOR) {
  var result = [];
  forOf(iter, false, result.push, result, ITERATOR);
  return result;
};


/***/ }),
/* 132 */
/***/ (function(module, exports) {

// https://rwaldron.github.io/proposal-math-extensions/
module.exports = Math.scale || function scale(x, inLow, inHigh, outLow, outHigh) {
  if (
    arguments.length === 0
      // eslint-disable-next-line no-self-compare
      || x != x
      // eslint-disable-next-line no-self-compare
      || inLow != inLow
      // eslint-disable-next-line no-self-compare
      || inHigh != inHigh
      // eslint-disable-next-line no-self-compare
      || outLow != outLow
      // eslint-disable-next-line no-self-compare
      || outHigh != outHigh
  ) return NaN;
  if (x === Infinity || x === -Infinity) return x;
  return (x - inLow) * (outHigh - outLow) / (inHigh - inLow) + outLow;
};


/***/ }),
/* 133 */
/***/ (function(module, exports) {

// shim for using process in browser
var process = module.exports = {};

// cached from whatever global is present so that test runners that stub it
// don't break things.  But we need to wrap it in a try catch in case it is
// wrapped in strict mode code which doesn't define any globals.  It's inside a
// function because try/catches deoptimize in certain engines.

var cachedSetTimeout;
var cachedClearTimeout;

function defaultSetTimout() {
    throw new Error('setTimeout has not been defined');
}
function defaultClearTimeout () {
    throw new Error('clearTimeout has not been defined');
}
(function () {
    try {
        if (typeof setTimeout === 'function') {
            cachedSetTimeout = setTimeout;
        } else {
            cachedSetTimeout = defaultSetTimout;
        }
    } catch (e) {
        cachedSetTimeout = defaultSetTimout;
    }
    try {
        if (typeof clearTimeout === 'function') {
            cachedClearTimeout = clearTimeout;
        } else {
            cachedClearTimeout = defaultClearTimeout;
        }
    } catch (e) {
        cachedClearTimeout = defaultClearTimeout;
    }
} ())
function runTimeout(fun) {
    if (cachedSetTimeout === setTimeout) {
        //normal enviroments in sane situations
        return setTimeout(fun, 0);
    }
    // if setTimeout wasn't available but was latter defined
    if ((cachedSetTimeout === defaultSetTimout || !cachedSetTimeout) && setTimeout) {
        cachedSetTimeout = setTimeout;
        return setTimeout(fun, 0);
    }
    try {
        // when when somebody has screwed with setTimeout but no I.E. maddness
        return cachedSetTimeout(fun, 0);
    } catch(e){
        try {
            // When we are in I.E. but the script has been evaled so I.E. doesn't trust the global object when called normally
            return cachedSetTimeout.call(null, fun, 0);
        } catch(e){
            // same as above but when it's a version of I.E. that must have the global object for 'this', hopfully our context correct otherwise it will throw a global error
            return cachedSetTimeout.call(this, fun, 0);
        }
    }


}
function runClearTimeout(marker) {
    if (cachedClearTimeout === clearTimeout) {
        //normal enviroments in sane situations
        return clearTimeout(marker);
    }
    // if clearTimeout wasn't available but was latter defined
    if ((cachedClearTimeout === defaultClearTimeout || !cachedClearTimeout) && clearTimeout) {
        cachedClearTimeout = clearTimeout;
        return clearTimeout(marker);
    }
    try {
        // when when somebody has screwed with setTimeout but no I.E. maddness
        return cachedClearTimeout(marker);
    } catch (e){
        try {
            // When we are in I.E. but the script has been evaled so I.E. doesn't  trust the global object when called normally
            return cachedClearTimeout.call(null, marker);
        } catch (e){
            // same as above but when it's a version of I.E. that must have the global object for 'this', hopfully our context correct otherwise it will throw a global error.
            // Some versions of I.E. have different rules for clearTimeout vs setTimeout
            return cachedClearTimeout.call(this, marker);
        }
    }



}
var queue = [];
var draining = false;
var currentQueue;
var queueIndex = -1;

function cleanUpNextTick() {
    if (!draining || !currentQueue) {
        return;
    }
    draining = false;
    if (currentQueue.length) {
        queue = currentQueue.concat(queue);
    } else {
        queueIndex = -1;
    }
    if (queue.length) {
        drainQueue();
    }
}

function drainQueue() {
    if (draining) {
        return;
    }
    var timeout = runTimeout(cleanUpNextTick);
    draining = true;

    var len = queue.length;
    while(len) {
        currentQueue = queue;
        queue = [];
        while (++queueIndex < len) {
            if (currentQueue) {
                currentQueue[queueIndex].run();
            }
        }
        queueIndex = -1;
        len = queue.length;
    }
    currentQueue = null;
    draining = false;
    runClearTimeout(timeout);
}

process.nextTick = function (fun) {
    var args = new Array(arguments.length - 1);
    if (arguments.length > 1) {
        for (var i = 1; i < arguments.length; i++) {
            args[i - 1] = arguments[i];
        }
    }
    queue.push(new Item(fun, args));
    if (queue.length === 1 && !draining) {
        runTimeout(drainQueue);
    }
};

// v8 likes predictible objects
function Item(fun, array) {
    this.fun = fun;
    this.array = array;
}
Item.prototype.run = function () {
    this.fun.apply(null, this.array);
};
process.title = 'browser';
process.browser = true;
process.env = {};
process.argv = [];
process.version = ''; // empty string to avoid regexp issues
process.versions = {};

function noop() {}

process.on = noop;
process.addListener = noop;
process.once = noop;
process.off = noop;
process.removeListener = noop;
process.removeAllListeners = noop;
process.emit = noop;
process.prependListener = noop;
process.prependOnceListener = noop;

process.listeners = function (name) { return [] }

process.binding = function (name) {
    throw new Error('process.binding is not supported');
};

process.cwd = function () { return '/' };
process.chdir = function (dir) {
    throw new Error('process.chdir is not supported');
};
process.umask = function() { return 0; };


/***/ }),
/* 134 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;
exports.HandlebarsEnvironment = HandlebarsEnvironment;
// istanbul ignore next

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

var _utils = __webpack_require__(28);

var _exception = __webpack_require__(45);

var _exception2 = _interopRequireDefault(_exception);

var _helpers = __webpack_require__(135);

var _decorators = __webpack_require__(371);

var _logger = __webpack_require__(136);

var _logger2 = _interopRequireDefault(_logger);

var _internalProtoAccess = __webpack_require__(137);

var VERSION = '4.7.3';
exports.VERSION = VERSION;
var COMPILER_REVISION = 8;
exports.COMPILER_REVISION = COMPILER_REVISION;
var LAST_COMPATIBLE_COMPILER_REVISION = 7;

exports.LAST_COMPATIBLE_COMPILER_REVISION = LAST_COMPATIBLE_COMPILER_REVISION;
var REVISION_CHANGES = {
  1: '<= 1.0.rc.2', // 1.0.rc.2 is actually rev2 but doesn't report it
  2: '== 1.0.0-rc.3',
  3: '== 1.0.0-rc.4',
  4: '== 1.x.x',
  5: '== 2.0.0-alpha.x',
  6: '>= 2.0.0-beta.1',
  7: '>= 4.0.0 <4.3.0',
  8: '>= 4.3.0'
};

exports.REVISION_CHANGES = REVISION_CHANGES;
var objectType = '[object Object]';

function HandlebarsEnvironment(helpers, partials, decorators) {
  this.helpers = helpers || {};
  this.partials = partials || {};
  this.decorators = decorators || {};

  _helpers.registerDefaultHelpers(this);
  _decorators.registerDefaultDecorators(this);
}

HandlebarsEnvironment.prototype = {
  constructor: HandlebarsEnvironment,

  logger: _logger2['default'],
  log: _logger2['default'].log,

  registerHelper: function registerHelper(name, fn) {
    if (_utils.toString.call(name) === objectType) {
      if (fn) {
        throw new _exception2['default']('Arg not supported with multiple helpers');
      }
      _utils.extend(this.helpers, name);
    } else {
      this.helpers[name] = fn;
    }
  },
  unregisterHelper: function unregisterHelper(name) {
    delete this.helpers[name];
  },

  registerPartial: function registerPartial(name, partial) {
    if (_utils.toString.call(name) === objectType) {
      _utils.extend(this.partials, name);
    } else {
      if (typeof partial === 'undefined') {
        throw new _exception2['default']('Attempting to register a partial called "' + name + '" as undefined');
      }
      this.partials[name] = partial;
    }
  },
  unregisterPartial: function unregisterPartial(name) {
    delete this.partials[name];
  },

  registerDecorator: function registerDecorator(name, fn) {
    if (_utils.toString.call(name) === objectType) {
      if (fn) {
        throw new _exception2['default']('Arg not supported with multiple decorators');
      }
      _utils.extend(this.decorators, name);
    } else {
      this.decorators[name] = fn;
    }
  },
  unregisterDecorator: function unregisterDecorator(name) {
    delete this.decorators[name];
  },
  /**
   * Reset the memory of illegal property accesses that have already been logged.
   * @deprecated should only be used in handlebars test-cases
   */
  resetLoggedPropertyAccesses: function resetLoggedPropertyAccesses() {
    _internalProtoAccess.resetLoggedProperties();
  }
};

var log = _logger2['default'].log;

exports.log = log;
exports.createFrame = _utils.createFrame;
exports.logger = _logger2['default'];
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL2Jhc2UuanMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7cUJBQThDLFNBQVM7O3lCQUNqQyxhQUFhOzs7O3VCQUNJLFdBQVc7OzBCQUNSLGNBQWM7O3NCQUNyQyxVQUFVOzs7O21DQUNTLHlCQUF5Qjs7QUFFeEQsSUFBTSxPQUFPLEdBQUcsT0FBTyxDQUFDOztBQUN4QixJQUFNLGlCQUFpQixHQUFHLENBQUMsQ0FBQzs7QUFDNUIsSUFBTSxpQ0FBaUMsR0FBRyxDQUFDLENBQUM7OztBQUU1QyxJQUFNLGdCQUFnQixHQUFHO0FBQzlCLEdBQUMsRUFBRSxhQUFhO0FBQ2hCLEdBQUMsRUFBRSxlQUFlO0FBQ2xCLEdBQUMsRUFBRSxlQUFlO0FBQ2xCLEdBQUMsRUFBRSxVQUFVO0FBQ2IsR0FBQyxFQUFFLGtCQUFrQjtBQUNyQixHQUFDLEVBQUUsaUJBQWlCO0FBQ3BCLEdBQUMsRUFBRSxpQkFBaUI7QUFDcEIsR0FBQyxFQUFFLFVBQVU7Q0FDZCxDQUFDOzs7QUFFRixJQUFNLFVBQVUsR0FBRyxpQkFBaUIsQ0FBQzs7QUFFOUIsU0FBUyxxQkFBcUIsQ0FBQyxPQUFPLEVBQUUsUUFBUSxFQUFFLFVBQVUsRUFBRTtBQUNuRSxNQUFJLENBQUMsT0FBTyxHQUFHLE9BQU8sSUFBSSxFQUFFLENBQUM7QUFDN0IsTUFBSSxDQUFDLFFBQVEsR0FBRyxRQUFRLElBQUksRUFBRSxDQUFDO0FBQy9CLE1BQUksQ0FBQyxVQUFVLEdBQUcsVUFBVSxJQUFJLEVBQUUsQ0FBQzs7QUFFbkMsa0NBQXVCLElBQUksQ0FBQyxDQUFDO0FBQzdCLHdDQUEwQixJQUFJLENBQUMsQ0FBQztDQUNqQzs7QUFFRCxxQkFBcUIsQ0FBQyxTQUFTLEdBQUc7QUFDaEMsYUFBVyxFQUFFLHFCQUFxQjs7QUFFbEMsUUFBTSxxQkFBUTtBQUNkLEtBQUcsRUFBRSxvQkFBTyxHQUFHOztBQUVmLGdCQUFjLEVBQUUsd0JBQVMsSUFBSSxFQUFFLEVBQUUsRUFBRTtBQUNqQyxRQUFJLGdCQUFTLElBQUksQ0FBQyxJQUFJLENBQUMsS0FBSyxVQUFVLEVBQUU7QUFDdEMsVUFBSSxFQUFFLEVBQUU7QUFDTixjQUFNLDJCQUFjLHlDQUF5QyxDQUFDLENBQUM7T0FDaEU7QUFDRCxvQkFBTyxJQUFJLENBQUMsT0FBTyxFQUFFLElBQUksQ0FBQyxDQUFDO0tBQzVCLE1BQU07QUFDTCxVQUFJLENBQUMsT0FBTyxDQUFDLElBQUksQ0FBQyxHQUFHLEVBQUUsQ0FBQztLQUN6QjtHQUNGO0FBQ0Qsa0JBQWdCLEVBQUUsMEJBQVMsSUFBSSxFQUFFO0FBQy9CLFdBQU8sSUFBSSxDQUFDLE9BQU8sQ0FBQyxJQUFJLENBQUMsQ0FBQztHQUMzQjs7QUFFRCxpQkFBZSxFQUFFLHlCQUFTLElBQUksRUFBRSxPQUFPLEVBQUU7QUFDdkMsUUFBSSxnQkFBUyxJQUFJLENBQUMsSUFBSSxDQUFDLEtBQUssVUFBVSxFQUFFO0FBQ3RDLG9CQUFPLElBQUksQ0FBQyxRQUFRLEVBQUUsSUFBSSxDQUFDLENBQUM7S0FDN0IsTUFBTTtBQUNMLFVBQUksT0FBTyxPQUFPLEtBQUssV0FBVyxFQUFFO0FBQ2xDLGNBQU0seUVBQ3dDLElBQUksb0JBQ2pELENBQUM7T0FDSDtBQUNELFVBQUksQ0FBQyxRQUFRLENBQUMsSUFBSSxDQUFDLEdBQUcsT0FBTyxDQUFDO0tBQy9CO0dBQ0Y7QUFDRCxtQkFBaUIsRUFBRSwyQkFBUyxJQUFJLEVBQUU7QUFDaEMsV0FBTyxJQUFJLENBQUMsUUFBUSxDQUFDLElBQUksQ0FBQyxDQUFDO0dBQzVCOztBQUVELG1CQUFpQixFQUFFLDJCQUFTLElBQUksRUFBRSxFQUFFLEVBQUU7QUFDcEMsUUFBSSxnQkFBUyxJQUFJLENBQUMsSUFBSSxDQUFDLEtBQUssVUFBVSxFQUFFO0FBQ3RDLFVBQUksRUFBRSxFQUFFO0FBQ04sY0FBTSwyQkFBYyw0Q0FBNEMsQ0FBQyxDQUFDO09BQ25FO0FBQ0Qsb0JBQU8sSUFBSSxDQUFDLFVBQVUsRUFBRSxJQUFJLENBQUMsQ0FBQztLQUMvQixNQUFNO0FBQ0wsVUFBSSxDQUFDLFVBQVUsQ0FBQyxJQUFJLENBQUMsR0FBRyxFQUFFLENBQUM7S0FDNUI7R0FDRjtBQUNELHFCQUFtQixFQUFFLDZCQUFTLElBQUksRUFBRTtBQUNsQyxXQUFPLElBQUksQ0FBQyxVQUFVLENBQUMsSUFBSSxDQUFDLENBQUM7R0FDOUI7Ozs7O0FBS0QsNkJBQTJCLEVBQUEsdUNBQUc7QUFDNUIsZ0RBQXVCLENBQUM7R0FDekI7Q0FDRixDQUFDOztBQUVLLElBQUksR0FBRyxHQUFHLG9CQUFPLEdBQUcsQ0FBQzs7O1FBRW5CLFdBQVc7UUFBRSxNQUFNIiwiZmlsZSI6ImJhc2UuanMiLCJzb3VyY2VzQ29udGVudCI6WyJpbXBvcnQgeyBjcmVhdGVGcmFtZSwgZXh0ZW5kLCB0b1N0cmluZyB9IGZyb20gJy4vdXRpbHMnO1xuaW1wb3J0IEV4Y2VwdGlvbiBmcm9tICcuL2V4Y2VwdGlvbic7XG5pbXBvcnQgeyByZWdpc3RlckRlZmF1bHRIZWxwZXJzIH0gZnJvbSAnLi9oZWxwZXJzJztcbmltcG9ydCB7IHJlZ2lzdGVyRGVmYXVsdERlY29yYXRvcnMgfSBmcm9tICcuL2RlY29yYXRvcnMnO1xuaW1wb3J0IGxvZ2dlciBmcm9tICcuL2xvZ2dlcic7XG5pbXBvcnQgeyByZXNldExvZ2dlZFByb3BlcnRpZXMgfSBmcm9tICcuL2ludGVybmFsL3Byb3RvLWFjY2Vzcyc7XG5cbmV4cG9ydCBjb25zdCBWRVJTSU9OID0gJzQuNy4zJztcbmV4cG9ydCBjb25zdCBDT01QSUxFUl9SRVZJU0lPTiA9IDg7XG5leHBvcnQgY29uc3QgTEFTVF9DT01QQVRJQkxFX0NPTVBJTEVSX1JFVklTSU9OID0gNztcblxuZXhwb3J0IGNvbnN0IFJFVklTSU9OX0NIQU5HRVMgPSB7XG4gIDE6ICc8PSAxLjAucmMuMicsIC8vIDEuMC5yYy4yIGlzIGFjdHVhbGx5IHJldjIgYnV0IGRvZXNuJ3QgcmVwb3J0IGl0XG4gIDI6ICc9PSAxLjAuMC1yYy4zJyxcbiAgMzogJz09IDEuMC4wLXJjLjQnLFxuICA0OiAnPT0gMS54LngnLFxuICA1OiAnPT0gMi4wLjAtYWxwaGEueCcsXG4gIDY6ICc+PSAyLjAuMC1iZXRhLjEnLFxuICA3OiAnPj0gNC4wLjAgPDQuMy4wJyxcbiAgODogJz49IDQuMy4wJ1xufTtcblxuY29uc3Qgb2JqZWN0VHlwZSA9ICdbb2JqZWN0IE9iamVjdF0nO1xuXG5leHBvcnQgZnVuY3Rpb24gSGFuZGxlYmFyc0Vudmlyb25tZW50KGhlbHBlcnMsIHBhcnRpYWxzLCBkZWNvcmF0b3JzKSB7XG4gIHRoaXMuaGVscGVycyA9IGhlbHBlcnMgfHwge307XG4gIHRoaXMucGFydGlhbHMgPSBwYXJ0aWFscyB8fCB7fTtcbiAgdGhpcy5kZWNvcmF0b3JzID0gZGVjb3JhdG9ycyB8fCB7fTtcblxuICByZWdpc3RlckRlZmF1bHRIZWxwZXJzKHRoaXMpO1xuICByZWdpc3RlckRlZmF1bHREZWNvcmF0b3JzKHRoaXMpO1xufVxuXG5IYW5kbGViYXJzRW52aXJvbm1lbnQucHJvdG90eXBlID0ge1xuICBjb25zdHJ1Y3RvcjogSGFuZGxlYmFyc0Vudmlyb25tZW50LFxuXG4gIGxvZ2dlcjogbG9nZ2VyLFxuICBsb2c6IGxvZ2dlci5sb2csXG5cbiAgcmVnaXN0ZXJIZWxwZXI6IGZ1bmN0aW9uKG5hbWUsIGZuKSB7XG4gICAgaWYgKHRvU3RyaW5nLmNhbGwobmFtZSkgPT09IG9iamVjdFR5cGUpIHtcbiAgICAgIGlmIChmbikge1xuICAgICAgICB0aHJvdyBuZXcgRXhjZXB0aW9uKCdBcmcgbm90IHN1cHBvcnRlZCB3aXRoIG11bHRpcGxlIGhlbHBlcnMnKTtcbiAgICAgIH1cbiAgICAgIGV4dGVuZCh0aGlzLmhlbHBlcnMsIG5hbWUpO1xuICAgIH0gZWxzZSB7XG4gICAgICB0aGlzLmhlbHBlcnNbbmFtZV0gPSBmbjtcbiAgICB9XG4gIH0sXG4gIHVucmVnaXN0ZXJIZWxwZXI6IGZ1bmN0aW9uKG5hbWUpIHtcbiAgICBkZWxldGUgdGhpcy5oZWxwZXJzW25hbWVdO1xuICB9LFxuXG4gIHJlZ2lzdGVyUGFydGlhbDogZnVuY3Rpb24obmFtZSwgcGFydGlhbCkge1xuICAgIGlmICh0b1N0cmluZy5jYWxsKG5hbWUpID09PSBvYmplY3RUeXBlKSB7XG4gICAgICBleHRlbmQodGhpcy5wYXJ0aWFscywgbmFtZSk7XG4gICAgfSBlbHNlIHtcbiAgICAgIGlmICh0eXBlb2YgcGFydGlhbCA9PT0gJ3VuZGVmaW5lZCcpIHtcbiAgICAgICAgdGhyb3cgbmV3IEV4Y2VwdGlvbihcbiAgICAgICAgICBgQXR0ZW1wdGluZyB0byByZWdpc3RlciBhIHBhcnRpYWwgY2FsbGVkIFwiJHtuYW1lfVwiIGFzIHVuZGVmaW5lZGBcbiAgICAgICAgKTtcbiAgICAgIH1cbiAgICAgIHRoaXMucGFydGlhbHNbbmFtZV0gPSBwYXJ0aWFsO1xuICAgIH1cbiAgfSxcbiAgdW5yZWdpc3RlclBhcnRpYWw6IGZ1bmN0aW9uKG5hbWUpIHtcbiAgICBkZWxldGUgdGhpcy5wYXJ0aWFsc1tuYW1lXTtcbiAgfSxcblxuICByZWdpc3RlckRlY29yYXRvcjogZnVuY3Rpb24obmFtZSwgZm4pIHtcbiAgICBpZiAodG9TdHJpbmcuY2FsbChuYW1lKSA9PT0gb2JqZWN0VHlwZSkge1xuICAgICAgaWYgKGZuKSB7XG4gICAgICAgIHRocm93IG5ldyBFeGNlcHRpb24oJ0FyZyBub3Qgc3VwcG9ydGVkIHdpdGggbXVsdGlwbGUgZGVjb3JhdG9ycycpO1xuICAgICAgfVxuICAgICAgZXh0ZW5kKHRoaXMuZGVjb3JhdG9ycywgbmFtZSk7XG4gICAgfSBlbHNlIHtcbiAgICAgIHRoaXMuZGVjb3JhdG9yc1tuYW1lXSA9IGZuO1xuICAgIH1cbiAgfSxcbiAgdW5yZWdpc3RlckRlY29yYXRvcjogZnVuY3Rpb24obmFtZSkge1xuICAgIGRlbGV0ZSB0aGlzLmRlY29yYXRvcnNbbmFtZV07XG4gIH0sXG4gIC8qKlxuICAgKiBSZXNldCB0aGUgbWVtb3J5IG9mIGlsbGVnYWwgcHJvcGVydHkgYWNjZXNzZXMgdGhhdCBoYXZlIGFscmVhZHkgYmVlbiBsb2dnZWQuXG4gICAqIEBkZXByZWNhdGVkIHNob3VsZCBvbmx5IGJlIHVzZWQgaW4gaGFuZGxlYmFycyB0ZXN0LWNhc2VzXG4gICAqL1xuICByZXNldExvZ2dlZFByb3BlcnR5QWNjZXNzZXMoKSB7XG4gICAgcmVzZXRMb2dnZWRQcm9wZXJ0aWVzKCk7XG4gIH1cbn07XG5cbmV4cG9ydCBsZXQgbG9nID0gbG9nZ2VyLmxvZztcblxuZXhwb3J0IHsgY3JlYXRlRnJhbWUsIGxvZ2dlciB9O1xuIl19


/***/ }),
/* 135 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;
exports.registerDefaultHelpers = registerDefaultHelpers;
exports.moveHelperToHooks = moveHelperToHooks;
// istanbul ignore next

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

var _helpersBlockHelperMissing = __webpack_require__(364);

var _helpersBlockHelperMissing2 = _interopRequireDefault(_helpersBlockHelperMissing);

var _helpersEach = __webpack_require__(365);

var _helpersEach2 = _interopRequireDefault(_helpersEach);

var _helpersHelperMissing = __webpack_require__(366);

var _helpersHelperMissing2 = _interopRequireDefault(_helpersHelperMissing);

var _helpersIf = __webpack_require__(367);

var _helpersIf2 = _interopRequireDefault(_helpersIf);

var _helpersLog = __webpack_require__(368);

var _helpersLog2 = _interopRequireDefault(_helpersLog);

var _helpersLookup = __webpack_require__(369);

var _helpersLookup2 = _interopRequireDefault(_helpersLookup);

var _helpersWith = __webpack_require__(370);

var _helpersWith2 = _interopRequireDefault(_helpersWith);

function registerDefaultHelpers(instance) {
  _helpersBlockHelperMissing2['default'](instance);
  _helpersEach2['default'](instance);
  _helpersHelperMissing2['default'](instance);
  _helpersIf2['default'](instance);
  _helpersLog2['default'](instance);
  _helpersLookup2['default'](instance);
  _helpersWith2['default'](instance);
}

function moveHelperToHooks(instance, helperName, keepHelper) {
  if (instance.helpers[helperName]) {
    instance.hooks[helperName] = instance.helpers[helperName];
    if (!keepHelper) {
      delete instance.helpers[helperName];
    }
  }
}
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL2hlbHBlcnMuanMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7O3lDQUF1QyxnQ0FBZ0M7Ozs7MkJBQzlDLGdCQUFnQjs7OztvQ0FDUCwwQkFBMEI7Ozs7eUJBQ3JDLGNBQWM7Ozs7MEJBQ2IsZUFBZTs7Ozs2QkFDWixrQkFBa0I7Ozs7MkJBQ3BCLGdCQUFnQjs7OztBQUVsQyxTQUFTLHNCQUFzQixDQUFDLFFBQVEsRUFBRTtBQUMvQyx5Q0FBMkIsUUFBUSxDQUFDLENBQUM7QUFDckMsMkJBQWEsUUFBUSxDQUFDLENBQUM7QUFDdkIsb0NBQXNCLFFBQVEsQ0FBQyxDQUFDO0FBQ2hDLHlCQUFXLFFBQVEsQ0FBQyxDQUFDO0FBQ3JCLDBCQUFZLFFBQVEsQ0FBQyxDQUFDO0FBQ3RCLDZCQUFlLFFBQVEsQ0FBQyxDQUFDO0FBQ3pCLDJCQUFhLFFBQVEsQ0FBQyxDQUFDO0NBQ3hCOztBQUVNLFNBQVMsaUJBQWlCLENBQUMsUUFBUSxFQUFFLFVBQVUsRUFBRSxVQUFVLEVBQUU7QUFDbEUsTUFBSSxRQUFRLENBQUMsT0FBTyxDQUFDLFVBQVUsQ0FBQyxFQUFFO0FBQ2hDLFlBQVEsQ0FBQyxLQUFLLENBQUMsVUFBVSxDQUFDLEdBQUcsUUFBUSxDQUFDLE9BQU8sQ0FBQyxVQUFVLENBQUMsQ0FBQztBQUMxRCxRQUFJLENBQUMsVUFBVSxFQUFFO0FBQ2YsYUFBTyxRQUFRLENBQUMsT0FBTyxDQUFDLFVBQVUsQ0FBQyxDQUFDO0tBQ3JDO0dBQ0Y7Q0FDRiIsImZpbGUiOiJoZWxwZXJzLmpzIiwic291cmNlc0NvbnRlbnQiOlsiaW1wb3J0IHJlZ2lzdGVyQmxvY2tIZWxwZXJNaXNzaW5nIGZyb20gJy4vaGVscGVycy9ibG9jay1oZWxwZXItbWlzc2luZyc7XG5pbXBvcnQgcmVnaXN0ZXJFYWNoIGZyb20gJy4vaGVscGVycy9lYWNoJztcbmltcG9ydCByZWdpc3RlckhlbHBlck1pc3NpbmcgZnJvbSAnLi9oZWxwZXJzL2hlbHBlci1taXNzaW5nJztcbmltcG9ydCByZWdpc3RlcklmIGZyb20gJy4vaGVscGVycy9pZic7XG5pbXBvcnQgcmVnaXN0ZXJMb2cgZnJvbSAnLi9oZWxwZXJzL2xvZyc7XG5pbXBvcnQgcmVnaXN0ZXJMb29rdXAgZnJvbSAnLi9oZWxwZXJzL2xvb2t1cCc7XG5pbXBvcnQgcmVnaXN0ZXJXaXRoIGZyb20gJy4vaGVscGVycy93aXRoJztcblxuZXhwb3J0IGZ1bmN0aW9uIHJlZ2lzdGVyRGVmYXVsdEhlbHBlcnMoaW5zdGFuY2UpIHtcbiAgcmVnaXN0ZXJCbG9ja0hlbHBlck1pc3NpbmcoaW5zdGFuY2UpO1xuICByZWdpc3RlckVhY2goaW5zdGFuY2UpO1xuICByZWdpc3RlckhlbHBlck1pc3NpbmcoaW5zdGFuY2UpO1xuICByZWdpc3RlcklmKGluc3RhbmNlKTtcbiAgcmVnaXN0ZXJMb2coaW5zdGFuY2UpO1xuICByZWdpc3Rlckxvb2t1cChpbnN0YW5jZSk7XG4gIHJlZ2lzdGVyV2l0aChpbnN0YW5jZSk7XG59XG5cbmV4cG9ydCBmdW5jdGlvbiBtb3ZlSGVscGVyVG9Ib29rcyhpbnN0YW5jZSwgaGVscGVyTmFtZSwga2VlcEhlbHBlcikge1xuICBpZiAoaW5zdGFuY2UuaGVscGVyc1toZWxwZXJOYW1lXSkge1xuICAgIGluc3RhbmNlLmhvb2tzW2hlbHBlck5hbWVdID0gaW5zdGFuY2UuaGVscGVyc1toZWxwZXJOYW1lXTtcbiAgICBpZiAoIWtlZXBIZWxwZXIpIHtcbiAgICAgIGRlbGV0ZSBpbnN0YW5jZS5oZWxwZXJzW2hlbHBlck5hbWVdO1xuICAgIH1cbiAgfVxufVxuIl19


/***/ }),
/* 136 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;

var _utils = __webpack_require__(28);

var logger = {
  methodMap: ['debug', 'info', 'warn', 'error'],
  level: 'info',

  // Maps a given level value to the `methodMap` indexes above.
  lookupLevel: function lookupLevel(level) {
    if (typeof level === 'string') {
      var levelMap = _utils.indexOf(logger.methodMap, level.toLowerCase());
      if (levelMap >= 0) {
        level = levelMap;
      } else {
        level = parseInt(level, 10);
      }
    }

    return level;
  },

  // Can be overridden in the host environment
  log: function log(level) {
    level = logger.lookupLevel(level);

    if (typeof console !== 'undefined' && logger.lookupLevel(logger.level) <= level) {
      var method = logger.methodMap[level];
      // eslint-disable-next-line no-console
      if (!console[method]) {
        method = 'log';
      }

      for (var _len = arguments.length, message = Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
        message[_key - 1] = arguments[_key];
      }

      console[method].apply(console, message); // eslint-disable-line no-console
    }
  }
};

exports['default'] = logger;
module.exports = exports['default'];
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL2xvZ2dlci5qcyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOzs7O3FCQUF3QixTQUFTOztBQUVqQyxJQUFJLE1BQU0sR0FBRztBQUNYLFdBQVMsRUFBRSxDQUFDLE9BQU8sRUFBRSxNQUFNLEVBQUUsTUFBTSxFQUFFLE9BQU8sQ0FBQztBQUM3QyxPQUFLLEVBQUUsTUFBTTs7O0FBR2IsYUFBVyxFQUFFLHFCQUFTLEtBQUssRUFBRTtBQUMzQixRQUFJLE9BQU8sS0FBSyxLQUFLLFFBQVEsRUFBRTtBQUM3QixVQUFJLFFBQVEsR0FBRyxlQUFRLE1BQU0sQ0FBQyxTQUFTLEVBQUUsS0FBSyxDQUFDLFdBQVcsRUFBRSxDQUFDLENBQUM7QUFDOUQsVUFBSSxRQUFRLElBQUksQ0FBQyxFQUFFO0FBQ2pCLGFBQUssR0FBRyxRQUFRLENBQUM7T0FDbEIsTUFBTTtBQUNMLGFBQUssR0FBRyxRQUFRLENBQUMsS0FBSyxFQUFFLEVBQUUsQ0FBQyxDQUFDO09BQzdCO0tBQ0Y7O0FBRUQsV0FBTyxLQUFLLENBQUM7R0FDZDs7O0FBR0QsS0FBRyxFQUFFLGFBQVMsS0FBSyxFQUFjO0FBQy9CLFNBQUssR0FBRyxNQUFNLENBQUMsV0FBVyxDQUFDLEtBQUssQ0FBQyxDQUFDOztBQUVsQyxRQUNFLE9BQU8sT0FBTyxLQUFLLFdBQVcsSUFDOUIsTUFBTSxDQUFDLFdBQVcsQ0FBQyxNQUFNLENBQUMsS0FBSyxDQUFDLElBQUksS0FBSyxFQUN6QztBQUNBLFVBQUksTUFBTSxHQUFHLE1BQU0sQ0FBQyxTQUFTLENBQUMsS0FBSyxDQUFDLENBQUM7O0FBRXJDLFVBQUksQ0FBQyxPQUFPLENBQUMsTUFBTSxDQUFDLEVBQUU7QUFDcEIsY0FBTSxHQUFHLEtBQUssQ0FBQztPQUNoQjs7d0NBWG1CLE9BQU87QUFBUCxlQUFPOzs7QUFZM0IsYUFBTyxDQUFDLE1BQU0sT0FBQyxDQUFmLE9BQU8sRUFBWSxPQUFPLENBQUMsQ0FBQztLQUM3QjtHQUNGO0NBQ0YsQ0FBQzs7cUJBRWEsTUFBTSIsImZpbGUiOiJsb2dnZXIuanMiLCJzb3VyY2VzQ29udGVudCI6WyJpbXBvcnQgeyBpbmRleE9mIH0gZnJvbSAnLi91dGlscyc7XG5cbmxldCBsb2dnZXIgPSB7XG4gIG1ldGhvZE1hcDogWydkZWJ1ZycsICdpbmZvJywgJ3dhcm4nLCAnZXJyb3InXSxcbiAgbGV2ZWw6ICdpbmZvJyxcblxuICAvLyBNYXBzIGEgZ2l2ZW4gbGV2ZWwgdmFsdWUgdG8gdGhlIGBtZXRob2RNYXBgIGluZGV4ZXMgYWJvdmUuXG4gIGxvb2t1cExldmVsOiBmdW5jdGlvbihsZXZlbCkge1xuICAgIGlmICh0eXBlb2YgbGV2ZWwgPT09ICdzdHJpbmcnKSB7XG4gICAgICBsZXQgbGV2ZWxNYXAgPSBpbmRleE9mKGxvZ2dlci5tZXRob2RNYXAsIGxldmVsLnRvTG93ZXJDYXNlKCkpO1xuICAgICAgaWYgKGxldmVsTWFwID49IDApIHtcbiAgICAgICAgbGV2ZWwgPSBsZXZlbE1hcDtcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIGxldmVsID0gcGFyc2VJbnQobGV2ZWwsIDEwKTtcbiAgICAgIH1cbiAgICB9XG5cbiAgICByZXR1cm4gbGV2ZWw7XG4gIH0sXG5cbiAgLy8gQ2FuIGJlIG92ZXJyaWRkZW4gaW4gdGhlIGhvc3QgZW52aXJvbm1lbnRcbiAgbG9nOiBmdW5jdGlvbihsZXZlbCwgLi4ubWVzc2FnZSkge1xuICAgIGxldmVsID0gbG9nZ2VyLmxvb2t1cExldmVsKGxldmVsKTtcblxuICAgIGlmIChcbiAgICAgIHR5cGVvZiBjb25zb2xlICE9PSAndW5kZWZpbmVkJyAmJlxuICAgICAgbG9nZ2VyLmxvb2t1cExldmVsKGxvZ2dlci5sZXZlbCkgPD0gbGV2ZWxcbiAgICApIHtcbiAgICAgIGxldCBtZXRob2QgPSBsb2dnZXIubWV0aG9kTWFwW2xldmVsXTtcbiAgICAgIC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBuby1jb25zb2xlXG4gICAgICBpZiAoIWNvbnNvbGVbbWV0aG9kXSkge1xuICAgICAgICBtZXRob2QgPSAnbG9nJztcbiAgICAgIH1cbiAgICAgIGNvbnNvbGVbbWV0aG9kXSguLi5tZXNzYWdlKTsgLy8gZXNsaW50LWRpc2FibGUtbGluZSBuby1jb25zb2xlXG4gICAgfVxuICB9XG59O1xuXG5leHBvcnQgZGVmYXVsdCBsb2dnZXI7XG4iXX0=


/***/ }),
/* 137 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;
exports.createProtoAccessControl = createProtoAccessControl;
exports.resultIsAllowed = resultIsAllowed;
exports.resetLoggedProperties = resetLoggedProperties;
// istanbul ignore next

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } else { var newObj = {}; if (obj != null) { for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) newObj[key] = obj[key]; } } newObj['default'] = obj; return newObj; } }

var _createNewLookupObject = __webpack_require__(373);

var _logger = __webpack_require__(136);

var logger = _interopRequireWildcard(_logger);

var loggedProperties = Object.create(null);

function createProtoAccessControl(runtimeOptions) {
  var defaultMethodWhiteList = Object.create(null);
  defaultMethodWhiteList['constructor'] = false;
  defaultMethodWhiteList['__defineGetter__'] = false;
  defaultMethodWhiteList['__defineSetter__'] = false;
  defaultMethodWhiteList['__lookupGetter__'] = false;

  var defaultPropertyWhiteList = Object.create(null);
  // eslint-disable-next-line no-proto
  defaultPropertyWhiteList['__proto__'] = false;

  return {
    properties: {
      whitelist: _createNewLookupObject.createNewLookupObject(defaultPropertyWhiteList, runtimeOptions.allowedProtoProperties),
      defaultValue: runtimeOptions.allowProtoPropertiesByDefault
    },
    methods: {
      whitelist: _createNewLookupObject.createNewLookupObject(defaultMethodWhiteList, runtimeOptions.allowedProtoMethods),
      defaultValue: runtimeOptions.allowProtoMethodsByDefault
    }
  };
}

function resultIsAllowed(result, protoAccessControl, propertyName) {
  if (typeof result === 'function') {
    return checkWhiteList(protoAccessControl.methods, propertyName);
  } else {
    return checkWhiteList(protoAccessControl.properties, propertyName);
  }
}

function checkWhiteList(protoAccessControlForType, propertyName) {
  if (protoAccessControlForType.whitelist[propertyName] !== undefined) {
    return protoAccessControlForType.whitelist[propertyName] === true;
  }
  if (protoAccessControlForType.defaultValue !== undefined) {
    return protoAccessControlForType.defaultValue;
  }
  logUnexpecedPropertyAccessOnce(propertyName);
  return false;
}

function logUnexpecedPropertyAccessOnce(propertyName) {
  if (loggedProperties[propertyName] !== true) {
    loggedProperties[propertyName] = true;
    logger.log('error', 'Handlebars: Access has been denied to resolve the property "' + propertyName + '" because it is not an "own property" of its parent.\n' + 'You can add a runtime option to disable the check or this warning:\n' + 'See https://handlebarsjs.com/api-reference/runtime-options.html#options-to-control-prototype-access for details');
  }
}

function resetLoggedProperties() {
  Object.keys(loggedProperties).forEach(function (propertyName) {
    delete loggedProperties[propertyName];
  });
}
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL2ludGVybmFsL3Byb3RvLWFjY2Vzcy5qcyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7O3FDQUFzQyw0QkFBNEI7O3NCQUMxQyxXQUFXOztJQUF2QixNQUFNOztBQUVsQixJQUFNLGdCQUFnQixHQUFHLE1BQU0sQ0FBQyxNQUFNLENBQUMsSUFBSSxDQUFDLENBQUM7O0FBRXRDLFNBQVMsd0JBQXdCLENBQUMsY0FBYyxFQUFFO0FBQ3ZELE1BQUksc0JBQXNCLEdBQUcsTUFBTSxDQUFDLE1BQU0sQ0FBQyxJQUFJLENBQUMsQ0FBQztBQUNqRCx3QkFBc0IsQ0FBQyxhQUFhLENBQUMsR0FBRyxLQUFLLENBQUM7QUFDOUMsd0JBQXNCLENBQUMsa0JBQWtCLENBQUMsR0FBRyxLQUFLLENBQUM7QUFDbkQsd0JBQXNCLENBQUMsa0JBQWtCLENBQUMsR0FBRyxLQUFLLENBQUM7QUFDbkQsd0JBQXNCLENBQUMsa0JBQWtCLENBQUMsR0FBRyxLQUFLLENBQUM7O0FBRW5ELE1BQUksd0JBQXdCLEdBQUcsTUFBTSxDQUFDLE1BQU0sQ0FBQyxJQUFJLENBQUMsQ0FBQzs7QUFFbkQsMEJBQXdCLENBQUMsV0FBVyxDQUFDLEdBQUcsS0FBSyxDQUFDOztBQUU5QyxTQUFPO0FBQ0wsY0FBVSxFQUFFO0FBQ1YsZUFBUyxFQUFFLDZDQUNULHdCQUF3QixFQUN4QixjQUFjLENBQUMsc0JBQXNCLENBQ3RDO0FBQ0Qsa0JBQVksRUFBRSxjQUFjLENBQUMsNkJBQTZCO0tBQzNEO0FBQ0QsV0FBTyxFQUFFO0FBQ1AsZUFBUyxFQUFFLDZDQUNULHNCQUFzQixFQUN0QixjQUFjLENBQUMsbUJBQW1CLENBQ25DO0FBQ0Qsa0JBQVksRUFBRSxjQUFjLENBQUMsMEJBQTBCO0tBQ3hEO0dBQ0YsQ0FBQztDQUNIOztBQUVNLFNBQVMsZUFBZSxDQUFDLE1BQU0sRUFBRSxrQkFBa0IsRUFBRSxZQUFZLEVBQUU7QUFDeEUsTUFBSSxPQUFPLE1BQU0sS0FBSyxVQUFVLEVBQUU7QUFDaEMsV0FBTyxjQUFjLENBQUMsa0JBQWtCLENBQUMsT0FBTyxFQUFFLFlBQVksQ0FBQyxDQUFDO0dBQ2pFLE1BQU07QUFDTCxXQUFPLGNBQWMsQ0FBQyxrQkFBa0IsQ0FBQyxVQUFVLEVBQUUsWUFBWSxDQUFDLENBQUM7R0FDcEU7Q0FDRjs7QUFFRCxTQUFTLGNBQWMsQ0FBQyx5QkFBeUIsRUFBRSxZQUFZLEVBQUU7QUFDL0QsTUFBSSx5QkFBeUIsQ0FBQyxTQUFTLENBQUMsWUFBWSxDQUFDLEtBQUssU0FBUyxFQUFFO0FBQ25FLFdBQU8seUJBQXlCLENBQUMsU0FBUyxDQUFDLFlBQVksQ0FBQyxLQUFLLElBQUksQ0FBQztHQUNuRTtBQUNELE1BQUkseUJBQXlCLENBQUMsWUFBWSxLQUFLLFNBQVMsRUFBRTtBQUN4RCxXQUFPLHlCQUF5QixDQUFDLFlBQVksQ0FBQztHQUMvQztBQUNELGdDQUE4QixDQUFDLFlBQVksQ0FBQyxDQUFDO0FBQzdDLFNBQU8sS0FBSyxDQUFDO0NBQ2Q7O0FBRUQsU0FBUyw4QkFBOEIsQ0FBQyxZQUFZLEVBQUU7QUFDcEQsTUFBSSxnQkFBZ0IsQ0FBQyxZQUFZLENBQUMsS0FBSyxJQUFJLEVBQUU7QUFDM0Msb0JBQWdCLENBQUMsWUFBWSxDQUFDLEdBQUcsSUFBSSxDQUFDO0FBQ3RDLFVBQU0sQ0FBQyxHQUFHLENBQ1IsT0FBTyxFQUNQLGlFQUErRCxZQUFZLG9JQUNILG9IQUMyQyxDQUNwSCxDQUFDO0dBQ0g7Q0FDRjs7QUFFTSxTQUFTLHFCQUFxQixHQUFHO0FBQ3RDLFFBQU0sQ0FBQyxJQUFJLENBQUMsZ0JBQWdCLENBQUMsQ0FBQyxPQUFPLENBQUMsVUFBQSxZQUFZLEVBQUk7QUFDcEQsV0FBTyxnQkFBZ0IsQ0FBQyxZQUFZLENBQUMsQ0FBQztHQUN2QyxDQUFDLENBQUM7Q0FDSiIsImZpbGUiOiJwcm90by1hY2Nlc3MuanMiLCJzb3VyY2VzQ29udGVudCI6WyJpbXBvcnQgeyBjcmVhdGVOZXdMb29rdXBPYmplY3QgfSBmcm9tICcuL2NyZWF0ZS1uZXctbG9va3VwLW9iamVjdCc7XG5pbXBvcnQgKiBhcyBsb2dnZXIgZnJvbSAnLi4vbG9nZ2VyJztcblxuY29uc3QgbG9nZ2VkUHJvcGVydGllcyA9IE9iamVjdC5jcmVhdGUobnVsbCk7XG5cbmV4cG9ydCBmdW5jdGlvbiBjcmVhdGVQcm90b0FjY2Vzc0NvbnRyb2wocnVudGltZU9wdGlvbnMpIHtcbiAgbGV0IGRlZmF1bHRNZXRob2RXaGl0ZUxpc3QgPSBPYmplY3QuY3JlYXRlKG51bGwpO1xuICBkZWZhdWx0TWV0aG9kV2hpdGVMaXN0Wydjb25zdHJ1Y3RvciddID0gZmFsc2U7XG4gIGRlZmF1bHRNZXRob2RXaGl0ZUxpc3RbJ19fZGVmaW5lR2V0dGVyX18nXSA9IGZhbHNlO1xuICBkZWZhdWx0TWV0aG9kV2hpdGVMaXN0WydfX2RlZmluZVNldHRlcl9fJ10gPSBmYWxzZTtcbiAgZGVmYXVsdE1ldGhvZFdoaXRlTGlzdFsnX19sb29rdXBHZXR0ZXJfXyddID0gZmFsc2U7XG5cbiAgbGV0IGRlZmF1bHRQcm9wZXJ0eVdoaXRlTGlzdCA9IE9iamVjdC5jcmVhdGUobnVsbCk7XG4gIC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBuby1wcm90b1xuICBkZWZhdWx0UHJvcGVydHlXaGl0ZUxpc3RbJ19fcHJvdG9fXyddID0gZmFsc2U7XG5cbiAgcmV0dXJuIHtcbiAgICBwcm9wZXJ0aWVzOiB7XG4gICAgICB3aGl0ZWxpc3Q6IGNyZWF0ZU5ld0xvb2t1cE9iamVjdChcbiAgICAgICAgZGVmYXVsdFByb3BlcnR5V2hpdGVMaXN0LFxuICAgICAgICBydW50aW1lT3B0aW9ucy5hbGxvd2VkUHJvdG9Qcm9wZXJ0aWVzXG4gICAgICApLFxuICAgICAgZGVmYXVsdFZhbHVlOiBydW50aW1lT3B0aW9ucy5hbGxvd1Byb3RvUHJvcGVydGllc0J5RGVmYXVsdFxuICAgIH0sXG4gICAgbWV0aG9kczoge1xuICAgICAgd2hpdGVsaXN0OiBjcmVhdGVOZXdMb29rdXBPYmplY3QoXG4gICAgICAgIGRlZmF1bHRNZXRob2RXaGl0ZUxpc3QsXG4gICAgICAgIHJ1bnRpbWVPcHRpb25zLmFsbG93ZWRQcm90b01ldGhvZHNcbiAgICAgICksXG4gICAgICBkZWZhdWx0VmFsdWU6IHJ1bnRpbWVPcHRpb25zLmFsbG93UHJvdG9NZXRob2RzQnlEZWZhdWx0XG4gICAgfVxuICB9O1xufVxuXG5leHBvcnQgZnVuY3Rpb24gcmVzdWx0SXNBbGxvd2VkKHJlc3VsdCwgcHJvdG9BY2Nlc3NDb250cm9sLCBwcm9wZXJ0eU5hbWUpIHtcbiAgaWYgKHR5cGVvZiByZXN1bHQgPT09ICdmdW5jdGlvbicpIHtcbiAgICByZXR1cm4gY2hlY2tXaGl0ZUxpc3QocHJvdG9BY2Nlc3NDb250cm9sLm1ldGhvZHMsIHByb3BlcnR5TmFtZSk7XG4gIH0gZWxzZSB7XG4gICAgcmV0dXJuIGNoZWNrV2hpdGVMaXN0KHByb3RvQWNjZXNzQ29udHJvbC5wcm9wZXJ0aWVzLCBwcm9wZXJ0eU5hbWUpO1xuICB9XG59XG5cbmZ1bmN0aW9uIGNoZWNrV2hpdGVMaXN0KHByb3RvQWNjZXNzQ29udHJvbEZvclR5cGUsIHByb3BlcnR5TmFtZSkge1xuICBpZiAocHJvdG9BY2Nlc3NDb250cm9sRm9yVHlwZS53aGl0ZWxpc3RbcHJvcGVydHlOYW1lXSAhPT0gdW5kZWZpbmVkKSB7XG4gICAgcmV0dXJuIHByb3RvQWNjZXNzQ29udHJvbEZvclR5cGUud2hpdGVsaXN0W3Byb3BlcnR5TmFtZV0gPT09IHRydWU7XG4gIH1cbiAgaWYgKHByb3RvQWNjZXNzQ29udHJvbEZvclR5cGUuZGVmYXVsdFZhbHVlICE9PSB1bmRlZmluZWQpIHtcbiAgICByZXR1cm4gcHJvdG9BY2Nlc3NDb250cm9sRm9yVHlwZS5kZWZhdWx0VmFsdWU7XG4gIH1cbiAgbG9nVW5leHBlY2VkUHJvcGVydHlBY2Nlc3NPbmNlKHByb3BlcnR5TmFtZSk7XG4gIHJldHVybiBmYWxzZTtcbn1cblxuZnVuY3Rpb24gbG9nVW5leHBlY2VkUHJvcGVydHlBY2Nlc3NPbmNlKHByb3BlcnR5TmFtZSkge1xuICBpZiAobG9nZ2VkUHJvcGVydGllc1twcm9wZXJ0eU5hbWVdICE9PSB0cnVlKSB7XG4gICAgbG9nZ2VkUHJvcGVydGllc1twcm9wZXJ0eU5hbWVdID0gdHJ1ZTtcbiAgICBsb2dnZXIubG9nKFxuICAgICAgJ2Vycm9yJyxcbiAgICAgIGBIYW5kbGViYXJzOiBBY2Nlc3MgaGFzIGJlZW4gZGVuaWVkIHRvIHJlc29sdmUgdGhlIHByb3BlcnR5IFwiJHtwcm9wZXJ0eU5hbWV9XCIgYmVjYXVzZSBpdCBpcyBub3QgYW4gXCJvd24gcHJvcGVydHlcIiBvZiBpdHMgcGFyZW50LlxcbmAgK1xuICAgICAgICBgWW91IGNhbiBhZGQgYSBydW50aW1lIG9wdGlvbiB0byBkaXNhYmxlIHRoZSBjaGVjayBvciB0aGlzIHdhcm5pbmc6XFxuYCArXG4gICAgICAgIGBTZWUgaHR0cHM6Ly9oYW5kbGViYXJzanMuY29tL2FwaS1yZWZlcmVuY2UvcnVudGltZS1vcHRpb25zLmh0bWwjb3B0aW9ucy10by1jb250cm9sLXByb3RvdHlwZS1hY2Nlc3MgZm9yIGRldGFpbHNgXG4gICAgKTtcbiAgfVxufVxuXG5leHBvcnQgZnVuY3Rpb24gcmVzZXRMb2dnZWRQcm9wZXJ0aWVzKCkge1xuICBPYmplY3Qua2V5cyhsb2dnZWRQcm9wZXJ0aWVzKS5mb3JFYWNoKHByb3BlcnR5TmFtZSA9PiB7XG4gICAgZGVsZXRlIGxvZ2dlZFByb3BlcnRpZXNbcHJvcGVydHlOYW1lXTtcbiAgfSk7XG59XG4iXX0=


/***/ }),
/* 138 */
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(139);
module.exports = __webpack_require__(341);


/***/ }),
/* 139 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/* WEBPACK VAR INJECTION */(function(global) {

__webpack_require__(140);

__webpack_require__(337);

__webpack_require__(338);

if (global._babelPolyfill) {
  throw new Error("only one instance of babel-polyfill is allowed");
}
global._babelPolyfill = true;

var DEFINE_PROPERTY = "defineProperty";
function define(O, key, value) {
  O[key] || Object[DEFINE_PROPERTY](O, key, {
    writable: true,
    configurable: true,
    value: value
  });
}

define(String.prototype, "padLeft", "".padStart);
define(String.prototype, "padRight", "".padEnd);

"pop,reverse,shift,keys,values,entries,indexOf,every,some,forEach,map,filter,find,findIndex,includes,join,slice,concat,push,splice,unshift,sort,lastIndexOf,reduce,reduceRight,copyWithin,fill".split(",").forEach(function (key) {
  [][key] && define(Array, key, Function.call.bind([][key]));
});
/* WEBPACK VAR INJECTION */}.call(this, __webpack_require__(55)))

/***/ }),
/* 140 */
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(141);
__webpack_require__(144);
__webpack_require__(145);
__webpack_require__(146);
__webpack_require__(147);
__webpack_require__(148);
__webpack_require__(149);
__webpack_require__(150);
__webpack_require__(151);
__webpack_require__(152);
__webpack_require__(153);
__webpack_require__(154);
__webpack_require__(155);
__webpack_require__(156);
__webpack_require__(157);
__webpack_require__(158);
__webpack_require__(159);
__webpack_require__(160);
__webpack_require__(161);
__webpack_require__(162);
__webpack_require__(163);
__webpack_require__(164);
__webpack_require__(165);
__webpack_require__(166);
__webpack_require__(167);
__webpack_require__(168);
__webpack_require__(169);
__webpack_require__(170);
__webpack_require__(171);
__webpack_require__(172);
__webpack_require__(173);
__webpack_require__(174);
__webpack_require__(175);
__webpack_require__(176);
__webpack_require__(177);
__webpack_require__(178);
__webpack_require__(179);
__webpack_require__(180);
__webpack_require__(181);
__webpack_require__(182);
__webpack_require__(183);
__webpack_require__(184);
__webpack_require__(185);
__webpack_require__(186);
__webpack_require__(187);
__webpack_require__(188);
__webpack_require__(189);
__webpack_require__(190);
__webpack_require__(191);
__webpack_require__(192);
__webpack_require__(193);
__webpack_require__(194);
__webpack_require__(195);
__webpack_require__(196);
__webpack_require__(197);
__webpack_require__(198);
__webpack_require__(199);
__webpack_require__(200);
__webpack_require__(201);
__webpack_require__(202);
__webpack_require__(203);
__webpack_require__(204);
__webpack_require__(205);
__webpack_require__(206);
__webpack_require__(207);
__webpack_require__(208);
__webpack_require__(209);
__webpack_require__(210);
__webpack_require__(211);
__webpack_require__(212);
__webpack_require__(213);
__webpack_require__(214);
__webpack_require__(215);
__webpack_require__(216);
__webpack_require__(217);
__webpack_require__(218);
__webpack_require__(219);
__webpack_require__(221);
__webpack_require__(222);
__webpack_require__(224);
__webpack_require__(225);
__webpack_require__(226);
__webpack_require__(227);
__webpack_require__(228);
__webpack_require__(229);
__webpack_require__(230);
__webpack_require__(232);
__webpack_require__(233);
__webpack_require__(234);
__webpack_require__(235);
__webpack_require__(236);
__webpack_require__(237);
__webpack_require__(238);
__webpack_require__(239);
__webpack_require__(240);
__webpack_require__(241);
__webpack_require__(242);
__webpack_require__(243);
__webpack_require__(244);
__webpack_require__(90);
__webpack_require__(245);
__webpack_require__(116);
__webpack_require__(246);
__webpack_require__(117);
__webpack_require__(247);
__webpack_require__(248);
__webpack_require__(249);
__webpack_require__(250);
__webpack_require__(251);
__webpack_require__(120);
__webpack_require__(122);
__webpack_require__(123);
__webpack_require__(252);
__webpack_require__(253);
__webpack_require__(254);
__webpack_require__(255);
__webpack_require__(256);
__webpack_require__(257);
__webpack_require__(258);
__webpack_require__(259);
__webpack_require__(260);
__webpack_require__(261);
__webpack_require__(262);
__webpack_require__(263);
__webpack_require__(264);
__webpack_require__(265);
__webpack_require__(266);
__webpack_require__(267);
__webpack_require__(268);
__webpack_require__(269);
__webpack_require__(270);
__webpack_require__(271);
__webpack_require__(272);
__webpack_require__(273);
__webpack_require__(274);
__webpack_require__(275);
__webpack_require__(276);
__webpack_require__(277);
__webpack_require__(278);
__webpack_require__(279);
__webpack_require__(280);
__webpack_require__(281);
__webpack_require__(282);
__webpack_require__(283);
__webpack_require__(284);
__webpack_require__(285);
__webpack_require__(286);
__webpack_require__(287);
__webpack_require__(288);
__webpack_require__(289);
__webpack_require__(290);
__webpack_require__(291);
__webpack_require__(292);
__webpack_require__(293);
__webpack_require__(294);
__webpack_require__(295);
__webpack_require__(296);
__webpack_require__(297);
__webpack_require__(298);
__webpack_require__(299);
__webpack_require__(300);
__webpack_require__(301);
__webpack_require__(302);
__webpack_require__(303);
__webpack_require__(304);
__webpack_require__(305);
__webpack_require__(306);
__webpack_require__(307);
__webpack_require__(308);
__webpack_require__(309);
__webpack_require__(310);
__webpack_require__(311);
__webpack_require__(312);
__webpack_require__(313);
__webpack_require__(314);
__webpack_require__(315);
__webpack_require__(316);
__webpack_require__(317);
__webpack_require__(318);
__webpack_require__(319);
__webpack_require__(320);
__webpack_require__(321);
__webpack_require__(322);
__webpack_require__(323);
__webpack_require__(324);
__webpack_require__(325);
__webpack_require__(326);
__webpack_require__(327);
__webpack_require__(328);
__webpack_require__(329);
__webpack_require__(330);
__webpack_require__(331);
__webpack_require__(332);
__webpack_require__(333);
__webpack_require__(334);
__webpack_require__(335);
__webpack_require__(336);
module.exports = __webpack_require__(19);


/***/ }),
/* 141 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// ECMAScript 6 symbols shim
var global = __webpack_require__(2);
var has = __webpack_require__(15);
var DESCRIPTORS = __webpack_require__(7);
var $export = __webpack_require__(0);
var redefine = __webpack_require__(13);
var META = __webpack_require__(32).KEY;
var $fails = __webpack_require__(3);
var shared = __webpack_require__(50);
var setToStringTag = __webpack_require__(46);
var uid = __webpack_require__(35);
var wks = __webpack_require__(5);
var wksExt = __webpack_require__(98);
var wksDefine = __webpack_require__(71);
var enumKeys = __webpack_require__(143);
var isArray = __webpack_require__(58);
var anObject = __webpack_require__(1);
var isObject = __webpack_require__(4);
var toObject = __webpack_require__(10);
var toIObject = __webpack_require__(16);
var toPrimitive = __webpack_require__(24);
var createDesc = __webpack_require__(34);
var _create = __webpack_require__(38);
var gOPNExt = __webpack_require__(101);
var $GOPD = __webpack_require__(17);
var $GOPS = __webpack_require__(57);
var $DP = __webpack_require__(8);
var $keys = __webpack_require__(36);
var gOPD = $GOPD.f;
var dP = $DP.f;
var gOPN = gOPNExt.f;
var $Symbol = global.Symbol;
var $JSON = global.JSON;
var _stringify = $JSON && $JSON.stringify;
var PROTOTYPE = 'prototype';
var HIDDEN = wks('_hidden');
var TO_PRIMITIVE = wks('toPrimitive');
var isEnum = {}.propertyIsEnumerable;
var SymbolRegistry = shared('symbol-registry');
var AllSymbols = shared('symbols');
var OPSymbols = shared('op-symbols');
var ObjectProto = Object[PROTOTYPE];
var USE_NATIVE = typeof $Symbol == 'function' && !!$GOPS.f;
var QObject = global.QObject;
// Don't use setters in Qt Script, https://github.com/zloirock/core-js/issues/173
var setter = !QObject || !QObject[PROTOTYPE] || !QObject[PROTOTYPE].findChild;

// fallback for old Android, https://code.google.com/p/v8/issues/detail?id=687
var setSymbolDesc = DESCRIPTORS && $fails(function () {
  return _create(dP({}, 'a', {
    get: function () { return dP(this, 'a', { value: 7 }).a; }
  })).a != 7;
}) ? function (it, key, D) {
  var protoDesc = gOPD(ObjectProto, key);
  if (protoDesc) delete ObjectProto[key];
  dP(it, key, D);
  if (protoDesc && it !== ObjectProto) dP(ObjectProto, key, protoDesc);
} : dP;

var wrap = function (tag) {
  var sym = AllSymbols[tag] = _create($Symbol[PROTOTYPE]);
  sym._k = tag;
  return sym;
};

var isSymbol = USE_NATIVE && typeof $Symbol.iterator == 'symbol' ? function (it) {
  return typeof it == 'symbol';
} : function (it) {
  return it instanceof $Symbol;
};

var $defineProperty = function defineProperty(it, key, D) {
  if (it === ObjectProto) $defineProperty(OPSymbols, key, D);
  anObject(it);
  key = toPrimitive(key, true);
  anObject(D);
  if (has(AllSymbols, key)) {
    if (!D.enumerable) {
      if (!has(it, HIDDEN)) dP(it, HIDDEN, createDesc(1, {}));
      it[HIDDEN][key] = true;
    } else {
      if (has(it, HIDDEN) && it[HIDDEN][key]) it[HIDDEN][key] = false;
      D = _create(D, { enumerable: createDesc(0, false) });
    } return setSymbolDesc(it, key, D);
  } return dP(it, key, D);
};
var $defineProperties = function defineProperties(it, P) {
  anObject(it);
  var keys = enumKeys(P = toIObject(P));
  var i = 0;
  var l = keys.length;
  var key;
  while (l > i) $defineProperty(it, key = keys[i++], P[key]);
  return it;
};
var $create = function create(it, P) {
  return P === undefined ? _create(it) : $defineProperties(_create(it), P);
};
var $propertyIsEnumerable = function propertyIsEnumerable(key) {
  var E = isEnum.call(this, key = toPrimitive(key, true));
  if (this === ObjectProto && has(AllSymbols, key) && !has(OPSymbols, key)) return false;
  return E || !has(this, key) || !has(AllSymbols, key) || has(this, HIDDEN) && this[HIDDEN][key] ? E : true;
};
var $getOwnPropertyDescriptor = function getOwnPropertyDescriptor(it, key) {
  it = toIObject(it);
  key = toPrimitive(key, true);
  if (it === ObjectProto && has(AllSymbols, key) && !has(OPSymbols, key)) return;
  var D = gOPD(it, key);
  if (D && has(AllSymbols, key) && !(has(it, HIDDEN) && it[HIDDEN][key])) D.enumerable = true;
  return D;
};
var $getOwnPropertyNames = function getOwnPropertyNames(it) {
  var names = gOPN(toIObject(it));
  var result = [];
  var i = 0;
  var key;
  while (names.length > i) {
    if (!has(AllSymbols, key = names[i++]) && key != HIDDEN && key != META) result.push(key);
  } return result;
};
var $getOwnPropertySymbols = function getOwnPropertySymbols(it) {
  var IS_OP = it === ObjectProto;
  var names = gOPN(IS_OP ? OPSymbols : toIObject(it));
  var result = [];
  var i = 0;
  var key;
  while (names.length > i) {
    if (has(AllSymbols, key = names[i++]) && (IS_OP ? has(ObjectProto, key) : true)) result.push(AllSymbols[key]);
  } return result;
};

// 19.4.1.1 Symbol([description])
if (!USE_NATIVE) {
  $Symbol = function Symbol() {
    if (this instanceof $Symbol) throw TypeError('Symbol is not a constructor!');
    var tag = uid(arguments.length > 0 ? arguments[0] : undefined);
    var $set = function (value) {
      if (this === ObjectProto) $set.call(OPSymbols, value);
      if (has(this, HIDDEN) && has(this[HIDDEN], tag)) this[HIDDEN][tag] = false;
      setSymbolDesc(this, tag, createDesc(1, value));
    };
    if (DESCRIPTORS && setter) setSymbolDesc(ObjectProto, tag, { configurable: true, set: $set });
    return wrap(tag);
  };
  redefine($Symbol[PROTOTYPE], 'toString', function toString() {
    return this._k;
  });

  $GOPD.f = $getOwnPropertyDescriptor;
  $DP.f = $defineProperty;
  __webpack_require__(39).f = gOPNExt.f = $getOwnPropertyNames;
  __webpack_require__(52).f = $propertyIsEnumerable;
  $GOPS.f = $getOwnPropertySymbols;

  if (DESCRIPTORS && !__webpack_require__(31)) {
    redefine(ObjectProto, 'propertyIsEnumerable', $propertyIsEnumerable, true);
  }

  wksExt.f = function (name) {
    return wrap(wks(name));
  };
}

$export($export.G + $export.W + $export.F * !USE_NATIVE, { Symbol: $Symbol });

for (var es6Symbols = (
  // 19.4.2.2, 19.4.2.3, 19.4.2.4, 19.4.2.6, 19.4.2.8, 19.4.2.9, 19.4.2.10, 19.4.2.11, 19.4.2.12, 19.4.2.13, 19.4.2.14
  'hasInstance,isConcatSpreadable,iterator,match,replace,search,species,split,toPrimitive,toStringTag,unscopables'
).split(','), j = 0; es6Symbols.length > j;)wks(es6Symbols[j++]);

for (var wellKnownSymbols = $keys(wks.store), k = 0; wellKnownSymbols.length > k;) wksDefine(wellKnownSymbols[k++]);

$export($export.S + $export.F * !USE_NATIVE, 'Symbol', {
  // 19.4.2.1 Symbol.for(key)
  'for': function (key) {
    return has(SymbolRegistry, key += '')
      ? SymbolRegistry[key]
      : SymbolRegistry[key] = $Symbol(key);
  },
  // 19.4.2.5 Symbol.keyFor(sym)
  keyFor: function keyFor(sym) {
    if (!isSymbol(sym)) throw TypeError(sym + ' is not a symbol!');
    for (var key in SymbolRegistry) if (SymbolRegistry[key] === sym) return key;
  },
  useSetter: function () { setter = true; },
  useSimple: function () { setter = false; }
});

$export($export.S + $export.F * !USE_NATIVE, 'Object', {
  // 19.1.2.2 Object.create(O [, Properties])
  create: $create,
  // 19.1.2.4 Object.defineProperty(O, P, Attributes)
  defineProperty: $defineProperty,
  // 19.1.2.3 Object.defineProperties(O, Properties)
  defineProperties: $defineProperties,
  // 19.1.2.6 Object.getOwnPropertyDescriptor(O, P)
  getOwnPropertyDescriptor: $getOwnPropertyDescriptor,
  // 19.1.2.7 Object.getOwnPropertyNames(O)
  getOwnPropertyNames: $getOwnPropertyNames,
  // 19.1.2.8 Object.getOwnPropertySymbols(O)
  getOwnPropertySymbols: $getOwnPropertySymbols
});

// Chrome 38 and 39 `Object.getOwnPropertySymbols` fails on primitives
// https://bugs.chromium.org/p/v8/issues/detail?id=3443
var FAILS_ON_PRIMITIVES = $fails(function () { $GOPS.f(1); });

$export($export.S + $export.F * FAILS_ON_PRIMITIVES, 'Object', {
  getOwnPropertySymbols: function getOwnPropertySymbols(it) {
    return $GOPS.f(toObject(it));
  }
});

// 24.3.2 JSON.stringify(value [, replacer [, space]])
$JSON && $export($export.S + $export.F * (!USE_NATIVE || $fails(function () {
  var S = $Symbol();
  // MS Edge converts symbol values to JSON as {}
  // WebKit converts symbol values to JSON as null
  // V8 throws on boxed symbols
  return _stringify([S]) != '[null]' || _stringify({ a: S }) != '{}' || _stringify(Object(S)) != '{}';
})), 'JSON', {
  stringify: function stringify(it) {
    var args = [it];
    var i = 1;
    var replacer, $replacer;
    while (arguments.length > i) args.push(arguments[i++]);
    $replacer = replacer = args[1];
    if (!isObject(replacer) && it === undefined || isSymbol(it)) return; // IE8 returns string on undefined
    if (!isArray(replacer)) replacer = function (key, value) {
      if (typeof $replacer == 'function') value = $replacer.call(this, key, value);
      if (!isSymbol(value)) return value;
    };
    args[1] = replacer;
    return _stringify.apply($JSON, args);
  }
});

// 19.4.3.4 Symbol.prototype[@@toPrimitive](hint)
$Symbol[PROTOTYPE][TO_PRIMITIVE] || __webpack_require__(12)($Symbol[PROTOTYPE], TO_PRIMITIVE, $Symbol[PROTOTYPE].valueOf);
// 19.4.3.5 Symbol.prototype[@@toStringTag]
setToStringTag($Symbol, 'Symbol');
// 20.2.1.9 Math[@@toStringTag]
setToStringTag(Math, 'Math', true);
// 24.3.3 JSON[@@toStringTag]
setToStringTag(global.JSON, 'JSON', true);


/***/ }),
/* 142 */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__(50)('native-function-to-string', Function.toString);


/***/ }),
/* 143 */
/***/ (function(module, exports, __webpack_require__) {

// all enumerable object keys, includes symbols
var getKeys = __webpack_require__(36);
var gOPS = __webpack_require__(57);
var pIE = __webpack_require__(52);
module.exports = function (it) {
  var result = getKeys(it);
  var getSymbols = gOPS.f;
  if (getSymbols) {
    var symbols = getSymbols(it);
    var isEnum = pIE.f;
    var i = 0;
    var key;
    while (symbols.length > i) if (isEnum.call(it, key = symbols[i++])) result.push(key);
  } return result;
};


/***/ }),
/* 144 */
/***/ (function(module, exports, __webpack_require__) {

var $export = __webpack_require__(0);
// 19.1.2.2 / 15.2.3.5 Object.create(O [, Properties])
$export($export.S, 'Object', { create: __webpack_require__(38) });


/***/ }),
/* 145 */
/***/ (function(module, exports, __webpack_require__) {

var $export = __webpack_require__(0);
// 19.1.2.4 / 15.2.3.6 Object.defineProperty(O, P, Attributes)
$export($export.S + $export.F * !__webpack_require__(7), 'Object', { defineProperty: __webpack_require__(8).f });


/***/ }),
/* 146 */
/***/ (function(module, exports, __webpack_require__) {

var $export = __webpack_require__(0);
// 19.1.2.3 / 15.2.3.7 Object.defineProperties(O, Properties)
$export($export.S + $export.F * !__webpack_require__(7), 'Object', { defineProperties: __webpack_require__(100) });


/***/ }),
/* 147 */
/***/ (function(module, exports, __webpack_require__) {

// 19.1.2.6 Object.getOwnPropertyDescriptor(O, P)
var toIObject = __webpack_require__(16);
var $getOwnPropertyDescriptor = __webpack_require__(17).f;

__webpack_require__(26)('getOwnPropertyDescriptor', function () {
  return function getOwnPropertyDescriptor(it, key) {
    return $getOwnPropertyDescriptor(toIObject(it), key);
  };
});


/***/ }),
/* 148 */
/***/ (function(module, exports, __webpack_require__) {

// 19.1.2.9 Object.getPrototypeOf(O)
var toObject = __webpack_require__(10);
var $getPrototypeOf = __webpack_require__(18);

__webpack_require__(26)('getPrototypeOf', function () {
  return function getPrototypeOf(it) {
    return $getPrototypeOf(toObject(it));
  };
});


/***/ }),
/* 149 */
/***/ (function(module, exports, __webpack_require__) {

// 19.1.2.14 Object.keys(O)
var toObject = __webpack_require__(10);
var $keys = __webpack_require__(36);

__webpack_require__(26)('keys', function () {
  return function keys(it) {
    return $keys(toObject(it));
  };
});


/***/ }),
/* 150 */
/***/ (function(module, exports, __webpack_require__) {

// 19.1.2.7 Object.getOwnPropertyNames(O)
__webpack_require__(26)('getOwnPropertyNames', function () {
  return __webpack_require__(101).f;
});


/***/ }),
/* 151 */
/***/ (function(module, exports, __webpack_require__) {

// 19.1.2.5 Object.freeze(O)
var isObject = __webpack_require__(4);
var meta = __webpack_require__(32).onFreeze;

__webpack_require__(26)('freeze', function ($freeze) {
  return function freeze(it) {
    return $freeze && isObject(it) ? $freeze(meta(it)) : it;
  };
});


/***/ }),
/* 152 */
/***/ (function(module, exports, __webpack_require__) {

// 19.1.2.17 Object.seal(O)
var isObject = __webpack_require__(4);
var meta = __webpack_require__(32).onFreeze;

__webpack_require__(26)('seal', function ($seal) {
  return function seal(it) {
    return $seal && isObject(it) ? $seal(meta(it)) : it;
  };
});


/***/ }),
/* 153 */
/***/ (function(module, exports, __webpack_require__) {

// 19.1.2.15 Object.preventExtensions(O)
var isObject = __webpack_require__(4);
var meta = __webpack_require__(32).onFreeze;

__webpack_require__(26)('preventExtensions', function ($preventExtensions) {
  return function preventExtensions(it) {
    return $preventExtensions && isObject(it) ? $preventExtensions(meta(it)) : it;
  };
});


/***/ }),
/* 154 */
/***/ (function(module, exports, __webpack_require__) {

// 19.1.2.12 Object.isFrozen(O)
var isObject = __webpack_require__(4);

__webpack_require__(26)('isFrozen', function ($isFrozen) {
  return function isFrozen(it) {
    return isObject(it) ? $isFrozen ? $isFrozen(it) : false : true;
  };
});


/***/ }),
/* 155 */
/***/ (function(module, exports, __webpack_require__) {

// 19.1.2.13 Object.isSealed(O)
var isObject = __webpack_require__(4);

__webpack_require__(26)('isSealed', function ($isSealed) {
  return function isSealed(it) {
    return isObject(it) ? $isSealed ? $isSealed(it) : false : true;
  };
});


/***/ }),
/* 156 */
/***/ (function(module, exports, __webpack_require__) {

// 19.1.2.11 Object.isExtensible(O)
var isObject = __webpack_require__(4);

__webpack_require__(26)('isExtensible', function ($isExtensible) {
  return function isExtensible(it) {
    return isObject(it) ? $isExtensible ? $isExtensible(it) : true : false;
  };
});


/***/ }),
/* 157 */
/***/ (function(module, exports, __webpack_require__) {

// 19.1.3.1 Object.assign(target, source)
var $export = __webpack_require__(0);

$export($export.S + $export.F, 'Object', { assign: __webpack_require__(102) });


/***/ }),
/* 158 */
/***/ (function(module, exports, __webpack_require__) {

// 19.1.3.10 Object.is(value1, value2)
var $export = __webpack_require__(0);
$export($export.S, 'Object', { is: __webpack_require__(103) });


/***/ }),
/* 159 */
/***/ (function(module, exports, __webpack_require__) {

// 19.1.3.19 Object.setPrototypeOf(O, proto)
var $export = __webpack_require__(0);
$export($export.S, 'Object', { setPrototypeOf: __webpack_require__(75).set });


/***/ }),
/* 160 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// 19.1.3.6 Object.prototype.toString()
var classof = __webpack_require__(47);
var test = {};
test[__webpack_require__(5)('toStringTag')] = 'z';
if (test + '' != '[object z]') {
  __webpack_require__(13)(Object.prototype, 'toString', function toString() {
    return '[object ' + classof(this) + ']';
  }, true);
}


/***/ }),
/* 161 */
/***/ (function(module, exports, __webpack_require__) {

// 19.2.3.2 / 15.3.4.5 Function.prototype.bind(thisArg, args...)
var $export = __webpack_require__(0);

$export($export.P, 'Function', { bind: __webpack_require__(104) });


/***/ }),
/* 162 */
/***/ (function(module, exports, __webpack_require__) {

var dP = __webpack_require__(8).f;
var FProto = Function.prototype;
var nameRE = /^\s*function ([^ (]*)/;
var NAME = 'name';

// 19.2.4.2 name
NAME in FProto || __webpack_require__(7) && dP(FProto, NAME, {
  configurable: true,
  get: function () {
    try {
      return ('' + this).match(nameRE)[1];
    } catch (e) {
      return '';
    }
  }
});


/***/ }),
/* 163 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var isObject = __webpack_require__(4);
var getPrototypeOf = __webpack_require__(18);
var HAS_INSTANCE = __webpack_require__(5)('hasInstance');
var FunctionProto = Function.prototype;
// 19.2.3.6 Function.prototype[@@hasInstance](V)
if (!(HAS_INSTANCE in FunctionProto)) __webpack_require__(8).f(FunctionProto, HAS_INSTANCE, { value: function (O) {
  if (typeof this != 'function' || !isObject(O)) return false;
  if (!isObject(this.prototype)) return O instanceof this;
  // for environment w/o native `@@hasInstance` logic enough `instanceof`, but add this:
  while (O = getPrototypeOf(O)) if (this.prototype === O) return true;
  return false;
} });


/***/ }),
/* 164 */
/***/ (function(module, exports, __webpack_require__) {

var $export = __webpack_require__(0);
var $parseInt = __webpack_require__(106);
// 18.2.5 parseInt(string, radix)
$export($export.G + $export.F * (parseInt != $parseInt), { parseInt: $parseInt });


/***/ }),
/* 165 */
/***/ (function(module, exports, __webpack_require__) {

var $export = __webpack_require__(0);
var $parseFloat = __webpack_require__(107);
// 18.2.4 parseFloat(string)
$export($export.G + $export.F * (parseFloat != $parseFloat), { parseFloat: $parseFloat });


/***/ }),
/* 166 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var global = __webpack_require__(2);
var has = __webpack_require__(15);
var cof = __webpack_require__(21);
var inheritIfRequired = __webpack_require__(77);
var toPrimitive = __webpack_require__(24);
var fails = __webpack_require__(3);
var gOPN = __webpack_require__(39).f;
var gOPD = __webpack_require__(17).f;
var dP = __webpack_require__(8).f;
var $trim = __webpack_require__(48).trim;
var NUMBER = 'Number';
var $Number = global[NUMBER];
var Base = $Number;
var proto = $Number.prototype;
// Opera ~12 has broken Object#toString
var BROKEN_COF = cof(__webpack_require__(38)(proto)) == NUMBER;
var TRIM = 'trim' in String.prototype;

// 7.1.3 ToNumber(argument)
var toNumber = function (argument) {
  var it = toPrimitive(argument, false);
  if (typeof it == 'string' && it.length > 2) {
    it = TRIM ? it.trim() : $trim(it, 3);
    var first = it.charCodeAt(0);
    var third, radix, maxCode;
    if (first === 43 || first === 45) {
      third = it.charCodeAt(2);
      if (third === 88 || third === 120) return NaN; // Number('+0x1') should be NaN, old V8 fix
    } else if (first === 48) {
      switch (it.charCodeAt(1)) {
        case 66: case 98: radix = 2; maxCode = 49; break; // fast equal /^0b[01]+$/i
        case 79: case 111: radix = 8; maxCode = 55; break; // fast equal /^0o[0-7]+$/i
        default: return +it;
      }
      for (var digits = it.slice(2), i = 0, l = digits.length, code; i < l; i++) {
        code = digits.charCodeAt(i);
        // parseInt parses a string to a first unavailable symbol
        // but ToNumber should return NaN if a string contains unavailable symbols
        if (code < 48 || code > maxCode) return NaN;
      } return parseInt(digits, radix);
    }
  } return +it;
};

if (!$Number(' 0o1') || !$Number('0b1') || $Number('+0x1')) {
  $Number = function Number(value) {
    var it = arguments.length < 1 ? 0 : value;
    var that = this;
    return that instanceof $Number
      // check on 1..constructor(foo) case
      && (BROKEN_COF ? fails(function () { proto.valueOf.call(that); }) : cof(that) != NUMBER)
        ? inheritIfRequired(new Base(toNumber(it)), that, $Number) : toNumber(it);
  };
  for (var keys = __webpack_require__(7) ? gOPN(Base) : (
    // ES3:
    'MAX_VALUE,MIN_VALUE,NaN,NEGATIVE_INFINITY,POSITIVE_INFINITY,' +
    // ES6 (in case, if modules with ES6 Number statics required before):
    'EPSILON,isFinite,isInteger,isNaN,isSafeInteger,MAX_SAFE_INTEGER,' +
    'MIN_SAFE_INTEGER,parseFloat,parseInt,isInteger'
  ).split(','), j = 0, key; keys.length > j; j++) {
    if (has(Base, key = keys[j]) && !has($Number, key)) {
      dP($Number, key, gOPD(Base, key));
    }
  }
  $Number.prototype = proto;
  proto.constructor = $Number;
  __webpack_require__(13)(global, NUMBER, $Number);
}


/***/ }),
/* 167 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $export = __webpack_require__(0);
var toInteger = __webpack_require__(22);
var aNumberValue = __webpack_require__(108);
var repeat = __webpack_require__(78);
var $toFixed = 1.0.toFixed;
var floor = Math.floor;
var data = [0, 0, 0, 0, 0, 0];
var ERROR = 'Number.toFixed: incorrect invocation!';
var ZERO = '0';

var multiply = function (n, c) {
  var i = -1;
  var c2 = c;
  while (++i < 6) {
    c2 += n * data[i];
    data[i] = c2 % 1e7;
    c2 = floor(c2 / 1e7);
  }
};
var divide = function (n) {
  var i = 6;
  var c = 0;
  while (--i >= 0) {
    c += data[i];
    data[i] = floor(c / n);
    c = (c % n) * 1e7;
  }
};
var numToString = function () {
  var i = 6;
  var s = '';
  while (--i >= 0) {
    if (s !== '' || i === 0 || data[i] !== 0) {
      var t = String(data[i]);
      s = s === '' ? t : s + repeat.call(ZERO, 7 - t.length) + t;
    }
  } return s;
};
var pow = function (x, n, acc) {
  return n === 0 ? acc : n % 2 === 1 ? pow(x, n - 1, acc * x) : pow(x * x, n / 2, acc);
};
var log = function (x) {
  var n = 0;
  var x2 = x;
  while (x2 >= 4096) {
    n += 12;
    x2 /= 4096;
  }
  while (x2 >= 2) {
    n += 1;
    x2 /= 2;
  } return n;
};

$export($export.P + $export.F * (!!$toFixed && (
  0.00008.toFixed(3) !== '0.000' ||
  0.9.toFixed(0) !== '1' ||
  1.255.toFixed(2) !== '1.25' ||
  1000000000000000128.0.toFixed(0) !== '1000000000000000128'
) || !__webpack_require__(3)(function () {
  // V8 ~ Android 4.3-
  $toFixed.call({});
})), 'Number', {
  toFixed: function toFixed(fractionDigits) {
    var x = aNumberValue(this, ERROR);
    var f = toInteger(fractionDigits);
    var s = '';
    var m = ZERO;
    var e, z, j, k;
    if (f < 0 || f > 20) throw RangeError(ERROR);
    // eslint-disable-next-line no-self-compare
    if (x != x) return 'NaN';
    if (x <= -1e21 || x >= 1e21) return String(x);
    if (x < 0) {
      s = '-';
      x = -x;
    }
    if (x > 1e-21) {
      e = log(x * pow(2, 69, 1)) - 69;
      z = e < 0 ? x * pow(2, -e, 1) : x / pow(2, e, 1);
      z *= 0x10000000000000;
      e = 52 - e;
      if (e > 0) {
        multiply(0, z);
        j = f;
        while (j >= 7) {
          multiply(1e7, 0);
          j -= 7;
        }
        multiply(pow(10, j, 1), 0);
        j = e - 1;
        while (j >= 23) {
          divide(1 << 23);
          j -= 23;
        }
        divide(1 << j);
        multiply(1, 1);
        divide(2);
        m = numToString();
      } else {
        multiply(0, z);
        multiply(1 << -e, 0);
        m = numToString() + repeat.call(ZERO, f);
      }
    }
    if (f > 0) {
      k = m.length;
      m = s + (k <= f ? '0.' + repeat.call(ZERO, f - k) + m : m.slice(0, k - f) + '.' + m.slice(k - f));
    } else {
      m = s + m;
    } return m;
  }
});


/***/ }),
/* 168 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $export = __webpack_require__(0);
var $fails = __webpack_require__(3);
var aNumberValue = __webpack_require__(108);
var $toPrecision = 1.0.toPrecision;

$export($export.P + $export.F * ($fails(function () {
  // IE7-
  return $toPrecision.call(1, undefined) !== '1';
}) || !$fails(function () {
  // V8 ~ Android 4.3-
  $toPrecision.call({});
})), 'Number', {
  toPrecision: function toPrecision(precision) {
    var that = aNumberValue(this, 'Number#toPrecision: incorrect invocation!');
    return precision === undefined ? $toPrecision.call(that) : $toPrecision.call(that, precision);
  }
});


/***/ }),
/* 169 */
/***/ (function(module, exports, __webpack_require__) {

// 20.1.2.1 Number.EPSILON
var $export = __webpack_require__(0);

$export($export.S, 'Number', { EPSILON: Math.pow(2, -52) });


/***/ }),
/* 170 */
/***/ (function(module, exports, __webpack_require__) {

// 20.1.2.2 Number.isFinite(number)
var $export = __webpack_require__(0);
var _isFinite = __webpack_require__(2).isFinite;

$export($export.S, 'Number', {
  isFinite: function isFinite(it) {
    return typeof it == 'number' && _isFinite(it);
  }
});


/***/ }),
/* 171 */
/***/ (function(module, exports, __webpack_require__) {

// 20.1.2.3 Number.isInteger(number)
var $export = __webpack_require__(0);

$export($export.S, 'Number', { isInteger: __webpack_require__(109) });


/***/ }),
/* 172 */
/***/ (function(module, exports, __webpack_require__) {

// 20.1.2.4 Number.isNaN(number)
var $export = __webpack_require__(0);

$export($export.S, 'Number', {
  isNaN: function isNaN(number) {
    // eslint-disable-next-line no-self-compare
    return number != number;
  }
});


/***/ }),
/* 173 */
/***/ (function(module, exports, __webpack_require__) {

// 20.1.2.5 Number.isSafeInteger(number)
var $export = __webpack_require__(0);
var isInteger = __webpack_require__(109);
var abs = Math.abs;

$export($export.S, 'Number', {
  isSafeInteger: function isSafeInteger(number) {
    return isInteger(number) && abs(number) <= 0x1fffffffffffff;
  }
});


/***/ }),
/* 174 */
/***/ (function(module, exports, __webpack_require__) {

// 20.1.2.6 Number.MAX_SAFE_INTEGER
var $export = __webpack_require__(0);

$export($export.S, 'Number', { MAX_SAFE_INTEGER: 0x1fffffffffffff });


/***/ }),
/* 175 */
/***/ (function(module, exports, __webpack_require__) {

// 20.1.2.10 Number.MIN_SAFE_INTEGER
var $export = __webpack_require__(0);

$export($export.S, 'Number', { MIN_SAFE_INTEGER: -0x1fffffffffffff });


/***/ }),
/* 176 */
/***/ (function(module, exports, __webpack_require__) {

var $export = __webpack_require__(0);
var $parseFloat = __webpack_require__(107);
// 20.1.2.12 Number.parseFloat(string)
$export($export.S + $export.F * (Number.parseFloat != $parseFloat), 'Number', { parseFloat: $parseFloat });


/***/ }),
/* 177 */
/***/ (function(module, exports, __webpack_require__) {

var $export = __webpack_require__(0);
var $parseInt = __webpack_require__(106);
// 20.1.2.13 Number.parseInt(string, radix)
$export($export.S + $export.F * (Number.parseInt != $parseInt), 'Number', { parseInt: $parseInt });


/***/ }),
/* 178 */
/***/ (function(module, exports, __webpack_require__) {

// 20.2.2.3 Math.acosh(x)
var $export = __webpack_require__(0);
var log1p = __webpack_require__(110);
var sqrt = Math.sqrt;
var $acosh = Math.acosh;

$export($export.S + $export.F * !($acosh
  // V8 bug: https://code.google.com/p/v8/issues/detail?id=3509
  && Math.floor($acosh(Number.MAX_VALUE)) == 710
  // Tor Browser bug: Math.acosh(Infinity) -> NaN
  && $acosh(Infinity) == Infinity
), 'Math', {
  acosh: function acosh(x) {
    return (x = +x) < 1 ? NaN : x > 94906265.62425156
      ? Math.log(x) + Math.LN2
      : log1p(x - 1 + sqrt(x - 1) * sqrt(x + 1));
  }
});


/***/ }),
/* 179 */
/***/ (function(module, exports, __webpack_require__) {

// 20.2.2.5 Math.asinh(x)
var $export = __webpack_require__(0);
var $asinh = Math.asinh;

function asinh(x) {
  return !isFinite(x = +x) || x == 0 ? x : x < 0 ? -asinh(-x) : Math.log(x + Math.sqrt(x * x + 1));
}

// Tor Browser bug: Math.asinh(0) -> -0
$export($export.S + $export.F * !($asinh && 1 / $asinh(0) > 0), 'Math', { asinh: asinh });


/***/ }),
/* 180 */
/***/ (function(module, exports, __webpack_require__) {

// 20.2.2.7 Math.atanh(x)
var $export = __webpack_require__(0);
var $atanh = Math.atanh;

// Tor Browser bug: Math.atanh(-0) -> 0
$export($export.S + $export.F * !($atanh && 1 / $atanh(-0) < 0), 'Math', {
  atanh: function atanh(x) {
    return (x = +x) == 0 ? x : Math.log((1 + x) / (1 - x)) / 2;
  }
});


/***/ }),
/* 181 */
/***/ (function(module, exports, __webpack_require__) {

// 20.2.2.9 Math.cbrt(x)
var $export = __webpack_require__(0);
var sign = __webpack_require__(79);

$export($export.S, 'Math', {
  cbrt: function cbrt(x) {
    return sign(x = +x) * Math.pow(Math.abs(x), 1 / 3);
  }
});


/***/ }),
/* 182 */
/***/ (function(module, exports, __webpack_require__) {

// 20.2.2.11 Math.clz32(x)
var $export = __webpack_require__(0);

$export($export.S, 'Math', {
  clz32: function clz32(x) {
    return (x >>>= 0) ? 31 - Math.floor(Math.log(x + 0.5) * Math.LOG2E) : 32;
  }
});


/***/ }),
/* 183 */
/***/ (function(module, exports, __webpack_require__) {

// 20.2.2.12 Math.cosh(x)
var $export = __webpack_require__(0);
var exp = Math.exp;

$export($export.S, 'Math', {
  cosh: function cosh(x) {
    return (exp(x = +x) + exp(-x)) / 2;
  }
});


/***/ }),
/* 184 */
/***/ (function(module, exports, __webpack_require__) {

// 20.2.2.14 Math.expm1(x)
var $export = __webpack_require__(0);
var $expm1 = __webpack_require__(80);

$export($export.S + $export.F * ($expm1 != Math.expm1), 'Math', { expm1: $expm1 });


/***/ }),
/* 185 */
/***/ (function(module, exports, __webpack_require__) {

// 20.2.2.16 Math.fround(x)
var $export = __webpack_require__(0);

$export($export.S, 'Math', { fround: __webpack_require__(111) });


/***/ }),
/* 186 */
/***/ (function(module, exports, __webpack_require__) {

// 20.2.2.17 Math.hypot([value1[, value2[, … ]]])
var $export = __webpack_require__(0);
var abs = Math.abs;

$export($export.S, 'Math', {
  hypot: function hypot(value1, value2) { // eslint-disable-line no-unused-vars
    var sum = 0;
    var i = 0;
    var aLen = arguments.length;
    var larg = 0;
    var arg, div;
    while (i < aLen) {
      arg = abs(arguments[i++]);
      if (larg < arg) {
        div = larg / arg;
        sum = sum * div * div + 1;
        larg = arg;
      } else if (arg > 0) {
        div = arg / larg;
        sum += div * div;
      } else sum += arg;
    }
    return larg === Infinity ? Infinity : larg * Math.sqrt(sum);
  }
});


/***/ }),
/* 187 */
/***/ (function(module, exports, __webpack_require__) {

// 20.2.2.18 Math.imul(x, y)
var $export = __webpack_require__(0);
var $imul = Math.imul;

// some WebKit versions fails with big numbers, some has wrong arity
$export($export.S + $export.F * __webpack_require__(3)(function () {
  return $imul(0xffffffff, 5) != -5 || $imul.length != 2;
}), 'Math', {
  imul: function imul(x, y) {
    var UINT16 = 0xffff;
    var xn = +x;
    var yn = +y;
    var xl = UINT16 & xn;
    var yl = UINT16 & yn;
    return 0 | xl * yl + ((UINT16 & xn >>> 16) * yl + xl * (UINT16 & yn >>> 16) << 16 >>> 0);
  }
});


/***/ }),
/* 188 */
/***/ (function(module, exports, __webpack_require__) {

// 20.2.2.21 Math.log10(x)
var $export = __webpack_require__(0);

$export($export.S, 'Math', {
  log10: function log10(x) {
    return Math.log(x) * Math.LOG10E;
  }
});


/***/ }),
/* 189 */
/***/ (function(module, exports, __webpack_require__) {

// 20.2.2.20 Math.log1p(x)
var $export = __webpack_require__(0);

$export($export.S, 'Math', { log1p: __webpack_require__(110) });


/***/ }),
/* 190 */
/***/ (function(module, exports, __webpack_require__) {

// 20.2.2.22 Math.log2(x)
var $export = __webpack_require__(0);

$export($export.S, 'Math', {
  log2: function log2(x) {
    return Math.log(x) / Math.LN2;
  }
});


/***/ }),
/* 191 */
/***/ (function(module, exports, __webpack_require__) {

// 20.2.2.28 Math.sign(x)
var $export = __webpack_require__(0);

$export($export.S, 'Math', { sign: __webpack_require__(79) });


/***/ }),
/* 192 */
/***/ (function(module, exports, __webpack_require__) {

// 20.2.2.30 Math.sinh(x)
var $export = __webpack_require__(0);
var expm1 = __webpack_require__(80);
var exp = Math.exp;

// V8 near Chromium 38 has a problem with very small numbers
$export($export.S + $export.F * __webpack_require__(3)(function () {
  return !Math.sinh(-2e-17) != -2e-17;
}), 'Math', {
  sinh: function sinh(x) {
    return Math.abs(x = +x) < 1
      ? (expm1(x) - expm1(-x)) / 2
      : (exp(x - 1) - exp(-x - 1)) * (Math.E / 2);
  }
});


/***/ }),
/* 193 */
/***/ (function(module, exports, __webpack_require__) {

// 20.2.2.33 Math.tanh(x)
var $export = __webpack_require__(0);
var expm1 = __webpack_require__(80);
var exp = Math.exp;

$export($export.S, 'Math', {
  tanh: function tanh(x) {
    var a = expm1(x = +x);
    var b = expm1(-x);
    return a == Infinity ? 1 : b == Infinity ? -1 : (a - b) / (exp(x) + exp(-x));
  }
});


/***/ }),
/* 194 */
/***/ (function(module, exports, __webpack_require__) {

// 20.2.2.34 Math.trunc(x)
var $export = __webpack_require__(0);

$export($export.S, 'Math', {
  trunc: function trunc(it) {
    return (it > 0 ? Math.floor : Math.ceil)(it);
  }
});


/***/ }),
/* 195 */
/***/ (function(module, exports, __webpack_require__) {

var $export = __webpack_require__(0);
var toAbsoluteIndex = __webpack_require__(37);
var fromCharCode = String.fromCharCode;
var $fromCodePoint = String.fromCodePoint;

// length should be 1, old FF problem
$export($export.S + $export.F * (!!$fromCodePoint && $fromCodePoint.length != 1), 'String', {
  // 21.1.2.2 String.fromCodePoint(...codePoints)
  fromCodePoint: function fromCodePoint(x) { // eslint-disable-line no-unused-vars
    var res = [];
    var aLen = arguments.length;
    var i = 0;
    var code;
    while (aLen > i) {
      code = +arguments[i++];
      if (toAbsoluteIndex(code, 0x10ffff) !== code) throw RangeError(code + ' is not a valid code point');
      res.push(code < 0x10000
        ? fromCharCode(code)
        : fromCharCode(((code -= 0x10000) >> 10) + 0xd800, code % 0x400 + 0xdc00)
      );
    } return res.join('');
  }
});


/***/ }),
/* 196 */
/***/ (function(module, exports, __webpack_require__) {

var $export = __webpack_require__(0);
var toIObject = __webpack_require__(16);
var toLength = __webpack_require__(6);

$export($export.S, 'String', {
  // 21.1.2.4 String.raw(callSite, ...substitutions)
  raw: function raw(callSite) {
    var tpl = toIObject(callSite.raw);
    var len = toLength(tpl.length);
    var aLen = arguments.length;
    var res = [];
    var i = 0;
    while (len > i) {
      res.push(String(tpl[i++]));
      if (i < aLen) res.push(String(arguments[i]));
    } return res.join('');
  }
});


/***/ }),
/* 197 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// 21.1.3.25 String.prototype.trim()
__webpack_require__(48)('trim', function ($trim) {
  return function trim() {
    return $trim(this, 3);
  };
});


/***/ }),
/* 198 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $at = __webpack_require__(59)(true);

// 21.1.3.27 String.prototype[@@iterator]()
__webpack_require__(81)(String, 'String', function (iterated) {
  this._t = String(iterated); // target
  this._i = 0;                // next index
// 21.1.5.2.1 %StringIteratorPrototype%.next()
}, function () {
  var O = this._t;
  var index = this._i;
  var point;
  if (index >= O.length) return { value: undefined, done: true };
  point = $at(O, index);
  this._i += point.length;
  return { value: point, done: false };
});


/***/ }),
/* 199 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $export = __webpack_require__(0);
var $at = __webpack_require__(59)(false);
$export($export.P, 'String', {
  // 21.1.3.3 String.prototype.codePointAt(pos)
  codePointAt: function codePointAt(pos) {
    return $at(this, pos);
  }
});


/***/ }),
/* 200 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
// 21.1.3.6 String.prototype.endsWith(searchString [, endPosition])

var $export = __webpack_require__(0);
var toLength = __webpack_require__(6);
var context = __webpack_require__(83);
var ENDS_WITH = 'endsWith';
var $endsWith = ''[ENDS_WITH];

$export($export.P + $export.F * __webpack_require__(84)(ENDS_WITH), 'String', {
  endsWith: function endsWith(searchString /* , endPosition = @length */) {
    var that = context(this, searchString, ENDS_WITH);
    var endPosition = arguments.length > 1 ? arguments[1] : undefined;
    var len = toLength(that.length);
    var end = endPosition === undefined ? len : Math.min(toLength(endPosition), len);
    var search = String(searchString);
    return $endsWith
      ? $endsWith.call(that, search, end)
      : that.slice(end - search.length, end) === search;
  }
});


/***/ }),
/* 201 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
// 21.1.3.7 String.prototype.includes(searchString, position = 0)

var $export = __webpack_require__(0);
var context = __webpack_require__(83);
var INCLUDES = 'includes';

$export($export.P + $export.F * __webpack_require__(84)(INCLUDES), 'String', {
  includes: function includes(searchString /* , position = 0 */) {
    return !!~context(this, searchString, INCLUDES)
      .indexOf(searchString, arguments.length > 1 ? arguments[1] : undefined);
  }
});


/***/ }),
/* 202 */
/***/ (function(module, exports, __webpack_require__) {

var $export = __webpack_require__(0);

$export($export.P, 'String', {
  // 21.1.3.13 String.prototype.repeat(count)
  repeat: __webpack_require__(78)
});


/***/ }),
/* 203 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
// 21.1.3.18 String.prototype.startsWith(searchString [, position ])

var $export = __webpack_require__(0);
var toLength = __webpack_require__(6);
var context = __webpack_require__(83);
var STARTS_WITH = 'startsWith';
var $startsWith = ''[STARTS_WITH];

$export($export.P + $export.F * __webpack_require__(84)(STARTS_WITH), 'String', {
  startsWith: function startsWith(searchString /* , position = 0 */) {
    var that = context(this, searchString, STARTS_WITH);
    var index = toLength(Math.min(arguments.length > 1 ? arguments[1] : undefined, that.length));
    var search = String(searchString);
    return $startsWith
      ? $startsWith.call(that, search, index)
      : that.slice(index, index + search.length) === search;
  }
});


/***/ }),
/* 204 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// B.2.3.2 String.prototype.anchor(name)
__webpack_require__(14)('anchor', function (createHTML) {
  return function anchor(name) {
    return createHTML(this, 'a', 'name', name);
  };
});


/***/ }),
/* 205 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// B.2.3.3 String.prototype.big()
__webpack_require__(14)('big', function (createHTML) {
  return function big() {
    return createHTML(this, 'big', '', '');
  };
});


/***/ }),
/* 206 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// B.2.3.4 String.prototype.blink()
__webpack_require__(14)('blink', function (createHTML) {
  return function blink() {
    return createHTML(this, 'blink', '', '');
  };
});


/***/ }),
/* 207 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// B.2.3.5 String.prototype.bold()
__webpack_require__(14)('bold', function (createHTML) {
  return function bold() {
    return createHTML(this, 'b', '', '');
  };
});


/***/ }),
/* 208 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// B.2.3.6 String.prototype.fixed()
__webpack_require__(14)('fixed', function (createHTML) {
  return function fixed() {
    return createHTML(this, 'tt', '', '');
  };
});


/***/ }),
/* 209 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// B.2.3.7 String.prototype.fontcolor(color)
__webpack_require__(14)('fontcolor', function (createHTML) {
  return function fontcolor(color) {
    return createHTML(this, 'font', 'color', color);
  };
});


/***/ }),
/* 210 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// B.2.3.8 String.prototype.fontsize(size)
__webpack_require__(14)('fontsize', function (createHTML) {
  return function fontsize(size) {
    return createHTML(this, 'font', 'size', size);
  };
});


/***/ }),
/* 211 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// B.2.3.9 String.prototype.italics()
__webpack_require__(14)('italics', function (createHTML) {
  return function italics() {
    return createHTML(this, 'i', '', '');
  };
});


/***/ }),
/* 212 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// B.2.3.10 String.prototype.link(url)
__webpack_require__(14)('link', function (createHTML) {
  return function link(url) {
    return createHTML(this, 'a', 'href', url);
  };
});


/***/ }),
/* 213 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// B.2.3.11 String.prototype.small()
__webpack_require__(14)('small', function (createHTML) {
  return function small() {
    return createHTML(this, 'small', '', '');
  };
});


/***/ }),
/* 214 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// B.2.3.12 String.prototype.strike()
__webpack_require__(14)('strike', function (createHTML) {
  return function strike() {
    return createHTML(this, 'strike', '', '');
  };
});


/***/ }),
/* 215 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// B.2.3.13 String.prototype.sub()
__webpack_require__(14)('sub', function (createHTML) {
  return function sub() {
    return createHTML(this, 'sub', '', '');
  };
});


/***/ }),
/* 216 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// B.2.3.14 String.prototype.sup()
__webpack_require__(14)('sup', function (createHTML) {
  return function sup() {
    return createHTML(this, 'sup', '', '');
  };
});


/***/ }),
/* 217 */
/***/ (function(module, exports, __webpack_require__) {

// 20.3.3.1 / 15.9.4.4 Date.now()
var $export = __webpack_require__(0);

$export($export.S, 'Date', { now: function () { return new Date().getTime(); } });


/***/ }),
/* 218 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $export = __webpack_require__(0);
var toObject = __webpack_require__(10);
var toPrimitive = __webpack_require__(24);

$export($export.P + $export.F * __webpack_require__(3)(function () {
  return new Date(NaN).toJSON() !== null
    || Date.prototype.toJSON.call({ toISOString: function () { return 1; } }) !== 1;
}), 'Date', {
  // eslint-disable-next-line no-unused-vars
  toJSON: function toJSON(key) {
    var O = toObject(this);
    var pv = toPrimitive(O);
    return typeof pv == 'number' && !isFinite(pv) ? null : O.toISOString();
  }
});


/***/ }),
/* 219 */
/***/ (function(module, exports, __webpack_require__) {

// 20.3.4.36 / 15.9.5.43 Date.prototype.toISOString()
var $export = __webpack_require__(0);
var toISOString = __webpack_require__(220);

// PhantomJS / old WebKit has a broken implementations
$export($export.P + $export.F * (Date.prototype.toISOString !== toISOString), 'Date', {
  toISOString: toISOString
});


/***/ }),
/* 220 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// 20.3.4.36 / 15.9.5.43 Date.prototype.toISOString()
var fails = __webpack_require__(3);
var getTime = Date.prototype.getTime;
var $toISOString = Date.prototype.toISOString;

var lz = function (num) {
  return num > 9 ? num : '0' + num;
};

// PhantomJS / old WebKit has a broken implementations
module.exports = (fails(function () {
  return $toISOString.call(new Date(-5e13 - 1)) != '0385-07-25T07:06:39.999Z';
}) || !fails(function () {
  $toISOString.call(new Date(NaN));
})) ? function toISOString() {
  if (!isFinite(getTime.call(this))) throw RangeError('Invalid time value');
  var d = this;
  var y = d.getUTCFullYear();
  var m = d.getUTCMilliseconds();
  var s = y < 0 ? '-' : y > 9999 ? '+' : '';
  return s + ('00000' + Math.abs(y)).slice(s ? -6 : -4) +
    '-' + lz(d.getUTCMonth() + 1) + '-' + lz(d.getUTCDate()) +
    'T' + lz(d.getUTCHours()) + ':' + lz(d.getUTCMinutes()) +
    ':' + lz(d.getUTCSeconds()) + '.' + (m > 99 ? m : '0' + lz(m)) + 'Z';
} : $toISOString;


/***/ }),
/* 221 */
/***/ (function(module, exports, __webpack_require__) {

var DateProto = Date.prototype;
var INVALID_DATE = 'Invalid Date';
var TO_STRING = 'toString';
var $toString = DateProto[TO_STRING];
var getTime = DateProto.getTime;
if (new Date(NaN) + '' != INVALID_DATE) {
  __webpack_require__(13)(DateProto, TO_STRING, function toString() {
    var value = getTime.call(this);
    // eslint-disable-next-line no-self-compare
    return value === value ? $toString.call(this) : INVALID_DATE;
  });
}


/***/ }),
/* 222 */
/***/ (function(module, exports, __webpack_require__) {

var TO_PRIMITIVE = __webpack_require__(5)('toPrimitive');
var proto = Date.prototype;

if (!(TO_PRIMITIVE in proto)) __webpack_require__(12)(proto, TO_PRIMITIVE, __webpack_require__(223));


/***/ }),
/* 223 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var anObject = __webpack_require__(1);
var toPrimitive = __webpack_require__(24);
var NUMBER = 'number';

module.exports = function (hint) {
  if (hint !== 'string' && hint !== NUMBER && hint !== 'default') throw TypeError('Incorrect hint');
  return toPrimitive(anObject(this), hint != NUMBER);
};


/***/ }),
/* 224 */
/***/ (function(module, exports, __webpack_require__) {

// 22.1.2.2 / 15.4.3.2 Array.isArray(arg)
var $export = __webpack_require__(0);

$export($export.S, 'Array', { isArray: __webpack_require__(58) });


/***/ }),
/* 225 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var ctx = __webpack_require__(20);
var $export = __webpack_require__(0);
var toObject = __webpack_require__(10);
var call = __webpack_require__(112);
var isArrayIter = __webpack_require__(85);
var toLength = __webpack_require__(6);
var createProperty = __webpack_require__(86);
var getIterFn = __webpack_require__(87);

$export($export.S + $export.F * !__webpack_require__(61)(function (iter) { Array.from(iter); }), 'Array', {
  // 22.1.2.1 Array.from(arrayLike, mapfn = undefined, thisArg = undefined)
  from: function from(arrayLike /* , mapfn = undefined, thisArg = undefined */) {
    var O = toObject(arrayLike);
    var C = typeof this == 'function' ? this : Array;
    var aLen = arguments.length;
    var mapfn = aLen > 1 ? arguments[1] : undefined;
    var mapping = mapfn !== undefined;
    var index = 0;
    var iterFn = getIterFn(O);
    var length, result, step, iterator;
    if (mapping) mapfn = ctx(mapfn, aLen > 2 ? arguments[2] : undefined, 2);
    // if object isn't iterable or it's array with default iterator - use simple case
    if (iterFn != undefined && !(C == Array && isArrayIter(iterFn))) {
      for (iterator = iterFn.call(O), result = new C(); !(step = iterator.next()).done; index++) {
        createProperty(result, index, mapping ? call(iterator, mapfn, [step.value, index], true) : step.value);
      }
    } else {
      length = toLength(O.length);
      for (result = new C(length); length > index; index++) {
        createProperty(result, index, mapping ? mapfn(O[index], index) : O[index]);
      }
    }
    result.length = index;
    return result;
  }
});


/***/ }),
/* 226 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $export = __webpack_require__(0);
var createProperty = __webpack_require__(86);

// WebKit Array.of isn't generic
$export($export.S + $export.F * __webpack_require__(3)(function () {
  function F() { /* empty */ }
  return !(Array.of.call(F) instanceof F);
}), 'Array', {
  // 22.1.2.3 Array.of( ...items)
  of: function of(/* ...args */) {
    var index = 0;
    var aLen = arguments.length;
    var result = new (typeof this == 'function' ? this : Array)(aLen);
    while (aLen > index) createProperty(result, index, arguments[index++]);
    result.length = aLen;
    return result;
  }
});


/***/ }),
/* 227 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// 22.1.3.13 Array.prototype.join(separator)
var $export = __webpack_require__(0);
var toIObject = __webpack_require__(16);
var arrayJoin = [].join;

// fallback for not array-like strings
$export($export.P + $export.F * (__webpack_require__(51) != Object || !__webpack_require__(23)(arrayJoin)), 'Array', {
  join: function join(separator) {
    return arrayJoin.call(toIObject(this), separator === undefined ? ',' : separator);
  }
});


/***/ }),
/* 228 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $export = __webpack_require__(0);
var html = __webpack_require__(74);
var cof = __webpack_require__(21);
var toAbsoluteIndex = __webpack_require__(37);
var toLength = __webpack_require__(6);
var arraySlice = [].slice;

// fallback for not array-like ES3 strings and DOM objects
$export($export.P + $export.F * __webpack_require__(3)(function () {
  if (html) arraySlice.call(html);
}), 'Array', {
  slice: function slice(begin, end) {
    var len = toLength(this.length);
    var klass = cof(this);
    end = end === undefined ? len : end;
    if (klass == 'Array') return arraySlice.call(this, begin, end);
    var start = toAbsoluteIndex(begin, len);
    var upTo = toAbsoluteIndex(end, len);
    var size = toLength(upTo - start);
    var cloned = new Array(size);
    var i = 0;
    for (; i < size; i++) cloned[i] = klass == 'String'
      ? this.charAt(start + i)
      : this[start + i];
    return cloned;
  }
});


/***/ }),
/* 229 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $export = __webpack_require__(0);
var aFunction = __webpack_require__(11);
var toObject = __webpack_require__(10);
var fails = __webpack_require__(3);
var $sort = [].sort;
var test = [1, 2, 3];

$export($export.P + $export.F * (fails(function () {
  // IE8-
  test.sort(undefined);
}) || !fails(function () {
  // V8 bug
  test.sort(null);
  // Old WebKit
}) || !__webpack_require__(23)($sort)), 'Array', {
  // 22.1.3.25 Array.prototype.sort(comparefn)
  sort: function sort(comparefn) {
    return comparefn === undefined
      ? $sort.call(toObject(this))
      : $sort.call(toObject(this), aFunction(comparefn));
  }
});


/***/ }),
/* 230 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $export = __webpack_require__(0);
var $forEach = __webpack_require__(27)(0);
var STRICT = __webpack_require__(23)([].forEach, true);

$export($export.P + $export.F * !STRICT, 'Array', {
  // 22.1.3.10 / 15.4.4.18 Array.prototype.forEach(callbackfn [, thisArg])
  forEach: function forEach(callbackfn /* , thisArg */) {
    return $forEach(this, callbackfn, arguments[1]);
  }
});


/***/ }),
/* 231 */
/***/ (function(module, exports, __webpack_require__) {

var isObject = __webpack_require__(4);
var isArray = __webpack_require__(58);
var SPECIES = __webpack_require__(5)('species');

module.exports = function (original) {
  var C;
  if (isArray(original)) {
    C = original.constructor;
    // cross-realm fallback
    if (typeof C == 'function' && (C === Array || isArray(C.prototype))) C = undefined;
    if (isObject(C)) {
      C = C[SPECIES];
      if (C === null) C = undefined;
    }
  } return C === undefined ? Array : C;
};


/***/ }),
/* 232 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $export = __webpack_require__(0);
var $map = __webpack_require__(27)(1);

$export($export.P + $export.F * !__webpack_require__(23)([].map, true), 'Array', {
  // 22.1.3.15 / 15.4.4.19 Array.prototype.map(callbackfn [, thisArg])
  map: function map(callbackfn /* , thisArg */) {
    return $map(this, callbackfn, arguments[1]);
  }
});


/***/ }),
/* 233 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $export = __webpack_require__(0);
var $filter = __webpack_require__(27)(2);

$export($export.P + $export.F * !__webpack_require__(23)([].filter, true), 'Array', {
  // 22.1.3.7 / 15.4.4.20 Array.prototype.filter(callbackfn [, thisArg])
  filter: function filter(callbackfn /* , thisArg */) {
    return $filter(this, callbackfn, arguments[1]);
  }
});


/***/ }),
/* 234 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $export = __webpack_require__(0);
var $some = __webpack_require__(27)(3);

$export($export.P + $export.F * !__webpack_require__(23)([].some, true), 'Array', {
  // 22.1.3.23 / 15.4.4.17 Array.prototype.some(callbackfn [, thisArg])
  some: function some(callbackfn /* , thisArg */) {
    return $some(this, callbackfn, arguments[1]);
  }
});


/***/ }),
/* 235 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $export = __webpack_require__(0);
var $every = __webpack_require__(27)(4);

$export($export.P + $export.F * !__webpack_require__(23)([].every, true), 'Array', {
  // 22.1.3.5 / 15.4.4.16 Array.prototype.every(callbackfn [, thisArg])
  every: function every(callbackfn /* , thisArg */) {
    return $every(this, callbackfn, arguments[1]);
  }
});


/***/ }),
/* 236 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $export = __webpack_require__(0);
var $reduce = __webpack_require__(113);

$export($export.P + $export.F * !__webpack_require__(23)([].reduce, true), 'Array', {
  // 22.1.3.18 / 15.4.4.21 Array.prototype.reduce(callbackfn [, initialValue])
  reduce: function reduce(callbackfn /* , initialValue */) {
    return $reduce(this, callbackfn, arguments.length, arguments[1], false);
  }
});


/***/ }),
/* 237 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $export = __webpack_require__(0);
var $reduce = __webpack_require__(113);

$export($export.P + $export.F * !__webpack_require__(23)([].reduceRight, true), 'Array', {
  // 22.1.3.19 / 15.4.4.22 Array.prototype.reduceRight(callbackfn [, initialValue])
  reduceRight: function reduceRight(callbackfn /* , initialValue */) {
    return $reduce(this, callbackfn, arguments.length, arguments[1], true);
  }
});


/***/ }),
/* 238 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $export = __webpack_require__(0);
var $indexOf = __webpack_require__(56)(false);
var $native = [].indexOf;
var NEGATIVE_ZERO = !!$native && 1 / [1].indexOf(1, -0) < 0;

$export($export.P + $export.F * (NEGATIVE_ZERO || !__webpack_require__(23)($native)), 'Array', {
  // 22.1.3.11 / 15.4.4.14 Array.prototype.indexOf(searchElement [, fromIndex])
  indexOf: function indexOf(searchElement /* , fromIndex = 0 */) {
    return NEGATIVE_ZERO
      // convert -0 to +0
      ? $native.apply(this, arguments) || 0
      : $indexOf(this, searchElement, arguments[1]);
  }
});


/***/ }),
/* 239 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $export = __webpack_require__(0);
var toIObject = __webpack_require__(16);
var toInteger = __webpack_require__(22);
var toLength = __webpack_require__(6);
var $native = [].lastIndexOf;
var NEGATIVE_ZERO = !!$native && 1 / [1].lastIndexOf(1, -0) < 0;

$export($export.P + $export.F * (NEGATIVE_ZERO || !__webpack_require__(23)($native)), 'Array', {
  // 22.1.3.14 / 15.4.4.15 Array.prototype.lastIndexOf(searchElement [, fromIndex])
  lastIndexOf: function lastIndexOf(searchElement /* , fromIndex = @[*-1] */) {
    // convert -0 to +0
    if (NEGATIVE_ZERO) return $native.apply(this, arguments) || 0;
    var O = toIObject(this);
    var length = toLength(O.length);
    var index = length - 1;
    if (arguments.length > 1) index = Math.min(index, toInteger(arguments[1]));
    if (index < 0) index = length + index;
    for (;index >= 0; index--) if (index in O) if (O[index] === searchElement) return index || 0;
    return -1;
  }
});


/***/ }),
/* 240 */
/***/ (function(module, exports, __webpack_require__) {

// 22.1.3.3 Array.prototype.copyWithin(target, start, end = this.length)
var $export = __webpack_require__(0);

$export($export.P, 'Array', { copyWithin: __webpack_require__(114) });

__webpack_require__(33)('copyWithin');


/***/ }),
/* 241 */
/***/ (function(module, exports, __webpack_require__) {

// 22.1.3.6 Array.prototype.fill(value, start = 0, end = this.length)
var $export = __webpack_require__(0);

$export($export.P, 'Array', { fill: __webpack_require__(89) });

__webpack_require__(33)('fill');


/***/ }),
/* 242 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// 22.1.3.8 Array.prototype.find(predicate, thisArg = undefined)
var $export = __webpack_require__(0);
var $find = __webpack_require__(27)(5);
var KEY = 'find';
var forced = true;
// Shouldn't skip holes
if (KEY in []) Array(1)[KEY](function () { forced = false; });
$export($export.P + $export.F * forced, 'Array', {
  find: function find(callbackfn /* , that = undefined */) {
    return $find(this, callbackfn, arguments.length > 1 ? arguments[1] : undefined);
  }
});
__webpack_require__(33)(KEY);


/***/ }),
/* 243 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// 22.1.3.9 Array.prototype.findIndex(predicate, thisArg = undefined)
var $export = __webpack_require__(0);
var $find = __webpack_require__(27)(6);
var KEY = 'findIndex';
var forced = true;
// Shouldn't skip holes
if (KEY in []) Array(1)[KEY](function () { forced = false; });
$export($export.P + $export.F * forced, 'Array', {
  findIndex: function findIndex(callbackfn /* , that = undefined */) {
    return $find(this, callbackfn, arguments.length > 1 ? arguments[1] : undefined);
  }
});
__webpack_require__(33)(KEY);


/***/ }),
/* 244 */
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(40)('Array');


/***/ }),
/* 245 */
/***/ (function(module, exports, __webpack_require__) {

var global = __webpack_require__(2);
var inheritIfRequired = __webpack_require__(77);
var dP = __webpack_require__(8).f;
var gOPN = __webpack_require__(39).f;
var isRegExp = __webpack_require__(60);
var $flags = __webpack_require__(53);
var $RegExp = global.RegExp;
var Base = $RegExp;
var proto = $RegExp.prototype;
var re1 = /a/g;
var re2 = /a/g;
// "new" creates a new object, old webkit buggy here
var CORRECT_NEW = new $RegExp(re1) !== re1;

if (__webpack_require__(7) && (!CORRECT_NEW || __webpack_require__(3)(function () {
  re2[__webpack_require__(5)('match')] = false;
  // RegExp constructor can alter flags and IsRegExp works correct with @@match
  return $RegExp(re1) != re1 || $RegExp(re2) == re2 || $RegExp(re1, 'i') != '/a/i';
}))) {
  $RegExp = function RegExp(p, f) {
    var tiRE = this instanceof $RegExp;
    var piRE = isRegExp(p);
    var fiU = f === undefined;
    return !tiRE && piRE && p.constructor === $RegExp && fiU ? p
      : inheritIfRequired(CORRECT_NEW
        ? new Base(piRE && !fiU ? p.source : p, f)
        : Base((piRE = p instanceof $RegExp) ? p.source : p, piRE && fiU ? $flags.call(p) : f)
      , tiRE ? this : proto, $RegExp);
  };
  var proxy = function (key) {
    key in $RegExp || dP($RegExp, key, {
      configurable: true,
      get: function () { return Base[key]; },
      set: function (it) { Base[key] = it; }
    });
  };
  for (var keys = gOPN(Base), i = 0; keys.length > i;) proxy(keys[i++]);
  proto.constructor = $RegExp;
  $RegExp.prototype = proto;
  __webpack_require__(13)(global, 'RegExp', $RegExp);
}

__webpack_require__(40)('RegExp');


/***/ }),
/* 246 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

__webpack_require__(117);
var anObject = __webpack_require__(1);
var $flags = __webpack_require__(53);
var DESCRIPTORS = __webpack_require__(7);
var TO_STRING = 'toString';
var $toString = /./[TO_STRING];

var define = function (fn) {
  __webpack_require__(13)(RegExp.prototype, TO_STRING, fn, true);
};

// 21.2.5.14 RegExp.prototype.toString()
if (__webpack_require__(3)(function () { return $toString.call({ source: 'a', flags: 'b' }) != '/a/b'; })) {
  define(function toString() {
    var R = anObject(this);
    return '/'.concat(R.source, '/',
      'flags' in R ? R.flags : !DESCRIPTORS && R instanceof RegExp ? $flags.call(R) : undefined);
  });
// FF44- RegExp#toString has a wrong name
} else if ($toString.name != TO_STRING) {
  define(function toString() {
    return $toString.call(this);
  });
}


/***/ }),
/* 247 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var anObject = __webpack_require__(1);
var toLength = __webpack_require__(6);
var advanceStringIndex = __webpack_require__(92);
var regExpExec = __webpack_require__(62);

// @@match logic
__webpack_require__(63)('match', 1, function (defined, MATCH, $match, maybeCallNative) {
  return [
    // `String.prototype.match` method
    // https://tc39.github.io/ecma262/#sec-string.prototype.match
    function match(regexp) {
      var O = defined(this);
      var fn = regexp == undefined ? undefined : regexp[MATCH];
      return fn !== undefined ? fn.call(regexp, O) : new RegExp(regexp)[MATCH](String(O));
    },
    // `RegExp.prototype[@@match]` method
    // https://tc39.github.io/ecma262/#sec-regexp.prototype-@@match
    function (regexp) {
      var res = maybeCallNative($match, regexp, this);
      if (res.done) return res.value;
      var rx = anObject(regexp);
      var S = String(this);
      if (!rx.global) return regExpExec(rx, S);
      var fullUnicode = rx.unicode;
      rx.lastIndex = 0;
      var A = [];
      var n = 0;
      var result;
      while ((result = regExpExec(rx, S)) !== null) {
        var matchStr = String(result[0]);
        A[n] = matchStr;
        if (matchStr === '') rx.lastIndex = advanceStringIndex(S, toLength(rx.lastIndex), fullUnicode);
        n++;
      }
      return n === 0 ? null : A;
    }
  ];
});


/***/ }),
/* 248 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var anObject = __webpack_require__(1);
var toObject = __webpack_require__(10);
var toLength = __webpack_require__(6);
var toInteger = __webpack_require__(22);
var advanceStringIndex = __webpack_require__(92);
var regExpExec = __webpack_require__(62);
var max = Math.max;
var min = Math.min;
var floor = Math.floor;
var SUBSTITUTION_SYMBOLS = /\$([$&`']|\d\d?|<[^>]*>)/g;
var SUBSTITUTION_SYMBOLS_NO_NAMED = /\$([$&`']|\d\d?)/g;

var maybeToString = function (it) {
  return it === undefined ? it : String(it);
};

// @@replace logic
__webpack_require__(63)('replace', 2, function (defined, REPLACE, $replace, maybeCallNative) {
  return [
    // `String.prototype.replace` method
    // https://tc39.github.io/ecma262/#sec-string.prototype.replace
    function replace(searchValue, replaceValue) {
      var O = defined(this);
      var fn = searchValue == undefined ? undefined : searchValue[REPLACE];
      return fn !== undefined
        ? fn.call(searchValue, O, replaceValue)
        : $replace.call(String(O), searchValue, replaceValue);
    },
    // `RegExp.prototype[@@replace]` method
    // https://tc39.github.io/ecma262/#sec-regexp.prototype-@@replace
    function (regexp, replaceValue) {
      var res = maybeCallNative($replace, regexp, this, replaceValue);
      if (res.done) return res.value;

      var rx = anObject(regexp);
      var S = String(this);
      var functionalReplace = typeof replaceValue === 'function';
      if (!functionalReplace) replaceValue = String(replaceValue);
      var global = rx.global;
      if (global) {
        var fullUnicode = rx.unicode;
        rx.lastIndex = 0;
      }
      var results = [];
      while (true) {
        var result = regExpExec(rx, S);
        if (result === null) break;
        results.push(result);
        if (!global) break;
        var matchStr = String(result[0]);
        if (matchStr === '') rx.lastIndex = advanceStringIndex(S, toLength(rx.lastIndex), fullUnicode);
      }
      var accumulatedResult = '';
      var nextSourcePosition = 0;
      for (var i = 0; i < results.length; i++) {
        result = results[i];
        var matched = String(result[0]);
        var position = max(min(toInteger(result.index), S.length), 0);
        var captures = [];
        // NOTE: This is equivalent to
        //   captures = result.slice(1).map(maybeToString)
        // but for some reason `nativeSlice.call(result, 1, result.length)` (called in
        // the slice polyfill when slicing native arrays) "doesn't work" in safari 9 and
        // causes a crash (https://pastebin.com/N21QzeQA) when trying to debug it.
        for (var j = 1; j < result.length; j++) captures.push(maybeToString(result[j]));
        var namedCaptures = result.groups;
        if (functionalReplace) {
          var replacerArgs = [matched].concat(captures, position, S);
          if (namedCaptures !== undefined) replacerArgs.push(namedCaptures);
          var replacement = String(replaceValue.apply(undefined, replacerArgs));
        } else {
          replacement = getSubstitution(matched, S, position, captures, namedCaptures, replaceValue);
        }
        if (position >= nextSourcePosition) {
          accumulatedResult += S.slice(nextSourcePosition, position) + replacement;
          nextSourcePosition = position + matched.length;
        }
      }
      return accumulatedResult + S.slice(nextSourcePosition);
    }
  ];

    // https://tc39.github.io/ecma262/#sec-getsubstitution
  function getSubstitution(matched, str, position, captures, namedCaptures, replacement) {
    var tailPos = position + matched.length;
    var m = captures.length;
    var symbols = SUBSTITUTION_SYMBOLS_NO_NAMED;
    if (namedCaptures !== undefined) {
      namedCaptures = toObject(namedCaptures);
      symbols = SUBSTITUTION_SYMBOLS;
    }
    return $replace.call(replacement, symbols, function (match, ch) {
      var capture;
      switch (ch.charAt(0)) {
        case '$': return '$';
        case '&': return matched;
        case '`': return str.slice(0, position);
        case "'": return str.slice(tailPos);
        case '<':
          capture = namedCaptures[ch.slice(1, -1)];
          break;
        default: // \d\d?
          var n = +ch;
          if (n === 0) return match;
          if (n > m) {
            var f = floor(n / 10);
            if (f === 0) return match;
            if (f <= m) return captures[f - 1] === undefined ? ch.charAt(1) : captures[f - 1] + ch.charAt(1);
            return match;
          }
          capture = captures[n - 1];
      }
      return capture === undefined ? '' : capture;
    });
  }
});


/***/ }),
/* 249 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var anObject = __webpack_require__(1);
var sameValue = __webpack_require__(103);
var regExpExec = __webpack_require__(62);

// @@search logic
__webpack_require__(63)('search', 1, function (defined, SEARCH, $search, maybeCallNative) {
  return [
    // `String.prototype.search` method
    // https://tc39.github.io/ecma262/#sec-string.prototype.search
    function search(regexp) {
      var O = defined(this);
      var fn = regexp == undefined ? undefined : regexp[SEARCH];
      return fn !== undefined ? fn.call(regexp, O) : new RegExp(regexp)[SEARCH](String(O));
    },
    // `RegExp.prototype[@@search]` method
    // https://tc39.github.io/ecma262/#sec-regexp.prototype-@@search
    function (regexp) {
      var res = maybeCallNative($search, regexp, this);
      if (res.done) return res.value;
      var rx = anObject(regexp);
      var S = String(this);
      var previousLastIndex = rx.lastIndex;
      if (!sameValue(previousLastIndex, 0)) rx.lastIndex = 0;
      var result = regExpExec(rx, S);
      if (!sameValue(rx.lastIndex, previousLastIndex)) rx.lastIndex = previousLastIndex;
      return result === null ? -1 : result.index;
    }
  ];
});


/***/ }),
/* 250 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var isRegExp = __webpack_require__(60);
var anObject = __webpack_require__(1);
var speciesConstructor = __webpack_require__(54);
var advanceStringIndex = __webpack_require__(92);
var toLength = __webpack_require__(6);
var callRegExpExec = __webpack_require__(62);
var regexpExec = __webpack_require__(91);
var fails = __webpack_require__(3);
var $min = Math.min;
var $push = [].push;
var $SPLIT = 'split';
var LENGTH = 'length';
var LAST_INDEX = 'lastIndex';
var MAX_UINT32 = 0xffffffff;

// babel-minify transpiles RegExp('x', 'y') -> /x/y and it causes SyntaxError
var SUPPORTS_Y = !fails(function () { RegExp(MAX_UINT32, 'y'); });

// @@split logic
__webpack_require__(63)('split', 2, function (defined, SPLIT, $split, maybeCallNative) {
  var internalSplit;
  if (
    'abbc'[$SPLIT](/(b)*/)[1] == 'c' ||
    'test'[$SPLIT](/(?:)/, -1)[LENGTH] != 4 ||
    'ab'[$SPLIT](/(?:ab)*/)[LENGTH] != 2 ||
    '.'[$SPLIT](/(.?)(.?)/)[LENGTH] != 4 ||
    '.'[$SPLIT](/()()/)[LENGTH] > 1 ||
    ''[$SPLIT](/.?/)[LENGTH]
  ) {
    // based on es5-shim implementation, need to rework it
    internalSplit = function (separator, limit) {
      var string = String(this);
      if (separator === undefined && limit === 0) return [];
      // If `separator` is not a regex, use native split
      if (!isRegExp(separator)) return $split.call(string, separator, limit);
      var output = [];
      var flags = (separator.ignoreCase ? 'i' : '') +
                  (separator.multiline ? 'm' : '') +
                  (separator.unicode ? 'u' : '') +
                  (separator.sticky ? 'y' : '');
      var lastLastIndex = 0;
      var splitLimit = limit === undefined ? MAX_UINT32 : limit >>> 0;
      // Make `global` and avoid `lastIndex` issues by working with a copy
      var separatorCopy = new RegExp(separator.source, flags + 'g');
      var match, lastIndex, lastLength;
      while (match = regexpExec.call(separatorCopy, string)) {
        lastIndex = separatorCopy[LAST_INDEX];
        if (lastIndex > lastLastIndex) {
          output.push(string.slice(lastLastIndex, match.index));
          if (match[LENGTH] > 1 && match.index < string[LENGTH]) $push.apply(output, match.slice(1));
          lastLength = match[0][LENGTH];
          lastLastIndex = lastIndex;
          if (output[LENGTH] >= splitLimit) break;
        }
        if (separatorCopy[LAST_INDEX] === match.index) separatorCopy[LAST_INDEX]++; // Avoid an infinite loop
      }
      if (lastLastIndex === string[LENGTH]) {
        if (lastLength || !separatorCopy.test('')) output.push('');
      } else output.push(string.slice(lastLastIndex));
      return output[LENGTH] > splitLimit ? output.slice(0, splitLimit) : output;
    };
  // Chakra, V8
  } else if ('0'[$SPLIT](undefined, 0)[LENGTH]) {
    internalSplit = function (separator, limit) {
      return separator === undefined && limit === 0 ? [] : $split.call(this, separator, limit);
    };
  } else {
    internalSplit = $split;
  }

  return [
    // `String.prototype.split` method
    // https://tc39.github.io/ecma262/#sec-string.prototype.split
    function split(separator, limit) {
      var O = defined(this);
      var splitter = separator == undefined ? undefined : separator[SPLIT];
      return splitter !== undefined
        ? splitter.call(separator, O, limit)
        : internalSplit.call(String(O), separator, limit);
    },
    // `RegExp.prototype[@@split]` method
    // https://tc39.github.io/ecma262/#sec-regexp.prototype-@@split
    //
    // NOTE: This cannot be properly polyfilled in engines that don't support
    // the 'y' flag.
    function (regexp, limit) {
      var res = maybeCallNative(internalSplit, regexp, this, limit, internalSplit !== $split);
      if (res.done) return res.value;

      var rx = anObject(regexp);
      var S = String(this);
      var C = speciesConstructor(rx, RegExp);

      var unicodeMatching = rx.unicode;
      var flags = (rx.ignoreCase ? 'i' : '') +
                  (rx.multiline ? 'm' : '') +
                  (rx.unicode ? 'u' : '') +
                  (SUPPORTS_Y ? 'y' : 'g');

      // ^(? + rx + ) is needed, in combination with some S slicing, to
      // simulate the 'y' flag.
      var splitter = new C(SUPPORTS_Y ? rx : '^(?:' + rx.source + ')', flags);
      var lim = limit === undefined ? MAX_UINT32 : limit >>> 0;
      if (lim === 0) return [];
      if (S.length === 0) return callRegExpExec(splitter, S) === null ? [S] : [];
      var p = 0;
      var q = 0;
      var A = [];
      while (q < S.length) {
        splitter.lastIndex = SUPPORTS_Y ? q : 0;
        var z = callRegExpExec(splitter, SUPPORTS_Y ? S : S.slice(q));
        var e;
        if (
          z === null ||
          (e = $min(toLength(splitter.lastIndex + (SUPPORTS_Y ? 0 : q)), S.length)) === p
        ) {
          q = advanceStringIndex(S, q, unicodeMatching);
        } else {
          A.push(S.slice(p, q));
          if (A.length === lim) return A;
          for (var i = 1; i <= z.length - 1; i++) {
            A.push(z[i]);
            if (A.length === lim) return A;
          }
          q = p = e;
        }
      }
      A.push(S.slice(p));
      return A;
    }
  ];
});


/***/ }),
/* 251 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var LIBRARY = __webpack_require__(31);
var global = __webpack_require__(2);
var ctx = __webpack_require__(20);
var classof = __webpack_require__(47);
var $export = __webpack_require__(0);
var isObject = __webpack_require__(4);
var aFunction = __webpack_require__(11);
var anInstance = __webpack_require__(41);
var forOf = __webpack_require__(42);
var speciesConstructor = __webpack_require__(54);
var task = __webpack_require__(93).set;
var microtask = __webpack_require__(94)();
var newPromiseCapabilityModule = __webpack_require__(95);
var perform = __webpack_require__(118);
var userAgent = __webpack_require__(64);
var promiseResolve = __webpack_require__(119);
var PROMISE = 'Promise';
var TypeError = global.TypeError;
var process = global.process;
var versions = process && process.versions;
var v8 = versions && versions.v8 || '';
var $Promise = global[PROMISE];
var isNode = classof(process) == 'process';
var empty = function () { /* empty */ };
var Internal, newGenericPromiseCapability, OwnPromiseCapability, Wrapper;
var newPromiseCapability = newGenericPromiseCapability = newPromiseCapabilityModule.f;

var USE_NATIVE = !!function () {
  try {
    // correct subclassing with @@species support
    var promise = $Promise.resolve(1);
    var FakePromise = (promise.constructor = {})[__webpack_require__(5)('species')] = function (exec) {
      exec(empty, empty);
    };
    // unhandled rejections tracking support, NodeJS Promise without it fails @@species test
    return (isNode || typeof PromiseRejectionEvent == 'function')
      && promise.then(empty) instanceof FakePromise
      // v8 6.6 (Node 10 and Chrome 66) have a bug with resolving custom thenables
      // https://bugs.chromium.org/p/chromium/issues/detail?id=830565
      // we can't detect it synchronously, so just check versions
      && v8.indexOf('6.6') !== 0
      && userAgent.indexOf('Chrome/66') === -1;
  } catch (e) { /* empty */ }
}();

// helpers
var isThenable = function (it) {
  var then;
  return isObject(it) && typeof (then = it.then) == 'function' ? then : false;
};
var notify = function (promise, isReject) {
  if (promise._n) return;
  promise._n = true;
  var chain = promise._c;
  microtask(function () {
    var value = promise._v;
    var ok = promise._s == 1;
    var i = 0;
    var run = function (reaction) {
      var handler = ok ? reaction.ok : reaction.fail;
      var resolve = reaction.resolve;
      var reject = reaction.reject;
      var domain = reaction.domain;
      var result, then, exited;
      try {
        if (handler) {
          if (!ok) {
            if (promise._h == 2) onHandleUnhandled(promise);
            promise._h = 1;
          }
          if (handler === true) result = value;
          else {
            if (domain) domain.enter();
            result = handler(value); // may throw
            if (domain) {
              domain.exit();
              exited = true;
            }
          }
          if (result === reaction.promise) {
            reject(TypeError('Promise-chain cycle'));
          } else if (then = isThenable(result)) {
            then.call(result, resolve, reject);
          } else resolve(result);
        } else reject(value);
      } catch (e) {
        if (domain && !exited) domain.exit();
        reject(e);
      }
    };
    while (chain.length > i) run(chain[i++]); // variable length - can't use forEach
    promise._c = [];
    promise._n = false;
    if (isReject && !promise._h) onUnhandled(promise);
  });
};
var onUnhandled = function (promise) {
  task.call(global, function () {
    var value = promise._v;
    var unhandled = isUnhandled(promise);
    var result, handler, console;
    if (unhandled) {
      result = perform(function () {
        if (isNode) {
          process.emit('unhandledRejection', value, promise);
        } else if (handler = global.onunhandledrejection) {
          handler({ promise: promise, reason: value });
        } else if ((console = global.console) && console.error) {
          console.error('Unhandled promise rejection', value);
        }
      });
      // Browsers should not trigger `rejectionHandled` event if it was handled here, NodeJS - should
      promise._h = isNode || isUnhandled(promise) ? 2 : 1;
    } promise._a = undefined;
    if (unhandled && result.e) throw result.v;
  });
};
var isUnhandled = function (promise) {
  return promise._h !== 1 && (promise._a || promise._c).length === 0;
};
var onHandleUnhandled = function (promise) {
  task.call(global, function () {
    var handler;
    if (isNode) {
      process.emit('rejectionHandled', promise);
    } else if (handler = global.onrejectionhandled) {
      handler({ promise: promise, reason: promise._v });
    }
  });
};
var $reject = function (value) {
  var promise = this;
  if (promise._d) return;
  promise._d = true;
  promise = promise._w || promise; // unwrap
  promise._v = value;
  promise._s = 2;
  if (!promise._a) promise._a = promise._c.slice();
  notify(promise, true);
};
var $resolve = function (value) {
  var promise = this;
  var then;
  if (promise._d) return;
  promise._d = true;
  promise = promise._w || promise; // unwrap
  try {
    if (promise === value) throw TypeError("Promise can't be resolved itself");
    if (then = isThenable(value)) {
      microtask(function () {
        var wrapper = { _w: promise, _d: false }; // wrap
        try {
          then.call(value, ctx($resolve, wrapper, 1), ctx($reject, wrapper, 1));
        } catch (e) {
          $reject.call(wrapper, e);
        }
      });
    } else {
      promise._v = value;
      promise._s = 1;
      notify(promise, false);
    }
  } catch (e) {
    $reject.call({ _w: promise, _d: false }, e); // wrap
  }
};

// constructor polyfill
if (!USE_NATIVE) {
  // 25.4.3.1 Promise(executor)
  $Promise = function Promise(executor) {
    anInstance(this, $Promise, PROMISE, '_h');
    aFunction(executor);
    Internal.call(this);
    try {
      executor(ctx($resolve, this, 1), ctx($reject, this, 1));
    } catch (err) {
      $reject.call(this, err);
    }
  };
  // eslint-disable-next-line no-unused-vars
  Internal = function Promise(executor) {
    this._c = [];             // <- awaiting reactions
    this._a = undefined;      // <- checked in isUnhandled reactions
    this._s = 0;              // <- state
    this._d = false;          // <- done
    this._v = undefined;      // <- value
    this._h = 0;              // <- rejection state, 0 - default, 1 - handled, 2 - unhandled
    this._n = false;          // <- notify
  };
  Internal.prototype = __webpack_require__(43)($Promise.prototype, {
    // 25.4.5.3 Promise.prototype.then(onFulfilled, onRejected)
    then: function then(onFulfilled, onRejected) {
      var reaction = newPromiseCapability(speciesConstructor(this, $Promise));
      reaction.ok = typeof onFulfilled == 'function' ? onFulfilled : true;
      reaction.fail = typeof onRejected == 'function' && onRejected;
      reaction.domain = isNode ? process.domain : undefined;
      this._c.push(reaction);
      if (this._a) this._a.push(reaction);
      if (this._s) notify(this, false);
      return reaction.promise;
    },
    // 25.4.5.1 Promise.prototype.catch(onRejected)
    'catch': function (onRejected) {
      return this.then(undefined, onRejected);
    }
  });
  OwnPromiseCapability = function () {
    var promise = new Internal();
    this.promise = promise;
    this.resolve = ctx($resolve, promise, 1);
    this.reject = ctx($reject, promise, 1);
  };
  newPromiseCapabilityModule.f = newPromiseCapability = function (C) {
    return C === $Promise || C === Wrapper
      ? new OwnPromiseCapability(C)
      : newGenericPromiseCapability(C);
  };
}

$export($export.G + $export.W + $export.F * !USE_NATIVE, { Promise: $Promise });
__webpack_require__(46)($Promise, PROMISE);
__webpack_require__(40)(PROMISE);
Wrapper = __webpack_require__(19)[PROMISE];

// statics
$export($export.S + $export.F * !USE_NATIVE, PROMISE, {
  // 25.4.4.5 Promise.reject(r)
  reject: function reject(r) {
    var capability = newPromiseCapability(this);
    var $$reject = capability.reject;
    $$reject(r);
    return capability.promise;
  }
});
$export($export.S + $export.F * (LIBRARY || !USE_NATIVE), PROMISE, {
  // 25.4.4.6 Promise.resolve(x)
  resolve: function resolve(x) {
    return promiseResolve(LIBRARY && this === Wrapper ? $Promise : this, x);
  }
});
$export($export.S + $export.F * !(USE_NATIVE && __webpack_require__(61)(function (iter) {
  $Promise.all(iter)['catch'](empty);
})), PROMISE, {
  // 25.4.4.1 Promise.all(iterable)
  all: function all(iterable) {
    var C = this;
    var capability = newPromiseCapability(C);
    var resolve = capability.resolve;
    var reject = capability.reject;
    var result = perform(function () {
      var values = [];
      var index = 0;
      var remaining = 1;
      forOf(iterable, false, function (promise) {
        var $index = index++;
        var alreadyCalled = false;
        values.push(undefined);
        remaining++;
        C.resolve(promise).then(function (value) {
          if (alreadyCalled) return;
          alreadyCalled = true;
          values[$index] = value;
          --remaining || resolve(values);
        }, reject);
      });
      --remaining || resolve(values);
    });
    if (result.e) reject(result.v);
    return capability.promise;
  },
  // 25.4.4.4 Promise.race(iterable)
  race: function race(iterable) {
    var C = this;
    var capability = newPromiseCapability(C);
    var reject = capability.reject;
    var result = perform(function () {
      forOf(iterable, false, function (promise) {
        C.resolve(promise).then(capability.resolve, reject);
      });
    });
    if (result.e) reject(result.v);
    return capability.promise;
  }
});


/***/ }),
/* 252 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var weak = __webpack_require__(124);
var validate = __webpack_require__(44);
var WEAK_SET = 'WeakSet';

// 23.4 WeakSet Objects
__webpack_require__(65)(WEAK_SET, function (get) {
  return function WeakSet() { return get(this, arguments.length > 0 ? arguments[0] : undefined); };
}, {
  // 23.4.3.1 WeakSet.prototype.add(value)
  add: function add(value) {
    return weak.def(validate(this, WEAK_SET), value, true);
  }
}, weak, false, true);


/***/ }),
/* 253 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $export = __webpack_require__(0);
var $typed = __webpack_require__(66);
var buffer = __webpack_require__(96);
var anObject = __webpack_require__(1);
var toAbsoluteIndex = __webpack_require__(37);
var toLength = __webpack_require__(6);
var isObject = __webpack_require__(4);
var ArrayBuffer = __webpack_require__(2).ArrayBuffer;
var speciesConstructor = __webpack_require__(54);
var $ArrayBuffer = buffer.ArrayBuffer;
var $DataView = buffer.DataView;
var $isView = $typed.ABV && ArrayBuffer.isView;
var $slice = $ArrayBuffer.prototype.slice;
var VIEW = $typed.VIEW;
var ARRAY_BUFFER = 'ArrayBuffer';

$export($export.G + $export.W + $export.F * (ArrayBuffer !== $ArrayBuffer), { ArrayBuffer: $ArrayBuffer });

$export($export.S + $export.F * !$typed.CONSTR, ARRAY_BUFFER, {
  // 24.1.3.1 ArrayBuffer.isView(arg)
  isView: function isView(it) {
    return $isView && $isView(it) || isObject(it) && VIEW in it;
  }
});

$export($export.P + $export.U + $export.F * __webpack_require__(3)(function () {
  return !new $ArrayBuffer(2).slice(1, undefined).byteLength;
}), ARRAY_BUFFER, {
  // 24.1.4.3 ArrayBuffer.prototype.slice(start, end)
  slice: function slice(start, end) {
    if ($slice !== undefined && end === undefined) return $slice.call(anObject(this), start); // FF fix
    var len = anObject(this).byteLength;
    var first = toAbsoluteIndex(start, len);
    var fin = toAbsoluteIndex(end === undefined ? len : end, len);
    var result = new (speciesConstructor(this, $ArrayBuffer))(toLength(fin - first));
    var viewS = new $DataView(this);
    var viewT = new $DataView(result);
    var index = 0;
    while (first < fin) {
      viewT.setUint8(index++, viewS.getUint8(first++));
    } return result;
  }
});

__webpack_require__(40)(ARRAY_BUFFER);


/***/ }),
/* 254 */
/***/ (function(module, exports, __webpack_require__) {

var $export = __webpack_require__(0);
$export($export.G + $export.W + $export.F * !__webpack_require__(66).ABV, {
  DataView: __webpack_require__(96).DataView
});


/***/ }),
/* 255 */
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(29)('Int8', 1, function (init) {
  return function Int8Array(data, byteOffset, length) {
    return init(this, data, byteOffset, length);
  };
});


/***/ }),
/* 256 */
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(29)('Uint8', 1, function (init) {
  return function Uint8Array(data, byteOffset, length) {
    return init(this, data, byteOffset, length);
  };
});


/***/ }),
/* 257 */
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(29)('Uint8', 1, function (init) {
  return function Uint8ClampedArray(data, byteOffset, length) {
    return init(this, data, byteOffset, length);
  };
}, true);


/***/ }),
/* 258 */
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(29)('Int16', 2, function (init) {
  return function Int16Array(data, byteOffset, length) {
    return init(this, data, byteOffset, length);
  };
});


/***/ }),
/* 259 */
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(29)('Uint16', 2, function (init) {
  return function Uint16Array(data, byteOffset, length) {
    return init(this, data, byteOffset, length);
  };
});


/***/ }),
/* 260 */
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(29)('Int32', 4, function (init) {
  return function Int32Array(data, byteOffset, length) {
    return init(this, data, byteOffset, length);
  };
});


/***/ }),
/* 261 */
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(29)('Uint32', 4, function (init) {
  return function Uint32Array(data, byteOffset, length) {
    return init(this, data, byteOffset, length);
  };
});


/***/ }),
/* 262 */
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(29)('Float32', 4, function (init) {
  return function Float32Array(data, byteOffset, length) {
    return init(this, data, byteOffset, length);
  };
});


/***/ }),
/* 263 */
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(29)('Float64', 8, function (init) {
  return function Float64Array(data, byteOffset, length) {
    return init(this, data, byteOffset, length);
  };
});


/***/ }),
/* 264 */
/***/ (function(module, exports, __webpack_require__) {

// 26.1.1 Reflect.apply(target, thisArgument, argumentsList)
var $export = __webpack_require__(0);
var aFunction = __webpack_require__(11);
var anObject = __webpack_require__(1);
var rApply = (__webpack_require__(2).Reflect || {}).apply;
var fApply = Function.apply;
// MS Edge argumentsList argument is optional
$export($export.S + $export.F * !__webpack_require__(3)(function () {
  rApply(function () { /* empty */ });
}), 'Reflect', {
  apply: function apply(target, thisArgument, argumentsList) {
    var T = aFunction(target);
    var L = anObject(argumentsList);
    return rApply ? rApply(T, thisArgument, L) : fApply.call(T, thisArgument, L);
  }
});


/***/ }),
/* 265 */
/***/ (function(module, exports, __webpack_require__) {

// 26.1.2 Reflect.construct(target, argumentsList [, newTarget])
var $export = __webpack_require__(0);
var create = __webpack_require__(38);
var aFunction = __webpack_require__(11);
var anObject = __webpack_require__(1);
var isObject = __webpack_require__(4);
var fails = __webpack_require__(3);
var bind = __webpack_require__(104);
var rConstruct = (__webpack_require__(2).Reflect || {}).construct;

// MS Edge supports only 2 arguments and argumentsList argument is optional
// FF Nightly sets third argument as `new.target`, but does not create `this` from it
var NEW_TARGET_BUG = fails(function () {
  function F() { /* empty */ }
  return !(rConstruct(function () { /* empty */ }, [], F) instanceof F);
});
var ARGS_BUG = !fails(function () {
  rConstruct(function () { /* empty */ });
});

$export($export.S + $export.F * (NEW_TARGET_BUG || ARGS_BUG), 'Reflect', {
  construct: function construct(Target, args /* , newTarget */) {
    aFunction(Target);
    anObject(args);
    var newTarget = arguments.length < 3 ? Target : aFunction(arguments[2]);
    if (ARGS_BUG && !NEW_TARGET_BUG) return rConstruct(Target, args, newTarget);
    if (Target == newTarget) {
      // w/o altered newTarget, optimization for 0-4 arguments
      switch (args.length) {
        case 0: return new Target();
        case 1: return new Target(args[0]);
        case 2: return new Target(args[0], args[1]);
        case 3: return new Target(args[0], args[1], args[2]);
        case 4: return new Target(args[0], args[1], args[2], args[3]);
      }
      // w/o altered newTarget, lot of arguments case
      var $args = [null];
      $args.push.apply($args, args);
      return new (bind.apply(Target, $args))();
    }
    // with altered newTarget, not support built-in constructors
    var proto = newTarget.prototype;
    var instance = create(isObject(proto) ? proto : Object.prototype);
    var result = Function.apply.call(Target, instance, args);
    return isObject(result) ? result : instance;
  }
});


/***/ }),
/* 266 */
/***/ (function(module, exports, __webpack_require__) {

// 26.1.3 Reflect.defineProperty(target, propertyKey, attributes)
var dP = __webpack_require__(8);
var $export = __webpack_require__(0);
var anObject = __webpack_require__(1);
var toPrimitive = __webpack_require__(24);

// MS Edge has broken Reflect.defineProperty - throwing instead of returning false
$export($export.S + $export.F * __webpack_require__(3)(function () {
  // eslint-disable-next-line no-undef
  Reflect.defineProperty(dP.f({}, 1, { value: 1 }), 1, { value: 2 });
}), 'Reflect', {
  defineProperty: function defineProperty(target, propertyKey, attributes) {
    anObject(target);
    propertyKey = toPrimitive(propertyKey, true);
    anObject(attributes);
    try {
      dP.f(target, propertyKey, attributes);
      return true;
    } catch (e) {
      return false;
    }
  }
});


/***/ }),
/* 267 */
/***/ (function(module, exports, __webpack_require__) {

// 26.1.4 Reflect.deleteProperty(target, propertyKey)
var $export = __webpack_require__(0);
var gOPD = __webpack_require__(17).f;
var anObject = __webpack_require__(1);

$export($export.S, 'Reflect', {
  deleteProperty: function deleteProperty(target, propertyKey) {
    var desc = gOPD(anObject(target), propertyKey);
    return desc && !desc.configurable ? false : delete target[propertyKey];
  }
});


/***/ }),
/* 268 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// 26.1.5 Reflect.enumerate(target)
var $export = __webpack_require__(0);
var anObject = __webpack_require__(1);
var Enumerate = function (iterated) {
  this._t = anObject(iterated); // target
  this._i = 0;                  // next index
  var keys = this._k = [];      // keys
  var key;
  for (key in iterated) keys.push(key);
};
__webpack_require__(82)(Enumerate, 'Object', function () {
  var that = this;
  var keys = that._k;
  var key;
  do {
    if (that._i >= keys.length) return { value: undefined, done: true };
  } while (!((key = keys[that._i++]) in that._t));
  return { value: key, done: false };
});

$export($export.S, 'Reflect', {
  enumerate: function enumerate(target) {
    return new Enumerate(target);
  }
});


/***/ }),
/* 269 */
/***/ (function(module, exports, __webpack_require__) {

// 26.1.6 Reflect.get(target, propertyKey [, receiver])
var gOPD = __webpack_require__(17);
var getPrototypeOf = __webpack_require__(18);
var has = __webpack_require__(15);
var $export = __webpack_require__(0);
var isObject = __webpack_require__(4);
var anObject = __webpack_require__(1);

function get(target, propertyKey /* , receiver */) {
  var receiver = arguments.length < 3 ? target : arguments[2];
  var desc, proto;
  if (anObject(target) === receiver) return target[propertyKey];
  if (desc = gOPD.f(target, propertyKey)) return has(desc, 'value')
    ? desc.value
    : desc.get !== undefined
      ? desc.get.call(receiver)
      : undefined;
  if (isObject(proto = getPrototypeOf(target))) return get(proto, propertyKey, receiver);
}

$export($export.S, 'Reflect', { get: get });


/***/ }),
/* 270 */
/***/ (function(module, exports, __webpack_require__) {

// 26.1.7 Reflect.getOwnPropertyDescriptor(target, propertyKey)
var gOPD = __webpack_require__(17);
var $export = __webpack_require__(0);
var anObject = __webpack_require__(1);

$export($export.S, 'Reflect', {
  getOwnPropertyDescriptor: function getOwnPropertyDescriptor(target, propertyKey) {
    return gOPD.f(anObject(target), propertyKey);
  }
});


/***/ }),
/* 271 */
/***/ (function(module, exports, __webpack_require__) {

// 26.1.8 Reflect.getPrototypeOf(target)
var $export = __webpack_require__(0);
var getProto = __webpack_require__(18);
var anObject = __webpack_require__(1);

$export($export.S, 'Reflect', {
  getPrototypeOf: function getPrototypeOf(target) {
    return getProto(anObject(target));
  }
});


/***/ }),
/* 272 */
/***/ (function(module, exports, __webpack_require__) {

// 26.1.9 Reflect.has(target, propertyKey)
var $export = __webpack_require__(0);

$export($export.S, 'Reflect', {
  has: function has(target, propertyKey) {
    return propertyKey in target;
  }
});


/***/ }),
/* 273 */
/***/ (function(module, exports, __webpack_require__) {

// 26.1.10 Reflect.isExtensible(target)
var $export = __webpack_require__(0);
var anObject = __webpack_require__(1);
var $isExtensible = Object.isExtensible;

$export($export.S, 'Reflect', {
  isExtensible: function isExtensible(target) {
    anObject(target);
    return $isExtensible ? $isExtensible(target) : true;
  }
});


/***/ }),
/* 274 */
/***/ (function(module, exports, __webpack_require__) {

// 26.1.11 Reflect.ownKeys(target)
var $export = __webpack_require__(0);

$export($export.S, 'Reflect', { ownKeys: __webpack_require__(126) });


/***/ }),
/* 275 */
/***/ (function(module, exports, __webpack_require__) {

// 26.1.12 Reflect.preventExtensions(target)
var $export = __webpack_require__(0);
var anObject = __webpack_require__(1);
var $preventExtensions = Object.preventExtensions;

$export($export.S, 'Reflect', {
  preventExtensions: function preventExtensions(target) {
    anObject(target);
    try {
      if ($preventExtensions) $preventExtensions(target);
      return true;
    } catch (e) {
      return false;
    }
  }
});


/***/ }),
/* 276 */
/***/ (function(module, exports, __webpack_require__) {

// 26.1.13 Reflect.set(target, propertyKey, V [, receiver])
var dP = __webpack_require__(8);
var gOPD = __webpack_require__(17);
var getPrototypeOf = __webpack_require__(18);
var has = __webpack_require__(15);
var $export = __webpack_require__(0);
var createDesc = __webpack_require__(34);
var anObject = __webpack_require__(1);
var isObject = __webpack_require__(4);

function set(target, propertyKey, V /* , receiver */) {
  var receiver = arguments.length < 4 ? target : arguments[3];
  var ownDesc = gOPD.f(anObject(target), propertyKey);
  var existingDescriptor, proto;
  if (!ownDesc) {
    if (isObject(proto = getPrototypeOf(target))) {
      return set(proto, propertyKey, V, receiver);
    }
    ownDesc = createDesc(0);
  }
  if (has(ownDesc, 'value')) {
    if (ownDesc.writable === false || !isObject(receiver)) return false;
    if (existingDescriptor = gOPD.f(receiver, propertyKey)) {
      if (existingDescriptor.get || existingDescriptor.set || existingDescriptor.writable === false) return false;
      existingDescriptor.value = V;
      dP.f(receiver, propertyKey, existingDescriptor);
    } else dP.f(receiver, propertyKey, createDesc(0, V));
    return true;
  }
  return ownDesc.set === undefined ? false : (ownDesc.set.call(receiver, V), true);
}

$export($export.S, 'Reflect', { set: set });


/***/ }),
/* 277 */
/***/ (function(module, exports, __webpack_require__) {

// 26.1.14 Reflect.setPrototypeOf(target, proto)
var $export = __webpack_require__(0);
var setProto = __webpack_require__(75);

if (setProto) $export($export.S, 'Reflect', {
  setPrototypeOf: function setPrototypeOf(target, proto) {
    setProto.check(target, proto);
    try {
      setProto.set(target, proto);
      return true;
    } catch (e) {
      return false;
    }
  }
});


/***/ }),
/* 278 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// https://github.com/tc39/Array.prototype.includes
var $export = __webpack_require__(0);
var $includes = __webpack_require__(56)(true);

$export($export.P, 'Array', {
  includes: function includes(el /* , fromIndex = 0 */) {
    return $includes(this, el, arguments.length > 1 ? arguments[1] : undefined);
  }
});

__webpack_require__(33)('includes');


/***/ }),
/* 279 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// https://tc39.github.io/proposal-flatMap/#sec-Array.prototype.flatMap
var $export = __webpack_require__(0);
var flattenIntoArray = __webpack_require__(127);
var toObject = __webpack_require__(10);
var toLength = __webpack_require__(6);
var aFunction = __webpack_require__(11);
var arraySpeciesCreate = __webpack_require__(88);

$export($export.P, 'Array', {
  flatMap: function flatMap(callbackfn /* , thisArg */) {
    var O = toObject(this);
    var sourceLen, A;
    aFunction(callbackfn);
    sourceLen = toLength(O.length);
    A = arraySpeciesCreate(O, 0);
    flattenIntoArray(A, O, O, sourceLen, 0, 1, callbackfn, arguments[1]);
    return A;
  }
});

__webpack_require__(33)('flatMap');


/***/ }),
/* 280 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// https://tc39.github.io/proposal-flatMap/#sec-Array.prototype.flatten
var $export = __webpack_require__(0);
var flattenIntoArray = __webpack_require__(127);
var toObject = __webpack_require__(10);
var toLength = __webpack_require__(6);
var toInteger = __webpack_require__(22);
var arraySpeciesCreate = __webpack_require__(88);

$export($export.P, 'Array', {
  flatten: function flatten(/* depthArg = 1 */) {
    var depthArg = arguments[0];
    var O = toObject(this);
    var sourceLen = toLength(O.length);
    var A = arraySpeciesCreate(O, 0);
    flattenIntoArray(A, O, O, sourceLen, 0, depthArg === undefined ? 1 : toInteger(depthArg));
    return A;
  }
});

__webpack_require__(33)('flatten');


/***/ }),
/* 281 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// https://github.com/mathiasbynens/String.prototype.at
var $export = __webpack_require__(0);
var $at = __webpack_require__(59)(true);

$export($export.P, 'String', {
  at: function at(pos) {
    return $at(this, pos);
  }
});


/***/ }),
/* 282 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// https://github.com/tc39/proposal-string-pad-start-end
var $export = __webpack_require__(0);
var $pad = __webpack_require__(128);
var userAgent = __webpack_require__(64);

// https://github.com/zloirock/core-js/issues/280
var WEBKIT_BUG = /Version\/10\.\d+(\.\d+)?( Mobile\/\w+)? Safari\//.test(userAgent);

$export($export.P + $export.F * WEBKIT_BUG, 'String', {
  padStart: function padStart(maxLength /* , fillString = ' ' */) {
    return $pad(this, maxLength, arguments.length > 1 ? arguments[1] : undefined, true);
  }
});


/***/ }),
/* 283 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// https://github.com/tc39/proposal-string-pad-start-end
var $export = __webpack_require__(0);
var $pad = __webpack_require__(128);
var userAgent = __webpack_require__(64);

// https://github.com/zloirock/core-js/issues/280
var WEBKIT_BUG = /Version\/10\.\d+(\.\d+)?( Mobile\/\w+)? Safari\//.test(userAgent);

$export($export.P + $export.F * WEBKIT_BUG, 'String', {
  padEnd: function padEnd(maxLength /* , fillString = ' ' */) {
    return $pad(this, maxLength, arguments.length > 1 ? arguments[1] : undefined, false);
  }
});


/***/ }),
/* 284 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// https://github.com/sebmarkbage/ecmascript-string-left-right-trim
__webpack_require__(48)('trimLeft', function ($trim) {
  return function trimLeft() {
    return $trim(this, 1);
  };
}, 'trimStart');


/***/ }),
/* 285 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// https://github.com/sebmarkbage/ecmascript-string-left-right-trim
__webpack_require__(48)('trimRight', function ($trim) {
  return function trimRight() {
    return $trim(this, 2);
  };
}, 'trimEnd');


/***/ }),
/* 286 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// https://tc39.github.io/String.prototype.matchAll/
var $export = __webpack_require__(0);
var defined = __webpack_require__(25);
var toLength = __webpack_require__(6);
var isRegExp = __webpack_require__(60);
var getFlags = __webpack_require__(53);
var RegExpProto = RegExp.prototype;

var $RegExpStringIterator = function (regexp, string) {
  this._r = regexp;
  this._s = string;
};

__webpack_require__(82)($RegExpStringIterator, 'RegExp String', function next() {
  var match = this._r.exec(this._s);
  return { value: match, done: match === null };
});

$export($export.P, 'String', {
  matchAll: function matchAll(regexp) {
    defined(this);
    if (!isRegExp(regexp)) throw TypeError(regexp + ' is not a regexp!');
    var S = String(this);
    var flags = 'flags' in RegExpProto ? String(regexp.flags) : getFlags.call(regexp);
    var rx = new RegExp(regexp.source, ~flags.indexOf('g') ? flags : 'g' + flags);
    rx.lastIndex = toLength(regexp.lastIndex);
    return new $RegExpStringIterator(rx, S);
  }
});


/***/ }),
/* 287 */
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(71)('asyncIterator');


/***/ }),
/* 288 */
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(71)('observable');


/***/ }),
/* 289 */
/***/ (function(module, exports, __webpack_require__) {

// https://github.com/tc39/proposal-object-getownpropertydescriptors
var $export = __webpack_require__(0);
var ownKeys = __webpack_require__(126);
var toIObject = __webpack_require__(16);
var gOPD = __webpack_require__(17);
var createProperty = __webpack_require__(86);

$export($export.S, 'Object', {
  getOwnPropertyDescriptors: function getOwnPropertyDescriptors(object) {
    var O = toIObject(object);
    var getDesc = gOPD.f;
    var keys = ownKeys(O);
    var result = {};
    var i = 0;
    var key, desc;
    while (keys.length > i) {
      desc = getDesc(O, key = keys[i++]);
      if (desc !== undefined) createProperty(result, key, desc);
    }
    return result;
  }
});


/***/ }),
/* 290 */
/***/ (function(module, exports, __webpack_require__) {

// https://github.com/tc39/proposal-object-values-entries
var $export = __webpack_require__(0);
var $values = __webpack_require__(129)(false);

$export($export.S, 'Object', {
  values: function values(it) {
    return $values(it);
  }
});


/***/ }),
/* 291 */
/***/ (function(module, exports, __webpack_require__) {

// https://github.com/tc39/proposal-object-values-entries
var $export = __webpack_require__(0);
var $entries = __webpack_require__(129)(true);

$export($export.S, 'Object', {
  entries: function entries(it) {
    return $entries(it);
  }
});


/***/ }),
/* 292 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $export = __webpack_require__(0);
var toObject = __webpack_require__(10);
var aFunction = __webpack_require__(11);
var $defineProperty = __webpack_require__(8);

// B.2.2.2 Object.prototype.__defineGetter__(P, getter)
__webpack_require__(7) && $export($export.P + __webpack_require__(67), 'Object', {
  __defineGetter__: function __defineGetter__(P, getter) {
    $defineProperty.f(toObject(this), P, { get: aFunction(getter), enumerable: true, configurable: true });
  }
});


/***/ }),
/* 293 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $export = __webpack_require__(0);
var toObject = __webpack_require__(10);
var aFunction = __webpack_require__(11);
var $defineProperty = __webpack_require__(8);

// B.2.2.3 Object.prototype.__defineSetter__(P, setter)
__webpack_require__(7) && $export($export.P + __webpack_require__(67), 'Object', {
  __defineSetter__: function __defineSetter__(P, setter) {
    $defineProperty.f(toObject(this), P, { set: aFunction(setter), enumerable: true, configurable: true });
  }
});


/***/ }),
/* 294 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $export = __webpack_require__(0);
var toObject = __webpack_require__(10);
var toPrimitive = __webpack_require__(24);
var getPrototypeOf = __webpack_require__(18);
var getOwnPropertyDescriptor = __webpack_require__(17).f;

// B.2.2.4 Object.prototype.__lookupGetter__(P)
__webpack_require__(7) && $export($export.P + __webpack_require__(67), 'Object', {
  __lookupGetter__: function __lookupGetter__(P) {
    var O = toObject(this);
    var K = toPrimitive(P, true);
    var D;
    do {
      if (D = getOwnPropertyDescriptor(O, K)) return D.get;
    } while (O = getPrototypeOf(O));
  }
});


/***/ }),
/* 295 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $export = __webpack_require__(0);
var toObject = __webpack_require__(10);
var toPrimitive = __webpack_require__(24);
var getPrototypeOf = __webpack_require__(18);
var getOwnPropertyDescriptor = __webpack_require__(17).f;

// B.2.2.5 Object.prototype.__lookupSetter__(P)
__webpack_require__(7) && $export($export.P + __webpack_require__(67), 'Object', {
  __lookupSetter__: function __lookupSetter__(P) {
    var O = toObject(this);
    var K = toPrimitive(P, true);
    var D;
    do {
      if (D = getOwnPropertyDescriptor(O, K)) return D.set;
    } while (O = getPrototypeOf(O));
  }
});


/***/ }),
/* 296 */
/***/ (function(module, exports, __webpack_require__) {

// https://github.com/DavidBruant/Map-Set.prototype.toJSON
var $export = __webpack_require__(0);

$export($export.P + $export.R, 'Map', { toJSON: __webpack_require__(130)('Map') });


/***/ }),
/* 297 */
/***/ (function(module, exports, __webpack_require__) {

// https://github.com/DavidBruant/Map-Set.prototype.toJSON
var $export = __webpack_require__(0);

$export($export.P + $export.R, 'Set', { toJSON: __webpack_require__(130)('Set') });


/***/ }),
/* 298 */
/***/ (function(module, exports, __webpack_require__) {

// https://tc39.github.io/proposal-setmap-offrom/#sec-map.of
__webpack_require__(68)('Map');


/***/ }),
/* 299 */
/***/ (function(module, exports, __webpack_require__) {

// https://tc39.github.io/proposal-setmap-offrom/#sec-set.of
__webpack_require__(68)('Set');


/***/ }),
/* 300 */
/***/ (function(module, exports, __webpack_require__) {

// https://tc39.github.io/proposal-setmap-offrom/#sec-weakmap.of
__webpack_require__(68)('WeakMap');


/***/ }),
/* 301 */
/***/ (function(module, exports, __webpack_require__) {

// https://tc39.github.io/proposal-setmap-offrom/#sec-weakset.of
__webpack_require__(68)('WeakSet');


/***/ }),
/* 302 */
/***/ (function(module, exports, __webpack_require__) {

// https://tc39.github.io/proposal-setmap-offrom/#sec-map.from
__webpack_require__(69)('Map');


/***/ }),
/* 303 */
/***/ (function(module, exports, __webpack_require__) {

// https://tc39.github.io/proposal-setmap-offrom/#sec-set.from
__webpack_require__(69)('Set');


/***/ }),
/* 304 */
/***/ (function(module, exports, __webpack_require__) {

// https://tc39.github.io/proposal-setmap-offrom/#sec-weakmap.from
__webpack_require__(69)('WeakMap');


/***/ }),
/* 305 */
/***/ (function(module, exports, __webpack_require__) {

// https://tc39.github.io/proposal-setmap-offrom/#sec-weakset.from
__webpack_require__(69)('WeakSet');


/***/ }),
/* 306 */
/***/ (function(module, exports, __webpack_require__) {

// https://github.com/tc39/proposal-global
var $export = __webpack_require__(0);

$export($export.G, { global: __webpack_require__(2) });


/***/ }),
/* 307 */
/***/ (function(module, exports, __webpack_require__) {

// https://github.com/tc39/proposal-global
var $export = __webpack_require__(0);

$export($export.S, 'System', { global: __webpack_require__(2) });


/***/ }),
/* 308 */
/***/ (function(module, exports, __webpack_require__) {

// https://github.com/ljharb/proposal-is-error
var $export = __webpack_require__(0);
var cof = __webpack_require__(21);

$export($export.S, 'Error', {
  isError: function isError(it) {
    return cof(it) === 'Error';
  }
});


/***/ }),
/* 309 */
/***/ (function(module, exports, __webpack_require__) {

// https://rwaldron.github.io/proposal-math-extensions/
var $export = __webpack_require__(0);

$export($export.S, 'Math', {
  clamp: function clamp(x, lower, upper) {
    return Math.min(upper, Math.max(lower, x));
  }
});


/***/ }),
/* 310 */
/***/ (function(module, exports, __webpack_require__) {

// https://rwaldron.github.io/proposal-math-extensions/
var $export = __webpack_require__(0);

$export($export.S, 'Math', { DEG_PER_RAD: Math.PI / 180 });


/***/ }),
/* 311 */
/***/ (function(module, exports, __webpack_require__) {

// https://rwaldron.github.io/proposal-math-extensions/
var $export = __webpack_require__(0);
var RAD_PER_DEG = 180 / Math.PI;

$export($export.S, 'Math', {
  degrees: function degrees(radians) {
    return radians * RAD_PER_DEG;
  }
});


/***/ }),
/* 312 */
/***/ (function(module, exports, __webpack_require__) {

// https://rwaldron.github.io/proposal-math-extensions/
var $export = __webpack_require__(0);
var scale = __webpack_require__(132);
var fround = __webpack_require__(111);

$export($export.S, 'Math', {
  fscale: function fscale(x, inLow, inHigh, outLow, outHigh) {
    return fround(scale(x, inLow, inHigh, outLow, outHigh));
  }
});


/***/ }),
/* 313 */
/***/ (function(module, exports, __webpack_require__) {

// https://gist.github.com/BrendanEich/4294d5c212a6d2254703
var $export = __webpack_require__(0);

$export($export.S, 'Math', {
  iaddh: function iaddh(x0, x1, y0, y1) {
    var $x0 = x0 >>> 0;
    var $x1 = x1 >>> 0;
    var $y0 = y0 >>> 0;
    return $x1 + (y1 >>> 0) + (($x0 & $y0 | ($x0 | $y0) & ~($x0 + $y0 >>> 0)) >>> 31) | 0;
  }
});


/***/ }),
/* 314 */
/***/ (function(module, exports, __webpack_require__) {

// https://gist.github.com/BrendanEich/4294d5c212a6d2254703
var $export = __webpack_require__(0);

$export($export.S, 'Math', {
  isubh: function isubh(x0, x1, y0, y1) {
    var $x0 = x0 >>> 0;
    var $x1 = x1 >>> 0;
    var $y0 = y0 >>> 0;
    return $x1 - (y1 >>> 0) - ((~$x0 & $y0 | ~($x0 ^ $y0) & $x0 - $y0 >>> 0) >>> 31) | 0;
  }
});


/***/ }),
/* 315 */
/***/ (function(module, exports, __webpack_require__) {

// https://gist.github.com/BrendanEich/4294d5c212a6d2254703
var $export = __webpack_require__(0);

$export($export.S, 'Math', {
  imulh: function imulh(u, v) {
    var UINT16 = 0xffff;
    var $u = +u;
    var $v = +v;
    var u0 = $u & UINT16;
    var v0 = $v & UINT16;
    var u1 = $u >> 16;
    var v1 = $v >> 16;
    var t = (u1 * v0 >>> 0) + (u0 * v0 >>> 16);
    return u1 * v1 + (t >> 16) + ((u0 * v1 >>> 0) + (t & UINT16) >> 16);
  }
});


/***/ }),
/* 316 */
/***/ (function(module, exports, __webpack_require__) {

// https://rwaldron.github.io/proposal-math-extensions/
var $export = __webpack_require__(0);

$export($export.S, 'Math', { RAD_PER_DEG: 180 / Math.PI });


/***/ }),
/* 317 */
/***/ (function(module, exports, __webpack_require__) {

// https://rwaldron.github.io/proposal-math-extensions/
var $export = __webpack_require__(0);
var DEG_PER_RAD = Math.PI / 180;

$export($export.S, 'Math', {
  radians: function radians(degrees) {
    return degrees * DEG_PER_RAD;
  }
});


/***/ }),
/* 318 */
/***/ (function(module, exports, __webpack_require__) {

// https://rwaldron.github.io/proposal-math-extensions/
var $export = __webpack_require__(0);

$export($export.S, 'Math', { scale: __webpack_require__(132) });


/***/ }),
/* 319 */
/***/ (function(module, exports, __webpack_require__) {

// https://gist.github.com/BrendanEich/4294d5c212a6d2254703
var $export = __webpack_require__(0);

$export($export.S, 'Math', {
  umulh: function umulh(u, v) {
    var UINT16 = 0xffff;
    var $u = +u;
    var $v = +v;
    var u0 = $u & UINT16;
    var v0 = $v & UINT16;
    var u1 = $u >>> 16;
    var v1 = $v >>> 16;
    var t = (u1 * v0 >>> 0) + (u0 * v0 >>> 16);
    return u1 * v1 + (t >>> 16) + ((u0 * v1 >>> 0) + (t & UINT16) >>> 16);
  }
});


/***/ }),
/* 320 */
/***/ (function(module, exports, __webpack_require__) {

// http://jfbastien.github.io/papers/Math.signbit.html
var $export = __webpack_require__(0);

$export($export.S, 'Math', { signbit: function signbit(x) {
  // eslint-disable-next-line no-self-compare
  return (x = +x) != x ? x : x == 0 ? 1 / x == Infinity : x > 0;
} });


/***/ }),
/* 321 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
// https://github.com/tc39/proposal-promise-finally

var $export = __webpack_require__(0);
var core = __webpack_require__(19);
var global = __webpack_require__(2);
var speciesConstructor = __webpack_require__(54);
var promiseResolve = __webpack_require__(119);

$export($export.P + $export.R, 'Promise', { 'finally': function (onFinally) {
  var C = speciesConstructor(this, core.Promise || global.Promise);
  var isFunction = typeof onFinally == 'function';
  return this.then(
    isFunction ? function (x) {
      return promiseResolve(C, onFinally()).then(function () { return x; });
    } : onFinally,
    isFunction ? function (e) {
      return promiseResolve(C, onFinally()).then(function () { throw e; });
    } : onFinally
  );
} });


/***/ }),
/* 322 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// https://github.com/tc39/proposal-promise-try
var $export = __webpack_require__(0);
var newPromiseCapability = __webpack_require__(95);
var perform = __webpack_require__(118);

$export($export.S, 'Promise', { 'try': function (callbackfn) {
  var promiseCapability = newPromiseCapability.f(this);
  var result = perform(callbackfn);
  (result.e ? promiseCapability.reject : promiseCapability.resolve)(result.v);
  return promiseCapability.promise;
} });


/***/ }),
/* 323 */
/***/ (function(module, exports, __webpack_require__) {

var metadata = __webpack_require__(30);
var anObject = __webpack_require__(1);
var toMetaKey = metadata.key;
var ordinaryDefineOwnMetadata = metadata.set;

metadata.exp({ defineMetadata: function defineMetadata(metadataKey, metadataValue, target, targetKey) {
  ordinaryDefineOwnMetadata(metadataKey, metadataValue, anObject(target), toMetaKey(targetKey));
} });


/***/ }),
/* 324 */
/***/ (function(module, exports, __webpack_require__) {

var metadata = __webpack_require__(30);
var anObject = __webpack_require__(1);
var toMetaKey = metadata.key;
var getOrCreateMetadataMap = metadata.map;
var store = metadata.store;

metadata.exp({ deleteMetadata: function deleteMetadata(metadataKey, target /* , targetKey */) {
  var targetKey = arguments.length < 3 ? undefined : toMetaKey(arguments[2]);
  var metadataMap = getOrCreateMetadataMap(anObject(target), targetKey, false);
  if (metadataMap === undefined || !metadataMap['delete'](metadataKey)) return false;
  if (metadataMap.size) return true;
  var targetMetadata = store.get(target);
  targetMetadata['delete'](targetKey);
  return !!targetMetadata.size || store['delete'](target);
} });


/***/ }),
/* 325 */
/***/ (function(module, exports, __webpack_require__) {

var metadata = __webpack_require__(30);
var anObject = __webpack_require__(1);
var getPrototypeOf = __webpack_require__(18);
var ordinaryHasOwnMetadata = metadata.has;
var ordinaryGetOwnMetadata = metadata.get;
var toMetaKey = metadata.key;

var ordinaryGetMetadata = function (MetadataKey, O, P) {
  var hasOwn = ordinaryHasOwnMetadata(MetadataKey, O, P);
  if (hasOwn) return ordinaryGetOwnMetadata(MetadataKey, O, P);
  var parent = getPrototypeOf(O);
  return parent !== null ? ordinaryGetMetadata(MetadataKey, parent, P) : undefined;
};

metadata.exp({ getMetadata: function getMetadata(metadataKey, target /* , targetKey */) {
  return ordinaryGetMetadata(metadataKey, anObject(target), arguments.length < 3 ? undefined : toMetaKey(arguments[2]));
} });


/***/ }),
/* 326 */
/***/ (function(module, exports, __webpack_require__) {

var Set = __webpack_require__(122);
var from = __webpack_require__(131);
var metadata = __webpack_require__(30);
var anObject = __webpack_require__(1);
var getPrototypeOf = __webpack_require__(18);
var ordinaryOwnMetadataKeys = metadata.keys;
var toMetaKey = metadata.key;

var ordinaryMetadataKeys = function (O, P) {
  var oKeys = ordinaryOwnMetadataKeys(O, P);
  var parent = getPrototypeOf(O);
  if (parent === null) return oKeys;
  var pKeys = ordinaryMetadataKeys(parent, P);
  return pKeys.length ? oKeys.length ? from(new Set(oKeys.concat(pKeys))) : pKeys : oKeys;
};

metadata.exp({ getMetadataKeys: function getMetadataKeys(target /* , targetKey */) {
  return ordinaryMetadataKeys(anObject(target), arguments.length < 2 ? undefined : toMetaKey(arguments[1]));
} });


/***/ }),
/* 327 */
/***/ (function(module, exports, __webpack_require__) {

var metadata = __webpack_require__(30);
var anObject = __webpack_require__(1);
var ordinaryGetOwnMetadata = metadata.get;
var toMetaKey = metadata.key;

metadata.exp({ getOwnMetadata: function getOwnMetadata(metadataKey, target /* , targetKey */) {
  return ordinaryGetOwnMetadata(metadataKey, anObject(target)
    , arguments.length < 3 ? undefined : toMetaKey(arguments[2]));
} });


/***/ }),
/* 328 */
/***/ (function(module, exports, __webpack_require__) {

var metadata = __webpack_require__(30);
var anObject = __webpack_require__(1);
var ordinaryOwnMetadataKeys = metadata.keys;
var toMetaKey = metadata.key;

metadata.exp({ getOwnMetadataKeys: function getOwnMetadataKeys(target /* , targetKey */) {
  return ordinaryOwnMetadataKeys(anObject(target), arguments.length < 2 ? undefined : toMetaKey(arguments[1]));
} });


/***/ }),
/* 329 */
/***/ (function(module, exports, __webpack_require__) {

var metadata = __webpack_require__(30);
var anObject = __webpack_require__(1);
var getPrototypeOf = __webpack_require__(18);
var ordinaryHasOwnMetadata = metadata.has;
var toMetaKey = metadata.key;

var ordinaryHasMetadata = function (MetadataKey, O, P) {
  var hasOwn = ordinaryHasOwnMetadata(MetadataKey, O, P);
  if (hasOwn) return true;
  var parent = getPrototypeOf(O);
  return parent !== null ? ordinaryHasMetadata(MetadataKey, parent, P) : false;
};

metadata.exp({ hasMetadata: function hasMetadata(metadataKey, target /* , targetKey */) {
  return ordinaryHasMetadata(metadataKey, anObject(target), arguments.length < 3 ? undefined : toMetaKey(arguments[2]));
} });


/***/ }),
/* 330 */
/***/ (function(module, exports, __webpack_require__) {

var metadata = __webpack_require__(30);
var anObject = __webpack_require__(1);
var ordinaryHasOwnMetadata = metadata.has;
var toMetaKey = metadata.key;

metadata.exp({ hasOwnMetadata: function hasOwnMetadata(metadataKey, target /* , targetKey */) {
  return ordinaryHasOwnMetadata(metadataKey, anObject(target)
    , arguments.length < 3 ? undefined : toMetaKey(arguments[2]));
} });


/***/ }),
/* 331 */
/***/ (function(module, exports, __webpack_require__) {

var $metadata = __webpack_require__(30);
var anObject = __webpack_require__(1);
var aFunction = __webpack_require__(11);
var toMetaKey = $metadata.key;
var ordinaryDefineOwnMetadata = $metadata.set;

$metadata.exp({ metadata: function metadata(metadataKey, metadataValue) {
  return function decorator(target, targetKey) {
    ordinaryDefineOwnMetadata(
      metadataKey, metadataValue,
      (targetKey !== undefined ? anObject : aFunction)(target),
      toMetaKey(targetKey)
    );
  };
} });


/***/ }),
/* 332 */
/***/ (function(module, exports, __webpack_require__) {

// https://github.com/rwaldron/tc39-notes/blob/master/es6/2014-09/sept-25.md#510-globalasap-for-enqueuing-a-microtask
var $export = __webpack_require__(0);
var microtask = __webpack_require__(94)();
var process = __webpack_require__(2).process;
var isNode = __webpack_require__(21)(process) == 'process';

$export($export.G, {
  asap: function asap(fn) {
    var domain = isNode && process.domain;
    microtask(domain ? domain.bind(fn) : fn);
  }
});


/***/ }),
/* 333 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// https://github.com/zenparsing/es-observable
var $export = __webpack_require__(0);
var global = __webpack_require__(2);
var core = __webpack_require__(19);
var microtask = __webpack_require__(94)();
var OBSERVABLE = __webpack_require__(5)('observable');
var aFunction = __webpack_require__(11);
var anObject = __webpack_require__(1);
var anInstance = __webpack_require__(41);
var redefineAll = __webpack_require__(43);
var hide = __webpack_require__(12);
var forOf = __webpack_require__(42);
var RETURN = forOf.RETURN;

var getMethod = function (fn) {
  return fn == null ? undefined : aFunction(fn);
};

var cleanupSubscription = function (subscription) {
  var cleanup = subscription._c;
  if (cleanup) {
    subscription._c = undefined;
    cleanup();
  }
};

var subscriptionClosed = function (subscription) {
  return subscription._o === undefined;
};

var closeSubscription = function (subscription) {
  if (!subscriptionClosed(subscription)) {
    subscription._o = undefined;
    cleanupSubscription(subscription);
  }
};

var Subscription = function (observer, subscriber) {
  anObject(observer);
  this._c = undefined;
  this._o = observer;
  observer = new SubscriptionObserver(this);
  try {
    var cleanup = subscriber(observer);
    var subscription = cleanup;
    if (cleanup != null) {
      if (typeof cleanup.unsubscribe === 'function') cleanup = function () { subscription.unsubscribe(); };
      else aFunction(cleanup);
      this._c = cleanup;
    }
  } catch (e) {
    observer.error(e);
    return;
  } if (subscriptionClosed(this)) cleanupSubscription(this);
};

Subscription.prototype = redefineAll({}, {
  unsubscribe: function unsubscribe() { closeSubscription(this); }
});

var SubscriptionObserver = function (subscription) {
  this._s = subscription;
};

SubscriptionObserver.prototype = redefineAll({}, {
  next: function next(value) {
    var subscription = this._s;
    if (!subscriptionClosed(subscription)) {
      var observer = subscription._o;
      try {
        var m = getMethod(observer.next);
        if (m) return m.call(observer, value);
      } catch (e) {
        try {
          closeSubscription(subscription);
        } finally {
          throw e;
        }
      }
    }
  },
  error: function error(value) {
    var subscription = this._s;
    if (subscriptionClosed(subscription)) throw value;
    var observer = subscription._o;
    subscription._o = undefined;
    try {
      var m = getMethod(observer.error);
      if (!m) throw value;
      value = m.call(observer, value);
    } catch (e) {
      try {
        cleanupSubscription(subscription);
      } finally {
        throw e;
      }
    } cleanupSubscription(subscription);
    return value;
  },
  complete: function complete(value) {
    var subscription = this._s;
    if (!subscriptionClosed(subscription)) {
      var observer = subscription._o;
      subscription._o = undefined;
      try {
        var m = getMethod(observer.complete);
        value = m ? m.call(observer, value) : undefined;
      } catch (e) {
        try {
          cleanupSubscription(subscription);
        } finally {
          throw e;
        }
      } cleanupSubscription(subscription);
      return value;
    }
  }
});

var $Observable = function Observable(subscriber) {
  anInstance(this, $Observable, 'Observable', '_f')._f = aFunction(subscriber);
};

redefineAll($Observable.prototype, {
  subscribe: function subscribe(observer) {
    return new Subscription(observer, this._f);
  },
  forEach: function forEach(fn) {
    var that = this;
    return new (core.Promise || global.Promise)(function (resolve, reject) {
      aFunction(fn);
      var subscription = that.subscribe({
        next: function (value) {
          try {
            return fn(value);
          } catch (e) {
            reject(e);
            subscription.unsubscribe();
          }
        },
        error: reject,
        complete: resolve
      });
    });
  }
});

redefineAll($Observable, {
  from: function from(x) {
    var C = typeof this === 'function' ? this : $Observable;
    var method = getMethod(anObject(x)[OBSERVABLE]);
    if (method) {
      var observable = anObject(method.call(x));
      return observable.constructor === C ? observable : new C(function (observer) {
        return observable.subscribe(observer);
      });
    }
    return new C(function (observer) {
      var done = false;
      microtask(function () {
        if (!done) {
          try {
            if (forOf(x, false, function (it) {
              observer.next(it);
              if (done) return RETURN;
            }) === RETURN) return;
          } catch (e) {
            if (done) throw e;
            observer.error(e);
            return;
          } observer.complete();
        }
      });
      return function () { done = true; };
    });
  },
  of: function of() {
    for (var i = 0, l = arguments.length, items = new Array(l); i < l;) items[i] = arguments[i++];
    return new (typeof this === 'function' ? this : $Observable)(function (observer) {
      var done = false;
      microtask(function () {
        if (!done) {
          for (var j = 0; j < items.length; ++j) {
            observer.next(items[j]);
            if (done) return;
          } observer.complete();
        }
      });
      return function () { done = true; };
    });
  }
});

hide($Observable.prototype, OBSERVABLE, function () { return this; });

$export($export.G, { Observable: $Observable });

__webpack_require__(40)('Observable');


/***/ }),
/* 334 */
/***/ (function(module, exports, __webpack_require__) {

// ie9- setTimeout & setInterval additional parameters fix
var global = __webpack_require__(2);
var $export = __webpack_require__(0);
var userAgent = __webpack_require__(64);
var slice = [].slice;
var MSIE = /MSIE .\./.test(userAgent); // <- dirty ie9- check
var wrap = function (set) {
  return function (fn, time /* , ...args */) {
    var boundArgs = arguments.length > 2;
    var args = boundArgs ? slice.call(arguments, 2) : false;
    return set(boundArgs ? function () {
      // eslint-disable-next-line no-new-func
      (typeof fn == 'function' ? fn : Function(fn)).apply(this, args);
    } : fn, time);
  };
};
$export($export.G + $export.B + $export.F * MSIE, {
  setTimeout: wrap(global.setTimeout),
  setInterval: wrap(global.setInterval)
});


/***/ }),
/* 335 */
/***/ (function(module, exports, __webpack_require__) {

var $export = __webpack_require__(0);
var $task = __webpack_require__(93);
$export($export.G + $export.B, {
  setImmediate: $task.set,
  clearImmediate: $task.clear
});


/***/ }),
/* 336 */
/***/ (function(module, exports, __webpack_require__) {

var $iterators = __webpack_require__(90);
var getKeys = __webpack_require__(36);
var redefine = __webpack_require__(13);
var global = __webpack_require__(2);
var hide = __webpack_require__(12);
var Iterators = __webpack_require__(49);
var wks = __webpack_require__(5);
var ITERATOR = wks('iterator');
var TO_STRING_TAG = wks('toStringTag');
var ArrayValues = Iterators.Array;

var DOMIterables = {
  CSSRuleList: true, // TODO: Not spec compliant, should be false.
  CSSStyleDeclaration: false,
  CSSValueList: false,
  ClientRectList: false,
  DOMRectList: false,
  DOMStringList: false,
  DOMTokenList: true,
  DataTransferItemList: false,
  FileList: false,
  HTMLAllCollection: false,
  HTMLCollection: false,
  HTMLFormElement: false,
  HTMLSelectElement: false,
  MediaList: true, // TODO: Not spec compliant, should be false.
  MimeTypeArray: false,
  NamedNodeMap: false,
  NodeList: true,
  PaintRequestList: false,
  Plugin: false,
  PluginArray: false,
  SVGLengthList: false,
  SVGNumberList: false,
  SVGPathSegList: false,
  SVGPointList: false,
  SVGStringList: false,
  SVGTransformList: false,
  SourceBufferList: false,
  StyleSheetList: true, // TODO: Not spec compliant, should be false.
  TextTrackCueList: false,
  TextTrackList: false,
  TouchList: false
};

for (var collections = getKeys(DOMIterables), i = 0; i < collections.length; i++) {
  var NAME = collections[i];
  var explicit = DOMIterables[NAME];
  var Collection = global[NAME];
  var proto = Collection && Collection.prototype;
  var key;
  if (proto) {
    if (!proto[ITERATOR]) hide(proto, ITERATOR, ArrayValues);
    if (!proto[TO_STRING_TAG]) hide(proto, TO_STRING_TAG, NAME);
    Iterators[NAME] = ArrayValues;
    if (explicit) for (key in $iterators) if (!proto[key]) redefine(proto, key, $iterators[key], true);
  }
}


/***/ }),
/* 337 */
/***/ (function(module, exports, __webpack_require__) {

/* WEBPACK VAR INJECTION */(function(global) {/**
 * Copyright (c) 2014, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * https://raw.github.com/facebook/regenerator/master/LICENSE file. An
 * additional grant of patent rights can be found in the PATENTS file in
 * the same directory.
 */

!(function(global) {
  "use strict";

  var Op = Object.prototype;
  var hasOwn = Op.hasOwnProperty;
  var undefined; // More compressible than void 0.
  var $Symbol = typeof Symbol === "function" ? Symbol : {};
  var iteratorSymbol = $Symbol.iterator || "@@iterator";
  var asyncIteratorSymbol = $Symbol.asyncIterator || "@@asyncIterator";
  var toStringTagSymbol = $Symbol.toStringTag || "@@toStringTag";

  var inModule = typeof module === "object";
  var runtime = global.regeneratorRuntime;
  if (runtime) {
    if (inModule) {
      // If regeneratorRuntime is defined globally and we're in a module,
      // make the exports object identical to regeneratorRuntime.
      module.exports = runtime;
    }
    // Don't bother evaluating the rest of this file if the runtime was
    // already defined globally.
    return;
  }

  // Define the runtime globally (as expected by generated code) as either
  // module.exports (if we're in a module) or a new, empty object.
  runtime = global.regeneratorRuntime = inModule ? module.exports : {};

  function wrap(innerFn, outerFn, self, tryLocsList) {
    // If outerFn provided and outerFn.prototype is a Generator, then outerFn.prototype instanceof Generator.
    var protoGenerator = outerFn && outerFn.prototype instanceof Generator ? outerFn : Generator;
    var generator = Object.create(protoGenerator.prototype);
    var context = new Context(tryLocsList || []);

    // The ._invoke method unifies the implementations of the .next,
    // .throw, and .return methods.
    generator._invoke = makeInvokeMethod(innerFn, self, context);

    return generator;
  }
  runtime.wrap = wrap;

  // Try/catch helper to minimize deoptimizations. Returns a completion
  // record like context.tryEntries[i].completion. This interface could
  // have been (and was previously) designed to take a closure to be
  // invoked without arguments, but in all the cases we care about we
  // already have an existing method we want to call, so there's no need
  // to create a new function object. We can even get away with assuming
  // the method takes exactly one argument, since that happens to be true
  // in every case, so we don't have to touch the arguments object. The
  // only additional allocation required is the completion record, which
  // has a stable shape and so hopefully should be cheap to allocate.
  function tryCatch(fn, obj, arg) {
    try {
      return { type: "normal", arg: fn.call(obj, arg) };
    } catch (err) {
      return { type: "throw", arg: err };
    }
  }

  var GenStateSuspendedStart = "suspendedStart";
  var GenStateSuspendedYield = "suspendedYield";
  var GenStateExecuting = "executing";
  var GenStateCompleted = "completed";

  // Returning this object from the innerFn has the same effect as
  // breaking out of the dispatch switch statement.
  var ContinueSentinel = {};

  // Dummy constructor functions that we use as the .constructor and
  // .constructor.prototype properties for functions that return Generator
  // objects. For full spec compliance, you may wish to configure your
  // minifier not to mangle the names of these two functions.
  function Generator() {}
  function GeneratorFunction() {}
  function GeneratorFunctionPrototype() {}

  // This is a polyfill for %IteratorPrototype% for environments that
  // don't natively support it.
  var IteratorPrototype = {};
  IteratorPrototype[iteratorSymbol] = function () {
    return this;
  };

  var getProto = Object.getPrototypeOf;
  var NativeIteratorPrototype = getProto && getProto(getProto(values([])));
  if (NativeIteratorPrototype &&
      NativeIteratorPrototype !== Op &&
      hasOwn.call(NativeIteratorPrototype, iteratorSymbol)) {
    // This environment has a native %IteratorPrototype%; use it instead
    // of the polyfill.
    IteratorPrototype = NativeIteratorPrototype;
  }

  var Gp = GeneratorFunctionPrototype.prototype =
    Generator.prototype = Object.create(IteratorPrototype);
  GeneratorFunction.prototype = Gp.constructor = GeneratorFunctionPrototype;
  GeneratorFunctionPrototype.constructor = GeneratorFunction;
  GeneratorFunctionPrototype[toStringTagSymbol] =
    GeneratorFunction.displayName = "GeneratorFunction";

  // Helper for defining the .next, .throw, and .return methods of the
  // Iterator interface in terms of a single ._invoke method.
  function defineIteratorMethods(prototype) {
    ["next", "throw", "return"].forEach(function(method) {
      prototype[method] = function(arg) {
        return this._invoke(method, arg);
      };
    });
  }

  runtime.isGeneratorFunction = function(genFun) {
    var ctor = typeof genFun === "function" && genFun.constructor;
    return ctor
      ? ctor === GeneratorFunction ||
        // For the native GeneratorFunction constructor, the best we can
        // do is to check its .name property.
        (ctor.displayName || ctor.name) === "GeneratorFunction"
      : false;
  };

  runtime.mark = function(genFun) {
    if (Object.setPrototypeOf) {
      Object.setPrototypeOf(genFun, GeneratorFunctionPrototype);
    } else {
      genFun.__proto__ = GeneratorFunctionPrototype;
      if (!(toStringTagSymbol in genFun)) {
        genFun[toStringTagSymbol] = "GeneratorFunction";
      }
    }
    genFun.prototype = Object.create(Gp);
    return genFun;
  };

  // Within the body of any async function, `await x` is transformed to
  // `yield regeneratorRuntime.awrap(x)`, so that the runtime can test
  // `hasOwn.call(value, "__await")` to determine if the yielded value is
  // meant to be awaited.
  runtime.awrap = function(arg) {
    return { __await: arg };
  };

  function AsyncIterator(generator) {
    function invoke(method, arg, resolve, reject) {
      var record = tryCatch(generator[method], generator, arg);
      if (record.type === "throw") {
        reject(record.arg);
      } else {
        var result = record.arg;
        var value = result.value;
        if (value &&
            typeof value === "object" &&
            hasOwn.call(value, "__await")) {
          return Promise.resolve(value.__await).then(function(value) {
            invoke("next", value, resolve, reject);
          }, function(err) {
            invoke("throw", err, resolve, reject);
          });
        }

        return Promise.resolve(value).then(function(unwrapped) {
          // When a yielded Promise is resolved, its final value becomes
          // the .value of the Promise<{value,done}> result for the
          // current iteration. If the Promise is rejected, however, the
          // result for this iteration will be rejected with the same
          // reason. Note that rejections of yielded Promises are not
          // thrown back into the generator function, as is the case
          // when an awaited Promise is rejected. This difference in
          // behavior between yield and await is important, because it
          // allows the consumer to decide what to do with the yielded
          // rejection (swallow it and continue, manually .throw it back
          // into the generator, abandon iteration, whatever). With
          // await, by contrast, there is no opportunity to examine the
          // rejection reason outside the generator function, so the
          // only option is to throw it from the await expression, and
          // let the generator function handle the exception.
          result.value = unwrapped;
          resolve(result);
        }, reject);
      }
    }

    if (typeof global.process === "object" && global.process.domain) {
      invoke = global.process.domain.bind(invoke);
    }

    var previousPromise;

    function enqueue(method, arg) {
      function callInvokeWithMethodAndArg() {
        return new Promise(function(resolve, reject) {
          invoke(method, arg, resolve, reject);
        });
      }

      return previousPromise =
        // If enqueue has been called before, then we want to wait until
        // all previous Promises have been resolved before calling invoke,
        // so that results are always delivered in the correct order. If
        // enqueue has not been called before, then it is important to
        // call invoke immediately, without waiting on a callback to fire,
        // so that the async generator function has the opportunity to do
        // any necessary setup in a predictable way. This predictability
        // is why the Promise constructor synchronously invokes its
        // executor callback, and why async functions synchronously
        // execute code before the first await. Since we implement simple
        // async functions in terms of async generators, it is especially
        // important to get this right, even though it requires care.
        previousPromise ? previousPromise.then(
          callInvokeWithMethodAndArg,
          // Avoid propagating failures to Promises returned by later
          // invocations of the iterator.
          callInvokeWithMethodAndArg
        ) : callInvokeWithMethodAndArg();
    }

    // Define the unified helper method that is used to implement .next,
    // .throw, and .return (see defineIteratorMethods).
    this._invoke = enqueue;
  }

  defineIteratorMethods(AsyncIterator.prototype);
  AsyncIterator.prototype[asyncIteratorSymbol] = function () {
    return this;
  };
  runtime.AsyncIterator = AsyncIterator;

  // Note that simple async functions are implemented on top of
  // AsyncIterator objects; they just return a Promise for the value of
  // the final result produced by the iterator.
  runtime.async = function(innerFn, outerFn, self, tryLocsList) {
    var iter = new AsyncIterator(
      wrap(innerFn, outerFn, self, tryLocsList)
    );

    return runtime.isGeneratorFunction(outerFn)
      ? iter // If outerFn is a generator, return the full iterator.
      : iter.next().then(function(result) {
          return result.done ? result.value : iter.next();
        });
  };

  function makeInvokeMethod(innerFn, self, context) {
    var state = GenStateSuspendedStart;

    return function invoke(method, arg) {
      if (state === GenStateExecuting) {
        throw new Error("Generator is already running");
      }

      if (state === GenStateCompleted) {
        if (method === "throw") {
          throw arg;
        }

        // Be forgiving, per 25.3.3.3.3 of the spec:
        // https://people.mozilla.org/~jorendorff/es6-draft.html#sec-generatorresume
        return doneResult();
      }

      context.method = method;
      context.arg = arg;

      while (true) {
        var delegate = context.delegate;
        if (delegate) {
          var delegateResult = maybeInvokeDelegate(delegate, context);
          if (delegateResult) {
            if (delegateResult === ContinueSentinel) continue;
            return delegateResult;
          }
        }

        if (context.method === "next") {
          // Setting context._sent for legacy support of Babel's
          // function.sent implementation.
          context.sent = context._sent = context.arg;

        } else if (context.method === "throw") {
          if (state === GenStateSuspendedStart) {
            state = GenStateCompleted;
            throw context.arg;
          }

          context.dispatchException(context.arg);

        } else if (context.method === "return") {
          context.abrupt("return", context.arg);
        }

        state = GenStateExecuting;

        var record = tryCatch(innerFn, self, context);
        if (record.type === "normal") {
          // If an exception is thrown from innerFn, we leave state ===
          // GenStateExecuting and loop back for another invocation.
          state = context.done
            ? GenStateCompleted
            : GenStateSuspendedYield;

          if (record.arg === ContinueSentinel) {
            continue;
          }

          return {
            value: record.arg,
            done: context.done
          };

        } else if (record.type === "throw") {
          state = GenStateCompleted;
          // Dispatch the exception by looping back around to the
          // context.dispatchException(context.arg) call above.
          context.method = "throw";
          context.arg = record.arg;
        }
      }
    };
  }

  // Call delegate.iterator[context.method](context.arg) and handle the
  // result, either by returning a { value, done } result from the
  // delegate iterator, or by modifying context.method and context.arg,
  // setting context.delegate to null, and returning the ContinueSentinel.
  function maybeInvokeDelegate(delegate, context) {
    var method = delegate.iterator[context.method];
    if (method === undefined) {
      // A .throw or .return when the delegate iterator has no .throw
      // method always terminates the yield* loop.
      context.delegate = null;

      if (context.method === "throw") {
        if (delegate.iterator.return) {
          // If the delegate iterator has a return method, give it a
          // chance to clean up.
          context.method = "return";
          context.arg = undefined;
          maybeInvokeDelegate(delegate, context);

          if (context.method === "throw") {
            // If maybeInvokeDelegate(context) changed context.method from
            // "return" to "throw", let that override the TypeError below.
            return ContinueSentinel;
          }
        }

        context.method = "throw";
        context.arg = new TypeError(
          "The iterator does not provide a 'throw' method");
      }

      return ContinueSentinel;
    }

    var record = tryCatch(method, delegate.iterator, context.arg);

    if (record.type === "throw") {
      context.method = "throw";
      context.arg = record.arg;
      context.delegate = null;
      return ContinueSentinel;
    }

    var info = record.arg;

    if (! info) {
      context.method = "throw";
      context.arg = new TypeError("iterator result is not an object");
      context.delegate = null;
      return ContinueSentinel;
    }

    if (info.done) {
      // Assign the result of the finished delegate to the temporary
      // variable specified by delegate.resultName (see delegateYield).
      context[delegate.resultName] = info.value;

      // Resume execution at the desired location (see delegateYield).
      context.next = delegate.nextLoc;

      // If context.method was "throw" but the delegate handled the
      // exception, let the outer generator proceed normally. If
      // context.method was "next", forget context.arg since it has been
      // "consumed" by the delegate iterator. If context.method was
      // "return", allow the original .return call to continue in the
      // outer generator.
      if (context.method !== "return") {
        context.method = "next";
        context.arg = undefined;
      }

    } else {
      // Re-yield the result returned by the delegate method.
      return info;
    }

    // The delegate iterator is finished, so forget it and continue with
    // the outer generator.
    context.delegate = null;
    return ContinueSentinel;
  }

  // Define Generator.prototype.{next,throw,return} in terms of the
  // unified ._invoke helper method.
  defineIteratorMethods(Gp);

  Gp[toStringTagSymbol] = "Generator";

  // A Generator should always return itself as the iterator object when the
  // @@iterator function is called on it. Some browsers' implementations of the
  // iterator prototype chain incorrectly implement this, causing the Generator
  // object to not be returned from this call. This ensures that doesn't happen.
  // See https://github.com/facebook/regenerator/issues/274 for more details.
  Gp[iteratorSymbol] = function() {
    return this;
  };

  Gp.toString = function() {
    return "[object Generator]";
  };

  function pushTryEntry(locs) {
    var entry = { tryLoc: locs[0] };

    if (1 in locs) {
      entry.catchLoc = locs[1];
    }

    if (2 in locs) {
      entry.finallyLoc = locs[2];
      entry.afterLoc = locs[3];
    }

    this.tryEntries.push(entry);
  }

  function resetTryEntry(entry) {
    var record = entry.completion || {};
    record.type = "normal";
    delete record.arg;
    entry.completion = record;
  }

  function Context(tryLocsList) {
    // The root entry object (effectively a try statement without a catch
    // or a finally block) gives us a place to store values thrown from
    // locations where there is no enclosing try statement.
    this.tryEntries = [{ tryLoc: "root" }];
    tryLocsList.forEach(pushTryEntry, this);
    this.reset(true);
  }

  runtime.keys = function(object) {
    var keys = [];
    for (var key in object) {
      keys.push(key);
    }
    keys.reverse();

    // Rather than returning an object with a next method, we keep
    // things simple and return the next function itself.
    return function next() {
      while (keys.length) {
        var key = keys.pop();
        if (key in object) {
          next.value = key;
          next.done = false;
          return next;
        }
      }

      // To avoid creating an additional object, we just hang the .value
      // and .done properties off the next function object itself. This
      // also ensures that the minifier will not anonymize the function.
      next.done = true;
      return next;
    };
  };

  function values(iterable) {
    if (iterable) {
      var iteratorMethod = iterable[iteratorSymbol];
      if (iteratorMethod) {
        return iteratorMethod.call(iterable);
      }

      if (typeof iterable.next === "function") {
        return iterable;
      }

      if (!isNaN(iterable.length)) {
        var i = -1, next = function next() {
          while (++i < iterable.length) {
            if (hasOwn.call(iterable, i)) {
              next.value = iterable[i];
              next.done = false;
              return next;
            }
          }

          next.value = undefined;
          next.done = true;

          return next;
        };

        return next.next = next;
      }
    }

    // Return an iterator with no values.
    return { next: doneResult };
  }
  runtime.values = values;

  function doneResult() {
    return { value: undefined, done: true };
  }

  Context.prototype = {
    constructor: Context,

    reset: function(skipTempReset) {
      this.prev = 0;
      this.next = 0;
      // Resetting context._sent for legacy support of Babel's
      // function.sent implementation.
      this.sent = this._sent = undefined;
      this.done = false;
      this.delegate = null;

      this.method = "next";
      this.arg = undefined;

      this.tryEntries.forEach(resetTryEntry);

      if (!skipTempReset) {
        for (var name in this) {
          // Not sure about the optimal order of these conditions:
          if (name.charAt(0) === "t" &&
              hasOwn.call(this, name) &&
              !isNaN(+name.slice(1))) {
            this[name] = undefined;
          }
        }
      }
    },

    stop: function() {
      this.done = true;

      var rootEntry = this.tryEntries[0];
      var rootRecord = rootEntry.completion;
      if (rootRecord.type === "throw") {
        throw rootRecord.arg;
      }

      return this.rval;
    },

    dispatchException: function(exception) {
      if (this.done) {
        throw exception;
      }

      var context = this;
      function handle(loc, caught) {
        record.type = "throw";
        record.arg = exception;
        context.next = loc;

        if (caught) {
          // If the dispatched exception was caught by a catch block,
          // then let that catch block handle the exception normally.
          context.method = "next";
          context.arg = undefined;
        }

        return !! caught;
      }

      for (var i = this.tryEntries.length - 1; i >= 0; --i) {
        var entry = this.tryEntries[i];
        var record = entry.completion;

        if (entry.tryLoc === "root") {
          // Exception thrown outside of any try block that could handle
          // it, so set the completion value of the entire function to
          // throw the exception.
          return handle("end");
        }

        if (entry.tryLoc <= this.prev) {
          var hasCatch = hasOwn.call(entry, "catchLoc");
          var hasFinally = hasOwn.call(entry, "finallyLoc");

          if (hasCatch && hasFinally) {
            if (this.prev < entry.catchLoc) {
              return handle(entry.catchLoc, true);
            } else if (this.prev < entry.finallyLoc) {
              return handle(entry.finallyLoc);
            }

          } else if (hasCatch) {
            if (this.prev < entry.catchLoc) {
              return handle(entry.catchLoc, true);
            }

          } else if (hasFinally) {
            if (this.prev < entry.finallyLoc) {
              return handle(entry.finallyLoc);
            }

          } else {
            throw new Error("try statement without catch or finally");
          }
        }
      }
    },

    abrupt: function(type, arg) {
      for (var i = this.tryEntries.length - 1; i >= 0; --i) {
        var entry = this.tryEntries[i];
        if (entry.tryLoc <= this.prev &&
            hasOwn.call(entry, "finallyLoc") &&
            this.prev < entry.finallyLoc) {
          var finallyEntry = entry;
          break;
        }
      }

      if (finallyEntry &&
          (type === "break" ||
           type === "continue") &&
          finallyEntry.tryLoc <= arg &&
          arg <= finallyEntry.finallyLoc) {
        // Ignore the finally entry if control is not jumping to a
        // location outside the try/catch block.
        finallyEntry = null;
      }

      var record = finallyEntry ? finallyEntry.completion : {};
      record.type = type;
      record.arg = arg;

      if (finallyEntry) {
        this.method = "next";
        this.next = finallyEntry.finallyLoc;
        return ContinueSentinel;
      }

      return this.complete(record);
    },

    complete: function(record, afterLoc) {
      if (record.type === "throw") {
        throw record.arg;
      }

      if (record.type === "break" ||
          record.type === "continue") {
        this.next = record.arg;
      } else if (record.type === "return") {
        this.rval = this.arg = record.arg;
        this.method = "return";
        this.next = "end";
      } else if (record.type === "normal" && afterLoc) {
        this.next = afterLoc;
      }

      return ContinueSentinel;
    },

    finish: function(finallyLoc) {
      for (var i = this.tryEntries.length - 1; i >= 0; --i) {
        var entry = this.tryEntries[i];
        if (entry.finallyLoc === finallyLoc) {
          this.complete(entry.completion, entry.afterLoc);
          resetTryEntry(entry);
          return ContinueSentinel;
        }
      }
    },

    "catch": function(tryLoc) {
      for (var i = this.tryEntries.length - 1; i >= 0; --i) {
        var entry = this.tryEntries[i];
        if (entry.tryLoc === tryLoc) {
          var record = entry.completion;
          if (record.type === "throw") {
            var thrown = record.arg;
            resetTryEntry(entry);
          }
          return thrown;
        }
      }

      // The context.catch method must only be called with a location
      // argument that corresponds to a known catch block.
      throw new Error("illegal catch attempt");
    },

    delegateYield: function(iterable, resultName, nextLoc) {
      this.delegate = {
        iterator: values(iterable),
        resultName: resultName,
        nextLoc: nextLoc
      };

      if (this.method === "next") {
        // Deliberately forget the last sent value so that we don't
        // accidentally pass it on to the delegate.
        this.arg = undefined;
      }

      return ContinueSentinel;
    }
  };
})(
  // Among the various tricks for obtaining a reference to the global
  // object, this seems to be the most reliable technique that does not
  // use indirect eval (which violates Content Security Policy).
  typeof global === "object" ? global :
  typeof window === "object" ? window :
  typeof self === "object" ? self : this
);

/* WEBPACK VAR INJECTION */}.call(this, __webpack_require__(55)))

/***/ }),
/* 338 */
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(339);
module.exports = __webpack_require__(19).RegExp.escape;


/***/ }),
/* 339 */
/***/ (function(module, exports, __webpack_require__) {

// https://github.com/benjamingr/RexExp.escape
var $export = __webpack_require__(0);
var $re = __webpack_require__(340)(/[\\^$*+?.()|[\]{}]/g, '\\$&');

$export($export.S, 'RegExp', { escape: function escape(it) { return $re(it); } });


/***/ }),
/* 340 */
/***/ (function(module, exports) {

module.exports = function (regExp, replace) {
  var replacer = replace === Object(replace) ? function (part) {
    return replace[part];
  } : replace;
  return function (it) {
    return String(it).replace(regExp, replacer);
  };
};


/***/ }),
/* 341 */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__(342);


/***/ }),
/* 342 */
/***/ (function(module, exports, __webpack_require__) {

/* WEBPACK VAR INJECTION */(function(process) {if(!(typeof process !== 'undefined' && {}.toString.call(process) === '[object process]' || typeof document =='undefined')){
__webpack_require__(343);
}

const Mura=__webpack_require__(9);

__webpack_require__(344);
__webpack_require__(345);
__webpack_require__(346);
__webpack_require__(347);
__webpack_require__(348);
__webpack_require__(349);
__webpack_require__(350);
__webpack_require__(351);
__webpack_require__(352);
__webpack_require__(353);
__webpack_require__(354);
__webpack_require__(355);
__webpack_require__(356);
__webpack_require__(357);
__webpack_require__(358);
__webpack_require__(359);
__webpack_require__(360);
__webpack_require__(361);
__webpack_require__(362);

if(Mura.isInNode()){
	/*
		This is an attempt to hide the require('request') from webpack
		It's also ignored in the webpack.config.js
	*/
	Mura._request=eval("require('request')");
} else if (typeof window != 'undefined'){

	window.m=Mura;
	window.mura=Mura;
	window.Mura=Mura;
	window.validateForm=Mura.validateForm;
	window.setHTMLEditor=Mura.setHTMLEditor;
	window.createCookie=Mura.createCookie;
	window.readCookie=Mura.readCookie;
	window.addLoadEvent=Mura.addLoadEvent;
	window.noSpam=Mura.noSpam;
	window.initMura=Mura.init;
}

module.exports=Mura;

/* WEBPACK VAR INJECTION */}.call(this, __webpack_require__(133)))

/***/ }),
/* 343 */
/***/ (function(module, exports, __webpack_require__) {

if(typeof window !='undefined' && typeof window.document != 'undefined'){
	window.Element && function(ElementPrototype) {
		ElementPrototype.matchesSelector = ElementPrototype.matchesSelector ||
		ElementPrototype.mozMatchesSelector ||
		ElementPrototype.msMatchesSelector ||
		ElementPrototype.oMatchesSelector ||
		ElementPrototype.webkitMatchesSelector ||
		function (selector) {
			var node = this, nodes = (node.parentNode || node.document).querySelectorAll(selector), i = -1;
			while (nodes[++i] && nodes[i] != node);
			return !!nodes[i];
		}
	}(Element.prototype);

	//https://github.com/filamentgroup/loadCSS/blob/master/src/cssrelpreload.js
	/*! loadCSS. [c]2017 Filament Group, Inc. MIT License */
	/* This file is meant as a standalone workflow for
	- testing support for link[rel=preload]
	- enabling async CSS loading in browsers that do not support rel=preload
	- applying rel preload css once loaded, whether supported or not.
	*/
	(function( w ){
		"use strict";
		// rel=preload support test
		if( !w.loadCSS ){
			w.loadCSS = function(){};
		}
		// define on the loadCSS obj
		var rp = loadCSS.relpreload = {};
		// rel=preload feature support test
		// runs once and returns a function for compat purposes
		rp.support = (function(){
			var ret;
			try {
				ret = w.document.createElement( "link" ).relList.supports( "preload" );
			} catch (e) {
				ret = false;
			}
			return function(){
				return ret;
			};
		})();
		// if preload isn't supported, get an asynchronous load by using a non-matching media attribute
		// then change that media back to its intended value on load
		rp.bindMediaToggle = function( link ){
			// remember existing media attr for ultimate state, or default to 'all'
			var finalMedia = link.media || "all";

			function enableStylesheet(){
				link.media = finalMedia;
			}
			// bind load handlers to enable media
			if( link.addEventListener ){
				link.addEventListener( "load", enableStylesheet );
			} else if( link.attachEvent ){
				link.attachEvent( "onload", enableStylesheet );
			}
			// Set rel and non-applicable media type to start an async request
			// note: timeout allows this to happen async to let rendering continue in IE
			setTimeout(function(){
				link.rel = "stylesheet";
				link.media = "only x";
			});
			// also enable media after 3 seconds,
			// which will catch very old browsers (android 2.x, old firefox) that don't support onload on link
			setTimeout( enableStylesheet, 3000 );
		};
		// loop through link elements in DOM
		rp.poly = function(){
			// double check this to prevent external calls from running
			if( rp.support() ){
				return;
			}
			var links = w.document.getElementsByTagName( "link" );
			for( var i = 0; i < links.length; i++ ){
				var link = links[ i ];
				// qualify links to those with rel=preload and as=style attrs
				if( link.rel === "preload" && link.getAttribute( "as" ) === "style" && !link.getAttribute( "data-loadcss" ) ){
					// prevent rerunning on link
					link.setAttribute( "data-loadcss", true );
					// bind listeners to toggle media back
					rp.bindMediaToggle( link );
				}
			}
		};
		// if unsupported, run the polyfill
		if( !rp.support() ){
			// run once at least
			rp.poly();
			// rerun poly on an interval until onload
			var run = w.setInterval( rp.poly, 500 );
			if( w.addEventListener ){
				w.addEventListener( "load", function(){
					rp.poly();
					w.clearInterval( run );
				} );
			} else if( w.attachEvent ){
				w.attachEvent( "onload", function(){
					rp.poly();
					w.clearInterval( run );
				} );
			}
		}
		// commonjs
		if( true ){
			exports.loadCSS = loadCSS;
		}
		else {}
	}( window ) );
}


/***/ }),
/* 344 */
/***/ (function(module, exports, __webpack_require__) {


var Mura=__webpack_require__(9);

/**
* Creates a new Mura.Core
* @name Mura.Core
* @class
* @memberof Mura
* @param  {object} properties Object containing values to set into object
* @return {Mura.Core}
*/

function Core(){
	this.init.apply(this,arguments);
	return this;
}

/** @lends Mura.Core.prototype */
Core.prototype=
	{
	init:function(){},
	/**
	 * invoke - Invokes a method
	 *
	 * @param  {string} funcName Method to call
	 * @param  {object} params Arguments to submit to method
	 * @return {any}
	 */
	invoke:function(funcName,params){
		var self = this;
		params=params || {};

		if(this[funcName]=='function'){
			return this[funcName].apply(this,params);
		}
	},

	/**
	 * trigger - Triggers custom event on Mura objects
	 *
	 * @name Mura.Core.trigger
	 * @function
	 * @param  {string} eventName  Name of header
	 * @return {object}  Self
	 */
	trigger:function(eventName){
		eventName=eventName.toLowerCase();
		if(typeof this.prototype.handlers[eventName] != 'undefined'){
			var handlers=this.prototype.handlers[eventName];
			for(var handler in handlers){
				if(typeof handler.call == 'undefined'){
					handler(this);
				} else {
					handler.call(this,this);
				}

			}
		}

		return this;
	},
};

/** @lends Mura.Core.prototype */

/**
 * Extend - Allow the creation of new Mura core classes
 *
 * @name Mura.Core.extend
 * @function
 * @param  {object} properties  Properties to add to new class prototype
 * @return {class}  Self
 */
Core.extend=function(properties){
	var self=this;
	return Mura.extend(Mura.extendClass(self,properties),{extend:self.extend,handlers:[]});
};

Mura.Core=Core;


/***/ }),
/* 345 */
/***/ (function(module, exports, __webpack_require__) {


var Mura=__webpack_require__(9);

(function(Mura){
"use strict";	

/**
* Creates a new Mura.Request
* @name	Mura.Request
* @class
* @extends Mura.Core
* @memberof Mura
* @param	{object} request		 Siteid
* @param	{object} response Entity name
* @param	{object} requestHeaders Optional
* @return {Mura.Request}	Self
*/

Mura.Request=Mura.Core.extend(
	/** @lends Mura.Request.prototype */
	{
		init: function(request, response, headers) {
			this.requestObject=request;
			this.responseObject=response;
			this.requestHeaders=headers || {};
			return this;
		},

		/**
		* execute - Make ajax request
		*
		* @param	{object} params
		* @return {Promise}
		*/
		execute: function(params) {
			
			if (!('type' in params)) {
				params.type = 'GET';
			}
			if (!('success' in params)) {
				params.success = function() {};
			}
			if (!('data' in params)) {
				params.data = {};
			}
			if (!('headers' in params)) {
				params.headers = {};
			}
			if(typeof XMLHttpRequest == 'undefined'){
				this.nodeRequest(params);
			} else {
				this.xhrRequest(params);
			}
		},
		/**
		 * setRequestHeader - Initialiazes feed
		 *
		 * @param	{string} headerName	Name of header
		 * @param	{string} value Header value
		 * @return {Mura.RequestContext}						Self
		 */
		setRequestHeader:function(headerName,value){
			this.requestHeaders[headerName]=value;
			return this;
		},
		/**
		 * getRequestHeader - Returns a request header value
		 *
		 * @param	{string} headerName	Name of header
		 * @return {string} header Value
		 */
		getRequestHeader:function(headerName){
			 if(typeof this.requestHeaders[headerName] != 'undefined'){
				 return this.requestHeaders[headerName];
			 } else {
				 return null;
			 }
		},
		/**
		 * getRequestHeaders - Returns a request header value
		 *
		 * @return {object} All Headers
		 */
		getRequestHeaders:function(){
			return this.requestHeaders;
		},
		nodeRequest:function(params){
			var debug=typeof Mura.debug != 'undefined' && Mura.debug;
			var self=this;
			if(typeof this.requestObject != 'undefined'){
				params.headers['User-Agent']='MuraJS';
				if(typeof this.requestObject.headers['cookie'] != 'undefined'){
					if(debug){
						console.log('pre cookies:');
						console.log(this.requestObject.headers['cookie']);
					}
					params.headers['Cookie']=this.requestObject.headers['cookie'];
				}
				if(typeof this.requestObject.headers['x-client_id'] != 'undefined'){
					params.headers['X-client_id']=this.requestObject.headers['x-client_id'];
				}
				if(typeof this.requestObject.headers['x-client_id'] != 'undefined'){
					params.headers['X-client_id']=this.requestObject.headers['x-client_id'];
				}
				if(typeof this.requestObject.headers['X-client_secret'] != 'undefined'){
					params.headers['X-client_secret']=this.requestObject.headers['X-client_secret'];
				}
				if(typeof this.requestObject.headers['x-client_secret'] != 'undefined'){
					params.headers['X-client_secret']=this.requestObject.headers['x-client_secret'];
				}
				if(typeof this.requestObject.headers['X-access_token'] != 'undefined'){
					params.headers['X-access_token']=this.requestObject.headers['X-access_token'];
				}
				if(typeof this.requestObject.headers['x-access_token'] != 'undefined'){
					params.headers['X-access_token']=this.requestObject.headers['x-access_token'];
				}
				if(typeof this.requestObject.headers['x-client-id'] != 'undefined'){
					params.headers['X-client-id']=this.requestObject.headers['x-client-id'];
				}
				if(typeof this.requestObject.headers['x-clien-id'] != 'undefined'){
					params.headers['X-client-id']=this.requestObject.headers['x-client-id'];
				}
				if(typeof this.requestObject.headers['X-client_secret'] != 'undefined'){
					params.headers['X-client-secret']=this.requestObject.headers['X-client-secret'];
				}
				if(typeof this.requestObject.headers['x-client-secret'] != 'undefined'){
					params.headers['X-client-secret']=this.requestObject.headers['x-client-secret'];
				}
				if(typeof this.requestObject.headers['X-access-token'] != 'undefined'){
					params.headers['X-access-token']=this.requestObject.headers['X-access-token'];
				}
				if(typeof this.requestObject.headers['x-access-token'] != 'undefined'){
					params.headers['X-access-token']=this.requestObject.headers['x-access-token'];
				}
				if(typeof this.requestObject.headers['Authorization'] != 'undefined'){
					params.headers['Authorization']=this.requestObject.headers['Authorization'];
				}
				if(typeof this.requestObject.headers['authorization'] != 'undefined'){
					params.headers['Authorization']=this.requestObject.headers['authorization'];
				}
			}
			for(var h in Mura.requestHeaders){
					if(Mura.requestHeaders.hasOwnProperty(h)){
							params.headers[h]= Mura.requestHeaders[h];
					}
			}
			for(var h in this.requestHeaders){
					if(this.requestHeaders.hasOwnProperty(h)){
							params.headers[h]= this.requestHeaders[h];
					}
			}
			//console.log('pre:')
			//console.log(params.headers);
			//console.log(params.headers)
			if (params.type.toLowerCase() == 'post') {
					Mura._request.post(
						{
							url: params.url,
							formData: params.data,
							headers: params.headers
						},
						nodeResponseHandler
					);
			} else {
					if (params.url.indexOf('?') == -1) {
							params.url += '?';
					}
					var query = [];
					for (var key in params.data) {
							query.push(Mura.escape(key) + '=' + Mura.escape(params.data[key]));
					}
					if(typeof params.data['muraPointInTime'] == 'undefined' && typeof Mura.pointInTime != 'undefined'){
							query.push('muraPointInTime=' + Mura.escape(Mura.pointInTime));
					}
					query = query.join('&');
					Mura._request(
						{
							url: params.url + query,
							headers:params.headers
						},
						nodeResponseHandler
					);
			}

			function nodeResponseHandler(error, httpResponse, body) {
				var debug=typeof Mura.debug != 'undefined' && Mura.debug;
				if(typeof self.responseObject != 'undefined'
					&& typeof httpResponse != 'undefined'
					&& typeof httpResponse.headers != 'undefined'
					&& typeof httpResponse.headers['set-cookie'] != 'undefined'){
					var existingCookies=((typeof self.requestObject.headers['cookie'] != 'undefined') ? self.requestObject.headers['cookie'] : '').split("; ");
					var newSetCookies=httpResponse.headers['set-cookie'];
					if(debug){
						console.log('response cookies:');
						console.log(httpResponse.headers['set-cookie']);
					}
					if(!(newSetCookies instanceof Array)){
						newSetCookies=[newSetCookies];
					}
					self.responseObject.setHeader('Set-Cookie',newSetCookies);
					var cookieMap={};
					var setMap={};
					// pull out existing cookies
					if(existingCookies.length){
						for(var c in existingCookies){
							var tempCookie=existingCookies[c];
							if(typeof tempCookie != 'undefined'){
								tempCookie=existingCookies[c].split(" ")[0].split("=");
								if(tempCookie.length > 1){
									cookieMap[tempCookie[0]]=tempCookie[1].split(';')[0];
								}
							}
						}
					}
					if(debug){
						console.log('existing 1:');
						console.log(cookieMap);
					}
					// pull out new cookies
					if(newSetCookies.length){
						for(var c in newSetCookies){
							var tempCookie=newSetCookies[c];
							if(typeof tempCookie != 'undefined'){
								tempCookie=tempCookie.split(" ")[0].split("=");
								if(tempCookie.length > 1){
									cookieMap[tempCookie[0]]=tempCookie[1].split(';')[0];
								}
							}
						}
					}
					if(debug){
						console.log('existing 2:');
						console.log(cookieMap);
					}
					var cookie='';
					// put cookies back in in the same order that they came out
					if(existingCookies.length){
						for(var c in existingCookies){
							var tempCookie=existingCookies[c];
							if(typeof tempCookie != 'undefined'){
								tempCookie=tempCookie.split(" ")[0].split("=");
								if(tempCookie.length > 1){
									if(cookie != ''){
										cookie=cookie + "; ";
									}
									setMap[tempCookie[0]]=true;
									cookie=cookie + tempCookie[0] + "=" + cookieMap[tempCookie[0]];
								}
							}
						}
					}
					if(newSetCookies.length){
						for(var c in newSetCookies){
							var tempCookie=newSetCookies[c];
							if(typeof tempCookie != 'undefined'){
								var tempCookie=tempCookie.split(" ")[0].split("=");
								if(typeof setMap[tempCookie[0]] == 'undefined' && tempCookie.length > 1){
									if(cookie != ''){
										cookie=cookie + "; ";
									}
									setMap[tempCookie[0]]=true;
									cookie=cookie + tempCookie[0] + "=" + cookieMap[tempCookie[0]];
								}
							}
						}
					}
					self.requestObject.headers['cookie']=cookie;
					if(debug){
						console.log('merged cookies:');
						console.log(self.requestObject.headers['cookie']);
					}
				}
				if (typeof error == 'undefined' || ( typeof httpResponse != 'undefined' && httpResponse.statusCode >= 200 && httpResponse.statusCode < 400)) {
					try {
						var data = JSON.parse.call(null,body);
					} catch (e) {
						var data = body;
					}
					params.success(data, httpResponse);
				} else if (typeof error == 'undefined') {
					try {
						var data = JSON.parse.call(null,body);
					} catch (e) {
						var data = body;
					}
					if(typeof params.error == 'function'){
						params.error(data,httpResponse);
					} else {
						throw data;
					}
				} else {
					try {
						var data = JSON.parse.call(null,body);
					} catch (e) {
						var data = body;
					}
					if(typeof params.error == 'function'){
						params.error(data,httpResponse);
					} else {
						throw data;
					}
				}
			}
		},
		xhrRequest:function(params){
			var debug=typeof Mura.debug != 'undefined' && Mura.debug;
			for(var h in Mura.requestHeaders){
				if(Mura.requestHeaders.hasOwnProperty(h)){
					params.headers[h]= Mura.requestHeaders[h];
				}
			}
			for(var h in this.requestHeaders){
				if(this.requestHeaders.hasOwnProperty(h)){
					params.headers[h]= this.requestHeaders[h];
				}
			}
			if (!(Mura.formdata && params.data instanceof FormData)) {
				params.data = Mura.deepExtend({}, params.data);
				for (var p in params.data) {
					if (typeof params.data[p] == 'object') {
						params.data[p] = JSON.stringify(params.data[p]);
					}
				}
			}
			if (!('xhrFields' in params)) {
				params.xhrFields = {
					withCredentials: true
				};
			}
			if (!('crossDomain' in params)) {
				params.crossDomain = true;
			}
			if (!('async' in params)) {
				params.async = true;
			}
			var req = new XMLHttpRequest();

			if (params.crossDomain) {
				if (!("withCredentials" in req) && typeof XDomainRequest !=
					"undefined" && this.isXDomainRequest(params.url)) {
					// Check if the XMLHttpRequest object has a "withCredentials" property.
					// "withCredentials" only exists on XMLHTTPRequest2 objects.
					// Otherwise, check if XDomainRequest.
					// XDomainRequest only exists in IE, and is IE's way of making CORS requests.
					req = new XDomainRequest();
				}
			}

			if(typeof params.data != 'undefined' && typeof params.data.httpmethod != 'undefined'){
				params.type=params.data.httpmethod;
				delete params.data.httpmethod;
			}
			
			params.progress=params.progress || params.onProgress || params.onUploadProgress || function(){};
			params.abort=params.abort || params.onAbort|| function(){};
			params.success=params.success || params.onSuccess || function(){};
			params.error=params.error || params.onError || function(){};
			
			if(typeof req.addEventListener != 'undefined'){
				if(typeof params.progress == 'function'){
					req.addEventListener("progress", params.progress);
				}

				if(typeof params.abort == 'function'){
					req.addEventListener("abort", params.abort);
				}
			}			
			
			req.onreadystatechange = function() {
				if (req.readyState == 4) {
					//IE9 doesn't appear to return the request status
					if (typeof req.status == 'undefined' || (req.status >= 200 && req.status < 400)) {
						try {	
							var data=JSON.parse.call(null,req.responseText);
						} catch (e) {
							var data = req.response;
						}
						
						params.success(data, req);
					} else {
						if(debug && typeof req.responseText != 'undefined'){
							console.log(req.responseText);
						}
						if(typeof params.error == 'function'){
							try {
								var data = JSON.parse.call(null,req.responseText);
							} catch (e) {
								var data = req.responseText;
							}
							params.error(data);
						} else {
							throw req;
						}
					}
				}
			}
			if (params.type.toLowerCase() == 'post') {
				req.open(params.type.toUpperCase(), params.url, params.async);
				for (var p in params.xhrFields) {
						if (p in req) {
							req[p] = params.xhrFields[p];
						}
				}
				for (var h in params.headers) {
						req.setRequestHeader(p, params.headers[h]);
				}
				if (Mura.formdata && params.data instanceof FormData) {
					try{
						req.send(params.data);
					} catch(e){
						if(typeof params.error == 'function'){
							try {
								var data = JSON.parse.call(null,req.responseText);
							} catch (e) {
								var data = req.responseText;
							}
							params.error(data,e);
						} else {
							throw e;
						}
					}
				} else {
					req.setRequestHeader('Content-Type',
							'application/x-www-form-urlencoded; charset=UTF-8'
					);
					var query = [];
					for (var key in params.data) {
							query.push(Mura.escape(key) + '=' + Mura.escape(params.data[
									key]));
					}
					if(typeof params.data['muraPointInTime'] == 'undefined' && typeof Mura.pointInTime != 'undefined'){
							query.push('muraPointInTime=' + Mura.escape(Mura.pointInTime));
					}
					query = query.join('&');
					setTimeout(function() {
						try{
							req.send(query);
						} catch(e){
							if(typeof params.error == 'function'){
								try {
									var data = JSON.parse.call(null,req.responseText);
								} catch (e) {
									var data = req.responseText;
								}
								params.error(data,e);
							} else {
								throw e;
							}
						}
					}, 0);
				}
			} else {
				if (params.url.indexOf('?') == -1) {
					params.url += '?';
				}
				var query = [];
				for (var key in params.data) {
					query.push(Mura.escape(key) + '=' + Mura.escape(params.data[key]));
				}
				if(typeof params.data['muraPointInTime'] == 'undefined' && typeof Mura.pointInTime != 'undefined'){
					query.push('muraPointInTime=' + Mura.escape(Mura.pointInTime));
				}
				query = query.join('&');

				req.open(params.type.toUpperCase(), params.url + '&' + query, params.async);
				for (var p in params.xhrFields) {
					if (p in req) {
						req[p] = params.xhrFields[p];
					}
				}
				for (var h in params.headers) {
					req.setRequestHeader(p, params.headers[h]);
				}
				setTimeout(function() {
					try{
						req.send();
					} catch(e){
						if(typeof params.error == 'function'){
							if(typeof req.responseText != 'undefined'){
								try {
									var data = JSON.parse.call(null,req.responseText);
								} catch (e) {
									var data = req.responseText;
								}
								params.error(data,e);
							} else {
								params.error(req,e);
							}
						} else {
							throw e;
						}
					}
				}, 0);
			}
		},

		isXDomainRequest:function(url) {
			function getHostName(url) {
				var match = url.match(/:\/\/([0-9]?\.)?(.[^/:]+)/i);
				if (match != null && match.length > 2 && typeof match[2] ===
					'string' && match[2].length > 0) {
					return match[2];
				} else {
					return null;
				}
			}

			function getDomain(url) {
				var hostName = getHostName(url);
				var domain = hostName;
				if (hostName != null) {
					var parts = hostName.split('.').reverse();
					if (parts != null && parts.length > 1) {
						domain = parts[1] + '.' + parts[0];
						if (hostName.toLowerCase().indexOf('.co.uk') != -1 &&
							parts.length > 2) {
							domain = parts[2] + '.' + domain;
						}
					}
				}
				return domain;
			}
			var requestDomain = getDomain(url);
			return (requestDomain && requestDomain != location.host);
		}
	}
);
})(Mura);


/***/ }),
/* 346 */
/***/ (function(module, exports, __webpack_require__) {


var Mura=__webpack_require__(9);

(function(Mura){
"use strict";

/**
* Creates a new Mura.RequestContext
* @name	Mura.RequestContext
* @class
* @extends Mura.Core
* @memberof Mura
* @param	{object} request		 Siteid
* @param	{object} response Entity name
* @param	{object} requestHeaders Optional
* @return {Mura.RequestContext} Self
*/

Mura.RequestContext=Mura.Core.extend(
/** @lends Mura.RequestContext.prototype */
{
	init: function(request, response, requestHeaders) {
		this.requestObject=request;
		this.responseObject=response;
		this._request=new Mura.Request(request, response, requestHeaders);
		return this;
	},

	/**
	 * setRequestHeader - Initialiazes feed
	 *
	 * @param	{string} headerName	Name of header
	 * @param	{string} value Header value
	 * @return {Mura.RequestContext}	Self
	 */
	setRequestHeader:function(headerName,value){
		this._request.setRequestHeader(headerName,value);
		return this;
	},

	/**
	 * getRequestHeader - Returns a request header value
	 *
	 * @param	{string} headerName	Name of header
	 * @return {string} header Value
	 */
	getRequestHeader:function(headerName){
		return this._request.getRequestHeader(headerName);
	},

	/**
	 * getRequestHeaders - Returns a request header value
	 *
	 * @return {object} All Headers
	 */
	getRequestHeaders:function(){
		return this._request.getRequestHeaders();
	},

	/**
	 * request - Executes a request
	 *
	 * @param	{object} params		 Object
	 * @return {Promise}						Self
	 */
	request:function(params){
		return this._request.execute(params);
	},

	/**
	 * renderFilename - Returns "Rendered" JSON object of content
	 *
	 * @param	{type} filename Mura content filename
	 * @param	{type} params Object
	 * @return {Promise}
	 */
	renderFilename:function(filename, params) {
		var query = [];
		var self=this;
		params = params || {};
		params.filename = params.filename || '';
		params.siteid = params.siteid || Mura.siteid;

		for (var key in params) {
			if (key != 'entityname' && key != 'filename' && key !=
				'siteid' && key != 'method') {
				query.push(encodeURIComponent(key) + '=' + encodeURIComponent(params[key]));
			}
		}

		return new Promise(function(resolve, reject) {
			self.request({
				async: true,
				type: 'get',
				url: Mura.apiEndpoint + '/content/_path/' + filename + '?' + query.join('&'),
				success: function(resp) {
					if (resp != null && typeof location != 'undefined' && typeof resp.data != 'undefined' && typeof resp.data.redirect != 'undefined' && typeof resp.data.contentid == 'undefined') {
						if (resp.data.redirect && resp.data.redirect != location.href) {
							location.href = resp.data.redirect;
						} else {
							location.reload(true);
						}
					} else {
						var item = new Mura.entities.Content({},self);
						item.set(resp.data);
						resolve(item);
					}
				},
				error: function(resp) {
					if (resp != null && typeof resp.data != 'undefined' && typeof resp.data != 'undefined' && typeof resolve == 'function') {
						var item = new Mura.entities.Content({},self);
						item.set(resp.data);
						resolve(item);
					} else if (typeof reject == 'function') {
						reject(resp);
					}
				}
			});
		});
	},

	/**
	 * getEntity - Returns Mura.Entity instance
	 *
	 * @param	{string} entityname Entity Name
	 * @param	{string} siteid		 Siteid
	 * @return {Mura.Entity}
	 */
	getEntity:function(entityname, siteid) {
		if (typeof entityname == 'string') {
			var properties = {
				entityname: entityname.substr(0, 1).toUpperCase() + entityname.substr(1)
			};
			properties.siteid = siteid || Mura.siteid;
		} else {
			properties = entityname;
			properties.entityname = properties.entityname || 'Content';
			properties.siteid = properties.siteid || Mura.siteid;
		}

		properties.links={
			permissions:Mura.apiEndpoint + properties.entityname + "/permissions"
		}

		if (Mura.entities[properties.entityname]) {
			var entity=new Mura.entities[properties.entityname](properties,this);
			return entity;
		} else {
			var entity=new Mura.Entity(properties,this);
			return entity;
		}
	},

	/**
	 * declareEntity - Declare Entity with in service factory
	 *
	 * @param	{object} entityConfig Entity config object
	 * @return {Promise}
	 */
	declareEntity:function(entityConfig) {
		var self=this;
		if(Mura.mode.toLowerCase() == 'rest'){
			return new Promise(function(resolve, reject) {
				self.request({
					async: true,
					type: 'POST',
					url: Mura.apiEndpoint,
					data:{
						method: 'declareEntity',
						entityConfig: encodeURIComponent(JSON.stringify(entityConfig))
					},
					success: function(resp) {
						if (typeof resolve =='function' && resp != null && typeof resp.data != 'undefined') {
							resolve(resp.data);
						} else if (typeof reject =='function' && resp != null && typeof resp.error != 'undefined') {
							resolve(resp);
						} else if (typeof resolve =='function'){
							resolve(resp);
						}
					}
				});
			});
		} else {
			return new Promise(function(resolve, reject) {
				self.request({
					type: 'POST',
					url: Mura.apiEndpoint + '?method=generateCSRFTokens',
					data: {context: ''},
					success: function(resp) {
						self.request({
							async: true,
							type: 'POST',
							url: Mura.apiEndpoint,
							data:{
								method: 'declareEntity',
								entityConfig: encodeURIComponent(JSON.stringify(entityConfig)),
								'csrf_token': resp.data.csrf_token,
								'csrf_token_expires': resp.data.csrf_token_expires
							},
							success: function(resp) {
								if (typeof resolve =='function' && resp != null && typeof resp.data != 'undefined') {
									resolve(resp.data);
								} else if (typeof reject =='function' && resp != null && typeof resp.error != 'undefined') {
									resolve(resp);
								} else if (typeof resolve =='function'){
									resolve(resp);
								}
							}
						});
					}
				});
			});
		}
	},

	/**
	 * undeclareEntity - Delete entity class from Mura
	 *
	 * @param	{object} entityName
	 * @return {Promise}
	 */
	undeclareEntity:function(entityName,deleteSchema) {
		var self=this;
		deleteSchema=deleteSchema || false;
		if(Mura.mode.toLowerCase() == 'rest'){
			return new Promise(function(resolve, reject) {
				self.request({
					async: true,
					type: 'POST',
					url: Mura.apiEndpoint,
					data:{
						method: 'undeclareEntity',
						entityName: entityName,
						deleteSchema : deleteSchema
					},
					success: function(resp) {
						if (typeof resolve =='function' && resp != null && typeof resp.data != 'undefined') {
							resolve(resp.data);
						} else if (typeof reject =='function' && resp != null && typeof resp.error != 'undefined') {
							resolve(resp);
						} else if (typeof resolve =='function'){
							resolve(resp);
						}
					}
				});
			});
		} else {
			return new Promise(function(resolve, reject) {
				self.request({
					type: 'POST',
					url: Mura.apiEndpoint + '?method=generateCSRFTokens',
					data: {context: ''},
					success: function(resp) {
						self.request({
							async: true,
							type: 'POST',
							url: Mura.apiEndpoint,
							data:{
								method: 'undeclareEntity',
								entityName: entityName,
								deleteSchema : deleteSchema,
								'csrf_token': resp.data.csrf_token,
								'csrf_token_expires': resp.data.csrf_token_expires
							},
							success: function(resp) {
								if (typeof resolve =='function' && resp != null && typeof resp.data != 'undefined') {
									resolve(resp.data);
								} else if (typeof reject =='function' && resp != null && typeof resp.error != 'undefined') {
									resolve(resp);
								} else if (typeof resolve =='function'){
									resolve(resp);
								}
							}
						});
					}
				});
			});
		}
	},

	/**
	 * getFeed - Return new instance of Mura.Feed
	 *
	 * @param	{type} entityname Entity name
	 * @return {Mura.Feed}
	 */
	getFeed:function(entityname,siteid) {
			siteid=siteid || Mura.siteid;
			var feed=new Mura.Feed(siteid, entityname, this);
			return feed;
	},

	/**
	 * getCurrentUser - Return Mura.Entity for current user
	 *
	 * @param	{object} params Load parameters, fields:listoffields
	 * @return {Promise}
	 */
	getCurrentUser:function(params) {
			var self=this;
			params=params || {};
			params.fields=params.fields || '';
			return new Promise(function(resolve, reject) {
				if (Mura.currentUser) {
					resolve(Mura.currentUser);
				} else {
					self.request({
						async: true,
						type: 'get',
						url: Mura.apiEndpoint +
							'findCurrentUser?fields=' + params.fields + '&_cacheid=' +
							Math.random(),
						success: function(resp) {
							if (typeof resolve =='function') {
								Mura.currentUser = self.getEntity('user');
								Mura.currentUser.set(resp.data);
								resolve(Mura.currentUser);
							}
						},
						error: function(resp) {
							if (typeof resolve =='function') {
								Mura.currentUser=self.getEntity('user')
								Mura.currentUser.set( resp.data);
								resolve(Mura.currentUser);
							}
						}
					});
				}
			});
	},

	/**
	 * findQuery - Returns Mura.EntityCollection with properties that match params
	 *
	 * @param	{object} params Object of matching params
	 * @return {Promise}
	 */
	findQuery:function(params) {
			var self=this;
			params = params || {};
			params.entityname = params.entityname || 'content';
			params.siteid = params.siteid || Mura.siteid;
			params.method = params.method || 'findQuery';
			params['_cacheid'] == Math.random();
			return new Promise(function(resolve, reject) {
				self.request({
					type: 'get',
					url: Mura.apiEndpoint,
					data: params,
					success: function(resp) {
						var collection = new Mura.EntityCollection(resp.data,self)
						if (typeof resolve == 'function') {
							resolve(collection);
						}
					},
					error:function(resp){
						console.log(resp);
					}
				});
			});
	},

	/**
	 * login - Logs user into Mura
	 *
	 * @param	{string} username Username
	 * @param	{string} password Password
	 * @param	{string} siteid	 Siteid
	 * @return {Promise}
	 */
	login:function(username, password, siteid) {
		siteid = siteid || Mura.siteid;
		var self=this;
		return new Promise(function(resolve, reject) {
			self.request({
				type: 'post',
				url: Mura.apiEndpoint +
						'?method=generateCSRFTokens',
				data: {
						siteid: siteid,
						context: 'login'
				},
				success: function(resp) {
					self.request({
						async: true,
						type: 'post',
						url: Mura.apiEndpoint,
						data: {
							siteid: siteid,
							username: username,
							password: password,
							method: 'login',
							'csrf_token': resp.data.csrf_token,
							'csrf_token_expires': resp.data.csrf_token_expires
						},
						success: function(resp) {
							resolve(resp.data);
						}
					});
				}
			});
		});
	},

	/**
	* openGate - Open's content gate when using MXP
	*
	* @param	{string} contentid Optional: default's to Mura.contentid
	* @return {Promise}
	* @memberof {class
	*/
	openGate:function(contentid) {
		var self=this;
		contentid=contentid || Mura.contentid;
		if(contentid){
			if(Mura.mode.toLowerCase() == 'rest'){
				return new Promise(function(resolve, reject) {
					self.request({
						async: true,
						type: 'POST',
						url: Mura.apiEndpoint + '/gatedasset/open',
						data:{
							contentid: contentid
						},
						success: function(resp) {
							if (typeof resolve =='function' && typeof resp.data != 'undefined') {
								resolve(resp.data);
							} else if (typeof reject =='function' && typeof resp.error != 'undefined') {
								resolve(resp);
							} else if (typeof resolve =='function'){
								resolve(resp);
							}
						}
					});
				});
			} else {
				return new Promise(function(resolve, reject) {
					self.request({
						type: 'POST',
						url: Mura.apiEndpoint + '?method=generateCSRFTokens',
						data: {context: contentid},
						success: function(resp) {
							self.request({
								async: true,
								type: 'POST',
								url: Mura.apiEndpoint + '/gatedasset/open',
								data:{
									contentid: contentid
								},
								success: function(resp) {
									if (typeof resolve =='function' && typeof resp.data != 'undefined') {
										resolve(resp.data);
									} else if (typeof reject =='function' && typeof resp.error != 'undefined') {
										resolve(resp);
									} else if (typeof resolve =='function'){
										resolve(resp);
									}
								}
							});
						}
					});
				});
			}
		}
	},

	/**
	 * logout - Logs user out
	 *
	 * @param	{type} siteid Siteid
	 * @return {Promise}
	 */
	logout:function(siteid) {
		siteid = siteid || Mura.siteid;
		var self=this;
		return new Promise(function(resolve, reject) {
			self.request({
				async: true,
				type: 'post',
				url: Mura.apiEndpoint,
				data: {
					siteid: siteid,
					method: 'logout'
				},
				success: function(resp) {
					resolve(resp.data);
				}
			});
		});
	},

	/**
	 * get - Make GET request
	 *
	 * @param	{url} url	URL
	 * @param	{object} data Data to send to url
	 * @return {Promise}
	 */
	get:function(url, data, eventHandler) {
		if(typeof url == 'object'){
			data=url.data;
			eventHander=url;
			url=url.url;
		} else {
			eventHandler=eventHandler || {};
		}

		Mura.normalizeRequestHandler(eventHandler);

		var self=this;
		data = data || {};

		return new Promise(function(resolve, reject) {

			if(typeof resolve == 'function'){
				eventHandler.success=resolve;
			}

			if(typeof reject == 'function'){
				eventHandler.error=reject;
			}

			return self.request({
				type: 'get',
				url: url,
				data: data,
				success: eventHandler.success,
				error: eventHandler.error,
				progress:eventHandler.progress,
				abort: eventHandler.abort
			});
		});
	},

	/**
	 * post - Make POST request
	 *
	 * @param	{url} url	URL
	 * @param	{object} data Data to send to url
	 * @return {Promise}
	 */
	post:function(url, data, eventHandler) {
		if(typeof url == 'object'){
			data=url.data;
			eventHander=url;
			url=url.url;
		} else {
			eventHandler=eventHandler || {};
		}

		Mura.normalizeRequestHandler(eventHandler);

		var self=this;
		data = data || {};

		return new Promise(function(resolve, reject) {

			if(typeof resolve == 'function'){
				eventHandler.success=resolve;
			}

			if(typeof reject == 'function'){
				eventHandler.error=reject;
			}

			return self.request({
				type: 'post',
				url: url,
				data: data,
				success: eventHandler.success,
				error: eventHandler.error,
				progress:eventHandler.progress,
				abort: eventHandler.abort
			});
		});
	},

	/**
	 * Request Headers
	**/
	requestHeaders:{}

});
})(Mura);


/***/ }),
/* 347 */
/***/ (function(module, exports, __webpack_require__) {


var Mura=__webpack_require__(9);
/**
 * Creates a new Mura.Cache
 * @name Mura.Cache
 * @class
 * @extends Mura.Core
 * @memberof	Mura
 * @return {Mura.Cache}
 */

Mura.Cache=Mura.Core.extend(
	/** @lends Mura.Cache.prototype */
	{
	init:function(){
		this.cache={};
		return this;
	},

	/**
	 * getKey - Returns Key value associated with key Name
	 *
	 * @param	{string} keyName Key Name
	 * @return {*}				 Key Value
	 */
	getKey:function(keyName){
		return Mura.hashCode(keyName);
	},

	/**
	 * get - Returns the value associated with key name
	 *
	 * @param	{string} keyName	description
	 * @param	{*} keyValue Default Value
	 * @return {*}
	 */
	get:function(keyName,keyValue){
		var key=this.getKey(keyName);
		if(typeof this.cache[key] != 'undefined'){
			return this.cache[key].keyValue;
		} else if (typeof keyValue != 'undefined') {
			this.set(keyName,keyValue,key);
			return this.cache[key].keyValue;
		} else {
			return;
		}
	},

	/**
	 * set - Sets and returns key value
	 *
	 * @param	{string} keyName	Key Name
	 * @param	{*} keyValue Key Value
	 * @param	{string} key			Key
	 * @return {*}
	 */
	set:function(keyName,keyValue,key){
		key=key || this.getKey(keyName);
		this.cache[key]={name:keyName,value:keyValue};
		return keyValue;
	},

	/**
	 * has - Returns if the key name has a value in the cache
	 *
	 * @param	{string} keyName Key Name
	 * @return {boolean}
	 */
	has:function(keyName){
		return typeof this.cache[getKey(keyName)] != 'undefined';
	},

	/**
	 * getAll - Returns object containing all key and key values
	 *
	 * @return {object}
	 */
	getAll:function(){
		return this.cache;
	},

	/**
	 * purgeAll - Purges all key/value pairs from cache
	 *
	 * @return {object}	Self
	 */
	purgeAll:function(){
		this.cache={};
		return this;
	},

	/**
	 * purge - Purges specific key name from cache
	 *
	 * @param	{string} keyName Key Name
	 * @return {object}				 Self
	 */
	purge:function(keyName){
		var key=this.getKey(keyName)
		if( typeof this.cache[key] != 'undefined')
		delete this.cache[key];
		return this;
	}
});

Mura.datacache=new Mura.Cache();


/***/ }),
/* 348 */
/***/ (function(module, exports, __webpack_require__) {


var Mura=__webpack_require__(9);

/**
* Creates a new Mura.Entity
* @name	Mura.Entity
* @class
* @extends Mura.Core
* @memberof Mura
* @param	{object} properties Object containing values to set into object
* @return {Mura.Entity}
*/

Mura.Entity = Mura.Core.extend(
/** @lends Mura.Entity.prototype */
{
	init: function(properties,requestcontext) {
		properties = properties || {};
		properties.entityname = properties.entityname || 'content';
		properties.siteid = properties.siteid || Mura.siteid;
		this.set(properties);

		if (typeof this.properties.isnew == 'undefined') {
			this.properties.isnew = 1;
		}

		if (this.properties.isnew) {
			this.set('isdirty', true);
		} else {
			this.set('isdirty', false);
		}

		if (typeof this.properties.isdeleted ==	'undefined') {
			this.properties.isdeleted = false;
		}

		this._requestcontext=requestcontext || Mura._requestcontext;

		this.cachePut();

		return this;
	},

	/**
	 * setRequestContext - Sets the RequestContext
	 *
	 * @RequestContext	{Mura.RequestContext} Mura.RequestContext List of fields
	 * @return {Mura.Feed}				Self
	 */
	setRequestContext: function(requestcontext) {
		this._requestcontext=requestcontext;
		return this;
	},

	/**
	 * getEnpoint - Returns API endpoint for entity type
	 *
	 * @return {string} All Headers
	 */
	getApiEndPoint:function(){
		return	Mura.apiEndpoint + this.get('entityname') + '/';
	},

	/**
	 * invoke - Invokes a method
	 *
	 * @param	{string} name Method to call
	 * @param	{object} params Arguments to submit to method
	 * @param	{string} method GET or POST
	 * @return {any}
	 */
	invoke:function(name,params,method,eventHandler){
		if(typeof name == 'object'){
			params=name.params || {};
			method=name.method || 'get';
			eventHandler=name;
			name=name.name;
		} else {
			eventHandler=eventHandler || {};
		}

		Mura.normalizeRequestHandler(eventHandler);

		var self = this;

		if(typeof method=='undefined' && typeof params=='string'){
			method=params;
			params={};
		}

		params=params || {};
		method=method || "post";

		if(this[name]=='function'){
			return this[name].apply(this,params);
		}

		return new Promise(function(resolve,reject) {

			if(typeof resolve == 'function'){
				eventHandler.success=resolve;
			}

			if(typeof reject == 'function'){
				eventHandler.error=reject;
			}

			if(params instanceof FormData){
				params.append('_cacheid',Math.random());
			} else {
				params._cacheid=Math.random();
			}

			self._requestcontext.request({
				type: method.toLowerCase(),
				url: self.getApiEndPoint() + name,
				data: params,
				success: function(resp) {
					if (resp.data != 'undefined'	) {
						if (typeof 	eventHandler.success ==	'function') {
							eventHandler.success(resp.data);
						}
					} else {
						if (typeof eventHandler.error == 'function') {
							eventHandler.error(resp);
						}
					}
				},
				error: function(resp) {
					resp=Mura.parseString(resp.response);
					if (typeof eventHandler.error == 'function'){
						eventHandler.error(resp);
					}
				},
				progress:eventHandler.progress,
				abort: eventHandler.abort
			});
		});
	},

	/**
	 * invokeWithCSRF - Proxies method call to remote api, but first generates CSRF tokens based on name
	 *
	 * @param	{string} name Method to call
	 * @param	{object} params Arguments to submit to method
	 * @param	{string} method GET or POST
	 * @return {Promise} All Headers
	 */
	invokeWithCSRF:function(name,params,method,eventHandler){
		if(typeof name == 'object'){
			params=name.params || {};
			method=name.method || 'get';
			eventHandler=name;
			name=name.name;
		} else {
			eventHandler=eventHandler || {};
		}

		Mura.normalizeRequestHandler(eventHandler);

		if(Mura.mode.toLowerCase() == 'rest'){

			return new Promise(function(resolve,reject) {
				return self.invoke(
					name,
					params,
					method,
					eventHandler
				).then(resolve,reject);
			});
		} else {
			var self = this;
			return new Promise(function(resolve,reject) {
				if(typeof resolve == 'function'){
					eventHandler.success=resolve;
				}

				if(typeof reject == 'function'){
					eventHandler.error=reject;
				}
				self._requestcontext.request({
					type: 'post',
					url: Mura.apiEndpoint + '?method=generateCSRFTokens',
					data: {
						siteid: self.get('siteid'),
						context: name
					},
					success: function(resp) {

						if(params instanceof FormData){
							params.append('csrf_token',resp.data.csrf_token);
							params.append('csrf_token_expires',resp.data.csrf_token_expires);
						} else {
							params=Mura.extend(params,resp.data);
						}

						if (resp.data != 'undefined'	) {
							self.invoke(
								name,
								params,
								method,
								eventHandler
							).then(resolve,reject);
						} else {
							if (typeof eventHandler.error == 'function'){
								eventHandler.error(resp);
							}
						}
					},
					error: function(resp) {
						resp=Mura.parseString(resp.response);
						if (typeof eventHandler.error == 'function'){
							eventHandler.error(resp);
						}
					}
				});
			});
		}
	},

	/**
	 * exists - Returns if the entity was previously saved
	 *
	 * @return {boolean}
	 */
	exists: function() {
		return this.has('isnew') && !this.get('isnew');
	},

	/**
	 * get - Retrieves property value from entity
	 *
	 * @param	{string} propertyName Property Name
	 * @param	{*} defaultValue Default Value
	 * @return {*}							Property Value
	 */
	get: function(propertyName, defaultValue) {
		if (typeof this.properties.links != 'undefined' &&
			typeof this.properties.links[propertyName] != 'undefined') {
			var self = this;
			if (typeof this.properties[propertyName] == 'object') {
				return new Promise(function(resolve,reject) {
					if ('items' in self.properties[propertyName]) {
						var returnObj = new Mura.EntityCollection(self.properties[propertyName],self._requestcontext);
					} else {
						if (Mura.entities[self.properties[propertyName].entityname]) {
							var returnObj = new Mura.entities[self.properties[propertyName ].entityname](self.properties[propertyName],self._requestcontext);
						} else {
							var returnObj = new Mura.Entity(self.properties[propertyName],self._requestcontext);
						}
					}
					if (typeof resolve == 'function') {
						resolve(returnObj);
					}
				});
			} else {
				if (typeof defaultValue == 'object') {
					var params = defaultValue;
				} else {
					var params = {};
				}
				return new Promise(function(resolve,reject) {
					self._requestcontext.request({
						type: 'get',
						url: self.properties.links[propertyName],
						params: params,
						success: function(resp) {
							if (
								'items' in resp.data
							) {
								var returnObj = new Mura.EntityCollection(resp.data,self._requestcontext);
							} else {
								if (Mura.entities[self.entityname]) {
									var returnObj = new Mura.entities[self.entityname](resp.data,self._requestcontext);
								} else {
									var returnObj = new Mura.Entity(resp.data,self._requestcontext);
								}
							}
							//Dont cache if there are custom params
							if (Mura.isEmptyObject(params)) {
								self.set(propertyName,resp.data);
							}
							if (typeof resolve == 'function') {
								resolve(returnObj);
							}
						},
						error: function(resp){
							resp=Mura.parseString(resp.response);
							if (typeof reject == 'function'){
								reject(resp);
							}
						}
					});
				});
			}
		} else if (typeof this.properties[propertyName] != 'undefined') {
			return this.properties[propertyName];
		} else if (typeof defaultValue != 'undefined') {
			this.properties[propertyName] = defaultValue;
			return this.properties[propertyName];
		} else {
			return '';
		}
	},

	/**
	 * set - Sets property value
	 *
	 * @param	{string} propertyName	Property Name
	 * @param	{*} propertyValue Property Value
	 * @return {Mura.Entity} Self
	 */
	set: function(propertyName, propertyValue) {
		if (typeof propertyName == 'object') {
			this.properties = Mura.deepExtend(this.properties,propertyName);
			this.set('isdirty', true);
		} else if (typeof this.properties[propertyName] == 'undefined' || this.properties[propertyName] != propertyValue) {
			this.properties[propertyName] = propertyValue;
			this.set('isdirty', true);
		}

		return this;
	},


	/**
	 * has - Returns is the entity has a certain property within it
	 *
	 * @param	{string} propertyName Property Name
	 * @return {type}
	 */
	has: function(propertyName) {
		return typeof this.properties[propertyName] !=
			'undefined' || (typeof this.properties.links !=
			'undefined' && typeof this.properties.links[propertyName] != 'undefined');
	},


	/**
	 * getAll - Returns all of the entities properties
	 *
	 * @return {object}
	 */
	getAll: function() {
		return this.properties;
	},


	/**
	 * load - Loads entity from JSON API
	 *
	 * @return {Promise}
	 */
	load: function() {
		return this.loadBy('id', this.get('id'));
	},


	/**
	 * new - Loads properties of a new instance from JSON API
	 *
	 * @param	{type} params Property values that you would like your new entity to have
	 * @return {Promise}
	 */
	'new': function(params) {
		var self = this;
		return new Promise(function(resolve, reject) {
			params = Mura.extend({
				entityname: self.get('entityname'),
				method: 'findNew',
				siteid: self.get('siteid'),
				'_cacheid': Math.random()
			},
				params
			);
			Mura.get(Mura.apiEndpoint, params).then(
				function(resp) {
					self.set(resp.data);
					if (typeof resolve == 'function') {
						resolve(self);
					}
			});
		});
	},

	/**
	 * checkSchema - Checks the schema for Mura ORM entities
	 *
	 * @return {Promise}
	 */
	'checkSchema': function() {
		var self = this;
		return new Promise(function(resolve, reject) {
			if(Mura.mode.toLowerCase() == 'rest'){
				self._requestcontext.request({
					type: 'post',
					url: Mura.apiEndpoint,
					data:{
						entityname: self.get('entityname'),
						method: 'checkSchema',
						siteid: self.get('siteid'),
						'_cacheid': Math.random()
					},
					success: function(	resp) {
						if (resp.data != 'undefined'	) {
							if (typeof resolve ==	'function') {
								resolve(self);
							}
						} else {
							self.set('errors',resp.error);
							if (typeof reject == 'function') {
								reject(self);
							}
						}
					}
				});
			} else {
				self._requestcontext.request({
					type: 'post',
					url: Mura.apiEndpoint + '?method=generateCSRFTokens',
					data: {
						siteid: self.get('siteid'),
						context: ''
					},
					success: function(resp) {
						self._requestcontext.request({
							type: 'post',
							url: Mura.apiEndpoint,
							data: Mura
							.extend(
							{
								entityname: self.get('entityname'),
								method: 'checkSchema',
								siteid: self.get('siteid'),
								'_cacheid': Math.random()
							}, {
								'csrf_token': resp.data.csrf_token,
								'csrf_token_expires': resp.data.csrf_token_expires
							}),
							success: function(	resp) {
								if (resp.data != 'undefined'	) {
									if (typeof resolve ==	'function') {
										resolve(self);
									}
								} else {
									self.set('errors',resp.error);
									if (typeof reject == 'function') {
										reject(self);
									}
								}
							},
							error: function(resp) {
								this.success(Mura.parseString(resp.response));
							}
						});
					},
					error: function(resp) {
						this.success(Mura.parseString(resp.response));
					}
				});
			}
		});

	},

	/**
	 * undeclareEntity - Undeclares an Mura ORM entity with service factory
	 *
	 * @return {Promise}
	 */
	'undeclareEntity': function(deleteSchema) {
		deleteSchema=deleteSchema || false;
		var self = this;
		return new Promise(function(resolve, reject) {
			if(Mura.mode.toLowerCase() == 'rest'){
				self._requestcontext.request({
					type: 'post',
					url: Mura.apiEndpoint,
					data: {
						entityname: self.get('entityname'),
						deleteSchema: deleteSchema,
						method: 'undeclareEntity',
						siteid: self.get('siteid'),
						'_cacheid': Math.random()
					},
					success: function(	resp) {
						if (resp.data != 'undefined'	) {
							if (typeof resolve ==	'function') {
								resolve(self);
							}
						} else {
							self.set('errors',resp.error);
							if (typeof reject == 'function') {
								reject(self);
							}
						}
					},
					error:function(resp){
						this.success(Mura.parseString(resp.response));
					}
				});
			} else {
				return self._requestcontext.request({
					type: 'post',
					url: Mura.apiEndpoint + '?method=generateCSRFTokens',
					data: {
						siteid: self.get('siteid'),
						context: ''
					},
					success: function(resp) {
						self._requestcontext.request({
							type: 'post',
							url: Mura.apiEndpoint,
							data: Mura
							.extend(	{
								entityname: self.get('entityname'),
								method: 'undeclareEntity',
								siteid: self.get('siteid'),
								'_cacheid': Math.random()
							}, {
								'csrf_token': resp.data.csrf_token,
								'csrf_token_expires': resp.data.csrf_token_expires
							}),
							success: function(resp) {
								if (resp.data != 'undefined'	) {
									if (typeof resolve ==	'function') {
										resolve(self);
									}
								} else {
									self.set('errors',resp.error);
									if (typeof reject == 'function') {
										reject(self);
									}
								}
							}
						});
					},
					error: function(resp) {
						this.success(Mura.parseString(resp.response));
					}
				});
			}
		});

	},


	/**
	 * loadBy - Loads entity by property and value
	 *
	 * @param	{string} propertyName	The primary load property to filter against
	 * @param	{string|number} propertyValue The value to match the propert against
	 * @param	{object} params				Addition parameters
	 * @return {Promise}
	 */
	loadBy: function(propertyName, propertyValue, params) {
		propertyName = propertyName || 'id';
		propertyValue = propertyValue || this.get(propertyName) || 'null';
		var self = this;
		if (propertyName == 'id') {
			var cachedValue = Mura.datacache.get(propertyValue);
			if (typeof cachedValue != 'undefined') {
				this.set(cachedValue);
				return new Promise(function(resolve,reject) {
					resolve(self);
				});
			}
		}
		return new Promise(function(resolve, reject) {
			params = Mura.extend({
				entityname: self.get('entityname').toLowerCase(),
				method: 'findQuery',
				siteid: self.get( 'siteid'),
				'_cacheid': Math.random(),
			},
				params
			);
			if (params.entityname == 'content' ||	params.entityname ==	'contentnav') {
				params.includeHomePage = 1;
				params.showNavOnly = 0;
				params.showExcludeSearch = 1;
			}
			params[propertyName] = propertyValue;
			Mura.findQuery(params).then(
				function(collection) {
					if (collection.get('items').length) {
						self.set(collection.get('items')[0].getAll());
					}
					if (typeof resolve == 'function') {
						resolve(self);
					}
			},function(resp){
				resp=Mura.parseString(resp.response);
				if (typeof reject == 'function'){
					reject(resp);
				}
			});
		});
	},

	/**
	 * validate - Validates instance
	 *
	 * @param	{string} fields List of properties to validate, defaults to all
	 * @return {Promise}
	 */
	validate: function(fields) {
		fields = fields || '';
		var self = this;
		var data = Mura.deepExtend({}, self.getAll());
		data.fields = fields;
		return new Promise(function(resolve, reject) {
			self._requestcontext.request({
				type: 'post',
				url: Mura.apiEndpoint + '?method=validate',
				data: {
					data: Mura.escape( data),
					validations: '{}',
					version: 4
				},
				success: function(resp) {
					if (resp.data !=	'undefined') {
						self.set('errors',resp.data)
					} else {
						self.set('errors',resp.error);
					}
					if (typeof resolve ==	'function') {
						resolve(self);
					}
				}
			});
		});
	},


	/**
	 * hasErrors - Returns if the entity has any errors
	 *
	 * @return {boolean}
	 */
	hasErrors: function() {
		var errors = this.get('errors', {});
		return (typeof errors == 'string' && errors !='') || (typeof errors == 'object' && !Mura.isEmptyObject(errors));
	},


	/**
	 * getErrors - Returns entites errors property
	 *
	 * @return {object}
	 */
	getErrors: function() {
		return this.get('errors', {});
	},


	/**
	 * save - Saves entity to JSON API
	 *
	 * @return {Promise}
	 */
	save: function(eventHandler) {
		eventHandler=eventHandler || {};

		Mura.normalizeRequestHandler(eventHandler);

		var self = this;

		if (!this.get('isdirty')) {
			return new Promise(function(resolve, reject) {
				if(typeof resolve == 'function'){
					eventHandler.success=resolve;
				}
				if (typeof eventHandler.success =='function') {
					eventHandler.success(self);
				}
			});
		}
		if (!this.get('id')) {
			return new Promise(function(resolve, reject) {
				var temp = Mura.deepExtend({},self.getAll());
				self._requestcontext.request({
					type: 'get',
					url: Mura.apiEndpoint + self.get('entityname') + '/new',
					success: function(resp) {
						self.set(resp.data);
						self.set(temp);
						self.set('id',resp.data.id);
						self.set('isdirty',true);
						self.cachePut();
						self.save(eventHandler).then(
							resolve,
							reject
						);
					},
					error: eventHandler.error,
					abort: eventHandler.abort
				});
			});
		} else {
			return new Promise(function(resolve, reject) {

				if(typeof resolve == 'function'){
					eventHandler.success=resolve;
				}

				if(typeof reject == 'function'){
					eventHandler.error=reject;
				}

				var context = self.get('id');
				if(Mura.mode.toLowerCase() == 'rest'){
					self._requestcontext.request({
						type: 'post',
						url: Mura.apiEndpoint + '?method=save',
						data:	self.getAll(),
						success: function(	resp) {
							if (resp.data != 'undefined') {
								self.set(resp.data)
								self.set('isdirty',false );
								if (self.get('saveerrors') ||
									Mura.isEmptyObject(self.getErrors())
								) {
									if (typeof eventHandler.success ==	'function') {
											eventHandler.success(self);
									}
								} else {
									if (typeof eventHandler.error == 'function') {
											eventHandler.error(self);
									}
								}
							} else {
								self.set('errors',resp.error);
								if (typeof eventHandler.error == 'function') {
									eventHandler.error(self);
								}
							}
						},
						progress:eventHandler.progress,
						abort: eventHandler.abort
					});
				} else {
					self._requestcontext.request({
						type: 'post',
						url: Mura.apiEndpoint + '?method=generateCSRFTokens',
						data: {
							siteid: self.get('siteid'),
							context: context
						},
						success: function(resp) {
							self._requestcontext.request({
								type: 'post',
								url: Mura.apiEndpoint + '?method=save',
								data: Mura
								.extend( self.getAll(), {
										'csrf_token': resp.data.csrf_token,
										'csrf_token_expires': resp.data.csrf_token_expires
									}
								),
								success: function(	resp) {
									if (resp.data != 'undefined'	) {
										self.set(resp.data)
										self.set('isdirty',false );
										if (self.get('saveerrors') ||
											Mura.isEmptyObject(self.getErrors())
										) {
											if (typeof eventHandler.success ==	'function') {
												eventHandler.success(self);
											}
										} else {
											if (typeof eventHandler.error == 'function') {
												eventHandler.error(self);
											}
										}
									} else {
										self.set('errors',resp.error);
										if (typeof eventHandler.error == 'function') {
											eventHandler.error(self);
										}
									}
								},
								progress:eventHandler.progress,
								abort: eventHandler.abort
							});
						},
						error: function(resp) {
							this.success(resp );
						},
						abort: eventHandler.abort
					});
				}
			});
		}
	},

	/**
	 * delete - Deletes entity
	 *
	 * @return {Promise}
	 */
	'delete': function(eventHandler) {
		eventHandler=eventHandler || {};

		Mura.normalizeRequestHandler(eventHandler);

		var self = this;
		if(Mura.mode.toLowerCase() == 'rest'){
			return new Promise(function(resolve, reject) {

				if(typeof resolve == 'function'){
					eventHandler.success=resolve;
				}

				if(typeof reject == 'function'){
					eventHandler.error=reject;
				}

				self._requestcontext.request({
					type: 'post',
					url: Mura.apiEndpoint + '?method=delete',
					data: {
						siteid: self.get('siteid'),
						id: self.get('id'),
						entityname: self.get('entityname')
					},
					success: function() {
						self.set('isdeleted',true);
						self.cachePurge();
						if (typeof eventHandler.success == 'function') {
							eventHandler.success(self);
						}
					},
					error: eventHandler.error,
					progress:eventHandler.progress,
					abort: eventHandler.abort
				});
			});
		} else {
			return new Promise(function(resolve, reject) {
				if(typeof resolve == 'function'){
					eventHandler.success=resolve;
				}

				if(typeof reject == 'function'){
					eventHandler.error=reject;
				}

				self._requestcontext.request({
					type: 'post',
					url: Mura.apiEndpoint + '?method=generateCSRFTokens',
					data: {
						siteid: self.get('siteid'),
						context: self.get('id')
					},
					success: function(resp) {
						self._requestcontext.request({
							type: 'post',
							url: Mura.apiEndpoint + '?method=delete',
							data: {
								siteid: self.get('siteid'),
								id: self.get('id'),
								entityname: self.get('entityname'),
								'csrf_token': resp.data.csrf_token,
								'csrf_token_expires': resp.data.csrf_token_expires
							},
							success: function() {
								self.set('isdeleted',true);
								self.cachePurge();
								if (typeof eventHandler.success == 'function') {
									eventHandler.success(self);
								}
							},
							error: eventHandler.error,
							progress:eventHandler.progress,
							abort: eventHandler.abort
						});
					},
					error: eventHandler.error,
					abort: eventHandler.abort
				});
			});
		}
	},

	/**
	 * getFeed - Returns a Mura.Feed instance of this current entitie's type and siteid
	 *
	 * @return {object}
	 */
	getFeed: function() {
		var siteid = get('siteid') || Mura.siteid;
		var feed=this._requestcontext.getFeed(this.get('entityName'));
		return feed;
	},

	/**
	 * cachePurge - Purges this entity from client cache
	 *
	 * @return {object}	Self
	 */
	cachePurge: function() {
		Mura.datacache.purge(this.get('id'));
		return this;
	},

	/**
	 * cachePut - Places this entity into client cache
	 *
	 * @return {object}	Self
	 */
	cachePut: function() {
		if (!this.get('isnew')) {
			Mura.datacache.set(this.get('id'), this);
		}
		return this;
	}

});


/***/ }),
/* 349 */
/***/ (function(module, exports, __webpack_require__) {


var Mura=__webpack_require__(9);

/**
* Creates a new Mura.entities.Content
* @name Mura.entities.Content
* @class
* @extends Mura.Entity
* @memberof Mura
* @param	{object} properties Object containing values to set into object
* @return {Mura.Entity}
*/

Mura.entities.Content = Mura.Entity.extend(
/** @lends Mura.entities.Content.prototype */
{
	/**
	 * hasParent - Returns true if content has a parent.
	 *
	 * @return {boolean}
	 */
	hasParent:function(){
		var parentid=this.get('parentid');
		if(!parentid || ['00000000000000000000000000000000END','00000000000000000000000000000000003','00000000000000000000000000000000004','00000000000000000000000000000000099'].find(function(value){return value===parentid})){
			return false;
		} else {
			return true;
		}
	},

	/**
	 * renderDisplayRegion - Returns a string with display region markup.
	 *
	 * @return {string}
	 */
	renderDisplayRegion:function(region){
		return Mura.buildDisplayRegion(this.get('displayregions')[region])
	},

	/**
	 * dspRegion - Appends a display region to a element.
	 *
	 * @return {self}
	 */
	dspRegion:function(selector,region,label){
		if(Mura.isNumeric(region) && region <= this.get('displayregionnames').length){
			region=this.get('displayregionnames')[region-1];
		}
		Mura(selector).processDisplayRegion(this.get('displayregions')[region],label);
		return this;
	},

	/**
	 * getRelatedContent - Gets related content sets by name
	 *
	 * @param	{string} relatedContentSetName
	 * @param	{object} params
	 * @return {Mura.EntityCollection}
	 */
	getRelatedContent:function(relatedContentSetName,params){
		var self=this;

		relatedContentSetName=relatedContentSetName || '';

		return new Promise(function(resolve,reject) {
			var query = [];
			params = params || {};
			params.siteid = self.get('siteid') || Mura.siteid;
			for (var key in params) {
				if (key != 'entityname' && key != 'filename' && key != 'siteid' && key != 'method') {
					query.push(encodeURIComponent(key) + '=' + encodeURIComponent(params[key]));
				}
			}
			self._requestcontext.request({
				type: 'get',
				url: Mura.apiEndpoint +
					'/content/' + self.get('contentid') + '/relatedcontent/' + relatedContentSetName + '?' +
					query.join('&'),
				params: params,
				success: function(resp) {
					if(typeof resp.data.items != 'undefined'){
						var returnObj = new Mura.EntityCollection(resp.data,self._requestcontext);
					} else {
						var returnObj = new Mura.Entity({siteid:Mura.siteid},self._requestcontext);
						for(var p in resp.data){
							if(resp.data.hasOwnProperty(p)){
								returnObj.set(p,new Mura.EntityCollection(resp.data[p],self._requestcontext));
							}
						}
					}
					if (typeof resolve == 'function') {
						resolve(returnObj);
					}
				},
				error: reject
			});
		});
	}
});


/***/ }),
/* 350 */
/***/ (function(module, exports, __webpack_require__) {


var Mura=__webpack_require__(9);

/**
* Creates a new Mura.entities.User
* @name Mura.entities.User
* @class
* @extends Mura.Entity
* @memberof Mura
* @param	{object} properties Object containing values to set into object
* @return {Mura.Entity}
*/

Mura.entities.User = Mura.Entity.extend(
/** @lends Mura.entities.User.prototype */
{
	/**
	 * isInGroup - Returns if the CURRENT USER is in a group
	 *
	 * @param	{string} group	Name of group
	 * @param	{boolean} isPublic	If you want to check public or private (system) groups
	 * @return {boolean}
	 */
	isInGroup:function(group,siteid,isPublic){
		siteid=siteid || Mura.siteid;
		var a=this.get('memberships');
		if(!Array.isArray(a)){
			console.log('Method design for use with currentuser() only');
			return false;
		}
		if(typeof isPublic !='undefined'){
			return a.indexOf(group + ";" + siteid + ";" + isPublic) >= 0;
		} else {
			return a.indexOf(group + ";" + siteid + ";0") >= 0 || a.indexOf(group + ";" + siteid + ";1") >= 0;
		}
	},

	/**
	 * isSuperUser - Returns if the CURRENT USER is a super user
	 *
	 * @return {boolean}
	 */
	isSuperUser:function(){
		var a=this.get('memberships');
		if(!Array.isArray(a)){
			console.log('Method design for use with currentuser() only');
			return false;
		}
		return a.indexOf('S2') >= 0;
	},

	/**
	 * isAdminUser - Returns if the CURRENT USER is a admin user
	 *
	 * @return {boolean}
	 */
	isAdminUser:function(siteid){
		siteid=siteid || Mura.siteid;
		var a=this.get('memberships');
		if(!Array.isArray(a)){
			console.log('Method design for use with currentuser() only');
			return false;
		}
		return (this.isSuperUser() || a.indexOf("Admin;" + siteid + ";0") >= 0);
	},

	/**
	 * isSystemUser - Returns if the CURRENT USER is a system/adminstrative user
	 *
	 * @return {boolean}
	 */
	isSystemUser:function(siteid){
		siteid=siteid || Mura.siteid;
		var a=this.get('memberships');
		if(!Array.isArray(a)){
			console.log('Method design for use with currentuser() only');
			return false;
		}
		return (this.isAdminUser() || a.indexOf("S2IsPrivate;" + siteid ) >= 0);
	},

	/**
	 * isLoggedIn - Returns if the CURRENT USER is logged in
	 *
	 * @return {boolean}
	 */
	isLoggedIn:function(){
		var a=this.get('isloggedin');
		if(a===''){
			return false;
		} else {
			return a;
		}
	}
});


/***/ }),
/* 351 */
/***/ (function(module, exports, __webpack_require__) {


var Mura=__webpack_require__(9);

/**
 * Creates a new Mura.EntityCollection
 * @name	Mura.EntityCollection
 * @class
 * @extends Mura.Entity
 * @memberof	Mura
 * @param	{object} properties Object containing values to set into object
 * @return {Mura.EntityCollection} Self
 */

Mura.EntityCollection=Mura.Entity.extend(
	/** @lends Mura.EntityCollection.prototype */
	{

	init:function(properties,requestcontext){
		properties=properties || {};
		this.set(properties);
		this._requestcontext=requestcontext || Mura._requestcontext;
		var self=this;
		if(Array.isArray(self.get('items'))){
			self.set('items',self.get('items').map(function(obj){
				var entityname=obj.entityname.substr(0, 1).toUpperCase() + obj.entityname.substr(1);
				if(Mura.entities[entityname]){
					return new Mura.entities[entityname](obj,self._requestcontext);
				} else {
					return new Mura.Entity(obj,self._requestcontext);
				}
			}));
		}

		return this;
	},

	/**
	 * length - Returns length entity collection
	 *
	 * @return {number}		 integer
	 */
	length:function(){
		return this.properties.items.length;
	},

	/**
	 * item - Return entity in collection at index
	 *
	 * @param	{nuymber} idx Index
	 * @return {object}		 Mura.Entity
	 */
	item:function(idx){
		return this.properties.items[idx];
	},

	/**
	 * index - Returns index of item in collection
	 *
	 * @param	{object} item Entity instance
	 * @return {number}			Index of entity
	 */
	index:function(item){
		return this.properties.items.indexOf(item);
	},

	/**
	 * indexOf - Returns index of item in collection
	 *
	 * @param	{object} item Entity instance
	 * @return {number}			Index of entity
	 */
	indexOf:function(item){
		return this.properties.items.indexOf(item);
	},

	/**
	 * getAll - Returns object with of all entities and properties
	 *
	 * @return {object}
	 */
	getAll:function(){
		var self=this;
		if(typeof self.properties.items != 'undefined'){
			return Mura.extend(
				{},
				self.properties,
				{
					items:self.properties.items.map(function(obj){
						return obj.getAll();
					})
				}
			);
		} else if(typeof self.properties.properties != 'undefined'){
			return Mura.extend(
				{},
				self.properties,
				{
					properties:self.properties.properties.map(function(obj){
						return obj.getAll();
					})
				}
			);
		}
	},

	/**
	 * each - Passes each entity in collection through function
	 *
	 * @param	{function} fn Function
	 * @return {object}	Self
	 */
	each:function(fn){
		this.properties.items.forEach( function(item,idx){
			if(typeof fn.call == 'undefined'){
				fn(item,idx);
			} else {
				fn.call(item,item,idx);
			}
		});
		return this;
	},

			/**
	 * each - Passes each entity in collection through function
	 *
	 * @param	{function} fn Function
	 * @return {object}	Self
	 */
	forEach:function(fn){
		return this.each(fn);
	},

	/**
	 * sort - Sorts collection
	 *
	 * @param	{function} fn Sorting function
	 * @return {object}	 Self
	 */
	sort:function(fn){
		this.properties.items.sort(fn);
		return this;
	},

	/**
	 * filter - Returns new Mura.EntityCollection of entities in collection that pass filter
	 *
	 * @param	{function} fn Filter function
	 * @return {Mura.EntityCollection}
	 */
	filter:function(fn){
		var newProps={};
		for(var p in this.properties){
			if(this.properties.hasOwnProperty(p) && p != 'items' && p != 'links'){
				newProps[p]=this.properties[p];
			}
		}
		var collection=new Mura.EntityCollection(newProps,this._requestcontext);
		return collection.set('items',this.properties.items.filter( function(item,idx){
			if(typeof fn.call == 'undefined'){
				return fn(item,idx);
			} else {
				return fn.call(item,item,idx);
			}
		}));
	},

	 /**
	 * map - Returns new Array returned from map function
	 *
	 * @param	{function} fn Filter function
	 * @return {Array}
	 */
	map:function(fn){
		return this.properties.items.map( function(item,idx){
			if(typeof fn.call == 'undefined'){
				return fn(item,idx);
			} else {
				return fn.call(item,item,idx);
			}
		});
	},

	 /**
	 * reverse - Returns new Array returned from map function
	 *
	 * @param	{function} fn Sorting function
	 * @return {object}	 collection
	 */
	reverse:function(fn){
		var newProps={};
		for(var p in this.properties){
			if(this.properties.hasOwnProperty(p) && p != 'items' && p != 'links'){
				newProps[p]=this.properties[p];
			}
		}
		var collection=new Mura.EntityCollection(newProps,this._requestcontext);
		collection.set('items',this.properties.items.reverse());
		return collection;
	},

	 /**
	 * reduce - Returns value from	reduce function
	 *
	 * @param	{function} fn Reduce function
	 * @param	{any} initialValue Starting accumulator value
	 * @return {accumulator}
	 */
	reduce:function(fn,initialValue){
		initialValue=initialValue||0;
		return this.properties.items.reduce(
			function(accumulator,item,idx,array){
				if(typeof fn.call == 'undefined'){
					return fn(accumulator,item,idx,array);
				} else {
					return fn.call(item,accumulator,item,idx,array);
				}
			},
			initialValue
		);
	}
});


/***/ }),
/* 352 */
/***/ (function(module, exports, __webpack_require__) {


var Mura=__webpack_require__(9);

/**
 * Creates a new Mura.Feed
 * @name  Mura.Feed
 * @class
 * @extends Mura.Core
 * @memberof Mura
 * @param  {string} siteid     Siteid
 * @param  {string} entityname Entity name
 * @return {Mura.Feed}            Self
 */

 /**
  * @ignore
  */

Mura.Feed = Mura.Core.extend(
	/** @lends Mura.Feed.prototype */
	{
		init: function(siteid, entityname, requestcontext) {
			this.queryString = entityname + '/?_cacheid=' + Math.random();
			this.propIndex = 0;

			this._requestcontext=requestcontext || Mura._requestcontext;

			return this;
		},

		/**
		 * fields - List fields to retrieve from API
		 *
		 * @param  {string} fields List of fields
		 * @return {Mura.Feed}        Self
		 */
		fields: function(fields) {
			if(typeof fields != 'undefined' && fields){
				this.queryString += '&fields=' + encodeURIComponent(fields);
			}
			return this;
		},

		/**
		 * setRequestContext - Sets the RequestContext
		 *
		 * @RequestContext  {Mura.RequestContext} Mura.RequestContext List of fields
		 * @return {Mura.Feed}        Self
		 */
		setRequestContext: function(RequestContext) {
			this._requestcontext=RequestContext;
			return this;
		},

		/**
		 * contentPoolID - Sets items per page
		 *
		 * @param  {string} contentPoolID Items per page
		 * @return {Mura.Feed}              Self
		 */
		contentPoolID: function(contentPoolID) {
			this.queryString += '&contentpoolid=' + encodeURIComponent(
				contentPoolID);
			return this;
		},

		/**
		 * name - Sets the name of the content feed to use
		 *
		 * @param  {string} name Name of feed as defined in admin
		 * @return {Mura.Feed}              Self
		 */
		name: function(name) {
			this.queryString += '&feedname=' + encodeURIComponent(
				name);
			return this;
		},

		/**
		 * contentPoolID - Sets items per page
		 *
		 * @param  {string} feedID Items per page
		 * @return {Mura.Feed}              Self
		 */
		feedID: function(feedID) {
			this.queryString += '&feedid=' + encodeURIComponent(
				feedID);
			return this;
		},

		/**
		 * where - Optional method for starting query chain
		 *
		 * @param  {string} property Property name
		 * @return {Mura.Feed}          Self
		 */
		where: function(property) {
			if (property) {
				return this.andProp(property);
			}
			return this;
		},

		/**
		 * prop - Add new property value
		 *
		 * @param  {string} property Property name
		 * @return {Mura.Feed}          Self
		 */
		prop: function(property) {
			return this.andProp(property);
		},

		/**
		 * andProp - Add new AND property value
		 *
		 * @param  {string} property Property name
		 * @return {Mura.Feed}          Self
		 */
		andProp: function(property) {
			this.queryString += '&' + encodeURIComponent(property + '[' + this.propIndex + ']') +
				'=';
			this.propIndex++;
			return this;
		},

		/**
		 * orProp - Add new OR property value
		 *
		 * @param  {string} property Property name
		 * @return {Mura.Feed}          Self
		 */
		orProp: function(property) {
			this.queryString += '&or' + encodeURIComponent('[' + this.propIndex + ']') + '&';
			this.propIndex++;
			this.queryString += encodeURIComponent(property +'[' + this.propIndex + ']') +
				'=';
			this.propIndex++;
			return this;
		},

		/**
		 * isEQ - Checks if preceding property value is EQ to criteria
		 *
		 * @param  {*} criteria Criteria
		 * @return {Mura.Feed}          Self
		 */
		isEQ: function(criteria) {
			if (typeof criteria== 'undefined' || criteria === '' || criteria ==	null) {
				criteria = 'null';
			}
			this.queryString += encodeURIComponent(criteria);
			return this;
		},

		/**
		 * isNEQ - Checks if preceding property value is NEQ to criteria
		 *
		 * @param  {*} criteria Criteria
		 * @return {Mura.Feed}          Self
		 */
		isNEQ: function(criteria) {
			if (typeof criteria == 'undefined' || criteria === '' || criteria == null) {
				criteria = 'null';
			}
			this.queryString += encodeURIComponent('neq^' + criteria);
			return this;
		},

		/**
		 * isLT - Checks if preceding property value is LT to criteria
		 *
		 * @param  {*} criteria Criteria
		 * @return {Mura.Feed}          Self
		 */
		isLT: function(criteria) {
			if (typeof criteria == 'undefined' || criteria === '' || criteria == null) {
				criteria = 'null';
			}
			this.queryString += encodeURIComponent('lt^' + criteria);
			return this;
		},

		/**
		 * isLTE - Checks if preceding property value is LTE to criteria
		 *
		 * @param  {*} criteria Criteria
		 * @return {Mura.Feed}          Self
		 */
		isLTE: function(criteria) {
			if (typeof criteria == 'undefined' || criteria === '' || criteria ==
				null) {
				criteria = 'null';
			}
			this.queryString += encodeURIComponent('lte^' + criteria);
			return this;
		},

		/**
		 * isGT - Checks if preceding property value is GT to criteria
		 *
		 * @param  {*} criteria Criteria
		 * @return {Mura.Feed}          Self
		 */
		isGT: function(criteria) {
			if (typeof criteria == 'undefined' || criteria === '' || criteria == null) {
				criteria = 'null';
			}
			this.queryString += encodeURIComponent('gt^' + criteria);
			return this;
		},

		/**
		 * isGTE - Checks if preceding property value is GTE to criteria
		 *
		 * @param  {*} criteria Criteria
		 * @return {Mura.Feed}          Self
		 */
		isGTE: function(criteria) {
			if (typeof criteria == 'undefined' || criteria === '' || criteria ==
				null) {
				criteria = 'null';
			}
			this.queryString += encodeURIComponent('gte^' + criteria);
			return this;
		},

		/**
		 * isIn - Checks if preceding property value is IN to list of criterias
		 *
		 * @param  {*} criteria Criteria List
		 * @return {Mura.Feed}          Self
		 */
		isIn: function(criteria) {
			this.queryString += encodeURIComponent('in^' + criteria);
			return this;
		},

		/**
		 * isNotIn - Checks if preceding property value is NOT IN to list of criterias
		 *
		 * @param  {*} criteria Criteria List
		 * @return {Mura.Feed}          Self
		 */
		isNotIn: function(criteria) {
			this.queryString += encodeURIComponent('notin^' + criteria);
			return this;
		},

		/**
		 * containsValue - Checks if preceding property value is CONTAINS the value of criteria
		 *
		 * @param  {*} criteria Criteria
		 * @return {Mura.Feed}          Self
		 */
		containsValue: function(criteria) {
			this.queryString += encodeURIComponent('containsValue^' + criteria);
			return this;
		},
		contains: function(criteria) {
			this.queryString += encodeURIComponent('containsValue^' + criteria);
			return this;
		},

		/**
		 * beginsWith - Checks if preceding property value BEGINS WITH criteria
		 *
		 * @param  {*} criteria Criteria
		 * @return {Mura.Feed}          Self
		 */
		beginsWith: function(criteria) {
			this.queryString += encodeURIComponent('begins^' + criteria);
			return this;
		},

		/**
		 * endsWith - Checks if preceding property value ENDS WITH criteria
		 *
		 * @param  {*} criteria Criteria
		 * @return {Mura.Feed}          Self
		 */
		endsWith: function(criteria) {
			this.queryString += encodeURIComponent('ends^' + criteria);
			return this;
		},


		/**
		 * openGrouping - Start new logical condition grouping
		 *
		 * @return {Mura.Feed}          Self
		 */
		openGrouping: function() {
			this.queryString += '&openGrouping' + encodeURIComponent('[' + this.propIndex + ']');
			this.propIndex++;
			return this;
		},

		/**
		 * openGrouping - Starts new logical condition grouping
		 *
		 * @return {Mura.Feed}          Self
		 */
		andOpenGrouping: function() {
			this.queryString += '&andOpenGrouping' + encodeURIComponent('[' + this.propIndex + ']');
			this.propIndex++;
			return this;
		},

		/**
		 * orOpenGrouping - Starts new logical condition grouping
		 *
		 * @return {Mura.Feed}          Self
		 */
		orOpenGrouping: function() {
			this.queryString += '&orOpenGrouping' + encodeURIComponent('[' + this.propIndex + ']');
			this.propIndex++;
			return this;
		},

		/**
		 * openGrouping - Closes logical condition grouping
		 *
		 * @return {Mura.Feed}          Self
		 */
		closeGrouping: function() {
			this.queryString += '&closeGrouping' + encodeURIComponent('[' + this.propIndex + ']');
			this.propIndex++;
			return this;
		},

		/**
		 * sort - Set desired sort or return collection
		 *
		 * @param  {string} property  Property
		 * @param  {string} direction Sort direction
		 * @return {Mura.Feed}           Self
		 */
		sort: function(property, direction) {
			direction = direction || 'asc';
			if (direction == 'desc') {
				this.queryString += '&sort' + encodeURIComponent('[' + this.propIndex + ']') + '=' + encodeURIComponent('-' + property);
			} else {
				this.queryString += '&sort' +encodeURIComponent('[' + this.propIndex + ']') + '=' + encodeURIComponent(property);
			}
			this.propIndex++;
			return this;
		},

		/**
		 * itemsPerPage - Sets items per page
		 *
		 * @param  {number} itemsPerPage Items per page
		 * @return {Mura.Feed}              Self
		 */
		itemsPerPage: function(itemsPerPage) {
			this.queryString += '&itemsPerPage=' + encodeURIComponent(itemsPerPage);
			return this;
		},

		/**
		 * pageIndex - Sets items per page
		 *
		 * @param  {number} pageIndex page to start at
		 */
		pageIndex: function(pageIndex) {
			this.queryString += '&pageIndex=' + encodeURIComponent(pageIndex);
			return this;
		},

		/**
		 * maxItems - Sets max items to return
		 *
		 * @param  {number} maxItems Items to return
		 * @return {Mura.Feed}              Self
		 */
		maxItems: function(maxItems) {
			this.queryString += '&maxItems=' + encodeURIComponent(maxItems);
			return this;
		},

		/**
		 * distinct - Sets to select distinct values of select fields
		 *
		 * @param  {boolean} distinct Whether to to select distinct values
		 * @return {Mura.Feed}              Self
		 */
		distinct: function(distinct) {
			if(typeof distinct=='undefined'){
				distinct=true;
			}
			this.queryString += '&distinct=' + encodeURIComponent(distinct);
			return this;
		},

		/**
		 * aggregate - Define aggregate values that you would like (sum,max,min,cout,avg,groupby)
		 *
		 * @param  {string} type Type of aggregation (sum,max,min,cout,avg,groupby)
		 * @param  {string} property property
		 * @return {Mura.Feed}	Self
		 */
		aggregate: function(type,property) {
			if(type == 'count' && typeof property=='undefined'){
				property='*';
			}

			if(typeof type != 'undefined' && typeof property!='undefined'){
				this.queryString += '&' + encodeURIComponent( type + '[' + this.propIndex + ']') + '=' + property;
				this.propIndex++;
			}
			return this;
		},

		/**
		 * liveOnly - Set whether to return all content or only content that is currently live.
		 * This only works if the user has module level access to the current site's content
		 *
		 * @param  {number} liveOnly 0 or 1
		 * @return {Mura.Feed}              Self
		 */
		liveOnly: function(liveOnly) {
			this.queryString += '&liveOnly=' + encodeURIComponent(liveOnly);
			return this;
		},

		/**
		 * groupBy - Sets property or properties to group by
		 *
		 * @param  {string} groupBy
		 * @return {Mura.Feed}              Self
		 */
		 groupBy: function(property) {
 			if(typeof property!='undefined'){
 				this.queryString += '&' + encodeURIComponent('groupBy[' + this.propIndex + ']') + '=' + property;
 				this.propIndex++;
 			}
 			return this;
 		},

		/**
		 * maxItems - Sets max items to return
		 *
		 * @param  {number} maxItems Items to return
		 * @return {Mura.Feed}              Self
		 */
		maxItems: function(maxItems) {
			this.queryString += '&maxItems=' + encodeURIComponent(maxItems);
			return this;
		},

		/**
		 * showNavOnly - Sets to include the homepage
		 *
		 * @param  {boolean} showNavOnly Whether to return items that have been excluded from search
		 * @return {Mura.Feed}              Self
		 */
		showNavOnly: function(showNavOnly) {
			this.queryString += '&showNavOnly=' + encodeURIComponent(showNavOnly);
			return this;
		},

		/**
		 * expand - Sets which linked properties to return expanded values
		 *
		 * @param  {string} expand List of properties to expand, use 'all' for all.
		 * @return {Mura.Feed}              Self
		 */
		expand: function(expand) {
			if(typeof expand == 'undefined'){
				expand = 'all';
			}
			if(expand){
				this.queryString += '&expand=' + encodeURIComponent(expand);
			}
			return this;
		},

		/**
		 * expandDepth - Set the depth that expanded links are expanded
		 *
		 * @param  {number} expandDepth Number of levels to expand, defaults to 1
		 * @return {Mura.Feed}              Self
		 */
		expandDepth: function(expandDepth) {
			expandDepth = expandDepth || 1;
			if(Mura.isNumeric(expandDepth) && Number(parseFloat(expandDepth)) > 1){
				this.queryString += '&expandDepth=' + encodeURIComponent(expandDepth);
			}
			return this;
		},

		/**
		 * no - Sets to include the homepage
		 *
		 * @param  {boolean} showExcludeSearch Whether to return items that have been excluded from search
		 * @return {Mura.Feed}              Self
		 */
		showExcludeSearch: function(showExcludeSearch) {
			this.queryString += '&showExcludeSearch=' + encodeURIComponent(showExcludeSearch);
			return this;
		},

		/**
		 * no - Sets to whether to require all categoryids in list of just one.
		 *
		 * @param  {boolean} useCategoryIntersect Whether require a match for all categories
		 * @return {Mura.Feed}              Self
		 */
		useCategoryIntersect: function(useCategoryIntersect) {
			this.queryString += '&useCategoryIntersect=' + encodeURIComponent(useCategoryIntersect);
			return this;
		},

		/**
		 * includeHomepage - Sets to include the home page
		 *
		 * @param  {boolean} showExcludeSearch Whether to return the homepage
		 * @return {Mura.Feed}              Self
		 */
		includeHomepage: function(includeHomepage) {
			this.queryString += '&includehomepage=' + encodeURIComponent(includeHomepage);
			return this;
		},

		/**
		 * innerJoin - Sets entity to INNER JOIN
		 *
		 * @param  {string} relatedEntity Related entity
		 * @return {Mura.Feed}              Self
		 */
		innerJoin: function(relatedEntity) {
			this.queryString += '&innerJoin' + encodeURIComponent('[' + this.propIndex + ']') + '=' +	encodeURIComponent(relatedEntity);
			this.propIndex++;
			return this;
		},

		/**
		 * leftJoin - Sets entity to LEFT JOIN
		 *
		 * @param  {string} relatedEntity Related entity
		 * @return {Mura.Feed}              Self
		 */
		leftJoin: function(relatedEntity) {
			this.queryString += '&leftJoin' + encodeURIComponent('[' + this.propIndex + ']') + '=' + encodeURIComponent(relatedEntity);
			this.propIndex++;
			return this;
		},

		/**
		 * Query - Return Mura.EntityCollection fetched from JSON API
		 * @return {Promise}
		 */
		getQuery: function(params) {
			var self = this;

			if(typeof params != 'undefined'){
				for(var p in params){
					if(params.hasOwnProperty(p)){
						if(typeof self[p] == 'function'){
							self[p](params[p]);
						} else {
							self.andProp(p).isEQ(params[p]);
						}
					}
				}
			}

			return new Promise(function(resolve, reject) {
				if (Mura.apiEndpoint.charAt(Mura.apiEndpoint.length - 1) == "/") {
					var apiEndpoint = Mura.apiEndpoint;
				} else {
					var apiEndpoint = Mura.apiEndpoint + '/';
				}
				self._requestcontext.request({
					type: 'get',
					url: apiEndpoint + self.queryString,
					success: function(resp) {
						if (resp.data != 'undefined'  ) {
							var returnObj = new Mura.EntityCollection(resp.data,self._requestcontext);

							if (typeof resolve == 'function') {
								resolve(returnObj);
							}
						} else if (typeof reject == 'function') {
							reject(resp);
						}
					},
					error: function(resp) {
						resp=Mura.parseString(resp.response);
						if (typeof reject == 'function'){
							reject(resp);
						}
					}
				});
			});
		}
	});


/***/ }),
/* 353 */
/***/ (function(module, exports, __webpack_require__) {


var Mura=__webpack_require__(9);

//https://github.com/malko/l.js
/*
* script for js/css parallel loading with dependancies management
* @author Jonathan Gotti < jgotti at jgotti dot net >
* @licence dual licence mit / gpl
* @since 2012-04-12
* @todo add prefetching using text/cache for js files
* @changelog
*            - 2014-06-26 - bugfix in css loaded check when hashbang is used
*            - 2014-05-25 - fallback support rewrite + null id bug correction + minification work
*            - 2014-05-21 - add cdn fallback support with hashbang url
*            - 2014-05-22 - add support for relative paths for stylesheets in checkLoaded
*            - 2014-05-21 - add support for relative paths for scripts in checkLoaded
*            - 2013-01-25 - add parrallel loading inside single load call
*            - 2012-06-29 - some minifier optimisations
*            - 2012-04-20 - now sharp part of url will be used as tag id
*                         - add options for checking already loaded scripts at load time
*            - 2012-04-19 - add addAliases method
* @note coding style is implied by the target usage of this script not my habbits
*/

if(typeof window !='undefined' && typeof window.document != 'undefined'){
	var isA =  function(a,b){ return a instanceof (b || Array);}
		//-- some minifier optimisation
		, D = document
		, getElementsByTagName = 'getElementsByTagName'
		, length = 'length'
		, readyState = 'readyState'
		, onreadystatechange = 'onreadystatechange'
		//-- get the current script tag for further evaluation of it's eventual content
		, scripts = D[getElementsByTagName]("script")
		, scriptTag = scripts[scripts[length]-1]
		, script  = scriptTag.innerHTML.replace(/^\s+|\s+$/g,'')
	;

	try {
		var preloadsupport = w.document.createElement( "link" ).relList.supports( "preload" );
	} catch (e) {
		var preloadsupport = false;
	}

	//avoid multiple inclusion to override current loader but allow tag content evaluation
	if( ! Mura.ljs ){
		var checkLoaded = scriptTag.src.match(/checkLoaded/)?1:0
			//-- keep trace of header as we will make multiple access to it
			,header  = D[getElementsByTagName]("head")[0] || D.documentElement
			, urlParse = function(url){
				var parts={}; // u => url, i => id, f = fallback
				parts.u = url.replace(/#(=)?([^#]*)?/g,function(m,a,b){ parts[a?'f':'i'] = b; return '';});
				return parts;
			}
			,appendElmt = function(type,attrs,cb){
				var el = D.createElement(type), i;

				if( type =='script' && cb ){ //-- this is not intended to be used for link
					if(el[readyState]){
						el[onreadystatechange] = function(){
							if (el[readyState] === "loaded" || el[readyState] === "complete"){
								el[onreadystatechange] = null;
								cb();
							}
						};
					} else{
						el.onload = cb;
					}
				} else if(
						type=='link'
						&& typeof attrs == 'object'
						&& typeof attrs.rel != 'undefined'
						&& attrs.rel=='preload'
					){

						/*
						Inspired by
						https://github.com/filamentgroup/loadCSS/blob/master/src/loadCSS.js
						*/

						var media=attrs.media || 'all';
						attrs.as = attrs.as || 'style';

						if(!preloadsupport){
							attrs.media='x only';
							attrs.rel="stylesheet";
						}

						function loadCB(){
							if( el.addEventListener ){
								el.removeEventListener( "load", loadCB );
							}
							el.media = media || "all";
						  el.rel="stylesheet";
						}

						function onloadcssdefined( cb ){
							var sheets=document.styleSheets;
							var resolvedHref = attrs.href;
							var i = sheets.length;
							while( i-- ){
								if( sheets[ i ].href === resolvedHref ){
									return cb();
								}
							}
							setTimeout(function() {
								onloadcssdefined( cb );
							});
						};

						if( el.addEventListener ){
							el.addEventListener( "load", loadCB);
						}

						el.onloadcssdefined = onloadcssdefined;

						onloadcssdefined( loadCB );

				}

				for( i in attrs ){ attrs[i] && (el[i]=attrs[i]); }

				header.appendChild(el);
				// return e; // unused at this time so drop it
			}
			,load = function(url,cb){
				if( this.aliases && this.aliases[url] ){
					var args = this.aliases[url].slice(0);
					isA(args) || (args=[args]);
					cb && args.push(cb);
					return this.load.apply(this,args);
				}
				if( isA(url) ){ // parallelized request
					for( var l=url[length]; l--;){
						this.load(url[l]);
					}
					cb && url.push(cb); // relaunch the dependancie queue
					return this.load.apply(this,url);
				}
				if( url.match(/\.css\b/) ){
					return this.loadcss(url,cb);
				} else if( url.match(/\.html\b/) ){
					return this.loadimport(url,cb);
				} else {
					return this.loadjs(url,cb);
				}
			}
			,loaded = {}  // will handle already loaded urls
			,loader  = {
				aliases:{}
				,loadjs: function(url,attrs,cb){
					if(typeof url == 'object'){
						if(Array.isArray(url)){
							return loader.load.apply(this, arguments);
						} else if(typeof attrs === 'function'){
							cb=attrs;
							attrs={};
							url=attrs.href
						} else if (typeof attrs=='string' || (typeof attrs=='object' && Array.isArray(attrs))) {
							return loader.load.apply(this, arguments);
						} else {
							attrs=url;
							url=attrs.href;
							cb=undefined;
						}
					} else if (typeof attrs=='function' ) {
						cb = attrs;
						attrs = {};
					} else if (typeof attrs=='string' || (typeof attrs=='object' && Array.isArray(attrs))) {
						return loader.load.apply(this, arguments);
					}
					if(typeof attrs==='undefined'){
						attrs={};
					}

					var parts = urlParse(url);
					var partToAttrs=[['i','id'],['f','fallback'],['u','src']];

					for(var i=0;i<partToAttrs.length;i++){
						var part=partToAttrs[i];
						if(!(part[1] in attrs) && (part[0] in parts)){
							attrs[part[1]]=parts[part[0]];
						}
					}

					if(typeof attrs.type === 'undefined'){
						attrs.type='text/javascript';
					}

					var finalAttrs={};

					for(var a in attrs){
						if(a != 'fallback'){
							finalAttrs[a]=attrs[a];
						}
					}

					finalAttrs.onerror=function(error){
						if( attrs.fallback ){
							var c = error.currentTarget;
							c.parentNode.removeChild(c);
							finalAttrs.src=attrs.fallback;
							appendElmt('script',attrs,cb);
						}
					};


					if( loaded[finalAttrs.src] === true ){ // already loaded exec cb if any
						cb && cb();
						return this;
					} else if( loaded[finalAttrs.src]!== undefined ){ // already asked for loading we append callback if any else return
						if( cb ){
							loaded[finalAttrs.src] = (function(ocb,cb){ return function(){ ocb && ocb(); cb && cb(); }; })(loaded[finalAttrs.src],cb);
						}
						return this;
					}
					// first time we ask this script
					loaded[finalAttrs.src] = (function(cb){ return function(){loaded[finalAttrs.src]=true; cb && cb();};})(cb);
					cb = function(){ loaded[url](); };
					appendElmt('script',finalAttrs,cb);
					return this;
				}
				,loadcss: function(url,attrs,cb){

					if(typeof url == 'object'){
						if(Array.isArray(url)){
							return loader.load.apply(this, arguments);
						} else if(typeof attrs === 'function'){
							cb=attrs;
							attrs=url;
							url=attrs.href
						} else if (typeof attrs=='string' || (typeof attrs=='object' && Array.isArray(attrs))) {
							return loader.load.apply(this, arguments);
						} else {
							attrs=url;
							url=attrs.href;
							cb=undefined;
						}
					} else if (typeof attrs=='function' ) {
						cb = attrs;
						attrs = {};
					} else if (typeof attrs=='string' || (typeof attrs=='object' && Array.isArray(attrs))) {
						return loader.load.apply(this, arguments);
					}

					var parts = urlParse(url);
					parts={type:'text/css',rel:'stylesheet',href:url,id:parts.i}

					if(typeof attrs !=='undefined'){
						for(var a in attrs){
							parts[a]=attrs[a];
						}
					}

					loaded[parts.href] || appendElmt('link',parts);
					loaded[parts.href] = true;
					cb && cb();
					return this;
				}
				,loadimport: function(url,attrs,cb){

					if(typeof url == 'object'){
						if(Array.isArray(url)){
							return loader.load.apply(this, arguments);
						} else if(typeof attrs === 'function'){
							cb=attrs;
							attrs=url;
							url=attrs.href
						} else if (typeof attrs=='string' || (typeof attrs=='object' && Array.isArray(attrs))) {
							return loader.load.apply(this, arguments);
						} else {
							attrs=url;
							url=attrs.href;
							cb=undefined;
						}
					} else if (typeof attrs=='function' ) {
						cb = attrs;
						attrs = {};
					} else if (typeof attrs=='string' || (typeof attrs=='object' && Array.isArray(attrs))) {
						return loader.load.apply(this, arguments);
					}

					var parts = urlParse(url);
					parts={rel:'import',href:url,id:parts.i}

					if(typeof attrs !=='undefined'){
						for(var a in attrs){
							parts[a]=attrs[a];
						}
					}

					loaded[parts.href] || appendElmt('link',parts);
					loaded[parts.href] = true;
					cb && cb();
					return this;
				}
				,load: function(){
					var argv=arguments,argc = argv[length];
					if( argc === 1 && isA(argv[0],Function) ){
						argv[0]();
						return this;
					}
					load.call(this,argv[0], argc <= 1 ? undefined : function(){ loader.load.apply(loader,[].slice.call(argv,1));} );
					return this;
				}
				,addAliases:function(aliases){
					for(var i in aliases ){
						this.aliases[i]= isA(aliases[i]) ? aliases[i].slice(0) : aliases[i];
					}
					return this;
				}
			}
		;

		if( checkLoaded ){
			var i,l,links,url;
			for(i=0,l=scripts[length];i<l;i++){
				(url = scripts[i].getAttribute('src')) && (loaded[url.replace(/#.*$/,'')] = true);
			}
			links = D[getElementsByTagName]('link');
			for(i=0,l=links[length];i<l;i++){
				(links[i].rel==='import' || links[i].rel==='stylesheet' || links[i].type==='text/css') && (loaded[links[i].getAttribute('href').replace(/#.*$/,'')]=true);
			}
		}
		//export ljs
		Mura.ljs = loader;
		// eval inside tag code if any
	}
	scriptTag.src && script && appendElmt('script', {innerHTML: script});
}


/***/ }),
/* 354 */
/***/ (function(module, exports, __webpack_require__) {


var Mura=__webpack_require__(9);

(function(Mura){
"use strict";
	
/**
 * Creates a new Mura.DOMSelection
 * @name	Mura.DOMSelection
 * @class
 * @param	{object} properties Object containing values to set into object
 * @return {Mura.DOMSelection}
 * @extends Mura.Core
 * @memberof Mura
 */

 /**
	* @ignore
	*/

Mura.DOMSelection = Mura.Core.extend(
	/** @lends Mura.DOMSelection.prototype */
	{

		init: function(selection, origSelector) {
			this.selection = selection;
			this.origSelector = origSelector;

			if (this.selection.length && this.selection[0]) {
				this.parentNode = this.selection[0].parentNode;
				this.childNodes = this.selection[0].childNodes;
				this.node = selection[0];
				this.length = this.selection.length;
			} else {
				this.parentNode = null;
				this.childNodes = null;
				this.node = null;
				this.length = 0;
			}

			if(typeof Mura.supportPassive == 'undefined'){
				Mura.supportsPassive = false;
				try {
					var opts = Object.defineProperty({}, 'passive', {
						get: function() {
						  Mura.supportsPassive = true;
						}
					});
					window.addEventListener("testPassive", null, opts);
					window.removeEventListener("testPassive", null, opts);
				} catch (e) {}
			}
		},

	/**
	 * get - Deprecated: Returns element at index of selection, use item()
	 *
	 * @param	{number} index Index of selection
	 * @return {*}
	 */
	get: function(index) {
		if(typeof index != 'undefined'){
			return this.selection[index];
		} else {
			return this.selection;
		}
	},

	/**
	 * select - Returns new Mura.DomSelection
	 *
	 * @param	{string} selector Selector
	 * @return {object}
	 */
	select: function(selector) {
		return Mura(selector);
	},

	/**
	 * each - Runs function against each item in selection
	 *
	 * @param	{function} fn Method
	 * @return {Mura.DOMSelection} Self
	 */
	each: function(fn) {
		this.selection.forEach(function(el, idx, array) {
			if(typeof fn.call == 'undefined'){
				fn(el, idx, array);
			} else {
				fn.call(el, el, idx, array);
			}
		});
		return this;
	},

	/**
	 * each - Runs function against each item in selection
	 *
	 * @param	{function} fn Method
	 * @return {Mura.DOMSelection} Self
	 */
	forEach: function(fn) {
		this.selection.forEach(function(el, idx, array) {
			if(typeof fn.call == 'undefined'){
				fn(el, idx, array);
			} else {
				fn.call(el, el, idx, array);
			}
		});
		return this;
	},

	/**
	 * filter - Creates a new Mura.DomSelection instance contains selection values that pass filter function by returning true
	 *
	 * @param	{function} fn Filter function
	 * @return {object}		New Mura.DOMSelection
	 */
	filter: function(fn) {
		return Mura(this.selection.filter(function(el,idx, array) {
			if(typeof fn.call == 'undefined'){
				return fn(el, idx,array);
			} else {
				return fn.call(el, el, idx,array);
			}
		}));
	},

	/**
	 * map - Creates a new Mura.DomSelection instance contains selection values that are returned by Map function
	 *
	 * @param	{function} fn Map function
	 * @return {object}		New Mura.DOMSelection
	 */
	map: function(fn) {
		return Mura(this.selection.map(function(el, idx, array) {
			if(typeof fn.call == 'undefined'){
				return fn(el, idx, array);
			} else {
				return fn.call(el, el, idx, array);
			}
		}));
	},

	/**
	 * reduce - Returns value from	reduce function
	 *
	 * @param	{function} fn Reduce function
	 * @param	{any} initialValue Starting accumulator value
	 * @return {accumulator}
	 */
	reduce: function(fn, initialValue) {
		initialValue = initialValue || 0;
		return this.selection.reduce(
			function(accumulator, item, idx, array) {
				if(typeof fn.call == 'undefined'){
					return fn(accumulator,item, idx, array);
				} else {
					return fn.call(item, accumulator,item, idx, array);
				}
			},
			initialValue
		);
	},

	/**
	 * isNumeric - Returns if value is numeric
	 *
	 * @param	{*} val Value
	 * @return {type}		 description
	 */
	isNumeric: function(val) {
		if (typeof val != 'undefined') {
			return isNumeric(val);
		}
		return isNumeric(this.selection[0]);
	},

	/**
	 * processMarkup - Process Markup of selected dom elements
	 *
	 * @return {Promise}
	 */
	processMarkup: function() {
		var self = this;
		return new Promise(function(resolve, reject) {
			self.each(function(el) {
				Mura.processMarkup(el);
			});
		});
	},

	/**
	 * addEventHandler - Add event event handling object
	 *
	 * @param	{string} selector	Selector (optional: for use with delegated events)
	 * @param	{object} handler				description
	 * @return {Mura.DOMSelection} Self
	 */
	addEventHandler:function(selector, handler){
		if (typeof handler == 'undefined') {
			handler = selector;
			selector = '';
		}
		for (var h in handler) {
			if(eventName.hasOwnProperty(h)){
				if(typeof selector == 'string' && selector){
					on(h, selector, handler[h]);
				} else {
					on(h,handler[h]);
				}
			}
		}
		return this;
	},

	/**
	 * on - Add event handling method
	 *
	 * @param	{string} eventName Event name
	 * @param	{string} selector	Selector (optional: for use with delegated events)
	 * @param	{function} fn				description
	 * @return {Mura.DOMSelection} Self
	 */
	on: function(eventName, selector, fn, EventListenerOptions) {
		if(typeof EventListenerOptions == 'undefined'){
			if(typeof fn != 'undefined' && typeof fn != 'function'){
				EventListenerOptions=fn;
			} else {
				EventListenerOptions=true;
			}
		}
		if (typeof selector == 'function') {
			fn = selector;
			selector = '';
		}
		if (eventName == 'ready') {
			if (document.readyState != 'loading') {
				var self = this;
				setTimeout(
					function() {
						self.each(function() {
							if (selector) {
								Mura(this).find(
									selector
								).each(
									function() {
										if(typeof fn.call =='undefined'){
											fn(this);
										} else {
											fn.call(this,this);
										}
								});
							} else {
								if(typeof fn.call =='undefined'){
									fn(this);
								} else {
									fn.call(this,this);
								}
							}
						});
					},
					1
				);
				return this;
			} else {
				eventName = 'DOMContentLoaded';
			}
		}

		this.each(function() {
				if (typeof this.addEventListener ==
						'function') {
						var self = this;
						this.addEventListener(
								eventName,
								function(event) {
									if (selector) {
										if (Mura(event.target).is(selector)) {
											if(typeof fn.call == 'undefined'){
												return fn(event);
											} else {
												return fn.call(event.target,event);
											}
										}
									} else {
										if(typeof fn.call == 'undefined'){
											return fn(event);
										} else {
											return fn.call(self,event);
										}
									}
								},
								EventListenerOptions
						);
				}
		});
		return this;
	},

	/**
	 * hover - Adds hovering events to selected dom elements
	 *
	 * @param	{function} handlerIn	In method
	 * @param	{function} handlerOut Out method
	 * @return {object}						Self
	 */
	hover: function(handlerIn, handlerOut, EventListenerOptions) {
		if(typeof EventListenerOptions =='undefined' || EventListenerOptions == null){
			EventListenerOptions= Mura.supportsPassive ? { passive: true } : false;
		}
		this.on('mouseover', handlerIn, EventListenerOptions);
		this.on('mouseout', handlerOut, EventListenerOptions);
		this.on('touchstart', handlerIn, EventListenerOptions);
		this.on('touchend', handlerOut, EventListenerOptions);
		return this;
	},

	/**
	 * click - Adds onClick event handler to selection
	 *
	 * @param	{function} fn Handler function
	 * @return {Mura.DOMSelection} Self
	 */
	click: function(fn) {
		this.on('click', fn);
		return this;
	},

	/**
	 * change - Adds onChange event handler to selection
	 *
	 * @param	{function} fn Handler function
	 * @return {Mura.DOMSelection} Self
	 */
	change: function(fn) {
		this.on('change', fn);
		return this;
	},

	/**
	 * submit - Adds onSubmit event handler to selection
	 *
	 * @param	{function} fn Handler function
	 * @return {Mura.DOMSelection} Self
	 */
	submit: function(fn) {
		if (fn) {
			this.on('submit', fn);
		} else {
			this.each(function(el) {
				if (typeof el.submit == 'function') {
					Mura.submitForm(el);
				}
			});
		}
		return this;
	},

	/**
	 * ready - Adds onReady event handler to selection
	 *
	 * @param	{function} fn Handler function
	 * @return {Mura.DOMSelection} Self
	 */
	ready: function(fn) {
		this.on('ready', fn);
		return this;
	},

	/**
	 * off - Removes event handler from selection
	 *
	 * @param	{string} eventName Event name
	 * @param	{function} fn			Function to remove	(optional)
	 * @return {Mura.DOMSelection} Self
	 */
	off: function(eventName, fn) {
		this.each(function(el, idx, array) {
			if (typeof eventName != 'undefined') {
				if (typeof fn != 'undefined') {
					el.removeEventListener(eventName, fn);
				} else {
					el[eventName] = null;
				}
			} else {
				if (typeof el.parentElement !=
					'undefined' && el.parentElement &&
					typeof el.parentElement.replaceChild !=
					'undefined') {
					var elClone = el.cloneNode(true);
					el.parentElement.replaceChild(elClone, el);
					array[idx] = elClone;
				} else {
					console.log("Mura: Can not remove all handlers from element without a parent node")
				}
			}
		});
		return this;
	},

	/**
	 * unbind - Removes event handler from selection
	 *
	 * @param	{string} eventName Event name
	 * @param	{function} fn			Function to remove	(optional)
	 * @return {Mura.DOMSelection} Self
	 */
	unbind: function(eventName, fn) {
		this.off(eventName, fn);
		return this;
	},

	/**
	 * bind - Add event handling method
	 *
	 * @param	{string} eventName Event name
	 * @param	{string} selector	Selector (optional: for use with delegated events)
	 * @param	{function} fn				description
	 * @return {Mura.DOMSelection}					 Self
	 */
	bind: function(eventName, fn) {
		this.on(eventName, fn);
		return this;
	},

	/**
	 * trigger - Triggers event on selection
	 *
	 * @param	{string} eventName	 Event name
	 * @param	{object} eventDetail Event properties
	 * @return {Mura.DOMSelection}						 Self
	 */
	trigger: function(eventName, eventDetail) {
		eventDetail = eventDetail || {};
		this.each(function(el) {
			Mura.trigger(el, eventName,eventDetail);
		});
		return this;
	},

	/**
	 * parent - Return new Mura.DOMSelection of the first elements parent
	 *
	 * @return {Mura.DOMSelection}
	 */
	parent: function() {
		if (!this.selection.length) {
			return this;
		}
		return Mura(this.selection[0].parentNode);
	},

	/**
	 * children - Returns new Mura.DOMSelection or the first elements children
	 *
	 * @param	{string} selector Filter (optional)
	 * @return {Mura.DOMSelection}
	 */
	children: function(selector) {
		if (!this.selection.length) {
			return this;
		}
		if (this.selection[0].hasChildNodes()) {
			var children = Mura(this.selection[0].childNodes);
			if (typeof selector == 'string') {
				var filterFn = function() {
					return (this.nodeType === 1 || this.nodeType === 11 ||this.nodeType === 9) &&	this.matchesSelector(selector);
				};
			} else {
				var filterFn = function() {
					return this.nodeType === 1 ||	this.nodeType === 11 ||	this.nodeType === 9;
				};
			}
			return children.filter(filterFn);
		} else {
			return Mura([]);
		}
	},


	/**
	 * find - Returns new Mura.DOMSelection matching items under the first selection
	 *
	 * @param	{string} selector Selector
	 * @return {Mura.DOMSelection}
	 */
	find: function(selector) {
		if (this.selection.length && this.selection[0]) {
			var removeId = false;
			if (this.selection[0].nodeType == '1' ||
				this.selection[0].nodeType == '11') {
				var result = this.selection[0].querySelectorAll(selector);
			} else if (this.selection[0].nodeType =='9') {
				var result = document.querySelectorAll(selector);
			} else {
				var result = [];
			}
			return Mura(result);
		} else {
				return Mura([]);
		}
	},

	/**
	 * first - Returns first item in selection
	 *
	 * @return {*}
	 */
	first: function() {
		if (this.selection.length) {
			return Mura(this.selection[0]);
		} else {
			return Mura([]);
		}
	},

	/**
	 * last - Returns last item in selection
	 *
	 * @return {*}
	 */
	last: function() {
		if (this.selection.length) {
			return Mura(this.selection[this.selection.length - 1]);
		} else {
			return Mura([]);
		}
	},

	/**
	 * selector - Returns css selector for first item in selection
	 *
	 * @return {string}
	 */
	selector: function() {
		var pathes = [];
		var path, node = Mura(this.selection[0]);
		while (node.length) {
			var realNode = node.get(0),
				name = realNode.localName;
			if (!name) {
				break;
			}
			if (!node.data('hastempid') && node.attr('id') && node.attr('id') != 'mura-variation-el') {
				name = '#' + node.attr('id');
				path = name + (path ? ' > ' + path : '');
				break;
			} else {
				name = name.toLowerCase();
				var parent = node.parent();
				var sameTagSiblings = parent.children(name);
				if (sameTagSiblings.length > 1) {
					var allSiblings = parent.children();
					var index = allSiblings.index(realNode) + 1;
					if (index > 0) {name += ':nth-child(' + index + ')';}
				}
				path = name + (path ? ' > ' + path : '');
				node = parent;
			}
		}
		pathes.push(path);
		return pathes.join(',');
	},

	/**
	 * siblings - Returns new Mura.DOMSelection of first item's siblings
	 *
	 * @param	{string} selector Selector to filter siblings (optional)
	 * @return {Mura.DOMSelection}
	 */
	siblings: function(selector) {
		if (!this.selection.length) {
			return this;
		}
		var el = this.selection[0];
		if (el.hasChildNodes()) {
			var silbings = Mura(this.selection[0].childNodes);
			if (typeof selector == 'string') {
				var filterFn = function() {
					return (this.nodeType === 1 |	this.nodeType === 11 || this.nodeType === 9) && this.matchesSelector(selector);
				};
			} else {
				var filterFn = function() {
					return this.nodeType === 1 ||	this.nodeType === 11 ||	this.nodeType === 9;
				};
			}
			return silbings.filter(filterFn);
		} else {
			return Mura([]);
		}
	},

	/**
	 * item - Returns item at selected index
	 *
	 * @param	{number} idx Index to return
	 * @return {*}
	 */
	item: function(idx) {
		return this.selection[idx];
	},

	/**
	 * index - Returns the index of element
	 *
	 * @param	{*} el Element to return index of
	 * @return {*}
	 */
	index: function(el) {
		return this.selection.indexOf(el);
	},

	/**
	 * indexOf - Returns the index of element
	 *
	 * @param	{*} el Element to return index of
	 * @return {*}
	 */
	indexOf: function(el) {
		return this.selection.indexOf(el);
	},

	/**
	 * closest - Returns new Mura.DOMSelection of closest parent matching selector
	 *
	 * @param	{string} selector Selector
	 * @return {Mura.DOMSelection}
	 */
	closest: function(selector) {
		if (!this.selection.length) {
			return null;
		}
		var el = this.selection[0];
		for (var parent = el; parent !== null && parent.matchesSelector && !parent.matchesSelector(selector); parent = el.parentElement) {
			el = parent;
		};
		if (parent) {
			return Mura(parent)
		} else {
			return Mura([]);
		}
	},

	/**
	 * append - Appends element to items in selection
	 *
	 * @param	{*} el Element to append
	 * @return {Mura.DOMSelection} Self
	 */
	append: function(el) {
		this.each(function() {
			if (typeof el == 'string') {
				this.insertAdjacentHTML('beforeend', el);
			} else {
				this.appendChild(el);
			}
		});
		return this;
	},

	/**
	 * appendDisplayObject - Appends display object to selected items
	 *
	 * @param	{object} data Display objectparams (including object='objectkey')
	 * @return {Promise}
	 */
	appendDisplayObject: function(data) {
		var self = this;
		delete data.method;
		if(typeof data.transient == 'undefined'){
			data.transient=true;
		}
		return new Promise(function(resolve, reject) {
			self.each(function() {
				var el = document.createElement('div');
				el.setAttribute('class','mura-object');
				for (var a in data) {
					el.setAttribute('data-' + a,data[a]);
				}
				if (typeof data.async == 'undefined') {
					el.setAttribute('data-async',true);
				}
				if (typeof data.render == 'undefined') {
					el.setAttribute('data-render','server');
				}
				el.setAttribute('data-instanceid',Mura.createUUID());
				var self=this;
				function watcher(){
					if(Mura.markupInitted){
						Mura(self).append(el);
						Mura.processDisplayObject(el,true,true).then(resolve, reject);
					} else {
						setTimeout(watcher);
					}
				}
				watcher();
			});
		});
	},

	/**
	 * appendModule - Appends display object to selected items
	 *
	 * @param	{object} data Display objectparams (including object='objectkey')
	 * @return {Promise}
	 */
	appendModule: function(data) {
		return this.appendDisplayObject(data);
	},

	/**
	 * insertDisplayObjectAfter - Inserts display object after selected items
	 *
	 * @param	{object} data Display objectparams (including object='objectkey')
	 * @return {Promise}
	 */
	insertDisplayObjectAfter: function(data) {
		var self = this;
		delete data.method;
		if(typeof data.transient == 'undefined'){
			data.transient=true;
		}
		return new Promise(function(resolve, reject) {
			self.each(function() {
				var el = document.createElement('div');
				el.setAttribute('class','mura-object');
				for (var a in data) {
					el.setAttribute('data-' + a,data[a]);
				}
				if (typeof data.async == 'undefined') {
					el.setAttribute('data-async',true);
				}
				if (typeof data.render == 'undefined') {
					el.setAttribute('data-render','server');
				}
				el.setAttribute('data-instanceid',Mura.createUUID());
				var self=this;
				function watcher(){
					if(Mura.markupInitted){
						Mura(self).after(el);
						Mura.processDisplayObject(el,true,true).then(resolve, reject);
					} else {
						setTimeout(watcher);
					}
				}
				watcher();
			});
		});
	},

	/**
	 * insertModuleAfter - Appends display object to selected items
	 *
	 * @param	{object} data Display objectparams (including object='objectkey')
	 * @return {Promise}
	 */
	insertModuleAfter: function(data) {
		return this.insertDisplayObjectAfter(data);
	},

	/**
	 * insertDisplayObjectBefore - Inserts display object after selected items
	 *
	 * @param	{object} data Display objectparams (including object='objectkey')
	 * @return {Promise}
	 */
	insertDisplayObjectBefore: function(data) {
		var self = this;
		delete data.method;
		if(typeof data.transient == 'undefined'){
			data.transient=true;
		}
		return new Promise(function(resolve, reject) {
			self.each(function() {
				var el = document.createElement('div');
				el.setAttribute('class','mura-object');
				for (var a in data) {
					el.setAttribute('data-' + a,data[a]);
				}
				if (typeof data.async == 'undefined') {
					el.setAttribute('data-async',true);
				}
				if (typeof data.render == 'undefined') {
					el.setAttribute('data-render','server');
				}
				el.setAttribute('data-instanceid',Mura.createUUID());
				var self=this;
				function watcher(){
					if(Mura.markupInitted){
						Mura(self).before(el);
						Mura.processDisplayObject(el,true,true).then(resolve, reject);
					} else {
						setTimeout(watcher);
					}
				}
				watcher();
			});
		});
	},

	/**
	 * insertModuleBefore - Appends display object to selected items
	 *
	 * @param	{object} data Display objectparams (including object='objectkey')
	 * @return {Promise}
	 */
	insertModuleBefore: function(data) {
		return this.insertDisplayObjectBefore(data);
	},

	/**
	 * prependDisplayObject - Prepends display object to selected items
	 *
	 * @param	{object} data Display objectparams (including object='objectkey')
	 * @return {Promise}
	 */
	prependDisplayObject: function(data) {
		var self = this;
		delete data.method;
		if(typeof data.transient == 'undefined'){
			data.transient=true;
		}
		return new Promise(function(resolve, reject) {
			self.each(function() {
				var el = document.createElement('div');
				el.setAttribute('class','mura-object');
				for (var a in data) {
					el.setAttribute('data-' + a,data[a]);
				}
				if (typeof data.async == 'undefined') {
					el.setAttribute('data-async',true);
				}
				if (typeof data.render == 'undefined') {
					el.setAttribute('data-render','server');
				}
				el.setAttribute('data-instanceid',Mura.createUUID());
				var self=this;
				function watcher(){
					if(Mura.markupInitted){
						Mura(self).prepend(el);
						Mura.processDisplayObject(el,true,true).then(resolve, reject);
					} else {
						setTimeout(watcher);
					}
				}
				watcher();
			});
		});
	},

	/**
	 * prependModule - Prepends display object to selected items
	 *
	 * @param	{object} data Display objectparams (including object='objectkey')
	 * @return {Promise}
	 */
	prependModule: function(data) {
		return this.prependDisplayObject(data);
	},

	/**
	 * processDisplayObject - Handles processing of display object params to selection
	 *
	 * @return {Promise}
	 */
	processDisplayObject: function() {
		var self = this;
		return new Promise(function(resolve, reject) {
			self.each(function() {
				Mura.processDisplayObject(
					this,true,true).then(
					resolve, reject
				);
			});
		});
	},

	/**
	 * processModule - Prepends display object to selected items
	 *
	 * @return {Promise}
	 */
	processModule: function() {
		return this.processDisplayObject();
	},

	/**
	 * prepend - Prepends element to items in selection
	 *
	 * @param	{*} el Element to append
	 * @return {Mura.DOMSelection} Self
	 */
	prepend: function(el) {
		this.each(function() {
			if (typeof el == 'string') {
				this.insertAdjacentHTML('afterbegin', el);
			} else {
				this.insertBefore(el, this.firstChild);
			}
		});
		return this;
	},

	/**
	 * before - Inserts element before items in selection
	 *
	 * @param	{*} el Element to append
	 * @return {Mura.DOMSelection} Self
	 */
	before: function(el) {
		this.each(function() {
			if (typeof el == 'string') {
				this.insertAdjacentHTML('beforebegin', el);
			} else {
				this.parentNode.insertBefore(el,this);
			}
		});
		return this;
	},

	/**
	 * after - Inserts element after items in selection
	 *
	 * @param	{*} el Element to append
	 * @return {Mura.DOMSelection} Self
	 */
	after: function(el) {
		this.each(function() {
			if (typeof el == 'string') {
				this.insertAdjacentHTML('afterend', el);
			} else {
				if(this.nextSibling){
					this.parentNode.insertBefore(el, this.nextSibling);
				} else {
					this.parentNode.appendChild(el);
				}
				
			}
		});
		return this;
	},

	/**
	 * hide - Hides elements in selection
	 *
	 * @return {object}	Self
	 */
	hide: function() {
		this.each(function(el) {
			el.style.display = 'none';
		});
		return this;
	},

	/**
	 * show - Shows elements in selection
	 *
	 * @return {object}	Self
	 */
	show: function() {
		this.each(function(el) {
			el.style.display = '';
		});
		return this;
	},

	/**
	 * repaint - repaints elements in selection
	 *
	 * @return {object}	Self
	 */
	redraw: function() {
		this.each(function(el) {
			var elm = Mura(el);
			setTimeout(
				function() {
					elm.show();
				},
				1
			);
		});
		return this;
	},

	/**
	 * remove - Removes elements in selection
	 *
	 * @return {object}	Self
	 */
	remove: function() {
		this.each(function(el) {
			el.parentNode && el.parentNode.removeChild(el);
		});
		return this;
	},

	/**
	 * addClass - Adds class to elements in selection
	 *
	 * @param	{string} className Name of class
	 * @return {Mura.DOMSelection} Self
	 */
	addClass: function(className) {
		if (className.length) {
			this.each(function(el) {
				if (el.classList) {
					el.classList.add(className);
				} else {
					el.className += ' ' + className;
				}
			});
		}
		return this;
	},

	/**
	 * hasClass - Returns if the first element in selection has class
	 *
	 * @param	{string} className Class name
	 * @return {Mura.DOMSelection} Self
	 */
	hasClass: function(className) {
			return this.is("." + className);
	},

	/**
	 * removeClass - Removes class from elements in selection
	 *
	 * @param	{string} className Class name
	 * @return {Mura.DOMSelection} Self
	 */
	removeClass: function(className) {
		this.each(function(el) {
			if (el.classList) {
				el.classList.remove(className);
			} else if (el.className) {
				el.className = el.className.replace(new RegExp('(^|\\b)' + className.split(' ').join('|') + '(\\b|$)', 'gi'), ' ');
			}
		});
		return this;
	},

	/**
	 * toggleClass - Toggles class on elements in selection
	 *
	 * @param	{string} className Class name
	 * @return {Mura.DOMSelection} Self
	 */
	toggleClass: function(className) {
		this.each(function(el) {
			if (el.classList) {
				el.classList.toggle(className);
			} else {
				var classes = el.className.split(' ');
				var existingIndex = classes.indexOf(className);

				if (existingIndex >= 0)
					classes.splice(existingIndex, 1);
				else
					classes.push(className);

				el.className = classes.join(' ');
			}
		});
		return this;
	},

	/**
	 * empty - Removes content from elements in selection
	 *
	 * @return {object}	Self
	 */
	empty: function() {
		this.each(function(el) {
			el.innerHTML = '';
		});
		return this;
	},

	/**
	 * evalScripts - Evaluates script tags in selection elements
	 *
	 * @return {object}	Self
	 */
	evalScripts: function() {
		if (!this.selection.length) {
			return this;
		}
		this.each(function(el) {
			Mura.evalScripts(el);
		});
		return this;
	},

	/**
	 * html - Returns or sets HTML of elements in selection
	 *
	 * @param	{string} htmlString description
	 * @return {object}						Self
	 */
	html: function(htmlString) {
		if (typeof htmlString != 'undefined') {
			this.each(function(el) {
				el.innerHTML = htmlString;
				Mura.evalScripts(el);
			});
			return this;
		} else {
			if (!this.selection.length) {
				return '';
			}
			return this.selection[0].innerHTML;
		}
	},

	/**
	 * css - Sets css value for elements in selection
	 *
	 * @param	{string} ruleName Css rule name
	 * @param	{string} value		Rule value
	 * @return {object}					Self
	 */
	css: function(ruleName, value) {
		if (!this.selection.length) {
			return this;
		}
		if (typeof ruleName == 'undefined' && typeof value == 'undefined') {
			try {
				return getComputedStyle(this.selection[0]);
			} catch (e) {
				console.log(e)
				return {};
			}
		} else if (typeof ruleName == 'object') {
			this.each(function(el) {
				try {
					for (var p in ruleName) {
						el.style[p] = ruleName[p];
					}
				} catch (e) {console.log(e)}
			});
		} else if (typeof value != 'undefined') {
			this.each(function(el) {
				try {
					el.style[ruleName] = value;
				} catch (e) {console.log(e)}
			});
			return this;
		} else {
			try {
				return getComputedStyle(this.selection[	0])[ruleName];
			} catch (e) {console.log(e)}
		}
	},

	/**
	 * calculateDisplayObjectStyles - Looks at data attrs and sets appropriate styles
	 *
	 * @return {object}	Self
	 */
	 calculateDisplayObjectStyles: function(windowResponse) {
		var styleMap={'alignContent':'align-content',
			'alignItems':'align-items',
			'alignSelf':'align-self',
			'animationDuration':'animation-duration',
			'animationName':'animation-name',
			'backgroundAttachment':'background-attachment',
			'backgroundColor':'background-color',
			'backgroundImage':'background-image',
			'backgroundOrigin':'background-origin',
			'backgroundPosition':'background-position',
			'backgroundRepeat':'background-repeat',
			'backgroundSize':'background-size',
			'borderRadius':'border-radius',
			'borderStyle':'border-style',
			'borderWidth':'border-width',
			'borderColor':'border-color',
			'boxSizing':'box-sizing',
			'color':'color',
			'display':'display',
			'flex':'flex',
			'flexGrow':'flex-grow',
			'flexShrink':'flex-shrink',
			'float':'float',
			'fontFamily':'font-family',
			'fontSize':'font-size',
			'fontVariant':'font-variant',
			'fontWeight':'font-weight',
			'justifyContent':'justify-content',
			'justifySelf':'justify-self',
			'letterSpacing':'letter-spacing',
			'lineHeight':'line-height',
			'marginBottom':'margin-bottom',
			'marginLeft':'margin-left',
			'marginRight':'margin-right',
			'marginTop':'margin-top',
			'maxHeight':'max-height',
			'minHeight':'min-height',
			'opacity':'opacity',
			'order':'order',
			'outlineColor':'outline-color',
			'outlineOffset':'outline-offset',
			'outlineStyle':'outline-style',
			'outlineWidth':'outline-width',
			'overflow':'overflow',
			'overflowX':'overflow-x',
			'overflowY':'overflow-y',
			'paddingBottom':'padding-bottom',
			'paddingLeft':'padding-left',
			'paddingRight':'padding-right',
			'paddingTop':'padding-top',
			'textAlign':'text-align',
			'textDecoration':'text-decoration',
			'textIndent':'text-indent',
			'textOverflow':'text-overflow',
			'textShadow':'text-shadow',
			'textTransform':'text-transform',
			'transitionDelay':'transition-delay',
			'transitionDuration':'transition-duration',
			'transitionProperty':'transition-property',
			'transitionTimingFunction':'transition-timing-function',
			'verticalAlign':'vertical-align',
			'webkitTransition':'-webkit-transition',
			'width':'width',
			'whiteSpace':'white-space',
			'wordSpacing':'word-spacing',
			'zIndex':'z-index'
		}
 		this.each(function(el) {

			function handleBackround(styles){
				var hasLayeredBg=(styles && typeof styles.backgroundColor != 'undefined' && styles.backgroundColor
				&& typeof styles.backgroundImage != 'undefined' && styles.backgroundImage);	
				
				if(hasLayeredBg){
					styles.backgroundImage='linear-gradient(' + styles.backgroundColor + ', ' + styles.backgroundColor +' ), ' + styles.backgroundImage;
				}
			}

			function handleTextColor(sheet,selector,styles){
				try{
					if(styles.color){
						var style=selector + ', ' + selector + ' label, ' + selector + ' p, ' + selector + ' h1, ' + selector + ' h2, ' + selector + ' h3, ' + selector + ' h4, ' + selector + ' h5, ' + selector + ' h6, ' +selector + ' a:link, ' + selector + ' a:visited, '  + selector + ' a:hover, ' + selector + ' .breadcrumb-item + .breadcrumb-item::before, ' + selector + ' a:active { color:' + styles.color + ';} ';
						sheet.insertRule(
							style,
							sheet.cssRules.length
						);
						sheet.insertRule(
							selector + ' * {color:inherit}',
							sheet.cssRules.length
						);
						sheet.insertRule(
							selector + ' hr { border-color:' + styles.color + ';}',
							sheet.cssRules.length
						);
					}
				} catch (e){
					console.log("error adding color: " + styles.color);
					console.log(e);
				}
			}
			 
			var obj=Mura(el);
			var breakpoints=['mura-xs','mura-sm','mura-md','mura-lg'];
			var objBreakpoint='mura-sm';
			
			for(var b=0;b<breakpoints.length;b++){
				if(obj.is('.' + breakpoints[b])){
					objBreakpoint=breakpoints[b];
					break;
				}
			}
			
			var fullsize=breakpoints.indexOf('mura-' + Mura.getBreakpoint()) >= breakpoints.indexOf(objBreakpoint);
			
			Mura.windowResponsiveModules=Mura.windowResponsiveModules||{};
			Mura.windowResponsiveModules[obj.data('instanceid')]=false;

 			obj = (obj.node) ? obj : Mura(obj);
 			var self = obj.node;
 			if (obj.data('class')) {
 				var classes = obj.data('class');
 				if (typeof classes != 'Array') {
 					var classes = classes.split(' ');
 				}
 				for (var c = 0; c < classes.length; c++) {
 					if (!obj.hasClass(classes[c])) {
 						obj.addClass(classes[c]);
 					}
 				}
 			}
 			if (obj.data('cssclass')) {
 				var classes = obj.data('cssclass');
 				if (typeof classes != 'array') {
 					var classes = classes.split(' ');
 				}
 				for (var c = 0; c < classes.length; c++) {
 					if (!obj.hasClass(classes[c])) {
 						obj.addClass(classes[c]);
 					}
 				}
 			}
 			if(obj.data('cssid')){
 				obj.attr('id',obj.data('cssid'));
 			} else {
 				obj.removeAttr('id');
 			}

			var styleSupport=obj.data('stylesupport') || {};

			if(typeof styleSupport == 'string'){
				styleSupport={};
			}
			var objectstyles={};

			if(styleSupport && styleSupport.objectstyles){
				objectstyles=styleSupport.objectstyles;
			}

			obj.removeAttr('style');
			if(!fullsize){
				delete objectstyles.margin;
				delete objectstyles.marginLeft;
				delete objectstyles.marginRight;
				delete objectstyles.marginTop;
				delete objectstyles.marginBottom;
			}

			if(!fullsize || (fullsize && !(
				obj.css('marginTop')=='0px'
				&& obj.css('marginBottom')=='0px'
				&& obj.css('marginLeft')=='0px'
				&& obj.css('marginRight')=='0px'
			))){
				Mura.windowResponsiveModules[obj.data('instanceid')]=true;
			}

			if(!windowResponse){
				var sheet=Mura.getStyleSheet('mura-styles-' + obj.data('instanceid'));

					while (sheet.cssRules.length) {
						sheet.deleteRule(0);
					}
				
				var objectAccumulator={};
					
				if(typeof objectstyles == 'string'){
					objectstyles={};
				}
				objectstyles=objectstyles || {};

				handleBackround(objectstyles);
	
				var selector='div.mura-object[data-instanceid="' + obj.data('instanceid') + '"]';
				var dyncss='';
				objectAccumulator=Mura.extend(objectAccumulator,objectstyles);
				for(var s in objectAccumulator){
					if(objectAccumulator.hasOwnProperty(s)){
						if(typeof styleMap[s] != 'undefined'){
							dyncss += styleMap[s]  + ': ' + objectAccumulator[s] + '!important;';
						} else {
							obj.css(s,objectAccumulator[s]);
						}		
					}
				}
				if(dyncss){
					try {
						//console.log(selector + ' {' + dyncss+ '}')
						sheet.insertRule(
							selector + ' {' + dyncss+ '}',
							sheet.cssRules.length
						);
					} catch (e){
						console.log(selector + ' {' + dyncss+ '}')
						console.log(e);
					}
				}

				handleTextColor(sheet,selector,objectstyles);
				
				if(typeof styleSupport['object_lg_styles'] == 'string'){
					styleSupport['object_lg_styles']={};
				}
				styleSupport['object_lg_styles']=styleSupport['object_lg_styles'] || {};
				var selector='@media (min-width: 992px) and (max-width: 1199px) { div.mura-object[data-instanceid="' + obj.data('instanceid') + '"]';
				var selector2='@media (min-width: 1292px) and (max-width: 1399px) { .mura-editing div.mura-object[data-instanceid="' + obj.data('instanceid') + '"]';
				var dyncss='';

				handleBackround(styleSupport['object_lg_styles']);

				objectAccumulator=Mura.extend(objectAccumulator,styleSupport['object_lg_styles']);
				for(var s in objectAccumulator){
					if(objectAccumulator.hasOwnProperty(s)){
						if(typeof styleMap[s] != 'undefined'){
							dyncss += styleMap[s]  + ': ' + objectAccumulator[s] + '!important;';
						}		
					}
				}
				if(dyncss){
					try {
						sheet.insertRule(
							selector + ' {' + dyncss+ '}',
							sheet.cssRules.length
						);
						sheet.insertRule(
							selector2 + ' {' + dyncss+ '}',
							sheet.cssRules.length
						);
					} catch (e){
						console.log(selector + ' {' + dyncss+ '}}')
						console.log(e);
					}
				}

				handleTextColor(sheet,selector,objectAccumulator);
				handleTextColor(sheet,selector2,objectAccumulator);

				if(typeof styleSupport['object_md_styles'] == 'string'){
					styleSupport['object_md_styles']={};
				}
				styleSupport['object_md_styles']=styleSupport['object_md_styles'] || {};
				var selector='@media (min-width: 768px) and (max-width: 991px) { div.mura-object[data-instanceid="' + obj.data('instanceid') + '"]';
				var selector2='@media (min-width: 1068px) and (max-width: 1291px) { .mura-editing div.mura-object[data-instanceid="' + obj.data('instanceid') + '"]';
				var dyncss='';

				handleBackround(styleSupport['object_md_styles']);

				objectAccumulator=Mura.extend(objectAccumulator,styleSupport['object_md_styles']);
				for(var s in objectAccumulator){
					if(objectAccumulator.hasOwnProperty(s)){
						if(typeof styleMap[s] != 'undefined'){
							dyncss += styleMap[s]  + ': ' + objectAccumulator[s] + '!important;';
						}		
					}
				}
				if(dyncss){
					try {
						sheet.insertRule(
							selector + ' {' + dyncss+ '}',
							sheet.cssRules.length
						);
						sheet.insertRule(
							selector2 + ' {' + dyncss+ '}',
							sheet.cssRules.length
						);
					} catch (e){
						console.log(selector + ' {' + dyncss+ '}}')
						console.log(e);
					}
				}

				handleTextColor(sheet,selector,objectAccumulator);
				handleTextColor(sheet,selector2,objectAccumulator);

				if(typeof styleSupport['object_sm_styles'] == 'string'){
					styleSupport['object_sm_styles']={};
				}
				styleSupport['object_sm_styles']=styleSupport['object_sm_styles'] || {};
				var selector='@media (min-width: 576px) and (max-width: 767px) { div.mura-object[data-instanceid="' + obj.data('instanceid') + '"]';
				var selector2='@media (min-width: 876px) and (max-width: 1067px) { .mura-editing div.mura-object[data-instanceid="' + obj.data('instanceid') + '"]';
				var dyncss='';

				handleBackround(styleSupport['object_sm_styles']);

				objectAccumulator=Mura.extend(objectAccumulator,styleSupport['object_sm_styles']);
				for(var s in objectAccumulator){
					if(objectAccumulator.hasOwnProperty(s)){
						if(typeof styleMap[s] != 'undefined'){
							dyncss += styleMap[s]  + ': ' + objectAccumulator[s] + '!important;';
						}		
					}
				}
				if(dyncss){
					try {
						sheet.insertRule(
							selector + ' {' + dyncss+ '}',
							sheet.cssRules.length
						);
						sheet.insertRule(
							selector2 + ' {' + dyncss+ '}',
							sheet.cssRules.length
						);
					} catch (e){
						console.log(selector + ' {' + dyncss+ '}}')
						console.log(e);
					}
				}

				handleTextColor(sheet,selector,objectAccumulator);
				handleTextColor(sheet,selector2,objectAccumulator);

				if(typeof styleSupport['object_xs_styles'] == 'string'){
					styleSupport['object_xs_styles']={};
				}
				styleSupport['object_xs_styles']=styleSupport['object_xs_styles'] || {};
				var selector='@media (max-width: 575px) { div.mura-object[data-instanceid="' + obj.data('instanceid') + '"]';
				var selector2='@media (max-width: 875px) { .mura-editing div.mura-object[data-instanceid="' + obj.data('instanceid') + '"]';
				var dyncss='';

				handleBackround(styleSupport['object_xs_styles']);

				objectAccumulator=Mura.extend(objectAccumulator,styleSupport['object_xs_styles']);
				for(var s in objectAccumulator){
					if(objectAccumulator.hasOwnProperty(s)){
						if(typeof styleMap[s] != 'undefined'){
							dyncss += styleMap[s]  + ': ' + objectAccumulator[s] + '!important;';
						}		
					}
				}
				if(dyncss){
					try {
						//console.log(selector + ' {' + dyncss+ '}}')
						sheet.insertRule(
							selector + ' {' + dyncss+ '}',
							sheet.cssRules.length
						);
						sheet.insertRule(
							selector2 + ' {' + dyncss+ '}',
							sheet.cssRules.length
						);
					} catch (e){
						console.log(selector + ' {' + dyncss+ '}}')
						console.log(e);
					}
				}

				handleTextColor(sheet,selector,objectAccumulator);
				handleTextColor(sheet,selector2,objectAccumulator);

				if(styleSupport.css){
					var styles=styleSupport.css.split('}');
					if(Array.isArray(styles) && styles.length){
						styles.forEach(function(style){
							var styleParts=style.split("{");
							if(styleParts.length > 1){
								var selectors=styleParts[0].split(',');
								selectors.forEach(function(subSelector){
									try{
										var subStyle=selector + ' ' + subSelector.replace(/\$self/g,'') + '{' + styleParts[1] + '}';
										sheet.insertRule(
											subStyle,
											sheet.cssRules.length
										);
										if(Mura.editing){
											console.log('Applying dynamic styles:' + subStyle);
										}
									} catch(e){
										if(Mura.editing){
											console.log('Error applying dynamic styles:' + subStyle);
											console.log(e);
										}
									}
								});
							}
						});
					}
				}
			}
 			
			var metaWrapper=obj.children('.mura-object-meta-wrapper');
			if(metaWrapper.length){
				styleSupport.metastyles=styleSupport.metastyles || {}; 
				var meta=metaWrapper.children('.mura-object-meta');
				if(meta.length){
					var metastyles={};
					if(styleSupport && styleSupport.metastyles){
						metastyles=styleSupport.metastyles;
					}

					var hasLayeredBg=false;

					if(!windowResponse){
						var metaAccumulator={};
						if(typeof metastyles == 'string'){
							metastyles={};
						}
						metastyles=metastyles || {};
						var selector='div.mura-object[data-instanceid="' + obj.data('instanceid') + '"] > div.mura-object-meta-wrapper > div.mura-object-meta';	
						var dyncss='';

						handleBackround(metastyles);

						metaAccumulator=Mura.extend(metaAccumulator,metastyles);
						for(var s in metaAccumulator){
							if(metaAccumulator.hasOwnProperty(s)){
								if(typeof styleMap[s] != 'undefined'){
									dyncss += styleMap[s]  + ': ' + metaAccumulator[s] + '!important;';
								} else {
									meta.css(s,metaAccumulator[s]);
								}		
							}
						}
						if(dyncss){
							try {
								//console.log(selector + ' {' + dyncss+ '}')
								sheet.insertRule(
									selector + ' {' + dyncss+ '}',
									sheet.cssRules.length
								);
							} catch (e){
								console.log(selector + ' {' + dyncss+ '}')
								console.log(e);
							}
						}

						try {
							if( metastyles.color){
								var style=selector + ', ' + selector + ' label, ' + selector + ' p, ' + selector + ' h1, ' + selector + ' h2, ' + selector + ' h3, ' + selector + ' h4, ' + selector + ' h5, ' + selector + ' h6, ' +selector + ' a:link, ' + selector + ' a:visited, '  + selector + ' a:hover, ' + selector + ' .breadcrumb-item + .breadcrumb-item::before, ' + selector + ' a:active { color:' + metastyles.color + ';} ';
								sheet.insertRule(
									style,
									sheet.cssRules.length
								);
								sheet.insertRule(
									selector + ' * {color:inherit}',
									sheet.cssRules.length
								);
								sheet.insertRule(
									selector + ' hr { border-color:' + metastyles.color + ';}',
									sheet.cssRules.length
								);
							}
						} catch (e){
							console.log("error adding color: " + metastyles.color);
							console.log(e);
						}

						if(typeof styleSupport['meta_lg_styles'] == 'string'){
							styleSupport['meta_lg_styles']={};
						}
						styleSupport['meta_lg_styles']=styleSupport['meta_lg_styles'] || {}; 
						var selector='@media (min-width: 992px) and (max-width: 1199px) { div.mura-object[data-instanceid="' + obj.data('instanceid') + '"] > div.mura-object-meta-wrapper > div.mura-object-meta';
						var selector2='@media (min-width: 1292px) and (max-width: 1399px) { .mura-editing div.mura-object[data-instanceid="' + obj.data('instanceid') + '"] > div.mura-object-meta-wrapper > div.mura-object-meta';
						var dyncss='';

						handleBackround(styleSupport['meta_lg_styles']);

						metaAccumulator=Mura.extend(metaAccumulator,styleSupport['meta_lg_styles']);
						for(var s in metaAccumulator){
							if(metaAccumulator.hasOwnProperty(s)){
								if(typeof styleMap[s] != 'undefined'){
									dyncss += styleMap[s]  + ': ' + metaAccumulator[s] + '!important;';
								}		
							}
						}
						if(dyncss){
							try {
								sheet.insertRule(
									selector + ' {' + dyncss+ '}',
									sheet.cssRules.length
								);
								sheet.insertRule(
									selector2 + ' {' + dyncss+ '}',
									sheet.cssRules.length
								);
							} catch (e){
								console.log(selector + ' {' + dyncss+ '}}')
								console.log(e);
							}
						}
						
						if(typeof styleSupport['meta_md_styles'] == 'string'){
							styleSupport['meta_md_styles']={};
						}
						styleSupport['meta_md_styles']=styleSupport['meta_md_styles'] || {}; 
						var selector='@media (min-width: 768px) an (max-width: 991px) { div.mura-object[data-instanceid="' + obj.data('instanceid') + '"] > div.mura-object-meta-wrapper > div.mura-object-meta';
						var selector2='@media (min-width: 1068px) an (max-width: 1291px) { .mura-editing div.mura-object[data-instanceid="' + obj.data('instanceid') + '"] > div.mura-object-meta-wrapper > div.mura-object-meta';
						var dyncss='';

						handleBackround(styleSupport['meta_md_styles']);

						metaAccumulator=Mura.extend(metaAccumulator,styleSupport['meta_md_styles']);
						for(var s in metaAccumulator){
							if(metaAccumulator.hasOwnProperty(s)){
								if(typeof styleMap[s] != 'undefined'){
									dyncss += styleMap[s]  + ': ' + metaAccumulator[s] + '!important;';
								}		
							}
						}
						if(dyncss){
							try {
								sheet.insertRule(
									selector + ' {' + dyncss+ '}',
									sheet.cssRules.length
								);
								sheet.insertRule(
									selector2 + ' {' + dyncss+ '}',
									sheet.cssRules.length
								);
							} catch (e){
								console.log(selector + ' {' + dyncss+ '}}')
								console.log(e);
							}
						}

						if(typeof styleSupport['meta_sm_styles'] == 'string'){
							styleSupport['meta_sm_styles']={};
						}
						styleSupport['meta_sm_styles']=styleSupport['meta_sm_styles'] || {}; 
						var selector='@media (min-width: 576px) an (max-width: 767) { div.mura-object[data-instanceid="' + obj.data('instanceid') + '"] > div.mura-object-meta-wrapper > div.mura-object-meta';
						var selector2='@media (min-width: 876px) an (max-width: 1067) { .mura-editing div.mura-object[data-instanceid="' + obj.data('instanceid') + '"] > div.mura-object-meta-wrapper > div.mura-object-meta';
						var dyncss='';

						handleBackround(styleSupport['meta_sm_styles']);

						metaAccumulator=Mura.extend(metaAccumulator,styleSupport['meta_sm_styles']);
						for(var s in metaAccumulator){
							if(metaAccumulator.hasOwnProperty(s)){
								if(typeof styleMap[s] != 'undefined'){
									dyncss += styleMap[s]  + ': ' + metaAccumulator[s] + '!important;';
								}		
							}
						}
						if(dyncss){
							try {
								sheet.insertRule(
									selector + ' {' + dyncss+ '}',
									sheet.cssRules.length
								);
								sheet.insertRule(
									selector2 + ' {' + dyncss+ '}',
									sheet.cssRules.length
								);
							} catch (e){
								console.log(selector + ' {' + dyncss+ '}}')
								console.log(e);
							}
						}

						if(typeof styleSupport['meta_xs_styles'] == 'string'){
							styleSupport['meta_xs_styles']={};
						}
						styleSupport['meta_xs_styles']=styleSupport['meta_xs_styles'] || {}; 
						var selector='@media (max-width: 575) { div.mura-object[data-instanceid="' + obj.data('instanceid') + '"] > div.mura-object-meta-wrapper > div.mura-object-meta';
						var selector2='@media (max-width: 875) { .mura-editing div.mura-object[data-instanceid="' + obj.data('instanceid') + '"] > div.mura-object-meta-wrapper > div.mura-object-meta';
						var dyncss='';

						handleBackround(styleSupport['meta_xs_styles']);	

						metaAccumulator=Mura.extend(metaAccumulator,styleSupport['meta_xs_styles']);
						for(var s in metaAccumulator){
							if(metaAccumulator.hasOwnProperty(s)){
								if(typeof styleMap[s] != 'undefined'){
									dyncss += styleMap[s]  + ': ' + metaAccumulator[s] + '!important;';
								}		
							}
						}
						if(dyncss){
							try {
								sheet.insertRule(
									selector + ' {' + dyncss+ '}',
									sheet.cssRules.length
								);
								sheet.insertRule(
									selector2 + ' {' + dyncss+ '}',
									sheet.cssRules.length
								);
							} catch (e){
								console.log(selector + ' {' + dyncss+ '}}')
								console.log(e);
							}
						}
					}

					if(obj.data('metacssid')){
						meta.attr('id',obj.data('metacssid'));
					}
					if(obj.data('metacssclass')){
						obj.data('metacssclass').split(' ').forEach(function(c){
							if (!meta.hasClass(c)) {
								meta.addClass(c);
							}
						})
					}


					if(obj.is('.mura-object-label-left, .mura-object-label-right')){
						var left=meta.css('marginLeft');
						var right=meta.css('marginRight')
						if(!(left=='0px' && right=='0px') && left.charAt(0) != "-" && right.charAt(0) != "-"){
							meta.css('width','calc(50% - (' + left + ' + ' + right + '))');
						}
					}
				
				}
			}

			
			var contentstyles={};
			
			if(styleSupport && styleSupport.contentstyles && typeof contentstyles !='string'){
				contentstyles=styleSupport.contentstyles;
			}

			var content=obj.children('.mura-object-content').first();

			var selector='div.mura-object[data-instanceid="' + obj.data('instanceid') + '"] > div.mura-object-content';

			var hasLayeredBg=false;

			if(!windowResponse){
				var contentAccumulator={};

				contentstyles=contentstyles || {};
				var selector='div.mura-object[data-instanceid="' + obj.data('instanceid') + '"] > div.mura-object-content';
				var dyncss='';

				handleBackround(contentstyles);

				contentAccumulator=Mura.extend(contentAccumulator,contentstyles);
				for(var s in contentAccumulator){
					if(contentAccumulator.hasOwnProperty(s)){
						if(typeof styleMap[s] != 'undefined'){
							dyncss += styleMap[s]  + ': ' + contentAccumulator[s] + '!important;';
						} else {
							content.css(s,contentAccumulator[s]);
						}		
					}
				}
				if(dyncss){
					try {
						//console.log(selector + ' {' + dyncss+ '}')
						sheet.insertRule(
							selector + ' {' + dyncss+ '}',
							sheet.cssRules.length
						);
					} catch (e){
						console.log(selector + ' {' + dyncss+ '}')
						console.log(e);
					}
				}
				try {
					if(contentstyles.color){
						var style=selector + ', ' + selector + ' label, ' + selector + ' p, ' + selector + ' h1, ' + selector + ' h2, ' + selector + ' h3, ' + selector + ' h4, ' + selector + ' h5, ' + selector + ' h6, ' +selector + ' a:link, ' + selector + ' a:visited, '  + selector + ' a:hover, ' + selector + ' .breadcrumb-item + .breadcrumb-item::before, ' + selector + ' a:active { color:' + contentstyles.color + ';} ';
						sheet.insertRule(
							style,
							sheet.cssRules.length
						);
						sheet.insertRule(
							selector + ' * {color:inherit}',
							sheet.cssRules.length
						);
						sheet.insertRule(
							selector + ' hr { border-color:' + contentstyles.color + ';}',
							sheet.cssRules.length
						);
					}
				} catch (e){
					console.log("error adding color: " + contentstyles.color);
					console.log(e);
				}

				if(typeof styleSupport['content_lg_styles'] == 'string'){
					styleSupport['content_lg_styles']={};
				}
				styleSupport['content_lg_styles']=styleSupport['content_lg_styles'] || {}; 
				var selector='@media (max-width: 992px) and (max-width: 1199px) { div.mura-object[data-instanceid="' + obj.data('instanceid') + '"] > div.mura-object-content';
				var selector2='@media (max-width: 1292px) and (max-width: 1499px) { .mura-editing div.mura-object[data-instanceid="' + obj.data('instanceid') + '"] > div.mura-object-content';
				var dyncss='';

				handleBackround(styleSupport['content_md_styles']);

				contentAccumulator=Mura.extend(contentAccumulator,styleSupport['content_lg_styles']);
				for(var s in contentAccumulator){
					if(contentAccumulator.hasOwnProperty(s)){
						if(typeof styleMap[s] != 'undefined'){
							dyncss += styleMap[s]  + ': ' + contentAccumulator[s] + '!important;';
						}		
					}
				}
				if(dyncss){
					try {
						sheet.insertRule(
							selector + ' {' + dyncss+ '}',
							sheet.cssRules.length
						);
						sheet.insertRule(
							selector2 + ' {' + dyncss+ '}',
							sheet.cssRules.length
						);
					} catch (e){
						console.log(selector + ' {' + dyncss+ '}}')
						console.log(e);
					}
				}

				if(typeof styleSupport['content_md_styles'] == 'string'){
					styleSupport['content_md_styles']={};
				}
				styleSupport['content_md_styles']=styleSupport['content_md_styles'] || {}; 
				var selector='@media (min-width: 768px) and (max-width: 991px) { div.mura-object[data-instanceid="' + obj.data('instanceid') + '"] > div.mura-object-content';
				var selector2='@media (min-width: 1068px) and (max-width: 1291px) { .mura-editing div.mura-object[data-instanceid="' + obj.data('instanceid') + '"] > div.mura-object-content';
				var dyncss='';

				handleBackround(styleSupport['content_md_styles']);

				contentAccumulator=Mura.extend(contentAccumulator,styleSupport['content_md_styles']);
				for(var s in contentAccumulator){
					if(contentAccumulator.hasOwnProperty(s)){
						if(typeof styleMap[s] != 'undefined'){
							dyncss += styleMap[s]  + ': ' + contentAccumulator[s] + '!important;';
						}		
					}
				}
				if(dyncss){
					try {
						sheet.insertRule(
							selector + ' {' + dyncss+ '}',
							sheet.cssRules.length
						);
						sheet.insertRule(
							selector2 + ' {' + dyncss+ '}',
							sheet.cssRules.length
						);
					} catch (e){
						console.log(selector + ' {' + dyncss+ '}}')
						console.log(e);
						
					}
				}

				if(typeof styleSupport['content_sm_styles'] == 'string'){
					styleSupport['content_sm_styles']={};
				}
				styleSupport['content_sm_styles']=styleSupport['content_sm_styles'] || {}; 
				var selector='@media (min-width: 576px) and (max-width: 767px) { div.mura-object[data-instanceid="' + obj.data('instanceid') + '"] > div.mura-object-content';
				var selector2='@media (min-width: 876px) and (max-width: 1067px) { .mura-editing div.mura-object[data-instanceid="' + obj.data('instanceid') + '"] > div.mura-object-content';
				var dyncss='';

				handleBackround(styleSupport['content_sm_styles']);

				contentAccumulator=Mura.extend(contentAccumulator,styleSupport['content_sm_styles']);
				for(var s in contentAccumulator){
					if(contentAccumulator.hasOwnProperty(s)){
						if(typeof styleMap[s] != 'undefined'){
							dyncss += styleMap[s]  + ': ' + contentAccumulator[s] + '!important;';
						}		
					}
				}
				if(dyncss){
					try {
						sheet.insertRule(
							selector + ' {' + dyncss+ '}',
							sheet.cssRules.length
						);
						sheet.insertRule(
							selector2 + ' {' + dyncss+ '}',
							sheet.cssRules.length
						);
					} catch (e){
						console.log(selector + ' {' + dyncss+ '}}')
						console.log(e);
					}
				}

				if(typeof styleSupport['content_xs_styles'] == 'string'){
					styleSupport['content_xs_styles']={};
				}
				styleSupport['content_xs_styles']=styleSupport['content_xs_styles'] || {}; 
				var selector='@media (max-width: 575px) { div.mura-object[data-instanceid="' + obj.data('instanceid') + '"] > div.mura-object-content';
				var selector2='@media (max-width: 875px) { .mura-editing div.mura-object[data-instanceid="' + obj.data('instanceid') + '"] > div.mura-object-content';
				var dyncss='';

				handleBackround(styleSupport['content_xs_styles']);

				contentAccumulator=Mura.extend(contentAccumulator,styleSupport['content_xs_styles']);
				for(var s in contentAccumulator){
					if(contentAccumulator.hasOwnProperty(s)){
						if(typeof styleMap[s] != 'undefined'){
							dyncss += styleMap[s]  + ': ' + contentAccumulator[s] + '!important;';
						}		
					}
				}
				if(dyncss){
					try {
						sheet.insertRule(
							selector + ' {' + dyncss+ '}',
							sheet.cssRules.length
						);
						sheet.insertRule(
							selector2 + ' {' + dyncss+ '}',
							sheet.cssRules.length
						);
					} catch (e){
						console.log(selector + ' {' + dyncss+ '}}')
						console.log(e);
					}
				}
			}

			if(obj.data('contentcssid')){
				content.attr('id',obj.data('contentcssid'));
			}
			if(obj.data('contentcssclass')){
				obj.data('contentcssclass').split(' ').forEach(function(c){
					if (!content.hasClass(c)) {
						content.addClass(c);
					}
				})
			}
				
			if(content.hasClass('container')){
				metaWrapper.addClass('container');
			} else {
				metaWrapper.removeClass('container');
			}

			if(contentstyles){
				content.removeAttr('style');
				//content.css(contentstyles);
			}

			if(obj.is('.mura-object-label-left, .mura-object-label-right')){
				var left=content.css('marginLeft');
				var right=content.css('marginRight')
				if(!(left=='0px' && right=='0px') && left.charAt(0) != "-" && right.charAt(0) != "-"){
					if(fullsize){
						content.css('width','calc(50% - (' + left + ' + ' + right + '))');
					}
					Mura.windowResponsiveModules[obj.data('instanceid')]=true;
				}
			}

			var left=obj.css('marginLeft');
			var right=obj.css('marginRight')
			
			if(!obj.is('.mura-center') && !(left=='0px' && right=='0px') && !(left=='auto' || right=='auto') && left.charAt(0) != "-" && right.charAt(0) != "-"){
				if(fullsize){
					var width='100%';

					if(obj.is('.mura-one')){
						width='8.33%';
					} else if(obj.is('.mura-two')){
						width='16.66%';
					} else if(obj.is('.mura-three')){
						width='25%';
					} else if(obj.is('.mura-four')){
						width='33.33%';
					} else if(obj.is('.mura-five')){
						width='41.66%';
					} else if(obj.is('.mura-six')){
						width='50%';
					} else if(obj.is('.mura-seven')){
						width='58.33';
					} else if(obj.is('.mura-eigth')){
						width='66.66%';
					} else if(obj.is('.mura-nine')){
						width='75%';
					} else if(obj.is('.mura-ten')){
						width='83.33%';
					} else if(obj.is('.mura-eleven')){
						width='91.66%';
					} else if(obj.is('.mura-twelve')){
						width='100%';
					} else if(obj.is('.mura-one-third')){
						width='33.33%';
					} else if(obj.is('.mura-two-thirds')){
						width='66.66%';
					} else if(obj.is('.mura-one-half')){
						width='50%';
					} else {
						width='100%';
					}
					obj.css('width','calc(' + width + ' - (' + left + ' + ' + right + '))');
				}
				Mura.windowResponsiveModules[obj.data('instanceid')]=true;
			}

			if(obj.css('paddingTop').replace(/[^0-9]/g,'') != '0' || obj.css('paddingLeft').replace(/[^0-9]/g,'') != '0'){
				obj.addClass('mura-object-pin-tools');
			} else {
				obj.removeClass('mura-object-pin-tools');
			}

 		});

 		return this;
 	},

	/**
	 * text - Gets or sets the text content of each element in the selection
	 *
	 * @param	{string} textString Text string
	 * @return {object}						Self
	 */
	text: function(textString) {
		if (typeof textString != 'undefined') {
			this.each(function(el) {
				el.textContent = textString;
			});
			return this;
		} else {
			return this.selection[0].textContent;
		}
	},

	/**
	 * is - Returns if the first element in the select matches the selector
	 *
	 * @param	{string} selector description
	 * @return {boolean}
	 */
	is: function(selector) {
		if (!this.selection.length) {
			return false;
		}
		try {
			if (typeof this.selection[0] !== "undefined") {
			 	return this.selection[0].matchesSelector && this.selection[0].matchesSelector(selector);
			} else {
				return false;
			}
		} catch(e){
			return false;
		}
	},

	/**
	 * hasAttr - Returns is the first element in the selection has an attribute
	 *
	 * @param	{string} attributeName description
	 * @return {boolean}
	 */
	hasAttr: function(attributeName) {
		if (!this.selection.length) {
			return false;
		}
		return typeof this.selection[0].hasAttribute ==
			'function' && this.selection[0].hasAttribute(
					attributeName);
	},

	/**
	 * hasData - Returns if the first element in the selection has data attribute
	 *
	 * @param	{sting} attributeName Data atttribute name
	 * @return {boolean}
	 */
	hasData: function(attributeName) {
		if (!this.selection.length) {
			return false;
		}
		return this.hasAttr('data-' + attributeName);
	},


	/**
	 * offsetParent - Returns first element in selection's offsetParent
	 *
	 * @return {object}	offsetParent
	 */
	offsetParent: function() {
		if (!this.selection.length) {
			return this;
		}
		var el = this.selection[0];
		return el.offsetParent || el;
	},

	/**
	 * outerHeight - Returns first element in selection's outerHeight
	 *
	 * @param	{boolean} withMargin Whether to include margin
	 * @return {number}
	 */
	outerHeight: function(withMargin) {
		if (!this.selection.length) {
			return this;
		}
		if (typeof withMargin == 'undefined') {
			function outerHeight(el) {
				var height = el.offsetHeight;
				var style = getComputedStyle(el);
				height += parseInt(style.marginTop) + parseInt(style.marginBottom);
				return height;
			}
			return outerHeight(this.selection[0]);
		} else {
			return this.selection[0].offsetHeight;
		}
	},

	/**
	 * height - Returns height of first element in selection or set height for elements in selection
	 *
	 * @param	{number} height	Height (option)
	 * @return {object}				Self
	 */
	height: function(height) {
		if (!this.selection.length) {
			return this;
		}
		if (typeof width != 'undefined') {
			if (!isNaN(height)) {
					height += 'px';
			}
			this.css('height', height);
			return this;
		}
		var el = this.selection[0];
		//var type=el.constructor.name.toLowerCase();
		if (typeof window !='undefined' && typeof window.document != 'undefined' && el === window) {
			return innerHeight
		} else if (el === document) {
			var body = document.body;
			var html = document.documentElement;
			return Math.max(body.scrollHeight, body.offsetHeight,
				html.clientHeight, html.scrollHeight,
				html.offsetHeight)
		}
		var styles = getComputedStyle(el);
		var margin = parseFloat(styles['marginTop']) + parseFloat(styles['marginBottom']);
		return Math.ceil(el.offsetHeight + margin);
	},

	/**
	 * width - Returns width of first element in selection or set width for elements in selection
	 *
	 * @param	{number} width Width (optional)
	 * @return {object}			 Self
	 */
	width: function(width) {
		if (!this.selection.length) {
			return this;
		}
		if (typeof width != 'undefined') {
			if (!isNaN(width)) {
				width += 'px';
			}
			this.css('width', width);
			return this;
		}
		var el = this.selection[0];
		//var type=el.constructor.name.toLowerCase();
		if (typeof window !='undefined' && typeof window.document != 'undefined' && el === window) {
			return innerWidth
		} else if (el === document) {
			var body = document.body;
			var html = document.documentElement;
		return Math.max(body.scrollWidth, body.offsetWidth,
				html.clientWidth, html.scrolWidth,
				html.offsetWidth)
		}
		return getComputedStyle(el).width;
	},

	/**
	 * width - Returns outerWidth of first element in selection
	 *
	 * @return {number}
	 */
	outerWidth: function() {
		if (!this.selection.length) {
			return 0;
		}
		var el = this.selection[0];
		var width = el.offsetWidth;
		var style = getComputedStyle(el);

		width += parseInt(style.marginLeft) + parseInt(style.marginRight);
		return width;
	},

	/**
	 * scrollTop - Returns the scrollTop of the current document
	 *
	 * @return {object}
	 */
	scrollTop: function() {
		if (!this.selection.length) {
			return 0;
		}
		var el = this.selection[0];
		if(typeof el.scrollTop != 'undefined'){
			return el.scrollTop;
		} else {
			return	window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
		}
	},

	/**
	 * offset - Returns offset of first element in selection
	 *
	 * @return {object}
	 */
	offset: function() {
		if (!this.selection.length) {
			return this;
		}
		var box = this.selection[0].getBoundingClientRect();
		return {
			top: box.top + (pageYOffset || document.scrollTop) -
					(document.clientTop || 0),
			left: box.left + (pageXOffset || document.scrollLeft) -
					(document.clientLeft || 0)
		};
	},

	/**
	 * removeAttr - Removes attribute from elements in selection
	 *
	 * @param	{string} attributeName Attribute name
	 * @return {object}							 Self
	 */
	removeAttr: function(attributeName) {
		if (!this.selection.length) {
				return this;
		}
		this.each(function(el) {
			if (el && typeof el.removeAttribute == 'function') {
				el.removeAttribute(attributeName);
			}
		});
		return this;
	},

	/**
	 * changeElementType - Changes element type of elements in selection
	 *
	 * @param	{string} type Element type to change to
	 * @return {Mura.DOMSelection} Self
	 */
	changeElementType: function(type) {
		if (!this.selection.length) {
			return this;
		}
		this.each(function(el) {
			Mura.changeElementType(el, type)
		});
		return this;
	},

	/**
	 * val - Set the value of elements in selection
	 *
	 * @param	{*} value Value
	 * @return {Mura.DOMSelection} Self
	 */
	val: function(value) {
		if (!this.selection.length) {
			return this;
		}
		if (typeof value != 'undefined') {
			this.each(function(el) {
				if (el.tagName == 'radio') {
					if (el.value == value) {
						el.checked = true;
					} else {
						el.checked = false;
					}
				} else {
					el.value = value;
				}
			});
			return this;
		} else {
			if (Object.prototype.hasOwnProperty.call(this.selection[0], 'value') ||
				typeof this.selection[0].value != 'undefined') {
				return this.selection[0].value;
			} else {
				return '';
			}
		}
	},

	/**
	 * attr - Returns attribute value of first element in selection or set attribute value for elements in selection
	 *
	 * @param	{string} attributeName Attribute name
	 * @param	{*} value				 Value (optional)
	 * @return {Mura.DOMSelection} Self
	 */
	attr: function(attributeName, value) {
		if (!this.selection.length) {
			return this;
		}
		if (typeof value == 'undefined' && typeof attributeName =='undefined') {
			return Mura.getAttributes(this.selection[0]);
		} else if (typeof attributeName == 'object') {
			this.each(function(el) {
				if (el.setAttribute) {
					for (var p in attributeName) {
						el.setAttribute(p,attributeName[p]);
					}
				}
			});
			return this;
		} else if (typeof value != 'undefined') {
			this.each(function(el) {
				if (el.setAttribute) {
					el.setAttribute(attributeName,value);
				}
			});
			return this;
		} else {
			if (this.selection[0] && this.selection[0].getAttribute) {
				return this.selection[0].getAttribute(attributeName);
			} else {
				return undefined;
			}

		}
	},

	/**
	 * data - Returns data attribute value of first element in selection or set data attribute value for elements in selection
	 *
	 * @param	{string} attributeName Attribute name
	 * @param	{*} value				 Value (optional)
	 * @return {Mura.DOMSelection} Self
	 */
	data: function(attributeName, value) {
		if (!this.selection.length) {
			return this;
		}
		if (typeof value == 'undefined' && typeof attributeName == 'undefined') {
			return Mura.getData(this.selection[0]);
		} else if (typeof attributeName == 'object') {
			this.each(function(el) {
				for (var p in attributeName) {
					el.setAttribute("data-" + p,attributeName[p]);
				}
			});
			return this;
		} else if (typeof value != 'undefined') {
			this.each(function(el) {
				el.setAttribute("data-" + attributeName, value);
			});
			return this;
		} else if (this.selection[0] && this.selection[	0].getAttribute) {
			return Mura.parseString(this.selection[0].getAttribute("data-" + attributeName));
		} else {
			return undefined;
		}
	},

	/**
	 * prop - Returns attribute value of first element in selection or set attribute value for elements in selection
	 *
	 * @param	{string} attributeName Attribute name
	 * @param	{*} value				 Value (optional)
	 * @return {Mura.DOMSelection} Self
	 */
	prop: function(attributeName, value) {
			if (!this.selection.length) {
				return this;
			}
			if (typeof value == 'undefined' && typeof attributeName == 'undefined') {
				return Mura.getProps(this.selection[0]);
			} else if (typeof attributeName == 'object') {
				this.each(function(el) {
					for (var p in attributeName) {
						el.setAttribute(p,attributeName[p]);
					}
				});
				return this;
			} else if (typeof value != 'undefined') {
				this.each(function(el) {
					el.setAttribute(attributeName,value);
				});
				return this;
			} else {
				return Mura.parseString(this.selection[0].getAttribute(attributeName));
			}
	},

	/**
	 * fadeOut - Fades out elements in selection
	 *
	 * @return {Mura.DOMSelection} Self
	 */
	fadeOut: function() {
		this.each(function(el) {
			el.style.opacity = 1;
			(function fade() {
				if ((el.style.opacity -= .1) < 	0) {
					el.style.opacity=0;
					el.style.display = "none";
				} else {
					requestAnimationFrame(fade);
				}
			})();
		});
		return this;
	},

	/**
	 * fadeIn - Fade in elements in selection
	 *
	 * @param	{string} display Display value
	 * @return {Mura.DOMSelection} Self
	 */
	fadeIn: function(display) {
			this.each(function(el) {
				el.style.opacity = 0;
				el.style.display = display ||	"block";
				(function fade() {
					var val = parseFloat(el.style.opacity);
					if (!((val += .1) > 1)) {
						el.style.opacity = val;
						requestAnimationFrame(fade);
					}
				})();
			});
			return this;
	},

	/**
	 * toggle - Toggles display object elements in selection
	 *
	 * @return {Mura.DOMSelection} Self
	 */
	toggle: function() {
		this.each(function(el) {
			if (typeof el.style.display ==
				'undefined' || el.style.display ==
				'') {
				el.style.display = 'none';
			} else {
				el.style.display = '';
			}
		});
		return this;
	},
	/**
	 * slideToggle - Place holder
	 *
	 * @return {Mura.DOMSelection} Self
	 */
	slideToggle: function() {
		this.each(function(el) {
			if (typeof el.style.display ==
				'undefined' || el.style.display ==
				'') {
				el.style.display = 'none';
			} else {
				el.style.display = '';
			}
		});
		return this;
	},

	/**
	 * focus - sets focus of the first select element
	 *
	 * @return {self}
	 */
	focus: function() {
		if (!this.selection.length) {
			return this;
		}
		this.selection[0].focus();
		return this;
	},

	/**
	 * renderEditableAttr- Returns a string with editable attriute markup markup.
	 *
	 * @param	{object} params Keys: name, type, required, validation, message, label
	 * @return {self}
	 */
	makeEditableAttr:function(params){
		if (!this.selection.length) {
			return this;
		}
		var value=this.selection[0].innerHTML;
		params=params || {};
		if(!params.name){
			return this;
		}
		params.type=params.type || "text";
		if(typeof params.required == 'undefined'){
			params.required=false;
		}
		if(typeof params.validation == 'undefined'){
			params.validation='';
		}
		if(typeof params.message == 'undefined'){
			params.message='';
		}
		if(typeof params.label == 'undefined'){
			params.label=params.name;
		}
		var outerClass="mura-editable mura-inactive";
		var innerClass="mura-inactive mura-editable-attribute";
		if(params.type=="htmlEditor"){
			outerClass += " mura-region mura-region-loose";
			innerClass += " mura-region-local";
		} else {
			outerClass += " inline";
			innerClass += " inline";
		}
		var innerClass="mura-inactive mura-editable-attribute";
		/*
		<div class="mura-editable mura-inactive inline">
		<label class="mura-editable-label" style="">TITLE</label>
		<div contenteditable="false" id="mura-editable-attribute-title" class="mura-inactive mura-editable-attribute inline" data-attribute="title" data-type="text" data-required="false" data-message="" data-label="title">About</div>
		</div>

		<div class="mura-region mura-region-loose mura-editable mura-inactive">
		<label class="mura-editable-label" style="">BODY</label>
		<div contenteditable="false" id="mura-editable-attribute-body" class="mura-region-local mura-inactive mura-editable-attribute" data-attribute="body" data-type="htmlEditor" data-required="false" data-message="" data-label="body" data-loose="true" data-perm="true" data-inited="false"></div>
		</div>
		*/
		var markup='<div class="' + outerClass + '">';
		markup +='<div contenteditable="false" id="mura-editable-attribute-' + params.name +' class="' + innerClass + '" ';
		markup += ' data-attribute="' + params.name + '" ';
		markup += ' data-type="' + params.type + '" ';
		markup += ' data-required="' + params.required + '" ';
		markup += ' data-message="' + params.message + '" ';
		markup += ' data-label="' + params.label + '"';
		if(params.type == 'htmlEditor'){
			markup += ' data-loose="true" data-perm="true" data-inited="false"';
		}
		markup += '>' + value + '</div>';
		markup += '<label class="mura-editable-label" style="display:none">' + params.label.toUpperCase() + '</label>';
		markup +=	'</div>';
		this.selection[0].innerHTML=markup;
		Mura.evalScripts(this.selection[0]);
		return this;
	},

	/**
	* processDisplayRegion - Renders and processes the display region data returned from Mura.renderFilename()
	*
	* @param	{any} data Region data to render
	* @return {Promise}
	*/
	processDisplayRegion:function(data,label){
		if (typeof data == 'undefined' || !this.selection.length) {
				return this.processMarkup();
		}
		this.html(Mura.buildDisplayRegion(data));
		if(label != 'undefined'){
			this.find('label.mura-editable-label').html('DISPLAY REGION : ' + data.label);
		}
		return this.processMarkup();
	},

	/**
	 * appendDisplayObject - Appends display object to selected items
	 *
	 * @param	{object} data Display objectparams (including object='objectkey')
	 * @return {Promise}
	 */
	dspObject:function(data){
		return this.appendDisplayObject(data);
	}
});
})(Mura);


/***/ }),
/* 355 */
/***/ (function(module, exports, __webpack_require__) {


var Mura =__webpack_require__(9);

/**
 * Creates a new Mura.UI instance
 * @name Mura.UI
 * @class
 * @extends  Mura.Core
 * @memberof Mura
 */

Mura.UI=Mura.Core.extend(
  /** @lends Mura.UI.prototype */
  {
	rb:{},
	context:{},
	onAfterRender:function(){},
	onBeforeRender:function(){},
	trigger:function(eventName){
		var $eventName=eventName.toLowerCase();
		if(typeof this.context.targetEl != 'undefined'){
			var obj=Mura(this.context.targetEl).closest('.mura-object');
			if(obj.length && typeof obj.node != 'undefined'){
				if(typeof this.handlers[$eventName] != 'undefined'){
					var $handlers=this.handlers[$eventName];
					for(var i=0;i < $handlers.length;i++){
						if(typeof $handlers[i].call == 'undefined'){
							$handlers[i](this);
						} else {
							$handlers[i].call(this,this);
						}
					}
				}
				if(typeof this[eventName] == 'function'){
					if(typeof this[eventName].call == 'undefined'){
						this[eventName](this);
					} else {
						this[eventName].call(this,this);
					}
				}
				var fnName='on' + eventName.substring(0,1).toUpperCase() + eventName.substring(1,eventName.length);
				if(typeof this[fnName] == 'function'){
					if(typeof this[fnName].call == 'undefined'){
						this[fnName](this);
					} else {
						this[fnName].call(this,this);
					}
				}
			}
		}
		return this;
	},

	/* This method is deprecated, use renderClient and renderServer instead */
	render:function(){
		Mura(this.context.targetEl).html(Mura.templates[context.object](this.context));
		this.trigger('afterRender');
		return this;
	},

	/*
		This method's current implementation is to support backward compatibility

		Typically it would look like:

		Mura(this.context.targetEl).html(Mura.templates[context.object](this.context));
		this.trigger('afterRender');
	*/
	renderClient:function(){
		return this.render();
	},


	renderServer:function(){
		return '';
	},

	hydrate:function(){

	},

	destroy:function(){
		
	},

	init:function(args){
		this.context=args;
		this.registerHelpers();
		return this;
	},

	registerHelpers:function(){

	}
});


/***/ }),
/* 356 */
/***/ (function(module, exports, __webpack_require__) {


var Mura=__webpack_require__(9);
/**
 * Creates a new Mura.UI.Form
 * @name	Mura.UI.Form
 * @class
 * @extends Mura.UI
 * @memberof	Mura
 */

Mura.UI.Form=Mura.UI.extend(
/** @lends Mura.DisplayObject.Form.prototype */
{
	context:{},
	ormform: false,
	formJSON:{},
	data:{},
	columns:[],
	currentpage: 0,
	entity: {},
	fields:{},
	filters: {},
	datasets: [],
	sortfield: '',
	sortdir: '',
	inlineerrors: true,
	properties: {},
	rendered: {},
	renderqueue: 0,
	//templateList: ['file','error','textblock','checkbox','checkbox_static','dropdown','dropdown_static','radio','radio_static','nested','textarea','textfield','form','paging','list','table','view','hidden','section'],
	formInit: false,
	responsemessage: "",
	rb: {
		generalwrapperclass:"well",
		generalwrapperbodyclass:"",
		formwrapperclass: "well",
		formwrapperbodyclass: "",
		formfieldwrapperclass: "control-group",
		formfieldlabelclass:"control-label",
		formerrorwrapperclass: "",
		formresponsewrapperclass: "",
		formgeneralcontrolclass:"form-control",
		forminputclass:"form-control",
		formselectclass:"form-control",
		formtextareaclass:"form-control",
		formfileclass:"form-control",
		formtextblockclass:"form-control",
		formcheckboxclass:"",
		formcheckboxlabelclass:"checkbox",
		formcheckboxwrapperclass:"",
		formradioclass:"",
		formradiowrapperclass:"",
		formradiolabelclass:"radio",
		formbuttonwrapperclass:"btn-group",
		formbuttoninnerclass:"",
		formbuttonclass:"btn btn-default",
		formrequiredwrapperclass:"",
		formbuttonsubmitclass :"form-submit",
		formbuttonsubmitlabel : "Submit",
		formbuttonsubmitwaitlabel : "Please Wait...",
		formbuttonnextclass:"form-nav",
		formbuttonnextlabel : "Next",
		formbuttonbackclass:"form-nav",
		formbuttonbacklabel : "Back",
		formbuttoncancelclass:"btn-primary pull-right",
		formbuttoncancellabel :"Cancel",
		formrequiredlabel:"Required"
	},
	renderClient:function(){

		if(this.context.mode == undefined){
			this.context.mode = 'form';
		}

		var ident = "mura-form-" + this.context.instanceid;

		this.context.formEl = "#" + ident;

		this.context.html = "<div id='"+ident+"'></div>";

		Mura(this.context.targetEl).html( this.context.html );

		if (this.context.view == 'form') {
			this.getForm();
		}
		else {
			this.getList();
		}

		return this;
	},

	getTemplates:function() {

		var self = this;

		if (self.context.view == 'form') {
			self.loadForm();
		} else {
			self.loadList();
		}

		/*
		if(Mura.templatesLoaded.length){
			var temp = Mura.templateList.pop();

			Mura.ajax(
				{
					url:Mura.assetpath + '/includes/display_objects/form/templates/' + temp + '.hb',
					type:'get',
					xhrFields:{ withCredentials: false },
					success:function(data) {
						Mura.templates[temp] = Mura.Handlebars.compile(data);
						if(!Mura.templateList.length) {
							if (self.context.view == 'form') {
								self.loadForm();
							} else {
								self.loadList();
							}
						} else {
							self.getTemplates();
						}
					}
				}
			);

		}
		*/
	},

	getPageFieldList:function(){

		var page=this.currentpage;
		var fields = this.formJSON.form.pages[page];
		var result=[];

		for(var f=0;f < fields.length;f++){
			//console.log("add: " + self.formJSON.form.fields[fields[f]].name);
			result.push(this.formJSON.form.fields[fields[f]].name);
		}

		//console.log(result);

		return result.join(',');
	},

	renderField:function(fieldtype,field) {
		var self = this;
		var templates = Mura.templates;
		var template = fieldtype;

		if( field.datasetid != "" && self.isormform)
			field.options = self.formJSON.datasets[field.datasetid].options;
		else if(field.datasetid != "") {
			field.dataset = self.formJSON.datasets[field.datasetid];
		}

		self.setDefault( fieldtype,field );

		if (fieldtype == "nested") {
			var nested_context = {};
			nested_context.objectid = field.formid;
			nested_context.paging = 'single';
			nested_context.mode = 'nested';
			nested_context.prefix = field.name + '_';
			nested_context.master = this;

			var data={};
			data.objectid=nested_context.objectid;
			data.formid=nested_context.objectid;
			data.object='form';
			data.siteid=self.context.siteid || Mura.siteid;
			data.contentid=Mura.contentid;
			data.contenthistid=Mura.contenthistid;

			Mura.get(
				 Mura.apiEndpoint + '?method=processAsyncObject',
				 data)
				 .then(function(resp){
					var tempContext=Mura.extend({},nested_context);

					delete tempContext.targetEl;

					var context=Mura.deepExtend({},tempContext,resp.data)

					context.targetEl=self.context.targetEl;

					var nestedForm = new Mura.UI.Form( context );

					Mura(".field-container-" + self.context.objectid,self.context.formEl).append('<div id="nested-'+field.formid+'"></div>');

					context.formEl = document.getElementById('nested-'+field.formid);

					nestedForm.getForm();

					var html = Mura.templates[template](field);

					Mura(".field-container-" + self.context.objectid,self.context.formEl).append(html);

				 });

		}
		else {
			if(fieldtype == "checkbox") {
				if(self.ormform) {
					field.selected = [];

					var ds = self.formJSON.datasets[field.datasetid];

					for (var i in ds.datarecords) {
						if(ds.datarecords[i].selected && ds.datarecords[i].selected == 1)
							field.selected.push(i);
					}

					field.selected = field.selected.join(",");
				}
				else {
					template = template + "_static";
				}
			}
			else if(fieldtype == "dropdown") {
				if(!self.ormform) {
					template = template + "_static";
				}
			}
			else if(fieldtype == "radio") {
				if(!self.ormform) {
					template = template + "_static";
				}
			}

			var html = Mura.templates[template](field);

			Mura(".field-container-" + self.context.objectid,self.context.formEl).append(html);
		}

	},

	setDefault:function(fieldtype,field) {
		var self = this;

		switch( fieldtype ) {
			case "textfield":
			case "textarea":
				if(self.data[self.context.prefix + field.name]){
					field.value = self.data[self.context.prefix + field.name];
				}
			 break;
			case "checkbox":
			var ds = self.formJSON.datasets[field.datasetid];
				for(var i=0;i<ds.datarecords.length;i++) {
					if (self.ormform) {
						var sourceid = ds.source + "id";
						ds.datarecords[i].selected = 0;
						ds.datarecords[i].isselected = 0;

						if(self.data[self.context.prefix + field.name].items && self.data[self.context.prefix + field.name].items.length) {
							for(var x = 0;x < self.data[self.context.prefix + field.name].items.length;x++) {
								if (ds.datarecords[i].id == self.data[self.context.prefix + field.name].items[x][sourceid]) {
									ds.datarecords[i].isselected = 1;
									ds.datarecords[i].selected = 1;
								}
							}
						}
					}
					else {
						if (self.data[self.context.prefix + field.name] && ds.datarecords[i].value && self.data[self.context.prefix + field.name].indexOf(ds.datarecords[i].value) > -1) {
							ds.datarecords[i].isselected = 1;
							ds.datarecords[i].selected = 1;
						}
						else {
							ds.datarecords[i].selected = 0;
							ds.datarecords[i].isselected = 0;
						}
					}
				}
			break;
			case "radio":
			case "dropdown":
				var ds = self.formJSON.datasets[field.datasetid];
				for(var i=0;i<ds.datarecords.length;i++) {
					if(self.ormform) {
						if(ds.datarecords[i].id == self.data[field.name+'id']) {
							ds.datarecords[i].isselected = 1;
							field.selected = self.data[field.name+'id'];
						}
						else {
							ds.datarecords[i].selected = 0;
							ds.datarecords[i].isselected = 0;
						}
					}
					else {
						 if(ds.datarecords[i].value == self.data[self.context.prefix + field.name]) {
							ds.datarecords[i].isselected = 1;
							field.selected = self.data[self.context.prefix + field.name];
						}
						else {
							ds.datarecords[i].isselected = 0;
						}
					}
				}
			break;
		}
	},

	renderData:function() {
		var self = this;

		if(self.datasets.length == 0){
			if (self.renderqueue == 0) {
				self.renderForm();
			}
			return;
		}

		var dataset = self.formJSON.datasets[self.datasets.pop()];

		if(dataset.sourcetype && dataset.sourcetype != 'muraorm'){
			self.renderData();
			return;
		}

		if(dataset.sourcetype=='muraorm'){
			dataset.options = [];
			self.renderqueue++;

			Mura.getFeed( dataset.source )
				.getQuery()
				.then( function(collection) {
					collection.each(function(item) {
						var itemid = item.get('id');
						dataset.datarecordorder.push( itemid );
						dataset.datarecords[itemid] = item.getAll();
						dataset.datarecords[itemid]['value'] = itemid;
						dataset.datarecords[itemid]['datarecordid'] = itemid;
						dataset.datarecords[itemid]['datasetid'] = dataset.datasetid;
						dataset.datarecords[itemid]['isselected'] = 0;
						dataset.options.push( dataset.datarecords[itemid] );
					});
				})
				.then(function() {
					self.renderqueue--;
					self.renderData();
					if (self.renderqueue == 0) {
						self.renderForm();
					}
				});
		} else {
			if (self.renderqueue == 0) {
				self.renderForm();
			}
		}
	},

	renderForm: function( ) {
		var self = this;

		//console.log("render form: " + self.currentpage);
		if(typeof self.context.prefix =='undefined'){
			self.context.prefix='';
		}

		Mura(".field-container-" + self.context.objectid,self.context.formEl).empty();

		if(!self.formInit) {
			self.initForm();
		}

		var fields = self.formJSON.form.pages[self.currentpage];

		for(var i = 0;i < fields.length;i++) {
			var field =	self.formJSON.form.fields[fields[i]];
			//try {
				if( field.fieldtype.fieldtype != undefined && field.fieldtype.fieldtype != "") {
					self.renderField(field.fieldtype.fieldtype,field);
				}
			//} catch(e){
				//console.log('Error rendering form field:');
				//console.log(field);
			//}
		}

		if(self.ishuman && self.currentpage==(self.formJSON.form.pages.length-1)){
			Mura(".field-container-" + self.context.objectid,self.context.formEl).append(self.ishuman);
		}

		if (self.context.mode == 'form') {
			self.renderPaging();
		}

		Mura.processMarkup(".field-container-" + self.context.objectid,self.context.formEl);

		self.trigger('afterRender');

	},

	renderPaging:function() {

		var self = this;
		var submitlabel=(typeof self.formJSON.form.formattributes != 'undefined' && typeof self.formJSON.form.formattributes.submitlabel != 'undefined' && self.formJSON.form.formattributes.submitlabel) ? self.formJSON.form.formattributes.submitlabel : self.rb.formbuttonsubmitlabel;

		Mura(".error-container-" + self.context.objectid,self.context.formEl).empty();
		Mura(".paging-container-" + self.context.objectid,self.context.formEl).empty();

		if(self.formJSON.form.pages.length == 1) {
			Mura(".paging-container-" + self.context.objectid,self.context.formEl).append(Mura.templates['paging']({page:self.currentpage+1,label:submitlabel,"class":Mura.trim("mura-form-submit " + self.rb.formbuttonsubmitclass)}));
		}
		else {
			if(self.currentpage == 0) {
				Mura(".paging-container-" + self.context.objectid,self.context.formEl).append(Mura.templates['paging']({page:1,label:self.rb.formbuttonnextlabel,"class":Mura.trim("mura-form-nav mura-form-next " + self.rb.formbuttonnextclass)}));
			} else {
				Mura(".paging-container-" + self.context.objectid,self.context.formEl).append(Mura.templates['paging']({page:self.currentpage-1,label:self.rb.formbuttonbacklabel,"class":Mura.trim("mura-form-nav mura-form-back " + self.rb.formbuttonbackclass)}));

				if(self.currentpage+1 < self.formJSON.form.pages.length) {
					Mura(".paging-container-" + self.context.objectid,self.context.formEl).append(Mura.templates['paging']({page:self.currentpage+1,label:self.rb.formbuttonnextlabel,"class":Mura.trim("mura-form-nav mura-form-next " + self.rb.formbuttonnextclass)}));
				}
				else {
					Mura(".paging-container-" + self.context.objectid,self.context.formEl).append(Mura.templates['paging']({page:self.currentpage+1,label:submitlabel,"class":Mura.trim("mura-form-submit " + self.rb.formbuttonsubmitclass)}));
				}
			}

			if(self.backlink != undefined && self.backlink.length)
				Mura(".paging-container-" + self.context.objectid,self.context.formEl).append(Mura.templates['paging']({page:self.currentpage+1,label:self.rb.formbuttoncancellabel,"class":Mura.trim("mura-form-nav mura-form-cancel " + self.rb.formbuttoncancelclass)}));
		}

		var submitHandler=function() {
			self.submitForm();
		};

		Mura(".mura-form-submit",self.context.formEl).off('click',submitHandler).on('click',submitHandler);

		Mura(".mura-form-cancel",self.context.formEl).click( function() {
			self.getTableData( self.backlink );
		});


		var formNavHandler=function(e) {

			if(Mura(e.target).is('.mura-form-submit')){
				return;
			}

			self.setDataValues();

			var keepGoing=self.onPageSubmit.call(self.context.targetEl);
			if(typeof keepGoing != 'undefined' && !keepGoing){
				return;
			}

			var button = this;

			if(self.ormform) {
				Mura.getEntity(self.entity)
				.set(
					self.data
				)
				.validate(self.getPageFieldList())
				.then(
					function( entity ) {
						if(entity.hasErrors()){
							self.showErrors( entity.properties.errors );
						} else {
							self.currentpage = Mura(button).data('page');
							self.renderForm();
						}
					}
				);
			} else {
				var data=Mura.extend({}, self.data, self.context);
				data.validateform=true;
				data.formid=data.objectid;
				data.siteid=data.siteid || Mura.siteid;
				data.fields=self.getPageFieldList();

				delete data.filename;
				delete data.def;
				delete data.ishuman;
				delete data.targetEl;
				delete data.html;


				Mura.ajax({
					type: 'post',
					url: Mura.apiEndpoint +
						'?method=generateCSRFTokens',
					data: {
						siteid: data.siteid,
						context: data.formid
					},
					success: function(resp) {
						data['csrf_token_expires']=resp.data['csrf_token_expires'];
						data['csrf_token']=resp.data['csrf_token'];

						Mura.post(
							Mura.apiEndpoint + '?method=processAsyncObject',
							data
						).then(function(resp){
							if(typeof resp.data.errors == 'object' && !Mura.isEmptyObject(resp.data.errors)){
								self.showErrors( resp.data.errors );
							} else if(typeof resp.data.redirect != 'undefined') {
								if(resp.data.redirect && resp.data.redirect != location.href){
									location.href=resp.data.redirect;
								} else {
									location.reload(true);
								}
							} else {
								self.currentpage = Mura(button).data('page');
								if(self.currentpage >= self.formJSON.form.pages.length){
									self.currentpage=self.formJSON.form.pages.length-1;
								}
								self.renderForm();
							}
						});
					}
				});
			}

			/*
			}
			else {
				console.log('oops!');
			}
			*/
		};

		Mura(".mura-form-nav",self.context.formEl).off('click',formNavHandler).on('click',formNavHandler);
	},

	setDataValues: function() {
		var self = this;
		var multi = {};
		var item = {};
		var valid = [];
		var currentPage = {};

		Mura(".field-container-" + self.context.objectid + " input, .field-container-" + self.context.objectid + " select, .field-container-" + self.context.objectid + " textarea").each( function() {

			currentPage[Mura(this).attr('name')]=true;

			if( Mura(this).is('[type="checkbox"]')) {
				if ( multi[Mura(this).attr('name')] == undefined )
					multi[Mura(this).attr('name')] = [];

				if( this.checked ) {
					if (self.ormform) {
						item = {};
						item['id'] = Mura.createUUID();
						item[self.entity + 'id'] = self.data.id;
						item[Mura(this).attr('source') + 'id'] = Mura(this).val();
						item['key'] = Mura(this).val();

						multi[Mura(this).attr('name')].push(item);
					}
					else {
						multi[Mura(this).attr('name')].push(Mura(this).val());
					}
				}
			}
			else if( Mura(this).is('[type="radio"]')) {
				if( this.checked ) {
					self.data[ Mura(this).attr('name') ] = Mura(this).val();
					valid[ Mura(this).attr('name') ] = self.data[name];
				}
			}
			else {
				self.data[ Mura(this).attr('name') ] = Mura(this).val();
				valid[ Mura(this).attr('name') ] = self.data[Mura(this).attr('name')];
			}
		});

		for(var i in multi) {
			if(self.ormform) {
				self.data[ i ].cascade = "replace";
				self.data[ i ].items = multi[ i ];
				valid[ i ] = self.data[i];
			}
			else {
				self.data[ i ] = multi[i].join(",");
				valid[ i ] = multi[i].join(",");
			}
		}

		if(Mura.formdata){
			var frm=document.getElementById('frm' + self.context.objectid);
			for(var p in currentPage){
				if(currentPage.hasOwnProperty(p) && typeof self.data[p] != 'undefined'){
					if(p.indexOf("_attachment") > -1 && typeof frm[p] != 'undefined'){
						self.attachments[p]=frm[p].files[0];
					}
				}
			}
		}

		return valid;

	},

	validate: function( entity,fields ) {
		return true;
	},

	getForm: function( entityid,backlink ) {
		var self = this;
		var formJSON = {};
		var entityName = '';

		if(entityid != undefined){
			self.entityid = entityid;
		} else {
			delete self.entityid;
		}

		if(backlink != undefined){
			self.backlink = backlink;
		} else {
			delete self.backlink;
		}

		/*
		if(Mura.templateList.length) {
			self.getTemplates( entityid );
		}
		else {
		*/
			self.loadForm();
		//}
	},

	loadForm: function( data ) {
		var self = this;

		//console.log('a');
		//console.log(self.formJSOrenderN);

		formJSON = JSON.parse(self.context.def);

		// old forms
		if(!formJSON.form.pages) {
			formJSON.form.pages = [];
			formJSON.form.pages[0] = formJSON.form.fieldorder;
			formJSON.form.fieldorder = [];
		}


		if(typeof formJSON.datasets != 'undefined'){
			for(var d in formJSON.datasets){
				if(typeof formJSON.datasets[d].DATARECORDS != 'undefined'){
					formJSON.datasets[d].datarecords=formJSON.datasets[d].DATARECORDS;
					delete formJSON.datasets[d].DATARECORDS;
				}
				if(typeof formJSON.datasets[d].DATARECORDORDER != 'undefined'){
					formJSON.datasets[d].datarecordorder=formJSON.datasets[d].DATARECORDORDER;
					delete formJSON.datasets[d].DATARECORDORDER;
				}
			}
		}

		entityName = self.context.filename.replace(/\W+/g, "");
		self.entity = entityName;
		self.formJSON = formJSON;
		self.fields = formJSON.form.fields;
		self.responsemessage = self.context.responsemessage;
		self.ishuman=self.context.ishuman;

		if (formJSON.form.formattributes && formJSON.form.formattributes.Muraormentities == 1) {
			self.ormform = true;
		}

		for(var i=0;i < self.formJSON.datasets;i++){
			self.datasets.push(i);
		}

		if(self.ormform) {
			self.entity = entityName;

			if(self.entityid == undefined) {
				Mura.get(
					Mura.apiEndpoint +'/'+ entityName + '/new?expand=all&ishuman=true'
				).then(function(resp) {
					self.data = resp.data;
					self.renderData();
				});
			}
			else {
				Mura.get(
					Mura.apiEndpoint	+ '/'+ entityName + '/' + self.entityid + '?expand=all&ishuman=true'
				).then(function(resp) {
					self.data = resp.data;
					self.renderData();
				});
			}
		}
		else {
			self.renderData();
		}
		/*
		Mura.get(
				Mura.apiEndpoint + '/content/' + self.context.objectid
				 + '?fields=body,title,filename,responsemessage&ishuman=true'
				).then(function(data) {
				 	formJSON = JSON.parse( data.data.body );

					// old forms
					if(!formJSON.form.pages) {
						formJSON.form.pages = [];
						formJSON.form.pages[0] = formJSON.form.fieldorder;
						formJSON.form.fieldorder = [];
					}

					entityName = data.data.filename.replace(/\W+/g, "");
					self.entity = entityName;
				 	self.formJSON = formJSON;
				 	self.fields = formJSON.form.fields;
				 	self.responsemessage = data.data.responsemessage;
					self.ishuman=data.data.ishuman;

					if (formJSON.form.formattributes && formJSON.form.formattributes.Muraormentities == 1) {
						self.ormform = true;
					}

					for(var i=0;i < self.formJSON.datasets;i++){
						self.datasets.push(i);
					}

					if(self.ormform) {
					 	self.entity = entityName;

					 	if(self.entityid == undefined) {
							Mura.get(
								Mura.apiEndpoint +'/'+ entityName + '/new?expand=all&ishuman=true'
							).then(function(resp) {
								self.data = resp.data;
								self.renderData();
							});
					 	}
					 	else {
							Mura.get(
								Mura.apiEndpoint	+ '/'+ entityName + '/' + self.entityid + '?expand=all&ishuman=true'
							).then(function(resp) {
								self.data = resp.data;
								self.renderData();
							});
						}
					}
					else {
						self.renderData();
					}
				 }
			);

		*/
	},

	initForm: function() {
		var self = this;
		Mura(self.context.formEl).empty();

		if(self.context.mode != undefined && self.context.mode == 'nested') {
			var html = Mura.templates['nested'](self.context);
		}
		else {
			var html = Mura.templates['form'](self.context);
		}

		Mura(self.context.formEl).append(html);

		self.currentpage = 0;
		self.attachments={};
		self.formInit=true;
		Mura.trackEvent({category:'Form',action:'Impression',label:self.context.name,objectid:self.context.objectid,nonInteraction:true});
	},

	onSubmit: function(){
		return true;
	},

	onPageSubmit: function(){
		return true;
	},

	submitForm: function() {

		var self = this;
		var valid = self.setDataValues();
		Mura(".error-container-" + self.context.objectid,self.context.formEl).empty();

		var keepGoing=this.onSubmit.call(this.context.targetEl);
		if(typeof keepGoing != 'undefined' && !keepGoing){
			return;
		}

		delete self.data.isNew;

		var frm=Mura(self.context.formEl).find('form');
		frm.find('.mura-form-submit').html(self.rb.formbuttonsubmitwaitlabel);
		frm.trigger('formSubmit');

		if(self.ormform) {
			//console.log('a!');
			Mura.getEntity(self.entity)
			.set(
				self.data
			)
			.save()
			.then(
				function( entity ) {
					if(self.backlink != undefined) {
						self.getTableData( self.location );
						return;
					}

					if(typeof resp.data.redirect != 'undefined'){
						if(resp.data.redirect && resp.data.redirect != location.href){
							location.href=resp.data.redirect;
						} else {
							location.reload(true);
						}
					} else {
						Mura(self.context.formEl).html( Mura.templates['success'](data) );
						self.trigger('afterResponseRender');
					}
				},
				function( entity ) {
					self.showErrors( entity.properties.errors );
					self.trigger('afterErrorRender');
				}
			);
		}
		else {
			//console.log('b!');

			if(!Mura.formdata){
				var data=Mura.extend({},self.context,self.data);
				data.saveform=true;
				data.formid=data.objectid;
				data.siteid=self.context.siteid || data.siteid || Mura.siteid;
				data.contentid=Mura.contentid || '';
				data.contenthistid=Mura.contenthistid || '';

				delete data.filename;
				delete data.def;
				delete data.ishuman;
				delete data.targetEl;
				delete data.html;

				if(data.responsechart){
					var frm=Mura(self.context.targetEl);
					var polllist=new Array();
					frm.find("input[type='radio']").each(function(){
						polllist.push(Mura(this).val());
					});
					if(polllist.length > 0) {data.polllist=polllist.toString();}
				}

				var tokenArgs={
					siteid: data.siteid,
					context: data.formid
				}

			} else {
				var rawdata=Mura.extend({},self.context,self.data);
				rawdata.saveform=true;
				rawdata.formid=rawdata.objectid;
				rawdata.siteid=self.context.siteid || rawdata.siteid || Mura.siteid;
				rawdata.contentid=Mura.contentid || '';
				rawdata.contenthistid=Mura.contenthistid || '';

				delete rawdata.filename;
				delete rawdata.def;
				delete rawdata.ishuman;
				delete rawdata.targetEl;
				delete rawdata.html;

				var tokenArgs={
					siteid: rawdata.siteid,
					context: rawdata.formid
				}

				if(rawdata.responsechart){
					var frm=Mura(self.context.targetEl);
					var polllist=new Array();
					frm.find("input[type='radio']").each(function(){
						polllist.push(Mura(this).val());
					});
					if(polllist.length > 0) {rawdata.polllist=polllist.toString();}
				}

				var data=new FormData();

				for(var p in rawdata){
					if(rawdata.hasOwnProperty(p)){
						if(typeof self.attachments[p] != 'undefined'){
							data.append(p,self.attachments[p]);
						} else {
							data.append(p,rawdata[p]);
						}
					}
				}
			}

			Mura.ajax({
				type: 'post',
				url: Mura.apiEndpoint +
					'?method=generateCSRFTokens',
				data: tokenArgs,
				success: function(resp) {

					if(!Mura.formdata){
						data['csrf_token_expires']=resp.data['csrf_token_expires'];
						data['csrf_token']=resp.data['csrf_token'];
					} else {
						data.append('csrf_token_expires',resp.data['csrf_token_expires']);
						data.append('csrf_token',resp.data['csrf_token']);
					}

					Mura.post(
						 Mura.apiEndpoint + '?method=processAsyncObject',
						 data)
						 .then(function(resp){
							 if(typeof resp.data.errors == 'object' && !Mura.isEmptyObject(resp.data.errors )){
								 self.showErrors( resp.data.errors );
								 self.trigger('afterErrorRender');
							 } else {

								 Mura(self.context.formEl)
									 .find('form')
									 .trigger('formSubmitSuccess');

								 Mura.trackEvent({
									 category:'Form',
									 action:'Conversion',
									 label:self.context.name,
									 objectid:self.context.objectid}
								 ).then(function(){
									 if(typeof resp.data.redirect != 'undefined'){
										 if(resp.data.redirect && resp.data.redirect != location.href){
											 location.href=resp.data.redirect;
										 } else {
											 location.reload(true);
										 }
									 } else {
										 Mura(self.context.formEl).html( Mura.templates['success'](resp.data) );
										 self.trigger('afterResponseRender');
									 }
								 });
						 	}
						},
						function(resp){
							self.showErrors( {"systemerror":"We're sorry, a system error has occurred. Please try again later."} );
							self.trigger('afterErrorRender');
						});
				}
			});
		}

	},

	showErrors: function( errors ) {
		var self = this;
		var frm=Mura(this.context.formEl);
		var frmErrors=frm.find(".error-container-" + self.context.objectid);

		frm.find('.mura-form-submit').html(self.rb.formbuttonsubmitlabel);
		frm.find('.mura-response-error').remove();

		console.log(errors);

		//var errorData = {};

		/*
		for(var i in self.fields) {
			var field = self.fields[i];

			if( errors[ field.name ] ) {
				var error = {};
				error.message = field.validatemessage && field.validatemessage.length ? field.validatemessage : errors[field.name];
				error.field = field.name;
				error.label = field.label;
				errorData[field.name] = error;
			}

		}
		*/

		for(var e in errors) {
			if( typeof self.fields[e] != 'undefined' ) {
				var field = self.fields[e]
				var error = {};
				error.message = field.validatemessage && field.validatemessage.length ? field.validatemessage : errors[field.name];
				error.field = field.name;
				error.label = field.label;
				//errorData[e] = error;
			} else {
				var error = {};
				error.message = errors[e];
				error.field = '';
				error.label = '';
				//errorData[e] = error;
			}

			if(this.inlineerrors){
				var label=Mura(this.context.formEl).find('label[data-for="' + e + '"]');

				if(label.length){
					label.node.insertAdjacentHTML('afterend',Mura.templates['error'](error));
				} else {
					frmErrors.append(Mura.templates['error'](error));
				}
			} else {
				frmErrors.append(Mura.templates['error'](error));
			}
		}

		Mura(self.context.formEl).find('.g-recaptcha-container').each(function(el){
			grecaptcha.reset(el.getAttribute('data-widgetid'));
		});

		var errorsSel=Mura(this.context.formEl).find('.mura-response-error');

		if(errorsSel.length){
			errorsSel=errorsSel.first().node;
			if(!Mura.isScrolledIntoView(errorsSel) && typeof errorsSel.scrollIntoView != 'undefined'){
				errorsSel.scrollIntoView(true);
			}
		}
	},


	// lists
	getList: function() {
		var self = this;

		var entityName = '';

		/*
		if(Mura.templateList.length) {
			self.getTemplates();
		}
		else {
		*/
			self.loadList();
		//}
	},

	filterResults: function() {
		var self = this;
		var before = "";
		var after = "";

		self.filters.filterby = Mura("#results-filterby",self.context.formEl).val();
		self.filters.filterkey = Mura("#results-keywords",self.context.formEl).val();

		if( Mura("#date1",self.context.formEl).length ) {
			if(Mura("#date1",self.context.formEl).val().length) {
				self.filters.from = Mura("#date1",self.context.formEl).val() + " " + Mura("#hour1",self.context.formEl).val() + ":00:00";
				self.filters.fromhour = Mura("#hour1",self.context.formEl).val();
				self.filters.fromdate = Mura("#date1",self.context.formEl).val();
			}
			else {
				self.filters.from = "";
				self.filters.fromhour = 0;
				self.filters.fromdate = "";
			}

			if(Mura("#date2",self.context.formEl).val().length) {
				self.filters.to = Mura("#date2",self.context.formEl).val() + " " + Mura("#hour2",self.context.formEl).val() + ":00:00";
				self.filters.tohour = Mura("#hour2",self.context.formEl).val();
				self.filters.todate = Mura("#date2",self.context.formEl).val();
			}
			else {
				self.filters.to = "";
				self.filters.tohour = 0;
				self.filters.todate = "";
			}
		}

		self.getTableData();
	},

	downloadResults: function() {
		var self = this;

		self.filterResults();

	},


	loadList: function() {
		var self = this;

		formJSON = self.context.formdata;
		entityName = dself.context.filename.replace(/\W+/g, "");
		self.entity = entityName;
		self.formJSON = formJSON;

		if (formJSON.form.formattributes && formJSON.form.formattributes.Muraormentities == 1) {
			self.ormform = true;
		}
		else {
			Mura(self.context.formEl).append("Unsupported for pre-Mura 7.0 MuraORM Forms.");
			return;
		}

		self.getTableData();

		/*
		Mura.get(
			Mura.apiEndpoint + 'content/' + self.context.objectid
			 + '?fields=body,title,filename,responsemessage'
			).then(function(data) {
			 	formJSON = JSON.parse( data.data.body );
				entityName = data.data.filename.replace(/\W+/g, "");
				self.entity = entityName;
			 	self.formJSON = formJSON;

				if (formJSON.form.formattributes && formJSON.form.formattributes.Muraormentities == 1) {
					self.ormform = true;
				}
				else {
					Mura(self.context.formEl).append("Unsupported for pre-Mura 7.0 MuraORM Forms.");
					return;
				}

				self.getTableData();
		});
		*/
	},

	getTableData: function( navlink ) {
		var self = this;

		Mura.get(
			Mura.apiEndpoint	+ self.entity + '/listviewdescriptor'
		).then(function(resp) {
				self.columns = resp.data;
			Mura.get(
				Mura.apiEndpoint + self.entity + '/propertydescriptor/'
			).then(function(resp) {
				self.properties = self.cleanProps(resp.data);
				if( navlink == undefined) {
					navlink = Mura.apiEndpoint + self.entity + '?sort=' + self.sortdir + self.sortfield;
					var fields = [];
					for(var i = 0;i < self.columns.length;i++) {
						fields.push(self.columns[i].column);
					}
					navlink = navlink + "&fields=" + fields.join(",");

					if (self.filters.filterkey && self.filters.filterkey != '') {
						navlink = navlink + "&" + self.filters.filterby + "=contains^" + self.filters.filterkey;
					}

					if (self.filters.from && self.filters.from != '') {
						navlink = navlink + "&created[1]=gte^" + self.filters.from;
					}
					if (self.filters.to && self.filters.to != '') {
						navlink = navlink + "&created[2]=lte^" + self.filters.to;
					}
				}

				Mura.get(
					navlink
				).then(function(resp) {
					self.data = resp.data;
					self.location = self.data.links.self;

					var tableData = {rows:self.data,columns:self.columns,properties:self.properties,filters:self.filters};
					self.renderTable( tableData );
				});

			});
		});

	},

	renderTable: function( tableData ) {
		var self = this;

		var html = Mura.templates['table'](tableData);
		Mura(self.context.formEl).html( html );

		if (self.context.view == 'list') {
			Mura("#date-filters",self.context.formEl).empty();
			Mura("#btn-results-download",self.context.formEl).remove();
		}
		else {
			if (self.context.render == undefined) {
				Mura(".datepicker", self.context.formEl).datepicker();
			}

			Mura("#btn-results-download",self.context.formEl).click( function() {
				self.downloadResults();
			});
		}

		Mura("#btn-results-search",self.context.formEl).click( function() {
			self.filterResults();
		});


		Mura(".data-edit",self.context.formEl).click( function() {
			self.renderCRUD( Mura(this).attr('data-value'),Mura(this).attr('data-pos'));
		});
		Mura(".data-view",self.context.formEl).click( function() {
			self.loadOverview(Mura(this).attr('data-value'),Mura(this).attr('data-pos'));
		});
		Mura(".data-nav",self.context.formEl).click( function() {
			self.getTableData( Mura(this).attr('data-value') );
		});

		Mura(".data-sort").click( function() {

			var sortfield = Mura(this).attr('data-value');

			if(sortfield == self.sortfield && self.sortdir == '')
				self.sortdir = '-';
			else
				self.sortdir = '';

			self.sortfield = Mura(this).attr('data-value');
			self.getTableData();

		});
	},


	loadOverview: function(itemid,pos) {
		var self = this;

		Mura.get(
			Mura.apiEndpoint + entityName + '/' + itemid + '?expand=all'
			).then(function(resp) {
				self.item = resp.data;

				self.renderOverview();
		});
	},

	renderOverview: function() {
		var self = this;

		//console.log('ia');
		//console.log(self.item);

		Mura(self.context.formEl).empty();

		var html = Mura.templates['view'](self.item);
		Mura(self.context.formEl).append(html);

		Mura(".nav-back",self.context.formEl).click( function() {
			self.getTableData( self.location );
		});
	},

	renderCRUD: function( itemid,pos ) {
		var self = this;

		self.formInit = 0;
		self.initForm();

		self.getForm(itemid,self.data.links.self);
	},

	cleanProps: function( props ) {
		var propsOrdered = {};
		var propsRet = {};
		var ct = 100000;

		delete props.isnew;
		delete props.created;
		delete props.lastUpdate;
		delete props.errors;
		delete props.saveErrors;
		delete props.instance;
		delete props.instanceid;
		delete props.frommuracache;
		delete props[self.entity + "id"];

		for(var i in props) {
			if( props[i].orderno != undefined) {
				propsOrdered[props[i].orderno] = props[i];
			}
			else {
				propsOrdered[ct++] = props[i];
			}
		}

		Object.keys(propsOrdered)
			.sort()
				.forEach(function(v, i) {
				propsRet[v] = propsOrdered[v];
		});

		return propsRet;
	},

	registerHelpers: function() {
		var self = this;

		Mura.extend(self.rb,Mura.rb);

		Mura.Handlebars.registerHelper('eachColRow',function(row, columns, options) {
			var ret = "";
			for(var i = 0;i < columns.length;i++) {
				ret = ret + options.fn(row[columns[i].column]);
			}
			return ret;
		});

		Mura.Handlebars.registerHelper('eachProp',function(data, options) {
			var ret = "";
			var obj = {};

			for(var i in self.properties) {
				obj.displayName = self.properties[i].displayName;
				if( self.properties[i].fieldtype == "one-to-one" ) {
					obj.displayValue = data[ self.properties[i].cfc ].val;
				}
				else
					obj.displayValue = data[ self.properties[i].column ];

				ret = ret + options.fn(obj);
			}
			return ret;
		});

		Mura.Handlebars.registerHelper('eachKey',function(properties, by, options) {
			var ret = "";
			var item = "";
			for(var i in properties) {
				item = properties[i];

				if(item.column == by)
					item.selected = "Selected";

				if(item.rendertype == 'textfield')
					ret = ret + options.fn(item);
			}

			return ret;
		});

		Mura.Handlebars.registerHelper('eachHour',function(hour, options) {
			var ret = "";
			var h = 0;
			var val = "";

			for(var i = 0;i < 24;i++) {

				if(i == 0 ) {
					val = {label:"12 AM",num:i};
				}
				else if(i <12 ) {
					h = i;
					val = {label:h + " AM",num:i};
				}
				else if(i == 12 ) {
					h = i;
					val = {label:h + " PM",num:i};
				}
				else {
					h = i-12;
					val = {label:h + " PM",num:i};
				}

				if(hour == i)
					val.selected = "selected";

				ret = ret + options.fn(val);
			}
			return ret;
		});

		Mura.Handlebars.registerHelper('eachColButton',function(row, options) {
			var ret = "";

			row.label='View';
			row.type='data-view';

			// only do view if there are more properties than columns
			if( Object.keys(self.properties).length > self.columns.length) {
				ret = ret + options.fn(row);
			}

			if( self.context.view == 'edit') {
				row.label='Edit';
				row.type='data-edit';

				ret = ret + options.fn(row);
			}

			return ret;
		});

		Mura.Handlebars.registerHelper('eachCheck',function(checks, selected, options) {
			var ret = "";

			for(var i = 0;i < checks.length;i++) {
				if( selected.indexOf( checks[i].id ) > -1 )
					checks[i].isselected = 1;
				else
				 	checks[i].isselected = 0;

				ret = ret + options.fn(checks[i]);
			}
			return ret;
		});

		Mura.Handlebars.registerHelper('eachStatic',function(dataset, options) {
			var ret = "";

			for(var i = 0;i < dataset.datarecordorder.length;i++) {
				ret = ret + options.fn(dataset.datarecords[dataset.datarecordorder[i]]);
			}
			return ret;
		});

		Mura.Handlebars.registerHelper('inputWrapperClass',function() {
			var escapeExpression=Mura.Handlebars.escapeExpression;
			var returnString='mura-control-group';

			if(self.rb.formfieldwrapperclass){
				returnString += ' ' + self.rb.formfieldwrapperclass;
			}

			if(this.wrappercssclass){
				returnString += ' ' + escapeExpression(this.wrappercssclass);
			}

			if(this.isrequired){
				returnString += ' req';

				if(self.rb.formrequiredwrapperclass){
					returnString += ' ' + self.rb.formrequiredwrapperclass;
				}
			}

			return returnString;
		});

		Mura.Handlebars.registerHelper('radioLabelClass',function() {
			return self.rb.formradiolabelclass;
		});

		Mura.Handlebars.registerHelper('formErrorWrapperClass',function() {
			if(self.rb.formerrorwrapperclass){
				return 'mura-response-error' + ' ' + self.rb.formerrorwrapperclass;
			} else {
				return 'mura-response-error';
			}
		});

		Mura.Handlebars.registerHelper('formSuccessWrapperClass',function() {
			if(self.rb.formresponsewrapperclass){
				return 'mura-response-success' + ' ' + self.rb.formresponsewrapperclass;
			} else {
				return 'mura-response-success';
			}
		});

		Mura.Handlebars.registerHelper('formResponseWrapperClass',function() {
			if(self.rb.formresponsewrapperclass){
				return 'mura-response-success' + ' ' + self.rb.formresponsewrapperclass;
			} else {
				return 'mura-response-success';
			}
		});

		Mura.Handlebars.registerHelper('radioClass',function() {
			return self.rb.formradioclass;
		});

		Mura.Handlebars.registerHelper('radioWrapperClass',function() {
			return self.rb.formradiowrapperclass;
		});

		Mura.Handlebars.registerHelper('checkboxLabelClass',function() {
			return self.rb.formcheckboxlabelclass;
		});

		Mura.Handlebars.registerHelper('checkboxClass',function() {
			return self.rb.formcheckboxclass;
		});

		Mura.Handlebars.registerHelper('checkboxWrapperClass',function() {
			return self.rb.formcheckboxwrapperclass;
		});

		Mura.Handlebars.registerHelper('formRequiredLabel',function() {
			return self.rb.formrequiredlabel;
		});

		Mura.Handlebars.registerHelper('formClass',function() {
			var escapeExpression=Mura.Handlebars.escapeExpression;
			var returnString='mura-form';

			if(self.formJSON && self.formJSON.form && self.formJSON.form.formattributes && self.formJSON.form.formattributes.class){
				returnString += ' ' + escapeExpression(self.formJSON.form.formattributes.class);
			}

			return returnString;
		});

		Mura.Handlebars.registerHelper('textInputTypeValue',function() {
			if(typeof Mura.useHTML5DateInput != 'undefined' && Mura.useHTML5DateInput && typeof this.validatetype != 'undefined' && this.validatetype.toLowerCase()=='date'){
				return 'date';
			} else {
				return 'text';
			}
		});

		Mura.Handlebars.registerHelper('labelForValue',function() {
			//id, class, title, size
			var escapeExpression=Mura.Handlebars.escapeExpression;

			if(this.cssid){
				return escapeExpression(this.cssid);
			} else {
				return "field-" + escapeExpression(this.name) ;
			}

			return returnString;
		});

		Mura.Handlebars.registerHelper('commonInputAttributes',function() {
			//id, class, title, size
			var escapeExpression=Mura.Handlebars.escapeExpression;

			if(typeof this.fieldtype != 'undefined' && this.fieldtype.fieldtype=='file'){
				var returnString='name="' + escapeExpression(self.context.prefix + this.name) + '_attachment"';
			} else {
				var returnString='name="' + escapeExpression(self.context.prefix + this.name) + '"';
			}

			if(this.cssid){
				returnString += ' id="' + escapeExpression(this.cssid) + '"';
			} else {
				returnString += ' id="field-' + escapeExpression(self.context.prefix + this.name) + '"';
			}

			returnString += ' class="';

			if(this.cssclass){
				returnString += escapeExpression(this.cssclass) + ' ';
			}

			if(this.fieldtype=='radio' || this.fieldtype=='radio_static'){
				returnString += self.rb.formradioclass;
			} else if(this.fieldtype=='checkbox' || this.fieldtype=='checkbox_static'){
				returnString += self.rb.formcheckboxclass;
			} else if(this.fieldtype=='file'){
				returnString += self.rb.formfileclass;
			} else if(this.fieldtype=='textarea'){
				returnString += self.rb.formtextareaclass;
			} else if(this.fieldtype=='dropdown' || this.fieldtype=='dropdown_static'){
				returnString += self.rb.formselectclass;
			} else if(this.fieldtype=='textblock'){
				returnString += self.rb.formtextblockclass;
			} else {
				returnString += self.rb.forminputclass;
			}

			returnString += '"';

			if(this.tooltip){
				returnString += ' title="' + escapeExpression(this.tooltip) + '"';
			}

			if(this.size){
				returnString += ' size="' + escapeExpression(this.size) + '"';
			}

			if(typeof Mura.useHTML5DateInput != 'undefined' && Mura.useHTML5DateInput && typeof this.validatetype != 'undefined' && this.validatetype.toLowerCase()=='date'){
				returnString += ' data-date-format="' + Mura.dateformat + '"';
			}

			return returnString;
		});
	}
});

//Legacy for early adopter backwords support
Mura.DisplayObject.Form=Mura.UI.Form;


/***/ }),
/* 357 */
/***/ (function(module, exports, __webpack_require__) {

var Mura=__webpack_require__(9);
/**
 * Creates a new Mura.UI.Text
 * @name  Mura.UI.Text
 * @class
 * @extends Mura.UI
 * @memberof  Mura
 */

Mura.UI.Text=Mura.UI.extend(
/** @lends Mura.DisplayObject.Text.prototype */
{
	renderClient:function(){
		Mura(this.context.targetEl).html(Mura.templates['text'](this.context));
		this.trigger('afterRender');
	},

	renderServer:function(){
		this.context.sourcetype=this.context.sourcetype || 'custom';

		if(this.context.sourcetype=='custom'){
			return Mura.templates['text'](this.context);
		} else {
			return '';
		}
	}
});

Mura.DisplayObject.Text=Mura.UI.Text;


/***/ }),
/* 358 */
/***/ (function(module, exports, __webpack_require__) {

var Mura=__webpack_require__(9);
/**
 * Creates a new Mura.UI.Text
 * @name  Mura.UI.Hr
 * @class
 * @extends Mura.UI
 * @memberof  Mura
 */

Mura.UI.Hr=Mura.UI.extend(
/** @lends Mura.DisplayObject.Hr.prototype */
{
	renderClient:function(){
		Mura(this.context.targetEl).html("<hr>");
		this.trigger('afterRender');
	},

	renderServer:function(){
        return "<hr>";
	
	}
});

Mura.DisplayObject.Hr=Mura.UI.Hr;


/***/ }),
/* 359 */
/***/ (function(module, exports, __webpack_require__) {

var Mura=__webpack_require__(9);
/**
 * Creates a new Mura.UI.Embed
 * @name  Mura.UI.Embed
 * @class
 * @extends Mura.UI
 * @memberof  Mura
 */

Mura.UI.Embed=Mura.UI.extend(
/** @lends Mura.DisplayObject.Embed.prototype */
{
	renderClient:function(){
		Mura(this.context.targetEl).html(Mura.templates['embed'](this.context));
		this.trigger('afterRender');
	},

	renderServer:function(){
		return Mura.templates['embed'](this.context);
	}
});

Mura.DisplayObject.Embed=Mura.UI.Embed;


/***/ }),
/* 360 */
/***/ (function(module, exports, __webpack_require__) {

var Mura=__webpack_require__(9);
/**
 * Creates a new Mura.UI.Text
 * @name  Mura.UI.Image
 * @class
 * @extends Mura.UI
 * @memberof  Mura
 */

Mura.UI.Image=Mura.UI.extend(
/** @lends Mura.DisplayObject.Image.prototype */
{
	renderClient:function(){
		Mura(this.context.targetEl).html(Mura.templates['image'](this.context));
		this.trigger('afterRender');
	},

	renderServer:function(){
		return Mura.templates['image'](this.context);
	
	}
});

Mura.DisplayObject.Image=Mura.UI.Image;


/***/ }),
/* 361 */
/***/ (function(module, exports, __webpack_require__) {

var Mura=__webpack_require__(9);
/**
 * Creates a new Mura.UI.Collection
 * @name  Mura.UI.Collection
 * @class
 * @extends Mura.UI
 * @memberof  Mura
 */

Mura.UI.Collection=Mura.UI.extend(
/** @lends Mura.UI.Collection.prototype */
{
	defaultLayout: "List",

	layoutInstance:'',

	getLayoutInstance:function(){
		if(this.layoutInstance){
			this.layoutInstance.destroy();
		}
		this.layoutInstance=new Mura.Module[this.context.layout](this.context);
		return this.layoutInstance;
	},

	getCollection:function(){
		var self=this;
		if(typeof this.context.feed != 'undefined' && typeof this.context.feed.getQuery != 'undefined'){
			return this.context.feed.getQuery();
		} else {
			this.context.source=this.context.source || '';

			if(typeof this.context.nextn != 'undefined'){
				this.context.itemsperpage=this.context.nextn;
			}

			if(typeof this.context.maxitems == 'undefined'){
				this.context.maxitems=20;
			}

			if(typeof this.context.itemsperpage != 'undefined'){
				this.context.itemsperpage=this.context.nextn;
			}

			if(typeof this.context.expand == 'undefined'){
				this.context.expand='';
			}

			if(typeof this.context.expanddepth == 'undefined'){
				this.context.expanddepth=1;
			}

			if(typeof this.context.fields == 'undefined'){
				this.context.fields='';
			}

			if(typeof this.context.rawcollection != 'undefined'){
				return new Promise(function(resolve,reject){
					resolve(new Mura.EntityCollection(self.context.rawcollection,Mura._requestcontext))
				});
			} else if(this.context.sourcetype=='relatedcontent'){
				if(this.context.source=='custom'){
					if(typeof this.context.items != 'undefined'){
						this.context.items=this.context.items.join();
					}
					return Mura.get(Mura.apiEndpoint + 'content/' + this.context.items + ',_',{
						itemsperpage:this.context.itemsperpage,
						maxitems:this.context.maxitems,
						expand:this.context.expand,
						expanddepth:this.context.expanddepth,
						fields:this.context.fields
					}).then(function(resp){
						return new Mura.EntityCollection(resp.data,Mura._requestcontext);
					});
				} else if(this.context.source=='reverse'){
					return Mura.getEntity('content')
						.set({
							'contentid':Mura.contentid,
							'id':Mura.contentid
						}).getRelatedContent('reverse',{
							itemsperpage:this.context.itemsperpage,
							maxitems:this.context.maxitems,
							sortby:this.context.sortby,
							expand:this.context.expand,
							expanddepth:this.context.expanddepth,
							fields:this.context.fields
						})
				} else {
					return Mura.getEntity('content')
						.set({
							'contentid':Mura.contentid,
							'id':Mura.contentid
						}).getRelatedContent(this.context.source,{
							itemsperpage:this.context.itemsperpage,
							maxitems:this.context.maxitems,
							expand:this.context.expand,
							expanddepth:this.context.expanddepth,
							fields:this.context.fields
						})
				}
			} else if(this.context.sourcetype=='children'){
				return Mura.getFeed('content')
					.where()
					.prop('parentid').isEQ(Mura.contentid)
					.maxItems(100)
					.itemsPerPage(this.context.itemsperpage)
					.expand(this.context.expand)
					.expandDepth(this.context.expanddepth)
					.fields(this.context.fields)
					.getQuery();
			} else {
				return Mura.getFeed('content')
					.where()
					.prop('feedid').isEQ(this.context.source)
					.maxItems(this.context.maxitems)
					.itemsPerPage(this.context.itemsperpage)
					.expand(this.context.expand)
					.expandDepth(this.context.expand)
					.fields(this.context.fields)
					.getQuery();
			}
		}
	},

	renderClient:function(){
		if(typeof Mura.Module[this.context.layout] == 'undefined'){
			this.context.layout=Mura.firstToUpperCase(this.context.layout);
		}
		if(typeof Mura.Module[this.context.layout] == 'undefined'
	 		&& Mura.Module[this.defaultLayout] != 'undefined'){
				this.context.layout=this.defaultLayout;
		}
		var self=this;
		if (typeof Mura.Module[this.context.layout] != 'undefined'){
			this.getCollection().then(function(collection){
				self.context.collection=collection;
				self.getLayoutInstance().renderClient();
			})
		} else {
			this.context.targetEl.innerHTML="This collection has an undefined layout";
		}
		this.trigger('afterRender');
	},

	renderServer:function(){
		//has implementation in ui.serverutils
		return '';
	},

	destroy:function(){
		//has implementation in ui.serverutils
		if(this.layoutInstance){
			this.layoutInstance.destroy();
		}
	}

});

Mura.Module.Collection=Mura.UI.Collection;


/***/ }),
/* 362 */
/***/ (function(module, exports, __webpack_require__) {


var Mura=__webpack_require__(9);
var Handlebars=__webpack_require__(363);
Mura.Handlebars=Handlebars.create();
Mura.templatesLoaded=false;
Handlebars.noConflict();

Mura.templates=Mura.templates || {};
Mura.templates['meta']=function(context){
	if(typeof context.labeltag == 'undefined' || !context.labeltag){
		context.labeltag='h2';
	}
	if(context.label){
		return '<div class="mura-object-meta-wrapper"><div class="mura-object-meta"><' + Mura.escapeHTML(context.labeltag) + '>' + Mura.escapeHTML(context.label) + '</' + Mura.escapeHTML(context.labeltag) + '></div></div><div class="mura-flex-break"></div>';
	} else {
		return '';
	}
}
Mura.templates['content']=function(context){
	context.html=context.html || context.content || context.source || '';
	return '<div class="mura-object-content">' + context.html + '</div>';
}
Mura.templates['text']=function(context){
	context=context || {};
	if(context.label){
		context.source=context.source || '';
	} else {
		context.source=context.source || '<p></p>';
	}
	return context.source;
}
Mura.templates['embed']=function(context){
	context=context || {};
	if(context.label){
		context.source=context.source || '';
	} else {
		context.source=context.source || '<p></p>';
	}
	return context.source;
}

Mura.templates['image']=function(context){
	context=context || {};
	context.src=context.src||'';
	context.alt=context.alt||'';
	context.caption=context.caption||'';
	context.imagelink=context.imagelink||'';

	var source='';

	if(!context.src){
		return '';
	}

	source='<img src="' + Mura.escapeHTML(context.src) + '" alt="' + Mura.escapeHTML(context.alt) + '" />';
	if(context.imagelink){
		context.imagelinktarget=context.imagelinktarget || "";
		var targetString="";
		if(context.imagelinktarget){
			targetString=' target="' + Mura.escapeHTML(context.imagelinktarget) + '"';
		}
		source='<a href="' +  Mura.escapeHTML(context.imagelink) + '"' + targetString + '/>' + source + '</a>';
	}
	if(context.caption && context.caption != '<p></p>'){
		source+='<figcaption>' + context.caption + '</figcaption>';
	}
	source='<figure>' + source + '</figure>';

	return source;
}

__webpack_require__(378);


/***/ }),
/* 363 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;
// istanbul ignore next

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

// istanbul ignore next

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } else { var newObj = {}; if (obj != null) { for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) newObj[key] = obj[key]; } } newObj['default'] = obj; return newObj; } }

var _handlebarsBase = __webpack_require__(134);

var base = _interopRequireWildcard(_handlebarsBase);

// Each of these augment the Handlebars object. No need to setup here.
// (This is done to easily share code between commonjs and browse envs)

var _handlebarsSafeString = __webpack_require__(374);

var _handlebarsSafeString2 = _interopRequireDefault(_handlebarsSafeString);

var _handlebarsException = __webpack_require__(45);

var _handlebarsException2 = _interopRequireDefault(_handlebarsException);

var _handlebarsUtils = __webpack_require__(28);

var Utils = _interopRequireWildcard(_handlebarsUtils);

var _handlebarsRuntime = __webpack_require__(375);

var runtime = _interopRequireWildcard(_handlebarsRuntime);

var _handlebarsNoConflict = __webpack_require__(377);

var _handlebarsNoConflict2 = _interopRequireDefault(_handlebarsNoConflict);

// For compatibility and usage outside of module systems, make the Handlebars object a namespace
function create() {
  var hb = new base.HandlebarsEnvironment();

  Utils.extend(hb, base);
  hb.SafeString = _handlebarsSafeString2['default'];
  hb.Exception = _handlebarsException2['default'];
  hb.Utils = Utils;
  hb.escapeExpression = Utils.escapeExpression;

  hb.VM = runtime;
  hb.template = function (spec) {
    return runtime.template(spec, hb);
  };

  return hb;
}

var inst = create();
inst.create = create;

_handlebarsNoConflict2['default'](inst);

inst['default'] = inst;

exports['default'] = inst;
module.exports = exports['default'];
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uL2xpYi9oYW5kbGViYXJzLnJ1bnRpbWUuanMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7OEJBQXNCLG1CQUFtQjs7SUFBN0IsSUFBSTs7Ozs7b0NBSU8sMEJBQTBCOzs7O21DQUMzQix3QkFBd0I7Ozs7K0JBQ3ZCLG9CQUFvQjs7SUFBL0IsS0FBSzs7aUNBQ1Esc0JBQXNCOztJQUFuQyxPQUFPOztvQ0FFSSwwQkFBMEI7Ozs7O0FBR2pELFNBQVMsTUFBTSxHQUFHO0FBQ2hCLE1BQUksRUFBRSxHQUFHLElBQUksSUFBSSxDQUFDLHFCQUFxQixFQUFFLENBQUM7O0FBRTFDLE9BQUssQ0FBQyxNQUFNLENBQUMsRUFBRSxFQUFFLElBQUksQ0FBQyxDQUFDO0FBQ3ZCLElBQUUsQ0FBQyxVQUFVLG9DQUFhLENBQUM7QUFDM0IsSUFBRSxDQUFDLFNBQVMsbUNBQVksQ0FBQztBQUN6QixJQUFFLENBQUMsS0FBSyxHQUFHLEtBQUssQ0FBQztBQUNqQixJQUFFLENBQUMsZ0JBQWdCLEdBQUcsS0FBSyxDQUFDLGdCQUFnQixDQUFDOztBQUU3QyxJQUFFLENBQUMsRUFBRSxHQUFHLE9BQU8sQ0FBQztBQUNoQixJQUFFLENBQUMsUUFBUSxHQUFHLFVBQVMsSUFBSSxFQUFFO0FBQzNCLFdBQU8sT0FBTyxDQUFDLFFBQVEsQ0FBQyxJQUFJLEVBQUUsRUFBRSxDQUFDLENBQUM7R0FDbkMsQ0FBQzs7QUFFRixTQUFPLEVBQUUsQ0FBQztDQUNYOztBQUVELElBQUksSUFBSSxHQUFHLE1BQU0sRUFBRSxDQUFDO0FBQ3BCLElBQUksQ0FBQyxNQUFNLEdBQUcsTUFBTSxDQUFDOztBQUVyQixrQ0FBVyxJQUFJLENBQUMsQ0FBQzs7QUFFakIsSUFBSSxDQUFDLFNBQVMsQ0FBQyxHQUFHLElBQUksQ0FBQzs7cUJBRVIsSUFBSSIsImZpbGUiOiJoYW5kbGViYXJzLnJ1bnRpbWUuanMiLCJzb3VyY2VzQ29udGVudCI6WyJpbXBvcnQgKiBhcyBiYXNlIGZyb20gJy4vaGFuZGxlYmFycy9iYXNlJztcblxuLy8gRWFjaCBvZiB0aGVzZSBhdWdtZW50IHRoZSBIYW5kbGViYXJzIG9iamVjdC4gTm8gbmVlZCB0byBzZXR1cCBoZXJlLlxuLy8gKFRoaXMgaXMgZG9uZSB0byBlYXNpbHkgc2hhcmUgY29kZSBiZXR3ZWVuIGNvbW1vbmpzIGFuZCBicm93c2UgZW52cylcbmltcG9ydCBTYWZlU3RyaW5nIGZyb20gJy4vaGFuZGxlYmFycy9zYWZlLXN0cmluZyc7XG5pbXBvcnQgRXhjZXB0aW9uIGZyb20gJy4vaGFuZGxlYmFycy9leGNlcHRpb24nO1xuaW1wb3J0ICogYXMgVXRpbHMgZnJvbSAnLi9oYW5kbGViYXJzL3V0aWxzJztcbmltcG9ydCAqIGFzIHJ1bnRpbWUgZnJvbSAnLi9oYW5kbGViYXJzL3J1bnRpbWUnO1xuXG5pbXBvcnQgbm9Db25mbGljdCBmcm9tICcuL2hhbmRsZWJhcnMvbm8tY29uZmxpY3QnO1xuXG4vLyBGb3IgY29tcGF0aWJpbGl0eSBhbmQgdXNhZ2Ugb3V0c2lkZSBvZiBtb2R1bGUgc3lzdGVtcywgbWFrZSB0aGUgSGFuZGxlYmFycyBvYmplY3QgYSBuYW1lc3BhY2VcbmZ1bmN0aW9uIGNyZWF0ZSgpIHtcbiAgbGV0IGhiID0gbmV3IGJhc2UuSGFuZGxlYmFyc0Vudmlyb25tZW50KCk7XG5cbiAgVXRpbHMuZXh0ZW5kKGhiLCBiYXNlKTtcbiAgaGIuU2FmZVN0cmluZyA9IFNhZmVTdHJpbmc7XG4gIGhiLkV4Y2VwdGlvbiA9IEV4Y2VwdGlvbjtcbiAgaGIuVXRpbHMgPSBVdGlscztcbiAgaGIuZXNjYXBlRXhwcmVzc2lvbiA9IFV0aWxzLmVzY2FwZUV4cHJlc3Npb247XG5cbiAgaGIuVk0gPSBydW50aW1lO1xuICBoYi50ZW1wbGF0ZSA9IGZ1bmN0aW9uKHNwZWMpIHtcbiAgICByZXR1cm4gcnVudGltZS50ZW1wbGF0ZShzcGVjLCBoYik7XG4gIH07XG5cbiAgcmV0dXJuIGhiO1xufVxuXG5sZXQgaW5zdCA9IGNyZWF0ZSgpO1xuaW5zdC5jcmVhdGUgPSBjcmVhdGU7XG5cbm5vQ29uZmxpY3QoaW5zdCk7XG5cbmluc3RbJ2RlZmF1bHQnXSA9IGluc3Q7XG5cbmV4cG9ydCBkZWZhdWx0IGluc3Q7XG4iXX0=


/***/ }),
/* 364 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;

var _utils = __webpack_require__(28);

exports['default'] = function (instance) {
  instance.registerHelper('blockHelperMissing', function (context, options) {
    var inverse = options.inverse,
        fn = options.fn;

    if (context === true) {
      return fn(this);
    } else if (context === false || context == null) {
      return inverse(this);
    } else if (_utils.isArray(context)) {
      if (context.length > 0) {
        if (options.ids) {
          options.ids = [options.name];
        }

        return instance.helpers.each(context, options);
      } else {
        return inverse(this);
      }
    } else {
      if (options.data && options.ids) {
        var data = _utils.createFrame(options.data);
        data.contextPath = _utils.appendContextPath(options.data.contextPath, options.name);
        options = { data: data };
      }

      return fn(context, options);
    }
  });
};

module.exports = exports['default'];
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL2hlbHBlcnMvYmxvY2staGVscGVyLW1pc3NpbmcuanMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7OztxQkFBd0QsVUFBVTs7cUJBRW5ELFVBQVMsUUFBUSxFQUFFO0FBQ2hDLFVBQVEsQ0FBQyxjQUFjLENBQUMsb0JBQW9CLEVBQUUsVUFBUyxPQUFPLEVBQUUsT0FBTyxFQUFFO0FBQ3ZFLFFBQUksT0FBTyxHQUFHLE9BQU8sQ0FBQyxPQUFPO1FBQzNCLEVBQUUsR0FBRyxPQUFPLENBQUMsRUFBRSxDQUFDOztBQUVsQixRQUFJLE9BQU8sS0FBSyxJQUFJLEVBQUU7QUFDcEIsYUFBTyxFQUFFLENBQUMsSUFBSSxDQUFDLENBQUM7S0FDakIsTUFBTSxJQUFJLE9BQU8sS0FBSyxLQUFLLElBQUksT0FBTyxJQUFJLElBQUksRUFBRTtBQUMvQyxhQUFPLE9BQU8sQ0FBQyxJQUFJLENBQUMsQ0FBQztLQUN0QixNQUFNLElBQUksZUFBUSxPQUFPLENBQUMsRUFBRTtBQUMzQixVQUFJLE9BQU8sQ0FBQyxNQUFNLEdBQUcsQ0FBQyxFQUFFO0FBQ3RCLFlBQUksT0FBTyxDQUFDLEdBQUcsRUFBRTtBQUNmLGlCQUFPLENBQUMsR0FBRyxHQUFHLENBQUMsT0FBTyxDQUFDLElBQUksQ0FBQyxDQUFDO1NBQzlCOztBQUVELGVBQU8sUUFBUSxDQUFDLE9BQU8sQ0FBQyxJQUFJLENBQUMsT0FBTyxFQUFFLE9BQU8sQ0FBQyxDQUFDO09BQ2hELE1BQU07QUFDTCxlQUFPLE9BQU8sQ0FBQyxJQUFJLENBQUMsQ0FBQztPQUN0QjtLQUNGLE1BQU07QUFDTCxVQUFJLE9BQU8sQ0FBQyxJQUFJLElBQUksT0FBTyxDQUFDLEdBQUcsRUFBRTtBQUMvQixZQUFJLElBQUksR0FBRyxtQkFBWSxPQUFPLENBQUMsSUFBSSxDQUFDLENBQUM7QUFDckMsWUFBSSxDQUFDLFdBQVcsR0FBRyx5QkFDakIsT0FBTyxDQUFDLElBQUksQ0FBQyxXQUFXLEVBQ3hCLE9BQU8sQ0FBQyxJQUFJLENBQ2IsQ0FBQztBQUNGLGVBQU8sR0FBRyxFQUFFLElBQUksRUFBRSxJQUFJLEVBQUUsQ0FBQztPQUMxQjs7QUFFRCxhQUFPLEVBQUUsQ0FBQyxPQUFPLEVBQUUsT0FBTyxDQUFDLENBQUM7S0FDN0I7R0FDRixDQUFDLENBQUM7Q0FDSiIsImZpbGUiOiJibG9jay1oZWxwZXItbWlzc2luZy5qcyIsInNvdXJjZXNDb250ZW50IjpbImltcG9ydCB7IGFwcGVuZENvbnRleHRQYXRoLCBjcmVhdGVGcmFtZSwgaXNBcnJheSB9IGZyb20gJy4uL3V0aWxzJztcblxuZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24oaW5zdGFuY2UpIHtcbiAgaW5zdGFuY2UucmVnaXN0ZXJIZWxwZXIoJ2Jsb2NrSGVscGVyTWlzc2luZycsIGZ1bmN0aW9uKGNvbnRleHQsIG9wdGlvbnMpIHtcbiAgICBsZXQgaW52ZXJzZSA9IG9wdGlvbnMuaW52ZXJzZSxcbiAgICAgIGZuID0gb3B0aW9ucy5mbjtcblxuICAgIGlmIChjb250ZXh0ID09PSB0cnVlKSB7XG4gICAgICByZXR1cm4gZm4odGhpcyk7XG4gICAgfSBlbHNlIGlmIChjb250ZXh0ID09PSBmYWxzZSB8fCBjb250ZXh0ID09IG51bGwpIHtcbiAgICAgIHJldHVybiBpbnZlcnNlKHRoaXMpO1xuICAgIH0gZWxzZSBpZiAoaXNBcnJheShjb250ZXh0KSkge1xuICAgICAgaWYgKGNvbnRleHQubGVuZ3RoID4gMCkge1xuICAgICAgICBpZiAob3B0aW9ucy5pZHMpIHtcbiAgICAgICAgICBvcHRpb25zLmlkcyA9IFtvcHRpb25zLm5hbWVdO1xuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIGluc3RhbmNlLmhlbHBlcnMuZWFjaChjb250ZXh0LCBvcHRpb25zKTtcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIHJldHVybiBpbnZlcnNlKHRoaXMpO1xuICAgICAgfVxuICAgIH0gZWxzZSB7XG4gICAgICBpZiAob3B0aW9ucy5kYXRhICYmIG9wdGlvbnMuaWRzKSB7XG4gICAgICAgIGxldCBkYXRhID0gY3JlYXRlRnJhbWUob3B0aW9ucy5kYXRhKTtcbiAgICAgICAgZGF0YS5jb250ZXh0UGF0aCA9IGFwcGVuZENvbnRleHRQYXRoKFxuICAgICAgICAgIG9wdGlvbnMuZGF0YS5jb250ZXh0UGF0aCxcbiAgICAgICAgICBvcHRpb25zLm5hbWVcbiAgICAgICAgKTtcbiAgICAgICAgb3B0aW9ucyA9IHsgZGF0YTogZGF0YSB9O1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gZm4oY29udGV4dCwgb3B0aW9ucyk7XG4gICAgfVxuICB9KTtcbn1cbiJdfQ==


/***/ }),
/* 365 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/* WEBPACK VAR INJECTION */(function(global) {

exports.__esModule = true;
// istanbul ignore next

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

var _utils = __webpack_require__(28);

var _exception = __webpack_require__(45);

var _exception2 = _interopRequireDefault(_exception);

exports['default'] = function (instance) {
  instance.registerHelper('each', function (context, options) {
    if (!options) {
      throw new _exception2['default']('Must pass iterator to #each');
    }

    var fn = options.fn,
        inverse = options.inverse,
        i = 0,
        ret = '',
        data = undefined,
        contextPath = undefined;

    if (options.data && options.ids) {
      contextPath = _utils.appendContextPath(options.data.contextPath, options.ids[0]) + '.';
    }

    if (_utils.isFunction(context)) {
      context = context.call(this);
    }

    if (options.data) {
      data = _utils.createFrame(options.data);
    }

    function execIteration(field, index, last) {
      if (data) {
        data.key = field;
        data.index = index;
        data.first = index === 0;
        data.last = !!last;

        if (contextPath) {
          data.contextPath = contextPath + field;
        }
      }

      ret = ret + fn(context[field], {
        data: data,
        blockParams: _utils.blockParams([context[field], field], [contextPath + field, null])
      });
    }

    if (context && typeof context === 'object') {
      if (_utils.isArray(context)) {
        for (var j = context.length; i < j; i++) {
          if (i in context) {
            execIteration(i, i, i === context.length - 1);
          }
        }
      } else if (global.Symbol && context[global.Symbol.iterator]) {
        var newContext = [];
        var iterator = context[global.Symbol.iterator]();
        for (var it = iterator.next(); !it.done; it = iterator.next()) {
          newContext.push(it.value);
        }
        context = newContext;
        for (var j = context.length; i < j; i++) {
          execIteration(i, i, i === context.length - 1);
        }
      } else {
        (function () {
          var priorKey = undefined;

          Object.keys(context).forEach(function (key) {
            // We're running the iterations one step out of sync so we can detect
            // the last iteration without have to scan the object twice and create
            // an itermediate keys array.
            if (priorKey !== undefined) {
              execIteration(priorKey, i - 1);
            }
            priorKey = key;
            i++;
          });
          if (priorKey !== undefined) {
            execIteration(priorKey, i - 1, true);
          }
        })();
      }
    }

    if (i === 0) {
      ret = inverse(this);
    }

    return ret;
  });
};

module.exports = exports['default'];
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL2hlbHBlcnMvZWFjaC5qcyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOzs7Ozs7O3FCQU1PLFVBQVU7O3lCQUNLLGNBQWM7Ozs7cUJBRXJCLFVBQVMsUUFBUSxFQUFFO0FBQ2hDLFVBQVEsQ0FBQyxjQUFjLENBQUMsTUFBTSxFQUFFLFVBQVMsT0FBTyxFQUFFLE9BQU8sRUFBRTtBQUN6RCxRQUFJLENBQUMsT0FBTyxFQUFFO0FBQ1osWUFBTSwyQkFBYyw2QkFBNkIsQ0FBQyxDQUFDO0tBQ3BEOztBQUVELFFBQUksRUFBRSxHQUFHLE9BQU8sQ0FBQyxFQUFFO1FBQ2pCLE9BQU8sR0FBRyxPQUFPLENBQUMsT0FBTztRQUN6QixDQUFDLEdBQUcsQ0FBQztRQUNMLEdBQUcsR0FBRyxFQUFFO1FBQ1IsSUFBSSxZQUFBO1FBQ0osV0FBVyxZQUFBLENBQUM7O0FBRWQsUUFBSSxPQUFPLENBQUMsSUFBSSxJQUFJLE9BQU8sQ0FBQyxHQUFHLEVBQUU7QUFDL0IsaUJBQVcsR0FDVCx5QkFBa0IsT0FBTyxDQUFDLElBQUksQ0FBQyxXQUFXLEVBQUUsT0FBTyxDQUFDLEdBQUcsQ0FBQyxDQUFDLENBQUMsQ0FBQyxHQUFHLEdBQUcsQ0FBQztLQUNyRTs7QUFFRCxRQUFJLGtCQUFXLE9BQU8sQ0FBQyxFQUFFO0FBQ3ZCLGFBQU8sR0FBRyxPQUFPLENBQUMsSUFBSSxDQUFDLElBQUksQ0FBQyxDQUFDO0tBQzlCOztBQUVELFFBQUksT0FBTyxDQUFDLElBQUksRUFBRTtBQUNoQixVQUFJLEdBQUcsbUJBQVksT0FBTyxDQUFDLElBQUksQ0FBQyxDQUFDO0tBQ2xDOztBQUVELGFBQVMsYUFBYSxDQUFDLEtBQUssRUFBRSxLQUFLLEVBQUUsSUFBSSxFQUFFO0FBQ3pDLFVBQUksSUFBSSxFQUFFO0FBQ1IsWUFBSSxDQUFDLEdBQUcsR0FBRyxLQUFLLENBQUM7QUFDakIsWUFBSSxDQUFDLEtBQUssR0FBRyxLQUFLLENBQUM7QUFDbkIsWUFBSSxDQUFDLEtBQUssR0FBRyxLQUFLLEtBQUssQ0FBQyxDQUFDO0FBQ3pCLFlBQUksQ0FBQyxJQUFJLEdBQUcsQ0FBQyxDQUFDLElBQUksQ0FBQzs7QUFFbkIsWUFBSSxXQUFXLEVBQUU7QUFDZixjQUFJLENBQUMsV0FBVyxHQUFHLFdBQVcsR0FBRyxLQUFLLENBQUM7U0FDeEM7T0FDRjs7QUFFRCxTQUFHLEdBQ0QsR0FBRyxHQUNILEVBQUUsQ0FBQyxPQUFPLENBQUMsS0FBSyxDQUFDLEVBQUU7QUFDakIsWUFBSSxFQUFFLElBQUk7QUFDVixtQkFBVyxFQUFFLG1CQUNYLENBQUMsT0FBTyxDQUFDLEtBQUssQ0FBQyxFQUFFLEtBQUssQ0FBQyxFQUN2QixDQUFDLFdBQVcsR0FBRyxLQUFLLEVBQUUsSUFBSSxDQUFDLENBQzVCO09BQ0YsQ0FBQyxDQUFDO0tBQ047O0FBRUQsUUFBSSxPQUFPLElBQUksT0FBTyxPQUFPLEtBQUssUUFBUSxFQUFFO0FBQzFDLFVBQUksZUFBUSxPQUFPLENBQUMsRUFBRTtBQUNwQixhQUFLLElBQUksQ0FBQyxHQUFHLE9BQU8sQ0FBQyxNQUFNLEVBQUUsQ0FBQyxHQUFHLENBQUMsRUFBRSxDQUFDLEVBQUUsRUFBRTtBQUN2QyxjQUFJLENBQUMsSUFBSSxPQUFPLEVBQUU7QUFDaEIseUJBQWEsQ0FBQyxDQUFDLEVBQUUsQ0FBQyxFQUFFLENBQUMsS0FBSyxPQUFPLENBQUMsTUFBTSxHQUFHLENBQUMsQ0FBQyxDQUFDO1dBQy9DO1NBQ0Y7T0FDRixNQUFNLElBQUksTUFBTSxDQUFDLE1BQU0sSUFBSSxPQUFPLENBQUMsTUFBTSxDQUFDLE1BQU0sQ0FBQyxRQUFRLENBQUMsRUFBRTtBQUMzRCxZQUFNLFVBQVUsR0FBRyxFQUFFLENBQUM7QUFDdEIsWUFBTSxRQUFRLEdBQUcsT0FBTyxDQUFDLE1BQU0sQ0FBQyxNQUFNLENBQUMsUUFBUSxDQUFDLEVBQUUsQ0FBQztBQUNuRCxhQUFLLElBQUksRUFBRSxHQUFHLFFBQVEsQ0FBQyxJQUFJLEVBQUUsRUFBRSxDQUFDLEVBQUUsQ0FBQyxJQUFJLEVBQUUsRUFBRSxHQUFHLFFBQVEsQ0FBQyxJQUFJLEVBQUUsRUFBRTtBQUM3RCxvQkFBVSxDQUFDLElBQUksQ0FBQyxFQUFFLENBQUMsS0FBSyxDQUFDLENBQUM7U0FDM0I7QUFDRCxlQUFPLEdBQUcsVUFBVSxDQUFDO0FBQ3JCLGFBQUssSUFBSSxDQUFDLEdBQUcsT0FBTyxDQUFDLE1BQU0sRUFBRSxDQUFDLEdBQUcsQ0FBQyxFQUFFLENBQUMsRUFBRSxFQUFFO0FBQ3ZDLHVCQUFhLENBQUMsQ0FBQyxFQUFFLENBQUMsRUFBRSxDQUFDLEtBQUssT0FBTyxDQUFDLE1BQU0sR0FBRyxDQUFDLENBQUMsQ0FBQztTQUMvQztPQUNGLE1BQU07O0FBQ0wsY0FBSSxRQUFRLFlBQUEsQ0FBQzs7QUFFYixnQkFBTSxDQUFDLElBQUksQ0FBQyxPQUFPLENBQUMsQ0FBQyxPQUFPLENBQUMsVUFBQSxHQUFHLEVBQUk7Ozs7QUFJbEMsZ0JBQUksUUFBUSxLQUFLLFNBQVMsRUFBRTtBQUMxQiwyQkFBYSxDQUFDLFFBQVEsRUFBRSxDQUFDLEdBQUcsQ0FBQyxDQUFDLENBQUM7YUFDaEM7QUFDRCxvQkFBUSxHQUFHLEdBQUcsQ0FBQztBQUNmLGFBQUMsRUFBRSxDQUFDO1dBQ0wsQ0FBQyxDQUFDO0FBQ0gsY0FBSSxRQUFRLEtBQUssU0FBUyxFQUFFO0FBQzFCLHlCQUFhLENBQUMsUUFBUSxFQUFFLENBQUMsR0FBRyxDQUFDLEVBQUUsSUFBSSxDQUFDLENBQUM7V0FDdEM7O09BQ0Y7S0FDRjs7QUFFRCxRQUFJLENBQUMsS0FBSyxDQUFDLEVBQUU7QUFDWCxTQUFHLEdBQUcsT0FBTyxDQUFDLElBQUksQ0FBQyxDQUFDO0tBQ3JCOztBQUVELFdBQU8sR0FBRyxDQUFDO0dBQ1osQ0FBQyxDQUFDO0NBQ0oiLCJmaWxlIjoiZWFjaC5qcyIsInNvdXJjZXNDb250ZW50IjpbImltcG9ydCB7XG4gIGFwcGVuZENvbnRleHRQYXRoLFxuICBibG9ja1BhcmFtcyxcbiAgY3JlYXRlRnJhbWUsXG4gIGlzQXJyYXksXG4gIGlzRnVuY3Rpb25cbn0gZnJvbSAnLi4vdXRpbHMnO1xuaW1wb3J0IEV4Y2VwdGlvbiBmcm9tICcuLi9leGNlcHRpb24nO1xuXG5leHBvcnQgZGVmYXVsdCBmdW5jdGlvbihpbnN0YW5jZSkge1xuICBpbnN0YW5jZS5yZWdpc3RlckhlbHBlcignZWFjaCcsIGZ1bmN0aW9uKGNvbnRleHQsIG9wdGlvbnMpIHtcbiAgICBpZiAoIW9wdGlvbnMpIHtcbiAgICAgIHRocm93IG5ldyBFeGNlcHRpb24oJ011c3QgcGFzcyBpdGVyYXRvciB0byAjZWFjaCcpO1xuICAgIH1cblxuICAgIGxldCBmbiA9IG9wdGlvbnMuZm4sXG4gICAgICBpbnZlcnNlID0gb3B0aW9ucy5pbnZlcnNlLFxuICAgICAgaSA9IDAsXG4gICAgICByZXQgPSAnJyxcbiAgICAgIGRhdGEsXG4gICAgICBjb250ZXh0UGF0aDtcblxuICAgIGlmIChvcHRpb25zLmRhdGEgJiYgb3B0aW9ucy5pZHMpIHtcbiAgICAgIGNvbnRleHRQYXRoID1cbiAgICAgICAgYXBwZW5kQ29udGV4dFBhdGgob3B0aW9ucy5kYXRhLmNvbnRleHRQYXRoLCBvcHRpb25zLmlkc1swXSkgKyAnLic7XG4gICAgfVxuXG4gICAgaWYgKGlzRnVuY3Rpb24oY29udGV4dCkpIHtcbiAgICAgIGNvbnRleHQgPSBjb250ZXh0LmNhbGwodGhpcyk7XG4gICAgfVxuXG4gICAgaWYgKG9wdGlvbnMuZGF0YSkge1xuICAgICAgZGF0YSA9IGNyZWF0ZUZyYW1lKG9wdGlvbnMuZGF0YSk7XG4gICAgfVxuXG4gICAgZnVuY3Rpb24gZXhlY0l0ZXJhdGlvbihmaWVsZCwgaW5kZXgsIGxhc3QpIHtcbiAgICAgIGlmIChkYXRhKSB7XG4gICAgICAgIGRhdGEua2V5ID0gZmllbGQ7XG4gICAgICAgIGRhdGEuaW5kZXggPSBpbmRleDtcbiAgICAgICAgZGF0YS5maXJzdCA9IGluZGV4ID09PSAwO1xuICAgICAgICBkYXRhLmxhc3QgPSAhIWxhc3Q7XG5cbiAgICAgICAgaWYgKGNvbnRleHRQYXRoKSB7XG4gICAgICAgICAgZGF0YS5jb250ZXh0UGF0aCA9IGNvbnRleHRQYXRoICsgZmllbGQ7XG4gICAgICAgIH1cbiAgICAgIH1cblxuICAgICAgcmV0ID1cbiAgICAgICAgcmV0ICtcbiAgICAgICAgZm4oY29udGV4dFtmaWVsZF0sIHtcbiAgICAgICAgICBkYXRhOiBkYXRhLFxuICAgICAgICAgIGJsb2NrUGFyYW1zOiBibG9ja1BhcmFtcyhcbiAgICAgICAgICAgIFtjb250ZXh0W2ZpZWxkXSwgZmllbGRdLFxuICAgICAgICAgICAgW2NvbnRleHRQYXRoICsgZmllbGQsIG51bGxdXG4gICAgICAgICAgKVxuICAgICAgICB9KTtcbiAgICB9XG5cbiAgICBpZiAoY29udGV4dCAmJiB0eXBlb2YgY29udGV4dCA9PT0gJ29iamVjdCcpIHtcbiAgICAgIGlmIChpc0FycmF5KGNvbnRleHQpKSB7XG4gICAgICAgIGZvciAobGV0IGogPSBjb250ZXh0Lmxlbmd0aDsgaSA8IGo7IGkrKykge1xuICAgICAgICAgIGlmIChpIGluIGNvbnRleHQpIHtcbiAgICAgICAgICAgIGV4ZWNJdGVyYXRpb24oaSwgaSwgaSA9PT0gY29udGV4dC5sZW5ndGggLSAxKTtcbiAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgIH0gZWxzZSBpZiAoZ2xvYmFsLlN5bWJvbCAmJiBjb250ZXh0W2dsb2JhbC5TeW1ib2wuaXRlcmF0b3JdKSB7XG4gICAgICAgIGNvbnN0IG5ld0NvbnRleHQgPSBbXTtcbiAgICAgICAgY29uc3QgaXRlcmF0b3IgPSBjb250ZXh0W2dsb2JhbC5TeW1ib2wuaXRlcmF0b3JdKCk7XG4gICAgICAgIGZvciAobGV0IGl0ID0gaXRlcmF0b3IubmV4dCgpOyAhaXQuZG9uZTsgaXQgPSBpdGVyYXRvci5uZXh0KCkpIHtcbiAgICAgICAgICBuZXdDb250ZXh0LnB1c2goaXQudmFsdWUpO1xuICAgICAgICB9XG4gICAgICAgIGNvbnRleHQgPSBuZXdDb250ZXh0O1xuICAgICAgICBmb3IgKGxldCBqID0gY29udGV4dC5sZW5ndGg7IGkgPCBqOyBpKyspIHtcbiAgICAgICAgICBleGVjSXRlcmF0aW9uKGksIGksIGkgPT09IGNvbnRleHQubGVuZ3RoIC0gMSk7XG4gICAgICAgIH1cbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIGxldCBwcmlvcktleTtcblxuICAgICAgICBPYmplY3Qua2V5cyhjb250ZXh0KS5mb3JFYWNoKGtleSA9PiB7XG4gICAgICAgICAgLy8gV2UncmUgcnVubmluZyB0aGUgaXRlcmF0aW9ucyBvbmUgc3RlcCBvdXQgb2Ygc3luYyBzbyB3ZSBjYW4gZGV0ZWN0XG4gICAgICAgICAgLy8gdGhlIGxhc3QgaXRlcmF0aW9uIHdpdGhvdXQgaGF2ZSB0byBzY2FuIHRoZSBvYmplY3QgdHdpY2UgYW5kIGNyZWF0ZVxuICAgICAgICAgIC8vIGFuIGl0ZXJtZWRpYXRlIGtleXMgYXJyYXkuXG4gICAgICAgICAgaWYgKHByaW9yS2V5ICE9PSB1bmRlZmluZWQpIHtcbiAgICAgICAgICAgIGV4ZWNJdGVyYXRpb24ocHJpb3JLZXksIGkgLSAxKTtcbiAgICAgICAgICB9XG4gICAgICAgICAgcHJpb3JLZXkgPSBrZXk7XG4gICAgICAgICAgaSsrO1xuICAgICAgICB9KTtcbiAgICAgICAgaWYgKHByaW9yS2V5ICE9PSB1bmRlZmluZWQpIHtcbiAgICAgICAgICBleGVjSXRlcmF0aW9uKHByaW9yS2V5LCBpIC0gMSwgdHJ1ZSk7XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICB9XG5cbiAgICBpZiAoaSA9PT0gMCkge1xuICAgICAgcmV0ID0gaW52ZXJzZSh0aGlzKTtcbiAgICB9XG5cbiAgICByZXR1cm4gcmV0O1xuICB9KTtcbn1cbiJdfQ==

/* WEBPACK VAR INJECTION */}.call(this, __webpack_require__(55)))

/***/ }),
/* 366 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;
// istanbul ignore next

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

var _exception = __webpack_require__(45);

var _exception2 = _interopRequireDefault(_exception);

exports['default'] = function (instance) {
  instance.registerHelper('helperMissing', function () /* [args, ]options */{
    if (arguments.length === 1) {
      // A missing field in a {{foo}} construct.
      return undefined;
    } else {
      // Someone is actually trying to call something, blow up.
      throw new _exception2['default']('Missing helper: "' + arguments[arguments.length - 1].name + '"');
    }
  });
};

module.exports = exports['default'];
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL2hlbHBlcnMvaGVscGVyLW1pc3NpbmcuanMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozt5QkFBc0IsY0FBYzs7OztxQkFFckIsVUFBUyxRQUFRLEVBQUU7QUFDaEMsVUFBUSxDQUFDLGNBQWMsQ0FBQyxlQUFlLEVBQUUsaUNBQWdDO0FBQ3ZFLFFBQUksU0FBUyxDQUFDLE1BQU0sS0FBSyxDQUFDLEVBQUU7O0FBRTFCLGFBQU8sU0FBUyxDQUFDO0tBQ2xCLE1BQU07O0FBRUwsWUFBTSwyQkFDSixtQkFBbUIsR0FBRyxTQUFTLENBQUMsU0FBUyxDQUFDLE1BQU0sR0FBRyxDQUFDLENBQUMsQ0FBQyxJQUFJLEdBQUcsR0FBRyxDQUNqRSxDQUFDO0tBQ0g7R0FDRixDQUFDLENBQUM7Q0FDSiIsImZpbGUiOiJoZWxwZXItbWlzc2luZy5qcyIsInNvdXJjZXNDb250ZW50IjpbImltcG9ydCBFeGNlcHRpb24gZnJvbSAnLi4vZXhjZXB0aW9uJztcblxuZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24oaW5zdGFuY2UpIHtcbiAgaW5zdGFuY2UucmVnaXN0ZXJIZWxwZXIoJ2hlbHBlck1pc3NpbmcnLCBmdW5jdGlvbigvKiBbYXJncywgXW9wdGlvbnMgKi8pIHtcbiAgICBpZiAoYXJndW1lbnRzLmxlbmd0aCA9PT0gMSkge1xuICAgICAgLy8gQSBtaXNzaW5nIGZpZWxkIGluIGEge3tmb299fSBjb25zdHJ1Y3QuXG4gICAgICByZXR1cm4gdW5kZWZpbmVkO1xuICAgIH0gZWxzZSB7XG4gICAgICAvLyBTb21lb25lIGlzIGFjdHVhbGx5IHRyeWluZyB0byBjYWxsIHNvbWV0aGluZywgYmxvdyB1cC5cbiAgICAgIHRocm93IG5ldyBFeGNlcHRpb24oXG4gICAgICAgICdNaXNzaW5nIGhlbHBlcjogXCInICsgYXJndW1lbnRzW2FyZ3VtZW50cy5sZW5ndGggLSAxXS5uYW1lICsgJ1wiJ1xuICAgICAgKTtcbiAgICB9XG4gIH0pO1xufVxuIl19


/***/ }),
/* 367 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;
// istanbul ignore next

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

var _utils = __webpack_require__(28);

var _exception = __webpack_require__(45);

var _exception2 = _interopRequireDefault(_exception);

exports['default'] = function (instance) {
  instance.registerHelper('if', function (conditional, options) {
    if (arguments.length != 2) {
      throw new _exception2['default']('#if requires exactly one argument');
    }
    if (_utils.isFunction(conditional)) {
      conditional = conditional.call(this);
    }

    // Default behavior is to render the positive path if the value is truthy and not empty.
    // The `includeZero` option may be set to treat the condtional as purely not empty based on the
    // behavior of isEmpty. Effectively this determines if 0 is handled by the positive path or negative.
    if (!options.hash.includeZero && !conditional || _utils.isEmpty(conditional)) {
      return options.inverse(this);
    } else {
      return options.fn(this);
    }
  });

  instance.registerHelper('unless', function (conditional, options) {
    if (arguments.length != 2) {
      throw new _exception2['default']('#unless requires exactly one argument');
    }
    return instance.helpers['if'].call(this, conditional, {
      fn: options.inverse,
      inverse: options.fn,
      hash: options.hash
    });
  });
};

module.exports = exports['default'];
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL2hlbHBlcnMvaWYuanMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7Ozs7OztxQkFBb0MsVUFBVTs7eUJBQ3hCLGNBQWM7Ozs7cUJBRXJCLFVBQVMsUUFBUSxFQUFFO0FBQ2hDLFVBQVEsQ0FBQyxjQUFjLENBQUMsSUFBSSxFQUFFLFVBQVMsV0FBVyxFQUFFLE9BQU8sRUFBRTtBQUMzRCxRQUFJLFNBQVMsQ0FBQyxNQUFNLElBQUksQ0FBQyxFQUFFO0FBQ3pCLFlBQU0sMkJBQWMsbUNBQW1DLENBQUMsQ0FBQztLQUMxRDtBQUNELFFBQUksa0JBQVcsV0FBVyxDQUFDLEVBQUU7QUFDM0IsaUJBQVcsR0FBRyxXQUFXLENBQUMsSUFBSSxDQUFDLElBQUksQ0FBQyxDQUFDO0tBQ3RDOzs7OztBQUtELFFBQUksQUFBQyxDQUFDLE9BQU8sQ0FBQyxJQUFJLENBQUMsV0FBVyxJQUFJLENBQUMsV0FBVyxJQUFLLGVBQVEsV0FBVyxDQUFDLEVBQUU7QUFDdkUsYUFBTyxPQUFPLENBQUMsT0FBTyxDQUFDLElBQUksQ0FBQyxDQUFDO0tBQzlCLE1BQU07QUFDTCxhQUFPLE9BQU8sQ0FBQyxFQUFFLENBQUMsSUFBSSxDQUFDLENBQUM7S0FDekI7R0FDRixDQUFDLENBQUM7O0FBRUgsVUFBUSxDQUFDLGNBQWMsQ0FBQyxRQUFRLEVBQUUsVUFBUyxXQUFXLEVBQUUsT0FBTyxFQUFFO0FBQy9ELFFBQUksU0FBUyxDQUFDLE1BQU0sSUFBSSxDQUFDLEVBQUU7QUFDekIsWUFBTSwyQkFBYyx1Q0FBdUMsQ0FBQyxDQUFDO0tBQzlEO0FBQ0QsV0FBTyxRQUFRLENBQUMsT0FBTyxDQUFDLElBQUksQ0FBQyxDQUFDLElBQUksQ0FBQyxJQUFJLEVBQUUsV0FBVyxFQUFFO0FBQ3BELFFBQUUsRUFBRSxPQUFPLENBQUMsT0FBTztBQUNuQixhQUFPLEVBQUUsT0FBTyxDQUFDLEVBQUU7QUFDbkIsVUFBSSxFQUFFLE9BQU8sQ0FBQyxJQUFJO0tBQ25CLENBQUMsQ0FBQztHQUNKLENBQUMsQ0FBQztDQUNKIiwiZmlsZSI6ImlmLmpzIiwic291cmNlc0NvbnRlbnQiOlsiaW1wb3J0IHsgaXNFbXB0eSwgaXNGdW5jdGlvbiB9IGZyb20gJy4uL3V0aWxzJztcbmltcG9ydCBFeGNlcHRpb24gZnJvbSAnLi4vZXhjZXB0aW9uJztcblxuZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24oaW5zdGFuY2UpIHtcbiAgaW5zdGFuY2UucmVnaXN0ZXJIZWxwZXIoJ2lmJywgZnVuY3Rpb24oY29uZGl0aW9uYWwsIG9wdGlvbnMpIHtcbiAgICBpZiAoYXJndW1lbnRzLmxlbmd0aCAhPSAyKSB7XG4gICAgICB0aHJvdyBuZXcgRXhjZXB0aW9uKCcjaWYgcmVxdWlyZXMgZXhhY3RseSBvbmUgYXJndW1lbnQnKTtcbiAgICB9XG4gICAgaWYgKGlzRnVuY3Rpb24oY29uZGl0aW9uYWwpKSB7XG4gICAgICBjb25kaXRpb25hbCA9IGNvbmRpdGlvbmFsLmNhbGwodGhpcyk7XG4gICAgfVxuXG4gICAgLy8gRGVmYXVsdCBiZWhhdmlvciBpcyB0byByZW5kZXIgdGhlIHBvc2l0aXZlIHBhdGggaWYgdGhlIHZhbHVlIGlzIHRydXRoeSBhbmQgbm90IGVtcHR5LlxuICAgIC8vIFRoZSBgaW5jbHVkZVplcm9gIG9wdGlvbiBtYXkgYmUgc2V0IHRvIHRyZWF0IHRoZSBjb25kdGlvbmFsIGFzIHB1cmVseSBub3QgZW1wdHkgYmFzZWQgb24gdGhlXG4gICAgLy8gYmVoYXZpb3Igb2YgaXNFbXB0eS4gRWZmZWN0aXZlbHkgdGhpcyBkZXRlcm1pbmVzIGlmIDAgaXMgaGFuZGxlZCBieSB0aGUgcG9zaXRpdmUgcGF0aCBvciBuZWdhdGl2ZS5cbiAgICBpZiAoKCFvcHRpb25zLmhhc2guaW5jbHVkZVplcm8gJiYgIWNvbmRpdGlvbmFsKSB8fCBpc0VtcHR5KGNvbmRpdGlvbmFsKSkge1xuICAgICAgcmV0dXJuIG9wdGlvbnMuaW52ZXJzZSh0aGlzKTtcbiAgICB9IGVsc2Uge1xuICAgICAgcmV0dXJuIG9wdGlvbnMuZm4odGhpcyk7XG4gICAgfVxuICB9KTtcblxuICBpbnN0YW5jZS5yZWdpc3RlckhlbHBlcigndW5sZXNzJywgZnVuY3Rpb24oY29uZGl0aW9uYWwsIG9wdGlvbnMpIHtcbiAgICBpZiAoYXJndW1lbnRzLmxlbmd0aCAhPSAyKSB7XG4gICAgICB0aHJvdyBuZXcgRXhjZXB0aW9uKCcjdW5sZXNzIHJlcXVpcmVzIGV4YWN0bHkgb25lIGFyZ3VtZW50Jyk7XG4gICAgfVxuICAgIHJldHVybiBpbnN0YW5jZS5oZWxwZXJzWydpZiddLmNhbGwodGhpcywgY29uZGl0aW9uYWwsIHtcbiAgICAgIGZuOiBvcHRpb25zLmludmVyc2UsXG4gICAgICBpbnZlcnNlOiBvcHRpb25zLmZuLFxuICAgICAgaGFzaDogb3B0aW9ucy5oYXNoXG4gICAgfSk7XG4gIH0pO1xufVxuIl19


/***/ }),
/* 368 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;

exports['default'] = function (instance) {
  instance.registerHelper('log', function () /* message, options */{
    var args = [undefined],
        options = arguments[arguments.length - 1];
    for (var i = 0; i < arguments.length - 1; i++) {
      args.push(arguments[i]);
    }

    var level = 1;
    if (options.hash.level != null) {
      level = options.hash.level;
    } else if (options.data && options.data.level != null) {
      level = options.data.level;
    }
    args[0] = level;

    instance.log.apply(instance, args);
  });
};

module.exports = exports['default'];
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL2hlbHBlcnMvbG9nLmpzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7Ozs7cUJBQWUsVUFBUyxRQUFRLEVBQUU7QUFDaEMsVUFBUSxDQUFDLGNBQWMsQ0FBQyxLQUFLLEVBQUUsa0NBQWlDO0FBQzlELFFBQUksSUFBSSxHQUFHLENBQUMsU0FBUyxDQUFDO1FBQ3BCLE9BQU8sR0FBRyxTQUFTLENBQUMsU0FBUyxDQUFDLE1BQU0sR0FBRyxDQUFDLENBQUMsQ0FBQztBQUM1QyxTQUFLLElBQUksQ0FBQyxHQUFHLENBQUMsRUFBRSxDQUFDLEdBQUcsU0FBUyxDQUFDLE1BQU0sR0FBRyxDQUFDLEVBQUUsQ0FBQyxFQUFFLEVBQUU7QUFDN0MsVUFBSSxDQUFDLElBQUksQ0FBQyxTQUFTLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQztLQUN6Qjs7QUFFRCxRQUFJLEtBQUssR0FBRyxDQUFDLENBQUM7QUFDZCxRQUFJLE9BQU8sQ0FBQyxJQUFJLENBQUMsS0FBSyxJQUFJLElBQUksRUFBRTtBQUM5QixXQUFLLEdBQUcsT0FBTyxDQUFDLElBQUksQ0FBQyxLQUFLLENBQUM7S0FDNUIsTUFBTSxJQUFJLE9BQU8sQ0FBQyxJQUFJLElBQUksT0FBTyxDQUFDLElBQUksQ0FBQyxLQUFLLElBQUksSUFBSSxFQUFFO0FBQ3JELFdBQUssR0FBRyxPQUFPLENBQUMsSUFBSSxDQUFDLEtBQUssQ0FBQztLQUM1QjtBQUNELFFBQUksQ0FBQyxDQUFDLENBQUMsR0FBRyxLQUFLLENBQUM7O0FBRWhCLFlBQVEsQ0FBQyxHQUFHLE1BQUEsQ0FBWixRQUFRLEVBQVEsSUFBSSxDQUFDLENBQUM7R0FDdkIsQ0FBQyxDQUFDO0NBQ0oiLCJmaWxlIjoibG9nLmpzIiwic291cmNlc0NvbnRlbnQiOlsiZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24oaW5zdGFuY2UpIHtcbiAgaW5zdGFuY2UucmVnaXN0ZXJIZWxwZXIoJ2xvZycsIGZ1bmN0aW9uKC8qIG1lc3NhZ2UsIG9wdGlvbnMgKi8pIHtcbiAgICBsZXQgYXJncyA9IFt1bmRlZmluZWRdLFxuICAgICAgb3B0aW9ucyA9IGFyZ3VtZW50c1thcmd1bWVudHMubGVuZ3RoIC0gMV07XG4gICAgZm9yIChsZXQgaSA9IDA7IGkgPCBhcmd1bWVudHMubGVuZ3RoIC0gMTsgaSsrKSB7XG4gICAgICBhcmdzLnB1c2goYXJndW1lbnRzW2ldKTtcbiAgICB9XG5cbiAgICBsZXQgbGV2ZWwgPSAxO1xuICAgIGlmIChvcHRpb25zLmhhc2gubGV2ZWwgIT0gbnVsbCkge1xuICAgICAgbGV2ZWwgPSBvcHRpb25zLmhhc2gubGV2ZWw7XG4gICAgfSBlbHNlIGlmIChvcHRpb25zLmRhdGEgJiYgb3B0aW9ucy5kYXRhLmxldmVsICE9IG51bGwpIHtcbiAgICAgIGxldmVsID0gb3B0aW9ucy5kYXRhLmxldmVsO1xuICAgIH1cbiAgICBhcmdzWzBdID0gbGV2ZWw7XG5cbiAgICBpbnN0YW5jZS5sb2coLi4uYXJncyk7XG4gIH0pO1xufVxuIl19


/***/ }),
/* 369 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;

exports['default'] = function (instance) {
  instance.registerHelper('lookup', function (obj, field, options) {
    if (!obj) {
      // Note for 5.0: Change to "obj == null" in 5.0
      return obj;
    }
    return options.lookupProperty(obj, field);
  });
};

module.exports = exports['default'];
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL2hlbHBlcnMvbG9va3VwLmpzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7Ozs7cUJBQWUsVUFBUyxRQUFRLEVBQUU7QUFDaEMsVUFBUSxDQUFDLGNBQWMsQ0FBQyxRQUFRLEVBQUUsVUFBUyxHQUFHLEVBQUUsS0FBSyxFQUFFLE9BQU8sRUFBRTtBQUM5RCxRQUFJLENBQUMsR0FBRyxFQUFFOztBQUVSLGFBQU8sR0FBRyxDQUFDO0tBQ1o7QUFDRCxXQUFPLE9BQU8sQ0FBQyxjQUFjLENBQUMsR0FBRyxFQUFFLEtBQUssQ0FBQyxDQUFDO0dBQzNDLENBQUMsQ0FBQztDQUNKIiwiZmlsZSI6Imxvb2t1cC5qcyIsInNvdXJjZXNDb250ZW50IjpbImV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uKGluc3RhbmNlKSB7XG4gIGluc3RhbmNlLnJlZ2lzdGVySGVscGVyKCdsb29rdXAnLCBmdW5jdGlvbihvYmosIGZpZWxkLCBvcHRpb25zKSB7XG4gICAgaWYgKCFvYmopIHtcbiAgICAgIC8vIE5vdGUgZm9yIDUuMDogQ2hhbmdlIHRvIFwib2JqID09IG51bGxcIiBpbiA1LjBcbiAgICAgIHJldHVybiBvYmo7XG4gICAgfVxuICAgIHJldHVybiBvcHRpb25zLmxvb2t1cFByb3BlcnR5KG9iaiwgZmllbGQpO1xuICB9KTtcbn1cbiJdfQ==


/***/ }),
/* 370 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;
// istanbul ignore next

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

var _utils = __webpack_require__(28);

var _exception = __webpack_require__(45);

var _exception2 = _interopRequireDefault(_exception);

exports['default'] = function (instance) {
  instance.registerHelper('with', function (context, options) {
    if (arguments.length != 2) {
      throw new _exception2['default']('#with requires exactly one argument');
    }
    if (_utils.isFunction(context)) {
      context = context.call(this);
    }

    var fn = options.fn;

    if (!_utils.isEmpty(context)) {
      var data = options.data;
      if (options.data && options.ids) {
        data = _utils.createFrame(options.data);
        data.contextPath = _utils.appendContextPath(options.data.contextPath, options.ids[0]);
      }

      return fn(context, {
        data: data,
        blockParams: _utils.blockParams([context], [data && data.contextPath])
      });
    } else {
      return options.inverse(this);
    }
  });
};

module.exports = exports['default'];
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL2hlbHBlcnMvd2l0aC5qcyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOzs7Ozs7O3FCQU1PLFVBQVU7O3lCQUNLLGNBQWM7Ozs7cUJBRXJCLFVBQVMsUUFBUSxFQUFFO0FBQ2hDLFVBQVEsQ0FBQyxjQUFjLENBQUMsTUFBTSxFQUFFLFVBQVMsT0FBTyxFQUFFLE9BQU8sRUFBRTtBQUN6RCxRQUFJLFNBQVMsQ0FBQyxNQUFNLElBQUksQ0FBQyxFQUFFO0FBQ3pCLFlBQU0sMkJBQWMscUNBQXFDLENBQUMsQ0FBQztLQUM1RDtBQUNELFFBQUksa0JBQVcsT0FBTyxDQUFDLEVBQUU7QUFDdkIsYUFBTyxHQUFHLE9BQU8sQ0FBQyxJQUFJLENBQUMsSUFBSSxDQUFDLENBQUM7S0FDOUI7O0FBRUQsUUFBSSxFQUFFLEdBQUcsT0FBTyxDQUFDLEVBQUUsQ0FBQzs7QUFFcEIsUUFBSSxDQUFDLGVBQVEsT0FBTyxDQUFDLEVBQUU7QUFDckIsVUFBSSxJQUFJLEdBQUcsT0FBTyxDQUFDLElBQUksQ0FBQztBQUN4QixVQUFJLE9BQU8sQ0FBQyxJQUFJLElBQUksT0FBTyxDQUFDLEdBQUcsRUFBRTtBQUMvQixZQUFJLEdBQUcsbUJBQVksT0FBTyxDQUFDLElBQUksQ0FBQyxDQUFDO0FBQ2pDLFlBQUksQ0FBQyxXQUFXLEdBQUcseUJBQ2pCLE9BQU8sQ0FBQyxJQUFJLENBQUMsV0FBVyxFQUN4QixPQUFPLENBQUMsR0FBRyxDQUFDLENBQUMsQ0FBQyxDQUNmLENBQUM7T0FDSDs7QUFFRCxhQUFPLEVBQUUsQ0FBQyxPQUFPLEVBQUU7QUFDakIsWUFBSSxFQUFFLElBQUk7QUFDVixtQkFBVyxFQUFFLG1CQUFZLENBQUMsT0FBTyxDQUFDLEVBQUUsQ0FBQyxJQUFJLElBQUksSUFBSSxDQUFDLFdBQVcsQ0FBQyxDQUFDO09BQ2hFLENBQUMsQ0FBQztLQUNKLE1BQU07QUFDTCxhQUFPLE9BQU8sQ0FBQyxPQUFPLENBQUMsSUFBSSxDQUFDLENBQUM7S0FDOUI7R0FDRixDQUFDLENBQUM7Q0FDSiIsImZpbGUiOiJ3aXRoLmpzIiwic291cmNlc0NvbnRlbnQiOlsiaW1wb3J0IHtcbiAgYXBwZW5kQ29udGV4dFBhdGgsXG4gIGJsb2NrUGFyYW1zLFxuICBjcmVhdGVGcmFtZSxcbiAgaXNFbXB0eSxcbiAgaXNGdW5jdGlvblxufSBmcm9tICcuLi91dGlscyc7XG5pbXBvcnQgRXhjZXB0aW9uIGZyb20gJy4uL2V4Y2VwdGlvbic7XG5cbmV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uKGluc3RhbmNlKSB7XG4gIGluc3RhbmNlLnJlZ2lzdGVySGVscGVyKCd3aXRoJywgZnVuY3Rpb24oY29udGV4dCwgb3B0aW9ucykge1xuICAgIGlmIChhcmd1bWVudHMubGVuZ3RoICE9IDIpIHtcbiAgICAgIHRocm93IG5ldyBFeGNlcHRpb24oJyN3aXRoIHJlcXVpcmVzIGV4YWN0bHkgb25lIGFyZ3VtZW50Jyk7XG4gICAgfVxuICAgIGlmIChpc0Z1bmN0aW9uKGNvbnRleHQpKSB7XG4gICAgICBjb250ZXh0ID0gY29udGV4dC5jYWxsKHRoaXMpO1xuICAgIH1cblxuICAgIGxldCBmbiA9IG9wdGlvbnMuZm47XG5cbiAgICBpZiAoIWlzRW1wdHkoY29udGV4dCkpIHtcbiAgICAgIGxldCBkYXRhID0gb3B0aW9ucy5kYXRhO1xuICAgICAgaWYgKG9wdGlvbnMuZGF0YSAmJiBvcHRpb25zLmlkcykge1xuICAgICAgICBkYXRhID0gY3JlYXRlRnJhbWUob3B0aW9ucy5kYXRhKTtcbiAgICAgICAgZGF0YS5jb250ZXh0UGF0aCA9IGFwcGVuZENvbnRleHRQYXRoKFxuICAgICAgICAgIG9wdGlvbnMuZGF0YS5jb250ZXh0UGF0aCxcbiAgICAgICAgICBvcHRpb25zLmlkc1swXVxuICAgICAgICApO1xuICAgICAgfVxuXG4gICAgICByZXR1cm4gZm4oY29udGV4dCwge1xuICAgICAgICBkYXRhOiBkYXRhLFxuICAgICAgICBibG9ja1BhcmFtczogYmxvY2tQYXJhbXMoW2NvbnRleHRdLCBbZGF0YSAmJiBkYXRhLmNvbnRleHRQYXRoXSlcbiAgICAgIH0pO1xuICAgIH0gZWxzZSB7XG4gICAgICByZXR1cm4gb3B0aW9ucy5pbnZlcnNlKHRoaXMpO1xuICAgIH1cbiAgfSk7XG59XG4iXX0=


/***/ }),
/* 371 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;
exports.registerDefaultDecorators = registerDefaultDecorators;
// istanbul ignore next

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

var _decoratorsInline = __webpack_require__(372);

var _decoratorsInline2 = _interopRequireDefault(_decoratorsInline);

function registerDefaultDecorators(instance) {
  _decoratorsInline2['default'](instance);
}
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL2RlY29yYXRvcnMuanMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Z0NBQTJCLHFCQUFxQjs7OztBQUV6QyxTQUFTLHlCQUF5QixDQUFDLFFBQVEsRUFBRTtBQUNsRCxnQ0FBZSxRQUFRLENBQUMsQ0FBQztDQUMxQiIsImZpbGUiOiJkZWNvcmF0b3JzLmpzIiwic291cmNlc0NvbnRlbnQiOlsiaW1wb3J0IHJlZ2lzdGVySW5saW5lIGZyb20gJy4vZGVjb3JhdG9ycy9pbmxpbmUnO1xuXG5leHBvcnQgZnVuY3Rpb24gcmVnaXN0ZXJEZWZhdWx0RGVjb3JhdG9ycyhpbnN0YW5jZSkge1xuICByZWdpc3RlcklubGluZShpbnN0YW5jZSk7XG59XG4iXX0=


/***/ }),
/* 372 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;

var _utils = __webpack_require__(28);

exports['default'] = function (instance) {
  instance.registerDecorator('inline', function (fn, props, container, options) {
    var ret = fn;
    if (!props.partials) {
      props.partials = {};
      ret = function (context, options) {
        // Create a new partials stack frame prior to exec.
        var original = container.partials;
        container.partials = _utils.extend({}, original, props.partials);
        var ret = fn(context, options);
        container.partials = original;
        return ret;
      };
    }

    props.partials[options.args[0]] = options.fn;

    return ret;
  });
};

module.exports = exports['default'];
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL2RlY29yYXRvcnMvaW5saW5lLmpzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7Ozs7cUJBQXVCLFVBQVU7O3FCQUVsQixVQUFTLFFBQVEsRUFBRTtBQUNoQyxVQUFRLENBQUMsaUJBQWlCLENBQUMsUUFBUSxFQUFFLFVBQVMsRUFBRSxFQUFFLEtBQUssRUFBRSxTQUFTLEVBQUUsT0FBTyxFQUFFO0FBQzNFLFFBQUksR0FBRyxHQUFHLEVBQUUsQ0FBQztBQUNiLFFBQUksQ0FBQyxLQUFLLENBQUMsUUFBUSxFQUFFO0FBQ25CLFdBQUssQ0FBQyxRQUFRLEdBQUcsRUFBRSxDQUFDO0FBQ3BCLFNBQUcsR0FBRyxVQUFTLE9BQU8sRUFBRSxPQUFPLEVBQUU7O0FBRS9CLFlBQUksUUFBUSxHQUFHLFNBQVMsQ0FBQyxRQUFRLENBQUM7QUFDbEMsaUJBQVMsQ0FBQyxRQUFRLEdBQUcsY0FBTyxFQUFFLEVBQUUsUUFBUSxFQUFFLEtBQUssQ0FBQyxRQUFRLENBQUMsQ0FBQztBQUMxRCxZQUFJLEdBQUcsR0FBRyxFQUFFLENBQUMsT0FBTyxFQUFFLE9BQU8sQ0FBQyxDQUFDO0FBQy9CLGlCQUFTLENBQUMsUUFBUSxHQUFHLFFBQVEsQ0FBQztBQUM5QixlQUFPLEdBQUcsQ0FBQztPQUNaLENBQUM7S0FDSDs7QUFFRCxTQUFLLENBQUMsUUFBUSxDQUFDLE9BQU8sQ0FBQyxJQUFJLENBQUMsQ0FBQyxDQUFDLENBQUMsR0FBRyxPQUFPLENBQUMsRUFBRSxDQUFDOztBQUU3QyxXQUFPLEdBQUcsQ0FBQztHQUNaLENBQUMsQ0FBQztDQUNKIiwiZmlsZSI6ImlubGluZS5qcyIsInNvdXJjZXNDb250ZW50IjpbImltcG9ydCB7IGV4dGVuZCB9IGZyb20gJy4uL3V0aWxzJztcblxuZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24oaW5zdGFuY2UpIHtcbiAgaW5zdGFuY2UucmVnaXN0ZXJEZWNvcmF0b3IoJ2lubGluZScsIGZ1bmN0aW9uKGZuLCBwcm9wcywgY29udGFpbmVyLCBvcHRpb25zKSB7XG4gICAgbGV0IHJldCA9IGZuO1xuICAgIGlmICghcHJvcHMucGFydGlhbHMpIHtcbiAgICAgIHByb3BzLnBhcnRpYWxzID0ge307XG4gICAgICByZXQgPSBmdW5jdGlvbihjb250ZXh0LCBvcHRpb25zKSB7XG4gICAgICAgIC8vIENyZWF0ZSBhIG5ldyBwYXJ0aWFscyBzdGFjayBmcmFtZSBwcmlvciB0byBleGVjLlxuICAgICAgICBsZXQgb3JpZ2luYWwgPSBjb250YWluZXIucGFydGlhbHM7XG4gICAgICAgIGNvbnRhaW5lci5wYXJ0aWFscyA9IGV4dGVuZCh7fSwgb3JpZ2luYWwsIHByb3BzLnBhcnRpYWxzKTtcbiAgICAgICAgbGV0IHJldCA9IGZuKGNvbnRleHQsIG9wdGlvbnMpO1xuICAgICAgICBjb250YWluZXIucGFydGlhbHMgPSBvcmlnaW5hbDtcbiAgICAgICAgcmV0dXJuIHJldDtcbiAgICAgIH07XG4gICAgfVxuXG4gICAgcHJvcHMucGFydGlhbHNbb3B0aW9ucy5hcmdzWzBdXSA9IG9wdGlvbnMuZm47XG5cbiAgICByZXR1cm4gcmV0O1xuICB9KTtcbn1cbiJdfQ==


/***/ }),
/* 373 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;
exports.createNewLookupObject = createNewLookupObject;

var _utils = __webpack_require__(28);

/**
 * Create a new object with "null"-prototype to avoid truthy results on prototype properties.
 * The resulting object can be used with "object[property]" to check if a property exists
 * @param {...object} sources a varargs parameter of source objects that will be merged
 * @returns {object}
 */

function createNewLookupObject() {
  for (var _len = arguments.length, sources = Array(_len), _key = 0; _key < _len; _key++) {
    sources[_key] = arguments[_key];
  }

  return _utils.extend.apply(undefined, [Object.create(null)].concat(sources));
}
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL2ludGVybmFsL2NyZWF0ZS1uZXctbG9va3VwLW9iamVjdC5qcyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOzs7OztxQkFBdUIsVUFBVTs7Ozs7Ozs7O0FBUTFCLFNBQVMscUJBQXFCLEdBQWE7b0NBQVQsT0FBTztBQUFQLFdBQU87OztBQUM5QyxTQUFPLGdDQUFPLE1BQU0sQ0FBQyxNQUFNLENBQUMsSUFBSSxDQUFDLFNBQUssT0FBTyxFQUFDLENBQUM7Q0FDaEQiLCJmaWxlIjoiY3JlYXRlLW5ldy1sb29rdXAtb2JqZWN0LmpzIiwic291cmNlc0NvbnRlbnQiOlsiaW1wb3J0IHsgZXh0ZW5kIH0gZnJvbSAnLi4vdXRpbHMnO1xuXG4vKipcbiAqIENyZWF0ZSBhIG5ldyBvYmplY3Qgd2l0aCBcIm51bGxcIi1wcm90b3R5cGUgdG8gYXZvaWQgdHJ1dGh5IHJlc3VsdHMgb24gcHJvdG90eXBlIHByb3BlcnRpZXMuXG4gKiBUaGUgcmVzdWx0aW5nIG9iamVjdCBjYW4gYmUgdXNlZCB3aXRoIFwib2JqZWN0W3Byb3BlcnR5XVwiIHRvIGNoZWNrIGlmIGEgcHJvcGVydHkgZXhpc3RzXG4gKiBAcGFyYW0gey4uLm9iamVjdH0gc291cmNlcyBhIHZhcmFyZ3MgcGFyYW1ldGVyIG9mIHNvdXJjZSBvYmplY3RzIHRoYXQgd2lsbCBiZSBtZXJnZWRcbiAqIEByZXR1cm5zIHtvYmplY3R9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBjcmVhdGVOZXdMb29rdXBPYmplY3QoLi4uc291cmNlcykge1xuICByZXR1cm4gZXh0ZW5kKE9iamVjdC5jcmVhdGUobnVsbCksIC4uLnNvdXJjZXMpO1xufVxuIl19


/***/ }),
/* 374 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
// Build out our basic SafeString type


exports.__esModule = true;
function SafeString(string) {
  this.string = string;
}

SafeString.prototype.toString = SafeString.prototype.toHTML = function () {
  return '' + this.string;
};

exports['default'] = SafeString;
module.exports = exports['default'];
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL3NhZmUtc3RyaW5nLmpzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7Ozs7QUFDQSxTQUFTLFVBQVUsQ0FBQyxNQUFNLEVBQUU7QUFDMUIsTUFBSSxDQUFDLE1BQU0sR0FBRyxNQUFNLENBQUM7Q0FDdEI7O0FBRUQsVUFBVSxDQUFDLFNBQVMsQ0FBQyxRQUFRLEdBQUcsVUFBVSxDQUFDLFNBQVMsQ0FBQyxNQUFNLEdBQUcsWUFBVztBQUN2RSxTQUFPLEVBQUUsR0FBRyxJQUFJLENBQUMsTUFBTSxDQUFDO0NBQ3pCLENBQUM7O3FCQUVhLFVBQVUiLCJmaWxlIjoic2FmZS1zdHJpbmcuanMiLCJzb3VyY2VzQ29udGVudCI6WyIvLyBCdWlsZCBvdXQgb3VyIGJhc2ljIFNhZmVTdHJpbmcgdHlwZVxuZnVuY3Rpb24gU2FmZVN0cmluZyhzdHJpbmcpIHtcbiAgdGhpcy5zdHJpbmcgPSBzdHJpbmc7XG59XG5cblNhZmVTdHJpbmcucHJvdG90eXBlLnRvU3RyaW5nID0gU2FmZVN0cmluZy5wcm90b3R5cGUudG9IVE1MID0gZnVuY3Rpb24oKSB7XG4gIHJldHVybiAnJyArIHRoaXMuc3RyaW5nO1xufTtcblxuZXhwb3J0IGRlZmF1bHQgU2FmZVN0cmluZztcbiJdfQ==


/***/ }),
/* 375 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;
exports.checkRevision = checkRevision;
exports.template = template;
exports.wrapProgram = wrapProgram;
exports.resolvePartial = resolvePartial;
exports.invokePartial = invokePartial;
exports.noop = noop;
// istanbul ignore next

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

// istanbul ignore next

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } else { var newObj = {}; if (obj != null) { for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) newObj[key] = obj[key]; } } newObj['default'] = obj; return newObj; } }

var _utils = __webpack_require__(28);

var Utils = _interopRequireWildcard(_utils);

var _exception = __webpack_require__(45);

var _exception2 = _interopRequireDefault(_exception);

var _base = __webpack_require__(134);

var _helpers = __webpack_require__(135);

var _internalWrapHelper = __webpack_require__(376);

var _internalProtoAccess = __webpack_require__(137);

function checkRevision(compilerInfo) {
  var compilerRevision = compilerInfo && compilerInfo[0] || 1,
      currentRevision = _base.COMPILER_REVISION;

  if (compilerRevision >= _base.LAST_COMPATIBLE_COMPILER_REVISION && compilerRevision <= _base.COMPILER_REVISION) {
    return;
  }

  if (compilerRevision < _base.LAST_COMPATIBLE_COMPILER_REVISION) {
    var runtimeVersions = _base.REVISION_CHANGES[currentRevision],
        compilerVersions = _base.REVISION_CHANGES[compilerRevision];
    throw new _exception2['default']('Template was precompiled with an older version of Handlebars than the current runtime. ' + 'Please update your precompiler to a newer version (' + runtimeVersions + ') or downgrade your runtime to an older version (' + compilerVersions + ').');
  } else {
    // Use the embedded version info since the runtime doesn't know about this revision yet
    throw new _exception2['default']('Template was precompiled with a newer version of Handlebars than the current runtime. ' + 'Please update your runtime to a newer version (' + compilerInfo[1] + ').');
  }
}

function template(templateSpec, env) {
  /* istanbul ignore next */
  if (!env) {
    throw new _exception2['default']('No environment passed to template');
  }
  if (!templateSpec || !templateSpec.main) {
    throw new _exception2['default']('Unknown template object: ' + typeof templateSpec);
  }

  templateSpec.main.decorator = templateSpec.main_d;

  // Note: Using env.VM references rather than local var references throughout this section to allow
  // for external users to override these as pseudo-supported APIs.
  env.VM.checkRevision(templateSpec.compiler);

  // backwards compatibility for precompiled templates with compiler-version 7 (<4.3.0)
  var templateWasPrecompiledWithCompilerV7 = templateSpec.compiler && templateSpec.compiler[0] === 7;

  function invokePartialWrapper(partial, context, options) {
    if (options.hash) {
      context = Utils.extend({}, context, options.hash);
      if (options.ids) {
        options.ids[0] = true;
      }
    }
    partial = env.VM.resolvePartial.call(this, partial, context, options);

    var extendedOptions = Utils.extend({}, options, {
      hooks: this.hooks,
      protoAccessControl: this.protoAccessControl
    });

    var result = env.VM.invokePartial.call(this, partial, context, extendedOptions);

    if (result == null && env.compile) {
      options.partials[options.name] = env.compile(partial, templateSpec.compilerOptions, env);
      result = options.partials[options.name](context, extendedOptions);
    }
    if (result != null) {
      if (options.indent) {
        var lines = result.split('\n');
        for (var i = 0, l = lines.length; i < l; i++) {
          if (!lines[i] && i + 1 === l) {
            break;
          }

          lines[i] = options.indent + lines[i];
        }
        result = lines.join('\n');
      }
      return result;
    } else {
      throw new _exception2['default']('The partial ' + options.name + ' could not be compiled when running in runtime-only mode');
    }
  }

  // Just add water
  var container = {
    strict: function strict(obj, name, loc) {
      if (!obj || !(name in obj)) {
        throw new _exception2['default']('"' + name + '" not defined in ' + obj, {
          loc: loc
        });
      }
      return obj[name];
    },
    lookupProperty: function lookupProperty(parent, propertyName) {
      var result = parent[propertyName];
      if (result == null) {
        return result;
      }
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return result;
      }

      if (_internalProtoAccess.resultIsAllowed(result, container.protoAccessControl, propertyName)) {
        return result;
      }
      return undefined;
    },
    lookup: function lookup(depths, name) {
      var len = depths.length;
      for (var i = 0; i < len; i++) {
        var result = depths[i] && container.lookupProperty(depths[i], name);
        if (result != null) {
          return depths[i][name];
        }
      }
    },
    lambda: function lambda(current, context) {
      return typeof current === 'function' ? current.call(context) : current;
    },

    escapeExpression: Utils.escapeExpression,
    invokePartial: invokePartialWrapper,

    fn: function fn(i) {
      var ret = templateSpec[i];
      ret.decorator = templateSpec[i + '_d'];
      return ret;
    },

    programs: [],
    program: function program(i, data, declaredBlockParams, blockParams, depths) {
      var programWrapper = this.programs[i],
          fn = this.fn(i);
      if (data || depths || blockParams || declaredBlockParams) {
        programWrapper = wrapProgram(this, i, fn, data, declaredBlockParams, blockParams, depths);
      } else if (!programWrapper) {
        programWrapper = this.programs[i] = wrapProgram(this, i, fn);
      }
      return programWrapper;
    },

    data: function data(value, depth) {
      while (value && depth--) {
        value = value._parent;
      }
      return value;
    },
    mergeIfNeeded: function mergeIfNeeded(param, common) {
      var obj = param || common;

      if (param && common && param !== common) {
        obj = Utils.extend({}, common, param);
      }

      return obj;
    },
    // An empty object to use as replacement for null-contexts
    nullContext: Object.seal({}),

    noop: env.VM.noop,
    compilerInfo: templateSpec.compiler
  };

  function ret(context) {
    var options = arguments.length <= 1 || arguments[1] === undefined ? {} : arguments[1];

    var data = options.data;

    ret._setup(options);
    if (!options.partial && templateSpec.useData) {
      data = initData(context, data);
    }
    var depths = undefined,
        blockParams = templateSpec.useBlockParams ? [] : undefined;
    if (templateSpec.useDepths) {
      if (options.depths) {
        depths = context != options.depths[0] ? [context].concat(options.depths) : options.depths;
      } else {
        depths = [context];
      }
    }

    function main(context /*, options*/) {
      return '' + templateSpec.main(container, context, container.helpers, container.partials, data, blockParams, depths);
    }

    main = executeDecorators(templateSpec.main, main, container, options.depths || [], data, blockParams);
    return main(context, options);
  }

  ret.isTop = true;

  ret._setup = function (options) {
    if (!options.partial) {
      var mergedHelpers = Utils.extend({}, env.helpers, options.helpers);
      wrapHelpersToPassLookupProperty(mergedHelpers, container);
      container.helpers = mergedHelpers;

      if (templateSpec.usePartial) {
        // Use mergeIfNeeded here to prevent compiling global partials multiple times
        container.partials = container.mergeIfNeeded(options.partials, env.partials);
      }
      if (templateSpec.usePartial || templateSpec.useDecorators) {
        container.decorators = Utils.extend({}, env.decorators, options.decorators);
      }

      container.hooks = {};
      container.protoAccessControl = _internalProtoAccess.createProtoAccessControl(options);

      var keepHelperInHelpers = options.allowCallsToHelperMissing || templateWasPrecompiledWithCompilerV7;
      _helpers.moveHelperToHooks(container, 'helperMissing', keepHelperInHelpers);
      _helpers.moveHelperToHooks(container, 'blockHelperMissing', keepHelperInHelpers);
    } else {
      container.protoAccessControl = options.protoAccessControl; // internal option
      container.helpers = options.helpers;
      container.partials = options.partials;
      container.decorators = options.decorators;
      container.hooks = options.hooks;
    }
  };

  ret._child = function (i, data, blockParams, depths) {
    if (templateSpec.useBlockParams && !blockParams) {
      throw new _exception2['default']('must pass block params');
    }
    if (templateSpec.useDepths && !depths) {
      throw new _exception2['default']('must pass parent depths');
    }

    return wrapProgram(container, i, templateSpec[i], data, 0, blockParams, depths);
  };
  return ret;
}

function wrapProgram(container, i, fn, data, declaredBlockParams, blockParams, depths) {
  function prog(context) {
    var options = arguments.length <= 1 || arguments[1] === undefined ? {} : arguments[1];

    var currentDepths = depths;
    if (depths && context != depths[0] && !(context === container.nullContext && depths[0] === null)) {
      currentDepths = [context].concat(depths);
    }

    return fn(container, context, container.helpers, container.partials, options.data || data, blockParams && [options.blockParams].concat(blockParams), currentDepths);
  }

  prog = executeDecorators(fn, prog, container, depths, data, blockParams);

  prog.program = i;
  prog.depth = depths ? depths.length : 0;
  prog.blockParams = declaredBlockParams || 0;
  return prog;
}

/**
 * This is currently part of the official API, therefore implementation details should not be changed.
 */

function resolvePartial(partial, context, options) {
  if (!partial) {
    if (options.name === '@partial-block') {
      partial = options.data['partial-block'];
    } else {
      partial = options.partials[options.name];
    }
  } else if (!partial.call && !options.name) {
    // This is a dynamic partial that returned a string
    options.name = partial;
    partial = options.partials[partial];
  }
  return partial;
}

function invokePartial(partial, context, options) {
  // Use the current closure context to save the partial-block if this partial
  var currentPartialBlock = options.data && options.data['partial-block'];
  options.partial = true;
  if (options.ids) {
    options.data.contextPath = options.ids[0] || options.data.contextPath;
  }

  var partialBlock = undefined;
  if (options.fn && options.fn !== noop) {
    (function () {
      options.data = _base.createFrame(options.data);
      // Wrapper function to get access to currentPartialBlock from the closure
      var fn = options.fn;
      partialBlock = options.data['partial-block'] = function partialBlockWrapper(context) {
        var options = arguments.length <= 1 || arguments[1] === undefined ? {} : arguments[1];

        // Restore the partial-block from the closure for the execution of the block
        // i.e. the part inside the block of the partial call.
        options.data = _base.createFrame(options.data);
        options.data['partial-block'] = currentPartialBlock;
        return fn(context, options);
      };
      if (fn.partials) {
        options.partials = Utils.extend({}, options.partials, fn.partials);
      }
    })();
  }

  if (partial === undefined && partialBlock) {
    partial = partialBlock;
  }

  if (partial === undefined) {
    throw new _exception2['default']('The partial ' + options.name + ' could not be found');
  } else if (partial instanceof Function) {
    return partial(context, options);
  }
}

function noop() {
  return '';
}

function initData(context, data) {
  if (!data || !('root' in data)) {
    data = data ? _base.createFrame(data) : {};
    data.root = context;
  }
  return data;
}

function executeDecorators(fn, prog, container, depths, data, blockParams) {
  if (fn.decorator) {
    var props = {};
    prog = fn.decorator(prog, props, container, depths && depths[0], data, blockParams, depths);
    Utils.extend(prog, props);
  }
  return prog;
}

function wrapHelpersToPassLookupProperty(mergedHelpers, container) {
  Object.keys(mergedHelpers).forEach(function (helperName) {
    var helper = mergedHelpers[helperName];
    mergedHelpers[helperName] = passLookupPropertyOption(helper, container);
  });
}

function passLookupPropertyOption(helper, container) {
  var lookupProperty = container.lookupProperty;
  return _internalWrapHelper.wrapHelper(helper, function (options) {
    return Utils.extend({ lookupProperty: lookupProperty }, options);
  });
}
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL3J1bnRpbWUuanMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7Ozs7cUJBQXVCLFNBQVM7O0lBQXBCLEtBQUs7O3lCQUNLLGFBQWE7Ozs7b0JBTTVCLFFBQVE7O3VCQUNtQixXQUFXOztrQ0FDbEIsdUJBQXVCOzttQ0FJM0MseUJBQXlCOztBQUV6QixTQUFTLGFBQWEsQ0FBQyxZQUFZLEVBQUU7QUFDMUMsTUFBTSxnQkFBZ0IsR0FBRyxBQUFDLFlBQVksSUFBSSxZQUFZLENBQUMsQ0FBQyxDQUFDLElBQUssQ0FBQztNQUM3RCxlQUFlLDBCQUFvQixDQUFDOztBQUV0QyxNQUNFLGdCQUFnQiwyQ0FBcUMsSUFDckQsZ0JBQWdCLDJCQUFxQixFQUNyQztBQUNBLFdBQU87R0FDUjs7QUFFRCxNQUFJLGdCQUFnQiwwQ0FBb0MsRUFBRTtBQUN4RCxRQUFNLGVBQWUsR0FBRyx1QkFBaUIsZUFBZSxDQUFDO1FBQ3ZELGdCQUFnQixHQUFHLHVCQUFpQixnQkFBZ0IsQ0FBQyxDQUFDO0FBQ3hELFVBQU0sMkJBQ0oseUZBQXlGLEdBQ3ZGLHFEQUFxRCxHQUNyRCxlQUFlLEdBQ2YsbURBQW1ELEdBQ25ELGdCQUFnQixHQUNoQixJQUFJLENBQ1AsQ0FBQztHQUNILE1BQU07O0FBRUwsVUFBTSwyQkFDSix3RkFBd0YsR0FDdEYsaURBQWlELEdBQ2pELFlBQVksQ0FBQyxDQUFDLENBQUMsR0FDZixJQUFJLENBQ1AsQ0FBQztHQUNIO0NBQ0Y7O0FBRU0sU0FBUyxRQUFRLENBQUMsWUFBWSxFQUFFLEdBQUcsRUFBRTs7QUFFMUMsTUFBSSxDQUFDLEdBQUcsRUFBRTtBQUNSLFVBQU0sMkJBQWMsbUNBQW1DLENBQUMsQ0FBQztHQUMxRDtBQUNELE1BQUksQ0FBQyxZQUFZLElBQUksQ0FBQyxZQUFZLENBQUMsSUFBSSxFQUFFO0FBQ3ZDLFVBQU0sMkJBQWMsMkJBQTJCLEdBQUcsT0FBTyxZQUFZLENBQUMsQ0FBQztHQUN4RTs7QUFFRCxjQUFZLENBQUMsSUFBSSxDQUFDLFNBQVMsR0FBRyxZQUFZLENBQUMsTUFBTSxDQUFDOzs7O0FBSWxELEtBQUcsQ0FBQyxFQUFFLENBQUMsYUFBYSxDQUFDLFlBQVksQ0FBQyxRQUFRLENBQUMsQ0FBQzs7O0FBRzVDLE1BQU0sb0NBQW9DLEdBQ3hDLFlBQVksQ0FBQyxRQUFRLElBQUksWUFBWSxDQUFDLFFBQVEsQ0FBQyxDQUFDLENBQUMsS0FBSyxDQUFDLENBQUM7O0FBRTFELFdBQVMsb0JBQW9CLENBQUMsT0FBTyxFQUFFLE9BQU8sRUFBRSxPQUFPLEVBQUU7QUFDdkQsUUFBSSxPQUFPLENBQUMsSUFBSSxFQUFFO0FBQ2hCLGFBQU8sR0FBRyxLQUFLLENBQUMsTUFBTSxDQUFDLEVBQUUsRUFBRSxPQUFPLEVBQUUsT0FBTyxDQUFDLElBQUksQ0FBQyxDQUFDO0FBQ2xELFVBQUksT0FBTyxDQUFDLEdBQUcsRUFBRTtBQUNmLGVBQU8sQ0FBQyxHQUFHLENBQUMsQ0FBQyxDQUFDLEdBQUcsSUFBSSxDQUFDO09BQ3ZCO0tBQ0Y7QUFDRCxXQUFPLEdBQUcsR0FBRyxDQUFDLEVBQUUsQ0FBQyxjQUFjLENBQUMsSUFBSSxDQUFDLElBQUksRUFBRSxPQUFPLEVBQUUsT0FBTyxFQUFFLE9BQU8sQ0FBQyxDQUFDOztBQUV0RSxRQUFJLGVBQWUsR0FBRyxLQUFLLENBQUMsTUFBTSxDQUFDLEVBQUUsRUFBRSxPQUFPLEVBQUU7QUFDOUMsV0FBSyxFQUFFLElBQUksQ0FBQyxLQUFLO0FBQ2pCLHdCQUFrQixFQUFFLElBQUksQ0FBQyxrQkFBa0I7S0FDNUMsQ0FBQyxDQUFDOztBQUVILFFBQUksTUFBTSxHQUFHLEdBQUcsQ0FBQyxFQUFFLENBQUMsYUFBYSxDQUFDLElBQUksQ0FDcEMsSUFBSSxFQUNKLE9BQU8sRUFDUCxPQUFPLEVBQ1AsZUFBZSxDQUNoQixDQUFDOztBQUVGLFFBQUksTUFBTSxJQUFJLElBQUksSUFBSSxHQUFHLENBQUMsT0FBTyxFQUFFO0FBQ2pDLGFBQU8sQ0FBQyxRQUFRLENBQUMsT0FBTyxDQUFDLElBQUksQ0FBQyxHQUFHLEdBQUcsQ0FBQyxPQUFPLENBQzFDLE9BQU8sRUFDUCxZQUFZLENBQUMsZUFBZSxFQUM1QixHQUFHLENBQ0osQ0FBQztBQUNGLFlBQU0sR0FBRyxPQUFPLENBQUMsUUFBUSxDQUFDLE9BQU8sQ0FBQyxJQUFJLENBQUMsQ0FBQyxPQUFPLEVBQUUsZUFBZSxDQUFDLENBQUM7S0FDbkU7QUFDRCxRQUFJLE1BQU0sSUFBSSxJQUFJLEVBQUU7QUFDbEIsVUFBSSxPQUFPLENBQUMsTUFBTSxFQUFFO0FBQ2xCLFlBQUksS0FBSyxHQUFHLE1BQU0sQ0FBQyxLQUFLLENBQUMsSUFBSSxDQUFDLENBQUM7QUFDL0IsYUFBSyxJQUFJLENBQUMsR0FBRyxDQUFDLEVBQUUsQ0FBQyxHQUFHLEtBQUssQ0FBQyxNQUFNLEVBQUUsQ0FBQyxHQUFHLENBQUMsRUFBRSxDQUFDLEVBQUUsRUFBRTtBQUM1QyxjQUFJLENBQUMsS0FBSyxDQUFDLENBQUMsQ0FBQyxJQUFJLENBQUMsR0FBRyxDQUFDLEtBQUssQ0FBQyxFQUFFO0FBQzVCLGtCQUFNO1dBQ1A7O0FBRUQsZUFBSyxDQUFDLENBQUMsQ0FBQyxHQUFHLE9BQU8sQ0FBQyxNQUFNLEdBQUcsS0FBSyxDQUFDLENBQUMsQ0FBQyxDQUFDO1NBQ3RDO0FBQ0QsY0FBTSxHQUFHLEtBQUssQ0FBQyxJQUFJLENBQUMsSUFBSSxDQUFDLENBQUM7T0FDM0I7QUFDRCxhQUFPLE1BQU0sQ0FBQztLQUNmLE1BQU07QUFDTCxZQUFNLDJCQUNKLGNBQWMsR0FDWixPQUFPLENBQUMsSUFBSSxHQUNaLDBEQUEwRCxDQUM3RCxDQUFDO0tBQ0g7R0FDRjs7O0FBR0QsTUFBSSxTQUFTLEdBQUc7QUFDZCxVQUFNLEVBQUUsZ0JBQVMsR0FBRyxFQUFFLElBQUksRUFBRSxHQUFHLEVBQUU7QUFDL0IsVUFBSSxDQUFDLEdBQUcsSUFBSSxFQUFFLElBQUksSUFBSSxHQUFHLENBQUEsQUFBQyxFQUFFO0FBQzFCLGNBQU0sMkJBQWMsR0FBRyxHQUFHLElBQUksR0FBRyxtQkFBbUIsR0FBRyxHQUFHLEVBQUU7QUFDMUQsYUFBRyxFQUFFLEdBQUc7U0FDVCxDQUFDLENBQUM7T0FDSjtBQUNELGFBQU8sR0FBRyxDQUFDLElBQUksQ0FBQyxDQUFDO0tBQ2xCO0FBQ0Qsa0JBQWMsRUFBRSx3QkFBUyxNQUFNLEVBQUUsWUFBWSxFQUFFO0FBQzdDLFVBQUksTUFBTSxHQUFHLE1BQU0sQ0FBQyxZQUFZLENBQUMsQ0FBQztBQUNsQyxVQUFJLE1BQU0sSUFBSSxJQUFJLEVBQUU7QUFDbEIsZUFBTyxNQUFNLENBQUM7T0FDZjtBQUNELFVBQUksTUFBTSxDQUFDLFNBQVMsQ0FBQyxjQUFjLENBQUMsSUFBSSxDQUFDLE1BQU0sRUFBRSxZQUFZLENBQUMsRUFBRTtBQUM5RCxlQUFPLE1BQU0sQ0FBQztPQUNmOztBQUVELFVBQUkscUNBQWdCLE1BQU0sRUFBRSxTQUFTLENBQUMsa0JBQWtCLEVBQUUsWUFBWSxDQUFDLEVBQUU7QUFDdkUsZUFBTyxNQUFNLENBQUM7T0FDZjtBQUNELGFBQU8sU0FBUyxDQUFDO0tBQ2xCO0FBQ0QsVUFBTSxFQUFFLGdCQUFTLE1BQU0sRUFBRSxJQUFJLEVBQUU7QUFDN0IsVUFBTSxHQUFHLEdBQUcsTUFBTSxDQUFDLE1BQU0sQ0FBQztBQUMxQixXQUFLLElBQUksQ0FBQyxHQUFHLENBQUMsRUFBRSxDQUFDLEdBQUcsR0FBRyxFQUFFLENBQUMsRUFBRSxFQUFFO0FBQzVCLFlBQUksTUFBTSxHQUFHLE1BQU0sQ0FBQyxDQUFDLENBQUMsSUFBSSxTQUFTLENBQUMsY0FBYyxDQUFDLE1BQU0sQ0FBQyxDQUFDLENBQUMsRUFBRSxJQUFJLENBQUMsQ0FBQztBQUNwRSxZQUFJLE1BQU0sSUFBSSxJQUFJLEVBQUU7QUFDbEIsaUJBQU8sTUFBTSxDQUFDLENBQUMsQ0FBQyxDQUFDLElBQUksQ0FBQyxDQUFDO1NBQ3hCO09BQ0Y7S0FDRjtBQUNELFVBQU0sRUFBRSxnQkFBUyxPQUFPLEVBQUUsT0FBTyxFQUFFO0FBQ2pDLGFBQU8sT0FBTyxPQUFPLEtBQUssVUFBVSxHQUFHLE9BQU8sQ0FBQyxJQUFJLENBQUMsT0FBTyxDQUFDLEdBQUcsT0FBTyxDQUFDO0tBQ3hFOztBQUVELG9CQUFnQixFQUFFLEtBQUssQ0FBQyxnQkFBZ0I7QUFDeEMsaUJBQWEsRUFBRSxvQkFBb0I7O0FBRW5DLE1BQUUsRUFBRSxZQUFTLENBQUMsRUFBRTtBQUNkLFVBQUksR0FBRyxHQUFHLFlBQVksQ0FBQyxDQUFDLENBQUMsQ0FBQztBQUMxQixTQUFHLENBQUMsU0FBUyxHQUFHLFlBQVksQ0FBQyxDQUFDLEdBQUcsSUFBSSxDQUFDLENBQUM7QUFDdkMsYUFBTyxHQUFHLENBQUM7S0FDWjs7QUFFRCxZQUFRLEVBQUUsRUFBRTtBQUNaLFdBQU8sRUFBRSxpQkFBUyxDQUFDLEVBQUUsSUFBSSxFQUFFLG1CQUFtQixFQUFFLFdBQVcsRUFBRSxNQUFNLEVBQUU7QUFDbkUsVUFBSSxjQUFjLEdBQUcsSUFBSSxDQUFDLFFBQVEsQ0FBQyxDQUFDLENBQUM7VUFDbkMsRUFBRSxHQUFHLElBQUksQ0FBQyxFQUFFLENBQUMsQ0FBQyxDQUFDLENBQUM7QUFDbEIsVUFBSSxJQUFJLElBQUksTUFBTSxJQUFJLFdBQVcsSUFBSSxtQkFBbUIsRUFBRTtBQUN4RCxzQkFBYyxHQUFHLFdBQVcsQ0FDMUIsSUFBSSxFQUNKLENBQUMsRUFDRCxFQUFFLEVBQ0YsSUFBSSxFQUNKLG1CQUFtQixFQUNuQixXQUFXLEVBQ1gsTUFBTSxDQUNQLENBQUM7T0FDSCxNQUFNLElBQUksQ0FBQyxjQUFjLEVBQUU7QUFDMUIsc0JBQWMsR0FBRyxJQUFJLENBQUMsUUFBUSxDQUFDLENBQUMsQ0FBQyxHQUFHLFdBQVcsQ0FBQyxJQUFJLEVBQUUsQ0FBQyxFQUFFLEVBQUUsQ0FBQyxDQUFDO09BQzlEO0FBQ0QsYUFBTyxjQUFjLENBQUM7S0FDdkI7O0FBRUQsUUFBSSxFQUFFLGNBQVMsS0FBSyxFQUFFLEtBQUssRUFBRTtBQUMzQixhQUFPLEtBQUssSUFBSSxLQUFLLEVBQUUsRUFBRTtBQUN2QixhQUFLLEdBQUcsS0FBSyxDQUFDLE9BQU8sQ0FBQztPQUN2QjtBQUNELGFBQU8sS0FBSyxDQUFDO0tBQ2Q7QUFDRCxpQkFBYSxFQUFFLHVCQUFTLEtBQUssRUFBRSxNQUFNLEVBQUU7QUFDckMsVUFBSSxHQUFHLEdBQUcsS0FBSyxJQUFJLE1BQU0sQ0FBQzs7QUFFMUIsVUFBSSxLQUFLLElBQUksTUFBTSxJQUFJLEtBQUssS0FBSyxNQUFNLEVBQUU7QUFDdkMsV0FBRyxHQUFHLEtBQUssQ0FBQyxNQUFNLENBQUMsRUFBRSxFQUFFLE1BQU0sRUFBRSxLQUFLLENBQUMsQ0FBQztPQUN2Qzs7QUFFRCxhQUFPLEdBQUcsQ0FBQztLQUNaOztBQUVELGVBQVcsRUFBRSxNQUFNLENBQUMsSUFBSSxDQUFDLEVBQUUsQ0FBQzs7QUFFNUIsUUFBSSxFQUFFLEdBQUcsQ0FBQyxFQUFFLENBQUMsSUFBSTtBQUNqQixnQkFBWSxFQUFFLFlBQVksQ0FBQyxRQUFRO0dBQ3BDLENBQUM7O0FBRUYsV0FBUyxHQUFHLENBQUMsT0FBTyxFQUFnQjtRQUFkLE9BQU8seURBQUcsRUFBRTs7QUFDaEMsUUFBSSxJQUFJLEdBQUcsT0FBTyxDQUFDLElBQUksQ0FBQzs7QUFFeEIsT0FBRyxDQUFDLE1BQU0sQ0FBQyxPQUFPLENBQUMsQ0FBQztBQUNwQixRQUFJLENBQUMsT0FBTyxDQUFDLE9BQU8sSUFBSSxZQUFZLENBQUMsT0FBTyxFQUFFO0FBQzVDLFVBQUksR0FBRyxRQUFRLENBQUMsT0FBTyxFQUFFLElBQUksQ0FBQyxDQUFDO0tBQ2hDO0FBQ0QsUUFBSSxNQUFNLFlBQUE7UUFDUixXQUFXLEdBQUcsWUFBWSxDQUFDLGNBQWMsR0FBRyxFQUFFLEdBQUcsU0FBUyxDQUFDO0FBQzdELFFBQUksWUFBWSxDQUFDLFNBQVMsRUFBRTtBQUMxQixVQUFJLE9BQU8sQ0FBQyxNQUFNLEVBQUU7QUFDbEIsY0FBTSxHQUNKLE9BQU8sSUFBSSxPQUFPLENBQUMsTUFBTSxDQUFDLENBQUMsQ0FBQyxHQUN4QixDQUFDLE9BQU8sQ0FBQyxDQUFDLE1BQU0sQ0FBQyxPQUFPLENBQUMsTUFBTSxDQUFDLEdBQ2hDLE9BQU8sQ0FBQyxNQUFNLENBQUM7T0FDdEIsTUFBTTtBQUNMLGNBQU0sR0FBRyxDQUFDLE9BQU8sQ0FBQyxDQUFDO09BQ3BCO0tBQ0Y7O0FBRUQsYUFBUyxJQUFJLENBQUMsT0FBTyxnQkFBZ0I7QUFDbkMsYUFDRSxFQUFFLEdBQ0YsWUFBWSxDQUFDLElBQUksQ0FDZixTQUFTLEVBQ1QsT0FBTyxFQUNQLFNBQVMsQ0FBQyxPQUFPLEVBQ2pCLFNBQVMsQ0FBQyxRQUFRLEVBQ2xCLElBQUksRUFDSixXQUFXLEVBQ1gsTUFBTSxDQUNQLENBQ0Q7S0FDSDs7QUFFRCxRQUFJLEdBQUcsaUJBQWlCLENBQ3RCLFlBQVksQ0FBQyxJQUFJLEVBQ2pCLElBQUksRUFDSixTQUFTLEVBQ1QsT0FBTyxDQUFDLE1BQU0sSUFBSSxFQUFFLEVBQ3BCLElBQUksRUFDSixXQUFXLENBQ1osQ0FBQztBQUNGLFdBQU8sSUFBSSxDQUFDLE9BQU8sRUFBRSxPQUFPLENBQUMsQ0FBQztHQUMvQjs7QUFFRCxLQUFHLENBQUMsS0FBSyxHQUFHLElBQUksQ0FBQzs7QUFFakIsS0FBRyxDQUFDLE1BQU0sR0FBRyxVQUFTLE9BQU8sRUFBRTtBQUM3QixRQUFJLENBQUMsT0FBTyxDQUFDLE9BQU8sRUFBRTtBQUNwQixVQUFJLGFBQWEsR0FBRyxLQUFLLENBQUMsTUFBTSxDQUFDLEVBQUUsRUFBRSxHQUFHLENBQUMsT0FBTyxFQUFFLE9BQU8sQ0FBQyxPQUFPLENBQUMsQ0FBQztBQUNuRSxxQ0FBK0IsQ0FBQyxhQUFhLEVBQUUsU0FBUyxDQUFDLENBQUM7QUFDMUQsZUFBUyxDQUFDLE9BQU8sR0FBRyxhQUFhLENBQUM7O0FBRWxDLFVBQUksWUFBWSxDQUFDLFVBQVUsRUFBRTs7QUFFM0IsaUJBQVMsQ0FBQyxRQUFRLEdBQUcsU0FBUyxDQUFDLGFBQWEsQ0FDMUMsT0FBTyxDQUFDLFFBQVEsRUFDaEIsR0FBRyxDQUFDLFFBQVEsQ0FDYixDQUFDO09BQ0g7QUFDRCxVQUFJLFlBQVksQ0FBQyxVQUFVLElBQUksWUFBWSxDQUFDLGFBQWEsRUFBRTtBQUN6RCxpQkFBUyxDQUFDLFVBQVUsR0FBRyxLQUFLLENBQUMsTUFBTSxDQUNqQyxFQUFFLEVBQ0YsR0FBRyxDQUFDLFVBQVUsRUFDZCxPQUFPLENBQUMsVUFBVSxDQUNuQixDQUFDO09BQ0g7O0FBRUQsZUFBUyxDQUFDLEtBQUssR0FBRyxFQUFFLENBQUM7QUFDckIsZUFBUyxDQUFDLGtCQUFrQixHQUFHLDhDQUF5QixPQUFPLENBQUMsQ0FBQzs7QUFFakUsVUFBSSxtQkFBbUIsR0FDckIsT0FBTyxDQUFDLHlCQUF5QixJQUNqQyxvQ0FBb0MsQ0FBQztBQUN2QyxpQ0FBa0IsU0FBUyxFQUFFLGVBQWUsRUFBRSxtQkFBbUIsQ0FBQyxDQUFDO0FBQ25FLGlDQUFrQixTQUFTLEVBQUUsb0JBQW9CLEVBQUUsbUJBQW1CLENBQUMsQ0FBQztLQUN6RSxNQUFNO0FBQ0wsZUFBUyxDQUFDLGtCQUFrQixHQUFHLE9BQU8sQ0FBQyxrQkFBa0IsQ0FBQztBQUMxRCxlQUFTLENBQUMsT0FBTyxHQUFHLE9BQU8sQ0FBQyxPQUFPLENBQUM7QUFDcEMsZUFBUyxDQUFDLFFBQVEsR0FBRyxPQUFPLENBQUMsUUFBUSxDQUFDO0FBQ3RDLGVBQVMsQ0FBQyxVQUFVLEdBQUcsT0FBTyxDQUFDLFVBQVUsQ0FBQztBQUMxQyxlQUFTLENBQUMsS0FBSyxHQUFHLE9BQU8sQ0FBQyxLQUFLLENBQUM7S0FDakM7R0FDRixDQUFDOztBQUVGLEtBQUcsQ0FBQyxNQUFNLEdBQUcsVUFBUyxDQUFDLEVBQUUsSUFBSSxFQUFFLFdBQVcsRUFBRSxNQUFNLEVBQUU7QUFDbEQsUUFBSSxZQUFZLENBQUMsY0FBYyxJQUFJLENBQUMsV0FBVyxFQUFFO0FBQy9DLFlBQU0sMkJBQWMsd0JBQXdCLENBQUMsQ0FBQztLQUMvQztBQUNELFFBQUksWUFBWSxDQUFDLFNBQVMsSUFBSSxDQUFDLE1BQU0sRUFBRTtBQUNyQyxZQUFNLDJCQUFjLHlCQUF5QixDQUFDLENBQUM7S0FDaEQ7O0FBRUQsV0FBTyxXQUFXLENBQ2hCLFNBQVMsRUFDVCxDQUFDLEVBQ0QsWUFBWSxDQUFDLENBQUMsQ0FBQyxFQUNmLElBQUksRUFDSixDQUFDLEVBQ0QsV0FBVyxFQUNYLE1BQU0sQ0FDUCxDQUFDO0dBQ0gsQ0FBQztBQUNGLFNBQU8sR0FBRyxDQUFDO0NBQ1o7O0FBRU0sU0FBUyxXQUFXLENBQ3pCLFNBQVMsRUFDVCxDQUFDLEVBQ0QsRUFBRSxFQUNGLElBQUksRUFDSixtQkFBbUIsRUFDbkIsV0FBVyxFQUNYLE1BQU0sRUFDTjtBQUNBLFdBQVMsSUFBSSxDQUFDLE9BQU8sRUFBZ0I7UUFBZCxPQUFPLHlEQUFHLEVBQUU7O0FBQ2pDLFFBQUksYUFBYSxHQUFHLE1BQU0sQ0FBQztBQUMzQixRQUNFLE1BQU0sSUFDTixPQUFPLElBQUksTUFBTSxDQUFDLENBQUMsQ0FBQyxJQUNwQixFQUFFLE9BQU8sS0FBSyxTQUFTLENBQUMsV0FBVyxJQUFJLE1BQU0sQ0FBQyxDQUFDLENBQUMsS0FBSyxJQUFJLENBQUEsQUFBQyxFQUMxRDtBQUNBLG1CQUFhLEdBQUcsQ0FBQyxPQUFPLENBQUMsQ0FBQyxNQUFNLENBQUMsTUFBTSxDQUFDLENBQUM7S0FDMUM7O0FBRUQsV0FBTyxFQUFFLENBQ1AsU0FBUyxFQUNULE9BQU8sRUFDUCxTQUFTLENBQUMsT0FBTyxFQUNqQixTQUFTLENBQUMsUUFBUSxFQUNsQixPQUFPLENBQUMsSUFBSSxJQUFJLElBQUksRUFDcEIsV0FBVyxJQUFJLENBQUMsT0FBTyxDQUFDLFdBQVcsQ0FBQyxDQUFDLE1BQU0sQ0FBQyxXQUFXLENBQUMsRUFDeEQsYUFBYSxDQUNkLENBQUM7R0FDSDs7QUFFRCxNQUFJLEdBQUcsaUJBQWlCLENBQUMsRUFBRSxFQUFFLElBQUksRUFBRSxTQUFTLEVBQUUsTUFBTSxFQUFFLElBQUksRUFBRSxXQUFXLENBQUMsQ0FBQzs7QUFFekUsTUFBSSxDQUFDLE9BQU8sR0FBRyxDQUFDLENBQUM7QUFDakIsTUFBSSxDQUFDLEtBQUssR0FBRyxNQUFNLEdBQUcsTUFBTSxDQUFDLE1BQU0sR0FBRyxDQUFDLENBQUM7QUFDeEMsTUFBSSxDQUFDLFdBQVcsR0FBRyxtQkFBbUIsSUFBSSxDQUFDLENBQUM7QUFDNUMsU0FBTyxJQUFJLENBQUM7Q0FDYjs7Ozs7O0FBS00sU0FBUyxjQUFjLENBQUMsT0FBTyxFQUFFLE9BQU8sRUFBRSxPQUFPLEVBQUU7QUFDeEQsTUFBSSxDQUFDLE9BQU8sRUFBRTtBQUNaLFFBQUksT0FBTyxDQUFDLElBQUksS0FBSyxnQkFBZ0IsRUFBRTtBQUNyQyxhQUFPLEdBQUcsT0FBTyxDQUFDLElBQUksQ0FBQyxlQUFlLENBQUMsQ0FBQztLQUN6QyxNQUFNO0FBQ0wsYUFBTyxHQUFHLE9BQU8sQ0FBQyxRQUFRLENBQUMsT0FBTyxDQUFDLElBQUksQ0FBQyxDQUFDO0tBQzFDO0dBQ0YsTUFBTSxJQUFJLENBQUMsT0FBTyxDQUFDLElBQUksSUFBSSxDQUFDLE9BQU8sQ0FBQyxJQUFJLEVBQUU7O0FBRXpDLFdBQU8sQ0FBQyxJQUFJLEdBQUcsT0FBTyxDQUFDO0FBQ3ZCLFdBQU8sR0FBRyxPQUFPLENBQUMsUUFBUSxDQUFDLE9BQU8sQ0FBQyxDQUFDO0dBQ3JDO0FBQ0QsU0FBTyxPQUFPLENBQUM7Q0FDaEI7O0FBRU0sU0FBUyxhQUFhLENBQUMsT0FBTyxFQUFFLE9BQU8sRUFBRSxPQUFPLEVBQUU7O0FBRXZELE1BQU0sbUJBQW1CLEdBQUcsT0FBTyxDQUFDLElBQUksSUFBSSxPQUFPLENBQUMsSUFBSSxDQUFDLGVBQWUsQ0FBQyxDQUFDO0FBQzFFLFNBQU8sQ0FBQyxPQUFPLEdBQUcsSUFBSSxDQUFDO0FBQ3ZCLE1BQUksT0FBTyxDQUFDLEdBQUcsRUFBRTtBQUNmLFdBQU8sQ0FBQyxJQUFJLENBQUMsV0FBVyxHQUFHLE9BQU8sQ0FBQyxHQUFHLENBQUMsQ0FBQyxDQUFDLElBQUksT0FBTyxDQUFDLElBQUksQ0FBQyxXQUFXLENBQUM7R0FDdkU7O0FBRUQsTUFBSSxZQUFZLFlBQUEsQ0FBQztBQUNqQixNQUFJLE9BQU8sQ0FBQyxFQUFFLElBQUksT0FBTyxDQUFDLEVBQUUsS0FBSyxJQUFJLEVBQUU7O0FBQ3JDLGFBQU8sQ0FBQyxJQUFJLEdBQUcsa0JBQVksT0FBTyxDQUFDLElBQUksQ0FBQyxDQUFDOztBQUV6QyxVQUFJLEVBQUUsR0FBRyxPQUFPLENBQUMsRUFBRSxDQUFDO0FBQ3BCLGtCQUFZLEdBQUcsT0FBTyxDQUFDLElBQUksQ0FBQyxlQUFlLENBQUMsR0FBRyxTQUFTLG1CQUFtQixDQUN6RSxPQUFPLEVBRVA7WUFEQSxPQUFPLHlEQUFHLEVBQUU7Ozs7QUFJWixlQUFPLENBQUMsSUFBSSxHQUFHLGtCQUFZLE9BQU8sQ0FBQyxJQUFJLENBQUMsQ0FBQztBQUN6QyxlQUFPLENBQUMsSUFBSSxDQUFDLGVBQWUsQ0FBQyxHQUFHLG1CQUFtQixDQUFDO0FBQ3BELGVBQU8sRUFBRSxDQUFDLE9BQU8sRUFBRSxPQUFPLENBQUMsQ0FBQztPQUM3QixDQUFDO0FBQ0YsVUFBSSxFQUFFLENBQUMsUUFBUSxFQUFFO0FBQ2YsZUFBTyxDQUFDLFFBQVEsR0FBRyxLQUFLLENBQUMsTUFBTSxDQUFDLEVBQUUsRUFBRSxPQUFPLENBQUMsUUFBUSxFQUFFLEVBQUUsQ0FBQyxRQUFRLENBQUMsQ0FBQztPQUNwRTs7R0FDRjs7QUFFRCxNQUFJLE9BQU8sS0FBSyxTQUFTLElBQUksWUFBWSxFQUFFO0FBQ3pDLFdBQU8sR0FBRyxZQUFZLENBQUM7R0FDeEI7O0FBRUQsTUFBSSxPQUFPLEtBQUssU0FBUyxFQUFFO0FBQ3pCLFVBQU0sMkJBQWMsY0FBYyxHQUFHLE9BQU8sQ0FBQyxJQUFJLEdBQUcscUJBQXFCLENBQUMsQ0FBQztHQUM1RSxNQUFNLElBQUksT0FBTyxZQUFZLFFBQVEsRUFBRTtBQUN0QyxXQUFPLE9BQU8sQ0FBQyxPQUFPLEVBQUUsT0FBTyxDQUFDLENBQUM7R0FDbEM7Q0FDRjs7QUFFTSxTQUFTLElBQUksR0FBRztBQUNyQixTQUFPLEVBQUUsQ0FBQztDQUNYOztBQUVELFNBQVMsUUFBUSxDQUFDLE9BQU8sRUFBRSxJQUFJLEVBQUU7QUFDL0IsTUFBSSxDQUFDLElBQUksSUFBSSxFQUFFLE1BQU0sSUFBSSxJQUFJLENBQUEsQUFBQyxFQUFFO0FBQzlCLFFBQUksR0FBRyxJQUFJLEdBQUcsa0JBQVksSUFBSSxDQUFDLEdBQUcsRUFBRSxDQUFDO0FBQ3JDLFFBQUksQ0FBQyxJQUFJLEdBQUcsT0FBTyxDQUFDO0dBQ3JCO0FBQ0QsU0FBTyxJQUFJLENBQUM7Q0FDYjs7QUFFRCxTQUFTLGlCQUFpQixDQUFDLEVBQUUsRUFBRSxJQUFJLEVBQUUsU0FBUyxFQUFFLE1BQU0sRUFBRSxJQUFJLEVBQUUsV0FBVyxFQUFFO0FBQ3pFLE1BQUksRUFBRSxDQUFDLFNBQVMsRUFBRTtBQUNoQixRQUFJLEtBQUssR0FBRyxFQUFFLENBQUM7QUFDZixRQUFJLEdBQUcsRUFBRSxDQUFDLFNBQVMsQ0FDakIsSUFBSSxFQUNKLEtBQUssRUFDTCxTQUFTLEVBQ1QsTUFBTSxJQUFJLE1BQU0sQ0FBQyxDQUFDLENBQUMsRUFDbkIsSUFBSSxFQUNKLFdBQVcsRUFDWCxNQUFNLENBQ1AsQ0FBQztBQUNGLFNBQUssQ0FBQyxNQUFNLENBQUMsSUFBSSxFQUFFLEtBQUssQ0FBQyxDQUFDO0dBQzNCO0FBQ0QsU0FBTyxJQUFJLENBQUM7Q0FDYjs7QUFFRCxTQUFTLCtCQUErQixDQUFDLGFBQWEsRUFBRSxTQUFTLEVBQUU7QUFDakUsUUFBTSxDQUFDLElBQUksQ0FBQyxhQUFhLENBQUMsQ0FBQyxPQUFPLENBQUMsVUFBQSxVQUFVLEVBQUk7QUFDL0MsUUFBSSxNQUFNLEdBQUcsYUFBYSxDQUFDLFVBQVUsQ0FBQyxDQUFDO0FBQ3ZDLGlCQUFhLENBQUMsVUFBVSxDQUFDLEdBQUcsd0JBQXdCLENBQUMsTUFBTSxFQUFFLFNBQVMsQ0FBQyxDQUFDO0dBQ3pFLENBQUMsQ0FBQztDQUNKOztBQUVELFNBQVMsd0JBQXdCLENBQUMsTUFBTSxFQUFFLFNBQVMsRUFBRTtBQUNuRCxNQUFNLGNBQWMsR0FBRyxTQUFTLENBQUMsY0FBYyxDQUFDO0FBQ2hELFNBQU8sK0JBQVcsTUFBTSxFQUFFLFVBQUEsT0FBTyxFQUFJO0FBQ25DLFdBQU8sS0FBSyxDQUFDLE1BQU0sQ0FBQyxFQUFFLGNBQWMsRUFBZCxjQUFjLEVBQUUsRUFBRSxPQUFPLENBQUMsQ0FBQztHQUNsRCxDQUFDLENBQUM7Q0FDSiIsImZpbGUiOiJydW50aW1lLmpzIiwic291cmNlc0NvbnRlbnQiOlsiaW1wb3J0ICogYXMgVXRpbHMgZnJvbSAnLi91dGlscyc7XG5pbXBvcnQgRXhjZXB0aW9uIGZyb20gJy4vZXhjZXB0aW9uJztcbmltcG9ydCB7XG4gIENPTVBJTEVSX1JFVklTSU9OLFxuICBjcmVhdGVGcmFtZSxcbiAgTEFTVF9DT01QQVRJQkxFX0NPTVBJTEVSX1JFVklTSU9OLFxuICBSRVZJU0lPTl9DSEFOR0VTXG59IGZyb20gJy4vYmFzZSc7XG5pbXBvcnQgeyBtb3ZlSGVscGVyVG9Ib29rcyB9IGZyb20gJy4vaGVscGVycyc7XG5pbXBvcnQgeyB3cmFwSGVscGVyIH0gZnJvbSAnLi9pbnRlcm5hbC93cmFwSGVscGVyJztcbmltcG9ydCB7XG4gIGNyZWF0ZVByb3RvQWNjZXNzQ29udHJvbCxcbiAgcmVzdWx0SXNBbGxvd2VkXG59IGZyb20gJy4vaW50ZXJuYWwvcHJvdG8tYWNjZXNzJztcblxuZXhwb3J0IGZ1bmN0aW9uIGNoZWNrUmV2aXNpb24oY29tcGlsZXJJbmZvKSB7XG4gIGNvbnN0IGNvbXBpbGVyUmV2aXNpb24gPSAoY29tcGlsZXJJbmZvICYmIGNvbXBpbGVySW5mb1swXSkgfHwgMSxcbiAgICBjdXJyZW50UmV2aXNpb24gPSBDT01QSUxFUl9SRVZJU0lPTjtcblxuICBpZiAoXG4gICAgY29tcGlsZXJSZXZpc2lvbiA+PSBMQVNUX0NPTVBBVElCTEVfQ09NUElMRVJfUkVWSVNJT04gJiZcbiAgICBjb21waWxlclJldmlzaW9uIDw9IENPTVBJTEVSX1JFVklTSU9OXG4gICkge1xuICAgIHJldHVybjtcbiAgfVxuXG4gIGlmIChjb21waWxlclJldmlzaW9uIDwgTEFTVF9DT01QQVRJQkxFX0NPTVBJTEVSX1JFVklTSU9OKSB7XG4gICAgY29uc3QgcnVudGltZVZlcnNpb25zID0gUkVWSVNJT05fQ0hBTkdFU1tjdXJyZW50UmV2aXNpb25dLFxuICAgICAgY29tcGlsZXJWZXJzaW9ucyA9IFJFVklTSU9OX0NIQU5HRVNbY29tcGlsZXJSZXZpc2lvbl07XG4gICAgdGhyb3cgbmV3IEV4Y2VwdGlvbihcbiAgICAgICdUZW1wbGF0ZSB3YXMgcHJlY29tcGlsZWQgd2l0aCBhbiBvbGRlciB2ZXJzaW9uIG9mIEhhbmRsZWJhcnMgdGhhbiB0aGUgY3VycmVudCBydW50aW1lLiAnICtcbiAgICAgICAgJ1BsZWFzZSB1cGRhdGUgeW91ciBwcmVjb21waWxlciB0byBhIG5ld2VyIHZlcnNpb24gKCcgK1xuICAgICAgICBydW50aW1lVmVyc2lvbnMgK1xuICAgICAgICAnKSBvciBkb3duZ3JhZGUgeW91ciBydW50aW1lIHRvIGFuIG9sZGVyIHZlcnNpb24gKCcgK1xuICAgICAgICBjb21waWxlclZlcnNpb25zICtcbiAgICAgICAgJykuJ1xuICAgICk7XG4gIH0gZWxzZSB7XG4gICAgLy8gVXNlIHRoZSBlbWJlZGRlZCB2ZXJzaW9uIGluZm8gc2luY2UgdGhlIHJ1bnRpbWUgZG9lc24ndCBrbm93IGFib3V0IHRoaXMgcmV2aXNpb24geWV0XG4gICAgdGhyb3cgbmV3IEV4Y2VwdGlvbihcbiAgICAgICdUZW1wbGF0ZSB3YXMgcHJlY29tcGlsZWQgd2l0aCBhIG5ld2VyIHZlcnNpb24gb2YgSGFuZGxlYmFycyB0aGFuIHRoZSBjdXJyZW50IHJ1bnRpbWUuICcgK1xuICAgICAgICAnUGxlYXNlIHVwZGF0ZSB5b3VyIHJ1bnRpbWUgdG8gYSBuZXdlciB2ZXJzaW9uICgnICtcbiAgICAgICAgY29tcGlsZXJJbmZvWzFdICtcbiAgICAgICAgJykuJ1xuICAgICk7XG4gIH1cbn1cblxuZXhwb3J0IGZ1bmN0aW9uIHRlbXBsYXRlKHRlbXBsYXRlU3BlYywgZW52KSB7XG4gIC8qIGlzdGFuYnVsIGlnbm9yZSBuZXh0ICovXG4gIGlmICghZW52KSB7XG4gICAgdGhyb3cgbmV3IEV4Y2VwdGlvbignTm8gZW52aXJvbm1lbnQgcGFzc2VkIHRvIHRlbXBsYXRlJyk7XG4gIH1cbiAgaWYgKCF0ZW1wbGF0ZVNwZWMgfHwgIXRlbXBsYXRlU3BlYy5tYWluKSB7XG4gICAgdGhyb3cgbmV3IEV4Y2VwdGlvbignVW5rbm93biB0ZW1wbGF0ZSBvYmplY3Q6ICcgKyB0eXBlb2YgdGVtcGxhdGVTcGVjKTtcbiAgfVxuXG4gIHRlbXBsYXRlU3BlYy5tYWluLmRlY29yYXRvciA9IHRlbXBsYXRlU3BlYy5tYWluX2Q7XG5cbiAgLy8gTm90ZTogVXNpbmcgZW52LlZNIHJlZmVyZW5jZXMgcmF0aGVyIHRoYW4gbG9jYWwgdmFyIHJlZmVyZW5jZXMgdGhyb3VnaG91dCB0aGlzIHNlY3Rpb24gdG8gYWxsb3dcbiAgLy8gZm9yIGV4dGVybmFsIHVzZXJzIHRvIG92ZXJyaWRlIHRoZXNlIGFzIHBzZXVkby1zdXBwb3J0ZWQgQVBJcy5cbiAgZW52LlZNLmNoZWNrUmV2aXNpb24odGVtcGxhdGVTcGVjLmNvbXBpbGVyKTtcblxuICAvLyBiYWNrd2FyZHMgY29tcGF0aWJpbGl0eSBmb3IgcHJlY29tcGlsZWQgdGVtcGxhdGVzIHdpdGggY29tcGlsZXItdmVyc2lvbiA3ICg8NC4zLjApXG4gIGNvbnN0IHRlbXBsYXRlV2FzUHJlY29tcGlsZWRXaXRoQ29tcGlsZXJWNyA9XG4gICAgdGVtcGxhdGVTcGVjLmNvbXBpbGVyICYmIHRlbXBsYXRlU3BlYy5jb21waWxlclswXSA9PT0gNztcblxuICBmdW5jdGlvbiBpbnZva2VQYXJ0aWFsV3JhcHBlcihwYXJ0aWFsLCBjb250ZXh0LCBvcHRpb25zKSB7XG4gICAgaWYgKG9wdGlvbnMuaGFzaCkge1xuICAgICAgY29udGV4dCA9IFV0aWxzLmV4dGVuZCh7fSwgY29udGV4dCwgb3B0aW9ucy5oYXNoKTtcbiAgICAgIGlmIChvcHRpb25zLmlkcykge1xuICAgICAgICBvcHRpb25zLmlkc1swXSA9IHRydWU7XG4gICAgICB9XG4gICAgfVxuICAgIHBhcnRpYWwgPSBlbnYuVk0ucmVzb2x2ZVBhcnRpYWwuY2FsbCh0aGlzLCBwYXJ0aWFsLCBjb250ZXh0LCBvcHRpb25zKTtcblxuICAgIGxldCBleHRlbmRlZE9wdGlvbnMgPSBVdGlscy5leHRlbmQoe30sIG9wdGlvbnMsIHtcbiAgICAgIGhvb2tzOiB0aGlzLmhvb2tzLFxuICAgICAgcHJvdG9BY2Nlc3NDb250cm9sOiB0aGlzLnByb3RvQWNjZXNzQ29udHJvbFxuICAgIH0pO1xuXG4gICAgbGV0IHJlc3VsdCA9IGVudi5WTS5pbnZva2VQYXJ0aWFsLmNhbGwoXG4gICAgICB0aGlzLFxuICAgICAgcGFydGlhbCxcbiAgICAgIGNvbnRleHQsXG4gICAgICBleHRlbmRlZE9wdGlvbnNcbiAgICApO1xuXG4gICAgaWYgKHJlc3VsdCA9PSBudWxsICYmIGVudi5jb21waWxlKSB7XG4gICAgICBvcHRpb25zLnBhcnRpYWxzW29wdGlvbnMubmFtZV0gPSBlbnYuY29tcGlsZShcbiAgICAgICAgcGFydGlhbCxcbiAgICAgICAgdGVtcGxhdGVTcGVjLmNvbXBpbGVyT3B0aW9ucyxcbiAgICAgICAgZW52XG4gICAgICApO1xuICAgICAgcmVzdWx0ID0gb3B0aW9ucy5wYXJ0aWFsc1tvcHRpb25zLm5hbWVdKGNvbnRleHQsIGV4dGVuZGVkT3B0aW9ucyk7XG4gICAgfVxuICAgIGlmIChyZXN1bHQgIT0gbnVsbCkge1xuICAgICAgaWYgKG9wdGlvbnMuaW5kZW50KSB7XG4gICAgICAgIGxldCBsaW5lcyA9IHJlc3VsdC5zcGxpdCgnXFxuJyk7XG4gICAgICAgIGZvciAobGV0IGkgPSAwLCBsID0gbGluZXMubGVuZ3RoOyBpIDwgbDsgaSsrKSB7XG4gICAgICAgICAgaWYgKCFsaW5lc1tpXSAmJiBpICsgMSA9PT0gbCkge1xuICAgICAgICAgICAgYnJlYWs7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgbGluZXNbaV0gPSBvcHRpb25zLmluZGVudCArIGxpbmVzW2ldO1xuICAgICAgICB9XG4gICAgICAgIHJlc3VsdCA9IGxpbmVzLmpvaW4oJ1xcbicpO1xuICAgICAgfVxuICAgICAgcmV0dXJuIHJlc3VsdDtcbiAgICB9IGVsc2Uge1xuICAgICAgdGhyb3cgbmV3IEV4Y2VwdGlvbihcbiAgICAgICAgJ1RoZSBwYXJ0aWFsICcgK1xuICAgICAgICAgIG9wdGlvbnMubmFtZSArXG4gICAgICAgICAgJyBjb3VsZCBub3QgYmUgY29tcGlsZWQgd2hlbiBydW5uaW5nIGluIHJ1bnRpbWUtb25seSBtb2RlJ1xuICAgICAgKTtcbiAgICB9XG4gIH1cblxuICAvLyBKdXN0IGFkZCB3YXRlclxuICBsZXQgY29udGFpbmVyID0ge1xuICAgIHN0cmljdDogZnVuY3Rpb24ob2JqLCBuYW1lLCBsb2MpIHtcbiAgICAgIGlmICghb2JqIHx8ICEobmFtZSBpbiBvYmopKSB7XG4gICAgICAgIHRocm93IG5ldyBFeGNlcHRpb24oJ1wiJyArIG5hbWUgKyAnXCIgbm90IGRlZmluZWQgaW4gJyArIG9iaiwge1xuICAgICAgICAgIGxvYzogbG9jXG4gICAgICAgIH0pO1xuICAgICAgfVxuICAgICAgcmV0dXJuIG9ialtuYW1lXTtcbiAgICB9LFxuICAgIGxvb2t1cFByb3BlcnR5OiBmdW5jdGlvbihwYXJlbnQsIHByb3BlcnR5TmFtZSkge1xuICAgICAgbGV0IHJlc3VsdCA9IHBhcmVudFtwcm9wZXJ0eU5hbWVdO1xuICAgICAgaWYgKHJlc3VsdCA9PSBudWxsKSB7XG4gICAgICAgIHJldHVybiByZXN1bHQ7XG4gICAgICB9XG4gICAgICBpZiAoT2JqZWN0LnByb3RvdHlwZS5oYXNPd25Qcm9wZXJ0eS5jYWxsKHBhcmVudCwgcHJvcGVydHlOYW1lKSkge1xuICAgICAgICByZXR1cm4gcmVzdWx0O1xuICAgICAgfVxuXG4gICAgICBpZiAocmVzdWx0SXNBbGxvd2VkKHJlc3VsdCwgY29udGFpbmVyLnByb3RvQWNjZXNzQ29udHJvbCwgcHJvcGVydHlOYW1lKSkge1xuICAgICAgICByZXR1cm4gcmVzdWx0O1xuICAgICAgfVxuICAgICAgcmV0dXJuIHVuZGVmaW5lZDtcbiAgICB9LFxuICAgIGxvb2t1cDogZnVuY3Rpb24oZGVwdGhzLCBuYW1lKSB7XG4gICAgICBjb25zdCBsZW4gPSBkZXB0aHMubGVuZ3RoO1xuICAgICAgZm9yIChsZXQgaSA9IDA7IGkgPCBsZW47IGkrKykge1xuICAgICAgICBsZXQgcmVzdWx0ID0gZGVwdGhzW2ldICYmIGNvbnRhaW5lci5sb29rdXBQcm9wZXJ0eShkZXB0aHNbaV0sIG5hbWUpO1xuICAgICAgICBpZiAocmVzdWx0ICE9IG51bGwpIHtcbiAgICAgICAgICByZXR1cm4gZGVwdGhzW2ldW25hbWVdO1xuICAgICAgICB9XG4gICAgICB9XG4gICAgfSxcbiAgICBsYW1iZGE6IGZ1bmN0aW9uKGN1cnJlbnQsIGNvbnRleHQpIHtcbiAgICAgIHJldHVybiB0eXBlb2YgY3VycmVudCA9PT0gJ2Z1bmN0aW9uJyA/IGN1cnJlbnQuY2FsbChjb250ZXh0KSA6IGN1cnJlbnQ7XG4gICAgfSxcblxuICAgIGVzY2FwZUV4cHJlc3Npb246IFV0aWxzLmVzY2FwZUV4cHJlc3Npb24sXG4gICAgaW52b2tlUGFydGlhbDogaW52b2tlUGFydGlhbFdyYXBwZXIsXG5cbiAgICBmbjogZnVuY3Rpb24oaSkge1xuICAgICAgbGV0IHJldCA9IHRlbXBsYXRlU3BlY1tpXTtcbiAgICAgIHJldC5kZWNvcmF0b3IgPSB0ZW1wbGF0ZVNwZWNbaSArICdfZCddO1xuICAgICAgcmV0dXJuIHJldDtcbiAgICB9LFxuXG4gICAgcHJvZ3JhbXM6IFtdLFxuICAgIHByb2dyYW06IGZ1bmN0aW9uKGksIGRhdGEsIGRlY2xhcmVkQmxvY2tQYXJhbXMsIGJsb2NrUGFyYW1zLCBkZXB0aHMpIHtcbiAgICAgIGxldCBwcm9ncmFtV3JhcHBlciA9IHRoaXMucHJvZ3JhbXNbaV0sXG4gICAgICAgIGZuID0gdGhpcy5mbihpKTtcbiAgICAgIGlmIChkYXRhIHx8IGRlcHRocyB8fCBibG9ja1BhcmFtcyB8fCBkZWNsYXJlZEJsb2NrUGFyYW1zKSB7XG4gICAgICAgIHByb2dyYW1XcmFwcGVyID0gd3JhcFByb2dyYW0oXG4gICAgICAgICAgdGhpcyxcbiAgICAgICAgICBpLFxuICAgICAgICAgIGZuLFxuICAgICAgICAgIGRhdGEsXG4gICAgICAgICAgZGVjbGFyZWRCbG9ja1BhcmFtcyxcbiAgICAgICAgICBibG9ja1BhcmFtcyxcbiAgICAgICAgICBkZXB0aHNcbiAgICAgICAgKTtcbiAgICAgIH0gZWxzZSBpZiAoIXByb2dyYW1XcmFwcGVyKSB7XG4gICAgICAgIHByb2dyYW1XcmFwcGVyID0gdGhpcy5wcm9ncmFtc1tpXSA9IHdyYXBQcm9ncmFtKHRoaXMsIGksIGZuKTtcbiAgICAgIH1cbiAgICAgIHJldHVybiBwcm9ncmFtV3JhcHBlcjtcbiAgICB9LFxuXG4gICAgZGF0YTogZnVuY3Rpb24odmFsdWUsIGRlcHRoKSB7XG4gICAgICB3aGlsZSAodmFsdWUgJiYgZGVwdGgtLSkge1xuICAgICAgICB2YWx1ZSA9IHZhbHVlLl9wYXJlbnQ7XG4gICAgICB9XG4gICAgICByZXR1cm4gdmFsdWU7XG4gICAgfSxcbiAgICBtZXJnZUlmTmVlZGVkOiBmdW5jdGlvbihwYXJhbSwgY29tbW9uKSB7XG4gICAgICBsZXQgb2JqID0gcGFyYW0gfHwgY29tbW9uO1xuXG4gICAgICBpZiAocGFyYW0gJiYgY29tbW9uICYmIHBhcmFtICE9PSBjb21tb24pIHtcbiAgICAgICAgb2JqID0gVXRpbHMuZXh0ZW5kKHt9LCBjb21tb24sIHBhcmFtKTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIG9iajtcbiAgICB9LFxuICAgIC8vIEFuIGVtcHR5IG9iamVjdCB0byB1c2UgYXMgcmVwbGFjZW1lbnQgZm9yIG51bGwtY29udGV4dHNcbiAgICBudWxsQ29udGV4dDogT2JqZWN0LnNlYWwoe30pLFxuXG4gICAgbm9vcDogZW52LlZNLm5vb3AsXG4gICAgY29tcGlsZXJJbmZvOiB0ZW1wbGF0ZVNwZWMuY29tcGlsZXJcbiAgfTtcblxuICBmdW5jdGlvbiByZXQoY29udGV4dCwgb3B0aW9ucyA9IHt9KSB7XG4gICAgbGV0IGRhdGEgPSBvcHRpb25zLmRhdGE7XG5cbiAgICByZXQuX3NldHVwKG9wdGlvbnMpO1xuICAgIGlmICghb3B0aW9ucy5wYXJ0aWFsICYmIHRlbXBsYXRlU3BlYy51c2VEYXRhKSB7XG4gICAgICBkYXRhID0gaW5pdERhdGEoY29udGV4dCwgZGF0YSk7XG4gICAgfVxuICAgIGxldCBkZXB0aHMsXG4gICAgICBibG9ja1BhcmFtcyA9IHRlbXBsYXRlU3BlYy51c2VCbG9ja1BhcmFtcyA/IFtdIDogdW5kZWZpbmVkO1xuICAgIGlmICh0ZW1wbGF0ZVNwZWMudXNlRGVwdGhzKSB7XG4gICAgICBpZiAob3B0aW9ucy5kZXB0aHMpIHtcbiAgICAgICAgZGVwdGhzID1cbiAgICAgICAgICBjb250ZXh0ICE9IG9wdGlvbnMuZGVwdGhzWzBdXG4gICAgICAgICAgICA/IFtjb250ZXh0XS5jb25jYXQob3B0aW9ucy5kZXB0aHMpXG4gICAgICAgICAgICA6IG9wdGlvbnMuZGVwdGhzO1xuICAgICAgfSBlbHNlIHtcbiAgICAgICAgZGVwdGhzID0gW2NvbnRleHRdO1xuICAgICAgfVxuICAgIH1cblxuICAgIGZ1bmN0aW9uIG1haW4oY29udGV4dCAvKiwgb3B0aW9ucyovKSB7XG4gICAgICByZXR1cm4gKFxuICAgICAgICAnJyArXG4gICAgICAgIHRlbXBsYXRlU3BlYy5tYWluKFxuICAgICAgICAgIGNvbnRhaW5lcixcbiAgICAgICAgICBjb250ZXh0LFxuICAgICAgICAgIGNvbnRhaW5lci5oZWxwZXJzLFxuICAgICAgICAgIGNvbnRhaW5lci5wYXJ0aWFscyxcbiAgICAgICAgICBkYXRhLFxuICAgICAgICAgIGJsb2NrUGFyYW1zLFxuICAgICAgICAgIGRlcHRoc1xuICAgICAgICApXG4gICAgICApO1xuICAgIH1cblxuICAgIG1haW4gPSBleGVjdXRlRGVjb3JhdG9ycyhcbiAgICAgIHRlbXBsYXRlU3BlYy5tYWluLFxuICAgICAgbWFpbixcbiAgICAgIGNvbnRhaW5lcixcbiAgICAgIG9wdGlvbnMuZGVwdGhzIHx8IFtdLFxuICAgICAgZGF0YSxcbiAgICAgIGJsb2NrUGFyYW1zXG4gICAgKTtcbiAgICByZXR1cm4gbWFpbihjb250ZXh0LCBvcHRpb25zKTtcbiAgfVxuXG4gIHJldC5pc1RvcCA9IHRydWU7XG5cbiAgcmV0Ll9zZXR1cCA9IGZ1bmN0aW9uKG9wdGlvbnMpIHtcbiAgICBpZiAoIW9wdGlvbnMucGFydGlhbCkge1xuICAgICAgbGV0IG1lcmdlZEhlbHBlcnMgPSBVdGlscy5leHRlbmQoe30sIGVudi5oZWxwZXJzLCBvcHRpb25zLmhlbHBlcnMpO1xuICAgICAgd3JhcEhlbHBlcnNUb1Bhc3NMb29rdXBQcm9wZXJ0eShtZXJnZWRIZWxwZXJzLCBjb250YWluZXIpO1xuICAgICAgY29udGFpbmVyLmhlbHBlcnMgPSBtZXJnZWRIZWxwZXJzO1xuXG4gICAgICBpZiAodGVtcGxhdGVTcGVjLnVzZVBhcnRpYWwpIHtcbiAgICAgICAgLy8gVXNlIG1lcmdlSWZOZWVkZWQgaGVyZSB0byBwcmV2ZW50IGNvbXBpbGluZyBnbG9iYWwgcGFydGlhbHMgbXVsdGlwbGUgdGltZXNcbiAgICAgICAgY29udGFpbmVyLnBhcnRpYWxzID0gY29udGFpbmVyLm1lcmdlSWZOZWVkZWQoXG4gICAgICAgICAgb3B0aW9ucy5wYXJ0aWFscyxcbiAgICAgICAgICBlbnYucGFydGlhbHNcbiAgICAgICAgKTtcbiAgICAgIH1cbiAgICAgIGlmICh0ZW1wbGF0ZVNwZWMudXNlUGFydGlhbCB8fCB0ZW1wbGF0ZVNwZWMudXNlRGVjb3JhdG9ycykge1xuICAgICAgICBjb250YWluZXIuZGVjb3JhdG9ycyA9IFV0aWxzLmV4dGVuZChcbiAgICAgICAgICB7fSxcbiAgICAgICAgICBlbnYuZGVjb3JhdG9ycyxcbiAgICAgICAgICBvcHRpb25zLmRlY29yYXRvcnNcbiAgICAgICAgKTtcbiAgICAgIH1cblxuICAgICAgY29udGFpbmVyLmhvb2tzID0ge307XG4gICAgICBjb250YWluZXIucHJvdG9BY2Nlc3NDb250cm9sID0gY3JlYXRlUHJvdG9BY2Nlc3NDb250cm9sKG9wdGlvbnMpO1xuXG4gICAgICBsZXQga2VlcEhlbHBlckluSGVscGVycyA9XG4gICAgICAgIG9wdGlvbnMuYWxsb3dDYWxsc1RvSGVscGVyTWlzc2luZyB8fFxuICAgICAgICB0ZW1wbGF0ZVdhc1ByZWNvbXBpbGVkV2l0aENvbXBpbGVyVjc7XG4gICAgICBtb3ZlSGVscGVyVG9Ib29rcyhjb250YWluZXIsICdoZWxwZXJNaXNzaW5nJywga2VlcEhlbHBlckluSGVscGVycyk7XG4gICAgICBtb3ZlSGVscGVyVG9Ib29rcyhjb250YWluZXIsICdibG9ja0hlbHBlck1pc3NpbmcnLCBrZWVwSGVscGVySW5IZWxwZXJzKTtcbiAgICB9IGVsc2Uge1xuICAgICAgY29udGFpbmVyLnByb3RvQWNjZXNzQ29udHJvbCA9IG9wdGlvbnMucHJvdG9BY2Nlc3NDb250cm9sOyAvLyBpbnRlcm5hbCBvcHRpb25cbiAgICAgIGNvbnRhaW5lci5oZWxwZXJzID0gb3B0aW9ucy5oZWxwZXJzO1xuICAgICAgY29udGFpbmVyLnBhcnRpYWxzID0gb3B0aW9ucy5wYXJ0aWFscztcbiAgICAgIGNvbnRhaW5lci5kZWNvcmF0b3JzID0gb3B0aW9ucy5kZWNvcmF0b3JzO1xuICAgICAgY29udGFpbmVyLmhvb2tzID0gb3B0aW9ucy5ob29rcztcbiAgICB9XG4gIH07XG5cbiAgcmV0Ll9jaGlsZCA9IGZ1bmN0aW9uKGksIGRhdGEsIGJsb2NrUGFyYW1zLCBkZXB0aHMpIHtcbiAgICBpZiAodGVtcGxhdGVTcGVjLnVzZUJsb2NrUGFyYW1zICYmICFibG9ja1BhcmFtcykge1xuICAgICAgdGhyb3cgbmV3IEV4Y2VwdGlvbignbXVzdCBwYXNzIGJsb2NrIHBhcmFtcycpO1xuICAgIH1cbiAgICBpZiAodGVtcGxhdGVTcGVjLnVzZURlcHRocyAmJiAhZGVwdGhzKSB7XG4gICAgICB0aHJvdyBuZXcgRXhjZXB0aW9uKCdtdXN0IHBhc3MgcGFyZW50IGRlcHRocycpO1xuICAgIH1cblxuICAgIHJldHVybiB3cmFwUHJvZ3JhbShcbiAgICAgIGNvbnRhaW5lcixcbiAgICAgIGksXG4gICAgICB0ZW1wbGF0ZVNwZWNbaV0sXG4gICAgICBkYXRhLFxuICAgICAgMCxcbiAgICAgIGJsb2NrUGFyYW1zLFxuICAgICAgZGVwdGhzXG4gICAgKTtcbiAgfTtcbiAgcmV0dXJuIHJldDtcbn1cblxuZXhwb3J0IGZ1bmN0aW9uIHdyYXBQcm9ncmFtKFxuICBjb250YWluZXIsXG4gIGksXG4gIGZuLFxuICBkYXRhLFxuICBkZWNsYXJlZEJsb2NrUGFyYW1zLFxuICBibG9ja1BhcmFtcyxcbiAgZGVwdGhzXG4pIHtcbiAgZnVuY3Rpb24gcHJvZyhjb250ZXh0LCBvcHRpb25zID0ge30pIHtcbiAgICBsZXQgY3VycmVudERlcHRocyA9IGRlcHRocztcbiAgICBpZiAoXG4gICAgICBkZXB0aHMgJiZcbiAgICAgIGNvbnRleHQgIT0gZGVwdGhzWzBdICYmXG4gICAgICAhKGNvbnRleHQgPT09IGNvbnRhaW5lci5udWxsQ29udGV4dCAmJiBkZXB0aHNbMF0gPT09IG51bGwpXG4gICAgKSB7XG4gICAgICBjdXJyZW50RGVwdGhzID0gW2NvbnRleHRdLmNvbmNhdChkZXB0aHMpO1xuICAgIH1cblxuICAgIHJldHVybiBmbihcbiAgICAgIGNvbnRhaW5lcixcbiAgICAgIGNvbnRleHQsXG4gICAgICBjb250YWluZXIuaGVscGVycyxcbiAgICAgIGNvbnRhaW5lci5wYXJ0aWFscyxcbiAgICAgIG9wdGlvbnMuZGF0YSB8fCBkYXRhLFxuICAgICAgYmxvY2tQYXJhbXMgJiYgW29wdGlvbnMuYmxvY2tQYXJhbXNdLmNvbmNhdChibG9ja1BhcmFtcyksXG4gICAgICBjdXJyZW50RGVwdGhzXG4gICAgKTtcbiAgfVxuXG4gIHByb2cgPSBleGVjdXRlRGVjb3JhdG9ycyhmbiwgcHJvZywgY29udGFpbmVyLCBkZXB0aHMsIGRhdGEsIGJsb2NrUGFyYW1zKTtcblxuICBwcm9nLnByb2dyYW0gPSBpO1xuICBwcm9nLmRlcHRoID0gZGVwdGhzID8gZGVwdGhzLmxlbmd0aCA6IDA7XG4gIHByb2cuYmxvY2tQYXJhbXMgPSBkZWNsYXJlZEJsb2NrUGFyYW1zIHx8IDA7XG4gIHJldHVybiBwcm9nO1xufVxuXG4vKipcbiAqIFRoaXMgaXMgY3VycmVudGx5IHBhcnQgb2YgdGhlIG9mZmljaWFsIEFQSSwgdGhlcmVmb3JlIGltcGxlbWVudGF0aW9uIGRldGFpbHMgc2hvdWxkIG5vdCBiZSBjaGFuZ2VkLlxuICovXG5leHBvcnQgZnVuY3Rpb24gcmVzb2x2ZVBhcnRpYWwocGFydGlhbCwgY29udGV4dCwgb3B0aW9ucykge1xuICBpZiAoIXBhcnRpYWwpIHtcbiAgICBpZiAob3B0aW9ucy5uYW1lID09PSAnQHBhcnRpYWwtYmxvY2snKSB7XG4gICAgICBwYXJ0aWFsID0gb3B0aW9ucy5kYXRhWydwYXJ0aWFsLWJsb2NrJ107XG4gICAgfSBlbHNlIHtcbiAgICAgIHBhcnRpYWwgPSBvcHRpb25zLnBhcnRpYWxzW29wdGlvbnMubmFtZV07XG4gICAgfVxuICB9IGVsc2UgaWYgKCFwYXJ0aWFsLmNhbGwgJiYgIW9wdGlvbnMubmFtZSkge1xuICAgIC8vIFRoaXMgaXMgYSBkeW5hbWljIHBhcnRpYWwgdGhhdCByZXR1cm5lZCBhIHN0cmluZ1xuICAgIG9wdGlvbnMubmFtZSA9IHBhcnRpYWw7XG4gICAgcGFydGlhbCA9IG9wdGlvbnMucGFydGlhbHNbcGFydGlhbF07XG4gIH1cbiAgcmV0dXJuIHBhcnRpYWw7XG59XG5cbmV4cG9ydCBmdW5jdGlvbiBpbnZva2VQYXJ0aWFsKHBhcnRpYWwsIGNvbnRleHQsIG9wdGlvbnMpIHtcbiAgLy8gVXNlIHRoZSBjdXJyZW50IGNsb3N1cmUgY29udGV4dCB0byBzYXZlIHRoZSBwYXJ0aWFsLWJsb2NrIGlmIHRoaXMgcGFydGlhbFxuICBjb25zdCBjdXJyZW50UGFydGlhbEJsb2NrID0gb3B0aW9ucy5kYXRhICYmIG9wdGlvbnMuZGF0YVsncGFydGlhbC1ibG9jayddO1xuICBvcHRpb25zLnBhcnRpYWwgPSB0cnVlO1xuICBpZiAob3B0aW9ucy5pZHMpIHtcbiAgICBvcHRpb25zLmRhdGEuY29udGV4dFBhdGggPSBvcHRpb25zLmlkc1swXSB8fCBvcHRpb25zLmRhdGEuY29udGV4dFBhdGg7XG4gIH1cblxuICBsZXQgcGFydGlhbEJsb2NrO1xuICBpZiAob3B0aW9ucy5mbiAmJiBvcHRpb25zLmZuICE9PSBub29wKSB7XG4gICAgb3B0aW9ucy5kYXRhID0gY3JlYXRlRnJhbWUob3B0aW9ucy5kYXRhKTtcbiAgICAvLyBXcmFwcGVyIGZ1bmN0aW9uIHRvIGdldCBhY2Nlc3MgdG8gY3VycmVudFBhcnRpYWxCbG9jayBmcm9tIHRoZSBjbG9zdXJlXG4gICAgbGV0IGZuID0gb3B0aW9ucy5mbjtcbiAgICBwYXJ0aWFsQmxvY2sgPSBvcHRpb25zLmRhdGFbJ3BhcnRpYWwtYmxvY2snXSA9IGZ1bmN0aW9uIHBhcnRpYWxCbG9ja1dyYXBwZXIoXG4gICAgICBjb250ZXh0LFxuICAgICAgb3B0aW9ucyA9IHt9XG4gICAgKSB7XG4gICAgICAvLyBSZXN0b3JlIHRoZSBwYXJ0aWFsLWJsb2NrIGZyb20gdGhlIGNsb3N1cmUgZm9yIHRoZSBleGVjdXRpb24gb2YgdGhlIGJsb2NrXG4gICAgICAvLyBpLmUuIHRoZSBwYXJ0IGluc2lkZSB0aGUgYmxvY2sgb2YgdGhlIHBhcnRpYWwgY2FsbC5cbiAgICAgIG9wdGlvbnMuZGF0YSA9IGNyZWF0ZUZyYW1lKG9wdGlvbnMuZGF0YSk7XG4gICAgICBvcHRpb25zLmRhdGFbJ3BhcnRpYWwtYmxvY2snXSA9IGN1cnJlbnRQYXJ0aWFsQmxvY2s7XG4gICAgICByZXR1cm4gZm4oY29udGV4dCwgb3B0aW9ucyk7XG4gICAgfTtcbiAgICBpZiAoZm4ucGFydGlhbHMpIHtcbiAgICAgIG9wdGlvbnMucGFydGlhbHMgPSBVdGlscy5leHRlbmQoe30sIG9wdGlvbnMucGFydGlhbHMsIGZuLnBhcnRpYWxzKTtcbiAgICB9XG4gIH1cblxuICBpZiAocGFydGlhbCA9PT0gdW5kZWZpbmVkICYmIHBhcnRpYWxCbG9jaykge1xuICAgIHBhcnRpYWwgPSBwYXJ0aWFsQmxvY2s7XG4gIH1cblxuICBpZiAocGFydGlhbCA9PT0gdW5kZWZpbmVkKSB7XG4gICAgdGhyb3cgbmV3IEV4Y2VwdGlvbignVGhlIHBhcnRpYWwgJyArIG9wdGlvbnMubmFtZSArICcgY291bGQgbm90IGJlIGZvdW5kJyk7XG4gIH0gZWxzZSBpZiAocGFydGlhbCBpbnN0YW5jZW9mIEZ1bmN0aW9uKSB7XG4gICAgcmV0dXJuIHBhcnRpYWwoY29udGV4dCwgb3B0aW9ucyk7XG4gIH1cbn1cblxuZXhwb3J0IGZ1bmN0aW9uIG5vb3AoKSB7XG4gIHJldHVybiAnJztcbn1cblxuZnVuY3Rpb24gaW5pdERhdGEoY29udGV4dCwgZGF0YSkge1xuICBpZiAoIWRhdGEgfHwgISgncm9vdCcgaW4gZGF0YSkpIHtcbiAgICBkYXRhID0gZGF0YSA/IGNyZWF0ZUZyYW1lKGRhdGEpIDoge307XG4gICAgZGF0YS5yb290ID0gY29udGV4dDtcbiAgfVxuICByZXR1cm4gZGF0YTtcbn1cblxuZnVuY3Rpb24gZXhlY3V0ZURlY29yYXRvcnMoZm4sIHByb2csIGNvbnRhaW5lciwgZGVwdGhzLCBkYXRhLCBibG9ja1BhcmFtcykge1xuICBpZiAoZm4uZGVjb3JhdG9yKSB7XG4gICAgbGV0IHByb3BzID0ge307XG4gICAgcHJvZyA9IGZuLmRlY29yYXRvcihcbiAgICAgIHByb2csXG4gICAgICBwcm9wcyxcbiAgICAgIGNvbnRhaW5lcixcbiAgICAgIGRlcHRocyAmJiBkZXB0aHNbMF0sXG4gICAgICBkYXRhLFxuICAgICAgYmxvY2tQYXJhbXMsXG4gICAgICBkZXB0aHNcbiAgICApO1xuICAgIFV0aWxzLmV4dGVuZChwcm9nLCBwcm9wcyk7XG4gIH1cbiAgcmV0dXJuIHByb2c7XG59XG5cbmZ1bmN0aW9uIHdyYXBIZWxwZXJzVG9QYXNzTG9va3VwUHJvcGVydHkobWVyZ2VkSGVscGVycywgY29udGFpbmVyKSB7XG4gIE9iamVjdC5rZXlzKG1lcmdlZEhlbHBlcnMpLmZvckVhY2goaGVscGVyTmFtZSA9PiB7XG4gICAgbGV0IGhlbHBlciA9IG1lcmdlZEhlbHBlcnNbaGVscGVyTmFtZV07XG4gICAgbWVyZ2VkSGVscGVyc1toZWxwZXJOYW1lXSA9IHBhc3NMb29rdXBQcm9wZXJ0eU9wdGlvbihoZWxwZXIsIGNvbnRhaW5lcik7XG4gIH0pO1xufVxuXG5mdW5jdGlvbiBwYXNzTG9va3VwUHJvcGVydHlPcHRpb24oaGVscGVyLCBjb250YWluZXIpIHtcbiAgY29uc3QgbG9va3VwUHJvcGVydHkgPSBjb250YWluZXIubG9va3VwUHJvcGVydHk7XG4gIHJldHVybiB3cmFwSGVscGVyKGhlbHBlciwgb3B0aW9ucyA9PiB7XG4gICAgcmV0dXJuIFV0aWxzLmV4dGVuZCh7IGxvb2t1cFByb3BlcnR5IH0sIG9wdGlvbnMpO1xuICB9KTtcbn1cbiJdfQ==


/***/ }),
/* 376 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;
exports.wrapHelper = wrapHelper;

function wrapHelper(helper, transformOptionsFn) {
  if (typeof helper !== 'function') {
    // This should not happen, but apparently it does in https://github.com/wycats/handlebars.js/issues/1639
    // We try to make the wrapper least-invasive by not wrapping it, if the helper is not a function.
    return helper;
  }
  var wrapper = function wrapper() /* dynamic arguments */{
    var options = arguments[arguments.length - 1];
    arguments[arguments.length - 1] = transformOptionsFn(options);
    return helper.apply(this, arguments);
  };
  return wrapper;
}
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL2ludGVybmFsL3dyYXBIZWxwZXIuanMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7Ozs7QUFBTyxTQUFTLFVBQVUsQ0FBQyxNQUFNLEVBQUUsa0JBQWtCLEVBQUU7QUFDckQsTUFBSSxPQUFPLE1BQU0sS0FBSyxVQUFVLEVBQUU7OztBQUdoQyxXQUFPLE1BQU0sQ0FBQztHQUNmO0FBQ0QsTUFBSSxPQUFPLEdBQUcsU0FBVixPQUFPLDBCQUFxQztBQUM5QyxRQUFNLE9BQU8sR0FBRyxTQUFTLENBQUMsU0FBUyxDQUFDLE1BQU0sR0FBRyxDQUFDLENBQUMsQ0FBQztBQUNoRCxhQUFTLENBQUMsU0FBUyxDQUFDLE1BQU0sR0FBRyxDQUFDLENBQUMsR0FBRyxrQkFBa0IsQ0FBQyxPQUFPLENBQUMsQ0FBQztBQUM5RCxXQUFPLE1BQU0sQ0FBQyxLQUFLLENBQUMsSUFBSSxFQUFFLFNBQVMsQ0FBQyxDQUFDO0dBQ3RDLENBQUM7QUFDRixTQUFPLE9BQU8sQ0FBQztDQUNoQiIsImZpbGUiOiJ3cmFwSGVscGVyLmpzIiwic291cmNlc0NvbnRlbnQiOlsiZXhwb3J0IGZ1bmN0aW9uIHdyYXBIZWxwZXIoaGVscGVyLCB0cmFuc2Zvcm1PcHRpb25zRm4pIHtcbiAgaWYgKHR5cGVvZiBoZWxwZXIgIT09ICdmdW5jdGlvbicpIHtcbiAgICAvLyBUaGlzIHNob3VsZCBub3QgaGFwcGVuLCBidXQgYXBwYXJlbnRseSBpdCBkb2VzIGluIGh0dHBzOi8vZ2l0aHViLmNvbS93eWNhdHMvaGFuZGxlYmFycy5qcy9pc3N1ZXMvMTYzOVxuICAgIC8vIFdlIHRyeSB0byBtYWtlIHRoZSB3cmFwcGVyIGxlYXN0LWludmFzaXZlIGJ5IG5vdCB3cmFwcGluZyBpdCwgaWYgdGhlIGhlbHBlciBpcyBub3QgYSBmdW5jdGlvbi5cbiAgICByZXR1cm4gaGVscGVyO1xuICB9XG4gIGxldCB3cmFwcGVyID0gZnVuY3Rpb24oLyogZHluYW1pYyBhcmd1bWVudHMgKi8pIHtcbiAgICBjb25zdCBvcHRpb25zID0gYXJndW1lbnRzW2FyZ3VtZW50cy5sZW5ndGggLSAxXTtcbiAgICBhcmd1bWVudHNbYXJndW1lbnRzLmxlbmd0aCAtIDFdID0gdHJhbnNmb3JtT3B0aW9uc0ZuKG9wdGlvbnMpO1xuICAgIHJldHVybiBoZWxwZXIuYXBwbHkodGhpcywgYXJndW1lbnRzKTtcbiAgfTtcbiAgcmV0dXJuIHdyYXBwZXI7XG59XG4iXX0=


/***/ }),
/* 377 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/* WEBPACK VAR INJECTION */(function(global) {

exports.__esModule = true;

exports['default'] = function (Handlebars) {
  /* istanbul ignore next */
  var root = typeof global !== 'undefined' ? global : window,
      $Handlebars = root.Handlebars;
  /* istanbul ignore next */
  Handlebars.noConflict = function () {
    if (root.Handlebars === Handlebars) {
      root.Handlebars = $Handlebars;
    }
    return Handlebars;
  };
};

module.exports = exports['default'];
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL25vLWNvbmZsaWN0LmpzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7Ozs7cUJBQWUsVUFBUyxVQUFVLEVBQUU7O0FBRWxDLE1BQUksSUFBSSxHQUFHLE9BQU8sTUFBTSxLQUFLLFdBQVcsR0FBRyxNQUFNLEdBQUcsTUFBTTtNQUN4RCxXQUFXLEdBQUcsSUFBSSxDQUFDLFVBQVUsQ0FBQzs7QUFFaEMsWUFBVSxDQUFDLFVBQVUsR0FBRyxZQUFXO0FBQ2pDLFFBQUksSUFBSSxDQUFDLFVBQVUsS0FBSyxVQUFVLEVBQUU7QUFDbEMsVUFBSSxDQUFDLFVBQVUsR0FBRyxXQUFXLENBQUM7S0FDL0I7QUFDRCxXQUFPLFVBQVUsQ0FBQztHQUNuQixDQUFDO0NBQ0giLCJmaWxlIjoibm8tY29uZmxpY3QuanMiLCJzb3VyY2VzQ29udGVudCI6WyJleHBvcnQgZGVmYXVsdCBmdW5jdGlvbihIYW5kbGViYXJzKSB7XG4gIC8qIGlzdGFuYnVsIGlnbm9yZSBuZXh0ICovXG4gIGxldCByb290ID0gdHlwZW9mIGdsb2JhbCAhPT0gJ3VuZGVmaW5lZCcgPyBnbG9iYWwgOiB3aW5kb3csXG4gICAgJEhhbmRsZWJhcnMgPSByb290LkhhbmRsZWJhcnM7XG4gIC8qIGlzdGFuYnVsIGlnbm9yZSBuZXh0ICovXG4gIEhhbmRsZWJhcnMubm9Db25mbGljdCA9IGZ1bmN0aW9uKCkge1xuICAgIGlmIChyb290LkhhbmRsZWJhcnMgPT09IEhhbmRsZWJhcnMpIHtcbiAgICAgIHJvb3QuSGFuZGxlYmFycyA9ICRIYW5kbGViYXJzO1xuICAgIH1cbiAgICByZXR1cm4gSGFuZGxlYmFycztcbiAgfTtcbn1cbiJdfQ==

/* WEBPACK VAR INJECTION */}.call(this, __webpack_require__(55)))

/***/ }),
/* 378 */
/***/ (function(module, exports, __webpack_require__) {

this["Mura"]=__webpack_require__(9);
this["Mura"]["templates"] = this["Mura"]["templates"] || {};

this["Mura"]["templates"]["checkbox_static"] = this.Mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return container.escapeExpression(((helper = (helper = lookupProperty(helpers,"summary") || (depth0 != null ? lookupProperty(depth0,"summary") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"summary","hash":{},"data":data,"loc":{"start":{"line":4,"column":18},"end":{"line":4,"column":29}}}) : helper)));
},"3":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return container.escapeExpression(((helper = (helper = lookupProperty(helpers,"label") || (depth0 != null ? lookupProperty(depth0,"label") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"label","hash":{},"data":data,"loc":{"start":{"line":4,"column":37},"end":{"line":4,"column":46}}}) : helper)));
},"5":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return " <ins>"
    + container.escapeExpression(((helper = (helper = lookupProperty(helpers,"formRequiredLabel") || (depth0 != null ? lookupProperty(depth0,"formRequiredLabel") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"formRequiredLabel","hash":{},"data":data,"loc":{"start":{"line":4,"column":77},"end":{"line":4,"column":98}}}) : helper)))
    + "</ins>";
},"7":function(container,depth0,helpers,partials,data) {
    return "</br>";
},"9":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "			<div class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"checkboxWrapperClass") || (depth0 != null ? lookupProperty(depth0,"checkboxWrapperClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"checkboxWrapperClass","hash":{},"data":data,"loc":{"start":{"line":8,"column":15},"end":{"line":8,"column":41}}}) : helper))) != null ? stack1 : "")
    + "\">\r\n				<input type=\"checkbox\" name=\""
    + alias4(container.lambda((depths[1] != null ? lookupProperty(depths[1],"name") : depths[1]), depth0))
    + "\" class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"checkboxClass") || (depth0 != null ? lookupProperty(depth0,"checkboxClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"checkboxClass","hash":{},"data":data,"loc":{"start":{"line":9,"column":53},"end":{"line":9,"column":72}}}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = lookupProperty(helpers,"datarecordid") || (depth0 != null ? lookupProperty(depth0,"datarecordid") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"datarecordid","hash":{},"data":data,"loc":{"start":{"line":9,"column":84},"end":{"line":9,"column":100}}}) : helper)))
    + "\" value=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"value") || (depth0 != null ? lookupProperty(depth0,"value") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"value","hash":{},"data":data,"loc":{"start":{"line":9,"column":109},"end":{"line":9,"column":118}}}) : helper)))
    + "\" "
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"isselected") : depth0),{"name":"if","hash":{},"fn":container.program(10, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":9,"column":120},"end":{"line":9,"column":163}}})) != null ? stack1 : "")
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"selected") : depth0),{"name":"if","hash":{},"fn":container.program(10, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":9,"column":163},"end":{"line":9,"column":204}}})) != null ? stack1 : "")
    + "/>\r\n				<label class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"checkboxLabelClass") || (depth0 != null ? lookupProperty(depth0,"checkboxLabelClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"checkboxLabelClass","hash":{},"data":data,"loc":{"start":{"line":10,"column":18},"end":{"line":10,"column":42}}}) : helper))) != null ? stack1 : "")
    + "\" for=\"field-"
    + alias4(((helper = (helper = lookupProperty(helpers,"datarecordid") || (depth0 != null ? lookupProperty(depth0,"datarecordid") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"datarecordid","hash":{},"data":data,"loc":{"start":{"line":10,"column":55},"end":{"line":10,"column":71}}}) : helper)))
    + "\">"
    + alias4(((helper = (helper = lookupProperty(helpers,"label") || (depth0 != null ? lookupProperty(depth0,"label") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data,"loc":{"start":{"line":10,"column":73},"end":{"line":10,"column":82}}}) : helper)))
    + "</label>\r\n			</div>\r\n";
},"10":function(container,depth0,helpers,partials,data) {
    return " checked='checked'";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "<div class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"inputWrapperClass") || (depth0 != null ? lookupProperty(depth0,"inputWrapperClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data,"loc":{"start":{"line":1,"column":12},"end":{"line":1,"column":35}}}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":1,"column":47},"end":{"line":1,"column":55}}}) : helper)))
    + "-container\">\r\n	<div class=\"mura-checkbox-group\">\r\n		<label class=\"mura-group-label\" for=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":3,"column":39},"end":{"line":3,"column":47}}}) : helper)))
    + "\">\r\n			"
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"summary") : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.program(3, data, 0, blockParams, depths),"data":data,"loc":{"start":{"line":4,"column":3},"end":{"line":4,"column":53}}})) != null ? stack1 : "")
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"isrequired") : depth0),{"name":"if","hash":{},"fn":container.program(5, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":4,"column":53},"end":{"line":4,"column":111}}})) != null ? stack1 : "")
    + "\r\n		</label>\r\n		"
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"summary") : depth0),{"name":"if","hash":{},"fn":container.program(7, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":6,"column":2},"end":{"line":6,"column":29}}})) != null ? stack1 : "")
    + "\r\n"
    + ((stack1 = (lookupProperty(helpers,"eachStatic")||(depth0 && lookupProperty(depth0,"eachStatic"))||alias2).call(alias1,(depth0 != null ? lookupProperty(depth0,"dataset") : depth0),{"name":"eachStatic","hash":{},"fn":container.program(9, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":7,"column":2},"end":{"line":12,"column":17}}})) != null ? stack1 : "")
    + "	</div>\r\n</div>\r\n";
},"useData":true,"useDepths":true});

this["Mura"]["templates"]["checkbox"] = this.Mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return container.escapeExpression(((helper = (helper = lookupProperty(helpers,"summary") || (depth0 != null ? lookupProperty(depth0,"summary") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"summary","hash":{},"data":data,"loc":{"start":{"line":4,"column":18},"end":{"line":4,"column":29}}}) : helper)));
},"3":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return container.escapeExpression(((helper = (helper = lookupProperty(helpers,"label") || (depth0 != null ? lookupProperty(depth0,"label") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"label","hash":{},"data":data,"loc":{"start":{"line":4,"column":37},"end":{"line":4,"column":46}}}) : helper)));
},"5":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return " <ins>"
    + container.escapeExpression(((helper = (helper = lookupProperty(helpers,"formRequiredLabel") || (depth0 != null ? lookupProperty(depth0,"formRequiredLabel") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"formRequiredLabel","hash":{},"data":data,"loc":{"start":{"line":4,"column":77},"end":{"line":4,"column":98}}}) : helper)))
    + "</ins>";
},"7":function(container,depth0,helpers,partials,data) {
    return "</br>";
},"9":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.lambda, alias5=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "			<div class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"checkboxWrapperClass") || (depth0 != null ? lookupProperty(depth0,"checkboxWrapperClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"checkboxWrapperClass","hash":{},"data":data,"loc":{"start":{"line":8,"column":15},"end":{"line":8,"column":41}}}) : helper))) != null ? stack1 : "")
    + "\">\r\n				<input source=\""
    + alias5(alias4(((stack1 = (depths[1] != null ? lookupProperty(depths[1],"dataset") : depths[1])) != null ? lookupProperty(stack1,"source") : stack1), depth0))
    + "\" class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"checkboxClass") || (depth0 != null ? lookupProperty(depth0,"checkboxClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"checkboxClass","hash":{},"data":data,"loc":{"start":{"line":9,"column":49},"end":{"line":9,"column":68}}}) : helper))) != null ? stack1 : "")
    + "\" type=\"checkbox\" name=\""
    + alias5(alias4((depths[1] != null ? lookupProperty(depths[1],"name") : depths[1]), depth0))
    + "\" id=\"field-"
    + alias5(((helper = (helper = lookupProperty(helpers,"id") || (depth0 != null ? lookupProperty(depth0,"id") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"id","hash":{},"data":data,"loc":{"start":{"line":9,"column":115},"end":{"line":9,"column":121}}}) : helper)))
    + "\" value=\""
    + alias5(((helper = (helper = lookupProperty(helpers,"id") || (depth0 != null ? lookupProperty(depth0,"id") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"id","hash":{},"data":data,"loc":{"start":{"line":9,"column":130},"end":{"line":9,"column":136}}}) : helper)))
    + "\" "
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"isselected") : depth0),{"name":"if","hash":{},"fn":container.program(10, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":9,"column":138},"end":{"line":9,"column":180}}})) != null ? stack1 : "")
    + "/>\r\n				<label class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"checkboxLabelClass") || (depth0 != null ? lookupProperty(depth0,"checkboxLabelClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"checkboxLabelClass","hash":{},"data":data,"loc":{"start":{"line":10,"column":18},"end":{"line":10,"column":42}}}) : helper))) != null ? stack1 : "")
    + "\" for=\"field-"
    + alias5(((helper = (helper = lookupProperty(helpers,"id") || (depth0 != null ? lookupProperty(depth0,"id") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"id","hash":{},"data":data,"loc":{"start":{"line":10,"column":55},"end":{"line":10,"column":61}}}) : helper)))
    + "\">"
    + alias5(((helper = (helper = lookupProperty(helpers,"label") || (depth0 != null ? lookupProperty(depth0,"label") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data,"loc":{"start":{"line":10,"column":63},"end":{"line":10,"column":72}}}) : helper)))
    + "</label>\r\n			</div>\r\n";
},"10":function(container,depth0,helpers,partials,data) {
    return "checked='checked'";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "<div class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"inputWrapperClass") || (depth0 != null ? lookupProperty(depth0,"inputWrapperClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data,"loc":{"start":{"line":1,"column":12},"end":{"line":1,"column":35}}}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":1,"column":47},"end":{"line":1,"column":55}}}) : helper)))
    + "-container\">\r\n	<div class=\"mura-checkbox-group\">\r\n		<label class=\"mura-group-label\" for=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":3,"column":39},"end":{"line":3,"column":47}}}) : helper)))
    + "\">\r\n			"
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"summary") : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.program(3, data, 0, blockParams, depths),"data":data,"loc":{"start":{"line":4,"column":3},"end":{"line":4,"column":53}}})) != null ? stack1 : "")
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"isrequired") : depth0),{"name":"if","hash":{},"fn":container.program(5, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":4,"column":53},"end":{"line":4,"column":111}}})) != null ? stack1 : "")
    + "\r\n		</label>\r\n		"
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"summary") : depth0),{"name":"if","hash":{},"fn":container.program(7, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":6,"column":2},"end":{"line":6,"column":29}}})) != null ? stack1 : "")
    + "\r\n"
    + ((stack1 = (lookupProperty(helpers,"eachCheck")||(depth0 && lookupProperty(depth0,"eachCheck"))||alias2).call(alias1,((stack1 = (depth0 != null ? lookupProperty(depth0,"dataset") : depth0)) != null ? lookupProperty(stack1,"options") : stack1),(depth0 != null ? lookupProperty(depth0,"selected") : depth0),{"name":"eachCheck","hash":{},"fn":container.program(9, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":7,"column":2},"end":{"line":12,"column":16}}})) != null ? stack1 : "")
    + "	</div>\r\n</div>\r\n";
},"useData":true,"useDepths":true});

this["Mura"]["templates"]["dropdown_static"] = this.Mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return container.escapeExpression(((helper = (helper = lookupProperty(helpers,"summary") || (depth0 != null ? lookupProperty(depth0,"summary") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"summary","hash":{},"data":data,"loc":{"start":{"line":2,"column":68},"end":{"line":2,"column":79}}}) : helper)));
},"3":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return container.escapeExpression(((helper = (helper = lookupProperty(helpers,"label") || (depth0 != null ? lookupProperty(depth0,"label") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"label","hash":{},"data":data,"loc":{"start":{"line":2,"column":87},"end":{"line":2,"column":96}}}) : helper)));
},"5":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return " <ins>"
    + container.escapeExpression(((helper = (helper = lookupProperty(helpers,"formRequiredLabel") || (depth0 != null ? lookupProperty(depth0,"formRequiredLabel") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"formRequiredLabel","hash":{},"data":data,"loc":{"start":{"line":2,"column":127},"end":{"line":2,"column":148}}}) : helper)))
    + "</ins>";
},"7":function(container,depth0,helpers,partials,data) {
    return "</br>";
},"9":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "				<option data-isother=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"isother") || (depth0 != null ? lookupProperty(depth0,"isother") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"isother","hash":{},"data":data,"loc":{"start":{"line":6,"column":26},"end":{"line":6,"column":37}}}) : helper)))
    + "\" id=\"field-"
    + alias4(((helper = (helper = lookupProperty(helpers,"datarecordid") || (depth0 != null ? lookupProperty(depth0,"datarecordid") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"datarecordid","hash":{},"data":data,"loc":{"start":{"line":6,"column":49},"end":{"line":6,"column":65}}}) : helper)))
    + "\" value=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"value") || (depth0 != null ? lookupProperty(depth0,"value") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"value","hash":{},"data":data,"loc":{"start":{"line":6,"column":74},"end":{"line":6,"column":83}}}) : helper)))
    + "\" "
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"isselected") : depth0),{"name":"if","hash":{},"fn":container.program(10, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":6,"column":85},"end":{"line":6,"column":129}}})) != null ? stack1 : "")
    + ">"
    + alias4(((helper = (helper = lookupProperty(helpers,"label") || (depth0 != null ? lookupProperty(depth0,"label") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data,"loc":{"start":{"line":6,"column":130},"end":{"line":6,"column":139}}}) : helper)))
    + "</option>\n";
},"10":function(container,depth0,helpers,partials,data) {
    return "selected='selected'";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "	<div class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"inputWrapperClass") || (depth0 != null ? lookupProperty(depth0,"inputWrapperClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data,"loc":{"start":{"line":1,"column":13},"end":{"line":1,"column":36}}}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":1,"column":48},"end":{"line":1,"column":56}}}) : helper)))
    + "-container\">\n		<label for=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"labelForValue") || (depth0 != null ? lookupProperty(depth0,"labelForValue") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"labelForValue","hash":{},"data":data,"loc":{"start":{"line":2,"column":14},"end":{"line":2,"column":31}}}) : helper)))
    + "\" data-for=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":2,"column":43},"end":{"line":2,"column":51}}}) : helper)))
    + "\">"
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"summary") : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0),"inverse":container.program(3, data, 0),"data":data,"loc":{"start":{"line":2,"column":53},"end":{"line":2,"column":103}}})) != null ? stack1 : "")
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"isrequired") : depth0),{"name":"if","hash":{},"fn":container.program(5, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":2,"column":103},"end":{"line":2,"column":161}}})) != null ? stack1 : "")
    + "</label>\n		"
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"summary") : depth0),{"name":"if","hash":{},"fn":container.program(7, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":3,"column":2},"end":{"line":3,"column":29}}})) != null ? stack1 : "")
    + "\n		<select "
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"commonInputAttributes") || (depth0 != null ? lookupProperty(depth0,"commonInputAttributes") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"commonInputAttributes","hash":{},"data":data,"loc":{"start":{"line":4,"column":10},"end":{"line":4,"column":37}}}) : helper))) != null ? stack1 : "")
    + ">\n"
    + ((stack1 = (lookupProperty(helpers,"eachStatic")||(depth0 && lookupProperty(depth0,"eachStatic"))||alias2).call(alias1,(depth0 != null ? lookupProperty(depth0,"dataset") : depth0),{"name":"eachStatic","hash":{},"fn":container.program(9, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":5,"column":3},"end":{"line":7,"column":18}}})) != null ? stack1 : "")
    + "		</select>\n	</div>\n";
},"useData":true});

this["Mura"]["templates"]["dropdown"] = this.Mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return container.escapeExpression(((helper = (helper = lookupProperty(helpers,"summary") || (depth0 != null ? lookupProperty(depth0,"summary") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"summary","hash":{},"data":data,"loc":{"start":{"line":2,"column":68},"end":{"line":2,"column":79}}}) : helper)));
},"3":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return container.escapeExpression(((helper = (helper = lookupProperty(helpers,"label") || (depth0 != null ? lookupProperty(depth0,"label") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"label","hash":{},"data":data,"loc":{"start":{"line":2,"column":87},"end":{"line":2,"column":96}}}) : helper)));
},"5":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return " <ins>"
    + container.escapeExpression(((helper = (helper = lookupProperty(helpers,"formRequiredLabel") || (depth0 != null ? lookupProperty(depth0,"formRequiredLabel") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"formRequiredLabel","hash":{},"data":data,"loc":{"start":{"line":2,"column":127},"end":{"line":2,"column":148}}}) : helper)))
    + "</ins>";
},"7":function(container,depth0,helpers,partials,data) {
    return "</br>";
},"9":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "					<option data-isother=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"isother") || (depth0 != null ? lookupProperty(depth0,"isother") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"isother","hash":{},"data":data,"loc":{"start":{"line":6,"column":27},"end":{"line":6,"column":38}}}) : helper)))
    + "\" id=\"field-"
    + alias4(((helper = (helper = lookupProperty(helpers,"id") || (depth0 != null ? lookupProperty(depth0,"id") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"id","hash":{},"data":data,"loc":{"start":{"line":6,"column":50},"end":{"line":6,"column":56}}}) : helper)))
    + "\" value=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"id") || (depth0 != null ? lookupProperty(depth0,"id") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"id","hash":{},"data":data,"loc":{"start":{"line":6,"column":65},"end":{"line":6,"column":71}}}) : helper)))
    + "\" "
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"isselected") : depth0),{"name":"if","hash":{},"fn":container.program(10, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":6,"column":73},"end":{"line":6,"column":117}}})) != null ? stack1 : "")
    + ">"
    + alias4(((helper = (helper = lookupProperty(helpers,"label") || (depth0 != null ? lookupProperty(depth0,"label") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data,"loc":{"start":{"line":6,"column":118},"end":{"line":6,"column":127}}}) : helper)))
    + "</option>\n";
},"10":function(container,depth0,helpers,partials,data) {
    return "selected='selected'";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "	<div class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"inputWrapperClass") || (depth0 != null ? lookupProperty(depth0,"inputWrapperClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data,"loc":{"start":{"line":1,"column":13},"end":{"line":1,"column":36}}}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":1,"column":48},"end":{"line":1,"column":56}}}) : helper)))
    + "-container\">\n		<label for=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"labelForValue") || (depth0 != null ? lookupProperty(depth0,"labelForValue") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"labelForValue","hash":{},"data":data,"loc":{"start":{"line":2,"column":14},"end":{"line":2,"column":31}}}) : helper)))
    + "\" data-for=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":2,"column":43},"end":{"line":2,"column":51}}}) : helper)))
    + "\">"
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"summary") : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0),"inverse":container.program(3, data, 0),"data":data,"loc":{"start":{"line":2,"column":53},"end":{"line":2,"column":103}}})) != null ? stack1 : "")
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"isrequired") : depth0),{"name":"if","hash":{},"fn":container.program(5, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":2,"column":103},"end":{"line":2,"column":161}}})) != null ? stack1 : "")
    + "</label>\n		"
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"summary") : depth0),{"name":"if","hash":{},"fn":container.program(7, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":3,"column":2},"end":{"line":3,"column":29}}})) != null ? stack1 : "")
    + "\n			<select "
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"commonInputAttributes") || (depth0 != null ? lookupProperty(depth0,"commonInputAttributes") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"commonInputAttributes","hash":{},"data":data,"loc":{"start":{"line":4,"column":11},"end":{"line":4,"column":38}}}) : helper))) != null ? stack1 : "")
    + ">\n"
    + ((stack1 = lookupProperty(helpers,"each").call(alias1,((stack1 = (depth0 != null ? lookupProperty(depth0,"dataset") : depth0)) != null ? lookupProperty(stack1,"options") : stack1),{"name":"each","hash":{},"fn":container.program(9, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":5,"column":4},"end":{"line":7,"column":13}}})) != null ? stack1 : "")
    + "			</select>\n	</div>\n";
},"useData":true});

this["Mura"]["templates"]["error"] = this.Mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return container.escapeExpression(((helper = (helper = lookupProperty(helpers,"label") || (depth0 != null ? lookupProperty(depth0,"label") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"label","hash":{},"data":data,"loc":{"start":{"line":1,"column":77},"end":{"line":1,"column":86}}}) : helper)))
    + ": ";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "<div class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"formErrorWrapperClass") || (depth0 != null ? lookupProperty(depth0,"formErrorWrapperClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"formErrorWrapperClass","hash":{},"data":data,"loc":{"start":{"line":1,"column":12},"end":{"line":1,"column":39}}}) : helper))) != null ? stack1 : "")
    + "\" data-field=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"field") || (depth0 != null ? lookupProperty(depth0,"field") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"field","hash":{},"data":data,"loc":{"start":{"line":1,"column":53},"end":{"line":1,"column":62}}}) : helper)))
    + "\">"
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"label") : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":1,"column":64},"end":{"line":1,"column":95}}})) != null ? stack1 : "")
    + alias4(((helper = (helper = lookupProperty(helpers,"message") || (depth0 != null ? lookupProperty(depth0,"message") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"message","hash":{},"data":data,"loc":{"start":{"line":1,"column":95},"end":{"line":1,"column":106}}}) : helper)))
    + "</div>\r\n";
},"useData":true});

this["Mura"]["templates"]["file"] = this.Mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return " <ins>"
    + container.escapeExpression(((helper = (helper = lookupProperty(helpers,"formRequiredLabel") || (depth0 != null ? lookupProperty(depth0,"formRequiredLabel") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"formRequiredLabel","hash":{},"data":data,"loc":{"start":{"line":2,"column":85},"end":{"line":2,"column":106}}}) : helper)))
    + "</ins>";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "<div class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"inputWrapperClass") || (depth0 != null ? lookupProperty(depth0,"inputWrapperClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data,"loc":{"start":{"line":1,"column":12},"end":{"line":1,"column":35}}}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":1,"column":47},"end":{"line":1,"column":55}}}) : helper)))
    + "-container\">\r\n	<label for=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"labelForValue") || (depth0 != null ? lookupProperty(depth0,"labelForValue") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"labelForValue","hash":{},"data":data,"loc":{"start":{"line":2,"column":13},"end":{"line":2,"column":30}}}) : helper)))
    + "\" data-for=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":2,"column":42},"end":{"line":2,"column":50}}}) : helper)))
    + "\">"
    + alias4(((helper = (helper = lookupProperty(helpers,"label") || (depth0 != null ? lookupProperty(depth0,"label") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data,"loc":{"start":{"line":2,"column":52},"end":{"line":2,"column":61}}}) : helper)))
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"isrequired") : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":2,"column":61},"end":{"line":2,"column":119}}})) != null ? stack1 : "")
    + "</label>\r\n	<input type=\"file\" "
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"commonInputAttributes") || (depth0 != null ? lookupProperty(depth0,"commonInputAttributes") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"commonInputAttributes","hash":{},"data":data,"loc":{"start":{"line":3,"column":20},"end":{"line":3,"column":47}}}) : helper))) != null ? stack1 : "")
    + "/>\r\n</div>\r\n";
},"useData":true});

this["Mura"]["templates"]["form"] = this.Mura.Handlebars.template({"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "<form id=\"frm"
    + alias4(((helper = (helper = lookupProperty(helpers,"objectid") || (depth0 != null ? lookupProperty(depth0,"objectid") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"objectid","hash":{},"data":data,"loc":{"start":{"line":1,"column":13},"end":{"line":1,"column":25}}}) : helper)))
    + "\" class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"formClass") || (depth0 != null ? lookupProperty(depth0,"formClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"formClass","hash":{},"data":data,"loc":{"start":{"line":1,"column":34},"end":{"line":1,"column":49}}}) : helper))) != null ? stack1 : "")
    + "\" novalidate=\"novalidate\" enctype=\"multipart/form-data\">\n<div class=\"error-container-"
    + alias4(((helper = (helper = lookupProperty(helpers,"objectid") || (depth0 != null ? lookupProperty(depth0,"objectid") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"objectid","hash":{},"data":data,"loc":{"start":{"line":2,"column":28},"end":{"line":2,"column":40}}}) : helper)))
    + "\">\n</div>\n<div class=\"field-container-"
    + alias4(((helper = (helper = lookupProperty(helpers,"objectid") || (depth0 != null ? lookupProperty(depth0,"objectid") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"objectid","hash":{},"data":data,"loc":{"start":{"line":4,"column":28},"end":{"line":4,"column":40}}}) : helper)))
    + "\">\n</div>\n<div class=\"paging-container-"
    + alias4(((helper = (helper = lookupProperty(helpers,"objectid") || (depth0 != null ? lookupProperty(depth0,"objectid") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"objectid","hash":{},"data":data,"loc":{"start":{"line":6,"column":29},"end":{"line":6,"column":41}}}) : helper)))
    + "\">\n</div>\n	<input type=\"hidden\" name=\"formid\" value=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"objectid") || (depth0 != null ? lookupProperty(depth0,"objectid") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"objectid","hash":{},"data":data,"loc":{"start":{"line":8,"column":43},"end":{"line":8,"column":55}}}) : helper)))
    + "\">\n</form>\n";
},"useData":true});

this["Mura"]["templates"]["hidden"] = this.Mura.Handlebars.template({"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "<input type=\"hidden\" name=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":1,"column":27},"end":{"line":1,"column":35}}}) : helper)))
    + "\" "
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"commonInputAttributes") || (depth0 != null ? lookupProperty(depth0,"commonInputAttributes") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"commonInputAttributes","hash":{},"data":data,"loc":{"start":{"line":1,"column":37},"end":{"line":1,"column":64}}}) : helper))) != null ? stack1 : "")
    + " value=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"value") || (depth0 != null ? lookupProperty(depth0,"value") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"value","hash":{},"data":data,"loc":{"start":{"line":1,"column":72},"end":{"line":1,"column":81}}}) : helper)))
    + "\" />			\n";
},"useData":true});

this["Mura"]["templates"]["list"] = this.Mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "					<option value=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":7,"column":20},"end":{"line":7,"column":28}}}) : helper)))
    + "\">"
    + alias4(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":7,"column":30},"end":{"line":7,"column":38}}}) : helper)))
    + "</option>\n";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "<form>\n	<div class=\"mura-control-group\">\n		<label for=\"beanList\">Choose Entity:</label>	\n		<div class=\"form-group-select\">\n			<select type=\"text\" name=\"bean\" id=\"select-bean-value\">\n"
    + ((stack1 = lookupProperty(helpers,"each").call(depth0 != null ? depth0 : (container.nullContext || {}),depth0,{"name":"each","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":6,"column":4},"end":{"line":8,"column":13}}})) != null ? stack1 : "")
    + "			</select>\n		</div>\n	</div>\n	<div class=\"mura-control-group\">\n		<button type=\"button\" id=\"select-bean\">Go</button>\n	</div>\n</form>";
},"useData":true});

this["Mura"]["templates"]["nested"] = this.Mura.Handlebars.template({"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "<div class=\"field-container-"
    + container.escapeExpression(((helper = (helper = lookupProperty(helpers,"objectid") || (depth0 != null ? lookupProperty(depth0,"objectid") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"objectid","hash":{},"data":data,"loc":{"start":{"line":1,"column":28},"end":{"line":1,"column":40}}}) : helper)))
    + "\">\r\n\r\n</div>\r\n";
},"useData":true});

this["Mura"]["templates"]["paging"] = this.Mura.Handlebars.template({"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "<button class=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"class") || (depth0 != null ? lookupProperty(depth0,"class") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"class","hash":{},"data":data,"loc":{"start":{"line":1,"column":15},"end":{"line":1,"column":24}}}) : helper)))
    + "\" type=\"button\" data-page=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"page") || (depth0 != null ? lookupProperty(depth0,"page") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"page","hash":{},"data":data,"loc":{"start":{"line":1,"column":51},"end":{"line":1,"column":59}}}) : helper)))
    + "\">"
    + alias4(((helper = (helper = lookupProperty(helpers,"label") || (depth0 != null ? lookupProperty(depth0,"label") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data,"loc":{"start":{"line":1,"column":61},"end":{"line":1,"column":70}}}) : helper)))
    + "</button> ";
},"useData":true});

this["Mura"]["templates"]["radio_static"] = this.Mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return container.escapeExpression(((helper = (helper = lookupProperty(helpers,"summary") || (depth0 != null ? lookupProperty(depth0,"summary") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"summary","hash":{},"data":data,"loc":{"start":{"line":4,"column":19},"end":{"line":4,"column":30}}}) : helper)));
},"3":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return container.escapeExpression(((helper = (helper = lookupProperty(helpers,"label") || (depth0 != null ? lookupProperty(depth0,"label") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"label","hash":{},"data":data,"loc":{"start":{"line":4,"column":38},"end":{"line":4,"column":47}}}) : helper)));
},"5":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return " <ins>"
    + container.escapeExpression(((helper = (helper = lookupProperty(helpers,"formRequiredLabel") || (depth0 != null ? lookupProperty(depth0,"formRequiredLabel") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"formRequiredLabel","hash":{},"data":data,"loc":{"start":{"line":4,"column":78},"end":{"line":4,"column":99}}}) : helper)))
    + "</ins>";
},"7":function(container,depth0,helpers,partials,data) {
    return "</br>";
},"9":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "				<div class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"radioWrapperClass") || (depth0 != null ? lookupProperty(depth0,"radioWrapperClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"radioWrapperClass","hash":{},"data":data,"loc":{"start":{"line":8,"column":16},"end":{"line":8,"column":39}}}) : helper))) != null ? stack1 : "")
    + "\">\n					<input type=\"radio\" name=\""
    + alias4(container.lambda((depths[1] != null ? lookupProperty(depths[1],"name") : depths[1]), depth0))
    + "\" class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"radioClass") || (depth0 != null ? lookupProperty(depth0,"radioClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"radioClass","hash":{},"data":data,"loc":{"start":{"line":9,"column":51},"end":{"line":9,"column":67}}}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = lookupProperty(helpers,"datarecordid") || (depth0 != null ? lookupProperty(depth0,"datarecordid") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"datarecordid","hash":{},"data":data,"loc":{"start":{"line":9,"column":79},"end":{"line":9,"column":95}}}) : helper)))
    + "\" value=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"value") || (depth0 != null ? lookupProperty(depth0,"value") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"value","hash":{},"data":data,"loc":{"start":{"line":9,"column":104},"end":{"line":9,"column":113}}}) : helper)))
    + "\"  "
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"isselected") : depth0),{"name":"if","hash":{},"fn":container.program(10, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":9,"column":116},"end":{"line":9,"column":158}}})) != null ? stack1 : "")
    + "/>\n					<label for=\"field-"
    + alias4(((helper = (helper = lookupProperty(helpers,"datarecordid") || (depth0 != null ? lookupProperty(depth0,"datarecordid") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"datarecordid","hash":{},"data":data,"loc":{"start":{"line":10,"column":23},"end":{"line":10,"column":39}}}) : helper)))
    + "\" class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"radioLabelClass") || (depth0 != null ? lookupProperty(depth0,"radioLabelClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"radioLabelClass","hash":{},"data":data,"loc":{"start":{"line":10,"column":48},"end":{"line":10,"column":69}}}) : helper))) != null ? stack1 : "")
    + "\">"
    + alias4(((helper = (helper = lookupProperty(helpers,"label") || (depth0 != null ? lookupProperty(depth0,"label") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data,"loc":{"start":{"line":10,"column":71},"end":{"line":10,"column":80}}}) : helper)))
    + "</label>\n				</div>\n";
},"10":function(container,depth0,helpers,partials,data) {
    return "checked='checked'";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "	<div class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"inputWrapperClass") || (depth0 != null ? lookupProperty(depth0,"inputWrapperClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data,"loc":{"start":{"line":1,"column":13},"end":{"line":1,"column":36}}}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":1,"column":48},"end":{"line":1,"column":56}}}) : helper)))
    + "-container\">\n		<div class=\"mura-radio-group\">\n			<label class=\"mura-group-label\" for=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":3,"column":40},"end":{"line":3,"column":48}}}) : helper)))
    + "\">\n				"
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"summary") : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.program(3, data, 0, blockParams, depths),"data":data,"loc":{"start":{"line":4,"column":4},"end":{"line":4,"column":54}}})) != null ? stack1 : "")
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"isrequired") : depth0),{"name":"if","hash":{},"fn":container.program(5, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":4,"column":54},"end":{"line":4,"column":112}}})) != null ? stack1 : "")
    + "\n			</label>\n			"
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"summary") : depth0),{"name":"if","hash":{},"fn":container.program(7, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":6,"column":3},"end":{"line":6,"column":30}}})) != null ? stack1 : "")
    + "\n"
    + ((stack1 = (lookupProperty(helpers,"eachStatic")||(depth0 && lookupProperty(depth0,"eachStatic"))||alias2).call(alias1,(depth0 != null ? lookupProperty(depth0,"dataset") : depth0),{"name":"eachStatic","hash":{},"fn":container.program(9, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":7,"column":3},"end":{"line":12,"column":18}}})) != null ? stack1 : "")
    + "		</div>\n	</div>\n";
},"useData":true,"useDepths":true});

this["Mura"]["templates"]["radio"] = this.Mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return container.escapeExpression(((helper = (helper = lookupProperty(helpers,"summary") || (depth0 != null ? lookupProperty(depth0,"summary") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"summary","hash":{},"data":data,"loc":{"start":{"line":4,"column":19},"end":{"line":4,"column":30}}}) : helper)));
},"3":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return container.escapeExpression(((helper = (helper = lookupProperty(helpers,"label") || (depth0 != null ? lookupProperty(depth0,"label") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"label","hash":{},"data":data,"loc":{"start":{"line":4,"column":38},"end":{"line":4,"column":47}}}) : helper)));
},"5":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return " <ins>"
    + container.escapeExpression(((helper = (helper = lookupProperty(helpers,"formRequiredLabel") || (depth0 != null ? lookupProperty(depth0,"formRequiredLabel") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"formRequiredLabel","hash":{},"data":data,"loc":{"start":{"line":4,"column":78},"end":{"line":4,"column":99}}}) : helper)))
    + "</ins>";
},"7":function(container,depth0,helpers,partials,data) {
    return "</br>";
},"9":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "				<div class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"radioWrapperClass") || (depth0 != null ? lookupProperty(depth0,"radioWrapperClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"radioWrapperClass","hash":{},"data":data,"loc":{"start":{"line":8,"column":16},"end":{"line":8,"column":39}}}) : helper))) != null ? stack1 : "")
    + "\">\n					<input type=\"radio\" name=\""
    + alias4(container.lambda((depths[1] != null ? lookupProperty(depths[1],"name") : depths[1]), depth0))
    + "id\" class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"radioClass") || (depth0 != null ? lookupProperty(depth0,"radioClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"radioClass","hash":{},"data":data,"loc":{"start":{"line":9,"column":53},"end":{"line":9,"column":69}}}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = lookupProperty(helpers,"id") || (depth0 != null ? lookupProperty(depth0,"id") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"id","hash":{},"data":data,"loc":{"start":{"line":9,"column":81},"end":{"line":9,"column":87}}}) : helper)))
    + "\" value=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"id") || (depth0 != null ? lookupProperty(depth0,"id") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"id","hash":{},"data":data,"loc":{"start":{"line":9,"column":96},"end":{"line":9,"column":102}}}) : helper)))
    + "\" "
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"isselected") : depth0),{"name":"if","hash":{},"fn":container.program(10, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":9,"column":104},"end":{"line":9,"column":146}}})) != null ? stack1 : "")
    + "/>\n					<label for=\"field-"
    + alias4(((helper = (helper = lookupProperty(helpers,"id") || (depth0 != null ? lookupProperty(depth0,"id") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"id","hash":{},"data":data,"loc":{"start":{"line":10,"column":23},"end":{"line":10,"column":29}}}) : helper)))
    + "\" test1=1 class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"radioLabelClass") || (depth0 != null ? lookupProperty(depth0,"radioLabelClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"radioLabelClass","hash":{},"data":data,"loc":{"start":{"line":10,"column":46},"end":{"line":10,"column":67}}}) : helper))) != null ? stack1 : "")
    + "\">"
    + alias4(((helper = (helper = lookupProperty(helpers,"label") || (depth0 != null ? lookupProperty(depth0,"label") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data,"loc":{"start":{"line":10,"column":69},"end":{"line":10,"column":78}}}) : helper)))
    + "</label>\n				</div>\n";
},"10":function(container,depth0,helpers,partials,data) {
    return "checked='checked'";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "	<div class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"inputWrapperClass") || (depth0 != null ? lookupProperty(depth0,"inputWrapperClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data,"loc":{"start":{"line":1,"column":13},"end":{"line":1,"column":36}}}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":1,"column":48},"end":{"line":1,"column":56}}}) : helper)))
    + "-container\">\n		<div class=\"mura-radio-group\">\n			<label class=\"mura-group-label\" for=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":3,"column":40},"end":{"line":3,"column":48}}}) : helper)))
    + "\">\n				"
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"summary") : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.program(3, data, 0, blockParams, depths),"data":data,"loc":{"start":{"line":4,"column":4},"end":{"line":4,"column":54}}})) != null ? stack1 : "")
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"isrequired") : depth0),{"name":"if","hash":{},"fn":container.program(5, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":4,"column":54},"end":{"line":4,"column":112}}})) != null ? stack1 : "")
    + "\n			</label>\n			"
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"summary") : depth0),{"name":"if","hash":{},"fn":container.program(7, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":6,"column":3},"end":{"line":6,"column":30}}})) != null ? stack1 : "")
    + "\n"
    + ((stack1 = lookupProperty(helpers,"each").call(alias1,((stack1 = (depth0 != null ? lookupProperty(depth0,"dataset") : depth0)) != null ? lookupProperty(stack1,"options") : stack1),{"name":"each","hash":{},"fn":container.program(9, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":7,"column":3},"end":{"line":12,"column":12}}})) != null ? stack1 : "")
    + "		</div>\n	</div>\n";
},"useData":true,"useDepths":true});

this["Mura"]["templates"]["section"] = this.Mura.Handlebars.template({"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "<div class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"inputWrapperClass") || (depth0 != null ? lookupProperty(depth0,"inputWrapperClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data,"loc":{"start":{"line":1,"column":12},"end":{"line":1,"column":35}}}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":1,"column":47},"end":{"line":1,"column":55}}}) : helper)))
    + "-container\">\r\n<div class=\"mura-section\">"
    + alias4(((helper = (helper = lookupProperty(helpers,"label") || (depth0 != null ? lookupProperty(depth0,"label") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data,"loc":{"start":{"line":2,"column":26},"end":{"line":2,"column":35}}}) : helper)))
    + "</div>\r\n<div class=\"mura-divide\"></div>\r\n</div>";
},"useData":true});

this["Mura"]["templates"]["success"] = this.Mura.Handlebars.template({"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "<div class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"formResponseWrapperClass") || (depth0 != null ? lookupProperty(depth0,"formResponseWrapperClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"formResponseWrapperClass","hash":{},"data":data,"loc":{"start":{"line":1,"column":12},"end":{"line":1,"column":42}}}) : helper))) != null ? stack1 : "")
    + "\">"
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"responsemessage") || (depth0 != null ? lookupProperty(depth0,"responsemessage") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"responsemessage","hash":{},"data":data,"loc":{"start":{"line":1,"column":44},"end":{"line":1,"column":65}}}) : helper))) != null ? stack1 : "")
    + "</div>\n";
},"useData":true});

this["Mura"]["templates"]["table"] = this.Mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "<option value=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"num") || (depth0 != null ? lookupProperty(depth0,"num") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"num","hash":{},"data":data,"loc":{"start":{"line":8,"column":102},"end":{"line":8,"column":109}}}) : helper)))
    + "\" "
    + alias4(((helper = (helper = lookupProperty(helpers,"selected") || (depth0 != null ? lookupProperty(depth0,"selected") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"selected","hash":{},"data":data,"loc":{"start":{"line":8,"column":111},"end":{"line":8,"column":123}}}) : helper)))
    + ">"
    + alias4(((helper = (helper = lookupProperty(helpers,"label") || (depth0 != null ? lookupProperty(depth0,"label") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data,"loc":{"start":{"line":8,"column":124},"end":{"line":8,"column":133}}}) : helper)))
    + "</option>";
},"3":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "					<option value=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":27,"column":20},"end":{"line":27,"column":28}}}) : helper)))
    + "\" "
    + alias4(((helper = (helper = lookupProperty(helpers,"selected") || (depth0 != null ? lookupProperty(depth0,"selected") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"selected","hash":{},"data":data,"loc":{"start":{"line":27,"column":30},"end":{"line":27,"column":42}}}) : helper)))
    + ">"
    + alias4(((helper = (helper = lookupProperty(helpers,"displayName") || (depth0 != null ? lookupProperty(depth0,"displayName") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"displayName","hash":{},"data":data,"loc":{"start":{"line":27,"column":43},"end":{"line":27,"column":58}}}) : helper)))
    + "</option>\n";
},"5":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "			<th class='data-sort' data-value='"
    + alias4(((helper = (helper = lookupProperty(helpers,"column") || (depth0 != null ? lookupProperty(depth0,"column") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"column","hash":{},"data":data,"loc":{"start":{"line":53,"column":37},"end":{"line":53,"column":47}}}) : helper)))
    + "'>"
    + alias4(((helper = (helper = lookupProperty(helpers,"displayName") || (depth0 != null ? lookupProperty(depth0,"displayName") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"displayName","hash":{},"data":data,"loc":{"start":{"line":53,"column":49},"end":{"line":53,"column":64}}}) : helper)))
    + "</th>\n";
},"7":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "			<tr class=\"even\">\n"
    + ((stack1 = (lookupProperty(helpers,"eachColRow")||(depth0 && lookupProperty(depth0,"eachColRow"))||alias2).call(alias1,depth0,(depths[1] != null ? lookupProperty(depths[1],"columns") : depths[1]),{"name":"eachColRow","hash":{},"fn":container.program(8, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":61,"column":4},"end":{"line":63,"column":19}}})) != null ? stack1 : "")
    + "				<td>\n"
    + ((stack1 = (lookupProperty(helpers,"eachColButton")||(depth0 && lookupProperty(depth0,"eachColButton"))||alias2).call(alias1,depth0,{"name":"eachColButton","hash":{},"fn":container.program(10, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":65,"column":4},"end":{"line":67,"column":22}}})) != null ? stack1 : "")
    + "				</td>\n			</tr>\n";
},"8":function(container,depth0,helpers,partials,data) {
    return "					<td>"
    + container.escapeExpression(container.lambda(depth0, depth0))
    + "</td>\n";
},"10":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "				<button type=\"button\" class=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"type") || (depth0 != null ? lookupProperty(depth0,"type") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"type","hash":{},"data":data,"loc":{"start":{"line":66,"column":33},"end":{"line":66,"column":41}}}) : helper)))
    + "\" data-value=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"id") || (depth0 != null ? lookupProperty(depth0,"id") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"id","hash":{},"data":data,"loc":{"start":{"line":66,"column":55},"end":{"line":66,"column":61}}}) : helper)))
    + "\" data-pos=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"index") || (data && lookupProperty(data,"index"))) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"index","hash":{},"data":data,"loc":{"start":{"line":66,"column":73},"end":{"line":66,"column":83}}}) : helper)))
    + "\">"
    + alias4(((helper = (helper = lookupProperty(helpers,"label") || (depth0 != null ? lookupProperty(depth0,"label") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data,"loc":{"start":{"line":66,"column":85},"end":{"line":66,"column":94}}}) : helper)))
    + "</button>\n";
},"12":function(container,depth0,helpers,partials,data) {
    var stack1, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "				<button class='data-nav' data-value=\""
    + container.escapeExpression(container.lambda(((stack1 = ((stack1 = (depth0 != null ? lookupProperty(depth0,"rows") : depth0)) != null ? lookupProperty(stack1,"links") : stack1)) != null ? lookupProperty(stack1,"first") : stack1), depth0))
    + "\">First</button>\n";
},"14":function(container,depth0,helpers,partials,data) {
    var stack1, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "				<button class='data-nav' data-value=\""
    + container.escapeExpression(container.lambda(((stack1 = ((stack1 = (depth0 != null ? lookupProperty(depth0,"rows") : depth0)) != null ? lookupProperty(stack1,"links") : stack1)) != null ? lookupProperty(stack1,"previous") : stack1), depth0))
    + "\">Prev</button>\n";
},"16":function(container,depth0,helpers,partials,data) {
    var stack1, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "				<button class='data-nav' data-value=\""
    + container.escapeExpression(container.lambda(((stack1 = ((stack1 = (depth0 != null ? lookupProperty(depth0,"rows") : depth0)) != null ? lookupProperty(stack1,"links") : stack1)) != null ? lookupProperty(stack1,"next") : stack1), depth0))
    + "\">Next</button>\n";
},"18":function(container,depth0,helpers,partials,data) {
    var stack1, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "				<button class='data-nav' data-value=\""
    + container.escapeExpression(container.lambda(((stack1 = ((stack1 = (depth0 != null ? lookupProperty(depth0,"rows") : depth0)) != null ? lookupProperty(stack1,"links") : stack1)) != null ? lookupProperty(stack1,"last") : stack1), depth0))
    + "\">Last</button>\n";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, alias1=container.lambda, alias2=container.escapeExpression, alias3=depth0 != null ? depth0 : (container.nullContext || {}), alias4=container.hooks.helperMissing, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "	<div class=\"mura-control-group\">\n		<div id=\"filter-results-container\">\n			<div id=\"date-filters\">\n				<div class=\"control-group\">\n				  <label>From</label>\n				  <div class=\"controls\">\n				  	<input type=\"text\" class=\"datepicker mura-date\" id=\"date1\" name=\"date1\" validate=\"date\" value=\""
    + alias2(alias1(((stack1 = (depth0 != null ? lookupProperty(depth0,"filters") : depth0)) != null ? lookupProperty(stack1,"fromdate") : stack1), depth0))
    + "\">\n				  	<select id=\"hour1\" name=\"hour1\" class=\"mura-date\">"
    + ((stack1 = (lookupProperty(helpers,"eachHour")||(depth0 && lookupProperty(depth0,"eachHour"))||alias4).call(alias3,((stack1 = (depth0 != null ? lookupProperty(depth0,"filters") : depth0)) != null ? lookupProperty(stack1,"fromhour") : stack1),{"name":"eachHour","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":8,"column":57},"end":{"line":8,"column":155}}})) != null ? stack1 : "")
    + "</select></select>\n					</div>\n				</div>\n			\n				<div class=\"control-group\">\n				  <label>To</label>\n				  <div class=\"controls\">\n				  	<input type=\"text\" class=\"datepicker mura-date\" id=\"date2\" name=\"date2\" validate=\"date\" value=\""
    + alias2(alias1(((stack1 = (depth0 != null ? lookupProperty(depth0,"filters") : depth0)) != null ? lookupProperty(stack1,"todate") : stack1), depth0))
    + "\">\n				  	<select id=\"hour2\" name=\"hour2\"  class=\"mura-date\">"
    + ((stack1 = (lookupProperty(helpers,"eachHour")||(depth0 && lookupProperty(depth0,"eachHour"))||alias4).call(alias3,((stack1 = (depth0 != null ? lookupProperty(depth0,"filters") : depth0)) != null ? lookupProperty(stack1,"tohour") : stack1),{"name":"eachHour","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":16,"column":58},"end":{"line":16,"column":154}}})) != null ? stack1 : "")
    + "</select></select>\n				   </select>\n					</div>\n				</div>\n			</div>\n					\n			<div class=\"control-group\">\n				<label>Keywords</label>\n				<div class=\"controls\">\n					<select name=\"filterBy\" class=\"mura-date\" id=\"results-filterby\">\n"
    + ((stack1 = (lookupProperty(helpers,"eachKey")||(depth0 && lookupProperty(depth0,"eachKey"))||alias4).call(alias3,(depth0 != null ? lookupProperty(depth0,"properties") : depth0),((stack1 = (depth0 != null ? lookupProperty(depth0,"filters") : depth0)) != null ? lookupProperty(stack1,"filterby") : stack1),{"name":"eachKey","hash":{},"fn":container.program(3, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":26,"column":5},"end":{"line":28,"column":17}}})) != null ? stack1 : "")
    + "					</select>\n					<input type=\"text\" class=\"mura-half\" name=\"keywords\" id=\"results-keywords\" value=\""
    + alias2(alias1(((stack1 = (depth0 != null ? lookupProperty(depth0,"filters") : depth0)) != null ? lookupProperty(stack1,"filterkey") : stack1), depth0))
    + "\">\n				</div>\n			</div>\n			<div class=\"form-actions\">\n				<button type=\"button\" class=\"btn\" id=\"btn-results-search\" ><i class=\"mi-bar-chart\"></i> View Data</button>\n				<button type=\"button\" class=\"btn\"  id=\"btn-results-download\" ><i class=\"mi-download\"></i> Download</button>\n			</div>\n		</div>\n	<div>\n\n	<ul class=\"metadata\">\n		<li>Page:\n			<strong>"
    + alias2(alias1(((stack1 = (depth0 != null ? lookupProperty(depth0,"rows") : depth0)) != null ? lookupProperty(stack1,"pageindex") : stack1), depth0))
    + " of "
    + alias2(alias1(((stack1 = (depth0 != null ? lookupProperty(depth0,"rows") : depth0)) != null ? lookupProperty(stack1,"totalpages") : stack1), depth0))
    + "</strong>\n		</li>\n		<li>Total Records:\n			<strong>"
    + alias2(alias1(((stack1 = (depth0 != null ? lookupProperty(depth0,"rows") : depth0)) != null ? lookupProperty(stack1,"totalitems") : stack1), depth0))
    + "</strong>\n		</li>\n	</ul>\n\n	<table style=\"width: 100%\" class=\"table\">\n		<thead>\n		<tr>\n"
    + ((stack1 = lookupProperty(helpers,"each").call(alias3,(depth0 != null ? lookupProperty(depth0,"columns") : depth0),{"name":"each","hash":{},"fn":container.program(5, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":52,"column":2},"end":{"line":54,"column":11}}})) != null ? stack1 : "")
    + "			<th></th>\n		</tr>\n		</thead>\n		<tbody>\n"
    + ((stack1 = lookupProperty(helpers,"each").call(alias3,((stack1 = (depth0 != null ? lookupProperty(depth0,"rows") : depth0)) != null ? lookupProperty(stack1,"items") : stack1),{"name":"each","hash":{},"fn":container.program(7, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":59,"column":2},"end":{"line":70,"column":11}}})) != null ? stack1 : "")
    + "		</tbody>\n		<tfoot>\n		<tr>\n			<td>\n"
    + ((stack1 = lookupProperty(helpers,"if").call(alias3,((stack1 = ((stack1 = (depth0 != null ? lookupProperty(depth0,"rows") : depth0)) != null ? lookupProperty(stack1,"links") : stack1)) != null ? lookupProperty(stack1,"first") : stack1),{"name":"if","hash":{},"fn":container.program(12, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":75,"column":4},"end":{"line":77,"column":11}}})) != null ? stack1 : "")
    + ((stack1 = lookupProperty(helpers,"if").call(alias3,((stack1 = ((stack1 = (depth0 != null ? lookupProperty(depth0,"rows") : depth0)) != null ? lookupProperty(stack1,"links") : stack1)) != null ? lookupProperty(stack1,"previous") : stack1),{"name":"if","hash":{},"fn":container.program(14, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":78,"column":4},"end":{"line":80,"column":11}}})) != null ? stack1 : "")
    + ((stack1 = lookupProperty(helpers,"if").call(alias3,((stack1 = ((stack1 = (depth0 != null ? lookupProperty(depth0,"rows") : depth0)) != null ? lookupProperty(stack1,"links") : stack1)) != null ? lookupProperty(stack1,"next") : stack1),{"name":"if","hash":{},"fn":container.program(16, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":81,"column":4},"end":{"line":83,"column":11}}})) != null ? stack1 : "")
    + ((stack1 = lookupProperty(helpers,"if").call(alias3,((stack1 = ((stack1 = (depth0 != null ? lookupProperty(depth0,"rows") : depth0)) != null ? lookupProperty(stack1,"links") : stack1)) != null ? lookupProperty(stack1,"last") : stack1),{"name":"if","hash":{},"fn":container.program(18, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":84,"column":4},"end":{"line":86,"column":11}}})) != null ? stack1 : "")
    + "			</td>\n		</tfoot>\n	</table>\n</div>";
},"useData":true,"useDepths":true});

this["Mura"]["templates"]["textarea"] = this.Mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return container.escapeExpression(((helper = (helper = lookupProperty(helpers,"summary") || (depth0 != null ? lookupProperty(depth0,"summary") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"summary","hash":{},"data":data,"loc":{"start":{"line":2,"column":67},"end":{"line":2,"column":78}}}) : helper)));
},"3":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return container.escapeExpression(((helper = (helper = lookupProperty(helpers,"label") || (depth0 != null ? lookupProperty(depth0,"label") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"label","hash":{},"data":data,"loc":{"start":{"line":2,"column":86},"end":{"line":2,"column":95}}}) : helper)));
},"5":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return " <ins>"
    + container.escapeExpression(((helper = (helper = lookupProperty(helpers,"formRequiredLabel") || (depth0 != null ? lookupProperty(depth0,"formRequiredLabel") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"formRequiredLabel","hash":{},"data":data,"loc":{"start":{"line":2,"column":126},"end":{"line":2,"column":147}}}) : helper)))
    + "</ins>";
},"7":function(container,depth0,helpers,partials,data) {
    return "</br>";
},"9":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return " placeholder=\""
    + container.escapeExpression(((helper = (helper = lookupProperty(helpers,"placeholder") || (depth0 != null ? lookupProperty(depth0,"placeholder") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"placeholder","hash":{},"data":data,"loc":{"start":{"line":4,"column":71},"end":{"line":4,"column":86}}}) : helper)))
    + "\"";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "<div class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"inputWrapperClass") || (depth0 != null ? lookupProperty(depth0,"inputWrapperClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data,"loc":{"start":{"line":1,"column":12},"end":{"line":1,"column":35}}}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":1,"column":47},"end":{"line":1,"column":55}}}) : helper)))
    + "-container\">\r\n	<label for=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"labelForValue") || (depth0 != null ? lookupProperty(depth0,"labelForValue") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"labelForValue","hash":{},"data":data,"loc":{"start":{"line":2,"column":13},"end":{"line":2,"column":30}}}) : helper)))
    + "\" data-for=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":2,"column":42},"end":{"line":2,"column":50}}}) : helper)))
    + "\">"
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"summary") : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0),"inverse":container.program(3, data, 0),"data":data,"loc":{"start":{"line":2,"column":52},"end":{"line":2,"column":102}}})) != null ? stack1 : "")
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"isrequired") : depth0),{"name":"if","hash":{},"fn":container.program(5, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":2,"column":102},"end":{"line":2,"column":160}}})) != null ? stack1 : "")
    + "</label>\r\n	"
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"summary") : depth0),{"name":"if","hash":{},"fn":container.program(7, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":3,"column":1},"end":{"line":3,"column":28}}})) != null ? stack1 : "")
    + "\r\n	<textarea "
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"commonInputAttributes") || (depth0 != null ? lookupProperty(depth0,"commonInputAttributes") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"commonInputAttributes","hash":{},"data":data,"loc":{"start":{"line":4,"column":11},"end":{"line":4,"column":38}}}) : helper))) != null ? stack1 : "")
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"placeholder") : depth0),{"name":"if","hash":{},"fn":container.program(9, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":4,"column":38},"end":{"line":4,"column":94}}})) != null ? stack1 : "")
    + ">"
    + alias4(((helper = (helper = lookupProperty(helpers,"value") || (depth0 != null ? lookupProperty(depth0,"value") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"value","hash":{},"data":data,"loc":{"start":{"line":4,"column":95},"end":{"line":4,"column":104}}}) : helper)))
    + "</textarea>\r\n</div>\r\n";
},"useData":true});

this["Mura"]["templates"]["textblock"] = this.Mura.Handlebars.template({"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "<div class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"inputWrapperClass") || (depth0 != null ? lookupProperty(depth0,"inputWrapperClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data,"loc":{"start":{"line":1,"column":12},"end":{"line":1,"column":35}}}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + container.escapeExpression(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":1,"column":47},"end":{"line":1,"column":55}}}) : helper)))
    + "-container\">\r\n<div class=\"mura-form-text\">"
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"value") || (depth0 != null ? lookupProperty(depth0,"value") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"value","hash":{},"data":data,"loc":{"start":{"line":2,"column":28},"end":{"line":2,"column":39}}}) : helper))) != null ? stack1 : "")
    + "</div>\r\n</div>\r\n";
},"useData":true});

this["Mura"]["templates"]["textfield"] = this.Mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return container.escapeExpression(((helper = (helper = lookupProperty(helpers,"summary") || (depth0 != null ? lookupProperty(depth0,"summary") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"summary","hash":{},"data":data,"loc":{"start":{"line":2,"column":67},"end":{"line":2,"column":78}}}) : helper)));
},"3":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return container.escapeExpression(((helper = (helper = lookupProperty(helpers,"label") || (depth0 != null ? lookupProperty(depth0,"label") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"label","hash":{},"data":data,"loc":{"start":{"line":2,"column":86},"end":{"line":2,"column":95}}}) : helper)));
},"5":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return " <ins>"
    + container.escapeExpression(((helper = (helper = lookupProperty(helpers,"formRequiredLabel") || (depth0 != null ? lookupProperty(depth0,"formRequiredLabel") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"formRequiredLabel","hash":{},"data":data,"loc":{"start":{"line":2,"column":126},"end":{"line":2,"column":147}}}) : helper)))
    + "</ins>";
},"7":function(container,depth0,helpers,partials,data) {
    return "</br>";
},"9":function(container,depth0,helpers,partials,data) {
    var helper, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return " placeholder=\""
    + container.escapeExpression(((helper = (helper = lookupProperty(helpers,"placeholder") || (depth0 != null ? lookupProperty(depth0,"placeholder") : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"placeholder","hash":{},"data":data,"loc":{"start":{"line":4,"column":118},"end":{"line":4,"column":133}}}) : helper)))
    + "\"";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "<div class=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"inputWrapperClass") || (depth0 != null ? lookupProperty(depth0,"inputWrapperClass") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data,"loc":{"start":{"line":1,"column":12},"end":{"line":1,"column":35}}}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":1,"column":47},"end":{"line":1,"column":55}}}) : helper)))
    + "-container\">\r\n	<label for=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"labelForValue") || (depth0 != null ? lookupProperty(depth0,"labelForValue") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"labelForValue","hash":{},"data":data,"loc":{"start":{"line":2,"column":13},"end":{"line":2,"column":30}}}) : helper)))
    + "\" data-for=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"name") || (depth0 != null ? lookupProperty(depth0,"name") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data,"loc":{"start":{"line":2,"column":42},"end":{"line":2,"column":50}}}) : helper)))
    + "\">"
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"summary") : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0),"inverse":container.program(3, data, 0),"data":data,"loc":{"start":{"line":2,"column":52},"end":{"line":2,"column":102}}})) != null ? stack1 : "")
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"isrequired") : depth0),{"name":"if","hash":{},"fn":container.program(5, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":2,"column":102},"end":{"line":2,"column":160}}})) != null ? stack1 : "")
    + "</label>\r\n	"
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"summary") : depth0),{"name":"if","hash":{},"fn":container.program(7, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":3,"column":1},"end":{"line":3,"column":28}}})) != null ? stack1 : "")
    + "\r\n	<input type=\""
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"textInputTypeValue") || (depth0 != null ? lookupProperty(depth0,"textInputTypeValue") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"textInputTypeValue","hash":{},"data":data,"loc":{"start":{"line":4,"column":14},"end":{"line":4,"column":38}}}) : helper))) != null ? stack1 : "")
    + "\" "
    + ((stack1 = ((helper = (helper = lookupProperty(helpers,"commonInputAttributes") || (depth0 != null ? lookupProperty(depth0,"commonInputAttributes") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"commonInputAttributes","hash":{},"data":data,"loc":{"start":{"line":4,"column":40},"end":{"line":4,"column":67}}}) : helper))) != null ? stack1 : "")
    + " value=\""
    + alias4(((helper = (helper = lookupProperty(helpers,"value") || (depth0 != null ? lookupProperty(depth0,"value") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"value","hash":{},"data":data,"loc":{"start":{"line":4,"column":75},"end":{"line":4,"column":84}}}) : helper)))
    + "\""
    + ((stack1 = lookupProperty(helpers,"if").call(alias1,(depth0 != null ? lookupProperty(depth0,"placeholder") : depth0),{"name":"if","hash":{},"fn":container.program(9, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":4,"column":85},"end":{"line":4,"column":141}}})) != null ? stack1 : "")
    + "/>\r\n</div>\r\n";
},"useData":true});

this["Mura"]["templates"]["view"] = this.Mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=container.hooks.helperMissing, alias3="function", alias4=container.escapeExpression, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "	<li>\n		<strong>"
    + alias4(((helper = (helper = lookupProperty(helpers,"displayName") || (depth0 != null ? lookupProperty(depth0,"displayName") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"displayName","hash":{},"data":data,"loc":{"start":{"line":5,"column":10},"end":{"line":5,"column":25}}}) : helper)))
    + ": </strong> "
    + alias4(((helper = (helper = lookupProperty(helpers,"displayValue") || (depth0 != null ? lookupProperty(depth0,"displayValue") : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"displayValue","hash":{},"data":data,"loc":{"start":{"line":5,"column":37},"end":{"line":5,"column":53}}}) : helper)))
    + " \n	</li>\n";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, lookupProperty = container.lookupProperty || function(parent, propertyName) {
        if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
          return parent[propertyName];
        }
        return undefined
    };

  return "<div class=\"mura-control-group\">\n<ul>\n"
    + ((stack1 = (lookupProperty(helpers,"eachProp")||(depth0 && lookupProperty(depth0,"eachProp"))||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),depth0,{"name":"eachProp","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":3,"column":0},"end":{"line":7,"column":13}}})) != null ? stack1 : "")
    + "</ul>\n<button type=\"button\" class=\"nav-back\">Back</button>\n</div>";
},"useData":true});

/***/ })
/******/ ]);
});
//# sourceMappingURL=mura.js.map