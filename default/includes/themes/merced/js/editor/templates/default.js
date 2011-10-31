/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
	
// Register a templates definition set named "default".
CKEDITOR.addTemplates( 'default',
{
    // The name of sub folder which hold the shortcut preview images of the
    // templates.
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
                                    '<div class="columns2 clearfix">' +
                                            '<div class="col">' +
                                            '<h3>Edit or Delete Header</h3>'+
                                          '<p>Content for the first column goes here.</p>' +
                                          '</div>' +
                                            
                                            '<div class="col">' +
                                            '<h3>Edit or Delete Header</h3>'+
                                          '<p>Content for the second column goes here.</p>' +
                                            
                                    '</div>'
                    },
                    {
                            title: '3 Columns',
                            image: 'template-cols3.gif',
                            description: 'An area with 3 equally wide columns',
                            html:
                                    '<div class="columns3 clearfix">' +
                                            '<div class="col">' +
                                            '<h3>Edit or Delete Header</h3>'+
                                          '<p>Content for the first column goes here.</p>' +
                                          '</div>' +
                                            
                                            '<div class="col">' +
                                            '<h3>Edit or Delete Header</h3>'+
                                          '<p>Content for the second column goes here.</p>' +
                                          '</div>' +

                                            '<div class="col">' +
                                            '<h3>Edit or Delete Header</h3>'+
                                          '<p>Content for the third column goes here.</p>' +
                                          '</div>' +
                                    '</div>'
                    },
                    {
                            title: '4 Columns',
                            image: 'template-cols4.gif',
                            description: 'An area with 4 equally wide columns',
                            html:
                                    '<div class="columns4 clearfix">' +
                                            '<div class="col">' +
                                            '<h3>Edit or Delete Header</h3>'+
                                          '<p>Content for the first column goes here.</p>' +
                                          '</div>' +
                                            
                                            '<div class="col">' +
                                            '<h3>Edit or Delete Header</h3>'+
                                          '<p>Content for the second column goes here.</p>' +
                                          '</div>' +

                                            '<div class="col">' +
                                            '<h3>Edit or Delete Header</h3>'+
                                          '<p>Content for the third column goes here.</p>' +
                                          '</div>' +

                                            '<div class="col">' +
                                            '<h3>Edit or Delete Header</h3>'+
                                          '<p>Content for the fourth column goes here.</p>' +
                                          '</div>' +
                                    '</div>'

                    }
            ]
});