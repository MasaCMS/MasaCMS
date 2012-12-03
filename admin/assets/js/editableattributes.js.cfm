<cfset node=application.serviceFactory.getBean('$').init(url.siteid).getBean('content').loadBy(contentHistID=url.contentHistID)>
<cfif not node.getIsNew()>
	<cfoutput>
	var muraInlineEditor={
				init: function(){
						CKEDITOR.disableAutoInline = true;

						$('.mura-editable-attribute').each(
							function(){
								var attribute=$(this);

								attribute.click(function(){$('##muracontentsave').fadeIn();});								
								
								if(attribute.attr('data-type').toLowerCase()=='htmleditor'){
									CKEDITOR.inline( 
										document.getElementById( 'mura-editable-attribute-' + attribute.attr('data-attribute') ),
										{
											toolbar: 'Default',
											width: "75%",
											customConfig: 'config.js.cfm'
										},
										muraInlineEditor.htmlEditorOnComplete
									 );
								}

								muraInlineEditor.attributes[attribute.attr('data-attribute')]=attribute;
							}
							
						);

						//clean instances
						for (var instance in CKEDITOR.instances) {
						   if(!$('##' + instance).length){
									CKEDITOR.instances[instance].destroy(true);
							}
						}
						 
					},
				getEditorInstance: function(attribute){
					var attributeid='mura-editable-attribute-' + attribute;
					if(typeof(CKEDITOR.instances[attributeid]) != 'undefined' && instance != CKEDITOR.instances[instance]) {
						return CKEDITOR.instances[attributeid];
					} else{
						return null;
					}
				},
				save:function(){
						var count=0;
						for (var prop in muraInlineEditor.attributes) {
							var attribute=muraInlineEditor.attributes[prop];
							var editor=getEditorInstance(prop);

							if(!editor) {
								muraInlineEditor.data[$(muraInlineEditor.attributes[i]).attr('data-attribute')]=attribute.html();	
							} else {
								muraInlineEditor.data[$(muraInlineEditor.attributes[i]).attr('data-attribute')]=editor.getData();		
							}

							count++;
						}

						if(count){
							$.post('#application.configBean.getContext()#/admin/index.cfm',
								muraInlineEditor.data,
								function(data){
									alert('saved');
								}
							)
						}
					
				},
				htmlEditorOnComplete: function(editorInstance) {	
					var instance = $(editorInstance).ckeditorGet();
					instance.resetDirty();
					var totalInstances = CKEDITOR.instances;
					CKFinder.setupCKEditor(
					instance, {
						basePath: '#application.configBean.getContext()#/tasks/widgets/ckfinder/',
						rememberLastFolder: false
					});
				},
				data:{
					muraaction: 'carch.update',
					ajaxrequest: true,
					siteid: '#JSStringFormat(node.getSiteID())#',
					sourceid: '#JSStringFormat(node.getContentHistID())#',
					contentid: '#JSStringFormat(node.getContentID())#',
					parentid: '#JSStringFormat(node.getParentID())#',
					approve: 1,
					changesetid: ''
					},
				attributes: {},
			};
	</cfoutput>
	$(document).ready(function(){
		muraInlineEditor.init();
	});
</cfif>