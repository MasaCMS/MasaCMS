//https://github.com/timruffles/ios-html5-drag-drop-shim
(function(doc) {

  log = noop; // noOp, remove this line to enable debugging

  var coordinateSystemForElementFromPoint;

  function main(config) {
    config = config || {};

    coordinateSystemForElementFromPoint = navigator.userAgent.match(/OS [1-4](?:_\d+)+ like Mac/) ? "page" : "client";

    var div = doc.createElement('div');
    var dragDiv = 'draggable' in div;
    var evts = 'ondragstart' in div && 'ondrop' in div;

    var needsPatch = !(dragDiv || evts) || /iPad|iPhone|iPod|Android/.test(navigator.userAgent);
    log((needsPatch ? "" : "not ") + "patching html5 drag drop");

    if(!needsPatch) {
        return;
    }

    if(!config.enableEnterLeave) {
      DragDrop.prototype.synthesizeEnterLeave = noop;
    }

    doc.addEventListener("touchstart", touchstart);
  }

  function DragDrop(event, el) {

    this.dragData = {};
    this.dragDataTypes = [];
    this.dragImage = null;
    this.dragImageTransform = null;
    this.dragImageWebKitTransform = null;
    this.el = el || event.target;

    log("dragstart");

    this.dispatchDragStart();
    this.createDragImage();

    this.listen();

  }

  DragDrop.prototype = {
    listen: function() {
      var move = onEvt(doc, "touchmove", this.move, this);
      var end = onEvt(doc, "touchend", ontouchend, this);
      var cancel = onEvt(doc, "touchcancel", cleanup, this);

      function ontouchend(event) {
        this.dragend(event, event.target);
        cleanup.call(this);
      }
      function cleanup() {
        log("cleanup");
        this.dragDataTypes = [];
        if (this.dragImage !== null) {
          this.dragImage.parentNode.removeChild(this.dragImage);
          this.dragImage = null;
          this.dragImageTransform = null;
          this.dragImageWebKitTransform = null;
        }
        this.el = this.dragData = null;
        return [move, end, cancel].forEach(function(handler) {
          return handler.off();
        });
      }
    },
    move: function(event) {
      var pageXs = [], pageYs = [];
      [].forEach.call(event.changedTouches, function(touch) {
        pageXs.push(touch.pageX);
        pageYs.push(touch.pageY);
      });

      var x = average(pageXs) - (parseInt(this.dragImage.offsetWidth, 10) / 2);
      var y = average(pageYs) - (parseInt(this.dragImage.offsetHeight, 10) / 2);
      this.translateDragImage(x, y);

      this.synthesizeEnterLeave(event);
    },
    // We use translate instead of top/left because of sub-pixel rendering and for the hope of better performance
    // http://www.paulirish.com/2012/why-moving-elements-with-translate-is-better-than-posabs-topleft/
    translateDragImage: function(x, y) {
      var translate = " translate(" + x + "px," + y + "px)";

      if (this.dragImageWebKitTransform !== null) {
        this.dragImage.style["-webkit-transform"] = this.dragImageWebKitTransform + translate;
      }
      if (this.dragImageTransform !== null) {
        this.dragImage.style.transform = this.dragImageTransform + translate;
      }
    },
    synthesizeEnterLeave: function(event) {
      var target = elementFromTouchEvent(this.el,event)
      if (target != this.lastEnter) {
        if (this.lastEnter) {
          this.dispatchLeave(event);
        }
        this.lastEnter = target;
        if (this.lastEnter) {
          this.dispatchEnter(event);
        }
      }
      if (this.lastEnter) {
        this.dispatchOver(event);
      }
    },
    dragend: function(event) {

      // we'll dispatch drop if there's a target, then dragEnd.
      // drop comes first http://www.whatwg.org/specs/web-apps/current-work/multipage/dnd.html#drag-and-drop-processing-model
      log("dragend");

      if (this.lastEnter) {
        this.dispatchLeave(event);
      }

      var target = elementFromTouchEvent(this.el,event)
      if (target) {
        log("found drop target " + target.tagName);
        this.dispatchDrop(target, event);
      } else {
        log("no drop target");
      }

      var dragendEvt = doc.createEvent("Event");
      dragendEvt.initEvent("dragend", true, true);
      this.el.dispatchEvent(dragendEvt);
    },
    dispatchDrop: function(target, event) {
      var dropEvt = doc.createEvent("Event");
      dropEvt.initEvent("drop", true, true);

      var touch = event.changedTouches[0];
      var x = touch[coordinateSystemForElementFromPoint + 'X'];
      var y = touch[coordinateSystemForElementFromPoint + 'Y'];
      dropEvt.offsetX = x - target.x;
      dropEvt.offsetY = y - target.y;

      dropEvt.dataTransfer = {
        types: this.dragDataTypes,
        getData: function(type) {
          return this.dragData[type];
        }.bind(this)
      };
      dropEvt.preventDefault = function() {
         // https://www.w3.org/Bugs/Public/show_bug.cgi?id=14638 - if we don't cancel it, we'll snap back
      }.bind(this);

      once(doc, "drop", function() {
        log("drop event not canceled");
      },this);

      target.dispatchEvent(dropEvt);
    },
    dispatchEnter: function(event) {

      var enterEvt = doc.createEvent("Event");
      enterEvt.initEvent("dragenter", true, true);
      enterEvt.dataTransfer = {
        types: this.dragDataTypes,
        getData: function(type) {
          return this.dragData[type];
        }.bind(this)
      };

      var touch = event.changedTouches[0];
      enterEvt.pageX = touch.pageX;
      enterEvt.pageY = touch.pageY;

      this.lastEnter.dispatchEvent(enterEvt);
    },
    dispatchOver: function(event) {

      var overEvt = doc.createEvent("Event");
      overEvt.initEvent("dragover", true, true);
      overEvt.dataTransfer = {
        types: this.dragDataTypes,
        getData: function(type) {
          return this.dragData[type];
        }.bind(this)
      };

      var touch = event.changedTouches[0];
      overEvt.pageX = touch.pageX;
      overEvt.pageY = touch.pageY;

      this.lastEnter.dispatchEvent(overEvt);
    },
    dispatchLeave: function(event) {

      var leaveEvt = doc.createEvent("Event");
      leaveEvt.initEvent("dragleave", true, true);
      leaveEvt.dataTransfer = {
        types: this.dragDataTypes,
        getData: function(type) {
          return this.dragData[type];
        }.bind(this)
      };

      var touch = event.changedTouches[0];
      leaveEvt.pageX = touch.pageX;
      leaveEvt.pageY = touch.pageY;

      this.lastEnter.dispatchEvent(leaveEvt);
      this.lastEnter = null;
    },
    dispatchDragStart: function() {
      var evt = doc.createEvent("Event");
      evt.initEvent("dragstart", true, true);
      evt.dataTransfer = {
        setData: function(type, val) {
          this.dragData[type] = val;
          if (this.dragDataTypes.indexOf(type) == -1) {
            this.dragDataTypes[this.dragDataTypes.length] = type;
          }
          return val;
        }.bind(this),
        dropEffect: "move"
      };
      this.el.dispatchEvent(evt);
    },
    createDragImage: function() {
      this.dragImage = this.el.cloneNode(true);
      
      duplicateStyle(this.el, this.dragImage);
      
      this.dragImage.style.opacity = "0.5";
      this.dragImage.style.position = "absolute";
      this.dragImage.style.left = "0px";
      this.dragImage.style.top = "0px";
      this.dragImage.style.zIndex = "999999";


      var transform = this.dragImage.style.transform;
      if (typeof transform !== "undefined") {
        this.dragImageTransform = "";
        if (transform != "none") {
          this.dragImageTransform = transform.replace(/translate\(\D*\d+[^,]*,\D*\d+[^,]*\)\s*/g, '');
        }
      }

      var webkitTransform = this.dragImage.style["-webkit-transform"];
      if (typeof webkitTransform !== "undefined") {
        this.dragImageWebKitTransform = "";
        if (webkitTransform != "none") {
          this.dragImageWebKitTransform = webkitTransform.replace(/translate\(\D*\d+[^,]*,\D*\d+[^,]*\)\s*/g, '');
        }
      }

      this.translateDragImage(-9999, -9999);

      doc.body.appendChild(this.dragImage);
    }
  };

  // event listeners
  function touchstart(evt) {
    var el = evt.target;
    do {
      if (el.draggable === true) {
        // If draggable isn't explicitly set for anchors, then simulate a click event.
        // Otherwise plain old vanilla links will stop working.
        // https://developer.mozilla.org/en-US/docs/Web/Guide/Events/Touch_events#Handling_clicks
        if (!el.hasAttribute("draggable") && el.tagName.toLowerCase() == "a") {
          var clickEvt = document.createEvent("MouseEvents");
          clickEvt.initMouseEvent("click", true, true, el.ownerDocument.defaultView, 1,
            evt.screenX, evt.screenY, evt.clientX, evt.clientY,
            evt.ctrlKey, evt.altKey, evt.shiftKey, evt.metaKey, 0, null);
          el.dispatchEvent(clickEvt);
          log("Simulating click to anchor");
        }
        evt.preventDefault();
        new DragDrop(evt,el);
      }
    } while((el = el.parentNode) && el !== doc.body);
  }

  // DOM helpers
  function elementFromTouchEvent(el,event) {
    var touch = event.changedTouches[0];
    var target = doc.elementFromPoint(
      touch[coordinateSystemForElementFromPoint + "X"],
      touch[coordinateSystemForElementFromPoint + "Y"]
    );
    return target;
  }

  function onEvt(el, event, handler, context) {
    if(context) {
      handler = handler.bind(context);
    }
    el.addEventListener(event, handler);
    return {
      off: function() {
        return el.removeEventListener(event, handler);
      }
    };
  }

  function once(el, event, handler, context) {
    if(context) {
      handler = handler.bind(context);
    }
    function listener(evt) {
      handler(evt);
      return el.removeEventListener(event,listener);
    }
    return el.addEventListener(event,listener);
  }

  // duplicateStyle expects dstNode to be a clone of srcNode
  function duplicateStyle(srcNode, dstNode) {
    // Is this node an element?
    if (srcNode.nodeType == 1) {
      // Remove any potential conflict attributes
      dstNode.removeAttribute("id");
      dstNode.removeAttribute("class");
      dstNode.removeAttribute("style");
      dstNode.removeAttribute("draggable");

      // Clone the style
      var cs = window.getComputedStyle(srcNode);
      for (var i = 0; i < cs.length; i++) {
        var csName = cs[i];
        dstNode.style.setProperty(csName, cs.getPropertyValue(csName), cs.getPropertyPriority(csName));
      }

      // Pointer events as none makes the drag image transparent to document.elementFromPoint()
      dstNode.style.pointerEvents = "none";
    }

    // Do the same for the children
    if (srcNode.hasChildNodes()) {
      for (var j = 0; j < srcNode.childNodes.length; j++) {
        duplicateStyle(srcNode.childNodes[j], dstNode.childNodes[j]);
      }
    }
  }

  // general helpers
  function log(msg) {
    console.log(msg);
  }

  function average(arr) {
    if (arr.length === 0) return 0;
    return arr.reduce((function(s, v) {
      return v + s;
    }), 0) / arr.length;
  }

  function noop() {}

  main(window.iosDragDropShim);


})(document);


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
    /**
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

    /**
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

    /**
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
      'catch': function(onRejection) {
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

;(function(window){

	function login(username,password,siteid){
		siteid=siteid || window.mura.siteid;

		return new Promise(function(resolve,reject) {
			window.mura.ajax({
					async:true,
					type:'post',
					url:window.mura.apiEndpoint,
					data:{
						siteid:siteid,
						username:username,
						password:password,
						method:'login'
					},
					success:function(resp){
						resolve(resp.data);
					}
			});
		});

	}


	function logout(siteid){
		siteid=siteid || window.mura.siteid;

		return new Promise(function(resolve,reject) {
			window.mura.ajax({
					async:true,
					type:'post',
					url:window.mura.apiEndpoint,
					data:{
						siteid:siteid,
						method:'logout'
					},
					success:function(resp){
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

	function renderFilename(filename,params){

		var query = [];
		params = params || {};
		params.filename= params.filename || '';
		params.siteid= params.siteid || window.mura.siteid;

	    for (var key in params) {
	    	if(key != 'entityname' && key != 'filename' && key != 'siteid' && key != 'method'){
	        	query.push(encodeURIComponent(key) + '=' + encodeURIComponent(params[key]));
	    	}
	    }

		return new Promise(function(resolve,reject) {
			window.mura.ajax({
					async:true,
					type:'get',
					url:window.mura.apiEndpoint + params.siteid + '/content/_path/' + filename + '?' + query.join('&'),
					success:function(resp){
						if(typeof resolve == 'function'){
							var item=new window.mura.Entity();
							item.set(resp.data);
							resolve(item);
						}
					}
			});
		});

	}
	function getEntity(entityname,siteid){
		if(typeof entityname == 'string'){
			var properties={entityname:entityname};
			properties.siteid = siteid || window.mura.siteid;
		} else {
			properties=entityname;
			properties.entityname=properties.entityname || 'content';
			properties.siteid=properties.siteid || window.mura.siteid;
		}
		return new window.mura.Entity(properties);
	}

	function findQuery(params){

		params=params || {};
		params.entityname=params.entityname || 'content';
		params.siteid=params.siteid || mura.siteid;
		params.method=params.method || 'findQuery';

		return new Promise(function(resolve,reject) {

			window.mura.ajax({
					type:'get',
					url:window.mura.apiEndpoint,
					data:params,
					success:function(resp){
							var collection=new window.mura.EntityCollection(resp.data)

							if(typeof resolve == 'function'){
								resolve(collection);
							}
						}
			});
		});
	}

	function evalScripts(el) {
	    if(typeof el=='string'){
	    	el=parseHTML(el);
	    }

	    var scripts = [];
	    var ret = el.childNodes;

	    for ( var i = 0; ret[i]; i++ ) {
	      if ( scripts && nodeName( ret[i], "script" ) && (!ret[i].type || ret[i].type.toLowerCase() === "text/javascript") ) {
	            scripts.push( ret[i].parentNode ? ret[i].parentNode.removeChild( ret[i] ) : ret[i] );
	        } else if(ret[i].nodeType==1 || ret[i].nodeType==9 || ret[i].nodeType==11){
	        	evalScripts(ret[i]);
	        }
	    }

	    for(script in scripts){
	      evalScript(scripts[script]);
	    }
	}

	function nodeName( el, name ) {
	    return el.nodeName && el.nodeName.toUpperCase() === name.toUpperCase();
	}

  	function evalScript(el) {
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

	function changeElementType(el, to) {
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

	function ready(fn) {
	    if(document.readyState != 'loading'){
	      //IE set the readyState to interative too early
	      setTimeout(fn,1);
	    } else {
	      document.addEventListener('DOMContentLoaded',function(){
	        fn();
	      });
	    }
	  }

	function get(url,data){
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

	function post(url,data){
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

	function ajax(params){

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

		if(params.crossDomain){
			if (!("withCredentials" in request)
				&& typeof XDomainRequest != "undefined") {
			    // Check if the XMLHttpRequest object has a "withCredentials" property.
			    // "withCredentials" only exists on XMLHTTPRequest2 objects.
			    // Otherwise, check if XDomainRequest.
			    // XDomainRequest only exists in IE, and is IE's way of making CORS requests.
			    request =new XDomainRequest();
			}

			request.withCredentials=true;
		}

		request.onload = function() {
		  	//IE9 doesn't appear to return the request status
     		if(typeof request.status == 'undefined' || (request.status >= 200 && request.status < 400)) {

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

	function each(selector,fn){
		select(selector).each(fn);
	}

	function on(el,eventName,fn){
		if(eventName=='ready'){
			mura.ready(fn);
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

	function trigger(el, eventName, eventDetail) {
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

      	var bubbles=eventName == "change" ? false : true;

      	if(eventClass=='Custom'){
	    	var event = document.createEvent('CustomEvent');
	    	event.initCustomEvent(eventName, true, true);

	    } else {
	    	var event = document.createEvent(eventClass);
	    	event.initEvent(eventName, bubbles, true);
	    	event.synthetic = true;
	    }
  	};

	function off(el,eventName,fn){
		el.removeEventListener(eventName,fn);
	}

	function parseSelection(selector){
		if(typeof selector == 'object' && Array.isArray(selector)){
			var selection=selector;
		} else if(typeof selector== 'string'){
			var selection=nodeListToArray(document.querySelectorAll(selector));
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

	function isEmptyObject(obj){
		return (typeof obj != 'object' || Object.keys(obj).length == 0);
	}

	function filter(selector,fn){
		return select(parseSelection(selector)).filter(fn);
	}

	function nodeListToArray(nodeList){
		var arr = [];
		for(var i = nodeList.length; i--; arr.unshift(nodeList[i]));
		return arr;
	}

	function select(selector){
		return new window.mura.DOMSelection(parseSelection(selector),selector);
	}

	function parseHTML(str) {
	  var tmp = document.implementation.createHTMLDocument();
	  tmp.body.innerHTML = str;
	  return tmp.body.children;
	};

	function getData(el){
		var data = {};
		Array.prototype.forEach.call(el.attributes, function(attr) {
		    if (/^data-/.test(attr.name)) {
		        data[attr.name.substr(5)] = parseString(attr.value);
		    }
		});

		return data;
	}

	function getProps(el){
		var data = {};
		Array.prototype.forEach.call(el.attributes, function(attr) {
		    if (/^data-/.test(attr.name)) {
		        data[attr.name.substr(5)] = parseString(attr.value);
		    }
		});

		return data;
	}

	function parseString(val){
		if(typeof val == 'string'){
			var lcaseVal=val.toLowerCase();

			if(lcaseVal=='false'){
				return false;
			} else if (lcaseVal=='true'){
				return true;
			} else {
				if(val.length != 35){
					var numVal=parseFloat(val);
					if(numVal==0 || !isNaN(1/numVal)){
						return numVal;
					}
				}

				try {
			        var jsonVal=JSON.parse(val);
			        return jsonVal;
			    } catch (e) {
			        return val;
			    }

			}
		} else {
			return val;
		}

	}

	function getAttributes(el){
		var data = {};
		Array.prototype.forEach.call(el.attributes, function(attr) {
		       data[attr.name] = attr.value;
		});

		return data;
	}

	function formToObject(form) {
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
	function extend(out) {
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

	function deepExtend(out) {
		out = out || {};

		for (var i = 1; i < arguments.length; i++) {
		    var obj = arguments[i];

		    if (!obj)
	      	continue;

		    for (var key in obj) {

		        if (obj.hasOwnProperty(key)) {
		        	if(Array.isArray(obj[key])){
		       			out[key]=obj[key].slice(0);
			        } else if (typeof obj[key] === 'object') {
			          	out[key]=deepExtend({}, obj[key]);
			        } else {
			          	out[key] = obj[key];
			        }
		      	}
		    }
		}

	  	return out;
	}

	function createCookie(name,value,days) {
		if (days) {
			var date = new Date();
			date.setTime(date.getTime()+(days*24*60*60*1000));
			var expires = "; expires="+date.toGMTString();
		}
		else var expires = "";
		document.cookie = name+"="+value+expires+"; path=/";
	}

	function readCookie(name) {
		var nameEQ = name + "=";
		var ca = document.cookie.split(';');
		for(var i=0;i < ca.length;i++) {
			var c = ca[i];
			while (c.charAt(0)==' ') c = c.substring(1,c.length);
			if (c.indexOf(nameEQ) == 0) return unescape(c.substring(nameEQ.length,c.length));
		}
		return "";
	}

	function eraseCookie(name) {
		createCookie(name,"",-1);
	}

	function $escape(value){
		return escape(value).replace(
       	 	new RegExp( "\\+", "g" ),
        	"%2B"
        );
	}

	function $unescape(value){
		return unescape(value);
	}

	//deprecated
	function addLoadEvent(func) {
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

	function noSpam(user,domain) {
		locationstring = "mailto:" + user + "@" + domain;
		window.location = locationstring;
	}

	function createUUID() {
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

	function setHTMLEditor(el) {

		function initEditor(){
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

		function htmlEditorOnComplete( editorInstance ) {
			//var instance=jQuery(editorInstance).ckeditorGet();
			//instance.resetDirty();
			editorInstance.resetDirty();
			var totalIntances=window.CKEDITOR.instances;
			//CKFinder.setupCKEditor( instance, { basePath : context + '/requirements/ckfinder/', rememberLastFolder : false } ) ;
		}

		function getHTMLEditorConfig(customConfig) {
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

	function isInteger(s){
		var i;
			for (i = 0; i < s.length; i++){
					// Check that current character is number.
					var c = s.charAt(i);
					if (((c < "0") || (c > "9"))) return false;
			}
			// All characters are numbers.
			return true;
	}

	function createDate(str){

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

	function dateToString(date){
		var mon   = date.getMonth()+1;
		var dt  = date.getDate();
		var yr   = date.getFullYear();

		if(mon < 10){ mon="0" + mon;}
		if(dt < 10){ dt="0" + dt;}


		return mon + "/" + dt + "/20" + new String(yr).substring(2,4);
	}


	function stripCharsInBag(s, bag){
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

	function daysInFebruary(year){
		// February has 29 days in any year evenly divisible by four,
			// EXCEPT for centurial years which are not also divisible by 400.
			return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
	}

	function DaysArray(n) {
		for (var i = 1; i <= n; i++) {
			this[i] = 31
			if (i==4 || i==6 || i==9 || i==11) {this[i] = 30}
			if (i==2) {this[i] = 29}
		 }
		 return this
	}

	function isDate(dtStr,fldName){
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

	function isEmail(cur){
		var string1=cur
		if (string1.indexOf("@") == -1 || string1.indexOf(".") == -1){
			return false;
		}else{
			return true;
		}
	}

	function initShadowBox(el){
	    if(mura(el).find('[data-rel^="shadowbox"],[rel^="shadowbox"]').length){
	      loader().load(
	        [
	          mura.assetpath +'/css/shadowbox.min.css',
	          mura.assetpath +'/js/external/shadowbox/shadowbox.min.js',
	          mura.assetpath +'/js/external/shadowbox/shadowbox-jquery.min.js'
	        ],
	        function(){
	            window.Shadowbox.init();
	        }
	      );
	  	}
	}

	function validateForm(frm,customaction) {

		function getValidationFieldName(theField){
			if(theField.getAttribute('data-label')!=undefined){
				return theField.getAttribute('data-label');
			}else if(theField.getAttribute('label')!=undefined){
				return theField.getAttribute('label');
			}else{
				return theField.getAttribute('name');
			}
		}

		function getValidationIsRequired(theField){
			if(theField.getAttribute('data-required')!=undefined){
				return (theField.getAttribute('data-required').toLowerCase() =='true');
			}else if(theField.getAttribute('required')!=undefined){
				return (theField.getAttribute('required').toLowerCase() =='true');
			}else{
				return false;
			}
		}

		function getValidationMessage(theField, defaultMessage){
			if(theField.getAttribute('data-message') != undefined){
				return theField.getAttribute('data-message');
			} else if(theField.getAttribute('message') != undefined){
				return theField.getAttribute('message') ;
			} else {
				return getValidationFieldName(theField).toUpperCase() + defaultMessage;
			}
		}

		function getValidationType(theField){
			if(theField.getAttribute('data-validate')!=undefined){
				return theField.getAttribute('data-validate').toUpperCase();
			}else if(theField.getAttribute('validate')!=undefined){
				return theField.getAttribute('validate').toUpperCase();
			}else{
				return '';
			}
		}

		function hasValidationMatchField(theField){
			if(theField.getAttribute('data-matchfield')!=undefined && theField.getAttribute('data-matchfield') != ''){
				return true;
			}else if(theField.getAttribute('matchfield')!=undefined && theField.getAttribute('matchfield') != ''){
				return true;
			}else{
				return false;
			}
		}

		function getValidationMatchField(theField){
			if(theField.getAttribute('data-matchfield')!=undefined){
				return theField.getAttribute('data-matchfield');
			}else if(theField.getAttribute('matchfield')!=undefined){
				return theField.getAttribute('matchfield');
			}else{
				return '';
			}
		}

		function hasValidationRegex(theField){
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

		function getValidationRegex(theField){
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
			//console.log(data);
			//console.log(validations);
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
								document.createElement('form').submit.call(theForm);
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

	function setLowerCaseKeys(obj) {
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

	function isScrolledIntoView(el) {
		if(!window || window.innerHeight){
			true;
		}
	    var elemTop = el.getBoundingClientRect().top;
	    var elemBottom = el.getBoundingClientRect().bottom;

	    var isVisible = elemTop < window.innerHeight && elemBottom >= 0;
	    return isVisible;
	}

	function loader(){return window.mura.ljs;}

	var layoutmanagertoolbar='<div class="frontEndToolsModal mura"><i class="icon-pencil"></i>&nbsp;</div>';

	function processMarkup(scope){

		if(!(scope instanceof window.mura.DOMSelection)){
			scope=select(scope);
		}

		var self=scope;

		function find(selector){
			return scope.find(selector);
		}

		var processors=[

			function(){
				find('.mura-object[data-async="true"], .mura-object[data-render="client"], .mura-async-object').each(function(){
					processObject(this,true);
				});
			},

			function(){
				find(".htmlEditor").each(function(){
					setHTMLEditor(this);
				});
			},

			function(){
				if(find(".cffp_applied  .cffp_mm .cffp_kp").length){
					var fileref=document.createElement('script')
				        fileref.setAttribute("type","text/javascript")
				        fileref.setAttribute("src", window.mura.requirementspath + '/cfformprotect/js/cffp.js')

					document.getElementsByTagName("head")[0].appendChild(fileref)
				}
			},

			function(){
				if(find(".g-recaptcha" ).length){
					var fileref=document.createElement('script')
				        fileref.setAttribute("type","text/javascript")
				        fileref.setAttribute("src", "https://www.google.com/recaptcha/api.js?onload=checkForReCaptcha&render=explicit")

					document.getElementsByTagName("head")[0].appendChild(fileref)

				}

				if(find(".g-recaptcha-container" ).length){
					loader().loadjs(
						"https://www.google.com/recaptcha/api.js?onload=checkForReCaptcha&render=explicit",
						function(){
							find(".g-recaptcha-container" ).each(function(el){
								var self=el;
								var checkForReCaptcha=function()
									{
									   if (typeof grecaptcha == 'object' )
									   {
									   	//console.log(self)
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

					find(".editableObject").each(function(){
						resizeEditableObject(this);
					});

				}
			},

			function(){

				if(typeof openFrontEndToolsModal == 'function' ){
					find(".frontEndToolsModal").on(
						'click',
						function(event){
							event.preventDefault();
							openFrontEndToolsModal(this);
						}
					);
				}


				if(window.muraInlineEditor && window.muraInlineEditor.checkforImageCroppers){
					find("img").each(function(){
						 window.muraInlineEditor.checkforImageCroppers(this);
					});

				}

			},

			function(){
				initShadowBox(scope.node);
			},

			function(){
				if(typeof urlparams.muraadminpreview != 'undefined'){
					find("a").each(function() {
						var h=this.getAttribute('href');
						if(typeof h =='string' && h.indexOf('muraadminpreview')==-1){
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

	function addEventHandler(eventName,fn){
		if(typeof eventName == 'object'){
			for(var h in eventName){
				on(document,h,eventName[h]);
			}
		} else {
			on(document,eventName,fn);
		}
	}


	function submitForm(frm,obj){
		frm=(frm.node) ? frm.node : frm;

	    if(obj){
	      obj=(obj.node) ? obj : mura(obj);
	    } else {
	      obj=mura(frm).closest('.mura-async-object');
	    }

		if(!obj.length){
			frm.submit();
		}

		if(typeof FormData != 'undefined' && frm.getAttribute('enctype')=='multipart/form-data'){

				var data=new FormData(frm);
				var checkdata=setLowerCaseKeys(formToObject(frm));
				var keys=deepExtend(setLowerCaseKeys(obj.data()),urlparams,{siteid:window.mura.siteid,contentid:window.mura.contentid,contenthistid:window.mura.contenthistid,nocache:1});

				for(var k in keys){
					if(!(k in checkdata)){
						data.append(k,keys[k]);
					}
				}

				if('objectparams' in checkdata){
					data.append('objectparams2', $escape(JSON.stringify(obj.data('objectparams'))));
				}

				if('nocache' in checkdata){
					data.append('nocache',1);
				}

				if(data.object=='container' && data.content){
					delete data.content;
				}

				var postconfig={
							url:  window.mura.apiEndpoint + '?method=processAsyncObject',
							type: 'POST',
							data: data,
							success:function(resp){handleResponse(obj,resp);}
						}

			} else {
				var data=deepExtend(setLowerCaseKeys(obj.data()),urlparams,setLowerCaseKeys(formToObject(frm)),{siteid:window.mura.siteid,contentid:window.mura.contentid,contenthistid:window.mura.contenthistid,nocache:1});

				if(data.object=='container' && data.content){
					delete data.content;
				}

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
							success:function(resp){handleResponse(obj,resp);}
						}
			}

			var self=obj.node;
			self.prevInnerHTML=self.innerHTML;
			self.prevData=obj.data();
			self.innerHTML=window.mura.preloaderMarkup;

			ajax(postconfig);
	}

	function resetAsyncObject(el){
		var self=mura(el);

		self.removeClass('active');
		self.removeAttr('data-perm');

		if(self.data('object')=='container'){
			self.find('.mura-object:not([data-object="container"])').html('');
			self.find('.frontEndToolsModal').remove();

			self.find('.mura-object').each(function(){
				var self=mura(this);
				self.removeClass('active');
				self.removeAttr('data-perm');
				self.removeAttr('data-inited');
			});

			self.find('.mura-object[data-object="container"]').each(function(){
				var self=mura(this);
				var content=self.children('div.mura-object-content');

				if(content.length){
					self.data('content',content.html());
				}

				content.html('');
			});

			self.find('.mura-object-meta').html('');
			var content=self.children('div.mura-object-content');

			if(content.length){
				self.data('content',content.html());
			}
		}

		self.html('');
	}

	function processAsyncObject(el){
		obj=mura(el);
		if(obj.data('async')===null){
			obj.data('async',true);
		}
		return processObject(obj);
	}

	function wireUpObject(obj,response){

		function validateFormAjax(frm) {
			validateForm(frm,
				function(frm){
					submitForm(frm,obj);
				}
			);

			return false;

		}

		obj=(obj.node) ? obj : mura(obj);
		var self=obj.node;

		if(obj.data('class')){
			var classes=obj.data('class');

			if(typeof classes != 'array'){
				var classes=classes.split(' ');
			}

			for(var c in classes){
				if(!obj.hasClass(classes[c])){
					obj.addClass(classes[c]);
				}
			}
		}

		obj.data('inited',true);

		if(obj.data('cssclass')){
			var classes=obj.data('cssclass');

			if(typeof classes != 'array'){
				var classes=classes.split(' ');
			}

			for(var c in classes){
				if(!obj.hasClass(classes[c])){
					obj.addClass(classes[c]);
				}
			}
		}

		if(response){
			if(typeof response == 'string'){
				obj.html(trim(response));
			} else if (typeof response.html =='string' && obj.data('render') != 'client'){
				obj.html(trim(response.html));
			} else {
				if(obj.data('object')=='container'){
					obj.prepend(mura.templates.meta(response));
				} else {
					var template=obj.data('clienttemplate') || obj.data('object');

					if(typeof mura.templates[template] == 'function'){
						var context=obj.data();
						context.html=mura.templates[template](obj.data());
						obj.html(mura.templates.content(context));
						obj.prepend(mura.templates.meta(context));
					} else {
						console.log('Missing Client Template for:');
						console.log(obj.data());
					}
				}
			}
		} else {
			if(obj.data('object')=='container'){
				obj.prepend(mura.templates.meta(obj.data()));
			} else {
				var template=obj.data('clienttemplate') || obj.data('object');

				if(typeof mura.templates[template] == 'function'){
					var context=obj.data();
					context.html=mura.templates[template](obj.data());
					obj.html(mura.templates.content(context));
					obj.prepend(mura.templates.meta(context));
				} else {
					console.log('Missing Client Template for:');
					console.log(obj.data());
				}
			}
		}

		if(mura.layoutmanager && mura.editing){
			if(obj.data('object')=='folder' || obj.data('object')=='gallery' || obj.data('object')=='calendar'){
				obj.prepend(layoutmanagertoolbar);
				muraInlineEditor.setAnchorSaveChecks(obj.node);

				obj
				.addClass('active')
				.hover(
					function(e){
						//e.stopPropagation();
						mura('.mura-active-target').removeClass('mura-active-target');
						mura(this).addClass('mura-active-target');
					},
					function(e){
						//e.stopPropagation();
						mura(this).removeClass('mura-active-target');
					}
				);
			} else {
				if(mura.type == 'Variation'){
					var objectData=obj.data();
					if(window.muraInlineEditor && (window.muraInlineEditor.objectHasConfigurator(objectData) || window.muraInlineEditor.objectHasEditor(objectData))){
						obj.prepend(layoutmanagertoolbar);
						muraInlineEditor.setAnchorSaveChecks(obj.node);

						obj
							.addClass('active')
							.hover(
								function(e){
									//e.stopPropagation();
									mura('.mura-active-target').removeClass('mura-active-target');
									mura(this).addClass('mura-active-target');
								},
								function(e){
									//e.stopPropagation();
									mura(this).removeClass('mura-active-target');
								}
							);
					}
				} else {
					var region=mura(self).closest(".mura-region-local");
					if(region && region.length ){
						if(region.data('perm')){
							var objectData=obj.data();

							if(window.muraInlineEditor && (window.muraInlineEditor.objectHasConfigurator(objectData) || window.muraInlineEditor.objectHasEditor(objectData))){
								obj.prepend(layoutmanagertoolbar);
								muraInlineEditor.setAnchorSaveChecks(obj.node);

								obj
									.addClass('active')
									.hover(
										function(e){
											//e.stopPropagation();
											mura('.mura-active-target').removeClass('mura-active-target');
											mura(this).addClass('mura-active-target');
										},
										function(e){
											//e.stopPropagation();
											mura(this).removeClass('mura-active-target');
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

		obj.find('a[href="javascript:history.back();"]').each(function(){
			mura(this).off("click").on("click",function(e){
				if(self.prevInnerHTML){
					e.preventDefault();
					wireUpObject(obj,self.prevInnerHTML);

					if(self.prevData){
				 		for(var p in self.prevData){
				 			select('[name="' + p + '"]').val(self.prevData[p]);
				 		}
				 	}
					self.prevInnerHTML=false;
					self.prevData=false;
				}
			});
		});

		each(self.getElementsByTagName('FORM'),function(el,i){
			el.onsubmit=function(){return validateFormAjax(this);};
		});

		if(obj.data('nextnid')){
			obj.find('.mura-next-n a').each(function(){
				mura(this).on('click',function(e){
					e.preventDefault();
					var a=this.getAttribute('href').split('?');
					if(a.length==2){
						window.location.hash=a[1];
					}

				});
			})
		}

		obj.trigger('asyncObjectRendered');

	}

	function handleResponse(obj,resp){

		obj=(obj.node) ? obj : mura(obj);

		if(resp.data.redirect){
			location.href=resp.data.redirect;
		} else if(resp.data.apiEndpoint){
			ajax({
		        type:"POST",
		        xhrFields:{ withCredentials: true },
		        crossDomain:true,
		        url:resp.data.apiEndpoint,
		        data:resp.data,
		        success:function(data){
		        	if(typeof data=='string'){
		        		wireUpObject(obj,data);
		        	} else if (typeof data=='object' && 'html' in data) {
		        		wireUpObject(obj,data.html);
		        	} else if (typeof data=='object' && 'data' in data && 'html' in data.data) {
		        		wireUpObject(obj,data.data.html);
		        	} else {
		        		wireUpObject(obj,data.data);
		        	}
		        }
	   		});
		} else {
			wireUpObject(obj,resp.data);
		}
	}

	function processObject(el,queue){

		var obj=(el.node) ? el : mura(el);
		el =el.node || el;
		var self=el;

		queue=(queue==null) ? false : queue;

		if(queue && !isScrolledIntoView(el)){
			setTimeout(function(){processObject(el,true)},10);
			return;
		}

		return new Promise(function(resolve,reject) {

			if(!self.getAttribute('data-instanceid')){
				self.setAttribute('data-instanceid',createUUID());
			}

			if(obj.data('async')){
				obj.addClass("mura-async-object");
			}

			if(obj.data('object')=='container'){

				obj.html(mura.templates.content(obj.data()));

				obj.find('.mura-object').each(function(){
					this.setAttribute('data-instanceid',createUUID());
				});
				obj.hide().show();

			}

			var data=deepExtend(setLowerCaseKeys(getData(self)),urlparams,{siteid:window.mura.siteid,contentid:window.mura.contentid,contenthistid:window.mura.contenthistid});

			delete data.inited;

			if(obj.data('contentid')){
				data.contentid=self.getAttribute('data-contentid');
			}

			if(obj.data('contenthistid')){
				data.contenthistid=self.getAttribute('data-contenthistid');
			}

			if('objectparams' in data){
				data['objectparams']= $escape(JSON.stringify(data['objectparams']));
			}

			delete data.params;

			if(obj.data('object')=='container'){
				wireUpObject(obj);
				if(typeof resolve == 'function'){
					resolve(obj);
				}
			} else {
				if(!obj.data('async') && obj.data('render')=='client'){
					wireUpObject(obj);
					if(typeof resolve == 'function'){
						resolve(obj);
					}
				} else {
					//console.log(data);
					self.innerHTML=window.mura.preloaderMarkup;
					ajax({
						url:window.mura.apiEndpoint + '?method=processAsyncObject',
						type:'get',
						data:data,
						success:function(resp){
							handleResponse(obj,resp);
							if(typeof resolve == 'function'){
								resolve(obj);
							}
						}
					});
				}

			}
		});

	}

	var hashparams={};
	var urlparams={};

	function handleHashChange(){

		var hash=window.location.hash;

		if(hash){
			hash=hash.substring(1);
		}

		if(hash){
			hashparams=getQueryStringParams(hash);
			if(hashparams.nextnid){
				mura('.mura-async-object[data-nextnid="' + hashparams.nextnid +'"]').each(function(){
					mura(this).data(hashparams);
					processAsyncObject(this);
				});
			} else if(hashparams.objectid){
				mura('.mura-async-object[data-objectid="' + hashparams.objectid +'"]').each(function(){
					mura(this).data(hashparams);
					processAsyncObject(this);
				});
			}
		}
	}

	function trim(str) {
	    return str.replace(/^\s+|\s+$/gm,'');
	}


	function extendClass (baseClass,subClass){
		var placeholder=function(){
			this.init.apply(this,arguments);
		}

		placeholder.prototype = Object.create(baseClass.prototype);
		placeholder.prototype.constructor = placeholder;

		window.mura.extend(placeholder.prototype,subClass);

		return placeholder;
	}

	function getQueryStringParams(queryString) {
	    var params = {};
	    var e,
	        a = /\+/g,  // Regex for replacing addition symbol with a space
	        r = /([^&;=]+)=?([^&;]*)/g,
	        d = function (s) { return decodeURIComponent(s.replace(a, " ")); };

	        if(queryString.substring(0,1)=='?'){
	        	var q=queryString.substring(1);
	        } else {
	        	var q=queryString;
	        }


	    while (e = r.exec(q))
	       params[d(e[1]).toLowerCase()] = d(e[2]);

	    return params;
	}

	function getHREFParams(href) {
	    var a=href.split('?');

	    if(a.length==2){
	    	return getQueryStringParams(a[1]);
	    } else {
	    	return {};
	    }
	}

	function inArray(elem, array, i) {
	    var len;
	    if ( array ) {
	        if ( array.indexOf ) {
	            return array.indexOf.call( array, elem, i );
	        }
	        len = array.length;
	        i = i ? i < 0 ? Math.max( 0, len + i ) : i : 0;
	        for ( ; i < len; i++ ) {
	            // Skip accessing in sparse arrays
	            if ( i in array && array[ i ] === elem ) {
	                return i;
	            }
	        }
	    }
	    return -1;
	}

	function getURLParams() {
		return getQueryStringParams(window.location.search);
	}

	function init(config){
		if(!config.context){
			config.context='';
		}

		if(!config.assetpath){
			config.assetpath=config.context;
		}

		if(!config.apiEndpoint){
			config.apiEndpoint=config.context + '/index.cfm/_api/json/v1/';
		}

		if(!config.pluginspath){
			config.pluginspath=config.context + '/plugins';
		}

		if(!config.requirementspath){
			config.requirementspath=config.context + '/requirements';
		}

		if(!config.jslib){
			config.jslib='jquery';
		}

		if(!config.perm){
			config.perm='none';
		}

		if(typeof config.layoutmanager == 'undefined'){
			config.layoutmanager=false;
		}

		if(typeof config.mobileformat == 'undefined'){
			config.mobileformat=false;
		}

		if(typeof config.windowdocumentdomain != 'undefined' && config.windowdocumentdomain != ''){
			window.document.domain=config.windowdocumentdomain;
		}

		mura.editing;

		extend(window.mura,config);

		mura(function(){

			var hash=window.location.hash;

			if(hash){
				hash=hash.substring(1);
			}

			hashparams=setLowerCaseKeys(getQueryStringParams(hash));
			urlparams=setLowerCaseKeys(getQueryStringParams(window.location.search));

			if(hashparams.nextnid){
				mura('.mura-async-object[data-nextnid="' + hashparams.nextnid +'"]').each(function(){
					mura(this).data(hashparams);
				});
			} else if(hashparams.objectid){
				mura('.mura-async-object[data-nextnid="' + hashparams.objectid +'"]').each(function(){
					mura(this).data(hashparams);
				});
			}

			mura(window).on('hashchange',handleHashChange);

			processMarkup(document);

			mura(document)
			.on("keydown", function(event){
				loginCheck(event.which);
			});

			/*
			mura.addEventHandler(
				{
					asyncObjectRendered:function(event){
						alert(this.innerHTML);
					}
				}
			);

			mura('#my-id').addDisplayObject('objectname',{..});

			mura.login('userame','password')
				.then(function(data){
					alert(data.success);
				});

			mura.logout())
				.then(function(data){
					alert('you have logged out!');
				});

			mura.renderFilename('')
				.then(function(item){
					alert(item.get('title'));
				});

			mura.getEntity('content').loadBy('contentid','00000000000000000000000000000000001')
				.then(function(item){
					alert(item.get('title'));
				});

			mura.getEntity('content').loadBy('contentid','00000000000000000000000000000000001')
				.then(function(item){
					item.get('kids').then(function(kids){
						alert(kids.get('items').length);
					});
				});

			mura.getEntity('content').loadBy('contentid','1C2AD93E-E39C-C758-A005942E1399F4D6')
				.then(function(item){
					item.get('parent').then(function(parent){
						alert(parent.get('title'));
					});
				});

			mura.getEntity('content').
				.set('parentid''1C2AD93E-E39C-C758-A005942E1399F4D6')
				.set('approved',1)
				.set('title','test 5')
				.save()
				.then(function(item){
					alert(item.get('title'));
				});

			mura.getEntity('content').
				.set(
					{
						parentid:'1C2AD93E-E39C-C758-A005942E1399F4D6',
						approved:1,
						title:'test 5'
					}
				.save()
				.then(function(item){
					alert(item.get('title'));
				});

			mura.findQuery({
					entityname:'content',
					title:'Home'
				})
				.then(function(collection){
					alert(collection.item(0).get('title'));
				});
			*/

			mura(document).trigger('muraReady');

		});

	    return window.mura
	}

	extend(window,{
		mura:extend(
			function(selector){
				if(typeof selector == 'function'){
					mura.ready(selector);
					return this;
				} else {
					return select(selector);
				}
			},
			{
			rb:{},
			entities:{},
			submitForm:submitForm,
			escapeHTML:escapeHTML,
			unescapeHTML:unescapeHTML,
			processObject:processObject,
			processAsyncObject:processAsyncObject,
			resetAsyncObject:resetAsyncObject,
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
			inArray:inArray,
			post:post,
			get:get,
			deepExtend:deepExtend,
			ajax:ajax,
			changeElementType:changeElementType,
			each:each,
			parseHTML:parseHTML,
			getData:getData,
			getProps:getProps,
			isEmptyObject:isEmptyObject,
			evalScripts:evalScripts,
			validateForm:validateForm,
			escape:$escape,
			unescape:$unescape,
			getBean:getEntity,
			getEntity:getEntity,
			renderFilename:renderFilename,
			findQuery:findQuery,
			login:login,
			logout:logout,
			extendClass:extendClass,
			init:init,
			formToObject:formToObject,
			createUUID:createUUID,
			processMarkup:processMarkup,
			layoutmanagertoolbar:layoutmanagertoolbar,
			parseString:parseString,
			createCookie:createCookie,
			readCookie:readCookie,
			trim:trim
			}
		),
		//these are here for legacy support
		validateForm:validateForm,
		setHTMLEditor:setHTMLEditor,
		createCookie:createCookie,
		readCookie:readCookie,
		addLoadEvent:addLoadEvent,
		noSpam:noSpam,
		initMura:init
	});

	window.m=window.m || window.mura;

	//for some reason this can't be added via extend
	window.validateForm=validateForm;


})(window);
;//https://github.com/malko/l.js
;(function(window){
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
	/** gEval credits goes to my javascript idol John Resig, this is a simplified jQuery.globalEval */
	var gEval = function(js){ ( window.execScript || function(js){ window[ "eval" ].call(window,js);} )(js); }
		, isA =  function(a,b){ return a instanceof (b || Array);}
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

	if( ! window.mura.ljs ){
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
				}
				return this.loadjs(url,cb);
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
				(links[i].rel==='stylesheet' || links[i].type==='text/css') && (loaded[links[i].getAttribute('href').replace(/#.*$/,'')]=true);
			}
		}
		//export ljs
		window.mura.ljs = loader;
		// eval inside tag code if any
	}
	script && gEval(script);
})(window);
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
;(function(window){
	function Core(){
		this.init.apply(this,arguments);
		return this;
	}

	Core.prototype={
		init:function(){
		}
	};

	Core.extend=function(properties){
		var self=this;
		return mura.extend(mura.extendClass(self,properties),{extend:self.extend});
	};

	window.mura.Core=Core;

})(window);
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

