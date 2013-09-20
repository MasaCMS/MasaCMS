/*
 * jQuery XDomainRequest Transport Plugin 1.1.3
 * https://github.com/blueimp/jQuery-File-Upload
 *
 * Copyright 2011, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 *
 * Based on Julian Aubourg's ajaxHooks xdr.js:
 * https://github.com/jaubourg/ajaxHooks/
 *//*jslint unparam: true *//*global define, window, XDomainRequest */(function(e){"use strict";typeof define=="function"&&define.amd?define(["jquery"],e):e(window.jQuery)})(function(e){"use strict";window.XDomainRequest&&!e.support.cors&&e.ajaxTransport(function(t){if(t.crossDomain&&t.async){if(t.timeout){t.xdrTimeout=t.timeout;delete t.timeout}var n;return{send:function(r,i){function u(t,r,s,o){n.onload=n.onerror=n.ontimeout=e.noop;n=null;i(t,r,s,o)}var o=/\?/.test(t.url)?"&":"?";n=new XDomainRequest;if(t.type==="DELETE"){t.url=t.url+o+"_method=DELETE";t.type="POST"}else if(t.type==="PUT"){t.url=t.url+o+"_method=PUT";t.type="POST"}else if(t.type==="PATCH"){t.url=t.url+o+"_method=PATCH";t.type="POST"}n.open(t.type,t.url);n.onload=function(){u(200,"OK",{text:n.responseText},"Content-Type: "+n.contentType)};n.onerror=function(){u(404,"Not Found")};if(t.xdrTimeout){n.ontimeout=function(){u(0,"timeout")};n.timeout=t.xdrTimeout}n.send(t.hasContent&&t.data||null)},abort:function(){if(n){n.onerror=e.noop();n.abort()}}}}})});