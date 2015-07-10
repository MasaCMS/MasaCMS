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
	
	.mura-sidebar:hover {
		transform: translateX(0);
		opacity: 1;
	}

	.mura-sidebar.mura-sidebar--dragging {
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
		border-style: dotted;
		min-height: 100px;
		border-color: black;
	}
	.mura-object:hover {
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
	
</style>

<div class="mura-sidebar">
<div class="mura-sidebar__objects-list">
	
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
	<div class="mura-sidebar__objects-list__object-group">
		<div class="mura-sidebar__objects-list__object-group-heading">Dragging</div>
		<div class="mura-sidebar__object-group-items">
			<div class="mura-sidebar__objects-list__object-item" id="dragtype"></div>
		</div>
	</div>
	<!---
	<div class="mura-sidebar__objects-list__object-group mura-displayregion">
		<div class="mura-sidebar__objects-list__object-group-heading">Example Display Region</div>
		<div class="mura-sidebar__object-group-items mura-displayregion">
	
		</div>
	</div>
	--->
</div>

</div>

<!---
<div class="mura-displayregion">
	
	<span class="editableObject editableFeed" >
		<span class="editableObjectContents">
		<span class="mura-object mura-async-object" 
			data-object="myobject"
			data-objectparams={test:123,dfgdfg:dfgdg}>

		</span>
		</span>
		<ul class="editableObjectControl">
			<li class="edit"><a/></li>
		</ul>
	</span>

	<span class="editableObject editableFeed" >
		<span class="editableObjectContents">
		<div class="mura-object mura-async-object">

		</div>
		</span>
		<ul class="editableObjectControl">
			<li class="edit"><a/></li>
		</ul>
	</span>
</div>
--->
<script>
	mura.ready(function(){

		var sortable,
		slice = function (arr, start, end) {
	        return Array.prototype.slice.call(arr, start, end)
	    },
	    dragEl;

	    function wireUpObjects(){

	    	mura(".mura-displayregion[data-inited='false']")
			.on('drop',function(e) {
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

		          if (this.parentNode === dragEl.parentNode && dropIndex > dragIndex) {
		            dropParent.insertBefore(dragEl, this.nextSibling);
		          } else {
		            this.appendChild(dragEl);
		          }
		       
		      }

		      checkForNew.call(this,e);
		     
		      //wireUpObjects();

		      dragEl = null;

		      return true;
   			})
			.on('dragover',function(e){
				e.preventDefault();
				//e.dataTransfer.dropEffect='move';
			}).data('inited','true');

			if(sortable){
		       	sortable.destroy();
		    }

			sortable=mura.sortable({
				els:'.mura-displayregion > .mura-object',
				onDrop:checkForNew,
				onDragStart:function(){dragEl=this;}
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

			//alert(2);
			if(typeof object=='object' && object.object){
				
				var displayObject=document.createElement("DIV");
				displayObject.setAttribute('data-object',object.object);
				displayObject.setAttribute('class','mura-async-object mura-object');
		        
		        if(mura(this).hasClass('mura-object')){
		        	this.parentNode.insertBefore(displayObject, this);				
		        } else if(mura(this).hasClass('mura-displayregion')){
		        	this.appendChild(displayObject);	
		        } else {
		        	var region=mura(this).find('.mura-displayregion');
		        	if(region.length){
		        		region.append(displayObject);
		        	}
		        }

		        mura.processAsyncObject(displayObject);

				wireUpObjects();
				
		    }

		}

		wireUpObjects();

		mura(".mura-objectclass").each(function(){
			var item=mura(this);
			item.attr('draggable',true);
			item.on('dragstart',function(e){
					//e.dataTransfer.effectAllowed = 'move';
					dragEl=null;
					mura('#dragtype').html(item.data('object'));
					mura('.mura-sidebar').addClass('mura-sidebar--dragging');
					e.dataTransfer.setData("text",JSON.stringify({object:item.data('object')}));
				}).on('dragend',
					function(){
						mura('#dragtype').html('');
						mura('.mura-sidebar').removeClass('mura-sidebar--dragging');
					});

		});

		
	});

</script>