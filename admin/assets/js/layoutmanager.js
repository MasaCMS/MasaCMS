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

	    function initDraggableObject(item){

			mura(item)
			.on('dragstart',function(e){
				//FireFox insists that the dataTranfer has been set
				e.dataTransfer.setData('Text','');
				dragEl=this;
				elDropHandled=false;
				newMuraObject=false;
				muraLooseDropTarget=null;
			})
			.on('dragend',function(){
				if(dragEl && !elDropHandled){
					mura(dragEl).remove();
				}

				dragEl=null;
				elDropHandled=false;
				newMuraObject=false;
			})
			.on('dragover',function(e){
				e.preventDefault();
			})
			.on('dragenter',function(e){

				if(dragEl || newMuraObject){
				

					var prev=mura('.mura-var-target');
					muraLooseDropTarget=this;

					if(prev.length){
						prev.removeClass('mura-var-target');

						if(!prev.attr('class')){
							prev.removeAttr('class');
						}
					}

					var item=mura(this).closest('.mura-object');
					mura(this).addClass('mura-var-target');	
					disabledEventPropagation(e);	
					
				}
			})
			.on('dragleave',function(e){
				mura(this).removeClass('mura-var-target');
				muraLooseDropTarget=null;
				if(!mura(this).attr('class')){
					mura(this).removeAttr('class');
				}
			}).on('drop',function(e){
				// this/e.target is current target element.
			    if (e.stopPropagation) {
			    	e.stopPropagation(); // stops the browser from redirecting.
			    }
			    if(dragEl || newMuraObject){
					if(dragEl && dragEl != this){
						if(this.getAttribute('data-object')=='container'){
							this.appendChild(dragEl);
						} else {
							this.parentNode.insertBefore(dragEl,this.nextSibling);
						}	
				    	//dragEl.setAttribute('data-droptarget',mura(this).getSelector());
						mura('#adminSave').show();
						mura(this).closest('.mura-displayregion').data('dirty',true);
						elDropHandled=true;
						disabledEventPropagation(e);
					} else if (dragEl==this){
						elDropHandled=true;
						disabledEventPropagation(e);
					}

					checkForNew.call(this,e);

				    mura(this).removeClass('mura-var-target');
					muraLooseDropTarget=null;
					newMuraObject=false;

					if(!mura(this).attr('class')){
						mura(this).removeAttr('class');
					}
				}
				
			}).attr('draggable',true);
		}

		function initLooseDropTarget(item){
			mura(item)
			.on('dragover',function(e){e.preventDefault()})
			.on('dragenter',function(e){
				if(dragEl || newMuraObject){
					var prev=mura('.mura-var-target');
					muraLooseDropTarget=this;

					if(prev.length){
						prev.removeClass('mura-var-target');

						if(!prev.attr('class')){
							prev.removeAttr('class');
						}
					}

					var item=mura(this).closest(".mura-object");

					if(item){
						item.addClass('mura-var-target');
					} else {
						mura(this).addClass('mura-var-target');
					}

					disabledEventPropagation(e);
					
				}
			})
			.on('dragleave',function(e){
				mura(this).removeClass('mura-var-target');
				muraLooseDropTarget=null;
				if(!mura(this).attr('class')){
					mura(this).removeAttr('class');
				}
			}).on('drop',function(e){
				// this/e.target is current target element.
			    if (e.stopPropagation) {
			    	e.stopPropagation(); // stops the browser from redirecting.
			    }

			    if(dragEl || newMuraObject){

				    if(dragEl && dragEl != this){
				    	if(this.getAttribute('data-object')=='container'){
							this.appendChild(dragEl);
						} else {
							this.parentNode.insertBefore(dragEl,this.nextSibling);
						}
				    	//dragEl.setAttribute('data-droptarget',mura(this).getSelector());
						mura('#adminSave').show();
						mura(dragEl).addClass('mura-async-object');
						mura(this).closest('.mura-displayregion').data('dirty',true);
						elDropHandled=true;
						disabledEventPropagation(e);
					} else if (dragEl==this){
						elDropHandled=true;
						disabledEventPropagation(e);
					}

					checkForNew.call(this,e);

					mura(this).removeClass('mura-var-target');
					muraLooseDropTarget=null;
					if(!mura(this).attr('class')){
						mura(this).removeAttr('class');
					}

				}
			});

		}

	    function initLayoutManager(){
			
			mura('.mura-displayregion[data-inited="false"]').each(function(){

				var region=mura(this);

				if(!region.data('loose') || (region.data('loose') && region.html() == '<p></p>')){
					region.on('drop',function(e) {
					    var dropParent, dropIndex, dragIndex;
					    e.preventDefault();
					      // this/e.target is current target element.
					    if (e.stopPropagation) {
					        e.stopPropagation(); // stops the browser from redirecting.
					    }

					    // Don't do anything if we're dropping on the same column we're dragging.
					    if (dragEl && dragEl !== this) {   
						    dropParent = this.parentNode;
						    dragIndex = slice(dragEl.parentNode.children).indexOf(dragEl);   
					        dropIndex = slice(this.parentNode.children).indexOf(this);

					        if (this.parentNode === dragEl.parentNode && dropIndex > dragIndex){
					            dropParent.insertBefore(dragEl, this.nextSibling);
					        } else {
					        	this.appendChild(dragEl);
					        }

					        //dragEl.setAttribute('data-droptarget',mura(this).getSelector());
					        mura('#adminSave').show();	
					        mura(dragEl).addClass('mura-async-object');
					        mura(this).data('dirty',true);
					        elDropHandled=true;
					        disabledEventPropagation(e);
					    } else if (dragEl==this){
					    	elDropHandled=true;
					    	disabledEventPropagation(e);
					    }

				      	checkForNew.call(this,e);
				     
				      	//wireUpObjects();

				      	muraLooseDropTarget=null;
				      	mura('.mura-var-target').removeClass('mura-var-target');

				      	return true;
		   			})
					.on('dragover',function(e){
						e.preventDefault();
						//e.dataTransfer.dropEffect='move';
					}).data('inited','true');
				}
			});

			mura('.mura-displayregion:not([data-loose="true"]) > .mura-object, .mura-displayregion[data-loose="true"] .mura-object')
			.each(function(){ initDraggableObject(this)});
			
			mura('.mura-displayregion[data-loose="true"] p, .mura-displayregion[data-loose="true"] p, .mura-displayregion[data-loose="true"] h1, .mura-displayregion[data-loose="true"] h2, .mura-displayregion[data-loose="true"] h3, .mura-displayregion[data-loose="true"] h4, .mura-displayregion[data-loose="true"] img, .mura-displayregion[data-loose="true"] table, .mura-displayregion[data-loose="true"] article, .mura-displayregion[data-loose="true"] dl').each(function(){ initLooseDropTarget(this)});

	    }

	    function initClassObjects(){
	    	mura(".mura-objectclass").each(function(){
				var item=mura(this);

				if(!item.data('inited')){
				item.attr('draggable',true);
				item.on('dragstart',function(e){
						//e.dataTransfer.effectAllowed = 'move';
						dragEl=null;
						elDropHandled=false;
						newMuraObject=true;
						muraLooseDropTarget=null;
						mura('#dragtype').html(item.data('object'));
						mura('.mura-sidebar').addClass('mura-sidebar--dragging');

						e.dataTransfer.setData("text",JSON.stringify({object:item.data('object'),objectname:this.innerHTML,objectid:item.data('objectid')}));
					})
					.on('dragend',
						function(){
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
		        e.stopPropagation(); // stops the browser from redirecting.
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
						this.appendChild(dragEl);
					} else {
						this.parentNode.insertBefore(dragEl,this.nextSibling);
					}
		        	this.parentNode.insertBefore(displayObject, this);				
		        } else if(target.hasClass('mura-displayregion')){
		        	this.appendChild(displayObject);	
		        } else {
				    this.parentNode.insertBefore(displayObject,this.nextSibling);
		        }

		        //displayObject.setAttribute('data-droptarget',target.getSelector());
		        initDraggableObject(displayObject);
		        
		        var objectData=mura(displayObject).data();

		        if(muraInlineEditor.objectHasConfigurator(objectData)){
		        	openFrontEndToolsModal(displayObject);
		    	}

		        mura.processAsyncObject(displayObject);

		        mura(displayObject).closest('.mura-displayregion').data('dirty',true);
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

		mura.initLayoutManager=initLayoutManager;
		mura.loadObjectClass=loadObjectClass;

		mura(function(){
			initClassObjects();
		});
		
		
	})(window);