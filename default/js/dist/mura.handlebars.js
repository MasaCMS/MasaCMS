
if (!Object.create) {
    Object.create = function(proto, props) {
        if (typeof props !== "undefined") {
            throw "The multiple-argument version of Object.create is not provided by this browser and cannot be shimmed.";
        }
        function ctor() { }
        ctor.prototype = proto;
        return new ctor();
    };
}

if (!Array.isArray) {
  Array.isArray = function(arg) {
    return Object.prototype.toString.call(arg) === '[object Array]';
  };
}

// From https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/keys
if (!Object.keys) {
  Object.keys = (function() {
    'use strict';
    var hasOwnProperty = Object.prototype.hasOwnProperty,
        hasDontEnumBug = !({ toString: null }).propertyIsEnumerable('toString'),
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

    return function(obj) {
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

!window.addEventListener && (function (WindowPrototype, DocumentPrototype, ElementPrototype, addEventListener, removeEventListener, dispatchEvent, registry) {
	WindowPrototype[addEventListener] = DocumentPrototype[addEventListener] = ElementPrototype[addEventListener] = function (type, listener) {
		var target = this;

		registry.unshift([target, type, listener, function (event) {
			event.currentTarget = target;
			event.preventDefault = function () { event.returnValue = false };
			event.stopPropagation = function () { event.cancelBubble = true };
			event.target = event.srcElement || target;

			listener.call(target, event);
		}]);

		this.attachEvent("on" + type, registry[0][3]);
	};

	WindowPrototype[removeEventListener] = DocumentPrototype[removeEventListener] = ElementPrototype[removeEventListener] = function (type, listener) {
		for (var index = 0, register; register = registry[index]; ++index) {
			if (register[0] == this && register[1] == type && register[2] == listener) {
				return this.detachEvent("on" + type, registry.splice(index, 1)[0][3]);
			}
		}
	};

	WindowPrototype[dispatchEvent] = DocumentPrototype[dispatchEvent] = ElementPrototype[dispatchEvent] = function (eventObject) {
		return this.fireEvent("on" + eventObject.type, eventObject);
	};
})(Window.prototype, HTMLDocument.prototype, Element.prototype, "addEventListener", "removeEventListener", "dispatchEvent", []);

// Production steps of ECMA-262, Edition 5, 15.4.4.21
// Reference: http://es5.github.io/#x15.4.4.21
// https://tc39.github.io/ecma262/#sec-array.prototype.reduce
if (!Array.prototype.reduce) {
  Array.prototype.reduce=function(callback) {
      if (this === null) {
        throw new TypeError('Array.prototype.reduce called on null or undefined');
      }
      if (typeof callback !== 'function') {
        throw new TypeError(callback + ' is not a function');
      }

      // 1. Let O be ? ToObject(this value).
      var o = Object(this);

      // 2. Let len be ? ToLength(? Get(O, "length")).
      var len = o.length >>> 0;

      // Steps 3, 4, 5, 6, 7
      var k = 0;
      var value;

      if (arguments.length == 2) {
        value = arguments[1];
      } else {
        while (k < len && !(k in o)) {
          k++;
        }

        // 3. If len is 0 and initialValue is not present, throw a TypeError exception.
        if (k >= len) {
          throw new TypeError('Reduce of empty array with no initial value');
        }
        value = o[k++];
      }

      // 8. Repeat, while k < len
      while (k < len) {
        // a. Let Pk be ! ToString(k).
        // b. Let kPresent be ? HasProperty(O, Pk).
        // c. If kPresent is true, then
        //    i. Let kValue be ? Get(O, Pk).
        //    ii. Let accumulator be ? Call(callbackfn, undefined, « accumulator, kValue, k, O »).
        if (k in o) {
          value = callback(value, o[k], k, o);
        }

        // d. Increase k by 1.
        k++;
      }

      // 9. Return accumulator.
      return value;
  }
}

if (!Array.prototype.forEach) {

  Array.prototype.forEach = function(callback, thisArg) {

    var T, k;

    if (this == null) {
      throw new TypeError(' this is null or not defined');
    }

    // 1. Let O be the result of calling toObject() passing the
    // |this| value as the argument.
    var O = Object(this);

    // 2. Let lenValue be the result of calling the Get() internal
    // method of O with the argument "length".
    // 3. Let len be toUint32(lenValue).
    var len = O.length >>> 0;

    // 4. If isCallable(callback) is false, throw a TypeErrorexception.
    // See: http://es5.github.com/#x9.11
    if (typeof callback !== "function") {
      throw new TypeError(callback + ' is not a function');
    }

    // 5. If thisArg was supplied, let T be thisArg; else let
    // T be undefined.
    if (arguments.length > 1) {
      T = thisArg;
    }

    // 6. Let k be 0
    k = 0;

    // 7. Repeat, while k < len
    while (k < len) {

      var kValue;

      // a. Let Pk be ToString(k).
      //    This is implicit for LHS operands of the in operator
      // b. Let kPresent be the result of calling the HasProperty
      //    internal method of O with argument Pk.
      //    This step can be combined with c
      // c. If kPresent is true, then
      if (k in O) {

        // i. Let kValue be the result of calling the Get internal
        // method of O with argument Pk.
        kValue = O[k];

        // ii. Call the Call internal method of callback with T as
        // the this value and argument list containing kValue, k, and O.
        callback.call(T, kValue, k, O);
      }
      // d. Increase k by 1.
      k++;
    }
    // 8. return undefined
  };
}

if (!Array.prototype.filter) {
  Array.prototype.filter = function(fun/*, thisArg*/) {
    'use strict';

    if (this === void 0 || this === null) {
      throw new TypeError();
    }

    var t = Object(this);
    var len = t.length >>> 0;
    if (typeof fun !== 'function') {
      throw new TypeError();
    }

    var res = [];
    var thisArg = arguments.length >= 2 ? arguments[1] : void 0;
    for (var i = 0; i < len; i++) {
      if (i in t) {
        var val = t[i];

        // NOTE: Technically this should Object.defineProperty at
        //       the next index, as push can be affected by
        //       properties on Object.prototype and Array.prototype.
        //       But that method's new, and collisions should be
        //       rare, so use the more-compatible alternative.
        if (fun.call(thisArg, val, i, t)) {
          res.push(val);
        }
      }
    }

    return res;
  };
}

// Production steps of ECMA-262, Edition 5, 15.4.4.19
// Reference: http://es5.github.io/#x15.4.4.19
if (!Array.prototype.map) {

  Array.prototype.map = function(callback, thisArg) {

    var T, A, k;

    if (this == null) {
      throw new TypeError(' this is null or not defined');
    }

    // 1. Let O be the result of calling ToObject passing the |this|
    //    value as the argument.
    var O = Object(this);

    // 2. Let lenValue be the result of calling the Get internal
    //    method of O with the argument "length".
    // 3. Let len be ToUint32(lenValue).
    var len = O.length >>> 0;

    // 4. If IsCallable(callback) is false, throw a TypeError exception.
    // See: http://es5.github.com/#x9.11
    if (typeof callback !== 'function') {
      throw new TypeError(callback + ' is not a function');
    }

    // 5. If thisArg was supplied, let T be thisArg; else let T be undefined.
    if (arguments.length > 1) {
      T = thisArg;
    }

    // 6. Let A be a new array created as if by the expression new Array(len)
    //    where Array is the standard built-in constructor with that name and
    //    len is the value of len.
    A = new Array(len);

    // 7. Let k be 0
    k = 0;

    // 8. Repeat, while k < len
    while (k < len) {

      var kValue, mappedValue;

      // a. Let Pk be ToString(k).
      //   This is implicit for LHS operands of the in operator
      // b. Let kPresent be the result of calling the HasProperty internal
      //    method of O with argument Pk.
      //   This step can be combined with c
      // c. If kPresent is true, then
      if (k in O) {

        // i. Let kValue be the result of calling the Get internal
        //    method of O with argument Pk.
        kValue = O[k];

        // ii. Let mappedValue be the result of calling the Call internal
        //     method of callback with T as the this value and argument
        //     list containing kValue, k, and O.
        mappedValue = callback.call(T, kValue, k, O);

        // iii. Call the DefineOwnProperty internal method of A with arguments
        // Pk, Property Descriptor
        // { Value: mappedValue,
        //   Writable: true,
        //   Enumerable: true,
        //   Configurable: true },
        // and false.

        // In browsers that support Object.defineProperty, use the following:
        // Object.defineProperty(A, k, {
        //   value: mappedValue,
        //   writable: true,
        //   enumerable: true,
        //   configurable: true
        // });

        // For best browser support, use the following:
        A[k] = mappedValue;
      }
      // d. Increase k by 1.
      k++;
    }

    // 9. return A
    return A;
  };
}

/*!
 * @overview es6-promise - a tiny implementation of Promises/A+.
 * @copyright Copyright (c) 2014 Yehuda Katz, Tom Dale, Stefan Penner and contributors (Conversion to ES6 API by Jake Archibald)
 * @license   Licensed under MIT license
 *            See https://raw.githubusercontent.com/jakearchibald/es6-promise/master/LICENSE
 * @version   2.3.0
 */

(function() {
    "use strict";
    function lib$es6$promise$utils$$objectOrFunction(x) {
      return typeof x === 'function' || (typeof x === 'object' && x !== null);
    }

    function lib$es6$promise$utils$$isFunction(x) {
      return typeof x === 'function';
    }

    function lib$es6$promise$utils$$isMaybeThenable(x) {
      return typeof x === 'object' && x !== null;
    }

    var lib$es6$promise$utils$$_isArray;
    if (!Array.isArray) {
      lib$es6$promise$utils$$_isArray = function (x) {
        return Object.prototype.toString.call(x) === '[object Array]';
      };
    } else {
      lib$es6$promise$utils$$_isArray = Array.isArray;
    }

    var lib$es6$promise$utils$$isArray = lib$es6$promise$utils$$_isArray;
    var lib$es6$promise$asap$$len = 0;
    var lib$es6$promise$asap$$toString = {}.toString;
    var lib$es6$promise$asap$$vertxNext;
    var lib$es6$promise$asap$$customSchedulerFn;

    var lib$es6$promise$asap$$asap = function asap(callback, arg) {
      lib$es6$promise$asap$$queue[lib$es6$promise$asap$$len] = callback;
      lib$es6$promise$asap$$queue[lib$es6$promise$asap$$len + 1] = arg;
      lib$es6$promise$asap$$len += 2;
      if (lib$es6$promise$asap$$len === 2) {
        // If len is 2, that means that we need to schedule an async flush.
        // If additional callbacks are queued before the queue is flushed, they
        // will be processed by this flush that we are scheduling.
        if (lib$es6$promise$asap$$customSchedulerFn) {
          lib$es6$promise$asap$$customSchedulerFn(lib$es6$promise$asap$$flush);
        } else {
          lib$es6$promise$asap$$scheduleFlush();
        }
      }
    }

    function lib$es6$promise$asap$$setScheduler(scheduleFn) {
      lib$es6$promise$asap$$customSchedulerFn = scheduleFn;
    }

    function lib$es6$promise$asap$$setAsap(asapFn) {
      lib$es6$promise$asap$$asap = asapFn;
    }

    var lib$es6$promise$asap$$browserWindow = (typeof window !== 'undefined') ? window : undefined;
    var lib$es6$promise$asap$$browserGlobal = lib$es6$promise$asap$$browserWindow || {};
    var lib$es6$promise$asap$$BrowserMutationObserver = lib$es6$promise$asap$$browserGlobal.MutationObserver || lib$es6$promise$asap$$browserGlobal.WebKitMutationObserver;
    var lib$es6$promise$asap$$isNode = typeof process !== 'undefined' && {}.toString.call(process) === '[object process]';

    // test for web worker but not in IE10
    var lib$es6$promise$asap$$isWorker = typeof Uint8ClampedArray !== 'undefined' &&
      typeof importScripts !== 'undefined' &&
      typeof MessageChannel !== 'undefined';

    // node
    function lib$es6$promise$asap$$useNextTick() {
      var nextTick = process.nextTick;
      // node version 0.10.x displays a deprecation warning when nextTick is used recursively
      // setImmediate should be used instead instead
      var version = process.versions.node.match(/^(?:(\d+)\.)?(?:(\d+)\.)?(\*|\d+)$/);
      if (Array.isArray(version) && version[1] === '0' && version[2] === '10') {
        nextTick = setImmediate;
      }
      return function() {
        nextTick(lib$es6$promise$asap$$flush);
      };
    }

    // vertx
    function lib$es6$promise$asap$$useVertxTimer() {
      return function() {
        lib$es6$promise$asap$$vertxNext(lib$es6$promise$asap$$flush);
      };
    }

    function lib$es6$promise$asap$$useMutationObserver() {
      var iterations = 0;
      var observer = new lib$es6$promise$asap$$BrowserMutationObserver(lib$es6$promise$asap$$flush);
      var node = document.createTextNode('');
      observer.observe(node, { characterData: true });

      return function() {
        node.data = (iterations = ++iterations % 2);
      };
    }

    // web worker
    function lib$es6$promise$asap$$useMessageChannel() {
      var channel = new MessageChannel();
      channel.port1.onmessage = lib$es6$promise$asap$$flush;
      return function () {
        channel.port2.postMessage(0);
      };
    }

    function lib$es6$promise$asap$$useSetTimeout() {
      return function() {
        setTimeout(lib$es6$promise$asap$$flush, 1);
      };
    }

    var lib$es6$promise$asap$$queue = new Array(1000);
    function lib$es6$promise$asap$$flush() {
      for (var i = 0; i < lib$es6$promise$asap$$len; i+=2) {
        var callback = lib$es6$promise$asap$$queue[i];
        var arg = lib$es6$promise$asap$$queue[i+1];

        callback(arg);

        lib$es6$promise$asap$$queue[i] = undefined;
        lib$es6$promise$asap$$queue[i+1] = undefined;
      }

      lib$es6$promise$asap$$len = 0;
    }

    function lib$es6$promise$asap$$attemptVertex() {
      try {
        var r = require;
        var vertx = r('vertx');
        lib$es6$promise$asap$$vertxNext = vertx.runOnLoop || vertx.runOnContext;
        return lib$es6$promise$asap$$useVertxTimer();
      } catch(e) {
        return lib$es6$promise$asap$$useSetTimeout();
      }
    }

    var lib$es6$promise$asap$$scheduleFlush;
    // Decide what async method to use to triggering processing of queued callbacks:
    if (lib$es6$promise$asap$$isNode) {
      lib$es6$promise$asap$$scheduleFlush = lib$es6$promise$asap$$useNextTick();
    } else if (lib$es6$promise$asap$$BrowserMutationObserver) {
      lib$es6$promise$asap$$scheduleFlush = lib$es6$promise$asap$$useMutationObserver();
    } else if (lib$es6$promise$asap$$isWorker) {
      lib$es6$promise$asap$$scheduleFlush = lib$es6$promise$asap$$useMessageChannel();
    } else if (lib$es6$promise$asap$$browserWindow === undefined && typeof require === 'function') {
      lib$es6$promise$asap$$scheduleFlush = lib$es6$promise$asap$$attemptVertex();
    } else {
      lib$es6$promise$asap$$scheduleFlush = lib$es6$promise$asap$$useSetTimeout();
    }

    function lib$es6$promise$$internal$$noop() {}

    var lib$es6$promise$$internal$$PENDING   = void 0;
    var lib$es6$promise$$internal$$FULFILLED = 1;
    var lib$es6$promise$$internal$$REJECTED  = 2;

    var lib$es6$promise$$internal$$GET_THEN_ERROR = new lib$es6$promise$$internal$$ErrorObject();

    function lib$es6$promise$$internal$$selfFullfillment() {
      return new TypeError("You cannot resolve a promise with itself");
    }

    function lib$es6$promise$$internal$$cannotReturnOwn() {
      return new TypeError('A promises callback cannot return that same promise.');
    }

    function lib$es6$promise$$internal$$getThen(promise) {
      try {
        return promise.then;
      } catch(error) {
        lib$es6$promise$$internal$$GET_THEN_ERROR.error = error;
        return lib$es6$promise$$internal$$GET_THEN_ERROR;
      }
    }

    function lib$es6$promise$$internal$$tryThen(then, value, fulfillmentHandler, rejectionHandler) {
      try {
        then.call(value, fulfillmentHandler, rejectionHandler);
      } catch(e) {
        return e;
      }
    }

    function lib$es6$promise$$internal$$handleForeignThenable(promise, thenable, then) {
       lib$es6$promise$asap$$asap(function(promise) {
        var sealed = false;
        var error = lib$es6$promise$$internal$$tryThen(then, thenable, function(value) {
          if (sealed) { return; }
          sealed = true;
          if (thenable !== value) {
            lib$es6$promise$$internal$$resolve(promise, value);
          } else {
            lib$es6$promise$$internal$$fulfill(promise, value);
          }
        }, function(reason) {
          if (sealed) { return; }
          sealed = true;

          lib$es6$promise$$internal$$reject(promise, reason);
        }, 'Settle: ' + (promise._label || ' unknown promise'));

        if (!sealed && error) {
          sealed = true;
          lib$es6$promise$$internal$$reject(promise, error);
        }
      }, promise);
    }

    function lib$es6$promise$$internal$$handleOwnThenable(promise, thenable) {
      if (thenable._state === lib$es6$promise$$internal$$FULFILLED) {
        lib$es6$promise$$internal$$fulfill(promise, thenable._result);
      } else if (thenable._state === lib$es6$promise$$internal$$REJECTED) {
        lib$es6$promise$$internal$$reject(promise, thenable._result);
      } else {
        lib$es6$promise$$internal$$subscribe(thenable, undefined, function(value) {
          lib$es6$promise$$internal$$resolve(promise, value);
        }, function(reason) {
          lib$es6$promise$$internal$$reject(promise, reason);
        });
      }
    }

    function lib$es6$promise$$internal$$handleMaybeThenable(promise, maybeThenable) {
      if (maybeThenable.constructor === promise.constructor) {
        lib$es6$promise$$internal$$handleOwnThenable(promise, maybeThenable);
      } else {
        var then = lib$es6$promise$$internal$$getThen(maybeThenable);

        if (then === lib$es6$promise$$internal$$GET_THEN_ERROR) {
          lib$es6$promise$$internal$$reject(promise, lib$es6$promise$$internal$$GET_THEN_ERROR.error);
        } else if (then === undefined) {
          lib$es6$promise$$internal$$fulfill(promise, maybeThenable);
        } else if (lib$es6$promise$utils$$isFunction(then)) {
          lib$es6$promise$$internal$$handleForeignThenable(promise, maybeThenable, then);
        } else {
          lib$es6$promise$$internal$$fulfill(promise, maybeThenable);
        }
      }
    }

    function lib$es6$promise$$internal$$resolve(promise, value) {
      if (promise === value) {
        lib$es6$promise$$internal$$reject(promise, lib$es6$promise$$internal$$selfFullfillment());
      } else if (lib$es6$promise$utils$$objectOrFunction(value)) {
        lib$es6$promise$$internal$$handleMaybeThenable(promise, value);
      } else {
        lib$es6$promise$$internal$$fulfill(promise, value);
      }
    }

    function lib$es6$promise$$internal$$publishRejection(promise) {
      if (promise._onerror) {
        promise._onerror(promise._result);
      }

      lib$es6$promise$$internal$$publish(promise);
    }

    function lib$es6$promise$$internal$$fulfill(promise, value) {
      if (promise._state !== lib$es6$promise$$internal$$PENDING) { return; }

      promise._result = value;
      promise._state = lib$es6$promise$$internal$$FULFILLED;

      if (promise._subscribers.length !== 0) {
        lib$es6$promise$asap$$asap(lib$es6$promise$$internal$$publish, promise);
      }
    }

    function lib$es6$promise$$internal$$reject(promise, reason) {
      if (promise._state !== lib$es6$promise$$internal$$PENDING) { return; }
      promise._state = lib$es6$promise$$internal$$REJECTED;
      promise._result = reason;

      lib$es6$promise$asap$$asap(lib$es6$promise$$internal$$publishRejection, promise);
    }

    function lib$es6$promise$$internal$$subscribe(parent, child, onFulfillment, onRejection) {
      var subscribers = parent._subscribers;
      var length = subscribers.length;

      parent._onerror = null;

      subscribers[length] = child;
      subscribers[length + lib$es6$promise$$internal$$FULFILLED] = onFulfillment;
      subscribers[length + lib$es6$promise$$internal$$REJECTED]  = onRejection;

      if (length === 0 && parent._state) {
        lib$es6$promise$asap$$asap(lib$es6$promise$$internal$$publish, parent);
      }
    }

    function lib$es6$promise$$internal$$publish(promise) {
      var subscribers = promise._subscribers;
      var settled = promise._state;

      if (subscribers.length === 0) { return; }

      var child, callback, detail = promise._result;

      for (var i = 0; i < subscribers.length; i += 3) {
        child = subscribers[i];
        callback = subscribers[i + settled];

        if (child) {
          lib$es6$promise$$internal$$invokeCallback(settled, child, callback, detail);
        } else {
          callback(detail);
        }
      }

      promise._subscribers.length = 0;
    }

    function lib$es6$promise$$internal$$ErrorObject() {
      this.error = null;
    }

    var lib$es6$promise$$internal$$TRY_CATCH_ERROR = new lib$es6$promise$$internal$$ErrorObject();

    function lib$es6$promise$$internal$$tryCatch(callback, detail) {
      try {
        return callback(detail);
      } catch(e) {
        console.error(e);
        lib$es6$promise$$internal$$TRY_CATCH_ERROR.error = e;
        return lib$es6$promise$$internal$$TRY_CATCH_ERROR;
      }
    }

    function lib$es6$promise$$internal$$invokeCallback(settled, promise, callback, detail) {
      var hasCallback = lib$es6$promise$utils$$isFunction(callback),
          value, error, succeeded, failed;

      if (hasCallback) {
        value = lib$es6$promise$$internal$$tryCatch(callback, detail);

        if (value === lib$es6$promise$$internal$$TRY_CATCH_ERROR) {
          failed = true;
          error = value.error;
          value = null;
        } else {
          succeeded = true;
        }

        if (promise === value) {
          lib$es6$promise$$internal$$reject(promise, lib$es6$promise$$internal$$cannotReturnOwn());
          return;
        }

      } else {
        value = detail;
        succeeded = true;
      }

      if (promise._state !== lib$es6$promise$$internal$$PENDING) {
        // noop
      } else if (hasCallback && succeeded) {
        lib$es6$promise$$internal$$resolve(promise, value);
      } else if (failed) {
        lib$es6$promise$$internal$$reject(promise, error);
      } else if (settled === lib$es6$promise$$internal$$FULFILLED) {
        lib$es6$promise$$internal$$fulfill(promise, value);
      } else if (settled === lib$es6$promise$$internal$$REJECTED) {
        lib$es6$promise$$internal$$reject(promise, value);
      }
    }

    function lib$es6$promise$$internal$$initializePromise(promise, resolver) {
      try {
        resolver(function resolvePromise(value){
          lib$es6$promise$$internal$$resolve(promise, value);
        }, function rejectPromise(reason) {
          lib$es6$promise$$internal$$reject(promise, reason);
        });
      } catch(e) {
        lib$es6$promise$$internal$$reject(promise, e);
      }
    }

    function lib$es6$promise$enumerator$$Enumerator(Constructor, input) {
      var enumerator = this;

      enumerator._instanceConstructor = Constructor;
      enumerator.promise = new Constructor(lib$es6$promise$$internal$$noop);

      if (enumerator._validateInput(input)) {
        enumerator._input     = input;
        enumerator.length     = input.length;
        enumerator._remaining = input.length;

        enumerator._init();

        if (enumerator.length === 0) {
          lib$es6$promise$$internal$$fulfill(enumerator.promise, enumerator._result);
        } else {
          enumerator.length = enumerator.length || 0;
          enumerator._enumerate();
          if (enumerator._remaining === 0) {
            lib$es6$promise$$internal$$fulfill(enumerator.promise, enumerator._result);
          }
        }
      } else {
        lib$es6$promise$$internal$$reject(enumerator.promise, enumerator._validationError());
      }
    }

    lib$es6$promise$enumerator$$Enumerator.prototype._validateInput = function(input) {
      return lib$es6$promise$utils$$isArray(input);
    };

    lib$es6$promise$enumerator$$Enumerator.prototype._validationError = function() {
      return new Error('Array Methods must be provided an Array');
    };

    lib$es6$promise$enumerator$$Enumerator.prototype._init = function() {
      this._result = new Array(this.length);
    };

    var lib$es6$promise$enumerator$$default = lib$es6$promise$enumerator$$Enumerator;

    lib$es6$promise$enumerator$$Enumerator.prototype._enumerate = function() {
      var enumerator = this;

      var length  = enumerator.length;
      var promise = enumerator.promise;
      var input   = enumerator._input;

      for (var i = 0; promise._state === lib$es6$promise$$internal$$PENDING && i < length; i++) {
        enumerator._eachEntry(input[i], i);
      }
    };

    lib$es6$promise$enumerator$$Enumerator.prototype._eachEntry = function(entry, i) {
      var enumerator = this;
      var c = enumerator._instanceConstructor;

      if (lib$es6$promise$utils$$isMaybeThenable(entry)) {
        if (entry.constructor === c && entry._state !== lib$es6$promise$$internal$$PENDING) {
          entry._onerror = null;
          enumerator._settledAt(entry._state, i, entry._result);
        } else {
          enumerator._willSettleAt(c.resolve(entry), i);
        }
      } else {
        enumerator._remaining--;
        enumerator._result[i] = entry;
      }
    };

    lib$es6$promise$enumerator$$Enumerator.prototype._settledAt = function(state, i, value) {
      var enumerator = this;
      var promise = enumerator.promise;

      if (promise._state === lib$es6$promise$$internal$$PENDING) {
        enumerator._remaining--;

        if (state === lib$es6$promise$$internal$$REJECTED) {
          lib$es6$promise$$internal$$reject(promise, value);
        } else {
          enumerator._result[i] = value;
        }
      }

      if (enumerator._remaining === 0) {
        lib$es6$promise$$internal$$fulfill(promise, enumerator._result);
      }
    };

    lib$es6$promise$enumerator$$Enumerator.prototype._willSettleAt = function(promise, i) {
      var enumerator = this;

      lib$es6$promise$$internal$$subscribe(promise, undefined, function(value) {
        enumerator._settledAt(lib$es6$promise$$internal$$FULFILLED, i, value);
      }, function(reason) {
        enumerator._settledAt(lib$es6$promise$$internal$$REJECTED, i, reason);
      });
    };
    function lib$es6$promise$promise$all$$all(entries) {
      return new lib$es6$promise$enumerator$$default(this, entries).promise;
    }
    var lib$es6$promise$promise$all$$default = lib$es6$promise$promise$all$$all;
    function lib$es6$promise$promise$race$$race(entries) {
      /*jshint validthis:true */
      var Constructor = this;

      var promise = new Constructor(lib$es6$promise$$internal$$noop);

      if (!lib$es6$promise$utils$$isArray(entries)) {
        lib$es6$promise$$internal$$reject(promise, new TypeError('You must pass an array to race.'));
        return promise;
      }

      var length = entries.length;

      function onFulfillment(value) {
        lib$es6$promise$$internal$$resolve(promise, value);
      }

      function onRejection(reason) {
        lib$es6$promise$$internal$$reject(promise, reason);
      }

      for (var i = 0; promise._state === lib$es6$promise$$internal$$PENDING && i < length; i++) {
        lib$es6$promise$$internal$$subscribe(Constructor.resolve(entries[i]), undefined, onFulfillment, onRejection);
      }

      return promise;
    }
    var lib$es6$promise$promise$race$$default = lib$es6$promise$promise$race$$race;
    function lib$es6$promise$promise$resolve$$resolve(object) {
      /*jshint validthis:true */
      var Constructor = this;

      if (object && typeof object === 'object' && object.constructor === Constructor) {
        return object;
      }

      var promise = new Constructor(lib$es6$promise$$internal$$noop);
      lib$es6$promise$$internal$$resolve(promise, object);
      return promise;
    }
    var lib$es6$promise$promise$resolve$$default = lib$es6$promise$promise$resolve$$resolve;
    function lib$es6$promise$promise$reject$$reject(reason) {
      /*jshint validthis:true */
      var Constructor = this;
      var promise = new Constructor(lib$es6$promise$$internal$$noop);
      lib$es6$promise$$internal$$reject(promise, reason);
      return promise;
    }
    var lib$es6$promise$promise$reject$$default = lib$es6$promise$promise$reject$$reject;

    var lib$es6$promise$promise$$counter = 0;

    function lib$es6$promise$promise$$needsResolver() {
      throw new TypeError('You must pass a resolver function as the first argument to the promise constructor');
    }

    function lib$es6$promise$promise$$needsNew() {
      throw new TypeError("Failed to construct 'Promise': Please use the 'new' operator, this object constructor cannot be called as a function.");
    }

    var lib$es6$promise$promise$$default = lib$es6$promise$promise$$Promise;
    /*
      Promise objects represent the eventual result of an asynchronous operation. The
      primary way of interacting with a promise is through its `then` method, which
      registers callbacks to receive either a promise's eventual value or the reason
      why the promise cannot be fulfilled.

      Terminology
      -----------

      - `promise` is an object or function with a `then` method whose behavior conforms to this specification.
      - `thenable` is an object or function that defines a `then` method.
      - `value` is any legal JavaScript value (including undefined, a thenable, or a promise).
      - `exception` is a value that is thrown using the throw statement.
      - `reason` is a value that indicates why a promise was rejected.
      - `settled` the final resting state of a promise, fulfilled or rejected.

      A promise can be in one of three states: pending, fulfilled, or rejected.

      Promises that are fulfilled have a fulfillment value and are in the fulfilled
      state.  Promises that are rejected have a rejection reason and are in the
      rejected state.  A fulfillment value is never a thenable.

      Promises can also be said to *resolve* a value.  If this value is also a
      promise, then the original promise's settled state will match the value's
      settled state.  So a promise that *resolves* a promise that rejects will
      itself reject, and a promise that *resolves* a promise that fulfills will
      itself fulfill.


      Basic Usage:
      ------------

      ```js
      var promise = new Promise(function(resolve, reject) {
        // on success
        resolve(value);

        // on failure
        reject(reason);
      });

      promise.then(function(value) {
        // on fulfillment
      }, function(reason) {
        // on rejection
      });
      ```

      Advanced Usage:
      ---------------

      Promises shine when abstracting away asynchronous interactions such as
      `XMLHttpRequest`s.

      ```js
      function getJSON(url) {
        return new Promise(function(resolve, reject){
          var xhr = new XMLHttpRequest();

          xhr.open('GET', url);
          xhr.onreadystatechange = handler;
          xhr.responseType = 'json';
          xhr.setRequestHeader('Accept', 'application/json');
          xhr.send();

          function handler() {
            if (this.readyState === this.DONE) {
              if (this.status === 200) {
                resolve(this.response);
              } else {
                reject(new Error('getJSON: `' + url + '` failed with status: [' + this.status + ']'));
              }
            }
          };
        });
      }

      getJSON('/posts.json').then(function(json) {
        // on fulfillment
      }, function(reason) {
        // on rejection
      });
      ```

      Unlike callbacks, promises are great composable primitives.

      ```js
      Promise.all([
        getJSON('/posts'),
        getJSON('/comments')
      ]).then(function(values){
        values[0] // => postsJSON
        values[1] // => commentsJSON

        return values;
      });
      ```

      @class Promise
      @param {function} resolver
      Useful for tooling.
      @constructor
    */
    function lib$es6$promise$promise$$Promise(resolver) {
      this._id = lib$es6$promise$promise$$counter++;
      this._state = undefined;
      this._result = undefined;
      this._subscribers = [];

      if (lib$es6$promise$$internal$$noop !== resolver) {
        if (!lib$es6$promise$utils$$isFunction(resolver)) {
          lib$es6$promise$promise$$needsResolver();
        }

        if (!(this instanceof lib$es6$promise$promise$$Promise)) {
          lib$es6$promise$promise$$needsNew();
        }

        lib$es6$promise$$internal$$initializePromise(this, resolver);
      }
    }

    lib$es6$promise$promise$$Promise.all = lib$es6$promise$promise$all$$default;
    lib$es6$promise$promise$$Promise.race = lib$es6$promise$promise$race$$default;
    lib$es6$promise$promise$$Promise.resolve = lib$es6$promise$promise$resolve$$default;
    lib$es6$promise$promise$$Promise.reject = lib$es6$promise$promise$reject$$default;
    lib$es6$promise$promise$$Promise._setScheduler = lib$es6$promise$asap$$setScheduler;
    lib$es6$promise$promise$$Promise._setAsap = lib$es6$promise$asap$$setAsap;
    lib$es6$promise$promise$$Promise._asap = lib$es6$promise$asap$$asap;

    lib$es6$promise$promise$$Promise.prototype = {
      constructor: lib$es6$promise$promise$$Promise,
    /*
      The primary way of interacting with a promise is through its `then` method,
      which registers callbacks to receive either a promise's eventual value or the
      reason why the promise cannot be fulfilled.

      ```js
      findUser().then(function(user){
        // user is available
      }, function(reason){
        // user is unavailable, and you are given the reason why
      });
      ```

      Chaining
      --------

      The return value of `then` is itself a promise.  This second, 'downstream'
      promise is resolved with the return value of the first promise's fulfillment
      or rejection handler, or rejected if the handler throws an exception.

      ```js
      findUser().then(function (user) {
        return user.name;
      }, function (reason) {
        return 'default name';
      }).then(function (userName) {
        // If `findUser` fulfilled, `userName` will be the user's name, otherwise it
        // will be `'default name'`
      });

      findUser().then(function (user) {
        throw new Error('Found user, but still unhappy');
      }, function (reason) {
        throw new Error('`findUser` rejected and we're unhappy');
      }).then(function (value) {
        // never reached
      }, function (reason) {
        // if `findUser` fulfilled, `reason` will be 'Found user, but still unhappy'.
        // If `findUser` rejected, `reason` will be '`findUser` rejected and we're unhappy'.
      });
      ```
      If the downstream promise does not specify a rejection handler, rejection reasons will be propagated further downstream.

      ```js
      findUser().then(function (user) {
        throw new PedagogicalException('Upstream error');
      }).then(function (value) {
        // never reached
      }).then(function (value) {
        // never reached
      }, function (reason) {
        // The `PedgagocialException` is propagated all the way down to here
      });
      ```

      Assimilation
      ------------

      Sometimes the value you want to propagate to a downstream promise can only be
      retrieved asynchronously. This can be achieved by returning a promise in the
      fulfillment or rejection handler. The downstream promise will then be pending
      until the returned promise is settled. This is called *assimilation*.

      ```js
      findUser().then(function (user) {
        return findCommentsByAuthor(user);
      }).then(function (comments) {
        // The user's comments are now available
      });
      ```

      If the assimliated promise rejects, then the downstream promise will also reject.

      ```js
      findUser().then(function (user) {
        return findCommentsByAuthor(user);
      }).then(function (comments) {
        // If `findCommentsByAuthor` fulfills, we'll have the value here
      }, function (reason) {
        // If `findCommentsByAuthor` rejects, we'll have the reason here
      });
      ```

      Simple Example
      --------------

      Synchronous Example

      ```javascript
      var result;

      try {
        result = findResult();
        // success
      } catch(reason) {
        // failure
      }
      ```

      Errback Example

      ```js
      findResult(function(result, err){
        if (err) {
          // failure
        } else {
          // success
        }
      });
      ```

      Promise Example;

      ```javascript
      findResult().then(function(result){
        // success
      }, function(reason){
        // failure
      });
      ```

      Advanced Example
      --------------

      Synchronous Example

      ```javascript
      var author, books;

      try {
        author = findAuthor();
        books  = findBooksByAuthor(author);
        // success
      } catch(reason) {
        // failure
      }
      ```

      Errback Example

      ```js

      function foundBooks(books) {

      }

      function failure(reason) {

      }

      findAuthor(function(author, err){
        if (err) {
          failure(err);
          // failure
        } else {
          try {
            findBoooksByAuthor(author, function(books, err) {
              if (err) {
                failure(err);
              } else {
                try {
                  foundBooks(books);
                } catch(reason) {
                  failure(reason);
                }
              }
            });
          } catch(error) {
            failure(err);
          }
          // success
        }
      });
      ```

      Promise Example;

      ```javascript
      findAuthor().
        then(findBooksByAuthor).
        then(function(books){
          // found books
      }).catch(function(reason){
        // something went wrong
      });
      ```

      @method then
      @param {Function} onFulfilled
      @param {Function} onRejected
      Useful for tooling.
      @return {Promise}
    */
      then: function(onFulfillment, onRejection) {
        var parent = this;
        var state = parent._state;

        if (state === lib$es6$promise$$internal$$FULFILLED && !onFulfillment || state === lib$es6$promise$$internal$$REJECTED && !onRejection) {
          return this;
        }

        var child = new this.constructor(lib$es6$promise$$internal$$noop);
        var result = parent._result;

        if (state) {
          var callback = arguments[state - 1];
          lib$es6$promise$asap$$asap(function(){
            lib$es6$promise$$internal$$invokeCallback(state, child, callback, result);
          });
        } else {
          lib$es6$promise$$internal$$subscribe(parent, child, onFulfillment, onRejection);
        }

        return child;
    },
    /*
      `catch` is simply sugar for `then(undefined, onRejection)` which makes it the same
      as the catch block of a try/catch statement.

      ```js
      function findAuthor(){
        throw new Error('couldn't find that author');
      }

      // synchronous
      try {
        findAuthor();
      } catch(reason) {
        // something went wrong
      }

      // async with promises
      findAuthor().catch(function(reason){
        // something went wrong
      });
      ```

      @method catch
      @param {Function} onRejection
      Useful for tooling.
      @return {Promise}
    */
      'catch':function(onRejection) {
        return this.then(null, onRejection);
      }
  };


    function lib$es6$promise$polyfill$$polyfill() {
      var local;

      if (typeof global !== 'undefined') {
          local = global;
      } else if (typeof self !== 'undefined') {
          local = self;
      } else {
          try {
              local = Function('return this')();
          } catch (e) {
              throw new Error('polyfill failed because global object is unavailable in this environment');
          }
      }

      var P = local.Promise;

      if (P && Object.prototype.toString.call(P.resolve()) === '[object Promise]' && !P.cast) {
        return;
      }

      local.Promise = lib$es6$promise$promise$$default;
    }
    var lib$es6$promise$polyfill$$default = lib$es6$promise$polyfill$$polyfill;

    var lib$es6$promise$umd$$ES6Promise = {
      'Promise': lib$es6$promise$promise$$default,
      'polyfill': lib$es6$promise$polyfill$$default
    };

    /* global define:true module:true window: true */
    if (typeof define === 'function' && define['amd']) {
      define(function() { return lib$es6$promise$umd$$ES6Promise; });
    } else if (typeof module !== 'undefined' && module['exports']) {
      module['exports'] = lib$es6$promise$umd$$ES6Promise;
    } else if (typeof this !== 'undefined') {
      this['ES6Promise'] = lib$es6$promise$umd$$ES6Promise;
    }

    lib$es6$promise$polyfill$$default();
}).call(this);


// http://paulirish.com/2011/requestanimationframe-for-smart-animating/
// http://my.opera.com/emoller/blog/2011/12/20/requestanimationframe-for-smart-er-animating

// requestAnimationFrame polyfill by Erik Möller. fixes from Paul Irish and Tino Zijdel
// refactored by Yannick Albert

// MIT license
(function(window) {
    var equestAnimationFrame = 'equestAnimationFrame',
        requestAnimationFrame = 'r' + equestAnimationFrame,

        ancelAnimationFrame = 'ancelAnimationFrame',
        cancelAnimationFrame = 'c' + ancelAnimationFrame,

        expectedTime = 0,
        vendors = ['moz', 'ms', 'o', 'webkit'],
        vendor;

    while(!window[requestAnimationFrame] && (vendor = vendors.pop())) {
        window[requestAnimationFrame] = window[vendor + 'R' + equestAnimationFrame];
        window[cancelAnimationFrame] = window[vendor + 'C' + ancelAnimationFrame] || window[vendor + 'CancelR' + equestAnimationFrame];
    }

    if(!window[requestAnimationFrame]) {
        window[requestAnimationFrame] = function(callback) {
            var currentTime = new Date().getTime(),
                adjustedDelay = 16 - (currentTime - expectedTime),
                delay = adjustedDelay > 0 ? adjustedDelay : 0;

            expectedTime = currentTime + delay;

            return setTimeout(function() {
                callback(expectedTime);
            }, delay);
        };

        window[cancelAnimationFrame] = clearTimeout;
    }
}(this));

//https://gist.github.com/jonathantneal/3062955
this.Element && function(ElementPrototype) {
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


// EventListener | MIT/GPL2 | github.com/jonathantneal/EventListener
this.Element && Element.prototype.attachEvent && !Element.prototype.addEventListener && (function () {
  function addToPrototype(name, method) {
    Window.prototype[name] = HTMLDocument.prototype[name] = Element.prototype[name] = method;
  }

  // add
  addToPrototype("addEventListener", function (type, listener) {
    var
    target = this,
    listeners = target.addEventListener.listeners = target.addEventListener.listeners || {},
    typeListeners = listeners[type] = listeners[type] || [];

    // if no events exist, attach the listener
    if (!typeListeners.length) {
      target.attachEvent("on" + type, typeListeners.event = function (event) {
        var documentElement = target.document && target.document.documentElement || target.documentElement || { scrollLeft: 0, scrollTop: 0 };

        // polyfill w3c properties and methods
        event.currentTarget = target;
        event.pageX = event.clientX + documentElement.scrollLeft;
        event.pageY = event.clientY + documentElement.scrollTop;
        event.preventDefault = function () { event.returnValue = false };
        event.relatedTarget = event.fromElement || null;
        event.stopImmediatePropagation = function () { immediatePropagation = false; event.cancelBubble = true };
        event.stopPropagation = function () { event.cancelBubble = true };
        event.relatedTarget = event.fromElement || null;
        event.target = event.srcElement || target;
        event.timeStamp = +new Date;

        // create an cached list of the master events list (to protect this loop from breaking when an event is removed)
        for (var i = 0, typeListenersCache = [].concat(typeListeners), typeListenerCache, immediatePropagation = true; immediatePropagation && (typeListenerCache = typeListenersCache[i]); ++i) {
          // check to see if the cached event still exists in the master events list
          for (var ii = 0, typeListener; typeListener = typeListeners[ii]; ++ii) {
            if (typeListener == typeListenerCache) {
              typeListener.call(target, event);

              break;
            }
          }
        }
      });
    }

    // add the event to the master event list
    typeListeners.push(listener);
  });

  // remove
  addToPrototype("removeEventListener", function (type, listener) {
    var
    target = this,
    listeners = target.addEventListener.listeners = target.addEventListener.listeners || {},
    typeListeners = listeners[type] = listeners[type] || [];

    // remove the newest matching event from the master event list
    for (var i = typeListeners.length - 1, typeListener; typeListener = typeListeners[i]; --i) {
      if (typeListener == listener) {
        typeListeners.splice(i, 1);

        break;
      }
    }

    // if no events exist, detach the listener
    if (!typeListeners.length && typeListeners.event) {
      target.detachEvent("on" + type, typeListeners.event);
    }
  });

  // dispatch
  addToPrototype("dispatchEvent", function (eventObject) {
    var
    target = this,
    type = eventObject.type,
    listeners = target.addEventListener.listeners = target.addEventListener.listeners || {},
    typeListeners = listeners[type] = listeners[type] || [];

    try {
      return target.fireEvent("on" + type, eventObject);
    } catch (error) {
      if (typeListeners.event) {
        typeListeners.event(eventObject);
      }

      return;
    }
  });

  // CustomEvent
  Object.defineProperty(Window.prototype, "CustomEvent", {
    get: function () {
      var self = this;

      return function CustomEvent(type, detail) {
        detail = detail || {};
        var event = self.document.createEventObject(), key;

        event.type = type;
        event.returnValue = !detail.cancelable;
        event.cancelBubble = !detail.bubbles;

        for (key in detail) {
          event[key] = detail[key];
        }

        return event;
      };
    }
  });

  // ready
  function ready(event) {
    if (ready.interval && document.body) {
      ready.interval = clearInterval(ready.interval);

      document.dispatchEvent(new CustomEvent("DOMContentLoaded"));
    }
  }

  ready.interval = setInterval(ready, 1);

  window.addEventListener("load", ready);
})();
;/**!

 @license
 handlebars v4.0.6

Copyright (C) 2011-2016 by Yehuda Katz

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/
/**!

 @license
 handlebars v4.0.6

Copyright (C) 2011-2016 by Yehuda Katz

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/
/**!

 @license
 handlebars v4.0.6

Copyright (C) 2011-2016 by Yehuda Katz

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/
(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory();
	else if(typeof define === 'function' && define.amd)
		define([], factory);
	else if(typeof exports === 'object')
		exports["Handlebars"] = factory();
	else
		root["Handlebars"] = factory();
})(this, function() {
return /******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var _interopRequireDefault = __webpack_require__(1)['default'];

	exports.__esModule = true;

	var _handlebarsRuntime = __webpack_require__(2);

	var _handlebarsRuntime2 = _interopRequireDefault(_handlebarsRuntime);

	// Compiler imports

	var _handlebarsCompilerAst = __webpack_require__(24);

	var _handlebarsCompilerAst2 = _interopRequireDefault(_handlebarsCompilerAst);

	var _handlebarsCompilerBase = __webpack_require__(25);

	var _handlebarsCompilerCompiler = __webpack_require__(30);

	var _handlebarsCompilerJavascriptCompiler = __webpack_require__(31);

	var _handlebarsCompilerJavascriptCompiler2 = _interopRequireDefault(_handlebarsCompilerJavascriptCompiler);

	var _handlebarsCompilerVisitor = __webpack_require__(28);

	var _handlebarsCompilerVisitor2 = _interopRequireDefault(_handlebarsCompilerVisitor);

	var _handlebarsNoConflict = __webpack_require__(23);

	var _handlebarsNoConflict2 = _interopRequireDefault(_handlebarsNoConflict);

	var _create = _handlebarsRuntime2['default'].create;
	function create() {
	  var hb = _create();

	  hb.compile = function (input, options) {
	    return _handlebarsCompilerCompiler.compile(input, options, hb);
	  };
	  hb.precompile = function (input, options) {
	    return _handlebarsCompilerCompiler.precompile(input, options, hb);
	  };

	  hb.AST = _handlebarsCompilerAst2['default'];
	  hb.Compiler = _handlebarsCompilerCompiler.Compiler;
	  hb.JavaScriptCompiler = _handlebarsCompilerJavascriptCompiler2['default'];
	  hb.Parser = _handlebarsCompilerBase.parser;
	  hb.parse = _handlebarsCompilerBase.parse;

	  return hb;
	}

	var inst = create();
	inst.create = create;

	_handlebarsNoConflict2['default'](inst);

	inst.Visitor = _handlebarsCompilerVisitor2['default'];

	inst['default'] = inst;

	exports['default'] = inst;
	module.exports = exports['default'];

/***/ },
/* 1 */
/***/ function(module, exports) {

	"use strict";

	exports["default"] = function (obj) {
	  return obj && obj.__esModule ? obj : {
	    "default": obj
	  };
	};

	exports.__esModule = true;

/***/ },
/* 2 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var _interopRequireWildcard = __webpack_require__(3)['default'];

	var _interopRequireDefault = __webpack_require__(1)['default'];

	exports.__esModule = true;

	var _handlebarsBase = __webpack_require__(4);

	var base = _interopRequireWildcard(_handlebarsBase);

	// Each of these augment the Handlebars object. No need to setup here.
	// (This is done to easily share code between commonjs and browse envs)

	var _handlebarsSafeString = __webpack_require__(21);

	var _handlebarsSafeString2 = _interopRequireDefault(_handlebarsSafeString);

	var _handlebarsException = __webpack_require__(6);

	var _handlebarsException2 = _interopRequireDefault(_handlebarsException);

	var _handlebarsUtils = __webpack_require__(5);

	var Utils = _interopRequireWildcard(_handlebarsUtils);

	var _handlebarsRuntime = __webpack_require__(22);

	var runtime = _interopRequireWildcard(_handlebarsRuntime);

	var _handlebarsNoConflict = __webpack_require__(23);

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

/***/ },
/* 3 */
/***/ function(module, exports) {

	"use strict";

	exports["default"] = function (obj) {
	  if (obj && obj.__esModule) {
	    return obj;
	  } else {
	    var newObj = {};

	    if (obj != null) {
	      for (var key in obj) {
	        if (Object.prototype.hasOwnProperty.call(obj, key)) newObj[key] = obj[key];
	      }
	    }

	    newObj["default"] = obj;
	    return newObj;
	  }
	};

	exports.__esModule = true;

/***/ },
/* 4 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var _interopRequireDefault = __webpack_require__(1)['default'];

	exports.__esModule = true;
	exports.HandlebarsEnvironment = HandlebarsEnvironment;

	var _utils = __webpack_require__(5);

	var _exception = __webpack_require__(6);

	var _exception2 = _interopRequireDefault(_exception);

	var _helpers = __webpack_require__(10);

	var _decorators = __webpack_require__(18);

	var _logger = __webpack_require__(20);

	var _logger2 = _interopRequireDefault(_logger);

	var VERSION = '4.0.5';
	exports.VERSION = VERSION;
	var COMPILER_REVISION = 7;

	exports.COMPILER_REVISION = COMPILER_REVISION;
	var REVISION_CHANGES = {
	  1: '<= 1.0.rc.2', // 1.0.rc.2 is actually rev2 but doesn't report it
	  2: '== 1.0.0-rc.3',
	  3: '== 1.0.0-rc.4',
	  4: '== 1.x.x',
	  5: '== 2.0.0-alpha.x',
	  6: '>= 2.0.0-beta.1',
	  7: '>= 4.0.0'
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
	  }
	};

	var log = _logger2['default'].log;

	exports.log = log;
	exports.createFrame = _utils.createFrame;
	exports.logger = _logger2['default'];

/***/ },
/* 5 */
/***/ function(module, exports) {

	'use strict';

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

/***/ },
/* 6 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var _Object$defineProperty = __webpack_require__(7)['default'];

	exports.__esModule = true;

	var errorProps = ['description', 'fileName', 'lineNumber', 'message', 'name', 'number', 'stack'];

	function Exception(message, node) {
	  var loc = node && node.loc,
	      line = undefined,
	      column = undefined;
	  if (loc) {
	    line = loc.start.line;
	    column = loc.start.column;

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

	      // Work around issue under safari where we can't directly set the column value
	      /* istanbul ignore next */
	      if (_Object$defineProperty) {
	        Object.defineProperty(this, 'column', { value: column });
	      } else {
	        this.column = column;
	      }
	    }
	  } catch (nop) {
	    /* Ignore if the browser is very particular */
	  }
	}

	Exception.prototype = new Error();

	exports['default'] = Exception;
	module.exports = exports['default'];