;(function(window){
	window.mura.DOMSelection=window.mura.Core.extend({
		init:function(selection,origSelector){
			this.selection=selection;
			this.origSelector=origSelector;

			if(this.selection.length && this.selection[0]){
				this.parentNode=this.selection[0].parentNode;
				this.childNodes=this.selection[0].childNodes;
				this.node=selection[0];
				this.length=this.selection.length;
			} else {
				this.parentNode=null;
				this.childNodes=null;
				this.node=null;
				this.length=0;
			}
		},

		get:function(index){
			return this.selection[index];
		},

		ajax:function(data){
			return window.mura.ajax(data);
		},

		select:function(selector){
			return window.mura(selector);
		},

		each:function(fn){
			this.selection.forEach( function(el,idx,array){
				fn.call(el,el,idx,array);
			});
			return this;
		},

		filter:function(fn){
			return window.mura(this.selection.filter( function(el,idx,array){
				return fn.call(el,el,idx,array);
			}));
		},

		map:function(fn){
			return window.mura(this.selection.map( function(el,idx,array){
				return fn.call(el,el,idx,array);
			}));
		},

		isNumeric:function(val){
			return isNumeric(this.selection[0]);
		},

		on:function(eventName,selector,fn){
			if(typeof selector == 'function'){
				fn=selector;
				selector='';
			}

			if(eventName=='ready'){
				if(document.readyState != 'loading'){
					var self=this;

					setTimeout(
						function(){
							self.each(function(){
								if(selector){
									mura(this).find(selector).each(function(){
										fn.call(this);
									});
								} else {
									fn.call(this);
								}
							});
						},
						1
					);

					return this;

				} else {
					eventName='DOMContentLoaded';
				}
			}

			this.each(function(){
				if(typeof this.addEventListener == 'function'){
					var self=this;
					this.addEventListener(
						eventName,
						function(event){
							if(selector){
								mura(self).find(selector).each(function(){
									fn.call(this,event);
								});
							} else {
								fn.call(self,event);
							}

						},
						true
					);
				}
			});

			return this;
		},

		hover:function(handlerIn,handlerOut){
			this.on('mouseover',handlerIn);
			this.on('mouseout',handlerOut);
			return this;
		},


		click:function(fn){
			this.on('click',fn);
			return this;
		},

		submit:function(fn){
			if(fn){
				this.on('submit',fn);
			} else {
				this.each(function(el){
					if(typeof el.submit == 'function'){
						window.mura.submitForm(el);
					}
				});
			}

			return this;
		},

		ready:function(fn){
			this.on('ready',fn);
			return this;
		},

		off:function(eventName,fn){
			this.each(function(el,idx,array){
				if(typeof eventName != 'undefined'){
					if(typeof fn != 'undefined'){
						el.removeEventListener(eventName,fn);
					} else {
						el[eventName]=null;
					}
				} else {
					var elClone = el.cloneNode(true);
					el.parentNode.replaceChild(elClone, el);
					array[idx]=elClone;

				}

			});
			return this;
		},

		unbind:function(eventName,fn){
			this.off(eventName,fn);
			return this;
		},

		bind:function(eventName,fn){
			this.on(eventName,fn);
			return this;
		},

		trigger:function(eventName,eventDetail){
			eventDetails=eventDetail || {};

			this.each(function(el){
				window.mura.trigger(el,eventName,eventDetail);
			});
			return this;
		},

		parent:function(){
			if(!this.selection.length){
				return;
			}
			return window.mura(this.selection[0].parentNode);
		},

		children:function(selector){
			if(!this.selection.length){
				return;
			}

			if(this.selection[0].hasChildNodes()){
				var children=window.mura(this.selection[0].childNodes);

				if(typeof selector == 'string'){
					var filterFn=function(){return (this.nodeType === 1 || this.nodeType === 11 || this.nodeType === 9) && this.matchesSelector(selector);};
				} else {
					var filterFn=function(){ return this.nodeType === 1 || this.nodeType === 11 || this.nodeType === 9;};
				}

				return children.filter(filterFn);
			} else {
				return window.mura([]);
			}

		},

		find:function(selector){
			if(this.selection.length){
				var removeId=false;

				if(this.selection[0].nodeType=='1' || this.selection[0].nodeType=='11'){
					var result=this.selection[0].querySelectorAll(selector);
				} else if(this.selection[0].nodeType=='9'){
					var result=window.document.querySelectorAll(selector);
				} else {
					var result=[];
				}
				return window.mura(result);
			} else {
				return window.mura([]);
			}
		},

		selector:function() {
			var pathes = [];
			var path, node = window.mura(this.selection[0]);

			while (node.length) {
				var realNode = node.get(0), name = realNode.localName;
				if (!name) { break; }

				if(!node.data('hastempid') && node.attr('id') && node.attr('id') != 'mura-variation-el'){
			   		name='#' + node.attr('id');
					path = name + (path ? ' > ' + path : '');
					break;
				} else {

				    name = name.toLowerCase();
				    var parent = node.parent();
				    var sameTagSiblings = parent.children(name);

				    if (sameTagSiblings.length > 1)
				    {
				        allSiblings = parent.children();
				        var index = allSiblings.index(realNode) +1;

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

		siblings:function(selector){
			if(!this.selection.length){
				return;
			}
			var el=this.selection[0];

			if(el.hasChildNodes()){
				var silbings=window.mura(this.selection[0].childNodes);

				if(typeof selector == 'string'){
					var filterFn=function(){return (this.nodeType === 1 || this.nodeType === 11 || this.nodeType === 9) && this.matchesSelector(selector);};
				} else {
					var filterFn=function(){return this.nodeType === 1 || this.nodeType === 11 || this.nodeType === 9;};
				}

				return silbings.filter(filterFn);
			} else {
				return window.mura([]);
			}
		},

		item:function(idx){
			return this.selection[idx];
		},

		index:function(el){
			return this.selection.indexOf(el);
		},

		closest:function(selector) {
			if(!this.selection.length){
				return null;
			}

		    var el = this.selection[0];

		    for( var parent = el ; parent !== null  && parent.matchesSelector && !parent.matchesSelector(selector) ; parent = el.parentElement ){ el = parent; };

		    if(parent){
		    	 return window.mura(parent)
		    } else {
		    	 return window.mura([]);
		    }

		},

		append:function(el) {
			this.each(function(){
				if(typeof el == 'string'){
					this.insertAdjacentHTML('beforeend', htmlString);
				} else {
					this.appendChild(el);
				}
			});
			return this;
		},

		appendMuraObject:function(data) {
		    var el=createElement('div');
		    el.setAttribute('class','mura-async-object');

			for(var a in data){
				el.setAttribute('data-' + a,data[a]);
			}

			this.append(el);

			window.mura.processAsyncObject(this.node);

			return el;
		},

		prepend:function(el) {
			this.each(function(){
				if(typeof el == 'string'){
					this.insertAdjacentHTML('afterbegin', el);
				} else {
					this.insertBefore(el,this.firstChild);
				}
			});
			return this;
		},

		before:function(el) {
			this.each(function(){
				if(typeof el == 'string'){
					this.insertAdjacentHTML('beforebegin', el);
				} else {
					this.parent.insertBefore(el,this);
				}
			});
			return this;
		},

		after:function(el) {
			this.each(function(){
				if(typeof el == 'string'){
					this.insertAdjacentHTML('afterend', el);
				} else {
					this.parent.insertBefore(el,this.parent.firstChild);
				}
			});
			return this;
		},

		prependMuraObject:function(data) {
		    var el=createElement('div');
		    el.setAttribute('class','mura-async-object');

			for(var a in data){
				el.setAttribute('data-' + a,data[a]);
			}

			this.prepend(el);

			window.mura.processAsyncObject(el);

			return el;
		},

		hide:function(){
			this.each(function(el){
				el.style.display = 'none';
			});
			return this;
		},

		show:function(){
			this.each(function(el){
				el.style.display = '';
			});
			return this;
		},

		remove:function(){
			this.each(function(el){
				el.parentNode.removeChild(el);
			});
			return this;
		},

		addClass:function(className){
			this.each(function(el){
				if (el.classList){
				  el.classList.add(className);
				} else {
				  el.className += ' ' + className;
				}
			});
			return this;
		},

		hasClass:function(className){
			return this.is("." + className);
		},

		removeClass:function(className){
			this.each(function(el){
				if (el.classList){
				  el.classList.remove(className);
				} else if (el.className) {
				  el.className = el.className.replace(new RegExp('(^|\\b)' + className.split(' ').join('|') + '(\\b|$)', 'gi'), ' ');
				}
			});
			return this;
		},

		toggleClass:function(className){
			this.each(function(el){
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

		after:function(el){
			this.each(function(){
				if(type)
				this.insertAdjacentHTML('afterend', el);
			});
			return this;
		},

		before:function(el){
			this.each(function(){
				this.insertAdjacentHTML('beforebegin', el);
			});
			return this;
		},

		empty:function(){
			this.each(function(el){
				el.innerHTML = '';
			});
			return this;
		},

		evalScripts:function(){
			if(!this.selection.length){
				return this;
			}

			this.each(function(el){
				window.mura.evalScripts(el);
			});

			return this;

		},

		html:function(htmlString){
			if(typeof htmlString != 'undefined'){
				this.each(function(el){
					el.innerHTML=htmlString;
					window.mura.evalScripts(el);
				});
				return this;
			} else {
				if(!this.selection.length){
					return '';
				}
				return this.selection[0].innerHTML;
			}
		},

		css:function(ruleName,value){
			if(!this.selection.length){
				return;
			}

			if(typeof rulename == 'undefined' && typeof value == 'undefined'){
				try{
					return window.getComputedStyle(this.selection[0]);
				} catch(e){
					return {};
				}
			} else if (typeof attributeName == 'object'){
				this.each(function(el){
					try{
						for(var p in attributeName){
							el.style[p]=attributeName[p];
						}
					} catch(e){}
				});
			} else if(typeof value != 'undefined'){
				this.each(function(el){
					try{
						el.style[ruleName]=value;
					} catch(e){}
				});
				return this;
			} else{
				try{
					return window.getComputedStyle(this.selection[0])[ruleName];
				} catch(e){}
			}
		},

		text:function(textString){
			if(typeof textString == 'undefined'){
				this.each(function(el){
					el.textContent=textString;
				});
				return this;
			} else {
				return this.selection[0].textContent;
			}
		},

		is:function(selector){
			if(!this.selection.length){
				return false;
			}
			return this.selection[0].matchesSelector && this.selection[0].matchesSelector(selector);
		},

		offsetParent:function(){
			if(!this.selection.length){
				return;
			}
			var el=this.selection[0];
			return el.offsetParent || el;
		},

		outerHeight:function(withMargin){
			if(!this.selection.length){
				return;
			}
			if(typeof withMargin == 'undefined'){
				function outerHeight(el) {
				  var height = el.offsetHeight;
				  var style = window.getComputedStyle(el);

				  height += parseInt(style.marginTop) + parseInt(style.marginBottom);
				  return height;
				}

				return outerHeight(this.selection[0]);
			} else {
				return this.selection[0].offsetHeight;
			}
		},

		height:function(height) {
		 	if(!this.selection.length){
				return;
			}

			if(typeof width != 'undefined'){
				if(!isNaN(height)){
					height += 'px';
				}
				this.css('height',height);
				return this;
			}

			var el=this.selection[0];
			//var type=el.constructor.name.toLowerCase();

			if(el === window){
				return window.innerHeight
			} else if(el === document){
				var body = document.body;
		    	var html = document.documentElement;
				return  Math.max( body.scrollHeight, body.offsetHeight,
		                       html.clientHeight, html.scrollHeight, html.offsetHeight )
			}

			var styles = window.getComputedStyle(el);
			var margin = parseFloat(styles['marginTop']) + parseFloat(styles['marginBottom']);

			return Math.ceil(el.offsetHeight + margin);
		},

		width:function(width) {
		  	if(!this.selection.length){
				return;
			}

			if(typeof width != 'undefined'){
				if(!isNaN(width)){
					width += 'px';
				}
				this.css('width',width);
				return this;
			}

			var el=this.selection[0];
			//var type=el.constructor.name.toLowerCase();

			if(el === window){
				return window.innerWidth
			} else if(el === document){
				var body = document.body;
		    	var html = document.documentElement;
				return  Math.max( body.scrollWidth, body.offsetWidth,
		                       html.clientWidth, html.scrolWidth, html.offsetWidth )
			}

		  	return window.getComputedStyle(el).width;
		},

		offset:function(){
			if(!this.selection.length){
				return;
			}
			var el=this.selection[0];
			var rect = el.getBoundingClientRect()

			return {
			  top: rect.top + document.body.scrollTop,
			  left: rect.left + document.body.scrollLeft
			};
		},

		scrollTop:function() {
		  	return document.body.scrollTop;
		},

		offset:function(attributeName,value){
			if(!this.selection.length){
				return;
			}
			var box = this.selection[0].getBoundingClientRect();
			return {
			  top: box.top  + ( window.pageYOffset || document.scrollTop )  - ( document.clientTop  || 0 ),
			  left: box.left + ( window.pageXOffset || document.scrollLeft ) - ( document.clientLeft || 0 )
			};
		},

		removeAttr:function(attributeName){
			if(!this.selection.length){
				return;
			}

			this.each(function(el){
				if(el && typeof el.removeAttribute == 'function'){
					el.removeAttribute(attributeName);
				}

			});
			return this;

		},

		changeElementType:function(type){
			if(!this.selection.length){
				return;
			}

			this.each(function(el){
				window.mura.changeElementType(el,type)

			});
			return this;

		},

        val:function(value){
			if(!this.selection.length){
				return;
			}

			if(typeof value != 'undefined'){
				this.each(function(el){
					if(el.tagName=='radio'){
						if(el.value==value){
							el.checked=true;
						} else {
							el.checked=false;
						}
					} else {
						el.value=value;
					}

				});
				return this;

			} else {
				if(this.selection[0].hasOwnProperty('value')){
					return this.selection[0].value;
				} else {
					return '';
				}
			}
		},

		attr:function(attributeName,value){
			if(!this.selection.length){
				return;
			}

			if(typeof value == 'undefined' && typeof attributeName == 'undefined'){
				return window.mura.getAttributes(this.selection[0]);
			} else if (typeof attributeName == 'object'){
				this.each(function(el){
					if(el.setAttribute){
						for(var p in attributeName){
							el.setAttribute(p,attributeName[p]);
						}
					}
				});
				return this;
			} else if(typeof value != 'undefined'){
				this.each(function(el){
					if(el.setAttribute){
						el.setAttribute(attributeName,value);
					}
				});
				return this;

			} else {
				if(this.selection[0] && this.selection[0].getAttribute){
					return this.selection[0].getAttribute(attributeName);
				} else {
					return undefined;
				}

			}
		},

		data:function(attributeName,value){
			if(!this.selection.length){
				return;
			}
			if(typeof value == 'undefined' && typeof attributeName == 'undefined'){
				return window.mura.getData(this.selection[0]);
			} else if (typeof attributeName == 'object'){
				this.each(function(el){
					for(var p in attributeName){
						el.setAttribute("data-" + p,attributeName[p]);
					}
				});
				return this;

			} else if(typeof value != 'undefined'){
				this.each(function(el){
					el.setAttribute("data-" + attributeName,value);
				});
				return this;
			} else if (this.selection[0] && this.selection[0].getAttribute) {
				return window.mura.parseString(this.selection[0].getAttribute("data-" + attributeName));
			} else {
				return undefined;
			}
		},

		prop:function(attributeName,value){
			if(!this.selection.length){
				return;
			}
			if(typeof value == 'undefined' && typeof attributeName == 'undefined'){
				return window.mura.getProps(this.selection[0]);
			} else if (typeof attributeName == 'object'){
				this.each(function(el){
					for(var p in attributeName){
						el.setAttribute(p,attributeName[p]);
					}
				});
				return this;

			} else if(typeof value != 'undefined'){
				this.each(function(el){
					el.setAttribute(attributeName,value);
				});
				return this;
			} else {
				return window.mura.parseString(this.selection[0].getAttribute(attributeName));
			}
		},

		fadeOut:function(){
		  	this.each(function(el){
			  el.style.opacity = 1;

			  (function fade() {
			    if ((el.style.opacity -= .1) < 0) {
			      el.style.display = "none";
			    } else {
			      requestAnimationFrame(fade);
			    }
			  })();
			});

			return this;
		},

		fadeIn:function(display){
		  this.each(function(el){
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

		toggle:function(){
		 	this.each(function(el){
				 if(typeof el.style.display == 'undefined' || el.style.display==''){
				 	el.style.display='none';
				 } else {
				 	el.style.display='';
				 }
		  	});
		  	return this;
		}
	});

})(window);
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

;(function(window){
	window.mura.Entity=window.mura.Core.extend({
		init:function(properties){
			properties || {};
			properties.entityname = properties.entityname || 'content';
			properties.siteid = properties.siteid || window.mura.siteid;
			this.set(properties);
		},

		get:function(propertyName,defaultValue){
			if(typeof this.properties.links != 'undefined'
				&& typeof this.properties.links[propertyName] != 'undefined'){
				var self=this;

				if(typeof this.properties[propertyName] != 'undefined'){

					return new Promise(function(resolve,reject) {
						if('items' in self.properties[propertyName]){
							var returnObj = new window.mura.EntityCollection(self.properties[propertyName]);
						} else {
							if(window.mura.entities[self.properties[propertyName].entityname]){
								var returnObj = new window.mura.entities[self.properties[propertyName].entityname](obj.properties[propertyName]);
							} else {
								var returnObj = new window.mura.Entity(self.properties[propertyName]);
							}
						}

						if(typeof resolve == 'function'){
							resolve(returnObj);
						}
					});

				} else {

					return new Promise(function(resolve,reject) {

						window.mura.ajax({
							type:'get',
							url:self.properties.links[propertyName],
							success:function(resp){

								if('items' in resp.data){
									var returnObj = new window.mura.EntityCollection(resp.data);
								} else {
									if(window.mura.entities[obj.entityname]){
										var returnObj = new window.mura.entities[obj.entityname](obj);
									} else {
										var returnObj = new window.mura.Entity(resp.data);
									}
								}

								self.set(propertyName,resp.data);

								if(typeof resolve == 'function'){
									resolve(returnObj);
								}
							},
							error:reject
						});
					});
				}

			} else if(typeof this.properties[propertyName] != 'undefined'){
				return this.properties[propertyName];
			} else if (typeof defaultValue != 'undefined') {
				this.properties[propertyName]=defaultValue;
				return this.properties[propertyName];

			} else {
				return '';
			}
		},

		set:function(propertyName,propertyValue){

			if(typeof propertyName == 'object'){
				this.properties=window.mura.deepExtend(this.properties,propertyName);
			} else {
				this.properties[propertyName]=propertyValue;
			}

			return this;

		},

		has:function(propertyName){
			return typeof this.properties[propertyName] != 'undefined' || (typeof this.properties.links != 'undefined' && typeof this.properties.links[propertyName] != 'undefined');
		},

		getAll:function(){
			return this.properties;
		},

		load:function(){
			return this.loadBy('id',this.get('id'));
		},

		loadBy:function(propertyName,propertyValue){

			propertyName=propertyName || 'id';
			propertyValue=propertyValue || this.get(propertyName);

			var self=this;

			return new Promise(function(resolve,reject){
				var params={
					entityname:self.get('entityname'),
					method:'findQuery',
					siteid:self.get('siteid')};

					params[propertyName]=propertyValue;

					window.mura.findQuery(params).then(function(collection){

					if(collection.get('items').length){
						self.set(collection.get('items')[0].getAll());
					}
					if(typeof resolve == 'function'){
						resolve(self);
					}
				});
			});
		},

		validate:function(){

			var self=this;

			return new Promise(function(resolve,reject) {

				window.mura.ajax({
					type: 'post',
					url: window.mura.apiEndpoint + '?method=validate',
					data: {
							data: window.mura.escape(JSON.stringify(self.getAll())),
							validations: '{}',
							version: 4
						},
					success:function(resp){
						if(resp.data != 'undefined'){
								self.set('errors',resp.data)
						} else {
							self.set('errors',resp.error);
						}

						if(typeof resolve == 'function'){
							resolve(self);
						}
					}
				});
			});

		},
		hasErrors:function(){
			var errors=this.get('errors',{});
			return (typeof errors=='string' && errors !='') || (typeof errors=='object' && !window.mura.isEmptyObject(errors));
		},
		getErrors:function(){
			return this.get('errors',{});
		},
		save:function(){
			var self=this;

			if(!this.get('id')){
				return new Promise(function(resolve,reject) {
					var temp=window.mura.deepExtend({},self.getAll());

					window.mura.ajax({
						type:'get',
						url:window.mura.apiEndpoint + self.get('siteid') + '/' + self.get('entityname') + '/new' ,
						success:function(resp){
							self.set(resp.data);
							self.set(temp);
							self.set('id',resp.data.id)
							self.save().then(resolve,reject);
						}
					});
				});

			} else {
				return new Promise(function(resolve,reject) {

					if(self.get('entityname') == 'content'){
						var context=self.get('contentid');
					} else {
						var context=self.get('id');
					}

					window.mura.ajax({
						type:'post',
						url:window.mura.apiEndpoint + '?method=generateCSRFTokens',
						data:{
							siteid:self.get('siteid'),
							context:context
						},
						success:function(resp){
							window.mura.ajax({
									type:'post',
									url:window.mura.apiEndpoint + '?method=save',
									data:window.mura.extend(self.getAll(),{'csrf_token':resp.data.csrf_token,'csrf_token_expires':resp.data.csrf_token_expires}),
									success:function(resp){
										if(resp.data != 'undefined'){
											self.set(resp.data)

											if(self.get('saveErrors') || window.mura.isEmptyObject(self.getErrors())){
												if(typeof resolve == 'function'){
													resolve(self);
												}
											} else {
												if(typeof reject == 'function'){
													reject(self);
												}
											}

										} else {
											self.set('errors',resp.error);
											if(typeof reject == 'function'){
												reject(self);
											}
										}
									}
							});
						}
					});

				});

			}

		},

		delete:function(){

			var self=this;

			return new Promise(function(resolve,reject) {
				window.mura.ajax({
					type:'get',
					url:window.mura.apiEndpoint + '?method=generateCSRFTokens',
					data:{
						siteid:self.get('siteid'),
						context:self.get('id')
					},
					success:function(resp){
						window.mura.ajax({
							type:'get',
							url:window.mura.apiEndpoint + '?method=delete',
							data:{
								siteid:self.get('siteid'),
								id:self.get('id'),
								entityname:self.get('entityname'),
								'csrf_token':resp.data.csrf_token,
								'csrf_token_expires':resp.data.csrf_token_expires
							},
							success:function(){
								if(typeof resolve == 'function'){
									resolve(self);
								}
							}
						});
					}
				});
			});

		}

	});

})(window);
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

;(function(window){
	window.mura.EntityCollection=window.mura.Entity.extend({
		init:function(properties){
			properties=properties || {};
			this.set(properties);

			var self=this;

			if(Array.isArray(self.get('items'))){
				self.set('items',self.get('items').map(function(obj){
					if(window.mura.entities[obj.entityname]){
						return new window.mura.entities[obj.entityname](obj);
					} else {
						return new window.mura.Entity(obj);
					}
				}));
			}

			return this;
		},

		item:function(idx){
			return this.properties.items[idx];
		},

		index:function(item){
			return this.properties.items.indexOf(item);
		},

		getAll:function(){
			var self=this;

			return mura.extend(
				{},
				self.properties,
				{
					items:self.map(function(obj){
						return obj.getAll();
					})
				}
			);

		},

		each:function(fn){
			this.properties.items.forEach( function(item,idx){
				fn.call(item,item,idx);
			});
			return this;
		},

		sort:function(fn){
			this.properties.items.sort(fn);
		},

		filter:function(fn){
			var collection=new window.mura.EntityCollection(this.properties);
			return collection.set('items',collection.get('items').filter( function(item,idx){
				return fn.call(item,item,idx);
			}));
		},

		map:function(fn){
			var collection=new window.mura.EntityCollection(this.properties);
			return collection.set('items',collection.get('items').map( function(item,idx){
				return fn.call(item,item,idx);
			}));
		}
	});
})(window);
;mura.templates={};
mura.templates['meta']=function(context){

	if(context.label){
		return '<div class="mura-object-meta"><h3>' + mura.escapeHTML(context.label) + '</h3></div>';
	} else {
	    return '';
	}
}
mura.templates['content']=function(context){
	context.html=context.html || context.content || context.source || '';

  	return '<div class="mura-object-content">' + context.html + '</div>';
}
mura.templates['text']=function(context){
	context=context || {};
	context.source=context.source || '<p>This object has not been configured.</p>';
 	return context.source;
}
mura.templates['embed']=function(context){
	context=context || {};
	context.source=context.source || '<p>This object has not been configured.</p>';
 	return context.source;
}
