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
	/core/
	/Application.cfc
	/index.cfm

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
	under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
	requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
	modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
	version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS. */
(function( jQuery ){
	var _formData		= {ismuraorm:0};
	var _currentPage	= 0;
	var _buildList		= [];
	var _dataSets		= {};
	var _formStatus		= {};
	var _selected		= "";
	var _nameEnabled	= false;
	var _isMuraORM		= false;

	var _ckeditor		= "";

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

			if( action == 'iscomplete' && !isComplete() ) {
				return false;
			}

			jQuery('#mura-formdata').val(  JSON.stringify( _submitdata ) );

			return true;
		}

		var settings		= jQuery.extend({},jQuery.fn.templatebuilder.defaults,settings);
		var _formInitData = jQuery.parseJSON( jQuery("#mura-formdata").val() );
		var _templates	= {};

		var _currentFieldBtn= '';
		var _currentFieldLIBtn = '';
		var _currentFieldID	= '';
		var _currentDataset	= '';
		var $_field		= jQuery('#mura-tb-field');
		var $_dataset	= jQuery('#mura-tb-dataset-form');
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

			_currentPage = 0;

			jQuery('#mura-tb-fields').sortable({
				axis: 'y',
				opacity: 0.6,
				delay: 200,
				update: function(event, ui) {
					jQuery(this).children().each( function() {
					})
//FO				_formData.fieldorder = jQuery('#mura-tb-fields').sortable('toArray');
					setCurrentPageOrder( jQuery('#mura-tb-fields').sortable('toArray') );
					_formData.issortchanged = 1;
				}
			});

			doActivateMenu();

			doRenderForm( data );

			if ( _formData.formattributes && _formData.formattributes['name-unrestricted'] == 1) {
				_nameEnabled = true;
			}
			if ( _formData.formattributes && _formData.formattributes['muraormentities'] == 1) {
				_isMuraORM = true;
				jQuery("#button-nested").hide();
				jQuery("#button-file").hide();
			}
			else {
				_isMuraORM = false;
				jQuery("#button-file").show();
				jQuery("#button-nested").show();
			}

		}

		function doRenderForm( response ) {
			doClearForm();

			_formData = response.form;
			_currentPage = 0;

			if (!_formData.pages) {
				_formData.pages = [];
			}

			if(!_formData.pages.length)  {
				_formData.pages.push([]);
			}

			if(_formData.fieldorder.length > 0) {
				_formData.pages[0] = _formData.fieldorder;
				_formData.fieldorder = [];
			}

			console.log('form');
			console.log(_formData);

			_dataSets = response.datasets;
			_formStatus.fields			= {};
			buildPages( _currentPage );
			setActivePage( 1 );
		}

		function doUpdateForm( response ) {
		}

		function doAddFields() {


			console.log( _currentPage );

			jQuery('#mura-tb-fields').empty();
			_buildList = _formData.pages[ _currentPage ].slice(0);

			if (_buildList.length) {
				var fieldid = _buildList.shift();
				doAddField(_formData.fields[fieldid]);
			}
		}

		function getCurrentPage() {
			return _formData.pages[ _currentPage ];
		}

		function setCurrentPageOrder( val ) {

			console.log( "setCurrentPageOrder" );
			console.log( val );
			console.log(  _currentPage );

			_formData.pages[ _currentPage ] = val;

			console.log( _formData.pages[ _currentPage ] );

		}

		function doCreateField( obj ) {
//FO		_formData.fieldorder.push(obj.fieldid);
			getCurrentPage().push( obj.fieldid );

			_formData.fields[obj.fieldid] = obj;
			doAddField( obj );

		}

		function doAddField( obj ) {

			if (_templates['field-block'] == undefined)
				goLoadTemplate('field-block',doRenderFieldBlock,obj);
			else {
				doRenderFieldBlock('field-block',obj);
			}
		}

		function doRenderFieldBlock( template,obj ) {
			jQuery("#mura-tb-fields-empty").hide();

			var $fieldBlock = jQuery(_templates['field-block']);
			var mdata = {};
			mdata.fieldType = 'field-'+obj.fieldtype.fieldtype;
			mdata.fieldID = obj.fieldid;

			jQuery("ul",$fieldBlock).hide();

			$fieldBlock.attr('id',obj.fieldid);
			jQuery(".mura-tb-block",$fieldBlock).attr('data-field',JSON.stringify(mdata));
			jQuery(".mura-tb-block",$fieldBlock).addClass(obj.fieldtype.displaytype);
			$fieldBlock.addClass("field-" +obj.fieldtype.fieldtype);
			jQuery("span",$fieldBlock).html(obj.label);

			jQuery('#mura-tb-fields').append( $fieldBlock );

			if (_buildList.length) {
				var fieldid = _buildList.shift();
				doAddField(_formData.fields[fieldid]);
			}
		}

		function doActivateMenu() {
			jQuery("#mura-templatebuilder .mura-tb-form-menu div").click( function() {
				doForm();
			});

			jQuery("#mura-templatebuilder .mura-tb-field-menu div").each( function(){
				var $btn = jQuery(this);
				$btn.click( function() {
					goLoadField( jQuery(this).attr('data-object'),_formData.formid );
				});
			});
			jQuery(document).on( 'click',"#mura-tb-fields li div", function() {
				doField( this );
			});

			jQuery("#mura-form-addpage").click( function() {
				_formData.pages.push([]);
				addPage(_formData.pages.length,true);
			});
		}

		function addPage( pageNum,isNew ) {
			$("#mura-form-pages li").removeClass('current');

			console.log('add');

			var pageblock = '<li id="page-~page~" data-page="~page~"></li>';
			var pageblock = $(pageblock.replace(/\~page\~/g,pageNum));

			if(pageNum == _currentPage )
				pageblock.addClass('current');

			pageblock.html( pageNum );

			jQuery("#mura-form-pages").append( pageblock );

			pageblock.click( function() {
				setActivePage( $(this).attr('data-page') );
			});

			if( isNew )
				setActivePage( pageNum );

		}

		function buildPages( currentPage ) {
			_currentPage = currentPage;

			console.log( "buildPages" );
			console.log( _formData );

			jQuery("#mura-form-pages").empty();

			for(var i = 0; i < _formData.pages.length;i++) {
				addPage( i+1 );
			}
		}

		function setActivePage( activePage ) {
			$("#mura-form-pages li").removeClass('current');
			$("#mura-form-pages .button-trash").remove();
			doClearForm();

			_currentPage = activePage - 1;

			var pageBlock = jQuery("#page-" + activePage);
			var delblock = jQuery('<div class="button-trash" title="Delete"></div>');

			pageBlock.addClass('current');

			if( activePage > 1 ) {
				pageBlock.append( delblock );

				$( ".button-trash",pageBlock ).click( function() {
					var pageblock = $(this).parent();
					var pageblockid = pageblock.attr("data-page");
					pageblock.remove();

					var pagefields = _formData.pages.splice( pageblockid-1,1 );

					if (pagefields && pagefields[0].length) {
						for(var f=0;f < pagefields[0].length;f++){
							_formData.pages[pageblockid - 2].push(pagefields[0][f]);
						}
					}

					setActivePage( pageblockid-1 );
					console.log(_formData);
				} );
			}
			doAddFields();
		}

		function doPreBlockActions() {

			if(_ckeditor == true ) {
				var instance = CKEDITOR.instances['field_textblock'];
				instance.destroy();
				_ckeditor = false;
			}

			jQuery("#mura-tb-field-empty").hide();
			$_field.hide();
			$_dataset.hide();
			$_grid.hide();

			if (_currentFieldLIBtn != '') {
				jQuery('.ui-button',_currentFieldLIBtn).each(function() {
					jQuery(this).unbind();
				});
				jQuery('ul',_currentFieldLIBtn).hide();

				_currentFieldLIBtn.removeClass('selected');
				jQuery('.pointer').remove();
			}

		}

		function doForm(){
			doPreBlockActions();

			if (_templates['form-form'] == undefined)
				goLoadTemplate('form-form');
			else {
				doRenderFormBlock();
			}
		}

		function doRenderFormBlock() {
			var templateName	= "form-form";

			if(!_formData.formattributes){
				_formData.formattributes={};
			}

			var fieldData		= _formData.formattributes;

			$_field.html(_templates[templateName]);
			$_field.show();

			jQuery('#mura-tb-form').jsonForm({source: fieldData,createOnNull: false,createOnDataNull: false,bindBy: 'name',baseObject: 'field'});

			jQuery('#mura-tb-form').bind('jsonformField', function( event,values ) {
				if (values.kind == 'selected') {
					if(_selected != undefined)
						jQuery(_selected).removeClass('selected');

					_selected = values.object;
					jQuery(_selected).addClass('selected');
				}
				else if (values.kind == 'update') {
					fieldData.isdirty = 1;
					_formData.isdirty = 1;

				}

				if(typeof values.item != 'undefined'){
					if(typeof values.value != 'undefined'){
						fieldData[values.item]=values.value;
					} else {
						delete fieldData[values.item];
					}
				}
			});

			jQuery("#tb-name-restricted").change(function() {
				if( jQuery("#tb-name-restricted").is(":checked") ) {
					_nameEnabled = true;
				}
				else {
					_nameEnabled = false;
				}
			});

			jQuery("#tb-muraormentities").change(function() {
				if( jQuery("#tb-muraormentities").is(":checked") ) {
					_isMuraORM = true;
					jQuery("#button-file").hide();
					jQuery("#button-nested").hide();
				}
				else {
					_isMuraORM = false;
					jQuery("#button-file").show();
					jQuery("#button-nested").show();
				}
			});
		}

		function doField( fieldBtn ) {
			var $btn		= jQuery( fieldBtn );
			var $libtn		= $btn.parent();

			var jsonData		= $btn.attr('data-field');
			var data			= jQuery.parseJSON( jsonData );
			var fieldData		= _formData.fields[data.fieldID];
			var templateName	= "field-" + fieldData.fieldtype.fieldtype;
			var $pointer		= jQuery('<div class="pointer"></div>');

			doPreBlockActions();

			_currentFieldBtn = $btn;
			_currentFieldLIBtn = $libtn;
			_currentFieldID = data.fieldID;

			jQuery('ul',_currentFieldLIBtn).show();
			_currentFieldLIBtn.addClass('selected');
			_currentFieldLIBtn.append($pointer);

			jQuery('.mura-tb-nav-utility div',_currentFieldLIBtn).each(function() {
				jQuery(this).click( function() {
					switch ( jQuery(this).attr('id') ) {
						case 'button-trash': {
							doDeleteField();
						}
						break;
					}
				});
			});

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
			jQuery(".tb-name").unbind();

			jQuery('#mura-tb-field-form').unbind();
			$_field.html(_templates[templateName]);
			$_field.show();

			if( _nameEnabled ) {
				jQuery("#tb-name").removeClass("disabled");
				jQuery("#tb-name").removeAttr("disabled");
			}
			else {
				jQuery("#tb-name").addClass("disabled");
				jQuery("#tb-name").attr("disabled","true");
			}

			jQuery('#mura-tb-form').jsonForm({source: fieldData,createOnNull: true,createOnDataNull: false,bindBy: 'name',baseObject: 'field'});

			jQuery('#mura-tb-form').bind('jsonformField', function( event,values ) {
				if (values.kind == 'selected') {
					if(_selected != undefined)
						jQuery(_selected).removeClass('selected');

					_selected = values.object;
					jQuery(_selected).addClass('selected');
				}
				else if (values.kind == 'update') {
					fieldData.isdirty = 1;
					_formData.isdirty = 1;

				}
			});

			jQuery("#mura-tb-form #mura-tb-form-label").html( jQuery(".tb-label").val() );

			jQuery(".tb-label").keyup(function() {
				var val = jQuery(this).val();
				var fval = val.replace(/[^a-zA-Z0-9_]/gi,'').toLowerCase();

				if(!_nameEnabled) {
					fval = fval.replace(/^[^a-zA-Z]*/,'');

					jQuery("#" + _currentFieldID).removeClass('tb-fieldIsEmpty');

					jQuery("#tb-name").val( fval );
					jQuery("#tb-name").trigger('change');
				}

				jQuery("span",_currentFieldBtn).html( val );
				jQuery("#mura-tb-form-label").html( val );
			});

			jQuery("#tb-name").keyup(function() {
				var val = jQuery(this).val();
				var fval = val.replace(/[^a-zA-Z0-9_]/gi,'').toLowerCase();
				fval = fval.replace(/^[^a-zA-Z]*/,'');

				jQuery("#" + _currentFieldID).removeClass('tb-fieldIsEmpty');
				jQuery("#tb-name").val( fval );
				jQuery("#tb-name").trigger('change');
			});

			jQuery("#ui-tabs").tabs();
//		jQuery("#ui-tabs").tabs('select',0);

			if(fieldData.fieldtype.fieldtype == "textblock") {
				jQuery('#field_textblock').ckeditor( {toolbar: 'FormBuilder', customConfig: 'config.js.cfm'},onCKEditorChange );
				_ckeditor = true;
			}
		}

		function onCKEditorChange() {
			var instance = CKEDITOR.instances['field_textblock'];
			var fieldData = _formData.fields[_currentFieldID];

			instance.on("change",
				function(e) {
					fieldData.value = jQuery('#field_textblock').val();
				});
		}

		function doDeleteField() {
			var fieldData		= _formData.fields[_currentFieldID];
			var $fieldButton	= jQuery("#" + _currentFieldID);

			delete _formData.fields[_currentFieldID];
			jQuery("#mura-tb-field-empty").show();

			$fieldButton.remove();
			$_field.hide();
			$_dataset.hide();
			$_grid.hide();
//FO		_formData.fieldorder = jQuery('#mura-tb-fields').sortable('toArray');
			setCurrentPageOrder( jQuery('#mura-tb-fields').sortable('toArray') );
			if( fieldData.datasetid && fieldData.datasetid.length ) {
				delete _dataSets[fieldData.datasetid];
			}

			if(!getCurrentPage().length) {
				jQuery("#mura-tb-fields-empty").show();
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

			if (_currentDataset.sourcetype == 'entered' ) {
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

			jQuery('#tb-source').val(_currentDataset.source);

			$_grid.show();
		}

		function doRenderDataset() {

			var fieldData	= _formData.fields[_currentFieldID];
			var datasetID	= fieldData.datasetid;
			var data		= _dataSets[datasetID];
			jQuery('.ui-tabs-nav li',$_grid).unbind();

			$_grid.html( _templates['dataset-grid'] );

			$_gridtable	= jQuery('#mura-tb-grid-table');
			$_gridhead	= jQuery('#mura-tb-grid-table-header');

			setDataMode('edit');

			jQuery('.ui-tabs-nav li',$_grid).click(function() {
				switch (jQuery(this).attr('id')) {
					case 'button-grid-edit':{
						doDatasetForm();
					}
					break;
				}
			});

			jQuery('.ui-button',$_grid).click(function() {
				switch ( jQuery(this).attr('id') ) {
					case 'button-grid-add': {
						doRenderRow();
					}
					break;
				}
			});

			jQuery(document).on('click',".mura-tb-grid-radio",function() {
				id = jQuery(this).attr('data-id');
				if(id){
					_currentDataset.defaultid = id;
				}
			});

			jQuery(document).on('click',$_grid,function() {
				id = jQuery(this).attr('data-id');
				if(id){
					_currentDataset.defaultid = id;
				}
			});

			$_grid.show();
			doRenderData();
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

			jQuery('.mura-tb-dsi').hide();

			if (!_isMuraORM) {
				jQuery("#dataset-source-muraorm").hide();
			}
			else {

				jQuery("#dataset-source-muraorm").show();
			}

			if(fieldData.fieldtype.fieldtype != 'multientity') {
				jQuery('#mura-tb-grp-sourcetype').hide();
//				_currentDataset.sourcetype = 'muraorm';
			}

			console.log(_currentDataset.sourcetype);

			switch( _currentDataset.sourcetype ) {
				case "multientity": {
					jQuery('.mura-tb-grp-entered').hide();
				}
				case "entered": {
					jQuery('.mura-tb-grp-entered').show();
				}
				break;
				case "multientity": {
					jQuery('.mura-tb-grp-source').show();
					jQuery('.mura-tb-grp-sourcetype').hide();
					jQuery('#button-grid-grid').hide();

				}
				break;
				case "dsp":
				case "object":
				case "muraorm":{
					jQuery('.mura-tb-grp-source').show();
					break;
				}
				case "remote": {
					jQuery('.mura-tb-grp-source').show();
					break;
				}
				break;
				default: {
					jQuery('.mura-tb-grp-entered').show();
					if(_currentDataset.sourcetype.length == 0) {
						jQuery('#button-grid-grid',$_dataset).unbind();
						jQuery('#button-grid-grid',$_dataset).hide();
					}
					else {
						jQuery('#button-grid-grid',$_dataset).show();
						jQuery('#button-grid-grid',$_dataset).click(function() {
							doDataset();
						});
					}
				}
				break;
			}

			if(jQuery('#mura-tb-dataset-issorted').val() == 1) {
				jQuery('.mura-tb-grp-sorted').show();
			}
			else {
				jQuery('.mura-tb-grp-sorted').hide();
			}


			jQuery('#mura-tb-dataset-sourcetype').val( _currentDataset.sourcetype );
			jQuery('#mura-tb-dataset-issorted').val( _currentDataset.issorted );
			jQuery('#mura-tb-dataset-sorttype').val( _currentDataset.sorttype );
			jQuery('#mura-tb-dataset-sortcolumn').val( _currentDataset.sortcolumn );
			jQuery('#mura-tb-dataset-sortdirection').val( _currentDataset.sortcolumn );
			jQuery('#mura-tb-dataset-source').val( _currentDataset.source );

			$_dataset.show();
		}

		function doRenderDatasetForm(){
			var fieldData	= _formData.fields[_currentFieldID];
			var datasetID	= fieldData.datasetid;
			var dataset		= _dataSets[datasetID];
			_currentDataset = dataset;

			$_dataset.hide();
			$_dataset.html(_templates['dataset-form']);



			jQuery('#mura-tb-dataset-sourcetype').change( function() {
				jQuery('.mura-tb-dsi').hide();

				_currentDataset.sourcetype = jQuery(this).val();
				jQuery('#button-grid-grid',$_dataset).unbind();
				jQuery('#button-grid-grid',$_dataset).hide();

				if( _currentDataset.sourcetype == "entered") {
					jQuery('.mura-tb-grp-entered').show();

					if(jQuery('#mura-tb-dataset-issorted').val() == 1) {
						jQuery('.mura-tb-grp-sorted').show();
					}
					else {
						jQuery('.mura-tb-grp-sorted').hide();
					}
				}
				else if( _currentDataset.sourcetype == "muraorm") {
					jQuery('.mura-tb-grp-entered').hide();
					jQuery('.mura-tb-grp-source').show();
					jQuery('#button-grid-grid',$_dataset).hide();
				}
				else {
					jQuery('.mura-tb-grp-source').show();
				}
			});

			jQuery('#mura-tb-dataset-issorted').change( function() {
				jQuery('.mura-tb-grp-sorted').hide();

				_currentDataset.issorted = jQuery(this).val();

				if(_currentDataset.issorted == 1) {
					jQuery('.mura-tb-grp-sorted').show();
				}
				else {
					jQuery('.mura-tb-grp-sorted').hide();
				}
			});
			if(fieldData.fieldtype.fieldtype == 'multientity') {
				jQuery('#mura-tb-grp-sourcetype').hide();
				jQuery('.mura-tb-grp-entered').hide();
				jQuery('.mura-tb-grp-source').hide();
console.log("asdfw");
				_currentDataset.sourcetype = 'muraorm';

			}

			jQuery('#mura-tb-save-dataset').click( function() {

				_currentDataset.sourcetype = jQuery('#mura-tb-dataset-sourcetype').val();
				_currentDataset.issorted = jQuery('#mura-tb-dataset-issorted').val();
				_currentDataset.sorttype = jQuery('#mura-tb-dataset-sorttype').val();
				_currentDataset.sortcolumn = jQuery('#mura-tb-dataset-sortcolumn').val();
				_currentDataset.sortdirection = jQuery('#mura-tb-dataset-sortdirection').val();
				_currentDataset.source = jQuery('#mura-tb-dataset-source').val();

				if(_currentDataset.sourcetype != 'entered'
						&& _currentDataset.sourcetype != 'muraorm'
						&& _currentDataset.sourcetype != 'multientity'
						&& !_currentDataset.source.length ) {
					doDisplayDialog( 'message-dataset-sourcerequired' );
					return;
				}

				doDataset();
			});

			doShowDatasetForm();
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


			$cell = jQuery(cell);
			$cell.addClass('mura-tb-cell-input');
			$cell.addClass('mura-tb-cell-label');
			$cell.html( jQuery('#element-labels #label',$rowHTML).html() );
			$row.append($cell);

			for( var i = 0;i < settings.dataColumns.length;i++) {
				colName		= settings.dataColumns[i];
				$cell = jQuery(cell);
				$cell.addClass('mura-tb-cell-input');
				$cell.html( jQuery('#element-labels #'+colName,$rowHTML).html() );
				$row.append($cell);
			}

			$_gridhead.append($row);

			//jQuery(".mura-tb-cell-input",$row).each( function() {
			//	jQuery(this).width( (480/(settings.dataColumns.length+2)) );
			//});
		}

		function doAddRecord() {
			var fieldData	= _formData.fields[_currentFieldID];
			var datasetID	= fieldData.datasetid;
			var data		= _dataSets[datasetID];

			var newID 			= uuid();
			var newDataRecord	= jQuery.extend({},data.model);

			data.iscomplete = 0;
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
			var radio		= jQuery('#element-radio',$rowHTML).html();
			var checkbox	= jQuery('#element-checkbox',$rowHTML).html();
			var row			= jQuery('#element-row',$rowHTML).html();
			var handle		= jQuery('#element-handle',$rowHTML).html();
			var bt_delete	= jQuery('#element-button-delete',$rowHTML).html();

			var $cell		= "";
			var $display	= "";
			var $input		= "";
			var $row		= "";
			var $radio		= "";
			var $checkbox	= "";
			var $row		= "";
			var $handle		= "";
			var $bt_delete	= "";

			editMode = 1;

			$row = jQuery(row);
			$row.attr('id',record.datarecordid);

			if(data.issorted != 1) {
				jQuery("#mura-tb-grid-table-header li").removeClass('nohandle');
				$row.append(handle);
			}
			else {
				jQuery("#mura-tb-grid-table-header li").addClass('nohandle');
			}

			if(fieldData.fieldtype.fieldtype != 'checkbox')
			{
				$cell = jQuery(cell);
				$cell.addClass('mura-tb-cell-small');
				$radio = jQuery(radio);
				$radio.attr('data-id', record.datarecordid);
				$radio.attr('name', 'isdefault');
				if( data.defaultid == record.datarecordid )
					$radio.attr('CHECKED','CHECKED');
				$cell.append($radio);
				$row.append($cell);
			}
			else {
				$cell = jQuery(cell);
				$cell.addClass('mura-tb-cell-small');
				$checkbox = jQuery(checkbox);
				$checkbox.attr('data-id', record.datarecordid);
				$checkbox.attr('name', 'isselected');
				if( record.isselected == 1 )
					$checkbox.attr('CHECKED','CHECKED');
				$cell.append($checkbox);
				$row.append($cell);
			}

			// label
			$cell = jQuery(cell);

			$cell.addClass('mura-tb-cell-input');
			$input = jQuery(input);
			$input.attr('data-id', record.datarecordid);
			$input.attr('name', 'label');
			$input.val(record.label);


			$cell.append($input);
			$row.append($cell);

			for( var i = 0;i < settings.dataColumns.length;i++) {
				colName		= settings.dataColumns[i];
				$cell = jQuery(cell);

				$cell.addClass('mura-tb-cell-input');

				$input = jQuery(input);
				$input.attr('data-id', record.datarecordid);
				$input.attr('name', colName);
				$input.val(record[colName]);
				$cell.append($input);
				$row.append($cell);
			}

			/*jQuery(".mura-tb-cell-input",$row).each( function() {
				jQuery(this).width( (480/(settings.dataColumns.length+2)) );
			});*/

			// delete
			$cell = jQuery(cell);
			$cell.addClass('mura-tb-cell-delete');
			$bt_delete = jQuery(bt_delete);
			$bt_delete.attr('data-id', record.datarecordid);
			$cell.append($bt_delete);
			$row.append($cell);

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
				doDisplayDialog( 'message-delete-row',false,doDeleteRow,{'id':id} );
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
			jQuery('#mura-tb-fields').children().remove();
			$_field.html('');
		}

		function goLoadField( type ) {
			var self = this;
			var data = {};
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

		function goLoadTemplate( template,fn1,args ) {
			var data = {};
			var iefix 		= Math.floor(Math.random()*9999999);

			data.fieldType = template;
			data.formid = _formData.formid;

			jQuery.ajax({
				url: settings.url + "?muraAction=cform.getfieldtemplate&i=" + iefix,
				type: 'POST',
				data: data,
				cache: false,
				success: function( response ) {
					_templates[template] = response;
					if (fn1)
						fn1(template, args);
					else {
						if(template == "form-form")
							doRenderFormBlock();
						else
							doRenderField();

					}
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
				url: settings.url + "?muraAction=cform.getdialog&i=" + iefix,
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
				url: settings.url + "?muraAction=cform.getdataset&i=" + iefix,
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

		function isComplete() {
			var formFields = _formData.fields;
			var pass = true;

			for(var i in formFields) {
				if(formFields[i].name.length < 1 && formFields[i].fieldtype.fieldtype != 'textblock' && formFields[i].fieldtype.fieldtype != 'section') {
					jQuery("#" + i).addClass("tb-fieldIsEmpty");
					pass = false;
				}
				else {
					jQuery("#" + i).removeClass("tb-fieldIsEmpty");
				}
			}

			return pass;
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

	uuid = function(){
		return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    		var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
	    	return v.toString(16);
		});
	}
})(jQuery);
