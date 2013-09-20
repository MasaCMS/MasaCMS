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
	(function($) {
	$.fn.minigrid = function(settings) {
		var settings		= $.extend({},$.fn.minigrid.defaults,settings);
		var self			= this;
		var $container		= $(this);

		self.data			= {};
		self.dataMap		= {};

		self.counter		= 1;
		self.isLoading		= false;

		self.identity		= '';
		self.sort			= false;

		self.setData		= doRenderData;

		self.input			= $("<input type='hidden' name='" + settings.fieldname +"' id='minigrid-"+ settings.id +"' value=''>");

		// external functions	
		self.getSaveData = function() {
			return getDataForSave();
		}

		// external functions	
		self.save = function() {
			return remoteSaveData();
		}

		self.getWidth = function() {
			return $container.width();
		}

		self.showModal = function() {
			$(".ui-minigrid-modal",$container).show();
		}
	
		self.hideModal = function() {
			$(".ui-minigrid-modal",$container).hide();
		}
		self.hideModal();

		renderGrid();

		// internal functions
		function renderGrid(){
			self.showModal();
			$container.width(settings.width);

			var $divBody		= $("<div class='ui-minigrid'></div>");
			var $divModal		= $("<div class='ui-minigrid-modal'><div class='ui-minigrid-spinner'></div></div>");
			var $divButtonBar	= $("<div class='ui-minigrid-buttonbar ui-widget-header ui-state-active'></div>");
			var $divHeader		= $("<div class='ui-minigrid-header ui-widget-header ui-state-default ui-minigrid-boxed clearfix'></div>");
			var $divHeaderList	= $("<ul class='ui-minigrid-header-list clearfix'></ul>");
			var $divContent		= $("<div class='ui-minigrid-body ui-minigrid-boxed clearfix'></div>");
			var $divContentList	= $("<ul class='ui-minigrid-content'></ul>");
			var $divResize		= $("<div class='ui-resize'></div>");
			
			var $buttonCon		= $("<ul class='table-buttons three left'></ul>")
			var $buttonCon2		= $("<ul class='table-buttons one right'></ul>")
			
			var $buttonAdd = $("<li class='bit'><span class='sb-button ui-state-default'><a id='minigrid-add' href='#' class='ui-icon ui-icon-document-b'></a></span></li>");
			var $buttonSave = $("<li class='bit'><span class='sb-button ui-state-default'><a id='minigrid-save' href='#' class='ui-icon ui-icon-disk'></a></span></li>");
			var $buttonRefresh = $("<li class='bit'><span class='sb-button ui-state-default'><a id='minigrid-refresh' href='#' class='ui-icon ui-icon-refresh'></a></span></li>");
			
			var $buttonOpenClose = $("<li class='bit'><span class='sb-button ui-state-default'><a id='minigrid-openclose' href='#' class='ui-icon ui-icon-minus'></a></span></li>");
			$divBody.data('state', 1);
						
			$buttonCon.append(self.input);

		//	if( settings.mode == 'create')
				$buttonCon.append($buttonAdd);

//			$buttonCon.append($buttonSave);
			$buttonCon.append($buttonRefresh);
			
			$buttonCon2.append($buttonOpenClose);
			
			$divButtonBar.append($buttonCon);
			$divButtonBar.append($buttonCon2);
			
			$divHeader.append($divHeaderList);
			$divContent.append($divContentList);
			$divBody.append($divHeader);
			$divBody.append($divContent);
			$container.append($divButtonBar);
			$container.append($divBody);
			$container.addClass("ui-minigrid");
			$container.append($divModal);
			$container.append($divResize);

			$buttonAdd.click(function(){
				doAddRow($container);
				if ($divBody.data('state') == 0) {
					$divBody.show();
					$divBody.data('state', 1);
				}
			});
			
			$buttonSave.click(function(){
				remoteSaveData();
			});
			
			$buttonRefresh.click(function(){
				alert( myDump( self.getDataMap(),"","  ",0,30) );
			});
			
			$buttonOpenClose.click(function(){
				$("#minigrid-openclose").toggleClass('ui-icon-minus').toggleClass('ui-icon-plus');
				if ($divBody.data('state') == 1) {
					$divBody.hide();
					$divBody.data('state', 0);
				}
				else {
					$divBody.show();
					$divBody.data('state', 1);
				}
			});
			
			self.isLoading = false;

			if (settings.data.columns != undefined && settings.data.columns.length) {
				doRenderData($container, settings.data);
			}
			else if (settings.url.length) {
				remoteLoadData();
			}
		}

		function doRenderData( $tgt,data,rerender ) {
		 	$container = $tgt;
			var $rowList = $(".ui-minigrid-content", $container);

			self.showModal();
	
			// create data map
			self.identity	= data.identity;
			self.sort		= data.sortable;
			
			createDataMap( data );

			// clear headers, record elements
			doClear( $container );
			
			// unbind previous bindings
			$container.unbind();
			$(":checkbox,:radio",$rowList).unbind();
			$(":text",$rowList).unbind();
			$(".ui-icon-close",$rowList).unbind();
			$(".ui-minigrid-body",$container).resizable('destroy');
			$(".ui-minigrid-body",$container).attr('style',''); 

			// make this sortable as required
			if (self.sort == true) {
				$rowList.sortable({
					axis: 'y',
					opacity: 0.6,
					delay: 200,
					update: function(event, ui){
						self.dataMap.dirty = 1;
						self.dataMap.sorted = 1;
						refreshEven($container);
					}
				});
			}

			// this is the up/down/tab key functionality
			$container.keydown( function( event ) {
				// down arrow
				if (event.keyCode == '38' && $(event.target).attr('type') == 'text') {
					var $parent = $(event.target).parents('ul:first').parent();					
					var index = $parent.index();
					if (index == 0) 
						return;
					
					var name = $(event.target).attr('name');
					
					var newFocusTarget = $("[name=" + name + "]", $parent.parent().children()[index - 1]);
					$(event.target).change();
					newFocusTarget.focus();
				// up arrow
				} else if (event.keyCode == '40' && $(event.target).attr('type') == 'text') {
					var $parent = $(event.target).parents('ul:first').parent();
					var index = $parent.index();
					if(index+1 >= $parent.parent().children().length )
						return;

					var name = $(event.target).attr('name');
					var newFocusTarget = $("[name=" + name + "]", $parent.parent().children()[index + 1]);
					$(event.target).change();
					newFocusTarget.focus();
				// tab key
				}  else if (event.keyCode == '9' && event.shiftKey == false) {
					var $master = $(event.target).parents('ul:first');
					var $parent = $master.parent();
					var $children = $master.children();
					var index = $parent.index();
					if(self.sort)
						var pos = 2;
					else
						var pos = 1;

					if (index + 1 == $parent.parent().children().length && $(event.target).parent().index() + pos == $children.length) {
						$(event.target).change();
						doAddRow($container);
						event.preventDefault();
					}
				}

			});

			// this is the data binding for checkboxes,radio buttons
			$(":checkbox,:radio",$rowList).on('change',function( event ) {
				var $tgt	= $(event.target); 
				var aID		= $tgt.attr('id').split("_");
				var pos		= aID[0];
				var name	= aID[1];
				var value	= $tgt.attr('value');
				var type	= $tgt.attr('type');
				var id		= self.dataMap.map[pos];
				
				switch (type) {
					case 'checkbox' :
						self.dataMap.records[id].data[name] = $tgt.is(':checked') ? value : 0; 
						self.dataMap.records[id].dirty = 1;
					break;
					case 'radio' :
						self.dataMap.records[id].data[name] = $tgt.is(':checked') ? 1 : 0; 
						self.dataMap.global[name] = value; 
						self.dataMap.records[id].dirty = 1;
					break;
				}
				self.dataMap.dirty = 1;
			});

			// this is the binding for text inputs
			$(":text",$rowList).on('keyup',function( event ) {
				var $tgt	= $(event.target); 
				
				var aID		= $tgt.attr('id').split("_");
				var pos		= aID[0];
				var name	= aID[1];
				var value	= $tgt.attr('value');
				var type	= $tgt.attr('type');
				var id		= self.dataMap.map[pos];

				// value didn't change
				if( $tgt.attr('value') == self.dataMap.records[id].data[name])
					return;
				// no record
				else if(!self.dataMap.records[id])
					return;

				self.dataMap.records[id].data[name] = value;
				self.dataMap.records[id].dirty = 1;
				self.dataMap.dirty = 1;
			});

			// this is the binding for delete keys
			$(".ui-icon-close",$rowList).on('click',function( event ) {
				var $tgt	= $(event.target);
				var $parent	= $tgt.parents("ul:first").parent();
				var pos	= $parent.attr('id');
				var id =  self.dataMap.map[pos];

				if(!self.dataMap.records[id])
					return;

				if( self.dataMap.records[id].phantom ) {
					delete self.dataMap.records[id];
					delete self.dataMap.map[pos];		
					if( !settings.commitOnSave )
						self.dataMap.dirty = 1;
				} else {
					self.dataMap.records[id].dirty = 1;
					self.dataMap.records[id].del = true;
					self.dataMap.dirty = 1;
//					alert( myDump( self.dataMap.records[id],"","  ",0,30) );
				}
				$parent.remove();
				refreshEven( $container );
			});
			
			// build header
			if( data.columns.length )
				doBuildHeader( $container );
			
			// build rows
			if( data.rows.length )
				doBuildRows( $container );
			
			settings.onRenderComplete();
							
			self.hideModal();
		}

		function createDataMap( data ) {
			if( data )
				self.data = $.extend(true,{},data);
				
			delete data;

			self.dataMap		= {};
			var rows			= self.data.rows;
			var identity		= self.data.identity;
			var finished		= false;
			var ct				= 0;

			self.dataMap.id			= self.data.id;
			self.dataMap.rowcount	= 0;
			self.dataMap.map		= {};
			self.dataMap.params		= {};		
			self.dataMap.dirty		= 0;
			self.dataMap.coldirty	= 0;
			self.dataMap.sorted		= 0;
			self.dataMap.global		= {};		
			self.dataMap.records	= {};
			self.dataMap.orderlist	= [];
			
			// treat as a struct as data may be coming in that way
			for (var cr in rows) {
				var ident	= rows[cr].data[identity];
				self.dataMap.map[self.dataMap.rowcount] = ident;
				self.dataMap.rowcount++;
				var mapItem = {dirty:0,id:ident,data: {}};
				mapItem = $.extend(true,mapItem,rows[ cr ]);
				mapItem.row = cr;
				self.dataMap.records[ident] = mapItem;
			}
		}

		function updateDataMap( data,callback ) {
			for(var i in data.phantoms) {
				if(self.dataMap.records[i]) {
					var dataItem = $.extend(true,{},self.dataMap.records[i]);
					self.dataMap.map[i] = data.phantoms[i];
					dataItem.data[self.data.identity] = dataItem.id = data.phantoms[i];
					dataItem.phantom = 0;
					self.dataMap.records[ data.phantoms[i] ] = dataItem;
					delete self.dataMap.records[i];
				}
			}
			for(var i in data.clean) {
				self.dataMap.records[i].dirty = 0;
			}
			for(var i in data.del) {
				delete self.dataMap.records[i];
				for(var x in self.dataMap.map) {
					if(self.dataMap.map[x] == i) {
						delete self.dataMap.map[x];
						break;
					}
				}
			}
						
			self.dataMap.coldirty = 0;
			self.dataMap.dirty = 0;
			self.dataMap.sorted = 0;

			self.hideModal();

			callback (
				self.getDataMap()
			)
			return;
		}

		function doBuildHeader( $container ) {
			var $headerList = $(".ui-minigrid-header-list", $container);
			var aCol		= [];
			var aRow		= [];
			var row			= '';
			var columns		= self.data.columns;
			var rows		= self.data.rows;

			aRow.push( "<ul class='column'>" );
			if (settings.mode == 'create') {
				aRow.push("<li class='button'></li>");
			}
					
			for(var i = 0;i<columns.length;i++) {
				aCol = [];
				switch( columns[i].render ) {
					case 'radio' :
					case 'checkbox' :
						aCol.push("<li class='bit'>");	
					break;
					default :
						if(columns[i].name == 'label')
							aCol.push("<li style='width: " + settings.widthPrimary +"px'>");
						else	
							aCol.push("<li style='width: " + settings.widthSecondary +"px'>");
					break;
				}
				aCol.push("<span>" + columns[i].label + "</span></li>");
				aRow.push( aCol.join('') );
			}
			
			if(self.sort)
				aRow.push( "<li class='sort'><span class='ui-icon " + settings.sortIcon + "' title='"+ settings.sortIconTitle +"'></span></li>" );
			aRow.push( '</ul>' );
			row = aRow.join('');
			$headerList.append( $(row) );
			$container.width( 1500 );
			$container.width( $(".column", $headerList).width() + 19 );
			$(".ui-minigrid-body",$container).height( settings.height );
				if( settings.resizable ) {
					$(".ui-resize",$container).resizable({ handles: 's',alsoResize: ".ui-minigrid-body",
						resize: function(event, ui) {
							$(".ui-resize",$container).attr('style','');		
						}
					 });
				}
				else {
					$(".ui-minigrid-body",$container).addClass('ui-minigrid-bordered');
				}
			}

		function doBuildRows( $container ) {
			// bind listener
			var $rowList = $(".ui-minigrid-content", $container);
			var aCol		= [];
			var aRow		= [];
			var $row		= '';
			var $col		= '';
			var $fullrow	= '';
			var columns		= self.data.columns;
			var records		= self.dataMap.records;
		
			for(var cr in records) {
				if(records[cr].del != true) {
					$row = buildGridRow( records[cr] );
					$rowList.append( $row );
				}
			}
			self.data.rows = [];
			$("li.row:even", $rowList).addClass('even');
		}

		function buildGridRow( dataItem ) {
			var columns		= self.data.columns;
			var identity	= self.data.identity;
			var record		= dataItem.data;

			var $row = $("<ul class='column'></ul>" );
			if (settings.mode == 'create') {
				var $button = $("<li class='bit'><span class='sb-button ui-state-default'><a href='#' class='ui-icon ui-icon-close'></a></span></li>");
				$row.append($button);
			}
			
			for(var cc = 0;cc<columns.length;cc++) {
				aCol = [];
				var item = columns[cc].name;
				switch( columns[cc].render ) {
					case 'radio' :
						aCol.push("<li class='bit'><input class='radio' id='");	
						aCol.push(dataItem.row + "_" + columns[cc].name);
//						aCol.push("' name='");
//						aCol.push(columns[cc].name);
						aCol.push("' value='");
						aCol.push(record[identity]);
						if( record[columns[cc].name] != '' && record[columns[cc].name] != 0 )
							aCol.push("' checked='checked");
						aCol.push("' type='radio'></li>");
						
						$col = $(aCol.join(''));
					break;
					case 'checkbox' :
						aCol.push("<li class='bit'><input class='checkbox' id='");	
						aCol.push(dataItem.row + "_" + columns[cc].name);
						if( record[columns[cc].name] != '' && record[columns[cc].name] != 0 )
							aCol.push("' checked='checked");
						aCol.push("' value='1' type='checkbox'></li>");
						$col = $(aCol.join(''));
					break;
					default :
						if(columns[cc].editable == true) {
							if(columns[cc].name == 'label')
								aCol.push("<li class='col' style='width: " + settings.widthPrimary +"px'><input class='text' style='width: " + (settings.widthPrimary-4) +"px' id='");	
							else	
								aCol.push("<li class='col' style='width: " + settings.widthSecondary +"px'><input class='text' style='width: " + (settings.widthSecondary-4) +"px' id='");	
							aCol.push(dataItem.row + "_" + columns[cc].name);
	//						aCol.push("' name='");
	//						aCol.push(columns[cc].name);
							aCol.push("' value='");
							aCol.push(record[columns[cc].name]);
							aCol.push("' type='input'></li>");	
							$col = $(aCol.join(''));
						}
						else {
							if(columns[cc].name == 'label')
								$col = $("<li class='col' style='width: " + settings.widthPrimary +"px'>" + record[columns[cc].name] +"</li>");	
							else	
								$col = $("<li class='col' style='width: " + settings.widthSecondary +"px'>" + record[columns[cc].name] +"</li>");	
						}
					break;
				}
				$row.append( $col );
			}

			if(self.sort)
				$row.append( $("<li class='sort'><span class='ui-icon ui-icon-grip-dotted-vertical'></span></li>") );

			$fullrow = $("<li class='row clearfix'></li>").append($row);
			$fullrow.attr('id',dataItem.row);
			return $fullrow;			
		}

		function doClear( $container ) {
			$(".ui-minigrid-header-list", $container).children().remove();
			$(".ui-minigrid-content", $container).children().remove();
		}

		function render( template, map ){
			return template.render( map );
		}

		function remoteLoadData( options ) {
			self.showModal();
			options	= $.extend(options,settings.loadOptions,{id: settings.id,contentid: settings.contentid,mode: settings.mode} );
			var url = settings.url + "?load=true";

			$.ajax({
				url: url,
				data: options,
				success: function( response ) {
					// Check to see if the request was successful.
					if (response.success) {
						doRenderData( $container,response.data );
						self.hideModal();
					} else {
						self.hideModal();
						alert("MINIGRID BORKED");
					}
				},
				error: function(){
					self.hideModal();
					alert("MINIGRID PROCESS BORKED");
				}
				
			});		
		}

		function remoteSaveData( url,options ) {
			if(self.dataMap.dirty == 0) {
				return false;
			}
			else if(!settings.commitOnSave) {
				settings.afterSave(
					self.getDataMap()
				);
				self.dataMap.dirty = 0;
				return;				
			}

			self.showModal();
			var url = settings.url + "?load=true";

			options	= $.extend(options,settings.saveOptions,{id: self.dataMap.id} );

			options.data = JSON.stringify( getDataForSave() );

			$.ajax({
				url: url,
				type: 'POST',
				data: options,
				success: function( response ) {
					// Check to see if the request was successful.
					if (response.success){
						var up = updateDataMap( response,settings.afterSave );
						self.hideModal();
					} else {
						self.hideModal();
						alert("Error: " + response.message);
					}
				},
				error: function(){
					self.hideModal();
					alert("MINIGRID PROCESS BORKED");
				}
			});
			return true;
		}

		function doRerender( $container ) {	
			self.showModal();
			remoteLoadData();
		}

		doSerialize = function( $container ) {	
			if(!self.sort)
				return;
			var aOrder = $(".ui-minigrid-content",$container).sortable('toArray');
		
			self.dataMap.orderlist = [];
		
			for(var i = 0;i < aOrder.length;i++) {
				var id = self.dataMap.map[aOrder[i]];
				self.dataMap.records[id].row = i;
				self.dataMap.orderlist.push( id );
			}
		
			return aOrder;
		}

		function doAddRow( $container ) {
			var dataRow = {};
			var record = self.data.record;
			var ident = self.dataMap.rowcount;

			for(var i in record) {
				dataRow[record[i].name] = record[i].value;
			}
			dataRow[self.data.identity] = ident;
			self.dataMap.map[ident] = ident;

			var mapItem = {dirty: 1,del: false,row: self.dataMap.rowcount,phantom: 1,id: ident,data: dataRow};
			self.dataMap.records[ident] = mapItem;
			self.dataMap.dirty = 1;
			doInsertRow( $container,self.dataMap.records[ident],true );
			self.dataMap.rowcount++;
		}

		function doInsertRow( $container,rowData,focus ) {
			var $rowList = $(".ui-minigrid-content", $container);
			$row = buildGridRow( rowData );
			$rowList.append( $row );
			$(":text:first",$row).focus();

			refreshEven( $container );
		}
		self.getDataMap = function( $container ) {
			doSerialize( $container );
			return self.dataMap;
		}
		self.getIsDirty = function( $container ) {
			return self.dataMap.dirty;
		}
		self.getDataList = function( $container ) {
			doSerialize( $container );
			var list = [];
			var map = self.dataMap.map;
			for(var i in map) {
				var item = self.dataMap.records[ map[i] ];
				var record = {};
				record[self.data.identity] = item.id;
				record['label'] = item.data.label;
				list.push(record);
			}
			
			return list;
		}

		function getDataForSave( $container ) {
			var saveData = {};
			var needSort = false;
			
			saveData.id			= self.dataMap.id;
			saveData.params		= self.dataMap.params;
			saveData.global		= self.dataMap.global;
			saveData.order		= [];
			saveData.update		= {};
			saveData.save		= {};
			
			for(var i in self.dataMap.records) {
				if (self.dataMap.records[i].dirty == 1) {
					if (self.dataMap.records[i].phantom == 1) {
						needSort = true;
						saveData.save[i] = self.dataMap.records[i];
					}
					else {
						saveData.update[i] = self.dataMap.records[i];
					}
				}
			}

			if( self.dataMap.sorted == 1 || needSort) {
				doSerialize( $container );
				saveData.order = self.dataMap.orderlist;
			}

			if(settings.dataToFormField == true) {
				var jsonData = JSON.stringify( saveData );
				self.input.val( jsonData );
			}

			return saveData;
		}

		function refreshEven( $container ) {
			var $rowList = $(".ui-minigrid-content", $container);
			$("li.row", $rowList).removeClass('even');
			$("li.row:even", $rowList).addClass('even');
		}
	};

	$.minigrid = {};

	$.fn.minigrid.defaults = {
		width				: 253,
		height				: 200,				
		url					: '',
		data				: {},
		source				: {},
		loadMethod			: {},
		saveMethod			: {},
		id					: '',
		contentid			: '',
		onRenderComplete	: function() {},
		loadOptions			: {method: 'getDataProvider',returnFormat: 'json'},
		saveOptions			: {method: 'saveDataProvider',returnFormat: 'json'},
		afterSave			: function(){},
		sortIcon			: 'ui-icon-arrowthick-2-n-s',
		sortIconTitle		: 'sortable',
		autoloadTemplate	: true,
		commitOnSave		: true,
		resizable			: false,
		widthPrimary		: 130,
		widthSecondary		: 90,
		dataToFormField		: false,
		fieldname			: '',
		mode				: 'create'
	};
	
})($);