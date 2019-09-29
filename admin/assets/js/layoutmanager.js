(function(window) {
	var sortable,
		slice = function(arr, start, end) {
			return Array.prototype.slice.call(arr, start, end)
		},
		dragE;


	function disabledEventPropagation(event) {
		if (event.stopPropagation) {
			event.stopPropagation();
		} else if (window.event) {
			window.event.cancelBubble = true;
		}
	}

	function initDraggableObject_dragstart(e) {
		//FireFox insists that the dataTranfer has been set
		e.dataTransfer.setData('Text', '');
		e.dataTransfer.dropEffect = 'copy';
		dragEl = this;
		elDropHandled = false;
		newMuraObject = false;
		muraLooseDropTarget = null;
		MuraInlineEditor.sidebarAction('showobjects');
		Mura('.mura-object-selected').removeClass('mura-object-selected');
		Mura(this).addClass('mura-object-selected');
	}

	function initDraggableObject_dragend() {
		dragEl = null;
		elDropHandled = false;
		newMuraObject = false;
		Mura('.mura-object-selected').removeClass('mura-object-selected');
	}

	function initDraggableObject_dragover(e) {
		e.preventDefault();
		e.dataTransfer.dropEffect = 'copy';

		if (dragEl || newMuraObject) {
			var prev = Mura('.mura-drop-target');
			muraLooseDropTarget = this;

			if (prev.length) {
				prev
					.removeClass('mura-drop-target')
					.removeClass('mura-append')
					.removeClass('mura-prepend');

				if (!prev.attr('class')) {
					prev.removeAttr('class');
				}
			}

			Mura(this)
				.addClass('mura-drop-target')
				.addClass('mura-' + getDropDirection(e, this));

		}
	}

	function initDraggableObject_dragleave(e) {
		Mura(this)
			.removeClass('mura-drop-target')
			.removeClass('mura-append')
			.removeClass('mura-prepend');

		muraLooseDropTarget = null;
		if (!Mura(this).attr('class')) {
			Mura(this).removeAttr('class');
		}
	}

	function getDropDirection(e, target) {
		var targetRect = target.getBoundingClientRect();
		var elemTop = targetRect.top;
		var elemBottom = targetRect.bottom;
		var divide = ((elemBottom - elemTop) / 2) + elemTop;

		if (e.clientY > divide) {
			return 'append';
		} else {
			return 'prepend';
		}

	}

	function initDraggableObject_drop(e) {

		var target = Mura('.mura-drop-target').node;

		if (target) {
			if (dragEl || newMuraObject) {
				if (dragEl && dragEl != this) {

					var dropDirection = getDropDirection(e, target);

					if (target.getAttribute('data-object') == 'container') {
						var container = Mura(target).children('.mura-object-content');
						if (container.length) {
							if (!container.node.childNodes.length) {
								container.append(dragEl);
							} else {
								container[dropDirection](dragEl);
							}
						} else {
							return;
						}
					} else {
						if (dropDirection == 'append') {
							target.parentNode.insertBefore(dragEl, target.nextSibling);
						} else {
							target.parentNode.insertBefore(dragEl, target);
						}
					}
					//dragEl.setAttribute('data-droptarget',Mura(this).getSelector());
					Mura('#adminSave').show();
					Mura(target).closest('.mura-region-local').data('dirty', true);
					elDropHandled = true;
					disabledEventPropagation(e);
				} else if (dragEl == target) {
					elDropHandled = true;
					disabledEventPropagation(e);
				}

				checkForNew.call(target, e);

			}
		}


		Mura('.mura-drop-target')
			.removeClass('mura-drop-target')
			.removeClass('mura-append')
			.removeClass('mura-prepend');

		muraLooseDropTarget = null;
		newMuraObject = false;

		if (!Mura(target).attr('class')) {
			Mura(target).removeAttr('class');
		}

	}

	function initDraggableObject_hoverin(e){
		//e.stopPropagation();
		Mura('.mura-active-target').removeClass('mura-active-target');
		var self = Mura(this);
		if (!self.hasClass('mura-object-selected')) {
			Mura(this).addClass('mura-active-target');
		}
	}

	function initDraggableObject_hoverout(e){
		//e.stopPropagation();
		Mura(this).removeClass('mura-active-target').calculateDisplayObjectStyles();

	}

	function initDraggableObject(item) {
		var obj=Mura(item);

		if(obj.data('object')=='container'){
			var EventListenerOptions=true;
		} else {
			var EventListenerOptions;
		}
		
		obj
			.off('dragenter', initDraggableObject_dragstart)
			.off('dragover', initDraggableObject_dragover)
			.off('drop', initDraggableObject_drop)
			.off('dragleave', initDraggableObject_dragleave)
			.on('dragstart', initDraggableObject_dragstart)
			.on('dragend', initDraggableObject_dragend)
			.on('dragover', initDraggableObject_dragover)
			.on('dragleave', initDraggableObject_dragleave)
			.on('drop', initDraggableObject_drop).attr('draggable', true)
			.hover(
				initDraggableObject_hoverin,
				initDraggableObject_hoverout,
				EventListenerOptions
			);
	}

	function applyObjectTargetClass(item, e, This) {
		if (item.closest('.mura-region').length) {
			var parentObj = item.parent().closest('.mura-object');

			while (parentObj.length && parentObj.data('object') != 'container') {
				item = parentObj;
				parentObj = parentObj.parent().closest('.mura-object');
			}

			if (item.length) {
				item
					.addClass('mura-drop-target')
					.addClass('mura-' + getDropDirection(e, This));
			}
		}
	}

	function initLooseDropTarget_dragenter(e) {
		e.preventDefault();
		//disabledEventPropagation(e)
		e.dataTransfer.dropEffect = 'copy';

		if (!Mura('.mura-drop-target').length && (dragEl || newMuraObject)) {

			var item = Mura(this).closest(".mura-object");

			if (item.length) {
				applyObjectTargetClass(item, e, this);
			} else {
				Mura(this)
					.addClass('mura-drop-target')
					.addClass('mura-' + getDropDirection(e, this));
			}

		}


	}

	function initLooseDropTarget_dragover(e) {

		e.preventDefault();

		if (dragEl || newMuraObject) {
			var prev = Mura('.mura-drop-target');
			muraLooseDropTarget = this;

			if (prev.length) {
				prev
					.removeClass('mura-drop-target')
					.removeClass('mura-append')
					.removeClass('mura-prepend');

				if (!prev.attr('class')) {
					prev.removeAttr('class');
				}
			}

			var item = Mura(this).closest('.mura-object');

			if (item.length) {
				applyObjectTargetClass(item, e, this);
			} else {
				item = Mura(this).closest('.mura-object');

				if (item.length) {
					item
						.addClass('mura-drop-target')
						.addClass('mura-' + getDropDirection(e, this));
				} else {
					Mura(this)
						.addClass('mura-drop-target')
						.addClass('mura-' + getDropDirection(e, this));;
				}
			}

		}
	}

	function initLooseDropTarget_dragleave(e) {
		Mura(this)
			.removeClass('mura-drop-target')
			.removeClass('mura-append')
			.removeClass('mura-prepend');

		muraLooseDropTarget = null;
		if (!Mura(this).attr('class')) {
			Mura(this).removeAttr('class');
		}
	}

	function initLooseDropTarget_drop(e) {
		disabledEventPropagation(e);

		if (dragEl || newMuraObject) {

			var target = Mura('.mura-drop-target').node;

			if (target) {

				if (dragEl && dragEl != target) {
					var dropDirection = getDropDirection(e, target);

					if (target.getAttribute('data-object') == 'container') {
						var container = Mura(target).children('.mura-object-content');
						if (!container.node.childNodes.length) {
							container.append(dragEl);
						} else {
							container[dropDirection](dragEl);
						}
					} else {
						try {
							if (dropDirection == 'append') {
								target.parentNode.insertBefore(dragEl, target.nextSibling);
							} else {
								target.parentNode.insertBefore(dragEl, target);
							}
						} catch (e) {};
					}

					var mDragEl = Mura(dragEl);
					Mura('#adminSave').show();
					mDragEl.addClass('mura-async-object');

					if (!(mDragEl.data('object') == 'text' && mDragEl.data('render') ==
							'client' && mDragEl.data('async') == 'false')) {
						mDragEl.data('async', true);
					}

					Mura(target).closest('.mura-region-local').data('dirty', true);

					if(Mura(target).hasClass('mura-object')){
						initDraggableObject(target);
					} else {
						initLooseDropTarget(this)
					}
					elDropHandled = true;
					disabledEventPropagation(e);

				} else if (dragEl == target) {
					elDropHandled = true;
					disabledEventPropagation(e);
				}

				checkForNew.call(target, e);

			}

		}

		Mura('.mura-drop-target')
			.removeClass('mura-drop-target')
			.removeClass('mura-append')
			.removeClass('mura-prepend');

		muraLooseDropTarget = null;
		newMuraObject = false;

		if (!Mura(this).attr('class')) {
			Mura(this).removeAttr('class');
		}
	}

	function initLooseDropTarget(item) {
		Mura(item)
			.off('dragenter', initLooseDropTarget_dragenter)
			.off('dragover', initLooseDropTarget_dragover)
			.off('drop', initLooseDropTarget_drop)
			.off('dragleave', initLooseDropTarget_dragleave)
			.on('dragenter', initLooseDropTarget_dragenter)
			.on('dragover', initLooseDropTarget_dragover)
			.on('dragleave', initLooseDropTarget_dragleave)
			.on('drop', initLooseDropTarget_drop);
	}

	function initClassObjects() {
		Mura(".mura-objectclass").each(function() {
			var item = Mura(this);

			if (!item.data('inited')) {
				item.attr('draggable', true);

				item.on('dragstart', function(e) {
						dragEl = null;
						elDropHandled = false;
						newMuraObject = true;
						muraLooseDropTarget = null;
						Mura('#dragtype').html(item.data('object'));
						Mura('.mura-sidebar').addClass('mura-sidebar--dragging');

						e.dataTransfer.setData("text", JSON.stringify({
							object: item.data('object'),
							objectname: item.data('objectname'),
							objectid: item.data('objectid'),
							objecticonclass: item.data('objecticonclass'),
						}));
					})
					.on('dragend', function() {
						Mura('#dragtype').html('');
						dragEl = null;
						elDropHandled = false;
						newMuraObject = false;
						Mura('.mura-sidebar').removeClass('mura-sidebar--dragging');
					});

				item.data('inited', true);
			}

		});
	}

	function checkForNew(e) {
		e.preventDefault();

		if (e.stopPropagation) {
			e.stopPropagation();
		}

		var object = e.dataTransfer.getData("text");

		if (object != '') {
			try {
				object = JSON.parse(object);
			} catch (e) {
				object = '';
			}
		}

		if (typeof object == 'object' && object.object) {

			var displayObject = document.createElement("DIV");
			displayObject.setAttribute('data-object', object.object);
			displayObject.setAttribute('data-objectname', object.objectname);
			displayObject.setAttribute('data-objecticonclass', object.objecticonclass);
			displayObject.setAttribute('data-async', true);
			displayObject.setAttribute('data-perm', 'author');
			displayObject.setAttribute('data-instanceid', Mura.createUUID());
			displayObject.setAttribute('class',
				'mura-async-object mura-object mura-active');

			if (object.objectid) {
				displayObject.setAttribute('data-objectid', object.objectid);
			} else {
				displayObject.setAttribute('data-objectid', Mura.createUUID());
			}

			var target = Mura(this);

			var dropDirection = getDropDirection(e, this);

			if (target.hasClass('mura-object')) {
				if (this.getAttribute('data-object') == 'container') {
					var container = target.children('.mura-object-content');
					if (!container.node.childNodes.length) {
						container.append(displayObject);
					} else {
						container[dropDirection](displayObject);
					}
				} else {
					if (dropDirection == 'append') {
						this.parentNode.insertBefore(displayObject, this.nextSibling);
					} else {
						this.parentNode.insertBefore(displayObject, this);
					}
				}
			} else if (target.hasClass('mura-region-local')) {
				this.appendChild(displayObject);
			} else {
				if (dropDirection == 'append') {
					this.parentNode.insertBefore(displayObject, this.nextSibling);
				} else {
					this.parentNode.insertBefore(displayObject, this);
				}
			}

			initDraggableObject(displayObject);
			openFrontEndToolsModal(displayObject, true);
			Mura.processAsyncObject(displayObject);

			Mura(displayObject).closest('.mura-region-local').data('dirty', true);
			Mura(displayObject).on('dragover', function() {})
			Mura('#adminSave').show();
			disabledEventPropagation(e);

		}

	}

	function loadObjectClass(siteid, classid, subclassid, contentid, parentid,
		contenthistid) {
		var pars =
			'muraAction=cArch.loadclass&compactDisplay=true&layoutmanager=true&siteid=' +
			siteid + '&classid=' + classid + '&subclassid=' + subclassid +
			'&contentid=' + contentid + '&parentid=' + parentid + '&cacheid=' + Math.random();

		if (classid == 'plugins') {
			var d = Mura('#pluginList');
		} else {
			var d = Mura('#classList');

			Mura('#classListContainer').show();
		}

		d.html(Mura.preloaderMarkup);

		Mura.ajax({
			url: Mura.adminpath + "?" + pars,
			success: function(data) {
				d.html(data);
				initClassObjects();
			}
		});

		return false;
	}

	function initLayoutManager(el) {

		Mura.loader().loadjs(
			Mura.adminpath + '/assets/js/ios-drag-drop.js',
			function() {
				if (el) {
					var obj = (el.node) ? el : Mura(el);
					el = el.node || el;
				} else {
					var obj = Mura('body');
					el = obj.node;

					initClassObjects();

					Mura('body')
						.removeClass('mura-sidebar-state__hidden--right')
						.addClass('mura-sidebar-state__pushed--right');
				}

				var iframe = Mura('#frontEndToolsSidebariframe');

				//iframe.attr('src',iframe.data('preloadsrc'));

				Mura('label.mura-editable-label').show()

				obj.find('.mxp-editable').each(function() {
					var item = Mura(this);

					if (!item.hasClass('mura-region-local')) {
						item.addClass('mura-region-local');
						item.data('inited', false);
						item.data('loose', true);
						item.data('perm', 'editor');
					}
				});

				obj.find('.mura-region-local[data-inited="false"]').each(function() {

					var region = Mura(this);

					if (!region.data('loose') || (region.data('loose') && (region.html() ==
							'<p></p>') || Mura.trim(region.html()) == '')) {
						region
							.on('drop', initRegion_drop)
							.on('dragover', initRegion_dragover)
							.data('inited', 'true');

					}
				});

				obj.find('.mura-region-local .mura-object').each(function() {
					initDraggableObject(this)
				});

				obj.find(
					'.mura-object[data-object="container"], .mura-region-local div, .mura-region-local[data-loose="true"] p, .mura-region-local[data-loose="true"] h1, .mura-region-local[data-loose="true"] h2, .mura-region-local[data-loose="true"] h3, .mura-region-local[data-loose="true"] h4, .mura-region-local[data-loose="true"] img, .mura-region-local[data-loose="true"] table, .mura-region-local[data-loose="true"] article, .mura-region-local[data-loose="true"] dl'
				).each(function() {
					initLooseDropTarget(this)
				});

				obj.find('.mura-body-object')
					.hover(
						initDraggableObject_hoverin,
						initDraggableObject_hoverout
					);
			});

	}

	function initRegion_dragover(e){
		e.preventDefault();
		e.dataTransfer.dropEffect = 'copy';
	}

	function initRegion_drop(e){
		var dropParent, dropIndex, dragIndex;

		e.preventDefault();

		if (Mura(this).find('.mura-object').length) {
			return;
		}

		if (e.stopPropagation) {
			e.stopPropagation();
		}

		if (dragEl && dragEl !== this) {
			dropParent = this.parentNode;
			dragIndex = slice(dragEl.parentNode.children).indexOf(dragEl);
			dropIndex = slice(this.parentNode.children).indexOf(this);
			if (this.parentNode === dragEl.parentNode && dropIndex >
				dragIndex) {
				dropParent.insertBefore(dragEl, this.nextSibling);
			} else {
				this.appendChild(dragEl);
			}

			Mura('#adminSave').show();
			Mura(dragEl).data('async', true);
			Mura(dragEl).addClass('mura-async-object');
			Mura(this).data('dirty', true);
			elDropHandled = true;
			disabledEventPropagation(e);
		} else if (dragEl == this) {
			elDropHandled = true;
			disabledEventPropagation(e);
		}

		checkForNew.call(this, e);

		muraLooseDropTarget = null;
		Mura('.mura-drop-target')
			.removeClass('mura-drop-target')
			.removeClass('mura-append')
			.removeClass('mura-prepend');

		return true;
	}
	function deInitLayoutManager(){
		Mura.editing=false;

		Mura('body').addClass('mura-sidebar-state__hidden--right');
		Mura('body').removeClass('mura-sidebar-state__pushed--right');

		Mura('.mura-object, .mura-body-object').each(function(){
			Mura(this)
				.off('dragenter', initDraggableObject_dragstart)
				.off('dragover', initDraggableObject_dragover)
				.off('drop', initDraggableObject_drop)
				.off('dragleave', initDraggableObject_dragleave)
				.off('dragstart', initDraggableObject_dragstart)
				.off('dragend', initDraggableObject_dragend)
				.off('mouseover', initDraggableObject_hoverin)
				.off('mouseout', initDraggableObject_hoverout)
				.off('touchstart', initDraggableObject_hoverin)
				.off('touchend', initDraggableObject_hoverout)
				.attr('draggable', false)
				.removeClass('mura-active')
				.removeClass('mura-object-selected')
				.removeClass('mura-object-select')
				.removeClass('mura-active-target')

				Mura('.mura-region-local')
					.off('drop',initRegion_drop)
					.off('dragover',initRegion_dragover)
					.data('inited', 'false')

				Mura('.mura-object[data-object="container"], .mura-region-local div, .mura-region-local[data-loose="true"] p, .mura-region-local[data-loose="true"] h1, .mura-region-local[data-loose="true"] h2, .mura-region-local[data-loose="true"] h3, .mura-region-local[data-loose="true"] h4, .mura-region-local[data-loose="true"] img, .mura-region-local[data-loose="true"] table, .mura-region-local[data-loose="true"] article, .mura-region-local[data-loose="true"] dl')
				.off('dragenter', initLooseDropTarget_dragenter)
				.off('dragover', initLooseDropTarget_dragover)
				.off('drop', initLooseDropTarget_drop)
				.off('dragleave', initLooseDropTarget_dragleave);

				Mura('.mura-editable-attribute')
					.each(function(){
					var attribute=Mura(this);

					if(typeof CKEDITOR != 'undefined' && CKEDITOR.instances[attribute.attr('id')]){
						var instance =CKEDITOR.instances[attribute.attr('id')];
						instance.updateElement();
						instance.destroy(true)
					}

					attribute.attr('contenteditable','false');
					attribute.removeClass('mura-active');
					attribute.data('manualedit',false);
					attribute.off('dblclick')
				})
		})
	}

	Mura.initLayoutManager = initLayoutManager;
	Mura.deInitLayoutManager = deInitLayoutManager;
	Mura.loadObjectClass = loadObjectClass;
	Mura.initLooseDropTarget = initLooseDropTarget;
	Mura.initDraggableObject = initDraggableObject;
	Mura.initDraggableObject_hoverin=initDraggableObject_hoverin;
	Mura.initDraggableObject_hoverout=initDraggableObject_hoverout;

})(window);
