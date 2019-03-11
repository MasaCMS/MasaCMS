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

/**
 * Creates a new Mura
 * @class {class} Mura
 */
;
(function(root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['Mura'], factory);
    } else if (typeof module === 'object' && module.exports) {
        // Node. Does not work with strict CommonJS, but
        // only CommonJS-like environments that support module.exports,
        // like Node.
        root.Mura = factory(root);
    } else {
        // Browser globals (root is window)
        root.Mura = factory(root);
    }
}(this, function(root) {

    /**
     * login - Logs user into Mura
     *
     * @param  {string} username Username
     * @param  {string} password Password
     * @param  {string} siteid   Siteid
     * @return {Promise}
     * @memberof Mura
     */
    function login(username, password, siteid) {
        siteid = siteid || root.Mura.siteid;

        return new Promise(function(resolve, reject) {

            Mura.ajax({
                type: 'post',
                url: Mura.apiEndpoint +
                    '?method=generateCSRFTokens',
                data: {
                    siteid: siteid,
                    context: 'login'
                },
                success: function(resp) {
                    root.Mura.ajax({
                        async: true,
                        type: 'post',
                        url: root.Mura.apiEndpoint,
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

    }


    /**
     * logout - Logs user out
     *
     * @param  {type} siteid Siteid
     * @return {Promise}
     * @memberof Mura
     */
    function logout(siteid) {
        siteid = siteid || root.Mura.siteid;

        return new Promise(function(resolve, reject) {
            root.Mura.ajax({
                async: true,
                type: 'post',
                url: root.Mura.apiEndpoint,
                data: {
                    siteid: siteid,
                    method: 'logout'
                },
                success: function(resp) {
                    resolve(resp.data);
                }
            });
        });

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


    var trackingMetadata={};

    /**
     * trackEvent - This is for Mura Experience Platform. It has no use with Mura standard
     *
     * @param  {object} data event data
     * @return {Promise}
     * @memberof Mura
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
         data.type =  eventData.hitType || eventData.type || 'event';
         data.value =  eventData.eventValue || eventData.value || undefined;

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

                 if (typeof data.value != 'undefined' && Mura.isNumeric(
                         data.value)) {
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

             if(typeof trackingMetadata[trackingID] != 'undefined'){
                 Mura.deepExtend(trackingVars,trackingMetadata[trackingID]);
                 trackingVars.eventData=data;
                 track();
             } else {
                 Mura.get(mura.apiEndpoint, {
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

                     trackingMetadata[trackingID]={};
                     Mura.deepExtend(trackingMetadata[trackingID],response.data);
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
     * @param  {type} filename Mura content filename
     * @param  {type} params Object
     * @return {Promise}
     * @memberof Mura
     */
    function renderFilename(filename, params) {

        var query = [];
        params = params || {};
        params.filename = params.filename || '';
        params.siteid = params.siteid || root.Mura.siteid;

        for (var key in params) {
            if (key != 'entityname' && key != 'filename' && key !=
                'siteid' && key != 'method') {
                query.push(encodeURIComponent(key) + '=' +
                    encodeURIComponent(params[key]));
            }
        }

        return new Promise(function(resolve, reject) {
            root.Mura.ajax({
                async: true,
                type: 'get',
                url: root.Mura.apiEndpoint +
                    '/content/_path/' + filename + '?' +
                    query.join('&'),
                success: function(resp) {
                  if (typeof resolve ==
                      'function') {
                      var item = new root.Mura.Entity();
                      item.set(resp.data);
                      resolve(item);
                  }
                },
                error: function(resp) {
  								if (typeof resp.data != 'undefined' && typeof resolve == 'function') {
                    var item = new root.Mura.Entity();
                    item.set(resp.data);
  									resolve(item);
  								} else if (typeof reject == 'function') {
                    reject(resp);
                  }
                }
            });
        });

    }

    /**
     * getEntity - Returns Mura.Entity instance
     *
     * @param  {string} entityname Entity Name
     * @param  {string} siteid     Siteid
     * @return {Mura.Entity}
     * @memberof Mura
     */
    function getEntity(entityname, siteid) {
        if (typeof entityname == 'string') {
            var properties = {
                entityname: entityname
            };
            properties.siteid = siteid || root.Mura.siteid;
        } else {
            properties = entityname;
            properties.entityname = properties.entityname || 'content';
            properties.siteid = properties.siteid || root.Mura.siteid;
        }

        if (root.Mura.entities[properties.entityname]) {
            return new root.Mura.entities[properties.entityname](
                properties);
        } else {
            return new root.Mura.Entity(properties);
        }
    }

    /**
     * getFeed - Return new instance of Mura.Feed
     *
     * @param  {type} entityname Entity name
     * @return {Mura.Feed}
     * @memberof Mura
     */
    function getFeed(entityname) {
        return new root.Mura.Feed(Mura.siteid, entityname);
    }

    /**
     * getCurrentUser - Return Mura.Entity for current user
     *
     * @param  {object} params Load parameters, fields:listoffields
     * @return {Promise}
     * @memberof Mura
     */
    function getCurrentUser(params) {
        params=params || {};
        params.fields=params.fields || '';
        return new Promise(function(resolve, reject) {
            if (root.Mura.currentUser) {
                return root.Mura.currentUser;
            } else {
                root.Mura.ajax({
                    async: true,
                    type: 'get',
                    url: root.Mura.apiEndpoint +
                        '/findCurrentUser?fields=' + params.fields + '&_cacheid=' +
                        Math.random(),
                    success: function(resp) {
                        if (typeof resolve ==
                            'function') {
                            root.Mura.currentUser =
                                new root.Mura.Entity();
                            root.Mura.currentUser.set(
                                resp.data);
                            resolve(root.Mura.currentUser);
                        }
                    }
                });
            }
        });
    }

    /**
     * findQuery - Returns Mura.EntityCollection with properties that match params
     *
     * @param  {object} params Object of matching params
     * @return {Promise}
     * @memberof Mura
     */
    function findQuery(params) {

        params = params || {};
        params.entityname = params.entityname || 'content';
        params.siteid = params.siteid || Mura.siteid;
        params.method = params.method || 'findQuery';
        params['_cacheid'] == Math.random();

        return new Promise(function(resolve, reject) {

            root.Mura.ajax({
                type: 'get',
                url: root.Mura.apiEndpoint,
                data: params,
                success: function(resp) {
                    var collection = new root.Mura.EntityCollection(
                        resp.data)

                    if (typeof resolve ==
                        'function') {
                        resolve(collection);
                    }
                }
            });
        });
    }

    function evalScripts(el) {
        if (typeof el == 'string') {
            el = parseHTML(el);
        }

        var scripts = [];
        var ret = el.childNodes;

        for (var i = 0; ret[i]; i++) {
            if (scripts && nodeName(ret[i], "script") && (!ret[i].type ||
                    ret[i].type.toLowerCase() === "text/javascript")) {
                if (ret[i].src) {
                    scripts.push(ret[i]);
                } else {
                    scripts.push(ret[i].parentNode ? ret[i].parentNode.removeChild(
                        ret[i]) : ret[i]);
                }
            } else if (ret[i].nodeType == 1 || ret[i].nodeType == 9 ||
                ret[i].nodeType == 11) {
                evalScripts(ret[i]);
            }
        }

        for (script in scripts) {
            evalScript(scripts[script]);
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
        if (document.readyState != 'loading') {
            //IE set the readyState to interative too early
            setTimeout(function() {
                fn(root.Mura);
            }, 1);
        } else {
            document.addEventListener('DOMContentLoaded', function() {
                fn(root.Mura);
            });
        }
    }

    /**
     * get - Make GET request
     *
     * @param  {url} url  URL
     * @param  {object} data Data to send to url
     * @return {Promise}
     * @memberof Mura
     */
    function get(url, data) {
        data = data || {};
        return new Promise(function(resolve, reject) {
            return ajax({
                type: 'get',
                url: url,
                data: data,
                success: function(resp) {
                    resolve(resp);
                },
                error: function(resp) {
                    reject(resp);
                }
            });
        });

    }

    /**
     * post - Make POST request
     *
     * @param  {url} url  URL
     * @param  {object} data Data to send to url
     * @return {Promise}
     * @memberof Mura
     */
    function post(url, data) {
        data = data || {};
        return new Promise(function(resolve, reject) {
            return ajax({
                type: 'post',
                url: url,
                data: data,
                success: function(resp) {
                    resolve(resp);
                },
                error: function(resp) {
                    reject(resp);
                }
            });
        });

    }

    function isXDomainRequest(url) {
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

    /**
     * ajax - Make ajax request
     *
     * @param  {object} params
     * @return {Promise}
     * @memberof Mura
     */
    function ajax(params) {

        //params=params || {};

        if (!('type' in params)) {
            params.type = 'GET';
        }

        if (!('success' in params)) {
            params.success = function() {};
        }

        if (!('data' in params)) {
            params.data = {};
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

        if (!('headers' in params)) {
            params.headers = {};
        }

        var request = new XMLHttpRequest();

        if (params.crossDomain) {
            if (!("withCredentials" in request) && typeof XDomainRequest !=
                "undefined" && isXDomainRequest(params.url)) {
                // Check if the XMLHttpRequest object has a "withCredentials" property.
                // "withCredentials" only exists on XMLHTTPRequest2 objects.
                // Otherwise, check if XDomainRequest.
                // XDomainRequest only exists in IE, and is IE's way of making CORS requests.

                request = new XDomainRequest();

            }
        }

        request.onreadystatechange = function() {
            if (request.readyState == 4) {
                //IE9 doesn't appear to return the request status
                if (typeof request.status == 'undefined' || (
                        request.status >= 200 && request.status <
                        400)) {

                    try {
                        var data = JSON.parse(request.responseText);
                    } catch (e) {
                        var data = request.responseText;
                    }

                    params.success(data, request);
                } else {
										if(typeof params.error == 'function'){
                    	params.error(request);
										}
                }
            }
        }

        if (params.type.toLowerCase() == 'post') {
            request.open(params.type.toUpperCase(), params.url, params.async);

            for (var p in params.xhrFields) {
                if (p in request) {
                    request[p] = params.xhrFields[p];
                }
            }

            for (var h in params.headers) {
                request.setRequestHeader(p, params.headers[h]);
            }

            //if(params.data.constructor.name == 'FormData'){

            if (Mura.formdata && params.data instanceof FormData) {
							try{
                request.send(params.data);
							} catch(e){
								if(typeof params.error == 'function'){
									params.error(request,e);
								} else {
									throw e;
								}
							}
            } else {
							request.setRequestHeader('Content-Type',
									'application/x-www-form-urlencoded; charset=UTF-8'
							);

              var query = [];

              for (var key in params.data) {
                  query.push($escape(key) + '=' + $escape(params.data[
                      key]));
              }

              query = query.join('&');

              setTimeout(function() {
								try{
									request.send(query);
								} catch(e){
									if(typeof params.error == 'function'){
										params.error(request,e);
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
                query.push($escape(key) + '=' + $escape(params.data[key]));
            }

            query = query.join('&');

            request.open(params.type.toUpperCase(), params.url + '&' +
                query, params.async);

            for (var p in params.xhrFields) {
                if (p in request) {
                    request[p] = params.xhrFields[p];
                }
            }

            for (var h in params.headers) {
                request.setRequestHeader(p, params.headers[h]);
            }

            setTimeout(function() {
							try{
								request.send();
							} catch(e){
								if(typeof params.error == 'function'){
									params.error(request,e);
								} else {
									throw e;
								}
							}
            }, 0);
        }

    }

    /**
     * generateOauthToken - Generate Outh toke for REST API
     *
     * @param  {string} grant_type  Grant type (Use client_credentials)
     * @param  {type} client_id     Client ID
     * @param  {type} client_secret Secret Key
     * @return {Promise}
     * @memberof Mura
     */
    function generateOauthToken(grant_type, client_id, client_secret) {
        return new Promise(function(resolve, reject) {
            get(Mura.apiEndpoint.replace('/json/', '/rest/') +
                'oauth?grant_type=' +
                encodeURIComponent(grant_type) +
                '&client_id=' + encodeURIComponent(
                    client_id) + '&client_secret=' +
                encodeURIComponent(client_secret) +
                '&cacheid=' + Math.random()).then(function(
                resp) {
                if (resp.data != 'undefined') {
                    resolve(resp.data);
                } else {

                    if (typeof resp.error != 'undefined' && typeof reject == 'function') {
                        reject(resp);
                    } else {
                        resolve(resp);
                    }
                }
            })
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
                        fn.call(el, event);
                    },
                    true
                );
            }
        }
    }

    function trigger(el, eventName, eventDetail) {

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


    };

    function off(el, eventName, fn) {
        el.removeEventListener(eventName, fn);
    }

    function parseSelection(selector) {
        if (typeof selector == 'object' && Array.isArray(selector)) {
            var selection = selector;
        } else if (typeof selector == 'string') {
            var selection = nodeListToArray(document.querySelectorAll(
                selector));
        } else {
            if ((typeof StaticNodeList != 'undefined' && selector instanceof StaticNodeList) ||
                selector instanceof NodeList || selector instanceof HTMLCollection
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
        return new root.Mura.DOMSelection(parseSelection(selector),
            selector);
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
     * @param  {*} val description
     * @return {boolean}
     * @memberof Mura
     */
    function isNumeric(val) {
        return Number(parseFloat(val)) == val;
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
     * @param  {form} form Form to serialize
     * @return {object}
     * @memberof Mura
     */
    function formToObject(form) {
        var field, s = {};
        if (typeof form == 'object' && form.nodeName == "FORM") {
            var len = form.elements.length;
            for (i = 0; i < len; i++) {
                field = form.elements[i];
                if (field.name && !field.disabled && field.type !=
                    'file' && field.type != 'reset' && field.type !=
                    'submit' && field.type != 'button') {
                    if (field.type == 'select-multiple') {
                        for (j = form.elements[i].options.length - 1; j >=
                            0; j--) {
                            if (field.options[j].selected)
                                s[s.name] = field.options[j].value;
                        }
                    } else if ((field.type != 'checkbox' && field.type !=
                            'radio') || field.checked) {
                        if (typeof s[field.name] == 'undefined') {
                            s[field.name] = field.value;
                        } else {
                            s[field.name] = s[field.name] + ',' + field
                                .value;
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
     * @return {object}
     * @memberof Mura
     */
    function extend(out) {
        out = out || {};

        for (var i = 1; i < arguments.length; i++) {
            if (!arguments[i])
                continue;

            for (var key in arguments[i]) {
                if (typeof arguments[i].hasOwnProperty != 'undefined' &&
                    arguments[i].hasOwnProperty(key))
                    out[key] = arguments[i][key];
            }
        }

        return out;
    };

    /**
     * extend - Extends object to full depth
     *
     * @return {object}
     * @memberof Mura
     */
    function deepExtend(out) {
        out = out || {};

        for (var i = 1; i < arguments.length; i++) {
            var obj = arguments[i];

            if (!obj)
                continue;

            for (var key in obj) {

                if (typeof arguments[i].hasOwnProperty != 'undefined' &&
                    arguments[i].hasOwnProperty(key)) {
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
     * @param  {string} name  Name
     * @param  {*} value Value
     * @param  {number} days  Days
     * @return {void}
     * @memberof Mura
     */
    function createCookie(name, value, days) {
        if (days) {
            var date = new Date();
            date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
            var expires = "; expires=" + date.toGMTString();
        } else var expires = "";
        document.cookie = name + "=" + value + expires + "; path=/";
    }

    /**
     * readCookie - Reads cookie value
     *
     * @param  {string} name Name
     * @return {*}
     * @memberof Mura
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
     * @param  {type} name description
     * @return {type}      description
     * @memberof Mura
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
        var oldonload = root.onload;
        if (typeof root.onload != 'function') {
            root.onload = func;
        } else {
            root.onload = function() {
                oldonload();
                func();
            }
        }
    }

    function noSpam(user, domain) {
        locationstring = "mailto:" + user + "@" + domain;
        root.location = locationstring;
    }

    /**
     * isUUID - description
     *
     * @param  {*} value Value
     * @return {boolean}
     * @memberof Mura
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
     * @return {string}
     * @memberof Mura
     */
    function createUUID() {
        var s = [],
            itoh = '0123456789ABCDEF';

        // Make array of random hex digits. The UUID only has 32 digits in it, but we
        // allocate an extra items to make room for the '-'s we'll be inserting.
        for (var i = 0; i < 35; i++) s[i] = Math.floor(Math.random() *
            0x10);

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
     * @param  {dom.element} el Dom Element
     * @return {void}
     */
    function setHTMLEditor(el) {

        function initEditor() {
            var instance = root.CKEDITOR.instances[el.getAttribute('id')];
            var conf = {
                height: 200,
                width: '70%'
            };

            extend(conf, Mura(el).data());

            if (instance) {
                instance.destroy();
                CKEDITOR.remove(instance);
            }

            root.CKEDITOR.replace(el.getAttribute('id'),
                getHTMLEditorConfig(conf), htmlEditorOnComplete);
        }

        function htmlEditorOnComplete(editorInstance) {
            editorInstance.resetDirty();
            var totalIntances = root.CKEDITOR.instances;
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
            root.Mura.requirementspath + '/ckeditor/ckeditor.js',
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

                if (typeof(root.Mura.loginURL) != "undefined") {
                    lu = root.Mura.loginURL;
                } else if (typeof(root.Mura.loginurl) !=
                    "undefined") {
                    lu = root.Mura.loginurl;
                } else {
                    lu = "?display=login";
                }

                if (typeof(root.Mura.returnURL) != "undefined") {
                    ru = root.Mura.returnURL;
                } else if (typeof(root.Mura.returnurl) !=
                    "undefined") {
                    ru = root.Mura.returnURL;
                } else {
                    ru = location.href;
                }
                pressed_keys = "";

                lu = new String(lu);
                if (lu.indexOf('?') != -1) {
                    location.href = lu + "&returnUrl=" +
                        encodeURIComponent(ru);
                } else {
                    location.href = lu + "?returnUrl=" +
                        encodeURIComponent(ru);
                }
            }
        }
    }

    /**
     * isInteger - Returns if the value is an integer
     *
     * @param  {*} s Value to check
     * @return {boolean}
     * @memberof Mura
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
        return (((year % 4 == 0) && ((!(year % 100 == 0)) || (year %
            400 == 0))) ? 29 : 28);
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

    function isDate(dtStr, fldName) {
        var daysInMonth = DaysArray(12);
        var dtArray = dtStr.split(root.Mura.dtCh);

        if (dtArray.length != 3) {
            //alert("The date format for the "+fldName+" field should be : short")
            return false
        }
        var strMonth = dtArray[root.Mura.dtFormat[0]];
        var strDay = dtArray[root.Mura.dtFormat[1]];
        var strYear = dtArray[root.Mura.dtFormat[2]];

        /*
        if(strYear.length == 2){
        	strYear="20" + strYear;
        }
        */
        strYr = strYear;

        if (strDay.charAt(0) == "0" && strDay.length > 1) strDay =
            strDay.substring(1)
        if (strMonth.charAt(0) == "0" && strMonth.length > 1) strMonth =
            strMonth.substring(1)
        for (var i = 1; i <= 3; i++) {
            if (strYr.charAt(0) == "0" && strYr.length > 1) strYr =
                strYr.substring(1)
        }

        month = parseInt(strMonth)
        day = parseInt(strDay)
        year = parseInt(strYr)

        if (month < 1 || month > 12) {
            //alert("Please enter a valid month in the "+fldName+" field")
            return false
        }
        if (day < 1 || day > 31 || (month == 2 && day > daysInFebruary(
                year)) || day > daysInMonth[month]) {
            //alert("Please enter a valid day  in the "+fldName+" field")
            return false
        }
        if (strYear.length != 4 || year == 0 || year < root.Mura.minYear ||
            year > root.Mura.maxYear) {
            //alert("Please enter a valid 4 digit year between "+root.Mura.minYear+" and "+root.Mura.maxYear +" in the "+fldName+" field")
            return false
        }
        if (isInteger(stripCharsInBag(dtStr, root.Mura.dtCh)) == false) {
            //alert("Please enter a valid date in the "+fldName+" field")
            return false
        }

        return true;
    }

    /**
     * isEmail - Returns if value is valid email
     *
     * @param  {string} str String to parse for email
     * @return {boolean}
     * @memberof Mura
     */
    function isEmail(cur) {
        var string1 = cur
        if (string1.indexOf("@") == -1 || string1.indexOf(".") == -1) {
            return false;
        } else {
            return true;
        }
    }

    function initShadowBox(el) {
        if (Mura(el).find('[data-rel^="shadowbox"],[rel^="shadowbox"]')
            .length) {

            loader().load(
                [
                    Mura.assetpath + '/css/shadowbox.min.css',
                    Mura.assetpath +
                    '/js/external/shadowbox/shadowbox.js'
                ],
                function() {
                    Mura('#shadowbox_overlay,#shadowbox_container')
                        .remove();
                    if (root.Shadowbox) {
                        root.Shadowbox.init();
                    }
                }
            );
        }
    }

    /**
     * validateForm - Validates Mura form
     *
     * @param  {type} frm          Form element to validate
     * @param  {function} customaction Custom action (optional)
     * @return {boolean}
     * @memberof Mura
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
                return (theField.getAttribute('data-required').toLowerCase() ==
                    'true');
            } else if (theField.getAttribute('required') != undefined) {
                return (theField.getAttribute('required').toLowerCase() ==
                    'true');
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
                return getValidationFieldName(theField).toUpperCase() +
                    defaultMessage;
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

                    if (validationType == 'EMAIL' && theField.value !=
                        '') {
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

                    } else if (validationType == 'REGEX' && theField.value !=
                        '' && hasValidationRegex(theField)) {
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
                            eq: theForm[getValidationMatchField(
                                theField)].value,
                            message: getValidationMessage(
                                theField, ' must match' +
                                getValidationMatchField(
                                    theField) + '.')
                        });

                    } else if (validationType == 'DATE' && theField.value !=
                        '') {
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
                    validations.properties[theField.getAttribute('name')] =
                        rules;
                    data[theField.getAttribute('name')] = theField.value;
                }
            }
        }
        var frmTextareas = theForm.getElementsByTagName("textarea");
        for (f = 0; f < frmTextareas.length; f++) {


            theField = frmTextareas[f];
            validationType = getValidationType(theField);

            rules = new Array();

            if (theField.style.display == "" && getValidationIsRequired(
                    theField)) {
                rules.push({
                    required: true,
                    message: getValidationMessage(theField,
                        ' is required.')
                });

            } else if (validationType != '') {
                if (validationType == 'REGEX' && theField.value != '' &&
                    hasValidationRegex(theField)) {
                    rules.push({
                        regex: getValidationRegex(theField),
                        message: getValidationMessage(theField,
                            ' is not valid.')
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

            if (theField.style.display == "" && getValidationIsRequired(
                    theField)) {
                rules.push({
                    required: true,
                    message: getValidationMessage(theField,
                        ' is required.')
                });
            }

            if (rules.length) {
                validations.properties[theField.getAttribute('name')] =
                    rules;
                data[theField.getAttribute('name')] = theField.value;
            }
        }

        try {
            //alert(JSON.stringify(validations));
            //console.log(data);
            //console.log(validations);
            ajax({
                type: 'post',
                url: root.Mura.apiEndpoint + '?method=validate',
                data: {
                    data: encodeURIComponent(JSON.stringify(
                        data)),
                    validations: encodeURIComponent(JSON.stringify(
                        validations)),
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
                            document.createElement('form').submit
                                .call(theForm);
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
        if (!root || root.innerHeight) {
            true;
        }

        try {
            var elemTop = el.getBoundingClientRect().top;
            var elemBottom = el.getBoundingClientRect().bottom;
        } catch (e) {
            return true;
        }

        var isVisible = elemTop < root.innerHeight && elemBottom >= 0;
        return isVisible;

    }

    /**
     * loader - Returns Mura.Loader
     *
     * @return {Mura.Loader}
     * @memberof Mura
     */
    function loader() {
        return root.Mura.ljs;
    }


    var layoutmanagertoolbar =
        '<div class="frontEndToolsModal mura"><span class="mura-edit-icon"></span></div>';

    function processMarkup(scope) {
        return new Promise(function(resolve, reject) {
            if (!(scope instanceof root.Mura.DOMSelection)) {
                scope = select(scope);
            }

            var self = scope;

            function find(selector) {
                return scope.find(selector);
            }

            var processors = [

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
                    if (find(
                            ".cffp_applied,  .cffp_mm, .cffp_kp"
                        ).length) {
                        var fileref = document.createElement(
                            'script')
                        fileref.setAttribute("type",
                            "text/javascript")
                        fileref.setAttribute("src", root.Mura
                            .requirementspath +
                            '/cfformprotect/js/cffp.js'
                        )

                        document.getElementsByTagName(
                            "head")[0].appendChild(
                            fileref)
                    }
                },

								function() {
										Mura.reCAPTCHALanguage = Mura.reCAPTCHALanguage ||	'en';

										if (find(".g-recaptcha").length) {
												var fileref = document.createElement('script')
												fileref.setAttribute("type","text/javascript");
												fileref.setAttribute(
													"src",
													"https://www.recaptcha.net/recaptcha/api.js?onload=MuraCheckForReCaptcha&render=explicit&hl=" +  Mura.reCAPTCHALanguage
												);

												document.getElementsByTagName("head")[0].appendChild(fileref);
										}

										if (find(".g-recaptcha-container").length) {
												loader().loadjs(
														"https://www.recaptcha.net/recaptcha/api.js?onload=MuraCheckForReCaptcha&render=explicit&hl=" +
														Mura.reCAPTCHALanguage,
														function() {
																find(
																		".g-recaptcha-container"
																).each(function(el) {
																		var self =  el;

																		MuraCheckForReCaptcha =
																				function() {
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
																														self
																														.getAttribute(
																																'id'
																														), {
																																'sitekey': self
																																		.getAttribute(
																																				'data-sitekey'
																																		),
																																'theme': self
																																		.getAttribute(
																																				'data-theme'
																																		),
																																'type': self
																																		.getAttribute(
																																				'data-type'
																																		)
																														}
																												)
																										);
																						} else {
																								setTimeout(
																												function() {
																														MuraCheckForReCaptcha();
																												},
																												10
																										);
																						}
																				}

																		MuraCheckForReCaptcha();

																});
														}
												);

										}
								},

                function() {
                    if (typeof resizeEditableObject ==
                        'function') {

                        scope.closest('.editableObject').each(
                            function() {
                                resizeEditableObject(
                                    this);
                            });

                        find(".editableObject").each(
                            function() {
                                resizeEditableObject(
                                    this);
                            });

                    }
                },

                function() {

                    if (typeof openFrontEndToolsModal ==
                        'function') {
                        find(".frontEndToolsModal").on(
                            'click',
                            function(event) {
                                event.preventDefault();
                                openFrontEndToolsModal(
                                    this);
                            }
                        );
                    }


                    if (root.MuraInlineEditor && root.MuraInlineEditor
                        .checkforImageCroppers) {
                        find("img").each(function() {
                            root.MuraInlineEditor.checkforImageCroppers(
                                this);
                        });

                    }

                },

                function() {
                    initShadowBox(scope.node);
                },

                function() {
                    if (typeof urlparams.Muraadminpreview !=
                        'undefined') {
                        find("a").each(function() {
                            var h = this.getAttribute(
                                'href');
                            if (typeof h ==
                                'string' && h.indexOf(
                                    'muraadminpreview'
                                ) == -1) {
                                h = h + (h.indexOf(
                                        '?') !=
                                    -1 ?
                                    "&muraadminpreview&mobileformat=" +
                                    root.Mura.mobileformat :
                                    "?muraadminpreview&muraadminpreview&mobileformat=" +
                                    root.Mura.mobileformat
                                );
                                this.setAttribute(
                                    'href', h);
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
                on(document, h, eventName[h]);
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

        if (Mura.formdata && frm.getAttribute(
                'enctype') == 'multipart/form-data') {

            var data = new FormData(frm);
            var checkdata = setLowerCaseKeys(formToObject(frm));
            var keys = deepExtend(setLowerCaseKeys(obj.data()),
                urlparams, {
                    siteid: root.Mura.siteid,
                    contentid: root.Mura.contentid,
                    contenthistid: root.Mura.contenthistid,
                    nocache: 1
                });

            for (var k in keys) {
                if (!(k in checkdata)) {
                    data.append(k, keys[k]);
                }
            }

            if ('objectparams' in checkdata) {
                data.append('objectparams2', encodeURIComponent(JSON.stringify(
                    obj.data('objectparams'))));
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
                url: root.Mura.apiEndpoint +
                    '?method=processAsyncObject',
                type: 'POST',
                data: data,
                success: function(resp) {
                    handleResponse(obj, resp);
                }
            }

        } else {

            var data = deepExtend(setLowerCaseKeys(obj.data()),
                urlparams, setLowerCaseKeys(formToObject(frm)), {
                    siteid: root.Mura.siteid,
                    contentid: root.Mura.contentid,
                    contenthistid: root.Mura.contenthistid,
                    nocache: 1
                });

            if (data.object == 'container' && data.content) {
                delete data.content;
            }

            if (!('g-recaptcha-response' in data)) {
                var reCaptchaCheck = Mura(frm).find(
                    "#g-recaptcha-response");

                if (reCaptchaCheck.length && typeof reCaptchaCheck.val() !=
                    'undefined') {
                    data['g-recaptcha-response'] = eCaptchaCheck.val();
                }
            }

            if ('objectparams' in data) {
                data['objectparams'] = encodeURIComponent(JSON.stringify(
                    data['objectparams']));
            }

            var postconfig = {
                url: root.Mura.apiEndpoint +
                    '?method=processAsyncObject',
                type: 'POST',
                data: data,
                success: function(resp) {
                    handleResponse(obj, resp);
                }
            }
        }

        var self = obj.node;
        self.prevInnerHTML = self.innerHTML;
        self.prevData = obj.data();
        self.innerHTML = root.Mura.preloaderMarkup;

        Mura(frm).trigger('formSubmit', data);

        ajax(postconfig);
    }

    function firstToUpperCase(str) {
        return str.substr(0, 1).toUpperCase() + str.substr(1);
    }

    function resetAsyncObject(el) {
        var self = Mura(el);

        self.removeClass('mura-active');
        self.removeAttr('data-perm');
        self.removeAttr('data-runtime');
        self.removeAttr('draggable');

        if (self.data('object') == 'container') {
            self.find('.mura-object:not([data-object="container"])').html(
                '');
            self.find('.frontEndToolsModal').remove();

            self.find('.mura-object').each(function() {
                var self = Mura(this);
                self.removeClass('mura-active');
                self.removeAttr('data-perm');
                self.removeAttr('data-inited');
                self.removeAttr('data-runtime');
                self.removeAttr('draggable');
            });

            self.find('.mura-object[data-object="container"]').each(
                function() {
                    var self = Mura(this);
                    var content = self.children(
                        'div.mura-object-content');

                    if (content.length) {
                        self.data('content', content.html());
                    }

                    content.html('');
                });

            self.find('.mura-object-meta').html('');
            var content = self.children('div.mura-object-content');

            if (content.length) {
                self.data('content', content.html());
            }
        }

        self.html('');
    }

    function processAsyncObject(el) {
        obj = Mura(el);
        if (obj.data('async') === null) {
            obj.data('async', true);
        }
        return processDisplayObject(obj, false, true);
    }

    function wireUpObject(obj, response, attempt) {

        attempt= attempt || 0;
        attempt++;

        function validateFormAjax(frm) {
            validateForm(frm,
                function(frm) {
                    submitForm(frm, obj);
                }
            );

            return false;

        }

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

        obj.data('inited', true);

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

        if (response) {
            if (typeof response == 'string') {
                obj.html(trim(response));
            } else if (typeof response.html == 'string' && response.render !=
                'client') {
                obj.html(trim(response.html));
            } else {
                if (obj.data('object') == 'container') {
                    var context = deepExtend(obj.data(), response);
                    context.targetEl = obj.node;
                    obj.prepend(Mura.templates.meta(context));
                } else {
                    var context = deepExtend(obj.data(), response);
                    var template = obj.data('clienttemplate') || obj.data(
                        'object');
                    var properNameCheck = firstToUpperCase(template);

                    if (typeof Mura.DisplayObject[properNameCheck] !=
                        'undefined') {
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

                    if (typeof Mura.DisplayObject[template] !=
                        'undefined') {
                        context.html = '';
                        obj.html(Mura.templates.content(context));
                        obj.prepend(Mura.templates.meta(context));
                        context.targetEl = obj.children(
                            '.mura-object-content').node;
                        Mura.displayObjectInstances[obj.data(
                            'instanceid')] = new Mura.DisplayObject[
                            template](context);
                    } else if (typeof Mura.templates[template] !=
                        'undefined') {
                        context.html = '';
                        obj.html(Mura.templates.content(context));
                        obj.prepend(Mura.templates.meta(context));
                        context.targetEl = obj.children(
                            '.mura-object-content').node;
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
            var context = obj.data();

            if (obj.data('object') == 'container') {
                obj.prepend(Mura.templates.meta(context));
            } else {
                var template = obj.data('clienttemplate') || obj.data(
                    'object');
                var properNameCheck = firstToUpperCase(template);

                if (typeof Mura.DisplayObject[properNameCheck] !=
                    'undefined') {
                    template = properNameCheck;
                }

                if (typeof Mura.DisplayObject[template] == 'function') {
                    context.html = '';
                    obj.html(Mura.templates.content(context));
                    obj.prepend(Mura.templates.meta(context));
                    context.targetEl = obj.children(
                        '.mura-object-content').node;
                    Mura.displayObjectInstances[obj.data('instanceid')] =
                        new Mura.DisplayObject[template](context);
                } else if (typeof Mura.templates[template] !=
                    'undefined') {
                    context.html = '';
                    obj.html(Mura.templates.content(context));
                    obj.prepend(Mura.templates.meta(context));
                    context.targetEl = obj.children(
                        '.mura-object-content').node;
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

        //obj.hide().show();

        if (Mura.layoutmanager && Mura.editing) {
            if (obj.hasClass('mura-body-object')) {
                obj.children('.frontEndToolsModal').remove();
                obj.prepend(layoutmanagertoolbar);
                MuraInlineEditor.setAnchorSaveChecks(obj.node);

                obj
                    .addClass('mura-active')
                    .hover(
                        function(e) {
                            //e.stopPropagation();
                            Mura('.mura-active-target').removeClass(
                                'mura-active-target');
                            Mura(this).addClass('mura-active-target');
                        },
                        function(e) {
                            //e.stopPropagation();
                            Mura(this).removeClass('mura-active-target');
                        }
                    );
            } else {
                if (Mura.type == 'Variation') {
                    var objectData = obj.data();
                    if (root.MuraInlineEditor && (root.MuraInlineEditor
                            .objectHasConfigurator(obj) || (!root.Mura.layoutmanager &&
                                root.MuraInlineEditor.objectHasEditor(
                                    objectParams)))) {
                        obj.children('.frontEndToolsModal').remove();
                        obj.prepend(layoutmanagertoolbar);
                        MuraInlineEditor.setAnchorSaveChecks(obj.node);

                        obj
                            .addClass('mura-active')
                            .hover(
                                function(e) {
                                    //e.stopPropagation();
                                    Mura('.mura-active-target').removeClass(
                                        'mura-active-target');
                                    Mura(this).addClass(
                                        'mura-active-target');
                                },
                                function(e) {
                                    //e.stopPropagation();
                                    Mura(this).removeClass(
                                        'mura-active-target');
                                }
                            );

                        Mura.initDraggableObject(self);
                    }
                } else {
                    var region = Mura(self).closest(
                        ".mura-region-local");
                    if (region && region.length) {
                        if (region.data('perm')) {
                            var objectData = obj.data();

                            if (root.MuraInlineEditor && (root.MuraInlineEditor
                                    .objectHasConfigurator(obj) || (!
                                        root.Mura.layoutmanager && root
                                        .MuraInlineEditor.objectHasEditor(
                                            objectData)))) {
                                obj.children('.frontEndToolsModal').remove();
                                obj.prepend(layoutmanagertoolbar);
                                MuraInlineEditor.setAnchorSaveChecks(
                                    obj.node);

                                obj
                                    .addClass('mura-active')
                                    .hover(
                                        function(e) {
                                            //e.stopPropagation();
                                            Mura('.mura-active-target')
                                                .removeClass(
                                                    'mura-active-target'
                                                );
                                            Mura(this).addClass(
                                                'mura-active-target'
                                            );
                                        },
                                        function(e) {
                                            //e.stopPropagation();
                                            Mura(this).removeClass(
                                                'mura-active-target'
                                            );
                                        }
                                    );

                                Mura.initDraggableObject(self);
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
                if (self.prevInnerHTML) {
                    e.preventDefault();
                    wireUpObject(obj, self.prevInnerHTML);

                    if (self.prevData) {
                        for (var p in self.prevData) {
                            select('[name="' + p + '"]')
                                .val(self.prevData[p]);
                        }
                    }
                    self.prevInnerHTML = false;
                    self.prevData = false;
                }
            });
        });


        obj.find('FORM').each(function() {
            var form = Mura(this);
            var self = this;

            if (form.data('async') || !(form.hasData('async') &&
                    !form.data('async')) && !(form.hasData(
                    'autowire') && !form.data('autowire')) && !
                form.attr('action') && !form.attr('onsubmit') &&
                !form.attr('onSubmit')) {
                self.onsubmit = function() {
                    return validateFormAjax(this);
                };
            }
        });

        if (obj.data('nextnid')) {
            obj.find('.mura-next-n a').each(function() {
                Mura(this).on('click', function(e) {
                    e.preventDefault();
                    var a = this.getAttribute('href').split(
                        '?');
                    if (a.length == 2) {
                        root.location.hash = a[1];
                    }

                });
            })
        }

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

    function processDisplayObject(el, queue, rerender, resolveFn) {

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

        el = el.node || el;
        var self = el;
        var rendered = !rerender && !(obj.hasClass('mura-async-object') ||
            obj.data('render') == 'client' || obj.data('async'));

        queue = (queue == null || rendered) ? false : queue;

        if (document.createEvent && queue && !isScrolledIntoView(el)) {
            if (!resolveFn) {
                return new Promise(function(resolve, reject) {

                    resolve = resolve || function() {};

                    setTimeout(
                        function() {
                            processDisplayObject(el, true,
                                false, resolve);
                        }, 10
                    );
                });
            } else {
                setTimeout(
                    function() {
                        var resp = processDisplayObject(el, true,
                            false, resolveFn);
                        if (typeof resp == 'object' && typeof resolveFn ==
                            'function') {
                            resp.then(resolveFn);
                        }
                    }, 10
                );

                return;
            }
        }

        if (!self.getAttribute('data-instanceid')) {
            self.setAttribute('data-instanceid', createUUID());
        }

        //if(obj.data('async')){
        obj.addClass("mura-async-object");
        //}

        if (obj.data('object') == 'container') {

            obj.html(Mura.templates.content(obj.data()));

            obj.find('.mura-object').each(function() {
                this.setAttribute('data-instanceid', createUUID());
            });

        }

        if (rendered) {
            return new Promise(function(resolve, reject) {
                var forms = obj.find('form');

                obj.find('form').each(function() {
                    var form = Mura(this);

                    if (form.data('async') || !(form.hasData(
                            'async') && !form.data(
                            'async')) && !(form.hasData(
                            'autowire') && !form.data(
                            'autowire')) && !form.attr(
                            'action') && !form.attr(
                            'onsubmit') && !form.attr(
                            'onSubmit')) {
                        form.on('submit', function(e) {
                            e.preventDefault();
                            validateForm(this,
                                function(
                                    frm) {
                                    submitForm
                                        (
                                            frm,
                                            obj
                                        );
                                }
                            );

                            return false;
                        });
                    }


                });

                if (typeof resolve == 'function') {
                    resolve(obj);
                }

            });
        }

        return new Promise(function(resolve, reject) {
            var data = deepExtend(setLowerCaseKeys(getData(self)),
                urlparams, {
                    siteid: root.Mura.siteid,
                    contentid: root.Mura.contentid,
                    contenthistid: root.Mura.contenthistid
                });

            delete data.inited;

            if (obj.data('contentid')) {
                data.contentid = self.getAttribute(
                    'data-contentid');
            }

            if (obj.data('contenthistid')) {
                data.contenthistid = self.getAttribute(
                    'data-contenthistid');
            }

            if ('objectparams' in data) {
                data['objectparams'] = encodeURIComponent(JSON.stringify(
                    data['objectparams']));
            }

            delete data.params;

            if (obj.data('object') == 'container') {
                wireUpObject(obj);
                if (typeof resolve == 'function') {
                    resolve.call(obj.node, obj);
                }
            } else {
                if (!obj.data('async') && obj.data('render') ==
                    'client') {
                    wireUpObject(obj);
                    if (typeof resolve == 'function') {
                        resolve.call(obj.node, obj);
                    }
                } else {
                    //console.log(data);
                    self.innerHTML = root.Mura.preloaderMarkup;
                    ajax({
                        url: root.Mura.apiEndpoint +
                            '?method=processAsyncObject',
                        type: 'get',
                        data: data,
                        success: function(resp) {
                            handleResponse(obj,
                                resp);
                            if (typeof resolve ==
                                'function') {
                                resolve.call(obj.node,
                                    obj);
                            }
                        }
                    });
                }

            }
        });

    }

    var hashparams = {};
    var urlparams = {};

    function handleHashChange() {

        var hash = root.location.hash;

        if (hash) {
            hash = hash.substring(1);
        }

        if (hash) {
            hashparams = getQueryStringParams(hash);
            if (hashparams.nextnid) {
                Mura('.mura-async-object[data-nextnid="' + hashparams.nextnid +
                    '"]').each(function() {
                    Mura(this).data(hashparams);
                    processAsyncObject(this);
                });
            } else if (hashparams.objectid) {
                Mura('.mura-async-object[data-objectid="' + hashparams.objectid +
                    '"]').each(function() {
                    Mura(this).data(hashparams);
                    processAsyncObject(this);
                });
            }
        }
    }

    /**
     * trim - description
     *
     * @param  {string} str Trims string
     * @return {string}     Trimmed string
     * @memberof Mura
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
            root.Mura.extend(muraObject.prototype, subClass);
        };

        muraObject.reopenClass = function(subClass) {
            root.Mura.extend(muraObject, subClass);
        };

        muraObject.on = function(eventName, fn) {
            eventName = eventName.toLowerCase();

            if (typeof muraObject.prototype.handlers[eventName] ==
                'undefined') {
                muraObject.prototype.handlers[eventName] = [];
            }

            if (!fn) {
                return muraObject;
            }

            for (var i = 0; i < muraObject.prototype.handlers[
                    eventName].length; i++) {
                if (muraObject.prototype.handlers[eventName][i] ==
                    handler) {
                    return muraObject;
                }
            }


            muraObject.prototype.handlers[eventName].push(fn);
            return muraObject;
        };

        muraObject.off = function(eventName, fn) {
            eventName = eventName.toLowerCase();

            if (typeof muraObject.prototype.handlers[eventName] ==
                'undefined') {
                muraObject.prototype.handlers[eventName] = [];
            }

            if (!fn) {
                muraObject.prototype.handlers[eventName] = [];
                return muraObject;
            }

            for (var i = 0; i < muraObject.prototype.handlers[
                    eventName].length; i++) {
                if (muraObject.prototype.handlers[eventName][i] ==
                    handler) {
                    muraObject.prototype.handlers[eventName].splice(
                        i, 1);
                }
            }
            return muraObject;
        }


        root.Mura.extend(muraObject.prototype, subClass);

        return muraObject;
    }


    /**
     * getQueryStringParams - Returns object of params in string
     *
     * @param  {string} queryString Query String
     * @return {object}
     * @memberof Mura
     */
    function getQueryStringParams(queryString) {
        queryString = queryString || root.location.search;
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

    //http://werxltd.com/wp/2010/05/13/javascript-implementation-of-javas-string-hashcode-method/

    /**
     * hashCode - description
     *
     * @param  {string} s String to hash
     * @return {string}
     * @memberof Mura
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

    function init(config) {

        if (config.rootpath) {
            config.context = config.rootpath;
        }

        if (config.endpoint) {
            config.context = config.endpoint;
        }

        if (!config.context) {
            config.context = '';
        }

        if (!config.assetpath) {
            config.assetpath = config.context + "/" + config.siteid;
        }

        if (!config.apiEndpoint) {
            config.apiEndpoint = config.context +
                '/index.cfm/_api/json/v1/' + config.siteid + '/';
        }

        if (!config.pluginspath) {
            config.pluginspath = config.context + '/plugins';
        }

        if (!config.requirementspath) {
            config.requirementspath = config.context + '/requirements';
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

        if (typeof config.rootdocumentdomain != 'undefined' && config.rootdocumentdomain !=
            '') {
            root.document.domain = config.rootdocumentdomain;
        }

				config.formdata=(typeof FormData != 'undefined') ? true : false;

        Mura.editing;

        extend(root.Mura, config);

        Mura(function() {

            var hash = root.location.hash;

            if (hash) {
                hash = hash.substring(1);
            }

            hashparams = setLowerCaseKeys(getQueryStringParams(
                hash));
            urlparams = setLowerCaseKeys(getQueryStringParams(
                root.location.search));

            if (hashparams.nextnid) {
                Mura('.mura-async-object[data-nextnid="' +
                    hashparams.nextnid + '"]').each(
                    function() {
                        Mura(this).data(hashparams);
                    });
            } else if (hashparams.objectid) {
                Mura('.mura-async-object[data-nextnid="' +
                    hashparams.objectid + '"]').each(
                    function() {
                        Mura(this).data(hashparams);
                    });
            }

            Mura(root).on('hashchange', handleHashChange);

            processMarkup(document);

            Mura(document)
                .on("keydown", function(event) {
                    loginCheck(event.which);
                });

            /*
            Mura.addEventHandler(
            	{
            		asyncObjectRendered:function(event){
            			alert(this.innerHTML);
            		}
            	}
            );

            Mura('#my-id').addDisplayObject('objectname',{..});

            Mura.login('userame','password')
            	.then(function(data){
            		alert(data.success);
            	});

            Mura.logout())
            	.then(function(data){
            		alert('you have logged out!');
            	});

            Mura.renderFilename('')
            	.then(function(item){
            		alert(item.get('title'));
            	});

            Mura.getEntity('content').loadBy('contentid','00000000000000000000000000000000001')
            	.then(function(item){
            		alert(item.get('title'));
            	});

            Mura.getEntity('content').loadBy('contentid','00000000000000000000000000000000001')
            	.then(function(item){
            		item.get('kids').then(function(kids){
            			alert(kids.get('items').length);
            		});
            	});

            Mura.getEntity('content').loadBy('contentid','1C2AD93E-E39C-C758-A005942E1399F4D6')
            	.then(function(item){
            		item.get('parent').then(function(parent){
            			alert(parent.get('title'));
            		});
            	});

            Mura.getEntity('content').
            	.set('parentid''1C2AD93E-E39C-C758-A005942E1399F4D6')
            	.set('approved',1)
            	.set('title','test 5')
            	.save()
            	.then(function(item){
            		alert(item.get('title'));
            	});

            Mura.getEntity('content').
            	.set(
            		{
            			parentid:'1C2AD93E-E39C-C758-A005942E1399F4D6',
            			approved:1,
            			title:'test 5'
            		}
            	.save()
            	.then(
            		function(item){
            			alert(item.get('title'));
            		});

            Mura.findQuery({
            		entityname:'content',
            		title:'Home'
            	})
            	.then(function(collection){
            		alert(collection.item(0).get('title'));
            	});
            */

            Mura(document).trigger('muraReady');

        });

        readyInternal(initReadyQueue);

        return root.Mura
    }

    extend(root, {
        Mura: extend(
            function(selector, context) {
                if (typeof selector == 'function') {
                    Mura.ready(selector);
                    return this;
                } else {
                    if (typeof context == 'undefined') {
                        return select(selector);
                    } else {
                        return select(context).find(
                            selector);
                    }
                }
            }, {
                rb: {},
                generateOAuthToken: generateOauthToken,
                entities: {},
                submitForm: submitForm,
                escapeHTML: escapeHTML,
                unescapeHTML: unescapeHTML,
                processDisplayObject: processDisplayObject,
                processAsyncObject: processAsyncObject,
                resetAsyncObject: resetAsyncObject,
                setLowerCaseKeys: setLowerCaseKeys,
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
                holdReady: holdReady,
                trackEvent: trackEvent,
                recordEvent: trackEvent
            }
        ),
        //these are here for legacy support
        validateForm: validateForm,
        setHTMLEditor: setHTMLEditor,
        createCookie: createCookie,
        readCookie: readCookie,
        addLoadEvent: addLoadEvent,
        noSpam: noSpam,
        initMura: init
    });

    //Legacy for early adopter backwords support
    root.mura = root.Mura
    root.m = root.Mura;
    root.Mura.displayObject = root.Mura.DisplayObject;

    //for some reason this can't be added via extend
    root.validateForm = validateForm;

    return root.Mura;
}));

/**
 * A namespace.
 * @namespace  Mura
 */
