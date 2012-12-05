<cfcontent reset="yes" type="application/javascript">
<cfif isDefined("url.siteID")>
<cfset isIeSix=FindNoCase('MSIE 6','#CGI.HTTP_USER_AGENT#') GREATER THAN 0>
<cfset $=application.serviceFactory.getBean("MuraScope").init(url.siteID)>
<cfparam name="Cookie.fetDisplay" default="">
<cfoutput>	
	addLoadEvent(checkToolbarDisplay);
	
	var adminProxy;
	var adminDomain=<cfif len($.globalConfig('admindomain'))>"#$.globalConfig('admindomain')#"<cfelse>location.hostname</cfif>;
	var adminProtocal=<cfif application.configBean.getAdminSSL() or application.utility.isHTTPS()>"https://";<cfelse>"http://"</cfif>;
	var adminProxyLoc=adminProtocal + adminDomain + "#$.globalConfig('serverPort')##$.globalConfig('context')#/admin/assets/js/porthole/proxy.html";
	var frontEndProxyLoc= location.protocol + "//" + location.hostname + "#$.globalConfig('serverPort')#";
	
	function onAdminMessage(messageEvent){

		if (messageEvent.origin == adminProtocal + adminDomain + "#$.globalConfig('serverPort')#") {
			
			var parameters=messageEvent.data;
			
			if (parameters["cmd"] == "setWidth") {			
				if(parameters["width"]=='configurator'){
					frontEndModalWidth=frontEndModalWidthConfigurator;
				} else if(jQuery.isNumeric(parameters["width"])){
					frontEndModalWidth=parameters["width"];
				} else {
					frontEndModalWidth=frontEndModalWidthStandard;
				}
				resizeFrontEndToolsModal();	
			} else if(parameters["cmd"] == "setLocation"){
				window.location=decodeURIComponent(parameters["location"]);
			} else if(parameters["cmd"] == "setHeight"){
				resizeFrontEndToolsModal(decodeURIComponent(parameters["height"]));
			}
		}			
	}

	var adminProxy;
	
	function initAdminProxy(){
			adminProxy = new Porthole.WindowProxy(adminProxyLoc, 'frontEndToolsModaliframe');
			adminProxy.addEventListener(onAdminMessage);
	}
	
	addLoadEvent(initAdminProxy);
	
	
	<cfif $.getJsLib() eq "jquery">
	var frontEndModalWidthStandard=990;
	var frontEndModalWidthConfigurator=600;
	var frontEndModalHeight=0;
	var frontEndModalWidth=0;

	function openFrontEndToolsModal(a){
		var src=a.href + "&frontEndProxyLoc=" + frontEndProxyLoc;
		var isModal=jQuery(a).attr("data-configurator");
		var width=jQuery(a).attr("data-modal-width");

		frontEndModalHeight=0;
		frontEndModalWidth=0;
		
		if(jQuery.isNumeric(width)){
			frontEndModalWidth = width;
		}

		if(!frontEndModalHeight){
			if (isModal == undefined) {
				frontEndModalWidth = frontEndModalWidthStandard;
			} else if (isModal == "true") {
				frontEndModalWidth=frontEndModalWidthConfigurator;
			} else {
				frontEndModalWidth = frontEndModalWidthStandard;
			}
		}
		
		closeFrontEndToolsModal();
		
		jQuery("##frontEndToolsModalTarget").html('<div id="frontEndToolsModalContainer">' +
		'<div id="frontEndToolsModalBody">' +
		'<a id="frontEndToolsModalClose" style="display:none;" href="javascript:closeFrontEndToolsModal();"><i class="icon-remove-sign"></i></a>' +
		'<iframe src="' + src + '" id="frontEndToolsModaliframe" scrolling="false" frameborder="0" style="overflow:hidden" name="frontEndToolsModaliframe"></iframe>' +
		'</div>' +
		'</div>');
		
		frontEndModalHeight=0;
		jQuery("##frontEndToolsModalBody").css("top",($(document).scrollTop()+50) + "px")
		resizeFrontEndToolsModal(0);
		
	}
	
	function resizeFrontEndToolsModal(frameHeight){
		if (document.getElementById("frontEndToolsModaliframe")) {
			var frame = document.getElementById("frontEndToolsModaliframe");
			var frameContainer = document.getElementById("frontEndToolsModalContainer");
			
			//if (frameDoc.body != null) {
				var windowHeight = Math.max(frameHeight, jQuery(window).height());
		
				if (frontEndModalWidth==frontEndModalWidthStandard 
					&& frameHeight < jQuery(window).height()
					) {
					frameHeight= Math.max(jQuery(window).height() * .80,frameHeight);
				}

				jQuery('##frontEndToolsModalContainer ##frontEndToolsModalBody,##frontEndToolsModalContainer ##frontEndToolsModaliframe').width(frontEndModalWidth);
				
				frame.style.height = frameHeight + "px";
				frameContainer.style.position = "absolute";
				document.overflow = "auto"
				
				if(windowHeight > frontEndModalHeight){	
					frontEndModalHeight=windowHeight;
					frameContainer.style.height=jQuery(document).height() + "px"
					setTimeout(function(){
						jQuery("##frontEndToolsModalClose").fadeIn("fast")
					},1000);
					
				}
				
			//}
			//setTimeout(resizeFrontEndToolsModal, 250);
		}
		
	}
	
	function closeFrontEndToolsModal(){
		jQuery('##frontEndToolsModalContainer').remove();
	}	
	

	
	jQuery(document).ready(function(){
		jQuery(".frontEndToolsModal").each(
			function(){
				jQuery(this).click(function(event){
					event.preventDefault();
					openFrontEndToolsModal(this);
				});
		});
	});	
	</cfif>
	<!---
	function checkToolbarDisplay () {
		<cfif Cookie.fetDisplay eq "none">
			<cfif $.getJsLib() eq "jquery">
				$(".editableObject").each(
					function(intIndex){
						$(this).addClass('editableObjectHide');
					}
				);
			<cfelse>
				$$(".editableObject").each(
					function(o){
						o.addClassName('editableObjectHide');
					}
				);
			</cfif>
		</cfif>
	}
	--->
	
	function checkToolbarDisplay () {
		<cfif Cookie.fetDisplay eq "none">
			<cfif $.getJsLib() eq "jquery">
				$('HTML').removeClass('mura-edit-mode');
				$(".editableObject").each(
					function(intIndex){
						$(this).addClass('editableObjectHide');
					}
				);
			<cfelse>
				$$(".editableObject").each(
					function(o){
						o.addClassName('editableObjectHide');
					}
				);
			</cfif>
		<cfelseif $.getJsLib() eq "jquery">
			$('HTML').addClass('mura-edit-mode');
		</cfif>
	}
	
	
