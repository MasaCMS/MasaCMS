<cfcontent reset="yes" type="application/javascript">
<cfif isDefined("url.siteID")>
<cfset isIeSix=FindNoCase('MSIE 6','#CGI.HTTP_USER_AGENT#') GREATER THAN 0>
<cfset $=application.serviceFactory.getBean("MuraScope").init(url.siteID)>
<cfparam name="Cookie.fetDisplay" default="">
<cfoutput>
	var adminProxy;
	var adminDomain=<cfif len($.globalConfig('admindomain'))>"#$.globalConfig('admindomain')#"<cfelse>location.hostname</cfif>;
	var adminProtocal=<cfif application.configBean.getAdminSSL() or application.utility.isHTTPS()>"https://";<cfelse>"http://"</cfif>;
	var adminProxyLoc=adminProtocal + adminDomain + "#$.globalConfig('serverPort')##$.globalConfig('context')#/admin/assets/js/porthole/proxy.html";
	var frontEndProxyLoc= location.protocol + "//" + location.hostname + "#$.globalConfig('serverPort')#";
	
	function onAdminMessage(messageEvent){

		if (messageEvent.origin == 'http://' + adminDomain + "#$.globalConfig('serverPort')#"
			|| messageEvent.origin == 'https://' + adminDomain + "#$.globalConfig('serverPort')#") {
			
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
	
	var frontEndModalWidthStandard=990;
	var frontEndModalWidthConfigurator=600;
	var frontEndModalHeight=0;
	var frontEndModalWidth=0;
	var frontEndModalIE8=document.all && document.querySelector && !document.addEventListener;
	
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
					if(frontEndModalIE8){
						frameContainer.style.height=Math.max(frameHeight,jQuery(document).height()) + "px";
					} else {
						frameContainer.style.height=jQuery(document).height() + "px";
					}
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
	
	function checkToolbarDisplay () {
		<cfif Cookie.fetDisplay eq "none">
			$('HTML').removeClass('mura-edit-mode');
			$(".editableObject").addClass('editableObjectHide');
		<cfelse>
			$('HTML').addClass('mura-edit-mode');
		</cfif>
	}
	
	

	function toggleAdminToolbar(){
		$("##frontEndTools").animate({opacity: "toggle"});
		$('HTML').toggleClass('mura-edit-mode');
		$(".editableObject").toggleClass('editableObjectHide');
			
		if(muraInlineEditor.inited){
			$(".mura-editable").toggleClass('inactive');
		}
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
		function(){
			jQuery(".frontEndToolsModal").each(
				function(){
					jQuery(this).click(function(event){
						event.preventDefault();
						openFrontEndToolsModal(this);
					}
				);
			});
			
			resizeEditableObjects();
			checkToolbarDisplay();
			initAdminProxy();
			
			if(frontEndModalIE8){
				$("##adminQuickEdit").remove();
			}
		}
	);

	$(window).resize(function() {
  		resizeEditableObjects();
	});
</cfoutput>
</cfif>
<cfif isDefined('url.siteID') and isDefined('url.contenthistid') and isDefined('url.showInlineEditor') and url.showInlineEditor>
<cfset node=application.serviceFactory.getBean('contentManager').read(contentHistID=url.contentHistID,siteid=url.siteid)>
<cfif not node.getIsNew()>
	<cfoutput>
	var muraInlineEditor={
		inited: false,
		init: function(){

			if(muraInlineEditor.inited){
				return false;
			}

			CKEDITOR.disableAutoInline=true;
			muraInlineEditor.inited=true;
			$('##adminSave').fadeIn();	
			$('.mura-editable').removeClass('inactive');

			$('.mura-editable-attribute').each(
			function(){
				var attribute=$(this);
				var attributename=attribute.attr('data-attribute').toLowerCase();

				attribute.attr('contenteditable','true');
				attribute.attr('title','');

				$(this).unbind('dblclick');

				$(this).click(
					function(){
						var attribute=$(this);
						var attributename=attribute.attr('data-attribute').toLowerCase();
				
						if(!(attributename in muraInlineEditor.attributes)){
							if(attributename in muraInlineEditor.preprocessed){
								attribute.html(muraInlineEditor.preprocessed[attributename]);
							}

							attribute.getAttribute=function(p){
							var value=$(this).attr(p);
								if(value==''){
									return undefined;
								} else {
									return value;
								}
							}

							//alert(attribute.getAttribute('data-label'));

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
						});

						editor.on('change', function(){
							if($('##adminSave').css('display') == 'none'){
								$('##adminSave').fadeIn();	
							}
						});
					}
								
				}
			});

			$('.mura-inline-save').click(function(){
				var changesetid=$(this).attr('data-changesetid');

				if(changesetid == ''){
					//alert(1 + " " + $(this).attr('data-approved'))
					muraInlineEditor.data.approved=$(this).attr('data-approved');
					muraInlineEditor.data.changesetid='';
				} else {
					if(muraInlineEditor.data.changesetid != '' && muraInlineEditor.data.changesetid != changesetid){
						if(confirm('#JSStringFormat(application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.removechangeset"),application.changesetManager.read(node.getChangesetID()).getName()))#')){
							muraInlineEditor.data._removePreviousChangeset=true;
						}
					}
					//alert(changesetid)
					muraInlineEditor.data.changesetid=changesetid;
					muraInlineEditor.data.approved=0;
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

			return false;				 
		},
		getAttributeValue: function(attribute){
			var attributeid='mura-editable-attribute-' + attribute;
			if(typeof(CKEDITOR.instances[attributeid]) != 'undefined') {
				return CKEDITOR.instances[attributeid].getData();
			} else{
				return $.trim(muraInlineEditor.stripHTML(muraInlineEditor.attributes[attribute].html()));
			}
		},
		save:function(){
			if(muraInlineEditor.validate()){
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
							var resp = eval('(' + data + ')');
							location.href=resp.location;
						}
					);
				} else {
					location.reload();
				}
			}
			return false;		
		},
		stripHTML: function(html){
			var tmp = document.createElement("DIV");
			tmp.innerHTML = html;
			return tmp.textContent||tmp.innerText;
		},
		validate: function(){
				var errors="";
				var setFocus=0;
				var started=false;
				var startAt;
				var firstErrorNode;
				var validationType='';
				for (var prop in muraInlineEditor.attributes) {
				 theField=muraInlineEditor.attributes[prop];
				 validationType=getValidationType(theField);
				 theValue=muraInlineEditor.getAttributeValue(prop);
				 //alert(prop + ":" + theValue + " " + validationType);
				if(getValidationIsRequired(theField) && theValue == "" )
					{	
						if (!started) {
						started=true;
						startAt=prop;
						}
						
						errors += getValidationMessage(theField,' is required.');
						 			
					}
				else if(validationType != ''){
						
					if(validationType=='EMAIL' && theValue != '' && !isEmail(theValue))
					{	
						if (!started) {
						started=true;
						startAt=prop;
						}
						
						errors += getValidationMessage(theField,' must be a valid email address.');
						
					}
			
					else if(validationType=='NUMERIC' && isNaN(theValue))
					{	
						if(!isNaN(theValue.replace(/\$|\,|\%/g,'')))
						{
							theField.html(theValue.replace(/\$|\,|\%/g,''));
			
						} else {
							if (!started) {
							started=true;
							startAt=prop;
							}
							
							errors += getValidationMessage(theField,' must be numeric.');
						}			
					}
					
					else if(validationType=='REGEX' && theValue !='' && hasValidationRegex(theField))
					{	
						var re = new RegExp(getValidationRegex(theField));
						if(!theValue.match(re))
						{
							if (!started) {
							started=true;
							startAt=prop;
							}
						
							 errors += getValidationMessage(theField,' is not valid.');
						}			
					}

					else if(validationType=='DATE' && theValue != '' && !isDate(theValue))
					{
						if (!started) {
						started=true;
						startAt=prop;
						}
						
						errors += getValidationMessage(theField, ' must be a valid date [MM/DD/YYYY].' );
						 
					}
				}
					
					}
				
				if(errors != ""){	
					alert(errors);
					//muraInlineEditor.attributes[startAt].focus();
					return false;
				}
				else
				{
					return true;
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
			action: 'add',
			ajaxrequest: true,
			siteid: '#JSStringFormat(node.getSiteID())#',
			sourceid: '#JSStringFormat(node.getContentHistID())#',
			contentid: '#JSStringFormat(node.getContentID())#',
			parentid: '#JSStringFormat(node.getParentID())#',
			moduleid: '#JSStringFormat(node.getModuleID())#',
			approved: 0,
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

</cfif>
</cfif>
