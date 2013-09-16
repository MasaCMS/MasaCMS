/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

if ( 'CKEDITOR' in window) {

	CKEDITOR.stylesSet.add( 'default',
	[
		/* Block Styles */

		{ name: 'Code', element: 'pre', attributes: { 'class': 'prettyprint linenums' } },

		{ name : 'Notice'	, element : 'p', attributes : { 'class' : 'alert' } },
		{ name : 'Success'	, element : 'p', attributes : { 'class' : 'alert alert-success' } },
		{ name : 'Error'	, element : 'p', attributes : { 'class' : 'alert alert-error' } },
		{ name : 'Info'		, element : 'p', attributes : { 'class' : 'alert alert-info' } },
		
		{ name : 'Well'	, element : 'p', attributes : { 'class' : 'well' } },
		
		{ name : 'Default Bootstrap Table'	, element : 'table', attributes : { 'class' : 'table' } },
		{ name : 'Table Striped'	, element : 'table', attributes : { 'class' : 'table table-striped' } },
		{ name : 'Table Bordered'	, element : 'table', attributes : { 'class' : 'table table-bordered' } },
		{ name : 'Table Hover'	, element : 'table', attributes : { 'class' : 'table table-hover' } },
		{ name : 'Table Condensed'	, element : 'table', attributes : { 'class' : 'table table-condensed' } },

		{ name : 'Marker: Yellow'	, element : 'span', styles : { 'background-color' : 'Yellow' } },
		{ name : 'Marker: Green'	, element : 'span', styles : { 'background-color' : 'Lime' } },

		{ name : 'Computer Code'	, element : 'code' },
		{ name : 'Deleted Text'		, element : 'del' },
		{ name : 'Inserted Text'	, element : 'ins' },

		{ name : 'Cited Work'		, element : 'cite' },
		{ name : 'Inline Quotation'	, element : 'q' },

		/* Object Styles */

		{ name : 'Align Image Left', element : 'img', attributes : { 'class' : 'pull-left' } },
		{ name : 'Align Image Right', element : 'img', attributes : { 'class' : 'pull-right' } },
		{ name : 'Rounded Corners', element : 'img', attributes : { 'class' : 'img-rounded' } },
		{ name : 'In a Circle', element : 'img', attributes : { 'class' : 'img-circle' } },
		{ name : 'Polaroid', element : 'img', attributes : { 'class' : 'img-polaroid' } },
		
		{ name : 'Table Row - Success', element : 'tr', attributes : { 'class' : 'success' } },
		{ name : 'Table Row - Error', element : 'tr', attributes : { 'class' : 'error' } },
		{ name : 'Table Row - Warning', element : 'tr', attributes : { 'class' : 'warning' } },
		{ name : 'Table Row - Info', element : 'tr', attributes : { 'class' : 'info' } },
		
		{ name : 'Link as Button', element : 'a', attributes : { 'class' : 'btn' } },
		{ name : 'Link as Primary Button', element : 'a', attributes : { 'class' : 'btn btn-primary' } },
		{ name : 'Link as Button-Large', element : 'a', attributes : { 'class' : 'btn btn-large' } },
		{ name : 'Link as Primary Button-Large', element : 'a', attributes : { 'class' : 'btn btn-primary btn-large' } },
		{ name : 'Link as Button-Small', element : 'a', attributes : { 'class' : 'btn btn-small' } },
		{ name : 'Link as Primary Button-Small', element : 'a', attributes : { 'class' : 'btn btn-primary btn-small' } },
		{ name : 'Link as Button-Mini', element : 'a', attributes : { 'class' : 'btn btn-mini' } },
		{ name : 'Link as Primary Button-Mini', element : 'a', attributes : { 'class' : 'btn btn-primary btn-mini' } },
		{ name : 'Link as Button-Block', element : 'a', attributes : { 'class' : 'btn btn-block' } },
		{ name : 'Link as Primary Button-Block', element : 'a', attributes : { 'class' : 'btn btn-primary btn-block' } },
		{ name : 'Link as Button-Large Block', element : 'a', attributes : { 'class' : 'btn btn-large btn-block' } },
		{ name : 'Link as Primary Button-Large Block', element : 'a', attributes : { 'class' : 'btn btn-primary btn-large btn-block' } },
		{ name : 'Link as Button-Small Block', element : 'a', attributes : { 'class' : 'btn btn-small btn-block' } },
		{ name : 'Link as Primary Button-Small Block', element : 'a', attributes : { 'class' : 'btn btn-primary btn-small btn-block' } },
		{ name : 'Link as Button-Mini Block', element : 'a', attributes : { 'class' : 'btn btn-mini btn-block' } },
		{ name : 'Link as Primary Button-Mini Block', element : 'a', attributes : { 'class' : 'btn btn-primary btn-mini btn-block' } },

		{ name : 'Square Bulleted List', element : 'ul', styles : { 'list-style-type' : 'square' } }
	]);

}