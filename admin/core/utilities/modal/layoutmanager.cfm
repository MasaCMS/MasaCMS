<style>
	/*
		DEV NOTE
		placeholder styles for #frontEndTools simulating mura toolbar
	*/
	#frontEndTools {
		position: fixed;
		z-index: 3;
		top: 0;
		left: 0;
		right: 0;
		height: 32px;
		background: #333;
	}
	
	.mura-sidebar {
		font-family: Helvetica, sans-serif;
		
		position: absolute;
		top: 100%;
		height: calc(100vh - 32px);
		background: #eaf4fd;
		
		width: 350px;
		
		transform: translateX(-300px);
		opacity: 0;
		
		transition: all .3s ease;
	}
	
	.mura-sidebar.active:hover {
		transform: translateX(0);
		opacity: 1;
	}

	.mura-sidebar.active.mura-sidebar--dragging {
		transform: translateX(-300px);
		opacity: 0;
	}
	
	/* 
		DEV NOTE
		ie10 does not allow use of 'inherit' on calculated parent
		example: .mura-sidebar uses a calculated height, therefore the child elements cannot use 'inherit' for height
		http://stackoverflow.com/questions/19423384/css-less-calc-method-is-crashing-my-ie10
	*/
	
	.mura-sidebar__objects-list {
		height: 100%;
		width: 100%;
		overflow: scroll;
	}
	
	.mura-sidebar__objects-list__object-group {
		background: #fff;
		margin: 15px;
	}
	
	.mura-sidebar__objects-list__object-group-heading {
		box-sizing: border-box;
		padding: .5em;
		padding-right: 50px;
		
		font-weight: bold;
		
		border-bottom: 3px solid rgba(0,0,0,.05);
	}
	
	.mura-sidebar__objects-list__object-item {
		box-sizing: border-box;
		padding: .5em;
		padding-right: 50px;
	}
	
	.mura-sidebar__objects-list__object-item:hover {
		background: #f7f7f7;
		cursor: pointer;
	}


	.mura-displayregion {
		min-height: 15px;
	}

	.mura-object.active:hover {
		background: #f7f7f7;
		cursor: pointer;
	}
	
	.mura-sidebar__objects-list__object-item + .mura-sidebar__objects-list__object-item {
		border-top: 1px solid rgba(0,0,0,.05);
	}
	
	body {
	    -webkit-touch-callout: none;
	    -webkit-user-select: none;
	    -khtml-user-select: none;
	    -moz-user-select: none;
	    -ms-user-select: none;
	    user-select: none;
	}


							
	.mura-var-target {
		border-bottom: dotted #ff0000;
		margin-bottom: -1px;
	}	
	
</style>
<cfoutput>
<div class="mura-sidebar">
	<div class="mura-sidebar__objects-list">
		<div class="mura-sidebar__objects-list__object-group">
			<div class="mura-sidebar__objects-list__object-group-heading">
				<select name="classSelector" onchange="mura.loadObjectClass('#esapiEncode("Javascript",$.content('siteid'))#',this.value,'','#$.content('contenthistid')#','#$.content('parentid')#','#$.content('contenthistid')#',0);">
				<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectobjecttype')#</option>
				<!---
				<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.primary')#</option>
				--->
                <option value="system">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.system')#</option>
                <option value="navigation">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.navigation')#</option>
                <cfif application.settingsManager.getSite($.event('siteid')).getDataCollection()>
	                <option value="form">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.forms')#</option>
	            </cfif>
	            <cfif application.settingsManager.getSite($.event('siteid')).getemailbroadcaster()>
	                <option value="mailingList">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mailinglists')#</option>
	            </cfif>
                <cfif application.settingsManager.getSite($.event('siteid')).getAdManager()>
                  <option value="adzone">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.adregions')#</option>
                </cfif>
                <!--- <option value="category">Categories</option> --->
                <option value="folder">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.Folders')#</option>
                <option value="calendar">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.calendars')#</option>
                <option value="gallery">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.galleries')#</option>
                <option value="component">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.components')#</option>
                <cfif application.settingsManager.getSite($.event('siteid')).getHasfeedManager()>
                  <option value="localFeed">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindexes')#</option>
                  <option value="slideshow">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindexslideshows')#</option>
                  <option value="remoteFeed">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotefeeds')#</option>
                </cfif>
            	 <option value="plugins">#application.rbFactory.getKeyValue(session.rb,'layout.plugins')#</option>
              </select>

			</div>
		</div>

		<div id="classListContainer" class="mura-sidebar__objects-list__object-group" style="display:none">
			<div class="mura-sidebar__objects-list__object-group-heading">Select Object</div>
			<div class="mura-sidebar__object-group-items" id="classList">
			</div>
		</div>

		<!---
		<div class="mura-sidebar__objects-list__object-group">
			<div class="mura-sidebar__objects-list__object-group-heading">Add Content</div>
			<div class="mura-sidebar__object-group-items">
				<div class="mura-sidebar__objects-list__object-item mura-objectclass" data-object="standard_nav">Secondary Navigation</div>
				<div class="mura-sidebar__objects-list__object-item mura-objectclass" data-object="collection">Collection</div>
				<div class="mura-sidebar__objects-list__object-item mura-objectclass" data-object="content">Content</div>
				<div class="mura-sidebar__objects-list__object-item mura-objectclass" data-object="media">Media</div>
				<div class="mura-sidebar__objects-list__object-item mura-objectclass" data-object="text">Text</div>
				<div class="mura-sidebar__objects-list__object-item mura-objectclass" data-object="embed">Social Embed</div>
				<div class="mura-sidebar__objects-list__object-item mura-objectclass" data-object="helloworld">Hello World</div>
			</div>
		</div>
		--->
	</div>
