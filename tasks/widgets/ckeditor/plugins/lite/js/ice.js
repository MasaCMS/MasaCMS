(function () {

	function nativeElement(e) {
		return e;
	}
	
	var exports = this,
		defaults, InlineChangeEditor;

	defaults = {
	// ice node attribute names:
		attributes: {
			changeId: 'data-cid',
			userId: 'data-userid',
			userName: 'data-username',
			time: 'data-time',
			changeData: 'data-changedata', // dfl, arbitrary data to associate with the node, e.g. version
		},
		// Prepended to `changeType.alias` for classname uniqueness, if needed
		attrValuePrefix: '',
		
		// Block element tagname, which wrap text and other inline nodes in `this.element`
		blockEl: 'p',
		
		// All permitted block element tagnames
		blockEls: ['div','p', 'ol', 'ul', 'li', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'blockquote'],
		
		// Unique style prefix, prepended to a digit, incremented for each encountered user, and stored
		// in ice node class attributes - cts1, cts2, cts3, ...
		stylePrefix: 'cts',
		currentUser: {
			id: null,
			name: null
		},
	
		// Default change types are insert and delete. Plugins or outside apps should extend this
		// if they want to manage new change types. The changeType name is used as a primary
		// reference for ice nodes; the `alias`, is dropped in the class attribute and is the
		// primary method of identifying ice nodes; and `tag` is used for construction only.
		// Invoking `this.getCleanContent()` will remove all delete type nodes and remove the tags
		// for the other types, leaving the html content in place.
		changeTypes: {
			insertType: {
				tag: 'span',
				alias: 'ins',
				action: 'Inserted'
		},
			deleteType: {
				tag: 'span',
				alias: 'del',
				action: 'Deleted'
			}
		},

		// If `true`, setup event listeners on `this.element` and handle events - good option for a basic
		// setup without a text editor. Otherwise, when set to `false`, events need to be manually passed
		// to `handleEvent`, which is good for a text editor with an event callback handler, like tinymce.
		handleEvents: false,
	
		// Sets this.element with the contentEditable element
		contentEditable: undefined,//dfl, start with a neutral value
	
		// Switch for toggling track changes on/off - when `false` events will be ignored.
		_isTracking: true,
	
		// NOT IMPLEMENTED - Selector for elements that will not get track changes
		noTrack: '.ice-no-track',
		
		tooltips: false, //dfl
		
		tooltipsDelay: 200, //dfl
	
		// Switch for whether paragraph breaks should be removed when the user is deleting over a
		// paragraph break while changes are tracked.
		mergeBlocks: true,
		
		_isVisible : true, // dfl, state of change tracking visibility
		
		_changeData : null, //dfl, a string you can associate with the current change set, e.g. version
		
		_handleSelectAll: false, // dfl, if true, handle ctrl/cmd-A in the change tracker
	};

	/**
	 * @class ice.InlineChangeEditor
	 * The change tracking engine
	 * interacts with a <code>contenteditable</code> DOM element
	 */
	InlineChangeEditor = function (options) {

		// Data structure for modelling changes in the element according to the following model:
		//	[changeid] => {`type`, `time`, `userid`, `username`}
		options || (options = {});
		if (!options.element) {
			throw new Error("`options.element` must be defined for ice construction.");
		}
	
		this._changes = {};
		// Tracks all of the styles for users according to the following model:
		//	[userId] => styleId; where style is "this.stylePrefix" + "this.uniqueStyleIndex"
		this._userStyles = {};
		this._styles = {}; // dfl, moved from prototype
		this._refreshInterval = null; // dfl
		this.$this = jQuery(this);
		this._browser = ice.dom.browser();
		this._tooltipMouseOver = this._tooltipMouseOver.bind(this);
		this._tooltipMouseOut = this._tooltipMouseOut.bind(this);
		
		ice.dom.extend(true, this, defaults, options);
		if (options.tooltips && (! jQuery.isFunction(options.hostMethods.showTooltip) || ! jQuery.isFunction(options.hostMethods.hideTooltip))) {
			throw new Error("hostMethods.showTooltip and hostMethods.hideTooltip must be defined if tooltips is true");
		}
		var us = options.userStyles || {}; // dfl, moved from prototype, allow preconfig
		for (var id in us) {
			if (us.hasOwnProperty(id)) {
				var st = us[id];
				if (! isNaN(st)) {
					this._userStyles[id] = this.stylePrefix + '-' + st;
					this._uniqueStyleIndex = Math.max(st, this._uniqueStyleIndex);
					this._styles[st] = true;
				}
			}
		}
	
	};

	InlineChangeEditor.prototype = {
	
		// Incremented for each new user and appended to they style prefix, and dropped in the
		// ice node class attribute.
		_uniqueStyleIndex: 0,
	
		_browserType: null,
	
		// One change may create multiple ice nodes, so this keeps track of the current batch id.
		_batchChangeid: null,
	
		// Incremented for each new change, dropped in the changeIdAttribute.
		_uniqueIDIndex: 1,
	
		// Temporary bookmark tags for deletes, when delete placeholding is active.
		_delBookmark: 'tempdel',
		isPlaceHoldingDeletes: false,
	
		/**
		 * Turns on change tracking - sets up events, if needed, and initializes the environment,
		 * range, and editor.
		 */
		startTracking: function () {
			// dfl:set contenteditable only if it has been explicitly set
			if (typeof(this.contentEditable) == "boolean") {
				this.element.setAttribute('contentEditable', this.contentEditable);
			}
		
			// If we are handling events setup the delegate to handle various events on `this.element`.
			if (this.handleEvents) {
				var self = this;
				ice.dom.bind(self.element, 'keyup.ice keydown.ice keypress.ice', function (e) {
					return self.handleEvent(e);
				});
			}
			
			this.initializeEnvironment();
			this.initializeEditor();
			this.initializeRange();
			this._updateTooltipsState(); //dfl
			
			return this;
		},
	
		/**
		 * Removes contenteditability and stops event handling.
		 * Changed by dfl to have the option of not setting contentEditable
		 */
		stopTracking: function (onlyICE) {
	
			this._isTracking = false;
			try { // dfl added try/catch for ie
				// If we are handling events setup the delegate to handle various events on `this.element`.
				if (this.element) {
					ice.dom.unbind(this.element, 'keyup.ice keydown.ice keypress.ice');
				}
		
				// dfl:reset contenteditable unless requested not to do so
				if (! onlyICE && (typeof(this.contentEditable) != "undefined")) {
					this.element.setAttribute('contentEditable', !this.contentEditable);
				}
			}
			catch (e){}

			this._updateTooltipsState();
			return this;
		},
	
		/**
		 * Initializes the `env` object with pointers to key objects of the page.
		 */
		initializeEnvironment: function () {
			this.env || (this.env = {});
			this.env.element = this.element;
			this.env.document = this.element.ownerDocument;
			this.env.window = this.env.document.defaultView || this.env.document.parentWindow || window;
			this.env.frame = this.env.window.frameElement;
			this.env.selection = this.selection = new ice.Selection(this.env);
			// Hack for using custom tags in IE 8/7
			this.env.document.createElement(this.changeTypes.insertType.tag);
			this.env.document.createElement(this.changeTypes.deleteType.tag);
		},
	
		/**
		 * Initializes the internal range object and sets focus to the editing element.
		 */
		initializeRange: function () {
/*			var range = this.selection.createRange();
			range.setStart(ice.dom.find(this.element, this.blockEls.join(', '))[0], 0);
			range.collapse(true);
			this.selection.addRange(range);
			if (this.env.frame) {
				this.env.frame.contentWindow.focus();
			}
			else {
				this.element.focus();
			} */
		},
	
		/**
		 * Initializes the content in the editor - cleans non-block nodes found between blocks and
		 * initializes the editor with any tracking tags found in the editing element.
		 */
		initializeEditor: function () {
			// Clean the element html body - add an empty block if there is no body, or remove any
			// content between elements.
/*			var self = this,
				body = this.env.document.createElement('div');
			if (this.element.childNodes.length) {
				body.innerHTML = this.element.innerHTML;
				ice.dom.removeWhitespace(body);
				if (body.innerHTML === '') {
//					body.appendChild(ice.dom.create('<' + this.blockEl + ' ><br/></' + this.blockEl + '>'));
				} 
			}
			else {
//				body.appendChild(ice.dom.create('<' + this.blockEl + ' ><br/></' + this.blockEl + '>'));
			}
//			this.element.innerHTML = body.innerHTML; */
			this._loadFromDom(); // refactored by dfl
			this._updateTooltipsState(); // dfl
		},
		
		/**
		 * Check whether or not this tracker is tracking changes.
		 * @return {Boolean} Is this tracker tracking?
		 */
		isTracking: function() {
			return this._isTracking;
		},
	
		/**
		 * Turn on change tracking and event handling.
		 */
		enableChangeTracking: function () {
			this._isTracking = true;
		},
	
		/**
		 * Turn off change tracking and event handling.
		 */
		disableChangeTracking: function () {
			this._isTracking = false;
		},
	
		/**
		 * Sets or toggles the tracking and event handling state.
		 * @param {Boolean} bTrack if undefined, the tracking state is toggled, otherwise set to the parameter
		 */
		toggleChangeTracking: function (bTrack) {
			bTrack = (undefined === bTrack) ? ! this._isTracking : !!bTrack;
			this._isTracking = bTrack;
		},
		/**
		 * Set the user to be tracked. A user object has the following properties:
		 * {`id`, `name`}
		 */
		setCurrentUser: function (user) {
			this.currentUser = user;
			this._updateUserData(user); // dfl, update data dependant on the user details
		},
		
		/**
		 * Sets or toggles the tooltips state.
		 * @param {Boolean} bTooltips if undefined, the tracking state is toggled, otherwise set to the parameter
		 */
		toggleTooltips: function(bTooltips) {
			bTooltips = (undefined === bTooltips) ? ! this.tooltips : !!bTooltips;
			this.tooltips = bTooltips;
			this._updateTooltipsState();
		},
	
		/**
		 * If tracking is on, handles event e when it is one of the following types:
		 * mouseup, mousedown, keypress, keydown, and keyup. Each event type is
		 * propagated to all of the plugins. Prevents default handling if the event
		 * was fully handled.
		 */
		handleEvent: function (e) {
			if (!this._isTracking) {
				return true;
			}
			if (e.type == 'keypress') {
				var needsToBubble = this.keyPress(e);
				if (!needsToBubble) {
					e.preventDefault();
				}
				return needsToBubble;
			} 
			else if (e.type == 'keydown') {
				var needsToBubble = this.keyDown(e);
				if (!needsToBubble) {
					e.preventDefault();
				}
				return needsToBubble;
			} 
		},

		visible: function(el) {
			if(el.nodeType === ice.dom.TEXT_NODE) el = el.parentNode;
			var rect = el.getBoundingClientRect();
			return ( rect.top > 0 && rect.left > 0);
		},

	 	
		/**
		 * Returns a tracking tag for the given `changeType`, with the optional `childNode` appended.
		 * @private
		 */
		_createIceNode: function (changeType, childNode) {
			var node = this.env.document.createElement(this.changeTypes[changeType].tag);
			ice.dom.addClass(node, this._getIceNodeClass(changeType));
	
			if (childNode) {
				node.appendChild(childNode);
			}
			this._addChange(this.changeTypes[changeType].alias, [node]);
	
			return node;
		},
	
		/**
		 * Inserts the given string/node into the given range with tracking tags, collapsing (deleting)
		 * the range first if needed. If range is undefined, then the range from the Selection object
		 * is used. If the range is in a parent delete node, then the range is positioned after the delete.
		 */
		insert: function (nodes) {
			this.hostMethods.beforeInsert && this.hostMethods.beforeInsert();

			var range = this.getCurrentRange(),
				hostRange = range ? null : this.hostMethods.getHostRange(),
				changeid = this._batchChangeid ? null : this.startBatchChange(),
				hadSelection = !!(range && !range.collapsed);
			
			
		// If we have any nodes selected, then we want to delete them before inserting the new text.
			if (hadSelection) {
				this._deleteContents(false, range); 
			// Update the range
				range = this.getCurrentRange();
				if (range.startContainer === range.endContainer && this.element === range.startContainer) {
/*					// The whole editable element is selected. Need to remove everything and init its contents.
					ice.dom.empty(this.element);
					range = this.selection.getRangeAt(0);
//					var firstSelectable = range.getLastSelectableChild(this.element);
//					range.setStartAfter(firstSelectable);
					range.collapse(true); */
				}
			}
			else if (! range && ! nodes) {
				// prepare for insertion when there's no selection - just ignore
				return true;
			}
			
			if (nodes && ! jQuery.isArray(nodes)) {
				nodes = [nodes];
			}
	
			// If we are in a non-tracking/void element, move the range to the end/outside.
			this._moveRangeToValidTrackingPos(range, hostRange, hadSelection);
	
			this._insertNodes(range, hostRange, nodes);
			this.endBatchChange(changeid);
			return true;//isPropagating;
		},
	
		/**
		 * Deletes the contents in the given range or the range from the Selection object. If the range
		 * is not collapsed, then a selection delete is handled; otherwise, it deletes one character
		 * to the left or right if the right parameter is false or true, respectively.
		 * compared OK
		 * @return true if deletion was handled.
		 * @private
		 */
		_deleteContents: function (right, range) {
			var prevent = true,
				browser = this._browser;
			
			this.hostMethods.beforeDelete && this.hostMethods.beforeDelete();
			if (range) {
				this.selection.addRange(range);
			} else {
				range = this.getCurrentRange();
			}
			var changeid = this._batchChangeid ? null : this.startBatchChange();
			if (range.collapsed === false) {
				range = this._deleteSelection(range);
/*				if(this._browser.mozilla){
					if(range.startContainer.parentNode.previousSibling){
						range.setEnd(range.startContainer.parentNode.previousSibling, 0);
						range.moveEnd(ice.dom.CHARACTER_UNIT, ice.dom.getNodeCharacterLength(range.endContainer));
					}
					else { 
						range.setEndAfter(range.startContainer.parentNode);
					}
					range.collapse(false);
				}
				else { */
					if(! this.visible(range.endContainer)) {
						range.setEnd(range.endContainer, Math.max(0, range.endOffset - 1));
						range.collapse(false);
					}
//				}
			}
			else {
		        if (right) {
					// RIGHT DELETE
					if(browser["type"] === "mozilla"){
						prevent = this._deleteRight(range);
						// Handling track change show/hide
						if(!this.visible(range.endContainer)){
							if(range.endContainer.parentNode.nextSibling){
		//						range.setEnd(range.endContainer.parentNode.nextSibling, 0);
								range.setEndBefore(range.endContainer.parentNode.nextSibling);
							} else {
								range.setEndAfter(range.endContainer);
							}
							range.collapse(false);
						}
					}
					else {
						// Calibrate Cursor before deleting
						if(range.endOffset === ice.dom.getNodeCharacterLength(range.endContainer)){
							var next = range.startContainer.nextSibling;
							if (ice.dom.is(next,  '.' + this._getIceNodeClass('deleteType'))) {
								while(next){
									if (ice.dom.is(next,  '.' + this._getIceNodeClass('deleteType'))) {
										next = next.nextSibling;
										continue;
									}
									range.setStart(next, 0);
									range.collapse(true);
									break;
								}
							}
						}
		
						// Delete
						prevent = this._deleteRight(range);
		
						// Calibrate Cursor after deleting
						if(!this.visible(range.endContainer)){
							if (ice.dom.is(range.endContainer.parentNode,  '.' + this._getIceNodeClass('insertType') + ', .' + this._getIceNodeClass('deleteType'))) {
		//						range.setStart(range.endContainer.parentNode.nextSibling, 0);
								range.setStartAfter(range.endContainer.parentNode);
								range.collapse(true);
							}
						}
					}
				}
				else {
					// LEFT DELETE
					if(browser.mozilla){
						prevent = this._deleteLeft(range);
						// Handling track change show/hide
						if(!this.visible(range.startContainer)){
							if(range.startContainer.parentNode.previousSibling){
								range.setEnd(range.startContainer.parentNode.previousSibling, 0);
							} else {
								range.setEnd(range.startContainer.parentNode, 0);
							}
							range.moveEnd(ice.dom.CHARACTER_UNIT, ice.dom.getNodeCharacterLength(range.endContainer));
							range.collapse(false);
						}
					}
					else {
						if(!this.visible(range.startContainer)){
							if(range.endOffset === ice.dom.getNodeCharacterLength(range.endContainer)){
								var prev = range.startContainer.previousSibling;
								if (ice.dom.is(prev,  '.' + this._getIceNodeClass('deleteType'))) {
									while(prev){
										if (ice.dom.is(prev,  '.' + this._getIceNodeClass('deleteType'))) {
											prev = prev.prevSibling;
											continue;
										}
										range.setEndBefore(prev.nextSibling, 0);
										range.collapse(false);
										break;
									}
								}
							}
						}
						prevent = this._deleteLeft(range);
					}
				}
			}
	
			this.selection.addRange(range);
			this.endBatchChange(changeid);
			return prevent;
		},
	
		/**
		 * Returns the changes - a hash of objects with the following properties:
		 * [changeid] => {`type`, `time`, `userid`, `username`}
		 */
		getChanges: function () {
			return this._changes;
		},
	
		/**
		 * Returns an array with the user ids who made the changes
		 */
		getChangeUserids: function () {
			var result = [];
			var keys = Object.keys(this._changes);
	
			for (var key in keys) {
				result.push(this._changes[keys[key]].userid);
			}
	
			return result.sort().filter(function (el, i, a) {
				if (i == a.indexOf(el)) return 1;
				return 0;
			});
		},
	
		/**
		 * Returns the html contents for the tracked element.
		 */
		getElementContent: function () {
			return this.element.innerHTML;
		},
	
		/**
		 * Returns the html contents, without tracking tags, for `this.element` or
		 * the optional `body` param which can be of either type string or node.
		 * Delete tags, and their html content, are completely removed; all other
		 * change type tags are removed, leaving the html content in place. After
		 * cleaning, the optional `callback` is executed, which should further
		 * modify and return the element body.
		 *
		 * prepare gets run before the body is cleaned by ice.
		 */
		getCleanContent: function (body, callback, prepare) {
			var newBody = this.getCleanDOM(body, {callback:callback, prepare: prepace, clone: true});
			return (newBody && newBody.innerHTML) || "";
		},
		
		/**
		 * Returns a clone of the DOM, without tracking tags, for `this.element` or
		 * the optional `body` param which can be of either type string or node.
		 * Delete tags, and their html content, are completely removed; all other
		 * change type tags are removed, leaving the html content in place. After
		 * cleaning, the optional `callback` is executed, which should further
		 * modify and return the element body.
		 *
		 * prepare gets run before the body is cleaned by ice.
		 */
		getCleanDOM : function(body, options) {
			var classList = '',
				self = this;
			options = options || {};
			ice.dom.each(this.changeTypes, function (type, i) {
			if (type != 'deleteType') {
				if (i > 0) classList += ',';
				classList += '.' + self._getIceNodeClass(type);
			}
			});
			if (body) {
				if (typeof body === 'string') {
					body = ice.dom.create('<div>' + body + '</div>');
				}
				else if (options.clone){
					body = ice.dom.cloneNode(body, false)[0];
				}
			} 
			else {
				body = options.clone? ice.dom.cloneNode(this.element, false)[0] : this.element;
			}
			return this._cleanBody(body, classList, options);
		},
		
		_cleanBody: function(body, classList, options) {
			body = options.prepare ? options.prepare.call(this, body) : body;
			var changes = ice.dom.find(body, classList);
			ice.dom.each(changes, function (i,el) {
				while (el.firstChild) {
					el.parentNode.insertBefore(el.firstChild, el);
				}
				el.parentNode.removeChild(el);
//				ice.dom.replaceWith(this, ice.dom.contents(this));
			});
			var deletes = ice.dom.find(body, '.' + this._getIceNodeClass('deleteType'));
			ice.dom.remove(deletes);
	
			body = options.callback ? options.callback.call(this, body) : body;
	
			return body;
		},
	
		/**
		 * Accepts all changes in the element body - removes delete nodes, and removes outer
		 * insert tags keeping the inner content in place.
		 * dfl:added support for filtering
		 */
		acceptAll: function (options) {
			if (options) {
				return this._acceptRejectSome(options, true);
			}
			else {
				this.getCleanDOM(this.element, {
					clone: false
				});
//				this.element.innerHTML = this.getCleanContent();
				this._changes = {}; // dfl, reset the changes table
				this._triggerChange(); // notify the world that our change count has changed
			}
		},
	
		/**
		 * Rejects all changes in the element body - removes insert nodes, and removes outer
		 * delete tags keeping the inner content in place.*
		 * dfl:added support for filtering
		 */
		rejectAll: function (options) {
			if (options) {
				return this._acceptRejectSome(options, false);
			}
			else {
				var insSel = '.' + this._getIceNodeClass('insertType');
				var delSel = '.' + this._getIceNodeClass('deleteType');
		
				ice.dom.remove(ice.dom.find(this.element, insSel));
				ice.dom.each(ice.dom.find(this.element, delSel), function (i, el) {
					ice.dom.replaceWith(el, ice.dom.contents(el));
				});
				this._changes = {}; // dfl, reset the changes table
				this._triggerChange(); // notify the world that our change count has changed
			}
		},
	
		/**
		 * Accepts the change at the given, or first tracking parent node of, `node`.	If
		 * `node` is undefined then the startContainer of the current collapsed range will be used.
		 * In the case of insert, inner content will be used to replace the containing tag; and in
		 * the case of delete, the node will be removed.
		 */
		acceptChange: function (node) {
			this.acceptRejectChange(node, true);
		},
	
		/**
		 * Rejects the change at the given, or first tracking parent node of, `node`.	If
		 * `node` is undefined then the startContainer of the current collapsed range will be used.
		 * In the case of delete, inner content will be used to replace the containing tag; and in
		 * the case of insert, the node will be removed.
		 */
		rejectChange: function (node) {
			this.acceptRejectChange(node, false);
		},
	
		/**
		 * Handles accepting or rejecting tracking changes
		 */
		acceptRejectChange: function (node, isAccept) {
			var delSel, insSel, selector, removeSel, replaceSel, trackNode, changes, dom = ice.dom, nChanges;
		
			if (!node) {
				var range = this.getCurrentRange();
				if (!range.collapsed) {
					return;
				}
				node = range.startContainer;
			}
		
			delSel = removeSel = '.' + this._getIceNodeClass('deleteType');
			insSel = replaceSel = '.' + this._getIceNodeClass('insertType');
			if (!isAccept) {
				removeSel = insSel;
				replaceSel = delSel;
			}
	
			selector = delSel + ',' + insSel;
			trackNode = dom.getNode(node, selector);
			var changeId = dom.attr(trackNode, this.attributes.changeId); //dfl
				// Some changes are done in batches so there may be other tracking
				// nodes with the same `changeIdAttribute` batch number.
			changes = dom.find(this.element, removeSel + '[' + this.attributes.changeId + '=' + changeId + ']');
			nChanges = changes.length;
			dom.remove(changes);
			// we handle the replaced nodes after the deleted nodes because, well, the engine may b buggy, resulting in some nesting
			changes = dom.find(this.element, replaceSel + '[' + this.attributes.changeId + '=' + changeId + ']');
			nChanges += changes.length;
		
			dom.each(changes, function (i, node) {
				dom.replaceWith(node, ice.dom.contents(node));
			});

			/* begin dfl: if changes were accepted/rejected, remove change trigger change event */
			delete this._changes[changeId];
			if (nChanges > 0) {
				this._triggerChange();
			}
			/* end dfl */
		},
	
		/**
		 * Returns true if the given `node`, or the current collapsed range is in a tracking
		 * node; otherwise, false.
		 */
		isInsideChange: function (node) {
			try {
				return !! this.currentChangeNode(node); // refactored by dfl
			}
			catch (e) {
				return false;
			}
		},
	
		/**
		 * Returns this `node` or the first parent tracking node with the given `changeType`.
		 * @private
		 */
		_getIceNode: function (node, changeType) {
			var selector = '.' + this._getIceNodeClass(changeType);
			return ice.dom.getNode((node && node.$) || node, selector);
		},
	
		/**
		 * Sets the given `range` to the first position, to the right, where it is outside of
		 * void elements.
		 * @private
		 */
		_moveRangeToValidTrackingPos: function (range, hostRange, moveToStart) {
			// set range to hostRange if available
			if (! (range = hostRange || range)) {
				return;
			}
			var voidEl,
				el,
				visited = [],
				found = false,
				length;
			while (! found) {
				el = moveToStart ? range.startContainer : range.endContainer;
				if (visited.indexOf(el) >= 0 || ! el) {
					return; // loop
				}
				visited.push(el);
				voidEl = this._getVoidElement(el);
				if (voidEl) {
					if (visited.indexOf(voidEl) >= 0) {
						return; // loop
					}
					visited.push(voidEl)
				}
				else {
					found = ice.dom.isTextContainer(el);
				}
				if (! found) { // in void element or non text container
					var newEdge = voidEl && moveToStart ? ice.dom.findPrevTextContainer(voidEl, this.element) :
							ice.dom.findNextTextContainer(voidEl || el, this.element),
						edgeNode = newEdge.node;
					// we have a new edge node

					if (hostRange) {
						edgeNode = this.hostMethods.makeHostElement(edgeNode);
					}
					try { 
						if (moveToStart) {
							range.setStart(edgeNode, newEdge.offset);
						}
						else {
							range.setEnd(edgeNode, newEdge.offset);
						}
						range.collapse(moveToStart);
					}
					catch (e) { // if we can't set the selection for whatever reason, end of document etc., break
						break;
					}
				}
			}
		},
	
		/**
		 * Returns the given `node` or the first parent node that matches against the list of no track elements.
		 * @private
		 */
		_getNoTrackElement: function (node) {
			var noTrackSelector = this._getNoTrackSelector();
			var parent = ice.dom.is(node, noTrackSelector) ? node : (ice.dom.parents(node, noTrackSelector)[0] || null);
			return parent;
		},
	
		/**
		 * Returns a selector for not tracking changes
		 * @private
		 */
		_getNoTrackSelector: function () {
			return this.noTrack;
		},
	
		/**
		 * Returns the given `node` or the first parent node that matches against the list of void elements.
		 * dfl: added try/catch
		 * @private
		 */
		_getVoidElement: function (node) {
			
			if (node.$) {
				node = node.$;
			}
			try {
				var voidSelector = this._getVoidElSelector(),
					voidParent = ice.dom.is(node, voidSelector) ? node : (ice.dom.parents(node, voidSelector)[0] || null);
				if (! voidParent) {
					if (3 == node.nodeType && node.nodeValue == '\u200B') {
						return node;
					}
				}
				return voidParent;
			}
			catch(e) {
				return null;
			}
		},
	
		/**
		 * Returns a css selector for delete .
		 * @private
		 */
		_getVoidElSelector: function () {
			return '.' + this._getIceNodeClass('deleteType');
		},
	
		/**
		 * Returns true if node has a user id attribute that matches the current user id.
		 * @private
		 */
		_currentUserIceNode: function (node) {
			return ice.dom.attr(node, this.attributes.userId) == this.currentUser.id;
		},
	
		/**
		 * With the given alias, searches the changeTypes objects and returns the
		 * associated key for the alias.
		 * @private
		 */
		_getChangeTypeFromAlias: function (alias) {
			var type, ctnType = null;
			for (type in this.changeTypes) {
				if (this.changeTypes.hasOwnProperty(type)) {
					if (this.changeTypes[type].alias == alias) {
						ctnType = type;
					}
				}
			}
	
			return ctnType;
		},
	
/**
 * @private
 */				
		_getIceNodeClass: function (changeType) {
			return this.attrValuePrefix + this.changeTypes[changeType].alias;
		},
	
		/**
		 * @private
		 */				
		_getUserStyle: function (userid) {
			if (userid === null || userid === "" || "undefined" == typeof userid) {
				return this.stylePrefix;
			};
			var styleIndex = null;
			if (this._userStyles[userid]) {
				styleIndex = this._userStyles[userid];
			}
			else {
				styleIndex = this._setUserStyle(userid, this._getNewStyleId());
			}
			return styleIndex;
		},
	
		/**
		 * @private
		 */
		_setUserStyle: function (userid, styleIndex) {
			var style = this.stylePrefix + '-' + styleIndex;
			if (!this._styles[styleIndex]) {
				this._styles[styleIndex] = true;
			}
			return this._userStyles[userid] = style;
		},
	
		_getNewStyleId: function () {
			var id = ++this._uniqueStyleIndex;
			if (this._styles[id]) {
			// Dupe.. create another..
				return this._getNewStyleId();
			} 
			else {
				this._styles[id] = true;
				return id;
			}
		},
	
		_addChange: function (ctnType, ctNodes) {
			var changeid = this._batchChangeid || this.getNewChangeId(),
				self = this;

			if (!this._changes[changeid]) {
				// Create the change object.
				this._changes[changeid] = {
					type: this._getChangeTypeFromAlias(ctnType),
					time: (new Date()).getTime(),
					userid: String(this.currentUser.id),// dfl: must stringify for consistency - when we read the props from dom attrs they are strings
					username: this.currentUser.name,
					data : this._changeData || ""
				};
				this._triggerChange(); //dfl
			}
			ice.dom.foreach(ctNodes, function (i) {
				self._addNodeToChange(changeid, ctNodes[i]);
			});
	
			return changeid;
		},
	
		/**
		 * Adds tracking attributes from the change with changeid to the ctNode.
		 * @param changeid Id of an existing change.
		 * @param ctNode The element to add for the change.
		 * @private
		 */
		_addNodeToChange: function (changeid, ctNode) {
			changeid = this._batchChangeid || changeid;
			var change = this.getChange(changeid);
			
			if (!ctNode.getAttribute(this.attributes.changeId)) ctNode.setAttribute(this.attributes.changeId, changeid);
// modified by dfl, handle missing userid, try to set username according to userid
			var userId = ctNode.getAttribute(this.attributes.userId); 
			if (! userId) {
				ctNode.setAttribute(this.attributes.userId, userId = change.userid);
			}
			if (userId == change.userid) {
				ctNode.setAttribute(this.attributes.userName, change.username);
			}
			
// dfl add change data
			var changeData = ctNode.getAttribute(this.attributes.changeData);
			if (null == changeData) {
				ctNode.setAttribute(this.attributes.changeData, this._changeData || "");
			}
			
			if (!ctNode.getAttribute(this.attributes.time)) {
				ctNode.setAttribute(this.attributes.time, change.time);
			}
			
//			if (!ice.dom.hasClass(ctNode, this._getIceNodeClass(change.type))) ice.dom.addClass(ctNode, this._getIceNodeClass(change.type));
	
			var style = this._getUserStyle(change.userid);
			if (!ice.dom.hasClass(ctNode, style)) {
				ice.dom.addClass(ctNode, style);
			}
			/* Added by dfl */
			this._updateNodeTooltip(ctNode);
		},
	
		getChange: function (changeid) {
			return this._changes[changeid] || null;
		},
	
		getNewChangeId: function () {
			var id = ++this._uniqueIDIndex;
			if (this._changes[id]) {
			// Dupe.. create another..
			id = this.getNewChangeId();
			}
			return id;
		},
	
		startBatchChange: function () {
			this._batchChangeid = this.getNewChangeId();
			return this._batchChangeid;
		},
	
		endBatchChange: function (changeid) {
			if (changeid !== this._batchChangeid) return;
			this._batchChangeid = null;
			this._triggerChangeText();
		},
	
		getCurrentRange: function () {
			try {
				return this.selection.getRangeAt(0);
			}
			catch (e) {
				return null;
			}
		},
	
		// passed compare, 2 changes below
		_insertNodes: function (_range, hostRange, nodes) {
			var range = hostRange || _range,
				_start = range.startContainer,
				start = (_start && _start.$) || _start,
				f = hostRange ? this.hostMethods.makeHostElement : nativeElement;
			
/*			if (!ice.dom.isBlockElement(start) && 
				!ice.dom.canContainTextElement(ice.dom.getBlockParent(start, this.element)) && 
				start.previousSibling) {
				range.setStart(f(start.previousSibling), 0);
				start = hostRange? hostRange.startContainer && hostRange.startContainer.$ : range.startContainer;
			} */
//			var startContainer = range.startContainer;
//				parentBlock = ice.dom.isBlockElement(startContainer) && startContainer || ice.dom.getBlockParent(startContainer, this.element) || null;
/*			if (parentBlock === this.element) {
				var firstPar = document.createElement(this.blockEl);
				parentBlock.appendChild(firstPar);
				range.setStart(firstPar, 0);
				range.collapse();
				return this._insertNodes(node, range, insertingDummy);
			}
			//dfl added null check on parentBlock
			if (parentBlock && ice.dom.hasNoTextOrStubContent(parentBlock)) {
				ice.dom.empty(parentBlock);
				ice.dom.append(parentBlock, '<br>');
				range.setStart(parentBlock, 0);
			} */
	
			var ctNode = this._getIceNode(start, 'insertType'),
				inCurrentUserInsert = this._currentUserIceNode(ctNode);
	
			// Do nothing, let this bubble-up to insertion handler.
			if (inCurrentUserInsert) {
				var head = nodes && nodes[0];
				if (head) {
					range.insertNode(f(head));
					var parent = head.parentNode,
						sibling = head.nextSibling;
					for (var i = 1; i < nodes.length; ++i) {
						if (sibling) {
							parent.insertBefore(nodes[i], sibling);
						}
						else {
							parent.appendChild(nodes[i]);
						}
					}
				}
			}
			else {
				// If we aren't in an insert node which belongs to the current user, then create a new ins node
				var node = this._createIceNode('insertType');
				if (ctNode) {
					var nChildren = ctNode.childNodes.length;
					ctNode.normalize();
					if (nChildren != ctNode.childNodes.length) {
						if (hostRange) {
							hostRange = range = this.hostMethods.getHostRange();
						}
						else {
							range = this.getCurrentRange();
						}
					}
					if (ctNode) {
						var end = (hostRange && hostRange.endContainer.$) || range.endContainer;
						if ((end.nodeType == 3 && range.endOffset < range.endContainer.length) || (end != ctNode.lastChild)) {
							ctNode = this._splitNode(ctNode, range.endContainer, range.endOffset);
						}
		//				range.setEndAfter(ctNode);
		//				range.collapse();
					}
				}
				if (ctNode) {
					range.setStartAfter(f(ctNode));
					range.collapse(true);
				}
	
				range.insertNode(f(node));
				var len = (nodes && nodes.length) || 0;
				if (len) {
					for (var i = 0; i < len; ++i) {
						node.appendChild(nodes[i]);
					}
					range.setStartAfter(f(node.lastChild));
				}
				else {
					var tn = this.element.ownerDocument.createTextNode('\uFEFF');
					node.appendChild(tn);
					tn = f(tn);
					range.setStartAndEnd(tn, 0, tn, 1);
				}
				if (hostRange) {
					this.hostMethods.setHostRange(hostRange);
				}
				else {
					this.selection.addRange(range);
				}
			}			

// Added by dfl
//			if (inCurrentUserInsert) {
//				this._normalizeNode(ctNode);
//			}
	
/*			if (insertingDummy) {
			// Create a selection of the dummy character we inserted
			// which will be removed after it bubbles up to the final handler.
				range.setStart(node, 0);
			} else {
				range.collapse();
			} */
			
		},
	
// compared OK
		_handleVoidEl: function(el, range) {
			// If `el` is or is in a void element, but not a delete
			// then collapse the `range` and return `true`.
			var voidEl = el && this._getVoidElement(el);
			if (voidEl && !this._getIceNode(voidEl, 'deleteType')) {
				range.collapse(true);
				return true;
			}
			return false;
		},
	
// compared OK
		_deleteSelection: function (range) {
	
			// Bookmark the range and get elements between.
			var bookmark = new ice.Bookmark(this.env, range),
			elements = ice.dom.getElementsBetween(bookmark.start, bookmark.end),
			b1 = ice.dom.parents(range.startContainer, this.blockEls.join(', '))[0],
			b2 = ice.dom.parents(range.endContainer, this.blockEls.join(', '))[0],
			betweenBlocks = new Array(); 
	
			for (var i = 0; i < elements.length; i++) {
				var elem = elements[i];
				if (ice.dom.isBlockElement(elem)) {
					betweenBlocks.push(elem);
					if (!ice.dom.canContainTextElement(elem)) {
						// Ignore containers that are not supposed to contain text. Check children instead.
						for (var k = 0; k < elem.childNodes.length; k++) {
							elements.push(elem.childNodes[k]);
						}
						continue;
					}
				}
				// Ignore empty space nodes
				if (elem.nodeType === ice.dom.TEXT_NODE && ice.dom.getNodeTextContent(elem).length === 0) continue;
		
				if (!this._getVoidElement(elem)) {
					// If the element is not a text or stub node, go deeper and check the children.
					if (elem.nodeType !== ice.dom.TEXT_NODE) {
						// Browsers like to insert breaks into empty paragraphs - remove them
						if (ice.dom.BREAK_ELEMENT == ice.dom.getTagName(elem)) {
							continue;
						}
			
						if (ice.dom.isStubElement(elem)) {
							this._addNodeTracking(elem, false, true);
							continue;
						}
						if (ice.dom.hasNoTextOrStubContent(elem)) {
							ice.dom.remove(elem);
						}
			
						for (var j = 0; j < elem.childNodes.length; j++) {
							var child = elem.childNodes[j];
							elements.push(child);
						}
						continue;
					}
					var parentBlock = ice.dom.getBlockParent(elem);
					this._addNodeTracking(elem, false, true, true);
					if (ice.dom.hasNoTextOrStubContent(parentBlock)) {
						ice.dom.remove(parentBlock);
					}
				}
			}
	
			if (this.mergeBlocks && b1 !== b2) {
				while (betweenBlocks.length) {
					ice.dom.mergeContainers(betweenBlocks.shift(), b1);
				}
//				ice.dom.removeBRFromChild(b2);
//				ice.dom.removeBRFromChild(b1);
				ice.dom.mergeContainers(b2, b1);
			}
	
			bookmark.selectBookmark();
			range = this.getCurrentRange();
			range.collapse(true);
			return range;
		},
	
		// Delete
		// passed compare
		_deleteRight: function (range) {
	
			var parentBlock = ice.dom.isBlockElement(range.startContainer) && range.startContainer || ice.dom.getBlockParent(range.startContainer, this.element) || null,
				isEmptyBlock = parentBlock ? (ice.dom.hasNoTextOrStubContent(parentBlock)) : false,
				nextBlock = parentBlock && ice.dom.getNextContentNode(parentBlock, this.element),
				nextBlockIsEmpty = nextBlock ? (ice.dom.hasNoTextOrStubContent(nextBlock)) : false,
				initialContainer = range.endContainer,
				initialOffset = range.endOffset,
				commonAncestor = range.commonAncestorContainer,
				nextContainer, returnValue;
	
	
			// If the current block is empty then let the browser handle the delete/event.
			if (isEmptyBlock) return false;
	
			// Some bugs in Firefox and Webkit make the caret disappear out of text nodes, so we try to put them back in.
			if (commonAncestor.nodeType !== ice.dom.TEXT_NODE) {
	
			// If placed at the beginning of a container that cannot contain text, such as an ul element, place the caret at the beginning of the first item.
			if (initialOffset === 0 && ice.dom.isBlockElement(commonAncestor) && (!ice.dom.canContainTextElement(commonAncestor))) {
				var firstItem = commonAncestor.firstElementChild;
				if (firstItem) {
				range.setStart(firstItem, 0);
				range.collapse();
				return this._deleteRight(range);
				}
			}
	
			if (commonAncestor.childNodes.length > initialOffset) {
				var tempTextContainer = document.createTextNode(' ');
				commonAncestor.insertBefore(tempTextContainer, commonAncestor.childNodes[initialOffset]);
				range.setStart(tempTextContainer, 1);
				range.collapse(true);
				returnValue = this._deleteRight(range);
				ice.dom.remove(tempTextContainer);
				return returnValue;
			} else {
				nextContainer = ice.dom.getNextContentNode(commonAncestor, this.element);
				range.setEnd(nextContainer, 0);
				range.collapse();
				return this._deleteRight(range);
			}
			}
	
			// Move range to position the cursor on the inside of any adjacent container that it is going
			// to potentially delete into or after a stub element.	E.G.:	test|<em>text</em>	->	test<em>|text</em> or
			// text1 |<img> text2 -> text1 <img>| text2
	
			// Merge blocks: If mergeBlocks is enabled, merge the previous and current block.
			range.moveEnd(ice.dom.CHARACTER_UNIT, 1);
			range.moveEnd(ice.dom.CHARACTER_UNIT, -1);
	
			// Handle cases of the caret is at the end of a container or placed directly in a block element
			if (initialOffset === initialContainer.data.length && (!ice.dom.hasNoTextOrStubContent(initialContainer))) {
				nextContainer = ice.dom.getNextNode(initialContainer, this.element);
		
				// If the next container is outside of ICE then do nothing.
				if (!nextContainer) {
					range.selectNodeContents(initialContainer);
					range.collapse();
					return false;
				}
		
				// If the next container is <br> element find the next node
				if (ice.dom.BREAK_ELEMENT == ice.dom.getTagName(nextContainer)) {
					nextContainer = ice.dom.getNextNode(nextContainer, this.element);
				}
		
				// If the next container is a text node, look at the parent node instead.
				if (nextContainer.nodeType === ice.dom.TEXT_NODE) {
					nextContainer = nextContainer.parentNode;
				}
		
				// If the next container is non-editable, enclose it with a delete ice node and add an empty text node after it to position the caret.
				if (!nextContainer.isContentEditable) {
					returnValue = this._addNodeTracking(nextContainer, false, false);
					var emptySpaceNode = document.createTextNode('');
					nextContainer.parentNode.insertBefore(emptySpaceNode, nextContainer.nextSibling);
					range.selectNode(emptySpaceNode);
					range.collapse(true);
					return returnValue;
				}
		
				if (this._handleVoidEl(nextContainer, range)) return true;
		
				// If the caret was placed directly before a stub element, enclose the element with a delete ice node.
				if (ice.dom.isChildOf(nextContainer, parentBlock) && ice.dom.isStubElement(nextContainer)) {
					return this._addNodeTracking(nextContainer, range, false);
				}
	
			}
	
			if (this._handleVoidEl(nextContainer, range)) {
				return true;
			}
	
			// If we are deleting into a no tracking containiner, then remove the content
			if (this._getNoTrackElement(range.endContainer.parentElement)) {
				range._deleteContents();
				return false;
			}
	
			if (ice.dom.isOnBlockBoundary(range.startContainer, range.endContainer, this.element)) {
				if (this.mergeBlocks && ice.dom.is(ice.dom.getBlockParent(nextContainer, this.element), this.blockEl)) {
					// Since the range is moved by character, it may have passed through empty blocks.
					// <p>text {RANGE.START}</p><p></p><p>{RANGE.END} text</p>
					if (nextBlock !== ice.dom.getBlockParent(range.endContainer, this.element)) {
					range.setEnd(nextBlock, 0);
					}
					// The browsers like to auto-insert breaks into empty paragraphs - remove them.
					var elements = ice.dom.getElementsBetween(range.startContainer, range.endContainer);
					for (var i = 0; i < elements.length; i++) {
					ice.dom.remove(elements[i]);
					}
					var startContainer = range.startContainer;
					var endContainer = range.endContainer;
					ice.dom.remove(ice.dom.find(startContainer, 'br'));
					ice.dom.remove(ice.dom.find(endContainer, 'br'));
					return ice.dom.mergeBlockWithSibling(range, ice.dom.getBlockParent(range.endContainer, this.element) || parentBlock);
				} else {
					// If the next block is empty, remove the next block.
					if (nextBlockIsEmpty) {
					ice.dom.remove(nextBlock);
					range.collapse(true);
					return true;
					}
		
					// Place the caret at the start of the next block.
					range.setStart(nextBlock, 0);
					range.collapse(true);
					return true;
				}
			}
	
			var entireTextNode = range.endContainer,
				deletedCharacter = entireTextNode.splitText(range.endOffset),
				remainingTextNode = deletedCharacter.splitText(1);
	
			return this._addNodeTracking(deletedCharacter, range, false);
	
		},
	
		// Backspace
		_deleteLeft: function (range) {
	
			var parentBlock = ice.dom.isBlockElement(range.startContainer) && range.startContainer || ice.dom.getBlockParent(range.startContainer, this.element) || null,
			isEmptyBlock = parentBlock ? ice.dom.hasNoTextOrStubContent(parentBlock) : false,
			prevBlock = parentBlock && ice.dom.getPrevContentNode(parentBlock, this.element), // || ice.dom.getBlockParent(parentBlock, this.element) || null,
			prevBlockIsEmpty = prevBlock ? ice.dom.hasNoTextOrStubContent(prevBlock) : false,
			initialContainer = range.startContainer,
			initialOffset = range.startOffset,
			commonAncestor = range.commonAncestorContainer,
			lastSelectable, prevContainer;
	
			// If the current block is empty, then let the browser handle the key/event.
			if (isEmptyBlock) {
				return false;
			}
	
			// Handle cases of the caret is at the start of a container or outside a text node
			if (initialOffset === 0 || commonAncestor.nodeType !== ice.dom.TEXT_NODE) {
			// If placed at the end of a container that cannot contain text, such as an ul element, place the caret at the end of the last item.
				if (ice.dom.isBlockElement(commonAncestor) && (!ice.dom.canContainTextElement(commonAncestor))) {
					if (initialOffset === 0) {
						var firstItem = commonAncestor.firstElementChild;
						if (firstItem) {
							range.setStart(firstItem, 0);
							range.collapse();
							return this._deleteLeft(range);
						}
					} 
					else {
						var lastItem = commonAncestor.lastElementChild;
						if (lastItem) {
							lastSelectable = range.getLastSelectableChild(lastItem);
							if (lastSelectable) {
								range.setStart(lastSelectable, lastSelectable.data.length);
								range.collapse();
								return this._deleteLeft(range);
							}
						}
					}
				}
		
				if (initialOffset === 0) {
					prevContainer = ice.dom.getPrevContentNode(initialContainer, this.element);
				} 
				else {
					prevContainer = commonAncestor.childNodes[initialOffset - 1];
				}
		
				// If the previous container is outside of ICE then do nothing.
				if (!prevContainer) {
					return false;
				}
		
				// Firefox finds an ice node wrapped around an image instead of the image itself sometimes, so we make sure to look at the image instead.
				if (ice.dom.is(prevContainer,	'.' + this._getIceNodeClass('insertType') + ', .' + this._getIceNodeClass('deleteType')) && prevContainer.childNodes.length > 0 && prevContainer.lastChild) {
					prevContainer = prevContainer.lastChild;
				}
		
				// If the previous container is a text node, look at the parent node instead.
				if (prevContainer.nodeType === ice.dom.TEXT_NODE) {
					prevContainer = prevContainer.parentNode;
				}
		
				// If the previous container is non-editable, enclose it with a delete ice node and add an empty text node before it to position the caret.
				if (!prevContainer.isContentEditable) {
					var returnValue = this._addNodeTracking(prevContainer, false, true);
					var emptySpaceNode = document.createTextNode('');
					prevContainer.parentNode.insertBefore(emptySpaceNode, prevContainer);
					range.selectNode(emptySpaceNode);
					range.collapse(true);
					return returnValue;
				}
		
				if (this._handleVoidEl(prevContainer, range)) {
					return true;
				}
		
				// If the caret was placed directly after a stub element, enclose the element with a delete ice node.
				if (ice.dom.isStubElement(prevContainer) && ice.dom.isChildOf(prevContainer, parentBlock) || !prevContainer.isContentEditable) {
					 return this._addNodeTracking(prevContainer, range, true);
				}
		
				// If the previous container is a stub element between blocks
				// then just delete and leave the range/cursor in place.
				if (ice.dom.isStubElement(prevContainer)) {
					ice.dom.remove(prevContainer);
					range.collapse(true);
					return false;
				}
		
				if (prevContainer !== parentBlock && !ice.dom.isChildOf(prevContainer, parentBlock)) {
		
					if (!ice.dom.canContainTextElement(prevContainer)) {
						prevContainer = prevContainer.lastElementChild;
					}
					// Before putting the caret into the last selectable child, lets see if the last element is a stub element. If it is, we need to put the caret there manually.
					if (prevContainer.lastChild && prevContainer.lastChild.nodeType !== ice.dom.TEXT_NODE && ice.dom.isStubElement(prevContainer.lastChild) && prevContainer.lastChild.tagName !== 'BR') {
						range.setStartAfter(prevContainer.lastChild);
						range.collapse(true);
						return true;
					}
					// Find the last selectable part of the prevContainer. If it exists, put the caret there.
					lastSelectable = range.getLastSelectableChild(prevContainer);
		
					if (lastSelectable && !ice.dom.isOnBlockBoundary(range.startContainer, lastSelectable, this.element)) {
						range.selectNodeContents(lastSelectable);
						range.collapse();
						return true;
					}
				}
			}
	
			// Firefox: If an image is at the start of the paragraph and the user has just deleted the image using backspace, an empty text node is created in the delete node before
			// the image, but the caret is placed with the image. We move the caret to the empty text node and execute deleteFromLeft again.
			if (initialOffset === 1 && !ice.dom.isBlockElement(commonAncestor) && range.startContainer.childNodes.length > 1 && range.startContainer.childNodes[0].nodeType === ice.dom.TEXT_NODE && range.startContainer.childNodes[0].data.length === 0) {
				range.setStart(range.startContainer, 0);
				return this._deleteLeft(range);
			}
	
			// Move range to position the cursor on the inside of any adjacent container that it is going
			// to potentially delete into or before a stub element.	E.G.: <em>text</em>| test	->	<em>text|</em> test or
			// text1 <img>| text2 -> text1 |<img> text2
			range.moveStart(ice.dom.CHARACTER_UNIT, -1);
			range.moveStart(ice.dom.CHARACTER_UNIT, 1);
	
			// If we are deleting into a no tracking containiner, then remove the content
			if (this._getNoTrackElement(range.startContainer.parentElement)) {
				range._deleteContents();
				return false;
			}
	
			// Handles cases in which the caret is at the start of the block.
			if (ice.dom.isOnBlockBoundary(range.startContainer, range.endContainer, this.element)) {
	
			// If the previous block is empty, remove the previous block.
			if (prevBlockIsEmpty) {
				ice.dom.remove(prevBlock);
				range.collapse();
				return true;
			}
	
			// Merge blocks: If mergeBlocks is enabled, merge the previous and current block.
			if (this.mergeBlocks && ice.dom.is(ice.dom.getBlockParent(prevContainer, this.element), this.blockEl)) {
				// Since the range is moved by character, it may have passed through empty blocks.
				// <p>text {RANGE.START}</p><p></p><p>{RANGE.END} text</p>
				if (prevBlock !== ice.dom.getBlockParent(range.startContainer, this.element)) {
				range.setStart(prevBlock, prevBlock.childNodes.length);
				}
				// The browsers like to auto-insert breaks into empty paragraphs - remove them.
				var elements = ice.dom.getElementsBetween(range.startContainer, range.endContainer)
				for (var i = 0; i < elements.length; i++) {
				ice.dom.remove(elements[i]);
				}
				var startContainer = range.startContainer;
				var endContainer = range.endContainer;
				ice.dom.remove(ice.dom.find(startContainer, 'br'));
				ice.dom.remove(ice.dom.find(endContainer, 'br'));
				return ice.dom.mergeBlockWithSibling(range, ice.dom.getBlockParent(range.endContainer, this.element) || parentBlock);
			}
	
			// If the previous Block ends with a stub element, set the caret behind it.
			if (prevBlock && prevBlock.lastChild && ice.dom.isStubElement(prevBlock.lastChild)) {
				range.setStartAfter(prevBlock.lastChild);
				range.collapse(true);
				return true;
			}
	
			// Place the caret at the end of the previous block.
			lastSelectable = range.getLastSelectableChild(prevBlock);
			if (lastSelectable) {
				range.setStart(lastSelectable, lastSelectable.data.length);
				range.collapse(true);
			} 
			else if (prevBlock) {
				range.setStart(prevBlock, prevBlock.childNodes.length);
				range.collapse(true);
			}
	
			return true;
			}
	
			var entireTextNode = range.startContainer,
				deletedCharacter = entireTextNode.splitText(range.startOffset - 1),
				remainingTextNode = deletedCharacter.splitText(1);
	
			return this._addNodeTracking(deletedCharacter, range, true);
	
		},
	
		// Marks text and other nodes for deletion
		// compared OK
		_addNodeTracking: function (contentNode, range, moveLeft) {
	
			var contentAddNode = this._getIceNode(contentNode, 'insertType');
	
			if (contentAddNode && this._currentUserIceNode(contentAddNode)) {
				if (range && moveLeft) {
					range.selectNode(contentNode);
				}
				contentNode.parentNode.removeChild(contentNode);
				var cleanNode = ice.dom.cloneNode(contentAddNode);
				ice.dom.remove(ice.dom.find(cleanNode, '.iceBookmark'));
				// Remove a potential empty tracking container
				if (contentAddNode !== null && (ice.dom.hasNoTextOrStubContent(cleanNode[0]))) {
					var newstart = this.env.document.createTextNode('');
					ice.dom.insertBefore(contentAddNode, newstart);
					if (range) {
						range.setStart(newstart, 0);
						range.collapse(true);
					}
					ice.dom.replaceWith(contentAddNode, ice.dom.contents(contentAddNode));
				}
		
				return true;
	
			} 
			else if (range && this._getIceNode(contentNode, 'deleteType')) {
			// It if the contentNode a text node, unite it with text nodes before and after it.
				this._normalizeNode(contentNode);// dfl - support ie8
		
				var found = false;
				if (moveLeft) {
					// Move to the left until there is valid sibling.
					var previousSibling = ice.dom.getPrevContentNode(contentNode, this.element);
					while (!found) {
						ctNode = this._getIceNode(previousSibling, 'deleteType');
						if (!ctNode) {
							found = true;
						} else {
							previousSibling = ice.dom.getPrevContentNode(previousSibling, this.element);
						}
					}
					if (previousSibling) {
						var lastSelectable = range.getLastSelectableChild(previousSibling);
						if (lastSelectable) {
							previousSibling = lastSelectable;
						}
						range.setStart(previousSibling, ice.dom.getNodeCharacterLength(previousSibling));
						range.collapse(true);
					}
					return true;
				} else {
					// Move the range to the right until there is valid sibling.
		
					var nextSibling = ice.dom.getNextContentNode(contentNode, this.element);
					while (!found) {
					ctNode = this._getIceNode(nextSibling, 'deleteType');
					if (!ctNode) {
						found = true;
					} else {
						nextSibling = ice.dom.getNextContentNode(nextSibling, this.element);
					}
					}
		
					if (nextSibling) {
					range.selectNodeContents(nextSibling);
					range.collapse(true);
					}
					return true;
				}
	
			}
			// Webkit likes to insert empty text nodes next to elements. We remove them here.
			if (contentNode.previousSibling && contentNode.previousSibling.nodeType === ice.dom.TEXT_NODE && contentNode.previousSibling.length === 0) {
				contentNode.parentNode.removeChild(contentNode.previousSibling);
			}
			if (contentNode.nextSibling && contentNode.nextSibling.nodeType === ice.dom.TEXT_NODE && contentNode.nextSibling.length === 0) {
				contentNode.parentNode.removeChild(contentNode.nextSibling);
			}
			var prevDelNode = this._getIceNode(contentNode.previousSibling, 'deleteType');
			var nextDelNode = this._getIceNode(contentNode.nextSibling, 'deleteType');
			var ctNode;
	
			if (prevDelNode && this._currentUserIceNode(prevDelNode)) {
				ctNode = prevDelNode;
				ctNode.appendChild(contentNode);
				if (nextDelNode && this._currentUserIceNode(nextDelNode)) {
					var nextDelContents = ice.dom.extractContent(nextDelNode);
					ice.dom.append(ctNode, nextDelContents);
					nextDelNode.parentNode.removeChild(nextDelNode);
				}
			} 
			else if (nextDelNode && this._currentUserIceNode(nextDelNode)) {
				ctNode = nextDelNode;
				ctNode.insertBefore(contentNode, ctNode.firstChild);
			} 
			else {
				ctNode = this._createIceNode('deleteType');
				contentNode.parentNode.insertBefore(ctNode, contentNode);
				ctNode.appendChild(contentNode);
			}
	
			if (range) {
				if (ice.dom.isStubElement(contentNode)) {
					range.selectNode(contentNode);
				} else {
					range.selectNodeContents(contentNode);
				}
				if (moveLeft) {
					range.collapse(true);
				} else {
					range.collapse();
				}
				this._normalizeNode(contentNode); // dfl - support ie8
			}
			return true;
	
		},
	
	
		/**
		 * Handles arrow, delete key events, and others.
		 *
		 * @param {JQuery Event} e The event object.
		 * return {void|boolean} Returns false if default event needs to be blocked.
		 * @private
		 */
		_handleAncillaryKey: function (e) {
			var key = e.keyCode ? e.keyCode : e.which,
	    		browser = this._browser,
				preventDefault = true,
				shiftKey = e.shiftKey,
				self = this,
				range = self.getCurrentRange();
			switch (key) {
				case ice.dom.DOM_VK_DELETE:
					preventDefault = this._deleteContents();
					break;
		
				case 46:
					// Key 46 is the DELETE key.
					preventDefault = this._deleteContents(true);
					break;
		
		/* ***********************************************************************************/
		/* BEGIN: Handling of caret movements inside hidden .ins/.del elements on Firefox **/
		/*  *Fix for carets getting stuck in .del elements when track changes are hidden  **/
				case ice.dom.DOM_VK_DOWN:
				case ice.dom.DOM_VK_UP:
				case ice.dom.DOM_VK_LEFT:
					if(browser["type"] === "mozilla"){
						if(!this.visible(range.startContainer)){
							// if Previous sibling exists in the paragraph, jump to the previous sibling
							if(range.startContainer.parentNode.previousSibling){
								// When moving left and moving into a hidden element, skip it and go to the previousSibling
								range.setEnd(range.startContainer.parentNode.previousSibling, 0);
								range.moveEnd(ice.dom.CHARACTER_UNIT, ice.dom.getNodeCharacterLength(range.endContainer));
								range.collapse(false);
							}
							// if Previous sibling doesn't exist, get out of the hidden zone by moving to the right
							else {
								range.setEnd(range.startContainer.parentNode.nextSibling, 0);
								range.collapse(false);
							}
						}
					  }	
			          preventDefault = false;
			          break;
				case ice.dom.DOM_VK_RIGHT:
					if(browser["type"] === "mozilla"){
						if(!this.visible(range.startContainer)){
							if(range.startContainer.parentNode.nextSibling){
								// When moving right and moving into a hidden element, skip it and go to the nextSibling
								range.setStart(range.startContainer.parentNode.nextSibling,0);
								range.collapse(true);
							}
						}
					}
					preventDefault = false;
					break;
		/* END: Handling of caret movements inside hidden .ins/.del elements ***************/
		/* ***********************************************************************************/
// dfl deleted space handling code
/*				case 32:
					preventDefault = true;
					var range = this.getCurrentRange();
					this._moveRangeToValidTrackingPos(range, range.startContainer);
					this.insert('\u00A0' , range);
					break; */
				default:
					// Ignore key.
					preventDefault = false;
					break;
			} //end switch
	
			if (preventDefault === true) {
				ice.dom.preventDefault(e);
				return false;
			}
			return true;
	
		},
	
		// compared OK
		keyDown: function (e) {
			var preventDefault = false;
	
			if (this._handleSpecialKey(e) === false) {
				if (ice.dom.isBrowser('msie') !== true) {
					this._preventKeyPress = true;
				}
		
				return false;
			} 
	
			switch (e.keyCode) {
				case 27:
					// ESC
					break;
				default:
					// If not Firefox then check if event is special arrow key etc.
					// Firefox will handle this in keyPress event.
					if (! this._browser.firefox) {
						preventDefault = !(this._handleAncillaryKey(e));
					}
					break;
			}
	
			if (preventDefault) {
				ice.dom.preventDefault(e);
				return false;
			}
	
			return true;
		},
	// compared OK
		keyPress: function (e) {
			if (this._preventKeyPress === true) {
				this._preventKeyPress = false;
				return;
			}
			var c = null;
			if (e.which == null) {
			// IE.
				c = String.fromCharCode(e.keyCode);
			} 
			else if (e.which > 0) {
				c = String.fromCharCode(e.which);
			}
	
			if (e.ctrlKey || e.metaKey) {
				return true;
			}
	
			// Inside a br - most likely in a placeholder of a new block - delete before handling.
			var range = this.getCurrentRange(),
				br = range && ice.dom.parents(range.startContainer, 'br')[0] || null;
			if (br) {
				range.moveToNextEl(br);
//				br.parentNode.removeChild(br);
			}
	
			// Ice will ignore the keyPress event if CMD or CTRL key is also pressed
			if (c !== null && e.ctrlKey !== true && e.metaKey !== true) {
				var key = e.keyCode ? e.keyCode : e.which;
    		    switch (key) {
					case ice.dom.DOM_VK_DELETE:
//					case 32: // space
					// Handle delete key for Firefox.
						return this._handleAncillaryKey(e);
					case ice.dom.DOM_VK_ENTER:
						return this._handleEnter();
					default:
						// If we are in a deletion, move the range to the end/outside.
						return this.insert();
				}
			}
	
			return this._handleAncillaryKey(e);
		},
	
		// compared OK
		_handleEnter: function () {
			var range = this.getCurrentRange();
			if (range && !range.collapsed) {
				this._deleteContents();
			}
			return true;
		},
	// compared OK
		_handleSpecialKey: function (e) {
			var keyCode = e.which;
			if (keyCode === null) {
			// IE.
				keyCode = e.keyCode;
			}
	
			var preventDefault = false;
			switch (keyCode) {
			case 65:
				// added by dfl
				if (! this._handleSelectAll) {
					return true;
				}
				// Check for CTRL/CMD + A (select all).
				if (e.ctrlKey === true || e.metaKey === true) {
					preventDefault = true;
					var range = this.getCurrentRange();
		
					if (ice.dom.isBrowser('msie') === true) {
						var selStart = this.env.document.createTextNode('');
						var selEnd = this.env.document.createTextNode('');
		
						if (this.element.firstChild) {
						ice.dom.insertBefore(this.element.firstChild, selStart);
						} else {
						this.element.appendChild(selStart);
						}
		
						this.element.appendChild(selEnd);
		
						range.setStart(selStart, 0);
						range.setEnd(selEnd, 0);
					} else {
						range.setStart(range.getFirstSelectableChild(this.element), 0);
						var lastSelectable = range.getLastSelectableChild(this.element);
						range.setEnd(lastSelectable, lastSelectable.length);
					} //end if
		
					this.selection.addRange(range);
				} //end if
				break;
			case 120:
			case 88:
/*				if (e.ctrlKey === true || e.metaKey === true) {
					ice.dom.preventDefault(e);
					this.hostMethods.hostCopy();
					this._deleteContents();
					return false;
				} */
	
			default:
				// Not a special key.
				break;
			} //end switch
	
			if (preventDefault === true) {
				ice.dom.preventDefault(e);
				return false;
			}
	
			return true;
		},
	
		/* Added by dfl */
		
		/**
		 * Returns the top level DOM element handled by this change tracker
		 */
		getContentElement: function() {
			return this.element;
		},
		
		_getIceNodes : function() {
			var classList = [];
			var self = this;
			ice.dom.each(this.changeTypes, 
				function (type, i) {
					classList.push('.' + self._getIceNodeClass(type));
				});
			classList = classList.join(',');
			return jQuery(this.element).find(classList);
		},
		
		/**
		 * Returns the first ice node in the hierarchy of the given node, or the current collapsed range.
		 * null if not in a track changes hierarchy
		 */
		currentChangeNode: function (node) {
			var selector = '.' + this._getIceNodeClass('insertType') + ', .' + this._getIceNodeClass('deleteType');
			if (!node) {
				var range = this.getCurrentRange();
				if (!range || !range.collapsed) {
					return false;
				}
				else {
					node = range.startContainer;
				}
			}
			return ice.dom.getNode(node, selector);
		},
		
		setShowChanges : function(bShow) {
			bShow = !! bShow;
			this._isVisible = bShow;
			var $body = jQuery(this.element);
			$body.toggleClass("ICE-Tracking", bShow);
			this._showTitles(bShow);
			this._updateTooltipsState();
		},
	
		reload : function() {
			this._loadFromDom();
		},
		
		hasChanges : function() {
			for (var key in this._changes) {
				var change = this._changes[key];
				if (change && change.type) {
					return true;
				}
			}
			return false;
		},
		
		countChanges : function(options) {
			var changes = this._filterChanges(options);
			return changes.count;
		},
		
		setChangeData : function(data) {
			if (null == data || (typeof data == "undefined")) {
				data = "";
			}
			this._changeData = String(data);
		},
		
		getDeleteClass : function() {
			return this._getIceNodeClass('deleteType');
		},
		
		toString : function() {
			return "ICE " + ((this.element && this.element.id) || "(no element id)");
		},
		
		_splitNode: function(node, atNode, atOffset) {
			var parent = node.parentNode,
			  	parentOffset = rangy.dom.getNodeIndex(node),
			  	doc = atNode.ownerDocument, 
			  	leftRange = doc.createRange(),
			  	left;
			  leftRange.setStart(parent, parentOffset);
			  leftRange.setEnd(atNode, atOffset);
			  left = leftRange.extractContents();
			  parent.insertBefore(left, node);
			  return node.previousSibling;
		},
		
		_triggerChange : function() {
			this.$this.trigger("change");
		},
	
		_triggerChangeText : function() {
			this.$this.trigger("textChange");
		},
		
		_updateNodeTooltip: function(node) {
			if (this.tooltips && this._isTracking && this._isVisible) {
				this._addTooltip(node);
			}
		},
	
		_acceptRejectSome : function(options, isAccept) {
			var f = (function(index, node) {
				this.acceptRejectChange(node, isAccept);
			}).bind(this);
			var changes = this._filterChanges(options);
			for (var id in changes.changes) {
				var nodes = ice.dom.find(this.element, '[' + this.attributes.changeId + '=' + id + ']');
				nodes.each(f);
			}
			if (changes.count) {
				this._triggerChange();
			}
		},
		
		/**
		 * Filters the current change set based on options
		 * @param options may contain one of:
		 * exclude: an array of user ids to exclude, include: an array of user ids to include
		 * and
		 * filter: a filter function of the form function({userid, time, data}):boolean
		 *	 @return an object with two members: count, changes (map of id:changeObject)
		 * @private
		 */
		_filterChanges : function(options) {
			var count = 0, changes = {};
			var filter = options && options.filter;
			var exclude = options && options.exclude ? jQuery.map(options.exclude, function(e) { return String(e); }) : null;
			var include = options && options.include ? jQuery.map(options.include, function(e) { return String(e); }) : null;
			for (var key in this._changes) {
				var change = this._changes[key];
				if (change && change.type) {	
					var skip = (filter && ! filter({userid: change.userid, time: change.time, data:change.data})) || 
						(exclude && exclude.indexOf(change.userid) >= 0) ||
						(include && include.indexOf(change.userid) < 0);
					if (! skip) {
						++count;
						changes[key] = change;
					}
				}
			}
			
			return { count : count, changes : changes };
		},
		
		_loadFromDom : function() {
			this._changes = {};
//			this._userStyles = {};
//			this._styles = {};
			this._uniqueStyleIndex = 0;
			var myUserId = this.currentUser && this.currentUser.id;
			var myUserName = (this.currentUser && this.currentUser.name) || "";
			var now = (new Date()).getTime();
			// Grab class for each changeType
			var changeTypeClasses = [];
			for (var changeType in this.changeTypes) {
				changeTypeClasses.push(this._getIceNodeClass(changeType));
			}
	
			var nodes = this._getIceNodes();
			function f(i, el) {
				var styleIndex = 0;
				var ctnType = '';
				var classList = el.className.split(' ');
				//TODO optimize this - create a map of regexp
				for (var i = 0; i < classList.length; i++) {
					var styleReg = new RegExp(this.stylePrefix + '-(\\d+)').exec(classList[i]);
					if (styleReg) styleIndex = styleReg[1];
					var ctnReg = new RegExp('(' + changeTypeClasses.join('|') + ')').exec(classList[i]);
					if (ctnReg) ctnType = this._getChangeTypeFromAlias(ctnReg[1]);
				}
				var userid = ice.dom.attr(el, this.attributes.userId);
				var userName;
				if (myUserId && (userid == myUserId)) {
					userName = myUserName;
					el.setAttribute(this.attributes.userName, myUserName)
				}
				else {
					userName = el.getAttribute(this.attributes.userName);
				}
				this._setUserStyle(userid, Number(styleIndex));
				var changeid = parseInt(ice.dom.attr(el, this.attributes.changeId) || "");
				if (isNaN(changeid)) {
					changeid = this.getNewChangeId();
					el.setAttribute(this.attributes.changeId, changeid);
				}
				var timeStamp = parseInt(el.getAttribute(this.attributes.time) || "");
				if (isNaN(timeStamp)) {
					timeStamp = now;
				}
				var changeData = ice.dom.attr(el, this.attributes.changeData) || "";
				var change = {
					type: ctnType,
					userid: String(userid),// dfl: must stringify for consistency - when we read the props from dom attrs they are strings
					username: userName,
					time: timeStamp,
					data : changeData
				};
				this._changes[changeid] = change;
				this._updateNodeTooltip(el);
			}
			nodes.each(f.bind(this));
			this._triggerChange();
		},
		
		_updateUserData : function(user) {
			if (user) {
				for (var key in this._changes) {
					var change = this._changes[key];
					if (change.userid == user.id) {
						change.username = user.name;
					}
				}
			}
			var nodes = this._getIceNodes();
			nodes.each((function(i,node) {
				var match = (! user) || (user.id == node.getAttribute(this.attributes.userId));
				if (user && match) {
					node.setAttribute(this.userNameAttribute, user.name);
				}
			}).bind(this));
		},
		
		_showTitles : function(bShow) {
			var nodes = this._getIceNodes();
			if (bShow) {
				jQuery(nodes).each((function(i, node) {
					this._updateNodeTooltip(node);
				}).bind(this));
			}
			else {
				jQuery(nodes).removeAttr("title");
			}
		},
		
		_updateTooltipsState: function() {
			if (this.tooltips && this._isTracking && this._isVisible) {
				if (! this._showingTips) {
					this._showingTips = true;
					var $nodes = this._getIceNodes(),
						self = this;
					$nodes.each(function(i, node) {
						self._addTooltip(node);
					});					
				}
			}
			else if (this._showingTips) {
				this._showingTips = false;
				var $nodes = this._getIceNodes();
				$nodes.each(function(i, node) {
					jQuery(node).unbind("mouseover").unbind("mouseout");
				});					
			}
		},
		
		_addTooltip: function(node) {
			jQuery(node).unbind("mouseover").unbind("mouseout").mouseover(this._tooltipMouseOver).mouseout(this._tooltipMouseOut);
		},
		
		_tooltipMouseOver: function(event) {
			var node = event.currentTarget,
				$node = jQuery(node),
				self = this;
			if (! $node.data("_tooltip_t")) {
				var to = setTimeout(function() {
					var cid = $node.attr(self.attributes.changeId),
						change = self.getChange(cid);
					if (change) {
						$node.removeData("_tooltip_t");
						self.hostMethods.showTooltip(node, jQuery.extend({}, change));
					}
				}, this.tooltipsDelay);
				$node.data("_tooltip_t", to);
			}
		},
		
		_tooltipMouseOut: function(event) {
			var node = event.currentTarget,
				$node = jQuery(node),
				to = $node.data("_tooltip_t");
			$node.removeData("_tooltip_t");
			if (to) {
				clearTimeout(to);
			}
			else {
				this.hostMethods.hideTooltip(node);
			}
		},
		
		 _normalizeNode : function(node) {
			if (! node) {
				return;
			}
			if (typeof node.normalize == "function") {
				return node.normalize();
			}
			return this._myNormalizeNode(node);
		},
	
		_myNormalizeNode : function(node) {
			if (! node) {
				return;
			}
			var ELEMENT_NODE = 1;
			var TEXT_NODE = 3;
			var child = node.firstChild;
			while (child) {
				if (child.nodeType == ELEMENT_NODE) {
					this._myNormalizeNode(child);
				}
				else if (child.nodeType == TEXT_NODE) { 
					var next;
					while ((next = child.nextSibling) && next.nodeType == TEXT_NODE) { 
						var value = next.nodeValue;
						if (value != null && value.length) {
							child.nodeValue = child.nodeValue + value;
						}
						node.removeChild(next);
					}
				}
				child = child.nextSibling;
			}
		}

	};

	exports.ice = this.ice || {};
	exports.ice.InlineChangeEditor = InlineChangeEditor;

}).call(this);
