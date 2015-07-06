/* This file is part of Mura CMS. 

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
	function MuraDOMSelection(selection,origSelector){
		this.selection=selection;
		this.origSelector=origSelector;

		if(this.selection.length){
			this.parentNode=this.selection[0].parentNode;
			this.childNodes=this.selection[0].childNodes;
			this.node=selection[0];
		} else {
			this.parentNode=null;
			this.childNodes=null;
			this.node=null;
		}

		this.length=this.selection.length;
	}

	MuraDOMSelection.prototype={
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
			this.selection.forEach( function(el,idx){
				fn.call(el,el,idx);
			});
			return this;
		},

		filter:function(fn){
			return window.mura(this.selection.filter( function(el,idx){
				return fn.call(el,el,idx);
			}));
		},

		map:function(fn){
			return window.mura(this.selection.map( function(el,idx){
				return fn.call(el,el,idx);
			}));
		},

		isNumeric:function(val){
			return isNumeric(this.selection[0]);
		},

		on:function(eventName,fn){
			if(eventName=='ready'){
				if(document.readyState != 'loading'){
					fn.call(document);
				} else { 
					document.addEventListener(
						'DOMContentLoaded',
						function(event){
								fn.call(el,event);
						},
						true
					);	
				}
			} else {
				this.each(function(el){
					if(typeof el.addEventListener == 'function'){
						el.addEventListener(
							eventName, 
							function(event){
								fn.call(el,event);
							},
							true
						);
					}
				});
			}

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

		ready:function(fn){
			this.on('ready',fn);
			return this;
		},

		off:function(eventName){
			this.each(function(el){
				el.removeEventListener(eventName);
			});
		},

		unbind:function(eventName){
			this.off(eventName);
		},

		bind:function(eventName){
			this.on(eventName);
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
					var filterFn=function(){return (this.nodeType === 1 || this.nodeType === 11 || this.nodeType === 9) && window.mura.matchesSelector(this,selector);};
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

		getSelector:function(omitSysEls) {
		    var pathes = [];

		    //this.selection.each(function(index, element) {
		        var path, $node = window.mura(this.selection[0]);

		        while ($node.length) {
		           var realNode = $node.get(0), name = realNode.localName;
		           if (!name) { break; }

		           if(omitSysEls 
		           		&& (
		           			$node.hasClass('mura-editable')
							|| $node.hasClass('editableObjectContents')
							|| $node.hasClass('editableObject')
		           		)

		           	){
		           		break;
		           }
		           
		           if($node.attr('id') && $node.attr('id') != 'mura-variation-el'){
		           		name='#' + $node.attr('id');
		           		path = name + (path ? ' > ' + path : '');
		            	break;
		           } else {

		                name = name.toLowerCase();
		                var parent = $node.parent();
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
		            	$node = parent;
		       		 }

		           
		        }

		        pathes.push(path);
		    //});

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
					var filterFn=function(){return (this.nodeType === 1 || this.nodeType === 11 || this.nodeType === 9) && window.mura.matchesSelector(this,selector);};	
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
		 
		    // traverse parents
		    while (el!==null) {
		        parent = el.parentElement;
		        if (parent!==null && window.mura.matchesSelector(parent,selector)) {
		            return parent;
		        }
		        el = parent;
		    }

		    return null;
		},

		append:function(el) {
			this.selection[0].parentNode.appendChild(el);
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
			this.selection[0].parentNode.insertBefore(el, this.parentNode.firstChild);
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
				} else {
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

		after:function(htmlString){
			this.each(function(el){
				el.insertAdjacentHTML('afterend', htmlString);
			});
			return this;
		},

		before:function(htmlString){
			this.each(function(el){
				el.insertAdjacentHTML('beforebegin', htmlString);
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
			return this.selection[0].matchesSelector(selector);
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
				el.removeAttribute(attributeName);
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
				return this.selection[0].getAttribute(attributeName);
			}
		},

		data:function(attributeName,value){
			if(!this.selection.length){
				return;
			}
			if(typeof value == 'undefined' && typeof attributeName == 'undefined'){
				return window.mura.getDataAttributes(this.selection[0]);
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
			} else {
				return this.selection[0].getAttribute("data-" + attributeName);
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
	}

	window.mura.MuraDOMSelection=MuraDOMSelection;

})(window);