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
			 minWidth : 400,
			 minHeight : 400,
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

				/* Begin insert links */
				if (typeof(iframeWindow.document.forms.frmLinks.theLinks) != 'undefined') {

					var theChoice = -1;
					
					if(iframeWindow.document.frmLinks.theLinks.length == undefined) {
						theChoice = 0; 
						theLink=iframeWindow.document.forms.frmLinks.theLinks.value.split("^")
					} else {
						for (counter = 0; counter < iframeWindow.document.frmLinks.theLinks.length; counter++) {
							if (iframeWindow.document.frmLinks.theLinks[counter].checked) {
								theChoice = counter; 
								var theLink=iframeWindow.document.forms.frmLinks.theLinks[theChoice].value.split("^");
							}
						}
					}

					if(theChoice != -1) {

						var mySelection = this._.editor.getSelection(),
							ranges = mySelection.getRanges( true ),
							selectedText, href, html;
						
						if (CKEDITOR.env.ie) {
						    mySelection.unlock(true);
						    selectedText = mySelection.getNative().createRange().text;
						} else {
						    selectedText = mySelection.getNative();
						}
						
						if ( ranges.length == 1 )
						{
							href = '<a href="' + theLink[0] + '">' + ( selectedText != "" ? selectedText :
					theLink[1] ) + '</a>';
							html = CKEDITOR.dom.element.createFromHtml( href );
							
							ranges[0].deleteContents();
							ranges[0].insertNode( html );
							ranges[0].selectNodeContents( html );
							mySelection.selectRanges( ranges );
						}
					}
				}
				/* End insert links */

			  }
		  };
		} );

	},

	requires : [ 'iframedialog' ]
} );