/***/ },
/* 7 */
/***/ function(module, exports, __webpack_require__) {

	module.exports = { "default": __webpack_require__(8), __esModule: true };

/***/ },
/* 8 */
/***/ function(module, exports, __webpack_require__) {

	var $ = __webpack_require__(9);
	module.exports = function defineProperty(it, key, desc){
	  return $.setDesc(it, key, desc);
	};

/***/ },
/* 9 */
/***/ function(module, exports) {

	var $Object = Object;
	module.exports = {
	  create:     $Object.create,
	  getProto:   $Object.getPrototypeOf,
	  isEnum:     {}.propertyIsEnumerable,
	  getDesc:    $Object.getOwnPropertyDescriptor,
	  setDesc:    $Object.defineProperty,
	  setDescs:   $Object.defineProperties,
	  getKeys:    $Object.keys,
	  getNames:   $Object.getOwnPropertyNames,
	  getSymbols: $Object.getOwnPropertySymbols,
	  each:       [].forEach
	};

/***/ },
/* 10 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var _interopRequireDefault = __webpack_require__(1)['default'];

	exports.__esModule = true;
	exports.registerDefaultHelpers = registerDefaultHelpers;

	var _helpersBlockHelperMissing = __webpack_require__(11);

	var _helpersBlockHelperMissing2 = _interopRequireDefault(_helpersBlockHelperMissing);

	var _helpersEach = __webpack_require__(12);

	var _helpersEach2 = _interopRequireDefault(_helpersEach);

	var _helpersHelperMissing = __webpack_require__(13);

	var _helpersHelperMissing2 = _interopRequireDefault(_helpersHelperMissing);

	var _helpersIf = __webpack_require__(14);

	var _helpersIf2 = _interopRequireDefault(_helpersIf);

	var _helpersLog = __webpack_require__(15);

	var _helpersLog2 = _interopRequireDefault(_helpersLog);

	var _helpersLookup = __webpack_require__(16);

	var _helpersLookup2 = _interopRequireDefault(_helpersLookup);

	var _helpersWith = __webpack_require__(17);

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

/***/ },
/* 11 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	exports.__esModule = true;

	var _utils = __webpack_require__(5);

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

/***/ },
/* 12 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var _interopRequireDefault = __webpack_require__(1)['default'];

	exports.__esModule = true;

	var _utils = __webpack_require__(5);

	var _exception = __webpack_require__(6);

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
	      } else {
	        var priorKey = undefined;

	        for (var key in context) {
	          if (context.hasOwnProperty(key)) {
	            // We're running the iterations one step out of sync so we can detect
	            // the last iteration without have to scan the object twice and create
	            // an itermediate keys array.
	            if (priorKey !== undefined) {
	              execIteration(priorKey, i - 1);
	            }
	            priorKey = key;
	            i++;
	          }
	        }
	        if (priorKey !== undefined) {
	          execIteration(priorKey, i - 1, true);
	        }
	      }
	    }

	    if (i === 0) {
	      ret = inverse(this);
	    }

	    return ret;
	  });
	};

	module.exports = exports['default'];

/***/ },
/* 13 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var _interopRequireDefault = __webpack_require__(1)['default'];

	exports.__esModule = true;

	var _exception = __webpack_require__(6);

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

/***/ },
/* 14 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	exports.__esModule = true;

	var _utils = __webpack_require__(5);

	exports['default'] = function (instance) {
	  instance.registerHelper('if', function (conditional, options) {
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
	    return instance.helpers['if'].call(this, conditional, { fn: options.inverse, inverse: options.fn, hash: options.hash });
	  });
	};

	module.exports = exports['default'];

/***/ },
/* 15 */
/***/ function(module, exports) {

	'use strict';

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

/***/ },
/* 16 */
/***/ function(module, exports) {

	'use strict';

	exports.__esModule = true;

	exports['default'] = function (instance) {
	  instance.registerHelper('lookup', function (obj, field) {
	    return obj && obj[field];
	  });
	};

	module.exports = exports['default'];

/***/ },
/* 17 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	exports.__esModule = true;

	var _utils = __webpack_require__(5);

	exports['default'] = function (instance) {
	  instance.registerHelper('with', function (context, options) {
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

/***/ },
/* 18 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var _interopRequireDefault = __webpack_require__(1)['default'];

	exports.__esModule = true;
	exports.registerDefaultDecorators = registerDefaultDecorators;

	var _decoratorsInline = __webpack_require__(19);

	var _decoratorsInline2 = _interopRequireDefault(_decoratorsInline);

	function registerDefaultDecorators(instance) {
	  _decoratorsInline2['default'](instance);
	}

/***/ },
/* 19 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	exports.__esModule = true;

	var _utils = __webpack_require__(5);

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

/***/ },
/* 20 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	exports.__esModule = true;

	var _utils = __webpack_require__(5);

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
	      if (!console[method]) {
	        // eslint-disable-line no-console
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

/***/ },
/* 21 */
/***/ function(module, exports) {

	// Build out our basic SafeString type
	'use strict';

	exports.__esModule = true;
	function SafeString(string) {
	  this.string = string;
	}

	SafeString.prototype.toString = SafeString.prototype.toHTML = function () {
	  return '' + this.string;
	};

	exports['default'] = SafeString;
	module.exports = exports['default'];

/***/ },
/* 22 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var _interopRequireWildcard = __webpack_require__(3)['default'];

	var _interopRequireDefault = __webpack_require__(1)['default'];

	exports.__esModule = true;
	exports.checkRevision = checkRevision;
	exports.template = template;
	exports.wrapProgram = wrapProgram;
	exports.resolvePartial = resolvePartial;
	exports.invokePartial = invokePartial;
	exports.noop = noop;

	var _utils = __webpack_require__(5);

	var Utils = _interopRequireWildcard(_utils);

	var _exception = __webpack_require__(6);

	var _exception2 = _interopRequireDefault(_exception);

	var _base = __webpack_require__(4);

	function checkRevision(compilerInfo) {
	  var compilerRevision = compilerInfo && compilerInfo[0] || 1,
	      currentRevision = _base.COMPILER_REVISION;

	  if (compilerRevision !== currentRevision) {
	    if (compilerRevision < currentRevision) {
	      var runtimeVersions = _base.REVISION_CHANGES[currentRevision],
	          compilerVersions = _base.REVISION_CHANGES[compilerRevision];
	      throw new _exception2['default']('Template was precompiled with an older version of Handlebars than the current runtime. ' + 'Please update your precompiler to a newer version (' + runtimeVersions + ') or downgrade your runtime to an older version (' + compilerVersions + ').');
	    } else {
	      // Use the embedded version info since the runtime doesn't know about this revision yet
	      throw new _exception2['default']('Template was precompiled with a newer version of Handlebars than the current runtime. ' + 'Please update your runtime to a newer version (' + compilerInfo[1] + ').');
	    }
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
	  // for external users to override these as psuedo-supported APIs.
	  env.VM.checkRevision(templateSpec.compiler);

	  function invokePartialWrapper(partial, context, options) {
	    if (options.hash) {
	      context = Utils.extend({}, context, options.hash);
	      if (options.ids) {
	        options.ids[0] = true;
	      }
	    }

	    partial = env.VM.resolvePartial.call(this, partial, context, options);
	    var result = env.VM.invokePartial.call(this, partial, context, options);

	    if (result == null && env.compile) {
	      options.partials[options.name] = env.compile(partial, templateSpec.compilerOptions, env);
	      result = options.partials[options.name](context, options);
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
	    strict: function strict(obj, name) {
	      if (!(name in obj)) {
	        throw new _exception2['default']('"' + name + '" not defined in ' + obj);
	      }
	      return obj[name];
	    },
	    lookup: function lookup(depths, name) {
	      var len = depths.length;
	      for (var i = 0; i < len; i++) {
	        if (depths[i] && depths[i][name] != null) {
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
	    merge: function merge(param, common) {
	      var obj = param || common;

	      if (param && common && param !== common) {
	        obj = Utils.extend({}, common, param);
	      }

	      return obj;
	    },

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
	      container.helpers = container.merge(options.helpers, env.helpers);

	      if (templateSpec.usePartial) {
	        container.partials = container.merge(options.partials, env.partials);
	      }
	      if (templateSpec.usePartial || templateSpec.useDecorators) {
	        container.decorators = container.merge(options.decorators, env.decorators);
	      }
	    } else {
	      container.helpers = options.helpers;
	      container.partials = options.partials;
	      container.decorators = options.decorators;
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
	    if (depths && context != depths[0]) {
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

	function resolvePartial(partial, context, options) {
	  if (!partial) {
	    if (options.name === '@partial-block') {
	      var data = options.data;
	      while (data['partial-block'] === noop) {
	        data = data._parent;
	      }
	      partial = data['partial-block'];
	      data['partial-block'] = noop;
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
	  options.partial = true;
	  if (options.ids) {
	    options.data.contextPath = options.ids[0] || options.data.contextPath;
	  }

	  var partialBlock = undefined;
	  if (options.fn && options.fn !== noop) {
	    options.data = _base.createFrame(options.data);
	    partialBlock = options.data['partial-block'] = options.fn;

	    if (partialBlock.partials) {
	      options.partials = Utils.extend({}, options.partials, partialBlock.partials);
	    }
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

/***/ },
/* 23 */
/***/ function(module, exports) {

	/* WEBPACK VAR INJECTION */(function(global) {/* global window */
	'use strict';

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
	/* WEBPACK VAR INJECTION */}.call(exports, (function() { return this; }())))

/***/ },
/* 24 */
/***/ function(module, exports) {

	'use strict';

	exports.__esModule = true;
	var AST = {
	  // Public API used to evaluate derived attributes regarding AST nodes
	  helpers: {
	    // a mustache is definitely a helper if:
	    // * it is an eligible helper, and
	    // * it has at least one parameter or hash segment
	    helperExpression: function helperExpression(node) {
	      return node.type === 'SubExpression' || (node.type === 'MustacheStatement' || node.type === 'BlockStatement') && !!(node.params && node.params.length || node.hash);
	    },

	    scopedId: function scopedId(path) {
	      return (/^\.|this\b/.test(path.original)
	      );
	    },

	    // an ID is simple if it only has one part, and that part is not
	    // `..` or `this`.
	    simpleId: function simpleId(path) {
	      return path.parts.length === 1 && !AST.helpers.scopedId(path) && !path.depth;
	    }
	  }
	};

	// Must be exported as an object rather than the root of the module as the jison lexer
	// must modify the object to operate properly.
	exports['default'] = AST;
	module.exports = exports['default'];

/***/ },
/* 25 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var _interopRequireDefault = __webpack_require__(1)['default'];

	var _interopRequireWildcard = __webpack_require__(3)['default'];

	exports.__esModule = true;
	exports.parse = parse;

	var _parser = __webpack_require__(26);

	var _parser2 = _interopRequireDefault(_parser);

	var _whitespaceControl = __webpack_require__(27);

	var _whitespaceControl2 = _interopRequireDefault(_whitespaceControl);

	var _helpers = __webpack_require__(29);

	var Helpers = _interopRequireWildcard(_helpers);

	var _utils = __webpack_require__(5);

	exports.parser = _parser2['default'];

	var yy = {};
	_utils.extend(yy, Helpers);

	function parse(input, options) {
	  // Just return if an already-compiled AST was passed in.
	  if (input.type === 'Program') {
	    return input;
	  }

	  _parser2['default'].yy = yy;

	  // Altering the shared object here, but this is ok as parser is a sync operation
	  yy.locInfo = function (locInfo) {
	    return new yy.SourceLocation(options && options.srcName, locInfo);
	  };

	  var strip = new _whitespaceControl2['default'](options);
	  return strip.accept(_parser2['default'].parse(input));
	}

/***/ },
/* 26 */
/***/ function(module, exports) {

	/* istanbul ignore next */
	/* Jison generated parser */
	"use strict";

	var handlebars = (function () {
	    var parser = { trace: function trace() {},
	        yy: {},
	        symbols_: { "error": 2, "root": 3, "program": 4, "EOF": 5, "program_repetition0": 6, "statement": 7, "mustache": 8, "block": 9, "rawBlock": 10, "partial": 11, "partialBlock": 12, "content": 13, "COMMENT": 14, "CONTENT": 15, "openRawBlock": 16, "rawBlock_repetition_plus0": 17, "END_RAW_BLOCK": 18, "OPEN_RAW_BLOCK": 19, "helperName": 20, "openRawBlock_repetition0": 21, "openRawBlock_option0": 22, "CLOSE_RAW_BLOCK": 23, "openBlock": 24, "block_option0": 25, "closeBlock": 26, "openInverse": 27, "block_option1": 28, "OPEN_BLOCK": 29, "openBlock_repetition0": 30, "openBlock_option0": 31, "openBlock_option1": 32, "CLOSE": 33, "OPEN_INVERSE": 34, "openInverse_repetition0": 35, "openInverse_option0": 36, "openInverse_option1": 37, "openInverseChain": 38, "OPEN_INVERSE_CHAIN": 39, "openInverseChain_repetition0": 40, "openInverseChain_option0": 41, "openInverseChain_option1": 42, "inverseAndProgram": 43, "INVERSE": 44, "inverseChain": 45, "inverseChain_option0": 46, "OPEN_ENDBLOCK": 47, "OPEN": 48, "mustache_repetition0": 49, "mustache_option0": 50, "OPEN_UNESCAPED": 51, "mustache_repetition1": 52, "mustache_option1": 53, "CLOSE_UNESCAPED": 54, "OPEN_PARTIAL": 55, "partialName": 56, "partial_repetition0": 57, "partial_option0": 58, "openPartialBlock": 59, "OPEN_PARTIAL_BLOCK": 60, "openPartialBlock_repetition0": 61, "openPartialBlock_option0": 62, "param": 63, "sexpr": 64, "OPEN_SEXPR": 65, "sexpr_repetition0": 66, "sexpr_option0": 67, "CLOSE_SEXPR": 68, "hash": 69, "hash_repetition_plus0": 70, "hashSegment": 71, "ID": 72, "EQUALS": 73, "blockParams": 74, "OPEN_BLOCK_PARAMS": 75, "blockParams_repetition_plus0": 76, "CLOSE_BLOCK_PARAMS": 77, "path": 78, "dataName": 79, "STRING": 80, "NUMBER": 81, "BOOLEAN": 82, "UNDEFINED": 83, "NULL": 84, "DATA": 85, "pathSegments": 86, "SEP": 87, "$accept": 0, "$end": 1 },
	        terminals_: { 2: "error", 5: "EOF", 14: "COMMENT", 15: "CONTENT", 18: "END_RAW_BLOCK", 19: "OPEN_RAW_BLOCK", 23: "CLOSE_RAW_BLOCK", 29: "OPEN_BLOCK", 33: "CLOSE", 34: "OPEN_INVERSE", 39: "OPEN_INVERSE_CHAIN", 44: "INVERSE", 47: "OPEN_ENDBLOCK", 48: "OPEN", 51: "OPEN_UNESCAPED", 54: "CLOSE_UNESCAPED", 55: "OPEN_PARTIAL", 60: "OPEN_PARTIAL_BLOCK", 65: "OPEN_SEXPR", 68: "CLOSE_SEXPR", 72: "ID", 73: "EQUALS", 75: "OPEN_BLOCK_PARAMS", 77: "CLOSE_BLOCK_PARAMS", 80: "STRING", 81: "NUMBER", 82: "BOOLEAN", 83: "UNDEFINED", 84: "NULL", 85: "DATA", 87: "SEP" },
	        productions_: [0, [3, 2], [4, 1], [7, 1], [7, 1], [7, 1], [7, 1], [7, 1], [7, 1], [7, 1], [13, 1], [10, 3], [16, 5], [9, 4], [9, 4], [24, 6], [27, 6], [38, 6], [43, 2], [45, 3], [45, 1], [26, 3], [8, 5], [8, 5], [11, 5], [12, 3], [59, 5], [63, 1], [63, 1], [64, 5], [69, 1], [71, 3], [74, 3], [20, 1], [20, 1], [20, 1], [20, 1], [20, 1], [20, 1], [20, 1], [56, 1], [56, 1], [79, 2], [78, 1], [86, 3], [86, 1], [6, 0], [6, 2], [17, 1], [17, 2], [21, 0], [21, 2], [22, 0], [22, 1], [25, 0], [25, 1], [28, 0], [28, 1], [30, 0], [30, 2], [31, 0], [31, 1], [32, 0], [32, 1], [35, 0], [35, 2], [36, 0], [36, 1], [37, 0], [37, 1], [40, 0], [40, 2], [41, 0], [41, 1], [42, 0], [42, 1], [46, 0], [46, 1], [49, 0], [49, 2], [50, 0], [50, 1], [52, 0], [52, 2], [53, 0], [53, 1], [57, 0], [57, 2], [58, 0], [58, 1], [61, 0], [61, 2], [62, 0], [62, 1], [66, 0], [66, 2], [67, 0], [67, 1], [70, 1], [70, 2], [76, 1], [76, 2]],
	        performAction: function anonymous(yytext, yyleng, yylineno, yy, yystate, $$, _$
	        /**/) {

	            var $0 = $$.length - 1;
	            switch (yystate) {
	                case 1:
	                    return $$[$0 - 1];
	                    break;
	                case 2:
	                    this.$ = yy.prepareProgram($$[$0]);
	                    break;
	                case 3:
	                    this.$ = $$[$0];
	                    break;
	                case 4:
	                    this.$ = $$[$0];
	                    break;
	                case 5:
	                    this.$ = $$[$0];
	                    break;
	                case 6:
	                    this.$ = $$[$0];
	                    break;
	                case 7:
	                    this.$ = $$[$0];
	                    break;
	                case 8:
	                    this.$ = $$[$0];
	                    break;
	                case 9:
	                    this.$ = {
	                        type: 'CommentStatement',
	                        value: yy.stripComment($$[$0]),
	                        strip: yy.stripFlags($$[$0], $$[$0]),
	                        loc: yy.locInfo(this._$)
	                    };

	                    break;
	                case 10:
	                    this.$ = {
	                        type: 'ContentStatement',
	                        original: $$[$0],
	                        value: $$[$0],
	                        loc: yy.locInfo(this._$)
	                    };

	                    break;
	                case 11:
	                    this.$ = yy.prepareRawBlock($$[$0 - 2], $$[$0 - 1], $$[$0], this._$);
	                    break;
	                case 12:
	                    this.$ = { path: $$[$0 - 3], params: $$[$0 - 2], hash: $$[$0 - 1] };
	                    break;
	                case 13:
	                    this.$ = yy.prepareBlock($$[$0 - 3], $$[$0 - 2], $$[$0 - 1], $$[$0], false, this._$);
	                    break;
	                case 14:
	                    this.$ = yy.prepareBlock($$[$0 - 3], $$[$0 - 2], $$[$0 - 1], $$[$0], true, this._$);
	                    break;
	                case 15:
	                    this.$ = { open: $$[$0 - 5], path: $$[$0 - 4], params: $$[$0 - 3], hash: $$[$0 - 2], blockParams: $$[$0 - 1], strip: yy.stripFlags($$[$0 - 5], $$[$0]) };
	                    break;
	                case 16:
	                    this.$ = { path: $$[$0 - 4], params: $$[$0 - 3], hash: $$[$0 - 2], blockParams: $$[$0 - 1], strip: yy.stripFlags($$[$0 - 5], $$[$0]) };
	                    break;
	                case 17:
	                    this.$ = { path: $$[$0 - 4], params: $$[$0 - 3], hash: $$[$0 - 2], blockParams: $$[$0 - 1], strip: yy.stripFlags($$[$0 - 5], $$[$0]) };
	                    break;
	                case 18:
	                    this.$ = { strip: yy.stripFlags($$[$0 - 1], $$[$0 - 1]), program: $$[$0] };
	                    break;
	                case 19:
	                    var inverse = yy.prepareBlock($$[$0 - 2], $$[$0 - 1], $$[$0], $$[$0], false, this._$),
	                        program = yy.prepareProgram([inverse], $$[$0 - 1].loc);
	                    program.chained = true;

	                    this.$ = { strip: $$[$0 - 2].strip, program: program, chain: true };

	                    break;
	                case 20:
	                    this.$ = $$[$0];
	                    break;
	                case 21:
	                    this.$ = { path: $$[$0 - 1], strip: yy.stripFlags($$[$0 - 2], $$[$0]) };
	                    break;
	                case 22:
	                    this.$ = yy.prepareMustache($$[$0 - 3], $$[$0 - 2], $$[$0 - 1], $$[$0 - 4], yy.stripFlags($$[$0 - 4], $$[$0]), this._$);
	                    break;
	                case 23:
	                    this.$ = yy.prepareMustache($$[$0 - 3], $$[$0 - 2], $$[$0 - 1], $$[$0 - 4], yy.stripFlags($$[$0 - 4], $$[$0]), this._$);
	                    break;
	                case 24:
	                    this.$ = {
	                        type: 'PartialStatement',
	                        name: $$[$0 - 3],
	                        params: $$[$0 - 2],
	                        hash: $$[$0 - 1],
	                        indent: '',
	                        strip: yy.stripFlags($$[$0 - 4], $$[$0]),
	                        loc: yy.locInfo(this._$)
	                    };

	                    break;
	                case 25:
	                    this.$ = yy.preparePartialBlock($$[$0 - 2], $$[$0 - 1], $$[$0], this._$);
	                    break;
	                case 26:
	                    this.$ = { path: $$[$0 - 3], params: $$[$0 - 2], hash: $$[$0 - 1], strip: yy.stripFlags($$[$0 - 4], $$[$0]) };
	                    break;
	                case 27:
	                    this.$ = $$[$0];
	                    break;
	                case 28:
	                    this.$ = $$[$0];
	                    break;
	                case 29:
	                    this.$ = {
	                        type: 'SubExpression',
	                        path: $$[$0 - 3],
	                        params: $$[$0 - 2],
	                        hash: $$[$0 - 1],
	                        loc: yy.locInfo(this._$)
	                    };

	                    break;
	                case 30:
	                    this.$ = { type: 'Hash', pairs: $$[$0], loc: yy.locInfo(this._$) };
	                    break;
	                case 31:
	                    this.$ = { type: 'HashPair', key: yy.id($$[$0 - 2]), value: $$[$0], loc: yy.locInfo(this._$) };
	                    break;
	                case 32:
	                    this.$ = yy.id($$[$0 - 1]);
	                    break;
	                case 33:
	                    this.$ = $$[$0];
	                    break;
	                case 34:
	                    this.$ = $$[$0];
	                    break;
	                case 35:
	                    this.$ = { type: 'StringLiteral', value: $$[$0], original: $$[$0], loc: yy.locInfo(this._$) };
	                    break;
	                case 36:
	                    this.$ = { type: 'NumberLiteral', value: Number($$[$0]), original: Number($$[$0]), loc: yy.locInfo(this._$) };
	                    break;
	                case 37:
	                    this.$ = { type: 'BooleanLiteral', value: $$[$0] === 'true', original: $$[$0] === 'true', loc: yy.locInfo(this._$) };
	                    break;
	                case 38:
	                    this.$ = { type: 'UndefinedLiteral', original: undefined, value: undefined, loc: yy.locInfo(this._$) };
	                    break;
	                case 39:
	                    this.$ = { type: 'NullLiteral', original: null, value: null, loc: yy.locInfo(this._$) };
	                    break;
	                case 40:
	                    this.$ = $$[$0];
	                    break;
	                case 41:
	                    this.$ = $$[$0];
	                    break;
	                case 42:
	                    this.$ = yy.preparePath(true, $$[$0], this._$);
	                    break;
	                case 43:
	                    this.$ = yy.preparePath(false, $$[$0], this._$);
	                    break;
	                case 44:
	                    $$[$0 - 2].push({ part: yy.id($$[$0]), original: $$[$0], separator: $$[$0 - 1] });this.$ = $$[$0 - 2];
	                    break;
	                case 45:
	                    this.$ = [{ part: yy.id($$[$0]), original: $$[$0] }];
	                    break;
	                case 46:
	                    this.$ = [];
	                    break;
	                case 47:
	                    $$[$0 - 1].push($$[$0]);
	                    break;
	                case 48:
	                    this.$ = [$$[$0]];
	                    break;
	                case 49:
	                    $$[$0 - 1].push($$[$0]);
	                    break;
	                case 50:
	                    this.$ = [];
	                    break;
	                case 51:
	                    $$[$0 - 1].push($$[$0]);
	                    break;
	                case 58:
	                    this.$ = [];
	                    break;
	                case 59:
	                    $$[$0 - 1].push($$[$0]);
	                    break;
	                case 64:
	                    this.$ = [];
	                    break;
	                case 65:
	                    $$[$0 - 1].push($$[$0]);
	                    break;
	                case 70:
	                    this.$ = [];
	                    break;
	                case 71:
	                    $$[$0 - 1].push($$[$0]);
	                    break;
	                case 78:
	                    this.$ = [];
	                    break;
	                case 79:
	                    $$[$0 - 1].push($$[$0]);
	                    break;
	                case 82:
	                    this.$ = [];
	                    break;
	                case 83:
	                    $$[$0 - 1].push($$[$0]);
	                    break;
	                case 86:
	                    this.$ = [];
	                    break;
	                case 87:
	                    $$[$0 - 1].push($$[$0]);
	                    break;
	                case 90:
	                    this.$ = [];
	                    break;
	                case 91:
	                    $$[$0 - 1].push($$[$0]);
	                    break;
	                case 94:
	                    this.$ = [];
	                    break;
	                case 95:
	                    $$[$0 - 1].push($$[$0]);
	                    break;
	                case 98:
	                    this.$ = [$$[$0]];
	                    break;
	                case 99:
	                    $$[$0 - 1].push($$[$0]);
	                    break;
	                case 100:
	                    this.$ = [$$[$0]];
	                    break;
	                case 101:
	                    $$[$0 - 1].push($$[$0]);
	                    break;
	            }
	        },
	        table: [{ 3: 1, 4: 2, 5: [2, 46], 6: 3, 14: [2, 46], 15: [2, 46], 19: [2, 46], 29: [2, 46], 34: [2, 46], 48: [2, 46], 51: [2, 46], 55: [2, 46], 60: [2, 46] }, { 1: [3] }, { 5: [1, 4] }, { 5: [2, 2], 7: 5, 8: 6, 9: 7, 10: 8, 11: 9, 12: 10, 13: 11, 14: [1, 12], 15: [1, 20], 16: 17, 19: [1, 23], 24: 15, 27: 16, 29: [1, 21], 34: [1, 22], 39: [2, 2], 44: [2, 2], 47: [2, 2], 48: [1, 13], 51: [1, 14], 55: [1, 18], 59: 19, 60: [1, 24] }, { 1: [2, 1] }, { 5: [2, 47], 14: [2, 47], 15: [2, 47], 19: [2, 47], 29: [2, 47], 34: [2, 47], 39: [2, 47], 44: [2, 47], 47: [2, 47], 48: [2, 47], 51: [2, 47], 55: [2, 47], 60: [2, 47] }, { 5: [2, 3], 14: [2, 3], 15: [2, 3], 19: [2, 3], 29: [2, 3], 34: [2, 3], 39: [2, 3], 44: [2, 3], 47: [2, 3], 48: [2, 3], 51: [2, 3], 55: [2, 3], 60: [2, 3] }, { 5: [2, 4], 14: [2, 4], 15: [2, 4], 19: [2, 4], 29: [2, 4], 34: [2, 4], 39: [2, 4], 44: [2, 4], 47: [2, 4], 48: [2, 4], 51: [2, 4], 55: [2, 4], 60: [2, 4] }, { 5: [2, 5], 14: [2, 5], 15: [2, 5], 19: [2, 5], 29: [2, 5], 34: [2, 5], 39: [2, 5], 44: [2, 5], 47: [2, 5], 48: [2, 5], 51: [2, 5], 55: [2, 5], 60: [2, 5] }, { 5: [2, 6], 14: [2, 6], 15: [2, 6], 19: [2, 6], 29: [2, 6], 34: [2, 6], 39: [2, 6], 44: [2, 6], 47: [2, 6], 48: [2, 6], 51: [2, 6], 55: [2, 6], 60: [2, 6] }, { 5: [2, 7], 14: [2, 7], 15: [2, 7], 19: [2, 7], 29: [2, 7], 34: [2, 7], 39: [2, 7], 44: [2, 7], 47: [2, 7], 48: [2, 7], 51: [2, 7], 55: [2, 7], 60: [2, 7] }, { 5: [2, 8], 14: [2, 8], 15: [2, 8], 19: [2, 8], 29: [2, 8], 34: [2, 8], 39: [2, 8], 44: [2, 8], 47: [2, 8], 48: [2, 8], 51: [2, 8], 55: [2, 8], 60: [2, 8] }, { 5: [2, 9], 14: [2, 9], 15: [2, 9], 19: [2, 9], 29: [2, 9], 34: [2, 9], 39: [2, 9], 44: [2, 9], 47: [2, 9], 48: [2, 9], 51: [2, 9], 55: [2, 9], 60: [2, 9] }, { 20: 25, 72: [1, 35], 78: 26, 79: 27, 80: [1, 28], 81: [1, 29], 82: [1, 30], 83: [1, 31], 84: [1, 32], 85: [1, 34], 86: 33 }, { 20: 36, 72: [1, 35], 78: 26, 79: 27, 80: [1, 28], 81: [1, 29], 82: [1, 30], 83: [1, 31], 84: [1, 32], 85: [1, 34], 86: 33 }, { 4: 37, 6: 3, 14: [2, 46], 15: [2, 46], 19: [2, 46], 29: [2, 46], 34: [2, 46], 39: [2, 46], 44: [2, 46], 47: [2, 46], 48: [2, 46], 51: [2, 46], 55: [2, 46], 60: [2, 46] }, { 4: 38, 6: 3, 14: [2, 46], 15: [2, 46], 19: [2, 46], 29: [2, 46], 34: [2, 46], 44: [2, 46], 47: [2, 46], 48: [2, 46], 51: [2, 46], 55: [2, 46], 60: [2, 46] }, { 13: 40, 15: [1, 20], 17: 39 }, { 20: 42, 56: 41, 64: 43, 65: [1, 44], 72: [1, 35], 78: 26, 79: 27, 80: [1, 28], 81: [1, 29], 82: [1, 30], 83: [1, 31], 84: [1, 32], 85: [1, 34], 86: 33 }, { 4: 45, 6: 3, 14: [2, 46], 15: [2, 46], 19: [2, 46], 29: [2, 46], 34: [2, 46], 47: [2, 46], 48: [2, 46], 51: [2, 46], 55: [2, 46], 60: [2, 46] }, { 5: [2, 10], 14: [2, 10], 15: [2, 10], 18: [2, 10], 19: [2, 10], 29: [2, 10], 34: [2, 10], 39: [2, 10], 44: [2, 10], 47: [2, 10], 48: [2, 10], 51: [2, 10], 55: [2, 10], 60: [2, 10] }, { 20: 46, 72: [1, 35], 78: 26, 79: 27, 80: [1, 28], 81: [1, 29], 82: [1, 30], 83: [1, 31], 84: [1, 32], 85: [1, 34], 86: 33 }, { 20: 47, 72: [1, 35], 78: 26, 79: 27, 80: [1, 28], 81: [1, 29], 82: [1, 30], 83: [1, 31], 84: [1, 32], 85: [1, 34], 86: 33 }, { 20: 48, 72: [1, 35], 78: 26, 79: 27, 80: [1, 28], 81: [1, 29], 82: [1, 30], 83: [1, 31], 84: [1, 32], 85: [1, 34], 86: 33 }, { 20: 42, 56: 49, 64: 43, 65: [1, 44], 72: [1, 35], 78: 26, 79: 27, 80: [1, 28], 81: [1, 29], 82: [1, 30], 83: [1, 31], 84: [1, 32], 85: [1, 34], 86: 33 }, { 33: [2, 78], 49: 50, 65: [2, 78], 72: [2, 78], 80: [2, 78], 81: [2, 78], 82: [2, 78], 83: [2, 78], 84: [2, 78], 85: [2, 78] }, { 23: [2, 33], 33: [2, 33], 54: [2, 33], 65: [2, 33], 68: [2, 33], 72: [2, 33], 75: [2, 33], 80: [2, 33], 81: [2, 33], 82: [2, 33], 83: [2, 33], 84: [2, 33], 85: [2, 33] }, { 23: [2, 34], 33: [2, 34], 54: [2, 34], 65: [2, 34], 68: [2, 34], 72: [2, 34], 75: [2, 34], 80: [2, 34], 81: [2, 34], 82: [2, 34], 83: [2, 34], 84: [2, 34], 85: [2, 34] }, { 23: [2, 35], 33: [2, 35], 54: [2, 35], 65: [2, 35], 68: [2, 35], 72: [2, 35], 75: [2, 35], 80: [2, 35], 81: [2, 35], 82: [2, 35], 83: [2, 35], 84: [2, 35], 85: [2, 35] }, { 23: [2, 36], 33: [2, 36], 54: [2, 36], 65: [2, 36], 68: [2, 36], 72: [2, 36], 75: [2, 36], 80: [2, 36], 81: [2, 36], 82: [2, 36], 83: [2, 36], 84: [2, 36], 85: [2, 36] }, { 23: [2, 37], 33: [2, 37], 54: [2, 37], 65: [2, 37], 68: [2, 37], 72: [2, 37], 75: [2, 37], 80: [2, 37], 81: [2, 37], 82: [2, 37], 83: [2, 37], 84: [2, 37], 85: [2, 37] }, { 23: [2, 38], 33: [2, 38], 54: [2, 38], 65: [2, 38], 68: [2, 38], 72: [2, 38], 75: [2, 38], 80: [2, 38], 81: [2, 38], 82: [2, 38], 83: [2, 38], 84: [2, 38], 85: [2, 38] }, { 23: [2, 39], 33: [2, 39], 54: [2, 39], 65: [2, 39], 68: [2, 39], 72: [2, 39], 75: [2, 39], 80: [2, 39], 81: [2, 39], 82: [2, 39], 83: [2, 39], 84: [2, 39], 85: [2, 39] }, { 23: [2, 43], 33: [2, 43], 54: [2, 43], 65: [2, 43], 68: [2, 43], 72: [2, 43], 75: [2, 43], 80: [2, 43], 81: [2, 43], 82: [2, 43], 83: [2, 43], 84: [2, 43], 85: [2, 43], 87: [1, 51] }, { 72: [1, 35], 86: 52 }, { 23: [2, 45], 33: [2, 45], 54: [2, 45], 65: [2, 45], 68: [2, 45], 72: [2, 45], 75: [2, 45], 80: [2, 45], 81: [2, 45], 82: [2, 45], 83: [2, 45], 84: [2, 45], 85: [2, 45], 87: [2, 45] }, { 52: 53, 54: [2, 82], 65: [2, 82], 72: [2, 82], 80: [2, 82], 81: [2, 82], 82: [2, 82], 83: [2, 82], 84: [2, 82], 85: [2, 82] }, { 25: 54, 38: 56, 39: [1, 58], 43: 57, 44: [1, 59], 45: 55, 47: [2, 54] }, { 28: 60, 43: 61, 44: [1, 59], 47: [2, 56] }, { 13: 63, 15: [1, 20], 18: [1, 62] }, { 15: [2, 48], 18: [2, 48] }, { 33: [2, 86], 57: 64, 65: [2, 86], 72: [2, 86], 80: [2, 86], 81: [2, 86], 82: [2, 86], 83: [2, 86], 84: [2, 86], 85: [2, 86] }, { 33: [2, 40], 65: [2, 40], 72: [2, 40], 80: [2, 40], 81: [2, 40], 82: [2, 40], 83: [2, 40], 84: [2, 40], 85: [2, 40] }, { 33: [2, 41], 65: [2, 41], 72: [2, 41], 80: [2, 41], 81: [2, 41], 82: [2, 41], 83: [2, 41], 84: [2, 41], 85: [2, 41] }, { 20: 65, 72: [1, 35], 78: 26, 79: 27, 80: [1, 28], 81: [1, 29], 82: [1, 30], 83: [1, 31], 84: [1, 32], 85: [1, 34], 86: 33 }, { 26: 66, 47: [1, 67] }, { 30: 68, 33: [2, 58], 65: [2, 58], 72: [2, 58], 75: [2, 58], 80: [2, 58], 81: [2, 58], 82: [2, 58], 83: [2, 58], 84: [2, 58], 85: [2, 58] }, { 33: [2, 64], 35: 69, 65: [2, 64], 72: [2, 64], 75: [2, 64], 80: [2, 64], 81: [2, 64], 82: [2, 64], 83: [2, 64], 84: [2, 64], 85: [2, 64] }, { 21: 70, 23: [2, 50], 65: [2, 50], 72: [2, 50], 80: [2, 50], 81: [2, 50], 82: [2, 50], 83: [2, 50], 84: [2, 50], 85: [2, 50] }, { 33: [2, 90], 61: 71, 65: [2, 90], 72: [2, 90], 80: [2, 90], 81: [2, 90], 82: [2, 90], 83: [2, 90], 84: [2, 90], 85: [2, 90] }, { 20: 75, 33: [2, 80], 50: 72, 63: 73, 64: 76, 65: [1, 44], 69: 74, 70: 77, 71: 78, 72: [1, 79], 78: 26, 79: 27, 80: [1, 28], 81: [1, 29], 82: [1, 30], 83: [1, 31], 84: [1, 32], 85: [1, 34], 86: 33 }, { 72: [1, 80] }, { 23: [2, 42], 33: [2, 42], 54: [2, 42], 65: [2, 42], 68: [2, 42], 72: [2, 42], 75: [2, 42], 80: [2, 42], 81: [2, 42], 82: [2, 42], 83: [2, 42], 84: [2, 42], 85: [2, 42], 87: [1, 51] }, { 20: 75, 53: 81, 54: [2, 84], 63: 82, 64: 76, 65: [1, 44], 69: 83, 70: 77, 71: 78, 72: [1, 79], 78: 26, 79: 27, 80: [1, 28], 81: [1, 29], 82: [1, 30], 83: [1, 31], 84: [1, 32], 85: [1, 34], 86: 33 }, { 26: 84, 47: [1, 67] }, { 47: [2, 55] }, { 4: 85, 6: 3, 14: [2, 46], 15: [2, 46], 19: [2, 46], 29: [2, 46], 34: [2, 46], 39: [2, 46], 44: [2, 46], 47: [2, 46], 48: [2, 46], 51: [2, 46], 55: [2, 46], 60: [2, 46] }, { 47: [2, 20] }, { 20: 86, 72: [1, 35], 78: 26, 79: 27, 80: [1, 28], 81: [1, 29], 82: [1, 30], 83: [1, 31], 84: [1, 32], 85: [1, 34], 86: 33 }, { 4: 87, 6: 3, 14: [2, 46], 15: [2, 46], 19: [2, 46], 29: [2, 46], 34: [2, 46], 47: [2, 46], 48: [2, 46], 51: [2, 46], 55: [2, 46], 60: [2, 46] }, { 26: 88, 47: [1, 67] }, { 47: [2, 57] }, { 5: [2, 11], 14: [2, 11], 15: [2, 11], 19: [2, 11], 29: [2, 11], 34: [2, 11], 39: [2, 11], 44: [2, 11], 47: [2, 11], 48: [2, 11], 51: [2, 11], 55: [2, 11], 60: [2, 11] }, { 15: [2, 49], 18: [2, 49] }, { 20: 75, 33: [2, 88], 58: 89, 63: 90, 64: 76, 65: [1, 44], 69: 91, 70: 77, 71: 78, 72: [1, 79], 78: 26, 79: 27, 80: [1, 28], 81: [1, 29], 82: [1, 30], 83: [1, 31], 84: [1, 32], 85: [1, 34], 86: 33 }, { 65: [2, 94], 66: 92, 68: [2, 94], 72: [2, 94], 80: [2, 94], 81: [2, 94], 82: [2, 94], 83: [2, 94], 84: [2, 94], 85: [2, 94] }, { 5: [2, 25], 14: [2, 25], 15: [2, 25], 19: [2, 25], 29: [2, 25], 34: [2, 25], 39: [2, 25], 44: [2, 25], 47: [2, 25], 48: [2, 25], 51: [2, 25], 55: [2, 25], 60: [2, 25] }, { 20: 93, 72: [1, 35], 78: 26, 79: 27, 80: [1, 28], 81: [1, 29], 82: [1, 30], 83: [1, 31], 84: [1, 32], 85: [1, 34], 86: 33 }, { 20: 75, 31: 94, 33: [2, 60], 63: 95, 64: 76, 65: [1, 44], 69: 96, 70: 77, 71: 78, 72: [1, 79], 75: [2, 60], 78: 26, 79: 27, 80: [1, 28], 81: [1, 29], 82: [1, 30], 83: [1, 31], 84: [1, 32], 85: [1, 34], 86: 33 }, { 20: 75, 33: [2, 66], 36: 97, 63: 98, 64: 76, 65: [1, 44], 69: 99, 70: 77, 71: 78, 72: [1, 79], 75: [2, 66], 78: 26, 79: 27, 80: [1, 28], 81: [1, 29], 82: [1, 30], 83: [1, 31], 84: [1, 32], 85: [1, 34], 86: 33 }, { 20: 75, 22: 100, 23: [2, 52], 63: 101, 64: 76, 65: [1, 44], 69: 102, 70: 77, 71: 78, 72: [1, 79], 78: 26, 79: 27, 80: [1, 28], 81: [1, 29], 82: [1, 30], 83: [1, 31], 84: [1, 32], 85: [1, 34], 86: 33 }, { 20: 75, 33: [2, 92], 62: 103, 63: 104, 64: 76, 65: [1, 44], 69: 105, 70: 77, 71: 78, 72: [1, 79], 78: 26, 79: 27, 80: [1, 28], 81: [1, 29], 82: [1, 30], 83: [1, 31], 84: [1, 32], 85: [1, 34], 86: 33 }, { 33: [1, 106] }, { 33: [2, 79], 65: [2, 79], 72: [2, 79], 80: [2, 79], 81: [2, 79], 82: [2, 79], 83: [2, 79], 84: [2, 79], 85: [2, 79] }, { 33: [2, 81] }, { 23: [2, 27], 33: [2, 27], 54: [2, 27], 65: [2, 27], 68: [2, 27], 72: [2, 27], 75: [2, 27], 80: [2, 27], 81: [2, 27], 82: [2, 27], 83: [2, 27], 84: [2, 27], 85: [2, 27] }, { 23: [2, 28], 33: [2, 28], 54: [2, 28], 65: [2, 28], 68: [2, 28], 72: [2, 28], 75: [2, 28], 80: [2, 28], 81: [2, 28], 82: [2, 28], 83: [2, 28], 84: [2, 28], 85: [2, 28] }, { 23: [2, 30], 33: [2, 30], 54: [2, 30], 68: [2, 30], 71: 107, 72: [1, 108], 75: [2, 30] }, { 23: [2, 98], 33: [2, 98], 54: [2, 98], 68: [2, 98], 72: [2, 98], 75: [2, 98] }, { 23: [2, 45], 33: [2, 45], 54: [2, 45], 65: [2, 45], 68: [2, 45], 72: [2, 45], 73: [1, 109], 75: [2, 45], 80: [2, 45], 81: [2, 45], 82: [2, 45], 83: [2, 45], 84: [2, 45], 85: [2, 45], 87: [2, 45] }, { 23: [2, 44], 33: [2, 44], 54: [2, 44], 65: [2, 44], 68: [2, 44], 72: [2, 44], 75: [2, 44], 80: [2, 44], 81: [2, 44], 82: [2, 44], 83: [2, 44], 84: [2, 44], 85: [2, 44], 87: [2, 44] }, { 54: [1, 110] }, { 54: [2, 83], 65: [2, 83], 72: [2, 83], 80: [2, 83], 81: [2, 83], 82: [2, 83], 83: [2, 83], 84: [2, 83], 85: [2, 83] }, { 54: [2, 85] }, { 5: [2, 13], 14: [2, 13], 15: [2, 13], 19: [2, 13], 29: [2, 13], 34: [2, 13], 39: [2, 13], 44: [2, 13], 47: [2, 13], 48: [2, 13], 51: [2, 13], 55: [2, 13], 60: [2, 13] }, { 38: 56, 39: [1, 58], 43: 57, 44: [1, 59], 45: 112, 46: 111, 47: [2, 76] }, { 33: [2, 70], 40: 113, 65: [2, 70], 72: [2, 70], 75: [2, 70], 80: [2, 70], 81: [2, 70], 82: [2, 70], 83: [2, 70], 84: [2, 70], 85: [2, 70] }, { 47: [2, 18] }, { 5: [2, 14], 14: [2, 14], 15: [2, 14], 19: [2, 14], 29: [2, 14], 34: [2, 14], 39: [2, 14], 44: [2, 14], 47: [2, 14], 48: [2, 14], 51: [2, 14], 55: [2, 14], 60: [2, 14] }, { 33: [1, 114] }, { 33: [2, 87], 65: [2, 87], 72: [2, 87], 80: [2, 87], 81: [2, 87], 82: [2, 87], 83: [2, 87], 84: [2, 87], 85: [2, 87] }, { 33: [2, 89] }, { 20: 75, 63: 116, 64: 76, 65: [1, 44], 67: 115, 68: [2, 96], 69: 117, 70: 77, 71: 78, 72: [1, 79], 78: 26, 79: 27, 80: [1, 28], 81: [1, 29], 82: [1, 30], 83: [1, 31], 84: [1, 32], 85: [1, 34], 86: 33 }, { 33: [1, 118] }, { 32: 119, 33: [2, 62], 74: 120, 75: [1, 121] }, { 33: [2, 59], 65: [2, 59], 72: [2, 59], 75: [2, 59], 80: [2, 59], 81: [2, 59], 82: [2, 59], 83: [2, 59], 84: [2, 59], 85: [2, 59] }, { 33: [2, 61], 75: [2, 61] }, { 33: [2, 68], 37: 122, 74: 123, 75: [1, 121] }, { 33: [2, 65], 65: [2, 65], 72: [2, 65], 75: [2, 65], 80: [2, 65], 81: [2, 65], 82: [2, 65], 83: [2, 65], 84: [2, 65], 85: [2, 65] }, { 33: [2, 67], 75: [2, 67] }, { 23: [1, 124] }, { 23: [2, 51], 65: [2, 51], 72: [2, 51], 80: [2, 51], 81: [2, 51], 82: [2, 51], 83: [2, 51], 84: [2, 51], 85: [2, 51] }, { 23: [2, 53] }, { 33: [1, 125] }, { 33: [2, 91], 65: [2, 91], 72: [2, 91], 80: [2, 91], 81: [2, 91], 82: [2, 91], 83: [2, 91], 84: [2, 91], 85: [2, 91] }, { 33: [2, 93] }, { 5: [2, 22], 14: [2, 22], 15: [2, 22], 19: [2, 22], 29: [2, 22], 34: [2, 22], 39: [2, 22], 44: [2, 22], 47: [2, 22], 48: [2, 22], 51: [2, 22], 55: [2, 22], 60: [2, 22] }, { 23: [2, 99], 33: [2, 99], 54: [2, 99], 68: [2, 99], 72: [2, 99], 75: [2, 99] }, { 73: [1, 109] }, { 20: 75, 63: 126, 64: 76, 65: [1, 44], 72: [1, 35], 78: 26, 79: 27, 80: [1, 28], 81: [1, 29], 82: [1, 30], 83: [1, 31], 84: [1, 32], 85: [1, 34], 86: 33 }, { 5: [2, 23], 14: [2, 23], 15: [2, 23], 19: [2, 23], 29: [2, 23], 34: [2, 23], 39: [2, 23], 44: [2, 23], 47: [2, 23], 48: [2, 23], 51: [2, 23], 55: [2, 23], 60: [2, 23] }, { 47: [2, 19] }, { 47: [2, 77] }, { 20: 75, 33: [2, 72], 41: 127, 63: 128, 64: 76, 65: [1, 44], 69: 129, 70: 77, 71: 78, 72: [1, 79], 75: [2, 72], 78: 26, 79: 27, 80: [1, 28], 81: [1, 29], 82: [1, 30], 83: [1, 31], 84: [1, 32], 85: [1, 34], 86: 33 }, { 5: [2, 24], 14: [2, 24], 15: [2, 24], 19: [2, 24], 29: [2, 24], 34: [2, 24], 39: [2, 24], 44: [2, 24], 47: [2, 24], 48: [2, 24], 51: [2, 24], 55: [2, 24], 60: [2, 24] }, { 68: [1, 130] }, { 65: [2, 95], 68: [2, 95], 72: [2, 95], 80: [2, 95], 81: [2, 95], 82: [2, 95], 83: [2, 95], 84: [2, 95], 85: [2, 95] }, { 68: [2, 97] }, { 5: [2, 21], 14: [2, 21], 15: [2, 21], 19: [2, 21], 29: [2, 21], 34: [2, 21], 39: [2, 21], 44: [2, 21], 47: [2, 21], 48: [2, 21], 51: [2, 21], 55: [2, 21], 60: [2, 21] }, { 33: [1, 131] }, { 33: [2, 63] }, { 72: [1, 133], 76: 132 }, { 33: [1, 134] }, { 33: [2, 69] }, { 15: [2, 12] }, { 14: [2, 26], 15: [2, 26], 19: [2, 26], 29: [2, 26], 34: [2, 26], 47: [2, 26], 48: [2, 26], 51: [2, 26], 55: [2, 26], 60: [2, 26] }, { 23: [2, 31], 33: [2, 31], 54: [2, 31], 68: [2, 31], 72: [2, 31], 75: [2, 31] }, { 33: [2, 74], 42: 135, 74: 136, 75: [1, 121] }, { 33: [2, 71], 65: [2, 71], 72: [2, 71], 75: [2, 71], 80: [2, 71], 81: [2, 71], 82: [2, 71], 83: [2, 71], 84: [2, 71], 85: [2, 71] }, { 33: [2, 73], 75: [2, 73] }, { 23: [2, 29], 33: [2, 29], 54: [2, 29], 65: [2, 29], 68: [2, 29], 72: [2, 29], 75: [2, 29], 80: [2, 29], 81: [2, 29], 82: [2, 29], 83: [2, 29], 84: [2, 29], 85: [2, 29] }, { 14: [2, 15], 15: [2, 15], 19: [2, 15], 29: [2, 15], 34: [2, 15], 39: [2, 15], 44: [2, 15], 47: [2, 15], 48: [2, 15], 51: [2, 15], 55: [2, 15], 60: [2, 15] }, { 72: [1, 138], 77: [1, 137] }, { 72: [2, 100], 77: [2, 100] }, { 14: [2, 16], 15: [2, 16], 19: [2, 16], 29: [2, 16], 34: [2, 16], 44: [2, 16], 47: [2, 16], 48: [2, 16], 51: [2, 16], 55: [2, 16], 60: [2, 16] }, { 33: [1, 139] }, { 33: [2, 75] }, { 33: [2, 32] }, { 72: [2, 101], 77: [2, 101] }, { 14: [2, 17], 15: [2, 17], 19: [2, 17], 29: [2, 17], 34: [2, 17], 39: [2, 17], 44: [2, 17], 47: [2, 17], 48: [2, 17], 51: [2, 17], 55: [2, 17], 60: [2, 17] }],
	        defaultActions: { 4: [2, 1], 55: [2, 55], 57: [2, 20], 61: [2, 57], 74: [2, 81], 83: [2, 85], 87: [2, 18], 91: [2, 89], 102: [2, 53], 105: [2, 93], 111: [2, 19], 112: [2, 77], 117: [2, 97], 120: [2, 63], 123: [2, 69], 124: [2, 12], 136: [2, 75], 137: [2, 32] },
	        parseError: function parseError(str, hash) {
	            throw new Error(str);
	        },
	        parse: function parse(input) {
	            var self = this,
	                stack = [0],
	                vstack = [null],
	                lstack = [],
	                table = this.table,
	                yytext = "",
	                yylineno = 0,
	                yyleng = 0,
	                recovering = 0,
	                TERROR = 2,
	                EOF = 1;
	            this.lexer.setInput(input);
	            this.lexer.yy = this.yy;
	            this.yy.lexer = this.lexer;
	            this.yy.parser = this;
	            if (typeof this.lexer.yylloc == "undefined") this.lexer.yylloc = {};
	            var yyloc = this.lexer.yylloc;
	            lstack.push(yyloc);
	            var ranges = this.lexer.options && this.lexer.options.ranges;
	            if (typeof this.yy.parseError === "function") this.parseError = this.yy.parseError;
	            function popStack(n) {
	                stack.length = stack.length - 2 * n;
	                vstack.length = vstack.length - n;
	                lstack.length = lstack.length - n;
	            }
	            function lex() {
	                var token;
	                token = self.lexer.lex() || 1;
	                if (typeof token !== "number") {
	                    token = self.symbols_[token] || token;
	                }
	                return token;
	            }
	            var symbol,
	                preErrorSymbol,
	                state,
	                action,
	                a,
	                r,
	                yyval = {},
	                p,
	                len,
	                newState,
	                expected;
	            while (true) {
	                state = stack[stack.length - 1];
	                if (this.defaultActions[state]) {
	                    action = this.defaultActions[state];
	                } else {
	                    if (symbol === null || typeof symbol == "undefined") {
	                        symbol = lex();
	                    }
	                    action = table[state] && table[state][symbol];
	                }
	                if (typeof action === "undefined" || !action.length || !action[0]) {
	                    var errStr = "";
	                    if (!recovering) {
	                        expected = [];
	                        for (p in table[state]) if (this.terminals_[p] && p > 2) {
	                            expected.push("'" + this.terminals_[p] + "'");
	                        }
	                        if (this.lexer.showPosition) {
	                            errStr = "Parse error on line " + (yylineno + 1) + ":\n" + this.lexer.showPosition() + "\nExpecting " + expected.join(", ") + ", got '" + (this.terminals_[symbol] || symbol) + "'";
	                        } else {
	                            errStr = "Parse error on line " + (yylineno + 1) + ": Unexpected " + (symbol == 1 ? "end of input" : "'" + (this.terminals_[symbol] || symbol) + "'");
	                        }
	                        this.parseError(errStr, { text: this.lexer.match, token: this.terminals_[symbol] || symbol, line: this.lexer.yylineno, loc: yyloc, expected: expected });
	                    }
	                }
	                if (action[0] instanceof Array && action.length > 1) {
	                    throw new Error("Parse Error: multiple actions possible at state: " + state + ", token: " + symbol);
	                }
	                switch (action[0]) {
	                    case 1:
	                        stack.push(symbol);
	                        vstack.push(this.lexer.yytext);
	                        lstack.push(this.lexer.yylloc);
	                        stack.push(action[1]);
	                        symbol = null;
	                        if (!preErrorSymbol) {
	                            yyleng = this.lexer.yyleng;
	                            yytext = this.lexer.yytext;
	                            yylineno = this.lexer.yylineno;
	                            yyloc = this.lexer.yylloc;
	                            if (recovering > 0) recovering--;
	                        } else {
	                            symbol = preErrorSymbol;
	                            preErrorSymbol = null;
	                        }
	                        break;
	                    case 2:
	                        len = this.productions_[action[1]][1];
	                        yyval.$ = vstack[vstack.length - len];
	                        yyval._$ = { first_line: lstack[lstack.length - (len || 1)].first_line, last_line: lstack[lstack.length - 1].last_line, first_column: lstack[lstack.length - (len || 1)].first_column, last_column: lstack[lstack.length - 1].last_column };
	                        if (ranges) {
	                            yyval._$.range = [lstack[lstack.length - (len || 1)].range[0], lstack[lstack.length - 1].range[1]];
	                        }
	                        r = this.performAction.call(yyval, yytext, yyleng, yylineno, this.yy, action[1], vstack, lstack);
	                        if (typeof r !== "undefined") {
	                            return r;
	                        }
	                        if (len) {
	                            stack = stack.slice(0, -1 * len * 2);
	                            vstack = vstack.slice(0, -1 * len);
	                            lstack = lstack.slice(0, -1 * len);
	                        }
	                        stack.push(this.productions_[action[1]][0]);
	                        vstack.push(yyval.$);
	                        lstack.push(yyval._$);
	                        newState = table[stack[stack.length - 2]][stack[stack.length - 1]];
	                        stack.push(newState);
	                        break;
	                    case 3:
	                        return true;
	                }
	            }
	            return true;
	        }
	    };
	    /* Jison generated lexer */
	    var lexer = (function () {
	        var lexer = { EOF: 1,
	            parseError: function parseError(str, hash) {
	                if (this.yy.parser) {
	                    this.yy.parser.parseError(str, hash);
	                } else {
	                    throw new Error(str);
	                }
	            },
	            setInput: function setInput(input) {
	                this._input = input;
	                this._more = this._less = this.done = false;
	                this.yylineno = this.yyleng = 0;
	                this.yytext = this.matched = this.match = '';
	                this.conditionStack = ['INITIAL'];
	                this.yylloc = { first_line: 1, first_column: 0, last_line: 1, last_column: 0 };
	                if (this.options.ranges) this.yylloc.range = [0, 0];
	                this.offset = 0;
	                return this;
	            },
	            input: function input() {
	                var ch = this._input[0];
	                this.yytext += ch;
	                this.yyleng++;
	                this.offset++;
	                this.match += ch;
	                this.matched += ch;
	                var lines = ch.match(/(?:\r\n?|\n).*/g);
	                if (lines) {
	                    this.yylineno++;
	                    this.yylloc.last_line++;
	                } else {
	                    this.yylloc.last_column++;
	                }
	                if (this.options.ranges) this.yylloc.range[1]++;

	                this._input = this._input.slice(1);
	                return ch;
	            },
	            unput: function unput(ch) {
	                var len = ch.length;
	                var lines = ch.split(/(?:\r\n?|\n)/g);

	                this._input = ch + this._input;
	                this.yytext = this.yytext.substr(0, this.yytext.length - len - 1);
	                //this.yyleng -= len;
	                this.offset -= len;
	                var oldLines = this.match.split(/(?:\r\n?|\n)/g);
	                this.match = this.match.substr(0, this.match.length - 1);
	                this.matched = this.matched.substr(0, this.matched.length - 1);

	                if (lines.length - 1) this.yylineno -= lines.length - 1;
	                var r = this.yylloc.range;

	                this.yylloc = { first_line: this.yylloc.first_line,
	                    last_line: this.yylineno + 1,
	                    first_column: this.yylloc.first_column,
	                    last_column: lines ? (lines.length === oldLines.length ? this.yylloc.first_column : 0) + oldLines[oldLines.length - lines.length].length - lines[0].length : this.yylloc.first_column - len
	                };

	                if (this.options.ranges) {
	                    this.yylloc.range = [r[0], r[0] + this.yyleng - len];
	                }
	                return this;
	            },
	            more: function more() {
	                this._more = true;
	                return this;
	            },
	            less: function less(n) {
	                this.unput(this.match.slice(n));
	            },
	            pastInput: function pastInput() {
	                var past = this.matched.substr(0, this.matched.length - this.match.length);
	                return (past.length > 20 ? '...' : '') + past.substr(-20).replace(/\n/g, "");
	            },
	            upcomingInput: function upcomingInput() {
	                var next = this.match;
	                if (next.length < 20) {
	                    next += this._input.substr(0, 20 - next.length);
	                }
	                return (next.substr(0, 20) + (next.length > 20 ? '...' : '')).replace(/\n/g, "");
	            },
	            showPosition: function showPosition() {
	                var pre = this.pastInput();
	                var c = new Array(pre.length + 1).join("-");
	                return pre + this.upcomingInput() + "\n" + c + "^";
	            },
	            next: function next() {
	                if (this.done) {
	                    return this.EOF;
	                }
	                if (!this._input) this.done = true;

	                var token, match, tempMatch, index, col, lines;
	                if (!this._more) {
	                    this.yytext = '';
	                    this.match = '';
	                }
	                var rules = this._currentRules();
	                for (var i = 0; i < rules.length; i++) {
	                    tempMatch = this._input.match(this.rules[rules[i]]);
	                    if (tempMatch && (!match || tempMatch[0].length > match[0].length)) {
	                        match = tempMatch;
	                        index = i;
	                        if (!this.options.flex) break;
	                    }
	                }
	                if (match) {
	                    lines = match[0].match(/(?:\r\n?|\n).*/g);
	                    if (lines) this.yylineno += lines.length;
	                    this.yylloc = { first_line: this.yylloc.last_line,
	                        last_line: this.yylineno + 1,
	                        first_column: this.yylloc.last_column,
	                        last_column: lines ? lines[lines.length - 1].length - lines[lines.length - 1].match(/\r?\n?/)[0].length : this.yylloc.last_column + match[0].length };
	                    this.yytext += match[0];
	                    this.match += match[0];
	                    this.matches = match;
	                    this.yyleng = this.yytext.length;
	                    if (this.options.ranges) {
	                        this.yylloc.range = [this.offset, this.offset += this.yyleng];
	                    }
	                    this._more = false;
	                    this._input = this._input.slice(match[0].length);
	                    this.matched += match[0];
	                    token = this.performAction.call(this, this.yy, this, rules[index], this.conditionStack[this.conditionStack.length - 1]);
	                    if (this.done && this._input) this.done = false;
	                    if (token) return token;else return;
	                }
	                if (this._input === "") {
	                    return this.EOF;
	                } else {
	                    return this.parseError('Lexical error on line ' + (this.yylineno + 1) + '. Unrecognized text.\n' + this.showPosition(), { text: "", token: null, line: this.yylineno });
	                }
	            },
	            lex: function lex() {
	                var r = this.next();
	                if (typeof r !== 'undefined') {
	                    return r;
	                } else {
	                    return this.lex();
	                }
	            },
	            begin: function begin(condition) {
	                this.conditionStack.push(condition);
	            },
	            popState: function popState() {
	                return this.conditionStack.pop();
	            },
	            _currentRules: function _currentRules() {
	                return this.conditions[this.conditionStack[this.conditionStack.length - 1]].rules;
	            },
	            topState: function topState() {
	                return this.conditionStack[this.conditionStack.length - 2];
	            },
	            pushState: function begin(condition) {
	                this.begin(condition);
	            } };
	        lexer.options = {};
	        lexer.performAction = function anonymous(yy, yy_, $avoiding_name_collisions, YY_START
	        /**/) {

	            function strip(start, end) {
	                return yy_.yytext = yy_.yytext.substr(start, yy_.yyleng - end);
	            }

	            var YYSTATE = YY_START;
	            switch ($avoiding_name_collisions) {
	                case 0:
	                    if (yy_.yytext.slice(-2) === "\\\\") {
	                        strip(0, 1);
	                        this.begin("mu");
	                    } else if (yy_.yytext.slice(-1) === "\\") {
	                        strip(0, 1);
	                        this.begin("emu");
	                    } else {
	                        this.begin("mu");
	                    }
	                    if (yy_.yytext) return 15;

	                    break;
	                case 1:
	                    return 15;
	                    break;
	                case 2:
	                    this.popState();
	                    return 15;

	                    break;
	                case 3:
	                    this.begin('raw');return 15;
	                    break;
	                case 4:
	                    this.popState();
	                    // Should be using `this.topState()` below, but it currently
	                    // returns the second top instead of the first top. Opened an
	                    // issue about it at https://github.com/zaach/jison/issues/291
	                    if (this.conditionStack[this.conditionStack.length - 1] === 'raw') {
	                        return 15;
	                    } else {
	                        yy_.yytext = yy_.yytext.substr(5, yy_.yyleng - 9);
	                        return 'END_RAW_BLOCK';
	                    }

	                    break;
	                case 5:
	                    return 15;
	                    break;
	                case 6:
	                    this.popState();
	                    return 14;

	                    break;
	                case 7:
	                    return 65;
	                    break;
	                case 8:
	                    return 68;
	                    break;
	                case 9:
	                    return 19;
	                    break;
	                case 10:
	                    this.popState();
	                    this.begin('raw');
	                    return 23;

	                    break;
	                case 11:
	                    return 55;
	                    break;
	                case 12:
	                    return 60;
	                    break;
	                case 13:
	                    return 29;
	                    break;
	                case 14:
	                    return 47;
	                    break;
	                case 15:
	                    this.popState();return 44;
	                    break;
	                case 16:
	                    this.popState();return 44;
	                    break;
	                case 17:
	                    return 34;
	                    break;
	                case 18:
	                    return 39;
	                    break;
	                case 19:
	                    return 51;
	                    break;
	                case 20:
	                    return 48;
	                    break;
	                case 21:
	                    this.unput(yy_.yytext);
	                    this.popState();
	                    this.begin('com');

	                    break;
	                case 22:
	                    this.popState();
	                    return 14;

	                    break;
	                case 23:
	                    return 48;
	                    break;
	                case 24:
	                    return 73;
	                    break;
	                case 25:
	                    return 72;
	                    break;
	                case 26:
	                    return 72;
	                    break;
	                case 27:
	                    return 87;
	                    break;
	                case 28:
	                    // ignore whitespace
	                    break;
	                case 29:
	                    this.popState();return 54;
	                    break;
	                case 30:
	                    this.popState();return 33;
	                    break;
	                case 31:
	                    yy_.yytext = strip(1, 2).replace(/\\"/g, '"');return 80;
	                    break;
	                case 32:
	                    yy_.yytext = strip(1, 2).replace(/\\'/g, "'");return 80;
	                    break;
	                case 33:
	                    return 85;
	                    break;
	                case 34:
	                    return 82;
	                    break;
	                case 35:
	                    return 82;
	                    break;
	                case 36:
	                    return 83;
	                    break;
	                case 37:
	                    return 84;
	                    break;
	                case 38:
	                    return 81;
	                    break;
	                case 39:
	                    return 75;
	                    break;
	                case 40:
	                    return 77;
	                    break;
	                case 41:
	                    return 72;
	                    break;
	                case 42:
	                    yy_.yytext = yy_.yytext.replace(/\\([\\\]])/g, '$1');return 72;
	                    break;
	                case 43:
	                    return 'INVALID';
	                    break;
	                case 44:
	                    return 5;
	                    break;
	            }
	        };
	        lexer.rules = [/^(?:[^\x00]*?(?=(\{\{)))/, /^(?:[^\x00]+)/, /^(?:[^\x00]{2,}?(?=(\{\{|\\\{\{|\\\\\{\{|$)))/, /^(?:\{\{\{\{(?=[^\/]))/, /^(?:\{\{\{\{\/[^\s!"#%-,\.\/;->@\[-\^`\{-~]+(?=[=}\s\/.])\}\}\}\})/, /^(?:[^\x00]*?(?=(\{\{\{\{)))/, /^(?:[\s\S]*?--(~)?\}\})/, /^(?:\()/, /^(?:\))/, /^(?:\{\{\{\{)/, /^(?:\}\}\}\})/, /^(?:\{\{(~)?>)/, /^(?:\{\{(~)?#>)/, /^(?:\{\{(~)?#\*?)/, /^(?:\{\{(~)?\/)/, /^(?:\{\{(~)?\^\s*(~)?\}\})/, /^(?:\{\{(~)?\s*else\s*(~)?\}\})/, /^(?:\{\{(~)?\^)/, /^(?:\{\{(~)?\s*else\b)/, /^(?:\{\{(~)?\{)/, /^(?:\{\{(~)?&)/, /^(?:\{\{(~)?!--)/, /^(?:\{\{(~)?![\s\S]*?\}\})/, /^(?:\{\{(~)?\*?)/, /^(?:=)/, /^(?:\.\.)/, /^(?:\.(?=([=~}\s\/.)|])))/, /^(?:[\/.])/, /^(?:\s+)/, /^(?:\}(~)?\}\})/, /^(?:(~)?\}\})/, /^(?:"(\\["]|[^"])*")/, /^(?:'(\\[']|[^'])*')/, /^(?:@)/, /^(?:true(?=([~}\s)])))/, /^(?:false(?=([~}\s)])))/, /^(?:undefined(?=([~}\s)])))/, /^(?:null(?=([~}\s)])))/, /^(?:-?[0-9]+(?:\.[0-9]+)?(?=([~}\s)])))/, /^(?:as\s+\|)/, /^(?:\|)/, /^(?:([^\s!"#%-,\.\/;->@\[-\^`\{-~]+(?=([=~}\s\/.)|]))))/, /^(?:\[(\\\]|[^\]])*\])/, /^(?:.)/, /^(?:$)/];
	        lexer.conditions = { "mu": { "rules": [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44], "inclusive": false }, "emu": { "rules": [2], "inclusive": false }, "com": { "rules": [6], "inclusive": false }, "raw": { "rules": [3, 4, 5], "inclusive": false }, "INITIAL": { "rules": [0, 1, 44], "inclusive": true } };
	        return lexer;
	    })();
	    parser.lexer = lexer;
	    function Parser() {
	        this.yy = {};
	    }Parser.prototype = parser;parser.Parser = Parser;
	    return new Parser();
	})();exports.__esModule = true;
	exports['default'] = handlebars;

/***/ },
/* 27 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var _interopRequireDefault = __webpack_require__(1)['default'];

	exports.__esModule = true;

	var _visitor = __webpack_require__(28);

	var _visitor2 = _interopRequireDefault(_visitor);

	function WhitespaceControl() {
	  var options = arguments.length <= 0 || arguments[0] === undefined ? {} : arguments[0];

	  this.options = options;
	}
	WhitespaceControl.prototype = new _visitor2['default']();

	WhitespaceControl.prototype.Program = function (program) {
	  var doStandalone = !this.options.ignoreStandalone;

	  var isRoot = !this.isRootSeen;
	  this.isRootSeen = true;

	  var body = program.body;
	  for (var i = 0, l = body.length; i < l; i++) {
	    var current = body[i],
	        strip = this.accept(current);

	    if (!strip) {
	      continue;
	    }

	    var _isPrevWhitespace = isPrevWhitespace(body, i, isRoot),
	        _isNextWhitespace = isNextWhitespace(body, i, isRoot),
	        openStandalone = strip.openStandalone && _isPrevWhitespace,
	        closeStandalone = strip.closeStandalone && _isNextWhitespace,
	        inlineStandalone = strip.inlineStandalone && _isPrevWhitespace && _isNextWhitespace;

	    if (strip.close) {
	      omitRight(body, i, true);
	    }
	    if (strip.open) {
	      omitLeft(body, i, true);
	    }

	    if (doStandalone && inlineStandalone) {
	      omitRight(body, i);

	      if (omitLeft(body, i)) {
	        // If we are on a standalone node, save the indent info for partials
	        if (current.type === 'PartialStatement') {
	          // Pull out the whitespace from the final line
	          current.indent = /([ \t]+$)/.exec(body[i - 1].original)[1];
	        }
	      }
	    }
	    if (doStandalone && openStandalone) {
	      omitRight((current.program || current.inverse).body);

	      // Strip out the previous content node if it's whitespace only
	      omitLeft(body, i);
	    }
	    if (doStandalone && closeStandalone) {
	      // Always strip the next node
	      omitRight(body, i);

	      omitLeft((current.inverse || current.program).body);
	    }
	  }

	  return program;
	};

	WhitespaceControl.prototype.BlockStatement = WhitespaceControl.prototype.DecoratorBlock = WhitespaceControl.prototype.PartialBlockStatement = function (block) {
	  this.accept(block.program);
	  this.accept(block.inverse);

	  // Find the inverse program that is involed with whitespace stripping.
	  var program = block.program || block.inverse,
	      inverse = block.program && block.inverse,
	      firstInverse = inverse,
	      lastInverse = inverse;

	  if (inverse && inverse.chained) {
	    firstInverse = inverse.body[0].program;

	    // Walk the inverse chain to find the last inverse that is actually in the chain.
	    while (lastInverse.chained) {
	      lastInverse = lastInverse.body[lastInverse.body.length - 1].program;
	    }
	  }

	  var strip = {
	    open: block.openStrip.open,
	    close: block.closeStrip.close,

	    // Determine the standalone candiacy. Basically flag our content as being possibly standalone
	    // so our parent can determine if we actually are standalone
	    openStandalone: isNextWhitespace(program.body),
	    closeStandalone: isPrevWhitespace((firstInverse || program).body)
	  };

	  if (block.openStrip.close) {
	    omitRight(program.body, null, true);
	  }

	  if (inverse) {
	    var inverseStrip = block.inverseStrip;

	    if (inverseStrip.open) {
	      omitLeft(program.body, null, true);
	    }

	    if (inverseStrip.close) {
	      omitRight(firstInverse.body, null, true);
	    }
	    if (block.closeStrip.open) {
	      omitLeft(lastInverse.body, null, true);
	    }

	    // Find standalone else statments
	    if (!this.options.ignoreStandalone && isPrevWhitespace(program.body) && isNextWhitespace(firstInverse.body)) {
	      omitLeft(program.body);
	      omitRight(firstInverse.body);
	    }
	  } else if (block.closeStrip.open) {
	    omitLeft(program.body, null, true);
	  }

	  return strip;
	};

	WhitespaceControl.prototype.Decorator = WhitespaceControl.prototype.MustacheStatement = function (mustache) {
	  return mustache.strip;
	};

	WhitespaceControl.prototype.PartialStatement = WhitespaceControl.prototype.CommentStatement = function (node) {
	  /* istanbul ignore next */
	  var strip = node.strip || {};
	  return {
	    inlineStandalone: true,
	    open: strip.open,
	    close: strip.close
	  };
	};

	function isPrevWhitespace(body, i, isRoot) {
	  if (i === undefined) {
	    i = body.length;
	  }

	  // Nodes that end with newlines are considered whitespace (but are special
	  // cased for strip operations)
	  var prev = body[i - 1],
	      sibling = body[i - 2];
	  if (!prev) {
	    return isRoot;
	  }

	  if (prev.type === 'ContentStatement') {
	    return (sibling || !isRoot ? /\r?\n\s*?$/ : /(^|\r?\n)\s*?$/).test(prev.original);
	  }
	}
	function isNextWhitespace(body, i, isRoot) {
	  if (i === undefined) {
	    i = -1;
	  }

	  var next = body[i + 1],
	      sibling = body[i + 2];
	  if (!next) {
	    return isRoot;
	  }

	  if (next.type === 'ContentStatement') {
	    return (sibling || !isRoot ? /^\s*?\r?\n/ : /^\s*?(\r?\n|$)/).test(next.original);
	  }
	}

	// Marks the node to the right of the position as omitted.
	// I.e. {{foo}}' ' will mark the ' ' node as omitted.
	//
	// If i is undefined, then the first child will be marked as such.
	//
	// If mulitple is truthy then all whitespace will be stripped out until non-whitespace
	// content is met.
	function omitRight(body, i, multiple) {
	  var current = body[i == null ? 0 : i + 1];
	  if (!current || current.type !== 'ContentStatement' || !multiple && current.rightStripped) {
	    return;
	  }

	  var original = current.value;
	  current.value = current.value.replace(multiple ? /^\s+/ : /^[ \t]*\r?\n?/, '');
	  current.rightStripped = current.value !== original;
	}

	// Marks the node to the left of the position as omitted.
	// I.e. ' '{{foo}} will mark the ' ' node as omitted.
	//
	// If i is undefined then the last child will be marked as such.
	//
	// If mulitple is truthy then all whitespace will be stripped out until non-whitespace
	// content is met.
	function omitLeft(body, i, multiple) {
	  var current = body[i == null ? body.length - 1 : i - 1];
	  if (!current || current.type !== 'ContentStatement' || !multiple && current.leftStripped) {
	    return;
	  }

	  // We omit the last node if it's whitespace only and not preceeded by a non-content node.
	  var original = current.value;
	  current.value = current.value.replace(multiple ? /\s+$/ : /[ \t]+$/, '');
	  current.leftStripped = current.value !== original;
	  return current.leftStripped;
	}

	exports['default'] = WhitespaceControl;
	module.exports = exports['default'];

/***/ },
/* 28 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var _interopRequireDefault = __webpack_require__(1)['default'];

	exports.__esModule = true;

	var _exception = __webpack_require__(6);

	var _exception2 = _interopRequireDefault(_exception);

	function Visitor() {
	  this.parents = [];
	}

	Visitor.prototype = {
	  constructor: Visitor,
	  mutating: false,

	  // Visits a given value. If mutating, will replace the value if necessary.
	  acceptKey: function acceptKey(node, name) {
	    var value = this.accept(node[name]);
	    if (this.mutating) {
	      // Hacky sanity check: This may have a few false positives for type for the helper
	      // methods but will generally do the right thing without a lot of overhead.
	      if (value && !Visitor.prototype[value.type]) {
	        throw new _exception2['default']('Unexpected node type "' + value.type + '" found when accepting ' + name + ' on ' + node.type);
	      }
	      node[name] = value;
	    }
	  },

	  // Performs an accept operation with added sanity check to ensure
	  // required keys are not removed.
	  acceptRequired: function acceptRequired(node, name) {
	    this.acceptKey(node, name);

	    if (!node[name]) {
	      throw new _exception2['default'](node.type + ' requires ' + name);
	    }
	  },

	  // Traverses a given array. If mutating, empty respnses will be removed
	  // for child elements.
	  acceptArray: function acceptArray(array) {
	    for (var i = 0, l = array.length; i < l; i++) {
	      this.acceptKey(array, i);

	      if (!array[i]) {
	        array.splice(i, 1);
	        i--;
	        l--;
	      }
	    }
	  },

	  accept: function accept(object) {
	    if (!object) {
	      return;
	    }

	    /* istanbul ignore next: Sanity code */
	    if (!this[object.type]) {
	      throw new _exception2['default']('Unknown type: ' + object.type, object);
	    }

	    if (this.current) {
	      this.parents.unshift(this.current);
	    }
	    this.current = object;

	    var ret = this[object.type](object);

	    this.current = this.parents.shift();

	    if (!this.mutating || ret) {
	      return ret;
	    } else if (ret !== false) {
	      return object;
	    }
	  },

	  Program: function Program(program) {
	    this.acceptArray(program.body);
	  },

	  MustacheStatement: visitSubExpression,
	  Decorator: visitSubExpression,

	  BlockStatement: visitBlock,
	  DecoratorBlock: visitBlock,

	  PartialStatement: visitPartial,
	  PartialBlockStatement: function PartialBlockStatement(partial) {
	    visitPartial.call(this, partial);

	    this.acceptKey(partial, 'program');
	  },

	  ContentStatement: function ContentStatement() /* content */{},
	  CommentStatement: function CommentStatement() /* comment */{},

	  SubExpression: visitSubExpression,

	  PathExpression: function PathExpression() /* path */{},

	  StringLiteral: function StringLiteral() /* string */{},
	  NumberLiteral: function NumberLiteral() /* number */{},
	  BooleanLiteral: function BooleanLiteral() /* bool */{},
	  UndefinedLiteral: function UndefinedLiteral() /* literal */{},
	  NullLiteral: function NullLiteral() /* literal */{},

	  Hash: function Hash(hash) {
	    this.acceptArray(hash.pairs);
	  },
	  HashPair: function HashPair(pair) {
	    this.acceptRequired(pair, 'value');
	  }
	};

	function visitSubExpression(mustache) {
	  this.acceptRequired(mustache, 'path');
	  this.acceptArray(mustache.params);
	  this.acceptKey(mustache, 'hash');
	}
	function visitBlock(block) {
	  visitSubExpression.call(this, block);

	  this.acceptKey(block, 'program');
	  this.acceptKey(block, 'inverse');
	}
	function visitPartial(partial) {
	  this.acceptRequired(partial, 'name');
	  this.acceptArray(partial.params);
	  this.acceptKey(partial, 'hash');
	}

	exports['default'] = Visitor;
	module.exports = exports['default'];

/***/ },
/* 29 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var _interopRequireDefault = __webpack_require__(1)['default'];

	exports.__esModule = true;
	exports.SourceLocation = SourceLocation;
	exports.id = id;
	exports.stripFlags = stripFlags;
	exports.stripComment = stripComment;
	exports.preparePath = preparePath;
	exports.prepareMustache = prepareMustache;
	exports.prepareRawBlock = prepareRawBlock;
	exports.prepareBlock = prepareBlock;
	exports.prepareProgram = prepareProgram;
	exports.preparePartialBlock = preparePartialBlock;

	var _exception = __webpack_require__(6);

	var _exception2 = _interopRequireDefault(_exception);

	function validateClose(open, close) {
	  close = close.path ? close.path.original : close;

	  if (open.path.original !== close) {
	    var errorNode = { loc: open.path.loc };

	    throw new _exception2['default'](open.path.original + " doesn't match " + close, errorNode);
	  }
	}

	function SourceLocation(source, locInfo) {
	  this.source = source;
	  this.start = {
	    line: locInfo.first_line,
	    column: locInfo.first_column
	  };
	  this.end = {
	    line: locInfo.last_line,
	    column: locInfo.last_column
	  };
	}

	function id(token) {
	  if (/^\[.*\]$/.test(token)) {
	    return token.substr(1, token.length - 2);
	  } else {
	    return token;
	  }
	}

	function stripFlags(open, close) {
	  return {
	    open: open.charAt(2) === '~',
	    close: close.charAt(close.length - 3) === '~'
	  };
	}

	function stripComment(comment) {
	  return comment.replace(/^\{\{~?\!-?-?/, '').replace(/-?-?~?\}\}$/, '');
	}

	function preparePath(data, parts, loc) {
	  loc = this.locInfo(loc);

	  var original = data ? '@' : '',
	      dig = [],
	      depth = 0,
	      depthString = '';

	  for (var i = 0, l = parts.length; i < l; i++) {
	    var part = parts[i].part,

	    // If we have [] syntax then we do not treat path references as operators,
	    // i.e. foo.[this] resolves to approximately context.foo['this']
	    isLiteral = parts[i].original !== part;
	    original += (parts[i].separator || '') + part;

	    if (!isLiteral && (part === '..' || part === '.' || part === 'this')) {
	      if (dig.length > 0) {
	        throw new _exception2['default']('Invalid path: ' + original, { loc: loc });
	      } else if (part === '..') {
	        depth++;
	        depthString += '../';
	      }
	    } else {
	      dig.push(part);
	    }
	  }

	  return {
	    type: 'PathExpression',
	    data: data,
	    depth: depth,
	    parts: dig,
	    original: original,
	    loc: loc
	  };
	}

	function prepareMustache(path, params, hash, open, strip, locInfo) {
	  // Must use charAt to support IE pre-10
	  var escapeFlag = open.charAt(3) || open.charAt(2),
	      escaped = escapeFlag !== '{' && escapeFlag !== '&';

	  var decorator = /\*/.test(open);
	  return {
	    type: decorator ? 'Decorator' : 'MustacheStatement',
	    path: path,
	    params: params,
	    hash: hash,
	    escaped: escaped,
	    strip: strip,
	    loc: this.locInfo(locInfo)
	  };
	}

	function prepareRawBlock(openRawBlock, contents, close, locInfo) {
	  validateClose(openRawBlock, close);

	  locInfo = this.locInfo(locInfo);
	  var program = {
	    type: 'Program',
	    body: contents,
	    strip: {},
	    loc: locInfo
	  };

	  return {
	    type: 'BlockStatement',
	    path: openRawBlock.path,
	    params: openRawBlock.params,
	    hash: openRawBlock.hash,
	    program: program,
	    openStrip: {},
	    inverseStrip: {},
	    closeStrip: {},
	    loc: locInfo
	  };
	}

	function prepareBlock(openBlock, program, inverseAndProgram, close, inverted, locInfo) {
	  if (close && close.path) {
	    validateClose(openBlock, close);
	  }

	  var decorator = /\*/.test(openBlock.open);

	  program.blockParams = openBlock.blockParams;

	  var inverse = undefined,
	      inverseStrip = undefined;

	  if (inverseAndProgram) {
	    if (decorator) {
	      throw new _exception2['default']('Unexpected inverse block on decorator', inverseAndProgram);
	    }

	    if (inverseAndProgram.chain) {
	      inverseAndProgram.program.body[0].closeStrip = close.strip;
	    }

	    inverseStrip = inverseAndProgram.strip;
	    inverse = inverseAndProgram.program;
	  }

	  if (inverted) {
	    inverted = inverse;
	    inverse = program;
	    program = inverted;
	  }

	  return {
	    type: decorator ? 'DecoratorBlock' : 'BlockStatement',
	    path: openBlock.path,
	    params: openBlock.params,
	    hash: openBlock.hash,
	    program: program,
	    inverse: inverse,
	    openStrip: openBlock.strip,
	    inverseStrip: inverseStrip,
	    closeStrip: close && close.strip,
	    loc: this.locInfo(locInfo)
	  };
	}

	function prepareProgram(statements, loc) {
	  if (!loc && statements.length) {
	    var firstLoc = statements[0].loc,
	        lastLoc = statements[statements.length - 1].loc;

	    /* istanbul ignore else */
	    if (firstLoc && lastLoc) {
	      loc = {
	        source: firstLoc.source,
	        start: {
	          line: firstLoc.start.line,
	          column: firstLoc.start.column
	        },
	        end: {
	          line: lastLoc.end.line,
	          column: lastLoc.end.column
	        }
	      };
	    }
	  }

	  return {
	    type: 'Program',
	    body: statements,
	    strip: {},
	    loc: loc
	  };
	}

	function preparePartialBlock(open, program, close, locInfo) {
	  validateClose(open, close);

	  return {
	    type: 'PartialBlockStatement',
	    name: open.path,
	    params: open.params,
	    hash: open.hash,
	    program: program,
	    openStrip: open.strip,
	    closeStrip: close && close.strip,
	    loc: this.locInfo(locInfo)
	  };
	}

/***/ },
/* 30 */
/***/ function(module, exports, __webpack_require__) {

	/* eslint-disable new-cap */

	'use strict';

	var _interopRequireDefault = __webpack_require__(1)['default'];

	exports.__esModule = true;
	exports.Compiler = Compiler;
	exports.precompile = precompile;
	exports.compile = compile;

	var _exception = __webpack_require__(6);

	var _exception2 = _interopRequireDefault(_exception);

	var _utils = __webpack_require__(5);

	var _ast = __webpack_require__(24);

	var _ast2 = _interopRequireDefault(_ast);

	var slice = [].slice;

	function Compiler() {}

	// the foundHelper register will disambiguate helper lookup from finding a
	// function in a context. This is necessary for mustache compatibility, which
	// requires that context functions in blocks are evaluated by blockHelperMissing,
	// and then proceed as if the resulting value was provided to blockHelperMissing.

	Compiler.prototype = {
	  compiler: Compiler,

	  equals: function equals(other) {
	    var len = this.opcodes.length;
	    if (other.opcodes.length !== len) {
	      return false;
	    }

	    for (var i = 0; i < len; i++) {
	      var opcode = this.opcodes[i],
	          otherOpcode = other.opcodes[i];
	      if (opcode.opcode !== otherOpcode.opcode || !argEquals(opcode.args, otherOpcode.args)) {
	        return false;
	      }
	    }

	    // We know that length is the same between the two arrays because they are directly tied
	    // to the opcode behavior above.
	    len = this.children.length;
	    for (var i = 0; i < len; i++) {
	      if (!this.children[i].equals(other.children[i])) {
	        return false;
	      }
	    }

	    return true;
	  },

	  guid: 0,

	  compile: function compile(program, options) {
	    this.sourceNode = [];
	    this.opcodes = [];
	    this.children = [];
	    this.options = options;
	    this.stringParams = options.stringParams;
	    this.trackIds = options.trackIds;

	    options.blockParams = options.blockParams || [];

	    // These changes will propagate to the other compiler components
	    var knownHelpers = options.knownHelpers;
	    options.knownHelpers = {
	      'helperMissing': true,
	      'blockHelperMissing': true,
	      'each': true,
	      'if': true,
	      'unless': true,
	      'with': true,
	      'log': true,
	      'lookup': true
	    };
	    if (knownHelpers) {
	      for (var _name in knownHelpers) {
	        /* istanbul ignore else */
	        if (_name in knownHelpers) {
	          options.knownHelpers[_name] = knownHelpers[_name];
	        }
	      }
	    }

	    return this.accept(program);
	  },

	  compileProgram: function compileProgram(program) {
	    var childCompiler = new this.compiler(),
	        // eslint-disable-line new-cap
	    result = childCompiler.compile(program, this.options),
	        guid = this.guid++;

	    this.usePartial = this.usePartial || result.usePartial;

	    this.children[guid] = result;
	    this.useDepths = this.useDepths || result.useDepths;

	    return guid;
	  },

	  accept: function accept(node) {
	    /* istanbul ignore next: Sanity code */
	    if (!this[node.type]) {
	      throw new _exception2['default']('Unknown type: ' + node.type, node);
	    }

	    this.sourceNode.unshift(node);
	    var ret = this[node.type](node);
	    this.sourceNode.shift();
	    return ret;
	  },

	  Program: function Program(program) {
	    this.options.blockParams.unshift(program.blockParams);

	    var body = program.body,
	        bodyLength = body.length;
	    for (var i = 0; i < bodyLength; i++) {
	      this.accept(body[i]);
	    }

	    this.options.blockParams.shift();

	    this.isSimple = bodyLength === 1;
	    this.blockParams = program.blockParams ? program.blockParams.length : 0;

	    return this;
	  },

	  BlockStatement: function BlockStatement(block) {
	    transformLiteralToPath(block);

	    var program = block.program,
	        inverse = block.inverse;

	    program = program && this.compileProgram(program);
	    inverse = inverse && this.compileProgram(inverse);

	    var type = this.classifySexpr(block);

	    if (type === 'helper') {
	      this.helperSexpr(block, program, inverse);
	    } else if (type === 'simple') {
	      this.simpleSexpr(block);

	      // now that the simple mustache is resolved, we need to
	      // evaluate it by executing `blockHelperMissing`
	      this.opcode('pushProgram', program);
	      this.opcode('pushProgram', inverse);
	      this.opcode('emptyHash');
	      this.opcode('blockValue', block.path.original);
	    } else {
	      this.ambiguousSexpr(block, program, inverse);

	      // now that the simple mustache is resolved, we need to
	      // evaluate it by executing `blockHelperMissing`
	      this.opcode('pushProgram', program);
	      this.opcode('pushProgram', inverse);
	      this.opcode('emptyHash');
	      this.opcode('ambiguousBlockValue');
	    }

	    this.opcode('append');
	  },

	  DecoratorBlock: function DecoratorBlock(decorator) {
	    var program = decorator.program && this.compileProgram(decorator.program);
	    var params = this.setupFullMustacheParams(decorator, program, undefined),
	        path = decorator.path;

	    this.useDecorators = true;
	    this.opcode('registerDecorator', params.length, path.original);
	  },

	  PartialStatement: function PartialStatement(partial) {
	    this.usePartial = true;

	    var program = partial.program;
	    if (program) {
	      program = this.compileProgram(partial.program);
	    }

	    var params = partial.params;
	    if (params.length > 1) {
	      throw new _exception2['default']('Unsupported number of partial arguments: ' + params.length, partial);
	    } else if (!params.length) {
	      if (this.options.explicitPartialContext) {
	        this.opcode('pushLiteral', 'undefined');
	      } else {
	        params.push({ type: 'PathExpression', parts: [], depth: 0 });
	      }
	    }

	    var partialName = partial.name.original,
	        isDynamic = partial.name.type === 'SubExpression';
	    if (isDynamic) {
	      this.accept(partial.name);
	    }

	    this.setupFullMustacheParams(partial, program, undefined, true);

	    var indent = partial.indent || '';
	    if (this.options.preventIndent && indent) {
	      this.opcode('appendContent', indent);
	      indent = '';
	    }

	    this.opcode('invokePartial', isDynamic, partialName, indent);
	    this.opcode('append');
	  },
	  PartialBlockStatement: function PartialBlockStatement(partialBlock) {
	    this.PartialStatement(partialBlock);
	  },

	  MustacheStatement: function MustacheStatement(mustache) {
	    this.SubExpression(mustache);

	    if (mustache.escaped && !this.options.noEscape) {
	      this.opcode('appendEscaped');
	    } else {
	      this.opcode('append');
	    }
	  },
	  Decorator: function Decorator(decorator) {
	    this.DecoratorBlock(decorator);
	  },

	  ContentStatement: function ContentStatement(content) {
	    if (content.value) {
	      this.opcode('appendContent', content.value);
	    }
	  },

	  CommentStatement: function CommentStatement() {},

	  SubExpression: function SubExpression(sexpr) {
	    transformLiteralToPath(sexpr);
	    var type = this.classifySexpr(sexpr);

	    if (type === 'simple') {
	      this.simpleSexpr(sexpr);
	    } else if (type === 'helper') {
	      this.helperSexpr(sexpr);
	    } else {
	      this.ambiguousSexpr(sexpr);
	    }
	  },
	  ambiguousSexpr: function ambiguousSexpr(sexpr, program, inverse) {
	    var path = sexpr.path,
	        name = path.parts[0],
	        isBlock = program != null || inverse != null;

	    this.opcode('getContext', path.depth);

	    this.opcode('pushProgram', program);
	    this.opcode('pushProgram', inverse);

	    path.strict = true;
	    this.accept(path);

	    this.opcode('invokeAmbiguous', name, isBlock);
	  },

	  simpleSexpr: function simpleSexpr(sexpr) {
	    var path = sexpr.path;
	    path.strict = true;
	    this.accept(path);
	    this.opcode('resolvePossibleLambda');
	  },

	  helperSexpr: function helperSexpr(sexpr, program, inverse) {
	    var params = this.setupFullMustacheParams(sexpr, program, inverse),
	        path = sexpr.path,
	        name = path.parts[0];

	    if (this.options.knownHelpers[name]) {
	      this.opcode('invokeKnownHelper', params.length, name);
	    } else if (this.options.knownHelpersOnly) {
	      throw new _exception2['default']('You specified knownHelpersOnly, but used the unknown helper ' + name, sexpr);
	    } else {
	      path.strict = true;
	      path.falsy = true;

	      this.accept(path);
	      this.opcode('invokeHelper', params.length, path.original, _ast2['default'].helpers.simpleId(path));
	    }
	  },

	  PathExpression: function PathExpression(path) {
	    this.addDepth(path.depth);
	    this.opcode('getContext', path.depth);

	    var name = path.parts[0],
	        scoped = _ast2['default'].helpers.scopedId(path),
	        blockParamId = !path.depth && !scoped && this.blockParamIndex(name);

	    if (blockParamId) {
	      this.opcode('lookupBlockParam', blockParamId, path.parts);
	    } else if (!name) {
	      // Context reference, i.e. `{{foo .}}` or `{{foo ..}}`
	      this.opcode('pushContext');
	    } else if (path.data) {
	      this.options.data = true;
	      this.opcode('lookupData', path.depth, path.parts, path.strict);
	    } else {
	      this.opcode('lookupOnContext', path.parts, path.falsy, path.strict, scoped);
	    }
	  },

	  StringLiteral: function StringLiteral(string) {
	    this.opcode('pushString', string.value);
	  },

	  NumberLiteral: function NumberLiteral(number) {
	    this.opcode('pushLiteral', number.value);
	  },

	  BooleanLiteral: function BooleanLiteral(bool) {
	    this.opcode('pushLiteral', bool.value);
	  },

	  UndefinedLiteral: function UndefinedLiteral() {
	    this.opcode('pushLiteral', 'undefined');
	  },

	  NullLiteral: function NullLiteral() {
	    this.opcode('pushLiteral', 'null');
	  },

	  Hash: function Hash(hash) {
	    var pairs = hash.pairs,
	        i = 0,
	        l = pairs.length;

	    this.opcode('pushHash');

	    for (; i < l; i++) {
	      this.pushParam(pairs[i].value);
	    }
	    while (i--) {
	      this.opcode('assignToHash', pairs[i].key);
	    }
	    this.opcode('popHash');
	  },

	  // HELPERS
	  opcode: function opcode(name) {
	    this.opcodes.push({ opcode: name, args: slice.call(arguments, 1), loc: this.sourceNode[0].loc });
	  },

	  addDepth: function addDepth(depth) {
	    if (!depth) {
	      return;
	    }

	    this.useDepths = true;
	  },

	  classifySexpr: function classifySexpr(sexpr) {
	    var isSimple = _ast2['default'].helpers.simpleId(sexpr.path);

	    var isBlockParam = isSimple && !!this.blockParamIndex(sexpr.path.parts[0]);

	    // a mustache is an eligible helper if:
	    // * its id is simple (a single part, not `this` or `..`)
	    var isHelper = !isBlockParam && _ast2['default'].helpers.helperExpression(sexpr);

	    // if a mustache is an eligible helper but not a definite
	    // helper, it is ambiguous, and will be resolved in a later
	    // pass or at runtime.
	    var isEligible = !isBlockParam && (isHelper || isSimple);

	    // if ambiguous, we can possibly resolve the ambiguity now
	    // An eligible helper is one that does not have a complex path, i.e. `this.foo`, `../foo` etc.
	    if (isEligible && !isHelper) {
	      var _name2 = sexpr.path.parts[0],
	          options = this.options;

	      if (options.knownHelpers[_name2]) {
	        isHelper = true;
	      } else if (options.knownHelpersOnly) {
	        isEligible = false;
	      }
	    }

	    if (isHelper) {
	      return 'helper';
	    } else if (isEligible) {
	      return 'ambiguous';
	    } else {
	      return 'simple';
	    }
	  },

	  pushParams: function pushParams(params) {
	    for (var i = 0, l = params.length; i < l; i++) {
	      this.pushParam(params[i]);
	    }
	  },

	  pushParam: function pushParam(val) {
	    var value = val.value != null ? val.value : val.original || '';

	    if (this.stringParams) {
	      if (value.replace) {
	        value = value.replace(/^(\.?\.\/)*/g, '').replace(/\//g, '.');
	      }

	      if (val.depth) {
	        this.addDepth(val.depth);
	      }
	      this.opcode('getContext', val.depth || 0);
	      this.opcode('pushStringParam', value, val.type);

	      if (val.type === 'SubExpression') {
	        // SubExpressions get evaluated and passed in
	        // in string params mode.
	        this.accept(val);
	      }
	    } else {
	      if (this.trackIds) {
	        var blockParamIndex = undefined;
	        if (val.parts && !_ast2['default'].helpers.scopedId(val) && !val.depth) {
	          blockParamIndex = this.blockParamIndex(val.parts[0]);
	        }
	        if (blockParamIndex) {
	          var blockParamChild = val.parts.slice(1).join('.');
	          this.opcode('pushId', 'BlockParam', blockParamIndex, blockParamChild);
	        } else {
	          value = val.original || value;
	          if (value.replace) {
	            value = value.replace(/^this(?:\.|$)/, '').replace(/^\.\//, '').replace(/^\.$/, '');
	          }

	          this.opcode('pushId', val.type, value);
	        }
	      }
	      this.accept(val);
	    }
	  },

	  setupFullMustacheParams: function setupFullMustacheParams(sexpr, program, inverse, omitEmpty) {
	    var params = sexpr.params;
	    this.pushParams(params);

	    this.opcode('pushProgram', program);
	    this.opcode('pushProgram', inverse);

	    if (sexpr.hash) {
	      this.accept(sexpr.hash);
	    } else {
	      this.opcode('emptyHash', omitEmpty);
	    }

	    return params;
	  },

	  blockParamIndex: function blockParamIndex(name) {
	    for (var depth = 0, len = this.options.blockParams.length; depth < len; depth++) {
	      var blockParams = this.options.blockParams[depth],
	          param = blockParams && _utils.indexOf(blockParams, name);
	      if (blockParams && param >= 0) {
	        return [depth, param];
	      }
	    }
	  }
	};

	function precompile(input, options, env) {
	  if (input == null || typeof input !== 'string' && input.type !== 'Program') {
	    throw new _exception2['default']('You must pass a string or Handlebars AST to Handlebars.precompile. You passed ' + input);
	  }

	  options = options || {};
	  if (!('data' in options)) {
	    options.data = true;
	  }
	  if (options.compat) {
	    options.useDepths = true;
	  }

	  var ast = env.parse(input, options),
	      environment = new env.Compiler().compile(ast, options);
	  return new env.JavaScriptCompiler().compile(environment, options);
	}

	function compile(input, options, env) {
	  if (options === undefined) options = {};

	  if (input == null || typeof input !== 'string' && input.type !== 'Program') {
	    throw new _exception2['default']('You must pass a string or Handlebars AST to Handlebars.compile. You passed ' + input);
	  }

	  if (!('data' in options)) {
	    options.data = true;
	  }
	  if (options.compat) {
	    options.useDepths = true;
	  }

	  var compiled = undefined;

	  function compileInput() {
	    var ast = env.parse(input, options),
	        environment = new env.Compiler().compile(ast, options),
	        templateSpec = new env.JavaScriptCompiler().compile(environment, options, undefined, true);
	    return env.template(templateSpec);
	  }

	  // Template is only compiled on first use and cached after that point.
	  function ret(context, execOptions) {
	    if (!compiled) {
	      compiled = compileInput();
	    }
	    return compiled.call(this, context, execOptions);
	  }
	  ret._setup = function (setupOptions) {
	    if (!compiled) {
	      compiled = compileInput();
	    }
	    return compiled._setup(setupOptions);
	  };
	  ret._child = function (i, data, blockParams, depths) {
	    if (!compiled) {
	      compiled = compileInput();
	    }
	    return compiled._child(i, data, blockParams, depths);
	  };
	  return ret;
	}

	function argEquals(a, b) {
	  if (a === b) {
	    return true;
	  }

	  if (_utils.isArray(a) && _utils.isArray(b) && a.length === b.length) {
	    for (var i = 0; i < a.length; i++) {
	      if (!argEquals(a[i], b[i])) {
	        return false;
	      }
	    }
	    return true;
	  }
	}

	function transformLiteralToPath(sexpr) {
	  if (!sexpr.path.parts) {
	    var literal = sexpr.path;
	    // Casting to string here to make false and 0 literal values play nicely with the rest
	    // of the system.
	    sexpr.path = {
	      type: 'PathExpression',
	      data: false,
	      depth: 0,
	      parts: [literal.original + ''],
	      original: literal.original + '',
	      loc: literal.loc
	    };
	  }
	}

/***/ },
/* 31 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var _interopRequireDefault = __webpack_require__(1)['default'];

	exports.__esModule = true;

	var _base = __webpack_require__(4);

	var _exception = __webpack_require__(6);

	var _exception2 = _interopRequireDefault(_exception);

	var _utils = __webpack_require__(5);

	var _codeGen = __webpack_require__(32);

	var _codeGen2 = _interopRequireDefault(_codeGen);

	function Literal(value) {
	  this.value = value;
	}

	function JavaScriptCompiler() {}

	JavaScriptCompiler.prototype = {
	  // PUBLIC API: You can override these methods in a subclass to provide
	  // alternative compiled forms for name lookup and buffering semantics
	  nameLookup: function nameLookup(parent, name /* , type*/) {
	    if (JavaScriptCompiler.isValidJavaScriptVariableName(name)) {
	      return [parent, '.', name];
	    } else {
	      return [parent, '[', JSON.stringify(name), ']'];
	    }
	  },
	  depthedLookup: function depthedLookup(name) {
	    return [this.aliasable('container.lookup'), '(depths, "', name, '")'];
	  },

	  compilerInfo: function compilerInfo() {
	    var revision = _base.COMPILER_REVISION,
	        versions = _base.REVISION_CHANGES[revision];
	    return [revision, versions];
	  },

	  appendToBuffer: function appendToBuffer(source, location, explicit) {
	    // Force a source as this simplifies the merge logic.
	    if (!_utils.isArray(source)) {
	      source = [source];
	    }
	    source = this.source.wrap(source, location);

	    if (this.environment.isSimple) {
	      return ['return ', source, ';'];
	    } else if (explicit) {
	      // This is a case where the buffer operation occurs as a child of another
	      // construct, generally braces. We have to explicitly output these buffer
	      // operations to ensure that the emitted code goes in the correct location.
	      return ['buffer += ', source, ';'];
	    } else {
	      source.appendToBuffer = true;
	      return source;
	    }
	  },

	  initializeBuffer: function initializeBuffer() {
	    return this.quotedString('');
	  },
	  // END PUBLIC API

	  compile: function compile(environment, options, context, asObject) {
	    this.environment = environment;
	    this.options = options;
	    this.stringParams = this.options.stringParams;
	    this.trackIds = this.options.trackIds;
	    this.precompile = !asObject;

	    this.name = this.environment.name;
	    this.isChild = !!context;
	    this.context = context || {
	      decorators: [],
	      programs: [],
	      environments: []
	    };

	    this.preamble();

	    this.stackSlot = 0;
	    this.stackVars = [];
	    this.aliases = {};
	    this.registers = { list: [] };
	    this.hashes = [];
	    this.compileStack = [];
	    this.inlineStack = [];
	    this.blockParams = [];

	    this.compileChildren(environment, options);

	    this.useDepths = this.useDepths || environment.useDepths || environment.useDecorators || this.options.compat;
	    this.useBlockParams = this.useBlockParams || environment.useBlockParams;

	    var opcodes = environment.opcodes,
	        opcode = undefined,
	        firstLoc = undefined,
	        i = undefined,
	        l = undefined;

	    for (i = 0, l = opcodes.length; i < l; i++) {
	      opcode = opcodes[i];

	      this.source.currentLocation = opcode.loc;
	      firstLoc = firstLoc || opcode.loc;
	      this[opcode.opcode].apply(this, opcode.args);
	    }

	    // Flush any trailing content that might be pending.
	    this.source.currentLocation = firstLoc;
	    this.pushSource('');

	    /* istanbul ignore next */
	    if (this.stackSlot || this.inlineStack.length || this.compileStack.length) {
	      throw new _exception2['default']('Compile completed with content left on stack');
	    }

	    if (!this.decorators.isEmpty()) {
	      this.useDecorators = true;

	      this.decorators.prepend('var decorators = container.decorators;\n');
	      this.decorators.push('return fn;');

	      if (asObject) {
	        this.decorators = Function.apply(this, ['fn', 'props', 'container', 'depth0', 'data', 'blockParams', 'depths', this.decorators.merge()]);
	      } else {
	        this.decorators.prepend('function(fn, props, container, depth0, data, blockParams, depths) {\n');
	        this.decorators.push('}\n');
	        this.decorators = this.decorators.merge();
	      }
	    } else {
	      this.decorators = undefined;
	    }

	    var fn = this.createFunctionContext(asObject);
	    if (!this.isChild) {
	      var ret = {
	        compiler: this.compilerInfo(),
	        main: fn
	      };

	      if (this.decorators) {
	        ret.main_d = this.decorators; // eslint-disable-line camelcase
	        ret.useDecorators = true;
	      }

	      var _context = this.context;
	      var programs = _context.programs;
	      var decorators = _context.decorators;

	      for (i = 0, l = programs.length; i < l; i++) {
	        if (programs[i]) {
	          ret[i] = programs[i];
	          if (decorators[i]) {
	            ret[i + '_d'] = decorators[i];
	            ret.useDecorators = true;
	          }
	        }
	      }

	      if (this.environment.usePartial) {
	        ret.usePartial = true;
	      }
	      if (this.options.data) {
	        ret.useData = true;
	      }
	      if (this.useDepths) {
	        ret.useDepths = true;
	      }
	      if (this.useBlockParams) {
	        ret.useBlockParams = true;
	      }
	      if (this.options.compat) {
	        ret.compat = true;
	      }

	      if (!asObject) {
	        ret.compiler = JSON.stringify(ret.compiler);

	        this.source.currentLocation = { start: { line: 1, column: 0 } };
	        ret = this.objectLiteral(ret);

	        if (options.srcName) {
	          ret = ret.toStringWithSourceMap({ file: options.destName });
	          ret.map = ret.map && ret.map.toString();
	        } else {
	          ret = ret.toString();
	        }
	      } else {
	        ret.compilerOptions = this.options;
	      }

	      return ret;
	    } else {
	      return fn;
	    }
	  },

	  preamble: function preamble() {
	    // track the last context pushed into place to allow skipping the
	    // getContext opcode when it would be a noop
	    this.lastContext = 0;
	    this.source = new _codeGen2['default'](this.options.srcName);
	    this.decorators = new _codeGen2['default'](this.options.srcName);
	  },

	  createFunctionContext: function createFunctionContext(asObject) {
	    var varDeclarations = '';

	    var locals = this.stackVars.concat(this.registers.list);
	    if (locals.length > 0) {
	      varDeclarations += ', ' + locals.join(', ');
	    }

	    // Generate minimizer alias mappings
	    //
	    // When using true SourceNodes, this will update all references to the given alias
	    // as the source nodes are reused in situ. For the non-source node compilation mode,
	    // aliases will not be used, but this case is already being run on the client and
	    // we aren't concern about minimizing the template size.
	    var aliasCount = 0;
	    for (var alias in this.aliases) {
	      // eslint-disable-line guard-for-in
	      var node = this.aliases[alias];

	      if (this.aliases.hasOwnProperty(alias) && node.children && node.referenceCount > 1) {
	        varDeclarations += ', alias' + ++aliasCount + '=' + alias;
	        node.children[0] = 'alias' + aliasCount;
	      }
	    }

	    var params = ['container', 'depth0', 'helpers', 'partials', 'data'];

	    if (this.useBlockParams || this.useDepths) {
	      params.push('blockParams');
	    }
	    if (this.useDepths) {
	      params.push('depths');
	    }

	    // Perform a second pass over the output to merge content when possible
	    var source = this.mergeSource(varDeclarations);

	    if (asObject) {
	      params.push(source);

	      return Function.apply(this, params);
	    } else {
	      return this.source.wrap(['function(', params.join(','), ') {\n  ', source, '}']);
	    }
	  },
	  mergeSource: function mergeSource(varDeclarations) {
	    var isSimple = this.environment.isSimple,
	        appendOnly = !this.forceBuffer,
	        appendFirst = undefined,
	        sourceSeen = undefined,
	        bufferStart = undefined,
	        bufferEnd = undefined;
	    this.source.each(function (line) {
	      if (line.appendToBuffer) {
	        if (bufferStart) {
	          line.prepend('  + ');
	        } else {
	          bufferStart = line;
	        }
	        bufferEnd = line;
	      } else {
	        if (bufferStart) {
	          if (!sourceSeen) {
	            appendFirst = true;
	          } else {
	            bufferStart.prepend('buffer += ');
	          }
	          bufferEnd.add(';');
	          bufferStart = bufferEnd = undefined;
	        }

	        sourceSeen = true;
	        if (!isSimple) {
	          appendOnly = false;
	        }
	      }
	    });

	    if (appendOnly) {
	      if (bufferStart) {
	        bufferStart.prepend('return ');
	        bufferEnd.add(';');
	      } else if (!sourceSeen) {
	        this.source.push('return "";');
	      }
	    } else {
	      varDeclarations += ', buffer = ' + (appendFirst ? '' : this.initializeBuffer());

	      if (bufferStart) {
	        bufferStart.prepend('return buffer + ');
	        bufferEnd.add(';');
	      } else {
	        this.source.push('return buffer;');
	      }
	    }

	    if (varDeclarations) {
	      this.source.prepend('var ' + varDeclarations.substring(2) + (appendFirst ? '' : ';\n'));
	    }

	    return this.source.merge();
	  },

	  // [blockValue]
	  //
	  // On stack, before: hash, inverse, program, value
	  // On stack, after: return value of blockHelperMissing
	  //
	  // The purpose of this opcode is to take a block of the form
	  // `{{#this.foo}}...{{/this.foo}}`, resolve the value of `foo`, and
	  // replace it on the stack with the result of properly
	  // invoking blockHelperMissing.
	  blockValue: function blockValue(name) {
	    var blockHelperMissing = this.aliasable('helpers.blockHelperMissing'),
	        params = [this.contextName(0)];
	    this.setupHelperArgs(name, 0, params);

	    var blockName = this.popStack();
	    params.splice(1, 0, blockName);

	    this.push(this.source.functionCall(blockHelperMissing, 'call', params));
	  },

	  // [ambiguousBlockValue]
	  //
	  // On stack, before: hash, inverse, program, value
	  // Compiler value, before: lastHelper=value of last found helper, if any
	  // On stack, after, if no lastHelper: same as [blockValue]
	  // On stack, after, if lastHelper: value
	  ambiguousBlockValue: function ambiguousBlockValue() {
	    // We're being a bit cheeky and reusing the options value from the prior exec
	    var blockHelperMissing = this.aliasable('helpers.blockHelperMissing'),
	        params = [this.contextName(0)];
	    this.setupHelperArgs('', 0, params, true);

	    this.flushInline();

	    var current = this.topStack();
	    params.splice(1, 0, current);

	    this.pushSource(['if (!', this.lastHelper, ') { ', current, ' = ', this.source.functionCall(blockHelperMissing, 'call', params), '}']);
	  },

	  // [appendContent]
	  //
	  // On stack, before: ...
	  // On stack, after: ...
	  //
	  // Appends the string value of `content` to the current buffer
	  appendContent: function appendContent(content) {
	    if (this.pendingContent) {
	      content = this.pendingContent + content;
	    } else {
	      this.pendingLocation = this.source.currentLocation;
	    }

	    this.pendingContent = content;
	  },

	  // [append]
	  //
	  // On stack, before: value, ...
	  // On stack, after: ...
	  //
	  // Coerces `value` to a String and appends it to the current buffer.
	  //
	  // If `value` is truthy, or 0, it is coerced into a string and appended
	  // Otherwise, the empty string is appended
	  append: function append() {
	    if (this.isInline()) {
	      this.replaceStack(function (current) {
	        return [' != null ? ', current, ' : ""'];
	      });

	      this.pushSource(this.appendToBuffer(this.popStack()));
	    } else {
	      var local = this.popStack();
	      this.pushSource(['if (', local, ' != null) { ', this.appendToBuffer(local, undefined, true), ' }']);
	      if (this.environment.isSimple) {
	        this.pushSource(['else { ', this.appendToBuffer("''", undefined, true), ' }']);
	      }
	    }
	  },

	  // [appendEscaped]
	  //
	  // On stack, before: value, ...
	  // On stack, after: ...
	  //
	  // Escape `value` and append it to the buffer
	  appendEscaped: function appendEscaped() {
	    this.pushSource(this.appendToBuffer([this.aliasable('container.escapeExpression'), '(', this.popStack(), ')']));
	  },

	  // [getContext]
	  //
	  // On stack, before: ...
	  // On stack, after: ...
	  // Compiler value, after: lastContext=depth
	  //
	  // Set the value of the `lastContext` compiler value to the depth
	  getContext: function getContext(depth) {
	    this.lastContext = depth;
	  },

	  // [pushContext]
	  //
	  // On stack, before: ...
	  // On stack, after: currentContext, ...
	  //
	  // Pushes the value of the current context onto the stack.
	  pushContext: function pushContext() {
	    this.pushStackLiteral(this.contextName(this.lastContext));
	  },

	  // [lookupOnContext]
	  //
	  // On stack, before: ...
	  // On stack, after: currentContext[name], ...
	  //
	  // Looks up the value of `name` on the current context and pushes
	  // it onto the stack.
	  lookupOnContext: function lookupOnContext(parts, falsy, strict, scoped) {
	    var i = 0;

	    if (!scoped && this.options.compat && !this.lastContext) {
	      // The depthed query is expected to handle the undefined logic for the root level that
	      // is implemented below, so we evaluate that directly in compat mode
	      this.push(this.depthedLookup(parts[i++]));
	    } else {
	      this.pushContext();
	    }

	    this.resolvePath('context', parts, i, falsy, strict);
	  },

	  // [lookupBlockParam]
	  //
	  // On stack, before: ...
	  // On stack, after: blockParam[name], ...
	  //
	  // Looks up the value of `parts` on the given block param and pushes
	  // it onto the stack.
	  lookupBlockParam: function lookupBlockParam(blockParamId, parts) {
	    this.useBlockParams = true;

	    this.push(['blockParams[', blockParamId[0], '][', blockParamId[1], ']']);
	    this.resolvePath('context', parts, 1);
	  },

	  // [lookupData]
	  //
	  // On stack, before: ...
	  // On stack, after: data, ...
	  //
	  // Push the data lookup operator
	  lookupData: function lookupData(depth, parts, strict) {
	    if (!depth) {
	      this.pushStackLiteral('data');
	    } else {
	      this.pushStackLiteral('container.data(data, ' + depth + ')');
	    }

	    this.resolvePath('data', parts, 0, true, strict);
	  },

	  resolvePath: function resolvePath(type, parts, i, falsy, strict) {
	    // istanbul ignore next

	    var _this = this;

	    if (this.options.strict || this.options.assumeObjects) {
	      this.push(strictLookup(this.options.strict && strict, this, parts, type));
	      return;
	    }

	    var len = parts.length;
	    for (; i < len; i++) {
	      /* eslint-disable no-loop-func */
	      this.replaceStack(function (current) {
	        var lookup = _this.nameLookup(current, parts[i], type);
	        // We want to ensure that zero and false are handled properly if the context (falsy flag)
	        // needs to have the special handling for these values.
	        if (!falsy) {
	          return [' != null ? ', lookup, ' : ', current];
	        } else {
	          // Otherwise we can use generic falsy handling
	          return [' && ', lookup];
	        }
	      });
	      /* eslint-enable no-loop-func */
	    }
	  },

	  // [resolvePossibleLambda]
	  //
	  // On stack, before: value, ...
	  // On stack, after: resolved value, ...
	  //
	  // If the `value` is a lambda, replace it on the stack by
	  // the return value of the lambda
	  resolvePossibleLambda: function resolvePossibleLambda() {
	    this.push([this.aliasable('container.lambda'), '(', this.popStack(), ', ', this.contextName(0), ')']);
	  },

	  // [pushStringParam]
	  //
	  // On stack, before: ...
	  // On stack, after: string, currentContext, ...
	  //
	  // This opcode is designed for use in string mode, which
	  // provides the string value of a parameter along with its
	  // depth rather than resolving it immediately.
	  pushStringParam: function pushStringParam(string, type) {
	    this.pushContext();
	    this.pushString(type);

	    // If it's a subexpression, the string result
	    // will be pushed after this opcode.
	    if (type !== 'SubExpression') {
	      if (typeof string === 'string') {
	        this.pushString(string);
	      } else {
	        this.pushStackLiteral(string);
	      }
	    }
	  },

	  emptyHash: function emptyHash(omitEmpty) {
	    if (this.trackIds) {
	      this.push('{}'); // hashIds
	    }
	    if (this.stringParams) {
	      this.push('{}'); // hashContexts
	      this.push('{}'); // hashTypes
	    }
	    this.pushStackLiteral(omitEmpty ? 'undefined' : '{}');
	  },
	  pushHash: function pushHash() {
	    if (this.hash) {
	      this.hashes.push(this.hash);
	    }
	    this.hash = { values: [], types: [], contexts: [], ids: [] };
	  },
	  popHash: function popHash() {
	    var hash = this.hash;
	    this.hash = this.hashes.pop();

	    if (this.trackIds) {
	      this.push(this.objectLiteral(hash.ids));
	    }
	    if (this.stringParams) {
	      this.push(this.objectLiteral(hash.contexts));
	      this.push(this.objectLiteral(hash.types));
	    }

	    this.push(this.objectLiteral(hash.values));
	  },

	  // [pushString]
	  //
	  // On stack, before: ...
	  // On stack, after: quotedString(string), ...
	  //
	  // Push a quoted version of `string` onto the stack
	  pushString: function pushString(string) {
	    this.pushStackLiteral(this.quotedString(string));
	  },

	  // [pushLiteral]
	  //
	  // On stack, before: ...
	  // On stack, after: value, ...
	  //
	  // Pushes a value onto the stack. This operation prevents
	  // the compiler from creating a temporary variable to hold
	  // it.
	  pushLiteral: function pushLiteral(value) {
	    this.pushStackLiteral(value);
	  },

	  // [pushProgram]
	  //
	  // On stack, before: ...
	  // On stack, after: program(guid), ...
	  //
	  // Push a program expression onto the stack. This takes
	  // a compile-time guid and converts it into a runtime-accessible
	  // expression.
	  pushProgram: function pushProgram(guid) {
	    if (guid != null) {
	      this.pushStackLiteral(this.programExpression(guid));
	    } else {
	      this.pushStackLiteral(null);
	    }
	  },

	  // [registerDecorator]
	  //
	  // On stack, before: hash, program, params..., ...
	  // On stack, after: ...
	  //
	  // Pops off the decorator's parameters, invokes the decorator,
	  // and inserts the decorator into the decorators list.
	  registerDecorator: function registerDecorator(paramSize, name) {
	    var foundDecorator = this.nameLookup('decorators', name, 'decorator'),
	        options = this.setupHelperArgs(name, paramSize);

	    this.decorators.push(['fn = ', this.decorators.functionCall(foundDecorator, '', ['fn', 'props', 'container', options]), ' || fn;']);
	  },

	  // [invokeHelper]
	  //
	  // On stack, before: hash, inverse, program, params..., ...
	  // On stack, after: result of helper invocation
	  //
	  // Pops off the helper's parameters, invokes the helper,
	  // and pushes the helper's return value onto the stack.
	  //
	  // If the helper is not found, `helperMissing` is called.
	  invokeHelper: function invokeHelper(paramSize, name, isSimple) {
	    var nonHelper = this.popStack(),
	        helper = this.setupHelper(paramSize, name),
	        simple = isSimple ? [helper.name, ' || '] : '';

	    var lookup = ['('].concat(simple, nonHelper);
	    if (!this.options.strict) {
	      lookup.push(' || ', this.aliasable('helpers.helperMissing'));
	    }
	    lookup.push(')');

	    this.push(this.source.functionCall(lookup, 'call', helper.callParams));
	  },

	  // [invokeKnownHelper]
	  //
	  // On stack, before: hash, inverse, program, params..., ...
	  // On stack, after: result of helper invocation
	  //
	  // This operation is used when the helper is known to exist,
	  // so a `helperMissing` fallback is not required.
	  invokeKnownHelper: function invokeKnownHelper(paramSize, name) {
	    var helper = this.setupHelper(paramSize, name);
	    this.push(this.source.functionCall(helper.name, 'call', helper.callParams));
	  },

	  // [invokeAmbiguous]
	  //
	  // On stack, before: hash, inverse, program, params..., ...
	  // On stack, after: result of disambiguation
	  //
	  // This operation is used when an expression like `{{foo}}`
	  // is provided, but we don't know at compile-time whether it
	  // is a helper or a path.
	  //
	  // This operation emits more code than the other options,
	  // and can be avoided by passing the `knownHelpers` and
	  // `knownHelpersOnly` flags at compile-time.
	  invokeAmbiguous: function invokeAmbiguous(name, helperCall) {
	    this.useRegister('helper');

	    var nonHelper = this.popStack();

	    this.emptyHash();
	    var helper = this.setupHelper(0, name, helperCall);

	    var helperName = this.lastHelper = this.nameLookup('helpers', name, 'helper');

	    var lookup = ['(', '(helper = ', helperName, ' || ', nonHelper, ')'];
	    if (!this.options.strict) {
	      lookup[0] = '(helper = ';
	      lookup.push(' != null ? helper : ', this.aliasable('helpers.helperMissing'));
	    }

	    this.push(['(', lookup, helper.paramsInit ? ['),(', helper.paramsInit] : [], '),', '(typeof helper === ', this.aliasable('"function"'), ' ? ', this.source.functionCall('helper', 'call', helper.callParams), ' : helper))']);
	  },

	  // [invokePartial]
	  //
	  // On stack, before: context, ...
	  // On stack after: result of partial invocation
	  //
	  // This operation pops off a context, invokes a partial with that context,
	  // and pushes the result of the invocation back.
	  invokePartial: function invokePartial(isDynamic, name, indent) {
	    var params = [],
	        options = this.setupParams(name, 1, params);

	    if (isDynamic) {
	      name = this.popStack();
	      delete options.name;
	    }

	    if (indent) {
	      options.indent = JSON.stringify(indent);
	    }
	    options.helpers = 'helpers';
	    options.partials = 'partials';
	    options.decorators = 'container.decorators';

	    if (!isDynamic) {
	      params.unshift(this.nameLookup('partials', name, 'partial'));
	    } else {
	      params.unshift(name);
	    }

	    if (this.options.compat) {
	      options.depths = 'depths';
	    }
	    options = this.objectLiteral(options);
	    params.push(options);

	    this.push(this.source.functionCall('container.invokePartial', '', params));
	  },

	  // [assignToHash]
	  //
	  // On stack, before: value, ..., hash, ...
	  // On stack, after: ..., hash, ...
	  //
	  // Pops a value off the stack and assigns it to the current hash
	  assignToHash: function assignToHash(key) {
	    var value = this.popStack(),
	        context = undefined,
	        type = undefined,
	        id = undefined;

	    if (this.trackIds) {
	      id = this.popStack();
	    }
	    if (this.stringParams) {
	      type = this.popStack();
	      context = this.popStack();
	    }

	    var hash = this.hash;
	    if (context) {
	      hash.contexts[key] = context;
	    }
	    if (type) {
	      hash.types[key] = type;
	    }
	    if (id) {
	      hash.ids[key] = id;
	    }
	    hash.values[key] = value;
	  },

	  pushId: function pushId(type, name, child) {
	    if (type === 'BlockParam') {
	      this.pushStackLiteral('blockParams[' + name[0] + '].path[' + name[1] + ']' + (child ? ' + ' + JSON.stringify('.' + child) : ''));
	    } else if (type === 'PathExpression') {
	      this.pushString(name);
	    } else if (type === 'SubExpression') {
	      this.pushStackLiteral('true');
	    } else {
	      this.pushStackLiteral('null');
	    }
	  },

	  // HELPERS

	  compiler: JavaScriptCompiler,

	  compileChildren: function compileChildren(environment, options) {
	    var children = environment.children,
	        child = undefined,
	        compiler = undefined;

	    for (var i = 0, l = children.length; i < l; i++) {
	      child = children[i];
	      compiler = new this.compiler(); // eslint-disable-line new-cap

	      var existing = this.matchExistingProgram(child);

	      if (existing == null) {
	        this.context.programs.push(''); // Placeholder to prevent name conflicts for nested children
	        var index = this.context.programs.length;
	        child.index = index;
	        child.name = 'program' + index;
	        this.context.programs[index] = compiler.compile(child, options, this.context, !this.precompile);
	        this.context.decorators[index] = compiler.decorators;
	        this.context.environments[index] = child;

	        this.useDepths = this.useDepths || compiler.useDepths;
	        this.useBlockParams = this.useBlockParams || compiler.useBlockParams;
	        child.useDepths = this.useDepths;
	        child.useBlockParams = this.useBlockParams;
	      } else {
	        child.index = existing.index;
	        child.name = 'program' + existing.index;

	        this.useDepths = this.useDepths || existing.useDepths;
	        this.useBlockParams = this.useBlockParams || existing.useBlockParams;
	      }
	    }
	  },
	  matchExistingProgram: function matchExistingProgram(child) {
	    for (var i = 0, len = this.context.environments.length; i < len; i++) {
	      var environment = this.context.environments[i];
	      if (environment && environment.equals(child)) {
	        return environment;
	      }
	    }
	  },

	  programExpression: function programExpression(guid) {
	    var child = this.environment.children[guid],
	        programParams = [child.index, 'data', child.blockParams];

	    if (this.useBlockParams || this.useDepths) {
	      programParams.push('blockParams');
	    }
	    if (this.useDepths) {
	      programParams.push('depths');
	    }

	    return 'container.program(' + programParams.join(', ') + ')';
	  },

	  useRegister: function useRegister(name) {
	    if (!this.registers[name]) {
	      this.registers[name] = true;
	      this.registers.list.push(name);
	    }
	  },

	  push: function push(expr) {
	    if (!(expr instanceof Literal)) {
	      expr = this.source.wrap(expr);
	    }

	    this.inlineStack.push(expr);
	    return expr;
	  },

	  pushStackLiteral: function pushStackLiteral(item) {
	    this.push(new Literal(item));
	  },

	  pushSource: function pushSource(source) {
	    if (this.pendingContent) {
	      this.source.push(this.appendToBuffer(this.source.quotedString(this.pendingContent), this.pendingLocation));
	      this.pendingContent = undefined;
	    }

	    if (source) {
	      this.source.push(source);
	    }
	  },

	  replaceStack: function replaceStack(callback) {
	    var prefix = ['('],
	        stack = undefined,
	        createdStack = undefined,
	        usedLiteral = undefined;

	    /* istanbul ignore next */
	    if (!this.isInline()) {
	      throw new _exception2['default']('replaceStack on non-inline');
	    }

	    // We want to merge the inline statement into the replacement statement via ','
	    var top = this.popStack(true);

	    if (top instanceof Literal) {
	      // Literals do not need to be inlined
	      stack = [top.value];
	      prefix = ['(', stack];
	      usedLiteral = true;
	    } else {
	      // Get or create the current stack name for use by the inline
	      createdStack = true;
	      var _name = this.incrStack();

	      prefix = ['((', this.push(_name), ' = ', top, ')'];
	      stack = this.topStack();
	    }

	    var item = callback.call(this, stack);

	    if (!usedLiteral) {
	      this.popStack();
	    }
	    if (createdStack) {
	      this.stackSlot--;
	    }
	    this.push(prefix.concat(item, ')'));
	  },

	  incrStack: function incrStack() {
	    this.stackSlot++;
	    if (this.stackSlot > this.stackVars.length) {
	      this.stackVars.push('stack' + this.stackSlot);
	    }
	    return this.topStackName();
	  },
	  topStackName: function topStackName() {
	    return 'stack' + this.stackSlot;
	  },
	  flushInline: function flushInline() {
	    var inlineStack = this.inlineStack;
	    this.inlineStack = [];
	    for (var i = 0, len = inlineStack.length; i < len; i++) {
	      var entry = inlineStack[i];
	      /* istanbul ignore if */
	      if (entry instanceof Literal) {
	        this.compileStack.push(entry);
	      } else {
	        var stack = this.incrStack();
	        this.pushSource([stack, ' = ', entry, ';']);
	        this.compileStack.push(stack);
	      }
	    }
	  },
	  isInline: function isInline() {
	    return this.inlineStack.length;
	  },

	  popStack: function popStack(wrapped) {
	    var inline = this.isInline(),
	        item = (inline ? this.inlineStack : this.compileStack).pop();

	    if (!wrapped && item instanceof Literal) {
	      return item.value;
	    } else {
	      if (!inline) {
	        /* istanbul ignore next */
	        if (!this.stackSlot) {
	          throw new _exception2['default']('Invalid stack pop');
	        }
	        this.stackSlot--;
	      }
	      return item;
	    }
	  },

	  topStack: function topStack() {
	    var stack = this.isInline() ? this.inlineStack : this.compileStack,
	        item = stack[stack.length - 1];

	    /* istanbul ignore if */
	    if (item instanceof Literal) {
	      return item.value;
	    } else {
	      return item;
	    }
	  },

	  contextName: function contextName(context) {
	    if (this.useDepths && context) {
	      return 'depths[' + context + ']';
	    } else {
	      return 'depth' + context;
	    }
	  },

	  quotedString: function quotedString(str) {
	    return this.source.quotedString(str);
	  },

	  objectLiteral: function objectLiteral(obj) {
	    return this.source.objectLiteral(obj);
	  },

	  aliasable: function aliasable(name) {
	    var ret = this.aliases[name];
	    if (ret) {
	      ret.referenceCount++;
	      return ret;
	    }

	    ret = this.aliases[name] = this.source.wrap(name);
	    ret.aliasable = true;
	    ret.referenceCount = 1;

	    return ret;
	  },

	  setupHelper: function setupHelper(paramSize, name, blockHelper) {
	    var params = [],
	        paramsInit = this.setupHelperArgs(name, paramSize, params, blockHelper);
	    var foundHelper = this.nameLookup('helpers', name, 'helper'),
	        callContext = this.aliasable(this.contextName(0) + ' != null ? ' + this.contextName(0) + ' : {}');

	    return {
	      params: params,
	      paramsInit: paramsInit,
	      name: foundHelper,
	      callParams: [callContext].concat(params)
	    };
	  },

	  setupParams: function setupParams(helper, paramSize, params) {
	    var options = {},
	        contexts = [],
	        types = [],
	        ids = [],
	        objectArgs = !params,
	        param = undefined;

	    if (objectArgs) {
	      params = [];
	    }

	    options.name = this.quotedString(helper);
	    options.hash = this.popStack();

	    if (this.trackIds) {
	      options.hashIds = this.popStack();
	    }
	    if (this.stringParams) {
	      options.hashTypes = this.popStack();
	      options.hashContexts = this.popStack();
	    }

	    var inverse = this.popStack(),
	        program = this.popStack();

	    // Avoid setting fn and inverse if neither are set. This allows
	    // helpers to do a check for `if (options.fn)`
	    if (program || inverse) {
	      options.fn = program || 'container.noop';
	      options.inverse = inverse || 'container.noop';
	    }

	    // The parameters go on to the stack in order (making sure that they are evaluated in order)
	    // so we need to pop them off the stack in reverse order
	    var i = paramSize;
	    while (i--) {
	      param = this.popStack();
	      params[i] = param;

	      if (this.trackIds) {
	        ids[i] = this.popStack();
	      }
	      if (this.stringParams) {
	        types[i] = this.popStack();
	        contexts[i] = this.popStack();
	      }
	    }

	    if (objectArgs) {
	      options.args = this.source.generateArray(params);
	    }

	    if (this.trackIds) {
	      options.ids = this.source.generateArray(ids);
	    }
	    if (this.stringParams) {
	      options.types = this.source.generateArray(types);
	      options.contexts = this.source.generateArray(contexts);
	    }

	    if (this.options.data) {
	      options.data = 'data';
	    }
	    if (this.useBlockParams) {
	      options.blockParams = 'blockParams';
	    }
	    return options;
	  },

	  setupHelperArgs: function setupHelperArgs(helper, paramSize, params, useRegister) {
	    var options = this.setupParams(helper, paramSize, params);
	    options = this.objectLiteral(options);
	    if (useRegister) {
	      this.useRegister('options');
	      params.push('options');
	      return ['options=', options];
	    } else if (params) {
	      params.push(options);
	      return '';
	    } else {
	      return options;
	    }
	  }
	};

	(function () {
	  var reservedWords = ('break else new var' + ' case finally return void' + ' catch for switch while' + ' continue function this with' + ' default if throw' + ' delete in try' + ' do instanceof typeof' + ' abstract enum int short' + ' boolean export interface static' + ' byte extends long super' + ' char final native synchronized' + ' class float package throws' + ' const goto private transient' + ' debugger implements protected volatile' + ' double import public let yield await' + ' null true false').split(' ');

	  var compilerWords = JavaScriptCompiler.RESERVED_WORDS = {};

	  for (var i = 0, l = reservedWords.length; i < l; i++) {
	    compilerWords[reservedWords[i]] = true;
	  }
	})();

	JavaScriptCompiler.isValidJavaScriptVariableName = function (name) {
	  return !JavaScriptCompiler.RESERVED_WORDS[name] && /^[a-zA-Z_$][0-9a-zA-Z_$]*$/.test(name);
	};

	function strictLookup(requireTerminal, compiler, parts, type) {
	  var stack = compiler.popStack(),
	      i = 0,
	      len = parts.length;
	  if (requireTerminal) {
	    len--;
	  }

	  for (; i < len; i++) {
	    stack = compiler.nameLookup(stack, parts[i], type);
	  }

	  if (requireTerminal) {
	    return [compiler.aliasable('container.strict'), '(', stack, ', ', compiler.quotedString(parts[i]), ')'];
	  } else {
	    return stack;
	  }
	}

	exports['default'] = JavaScriptCompiler;
	module.exports = exports['default'];

/***/ },
/* 32 */
/***/ function(module, exports, __webpack_require__) {

	/* global define */
	'use strict';

	exports.__esModule = true;

	var _utils = __webpack_require__(5);

	var SourceNode = undefined;

	try {
	  /* istanbul ignore next */
	  if (false) {
	    // We don't support this in AMD environments. For these environments, we asusme that
	    // they are running on the browser and thus have no need for the source-map library.
	    var SourceMap = require('source-map');
	    SourceNode = SourceMap.SourceNode;
	  }
	} catch (err) {}
	/* NOP */

	/* istanbul ignore if: tested but not covered in istanbul due to dist build  */
	if (!SourceNode) {
	  SourceNode = function (line, column, srcFile, chunks) {
	    this.src = '';
	    if (chunks) {
	      this.add(chunks);
	    }
	  };
	  /* istanbul ignore next */
	  SourceNode.prototype = {
	    add: function add(chunks) {
	      if (_utils.isArray(chunks)) {
	        chunks = chunks.join('');
	      }
	      this.src += chunks;
	    },
	    prepend: function prepend(chunks) {
	      if (_utils.isArray(chunks)) {
	        chunks = chunks.join('');
	      }
	      this.src = chunks + this.src;
	    },
	    toStringWithSourceMap: function toStringWithSourceMap() {
	      return { code: this.toString() };
	    },
	    toString: function toString() {
	      return this.src;
	    }
	  };
	}

	function castChunk(chunk, codeGen, loc) {
	  if (_utils.isArray(chunk)) {
	    var ret = [];

	    for (var i = 0, len = chunk.length; i < len; i++) {
	      ret.push(codeGen.wrap(chunk[i], loc));
	    }
	    return ret;
	  } else if (typeof chunk === 'boolean' || typeof chunk === 'number') {
	    // Handle primitives that the SourceNode will throw up on
	    return chunk + '';
	  }
	  return chunk;
	}

	function CodeGen(srcFile) {
	  this.srcFile = srcFile;
	  this.source = [];
	}

	CodeGen.prototype = {
	  isEmpty: function isEmpty() {
	    return !this.source.length;
	  },
	  prepend: function prepend(source, loc) {
	    this.source.unshift(this.wrap(source, loc));
	  },
	  push: function push(source, loc) {
	    this.source.push(this.wrap(source, loc));
	  },

	  merge: function merge() {
	    var source = this.empty();
	    this.each(function (line) {
	      source.add(['  ', line, '\n']);
	    });
	    return source;
	  },

	  each: function each(iter) {
	    for (var i = 0, len = this.source.length; i < len; i++) {
	      iter(this.source[i]);
	    }
	  },

	  empty: function empty() {
	    var loc = this.currentLocation || { start: {} };
	    return new SourceNode(loc.start.line, loc.start.column, this.srcFile);
	  },
	  wrap: function wrap(chunk) {
	    var loc = arguments.length <= 1 || arguments[1] === undefined ? this.currentLocation || { start: {} } : arguments[1];

	    if (chunk instanceof SourceNode) {
	      return chunk;
	    }

	    chunk = castChunk(chunk, this, loc);

	    return new SourceNode(loc.start.line, loc.start.column, this.srcFile, chunk);
	  },

	  functionCall: function functionCall(fn, type, params) {
	    params = this.generateList(params);
	    return this.wrap([fn, type ? '.' + type + '(' : '(', params, ')']);
	  },

	  quotedString: function quotedString(str) {
	    return '"' + (str + '').replace(/\\/g, '\\\\').replace(/"/g, '\\"').replace(/\n/g, '\\n').replace(/\r/g, '\\r').replace(/\u2028/g, '\\u2028') // Per Ecma-262 7.3 + 7.8.4
	    .replace(/\u2029/g, '\\u2029') + '"';
	  },

	  objectLiteral: function objectLiteral(obj) {
	    var pairs = [];

	    for (var key in obj) {
	      if (obj.hasOwnProperty(key)) {
	        var value = castChunk(obj[key], this);
	        if (value !== 'undefined') {
	          pairs.push([this.quotedString(key), ':', value]);
	        }
	      }
	    }

	    var ret = this.generateList(pairs);
	    ret.prepend('{');
	    ret.add('}');
	    return ret;
	  },

	  generateList: function generateList(entries) {
	    var ret = this.empty();

	    for (var i = 0, len = entries.length; i < len; i++) {
	      if (i) {
	        ret.add(',');
	      }

	      ret.add(castChunk(entries[i], this));
	    }

	    return ret;
	  },

	  generateArray: function generateArray(entries) {
	    var ret = this.generateList(entries);
	    ret.prepend('[');
	    ret.add(']');

	    return ret;
	  }
	};

	exports['default'] = CodeGen;
	module.exports = exports['default'];

/***/ }
/******/ ])
});
;
;/* This file is part of Mura CMS.

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
;//https://github.com/malko/l.js
;(function(root){
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

	//avoid multiple inclusion to override current loader but allow tag content evaluation
	if( ! root.Mura.ljs ){
		var checkLoaded = scriptTag.src.match(/checkLoaded/)?1:0
			//-- keep trace of header as we will make multiple access to it
			,header  = D[getElementsByTagName]("head")[0] || D.documentElement
			, urlParse = function(url){
				var parts={}; // u => url, i => id, f = fallback
				parts.u = url.replace(/#(=)?([^#]*)?/g,function(m,a,b){ parts[a?'f':'i'] = b; return '';});
				return parts;
			}
			,appendElmt = function(type,attrs,cb){
				var e = D.createElement(type), i;
				if( cb ){ //-- this is not intended to be used for link
					if(e[readyState]){
						e[onreadystatechange] = function(){
							if (e[readyState] === "loaded" || e[readyState] === "complete"){
								e[onreadystatechange] = null;
								cb();
							}
						};
					}else{
						e.onload = cb;
					}
				}
				for( i in attrs ){ attrs[i] && (e[i]=attrs[i]); }
				header.appendChild(e);
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
		root.Mura.ljs = loader;
		// eval inside tag code if any
	}
	scriptTag.src && script && appendElmt('script', {innerHTML: script});
})(this);
;/* This file is part of Mura CMS.

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
;(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['Mura'], factory);
    } else if (typeof module === 'object' && module.exports) {
        // Node. Does not work with strict CommonJS, but
        // only CommonJS-like environments that support module.exports,
        // like Node.
        factory(require('Mura'));
    } else {
        // Browser globals (root is window)
        factory(root.Mura);
    }
}(this, function (Mura) {
	function core(){
		this.init.apply(this,arguments);
		return this;
	}

	core.prototype={
		init:function(){
		},
		trigger:function(eventName){
			eventName=eventName.toLowerCase();

			if(typeof this.prototype.handlers[eventName] != 'undefined'){
				var handlers=this.prototype.handlers[eventName];
				for(var handler in handlers){
					handler.call(this);
				}
			}

			return this;
		},
	};

	core.extend=function(properties){
		var self=this;
		return Mura.extend(Mura.extendClass(self,properties),{extend:self.extend,handlers:[]});
	};

	Mura.Core=core;

}));
;/* This file is part of Mura CMS.

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

;(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['Mura'], factory);
    } else if (typeof module === 'object' && module.exports) {
        // Node. Does not work with strict CommonJS, but
        // only CommonJS-like environments that support module.exports,
        // like Node.
        factory(require('Mura'));
    } else {
        // Browser globals (root is window)
        factory(root.Mura);
    }
}(this, function (Mura) {
    /**
     * Creates a new Mura.Cache
     * @class {class} Mura.Cache
     */
	Mura.Cache=Mura.Core.extend(
    /** @lends Mura.Cache.prototype */
    {

		/**
		 * init - Initialiazes cache
		 *
		 * @return {void}
		 */
		init:function(){
			this.cache={};
		},

        /**
         * getKey - Returns Key value associated with key Name
         *
         * @param  {string} keyName Key Name
         * @return {*}         Key Value
         */
        getKey:function(keyName){
            return Mura.hashCode(keyName);
        },

        /**
         * get - Returns the value associated with key name
         *
         * @param  {string} keyName  description
         * @param  {*} keyValue Default Value
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
		 * @param  {string} keyName  Key Name
		 * @param  {*} keyValue Key Value
		 * @param  {string} key      Key
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
		 * @param  {string} keyName Key Name
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
         * @return {object}  Self
         */
        purgeAll:function(){
            this.cache={};
			return this;
		},

        /**
         * purge - Purges specific key name from cache
         *
         * @param  {string} keyName Key Name
         * @return {object}         Self
         */
        purge:function(keyName){
            var key=this.getKey(keyName)
            if( typeof this.cache[key] != 'undefined')
            delete this.cache[key];
			return this;
		}

	});

}));
;/* This file is part of Mura CMS.

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
;
(function(root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define([root, 'Mura'], factory);
    } else if (typeof module === 'object' && module.exports) {
        // Node. Does not work with strict CommonJS, but
        // only CommonJS-like environments that support module.exports,
        // like Node.
        factory(root, require('Mura'));
    } else {
        // Browser globals (root is window)
        factory(root, root.Mura);
    }
}(this, function(root, Mura) {
    /**
     * Creates a new Mura.DOMSelection
     * @class {class} Mura.DOMSelection
     */
    Mura.DOMSelection = Mura.Core.extend(
        /** @lends Mura.DOMSelection.prototype */
        {

            /**
             * init - initiliazes instance
             *
             * @param  {object} properties Object containing values to set into object
             * @return {void}
             */
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
            },


            /**
             * get - Deprecated: Returns element at index of selection, use item()
             *
             * @param  {number} index Index of selection
             * @return {*}
             */
            get: function(index) {
                return this.selection[index];
            },


            /**
             * select - Returns new Mura.DomSelection
             *
             * @param  {string} selector Selector
             * @return {object}
             */
            select: function(selector) {
                return mura(selector);
            },


            /**
             * each - Runs function against each item in selection
             *
             * @param  {function} fn Method
             * @return {Mura.DOMSelection} Self
             */
            each: function(fn) {
                this.selection.forEach(function(el, idx, array) {
                    fn.call(el, el, idx, array);
                });
                return this;
            },


            /**
             * filter - Creates a new Mura.DomSelection instance contains selection values that pass filter function by returning true
             *
             * @param  {function} fn Filter function
             * @return {object}    New Mura.DOMSelection
             */
            filter: function(fn) {
                return mura(this.selection.filter(function(el,
                    idx, array) {
                    return fn.call(el, el, idx,
                        array);
                }));
            },

            /**
             * map - Creates a new Mura.DomSelection instance contains selection values that are returned by Map function
             *
             * @param  {function} fn Map function
             * @return {object}    New Mura.DOMSelection
             */
            map: function(fn) {
                return mura(this.selection.map(function(el, idx,
                    array) {
                    return fn.call(el, el, idx,
                        array);
                }));
            },

            /**
             * reduce - Returns value from  reduce function
             *
             * @param  {function} fn Reduce function
             * @param  {any} initialValue Starting accumulator value
             * @return {accumulator}
             */
            reduce: function(fn, initialValue) {
                initialValue = initialValue || 0;
                return this.selection.reduce(
                    function(accumulator, item, idx, array) {
                        return fn.call(item, accumulator,
                            item, idx, array);
                    },
                    initialValue
                );
            },


            /**
             * isNumeric - Returns if value is numeric
             *
             * @param  {*} val Value
             * @return {type}     description
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
             * on - Add event handling method
             *
             * @param  {string} eventName Event name
             * @param  {string} selector  Selector (optional: for use with delegated events)
             * @param  {function} fn        description
             * @return {Mura.DOMSelection} Self
             */
            on: function(eventName, selector, fn) {
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
                                        mura(this).find(
                                            selector
                                        ).each(
                                            function() {
                                                fn
                                                    .call(
                                                        this
                                                    );
                                            });
                                    } else {
                                        fn.call(
                                            this
                                        );
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
                                    if (mura(event.target)
                                        .is(
                                            selector
                                        )) {
                                        return fn.call(
                                            event
                                            .target,
                                            event
                                        );
                                    }
                                } else {
                                    return fn.call(
                                        self,
                                        event);
                                }

                            },
                            true
                        );
                    }
                });

                return this;
            },

            /**
             * hover - Adds hovering events to selected dom elements
             *
             * @param  {function} handlerIn  In method
             * @param  {function} handlerOut Out method
             * @return {object}            Self
             */
            hover: function(handlerIn, handlerOut) {
                this.on('mouseover', handlerIn);
                this.on('mouseout', handlerOut);
                this.on('touchstart', handlerIn);
                this.on('touchend', handlerOut);
                return this;
            },


            /**
             * click - Adds onClick event handler to selection
             *
             * @param  {function} fn Handler function
             * @return {Mura.DOMSelection} Self
             */
            click: function(fn) {
                this.on('click', fn);
                return this;
            },

            /**
             * change - Adds onChange event handler to selection
             *
             * @param  {function} fn Handler function
             * @return {Mura.DOMSelection} Self
             */
            change: function(fn) {
                this.on('change', fn);
                return this;
            },

            /**
             * submit - Adds onSubmit event handler to selection
             *
             * @param  {function} fn Handler function
             * @return {Mura.DOMSelection} Self
             */
            submit: function(fn) {
                if (fn) {
                    this.on('submit', fn);
                } else {
                    this.each(function(el) {
                        if (typeof el.submit ==
                            'function') {
                            Mura.submitForm(el);
                        }
                    });
                }

                return this;
            },

            /**
             * ready - Adds onReady event handler to selection
             *
             * @param  {function} fn Handler function
             * @return {Mura.DOMSelection} Self
             */
            ready: function(fn) {
                this.on('ready', fn);
                return this;
            },

            /**
             * off - Removes event handler from selection
             *
             * @param  {string} eventName Event name
             * @param  {function} fn      Function to remove  (optional)
             * @return {Mura.DOMSelection} Self
             */
            off: function(eventName, fn) {
                this.each(function(el, idx, array) {
                    if (typeof eventName != 'undefined') {
                        if (typeof fn != 'undefined') {
                            el.removeEventListener(
                                eventName, fn);
                        } else {
                            el[eventName] = null;
                        }
                    } else {
                        if (typeof el.parentElement !=
                            'undefined' && el.parentElement &&
                            typeof el.parentElement.replaceChild !=
                            'undefined') {
                            var elClone = el.cloneNode(
                                true);
                            el.parentElement.replaceChild(
                                elClone, el);
                            array[idx] = elClone;
                        } else {
                            console.log(
                                "Mura: Can not remove all handlers from element without a parent node"
                            )
                        }
                    }

                });
                return this;
            },

            /**
             * unbind - Removes event handler from selection
             *
             * @param  {string} eventName Event name
             * @param  {function} fn      Function to remove  (optional)
             * @return {Mura.DOMSelection} Self
             */
            unbind: function(eventName, fn) {
                this.off(eventName, fn);
                return this;
            },

            /**
             * bind - Add event handling method
             *
             * @param  {string} eventName Event name
             * @param  {string} selector  Selector (optional: for use with delegated events)
             * @param  {function} fn        description
             * @return {Mura.DOMSelection}           Self
             */
            bind: function(eventName, fn) {
                this.on(eventName, fn);
                return this;
            },

            /**
             * trigger - Triggers event on selection
             *
             * @param  {string} eventName   Event name
             * @param  {object} eventDetail Event properties
             * @return {Mura.DOMSelection}             Self
             */
            trigger: function(eventName, eventDetail) {
                eventDetails = eventDetail || {};

                this.each(function(el) {
                    Mura.trigger(el, eventName,
                        eventDetail);
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
                return mura(this.selection[0].parentNode);
            },

            /**
             * children - Returns new Mura.DOMSelection or the first elements children
             *
             * @param  {string} selector Filter (optional)
             * @return {Mura.DOMSelection}
             */
            children: function(selector) {
                if (!this.selection.length) {
                    return this;
                }

                if (this.selection[0].hasChildNodes()) {
                    var children = mura(this.selection[0].childNodes);

                    if (typeof selector == 'string') {
                        var filterFn = function() {
                            return (this.nodeType === 1 ||
                                    this.nodeType === 11 ||
                                    this.nodeType === 9) &&
                                this.matchesSelector(
                                    selector);
                        };
                    } else {
                        var filterFn = function() {
                            return this.nodeType === 1 ||
                                this.nodeType === 11 ||
                                this.nodeType === 9;
                        };
                    }

                    return children.filter(filterFn);
                } else {
                    return mura([]);
                }

            },


            /**
             * find - Returns new Mura.DOMSelection matching items under the first selection
             *
             * @param  {string} selector Selector
             * @return {Mura.DOMSelection}
             */
            find: function(selector) {
                if (this.selection.length && this.selection[0]) {
                    var removeId = false;

                    if (this.selection[0].nodeType == '1' ||
                        this.selection[0].nodeType == '11') {
                        var result = this.selection[0].querySelectorAll(
                            selector);
                    } else if (this.selection[0].nodeType ==
                        '9') {
                        var result = document.querySelectorAll(
                            selector);
                    } else {
                        var result = [];
                    }
                    return mura(result);
                } else {
                    return mura([]);
                }
            },

            /**
             * first - Returns first item in selection
             *
             * @return {*}
             */
            first: function() {
                if (this.selection.length) {
                    return mura(this.selection[0]);
                } else {
                    return mura([]);
                }
            },

            /**
             * last - Returns last item in selection
             *
             * @return {*}
             */
            last: function() {
                if (this.selection.length) {
                    return mura(this.selection[this.selection.length -
                        1]);
                } else {
                    return mura([]);
                }
            },

            /**
             * selector - Returns css selector for first item in selection
             *
             * @return {string}
             */
            selector: function() {
                var pathes = [];
                var path, node = mura(this.selection[0]);

                while (node.length) {
                    var realNode = node.get(0),
                        name = realNode.localName;
                    if (!name) {
                        break;
                    }

                    if (!node.data('hastempid') && node.attr(
                            'id') && node.attr('id') !=
                        'mura-variation-el') {
                        name = '#' + node.attr('id');
                        path = name + (path ? ' > ' + path : '');
                        break;
                    } else {

                        name = name.toLowerCase();
                        var parent = node.parent();
                        var sameTagSiblings = parent.children(
                            name);

                        if (sameTagSiblings.length > 1) {
                            var allSiblings = parent.children();
                            var index = allSiblings.index(
                                realNode) + 1;

                            if (index > 0) {
                                name += ':nth-child(' + index +
                                    ')';
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
             * @param  {string} selector Selector to filter siblings (optional)
             * @return {Mura.DOMSelection}
             */
            siblings: function(selector) {
                if (!this.selection.length) {
                    return this;
                }
                var el = this.selection[0];

                if (el.hasChildNodes()) {
                    var silbings = mura(this.selection[0].childNodes);

                    if (typeof selector == 'string') {
                        var filterFn = function() {
                            return (this.nodeType === 1 ||
                                    this.nodeType === 11 ||
                                    this.nodeType === 9) &&
                                this.matchesSelector(
                                    selector);
                        };
                    } else {
                        var filterFn = function() {
                            return this.nodeType === 1 ||
                                this.nodeType === 11 ||
                                this.nodeType === 9;
                        };
                    }

                    return silbings.filter(filterFn);
                } else {
                    return mura([]);
                }
            },

            /**
             * item - Returns item at selected index
             *
             * @param  {number} idx Index to return
             * @return {*}
             */
            item: function(idx) {
                return this.selection[idx];
            },

            /**
             * index - Returns the index of element
             *
             * @param  {*} el Element to return index of
             * @return {*}
             */
            index: function(el) {
                return this.selection.indexOf(el);
            },

            /**
             * closest - Returns new Mura.DOMSelection of closest parent matching selector
             *
             * @param  {string} selector Selector
             * @return {Mura.DOMSelection}
             */
            closest: function(selector) {
                if (!this.selection.length) {
                    return null;
                }

                var el = this.selection[0];

                for (var parent = el; parent !== null && parent
                    .matchesSelector && !parent.matchesSelector(
                        selector); parent = el.parentElement) {
                    el = parent;
                };

                if (parent) {
                    return mura(parent)
                } else {
                    return mura([]);
                }

            },

            /**
             * append - Appends element to items in selection
             *
             * @param  {*} el Element to append
             * @return {Mura.DOMSelection} Self
             */
            append: function(el) {
                this.each(function() {
                    if (typeof el == 'string') {
                        this.insertAdjacentHTML(
                            'beforeend', el);
                    } else {
                        this.appendChild(el);
                    }
                });
                return this;
            },

            /**
             * appendDisplayObject - Appends display object to selected items
             *
             * @param  {object} data Display objectparams (including object='objectkey')
             * @return {Promise}
             */
            appendDisplayObject: function(data) {
                var self = this;

                delete data.method;
                
                return new Promise(function(resolve, reject) {
                    self.each(function() {
                        var el = document.createElement(
                            'div');
                        el.setAttribute('class',
                            'mura-object');

                        for (var a in data) {
                            el.setAttribute(
                                'data-' + a,
                                data[a]);
                        }

                        if (typeof data.async ==
                            'undefined') {
                            el.setAttribute(
                                'data-async',
                                true);
                        }

                        if (typeof data.render ==
                            'undefined') {
                            el.setAttribute(
                                'data-render',
                                'server');
                        }

                        el.setAttribute(
                            'data-instanceid',
                            Mura.createUUID()
                        );

                        mura(this).append(el);

                        Mura.processDisplayObject(
                            el,true,true).then(
                            resolve, reject
                        );

                    });
                });
            },

            /**
             * prependDisplayObject - Prepends display object to selected items
             *
             * @param  {object} data Display objectparams (including object='objectkey')
             * @return {Promise}
             */
            prependDisplayObject: function(data) {
                var self = this;

                delete data.method;

                return new Promise(function(resolve, reject) {
                    self.each(function() {
                        var el = document.createElement(
                            'div');
                        el.setAttribute('class',
                            'mura-object');

                        for (var a in data) {
                            el.setAttribute(
                                'data-' + a,
                                data[a]);
                        }

                        if (typeof data.async ==
                            'undefined') {
                            el.setAttribute(
                                'data-async',
                                true);
                        }

                        if (typeof data.render ==
                            'undefined') {
                            el.setAttribute(
                                'data-render',
                                'server');
                        }

                        el.setAttribute(
                            'data-instanceid',
                            Mura.createUUID()
                        );

                        mura(this).prepend(el);

                        Mura.processDisplayObject(
                            el,true,true).then(
                            resolve, reject
                        );

                    });
                });
            },

            /**
             * processDisplayObject - Handles processing of display object params to selection
             *
             * @param  {object} data Display object params
             * @return {Promise}
             */
            processDisplayObject: function(data) {
                var self = this;

                delete data.method;

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
             * prepend - Prepends element to items in selection
             *
             * @param  {*} el Element to append
             * @return {Mura.DOMSelection} Self
             */
            prepend: function(el) {
                this.each(function() {
                    if (typeof el == 'string') {
                        this.insertAdjacentHTML(
                            'afterbegin', el);
                    } else {
                        this.insertBefore(el, this.firstChild);
                    }
                });
                return this;
            },

            /**
             * before - Inserts element before items in selection
             *
             * @param  {*} el Element to append
             * @return {Mura.DOMSelection} Self
             */
            before: function(el) {
                this.each(function() {
                    if (typeof el == 'string') {
                        this.insertAdjacentHTML(
                            'beforebegin', el);
                    } else {
                        this.parent.insertBefore(el,
                            this);
                    }
                });
                return this;
            },

            /**
             * after - Inserts element after items in selection
             *
             * @param  {*} el Element to append
             * @return {Mura.DOMSelection} Self
             */
            after: function(el) {
                this.each(function() {
                    if (typeof el == 'string') {
                        this.insertAdjacentHTML(
                            'afterend', el);
                    } else {
                        this.parent.insertBefore(el,
                            this.parent.firstChild);
                    }
                });
                return this;
            },


            /**
             * hide - Hides elements in selection
             *
             * @return {object}  Self
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
             * @return {object}  Self
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
             * @return {object}  Self
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
             * @return {object}  Self
             */
            remove: function() {
                this.each(function(el) {
                    el.parentNode.removeChild(el);
                });
                return this;
            },

            /**
             * addClass - Adds class to elements in selection
             *
             * @param  {string} className Name of class
             * @return {Mura.DOMSelection} Self
             */
            addClass: function(className) {
                this.each(function(el) {
                    if (el.classList) {
                        el.classList.add(className);
                    } else {
                        el.className += ' ' + className;
                    }
                });
                return this;
            },

            /**
             * hasClass - Returns if the first element in selection has class
             *
             * @param  {string} className Class name
             * @return {Mura.DOMSelection} Self
             */
            hasClass: function(className) {
                return this.is("." + className);
            },

            /**
             * removeClass - Removes class from elements in selection
             *
             * @param  {string} className Class name
             * @return {Mura.DOMSelection} Self
             */
            removeClass: function(className) {
                this.each(function(el) {
                    if (el.classList) {
                        el.classList.remove(className);
                    } else if (el.className) {
                        el.className = el.className.replace(
                            new RegExp('(^|\\b)' +
                                className.split(' ')
                                .join('|') +
                                '(\\b|$)', 'gi'),
                            ' ');
                    }
                });
                return this;
            },

            /**
             * toggleClass - Toggles class on elements in selection
             *
             * @param  {string} className Class name
             * @return {Mura.DOMSelection} Self
             */
            toggleClass: function(className) {
                this.each(function(el) {
                    if (el.classList) {
                        el.classList.toggle(className);
                    } else {
                        var classes = el.className.split(
                            ' ');
                        var existingIndex = classes.indexOf(
                            className);

                        if (existingIndex >= 0)
                            classes.splice(
                                existingIndex, 1);
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
             * @return {object}  Self
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
             * @return {object}  Self
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
             * @param  {string} htmlString description
             * @return {object}            Self
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
             * @param  {string} ruleName Css rule name
             * @param  {string} value    Rule value
             * @return {object}          Self
             */
            css: function(ruleName, value) {
                if (!this.selection.length) {
                    return this;
                }

                if (typeof ruleName == 'undefined' && typeof value ==
                    'undefined') {
                    try {
                        return getComputedStyle(this.selection[
                            0]);
                    } catch (e) {
                        return {};
                    }
                } else if (typeof ruleName == 'object') {
                    this.each(function(el) {
                        try {
                            for (var p in ruleName) {
                                el.style[p] = ruleName[
                                    p];
                            }
                        } catch (e) {}
                    });
                } else if (typeof value != 'undefined') {
                    this.each(function(el) {
                        try {
                            el.style[ruleName] = value;
                        } catch (e) {}
                    });
                    return this;
                } else {
                    try {
                        return getComputedStyle(this.selection[
                            0])[ruleName];
                    } catch (e) {}
                }
            },

            /**
             * text - Gets or sets the text content of each element in the selection
             *
             * @param  {string} textString Text string
             * @return {object}            Self
             */
            text: function(textString) {
                if (typeof textString == 'undefined') {
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
             * @param  {string} selector description
             * @return {boolean}
             */
            is: function(selector) {
                if (!this.selection.length) {
                    return false;
                }
                return this.selection[0].matchesSelector &&
                    this.selection[0].matchesSelector(selector);
            },

            /**
             * hasAttr - Returns is the first element in the selection has an attribute
             *
             * @param  {string} attributeName description
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
             * @param  {sting} attributeName Data atttribute name
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
             * @return {object}  offsetParent
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
             * @param  {boolean} withMargin Whether to include margin
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

                        height += parseInt(style.marginTop) +
                            parseInt(style.marginBottom);
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
             * @param  {number} height  Height (option)
             * @return {object}        Self
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

                if (el === root) {
                    return innerHeight
                } else if (el === document) {
                    var body = document.body;
                    var html = document.documentElement;
                    return Math.max(body.scrollHeight, body.offsetHeight,
                        html.clientHeight, html.scrollHeight,
                        html.offsetHeight)
                }

                var styles = getComputedStyle(el);
                var margin = parseFloat(styles['marginTop']) +
                    parseFloat(styles['marginBottom']);

                return Math.ceil(el.offsetHeight + margin);
            },

            /**
             * width - Returns height of first element in selection or set width for elements in selection
             *
             * @param  {number} width Width (optional)
             * @return {object}       Self
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

                if (el === root) {
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
             * scrollTop - Returns the scrollTop of the current document
             *
             * @return {object}
             */
            scrollTop: function() {
                return document.body.scrollTop;
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
             * @param  {string} attributeName Attribute name
             * @return {object}               Self
             */
            removeAttr: function(attributeName) {
                if (!this.selection.length) {
                    return this;
                }

                this.each(function(el) {
                    if (el && typeof el.removeAttribute ==
                        'function') {
                        el.removeAttribute(
                            attributeName);
                    }

                });
                return this;

            },

            /**
             * changeElementType - Changes element type of elements in selection
             *
             * @param  {string} type Element type to change to
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
             * @param  {*} value Value
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
                    if (Object.prototype.hasOwnProperty.call(
                            this.selection[0], 'value') ||
                        typeof this.selection[0].value !=
                        'undefined') {
                        return this.selection[0].value;
                    } else {
                        return '';
                    }
                }
            },

            /**
             * attr - Returns attribute value of first element in selection or set attribute value for elements in selection
             *
             * @param  {string} attributeName Attribute name
             * @param  {*} value         Value (optional)
             * @return {Mura.DOMSelection} Self
             */
            attr: function(attributeName, value) {
                if (!this.selection.length) {
                    return this;
                }

                if (typeof value == 'undefined' && typeof attributeName ==
                    'undefined') {
                    return Mura.getAttributes(this.selection[0]);
                } else if (typeof attributeName == 'object') {
                    this.each(function(el) {
                        if (el.setAttribute) {
                            for (var p in attributeName) {
                                el.setAttribute(p,
                                    attributeName[p]
                                );
                            }
                        }
                    });
                    return this;
                } else if (typeof value != 'undefined') {
                    this.each(function(el) {
                        if (el.setAttribute) {
                            el.setAttribute(
                                attributeName,
                                value);
                        }
                    });
                    return this;

                } else {
                    if (this.selection[0] && this.selection[0].getAttribute) {
                        return this.selection[0].getAttribute(
                            attributeName);
                    } else {
                        return undefined;
                    }

                }
            },

            /**
             * data - Returns data attribute value of first element in selection or set data attribute value for elements in selection
             *
             * @param  {string} attributeName Attribute name
             * @param  {*} value         Value (optional)
             * @return {Mura.DOMSelection} Self
             */
            data: function(attributeName, value) {
                if (!this.selection.length) {
                    return this;
                }
                if (typeof value == 'undefined' && typeof attributeName ==
                    'undefined') {
                    return Mura.getData(this.selection[0]);
                } else if (typeof attributeName == 'object') {
                    this.each(function(el) {
                        for (var p in attributeName) {
                            el.setAttribute("data-" + p,
                                attributeName[p]);
                        }
                    });
                    return this;

                } else if (typeof value != 'undefined') {
                    this.each(function(el) {
                        el.setAttribute("data-" +
                            attributeName, value);
                    });
                    return this;
                } else if (this.selection[0] && this.selection[
                        0].getAttribute) {
                    return Mura.parseString(this.selection[0].getAttribute(
                        "data-" + attributeName));
                } else {
                    return undefined;
                }
            },

            /**
             * prop - Returns attribute value of first element in selection or set attribute value for elements in selection
             *
             * @param  {string} attributeName Attribute name
             * @param  {*} value         Value (optional)
             * @return {Mura.DOMSelection} Self
             */
            prop: function(attributeName, value) {
                if (!this.selection.length) {
                    return this;
                }
                if (typeof value == 'undefined' && typeof attributeName ==
                    'undefined') {
                    return Mura.getProps(this.selection[0]);
                } else if (typeof attributeName == 'object') {
                    this.each(function(el) {
                        for (var p in attributeName) {
                            el.setAttribute(p,
                                attributeName[p]);
                        }
                    });
                    return this;

                } else if (typeof value != 'undefined') {
                    this.each(function(el) {
                        el.setAttribute(attributeName,
                            value);
                    });
                    return this;
                } else {
                    return Mura.parseString(this.selection[0].getAttribute(
                        attributeName));
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
                        if ((el.style.opacity -= .1) <
                            0) {
                            el.style.display =
                                "none";
                        } else {
                            requestAnimationFrame(
                                fade);
                        }
                    })();
                });

                return this;
            },

            /**
             * fadeIn - Fade in elements in selection
             *
             * @param  {string} display Display value
             * @return {Mura.DOMSelection} Self
             */
            fadeIn: function(display) {
                this.each(function(el) {
                    el.style.opacity = 0;
                    el.style.display = display ||
                        "block";

                    (function fade() {
                        var val = parseFloat(el.style
                            .opacity);
                        if (!((val += .1) > 1)) {
                            el.style.opacity = val;
                            requestAnimationFrame(
                                fade);
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
            }
        });

}));
;/* This file is part of Mura CMS.

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
;
(function(root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['Mura'], factory);
    } else if (typeof module === 'object' && module.exports) {
        // Node. Does not work with strict CommonJS, but
        // only CommonJS-like environments that support module.exports,
        // like Node.
        factory(require('Mura'));
    } else {
        // Browser globals (root is window)
        factory(root.Mura);
    }
}(this, function(Mura) {
    /**
     * Creates a new Mura.Entity
     * @class {class} Mura.Entity
     */
    Mura.Entity = Mura.Core.extend(
        /** @lends Mura.Entity.prototype */
        {

            /**
             * init - initiliazes instance
             *
             * @param  {object} properties Object containing values to set into object
             * @return {void}
             */
            init: function(properties) {
                properties = properties || {};
                properties.entityname = properties.entityname ||
                    'content';
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

                if (typeof this.properties.isdeleted ==
                    'undefined') {
                    this.properties.isdeleted = false;
                }

                this.cachePut();
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
             * @param  {string} propertyName Property Name
             * @param  {*} defaultValue Default Value
             * @return {*}              Property Value
             */
            get: function(propertyName, defaultValue) {
                if (typeof this.properties.links != 'undefined' &&
                    typeof this.properties.links[propertyName] !=
                    'undefined') {
                    var self = this;

                    if (typeof this.properties[propertyName] ==
                        'object') {

                        return new Promise(function(resolve,
                            reject) {
                            if ('items' in self.properties[
                                    propertyName]) {
                                var returnObj = new Mura
                                    .EntityCollection(
                                        self.properties[
                                            propertyName
                                        ]);
                            } else {
                                if (Mura.entities[self.properties[
                                        propertyName
                                    ].entityname]) {
                                    var returnObj = new Mura
                                        .entities[self.properties[
                                            propertyName
                                        ].entityname](
                                            obj.properties[
                                                propertyName
                                            ]);
                                } else {
                                    var returnObj = new Mura
                                        .Entity(self.properties[
                                            propertyName
                                        ]);
                                }
                            }

                            if (typeof resolve ==
                                'function') {
                                resolve(returnObj);
                            }
                        });

                    } else {
                        if (typeof defaultValue == 'object') {
                            var params = defaultValue;
                        } else {
                            var params = {};
                        }
                        return new Promise(function(resolve,
                            reject) {

                            Mura.ajax({
                                type: 'get',
                                url: self.properties
                                    .links[
                                        propertyName
                                    ],
                                params: params,
                                success: function(
                                    resp) {

                                    if (
                                        'items' in
                                        resp
                                        .data
                                    ) {
                                        var
                                            returnObj =
                                            new Mura
                                            .EntityCollection(
                                                resp
                                                .data
                                            );
                                    } else {
                                        if (
                                            Mura
                                            .entities[
                                                obj
                                                .entityname
                                            ]
                                        ) {
                                            var
                                                returnObj =
                                                new Mura
                                                .entities[
                                                    obj
                                                    .entityname
                                                ]
                                                (
                                                    obj
                                                );
                                        } else {
                                            var
                                                returnObj =
                                                new Mura
                                                .Entity(
                                                    resp
                                                    .data
                                                );
                                        }
                                    }

                                    //Dont cache it there are custom params
                                    if (
                                        Mura
                                        .isEmptyObject(
                                            params
                                        )) {
                                        self
                                            .set(
                                                propertyName,
                                                resp
                                                .data
                                            );
                                    }

                                    if (
                                        typeof resolve ==
                                        'function'
                                    ) {
                                        resolve
                                            (
                                                returnObj
                                            );
                                    }
                                },
                                error: reject
                            });
                        });
                    }

                } else if (typeof this.properties[propertyName] !=
                    'undefined') {
                    return this.properties[propertyName];
                } else if (typeof defaultValue != 'undefined') {
                    this.properties[propertyName] =
                        defaultValue;
                    return this.properties[propertyName];

                } else {
                    return '';
                }
            },


            /**
             * set - Sets property value
             *
             * @param  {string} propertyName  Property Name
             * @param  {*} propertyValue Property Value
             * @return {Mura.Entity} Self
             */
            set: function(propertyName, propertyValue) {

                if (typeof propertyName == 'object') {
                    this.properties = Mura.deepExtend(this.properties,
                        propertyName);
                    this.set('isdirty', true);
                } else if (typeof this.properties[propertyName] ==
                    'undefined' || this.properties[propertyName] !=
                    propertyValue) {
                    this.properties[propertyName] =
                        propertyValue;
                    this.set('isdirty', true);
                }

                return this;

            },


            /**
             * has - Returns is the entity has a certain property within it
             *
             * @param  {string} propertyName Property Name
             * @return {type}
             */
            has: function(propertyName) {
                return typeof this.properties[propertyName] !=
                    'undefined' || (typeof this.properties.links !=
                        'undefined' && typeof this.properties.links[
                            propertyName] != 'undefined');
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
             * @param  {type} params Property values that you would like your new entity to have
             * @return {Promise}
             */
            'new': function(params) {
                var self = this;

                return new Promise(function(resolve, reject) {
                    params = Mura.extend({
                            entityname: self.get(
                                'entityname'),
                            method: 'findNew',
                            siteid: self.get(
                                'siteid'),
                            '_cacheid': Math.random()
                        },
                        params
                    );

                    Mura.get(Mura.apiEndpoint, params).then(
                        function(resp) {
                            self.set(resp.data);
                            if (typeof resolve ==
                                'function') {
                                resolve(self);
                            }
                        });
                });
            },


            /**
             * loadBy - Loads entity by property and value
             *
             * @param  {string} propertyName  The primary load property to filter against
             * @param  {string|number} propertyValue The value to match the propert against
             * @param  {object} params        Addition parameters
             * @return {Promise}
             */
            loadBy: function(propertyName, propertyValue, params) {

                propertyName = propertyName || 'id';
                propertyValue = propertyValue || this.get(
                    propertyName) || 'null';

                var self = this;

                if (propertyName == 'id') {
                    var cachedValue = Mura.datacache.get(
                        propertyValue);

                    if (cachedValue) {
                        this.set(cachedValue);
                        return new Promise(function(resolve,
                            reject) {
                            resolve(self);
                        });
                    }
                }

                return new Promise(function(resolve, reject) {
                    params = Mura.extend({
                            entityname: self.get(
                                'entityname').toLowerCase(),
                            method: 'findQuery',
                            siteid: self.get(
                                'siteid'),
                            '_cacheid': Math.random(),
                        },
                        params
                    );

                    if (params.entityname == 'content' ||
                        params.entityname ==
                        'contentnav') {
                        params.includeHomePage = 1;
                        params.showNavOnly = 0;
                        params.showExcludeSearch = 1;
                    }

                    params[propertyName] =
                        propertyValue;


                    Mura.findQuery(params).then(
                        function(collection) {

                            if (collection.get(
                                    'items').length) {
                                self.set(collection
                                    .get(
                                        'items'
                                    )[0].getAll()
                                );
                            }
                            if (typeof resolve ==
                                'function') {
                                resolve(self);
                            }
                        });
                });
            },


            /**
             * validate - Validates instance
             *
             * @param  {string} fields List of properties to validate, defaults to all
             * @return {Promise}
             */
            validate: function(fields) {
                fields = fields || '';

                var self = this;
                var data = Mura.deepExtend({}, self.getAll());

                data.fields = fields;

                return new Promise(function(resolve, reject) {

                    Mura.ajax({
                        type: 'post',
                        url: Mura.apiEndpoint +
                            '?method=validate',
                        data: {
                            data: Mura.escape(
                                data),
                            validations: '{}',
                            version: 4
                        },
                        success: function(resp) {
                            if (resp.data !=
                                'undefined'
                            ) {
                                self.set(
                                    'errors',
                                    resp
                                    .data
                                )
                            } else {
                                self.set(
                                    'errors',
                                    resp
                                    .error
                                );
                            }

                            if (typeof resolve ==
                                'function') {
                                resolve(
                                    self
                                );
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
                return (typeof errors == 'string' && errors !=
                    '') || (typeof errors == 'object' && !
                    Mura.isEmptyObject(errors));
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
            save: function() {
                var self = this;

                if (!this.get('isdirty')) {
                    return new Promise(function(resolve, reject) {
                        if (typeof resolve ==
                            'function') {
                            resolve(self);
                        }
                    });
                }

                if (!this.get('id')) {
                    return new Promise(function(resolve, reject) {
                        var temp = Mura.deepExtend({},
                            self.getAll());

                        Mura.ajax({
                            type: 'get',
                            url: Mura.apiEndpoint +
                                self.get(
                                    'entityname'
                                ) + '/new',
                            success: function(
                                resp) {
                                self.set(
                                    resp
                                    .data
                                );
                                self.set(
                                    temp
                                );
                                self.set(
                                    'id',
                                    resp
                                    .data
                                    .id
                                );
                                self.set(
                                    'isdirty',
                                    true
                                );
                                self.cachePut();
                                self.save()
                                    .then(
                                        resolve,
                                        reject
                                    );
                            }
                        });
                    });

                } else {
                    return new Promise(function(resolve, reject) {

                        var context = self.get('id');

                        Mura.ajax({
                            type: 'post',
                            url: Mura.apiEndpoint +
                                '?method=generateCSRFTokens',
                            data: {
                                siteid: self.get(
                                    'siteid'
                                ),
                                context: context
                            },
                            success: function(
                                resp) {
                                Mura.ajax({
                                    type: 'post',
                                    url: Mura
                                        .apiEndpoint +
                                        '?method=save',
                                    data: Mura
                                        .extend(
                                            self
                                            .getAll(), {
                                                'csrf_token': resp
                                                    .data
                                                    .csrf_token,
                                                'csrf_token_expires': resp
                                                    .data
                                                    .csrf_token_expires
                                            }
                                        ),
                                    success: function(
                                        resp
                                    ) {
                                        if (
                                            resp
                                            .data !=
                                            'undefined'
                                        ) {
                                            self
                                                .set(
                                                    resp
                                                    .data
                                                )
                                            self
                                                .set(
                                                    'isdirty',
                                                    false
                                                );
                                            if (
                                                self
                                                .get(
                                                    'saveerrors'
                                                ) ||
                                                Mura
                                                .isEmptyObject(
                                                    self
                                                    .getErrors()
                                                )
                                            ) {
                                                if (
                                                    typeof resolve ==
                                                    'function'
                                                ) {
                                                    resolve
                                                        (
                                                            self
                                                        );
                                                }
                                            } else {
                                                if (
                                                    typeof reject ==
                                                    'function'
                                                ) {
                                                    reject
                                                        (
                                                            self
                                                        );
                                                }
                                            }

                                        } else {
                                            self
                                                .set(
                                                    'errors',
                                                    resp
                                                    .error
                                                );
                                            if (
                                                typeof reject ==
                                                'function'
                                            ) {
                                                reject
                                                    (
                                                        self
                                                    );
                                            }
                                        }
                                    }
                                });
                            },
                            error: function(
                                resp) {
                                this.success(
                                    resp
                                );
                            }
                        });

                    });

                }

            },


            /**
             * delete - Deletes entity
             *
             * @return {Promise}
             */
            'delete': function() {

                var self = this;

                return new Promise(function(resolve, reject) {
                    Mura.ajax({
                        type: 'post',
                        url: Mura.apiEndpoint +
                            '?method=generateCSRFTokens',
                        data: {
                            siteid: self.get(
                                'siteid'),
                            context: self.get(
                                'id')
                        },
                        success: function(resp) {
                            Mura.ajax({
                                type: 'post',
                                url: Mura
                                    .apiEndpoint +
                                    '?method=delete',
                                data: {
                                    siteid: self
                                        .get(
                                            'siteid'
                                        ),
                                    id: self
                                        .get(
                                            'id'
                                        ),
                                    entityname: self
                                        .get(
                                            'entityname'
                                        ),
                                    'csrf_token': resp
                                        .data
                                        .csrf_token,
                                    'csrf_token_expires': resp
                                        .data
                                        .csrf_token_expires
                                },
                                success: function() {
                                    self
                                        .set(
                                            'isdeleted',
                                            true
                                        );
                                    self
                                        .cachePurge();
                                    if (
                                        typeof resolve ==
                                        'function'
                                    ) {
                                        resolve
                                            (
                                                self
                                            );
                                    }
                                }
                            });
                        }
                    });
                });

            },


            /**
             * getFeed - Returns a Mura.Feed instance of this current entitie's type and siteid
             *
             * @return {object}
             */
            getFeed: function() {
                var siteid = get('siteid') || Mura.siteid;
                return new Mura.Feed(this.get('entityName'));
            },


            /**
             * cachePurge - Purges this entity from client cache
             *
             * @return {object}  Self
             */
            cachePurge: function() {
                Mura.datacache.purge(this.get('id'));
                return this;
            },


            /**
             * cachePut - Places this entity into client cache
             *
             * @return {object}  Self
             */
            cachePut: function() {
                if (!this.get('isnew')) {
                    Mura.datacache.set(this.get('id'), this);
                }
                return this;
            }

        });
}));
;/* This file is part of Mura CMS.

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
;(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['Mura'], factory);
    } else if (typeof module === 'object' && module.exports) {
        // Node. Does not work with strict CommonJS, but
        // only CommonJS-like environments that support module.exports,
        // like Node.
        factory(require('Mura'));
    } else {
        // Browser globals (root is window)
        factory(root.Mura);
    }
}(this, function (Mura) {
    /**
     * Creates a new Mura.EntityCollection
     * @class {class} Mura.EntityCollection
     */
	Mura.EntityCollection=Mura.Entity.extend(
    /** @lends Mura.EntityCollection.prototype */
    {
        /**
		 * init - initiliazes instance
		 *
		 * @param  {object} properties Object containing values to set into object
		 * @return {object} Self
		 */
		init:function(properties){
			properties=properties || {};
			this.set(properties);

			var self=this;

			if(Array.isArray(self.get('items'))){
				self.set('items',self.get('items').map(function(obj){
					if(Mura.entities[obj.entityname]){
						return new Mura.entities[obj.entityname](obj);
					} else {
						return new Mura.Entity(obj);
					}
				}));
			}

			return this;
		},

        /**
		 * length - Returns length entity collection
		 *
		 * @return {number}     integer
		 */
		length:function(){
			return this.properties.items.length;
		},

		/**
		 * item - Return entity in collection at index
		 *
		 * @param  {nuymber} idx Index
		 * @return {object}     Mura.Entity
		 */
		item:function(idx){
			return this.properties.items[idx];
		},

		/**
		 * index - Returns index of item in collection
		 *
		 * @param  {object} item Entity instance
		 * @return {number}      Index of entity
		 */
		index:function(item){
			return this.properties.items.indexOf(item);
		},

		/**
		 * getAll - Returns object with of all entities and properties
		 *
		 * @return {object}
		 */
		getAll:function(){
			var self=this;
			return Mura.extend(
				{},
				self.properties,
				{
					items:this.properties.items.map(function(obj){
						return obj.getAll();
					})
				}
			);

		},

		/**
		 * each - Passes each entity in collection through function
		 *
		 * @param  {function} fn Function
		 * @return {object}  Self
		 */
		each:function(fn){
			this.properties.items.forEach( function(item,idx){
				fn.call(item,item,idx);
			});
			return this;
		},

        /**
		 * each - Passes each entity in collection through function
		 *
		 * @param  {function} fn Function
		 * @return {object}  Self
		 */
		forEach:function(fn){
			return this.each(fn);
		},

		/**
		 * sort - Sorts collection
		 *
		 * @param  {function} fn Sorting function
		 * @return {object}   Self
		 */
		sort:function(fn){
			this.properties.items.sort(fn);
            return this;
		},

		/**
		 * filter - Returns new Mura.EntityCollection of entities in collection that pass filter
		 *
		 * @param  {function} fn Filter function
		 * @return {Mura.EntityCollection}
		 */
		filter:function(fn){
            var newProps={};

            for(var p in this.properties){
                if(this.properties.hasOwnProperty(p) && p != 'items' && p != 'links'){
                    newProps[p]=this.properties[p];
                }
            }

			var collection=new Mura.EntityCollection(newProps);
			return collection.set('items',this.properties.items.filter( function(item,idx){
				return fn.call(item,item,idx);
			}));
		},

        /**
		 * map - Returns new Array returned from map function
		 *
		 * @param  {function} fn Filter function
		 * @return {Array}
		 */
		map:function(fn){
			return this.properties.items.map( function(item,idx){
				return fn.call(item,item,idx);
			});
		},

        /**
		 * reduce - Returns value from  reduce function
		 *
		 * @param  {function} fn Reduce function
         * @param  {any} initialValue Starting accumulator value
		 * @return {accumulator}
		 */
		reduce:function(fn,initialValue){
            initialValue=initialValue||0;
			return this.properties.items.reduce(
                function(accumulator,item,idx,array){
    				return fn.call(item,accumulator,item,idx,array);
    			},
                initialValue
            );
		}
	});
}));
;/* This file is part of Mura CMS.

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
;
(function(root, factory) {
	if (typeof define === 'function' && define.amd) {
		// AMD. Register as an anonymous module.
		define(['Mura'], factory);
	} else if (typeof module === 'object' && module.exports) {
		// Node. Does not work with strict CommonJS, but
		// only CommonJS-like environments that support module.exports,
		// like Node.
		factory(require('Mura'));
	} else {
		// Browser globals (root is window)
		factory(root.Mura);
	}
}(this, function(Mura) {
	/**
	 * Creates a new Mura.Feed
	 * @class {class} Mura.Feed
	 */
	Mura.Feed = Mura.Core.extend(
		/** @lends Mura.Feed.prototype */
		{

			/**
			 * init - Initialiazes feed
			 *
			 * @param  {string} siteid     Siteid
			 * @param  {string} entityname Entity name
			 * @return {Mura.Feed}            Self
			 */
			init: function(siteid, entityname) {
				this.queryString = entityname + '/?_cacheid=' + Math.random();
				this.propIndex = 0;
				return this;
			},

			/**
			 * fields - List fields to retrieve from API
			 *
			 * @param  {string} fields List of fields
			 * @return {Mura.Feed}        Self
			 */
			fields: function(fields) {
				this.queryString += '&fields=' + encodeURIComponent(fields);
				return this;
			},

			/**
			 * contentPoolID - Sets items per page
			 *
			 * @param  {number} contentPoolID Items per page
			 * @return {Mura.Feed}              Self
			 */
			contentPoolID: function(contentPoolID) {
				this.queryString += '&contentpoolid=' + encodeURIComponent(
					contentPoolID);
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
				this.queryString += '&or[' + this.propIndex + ']&';
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
				if (typeof criteria == 'undefined' || criteria == '' || criteria ==
					null) {
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
				if (typeof criteria == 'undefined' || criteria == '' || criteria ==
					null) {
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
				if (typeof criteria == 'undefined' || criteria == '' || criteria ==
					null) {
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
				if (typeof criteria == 'undefined' || criteria == '' || criteria ==
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
				if (typeof criteria == 'undefined' || criteria == '' || criteria ==
					null) {
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
				if (typeof criteria == 'undefined' || criteria == '' || criteria ==
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
				this.queryString += '&openGrouping[' + this.propIndex + ']';
				this.propIndex++;
				return this;
			},

			/**
			 * openGrouping - Starts new logical condition grouping
			 *
			 * @return {Mura.Feed}          Self
			 */
			andOpenGrouping: function(criteria) {
				this.queryString += '&andOpenGrouping[' + this.propIndex + ']';
				this.propIndex++;
				return this;
			},

			/**
			 * openGrouping - Closes logical condition grouping
			 *
			 * @return {Mura.Feed}          Self
			 */
			closeGrouping: function(criteria) {
				this.queryString += '&closeGrouping[' + this.propIndex + ']';
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
					this.queryString += '&sort' + encodeURIComponent('[' + this.propIndex + ']') + '=' +
						encodeURIComponent('-' + property);
				} else {
					this.queryString += '&sort' +encodeURIComponent('[' + this.propIndex + ']') + '=' +
						encodeURIComponent(property);
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
			 * showNavOnly - Sets to only return content set to be in nav
			 *
			 * @param  {boolean} showNavOnly Whether to return items that have been excluded from nav
			 * @return {Mura.Feed}              Self
			 */
			showNavOnly: function(showNavOnly) {
				this.queryString += '&showNavOnly=' + encodeURIComponent(showNavOnly);
				return this;
			},

			/**
			 * showExcludeSearch - Sets to include the homepage
			 *
			 * @param  {boolean} showExcludeSearch Whether to return items that have been excluded from search
			 * @return {Mura.Feed}              Self
			 */
			showExcludeSearch: function(showExcludeSearch) {
				this.queryString += '&showExcludeSearch=' + encodeURIComponent(
					showExcludeSearch);
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
			 * includeHomepage - Sets to include the home page
			 *
			 * @param  {boolean} showExcludeSearch Whether to return the homepage
			 * @return {Mura.Feed}              Self
			 */
			includeHomepage: function(includeHomepage) {
				this.queryString += '&includehomepage=' + encodeURIComponent(
					includeHomepage);
				return this;
			},

			/**
			 * innerJoin - Sets entity to INNER JOIN
			 *
			 * @param  {string} relatedEntity Related entity
			 * @return {Mura.Feed}              Self
			 */
			innerJoin: function(relatedEntity) {
				this.queryString += '&innerJoin' + encodeURIComponent('[' + this.propIndex + ']') + '=' +
					encodeURIComponent(relatedEntity);
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
				this.queryString += '&leftJoin' + encodeURIComponent('[' + this.propIndex + ']') + '=' +
					encodeURIComponent(relatedEntity);
				this.propIndex++;
				return this;
			},

			/**
			 * Query - Return Mura.EntityCollection fetched from JSON API
			 * @return {Promise}
			 */
			getQuery: function() {
				var self = this;

				return new Promise(function(resolve, reject) {
					if (Mura.apiEndpoint.charAt(Mura.apiEndpoint.length - 1) == "/") {
						var apiEndpoint = Mura.apiEndpoint;
					} else {
						var apiEndpoint = Mura.apiEndpoint + '/';
					}
					Mura.ajax({
						type: 'get',
						url: apiEndpoint + self.queryString,
						success: function(resp) {
							if (resp.data != 'undefined'  ) {
								var returnObj = new Mura.EntityCollection(resp.data);

								if (typeof resolve == 'function') {
									resolve(returnObj);
								}
							} else if (typeof reject == 'function') {
									reject(returnObj);
							}
						},
						error: function(resp) {
								this.success(resp );
						}
					});
				});
			}
		});

}));
;/* This file is part of Mura CMS.

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
;(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['Mura'], factory);
    } else if (typeof module === 'object' && module.exports) {
        // Node. Does not work with strict CommonJS, but
        // only CommonJS-like environments that support module.exports,
        // like Node.
        factory(require('Mura'));
    } else {
        // Browser globals (root is window)
        factory(root.Mura);
    }
}(this, function (Mura) {
	Mura.templates=Mura.templates || {};
	Mura.templates['meta']=function(context){

		if(context.label){
			return '<div class="mura-object-meta"><h3>' + Mura.escapeHTML(context.label) + '</h3></div>';
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
		context.source=context.source || '<p>This object has not been configured.</p>';
	 	return context.source;
	}
	Mura.templates['embed']=function(context){
		context=context || {};
		context.source=context.source || '<p>This object has not been configured.</p>';
	 	return context.source;
	}
}));
;/* This file is part of Mura CMS.

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
;(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['Mura'], factory);
    } else if (typeof module === 'object' && module.exports) {
        // Node. Does not work with strict CommonJS, but
        // only CommonJS-like environments that support module.exports,
        // like Node.
        factory(require('Mura'));
    } else {
        // Browser globals (root is window)
        factory(root.Mura);
    }
}(this, function (Mura) {
    /**
     * Creates a new Mura.Entity
     * @class {class} Mura.UI
     */
	Mura.UI=Mura.Core.extend(
    /** @lends Mura.Feed.prototype */
    {
		rb:{},
		context:{},
		onAfterRender:function(){},
		onBeforeRender:function(){},
		trigger:function(eventName){
			var $eventName=eventName.toLowerCase();
			if(typeof this.context.targetEl != 'undefined'){
				var obj=mura(this.context.targetEl).closest('.mura-object');
				if(obj.length && typeof obj.node != 'undefined'){
					if(typeof this.handlers[$eventName] != 'undefined'){
						var $handlers=this.handlers[$eventName];
						for(var i=0;i < $handlers.length;i++){
							$handlers[i].call(this);
						}
					}

					if(typeof this[eventName] == 'function'){
						this[eventName].call(this);
					}
					var fnName='on' + eventName.substring(0,1).toUpperCase() + eventName.substring(1,eventName.length);

					if(typeof this[fnName] == 'function'){
						this[fnName].call(this);
					}
				}
			}

			return this;
		},

		render:function(){
			mura(this.context.targetEl).html(Mura.templates[context.object](this.context));
			this.trigger('afterRender');
			return this;
		},

		init:function(args){
			this.context=args;
			this.registerHelpers();
			this.trigger('beforeRender');
			this.render();
			return this;
		},

		registerHelpers:function(){

		}
	});

}));
;/* This file is part of Mura CMS.

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
	;(function (root, factory) {
	    if (typeof define === 'function' && define.amd) {
	        // AMD. Register as an anonymous module.
	        define(['Mura'], factory);
	    } else if (typeof module === 'object' && module.exports) {
	        // Node. Does not work with strict CommonJS, but
	        // only CommonJS-like environments that support module.exports,
	        // like Node.
	        factory(require('Mura'));
	    } else {
	        // Browser globals (root is window)
	        factory(root.Mura);
	    }
	}(this, function (Mura) {
		Mura.DisplayObject.Form=Mura.UI.extend({
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
				btnsubmitclass:"form-submit",
				btnsubmitlabel:"Submit",
				btnnextlabel:"Next",
				btnbacklabel:"Back",
				btncancellabel:"Cancel"
			},
			render:function(){

				if(this.context.mode == undefined){
					this.context.mode = 'form';
				}

				var ident = "mura-form-" + this.context.objectid;

				this.context.formEl = "#" + ident;

				this.context.html = "<div id='"+ident+"'></div>";

				mura(this.context.targetEl).html( this.context.html );

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
					var fields = self.formJSON.form.pages[page];
					var result=[];

					for(var f=0;f < fields.length;f++){
						//console.log("add: " + self.formJSON.form.fields[fields[f]].name);
						result.push(self.formJSON.form.fields[fields[f]].name);
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
					var context = {};
					context.objectid = field.formid;
					context.paging = 'single';
					context.mode = 'nested';
					context.master = this;

					var nestedForm = new Mura.FormUI( context );
					var holder = mura('<div id="nested-'+field.formid+'"></div>');

					mura(".field-container-" + self.context.objectid,self.context.formEl).append(holder);

					context.formEl = holder;
					nestedForm.getForm();

					var html = Mura.templates[template](field);
					mura(".field-container-" + self.context.objectid,self.context.formEl).append(html);
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

					mura(".field-container-" + self.context.objectid,self.context.formEl).append(html);
				}

			},

			setDefault:function(fieldtype,field) {
				var self = this;

				switch( fieldtype ) {
					case "textfield":
					case "textarea":
						if(self.data[field.name]){
							field.value = self.data[field.name];
						}
					 break;
					case "checkbox":

						var ds = self.formJSON.datasets[field.datasetid];

						for(var i=0;i<ds.datarecords.length;i++) {
							if (self.ormform) {
								var sourceid = ds.source + "id";

								ds.datarecords[i].selected = 0;
								ds.datarecords[i].isselected = 0;

								if(self.data[field.name].items && self.data[field.name].items.length) {
									for(var x = 0;x < self.data[field.name].items.length;x++) {
										if (ds.datarecords[i].id == self.data[field.name].items[x][sourceid]) {
											ds.datarecords[i].isselected = 1;
											ds.datarecords[i].selected = 1;
										}
									}
								}
							}
							else {
								if (self.data[field.name] && ds.datarecords[i].value && self.data[field.name].indexOf(ds.datarecords[i].value) > -1) {
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
								 if(ds.datarecords[i].value == self.data[field.name]) {
									ds.datarecords[i].isselected = 1;
									field.selected = self.data[field.name];
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

				mura(".field-container-" + self.context.objectid,self.context.formEl).empty();

				if(!self.formInit) {
					self.initForm();
				}

				var fields = self.formJSON.form.pages[self.currentpage];

				for(var i = 0;i < fields.length;i++) {
					var field =  self.formJSON.form.fields[fields[i]];
					try {
						if( field.fieldtype.fieldtype != undefined && field.fieldtype.fieldtype != "") {
							self.renderField(field.fieldtype.fieldtype,field);
						}
					} catch(e){
						console.log('Error rendering form field:');
						console.log(field);
					}
				}

				if(self.ishuman && self.currentpage==(self.formJSON.form.pages.length-1)){
					mura(".field-container-" + self.context.objectid,self.context.formEl).append(self.ishuman);
				}

				if (self.context.mode == 'form') {
					self.renderPaging();
				}

				Mura.processMarkup(".field-container-" + self.context.objectid,self.context.formEl);

				self.trigger('afterRender');

			},

			renderPaging:function() {
				var self = this;
				var submitlabel=(typeof self.formJSON.form.formattributes != 'undefined' && typeof self.formJSON.form.formattributes.submitlabel != 'undefined' && self.formJSON.form.formattributes.submitlabel) ? self.formJSON.form.formattributes.submitlabel : self.rb.btnsubmitlabel;

				mura(".error-container-" + self.context.objectid,self.context.formEl).empty();

				mura(".paging-container-" + self.context.objectid,self.context.formEl).empty();

				if(self.formJSON.form.pages.length == 1) {
					mura(".paging-container-" + self.context.objectid,self.context.formEl).append(Mura.templates['paging']({page:self.currentpage+1,label:submitlabel,"class":self.rb.btnsubmitclass}));
				}
				else {
					if(self.currentpage == 0) {
						mura(".paging-container-" + self.context.objectid,self.context.formEl).append(Mura.templates['paging']({page:1,label:self.rb.btnnextlabel,"class":"form-nav"}));
					} else {
						mura(".paging-container-" + self.context.objectid,self.context.formEl).append(Mura.templates['paging']({page:self.currentpage-1,label:self.rb.btnbacklabel,"class":'form-nav'}));

						if(self.currentpage+1 < self.formJSON.form.pages.length) {
							mura(".paging-container-" + self.context.objectid,self.context.formEl).append(Mura.templates['paging']({page:self.currentpage+1,label:self.rb.btnnextlabel,"class":'form-nav'}));
						}
						else {
							mura(".paging-container-" + self.context.objectid,self.context.formEl).append(Mura.templates['paging']({page:self.currentpage+1,label:submitlabel,"class":'form-submit  btn-primary'}));
						}
					}

					if(self.backlink != undefined && self.backlink.length)
						mura(".paging-container-" + self.context.objectid,self.context.formEl).append(Mura.templates['paging']({page:self.currentpage+1,label:self.rb.btncancellabel,"class":'form-cancel btn-primary pull-right'}));
				}

				mura(".form-submit",self.context.formEl).click( function() {
					self.submitForm();
				});
				mura(".form-cancel",self.context.formEl).click( function() {
					self.getTableData( self.backlink );
				});


				var formNavHandler=function() {
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
									self.currentpage = mura(button).data('page');
									self.renderForm();
								}
							}
						);
					} else {
						var data=Mura.deepExtend({}, self.data, self.context);
		                data.validateform=true;
						data.formid=data.objectid;
						data.siteid=data.siteid || Mura.siteid;
						data.fields=self.getPageFieldList();

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
			                        data)
			                        .then(function(resp){
			                            if(typeof resp.data.errors == 'object' && !Mura.isEmptyObject(resp.data.errors)){
											self.showErrors( resp.data.errors );
			                            } else if(typeof resp.data.redirect != 'undefined') {
											if(resp.data.redirect && resp.data.redirect != location.href){
												location.href=resp.data.redirect;
											} else {
												location.reload(true);
											}
										} else {
											self.currentpage = mura(button).data('page');
			                                self.renderForm();
			                            }
			                        }
								);
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

				mura(".form-nav",self.context.formEl).off('click',formNavHandler).on('click',formNavHandler);
			},

			setDataValues: function() {
				var self = this;
				var multi = {};
				var item = {};
				var valid = [];
				var currentPage = {};

				mura(".field-container-" + self.context.objectid + " input, .field-container-" + self.context.objectid + " select, .field-container-" + self.context.objectid + " textarea").each( function() {

					currentPage[mura(this).attr('name')]=true;

					if( mura(this).is('[type="checkbox"]')) {
						if ( multi[mura(this).attr('name')] == undefined )
							multi[mura(this).attr('name')] = [];

						if( this.checked ) {
							if (self.ormform) {
								item = {};
								item['id'] = Mura.createUUID();
								item[self.entity + 'id'] = self.data.id;
								item[mura(this).attr('source') + 'id'] = mura(this).val();
								item['key'] = mura(this).val();

								multi[mura(this).attr('name')].push(item);
							}
							else {
								multi[mura(this).attr('name')].push(mura(this).val());
							}
						}
					}
					else if( mura(this).is('[type="radio"]')) {
						if( this.checked ) {
							self.data[ mura(this).attr('name') ] = mura(this).val();
							valid[ mura(this).attr('name') ] = self.data[name];
						}
					}
					else {
						self.data[ mura(this).attr('name') ] = mura(this).val();
						valid[ mura(this).attr('name') ] = self.data[mura(this).attr('name')];
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
							Mura.apiEndpoint  + '/'+ entityName + '/' + self.entityid + '?expand=all&ishuman=true'
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
										Mura.apiEndpoint  + '/'+ entityName + '/' + self.entityid + '?expand=all&ishuman=true'
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
				mura(self.context.formEl).empty();

				if(self.context.mode != undefined && self.context.mode == 'nested') {
					var html = Mura.templates['nested'](self.context);
				}
				else {
					var html = Mura.templates['form'](self.context);
				}

				mura(self.context.formEl).append(html);

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
				mura(".error-container-" + self.context.objectid,self.context.formEl).empty();

				var keepGoing=this.onSubmit.call(this.context.targetEl);
				if(typeof keepGoing != 'undefined' && !keepGoing){
					return;
				}

				delete self.data.isNew;

				mura(self.context.formEl)
					.find('form')
					.trigger('formSubmit');

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
								mura(self.context.formEl).html( Mura.templates['success'](data) );
							}
						},
						function( entity ) {
							self.showErrors( entity.properties.errors );
						}
					);
				}
				else {
					//console.log('b!');

					if(!Mura.formdata){
						var data=Mura.deepExtend({},self.context,self.data);
						data.saveform=true;
						data.formid=data.objectid;
						data.siteid=data.siteid || Mura.siteid;
						data.contentid=Mura.contentid || '';
						data.contenthistid=Mura.contenthistid || '';
						delete data.filename;

						var tokenArgs={
							siteid: data.siteid,
							context: data.formid
						}

					} else {
						var rawdata=Mura.deepExtend({},self.context,self.data);
						rawdata.saveform=true;
						rawdata.formid=rawdata.objectid;
						rawdata.siteid=rawdata.siteid || Mura.siteid;
						rawdata.contentid=Mura.contentid || '';
						rawdata.contenthistid=Mura.contenthistid || '';

						var tokenArgs={
							siteid: rawdata.siteid,
							context: rawdata.formid
						}

						delete rawdata.filename;

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

										 mura(self.context.formEl)
						 					.find('form')
						 					.trigger('formSubmitSuccess');

						 				Mura.trackEvent(
											{category:'Form',
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
	 										   mura(self.context.formEl).html( Mura.templates['success'](resp.data) );
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
				var frm=mura(this.context.formEl);
				var frmErrors=frm.find(".error-container-" + self.context.objectid);

				mura(this.context.formEl).find('.mura-response-error').remove();

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
						var label=mura(this.context.formEl).find('label[for="' + e + '"]');

						if(label.length){
							label.node.insertAdjacentHTML('afterend',Mura.templates['error'](error));
						} else {
							frmErrors.append(Mura.templates['error'](error));
						}
					} else {
						frmErrors.append(Mura.templates['error'](error));
					}
				}

				//var html = Mura.templates['error'](errorData);
				//console.log(errorData);

				mura(self.context.formEl).find('.g-recaptcha-container').each(function(el){
					grecaptcha.reset(el.getAttribute('data-widgetid'));
				});

				//mura(".error-container-" + self.context.objectid,self.context.formEl).html(html);
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

				self.filters.filterby = mura("#results-filterby",self.context.formEl).val();
				self.filters.filterkey = mura("#results-keywords",self.context.formEl).val();

				if( mura("#date1",self.context.formEl).length ) {
					if(mura("#date1",self.context.formEl).val().length) {
						self.filters.from = mura("#date1",self.context.formEl).val() + " " + mura("#hour1",self.context.formEl).val() + ":00:00";
						self.filters.fromhour = mura("#hour1",self.context.formEl).val();
						self.filters.fromdate = mura("#date1",self.context.formEl).val();
					}
					else {
						self.filters.from = "";
						self.filters.fromhour = 0;
						self.filters.fromdate = "";
					}

					if(mura("#date2",self.context.formEl).val().length) {
						self.filters.to = mura("#date2",self.context.formEl).val() + " " + mura("#hour2",self.context.formEl).val() + ":00:00";
						self.filters.tohour = mura("#hour2",self.context.formEl).val();
						self.filters.todate = mura("#date2",self.context.formEl).val();
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
					mura(self.context.formEl).append("Unsupported for pre-Mura 7.0 MuraORM Forms.");
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
							mura(self.context.formEl).append("Unsupported for pre-Mura 7.0 MuraORM Forms.");
							return;
						}

						self.getTableData();
				});
				*/
			},

			getTableData: function( navlink ) {
				var self = this;

				Mura.get(
					Mura.apiEndpoint  + self.entity + '/listviewdescriptor'
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
				mura(self.context.formEl).html( html );

				if (self.context.view == 'list') {
					mura("#date-filters",self.context.formEl).empty();
					mura("#btn-results-download",self.context.formEl).remove();
				}
				else {
					if (self.context.render == undefined) {
						mura(".datepicker", self.context.formEl).datepicker();
					}

					mura("#btn-results-download",self.context.formEl).click( function() {
						self.downloadResults();
					});
				}

				mura("#btn-results-search",self.context.formEl).click( function() {
					self.filterResults();
				});


				mura(".data-edit",self.context.formEl).click( function() {
					self.renderCRUD( mura(this).attr('data-value'),mura(this).attr('data-pos'));
				});
				mura(".data-view",self.context.formEl).click( function() {
					self.loadOverview(mura(this).attr('data-value'),mura(this).attr('data-pos'));
				});
				mura(".data-nav",self.context.formEl).click( function() {
					self.getTableData( mura(this).attr('data-value') );
				});

				mura(".data-sort").click( function() {

					var sortfield = mura(this).attr('data-value');

					if(sortfield == self.sortfield && self.sortdir == '')
						self.sortdir = '-';
					else
						self.sortdir = '';

					self.sortfield = mura(this).attr('data-value');
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

				mura(self.context.formEl).empty();

				var html = Mura.templates['view'](self.item);
				mura(self.context.formEl).append(html);

				mura(".nav-back",self.context.formEl).click( function() {
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

					if(this.wrappercssclass){
						returnString += ' ' + escapeExpression(this.wrappercssclass);
					}

					if(this.isrequired){
						returnString += ' req';
					}

					return returnString;
				});

				Mura.Handlebars.registerHelper('formClass',function() {
					var escapeExpression=Mura.Handlebars.escapeExpression;
					var returnString='mura-form';

					if(this['class']){
						returnString += ' ' + escapeExpression(this['class']);
					}

					return returnString;
				});

				Mura.Handlebars.registerHelper('commonInputAttributes',function() {
					//id, class, title, size
					var escapeExpression=Mura.Handlebars.escapeExpression;

					if(typeof this.fieldtype != 'undefined' && this.fieldtype.fieldtype=='file'){
						var returnString='name="' + escapeExpression(this.name) + '_attachment"';
					} else {
						var returnString='name="' + escapeExpression(this.name) + '"';
					}

					if(this.cssid){
						returnString += ' id="' + escapeExpression(this.cssid) + '"';
					} else {
						returnString += ' id="field-' + escapeExpression(this.name) + '"';
					}

					if(this.cssclass){
						returnString += ' class="' + escapeExpression(this.cssclass) + '"';
					}

					if(this.tooltip){
						returnString += ' title="' + escapeExpression(this.tooltip) + '"';
					}

					if(this.size){
						returnString += ' size="' + escapeExpression(this.size) + '"';
					}

					return returnString;
				});

			}

		});

		//Legacy for early adopter backwords support
		Mura.DisplayObject.form=Mura.DisplayObject.Form;

	}));
;/* This file is part of Mura CMS.

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
;(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['Mura'], factory);
    } else if (typeof module === 'object' && module.exports) {
        // Node. Does not work with strict CommonJS, but
        // only CommonJS-like environments that support module.exports,
        // like Node.
        mura=factory(require('Mura'),require('Handlebars'));
    } else {
        // Browser globals (root is window)
        factory(root.Mura,root.Handlebars);
    }
}(this, function (Mura,Handlebars) {
    Mura.datacache=new Mura.Cache();
    Mura.Handlebars=Handlebars.create();
    Mura.templatesLoaded=false;
    Handlebars.noConflict();
}));
;this["mura"] = this["mura"] || {};
this["mura"]["templates"] = this["mura"]["templates"] || {};

this["mura"]["templates"]["checkbox"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.summary || (depth0 != null ? depth0.summary : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"summary","hash":{},"data":data}) : helper)));
},"3":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"label","hash":{},"data":data}) : helper)));
},"5":function(container,depth0,helpers,partials,data) {
    return " <ins>Required</ins>";
},"7":function(container,depth0,helpers,partials,data) {
    return "</br>";
},"9":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=container.lambda, alias2=container.escapeExpression, alias3=depth0 != null ? depth0 : (container.nullContext || {}), alias4=helpers.helperMissing, alias5="function";

  return "				<label class=\"checkbox\">\r\n				<input source=\""
    + alias2(alias1(((stack1 = (depths[1] != null ? depths[1].dataset : depths[1])) != null ? stack1.source : stack1), depth0))
    + "\" type=\"checkbox\" name=\""
    + alias2(alias1((depths[1] != null ? depths[1].name : depths[1]), depth0))
    + "\" id=\"field-"
    + alias2(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : alias4),(typeof helper === alias5 ? helper.call(alias3,{"name":"id","hash":{},"data":data}) : helper)))
    + "\" value=\""
    + alias2(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : alias4),(typeof helper === alias5 ? helper.call(alias3,{"name":"id","hash":{},"data":data}) : helper)))
    + "\" id=\""
    + alias2(alias1((depths[1] != null ? depths[1].name : depths[1]), depth0))
    + "-"
    + alias2(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : alias4),(typeof helper === alias5 ? helper.call(alias3,{"name":"id","hash":{},"data":data}) : helper)))
    + "\" "
    + ((stack1 = helpers["if"].call(alias3,(depth0 != null ? depth0.isselected : depth0),{"name":"if","hash":{},"fn":container.program(10, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "/>\r\n				"
    + alias2(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias4),(typeof helper === alias5 ? helper.call(alias3,{"name":"label","hash":{},"data":data}) : helper)))
    + "</label>\r\n";
},"10":function(container,depth0,helpers,partials,data) {
    return "checked='checked'";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function";

  return "	<div class=\""
    + ((stack1 = ((helper = (helper = helpers.inputWrapperClass || (depth0 != null ? depth0.inputWrapperClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + container.escapeExpression(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "-container\">\r\n		<div class=\"mura-checkbox-group\">\r\n			<div class=\"mura-group-label\">"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.summary : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.program(3, data, 0, blockParams, depths),"data":data})) != null ? stack1 : "")
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isrequired : depth0),{"name":"if","hash":{},"fn":container.program(5, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</div>\r\n			"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.summary : depth0),{"name":"if","hash":{},"fn":container.program(7, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "\r\n"
    + ((stack1 = (helpers.eachCheck || (depth0 && depth0.eachCheck) || alias2).call(alias1,((stack1 = (depth0 != null ? depth0.dataset : depth0)) != null ? stack1.options : stack1),(depth0 != null ? depth0.selected : depth0),{"name":"eachCheck","hash":{},"fn":container.program(9, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "		</div>\r\n	</div>\r\n";
},"useData":true,"useDepths":true});

this["mura"]["templates"]["checkbox_static"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.summary || (depth0 != null ? depth0.summary : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"summary","hash":{},"data":data}) : helper)));
},"3":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"label","hash":{},"data":data}) : helper)));
},"5":function(container,depth0,helpers,partials,data) {
    return " <ins>Required</ins>";
},"7":function(container,depth0,helpers,partials,data) {
    return "</br>";
},"9":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=container.lambda, alias2=container.escapeExpression, alias3=depth0 != null ? depth0 : (container.nullContext || {}), alias4=helpers.helperMissing, alias5="function";

  return "				<label class=\"checkbox\">\r\n				<input type=\"checkbox\" name=\""
    + alias2(alias1((depths[1] != null ? depths[1].name : depths[1]), depth0))
    + "\" id=\"field-"
    + alias2(((helper = (helper = helpers.datarecordid || (depth0 != null ? depth0.datarecordid : depth0)) != null ? helper : alias4),(typeof helper === alias5 ? helper.call(alias3,{"name":"datarecordid","hash":{},"data":data}) : helper)))
    + "\" value=\""
    + alias2(((helper = (helper = helpers.value || (depth0 != null ? depth0.value : depth0)) != null ? helper : alias4),(typeof helper === alias5 ? helper.call(alias3,{"name":"value","hash":{},"data":data}) : helper)))
    + "\" id=\""
    + alias2(alias1((depths[1] != null ? depths[1].name : depths[1]), depth0))
    + "\" "
    + ((stack1 = helpers["if"].call(alias3,(depth0 != null ? depth0.isselected : depth0),{"name":"if","hash":{},"fn":container.program(10, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + ((stack1 = helpers["if"].call(alias3,(depth0 != null ? depth0.selected : depth0),{"name":"if","hash":{},"fn":container.program(10, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "/>\r\n				"
    + alias2(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias4),(typeof helper === alias5 ? helper.call(alias3,{"name":"label","hash":{},"data":data}) : helper)))
    + "</label>\r\n";
},"10":function(container,depth0,helpers,partials,data) {
    return " checked='checked'";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function";

  return "	<div class=\""
    + ((stack1 = ((helper = (helper = helpers.inputWrapperClass || (depth0 != null ? depth0.inputWrapperClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + container.escapeExpression(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "-container\">\r\n		<div class=\"mura-checkbox-group\">\r\n			<div class=\"mura-group-label\">"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.summary : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.program(3, data, 0, blockParams, depths),"data":data})) != null ? stack1 : "")
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isrequired : depth0),{"name":"if","hash":{},"fn":container.program(5, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</div>\r\n			"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.summary : depth0),{"name":"if","hash":{},"fn":container.program(7, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "\r\n"
    + ((stack1 = (helpers.eachStatic || (depth0 && depth0.eachStatic) || alias2).call(alias1,(depth0 != null ? depth0.dataset : depth0),{"name":"eachStatic","hash":{},"fn":container.program(9, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "		</div>\r\n	</div>\r\n";
},"useData":true,"useDepths":true});

this["mura"]["templates"]["dropdown"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.summary || (depth0 != null ? depth0.summary : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"summary","hash":{},"data":data}) : helper)));
},"3":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"label","hash":{},"data":data}) : helper)));
},"5":function(container,depth0,helpers,partials,data) {
    return " <ins>Required</ins>";
},"7":function(container,depth0,helpers,partials,data) {
    return "</br>";
},"9":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "					<option data-isother=\""
    + alias4(((helper = (helper = helpers.isother || (depth0 != null ? depth0.isother : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"isother","hash":{},"data":data}) : helper)))
    + "\" id=\"field-"
    + alias4(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"id","hash":{},"data":data}) : helper)))
    + "\" value=\""
    + alias4(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"id","hash":{},"data":data}) : helper)))
    + "\" "
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isselected : depth0),{"name":"if","hash":{},"fn":container.program(10, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + ">"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + "</option>\n";
},"10":function(container,depth0,helpers,partials,data) {
    return "selected='selected'";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "	<div class=\""
    + ((stack1 = ((helper = (helper = helpers.inputWrapperClass || (depth0 != null ? depth0.inputWrapperClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "-container\">\n		<label for=\""
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "\">"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.summary : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0),"inverse":container.program(3, data, 0),"data":data})) != null ? stack1 : "")
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isrequired : depth0),{"name":"if","hash":{},"fn":container.program(5, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</label>\n		"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.summary : depth0),{"name":"if","hash":{},"fn":container.program(7, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "\n			<select "
    + ((stack1 = ((helper = (helper = helpers.commonInputAttributes || (depth0 != null ? depth0.commonInputAttributes : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"commonInputAttributes","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + ">\n"
    + ((stack1 = helpers.each.call(alias1,((stack1 = (depth0 != null ? depth0.dataset : depth0)) != null ? stack1.options : stack1),{"name":"each","hash":{},"fn":container.program(9, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "			</select>\n	</div>\n";
},"useData":true});

this["mura"]["templates"]["dropdown_static"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.summary || (depth0 != null ? depth0.summary : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"summary","hash":{},"data":data}) : helper)));
},"3":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"label","hash":{},"data":data}) : helper)));
},"5":function(container,depth0,helpers,partials,data) {
    return " <ins>Required</ins>";
},"7":function(container,depth0,helpers,partials,data) {
    return "</br>";
},"9":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "				<option data-isother=\""
    + alias4(((helper = (helper = helpers.isother || (depth0 != null ? depth0.isother : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"isother","hash":{},"data":data}) : helper)))
    + "\" id=\"field-"
    + alias4(((helper = (helper = helpers.datarecordid || (depth0 != null ? depth0.datarecordid : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"datarecordid","hash":{},"data":data}) : helper)))
    + "\" value=\""
    + alias4(((helper = (helper = helpers.value || (depth0 != null ? depth0.value : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"value","hash":{},"data":data}) : helper)))
    + "\" "
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isselected : depth0),{"name":"if","hash":{},"fn":container.program(10, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + ">"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + "</option>\n";
},"10":function(container,depth0,helpers,partials,data) {
    return "selected='selected'";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "	<div class=\""
    + ((stack1 = ((helper = (helper = helpers.inputWrapperClass || (depth0 != null ? depth0.inputWrapperClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "-container\">\n		<label for=\""
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "\">"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.summary : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0),"inverse":container.program(3, data, 0),"data":data})) != null ? stack1 : "")
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isrequired : depth0),{"name":"if","hash":{},"fn":container.program(5, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</label>\n		"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.summary : depth0),{"name":"if","hash":{},"fn":container.program(7, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "\n		<select "
    + ((stack1 = ((helper = (helper = helpers.commonInputAttributes || (depth0 != null ? depth0.commonInputAttributes : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"commonInputAttributes","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + ">\n"
    + ((stack1 = (helpers.eachStatic || (depth0 && depth0.eachStatic) || alias2).call(alias1,(depth0 != null ? depth0.dataset : depth0),{"name":"eachStatic","hash":{},"fn":container.program(9, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "		</select>\n	</div>\n";
},"useData":true});

this["mura"]["templates"]["error"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"label","hash":{},"data":data}) : helper)))
    + ": ";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "<div class=\"mura-response-error\" data-field=\""
    + alias4(((helper = (helper = helpers.field || (depth0 != null ? depth0.field : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"field","hash":{},"data":data}) : helper)))
    + "\">"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.label : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + alias4(((helper = (helper = helpers.message || (depth0 != null ? depth0.message : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"message","hash":{},"data":data}) : helper)))
    + "</div>\r\n";
},"useData":true});

this["mura"]["templates"]["file"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    return " <ins>Required</ins>";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "<div class=\""
    + ((stack1 = ((helper = (helper = helpers.inputWrapperClass || (depth0 != null ? depth0.inputWrapperClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "-container\">\r\n	<label for=\""
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "_attachment\">"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isrequired : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</label>\r\n	<input type=\"file\" "
    + ((stack1 = ((helper = (helper = helpers.commonInputAttributes || (depth0 != null ? depth0.commonInputAttributes : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"commonInputAttributes","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "/>\r\n</div>\r\n";
},"useData":true});

this["mura"]["templates"]["form"] = this.mura.Handlebars.template({"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "<form id=\"frm"
    + alias4(((helper = (helper = helpers.objectid || (depth0 != null ? depth0.objectid : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"objectid","hash":{},"data":data}) : helper)))
    + "\" class=\""
    + ((stack1 = ((helper = (helper = helpers.formClass || (depth0 != null ? depth0.formClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"formClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" novalidate=\"novalidate\" enctype=\"multipart/form-data\">\n<div class=\"error-container-"
    + alias4(((helper = (helper = helpers.objectid || (depth0 != null ? depth0.objectid : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"objectid","hash":{},"data":data}) : helper)))
    + "\">\n</div>\n<div class=\"field-container-"
    + alias4(((helper = (helper = helpers.objectid || (depth0 != null ? depth0.objectid : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"objectid","hash":{},"data":data}) : helper)))
    + "\">\n</div>\n<div class=\"paging-container-"
    + alias4(((helper = (helper = helpers.objectid || (depth0 != null ? depth0.objectid : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"objectid","hash":{},"data":data}) : helper)))
    + "\">\n</div>\n	<input type=\"hidden\" name=\"formid\" value=\""
    + alias4(((helper = (helper = helpers.objectid || (depth0 != null ? depth0.objectid : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"objectid","hash":{},"data":data}) : helper)))
    + "\">\n</form>\n";
},"useData":true});

this["mura"]["templates"]["hidden"] = this.mura.Handlebars.template({"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "<input type=\"hidden\" name=\""
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "\" "
    + ((stack1 = ((helper = (helper = helpers.commonInputAttributes || (depth0 != null ? depth0.commonInputAttributes : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"commonInputAttributes","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + " value=\""
    + alias4(((helper = (helper = helpers.value || (depth0 != null ? depth0.value : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"value","hash":{},"data":data}) : helper)))
    + "\" />			\n";
},"useData":true});

this["mura"]["templates"]["list"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "					<option value=\""
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "\">"
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "</option>\n";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<form>\n	<div class=\"mura-control-group\">\n		<label for=\"beanList\">Choose Entity:</label>	\n		<div class=\"form-group-select\">\n			<select type=\"text\" name=\"bean\" id=\"select-bean-value\">\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),depth0,{"name":"each","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "			</select>\n		</div>\n	</div>\n	<div class=\"mura-control-group\">\n		<button type=\"button\" id=\"select-bean\">Go</button>\n	</div>\n</form>";
},"useData":true});

this["mura"]["templates"]["nested"] = this.mura.Handlebars.template({"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<div class=\"field-container-"
    + container.escapeExpression(((helper = (helper = helpers.objectid || (depth0 != null ? depth0.objectid : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"objectid","hash":{},"data":data}) : helper)))
    + "\">\r\n\r\n</div>\r\n";
},"useData":true});

this["mura"]["templates"]["paging"] = this.mura.Handlebars.template({"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "<button class=\""
    + alias4(((helper = (helper = helpers["class"] || (depth0 != null ? depth0["class"] : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"class","hash":{},"data":data}) : helper)))
    + "\" type=\"button\" data-page=\""
    + alias4(((helper = (helper = helpers.page || (depth0 != null ? depth0.page : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"page","hash":{},"data":data}) : helper)))
    + "\">"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + "</button> ";
},"useData":true});

this["mura"]["templates"]["radio"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.summary || (depth0 != null ? depth0.summary : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"summary","hash":{},"data":data}) : helper)));
},"3":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"label","hash":{},"data":data}) : helper)));
},"5":function(container,depth0,helpers,partials,data) {
    return " <ins>Required</ins>";
},"7":function(container,depth0,helpers,partials,data) {
    return "</br>";
},"9":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "				<label for=\"field-"
    + alias4(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"id","hash":{},"data":data}) : helper)))
    + "\" class=\"radio\">\n				<input type=\"radio\" name=\""
    + alias4(container.lambda((depths[1] != null ? depths[1].name : depths[1]), depth0))
    + "id\" id=\"field-"
    + alias4(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"id","hash":{},"data":data}) : helper)))
    + "\" value=\""
    + alias4(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"id","hash":{},"data":data}) : helper)))
    + "\" "
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isselected : depth0),{"name":"if","hash":{},"fn":container.program(10, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "/>\n				"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + "</label>\n";
},"10":function(container,depth0,helpers,partials,data) {
    return "checked='checked'";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function";

  return "	<div class=\""
    + ((stack1 = ((helper = (helper = helpers.inputWrapperClass || (depth0 != null ? depth0.inputWrapperClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + container.escapeExpression(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "-container\">\n		<div class=\"mura-radio-group\">\n			<div class=\"mura-group-label\">"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.summary : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.program(3, data, 0, blockParams, depths),"data":data})) != null ? stack1 : "")
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isrequired : depth0),{"name":"if","hash":{},"fn":container.program(5, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</div>\n			"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.summary : depth0),{"name":"if","hash":{},"fn":container.program(7, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "\n"
    + ((stack1 = helpers.each.call(alias1,((stack1 = (depth0 != null ? depth0.dataset : depth0)) != null ? stack1.options : stack1),{"name":"each","hash":{},"fn":container.program(9, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "		</div>\n	</div>\n";
},"useData":true,"useDepths":true});

this["mura"]["templates"]["radio_static"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.summary || (depth0 != null ? depth0.summary : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"summary","hash":{},"data":data}) : helper)));
},"3":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"label","hash":{},"data":data}) : helper)));
},"5":function(container,depth0,helpers,partials,data) {
    return " <ins>Required</ins>";
},"7":function(container,depth0,helpers,partials,data) {
    return "</br>";
},"9":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "				<label for=\"field-"
    + alias4(((helper = (helper = helpers.datarecordid || (depth0 != null ? depth0.datarecordid : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"datarecordid","hash":{},"data":data}) : helper)))
    + "\" class=\"radio\">\n				<input type=\"radio\" name=\""
    + alias4(container.lambda((depths[1] != null ? depths[1].name : depths[1]), depth0))
    + "\" id=\"field-"
    + alias4(((helper = (helper = helpers.datarecordid || (depth0 != null ? depth0.datarecordid : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"datarecordid","hash":{},"data":data}) : helper)))
    + "\" value=\""
    + alias4(((helper = (helper = helpers.value || (depth0 != null ? depth0.value : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"value","hash":{},"data":data}) : helper)))
    + "\"  "
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isselected : depth0),{"name":"if","hash":{},"fn":container.program(10, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "/>\n				"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + "</label>\n";
},"10":function(container,depth0,helpers,partials,data) {
    return "checked='checked'";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function";

  return "	<div class=\""
    + ((stack1 = ((helper = (helper = helpers.inputWrapperClass || (depth0 != null ? depth0.inputWrapperClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + container.escapeExpression(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "-container\">\n		<div class=\"mura-radio-group\">\n			<div class=\"mura-group-label\">"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.summary : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.program(3, data, 0, blockParams, depths),"data":data})) != null ? stack1 : "")
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isrequired : depth0),{"name":"if","hash":{},"fn":container.program(5, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</div>\n			"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.summary : depth0),{"name":"if","hash":{},"fn":container.program(7, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "\n"
    + ((stack1 = (helpers.eachStatic || (depth0 && depth0.eachStatic) || alias2).call(alias1,(depth0 != null ? depth0.dataset : depth0),{"name":"eachStatic","hash":{},"fn":container.program(9, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "		</div>\n	</div>\n";
},"useData":true,"useDepths":true});

this["mura"]["templates"]["section"] = this.mura.Handlebars.template({"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "<div class=\""
    + ((stack1 = ((helper = (helper = helpers.inputWrapperClass || (depth0 != null ? depth0.inputWrapperClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "-container\">\r\n<div class=\"mura-section\">"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + "</div>\r\n<div class=\"mura-divide\"></div>\r\n</div>";
},"useData":true});

this["mura"]["templates"]["success"] = this.mura.Handlebars.template({"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper;

  return "<div class=\"mura-response-success\">"
    + ((stack1 = ((helper = (helper = helpers.responsemessage || (depth0 != null ? depth0.responsemessage : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"responsemessage","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "</div>\n";
},"useData":true});

this["mura"]["templates"]["table"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "<option value=\""
    + alias4(((helper = (helper = helpers.num || (depth0 != null ? depth0.num : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"num","hash":{},"data":data}) : helper)))
    + "\" "
    + alias4(((helper = (helper = helpers.selected || (depth0 != null ? depth0.selected : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"selected","hash":{},"data":data}) : helper)))
    + ">"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + "</option>";
},"3":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "					<option value=\""
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "\" "
    + alias4(((helper = (helper = helpers.selected || (depth0 != null ? depth0.selected : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"selected","hash":{},"data":data}) : helper)))
    + ">"
    + alias4(((helper = (helper = helpers.displayName || (depth0 != null ? depth0.displayName : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"displayName","hash":{},"data":data}) : helper)))
    + "</option>\n";
},"5":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "			<th class='data-sort' data-value='"
    + alias4(((helper = (helper = helpers.column || (depth0 != null ? depth0.column : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"column","hash":{},"data":data}) : helper)))
    + "'>"
    + alias4(((helper = (helper = helpers.displayName || (depth0 != null ? depth0.displayName : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"displayName","hash":{},"data":data}) : helper)))
    + "</th>\n";
},"7":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing;

  return "			<tr class=\"even\">\n"
    + ((stack1 = (helpers.eachColRow || (depth0 && depth0.eachColRow) || alias2).call(alias1,depth0,(depths[1] != null ? depths[1].columns : depths[1]),{"name":"eachColRow","hash":{},"fn":container.program(8, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "				<td>\n"
    + ((stack1 = (helpers.eachColButton || (depth0 && depth0.eachColButton) || alias2).call(alias1,depth0,{"name":"eachColButton","hash":{},"fn":container.program(10, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "				</td>\n			</tr>\n";
},"8":function(container,depth0,helpers,partials,data) {
    return "					<td>"
    + container.escapeExpression(container.lambda(depth0, depth0))
    + "</td>\n";
},"10":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "				<button type=\"button\" class=\""
    + alias4(((helper = (helper = helpers.type || (depth0 != null ? depth0.type : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"type","hash":{},"data":data}) : helper)))
    + "\" data-value=\""
    + alias4(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"id","hash":{},"data":data}) : helper)))
    + "\" data-pos=\""
    + alias4(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"index","hash":{},"data":data}) : helper)))
    + "\">"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + "</button>\n";
},"12":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "				<button class='data-nav' data-value=\""
    + container.escapeExpression(container.lambda(((stack1 = ((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.links : stack1)) != null ? stack1.first : stack1), depth0))
    + "\">First</button>\n";
},"14":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "				<button class='data-nav' data-value=\""
    + container.escapeExpression(container.lambda(((stack1 = ((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.links : stack1)) != null ? stack1.previous : stack1), depth0))
    + "\">Prev</button>\n";
},"16":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "				<button class='data-nav' data-value=\""
    + container.escapeExpression(container.lambda(((stack1 = ((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.links : stack1)) != null ? stack1.next : stack1), depth0))
    + "\">Next</button>\n";
},"18":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "				<button class='data-nav' data-value=\""
    + container.escapeExpression(container.lambda(((stack1 = ((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.links : stack1)) != null ? stack1.last : stack1), depth0))
    + "\">Last</button>\n";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, alias1=container.lambda, alias2=container.escapeExpression, alias3=depth0 != null ? depth0 : (container.nullContext || {}), alias4=helpers.helperMissing;

  return "	<div class=\"mura-control-group\">\n		<div id=\"filter-results-container\">\n			<div id=\"date-filters\">\n				<div class=\"control-group\">\n				  <label>From</label>\n				  <div class=\"controls\">\n				  	<input type=\"text\" class=\"datepicker mura-date\" id=\"date1\" name=\"date1\" validate=\"date\" value=\""
    + alias2(alias1(((stack1 = (depth0 != null ? depth0.filters : depth0)) != null ? stack1.fromdate : stack1), depth0))
    + "\">\n				  	<select id=\"hour1\" name=\"hour1\" class=\"mura-date\">"
    + ((stack1 = (helpers.eachHour || (depth0 && depth0.eachHour) || alias4).call(alias3,((stack1 = (depth0 != null ? depth0.filters : depth0)) != null ? stack1.fromhour : stack1),{"name":"eachHour","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</select></select>\n					</div>\n				</div>\n			\n				<div class=\"control-group\">\n				  <label>To</label>\n				  <div class=\"controls\">\n				  	<input type=\"text\" class=\"datepicker mura-date\" id=\"date2\" name=\"date2\" validate=\"date\" value=\""
    + alias2(alias1(((stack1 = (depth0 != null ? depth0.filters : depth0)) != null ? stack1.todate : stack1), depth0))
    + "\">\n				  	<select id=\"hour2\" name=\"hour2\"  class=\"mura-date\">"
    + ((stack1 = (helpers.eachHour || (depth0 && depth0.eachHour) || alias4).call(alias3,((stack1 = (depth0 != null ? depth0.filters : depth0)) != null ? stack1.tohour : stack1),{"name":"eachHour","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</select></select>\n				   </select>\n					</div>\n				</div>\n			</div>\n					\n			<div class=\"control-group\">\n				<label>Keywords</label>\n				<div class=\"controls\">\n					<select name=\"filterBy\" class=\"mura-date\" id=\"results-filterby\">\n"
    + ((stack1 = (helpers.eachKey || (depth0 && depth0.eachKey) || alias4).call(alias3,(depth0 != null ? depth0.properties : depth0),((stack1 = (depth0 != null ? depth0.filters : depth0)) != null ? stack1.filterby : stack1),{"name":"eachKey","hash":{},"fn":container.program(3, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "					</select>\n					<input type=\"text\" class=\"mura-half\" name=\"keywords\" id=\"results-keywords\" value=\""
    + alias2(alias1(((stack1 = (depth0 != null ? depth0.filters : depth0)) != null ? stack1.filterkey : stack1), depth0))
    + "\">\n				</div>\n			</div>\n			<div class=\"form-actions\">\n				<button type=\"button\" class=\"btn\" id=\"btn-results-search\" ><i class=\"mi-bar-chart\"></i> View Data</button>\n				<button type=\"button\" class=\"btn\"  id=\"btn-results-download\" ><i class=\"mi-download\"></i> Download</button>\n			</div>\n		</div>\n	<div>\n\n	<ul class=\"metadata\">\n		<li>Page:\n			<strong>"
    + alias2(alias1(((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.pageindex : stack1), depth0))
    + " of "
    + alias2(alias1(((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.totalpages : stack1), depth0))
    + "</strong>\n		</li>\n		<li>Total Records:\n			<strong>"
    + alias2(alias1(((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.totalitems : stack1), depth0))
    + "</strong>\n		</li>\n	</ul>\n\n	<table style=\"width: 100%\" class=\"table\">\n		<thead>\n		<tr>\n"
    + ((stack1 = helpers.each.call(alias3,(depth0 != null ? depth0.columns : depth0),{"name":"each","hash":{},"fn":container.program(5, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "			<th></th>\n		</tr>\n		</thead>\n		<tbody>\n"
    + ((stack1 = helpers.each.call(alias3,((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.items : stack1),{"name":"each","hash":{},"fn":container.program(7, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "		</tbody>\n		<tfoot>\n		<tr>\n			<td>\n"
    + ((stack1 = helpers["if"].call(alias3,((stack1 = ((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.links : stack1)) != null ? stack1.first : stack1),{"name":"if","hash":{},"fn":container.program(12, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + ((stack1 = helpers["if"].call(alias3,((stack1 = ((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.links : stack1)) != null ? stack1.previous : stack1),{"name":"if","hash":{},"fn":container.program(14, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + ((stack1 = helpers["if"].call(alias3,((stack1 = ((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.links : stack1)) != null ? stack1.next : stack1),{"name":"if","hash":{},"fn":container.program(16, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + ((stack1 = helpers["if"].call(alias3,((stack1 = ((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.links : stack1)) != null ? stack1.last : stack1),{"name":"if","hash":{},"fn":container.program(18, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "			</td>\n		</tfoot>\n	</table>\n</div>";
},"useData":true,"useDepths":true});

this["mura"]["templates"]["textarea"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.summary || (depth0 != null ? depth0.summary : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"summary","hash":{},"data":data}) : helper)));
},"3":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"label","hash":{},"data":data}) : helper)));
},"5":function(container,depth0,helpers,partials,data) {
    return " <ins>Required</ins>";
},"7":function(container,depth0,helpers,partials,data) {
    return "</br>";
},"9":function(container,depth0,helpers,partials,data) {
    var helper;

  return " placeholder=\""
    + container.escapeExpression(((helper = (helper = helpers.placeholder || (depth0 != null ? depth0.placeholder : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"placeholder","hash":{},"data":data}) : helper)))
    + "\"";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "<div class=\""
    + ((stack1 = ((helper = (helper = helpers.inputWrapperClass || (depth0 != null ? depth0.inputWrapperClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\"  id=\"field-"
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "-container\">\r\n	<label for=\""
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "\">"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.summary : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0),"inverse":container.program(3, data, 0),"data":data})) != null ? stack1 : "")
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isrequired : depth0),{"name":"if","hash":{},"fn":container.program(5, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</label>\r\n	"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.summary : depth0),{"name":"if","hash":{},"fn":container.program(7, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "\r\n	<textarea "
    + ((stack1 = ((helper = (helper = helpers.commonInputAttributes || (depth0 != null ? depth0.commonInputAttributes : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"commonInputAttributes","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.placeholder : depth0),{"name":"if","hash":{},"fn":container.program(9, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + ">"
    + alias4(((helper = (helper = helpers.value || (depth0 != null ? depth0.value : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"value","hash":{},"data":data}) : helper)))
    + "</textarea>\r\n</div>\r\n";
},"useData":true});

this["mura"]["templates"]["textblock"] = this.mura.Handlebars.template({"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function";

  return "<div class=\""
    + ((stack1 = ((helper = (helper = helpers.inputWrapperClass || (depth0 != null ? depth0.inputWrapperClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + container.escapeExpression(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "-container\">\r\n<div class=\"mura-form-text\">"
    + ((stack1 = ((helper = (helper = helpers.value || (depth0 != null ? depth0.value : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"value","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "</div>\r\n</div>";
},"useData":true});

this["mura"]["templates"]["textfield"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.summary || (depth0 != null ? depth0.summary : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"summary","hash":{},"data":data}) : helper)));
},"3":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"label","hash":{},"data":data}) : helper)));
},"5":function(container,depth0,helpers,partials,data) {
    return " <ins>Required</ins>";
},"7":function(container,depth0,helpers,partials,data) {
    return "</br>";
},"9":function(container,depth0,helpers,partials,data) {
    var helper;

  return " placeholder=\""
    + container.escapeExpression(((helper = (helper = helpers.placeholder || (depth0 != null ? depth0.placeholder : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"placeholder","hash":{},"data":data}) : helper)))
    + "\"";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "<div class=\""
    + ((stack1 = ((helper = (helper = helpers.inputWrapperClass || (depth0 != null ? depth0.inputWrapperClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "-container\">\r\n	<label for=\""
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "\">"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.summary : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0),"inverse":container.program(3, data, 0),"data":data})) != null ? stack1 : "")
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isrequired : depth0),{"name":"if","hash":{},"fn":container.program(5, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</label>\r\n	"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.summary : depth0),{"name":"if","hash":{},"fn":container.program(7, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "\r\n	<input type=\"text\" "
    + ((stack1 = ((helper = (helper = helpers.commonInputAttributes || (depth0 != null ? depth0.commonInputAttributes : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"commonInputAttributes","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + " value=\""
    + alias4(((helper = (helper = helpers.value || (depth0 != null ? depth0.value : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"value","hash":{},"data":data}) : helper)))
    + "\""
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.placeholder : depth0),{"name":"if","hash":{},"fn":container.program(9, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "/>\r\n</div>\r\n";
},"useData":true});

this["mura"]["templates"]["view"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "	<li>\n		<strong>"
    + alias4(((helper = (helper = helpers.displayName || (depth0 != null ? depth0.displayName : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"displayName","hash":{},"data":data}) : helper)))
    + ": </strong> "
    + alias4(((helper = (helper = helpers.displayValue || (depth0 != null ? depth0.displayValue : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"displayValue","hash":{},"data":data}) : helper)))
    + " \n	</li>\n";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<div class=\"mura-control-group\">\n<ul>\n"
    + ((stack1 = (helpers.eachProp || (depth0 && depth0.eachProp) || helpers.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),depth0,{"name":"eachProp","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</ul>\n<button type=\"button\" class=\"nav-back\">Back</button>\n</div>";
},"useData":true});