</div>
</cfoutput>
<script>
	mura.ready(function(){

		<cfoutput>mura.adminpath='#variables.$.globalConfig("adminPath")#';</cfoutput>

		var sortable,
		slice = function (arr, start, end) {
	        return Array.prototype.slice.call(arr, start, end)
	    },
	    dragE;

	    function initDraggableObject(item){

				mura(item)
				.on('dragstart',function(){
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
					    	this.parentNode.insertBefore(dragEl,this.nextSibling);
					    	//dragEl.setAttribute('data-droptarget',mura(this).getSelector());
							mura('#adminSave').show();
							mura(this).closest('.mura-displayregion').data('dirty',true);
							elDropHandled=true;
						} else if (dragEl==this){
							elDropHandled=true;
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
					    	this.parentNode.insertBefore(dragEl,this.nextSibling);
					    	//dragEl.setAttribute('data-droptarget',mura(this).getSelector());
							mura('#adminSave').show();
							mura(dragEl).addClass('mura-async-object');
							mura(this).closest('.mura-displayregion').data('dirty',true);
							elDropHandled=true;
						} else if (dragEl==this){
							elDropHandled=true;
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

				if(region.data('loose')!='true' || (region.data('loose')=='true' && region.html() == '<p></p>')){
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
					    } else if (dragEl==this){
					    	elDropHandled=true;
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
		        	this.parentNode.insertBefore(displayObject, this);				
		        } else if(target.hasClass('mura-displayregion')){
		        	this.appendChild(displayObject);	
		        } else {
				    this.parentNode.insertBefore(displayObject,this.nextSibling);
		        }

		        //displayObject.setAttribute('data-droptarget',target.getSelector());
		        initDraggableObject(displayObject);
		        openFrontEndToolsModal(displayObject);
		        mura.processAsyncObject(displayObject);

		        mura(displayObject).closest('.mura-displayregion').data('dirty',true);
		        mura(displayObject).on('dragover',function(){})
		        mura('#adminSave').show();	
				//wireUpObjects();
				
		    }

		}

		function loadObjectClass(siteid, classid, subclassid, contentid, parentid, contenthistid) {
			var pars = 'muraAction=cArch.loadclass&compactDisplay=true&layoutmanager=true&siteid=' + siteid + '&classid=' + classid + '&subclassid=' + subclassid + '&contentid=' + contentid + '&parentid=' + parentid + '&cacheid=' + Math.random();
			var d = mura('#classList');
			mura('#classListContainer').show();
			d.html(mura.preloaderMarkup);
			mura.get(mura.adminpath + "?" + pars).then(function(data) {
				d.html(data);
				initClassObjects();
			});
			return false;
		}

		mura.initLayoutManager=initLayoutManager;
		mura.loadObjectClass=loadObjectClass;
		
	});

</script>