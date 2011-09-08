/**
 * QR CODES plugin for CKEditor 3.x 
 * @Author: Cedric Dugas, http://www.position-absolute.com
 * @Copyright Cakemail
 * @version:	 1.0
 */

CKEDITOR.dialog.add("gmap",function(e){	
	
	return{
		title:e.lang.gmap.title,
		resizable : CKEDITOR.DIALOG_RESIZE_BOTH,
		minWidth:180,
		minHeight:160,
		onShow:function(){ 
		},
		onLoad:function(){ 
				this.setupContent();
		},
		onOk:function(){
			
			var url = this.getValueOf("info","insertcode_area");
			var zoom = this.getValueOf("info","zoom");
			var height = this.getValueOf("info","txtHeight");
			var width = this.getValueOf("info","txtWidth");
			 url = url.replace(/\s/g , "+");
			var sInsert='<img src="http://maps.google.com/maps/api/staticmap?center='+url+'&markers=color:red|'+url+'&zoom='+zoom+'&size='+width+'x'+height+'&sensor=false" alt="Map" />';   
			if ( sInsert.length > 0 ) 
			e.insertHtml(sInsert); 
		},
		contents:[
			{	id:"info",
				name:'info',
				label:e.lang.gmap.commonTab,
				elements:[{
				 type:'vbox',
				 padding:0,
				 children:[
				  {
				  type:'html',
				  html:'<div style="padding-bottom:5px;">'+e.lang.gmap.HelpInfo+'</div>'
				  },
				  { type:'text',
				    id:'insertcode_area'
				  },
					{
						type : 'hbox',
						widths : [ '55%', '100%' ],
						children :
						[
							{
								type : 'vbox',
								padding : 1,
								widths : [ '10%', '100%' ],
								style : 'margin-top:10px;width:230px;',
								children :
								[
									{
										type : 'text',
										width: '40px',
										id : 'txtWidth',
										labelLayout : 'horizontal',	
										label : e.lang.gmap.Width,
										"default":"250"
									},
									
									{
										type : 'text',
										id : 'txtHeight',
										width: '40px',
										labelLayout : 'horizontal',
										label : e.lang.gmap.Height,
										"default":"250"
									},
									{
										id : 'zoom',
										type : 'select',
										labelLayout : 'horizontal',
										width: '120px',
										label : e.lang.gmap.Zoom,
										'default' : '14',
										items :
										[
											[ "14 - "+ e.lang.gmap.Near+"", '14'],
											[ "13" , '13'],
											[ "12" , '12'],
											[ "11" , '11'],
											[ "10" , '10'],
											[ "9" , '9'],
											[ "8" , '8'],
											[ "7 - "+ e.lang.gmap.Far+"" , '7']
										]
									}
								]
							}
						]		
					}]
				}]
			}
		]
	};
});


	