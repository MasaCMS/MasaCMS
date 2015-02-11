/*
Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license

	Documentation on Styles can be found at:
	http://docs.ckeditor.com/#!/guide/dev_styles

*/
if ( 'CKEDITOR' in window) {

	CKEDITOR.stylesSet.add( 'default',
	[

		/* Inline Styles */

		{ name: 'Notice', element: 'p', attributes: { 'class': 'alert' } },
		{ name: 'Success', element: 'p', attributes: { 'class': 'alert alert-success' } },
		{ name: 'Error', element: 'p', attributes: { 'class': 'alert alert-danger' } },
		{ name: 'Info', element: 'p', attributes: { 'class': 'alert alert-info' } },
		{ name: 'Prettify', element: 'pre', attributes: { 'class': 'prettyprint linenums' } },
		{ name: 'Marker: Yellow', element: 'span', styles: { 'background-color': 'Yellow' } },
		{ name: 'Marker: Green', element: 'span', styles: { 'background-color': 'Lime' } },
		{ name: 'Computer Code', element: 'code' },
		{ name: 'Deleted Text', element: 'del' },
		{ name: 'Inserted Text', element: 'ins' },
		{ name: 'Cited Work', element: 'cite' },
		{ name: 'Inline Quotation', element: 'q' },

		// These are core styles available as toolbar buttons. You may opt enabling
		// some of them in the Styles combo, removing them from the toolbar.
		/*
			{ name: 'Strong', element: 'strong', overrides: 'b' },
			{ name: 'Emphasis', element: 'em'	, overrides: 'i' },
			{ name: 'Underline', element: 'u' },
			{ name: 'Strikethrough', element: 'strike' },
			{ name: 'Subscript', element: 'sub' },
			{ name: 'Superscript', element: 'sup' },
			{ name: 'Big', element: 'big' },
			{ name: 'Small', element: 'small' },
			{ name: 'Typewriter, element: 'tt' },
			{ name: 'Keyboard Phrase', element: 'kbd' },
			{ name: 'Sample Text', element: 'samp' },
			{ name: 'Variable', element: 'var' },
			{ name: 'Language: RTL', element: 'span', attributes: { 'dir' : 'rtl' } },
			{ name: 'Language: LTR', element: 'span', attributes: { 'dir' : 'ltr' } },
		*/

		/* Object Styles */

		{ name: 'Borderless Table', element: 'table', styles: { 'border-style': 'hidden', 'background-color': '#E6E6FA' } },
		{ name: 'Square Bulleted List', element: 'ul', styles : { 'list-style-type': 'square' } },


		/* Widget Styles : http://ckeditor.com/tmp/4.4.0/widget-styles.html */
		{ name: 'Align Image Left', type: 'widget', widget: 'image', attributes: { 'class': 'image-left' } },
		{ name: 'Align Image Right', type: 'widget', widget: 'image', attributes: { 'class': 'image-right' } }


		/* Block Styles */

		// These styles are already available in the "Format" combo, so they are
		// not needed here by default. You may enable them to avoid placing the
		// "Format" combo in the toolbar, maintaining the same features.
		/*
			{ name: 'Paragraph', element: 'p' },
			{ name: 'Heading 1', element: 'h1' },
			{ name: 'Heading 2', element: 'h2' },
			{ name: 'Heading 3', element: 'h3' },
			{ name: 'Heading 4', element: 'h4' },
			{ name: 'Heading 5', element: 'h5' },
			{ name: 'Heading 6', element: 'h6' },
			{ name: 'Preformatted Text', element: 'pre' },
			{ name: 'Address', element: 'address' },
			{ name: 'Intro Paragraph', element: 'p', attributes: { 'class': 'intro' } },
			{ name: 'Center Text', element: 'p', attributes: { 'class': 'center' } },
			{ name: 'Call to Action', element: 'a', attributes: { 'class': 'callToAction' } }
		*/

	]);

}