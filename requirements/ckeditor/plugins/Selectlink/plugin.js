var iframeWindow = null;
CKEDITOR.plugins.add( 'Selectlink',
{
	init : function( editor )
	{
		editor.ui.addButton( 'Selectlink',
			{
				label : 'Add Internal Link',
				command : 'Selectlink',
				icon: this.path + 'btn_selectlink.png'
			});
		var selectLinkCommand = editor.addCommand( 'Selectlink', new CKEDITOR.dialogCommand( 'Selectlink' ) );
		selectLinkCommand.canUndo = false;
		
		//CKEDITOR.dialog.addIframe( 'Selectlink', 'Select Link', this.path + 'fck_selectlink.cfm', 400, 400, function() {});
		var me = this;
		CKEDITOR.dialog.add( 'Selectlink', function () {
		  return {
			 title : 'Select Link',
			 minWidth : 550,
			 minHeight : 500,
			 resizable : CKEDITOR.DIALOG_RESIZE_BOTH,
			 contents :
				   [
					  {
						 id : 'iframe',
						 label : 'Insert Internal Link...',
						 expand : true,
						 elements :
							   [
								  {
									 type : 'iframe',
									 src : me.path + 'fck_selectlink.cfm',
									 width : '100%',
									 height : '460px',
									 onContentLoad : function() {
										var iframe = document.getElementById(this._.frameId);
										iframeWindow = iframe.contentWindow;
									 }
								  }
							   ]
					  }
				   ],
			 onOk : function() {
				/* Begin insert links */
				if (typeof(iframeWindow.document.forms.frmLinks.theLinks) != 'undefined') {
					var theChoice = -1,
						theLink;
					
					if(iframeWindow.document.forms.frmLinks.theLinks.length == undefined) {
						theChoice = 0; 
						theLink = iframeWindow.document.forms.frmLinks.theLinks.value.split("^");
					} else {
						for (counter = 0; counter < iframeWindow.document.forms.frmLinks.theLinks.length; counter++) {
							if (iframeWindow.document.forms.frmLinks.theLinks[counter].checked) {
								theChoice = counter; 
								theLink = iframeWindow.document.forms.frmLinks.theLinks[theChoice].value.split("^");
							}
						}
					}
				
					if(theChoice != -1) {

						var editor = this._.editor,
							selection = editor.getSelection(),
							ranges = selection.getRanges( true );
						
						if ( ranges.length == 1 && ranges[0].collapsed )
						{
							var text = new CKEDITOR.dom.text( theLink[1], editor.document );
							ranges[0].insertNode( text );
							ranges[0].selectNodeContents( text );
						}
						selection.selectRanges( ranges );
						
						var style = new CKEDITOR.style( {
							element : 'a',
							attributes : {
								href : theLink[0]
								}
							} );
						style.type = CKEDITOR.STYLE_INLINE;
						style.apply( editor.document );
					}
				}
				/* End insert links */

			  }
		  };
		} );

	},

	requires : [ 'iframedialog' ]
} );

