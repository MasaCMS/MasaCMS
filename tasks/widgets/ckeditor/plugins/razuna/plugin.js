
RazunaAdded=false;

CKEDITOR.plugins.add( 'razuna', {
	init: function( editor ) {	

		if(typeof renderRazunaWindow != 'undefined'){
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
					   		try{
						   		$('#razunaModalWindow').dialog("close");
						   	} catch(err){}
					 	}
					 );
			      }

			      else if (!CKEDITOR.currentInstance.razunaimage && ev.data.name == 'image2' )
			      {
			       
			         ev.data.definition.getContents( 'info' ).elements[0].children[0].children.push({
						               id: 'razuna',
						               type: 'button',
						               label: 'Razuna',
						               style: 'display:inline-block;margin-top:12px;',
			                           align: "center",
						               title: 'Razuna',
						               disabled: false,
						               onClick: function()
						                  {	
						                     renderRazunaWindow(this.getDialog().getContentElement("info", "src"));
						                  },

						            });

			       	CKEDITOR.currentInstance.razunaimage=true;
			   
					ev.data.definition.dialog.on( 'hide', function( ev )
					   {
					   		try{
						   		$('#razunaModalWindow').dialog("close");
						   	} catch(err){}
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
					   		try{
						   		$('#razunaModalWindow').dialog("close");
						   	} catch(err){}
					 	}
					 );
			      }

			      else if (!CKEDITOR.currentInstance.razunalink && ev.data.name == 'link' )
			      {
			      	
			      	var temp = {
					    "type": "hbox",
					    "id": "urlOptionsButtons",
					    "widths": ["25%", "75%"],
					    "children": []
					    };
					 	
					temp.children.push(ev.data.definition.getContents( 'info' ).elements[1].children[1]);
				
			        temp.children.push({
						               id: 'razuna',
						               type: 'button',
						               label: 'Razuna',
						     
						               title: 'Razuna',
						               disabled: false,
						               onClick: function()
						                  {	
						                     renderRazunaWindow(this.getDialog().getContentElement("info", "url"));
						                  },

						            });

			        ev.data.definition.getContents( 'info' ).elements[1].children[1]=temp;

			       	CKEDITOR.currentInstance.razunalink=true;
			   
					ev.data.definition.dialog.on( 'hide', function( ev )
					   {
						   	try{
						   		$('#razunaModalWindow').dialog("close");
						   	} catch(err){}
					 	}
					 );
			      }
			      
			   });

			}

		}
	}
);	
    	

		