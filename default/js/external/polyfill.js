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