<cfif not isIeSix>
	function toggleAdminToolbar(){
		<cfif $.getJsLib() eq "jquery">
			$("##frontEndTools").animate({opacity: "toggle"});
			$('HTML').toggleClass('mura-edit-mode');
			$(".editableObject").each(
				function(intIndex){
					$(this).toggleClass('editableObjectHide');
				}
			);
		<cfelse>
			Effect.toggle("frontEndTools", "appear");
			
			$$(".editableObject").each(
				function(o){
					o.toggleClassName('editableObjectHide');
				}
			);
		</cfif>
	}

	function resizeEditableObjects(){
		$(".editableObjectContents").each(	
			function(el){
				var display="inline";	
				var width=0;
				var float;
						
				$(this).children().each(
					function(el){			
						if ($(this).css("display") == "block") {
							display = "block";
							float=$(this).css("float");
							width=$(this).outerWidth();
						}											
					}	
				);
					
				$(this).css("display",display).parent().css("display",display);
					
				if(width){
					$(this).width(width).parent().width(width);
					$(this).css("float",float).parent().css("float",float);
				}
					
			}
		);
	}

	jQuery(document).ready(
		function($) {
			resizeEditableObjects();
		}
	);

	$(window).resize(function() {
  		resizeEditableObjects();
	});


<cfelse>
	function toggleAdminToolbarIE6(){
	<cfif $.getJsLib() eq "jquery">
		$("##frontEndToolsIE6").animate({opacity: "toggle"});
		
		$(".editableObject").each(
			function(intIndex){
				$(this).toggleClass('editableObjectHide');
			}
		);
		
	<cfelse>
		Effect.toggle("frontEndToolsIE6", "appear");
		
		$$(".editableObject").each(
			function(o){
				o.toggleClassName('editableObjectHide');
			}
		);
	</cfif>
	};
					
	function showSubMenuIE6(callerId,elementId){
		var callerElement = document.getElementById(callerId);					
		var xCoord = callerElement.offsetLeft;
		var yCoord = callerElement.offsetTop + callerElement.offsetHeight + 0;		
		var minWidth = callerElement.offsetWidth;
		var subMenu = document.getElementById(elementId);
							
		if(subMenu){			
			subMenu.style.position = 'absolute';
			subMenu.style.left = xCoord + 'px';
			subMenu.style.top = yCoord + 'px';					
		};			
		showObjIE6(elementId);					
	};
		
	function showObjIE6(elementId){			
		if(document.getElementById(elementId)){
			document.getElementById(elementId).style.display = '';
		};
	};
			
	function hideObjIE6(elementId){			
		if(document.getElementById(elementId)){
			document.getElementById(elementId).style.display = 'none';
		};
	};
</cfif>	
</cfoutput>
</cfif>
<cfif isDefined('url.siteID') and isDefined('url.contenthistid') and isDefined('url.showEditableObjects') and url.showEditableObjects>
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
										var editor=CKEDITOR.inline( 
											document.getElementById( attribute.attr('id') ),
											{
												toolbar: 'Default',
												width: "75%",
												customConfig: 'config.js.cfm'
											}
										 );

										 editor.on('change', function(){
										 	if($('##adminSave').css('display') == 'none'){
												$('##adminSave').fadeIn();	
											}
										 });
									}
								
								}
							}
							
						);

						$('.mura-inline-save').click(function(){
							var changesetid=$(this).attr('data-changesetid');

							if(changesetid == ''){
								muraInlineEditor.data.approve=$(this).attr('data-approve');
								muraInlineEditor.data.changesetid='';
							} else {
								if(muraInlineEditor.data.changesetid != '' && muraInlineEditor.data.changesetid != changesetid){
									if(confirm('#JSStringFormat(application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.removechangeset"),application.changesetManager.read(node.getChangesetID()).getName()))#')){
										muraInlineEditor.data._removePreviousChangeset=true;
									}
								}
								muraInlineEditor.data.changesetid=changesetid;
								muraInlineEditor.data.approve=0;
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
					approve: 0,
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
