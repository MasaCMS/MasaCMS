
var iframeWindow = null;
CKEDITOR.plugins.add( 'SelectComponent',
{
	init : function( editor )
	{
		editor.ui.addButton( 'SelectComponent',
			{
				label : 'Insert Component',
				command : 'SelectComponent',
				icon: this.path + 'btn_selectcomponent.png'
			});
		
		var selectComponentCommand = editor.addCommand( 'SelectComponent', new CKEDITOR.dialogCommand( 'SelectComponent' ) );
		selectComponentCommand.canUndo = false;

		//CKEDITOR.dialog.addIframe( 'Selectlink', 'Select Link', this.path + 'fck_selectlink.cfm', 400, 400, function() {});
		var me = this;
		CKEDITOR.dialog.add( 'SelectComponent', function () {
		  return {
			 title : 'Select Component',
			 minWidth : 340,
			 minHeight : 50,
			 contents :
				   [
					  {
						 id : 'iframe',
						 label : 'Insert Component...',
						 expand : true,
						 elements :
							   [
								  {
									 type : 'iframe',
									 src : me.path + 'fck_selectComponent.cfm',
									 width : '100%',
									 height : '100%',
									 onContentLoad : function() {
										var iframe = document.getElementById(this._.frameId);
										iframeWindow = iframe.contentWindow;
									 }
								  }
							   ]
					  }
				   ],
			 onOk : function() {

				if(iframeWindow.document.getElementById('btnComponents').value != ''){
					this._.editor.insertHtml(iframeWindow.document.getElementById('btnComponents').value) ;	
				}else{
					alert('Please select a component.');
					return false;
				}

			  }
		  };
		} );

	},

	requires : [ 'iframedialog' ]
} );

