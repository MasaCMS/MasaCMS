/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

if ( 'CKEDITOR' in window) {

	// Register a templates definition set named "default".
	CKEDITOR.addTemplates( 'default',
	{
		// The name of sub folder which hold the shortcut preview images of the templates.
		//imagesPath : CKEDITOR.getUrl( themepath + '/js/editor/templates/images/' ),
		imagesPath : themepath + '/js/editor/templates/images/',
		// The templates definitions.
		templates :
			[
				{
					title: '2 Columns',
					image: 'template-cols2.gif',
					description: 'An area with 2 equally wide columns',
					html:
									'<div class="row">' +
										'<div class="span6 col-md-6">' +
											'<h2>Header 1</h2>'+
											'<p>Content for column 1 goes here. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi venenatis lacinia sem, et imperdiet nisl rhoncus nec. Nulla erat neque, mattis et diam quis, posuere malesuada neque. Praesent dictum magna et mauris congue, at molestie ante imperdiet. Pellentesque neque justo, egestas ac augue vitae, fringilla malesuada orci. Sed tincidunt eleifend diam, nec imperdiet libero gravida quis. Fusce accumsan ultrices mauris et aliquam. Duis rutrum facilisis ultrices.</p>' +
										'</div>' +

										'<div class="span6 col-md-6">' +
											'<h2>Header 2</h2>'+
											'<p>Content for column 2 goes here. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi venenatis lacinia sem, et imperdiet nisl rhoncus nec. Nulla erat neque, mattis et diam quis, posuere malesuada neque. Praesent dictum magna et mauris congue, at molestie ante imperdiet. Pellentesque neque justo, egestas ac augue vitae, fringilla malesuada orci. Sed tincidunt eleifend diam, nec imperdiet libero gravida quis. Fusce accumsan ultrices mauris et aliquam. Duis rutrum facilisis ultrices.</p>' +
										'</div>' +
									'</div>'
				},
				{
					title: '3 Columns',
					image: 'template-cols3.gif',
					description: 'An area with 3 equally wide columns',
					html:
									'<div class="row">' +
										'<div class="span4 col-md-4">' +
											'<h2>Header 1</h2>'+
											'<p>Content for column 1 goes here. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi venenatis lacinia sem, et imperdiet nisl rhoncus nec. Nulla erat neque, mattis et diam quis, posuere malesuada neque. Praesent dictum magna et mauris congue, at molestie ante imperdiet. Pellentesque neque justo, egestas ac augue vitae, fringilla malesuada orci. Sed tincidunt eleifend diam, nec imperdiet libero gravida quis. Fusce accumsan ultrices mauris et aliquam. Duis rutrum facilisis ultrices.</p>' +
										'</div>' +

										'<div class="span4 col-md-4">' +
											'<h2>Header 2</h2>'+
											'<p>Content for column 2 goes here. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi venenatis lacinia sem, et imperdiet nisl rhoncus nec. Nulla erat neque, mattis et diam quis, posuere malesuada neque. Praesent dictum magna et mauris congue, at molestie ante imperdiet. Pellentesque neque justo, egestas ac augue vitae, fringilla malesuada orci. Sed tincidunt eleifend diam, nec imperdiet libero gravida quis. Fusce accumsan ultrices mauris et aliquam. Duis rutrum facilisis ultrices.</p>' +
										'</div>' +

										'<div class="span4 col-md-4">' +
											'<h2>Header 3</h2>'+
											'<p>Content for column 3 goes here. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi venenatis lacinia sem, et imperdiet nisl rhoncus nec. Nulla erat neque, mattis et diam quis, posuere malesuada neque. Praesent dictum magna et mauris congue, at molestie ante imperdiet. Pellentesque neque justo, egestas ac augue vitae, fringilla malesuada orci. Sed tincidunt eleifend diam, nec imperdiet libero gravida quis. Fusce accumsan ultrices mauris et aliquam. Duis rutrum facilisis ultrices.</p>' +
										'</div>' +
									'</div>'
				},
				{
					title: '4 Columns',
					image: 'template-cols4.gif',
					description: 'An area with 4 equally wide columns',
					html:
									'<div class="row">' +
										'<div class="span3 col-md-3">' +
											'<h2>Header 1</h2>'+
											'<p>Content for column 1 goes here. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi venenatis lacinia sem, et imperdiet nisl rhoncus nec. Nulla erat neque, mattis et diam quis, posuere malesuada neque. Praesent dictum magna et mauris congue, at molestie ante imperdiet. Pellentesque neque justo, egestas ac augue vitae, fringilla malesuada orci. Sed tincidunt eleifend diam, nec imperdiet libero gravida quis. Fusce accumsan ultrices mauris et aliquam. Duis rutrum facilisis ultrices.</p>' +
										'</div>' +

										'<div class="span3 col-md-3">' +
											'<h2>Header 2</h2>'+
											'<p>Content for column 2 goes here. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi venenatis lacinia sem, et imperdiet nisl rhoncus nec. Nulla erat neque, mattis et diam quis, posuere malesuada neque. Praesent dictum magna et mauris congue, at molestie ante imperdiet. Pellentesque neque justo, egestas ac augue vitae, fringilla malesuada orci. Sed tincidunt eleifend diam, nec imperdiet libero gravida quis. Fusce accumsan ultrices mauris et aliquam. Duis rutrum facilisis ultrices.</p>' +
										'</div>' +

										'<div class="span3 col-md-3">' +
											'<h2>Header 3</h2>'+
											'<p>Content for column 3 goes here. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi venenatis lacinia sem, et imperdiet nisl rhoncus nec. Nulla erat neque, mattis et diam quis, posuere malesuada neque. Praesent dictum magna et mauris congue, at molestie ante imperdiet. Pellentesque neque justo, egestas ac augue vitae, fringilla malesuada orci. Sed tincidunt eleifend diam, nec imperdiet libero gravida quis. Fusce accumsan ultrices mauris et aliquam. Duis rutrum facilisis ultrices.</p>' +
										'</div>' +

										'<div class="span3 col-md-3">' +
											'<h2>Header 4</h2>'+
											'<p>Content for column 4 goes here. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi venenatis lacinia sem, et imperdiet nisl rhoncus nec. Nulla erat neque, mattis et diam quis, posuere malesuada neque. Praesent dictum magna et mauris congue, at molestie ante imperdiet. Pellentesque neque justo, egestas ac augue vitae, fringilla malesuada orci. Sed tincidunt eleifend diam, nec imperdiet libero gravida quis. Fusce accumsan ultrices mauris et aliquam. Duis rutrum facilisis ultrices.</p>' +
										'</div>' +
									'</div>'
				}
			]
	});

}