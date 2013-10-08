
CKEDITOR.plugins.add( 'razuna', {
		init: function( editor ) {	

			 		editor.ui.addButton( 'razuna',
						{
							label : 'Razuna',
							command : 'razunaDialog',
							icon: this.path + 'icons/razuna.png'
						}
					);
				    
				    editor.addCommand( 'razunaDialog', {
							exec : function( editor )
							{    
								renderRazunaWindow(editor);
							}
						}
					);
				        
				        
		
				   	
				    }
				}
			);	
    	

		
