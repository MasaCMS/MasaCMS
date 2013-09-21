/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

if ( 'CKEDITOR' in window) {

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
                                      '<div class="row-fluid">' +
                                              '<div class="span6">' +
                                              '<h2>Edit or Delete Header</h2>'+
                                            '<p>Content for the first column goes here.</p>' +
                                            '</div>' +

                                              '<div class="span6">' +
                                              '<h2>Edit or Delete Header</h2>'+
                                            '<p>Content for the second column goes here.</p>' +
                                            '</div>' +

                                      '</div>'
                      },
                      {
                              title: '3 Columns',
                              image: 'template-cols3.gif',
                              description: 'An area with 3 equally wide columns',
                              html:
                                      '<div class="row-fluid">' +
                                              '<div class="span4">' +
                                              '<h2>Edit or Delete Header</h2>'+
                                            '<p>Content for the first column goes here.</p>' +
                                            '</div>' +

                                              '<div class="span4">' +
                                              '<h2>Edit or Delete Header</h2>'+
                                            '<p>Content for the second column goes here.</p>' +
                                            '</div>' +

                                              '<div class="span4">' +
                                              '<h2>Edit or Delete Header</h2>'+
                                            '<p>Content for the third column goes here.</p>' +
                                            '</div>' +
                                      '</div>'
                      },
                      {
                              title: '4 Columns',
                              image: 'template-cols4.gif',
                              description: 'An area with 4 equally wide columns',
                              html:
                                      '<div class="row-fluid">' +
                                              '<div class="span3">' +
                                              '<h2>Edit or Delete Header</h2>'+
                                            '<p>Content for the first column goes here.</p>' +
                                            '</div>' +

                                              '<div class="span3">' +
                                              '<h2>Edit or Delete Header</h2>'+
                                            '<p>Content for the second column goes here.</p>' +
                                            '</div>' +

                                              '<div class="span3">' +
                                              '<h2>Edit or Delete Header</h2>'+
                                            '<p>Content for the third column goes here.</p>' +
                                            '</div>' +

                                              '<div class="span3">' +
                                              '<h2>Edit or Delete Header</h2>'+
                                            '<p>Content for the fourth column goes here.</p>' +
                                            '</div>' +
                                      '</div>'

                      }
              ]
  });

}