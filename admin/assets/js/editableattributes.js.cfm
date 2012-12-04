<cftry>
<cfcontent reset="yes" type="application/javascript">
<cfif isDefined('url.siteID') and isDefined('url.contenthistid')>
<cfset node=application.serviceFactory.getBean('contentManager').read(contentHistID=url.contentHistID,siteid=url.siteid)>
<cfif not node.getIsNew()>
	<cfoutput>
	var muraInlineEditor={
				init: function(){
						CKEDITOR.disableAutoInline = true;

						$('.mura-editable-attribute').each(
							function(){
								var attribute=$(this);
								var attributename=attribute.attr('data-attribute').toLowerCase();

								$(this).click(
									function(){
										var attribute=$(this);
										var attributename=attribute.attr('data-attribute').toLowerCase();

										if($('##adminSave').css('display') == 'none'){
											$('##adminSave').fadeIn();	
										}	

										if(!(attributename in muraInlineEditor.attributes)){
											if(attributename in muraInlineEditor.preprocessed){
												attribute.html(muraInlineEditor.preprocessed[attributename]);
											}

											muraInlineEditor.attributes[attributename]=attribute;
										}

									}
								);													
								
								if(!(attributename in muraInlineEditor.attributes)){

									if(attribute.attr('data-type').toLowerCase()=='htmleditor' && 
										typeof(CKEDITOR.instances[attribute.attr('id')]) == 'undefined' 	
									){
										CKEDITOR.inline( 
											document.getElementById( attribute.attr('id') ),
											{
												toolbar: 'Default',
												width: "75%",
												customConfig: 'config.js.cfm'
											},
											muraInlineEditor.htmlEditorOnComplete
										 );
									}
								
								}
							}
							
						);

						$('.mura-inline-save').click(function(){
							var changesetid=$(this).attr('data-changesetid');

							if(changsetid == ''){
								muraInlineEditor.data.approve=$(this).attr('data-approve');
							} else {
								if(muraInlineEditor.data.changesetid != '' && muraInlineEditor.data.changesetid != changesetid){
									if(confirm('#JSStringFormat(application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.removechangeset"),application.changesetManager.read(node.getChangesetID()).getName()))#')){
										muraInlineEditor.data._removePreviousChangeset=true;
									}
								}
								muraInlineEditor.data.changesetid=changesetid;
							}

							muraInlineEditor.save();
						});

						$('.mura-inline-cancel').click(function(){
							location.reload();
						});

						//clean instances
						for (var instance in CKEDITOR.instances) {
						   if(!$('##' + instance).length){
									CKEDITOR.instances[instance].destroy(true);
							}
						}


						 
					},
				getAttributeValue: function(attribute){
					var attributeid='mura-editable-attribute-' + attribute;
					if(typeof(CKEDITOR.instances[attributeid]) != 'undefined') {
						return CKEDITOR.instances[attributeid].getData();
					} else{
						return muraInlineEditor.attributes[attribute].html();
					}
				},
				save:function(){
						var count=0;
						for (var prop in muraInlineEditor.attributes) {
							var attribute=$(muraInlineEditor.attributes[prop]).attr('data-attribute');
							muraInlineEditor.data[attribute]=muraInlineEditor.getAttributeValue(attribute);
							count++;
						}

						if(count){
							$.post('#application.configBean.getContext()#/admin/index.cfm',
								muraInlineEditor.data,
								function(data){
									location.reload();
								}
							)
						}

						return false;
					
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
					action: 'add',
					ajaxrequest: true,
					siteid: '#JSStringFormat(node.getSiteID())#',
					sourceid: '#JSStringFormat(node.getContentHistID())#',
					contentid: '#JSStringFormat(node.getContentID())#',
					parentid: '#JSStringFormat(node.getParentID())#',
					moduleid: '#JSStringFormat(node.getModuleID())#',
					approve: 1,
					changesetid: ''
					},
				attributes: {},
				preprocessed: {
				</cfoutput>
				<cfscript>
				started=false;
				nodeCollection=node.getAllValues();
				for(attribute in nodeCollection)
					if(isSimpleValue(nodeCollection[attribute]) and reFindNoCase("(\{{|\[sava\]|\[mura\]).+?(\[/sava\]|\[/mura\]|}})",nodeCollection[attribute])){
						if(started){writeOutput(",");}
						writeOutput("'#JSStringFormat(lcase(attribute))#':'#JSStringFormat(trim(nodeCollection[attribute]))#'");
						started=true;
					}
				</cfscript>
				}
			};
	$(document).ready(function(){
		muraInlineEditor.init();
	});
</cfif>
</cfif>
<cfcatch>
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>