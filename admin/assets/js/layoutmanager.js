(function(window){
		var sortable,
		slice = function (arr, start, end) {
	        return Array.prototype.slice.call(arr, start, end)
	    },
	    dragE;


	    function disabledEventPropagation(event)
		{
		   if (event.stopPropagation){
		       event.stopPropagation();
		   }
		   else if(window.event){
		      window.event.cancelBubble=true;
		   }
		}

		function initDraggableObject_dragstart(e){
			//FireFox insists that the dataTranfer has been set
			e.dataTransfer.setData('Text','');
			e.dataTransfer.dropEffect = 'copy';
			dragEl=this;
			elDropHandled=false;
			newMuraObject=false;
			muraLooseDropTarget=null;
			muraInlineEditor.sidebarAction('showobjects');
			mura('.mura-object-selected').removeClass('mura-object-selected');
			mura(this).addClass('mura-object-selected');
		}

		function initDraggableObject_dragend(){
			dragEl=null;
			elDropHandled=false;
			newMuraObject=false;
			mura('.mura-object-selected').removeClass('mura-object-selected');
		}

		function initDraggableObject_dragover(e){
			e.preventDefault();
			e.dataTransfer.dropEffect = 'copy';

			if(dragEl || newMuraObject){
				var prev=mura('.mura-drop-target');
				muraLooseDropTarget=this;

				if(prev.length){
					prev.removeClass('mura-drop-target');

					if(!prev.attr('class')){
						prev.removeAttr('class');
					}
				}

				mura(this).addClass('mura-drop-target');	
				
			}
		}

		function initDraggableObject_dragleave(e){
			mura(this).removeClass('mura-drop-target');
			muraLooseDropTarget=null;
			if(!mura(this).attr('class')){
				mura(this).removeAttr('class');
			}
		}

		function initDraggableObject_drop(e){
		 
		    var target=mura('.mura-drop-target').node;

		    if(target){
			    if(dragEl || newMuraObject){
					if(dragEl && dragEl != this){
						if(target.getAttribute('data-object')=='container'){
							var container=mura(target).children('.mura-object-content');
							if(container.length){
								container.append(dragEl);
							} else {
								return;
							}
						} else {
							target.parentNode.insertBefore(dragEl,target.nextSibling);
						}	
				    	//dragEl.setAttribute('data-droptarget',mura(this).getSelector());
						mura('#adminSave').show();
						mura(target).closest('.mura-region-local').data('dirty',true);
						elDropHandled=true;
						disabledEventPropagation(e);
					} else if (dragEl==target){
						elDropHandled=true;
						disabledEventPropagation(e);
					}

					checkForNew.call(target,e);

				}
			}


		    mura('.mura-drop-target').removeClass('mura-drop-target');
			muraLooseDropTarget=null;
			newMuraObject=false;

			if(!mura(target).attr('class')){
				mura(target).removeAttr('class');
			}
			
		}

	    function initDraggableObject(item){

			mura(item)
			.off('dragenter',initDraggableObject_dragstart)
			.off('dragover',initDraggableObject_dragover)
			.off('drop',initDraggableObject_drop)
			.off('dragleave',initDraggableObject_dragleave)
			.on('dragstart',initDraggableObject_dragstart)
			.on('dragend',initDraggableObject_dragend)
			.on('dragover',initDraggableObject_dragover)
			.on('dragleave',initDraggableObject_dragleave)
			.on('drop',initDraggableObject_drop).attr('draggable',true)
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

		function initLooseDropTarget_dragenter(e){
			e.preventDefault();
			//disabledEventPropagation(e)
			e.dataTransfer.dropEffect = 'copy';

			if(!mura('.mura-drop-target').length && (dragEl || newMuraObject)){

				var item=mura(this).closest(".mura-object");

				if(item.length){
					item.addClass('mura-drop-target');
				} else {
					mura(this).addClass('mura-drop-target');
				}
				
			}

			
		}

		function initLooseDropTarget_dragover(e){

			e.preventDefault();

			if(dragEl || newMuraObject){
				var prev=mura('.mura-drop-target');
				muraLooseDropTarget=this;

				if(prev.length){
					prev.removeClass('mura-drop-target');

					if(!prev.attr('class')){
						prev.removeAttr('class');
					}
				}

				var item=mura(this).closest('.mura-object[data-object="container"]');

				if(item.length){
					item.addClass('mura-drop-target');
				} else {
					item=mura(this).closest('.mura-object');
					
					if(item.length){
						item.addClass('mura-drop-target');
					} else {
						mura(this).addClass('mura-drop-target');
					}
				}
				
			}
		}

		function initLooseDropTarget_dragleave(e){
			mura(this).removeClass('mura-drop-target');
			muraLooseDropTarget=null;
			if(!mura(this).attr('class')){
				mura(this).removeAttr('class');
			}
		}

		function initLooseDropTarget_drop(e){
		    disabledEventPropagation(e);

		    if(dragEl || newMuraObject){

		    	var target=mura('.mura-drop-target').node;

		    	if(target){

				    if(dragEl && dragEl != target){
				    	if(target.getAttribute('data-object')=='container'){
							var container=mura(target).children('.mura-object-content')
							container.append(dragEl);
						} else {
							try{
								target.parentNode.insertBefore(dragEl,target.nextSibling);
							} catch(e){};
						}
				    	
				    	var mDragEl=mura(dragEl);
						mura('#adminSave').show();
						mDragEl.addClass('mura-async-object');
						
						if(!(mDragEl.data('object')=='text' && mDragEl.data('render')=='client' && mDragEl.data('async')=='false')){
							mDragEl.data('async',true);
						}
						
						mura(target).closest('.mura-region-local').data('dirty',true);
						
						initDraggableObject(target);
						elDropHandled=true;
						disabledEventPropagation(e);

					} else if (dragEl==target){
						elDropHandled=true;
						disabledEventPropagation(e);
					}

					checkForNew.call(target,e);

				}

			}

			mura('.mura-drop-target').removeClass('mura-drop-target');
			muraLooseDropTarget=null;
			newMuraObject=false;

			if(!mura(this).attr('class')){
				mura(this).removeAttr('class');
			}
		}

		function initLooseDropTarget(item){
			mura(item)
			.off('dragenter',initLooseDropTarget_dragenter)
			.off('dragover',initLooseDropTarget_dragover)
			.off('drop',initLooseDropTarget_drop)
			.off('dragleave',initLooseDropTarget_dragleave)
			.on('dragenter',initLooseDropTarget_dragenter)
			.on('dragover',initLooseDropTarget_dragover)
			.on('dragleave',initLooseDropTarget_dragleave)
			.on('drop',initLooseDropTarget_drop);
		}

	    function initClassObjects(){
	    	mura(".mura-objectclass").each(function(){
				var item=mura(this);

				if(!item.data('inited')){
					item.attr('draggable',true);

					item.on('dragstart',function(e){
						dragEl=null;
						elDropHandled=false;
						newMuraObject=true;
						muraLooseDropTarget=null;
						mura('#dragtype').html(item.data('object'));
						mura('.mura-sidebar').addClass('mura-sidebar--dragging');

						e.dataTransfer.setData("text",JSON.stringify({object:item.data('object'),objectname:this.innerHTML,objectid:item.data('objectid')}));
					})
					.on('dragend',function(){
						mura('#dragtype').html('');
						dragEl=null;
						elDropHandled=false;
						newMuraObject=false;
						mura('.mura-sidebar').removeClass('mura-sidebar--dragging');
					});

					item.data('inited',true); 
				}

			});
	    }

		function checkForNew(e){
			e.preventDefault();

			if(e.stopPropagation) {
		        e.stopPropagation(); 
		    }

			var object= e.dataTransfer.getData("text");

			if(object != ''){
				try{
					object=JSON.parse(object);
				} catch (e){
					object='';
				}
			}

			if(typeof object=='object' && object.object){
				
				var displayObject=document.createElement("DIV");
				displayObject.setAttribute('data-object',object.object);
				displayObject.setAttribute('data-objectname',object.objectname);
				displayObject.setAttribute('data-async',true);
				displayObject.setAttribute('data-perm','author');
				displayObject.setAttribute('data-instanceid',mura.createUUID());
				displayObject.setAttribute('class','mura-async-object mura-object active');

				if(object.objectid){
					displayObject.setAttribute('data-objectid',object.objectid);
				} else {
					displayObject.setAttribute('data-objectid',mura.createUUID());
				}
		        
		        var target=mura(this);

		        if(target.hasClass('mura-object')){
		        	if(this.getAttribute('data-object')=='container'){
						var container=target.find('.mura-object-content');
						container.append(displayObject);
					} else {
						this.parentNode.insertBefore(displayObject,this.nextSibling);
					}			
		        } else if(target.hasClass('mura-region-local')){
		        	this.appendChild(displayObject);	
		        } else {
				    this.parentNode.insertBefore(displayObject,this.nextSibling);
		        }

		        initDraggableObject(displayObject);
		        
		        var objectData=mura(displayObject).data();

		        if(muraInlineEditor.objectHasConfigurator(objectData)){
		        	openFrontEndToolsModal(displayObject);
		    	}

		        mura.processAsyncObject(displayObject);

		        mura(displayObject).closest('.mura-region-local').data('dirty',true);
		        mura(displayObject).on('dragover',function(){})
		        mura('#adminSave').show();	
				disabledEventPropagation(e);
				
		    }

		}

		function loadObjectClass(siteid, classid, subclassid, contentid, parentid, contenthistid) {
			var pars = 'muraAction=cArch.loadclass&compactDisplay=true&layoutmanager=true&siteid=' + siteid + '&classid=' + classid + '&subclassid=' + subclassid + '&contentid=' + contentid + '&parentid=' + parentid + '&cacheid=' + Math.random();
			
			if(classid == 'plugins'){
				var d = mura('#pluginList');
			} else {
				var d = mura('#classList');
			
				mura('#classListContainer').show();
			}
			
			d.html(mura.preloaderMarkup);

			mura.ajax({
				url:mura.adminpath + "?" + pars,
				success:function(data) {
					d.html(data);
					initClassObjects();
				}
			});

			return false;
		}

		 function initLayoutManager(){
			initClassObjects();
			mura('body').addClass('-state__pushed--left');

			mura('.mxp-editable').each(function(){
				var item=mura(this);

				if(!item.hasClass('mura-region-local')){
					item.addClass('mura-region-local');
					item.data('inited',false);
					item.data('loose',true);
				}
			});

			mura('.mura-region-local[data-inited="false"]').each(function(){

				var region=mura(this);
				
				if(!region.data('loose') || (region.data('loose') && (region.html() == '<p></p>') || mura.trim(region.html()) =='' )){
					region.on('drop',function(e) {
					    var dropParent, dropIndex, dragIndex;

					    e.preventDefault();

					    if(mura(this).find('.mura-object').length){	    	
					    	return;
					    }

					    if (e.stopPropagation) {
					        e.stopPropagation(); 
					    }

					    if (dragEl && dragEl !== this) {   
						    dropParent = this.parentNode;
						    dragIndex = slice(dragEl.parentNode.children).indexOf(dragEl);   
					        dropIndex = slice(this.parentNode.children).indexOf(this);
					        if (this.parentNode === dragEl.parentNode && dropIndex > dragIndex){
					            dropParent.insertBefore(dragEl, this.nextSibling);
					        } else {
					        	this.appendChild(dragEl);
					        }

					        mura('#adminSave').show();
					        mura(dragEl).data('async',true);	
					        mura(dragEl).addClass('mura-async-object');
					        mura(this).data('dirty',true);
					        elDropHandled=true;
					        disabledEventPropagation(e);
					    } else if (dragEl==this){
					    	elDropHandled=true;
					    	disabledEventPropagation(e);
					    }

				      	checkForNew.call(this,e);

				      	muraLooseDropTarget=null;
				      	mura('.mura-drop-target').removeClass('mura-drop-target');

				      	return true;
		   			})
					.on('dragover',function(e){
						e.preventDefault();
						e.dataTransfer.dropEffect = 'copy';
					}).data('inited','true');

				}
			});

			mura('.mura-region-local .mura-object').each(function(){ initDraggableObject(this)});
			
			mura('.mura-object[data-object="container"], .mura-region-local div, .mura-region-local[data-loose="true"] p, .mura-region-local[data-loose="true"] h1, .mura-region-local[data-loose="true"] h2, .mura-region-local[data-loose="true"] h3, .mura-region-local[data-loose="true"] h4, .mura-region-local[data-loose="true"] img, .mura-region-local[data-loose="true"] table, .mura-region-local[data-loose="true"] article, .mura-region-local[data-loose="true"] dl').each(function(){ initLooseDropTarget(this)});

			mura('.mura-object[data-object="folder"],.mura-object[data-object="calendar"],.mura-object[data-object="gallery"]')
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

		mura.initLayoutManager=initLayoutManager;
		mura.loadObjectClass=loadObjectClass;
		mura.initLooseDropTarget=initLooseDropTarget;
		mura.initDraggableObject=initDraggableObject;
		
	})(window);