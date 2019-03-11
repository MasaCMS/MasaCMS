
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

	var _interopRequireWildcard = __webpack_require__(1)['default'];

	var _interopRequireDefault = __webpack_require__(2)['default'];

	exports.__esModule = true;

	var _handlebarsBase = __webpack_require__(3);

	var base = _interopRequireWildcard(_handlebarsBase);

	// Each of these augment the Handlebars object. No need to setup here.
	// (This is done to easily share code between commonjs and browse envs)

	var _handlebarsSafeString = __webpack_require__(20);

	var _handlebarsSafeString2 = _interopRequireDefault(_handlebarsSafeString);

	var _handlebarsException = __webpack_require__(5);

	var _handlebarsException2 = _interopRequireDefault(_handlebarsException);

	var _handlebarsUtils = __webpack_require__(4);

	var Utils = _interopRequireWildcard(_handlebarsUtils);

	var _handlebarsRuntime = __webpack_require__(21);

	var runtime = _interopRequireWildcard(_handlebarsRuntime);

	var _handlebarsNoConflict = __webpack_require__(22);

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
/* 1 */
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
/* 2 */
/***/ function(module, exports) {

	"use strict";

	exports["default"] = function (obj) {
	  return obj && obj.__esModule ? obj : {
	    "default": obj
	  };
	};

	exports.__esModule = true;

/***/ },
/* 3 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var _interopRequireDefault = __webpack_require__(2)['default'];

	exports.__esModule = true;
	exports.HandlebarsEnvironment = HandlebarsEnvironment;

	var _utils = __webpack_require__(4);

	var _exception = __webpack_require__(5);

	var _exception2 = _interopRequireDefault(_exception);

	var _helpers = __webpack_require__(9);

	var _decorators = __webpack_require__(17);

	var _logger = __webpack_require__(19);

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
/* 4 */
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
/* 5 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var _Object$defineProperty = __webpack_require__(6)['default'];

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
/* 6 */
/***/ function(module, exports, __webpack_require__) {

	module.exports = { "default": __webpack_require__(7), __esModule: true };

/***/ },
/* 7 */
/***/ function(module, exports, __webpack_require__) {

	var $ = __webpack_require__(8);
	module.exports = function defineProperty(it, key, desc){
	  return $.setDesc(it, key, desc);
	};

/***/ },
/* 8 */
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
/* 9 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var _interopRequireDefault = __webpack_require__(2)['default'];

	exports.__esModule = true;
	exports.registerDefaultHelpers = registerDefaultHelpers;

	var _helpersBlockHelperMissing = __webpack_require__(10);

	var _helpersBlockHelperMissing2 = _interopRequireDefault(_helpersBlockHelperMissing);

	var _helpersEach = __webpack_require__(11);

	var _helpersEach2 = _interopRequireDefault(_helpersEach);

	var _helpersHelperMissing = __webpack_require__(12);

	var _helpersHelperMissing2 = _interopRequireDefault(_helpersHelperMissing);

	var _helpersIf = __webpack_require__(13);

	var _helpersIf2 = _interopRequireDefault(_helpersIf);

	var _helpersLog = __webpack_require__(14);

	var _helpersLog2 = _interopRequireDefault(_helpersLog);

	var _helpersLookup = __webpack_require__(15);

	var _helpersLookup2 = _interopRequireDefault(_helpersLookup);

	var _helpersWith = __webpack_require__(16);

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
/* 10 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	exports.__esModule = true;

	var _utils = __webpack_require__(4);

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
/* 11 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var _interopRequireDefault = __webpack_require__(2)['default'];

	exports.__esModule = true;

	var _utils = __webpack_require__(4);

	var _exception = __webpack_require__(5);

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
/* 12 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var _interopRequireDefault = __webpack_require__(2)['default'];

	exports.__esModule = true;

	var _exception = __webpack_require__(5);

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
/* 13 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	exports.__esModule = true;

	var _utils = __webpack_require__(4);

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
/* 14 */
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
/* 15 */
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
/* 16 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	exports.__esModule = true;

	var _utils = __webpack_require__(4);

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
/* 17 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var _interopRequireDefault = __webpack_require__(2)['default'];

	exports.__esModule = true;
	exports.registerDefaultDecorators = registerDefaultDecorators;

	var _decoratorsInline = __webpack_require__(18);

	var _decoratorsInline2 = _interopRequireDefault(_decoratorsInline);

	function registerDefaultDecorators(instance) {
	  _decoratorsInline2['default'](instance);
	}

/***/ },
/* 18 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	exports.__esModule = true;

	var _utils = __webpack_require__(4);

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
/* 19 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	exports.__esModule = true;

	var _utils = __webpack_require__(4);

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
/* 20 */
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
/* 21 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var _interopRequireWildcard = __webpack_require__(1)['default'];

	var _interopRequireDefault = __webpack_require__(2)['default'];

	exports.__esModule = true;
	exports.checkRevision = checkRevision;
	exports.template = template;
	exports.wrapProgram = wrapProgram;
	exports.resolvePartial = resolvePartial;
	exports.invokePartial = invokePartial;
	exports.noop = noop;

	var _utils = __webpack_require__(4);

	var Utils = _interopRequireWildcard(_utils);

	var _exception = __webpack_require__(5);

	var _exception2 = _interopRequireDefault(_exception);

	var _base = __webpack_require__(3);

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
/* 22 */
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