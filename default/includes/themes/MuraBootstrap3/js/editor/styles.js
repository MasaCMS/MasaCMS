/*
Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license

	Documentation on Styles can be found at:
	http://docs.ckeditor.com/#!/guide/dev_styles

*/
if ( 'CKEDITOR' in window) {

	CKEDITOR.stylesSet.add( 'default',
	[
		/* Block Styles */

			{ name: 'Notice', element: 'p', attributes: { 'class': 'alert' } },
			{ name: 'Success', element: 'p', attributes: { 'class': 'alert alert-success' } },
			{ name: 'Error', element: 'p', attributes: { 'class': 'alert alert-danger' } },
			{ name: 'Info', element: 'p', attributes: { 'class': 'alert alert-info' } },
			{ name: 'Prettify', element: 'pre', attributes: { 'class': 'prettyprint linenums' } },


		/* Inline Styles */

			{ name: 'Marker: Yellow', element: 'span', styles: { 'background-color': 'Yellow' } },
			{ name: 'Marker: Green', element: 'span', styles: { 'background-color': 'Lime' } },
			{ name: 'Computer Code', element: 'code' },
			{ name: 'Deleted Text', element: 'del' },
			{ name: 'Inserted Text', element: 'ins' },
			{ name: 'Cited Work', element: 'cite' },
			{ name: 'Inline Quotation', element: 'q' },

			// These are core styles available as toolbar buttons. You may opt enabling
			// some of them in the Styles combo, removing them from the toolbar.
			// { name: 'Strong', element: 'strong', overrides: 'b' },
			// { name: 'Emphasis', element: 'em'	, overrides: 'i' },
			// { name: 'Underline', element: 'u' },
			// { name: 'Strikethrough', element: 'strike' },
			// { name: 'Subscript', element: 'sub' },
			// { name: 'Superscript', element: 'sup' },
			// { name: 'Big', element: 'big' },
			// { name: 'Small', element: 'small' },
			// { name: 'Typewriter, element: 'tt' },
			// { name: 'Keyboard Phrase', element: 'kbd' },
			// { name: 'Sample Text', element: 'samp' },
			// { name: 'Variable', element: 'var' },
			// { name: 'Language: RTL', element: 'span', attributes: { 'dir' : 'rtl' } },
			// { name: 'Language: LTR', element: 'span', attributes: { 'dir' : 'ltr' } },

		/* Object Styles */

			{ name: 'Borderless Table', element: 'table', styles: { 'border-style': 'hidden', 'background-color': '#E6E6FA' } },
			{ name: 'Square Bulleted List', element: 'ul', styles : { 'list-style-type': 'square' } },


		/* Widget Styles : http://ckeditor.com/tmp/4.4.0/widget-styles.html */

			{ name: 'Align Image Left', type: 'widget', widget: 'image', attributes: { 'class': 'image-left' } },
			{ name: 'Align Image Right', type: 'widget', widget: 'image', attributes: { 'class': 'image-right' } }

	]);

}