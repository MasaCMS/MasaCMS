(function( jQuery ){

	var _formData		= {};
	var _dataSets		= {};
	var _formStatus		= {};
	var _selected		= "";

	var _list			= {};

	if(window.Prototype) {
	    delete Object.prototype.toJSON;
	    delete Array.prototype.toJSON;
	    delete Hash.prototype.toJSON;
	    delete String.prototype.toJSON;
	}

	jQuery.fn.templatebuilder = function( action ) {
		
		if(action) {
			var _submitdata = {};
			var _submitFieldOrder = [];
						
			_submitdata.form = _formData;
			_submitdata.datasets = _dataSets;
			
			jQuery('#meld-formdata').val(  JSON.stringify( _submitdata ) );
			return false;
		}
		
		var settings		= jQuery.extend({},jQuery.fn.templatebuilder.defaults,settings);

		var _formInitData = jQuery.parseJSON( jQuery("#meld-formdata").val() ); 

		var _templates	= {};

		var _currentFieldBtn= '';
		var _currentFieldID	= '';
		var _currentDataset	= '';
		var $_field		= jQuery('#meld-tb-field');
		var $_dataset	= jQuery('#meld-tb-dataset-form');
		var $_grid		= jQuery('#meld-tb-grid');
		var $_gridtable	= '';
		var $_gridhead	= '';

		var _rowCounter	= 0;

		if(!settings.url)
			settings.url = jQuery("#meld-templatebuilder").attr('data-url');

		doInitFormBuilder( _formInitData );		
		
		function doInitFormBuilder( data ) {
			$_field.hide();
			$_grid.hide();

			jQuery('#meld-tb-fields').sortable({
				axis: 'y',
				opacity: 0.6,
				delay: 200,
				update: function(event, ui) {
					jQuery(this).children().each( function() {
					})
					_formData.fieldorder = jQuery('#meld-tb-fields').sortable('toArray');
					_formData.issortchanged = 1;
				}
			});

			doActivateMenu();

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
			$fieldBlock.attr('class','field-'+obj.fieldtype.fieldtype);
			jQuery('#meld-tb-fields').append( $fieldBlock );
		}
	
		function doActivateMenu() {
			jQuery("#meld-templatebuilder .meld-tb-menu div").each( function(){
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
			jQuery("#meld-tb-fields li div").live( 'click', function() {
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
			$_dataset.hide();
			$_grid.hide();

			if(_currentFieldBtn != undefined)
				jQuery(_currentFieldBtn).removeClass('selected');

			_currentFieldBtn = $btn;
			_currentFieldID = data.fieldID;
								
			jQuery(_currentFieldBtn).addClass('selected');

			if (_templates[templateName] == undefined) 
				goLoadTemplate(templateName);
			else {
				doRenderField();
			}

			if(fieldData.fieldtype.isdata == 1) {
				if (fieldData.datasetid.length) {
					doDataset();
				}
				else {
					goLoadDataset();
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
			

			jQuery('#meld-tb-field-form').unbind();
			$_field.html(_templates[templateName]);
			$_field.show();

			jQuery('#meld-tb-form').jsonForm({source: fieldData,createOnNull: true,createOnDataNull: true,bindBy: 'name',baseObject: 'field'});

			jQuery('#meld-tb-form').bind('jsonformField', function( event,values ) {
				if (values.kind == 'selected') {
					if(_selected != undefined)
						jQuery(_selected).removeClass('selected');
										
					_selected = values.object;
					jQuery(_selected).addClass('selected');
				}
				else if (values.kind == 'update') {
					alert(event.field);
					fieldData.isdirty = 1;
					_formData.isdirty = 1;
					
				}
			});

			jQuery("#meld-tb-form #meld-tb-form-label").html( jQuery(".tb-label").val() );

			jQuery(".tb-label").keyup(function() {
				var val = jQuery(this).val();
				var fval = val.replace(/[^A-Za-z]/g,"").toLowerCase();

				jQuery("#tb-name").val( fval );
				jQuery("#tb-name").trigger('change');
				
				jQuery("span",_currentFieldBtn).html( val );				
				jQuery("#meld-tb-form-label").html( val );
			});

			jQuery('.ui-button',$_field).each(function() {
				jQuery(this).click( function() {
					switch ( jQuery(this).attr('id') ) {
						case 'button-trash': {
							doDeleteField();
						}
						break;
					}
				});
			});
			
			jQuery("#ui-tabs").tabs();
			jQuery("#ui-tabs").tabs('select',0);

		}

		function doDeleteField() {
			var fieldData		= _formData.fields[_currentFieldID];
			var $fieldButton	= jQuery("#" + _currentFieldID);

			delete _formData.fields[_currentFieldID]; 			

			$fieldButton.remove();
			$_field.hide();
			$_dataset.hide();
			$_grid.hide();
			_formData.fieldorder = jQuery('#meld-tb-fields').sortable('toArray');
			if( fieldData.datasetid.length ) {
				delete _dataSets[fieldData.datasetid];
			}
		}

		function doDataset() {
			var fieldData	= _formData.fields[_currentFieldID];
			var datasetID	= fieldData.datasetid; 
			var dataset		= _dataSets[datasetID];
			_currentDataset = dataset;

			$_dataset.hide();
			$_grid.hide();

			if(_currentDataset.sourcetype == "") {
				doDatasetForm();
				return;
			}

			if (_currentDataset.sourcetype == 'entered') {
				if (_templates['dataset-grid'] == undefined) 
					goLoadTemplate('dataset-grid', doRenderDataset);
				else {
					doRenderDataset();
				}
			}
			else {
				if (_templates['dataset-sourced'] == undefined) 
					goLoadTemplate('dataset-sourced', doRenderSourced);
				else {
					doRenderSourced();
				}
			}
		}

		function doRenderSourced() {
			$_dataset.hide();
			$_grid.hide();
	
			jQuery('.ui-button',$_grid).unbind();
			$_grid.html(_templates['dataset-sourced']);

			jQuery('.ui-button',$_grid).click(function() {
				switch (jQuery(this).attr('id')) {
					case 'button-grid-edit':{
						doDatasetForm();
					}
					break;
				}
			});

			jQuery('#tb-source').val( _currentDataset.source );

			$_grid.show();
		}

		function doDatasetForm() {
			var fieldData	= _formData.fields[_currentFieldID];
			var datasetID	= fieldData.datasetid; 
			var dataset		= _dataSets[datasetID];
			_currentDataset = dataset;

			$_dataset.hide();
			$_grid.hide();

			if (_templates['dataset-form'] == undefined) { 
				goLoadTemplate('dataset-form',doRenderDatasetForm);
			}
			else {
				doShowDatasetForm();
			}
		}

		function doShowDatasetForm() {
			var fieldData	= _formData.fields[_currentFieldID];
			var datasetID	= fieldData.datasetid; 
			var dataset		= _dataSets[datasetID];
			_currentDataset = dataset;

			jQuery('.meld-tb-dsi').hide();
			switch( _currentDataset.sourcetype ) {
				case "entered": {
					jQuery('.meld-tb-grp-entered').show();						
				}
				break;
				case "dsp":
				case "object":
				case "remote": {
					jQuery('.meld-tb-grp-source').show();						
				}
				break;
				default: {
					jQuery('.meld-tb-grp-entered').show();						
				}
				break;
			}

			if(jQuery('#meld-tb-dataset-issorted').val() == 1) {
				jQuery('.meld-tb-grp-sorted').show();			
			}
			else {
				jQuery('.meld-tb-grp-sorted').hide();
			}

			jQuery('#meld-tb-dataset-sourcetype').val( _currentDataset.sourcetype );
			jQuery('#meld-tb-dataset-issorted').val( _currentDataset.issorted );
			jQuery('#meld-tb-dataset-sorttype').val( _currentDataset.sorttype );
			jQuery('#meld-tb-dataset-sortcolumn').val( _currentDataset.sortcolumn );
			jQuery('#meld-tb-dataset-sortdirection').val( _currentDataset.sortcolumn );
			jQuery('#meld-tb-dataset-source').val( _currentDataset.source );
			
			$_dataset.show();
		}
		
		function doRenderDatasetForm(){
			var fieldData	= _formData.fields[_currentFieldID];
			var datasetID	= fieldData.datasetid; 
			var dataset		= _dataSets[datasetID];
			_currentDataset = dataset;

			$_dataset.hide();
			$_dataset.html(_templates['dataset-form']);

			jQuery('#meld-tb-dataset-sourcetype').change( function() {
				jQuery('.meld-tb-dsi').hide();
				
				_currentDataset.sourcetype = jQuery(this).val();
				
				if( _currentDataset.sourcetype == "entered") {
					jQuery('.meld-tb-grp-entered').show();						

					if(jQuery('#meld-tb-dataset-issorted').val() == 1) {
						jQuery('.meld-tb-grp-sorted').show();			
					}
					else {
						jQuery('.meld-tb-grp-sorted').hide();
					}
				}
				else {
					jQuery('.meld-tb-grp-source').show();						
				}
			});

			jQuery('#meld-tb-dataset-issorted').change( function() {
				jQuery('.meld-tb-grp-sorted').hide();
				
				_currentDataset.issorted = jQuery(this).val();
				
				if(_currentDataset.issorted == 1) {
					jQuery('.meld-tb-grp-sorted').show();			
				}
				else {
					jQuery('.meld-tb-grp-sorted').hide();
				}
			});

			jQuery('#meld-tb-save-dataset').click( function() {
				
				_currentDataset.sourcetype = jQuery('#meld-tb-dataset-sourcetype').val();
				_currentDataset.issorted = jQuery('#meld-tb-dataset-issorted').val();
				_currentDataset.sorttype = jQuery('#meld-tb-dataset-sorttype').val();
				_currentDataset.sortcolumn = jQuery('#meld-tb-dataset-sortcolumn').val();
				_currentDataset.sortdirection = jQuery('#meld-tb-dataset-sortdirection').val();
				_currentDataset.source = jQuery('#meld-tb-dataset-source').val();
				
				if(_currentDataset.sourcetype != 'entered' && !_currentDataset.source.length ) {
					doDisplayDialog( 'message-dataset-sourcerequired' );
					return;
				}
				
				doDataset();
			});

			doShowDatasetForm();
		}
		
		function doRenderDataset() {

			var fieldData	= _formData.fields[_currentFieldID];
			var datasetID	= fieldData.datasetid; 
			var data		= _dataSets[datasetID];


			jQuery('.ui-button',$_grid).unbind();
			$_grid.html( _templates['dataset-grid'] );

			$_gridtable	= jQuery('#meld-tb-grid-table');
			$_gridhead	= jQuery('#meld-tb-grid-table-header');

			setDataMode('edit');

			jQuery('.ui-button',$_grid).click(function() {
				switch ( jQuery(this).attr('id') ) {
					case 'button-grid-dump': {
						alert( myDump( data ,"","  ",0,30) );
					}
					break;
					case 'button-grid-edit': {
						doDatasetForm();
					}
					break;
					case 'button-grid-add': {
						doRenderRow();
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
			
			if (data.issorted != 1) {
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
			$cell.addClass('meld-tb-cell-small');
			$row.append($cell);
			$cell = jQuery(cell);
			$cell.addClass('meld-tb-cell-input');
			$cell.html( jQuery('#element-labels #label',$rowHTML).html() );
			$row.append($cell);

			for( var i = 0;i < settings.dataColumns.length;i++) {
				colName		= settings.dataColumns[i];
				$cell = jQuery(cell);
				$cell.addClass('meld-tb-cell-input');
				$cell.html( jQuery('#element-labels #'+colName,$rowHTML).html() );
				$row.append($cell);
			}

			$_gridhead.append($row);

			jQuery(".meld-tb-cell-input",$row).each( function() {
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

			editMode = 1;

			$row = jQuery(row);
			$row.attr('id',record.datarecordid);

			{
				// isInSet
				$cell = jQuery(cell);
				$cell.addClass('meld-tb-cell-small');
				$checkbox = jQuery(checkbox);
				$checkbox.attr('data-id', record.datarecordid);
				$checkbox.attr('name', 'isinset');
				$checkbox.attr('checked', record.isinset == 1);
				$cell.append($checkbox);
				$row.append($cell);
			}
			
			// label
			$cell = jQuery(cell);
			$cell.addClass('meld-tb-cell-input');
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
			$cell.addClass('meld-tb-cell-input');
			$input = jQuery(input);
			$input.attr('data-id',record.datarecordid);
			$input.attr('name','rblabel');
			$input.val(record.rblabel);
			$cell.append($input);
			$row.append($cell);
*/
			
			for( var i = 0;i < settings.dataColumns.length;i++) {
				colName		= settings.dataColumns[i];
				$cell = jQuery(cell);

				$cell.addClass('meld-tb-cell-input');

				$input = jQuery(input);
				$input.attr('data-id', record.datarecordid);
				$input.attr('name', colName);
				$input.val(record[colName]);
				$cell.append($input);
				$row.append($cell);
			}
			
			if(data.issorted != 1) {
				$row.css('border-right','15px solid #435f8b');
			}

			if (editMode || record.config.isphantom == 1) {
				// delete
				$cell = jQuery(cell);
				$cell.addClass('meld-tb-cell-small button');
				$bt_delete = jQuery(bt_delete);
				$bt_delete.attr('data-id', record.datarecordid);
				$cell.append($bt_delete);
				$row.append($cell);
			}

			jQuery(".meld-tb-cell-input",$row).each( function() {
				jQuery(this).width( (550/(settings.dataColumns.length+2)) );
			});

			$_gridtable.append($row);

			if($_gridtable.children().length % 2)
				$row.addClass('alt');

			jQuery(".meld-tb-grid-input",$row).each( function() {
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
				doDisplayDialog( 'message-delete-row',false,doDeleteRow,{'id':id} );
			})

			jQuery(".meld-tb-grid-checkbox",$row).change( function() {
				var name = jQuery(this).attr('name');
				var id = jQuery(this).attr('data-id');
				data.datarecords[id][name] = jQuery(this).is(":checked") ? 1 : 0;
				data.datarecords[id].isdirty = 1;
				data.isdirty = 1;	
			} );

			return $row;
		}

		function doDisplayNewDatasetForm(sFieldID){
			if (_templates['dataset-create'] == undefined) 
				goLoadField(_currentFieldID,'dataset-create');
			else if( fieldData.fieldtype.isdata != 1) {
				doDisplayDialog( 'message-dataset-new' );
			}
			
		}

		function doDisplayDialog( template,isMsg,onYes,args,lblYes,lblNo ) {
			bt = {};

			if (isMsg == false) {
				bt[!lblYes ? settings.lbl['yes'] : lblYes] = function(){
					jQuery(this).dialog('close');
					if (onYes) 
						onYes(args);
				};
			}

			bt[ !lblNo ? settings.lbl['no'] : lblNo ] = function(){
				jQuery(this).dialog('close');
			};
						
			if (!_templates[template]) {
				goLoadDialog( template,isMsg,onYes,args,lblYes,lblNo );
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
			jQuery('#meld-tb-fields').children().remove();
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
				url: settings.url + "?fuseaction=cform.getfield&i=" + iefix,
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
				url: settings.url + "?fuseaction=cform.getfieldtemplate&i=" + iefix,
				type: 'POST',
				data: data,
				cache: false,
				success: function( response ) {
					_templates[template] = response;
					if(fn1)
						fn1(template);
					else
						doRenderField();
				},
				error: function(){
					alert('fail: load template');
				}
			});		
		}
							   
		function goLoadDialog( template,isMsg,onYes,args,lblYes,lblNo ) {
			var data = {};
			var iefix 		= Math.floor(Math.random()*9999999);

			data.dialog = template;

			jQuery.ajax({
				url: settings.url + "?fuseaction=cform.getdialog&i=" + iefix,
				type: 'POST',
				data: data,
				cache: false,
				success: function( response ) {
					_templates[template] = response;
					doDisplayDialog( template,isMsg,onYes,args,lblYes,lblNo );
				},
				error: function(){
					alert('fail: load dialog');
				}
			});		
		}

		function goLoadDataset( datasetID ) {
			var data = {};
			var fieldData	= _formData.fields[_currentFieldID];
			var iefix 		= Math.floor(Math.random()*9999999);

			data.datasetID = datasetID == undefined ? fieldData.datasetid : datasetID;
			data.fieldID = _currentFieldID;

			jQuery.ajax({
				url: settings.url + "?fuseaction=cform.getdataset&i=" + iefix,
				type: 'POST',
				data: data,
				cache: false,
				success: function( response ) {
					if ( data.datasetID.length == 0 ) {
						_dataSets[response.datasetid] = response;
						fieldData.datasetid = response.datasetid;
						doDatasetForm();
					}
				},
				error: function(){
					alert('fail: load dataset');
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
		dataColumns:	['value'],
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