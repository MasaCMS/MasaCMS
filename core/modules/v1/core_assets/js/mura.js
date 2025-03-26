(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory();
	else if(typeof define === 'function' && define.amd)
		define("Mura", [], factory);
	else if(typeof exports === 'object')
		exports["Mura"] = factory();
	else
		root["Mura"] = factory();
})(self, function() {
return /******/ (function() { // webpackBootstrap
/******/ 	var __webpack_modules__ = ({

/***/ 9669:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

module.exports = __webpack_require__(1609);

/***/ }),

/***/ 5448:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";


var utils = __webpack_require__(4867);
var settle = __webpack_require__(6026);
var cookies = __webpack_require__(4372);
var buildURL = __webpack_require__(5327);
var buildFullPath = __webpack_require__(4097);
var parseHeaders = __webpack_require__(4109);
var isURLSameOrigin = __webpack_require__(7985);
var createError = __webpack_require__(5061);
var defaults = __webpack_require__(5655);
var Cancel = __webpack_require__(5263);

module.exports = function xhrAdapter(config) {
  return new Promise(function dispatchXhrRequest(resolve, reject) {
    var requestData = config.data;
    var requestHeaders = config.headers;
    var responseType = config.responseType;
    var onCanceled;
    function done() {
      if (config.cancelToken) {
        config.cancelToken.unsubscribe(onCanceled);
      }

      if (config.signal) {
        config.signal.removeEventListener('abort', onCanceled);
      }
    }

    if (utils.isFormData(requestData)) {
      delete requestHeaders['Content-Type']; // Let the browser set it
    }

    var request = new XMLHttpRequest();

    // HTTP basic authentication
    if (config.auth) {
      var username = config.auth.username || '';
      var password = config.auth.password ? unescape(encodeURIComponent(config.auth.password)) : '';
      requestHeaders.Authorization = 'Basic ' + btoa(username + ':' + password);
    }

    var fullPath = buildFullPath(config.baseURL, config.url);
    request.open(config.method.toUpperCase(), buildURL(fullPath, config.params, config.paramsSerializer), true);

    // Set the request timeout in MS
    request.timeout = config.timeout;

    function onloadend() {
      if (!request) {
        return;
      }
      // Prepare the response
      var responseHeaders = 'getAllResponseHeaders' in request ? parseHeaders(request.getAllResponseHeaders()) : null;
      var responseData = !responseType || responseType === 'text' ||  responseType === 'json' ?
        request.responseText : request.response;
      var response = {
        data: responseData,
        status: request.status,
        statusText: request.statusText,
        headers: responseHeaders,
        config: config,
        request: request
      };

      settle(function _resolve(value) {
        resolve(value);
        done();
      }, function _reject(err) {
        reject(err);
        done();
      }, response);

      // Clean up request
      request = null;
    }

    if ('onloadend' in request) {
      // Use onloadend if available
      request.onloadend = onloadend;
    } else {
      // Listen for ready state to emulate onloadend
      request.onreadystatechange = function handleLoad() {
        if (!request || request.readyState !== 4) {
          return;
        }

        // The request errored out and we didn't get a response, this will be
        // handled by onerror instead
        // With one exception: request that using file: protocol, most browsers
        // will return status as 0 even though it's a successful request
        if (request.status === 0 && !(request.responseURL && request.responseURL.indexOf('file:') === 0)) {
          return;
        }
        // readystate handler is calling before onerror or ontimeout handlers,
        // so we should call onloadend on the next 'tick'
        setTimeout(onloadend);
      };
    }

    // Handle browser request cancellation (as opposed to a manual cancellation)
    request.onabort = function handleAbort() {
      if (!request) {
        return;
      }

      reject(createError('Request aborted', config, 'ECONNABORTED', request));

      // Clean up request
      request = null;
    };

    // Handle low level network errors
    request.onerror = function handleError() {
      // Real errors are hidden from us by the browser
      // onerror should only fire if it's a network error
      reject(createError('Network Error', config, null, request));

      // Clean up request
      request = null;
    };

    // Handle timeout
    request.ontimeout = function handleTimeout() {
      var timeoutErrorMessage = config.timeout ? 'timeout of ' + config.timeout + 'ms exceeded' : 'timeout exceeded';
      var transitional = config.transitional || defaults.transitional;
      if (config.timeoutErrorMessage) {
        timeoutErrorMessage = config.timeoutErrorMessage;
      }
      reject(createError(
        timeoutErrorMessage,
        config,
        transitional.clarifyTimeoutError ? 'ETIMEDOUT' : 'ECONNABORTED',
        request));

      // Clean up request
      request = null;
    };

    // Add xsrf header
    // This is only done if running in a standard browser environment.
    // Specifically not if we're in a web worker, or react-native.
    if (utils.isStandardBrowserEnv()) {
      // Add xsrf header
      var xsrfValue = (config.withCredentials || isURLSameOrigin(fullPath)) && config.xsrfCookieName ?
        cookies.read(config.xsrfCookieName) :
        undefined;

      if (xsrfValue) {
        requestHeaders[config.xsrfHeaderName] = xsrfValue;
      }
    }

    // Add headers to the request
    if ('setRequestHeader' in request) {
      utils.forEach(requestHeaders, function setRequestHeader(val, key) {
        if (typeof requestData === 'undefined' && key.toLowerCase() === 'content-type') {
          // Remove Content-Type if data is undefined
          delete requestHeaders[key];
        } else {
          // Otherwise add header to the request
          request.setRequestHeader(key, val);
        }
      });
    }

    // Add withCredentials to request if needed
    if (!utils.isUndefined(config.withCredentials)) {
      request.withCredentials = !!config.withCredentials;
    }

    // Add responseType to request if needed
    if (responseType && responseType !== 'json') {
      request.responseType = config.responseType;
    }

    // Handle progress if needed
    if (typeof config.onDownloadProgress === 'function') {
      request.addEventListener('progress', config.onDownloadProgress);
    }

    // Not all browsers support upload events
    if (typeof config.onUploadProgress === 'function' && request.upload) {
      request.upload.addEventListener('progress', config.onUploadProgress);
    }

    if (config.cancelToken || config.signal) {
      // Handle cancellation
      // eslint-disable-next-line func-names
      onCanceled = function(cancel) {
        if (!request) {
          return;
        }
        reject(!cancel || (cancel && cancel.type) ? new Cancel('canceled') : cancel);
        request.abort();
        request = null;
      };

      config.cancelToken && config.cancelToken.subscribe(onCanceled);
      if (config.signal) {
        config.signal.aborted ? onCanceled() : config.signal.addEventListener('abort', onCanceled);
      }
    }

    if (!requestData) {
      requestData = null;
    }

    // Send the request
    request.send(requestData);
  });
};


/***/ }),

/***/ 1609:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";


var utils = __webpack_require__(4867);
var bind = __webpack_require__(1849);
var Axios = __webpack_require__(321);
var mergeConfig = __webpack_require__(7185);
var defaults = __webpack_require__(5655);

/**
 * Create an instance of Axios
 *
 * @param {Object} defaultConfig The default config for the instance
 * @return {Axios} A new instance of Axios
 */
function createInstance(defaultConfig) {
  var context = new Axios(defaultConfig);
  var instance = bind(Axios.prototype.request, context);

  // Copy axios.prototype to instance
  utils.extend(instance, Axios.prototype, context);

  // Copy context to instance
  utils.extend(instance, context);

  // Factory for creating new instances
  instance.create = function create(instanceConfig) {
    return createInstance(mergeConfig(defaultConfig, instanceConfig));
  };

  return instance;
}

// Create the default instance to be exported
var axios = createInstance(defaults);

// Expose Axios class to allow class inheritance
axios.Axios = Axios;

// Expose Cancel & CancelToken
axios.Cancel = __webpack_require__(5263);
axios.CancelToken = __webpack_require__(4972);
axios.isCancel = __webpack_require__(6502);
axios.VERSION = (__webpack_require__(7288).version);

// Expose all/spread
axios.all = function all(promises) {
  return Promise.all(promises);
};
axios.spread = __webpack_require__(8713);

// Expose isAxiosError
axios.isAxiosError = __webpack_require__(6268);

module.exports = axios;

// Allow use of default import syntax in TypeScript
module.exports["default"] = axios;


/***/ }),

/***/ 5263:
/***/ (function(module) {

"use strict";


/**
 * A `Cancel` is an object that is thrown when an operation is canceled.
 *
 * @class
 * @param {string=} message The message.
 */
function Cancel(message) {
  this.message = message;
}

Cancel.prototype.toString = function toString() {
  return 'Cancel' + (this.message ? ': ' + this.message : '');
};

Cancel.prototype.__CANCEL__ = true;

module.exports = Cancel;


/***/ }),

/***/ 4972:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";


var Cancel = __webpack_require__(5263);

/**
 * A `CancelToken` is an object that can be used to request cancellation of an operation.
 *
 * @class
 * @param {Function} executor The executor function.
 */
function CancelToken(executor) {
  if (typeof executor !== 'function') {
    throw new TypeError('executor must be a function.');
  }

  var resolvePromise;

  this.promise = new Promise(function promiseExecutor(resolve) {
    resolvePromise = resolve;
  });

  var token = this;

  // eslint-disable-next-line func-names
  this.promise.then(function(cancel) {
    if (!token._listeners) return;

    var i;
    var l = token._listeners.length;

    for (i = 0; i < l; i++) {
      token._listeners[i](cancel);
    }
    token._listeners = null;
  });

  // eslint-disable-next-line func-names
  this.promise.then = function(onfulfilled) {
    var _resolve;
    // eslint-disable-next-line func-names
    var promise = new Promise(function(resolve) {
      token.subscribe(resolve);
      _resolve = resolve;
    }).then(onfulfilled);

    promise.cancel = function reject() {
      token.unsubscribe(_resolve);
    };

    return promise;
  };

  executor(function cancel(message) {
    if (token.reason) {
      // Cancellation has already been requested
      return;
    }

    token.reason = new Cancel(message);
    resolvePromise(token.reason);
  });
}

/**
 * Throws a `Cancel` if cancellation has been requested.
 */
CancelToken.prototype.throwIfRequested = function throwIfRequested() {
  if (this.reason) {
    throw this.reason;
  }
};

/**
 * Subscribe to the cancel signal
 */

CancelToken.prototype.subscribe = function subscribe(listener) {
  if (this.reason) {
    listener(this.reason);
    return;
  }

  if (this._listeners) {
    this._listeners.push(listener);
  } else {
    this._listeners = [listener];
  }
};

/**
 * Unsubscribe from the cancel signal
 */

CancelToken.prototype.unsubscribe = function unsubscribe(listener) {
  if (!this._listeners) {
    return;
  }
  var index = this._listeners.indexOf(listener);
  if (index !== -1) {
    this._listeners.splice(index, 1);
  }
};

/**
 * Returns an object that contains a new `CancelToken` and a function that, when called,
 * cancels the `CancelToken`.
 */
CancelToken.source = function source() {
  var cancel;
  var token = new CancelToken(function executor(c) {
    cancel = c;
  });
  return {
    token: token,
    cancel: cancel
  };
};

module.exports = CancelToken;


/***/ }),

/***/ 6502:
/***/ (function(module) {

"use strict";


module.exports = function isCancel(value) {
  return !!(value && value.__CANCEL__);
};


/***/ }),

/***/ 321:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";


var utils = __webpack_require__(4867);
var buildURL = __webpack_require__(5327);
var InterceptorManager = __webpack_require__(782);
var dispatchRequest = __webpack_require__(3572);
var mergeConfig = __webpack_require__(7185);
var validator = __webpack_require__(4875);

var validators = validator.validators;
/**
 * Create a new instance of Axios
 *
 * @param {Object} instanceConfig The default config for the instance
 */
function Axios(instanceConfig) {
  this.defaults = instanceConfig;
  this.interceptors = {
    request: new InterceptorManager(),
    response: new InterceptorManager()
  };
}

/**
 * Dispatch a request
 *
 * @param {Object} config The config specific for this request (merged with this.defaults)
 */
Axios.prototype.request = function request(configOrUrl, config) {
  /*eslint no-param-reassign:0*/
  // Allow for axios('example/url'[, config]) a la fetch API
  if (typeof configOrUrl === 'string') {
    config = config || {};
    config.url = configOrUrl;
  } else {
    config = configOrUrl || {};
  }

  config = mergeConfig(this.defaults, config);

  // Set config.method
  if (config.method) {
    config.method = config.method.toLowerCase();
  } else if (this.defaults.method) {
    config.method = this.defaults.method.toLowerCase();
  } else {
    config.method = 'get';
  }

  var transitional = config.transitional;

  if (transitional !== undefined) {
    validator.assertOptions(transitional, {
      silentJSONParsing: validators.transitional(validators.boolean),
      forcedJSONParsing: validators.transitional(validators.boolean),
      clarifyTimeoutError: validators.transitional(validators.boolean)
    }, false);
  }

  // filter out skipped interceptors
  var requestInterceptorChain = [];
  var synchronousRequestInterceptors = true;
  this.interceptors.request.forEach(function unshiftRequestInterceptors(interceptor) {
    if (typeof interceptor.runWhen === 'function' && interceptor.runWhen(config) === false) {
      return;
    }

    synchronousRequestInterceptors = synchronousRequestInterceptors && interceptor.synchronous;

    requestInterceptorChain.unshift(interceptor.fulfilled, interceptor.rejected);
  });

  var responseInterceptorChain = [];
  this.interceptors.response.forEach(function pushResponseInterceptors(interceptor) {
    responseInterceptorChain.push(interceptor.fulfilled, interceptor.rejected);
  });

  var promise;

  if (!synchronousRequestInterceptors) {
    var chain = [dispatchRequest, undefined];

    Array.prototype.unshift.apply(chain, requestInterceptorChain);
    chain = chain.concat(responseInterceptorChain);

    promise = Promise.resolve(config);
    while (chain.length) {
      promise = promise.then(chain.shift(), chain.shift());
    }

    return promise;
  }


  var newConfig = config;
  while (requestInterceptorChain.length) {
    var onFulfilled = requestInterceptorChain.shift();
    var onRejected = requestInterceptorChain.shift();
    try {
      newConfig = onFulfilled(newConfig);
    } catch (error) {
      onRejected(error);
      break;
    }
  }

  try {
    promise = dispatchRequest(newConfig);
  } catch (error) {
    return Promise.reject(error);
  }

  while (responseInterceptorChain.length) {
    promise = promise.then(responseInterceptorChain.shift(), responseInterceptorChain.shift());
  }

  return promise;
};

Axios.prototype.getUri = function getUri(config) {
  config = mergeConfig(this.defaults, config);
  return buildURL(config.url, config.params, config.paramsSerializer).replace(/^\?/, '');
};

// Provide aliases for supported request methods
utils.forEach(['delete', 'get', 'head', 'options'], function forEachMethodNoData(method) {
  /*eslint func-names:0*/
  Axios.prototype[method] = function(url, config) {
    return this.request(mergeConfig(config || {}, {
      method: method,
      url: url,
      data: (config || {}).data
    }));
  };
});

utils.forEach(['post', 'put', 'patch'], function forEachMethodWithData(method) {
  /*eslint func-names:0*/
  Axios.prototype[method] = function(url, data, config) {
    return this.request(mergeConfig(config || {}, {
      method: method,
      url: url,
      data: data
    }));
  };
});

module.exports = Axios;


/***/ }),

/***/ 782:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";


var utils = __webpack_require__(4867);

function InterceptorManager() {
  this.handlers = [];
}

/**
 * Add a new interceptor to the stack
 *
 * @param {Function} fulfilled The function to handle `then` for a `Promise`
 * @param {Function} rejected The function to handle `reject` for a `Promise`
 *
 * @return {Number} An ID used to remove interceptor later
 */
InterceptorManager.prototype.use = function use(fulfilled, rejected, options) {
  this.handlers.push({
    fulfilled: fulfilled,
    rejected: rejected,
    synchronous: options ? options.synchronous : false,
    runWhen: options ? options.runWhen : null
  });
  return this.handlers.length - 1;
};

/**
 * Remove an interceptor from the stack
 *
 * @param {Number} id The ID that was returned by `use`
 */
InterceptorManager.prototype.eject = function eject(id) {
  if (this.handlers[id]) {
    this.handlers[id] = null;
  }
};

/**
 * Iterate over all the registered interceptors
 *
 * This method is particularly useful for skipping over any
 * interceptors that may have become `null` calling `eject`.
 *
 * @param {Function} fn The function to call for each interceptor
 */
InterceptorManager.prototype.forEach = function forEach(fn) {
  utils.forEach(this.handlers, function forEachHandler(h) {
    if (h !== null) {
      fn(h);
    }
  });
};

module.exports = InterceptorManager;


/***/ }),

/***/ 4097:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";


var isAbsoluteURL = __webpack_require__(1793);
var combineURLs = __webpack_require__(7303);

/**
 * Creates a new URL by combining the baseURL with the requestedURL,
 * only when the requestedURL is not already an absolute URL.
 * If the requestURL is absolute, this function returns the requestedURL untouched.
 *
 * @param {string} baseURL The base URL
 * @param {string} requestedURL Absolute or relative URL to combine
 * @returns {string} The combined full path
 */
module.exports = function buildFullPath(baseURL, requestedURL) {
  if (baseURL && !isAbsoluteURL(requestedURL)) {
    return combineURLs(baseURL, requestedURL);
  }
  return requestedURL;
};


/***/ }),

/***/ 5061:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";


var enhanceError = __webpack_require__(481);

/**
 * Create an Error with the specified message, config, error code, request and response.
 *
 * @param {string} message The error message.
 * @param {Object} config The config.
 * @param {string} [code] The error code (for example, 'ECONNABORTED').
 * @param {Object} [request] The request.
 * @param {Object} [response] The response.
 * @returns {Error} The created error.
 */
module.exports = function createError(message, config, code, request, response) {
  var error = new Error(message);
  return enhanceError(error, config, code, request, response);
};


/***/ }),

/***/ 3572:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";


var utils = __webpack_require__(4867);
var transformData = __webpack_require__(8527);
var isCancel = __webpack_require__(6502);
var defaults = __webpack_require__(5655);
var Cancel = __webpack_require__(5263);

/**
 * Throws a `Cancel` if cancellation has been requested.
 */
function throwIfCancellationRequested(config) {
  if (config.cancelToken) {
    config.cancelToken.throwIfRequested();
  }

  if (config.signal && config.signal.aborted) {
    throw new Cancel('canceled');
  }
}

/**
 * Dispatch a request to the server using the configured adapter.
 *
 * @param {object} config The config that is to be used for the request
 * @returns {Promise} The Promise to be fulfilled
 */
module.exports = function dispatchRequest(config) {
  throwIfCancellationRequested(config);

  // Ensure headers exist
  config.headers = config.headers || {};

  // Transform request data
  config.data = transformData.call(
    config,
    config.data,
    config.headers,
    config.transformRequest
  );

  // Flatten headers
  config.headers = utils.merge(
    config.headers.common || {},
    config.headers[config.method] || {},
    config.headers
  );

  utils.forEach(
    ['delete', 'get', 'head', 'post', 'put', 'patch', 'common'],
    function cleanHeaderConfig(method) {
      delete config.headers[method];
    }
  );

  var adapter = config.adapter || defaults.adapter;

  return adapter(config).then(function onAdapterResolution(response) {
    throwIfCancellationRequested(config);

    // Transform response data
    response.data = transformData.call(
      config,
      response.data,
      response.headers,
      config.transformResponse
    );

    return response;
  }, function onAdapterRejection(reason) {
    if (!isCancel(reason)) {
      throwIfCancellationRequested(config);

      // Transform response data
      if (reason && reason.response) {
        reason.response.data = transformData.call(
          config,
          reason.response.data,
          reason.response.headers,
          config.transformResponse
        );
      }
    }

    return Promise.reject(reason);
  });
};


/***/ }),

/***/ 481:
/***/ (function(module) {

"use strict";


/**
 * Update an Error with the specified config, error code, and response.
 *
 * @param {Error} error The error to update.
 * @param {Object} config The config.
 * @param {string} [code] The error code (for example, 'ECONNABORTED').
 * @param {Object} [request] The request.
 * @param {Object} [response] The response.
 * @returns {Error} The error.
 */
module.exports = function enhanceError(error, config, code, request, response) {
  error.config = config;
  if (code) {
    error.code = code;
  }

  error.request = request;
  error.response = response;
  error.isAxiosError = true;

  error.toJSON = function toJSON() {
    return {
      // Standard
      message: this.message,
      name: this.name,
      // Microsoft
      description: this.description,
      number: this.number,
      // Mozilla
      fileName: this.fileName,
      lineNumber: this.lineNumber,
      columnNumber: this.columnNumber,
      stack: this.stack,
      // Axios
      config: this.config,
      code: this.code,
      status: this.response && this.response.status ? this.response.status : null
    };
  };
  return error;
};


/***/ }),

/***/ 7185:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";


var utils = __webpack_require__(4867);

/**
 * Config-specific merge-function which creates a new config-object
 * by merging two configuration objects together.
 *
 * @param {Object} config1
 * @param {Object} config2
 * @returns {Object} New object resulting from merging config2 to config1
 */
module.exports = function mergeConfig(config1, config2) {
  // eslint-disable-next-line no-param-reassign
  config2 = config2 || {};
  var config = {};

  function getMergedValue(target, source) {
    if (utils.isPlainObject(target) && utils.isPlainObject(source)) {
      return utils.merge(target, source);
    } else if (utils.isPlainObject(source)) {
      return utils.merge({}, source);
    } else if (utils.isArray(source)) {
      return source.slice();
    }
    return source;
  }

  // eslint-disable-next-line consistent-return
  function mergeDeepProperties(prop) {
    if (!utils.isUndefined(config2[prop])) {
      return getMergedValue(config1[prop], config2[prop]);
    } else if (!utils.isUndefined(config1[prop])) {
      return getMergedValue(undefined, config1[prop]);
    }
  }

  // eslint-disable-next-line consistent-return
  function valueFromConfig2(prop) {
    if (!utils.isUndefined(config2[prop])) {
      return getMergedValue(undefined, config2[prop]);
    }
  }

  // eslint-disable-next-line consistent-return
  function defaultToConfig2(prop) {
    if (!utils.isUndefined(config2[prop])) {
      return getMergedValue(undefined, config2[prop]);
    } else if (!utils.isUndefined(config1[prop])) {
      return getMergedValue(undefined, config1[prop]);
    }
  }

  // eslint-disable-next-line consistent-return
  function mergeDirectKeys(prop) {
    if (prop in config2) {
      return getMergedValue(config1[prop], config2[prop]);
    } else if (prop in config1) {
      return getMergedValue(undefined, config1[prop]);
    }
  }

  var mergeMap = {
    'url': valueFromConfig2,
    'method': valueFromConfig2,
    'data': valueFromConfig2,
    'baseURL': defaultToConfig2,
    'transformRequest': defaultToConfig2,
    'transformResponse': defaultToConfig2,
    'paramsSerializer': defaultToConfig2,
    'timeout': defaultToConfig2,
    'timeoutMessage': defaultToConfig2,
    'withCredentials': defaultToConfig2,
    'adapter': defaultToConfig2,
    'responseType': defaultToConfig2,
    'xsrfCookieName': defaultToConfig2,
    'xsrfHeaderName': defaultToConfig2,
    'onUploadProgress': defaultToConfig2,
    'onDownloadProgress': defaultToConfig2,
    'decompress': defaultToConfig2,
    'maxContentLength': defaultToConfig2,
    'maxBodyLength': defaultToConfig2,
    'transport': defaultToConfig2,
    'httpAgent': defaultToConfig2,
    'httpsAgent': defaultToConfig2,
    'cancelToken': defaultToConfig2,
    'socketPath': defaultToConfig2,
    'responseEncoding': defaultToConfig2,
    'validateStatus': mergeDirectKeys
  };

  utils.forEach(Object.keys(config1).concat(Object.keys(config2)), function computeConfigValue(prop) {
    var merge = mergeMap[prop] || mergeDeepProperties;
    var configValue = merge(prop);
    (utils.isUndefined(configValue) && merge !== mergeDirectKeys) || (config[prop] = configValue);
  });

  return config;
};


/***/ }),

/***/ 6026:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";


var createError = __webpack_require__(5061);

/**
 * Resolve or reject a Promise based on response status.
 *
 * @param {Function} resolve A function that resolves the promise.
 * @param {Function} reject A function that rejects the promise.
 * @param {object} response The response.
 */
module.exports = function settle(resolve, reject, response) {
  var validateStatus = response.config.validateStatus;
  if (!response.status || !validateStatus || validateStatus(response.status)) {
    resolve(response);
  } else {
    reject(createError(
      'Request failed with status code ' + response.status,
      response.config,
      null,
      response.request,
      response
    ));
  }
};


/***/ }),

/***/ 8527:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";


var utils = __webpack_require__(4867);
var defaults = __webpack_require__(5655);

/**
 * Transform the data for a request or a response
 *
 * @param {Object|String} data The data to be transformed
 * @param {Array} headers The headers for the request or response
 * @param {Array|Function} fns A single function or Array of functions
 * @returns {*} The resulting transformed data
 */
module.exports = function transformData(data, headers, fns) {
  var context = this || defaults;
  /*eslint no-param-reassign:0*/
  utils.forEach(fns, function transform(fn) {
    data = fn.call(context, data, headers);
  });

  return data;
};


/***/ }),

/***/ 5655:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";


var utils = __webpack_require__(4867);
var normalizeHeaderName = __webpack_require__(6016);
var enhanceError = __webpack_require__(481);

var DEFAULT_CONTENT_TYPE = {
  'Content-Type': 'application/x-www-form-urlencoded'
};

function setContentTypeIfUnset(headers, value) {
  if (!utils.isUndefined(headers) && utils.isUndefined(headers['Content-Type'])) {
    headers['Content-Type'] = value;
  }
}

function getDefaultAdapter() {
  var adapter;
  if (typeof XMLHttpRequest !== 'undefined') {
    // For browsers use XHR adapter
    adapter = __webpack_require__(5448);
  } else if (typeof process !== 'undefined' && Object.prototype.toString.call(process) === '[object process]') {
    // For node use HTTP adapter
    adapter = __webpack_require__(5448);
  }
  return adapter;
}

function stringifySafely(rawValue, parser, encoder) {
  if (utils.isString(rawValue)) {
    try {
      (parser || JSON.parse)(rawValue);
      return utils.trim(rawValue);
    } catch (e) {
      if (e.name !== 'SyntaxError') {
        throw e;
      }
    }
  }

  return (encoder || JSON.stringify)(rawValue);
}

var defaults = {

  transitional: {
    silentJSONParsing: true,
    forcedJSONParsing: true,
    clarifyTimeoutError: false
  },

  adapter: getDefaultAdapter(),

  transformRequest: [function transformRequest(data, headers) {
    normalizeHeaderName(headers, 'Accept');
    normalizeHeaderName(headers, 'Content-Type');

    if (utils.isFormData(data) ||
      utils.isArrayBuffer(data) ||
      utils.isBuffer(data) ||
      utils.isStream(data) ||
      utils.isFile(data) ||
      utils.isBlob(data)
    ) {
      return data;
    }
    if (utils.isArrayBufferView(data)) {
      return data.buffer;
    }
    if (utils.isURLSearchParams(data)) {
      setContentTypeIfUnset(headers, 'application/x-www-form-urlencoded;charset=utf-8');
      return data.toString();
    }
    if (utils.isObject(data) || (headers && headers['Content-Type'] === 'application/json')) {
      setContentTypeIfUnset(headers, 'application/json');
      return stringifySafely(data);
    }
    return data;
  }],

  transformResponse: [function transformResponse(data) {
    var transitional = this.transitional || defaults.transitional;
    var silentJSONParsing = transitional && transitional.silentJSONParsing;
    var forcedJSONParsing = transitional && transitional.forcedJSONParsing;
    var strictJSONParsing = !silentJSONParsing && this.responseType === 'json';

    if (strictJSONParsing || (forcedJSONParsing && utils.isString(data) && data.length)) {
      try {
        return JSON.parse(data);
      } catch (e) {
        if (strictJSONParsing) {
          if (e.name === 'SyntaxError') {
            throw enhanceError(e, this, 'E_JSON_PARSE');
          }
          throw e;
        }
      }
    }

    return data;
  }],

  /**
   * A timeout in milliseconds to abort a request. If set to 0 (default) a
   * timeout is not created.
   */
  timeout: 0,

  xsrfCookieName: 'XSRF-TOKEN',
  xsrfHeaderName: 'X-XSRF-TOKEN',

  maxContentLength: -1,
  maxBodyLength: -1,

  validateStatus: function validateStatus(status) {
    return status >= 200 && status < 300;
  },

  headers: {
    common: {
      'Accept': 'application/json, text/plain, */*'
    }
  }
};

utils.forEach(['delete', 'get', 'head'], function forEachMethodNoData(method) {
  defaults.headers[method] = {};
});

utils.forEach(['post', 'put', 'patch'], function forEachMethodWithData(method) {
  defaults.headers[method] = utils.merge(DEFAULT_CONTENT_TYPE);
});

module.exports = defaults;


/***/ }),

/***/ 7288:
/***/ (function(module) {

module.exports = {
  "version": "0.26.0"
};

/***/ }),

/***/ 1849:
/***/ (function(module) {

"use strict";


module.exports = function bind(fn, thisArg) {
  return function wrap() {
    var args = new Array(arguments.length);
    for (var i = 0; i < args.length; i++) {
      args[i] = arguments[i];
    }
    return fn.apply(thisArg, args);
  };
};


/***/ }),

/***/ 5327:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";


var utils = __webpack_require__(4867);

function encode(val) {
  return encodeURIComponent(val).
    replace(/%3A/gi, ':').
    replace(/%24/g, '$').
    replace(/%2C/gi, ',').
    replace(/%20/g, '+').
    replace(/%5B/gi, '[').
    replace(/%5D/gi, ']');
}

/**
 * Build a URL by appending params to the end
 *
 * @param {string} url The base of the url (e.g., http://www.google.com)
 * @param {object} [params] The params to be appended
 * @returns {string} The formatted url
 */
module.exports = function buildURL(url, params, paramsSerializer) {
  /*eslint no-param-reassign:0*/
  if (!params) {
    return url;
  }

  var serializedParams;
  if (paramsSerializer) {
    serializedParams = paramsSerializer(params);
  } else if (utils.isURLSearchParams(params)) {
    serializedParams = params.toString();
  } else {
    var parts = [];

    utils.forEach(params, function serialize(val, key) {
      if (val === null || typeof val === 'undefined') {
        return;
      }

      if (utils.isArray(val)) {
        key = key + '[]';
      } else {
        val = [val];
      }

      utils.forEach(val, function parseValue(v) {
        if (utils.isDate(v)) {
          v = v.toISOString();
        } else if (utils.isObject(v)) {
          v = JSON.stringify(v);
        }
        parts.push(encode(key) + '=' + encode(v));
      });
    });

    serializedParams = parts.join('&');
  }

  if (serializedParams) {
    var hashmarkIndex = url.indexOf('#');
    if (hashmarkIndex !== -1) {
      url = url.slice(0, hashmarkIndex);
    }

    url += (url.indexOf('?') === -1 ? '?' : '&') + serializedParams;
  }

  return url;
};


/***/ }),

/***/ 7303:
/***/ (function(module) {

"use strict";


/**
 * Creates a new URL by combining the specified URLs
 *
 * @param {string} baseURL The base URL
 * @param {string} relativeURL The relative URL
 * @returns {string} The combined URL
 */
module.exports = function combineURLs(baseURL, relativeURL) {
  return relativeURL
    ? baseURL.replace(/\/+$/, '') + '/' + relativeURL.replace(/^\/+/, '')
    : baseURL;
};


/***/ }),

/***/ 4372:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";


var utils = __webpack_require__(4867);

module.exports = (
  utils.isStandardBrowserEnv() ?

  // Standard browser envs support document.cookie
    (function standardBrowserEnv() {
      return {
        write: function write(name, value, expires, path, domain, secure) {
          var cookie = [];
          cookie.push(name + '=' + encodeURIComponent(value));

          if (utils.isNumber(expires)) {
            cookie.push('expires=' + new Date(expires).toGMTString());
          }

          if (utils.isString(path)) {
            cookie.push('path=' + path);
          }

          if (utils.isString(domain)) {
            cookie.push('domain=' + domain);
          }

          if (secure === true) {
            cookie.push('secure');
          }

          document.cookie = cookie.join('; ');
        },

        read: function read(name) {
          var match = document.cookie.match(new RegExp('(^|;\\s*)(' + name + ')=([^;]*)'));
          return (match ? decodeURIComponent(match[3]) : null);
        },

        remove: function remove(name) {
          this.write(name, '', Date.now() - 86400000);
        }
      };
    })() :

  // Non standard browser env (web workers, react-native) lack needed support.
    (function nonStandardBrowserEnv() {
      return {
        write: function write() {},
        read: function read() { return null; },
        remove: function remove() {}
      };
    })()
);


/***/ }),

/***/ 1793:
/***/ (function(module) {

"use strict";


/**
 * Determines whether the specified URL is absolute
 *
 * @param {string} url The URL to test
 * @returns {boolean} True if the specified URL is absolute, otherwise false
 */
module.exports = function isAbsoluteURL(url) {
  // A URL is considered absolute if it begins with "<scheme>://" or "//" (protocol-relative URL).
  // RFC 3986 defines scheme name as a sequence of characters beginning with a letter and followed
  // by any combination of letters, digits, plus, period, or hyphen.
  return /^([a-z][a-z\d+\-.]*:)?\/\//i.test(url);
};


/***/ }),

/***/ 6268:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";


var utils = __webpack_require__(4867);

/**
 * Determines whether the payload is an error thrown by Axios
 *
 * @param {*} payload The value to test
 * @returns {boolean} True if the payload is an error thrown by Axios, otherwise false
 */
module.exports = function isAxiosError(payload) {
  return utils.isObject(payload) && (payload.isAxiosError === true);
};


/***/ }),

/***/ 7985:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";


var utils = __webpack_require__(4867);

module.exports = (
  utils.isStandardBrowserEnv() ?

  // Standard browser envs have full support of the APIs needed to test
  // whether the request URL is of the same origin as current location.
    (function standardBrowserEnv() {
      var msie = /(msie|trident)/i.test(navigator.userAgent);
      var urlParsingNode = document.createElement('a');
      var originURL;

      /**
    * Parse a URL to discover it's components
    *
    * @param {String} url The URL to be parsed
    * @returns {Object}
    */
      function resolveURL(url) {
        var href = url;

        if (msie) {
        // IE needs attribute set twice to normalize properties
          urlParsingNode.setAttribute('href', href);
          href = urlParsingNode.href;
        }

        urlParsingNode.setAttribute('href', href);

        // urlParsingNode provides the UrlUtils interface - http://url.spec.whatwg.org/#urlutils
        return {
          href: urlParsingNode.href,
          protocol: urlParsingNode.protocol ? urlParsingNode.protocol.replace(/:$/, '') : '',
          host: urlParsingNode.host,
          search: urlParsingNode.search ? urlParsingNode.search.replace(/^\?/, '') : '',
          hash: urlParsingNode.hash ? urlParsingNode.hash.replace(/^#/, '') : '',
          hostname: urlParsingNode.hostname,
          port: urlParsingNode.port,
          pathname: (urlParsingNode.pathname.charAt(0) === '/') ?
            urlParsingNode.pathname :
            '/' + urlParsingNode.pathname
        };
      }

      originURL = resolveURL(window.location.href);

      /**
    * Determine if a URL shares the same origin as the current location
    *
    * @param {String} requestURL The URL to test
    * @returns {boolean} True if URL shares the same origin, otherwise false
    */
      return function isURLSameOrigin(requestURL) {
        var parsed = (utils.isString(requestURL)) ? resolveURL(requestURL) : requestURL;
        return (parsed.protocol === originURL.protocol &&
            parsed.host === originURL.host);
      };
    })() :

  // Non standard browser envs (web workers, react-native) lack needed support.
    (function nonStandardBrowserEnv() {
      return function isURLSameOrigin() {
        return true;
      };
    })()
);


/***/ }),

/***/ 6016:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";


var utils = __webpack_require__(4867);

module.exports = function normalizeHeaderName(headers, normalizedName) {
  utils.forEach(headers, function processHeader(value, name) {
    if (name !== normalizedName && name.toUpperCase() === normalizedName.toUpperCase()) {
      headers[normalizedName] = value;
      delete headers[name];
    }
  });
};


/***/ }),

/***/ 4109:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";


var utils = __webpack_require__(4867);

// Headers whose duplicates are ignored by node
// c.f. https://nodejs.org/api/http.html#http_message_headers
var ignoreDuplicateOf = [
  'age', 'authorization', 'content-length', 'content-type', 'etag',
  'expires', 'from', 'host', 'if-modified-since', 'if-unmodified-since',
  'last-modified', 'location', 'max-forwards', 'proxy-authorization',
  'referer', 'retry-after', 'user-agent'
];

/**
 * Parse headers into an object
 *
 * ```
 * Date: Wed, 27 Aug 2014 08:58:49 GMT
 * Content-Type: application/json
 * Connection: keep-alive
 * Transfer-Encoding: chunked
 * ```
 *
 * @param {String} headers Headers needing to be parsed
 * @returns {Object} Headers parsed into an object
 */
module.exports = function parseHeaders(headers) {
  var parsed = {};
  var key;
  var val;
  var i;

  if (!headers) { return parsed; }

  utils.forEach(headers.split('\n'), function parser(line) {
    i = line.indexOf(':');
    key = utils.trim(line.substr(0, i)).toLowerCase();
    val = utils.trim(line.substr(i + 1));

    if (key) {
      if (parsed[key] && ignoreDuplicateOf.indexOf(key) >= 0) {
        return;
      }
      if (key === 'set-cookie') {
        parsed[key] = (parsed[key] ? parsed[key] : []).concat([val]);
      } else {
        parsed[key] = parsed[key] ? parsed[key] + ', ' + val : val;
      }
    }
  });

  return parsed;
};


/***/ }),

/***/ 8713:
/***/ (function(module) {

"use strict";


/**
 * Syntactic sugar for invoking a function and expanding an array for arguments.
 *
 * Common use case would be to use `Function.prototype.apply`.
 *
 *  ```js
 *  function f(x, y, z) {}
 *  var args = [1, 2, 3];
 *  f.apply(null, args);
 *  ```
 *
 * With `spread` this example can be re-written.
 *
 *  ```js
 *  spread(function(x, y, z) {})([1, 2, 3]);
 *  ```
 *
 * @param {Function} callback
 * @returns {Function}
 */
module.exports = function spread(callback) {
  return function wrap(arr) {
    return callback.apply(null, arr);
  };
};


/***/ }),

/***/ 4875:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";


var VERSION = (__webpack_require__(7288).version);

var validators = {};

// eslint-disable-next-line func-names
['object', 'boolean', 'number', 'function', 'string', 'symbol'].forEach(function(type, i) {
  validators[type] = function validator(thing) {
    return typeof thing === type || 'a' + (i < 1 ? 'n ' : ' ') + type;
  };
});

var deprecatedWarnings = {};

/**
 * Transitional option validator
 * @param {function|boolean?} validator - set to false if the transitional option has been removed
 * @param {string?} version - deprecated version / removed since version
 * @param {string?} message - some message with additional info
 * @returns {function}
 */
validators.transitional = function transitional(validator, version, message) {
  function formatMessage(opt, desc) {
    return '[Axios v' + VERSION + '] Transitional option \'' + opt + '\'' + desc + (message ? '. ' + message : '');
  }

  // eslint-disable-next-line func-names
  return function(value, opt, opts) {
    if (validator === false) {
      throw new Error(formatMessage(opt, ' has been removed' + (version ? ' in ' + version : '')));
    }

    if (version && !deprecatedWarnings[opt]) {
      deprecatedWarnings[opt] = true;
      // eslint-disable-next-line no-console
      console.warn(
        formatMessage(
          opt,
          ' has been deprecated since v' + version + ' and will be removed in the near future'
        )
      );
    }

    return validator ? validator(value, opt, opts) : true;
  };
};

/**
 * Assert object's properties type
 * @param {object} options
 * @param {object} schema
 * @param {boolean?} allowUnknown
 */

function assertOptions(options, schema, allowUnknown) {
  if (typeof options !== 'object') {
    throw new TypeError('options must be an object');
  }
  var keys = Object.keys(options);
  var i = keys.length;
  while (i-- > 0) {
    var opt = keys[i];
    var validator = schema[opt];
    if (validator) {
      var value = options[opt];
      var result = value === undefined || validator(value, opt, options);
      if (result !== true) {
        throw new TypeError('option ' + opt + ' must be ' + result);
      }
      continue;
    }
    if (allowUnknown !== true) {
      throw Error('Unknown option ' + opt);
    }
  }
}

module.exports = {
  assertOptions: assertOptions,
  validators: validators
};


/***/ }),

/***/ 4867:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";


var bind = __webpack_require__(1849);

// utils is a library of generic helper functions non-specific to axios

var toString = Object.prototype.toString;

/**
 * Determine if a value is an Array
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is an Array, otherwise false
 */
function isArray(val) {
  return Array.isArray(val);
}

/**
 * Determine if a value is undefined
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if the value is undefined, otherwise false
 */
function isUndefined(val) {
  return typeof val === 'undefined';
}

/**
 * Determine if a value is a Buffer
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is a Buffer, otherwise false
 */
function isBuffer(val) {
  return val !== null && !isUndefined(val) && val.constructor !== null && !isUndefined(val.constructor)
    && typeof val.constructor.isBuffer === 'function' && val.constructor.isBuffer(val);
}

/**
 * Determine if a value is an ArrayBuffer
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is an ArrayBuffer, otherwise false
 */
function isArrayBuffer(val) {
  return toString.call(val) === '[object ArrayBuffer]';
}

/**
 * Determine if a value is a FormData
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is an FormData, otherwise false
 */
function isFormData(val) {
  return toString.call(val) === '[object FormData]';
}

/**
 * Determine if a value is a view on an ArrayBuffer
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is a view on an ArrayBuffer, otherwise false
 */
function isArrayBufferView(val) {
  var result;
  if ((typeof ArrayBuffer !== 'undefined') && (ArrayBuffer.isView)) {
    result = ArrayBuffer.isView(val);
  } else {
    result = (val) && (val.buffer) && (isArrayBuffer(val.buffer));
  }
  return result;
}

/**
 * Determine if a value is a String
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is a String, otherwise false
 */
function isString(val) {
  return typeof val === 'string';
}

/**
 * Determine if a value is a Number
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is a Number, otherwise false
 */
function isNumber(val) {
  return typeof val === 'number';
}

/**
 * Determine if a value is an Object
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is an Object, otherwise false
 */
function isObject(val) {
  return val !== null && typeof val === 'object';
}

/**
 * Determine if a value is a plain Object
 *
 * @param {Object} val The value to test
 * @return {boolean} True if value is a plain Object, otherwise false
 */
function isPlainObject(val) {
  if (toString.call(val) !== '[object Object]') {
    return false;
  }

  var prototype = Object.getPrototypeOf(val);
  return prototype === null || prototype === Object.prototype;
}

/**
 * Determine if a value is a Date
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is a Date, otherwise false
 */
function isDate(val) {
  return toString.call(val) === '[object Date]';
}

/**
 * Determine if a value is a File
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is a File, otherwise false
 */
function isFile(val) {
  return toString.call(val) === '[object File]';
}

/**
 * Determine if a value is a Blob
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is a Blob, otherwise false
 */
function isBlob(val) {
  return toString.call(val) === '[object Blob]';
}

/**
 * Determine if a value is a Function
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is a Function, otherwise false
 */
function isFunction(val) {
  return toString.call(val) === '[object Function]';
}

/**
 * Determine if a value is a Stream
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is a Stream, otherwise false
 */
function isStream(val) {
  return isObject(val) && isFunction(val.pipe);
}

/**
 * Determine if a value is a URLSearchParams object
 *
 * @param {Object} val The value to test
 * @returns {boolean} True if value is a URLSearchParams object, otherwise false
 */
function isURLSearchParams(val) {
  return toString.call(val) === '[object URLSearchParams]';
}

/**
 * Trim excess whitespace off the beginning and end of a string
 *
 * @param {String} str The String to trim
 * @returns {String} The String freed of excess whitespace
 */
function trim(str) {
  return str.trim ? str.trim() : str.replace(/^\s+|\s+$/g, '');
}

/**
 * Determine if we're running in a standard browser environment
 *
 * This allows axios to run in a web worker, and react-native.
 * Both environments support XMLHttpRequest, but not fully standard globals.
 *
 * web workers:
 *  typeof window -> undefined
 *  typeof document -> undefined
 *
 * react-native:
 *  navigator.product -> 'ReactNative'
 * nativescript
 *  navigator.product -> 'NativeScript' or 'NS'
 */
function isStandardBrowserEnv() {
  if (typeof navigator !== 'undefined' && (navigator.product === 'ReactNative' ||
                                           navigator.product === 'NativeScript' ||
                                           navigator.product === 'NS')) {
    return false;
  }
  return (
    typeof window !== 'undefined' &&
    typeof document !== 'undefined'
  );
}

/**
 * Iterate over an Array or an Object invoking a function for each item.
 *
 * If `obj` is an Array callback will be called passing
 * the value, index, and complete array for each item.
 *
 * If 'obj' is an Object callback will be called passing
 * the value, key, and complete object for each property.
 *
 * @param {Object|Array} obj The object to iterate
 * @param {Function} fn The callback to invoke for each item
 */
function forEach(obj, fn) {
  // Don't bother if no value provided
  if (obj === null || typeof obj === 'undefined') {
    return;
  }

  // Force an array if not already something iterable
  if (typeof obj !== 'object') {
    /*eslint no-param-reassign:0*/
    obj = [obj];
  }

  if (isArray(obj)) {
    // Iterate over array values
    for (var i = 0, l = obj.length; i < l; i++) {
      fn.call(null, obj[i], i, obj);
    }
  } else {
    // Iterate over object keys
    for (var key in obj) {
      if (Object.prototype.hasOwnProperty.call(obj, key)) {
        fn.call(null, obj[key], key, obj);
      }
    }
  }
}

/**
 * Accepts varargs expecting each argument to be an object, then
 * immutably merges the properties of each object and returns result.
 *
 * When multiple objects contain the same key the later object in
 * the arguments list will take precedence.
 *
 * Example:
 *
 * ```js
 * var result = merge({foo: 123}, {foo: 456});
 * console.log(result.foo); // outputs 456
 * ```
 *
 * @param {Object} obj1 Object to merge
 * @returns {Object} Result of all merge properties
 */
function merge(/* obj1, obj2, obj3, ... */) {
  var result = {};
  function assignValue(val, key) {
    if (isPlainObject(result[key]) && isPlainObject(val)) {
      result[key] = merge(result[key], val);
    } else if (isPlainObject(val)) {
      result[key] = merge({}, val);
    } else if (isArray(val)) {
      result[key] = val.slice();
    } else {
      result[key] = val;
    }
  }

  for (var i = 0, l = arguments.length; i < l; i++) {
    forEach(arguments[i], assignValue);
  }
  return result;
}

/**
 * Extends object a by mutably adding to it the properties of object b.
 *
 * @param {Object} a The object to be extended
 * @param {Object} b The object to copy properties from
 * @param {Object} thisArg The object to bind function to
 * @return {Object} The resulting value of object a
 */
function extend(a, b, thisArg) {
  forEach(b, function assignValue(val, key) {
    if (thisArg && typeof val === 'function') {
      a[key] = bind(val, thisArg);
    } else {
      a[key] = val;
    }
  });
  return a;
}

/**
 * Remove byte order marker. This catches EF BB BF (the UTF-8 BOM)
 *
 * @param {string} content with BOM
 * @return {string} content value without BOM
 */
function stripBOM(content) {
  if (content.charCodeAt(0) === 0xFEFF) {
    content = content.slice(1);
  }
  return content;
}

module.exports = {
  isArray: isArray,
  isArrayBuffer: isArrayBuffer,
  isBuffer: isBuffer,
  isFormData: isFormData,
  isArrayBufferView: isArrayBufferView,
  isString: isString,
  isNumber: isNumber,
  isObject: isObject,
  isPlainObject: isPlainObject,
  isUndefined: isUndefined,
  isDate: isDate,
  isFile: isFile,
  isBlob: isBlob,
  isFunction: isFunction,
  isStream: isStream,
  isURLSearchParams: isURLSearchParams,
  isStandardBrowserEnv: isStandardBrowserEnv,
  forEach: forEach,
  merge: merge,
  extend: extend,
  trim: trim,
  stripBOM: stripBOM
};


/***/ }),

/***/ 2147:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var Mura = __webpack_require__(791);
/**
 * Creates a new Mura.Cache
 * @name Mura.Cache
 * @class
 * @extends Mura.Core
 * @memberof	Mura
 * @return {Mura.Cache}
 */


Mura.Cache = Mura.Core.extend(
/** @lends Mura.Cache.prototype */
{
  init: function init() {
    this.cache = {};
    return this;
  },

  /**
   * getKey - Returns Key value associated with key Name
   *
   * @param	{string} keyName Key Name
   * @return {*}				 Key Value
   */
  getKey: function getKey(keyName) {
    return Mura.hashCode(keyName);
  },

  /**
   * get - Returns the value associated with key name
   *
   * @param	{string} keyName	description
   * @param	{*} keyValue Default Value
   * @return {*}
   */
  get: function get(keyName, keyValue) {
    var key = this.getKey(keyName);

    if (typeof this.cache[key] != 'undefined') {
      return this.cache[key].keyValue;
    } else if (typeof keyValue != 'undefined') {
      this.set(keyName, keyValue, key);
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
  set: function set(keyName, keyValue, key) {
    key = key || this.getKey(keyName);
    this.cache[key] = {
      name: keyName,
      value: keyValue
    };
    return keyValue;
  },

  /**
   * has - Returns if the key name has a value in the cache
   *
   * @param	{string} keyName Key Name
   * @return {boolean}
   */
  has: function has(keyName) {
    return typeof this.cache[getKey(keyName)] != 'undefined';
  },

  /**
   * getAll - Returns object containing all key and key values
   *
   * @return {object}
   */
  getAll: function getAll() {
    return this.cache;
  },

  /**
   * purgeAll - Purges all key/value pairs from cache
   *
   * @return {object}	Self
   */
  purgeAll: function purgeAll() {
    this.cache = {};
    return this;
  },

  /**
   * purge - Purges specific key name from cache
   *
   * @param	{string} keyName Key Name
   * @return {object}				 Self
   */
  purge: function purge(keyName) {
    var key = this.getKey(keyName);
    if (typeof this.cache[key] != 'undefined') delete this.cache[key];
    return this;
  }
});
Mura.datacache = new Mura.Cache();

/***/ }),

/***/ 4506:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

function _typeof(obj) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (obj) { return typeof obj; } : function (obj) { return obj && "function" == typeof Symbol && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }, _typeof(obj); }

var Mura = __webpack_require__(791);
/**
* Creates a new Mura.entities.Content
* @name Mura.entities.Content
* @class
* @extends Mura.Entity
* @memberof Mura
* @param	{object} properties Object containing values to set into object
* @return {Mura.entities.Content}
*/


Mura.entities.Content = Mura.Entity.extend(
/** @lends Mura.entities.Content.prototype */
{
  /**
   * hasParent - Returns true if content has a parent.
   *
   * @return {boolean}
   */
  hasParent: function hasParent() {
    var parentid = this.get('parentid');
    return !(!parentid || ['00000000000000000000000000000000END', '00000000000000000000000000000000003', '00000000000000000000000000000000004', '00000000000000000000000000000000099'].find(function (value) {
      return value === parentid;
    }));
  },

  /**
   * updateFromDom - Updates editable data from what's in the DOM.
   *
   * @return {string}
   */
  updateFromDom: function updateFromDom() {
    var regions = this.get('displayregions');

    if (regions && _typeof(regions) === 'object') {
      Object.keys(regions).forEach(function (key) {
        var region = regions[key];

        if (region) {
          var items = [];
          Mura('.mura-region-local[data-regionid="' + region.regionid + '"]').forEach(function () {
            Mura(this).children('.mura-object[data-object]').forEach(function () {
              var obj = Mura(this);

              if (typeof Mura.displayObjectInstances[obj.data('instanceid')] != 'undefined') {
                Mura.displayObjectInstances[obj.data('instanceid')].reset(obj, false);
              }

              items.push(Mura.cleanModuleProps(obj.data()));
            });
          });
          region.local.items = items;
        }
      });
    }

    var self = this;
    Mura('div.mura-object[data-targetattr]').each(function () {
      var obj = Mura(this);

      if (typeof Mura.displayObjectInstances[obj.data('instanceid')] != 'undefined') {
        Mura.displayObjectInstances[obj.data('instanceid')].reset(obj, false);
      }

      self.set(obj.data('targetattr'), Mura.cleanModuleProps(Mura(this).data()));
    });
    Mura('.mura-editable-attribute.inline').forEach(function () {
      var editable = Mura(this);
      var attributeName = editable.data('attribute');
      self.set(attributeName, editable.html());
    });
    return this;
  },

  /**
   * renderDisplayRegion - Returns a string with display region markup.
   *
   * @return {string}
   */
  renderDisplayRegion: function renderDisplayRegion(region) {
    return Mura.buildDisplayRegion(this.get('displayregions')[region]);
  },

  /**
   * dspRegion - Appends a display region to a element.
   *
   * @return {self}
   */
  dspRegion: function dspRegion(selector, region, label) {
    if (Mura.isNumeric(region) && region <= this.get('displayregionnames').length) {
      region = this.get('displayregionnames')[region - 1];
    }

    Mura(selector).processDisplayRegion(this.get('displayregions')[region], label);
    return this;
  },

  /**
   * getRelatedContent - Gets related content sets by name
   *
   * @param	{string} relatedContentSetName
   * @param	{object} params
   * @return {Mura.EntityCollection}
   */
  getRelatedContent: function getRelatedContent(relatedContentSetName, params) {
    var self = this;
    relatedContentSetName = relatedContentSetName || '';
    return new Promise(function (resolve, reject) {
      var query = [];
      params = params || {};
      params.siteid = self.get('siteid') || Mura.siteid;

      if (self.has('contenthistid') && self.get('contenthistid')) {
        params.contenthistid = self.get('contenthistid');
      }

      for (var key in params) {
        if (key != 'entityname' && key != 'filename' && key != 'siteid' && key != 'method') {
          query.push(encodeURIComponent(key) + '=' + encodeURIComponent(params[key]));
        }
      }

      self._requestcontext.request({
        type: 'get',
        url: self._requestcontext.getAPIEndpoint() + '/content/' + self.get('contentid') + '/relatedcontent/' + relatedContentSetName + '?' + query.join('&'),
        params: params,
        success: function success(resp) {
          if (typeof resp.data.items != 'undefined') {
            var returnObj = new Mura.EntityCollection(resp.data, self._requestcontext);
          } else {
            var returnObj = new Mura.Entity({
              siteid: Mura.siteid
            }, self._requestcontext);

            for (var p in resp.data) {
              if (resp.data.hasOwnProperty(p)) {
                returnObj.set(p, new Mura.EntityCollection(resp.data[p], self._requestcontext));
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

/***/ 791:
/***/ (function(module) {

"use strict";
//require("babel-polyfill");
//require("./polyfill");

/**
 * login - Logs user into Mura
 *
 * @param	{string} username Username
 * @param	{string} password Password
 * @param	{string} siteid	 Siteid
 * @return {Promise}
 * @memberof {class} Mura
 */

function _typeof(obj) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (obj) { return typeof obj; } : function (obj) { return obj && "function" == typeof Symbol && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }, _typeof(obj); }

function login(username, password, siteid) {
  return Mura.getRequestContext().login(username, password, siteid);
}
/**
 * logout - Logs user out
 *
 * @param	{type} siteid Siteid
 * @return {Promise}
 * @memberof {class} Mura
 */


function logout(siteid) {
  return Mura.getRequestContext().logout(siteid);
}
/**
 * trackEvent - This is for Mura Experience Platform. It has no use with Mura standard
 *
 * @param	{object} data event data
 * @return {Promise}
 * @memberof {class} Mura
 */


function trackEvent(eventData) {
  if (typeof Mura.editing != 'undefined' && Mura.editing) {
    return new Promise(function (resolve, reject) {
      resolve = resolve || function () {};

      resolve();
    });
  }

  var data = {};
  var isMXP = typeof Mura.MXP != 'undefined';
  var trackingVars = {
    ga: {
      trackingvars: {}
    }
  };
  var gaFound = false;
  var gtagFound = false;
  var trackingComplete = false;
  var attempt = 0;
  data.category = eventData.event_category || eventData.eventCategory || eventData.category || '';
  data.action = eventData.event_action || eventData.eventAction || eventData.action || '';
  data.label = eventData.event_label || eventData.eventLabel || eventData.label || '';
  data.type = eventData.hit_ype || eventData.hitType || eventData.type || 'event';
  data.value = eventData.event_value || eventData.eventValue || eventData.value || undefined;

  if (typeof eventData.nonInteraction == 'undefined') {
    data.nonInteraction = false;
  } else {
    data.nonInteraction = eventData.nonInteraction;
  }

  data.contentid = eventData.contentid || Mura.contentid;
  data.objectid = eventData.objectid || '';

  function track() {
    if (!attempt) {
      trackingVars.ga.trackingvars.eventCategory = data.category;
      trackingVars.ga.trackingvars.eventAction = data.action;
      trackingVars.ga.trackingvars.nonInteraction = data.nonInteraction;
      trackingVars.ga.trackingvars.hitType = data.type;

      if (typeof data.value != 'undefined' && Mura.isNumeric(data.value)) {
        trackingVars.ga.trackingvars.eventValue = data.value;
      }

      if (data.label) {
        trackingVars.ga.trackingvars.eventLabel = data.label;
      } else if (isMXP) {
        if (typeof trackingVars.object != 'undefined') {
          trackingVars.ga.trackingvars.eventLabel = trackingVars.object.title;
        } else {
          trackingVars.ga.trackingvars.eventLabel = trackingVars.content.title;
        }

        data.label = trackingVars.object.title;
      }

      Mura(document).trigger('muraTrackEvent', trackingVars);
      Mura(document).trigger('muraRecordEvent', trackingVars);
    }

    if (typeof gtag != 'undefined') {
      trackingVars.ga.trackingvars.event_category = trackingVars.ga.trackingvars.eventCategory;
      trackingVars.ga.trackingvars.event_action = trackingVars.ga.trackingvars.eventAction;
      trackingVars.ga.trackingvars.non_interaction = trackingVars.ga.trackingvars.nonInteraction;
      trackingVars.ga.trackingvars.hit_type = trackingVars.ga.trackingvars.hitType;
      trackingVars.ga.trackingvars.event_value = trackingVars.ga.trackingvars.eventValue;
      trackingVars.ga.trackingvars.event_label = trackingVars.ga.trackingvars.eventLabel;
      delete trackingVars.ga.trackingvars.eventCategory;
      delete trackingVars.ga.trackingvars.eventAction;
      delete trackingVars.ga.trackingvars.nonInteraction;
      delete trackingVars.ga.trackingvars.hitType;
      delete trackingVars.ga.trackingvars.eventValue;
      delete trackingVars.ga.trackingvars.eventLabel;

      if (isMXP) {
        trackingVars.ga.trackingvars.send_to = Mura.trackingVars.ga.trackingid;
      }

      gtag('event', data.type, trackingVars.ga.trackingvars);
      gaFound = true;
      trackingComplete = true;
    } else if (typeof ga != 'undefined') {
      if (isMXP) {
        ga('mxpGATracker.send', data.type, trackingVars.ga.trackingvars);
      } else {
        ga('send', data.type, trackingVars.ga.trackingvars);
      }

      gaFound = true;
      trackingComplete = true;
    }

    attempt++;

    if (!gaFound && attempt < 250) {
      setTimeout(track, 1);
    } else {
      trackingComplete = true;
    }
  }

  if (isMXP) {
    var trackingID = data.contentid + data.objectid;

    if (typeof Mura.trackingMetadata[trackingID] != 'undefined') {
      Mura.deepExtend(trackingVars, Mura.trackingMetadata[trackingID]);
      trackingVars.eventData = data;
      track();
    } else {
      Mura.get(Mura.getAPIEndpoint(), {
        method: 'findTrackingProps',
        siteid: Mura.siteid,
        contentid: data.contentid,
        objectid: data.objectid
      }).then(function (response) {
        Mura.deepExtend(trackingVars, response.data);
        trackingVars.eventData = data;

        for (var p in trackingVars.ga.trackingprops) {
          if (trackingVars.ga.trackingprops.hasOwnProperty(p) && p.substring(0, 1) == 'd' && typeof trackingVars.ga.trackingprops[p] != 'string') {
            trackingVars.ga.trackingprops[p] = new String(trackingVars.ga[p]);
          }
        }

        Mura.trackingMetadata[trackingID] = {};
        Mura.deepExtend(Mura.trackingMetadata[trackingID], response.data);
        track();
      });
    }
  } else {
    track();
  }

  return new Promise(function (resolve, reject) {
    resolve = resolve || function () {};

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
  return Mura.getRequestContext().renderFilename(filename, params);
}
/**
 * declareEntity - Declare Entity with in service factory
 *
 * @param	{object} entityConfig Entity config object
 * @return {Promise}
 * @memberof {class} Mura
 */


function declareEntity(entityConfig) {
  return Mura.getRequestContext().declareEntity(entityConfig);
}
/**
 * undeclareEntity - Deletes entity class from Mura
 *
 * @param	{object} entityName
 * @return {Promise}
 * @memberof {class} Mura
 */


function undeclareEntity(entityName, deleteSchema) {
  deleteSchema = deleteSchema || false;
  return Mura.getRequestContext().undeclareEntity(entityName, deleteSchema);
}
/**
 * openGate - Open's content gate when using MXP
 *
 * @param	{string} contentid Optional: default's to Mura.contentid
 * @return {Promise}
 * @memberof {class} Mura
 */


function openGate(contentid) {
  return Mura.getRequestContext().openGate(contentid);
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
  siteid = siteid || Mura.siteid;
  return Mura.getRequestContext().getEntity(entityname, siteid);
}
/**
 * getFeed - Return new instance of Mura.Feed
 *
 * @param	{type} entityname Entity name
 * @return {Mura.Feed}
 * @memberof {class} Mura
 */


function getFeed(entityname, siteid) {
  siteid = siteid || Mura.siteid;
  return Mura.getRequestContext().getFeed(entityname, siteid);
}
/**
 * getCurrentUser - Return Mura.Entity for current user
 *
 * @param	{object} params Load parameters, fields:list of fields
 * @return {Promise}
 * @memberof {class} Mura
 */


function getCurrentUser(params) {
  return Mura.getRequestContext().getCurrentUser(params);
}
/**
 * findText - Return Mura.Collection for content with text
 *
 * @param	{object} params Load parameters
 * @return {Promise}
 * @memberof {class} Mura
 */


function findText(text, params) {
  return Mura.getRequestContext().findText(text, params);
}
/**
 * findQuery - Returns Mura.EntityCollection with properties that match params
 *
 * @param	{object} params Object of matching params
 * @return {Promise}
 * @memberof {class} Mura
 */


function findQuery(params) {
  return Mura.getRequestContext().findQuery(params);
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
    } else if (ret[i].nodeType == 1 || ret[i].nodeType == 9 || ret[i].nodeType == 11) {
      evalScripts(ret[i]);
    }
  }

  for (var $script in scripts) {
    evalScript(scripts[$script]);
  }
}

function evalScript(el) {
  if (el.src) {
    Mura.loader().load(el.src);
    Mura(el).remove();
  } else {
    var data = el.text || el.textContent || el.innerHTML || "";
    var head = document.getElementsByTagName("head")[0] || document.documentElement,
        script = document.createElement("script");
    script.type = "text/javascript"; //script.appendChild( document.createTextNode( data ) );

    script.text = data;
    head.insertBefore(script, head.firstChild);
    head.removeChild(script);

    if (el.parentNode) {
      el.parentNode.removeChild(el);
    }
  }
}

function nodeName(el, name) {
  return el.nodeName && el.nodeName.toUpperCase() === name.toUpperCase();
}

function changeElementType(el, to) {
  var newEl = document.createElement(to); // Try to copy attributes across

  for (var i = 0, a = el.attributes, n = a.length; i < n; ++i) {
    el.setAttribute(a[i].name, a[i].value);
  } // Try to move children across


  while (el.hasChildNodes()) {
    newEl.appendChild(el.firstChild);
  } // Replace the old element with the new one


  el.parentNode.replaceChild(newEl, el); // Return the new element, for good measure.

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
var holdingPreInitQueue = [];
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
}

;

function releaseReadyQueue() {
  holdingQueueReleased = true;
  holdingReady = false;
  holdingQueue.forEach(function (fn) {
    readyInternal(fn);
  });
  holdingQueue = [];
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
  if (typeof document != 'undefined') {
    if (document.readyState != 'loading') {
      //IE set the readyState to interative too early
      setTimeout(function () {
        fn(Mura);
      }, 1);
    } else {
      document.addEventListener('DOMContentLoaded', function () {
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
  return Mura.getRequestContext().get(url, data, eventHandler);
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
  return Mura.getRequestContext().post(url, data, eventHandler);
}
/**
 * put - Make PUT request
 *
 * @param	{url} url	URL
 * @param	{object} data Data to send to url
 * @return {Promise}
 * @memberof {class} Mura
 */


function put(url, data, config) {
  return Mura.getRequestContext().put(url, data, config);
}
/**
 * update - Make UPDATE request
 *
 * @param	{url} url	URL
 * @param	{object} data Data to send to url
 * @return {Promise}
 * @memberof {class} Mura
 */


function patch(url, data, config) {
  return Mura.getRequestContext().patch(url, data, config);
}
/**
 * delete - Make Delete request
 *
 * @param	{url} url	URL
 * @param	{object} data Data to send to url
 * @return {Promise}
 * @memberof {class} Mura
 */


function deleteReq(url, data, config) {
  return Mura.getRequestContext().delete(url, data, config);
}
/**
 * ajax - Make ajax request
 *
 * @param	{object} params
 * @return {Promise}
 * @memberof {class} Mura
 */


function ajax(config) {
  return Mura.getRequestContext().request(config);
}
/**
 * normalizeRequestHandler - Standardizes request handler objects
 *
 * @param	{object} eventHandler
 * @memberof {object} eventHandler
 */


function normalizeRequestHandler(eventHandler) {
  eventHandler.progress = eventHandler.progress || eventHandler.onProgress || eventHandler.onUploadProgress || function () {};

  eventHandler.download = eventHandler.download || eventHandler.onDownload || eventHandler.onDownloadProgress || function () {};

  eventHandler.abort = eventHandler.abort || eventHandler.onAbort || function () {};

  eventHandler.success = eventHandler.success || eventHandler.onSuccess || function () {};

  eventHandler.error = eventHandler.error || eventHandler.onError || function () {};

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


function getRequestContext(request, response, headers, siteid, endpoint, mode) {
  //Logic aded to support single config object arg
  if (_typeof(request) === 'object' && _typeof(request.req) === 'object' && typeof response === 'undefined') {
    var config = request;
    request = config.req;
    response = config.res;
    headers = config.headers;
    siteid = config.siteid;
    endpoint = config.endpoint;
    mode = config.mode;
  } else {
    if (typeof headers == 'string') {
      var originalSiteid = siteid;
      siteid = headers;

      if (_typeof(originalSiteid) === 'object') {
        headers = originalSiteid;
      } else {
        headers = {};
      }
    }
  }

  request = request || Mura.request;
  response = response || Mura.response;
  endpoint = endpoint || Mura.getAPIEndpoint();
  mode = mode || Mura.getMode();
  return new Mura.RequestContext(request, response, headers, siteid, endpoint, mode);
}
/**
 * getDefaultRequestContext - Returns the default Mura.RequestContext;
 *
 * @name getDefaultRequestContext
 * @return {Mura.RequestContext}	 Mura.RequestContext
 * @memberof {class} Mura
 */


function getDefaultRequestContext() {
  return Mura.getRequestContext();
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
  return new Promise(function (resolve, reject) {
    get(Mura.getAPIEndpoint().replace('/json/', '/rest/') + 'oauth?grant_type=' + encodeURIComponent(grant_type) + '&client_id=' + encodeURIComponent(client_id) + '&client_secret=' + encodeURIComponent(client_secret) + '&_cacheid=' + Math.random()).then(function (resp) {
      if (resp.data != 'undefined') {
        resolve(resp.data);
      } else {
        if (typeof resp.error != 'undefined' && typeof reject == 'function') {
          reject(resp);
        } else {
          resolve(resp);
        }
      }
    });
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
      el.addEventListener(eventName, function (event) {
        if (typeof fn.call == 'undefined') {
          fn(event);
        } else {
          fn.call(el, event);
        }
      }, true);
    }
  }
}

function trigger(el, eventName, eventDetail) {
  if (typeof document != 'undefined') {
    var bubbles = eventName == "change" ? false : true;

    if (document.createEvent) {
      if (eventDetail && !isEmptyObject(eventDetail)) {
        var event = document.createEvent('CustomEvent');
        event.initCustomEvent(eventName, bubbles, true, eventDetail);
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
        console.warn("Event failed to fire due to legacy browser: on" + eventName);
      }
    }
  }
}

;

function off(el, eventName, fn) {
  el.removeEventListener(eventName, fn);
}

function parseSelection(selector) {
  if (_typeof(selector) == 'object' && Array.isArray(selector)) {
    var selection = selector;
  } else if (typeof selector == 'string') {
    var selection = nodeListToArray(document.querySelectorAll(selector));
  } else {
    if (typeof StaticNodeList != 'undefined' && selector instanceof StaticNodeList || typeof NodeList != 'undefined' && selector instanceof NodeList || typeof HTMLCollection != 'undefined' && selector instanceof HTMLCollection) {
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
  return _typeof(obj) != 'object' || Object.keys(obj).length == 0;
}

function filter(selector, fn) {
  return select(parseSelection(selector)).filter(fn);
}

function nodeListToArray(nodeList) {
  var arr = [];

  for (var i = nodeList.length; i--; arr.unshift(nodeList[i])) {
    ;
  }

  return arr;
}

function select(selector) {
  return new Mura.DOMSelection(parseSelection(selector), selector);
}

function escapeHTML(str) {
  if (typeof document != 'undefined') {
    var div = document.createElement('div');
    div.appendChild(document.createTextNode(str));
    return div.innerHTML;
  } else {
    return Mura._escapeHTML(str);
  }
}

; // UNSAFE with unsafe strings; only use on previously-escaped ones!

function unescapeHTML(escapedStr) {
  var div = document.createElement('div');
  div.innerHTML = escapedStr;
  var child = div.childNodes[0];
  return child ? child.nodeValue : '';
}

;

function parseHTML(str) {
  var tmp = document.implementation.createHTMLDocument();
  tmp.body.innerHTML = str;
  return tmp.body.children;
}

;

function parseStringAsTemplate(stringValue) {
  var errors = {};
  var parsedString = stringValue;
  var doLoop = true;

  do {
    var finder = /(\${)(.+?)(})/.exec(parsedString);

    if (finder) {
      var template = void 0;

      try {
        template = eval('`${' + finder[2] + '}`');
      } catch (e) {
        console.log('error parsing string template: ' + '${' + finder[2] + '}', e);
        template = '[error]' + finder[2] + '[/error]';
      }

      parsedString = parsedString.replace(finder[0], template);
    } else {
      doLoop = false;
    }
  } while (doLoop);

  parsedString = parsedString.replace('[error]', '${');
  parsedString = parsedString.replace('[/error]', '}');
  return parsedString;
}

function getData(el) {
  var data = {};
  Array.prototype.forEach.call(el.attributes, function (attr) {
    if (/^data-/.test(attr.name)) {
      data[attr.name.substr(5)] = parseString(attr.value);
    }
  });
  return data;
}

function getProps(el) {
  return getData(el);
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


function buildDisplayRegion(data) {
  if (typeof data == 'undefined') {
    return '';
  }

  var str = "<div class=\"mura-region\" data-regionid=\"" + escapeHTML(data.regionid) + "\">";

  function buildItemHeader(data) {
    var classes = data.class || '';
    var header = "<div class=\"mura-object " + escapeHTML(classes) + "\"";

    for (var p in data) {
      if (data.hasOwnProperty(p)) {
        if (_typeof(data[p]) == 'object') {
          header += " data-" + p + "=\'" + escapeHTML(JSON.stringify(data[p]).replace(/'/g, "&#39;")) + "\'";
        } else {
          header += " data-" + p + "=\"" + escapeHTML(data[p]).replace(/"/g, "&quot;") + "\"";
        }
      }
    }

    header += ">";
    return header;
  }

  function buildRegionSectionHeader(section, name, perm, regionid) {
    if (name) {
      if (section == 'inherited') {
        return "<div class=\"mura-region-inherited\"><div class=\"frontEndToolsModal mura\"><span class=\"mura-edit-label mi-lock\">" + escapeHTML(name.toUpperCase()) + ": Inherited</span></div>";
      } else {
        return "<div class=\"mura-editable mura-inactive\"><div class=\"mura-region-local mura-inactive mura-editable-attribute\" data-loose=\"false\" data-regionid=\"" + escapeHTML(regionid) + "\" data-inited=\"false\" data-perm=\"" + escapeHTML(perm) + "\"><label class=\"mura-editable-label\" style=\"display:none\">" + escapeHTML(name.toUpperCase()) + "</label>";
      }
    } else {
      return "<div class=\"mura-region-" + escapeHTML(section) + "\">";
    }
  }

  if (data.inherited.items.length) {
    if (data.inherited.header) {
      str += data.inherited.header;
    } else {
      str += buildRegionSectionHeader('inherited', data.name, data.inherited.perm, data.regionid);
    }

    for (var i in data.inherited.items) {
      if (data.inherited.items[i].header) {
        str += data.inherited.items[i].header;
      } else {
        str += buildItemHeader(data.inherited.items[i]);
      }

      if (typeof data.inherited.items[i].html != 'undefined' && data.inherited.items[i].html) {
        str += data.inherited.items[i].html;
      }

      if (data.inherited.items[i].footer) {
        str += data.inherited.items[i].footer;
      } else {
        str += "</div>";
      }
    }

    str += "</div>";
  }

  if (data.local.header) {
    str += data.local.header;
  } else {
    str += buildRegionSectionHeader('local', data.name, data.local.perm, data.regionid);
  }

  if (data.local.items.length) {
    for (var i in data.local.items) {
      if (data.local.items[i].header) {
        str += data.local.items[i].header;
      } else {
        str += buildItemHeader(data.local.items[i]);
      }

      if (typeof data.local.items[i].html != 'undefined' && data.local.items[i].html) {
        str += data.local.items[i].html;
      }

      if (data.local.items[i].footer) {
        str += data.local.items[i].footer;
      } else {
        str += '</div>';
      }
    }
  } //when editing the region header contains two divs


  if (data.name) {
    str += "</div></div>";
  } else {
    str += "</div>";
  }

  str += "</div>";
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
      if (!(typeof val == 'string' && val.length == 35) && isNumeric(val)) {
        var numVal = parseFloat(val);

        if (numVal == 0 || !isNaN(1 / numVal)) {
          return numVal;
        }
      }

      try {
        var testVal = JSON.parse.call(null, val);

        if (typeof testVal != 'string') {
          return testVal;
        } else {
          return val;
        }
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
  Array.prototype.forEach.call(el.attributes, function (attr) {
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
  var field,
      s = {};

  if (_typeof(form) == 'object' && form.nodeName == "FORM") {
    var len = form.elements.length;

    for (var i = 0; i < len; i++) {
      field = form.elements[i];

      if (field.name && !field.disabled && field.type != 'file' && field.type != 'reset' && field.type != 'submit' && field.type != 'button') {
        if (field.type == 'select-multiple') {
          var val = [];

          for (var j = form.elements[i].options.length - 1; j >= 0; j--) {
            if (field.options[j].selected) {
              val.push(field.options[j].value);
            }
          }

          s[field.name] = val.join(",");
        } else if (field.type != 'checkbox' && field.type != 'radio' || field.checked) {
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
} //http://youmightnotneedjquery.com/

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
    if (!arguments[i]) continue;

    for (var key in arguments[i]) {
      if (key != '__proto__' && typeof arguments[i].hasOwnProperty != 'undefined' && arguments[i].hasOwnProperty(key)) out[key] = arguments[i][key];
    }
  }

  return out;
}

;
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
    if (!obj) continue;

    for (var key in obj) {
      if (key != '__proto__' && typeof arguments[i].hasOwnProperty != 'undefined' && arguments[i].hasOwnProperty(key)) {
        if (Array.isArray(obj[key])) {
          out[key] = obj[key].slice(0);
        } else if (_typeof(obj[key]) === 'object') {
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
  if (days) {
    var date = new Date();
    date.setTime(date.getTime() + days * 24 * 60 * 60 * 1000);
    var expires = "; expires=" + date.toGMTString();
  } else {
    var expires = "";
  }

  if (typeof location != 'undefined' && location.protocol == 'https:') {
    var secure = '; secure; samesite=None;';
  } else {
    var secure = '';
  }

  if (typeof domain != 'undefined') {
    domain = '; domain=' + domain;
  } else {
    domain = '';
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

    while (c.charAt(0) == ' ') {
      c = c.substring(1, c.length);
    }

    if (c.indexOf(nameEQ) == 0) return unescape(c.substring(nameEQ.length, c.length));
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
    return encodeURIComponent(value);
  } else {
    return escape(value).replace(new RegExp("\\+", "g"), "%2B").replace(/[\x00-\x1F\x7F-\x9F]/g, "");
  }
}

function $unescape(value) {
  return unescape(value);
} //deprecated


function addLoadEvent(func) {
  var oldonload = onload;

  if (typeof onload != 'function') {
    onload = func;
  } else {
    onload = function onload() {
      oldonload();
      func();
    };
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
  if (typeof value == 'string' && (value.length == 35 && value[8] == '-' && value[13] == '-' && value[18] == '-' || value == '00000000000000000000000000000000001' || value == '00000000000000000000000000000000000' || value == '00000000000000000000000000000000003' || value == '00000000000000000000000000000000005' || value == '00000000000000000000000000000000099')) {
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
  var s = [],
      itoh = '0123456789ABCDEF'; // Make array of random hex digits. The UUID only has 32 digits in it, but we
  // allocate an extra items to make room for the '-'s we'll be inserting.

  for (var i = 0; i < 35; i++) {
    s[i] = Math.floor(Math.random() * 0x10);
  } // Conform to RFC-4122, section 4.4


  s[14] = 4; // Set 4 high bits of time_high field to version

  s[19] = s[19] & 0x3 | 0x8; // Specify 2 high bits of clock sequence
  // Convert to hex chars

  for (var i = 0; i < 36; i++) {
    s[i] = itoh[s[i]];
  } // Insert '-'s


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
    };

    if (_typeof(customConfig) == 'object') {
      extend(htmlEditorConfig, customConfig);
    }

    return htmlEditorConfig;
  }

  loader().loadjs(Mura.corepath + '/vendor/ckeditor/ckeditor.js', function () {
    initEditor();
  });
}

var commandKeyActive = false;

var keyCmdCheck = function keyCmdCheck(event) {
  switch (event.which) {
    case 17: //ctrl

    case 27: //escape

    case 91:
      //cmd
      commandKeyActive = event.which;
      break;

    case 69:
      if (commandKeyActive) {
        event.preventDefault();
        Mura.editroute = Mura.editroute || "/";
        var inEditRoute = typeof location.pathname.startsWith != 'undefined' && location.pathname.startsWith(Mura.editroute);

        if (inEditRoute && typeof MuraInlineEditor != 'undefined') {
          MuraInlineEditor.init();
        } else {
          var params = getQueryStringParams(location.search);

          if (typeof params.editlayout == 'undefined') {
            Mura.editroute = Mura.editroute || '';

            if (Mura.editroute) {
              if (inEditRoute) {
                if (typeof params.previewid != 'undefined') {
                  location.href = Mura.editroute + location.pathname + "?previewid=" + params.previewid;
                }
              } else {
                if (typeof params.previewid != 'undefined') {
                  location.href = Mura.editroute + location.pathname + "?previewid=" + params.previewid;
                } else {
                  location.href = Mura.editroute + location.pathname;
                }
              }
            }
          }
        }
      }

      break;

    case 76:
      if (commandKeyActive && commandKeyActive != 91 && commandKeyActive != 17) {
        event.preventDefault();
        var params = getQueryStringParams(location.search);

        if (params.display != 'login') {
          var lu = '';
          var ru = '';

          if (typeof Mura.loginURL != "undefined") {
            lu = Mura.loginURL;
          } else if (typeof Mura.loginurl != "undefined") {
            lu = Mura.loginurl;
          } else {
            lu = "?display=login";
          }

          if (typeof Mura.returnURL != "undefined") {
            ru = Mura.returnURL;
          } else if (typeof Mura.returnurl != "undefined") {
            ru = Mura.returnurl;
          } else {
            ru = location.href;
          }

          lu = new String(lu);

          if (lu.indexOf('?') != -1) {
            location.href = lu + "&returnUrl=" + encodeURIComponent(ru);
          } else {
            location.href = lu + "?returnUrl=" + encodeURIComponent(ru);
          }
        }
      }

      break;

    default:
      commandKeyActive = false;
      break;
  }
};
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
    if (c < "0" || c > "9") return false;
  } // All characters are numbers.


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
  var returnString = ""; // Search through string's characters one by one.
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
  return year % 4 == 0 && (!(year % 100 == 0) || year % 400 == 0) ? 29 : 28;
}

function DaysArray(n) {
  for (var i = 1; i <= n; i++) {
    this[i] = 31;

    if (i == 4 || i == 6 || i == 9 || i == 11) {
      this[i] = 30;
    }

    if (i == 2) {
      this[i] = 29;
    }
  }

  return this;
}
/**
 * generateDateFormat - dateformt for input type="date"
 *
 * @name generateDateFormat
 * @return {string}
 */


function generateDateFormat(dtStr, fldName) {
  var formatArray = ['mm', 'dd', 'yyyy'];
  return [formatArray[Mura.dtformat[0]], formatArray[Mura.dtformat[1]], formatArray[Mura.dtformat[2]]].join(Mura.dtch);
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
  var dtArray = dtStr.split(Mura.dtch);

  if (dtArray.length != 3) {
    //alert("The date format for the "+fldName+" field should be : short")
    return false;
  }

  var strMonth = dtArray[Mura.dtformat[0]];
  var strDay = dtArray[Mura.dtformat[1]];
  var strYear = dtArray[Mura.dtformat[2]];
  /*
  if(strYear.length == 2){
  	strYear="20" + strYear;
  }
  */

  strYr = strYear;
  if (strDay.charAt(0) == "0" && strDay.length > 1) strDay = strDay.substring(1);
  if (strMonth.charAt(0) == "0" && strMonth.length > 1) strMonth = strMonth.substring(1);

  for (var i = 1; i <= 3; i++) {
    if (strYr.charAt(0) == "0" && strYr.length > 1) strYr = strYr.substring(1);
  }

  month = parseInt(strMonth);
  day = parseInt(strDay);
  year = parseInt(strYr);

  if (month < 1 || month > 12) {
    //alert("Please enter a valid month in the "+fldName+" field")
    return false;
  }

  if (day < 1 || day > 31 || month == 2 && day > daysInFebruary(year) || day > daysInMonth[month]) {
    //alert("Please enter a valid day	in the "+fldName+" field")
    return false;
  }

  if (strYear.length != 4 || year == 0 || year < Mura.minYear || year > Mura.maxYear) {
    //alert("Please enter a valid 4 digit year between "+Mura.minYear+" and "+Mura.maxYear +" in the "+fldName+" field")
    return false;
  }

  if (isInteger(stripCharsInBag(dtStr, Mura.dtch)) == false) {
    //alert("Please enter a valid date in the "+fldName+" field")
    return false;
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
  return /^[a-zA-Z_0-9-'\+~]+(\.[a-zA-Z_0-9-'\+~]+)*@([a-zA-Z_0-9-]+\.)+[a-zA-Z]{2,8}$/.test(e);
}

function initShadowBox(el) {
  if (typeof window == 'undefined' || typeof window.document == 'undefined') {
    return;
  }

  ;

  if (Mura(el).find('[data-rel^="shadowbox"],[rel^="shadowbox"]').length) {
    loader().load([Mura.context + '/core/modules/v1/core_assets/css/shadowbox.min.css', Mura.context + '/core/modules/v1/core_assets/js/shadowbox.js'], function () {
      Mura('#shadowbox_overlay,#shadowbox_container').remove();
      window.Shadowbox.init();
    });
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
      return theField.getAttribute('data-required').toLowerCase() == 'true';
    } else if (theField.getAttribute('required') != undefined) {
      return theField.getAttribute('required').toLowerCase() == 'true';
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
    if (theField.getAttribute('data-matchfield') != undefined && theField.getAttribute('data-matchfield') != '') {
      return true;
    } else if (theField.getAttribute('matchfield') != undefined && theField.getAttribute('matchfield') != '') {
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
      if (theField.getAttribute('data-regex') != undefined && theField.getAttribute('data-regex') != '') {
        return true;
      } else if (theField.getAttribute('regex') != undefined && theField.getAttribute('regex') != '') {
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
          message: getValidationMessage(theField, ' is required.')
        });
      }

      if (validationType != '') {
        if (validationType == 'EMAIL' && theField.value != '') {
          rules.push({
            dataType: 'EMAIL',
            message: getValidationMessage(theField, ' must be a valid email address.')
          });
        } else if (validationType == 'NUMERIC' && theField.value != '') {
          rules.push({
            dataType: 'NUMERIC',
            message: getValidationMessage(theField, ' must be numeric.')
          });
        } else if (validationType == 'REGEX' && theField.value != '' && hasValidationRegex(theField)) {
          rules.push({
            regex: getValidationRegex(theField),
            message: getValidationMessage(theField, ' is not valid.')
          });
        } else if (validationType == 'MATCH' && hasValidationMatchField(theField) && theField.value != theForm[getValidationMatchField(theField)].value) {
          rules.push({
            eq: theForm[getValidationMatchField(theField)].value,
            message: getValidationMessage(theField, ' must match' + getValidationMatchField(theField) + '.')
          });
        } else if (validationType == 'DATE' && theField.value != '') {
          rules.push({
            dataType: 'DATE',
            message: getValidationMessage(theField, ' must be a valid date [MM/DD/YYYY].')
          });
        }
      }

      if (rules.length) {
        validations.properties[theField.getAttribute('name')] = rules; //if(!Array.isArray(data[theField.getAttribute('name')])){

        data[theField.getAttribute('name')] = []; //}

        for (var v = 0; v < frmInputs.length; v++) {
          if (frmInputs[v].getAttribute('name') == theField.getAttribute('name')) {
            if (frmInputs[v].getAttribute('type').toLowerCase() == 'checkbox' || frmInputs[v].getAttribute('type').toLowerCase() == 'radio') {
              if (frmInputs[v].checked) {
                data[theField.getAttribute('name')].push(frmInputs[v].value);
              }
            } else if (typeof frmInputs[v].value != 'undefined' && frmInputs[v].value != '') {
              data[theField.getAttribute('name')].push(frmInputs[v].value);
            }
          }
        }
      }
    }
  }

  for (var p in data) {
    if (data.hasOwnProperty(p)) {
      data[p] = data[p].join();
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
        message: getValidationMessage(theField, ' is required.')
      });
    } else if (validationType != '') {
      if (validationType == 'REGEX' && theField.value != '' && hasValidationRegex(theField)) {
        rules.push({
          regex: getValidationRegex(theField),
          message: getValidationMessage(theField, ' is not valid.')
        });
      }
    }

    if (rules.length) {
      validations.properties[theField.getAttribute('name')] = rules;
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
        message: getValidationMessage(theField, ' is required.')
      });
    }

    if (rules.length) {
      validations.properties[theField.getAttribute('name')] = rules;
      data[theField.getAttribute('name')] = theField.value;
    }
  }

  try {
    //alert(JSON.stringify(validations));
    //console.log(data);
    //console.log(validations);
    ajax({
      type: 'post',
      url: Mura.getAPIEndpoint() + '?method=validate',
      data: {
        data: encodeURIComponent(JSON.stringify(data)),
        validations: encodeURIComponent(JSON.stringify(validations)),
        version: 4
      },
      success: function success(resp) {
        data = resp.data;

        if (Object.keys(data).length === 0) {
          if (typeof $customaction == 'function') {
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
      error: function error(resp) {
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
    if (key !== key.toLowerCase()) {
      // might already be in its lower case version
      obj[key.toLowerCase()] = obj[key]; // swap the value to a new lower case key

      delete obj[key]; // delete the old key
    }

    if (_typeof(obj[key.toLowerCase()]) == 'object') {
      setLowerCaseKeys(obj[key.toLowerCase()]);
    }
  }

  return obj;
}

function isScrolledIntoView(el) {
  if (typeof window == 'undefined' || typeof window.document == 'undefined' || window.innerHeight) {
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

var layoutmanagertoolbar = '<span class="mura-fetborder mura-fetborder-left"></span><span class="mura-fetborder mura-fetborder-right"></span><span class="mura-fetborder mura-fetborder-top"></span><span class="mura-fetborder mura-fetborder-bottom"></span><div class="frontEndToolsModal mura"><span class="mura-edit-icon"></span><span class="mura-edit-label"></span></div>';

function processMarkup(scope) {
  return new Promise(function (resolve, reject) {
    if (!(scope instanceof Mura.DOMSelection)) {
      scope = select(scope);
    }

    function find(selector) {
      return scope.find(selector);
    }

    var processors = [function () {
      //if layout manager UI exists check for rendered regions and remove them from additional regions
      if (Mura('.mura__layout-manager__display-regions').length) {
        find('.mura-region').each(function (el) {
          var region = Mura(el);

          if (!region.closest('.mura__layout-manager__display-regions').length) {
            Mura('.mura-region__item[data-regionid="' + region.data('regionid') + '"]').remove();
          }
        });

        if (!Mura('.mura__layout-manager__display-regions .mura-region__item').length) {
          Mura('#mura-objects-openregions-btn, .mura__layout-manager__display-regions').remove();
        }
      }
    }, function () {
      find('.mura-object, .mura-async-object').each(function (el) {
        if (scope == document) {
          var obj = Mura(el);

          if (!obj.parent().closest('.mura-object').length) {
            processDisplayObject(this, Mura.queueobjects).then(resolve);
          }
        } else {
          processDisplayObject(el, Mura.queueobjects).then(resolve);
        }
      });
    }, function () {
      find(".htmlEditor").each(function (el) {
        setHTMLEditor(el);
      });
    }, function () {
      if (find(".cffp_applied,	.cffp_mm, .cffp_kp").length) {
        var fileref = document.createElement('script');
        fileref.setAttribute("type", "text/javascript");
        fileref.setAttribute("src", Mura.corepath + '/vendor/cfformprotect/js/cffp.js');
        document.getElementsByTagName("head")[0].appendChild(fileref);
      }
    }, function () {
      Mura.reCAPTCHALanguage = Mura.reCAPTCHALanguage || 'en';

      if (find(".g-recaptcha-container").length) {
        loader().loadjs("https://www.recaptcha.net/recaptcha/api.js?onload=MuraCheckForReCaptcha&render=explicit&hl=" + Mura.reCAPTCHALanguage, function () {
          find(".g-recaptcha-container").each(function (el) {
            var notready = 0;
            ;

            window.MuraCheckForReCaptcha = function () {
              Mura('.g-recaptcha-container').each(function () {
                var self = this;

                if ((typeof grecaptcha === "undefined" ? "undefined" : _typeof(grecaptcha)) == 'object' && typeof grecaptcha.render != 'undefined' && !self.innerHTML) {
                  self.setAttribute('data-widgetid', grecaptcha.render(self.getAttribute('id'), {
                    'sitekey': self.getAttribute('data-sitekey'),
                    'theme': self.getAttribute('data-theme'),
                    'type': self.getAttribute('data-type')
                  }));
                } else {
                  notready++;
                }
              });

              if (notready) {
                setTimeout(function () {
                  window.MuraCheckForReCaptcha();
                }, 10);
              }
            };

            window.MuraCheckForReCaptcha();
          });
        });
      }
    }, function () {
      if (typeof resizeEditableObject == 'function') {
        scope.closest('.editableObject').each(function (el) {
          resizeEditableObject(el);
        });
        find(".editableObject").each(function (el) {
          resizeEditableObject(el);
        });
      }
    }, function () {
      if (Mura.handleObjectClick == 'function') {
        find('.mura-object, .frontEndToolsModal').on('click', Mura.handleObjectClick);
      }

      if (typeof window != 'undefined' && typeof window.document != 'undefined' && window.MuraInlineEditor && window.MuraInlineEditor.checkforImageCroppers) {
        find("img").each(function (el) {
          window.muraInlineEditor.checkforImageCroppers(el);
        });
      }
    }, function () {
      initShadowBox(scope.node);
    }];

    for (var h = 0; h < processors.length; h++) {
      processors[h]();
    }
  });
}

function addEventHandler(eventName, fn) {
  if (_typeof(eventName) == 'object') {
    for (var h in eventName) {
      if (eventName.hasOwnProperty(h)) {
        on(document, h, eventName[h]);
      }
    }
  } else {
    on(document, eventName, fn);
  }
}

function submitForm(frm, obj) {
  frm = frm.node ? frm.node : frm;

  if (obj) {
    obj = obj.node ? obj : Mura(obj);
  } else {
    obj = Mura(frm).closest('.mura-async-object');
  }

  if (!obj.length) {
    Mura(frm).trigger('formSubmit', formToObject(frm));
    frm.submit();
  }

  if (Mura.formdata && frm.getAttribute('enctype') == 'multipart/form-data') {
    var data = new FormData(frm);
    var checkdata = setLowerCaseKeys(formToObject(frm));
    var keys = filterUnwantedParams(deepExtend(setLowerCaseKeys(obj.data()), urlparams, {
      siteid: Mura.siteid,
      contentid: Mura.contentid,
      contenthistid: Mura.contenthistid,
      nocache: 1
    }));

    if (obj.data('siteid')) {
      keys.siteid = obj.data('siteid');
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

    var postconfig = {
      url: Mura.getAPIEndpoint() + '?method=processAsyncObject',
      type: 'POST',
      data: data,
      success: function success(resp) {
        //console.log(data.object,resp)
        setTimeout(function () {
          handleResponse(obj, resp);
        }, 0);
      }
    };
  } else {
    var data = filterUnwantedParams(deepExtend(setLowerCaseKeys(obj.data()), urlparams, setLowerCaseKeys(formToObject(frm)), {
      siteid: Mura.siteid,
      contentid: Mura.contentid,
      contenthistid: Mura.contenthistid,
      nocache: 1
    }));

    if (obj.data('siteid')) {
      data.siteid = obj.data('siteid');
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
      url: Mura.getAPIEndpoint() + '?method=processAsyncObject',
      type: 'POST',
      data: data,
      success: function success(resp) {
        //console.log(data.object,resp)
        setTimeout(function () {
          handleResponse(obj, resp);
        }, 0);
      }
    };
  }

  var self = obj.node;
  self.prevInnerHTML = self.innerHTML;
  self.prevData = filterUnwantedParams(obj.data());

  if (typeof self.prevData != 'undefined' && typeof self.prevData.preloadermarkup != 'undefined') {
    self.innerHTML = self.prevData.preloadermarkup;
  } else {
    self.innerHTML = Mura.preloadermarkup;
  }

  Mura(frm).trigger('formSubmit', data);
  ajax(postconfig);
}

function firstToUpperCase(str) {
  return str.substr(0, 1).toUpperCase() + str.substr(1);
}

function firstToLowerCase(str) {
  return str.substr(0, 1).toLowerCase() + str.substr(1);
}

function cleanModuleProps(obj) {
  if (obj) {
    var dataTargets = ['runtime', 'perm', 'startrow', 'pagenum', 'pageidx', 'nextnid', 'purgecache', 'origininstanceid'];

    if (typeof obj.removeAttr == 'function') {
      dataTargets.forEach(function (item) {
        obj.removeAttr('data-' + item);
      });

      if (obj.hasAttr('data-cachedwithin') && !obj.attr('data-cachedwithin')) {
        obj.removeAttr('data-cachedwithin');
      }
    } else {
      dataTargets.forEach(function (item) {
        if (typeof obj[item] != 'undefined') {
          delete obj[item];
        }
      });
      delete obj.inited;
    }
  }

  return obj;
}

function resetAsyncObject(el, empty) {
  var self = Mura(el);

  if (self.data('transient')) {
    self.remove();
  } else {
    if (typeof empty == 'undefined') {
      empty = true;
    }

    cleanModuleProps(self);

    if (empty) {
      self.removeAttr('data-inited');
    }

    var data = self.data();

    for (var p in data) {
      if (data.hasOwnProperty(p) && (typeof p == 'undefined' || data[p] === '')) {
        self.removeAttr('data-' + p);
      }
    }

    if (typeof Mura.displayObjectInstances[self.data('instanceid')] != 'undefined') {
      Mura.displayObjectInstances[self.data('instanceid')].reset(self, empty);
    }

    if (empty) {
      self.html('');
    }
  }
}

function processAsyncObject(el, usePreloaderMarkup) {
  var obj = Mura(el);

  if (obj.data('async') === null) {
    obj.data('async', true);
  }

  if (typeof usePreloaderMarkup == 'undefined') {
    usePreloaderMarkup = true;
  }

  return processDisplayObject(obj, false, true, false, usePreloaderMarkup);
}

function filterUnwantedParams(params) {
  //Strip out unwanted attributes
  var unwanted = ['iconclass', 'objectname', 'inited', 'params', 'stylesupport', 'cssstyles', 'metacssstyles', 'contentcssstyles', 'cssclass', 'cssid', 'metacssclass', 'metacssid', 'contentcssclass', 'contentcssid', 'transient', 'draggable', 'objectspacing', 'metaspacing', 'contentspacing'];

  for (var c = 0; c < unwanted.length; c++) {
    delete params[unwanted[c]];
  }

  return params;
}

function destroyDisplayObjects() {
  for (var property in Mura.displayObjectInstances) {
    if (Mura.displayObjectInstances.hasOwnProperty(property)) {
      var obj = Mura.displayObjectInstances[property];

      if (typeof obj.destroy == 'function') {
        obj.destroy();
      }

      delete Mura.displayObjectInstances[property];
    }
  }
}

function destroyModules() {
  destroyDisplayObjects();
}

function wireUpObject(obj, response, attempt) {
  attempt = attempt || 0;
  attempt++;
  obj = obj.node ? obj : Mura(obj);
  obj.data('inited', true);

  if (response) {
    if (typeof response == 'string') {
      obj.html(trim(response));
    } else if (typeof response.html == 'string' && response.render != 'client') {
      obj.html(trim(response.html));
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

        if (typeof Mura.displayObjectInstances[obj.data('instanceid')] != 'undefined') {
          Mura.displayObjectInstances[obj.data('instanceid')].destroy();
        }

        obj.html(Mura.templates.content({
          html: ''
        }));
        obj.prepend(Mura.templates.meta(context));
        context.targetEl = obj.children('.mura-object-content').node;
        Mura.displayObjectInstances[obj.data('instanceid')] = new Mura.DisplayObject[template](context);
        Mura.displayObjectInstances[obj.data('instanceid')].trigger('beforeRender');
        Mura.displayObjectInstances[obj.data('instanceid')].renderClient();
      } else if (typeof Mura.templates[template] != 'undefined') {
        context.html = '';
        obj.html(Mura.templates.content(context));
        obj.prepend(Mura.templates.meta(context));
        context.targetEl = obj.children('.mura-object-content').node;
        Mura.templates[template](context);
      } else {
        if (attempt < 1000) {
          setTimeout(function () {
            wireUpObject(obj, response, attempt);
          }, 1);
        } else {
          console.log('Missing Client Template for:');
          console.log(obj.data());
        }
      }
    }
  } else {
    var context = filterUnwantedParams(obj.data());
    var template = obj.data('clienttemplate') || obj.data('object');
    var properNameCheck = firstToUpperCase(template);

    if (typeof Mura.DisplayObject[properNameCheck] != 'undefined') {
      template = properNameCheck;
    }

    if (typeof Mura.DisplayObject[template] == 'function') {
      context.html = '';

      if (typeof Mura.displayObjectInstances[obj.data('instanceid')] != 'undefined') {
        Mura.displayObjectInstances[obj.data('instanceid')].destroy();
      }

      obj.html(Mura.templates.content({
        html: ''
      }));
      obj.prepend(Mura.templates.meta(context));
      context.targetEl = obj.children('.mura-object-content').node;
      Mura.displayObjectInstances[obj.data('instanceid')] = new Mura.DisplayObject[template](context);
      Mura.displayObjectInstances[obj.data('instanceid')].trigger('beforeRender');
      Mura.displayObjectInstances[obj.data('instanceid')].renderClient();
    } else if (typeof Mura.templates[template] != 'undefined') {
      context.html = '';
      obj.html(Mura.templates.content(context));
      obj.prepend(Mura.templates.meta(context));
      context.targetEl = obj.children('.mura-object-content').node;
      Mura.templates[template](context);
    } else {
      if (attempt < 1000) {
        setTimeout(function () {
          wireUpObject(obj, response, attempt);
        }, 1);
      } else {
        console.log('Missing Client Template for:');
        console.log(obj.data());
      }
    }
  }

  obj.calculateDisplayObjectStyles();
  obj.hide().show();

  if (Mura.layoutmanager && Mura.editing) {
    if (obj.hasClass('mura-body-object') || obj.is('div.mura-object[data-targetattr]')) {
      obj.children('.frontEndToolsModal').remove();
      obj.prepend(Mura.layoutmanagertoolbar);

      if (obj.data('objectname')) {
        obj.children('.frontEndToolsModal').children('.mura-edit-label').html(obj.data('objectname'));
      } else {
        obj.children('.frontEndToolsModal').children('.mura-edit-label').html(Mura.firstToUpperCase(obj.data('object')));
      }

      if (obj.data('objecticonclass')) {
        obj.children('.frontEndToolsModal').children('.mura-edit-label').addClass(obj.data('objecticonclass'));
      }

      MuraInlineEditor.setAnchorSaveChecks(obj.node);
      obj.addClass('mura-active').hover(Mura.initDraggableObject_hoverin, Mura.initDraggableObject_hoverout);
    } else {
      //replace this with Mura.initEditableObject.call(obj.node) in future
      function initEditableObject(item) {
        var objectParams;

        if (item.data('transient')) {
          item.remove();
        } else if (Mura.type == 'Variation' && !(item.is('[data-mxpeditable]') || item.closest('.mxp-editable').length)) {
          return;
        }

        item.addClass("mura-active");

        if (Mura.type == 'Variation') {
          objectParams = item.data();
          item.children('.frontEndToolsModal').remove();
          item.children('.mura-fetborder').remove();
          item.prepend(window.Mura.layoutmanagertoolbar);

          if (item.data('objectname')) {
            item.children('.frontEndToolsModal').children('.mura-edit-label').html(item.data('objectname'));
          } else {
            item.children('.frontEndToolsModal').children('.mura-edit-label').html(Mura.firstToUpperCase(item.data('object')));
          }

          if (item.data('objecticonclass')) {
            item.children('.frontEndToolsModal').children('.mura-edit-label').addClass(item.data('objecticonclass'));
          }

          item.off("click", Mura.handleObjectClick).on("click", Mura.handleObjectClick);
          item.find("img").each(function (el) {
            MuraInlineEditor.checkforImageCroppers(el);
          });
          item.find('.mura-object').each(function (el) {
            initEditableObject(Mura(el));
          });
          Mura.initDraggableObject(item.node);
        } else {
          var lcaseObject = item.data('object');

          if (typeof lcaseObject == 'string') {
            lcaseObject = lcaseObject.toLowerCase();
          }

          var region = item.closest('.mura-region-local, div.mura-object[data-object][data-targetattr]');

          if (region.length) {
            if (region.is('.mura-region-local') && region.data('perm') || region.is('div.mura-object[data-object][data-targetattr]')) {
              objectParams = item.data();

              if (window.MuraInlineEditor.objectHasConfigurator(item) || !window.Mura.layoutmanager && window.MuraInlineEditor.objectHasEditor(objectParams)) {
                item.children('.frontEndToolsModal').remove();
                item.children('.mura-fetborder').remove();
                item.prepend(window.Mura.layoutmanagertoolbar);

                if (item.data('objectname')) {
                  item.children('.frontEndToolsModal').children('.mura-edit-label').html(item.data('objectname'));
                } else {
                  item.children('.frontEndToolsModal').children('.mura-edit-label').html(Mura.firstToUpperCase(item.data('object')));
                }

                if (item.data('objecticonclass')) {
                  item.children('.frontEndToolsModal').children('.mura-edit-label').addClass(item.data('objecticonclass'));
                }

                item.off("click", Mura.handleObjectClick).on("click", Mura.handleObjectClick);
                item.find("img").each(function (el) {
                  MuraInlineEditor.checkforImageCroppers(el);
                });
                item.find('.mura-object').each(function (el) {
                  initEditableObject(Mura(el));
                });
                Mura.initDraggableObject(item.node);

                if (typeof Mura.initPinnedObject == 'function') {
                  item.find('div.mura-object[data-pinned="true"]').each(function (el) {
                    Mura.initPinnedObject(el);
                  });
                }

                Mura('body').find('.mura-object').each(function() {
                  // Reset the front-end for all items that have an empty objectname.
                  Mura(this).data('objectname', '').find('.mura-edit-icon').on('click', function() {
                      Mura.initFrontendUI(this)
                  });
                });

              }
            }
          } else if (lcaseObject == 'form' || lcaseObject == 'component') {
            var entity = Mura.getEntity('content');

            var conditionalApply = function conditionalApply() {
              objectParams = item.data();

              if (window.MuraInlineEditor.objectHasConfigurator(item) || !window.Mura.layoutmanager && window.MuraInlineEditor.objectHasEditor(objectParams)) {
                item.addClass('mura-active');
                item.hover(Mura.initDraggableObject_hoverin, Mura.initDraggableObject_hoverout);
                item.data('notconfigurable', true);
                item.children('.frontEndToolsModal').remove();
                item.children('.mura-fetborder').remove();
                item.prepend(window.Mura.layoutmanagertoolbar);

                if (item.data('objectname')) {
                  item.children('.frontEndToolsModal').children('.mura-edit-label').html(item.data('objectname'));
                } else {
                  item.children('.frontEndToolsModal').children('.mura-edit-label').html(Mura.firstToUpperCase(item.data('object')));
                }

                if (item.data('objecticonclass')) {
                  item.children('.frontEndToolsModal').children('.mura-edit-label').addClass(item.data('objecticonclass'));
                }

                item.off("click", Mura.handleObjectClick).on("click", Mura.handleObjectClick);
                item.find("img").each(function (el) {
                  MuraInlineEditor.checkforImageCroppers(el);
                });
                item.find('.mura-object').each(function (el) {
                  initEditableObject(Mura(el));
                });
              }
            };

            if (item.data('perm')) {
              conditionalApply();
            } else {
              if (Mura.isUUID(item.data('objectid'))) {
                entity.loadBy('contentid', item.data('objectid'), {
                  type: lcaseObject
                }).then(function (bean) {
                  bean.get('permissions').then(function (permissions) {
                    if (permissions.get('save')) {
                      item.data('perm', true);
                      conditionalApply();
                    }
                  });
                });
              } else {
                entity.loadBy('title', item.data('objectid'), {
                  type: lcaseObject
                }).then(function (bean) {
                  bean.get('permissions').then(function (permissions) {
                    if (permissions.get('save')) {
                      item.data('perm', true);
                      conditionalApply();
                    }
                  });
                });
              }
            }
          }
        }
      }

      initEditableObject(obj);
    }
  }

  obj.hide().show(); //if(obj.data('object') != 'container' || obj.data('content')){

  processMarkup(obj.node); //}

  if (obj.data('object') != 'container') {
    obj.find('a[href="javascript:history.back();"]').each(function (el) {
      Mura(el).off("click").on("click", function (e) {
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

    if (obj.data('render') && obj.data('render').toLowerCase() == 'server') {
      obj.find('form').each(function (el) {
        var form = Mura(el);

        if (form.closest('.mura-object').data('instanceid') == obj.data('instanceid')) {
          if (form.data('async') || !(form.hasData('async') && !form.data('async')) && !(form.hasData('autowire') && !form.data('autowire')) && !form.attr('action') && !form.attr('onsubmit') && !form.attr('onSubmit')) {
            form.on('submit', function (e) {
              e.preventDefault();
              validateForm(this, function (frm) {
                submitForm(frm, obj);
              });
              return false;
            });
          }
        }
      });
    }
  }

  obj.trigger('asyncObjectRendered');
}

function handleResponse(obj, resp) {
  obj = obj.node ? obj : Mura(obj); // handle HTML response

  resp = !resp.data ? {
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
      success: function success(data) {
        if (typeof data == 'string') {
          wireUpObject(obj, data);
        } else if (_typeof(data) == 'object' && 'html' in data) {
          wireUpObject(obj, data.html);
        } else if (_typeof(data) == 'object' && 'data' in data && 'html' in data.data) {
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
  try {
    var obj = el.node ? el : Mura(el);

    if (!obj.data('object')) {
      obj.data('inited', true);
      return new Promise(function (resolve, reject) {
        if (typeof resolve == 'function') {
          resolve(obj);
        }
      });
    }

    if (obj.data('queue') != null) {
      queue = obj.data('queue');

      if (typeof queue == 'string') {
        queue = queue.toLowerCase();

        if (queue == 'no' || queue == 'false') {
          queue = false;
          obj.data('queue', false);
        } else {
          queue = true;
          obj.data('queue', true);
        }
      }
    }

    var rendered = rerender && !obj.data('async') ? false : obj.children('.mura-object-content').length;
    queue = queue == null || rendered ? false : queue;

    if (document.createEvent && queue && !isScrolledIntoView(obj.node)) {
      if (!resolveFn) {
        return new Promise(function (resolve, reject) {
          resolve = resolve || function () {};

          setTimeout(function () {
            processDisplayObject(obj.node, true, false, resolve, usePreloaderMarkup);
          }, 10);
        });
      } else {
        setTimeout(function () {
          var resp = processDisplayObject(obj.node, true, false, resolveFn, usePreloaderMarkup);

          if (_typeof(resp) == 'object' && typeof resolveFn == 'function') {
            resp.then(resolveFn);
          }
        }, 10);
        return;
      }
    }

    if (!obj.node.getAttribute('data-instanceid')) {
      obj.node.setAttribute('data-instanceid', createUUID());
    } //if(obj.data('async')){


    obj.addClass("mura-async-object"); //}

    if (rendered && !obj.data('async')) {
      return new Promise(function (resolve, reject) {
        obj.calculateDisplayObjectStyles();
        var template = obj.data('clienttemplate') || obj.data('object');
        var properNameCheck = firstToUpperCase(template);

        if (typeof Mura.Module[properNameCheck] != 'undefined') {
          template = properNameCheck;
        }

        if (typeof Mura.Module[template] != 'undefined') {//obj.data('render','client')
        }

        if (!rerender && obj.data('render') == 'client' && obj.children('.mura-object-content').length) {
          var context = filterUnwantedParams(obj.data());

          if (typeof context.instanceid != 'undefined' && typeof Mura.hydrationData[context.instanceid] != 'undefined') {
            Mura.extend(context, Mura.hydrationData[context.instanceid]);
          }

          if (typeof Mura.DisplayObject[template] != 'undefined') {
            context.targetEl = obj.children('.mura-object-content').node;
            Mura.displayObjectInstances[obj.data('instanceid')] = new Mura.DisplayObject[template](context);
            Mura.displayObjectInstances[obj.data('instanceid')].trigger('beforeRender');
            Mura.displayObjectInstances[obj.data('instanceid')].hydrate();
          } else {
            console.log('Missing Client Template for:');
            console.log(obj.data());
          }

          obj.data('inited', true);
        }

        if (obj.data('render') && obj.data('render').toLowerCase() == 'server') {
          obj.find('form').each(function (el) {
            var form = Mura(el);

            if (form.closest('.mura-object').data('instanceid') == obj.data('instanceid')) {
              if (form.data('async') || !(form.hasData('async') && !form.data('async')) && !(form.hasData('autowire') && !form.data('autowire')) && !form.attr('action') && !form.attr('onsubmit') && !form.attr('onSubmit')) {
                form.on('submit', function (e) {
                  e.preventDefault();
                  validateForm(this, function (frm) {
                    submitForm(frm, obj);
                  });
                  return false;
                });
              }
            }
          });
        }

        if (typeof resolve == 'function') {
          resolve(obj);
        }
      });
    }

    return new Promise(function (resolve, reject) {
      var data = deepExtend(setLowerCaseKeys(obj.data()), urlparams, {
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

      if (!obj.data('async') && obj.data('render') == 'client') {
        wireUpObject(obj);

        if (typeof resolve == 'function') {
          if (typeof resolve.call == 'undefined') {
            resolve(obj);
          } else {
            resolve.call(obj.node, obj);
          }
        }
      } else {
        //console.log(data);
        if (usePreloaderMarkup) {
          if (typeof data.preloadermarkup != 'undefined') {
            obj.node.innerHTML = data.preloadermarkup;
            delete data.preloadermarkup;
          } else {
            obj.node.innerHTML = Mura.preloadermarkup;
          }
        }

        var requestType = 'get';
        var requestData = filterUnwantedParams(data);
        var postCheck = new RegExp(/<\/?[a-z][\s\S]*>/i);

        for (var p in requestData) {
          if (requestData.hasOwnProperty(p) && requestData[p] && postCheck.test(requestData[p])) {
            requestType = 'post';
            break;
          }
        }

        ajax({
          url: Mura.getAPIEndpoint() + '?method=processAsyncObject',
          type: requestType,
          data: requestData,
          success: function success(resp) {
            //console.log(data.object,resp)
            setTimeout(function () {
              handleResponse(obj, resp);

              if (typeof resolve == 'function') {
                if (typeof resolve.call == 'undefined') {
                  resolve(obj);
                } else {
                  resolve.call(obj.node, obj);
                }
              }
            }, 0);
          }
        });
      }
    });
  } catch (e) {
    console.error(e);

    if (typeof resolve == 'function') {
      resolve(obj);
    }
  }
}

function processModule(el, queue, rerender, resolveFn, usePreloaderMarkup) {
  return processDisplayObject(el, queue, rerender, resolveFn, usePreloaderMarkup);
}

var hashparams = {};
var urlparams = {};

function handleHashChange() {
  if (typeof location != 'undefined') {
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
      Mura('.mura-async-object[data-nextnid="' + hashparams.nextnid + '"]').each(function (el) {
        Mura(el).data(hashparams);
        processAsyncObject(el);
      });
    } else if (hashparams.objectid) {
      Mura('.mura-async-object[data-objectid="' + hashparams.objectid + '"]').each(function (el) {
        Mura(el).data(hashparams);
        processAsyncObject(el);
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
  var muraObject = function muraObject() {
    this.init.apply(this, arguments);
  };

  muraObject.prototype = Object.create(baseClass.prototype);
  muraObject.prototype.constructor = muraObject;
  muraObject.prototype.handlers = {};

  muraObject.reopen = function (subClass) {
    Mura.extend(muraObject.prototype, subClass);
  };

  muraObject.reopenClass = function (subClass) {
    Mura.extend(muraObject, subClass);
  };

  muraObject.on = function (eventName, fn) {
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

  muraObject.off = function (eventName, fn) {
    eventName = eventName.toLowerCase();

    if (typeof muraObject.prototype.handlers[eventName] == 'undefined') {
      muraObject.prototype.handlers[eventName] = [];
    }

    if (!fn) {
      muraObject.prototype.handlers[eventName] = [];
      return muraObject;
    }

    for (var i = 0; i < muraObject.prototype.handlers[eventName].length; i++) {
      if (muraObject.prototype.handlers[eventName][i] == handler) {
        muraObject.prototype.handlers[eventName].splice(i, 1);
      }
    }

    return muraObject;
  };

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
  if (typeof queryString === 'undefined') {
    if (typeof location != 'undefined') {
      queryString = location.search;
    } else {
      return {};
    }
  }

  var params = {};

  var e,
      a = /\+/g,
      // Regex for replacing addition symbol with a space
  r = /([^&;=]+)=?([^&;]*)/g,
      d = function d(s) {
    return decodeURIComponent(s.replace(a, " "));
  };

  if (queryString.substring(0, 1) == '?') {
    var q = queryString.substring(1);
  } else {
    var q = queryString;
  }

  while (e = r.exec(q)) {
    params[d(e[1]).toLowerCase()] = d(e[2]);
  }

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
  if (Mura.isInNode()) {
    return getStyleSheetPlaceHolder(id);
  } else {
    var sheet = Mura('#' + id);

    if (sheet.length) {
      return sheet.get(0).sheet;
    } else {
      Mura('HEAD').append('<style id="' + id + '" type="text/css"></style>');
      return Mura('#' + id).get(0).sheet;
    }
  }
}
/**
 * applyModuleCustomCSS - Returns a stylesheet object;
 *
 * @param	{object} stylesupport Object Containing Module Style configuration
 * @param	{object} sheet Object StyleSheet object
 * @param	{string} id Text string
 * @return {void}	void
 */


function applyModuleCustomCSS(stylesupport, sheet, id) {
  stylesupport = stylesupport || {};

  if (typeof stylesupport.css != 'undefined' && stylesupport.css) {
    var styles = stylesupport.css.split('}');

    if (Array.isArray(styles) && styles.length) {
      styles.forEach(function (style) {
        var styleParts = style.split("{");

        if (styleParts.length > 1) {
          var selectors = styleParts[0].split(',');
          selectors.forEach(function (subSelector) {
            try {
              var subStyle = 'div.mura-object[data-instanceid="' + id + '"] ' + subSelector.replace(/\$self/g, '') + '{' + styleParts[1] + '}';
              sheet.insertRule(subStyle, sheet.cssRules.length);

              if (Mura.editing) {
                console.log('Applying dynamic styles:' + subStyle);
              }
            } catch (e) {
              if (Mura.editing) {
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
/**
 * getStyleSheetPlaceHolder - ;
 *
 * @return {object}	 object
 */


function getStyleSheetPlaceHolder(id) {
  return {
    deleteRule: function deleteRule(idx) {
      this.cssRules.splice(idx, 1);
    },
    insertRule: function insertRule(rule) {
      this.cssRules.push(rule);
    },
    cssRules: [],
    id: id,
    targets: {
      object: {
        class: "mura-object"
      },
      meta: {
        class: "mura-object-meta"
      },
      metawrapper: {
        class: "mura-object-meta-wrapper"
      },
      content: {
        class: "mura-object-content"
      }
    }
  };
}
/**
 * normalizeModuleClassesAndIds - ;
 *
 * @param	{object} params Object Containing Module Style configuration
 * @return {object}	style object
 */


function normalizeModuleClassesAndIds(params, sheet) {
  if (typeof sheet == 'undefined') {
    sheet = getStyleSheetPlaceHolder('mura-styles-' + params.instanceid);
  }

  if (typeof params.class != 'undefined' && params.class != '') {
    sheet.targets.object.class += ' ' + params.class;
  }

  if (typeof params.cssclass != 'undefined' && params.cssclass != '') {
    sheet.targets.object.class += ' ' + params.cssclass;
  }

  if (typeof params.cssid != 'undefined' && params.cssid != '') {
    sheet.targets.object.id = params.cssid;
  }

  if (typeof params.metacssclass != 'undefined' && params.metacssclass != '') {
    sheet.targets.meta.class += ' ' + params.metacssclass;
  }

  if (typeof params.metacssid != 'undefined' && params.metacssid != '') {
    sheet.targets.meta.id = params.metacssid;
  }

  if (typeof params.contentcssclass != 'undefined' && params.contentcssclass != '') {
    sheet.targets.content.class += ' ' + params.contentcssclass;
  }

  if (typeof params.contentcssid != 'undefined' && params.contentcssid != '') {
    sheet.targets.content.id = params.contentcssid;
  }

  if (typeof params.objectspacing != 'undefined' && params.objectspacing != '' && params.objectspacing != 'custom') {
    sheet.targets.object.class += ' ' + params.objectspacing;
  }

  if (typeof params.metaspacing != 'undefined' && params.metaspacing != '' && params.metaspacing != 'custom') {
    sheet.targets.meta.class += ' ' + params.metaspacing;
  }

  if (typeof params.contentspacing != 'undefined' && params.contentspacing != '' && params.contentspacing != 'custom') {
    sheet.targets.content.class += ' ' + params.contentspacing;
  }

  if (sheet.targets.content.class.split(' ').find(function ($class) {
    return $class === 'container';
  })) {
    sheet.targets.metawrapper.class += ' container';
  }

  return sheet;
}
/**
 * recordModuleClassesAndIds - ;
 *
 * @param	{object} params Object Containing Module Style configuration
 * @return {object}	style object
 */


function recordModuleClassesAndIds(params) {
  params.instanceid = params.instanceid || createUUID();
  params.stylesupport = params.stylesupport || {};
  var sheet = getStyleSheet('mura-styles-' + params.instanceid);

  if (sheet.recorded) {
    return sheet;
  }

  normalizeModuleClassesAndIds(params, sheet);
  return sheet;
}
/**
 * recordModuleStyles - ;
 *
 * @param	{object} params Object Containing Module Style configuration
 * @return {object}	style object
 */


function recordModuleStyles(params) {
  params.instanceid = params.instanceid || createUUID();
  params.stylesupport = params.stylesupport || {};
  var sheet = getStyleSheet('mura-styles-' + params.instanceid);

  if (sheet.recorded) {
    return sheet;
  }

  var styleTargets = getModuleStyleTargets(params.instanceid, false);
  applyModuleStyles(params.stylesupport, styleTargets.object, sheet);
  applyModuleCustomCSS(params.stylesupport, sheet, params.instanceid);
  applyModuleStyles(params.stylesupport, styleTargets.meta, sheet);
  applyModuleStyles(params.stylesupport, styleTargets.content, sheet);
  normalizeModuleClassesAndIds(params, sheet);
  return sheet;
}
/**
 * applyModuleStyles - Returns a stylesheet object;
 *
 * @param	{object} stylesupport Object Containing Module Style configuration
 * @param	{object} group Object Containing a group of selectors
 * @param	{object} sheet StyleSheet object
 * @param	{object} obj Mura.DomSelection
 * @return {void}	void
 */


function applyModuleStyles(stylesupport, group, sheet, obj) {
  var acummulator = {}; //group is for object, content, meta

  group.targets.forEach(function (target) {
    var styles = {};
    var dyncss = '';

    if (stylesupport && stylesupport[target.name]) {
      styles = stylesupport[target.name];
    } //console.log(target.name)
    //console.log(styles)


    acummulator = Mura.extend(acummulator, styles);
    handleBackround(acummulator);

    for (var s in acummulator) {
      if (acummulator.hasOwnProperty(s)) {
        var p = s.toLowerCase();

        if (Mura.styleMap && typeof Mura.styleMap.tojs[p] != 'undefined' && Mura.styleMap.tocss[Mura.styleMap.tojs[p]] != 'undefined') {
          dyncss += Mura.styleMap.tocss[Mura.styleMap.tojs[p]] + ': ' + acummulator[s] + ' !important;';
        } else if (typeof obj != 'undefined') {
          obj.css(s, acummulator[s]);
        }
      }
    } //console.log(target.name,acummulator,dyncss)


    if (dyncss) {
      try {
        //selector is for edit mode or standard
        target.selectors.forEach(function (selector) {
          //console.log(selector)
          sheet.insertRule(selector + ' {' + dyncss + '}}', sheet.cssRules.length); //console.log(selector + ' {' + dyncss+ '}}')

          handleTextColor(sheet, selector, acummulator);
        });
      } catch (e) {
        console.log(selector + ' {' + dyncss + '}}');
        console.log(e);
      }
    }
  });

  function handleBackround(styles) {
    if (typeof styles.backgroundImage != 'undefined' && styles.backgroundImage) {
      var bgArray = styles.backgroundImage.split(',');

      if (bgArray.length) {
        styles.backgroundImage = Mura.trim(bgArray[bgArray.length - 1]);
      }
    }

    var hasLayeredBg = styles && typeof styles.backgroundColor != 'undefined' && styles.backgroundColor && typeof styles.backgroundImage != 'undefined' && styles.backgroundImage;

    if (hasLayeredBg) {
      styles.backgroundImage = 'linear-gradient(' + styles.backgroundColor + ', ' + styles.backgroundColor + ' ), ' + styles.backgroundImage;
    } else {
      if (typeof styles.backgroundimage != 'undefined' && styles.backgroundimage) {
        var bgArray = styles.backgroundimage.split(',');

        if (bgArray.length) {
          styles.backgroundimage = Mura.trim(bgArray[bgArray.length - 1]);
        }
      }

      hasLayeredBg = styles && typeof styles.backgroundcolor != 'undefined' && styles.backgroundcolor && typeof styles.backgroundimage != 'undefined' && styles.backgroundimage;

      if (hasLayeredBg) {
        styles.backgroundImage = 'linear-gradient(' + styles.backgroundcolor + ', ' + styles.backgroundcolor + ' ), ' + styles.backgroundimage;
      }
    }
  }

  function handleTextColor(sheet, selector, styles) {
    try {
      if (styles.color) {
        var selectorArray = selector.split('{');
        var style = selectorArray[0] + '{' + selectorArray[1] + ', ' + selectorArray[1] + ' label, ' + selectorArray[1] + ' p, ' + selectorArray[1] + ' h1, ' + selectorArray[1] + ' h2, ' + selectorArray[1] + ' h3, ' + selectorArray[1] + ' h4, ' + selectorArray[1] + ' h5, ' + selectorArray[1] + ' h6, ' + selectorArray[1] + ' a, ' + selectorArray[1] + ' a:link, ' + selectorArray[1] + ' a:visited, ' + selectorArray[1] + ' a:hover, ' + selectorArray[1] + ' .breadcrumb-item + .breadcrumb-item::before, ' + selectorArray[1] + ' a:active { color:' + styles.color + ' !important;}} ';
        sheet.insertRule(style, sheet.cssRules.length); //console.log(style)

        sheet.insertRule(selector + ' * {color:inherit !important}}', sheet.cssRules.length); //console.log(selector + ' * {color:inherit}')

        sheet.insertRule(selector + ' hr { border-color:' + styles.color + ' !important;}}', sheet.cssRules.length);
      }
    } catch (e) {
      console.log("error adding color: " + styles.color);
      console.log(e);
    }
  }
}

function getBreakpoint() {
  if (typeof document != 'undefined') {
    var breakpoints = getBreakpoints();
    var width = document.documentElement.clientWidth;

    if (Mura.editing) {
      width = width - 300;
    }

    if (width >= breakpoints.xl) {
      return 'xl';
    } else if (width >= breakpoints.lg) {
      return 'lg';
    } else if (width >= breakpoints.md) {
      return 'md';
    } else if (width >= breakpoints.sm) {
      return 'sm';
    } else {
      return 'xs';
    }
  } else {
    return '';
  }
}

function getBreakpoints() {
  if (typeof Mura.breakpoints != 'undefined') {
    return Mura.breakpoints;
  } else {
    return {
      xl: 1200,
      lg: 992,
      md: 768,
      sm: 576
    };
  }
}

function getModuleStyleTargets(id, dynamic) {
  var breakpoints = getBreakpoints();
  var sidebar = 300;
  var objTargets = {
    object: {
      targets: [{
        name: 'objectstyles',
        selectors: ['@media (min-width: ' + breakpoints.xl + 'px) { div[data-instanceid="' + id + '"]', '@media (min-width: ' + (breakpoints.xl + sidebar) + 'px) { .mura-editing div[data-instanceid="' + id + '"]']
      }, {
        name: 'object_lg_styles',
        selectors: ['@media (min-width: ' + breakpoints.lg + 'px) and (max-width: ' + (breakpoints.xl - 1) + 'px) { div[data-instanceid="' + id + '"]', '@media (min-width: ' + (breakpoints.lg + sidebar) + 'px) and (max-width: ' + (breakpoints.xl + sidebar - 1) + 'px) { .mura-editing div[data-instanceid="' + id + '"]']
      }, {
        name: 'object_md_styles',
        selectors: ['@media (min-width: ' + breakpoints.md + 'px) and (max-width:' + (breakpoints.lg - 1) + 'px) { div[data-instanceid="' + id + '"]', '@media (min-width: ' + (breakpoints.md + sidebar) + 'px) and (max-width: ' + (breakpoints.lg + sidebar - 1) + 'px) { .mura-editing div[data-instanceid="' + id + '"]']
      }, {
        name: 'object_sm_styles',
        selectors: ['@media (min-width: ' + breakpoints.sm + 'px) and (max-width: ' + (breakpoints.md - 1) + 'px) { div[data-instanceid="' + id + '"]', '@media (min-width: ' + (breakpoints.sm + sidebar) + 'px) and (max-width: ' + (breakpoints.md + sidebar - 1) + 'px) { .mura-editing div[data-instanceid="' + id + '"]']
      }, {
        name: 'object_xs_styles',
        selectors: ['@media (max-width: ' + (breakpoints.sm - 1) + 'px) { div[data-instanceid="' + id + '"]', '@media (max-width: ' + (breakpoints.sm + sidebar - 1) + 'px) { .mura-editing div[data-instanceid="' + id + '"]']
      }]
    },
    meta: {
      targets: [{
        name: 'metastyles',
        selectors: ['@media (min-width: ' + breakpoints.xl + 'px) { div[data-instanceid="' + id + '"] > div.mura-object-meta-wrapper > div.mura-object-meta', '@media (min-width: ' + (breakpoints.xl + sidebar) + 'px) { .mura-editing div[data-instanceid="' + id + '"] > div.mura-object-meta-wrapper > div.mura-object-meta']
      }, {
        name: 'meta_lg_styles',
        selectors: ['@media (min-width: ' + breakpoints.lg + 'px) and (max-width: ' + (breakpoints.xl - 1) + 'px) { div[data-instanceid="' + id + '"] > div.mura-object-meta-wrapper > div.mura-object-meta', '@media (min-width: ' + (breakpoints.lg + sidebar) + 'px) and (max-width: ' + (breakpoints.xl + sidebar - 1) + 'px) { .mura-editing div[data-instanceid="' + id + '"] > div.mura-object-meta-wrapper > div.mura-object-meta']
      }, {
        name: 'meta_md_styles',
        selectors: ['@media (min-width: ' + breakpoints.md + 'px) and (max-width: ' + (breakpoints.lg - 1) + 'px) { div[data-instanceid="' + id + '"] > div.mura-object-meta-wrapper > div.mura-object-meta', '@media (min-width: ' + (breakpoints.md + sidebar) + 'px) and (max-width: ' + (breakpoints.lg + sidebar - 1) + 'px) { .mura-editing div[data-instanceid="' + id + '"] > div.mura-object-meta-wrapper > div.mura-object-meta']
      }, {
        name: 'meta_sm_styles',
        selectors: ['@media (min-width: ' + breakpoints.sm + 'px) and (max-width: ' + (breakpoints.md - 1) + 'px) { div[data-instanceid="' + id + '"] > div.mura-object-meta-wrapper > div.mura-object-meta', '@media (min-width: ' + (breakpoints.sm + sidebar) + 'px) and (max-width: ' + (breakpoints.md + sidebar - 1) + 'px) { .mura-editing div[data-instanceid="' + id + '"] > div.mura-object-meta-wrapper > div.mura-object-meta']
      }, {
        name: 'meta_xs_styles',
        selectors: ['@media (max-width: ' + (breakpoints.sm - 1) + 'px) { div[data-instanceid="' + id + '"] > div.mura-object-meta-wrapper > div.mura-object-meta', '@media (max-width: ' + (breakpoints.sm + sidebar - 1) + 'px) { .mura-editing div[data-instanceid="' + id + '"] > div.mura-object-meta-wrapper > div.mura-object-meta']
      }]
    },
    content: {
      targets: [{
        name: 'contentstyles',
        selectors: ['@media (min-width: ' + breakpoints.xl + 'px) { div.mura-object[data-instanceid="' + id + '"] > div.mura-object-content', '@media (min-width: ' + (breakpoints.xl + sidebar) + 'px) { .mura-editing div.mura-object[data-instanceid="' + id + '"] > div.mura-object-content']
      }, {
        name: 'content_lg_styles',
        selectors: ['@media (min-width: ' + breakpoints.lg + 'px) and (max-width: ' + (breakpoints.xl - 1) + 'px) { div.mura-object[data-instanceid="' + id + '"] > div.mura-object-content', '@media (min-width: ' + (breakpoints.lg + sidebar) + 'px) and (max-width: ' + (breakpoints.xl + sidebar - 1) + 'px) { .mura-editing div.mura-object[data-instanceid="' + id + '"] > div.mura-object-content']
      }, {
        name: 'content_md_styles',
        selectors: ['@media (min-width: ' + breakpoints.md + 'px) and (max-width: ' + (breakpoints.lg - 1) + 'px) { div.mura-object[data-instanceid="' + id + '"] > div.mura-object-content', '@media (min-width: ' + (breakpoints.md + sidebar) + 'px) and (max-width: ' + (breakpoints.lg + sidebar - 1) + 'px) { .mura-editing div.mura-object[data-instanceid="' + id + '"] > div.mura-object-content']
      }, {
        name: 'content_sm_styles',
        selectors: ['@media (min-width: ' + breakpoints.sm + 'px) and (max-width: ' + (breakpoints.md - 1) + 'px) { div.mura-object[data-instanceid="' + id + '"] > div.mura-object-content', '@media (min-width: ' + (breakpoints.sm + sidebar) + 'px) and (max-width: ' + (breakpoints.md + sidebar - 1) + 'px) { .mura-editing div.mura-object[data-instanceid="' + id + '"] > div.mura-object-content']
      }, {
        name: 'content_xs_styles',
        selectors: ['@media (max-width: ' + (breakpoints.sm - 1) + 'px) { div.mura-object[data-instanceid="' + id + '"] > div.mura-object-content', '@media (max-width: ' + (breakpoints.sm + sidebar - 1) + 'px) { .mura-editing div.mura-object[data-instanceid="' + id + '"] > div.mura-object-content']
      }]
    }
  };

  if (!dynamic) {
    for (var elTarget in objTargets) {
      if (objTargets.hasOwnProperty(elTarget)) {
        objTargets[elTarget].targets.forEach(function (target) {
          target.selectors.pop();
        });
      }
    }
  }

  return objTargets;
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


function setRequestHeader(headerName, value) {
  Mura.requestHeaders[headerName] = value;
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


function getRequestHeader(headerName) {
  if (typeof Mura.requestHeaders[headerName] != 'undefined') {
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


function getRequestHeaders() {
  return Mura.requestHeaders;
} //http://werxltd.com/wp/2010/05/13/javascript-implementation-of-javas-string-hashcode-method/

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
      i,
      c;

  if (strlen === 0) {
    return hash;
  }

  for (i = 0; i < strlen; i++) {
    c = s.charCodeAt(i);
    hash = (hash << 5) - hash + c;
    hash = hash & hash; // Convert to 32bit integer
  }

  return hash >>> 0;
}
/**
 * Returns if the current request s running in Node.js
**/


function isInNode() {
  return typeof process !== 'undefined' && {}.toString.call(process) === '[object process]' || typeof document == 'undefined';
}
/**
 * Global Request Headers
**/


var requestHeaders = {};

function throttle(func, interval) {
  var timeout;
  return function () {
    var context = this,
        args = arguments;

    var later = function later() {
      timeout = false;
    };

    if (!timeout) {
      func.apply(context, args);
      timeout = true;
      setTimeout(later, interval);
    }
  };
}

function debounce(func, interval) {
  var timeout;
  return function () {
    var context = this,
        args = arguments;

    var later = function later() {
      timeout = null;
      func.apply(context, args);
    };

    clearTimeout(timeout);
    timeout = setTimeout(later, interval || 200);
  };
}

function getAPIEndpoint() {
  if (Mura.apiendpoint) {
    Mura.apiEndpoint = Mura.apiendpoint;
    delete Mura.apiendpoint;

    if (Mura.mode.toLowerCase() == 'rest') {
      Mura.apiEndpoint = Mura.apiEndpoint.replace('/json/', '/rest/');
    }
  }

  return Mura.apiEndpoint;
}

function setAPIEndpoint(apiEndpoint) {
  Mura.apiEndpoint = apiEndpoint;
}

function setMode(mode) {
  Mura.mode = mode;
}

function getMode() {
  return Mura.mode;
}

function startUserStateListener(interval) {
  Mura.userStateListenerInterval = interval;
}

function stopUserStateListener() {
  Mura.userStateListenerInterval = false;
}

function pollUserState() {
  if (typeof window != 'undefined' && typeof document != 'undefined' && (Mura.userStateListenerInterval || Mura.editing)) {
    Mura.getEntity('user').invoke('pollState').then(function (state) {
      var data = state;

      if (typeof state == 'string') {
        try {
          data = JSON.parse(state);
        } catch (e) {
          data = state;
        }
      }

      Mura(document).trigger('muraUserStateMessage', data);
    });
  }

  var interval = typeof Mura.userStateListenerInterval === 'number' && Mura.userStateListenerInterval ? Mura.userStateListenerInterval : 60000;
  setTimeout(pollUserState, interval);
}

function deInit() {
  //This all needs to be moved to a state object
  delete Mura._requestcontext;
  delete Mura.response;
  delete Mura.request;
  Mura.requestHeaders = {};
  Mura.displayObjectInstances = {};
  delete Mura.renderMode;
  delete Mura.userStateListenerInterval;
  delete Mura.currentUser;
  Mura.mode = "json";
  setAPIEndpoint(getAPIEndpoint().replace('/rest/', '/json/'));
  Mura.trackingMetadata = {};
  delete Mura.trackingVars; //delete Mura.apiEndpoint;
  //delete Mura.apiendpoint;
  //delete Mura._fetch;
  //delete Mura._formData;
  //delete Mura._escapeHTML;

  delete Mura.perm;
  delete Mura.formdata;
  delete Mura.windowResponsiveModules;
  delete Mura.windowResizeID;
  delete Mura.Content;
  delete Mura.content;
  return Mura;
} //Mura.init()


function init(config) {
  var existingEndpoint = '';

  if (Mura.siteid && config.siteid && Mura.siteid != config.siteid) {
    delete Mura.apiEndpoint;
    delete Mura.apiendpoint;
  }

  if (typeof Mura.apiEndpoint != 'undefined' && Mura.apiEndpoint) {
    existingEndpoint = Mura.apiEndpoint;
  }

  if (typeof config.content != 'undefined') {
    if (typeof config.content.get == 'undefined') {
      config.content = getEntity('content').set(config.content);
    }

    Mura.extend(config, config.content.get('config'));
  }

  if (existingEndpoint) {
    config.apiEndpoint = existingEndpoint;
    delete config.apiendpoint;
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

  if (config.apiendpoint) {
    config.apiEndpoint = config.apiendpoint;
    delete config.apiendpoint;
  }

  if (typeof config.indexfileinapi == 'undefined') {
    if (typeof Mura.indexfileinapi != 'undefined') {
      config.indexfileinapi = Mura.indexfileinapi;
    } else {
      config.indexfileinapi = true;
    }
  }

  if (!config.apiEndpoint) {
    if (config.indexfileinapi) {
      config.apiEndpoint = config.context + '/index.cfm/_api/json/v1/' + config.siteid + '/';
    } else {
      config.apiEndpoint = config.context + '/_api/json/v1/' + config.siteid + '/';
    }
  }

  if (config.apiEndpoint.indexOf('/_api/') == -1) {
    if (config.indexfileinapi) {
      config.apiEndpoint = config.apiEndpoint + '/index.cfm/_api/json/v1/' + config.siteid + '/';
    } else {
      config.apiEndpoint = config.apiEndpoint + '/_api/json/v1/' + config.siteid + '/';
    }
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

  if (typeof config.queueObjects != 'undefined') {
    config.queueobjects = config.queueObjects;
    delete config.queueobjects;
  }

  if (typeof config.queueobjects == 'undefined') {
    config.queueobjects = true;
  }

  if (typeof config.rootdocumentdomain != 'undefined' && config.rootdocumentdomain != '') {
    document.domain = config.rootdocumentdomain;
  }

  if (typeof config.preloaderMarkup != 'undefined') {
    config.preloadermarkup = config.preloaderMarkup;
    delete config.preloaderMarkup;
  }

  if (typeof config.preloadermarkup == 'undefined') {
    config.preloadermarkup = '';
  }

  if (typeof config.rb == 'undefined') {
    config.rb = {};
  }

  if (typeof config.dtExample != 'undefined') {
    config.dtexample = config.dtExample;
    delete config.dtExample;
  }

  if (typeof config.dtexample == 'undefined') {
    config.dtexample = "11/10/2024";
  }

  if (typeof config.dtCh != 'undefined') {
    config.dtch = config.dtCh;
    delete config.dtCh;
  }

  if (typeof config.dtch == 'undefined') {
    config.dtch = "/";
  }

  if (typeof config.dtFormat != 'undefined') {
    config.dtformat = config.dtFormat;
    delete config.dtFormat;
  }

  if (typeof config.dtformat == 'undefined') {
    config.dtformat = [0, 1, 2];
  }

  if (typeof config.dtLocale != 'undefined') {
    config.dtlocale = config.dtLocale;
    delete config.dtLocale;
  }

  if (typeof config.dtlocale == 'undefined') {
    config.dtlocale = "en-US";
  }

  if (typeof config.useHTML5DateInput != 'undefined') {
    config.usehtml5dateinput = config.useHTML5DateInput;
    delete config.usehtml5dateinput;
  }

  if (typeof config.usehtml5dateinput == 'undefined') {
    config.usehtml5dateinput = false;
  }

  if (typeof config.cookieConsentEnabled != 'undefined') {
    config.cookieconsentenabled = config.cookieConsentEnabled;
    delete config.cookieConsentEnabled;
  }

  if (typeof config.cookieconsentenabled == 'undefined') {
    config.cookieconsentenabled = false;
  }

  if (typeof config.initialProcessMarkupSelector == 'undefined') {
    if (typeof window != 'undefined' && typeof document != 'undefined') {
      var initialProcessMarkupSelector = 'document';
    } else {
      var initialProcessMarkupSelector = '';
    }
  } else {
    var initialProcessMarkupSelector = config.initialProcessMarkupSelector;
  }

  config.formdata = typeof FormData != 'undefined' ? true : false;
  var initForDataOnly = false;

  if (typeof config.processMarkup != 'undefined') {
    initForDataOnly = typeof config.processMarkup != 'function' && !config.processMarkup;
    delete config.processMarkup;
  } else if (typeof config.processmarkup != 'undefined') {
    initForDataOnly = typeof config.processmarkup != 'function' && !config.processmarkup;
    delete config.processmarkup;
  }

  extend(Mura, config);
  Mura.trackingMetadata = {};
  Mura.hydrationData = {};

  if (typeof config.content != 'undefined' && typeof config.content.get != 'undefined' && config.content.get('displayregions')) {
    for (var r in config.content.properties.displayregions) {
      if (config.content.properties.displayregions.hasOwnProperty(r)) {
        var data = config.content.properties.displayregions[r];

        if (typeof data.inherited != 'undefined' && typeof data.inherited.items != 'undefined') {
          for (var d in data.inherited.items) {
            Mura.hydrationData[data.inherited.items[d].instanceid] = data.inherited.items[d];
          }
        }

        if (typeof data.local != 'undefined' && typeof data.local.items != 'undefined') {
          for (var d in data.local.items) {
            Mura.hydrationData[data.local.items[d].instanceid] = data.local.items[d];
          }
        }
      }
    }
  }

  Mura.dateformat = generateDateFormat();

  if (Mura.mode.toLowerCase() == 'rest') {
    Mura.apiEndpoint = Mura.apiEndpoint.replace('/json/', '/rest/');
  }

  if (typeof window != 'undefined' && typeof window.document != 'undefined') {
    if (Array.isArray(window.queuedMuraCmds) && window.queuedMuraCmds.length) {
      holdingQueue = window.queuedMuraCmds.concat(holdingQueue);
      window.queuedMuraCmds = [];
    }

    if (Array.isArray(window.queuedMuraPreInitCmds) && window.queuedMuraPreInitCmds.length) {
      holdingPreInitQueue = window.queuedMuraPreInitCmds.concat(holdingPreInitQueue);
      window.queuedMuraPreInitCmds = [];
    }
  }

  if (!initForDataOnly) {
    destroyDisplayObjects();
    stopUserStateListener();
    Mura(function () {
      for (var cmd in holdingPreInitQueue) {
        if (typeof holdingPreInitQueue[cmd] == 'function') {
          holdingPreInitQueue[cmd](Mura);
        }
      }

      if (typeof window != 'undefined' && typeof window.document != 'undefined') {
        var hash = location.hash;

        if (hash) {
          hash = hash.substring(1);
        }

        urlparams = setLowerCaseKeys(getQueryStringParams(location.search));

        if (hashparams.nextnid) {
          Mura('.mura-async-object[data-nextnid="' + hashparams.nextnid + '"]').each(function (el) {
            Mura(el).data(hashparams);
          });
        } else if (hashparams.objectid) {
          Mura('.mura-async-object[data-nextnid="' + hashparams.objectid + '"]').each(function (el) {
            Mura(el).data(hashparams);
          });
        }

        Mura(window).on('hashchange', handleHashChange);
        Mura(document).on('click', 'div.mura-object .mura-next-n a,div.mura-object .mura-search-results div.moreResults a,div.mura-object div.mura-pagination a', function (e) {
          e.preventDefault();
          var href = Mura(e.target).attr('href');

          if (href != '#') {
            var hArray = href.split('?');
            var source = Mura(e.target);
            var data = setLowerCaseKeys(getQueryStringParams(hArray[hArray.length - 1]));
            var obj = source.closest('div.mura-object');
            obj.data(data);
            processAsyncObject(obj.node).then(function () {
              try {
                if (typeof window != 'undefined' && typeof document != 'undefined') {
                  var rect = obj.node.getBoundingClientRect();
                  var elemTop = rect.top;

                  if (elemTop < 0) {
                    window.scrollTo(0, Mura(document).scrollTop() + elemTop);
                  }
                }
              } catch (e) {
                console.log(e);
              }
            });
          }
        });

        if (!Mura.inAdmin && initialProcessMarkupSelector) {
          if (initialProcessMarkupSelector == 'document') {
            processMarkup(document);
          } else {
            processMarkup(initialProcessMarkupSelector);
          }
        }

        Mura.markupInitted = true;

        if (Mura.cookieconsentenabled) {
          Mura(function () {
            Mura('body').appendDisplayObject({
              object: 'cookie_consent',
              queue: false,
              statsid: 'cookie_consent'
            });
          });
        }

        Mura(document).on("keydown", function (event) {
          keyCmdCheck(event);
        });
        Mura.breakpoint = getBreakpoint();
        Mura.windowResponsiveModules = {};
        window.addEventListener("resize", function () {
          clearTimeout(Mura.windowResizeID);
          Mura.windowResizeID = setTimeout(doneResizing, 250);

          function doneResizing() {
            var breakpoint = getBreakpoint();

            if (breakpoint != Mura.breakpoint) {
              Mura.breakpoint = breakpoint;
              Mura('.mura-object').each(function (el) {
                var obj = Mura(el);
                var instanceid = obj.data('instanceid');

                if (typeof Mura.windowResponsiveModules[instanceid] == 'undefined' || Mura.windowResponsiveModules[instanceid]) {
                  obj.calculateDisplayObjectStyles(true);
                }
              });
            }

            delete Mura.windowResizeID;
          }
        });
        Mura(document).trigger('muraReady');
        pollUserState();
      }
    });
    readyInternal(initReadyQueue);
  }

  return Mura;
}

var Mura = extend(function (selector, context) {
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
  preInit: function preInit(fn) {
    if (holdingReady) {
      holdingPreInitQueue.push(fn);
    } else {
      Mura(fn);
    }
  },
  generateOAuthToken: generateOAuthToken,
  entities: {},
  feeds: {},
  submitForm: submitForm,
  escapeHTML: escapeHTML,
  unescapeHTML: unescapeHTML,
  processDisplayObject: processDisplayObject,
  processModule: processModule,
  processAsyncObject: processAsyncObject,
  resetAsyncObject: resetAsyncObject,
  setLowerCaseKeys: setLowerCaseKeys,
  throttle: throttle,
  debounce: debounce,
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
  delete: deleteReq,
  put: put,
  patch: patch,
  deepExtend: deepExtend,
  ajax: ajax,
  request: ajax,
  changeElementType: changeElementType,
  setHTMLEditor: setHTMLEditor,
  each: each,
  parseHTML: parseHTML,
  getData: getData,
  cleanModuleProps: cleanModuleProps,
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
  startUserStateListener: startUserStateListener,
  stopUserStateListener: stopUserStateListener,
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
  eraseCookie: eraseCookie,
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
  requestHeaders: requestHeaders,
  setRequestHeader: setRequestHeader,
  getRequestHeader: getRequestHeaders,
  getRequestHeaders: getRequestHeaders,
  mode: 'json',
  declareEntity: declareEntity,
  undeclareEntity: undeclareEntity,
  buildDisplayRegion: buildDisplayRegion,
  openGate: openGate,
  firstToUpperCase: firstToUpperCase,
  firstToLowerCase: firstToLowerCase,
  normalizeRequestHandler: normalizeRequestHandler,
  getStyleSheet: getStyleSheet,
  getStyleSheetPlaceHolder: getStyleSheetPlaceHolder,
  applyModuleStyles: applyModuleStyles,
  applyModuleCustomCSS: applyModuleCustomCSS,
  recordModuleStyles: recordModuleStyles,
  recordModuleClassesAndIds: recordModuleClassesAndIds,
  getModuleStyleTargets: getModuleStyleTargets,
  getBreakpoint: getBreakpoint,
  getAPIEndpoint: getAPIEndpoint,
  setAPIEndpoint: setAPIEndpoint,
  getMode: getMode,
  setMode: setMode,
  parseStringAsTemplate: parseStringAsTemplate,
  findText: findText,
  deInit: deInit,
  inAdmin: false,
  lmv: 2,
  homeid: '00000000000000000000000000000000001',
  cloning: false
});
Mura.Module = Mura.DisplayObject;
module.exports = Mura;

/***/ }),

/***/ 6839:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

function _typeof(obj) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (obj) { return typeof obj; } : function (obj) { return obj && "function" == typeof Symbol && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }, _typeof(obj); }

var Mura = __webpack_require__(791);

'use strict';
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
  init: function init(selection, origSelector) {
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

    if (typeof Mura.supportPassive == 'undefined') {
      Mura.supportsPassive = false;

      try {
        var opts = Object.defineProperty({}, 'passive', {
          get: function get() {
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
  get: function get(index) {
    if (typeof index != 'undefined') {
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
  select: function select(selector) {
    return Mura(selector);
  },

  /**
   * each - Runs function against each item in selection
   *
   * @param	{function} fn Method
   * @return {Mura.DOMSelection} Self
   */
  each: function each(fn) {
    this.selection.forEach(function (el, idx, array) {
      if (typeof fn.call == 'undefined') {
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
  forEach: function forEach(fn) {
    this.selection.forEach(function (el, idx, array) {
      if (typeof fn.call == 'undefined') {
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
  filter: function filter(fn) {
    return Mura(this.selection.filter(function (el, idx, array) {
      if (typeof fn.call == 'undefined') {
        return fn(el, idx, array);
      } else {
        return fn.call(el, el, idx, array);
      }
    }));
  },

  /**
   * map - Creates a new Mura.DomSelection instance contains selection values that are returned by Map function
   *
   * @param	{function} fn Map function
   * @return {object}		New Mura.DOMSelection
   */
  map: function map(fn) {
    return Mura(this.selection.map(function (el, idx, array) {
      if (typeof fn.call == 'undefined') {
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
  reduce: function reduce(fn, initialValue) {
    initialValue = initialValue || 0;
    return this.selection.reduce(function (accumulator, item, idx, array) {
      if (typeof fn.call == 'undefined') {
        return fn(accumulator, item, idx, array);
      } else {
        return fn.call(item, accumulator, item, idx, array);
      }
    }, initialValue);
  },

  /**
   * isNumeric - Returns if value is numeric
   *
   * @param	{*} val Value
   * @return {type}		 description
   */
  isNumeric: function (_isNumeric) {
    function isNumeric(_x) {
      return _isNumeric.apply(this, arguments);
    }

    isNumeric.toString = function () {
      return _isNumeric.toString();
    };

    return isNumeric;
  }(function (val) {
    if (typeof val != 'undefined') {
      return isNumeric(val);
    }

    return isNumeric(this.selection[0]);
  }),

  /**
   * processMarkup - Process Markup of selected dom elements
   *
   * @return {Promise}
   */
  processMarkup: function processMarkup() {
    var self = this;
    return new Promise(function (resolve, reject) {
      self.each(function (el) {
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
  addEventHandler: function addEventHandler(selector, handler) {
    if (typeof handler == 'undefined') {
      handler = selector;
      selector = '';
    }

    for (var h in handler) {
      if (eventName.hasOwnProperty(h)) {
        if (typeof selector == 'string' && selector) {
          on(h, selector, handler[h]);
        } else {
          on(h, handler[h]);
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
  on: function on(eventName, selector, fn, EventListenerOptions) {
    if (typeof EventListenerOptions == 'undefined') {
      if (typeof fn != 'undefined' && typeof fn != 'function') {
        EventListenerOptions = fn;
      } else {
        EventListenerOptions = true;
      }
    }

    if (eventName == 'touchstart' || eventName == 'end') {
      EventListenerOptions = Mura.supportsPassive ? {
        passive: true
      } : false;
    }

    if (typeof selector == 'function') {
      fn = selector;
      selector = '';
    }

    if (typeof fn === 'undefined') {
      return;
    }

    if (eventName == 'ready') {
      if (document.readyState != 'loading') {
        var self = this;
        setTimeout(function () {
          self.each(function (target) {
            if (selector) {
              Mura(target).find(selector).each(function (target) {
                if (typeof fn.call == 'undefined') {
                  fn(target);
                } else {
                  fn.call(target, target);
                }
              });
            } else {
              if (typeof fn.call == 'undefined') {
                fn(target);
              } else {
                fn.call(target, target);
              }
            }
          });
        }, 1);
        return this;
      } else {
        eventName = 'DOMContentLoaded';
      }
    }

    this.each(function (el) {
      if (typeof this.addEventListener == 'function') {
        var self = el;
        this.addEventListener(eventName, function (event) {
          if (selector) {
            if (Mura(event.target).is(selector)) {
              if (typeof fn.call == 'undefined') {
                return fn(event);
              } else {
                return fn.call(event.target, event);
              }
            }
          } else {
            if (typeof fn.call == 'undefined') {
              return fn(event);
            } else {
              return fn.call(self, event);
            }
          }
        }, EventListenerOptions);
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
  hover: function hover(handlerIn, handlerOut, EventListenerOptions) {
    if (typeof EventListenerOptions == 'undefined' || EventListenerOptions == null) {
      EventListenerOptions = Mura.supportsPassive ? {
        passive: true
      } : false;
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
  click: function click(fn) {
    this.on('click', fn);
    return this;
  },

  /**
   * change - Adds onChange event handler to selection
   *
   * @param	{function} fn Handler function
   * @return {Mura.DOMSelection} Self
   */
  change: function change(fn) {
    this.on('change', fn);
    return this;
  },

  /**
   * submit - Adds onSubmit event handler to selection
   *
   * @param	{function} fn Handler function
   * @return {Mura.DOMSelection} Self
   */
  submit: function submit(fn) {
    if (fn) {
      this.on('submit', fn);
    } else {
      this.each(function (el) {
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
  ready: function ready(fn) {
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
  off: function off(eventName, fn) {
    this.each(function (el, idx, array) {
      if (typeof eventName != 'undefined') {
        if (typeof fn != 'undefined') {
          el.removeEventListener(eventName, fn);
        } else {
          el[eventName] = null;
        }
      } else {
        if (typeof el.parentElement != 'undefined' && el.parentElement && typeof el.parentElement.replaceChild != 'undefined') {
          var elClone = el.cloneNode(true);
          el.parentElement.replaceChild(elClone, el);
          array[idx] = elClone;
        } else {
          console.log("Mura: Can not remove all handlers from element without a parent node");
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
  unbind: function unbind(eventName, fn) {
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
  bind: function bind(eventName, fn) {
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
  trigger: function trigger(eventName, eventDetail) {
    eventDetail = eventDetail || {};
    this.each(function (el) {
      Mura.trigger(el, eventName, eventDetail);
    });
    return this;
  },

  /**
   * parent - Return new Mura.DOMSelection of the first elements parent
   *
   * @return {Mura.DOMSelection}
   */
  parent: function parent() {
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
  children: function children(selector) {
    if (!this.selection.length) {
      return this;
    }

    if (this.selection[0].hasChildNodes()) {
      var children = Mura(this.selection[0].childNodes);

      if (typeof selector == 'string') {
        var filterFn = function filterFn(el) {
          return (el.nodeType === 1 || el.nodeType === 11 || el.nodeType === 9) && el.matchesSelector(selector);
        };
      } else {
        var filterFn = function filterFn(el) {
          return el.nodeType === 1 || el.nodeType === 11 || el.nodeType === 9;
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
  find: function find(selector) {
    if (this.selection.length && this.selection[0]) {
      var removeId = false;

      if (this.selection[0].nodeType == '1' || this.selection[0].nodeType == '11') {
        var result = this.selection[0].querySelectorAll(selector);
      } else if (this.selection[0].nodeType == '9') {
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
  first: function first() {
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
  last: function last() {
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
  selector: function selector() {
    var pathes = [];
    var path,
        node = Mura(this.selection[0]);

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
      } else if (node.data('instanceid')) {
        name = '[data-instanceid="' + node.data('instanceid') + '"]';
        path = name + (path ? ' > ' + path : '');
        break;
      } else {
        name = name.toLowerCase();
        var parent = node.parent();
        var sameTagSiblings = parent.children(name);

        if (sameTagSiblings.length > 1) {
          var allSiblings = parent.children();
          var index = allSiblings.index(realNode) + 1;

          if (index > 0) {
            name += ':nth-child(' + index + ')';
          }
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
  siblings: function siblings(selector) {
    if (!this.selection.length) {
      return this;
    }

    var el = this.selection[0];

    if (el.hasChildNodes()) {
      var silbings = Mura(this.selection[0].childNodes);

      if (typeof selector == 'string') {
        var filterFn = function filterFn(el) {
          return (el.nodeType === 1 || el.nodeType === 11 || el.nodeType === 9) && el.matchesSelector(selector);
        };
      } else {
        var filterFn = function filterFn(el) {
          return el.nodeType === 1 || el.nodeType === 11 || el.nodeType === 9;
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
  item: function item(idx) {
    return this.selection[idx];
  },

  /**
   * index - Returns the index of element
   *
   * @param	{*} el Element to return index of
   * @return {*}
   */
  index: function index(el) {
    return this.selection.indexOf(el);
  },

  /**
   * indexOf - Returns the index of element
   *
   * @param	{*} el Element to return index of
   * @return {*}
   */
  indexOf: function indexOf(el) {
    return this.selection.indexOf(el);
  },

  /**
   * closest - Returns new Mura.DOMSelection of closest parent matching selector
   *
   * @param	{string} selector Selector
   * @return {Mura.DOMSelection}
   */
  closest: function closest(selector) {
    if (!this.selection.length) {
      return null;
    }

    var el = this.selection[0];

    for (var parent = el; parent !== null && parent.matchesSelector && !parent.matchesSelector(selector); parent = el.parentElement) {
      el = parent;
    }

    ;

    if (parent) {
      return Mura(parent);
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
  append: function append(el) {
    this.each(function (target) {
      try {
        if (typeof el == 'string') {
          target.insertAdjacentHTML('beforeend', el);
        } else {
          target.appendChild(el);
        }
      } catch (e) {
        console.log(e);
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
  appendDisplayObject: function appendDisplayObject(data) {
    var self = this;
    delete data.method;

    if (typeof data.transient == 'undefined') {
      data.transient = true;
    }

    return new Promise(function (resolve, reject) {
      self.each(function (target) {
        var el = document.createElement('div');
        el.setAttribute('class', 'mura-object');
        var preserveid = false;

        for (var a in data) {
          if (_typeof(data[a]) == 'object') {
            el.setAttribute('data-' + a, JSON.stringify(data[a]));
          } else if (a != 'preserveid') {
            el.setAttribute('data-' + a, data[a]);
          } else {
            preserveid = data[a];
          }
        }

        if (typeof data.async == 'undefined') {
          el.setAttribute('data-async', true);
        }

        if (typeof data.render == 'undefined') {
          el.setAttribute('data-render', 'server');
        }

        if (preserveid && Mura.isUUID(data.instanceid)) {
          el.setAttribute('data-instanceid', data.instanceid);
        } else {
          el.setAttribute('data-instanceid', Mura.createUUID());
        }

        var self = target;

        function watcher() {
          if (Mura.markupInitted) {
            Mura(self).append(el);
            Mura.processDisplayObject(el, true, true).then(resolve, reject);
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
  appendModule: function appendModule(data) {
    return this.appendDisplayObject(data);
  },

  /**
   * insertDisplayObjectAfter - Inserts display object after selected items
   *
   * @param	{object} data Display objectparams (including object='objectkey')
   * @return {Promise}
   */
  insertDisplayObjectAfter: function insertDisplayObjectAfter(data) {
    var self = this;
    delete data.method;

    if (typeof data.transient == 'undefined') {
      data.transient = true;
    }

    return new Promise(function (resolve, reject) {
      self.each(function (target) {
        var el = document.createElement('div');
        el.setAttribute('class', 'mura-object');
        var preserveid = false;

        for (var a in data) {
          if (_typeof(data[a]) == 'object') {
            el.setAttribute('data-' + a, JSON.stringify(data[a]));
          } else if (a != 'preserveid') {
            el.setAttribute('data-' + a, data[a]);
          } else {
            preserveid = data[a];
          }
        }

        if (typeof data.async == 'undefined') {
          el.setAttribute('data-async', true);
        }

        if (typeof data.render == 'undefined') {
          el.setAttribute('data-render', 'server');
        }

        if (preserveid && Mura.isUUID(data.instanceid)) {
          el.setAttribute('data-instanceid', data.instanceid);
        } else {
          el.setAttribute('data-instanceid', Mura.createUUID());
        }

        var self = target;

        function watcher() {
          if (Mura.markupInitted) {
            Mura(self).after(el);
            Mura.processDisplayObject(el, true, true).then(resolve, reject);
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
  insertModuleAfter: function insertModuleAfter(data) {
    return this.insertDisplayObjectAfter(data);
  },

  /**
   * insertDisplayObjectBefore - Inserts display object after selected items
   *
   * @param	{object} data Display objectparams (including object='objectkey')
   * @return {Promise}
   */
  insertDisplayObjectBefore: function insertDisplayObjectBefore(data) {
    var self = this;
    delete data.method;

    if (typeof data.transient == 'undefined') {
      data.transient = true;
    }

    return new Promise(function (resolve, reject) {
      self.each(function (target) {
        var el = document.createElement('div');
        el.setAttribute('class', 'mura-object');
        var preserveid = false;

        for (var a in data) {
          if (_typeof(data[a]) == 'object') {
            el.setAttribute('data-' + a, JSON.stringify(data[a]));
          } else if (a != 'preserveid') {
            el.setAttribute('data-' + a, data[a]);
          } else {
            preserveid = data[a];
          }
        }

        if (typeof data.async == 'undefined') {
          el.setAttribute('data-async', true);
        }

        if (typeof data.render == 'undefined') {
          el.setAttribute('data-render', 'server');
        }

        if (preserveid && Mura.isUUID(data.instanceid)) {
          el.setAttribute('data-instanceid', data.instanceid);
        } else {
          el.setAttribute('data-instanceid', Mura.createUUID());
        }

        var self = target;

        function watcher() {
          if (Mura.markupInitted) {
            Mura(self).before(el);
            Mura.processDisplayObject(el, true, true).then(resolve, reject);
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
  insertModuleBefore: function insertModuleBefore(data) {
    return this.insertDisplayObjectBefore(data);
  },

  /**
   * prependDisplayObject - Prepends display object to selected items
   *
   * @param	{object} data Display objectparams (including object='objectkey')
   * @return {Promise}
   */
  prependDisplayObject: function prependDisplayObject(data) {
    var self = this;
    delete data.method;

    if (typeof data.transient == 'undefined') {
      data.transient = true;
    }

    return new Promise(function (resolve, reject) {
      self.each(function (target) {
        var el = document.createElement('div');
        el.setAttribute('class', 'mura-object');
        var preserveid = false;

        for (var a in data) {
          if (_typeof(data[a]) == 'object') {
            el.setAttribute('data-' + a, JSON.stringify(data[a]));
          } else if (a != 'preserveid') {
            el.setAttribute('data-' + a, data[a]);
          } else {
            preserveid = data[a];
          }
        }

        if (typeof data.async == 'undefined') {
          el.setAttribute('data-async', true);
        }

        if (typeof data.render == 'undefined') {
          el.setAttribute('data-render', 'server');
        }

        if (preserveid && Mura.isUUID(data.instanceid)) {
          el.setAttribute('data-instanceid', data.instanceid);
        } else {
          el.setAttribute('data-instanceid', Mura.createUUID());
        }

        var self = target;

        function watcher() {
          if (Mura.markupInitted) {
            Mura(self).prepend(el);
            Mura.processDisplayObject(el, true, true).then(resolve, reject);
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
  prependModule: function prependModule(data) {
    return this.prependDisplayObject(data);
  },

  /**
   * processDisplayObject - Handles processing of display object params to selection
   *
   * @return {Promise}
   */
  processDisplayObject: function processDisplayObject() {
    var self = this;
    return new Promise(function (resolve, reject) {
      self.each(function (target) {
        Mura.processDisplayObject(target, true, true).then(resolve, reject);
      });
    });
  },

  /**
   * processModule - Prepends display object to selected items
   *
   * @return {Promise}
   */
  processModule: function processModule() {
    return this.processDisplayObject();
  },

  /**
   * prepend - Prepends element to items in selection
   *
   * @param	{*} el Element to append
   * @return {Mura.DOMSelection} Self
   */
  prepend: function prepend(el) {
    this.each(function (target) {
      try {
        if (typeof el == 'string') {
          target.insertAdjacentHTML('afterbegin', el);
        } else {
          target.insertBefore(el, target.firstChild);
        }
      } catch (e) {
        console.log(e);
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
  before: function before(el) {
    this.each(function (target) {
      try {
        if (typeof el == 'string') {
          target.insertAdjacentHTML('beforebegin', el);
        } else {
          target.parentNode.insertBefore(el, target);
        }
      } catch (e) {
        console.log(e);
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
  after: function after(el) {
    this.each(function (target) {
      try {
        if (typeof el == 'string') {
          target.insertAdjacentHTML('afterend', el);
        } else {
          if (target.nextSibling) {
            target.parentNode.insertBefore(el, target.nextSibling);
          } else {
            target.parentNode.appendChild(el);
          }
        }
      } catch (e) {
        console.log(e);
      }
    });
    return this;
  },

  /**
   * hide - Hides elements in selection
   *
   * @return {object}	Self
   */
  hide: function hide() {
    this.each(function (el) {
      el.style.display = 'none';
    });
    return this;
  },

  /**
   * show - Shows elements in selection
   *
   * @return {object}	Self
   */
  show: function show() {
    this.each(function (el) {
      el.style.display = '';
    });
    return this;
  },

  /**
   * repaint - repaints elements in selection
   *
   * @return {object}	Self
   */
  redraw: function redraw() {
    this.each(function (el) {
      var elm = Mura(el);
      setTimeout(function () {
        elm.show();
      }, 1);
    });
    return this;
  },

  /**
   * remove - Removes elements in selection
   *
   * @return {object}	Self
   */
  remove: function remove() {
    this.each(function (el) {
      el.parentNode && el.parentNode.removeChild(el);
    });
    return this;
  },

  /**
   * detach - Detaches elements in selection
   *
   * @return {object}	Self
   */
  detach: function detach() {
    var detached = [];
    this.each(function (el) {
      el.parentNode && detached.push(el.parentNode.removeChild(el));
    });
    return Mura(detached);
  },

  /**
   * addClass - Adds class to elements in selection
   *
   * @param	{string} className Name of class
   * @return {Mura.DOMSelection} Self
   */
  addClass: function addClass(className) {
    if (className.length) {
      this.each(function (el) {
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
  hasClass: function hasClass(className) {
    return this.is("." + className);
  },

  /**
   * removeClass - Removes class from elements in selection
   *
   * @param	{string} className Class name
   * @return {Mura.DOMSelection} Self
   */
  removeClass: function removeClass(className) {
    this.each(function (el) {
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
  toggleClass: function toggleClass(className) {
    this.each(function (el) {
      if (el.classList) {
        el.classList.toggle(className);
      } else {
        var classes = el.className.split(' ');
        var existingIndex = classes.indexOf(className);
        if (existingIndex >= 0) classes.splice(existingIndex, 1);else classes.push(className);
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
  empty: function empty() {
    this.each(function (el) {
      el.innerHTML = '';
    });
    return this;
  },

  /**
   * evalScripts - Evaluates script tags in selection elements
   *
   * @return {object}	Self
   */
  evalScripts: function evalScripts() {
    if (!this.selection.length) {
      return this;
    }

    this.each(function (el) {
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
  html: function html(htmlString) {
    if (typeof htmlString != 'undefined') {
      this.each(function (el) {
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
  css: function css(ruleName, value) {
    if (!this.selection.length) {
      return this;
    }

    if (typeof ruleName == 'undefined' && typeof value == 'undefined') {
      try {
        return getComputedStyle(this.selection[0]);
      } catch (e) {
        console.log(e);
        return {};
      }
    } else if (_typeof(ruleName) == 'object') {
      this.each(function (el) {
        try {
          for (var p in ruleName) {
            el.style[Mura.styleMap.tojs[p.toLowerCase()]] = ruleName[p];
          }
        } catch (e) {
          console.log(e);
        }
      });
    } else if (typeof value != 'undefined') {
      this.each(function (el) {
        try {
          el.style[Mura.styleMap.tojs[ruleName.toLowerCase()]] = value;
        } catch (e) {
          console.log(e);
        }
      });
      return this;
    } else {
      try {
        return getComputedStyle(this.selection[0])[Mura.styleMap.tojs[ruleName.toLowerCase()]];
      } catch (e) {
        console.log(e);
      }
    }

    return this;
  },

  /**
   * calculateDisplayObjectStyles - Looks at data attrs and sets appropriate styles
   *
   * @return {object}	Self
   */
  calculateDisplayObjectStyles: function calculateDisplayObjectStyles(windowResponse) {
    this.each(function (el) {
      var breakpoints = ['mura-xs', 'mura-sm', 'mura-md', 'mura-lg', 'mura-xl'];
      var objBreakpoint = 'mura-sm';
      var obj = Mura(el);

      for (var b = 0; b < breakpoints.length; b++) {
        if (obj.is('.' + breakpoints[b])) {
          objBreakpoint = breakpoints[b];
          break;
        }
      }

      var styleTargets = Mura.getModuleStyleTargets(obj.data('instanceid'), true);
      var fullsize = breakpoints.indexOf('mura-' + Mura.getBreakpoint()) >= breakpoints.indexOf(objBreakpoint);
      Mura.windowResponsiveModules = Mura.windowResponsiveModules || {};
      Mura.windowResponsiveModules[obj.data('instanceid')] = false;
      obj = obj.node ? obj : Mura(obj);

      if (!windowResponse) {
        applyObjectClassesAndId(obj);
      }

      var styleSupport = obj.data('stylesupport') || {};

      if (typeof styleSupport == 'string') {
        try {
          styleSupport = JSON.parse.call(null, styleSupport);
        } catch (e) {
          styleSupport = {};
        }

        if (typeof styleSupport == 'string') {
          styleSupport = {};
        }
      }

      obj.removeAttr('style');

      if (!fullsize) {
        if (styleSupport && _typeof(styleSupport.objectstyles) == 'object') {
          var objectstyles = styleSupport.objectstyles;
          delete objectstyles.margin;
          delete objectstyles.marginLeft;
          delete objectstyles.marginRight;
          delete objectstyles.marginTop;
          delete objectstyles.marginBottom;
        }
      }

      if (!fullsize || fullsize && !(obj.css('marginTop') == '0px' && obj.css('marginBottom') == '0px' && obj.css('marginLeft') == '0px' && obj.css('marginRight') == '0px')) {
        Mura.windowResponsiveModules[obj.data('instanceid')] = true;
      }

      if (!windowResponse) {
        var sheet = Mura.getStyleSheet('mura-styles-' + obj.data('instanceid'));

        while (sheet.cssRules.length) {
          sheet.deleteRule(0);
        }

        Mura.applyModuleStyles(styleSupport, styleTargets.object, sheet, obj);
        Mura.applyModuleCustomCSS(styleSupport, sheet, obj.data('instanceid'));
      }

      var metaWrapper = obj.children('.mura-object-meta-wrapper');

      if (metaWrapper.length) {
        styleSupport.metastyles = styleSupport.metastyles || {};
        var meta = metaWrapper.children('.mura-object-meta');

        if (meta.length) {
          meta.removeAttr('style');

          if (!windowResponse) {
            applyMetaClassesAndId(obj, meta, metaWrapper);
            Mura.applyModuleStyles(styleSupport, styleTargets.meta, sheet, obj);
          }
        }
      }

      var content = obj.children('.mura-object-content').first();
      content.removeAttr('style');

      if (!windowResponse) {
        applyContentClassesAndId(obj, content, metaWrapper);
        Mura.applyModuleStyles(styleSupport, styleTargets.content, sheet, obj);
      }

      applyMarginWidthOffset(obj);
      pinUIToolsToTopLeft(obj);

      function applyObjectClassesAndId(obj) {
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

        if (obj.data('objectspacing')) {
          var classes = obj.data('objectspacing');

          if (typeof classes != 'array') {
            var classes = classes.split(' ');
          }

          for (var c = 0; c < classes.length; c++) {
            if (c != 'custom' && !obj.hasClass(classes[c])) {
              obj.addClass(classes[c]);
            }
          }
        }

        if (obj.data('cssid')) {
          obj.attr('id', obj.data('cssid'));
        } else {
          obj.removeAttr('id');
        }
      }

      function applyMetaClassesAndId(obj, meta, metawrapper) {
        if (obj.data('metacssid')) {
          meta.attr('id', obj.data('metacssid'));
        } else {
          meta.removeAttr('id');
        }

        if (obj.data('metacssclass')) {
          obj.data('metacssclass').split(' ').forEach(function (c) {
            if (!meta.hasClass(c)) {
              meta.addClass(c);
            }
          });
        }

        if (obj.data('metaspacing')) {
          var classes = obj.data('metaspacing');

          if (typeof classes != 'array') {
            var classes = classes.split(' ');
          }

          for (var c = 0; c < classes.length; c++) {
            if (c != 'custom' && !meta.hasClass(classes[c])) {
              meta.addClass(classes[c]);
            }
          }
        }

        if (obj.is('.mura-object-label-left, .mura-object-label-right')) {
          var left = meta.css('marginLeft');
          var right = meta.css('marginRight');

          if (!(left == '0px' && right == '0px') && left.charAt(0) != "-" && right.charAt(0) != "-") {
            meta.css('width', 'calc(50% - (' + left + ' + ' + right + '))');
          }
        }
      }

      function applyContentClassesAndId(obj, content, metaWrapper) {
        if (obj.data('contentcssid')) {
          content.attr('id', obj.data('contentcssid'));
        } else {
          content.removeAttr('id');
        }

        if (obj.data('contentcssclass')) {
          obj.data('contentcssclass').split(' ').forEach(function (c) {
            if (!content.hasClass(c)) {
              content.addClass(c);
            }
          });
        }

        if (obj.data('contentspacing')) {
          var classes = obj.data('contentspacing');

          if (typeof classes != 'array') {
            var classes = classes.split(' ');
          }

          for (var c = 0; c < classes.length; c++) {
            if (c != 'custom' && !content.hasClass(classes[c])) {
              content.addClass(classes[c]);
            }
          }
        }

        if (content.hasClass('container')) {
          metaWrapper.addClass('container');
        } else {
          metaWrapper.removeClass('container');
        }

        if (obj.is('.mura-object-label-left, .mura-object-label-right')) {
          var left = content.css('marginLeft');
          var right = content.css('marginRight');

          if (!(left == '0px' && right == '0px') && left.charAt(0) != "-" && right.charAt(0) != "-") {
            if (fullsize) {
              content.css('width', 'calc(50% - (' + left + ' + ' + right + '))');
            }

            Mura.windowResponsiveModules[obj.data('instanceid')] = true;
          }
        }
      }

      function applyMarginWidthOffset(obj) {
        var left = obj.css('marginLeft');
        var right = obj.css('marginRight');

        if (!obj.is('.mura-center') && !(left == '0px' && right == '0px') && !(left == 'auto' || right == 'auto') && left.charAt(0) != "-" && right.charAt(0) != "-") {
          if (fullsize) {
            var width = '100%';

            if (obj.is('.mura-one')) {
              width = '8.33%';
            } else if (obj.is('.mura-two')) {
              width = '16.66%';
            } else if (obj.is('.mura-three')) {
              width = '25%';
            } else if (obj.is('.mura-four')) {
              width = '33.33%';
            } else if (obj.is('.mura-five')) {
              width = '41.66%';
            } else if (obj.is('.mura-six')) {
              width = '50%';
            } else if (obj.is('.mura-seven')) {
              width = '58.33';
            } else if (obj.is('.mura-eight')) {
              width = '66.66%';
            } else if (obj.is('.mura-nine')) {
              width = '75%';
            } else if (obj.is('.mura-ten')) {
              width = '83.33%';
            } else if (obj.is('.mura-eleven')) {
              width = '91.66%';
            } else if (obj.is('.mura-twelve')) {
              width = '100%';
            } else if (obj.is('.mura-one-third')) {
              width = '33.33%';
            } else if (obj.is('.mura-two-thirds')) {
              width = '66.66%';
            } else if (obj.is('.mura-one-half')) {
              width = '50%';
            } else {
              width = '100%';
            }

            obj.css('width', 'calc(' + width + ' - (' + left + ' + ' + right + '))');
          }

          Mura.windowResponsiveModules[obj.data('instanceid')] = true;
        }
      }

      function pinUIToolsToTopLeft(obj) {
        if (obj.css('paddingTop').replace(/[^0-9]/g, '') != '0' || obj.css('paddingLeft').replace(/[^0-9]/g, '') != '0') {
          obj.addClass('mura-object-pin-tools');
        } else {
          obj.removeClass('mura-object-pin-tools');
        }
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
  text: function text(textString) {
    if (typeof textString != 'undefined') {
      this.each(function (el) {
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
  is: function is(selector) {
    if (!this.selection.length) {
      return false;
    }

    try {
      if (typeof this.selection[0] !== "undefined") {
        return this.selection[0].matchesSelector && this.selection[0].matchesSelector(selector);
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  },

  /**
   * hasAttr - Returns is the first element in the selection has an attribute
   *
   * @param	{string} attributeName description
   * @return {boolean}
   */
  hasAttr: function hasAttr(attributeName) {
    if (!this.selection.length) {
      return false;
    }

    return typeof this.selection[0].hasAttribute == 'function' && this.selection[0].hasAttribute(attributeName);
  },

  /**
   * hasData - Returns if the first element in the selection has data attribute
   *
   * @param	{sting} attributeName Data atttribute name
   * @return {boolean}
   */
  hasData: function hasData(attributeName) {
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
  offsetParent: function offsetParent() {
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
  outerHeight: function outerHeight(withMargin) {
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
  height: function height(_height) {
    if (!this.selection.length) {
      return this;
    }

    if (typeof width != 'undefined') {
      if (!isNaN(_height)) {
        _height += 'px';
      }

      this.css('height', _height);
      return this;
    }

    var el = this.selection[0]; //var type=el.constructor.name.toLowerCase();

    if (typeof window != 'undefined' && typeof window.document != 'undefined' && el === window) {
      return innerHeight;
    } else if (el === document) {
      var body = document.body;
      var html = document.documentElement;
      return Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight);
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
  width: function (_width) {
    function width(_x2) {
      return _width.apply(this, arguments);
    }

    width.toString = function () {
      return _width.toString();
    };

    return width;
  }(function (width) {
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

    var el = this.selection[0]; //var type=el.constructor.name.toLowerCase();

    if (typeof window != 'undefined' && typeof window.document != 'undefined' && el === window) {
      return innerWidth;
    } else if (el === document) {
      var body = document.body;
      var html = document.documentElement;
      return Math.max(body.scrollWidth, body.offsetWidth, html.clientWidth, html.scrolWidth, html.offsetWidth);
    }

    return getComputedStyle(el).width;
  }),

  /**
   * width - Returns outerWidth of first element in selection
   *
   * @return {number}
   */
  outerWidth: function outerWidth() {
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
  scrollTop: function scrollTop() {
    if (!this.selection.length) {
      return 0;
    }

    var el = this.selection[0];

    if (typeof el.scrollTop != 'undefined') {
      return el.scrollTop;
    } else {
      return window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
    }
  },

  /**
   * offset - Returns offset of first element in selection
   *
   * @return {object}
   */
  offset: function offset() {
    if (!this.selection.length) {
      return this;
    }

    var box = this.selection[0].getBoundingClientRect();
    return {
      top: box.top + (pageYOffset || document.scrollTop) - (document.clientTop || 0),
      left: box.left + (pageXOffset || document.scrollLeft) - (document.clientLeft || 0)
    };
  },

  /**
   * removeAttr - Removes attribute from elements in selection
   *
   * @param	{string} attributeName Attribute name
   * @return {object}							 Self
   */
  removeAttr: function removeAttr(attributeName) {
    if (!this.selection.length) {
      return this;
    }

    this.each(function (el) {
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
  changeElementType: function changeElementType(type) {
    if (!this.selection.length) {
      return this;
    }

    this.each(function (el) {
      Mura.changeElementType(el, type);
    });
    return this;
  },

  /**
   * val - Set the value of elements in selection
   *
   * @param	{*} value Value
   * @return {Mura.DOMSelection} Self
   */
  val: function val(value) {
    if (!this.selection.length) {
      return this;
    }

    if (typeof value != 'undefined') {
      this.each(function (el) {
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
    } else if (this.selection[0].tagName == 'SELECT') {
      var val = [];

      for (var j = this.selection[0].options.length - 1; j >= 0; j--) {
        if (this.selection[0].options[j].selected) {
          val.push(this.selection[0].options[j].value);
        }
      }

      return val.join(",");
    } else {
      if (Object.prototype.hasOwnProperty.call(this.selection[0], 'value') || typeof this.selection[0].value != 'undefined') {
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
  attr: function attr(attributeName, value) {
    if (!this.selection.length) {
      return this;
    }

    if (typeof value == 'undefined' && typeof attributeName == 'undefined') {
      return Mura.getAttributes(this.selection[0]);
    } else if (_typeof(attributeName) == 'object') {
      this.each(function (el) {
        if (el.setAttribute) {
          for (var p in attributeName) {
            el.setAttribute(p, attributeName[p]);
          }
        }
      });
      return this;
    } else if (typeof value != 'undefined') {
      this.each(function (el) {
        if (el.setAttribute) {
          el.setAttribute(attributeName, value);
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
  data: function data(attributeName, value) {
    if (!this.selection.length) {
      return this;
    }

    if (typeof value == 'undefined' && typeof attributeName == 'undefined') {
      return Mura.getData(this.selection[0]);
    } else if (_typeof(attributeName) == 'object') {
      this.each(function (el) {
        for (var p in attributeName) {
          el.setAttribute("data-" + p, attributeName[p]);
        }
      });
      return this;
    } else if (typeof value != 'undefined') {
      this.each(function (el) {
        el.setAttribute("data-" + attributeName, value);
      });
      return this;
    } else if (this.selection[0] && this.selection[0].getAttribute) {
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
  prop: function prop(attributeName, value) {
    if (!this.selection.length) {
      return this;
    }

    if (typeof value == 'undefined' && typeof attributeName == 'undefined') {
      return Mura.getProps(this.selection[0]);
    } else if (_typeof(attributeName) == 'object') {
      this.each(function (el) {
        for (var p in attributeName) {
          el.setAttribute(p, attributeName[p]);
        }
      });
      return this;
    } else if (typeof value != 'undefined') {
      this.each(function (el) {
        el.setAttribute(attributeName, value);
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
  fadeOut: function fadeOut() {
    this.each(function (el) {
      el.style.opacity = 1;

      (function fade() {
        if ((el.style.opacity -= .1) < 0) {
          el.style.opacity = 0;
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
  fadeIn: function fadeIn(display) {
    this.each(function (el) {
      el.style.opacity = 0;
      el.style.display = display || "block";

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
  toggle: function toggle() {
    this.each(function (el) {
      if (typeof el.style.display == 'undefined' || el.style.display == '') {
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
  slideToggle: function slideToggle() {
    this.each(function (el) {
      if (typeof el.style.display == 'undefined' || el.style.display == '') {
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
  focus: function focus() {
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
  makeEditableAttr: function makeEditableAttr(params) {
    if (!this.selection.length) {
      return this;
    }

    var value = this.selection[0].innerHTML;
    params = params || {};

    if (!params.name) {
      return this;
    }

    params.type = params.type || "text";

    if (typeof params.required == 'undefined') {
      params.required = false;
    }

    if (typeof params.validation == 'undefined') {
      params.validation = '';
    }

    if (typeof params.message == 'undefined') {
      params.message = '';
    }

    if (typeof params.label == 'undefined') {
      params.label = params.name;
    }

    var outerClass = "mura-editable mura-inactive";
    var innerClass = "mura-inactive mura-editable-attribute";

    if (params.type == "htmlEditor") {
      outerClass += " mura-region mura-region-loose";
      innerClass += " mura-region-local";
    } else {
      outerClass += " inline";
      innerClass += " inline";
    }

    var innerClass = "mura-inactive mura-editable-attribute";
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

    var markup = '<div class="' + outerClass + '">';
    markup += '<div contenteditable="false" id="mura-editable-attribute-' + params.name + ' class="' + innerClass + '" ';
    markup += ' data-attribute="' + params.name + '" ';
    markup += ' data-type="' + params.type + '" ';
    markup += ' data-required="' + params.required + '" ';
    markup += ' data-message="' + params.message + '" ';
    markup += ' data-label="' + params.label + '"';

    if (params.type == 'htmlEditor') {
      markup += ' data-loose="true" data-perm="true" data-inited="false"';
    }

    markup += '>' + value + '</div>';
    markup += '<label class="mura-editable-label" style="display:none">' + params.label.toUpperCase() + '</label>';
    markup += '</div>';
    this.selection[0].innerHTML = markup;
    Mura.evalScripts(this.selection[0]);
    return this;
  },

  /**
  * processDisplayRegion - Renders and processes the display region data returned from Mura.renderFilename()
  *
  * @param	{any} data Region data to render
  * @return {Promise}
  */
  processDisplayRegion: function processDisplayRegion(data, label) {
    if (typeof data == 'undefined' || !this.selection.length) {
      return this.processMarkup();
    }

    this.html(Mura.buildDisplayRegion(data));

    if (label != 'undefined') {
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
  dspObject: function dspObject(data) {
    return this.appendDisplayObject(data);
  }
});

/***/ }),

/***/ 6501:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

function _typeof(obj) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (obj) { return typeof obj; } : function (obj) { return obj && "function" == typeof Symbol && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }, _typeof(obj); }

var Mura = __webpack_require__(791);
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
  init: function init(properties, requestcontext) {
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

    if (typeof this.properties.isdeleted == 'undefined') {
      this.properties.isdeleted = false;
    }

    this._requestcontext = requestcontext || Mura.getRequestContext();
    this.cachePut();
    return this;
  },

  /**
   * updateFromDom - Updates editable data from what's in the DOM.
   *
   * @return {string}
   */
  updateFromDom: function updateFromDom() {
    return this;
  },

  /**
   * setRequestContext - Sets the RequestContext
   *
   * @RequestContext	{Mura.RequestContext} Mura.RequestContext List of fields
   * @return {Mura.Feed}				Self
   */
  setRequestContext: function setRequestContext(requestcontext) {
    this._requestcontext = requestcontext;
    return this;
  },

  /**
   * getEnpoint - Returns API endpoint for entity type
   *
   * @return {string} All Headers
   */
  getAPIEndpoint: function getAPIEndpoint() {
    return this._requestcontext.getAPIEndpoint() + this.get('entityname') + '/';
  },

  /**
   * invoke - Invokes a method
   *
   * @param	{string} name Method to call
   * @param	{object} params Arguments to submit to method
   * @param	{string} method GET or POST
   * @return {any}
   */
  invoke: function invoke(name, params, method, eventHandler) {
    if (_typeof(name) == 'object') {
      params = name.params || {};
      method = name.method || 'get';
      eventHandler = name;
      name = name.name;
    } else {
      eventHandler = eventHandler || {};
    }

    Mura.normalizeRequestHandler(eventHandler);
    var self = this;

    if (typeof method == 'undefined' && typeof params == 'string') {
      method = params;
      params = {};
    }

    params = params || {};
    method = method || "post";

    if (this[name] == 'function') {
      return this[name].apply(this, params);
    }

    return new Promise(function (resolve, reject) {
      if (typeof resolve == 'function') {
        eventHandler.success = resolve;
      }

      if (typeof reject == 'function') {
        eventHandler.error = reject;
      }

      if (Mura.formdata && params instanceof FormData) {
        params.append('_cacheid', Math.random());
      } else {
        params._cacheid = Math.random();
      }

      self._requestcontext.request({
        type: method.toLowerCase(),
        url: self.getAPIEndpoint() + name,
        data: params,
        success: function success(resp) {
          if (typeof resp.error == 'undefined') {
            if (typeof eventHandler.success == 'function') {
              if (typeof resp.data != 'undefined') {
                eventHandler.success(resp.data);
              } else {
                eventHandler.success(resp);
              }
            }
          } else {
            if (typeof eventHandler.error == 'function') {
              eventHandler.error(resp);
            }
          }
        },
        error: function error(resp) {
          if (typeof eventHandler.error == 'function') {
            eventHandler.error(resp);
          }
        },
        progress: eventHandler.progress,
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
  invokeWithCSRF: function invokeWithCSRF(name, params, method, eventHandler) {
    if (_typeof(name) == 'object') {
      params = name.params || {};
      method = name.method || 'get';
      eventHandler = name;
      name = name.name;
    } else {
      eventHandler = eventHandler || {};
    }

    Mura.normalizeRequestHandler(eventHandler);

    if (self._requestcontext.getMode().toLowerCase() == 'rest') {
      return new Promise(function (resolve, reject) {
        return self.invoke(name, params, method, eventHandler).then(resolve, reject);
      });
    } else {
      var self = this;
      return new Promise(function (resolve, reject) {
        if (typeof resolve == 'function') {
          eventHandler.success = resolve;
        }

        if (typeof reject == 'function') {
          eventHandler.error = reject;
        }

        self._requestcontext.request({
          type: 'post',
          url: self._requestcontext.getAPIEndpoint() + '?method=generateCSRFTokens',
          data: {
            siteid: self.get('siteid'),
            context: name
          },
          success: function success(resp) {
            if (Mura.formdata && params instanceof FormData) {
              params.append('csrf_token', resp.data.csrf_token);
              params.append('csrf_token_expires', resp.data.csrf_token_expires);
            } else {
              params = Mura.extend(params, resp.data);
            }

            if (resp.data != 'undefined') {
              self.invoke(name, params, method, eventHandler).then(resolve, reject);
            } else {
              if (typeof eventHandler.error == 'function') {
                eventHandler.error(resp);
              }
            }
          },
          error: function error(resp) {
            if (typeof eventHandler.error == 'function') {
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
  exists: function exists() {
    return this.has('isnew') && !this.get('isnew');
  },

  /**
   * get - Retrieves property value from entity
   *
   * @param	{string} propertyName Property Name
   * @param	{*} defaultValue Default Value
   * @return {*}							Property Value
   */
  get: function get(propertyName, defaultValue) {
    if (typeof this.properties.links != 'undefined' && typeof this.properties.links[propertyName] != 'undefined') {
      var self = this;

      if (_typeof(this.properties[propertyName]) == 'object') {
        return new Promise(function (resolve, reject) {
          if ('items' in self.properties[propertyName]) {
            var returnObj = new Mura.EntityCollection(self.properties[propertyName], self._requestcontext);
          } else {
            if (Mura.entities[self.properties[propertyName].entityname]) {
              var returnObj = new Mura.entities[self.properties[propertyName].entityname](self.properties[propertyName], self._requestcontext);
            } else {
              var returnObj = new Mura.Entity(self.properties[propertyName], self._requestcontext);
            }
          }

          if (typeof resolve == 'function') {
            resolve(returnObj);
          }
        });
      } else {
        if (_typeof(defaultValue) == 'object') {
          var params = defaultValue;
        } else {
          var params = {};
        }

        return new Promise(function (resolve, reject) {
          self._requestcontext.request({
            type: 'get',
            url: self.properties.links[propertyName],
            params: params,
            success: function success(resp) {
              if ('items' in resp.data) {
                var returnObj = new Mura.EntityCollection(resp.data, self._requestcontext);
              } else {
                if (Mura.entities[self.entityname]) {
                  var returnObj = new Mura.entities[self.entityname](resp.data, self._requestcontext);
                } else {
                  var returnObj = new Mura.Entity(resp.data, self._requestcontext);
                }
              } //Dont cache if there are custom params


              if (Mura.isEmptyObject(params)) {
                self.set(propertyName, resp.data);
              }

              if (typeof resolve == 'function') {
                resolve(returnObj);
              }
            },
            error: function error(resp) {
              if (typeof reject == 'function') {
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
  set: function set(propertyName, propertyValue) {
    if (_typeof(propertyName) == 'object') {
      this.properties = Mura.deepExtend(this.properties, propertyName);
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
  has: function has(propertyName) {
    return typeof this.properties[propertyName] != 'undefined' || typeof this.properties.links != 'undefined' && typeof this.properties.links[propertyName] != 'undefined';
  },

  /**
   * getAll - Returns all of the entities properties
   *
   * @return {object}
   */
  getAll: function getAll() {
    return this.properties;
  },

  /**
   * load - Loads entity from JSON API
   *
   * @return {Promise}
   */
  load: function load() {
    return this.loadBy('id', this.get('id'));
  },

  /**
   * new - Loads properties of a new instance from JSON API
   *
   * @param	{type} params Property values that you would like your new entity to have
   * @return {Promise}
   */
  'new': function _new(params) {
    var self = this;
    return new Promise(function (resolve, reject) {
      params = Mura.extend({
        entityname: self.get('entityname'),
        method: 'findNew',
        siteid: self.get('siteid'),
        '_cacheid': Math.random()
      }, params);

      self._requestcontext.get(self._requestcontext.getAPIEndpoint(), params).then(function (resp) {
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
  'checkSchema': function checkSchema() {
    var self = this;
    return new Promise(function (resolve, reject) {
      if (self._requestcontext.getMode().toLowerCase() == 'rest') {
        self._requestcontext.request({
          type: 'post',
          url: self._requestcontext.getAPIEndpoint(),
          data: {
            entityname: self.get('entityname'),
            method: 'checkSchema',
            siteid: self.get('siteid'),
            '_cacheid': Math.random()
          },
          success: function success(resp) {
            if (resp.data != 'undefined') {
              if (typeof resolve == 'function') {
                resolve(self);
              }
            } else {
              console.log(resp);

              if (typeof reject == 'function') {
                reject(self);
              }
            }
          },
          error: function error(resp) {
            self.set('errors', resp.error);

            if (typeof reject == 'function') {
              reject(self);
            }
          }
        });
      } else {
        self._requestcontext.request({
          type: 'post',
          url: self._requestcontext.getAPIEndpoint() + '?method=generateCSRFTokens',
          data: {
            siteid: self.get('siteid'),
            context: ''
          },
          success: function success(resp) {
            self._requestcontext.request({
              type: 'post',
              url: self._requestcontext.getAPIEndpoint(),
              data: Mura.extend({
                entityname: self.get('entityname'),
                method: 'checkSchema',
                siteid: self.get('siteid'),
                '_cacheid': Math.random()
              }, {
                'csrf_token': resp.data.csrf_token,
                'csrf_token_expires': resp.data.csrf_token_expires
              }),
              success: function success(resp) {
                if (resp.data != 'undefined') {
                  if (typeof resolve == 'function') {
                    resolve(self);
                  }
                } else {
                  console.log(resp);
                  self.set('errors', resp.error);

                  if (typeof reject == 'function') {
                    reject(self);
                  }
                }
              },
              error: function error(resp) {
                this.success(resp);
              }
            });
          },
          error: function error(resp) {
            this.success(resp);
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
  'undeclareEntity': function undeclareEntity(deleteSchema) {
    deleteSchema = deleteSchema || false;
    var self = this;
    return new Promise(function (resolve, reject) {
      if (self._requestcontext.getMode().toLowerCase() == 'rest') {
        self._requestcontext.request({
          type: 'post',
          url: self._requestcontext.getAPIEndpoint(),
          data: {
            entityname: self.get('entityname'),
            deleteSchema: deleteSchema,
            method: 'undeclareEntity',
            siteid: self.get('siteid'),
            '_cacheid': Math.random()
          },
          success: function success(resp) {
            if (resp.data != 'undefined') {
              if (typeof resolve == 'function') {
                resolve(self);
              }
            } else {
              console.log(resp);
              self.set('errors', resp.error);

              if (typeof reject == 'function') {
                reject(self);
              }
            }
          },
          error: function error(resp) {
            this.success(resp);
          }
        });
      } else {
        return self._requestcontext.request({
          type: 'post',
          url: self._requestcontext.getAPIEndpoint() + '?method=generateCSRFTokens',
          data: {
            siteid: self.get('siteid'),
            context: ''
          },
          success: function success(resp) {
            self._requestcontext.request({
              type: 'post',
              url: self._requestcontext.getAPIEndpoint(),
              data: Mura.extend({
                entityname: self.get('entityname'),
                method: 'undeclareEntity',
                siteid: self.get('siteid'),
                '_cacheid': Math.random()
              }, {
                'csrf_token': resp.data.csrf_token,
                'csrf_token_expires': resp.data.csrf_token_expires
              }),
              success: function success(resp) {
                if (resp.data != 'undefined') {
                  if (typeof resolve == 'function') {
                    resolve(self);
                  }
                } else {
                  self.set('errors', resp.error);

                  if (typeof reject == 'function') {
                    reject(self);
                  }
                }
              }
            });
          },
          error: function error(resp) {
            this.success(resp);
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
  loadBy: function loadBy(propertyName, propertyValue, params) {
    propertyName = propertyName || 'id';
    propertyValue = propertyValue || this.get(propertyName) || 'null';
    var self = this;

    if (propertyName == 'id') {
      var cachedValue = Mura.datacache.get(propertyValue);

      if (typeof cachedValue != 'undefined') {
        this.set(cachedValue);
        return new Promise(function (resolve, reject) {
          resolve(self);
        });
      }
    }

    return new Promise(function (resolve, reject) {
      params = Mura.extend({
        entityname: self.get('entityname').toLowerCase(),
        method: 'findQuery',
        siteid: self.get('siteid'),
        '_cacheid': Math.random()
      }, params);

      if (params.entityname == 'content' || params.entityname == 'contentnav') {
        params.includeHomePage = 1;
        params.showNavOnly = 0;
        params.showExcludeSearch = 1;
      }

      params[propertyName] = propertyValue;

      self._requestcontext.findQuery(params).then(function (collection) {
        if (collection.get('items').length) {
          self.set(collection.get('items')[0].getAll());
        }

        if (typeof resolve == 'function') {
          resolve(self);
        }
      }, function (resp) {
        if (typeof reject == 'function') {
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
  validate: function validate(fields) {
    fields = fields || '';
    var self = this;
    var data = Mura.deepExtend({}, self.getAll());
    data.fields = fields;
    return new Promise(function (resolve, reject) {
      self._requestcontext.request({
        type: 'post',
        url: self._requestcontext.getAPIEndpoint() + '?method=validate',
        data: {
          data: JSON.stringify(data),
          validations: '{}',
          version: 4
        },
        success: function success(resp) {
          if (resp.data != 'undefined') {
            self.set('errors', resp.data);
          } else {
            self.set('errors', resp.error);
          }

          if (typeof resolve == 'function') {
            resolve(self);
          }
        },
        error: function error(resp) {
          self.set('errors', resp.error);
          resolve(self);
        }
      });
    });
  },

  /**
   * hasErrors - Returns if the entity has any errors
   *
   * @return {boolean}
   */
  hasErrors: function hasErrors() {
    var errors = this.get('errors', {});
    return typeof errors == 'string' && errors != '' || _typeof(errors) == 'object' && !Mura.isEmptyObject(errors);
  },

  /**
   * getErrors - Returns entites errors property
   *
   * @return {object}
   */
  getErrors: function getErrors() {
    return this.get('errors', {});
  },

  /**
   * save - Saves entity to JSON API
   *
   * @return {Promise}
   */
  save: function save(eventHandler) {
    eventHandler = eventHandler || {};
    Mura.normalizeRequestHandler(eventHandler);
    var self = this;

    if (!this.get('isdirty')) {
      return new Promise(function (resolve, reject) {
        if (typeof resolve == 'function') {
          eventHandler.success = resolve;
        }

        if (typeof eventHandler.success == 'function') {
          eventHandler.success(self);
        }
      });
    }

    if (!this.get('id')) {
      return new Promise(function (resolve, reject) {
        var temp = Mura.deepExtend({}, self.getAll());

        self._requestcontext.request({
          type: 'get',
          url: self._requestcontext.getAPIEndpoint() + self.get('entityname') + '/new',
          success: function success(resp) {
            self.set(resp.data);
            self.set(temp);
            self.set('id', resp.data.id);
            self.set('isdirty', true);
            self.cachePut();
            self.save(eventHandler).then(resolve, reject);
          },
          error: eventHandler.error,
          abort: eventHandler.abort
        });
      });
    } else {
      return new Promise(function (resolve, reject) {
        if (typeof resolve == 'function') {
          eventHandler.success = resolve;
        }

        if (typeof reject == 'function') {
          eventHandler.error = reject;
        }

        var context = self.get('id');

        if (self._requestcontext.getMode().toLowerCase() == 'rest') {
          self._requestcontext.request({
            type: 'post',
            url: self._requestcontext.getAPIEndpoint() + '?method=save',
            data: self.getAll(),
            success: function success(resp) {
              if (resp.data != 'undefined') {
                self.set(resp.data);
                self.set('isdirty', false);

                if (self.get('saveerrors') || Mura.isEmptyObject(self.getErrors())) {
                  if (typeof eventHandler.success == 'function') {
                    eventHandler.success(self);
                  }
                } else {
                  if (typeof eventHandler.error == 'function') {
                    eventHandler.error(self);
                  }
                }
              } else {
                self.set('errors', resp.error);

                if (typeof eventHandler.error == 'function') {
                  eventHandler.error(self);
                }
              }
            },
            error: function error(resp) {
              self.set('errors', resp.error);

              if (typeof eventHandler.error == 'function') {
                eventHandler.error(self);
              }
            },
            progress: eventHandler.progress,
            abort: eventHandler.abort
          });
        } else {
          self._requestcontext.request({
            type: 'post',
            url: self._requestcontext.getAPIEndpoint() + '?method=generateCSRFTokens',
            data: {
              siteid: self.get('siteid'),
              context: context
            },
            success: function success(resp) {
              self._requestcontext.request({
                type: 'post',
                url: self._requestcontext.getAPIEndpoint() + '?method=save',
                data: Mura.extend(self.getAll(), {
                  'csrf_token': resp.data.csrf_token,
                  'csrf_token_expires': resp.data.csrf_token_expires
                }),
                success: function success(resp) {
                  if (resp.data != 'undefined') {
                    self.set(resp.data);
                    self.set('isdirty', false);

                    if (self.get('saveerrors') || Mura.isEmptyObject(self.getErrors())) {
                      if (typeof eventHandler.success == 'function') {
                        eventHandler.success(self);
                      }
                    } else {
                      if (typeof eventHandler.error == 'function') {
                        eventHandler.error(self);
                      }
                    }
                  } else {
                    self.set('errors', resp.error);

                    if (typeof eventHandler.error == 'function') {
                      eventHandler.error(self);
                    }
                  }
                },
                error: function error(resp) {
                  self.set('errors', resp.error);

                  if (typeof eventHandler.error == 'function') {
                    eventHandler.error(self);
                  }
                },
                progress: eventHandler.progress,
                abort: eventHandler.abort
              });
            },
            error: function error(resp) {
              this.error(resp);
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
  'delete': function _delete(eventHandler) {
    eventHandler = eventHandler || {};
    Mura.normalizeRequestHandler(eventHandler);
    var self = this;

    if (self._requestcontext.getMode().toLowerCase() == 'rest') {
      return new Promise(function (resolve, reject) {
        if (typeof resolve == 'function') {
          eventHandler.success = resolve;
        }

        if (typeof reject == 'function') {
          eventHandler.error = reject;
        }

        self._requestcontext.request({
          type: 'post',
          url: self._requestcontext.getAPIEndpoint() + '?method=delete',
          data: {
            siteid: self.get('siteid'),
            id: self.get('id'),
            entityname: self.get('entityname')
          },
          success: function success() {
            self.set('isdeleted', true);
            self.cachePurge();

            if (typeof eventHandler.success == 'function') {
              eventHandler.success(self);
            }
          },
          error: eventHandler.error,
          progress: eventHandler.progress,
          abort: eventHandler.abort
        });
      });
    } else {
      return new Promise(function (resolve, reject) {
        if (typeof resolve == 'function') {
          eventHandler.success = resolve;
        }

        if (typeof reject == 'function') {
          eventHandler.error = reject;
        }

        self._requestcontext.request({
          type: 'post',
          url: self._requestcontext.getAPIEndpoint() + '?method=generateCSRFTokens',
          data: {
            siteid: self.get('siteid'),
            context: self.get('id')
          },
          success: function success(resp) {
            self._requestcontext.request({
              type: 'post',
              url: self._requestcontext.getAPIEndpoint() + '?method=delete',
              data: {
                siteid: self.get('siteid'),
                id: self.get('id'),
                entityname: self.get('entityname'),
                'csrf_token': resp.data.csrf_token,
                'csrf_token_expires': resp.data.csrf_token_expires
              },
              success: function success() {
                self.set('isdeleted', true);
                self.cachePurge();

                if (typeof eventHandler.success == 'function') {
                  eventHandler.success(self);
                }
              },
              error: eventHandler.error,
              progress: eventHandler.progress,
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
  getFeed: function getFeed() {
    return this._requestcontext.getFeed(this.get('entityName'));
  },

  /**
   * cachePurge - Purges this entity from client cache
   *
   * @return {object}	Self
   */
  cachePurge: function cachePurge() {
    Mura.datacache.purge(this.get('id'));
    return this;
  },

  /**
   * cachePut - Places this entity into client cache
   *
   * @return {object}	Self
   */
  cachePut: function cachePut() {
    if (!this.get('isnew')) {
      Mura.datacache.set(this.get('id'), this);
    }

    return this;
  }
});

/***/ }),

/***/ 2826:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var Mura = __webpack_require__(791);
/**
 * Creates a new Mura.EntityCollection
 * @name	Mura.EntityCollection
 * @class
 * @extends Mura.Entity
 * @memberof	Mura
 * @param	{object} properties Object containing values to set into object
 * @return {Mura.EntityCollection} Self
 */


Mura.EntityCollection = Mura.Entity.extend(
/** @lends Mura.EntityCollection.prototype */
{
  init: function init(properties, requestcontext) {
    properties = properties || {};
    this.set(properties);
    this._requestcontext = requestcontext || Mura._requestcontext;
    var self = this;

    if (Array.isArray(self.get('items'))) {
      self.set('items', self.get('items').map(function (obj) {
        var entityname = obj.entityname.substr(0, 1).toUpperCase() + obj.entityname.substr(1);

        if (Mura.entities[entityname]) {
          return new Mura.entities[entityname](obj, self._requestcontext);
        } else {
          return new Mura.Entity(obj, self._requestcontext);
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
  length: function length() {
    return this.properties.items.length;
  },

  /**
   * item - Return entity in collection at index
   *
   * @param	{nuymber} idx Index
   * @return {object}		 Mura.Entity
   */
  item: function item(idx) {
    return this.properties.items[idx];
  },

  /**
   * index - Returns index of item in collection
   *
   * @param	{object} item Entity instance
   * @return {number}			Index of entity
   */
  index: function index(item) {
    return this.properties.items.indexOf(item);
  },

  /**
   * indexOf - Returns index of item in collection
   *
   * @param	{object} item Entity instance
   * @return {number}			Index of entity
   */
  indexOf: function indexOf(item) {
    return this.properties.items.indexOf(item);
  },

  /**
   * getAll - Returns object with of all entities and properties
   *
   * @return {object}
   */
  getAll: function getAll() {
    var self = this;

    if (typeof self.properties.items != 'undefined') {
      return Mura.extend({}, self.properties, {
        items: self.properties.items.map(function (obj) {
          return obj.getAll();
        })
      });
    } else if (typeof self.properties.properties != 'undefined') {
      return Mura.extend({}, self.properties, {
        properties: self.properties.properties.map(function (obj) {
          return obj.getAll();
        })
      });
    }
  },

  /**
   * each - Passes each entity in collection through function
   *
   * @param	{function} fn Function
   * @return {object}	Self
   */
  each: function each(fn) {
    this.properties.items.forEach(function (item, idx) {
      if (typeof fn.call == 'undefined') {
        fn(item, idx);
      } else {
        fn.call(item, item, idx);
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
  forEach: function forEach(fn) {
    return this.each(fn);
  },

  /**
   * sort - Sorts collection
   *
   * @param	{function} fn Sorting function
   * @return {object}	 Self
   */
  sort: function sort(fn) {
    this.properties.items.sort(fn);
    return this;
  },

  /**
   * filter - Returns new Mura.EntityCollection of entities in collection that pass filter
   *
   * @param	{function} fn Filter function
   * @return {Mura.EntityCollection}
   */
  filter: function filter(fn) {
    var newProps = {};

    for (var p in this.properties) {
      if (this.properties.hasOwnProperty(p) && p != 'items' && p != 'links') {
        newProps[p] = this.properties[p];
      }
    }

    var collection = new Mura.EntityCollection(newProps, this._requestcontext);
    return collection.set('items', this.properties.items.filter(function (item, idx) {
      if (typeof fn.call == 'undefined') {
        return fn(item, idx);
      } else {
        return fn.call(item, item, idx);
      }
    }));
  },

  /**
  * map - Returns new Array returned from map function
  *
  * @param	{function} fn Filter function
  * @return {Array}
  */
  map: function map(fn) {
    return this.properties.items.map(function (item, idx) {
      if (typeof fn.call == 'undefined') {
        return fn(item, idx);
      } else {
        return fn.call(item, item, idx);
      }
    });
  },

  /**
  * reverse - Returns new Array returned from map function
  *
  * @param	{function} fn Sorting function
  * @return {object}	 collection
  */
  reverse: function reverse(fn) {
    var newProps = {};

    for (var p in this.properties) {
      if (this.properties.hasOwnProperty(p) && p != 'items' && p != 'links') {
        newProps[p] = this.properties[p];
      }
    }

    var collection = new Mura.EntityCollection(newProps, this._requestcontext);
    collection.set('items', this.properties.items.reverse());
    return collection;
  },

  /**
  * reduce - Returns value from	reduce function
  *
  * @param	{function} fn Reduce function
  * @param	{any} initialValue Starting accumulator value
  * @return {accumulator}
  */
  reduce: function reduce(fn, initialValue) {
    initialValue = initialValue || 0;
    return this.properties.items.reduce(function (accumulator, item, idx, array) {
      if (typeof fn.call == 'undefined') {
        return fn(accumulator, item, idx, array);
      } else {
        return fn.call(item, accumulator, item, idx, array);
      }
    }, initialValue);
  }
});

/***/ }),

/***/ 7847:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var _Mura$Core$extend;

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

var Mura = __webpack_require__(791);
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


Mura.Feed = Mura.Core.extend((_Mura$Core$extend = {
  init: function init(siteid, entityname, requestcontext) {
    this.queryString = entityname + '/?_cacheid=' + Math.random();
    this.propIndex = 0;
    this._requestcontext = requestcontext || Mura.getRequestContext();
    return this;
  },

  /**
   * fields - List fields to retrieve from API
   *
   * @param  {string} fields List of fields
   * @return {Mura.Feed}        Self
   */
  fields: function fields(_fields) {
    if (typeof _fields != 'undefined' && _fields) {
      this.queryString += '&fields=' + encodeURIComponent(_fields);
    }

    return this;
  },

  /**
   * setRequestContext - Sets the RequestContext
   *
   * @RequestContext  {Mura.RequestContext} Mura.RequestContext List of fields
   * @return {Mura.Feed}        Self
   */
  setRequestContext: function setRequestContext(RequestContext) {
    this._requestcontext = RequestContext;
    return this;
  },

  /**
   * contentPoolID - Sets items per page
   *
   * @param  {string} contentPoolID Items per page
   * @return {Mura.Feed}              Self
   */
  contentPoolID: function contentPoolID(_contentPoolID) {
    this.queryString += '&contentpoolid=' + encodeURIComponent(_contentPoolID);
    return this;
  },

  /**
   * name - Sets the name of the content feed to use
   *
   * @param  {string} name Name of feed as defined in admin
   * @return {Mura.Feed}              Self
   */
  name: function name(_name) {
    this.queryString += '&feedname=' + encodeURIComponent(_name);
    return this;
  },

  /**
   * cacheKey - Set unique key in cache
   *
   * @param  {string} cacheKey Unique key in cache
   * @return {Mura.Feed}              Self
   */
  cacheKey: function cacheKey(_cacheKey) {
    this.queryString += '&cacheKey=' + encodeURIComponent(_cacheKey);
    return this;
  },

  /**
   * cachedWithin - Sets maximum number of seconds to remain in cache
   *
   * @param  {number} cachedWithin Maximum number of seconds to remain in cache
   * @return {Mura.Feed}              Self
   */
  cachedWithin: function cachedWithin(_cachedWithin) {
    this.queryString += '&cachedWithin=' + encodeURIComponent(_cachedWithin);
    return this;
  },

  /**
   * purgeCache - Sets whether to purge any existing cached values
   *
   * @param  {boolean} purgeCache Whether to purge any existing cached values
   * @return {Mura.Feed}              Self
   */
  purgeCache: function purgeCache(_purgeCache) {
    this.queryString += '&purgeCache=' + encodeURIComponent(_purgeCache);
    return this;
  },

  /**
   * contentPoolID - Sets items per page
   *
   * @param  {string} feedID Items per page
   * @return {Mura.Feed}              Self
   */
  feedID: function feedID(_feedID) {
    this.queryString += '&feedid=' + encodeURIComponent(_feedID);
    return this;
  },

  /**
   * where - Optional method for starting query chain
   *
   * @param  {string} property Property name
   * @return {Mura.Feed}          Self
   */
  where: function where(property) {
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
  prop: function prop(property) {
    return this.andProp(property);
  },

  /**
   * andProp - Add new AND property value
   *
   * @param  {string} property Property name
   * @return {Mura.Feed}          Self
   */
  andProp: function andProp(property) {
    this.queryString += '&' + encodeURIComponent(property + '[' + this.propIndex + ']') + '=';
    this.propIndex++;
    return this;
  },

  /**
   * orProp - Add new OR property value
   *
   * @param  {string} property Property name
   * @return {Mura.Feed}          Self
   */
  orProp: function orProp(property) {
    this.queryString += '&or' + encodeURIComponent('[' + this.propIndex + ']') + '&';
    this.propIndex++;
    this.queryString += encodeURIComponent(property + '[' + this.propIndex + ']') + '=';
    this.propIndex++;
    return this;
  },

  /**
   * isEQ - Checks if preceding property value is EQ to criteria
   *
   * @param  {*} criteria Criteria
   * @return {Mura.Feed}          Self
   */
  isEQ: function isEQ(criteria) {
    if (typeof criteria == 'undefined' || criteria === '' || criteria == null) {
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
  isNEQ: function isNEQ(criteria) {
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
  isLT: function isLT(criteria) {
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
  isLTE: function isLTE(criteria) {
    if (typeof criteria == 'undefined' || criteria === '' || criteria == null) {
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
  isGT: function isGT(criteria) {
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
  isGTE: function isGTE(criteria) {
    if (typeof criteria == 'undefined' || criteria === '' || criteria == null) {
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
  isIn: function isIn(criteria) {
    this.queryString += encodeURIComponent('in^' + criteria);
    return this;
  },

  /**
   * isNotIn - Checks if preceding property value is NOT IN to list of criterias
   *
   * @param  {*} criteria Criteria List
   * @return {Mura.Feed}          Self
   */
  isNotIn: function isNotIn(criteria) {
    this.queryString += encodeURIComponent('notin^' + criteria);
    return this;
  },

  /**
   * containsValue - Checks if preceding property value is CONTAINS the value of criteria
   *
   * @param  {*} criteria Criteria
   * @return {Mura.Feed}          Self
   */
  containsValue: function containsValue(criteria) {
    this.queryString += encodeURIComponent('containsValue^' + criteria);
    return this;
  },
  contains: function contains(criteria) {
    this.queryString += encodeURIComponent('containsValue^' + criteria);
    return this;
  },

  /**
   * beginsWith - Checks if preceding property value BEGINS WITH criteria
   *
   * @param  {*} criteria Criteria
   * @return {Mura.Feed}          Self
   */
  beginsWith: function beginsWith(criteria) {
    this.queryString += encodeURIComponent('begins^' + criteria);
    return this;
  },

  /**
   * endsWith - Checks if preceding property value ENDS WITH criteria
   *
   * @param  {*} criteria Criteria
   * @return {Mura.Feed}          Self
   */
  endsWith: function endsWith(criteria) {
    this.queryString += encodeURIComponent('ends^' + criteria);
    return this;
  },

  /**
   * openGrouping - Start new logical condition grouping
   *
   * @return {Mura.Feed}          Self
   */
  openGrouping: function openGrouping() {
    this.queryString += '&openGrouping' + encodeURIComponent('[' + this.propIndex + ']');
    this.propIndex++;
    return this;
  },

  /**
   * openGrouping - Starts new logical condition grouping
   *
   * @return {Mura.Feed}          Self
   */
  andOpenGrouping: function andOpenGrouping() {
    this.queryString += '&andOpenGrouping' + encodeURIComponent('[' + this.propIndex + ']');
    this.propIndex++;
    return this;
  },

  /**
   * orOpenGrouping - Starts new logical condition grouping
   *
   * @return {Mura.Feed}          Self
   */
  orOpenGrouping: function orOpenGrouping() {
    this.queryString += '&orOpenGrouping' + encodeURIComponent('[' + this.propIndex + ']');
    this.propIndex++;
    return this;
  },

  /**
   * openGrouping - Closes logical condition grouping
   *
   * @return {Mura.Feed}          Self
   */
  closeGrouping: function closeGrouping() {
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
  sort: function sort(property, direction) {
    direction = direction || 'asc';

    if (direction == 'desc') {
      this.queryString += '&sort' + encodeURIComponent('[' + this.propIndex + ']') + '=' + encodeURIComponent('-' + property);
    } else {
      this.queryString += '&sort' + encodeURIComponent('[' + this.propIndex + ']') + '=' + encodeURIComponent(property);
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
  itemsPerPage: function itemsPerPage(_itemsPerPage) {
    this.queryString += '&itemsPerPage=' + encodeURIComponent(_itemsPerPage);
    return this;
  },

  /**
   * pageIndex - Sets items per page
   *
   * @param  {number} pageIndex page to start at
   */
  pageIndex: function pageIndex(_pageIndex) {
    this.queryString += '&pageIndex=' + encodeURIComponent(_pageIndex);
    return this;
  },

  /**
   * maxItems - Sets max items to return
   *
   * @param  {number} maxItems Items to return
   * @return {Mura.Feed}              Self
   */
  maxItems: function maxItems(_maxItems) {
    this.queryString += '&maxItems=' + encodeURIComponent(_maxItems);
    return this;
  },

  /**
   * distinct - Sets to select distinct values of select fields
   *
   * @param  {boolean} distinct Whether to to select distinct values
   * @return {Mura.Feed}              Self
   */
  distinct: function distinct(_distinct) {
    if (typeof _distinct == 'undefined') {
      _distinct = true;
    }

    this.queryString += '&distinct=' + encodeURIComponent(_distinct);
    return this;
  },

  /**
   * aggregate - Define aggregate values that you would like (sum,max,min,cout,avg,groupby)
   *
   * @param  {string} type Type of aggregation (sum,max,min,cout,avg,groupby)
   * @param  {string} property property
   * @return {Mura.Feed}	Self
   */
  aggregate: function aggregate(type, property) {
    if (type == 'count' && typeof property == 'undefined') {
      property = '*';
    }

    if (typeof type != 'undefined' && typeof property != 'undefined') {
      this.queryString += '&' + encodeURIComponent(type + '[' + this.propIndex + ']') + '=' + property;
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
  liveOnly: function liveOnly(_liveOnly) {
    this.queryString += '&liveOnly=' + encodeURIComponent(_liveOnly);
    return this;
  },

  /**
   * groupBy - Sets property or properties to group by
   *
   * @param  {string} groupBy
   * @return {Mura.Feed}              Self
   */
  groupBy: function groupBy(property) {
    if (typeof property != 'undefined') {
      this.queryString += '&' + encodeURIComponent('groupBy[' + this.propIndex + ']') + '=' + property;
      this.propIndex++;
    }

    return this;
  }
}, _defineProperty(_Mura$Core$extend, "maxItems", function maxItems(_maxItems2) {
  this.queryString += '&maxItems=' + encodeURIComponent(_maxItems2);
  return this;
}), _defineProperty(_Mura$Core$extend, "showNavOnly", function showNavOnly(_showNavOnly) {
  this.queryString += '&showNavOnly=' + encodeURIComponent(_showNavOnly);
  return this;
}), _defineProperty(_Mura$Core$extend, "expand", function expand(_expand) {
  if (typeof _expand == 'undefined') {
    _expand = 'all';
  }

  if (_expand) {
    this.queryString += '&expand=' + encodeURIComponent(_expand);
  }

  return this;
}), _defineProperty(_Mura$Core$extend, "expandDepth", function expandDepth(_expandDepth) {
  _expandDepth = _expandDepth || 1;

  if (Mura.isNumeric(_expandDepth) && Number(parseFloat(_expandDepth)) > 1) {
    this.queryString += '&expandDepth=' + encodeURIComponent(_expandDepth);
  }

  return this;
}), _defineProperty(_Mura$Core$extend, "findMany", function findMany(ids) {
  if (!Array.isArray(ids)) {
    ids = ids.split(",");
  }

  if (!ids.length) {
    ids = [Mura.createUUID()];
  }

  if (ids.length === 1) {
    this.andProp('id').isEQ(ids[0]);
  } else {
    this.queryString += '&id=' + encodeURIComponent(ids.join(","));
  }

  return this;
}), _defineProperty(_Mura$Core$extend, "pointInTime", function pointInTime(_pointInTime) {
  this.queryString += '&pointInTime=' + encodeURIComponent(_pointInTime);
  return this;
}), _defineProperty(_Mura$Core$extend, "showExcludeSearch", function showExcludeSearch(_showExcludeSearch) {
  this.queryString += '&showExcludeSearch=' + encodeURIComponent(_showExcludeSearch);
  return this;
}), _defineProperty(_Mura$Core$extend, "applyPermFilter", function applyPermFilter(_applyPermFilter) {
  this.queryString += '&applyPermFilter=' + encodeURIComponent(_applyPermFilter);
  return this;
}), _defineProperty(_Mura$Core$extend, "imageSizes", function imageSizes(_imageSizes) {
  this.queryString += '&imageSizes=' + encodeURIComponent(_imageSizes);
  return this;
}), _defineProperty(_Mura$Core$extend, "useCategoryIntersect", function useCategoryIntersect(_useCategoryIntersect) {
  this.queryString += '&useCategoryIntersect=' + encodeURIComponent(_useCategoryIntersect);
  return this;
}), _defineProperty(_Mura$Core$extend, "includeHomepage", function includeHomepage(_includeHomepage) {
  this.queryString += '&includehomepage=' + encodeURIComponent(_includeHomepage);
  return this;
}), _defineProperty(_Mura$Core$extend, "innerJoin", function innerJoin(relatedEntity) {
  this.queryString += '&innerJoin' + encodeURIComponent('[' + this.propIndex + ']') + '=' + encodeURIComponent(relatedEntity);
  this.propIndex++;
  return this;
}), _defineProperty(_Mura$Core$extend, "leftJoin", function leftJoin(relatedEntity) {
  this.queryString += '&leftJoin' + encodeURIComponent('[' + this.propIndex + ']') + '=' + encodeURIComponent(relatedEntity);
  this.propIndex++;
  return this;
}), _defineProperty(_Mura$Core$extend, "getIterator", function getIterator(params) {
  return this.getQuery(params);
}), _defineProperty(_Mura$Core$extend, "getQuery", function getQuery(params) {
  var self = this;

  if (typeof params != 'undefined') {
    for (var p in params) {
      if (params.hasOwnProperty(p)) {
        if (typeof self[p] == 'function') {
          self[p](params[p]);
        } else {
          self.andProp(p).isEQ(params[p]);
        }
      }
    }
  }

  return new Promise(function (resolve, reject) {
    var rcEndpoint = self._requestcontext.getAPIEndpoint();

    if (rcEndpoint.charAt(rcEndpoint.length - 1) == "/") {
      var apiEndpoint = rcEndpoint;
    } else {
      var apiEndpoint = rcEndpoint + '/';
    }

    self._requestcontext.request({
      type: 'get',
      url: apiEndpoint + self.queryString,
      success: function success(resp) {
        if (resp.data != 'undefined') {
          var returnObj = new Mura.EntityCollection(resp.data, self._requestcontext);

          if (typeof resolve == 'function') {
            resolve(returnObj);
          }
        } else if (typeof reject == 'function') {
          reject(resp);
        }
      },
      error: function error(resp) {
        if (typeof reject == 'function') {
          reject(resp);
        }
      }
    });
  });
}), _Mura$Core$extend));

/***/ }),

/***/ 7023:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

function _typeof(obj) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (obj) { return typeof obj; } : function (obj) { return obj && "function" == typeof Symbol && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }, _typeof(obj); }

var Mura = __webpack_require__(791); //https://github.com/malko/l.js

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


if (typeof window != 'undefined' && typeof window.document != 'undefined') {
  var isA = function isA(a, b) {
    return a instanceof (b || Array);
  } //-- some minifier optimisation
  ,
      D = document,
      getElementsByTagName = 'getElementsByTagName',
      length = 'length',
      readyState = 'readyState',
      onreadystatechange = 'onreadystatechange' //-- get the current script tag for further evaluation of it's eventual content
  ,
      scripts = D[getElementsByTagName]("script"),
      scriptTag = scripts[scripts[length] - 1],
      script = scriptTag.innerHTML.replace(/^\s+|\s+$/g, '');

  try {
    var preloadsupport = w.document.createElement("link").relList.supports("preload");
  } catch (e) {
    var preloadsupport = false;
  } //avoid multiple inclusion to override current loader but allow tag content evaluation


  if (!Mura.ljs) {
    var checkLoaded = scriptTag.src.match(/checkLoaded/) ? 1 : 0 //-- keep trace of header as we will make multiple access to it
    ,
        header = D[getElementsByTagName]("head")[0] || D.documentElement,
        urlParse = function urlParse(url) {
      var parts = {}; // u => url, i => id, f = fallback

      parts.u = url.replace(/#(=)?([^#]*)?/g, function (m, a, b) {
        parts[a ? 'f' : 'i'] = b;
        return '';
      });
      return parts;
    },
        appendElmt = function appendElmt(type, attrs, cb) {
      var el = D.createElement(type),
          i;

      if (type == 'script' && cb) {
        //-- this is not intended to be used for link
        if (el[readyState]) {
          el[onreadystatechange] = function () {
            if (el[readyState] === "loaded" || el[readyState] === "complete") {
              el[onreadystatechange] = null;
              cb();
            }
          };
        } else {
          el.onload = cb;
        }
      } else if (type == 'link' && _typeof(attrs) == 'object' && typeof attrs.rel != 'undefined' && attrs.rel == 'preload') {
        /*
        Inspired by
        https://github.com/filamentgroup/loadCSS/blob/master/src/loadCSS.js
        */
        var media = attrs.media || 'all';
        attrs.as = attrs.as || 'style';

        if (!preloadsupport) {
          attrs.media = 'x only';
          attrs.rel = "stylesheet";
        }

        function loadCB() {
          if (el.addEventListener) {
            el.removeEventListener("load", loadCB);
          }

          el.media = media || "all";
          el.rel = "stylesheet";
        }

        function onloadcssdefined(cb) {
          var sheets = document.styleSheets;
          var resolvedHref = attrs.href;
          var i = sheets.length;

          while (i--) {
            if (sheets[i].href === resolvedHref) {
              return cb();
            }
          }

          setTimeout(function () {
            onloadcssdefined(cb);
          });
        }

        ;

        if (el.addEventListener) {
          el.addEventListener("load", loadCB);
        }

        el.onloadcssdefined = onloadcssdefined;
        onloadcssdefined(loadCB);
      }

      for (i in attrs) {
        attrs[i] && (el[i] = attrs[i]);
      }

      header.appendChild(el); // return e; // unused at this time so drop it
    },
        _load = function load(url, cb) {
      if (this.aliases && this.aliases[url]) {
        var args = this.aliases[url].slice(0);
        isA(args) || (args = [args]);
        cb && args.push(cb);
        return this.load.apply(this, args);
      }

      if (isA(url)) {
        // parallelized request
        for (var l = url[length]; l--;) {
          this.load(url[l]);
        }

        cb && url.push(cb); // relaunch the dependancie queue

        return this.load.apply(this, url);
      }

      if (url.match(/\.css\b/)) {
        return this.loadcss(url, cb);
      } else if (url.match(/\.html\b/)) {
        return this.loadimport(url, cb);
      } else {
        return this.loadjs(url, cb);
      }
    },
        loaded = {} // will handle already loaded urls
    ,
        loader = {
      aliases: {},
      loadjs: function loadjs(url, attrs, cb) {
        if (_typeof(url) == 'object') {
          if (Array.isArray(url)) {
            return loader.load.apply(this, arguments);
          } else if (typeof attrs === 'function') {
            cb = attrs;
            attrs = {};
            url = attrs.href;
          } else if (typeof attrs == 'string' || _typeof(attrs) == 'object' && Array.isArray(attrs)) {
            return loader.load.apply(this, arguments);
          } else {
            attrs = url;
            url = attrs.href;
            cb = undefined;
          }
        } else if (typeof attrs == 'function') {
          cb = attrs;
          attrs = {};
        } else if (typeof attrs == 'string' || _typeof(attrs) == 'object' && Array.isArray(attrs)) {
          return loader.load.apply(this, arguments);
        }

        if (typeof attrs === 'undefined') {
          attrs = {};
        }

        var parts = urlParse(url);
        var partToAttrs = [['i', 'id'], ['f', 'fallback'], ['u', 'src']];

        for (var i = 0; i < partToAttrs.length; i++) {
          var part = partToAttrs[i];

          if (!(part[1] in attrs) && part[0] in parts) {
            attrs[part[1]] = parts[part[0]];
          }
        }

        if (typeof attrs.type === 'undefined') {
          attrs.type = 'text/javascript';
        }

        var finalAttrs = {};

        for (var a in attrs) {
          if (a != 'fallback') {
            finalAttrs[a] = attrs[a];
          }
        }

        finalAttrs.onerror = function (error) {
          if (attrs.fallback) {
            var c = error.currentTarget;
            c.parentNode.removeChild(c);
            finalAttrs.src = attrs.fallback;
            appendElmt('script', attrs, cb);
          }
        };

        if (loaded[finalAttrs.src] === true) {
          // already loaded exec cb if any
          cb && cb();
          return this;
        } else if (loaded[finalAttrs.src] !== undefined) {
          // already asked for loading we append callback if any else return
          if (cb) {
            loaded[finalAttrs.src] = function (ocb, cb) {
              return function () {
                ocb && ocb();
                cb && cb();
              };
            }(loaded[finalAttrs.src], cb);
          }

          return this;
        } // first time we ask this script


        loaded[finalAttrs.src] = function (cb) {
          return function () {
            loaded[finalAttrs.src] = true;
            cb && cb();
          };
        }(cb);

        cb = function cb() {
          loaded[url]();
        };

        appendElmt('script', finalAttrs, cb);
        return this;
      },
      loadcss: function loadcss(url, attrs, cb) {
        if (_typeof(url) == 'object') {
          if (Array.isArray(url)) {
            return loader.load.apply(this, arguments);
          } else if (typeof attrs === 'function') {
            cb = attrs;
            attrs = url;
            url = attrs.href;
          } else if (typeof attrs == 'string' || _typeof(attrs) == 'object' && Array.isArray(attrs)) {
            return loader.load.apply(this, arguments);
          } else {
            attrs = url;
            url = attrs.href;
            cb = undefined;
          }
        } else if (typeof attrs == 'function') {
          cb = attrs;
          attrs = {};
        } else if (typeof attrs == 'string' || _typeof(attrs) == 'object' && Array.isArray(attrs)) {
          return loader.load.apply(this, arguments);
        }

        var parts = urlParse(url);
        parts = {
          type: 'text/css',
          rel: 'stylesheet',
          href: url,
          id: parts.i
        };

        if (typeof attrs !== 'undefined') {
          for (var a in attrs) {
            parts[a] = attrs[a];
          }
        }

        loaded[parts.href] || appendElmt('link', parts);
        loaded[parts.href] = true;
        cb && cb();
        return this;
      },
      loadimport: function loadimport(url, attrs, cb) {
        if (_typeof(url) == 'object') {
          if (Array.isArray(url)) {
            return loader.load.apply(this, arguments);
          } else if (typeof attrs === 'function') {
            cb = attrs;
            attrs = url;
            url = attrs.href;
          } else if (typeof attrs == 'string' || _typeof(attrs) == 'object' && Array.isArray(attrs)) {
            return loader.load.apply(this, arguments);
          } else {
            attrs = url;
            url = attrs.href;
            cb = undefined;
          }
        } else if (typeof attrs == 'function') {
          cb = attrs;
          attrs = {};
        } else if (typeof attrs == 'string' || _typeof(attrs) == 'object' && Array.isArray(attrs)) {
          return loader.load.apply(this, arguments);
        }

        var parts = urlParse(url);
        parts = {
          rel: 'import',
          href: url,
          id: parts.i
        };

        if (typeof attrs !== 'undefined') {
          for (var a in attrs) {
            parts[a] = attrs[a];
          }
        }

        loaded[parts.href] || appendElmt('link', parts);
        loaded[parts.href] = true;
        cb && cb();
        return this;
      },
      load: function load() {
        var argv = arguments,
            argc = argv[length];

        if (argc === 1 && isA(argv[0], Function)) {
          argv[0]();
          return this;
        }

        _load.call(this, argv[0], argc <= 1 ? undefined : function () {
          loader.load.apply(loader, [].slice.call(argv, 1));
        });

        return this;
      },
      addAliases: function addAliases(aliases) {
        for (var i in aliases) {
          this.aliases[i] = isA(aliases[i]) ? aliases[i].slice(0) : aliases[i];
        }

        return this;
      }
    };

    if (checkLoaded) {
      var i, l, links, url;

      for (i = 0, l = scripts[length]; i < l; i++) {
        (url = scripts[i].getAttribute('src')) && (loaded[url.replace(/#.*$/, '')] = true);
      }

      links = D[getElementsByTagName]('link');

      for (i = 0, l = links[length]; i < l; i++) {
        (links[i].rel === 'import' || links[i].rel === 'stylesheet' || links[i].type === 'text/css') && (loaded[links[i].getAttribute('href').replace(/#.*$/, '')] = true);
      }
    } //export ljs


    Mura.ljs = loader; // eval inside tag code if any
  }

  scriptTag.src && script && appendElmt('script', {
    innerHTML: script
  });
}

/***/ }),

/***/ 7285:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var Mura = __webpack_require__(791);
/**
* Creates a new Mura.Core
* @name Mura.Core
* @class
* @memberof Mura
* @param  {object} properties Object containing values to set into object
* @return {Mura.Core}
*/


function Core() {
  this.init.apply(this, arguments);
  return this;
}
/** @lends Mura.Core.prototype */


Core.prototype = {
  init: function init() {},

  /**
   * invoke - Invokes a method
   *
   * @param  {string} funcName Method to call
   * @param  {object} params Arguments to submit to method
   * @return {any}
   */
  invoke: function invoke(funcName, params) {
    params = params || {};

    if (this[funcName] == 'function') {
      return this[funcName].apply(this, params);
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
  trigger: function trigger(eventName) {
    eventName = eventName.toLowerCase();

    if (typeof this.prototype.handlers[eventName] != 'undefined') {
      var handlers = this.prototype.handlers[eventName];

      for (var handler in handlers) {
        if (typeof handler.call == 'undefined') {
          handler(this);
        } else {
          handler.call(this, this);
        }
      }
    }

    return this;
  }
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

Core.extend = function (properties) {
  var self = this;
  return Mura.extend(Mura.extendClass(self, properties), {
    extend: self.extend,
    handlers: []
  });
};

Mura.Core = Core;

/***/ }),

/***/ 3902:
/***/ (function(__unused_webpack_module, exports) {

if (typeof window != 'undefined' && typeof window.document != 'undefined') {
  window.Element && function (ElementPrototype) {
    ElementPrototype.matchesSelector = ElementPrototype.matchesSelector || ElementPrototype.mozMatchesSelector || ElementPrototype.msMatchesSelector || ElementPrototype.oMatchesSelector || ElementPrototype.webkitMatchesSelector || function (selector) {
      var node = this,
          nodes = (node.parentNode || node.document).querySelectorAll(selector),
          i = -1;

      while (nodes[++i] && nodes[i] != node) {
        ;
      }

      return !!nodes[i];
    };
  }(Element.prototype); //https://github.com/filamentgroup/loadCSS/blob/master/src/cssrelpreload.js

  /*! loadCSS. [c]2017 Filament Group, Inc. MIT License */

  /* This file is meant as a standalone workflow for
  - testing support for link[rel=preload]
  - enabling async CSS loading in browsers that do not support rel=preload
  - applying rel preload css once loaded, whether supported or not.
  */

  (function (w) {
    "use strict"; // rel=preload support test

    if (!w.loadCSS) {
      w.loadCSS = function () {};
    } // define on the loadCSS obj


    var rp = loadCSS.relpreload = {}; // rel=preload feature support test
    // runs once and returns a function for compat purposes

    rp.support = function () {
      var ret;

      try {
        ret = w.document.createElement("link").relList.supports("preload");
      } catch (e) {
        ret = false;
      }

      return function () {
        return ret;
      };
    }(); // if preload isn't supported, get an asynchronous load by using a non-matching media attribute
    // then change that media back to its intended value on load


    rp.bindMediaToggle = function (link) {
      // remember existing media attr for ultimate state, or default to 'all'
      var finalMedia = link.media || "all";

      function enableStylesheet() {
        link.media = finalMedia;
      } // bind load handlers to enable media


      if (link.addEventListener) {
        link.addEventListener("load", enableStylesheet);
      } else if (link.attachEvent) {
        link.attachEvent("onload", enableStylesheet);
      } // Set rel and non-applicable media type to start an async request
      // note: timeout allows this to happen async to let rendering continue in IE


      setTimeout(function () {
        link.rel = "stylesheet";
        link.media = "only x";
      }); // also enable media after 3 seconds,
      // which will catch very old browsers (android 2.x, old firefox) that don't support onload on link

      setTimeout(enableStylesheet, 3000);
    }; // loop through link elements in DOM


    rp.poly = function () {
      // double check this to prevent external calls from running
      if (rp.support()) {
        return;
      }

      var links = w.document.getElementsByTagName("link");

      for (var i = 0; i < links.length; i++) {
        var link = links[i]; // qualify links to those with rel=preload and as=style attrs

        if (link.rel === "preload" && link.getAttribute("as") === "style" && !link.getAttribute("data-loadcss")) {
          // prevent rerunning on link
          link.setAttribute("data-loadcss", true); // bind listeners to toggle media back

          rp.bindMediaToggle(link);
        }
      }
    }; // if unsupported, run the polyfill


    if (!rp.support()) {
      // run once at least
      rp.poly(); // rerun poly on an interval until onload

      var run = w.setInterval(rp.poly, 500);

      if (w.addEventListener) {
        w.addEventListener("load", function () {
          rp.poly();
          w.clearInterval(run);
        });
      } else if (w.attachEvent) {
        w.attachEvent("onload", function () {
          rp.poly();
          w.clearInterval(run);
        });
      }
    } // commonjs


    if (true) {
      exports.loadCSS = loadCSS;
    } else {}
  })(window); //https://stackoverflow.com/questions/44091567/how-to-cover-a-div-with-an-img-tag-like-background-image-does


  if ('objectFit' in document.documentElement.style === false) {
    document.addEventListener('DOMContentLoaded', function () {
      Array.prototype.forEach.call(document.querySelectorAll('img[data-object-fit]'), function (image) {
        (image.runtimeStyle || image.style).background = 'url("' + image.src + '") no-repeat 50%/' + (image.currentStyle ? image.currentStyle['object-fit'] : image.getAttribute('data-object-fit'));
        image.src = 'data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'' + image.width + '\' height=\'' + image.height + '\'%3E%3C/svg%3E';
      });
    });
  }
}

/***/ }),

/***/ 4980:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

function _typeof(obj) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (obj) { return typeof obj; } : function (obj) { return obj && "function" == typeof Symbol && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }, _typeof(obj); }

var Mura = __webpack_require__(791);
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


Mura.RequestContext = Mura.Core.extend(
/** @lends Mura.RequestContext.prototype */
{
  init: function init(request, response, headers, siteid, endpoint, mode) {
    //Logic aded to support single config object arg
    if (_typeof(request) === 'object' && _typeof(request.req) === 'object' && typeof response === 'undefined') {
      var config = request;
      request = config.req;
      response = config.res;
      headers = config.headers;
      siteid = config.siteid;
      endpoint = config.endpoint;
      mode = config.mode;
    } else {
      if (typeof headers == 'string') {
        var originalSiteid = siteid;
        siteid = headers;

        if (_typeof(originalSiteid) === 'object') {
          headers = originalSiteid;
        } else {
          headers = {};
        }
      }
    }

    this.siteid = siteid || Mura.siteid;
    this.apiEndpoint = endpoint || Mura.getAPIEndpoint();
    this.mode = mode || Mura.getMode();
    this.requestObject = request;
    this.responseObject = response;
    this._request = new Mura.Request(request, response, headers);

    if (this.mode == 'rest') {
      this.apiEndpoint = this.apiEndpoint.replace('/json/', '/rest/');
    }

    return this;
  },

  /**
   * setRequestHeader - Initialiazes feed
   *
   * @param	{string} headerName	Name of header
   * @param	{string} value Header value
   * @return {Mura.RequestContext}	Self
   */
  setRequestHeader: function setRequestHeader(headerName, value) {
    this._request.setRequestHeader(headerName, value);

    return this;
  },

  /**
   * getRequestHeader - Returns a request header value
   *
   * @param	{string} headerName	Name of header
   * @return {string} header Value
   */
  getRequestHeader: function getRequestHeader(headerName) {
    return this._request.getRequestHeader(headerName);
  },

  /**
   * getAPIEndpoint() - Returns api endpoint
   *
   * @return {object} All Headers
   */
  getAPIEndpoint: function getAPIEndpoint() {
    return this.apiEndpoint;
  },

  /**
   * getMode() - Returns context's mode
   *
   * @return {object} All Headers
   */
  getMode: function getMode() {
    return this.mode;
  },

  /**
   * getRequestHeaders - Returns a request header value
   *
   * @return {object} All Headers
   */
  getRequestHeaders: function getRequestHeaders() {
    return this._request.getRequestHeaders();
  },

  /**
   * request - Executes a request
   *
   * @param	{object} params		 Object
   * @return {Promise}						Self
   */
  request: function request(params) {
    return this._request.execute(params);
  },

  /**
   * renderFilename - Returns "Rendered" JSON object of content
   *
   * @param	{type} filename Mura content filename
   * @param	{type} params Object
   * @return {Promise}
   */
  renderFilename: function renderFilename(filename, params) {
    var query = [];
    var self = this;
    params = params || {};
    params.filename = params.filename || '';
    params.siteid = params.siteid || this.siteid;

    for (var key in params) {
      if (key != 'entityname' && key != 'filename' && key != 'siteid' && key != 'method') {
        query.push(encodeURIComponent(key) + '=' + encodeURIComponent(params[key]));
      }
    }

    return new Promise(function (resolve, reject) {
      self.request({
        async: true,
        type: 'get',
        url: self.apiEndpoint + '/content/_path/' + filename + '?' + query.join('&'),
        success: function success(resp) {
          if (resp != null && typeof location != 'undefined' && typeof resp.data != 'undefined' && typeof resp.data.redirect != 'undefined' && typeof resp.data.contentid == 'undefined') {
            if (resp.data.redirect && resp.data.redirect != location.href) {
              location.href = resp.data.redirect;
            } else {
              location.reload(true);
            }
          } else {
            var item = new Mura.entities.Content({}, self);
            item.set(resp.data);
            resolve(item);
          }
        },
        error: function error(resp) {
          if (resp != null && typeof resp.data != 'undefined' && typeof resp.data != 'undefined' && typeof resolve == 'function') {
            var item = new Mura.entities.Content({}, self);
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
   * findText - Returns content associated with text
   *
   * @param	{type} text
   * @param	{type} params Object
   * @return {Promise}
   */
  findText: function findText(text, params) {
    var self = this;
    params = params || {};
    params.text = text || params.text || '';
    params.siteid = params.siteid || this.siteid;
    params.method = "findtext";
    return new Promise(function (resolve, reject) {
      self.request({
        type: 'get',
        url: self.apiEndpoint,
        data: params,
        success: function success(resp) {
          var collection = new Mura.EntityCollection(resp.data, self);

          if (typeof resolve == 'function') {
            resolve(collection);
          }
        },
        error: function error(resp) {
          console.log(resp);
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
  getEntity: function getEntity(entityname, siteid) {
    if (typeof entityname == 'string') {
      var properties = {
        entityname: entityname.substr(0, 1).toUpperCase() + entityname.substr(1)
      };
      properties.siteid = siteid || this.siteid;
    } else {
      properties = entityname;
      properties.entityname = properties.entityname || 'Content';
      properties.siteid = properties.siteid || this.siteid;
    }

    properties.links = {
      permissions: this.apiEndpoint + properties.entityname + "/permissions"
    };

    if (Mura.entities[properties.entityname]) {
      var entity = new Mura.entities[properties.entityname](properties, this);
      return entity;
    } else {
      var entity = new Mura.Entity(properties, this);
      return entity;
    }
  },

  /**
   * getBean - Returns Mura.Entity instance
   *
   * @param	{string} entityname Entity Name
   * @param	{string} siteid		 Siteid
   * @return {Mura.Entity}
   */
  getBean: function getBean(entityname, siteid) {
    return this.getEntity(entityname, siteid);
  },

  /**
   * declareEntity - Declare Entity with in service factory
   *
   * @param	{object} entityConfig Entity config object
   * @return {Promise}
   */
  declareEntity: function declareEntity(entityConfig) {
    var self = this;

    if (this.getMode().toLowerCase() == 'rest') {
      return new Promise(function (resolve, reject) {
        self.request({
          async: true,
          type: 'POST',
          url: self.apiEndpoint,
          data: {
            method: 'declareEntity',
            entityConfig: encodeURIComponent(JSON.stringify(entityConfig))
          },
          success: function success(resp) {
            if (typeof resolve == 'function' && resp != null && typeof resp.data != 'undefined') {
              resolve(resp.data);
            } else if (typeof reject == 'function' && resp != null && typeof resp.error != 'undefined') {
              resolve(resp);
            } else if (typeof resolve == 'function') {
              resolve(resp);
            }
          }
        });
      });
    } else {
      return new Promise(function (resolve, reject) {
        self.request({
          type: 'POST',
          url: self.apiEndpoint + '?method=generateCSRFTokens',
          data: {
            context: ''
          },
          success: function success(resp) {
            self.request({
              async: true,
              type: 'POST',
              url: self.apiEndpoint,
              data: {
                method: 'declareEntity',
                entityConfig: encodeURIComponent(JSON.stringify(entityConfig)),
                'csrf_token': resp.data.csrf_token,
                'csrf_token_expires': resp.data.csrf_token_expires
              },
              success: function success(resp) {
                if (typeof resolve == 'function' && resp != null && typeof resp.data != 'undefined') {
                  resolve(resp.data);
                } else if (typeof reject == 'function' && resp != null && typeof resp.error != 'undefined') {
                  resolve(resp);
                } else if (typeof resolve == 'function') {
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
  undeclareEntity: function undeclareEntity(entityName, deleteSchema) {
    var self = this;
    deleteSchema = deleteSchema || false;

    if (this.getMode().toLowerCase() == 'rest') {
      return new Promise(function (resolve, reject) {
        self.request({
          async: true,
          type: 'POST',
          url: self.apiEndpoint,
          data: {
            method: 'undeclareEntity',
            entityName: entityName,
            deleteSchema: deleteSchema
          },
          success: function success(resp) {
            if (typeof resolve == 'function' && resp != null && typeof resp.data != 'undefined') {
              resolve(resp.data);
            } else if (typeof reject == 'function' && resp != null && typeof resp.error != 'undefined') {
              resolve(resp);
            } else if (typeof resolve == 'function') {
              resolve(resp);
            }
          }
        });
      });
    } else {
      return new Promise(function (resolve, reject) {
        self.request({
          type: 'POST',
          url: self.apiEndpoint + '?method=generateCSRFTokens',
          data: {
            context: ''
          },
          success: function success(resp) {
            self.request({
              async: true,
              type: 'POST',
              url: self.apiEndpoint,
              data: {
                method: 'undeclareEntity',
                entityName: entityName,
                deleteSchema: deleteSchema,
                'csrf_token': resp.data.csrf_token,
                'csrf_token_expires': resp.data.csrf_token_expires
              },
              success: function success(resp) {
                if (typeof resolve == 'function' && resp != null && typeof resp.data != 'undefined') {
                  resolve(resp.data);
                } else if (typeof reject == 'function' && resp != null && typeof resp.error != 'undefined') {
                  resolve(resp);
                } else if (typeof resolve == 'function') {
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
  getFeed: function getFeed(entityname, siteid) {
    Mura.feeds = Mura.feeds || {};
    siteid = siteid || this.siteid;

    if (typeof entityname === 'string') {
      entityname = entityname.substr(0, 1).toUpperCase() + entityname.substr(1);

      if (Mura.feeds[entityname]) {
        var feed = new Mura.feeds[entityname](siteid, entityname, this);
        return feed;
      }
    }

    var feed = new Mura.Feed(siteid, entityname, this);
    return feed;
  },

  /**
   * getCurrentUser - Return Mura.Entity for current user
   *
   * @param	{object} params Load parameters, fields:listoffields
   * @return {Promise}
   */
  getCurrentUser: function getCurrentUser(params) {
    var self = this;
    params = params || {};
    params.fields = params.fields || '';
    return new Promise(function (resolve, reject) {
      if (Mura.currentUser) {
        resolve(Mura.currentUser);
      } else {
        self.request({
          async: true,
          type: 'get',
          url: self.apiEndpoint + 'findCurrentUser?fields=' + params.fields + '&_cacheid=' + Math.random(),
          success: function success(resp) {
            if (typeof resolve == 'function') {
              Mura.currentUser = self.getEntity('user');
              Mura.currentUser.set(resp.data);
              resolve(Mura.currentUser);
            }
          },
          error: function error(resp) {
            if (typeof resolve == 'function') {
              Mura.currentUser = self.getEntity('user');
              Mura.currentUser.set(resp.data);
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
  findQuery: function findQuery(params) {
    var self = this;
    params = params || {};
    params.entityname = params.entityname || 'content';
    params.siteid = params.siteid || this.siteid;
    params.method = params.method || 'findQuery';
    params['_cacheid'] == Math.random();
    return new Promise(function (resolve, reject) {
      self.request({
        type: 'get',
        url: self.apiEndpoint,
        data: params,
        success: function success(resp) {
          var collection = new Mura.EntityCollection(resp.data, self);

          if (typeof resolve == 'function') {
            resolve(collection);
          }
        },
        error: function error(resp) {
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
  login: function login(username, password, siteid) {
    siteid = siteid || this.siteid;
    var self = this;
    return new Promise(function (resolve, reject) {
      self.request({
        type: 'post',
        url: self.apiEndpoint + '?method=generateCSRFTokens',
        data: {
          siteid: siteid,
          context: 'login'
        },
        success: function success(resp) {
          self.request({
            async: true,
            type: 'post',
            url: self.apiEndpoint,
            data: {
              siteid: siteid,
              username: username,
              password: password,
              method: 'login',
              'csrf_token': resp.data.csrf_token,
              'csrf_token_expires': resp.data.csrf_token_expires
            },
            success: function success(resp) {
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
  openGate: function openGate(contentid) {
    var self = this;
    contentid = contentid || Mura.contentid;

    if (contentid) {
      if (this.getMode().toLowerCase() == 'rest') {
        return new Promise(function (resolve, reject) {
          self.request({
            async: true,
            type: 'POST',
            url: self.apiEndpoint + '/gatedasset/open',
            data: {
              contentid: contentid
            },
            success: function success(resp) {
              if (typeof resolve == 'function' && typeof resp.data != 'undefined') {
                resolve(resp.data);
              } else if (typeof reject == 'function' && typeof resp.error != 'undefined') {
                resolve(resp);
              } else if (typeof resolve == 'function') {
                resolve(resp);
              }
            }
          });
        });
      } else {
        return new Promise(function (resolve, reject) {
          self.request({
            type: 'POST',
            url: self.apiEndpoint + '?method=generateCSRFTokens',
            data: {
              context: contentid
            },
            success: function success(resp) {
              self.request({
                async: true,
                type: 'POST',
                url: self.apiEndpoint + '/gatedasset/open',
                data: {
                  contentid: contentid
                },
                success: function success(resp) {
                  if (typeof resolve == 'function' && typeof resp.data != 'undefined') {
                    resolve(resp.data);
                  } else if (typeof reject == 'function' && typeof resp.error != 'undefined') {
                    resolve(resp);
                  } else if (typeof resolve == 'function') {
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
  logout: function logout(siteid) {
    siteid = siteid || this.siteid;
    var self = this;
    return new Promise(function (resolve, reject) {
      self.request({
        async: true,
        type: 'post',
        url: self.apiEndpoint,
        data: {
          siteid: siteid,
          method: 'logout'
        },
        success: function success(resp) {
          resolve(resp.data);
        }
      });
    });
  },

  /**
   * normalizeRequest - I normalize protocol requests
   *
   * @param	{url} url	URL
   * @param	{object} data Data to send to url
   * @return {Promise}
   */
  normalizeRequest: function normalizeRequest(type, url, data, config) {
    if (_typeof(url) == 'object') {
      data = url.data;
      config = url;
      url = url.url;
    } else {
      config = config || {};
    }

    Mura.normalizeRequestHandler(config);
    var self = this;
    data = data || {};
    return new Promise(function (resolve, reject) {
      if (typeof resolve == 'function') {
        config.success = resolve;
      }

      if (typeof reject == 'function') {
        config.error = reject;
      }

      var normalizedConfig = Mura.extend({
        type: type,
        url: url,
        data: data
      }, config);
      return self.request(normalizedConfig);
    });
  },

  /**
   * get - Make GET request
   *
   * @param	{url} url	URL
   * @param	{object} data Data to send to url
   * @return {Promise}
   */
  get: function get(url, data, config) {
    return this.normalizeRequest('get', url, data, config);
  },

  /**
   * post - Make POST request
   *
   * @param	{url} url	URL
   * @param	{object} data Data to send to url
   * @return {Promise}
   */
  post: function post(url, data, config) {
    return this.normalizeRequest('post', url, data, config);
  },

  /**
   * put - Make PUT request
   *
   * @param	{url} url	URL
   * @param	{object} data Data to send to url
   * @return {Promise}
   */
  put: function put(url, data, config) {
    return this.normalizeRequest('put', url, data, config);
  },

  /**
   * update - Make UPDATE request
   *
   * @param	{url} url	URL
   * @param	{object} data Data to send to url
   * @return {Promise}
   */
  patch: function patch(url, data, config) {
    return this.normalizeRequest('patch', url, data, config);
  },

  /**
   * delete - Make DELETE request
   *
   * @param	{url} url	URL
   * @param	{object} data Data to send to url
   * @return {Promise}
   */
  delete: function _delete(url, data, config) {
    return this.normalizeRequest('delete', url, data, config);
  },

  /**
   * Request Headers
  **/
  requestHeaders: {}
});

/***/ }),

/***/ 9058:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

function _typeof(obj) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (obj) { return typeof obj; } : function (obj) { return obj && "function" == typeof Symbol && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }, _typeof(obj); }

var Mura = __webpack_require__(791);
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


Mura.Request = Mura.Core.extend(
/** @lends Mura.Request.prototype */
{
  init: function init(request, response, headers) {
    this.requestObject = request;
    this.responseObject = response;
    this.requestHeaders = headers || {};
    this.inNode = typeof XMLHttpRequest === 'undefined';
    return this;
  },

  /**
  * execute - Make ajax request
  *
  * @param	{object} config
  * @return {Promise}
  */
  execute: function execute(config) {
    if (!('type' in config)) {
      config.type = 'GET';
    }

    if (!('data' in config)) {
      config.data = {};
    }

    if (!('headers' in config)) {
      config.headers = {};
    }

    if ('method' in config) {
      config.type = config.method;
    }

    if (!('dataType' in config)) {
      config.dataType = 'default';
    }

    Mura.normalizeRequestHandler(config);
    config.type = config.type.toLowerCase();

    try {
      //if is in node not a FormData obj
      if (this.inNode || !(config.data instanceof FormData)) {
        if (config.type === 'get' && !(typeof config.url === 'string' && config.url.toLowerCase().indexOf('purgecache') > -1) && typeof config.data.purgeCache === 'undefined' && typeof config.data.purgecache === 'undefined') {
          var sourceParams = {};

          if (!this.inNode && typeof location != 'undefined' && location.search) {
            sourceParams = Mura.getQueryStringParams(location.search);
          } else if (typeof this.requestObject != 'undefined' && typeof this.requestObject.url === 'string' && this.requestObject.url) {
            var qa = this.requestObject.url.split("?");

            if (qa.length) {
              var qs = qa[qa.length - 1] || '';
              qs = qs.toString();
              sourceParams = Mura.getQueryStringParams(qs);
            }
          }

          if (typeof sourceParams.purgeCache != 'undefined') {
            config.data.purgeCache = sourceParams.purgeCache;
          } else if (typeof sourceParams.purgecache != 'undefined') {
            config.data.purgecache = sourceParams.purgecache;
          }
        }
      }
    } catch (e) {
      console.log(e);
    }

    if (typeof config.data.httpmethod != 'undefined') {
      config.type = config.data.httpmethod;
      delete config.data.httpmethod;
    }

    if (this.inNode) {
      this.nodeRequest(config);
    } else {
      this.xhrRequest(config);
    }
  },

  /**
   * setRequestHeader - Initialiazes feed
   *
   * @param	{string} headerName	Name of header
   * @param	{string} value Header value
   * @return {Mura.RequestContext}						Self
   */
  setRequestHeader: function setRequestHeader(headerName, value) {
    headerName = headerName.toLowerCase();
    this.requestHeaders[headerName] = value;
    return this;
  },

  /**
   * getRequestHeader - Returns a request header value
   *
   * @param	{string} headerName	Name of header
   * @return {string} header Value
   */
  getRequestHeader: function getRequestHeader(headerName) {
    headerName = headerName.toLowerCase();

    if (typeof this.requestHeaders[headerName] != 'undefined') {
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
  getRequestHeaders: function getRequestHeaders() {
    return this.requestHeaders;
  },
  nodeRequest: function nodeRequest(config) {
    var _this = this;

    if (typeof Mura.renderMode != 'undefined') {
      config.renderMode = Mura.renderMode;
    }

    var self = this;

    if (typeof this.requestObject != 'undefined') {
      ['Cookie', 'X-Client_id', 'X-Client_secret', 'X-Access_token', 'Access_Token', 'Authorization', 'User-Agent', 'Referer', 'X-Forwarded-For', 'X-Forwarded-Host', 'X-Forwarded-Proto'].forEach(function (item) {
        if (typeof _this.requestObject.headers[item] != 'undefined') {
          config.headers[item.toLowerCase()] = _this.requestObject.headers[item];
        } else {
          var lcaseItem = item.toLowerCase();

          if (typeof _this.requestObject.headers[lcaseItem] != 'undefined') {
            config.headers[lcaseItem] = _this.requestObject.headers[lcaseItem];
          }
        }
      });
    }

    var h;

    for (h in Mura.requestHeaders) {
      if (Mura.requestHeaders.hasOwnProperty(h)) {
        config.headers[h.toLowerCase()] = config.requestHeaders[h];
      }
    }

    for (h in this.requestHeaders) {
      if (this.requestHeaders.hasOwnProperty(h)) {
        config.headers[h.toLowerCase()] = this.requestHeaders[h];
      }
    } //console.log('pre:',config.headers)


    var nodeProxyHeaders = function nodeProxyHeaders(response) {
      if (typeof self.responseObject != 'undefined') {
        self.responseObject.proxiedResponse = response;

        if (!self.responseObject.headersSent) {
          if (response.statusCode > 300 && response.status < 400) {
            var _header = response.headers['location'];

            if (_header) {
              try {
                //match casing of mura-next connector
                self.responseObject.setHeader('location', _header);
                self.responseObject.statusCode = httpResponse.statusCode;
              } catch (e) {
                console.log('Error setting location header');
              }
            }
          }

          var header = '';
          header = response.headers['cache-control'];

          if (header) {
            try {
              //match casing of mura-next connector
              self.responseObject.setHeader('cache-control', header);
            } catch (e) {
              console.log(e);
              console.log('Error setting Cache-Control header');
            }
          }

          header = response.headers['pragma'];

          if (header) {
            try {
              //match casing of mura-next connector
              self.responseObject.setHeader('pragma', header);
            } catch (e) {
              console.log('Error setting Pragma header');
            }
          }
        }
      }
    };

    var nodeProxyCookies = function nodeProxyCookies(response) {
      var debug = typeof Mura.debug != 'undefined' && Mura.debug;

      if (typeof self.responseObject != 'undefined') {
        var existingCookies = typeof self.requestObject.headers['cookie'] != 'undefined' ? self.requestObject.headers['cookie'] : '';
        var newSetCookies = response.headers['set-cookie'];

        if (Array.isArray(existingCookies)) {
          if (existingCookies.length) {
            existingCookies = existingCookies[0];
          } else {
            existingCookies = '';
          }
        }

        existingCookies = existingCookies.split("; ");

        if (!Array.isArray(newSetCookies)) {
          newSetCookies = [];
        }

        if (debug) {
          console.log('response cookies:');
          console.log(newSetCookies);
        }

        try {
          self.responseObject.setHeader('set-cookie', newSetCookies);
        } catch (e) {//console.log('Header already sent');
        }

        var cookieMap = {};
        var setMap = {};
        var c;
        var tempCookie; // pull out existing cookies

        if (existingCookies.length) {
          for (c in existingCookies) {
            tempCookie = existingCookies[c];

            if (typeof tempCookie != 'undefined') {
              tempCookie = existingCookies[c].split(" ")[0].split("=");

              if (tempCookie.length > 1) {
                cookieMap[tempCookie[0]] = tempCookie[1].split(';')[0];
              }
            }
          }
        }

        if (debug) {
          console.log('existing 1:');
          console.log(cookieMap);
        } // pull out new cookies


        if (newSetCookies.length) {
          for (c in newSetCookies) {
            tempCookie = newSetCookies[c];

            if (typeof tempCookie != 'undefined') {
              tempCookie = tempCookie.split(" ")[0].split("=");

              if (tempCookie.length > 1) {
                cookieMap[tempCookie[0]] = tempCookie[1].split(';')[0];
              }
            }
          }
        }

        if (debug) {
          console.log('existing 2:');
          console.log(cookieMap);
        }

        var cookie = ''; // put cookies back in in the same order that they came out

        if (existingCookies.length) {
          for (c in existingCookies) {
            tempCookie = existingCookies[c];

            if (typeof tempCookie != 'undefined') {
              tempCookie = tempCookie.split(" ")[0].split("=");

              if (tempCookie.length > 1) {
                if (cookie != '') {
                  cookie = cookie + "; ";
                }

                setMap[tempCookie[0]] = true;
                cookie = cookie + tempCookie[0] + "=" + cookieMap[tempCookie[0]];
              }
            }
          }
        }

        if (newSetCookies.length) {
          for (c in newSetCookies) {
            tempCookie = newSetCookies[c];

            if (typeof tempCookie != 'undefined') {
              tempCookie = tempCookie.split(" ")[0].split("=");

              if (typeof setMap[tempCookie[0]] == 'undefined' && tempCookie.length > 1) {
                if (cookie != '') {
                  cookie = cookie + "; ";
                }

                setMap[tempCookie[0]] = true;
                cookie = cookie + tempCookie[0] + "=" + cookieMap[tempCookie[0]];
              }
            }
          }
        }

        self.requestObject.headers['cookie'] = cookie;

        if (debug) {
          console.log('merged cookies:');
          console.log(self.requestObject.headers['cookie']);
        }
      }
    };

    (__webpack_require__(9669)["default"].request)(this.MuraToAxiosConfig(config)).then(function (response) {
      nodeProxyCookies(response);
      nodeProxyHeaders(response);
      config.success(response.data);
    }).catch(function (error) {
      console.log(error);

      if (error.response) {
        nodeProxyCookies(error.response);
        nodeProxyHeaders(error.response);
        config.error(error.response.data);
      } else {
        config.error(error);
      }
    });
  },
  xhrRequest: function xhrRequest(config) {
    var h;

    for (h in Mura.requestHeaders) {
      if (Mura.requestHeaders.hasOwnProperty(h)) {
        config.headers[h.toLowerCase()] = Mura.requestHeaders[h];
      }
    }

    for (h in this.requestHeaders) {
      if (this.requestHeaders.hasOwnProperty(h)) {
        config.headers[h.toLowerCase()] = this.requestHeaders[h];
      }
    }

    (__webpack_require__(9669)["default"].request)(this.MuraToAxiosConfig(config)).then(function (response) {
      config.success(response.data);
    }, function (error) {
      console.log(error);

      if (error.response) {
        config.error(error.response.data);
      } else {
        config.error(error);
      }
    });
  },
  serializeParams: function serializeParams(params) {
    var query = [];

    for (var key in params) {
      if (params.hasOwnProperty(key)) {
        query.push(encodeURIComponent(key) + '=' + encodeURIComponent(params[key]));
      }
    }

    return query.join('&');
  },
  MuraToAxiosConfig: function MuraToAxiosConfig(config) {
    var parsedConfig = {
      responseType: 'text',
      method: config.type,
      headers: config.headers,
      url: config.url,
      onUploadProgress: config.progress,
      onDownloadProgress: config.download,
      withCredentials: true,
      paramsSerializer: this.serializeParams
    };
    var sendJSON = parsedConfig.headers['content-type'] && parsedConfig.headers['content-type'].indexOf('json') > -1;
    var sendFormData = !this.inNode && config.data instanceof FormData;

    if (parsedConfig.method == 'get') {
      //GET send params and not data
      parsedConfig.params = Mura.deepExtend({}, config.data);

      if (typeof parsedConfig.params['muraPointInTime'] == 'undefined' && typeof Mura.pointInTime != 'undefined') {
        parsedConfig.params['muraPointInTime'] = Mura.pointInTime;
      }
    } else {
      if (sendJSON) {
        parsedConfig.data = Object.assign({}, config.data);
      } else {
        if (sendFormData) {
          parsedConfig.data = config.data;
        } else {
          parsedConfig.data = Mura.deepExtend({}, config.data);

          if (typeof parsedConfig.data['muraPointInTime'] == 'undefined' && typeof Mura.pointInTime != 'undefined') {
            parsedConfig.data['muraPointInTime'] = Mura.pointInTime;
          }
        }

        if (sendFormData) {
          parsedConfig.headers['content-type'] = 'multipart/form-data; charset=UTF-8';
        } else {
          parsedConfig.headers['content-type'] = 'application/x-www-form-urlencoded; charset=UTF-8';
          parsedConfig.data = Object.assign({}, config.data);

          for (var p in parsedConfig.data) {
            if (_typeof(parsedConfig.data[p]) == 'object') {
              parsedConfig.data[p] = JSON.stringify(parsedConfig.data[p]);
            }
          }

          if (typeof parsedConfig.data['muraPointInTime'] == 'undefined' && typeof Mura.pointInTime != 'undefined') {
            parsedConfig.data['muraPointInTime'] = Mura.pointInTime;
          }

          parsedConfig.data = this.serializeParams(parsedConfig.data);
        }
      }
    }

    return parsedConfig;
  }
});

/***/ }),

/***/ 1526:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var Mura = __webpack_require__(791);

if (typeof document != 'undefined' && typeof Mura.styleMap == 'undefined') {
  var tocss = {};
  var CSSStyleDeclaration = document.createElement('div').style;
  var fromArray;
  var toArray;
  var hasError = false;

  for (var s in CSSStyleDeclaration) {
    fromArray = s.split(/(?=[A-Z])/);
    toArray = [];

    for (var i in fromArray) {
      try {
        if (typeof fromArray[i] == 'string') {
          toArray.push(fromArray[i].toLowerCase());
        }
      } catch (e) {
        console.log("error setting style from array", JSON.stringify(fromArray[i]));
      }
    }

    tocss[s] = toArray.join("-");
  }

  var styleMap = {
    tocss: tocss,
    tojs: {}
  };

  for (var s in tocss) {
    try {
      if (typeof s == 'string') {
        styleMap.tojs[s.toLowerCase()] = s;
        styleMap.tocss[s.toLowerCase()] = styleMap.tocss[s];
      }
    } catch (e) {
      console.log("error setting style to array", JSON.stringify(s));
    }
  }

  Mura.styleMap = styleMap;
}

/***/ }),

/***/ 379:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

function _typeof(obj) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (obj) { return typeof obj; } : function (obj) { return obj && "function" == typeof Symbol && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }, _typeof(obj); }

this.Mura = __webpack_require__(791);
this.Mura.templates = this["Mura"]["templates"] || {};
this.Mura.templates.checkbox_static = this.Mura.Handlebars.template({
  "1": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return container.escapeExpression((helper = (helper = lookupProperty(helpers, "summary") || (depth0 != null ? lookupProperty(depth0, "summary") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "summary",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 18
        },
        "end": {
          "line": 4,
          "column": 29
        }
      }
    }) : helper));
  },
  "3": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return container.escapeExpression((helper = (helper = lookupProperty(helpers, "label") || (depth0 != null ? lookupProperty(depth0, "label") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "label",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 37
        },
        "end": {
          "line": 4,
          "column": 46
        }
      }
    }) : helper));
  },
  "5": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return " <ins>" + container.escapeExpression((helper = (helper = lookupProperty(helpers, "formRequiredLabel") || (depth0 != null ? lookupProperty(depth0, "formRequiredLabel") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "formRequiredLabel",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 77
        },
        "end": {
          "line": 4,
          "column": 98
        }
      }
    }) : helper)) + "</ins>";
  },
  "7": function _(container, depth0, helpers, partials, data) {
    return "</br>";
  },
  "9": function _(container, depth0, helpers, partials, data, blockParams, depths) {
    var stack1,
        helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "			<div class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "checkboxWrapperClass") || (depth0 != null ? lookupProperty(depth0, "checkboxWrapperClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "checkboxWrapperClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 8,
          "column": 15
        },
        "end": {
          "line": 8,
          "column": 41
        }
      }
    }) : helper)) != null ? stack1 : "") + "\">\r\n				<input type=\"checkbox\" name=\"" + alias4(container.lambda(depths[1] != null ? lookupProperty(depths[1], "name") : depths[1], depth0)) + "\" class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "checkboxClass") || (depth0 != null ? lookupProperty(depth0, "checkboxClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "checkboxClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 9,
          "column": 53
        },
        "end": {
          "line": 9,
          "column": 72
        }
      }
    }) : helper)) != null ? stack1 : "") + "\" id=\"field-" + alias4((helper = (helper = lookupProperty(helpers, "datarecordid") || (depth0 != null ? lookupProperty(depth0, "datarecordid") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "datarecordid",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 9,
          "column": 84
        },
        "end": {
          "line": 9,
          "column": 100
        }
      }
    }) : helper)) + "\" value=\"" + alias4((helper = (helper = lookupProperty(helpers, "value") || (depth0 != null ? lookupProperty(depth0, "value") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "value",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 9,
          "column": 109
        },
        "end": {
          "line": 9,
          "column": 118
        }
      }
    }) : helper)) + "\" " + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "isselected") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(10, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 9,
          "column": 120
        },
        "end": {
          "line": 9,
          "column": 163
        }
      }
    })) != null ? stack1 : "") + "/>\r\n				<label class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "checkboxLabelClass") || (depth0 != null ? lookupProperty(depth0, "checkboxLabelClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "checkboxLabelClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 10,
          "column": 18
        },
        "end": {
          "line": 10,
          "column": 42
        }
      }
    }) : helper)) != null ? stack1 : "") + "\" for=\"field-" + alias4((helper = (helper = lookupProperty(helpers, "datarecordid") || (depth0 != null ? lookupProperty(depth0, "datarecordid") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "datarecordid",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 10,
          "column": 55
        },
        "end": {
          "line": 10,
          "column": 71
        }
      }
    }) : helper)) + "\">" + alias4((helper = (helper = lookupProperty(helpers, "label") || (depth0 != null ? lookupProperty(depth0, "label") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "label",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 10,
          "column": 73
        },
        "end": {
          "line": 10,
          "column": 82
        }
      }
    }) : helper)) + "</label>\r\n			</div>\r\n";
  },
  "10": function _(container, depth0, helpers, partials, data) {
    return " checked='checked'";
  },
  "compiler": [8, ">= 4.3.0"],
  "main": function main(container, depth0, helpers, partials, data, blockParams, depths) {
    var stack1,
        helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "<div class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "inputWrapperClass") || (depth0 != null ? lookupProperty(depth0, "inputWrapperClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "inputWrapperClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 12
        },
        "end": {
          "line": 1,
          "column": 35
        }
      }
    }) : helper)) != null ? stack1 : "") + "\" id=\"field-" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 47
        },
        "end": {
          "line": 1,
          "column": 55
        }
      }
    }) : helper)) + "-container\">\r\n	<div class=\"mura-checkbox-group\">\r\n		<label class=\"mura-group-label\" for=\"" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 3,
          "column": 39
        },
        "end": {
          "line": 3,
          "column": 47
        }
      }
    }) : helper)) + "\">\r\n			" + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "summary") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(1, data, 0, blockParams, depths),
      "inverse": container.program(3, data, 0, blockParams, depths),
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 3
        },
        "end": {
          "line": 4,
          "column": 53
        }
      }
    })) != null ? stack1 : "") + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "isrequired") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(5, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 53
        },
        "end": {
          "line": 4,
          "column": 111
        }
      }
    })) != null ? stack1 : "") + "\r\n		</label>\r\n		" + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "summary") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(7, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 6,
          "column": 2
        },
        "end": {
          "line": 6,
          "column": 29
        }
      }
    })) != null ? stack1 : "") + "\r\n" + ((stack1 = (lookupProperty(helpers, "eachStatic") || depth0 && lookupProperty(depth0, "eachStatic") || alias2).call(alias1, depth0 != null ? lookupProperty(depth0, "dataset") : depth0, {
      "name": "eachStatic",
      "hash": {},
      "fn": container.program(9, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 7,
          "column": 2
        },
        "end": {
          "line": 12,
          "column": 17
        }
      }
    })) != null ? stack1 : "") + "	</div>\r\n</div>\r\n";
  },
  "useData": true,
  "useDepths": true
});
this.Mura.templates.checkbox = this.Mura.Handlebars.template({
  "1": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return container.escapeExpression((helper = (helper = lookupProperty(helpers, "summary") || (depth0 != null ? lookupProperty(depth0, "summary") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "summary",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 18
        },
        "end": {
          "line": 4,
          "column": 29
        }
      }
    }) : helper));
  },
  "3": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return container.escapeExpression((helper = (helper = lookupProperty(helpers, "label") || (depth0 != null ? lookupProperty(depth0, "label") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "label",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 37
        },
        "end": {
          "line": 4,
          "column": 46
        }
      }
    }) : helper));
  },
  "5": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return " <ins>" + container.escapeExpression((helper = (helper = lookupProperty(helpers, "formRequiredLabel") || (depth0 != null ? lookupProperty(depth0, "formRequiredLabel") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "formRequiredLabel",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 77
        },
        "end": {
          "line": 4,
          "column": 98
        }
      }
    }) : helper)) + "</ins>";
  },
  "7": function _(container, depth0, helpers, partials, data) {
    return "</br>";
  },
  "9": function _(container, depth0, helpers, partials, data, blockParams, depths) {
    var stack1,
        helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.lambda,
        alias5 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "			<div class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "checkboxWrapperClass") || (depth0 != null ? lookupProperty(depth0, "checkboxWrapperClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "checkboxWrapperClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 8,
          "column": 15
        },
        "end": {
          "line": 8,
          "column": 41
        }
      }
    }) : helper)) != null ? stack1 : "") + "\">\r\n				<input source=\"" + alias5(alias4((stack1 = depths[1] != null ? lookupProperty(depths[1], "dataset") : depths[1]) != null ? lookupProperty(stack1, "source") : stack1, depth0)) + "\" class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "checkboxClass") || (depth0 != null ? lookupProperty(depth0, "checkboxClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "checkboxClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 9,
          "column": 49
        },
        "end": {
          "line": 9,
          "column": 68
        }
      }
    }) : helper)) != null ? stack1 : "") + "\" type=\"checkbox\" name=\"" + alias5(alias4(depths[1] != null ? lookupProperty(depths[1], "name") : depths[1], depth0)) + "\" id=\"field-" + alias5((helper = (helper = lookupProperty(helpers, "id") || (depth0 != null ? lookupProperty(depth0, "id") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "id",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 9,
          "column": 115
        },
        "end": {
          "line": 9,
          "column": 121
        }
      }
    }) : helper)) + "\" value=\"" + alias5((helper = (helper = lookupProperty(helpers, "id") || (depth0 != null ? lookupProperty(depth0, "id") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "id",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 9,
          "column": 130
        },
        "end": {
          "line": 9,
          "column": 136
        }
      }
    }) : helper)) + "\" " + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "isselected") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(10, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 9,
          "column": 138
        },
        "end": {
          "line": 9,
          "column": 180
        }
      }
    })) != null ? stack1 : "") + "/>\r\n				<label class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "checkboxLabelClass") || (depth0 != null ? lookupProperty(depth0, "checkboxLabelClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "checkboxLabelClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 10,
          "column": 18
        },
        "end": {
          "line": 10,
          "column": 42
        }
      }
    }) : helper)) != null ? stack1 : "") + "\" for=\"field-" + alias5((helper = (helper = lookupProperty(helpers, "id") || (depth0 != null ? lookupProperty(depth0, "id") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "id",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 10,
          "column": 55
        },
        "end": {
          "line": 10,
          "column": 61
        }
      }
    }) : helper)) + "\">" + alias5((helper = (helper = lookupProperty(helpers, "label") || (depth0 != null ? lookupProperty(depth0, "label") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "label",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 10,
          "column": 63
        },
        "end": {
          "line": 10,
          "column": 72
        }
      }
    }) : helper)) + "</label>\r\n			</div>\r\n";
  },
  "10": function _(container, depth0, helpers, partials, data) {
    return "checked='checked'";
  },
  "compiler": [8, ">= 4.3.0"],
  "main": function main(container, depth0, helpers, partials, data, blockParams, depths) {
    var stack1,
        helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "<div class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "inputWrapperClass") || (depth0 != null ? lookupProperty(depth0, "inputWrapperClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "inputWrapperClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 12
        },
        "end": {
          "line": 1,
          "column": 35
        }
      }
    }) : helper)) != null ? stack1 : "") + "\" id=\"field-" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 47
        },
        "end": {
          "line": 1,
          "column": 55
        }
      }
    }) : helper)) + "-container\">\r\n	<div class=\"mura-checkbox-group\">\r\n		<label class=\"mura-group-label\" for=\"" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 3,
          "column": 39
        },
        "end": {
          "line": 3,
          "column": 47
        }
      }
    }) : helper)) + "\">\r\n			" + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "summary") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(1, data, 0, blockParams, depths),
      "inverse": container.program(3, data, 0, blockParams, depths),
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 3
        },
        "end": {
          "line": 4,
          "column": 53
        }
      }
    })) != null ? stack1 : "") + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "isrequired") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(5, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 53
        },
        "end": {
          "line": 4,
          "column": 111
        }
      }
    })) != null ? stack1 : "") + "\r\n		</label>\r\n		" + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "summary") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(7, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 6,
          "column": 2
        },
        "end": {
          "line": 6,
          "column": 29
        }
      }
    })) != null ? stack1 : "") + "\r\n" + ((stack1 = (lookupProperty(helpers, "eachCheck") || depth0 && lookupProperty(depth0, "eachCheck") || alias2).call(alias1, (stack1 = depth0 != null ? lookupProperty(depth0, "dataset") : depth0) != null ? lookupProperty(stack1, "options") : stack1, depth0 != null ? lookupProperty(depth0, "selected") : depth0, {
      "name": "eachCheck",
      "hash": {},
      "fn": container.program(9, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 7,
          "column": 2
        },
        "end": {
          "line": 12,
          "column": 16
        }
      }
    })) != null ? stack1 : "") + "	</div>\r\n</div>\r\n";
  },
  "useData": true,
  "useDepths": true
});
this.Mura.templates.dropdown_static = this.Mura.Handlebars.template({
  "1": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return container.escapeExpression((helper = (helper = lookupProperty(helpers, "summary") || (depth0 != null ? lookupProperty(depth0, "summary") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "summary",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 68
        },
        "end": {
          "line": 2,
          "column": 79
        }
      }
    }) : helper));
  },
  "3": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return container.escapeExpression((helper = (helper = lookupProperty(helpers, "label") || (depth0 != null ? lookupProperty(depth0, "label") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "label",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 87
        },
        "end": {
          "line": 2,
          "column": 96
        }
      }
    }) : helper));
  },
  "5": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return " <ins>" + container.escapeExpression((helper = (helper = lookupProperty(helpers, "formRequiredLabel") || (depth0 != null ? lookupProperty(depth0, "formRequiredLabel") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "formRequiredLabel",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 127
        },
        "end": {
          "line": 2,
          "column": 148
        }
      }
    }) : helper)) + "</ins>";
  },
  "7": function _(container, depth0, helpers, partials, data) {
    return "</br>";
  },
  "9": function _(container, depth0, helpers, partials, data) {
    return " aria-required=\"true\"";
  },
  "11": function _(container, depth0, helpers, partials, data) {
    var stack1,
        helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "				<option data-isother=\"" + alias4((helper = (helper = lookupProperty(helpers, "isother") || (depth0 != null ? lookupProperty(depth0, "isother") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "isother",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 6,
          "column": 26
        },
        "end": {
          "line": 6,
          "column": 37
        }
      }
    }) : helper)) + "\" id=\"field-" + alias4((helper = (helper = lookupProperty(helpers, "datarecordid") || (depth0 != null ? lookupProperty(depth0, "datarecordid") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "datarecordid",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 6,
          "column": 49
        },
        "end": {
          "line": 6,
          "column": 65
        }
      }
    }) : helper)) + "\" value=\"" + alias4((helper = (helper = lookupProperty(helpers, "value") || (depth0 != null ? lookupProperty(depth0, "value") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "value",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 6,
          "column": 74
        },
        "end": {
          "line": 6,
          "column": 83
        }
      }
    }) : helper)) + "\" " + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "isselected") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(12, data, 0),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 6,
          "column": 85
        },
        "end": {
          "line": 6,
          "column": 129
        }
      }
    })) != null ? stack1 : "") + ">" + alias4((helper = (helper = lookupProperty(helpers, "label") || (depth0 != null ? lookupProperty(depth0, "label") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "label",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 6,
          "column": 130
        },
        "end": {
          "line": 6,
          "column": 139
        }
      }
    }) : helper)) + "</option>\n";
  },
  "12": function _(container, depth0, helpers, partials, data) {
    return "selected='selected'";
  },
  "compiler": [8, ">= 4.3.0"],
  "main": function main(container, depth0, helpers, partials, data) {
    var stack1,
        helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "	<div class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "inputWrapperClass") || (depth0 != null ? lookupProperty(depth0, "inputWrapperClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "inputWrapperClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 13
        },
        "end": {
          "line": 1,
          "column": 36
        }
      }
    }) : helper)) != null ? stack1 : "") + "\" id=\"field-" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 48
        },
        "end": {
          "line": 1,
          "column": 56
        }
      }
    }) : helper)) + "-container\">\n		<label for=\"" + alias4((helper = (helper = lookupProperty(helpers, "labelForValue") || (depth0 != null ? lookupProperty(depth0, "labelForValue") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "labelForValue",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 14
        },
        "end": {
          "line": 2,
          "column": 31
        }
      }
    }) : helper)) + "\" data-for=\"" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 43
        },
        "end": {
          "line": 2,
          "column": 51
        }
      }
    }) : helper)) + "\">" + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "summary") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(1, data, 0),
      "inverse": container.program(3, data, 0),
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 53
        },
        "end": {
          "line": 2,
          "column": 103
        }
      }
    })) != null ? stack1 : "") + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "isrequired") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(5, data, 0),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 103
        },
        "end": {
          "line": 2,
          "column": 161
        }
      }
    })) != null ? stack1 : "") + "</label>\n		" + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "summary") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(7, data, 0),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 3,
          "column": 2
        },
        "end": {
          "line": 3,
          "column": 29
        }
      }
    })) != null ? stack1 : "") + "\n		<select " + ((stack1 = (helper = (helper = lookupProperty(helpers, "commonInputAttributes") || (depth0 != null ? lookupProperty(depth0, "commonInputAttributes") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "commonInputAttributes",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 10
        },
        "end": {
          "line": 4,
          "column": 37
        }
      }
    }) : helper)) != null ? stack1 : "") + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "isrequired") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(9, data, 0),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 37
        },
        "end": {
          "line": 4,
          "column": 83
        }
      }
    })) != null ? stack1 : "") + ">\n" + ((stack1 = (lookupProperty(helpers, "eachStatic") || depth0 && lookupProperty(depth0, "eachStatic") || alias2).call(alias1, depth0 != null ? lookupProperty(depth0, "dataset") : depth0, {
      "name": "eachStatic",
      "hash": {},
      "fn": container.program(11, data, 0),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 5,
          "column": 3
        },
        "end": {
          "line": 7,
          "column": 18
        }
      }
    })) != null ? stack1 : "") + "		</select>\n	</div>\n";
  },
  "useData": true
});
this.Mura.templates.dropdown = this.Mura.Handlebars.template({
  "1": function _(container, depth0, helpers, partials, data) {
    return " aria-required=\"true\"";
  },
  "3": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return container.escapeExpression((helper = (helper = lookupProperty(helpers, "summary") || (depth0 != null ? lookupProperty(depth0, "summary") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "summary",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 114
        },
        "end": {
          "line": 2,
          "column": 125
        }
      }
    }) : helper));
  },
  "5": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return container.escapeExpression((helper = (helper = lookupProperty(helpers, "label") || (depth0 != null ? lookupProperty(depth0, "label") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "label",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 133
        },
        "end": {
          "line": 2,
          "column": 142
        }
      }
    }) : helper));
  },
  "7": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return " <ins>" + container.escapeExpression((helper = (helper = lookupProperty(helpers, "formRequiredLabel") || (depth0 != null ? lookupProperty(depth0, "formRequiredLabel") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "formRequiredLabel",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 173
        },
        "end": {
          "line": 2,
          "column": 194
        }
      }
    }) : helper)) + "</ins>";
  },
  "9": function _(container, depth0, helpers, partials, data) {
    return "</br>";
  },
  "11": function _(container, depth0, helpers, partials, data) {
    var stack1,
        helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "					<option data-isother=\"" + alias4((helper = (helper = lookupProperty(helpers, "isother") || (depth0 != null ? lookupProperty(depth0, "isother") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "isother",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 6,
          "column": 27
        },
        "end": {
          "line": 6,
          "column": 38
        }
      }
    }) : helper)) + "\" id=\"field-" + alias4((helper = (helper = lookupProperty(helpers, "id") || (depth0 != null ? lookupProperty(depth0, "id") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "id",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 6,
          "column": 50
        },
        "end": {
          "line": 6,
          "column": 56
        }
      }
    }) : helper)) + "\" value=\"" + alias4((helper = (helper = lookupProperty(helpers, "id") || (depth0 != null ? lookupProperty(depth0, "id") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "id",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 6,
          "column": 65
        },
        "end": {
          "line": 6,
          "column": 71
        }
      }
    }) : helper)) + "\" " + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "isselected") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(12, data, 0),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 6,
          "column": 73
        },
        "end": {
          "line": 6,
          "column": 117
        }
      }
    })) != null ? stack1 : "") + ">" + alias4((helper = (helper = lookupProperty(helpers, "label") || (depth0 != null ? lookupProperty(depth0, "label") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "label",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 6,
          "column": 118
        },
        "end": {
          "line": 6,
          "column": 127
        }
      }
    }) : helper)) + "</option>\n";
  },
  "12": function _(container, depth0, helpers, partials, data) {
    return "selected='selected'";
  },
  "compiler": [8, ">= 4.3.0"],
  "main": function main(container, depth0, helpers, partials, data) {
    var stack1,
        helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "	<div class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "inputWrapperClass") || (depth0 != null ? lookupProperty(depth0, "inputWrapperClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "inputWrapperClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 13
        },
        "end": {
          "line": 1,
          "column": 36
        }
      }
    }) : helper)) != null ? stack1 : "") + "\" id=\"field-" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 48
        },
        "end": {
          "line": 1,
          "column": 56
        }
      }
    }) : helper)) + "-container\">\n		<label for=\"" + alias4((helper = (helper = lookupProperty(helpers, "labelForValue") || (depth0 != null ? lookupProperty(depth0, "labelForValue") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "labelForValue",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 14
        },
        "end": {
          "line": 2,
          "column": 31
        }
      }
    }) : helper)) + "\" data-for=\"" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 43
        },
        "end": {
          "line": 2,
          "column": 51
        }
      }
    }) : helper)) + "\"" + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "isrequired") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(1, data, 0),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 52
        },
        "end": {
          "line": 2,
          "column": 98
        }
      }
    })) != null ? stack1 : "") + ">" + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "summary") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(3, data, 0),
      "inverse": container.program(5, data, 0),
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 99
        },
        "end": {
          "line": 2,
          "column": 149
        }
      }
    })) != null ? stack1 : "") + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "isrequired") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(7, data, 0),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 149
        },
        "end": {
          "line": 2,
          "column": 207
        }
      }
    })) != null ? stack1 : "") + "</label>\n		" + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "summary") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(9, data, 0),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 3,
          "column": 2
        },
        "end": {
          "line": 3,
          "column": 29
        }
      }
    })) != null ? stack1 : "") + "\n			<select " + ((stack1 = (helper = (helper = lookupProperty(helpers, "commonInputAttributes") || (depth0 != null ? lookupProperty(depth0, "commonInputAttributes") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "commonInputAttributes",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 11
        },
        "end": {
          "line": 4,
          "column": 38
        }
      }
    }) : helper)) != null ? stack1 : "") + ">\n" + ((stack1 = lookupProperty(helpers, "each").call(alias1, (stack1 = depth0 != null ? lookupProperty(depth0, "dataset") : depth0) != null ? lookupProperty(stack1, "options") : stack1, {
      "name": "each",
      "hash": {},
      "fn": container.program(11, data, 0),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 5,
          "column": 4
        },
        "end": {
          "line": 7,
          "column": 13
        }
      }
    })) != null ? stack1 : "") + "			</select>\n	</div>\n";
  },
  "useData": true
});
this.Mura.templates.error = this.Mura.Handlebars.template({
  "1": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return container.escapeExpression((helper = (helper = lookupProperty(helpers, "label") || (depth0 != null ? lookupProperty(depth0, "label") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "label",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 102
        },
        "end": {
          "line": 1,
          "column": 111
        }
      }
    }) : helper)) + ": ";
  },
  "compiler": [8, ">= 4.3.0"],
  "main": function main(container, depth0, helpers, partials, data) {
    var stack1,
        helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "<div id=\"" + alias4((helper = (helper = lookupProperty(helpers, "id") || (depth0 != null ? lookupProperty(depth0, "id") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "id",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 9
        },
        "end": {
          "line": 1,
          "column": 15
        }
      }
    }) : helper)) + "\" class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "formErrorWrapperClass") || (depth0 != null ? lookupProperty(depth0, "formErrorWrapperClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "formErrorWrapperClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 24
        },
        "end": {
          "line": 1,
          "column": 51
        }
      }
    }) : helper)) != null ? stack1 : "") + "\" data-field=\"" + alias4((helper = (helper = lookupProperty(helpers, "field") || (depth0 != null ? lookupProperty(depth0, "field") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "field",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 65
        },
        "end": {
          "line": 1,
          "column": 74
        }
      }
    }) : helper)) + "\" role=\"alert\">" + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "label") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(1, data, 0),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 89
        },
        "end": {
          "line": 1,
          "column": 120
        }
      }
    })) != null ? stack1 : "") + alias4((helper = (helper = lookupProperty(helpers, "message") || (depth0 != null ? lookupProperty(depth0, "message") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "message",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 120
        },
        "end": {
          "line": 1,
          "column": 131
        }
      }
    }) : helper)) + "</div>\r\n";
  },
  "useData": true
});
this.Mura.templates.file = this.Mura.Handlebars.template({
  "1": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return " <ins>" + container.escapeExpression((helper = (helper = lookupProperty(helpers, "formRequiredLabel") || (depth0 != null ? lookupProperty(depth0, "formRequiredLabel") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "formRequiredLabel",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 117
        },
        "end": {
          "line": 2,
          "column": 138
        }
      }
    }) : helper)) + "</ins>";
  },
  "3": function _(container, depth0, helpers, partials, data) {
    return " aria-required=\"true\"";
  },
  "compiler": [8, ">= 4.3.0"],
  "main": function main(container, depth0, helpers, partials, data) {
    var stack1,
        helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "<div class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "inputWrapperClass") || (depth0 != null ? lookupProperty(depth0, "inputWrapperClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "inputWrapperClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 12
        },
        "end": {
          "line": 1,
          "column": 35
        }
      }
    }) : helper)) != null ? stack1 : "") + " mura-form-file-container\" id=\"field-" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 72
        },
        "end": {
          "line": 1,
          "column": 80
        }
      }
    }) : helper)) + "-container\">\r\n	<label for=\"" + alias4((helper = (helper = lookupProperty(helpers, "labelForValue") || (depth0 != null ? lookupProperty(depth0, "labelForValue") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "labelForValue",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 13
        },
        "end": {
          "line": 2,
          "column": 30
        }
      }
    }) : helper)) + " mura-form-file-label\" data-for=\"" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 63
        },
        "end": {
          "line": 2,
          "column": 71
        }
      }
    }) : helper)) + "_attachment\">" + alias4((helper = (helper = lookupProperty(helpers, "label") || (depth0 != null ? lookupProperty(depth0, "label") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "label",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 84
        },
        "end": {
          "line": 2,
          "column": 93
        }
      }
    }) : helper)) + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "isrequired") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(1, data, 0),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 93
        },
        "end": {
          "line": 2,
          "column": 151
        }
      }
    })) != null ? stack1 : "") + "</label>\r\n	<input readonly type=\"text\" data-filename=\"" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 3,
          "column": 44
        },
        "end": {
          "line": 3,
          "column": 52
        }
      }
    }) : helper)) + "_attachment\"" + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "isrequired") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(3, data, 0),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 3,
          "column": 64
        },
        "end": {
          "line": 3,
          "column": 110
        }
      }
    })) != null ? stack1 : "") + " placeholder=\"" + alias4((helper = (helper = lookupProperty(helpers, "filePlaceholder") || (depth0 != null ? lookupProperty(depth0, "filePlaceholder") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "filePlaceholder",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 3,
          "column": 124
        },
        "end": {
          "line": 3,
          "column": 143
        }
      }
    }) : helper)) + "\" " + ((stack1 = (helper = (helper = lookupProperty(helpers, "fileAttributes") || (depth0 != null ? lookupProperty(depth0, "fileAttributes") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "fileAttributes",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 3,
          "column": 145
        },
        "end": {
          "line": 3,
          "column": 165
        }
      }
    }) : helper)) != null ? stack1 : "") + ">\r\n	<input hidden data-filename=\"" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 30
        },
        "end": {
          "line": 4,
          "column": 38
        }
      }
    }) : helper)) + "_attachment\" type=\"file\" " + ((stack1 = (helper = (helper = lookupProperty(helpers, "commonInputAttributes") || (depth0 != null ? lookupProperty(depth0, "commonInputAttributes") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "commonInputAttributes",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 63
        },
        "end": {
          "line": 4,
          "column": 90
        }
      }
    }) : helper)) != null ? stack1 : "") + "/>\r\n	<div class=\"mura-form-preview\" style=\"display:none;\">\r\n		<img style=\"display:none;\" id=\"mura-form-preview-" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 6,
          "column": 51
        },
        "end": {
          "line": 6,
          "column": 59
        }
      }
    }) : helper)) + "_attachment\" src=\"\" onerror=\"this.onerror=null;this.src='';this.style.display='none';\">\r\n	</div>\r\n</div>\r\n";
  },
  "useData": true
});
this.Mura.templates.form = this.Mura.Handlebars.template({
  "compiler": [8, ">= 4.3.0"],
  "main": function main(container, depth0, helpers, partials, data) {
    var stack1,
        helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "<form id=\"frm" + alias4((helper = (helper = lookupProperty(helpers, "objectid") || (depth0 != null ? lookupProperty(depth0, "objectid") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "objectid",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 13
        },
        "end": {
          "line": 1,
          "column": 25
        }
      }
    }) : helper)) + "\" class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "formClass") || (depth0 != null ? lookupProperty(depth0, "formClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "formClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 34
        },
        "end": {
          "line": 1,
          "column": 49
        }
      }
    }) : helper)) != null ? stack1 : "") + "\" novalidate=\"novalidate\" enctype=\"multipart/form-data\">\n<div class=\"error-container-" + alias4((helper = (helper = lookupProperty(helpers, "objectid") || (depth0 != null ? lookupProperty(depth0, "objectid") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "objectid",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 28
        },
        "end": {
          "line": 2,
          "column": 40
        }
      }
    }) : helper)) + "\">\n</div>\n<div class=\"field-container-" + alias4((helper = (helper = lookupProperty(helpers, "objectid") || (depth0 != null ? lookupProperty(depth0, "objectid") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "objectid",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 28
        },
        "end": {
          "line": 4,
          "column": 40
        }
      }
    }) : helper)) + "\">\n</div>\n<div class=\"paging-container-" + alias4((helper = (helper = lookupProperty(helpers, "objectid") || (depth0 != null ? lookupProperty(depth0, "objectid") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "objectid",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 6,
          "column": 29
        },
        "end": {
          "line": 6,
          "column": 41
        }
      }
    }) : helper)) + "\">\n</div>\n	<input type=\"hidden\" name=\"formid\" value=\"" + alias4((helper = (helper = lookupProperty(helpers, "objectid") || (depth0 != null ? lookupProperty(depth0, "objectid") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "objectid",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 8,
          "column": 43
        },
        "end": {
          "line": 8,
          "column": 55
        }
      }
    }) : helper)) + "\">\n</form>\n";
  },
  "useData": true
});
this.Mura.templates.hidden = this.Mura.Handlebars.template({
  "compiler": [8, ">= 4.3.0"],
  "main": function main(container, depth0, helpers, partials, data) {
    var stack1,
        helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "<input type=\"hidden\" name=\"" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 27
        },
        "end": {
          "line": 1,
          "column": 35
        }
      }
    }) : helper)) + "\" " + ((stack1 = (helper = (helper = lookupProperty(helpers, "commonInputAttributes") || (depth0 != null ? lookupProperty(depth0, "commonInputAttributes") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "commonInputAttributes",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 37
        },
        "end": {
          "line": 1,
          "column": 64
        }
      }
    }) : helper)) != null ? stack1 : "") + " value=\"" + alias4((helper = (helper = lookupProperty(helpers, "value") || (depth0 != null ? lookupProperty(depth0, "value") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "value",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 72
        },
        "end": {
          "line": 1,
          "column": 81
        }
      }
    }) : helper)) + "\" />			\n";
  },
  "useData": true
});
this.Mura.templates.list = this.Mura.Handlebars.template({
  "1": function _(container, depth0, helpers, partials, data) {
    var helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "					<option value=\"" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 7,
          "column": 20
        },
        "end": {
          "line": 7,
          "column": 28
        }
      }
    }) : helper)) + "\">" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 7,
          "column": 30
        },
        "end": {
          "line": 7,
          "column": 38
        }
      }
    }) : helper)) + "</option>\n";
  },
  "compiler": [8, ">= 4.3.0"],
  "main": function main(container, depth0, helpers, partials, data) {
    var stack1,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "<form>\n	<div class=\"mura-control-group\">\n		<label for=\"beanList\">Choose Entity:</label>	\n		<div class=\"form-group-select\">\n			<select type=\"text\" name=\"bean\" id=\"select-bean-value\">\n" + ((stack1 = lookupProperty(helpers, "each").call(depth0 != null ? depth0 : container.nullContext || {}, depth0, {
      "name": "each",
      "hash": {},
      "fn": container.program(1, data, 0),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 6,
          "column": 4
        },
        "end": {
          "line": 8,
          "column": 13
        }
      }
    })) != null ? stack1 : "") + "			</select>\n		</div>\n	</div>\n	<div class=\"mura-control-group\">\n		<button type=\"button\" id=\"select-bean\">Go</button>\n	</div>\n</form>";
  },
  "useData": true
});
this.Mura.templates.nested = this.Mura.Handlebars.template({
  "compiler": [8, ">= 4.3.0"],
  "main": function main(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "<div class=\"field-container-" + container.escapeExpression((helper = (helper = lookupProperty(helpers, "objectid") || (depth0 != null ? lookupProperty(depth0, "objectid") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "objectid",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 28
        },
        "end": {
          "line": 1,
          "column": 40
        }
      }
    }) : helper)) + "\">\r\n\r\n</div>\r\n";
  },
  "useData": true
});
this.Mura.templates.paging = this.Mura.Handlebars.template({
  "compiler": [8, ">= 4.3.0"],
  "main": function main(container, depth0, helpers, partials, data) {
    var helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "<button class=\"" + alias4((helper = (helper = lookupProperty(helpers, "class") || (depth0 != null ? lookupProperty(depth0, "class") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "class",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 15
        },
        "end": {
          "line": 1,
          "column": 24
        }
      }
    }) : helper)) + "\" type=\"button\" data-page=\"" + alias4((helper = (helper = lookupProperty(helpers, "page") || (depth0 != null ? lookupProperty(depth0, "page") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "page",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 51
        },
        "end": {
          "line": 1,
          "column": 59
        }
      }
    }) : helper)) + "\">" + alias4((helper = (helper = lookupProperty(helpers, "label") || (depth0 != null ? lookupProperty(depth0, "label") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "label",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 61
        },
        "end": {
          "line": 1,
          "column": 70
        }
      }
    }) : helper)) + "</button> ";
  },
  "useData": true
});
this.Mura.templates.radio_static = this.Mura.Handlebars.template({
  "1": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return container.escapeExpression((helper = (helper = lookupProperty(helpers, "summary") || (depth0 != null ? lookupProperty(depth0, "summary") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "summary",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 19
        },
        "end": {
          "line": 4,
          "column": 30
        }
      }
    }) : helper));
  },
  "3": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return container.escapeExpression((helper = (helper = lookupProperty(helpers, "label") || (depth0 != null ? lookupProperty(depth0, "label") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "label",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 38
        },
        "end": {
          "line": 4,
          "column": 47
        }
      }
    }) : helper));
  },
  "5": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return " <ins>" + container.escapeExpression((helper = (helper = lookupProperty(helpers, "formRequiredLabel") || (depth0 != null ? lookupProperty(depth0, "formRequiredLabel") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "formRequiredLabel",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 78
        },
        "end": {
          "line": 4,
          "column": 99
        }
      }
    }) : helper)) + "</ins>";
  },
  "7": function _(container, depth0, helpers, partials, data) {
    return "</br>";
  },
  "9": function _(container, depth0, helpers, partials, data, blockParams, depths) {
    var stack1,
        helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "				<div class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "radioWrapperClass") || (depth0 != null ? lookupProperty(depth0, "radioWrapperClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "radioWrapperClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 8,
          "column": 16
        },
        "end": {
          "line": 8,
          "column": 39
        }
      }
    }) : helper)) != null ? stack1 : "") + "\">\n					<input type=\"radio\" name=\"" + alias4(container.lambda(depths[1] != null ? lookupProperty(depths[1], "name") : depths[1], depth0)) + "\" class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "radioClass") || (depth0 != null ? lookupProperty(depth0, "radioClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "radioClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 9,
          "column": 51
        },
        "end": {
          "line": 9,
          "column": 67
        }
      }
    }) : helper)) != null ? stack1 : "") + "\" id=\"field-" + alias4((helper = (helper = lookupProperty(helpers, "datarecordid") || (depth0 != null ? lookupProperty(depth0, "datarecordid") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "datarecordid",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 9,
          "column": 79
        },
        "end": {
          "line": 9,
          "column": 95
        }
      }
    }) : helper)) + "\" value=\"" + alias4((helper = (helper = lookupProperty(helpers, "value") || (depth0 != null ? lookupProperty(depth0, "value") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "value",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 9,
          "column": 104
        },
        "end": {
          "line": 9,
          "column": 113
        }
      }
    }) : helper)) + "\"  " + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "isselected") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(10, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 9,
          "column": 116
        },
        "end": {
          "line": 9,
          "column": 158
        }
      }
    })) != null ? stack1 : "") + "/>\n					<label for=\"field-" + alias4((helper = (helper = lookupProperty(helpers, "datarecordid") || (depth0 != null ? lookupProperty(depth0, "datarecordid") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "datarecordid",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 10,
          "column": 23
        },
        "end": {
          "line": 10,
          "column": 39
        }
      }
    }) : helper)) + "\" class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "radioLabelClass") || (depth0 != null ? lookupProperty(depth0, "radioLabelClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "radioLabelClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 10,
          "column": 48
        },
        "end": {
          "line": 10,
          "column": 69
        }
      }
    }) : helper)) != null ? stack1 : "") + "\">" + alias4((helper = (helper = lookupProperty(helpers, "label") || (depth0 != null ? lookupProperty(depth0, "label") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "label",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 10,
          "column": 71
        },
        "end": {
          "line": 10,
          "column": 80
        }
      }
    }) : helper)) + "</label>\n				</div>\n";
  },
  "10": function _(container, depth0, helpers, partials, data) {
    return "checked='checked'";
  },
  "compiler": [8, ">= 4.3.0"],
  "main": function main(container, depth0, helpers, partials, data, blockParams, depths) {
    var stack1,
        helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "	<div class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "inputWrapperClass") || (depth0 != null ? lookupProperty(depth0, "inputWrapperClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "inputWrapperClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 13
        },
        "end": {
          "line": 1,
          "column": 36
        }
      }
    }) : helper)) != null ? stack1 : "") + "\" id=\"field-" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 48
        },
        "end": {
          "line": 1,
          "column": 56
        }
      }
    }) : helper)) + "-container\">\n		<div class=\"mura-radio-group\">\n			<label class=\"mura-group-label\" for=\"" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 3,
          "column": 40
        },
        "end": {
          "line": 3,
          "column": 48
        }
      }
    }) : helper)) + "\">\n				" + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "summary") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(1, data, 0, blockParams, depths),
      "inverse": container.program(3, data, 0, blockParams, depths),
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 4
        },
        "end": {
          "line": 4,
          "column": 54
        }
      }
    })) != null ? stack1 : "") + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "isrequired") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(5, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 54
        },
        "end": {
          "line": 4,
          "column": 112
        }
      }
    })) != null ? stack1 : "") + "\n			</label>\n			" + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "summary") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(7, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 6,
          "column": 3
        },
        "end": {
          "line": 6,
          "column": 30
        }
      }
    })) != null ? stack1 : "") + "\n" + ((stack1 = (lookupProperty(helpers, "eachStatic") || depth0 && lookupProperty(depth0, "eachStatic") || alias2).call(alias1, depth0 != null ? lookupProperty(depth0, "dataset") : depth0, {
      "name": "eachStatic",
      "hash": {},
      "fn": container.program(9, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 7,
          "column": 3
        },
        "end": {
          "line": 12,
          "column": 18
        }
      }
    })) != null ? stack1 : "") + "		</div>\n	</div>\n";
  },
  "useData": true,
  "useDepths": true
});
this.Mura.templates.radio = this.Mura.Handlebars.template({
  "1": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return container.escapeExpression((helper = (helper = lookupProperty(helpers, "summary") || (depth0 != null ? lookupProperty(depth0, "summary") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "summary",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 19
        },
        "end": {
          "line": 4,
          "column": 30
        }
      }
    }) : helper));
  },
  "3": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return container.escapeExpression((helper = (helper = lookupProperty(helpers, "label") || (depth0 != null ? lookupProperty(depth0, "label") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "label",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 38
        },
        "end": {
          "line": 4,
          "column": 47
        }
      }
    }) : helper));
  },
  "5": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return " <ins>" + container.escapeExpression((helper = (helper = lookupProperty(helpers, "formRequiredLabel") || (depth0 != null ? lookupProperty(depth0, "formRequiredLabel") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "formRequiredLabel",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 78
        },
        "end": {
          "line": 4,
          "column": 99
        }
      }
    }) : helper)) + "</ins>";
  },
  "7": function _(container, depth0, helpers, partials, data) {
    return "</br>";
  },
  "9": function _(container, depth0, helpers, partials, data, blockParams, depths) {
    var stack1,
        helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "				<div class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "radioWrapperClass") || (depth0 != null ? lookupProperty(depth0, "radioWrapperClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "radioWrapperClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 8,
          "column": 16
        },
        "end": {
          "line": 8,
          "column": 39
        }
      }
    }) : helper)) != null ? stack1 : "") + "\">\n					<input type=\"radio\" name=\"" + alias4(container.lambda(depths[1] != null ? lookupProperty(depths[1], "name") : depths[1], depth0)) + "id\" class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "radioClass") || (depth0 != null ? lookupProperty(depth0, "radioClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "radioClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 9,
          "column": 53
        },
        "end": {
          "line": 9,
          "column": 69
        }
      }
    }) : helper)) != null ? stack1 : "") + "\" id=\"field-" + alias4((helper = (helper = lookupProperty(helpers, "id") || (depth0 != null ? lookupProperty(depth0, "id") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "id",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 9,
          "column": 81
        },
        "end": {
          "line": 9,
          "column": 87
        }
      }
    }) : helper)) + "\" value=\"" + alias4((helper = (helper = lookupProperty(helpers, "id") || (depth0 != null ? lookupProperty(depth0, "id") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "id",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 9,
          "column": 96
        },
        "end": {
          "line": 9,
          "column": 102
        }
      }
    }) : helper)) + "\" " + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "isselected") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(10, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 9,
          "column": 104
        },
        "end": {
          "line": 9,
          "column": 146
        }
      }
    })) != null ? stack1 : "") + "/>\n					<label for=\"field-" + alias4((helper = (helper = lookupProperty(helpers, "id") || (depth0 != null ? lookupProperty(depth0, "id") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "id",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 10,
          "column": 23
        },
        "end": {
          "line": 10,
          "column": 29
        }
      }
    }) : helper)) + "\" test1=1 class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "radioLabelClass") || (depth0 != null ? lookupProperty(depth0, "radioLabelClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "radioLabelClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 10,
          "column": 46
        },
        "end": {
          "line": 10,
          "column": 67
        }
      }
    }) : helper)) != null ? stack1 : "") + "\">" + alias4((helper = (helper = lookupProperty(helpers, "label") || (depth0 != null ? lookupProperty(depth0, "label") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "label",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 10,
          "column": 69
        },
        "end": {
          "line": 10,
          "column": 78
        }
      }
    }) : helper)) + "</label>\n				</div>\n";
  },
  "10": function _(container, depth0, helpers, partials, data) {
    return "checked='checked'";
  },
  "compiler": [8, ">= 4.3.0"],
  "main": function main(container, depth0, helpers, partials, data, blockParams, depths) {
    var stack1,
        helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "	<div class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "inputWrapperClass") || (depth0 != null ? lookupProperty(depth0, "inputWrapperClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "inputWrapperClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 13
        },
        "end": {
          "line": 1,
          "column": 36
        }
      }
    }) : helper)) != null ? stack1 : "") + "\" id=\"field-" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 48
        },
        "end": {
          "line": 1,
          "column": 56
        }
      }
    }) : helper)) + "-container\">\n		<div class=\"mura-radio-group\">\n			<label class=\"mura-group-label\" for=\"" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 3,
          "column": 40
        },
        "end": {
          "line": 3,
          "column": 48
        }
      }
    }) : helper)) + "\">\n				" + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "summary") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(1, data, 0, blockParams, depths),
      "inverse": container.program(3, data, 0, blockParams, depths),
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 4
        },
        "end": {
          "line": 4,
          "column": 54
        }
      }
    })) != null ? stack1 : "") + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "isrequired") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(5, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 54
        },
        "end": {
          "line": 4,
          "column": 112
        }
      }
    })) != null ? stack1 : "") + "\n			</label>\n			" + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "summary") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(7, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 6,
          "column": 3
        },
        "end": {
          "line": 6,
          "column": 30
        }
      }
    })) != null ? stack1 : "") + "\n" + ((stack1 = lookupProperty(helpers, "each").call(alias1, (stack1 = depth0 != null ? lookupProperty(depth0, "dataset") : depth0) != null ? lookupProperty(stack1, "options") : stack1, {
      "name": "each",
      "hash": {},
      "fn": container.program(9, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 7,
          "column": 3
        },
        "end": {
          "line": 12,
          "column": 12
        }
      }
    })) != null ? stack1 : "") + "		</div>\n	</div>\n";
  },
  "useData": true,
  "useDepths": true
});
this.Mura.templates.section = this.Mura.Handlebars.template({
  "compiler": [8, ">= 4.3.0"],
  "main": function main(container, depth0, helpers, partials, data) {
    var stack1,
        helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "<div class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "inputWrapperClass") || (depth0 != null ? lookupProperty(depth0, "inputWrapperClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "inputWrapperClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 12
        },
        "end": {
          "line": 1,
          "column": 35
        }
      }
    }) : helper)) != null ? stack1 : "") + "\" id=\"field-" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 47
        },
        "end": {
          "line": 1,
          "column": 55
        }
      }
    }) : helper)) + "-container\">\r\n<div class=\"mura-section\">" + alias4((helper = (helper = lookupProperty(helpers, "label") || (depth0 != null ? lookupProperty(depth0, "label") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "label",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 26
        },
        "end": {
          "line": 2,
          "column": 35
        }
      }
    }) : helper)) + "</div>\r\n<div class=\"mura-divide\"></div>\r\n</div>";
  },
  "useData": true
});

this.Mura.templates.success = this.Mura.Handlebars.template({
  "compiler": [8, ">= 4.3.0"],
  "main": function main(container, depth0, helpers, partials, data) {
    var stack1,
        helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "<div class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "formResponseWrapperClass") || (depth0 != null ? lookupProperty(depth0, "formResponseWrapperClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "formResponseWrapperClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 12
        },
        "end": {
          "line": 1,
          "column": 42
        }
      }
    }) : helper)) != null ? stack1 : "") + "\">" + ((stack1 = (helper = (helper = lookupProperty(helpers, "responsemessage") || (depth0 != null ? lookupProperty(depth0, "responsemessage") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "responsemessage",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 44
        },
        "end": {
          "line": 1,
          "column": 65
        }
      }
    }) : helper)) != null ? stack1 : "") + "</div>\n";
  },
  "useData": true
});
this.Mura.templates.table = this.Mura.Handlebars.template({
  "1": function _(container, depth0, helpers, partials, data) {
    var helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "<option value=\"" + alias4((helper = (helper = lookupProperty(helpers, "num") || (depth0 != null ? lookupProperty(depth0, "num") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "num",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 8,
          "column": 102
        },
        "end": {
          "line": 8,
          "column": 109
        }
      }
    }) : helper)) + "\" " + alias4((helper = (helper = lookupProperty(helpers, "selected") || (depth0 != null ? lookupProperty(depth0, "selected") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "selected",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 8,
          "column": 111
        },
        "end": {
          "line": 8,
          "column": 123
        }
      }
    }) : helper)) + ">" + alias4((helper = (helper = lookupProperty(helpers, "label") || (depth0 != null ? lookupProperty(depth0, "label") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "label",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 8,
          "column": 124
        },
        "end": {
          "line": 8,
          "column": 133
        }
      }
    }) : helper)) + "</option>";
  },
  "3": function _(container, depth0, helpers, partials, data) {
    var helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "					<option value=\"" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 27,
          "column": 20
        },
        "end": {
          "line": 27,
          "column": 28
        }
      }
    }) : helper)) + "\" " + alias4((helper = (helper = lookupProperty(helpers, "selected") || (depth0 != null ? lookupProperty(depth0, "selected") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "selected",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 27,
          "column": 30
        },
        "end": {
          "line": 27,
          "column": 42
        }
      }
    }) : helper)) + ">" + alias4((helper = (helper = lookupProperty(helpers, "displayName") || (depth0 != null ? lookupProperty(depth0, "displayName") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "displayName",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 27,
          "column": 43
        },
        "end": {
          "line": 27,
          "column": 58
        }
      }
    }) : helper)) + "</option>\n";
  },
  "5": function _(container, depth0, helpers, partials, data) {
    var helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "			<th class='data-sort' data-value='" + alias4((helper = (helper = lookupProperty(helpers, "column") || (depth0 != null ? lookupProperty(depth0, "column") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "column",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 53,
          "column": 37
        },
        "end": {
          "line": 53,
          "column": 47
        }
      }
    }) : helper)) + "'>" + alias4((helper = (helper = lookupProperty(helpers, "displayName") || (depth0 != null ? lookupProperty(depth0, "displayName") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "displayName",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 53,
          "column": 49
        },
        "end": {
          "line": 53,
          "column": 64
        }
      }
    }) : helper)) + "</th>\n";
  },
  "7": function _(container, depth0, helpers, partials, data, blockParams, depths) {
    var stack1,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "			<tr class=\"even\">\n" + ((stack1 = (lookupProperty(helpers, "eachColRow") || depth0 && lookupProperty(depth0, "eachColRow") || alias2).call(alias1, depth0, depths[1] != null ? lookupProperty(depths[1], "columns") : depths[1], {
      "name": "eachColRow",
      "hash": {},
      "fn": container.program(8, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 61,
          "column": 4
        },
        "end": {
          "line": 63,
          "column": 19
        }
      }
    })) != null ? stack1 : "") + "				<td>\n" + ((stack1 = (lookupProperty(helpers, "eachColButton") || depth0 && lookupProperty(depth0, "eachColButton") || alias2).call(alias1, depth0, {
      "name": "eachColButton",
      "hash": {},
      "fn": container.program(10, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 65,
          "column": 4
        },
        "end": {
          "line": 67,
          "column": 22
        }
      }
    })) != null ? stack1 : "") + "				</td>\n			</tr>\n";
  },
  "8": function _(container, depth0, helpers, partials, data) {
    return "					<td>" + container.escapeExpression(container.lambda(depth0, depth0)) + "</td>\n";
  },
  "10": function _(container, depth0, helpers, partials, data) {
    var helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "				<button type=\"button\" class=\"" + alias4((helper = (helper = lookupProperty(helpers, "type") || (depth0 != null ? lookupProperty(depth0, "type") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "type",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 66,
          "column": 33
        },
        "end": {
          "line": 66,
          "column": 41
        }
      }
    }) : helper)) + "\" data-value=\"" + alias4((helper = (helper = lookupProperty(helpers, "id") || (depth0 != null ? lookupProperty(depth0, "id") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "id",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 66,
          "column": 55
        },
        "end": {
          "line": 66,
          "column": 61
        }
      }
    }) : helper)) + "\" data-pos=\"" + alias4((helper = (helper = lookupProperty(helpers, "index") || data && lookupProperty(data, "index")) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "index",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 66,
          "column": 73
        },
        "end": {
          "line": 66,
          "column": 83
        }
      }
    }) : helper)) + "\">" + alias4((helper = (helper = lookupProperty(helpers, "label") || (depth0 != null ? lookupProperty(depth0, "label") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "label",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 66,
          "column": 85
        },
        "end": {
          "line": 66,
          "column": 94
        }
      }
    }) : helper)) + "</button>\n";
  },
  "12": function _(container, depth0, helpers, partials, data) {
    var stack1,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "				<button class='data-nav' data-value=\"" + container.escapeExpression(container.lambda((stack1 = (stack1 = depth0 != null ? lookupProperty(depth0, "rows") : depth0) != null ? lookupProperty(stack1, "links") : stack1) != null ? lookupProperty(stack1, "first") : stack1, depth0)) + "\">First</button>\n";
  },
  "14": function _(container, depth0, helpers, partials, data) {
    var stack1,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "				<button class='data-nav' data-value=\"" + container.escapeExpression(container.lambda((stack1 = (stack1 = depth0 != null ? lookupProperty(depth0, "rows") : depth0) != null ? lookupProperty(stack1, "links") : stack1) != null ? lookupProperty(stack1, "previous") : stack1, depth0)) + "\">Prev</button>\n";
  },
  "16": function _(container, depth0, helpers, partials, data) {
    var stack1,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "				<button class='data-nav' data-value=\"" + container.escapeExpression(container.lambda((stack1 = (stack1 = depth0 != null ? lookupProperty(depth0, "rows") : depth0) != null ? lookupProperty(stack1, "links") : stack1) != null ? lookupProperty(stack1, "next") : stack1, depth0)) + "\">Next</button>\n";
  },
  "18": function _(container, depth0, helpers, partials, data) {
    var stack1,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "				<button class='data-nav' data-value=\"" + container.escapeExpression(container.lambda((stack1 = (stack1 = depth0 != null ? lookupProperty(depth0, "rows") : depth0) != null ? lookupProperty(stack1, "links") : stack1) != null ? lookupProperty(stack1, "last") : stack1, depth0)) + "\">Last</button>\n";
  },
  "compiler": [8, ">= 4.3.0"],
  "main": function main(container, depth0, helpers, partials, data, blockParams, depths) {
    var stack1,
        alias1 = container.lambda,
        alias2 = container.escapeExpression,
        alias3 = depth0 != null ? depth0 : container.nullContext || {},
        alias4 = container.hooks.helperMissing,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "	<div class=\"mura-control-group\">\n		<div id=\"filter-results-container\">\n			<div id=\"date-filters\">\n				<div class=\"control-group\">\n				  <label>From</label>\n				  <div class=\"controls\">\n				  	<input type=\"text\" class=\"datepicker mura-date\" id=\"date1\" name=\"date1\" validate=\"date\" value=\"" + alias2(alias1((stack1 = depth0 != null ? lookupProperty(depth0, "filters") : depth0) != null ? lookupProperty(stack1, "fromdate") : stack1, depth0)) + "\">\n				  	<select id=\"hour1\" name=\"hour1\" class=\"mura-date\">" + ((stack1 = (lookupProperty(helpers, "eachHour") || depth0 && lookupProperty(depth0, "eachHour") || alias4).call(alias3, (stack1 = depth0 != null ? lookupProperty(depth0, "filters") : depth0) != null ? lookupProperty(stack1, "fromhour") : stack1, {
      "name": "eachHour",
      "hash": {},
      "fn": container.program(1, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 8,
          "column": 57
        },
        "end": {
          "line": 8,
          "column": 155
        }
      }
    })) != null ? stack1 : "") + "</select></select>\n					</div>\n				</div>\n			\n				<div class=\"control-group\">\n				  <label>To</label>\n				  <div class=\"controls\">\n				  	<input type=\"text\" class=\"datepicker mura-date\" id=\"date2\" name=\"date2\" validate=\"date\" value=\"" + alias2(alias1((stack1 = depth0 != null ? lookupProperty(depth0, "filters") : depth0) != null ? lookupProperty(stack1, "todate") : stack1, depth0)) + "\">\n				  	<select id=\"hour2\" name=\"hour2\"  class=\"mura-date\">" + ((stack1 = (lookupProperty(helpers, "eachHour") || depth0 && lookupProperty(depth0, "eachHour") || alias4).call(alias3, (stack1 = depth0 != null ? lookupProperty(depth0, "filters") : depth0) != null ? lookupProperty(stack1, "tohour") : stack1, {
      "name": "eachHour",
      "hash": {},
      "fn": container.program(1, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 16,
          "column": 58
        },
        "end": {
          "line": 16,
          "column": 154
        }
      }
    })) != null ? stack1 : "") + "</select></select>\n				   </select>\n					</div>\n				</div>\n			</div>\n					\n			<div class=\"control-group\">\n				<label>Keywords</label>\n				<div class=\"controls\">\n					<select name=\"filterBy\" class=\"mura-date\" id=\"results-filterby\">\n" + ((stack1 = (lookupProperty(helpers, "eachKey") || depth0 && lookupProperty(depth0, "eachKey") || alias4).call(alias3, depth0 != null ? lookupProperty(depth0, "properties") : depth0, (stack1 = depth0 != null ? lookupProperty(depth0, "filters") : depth0) != null ? lookupProperty(stack1, "filterby") : stack1, {
      "name": "eachKey",
      "hash": {},
      "fn": container.program(3, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 26,
          "column": 5
        },
        "end": {
          "line": 28,
          "column": 17
        }
      }
    })) != null ? stack1 : "") + "					</select>\n					<input type=\"text\" class=\"mura-half\" name=\"keywords\" id=\"results-keywords\" value=\"" + alias2(alias1((stack1 = depth0 != null ? lookupProperty(depth0, "filters") : depth0) != null ? lookupProperty(stack1, "filterkey") : stack1, depth0)) + "\">\n				</div>\n			</div>\n			<div class=\"form-actions\">\n				<button type=\"button\" class=\"btn\" id=\"btn-results-search\" ><i class=\"mi-bar-chart\"></i> View Data</button>\n				<button type=\"button\" class=\"btn\"  id=\"btn-results-download\" ><i class=\"mi-download\"></i> Download</button>\n			</div>\n		</div>\n	<div>\n\n	<ul class=\"metadata\">\n		<li>Page:\n			<strong>" + alias2(alias1((stack1 = depth0 != null ? lookupProperty(depth0, "rows") : depth0) != null ? lookupProperty(stack1, "pageindex") : stack1, depth0)) + " of " + alias2(alias1((stack1 = depth0 != null ? lookupProperty(depth0, "rows") : depth0) != null ? lookupProperty(stack1, "totalpages") : stack1, depth0)) + "</strong>\n		</li>\n		<li>Total Records:\n			<strong>" + alias2(alias1((stack1 = depth0 != null ? lookupProperty(depth0, "rows") : depth0) != null ? lookupProperty(stack1, "totalitems") : stack1, depth0)) + "</strong>\n		</li>\n	</ul>\n\n	<table style=\"width: 100%\" class=\"table\">\n		<thead>\n		<tr>\n" + ((stack1 = lookupProperty(helpers, "each").call(alias3, depth0 != null ? lookupProperty(depth0, "columns") : depth0, {
      "name": "each",
      "hash": {},
      "fn": container.program(5, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 52,
          "column": 2
        },
        "end": {
          "line": 54,
          "column": 11
        }
      }
    })) != null ? stack1 : "") + "			<th></th>\n		</tr>\n		</thead>\n		<tbody>\n" + ((stack1 = lookupProperty(helpers, "each").call(alias3, (stack1 = depth0 != null ? lookupProperty(depth0, "rows") : depth0) != null ? lookupProperty(stack1, "items") : stack1, {
      "name": "each",
      "hash": {},
      "fn": container.program(7, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 59,
          "column": 2
        },
        "end": {
          "line": 70,
          "column": 11
        }
      }
    })) != null ? stack1 : "") + "		</tbody>\n		<tfoot>\n		<tr>\n			<td>\n" + ((stack1 = lookupProperty(helpers, "if").call(alias3, (stack1 = (stack1 = depth0 != null ? lookupProperty(depth0, "rows") : depth0) != null ? lookupProperty(stack1, "links") : stack1) != null ? lookupProperty(stack1, "first") : stack1, {
      "name": "if",
      "hash": {},
      "fn": container.program(12, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 75,
          "column": 4
        },
        "end": {
          "line": 77,
          "column": 11
        }
      }
    })) != null ? stack1 : "") + ((stack1 = lookupProperty(helpers, "if").call(alias3, (stack1 = (stack1 = depth0 != null ? lookupProperty(depth0, "rows") : depth0) != null ? lookupProperty(stack1, "links") : stack1) != null ? lookupProperty(stack1, "previous") : stack1, {
      "name": "if",
      "hash": {},
      "fn": container.program(14, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 78,
          "column": 4
        },
        "end": {
          "line": 80,
          "column": 11
        }
      }
    })) != null ? stack1 : "") + ((stack1 = lookupProperty(helpers, "if").call(alias3, (stack1 = (stack1 = depth0 != null ? lookupProperty(depth0, "rows") : depth0) != null ? lookupProperty(stack1, "links") : stack1) != null ? lookupProperty(stack1, "next") : stack1, {
      "name": "if",
      "hash": {},
      "fn": container.program(16, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 81,
          "column": 4
        },
        "end": {
          "line": 83,
          "column": 11
        }
      }
    })) != null ? stack1 : "") + ((stack1 = lookupProperty(helpers, "if").call(alias3, (stack1 = (stack1 = depth0 != null ? lookupProperty(depth0, "rows") : depth0) != null ? lookupProperty(stack1, "links") : stack1) != null ? lookupProperty(stack1, "last") : stack1, {
      "name": "if",
      "hash": {},
      "fn": container.program(18, data, 0, blockParams, depths),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 84,
          "column": 4
        },
        "end": {
          "line": 86,
          "column": 11
        }
      }
    })) != null ? stack1 : "") + "			</td>\n		</tfoot>\n	</table>\n</div>";
  },
  "useData": true,
  "useDepths": true
});
this.Mura.templates.textarea = this.Mura.Handlebars.template({
  "1": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return container.escapeExpression((helper = (helper = lookupProperty(helpers, "summary") || (depth0 != null ? lookupProperty(depth0, "summary") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "summary",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 67
        },
        "end": {
          "line": 2,
          "column": 78
        }
      }
    }) : helper));
  },
  "3": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return container.escapeExpression((helper = (helper = lookupProperty(helpers, "label") || (depth0 != null ? lookupProperty(depth0, "label") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "label",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 86
        },
        "end": {
          "line": 2,
          "column": 95
        }
      }
    }) : helper));
  },
  "5": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return " <ins>" + container.escapeExpression((helper = (helper = lookupProperty(helpers, "formRequiredLabel") || (depth0 != null ? lookupProperty(depth0, "formRequiredLabel") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "formRequiredLabel",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 126
        },
        "end": {
          "line": 2,
          "column": 147
        }
      }
    }) : helper)) + "</ins>";
  },
  "7": function _(container, depth0, helpers, partials, data) {
    return "</br>";
  },
  "9": function _(container, depth0, helpers, partials, data) {
    return " aria-required=\"true\"";
  },
  "11": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return " placeholder=\"" + container.escapeExpression((helper = (helper = lookupProperty(helpers, "placeholder") || (depth0 != null ? lookupProperty(depth0, "placeholder") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "placeholder",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 117
        },
        "end": {
          "line": 4,
          "column": 132
        }
      }
    }) : helper)) + "\"";
  },
  "compiler": [8, ">= 4.3.0"],
  "main": function main(container, depth0, helpers, partials, data) {
    var stack1,
        helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "<div class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "inputWrapperClass") || (depth0 != null ? lookupProperty(depth0, "inputWrapperClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "inputWrapperClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 12
        },
        "end": {
          "line": 1,
          "column": 35
        }
      }
    }) : helper)) != null ? stack1 : "") + "\" id=\"field-" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 47
        },
        "end": {
          "line": 1,
          "column": 55
        }
      }
    }) : helper)) + "-container\">\r\n	<label for=\"" + alias4((helper = (helper = lookupProperty(helpers, "labelForValue") || (depth0 != null ? lookupProperty(depth0, "labelForValue") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "labelForValue",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 13
        },
        "end": {
          "line": 2,
          "column": 30
        }
      }
    }) : helper)) + "\" data-for=\"" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 42
        },
        "end": {
          "line": 2,
          "column": 50
        }
      }
    }) : helper)) + "\">" + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "summary") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(1, data, 0),
      "inverse": container.program(3, data, 0),
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 52
        },
        "end": {
          "line": 2,
          "column": 102
        }
      }
    })) != null ? stack1 : "") + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "isrequired") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(5, data, 0),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 102
        },
        "end": {
          "line": 2,
          "column": 160
        }
      }
    })) != null ? stack1 : "") + "</label>\r\n	" + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "summary") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(7, data, 0),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 3,
          "column": 1
        },
        "end": {
          "line": 3,
          "column": 28
        }
      }
    })) != null ? stack1 : "") + "\r\n	<textarea " + ((stack1 = (helper = (helper = lookupProperty(helpers, "commonInputAttributes") || (depth0 != null ? lookupProperty(depth0, "commonInputAttributes") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "commonInputAttributes",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 11
        },
        "end": {
          "line": 4,
          "column": 38
        }
      }
    }) : helper)) != null ? stack1 : "") + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "isrequired") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(9, data, 0),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 38
        },
        "end": {
          "line": 4,
          "column": 84
        }
      }
    })) != null ? stack1 : "") + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "placeholder") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(11, data, 0),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 84
        },
        "end": {
          "line": 4,
          "column": 140
        }
      }
    })) != null ? stack1 : "") + ">" + alias4((helper = (helper = lookupProperty(helpers, "value") || (depth0 != null ? lookupProperty(depth0, "value") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "value",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 141
        },
        "end": {
          "line": 4,
          "column": 150
        }
      }
    }) : helper)) + "</textarea>\r\n</div>\r\n";
  },
  "useData": true
});
this.Mura.templates.textblock = this.Mura.Handlebars.template({
  "compiler": [8, ">= 4.3.0"],
  "main": function main(container, depth0, helpers, partials, data) {
    var stack1,
        helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "<div class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "inputWrapperClass") || (depth0 != null ? lookupProperty(depth0, "inputWrapperClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "inputWrapperClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 12
        },
        "end": {
          "line": 1,
          "column": 35
        }
      }
    }) : helper)) != null ? stack1 : "") + "\" id=\"field-" + container.escapeExpression((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 47
        },
        "end": {
          "line": 1,
          "column": 55
        }
      }
    }) : helper)) + "-container\">\r\n<div class=\"mura-form-text\">" + ((stack1 = (helper = (helper = lookupProperty(helpers, "value") || (depth0 != null ? lookupProperty(depth0, "value") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "value",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 28
        },
        "end": {
          "line": 2,
          "column": 39
        }
      }
    }) : helper)) != null ? stack1 : "") + "</div>\r\n</div>\r\n";
  },
  "useData": true
});
this.Mura.templates.textfield = this.Mura.Handlebars.template({
  "1": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return container.escapeExpression((helper = (helper = lookupProperty(helpers, "summary") || (depth0 != null ? lookupProperty(depth0, "summary") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "summary",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 67
        },
        "end": {
          "line": 2,
          "column": 78
        }
      }
    }) : helper));
  },
  "3": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return container.escapeExpression((helper = (helper = lookupProperty(helpers, "label") || (depth0 != null ? lookupProperty(depth0, "label") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "label",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 86
        },
        "end": {
          "line": 2,
          "column": 95
        }
      }
    }) : helper));
  },
  "5": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return " <ins>" + container.escapeExpression((helper = (helper = lookupProperty(helpers, "formRequiredLabel") || (depth0 != null ? lookupProperty(depth0, "formRequiredLabel") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "formRequiredLabel",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 126
        },
        "end": {
          "line": 2,
          "column": 147
        }
      }
    }) : helper)) + "</ins>";
  },
  "7": function _(container, depth0, helpers, partials, data) {
    return "</br>";
  },
  "9": function _(container, depth0, helpers, partials, data) {
    return " aria-required=\"true\"";
  },
  "11": function _(container, depth0, helpers, partials, data) {
    var helper,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return " placeholder=\"" + container.escapeExpression((helper = (helper = lookupProperty(helpers, "placeholder") || (depth0 != null ? lookupProperty(depth0, "placeholder") : depth0)) != null ? helper : container.hooks.helperMissing, typeof helper === "function" ? helper.call(depth0 != null ? depth0 : container.nullContext || {}, {
      "name": "placeholder",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 164
        },
        "end": {
          "line": 4,
          "column": 179
        }
      }
    }) : helper)) + "\"";
  },
  "compiler": [8, ">= 4.3.0"],
  "main": function main(container, depth0, helpers, partials, data) {
    var stack1,
        helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "<div class=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "inputWrapperClass") || (depth0 != null ? lookupProperty(depth0, "inputWrapperClass") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "inputWrapperClass",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 12
        },
        "end": {
          "line": 1,
          "column": 35
        }
      }
    }) : helper)) != null ? stack1 : "") + "\" id=\"field-" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 1,
          "column": 47
        },
        "end": {
          "line": 1,
          "column": 55
        }
      }
    }) : helper)) + "-container\">\r\n	<label for=\"" + alias4((helper = (helper = lookupProperty(helpers, "labelForValue") || (depth0 != null ? lookupProperty(depth0, "labelForValue") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "labelForValue",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 13
        },
        "end": {
          "line": 2,
          "column": 30
        }
      }
    }) : helper)) + "\" data-for=\"" + alias4((helper = (helper = lookupProperty(helpers, "name") || (depth0 != null ? lookupProperty(depth0, "name") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "name",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 42
        },
        "end": {
          "line": 2,
          "column": 50
        }
      }
    }) : helper)) + "\">" + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "summary") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(1, data, 0),
      "inverse": container.program(3, data, 0),
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 52
        },
        "end": {
          "line": 2,
          "column": 102
        }
      }
    })) != null ? stack1 : "") + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "isrequired") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(5, data, 0),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 2,
          "column": 102
        },
        "end": {
          "line": 2,
          "column": 160
        }
      }
    })) != null ? stack1 : "") + "</label>\r\n	" + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "summary") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(7, data, 0),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 3,
          "column": 1
        },
        "end": {
          "line": 3,
          "column": 28
        }
      }
    })) != null ? stack1 : "") + "\r\n	<input type=\"" + ((stack1 = (helper = (helper = lookupProperty(helpers, "textInputTypeValue") || (depth0 != null ? lookupProperty(depth0, "textInputTypeValue") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "textInputTypeValue",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 14
        },
        "end": {
          "line": 4,
          "column": 38
        }
      }
    }) : helper)) != null ? stack1 : "") + "\" " + ((stack1 = (helper = (helper = lookupProperty(helpers, "commonInputAttributes") || (depth0 != null ? lookupProperty(depth0, "commonInputAttributes") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "commonInputAttributes",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 40
        },
        "end": {
          "line": 4,
          "column": 67
        }
      }
    }) : helper)) != null ? stack1 : "") + " value=\"" + alias4((helper = (helper = lookupProperty(helpers, "value") || (depth0 != null ? lookupProperty(depth0, "value") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "value",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 75
        },
        "end": {
          "line": 4,
          "column": 84
        }
      }
    }) : helper)) + "\"" + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "isrequired") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(9, data, 0),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 85
        },
        "end": {
          "line": 4,
          "column": 131
        }
      }
    })) != null ? stack1 : "") + ((stack1 = lookupProperty(helpers, "if").call(alias1, depth0 != null ? lookupProperty(depth0, "placeholder") : depth0, {
      "name": "if",
      "hash": {},
      "fn": container.program(11, data, 0),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 4,
          "column": 131
        },
        "end": {
          "line": 4,
          "column": 187
        }
      }
    })) != null ? stack1 : "") + "/>\r\n</div>\r\n";
  },
  "useData": true
});
this.Mura.templates.view = this.Mura.Handlebars.template({
  "1": function _(container, depth0, helpers, partials, data) {
    var helper,
        alias1 = depth0 != null ? depth0 : container.nullContext || {},
        alias2 = container.hooks.helperMissing,
        alias3 = "function",
        alias4 = container.escapeExpression,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "	<li>\n		<strong>" + alias4((helper = (helper = lookupProperty(helpers, "displayName") || (depth0 != null ? lookupProperty(depth0, "displayName") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "displayName",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 5,
          "column": 10
        },
        "end": {
          "line": 5,
          "column": 25
        }
      }
    }) : helper)) + ": </strong> " + alias4((helper = (helper = lookupProperty(helpers, "displayValue") || (depth0 != null ? lookupProperty(depth0, "displayValue") : depth0)) != null ? helper : alias2, _typeof(helper) === alias3 ? helper.call(alias1, {
      "name": "displayValue",
      "hash": {},
      "data": data,
      "loc": {
        "start": {
          "line": 5,
          "column": 37
        },
        "end": {
          "line": 5,
          "column": 53
        }
      }
    }) : helper)) + " \n	</li>\n";
  },
  "compiler": [8, ">= 4.3.0"],
  "main": function main(container, depth0, helpers, partials, data) {
    var stack1,
        lookupProperty = container.lookupProperty || function (parent, propertyName) {
      if (Object.prototype.hasOwnProperty.call(parent, propertyName)) {
        return parent[propertyName];
      }

      return undefined;
    };

    return "<div class=\"mura-control-group\">\n<ul>\n" + ((stack1 = (lookupProperty(helpers, "eachProp") || depth0 && lookupProperty(depth0, "eachProp") || container.hooks.helperMissing).call(depth0 != null ? depth0 : container.nullContext || {}, depth0, {
      "name": "eachProp",
      "hash": {},
      "fn": container.program(1, data, 0),
      "inverse": container.noop,
      "data": data,
      "loc": {
        "start": {
          "line": 3,
          "column": 0
        },
        "end": {
          "line": 7,
          "column": 13
        }
      }
    })) != null ? stack1 : "") + "</ul>\n<button type=\"button\" class=\"nav-back\">Back</button>\n</div>";
  },
  "useData": true
});

/***/ }),

/***/ 4654:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var Mura = __webpack_require__(791);

var Handlebars = __webpack_require__(6834);

Mura.Handlebars = Handlebars.create();
Mura.templatesLoaded = false;
Handlebars.noConflict();
Mura.templates = Mura.templates || {};

Mura.templates['meta'] = function (context) {
  if (typeof context.labeltag == 'undefined' || !context.labeltag) {
    context.labeltag = 'h2';
  }

  if (context.label) {
    return '<div class="mura-object-meta-wrapper"><div class="mura-object-meta"><' + Mura.escapeHTML(context.labeltag) + '>' + Mura.escapeHTML(context.label) + '</' + Mura.escapeHTML(context.labeltag) + '></div></div><div class="mura-flex-break"></div>';
  } else {
    return '';
  }
};

Mura.templates['content'] = function (context) {
  var html = context.html || context.content || context.source || '';

  if (Array.isArray(html)) {
    html = '';
  }

  return '<div class="mura-object-content">' + html + '</div>';
};

Mura.templates['text'] = function (context) {
  context = context || {};

  if (context.label) {
    context.source = context.source || '';
  } else {
    context.source = context.source || '<p></p>';
  }

  return context.source;
};

Mura.templates['embed'] = function (context) {
  context = context || {};

  if (context.source) {
    context.source = context.source || '';
  } else {
    context.source = context.source || '<p></p>';
  }

  return context.source;
};

Mura.templates['image'] = function (context) {
  context = context || {};
  context.src = context.src || '';
  context.alt = context.alt || '';
  context.caption = context.caption || '';
  context.imagelink = context.imagelink || '';
  context.fit = context.fit || '';
  var source = '';
  var style = '';

  if (!context.src) {
    return '';
  }

  if (context.fit) {
    style = ' style="height:100%;width:100%;object-fit:' + Mura.escapeHTML(context.fit) + ';" data-object-fit="' + Mura.escapeHTML(context.fit) + '" ';
  }

  source = '<img src="' + Mura.escapeHTML(context.src) + '" alt="' + Mura.escapeHTML(context.alt) + '"' + style + ' loading="lazy"/>';

  if (context.imagelink) {
    context.imagelinktarget = context.imagelinktarget || "";
    var targetString = "";

    if (context.imagelinktarget) {
      targetString = ' target="' + Mura.escapeHTML(context.imagelinktarget) + '"';
    }

    source = '<a href="' + Mura.escapeHTML(context.imagelink) + '"' + targetString + '/>' + source + '</a>';
  }

  if (context.caption && context.caption != '<p></p>') {
    source += '<figcaption>' + context.caption + '</figcaption>';
  }

  source = '<figure style="margin:0px">' + source + '</figure>';
  return source;
};

__webpack_require__(379);

/***/ }),

/***/ 324:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var Mura = __webpack_require__(791);
/**
 * Creates a new Mura.UI.Collection
 * @name  Mura.UI.Collection
 * @class
 * @extends Mura.UI
 * @memberof  Mura
 */


Mura.UI.Collection = Mura.UI.extend(
/** @lends Mura.UI.Collection.prototype */
{
  defaultLayout: "List",
  layoutInstance: '',
  getLayoutInstance: function getLayoutInstance() {
    if (this.layoutInstance) {
      this.layoutInstance.destroy();
    }

    this.layoutInstance = new Mura.Module[this.context.layout](this.context);
    return this.layoutInstance;
  },
  getCollection: function getCollection() {
    var self = this;

    if (typeof this.context.feed != 'undefined' && typeof this.context.feed.getQuery != 'undefined') {
      return this.context.feed.getQuery();
    } else {
      this.context.source = this.context.source || '';

      if (typeof this.context.nextn != 'undefined') {
        this.context.itemsperpage = this.context.nextn;
      }

      if (typeof this.context.maxitems == 'undefined') {
        this.context.maxitems = 20;
      }

      if (typeof this.context.itemsperpage != 'undefined') {
        this.context.itemsperpage = this.context.nextn;
      }

      if (typeof this.context.expand == 'undefined') {
        this.context.expand = '';
      }

      if (typeof this.context.expanddepth == 'undefined') {
        this.context.expanddepth = 1;
      }

      if (typeof this.context.fields == 'undefined') {
        this.context.fields = '';
      }

      if (typeof this.context.rawcollection != 'undefined') {
        return new Promise(function (resolve, reject) {
          resolve(new Mura.EntityCollection(self.context.rawcollection, Mura._requestcontext));
        });
      } else if (this.context.sourcetype == 'relatedcontent') {
        if (this.context.source == 'custom') {
          if (typeof this.context.items != 'undefined') {
            this.context.items = this.context.items.join();
          }

          if (!this.context.items) {
            this.context.items = Mura.createUUID();
          }

          return Mura.get(Mura.getAPIEndpoint() + 'content', {
            id: this.context.items,
            itemsperpage: this.context.itemsperpage,
            maxitems: this.context.maxitems,
            expand: this.context.expand,
            expanddepth: this.context.expanddepth,
            fields: this.context.fields
          }).then(function (resp) {
            return new Mura.EntityCollection(resp.data, Mura._requestcontext);
          });
        } else if (this.context.source == 'reverse') {
          return Mura.getEntity('content').set({
            'contentid': Mura.contentid,
            'id': Mura.contentid
          }).getRelatedContent('reverse', {
            itemsperpage: this.context.itemsperpage,
            maxitems: this.context.maxitems,
            sortby: this.context.sortby,
            expand: this.context.expand,
            expanddepth: this.context.expanddepth,
            fields: this.context.fields
          });
        } else {
          return Mura.getEntity('content').set({
            'contentid': Mura.contentid,
            'id': Mura.contentid
          }).getRelatedContent(this.context.source, {
            itemsperpage: this.context.itemsperpage,
            maxitems: this.context.maxitems,
            expand: this.context.expand,
            expanddepth: this.context.expanddepth,
            fields: this.context.fields
          });
        }
      } else if (this.context.sourcetype == 'children') {
        return Mura.getFeed('content').where().prop('parentid').isEQ(Mura.contentid).maxItems(100).itemsPerPage(this.context.itemsperpage).expand(this.context.expand).expandDepth(this.context.expanddepth).fields(this.context.fields).getQuery();
      } else {
        return Mura.getFeed('content').where().prop('feedid').isEQ(this.context.source).maxItems(this.context.maxitems).itemsPerPage(this.context.itemsperpage).expand(this.context.expand).expandDepth(this.context.expand).fields(this.context.fields).getQuery();
      }
    }
  },
  renderClient: function renderClient() {
    if (typeof Mura.Module[this.context.layout] == 'undefined') {
      this.context.layout = Mura.firstToUpperCase(this.context.layout);
    }

    if (typeof Mura.Module[this.context.layout] == 'undefined' && Mura.Module[this.defaultLayout] != 'undefined') {
      this.context.layout = this.defaultLayout;
    }

    var self = this;

    if (typeof Mura.Module[this.context.layout] != 'undefined') {
      this.getCollection().then(function (collection) {
        self.context.collection = collection;
        self.getLayoutInstance().renderClient();
      });
    } else {
      this.context.targetEl.innerHTML = "This collection has an undefined layout";
    }

    this.trigger('afterRender');
  },
  renderServer: function renderServer() {
    //has implementation in ui.serverutils
    return '';
  },
  destroy: function destroy() {
    //has implementation in ui.serverutils
    if (this.layoutInstance) {
      this.layoutInstance.destroy();
    }
  }
});
Mura.Module.Collection = Mura.UI.Collection;

/***/ }),

/***/ 1711:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var Mura = __webpack_require__(791);
/**
 * Creates a new Mura.UI.Text
 * @name  Mura.UI.Container
 * @class
 * @extends Mura.UI
 * @memberof  Mura
 */


Mura.UI.Container = Mura.UI.extend(
/** @lends Mura.DisplayObject.Container.prototype */
{
  renderClient: function renderClient() {
    var target = Mura(this.context.targetEl);

    if (typeof this.context.items != 'undefined' && !Array.isArray(this.context.items)) {
      try {
        this.context.items = JSON.parse(this.context.items);
      } catch (_unused) {
        console.log(this.context.items);
        delete this.context.items;
      }
    }

    if (!Array.isArray(this.context.items)) {
      this.context.content = this.context.content || '';
      target.html(this.context.content);
    } else {
      this.context.items = this.context.items || [];
      this.context.items.forEach(function (data) {
        //console.log(data)
        data.transient = false;

        if (!Mura.cloning) {
          data.preserveid = true;
        }

        target.appendDisplayObject(data);
        delete data.preserveid;
      });
    }

    this.trigger('afterRender');
  },
  reset: function reset(self, empty) {
    if (empty) {
      self.find('.mura-object:not([data-object="container"])').html('');
      self.find('.frontEndToolsModal').remove();
      self.find('.mura-object-meta').html('');
    }

    var content = self.children('div.mura-object-content');

    if (content.length) {
      var nestedObjects = [];
      content.children('.mura-object').each(function () {
        Mura.resetAsyncObject(this, empty); //console.log(Mura(this).data())

        nestedObjects.push(Mura(this).data());
      });
      self.data('items', JSON.stringify(nestedObjects));
      self.removeAttr('data-content');
    }
  }
});
Mura.DisplayObject.Container = Mura.UI.Container;

/***/ }),

/***/ 397:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var Mura = __webpack_require__(791);
/**
 * Creates a new Mura.UI.Embed
 * @name  Mura.UI.Embed
 * @class
 * @extends Mura.UI
 * @memberof  Mura
 */


Mura.UI.Embed = Mura.UI.extend(
/** @lends Mura.DisplayObject.Embed.prototype */
{
  renderClient: function renderClient() {
    Mura(this.context.targetEl).html(Mura.templates['embed'](this.context));
    this.trigger('afterRender');
  },
  renderServer: function renderServer() {
    return Mura.templates['embed'](this.context);
  }
});
Mura.DisplayObject.Embed = Mura.UI.Embed;

/***/ }),

/***/ 5086:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

function _typeof(obj) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (obj) { return typeof obj; } : function (obj) { return obj && "function" == typeof Symbol && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }, _typeof(obj); }

var Mura = __webpack_require__(791);
/**
 * Creates a new Mura.UI.Form
 * @name	Mura.UI.Form
 * @class
 * @extends Mura.UI
 * @memberof	Mura
 */


Mura.UI.Form = Mura.UI.extend(
/** @lends Mura.DisplayObject.Form.prototype */
{
  context: {},
  ormform: false,
  formJSON: {},
  data: {},
  columns: [],
  currentpage: 0,
  entity: {},
  fields: {},
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
    generalwrapperclass: "well",
    generalwrapperbodyclass: "",
    formwrapperclass: "well",
    formwrapperbodyclass: "",
    formfieldwrapperclass: "control-group",
    formfieldlabelclass: "control-label",
    formerrorwrapperclass: "",
    formresponsewrapperclass: "",
    formgeneralcontrolclass: "form-control",
    forminputclass: "form-control",
    formselectclass: "form-control",
    formtextareaclass: "form-control",
    formfileclass: "form-control",
    formtextblockclass: "form-control",
    formcheckboxclass: "",
    formcheckboxlabelclass: "checkbox",
    formcheckboxwrapperclass: "",
    formradioclass: "",
    formradiowrapperclass: "",
    formradiolabelclass: "radio",
    formbuttonwrapperclass: "btn-group",
    formbuttoninnerclass: "",
    formbuttonclass: "btn btn-default",
    formrequiredwrapperclass: "",
    formbuttonsubmitclass: "form-submit",
    formbuttonsubmitlabel: "Submit",
    formbuttonsubmitwaitlabel: "Please Wait...",
    formbuttonnextclass: "form-nav",
    formbuttonnextlabel: "Next",
    formbuttonbackclass: "form-nav",
    formbuttonbacklabel: "Back",
    formbuttoncancelclass: "btn-primary pull-right",
    formbuttoncancellabel: "Cancel",
    formrequiredlabel: "Required",
    formfileplaceholder: "Select File"
  },
  renderClient: function renderClient() {
    if (this.context.mode == undefined) {
      this.context.mode = 'form';
    }

    var ident = "mura-form-" + this.context.instanceid;
    this.context.formEl = "#" + ident;
    this.context.html = "<div id='" + ident + "'></div>";
    Mura(this.context.targetEl).html(this.context.html);

    if (this.context.view == 'form') {
      this.getForm();
    } else {
      this.getList();
    }

    return this;
  },
  getTemplates: function getTemplates() {
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
    			success(data) {
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
  getPageFieldList: function getPageFieldList() {
    var page = this.currentpage;
    var fields = this.formJSON.form.pages[page];
    var result = [];

    for (var f = 0; f < fields.length; f++) {
      //console.log("add: " + self.formJSON.form.fields[fields[f]].name);
      result.push(this.formJSON.form.fields[fields[f]].name);
    } //console.log(result);


    return result.join(',');
  },
  renderField: function renderField(fieldtype, field) {
    var self = this;
    var templates = Mura.templates;
    var template = fieldtype;
    if (field.datasetid != "" && self.isormform) field.options = self.formJSON.datasets[field.datasetid].options;else if (field.datasetid != "") {
      field.dataset = self.formJSON.datasets[field.datasetid];
    }
    self.setDefault(fieldtype, field);

    if (fieldtype == "nested") {
      var nested_context = {};
      nested_context.objectid = field.formid;
      nested_context.paging = 'single';
      nested_context.mode = 'nested';
      nested_context.prefix = field.name + '_';
      nested_context.master = this;
      var data = {};
      data.objectid = nested_context.objectid;
      data.formid = nested_context.objectid;
      data.object = 'form';
      data.siteid = self.context.siteid || Mura.siteid;
      data.contentid = Mura.contentid;
      data.contenthistid = Mura.contenthistid;
      Mura.get(Mura.getAPIEndpoint() + '?method=processAsyncObject', data).then(function (resp) {
        var tempContext = Mura.extend({}, nested_context);
        delete tempContext.targetEl;
        var context = Mura.deepExtend({}, tempContext, resp.data);
        context.targetEl = self.context.targetEl;
        Mura(".field-container-" + self.context.objectid, self.context.formEl).append('<div id="nested-' + field.formid + '"></div>');
        var nestedForm = new Mura.UI.Form(context);
        context.formEl = document.getElementById('nested-' + field.formid);
        nestedForm.getForm(); // var html = Mura.templates[template](field);
        // Mura(".field-container-" + self.context.objectid,self.context.formEl).append(html);
      });
    } else {
      if (fieldtype == "checkbox") {
        if (self.ormform) {
          field.selected = [];
          var ds = self.formJSON.datasets[field.datasetid];

          for (var i in ds.datarecords) {
            if (ds.datarecords[i].selected && ds.datarecords[i].selected == 1) field.selected.push(i);
          }

          field.selected = field.selected.join(",");
        } else {
          template = template + "_static";
        }
      } else if (fieldtype == "dropdown") {
        if (!self.ormform) {
          template = template + "_static";
        }
      } else if (fieldtype == "radio") {
        if (!self.ormform) {
          template = template + "_static";
        }
      } else if (fieldtype == "section") { 
        if(field.fieldsetopen === '1') {
          field.label = '';
          if(self.fieldsetIsOpen === true) {
            Mura(".field-container-" + self.context.objectid, self.context.formEl).append('<!--close-fieldset-->');
          }
          self.fieldsetIsOpen = true;

          Mura(".field-container-" + self.context.objectid, self.context.formEl).append('<!--open-fieldset-label: |' + field.fieldsetid + '| --->');    
        }
      }

      try {
      var html = Mura.templates[template](field);
      } catch (e) {
        console.log("ERROR",e,field);
      }
      Mura(".field-container-" + self.context.objectid, self.context.formEl).append(html);
    }
  },
  setDefault: function setDefault(fieldtype, field) {
    var self = this;

    switch (fieldtype) {
      case "textfield":
      case "textarea":
        if (self.data[self.context.prefix + field.name]) {
          field.value = self.data[self.context.prefix + field.name];
        }

        break;

      case "checkbox":
        var ds = self.formJSON.datasets[field.datasetid];

        for (var i = 0; i < ds.datarecords.length; i++) {
          if (self.ormform) {
            var sourceid = ds.source + "id";
            ds.datarecords[i].selected = 0;
            ds.datarecords[i].isselected = 0;

            if (self.data[self.context.prefix + field.name].items && self.data[self.context.prefix + field.name].items.length) {
              for (var x = 0; x < self.data[self.context.prefix + field.name].items.length; x++) {
                if (ds.datarecords[i].id == self.data[self.context.prefix + field.name].items[x][sourceid]) {
                  ds.datarecords[i].isselected = 1;
                  ds.datarecords[i].selected = 1;
                }
              }
            }
          } else {
            if (self.data[self.context.prefix + field.name] && ds.datarecords[i].value && self.data[self.context.prefix + field.name].indexOf(ds.datarecords[i].value) > -1) {
              ds.datarecords[i].isselected = 1;
              ds.datarecords[i].selected = 1;
            } else {
              ds.datarecords[i].selected = 0;
              ds.datarecords[i].isselected = 0;
            }
          }
        }

        break;

      case "radio":
      case "dropdown":
        var ds = self.formJSON.datasets[field.datasetid];

        for (var i = 0; i < ds.datarecords.length; i++) {
          if (self.ormform) {
            if (ds.datarecords[i].id == self.data[field.name + 'id']) {
              ds.datarecords[i].isselected = 1;
              field.selected = self.data[field.name + 'id'];
            } else {
              ds.datarecords[i].selected = 0;
              ds.datarecords[i].isselected = 0;
            }
          } else {
            if (ds.datarecords[i].value == self.data[self.context.prefix + field.name]) {
              ds.datarecords[i].isselected = 1;
              field.selected = self.data[self.context.prefix + field.name];
            } else {
              ds.datarecords[i].isselected = 0;
            }
          }
        }

        break;
    }
  },
  renderData: function renderData() {
    var self = this;

    if (self.datasets.length == 0) {
      if (self.renderqueue == 0) {
        self.renderForm();
      }

      return;
    }

    var dataset = self.formJSON.datasets[self.datasets.pop()];

    if (dataset.sourcetype && dataset.sourcetype != 'muraorm') {
      self.renderData();
      return;
    }

    if (dataset.sourcetype == 'muraorm') {
      dataset.options = [];
      self.renderqueue++;
      Mura.getFeed(dataset.source).getQuery().then(function (collection) {
        collection.each(function (item) {
          var itemid = item.get('id');
          dataset.datarecordorder.push(itemid);
          dataset.datarecords[itemid] = item.getAll();
          dataset.datarecords[itemid]['value'] = itemid;
          dataset.datarecords[itemid]['datarecordid'] = itemid;
          dataset.datarecords[itemid]['datasetid'] = dataset.datasetid;
          dataset.datarecords[itemid]['isselected'] = 0;
          dataset.options.push(dataset.datarecords[itemid]);
        });
      }).then(function () {
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
  renderForm: function renderForm() {
    var self = this; //console.log("render form: " + self.currentpage);

    if (typeof self.context.prefix == 'undefined') {
      self.context.prefix = '';
    }

    Mura(".field-container-" + self.context.objectid, self.context.formEl).empty();

    if (!self.formInit) {
      self.initForm();
    }

    var fields = self.formJSON.form.pages[self.currentpage];

    self.fieldsetIsOpen = false;

    for (var i = 0; i < fields.length; i++) {
      var field = self.formJSON.form.fields[fields[i]]; //try {

      if (field.fieldtype.fieldtype != undefined && field.fieldtype.fieldtype != "") {
        self.renderField(field.fieldtype.fieldtype, field);
      }
    }
   if(self.fieldsetIsOpen) {
      Mura(".field-container-" + self.context.objectid, self.context.formEl).append('<!--close-fieldset-->');
   }

   var selector = `.field-container-${self.context.objectid}`;
   var container = document.querySelector(selector);
   var htmlContent = container.innerHTML;

   htmlContent = htmlContent.replace(/<!--open-fieldset-label: \|(.+?)\| --->/g, '<fieldset id="$1">');
   htmlContent = htmlContent.replace(/<!--close-fieldset-->/g, '</fieldset>');

   container.innerHTML = htmlContent;



    if (self.ishuman && self.currentpage == self.formJSON.form.pages.length - 1) {
      Mura(".field-container-" + self.context.objectid, self.context.formEl).append(self.ishuman);
    }

    if (self.context.mode == 'form') {
      self.renderPaging();
    }

    Mura.processMarkup(".field-container-" + self.context.objectid, self.context.formEl);
    self.trigger('afterRender');
  },
  renderPaging: function renderPaging() {
    var self = this;
    var submitlabel = typeof self.formJSON.form.formattributes != 'undefined' && typeof self.formJSON.form.formattributes.submitlabel != 'undefined' && self.formJSON.form.formattributes.submitlabel ? self.formJSON.form.formattributes.submitlabel : self.rb.formbuttonsubmitlabel;
    Mura(".error-container-" + self.context.objectid, self.context.formEl).empty();
    Mura(".paging-container-" + self.context.objectid, self.context.formEl).empty();

    if (self.formJSON.form.pages.length == 1) {
      Mura(".paging-container-" + self.context.objectid, self.context.formEl).append(Mura.templates['paging']({
        page: self.currentpage + 1,
        label: submitlabel,
        "class": Mura.trim("mura-form-submit " + self.rb.formbuttonsubmitclass)
      }));
    } else {
      if (self.currentpage == 0) {
        Mura(".paging-container-" + self.context.objectid, self.context.formEl).append(Mura.templates['paging']({
          page: 1,
          label: self.rb.formbuttonnextlabel,
          "class": Mura.trim("mura-form-nav mura-form-next " + self.rb.formbuttonnextclass)
        }));
      } else {
        Mura(".paging-container-" + self.context.objectid, self.context.formEl).append(Mura.templates['paging']({
          page: self.currentpage - 1,
          label: self.rb.formbuttonbacklabel,
          "class": Mura.trim("mura-form-nav mura-form-back " + self.rb.formbuttonbackclass)
        }));

        if (self.currentpage + 1 < self.formJSON.form.pages.length) {
          Mura(".paging-container-" + self.context.objectid, self.context.formEl).append(Mura.templates['paging']({
            page: self.currentpage + 1,
            label: self.rb.formbuttonnextlabel,
            "class": Mura.trim("mura-form-nav mura-form-next " + self.rb.formbuttonnextclass)
          }));
        } else {
          Mura(".paging-container-" + self.context.objectid, self.context.formEl).append(Mura.templates['paging']({
            page: self.currentpage + 1,
            label: submitlabel,
            "class": Mura.trim("mura-form-submit " + self.rb.formbuttonsubmitclass)
          }));
        }
      }

      if (self.backlink != undefined && self.backlink.length) Mura(".paging-container-" + self.context.objectid, self.context.formEl).append(Mura.templates['paging']({
        page: self.currentpage + 1,
        label: self.rb.formbuttoncancellabel,
        "class": Mura.trim("mura-form-nav mura-form-cancel " + self.rb.formbuttoncancelclass)
      }));
    }

    var submitHandler = function submitHandler() {
      self.submitForm();
    };

    Mura(".mura-form-submit", self.context.formEl).off('click', submitHandler).on('click', submitHandler);
    Mura(".mura-form-cancel", self.context.formEl).click(function () {
      self.getTableData(self.backlink);
    });

    var formNavHandler = function formNavHandler(e) {
      if (Mura(e.target).is('.mura-form-submit')) {
        return;
      }

      self.setDataValues();
      var keepGoing = self.onPageSubmit.call(self.context.targetEl);

      if (typeof keepGoing != 'undefined' && !keepGoing) {
        return;
      }

      var button = this;

      if (self.ormform) {
        Mura.getEntity(self.entity).set(self.data).validate(self.getPageFieldList()).then(function (entity) {
          if (entity.hasErrors()) {
            self.showErrors(entity.properties.errors);
          } else {
            self.currentpage = Mura(button).data('page');
            self.renderForm();
          }
        });
      } else {
        var data = Mura.extend({}, self.data, self.context);
        data.validateform = true;
        data.formid = data.objectid;
        data.siteid = data.siteid || Mura.siteid;
        data.fields = self.getPageFieldList();
        delete data.filename;
        delete data.def;
        delete data.ishuman;
        delete data.targetEl;
        delete data.html;
        Mura.ajax({
          type: 'post',
          url: Mura.getAPIEndpoint() + '?method=generateCSRFTokens',
          data: {
            siteid: data.siteid,
            context: data.formid
          },
          success: function success(resp) {
            data['csrf_token_expires'] = resp.data['csrf_token_expires'];
            data['csrf_token'] = resp.data['csrf_token'];
            Mura.post(Mura.getAPIEndpoint() + '?method=processAsyncObject', data).then(function (resp) {
              if (_typeof(resp.data.errors) == 'object' && !Mura.isEmptyObject(resp.data.errors)) {
                self.showErrors(resp.data.errors);
              } else if (typeof resp.data.redirect != 'undefined') {
                if (resp.data.redirect && resp.data.redirect != location.href) {
                  location.href = resp.data.redirect;
                } else {
                  location.reload(true);
                }
              } else {
                self.currentpage = Mura(button).data('page');

                if (self.currentpage >= self.formJSON.form.pages.length) {
                  self.currentpage = self.formJSON.form.pages.length - 1;
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

    Mura(".mura-form-nav", self.context.formEl).off('click', formNavHandler).on('click', formNavHandler);

    var fileSelectorHandler = function fileSelectorHandler(e) {
      Mura(this).closest('.mura-form-file-container').find('input[type="file"]').trigger('click');
    };

    var fileChangeHandler = function fileChangeHandler(e) {
      var inputEl = Mura(this);
      var fn = inputEl.val().replace(/\\/g, '/').replace(/.*\//, '');
      var fnEl = Mura('.mura-newfile-filename[data-filename="' + inputEl.attr("name") + '"]').val(fn);
      var f = Mura('input[type="file"][data-filename="' + inputEl.attr("name") + '"]').node.files[0];
      var fImg = Mura('img#mura-form-preview-' + inputEl.attr("name"));
      var fUrl = ''; // file upload

      if (typeof f !== 'undefined') {
        fUrl = window.URL.createObjectURL(f);
        fnEl.val(fn);
        fImg.hide();

        if (f.type.indexOf('image') == 0 && fUrl.length) {
          fImg.attr('src', fUrl).show();
        }
      } else {
        fImg.attr('src', fUrl).hide();
      }
    };

    Mura(self.context.formEl).find('input[type="file"]').off('change', fileChangeHandler).on('change', fileChangeHandler);
    Mura(self.context.formEl).find('.mura-form-preview img, .mura-newfile-filename').off('click', fileSelectorHandler).on('click', fileSelectorHandler);
  },
  setDataValues: function setDataValues() {
    var self = this;
    var multi = {};
    var item = {};
    var valid = [];
    var currentPage = {};
    Mura(".field-container-" + self.context.objectid + " input, .field-container-" + self.context.objectid + " select, .field-container-" + self.context.objectid + " textarea").each(function () {
      currentPage[Mura(this).attr('name')] = true;

      if (Mura(this).is('[type="checkbox"]')) {
        if (multi[Mura(this).attr('name')] == undefined) multi[Mura(this).attr('name')] = [];

        if (this.checked) {
          if (self.ormform) {
            item = {};
            item['id'] = Mura.createUUID();
            item[self.entity + 'id'] = self.data.id;
            item[Mura(this).attr('source') + 'id'] = Mura(this).val();
            item['key'] = Mura(this).val();
            multi[Mura(this).attr('name')].push(item);
          } else {
            multi[Mura(this).attr('name')].push(Mura(this).val());
          }
        }
      } else if (Mura(this).is('[type="radio"]')) {
        if (this.checked) {
          self.data[Mura(this).attr('name')] = Mura(this).val();
          valid[Mura(this).attr('name')] = self.data[name];
        }
      } else {
        self.data[Mura(this).attr('name')] = Mura(this).val();
        valid[Mura(this).attr('name')] = self.data[Mura(this).attr('name')];
      }
    });

    for (var i in multi) {
      if (self.ormform) {
        self.data[i].cascade = "replace";
        self.data[i].items = multi[i];
        valid[i] = self.data[i];
      } else {
        self.data[i] = multi[i].join(",");
        valid[i] = multi[i].join(",");
      }
    }

    if (Mura.formdata) {
      var frm = document.getElementById('frm' + self.context.objectid);

      for (var p in currentPage) {
        if (currentPage.hasOwnProperty(p) && typeof self.data[p] != 'undefined') {
          if (p.indexOf("_attachment") > -1 && typeof frm[p] != 'undefined') {
            self.attachments[p] = frm[p].files[0];
          }
        }
      }
    }

    return valid;
  },
  validate: function validate(entity, fields) {
    return true;
  },
  getForm: function getForm(entityid, backlink) {
    var self = this;

    if (entityid != undefined) {
      self.entityid = entityid;
    } else {
      delete self.entityid;
    }

    if (backlink != undefined) {
      self.backlink = backlink;
    } else {
      delete self.backlink;
    }

    self.loadForm();
  },
  loadForm: function loadForm(data) {
    var self = this;
    var formJSON = JSON.parse(self.context.def); // old forms

    if (!formJSON.form.pages) {
      formJSON.form.pages = [];
      formJSON.form.pages[0] = formJSON.form.fieldorder;
      formJSON.form.fieldorder = [];
    }

    if (typeof formJSON.datasets != 'undefined') {
      for (var d in formJSON.datasets) {
        if (typeof formJSON.datasets[d].DATARECORDS != 'undefined') {
          formJSON.datasets[d].datarecords = formJSON.datasets[d].DATARECORDS;
          delete formJSON.datasets[d].DATARECORDS;
        }

        if (typeof formJSON.datasets[d].DATARECORDORDER != 'undefined') {
          formJSON.datasets[d].datarecordorder = formJSON.datasets[d].DATARECORDORDER;
          delete formJSON.datasets[d].DATARECORDORDER;
        }
      }
    }

    entityName = self.context.filename.replace(/\W+/g, "");
    self.entity = entityName;
    self.formJSON = formJSON;
    self.fields = formJSON.form.fields;
    self.responsemessage = self.context.responsemessage;
    self.ishuman = self.context.ishuman;

    if (formJSON.form.formattributes && formJSON.form.formattributes.Muraormentities == 1) {
      self.ormform = true;
    }

    for (var i = 0; i < self.formJSON.datasets; i++) {
      self.datasets.push(i);
    }

    if (self.ormform) {
      self.entity = entityName;

      if (self.entityid == undefined) {
        Mura.get(Mura.getAPIEndpoint() + '/' + entityName + '/new?expand=all&ishuman=true').then(function (resp) {
          self.data = resp.data;
          self.renderData();
        });
      } else {
        Mura.get(Mura.getAPIEndpoint() + '/' + entityName + '/' + self.entityid + '?expand=all&ishuman=true').then(function (resp) {
          self.data = resp.data;
          self.renderData();
        });
      }
    } else {
      self.renderData();
    }
  },
  initForm: function initForm() {
    var self = this;
    Mura(self.context.formEl).empty();

    if (self.context.mode != undefined && self.context.mode == 'nested') {
      var html = Mura.templates['nested'](self.context);
    } else {
      var html = Mura.templates['form'](self.context);
    }

    Mura(self.context.formEl).append(html);
    self.currentpage = 0;
    self.attachments = {};
    self.formInit = true;
    Mura.trackEvent({
      category: 'Form',
      action: 'Impression',
      label: self.context.name,
      objectid: self.context.objectid,
      nonInteraction: true
    });
  },
  onSubmit: function onSubmit() {
    return true;
  },
  onPageSubmit: function onPageSubmit() {
    return true;
  },
  submitForm: function submitForm() {
    var self = this;
    var valid = self.setDataValues();
    Mura(".error-container-" + self.context.objectid, self.context.formEl).empty();
    var keepGoing = this.onSubmit.call(this.context.targetEl);

    if (typeof keepGoing != 'undefined' && !keepGoing) {
      return;
    }

    delete self.data.isNew;
    var frm = Mura(self.context.formEl).find('form');
    frm.find('.mura-form-submit').html(self.rb.formbuttonsubmitwaitlabel);
    frm.trigger('formSubmit');

    if (self.ormform) {
      //console.log('a!');
      Mura.getEntity(self.entity).set(self.data).save().then(function (entity) {
        if (self.backlink != undefined) {
          self.getTableData(self.location);
          return;
        }

        if (typeof resp.data.redirect != 'undefined') {
          if (resp.data.redirect && resp.data.redirect != location.href) {
            location.href = resp.data.redirect;
          } else {
            location.reload(true);
          }
        } else {
          Mura(self.context.formEl).html(Mura.templates['success'](data));
          self.trigger('afterResponseRender');
        }
      }, function (entity) {
        self.showErrors(entity.properties.errors);
        self.trigger('afterErrorRender');
      });
    } else {
      //console.log('b!');
      if (!Mura.formdata) {
        var data = Mura.extend({}, self.context, self.data);
        data.saveform = true;
        data.formid = data.objectid;
        data.siteid = self.context.siteid || data.siteid || Mura.siteid;
        data.contentid = Mura.contentid || '';
        data.contenthistid = Mura.contenthistid || '';
        delete data.filename;
        delete data.def;
        delete data.ishuman;
        delete data.targetEl;
        delete data.html;

        if (data.responsechart) {
          var frm = Mura(self.context.targetEl);
          var polllist = new Array();
          frm.find("input[type='radio']").each(function () {
            polllist.push(Mura(this).val());
          });

          if (polllist.length > 0) {
            data.polllist = polllist.toString();
          }
        }

        var tokenArgs = {
          siteid: data.siteid,
          context: data.formid
        };
      } else {
        var rawdata = Mura.extend({}, self.context, self.data);
        rawdata.saveform = true;
        rawdata.formid = rawdata.objectid;
        rawdata.siteid = self.context.siteid || rawdata.siteid || Mura.siteid;
        rawdata.contentid = Mura.contentid || '';
        rawdata.contenthistid = Mura.contenthistid || '';
        delete rawdata.filename;
        delete rawdata.def;
        delete rawdata.ishuman;
        delete rawdata.targetEl;
        delete rawdata.html;
        var tokenArgs = {
          siteid: rawdata.siteid,
          context: rawdata.formid
        };

        if (rawdata.responsechart) {
          var frm = Mura(self.context.targetEl);
          var polllist = new Array();
          frm.find("input[type='radio']").each(function () {
            polllist.push(Mura(this).val());
          });

          if (polllist.length > 0) {
            rawdata.polllist = polllist.toString();
          }
        }

        var data = new FormData();

        for (var p in rawdata) {
          if (rawdata.hasOwnProperty(p)) {
            if (typeof self.attachments[p] != 'undefined') {
              data.append(p, self.attachments[p]);
            } else {
              data.append(p, rawdata[p]);
            }
          }
        }
      }

      Mura.ajax({
        type: 'post',
        url: Mura.getAPIEndpoint() + '?method=generateCSRFTokens',
        data: tokenArgs,
        success: function success(resp) {
          if (!Mura.formdata) {
            data['csrf_token_expires'] = resp.data['csrf_token_expires'];
            data['csrf_token'] = resp.data['csrf_token'];
          } else {
            data.append('csrf_token_expires', resp.data['csrf_token_expires']);
            data.append('csrf_token', resp.data['csrf_token']);
          }

          Mura.post(Mura.getAPIEndpoint() + '?method=processAsyncObject', data).then(function (resp) {
            if (_typeof(resp.data.errors) == 'object' && !Mura.isEmptyObject(resp.data.errors)) {
              self.showErrors(resp.data.errors);
              self.trigger('afterErrorRender');
            } else {
              Mura(self.context.formEl).find('form').trigger('formSubmitSuccess');
              Mura.trackEvent({
                category: 'Form',
                action: 'Conversion',
                label: self.context.name,
                objectid: self.context.objectid
              }).then(function () {
                if (typeof resp.data.redirect != 'undefined') {
                  if (resp.data.redirect && resp.data.redirect != location.href) {
                    location.href = resp.data.redirect;
                  } else {
                    location.reload(true);
                  }
                } else {
                  Mura(self.context.formEl).html(Mura.templates['success'](resp.data));
                  self.trigger('afterResponseRender');
                }
              });
            }
          }, function (resp) {
            self.showErrors({
              "systemerror": "We're sorry, a system error has occurred. Please try again later."
            });
            self.trigger('afterErrorRender');
          });
        }
      });
    }
  },
  showErrors: function showErrors(errors) {
    var self = this;
    var frm = Mura(this.context.formEl);
    var frmErrors = frm.find(".error-container-" + self.context.objectid);
    frm.find('.mura-form-submit').html(self.rb.formbuttonsubmitlabel);
    frm.find('.mura-response-error').remove();
    frm.find('[aria-invalid]').forEach(function () {
      this.removeAttribute('aria-invalid');
      this.removeAttribute('aria-describedby');
    }); //console.log(errors);
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

    var fieldKeys = Object.keys(self.fields);
    /*
    ]	<input type="text" name=“Email " id=“Email" aria-required="true" aria-invalid="true" aria-describedby=“email_error">
    <div class="error " id=“email_error" role="alert" style="display: inline;"> Enter valid email ID</div>
    */

    for (var e in errors) {
      var fieldKey = fieldKeys.find(function (key) {
        return self.fields[key].name === e;
      });

      if (fieldKey) {
        var field = self.fields[fieldKey]; //console.log(field)

        var error = {}; //error.message = field.validatemessage && field.validatemessage.length ? field.validatemessage : errors[field.name];
        //error.field = field.name;
        //error.label = field.label;

        error.message = errors[e];
        error.selector = '#field-' + field.name;
        error.field = 'field-' + field.name;
        error.label = '';
        error.id = 'e' + Mura.createUUID();

        if (field.cssid) {
          error.selector = '#' + field.cssid;
        } //errorData[e] = error;

      } else {
        var error = {};
        error.message = errors[e];
        error.selector = '#field-' + e;
        error.field = 'field-' + e;
        error.label = '';
        error.id = 'e' + Mura.createUUID(); //errorData[e] = error;
      } //console.log(error);


      if (this.inlineerrors) {
        var field = Mura(this.context.formEl).find(error.selector);
        var errorTarget = field;
        var check;

        if (!field.length) {
          field = Mura('label[for="' + e + '"]');
          check = field.parent().find('input');

          if (check.length) {
            field = check;
          }

          errorTarget = field;
          check = field.parent().find('label');

          if (check.length) {
            errorTarget = check;
          }
        }

        if (field.length) {
          field.attr('aria-invalid', true);
          field.attr('aria-describedby', error.id);
          errorTarget.node.insertAdjacentHTML('afterend', Mura.templates['error'](error));
        } else {
          frmErrors.append(Mura.templates['error'](error));
        }
      } else {
        frmErrors.append(Mura.templates['error'](error));
      }
    }

    Mura(self.context.formEl).find('.g-recaptcha-container').each(function (el) {
      grecaptcha.reset(el.getAttribute('data-widgetid'));
    });
    var errorsSel = Mura(this.context.formEl).find('.mura-response-error');

    if (errorsSel.length) {
      var error = errorsSel.first();
      var check = Mura('[aria-describedby="' + error.attr('id') + '"]');

      if (check.length) {
        check.focus();
      } else {
        error.focus();
      }
    }
  },
  // lists
  getList: function getList() {
    var self = this;
    var entityName = '';
    /*
    if(Mura.templateList.length) {
    	self.getTemplates();
    }
    else {
    */

    self.loadList(); //}
  },
  filterResults: function filterResults() {
    var self = this;
    var before = "";
    var after = "";
    self.filters.filterby = Mura("#results-filterby", self.context.formEl).val();
    self.filters.filterkey = Mura("#results-keywords", self.context.formEl).val();

    if (Mura("#date1", self.context.formEl).length) {
      if (Mura("#date1", self.context.formEl).val().length) {
        self.filters.from = Mura("#date1", self.context.formEl).val() + " " + Mura("#hour1", self.context.formEl).val() + ":00:00";
        self.filters.fromhour = Mura("#hour1", self.context.formEl).val();
        self.filters.fromdate = Mura("#date1", self.context.formEl).val();
      } else {
        self.filters.from = "";
        self.filters.fromhour = 0;
        self.filters.fromdate = "";
      }

      if (Mura("#date2", self.context.formEl).val().length) {
        self.filters.to = Mura("#date2", self.context.formEl).val() + " " + Mura("#hour2", self.context.formEl).val() + ":00:00";
        self.filters.tohour = Mura("#hour2", self.context.formEl).val();
        self.filters.todate = Mura("#date2", self.context.formEl).val();
      } else {
        self.filters.to = "";
        self.filters.tohour = 0;
        self.filters.todate = "";
      }
    }

    self.getTableData();
  },
  downloadResults: function downloadResults() {
    var self = this;
    self.filterResults();
  },
  loadList: function loadList() {
    var self = this;
    formJSON = self.context.formdata;
    entityName = dself.context.filename.replace(/\W+/g, "");
    self.entity = entityName;
    self.formJSON = formJSON;

    if (formJSON.form.formattributes && formJSON.form.formattributes.Muraormentities == 1) {
      self.ormform = true;
    } else {
      Mura(self.context.formEl).append("Unsupported for pre-Mura 7.0 MuraORM Forms.");
      return;
    }

    self.getTableData();
    /*
    Mura.get(
    	Mura.getAPIEndpoint() + 'content/' + self.context.objectid
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
  getTableData: function getTableData(navlink) {
    var self = this;
    Mura.get(Mura.getAPIEndpoint() + self.entity + '/listviewdescriptor').then(function (resp) {
      self.columns = resp.data;
      Mura.get(Mura.getAPIEndpoint() + self.entity + '/propertydescriptor/').then(function (resp) {
        self.properties = self.cleanProps(resp.data);

        if (navlink == undefined) {
          navlink = Mura.getAPIEndpoint() + self.entity + '?sort=' + self.sortdir + self.sortfield;
          var fields = [];

          for (var i = 0; i < self.columns.length; i++) {
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

        Mura.get(navlink).then(function (resp) {
          self.data = resp.data;
          self.location = self.data.links.self;
          var tableData = {
            rows: self.data,
            columns: self.columns,
            properties: self.properties,
            filters: self.filters
          };
          self.renderTable(tableData);
        });
      });
    });
  },
  renderTable: function renderTable(tableData) {
    var self = this;
    var html = Mura.templates['table'](tableData);
    Mura(self.context.formEl).html(html);

    if (self.context.view == 'list') {
      Mura("#date-filters", self.context.formEl).empty();
      Mura("#btn-results-download", self.context.formEl).remove();
    } else {
      if (self.context.render == undefined) {
        Mura(".datepicker", self.context.formEl).datepicker();
      }

      Mura("#btn-results-download", self.context.formEl).click(function () {
        self.downloadResults();
      });
    }

    Mura("#btn-results-search", self.context.formEl).click(function () {
      self.filterResults();
    });
    Mura(".data-edit", self.context.formEl).click(function () {
      self.renderCRUD(Mura(this).attr('data-value'), Mura(this).attr('data-pos'));
    });
    Mura(".data-view", self.context.formEl).click(function () {
      self.loadOverview(Mura(this).attr('data-value'), Mura(this).attr('data-pos'));
    });
    Mura(".data-nav", self.context.formEl).click(function () {
      self.getTableData(Mura(this).attr('data-value'));
    });
    Mura(".data-sort").click(function () {
      var sortfield = Mura(this).attr('data-value');
      if (sortfield == self.sortfield && self.sortdir == '') self.sortdir = '-';else self.sortdir = '';
      self.sortfield = Mura(this).attr('data-value');
      self.getTableData();
    });
  },
  loadOverview: function loadOverview(itemid, pos) {
    var self = this;
    Mura.get(Mura.getAPIEndpoint() + entityName + '/' + itemid + '?expand=all').then(function (resp) {
      self.item = resp.data;
      self.renderOverview();
    });
  },
  renderOverview: function renderOverview() {
    var self = this; //console.log('ia');
    //console.log(self.item);

    Mura(self.context.formEl).empty();
    var html = Mura.templates['view'](self.item);
    Mura(self.context.formEl).append(html);
    Mura(".nav-back", self.context.formEl).click(function () {
      self.getTableData(self.location);
    });
  },
  renderCRUD: function renderCRUD(itemid, pos) {
    var self = this;
    self.formInit = 0;
    self.initForm();
    self.getForm(itemid, self.data.links.self);
  },
  cleanProps: function cleanProps(props) {
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

    for (var i in props) {
      if (props[i].orderno != undefined) {
        propsOrdered[props[i].orderno] = props[i];
      } else {
        propsOrdered[ct++] = props[i];
      }
    }

    Object.keys(propsOrdered).sort().forEach(function (v, i) {
      propsRet[v] = propsOrdered[v];
    });
    return propsRet;
  },
  registerHelpers: function registerHelpers() {
    var self = this;
    Mura.extend(self.rb, Mura.rb);
    Mura.Handlebars.registerHelper('eachColRow', function (row, columns, options) {
      var ret = "";

      for (var i = 0; i < columns.length; i++) {
        ret = ret + options.fn(row[columns[i].column]);
      }

      return ret;
    });
    Mura.Handlebars.registerHelper('eachProp', function (data, options) {
      var ret = "";
      var obj = {};

      for (var i in self.properties) {
        obj.displayName = self.properties[i].displayName;

        if (self.properties[i].fieldtype == "one-to-one") {
          obj.displayValue = data[self.properties[i].cfc].val;
        } else obj.displayValue = data[self.properties[i].column];

        ret = ret + options.fn(obj);
      }

      return ret;
    });
    Mura.Handlebars.registerHelper('eachKey', function (properties, by, options) {
      var ret = "";
      var item = "";

      for (var i in properties) {
        item = properties[i];
        if (item.column == by) item.selected = "Selected";
        if (item.rendertype == 'textfield') ret = ret + options.fn(item);
      }

      return ret;
    });
    Mura.Handlebars.registerHelper('eachHour', function (hour, options) {
      var ret = "";
      var h = 0;
      var val = "";

      for (var i = 0; i < 24; i++) {
        if (i == 0) {
          val = {
            label: "12 AM",
            num: i
          };
        } else if (i < 12) {
          h = i;
          val = {
            label: h + " AM",
            num: i
          };
        } else if (i == 12) {
          h = i;
          val = {
            label: h + " PM",
            num: i
          };
        } else {
          h = i - 12;
          val = {
            label: h + " PM",
            num: i
          };
        }

        if (hour == i) val.selected = "selected";
        ret = ret + options.fn(val);
      }

      return ret;
    });
    Mura.Handlebars.registerHelper('eachColButton', function (row, options) {
      var ret = "";
      row.label = 'View';
      row.type = 'data-view'; // only do view if there are more properties than columns

      if (Object.keys(self.properties).length > self.columns.length) {
        ret = ret + options.fn(row);
      }

      if (self.context.view == 'edit') {
        row.label = 'Edit';
        row.type = 'data-edit';
        ret = ret + options.fn(row);
      }

      return ret;
    });
    Mura.Handlebars.registerHelper('eachCheck', function (checks, selected, options) {
      var ret = "";

      for (var i = 0; i < checks.length; i++) {
        if (selected.indexOf(checks[i].id) > -1) checks[i].isselected = 1;else checks[i].isselected = 0;
        ret = ret + options.fn(checks[i]);
      }

      return ret;
    });
    Mura.Handlebars.registerHelper('eachStatic', function (dataset, options) {
      var ret = "";

      for (var i = 0; i < dataset.datarecordorder.length; i++) {
        ret = ret + options.fn(dataset.datarecords[dataset.datarecordorder[i]]);
      }

      return ret;
    });
    Mura.Handlebars.registerHelper('inputWrapperClass', function () {
      var escapeExpression = Mura.Handlebars.escapeExpression;
      var returnString = 'mura-control-group';

      if (self.rb.formfieldwrapperclass) {
        returnString += ' ' + self.rb.formfieldwrapperclass;
      }

      if (this.wrappercssclass) {
        returnString += ' ' + escapeExpression(this.wrappercssclass);
      }

      if (this.isrequired) {
        returnString += ' req';

        if (self.rb.formrequiredwrapperclass) {
          returnString += ' ' + self.rb.formrequiredwrapperclass;
        }
      }

      return returnString;
    });
    Mura.Handlebars.registerHelper('radioLabelClass', function () {
      return self.rb.formradiolabelclass;
    });
    Mura.Handlebars.registerHelper('formErrorWrapperClass', function () {
      if (self.rb.formerrorwrapperclass) {
        return 'mura-response-error' + ' ' + self.rb.formerrorwrapperclass;
      } else {
        return 'mura-response-error';
      }
    });
    Mura.Handlebars.registerHelper('formSuccessWrapperClass', function () {
      if (self.rb.formresponsewrapperclass) {
        return 'mura-response-success' + ' ' + self.rb.formresponsewrapperclass;
      } else {
        return 'mura-response-success';
      }
    });
    Mura.Handlebars.registerHelper('formResponseWrapperClass', function () {
      if (self.rb.formresponsewrapperclass) {
        return 'mura-response-success' + ' ' + self.rb.formresponsewrapperclass;
      } else {
        return 'mura-response-success';
      }
    });
    Mura.Handlebars.registerHelper('radioClass', function () {
      return self.rb.formradioclass;
    });
    Mura.Handlebars.registerHelper('radioWrapperClass', function () {
      return self.rb.formradiowrapperclass;
    });
    Mura.Handlebars.registerHelper('checkboxLabelClass', function () {
      return self.rb.formcheckboxlabelclass;
    });
    Mura.Handlebars.registerHelper('checkboxClass', function () {
      return self.rb.formcheckboxclass;
    });
    Mura.Handlebars.registerHelper('checkboxWrapperClass', function () {
      return self.rb.formcheckboxwrapperclass;
    });
    Mura.Handlebars.registerHelper('formRequiredLabel', function () {
      return self.rb.formrequiredlabel;
    });
    Mura.Handlebars.registerHelper('filePlaceholder', function () {
      var escapeExpression = Mura.Handlebars.escapeExpression;

      if (this.placeholder) {
        return escapeExpression(this.placeholder);
      } else {
        return self.rb.formfileplaceholder;
      }
    });
    Mura.Handlebars.registerHelper('formClass', function () {
      var escapeExpression = Mura.Handlebars.escapeExpression;
      var returnString = 'mura-form';

      if (self.formJSON && self.formJSON.form && self.formJSON.form.formattributes && self.formJSON.form.formattributes.class) {
        returnString += ' ' + escapeExpression(self.formJSON.form.formattributes.class);
      }

      return returnString;
    });
    Mura.Handlebars.registerHelper('textInputTypeValue', function () {
      if (typeof Mura.usehtml5dateinput != 'undefined' && Mura.usehtml5dateinput && typeof this.validatetype != 'undefined' && this.validatetype.toLowerCase() == 'date') {
        return 'date';
      } else {
        return 'text';
      }
    });
    Mura.Handlebars.registerHelper('labelForValue', function () {
      //id, class, title, size
      var escapeExpression = Mura.Handlebars.escapeExpression;

      if (this.cssid) {
        return escapeExpression(this.cssid);
      } else {
        return "field-" + escapeExpression(this.name);
      }

      return returnString;
    });
    Mura.Handlebars.registerHelper('commonInputAttributes', function () {
      //id, class, title, size
      var escapeExpression = Mura.Handlebars.escapeExpression;

      if (typeof this.fieldtype != 'undefined' && this.fieldtype.fieldtype == 'file') {
        var returnString = 'name="' + escapeExpression(self.context.prefix + this.name) + '_attachment"';
      } else {
        var returnString = 'name="' + escapeExpression(self.context.prefix + this.name) + '"';
      }

      if (this.cssid) {
        returnString += ' id="' + escapeExpression(this.cssid) + '"';
      } else {
        returnString += ' id="field-' + escapeExpression(self.context.prefix + this.name) + '"';
      }

      returnString += ' class="';

      if (this.cssclass) {
        returnString += escapeExpression(this.cssclass) + ' ';
      }

      if (this.fieldtype == 'radio' || this.fieldtype == 'radio_static') {
        returnString += self.rb.formradioclass;
      } else if (this.fieldtype == 'checkbox' || this.fieldtype == 'checkbox_static') {
        returnString += self.rb.formcheckboxclass;
      } else if (this.fieldtype == 'file') {
        returnString += self.rb.formfileclass;
      } else if (this.fieldtype == 'textarea') {
        returnString += self.rb.formtextareaclass;
      } else if (this.fieldtype == 'dropdown' || this.fieldtype == 'dropdown_static') {
        returnString += self.rb.formselectclass;
      } else if (this.fieldtype == 'textblock') {
        returnString += self.rb.formtextblockclass;
      } else {
        returnString += self.rb.forminputclass;
      }

      returnString += '"';

      if (this.tooltip) {
        returnString += ' title="' + escapeExpression(this.tooltip) + '"';
      }

      if (this.size) {
        returnString += ' size="' + escapeExpression(this.size) + '"';
      }

      if (this.multiple) {
        returnString += ' multiple';
      }

      if (typeof Mura.usehtml5dateinput != 'undefined' && Mura.usehtml5dateinput && typeof this.validatetype != 'undefined' && this.validatetype.toLowerCase() == 'date') {
        returnString += ' data-date-format="' + Mura.dateformat + '"';
      }

      return returnString;
    });
    Mura.Handlebars.registerHelper('fileAttributes', function () {
      //id, class, title, size
      var escapeExpression = Mura.Handlebars.escapeExpression;
      var returnString = '';

      if (this.cssid) {
        returnString += ' id="' + escapeExpression(this.cssid) + '"';
      } else {
        returnString += ' id="field-' + escapeExpression(self.context.prefix + this.name) + '"';
      }

      returnString += ' class="mura-newfile-filename ';

      if (this.cssclass) {
        returnString += escapeExpression(this.cssclass) + ' ';
      }

      returnString += self.rb.forminputclass;
      returnString += '"';

      if (this.tooltip) {
        returnString += ' title="' + escapeExpression(this.tooltip) + '"';
      }

      return returnString;
    });
  }
}); //Legacy for early adopter backwords support

Mura.DisplayObject.Form = Mura.UI.Form;

/***/ }),

/***/ 8180:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var Mura = __webpack_require__(791);
/**
 * Creates a new Mura.UI.Text
 * @name  Mura.UI.Hr
 * @class
 * @extends Mura.UI
 * @memberof  Mura
 */


Mura.UI.Hr = Mura.UI.extend(
/** @lends Mura.DisplayObject.Hr.prototype */
{
  renderClient: function renderClient() {
    Mura(this.context.targetEl).html("<hr>");
    this.trigger('afterRender');
  },
  renderServer: function renderServer() {
    return "<hr>";
  }
});
Mura.DisplayObject.Hr = Mura.UI.Hr;

/***/ }),

/***/ 876:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var Mura = __webpack_require__(791);
/**
 * Creates a new Mura.UI.Text
 * @name  Mura.UI.Image
 * @class
 * @extends Mura.UI
 * @memberof  Mura
 */


Mura.UI.Image = Mura.UI.extend(
/** @lends Mura.DisplayObject.Image.prototype */
{
  renderClient: function renderClient() {
    Mura(this.context.targetEl).html(Mura.templates['image'](this.context));
    this.trigger('afterRender');
  },
  renderServer: function renderServer() {
    return Mura.templates['image'](this.context);
  }
});
Mura.DisplayObject.Image = Mura.UI.Image;

/***/ }),

/***/ 7789:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var Mura = __webpack_require__(791);
/**
 * Creates a new Mura.UI instance
 * @name Mura.UI
 * @class
 * @extends  Mura.Core
 * @memberof Mura
 */


Mura.UI = Mura.Core.extend(
/** @lends Mura.UI.prototype */
{
  rb: {},
  context: {},
  onAfterRender: function onAfterRender() {},
  onBeforeRender: function onBeforeRender() {},
  trigger: function trigger(eventName) {
    var $eventName = eventName.toLowerCase();

    if (typeof this.context.targetEl != 'undefined') {
      var obj = Mura(this.context.targetEl).closest('.mura-object');

      if (obj.length && typeof obj.node != 'undefined') {
        if (typeof this.handlers[$eventName] != 'undefined') {
          var $handlers = this.handlers[$eventName];

          for (var i = 0; i < $handlers.length; i++) {
            if (typeof $handlers[i].call == 'undefined') {
              $handlers[i](this);
            } else {
              $handlers[i].call(this, this);
            }
          }
        }

        if (typeof this[eventName] == 'function') {
          if (typeof this[eventName].call == 'undefined') {
            this[eventName](this);
          } else {
            this[eventName].call(this, this);
          }
        }

        var fnName = 'on' + eventName.substring(0, 1).toUpperCase() + eventName.substring(1, eventName.length);

        if (typeof this[fnName] == 'function') {
          if (typeof this[fnName].call == 'undefined') {
            this[fnName](this);
          } else {
            this[fnName].call(this, this);
          }
        }
      }
    }

    return this;
  },

  /* This method is deprecated, use renderClient and renderServer instead */
  render: function render() {
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
  renderClient: function renderClient() {
    return this.render();
  },
  renderServer: function renderServer() {
    return '';
  },
  hydrate: function hydrate() {},
  destroy: function destroy() {},
  reset: function reset(self, empty) {},
  init: function init(args) {
    this.context = args;
    this.registerHelpers();
    return this;
  },
  registerHelpers: function registerHelpers() {}
});

/***/ }),

/***/ 6943:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var Mura = __webpack_require__(791);
/**
 * Creates a new Mura.UI.Text
 * @name  Mura.UI.Text
 * @class
 * @extends Mura.UI
 * @memberof  Mura
 */


Mura.UI.Text = Mura.UI.extend(
/** @lends Mura.DisplayObject.Text.prototype */
{
  renderClient: function renderClient() {
    var _this = this;

    this.context.sourcetype = this.context.sourcetype || 'custom';

    if (this.context.sourcetype == 'component' && this.context.source) {
      if (Mura.isUUID(this.context.source)) {
        var loadbykey = 'contentid';
      } else {
        var loadbykey = 'tile';
      }

      Mura.getEntity('content').loadBy(loadbykey, this.context.source, {
        fields: 'body',
        type: 'component'
      }).then(function (content) {
        if (content.get('body')) {
          Mura(_this.context.targetEl).html(_this.deserialize(content.get('body')));
        } else if (_this.context.label) {
          Mura(_this.context.targetEl).html('');
        } else {
          Mura(_this.context.targetEl).html('<p></p>');
        }

        _this.trigger('afterRender');
      });
    } else {
      Mura(this.context.targetEl).html(Mura.templates['text'](this.context));
      this.trigger('afterRender');
    }
  },
  renderServer: function renderServer() {
    this.context.sourcetype = this.context.sourcetype || 'custom';

    if (this.context.sourcetype == 'custom') {
      return this.deserialize(this.context.source);
    } else {
      return '<p></p>';
    }
  },
  deserialize: function deserialize(source) {
    return source;
  }
});
Mura.DisplayObject.Text = Mura.UI.Text;

/***/ }),

/***/ 1808:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var Mura = __webpack_require__(791);
/**
* Creates a new Mura.entities.User
* @name Mura.entities.User
* @class
* @extends Mura.Entity
* @memberof Mura
* @param	{object} properties Object containing values to set into object
* @return {Mura.entities.User}
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
  isInGroup: function isInGroup(group, siteid, isPublic) {
    siteid = siteid || Mura.siteid;
    var a = this.get('memberships');

    if (!Array.isArray(a)) {
      console.log('Method design for use with currentuser() only');
      return false;
    }

    if (typeof isPublic != 'undefined') {
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
  isSuperUser: function isSuperUser() {
    var a = this.get('memberships');

    if (!Array.isArray(a)) {
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
  isAdminUser: function isAdminUser(siteid) {
    siteid = siteid || Mura.siteid;
    var a = this.get('memberships');

    if (!Array.isArray(a)) {
      console.log('Method design for use with currentuser() only');
      return false;
    }

    return this.isSuperUser() || a.indexOf("Admin;" + siteid + ";0") >= 0;
  },

  /**
   * isSystemUser - Returns if the CURRENT USER is a system/adminstrative user
   *
   * @return {boolean}
   */
  isSystemUser: function isSystemUser(siteid) {
    siteid = siteid || Mura.siteid;
    var a = this.get('memberships');

    if (!Array.isArray(a)) {
      console.log('Method design for use with currentuser() only');
      return false;
    }

    return this.isAdminUser() || a.indexOf("S2IsPrivate;" + siteid) >= 0;
  },

  /**
   * isLoggedIn - Returns if the CURRENT USER is logged in
   *
   * @return {boolean}
   */
  isLoggedIn: function isLoggedIn() {
    var a = this.get('isloggedin');

    if (a === '') {
      return false;
    } else {
      return a;
    }
  }
});

/***/ }),

/***/ 5579:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

if (!(typeof process !== 'undefined' && {}.toString.call(process) === '[object process]' || typeof document == 'undefined')) {
  __webpack_require__(3902);
}

var Mura = __webpack_require__(791);

__webpack_require__(7285);

__webpack_require__(9058);

__webpack_require__(4980);

__webpack_require__(2147);

__webpack_require__(6501);

__webpack_require__(4506);

__webpack_require__(1808);

__webpack_require__(2826);

__webpack_require__(7847);

__webpack_require__(7023);

__webpack_require__(6839);

__webpack_require__(7789);

__webpack_require__(5086);

__webpack_require__(6943);

__webpack_require__(8180);

__webpack_require__(397);

__webpack_require__(876);

__webpack_require__(324);

__webpack_require__(1711);

__webpack_require__(4654);

__webpack_require__(1526);

if (Mura.isInNode()) {
  Mura._escapeHTML = __webpack_require__(Object(function webpackMissingModule() { var e = new Error("Cannot find module 'escape-html'"); e.code = 'MODULE_NOT_FOUND'; throw e; }()));
} else if (typeof window != 'undefined') {
  window.m = Mura;
  window.mura = Mura;
  window.Mura = Mura;
  window.validateForm = Mura.validateForm;
  window.setHTMLEditor = Mura.setHTMLEditor;
  window.createCookie = Mura.createCookie;
  window.readCookie = Mura.readCookie;
  window.addLoadEvent = Mura.addLoadEvent;
  window.noSpam = Mura.noSpam;
  window.initMura = Mura.init;
}

module.exports = Mura;

/***/ }),

/***/ 8346:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var parent = __webpack_require__(1150);

module.exports = parent;


/***/ }),

/***/ 7633:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

__webpack_require__(9170);
__webpack_require__(6992);
__webpack_require__(1539);
__webpack_require__(8674);
__webpack_require__(7922);
__webpack_require__(4668);
__webpack_require__(7727);
__webpack_require__(8783);
var path = __webpack_require__(857);

module.exports = path.Promise;


/***/ }),

/***/ 3867:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var parent = __webpack_require__(8346);
__webpack_require__(8628);
// TODO: Remove from `core-js@4`
__webpack_require__(7314);
__webpack_require__(4850);
__webpack_require__(6290);

module.exports = parent;


/***/ }),

/***/ 9662:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var isCallable = __webpack_require__(614);
var tryToString = __webpack_require__(6330);

var TypeError = global.TypeError;

// `Assert: IsCallable(argument) is true`
module.exports = function (argument) {
  if (isCallable(argument)) return argument;
  throw TypeError(tryToString(argument) + ' is not a function');
};


/***/ }),

/***/ 9483:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var isConstructor = __webpack_require__(4411);
var tryToString = __webpack_require__(6330);

var TypeError = global.TypeError;

// `Assert: IsConstructor(argument) is true`
module.exports = function (argument) {
  if (isConstructor(argument)) return argument;
  throw TypeError(tryToString(argument) + ' is not a constructor');
};


/***/ }),

/***/ 6077:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var isCallable = __webpack_require__(614);

var String = global.String;
var TypeError = global.TypeError;

module.exports = function (argument) {
  if (typeof argument == 'object' || isCallable(argument)) return argument;
  throw TypeError("Can't set " + String(argument) + ' as a prototype');
};


/***/ }),

/***/ 1223:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var wellKnownSymbol = __webpack_require__(5112);
var create = __webpack_require__(30);
var definePropertyModule = __webpack_require__(3070);

var UNSCOPABLES = wellKnownSymbol('unscopables');
var ArrayPrototype = Array.prototype;

// Array.prototype[@@unscopables]
// https://tc39.es/ecma262/#sec-array.prototype-@@unscopables
if (ArrayPrototype[UNSCOPABLES] == undefined) {
  definePropertyModule.f(ArrayPrototype, UNSCOPABLES, {
    configurable: true,
    value: create(null)
  });
}

// add a key to Array.prototype[@@unscopables]
module.exports = function (key) {
  ArrayPrototype[UNSCOPABLES][key] = true;
};


/***/ }),

/***/ 5787:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var isPrototypeOf = __webpack_require__(7976);

var TypeError = global.TypeError;

module.exports = function (it, Prototype) {
  if (isPrototypeOf(Prototype, it)) return it;
  throw TypeError('Incorrect invocation');
};


/***/ }),

/***/ 9670:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var isObject = __webpack_require__(111);

var String = global.String;
var TypeError = global.TypeError;

// `Assert: Type(argument) is Object`
module.exports = function (argument) {
  if (isObject(argument)) return argument;
  throw TypeError(String(argument) + ' is not an object');
};


/***/ }),

/***/ 8533:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var $forEach = (__webpack_require__(2092).forEach);
var arrayMethodIsStrict = __webpack_require__(9341);

var STRICT_METHOD = arrayMethodIsStrict('forEach');

// `Array.prototype.forEach` method implementation
// https://tc39.es/ecma262/#sec-array.prototype.foreach
module.exports = !STRICT_METHOD ? function forEach(callbackfn /* , thisArg */) {
  return $forEach(this, callbackfn, arguments.length > 1 ? arguments[1] : undefined);
// eslint-disable-next-line es/no-array-prototype-foreach -- safe
} : [].forEach;


/***/ }),

/***/ 8457:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var global = __webpack_require__(7854);
var bind = __webpack_require__(9974);
var call = __webpack_require__(6916);
var toObject = __webpack_require__(7908);
var callWithSafeIterationClosing = __webpack_require__(3411);
var isArrayIteratorMethod = __webpack_require__(7659);
var isConstructor = __webpack_require__(4411);
var lengthOfArrayLike = __webpack_require__(6244);
var createProperty = __webpack_require__(6135);
var getIterator = __webpack_require__(8554);
var getIteratorMethod = __webpack_require__(1246);

var Array = global.Array;

// `Array.from` method implementation
// https://tc39.es/ecma262/#sec-array.from
module.exports = function from(arrayLike /* , mapfn = undefined, thisArg = undefined */) {
  var O = toObject(arrayLike);
  var IS_CONSTRUCTOR = isConstructor(this);
  var argumentsLength = arguments.length;
  var mapfn = argumentsLength > 1 ? arguments[1] : undefined;
  var mapping = mapfn !== undefined;
  if (mapping) mapfn = bind(mapfn, argumentsLength > 2 ? arguments[2] : undefined);
  var iteratorMethod = getIteratorMethod(O);
  var index = 0;
  var length, result, step, iterator, next, value;
  // if the target is not iterable or it's an array with the default iterator - use a simple case
  if (iteratorMethod && !(this == Array && isArrayIteratorMethod(iteratorMethod))) {
    iterator = getIterator(O, iteratorMethod);
    next = iterator.next;
    result = IS_CONSTRUCTOR ? new this() : [];
    for (;!(step = call(next, iterator)).done; index++) {
      value = mapping ? callWithSafeIterationClosing(iterator, mapfn, [step.value, index], true) : step.value;
      createProperty(result, index, value);
    }
  } else {
    length = lengthOfArrayLike(O);
    result = IS_CONSTRUCTOR ? new this(length) : Array(length);
    for (;length > index; index++) {
      value = mapping ? mapfn(O[index], index) : O[index];
      createProperty(result, index, value);
    }
  }
  result.length = index;
  return result;
};


/***/ }),

/***/ 1318:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var toIndexedObject = __webpack_require__(5656);
var toAbsoluteIndex = __webpack_require__(1400);
var lengthOfArrayLike = __webpack_require__(6244);

// `Array.prototype.{ indexOf, includes }` methods implementation
var createMethod = function (IS_INCLUDES) {
  return function ($this, el, fromIndex) {
    var O = toIndexedObject($this);
    var length = lengthOfArrayLike(O);
    var index = toAbsoluteIndex(fromIndex, length);
    var value;
    // Array#includes uses SameValueZero equality algorithm
    // eslint-disable-next-line no-self-compare -- NaN check
    if (IS_INCLUDES && el != el) while (length > index) {
      value = O[index++];
      // eslint-disable-next-line no-self-compare -- NaN check
      if (value != value) return true;
    // Array#indexOf ignores holes, Array#includes - not
    } else for (;length > index; index++) {
      if ((IS_INCLUDES || index in O) && O[index] === el) return IS_INCLUDES || index || 0;
    } return !IS_INCLUDES && -1;
  };
};

module.exports = {
  // `Array.prototype.includes` method
  // https://tc39.es/ecma262/#sec-array.prototype.includes
  includes: createMethod(true),
  // `Array.prototype.indexOf` method
  // https://tc39.es/ecma262/#sec-array.prototype.indexof
  indexOf: createMethod(false)
};


/***/ }),

/***/ 2092:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var bind = __webpack_require__(9974);
var uncurryThis = __webpack_require__(1702);
var IndexedObject = __webpack_require__(8361);
var toObject = __webpack_require__(7908);
var lengthOfArrayLike = __webpack_require__(6244);
var arraySpeciesCreate = __webpack_require__(5417);

var push = uncurryThis([].push);

// `Array.prototype.{ forEach, map, filter, some, every, find, findIndex, filterReject }` methods implementation
var createMethod = function (TYPE) {
  var IS_MAP = TYPE == 1;
  var IS_FILTER = TYPE == 2;
  var IS_SOME = TYPE == 3;
  var IS_EVERY = TYPE == 4;
  var IS_FIND_INDEX = TYPE == 6;
  var IS_FILTER_REJECT = TYPE == 7;
  var NO_HOLES = TYPE == 5 || IS_FIND_INDEX;
  return function ($this, callbackfn, that, specificCreate) {
    var O = toObject($this);
    var self = IndexedObject(O);
    var boundFunction = bind(callbackfn, that);
    var length = lengthOfArrayLike(self);
    var index = 0;
    var create = specificCreate || arraySpeciesCreate;
    var target = IS_MAP ? create($this, length) : IS_FILTER || IS_FILTER_REJECT ? create($this, 0) : undefined;
    var value, result;
    for (;length > index; index++) if (NO_HOLES || index in self) {
      value = self[index];
      result = boundFunction(value, index, O);
      if (TYPE) {
        if (IS_MAP) target[index] = result; // map
        else if (result) switch (TYPE) {
          case 3: return true;              // some
          case 5: return value;             // find
          case 6: return index;             // findIndex
          case 2: push(target, value);      // filter
        } else switch (TYPE) {
          case 4: return false;             // every
          case 7: push(target, value);      // filterReject
        }
      }
    }
    return IS_FIND_INDEX ? -1 : IS_SOME || IS_EVERY ? IS_EVERY : target;
  };
};

module.exports = {
  // `Array.prototype.forEach` method
  // https://tc39.es/ecma262/#sec-array.prototype.foreach
  forEach: createMethod(0),
  // `Array.prototype.map` method
  // https://tc39.es/ecma262/#sec-array.prototype.map
  map: createMethod(1),
  // `Array.prototype.filter` method
  // https://tc39.es/ecma262/#sec-array.prototype.filter
  filter: createMethod(2),
  // `Array.prototype.some` method
  // https://tc39.es/ecma262/#sec-array.prototype.some
  some: createMethod(3),
  // `Array.prototype.every` method
  // https://tc39.es/ecma262/#sec-array.prototype.every
  every: createMethod(4),
  // `Array.prototype.find` method
  // https://tc39.es/ecma262/#sec-array.prototype.find
  find: createMethod(5),
  // `Array.prototype.findIndex` method
  // https://tc39.es/ecma262/#sec-array.prototype.findIndex
  findIndex: createMethod(6),
  // `Array.prototype.filterReject` method
  // https://github.com/tc39/proposal-array-filtering
  filterReject: createMethod(7)
};


/***/ }),

/***/ 9341:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var fails = __webpack_require__(7293);

module.exports = function (METHOD_NAME, argument) {
  var method = [][METHOD_NAME];
  return !!method && fails(function () {
    // eslint-disable-next-line no-useless-call -- required for testing
    method.call(null, argument || function () { return 1; }, 1);
  });
};


/***/ }),

/***/ 1589:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var toAbsoluteIndex = __webpack_require__(1400);
var lengthOfArrayLike = __webpack_require__(6244);
var createProperty = __webpack_require__(6135);

var Array = global.Array;
var max = Math.max;

module.exports = function (O, start, end) {
  var length = lengthOfArrayLike(O);
  var k = toAbsoluteIndex(start, length);
  var fin = toAbsoluteIndex(end === undefined ? length : end, length);
  var result = Array(max(fin - k, 0));
  for (var n = 0; k < fin; k++, n++) createProperty(result, n, O[k]);
  result.length = n;
  return result;
};


/***/ }),

/***/ 206:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var uncurryThis = __webpack_require__(1702);

module.exports = uncurryThis([].slice);


/***/ }),

/***/ 4362:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var arraySlice = __webpack_require__(1589);

var floor = Math.floor;

var mergeSort = function (array, comparefn) {
  var length = array.length;
  var middle = floor(length / 2);
  return length < 8 ? insertionSort(array, comparefn) : merge(
    array,
    mergeSort(arraySlice(array, 0, middle), comparefn),
    mergeSort(arraySlice(array, middle), comparefn),
    comparefn
  );
};

var insertionSort = function (array, comparefn) {
  var length = array.length;
  var i = 1;
  var element, j;

  while (i < length) {
    j = i;
    element = array[i];
    while (j && comparefn(array[j - 1], element) > 0) {
      array[j] = array[--j];
    }
    if (j !== i++) array[j] = element;
  } return array;
};

var merge = function (array, left, right, comparefn) {
  var llength = left.length;
  var rlength = right.length;
  var lindex = 0;
  var rindex = 0;

  while (lindex < llength || rindex < rlength) {
    array[lindex + rindex] = (lindex < llength && rindex < rlength)
      ? comparefn(left[lindex], right[rindex]) <= 0 ? left[lindex++] : right[rindex++]
      : lindex < llength ? left[lindex++] : right[rindex++];
  } return array;
};

module.exports = mergeSort;


/***/ }),

/***/ 7475:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var isArray = __webpack_require__(3157);
var isConstructor = __webpack_require__(4411);
var isObject = __webpack_require__(111);
var wellKnownSymbol = __webpack_require__(5112);

var SPECIES = wellKnownSymbol('species');
var Array = global.Array;

// a part of `ArraySpeciesCreate` abstract operation
// https://tc39.es/ecma262/#sec-arrayspeciescreate
module.exports = function (originalArray) {
  var C;
  if (isArray(originalArray)) {
    C = originalArray.constructor;
    // cross-realm fallback
    if (isConstructor(C) && (C === Array || isArray(C.prototype))) C = undefined;
    else if (isObject(C)) {
      C = C[SPECIES];
      if (C === null) C = undefined;
    }
  } return C === undefined ? Array : C;
};


/***/ }),

/***/ 5417:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var arraySpeciesConstructor = __webpack_require__(7475);

// `ArraySpeciesCreate` abstract operation
// https://tc39.es/ecma262/#sec-arrayspeciescreate
module.exports = function (originalArray, length) {
  return new (arraySpeciesConstructor(originalArray))(length === 0 ? 0 : length);
};


/***/ }),

/***/ 4170:
/***/ (function(module) {

var itoc = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
var ctoi = {};

for (var index = 0; index < 66; index++) ctoi[itoc.charAt(index)] = index;

module.exports = {
  itoc: itoc,
  ctoi: ctoi
};


/***/ }),

/***/ 3411:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var anObject = __webpack_require__(9670);
var iteratorClose = __webpack_require__(9212);

// call something on iterator step with safe closing on error
module.exports = function (iterator, fn, value, ENTRIES) {
  try {
    return ENTRIES ? fn(anObject(value)[0], value[1]) : fn(value);
  } catch (error) {
    iteratorClose(iterator, 'throw', error);
  }
};


/***/ }),

/***/ 7072:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var wellKnownSymbol = __webpack_require__(5112);

var ITERATOR = wellKnownSymbol('iterator');
var SAFE_CLOSING = false;

try {
  var called = 0;
  var iteratorWithReturn = {
    next: function () {
      return { done: !!called++ };
    },
    'return': function () {
      SAFE_CLOSING = true;
    }
  };
  iteratorWithReturn[ITERATOR] = function () {
    return this;
  };
  // eslint-disable-next-line es/no-array-from, no-throw-literal -- required for testing
  Array.from(iteratorWithReturn, function () { throw 2; });
} catch (error) { /* empty */ }

module.exports = function (exec, SKIP_CLOSING) {
  if (!SKIP_CLOSING && !SAFE_CLOSING) return false;
  var ITERATION_SUPPORT = false;
  try {
    var object = {};
    object[ITERATOR] = function () {
      return {
        next: function () {
          return { done: ITERATION_SUPPORT = true };
        }
      };
    };
    exec(object);
  } catch (error) { /* empty */ }
  return ITERATION_SUPPORT;
};


/***/ }),

/***/ 4326:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var uncurryThis = __webpack_require__(1702);

var toString = uncurryThis({}.toString);
var stringSlice = uncurryThis(''.slice);

module.exports = function (it) {
  return stringSlice(toString(it), 8, -1);
};


/***/ }),

/***/ 648:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var TO_STRING_TAG_SUPPORT = __webpack_require__(1694);
var isCallable = __webpack_require__(614);
var classofRaw = __webpack_require__(4326);
var wellKnownSymbol = __webpack_require__(5112);

var TO_STRING_TAG = wellKnownSymbol('toStringTag');
var Object = global.Object;

// ES3 wrong here
var CORRECT_ARGUMENTS = classofRaw(function () { return arguments; }()) == 'Arguments';

// fallback for IE11 Script Access Denied error
var tryGet = function (it, key) {
  try {
    return it[key];
  } catch (error) { /* empty */ }
};

// getting tag from ES6+ `Object.prototype.toString`
module.exports = TO_STRING_TAG_SUPPORT ? classofRaw : function (it) {
  var O, tag, result;
  return it === undefined ? 'Undefined' : it === null ? 'Null'
    // @@toStringTag case
    : typeof (tag = tryGet(O = Object(it), TO_STRING_TAG)) == 'string' ? tag
    // builtinTag case
    : CORRECT_ARGUMENTS ? classofRaw(O)
    // ES3 arguments fallback
    : (result = classofRaw(O)) == 'Object' && isCallable(O.callee) ? 'Arguments' : result;
};


/***/ }),

/***/ 7741:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var uncurryThis = __webpack_require__(1702);

var replace = uncurryThis(''.replace);

var TEST = (function (arg) { return String(Error(arg).stack); })('zxcasd');
var V8_OR_CHAKRA_STACK_ENTRY = /\n\s*at [^:]*:[^\n]*/;
var IS_V8_OR_CHAKRA_STACK = V8_OR_CHAKRA_STACK_ENTRY.test(TEST);

module.exports = function (stack, dropEntries) {
  if (IS_V8_OR_CHAKRA_STACK && typeof stack == 'string') {
    while (dropEntries--) stack = replace(stack, V8_OR_CHAKRA_STACK_ENTRY, '');
  } return stack;
};


/***/ }),

/***/ 9920:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var hasOwn = __webpack_require__(2597);
var ownKeys = __webpack_require__(3887);
var getOwnPropertyDescriptorModule = __webpack_require__(1236);
var definePropertyModule = __webpack_require__(3070);

module.exports = function (target, source, exceptions) {
  var keys = ownKeys(source);
  var defineProperty = definePropertyModule.f;
  var getOwnPropertyDescriptor = getOwnPropertyDescriptorModule.f;
  for (var i = 0; i < keys.length; i++) {
    var key = keys[i];
    if (!hasOwn(target, key) && !(exceptions && hasOwn(exceptions, key))) {
      defineProperty(target, key, getOwnPropertyDescriptor(source, key));
    }
  }
};


/***/ }),

/***/ 8544:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var fails = __webpack_require__(7293);

module.exports = !fails(function () {
  function F() { /* empty */ }
  F.prototype.constructor = null;
  // eslint-disable-next-line es/no-object-getprototypeof -- required for testing
  return Object.getPrototypeOf(new F()) !== F.prototype;
});


/***/ }),

/***/ 4994:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var IteratorPrototype = (__webpack_require__(3383).IteratorPrototype);
var create = __webpack_require__(30);
var createPropertyDescriptor = __webpack_require__(9114);
var setToStringTag = __webpack_require__(8003);
var Iterators = __webpack_require__(7497);

var returnThis = function () { return this; };

module.exports = function (IteratorConstructor, NAME, next, ENUMERABLE_NEXT) {
  var TO_STRING_TAG = NAME + ' Iterator';
  IteratorConstructor.prototype = create(IteratorPrototype, { next: createPropertyDescriptor(+!ENUMERABLE_NEXT, next) });
  setToStringTag(IteratorConstructor, TO_STRING_TAG, false, true);
  Iterators[TO_STRING_TAG] = returnThis;
  return IteratorConstructor;
};


/***/ }),

/***/ 8880:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var DESCRIPTORS = __webpack_require__(9781);
var definePropertyModule = __webpack_require__(3070);
var createPropertyDescriptor = __webpack_require__(9114);

module.exports = DESCRIPTORS ? function (object, key, value) {
  return definePropertyModule.f(object, key, createPropertyDescriptor(1, value));
} : function (object, key, value) {
  object[key] = value;
  return object;
};


/***/ }),

/***/ 9114:
/***/ (function(module) {

module.exports = function (bitmap, value) {
  return {
    enumerable: !(bitmap & 1),
    configurable: !(bitmap & 2),
    writable: !(bitmap & 4),
    value: value
  };
};


/***/ }),

/***/ 6135:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var toPropertyKey = __webpack_require__(4948);
var definePropertyModule = __webpack_require__(3070);
var createPropertyDescriptor = __webpack_require__(9114);

module.exports = function (object, key, value) {
  var propertyKey = toPropertyKey(key);
  if (propertyKey in object) definePropertyModule.f(object, propertyKey, createPropertyDescriptor(0, value));
  else object[propertyKey] = value;
};


/***/ }),

/***/ 654:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var $ = __webpack_require__(2109);
var call = __webpack_require__(6916);
var IS_PURE = __webpack_require__(1913);
var FunctionName = __webpack_require__(6530);
var isCallable = __webpack_require__(614);
var createIteratorConstructor = __webpack_require__(4994);
var getPrototypeOf = __webpack_require__(9518);
var setPrototypeOf = __webpack_require__(7674);
var setToStringTag = __webpack_require__(8003);
var createNonEnumerableProperty = __webpack_require__(8880);
var redefine = __webpack_require__(1320);
var wellKnownSymbol = __webpack_require__(5112);
var Iterators = __webpack_require__(7497);
var IteratorsCore = __webpack_require__(3383);

var PROPER_FUNCTION_NAME = FunctionName.PROPER;
var CONFIGURABLE_FUNCTION_NAME = FunctionName.CONFIGURABLE;
var IteratorPrototype = IteratorsCore.IteratorPrototype;
var BUGGY_SAFARI_ITERATORS = IteratorsCore.BUGGY_SAFARI_ITERATORS;
var ITERATOR = wellKnownSymbol('iterator');
var KEYS = 'keys';
var VALUES = 'values';
var ENTRIES = 'entries';

var returnThis = function () { return this; };

module.exports = function (Iterable, NAME, IteratorConstructor, next, DEFAULT, IS_SET, FORCED) {
  createIteratorConstructor(IteratorConstructor, NAME, next);

  var getIterationMethod = function (KIND) {
    if (KIND === DEFAULT && defaultIterator) return defaultIterator;
    if (!BUGGY_SAFARI_ITERATORS && KIND in IterablePrototype) return IterablePrototype[KIND];
    switch (KIND) {
      case KEYS: return function keys() { return new IteratorConstructor(this, KIND); };
      case VALUES: return function values() { return new IteratorConstructor(this, KIND); };
      case ENTRIES: return function entries() { return new IteratorConstructor(this, KIND); };
    } return function () { return new IteratorConstructor(this); };
  };

  var TO_STRING_TAG = NAME + ' Iterator';
  var INCORRECT_VALUES_NAME = false;
  var IterablePrototype = Iterable.prototype;
  var nativeIterator = IterablePrototype[ITERATOR]
    || IterablePrototype['@@iterator']
    || DEFAULT && IterablePrototype[DEFAULT];
  var defaultIterator = !BUGGY_SAFARI_ITERATORS && nativeIterator || getIterationMethod(DEFAULT);
  var anyNativeIterator = NAME == 'Array' ? IterablePrototype.entries || nativeIterator : nativeIterator;
  var CurrentIteratorPrototype, methods, KEY;

  // fix native
  if (anyNativeIterator) {
    CurrentIteratorPrototype = getPrototypeOf(anyNativeIterator.call(new Iterable()));
    if (CurrentIteratorPrototype !== Object.prototype && CurrentIteratorPrototype.next) {
      if (!IS_PURE && getPrototypeOf(CurrentIteratorPrototype) !== IteratorPrototype) {
        if (setPrototypeOf) {
          setPrototypeOf(CurrentIteratorPrototype, IteratorPrototype);
        } else if (!isCallable(CurrentIteratorPrototype[ITERATOR])) {
          redefine(CurrentIteratorPrototype, ITERATOR, returnThis);
        }
      }
      // Set @@toStringTag to native iterators
      setToStringTag(CurrentIteratorPrototype, TO_STRING_TAG, true, true);
      if (IS_PURE) Iterators[TO_STRING_TAG] = returnThis;
    }
  }

  // fix Array.prototype.{ values, @@iterator }.name in V8 / FF
  if (PROPER_FUNCTION_NAME && DEFAULT == VALUES && nativeIterator && nativeIterator.name !== VALUES) {
    if (!IS_PURE && CONFIGURABLE_FUNCTION_NAME) {
      createNonEnumerableProperty(IterablePrototype, 'name', VALUES);
    } else {
      INCORRECT_VALUES_NAME = true;
      defaultIterator = function values() { return call(nativeIterator, this); };
    }
  }

  // export additional methods
  if (DEFAULT) {
    methods = {
      values: getIterationMethod(VALUES),
      keys: IS_SET ? defaultIterator : getIterationMethod(KEYS),
      entries: getIterationMethod(ENTRIES)
    };
    if (FORCED) for (KEY in methods) {
      if (BUGGY_SAFARI_ITERATORS || INCORRECT_VALUES_NAME || !(KEY in IterablePrototype)) {
        redefine(IterablePrototype, KEY, methods[KEY]);
      }
    } else $({ target: NAME, proto: true, forced: BUGGY_SAFARI_ITERATORS || INCORRECT_VALUES_NAME }, methods);
  }

  // define iterator
  if ((!IS_PURE || FORCED) && IterablePrototype[ITERATOR] !== defaultIterator) {
    redefine(IterablePrototype, ITERATOR, defaultIterator, { name: DEFAULT });
  }
  Iterators[NAME] = defaultIterator;

  return methods;
};


/***/ }),

/***/ 9781:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var fails = __webpack_require__(7293);

// Detect IE8's incomplete defineProperty implementation
module.exports = !fails(function () {
  // eslint-disable-next-line es/no-object-defineproperty -- required for testing
  return Object.defineProperty({}, 1, { get: function () { return 7; } })[1] != 7;
});


/***/ }),

/***/ 317:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var isObject = __webpack_require__(111);

var document = global.document;
// typeof document.createElement is 'object' in old IE
var EXISTS = isObject(document) && isObject(document.createElement);

module.exports = function (it) {
  return EXISTS ? document.createElement(it) : {};
};


/***/ }),

/***/ 3678:
/***/ (function(module) {

module.exports = {
  IndexSizeError: { s: 'INDEX_SIZE_ERR', c: 1, m: 1 },
  DOMStringSizeError: { s: 'DOMSTRING_SIZE_ERR', c: 2, m: 0 },
  HierarchyRequestError: { s: 'HIERARCHY_REQUEST_ERR', c: 3, m: 1 },
  WrongDocumentError: { s: 'WRONG_DOCUMENT_ERR', c: 4, m: 1 },
  InvalidCharacterError: { s: 'INVALID_CHARACTER_ERR', c: 5, m: 1 },
  NoDataAllowedError: { s: 'NO_DATA_ALLOWED_ERR', c: 6, m: 0 },
  NoModificationAllowedError: { s: 'NO_MODIFICATION_ALLOWED_ERR', c: 7, m: 1 },
  NotFoundError: { s: 'NOT_FOUND_ERR', c: 8, m: 1 },
  NotSupportedError: { s: 'NOT_SUPPORTED_ERR', c: 9, m: 1 },
  InUseAttributeError: { s: 'INUSE_ATTRIBUTE_ERR', c: 10, m: 1 },
  InvalidStateError: { s: 'INVALID_STATE_ERR', c: 11, m: 1 },
  SyntaxError: { s: 'SYNTAX_ERR', c: 12, m: 1 },
  InvalidModificationError: { s: 'INVALID_MODIFICATION_ERR', c: 13, m: 1 },
  NamespaceError: { s: 'NAMESPACE_ERR', c: 14, m: 1 },
  InvalidAccessError: { s: 'INVALID_ACCESS_ERR', c: 15, m: 1 },
  ValidationError: { s: 'VALIDATION_ERR', c: 16, m: 0 },
  TypeMismatchError: { s: 'TYPE_MISMATCH_ERR', c: 17, m: 1 },
  SecurityError: { s: 'SECURITY_ERR', c: 18, m: 1 },
  NetworkError: { s: 'NETWORK_ERR', c: 19, m: 1 },
  AbortError: { s: 'ABORT_ERR', c: 20, m: 1 },
  URLMismatchError: { s: 'URL_MISMATCH_ERR', c: 21, m: 1 },
  QuotaExceededError: { s: 'QUOTA_EXCEEDED_ERR', c: 22, m: 1 },
  TimeoutError: { s: 'TIMEOUT_ERR', c: 23, m: 1 },
  InvalidNodeTypeError: { s: 'INVALID_NODE_TYPE_ERR', c: 24, m: 1 },
  DataCloneError: { s: 'DATA_CLONE_ERR', c: 25, m: 1 }
};


/***/ }),

/***/ 8324:
/***/ (function(module) {

// iterable DOM collections
// flag - `iterable` interface - 'entries', 'keys', 'values', 'forEach' methods
module.exports = {
  CSSRuleList: 0,
  CSSStyleDeclaration: 0,
  CSSValueList: 0,
  ClientRectList: 0,
  DOMRectList: 0,
  DOMStringList: 0,
  DOMTokenList: 1,
  DataTransferItemList: 0,
  FileList: 0,
  HTMLAllCollection: 0,
  HTMLCollection: 0,
  HTMLFormElement: 0,
  HTMLSelectElement: 0,
  MediaList: 0,
  MimeTypeArray: 0,
  NamedNodeMap: 0,
  NodeList: 1,
  PaintRequestList: 0,
  Plugin: 0,
  PluginArray: 0,
  SVGLengthList: 0,
  SVGNumberList: 0,
  SVGPathSegList: 0,
  SVGPointList: 0,
  SVGStringList: 0,
  SVGTransformList: 0,
  SourceBufferList: 0,
  StyleSheetList: 0,
  TextTrackCueList: 0,
  TextTrackList: 0,
  TouchList: 0
};


/***/ }),

/***/ 8509:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

// in old WebKit versions, `element.classList` is not an instance of global `DOMTokenList`
var documentCreateElement = __webpack_require__(317);

var classList = documentCreateElement('span').classList;
var DOMTokenListPrototype = classList && classList.constructor && classList.constructor.prototype;

module.exports = DOMTokenListPrototype === Object.prototype ? undefined : DOMTokenListPrototype;


/***/ }),

/***/ 7871:
/***/ (function(module) {

module.exports = typeof window == 'object';


/***/ }),

/***/ 1528:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var userAgent = __webpack_require__(8113);
var global = __webpack_require__(7854);

module.exports = /ipad|iphone|ipod/i.test(userAgent) && global.Pebble !== undefined;


/***/ }),

/***/ 6833:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var userAgent = __webpack_require__(8113);

module.exports = /(?:ipad|iphone|ipod).*applewebkit/i.test(userAgent);


/***/ }),

/***/ 5268:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var classof = __webpack_require__(4326);
var global = __webpack_require__(7854);

module.exports = classof(global.process) == 'process';


/***/ }),

/***/ 1036:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var userAgent = __webpack_require__(8113);

module.exports = /web0s(?!.*chrome)/i.test(userAgent);


/***/ }),

/***/ 8113:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var getBuiltIn = __webpack_require__(5005);

module.exports = getBuiltIn('navigator', 'userAgent') || '';


/***/ }),

/***/ 7392:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var userAgent = __webpack_require__(8113);

var process = global.process;
var Deno = global.Deno;
var versions = process && process.versions || Deno && Deno.version;
var v8 = versions && versions.v8;
var match, version;

if (v8) {
  match = v8.split('.');
  // in old Chrome, versions of V8 isn't V8 = Chrome / 10
  // but their correct versions are not interesting for us
  version = match[0] > 0 && match[0] < 4 ? 1 : +(match[0] + match[1]);
}

// BrowserFS NodeJS `process` polyfill incorrectly set `.v8` to `0.0`
// so check `userAgent` even if `.v8` exists, but 0
if (!version && userAgent) {
  match = userAgent.match(/Edge\/(\d+)/);
  if (!match || match[1] >= 74) {
    match = userAgent.match(/Chrome\/(\d+)/);
    if (match) version = +match[1];
  }
}

module.exports = version;


/***/ }),

/***/ 748:
/***/ (function(module) {

// IE8- don't enum bug keys
module.exports = [
  'constructor',
  'hasOwnProperty',
  'isPrototypeOf',
  'propertyIsEnumerable',
  'toLocaleString',
  'toString',
  'valueOf'
];


/***/ }),

/***/ 2914:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var fails = __webpack_require__(7293);
var createPropertyDescriptor = __webpack_require__(9114);

module.exports = !fails(function () {
  var error = Error('a');
  if (!('stack' in error)) return true;
  // eslint-disable-next-line es/no-object-defineproperty -- safe
  Object.defineProperty(error, 'stack', createPropertyDescriptor(1, 7));
  return error.stack !== 7;
});


/***/ }),

/***/ 7762:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var DESCRIPTORS = __webpack_require__(9781);
var fails = __webpack_require__(7293);
var anObject = __webpack_require__(9670);
var create = __webpack_require__(30);
var normalizeStringArgument = __webpack_require__(6277);

var nativeErrorToString = Error.prototype.toString;

var INCORRECT_TO_STRING = fails(function () {
  if (DESCRIPTORS) {
    // Chrome 32- incorrectly call accessor
    // eslint-disable-next-line es/no-object-defineproperty -- safe
    var object = create(Object.defineProperty({}, 'name', { get: function () {
      return this === object;
    } }));
    if (nativeErrorToString.call(object) !== 'true') return true;
  }
  // FF10- does not properly handle non-strings
  return nativeErrorToString.call({ message: 1, name: 2 }) !== '2: 1'
    // IE8 does not properly handle defaults
    || nativeErrorToString.call({}) !== 'Error';
});

module.exports = INCORRECT_TO_STRING ? function toString() {
  var O = anObject(this);
  var name = normalizeStringArgument(O.name, 'Error');
  var message = normalizeStringArgument(O.message);
  return !name ? message : !message ? name : name + ': ' + message;
} : nativeErrorToString;


/***/ }),

/***/ 2109:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var getOwnPropertyDescriptor = (__webpack_require__(1236).f);
var createNonEnumerableProperty = __webpack_require__(8880);
var redefine = __webpack_require__(1320);
var setGlobal = __webpack_require__(3505);
var copyConstructorProperties = __webpack_require__(9920);
var isForced = __webpack_require__(4705);

/*
  options.target      - name of the target object
  options.global      - target is the global object
  options.stat        - export as static methods of target
  options.proto       - export as prototype methods of target
  options.real        - real prototype method for the `pure` version
  options.forced      - export even if the native feature is available
  options.bind        - bind methods to the target, required for the `pure` version
  options.wrap        - wrap constructors to preventing global pollution, required for the `pure` version
  options.unsafe      - use the simple assignment of property instead of delete + defineProperty
  options.sham        - add a flag to not completely full polyfills
  options.enumerable  - export as enumerable property
  options.noTargetGet - prevent calling a getter on target
  options.name        - the .name of the function if it does not match the key
*/
module.exports = function (options, source) {
  var TARGET = options.target;
  var GLOBAL = options.global;
  var STATIC = options.stat;
  var FORCED, target, key, targetProperty, sourceProperty, descriptor;
  if (GLOBAL) {
    target = global;
  } else if (STATIC) {
    target = global[TARGET] || setGlobal(TARGET, {});
  } else {
    target = (global[TARGET] || {}).prototype;
  }
  if (target) for (key in source) {
    sourceProperty = source[key];
    if (options.noTargetGet) {
      descriptor = getOwnPropertyDescriptor(target, key);
      targetProperty = descriptor && descriptor.value;
    } else targetProperty = target[key];
    FORCED = isForced(GLOBAL ? key : TARGET + (STATIC ? '.' : '#') + key, options.forced);
    // contained in target
    if (!FORCED && targetProperty !== undefined) {
      if (typeof sourceProperty == typeof targetProperty) continue;
      copyConstructorProperties(sourceProperty, targetProperty);
    }
    // add a flag to not completely full polyfills
    if (options.sham || (targetProperty && targetProperty.sham)) {
      createNonEnumerableProperty(sourceProperty, 'sham', true);
    }
    // extend global
    redefine(target, key, sourceProperty, options);
  }
};


/***/ }),

/***/ 7293:
/***/ (function(module) {

module.exports = function (exec) {
  try {
    return !!exec();
  } catch (error) {
    return true;
  }
};


/***/ }),

/***/ 2104:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var NATIVE_BIND = __webpack_require__(4374);

var FunctionPrototype = Function.prototype;
var apply = FunctionPrototype.apply;
var call = FunctionPrototype.call;

// eslint-disable-next-line es/no-reflect -- safe
module.exports = typeof Reflect == 'object' && Reflect.apply || (NATIVE_BIND ? call.bind(apply) : function () {
  return call.apply(apply, arguments);
});


/***/ }),

/***/ 9974:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var uncurryThis = __webpack_require__(1702);
var aCallable = __webpack_require__(9662);
var NATIVE_BIND = __webpack_require__(4374);

var bind = uncurryThis(uncurryThis.bind);

// optional / simple context binding
module.exports = function (fn, that) {
  aCallable(fn);
  return that === undefined ? fn : NATIVE_BIND ? bind(fn, that) : function (/* ...args */) {
    return fn.apply(that, arguments);
  };
};


/***/ }),

/***/ 4374:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var fails = __webpack_require__(7293);

module.exports = !fails(function () {
  var test = (function () { /* empty */ }).bind();
  // eslint-disable-next-line no-prototype-builtins -- safe
  return typeof test != 'function' || test.hasOwnProperty('prototype');
});


/***/ }),

/***/ 6916:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var NATIVE_BIND = __webpack_require__(4374);

var call = Function.prototype.call;

module.exports = NATIVE_BIND ? call.bind(call) : function () {
  return call.apply(call, arguments);
};


/***/ }),

/***/ 6530:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var DESCRIPTORS = __webpack_require__(9781);
var hasOwn = __webpack_require__(2597);

var FunctionPrototype = Function.prototype;
// eslint-disable-next-line es/no-object-getownpropertydescriptor -- safe
var getDescriptor = DESCRIPTORS && Object.getOwnPropertyDescriptor;

var EXISTS = hasOwn(FunctionPrototype, 'name');
// additional protection from minified / mangled / dropped function names
var PROPER = EXISTS && (function something() { /* empty */ }).name === 'something';
var CONFIGURABLE = EXISTS && (!DESCRIPTORS || (DESCRIPTORS && getDescriptor(FunctionPrototype, 'name').configurable));

module.exports = {
  EXISTS: EXISTS,
  PROPER: PROPER,
  CONFIGURABLE: CONFIGURABLE
};


/***/ }),

/***/ 1702:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var NATIVE_BIND = __webpack_require__(4374);

var FunctionPrototype = Function.prototype;
var bind = FunctionPrototype.bind;
var call = FunctionPrototype.call;
var uncurryThis = NATIVE_BIND && bind.bind(call, call);

module.exports = NATIVE_BIND ? function (fn) {
  return fn && uncurryThis(fn);
} : function (fn) {
  return fn && function () {
    return call.apply(fn, arguments);
  };
};


/***/ }),

/***/ 5005:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var isCallable = __webpack_require__(614);

var aFunction = function (argument) {
  return isCallable(argument) ? argument : undefined;
};

module.exports = function (namespace, method) {
  return arguments.length < 2 ? aFunction(global[namespace]) : global[namespace] && global[namespace][method];
};


/***/ }),

/***/ 1246:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var classof = __webpack_require__(648);
var getMethod = __webpack_require__(8173);
var Iterators = __webpack_require__(7497);
var wellKnownSymbol = __webpack_require__(5112);

var ITERATOR = wellKnownSymbol('iterator');

module.exports = function (it) {
  if (it != undefined) return getMethod(it, ITERATOR)
    || getMethod(it, '@@iterator')
    || Iterators[classof(it)];
};


/***/ }),

/***/ 8554:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var call = __webpack_require__(6916);
var aCallable = __webpack_require__(9662);
var anObject = __webpack_require__(9670);
var tryToString = __webpack_require__(6330);
var getIteratorMethod = __webpack_require__(1246);

var TypeError = global.TypeError;

module.exports = function (argument, usingIterator) {
  var iteratorMethod = arguments.length < 2 ? getIteratorMethod(argument) : usingIterator;
  if (aCallable(iteratorMethod)) return anObject(call(iteratorMethod, argument));
  throw TypeError(tryToString(argument) + ' is not iterable');
};


/***/ }),

/***/ 8173:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var aCallable = __webpack_require__(9662);

// `GetMethod` abstract operation
// https://tc39.es/ecma262/#sec-getmethod
module.exports = function (V, P) {
  var func = V[P];
  return func == null ? undefined : aCallable(func);
};


/***/ }),

/***/ 7854:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var check = function (it) {
  return it && it.Math == Math && it;
};

// https://github.com/zloirock/core-js/issues/86#issuecomment-115759028
module.exports =
  // eslint-disable-next-line es/no-global-this -- safe
  check(typeof globalThis == 'object' && globalThis) ||
  check(typeof window == 'object' && window) ||
  // eslint-disable-next-line no-restricted-globals -- safe
  check(typeof self == 'object' && self) ||
  check(typeof __webpack_require__.g == 'object' && __webpack_require__.g) ||
  // eslint-disable-next-line no-new-func -- fallback
  (function () { return this; })() || Function('return this')();


/***/ }),

/***/ 2597:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var uncurryThis = __webpack_require__(1702);
var toObject = __webpack_require__(7908);

var hasOwnProperty = uncurryThis({}.hasOwnProperty);

// `HasOwnProperty` abstract operation
// https://tc39.es/ecma262/#sec-hasownproperty
module.exports = Object.hasOwn || function hasOwn(it, key) {
  return hasOwnProperty(toObject(it), key);
};


/***/ }),

/***/ 3501:
/***/ (function(module) {

module.exports = {};


/***/ }),

/***/ 842:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);

module.exports = function (a, b) {
  var console = global.console;
  if (console && console.error) {
    arguments.length == 1 ? console.error(a) : console.error(a, b);
  }
};


/***/ }),

/***/ 490:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var getBuiltIn = __webpack_require__(5005);

module.exports = getBuiltIn('document', 'documentElement');


/***/ }),

/***/ 4664:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var DESCRIPTORS = __webpack_require__(9781);
var fails = __webpack_require__(7293);
var createElement = __webpack_require__(317);

// Thanks to IE8 for its funny defineProperty
module.exports = !DESCRIPTORS && !fails(function () {
  // eslint-disable-next-line es/no-object-defineproperty -- required for testing
  return Object.defineProperty(createElement('div'), 'a', {
    get: function () { return 7; }
  }).a != 7;
});


/***/ }),

/***/ 8361:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var uncurryThis = __webpack_require__(1702);
var fails = __webpack_require__(7293);
var classof = __webpack_require__(4326);

var Object = global.Object;
var split = uncurryThis(''.split);

// fallback for non-array-like ES3 and non-enumerable old V8 strings
module.exports = fails(function () {
  // throws an error in rhino, see https://github.com/mozilla/rhino/issues/346
  // eslint-disable-next-line no-prototype-builtins -- safe
  return !Object('z').propertyIsEnumerable(0);
}) ? function (it) {
  return classof(it) == 'String' ? split(it, '') : Object(it);
} : Object;


/***/ }),

/***/ 9587:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var isCallable = __webpack_require__(614);
var isObject = __webpack_require__(111);
var setPrototypeOf = __webpack_require__(7674);

// makes subclassing work correct for wrapped built-ins
module.exports = function ($this, dummy, Wrapper) {
  var NewTarget, NewTargetPrototype;
  if (
    // it can work only with native `setPrototypeOf`
    setPrototypeOf &&
    // we haven't completely correct pre-ES6 way for getting `new.target`, so use this
    isCallable(NewTarget = dummy.constructor) &&
    NewTarget !== Wrapper &&
    isObject(NewTargetPrototype = NewTarget.prototype) &&
    NewTargetPrototype !== Wrapper.prototype
  ) setPrototypeOf($this, NewTargetPrototype);
  return $this;
};


/***/ }),

/***/ 2788:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var uncurryThis = __webpack_require__(1702);
var isCallable = __webpack_require__(614);
var store = __webpack_require__(5465);

var functionToString = uncurryThis(Function.toString);

// this helper broken in `core-js@3.4.1-3.4.4`, so we can't use `shared` helper
if (!isCallable(store.inspectSource)) {
  store.inspectSource = function (it) {
    return functionToString(it);
  };
}

module.exports = store.inspectSource;


/***/ }),

/***/ 8340:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var isObject = __webpack_require__(111);
var createNonEnumerableProperty = __webpack_require__(8880);

// `InstallErrorCause` abstract operation
// https://tc39.es/proposal-error-cause/#sec-errorobjects-install-error-cause
module.exports = function (O, options) {
  if (isObject(options) && 'cause' in options) {
    createNonEnumerableProperty(O, 'cause', options.cause);
  }
};


/***/ }),

/***/ 9909:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var NATIVE_WEAK_MAP = __webpack_require__(8536);
var global = __webpack_require__(7854);
var uncurryThis = __webpack_require__(1702);
var isObject = __webpack_require__(111);
var createNonEnumerableProperty = __webpack_require__(8880);
var hasOwn = __webpack_require__(2597);
var shared = __webpack_require__(5465);
var sharedKey = __webpack_require__(6200);
var hiddenKeys = __webpack_require__(3501);

var OBJECT_ALREADY_INITIALIZED = 'Object already initialized';
var TypeError = global.TypeError;
var WeakMap = global.WeakMap;
var set, get, has;

var enforce = function (it) {
  return has(it) ? get(it) : set(it, {});
};

var getterFor = function (TYPE) {
  return function (it) {
    var state;
    if (!isObject(it) || (state = get(it)).type !== TYPE) {
      throw TypeError('Incompatible receiver, ' + TYPE + ' required');
    } return state;
  };
};

if (NATIVE_WEAK_MAP || shared.state) {
  var store = shared.state || (shared.state = new WeakMap());
  var wmget = uncurryThis(store.get);
  var wmhas = uncurryThis(store.has);
  var wmset = uncurryThis(store.set);
  set = function (it, metadata) {
    if (wmhas(store, it)) throw new TypeError(OBJECT_ALREADY_INITIALIZED);
    metadata.facade = it;
    wmset(store, it, metadata);
    return metadata;
  };
  get = function (it) {
    return wmget(store, it) || {};
  };
  has = function (it) {
    return wmhas(store, it);
  };
} else {
  var STATE = sharedKey('state');
  hiddenKeys[STATE] = true;
  set = function (it, metadata) {
    if (hasOwn(it, STATE)) throw new TypeError(OBJECT_ALREADY_INITIALIZED);
    metadata.facade = it;
    createNonEnumerableProperty(it, STATE, metadata);
    return metadata;
  };
  get = function (it) {
    return hasOwn(it, STATE) ? it[STATE] : {};
  };
  has = function (it) {
    return hasOwn(it, STATE);
  };
}

module.exports = {
  set: set,
  get: get,
  has: has,
  enforce: enforce,
  getterFor: getterFor
};


/***/ }),

/***/ 7659:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var wellKnownSymbol = __webpack_require__(5112);
var Iterators = __webpack_require__(7497);

var ITERATOR = wellKnownSymbol('iterator');
var ArrayPrototype = Array.prototype;

// check on default Array iterator
module.exports = function (it) {
  return it !== undefined && (Iterators.Array === it || ArrayPrototype[ITERATOR] === it);
};


/***/ }),

/***/ 3157:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var classof = __webpack_require__(4326);

// `IsArray` abstract operation
// https://tc39.es/ecma262/#sec-isarray
// eslint-disable-next-line es/no-array-isarray -- safe
module.exports = Array.isArray || function isArray(argument) {
  return classof(argument) == 'Array';
};


/***/ }),

/***/ 614:
/***/ (function(module) {

// `IsCallable` abstract operation
// https://tc39.es/ecma262/#sec-iscallable
module.exports = function (argument) {
  return typeof argument == 'function';
};


/***/ }),

/***/ 4411:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var uncurryThis = __webpack_require__(1702);
var fails = __webpack_require__(7293);
var isCallable = __webpack_require__(614);
var classof = __webpack_require__(648);
var getBuiltIn = __webpack_require__(5005);
var inspectSource = __webpack_require__(2788);

var noop = function () { /* empty */ };
var empty = [];
var construct = getBuiltIn('Reflect', 'construct');
var constructorRegExp = /^\s*(?:class|function)\b/;
var exec = uncurryThis(constructorRegExp.exec);
var INCORRECT_TO_STRING = !constructorRegExp.exec(noop);

var isConstructorModern = function isConstructor(argument) {
  if (!isCallable(argument)) return false;
  try {
    construct(noop, empty, argument);
    return true;
  } catch (error) {
    return false;
  }
};

var isConstructorLegacy = function isConstructor(argument) {
  if (!isCallable(argument)) return false;
  switch (classof(argument)) {
    case 'AsyncFunction':
    case 'GeneratorFunction':
    case 'AsyncGeneratorFunction': return false;
  }
  try {
    // we can't check .prototype since constructors produced by .bind haven't it
    // `Function#toString` throws on some built-it function in some legacy engines
    // (for example, `DOMQuad` and similar in FF41-)
    return INCORRECT_TO_STRING || !!exec(constructorRegExp, inspectSource(argument));
  } catch (error) {
    return true;
  }
};

isConstructorLegacy.sham = true;

// `IsConstructor` abstract operation
// https://tc39.es/ecma262/#sec-isconstructor
module.exports = !construct || fails(function () {
  var called;
  return isConstructorModern(isConstructorModern.call)
    || !isConstructorModern(Object)
    || !isConstructorModern(function () { called = true; })
    || called;
}) ? isConstructorLegacy : isConstructorModern;


/***/ }),

/***/ 4705:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var fails = __webpack_require__(7293);
var isCallable = __webpack_require__(614);

var replacement = /#|\.prototype\./;

var isForced = function (feature, detection) {
  var value = data[normalize(feature)];
  return value == POLYFILL ? true
    : value == NATIVE ? false
    : isCallable(detection) ? fails(detection)
    : !!detection;
};

var normalize = isForced.normalize = function (string) {
  return String(string).replace(replacement, '.').toLowerCase();
};

var data = isForced.data = {};
var NATIVE = isForced.NATIVE = 'N';
var POLYFILL = isForced.POLYFILL = 'P';

module.exports = isForced;


/***/ }),

/***/ 111:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var isCallable = __webpack_require__(614);

module.exports = function (it) {
  return typeof it == 'object' ? it !== null : isCallable(it);
};


/***/ }),

/***/ 1913:
/***/ (function(module) {

module.exports = false;


/***/ }),

/***/ 2190:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var getBuiltIn = __webpack_require__(5005);
var isCallable = __webpack_require__(614);
var isPrototypeOf = __webpack_require__(7976);
var USE_SYMBOL_AS_UID = __webpack_require__(3307);

var Object = global.Object;

module.exports = USE_SYMBOL_AS_UID ? function (it) {
  return typeof it == 'symbol';
} : function (it) {
  var $Symbol = getBuiltIn('Symbol');
  return isCallable($Symbol) && isPrototypeOf($Symbol.prototype, Object(it));
};


/***/ }),

/***/ 408:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var bind = __webpack_require__(9974);
var call = __webpack_require__(6916);
var anObject = __webpack_require__(9670);
var tryToString = __webpack_require__(6330);
var isArrayIteratorMethod = __webpack_require__(7659);
var lengthOfArrayLike = __webpack_require__(6244);
var isPrototypeOf = __webpack_require__(7976);
var getIterator = __webpack_require__(8554);
var getIteratorMethod = __webpack_require__(1246);
var iteratorClose = __webpack_require__(9212);

var TypeError = global.TypeError;

var Result = function (stopped, result) {
  this.stopped = stopped;
  this.result = result;
};

var ResultPrototype = Result.prototype;

module.exports = function (iterable, unboundFunction, options) {
  var that = options && options.that;
  var AS_ENTRIES = !!(options && options.AS_ENTRIES);
  var IS_ITERATOR = !!(options && options.IS_ITERATOR);
  var INTERRUPTED = !!(options && options.INTERRUPTED);
  var fn = bind(unboundFunction, that);
  var iterator, iterFn, index, length, result, next, step;

  var stop = function (condition) {
    if (iterator) iteratorClose(iterator, 'normal', condition);
    return new Result(true, condition);
  };

  var callFn = function (value) {
    if (AS_ENTRIES) {
      anObject(value);
      return INTERRUPTED ? fn(value[0], value[1], stop) : fn(value[0], value[1]);
    } return INTERRUPTED ? fn(value, stop) : fn(value);
  };

  if (IS_ITERATOR) {
    iterator = iterable;
  } else {
    iterFn = getIteratorMethod(iterable);
    if (!iterFn) throw TypeError(tryToString(iterable) + ' is not iterable');
    // optimisation for array iterators
    if (isArrayIteratorMethod(iterFn)) {
      for (index = 0, length = lengthOfArrayLike(iterable); length > index; index++) {
        result = callFn(iterable[index]);
        if (result && isPrototypeOf(ResultPrototype, result)) return result;
      } return new Result(false);
    }
    iterator = getIterator(iterable, iterFn);
  }

  next = iterator.next;
  while (!(step = call(next, iterator)).done) {
    try {
      result = callFn(step.value);
    } catch (error) {
      iteratorClose(iterator, 'throw', error);
    }
    if (typeof result == 'object' && result && isPrototypeOf(ResultPrototype, result)) return result;
  } return new Result(false);
};


/***/ }),

/***/ 9212:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var call = __webpack_require__(6916);
var anObject = __webpack_require__(9670);
var getMethod = __webpack_require__(8173);

module.exports = function (iterator, kind, value) {
  var innerResult, innerError;
  anObject(iterator);
  try {
    innerResult = getMethod(iterator, 'return');
    if (!innerResult) {
      if (kind === 'throw') throw value;
      return value;
    }
    innerResult = call(innerResult, iterator);
  } catch (error) {
    innerError = true;
    innerResult = error;
  }
  if (kind === 'throw') throw value;
  if (innerError) throw innerResult;
  anObject(innerResult);
  return value;
};


/***/ }),

/***/ 3383:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var fails = __webpack_require__(7293);
var isCallable = __webpack_require__(614);
var create = __webpack_require__(30);
var getPrototypeOf = __webpack_require__(9518);
var redefine = __webpack_require__(1320);
var wellKnownSymbol = __webpack_require__(5112);
var IS_PURE = __webpack_require__(1913);

var ITERATOR = wellKnownSymbol('iterator');
var BUGGY_SAFARI_ITERATORS = false;

// `%IteratorPrototype%` object
// https://tc39.es/ecma262/#sec-%iteratorprototype%-object
var IteratorPrototype, PrototypeOfArrayIteratorPrototype, arrayIterator;

/* eslint-disable es/no-array-prototype-keys -- safe */
if ([].keys) {
  arrayIterator = [].keys();
  // Safari 8 has buggy iterators w/o `next`
  if (!('next' in arrayIterator)) BUGGY_SAFARI_ITERATORS = true;
  else {
    PrototypeOfArrayIteratorPrototype = getPrototypeOf(getPrototypeOf(arrayIterator));
    if (PrototypeOfArrayIteratorPrototype !== Object.prototype) IteratorPrototype = PrototypeOfArrayIteratorPrototype;
  }
}

var NEW_ITERATOR_PROTOTYPE = IteratorPrototype == undefined || fails(function () {
  var test = {};
  // FF44- legacy iterators case
  return IteratorPrototype[ITERATOR].call(test) !== test;
});

if (NEW_ITERATOR_PROTOTYPE) IteratorPrototype = {};
else if (IS_PURE) IteratorPrototype = create(IteratorPrototype);

// `%IteratorPrototype%[@@iterator]()` method
// https://tc39.es/ecma262/#sec-%iteratorprototype%-@@iterator
if (!isCallable(IteratorPrototype[ITERATOR])) {
  redefine(IteratorPrototype, ITERATOR, function () {
    return this;
  });
}

module.exports = {
  IteratorPrototype: IteratorPrototype,
  BUGGY_SAFARI_ITERATORS: BUGGY_SAFARI_ITERATORS
};


/***/ }),

/***/ 7497:
/***/ (function(module) {

module.exports = {};


/***/ }),

/***/ 6244:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var toLength = __webpack_require__(7466);

// `LengthOfArrayLike` abstract operation
// https://tc39.es/ecma262/#sec-lengthofarraylike
module.exports = function (obj) {
  return toLength(obj.length);
};


/***/ }),

/***/ 5948:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var bind = __webpack_require__(9974);
var getOwnPropertyDescriptor = (__webpack_require__(1236).f);
var macrotask = (__webpack_require__(261).set);
var IS_IOS = __webpack_require__(6833);
var IS_IOS_PEBBLE = __webpack_require__(1528);
var IS_WEBOS_WEBKIT = __webpack_require__(1036);
var IS_NODE = __webpack_require__(5268);

var MutationObserver = global.MutationObserver || global.WebKitMutationObserver;
var document = global.document;
var process = global.process;
var Promise = global.Promise;
// Node.js 11 shows ExperimentalWarning on getting `queueMicrotask`
var queueMicrotaskDescriptor = getOwnPropertyDescriptor(global, 'queueMicrotask');
var queueMicrotask = queueMicrotaskDescriptor && queueMicrotaskDescriptor.value;

var flush, head, last, notify, toggle, node, promise, then;

// modern engines have queueMicrotask method
if (!queueMicrotask) {
  flush = function () {
    var parent, fn;
    if (IS_NODE && (parent = process.domain)) parent.exit();
    while (head) {
      fn = head.fn;
      head = head.next;
      try {
        fn();
      } catch (error) {
        if (head) notify();
        else last = undefined;
        throw error;
      }
    } last = undefined;
    if (parent) parent.enter();
  };

  // browsers with MutationObserver, except iOS - https://github.com/zloirock/core-js/issues/339
  // also except WebOS Webkit https://github.com/zloirock/core-js/issues/898
  if (!IS_IOS && !IS_NODE && !IS_WEBOS_WEBKIT && MutationObserver && document) {
    toggle = true;
    node = document.createTextNode('');
    new MutationObserver(flush).observe(node, { characterData: true });
    notify = function () {
      node.data = toggle = !toggle;
    };
  // environments with maybe non-completely correct, but existent Promise
  } else if (!IS_IOS_PEBBLE && Promise && Promise.resolve) {
    // Promise.resolve without an argument throws an error in LG WebOS 2
    promise = Promise.resolve(undefined);
    // workaround of WebKit ~ iOS Safari 10.1 bug
    promise.constructor = Promise;
    then = bind(promise.then, promise);
    notify = function () {
      then(flush);
    };
  // Node.js without promises
  } else if (IS_NODE) {
    notify = function () {
      process.nextTick(flush);
    };
  // for other environments - macrotask based on:
  // - setImmediate
  // - MessageChannel
  // - window.postMessag
  // - onreadystatechange
  // - setTimeout
  } else {
    // strange IE + webpack dev server bug - use .bind(global)
    macrotask = bind(macrotask, global);
    notify = function () {
      macrotask(flush);
    };
  }
}

module.exports = queueMicrotask || function (fn) {
  var task = { fn: fn, next: undefined };
  if (last) last.next = task;
  if (!head) {
    head = task;
    notify();
  } last = task;
};


/***/ }),

/***/ 3366:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);

module.exports = global.Promise;


/***/ }),

/***/ 133:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

/* eslint-disable es/no-symbol -- required for testing */
var V8_VERSION = __webpack_require__(7392);
var fails = __webpack_require__(7293);

// eslint-disable-next-line es/no-object-getownpropertysymbols -- required for testing
module.exports = !!Object.getOwnPropertySymbols && !fails(function () {
  var symbol = Symbol();
  // Chrome 38 Symbol has incorrect toString conversion
  // `get-own-property-symbols` polyfill symbols converted to object are not Symbol instances
  return !String(symbol) || !(Object(symbol) instanceof Symbol) ||
    // Chrome 38-40 symbols are not inherited from DOM collections prototypes to instances
    !Symbol.sham && V8_VERSION && V8_VERSION < 41;
});


/***/ }),

/***/ 590:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var fails = __webpack_require__(7293);
var wellKnownSymbol = __webpack_require__(5112);
var IS_PURE = __webpack_require__(1913);

var ITERATOR = wellKnownSymbol('iterator');

module.exports = !fails(function () {
  // eslint-disable-next-line unicorn/relative-url-style -- required for testing
  var url = new URL('b?a=1&b=2&c=3', 'http://a');
  var searchParams = url.searchParams;
  var result = '';
  url.pathname = 'c%20d';
  searchParams.forEach(function (value, key) {
    searchParams['delete']('b');
    result += key + value;
  });
  return (IS_PURE && !url.toJSON)
    || !searchParams.sort
    || url.href !== 'http://a/c%20d?a=1&c=3'
    || searchParams.get('c') !== '3'
    || String(new URLSearchParams('?a=1')) !== 'a=1'
    || !searchParams[ITERATOR]
    // throws in Edge
    || new URL('https://a@b').username !== 'a'
    || new URLSearchParams(new URLSearchParams('a=b')).get('a') !== 'b'
    // not punycoded in Edge
    || new URL('http://тест').host !== 'xn--e1aybc'
    // not escaped in Chrome 62-
    || new URL('http://a#б').hash !== '#%D0%B1'
    // fails in Chrome 66-
    || result !== 'a1c3'
    // throws in Safari
    || new URL('http://x', undefined).host !== 'x';
});


/***/ }),

/***/ 8536:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var isCallable = __webpack_require__(614);
var inspectSource = __webpack_require__(2788);

var WeakMap = global.WeakMap;

module.exports = isCallable(WeakMap) && /native code/.test(inspectSource(WeakMap));


/***/ }),

/***/ 8523:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var aCallable = __webpack_require__(9662);

var PromiseCapability = function (C) {
  var resolve, reject;
  this.promise = new C(function ($$resolve, $$reject) {
    if (resolve !== undefined || reject !== undefined) throw TypeError('Bad Promise constructor');
    resolve = $$resolve;
    reject = $$reject;
  });
  this.resolve = aCallable(resolve);
  this.reject = aCallable(reject);
};

// `NewPromiseCapability` abstract operation
// https://tc39.es/ecma262/#sec-newpromisecapability
module.exports.f = function (C) {
  return new PromiseCapability(C);
};


/***/ }),

/***/ 6277:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var toString = __webpack_require__(1340);

module.exports = function (argument, $default) {
  return argument === undefined ? arguments.length < 2 ? '' : $default : toString(argument);
};


/***/ }),

/***/ 1574:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var DESCRIPTORS = __webpack_require__(9781);
var uncurryThis = __webpack_require__(1702);
var call = __webpack_require__(6916);
var fails = __webpack_require__(7293);
var objectKeys = __webpack_require__(1956);
var getOwnPropertySymbolsModule = __webpack_require__(5181);
var propertyIsEnumerableModule = __webpack_require__(5296);
var toObject = __webpack_require__(7908);
var IndexedObject = __webpack_require__(8361);

// eslint-disable-next-line es/no-object-assign -- safe
var $assign = Object.assign;
// eslint-disable-next-line es/no-object-defineproperty -- required for testing
var defineProperty = Object.defineProperty;
var concat = uncurryThis([].concat);

// `Object.assign` method
// https://tc39.es/ecma262/#sec-object.assign
module.exports = !$assign || fails(function () {
  // should have correct order of operations (Edge bug)
  if (DESCRIPTORS && $assign({ b: 1 }, $assign(defineProperty({}, 'a', {
    enumerable: true,
    get: function () {
      defineProperty(this, 'b', {
        value: 3,
        enumerable: false
      });
    }
  }), { b: 2 })).b !== 1) return true;
  // should work with symbols and should have deterministic property order (V8 bug)
  var A = {};
  var B = {};
  // eslint-disable-next-line es/no-symbol -- safe
  var symbol = Symbol();
  var alphabet = 'abcdefghijklmnopqrst';
  A[symbol] = 7;
  alphabet.split('').forEach(function (chr) { B[chr] = chr; });
  return $assign({}, A)[symbol] != 7 || objectKeys($assign({}, B)).join('') != alphabet;
}) ? function assign(target, source) { // eslint-disable-line no-unused-vars -- required for `.length`
  var T = toObject(target);
  var argumentsLength = arguments.length;
  var index = 1;
  var getOwnPropertySymbols = getOwnPropertySymbolsModule.f;
  var propertyIsEnumerable = propertyIsEnumerableModule.f;
  while (argumentsLength > index) {
    var S = IndexedObject(arguments[index++]);
    var keys = getOwnPropertySymbols ? concat(objectKeys(S), getOwnPropertySymbols(S)) : objectKeys(S);
    var length = keys.length;
    var j = 0;
    var key;
    while (length > j) {
      key = keys[j++];
      if (!DESCRIPTORS || call(propertyIsEnumerable, S, key)) T[key] = S[key];
    }
  } return T;
} : $assign;


/***/ }),

/***/ 30:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

/* global ActiveXObject -- old IE, WSH */
var anObject = __webpack_require__(9670);
var definePropertiesModule = __webpack_require__(6048);
var enumBugKeys = __webpack_require__(748);
var hiddenKeys = __webpack_require__(3501);
var html = __webpack_require__(490);
var documentCreateElement = __webpack_require__(317);
var sharedKey = __webpack_require__(6200);

var GT = '>';
var LT = '<';
var PROTOTYPE = 'prototype';
var SCRIPT = 'script';
var IE_PROTO = sharedKey('IE_PROTO');

var EmptyConstructor = function () { /* empty */ };

var scriptTag = function (content) {
  return LT + SCRIPT + GT + content + LT + '/' + SCRIPT + GT;
};

// Create object with fake `null` prototype: use ActiveX Object with cleared prototype
var NullProtoObjectViaActiveX = function (activeXDocument) {
  activeXDocument.write(scriptTag(''));
  activeXDocument.close();
  var temp = activeXDocument.parentWindow.Object;
  activeXDocument = null; // avoid memory leak
  return temp;
};

// Create object with fake `null` prototype: use iframe Object with cleared prototype
var NullProtoObjectViaIFrame = function () {
  // Thrash, waste and sodomy: IE GC bug
  var iframe = documentCreateElement('iframe');
  var JS = 'java' + SCRIPT + ':';
  var iframeDocument;
  iframe.style.display = 'none';
  html.appendChild(iframe);
  // https://github.com/zloirock/core-js/issues/475
  iframe.src = String(JS);
  iframeDocument = iframe.contentWindow.document;
  iframeDocument.open();
  iframeDocument.write(scriptTag('document.F=Object'));
  iframeDocument.close();
  return iframeDocument.F;
};

// Check for document.domain and active x support
// No need to use active x approach when document.domain is not set
// see https://github.com/es-shims/es5-shim/issues/150
// variation of https://github.com/kitcambridge/es5-shim/commit/4f738ac066346
// avoid IE GC bug
var activeXDocument;
var NullProtoObject = function () {
  try {
    activeXDocument = new ActiveXObject('htmlfile');
  } catch (error) { /* ignore */ }
  NullProtoObject = typeof document != 'undefined'
    ? document.domain && activeXDocument
      ? NullProtoObjectViaActiveX(activeXDocument) // old IE
      : NullProtoObjectViaIFrame()
    : NullProtoObjectViaActiveX(activeXDocument); // WSH
  var length = enumBugKeys.length;
  while (length--) delete NullProtoObject[PROTOTYPE][enumBugKeys[length]];
  return NullProtoObject();
};

hiddenKeys[IE_PROTO] = true;

// `Object.create` method
// https://tc39.es/ecma262/#sec-object.create
module.exports = Object.create || function create(O, Properties) {
  var result;
  if (O !== null) {
    EmptyConstructor[PROTOTYPE] = anObject(O);
    result = new EmptyConstructor();
    EmptyConstructor[PROTOTYPE] = null;
    // add "__proto__" for Object.getPrototypeOf polyfill
    result[IE_PROTO] = O;
  } else result = NullProtoObject();
  return Properties === undefined ? result : definePropertiesModule.f(result, Properties);
};


/***/ }),

/***/ 6048:
/***/ (function(__unused_webpack_module, exports, __webpack_require__) {

var DESCRIPTORS = __webpack_require__(9781);
var V8_PROTOTYPE_DEFINE_BUG = __webpack_require__(3353);
var definePropertyModule = __webpack_require__(3070);
var anObject = __webpack_require__(9670);
var toIndexedObject = __webpack_require__(5656);
var objectKeys = __webpack_require__(1956);

// `Object.defineProperties` method
// https://tc39.es/ecma262/#sec-object.defineproperties
// eslint-disable-next-line es/no-object-defineproperties -- safe
exports.f = DESCRIPTORS && !V8_PROTOTYPE_DEFINE_BUG ? Object.defineProperties : function defineProperties(O, Properties) {
  anObject(O);
  var props = toIndexedObject(Properties);
  var keys = objectKeys(Properties);
  var length = keys.length;
  var index = 0;
  var key;
  while (length > index) definePropertyModule.f(O, key = keys[index++], props[key]);
  return O;
};


/***/ }),

/***/ 3070:
/***/ (function(__unused_webpack_module, exports, __webpack_require__) {

var global = __webpack_require__(7854);
var DESCRIPTORS = __webpack_require__(9781);
var IE8_DOM_DEFINE = __webpack_require__(4664);
var V8_PROTOTYPE_DEFINE_BUG = __webpack_require__(3353);
var anObject = __webpack_require__(9670);
var toPropertyKey = __webpack_require__(4948);

var TypeError = global.TypeError;
// eslint-disable-next-line es/no-object-defineproperty -- safe
var $defineProperty = Object.defineProperty;
// eslint-disable-next-line es/no-object-getownpropertydescriptor -- safe
var $getOwnPropertyDescriptor = Object.getOwnPropertyDescriptor;
var ENUMERABLE = 'enumerable';
var CONFIGURABLE = 'configurable';
var WRITABLE = 'writable';

// `Object.defineProperty` method
// https://tc39.es/ecma262/#sec-object.defineproperty
exports.f = DESCRIPTORS ? V8_PROTOTYPE_DEFINE_BUG ? function defineProperty(O, P, Attributes) {
  anObject(O);
  P = toPropertyKey(P);
  anObject(Attributes);
  if (typeof O === 'function' && P === 'prototype' && 'value' in Attributes && WRITABLE in Attributes && !Attributes[WRITABLE]) {
    var current = $getOwnPropertyDescriptor(O, P);
    if (current && current[WRITABLE]) {
      O[P] = Attributes.value;
      Attributes = {
        configurable: CONFIGURABLE in Attributes ? Attributes[CONFIGURABLE] : current[CONFIGURABLE],
        enumerable: ENUMERABLE in Attributes ? Attributes[ENUMERABLE] : current[ENUMERABLE],
        writable: false
      };
    }
  } return $defineProperty(O, P, Attributes);
} : $defineProperty : function defineProperty(O, P, Attributes) {
  anObject(O);
  P = toPropertyKey(P);
  anObject(Attributes);
  if (IE8_DOM_DEFINE) try {
    return $defineProperty(O, P, Attributes);
  } catch (error) { /* empty */ }
  if ('get' in Attributes || 'set' in Attributes) throw TypeError('Accessors not supported');
  if ('value' in Attributes) O[P] = Attributes.value;
  return O;
};


/***/ }),

/***/ 1236:
/***/ (function(__unused_webpack_module, exports, __webpack_require__) {

var DESCRIPTORS = __webpack_require__(9781);
var call = __webpack_require__(6916);
var propertyIsEnumerableModule = __webpack_require__(5296);
var createPropertyDescriptor = __webpack_require__(9114);
var toIndexedObject = __webpack_require__(5656);
var toPropertyKey = __webpack_require__(4948);
var hasOwn = __webpack_require__(2597);
var IE8_DOM_DEFINE = __webpack_require__(4664);

// eslint-disable-next-line es/no-object-getownpropertydescriptor -- safe
var $getOwnPropertyDescriptor = Object.getOwnPropertyDescriptor;

// `Object.getOwnPropertyDescriptor` method
// https://tc39.es/ecma262/#sec-object.getownpropertydescriptor
exports.f = DESCRIPTORS ? $getOwnPropertyDescriptor : function getOwnPropertyDescriptor(O, P) {
  O = toIndexedObject(O);
  P = toPropertyKey(P);
  if (IE8_DOM_DEFINE) try {
    return $getOwnPropertyDescriptor(O, P);
  } catch (error) { /* empty */ }
  if (hasOwn(O, P)) return createPropertyDescriptor(!call(propertyIsEnumerableModule.f, O, P), O[P]);
};


/***/ }),

/***/ 8006:
/***/ (function(__unused_webpack_module, exports, __webpack_require__) {

var internalObjectKeys = __webpack_require__(6324);
var enumBugKeys = __webpack_require__(748);

var hiddenKeys = enumBugKeys.concat('length', 'prototype');

// `Object.getOwnPropertyNames` method
// https://tc39.es/ecma262/#sec-object.getownpropertynames
// eslint-disable-next-line es/no-object-getownpropertynames -- safe
exports.f = Object.getOwnPropertyNames || function getOwnPropertyNames(O) {
  return internalObjectKeys(O, hiddenKeys);
};


/***/ }),

/***/ 5181:
/***/ (function(__unused_webpack_module, exports) {

// eslint-disable-next-line es/no-object-getownpropertysymbols -- safe
exports.f = Object.getOwnPropertySymbols;


/***/ }),

/***/ 9518:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var hasOwn = __webpack_require__(2597);
var isCallable = __webpack_require__(614);
var toObject = __webpack_require__(7908);
var sharedKey = __webpack_require__(6200);
var CORRECT_PROTOTYPE_GETTER = __webpack_require__(8544);

var IE_PROTO = sharedKey('IE_PROTO');
var Object = global.Object;
var ObjectPrototype = Object.prototype;

// `Object.getPrototypeOf` method
// https://tc39.es/ecma262/#sec-object.getprototypeof
module.exports = CORRECT_PROTOTYPE_GETTER ? Object.getPrototypeOf : function (O) {
  var object = toObject(O);
  if (hasOwn(object, IE_PROTO)) return object[IE_PROTO];
  var constructor = object.constructor;
  if (isCallable(constructor) && object instanceof constructor) {
    return constructor.prototype;
  } return object instanceof Object ? ObjectPrototype : null;
};


/***/ }),

/***/ 7976:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var uncurryThis = __webpack_require__(1702);

module.exports = uncurryThis({}.isPrototypeOf);


/***/ }),

/***/ 6324:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var uncurryThis = __webpack_require__(1702);
var hasOwn = __webpack_require__(2597);
var toIndexedObject = __webpack_require__(5656);
var indexOf = (__webpack_require__(1318).indexOf);
var hiddenKeys = __webpack_require__(3501);

var push = uncurryThis([].push);

module.exports = function (object, names) {
  var O = toIndexedObject(object);
  var i = 0;
  var result = [];
  var key;
  for (key in O) !hasOwn(hiddenKeys, key) && hasOwn(O, key) && push(result, key);
  // Don't enum bug & hidden keys
  while (names.length > i) if (hasOwn(O, key = names[i++])) {
    ~indexOf(result, key) || push(result, key);
  }
  return result;
};


/***/ }),

/***/ 1956:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var internalObjectKeys = __webpack_require__(6324);
var enumBugKeys = __webpack_require__(748);

// `Object.keys` method
// https://tc39.es/ecma262/#sec-object.keys
// eslint-disable-next-line es/no-object-keys -- safe
module.exports = Object.keys || function keys(O) {
  return internalObjectKeys(O, enumBugKeys);
};


/***/ }),

/***/ 5296:
/***/ (function(__unused_webpack_module, exports) {

"use strict";

var $propertyIsEnumerable = {}.propertyIsEnumerable;
// eslint-disable-next-line es/no-object-getownpropertydescriptor -- safe
var getOwnPropertyDescriptor = Object.getOwnPropertyDescriptor;

// Nashorn ~ JDK8 bug
var NASHORN_BUG = getOwnPropertyDescriptor && !$propertyIsEnumerable.call({ 1: 2 }, 1);

// `Object.prototype.propertyIsEnumerable` method implementation
// https://tc39.es/ecma262/#sec-object.prototype.propertyisenumerable
exports.f = NASHORN_BUG ? function propertyIsEnumerable(V) {
  var descriptor = getOwnPropertyDescriptor(this, V);
  return !!descriptor && descriptor.enumerable;
} : $propertyIsEnumerable;


/***/ }),

/***/ 7674:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

/* eslint-disable no-proto -- safe */
var uncurryThis = __webpack_require__(1702);
var anObject = __webpack_require__(9670);
var aPossiblePrototype = __webpack_require__(6077);

// `Object.setPrototypeOf` method
// https://tc39.es/ecma262/#sec-object.setprototypeof
// Works with __proto__ only. Old v8 can't work with null proto objects.
// eslint-disable-next-line es/no-object-setprototypeof -- safe
module.exports = Object.setPrototypeOf || ('__proto__' in {} ? function () {
  var CORRECT_SETTER = false;
  var test = {};
  var setter;
  try {
    // eslint-disable-next-line es/no-object-getownpropertydescriptor -- safe
    setter = uncurryThis(Object.getOwnPropertyDescriptor(Object.prototype, '__proto__').set);
    setter(test, []);
    CORRECT_SETTER = test instanceof Array;
  } catch (error) { /* empty */ }
  return function setPrototypeOf(O, proto) {
    anObject(O);
    aPossiblePrototype(proto);
    if (CORRECT_SETTER) setter(O, proto);
    else O.__proto__ = proto;
    return O;
  };
}() : undefined);


/***/ }),

/***/ 288:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var TO_STRING_TAG_SUPPORT = __webpack_require__(1694);
var classof = __webpack_require__(648);

// `Object.prototype.toString` method implementation
// https://tc39.es/ecma262/#sec-object.prototype.tostring
module.exports = TO_STRING_TAG_SUPPORT ? {}.toString : function toString() {
  return '[object ' + classof(this) + ']';
};


/***/ }),

/***/ 2140:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var call = __webpack_require__(6916);
var isCallable = __webpack_require__(614);
var isObject = __webpack_require__(111);

var TypeError = global.TypeError;

// `OrdinaryToPrimitive` abstract operation
// https://tc39.es/ecma262/#sec-ordinarytoprimitive
module.exports = function (input, pref) {
  var fn, val;
  if (pref === 'string' && isCallable(fn = input.toString) && !isObject(val = call(fn, input))) return val;
  if (isCallable(fn = input.valueOf) && !isObject(val = call(fn, input))) return val;
  if (pref !== 'string' && isCallable(fn = input.toString) && !isObject(val = call(fn, input))) return val;
  throw TypeError("Can't convert object to primitive value");
};


/***/ }),

/***/ 3887:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var getBuiltIn = __webpack_require__(5005);
var uncurryThis = __webpack_require__(1702);
var getOwnPropertyNamesModule = __webpack_require__(8006);
var getOwnPropertySymbolsModule = __webpack_require__(5181);
var anObject = __webpack_require__(9670);

var concat = uncurryThis([].concat);

// all object keys, includes non-enumerable and symbols
module.exports = getBuiltIn('Reflect', 'ownKeys') || function ownKeys(it) {
  var keys = getOwnPropertyNamesModule.f(anObject(it));
  var getOwnPropertySymbols = getOwnPropertySymbolsModule.f;
  return getOwnPropertySymbols ? concat(keys, getOwnPropertySymbols(it)) : keys;
};


/***/ }),

/***/ 857:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);

module.exports = global;


/***/ }),

/***/ 2534:
/***/ (function(module) {

module.exports = function (exec) {
  try {
    return { error: false, value: exec() };
  } catch (error) {
    return { error: true, value: error };
  }
};


/***/ }),

/***/ 9478:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var anObject = __webpack_require__(9670);
var isObject = __webpack_require__(111);
var newPromiseCapability = __webpack_require__(8523);

module.exports = function (C, x) {
  anObject(C);
  if (isObject(x) && x.constructor === C) return x;
  var promiseCapability = newPromiseCapability.f(C);
  var resolve = promiseCapability.resolve;
  resolve(x);
  return promiseCapability.promise;
};


/***/ }),

/***/ 8572:
/***/ (function(module) {

var Queue = function () {
  this.head = null;
  this.tail = null;
};

Queue.prototype = {
  add: function (item) {
    var entry = { item: item, next: null };
    if (this.head) this.tail.next = entry;
    else this.head = entry;
    this.tail = entry;
  },
  get: function () {
    var entry = this.head;
    if (entry) {
      this.head = entry.next;
      if (this.tail === entry) this.tail = null;
      return entry.item;
    }
  }
};

module.exports = Queue;


/***/ }),

/***/ 2248:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var redefine = __webpack_require__(1320);

module.exports = function (target, src, options) {
  for (var key in src) redefine(target, key, src[key], options);
  return target;
};


/***/ }),

/***/ 1320:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var isCallable = __webpack_require__(614);
var hasOwn = __webpack_require__(2597);
var createNonEnumerableProperty = __webpack_require__(8880);
var setGlobal = __webpack_require__(3505);
var inspectSource = __webpack_require__(2788);
var InternalStateModule = __webpack_require__(9909);
var CONFIGURABLE_FUNCTION_NAME = (__webpack_require__(6530).CONFIGURABLE);

var getInternalState = InternalStateModule.get;
var enforceInternalState = InternalStateModule.enforce;
var TEMPLATE = String(String).split('String');

(module.exports = function (O, key, value, options) {
  var unsafe = options ? !!options.unsafe : false;
  var simple = options ? !!options.enumerable : false;
  var noTargetGet = options ? !!options.noTargetGet : false;
  var name = options && options.name !== undefined ? options.name : key;
  var state;
  if (isCallable(value)) {
    if (String(name).slice(0, 7) === 'Symbol(') {
      name = '[' + String(name).replace(/^Symbol\(([^)]*)\)/, '$1') + ']';
    }
    if (!hasOwn(value, 'name') || (CONFIGURABLE_FUNCTION_NAME && value.name !== name)) {
      createNonEnumerableProperty(value, 'name', name);
    }
    state = enforceInternalState(value);
    if (!state.source) {
      state.source = TEMPLATE.join(typeof name == 'string' ? name : '');
    }
  }
  if (O === global) {
    if (simple) O[key] = value;
    else setGlobal(key, value);
    return;
  } else if (!unsafe) {
    delete O[key];
  } else if (!noTargetGet && O[key]) {
    simple = true;
  }
  if (simple) O[key] = value;
  else createNonEnumerableProperty(O, key, value);
// add fake Function#toString for correct work wrapped methods / constructors with methods like LoDash isNative
})(Function.prototype, 'toString', function toString() {
  return isCallable(this) && getInternalState(this).source || inspectSource(this);
});


/***/ }),

/***/ 7066:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var anObject = __webpack_require__(9670);

// `RegExp.prototype.flags` getter implementation
// https://tc39.es/ecma262/#sec-get-regexp.prototype.flags
module.exports = function () {
  var that = anObject(this);
  var result = '';
  if (that.global) result += 'g';
  if (that.ignoreCase) result += 'i';
  if (that.multiline) result += 'm';
  if (that.dotAll) result += 's';
  if (that.unicode) result += 'u';
  if (that.sticky) result += 'y';
  return result;
};


/***/ }),

/***/ 4488:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);

var TypeError = global.TypeError;

// `RequireObjectCoercible` abstract operation
// https://tc39.es/ecma262/#sec-requireobjectcoercible
module.exports = function (it) {
  if (it == undefined) throw TypeError("Can't call method on " + it);
  return it;
};


/***/ }),

/***/ 3505:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);

// eslint-disable-next-line es/no-object-defineproperty -- safe
var defineProperty = Object.defineProperty;

module.exports = function (key, value) {
  try {
    defineProperty(global, key, { value: value, configurable: true, writable: true });
  } catch (error) {
    global[key] = value;
  } return value;
};


/***/ }),

/***/ 6340:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var getBuiltIn = __webpack_require__(5005);
var definePropertyModule = __webpack_require__(3070);
var wellKnownSymbol = __webpack_require__(5112);
var DESCRIPTORS = __webpack_require__(9781);

var SPECIES = wellKnownSymbol('species');

module.exports = function (CONSTRUCTOR_NAME) {
  var Constructor = getBuiltIn(CONSTRUCTOR_NAME);
  var defineProperty = definePropertyModule.f;

  if (DESCRIPTORS && Constructor && !Constructor[SPECIES]) {
    defineProperty(Constructor, SPECIES, {
      configurable: true,
      get: function () { return this; }
    });
  }
};


/***/ }),

/***/ 8003:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var defineProperty = (__webpack_require__(3070).f);
var hasOwn = __webpack_require__(2597);
var wellKnownSymbol = __webpack_require__(5112);

var TO_STRING_TAG = wellKnownSymbol('toStringTag');

module.exports = function (target, TAG, STATIC) {
  if (target && !STATIC) target = target.prototype;
  if (target && !hasOwn(target, TO_STRING_TAG)) {
    defineProperty(target, TO_STRING_TAG, { configurable: true, value: TAG });
  }
};


/***/ }),

/***/ 6200:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var shared = __webpack_require__(2309);
var uid = __webpack_require__(9711);

var keys = shared('keys');

module.exports = function (key) {
  return keys[key] || (keys[key] = uid(key));
};


/***/ }),

/***/ 5465:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var setGlobal = __webpack_require__(3505);

var SHARED = '__core-js_shared__';
var store = global[SHARED] || setGlobal(SHARED, {});

module.exports = store;


/***/ }),

/***/ 2309:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var IS_PURE = __webpack_require__(1913);
var store = __webpack_require__(5465);

(module.exports = function (key, value) {
  return store[key] || (store[key] = value !== undefined ? value : {});
})('versions', []).push({
  version: '3.21.1',
  mode: IS_PURE ? 'pure' : 'global',
  copyright: '© 2014-2022 Denis Pushkarev (zloirock.ru)',
  license: 'https://github.com/zloirock/core-js/blob/v3.21.1/LICENSE',
  source: 'https://github.com/zloirock/core-js'
});


/***/ }),

/***/ 6707:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var anObject = __webpack_require__(9670);
var aConstructor = __webpack_require__(9483);
var wellKnownSymbol = __webpack_require__(5112);

var SPECIES = wellKnownSymbol('species');

// `SpeciesConstructor` abstract operation
// https://tc39.es/ecma262/#sec-speciesconstructor
module.exports = function (O, defaultConstructor) {
  var C = anObject(O).constructor;
  var S;
  return C === undefined || (S = anObject(C)[SPECIES]) == undefined ? defaultConstructor : aConstructor(S);
};


/***/ }),

/***/ 8710:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var uncurryThis = __webpack_require__(1702);
var toIntegerOrInfinity = __webpack_require__(9303);
var toString = __webpack_require__(1340);
var requireObjectCoercible = __webpack_require__(4488);

var charAt = uncurryThis(''.charAt);
var charCodeAt = uncurryThis(''.charCodeAt);
var stringSlice = uncurryThis(''.slice);

var createMethod = function (CONVERT_TO_STRING) {
  return function ($this, pos) {
    var S = toString(requireObjectCoercible($this));
    var position = toIntegerOrInfinity(pos);
    var size = S.length;
    var first, second;
    if (position < 0 || position >= size) return CONVERT_TO_STRING ? '' : undefined;
    first = charCodeAt(S, position);
    return first < 0xD800 || first > 0xDBFF || position + 1 === size
      || (second = charCodeAt(S, position + 1)) < 0xDC00 || second > 0xDFFF
        ? CONVERT_TO_STRING
          ? charAt(S, position)
          : first
        : CONVERT_TO_STRING
          ? stringSlice(S, position, position + 2)
          : (first - 0xD800 << 10) + (second - 0xDC00) + 0x10000;
  };
};

module.exports = {
  // `String.prototype.codePointAt` method
  // https://tc39.es/ecma262/#sec-string.prototype.codepointat
  codeAt: createMethod(false),
  // `String.prototype.at` method
  // https://github.com/mathiasbynens/String.prototype.at
  charAt: createMethod(true)
};


/***/ }),

/***/ 3197:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";

// based on https://github.com/bestiejs/punycode.js/blob/master/punycode.js
var global = __webpack_require__(7854);
var uncurryThis = __webpack_require__(1702);

var maxInt = 2147483647; // aka. 0x7FFFFFFF or 2^31-1
var base = 36;
var tMin = 1;
var tMax = 26;
var skew = 38;
var damp = 700;
var initialBias = 72;
var initialN = 128; // 0x80
var delimiter = '-'; // '\x2D'
var regexNonASCII = /[^\0-\u007E]/; // non-ASCII chars
var regexSeparators = /[.\u3002\uFF0E\uFF61]/g; // RFC 3490 separators
var OVERFLOW_ERROR = 'Overflow: input needs wider integers to process';
var baseMinusTMin = base - tMin;

var RangeError = global.RangeError;
var exec = uncurryThis(regexSeparators.exec);
var floor = Math.floor;
var fromCharCode = String.fromCharCode;
var charCodeAt = uncurryThis(''.charCodeAt);
var join = uncurryThis([].join);
var push = uncurryThis([].push);
var replace = uncurryThis(''.replace);
var split = uncurryThis(''.split);
var toLowerCase = uncurryThis(''.toLowerCase);

/**
 * Creates an array containing the numeric code points of each Unicode
 * character in the string. While JavaScript uses UCS-2 internally,
 * this function will convert a pair of surrogate halves (each of which
 * UCS-2 exposes as separate characters) into a single code point,
 * matching UTF-16.
 */
var ucs2decode = function (string) {
  var output = [];
  var counter = 0;
  var length = string.length;
  while (counter < length) {
    var value = charCodeAt(string, counter++);
    if (value >= 0xD800 && value <= 0xDBFF && counter < length) {
      // It's a high surrogate, and there is a next character.
      var extra = charCodeAt(string, counter++);
      if ((extra & 0xFC00) == 0xDC00) { // Low surrogate.
        push(output, ((value & 0x3FF) << 10) + (extra & 0x3FF) + 0x10000);
      } else {
        // It's an unmatched surrogate; only append this code unit, in case the
        // next code unit is the high surrogate of a surrogate pair.
        push(output, value);
        counter--;
      }
    } else {
      push(output, value);
    }
  }
  return output;
};

/**
 * Converts a digit/integer into a basic code point.
 */
var digitToBasic = function (digit) {
  //  0..25 map to ASCII a..z or A..Z
  // 26..35 map to ASCII 0..9
  return digit + 22 + 75 * (digit < 26);
};

/**
 * Bias adaptation function as per section 3.4 of RFC 3492.
 * https://tools.ietf.org/html/rfc3492#section-3.4
 */
var adapt = function (delta, numPoints, firstTime) {
  var k = 0;
  delta = firstTime ? floor(delta / damp) : delta >> 1;
  delta += floor(delta / numPoints);
  while (delta > baseMinusTMin * tMax >> 1) {
    delta = floor(delta / baseMinusTMin);
    k += base;
  }
  return floor(k + (baseMinusTMin + 1) * delta / (delta + skew));
};

/**
 * Converts a string of Unicode symbols (e.g. a domain name label) to a
 * Punycode string of ASCII-only symbols.
 */
var encode = function (input) {
  var output = [];

  // Convert the input in UCS-2 to an array of Unicode code points.
  input = ucs2decode(input);

  // Cache the length.
  var inputLength = input.length;

  // Initialize the state.
  var n = initialN;
  var delta = 0;
  var bias = initialBias;
  var i, currentValue;

  // Handle the basic code points.
  for (i = 0; i < input.length; i++) {
    currentValue = input[i];
    if (currentValue < 0x80) {
      push(output, fromCharCode(currentValue));
    }
  }

  var basicLength = output.length; // number of basic code points.
  var handledCPCount = basicLength; // number of code points that have been handled;

  // Finish the basic string with a delimiter unless it's empty.
  if (basicLength) {
    push(output, delimiter);
  }

  // Main encoding loop:
  while (handledCPCount < inputLength) {
    // All non-basic code points < n have been handled already. Find the next larger one:
    var m = maxInt;
    for (i = 0; i < input.length; i++) {
      currentValue = input[i];
      if (currentValue >= n && currentValue < m) {
        m = currentValue;
      }
    }

    // Increase `delta` enough to advance the decoder's <n,i> state to <m,0>, but guard against overflow.
    var handledCPCountPlusOne = handledCPCount + 1;
    if (m - n > floor((maxInt - delta) / handledCPCountPlusOne)) {
      throw RangeError(OVERFLOW_ERROR);
    }

    delta += (m - n) * handledCPCountPlusOne;
    n = m;

    for (i = 0; i < input.length; i++) {
      currentValue = input[i];
      if (currentValue < n && ++delta > maxInt) {
        throw RangeError(OVERFLOW_ERROR);
      }
      if (currentValue == n) {
        // Represent delta as a generalized variable-length integer.
        var q = delta;
        var k = base;
        while (true) {
          var t = k <= bias ? tMin : (k >= bias + tMax ? tMax : k - bias);
          if (q < t) break;
          var qMinusT = q - t;
          var baseMinusT = base - t;
          push(output, fromCharCode(digitToBasic(t + qMinusT % baseMinusT)));
          q = floor(qMinusT / baseMinusT);
          k += base;
        }

        push(output, fromCharCode(digitToBasic(q)));
        bias = adapt(delta, handledCPCountPlusOne, handledCPCount == basicLength);
        delta = 0;
        handledCPCount++;
      }
    }

    delta++;
    n++;
  }
  return join(output, '');
};

module.exports = function (input) {
  var encoded = [];
  var labels = split(replace(toLowerCase(input), regexSeparators, '\u002E'), '.');
  var i, label;
  for (i = 0; i < labels.length; i++) {
    label = labels[i];
    push(encoded, exec(regexNonASCII, label) ? 'xn--' + encode(label) : label);
  }
  return join(encoded, '.');
};


/***/ }),

/***/ 261:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var apply = __webpack_require__(2104);
var bind = __webpack_require__(9974);
var isCallable = __webpack_require__(614);
var hasOwn = __webpack_require__(2597);
var fails = __webpack_require__(7293);
var html = __webpack_require__(490);
var arraySlice = __webpack_require__(206);
var createElement = __webpack_require__(317);
var validateArgumentsLength = __webpack_require__(8053);
var IS_IOS = __webpack_require__(6833);
var IS_NODE = __webpack_require__(5268);

var set = global.setImmediate;
var clear = global.clearImmediate;
var process = global.process;
var Dispatch = global.Dispatch;
var Function = global.Function;
var MessageChannel = global.MessageChannel;
var String = global.String;
var counter = 0;
var queue = {};
var ONREADYSTATECHANGE = 'onreadystatechange';
var location, defer, channel, port;

try {
  // Deno throws a ReferenceError on `location` access without `--location` flag
  location = global.location;
} catch (error) { /* empty */ }

var run = function (id) {
  if (hasOwn(queue, id)) {
    var fn = queue[id];
    delete queue[id];
    fn();
  }
};

var runner = function (id) {
  return function () {
    run(id);
  };
};

var listener = function (event) {
  run(event.data);
};

var post = function (id) {
  // old engines have not location.origin
  global.postMessage(String(id), location.protocol + '//' + location.host);
};

// Node.js 0.9+ & IE10+ has setImmediate, otherwise:
if (!set || !clear) {
  set = function setImmediate(handler) {
    validateArgumentsLength(arguments.length, 1);
    var fn = isCallable(handler) ? handler : Function(handler);
    var args = arraySlice(arguments, 1);
    queue[++counter] = function () {
      apply(fn, undefined, args);
    };
    defer(counter);
    return counter;
  };
  clear = function clearImmediate(id) {
    delete queue[id];
  };
  // Node.js 0.8-
  if (IS_NODE) {
    defer = function (id) {
      process.nextTick(runner(id));
    };
  // Sphere (JS game engine) Dispatch API
  } else if (Dispatch && Dispatch.now) {
    defer = function (id) {
      Dispatch.now(runner(id));
    };
  // Browsers with MessageChannel, includes WebWorkers
  // except iOS - https://github.com/zloirock/core-js/issues/624
  } else if (MessageChannel && !IS_IOS) {
    channel = new MessageChannel();
    port = channel.port2;
    channel.port1.onmessage = listener;
    defer = bind(port.postMessage, port);
  // Browsers with postMessage, skip WebWorkers
  // IE8 has postMessage, but it's sync & typeof its postMessage is 'object'
  } else if (
    global.addEventListener &&
    isCallable(global.postMessage) &&
    !global.importScripts &&
    location && location.protocol !== 'file:' &&
    !fails(post)
  ) {
    defer = post;
    global.addEventListener('message', listener, false);
  // IE8-
  } else if (ONREADYSTATECHANGE in createElement('script')) {
    defer = function (id) {
      html.appendChild(createElement('script'))[ONREADYSTATECHANGE] = function () {
        html.removeChild(this);
        run(id);
      };
    };
  // Rest old browsers
  } else {
    defer = function (id) {
      setTimeout(runner(id), 0);
    };
  }
}

module.exports = {
  set: set,
  clear: clear
};


/***/ }),

/***/ 1400:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var toIntegerOrInfinity = __webpack_require__(9303);

var max = Math.max;
var min = Math.min;

// Helper for a popular repeating case of the spec:
// Let integer be ? ToInteger(index).
// If integer < 0, let result be max((length + integer), 0); else let result be min(integer, length).
module.exports = function (index, length) {
  var integer = toIntegerOrInfinity(index);
  return integer < 0 ? max(integer + length, 0) : min(integer, length);
};


/***/ }),

/***/ 5656:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

// toObject with fallback for non-array-like ES3 strings
var IndexedObject = __webpack_require__(8361);
var requireObjectCoercible = __webpack_require__(4488);

module.exports = function (it) {
  return IndexedObject(requireObjectCoercible(it));
};


/***/ }),

/***/ 9303:
/***/ (function(module) {

var ceil = Math.ceil;
var floor = Math.floor;

// `ToIntegerOrInfinity` abstract operation
// https://tc39.es/ecma262/#sec-tointegerorinfinity
module.exports = function (argument) {
  var number = +argument;
  // eslint-disable-next-line no-self-compare -- safe
  return number !== number || number === 0 ? 0 : (number > 0 ? floor : ceil)(number);
};


/***/ }),

/***/ 7466:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var toIntegerOrInfinity = __webpack_require__(9303);

var min = Math.min;

// `ToLength` abstract operation
// https://tc39.es/ecma262/#sec-tolength
module.exports = function (argument) {
  return argument > 0 ? min(toIntegerOrInfinity(argument), 0x1FFFFFFFFFFFFF) : 0; // 2 ** 53 - 1 == 9007199254740991
};


/***/ }),

/***/ 7908:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var requireObjectCoercible = __webpack_require__(4488);

var Object = global.Object;

// `ToObject` abstract operation
// https://tc39.es/ecma262/#sec-toobject
module.exports = function (argument) {
  return Object(requireObjectCoercible(argument));
};


/***/ }),

/***/ 7593:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var call = __webpack_require__(6916);
var isObject = __webpack_require__(111);
var isSymbol = __webpack_require__(2190);
var getMethod = __webpack_require__(8173);
var ordinaryToPrimitive = __webpack_require__(2140);
var wellKnownSymbol = __webpack_require__(5112);

var TypeError = global.TypeError;
var TO_PRIMITIVE = wellKnownSymbol('toPrimitive');

// `ToPrimitive` abstract operation
// https://tc39.es/ecma262/#sec-toprimitive
module.exports = function (input, pref) {
  if (!isObject(input) || isSymbol(input)) return input;
  var exoticToPrim = getMethod(input, TO_PRIMITIVE);
  var result;
  if (exoticToPrim) {
    if (pref === undefined) pref = 'default';
    result = call(exoticToPrim, input, pref);
    if (!isObject(result) || isSymbol(result)) return result;
    throw TypeError("Can't convert object to primitive value");
  }
  if (pref === undefined) pref = 'number';
  return ordinaryToPrimitive(input, pref);
};


/***/ }),

/***/ 4948:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var toPrimitive = __webpack_require__(7593);
var isSymbol = __webpack_require__(2190);

// `ToPropertyKey` abstract operation
// https://tc39.es/ecma262/#sec-topropertykey
module.exports = function (argument) {
  var key = toPrimitive(argument, 'string');
  return isSymbol(key) ? key : key + '';
};


/***/ }),

/***/ 1694:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var wellKnownSymbol = __webpack_require__(5112);

var TO_STRING_TAG = wellKnownSymbol('toStringTag');
var test = {};

test[TO_STRING_TAG] = 'z';

module.exports = String(test) === '[object z]';


/***/ }),

/***/ 1340:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var classof = __webpack_require__(648);

var String = global.String;

module.exports = function (argument) {
  if (classof(argument) === 'Symbol') throw TypeError('Cannot convert a Symbol value to a string');
  return String(argument);
};


/***/ }),

/***/ 4038:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var IS_NODE = __webpack_require__(5268);

module.exports = function (name) {
  try {
    // eslint-disable-next-line no-new-func -- safe
    if (IS_NODE) return Function('return require("' + name + '")')();
  } catch (error) { /* empty */ }
};


/***/ }),

/***/ 6330:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);

var String = global.String;

module.exports = function (argument) {
  try {
    return String(argument);
  } catch (error) {
    return 'Object';
  }
};


/***/ }),

/***/ 9711:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var uncurryThis = __webpack_require__(1702);

var id = 0;
var postfix = Math.random();
var toString = uncurryThis(1.0.toString);

module.exports = function (key) {
  return 'Symbol(' + (key === undefined ? '' : key) + ')_' + toString(++id + postfix, 36);
};


/***/ }),

/***/ 3307:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

/* eslint-disable es/no-symbol -- required for testing */
var NATIVE_SYMBOL = __webpack_require__(133);

module.exports = NATIVE_SYMBOL
  && !Symbol.sham
  && typeof Symbol.iterator == 'symbol';


/***/ }),

/***/ 3353:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var DESCRIPTORS = __webpack_require__(9781);
var fails = __webpack_require__(7293);

// V8 ~ Chrome 36-
// https://bugs.chromium.org/p/v8/issues/detail?id=3334
module.exports = DESCRIPTORS && fails(function () {
  // eslint-disable-next-line es/no-object-defineproperty -- required for testing
  return Object.defineProperty(function () { /* empty */ }, 'prototype', {
    value: 42,
    writable: false
  }).prototype != 42;
});


/***/ }),

/***/ 8053:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);

var TypeError = global.TypeError;

module.exports = function (passed, required) {
  if (passed < required) throw TypeError('Not enough arguments');
  return passed;
};


/***/ }),

/***/ 5112:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var shared = __webpack_require__(2309);
var hasOwn = __webpack_require__(2597);
var uid = __webpack_require__(9711);
var NATIVE_SYMBOL = __webpack_require__(133);
var USE_SYMBOL_AS_UID = __webpack_require__(3307);

var WellKnownSymbolsStore = shared('wks');
var Symbol = global.Symbol;
var symbolFor = Symbol && Symbol['for'];
var createWellKnownSymbol = USE_SYMBOL_AS_UID ? Symbol : Symbol && Symbol.withoutSetter || uid;

module.exports = function (name) {
  if (!hasOwn(WellKnownSymbolsStore, name) || !(NATIVE_SYMBOL || typeof WellKnownSymbolsStore[name] == 'string')) {
    var description = 'Symbol.' + name;
    if (NATIVE_SYMBOL && hasOwn(Symbol, name)) {
      WellKnownSymbolsStore[name] = Symbol[name];
    } else if (USE_SYMBOL_AS_UID && symbolFor) {
      WellKnownSymbolsStore[name] = symbolFor(description);
    } else {
      WellKnownSymbolsStore[name] = createWellKnownSymbol(description);
    }
  } return WellKnownSymbolsStore[name];
};


/***/ }),

/***/ 9170:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var $ = __webpack_require__(2109);
var global = __webpack_require__(7854);
var isPrototypeOf = __webpack_require__(7976);
var getPrototypeOf = __webpack_require__(9518);
var setPrototypeOf = __webpack_require__(7674);
var copyConstructorProperties = __webpack_require__(9920);
var create = __webpack_require__(30);
var createNonEnumerableProperty = __webpack_require__(8880);
var createPropertyDescriptor = __webpack_require__(9114);
var clearErrorStack = __webpack_require__(7741);
var installErrorCause = __webpack_require__(8340);
var iterate = __webpack_require__(408);
var normalizeStringArgument = __webpack_require__(6277);
var wellKnownSymbol = __webpack_require__(5112);
var ERROR_STACK_INSTALLABLE = __webpack_require__(2914);

var TO_STRING_TAG = wellKnownSymbol('toStringTag');
var Error = global.Error;
var push = [].push;

var $AggregateError = function AggregateError(errors, message /* , options */) {
  var options = arguments.length > 2 ? arguments[2] : undefined;
  var isInstance = isPrototypeOf(AggregateErrorPrototype, this);
  var that;
  if (setPrototypeOf) {
    that = setPrototypeOf(new Error(), isInstance ? getPrototypeOf(this) : AggregateErrorPrototype);
  } else {
    that = isInstance ? this : create(AggregateErrorPrototype);
    createNonEnumerableProperty(that, TO_STRING_TAG, 'Error');
  }
  if (message !== undefined) createNonEnumerableProperty(that, 'message', normalizeStringArgument(message));
  if (ERROR_STACK_INSTALLABLE) createNonEnumerableProperty(that, 'stack', clearErrorStack(that.stack, 1));
  installErrorCause(that, options);
  var errorsArray = [];
  iterate(errors, push, { that: errorsArray });
  createNonEnumerableProperty(that, 'errors', errorsArray);
  return that;
};

if (setPrototypeOf) setPrototypeOf($AggregateError, Error);
else copyConstructorProperties($AggregateError, Error, { name: true });

var AggregateErrorPrototype = $AggregateError.prototype = create(Error.prototype, {
  constructor: createPropertyDescriptor(1, $AggregateError),
  message: createPropertyDescriptor(1, ''),
  name: createPropertyDescriptor(1, 'AggregateError')
});

// `AggregateError` constructor
// https://tc39.es/ecma262/#sec-aggregate-error-constructor
$({ global: true }, {
  AggregateError: $AggregateError
});


/***/ }),

/***/ 6992:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var toIndexedObject = __webpack_require__(5656);
var addToUnscopables = __webpack_require__(1223);
var Iterators = __webpack_require__(7497);
var InternalStateModule = __webpack_require__(9909);
var defineProperty = (__webpack_require__(3070).f);
var defineIterator = __webpack_require__(654);
var IS_PURE = __webpack_require__(1913);
var DESCRIPTORS = __webpack_require__(9781);

var ARRAY_ITERATOR = 'Array Iterator';
var setInternalState = InternalStateModule.set;
var getInternalState = InternalStateModule.getterFor(ARRAY_ITERATOR);

// `Array.prototype.entries` method
// https://tc39.es/ecma262/#sec-array.prototype.entries
// `Array.prototype.keys` method
// https://tc39.es/ecma262/#sec-array.prototype.keys
// `Array.prototype.values` method
// https://tc39.es/ecma262/#sec-array.prototype.values
// `Array.prototype[@@iterator]` method
// https://tc39.es/ecma262/#sec-array.prototype-@@iterator
// `CreateArrayIterator` internal method
// https://tc39.es/ecma262/#sec-createarrayiterator
module.exports = defineIterator(Array, 'Array', function (iterated, kind) {
  setInternalState(this, {
    type: ARRAY_ITERATOR,
    target: toIndexedObject(iterated), // target
    index: 0,                          // next index
    kind: kind                         // kind
  });
// `%ArrayIteratorPrototype%.next` method
// https://tc39.es/ecma262/#sec-%arrayiteratorprototype%.next
}, function () {
  var state = getInternalState(this);
  var target = state.target;
  var kind = state.kind;
  var index = state.index++;
  if (!target || index >= target.length) {
    state.target = undefined;
    return { value: undefined, done: true };
  }
  if (kind == 'keys') return { value: index, done: false };
  if (kind == 'values') return { value: target[index], done: false };
  return { value: [index, target[index]], done: false };
}, 'values');

// argumentsList[@@iterator] is %ArrayProto_values%
// https://tc39.es/ecma262/#sec-createunmappedargumentsobject
// https://tc39.es/ecma262/#sec-createmappedargumentsobject
var values = Iterators.Arguments = Iterators.Array;

// https://tc39.es/ecma262/#sec-array.prototype-@@unscopables
addToUnscopables('keys');
addToUnscopables('values');
addToUnscopables('entries');

// V8 ~ Chrome 45- bug
if (!IS_PURE && DESCRIPTORS && values.name !== 'values') try {
  defineProperty(values, 'name', { value: 'values' });
} catch (error) { /* empty */ }


/***/ }),

/***/ 1539:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var TO_STRING_TAG_SUPPORT = __webpack_require__(1694);
var redefine = __webpack_require__(1320);
var toString = __webpack_require__(288);

// `Object.prototype.toString` method
// https://tc39.es/ecma262/#sec-object.prototype.tostring
if (!TO_STRING_TAG_SUPPORT) {
  redefine(Object.prototype, 'toString', toString, { unsafe: true });
}


/***/ }),

/***/ 7922:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var $ = __webpack_require__(2109);
var call = __webpack_require__(6916);
var aCallable = __webpack_require__(9662);
var newPromiseCapabilityModule = __webpack_require__(8523);
var perform = __webpack_require__(2534);
var iterate = __webpack_require__(408);

// `Promise.allSettled` method
// https://tc39.es/ecma262/#sec-promise.allsettled
$({ target: 'Promise', stat: true }, {
  allSettled: function allSettled(iterable) {
    var C = this;
    var capability = newPromiseCapabilityModule.f(C);
    var resolve = capability.resolve;
    var reject = capability.reject;
    var result = perform(function () {
      var promiseResolve = aCallable(C.resolve);
      var values = [];
      var counter = 0;
      var remaining = 1;
      iterate(iterable, function (promise) {
        var index = counter++;
        var alreadyCalled = false;
        remaining++;
        call(promiseResolve, C, promise).then(function (value) {
          if (alreadyCalled) return;
          alreadyCalled = true;
          values[index] = { status: 'fulfilled', value: value };
          --remaining || resolve(values);
        }, function (error) {
          if (alreadyCalled) return;
          alreadyCalled = true;
          values[index] = { status: 'rejected', reason: error };
          --remaining || resolve(values);
        });
      });
      --remaining || resolve(values);
    });
    if (result.error) reject(result.value);
    return capability.promise;
  }
});


/***/ }),

/***/ 4668:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var $ = __webpack_require__(2109);
var aCallable = __webpack_require__(9662);
var getBuiltIn = __webpack_require__(5005);
var call = __webpack_require__(6916);
var newPromiseCapabilityModule = __webpack_require__(8523);
var perform = __webpack_require__(2534);
var iterate = __webpack_require__(408);

var PROMISE_ANY_ERROR = 'No one promise resolved';

// `Promise.any` method
// https://tc39.es/ecma262/#sec-promise.any
$({ target: 'Promise', stat: true }, {
  any: function any(iterable) {
    var C = this;
    var AggregateError = getBuiltIn('AggregateError');
    var capability = newPromiseCapabilityModule.f(C);
    var resolve = capability.resolve;
    var reject = capability.reject;
    var result = perform(function () {
      var promiseResolve = aCallable(C.resolve);
      var errors = [];
      var counter = 0;
      var remaining = 1;
      var alreadyResolved = false;
      iterate(iterable, function (promise) {
        var index = counter++;
        var alreadyRejected = false;
        remaining++;
        call(promiseResolve, C, promise).then(function (value) {
          if (alreadyRejected || alreadyResolved) return;
          alreadyResolved = true;
          resolve(value);
        }, function (error) {
          if (alreadyRejected || alreadyResolved) return;
          alreadyRejected = true;
          errors[index] = error;
          --remaining || reject(new AggregateError(errors, PROMISE_ANY_ERROR));
        });
      });
      --remaining || reject(new AggregateError(errors, PROMISE_ANY_ERROR));
    });
    if (result.error) reject(result.value);
    return capability.promise;
  }
});


/***/ }),

/***/ 7727:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var $ = __webpack_require__(2109);
var IS_PURE = __webpack_require__(1913);
var NativePromise = __webpack_require__(3366);
var fails = __webpack_require__(7293);
var getBuiltIn = __webpack_require__(5005);
var isCallable = __webpack_require__(614);
var speciesConstructor = __webpack_require__(6707);
var promiseResolve = __webpack_require__(9478);
var redefine = __webpack_require__(1320);

// Safari bug https://bugs.webkit.org/show_bug.cgi?id=200829
var NON_GENERIC = !!NativePromise && fails(function () {
  // eslint-disable-next-line unicorn/no-thenable -- required for testing
  NativePromise.prototype['finally'].call({ then: function () { /* empty */ } }, function () { /* empty */ });
});

// `Promise.prototype.finally` method
// https://tc39.es/ecma262/#sec-promise.prototype.finally
$({ target: 'Promise', proto: true, real: true, forced: NON_GENERIC }, {
  'finally': function (onFinally) {
    var C = speciesConstructor(this, getBuiltIn('Promise'));
    var isFunction = isCallable(onFinally);
    return this.then(
      isFunction ? function (x) {
        return promiseResolve(C, onFinally()).then(function () { return x; });
      } : onFinally,
      isFunction ? function (e) {
        return promiseResolve(C, onFinally()).then(function () { throw e; });
      } : onFinally
    );
  }
});

// makes sure that native promise-based APIs `Promise#finally` properly works with patched `Promise#then`
if (!IS_PURE && isCallable(NativePromise)) {
  var method = getBuiltIn('Promise').prototype['finally'];
  if (NativePromise.prototype['finally'] !== method) {
    redefine(NativePromise.prototype, 'finally', method, { unsafe: true });
  }
}


/***/ }),

/***/ 8674:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var $ = __webpack_require__(2109);
var IS_PURE = __webpack_require__(1913);
var global = __webpack_require__(7854);
var getBuiltIn = __webpack_require__(5005);
var call = __webpack_require__(6916);
var NativePromise = __webpack_require__(3366);
var redefine = __webpack_require__(1320);
var redefineAll = __webpack_require__(2248);
var setPrototypeOf = __webpack_require__(7674);
var setToStringTag = __webpack_require__(8003);
var setSpecies = __webpack_require__(6340);
var aCallable = __webpack_require__(9662);
var isCallable = __webpack_require__(614);
var isObject = __webpack_require__(111);
var anInstance = __webpack_require__(5787);
var inspectSource = __webpack_require__(2788);
var iterate = __webpack_require__(408);
var checkCorrectnessOfIteration = __webpack_require__(7072);
var speciesConstructor = __webpack_require__(6707);
var task = (__webpack_require__(261).set);
var microtask = __webpack_require__(5948);
var promiseResolve = __webpack_require__(9478);
var hostReportErrors = __webpack_require__(842);
var newPromiseCapabilityModule = __webpack_require__(8523);
var perform = __webpack_require__(2534);
var Queue = __webpack_require__(8572);
var InternalStateModule = __webpack_require__(9909);
var isForced = __webpack_require__(4705);
var wellKnownSymbol = __webpack_require__(5112);
var IS_BROWSER = __webpack_require__(7871);
var IS_NODE = __webpack_require__(5268);
var V8_VERSION = __webpack_require__(7392);

var SPECIES = wellKnownSymbol('species');
var PROMISE = 'Promise';

var getInternalState = InternalStateModule.getterFor(PROMISE);
var setInternalState = InternalStateModule.set;
var getInternalPromiseState = InternalStateModule.getterFor(PROMISE);
var NativePromisePrototype = NativePromise && NativePromise.prototype;
var PromiseConstructor = NativePromise;
var PromisePrototype = NativePromisePrototype;
var TypeError = global.TypeError;
var document = global.document;
var process = global.process;
var newPromiseCapability = newPromiseCapabilityModule.f;
var newGenericPromiseCapability = newPromiseCapability;

var DISPATCH_EVENT = !!(document && document.createEvent && global.dispatchEvent);
var NATIVE_REJECTION_EVENT = isCallable(global.PromiseRejectionEvent);
var UNHANDLED_REJECTION = 'unhandledrejection';
var REJECTION_HANDLED = 'rejectionhandled';
var PENDING = 0;
var FULFILLED = 1;
var REJECTED = 2;
var HANDLED = 1;
var UNHANDLED = 2;
var SUBCLASSING = false;

var Internal, OwnPromiseCapability, PromiseWrapper, nativeThen;

var FORCED = isForced(PROMISE, function () {
  var PROMISE_CONSTRUCTOR_SOURCE = inspectSource(PromiseConstructor);
  var GLOBAL_CORE_JS_PROMISE = PROMISE_CONSTRUCTOR_SOURCE !== String(PromiseConstructor);
  // V8 6.6 (Node 10 and Chrome 66) have a bug with resolving custom thenables
  // https://bugs.chromium.org/p/chromium/issues/detail?id=830565
  // We can't detect it synchronously, so just check versions
  if (!GLOBAL_CORE_JS_PROMISE && V8_VERSION === 66) return true;
  // We need Promise#finally in the pure version for preventing prototype pollution
  if (IS_PURE && !PromisePrototype['finally']) return true;
  // We can't use @@species feature detection in V8 since it causes
  // deoptimization and performance degradation
  // https://github.com/zloirock/core-js/issues/679
  if (V8_VERSION >= 51 && /native code/.test(PROMISE_CONSTRUCTOR_SOURCE)) return false;
  // Detect correctness of subclassing with @@species support
  var promise = new PromiseConstructor(function (resolve) { resolve(1); });
  var FakePromise = function (exec) {
    exec(function () { /* empty */ }, function () { /* empty */ });
  };
  var constructor = promise.constructor = {};
  constructor[SPECIES] = FakePromise;
  SUBCLASSING = promise.then(function () { /* empty */ }) instanceof FakePromise;
  if (!SUBCLASSING) return true;
  // Unhandled rejections tracking support, NodeJS Promise without it fails @@species test
  return !GLOBAL_CORE_JS_PROMISE && IS_BROWSER && !NATIVE_REJECTION_EVENT;
});

var INCORRECT_ITERATION = FORCED || !checkCorrectnessOfIteration(function (iterable) {
  PromiseConstructor.all(iterable)['catch'](function () { /* empty */ });
});

// helpers
var isThenable = function (it) {
  var then;
  return isObject(it) && isCallable(then = it.then) ? then : false;
};

var callReaction = function (reaction, state) {
  var value = state.value;
  var ok = state.state == FULFILLED;
  var handler = ok ? reaction.ok : reaction.fail;
  var resolve = reaction.resolve;
  var reject = reaction.reject;
  var domain = reaction.domain;
  var result, then, exited;
  try {
    if (handler) {
      if (!ok) {
        if (state.rejection === UNHANDLED) onHandleUnhandled(state);
        state.rejection = HANDLED;
      }
      if (handler === true) result = value;
      else {
        if (domain) domain.enter();
        result = handler(value); // can throw
        if (domain) {
          domain.exit();
          exited = true;
        }
      }
      if (result === reaction.promise) {
        reject(TypeError('Promise-chain cycle'));
      } else if (then = isThenable(result)) {
        call(then, result, resolve, reject);
      } else resolve(result);
    } else reject(value);
  } catch (error) {
    if (domain && !exited) domain.exit();
    reject(error);
  }
};

var notify = function (state, isReject) {
  if (state.notified) return;
  state.notified = true;
  microtask(function () {
    var reactions = state.reactions;
    var reaction;
    while (reaction = reactions.get()) {
      callReaction(reaction, state);
    }
    state.notified = false;
    if (isReject && !state.rejection) onUnhandled(state);
  });
};

var dispatchEvent = function (name, promise, reason) {
  var event, handler;
  if (DISPATCH_EVENT) {
    event = document.createEvent('Event');
    event.promise = promise;
    event.reason = reason;
    event.initEvent(name, false, true);
    global.dispatchEvent(event);
  } else event = { promise: promise, reason: reason };
  if (!NATIVE_REJECTION_EVENT && (handler = global['on' + name])) handler(event);
  else if (name === UNHANDLED_REJECTION) hostReportErrors('Unhandled promise rejection', reason);
};

var onUnhandled = function (state) {
  call(task, global, function () {
    var promise = state.facade;
    var value = state.value;
    var IS_UNHANDLED = isUnhandled(state);
    var result;
    if (IS_UNHANDLED) {
      result = perform(function () {
        if (IS_NODE) {
          process.emit('unhandledRejection', value, promise);
        } else dispatchEvent(UNHANDLED_REJECTION, promise, value);
      });
      // Browsers should not trigger `rejectionHandled` event if it was handled here, NodeJS - should
      state.rejection = IS_NODE || isUnhandled(state) ? UNHANDLED : HANDLED;
      if (result.error) throw result.value;
    }
  });
};

var isUnhandled = function (state) {
  return state.rejection !== HANDLED && !state.parent;
};

var onHandleUnhandled = function (state) {
  call(task, global, function () {
    var promise = state.facade;
    if (IS_NODE) {
      process.emit('rejectionHandled', promise);
    } else dispatchEvent(REJECTION_HANDLED, promise, state.value);
  });
};

var bind = function (fn, state, unwrap) {
  return function (value) {
    fn(state, value, unwrap);
  };
};

var internalReject = function (state, value, unwrap) {
  if (state.done) return;
  state.done = true;
  if (unwrap) state = unwrap;
  state.value = value;
  state.state = REJECTED;
  notify(state, true);
};

var internalResolve = function (state, value, unwrap) {
  if (state.done) return;
  state.done = true;
  if (unwrap) state = unwrap;
  try {
    if (state.facade === value) throw TypeError("Promise can't be resolved itself");
    var then = isThenable(value);
    if (then) {
      microtask(function () {
        var wrapper = { done: false };
        try {
          call(then, value,
            bind(internalResolve, wrapper, state),
            bind(internalReject, wrapper, state)
          );
        } catch (error) {
          internalReject(wrapper, error, state);
        }
      });
    } else {
      state.value = value;
      state.state = FULFILLED;
      notify(state, false);
    }
  } catch (error) {
    internalReject({ done: false }, error, state);
  }
};

// constructor polyfill
if (FORCED) {
  // 25.4.3.1 Promise(executor)
  PromiseConstructor = function Promise(executor) {
    anInstance(this, PromisePrototype);
    aCallable(executor);
    call(Internal, this);
    var state = getInternalState(this);
    try {
      executor(bind(internalResolve, state), bind(internalReject, state));
    } catch (error) {
      internalReject(state, error);
    }
  };
  PromisePrototype = PromiseConstructor.prototype;
  // eslint-disable-next-line no-unused-vars -- required for `.length`
  Internal = function Promise(executor) {
    setInternalState(this, {
      type: PROMISE,
      done: false,
      notified: false,
      parent: false,
      reactions: new Queue(),
      rejection: false,
      state: PENDING,
      value: undefined
    });
  };
  Internal.prototype = redefineAll(PromisePrototype, {
    // `Promise.prototype.then` method
    // https://tc39.es/ecma262/#sec-promise.prototype.then
    // eslint-disable-next-line unicorn/no-thenable -- safe
    then: function then(onFulfilled, onRejected) {
      var state = getInternalPromiseState(this);
      var reaction = newPromiseCapability(speciesConstructor(this, PromiseConstructor));
      state.parent = true;
      reaction.ok = isCallable(onFulfilled) ? onFulfilled : true;
      reaction.fail = isCallable(onRejected) && onRejected;
      reaction.domain = IS_NODE ? process.domain : undefined;
      if (state.state == PENDING) state.reactions.add(reaction);
      else microtask(function () {
        callReaction(reaction, state);
      });
      return reaction.promise;
    },
    // `Promise.prototype.catch` method
    // https://tc39.es/ecma262/#sec-promise.prototype.catch
    'catch': function (onRejected) {
      return this.then(undefined, onRejected);
    }
  });
  OwnPromiseCapability = function () {
    var promise = new Internal();
    var state = getInternalState(promise);
    this.promise = promise;
    this.resolve = bind(internalResolve, state);
    this.reject = bind(internalReject, state);
  };
  newPromiseCapabilityModule.f = newPromiseCapability = function (C) {
    return C === PromiseConstructor || C === PromiseWrapper
      ? new OwnPromiseCapability(C)
      : newGenericPromiseCapability(C);
  };

  if (!IS_PURE && isCallable(NativePromise) && NativePromisePrototype !== Object.prototype) {
    nativeThen = NativePromisePrototype.then;

    if (!SUBCLASSING) {
      // make `Promise#then` return a polyfilled `Promise` for native promise-based APIs
      redefine(NativePromisePrototype, 'then', function then(onFulfilled, onRejected) {
        var that = this;
        return new PromiseConstructor(function (resolve, reject) {
          call(nativeThen, that, resolve, reject);
        }).then(onFulfilled, onRejected);
      // https://github.com/zloirock/core-js/issues/640
      }, { unsafe: true });

      // makes sure that native promise-based APIs `Promise#catch` properly works with patched `Promise#then`
      redefine(NativePromisePrototype, 'catch', PromisePrototype['catch'], { unsafe: true });
    }

    // make `.constructor === Promise` work for native promise-based APIs
    try {
      delete NativePromisePrototype.constructor;
    } catch (error) { /* empty */ }

    // make `instanceof Promise` work for native promise-based APIs
    if (setPrototypeOf) {
      setPrototypeOf(NativePromisePrototype, PromisePrototype);
    }
  }
}

$({ global: true, wrap: true, forced: FORCED }, {
  Promise: PromiseConstructor
});

setToStringTag(PromiseConstructor, PROMISE, false, true);
setSpecies(PROMISE);

PromiseWrapper = getBuiltIn(PROMISE);

// statics
$({ target: PROMISE, stat: true, forced: FORCED }, {
  // `Promise.reject` method
  // https://tc39.es/ecma262/#sec-promise.reject
  reject: function reject(r) {
    var capability = newPromiseCapability(this);
    call(capability.reject, undefined, r);
    return capability.promise;
  }
});

$({ target: PROMISE, stat: true, forced: IS_PURE || FORCED }, {
  // `Promise.resolve` method
  // https://tc39.es/ecma262/#sec-promise.resolve
  resolve: function resolve(x) {
    return promiseResolve(IS_PURE && this === PromiseWrapper ? PromiseConstructor : this, x);
  }
});

$({ target: PROMISE, stat: true, forced: INCORRECT_ITERATION }, {
  // `Promise.all` method
  // https://tc39.es/ecma262/#sec-promise.all
  all: function all(iterable) {
    var C = this;
    var capability = newPromiseCapability(C);
    var resolve = capability.resolve;
    var reject = capability.reject;
    var result = perform(function () {
      var $promiseResolve = aCallable(C.resolve);
      var values = [];
      var counter = 0;
      var remaining = 1;
      iterate(iterable, function (promise) {
        var index = counter++;
        var alreadyCalled = false;
        remaining++;
        call($promiseResolve, C, promise).then(function (value) {
          if (alreadyCalled) return;
          alreadyCalled = true;
          values[index] = value;
          --remaining || resolve(values);
        }, reject);
      });
      --remaining || resolve(values);
    });
    if (result.error) reject(result.value);
    return capability.promise;
  },
  // `Promise.race` method
  // https://tc39.es/ecma262/#sec-promise.race
  race: function race(iterable) {
    var C = this;
    var capability = newPromiseCapability(C);
    var reject = capability.reject;
    var result = perform(function () {
      var $promiseResolve = aCallable(C.resolve);
      iterate(iterable, function (promise) {
        call($promiseResolve, C, promise).then(capability.resolve, reject);
      });
    });
    if (result.error) reject(result.value);
    return capability.promise;
  }
});


/***/ }),

/***/ 8783:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var charAt = (__webpack_require__(8710).charAt);
var toString = __webpack_require__(1340);
var InternalStateModule = __webpack_require__(9909);
var defineIterator = __webpack_require__(654);

var STRING_ITERATOR = 'String Iterator';
var setInternalState = InternalStateModule.set;
var getInternalState = InternalStateModule.getterFor(STRING_ITERATOR);

// `String.prototype[@@iterator]` method
// https://tc39.es/ecma262/#sec-string.prototype-@@iterator
defineIterator(String, 'String', function (iterated) {
  setInternalState(this, {
    type: STRING_ITERATOR,
    string: toString(iterated),
    index: 0
  });
// `%StringIteratorPrototype%.next` method
// https://tc39.es/ecma262/#sec-%stringiteratorprototype%.next
}, function next() {
  var state = getInternalState(this);
  var string = state.string;
  var index = state.index;
  var point;
  if (index >= string.length) return { value: undefined, done: true };
  point = charAt(string, index);
  state.index += point.length;
  return { value: point, done: false };
});


/***/ }),

/***/ 8628:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

// TODO: Remove from `core-js@4`
__webpack_require__(9170);


/***/ }),

/***/ 7314:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

// TODO: Remove from `core-js@4`
__webpack_require__(7922);


/***/ }),

/***/ 6290:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

// TODO: Remove from `core-js@4`
__webpack_require__(4668);


/***/ }),

/***/ 4850:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var $ = __webpack_require__(2109);
var newPromiseCapabilityModule = __webpack_require__(8523);
var perform = __webpack_require__(2534);

// `Promise.try` method
// https://github.com/tc39/proposal-promise-try
$({ target: 'Promise', stat: true, forced: true }, {
  'try': function (callbackfn) {
    var promiseCapability = newPromiseCapabilityModule.f(this);
    var result = perform(callbackfn);
    (result.error ? promiseCapability.reject : promiseCapability.resolve)(result.value);
    return promiseCapability.promise;
  }
});


/***/ }),

/***/ 5505:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var $ = __webpack_require__(2109);
var getBuiltIn = __webpack_require__(5005);
var uncurryThis = __webpack_require__(1702);
var fails = __webpack_require__(7293);
var toString = __webpack_require__(1340);
var hasOwn = __webpack_require__(2597);
var validateArgumentsLength = __webpack_require__(8053);
var ctoi = (__webpack_require__(4170).ctoi);

var disallowed = /[^\d+/a-z]/i;
var whitespaces = /[\t\n\f\r ]+/g;
var finalEq = /[=]+$/;

var $atob = getBuiltIn('atob');
var fromCharCode = String.fromCharCode;
var charAt = uncurryThis(''.charAt);
var replace = uncurryThis(''.replace);
var exec = uncurryThis(disallowed.exec);

var NO_SPACES_IGNORE = fails(function () {
  return atob(' ') !== '';
});

var NO_ARG_RECEIVING_CHECK = !NO_SPACES_IGNORE && !fails(function () {
  $atob();
});

// `atob` method
// https://html.spec.whatwg.org/multipage/webappapis.html#dom-atob
$({ global: true, enumerable: true, forced: NO_SPACES_IGNORE || NO_ARG_RECEIVING_CHECK }, {
  atob: function atob(data) {
    validateArgumentsLength(arguments.length, 1);
    if (NO_ARG_RECEIVING_CHECK) return $atob(data);
    var string = replace(toString(data), whitespaces, '');
    var output = '';
    var position = 0;
    var bc = 0;
    var chr, bs;
    if (string.length % 4 == 0) {
      string = replace(string, finalEq, '');
    }
    if (string.length % 4 == 1 || exec(disallowed, string)) {
      throw new (getBuiltIn('DOMException'))('The string is not correctly encoded', 'InvalidCharacterError');
    }
    while (chr = charAt(string, position++)) {
      if (hasOwn(ctoi, chr)) {
        bs = bc % 4 ? bs * 64 + ctoi[chr] : ctoi[chr];
        if (bc++ % 4) output += fromCharCode(255 & bs >> (-2 * bc & 6));
      }
    } return output;
  }
});


/***/ }),

/***/ 7479:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var $ = __webpack_require__(2109);
var getBuiltIn = __webpack_require__(5005);
var uncurryThis = __webpack_require__(1702);
var fails = __webpack_require__(7293);
var toString = __webpack_require__(1340);
var validateArgumentsLength = __webpack_require__(8053);
var itoc = (__webpack_require__(4170).itoc);

var $btoa = getBuiltIn('btoa');
var charAt = uncurryThis(''.charAt);
var charCodeAt = uncurryThis(''.charCodeAt);

var NO_ARG_RECEIVING_CHECK = !!$btoa && !fails(function () {
  $btoa();
});

// `btoa` method
// https://html.spec.whatwg.org/multipage/webappapis.html#dom-btoa
$({ global: true, enumerable: true, forced: NO_ARG_RECEIVING_CHECK }, {
  btoa: function btoa(data) {
    validateArgumentsLength(arguments.length, 1);
    if (NO_ARG_RECEIVING_CHECK) return $btoa(data);
    var string = toString(data);
    var output = '';
    var position = 0;
    var map = itoc;
    var block, charCode;
    while (charAt(string, position) || (map = '=', position % 1)) {
      charCode = charCodeAt(string, position += 3 / 4);
      if (charCode > 0xFF) {
        throw new (getBuiltIn('DOMException'))('The string contains characters outside of the Latin1 range', 'InvalidCharacterError');
      }
      block = block << 8 | charCode;
      output += charAt(map, 63 & block >> 8 - position % 1 * 8);
    } return output;
  }
});


/***/ }),

/***/ 4747:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var DOMIterables = __webpack_require__(8324);
var DOMTokenListPrototype = __webpack_require__(8509);
var forEach = __webpack_require__(8533);
var createNonEnumerableProperty = __webpack_require__(8880);

var handlePrototype = function (CollectionPrototype) {
  // some Chrome versions have non-configurable methods on DOMTokenList
  if (CollectionPrototype && CollectionPrototype.forEach !== forEach) try {
    createNonEnumerableProperty(CollectionPrototype, 'forEach', forEach);
  } catch (error) {
    CollectionPrototype.forEach = forEach;
  }
};

for (var COLLECTION_NAME in DOMIterables) {
  if (DOMIterables[COLLECTION_NAME]) {
    handlePrototype(global[COLLECTION_NAME] && global[COLLECTION_NAME].prototype);
  }
}

handlePrototype(DOMTokenListPrototype);


/***/ }),

/***/ 3948:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var global = __webpack_require__(7854);
var DOMIterables = __webpack_require__(8324);
var DOMTokenListPrototype = __webpack_require__(8509);
var ArrayIteratorMethods = __webpack_require__(6992);
var createNonEnumerableProperty = __webpack_require__(8880);
var wellKnownSymbol = __webpack_require__(5112);

var ITERATOR = wellKnownSymbol('iterator');
var TO_STRING_TAG = wellKnownSymbol('toStringTag');
var ArrayValues = ArrayIteratorMethods.values;

var handlePrototype = function (CollectionPrototype, COLLECTION_NAME) {
  if (CollectionPrototype) {
    // some Chrome versions have non-configurable methods on DOMTokenList
    if (CollectionPrototype[ITERATOR] !== ArrayValues) try {
      createNonEnumerableProperty(CollectionPrototype, ITERATOR, ArrayValues);
    } catch (error) {
      CollectionPrototype[ITERATOR] = ArrayValues;
    }
    if (!CollectionPrototype[TO_STRING_TAG]) {
      createNonEnumerableProperty(CollectionPrototype, TO_STRING_TAG, COLLECTION_NAME);
    }
    if (DOMIterables[COLLECTION_NAME]) for (var METHOD_NAME in ArrayIteratorMethods) {
      // some Chrome versions have non-configurable methods on DOMTokenList
      if (CollectionPrototype[METHOD_NAME] !== ArrayIteratorMethods[METHOD_NAME]) try {
        createNonEnumerableProperty(CollectionPrototype, METHOD_NAME, ArrayIteratorMethods[METHOD_NAME]);
      } catch (error) {
        CollectionPrototype[METHOD_NAME] = ArrayIteratorMethods[METHOD_NAME];
      }
    }
  }
};

for (var COLLECTION_NAME in DOMIterables) {
  handlePrototype(global[COLLECTION_NAME] && global[COLLECTION_NAME].prototype, COLLECTION_NAME);
}

handlePrototype(DOMTokenListPrototype, 'DOMTokenList');


/***/ }),

/***/ 7714:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var $ = __webpack_require__(2109);
var tryNodeRequire = __webpack_require__(4038);
var getBuiltIn = __webpack_require__(5005);
var fails = __webpack_require__(7293);
var create = __webpack_require__(30);
var createPropertyDescriptor = __webpack_require__(9114);
var defineProperty = (__webpack_require__(3070).f);
var defineProperties = (__webpack_require__(6048).f);
var redefine = __webpack_require__(1320);
var hasOwn = __webpack_require__(2597);
var anInstance = __webpack_require__(5787);
var anObject = __webpack_require__(9670);
var errorToString = __webpack_require__(7762);
var normalizeStringArgument = __webpack_require__(6277);
var DOMExceptionConstants = __webpack_require__(3678);
var clearErrorStack = __webpack_require__(7741);
var InternalStateModule = __webpack_require__(9909);
var DESCRIPTORS = __webpack_require__(9781);
var IS_PURE = __webpack_require__(1913);

var DOM_EXCEPTION = 'DOMException';
var DATA_CLONE_ERR = 'DATA_CLONE_ERR';
var Error = getBuiltIn('Error');
// NodeJS < 17.0 does not expose `DOMException` to global
var NativeDOMException = getBuiltIn(DOM_EXCEPTION) || (function () {
  try {
    // NodeJS < 15.0 does not expose `MessageChannel` to global
    var MessageChannel = getBuiltIn('MessageChannel') || tryNodeRequire('worker_threads').MessageChannel;
    // eslint-disable-next-line es/no-weak-map, unicorn/require-post-message-target-origin -- safe
    new MessageChannel().port1.postMessage(new WeakMap());
  } catch (error) {
    if (error.name == DATA_CLONE_ERR && error.code == 25) return error.constructor;
  }
})();
var NativeDOMExceptionPrototype = NativeDOMException && NativeDOMException.prototype;
var ErrorPrototype = Error.prototype;
var setInternalState = InternalStateModule.set;
var getInternalState = InternalStateModule.getterFor(DOM_EXCEPTION);
var HAS_STACK = 'stack' in Error(DOM_EXCEPTION);

var codeFor = function (name) {
  return hasOwn(DOMExceptionConstants, name) && DOMExceptionConstants[name].m ? DOMExceptionConstants[name].c : 0;
};

var $DOMException = function DOMException() {
  anInstance(this, DOMExceptionPrototype);
  var argumentsLength = arguments.length;
  var message = normalizeStringArgument(argumentsLength < 1 ? undefined : arguments[0]);
  var name = normalizeStringArgument(argumentsLength < 2 ? undefined : arguments[1], 'Error');
  var code = codeFor(name);
  setInternalState(this, {
    type: DOM_EXCEPTION,
    name: name,
    message: message,
    code: code
  });
  if (!DESCRIPTORS) {
    this.name = name;
    this.message = message;
    this.code = code;
  }
  if (HAS_STACK) {
    var error = Error(message);
    error.name = DOM_EXCEPTION;
    defineProperty(this, 'stack', createPropertyDescriptor(1, clearErrorStack(error.stack, 1)));
  }
};

var DOMExceptionPrototype = $DOMException.prototype = create(ErrorPrototype);

var createGetterDescriptor = function (get) {
  return { enumerable: true, configurable: true, get: get };
};

var getterFor = function (key) {
  return createGetterDescriptor(function () {
    return getInternalState(this)[key];
  });
};

if (DESCRIPTORS) defineProperties(DOMExceptionPrototype, {
  name: getterFor('name'),
  message: getterFor('message'),
  code: getterFor('code')
});

defineProperty(DOMExceptionPrototype, 'constructor', createPropertyDescriptor(1, $DOMException));

// FF36- DOMException is a function, but can't be constructed
var INCORRECT_CONSTRUCTOR = fails(function () {
  return !(new NativeDOMException() instanceof Error);
});

// Safari 10.1 / Chrome 32- / IE8- DOMException.prototype.toString bugs
var INCORRECT_TO_STRING = INCORRECT_CONSTRUCTOR || fails(function () {
  return ErrorPrototype.toString !== errorToString || String(new NativeDOMException(1, 2)) !== '2: 1';
});

// Deno 1.6.3- DOMException.prototype.code just missed
var INCORRECT_CODE = INCORRECT_CONSTRUCTOR || fails(function () {
  return new NativeDOMException(1, 'DataCloneError').code !== 25;
});

// Deno 1.6.3- DOMException constants just missed
var MISSED_CONSTANTS = INCORRECT_CONSTRUCTOR
  || NativeDOMException[DATA_CLONE_ERR] !== 25
  || NativeDOMExceptionPrototype[DATA_CLONE_ERR] !== 25;

var FORCED_CONSTRUCTOR = IS_PURE ? INCORRECT_TO_STRING || INCORRECT_CODE || MISSED_CONSTANTS : INCORRECT_CONSTRUCTOR;

// `DOMException` constructor
// https://webidl.spec.whatwg.org/#idl-DOMException
$({ global: true, forced: FORCED_CONSTRUCTOR }, {
  DOMException: FORCED_CONSTRUCTOR ? $DOMException : NativeDOMException
});

var PolyfilledDOMException = getBuiltIn(DOM_EXCEPTION);
var PolyfilledDOMExceptionPrototype = PolyfilledDOMException.prototype;

if (INCORRECT_TO_STRING && (IS_PURE || NativeDOMException === PolyfilledDOMException)) {
  redefine(PolyfilledDOMExceptionPrototype, 'toString', errorToString);
}

if (INCORRECT_CODE && DESCRIPTORS && NativeDOMException === PolyfilledDOMException) {
  defineProperty(PolyfilledDOMExceptionPrototype, 'code', createGetterDescriptor(function () {
    return codeFor(anObject(this).name);
  }));
}

for (var key in DOMExceptionConstants) if (hasOwn(DOMExceptionConstants, key)) {
  var constant = DOMExceptionConstants[key];
  var constantName = constant.s;
  var descriptor = createPropertyDescriptor(6, constant.c);
  if (!hasOwn(PolyfilledDOMException, constantName)) {
    defineProperty(PolyfilledDOMException, constantName, descriptor);
  }
  if (!hasOwn(PolyfilledDOMExceptionPrototype, constantName)) {
    defineProperty(PolyfilledDOMExceptionPrototype, constantName, descriptor);
  }
}


/***/ }),

/***/ 2801:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var $ = __webpack_require__(2109);
var getBuiltIn = __webpack_require__(5005);
var createPropertyDescriptor = __webpack_require__(9114);
var defineProperty = (__webpack_require__(3070).f);
var hasOwn = __webpack_require__(2597);
var anInstance = __webpack_require__(5787);
var inheritIfRequired = __webpack_require__(9587);
var normalizeStringArgument = __webpack_require__(6277);
var DOMExceptionConstants = __webpack_require__(3678);
var clearErrorStack = __webpack_require__(7741);
var IS_PURE = __webpack_require__(1913);

var DOM_EXCEPTION = 'DOMException';
var Error = getBuiltIn('Error');
var NativeDOMException = getBuiltIn(DOM_EXCEPTION);

var $DOMException = function DOMException() {
  anInstance(this, DOMExceptionPrototype);
  var argumentsLength = arguments.length;
  var message = normalizeStringArgument(argumentsLength < 1 ? undefined : arguments[0]);
  var name = normalizeStringArgument(argumentsLength < 2 ? undefined : arguments[1], 'Error');
  var that = new NativeDOMException(message, name);
  var error = Error(message);
  error.name = DOM_EXCEPTION;
  defineProperty(that, 'stack', createPropertyDescriptor(1, clearErrorStack(error.stack, 1)));
  inheritIfRequired(that, this, $DOMException);
  return that;
};

var DOMExceptionPrototype = $DOMException.prototype = NativeDOMException.prototype;

var ERROR_HAS_STACK = 'stack' in Error(DOM_EXCEPTION);
var DOM_EXCEPTION_HAS_STACK = 'stack' in new NativeDOMException(1, 2);
var FORCED_CONSTRUCTOR = ERROR_HAS_STACK && !DOM_EXCEPTION_HAS_STACK;

// `DOMException` constructor patch for `.stack` where it's required
// https://webidl.spec.whatwg.org/#es-DOMException-specialness
$({ global: true, forced: IS_PURE || FORCED_CONSTRUCTOR }, { // TODO: fix export logic
  DOMException: FORCED_CONSTRUCTOR ? $DOMException : NativeDOMException
});

var PolyfilledDOMException = getBuiltIn(DOM_EXCEPTION);
var PolyfilledDOMExceptionPrototype = PolyfilledDOMException.prototype;

if (PolyfilledDOMExceptionPrototype.constructor !== PolyfilledDOMException) {
  if (!IS_PURE) {
    defineProperty(PolyfilledDOMExceptionPrototype, 'constructor', createPropertyDescriptor(1, PolyfilledDOMException));
  }

  for (var key in DOMExceptionConstants) if (hasOwn(DOMExceptionConstants, key)) {
    var constant = DOMExceptionConstants[key];
    var constantName = constant.s;
    if (!hasOwn(PolyfilledDOMException, constantName)) {
      defineProperty(PolyfilledDOMException, constantName, createPropertyDescriptor(6, constant.c));
    }
  }
}


/***/ }),

/***/ 1174:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var getBuiltIn = __webpack_require__(5005);
var setToStringTag = __webpack_require__(8003);

var DOM_EXCEPTION = 'DOMException';

setToStringTag(getBuiltIn(DOM_EXCEPTION), DOM_EXCEPTION);


/***/ }),

/***/ 4633:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var $ = __webpack_require__(2109);
var global = __webpack_require__(7854);
var task = __webpack_require__(261);

var FORCED = !global.setImmediate || !global.clearImmediate;

// http://w3c.github.io/setImmediate/
$({ global: true, bind: true, enumerable: true, forced: FORCED }, {
  // `setImmediate` method
  // http://w3c.github.io/setImmediate/#si-setImmediate
  setImmediate: task.set,
  // `clearImmediate` method
  // http://w3c.github.io/setImmediate/#si-clearImmediate
  clearImmediate: task.clear
});


/***/ }),

/***/ 5844:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var $ = __webpack_require__(2109);
var global = __webpack_require__(7854);
var microtask = __webpack_require__(5948);
var aCallable = __webpack_require__(9662);
var validateArgumentsLength = __webpack_require__(8053);
var IS_NODE = __webpack_require__(5268);

var process = global.process;

// `queueMicrotask` method
// https://html.spec.whatwg.org/multipage/timers-and-user-prompts.html#dom-queuemicrotask
$({ global: true, enumerable: true, noTargetGet: true }, {
  queueMicrotask: function queueMicrotask(fn) {
    validateArgumentsLength(arguments.length, 1);
    aCallable(fn);
    var domain = IS_NODE && process.domain;
    microtask(domain ? domain.bind(fn) : fn);
  }
});


/***/ }),

/***/ 1295:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var IS_PURE = __webpack_require__(1913);
var $ = __webpack_require__(2109);
var global = __webpack_require__(7854);
var getBuiltin = __webpack_require__(5005);
var uncurryThis = __webpack_require__(1702);
var fails = __webpack_require__(7293);
var uid = __webpack_require__(9711);
var isCallable = __webpack_require__(614);
var isConstructor = __webpack_require__(4411);
var isObject = __webpack_require__(111);
var isSymbol = __webpack_require__(2190);
var iterate = __webpack_require__(408);
var anObject = __webpack_require__(9670);
var classof = __webpack_require__(648);
var hasOwn = __webpack_require__(2597);
var createProperty = __webpack_require__(6135);
var createNonEnumerableProperty = __webpack_require__(8880);
var lengthOfArrayLike = __webpack_require__(6244);
var validateArgumentsLength = __webpack_require__(8053);
var regExpFlags = __webpack_require__(7066);
var ERROR_STACK_INSTALLABLE = __webpack_require__(2914);

var Object = global.Object;
var Date = global.Date;
var Error = global.Error;
var EvalError = global.EvalError;
var RangeError = global.RangeError;
var ReferenceError = global.ReferenceError;
var SyntaxError = global.SyntaxError;
var TypeError = global.TypeError;
var URIError = global.URIError;
var PerformanceMark = global.PerformanceMark;
var WebAssembly = global.WebAssembly;
var CompileError = WebAssembly && WebAssembly.CompileError || Error;
var LinkError = WebAssembly && WebAssembly.LinkError || Error;
var RuntimeError = WebAssembly && WebAssembly.RuntimeError || Error;
var DOMException = getBuiltin('DOMException');
var Set = getBuiltin('Set');
var Map = getBuiltin('Map');
var MapPrototype = Map.prototype;
var mapHas = uncurryThis(MapPrototype.has);
var mapGet = uncurryThis(MapPrototype.get);
var mapSet = uncurryThis(MapPrototype.set);
var setAdd = uncurryThis(Set.prototype.add);
var objectKeys = getBuiltin('Object', 'keys');
var push = uncurryThis([].push);
var booleanValueOf = uncurryThis(true.valueOf);
var numberValueOf = uncurryThis(1.0.valueOf);
var stringValueOf = uncurryThis(''.valueOf);
var getFlags = uncurryThis(regExpFlags);
var getTime = uncurryThis(Date.prototype.getTime);
var PERFORMANCE_MARK = uid('structuredClone');
var DATA_CLONE_ERROR = 'DataCloneError';
var TRANSFERRING = 'Transferring';

var checkBasicSemantic = function (structuredCloneImplementation) {
  return !fails(function () {
    var set1 = new global.Set([7]);
    var set2 = structuredCloneImplementation(set1);
    var number = structuredCloneImplementation(Object(7));
    return set2 == set1 || !set2.has(7) || typeof number != 'object' || number != 7;
  }) && structuredCloneImplementation;
};

// https://github.com/whatwg/html/pull/5749
var checkNewErrorsSemantic = function (structuredCloneImplementation) {
  return !fails(function () {
    var test = structuredCloneImplementation(new global.AggregateError([1], PERFORMANCE_MARK, { cause: 3 }));
    return test.name != 'AggregateError' || test.errors[0] != 1 || test.message != PERFORMANCE_MARK || test.cause != 3;
  }) && structuredCloneImplementation;
};

// FF94+, Safari TP134+, Chrome Canary 98+, NodeJS 17.0+, Deno 1.13+
// current FF and Safari implementations can't clone errors
// https://bugzilla.mozilla.org/show_bug.cgi?id=1556604
// no one of current implementations supports new (html/5749) error cloning semantic
var nativeStructuredClone = global.structuredClone;

var FORCED_REPLACEMENT = IS_PURE || !checkNewErrorsSemantic(nativeStructuredClone);

// Chrome 82+, Safari 14.1+, Deno 1.11+
// Chrome 78-81 implementation swaps `.name` and `.message` of cloned `DOMException`
// Safari 14.1 implementation doesn't clone some `RegExp` flags, so requires a workaround
// current Safari implementation can't clone errors
// Deno 1.2-1.10 implementations too naive
// NodeJS 16.0+ does not have `PerformanceMark` constructor, structured cloning implementation
//   from `performance.mark` is too naive and can't clone, for example, `RegExp` or some boxed primitives
//   https://github.com/nodejs/node/issues/40840
// no one of current implementations supports new (html/5749) error cloning semantic
var structuredCloneFromMark = !nativeStructuredClone && checkBasicSemantic(function (value) {
  return new PerformanceMark(PERFORMANCE_MARK, { detail: value }).detail;
});

var nativeRestrictedStructuredClone = checkBasicSemantic(nativeStructuredClone) || structuredCloneFromMark;

var throwUncloneable = function (type) {
  throw new DOMException('Uncloneable type: ' + type, DATA_CLONE_ERROR);
};

var throwUnpolyfillable = function (type, kind) {
  throw new DOMException((kind || 'Cloning') + ' of ' + type + ' cannot be properly polyfilled in this engine', DATA_CLONE_ERROR);
};

var structuredCloneInternal = function (value, map) {
  if (isSymbol(value)) throwUncloneable('Symbol');
  if (!isObject(value)) return value;
  // effectively preserves circular references
  if (map) {
    if (mapHas(map, value)) return mapGet(map, value);
  } else map = new Map();

  var type = classof(value);
  var deep = false;
  var C, name, cloned, dataTransfer, i, length, keys, key, source, target;

  switch (type) {
    case 'Array':
      cloned = [];
      deep = true;
      break;
    case 'Object':
      cloned = {};
      deep = true;
      break;
    case 'Map':
      cloned = new Map();
      deep = true;
      break;
    case 'Set':
      cloned = new Set();
      deep = true;
      break;
    case 'RegExp':
      // in this block because of a Safari 14.1 bug
      // old FF does not clone regexes passed to the constructor, so get the source and flags directly
      cloned = new RegExp(value.source, 'flags' in value ? value.flags : getFlags(value));
      break;
    case 'Error':
      name = value.name;
      switch (name) {
        case 'AggregateError':
          cloned = getBuiltin('AggregateError')([]);
          break;
        case 'EvalError':
          cloned = EvalError();
          break;
        case 'RangeError':
          cloned = RangeError();
          break;
        case 'ReferenceError':
          cloned = ReferenceError();
          break;
        case 'SyntaxError':
          cloned = SyntaxError();
          break;
        case 'TypeError':
          cloned = TypeError();
          break;
        case 'URIError':
          cloned = URIError();
          break;
        case 'CompileError':
          cloned = CompileError();
          break;
        case 'LinkError':
          cloned = LinkError();
          break;
        case 'RuntimeError':
          cloned = RuntimeError();
          break;
        default:
          cloned = Error();
      }
      deep = true;
      break;
    case 'DOMException':
      cloned = new DOMException(value.message, value.name);
      deep = true;
      break;
    case 'DataView':
    case 'Int8Array':
    case 'Uint8Array':
    case 'Uint8ClampedArray':
    case 'Int16Array':
    case 'Uint16Array':
    case 'Int32Array':
    case 'Uint32Array':
    case 'Float32Array':
    case 'Float64Array':
    case 'BigInt64Array':
    case 'BigUint64Array':
      C = global[type];
      // in some old engines like Safari 9, typeof C is 'object'
      // on Uint8ClampedArray or some other constructors
      if (!isObject(C)) throwUnpolyfillable(type);
      cloned = new C(
        // this is safe, since arraybuffer cannot have circular references
        structuredCloneInternal(value.buffer, map),
        value.byteOffset,
        type === 'DataView' ? value.byteLength : value.length
      );
      break;
    case 'DOMQuad':
      try {
        cloned = new DOMQuad(
          structuredCloneInternal(value.p1, map),
          structuredCloneInternal(value.p2, map),
          structuredCloneInternal(value.p3, map),
          structuredCloneInternal(value.p4, map)
        );
      } catch (error) {
        if (nativeRestrictedStructuredClone) {
          cloned = nativeRestrictedStructuredClone(value);
        } else throwUnpolyfillable(type);
      }
      break;
    case 'FileList':
      C = global.DataTransfer;
      if (isConstructor(C)) {
        dataTransfer = new C();
        for (i = 0, length = lengthOfArrayLike(value); i < length; i++) {
          dataTransfer.items.add(structuredCloneInternal(value[i], map));
        }
        cloned = dataTransfer.files;
      } else if (nativeRestrictedStructuredClone) {
        cloned = nativeRestrictedStructuredClone(value);
      } else throwUnpolyfillable(type);
      break;
    case 'ImageData':
      // Safari 9 ImageData is a constructor, but typeof ImageData is 'object'
      try {
        cloned = new ImageData(
          structuredCloneInternal(value.data, map),
          value.width,
          value.height,
          { colorSpace: value.colorSpace }
        );
      } catch (error) {
        if (nativeRestrictedStructuredClone) {
          cloned = nativeRestrictedStructuredClone(value);
        } else throwUnpolyfillable(type);
      } break;
    default:
      if (nativeRestrictedStructuredClone) {
        cloned = nativeRestrictedStructuredClone(value);
      } else switch (type) {
        case 'BigInt':
          // can be a 3rd party polyfill
          cloned = Object(value.valueOf());
          break;
        case 'Boolean':
          cloned = Object(booleanValueOf(value));
          break;
        case 'Number':
          cloned = Object(numberValueOf(value));
          break;
        case 'String':
          cloned = Object(stringValueOf(value));
          break;
        case 'Date':
          cloned = new Date(getTime(value));
          break;
        case 'ArrayBuffer':
          C = global.DataView;
          // `ArrayBuffer#slice` is not available in IE10
          // `ArrayBuffer#slice` and `DataView` are not available in old FF
          if (!C && typeof value.slice != 'function') throwUnpolyfillable(type);
          // detached buffers throws in `DataView` and `.slice`
          try {
            if (typeof value.slice == 'function') {
              cloned = value.slice(0);
            } else {
              length = value.byteLength;
              cloned = new ArrayBuffer(length);
              source = new C(value);
              target = new C(cloned);
              for (i = 0; i < length; i++) {
                target.setUint8(i, source.getUint8(i));
              }
            }
          } catch (error) {
            throw new DOMException('ArrayBuffer is detached', DATA_CLONE_ERROR);
          } break;
        case 'SharedArrayBuffer':
          // SharedArrayBuffer should use shared memory, we can't polyfill it, so return the original
          cloned = value;
          break;
        case 'Blob':
          try {
            cloned = value.slice(0, value.size, value.type);
          } catch (error) {
            throwUnpolyfillable(type);
          } break;
        case 'DOMPoint':
        case 'DOMPointReadOnly':
          C = global[type];
          try {
            cloned = C.fromPoint
              ? C.fromPoint(value)
              : new C(value.x, value.y, value.z, value.w);
          } catch (error) {
            throwUnpolyfillable(type);
          } break;
        case 'DOMRect':
        case 'DOMRectReadOnly':
          C = global[type];
          try {
            cloned = C.fromRect
              ? C.fromRect(value)
              : new C(value.x, value.y, value.width, value.height);
          } catch (error) {
            throwUnpolyfillable(type);
          } break;
        case 'DOMMatrix':
        case 'DOMMatrixReadOnly':
          C = global[type];
          try {
            cloned = C.fromMatrix
              ? C.fromMatrix(value)
              : new C(value);
          } catch (error) {
            throwUnpolyfillable(type);
          } break;
        case 'AudioData':
        case 'VideoFrame':
          if (!isCallable(value.clone)) throwUnpolyfillable(type);
          try {
            cloned = value.clone();
          } catch (error) {
            throwUncloneable(type);
          } break;
        case 'File':
          try {
            cloned = new File([value], value.name, value);
          } catch (error) {
            throwUnpolyfillable(type);
          } break;
        case 'CryptoKey':
        case 'GPUCompilationMessage':
        case 'GPUCompilationInfo':
        case 'ImageBitmap':
        case 'RTCCertificate':
        case 'WebAssembly.Module':
          throwUnpolyfillable(type);
          // break omitted
        default:
          throwUncloneable(type);
      }
  }

  mapSet(map, value, cloned);

  if (deep) switch (type) {
    case 'Array':
    case 'Object':
      keys = objectKeys(value);
      for (i = 0, length = lengthOfArrayLike(keys); i < length; i++) {
        key = keys[i];
        createProperty(cloned, key, structuredCloneInternal(value[key], map));
      } break;
    case 'Map':
      value.forEach(function (v, k) {
        mapSet(cloned, structuredCloneInternal(k, map), structuredCloneInternal(v, map));
      });
      break;
    case 'Set':
      value.forEach(function (v) {
        setAdd(cloned, structuredCloneInternal(v, map));
      });
      break;
    case 'Error':
      createNonEnumerableProperty(cloned, 'message', structuredCloneInternal(value.message, map));
      if (hasOwn(value, 'cause')) {
        createNonEnumerableProperty(cloned, 'cause', structuredCloneInternal(value.cause, map));
      }
      if (name == 'AggregateError') {
        cloned.errors = structuredCloneInternal(value.errors, map);
      } // break omitted
    case 'DOMException':
      if (ERROR_STACK_INSTALLABLE) {
        createNonEnumerableProperty(cloned, 'stack', structuredCloneInternal(value.stack, map));
      }
  }

  return cloned;
};

var PROPER_TRANSFER = nativeStructuredClone && !fails(function () {
  var buffer = new ArrayBuffer(8);
  var clone = nativeStructuredClone(buffer, { transfer: [buffer] });
  return buffer.byteLength != 0 || clone.byteLength != 8;
});

var tryToTransfer = function (rawTransfer, map) {
  if (!isObject(rawTransfer)) throw TypeError('Transfer option cannot be converted to a sequence');

  var transfer = [];

  iterate(rawTransfer, function (value) {
    push(transfer, anObject(value));
  });

  var i = 0;
  var length = lengthOfArrayLike(transfer);
  var value, type, C, transferredArray, transferred, canvas, context;

  if (PROPER_TRANSFER) {
    transferredArray = nativeStructuredClone(transfer, { transfer: transfer });
    while (i < length) mapSet(map, transfer[i], transferredArray[i++]);
  } else while (i < length) {
    value = transfer[i++];
    if (mapHas(map, value)) throw new DOMException('Duplicate transferable', DATA_CLONE_ERROR);

    type = classof(value);

    switch (type) {
      case 'ImageBitmap':
        C = global.OffscreenCanvas;
        if (!isConstructor(C)) throwUnpolyfillable(type, TRANSFERRING);
        try {
          canvas = new C(value.width, value.height);
          context = canvas.getContext('bitmaprenderer');
          context.transferFromImageBitmap(value);
          transferred = canvas.transferToImageBitmap();
        } catch (error) { /* empty */ }
        break;
      case 'AudioData':
      case 'VideoFrame':
        if (!isCallable(value.clone) || !isCallable(value.close)) throwUnpolyfillable(type, TRANSFERRING);
        try {
          transferred = value.clone();
          value.close();
        } catch (error) { /* empty */ }
        break;
      case 'ArrayBuffer':
      case 'MessagePort':
      case 'OffscreenCanvas':
      case 'ReadableStream':
      case 'TransformStream':
      case 'WritableStream':
        throwUnpolyfillable(type, TRANSFERRING);
    }

    if (transferred === undefined) throw new DOMException('This object cannot be transferred: ' + type, DATA_CLONE_ERROR);
    mapSet(map, value, transferred);
  }
};

$({ global: true, enumerable: true, sham: !PROPER_TRANSFER, forced: FORCED_REPLACEMENT }, {
  structuredClone: function structuredClone(value /* , { transfer } */) {
    var options = validateArgumentsLength(arguments.length, 1) > 1 ? anObject(arguments[1]) : undefined;
    var transfer = options ? options.transfer : undefined;
    var map;

    if (transfer !== undefined) {
      map = new Map();
      tryToTransfer(transfer, map);
    }

    return structuredCloneInternal(value, map);
  }
});


/***/ }),

/***/ 2564:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

var $ = __webpack_require__(2109);
var global = __webpack_require__(7854);
var apply = __webpack_require__(2104);
var isCallable = __webpack_require__(614);
var userAgent = __webpack_require__(8113);
var arraySlice = __webpack_require__(206);
var validateArgumentsLength = __webpack_require__(8053);

var MSIE = /MSIE .\./.test(userAgent); // <- dirty ie9- check
var Function = global.Function;

var wrap = function (scheduler) {
  return function (handler, timeout /* , ...arguments */) {
    var boundArgs = validateArgumentsLength(arguments.length, 1) > 2;
    var fn = isCallable(handler) ? handler : Function(handler);
    var args = boundArgs ? arraySlice(arguments, 2) : undefined;
    return scheduler(boundArgs ? function () {
      apply(fn, this, args);
    } : fn, timeout);
  };
};

// ie9- setTimeout & setInterval additional parameters fix
// https://html.spec.whatwg.org/multipage/timers-and-user-prompts.html#timers
$({ global: true, bind: true, forced: MSIE }, {
  // `setTimeout` method
  // https://html.spec.whatwg.org/multipage/timers-and-user-prompts.html#dom-settimeout
  setTimeout: wrap(global.setTimeout),
  // `setInterval` method
  // https://html.spec.whatwg.org/multipage/timers-and-user-prompts.html#dom-setinterval
  setInterval: wrap(global.setInterval)
});


/***/ }),

/***/ 1637:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

"use strict";

// TODO: in core-js@4, move /modules/ dependencies to public entries for better optimization by tools like `preset-env`
__webpack_require__(6992);
var $ = __webpack_require__(2109);
var global = __webpack_require__(7854);
var getBuiltIn = __webpack_require__(5005);
var call = __webpack_require__(6916);
var uncurryThis = __webpack_require__(1702);
var USE_NATIVE_URL = __webpack_require__(590);
var redefine = __webpack_require__(1320);
var redefineAll = __webpack_require__(2248);
var setToStringTag = __webpack_require__(8003);
var createIteratorConstructor = __webpack_require__(4994);
var InternalStateModule = __webpack_require__(9909);
var anInstance = __webpack_require__(5787);
var isCallable = __webpack_require__(614);
var hasOwn = __webpack_require__(2597);
var bind = __webpack_require__(9974);
var classof = __webpack_require__(648);
var anObject = __webpack_require__(9670);
var isObject = __webpack_require__(111);
var $toString = __webpack_require__(1340);
var create = __webpack_require__(30);
var createPropertyDescriptor = __webpack_require__(9114);
var getIterator = __webpack_require__(8554);
var getIteratorMethod = __webpack_require__(1246);
var validateArgumentsLength = __webpack_require__(8053);
var wellKnownSymbol = __webpack_require__(5112);
var arraySort = __webpack_require__(4362);

var ITERATOR = wellKnownSymbol('iterator');
var URL_SEARCH_PARAMS = 'URLSearchParams';
var URL_SEARCH_PARAMS_ITERATOR = URL_SEARCH_PARAMS + 'Iterator';
var setInternalState = InternalStateModule.set;
var getInternalParamsState = InternalStateModule.getterFor(URL_SEARCH_PARAMS);
var getInternalIteratorState = InternalStateModule.getterFor(URL_SEARCH_PARAMS_ITERATOR);

var n$Fetch = getBuiltIn('fetch');
var N$Request = getBuiltIn('Request');
var Headers = getBuiltIn('Headers');
var RequestPrototype = N$Request && N$Request.prototype;
var HeadersPrototype = Headers && Headers.prototype;
var RegExp = global.RegExp;
var TypeError = global.TypeError;
var decodeURIComponent = global.decodeURIComponent;
var encodeURIComponent = global.encodeURIComponent;
var charAt = uncurryThis(''.charAt);
var join = uncurryThis([].join);
var push = uncurryThis([].push);
var replace = uncurryThis(''.replace);
var shift = uncurryThis([].shift);
var splice = uncurryThis([].splice);
var split = uncurryThis(''.split);
var stringSlice = uncurryThis(''.slice);

var plus = /\+/g;
var sequences = Array(4);

var percentSequence = function (bytes) {
  return sequences[bytes - 1] || (sequences[bytes - 1] = RegExp('((?:%[\\da-f]{2}){' + bytes + '})', 'gi'));
};

var percentDecode = function (sequence) {
  try {
    return decodeURIComponent(sequence);
  } catch (error) {
    return sequence;
  }
};

var deserialize = function (it) {
  var result = replace(it, plus, ' ');
  var bytes = 4;
  try {
    return decodeURIComponent(result);
  } catch (error) {
    while (bytes) {
      result = replace(result, percentSequence(bytes--), percentDecode);
    }
    return result;
  }
};

var find = /[!'()~]|%20/g;

var replacements = {
  '!': '%21',
  "'": '%27',
  '(': '%28',
  ')': '%29',
  '~': '%7E',
  '%20': '+'
};

var replacer = function (match) {
  return replacements[match];
};

var serialize = function (it) {
  return replace(encodeURIComponent(it), find, replacer);
};

var URLSearchParamsIterator = createIteratorConstructor(function Iterator(params, kind) {
  setInternalState(this, {
    type: URL_SEARCH_PARAMS_ITERATOR,
    iterator: getIterator(getInternalParamsState(params).entries),
    kind: kind
  });
}, 'Iterator', function next() {
  var state = getInternalIteratorState(this);
  var kind = state.kind;
  var step = state.iterator.next();
  var entry = step.value;
  if (!step.done) {
    step.value = kind === 'keys' ? entry.key : kind === 'values' ? entry.value : [entry.key, entry.value];
  } return step;
}, true);

var URLSearchParamsState = function (init) {
  this.entries = [];
  this.url = null;

  if (init !== undefined) {
    if (isObject(init)) this.parseObject(init);
    else this.parseQuery(typeof init == 'string' ? charAt(init, 0) === '?' ? stringSlice(init, 1) : init : $toString(init));
  }
};

URLSearchParamsState.prototype = {
  type: URL_SEARCH_PARAMS,
  bindURL: function (url) {
    this.url = url;
    this.update();
  },
  parseObject: function (object) {
    var iteratorMethod = getIteratorMethod(object);
    var iterator, next, step, entryIterator, entryNext, first, second;

    if (iteratorMethod) {
      iterator = getIterator(object, iteratorMethod);
      next = iterator.next;
      while (!(step = call(next, iterator)).done) {
        entryIterator = getIterator(anObject(step.value));
        entryNext = entryIterator.next;
        if (
          (first = call(entryNext, entryIterator)).done ||
          (second = call(entryNext, entryIterator)).done ||
          !call(entryNext, entryIterator).done
        ) throw TypeError('Expected sequence with length 2');
        push(this.entries, { key: $toString(first.value), value: $toString(second.value) });
      }
    } else for (var key in object) if (hasOwn(object, key)) {
      push(this.entries, { key: key, value: $toString(object[key]) });
    }
  },
  parseQuery: function (query) {
    if (query) {
      var attributes = split(query, '&');
      var index = 0;
      var attribute, entry;
      while (index < attributes.length) {
        attribute = attributes[index++];
        if (attribute.length) {
          entry = split(attribute, '=');
          push(this.entries, {
            key: deserialize(shift(entry)),
            value: deserialize(join(entry, '='))
          });
        }
      }
    }
  },
  serialize: function () {
    var entries = this.entries;
    var result = [];
    var index = 0;
    var entry;
    while (index < entries.length) {
      entry = entries[index++];
      push(result, serialize(entry.key) + '=' + serialize(entry.value));
    } return join(result, '&');
  },
  update: function () {
    this.entries.length = 0;
    this.parseQuery(this.url.query);
  },
  updateURL: function () {
    if (this.url) this.url.update();
  }
};

// `URLSearchParams` constructor
// https://url.spec.whatwg.org/#interface-urlsearchparams
var URLSearchParamsConstructor = function URLSearchParams(/* init */) {
  anInstance(this, URLSearchParamsPrototype);
  var init = arguments.length > 0 ? arguments[0] : undefined;
  setInternalState(this, new URLSearchParamsState(init));
};

var URLSearchParamsPrototype = URLSearchParamsConstructor.prototype;

redefineAll(URLSearchParamsPrototype, {
  // `URLSearchParams.prototype.append` method
  // https://url.spec.whatwg.org/#dom-urlsearchparams-append
  append: function append(name, value) {
    validateArgumentsLength(arguments.length, 2);
    var state = getInternalParamsState(this);
    push(state.entries, { key: $toString(name), value: $toString(value) });
    state.updateURL();
  },
  // `URLSearchParams.prototype.delete` method
  // https://url.spec.whatwg.org/#dom-urlsearchparams-delete
  'delete': function (name) {
    validateArgumentsLength(arguments.length, 1);
    var state = getInternalParamsState(this);
    var entries = state.entries;
    var key = $toString(name);
    var index = 0;
    while (index < entries.length) {
      if (entries[index].key === key) splice(entries, index, 1);
      else index++;
    }
    state.updateURL();
  },
  // `URLSearchParams.prototype.get` method
  // https://url.spec.whatwg.org/#dom-urlsearchparams-get
  get: function get(name) {
    validateArgumentsLength(arguments.length, 1);
    var entries = getInternalParamsState(this).entries;
    var key = $toString(name);
    var index = 0;
    for (; index < entries.length; index++) {
      if (entries[index].key === key) return entries[index].value;
    }
    return null;
  },
  // `URLSearchParams.prototype.getAll` method
  // https://url.spec.whatwg.org/#dom-urlsearchparams-getall
  getAll: function getAll(name) {
    validateArgumentsLength(arguments.length, 1);
    var entries = getInternalParamsState(this).entries;
    var key = $toString(name);
    var result = [];
    var index = 0;
    for (; index < entries.length; index++) {
      if (entries[index].key === key) push(result, entries[index].value);
    }
    return result;
  },
  // `URLSearchParams.prototype.has` method
  // https://url.spec.whatwg.org/#dom-urlsearchparams-has
  has: function has(name) {
    validateArgumentsLength(arguments.length, 1);
    var entries = getInternalParamsState(this).entries;
    var key = $toString(name);
    var index = 0;
    while (index < entries.length) {
      if (entries[index++].key === key) return true;
    }
    return false;
  },
  // `URLSearchParams.prototype.set` method
  // https://url.spec.whatwg.org/#dom-urlsearchparams-set
  set: function set(name, value) {
    validateArgumentsLength(arguments.length, 1);
    var state = getInternalParamsState(this);
    var entries = state.entries;
    var found = false;
    var key = $toString(name);
    var val = $toString(value);
    var index = 0;
    var entry;
    for (; index < entries.length; index++) {
      entry = entries[index];
      if (entry.key === key) {
        if (found) splice(entries, index--, 1);
        else {
          found = true;
          entry.value = val;
        }
      }
    }
    if (!found) push(entries, { key: key, value: val });
    state.updateURL();
  },
  // `URLSearchParams.prototype.sort` method
  // https://url.spec.whatwg.org/#dom-urlsearchparams-sort
  sort: function sort() {
    var state = getInternalParamsState(this);
    arraySort(state.entries, function (a, b) {
      return a.key > b.key ? 1 : -1;
    });
    state.updateURL();
  },
  // `URLSearchParams.prototype.forEach` method
  forEach: function forEach(callback /* , thisArg */) {
    var entries = getInternalParamsState(this).entries;
    var boundFunction = bind(callback, arguments.length > 1 ? arguments[1] : undefined);
    var index = 0;
    var entry;
    while (index < entries.length) {
      entry = entries[index++];
      boundFunction(entry.value, entry.key, this);
    }
  },
  // `URLSearchParams.prototype.keys` method
  keys: function keys() {
    return new URLSearchParamsIterator(this, 'keys');
  },
  // `URLSearchParams.prototype.values` method
  values: function values() {
    return new URLSearchParamsIterator(this, 'values');
  },
  // `URLSearchParams.prototype.entries` method
  entries: function entries() {
    return new URLSearchParamsIterator(this, 'entries');
  }
}, { enumerable: true });

// `URLSearchParams.prototype[@@iterator]` method
redefine(URLSearchParamsPrototype, ITERATOR, URLSearchParamsPrototype.entries, { name: 'entries' });

// `URLSearchParams.prototype.toString` method
// https://url.spec.whatwg.org/#urlsearchparams-stringification-behavior
redefine(URLSearchParamsPrototype, 'toString', function toString() {
  return getInternalParamsState(this).serialize();
}, { enumerable: true });

setToStringTag(URLSearchParamsConstructor, URL_SEARCH_PARAMS);

$({ global: true, forced: !USE_NATIVE_URL }, {
  URLSearchParams: URLSearchParamsConstructor
});

// Wrap `fetch` and `Request` for correct work with polyfilled `URLSearchParams`
if (!USE_NATIVE_URL && isCallable(Headers)) {
  var headersHas = uncurryThis(HeadersPrototype.has);
  var headersSet = uncurryThis(HeadersPrototype.set);

  var wrapRequestOptions = function (init) {
    if (isObject(init)) {
      var body = init.body;
      var headers;
      if (classof(body) === URL_SEARCH_PARAMS) {
        headers = init.headers ? new Headers(init.headers) : new Headers();
        if (!headersHas(headers, 'content-type')) {
          headersSet(headers, 'content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
        }
        return create(init, {
          body: createPropertyDescriptor(0, $toString(body)),
          headers: createPropertyDescriptor(0, headers)
        });
      }
    } return init;
  };

  if (isCallable(n$Fetch)) {
    $({ global: true, enumerable: true, forced: true }, {
      fetch: function fetch(input /* , init */) {
        return n$Fetch(input, arguments.length > 1 ? wrapRequestOptions(arguments[1]) : {});
      }
    });
  }

  if (isCallable(N$Request)) {
    var RequestConstructor = function Request(input /* , init */) {
      anInstance(this, RequestPrototype);
      return new N$Request(input, arguments.length > 1 ? wrapRequestOptions(arguments[1]) : {});
    };

    RequestPrototype.constructor = RequestConstructor;
    RequestConstructor.prototype = RequestPrototype;

    $({ global: true, forced: true }, {
      Request: RequestConstructor
    });
  }
}

module.exports = {
  URLSearchParams: URLSearchParamsConstructor,
  getState: getInternalParamsState
};


/***/ }),

/***/ 285:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

"use strict";

// TODO: in core-js@4, move /modules/ dependencies to public entries for better optimization by tools like `preset-env`
__webpack_require__(8783);
var $ = __webpack_require__(2109);
var DESCRIPTORS = __webpack_require__(9781);
var USE_NATIVE_URL = __webpack_require__(590);
var global = __webpack_require__(7854);
var bind = __webpack_require__(9974);
var uncurryThis = __webpack_require__(1702);
var defineProperties = (__webpack_require__(6048).f);
var redefine = __webpack_require__(1320);
var anInstance = __webpack_require__(5787);
var hasOwn = __webpack_require__(2597);
var assign = __webpack_require__(1574);
var arrayFrom = __webpack_require__(8457);
var arraySlice = __webpack_require__(1589);
var codeAt = (__webpack_require__(8710).codeAt);
var toASCII = __webpack_require__(3197);
var $toString = __webpack_require__(1340);
var setToStringTag = __webpack_require__(8003);
var validateArgumentsLength = __webpack_require__(8053);
var URLSearchParamsModule = __webpack_require__(1637);
var InternalStateModule = __webpack_require__(9909);

var setInternalState = InternalStateModule.set;
var getInternalURLState = InternalStateModule.getterFor('URL');
var URLSearchParams = URLSearchParamsModule.URLSearchParams;
var getInternalSearchParamsState = URLSearchParamsModule.getState;

var NativeURL = global.URL;
var TypeError = global.TypeError;
var parseInt = global.parseInt;
var floor = Math.floor;
var pow = Math.pow;
var charAt = uncurryThis(''.charAt);
var exec = uncurryThis(/./.exec);
var join = uncurryThis([].join);
var numberToString = uncurryThis(1.0.toString);
var pop = uncurryThis([].pop);
var push = uncurryThis([].push);
var replace = uncurryThis(''.replace);
var shift = uncurryThis([].shift);
var split = uncurryThis(''.split);
var stringSlice = uncurryThis(''.slice);
var toLowerCase = uncurryThis(''.toLowerCase);
var unshift = uncurryThis([].unshift);

var INVALID_AUTHORITY = 'Invalid authority';
var INVALID_SCHEME = 'Invalid scheme';
var INVALID_HOST = 'Invalid host';
var INVALID_PORT = 'Invalid port';

var ALPHA = /[a-z]/i;
// eslint-disable-next-line regexp/no-obscure-range -- safe
var ALPHANUMERIC = /[\d+-.a-z]/i;
var DIGIT = /\d/;
var HEX_START = /^0x/i;
var OCT = /^[0-7]+$/;
var DEC = /^\d+$/;
var HEX = /^[\da-f]+$/i;
/* eslint-disable regexp/no-control-character -- safe */
var FORBIDDEN_HOST_CODE_POINT = /[\0\t\n\r #%/:<>?@[\\\]^|]/;
var FORBIDDEN_HOST_CODE_POINT_EXCLUDING_PERCENT = /[\0\t\n\r #/:<>?@[\\\]^|]/;
var LEADING_AND_TRAILING_C0_CONTROL_OR_SPACE = /^[\u0000-\u0020]+|[\u0000-\u0020]+$/g;
var TAB_AND_NEW_LINE = /[\t\n\r]/g;
/* eslint-enable regexp/no-control-character -- safe */
var EOF;

// https://url.spec.whatwg.org/#ipv4-number-parser
var parseIPv4 = function (input) {
  var parts = split(input, '.');
  var partsLength, numbers, index, part, radix, number, ipv4;
  if (parts.length && parts[parts.length - 1] == '') {
    parts.length--;
  }
  partsLength = parts.length;
  if (partsLength > 4) return input;
  numbers = [];
  for (index = 0; index < partsLength; index++) {
    part = parts[index];
    if (part == '') return input;
    radix = 10;
    if (part.length > 1 && charAt(part, 0) == '0') {
      radix = exec(HEX_START, part) ? 16 : 8;
      part = stringSlice(part, radix == 8 ? 1 : 2);
    }
    if (part === '') {
      number = 0;
    } else {
      if (!exec(radix == 10 ? DEC : radix == 8 ? OCT : HEX, part)) return input;
      number = parseInt(part, radix);
    }
    push(numbers, number);
  }
  for (index = 0; index < partsLength; index++) {
    number = numbers[index];
    if (index == partsLength - 1) {
      if (number >= pow(256, 5 - partsLength)) return null;
    } else if (number > 255) return null;
  }
  ipv4 = pop(numbers);
  for (index = 0; index < numbers.length; index++) {
    ipv4 += numbers[index] * pow(256, 3 - index);
  }
  return ipv4;
};

// https://url.spec.whatwg.org/#concept-ipv6-parser
// eslint-disable-next-line max-statements -- TODO
var parseIPv6 = function (input) {
  var address = [0, 0, 0, 0, 0, 0, 0, 0];
  var pieceIndex = 0;
  var compress = null;
  var pointer = 0;
  var value, length, numbersSeen, ipv4Piece, number, swaps, swap;

  var chr = function () {
    return charAt(input, pointer);
  };

  if (chr() == ':') {
    if (charAt(input, 1) != ':') return;
    pointer += 2;
    pieceIndex++;
    compress = pieceIndex;
  }
  while (chr()) {
    if (pieceIndex == 8) return;
    if (chr() == ':') {
      if (compress !== null) return;
      pointer++;
      pieceIndex++;
      compress = pieceIndex;
      continue;
    }
    value = length = 0;
    while (length < 4 && exec(HEX, chr())) {
      value = value * 16 + parseInt(chr(), 16);
      pointer++;
      length++;
    }
    if (chr() == '.') {
      if (length == 0) return;
      pointer -= length;
      if (pieceIndex > 6) return;
      numbersSeen = 0;
      while (chr()) {
        ipv4Piece = null;
        if (numbersSeen > 0) {
          if (chr() == '.' && numbersSeen < 4) pointer++;
          else return;
        }
        if (!exec(DIGIT, chr())) return;
        while (exec(DIGIT, chr())) {
          number = parseInt(chr(), 10);
          if (ipv4Piece === null) ipv4Piece = number;
          else if (ipv4Piece == 0) return;
          else ipv4Piece = ipv4Piece * 10 + number;
          if (ipv4Piece > 255) return;
          pointer++;
        }
        address[pieceIndex] = address[pieceIndex] * 256 + ipv4Piece;
        numbersSeen++;
        if (numbersSeen == 2 || numbersSeen == 4) pieceIndex++;
      }
      if (numbersSeen != 4) return;
      break;
    } else if (chr() == ':') {
      pointer++;
      if (!chr()) return;
    } else if (chr()) return;
    address[pieceIndex++] = value;
  }
  if (compress !== null) {
    swaps = pieceIndex - compress;
    pieceIndex = 7;
    while (pieceIndex != 0 && swaps > 0) {
      swap = address[pieceIndex];
      address[pieceIndex--] = address[compress + swaps - 1];
      address[compress + --swaps] = swap;
    }
  } else if (pieceIndex != 8) return;
  return address;
};

var findLongestZeroSequence = function (ipv6) {
  var maxIndex = null;
  var maxLength = 1;
  var currStart = null;
  var currLength = 0;
  var index = 0;
  for (; index < 8; index++) {
    if (ipv6[index] !== 0) {
      if (currLength > maxLength) {
        maxIndex = currStart;
        maxLength = currLength;
      }
      currStart = null;
      currLength = 0;
    } else {
      if (currStart === null) currStart = index;
      ++currLength;
    }
  }
  if (currLength > maxLength) {
    maxIndex = currStart;
    maxLength = currLength;
  }
  return maxIndex;
};

// https://url.spec.whatwg.org/#host-serializing
var serializeHost = function (host) {
  var result, index, compress, ignore0;
  // ipv4
  if (typeof host == 'number') {
    result = [];
    for (index = 0; index < 4; index++) {
      unshift(result, host % 256);
      host = floor(host / 256);
    } return join(result, '.');
  // ipv6
  } else if (typeof host == 'object') {
    result = '';
    compress = findLongestZeroSequence(host);
    for (index = 0; index < 8; index++) {
      if (ignore0 && host[index] === 0) continue;
      if (ignore0) ignore0 = false;
      if (compress === index) {
        result += index ? ':' : '::';
        ignore0 = true;
      } else {
        result += numberToString(host[index], 16);
        if (index < 7) result += ':';
      }
    }
    return '[' + result + ']';
  } return host;
};

var C0ControlPercentEncodeSet = {};
var fragmentPercentEncodeSet = assign({}, C0ControlPercentEncodeSet, {
  ' ': 1, '"': 1, '<': 1, '>': 1, '`': 1
});
var pathPercentEncodeSet = assign({}, fragmentPercentEncodeSet, {
  '#': 1, '?': 1, '{': 1, '}': 1
});
var userinfoPercentEncodeSet = assign({}, pathPercentEncodeSet, {
  '/': 1, ':': 1, ';': 1, '=': 1, '@': 1, '[': 1, '\\': 1, ']': 1, '^': 1, '|': 1
});

var percentEncode = function (chr, set) {
  var code = codeAt(chr, 0);
  return code > 0x20 && code < 0x7F && !hasOwn(set, chr) ? chr : encodeURIComponent(chr);
};

// https://url.spec.whatwg.org/#special-scheme
var specialSchemes = {
  ftp: 21,
  file: null,
  http: 80,
  https: 443,
  ws: 80,
  wss: 443
};

// https://url.spec.whatwg.org/#windows-drive-letter
var isWindowsDriveLetter = function (string, normalized) {
  var second;
  return string.length == 2 && exec(ALPHA, charAt(string, 0))
    && ((second = charAt(string, 1)) == ':' || (!normalized && second == '|'));
};

// https://url.spec.whatwg.org/#start-with-a-windows-drive-letter
var startsWithWindowsDriveLetter = function (string) {
  var third;
  return string.length > 1 && isWindowsDriveLetter(stringSlice(string, 0, 2)) && (
    string.length == 2 ||
    ((third = charAt(string, 2)) === '/' || third === '\\' || third === '?' || third === '#')
  );
};

// https://url.spec.whatwg.org/#single-dot-path-segment
var isSingleDot = function (segment) {
  return segment === '.' || toLowerCase(segment) === '%2e';
};

// https://url.spec.whatwg.org/#double-dot-path-segment
var isDoubleDot = function (segment) {
  segment = toLowerCase(segment);
  return segment === '..' || segment === '%2e.' || segment === '.%2e' || segment === '%2e%2e';
};

// States:
var SCHEME_START = {};
var SCHEME = {};
var NO_SCHEME = {};
var SPECIAL_RELATIVE_OR_AUTHORITY = {};
var PATH_OR_AUTHORITY = {};
var RELATIVE = {};
var RELATIVE_SLASH = {};
var SPECIAL_AUTHORITY_SLASHES = {};
var SPECIAL_AUTHORITY_IGNORE_SLASHES = {};
var AUTHORITY = {};
var HOST = {};
var HOSTNAME = {};
var PORT = {};
var FILE = {};
var FILE_SLASH = {};
var FILE_HOST = {};
var PATH_START = {};
var PATH = {};
var CANNOT_BE_A_BASE_URL_PATH = {};
var QUERY = {};
var FRAGMENT = {};

var URLState = function (url, isBase, base) {
  var urlString = $toString(url);
  var baseState, failure, searchParams;
  if (isBase) {
    failure = this.parse(urlString);
    if (failure) throw TypeError(failure);
    this.searchParams = null;
  } else {
    if (base !== undefined) baseState = new URLState(base, true);
    failure = this.parse(urlString, null, baseState);
    if (failure) throw TypeError(failure);
    searchParams = getInternalSearchParamsState(new URLSearchParams());
    searchParams.bindURL(this);
    this.searchParams = searchParams;
  }
};

URLState.prototype = {
  type: 'URL',
  // https://url.spec.whatwg.org/#url-parsing
  // eslint-disable-next-line max-statements -- TODO
  parse: function (input, stateOverride, base) {
    var url = this;
    var state = stateOverride || SCHEME_START;
    var pointer = 0;
    var buffer = '';
    var seenAt = false;
    var seenBracket = false;
    var seenPasswordToken = false;
    var codePoints, chr, bufferCodePoints, failure;

    input = $toString(input);

    if (!stateOverride) {
      url.scheme = '';
      url.username = '';
      url.password = '';
      url.host = null;
      url.port = null;
      url.path = [];
      url.query = null;
      url.fragment = null;
      url.cannotBeABaseURL = false;
      input = replace(input, LEADING_AND_TRAILING_C0_CONTROL_OR_SPACE, '');
    }

    input = replace(input, TAB_AND_NEW_LINE, '');

    codePoints = arrayFrom(input);

    while (pointer <= codePoints.length) {
      chr = codePoints[pointer];
      switch (state) {
        case SCHEME_START:
          if (chr && exec(ALPHA, chr)) {
            buffer += toLowerCase(chr);
            state = SCHEME;
          } else if (!stateOverride) {
            state = NO_SCHEME;
            continue;
          } else return INVALID_SCHEME;
          break;

        case SCHEME:
          if (chr && (exec(ALPHANUMERIC, chr) || chr == '+' || chr == '-' || chr == '.')) {
            buffer += toLowerCase(chr);
          } else if (chr == ':') {
            if (stateOverride && (
              (url.isSpecial() != hasOwn(specialSchemes, buffer)) ||
              (buffer == 'file' && (url.includesCredentials() || url.port !== null)) ||
              (url.scheme == 'file' && !url.host)
            )) return;
            url.scheme = buffer;
            if (stateOverride) {
              if (url.isSpecial() && specialSchemes[url.scheme] == url.port) url.port = null;
              return;
            }
            buffer = '';
            if (url.scheme == 'file') {
              state = FILE;
            } else if (url.isSpecial() && base && base.scheme == url.scheme) {
              state = SPECIAL_RELATIVE_OR_AUTHORITY;
            } else if (url.isSpecial()) {
              state = SPECIAL_AUTHORITY_SLASHES;
            } else if (codePoints[pointer + 1] == '/') {
              state = PATH_OR_AUTHORITY;
              pointer++;
            } else {
              url.cannotBeABaseURL = true;
              push(url.path, '');
              state = CANNOT_BE_A_BASE_URL_PATH;
            }
          } else if (!stateOverride) {
            buffer = '';
            state = NO_SCHEME;
            pointer = 0;
            continue;
          } else return INVALID_SCHEME;
          break;

        case NO_SCHEME:
          if (!base || (base.cannotBeABaseURL && chr != '#')) return INVALID_SCHEME;
          if (base.cannotBeABaseURL && chr == '#') {
            url.scheme = base.scheme;
            url.path = arraySlice(base.path);
            url.query = base.query;
            url.fragment = '';
            url.cannotBeABaseURL = true;
            state = FRAGMENT;
            break;
          }
          state = base.scheme == 'file' ? FILE : RELATIVE;
          continue;

        case SPECIAL_RELATIVE_OR_AUTHORITY:
          if (chr == '/' && codePoints[pointer + 1] == '/') {
            state = SPECIAL_AUTHORITY_IGNORE_SLASHES;
            pointer++;
          } else {
            state = RELATIVE;
            continue;
          } break;

        case PATH_OR_AUTHORITY:
          if (chr == '/') {
            state = AUTHORITY;
            break;
          } else {
            state = PATH;
            continue;
          }

        case RELATIVE:
          url.scheme = base.scheme;
          if (chr == EOF) {
            url.username = base.username;
            url.password = base.password;
            url.host = base.host;
            url.port = base.port;
            url.path = arraySlice(base.path);
            url.query = base.query;
          } else if (chr == '/' || (chr == '\\' && url.isSpecial())) {
            state = RELATIVE_SLASH;
          } else if (chr == '?') {
            url.username = base.username;
            url.password = base.password;
            url.host = base.host;
            url.port = base.port;
            url.path = arraySlice(base.path);
            url.query = '';
            state = QUERY;
          } else if (chr == '#') {
            url.username = base.username;
            url.password = base.password;
            url.host = base.host;
            url.port = base.port;
            url.path = arraySlice(base.path);
            url.query = base.query;
            url.fragment = '';
            state = FRAGMENT;
          } else {
            url.username = base.username;
            url.password = base.password;
            url.host = base.host;
            url.port = base.port;
            url.path = arraySlice(base.path);
            url.path.length--;
            state = PATH;
            continue;
          } break;

        case RELATIVE_SLASH:
          if (url.isSpecial() && (chr == '/' || chr == '\\')) {
            state = SPECIAL_AUTHORITY_IGNORE_SLASHES;
          } else if (chr == '/') {
            state = AUTHORITY;
          } else {
            url.username = base.username;
            url.password = base.password;
            url.host = base.host;
            url.port = base.port;
            state = PATH;
            continue;
          } break;

        case SPECIAL_AUTHORITY_SLASHES:
          state = SPECIAL_AUTHORITY_IGNORE_SLASHES;
          if (chr != '/' || charAt(buffer, pointer + 1) != '/') continue;
          pointer++;
          break;

        case SPECIAL_AUTHORITY_IGNORE_SLASHES:
          if (chr != '/' && chr != '\\') {
            state = AUTHORITY;
            continue;
          } break;

        case AUTHORITY:
          if (chr == '@') {
            if (seenAt) buffer = '%40' + buffer;
            seenAt = true;
            bufferCodePoints = arrayFrom(buffer);
            for (var i = 0; i < bufferCodePoints.length; i++) {
              var codePoint = bufferCodePoints[i];
              if (codePoint == ':' && !seenPasswordToken) {
                seenPasswordToken = true;
                continue;
              }
              var encodedCodePoints = percentEncode(codePoint, userinfoPercentEncodeSet);
              if (seenPasswordToken) url.password += encodedCodePoints;
              else url.username += encodedCodePoints;
            }
            buffer = '';
          } else if (
            chr == EOF || chr == '/' || chr == '?' || chr == '#' ||
            (chr == '\\' && url.isSpecial())
          ) {
            if (seenAt && buffer == '') return INVALID_AUTHORITY;
            pointer -= arrayFrom(buffer).length + 1;
            buffer = '';
            state = HOST;
          } else buffer += chr;
          break;

        case HOST:
        case HOSTNAME:
          if (stateOverride && url.scheme == 'file') {
            state = FILE_HOST;
            continue;
          } else if (chr == ':' && !seenBracket) {
            if (buffer == '') return INVALID_HOST;
            failure = url.parseHost(buffer);
            if (failure) return failure;
            buffer = '';
            state = PORT;
            if (stateOverride == HOSTNAME) return;
          } else if (
            chr == EOF || chr == '/' || chr == '?' || chr == '#' ||
            (chr == '\\' && url.isSpecial())
          ) {
            if (url.isSpecial() && buffer == '') return INVALID_HOST;
            if (stateOverride && buffer == '' && (url.includesCredentials() || url.port !== null)) return;
            failure = url.parseHost(buffer);
            if (failure) return failure;
            buffer = '';
            state = PATH_START;
            if (stateOverride) return;
            continue;
          } else {
            if (chr == '[') seenBracket = true;
            else if (chr == ']') seenBracket = false;
            buffer += chr;
          } break;

        case PORT:
          if (exec(DIGIT, chr)) {
            buffer += chr;
          } else if (
            chr == EOF || chr == '/' || chr == '?' || chr == '#' ||
            (chr == '\\' && url.isSpecial()) ||
            stateOverride
          ) {
            if (buffer != '') {
              var port = parseInt(buffer, 10);
              if (port > 0xFFFF) return INVALID_PORT;
              url.port = (url.isSpecial() && port === specialSchemes[url.scheme]) ? null : port;
              buffer = '';
            }
            if (stateOverride) return;
            state = PATH_START;
            continue;
          } else return INVALID_PORT;
          break;

        case FILE:
          url.scheme = 'file';
          if (chr == '/' || chr == '\\') state = FILE_SLASH;
          else if (base && base.scheme == 'file') {
            if (chr == EOF) {
              url.host = base.host;
              url.path = arraySlice(base.path);
              url.query = base.query;
            } else if (chr == '?') {
              url.host = base.host;
              url.path = arraySlice(base.path);
              url.query = '';
              state = QUERY;
            } else if (chr == '#') {
              url.host = base.host;
              url.path = arraySlice(base.path);
              url.query = base.query;
              url.fragment = '';
              state = FRAGMENT;
            } else {
              if (!startsWithWindowsDriveLetter(join(arraySlice(codePoints, pointer), ''))) {
                url.host = base.host;
                url.path = arraySlice(base.path);
                url.shortenPath();
              }
              state = PATH;
              continue;
            }
          } else {
            state = PATH;
            continue;
          } break;

        case FILE_SLASH:
          if (chr == '/' || chr == '\\') {
            state = FILE_HOST;
            break;
          }
          if (base && base.scheme == 'file' && !startsWithWindowsDriveLetter(join(arraySlice(codePoints, pointer), ''))) {
            if (isWindowsDriveLetter(base.path[0], true)) push(url.path, base.path[0]);
            else url.host = base.host;
          }
          state = PATH;
          continue;

        case FILE_HOST:
          if (chr == EOF || chr == '/' || chr == '\\' || chr == '?' || chr == '#') {
            if (!stateOverride && isWindowsDriveLetter(buffer)) {
              state = PATH;
            } else if (buffer == '') {
              url.host = '';
              if (stateOverride) return;
              state = PATH_START;
            } else {
              failure = url.parseHost(buffer);
              if (failure) return failure;
              if (url.host == 'localhost') url.host = '';
              if (stateOverride) return;
              buffer = '';
              state = PATH_START;
            } continue;
          } else buffer += chr;
          break;

        case PATH_START:
          if (url.isSpecial()) {
            state = PATH;
            if (chr != '/' && chr != '\\') continue;
          } else if (!stateOverride && chr == '?') {
            url.query = '';
            state = QUERY;
          } else if (!stateOverride && chr == '#') {
            url.fragment = '';
            state = FRAGMENT;
          } else if (chr != EOF) {
            state = PATH;
            if (chr != '/') continue;
          } break;

        case PATH:
          if (
            chr == EOF || chr == '/' ||
            (chr == '\\' && url.isSpecial()) ||
            (!stateOverride && (chr == '?' || chr == '#'))
          ) {
            if (isDoubleDot(buffer)) {
              url.shortenPath();
              if (chr != '/' && !(chr == '\\' && url.isSpecial())) {
                push(url.path, '');
              }
            } else if (isSingleDot(buffer)) {
              if (chr != '/' && !(chr == '\\' && url.isSpecial())) {
                push(url.path, '');
              }
            } else {
              if (url.scheme == 'file' && !url.path.length && isWindowsDriveLetter(buffer)) {
                if (url.host) url.host = '';
                buffer = charAt(buffer, 0) + ':'; // normalize windows drive letter
              }
              push(url.path, buffer);
            }
            buffer = '';
            if (url.scheme == 'file' && (chr == EOF || chr == '?' || chr == '#')) {
              while (url.path.length > 1 && url.path[0] === '') {
                shift(url.path);
              }
            }
            if (chr == '?') {
              url.query = '';
              state = QUERY;
            } else if (chr == '#') {
              url.fragment = '';
              state = FRAGMENT;
            }
          } else {
            buffer += percentEncode(chr, pathPercentEncodeSet);
          } break;

        case CANNOT_BE_A_BASE_URL_PATH:
          if (chr == '?') {
            url.query = '';
            state = QUERY;
          } else if (chr == '#') {
            url.fragment = '';
            state = FRAGMENT;
          } else if (chr != EOF) {
            url.path[0] += percentEncode(chr, C0ControlPercentEncodeSet);
          } break;

        case QUERY:
          if (!stateOverride && chr == '#') {
            url.fragment = '';
            state = FRAGMENT;
          } else if (chr != EOF) {
            if (chr == "'" && url.isSpecial()) url.query += '%27';
            else if (chr == '#') url.query += '%23';
            else url.query += percentEncode(chr, C0ControlPercentEncodeSet);
          } break;

        case FRAGMENT:
          if (chr != EOF) url.fragment += percentEncode(chr, fragmentPercentEncodeSet);
          break;
      }

      pointer++;
    }
  },
  // https://url.spec.whatwg.org/#host-parsing
  parseHost: function (input) {
    var result, codePoints, index;
    if (charAt(input, 0) == '[') {
      if (charAt(input, input.length - 1) != ']') return INVALID_HOST;
      result = parseIPv6(stringSlice(input, 1, -1));
      if (!result) return INVALID_HOST;
      this.host = result;
    // opaque host
    } else if (!this.isSpecial()) {
      if (exec(FORBIDDEN_HOST_CODE_POINT_EXCLUDING_PERCENT, input)) return INVALID_HOST;
      result = '';
      codePoints = arrayFrom(input);
      for (index = 0; index < codePoints.length; index++) {
        result += percentEncode(codePoints[index], C0ControlPercentEncodeSet);
      }
      this.host = result;
    } else {
      input = toASCII(input);
      if (exec(FORBIDDEN_HOST_CODE_POINT, input)) return INVALID_HOST;
      result = parseIPv4(input);
      if (result === null) return INVALID_HOST;
      this.host = result;
    }
  },
  // https://url.spec.whatwg.org/#cannot-have-a-username-password-port
  cannotHaveUsernamePasswordPort: function () {
    return !this.host || this.cannotBeABaseURL || this.scheme == 'file';
  },
  // https://url.spec.whatwg.org/#include-credentials
  includesCredentials: function () {
    return this.username != '' || this.password != '';
  },
  // https://url.spec.whatwg.org/#is-special
  isSpecial: function () {
    return hasOwn(specialSchemes, this.scheme);
  },
  // https://url.spec.whatwg.org/#shorten-a-urls-path
  shortenPath: function () {
    var path = this.path;
    var pathSize = path.length;
    if (pathSize && (this.scheme != 'file' || pathSize != 1 || !isWindowsDriveLetter(path[0], true))) {
      path.length--;
    }
  },
  // https://url.spec.whatwg.org/#concept-url-serializer
  serialize: function () {
    var url = this;
    var scheme = url.scheme;
    var username = url.username;
    var password = url.password;
    var host = url.host;
    var port = url.port;
    var path = url.path;
    var query = url.query;
    var fragment = url.fragment;
    var output = scheme + ':';
    if (host !== null) {
      output += '//';
      if (url.includesCredentials()) {
        output += username + (password ? ':' + password : '') + '@';
      }
      output += serializeHost(host);
      if (port !== null) output += ':' + port;
    } else if (scheme == 'file') output += '//';
    output += url.cannotBeABaseURL ? path[0] : path.length ? '/' + join(path, '/') : '';
    if (query !== null) output += '?' + query;
    if (fragment !== null) output += '#' + fragment;
    return output;
  },
  // https://url.spec.whatwg.org/#dom-url-href
  setHref: function (href) {
    var failure = this.parse(href);
    if (failure) throw TypeError(failure);
    this.searchParams.update();
  },
  // https://url.spec.whatwg.org/#dom-url-origin
  getOrigin: function () {
    var scheme = this.scheme;
    var port = this.port;
    if (scheme == 'blob') try {
      return new URLConstructor(scheme.path[0]).origin;
    } catch (error) {
      return 'null';
    }
    if (scheme == 'file' || !this.isSpecial()) return 'null';
    return scheme + '://' + serializeHost(this.host) + (port !== null ? ':' + port : '');
  },
  // https://url.spec.whatwg.org/#dom-url-protocol
  getProtocol: function () {
    return this.scheme + ':';
  },
  setProtocol: function (protocol) {
    this.parse($toString(protocol) + ':', SCHEME_START);
  },
  // https://url.spec.whatwg.org/#dom-url-username
  getUsername: function () {
    return this.username;
  },
  setUsername: function (username) {
    var codePoints = arrayFrom($toString(username));
    if (this.cannotHaveUsernamePasswordPort()) return;
    this.username = '';
    for (var i = 0; i < codePoints.length; i++) {
      this.username += percentEncode(codePoints[i], userinfoPercentEncodeSet);
    }
  },
  // https://url.spec.whatwg.org/#dom-url-password
  getPassword: function () {
    return this.password;
  },
  setPassword: function (password) {
    var codePoints = arrayFrom($toString(password));
    if (this.cannotHaveUsernamePasswordPort()) return;
    this.password = '';
    for (var i = 0; i < codePoints.length; i++) {
      this.password += percentEncode(codePoints[i], userinfoPercentEncodeSet);
    }
  },
  // https://url.spec.whatwg.org/#dom-url-host
  getHost: function () {
    var host = this.host;
    var port = this.port;
    return host === null ? ''
      : port === null ? serializeHost(host)
      : serializeHost(host) + ':' + port;
  },
  setHost: function (host) {
    if (this.cannotBeABaseURL) return;
    this.parse(host, HOST);
  },
  // https://url.spec.whatwg.org/#dom-url-hostname
  getHostname: function () {
    var host = this.host;
    return host === null ? '' : serializeHost(host);
  },
  setHostname: function (hostname) {
    if (this.cannotBeABaseURL) return;
    this.parse(hostname, HOSTNAME);
  },
  // https://url.spec.whatwg.org/#dom-url-port
  getPort: function () {
    var port = this.port;
    return port === null ? '' : $toString(port);
  },
  setPort: function (port) {
    if (this.cannotHaveUsernamePasswordPort()) return;
    port = $toString(port);
    if (port == '') this.port = null;
    else this.parse(port, PORT);
  },
  // https://url.spec.whatwg.org/#dom-url-pathname
  getPathname: function () {
    var path = this.path;
    return this.cannotBeABaseURL ? path[0] : path.length ? '/' + join(path, '/') : '';
  },
  setPathname: function (pathname) {
    if (this.cannotBeABaseURL) return;
    this.path = [];
    this.parse(pathname, PATH_START);
  },
  // https://url.spec.whatwg.org/#dom-url-search
  getSearch: function () {
    var query = this.query;
    return query ? '?' + query : '';
  },
  setSearch: function (search) {
    search = $toString(search);
    if (search == '') {
      this.query = null;
    } else {
      if ('?' == charAt(search, 0)) search = stringSlice(search, 1);
      this.query = '';
      this.parse(search, QUERY);
    }
    this.searchParams.update();
  },
  // https://url.spec.whatwg.org/#dom-url-searchparams
  getSearchParams: function () {
    return this.searchParams.facade;
  },
  // https://url.spec.whatwg.org/#dom-url-hash
  getHash: function () {
    var fragment = this.fragment;
    return fragment ? '#' + fragment : '';
  },
  setHash: function (hash) {
    hash = $toString(hash);
    if (hash == '') {
      this.fragment = null;
      return;
    }
    if ('#' == charAt(hash, 0)) hash = stringSlice(hash, 1);
    this.fragment = '';
    this.parse(hash, FRAGMENT);
  },
  update: function () {
    this.query = this.searchParams.serialize() || null;
  }
};

// `URL` constructor
// https://url.spec.whatwg.org/#url-class
var URLConstructor = function URL(url /* , base */) {
  var that = anInstance(this, URLPrototype);
  var base = validateArgumentsLength(arguments.length, 1) > 1 ? arguments[1] : undefined;
  var state = setInternalState(that, new URLState(url, false, base));
  if (!DESCRIPTORS) {
    that.href = state.serialize();
    that.origin = state.getOrigin();
    that.protocol = state.getProtocol();
    that.username = state.getUsername();
    that.password = state.getPassword();
    that.host = state.getHost();
    that.hostname = state.getHostname();
    that.port = state.getPort();
    that.pathname = state.getPathname();
    that.search = state.getSearch();
    that.searchParams = state.getSearchParams();
    that.hash = state.getHash();
  }
};

var URLPrototype = URLConstructor.prototype;

var accessorDescriptor = function (getter, setter) {
  return {
    get: function () {
      return getInternalURLState(this)[getter]();
    },
    set: setter && function (value) {
      return getInternalURLState(this)[setter](value);
    },
    configurable: true,
    enumerable: true
  };
};

if (DESCRIPTORS) {
  defineProperties(URLPrototype, {
    // `URL.prototype.href` accessors pair
    // https://url.spec.whatwg.org/#dom-url-href
    href: accessorDescriptor('serialize', 'setHref'),
    // `URL.prototype.origin` getter
    // https://url.spec.whatwg.org/#dom-url-origin
    origin: accessorDescriptor('getOrigin'),
    // `URL.prototype.protocol` accessors pair
    // https://url.spec.whatwg.org/#dom-url-protocol
    protocol: accessorDescriptor('getProtocol', 'setProtocol'),
    // `URL.prototype.username` accessors pair
    // https://url.spec.whatwg.org/#dom-url-username
    username: accessorDescriptor('getUsername', 'setUsername'),
    // `URL.prototype.password` accessors pair
    // https://url.spec.whatwg.org/#dom-url-password
    password: accessorDescriptor('getPassword', 'setPassword'),
    // `URL.prototype.host` accessors pair
    // https://url.spec.whatwg.org/#dom-url-host
    host: accessorDescriptor('getHost', 'setHost'),
    // `URL.prototype.hostname` accessors pair
    // https://url.spec.whatwg.org/#dom-url-hostname
    hostname: accessorDescriptor('getHostname', 'setHostname'),
    // `URL.prototype.port` accessors pair
    // https://url.spec.whatwg.org/#dom-url-port
    port: accessorDescriptor('getPort', 'setPort'),
    // `URL.prototype.pathname` accessors pair
    // https://url.spec.whatwg.org/#dom-url-pathname
    pathname: accessorDescriptor('getPathname', 'setPathname'),
    // `URL.prototype.search` accessors pair
    // https://url.spec.whatwg.org/#dom-url-search
    search: accessorDescriptor('getSearch', 'setSearch'),
    // `URL.prototype.searchParams` getter
    // https://url.spec.whatwg.org/#dom-url-searchparams
    searchParams: accessorDescriptor('getSearchParams'),
    // `URL.prototype.hash` accessors pair
    // https://url.spec.whatwg.org/#dom-url-hash
    hash: accessorDescriptor('getHash', 'setHash')
  });
}

// `URL.prototype.toJSON` method
// https://url.spec.whatwg.org/#dom-url-tojson
redefine(URLPrototype, 'toJSON', function toJSON() {
  return getInternalURLState(this).serialize();
}, { enumerable: true });

// `URL.prototype.toString` method
// https://url.spec.whatwg.org/#URL-stringification-behavior
redefine(URLPrototype, 'toString', function toString() {
  return getInternalURLState(this).serialize();
}, { enumerable: true });

if (NativeURL) {
  var nativeCreateObjectURL = NativeURL.createObjectURL;
  var nativeRevokeObjectURL = NativeURL.revokeObjectURL;
  // `URL.createObjectURL` method
  // https://developer.mozilla.org/en-US/docs/Web/API/URL/createObjectURL
  if (nativeCreateObjectURL) redefine(URLConstructor, 'createObjectURL', bind(nativeCreateObjectURL, NativeURL));
  // `URL.revokeObjectURL` method
  // https://developer.mozilla.org/en-US/docs/Web/API/URL/revokeObjectURL
  if (nativeRevokeObjectURL) redefine(URLConstructor, 'revokeObjectURL', bind(nativeRevokeObjectURL, NativeURL));
}

setToStringTag(URLConstructor, 'URL');

$({ global: true, forced: !USE_NATIVE_URL, sham: !DESCRIPTORS }, {
  URL: URLConstructor
});


/***/ }),

/***/ 3753:
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

"use strict";

var $ = __webpack_require__(2109);
var call = __webpack_require__(6916);

// `URL.prototype.toJSON` method
// https://url.spec.whatwg.org/#dom-url-tojson
$({ target: 'URL', proto: true, enumerable: true }, {
  toJSON: function toJSON() {
    return call(URL.prototype.toString, this);
  }
});


/***/ }),

/***/ 1150:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

var parent = __webpack_require__(7633);
__webpack_require__(3948);

module.exports = parent;


/***/ }),

/***/ 6337:
/***/ (function(module, __unused_webpack_exports, __webpack_require__) {

__webpack_require__(5505);
__webpack_require__(7479);
__webpack_require__(4747);
__webpack_require__(3948);
__webpack_require__(7714);
__webpack_require__(2801);
__webpack_require__(1174);
__webpack_require__(4633);
__webpack_require__(5844);
__webpack_require__(1295);
__webpack_require__(2564);
__webpack_require__(285);
__webpack_require__(3753);
__webpack_require__(1637);
var path = __webpack_require__(857);

module.exports = path;


/***/ }),

/***/ 6834:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;
// istanbul ignore next

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

// istanbul ignore next

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } else { var newObj = {}; if (obj != null) { for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) newObj[key] = obj[key]; } } newObj['default'] = obj; return newObj; } }

var _handlebarsBase = __webpack_require__(2067);

var base = _interopRequireWildcard(_handlebarsBase);

// Each of these augment the Handlebars object. No need to setup here.
// (This is done to easily share code between commonjs and browse envs)

var _handlebarsSafeString = __webpack_require__(5558);

var _handlebarsSafeString2 = _interopRequireDefault(_handlebarsSafeString);

var _handlebarsException = __webpack_require__(8728);

var _handlebarsException2 = _interopRequireDefault(_handlebarsException);

var _handlebarsUtils = __webpack_require__(2392);

var Utils = _interopRequireWildcard(_handlebarsUtils);

var _handlebarsRuntime = __webpack_require__(1628);

var runtime = _interopRequireWildcard(_handlebarsRuntime);

var _handlebarsNoConflict = __webpack_require__(3982);

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

exports["default"] = inst;
module.exports = exports['default'];
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uL2xpYi9oYW5kbGViYXJzLnJ1bnRpbWUuanMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7OEJBQXNCLG1CQUFtQjs7SUFBN0IsSUFBSTs7Ozs7b0NBSU8sMEJBQTBCOzs7O21DQUMzQix3QkFBd0I7Ozs7K0JBQ3ZCLG9CQUFvQjs7SUFBL0IsS0FBSzs7aUNBQ1Esc0JBQXNCOztJQUFuQyxPQUFPOztvQ0FFSSwwQkFBMEI7Ozs7O0FBR2pELFNBQVMsTUFBTSxHQUFHO0FBQ2hCLE1BQUksRUFBRSxHQUFHLElBQUksSUFBSSxDQUFDLHFCQUFxQixFQUFFLENBQUM7O0FBRTFDLE9BQUssQ0FBQyxNQUFNLENBQUMsRUFBRSxFQUFFLElBQUksQ0FBQyxDQUFDO0FBQ3ZCLElBQUUsQ0FBQyxVQUFVLG9DQUFhLENBQUM7QUFDM0IsSUFBRSxDQUFDLFNBQVMsbUNBQVksQ0FBQztBQUN6QixJQUFFLENBQUMsS0FBSyxHQUFHLEtBQUssQ0FBQztBQUNqQixJQUFFLENBQUMsZ0JBQWdCLEdBQUcsS0FBSyxDQUFDLGdCQUFnQixDQUFDOztBQUU3QyxJQUFFLENBQUMsRUFBRSxHQUFHLE9BQU8sQ0FBQztBQUNoQixJQUFFLENBQUMsUUFBUSxHQUFHLFVBQVMsSUFBSSxFQUFFO0FBQzNCLFdBQU8sT0FBTyxDQUFDLFFBQVEsQ0FBQyxJQUFJLEVBQUUsRUFBRSxDQUFDLENBQUM7R0FDbkMsQ0FBQzs7QUFFRixTQUFPLEVBQUUsQ0FBQztDQUNYOztBQUVELElBQUksSUFBSSxHQUFHLE1BQU0sRUFBRSxDQUFDO0FBQ3BCLElBQUksQ0FBQyxNQUFNLEdBQUcsTUFBTSxDQUFDOztBQUVyQixrQ0FBVyxJQUFJLENBQUMsQ0FBQzs7QUFFakIsSUFBSSxDQUFDLFNBQVMsQ0FBQyxHQUFHLElBQUksQ0FBQzs7cUJBRVIsSUFBSSIsImZpbGUiOiJoYW5kbGViYXJzLnJ1bnRpbWUuanMiLCJzb3VyY2VzQ29udGVudCI6WyJpbXBvcnQgKiBhcyBiYXNlIGZyb20gJy4vaGFuZGxlYmFycy9iYXNlJztcblxuLy8gRWFjaCBvZiB0aGVzZSBhdWdtZW50IHRoZSBIYW5kbGViYXJzIG9iamVjdC4gTm8gbmVlZCB0byBzZXR1cCBoZXJlLlxuLy8gKFRoaXMgaXMgZG9uZSB0byBlYXNpbHkgc2hhcmUgY29kZSBiZXR3ZWVuIGNvbW1vbmpzIGFuZCBicm93c2UgZW52cylcbmltcG9ydCBTYWZlU3RyaW5nIGZyb20gJy4vaGFuZGxlYmFycy9zYWZlLXN0cmluZyc7XG5pbXBvcnQgRXhjZXB0aW9uIGZyb20gJy4vaGFuZGxlYmFycy9leGNlcHRpb24nO1xuaW1wb3J0ICogYXMgVXRpbHMgZnJvbSAnLi9oYW5kbGViYXJzL3V0aWxzJztcbmltcG9ydCAqIGFzIHJ1bnRpbWUgZnJvbSAnLi9oYW5kbGViYXJzL3J1bnRpbWUnO1xuXG5pbXBvcnQgbm9Db25mbGljdCBmcm9tICcuL2hhbmRsZWJhcnMvbm8tY29uZmxpY3QnO1xuXG4vLyBGb3IgY29tcGF0aWJpbGl0eSBhbmQgdXNhZ2Ugb3V0c2lkZSBvZiBtb2R1bGUgc3lzdGVtcywgbWFrZSB0aGUgSGFuZGxlYmFycyBvYmplY3QgYSBuYW1lc3BhY2VcbmZ1bmN0aW9uIGNyZWF0ZSgpIHtcbiAgbGV0IGhiID0gbmV3IGJhc2UuSGFuZGxlYmFyc0Vudmlyb25tZW50KCk7XG5cbiAgVXRpbHMuZXh0ZW5kKGhiLCBiYXNlKTtcbiAgaGIuU2FmZVN0cmluZyA9IFNhZmVTdHJpbmc7XG4gIGhiLkV4Y2VwdGlvbiA9IEV4Y2VwdGlvbjtcbiAgaGIuVXRpbHMgPSBVdGlscztcbiAgaGIuZXNjYXBlRXhwcmVzc2lvbiA9IFV0aWxzLmVzY2FwZUV4cHJlc3Npb247XG5cbiAgaGIuVk0gPSBydW50aW1lO1xuICBoYi50ZW1wbGF0ZSA9IGZ1bmN0aW9uKHNwZWMpIHtcbiAgICByZXR1cm4gcnVudGltZS50ZW1wbGF0ZShzcGVjLCBoYik7XG4gIH07XG5cbiAgcmV0dXJuIGhiO1xufVxuXG5sZXQgaW5zdCA9IGNyZWF0ZSgpO1xuaW5zdC5jcmVhdGUgPSBjcmVhdGU7XG5cbm5vQ29uZmxpY3QoaW5zdCk7XG5cbmluc3RbJ2RlZmF1bHQnXSA9IGluc3Q7XG5cbmV4cG9ydCBkZWZhdWx0IGluc3Q7XG4iXX0=


/***/ }),

/***/ 2067:
/***/ (function(__unused_webpack_module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;
exports.HandlebarsEnvironment = HandlebarsEnvironment;
// istanbul ignore next

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

var _utils = __webpack_require__(2392);

var _exception = __webpack_require__(8728);

var _exception2 = _interopRequireDefault(_exception);

var _helpers = __webpack_require__(2638);

var _decorators = __webpack_require__(881);

var _logger = __webpack_require__(8037);

var _logger2 = _interopRequireDefault(_logger);

var _internalProtoAccess = __webpack_require__(6293);

var VERSION = '4.7.7';
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
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL2Jhc2UuanMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7cUJBQThDLFNBQVM7O3lCQUNqQyxhQUFhOzs7O3VCQUNJLFdBQVc7OzBCQUNSLGNBQWM7O3NCQUNyQyxVQUFVOzs7O21DQUNTLHlCQUF5Qjs7QUFFeEQsSUFBTSxPQUFPLEdBQUcsT0FBTyxDQUFDOztBQUN4QixJQUFNLGlCQUFpQixHQUFHLENBQUMsQ0FBQzs7QUFDNUIsSUFBTSxpQ0FBaUMsR0FBRyxDQUFDLENBQUM7OztBQUU1QyxJQUFNLGdCQUFnQixHQUFHO0FBQzlCLEdBQUMsRUFBRSxhQUFhO0FBQ2hCLEdBQUMsRUFBRSxlQUFlO0FBQ2xCLEdBQUMsRUFBRSxlQUFlO0FBQ2xCLEdBQUMsRUFBRSxVQUFVO0FBQ2IsR0FBQyxFQUFFLGtCQUFrQjtBQUNyQixHQUFDLEVBQUUsaUJBQWlCO0FBQ3BCLEdBQUMsRUFBRSxpQkFBaUI7QUFDcEIsR0FBQyxFQUFFLFVBQVU7Q0FDZCxDQUFDOzs7QUFFRixJQUFNLFVBQVUsR0FBRyxpQkFBaUIsQ0FBQzs7QUFFOUIsU0FBUyxxQkFBcUIsQ0FBQyxPQUFPLEVBQUUsUUFBUSxFQUFFLFVBQVUsRUFBRTtBQUNuRSxNQUFJLENBQUMsT0FBTyxHQUFHLE9BQU8sSUFBSSxFQUFFLENBQUM7QUFDN0IsTUFBSSxDQUFDLFFBQVEsR0FBRyxRQUFRLElBQUksRUFBRSxDQUFDO0FBQy9CLE1BQUksQ0FBQyxVQUFVLEdBQUcsVUFBVSxJQUFJLEVBQUUsQ0FBQzs7QUFFbkMsa0NBQXVCLElBQUksQ0FBQyxDQUFDO0FBQzdCLHdDQUEwQixJQUFJLENBQUMsQ0FBQztDQUNqQzs7QUFFRCxxQkFBcUIsQ0FBQyxTQUFTLEdBQUc7QUFDaEMsYUFBVyxFQUFFLHFCQUFxQjs7QUFFbEMsUUFBTSxxQkFBUTtBQUNkLEtBQUcsRUFBRSxvQkFBTyxHQUFHOztBQUVmLGdCQUFjLEVBQUUsd0JBQVMsSUFBSSxFQUFFLEVBQUUsRUFBRTtBQUNqQyxRQUFJLGdCQUFTLElBQUksQ0FBQyxJQUFJLENBQUMsS0FBSyxVQUFVLEVBQUU7QUFDdEMsVUFBSSxFQUFFLEVBQUU7QUFDTixjQUFNLDJCQUFjLHlDQUF5QyxDQUFDLENBQUM7T0FDaEU7QUFDRCxvQkFBTyxJQUFJLENBQUMsT0FBTyxFQUFFLElBQUksQ0FBQyxDQUFDO0tBQzVCLE1BQU07QUFDTCxVQUFJLENBQUMsT0FBTyxDQUFDLElBQUksQ0FBQyxHQUFHLEVBQUUsQ0FBQztLQUN6QjtHQUNGO0FBQ0Qsa0JBQWdCLEVBQUUsMEJBQVMsSUFBSSxFQUFFO0FBQy9CLFdBQU8sSUFBSSxDQUFDLE9BQU8sQ0FBQyxJQUFJLENBQUMsQ0FBQztHQUMzQjs7QUFFRCxpQkFBZSxFQUFFLHlCQUFTLElBQUksRUFBRSxPQUFPLEVBQUU7QUFDdkMsUUFBSSxnQkFBUyxJQUFJLENBQUMsSUFBSSxDQUFDLEtBQUssVUFBVSxFQUFFO0FBQ3RDLG9CQUFPLElBQUksQ0FBQyxRQUFRLEVBQUUsSUFBSSxDQUFDLENBQUM7S0FDN0IsTUFBTTtBQUNMLFVBQUksT0FBTyxPQUFPLEtBQUssV0FBVyxFQUFFO0FBQ2xDLGNBQU0seUVBQ3dDLElBQUksb0JBQ2pELENBQUM7T0FDSDtBQUNELFVBQUksQ0FBQyxRQUFRLENBQUMsSUFBSSxDQUFDLEdBQUcsT0FBTyxDQUFDO0tBQy9CO0dBQ0Y7QUFDRCxtQkFBaUIsRUFBRSwyQkFBUyxJQUFJLEVBQUU7QUFDaEMsV0FBTyxJQUFJLENBQUMsUUFBUSxDQUFDLElBQUksQ0FBQyxDQUFDO0dBQzVCOztBQUVELG1CQUFpQixFQUFFLDJCQUFTLElBQUksRUFBRSxFQUFFLEVBQUU7QUFDcEMsUUFBSSxnQkFBUyxJQUFJLENBQUMsSUFBSSxDQUFDLEtBQUssVUFBVSxFQUFFO0FBQ3RDLFVBQUksRUFBRSxFQUFFO0FBQ04sY0FBTSwyQkFBYyw0Q0FBNEMsQ0FBQyxDQUFDO09BQ25FO0FBQ0Qsb0JBQU8sSUFBSSxDQUFDLFVBQVUsRUFBRSxJQUFJLENBQUMsQ0FBQztLQUMvQixNQUFNO0FBQ0wsVUFBSSxDQUFDLFVBQVUsQ0FBQyxJQUFJLENBQUMsR0FBRyxFQUFFLENBQUM7S0FDNUI7R0FDRjtBQUNELHFCQUFtQixFQUFFLDZCQUFTLElBQUksRUFBRTtBQUNsQyxXQUFPLElBQUksQ0FBQyxVQUFVLENBQUMsSUFBSSxDQUFDLENBQUM7R0FDOUI7Ozs7O0FBS0QsNkJBQTJCLEVBQUEsdUNBQUc7QUFDNUIsZ0RBQXVCLENBQUM7R0FDekI7Q0FDRixDQUFDOztBQUVLLElBQUksR0FBRyxHQUFHLG9CQUFPLEdBQUcsQ0FBQzs7O1FBRW5CLFdBQVc7UUFBRSxNQUFNIiwiZmlsZSI6ImJhc2UuanMiLCJzb3VyY2VzQ29udGVudCI6WyJpbXBvcnQgeyBjcmVhdGVGcmFtZSwgZXh0ZW5kLCB0b1N0cmluZyB9IGZyb20gJy4vdXRpbHMnO1xuaW1wb3J0IEV4Y2VwdGlvbiBmcm9tICcuL2V4Y2VwdGlvbic7XG5pbXBvcnQgeyByZWdpc3RlckRlZmF1bHRIZWxwZXJzIH0gZnJvbSAnLi9oZWxwZXJzJztcbmltcG9ydCB7IHJlZ2lzdGVyRGVmYXVsdERlY29yYXRvcnMgfSBmcm9tICcuL2RlY29yYXRvcnMnO1xuaW1wb3J0IGxvZ2dlciBmcm9tICcuL2xvZ2dlcic7XG5pbXBvcnQgeyByZXNldExvZ2dlZFByb3BlcnRpZXMgfSBmcm9tICcuL2ludGVybmFsL3Byb3RvLWFjY2Vzcyc7XG5cbmV4cG9ydCBjb25zdCBWRVJTSU9OID0gJzQuNy43JztcbmV4cG9ydCBjb25zdCBDT01QSUxFUl9SRVZJU0lPTiA9IDg7XG5leHBvcnQgY29uc3QgTEFTVF9DT01QQVRJQkxFX0NPTVBJTEVSX1JFVklTSU9OID0gNztcblxuZXhwb3J0IGNvbnN0IFJFVklTSU9OX0NIQU5HRVMgPSB7XG4gIDE6ICc8PSAxLjAucmMuMicsIC8vIDEuMC5yYy4yIGlzIGFjdHVhbGx5IHJldjIgYnV0IGRvZXNuJ3QgcmVwb3J0IGl0XG4gIDI6ICc9PSAxLjAuMC1yYy4zJyxcbiAgMzogJz09IDEuMC4wLXJjLjQnLFxuICA0OiAnPT0gMS54LngnLFxuICA1OiAnPT0gMi4wLjAtYWxwaGEueCcsXG4gIDY6ICc+PSAyLjAuMC1iZXRhLjEnLFxuICA3OiAnPj0gNC4wLjAgPDQuMy4wJyxcbiAgODogJz49IDQuMy4wJ1xufTtcblxuY29uc3Qgb2JqZWN0VHlwZSA9ICdbb2JqZWN0IE9iamVjdF0nO1xuXG5leHBvcnQgZnVuY3Rpb24gSGFuZGxlYmFyc0Vudmlyb25tZW50KGhlbHBlcnMsIHBhcnRpYWxzLCBkZWNvcmF0b3JzKSB7XG4gIHRoaXMuaGVscGVycyA9IGhlbHBlcnMgfHwge307XG4gIHRoaXMucGFydGlhbHMgPSBwYXJ0aWFscyB8fCB7fTtcbiAgdGhpcy5kZWNvcmF0b3JzID0gZGVjb3JhdG9ycyB8fCB7fTtcblxuICByZWdpc3RlckRlZmF1bHRIZWxwZXJzKHRoaXMpO1xuICByZWdpc3RlckRlZmF1bHREZWNvcmF0b3JzKHRoaXMpO1xufVxuXG5IYW5kbGViYXJzRW52aXJvbm1lbnQucHJvdG90eXBlID0ge1xuICBjb25zdHJ1Y3RvcjogSGFuZGxlYmFyc0Vudmlyb25tZW50LFxuXG4gIGxvZ2dlcjogbG9nZ2VyLFxuICBsb2c6IGxvZ2dlci5sb2csXG5cbiAgcmVnaXN0ZXJIZWxwZXI6IGZ1bmN0aW9uKG5hbWUsIGZuKSB7XG4gICAgaWYgKHRvU3RyaW5nLmNhbGwobmFtZSkgPT09IG9iamVjdFR5cGUpIHtcbiAgICAgIGlmIChmbikge1xuICAgICAgICB0aHJvdyBuZXcgRXhjZXB0aW9uKCdBcmcgbm90IHN1cHBvcnRlZCB3aXRoIG11bHRpcGxlIGhlbHBlcnMnKTtcbiAgICAgIH1cbiAgICAgIGV4dGVuZCh0aGlzLmhlbHBlcnMsIG5hbWUpO1xuICAgIH0gZWxzZSB7XG4gICAgICB0aGlzLmhlbHBlcnNbbmFtZV0gPSBmbjtcbiAgICB9XG4gIH0sXG4gIHVucmVnaXN0ZXJIZWxwZXI6IGZ1bmN0aW9uKG5hbWUpIHtcbiAgICBkZWxldGUgdGhpcy5oZWxwZXJzW25hbWVdO1xuICB9LFxuXG4gIHJlZ2lzdGVyUGFydGlhbDogZnVuY3Rpb24obmFtZSwgcGFydGlhbCkge1xuICAgIGlmICh0b1N0cmluZy5jYWxsKG5hbWUpID09PSBvYmplY3RUeXBlKSB7XG4gICAgICBleHRlbmQodGhpcy5wYXJ0aWFscywgbmFtZSk7XG4gICAgfSBlbHNlIHtcbiAgICAgIGlmICh0eXBlb2YgcGFydGlhbCA9PT0gJ3VuZGVmaW5lZCcpIHtcbiAgICAgICAgdGhyb3cgbmV3IEV4Y2VwdGlvbihcbiAgICAgICAgICBgQXR0ZW1wdGluZyB0byByZWdpc3RlciBhIHBhcnRpYWwgY2FsbGVkIFwiJHtuYW1lfVwiIGFzIHVuZGVmaW5lZGBcbiAgICAgICAgKTtcbiAgICAgIH1cbiAgICAgIHRoaXMucGFydGlhbHNbbmFtZV0gPSBwYXJ0aWFsO1xuICAgIH1cbiAgfSxcbiAgdW5yZWdpc3RlclBhcnRpYWw6IGZ1bmN0aW9uKG5hbWUpIHtcbiAgICBkZWxldGUgdGhpcy5wYXJ0aWFsc1tuYW1lXTtcbiAgfSxcblxuICByZWdpc3RlckRlY29yYXRvcjogZnVuY3Rpb24obmFtZSwgZm4pIHtcbiAgICBpZiAodG9TdHJpbmcuY2FsbChuYW1lKSA9PT0gb2JqZWN0VHlwZSkge1xuICAgICAgaWYgKGZuKSB7XG4gICAgICAgIHRocm93IG5ldyBFeGNlcHRpb24oJ0FyZyBub3Qgc3VwcG9ydGVkIHdpdGggbXVsdGlwbGUgZGVjb3JhdG9ycycpO1xuICAgICAgfVxuICAgICAgZXh0ZW5kKHRoaXMuZGVjb3JhdG9ycywgbmFtZSk7XG4gICAgfSBlbHNlIHtcbiAgICAgIHRoaXMuZGVjb3JhdG9yc1tuYW1lXSA9IGZuO1xuICAgIH1cbiAgfSxcbiAgdW5yZWdpc3RlckRlY29yYXRvcjogZnVuY3Rpb24obmFtZSkge1xuICAgIGRlbGV0ZSB0aGlzLmRlY29yYXRvcnNbbmFtZV07XG4gIH0sXG4gIC8qKlxuICAgKiBSZXNldCB0aGUgbWVtb3J5IG9mIGlsbGVnYWwgcHJvcGVydHkgYWNjZXNzZXMgdGhhdCBoYXZlIGFscmVhZHkgYmVlbiBsb2dnZWQuXG4gICAqIEBkZXByZWNhdGVkIHNob3VsZCBvbmx5IGJlIHVzZWQgaW4gaGFuZGxlYmFycyB0ZXN0LWNhc2VzXG4gICAqL1xuICByZXNldExvZ2dlZFByb3BlcnR5QWNjZXNzZXMoKSB7XG4gICAgcmVzZXRMb2dnZWRQcm9wZXJ0aWVzKCk7XG4gIH1cbn07XG5cbmV4cG9ydCBsZXQgbG9nID0gbG9nZ2VyLmxvZztcblxuZXhwb3J0IHsgY3JlYXRlRnJhbWUsIGxvZ2dlciB9O1xuIl19


/***/ }),

/***/ 881:
/***/ (function(__unused_webpack_module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;
exports.registerDefaultDecorators = registerDefaultDecorators;
// istanbul ignore next

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

var _decoratorsInline = __webpack_require__(5670);

var _decoratorsInline2 = _interopRequireDefault(_decoratorsInline);

function registerDefaultDecorators(instance) {
  _decoratorsInline2['default'](instance);
}
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL2RlY29yYXRvcnMuanMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Z0NBQTJCLHFCQUFxQjs7OztBQUV6QyxTQUFTLHlCQUF5QixDQUFDLFFBQVEsRUFBRTtBQUNsRCxnQ0FBZSxRQUFRLENBQUMsQ0FBQztDQUMxQiIsImZpbGUiOiJkZWNvcmF0b3JzLmpzIiwic291cmNlc0NvbnRlbnQiOlsiaW1wb3J0IHJlZ2lzdGVySW5saW5lIGZyb20gJy4vZGVjb3JhdG9ycy9pbmxpbmUnO1xuXG5leHBvcnQgZnVuY3Rpb24gcmVnaXN0ZXJEZWZhdWx0RGVjb3JhdG9ycyhpbnN0YW5jZSkge1xuICByZWdpc3RlcklubGluZShpbnN0YW5jZSk7XG59XG4iXX0=


/***/ }),

/***/ 5670:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;

var _utils = __webpack_require__(2392);

exports["default"] = function (instance) {
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

/***/ 8728:
/***/ (function(module, exports) {

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

exports["default"] = Exception;
module.exports = exports['default'];
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL2V4Y2VwdGlvbi5qcyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOzs7QUFBQSxJQUFNLFVBQVUsR0FBRyxDQUNqQixhQUFhLEVBQ2IsVUFBVSxFQUNWLFlBQVksRUFDWixlQUFlLEVBQ2YsU0FBUyxFQUNULE1BQU0sRUFDTixRQUFRLEVBQ1IsT0FBTyxDQUNSLENBQUM7O0FBRUYsU0FBUyxTQUFTLENBQUMsT0FBTyxFQUFFLElBQUksRUFBRTtBQUNoQyxNQUFJLEdBQUcsR0FBRyxJQUFJLElBQUksSUFBSSxDQUFDLEdBQUc7TUFDeEIsSUFBSSxZQUFBO01BQ0osYUFBYSxZQUFBO01BQ2IsTUFBTSxZQUFBO01BQ04sU0FBUyxZQUFBLENBQUM7O0FBRVosTUFBSSxHQUFHLEVBQUU7QUFDUCxRQUFJLEdBQUcsR0FBRyxDQUFDLEtBQUssQ0FBQyxJQUFJLENBQUM7QUFDdEIsaUJBQWEsR0FBRyxHQUFHLENBQUMsR0FBRyxDQUFDLElBQUksQ0FBQztBQUM3QixVQUFNLEdBQUcsR0FBRyxDQUFDLEtBQUssQ0FBQyxNQUFNLENBQUM7QUFDMUIsYUFBUyxHQUFHLEdBQUcsQ0FBQyxHQUFHLENBQUMsTUFBTSxDQUFDOztBQUUzQixXQUFPLElBQUksS0FBSyxHQUFHLElBQUksR0FBRyxHQUFHLEdBQUcsTUFBTSxDQUFDO0dBQ3hDOztBQUVELE1BQUksR0FBRyxHQUFHLEtBQUssQ0FBQyxTQUFTLENBQUMsV0FBVyxDQUFDLElBQUksQ0FBQyxJQUFJLEVBQUUsT0FBTyxDQUFDLENBQUM7OztBQUcxRCxPQUFLLElBQUksR0FBRyxHQUFHLENBQUMsRUFBRSxHQUFHLEdBQUcsVUFBVSxDQUFDLE1BQU0sRUFBRSxHQUFHLEVBQUUsRUFBRTtBQUNoRCxRQUFJLENBQUMsVUFBVSxDQUFDLEdBQUcsQ0FBQyxDQUFDLEdBQUcsR0FBRyxDQUFDLFVBQVUsQ0FBQyxHQUFHLENBQUMsQ0FBQyxDQUFDO0dBQzlDOzs7QUFHRCxNQUFJLEtBQUssQ0FBQyxpQkFBaUIsRUFBRTtBQUMzQixTQUFLLENBQUMsaUJBQWlCLENBQUMsSUFBSSxFQUFFLFNBQVMsQ0FBQyxDQUFDO0dBQzFDOztBQUVELE1BQUk7QUFDRixRQUFJLEdBQUcsRUFBRTtBQUNQLFVBQUksQ0FBQyxVQUFVLEdBQUcsSUFBSSxDQUFDO0FBQ3ZCLFVBQUksQ0FBQyxhQUFhLEdBQUcsYUFBYSxDQUFDOzs7O0FBSW5DLFVBQUksTUFBTSxDQUFDLGNBQWMsRUFBRTtBQUN6QixjQUFNLENBQUMsY0FBYyxDQUFDLElBQUksRUFBRSxRQUFRLEVBQUU7QUFDcEMsZUFBSyxFQUFFLE1BQU07QUFDYixvQkFBVSxFQUFFLElBQUk7U0FDakIsQ0FBQyxDQUFDO0FBQ0gsY0FBTSxDQUFDLGNBQWMsQ0FBQyxJQUFJLEVBQUUsV0FBVyxFQUFFO0FBQ3ZDLGVBQUssRUFBRSxTQUFTO0FBQ2hCLG9CQUFVLEVBQUUsSUFBSTtTQUNqQixDQUFDLENBQUM7T0FDSixNQUFNO0FBQ0wsWUFBSSxDQUFDLE1BQU0sR0FBRyxNQUFNLENBQUM7QUFDckIsWUFBSSxDQUFDLFNBQVMsR0FBRyxTQUFTLENBQUM7T0FDNUI7S0FDRjtHQUNGLENBQUMsT0FBTyxHQUFHLEVBQUU7O0dBRWI7Q0FDRjs7QUFFRCxTQUFTLENBQUMsU0FBUyxHQUFHLElBQUksS0FBSyxFQUFFLENBQUM7O3FCQUVuQixTQUFTIiwiZmlsZSI6ImV4Y2VwdGlvbi5qcyIsInNvdXJjZXNDb250ZW50IjpbImNvbnN0IGVycm9yUHJvcHMgPSBbXG4gICdkZXNjcmlwdGlvbicsXG4gICdmaWxlTmFtZScsXG4gICdsaW5lTnVtYmVyJyxcbiAgJ2VuZExpbmVOdW1iZXInLFxuICAnbWVzc2FnZScsXG4gICduYW1lJyxcbiAgJ251bWJlcicsXG4gICdzdGFjaydcbl07XG5cbmZ1bmN0aW9uIEV4Y2VwdGlvbihtZXNzYWdlLCBub2RlKSB7XG4gIGxldCBsb2MgPSBub2RlICYmIG5vZGUubG9jLFxuICAgIGxpbmUsXG4gICAgZW5kTGluZU51bWJlcixcbiAgICBjb2x1bW4sXG4gICAgZW5kQ29sdW1uO1xuXG4gIGlmIChsb2MpIHtcbiAgICBsaW5lID0gbG9jLnN0YXJ0LmxpbmU7XG4gICAgZW5kTGluZU51bWJlciA9IGxvYy5lbmQubGluZTtcbiAgICBjb2x1bW4gPSBsb2Muc3RhcnQuY29sdW1uO1xuICAgIGVuZENvbHVtbiA9IGxvYy5lbmQuY29sdW1uO1xuXG4gICAgbWVzc2FnZSArPSAnIC0gJyArIGxpbmUgKyAnOicgKyBjb2x1bW47XG4gIH1cblxuICBsZXQgdG1wID0gRXJyb3IucHJvdG90eXBlLmNvbnN0cnVjdG9yLmNhbGwodGhpcywgbWVzc2FnZSk7XG5cbiAgLy8gVW5mb3J0dW5hdGVseSBlcnJvcnMgYXJlIG5vdCBlbnVtZXJhYmxlIGluIENocm9tZSAoYXQgbGVhc3QpLCBzbyBgZm9yIHByb3AgaW4gdG1wYCBkb2Vzbid0IHdvcmsuXG4gIGZvciAobGV0IGlkeCA9IDA7IGlkeCA8IGVycm9yUHJvcHMubGVuZ3RoOyBpZHgrKykge1xuICAgIHRoaXNbZXJyb3JQcm9wc1tpZHhdXSA9IHRtcFtlcnJvclByb3BzW2lkeF1dO1xuICB9XG5cbiAgLyogaXN0YW5idWwgaWdub3JlIGVsc2UgKi9cbiAgaWYgKEVycm9yLmNhcHR1cmVTdGFja1RyYWNlKSB7XG4gICAgRXJyb3IuY2FwdHVyZVN0YWNrVHJhY2UodGhpcywgRXhjZXB0aW9uKTtcbiAgfVxuXG4gIHRyeSB7XG4gICAgaWYgKGxvYykge1xuICAgICAgdGhpcy5saW5lTnVtYmVyID0gbGluZTtcbiAgICAgIHRoaXMuZW5kTGluZU51bWJlciA9IGVuZExpbmVOdW1iZXI7XG5cbiAgICAgIC8vIFdvcmsgYXJvdW5kIGlzc3VlIHVuZGVyIHNhZmFyaSB3aGVyZSB3ZSBjYW4ndCBkaXJlY3RseSBzZXQgdGhlIGNvbHVtbiB2YWx1ZVxuICAgICAgLyogaXN0YW5idWwgaWdub3JlIG5leHQgKi9cbiAgICAgIGlmIChPYmplY3QuZGVmaW5lUHJvcGVydHkpIHtcbiAgICAgICAgT2JqZWN0LmRlZmluZVByb3BlcnR5KHRoaXMsICdjb2x1bW4nLCB7XG4gICAgICAgICAgdmFsdWU6IGNvbHVtbixcbiAgICAgICAgICBlbnVtZXJhYmxlOiB0cnVlXG4gICAgICAgIH0pO1xuICAgICAgICBPYmplY3QuZGVmaW5lUHJvcGVydHkodGhpcywgJ2VuZENvbHVtbicsIHtcbiAgICAgICAgICB2YWx1ZTogZW5kQ29sdW1uLFxuICAgICAgICAgIGVudW1lcmFibGU6IHRydWVcbiAgICAgICAgfSk7XG4gICAgICB9IGVsc2Uge1xuICAgICAgICB0aGlzLmNvbHVtbiA9IGNvbHVtbjtcbiAgICAgICAgdGhpcy5lbmRDb2x1bW4gPSBlbmRDb2x1bW47XG4gICAgICB9XG4gICAgfVxuICB9IGNhdGNoIChub3ApIHtcbiAgICAvKiBJZ25vcmUgaWYgdGhlIGJyb3dzZXIgaXMgdmVyeSBwYXJ0aWN1bGFyICovXG4gIH1cbn1cblxuRXhjZXB0aW9uLnByb3RvdHlwZSA9IG5ldyBFcnJvcigpO1xuXG5leHBvcnQgZGVmYXVsdCBFeGNlcHRpb247XG4iXX0=


/***/ }),

/***/ 2638:
/***/ (function(__unused_webpack_module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;
exports.registerDefaultHelpers = registerDefaultHelpers;
exports.moveHelperToHooks = moveHelperToHooks;
// istanbul ignore next

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

var _helpersBlockHelperMissing = __webpack_require__(7342);

var _helpersBlockHelperMissing2 = _interopRequireDefault(_helpersBlockHelperMissing);

var _helpersEach = __webpack_require__(6822);

var _helpersEach2 = _interopRequireDefault(_helpersEach);

var _helpersHelperMissing = __webpack_require__(4905);

var _helpersHelperMissing2 = _interopRequireDefault(_helpersHelperMissing);

var _helpersIf = __webpack_require__(7405);

var _helpersIf2 = _interopRequireDefault(_helpersIf);

var _helpersLog = __webpack_require__(5702);

var _helpersLog2 = _interopRequireDefault(_helpersLog);

var _helpersLookup = __webpack_require__(9709);

var _helpersLookup2 = _interopRequireDefault(_helpersLookup);

var _helpersWith = __webpack_require__(3978);

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

/***/ 7342:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;

var _utils = __webpack_require__(2392);

exports["default"] = function (instance) {
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

/***/ 6822:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;
// istanbul ignore next

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

var _utils = __webpack_require__(2392);

var _exception = __webpack_require__(8728);

var _exception2 = _interopRequireDefault(_exception);

exports["default"] = function (instance) {
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
      } else if (__webpack_require__.g.Symbol && context[__webpack_require__.g.Symbol.iterator]) {
        var newContext = [];
        var iterator = context[__webpack_require__.g.Symbol.iterator]();
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


/***/ }),

/***/ 4905:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;
// istanbul ignore next

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

var _exception = __webpack_require__(8728);

var _exception2 = _interopRequireDefault(_exception);

exports["default"] = function (instance) {
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

/***/ 7405:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;
// istanbul ignore next

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

var _utils = __webpack_require__(2392);

var _exception = __webpack_require__(8728);

var _exception2 = _interopRequireDefault(_exception);

exports["default"] = function (instance) {
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

/***/ 5702:
/***/ (function(module, exports) {

"use strict";


exports.__esModule = true;

exports["default"] = function (instance) {
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

/***/ 9709:
/***/ (function(module, exports) {

"use strict";


exports.__esModule = true;

exports["default"] = function (instance) {
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

/***/ 3978:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;
// istanbul ignore next

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

var _utils = __webpack_require__(2392);

var _exception = __webpack_require__(8728);

var _exception2 = _interopRequireDefault(_exception);

exports["default"] = function (instance) {
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

/***/ 589:
/***/ (function(__unused_webpack_module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;
exports.createNewLookupObject = createNewLookupObject;

var _utils = __webpack_require__(2392);

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

/***/ 6293:
/***/ (function(__unused_webpack_module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;
exports.createProtoAccessControl = createProtoAccessControl;
exports.resultIsAllowed = resultIsAllowed;
exports.resetLoggedProperties = resetLoggedProperties;
// istanbul ignore next

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } else { var newObj = {}; if (obj != null) { for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) newObj[key] = obj[key]; } } newObj['default'] = obj; return newObj; } }

var _createNewLookupObject = __webpack_require__(589);

var _logger = __webpack_require__(8037);

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

/***/ 7253:
/***/ (function(__unused_webpack_module, exports) {

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

/***/ 8037:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;

var _utils = __webpack_require__(2392);

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

exports["default"] = logger;
module.exports = exports['default'];
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL2xvZ2dlci5qcyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOzs7O3FCQUF3QixTQUFTOztBQUVqQyxJQUFJLE1BQU0sR0FBRztBQUNYLFdBQVMsRUFBRSxDQUFDLE9BQU8sRUFBRSxNQUFNLEVBQUUsTUFBTSxFQUFFLE9BQU8sQ0FBQztBQUM3QyxPQUFLLEVBQUUsTUFBTTs7O0FBR2IsYUFBVyxFQUFFLHFCQUFTLEtBQUssRUFBRTtBQUMzQixRQUFJLE9BQU8sS0FBSyxLQUFLLFFBQVEsRUFBRTtBQUM3QixVQUFJLFFBQVEsR0FBRyxlQUFRLE1BQU0sQ0FBQyxTQUFTLEVBQUUsS0FBSyxDQUFDLFdBQVcsRUFBRSxDQUFDLENBQUM7QUFDOUQsVUFBSSxRQUFRLElBQUksQ0FBQyxFQUFFO0FBQ2pCLGFBQUssR0FBRyxRQUFRLENBQUM7T0FDbEIsTUFBTTtBQUNMLGFBQUssR0FBRyxRQUFRLENBQUMsS0FBSyxFQUFFLEVBQUUsQ0FBQyxDQUFDO09BQzdCO0tBQ0Y7O0FBRUQsV0FBTyxLQUFLLENBQUM7R0FDZDs7O0FBR0QsS0FBRyxFQUFFLGFBQVMsS0FBSyxFQUFjO0FBQy9CLFNBQUssR0FBRyxNQUFNLENBQUMsV0FBVyxDQUFDLEtBQUssQ0FBQyxDQUFDOztBQUVsQyxRQUNFLE9BQU8sT0FBTyxLQUFLLFdBQVcsSUFDOUIsTUFBTSxDQUFDLFdBQVcsQ0FBQyxNQUFNLENBQUMsS0FBSyxDQUFDLElBQUksS0FBSyxFQUN6QztBQUNBLFVBQUksTUFBTSxHQUFHLE1BQU0sQ0FBQyxTQUFTLENBQUMsS0FBSyxDQUFDLENBQUM7O0FBRXJDLFVBQUksQ0FBQyxPQUFPLENBQUMsTUFBTSxDQUFDLEVBQUU7QUFDcEIsY0FBTSxHQUFHLEtBQUssQ0FBQztPQUNoQjs7d0NBWG1CLE9BQU87QUFBUCxlQUFPOzs7QUFZM0IsYUFBTyxDQUFDLE1BQU0sT0FBQyxDQUFmLE9BQU8sRUFBWSxPQUFPLENBQUMsQ0FBQztLQUM3QjtHQUNGO0NBQ0YsQ0FBQzs7cUJBRWEsTUFBTSIsImZpbGUiOiJsb2dnZXIuanMiLCJzb3VyY2VzQ29udGVudCI6WyJpbXBvcnQgeyBpbmRleE9mIH0gZnJvbSAnLi91dGlscyc7XG5cbmxldCBsb2dnZXIgPSB7XG4gIG1ldGhvZE1hcDogWydkZWJ1ZycsICdpbmZvJywgJ3dhcm4nLCAnZXJyb3InXSxcbiAgbGV2ZWw6ICdpbmZvJyxcblxuICAvLyBNYXBzIGEgZ2l2ZW4gbGV2ZWwgdmFsdWUgdG8gdGhlIGBtZXRob2RNYXBgIGluZGV4ZXMgYWJvdmUuXG4gIGxvb2t1cExldmVsOiBmdW5jdGlvbihsZXZlbCkge1xuICAgIGlmICh0eXBlb2YgbGV2ZWwgPT09ICdzdHJpbmcnKSB7XG4gICAgICBsZXQgbGV2ZWxNYXAgPSBpbmRleE9mKGxvZ2dlci5tZXRob2RNYXAsIGxldmVsLnRvTG93ZXJDYXNlKCkpO1xuICAgICAgaWYgKGxldmVsTWFwID49IDApIHtcbiAgICAgICAgbGV2ZWwgPSBsZXZlbE1hcDtcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIGxldmVsID0gcGFyc2VJbnQobGV2ZWwsIDEwKTtcbiAgICAgIH1cbiAgICB9XG5cbiAgICByZXR1cm4gbGV2ZWw7XG4gIH0sXG5cbiAgLy8gQ2FuIGJlIG92ZXJyaWRkZW4gaW4gdGhlIGhvc3QgZW52aXJvbm1lbnRcbiAgbG9nOiBmdW5jdGlvbihsZXZlbCwgLi4ubWVzc2FnZSkge1xuICAgIGxldmVsID0gbG9nZ2VyLmxvb2t1cExldmVsKGxldmVsKTtcblxuICAgIGlmIChcbiAgICAgIHR5cGVvZiBjb25zb2xlICE9PSAndW5kZWZpbmVkJyAmJlxuICAgICAgbG9nZ2VyLmxvb2t1cExldmVsKGxvZ2dlci5sZXZlbCkgPD0gbGV2ZWxcbiAgICApIHtcbiAgICAgIGxldCBtZXRob2QgPSBsb2dnZXIubWV0aG9kTWFwW2xldmVsXTtcbiAgICAgIC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBuby1jb25zb2xlXG4gICAgICBpZiAoIWNvbnNvbGVbbWV0aG9kXSkge1xuICAgICAgICBtZXRob2QgPSAnbG9nJztcbiAgICAgIH1cbiAgICAgIGNvbnNvbGVbbWV0aG9kXSguLi5tZXNzYWdlKTsgLy8gZXNsaW50LWRpc2FibGUtbGluZSBuby1jb25zb2xlXG4gICAgfVxuICB9XG59O1xuXG5leHBvcnQgZGVmYXVsdCBsb2dnZXI7XG4iXX0=


/***/ }),

/***/ 3982:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;

exports["default"] = function (Handlebars) {
  /* istanbul ignore next */
  var root = typeof __webpack_require__.g !== 'undefined' ? __webpack_require__.g : window,
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


/***/ }),

/***/ 1628:
/***/ (function(__unused_webpack_module, exports, __webpack_require__) {

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

var _utils = __webpack_require__(2392);

var Utils = _interopRequireWildcard(_utils);

var _exception = __webpack_require__(8728);

var _exception2 = _interopRequireDefault(_exception);

var _base = __webpack_require__(2067);

var _helpers = __webpack_require__(2638);

var _internalWrapHelper = __webpack_require__(7253);

var _internalProtoAccess = __webpack_require__(6293);

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
      return container.lookupProperty(obj, name);
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
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL3J1bnRpbWUuanMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7Ozs7cUJBQXVCLFNBQVM7O0lBQXBCLEtBQUs7O3lCQUNLLGFBQWE7Ozs7b0JBTTVCLFFBQVE7O3VCQUNtQixXQUFXOztrQ0FDbEIsdUJBQXVCOzttQ0FJM0MseUJBQXlCOztBQUV6QixTQUFTLGFBQWEsQ0FBQyxZQUFZLEVBQUU7QUFDMUMsTUFBTSxnQkFBZ0IsR0FBRyxBQUFDLFlBQVksSUFBSSxZQUFZLENBQUMsQ0FBQyxDQUFDLElBQUssQ0FBQztNQUM3RCxlQUFlLDBCQUFvQixDQUFDOztBQUV0QyxNQUNFLGdCQUFnQiwyQ0FBcUMsSUFDckQsZ0JBQWdCLDJCQUFxQixFQUNyQztBQUNBLFdBQU87R0FDUjs7QUFFRCxNQUFJLGdCQUFnQiwwQ0FBb0MsRUFBRTtBQUN4RCxRQUFNLGVBQWUsR0FBRyx1QkFBaUIsZUFBZSxDQUFDO1FBQ3ZELGdCQUFnQixHQUFHLHVCQUFpQixnQkFBZ0IsQ0FBQyxDQUFDO0FBQ3hELFVBQU0sMkJBQ0oseUZBQXlGLEdBQ3ZGLHFEQUFxRCxHQUNyRCxlQUFlLEdBQ2YsbURBQW1ELEdBQ25ELGdCQUFnQixHQUNoQixJQUFJLENBQ1AsQ0FBQztHQUNILE1BQU07O0FBRUwsVUFBTSwyQkFDSix3RkFBd0YsR0FDdEYsaURBQWlELEdBQ2pELFlBQVksQ0FBQyxDQUFDLENBQUMsR0FDZixJQUFJLENBQ1AsQ0FBQztHQUNIO0NBQ0Y7O0FBRU0sU0FBUyxRQUFRLENBQUMsWUFBWSxFQUFFLEdBQUcsRUFBRTs7QUFFMUMsTUFBSSxDQUFDLEdBQUcsRUFBRTtBQUNSLFVBQU0sMkJBQWMsbUNBQW1DLENBQUMsQ0FBQztHQUMxRDtBQUNELE1BQUksQ0FBQyxZQUFZLElBQUksQ0FBQyxZQUFZLENBQUMsSUFBSSxFQUFFO0FBQ3ZDLFVBQU0sMkJBQWMsMkJBQTJCLEdBQUcsT0FBTyxZQUFZLENBQUMsQ0FBQztHQUN4RTs7QUFFRCxjQUFZLENBQUMsSUFBSSxDQUFDLFNBQVMsR0FBRyxZQUFZLENBQUMsTUFBTSxDQUFDOzs7O0FBSWxELEtBQUcsQ0FBQyxFQUFFLENBQUMsYUFBYSxDQUFDLFlBQVksQ0FBQyxRQUFRLENBQUMsQ0FBQzs7O0FBRzVDLE1BQU0sb0NBQW9DLEdBQ3hDLFlBQVksQ0FBQyxRQUFRLElBQUksWUFBWSxDQUFDLFFBQVEsQ0FBQyxDQUFDLENBQUMsS0FBSyxDQUFDLENBQUM7O0FBRTFELFdBQVMsb0JBQW9CLENBQUMsT0FBTyxFQUFFLE9BQU8sRUFBRSxPQUFPLEVBQUU7QUFDdkQsUUFBSSxPQUFPLENBQUMsSUFBSSxFQUFFO0FBQ2hCLGFBQU8sR0FBRyxLQUFLLENBQUMsTUFBTSxDQUFDLEVBQUUsRUFBRSxPQUFPLEVBQUUsT0FBTyxDQUFDLElBQUksQ0FBQyxDQUFDO0FBQ2xELFVBQUksT0FBTyxDQUFDLEdBQUcsRUFBRTtBQUNmLGVBQU8sQ0FBQyxHQUFHLENBQUMsQ0FBQyxDQUFDLEdBQUcsSUFBSSxDQUFDO09BQ3ZCO0tBQ0Y7QUFDRCxXQUFPLEdBQUcsR0FBRyxDQUFDLEVBQUUsQ0FBQyxjQUFjLENBQUMsSUFBSSxDQUFDLElBQUksRUFBRSxPQUFPLEVBQUUsT0FBTyxFQUFFLE9BQU8sQ0FBQyxDQUFDOztBQUV0RSxRQUFJLGVBQWUsR0FBRyxLQUFLLENBQUMsTUFBTSxDQUFDLEVBQUUsRUFBRSxPQUFPLEVBQUU7QUFDOUMsV0FBSyxFQUFFLElBQUksQ0FBQyxLQUFLO0FBQ2pCLHdCQUFrQixFQUFFLElBQUksQ0FBQyxrQkFBa0I7S0FDNUMsQ0FBQyxDQUFDOztBQUVILFFBQUksTUFBTSxHQUFHLEdBQUcsQ0FBQyxFQUFFLENBQUMsYUFBYSxDQUFDLElBQUksQ0FDcEMsSUFBSSxFQUNKLE9BQU8sRUFDUCxPQUFPLEVBQ1AsZUFBZSxDQUNoQixDQUFDOztBQUVGLFFBQUksTUFBTSxJQUFJLElBQUksSUFBSSxHQUFHLENBQUMsT0FBTyxFQUFFO0FBQ2pDLGFBQU8sQ0FBQyxRQUFRLENBQUMsT0FBTyxDQUFDLElBQUksQ0FBQyxHQUFHLEdBQUcsQ0FBQyxPQUFPLENBQzFDLE9BQU8sRUFDUCxZQUFZLENBQUMsZUFBZSxFQUM1QixHQUFHLENBQ0osQ0FBQztBQUNGLFlBQU0sR0FBRyxPQUFPLENBQUMsUUFBUSxDQUFDLE9BQU8sQ0FBQyxJQUFJLENBQUMsQ0FBQyxPQUFPLEVBQUUsZUFBZSxDQUFDLENBQUM7S0FDbkU7QUFDRCxRQUFJLE1BQU0sSUFBSSxJQUFJLEVBQUU7QUFDbEIsVUFBSSxPQUFPLENBQUMsTUFBTSxFQUFFO0FBQ2xCLFlBQUksS0FBSyxHQUFHLE1BQU0sQ0FBQyxLQUFLLENBQUMsSUFBSSxDQUFDLENBQUM7QUFDL0IsYUFBSyxJQUFJLENBQUMsR0FBRyxDQUFDLEVBQUUsQ0FBQyxHQUFHLEtBQUssQ0FBQyxNQUFNLEVBQUUsQ0FBQyxHQUFHLENBQUMsRUFBRSxDQUFDLEVBQUUsRUFBRTtBQUM1QyxjQUFJLENBQUMsS0FBSyxDQUFDLENBQUMsQ0FBQyxJQUFJLENBQUMsR0FBRyxDQUFDLEtBQUssQ0FBQyxFQUFFO0FBQzVCLGtCQUFNO1dBQ1A7O0FBRUQsZUFBSyxDQUFDLENBQUMsQ0FBQyxHQUFHLE9BQU8sQ0FBQyxNQUFNLEdBQUcsS0FBSyxDQUFDLENBQUMsQ0FBQyxDQUFDO1NBQ3RDO0FBQ0QsY0FBTSxHQUFHLEtBQUssQ0FBQyxJQUFJLENBQUMsSUFBSSxDQUFDLENBQUM7T0FDM0I7QUFDRCxhQUFPLE1BQU0sQ0FBQztLQUNmLE1BQU07QUFDTCxZQUFNLDJCQUNKLGNBQWMsR0FDWixPQUFPLENBQUMsSUFBSSxHQUNaLDBEQUEwRCxDQUM3RCxDQUFDO0tBQ0g7R0FDRjs7O0FBR0QsTUFBSSxTQUFTLEdBQUc7QUFDZCxVQUFNLEVBQUUsZ0JBQVMsR0FBRyxFQUFFLElBQUksRUFBRSxHQUFHLEVBQUU7QUFDL0IsVUFBSSxDQUFDLEdBQUcsSUFBSSxFQUFFLElBQUksSUFBSSxHQUFHLENBQUEsQUFBQyxFQUFFO0FBQzFCLGNBQU0sMkJBQWMsR0FBRyxHQUFHLElBQUksR0FBRyxtQkFBbUIsR0FBRyxHQUFHLEVBQUU7QUFDMUQsYUFBRyxFQUFFLEdBQUc7U0FDVCxDQUFDLENBQUM7T0FDSjtBQUNELGFBQU8sU0FBUyxDQUFDLGNBQWMsQ0FBQyxHQUFHLEVBQUUsSUFBSSxDQUFDLENBQUM7S0FDNUM7QUFDRCxrQkFBYyxFQUFFLHdCQUFTLE1BQU0sRUFBRSxZQUFZLEVBQUU7QUFDN0MsVUFBSSxNQUFNLEdBQUcsTUFBTSxDQUFDLFlBQVksQ0FBQyxDQUFDO0FBQ2xDLFVBQUksTUFBTSxJQUFJLElBQUksRUFBRTtBQUNsQixlQUFPLE1BQU0sQ0FBQztPQUNmO0FBQ0QsVUFBSSxNQUFNLENBQUMsU0FBUyxDQUFDLGNBQWMsQ0FBQyxJQUFJLENBQUMsTUFBTSxFQUFFLFlBQVksQ0FBQyxFQUFFO0FBQzlELGVBQU8sTUFBTSxDQUFDO09BQ2Y7O0FBRUQsVUFBSSxxQ0FBZ0IsTUFBTSxFQUFFLFNBQVMsQ0FBQyxrQkFBa0IsRUFBRSxZQUFZLENBQUMsRUFBRTtBQUN2RSxlQUFPLE1BQU0sQ0FBQztPQUNmO0FBQ0QsYUFBTyxTQUFTLENBQUM7S0FDbEI7QUFDRCxVQUFNLEVBQUUsZ0JBQVMsTUFBTSxFQUFFLElBQUksRUFBRTtBQUM3QixVQUFNLEdBQUcsR0FBRyxNQUFNLENBQUMsTUFBTSxDQUFDO0FBQzFCLFdBQUssSUFBSSxDQUFDLEdBQUcsQ0FBQyxFQUFFLENBQUMsR0FBRyxHQUFHLEVBQUUsQ0FBQyxFQUFFLEVBQUU7QUFDNUIsWUFBSSxNQUFNLEdBQUcsTUFBTSxDQUFDLENBQUMsQ0FBQyxJQUFJLFNBQVMsQ0FBQyxjQUFjLENBQUMsTUFBTSxDQUFDLENBQUMsQ0FBQyxFQUFFLElBQUksQ0FBQyxDQUFDO0FBQ3BFLFlBQUksTUFBTSxJQUFJLElBQUksRUFBRTtBQUNsQixpQkFBTyxNQUFNLENBQUMsQ0FBQyxDQUFDLENBQUMsSUFBSSxDQUFDLENBQUM7U0FDeEI7T0FDRjtLQUNGO0FBQ0QsVUFBTSxFQUFFLGdCQUFTLE9BQU8sRUFBRSxPQUFPLEVBQUU7QUFDakMsYUFBTyxPQUFPLE9BQU8sS0FBSyxVQUFVLEdBQUcsT0FBTyxDQUFDLElBQUksQ0FBQyxPQUFPLENBQUMsR0FBRyxPQUFPLENBQUM7S0FDeEU7O0FBRUQsb0JBQWdCLEVBQUUsS0FBSyxDQUFDLGdCQUFnQjtBQUN4QyxpQkFBYSxFQUFFLG9CQUFvQjs7QUFFbkMsTUFBRSxFQUFFLFlBQVMsQ0FBQyxFQUFFO0FBQ2QsVUFBSSxHQUFHLEdBQUcsWUFBWSxDQUFDLENBQUMsQ0FBQyxDQUFDO0FBQzFCLFNBQUcsQ0FBQyxTQUFTLEdBQUcsWUFBWSxDQUFDLENBQUMsR0FBRyxJQUFJLENBQUMsQ0FBQztBQUN2QyxhQUFPLEdBQUcsQ0FBQztLQUNaOztBQUVELFlBQVEsRUFBRSxFQUFFO0FBQ1osV0FBTyxFQUFFLGlCQUFTLENBQUMsRUFBRSxJQUFJLEVBQUUsbUJBQW1CLEVBQUUsV0FBVyxFQUFFLE1BQU0sRUFBRTtBQUNuRSxVQUFJLGNBQWMsR0FBRyxJQUFJLENBQUMsUUFBUSxDQUFDLENBQUMsQ0FBQztVQUNuQyxFQUFFLEdBQUcsSUFBSSxDQUFDLEVBQUUsQ0FBQyxDQUFDLENBQUMsQ0FBQztBQUNsQixVQUFJLElBQUksSUFBSSxNQUFNLElBQUksV0FBVyxJQUFJLG1CQUFtQixFQUFFO0FBQ3hELHNCQUFjLEdBQUcsV0FBVyxDQUMxQixJQUFJLEVBQ0osQ0FBQyxFQUNELEVBQUUsRUFDRixJQUFJLEVBQ0osbUJBQW1CLEVBQ25CLFdBQVcsRUFDWCxNQUFNLENBQ1AsQ0FBQztPQUNILE1BQU0sSUFBSSxDQUFDLGNBQWMsRUFBRTtBQUMxQixzQkFBYyxHQUFHLElBQUksQ0FBQyxRQUFRLENBQUMsQ0FBQyxDQUFDLEdBQUcsV0FBVyxDQUFDLElBQUksRUFBRSxDQUFDLEVBQUUsRUFBRSxDQUFDLENBQUM7T0FDOUQ7QUFDRCxhQUFPLGNBQWMsQ0FBQztLQUN2Qjs7QUFFRCxRQUFJLEVBQUUsY0FBUyxLQUFLLEVBQUUsS0FBSyxFQUFFO0FBQzNCLGFBQU8sS0FBSyxJQUFJLEtBQUssRUFBRSxFQUFFO0FBQ3ZCLGFBQUssR0FBRyxLQUFLLENBQUMsT0FBTyxDQUFDO09BQ3ZCO0FBQ0QsYUFBTyxLQUFLLENBQUM7S0FDZDtBQUNELGlCQUFhLEVBQUUsdUJBQVMsS0FBSyxFQUFFLE1BQU0sRUFBRTtBQUNyQyxVQUFJLEdBQUcsR0FBRyxLQUFLLElBQUksTUFBTSxDQUFDOztBQUUxQixVQUFJLEtBQUssSUFBSSxNQUFNLElBQUksS0FBSyxLQUFLLE1BQU0sRUFBRTtBQUN2QyxXQUFHLEdBQUcsS0FBSyxDQUFDLE1BQU0sQ0FBQyxFQUFFLEVBQUUsTUFBTSxFQUFFLEtBQUssQ0FBQyxDQUFDO09BQ3ZDOztBQUVELGFBQU8sR0FBRyxDQUFDO0tBQ1o7O0FBRUQsZUFBVyxFQUFFLE1BQU0sQ0FBQyxJQUFJLENBQUMsRUFBRSxDQUFDOztBQUU1QixRQUFJLEVBQUUsR0FBRyxDQUFDLEVBQUUsQ0FBQyxJQUFJO0FBQ2pCLGdCQUFZLEVBQUUsWUFBWSxDQUFDLFFBQVE7R0FDcEMsQ0FBQzs7QUFFRixXQUFTLEdBQUcsQ0FBQyxPQUFPLEVBQWdCO1FBQWQsT0FBTyx5REFBRyxFQUFFOztBQUNoQyxRQUFJLElBQUksR0FBRyxPQUFPLENBQUMsSUFBSSxDQUFDOztBQUV4QixPQUFHLENBQUMsTUFBTSxDQUFDLE9BQU8sQ0FBQyxDQUFDO0FBQ3BCLFFBQUksQ0FBQyxPQUFPLENBQUMsT0FBTyxJQUFJLFlBQVksQ0FBQyxPQUFPLEVBQUU7QUFDNUMsVUFBSSxHQUFHLFFBQVEsQ0FBQyxPQUFPLEVBQUUsSUFBSSxDQUFDLENBQUM7S0FDaEM7QUFDRCxRQUFJLE1BQU0sWUFBQTtRQUNSLFdBQVcsR0FBRyxZQUFZLENBQUMsY0FBYyxHQUFHLEVBQUUsR0FBRyxTQUFTLENBQUM7QUFDN0QsUUFBSSxZQUFZLENBQUMsU0FBUyxFQUFFO0FBQzFCLFVBQUksT0FBTyxDQUFDLE1BQU0sRUFBRTtBQUNsQixjQUFNLEdBQ0osT0FBTyxJQUFJLE9BQU8sQ0FBQyxNQUFNLENBQUMsQ0FBQyxDQUFDLEdBQ3hCLENBQUMsT0FBTyxDQUFDLENBQUMsTUFBTSxDQUFDLE9BQU8sQ0FBQyxNQUFNLENBQUMsR0FDaEMsT0FBTyxDQUFDLE1BQU0sQ0FBQztPQUN0QixNQUFNO0FBQ0wsY0FBTSxHQUFHLENBQUMsT0FBTyxDQUFDLENBQUM7T0FDcEI7S0FDRjs7QUFFRCxhQUFTLElBQUksQ0FBQyxPQUFPLGdCQUFnQjtBQUNuQyxhQUNFLEVBQUUsR0FDRixZQUFZLENBQUMsSUFBSSxDQUNmLFNBQVMsRUFDVCxPQUFPLEVBQ1AsU0FBUyxDQUFDLE9BQU8sRUFDakIsU0FBUyxDQUFDLFFBQVEsRUFDbEIsSUFBSSxFQUNKLFdBQVcsRUFDWCxNQUFNLENBQ1AsQ0FDRDtLQUNIOztBQUVELFFBQUksR0FBRyxpQkFBaUIsQ0FDdEIsWUFBWSxDQUFDLElBQUksRUFDakIsSUFBSSxFQUNKLFNBQVMsRUFDVCxPQUFPLENBQUMsTUFBTSxJQUFJLEVBQUUsRUFDcEIsSUFBSSxFQUNKLFdBQVcsQ0FDWixDQUFDO0FBQ0YsV0FBTyxJQUFJLENBQUMsT0FBTyxFQUFFLE9BQU8sQ0FBQyxDQUFDO0dBQy9COztBQUVELEtBQUcsQ0FBQyxLQUFLLEdBQUcsSUFBSSxDQUFDOztBQUVqQixLQUFHLENBQUMsTUFBTSxHQUFHLFVBQVMsT0FBTyxFQUFFO0FBQzdCLFFBQUksQ0FBQyxPQUFPLENBQUMsT0FBTyxFQUFFO0FBQ3BCLFVBQUksYUFBYSxHQUFHLEtBQUssQ0FBQyxNQUFNLENBQUMsRUFBRSxFQUFFLEdBQUcsQ0FBQyxPQUFPLEVBQUUsT0FBTyxDQUFDLE9BQU8sQ0FBQyxDQUFDO0FBQ25FLHFDQUErQixDQUFDLGFBQWEsRUFBRSxTQUFTLENBQUMsQ0FBQztBQUMxRCxlQUFTLENBQUMsT0FBTyxHQUFHLGFBQWEsQ0FBQzs7QUFFbEMsVUFBSSxZQUFZLENBQUMsVUFBVSxFQUFFOztBQUUzQixpQkFBUyxDQUFDLFFBQVEsR0FBRyxTQUFTLENBQUMsYUFBYSxDQUMxQyxPQUFPLENBQUMsUUFBUSxFQUNoQixHQUFHLENBQUMsUUFBUSxDQUNiLENBQUM7T0FDSDtBQUNELFVBQUksWUFBWSxDQUFDLFVBQVUsSUFBSSxZQUFZLENBQUMsYUFBYSxFQUFFO0FBQ3pELGlCQUFTLENBQUMsVUFBVSxHQUFHLEtBQUssQ0FBQyxNQUFNLENBQ2pDLEVBQUUsRUFDRixHQUFHLENBQUMsVUFBVSxFQUNkLE9BQU8sQ0FBQyxVQUFVLENBQ25CLENBQUM7T0FDSDs7QUFFRCxlQUFTLENBQUMsS0FBSyxHQUFHLEVBQUUsQ0FBQztBQUNyQixlQUFTLENBQUMsa0JBQWtCLEdBQUcsOENBQXlCLE9BQU8sQ0FBQyxDQUFDOztBQUVqRSxVQUFJLG1CQUFtQixHQUNyQixPQUFPLENBQUMseUJBQXlCLElBQ2pDLG9DQUFvQyxDQUFDO0FBQ3ZDLGlDQUFrQixTQUFTLEVBQUUsZUFBZSxFQUFFLG1CQUFtQixDQUFDLENBQUM7QUFDbkUsaUNBQWtCLFNBQVMsRUFBRSxvQkFBb0IsRUFBRSxtQkFBbUIsQ0FBQyxDQUFDO0tBQ3pFLE1BQU07QUFDTCxlQUFTLENBQUMsa0JBQWtCLEdBQUcsT0FBTyxDQUFDLGtCQUFrQixDQUFDO0FBQzFELGVBQVMsQ0FBQyxPQUFPLEdBQUcsT0FBTyxDQUFDLE9BQU8sQ0FBQztBQUNwQyxlQUFTLENBQUMsUUFBUSxHQUFHLE9BQU8sQ0FBQyxRQUFRLENBQUM7QUFDdEMsZUFBUyxDQUFDLFVBQVUsR0FBRyxPQUFPLENBQUMsVUFBVSxDQUFDO0FBQzFDLGVBQVMsQ0FBQyxLQUFLLEdBQUcsT0FBTyxDQUFDLEtBQUssQ0FBQztLQUNqQztHQUNGLENBQUM7O0FBRUYsS0FBRyxDQUFDLE1BQU0sR0FBRyxVQUFTLENBQUMsRUFBRSxJQUFJLEVBQUUsV0FBVyxFQUFFLE1BQU0sRUFBRTtBQUNsRCxRQUFJLFlBQVksQ0FBQyxjQUFjLElBQUksQ0FBQyxXQUFXLEVBQUU7QUFDL0MsWUFBTSwyQkFBYyx3QkFBd0IsQ0FBQyxDQUFDO0tBQy9DO0FBQ0QsUUFBSSxZQUFZLENBQUMsU0FBUyxJQUFJLENBQUMsTUFBTSxFQUFFO0FBQ3JDLFlBQU0sMkJBQWMseUJBQXlCLENBQUMsQ0FBQztLQUNoRDs7QUFFRCxXQUFPLFdBQVcsQ0FDaEIsU0FBUyxFQUNULENBQUMsRUFDRCxZQUFZLENBQUMsQ0FBQyxDQUFDLEVBQ2YsSUFBSSxFQUNKLENBQUMsRUFDRCxXQUFXLEVBQ1gsTUFBTSxDQUNQLENBQUM7R0FDSCxDQUFDO0FBQ0YsU0FBTyxHQUFHLENBQUM7Q0FDWjs7QUFFTSxTQUFTLFdBQVcsQ0FDekIsU0FBUyxFQUNULENBQUMsRUFDRCxFQUFFLEVBQ0YsSUFBSSxFQUNKLG1CQUFtQixFQUNuQixXQUFXLEVBQ1gsTUFBTSxFQUNOO0FBQ0EsV0FBUyxJQUFJLENBQUMsT0FBTyxFQUFnQjtRQUFkLE9BQU8seURBQUcsRUFBRTs7QUFDakMsUUFBSSxhQUFhLEdBQUcsTUFBTSxDQUFDO0FBQzNCLFFBQ0UsTUFBTSxJQUNOLE9BQU8sSUFBSSxNQUFNLENBQUMsQ0FBQyxDQUFDLElBQ3BCLEVBQUUsT0FBTyxLQUFLLFNBQVMsQ0FBQyxXQUFXLElBQUksTUFBTSxDQUFDLENBQUMsQ0FBQyxLQUFLLElBQUksQ0FBQSxBQUFDLEVBQzFEO0FBQ0EsbUJBQWEsR0FBRyxDQUFDLE9BQU8sQ0FBQyxDQUFDLE1BQU0sQ0FBQyxNQUFNLENBQUMsQ0FBQztLQUMxQzs7QUFFRCxXQUFPLEVBQUUsQ0FDUCxTQUFTLEVBQ1QsT0FBTyxFQUNQLFNBQVMsQ0FBQyxPQUFPLEVBQ2pCLFNBQVMsQ0FBQyxRQUFRLEVBQ2xCLE9BQU8sQ0FBQyxJQUFJLElBQUksSUFBSSxFQUNwQixXQUFXLElBQUksQ0FBQyxPQUFPLENBQUMsV0FBVyxDQUFDLENBQUMsTUFBTSxDQUFDLFdBQVcsQ0FBQyxFQUN4RCxhQUFhLENBQ2QsQ0FBQztHQUNIOztBQUVELE1BQUksR0FBRyxpQkFBaUIsQ0FBQyxFQUFFLEVBQUUsSUFBSSxFQUFFLFNBQVMsRUFBRSxNQUFNLEVBQUUsSUFBSSxFQUFFLFdBQVcsQ0FBQyxDQUFDOztBQUV6RSxNQUFJLENBQUMsT0FBTyxHQUFHLENBQUMsQ0FBQztBQUNqQixNQUFJLENBQUMsS0FBSyxHQUFHLE1BQU0sR0FBRyxNQUFNLENBQUMsTUFBTSxHQUFHLENBQUMsQ0FBQztBQUN4QyxNQUFJLENBQUMsV0FBVyxHQUFHLG1CQUFtQixJQUFJLENBQUMsQ0FBQztBQUM1QyxTQUFPLElBQUksQ0FBQztDQUNiOzs7Ozs7QUFLTSxTQUFTLGNBQWMsQ0FBQyxPQUFPLEVBQUUsT0FBTyxFQUFFLE9BQU8sRUFBRTtBQUN4RCxNQUFJLENBQUMsT0FBTyxFQUFFO0FBQ1osUUFBSSxPQUFPLENBQUMsSUFBSSxLQUFLLGdCQUFnQixFQUFFO0FBQ3JDLGFBQU8sR0FBRyxPQUFPLENBQUMsSUFBSSxDQUFDLGVBQWUsQ0FBQyxDQUFDO0tBQ3pDLE1BQU07QUFDTCxhQUFPLEdBQUcsT0FBTyxDQUFDLFFBQVEsQ0FBQyxPQUFPLENBQUMsSUFBSSxDQUFDLENBQUM7S0FDMUM7R0FDRixNQUFNLElBQUksQ0FBQyxPQUFPLENBQUMsSUFBSSxJQUFJLENBQUMsT0FBTyxDQUFDLElBQUksRUFBRTs7QUFFekMsV0FBTyxDQUFDLElBQUksR0FBRyxPQUFPLENBQUM7QUFDdkIsV0FBTyxHQUFHLE9BQU8sQ0FBQyxRQUFRLENBQUMsT0FBTyxDQUFDLENBQUM7R0FDckM7QUFDRCxTQUFPLE9BQU8sQ0FBQztDQUNoQjs7QUFFTSxTQUFTLGFBQWEsQ0FBQyxPQUFPLEVBQUUsT0FBTyxFQUFFLE9BQU8sRUFBRTs7QUFFdkQsTUFBTSxtQkFBbUIsR0FBRyxPQUFPLENBQUMsSUFBSSxJQUFJLE9BQU8sQ0FBQyxJQUFJLENBQUMsZUFBZSxDQUFDLENBQUM7QUFDMUUsU0FBTyxDQUFDLE9BQU8sR0FBRyxJQUFJLENBQUM7QUFDdkIsTUFBSSxPQUFPLENBQUMsR0FBRyxFQUFFO0FBQ2YsV0FBTyxDQUFDLElBQUksQ0FBQyxXQUFXLEdBQUcsT0FBTyxDQUFDLEdBQUcsQ0FBQyxDQUFDLENBQUMsSUFBSSxPQUFPLENBQUMsSUFBSSxDQUFDLFdBQVcsQ0FBQztHQUN2RTs7QUFFRCxNQUFJLFlBQVksWUFBQSxDQUFDO0FBQ2pCLE1BQUksT0FBTyxDQUFDLEVBQUUsSUFBSSxPQUFPLENBQUMsRUFBRSxLQUFLLElBQUksRUFBRTs7QUFDckMsYUFBTyxDQUFDLElBQUksR0FBRyxrQkFBWSxPQUFPLENBQUMsSUFBSSxDQUFDLENBQUM7O0FBRXpDLFVBQUksRUFBRSxHQUFHLE9BQU8sQ0FBQyxFQUFFLENBQUM7QUFDcEIsa0JBQVksR0FBRyxPQUFPLENBQUMsSUFBSSxDQUFDLGVBQWUsQ0FBQyxHQUFHLFNBQVMsbUJBQW1CLENBQ3pFLE9BQU8sRUFFUDtZQURBLE9BQU8seURBQUcsRUFBRTs7OztBQUlaLGVBQU8sQ0FBQyxJQUFJLEdBQUcsa0JBQVksT0FBTyxDQUFDLElBQUksQ0FBQyxDQUFDO0FBQ3pDLGVBQU8sQ0FBQyxJQUFJLENBQUMsZUFBZSxDQUFDLEdBQUcsbUJBQW1CLENBQUM7QUFDcEQsZUFBTyxFQUFFLENBQUMsT0FBTyxFQUFFLE9BQU8sQ0FBQyxDQUFDO09BQzdCLENBQUM7QUFDRixVQUFJLEVBQUUsQ0FBQyxRQUFRLEVBQUU7QUFDZixlQUFPLENBQUMsUUFBUSxHQUFHLEtBQUssQ0FBQyxNQUFNLENBQUMsRUFBRSxFQUFFLE9BQU8sQ0FBQyxRQUFRLEVBQUUsRUFBRSxDQUFDLFFBQVEsQ0FBQyxDQUFDO09BQ3BFOztHQUNGOztBQUVELE1BQUksT0FBTyxLQUFLLFNBQVMsSUFBSSxZQUFZLEVBQUU7QUFDekMsV0FBTyxHQUFHLFlBQVksQ0FBQztHQUN4Qjs7QUFFRCxNQUFJLE9BQU8sS0FBSyxTQUFTLEVBQUU7QUFDekIsVUFBTSwyQkFBYyxjQUFjLEdBQUcsT0FBTyxDQUFDLElBQUksR0FBRyxxQkFBcUIsQ0FBQyxDQUFDO0dBQzVFLE1BQU0sSUFBSSxPQUFPLFlBQVksUUFBUSxFQUFFO0FBQ3RDLFdBQU8sT0FBTyxDQUFDLE9BQU8sRUFBRSxPQUFPLENBQUMsQ0FBQztHQUNsQztDQUNGOztBQUVNLFNBQVMsSUFBSSxHQUFHO0FBQ3JCLFNBQU8sRUFBRSxDQUFDO0NBQ1g7O0FBRUQsU0FBUyxRQUFRLENBQUMsT0FBTyxFQUFFLElBQUksRUFBRTtBQUMvQixNQUFJLENBQUMsSUFBSSxJQUFJLEVBQUUsTUFBTSxJQUFJLElBQUksQ0FBQSxBQUFDLEVBQUU7QUFDOUIsUUFBSSxHQUFHLElBQUksR0FBRyxrQkFBWSxJQUFJLENBQUMsR0FBRyxFQUFFLENBQUM7QUFDckMsUUFBSSxDQUFDLElBQUksR0FBRyxPQUFPLENBQUM7R0FDckI7QUFDRCxTQUFPLElBQUksQ0FBQztDQUNiOztBQUVELFNBQVMsaUJBQWlCLENBQUMsRUFBRSxFQUFFLElBQUksRUFBRSxTQUFTLEVBQUUsTUFBTSxFQUFFLElBQUksRUFBRSxXQUFXLEVBQUU7QUFDekUsTUFBSSxFQUFFLENBQUMsU0FBUyxFQUFFO0FBQ2hCLFFBQUksS0FBSyxHQUFHLEVBQUUsQ0FBQztBQUNmLFFBQUksR0FBRyxFQUFFLENBQUMsU0FBUyxDQUNqQixJQUFJLEVBQ0osS0FBSyxFQUNMLFNBQVMsRUFDVCxNQUFNLElBQUksTUFBTSxDQUFDLENBQUMsQ0FBQyxFQUNuQixJQUFJLEVBQ0osV0FBVyxFQUNYLE1BQU0sQ0FDUCxDQUFDO0FBQ0YsU0FBSyxDQUFDLE1BQU0sQ0FBQyxJQUFJLEVBQUUsS0FBSyxDQUFDLENBQUM7R0FDM0I7QUFDRCxTQUFPLElBQUksQ0FBQztDQUNiOztBQUVELFNBQVMsK0JBQStCLENBQUMsYUFBYSxFQUFFLFNBQVMsRUFBRTtBQUNqRSxRQUFNLENBQUMsSUFBSSxDQUFDLGFBQWEsQ0FBQyxDQUFDLE9BQU8sQ0FBQyxVQUFBLFVBQVUsRUFBSTtBQUMvQyxRQUFJLE1BQU0sR0FBRyxhQUFhLENBQUMsVUFBVSxDQUFDLENBQUM7QUFDdkMsaUJBQWEsQ0FBQyxVQUFVLENBQUMsR0FBRyx3QkFBd0IsQ0FBQyxNQUFNLEVBQUUsU0FBUyxDQUFDLENBQUM7R0FDekUsQ0FBQyxDQUFDO0NBQ0o7O0FBRUQsU0FBUyx3QkFBd0IsQ0FBQyxNQUFNLEVBQUUsU0FBUyxFQUFFO0FBQ25ELE1BQU0sY0FBYyxHQUFHLFNBQVMsQ0FBQyxjQUFjLENBQUM7QUFDaEQsU0FBTywrQkFBVyxNQUFNLEVBQUUsVUFBQSxPQUFPLEVBQUk7QUFDbkMsV0FBTyxLQUFLLENBQUMsTUFBTSxDQUFDLEVBQUUsY0FBYyxFQUFkLGNBQWMsRUFBRSxFQUFFLE9BQU8sQ0FBQyxDQUFDO0dBQ2xELENBQUMsQ0FBQztDQUNKIiwiZmlsZSI6InJ1bnRpbWUuanMiLCJzb3VyY2VzQ29udGVudCI6WyJpbXBvcnQgKiBhcyBVdGlscyBmcm9tICcuL3V0aWxzJztcbmltcG9ydCBFeGNlcHRpb24gZnJvbSAnLi9leGNlcHRpb24nO1xuaW1wb3J0IHtcbiAgQ09NUElMRVJfUkVWSVNJT04sXG4gIGNyZWF0ZUZyYW1lLFxuICBMQVNUX0NPTVBBVElCTEVfQ09NUElMRVJfUkVWSVNJT04sXG4gIFJFVklTSU9OX0NIQU5HRVNcbn0gZnJvbSAnLi9iYXNlJztcbmltcG9ydCB7IG1vdmVIZWxwZXJUb0hvb2tzIH0gZnJvbSAnLi9oZWxwZXJzJztcbmltcG9ydCB7IHdyYXBIZWxwZXIgfSBmcm9tICcuL2ludGVybmFsL3dyYXBIZWxwZXInO1xuaW1wb3J0IHtcbiAgY3JlYXRlUHJvdG9BY2Nlc3NDb250cm9sLFxuICByZXN1bHRJc0FsbG93ZWRcbn0gZnJvbSAnLi9pbnRlcm5hbC9wcm90by1hY2Nlc3MnO1xuXG5leHBvcnQgZnVuY3Rpb24gY2hlY2tSZXZpc2lvbihjb21waWxlckluZm8pIHtcbiAgY29uc3QgY29tcGlsZXJSZXZpc2lvbiA9IChjb21waWxlckluZm8gJiYgY29tcGlsZXJJbmZvWzBdKSB8fCAxLFxuICAgIGN1cnJlbnRSZXZpc2lvbiA9IENPTVBJTEVSX1JFVklTSU9OO1xuXG4gIGlmIChcbiAgICBjb21waWxlclJldmlzaW9uID49IExBU1RfQ09NUEFUSUJMRV9DT01QSUxFUl9SRVZJU0lPTiAmJlxuICAgIGNvbXBpbGVyUmV2aXNpb24gPD0gQ09NUElMRVJfUkVWSVNJT05cbiAgKSB7XG4gICAgcmV0dXJuO1xuICB9XG5cbiAgaWYgKGNvbXBpbGVyUmV2aXNpb24gPCBMQVNUX0NPTVBBVElCTEVfQ09NUElMRVJfUkVWSVNJT04pIHtcbiAgICBjb25zdCBydW50aW1lVmVyc2lvbnMgPSBSRVZJU0lPTl9DSEFOR0VTW2N1cnJlbnRSZXZpc2lvbl0sXG4gICAgICBjb21waWxlclZlcnNpb25zID0gUkVWSVNJT05fQ0hBTkdFU1tjb21waWxlclJldmlzaW9uXTtcbiAgICB0aHJvdyBuZXcgRXhjZXB0aW9uKFxuICAgICAgJ1RlbXBsYXRlIHdhcyBwcmVjb21waWxlZCB3aXRoIGFuIG9sZGVyIHZlcnNpb24gb2YgSGFuZGxlYmFycyB0aGFuIHRoZSBjdXJyZW50IHJ1bnRpbWUuICcgK1xuICAgICAgICAnUGxlYXNlIHVwZGF0ZSB5b3VyIHByZWNvbXBpbGVyIHRvIGEgbmV3ZXIgdmVyc2lvbiAoJyArXG4gICAgICAgIHJ1bnRpbWVWZXJzaW9ucyArXG4gICAgICAgICcpIG9yIGRvd25ncmFkZSB5b3VyIHJ1bnRpbWUgdG8gYW4gb2xkZXIgdmVyc2lvbiAoJyArXG4gICAgICAgIGNvbXBpbGVyVmVyc2lvbnMgK1xuICAgICAgICAnKS4nXG4gICAgKTtcbiAgfSBlbHNlIHtcbiAgICAvLyBVc2UgdGhlIGVtYmVkZGVkIHZlcnNpb24gaW5mbyBzaW5jZSB0aGUgcnVudGltZSBkb2Vzbid0IGtub3cgYWJvdXQgdGhpcyByZXZpc2lvbiB5ZXRcbiAgICB0aHJvdyBuZXcgRXhjZXB0aW9uKFxuICAgICAgJ1RlbXBsYXRlIHdhcyBwcmVjb21waWxlZCB3aXRoIGEgbmV3ZXIgdmVyc2lvbiBvZiBIYW5kbGViYXJzIHRoYW4gdGhlIGN1cnJlbnQgcnVudGltZS4gJyArXG4gICAgICAgICdQbGVhc2UgdXBkYXRlIHlvdXIgcnVudGltZSB0byBhIG5ld2VyIHZlcnNpb24gKCcgK1xuICAgICAgICBjb21waWxlckluZm9bMV0gK1xuICAgICAgICAnKS4nXG4gICAgKTtcbiAgfVxufVxuXG5leHBvcnQgZnVuY3Rpb24gdGVtcGxhdGUodGVtcGxhdGVTcGVjLCBlbnYpIHtcbiAgLyogaXN0YW5idWwgaWdub3JlIG5leHQgKi9cbiAgaWYgKCFlbnYpIHtcbiAgICB0aHJvdyBuZXcgRXhjZXB0aW9uKCdObyBlbnZpcm9ubWVudCBwYXNzZWQgdG8gdGVtcGxhdGUnKTtcbiAgfVxuICBpZiAoIXRlbXBsYXRlU3BlYyB8fCAhdGVtcGxhdGVTcGVjLm1haW4pIHtcbiAgICB0aHJvdyBuZXcgRXhjZXB0aW9uKCdVbmtub3duIHRlbXBsYXRlIG9iamVjdDogJyArIHR5cGVvZiB0ZW1wbGF0ZVNwZWMpO1xuICB9XG5cbiAgdGVtcGxhdGVTcGVjLm1haW4uZGVjb3JhdG9yID0gdGVtcGxhdGVTcGVjLm1haW5fZDtcblxuICAvLyBOb3RlOiBVc2luZyBlbnYuVk0gcmVmZXJlbmNlcyByYXRoZXIgdGhhbiBsb2NhbCB2YXIgcmVmZXJlbmNlcyB0aHJvdWdob3V0IHRoaXMgc2VjdGlvbiB0byBhbGxvd1xuICAvLyBmb3IgZXh0ZXJuYWwgdXNlcnMgdG8gb3ZlcnJpZGUgdGhlc2UgYXMgcHNldWRvLXN1cHBvcnRlZCBBUElzLlxuICBlbnYuVk0uY2hlY2tSZXZpc2lvbih0ZW1wbGF0ZVNwZWMuY29tcGlsZXIpO1xuXG4gIC8vIGJhY2t3YXJkcyBjb21wYXRpYmlsaXR5IGZvciBwcmVjb21waWxlZCB0ZW1wbGF0ZXMgd2l0aCBjb21waWxlci12ZXJzaW9uIDcgKDw0LjMuMClcbiAgY29uc3QgdGVtcGxhdGVXYXNQcmVjb21waWxlZFdpdGhDb21waWxlclY3ID1cbiAgICB0ZW1wbGF0ZVNwZWMuY29tcGlsZXIgJiYgdGVtcGxhdGVTcGVjLmNvbXBpbGVyWzBdID09PSA3O1xuXG4gIGZ1bmN0aW9uIGludm9rZVBhcnRpYWxXcmFwcGVyKHBhcnRpYWwsIGNvbnRleHQsIG9wdGlvbnMpIHtcbiAgICBpZiAob3B0aW9ucy5oYXNoKSB7XG4gICAgICBjb250ZXh0ID0gVXRpbHMuZXh0ZW5kKHt9LCBjb250ZXh0LCBvcHRpb25zLmhhc2gpO1xuICAgICAgaWYgKG9wdGlvbnMuaWRzKSB7XG4gICAgICAgIG9wdGlvbnMuaWRzWzBdID0gdHJ1ZTtcbiAgICAgIH1cbiAgICB9XG4gICAgcGFydGlhbCA9IGVudi5WTS5yZXNvbHZlUGFydGlhbC5jYWxsKHRoaXMsIHBhcnRpYWwsIGNvbnRleHQsIG9wdGlvbnMpO1xuXG4gICAgbGV0IGV4dGVuZGVkT3B0aW9ucyA9IFV0aWxzLmV4dGVuZCh7fSwgb3B0aW9ucywge1xuICAgICAgaG9va3M6IHRoaXMuaG9va3MsXG4gICAgICBwcm90b0FjY2Vzc0NvbnRyb2w6IHRoaXMucHJvdG9BY2Nlc3NDb250cm9sXG4gICAgfSk7XG5cbiAgICBsZXQgcmVzdWx0ID0gZW52LlZNLmludm9rZVBhcnRpYWwuY2FsbChcbiAgICAgIHRoaXMsXG4gICAgICBwYXJ0aWFsLFxuICAgICAgY29udGV4dCxcbiAgICAgIGV4dGVuZGVkT3B0aW9uc1xuICAgICk7XG5cbiAgICBpZiAocmVzdWx0ID09IG51bGwgJiYgZW52LmNvbXBpbGUpIHtcbiAgICAgIG9wdGlvbnMucGFydGlhbHNbb3B0aW9ucy5uYW1lXSA9IGVudi5jb21waWxlKFxuICAgICAgICBwYXJ0aWFsLFxuICAgICAgICB0ZW1wbGF0ZVNwZWMuY29tcGlsZXJPcHRpb25zLFxuICAgICAgICBlbnZcbiAgICAgICk7XG4gICAgICByZXN1bHQgPSBvcHRpb25zLnBhcnRpYWxzW29wdGlvbnMubmFtZV0oY29udGV4dCwgZXh0ZW5kZWRPcHRpb25zKTtcbiAgICB9XG4gICAgaWYgKHJlc3VsdCAhPSBudWxsKSB7XG4gICAgICBpZiAob3B0aW9ucy5pbmRlbnQpIHtcbiAgICAgICAgbGV0IGxpbmVzID0gcmVzdWx0LnNwbGl0KCdcXG4nKTtcbiAgICAgICAgZm9yIChsZXQgaSA9IDAsIGwgPSBsaW5lcy5sZW5ndGg7IGkgPCBsOyBpKyspIHtcbiAgICAgICAgICBpZiAoIWxpbmVzW2ldICYmIGkgKyAxID09PSBsKSB7XG4gICAgICAgICAgICBicmVhaztcbiAgICAgICAgICB9XG5cbiAgICAgICAgICBsaW5lc1tpXSA9IG9wdGlvbnMuaW5kZW50ICsgbGluZXNbaV07XG4gICAgICAgIH1cbiAgICAgICAgcmVzdWx0ID0gbGluZXMuam9pbignXFxuJyk7XG4gICAgICB9XG4gICAgICByZXR1cm4gcmVzdWx0O1xuICAgIH0gZWxzZSB7XG4gICAgICB0aHJvdyBuZXcgRXhjZXB0aW9uKFxuICAgICAgICAnVGhlIHBhcnRpYWwgJyArXG4gICAgICAgICAgb3B0aW9ucy5uYW1lICtcbiAgICAgICAgICAnIGNvdWxkIG5vdCBiZSBjb21waWxlZCB3aGVuIHJ1bm5pbmcgaW4gcnVudGltZS1vbmx5IG1vZGUnXG4gICAgICApO1xuICAgIH1cbiAgfVxuXG4gIC8vIEp1c3QgYWRkIHdhdGVyXG4gIGxldCBjb250YWluZXIgPSB7XG4gICAgc3RyaWN0OiBmdW5jdGlvbihvYmosIG5hbWUsIGxvYykge1xuICAgICAgaWYgKCFvYmogfHwgIShuYW1lIGluIG9iaikpIHtcbiAgICAgICAgdGhyb3cgbmV3IEV4Y2VwdGlvbignXCInICsgbmFtZSArICdcIiBub3QgZGVmaW5lZCBpbiAnICsgb2JqLCB7XG4gICAgICAgICAgbG9jOiBsb2NcbiAgICAgICAgfSk7XG4gICAgICB9XG4gICAgICByZXR1cm4gY29udGFpbmVyLmxvb2t1cFByb3BlcnR5KG9iaiwgbmFtZSk7XG4gICAgfSxcbiAgICBsb29rdXBQcm9wZXJ0eTogZnVuY3Rpb24ocGFyZW50LCBwcm9wZXJ0eU5hbWUpIHtcbiAgICAgIGxldCByZXN1bHQgPSBwYXJlbnRbcHJvcGVydHlOYW1lXTtcbiAgICAgIGlmIChyZXN1bHQgPT0gbnVsbCkge1xuICAgICAgICByZXR1cm4gcmVzdWx0O1xuICAgICAgfVxuICAgICAgaWYgKE9iamVjdC5wcm90b3R5cGUuaGFzT3duUHJvcGVydHkuY2FsbChwYXJlbnQsIHByb3BlcnR5TmFtZSkpIHtcbiAgICAgICAgcmV0dXJuIHJlc3VsdDtcbiAgICAgIH1cblxuICAgICAgaWYgKHJlc3VsdElzQWxsb3dlZChyZXN1bHQsIGNvbnRhaW5lci5wcm90b0FjY2Vzc0NvbnRyb2wsIHByb3BlcnR5TmFtZSkpIHtcbiAgICAgICAgcmV0dXJuIHJlc3VsdDtcbiAgICAgIH1cbiAgICAgIHJldHVybiB1bmRlZmluZWQ7XG4gICAgfSxcbiAgICBsb29rdXA6IGZ1bmN0aW9uKGRlcHRocywgbmFtZSkge1xuICAgICAgY29uc3QgbGVuID0gZGVwdGhzLmxlbmd0aDtcbiAgICAgIGZvciAobGV0IGkgPSAwOyBpIDwgbGVuOyBpKyspIHtcbiAgICAgICAgbGV0IHJlc3VsdCA9IGRlcHRoc1tpXSAmJiBjb250YWluZXIubG9va3VwUHJvcGVydHkoZGVwdGhzW2ldLCBuYW1lKTtcbiAgICAgICAgaWYgKHJlc3VsdCAhPSBudWxsKSB7XG4gICAgICAgICAgcmV0dXJuIGRlcHRoc1tpXVtuYW1lXTtcbiAgICAgICAgfVxuICAgICAgfVxuICAgIH0sXG4gICAgbGFtYmRhOiBmdW5jdGlvbihjdXJyZW50LCBjb250ZXh0KSB7XG4gICAgICByZXR1cm4gdHlwZW9mIGN1cnJlbnQgPT09ICdmdW5jdGlvbicgPyBjdXJyZW50LmNhbGwoY29udGV4dCkgOiBjdXJyZW50O1xuICAgIH0sXG5cbiAgICBlc2NhcGVFeHByZXNzaW9uOiBVdGlscy5lc2NhcGVFeHByZXNzaW9uLFxuICAgIGludm9rZVBhcnRpYWw6IGludm9rZVBhcnRpYWxXcmFwcGVyLFxuXG4gICAgZm46IGZ1bmN0aW9uKGkpIHtcbiAgICAgIGxldCByZXQgPSB0ZW1wbGF0ZVNwZWNbaV07XG4gICAgICByZXQuZGVjb3JhdG9yID0gdGVtcGxhdGVTcGVjW2kgKyAnX2QnXTtcbiAgICAgIHJldHVybiByZXQ7XG4gICAgfSxcblxuICAgIHByb2dyYW1zOiBbXSxcbiAgICBwcm9ncmFtOiBmdW5jdGlvbihpLCBkYXRhLCBkZWNsYXJlZEJsb2NrUGFyYW1zLCBibG9ja1BhcmFtcywgZGVwdGhzKSB7XG4gICAgICBsZXQgcHJvZ3JhbVdyYXBwZXIgPSB0aGlzLnByb2dyYW1zW2ldLFxuICAgICAgICBmbiA9IHRoaXMuZm4oaSk7XG4gICAgICBpZiAoZGF0YSB8fCBkZXB0aHMgfHwgYmxvY2tQYXJhbXMgfHwgZGVjbGFyZWRCbG9ja1BhcmFtcykge1xuICAgICAgICBwcm9ncmFtV3JhcHBlciA9IHdyYXBQcm9ncmFtKFxuICAgICAgICAgIHRoaXMsXG4gICAgICAgICAgaSxcbiAgICAgICAgICBmbixcbiAgICAgICAgICBkYXRhLFxuICAgICAgICAgIGRlY2xhcmVkQmxvY2tQYXJhbXMsXG4gICAgICAgICAgYmxvY2tQYXJhbXMsXG4gICAgICAgICAgZGVwdGhzXG4gICAgICAgICk7XG4gICAgICB9IGVsc2UgaWYgKCFwcm9ncmFtV3JhcHBlcikge1xuICAgICAgICBwcm9ncmFtV3JhcHBlciA9IHRoaXMucHJvZ3JhbXNbaV0gPSB3cmFwUHJvZ3JhbSh0aGlzLCBpLCBmbik7XG4gICAgICB9XG4gICAgICByZXR1cm4gcHJvZ3JhbVdyYXBwZXI7XG4gICAgfSxcblxuICAgIGRhdGE6IGZ1bmN0aW9uKHZhbHVlLCBkZXB0aCkge1xuICAgICAgd2hpbGUgKHZhbHVlICYmIGRlcHRoLS0pIHtcbiAgICAgICAgdmFsdWUgPSB2YWx1ZS5fcGFyZW50O1xuICAgICAgfVxuICAgICAgcmV0dXJuIHZhbHVlO1xuICAgIH0sXG4gICAgbWVyZ2VJZk5lZWRlZDogZnVuY3Rpb24ocGFyYW0sIGNvbW1vbikge1xuICAgICAgbGV0IG9iaiA9IHBhcmFtIHx8IGNvbW1vbjtcblxuICAgICAgaWYgKHBhcmFtICYmIGNvbW1vbiAmJiBwYXJhbSAhPT0gY29tbW9uKSB7XG4gICAgICAgIG9iaiA9IFV0aWxzLmV4dGVuZCh7fSwgY29tbW9uLCBwYXJhbSk7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiBvYmo7XG4gICAgfSxcbiAgICAvLyBBbiBlbXB0eSBvYmplY3QgdG8gdXNlIGFzIHJlcGxhY2VtZW50IGZvciBudWxsLWNvbnRleHRzXG4gICAgbnVsbENvbnRleHQ6IE9iamVjdC5zZWFsKHt9KSxcblxuICAgIG5vb3A6IGVudi5WTS5ub29wLFxuICAgIGNvbXBpbGVySW5mbzogdGVtcGxhdGVTcGVjLmNvbXBpbGVyXG4gIH07XG5cbiAgZnVuY3Rpb24gcmV0KGNvbnRleHQsIG9wdGlvbnMgPSB7fSkge1xuICAgIGxldCBkYXRhID0gb3B0aW9ucy5kYXRhO1xuXG4gICAgcmV0Ll9zZXR1cChvcHRpb25zKTtcbiAgICBpZiAoIW9wdGlvbnMucGFydGlhbCAmJiB0ZW1wbGF0ZVNwZWMudXNlRGF0YSkge1xuICAgICAgZGF0YSA9IGluaXREYXRhKGNvbnRleHQsIGRhdGEpO1xuICAgIH1cbiAgICBsZXQgZGVwdGhzLFxuICAgICAgYmxvY2tQYXJhbXMgPSB0ZW1wbGF0ZVNwZWMudXNlQmxvY2tQYXJhbXMgPyBbXSA6IHVuZGVmaW5lZDtcbiAgICBpZiAodGVtcGxhdGVTcGVjLnVzZURlcHRocykge1xuICAgICAgaWYgKG9wdGlvbnMuZGVwdGhzKSB7XG4gICAgICAgIGRlcHRocyA9XG4gICAgICAgICAgY29udGV4dCAhPSBvcHRpb25zLmRlcHRoc1swXVxuICAgICAgICAgICAgPyBbY29udGV4dF0uY29uY2F0KG9wdGlvbnMuZGVwdGhzKVxuICAgICAgICAgICAgOiBvcHRpb25zLmRlcHRocztcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIGRlcHRocyA9IFtjb250ZXh0XTtcbiAgICAgIH1cbiAgICB9XG5cbiAgICBmdW5jdGlvbiBtYWluKGNvbnRleHQgLyosIG9wdGlvbnMqLykge1xuICAgICAgcmV0dXJuIChcbiAgICAgICAgJycgK1xuICAgICAgICB0ZW1wbGF0ZVNwZWMubWFpbihcbiAgICAgICAgICBjb250YWluZXIsXG4gICAgICAgICAgY29udGV4dCxcbiAgICAgICAgICBjb250YWluZXIuaGVscGVycyxcbiAgICAgICAgICBjb250YWluZXIucGFydGlhbHMsXG4gICAgICAgICAgZGF0YSxcbiAgICAgICAgICBibG9ja1BhcmFtcyxcbiAgICAgICAgICBkZXB0aHNcbiAgICAgICAgKVxuICAgICAgKTtcbiAgICB9XG5cbiAgICBtYWluID0gZXhlY3V0ZURlY29yYXRvcnMoXG4gICAgICB0ZW1wbGF0ZVNwZWMubWFpbixcbiAgICAgIG1haW4sXG4gICAgICBjb250YWluZXIsXG4gICAgICBvcHRpb25zLmRlcHRocyB8fCBbXSxcbiAgICAgIGRhdGEsXG4gICAgICBibG9ja1BhcmFtc1xuICAgICk7XG4gICAgcmV0dXJuIG1haW4oY29udGV4dCwgb3B0aW9ucyk7XG4gIH1cblxuICByZXQuaXNUb3AgPSB0cnVlO1xuXG4gIHJldC5fc2V0dXAgPSBmdW5jdGlvbihvcHRpb25zKSB7XG4gICAgaWYgKCFvcHRpb25zLnBhcnRpYWwpIHtcbiAgICAgIGxldCBtZXJnZWRIZWxwZXJzID0gVXRpbHMuZXh0ZW5kKHt9LCBlbnYuaGVscGVycywgb3B0aW9ucy5oZWxwZXJzKTtcbiAgICAgIHdyYXBIZWxwZXJzVG9QYXNzTG9va3VwUHJvcGVydHkobWVyZ2VkSGVscGVycywgY29udGFpbmVyKTtcbiAgICAgIGNvbnRhaW5lci5oZWxwZXJzID0gbWVyZ2VkSGVscGVycztcblxuICAgICAgaWYgKHRlbXBsYXRlU3BlYy51c2VQYXJ0aWFsKSB7XG4gICAgICAgIC8vIFVzZSBtZXJnZUlmTmVlZGVkIGhlcmUgdG8gcHJldmVudCBjb21waWxpbmcgZ2xvYmFsIHBhcnRpYWxzIG11bHRpcGxlIHRpbWVzXG4gICAgICAgIGNvbnRhaW5lci5wYXJ0aWFscyA9IGNvbnRhaW5lci5tZXJnZUlmTmVlZGVkKFxuICAgICAgICAgIG9wdGlvbnMucGFydGlhbHMsXG4gICAgICAgICAgZW52LnBhcnRpYWxzXG4gICAgICAgICk7XG4gICAgICB9XG4gICAgICBpZiAodGVtcGxhdGVTcGVjLnVzZVBhcnRpYWwgfHwgdGVtcGxhdGVTcGVjLnVzZURlY29yYXRvcnMpIHtcbiAgICAgICAgY29udGFpbmVyLmRlY29yYXRvcnMgPSBVdGlscy5leHRlbmQoXG4gICAgICAgICAge30sXG4gICAgICAgICAgZW52LmRlY29yYXRvcnMsXG4gICAgICAgICAgb3B0aW9ucy5kZWNvcmF0b3JzXG4gICAgICAgICk7XG4gICAgICB9XG5cbiAgICAgIGNvbnRhaW5lci5ob29rcyA9IHt9O1xuICAgICAgY29udGFpbmVyLnByb3RvQWNjZXNzQ29udHJvbCA9IGNyZWF0ZVByb3RvQWNjZXNzQ29udHJvbChvcHRpb25zKTtcblxuICAgICAgbGV0IGtlZXBIZWxwZXJJbkhlbHBlcnMgPVxuICAgICAgICBvcHRpb25zLmFsbG93Q2FsbHNUb0hlbHBlck1pc3NpbmcgfHxcbiAgICAgICAgdGVtcGxhdGVXYXNQcmVjb21waWxlZFdpdGhDb21waWxlclY3O1xuICAgICAgbW92ZUhlbHBlclRvSG9va3MoY29udGFpbmVyLCAnaGVscGVyTWlzc2luZycsIGtlZXBIZWxwZXJJbkhlbHBlcnMpO1xuICAgICAgbW92ZUhlbHBlclRvSG9va3MoY29udGFpbmVyLCAnYmxvY2tIZWxwZXJNaXNzaW5nJywga2VlcEhlbHBlckluSGVscGVycyk7XG4gICAgfSBlbHNlIHtcbiAgICAgIGNvbnRhaW5lci5wcm90b0FjY2Vzc0NvbnRyb2wgPSBvcHRpb25zLnByb3RvQWNjZXNzQ29udHJvbDsgLy8gaW50ZXJuYWwgb3B0aW9uXG4gICAgICBjb250YWluZXIuaGVscGVycyA9IG9wdGlvbnMuaGVscGVycztcbiAgICAgIGNvbnRhaW5lci5wYXJ0aWFscyA9IG9wdGlvbnMucGFydGlhbHM7XG4gICAgICBjb250YWluZXIuZGVjb3JhdG9ycyA9IG9wdGlvbnMuZGVjb3JhdG9ycztcbiAgICAgIGNvbnRhaW5lci5ob29rcyA9IG9wdGlvbnMuaG9va3M7XG4gICAgfVxuICB9O1xuXG4gIHJldC5fY2hpbGQgPSBmdW5jdGlvbihpLCBkYXRhLCBibG9ja1BhcmFtcywgZGVwdGhzKSB7XG4gICAgaWYgKHRlbXBsYXRlU3BlYy51c2VCbG9ja1BhcmFtcyAmJiAhYmxvY2tQYXJhbXMpIHtcbiAgICAgIHRocm93IG5ldyBFeGNlcHRpb24oJ211c3QgcGFzcyBibG9jayBwYXJhbXMnKTtcbiAgICB9XG4gICAgaWYgKHRlbXBsYXRlU3BlYy51c2VEZXB0aHMgJiYgIWRlcHRocykge1xuICAgICAgdGhyb3cgbmV3IEV4Y2VwdGlvbignbXVzdCBwYXNzIHBhcmVudCBkZXB0aHMnKTtcbiAgICB9XG5cbiAgICByZXR1cm4gd3JhcFByb2dyYW0oXG4gICAgICBjb250YWluZXIsXG4gICAgICBpLFxuICAgICAgdGVtcGxhdGVTcGVjW2ldLFxuICAgICAgZGF0YSxcbiAgICAgIDAsXG4gICAgICBibG9ja1BhcmFtcyxcbiAgICAgIGRlcHRoc1xuICAgICk7XG4gIH07XG4gIHJldHVybiByZXQ7XG59XG5cbmV4cG9ydCBmdW5jdGlvbiB3cmFwUHJvZ3JhbShcbiAgY29udGFpbmVyLFxuICBpLFxuICBmbixcbiAgZGF0YSxcbiAgZGVjbGFyZWRCbG9ja1BhcmFtcyxcbiAgYmxvY2tQYXJhbXMsXG4gIGRlcHRoc1xuKSB7XG4gIGZ1bmN0aW9uIHByb2coY29udGV4dCwgb3B0aW9ucyA9IHt9KSB7XG4gICAgbGV0IGN1cnJlbnREZXB0aHMgPSBkZXB0aHM7XG4gICAgaWYgKFxuICAgICAgZGVwdGhzICYmXG4gICAgICBjb250ZXh0ICE9IGRlcHRoc1swXSAmJlxuICAgICAgIShjb250ZXh0ID09PSBjb250YWluZXIubnVsbENvbnRleHQgJiYgZGVwdGhzWzBdID09PSBudWxsKVxuICAgICkge1xuICAgICAgY3VycmVudERlcHRocyA9IFtjb250ZXh0XS5jb25jYXQoZGVwdGhzKTtcbiAgICB9XG5cbiAgICByZXR1cm4gZm4oXG4gICAgICBjb250YWluZXIsXG4gICAgICBjb250ZXh0LFxuICAgICAgY29udGFpbmVyLmhlbHBlcnMsXG4gICAgICBjb250YWluZXIucGFydGlhbHMsXG4gICAgICBvcHRpb25zLmRhdGEgfHwgZGF0YSxcbiAgICAgIGJsb2NrUGFyYW1zICYmIFtvcHRpb25zLmJsb2NrUGFyYW1zXS5jb25jYXQoYmxvY2tQYXJhbXMpLFxuICAgICAgY3VycmVudERlcHRoc1xuICAgICk7XG4gIH1cblxuICBwcm9nID0gZXhlY3V0ZURlY29yYXRvcnMoZm4sIHByb2csIGNvbnRhaW5lciwgZGVwdGhzLCBkYXRhLCBibG9ja1BhcmFtcyk7XG5cbiAgcHJvZy5wcm9ncmFtID0gaTtcbiAgcHJvZy5kZXB0aCA9IGRlcHRocyA/IGRlcHRocy5sZW5ndGggOiAwO1xuICBwcm9nLmJsb2NrUGFyYW1zID0gZGVjbGFyZWRCbG9ja1BhcmFtcyB8fCAwO1xuICByZXR1cm4gcHJvZztcbn1cblxuLyoqXG4gKiBUaGlzIGlzIGN1cnJlbnRseSBwYXJ0IG9mIHRoZSBvZmZpY2lhbCBBUEksIHRoZXJlZm9yZSBpbXBsZW1lbnRhdGlvbiBkZXRhaWxzIHNob3VsZCBub3QgYmUgY2hhbmdlZC5cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHJlc29sdmVQYXJ0aWFsKHBhcnRpYWwsIGNvbnRleHQsIG9wdGlvbnMpIHtcbiAgaWYgKCFwYXJ0aWFsKSB7XG4gICAgaWYgKG9wdGlvbnMubmFtZSA9PT0gJ0BwYXJ0aWFsLWJsb2NrJykge1xuICAgICAgcGFydGlhbCA9IG9wdGlvbnMuZGF0YVsncGFydGlhbC1ibG9jayddO1xuICAgIH0gZWxzZSB7XG4gICAgICBwYXJ0aWFsID0gb3B0aW9ucy5wYXJ0aWFsc1tvcHRpb25zLm5hbWVdO1xuICAgIH1cbiAgfSBlbHNlIGlmICghcGFydGlhbC5jYWxsICYmICFvcHRpb25zLm5hbWUpIHtcbiAgICAvLyBUaGlzIGlzIGEgZHluYW1pYyBwYXJ0aWFsIHRoYXQgcmV0dXJuZWQgYSBzdHJpbmdcbiAgICBvcHRpb25zLm5hbWUgPSBwYXJ0aWFsO1xuICAgIHBhcnRpYWwgPSBvcHRpb25zLnBhcnRpYWxzW3BhcnRpYWxdO1xuICB9XG4gIHJldHVybiBwYXJ0aWFsO1xufVxuXG5leHBvcnQgZnVuY3Rpb24gaW52b2tlUGFydGlhbChwYXJ0aWFsLCBjb250ZXh0LCBvcHRpb25zKSB7XG4gIC8vIFVzZSB0aGUgY3VycmVudCBjbG9zdXJlIGNvbnRleHQgdG8gc2F2ZSB0aGUgcGFydGlhbC1ibG9jayBpZiB0aGlzIHBhcnRpYWxcbiAgY29uc3QgY3VycmVudFBhcnRpYWxCbG9jayA9IG9wdGlvbnMuZGF0YSAmJiBvcHRpb25zLmRhdGFbJ3BhcnRpYWwtYmxvY2snXTtcbiAgb3B0aW9ucy5wYXJ0aWFsID0gdHJ1ZTtcbiAgaWYgKG9wdGlvbnMuaWRzKSB7XG4gICAgb3B0aW9ucy5kYXRhLmNvbnRleHRQYXRoID0gb3B0aW9ucy5pZHNbMF0gfHwgb3B0aW9ucy5kYXRhLmNvbnRleHRQYXRoO1xuICB9XG5cbiAgbGV0IHBhcnRpYWxCbG9jaztcbiAgaWYgKG9wdGlvbnMuZm4gJiYgb3B0aW9ucy5mbiAhPT0gbm9vcCkge1xuICAgIG9wdGlvbnMuZGF0YSA9IGNyZWF0ZUZyYW1lKG9wdGlvbnMuZGF0YSk7XG4gICAgLy8gV3JhcHBlciBmdW5jdGlvbiB0byBnZXQgYWNjZXNzIHRvIGN1cnJlbnRQYXJ0aWFsQmxvY2sgZnJvbSB0aGUgY2xvc3VyZVxuICAgIGxldCBmbiA9IG9wdGlvbnMuZm47XG4gICAgcGFydGlhbEJsb2NrID0gb3B0aW9ucy5kYXRhWydwYXJ0aWFsLWJsb2NrJ10gPSBmdW5jdGlvbiBwYXJ0aWFsQmxvY2tXcmFwcGVyKFxuICAgICAgY29udGV4dCxcbiAgICAgIG9wdGlvbnMgPSB7fVxuICAgICkge1xuICAgICAgLy8gUmVzdG9yZSB0aGUgcGFydGlhbC1ibG9jayBmcm9tIHRoZSBjbG9zdXJlIGZvciB0aGUgZXhlY3V0aW9uIG9mIHRoZSBibG9ja1xuICAgICAgLy8gaS5lLiB0aGUgcGFydCBpbnNpZGUgdGhlIGJsb2NrIG9mIHRoZSBwYXJ0aWFsIGNhbGwuXG4gICAgICBvcHRpb25zLmRhdGEgPSBjcmVhdGVGcmFtZShvcHRpb25zLmRhdGEpO1xuICAgICAgb3B0aW9ucy5kYXRhWydwYXJ0aWFsLWJsb2NrJ10gPSBjdXJyZW50UGFydGlhbEJsb2NrO1xuICAgICAgcmV0dXJuIGZuKGNvbnRleHQsIG9wdGlvbnMpO1xuICAgIH07XG4gICAgaWYgKGZuLnBhcnRpYWxzKSB7XG4gICAgICBvcHRpb25zLnBhcnRpYWxzID0gVXRpbHMuZXh0ZW5kKHt9LCBvcHRpb25zLnBhcnRpYWxzLCBmbi5wYXJ0aWFscyk7XG4gICAgfVxuICB9XG5cbiAgaWYgKHBhcnRpYWwgPT09IHVuZGVmaW5lZCAmJiBwYXJ0aWFsQmxvY2spIHtcbiAgICBwYXJ0aWFsID0gcGFydGlhbEJsb2NrO1xuICB9XG5cbiAgaWYgKHBhcnRpYWwgPT09IHVuZGVmaW5lZCkge1xuICAgIHRocm93IG5ldyBFeGNlcHRpb24oJ1RoZSBwYXJ0aWFsICcgKyBvcHRpb25zLm5hbWUgKyAnIGNvdWxkIG5vdCBiZSBmb3VuZCcpO1xuICB9IGVsc2UgaWYgKHBhcnRpYWwgaW5zdGFuY2VvZiBGdW5jdGlvbikge1xuICAgIHJldHVybiBwYXJ0aWFsKGNvbnRleHQsIG9wdGlvbnMpO1xuICB9XG59XG5cbmV4cG9ydCBmdW5jdGlvbiBub29wKCkge1xuICByZXR1cm4gJyc7XG59XG5cbmZ1bmN0aW9uIGluaXREYXRhKGNvbnRleHQsIGRhdGEpIHtcbiAgaWYgKCFkYXRhIHx8ICEoJ3Jvb3QnIGluIGRhdGEpKSB7XG4gICAgZGF0YSA9IGRhdGEgPyBjcmVhdGVGcmFtZShkYXRhKSA6IHt9O1xuICAgIGRhdGEucm9vdCA9IGNvbnRleHQ7XG4gIH1cbiAgcmV0dXJuIGRhdGE7XG59XG5cbmZ1bmN0aW9uIGV4ZWN1dGVEZWNvcmF0b3JzKGZuLCBwcm9nLCBjb250YWluZXIsIGRlcHRocywgZGF0YSwgYmxvY2tQYXJhbXMpIHtcbiAgaWYgKGZuLmRlY29yYXRvcikge1xuICAgIGxldCBwcm9wcyA9IHt9O1xuICAgIHByb2cgPSBmbi5kZWNvcmF0b3IoXG4gICAgICBwcm9nLFxuICAgICAgcHJvcHMsXG4gICAgICBjb250YWluZXIsXG4gICAgICBkZXB0aHMgJiYgZGVwdGhzWzBdLFxuICAgICAgZGF0YSxcbiAgICAgIGJsb2NrUGFyYW1zLFxuICAgICAgZGVwdGhzXG4gICAgKTtcbiAgICBVdGlscy5leHRlbmQocHJvZywgcHJvcHMpO1xuICB9XG4gIHJldHVybiBwcm9nO1xufVxuXG5mdW5jdGlvbiB3cmFwSGVscGVyc1RvUGFzc0xvb2t1cFByb3BlcnR5KG1lcmdlZEhlbHBlcnMsIGNvbnRhaW5lcikge1xuICBPYmplY3Qua2V5cyhtZXJnZWRIZWxwZXJzKS5mb3JFYWNoKGhlbHBlck5hbWUgPT4ge1xuICAgIGxldCBoZWxwZXIgPSBtZXJnZWRIZWxwZXJzW2hlbHBlck5hbWVdO1xuICAgIG1lcmdlZEhlbHBlcnNbaGVscGVyTmFtZV0gPSBwYXNzTG9va3VwUHJvcGVydHlPcHRpb24oaGVscGVyLCBjb250YWluZXIpO1xuICB9KTtcbn1cblxuZnVuY3Rpb24gcGFzc0xvb2t1cFByb3BlcnR5T3B0aW9uKGhlbHBlciwgY29udGFpbmVyKSB7XG4gIGNvbnN0IGxvb2t1cFByb3BlcnR5ID0gY29udGFpbmVyLmxvb2t1cFByb3BlcnR5O1xuICByZXR1cm4gd3JhcEhlbHBlcihoZWxwZXIsIG9wdGlvbnMgPT4ge1xuICAgIHJldHVybiBVdGlscy5leHRlbmQoeyBsb29rdXBQcm9wZXJ0eSB9LCBvcHRpb25zKTtcbiAgfSk7XG59XG4iXX0=


/***/ }),

/***/ 5558:
/***/ (function(module, exports) {

"use strict";
// Build out our basic SafeString type


exports.__esModule = true;
function SafeString(string) {
  this.string = string;
}

SafeString.prototype.toString = SafeString.prototype.toHTML = function () {
  return '' + this.string;
};

exports["default"] = SafeString;
module.exports = exports['default'];
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uL2xpYi9oYW5kbGViYXJzL3NhZmUtc3RyaW5nLmpzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7Ozs7QUFDQSxTQUFTLFVBQVUsQ0FBQyxNQUFNLEVBQUU7QUFDMUIsTUFBSSxDQUFDLE1BQU0sR0FBRyxNQUFNLENBQUM7Q0FDdEI7O0FBRUQsVUFBVSxDQUFDLFNBQVMsQ0FBQyxRQUFRLEdBQUcsVUFBVSxDQUFDLFNBQVMsQ0FBQyxNQUFNLEdBQUcsWUFBVztBQUN2RSxTQUFPLEVBQUUsR0FBRyxJQUFJLENBQUMsTUFBTSxDQUFDO0NBQ3pCLENBQUM7O3FCQUVhLFVBQVUiLCJmaWxlIjoic2FmZS1zdHJpbmcuanMiLCJzb3VyY2VzQ29udGVudCI6WyIvLyBCdWlsZCBvdXQgb3VyIGJhc2ljIFNhZmVTdHJpbmcgdHlwZVxuZnVuY3Rpb24gU2FmZVN0cmluZyhzdHJpbmcpIHtcbiAgdGhpcy5zdHJpbmcgPSBzdHJpbmc7XG59XG5cblNhZmVTdHJpbmcucHJvdG90eXBlLnRvU3RyaW5nID0gU2FmZVN0cmluZy5wcm90b3R5cGUudG9IVE1MID0gZnVuY3Rpb24oKSB7XG4gIHJldHVybiAnJyArIHRoaXMuc3RyaW5nO1xufTtcblxuZXhwb3J0IGRlZmF1bHQgU2FmZVN0cmluZztcbiJdfQ==


/***/ }),

/***/ 2392:
/***/ (function(__unused_webpack_module, exports) {

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

/***/ 5666:
/***/ (function(module) {

/**
 * Copyright (c) 2014-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

var runtime = (function (exports) {
  "use strict";

  var Op = Object.prototype;
  var hasOwn = Op.hasOwnProperty;
  var undefined; // More compressible than void 0.
  var $Symbol = typeof Symbol === "function" ? Symbol : {};
  var iteratorSymbol = $Symbol.iterator || "@@iterator";
  var asyncIteratorSymbol = $Symbol.asyncIterator || "@@asyncIterator";
  var toStringTagSymbol = $Symbol.toStringTag || "@@toStringTag";

  function define(obj, key, value) {
    Object.defineProperty(obj, key, {
      value: value,
      enumerable: true,
      configurable: true,
      writable: true
    });
    return obj[key];
  }
  try {
    // IE 8 has a broken Object.defineProperty that only works on DOM objects.
    define({}, "");
  } catch (err) {
    define = function(obj, key, value) {
      return obj[key] = value;
    };
  }

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
  exports.wrap = wrap;

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
  define(IteratorPrototype, iteratorSymbol, function () {
    return this;
  });

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
  GeneratorFunction.prototype = GeneratorFunctionPrototype;
  define(Gp, "constructor", GeneratorFunctionPrototype);
  define(GeneratorFunctionPrototype, "constructor", GeneratorFunction);
  GeneratorFunction.displayName = define(
    GeneratorFunctionPrototype,
    toStringTagSymbol,
    "GeneratorFunction"
  );

  // Helper for defining the .next, .throw, and .return methods of the
  // Iterator interface in terms of a single ._invoke method.
  function defineIteratorMethods(prototype) {
    ["next", "throw", "return"].forEach(function(method) {
      define(prototype, method, function(arg) {
        return this._invoke(method, arg);
      });
    });
  }

  exports.isGeneratorFunction = function(genFun) {
    var ctor = typeof genFun === "function" && genFun.constructor;
    return ctor
      ? ctor === GeneratorFunction ||
        // For the native GeneratorFunction constructor, the best we can
        // do is to check its .name property.
        (ctor.displayName || ctor.name) === "GeneratorFunction"
      : false;
  };

  exports.mark = function(genFun) {
    if (Object.setPrototypeOf) {
      Object.setPrototypeOf(genFun, GeneratorFunctionPrototype);
    } else {
      genFun.__proto__ = GeneratorFunctionPrototype;
      define(genFun, toStringTagSymbol, "GeneratorFunction");
    }
    genFun.prototype = Object.create(Gp);
    return genFun;
  };

  // Within the body of any async function, `await x` is transformed to
  // `yield regeneratorRuntime.awrap(x)`, so that the runtime can test
  // `hasOwn.call(value, "__await")` to determine if the yielded value is
  // meant to be awaited.
  exports.awrap = function(arg) {
    return { __await: arg };
  };

  function AsyncIterator(generator, PromiseImpl) {
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
          return PromiseImpl.resolve(value.__await).then(function(value) {
            invoke("next", value, resolve, reject);
          }, function(err) {
            invoke("throw", err, resolve, reject);
          });
        }

        return PromiseImpl.resolve(value).then(function(unwrapped) {
          // When a yielded Promise is resolved, its final value becomes
          // the .value of the Promise<{value,done}> result for the
          // current iteration.
          result.value = unwrapped;
          resolve(result);
        }, function(error) {
          // If a rejected Promise was yielded, throw the rejection back
          // into the async generator function so it can be handled there.
          return invoke("throw", error, resolve, reject);
        });
      }
    }

    var previousPromise;

    function enqueue(method, arg) {
      function callInvokeWithMethodAndArg() {
        return new PromiseImpl(function(resolve, reject) {
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
  define(AsyncIterator.prototype, asyncIteratorSymbol, function () {
    return this;
  });
  exports.AsyncIterator = AsyncIterator;

  // Note that simple async functions are implemented on top of
  // AsyncIterator objects; they just return a Promise for the value of
  // the final result produced by the iterator.
  exports.async = function(innerFn, outerFn, self, tryLocsList, PromiseImpl) {
    if (PromiseImpl === void 0) PromiseImpl = Promise;

    var iter = new AsyncIterator(
      wrap(innerFn, outerFn, self, tryLocsList),
      PromiseImpl
    );

    return exports.isGeneratorFunction(outerFn)
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
        // Note: ["return"] must be used for ES3 parsing compatibility.
        if (delegate.iterator["return"]) {
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

  define(Gp, toStringTagSymbol, "Generator");

  // A Generator should always return itself as the iterator object when the
  // @@iterator function is called on it. Some browsers' implementations of the
  // iterator prototype chain incorrectly implement this, causing the Generator
  // object to not be returned from this call. This ensures that doesn't happen.
  // See https://github.com/facebook/regenerator/issues/274 for more details.
  define(Gp, iteratorSymbol, function() {
    return this;
  });

  define(Gp, "toString", function() {
    return "[object Generator]";
  });

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

  exports.keys = function(object) {
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
  exports.values = values;

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

  // Regardless of whether this script is executing as a CommonJS module
  // or not, return the runtime object so that we can declare the variable
  // regeneratorRuntime in the outer scope, which allows this module to be
  // injected easily by `bin/regenerator --include-runtime script.js`.
  return exports;

}(
  // If this script is executing as a CommonJS module, use module.exports
  // as the regeneratorRuntime namespace. Otherwise create a new empty
  // object. Either way, the resulting object will be used to initialize
  // the regeneratorRuntime variable at the top of this file.
   true ? module.exports : 0
));

try {
  regeneratorRuntime = runtime;
} catch (accidentalStrictMode) {
  // This module should not be running in strict mode, so the above
  // assignment should always work unless something is misconfigured. Just
  // in case runtime.js accidentally runs in strict mode, in modern engines
  // we can explicitly access globalThis. In older engines we can escape
  // strict mode using a global Function call. This could conceivably fail
  // if a Content Security Policy forbids using Function, but in that case
  // the proper solution is to fix the accidental strict mode problem. If
  // you've misconfigured your bundler to force strict mode and applied a
  // CSP to forbid Function, and you're not willing to fix either of those
  // problems, please detail your unique predicament in a GitHub issue.
  if (typeof globalThis === "object") {
    globalThis.regeneratorRuntime = runtime;
  } else {
    Function("r", "regeneratorRuntime = r")(runtime);
  }
}


/***/ })

/******/ 	});
/************************************************************************/
/******/ 	// The module cache
/******/ 	var __webpack_module_cache__ = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/ 		// Check if module is in cache
/******/ 		var cachedModule = __webpack_module_cache__[moduleId];
/******/ 		if (cachedModule !== undefined) {
/******/ 			return cachedModule.exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = __webpack_module_cache__[moduleId] = {
/******/ 			// no module.id needed
/******/ 			// no module.loaded needed
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		__webpack_modules__[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/************************************************************************/
/******/ 	/* webpack/runtime/global */
/******/ 	!function() {
/******/ 		__webpack_require__.g = (function() {
/******/ 			if (typeof globalThis === 'object') return globalThis;
/******/ 			try {
/******/ 				return this || new Function('return this')();
/******/ 			} catch (e) {
/******/ 				if (typeof window === 'object') return window;
/******/ 			}
/******/ 		})();
/******/ 	}();
/******/
/************************************************************************/
/******/
/******/ 	// startup
/******/ 	// Load entry module and return exports
/******/ 	// This entry module is referenced by other modules so it can't be inlined
/******/ 	__webpack_require__(6337);
/******/ 	__webpack_require__(3867);
/******/ 	__webpack_require__(5666);
/******/ 	var __webpack_exports__ = __webpack_require__(5579);
/******/
/******/ 	return __webpack_exports__;
/******/ })()
;
});
//# sourceMappingURL=mura.js.map