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
(function( jQuery ){

	var _formData		= {};
	var _dataSets		= {};
	var _formStatus		= {};

	var _list			= {};

    delete Array.prototype.toJSON;

	jQuery.fn.templatebuilder = function( action ) {
		
		if(action) {
			var _submitdata = {};
			var _submitFieldOrder = [];
						
			_submitdata.form = _formData;
			_submitdata.datasets = _dataSets;
			
			jQuery('#mura-formdata').val(  JSON.stringify( _submitdata ) );
			return false;
		}
		
		var settings		= jQuery.extend({},jQuery.fn.templatebuilder.defaults,settings);

		var _formInitData = jQuery.parseJSON( jQuery("#mura-formdata").val() ); 

		var _templates	= {};

		var _currentFieldBtn= '';
		var _currentFieldID	= '';
		var $_field		= jQuery('#mura-tb-field');
		var $_grid		= jQuery('#mura-tb-grid');
		var $_gridtable	= '';
		var $_gridhead	= '';

		var _rowCounter	= 0;

		if(!settings.url)
			settings.url = jQuery("#mura-templatebuilder").attr('data-url');

		doInitFormBuilder( _formInitData );		
		
		function doInitFormBuilder( data ) {
			$_field.hide();
			$_grid.hide();

			jQuery('#mura-tb-fields').sortable({
				axis: 'y',
				opacity: 0.6,
				delay: 200,
				update: function(event, ui) {
					jQuery(this).children().each( function() {
					})
					_formData.fieldorder = jQuery('#mura-tb-fields').sortable('toArray');
					_formData.issortchanged = 1;
				}
			});

			doActivateMenu();

//			if(settings.formid.length)
//				goLoadForm( {formid:settings.formid} );
//			else
				doRenderForm( data );
		}

		function doRenderForm( response ) {
			doClearForm();

			_formData = response.form;
			_dataSets = response.datasets;

			_formStatus.fields			= {};
			
			doAddFields();
		}

		function doUpdateForm( response ) {
		}

		function doAddFields() {
			for( var i = 0;i < _formData.fieldorder.length;i++ ) {
				doAddField( _formData.fields[_formData.fieldorder[i]] );
			}
		}
	
		function doCreateField( obj ) {
			_formData.fieldorder.push(obj.fieldid);
			_formData.fields[obj.fieldid] = obj;
			doAddField( obj );
		}

		function doAddField( obj ) {
			var $fieldBlock = jQuery('<li><div class="'+obj.fieldtype.displaytype+'" data-field=\'{"fieldType":"field-'+obj.fieldtype.fieldtype+'","fieldID":"'+obj.fieldid+'"}\'><span>'+obj.label+'</span></div></li>');
			$fieldBlock.attr('id',obj.fieldid);
			jQuery('#mura-tb-fields').append( $fieldBlock );
		}
	
		function doActivateMenu() {
			jQuery("#mura-templatebuilder .mura-tb-menu div").each( function(){
				var $btn = jQuery(this);
				$btn.click( function() {
					switch ( jQuery(this).attr('id') ) {
						case 'button-save': {
							goSaveForm();
						}
						break;
						case 'button-form': {
							goLoadForm();
						}
						break;
						case 'button-show': {
							alert( myDump( _formData ,"","  ",0,30) );
						}
						break;
						case 'button-grid-edit': {
							
						}
						break;
						default:
							goLoadField( jQuery(this).attr('data-object'),_formData.formid );
						break;
					}
				});
			});
			jQuery("#mura-tb-fields li div").on( 'click', function() {
				doField( this );
			});			
		}

		function doField( fieldBtn ) {
			var $btn		= jQuery( fieldBtn );

			var jsonData		= $btn.attr('data-field');
			var data			= jQuery.parseJSON( jsonData );
			var fieldData		= _formData.fields[data.fieldID];
			var templateName	= "field-" + fieldData.fieldtype.fieldtype;

			$_field.hide();
			$_grid.hide();

			_currentFieldBtn = $btn;
			_currentFieldID = data.fieldID;

			if (_templates[templateName] == undefined) 
				goLoadTemplate(templateName);
			else {
				doRenderField();
			}

			if(fieldData.fieldtype.isdata == 1) {
				if( fieldData.datasetid.length && _dataSets[fieldData.datasetid] == false )
					goLoadDataset();
				else if( fieldData.datasetid.length )
					doDataset();
				else {
					goCreateDataset();
				}
			}
			
			
		}
		
		function doRenderField() {
			var fieldData		= _formData.fields[_currentFieldID];
			var templateName	= "field-" + fieldData.fieldtype.fieldtype;

			jQuery(".tb-label").unbind();
			jQuery('.ui-button',$_field).each(function() {
				jQuery(this).unbind();	
			});
			

			jQuery('#mura-tb-field-form').unbind();
			$_field.html(_templates[templateName]);
			$_field.show();

			jQuery('#mura-tb-form').jsonForm({source: fieldData,createOnNull: true,createOnDataNull: true,bindBy: 'name',baseObject: 'field'});

			jQuery('#mura-tb-form').bind('jsonformField', function( event,values ) {
				if (values.kind == 'update') {
					fieldData.isdirty = 1;
					_formData.isdirty = 1;
				}
			});

			jQuery("#mura-tb-form #mura-tb-form-label").html( jQuery(".tb-label").val() );

			jQuery(".tb-label").keyup(function() {
				var val = jQuery(this).val();
				var fval = val.replace(/[^A-Za-z]/g,"").toLowerCase();

				jQuery("#tb-name").val( fval );
				jQuery("#tb-name").trigger('change');
				
				jQuery("span",_currentFieldBtn).html( val );				
				jQuery("#mura-tb-form-label").html( val );
			});

			jQuery('.ui-button',$_field).each(function() {
				jQuery(this).click( function() {
					//alert('click');
					switch ( jQuery(this).attr('id') ) {
						case 'button-trash': {
							doDeleteField();
						}
						break;
					}
				});
			});

		}

		function doDeleteField() {
			var fieldData		= _formData.fields[_currentFieldID];
			var $fieldButton	= jQuery("#" + _currentFieldID);

			delete _formData.fields[_currentFieldID]; 			

			$fieldButton.remove();
			$_field.hide();
			$_grid.hide();
			_formData.fieldorder = jQuery('#mura-tb-fields').sortable('toArray');
			if( fieldData.datasetid.length ) {
				delete _dataSets[fieldData.datasetid];
			}
		}

		function doDataset() {
			var fieldData	= _formData.fields[_currentFieldID];
			var datasetID	= fieldData.datasetid; 


			if (_templates['dataset-grid'] == undefined) 
				goLoadTemplate('dataset-grid',doRenderDataset);
			else {
				doRenderDataset();
			}
		}
		
		function doRenderDataset() {

			var fieldData	= _formData.fields[_currentFieldID];
			var datasetID	= fieldData.datasetid; 
			var data		= _dataSets[datasetID];

			if(!data.config.mode)
				data.config.mode	= 'edit'; 

			jQuery('.ui-button',$_grid).unbind();
			$_grid.html( _templates['dataset-grid'] );
			$_gridtable	= jQuery('#mura-tb-grid-table');
			$_gridhead	= jQuery('#mura-tb-grid-table-header');

			jQuery('.ui-button',$_grid).click(function() {
				switch ( jQuery(this).attr('id') ) {
					case 'button-grid-dump': {
						alert( myDump( data ,"","  ",0,30) );
					}
					break;
					case 'button-grid-edit': {
						if( data.config.mode != 'create' )
							setDataMode('create');
						else
							setDataMode('edit');

						doRenderDataset();
					}
					break;
					case 'button-grid-add': {
						doRenderRow();
					}
					break;
					case 'button-grid-reload': {
						if( data.isdirty || data.issortchanged )
							doDisplayDialog( 'message-reload-dataset',goLoadDataset );
					}
					break;
					case 'button-grid-edit': {
						
					}
					break;
				}
			});

			$_grid.show();
			doRenderData();
		}
		
		function setDataMode( mode ) {
			var fieldData	= _formData.fields[_currentFieldID];
			var datasetID	= fieldData.datasetid; 
			var data		= _dataSets[datasetID];

			data.config.mode = mode;
		}
		
		function doRenderData() {
			if (_templates['dataset-row'] == undefined) 
				goLoadTemplate('dataset-row',doRenderRows);
			else {
				doRenderRows();
			}
		}

		function doRenderRows() {
			var fieldData	= _formData.fields[_currentFieldID];
			var datasetID	= fieldData.datasetid; 
			var data		= _dataSets[datasetID];
			var record 		= "";

			jQuery(":input",$_gridtable).unbind();

			var $row 		= "";
			$_gridtable.html('');
			$_gridhead.html('');
			
			if (data.sorttype == 'manual') {
				$_gridtable.sortable({
					axis: 'y',
					opacity: 0.6,
					delay: 200,
					update: function(event, ui){
						var i = 0;
						jQuery(this).children().each(function(){
							i++;
							if (i % 2) 
								jQuery(this).addClass('alt');
							else 
								jQuery(this).removeClass('alt');
						})
						data.datarecordorder = $_gridtable.sortable('toArray');
						data.issortchanged = 1;
					},
					receive: function(event, ui){
					}
				})
			}
			
			doRenderGridHeader();

			if(data.config.mode == 'create') {
				jQuery('#mura-tb-grid-message').show();
			}
			else
				jQuery('#mura-tb-grid-message').hide();

			
			for(var i = 0;i < data.datarecordorder.length;i++) {
				record = data.datarecords[ data.datarecordorder[i] ];
				if( record )
					doRenderRow( record );
			}
		}

		function doDeleteRow( args ){
			var fieldData	= _formData.fields[_currentFieldID];
			var datasetID	= fieldData.datasetid; 
			var data		= _dataSets[datasetID];
			var id			= args.id;
			
			jQuery("#"+id,$_gridtable).remove();

			if (!data.datarecords[id].config.isphantom) {
				data.deletedrecords[id] = 1;
				data.isdirty = 1;
			}

			delete data.datarecords[id];

			for(var i = 0;i < data.datarecordorder.length;i++) {
				if( data.datarecordorder[i] == id ) {
					data.datarecordorder.splice(i,1);
					break;					
				}
			}

		}

		function doRenderGridHeader() {
			var fieldData	= _formData.fields[_currentFieldID];
			var datasetID	= fieldData.datasetid; 
			var data		= _dataSets[datasetID];
			var $rowHTML	= jQuery(_templates['dataset-row']);
			var cell		= jQuery('#element-cell',$rowHTML).html();
			var row			= jQuery('#element-row',$rowHTML).html();
			var $cell		= "";
			var $row		= jQuery(row);

			
			//isInSet
			$cell = jQuery(cell);
			$cell.addClass('mura-tb-cell-small');
			$row.append($cell);
			$cell = jQuery(cell);
			$cell.addClass('mura-tb-cell-input');
			$cell.html( jQuery('#element-labels #label',$rowHTML).html() );
			$row.append($cell);

			for( var i = 0;i < settings.dataColumns.length;i++) {
				colName		= settings.dataColumns[i];
				isColUsed	= data["is"+colName];
				$cell = jQuery(cell);
				$cell.addClass('mura-tb-cell-input');
				if (isColUsed) {
					$cell.html( jQuery('#element-labels #'+colName,$rowHTML).html() );
					$row.append($cell);
				}
			}

			$_gridhead.append($row);

			jQuery(".mura-tb-cell-input",$row).each( function() {
				jQuery(this).width( (550/(settings.dataColumns.length+2)) );
			});
		}
		
		function doAddRecord() {
			var fieldData	= _formData.fields[_currentFieldID];
			var datasetID	= fieldData.datasetid; 
			var data		= _dataSets[datasetID];

			var newID 			= ++_rowCounter;
			var newDataRecord	= jQuery.extend({},data.model);

			data.isdirty = 1;
			newDataRecord.config = {};
			
			newDataRecord.datarecordid = newID;
			newDataRecord.config.isphantom = 1;
			newDataRecord.isdirty = 1;
			
			data.datarecordorder.push(newID);
			data.datarecords[newID] = newDataRecord;
			
			return newDataRecord;
		}
		
		function doRenderRow( record ) {
			if(!record) {
				record = doAddRecord();
			}

			var fieldData	= _formData.fields[_currentFieldID];
			var datasetID	= fieldData.datasetid; 
			var data		= _dataSets[datasetID];

			var editMode	= 0;

			var colName		= "";
			var isColUsed	= "";
			var $rowHTML	= jQuery(_templates['dataset-row']);
			
			var cell		= jQuery('#element-cell',$rowHTML).html();
			var display		= jQuery('#element-display',$rowHTML).html();
			var input		= jQuery('#element-input',$rowHTML).html();
			var checkbox	= jQuery('#element-checkbox',$rowHTML).html();
			var radio		= jQuery('#element-radio',$rowHTML).html();
			var row			= jQuery('#element-row',$rowHTML).html();
			var handle		= jQuery('#element-handle',$rowHTML).html();
			var bt_delete	= jQuery('#element-button-delete',$rowHTML).html();
			
			var $cell		= "";
			var $display	= "";
			var $input		= "";
			var $row		= "";
			var $checkbox	= "";
			var $row		= "";
			var $handle		= "";
			var $bt_delete	= "";

			if(data.config.mode == 'create' || data.issubset == 0 || record.config.isphantom == 1) {
				editMode = 1;
			}

			$row = jQuery(row);
			$row.attr('id',record.datarecordid);

			{
				// isInSet
				$cell = jQuery(cell);
				$cell.addClass('mura-tb-cell-small');
				$checkbox = jQuery(checkbox);
				$checkbox.attr('data-id', record.datarecordid);
				$checkbox.attr('name', 'isinset');
				$checkbox.attr('checked', record.isinset == 1);
				$cell.append($checkbox);
				$row.append($cell);
			}
			
			// label
			$cell = jQuery(cell);
			$cell.addClass('mura-tb-cell-input');
			if (editMode) {
				$input = jQuery(input);
				$input.attr('data-id', record.datarecordid);
				$input.attr('name', 'label');
				$input.val(record.label);
				$cell.append($input);
				$row.append($cell);
			}
			else {
				$display = jQuery(display);
				$display.attr('title', record.label);
				$display.html(record.label);
				$cell.append($display);
				$row.append($cell);
			}
/*
			$cell = jQuery(cell);
			$cell.addClass('mura-tb-cell-input');
			$input = jQuery(input);
			$input.attr('data-id',record.datarecordid);
			$input.attr('name','rblabel');
			$input.val(record.rblabel);
			$cell.append($input);
			$row.append($cell);
*/
			
			for( var i = 0;i < settings.dataColumns.length;i++) {
				colName		= settings.dataColumns[i];
				isColUsed	= data["is"+colName];
				$cell = jQuery(cell);

				$cell.addClass('mura-tb-cell-input');
				if (isColUsed && editMode) {
					$input = jQuery(input);
					$input.attr('data-id', record.datarecordid);
					$input.attr('name', colName);
					$input.val(record[colName]);
					$cell.append($input);
					$row.append($cell);
				}
				else if (isColUsed) {
					$display = jQuery(display);
					$display.attr('name', colName);
					$display.html(record[colName]);
					$cell.append($display);
					$row.append($cell);
				}
			}
			
			if(data.sorttype == 'manual') {
//				$handle = jQuery(handle);
//				$row.append($handle);
				$row.css('border-right','15px solid #435f8b');
			}

			if (editMode || record.config.isphantom == 1) {
				// delete
				$cell = jQuery(cell);
				$cell.addClass('mura-tb-cell-small button');
				$bt_delete = jQuery(bt_delete);
				$bt_delete.attr('data-id', record.datarecordid);
				$cell.append($bt_delete);
				$row.append($cell);
			}

			jQuery(".mura-tb-cell-input",$row).each( function() {
				jQuery(this).width( (550/(settings.dataColumns.length+2)) );
			});

			$_gridtable.append($row);

			if($_gridtable.children().length % 2)
				$row.addClass('alt');

			jQuery(".mura-tb-grid-input",$row).each( function() {
				jQuery(this).keyup( function() {
					var name = jQuery(this).attr('name');
					var id = jQuery(this).attr('data-id');
					data.datarecords[id][name] = jQuery(this).val();
					data.datarecords[id].isdirty = 1;
					data.isdirty = 1;	
				} );
			});

			jQuery('.button-grid-row-delete',$row).click( function() {
				var id = jQuery(this).attr('data-id');
				doDisplayDialog( 'message-delete-row',doDeleteRow,{'id':id} );
			})

			jQuery(".mura-tb-grid-checkbox",$row).change( function() {
				var name = jQuery(this).attr('name');
				var id = jQuery(this).attr('data-id');
				data.datarecords[id][name] = jQuery(this).is(":checked") ? 1 : 0;
				data.datarecords[id].isdirty = 1;
				data.isdirty = 1;	
			} );

			return $row;
		}

		function doDisplayNewDatasetForm(sFieldID){
			//if (_templates['dataset-new'] == undefined) 
			//	goLoadField(_currentFieldID,'dataset-new');
			//else if( fieldData.fieldtype.isdata != 1) {
				doDisplayDialog( 'message-dataset-new' );
			//}
			
		}

		function doDisplayDialog( template,onYes,args,lblYes,lblNo ) {
			bt = {};
			bt[ !lblYes ? settings.lbl['yes'] : lblYes ] = function() {
				jQuery(this).dialog('close');
				if (onYes) 
					onYes(args);
			};
			bt[ !lblNo ? settings.lbl['no'] : lblNo ] = function(){
				jQuery(this).dialog('close');
			};
						
			if (!_templates[template]) {
				goLoadDialog( template,onYes,args );
			}
			else {
				jQuery("<div id='closable' style='display: none'>" + _templates[template] + "</div>").dialog({
					modal: true,
					resizable: false,
					buttons: bt
				});
			}
		}

		function isFieldDirty(fieldID){
			return _formStatus.fields.dirty[fieldID] == undefined ? false : true; 
		}

		function isFieldNew(fieldID){
			return _formStatus.fields.created[fieldID] == undefined ? false : true; 
		}
		

		function doClearForm() {
			jQuery('#mura-tb-fields').children().remove();
			$_field.html('');
		}
		
		function goLoadField( type ) {
			var self = this;
			var data = {};
//			var fieldData	= _formData.fields[_currentFieldID];
			var fieldtype	= type;
			var iefix 		= Math.floor(Math.random()*9999999);
			
			data.fieldtype = fieldtype;
			data.formid = _formData.formid;
			
			jQuery.ajax({
				url: settings.url + "?muraAction=cform.getfield&i=" + iefix,
				type: 'POST',
				data: data,
				cache: false,
				success: function( response ) {
					doCreateField( response );
				},
				error: function(){
					alert('fail: load field');
				}
			});		
		}
		
		function goLoadTemplate( template,fn1 ) {
			var data = {};
			var iefix 		= Math.floor(Math.random()*9999999);

			data.fieldType = template;

			jQuery.ajax({
				url: settings.url + "?muraAction=cform.getfieldtemplate&i=" + iefix,
				type: 'POST',
				data: data,
				cache: false,
				success: function( response ) {
					_templates[template] = response;
					doRenderField();
				},
				error: function(){
					alert('fail: load template');
				}
			});		
		}
		
		function goLoadDialog( template,fn,args,lblYes,lblNo ) {
			var data = {};

			data.fieldType = template;

			jQuery.ajax({
				url: settings.url + "?action=admin:data.field",
				type: 'POST',
				data: data,
				cache: false,
				success: function( response ) {
					_templates[template] = response;
					doDisplayDialog( template,fn,args,lblYes,lblNo );
				},
				error: function(){
					alert('fail: load dialog');
				}
			});		
		}

		function goLoadDataset( datasetID ) {
			var data = {};
			var fieldData	= _formData.fields[_currentFieldID];

			data.datasetID = datasetID == undefined ? fieldData.datasetid : datasetID;

			jQuery.ajax({
				url: settings.url + "?action=admin:data.dataset",
				type: 'POST',
				data: data,
				cache: false,
				success: function( response ) {
					_dataSets[data.datasetID] = response;
					doDataset();
				},
				error: function(){
					alert('fail: load dataset');
				}
			});		
			
		}

		function goCreateDataset() {
			var data = {};
			var fieldData	= _formData.fields[_currentFieldID];

			jQuery.ajax({
				url: settings.url + "?action=admin:data.dataset",
				type: 'POST',
				data: data,
				cache: false,
				success: function( response ) {
					_dataSets[data.datasetID] = response;
					doDataset();
				},
				error: function(){
					alert('fail: load dataset');
				}
			});		
			
		}

		function goLoadForm( data ) {
			if(!data) {
				data = {};
				data.formid ;
			}
				
			jQuery.ajax({
				url: settings.url + "?action=admin:data.form",
				type: 'POST',
				data: data,
				cache: false,
				success: function( response ) {
					doRenderForm( response );
				},
				error: function(){
					alert('fail: load form');
				}
			});		
		}

		function goSaveForm() {
			var data = {};
			var changed = getChanged();
			
			if(!changed.isdirty) {
				return;
			}
			
			data.changed = JSON.stringify( changed );
			
			jQuery.ajax({
				url: settings.url + "?action=admin:data.save",
				type: 'POST',
				data: data,
				cache: false,
				success: function( response ) {
					doUpdateForm( response );
				},
				error: function(){
					alert('fail: save form');
				}
			});		
		}

		function getFormData(){
			var sData = {};
			for(var i in _formData ) {
				if( typeof _formData[i] == 'string') {
					sData[i] = _formData[i];
				}
			}
			return sData;
		}

		function getDatasetData( id ){
			var sData = {};
			var Dataset = _dataSets[id];
			
			for(var i in Dataset ) {
				if( typeof Dataset[i] == 'string') {
					sData[i] = Dataset[i];
				}
			}
			return sData;
		}
	};

	jQuery.templatebuilder = {};

	jQuery.fn.templatebuilder.defaults = {
		url:			'',
		formid:			'',
		mode:	 		'create',
		dataColumns:	[],
		lbl:			{'yes':'Yes','no':'Cancel','cancel':'Cancel'}
	};

	jQuery.templatebuilder.clear = function( $container ) {
	}

	myDump = function(obj, name, indent, depth, maxdepth) {
			var self = this;
	
		if(!maxdepth)
			maxdepth = 1;
	
		if (depth > maxdepth) {
		     return indent + name + ": <Maximum Depth Reached>\n";
		}
		
		if (typeof obj == "object") {
		     var child = null;
		     var output = indent + name + "\n";
		     indent += "\t";
		     for (var item in obj)
		     {
		           try {
		                  child = obj[item];
		           } catch (e) {
		                  child = "<Unable to Evaluate>";
		           }
		           if (typeof child == "object") {
						  output += myDump(child, item, indent,depth++,maxdepth);
		           } else {
		                  output += indent + item + ": " + child + "\n";
		           }
		     }
		     return output;
		} else {
		     return obj;
		}
	}
})(jQuery);