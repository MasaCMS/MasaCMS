
RazunaAdded=false;

CKEDITOR.plugins.add( 'razuna', {
	init: function( editor ) {	

		if(renderRazunaWindow){
			CKEDITOR.on( 'dialogDefinition', function( ev )
			   {

			      if (!CKEDITOR.currentInstance.razunaimage && ev.data.name == 'image' )
			      {
			       
			         ev.data.definition.getContents( 'info' ).elements[0].children[0].children.push({
						               id: 'razuna',
						               type: 'button',
						               label: 'Razuna',
						               style: "display:inline-block;margin-top:10px;",
			                           align: "center",
						               title: 'Razuna',
						               disabled: false,
						               onClick: function()
						                  {	
						                     renderRazunaWindow(this.getDialog().getContentElement("info", "txtUrl"));
						                  },

						            });

			       	CKEDITOR.currentInstance.razunaimage=true;
			   
					ev.data.definition.dialog.on( 'hide', function( ev )
					   {
					   	$('#razunaModalWindow').dialog("close");
					 	}
					 );
			      }

			      else if (!CKEDITOR.currentInstance.razunaflash && ev.data.name == 'flash' )
			      {
			       
			         ev.data.definition.getContents( 'info' ).elements[0].children[0].children.push({
						               id: 'razuna',
						               type: 'button',
						               label: 'Razuna',
						               style: "display:inline-block;margin-top:10px;",
			                           align: "center",
						               title: 'Razuna',
						               disabled: false,
						               onClick: function()
						                  {	
						                     renderRazunaWindow(this.getDialog().getContentElement("info", "src"));
						                  },

						            });

			       	CKEDITOR.currentInstance.razunaflash=true;
			   
					ev.data.definition.dialog.on( 'hide', function( ev )
					   {
					   	$('#razunaModalWindow').dialog("close");
					 	}
					 );
			      }

			      else if (!CKEDITOR.currentInstance.razunalink && ev.data.name == 'link' )
			      {
			      	alert( JSON.stringify(ev.data.definition.getContents( 'info' ).elements) );
			         ev.data.definition.getContents( 'info' ).elements[1].children[0].children.push({
						               id: 'razuna',
						               type: 'button',
						               label: 'Razuna',
						               style: "display:inline-block;margin-top:10px;",
			                           align: "center",
						               title: 'Razuna',
						               disabled: false,
						               onClick: function()
						                  {	
						                     renderRazunaWindow(this.getDialog().getContentElement("info", "url"));
						                  },

						            });

			       	CKEDITOR.currentInstance.razunalink=true;
			   
					ev.data.definition.dialog.on( 'hide', function( ev )
					   {
					   	$('#razunaModalWindow').dialog("close");
					 	}
					 );
			      }
			      
			   });

			}

		}
	}
);	
    	

		