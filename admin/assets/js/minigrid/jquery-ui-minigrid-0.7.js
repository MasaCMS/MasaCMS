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
(function(jQuery) {

	var _container	= {};
	var _data		= {};

	jQuery.fn.minigrid = function( method ) {
		_container = jQuery(this);

		function init() {
			alert("init: " + _container);
			_container.data('_isInitialized',true);
						
			_data = {};
			
			self.isLoading = false;
			
			self.identity = '';
			self.sort = false;
			
			self.input = jQuery("<input type='hidden' name='" + settings.fieldname + "' id='minigrid-" + settings.id + "' value=''>");
			
			self.showModal = function(){
				jQuery(".ui-minigrid-modal", _container).show();
			}
			
			self.hideModal = function(){
				jQuery(".ui-minigrid-modal", _container).hide();
			}
			self.hideModal();
			renderGrid();
		} 

		if ( methods[method] ) {
			alert('method');
			return methods[method].apply( this, Array.prototype.slice.call( arguments, 1 ));
		} else if ( typeof method === 'object' || ! method ) {
			var options = methods.init.apply( this, arguments ); 
			init();
			return options;
		} else {
			jQuery.error( 'Method ' +  method + ' does not exist on jQuery.tooltip' );
		}    
	}
	
	// internal functions
	function renderGrid(){
		self.showModal();
		
		alert( self.sort );
		
		_container.width(settings.width);

		var $divBody		= jQuery("<div class='ui-minigrid'></div>");
		var $divModal		= jQuery("<div class='ui-minigrid-modal'><div class='ui-minigrid-spinner'></div></div>");
//		var $divButtonBar	= jQuery("<div class='ui-minigrid-buttonbar ui-widget-header ui-state-active'></div>");
		var $divHeader		= jQuery("<div class='ui-minigrid-header ui-widget-header ui-state-default ui-minigrid-boxed clearfix'></div>");
		var $divHeaderList	= jQuery("<ul class='ui-minigrid-header-list clearfix'></ul>");
		var $divContent		= jQuery("<div class='ui-minigrid-body ui-minigrid-boxed clearfix'></div>");
		var $divContentList	= jQuery("<ul class='ui-minigrid-content'></ul>");
		var $divResize		= jQuery("<div class='ui-resize'></div>");
		
		var $buttonCon		= jQuery("<ul class='table-buttons three left'></ul>")
		var $buttonCon2		= jQuery("<ul class='table-buttons one right'></ul>")
		
		var $buttonAdd = jQuery("<li class='bit'><span class='sb-button ui-state-default'><a id='minigrid-add' href='#' class='ui-icon ui-icon-document-b'></a></span></li>");
		var $buttonSave = jQuery("<li class='bit'><span class='sb-button ui-state-default'><a id='minigrid-save' href='#' class='ui-icon ui-icon-disk'></a></span></li>");
		var $buttonRefresh = jQuery("<li class='bit'><span class='sb-button ui-state-default'><a id='minigrid-refresh' href='#' class='ui-icon ui-icon-refresh'></a></span></li>");
		
		var $buttonOpenClose = jQuery("<li class='bit'><span class='sb-button ui-state-default'><a id='minigrid-openclose' href='#' class='ui-icon ui-icon-minus'></a></span></li>");
		$divBody.data('state', 1);
					
		$buttonCon.append(self.input);

	//	if( settings.mode == 'create')
			$buttonCon.append($buttonAdd);

//			$buttonCon.append($buttonSave);
		$buttonCon.append($buttonRefresh);
		
		$buttonCon2.append($buttonOpenClose);
		
//		$divButtonBar.append($buttonCon);
//		$divButtonBar.append($buttonCon2);
		
		$divHeader.append($divHeaderList);
		$divContent.append($divContentList);
		$divBody.append($divHeader);
		$divBody.append($divContent);
//		_container.append($divButtonBar);
		_container.append($divBody);
		_container.addClass("ui-minigrid");
		_container.append($divModal);
		_container.append($divResize);

		$buttonAdd.click(function(){
			doAddRow(_container);
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
			jQuery("#minigrid-openclose").toggleClass('ui-icon-minus').toggleClass('ui-icon-plus');
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
		doRenderButtons();
	}

	function doRenderButtons() {
		var $rowList = jQuery(".ui-minigrid-content", _container );
		// this is the up/down/tab key functionality
		_container.keydown( function( event ) {
			// down arrow
			if (event.keyCode == '38' && jQuery(event.target).attr('type') == 'text') {
				var $parent = jQuery(event.target).parents('ul:first').parent();					
				var index = $parent.index();
				if (index == 0) 
					return;
				
				var name = jQuery(event.target).attr('name');
				
				var newFocusTarget = jQuery("[name=" + name + "]", $parent.parent().children()[index - 1]);
				jQuery(event.target).change();
				newFocusTarget.focus();
			// up arrow
			} else if (event.keyCode == '40' && jQuery(event.target).attr('type') == 'text') {
				var $parent = jQuery(event.target).parents('ul:first').parent();
				var index = $parent.index();
				if(index+1 >= $parent.parent().children().length )
					return;

				var name = jQuery(event.target).attr('name');
				var newFocusTarget = jQuery("[name=" + name + "]", $parent.parent().children()[index + 1]);
				jQuery(event.target).change();
				newFocusTarget.focus();
			// tab key
			}  else if (event.keyCode == '9' && event.shiftKey == false) {
				var $master = jQuery(event.target).parents('ul:first');
				var $parent = $master.parent();
				var $children = $master.children();
				var index = $parent.index();
				if(self.sort)
					var pos = 2;
				else
					var pos = 1;

				if (index + 1 == $parent.parent().children().length && jQuery(event.target).parent().index() + pos == $children.length) {
					jQuery(event.target).change();
					doAddRow(_container);
					event.preventDefault();
				}
			}

		});

		// this is the data binding for checkboxes,radio buttons
		jQuery(":checkbox,:radio",$rowList).live('change',function( event ) {
			var $tgt	= jQuery(event.target); 
			var aID		= $tgt.attr('id').split("_");
			var pos		= aID[0];
			var name	= aID[1];
			var value	= $tgt.attr('value');
			var type	= $tgt.attr('type');
			var id		= self.dataMap.map[pos];
			
			switch (type) {
				case 'checkbox' :
					self.dataMap.records[id].data[name] = $tgt.is(':checked') ? value : 0; 
					self.dataMap.records[id].isdirty = 1;
				break;
				case 'radio' :
					self.dataMap.records[id].data[name] = $tgt.is(':checked') ? 1 : 0; 
					self.dataMap.global[name] = value; 
					self.dataMap.records[id].isdirty = 1;
				break;
			}
			self.dataMap.isdirty = 1;
		});

		// this is the binding for text inputs
		jQuery(":text",$rowList).live('keyup',function( event ) {
			var $tgt	= jQuery(event.target); 
			
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
			self.dataMap.records[id].isdirty = 1;
			self.dataMap.isdirty = 1;
		});

		// this is the binding for delete keys
		jQuery(".ui-icon-close",$rowList).live('click',function( event ) {
			var $tgt	= jQuery(event.target);
			var $parent	= $tgt.parents("ul:first").parent();
			var pos	= $parent.attr('id');
			var id =  self.dataMap.map[pos];

			if(!self.dataMap.records[id])
				return;

			if( self.dataMap.records[id].isphantom ) {
				delete self.dataMap.records[id];
				delete self.dataMap.map[pos];		
				if( !settings.commitOnSave )
					self.dataMap.isdirty = 1;
			} else {
				self.dataMap.records[id].isdirty = 1;
				self.dataMap.records[id].del = true;
				self.dataMap.isdirty = 1;
//					alert( myDump( self.dataMap.records[id],"","  ",0,30) );
			}
			$parent.remove();
			refreshEven();
		});
	}

	function doRenderData() {
		var $rowList = jQuery(".ui-minigrid-content", _container );
		self.showModal();
				
		// create data map
		self.identity = data.identity;
		self.sort = data.sortable;
		
		createDataMap(data);
		
		// clear headers, record elements
		doClear();
		
		// unbind previous bindings
		_container.unbind();
		jQuery(":checkbox,:radio", $rowList).unbind();
		jQuery(":text", $rowList).unbind();
		jQuery(".ui-icon-close", $rowList).unbind();
		jQuery(".ui-minigrid-body", _container).resizable('destroy');
		jQuery(".ui-minigrid-body", _container).attr('style', '');
		
		// make this sortable as required
		if (self.sort == true) {
			$rowList.sortable({
				axis: 'y',
				opacity: 0.6,
				delay: 200,
				update: function(event, ui){
					self.dataMap.isdirty = 1;
					self.dataMap.sorted = 1;
					refreshEven(_container);
				}
			});
		}
		// build header
		if( data.columns.length )
			doBuildHeader();
		
		// build rows
		if( data.rows.length )
			doBuildRows();
		
		settings.onRenderComplete();
						
		self.hideModal();
	}

	function createDataMap( data ) {
		if( data )
			self.data = jQuery.extend(true,{},data);
			
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
		self.dataMap.isdirty		= 0;
		self.dataMap.sorted		= 0;
		self.dataMap.global		= {};		
		self.dataMap.records	= {};
		self.dataMap.orderlist	= [];
		
		// treat as a struct as data may be coming in that way
		for (var cr in rows) {
			var ident	= rows[cr].data[identity];
			self.dataMap.map[self.dataMap.rowcount] = ident;
			self.dataMap.rowcount++;
			var mapItem = {isdirty:0,id:ident,data: {}};
			mapItem = jQuery.extend(true,mapItem,rows[ cr ]);
			mapItem.row = cr;
			self.dataMap.records[ident] = mapItem;
		}
	}

	function updateDataMap( data,callback ) {
		for(var i in data.isphantoms) {
			if(self.dataMap.records[i]) {
				var dataItem = jQuery.extend(true,{},self.dataMap.records[i]);
				self.dataMap.map[i] = data.isphantoms[i];
				dataItem.data[self.data.identity] = dataItem.id = data.isphantoms[i];
				dataItem.isphantom = 0;
				self.dataMap.records[ data.isphantoms[i] ] = dataItem;
				delete self.dataMap.records[i];
			}
		}
		for(var i in data.clean) {
			self.dataMap.records[i].isdirty = 0;
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
					
		self.dataMap.isdirty = 0;
		self.dataMap.sorted = 0;

		self.hideModal();

		callback (
			self.getDataMap()
		)
		return;
	}

	function doBuildHeader() {
		var $headerList = jQuery(".ui-minigrid-header-list", _container);
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
		$headerList.append( jQuery(row) );
		_container.width( 1500 );
		_container.width( jQuery(".column", $headerList).width() + 19 );
		jQuery(".ui-minigrid-body",_container).height( settings.height );
			if( settings.resizable ) {
				jQuery(".ui-resize",_container).resizable({ handles: 's',alsoResize: ".ui-minigrid-body",
					resize: function(event, ui) {
						jQuery(".ui-resize",_container).attr('style','');		
					}
				 });
			}
			else {
				jQuery(".ui-minigrid-body",_container).addClass('ui-minigrid-bordered');
			}
		}

	function doBuildRows() {
		// bind listener
		var $rowList = jQuery(".ui-minigrid-content", _container);
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
		jQuery("li.row:even", $rowList).addClass('even');
	}

	function buildGridRow( dataItem ) {
		var columns		= self.data.columns;
		var identity	= self.data.identity;
		var record		= dataItem.data;

		var $row = jQuery("<ul class='column'></ul>" );
		if (settings.mode == 'create') {
			var $button = jQuery("<li class='bit'><span class='sb-button ui-state-default'><a href='#' class='ui-icon ui-icon-close'></a></span></li>");
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
					
					$col = jQuery(aCol.join(''));
				break;
				case 'checkbox' :
					aCol.push("<li class='bit'><input class='checkbox' id='");	
					aCol.push(dataItem.row + "_" + columns[cc].name);
					if( record[columns[cc].name] != '' && record[columns[cc].name] != 0 )
						aCol.push("' checked='checked");
					aCol.push("' value='1' type='checkbox'></li>");
					$col = jQuery(aCol.join(''));
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
						$col = jQuery(aCol.join(''));
					}
					else {
						if(columns[cc].name == 'label')
							$col = jQuery("<li class='col' style='width: " + settings.widthPrimary +"px'>" + record[columns[cc].name] +"</li>");	
						else	
							$col = jQuery("<li class='col' style='width: " + settings.widthSecondary +"px'>" + record[columns[cc].name] +"</li>");	
					}
				break;
			}
			$row.append( $col );
		}

		if(self.sort)
			$row.append( jQuery("<li class='sort'><span class='ui-icon ui-icon-grip-dotted-vertical'></span></li>") );

		$fullrow = jQuery("<li class='row clearfix'></li>").append($row);
		$fullrow.attr('id',dataItem.row);
		return $fullrow;			
	}

	function doClear() {
		jQuery(".ui-minigrid-header-list", _container).children().remove();
		jQuery(".ui-minigrid-content", _container).children().remove();
	}

	function render( template, map ){
		return template.render( map );
	}

	function doRerender() {	
		self.showModal();
		remoteLoadData();
	}

	doSerialize = function() {	
		if(!self.sort)
			return;
		var aOrder = jQuery(".ui-minigrid-content",_container).sortable('toArray');
	
		self.dataMap.orderlist = [];
	
		for(var i = 0;i < aOrder.length;i++) {
			var id = self.dataMap.map[aOrder[i]];
			self.dataMap.records[id].row = i;
			self.dataMap.orderlist.push( id );
		}
	
		return aOrder;
	}

	function doAddRow() {
		var dataRow = {};
		var record = self.data.record;
		var ident = self.dataMap.rowcount;

		for(var i in record) {
			dataRow[record[i].name] = record[i].value;
		}
		dataRow[self.data.identity] = ident;
		self.dataMap.map[ident] = ident;

		var mapItem = {isdirty: 1,del: false,row: self.dataMap.rowcount,isphantom: 1,id: ident,data: dataRow};
		self.dataMap.records[ident] = mapItem;
		self.dataMap.isdirty = 1;
		doInsertRow( _container,self.dataMap.records[ident],true );
		self.dataMap.rowcount++;
	}

	function doInsertRow( _container,rowData,focus ) {
		var $rowList = jQuery(".ui-minigrid-content", _container);
		$row = buildGridRow( rowData );
		$rowList.append( $row );
		jQuery(":text:first",$row).focus();

		refreshEven();
	}
	self.getDataMap = function() {
		doSerialize();
		return self.dataMap;
	}
	self.getIsisdirty = function() {
		return self.dataMap.isdirty;
	}
	self.getDataList = function() {
		doSerialize();
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

	function getDataForSave() {
		var saveData = {};
		var needSort = false;
		
		saveData.id			= self.dataMap.id;
		saveData.params		= self.dataMap.params;
		saveData.global		= self.dataMap.global;
		saveData.order		= [];
		saveData.update		= {};
		saveData.save		= {};
		
		for(var i in self.dataMap.records) {
			if (self.dataMap.records[i].isdirty == 1) {
				if (self.dataMap.records[i].isphantom == 1) {
					needSort = true;
					saveData.save[i] = self.dataMap.records[i];
				}
				else {
					saveData.update[i] = self.dataMap.records[i];
				}
			}
		}

		if( self.dataMap.sorted == 1 || needSort) {
			doSerialize();
			saveData.order = self.dataMap.orderlist;
		}

		if(settings.dataToFormField == true) {
			var jsonData = JSON.stringify( saveData );
			self.input.val( jsonData );
		}

		return saveData;
	}

	function refreshEven() {
		var $rowList = jQuery(".ui-minigrid-content", _container );
		jQuery("li.row", $rowList).removeClass('even');
		jQuery("li.row:even", $rowList).addClass('even');
	}

	jQuery.fn.minigrid.defaults = {
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

	var settings = jQuery.fn.minigrid.defaults;

	var methods = {
		init : function( options ) {
			settings = jQuery.extend({},jQuery.fn.minigrid.defaults,options );
		},
		set : function( data ) {
			doRenderData( data );	
		}
	};
})(jQuery);