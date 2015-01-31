<cfcontent reset="yes" type="application/javascript">
<cfscript>
	if(server.coldfusion.productname != 'ColdFusion Server'){
		backportdir='';
		include "/mura/backport/backport.cfm";
	} else {
		backportdir='/mura/backport/';
		include "#backportdir#backport.cfm";
	}
</cfscript>
<cfif isDefined("url.siteID")>
<cfset isIeSix=FindNoCase('MSIE 6','#CGI.HTTP_USER_AGENT#') GREATER THAN 0>
<cfset $=application.serviceFactory.getBean("MuraScope").init(url.siteID)>
<cfparam name="session.siteid" default="#url.siteid#">
<cfif not structKeyExists(session,"rb")>
	<cfset application.rbFactory.resetSessionLocale()>
</cfif>
<cfparam name="Cookie.fetDisplay" default="">
<cfoutput>
	var adminProxy;
	var adminDomain=<cfif len($.globalConfig('admindomain'))>"#$.globalConfig('admindomain')#"<cfelse>location.hostname</cfif>;
	var adminProtocal=<cfif application.configBean.getAdminSSL() or application.utility.isHTTPS()>"https://";<cfelse>"http://"</cfif>;
	var adminProxyLoc=adminProtocal + adminDomain + "#$.globalConfig('serverPort')##$.globalConfig('context')#/admin/assets/js/porthole/proxy.html";
	var adminLoc=adminProtocal + adminDomain + "#$.globalConfig('serverPort')##$.globalConfig('context')#/admin/";
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
			} else if(parameters["cmd"] == "close"){
				closeFrontEndToolsModal();
			} else if(parameters["cmd"] == "setLocation"){
				window.location=decodeURIComponent(parameters["location"]);
			} else if(parameters["cmd"] == "setHeight"){
				resizeFrontEndToolsModal(decodeURIComponent(parameters["height"]));
			} else if(parameters["cmd"] == "autoScroll"){
				autoScroll(parameters["y"]);
			}
		}			
	}

	function initAdminProxy(){
			adminProxy = new Porthole.WindowProxy(adminProxyLoc, 'frontEndToolsModaliframe');
			adminProxy.addEventListener(onAdminMessage);
	}
	
	var frontEndModalWidthStandard=990;
	var frontEndModalWidthConfigurator=600;
	var frontEndModalHeight=0;
	var frontEndModalWidth=0;
	var frontEndModalIE8=document.all && document.querySelector && !document.addEventListener;
	
	function autoScroll(y){
		var st = $(window).scrollTop();
	    var o = $('##frontEndToolsModalBody').offset().top;
	    var t = $(window).scrollTop() + 80;
	    var b = $(window).height() - 50 + $(window).scrollTop();
	    var adjY = y + o;

		if (adjY > b) {
	        //Down
	        scrollTop(adjY, st + 35);
		} else if (adjY < t) {
	        //Up
	        scrollTop(adjY, st - 35);
	    }
	}

	function scrollTop(y, top){
		$('html, body').stop().animate({
	        'scrollTop': top
	    }, 50);
	}

	function openFrontEndToolsModal(a){
		var src=a.href;
		var isModal=jQuery(a).attr("data-configurator");
		var width=jQuery(a).attr("data-modal-width");
		var ispreview=jQuery(a).attr("data-modal-preview");

		frontEndModalHeight=0;
		frontEndModalWidth=0;
		
		if(jQuery.isNumeric(width)){
			frontEndModalWidth = width;
		}

		closeFrontEndToolsModal();
		
		if(ispreview){
			if(src.indexOf("?") == -1) {
				src = src + '?muraadminpreview';
			} else {
				src = src + '&muraadminpreview';
			}

			frontEndModalHeight=600;
			frontEndModalWidth=1075;

			var $tools='<div id="mura-preview-device-selector">';
				$tools=$tools+'<p>Preview Mode</p>';
				$tools=$tools+'<a class="mura-device-standard active" title="Desktop" data-height="600" data-width="1075" data-mobileformat="false"><i class="icon-desktop"></i></a>';
				$tools=$tools+'<a class="mura-device-tablet" title="Tablet" data-height="600" data-width="768" data-mobileformat="false"><i class="icon-tablet"></i></a>';
				$tools=$tools+'<a class="mura-device-tablet-landscape" title="Tablet Landscape" data-height="480" data-width="1024" data-mobileformat="false"><i class="icon-tablet icon-rotate-270"></i></a>';
				$tools=$tools+'<a class="mura-device-phone" title="Phone" data-height="480" data-width="320" data-mobileformat="true"><i class="icon-mobile-phone"></i></a>';
				$tools=$tools+'<a class="mura-device-phone-landscape" title="Phone Landscape" data-height="250" data-width="520" data-mobileformat="true"><i class="icon-mobile-phone icon-rotate-270"></i></a>';
				$tools=$tools+'<a id="preview-close" title="Close" href="##" onclick="closeFrontEndToolsModal();"><i class="icon-remove-sign"></i></a>';
				$tools=$tools+'</div>';

		} else {
			if(!frontEndModalHeight){
				if (isModal == undefined) {
					frontEndModalWidth = frontEndModalWidthStandard;
				} else if (isModal == "true") {
					frontEndModalWidth=frontEndModalWidthConfigurator;
				} else {
					frontEndModalWidth = frontEndModalWidthStandard;
				}
			}

			src=src + "&frontEndProxyLoc=" + frontEndProxyLoc;
			var $tools='';
		}


		jQuery("##frontEndToolsModalTarget").html('<div id="frontEndToolsModalContainer">' +
		'<div id="frontEndToolsModalBody">' + $tools +
		'<iframe src="' + src + '" id="frontEndToolsModaliframe" scrolling="false" frameborder="0" style="overflow:hidden" name="frontEndToolsModaliframe"></iframe>' +
		'</div>' +
		'</div>');
		
		if(ispreview){
			$('##mura-preview-device-selector a').bind('click', function () {
				var data=$(this).data();

				frontEndModalWidth=data.width;
			   	frontEndModalHeight=data.height;

			   	$('##frontEndToolsModaliframe').attr('src',src + '&mobileFormat=' + data.mobileformat);
			    $('##mura-preview-device-selector a').removeClass('active');
			    $(this).addClass('active');

			    resizeFrontEndToolsModal(data.height);
			    return false;
			});

			jQuery("##frontEndToolsModalBody").css("top",($(document).scrollTop()+80) + "px")
			resizeFrontEndToolsModal(frontEndModalHeight);
		} else{
			frontEndModalHeight=0;
			jQuery("##frontEndToolsModalBody").css("top",($(document).scrollTop()+50) + "px")
			resizeFrontEndToolsModal(0);
			}

		
		
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

	function resizeEditableObject(target){
		
		var display="inline";	
		var width=0;
		var float;

		jQuery(target).find(".editableObjectContents").each(
			function(){
				jQuery(this).find(".frontEndToolsModal").each(
					function(){
						jQuery(this).click(function(event){
							event.preventDefault();
							openFrontEndToolsModal(this);
						}
					);
				});
					
				jQuery(this).children().each(
					function(el){			
						if ($(this).css("display") == "block") {
							display = "block";
							float=$(this).css("float");
							width=$(this).outerWidth();
						}											
					}	
				);
					
				jQuery(this).css("display",display).parent().css("display",display);
					
				if(width){
					jQuery(this).width(width).parent().width(width);
					jQuery(this).css("float",float).parent().css("float",float);
				}

		});

		if($('HTML').hasClass('mura-edit-mode')){
			$(target).removeClass('editableObjectHide');
		} else {
			$(target).addClass('editableObjectHide');
		}
		
	}

	jQuery(document).ready(		
		function(){

			checkToolbarDisplay();

			jQuery(".frontEndToolsModal").each(
				function(){
					jQuery(this).click(function(event){
						event.preventDefault();
						openFrontEndToolsModal(this);
					}
				);
			});

			jQuery(".editableObject").each(function(){
				resizeEditableObject(this);
			});
			
			initAdminProxy();
			
			if(frontEndModalIE8){
				$("##adminQuickEdit").remove();
			}
		}
	);

	$(window).resize(function() {
  		jQuery(".editableObjectContents").each(function(){
				resizeEditableObject(this);
		});
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

			<cfif $.siteConfig('hasLockableNodes')>
				<cfset stats=node.getStats()>
				<cfif stats.getLockType() eq 'node' and stats.getLockID() neq session.mura.userid>
					alert('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"sitemanager.draftprompt.contentislockedbyanotheruser"))#');
					return false;
				</cfif>
			</cfif>
			if(muraInlineEditor.inited){
				return false;
			}

			CKEDITOR.disableAutoInline=true;
			muraInlineEditor.inited=true;
			$('##adminSave').show();
			$('##adminStatus').hide();		
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
							toolbar: 'QuickEdit',
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
						if(confirm('#esapiEncode('javascript',application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.removechangeset"),application.changesetManager.read(node.getChangesetID()).getName()))#')){
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
			try{
				muraInlineEditor.validate(
					function(){
						var count=0;
						for (var prop in muraInlineEditor.attributes) {
							var attribute=$(muraInlineEditor.attributes[prop]).attr('data-attribute');
							muraInlineEditor.data[attribute]=muraInlineEditor.getAttributeValue(attribute);
							count++;
						}

						if(count){
							if(muraInlineEditor.data.approvalstatus=='Pending'){
								if(confirm('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"approvalchains.cancelPendingApproval"))#')){
									muraInlineEditor.data.cancelpendingapproval=true;
								} else {
									muraInlineEditor.data.cancelpendingapproval=false;
								}

							}

							$.ajax({ 
					        type: "POST",
					        <cfif yesNoFormat($.globalConfig('accesscontrolcredentials'))>
					        xhrFields: { withCredentials: true },
					        </cfif>
					       	<cfif yesNoFormat($.globalConfig('accesscontrolheaders'))>
					        crossDomain:true,
					     	</cfif>
					        url: adminLoc,
					        data: muraInlineEditor.data,
					        success: function(data){
						        var resp = eval('(' + data + ')');
						        location.href=resp.location;
					        }
					       });
						} else {
							location.reload();
						}
					}
				);
			} catch(err){
				alert("An error has occurred, please check your browser console for more information."); 
				console.log(err);
			}

			return false;		
		},
		stripHTML: function(html){
			var tmp = document.createElement("DIV");
			tmp.innerHTML = html;
			return tmp.textContent||tmp.innerText;
		},
		validate: function(callback){

				if(!mura.apiEndpoint){
					mura.apiEndpoint=mura.context + '/index.cfm/_api/json/v1/';
				}

				var getValidationFieldName=function(theField){
					if(theField.getAttribute('data-label')!=undefined){
						return theField.getAttribute('data-label');
					}else if(theField.getAttribute('label')!=undefined){
						return theField.getAttribute('label');
					}else{
						return theField.getAttribute('name');
					}
				}

				var getValidationIsRequired=function(theField){
					if(theField.getAttribute('data-required')!=undefined){
						return (theField.getAttribute('data-required').toLowerCase() =='true');
					}else if(theField.getAttribute('required')!=undefined){
						return (theField.getAttribute('required').toLowerCase() =='true');
					}else{
						return false;
					}
				}

				var getValidationMessage=function(theField, defaultMessage){
					if(theField.getAttribute('data-message') != undefined){
						return theField.getAttribute('data-message');
					} else if(theField.getAttribute('message') != undefined){
						return theField.getAttribute('message') ;
					} else {
						return getValidationFieldName(theField).toUpperCase() + defaultMessage;
					}	
				}

				var getValidationType=function(theField){
					if(theField.getAttribute('data-validate')!=undefined){
						return theField.getAttribute('data-validate').toUpperCase();
					}else if(theField.getAttribute('validate')!=undefined){
						return theField.getAttribute('validate').toUpperCase();
					}else{
						return '';
					}
				}

				var hasValidationMatchField=function(theField){
					if(theField.getAttribute('data-matchfield')!=undefined && theField.getAttribute('data-matchfield') != ''){
						return true;
					}else if(theField.getAttribute('matchfield')!=undefined && theField.getAttribute('matchfield') != ''){
						return true;
					}else{
						return false;
					}
				}

				var getValidationMatchField=function (theField){
					if(theField.getAttribute('data-matchfield')!=undefined){
						return theField.getAttribute('data-matchfield');
					}else if(theField.getAttribute('matchfield')!=undefined){
						return theField.getAttribute('matchfield');
					}else{
						return '';
					}
				}

				var hasValidationRegex=function(theField){
					if(theField.value != undefined){
						if(theField.getAttribute('data-regex')!=undefined && theField.getAttribute('data-regex') != ''){
							return true;
						}else if(theField.getAttribute('regex')!=undefined && theField.getAttribute('regex') != ''){
							return true;
						}
					}else{
						return false;
					}
				}

				var getValidationRegex=function(theField){
					if(theField.getAttribute('data-regex')!=undefined){
						return theField.getAttribute('data-regex');
					}else if(theField.getAttribute('regex')!=undefined){
						return theField.getAttribute('regex');
					}else{
						return '';
					}
				}

				var data={};
				var $callback=callback;

				for (var prop in muraInlineEditor.attributes) {
					data[prop]=muraInlineEditor.getAttributeValue(prop);
				}

				var errors="";
                var setFocus=0;
                var started=false;
                var startAt;
                var firstErrorNode;
                var validationType='';
                var validations={properties:{}};
                var rules=new Array();

                for (var prop in muraInlineEditor.attributes) {
                	theField=muraInlineEditor.attributes[prop];
                    validationType=getValidationType(theField).toUpperCase();;
                    theValue=muraInlineEditor.getAttributeValue(prop);
		
					rules=new Array();
					
					if(getValidationIsRequired(theField))
						{	
							rules.push({
								required: true,
								message: getValidationMessage(theField,' is required.')
							});
							
							 			
						}
					if(validationType != ''){
							
						if(validationType=='EMAIL' && theValue != '')
						{	
								rules.push({
									dataType: 'EMAIL',
									message: getValidationMessage(theField,' must be a valid email address.')
								});
								
										
						}
		
						else if(validationType=='NUMERIC')
						{	
								rules.push({
									dataType: 'NUMERIC',
									message: getValidationMessage(theField,' must be numeric.')
								});
											
						}
						
						else if(validationType=='REGEX' && theValue !='' && hasValidationRegex(theField))
						{	
								rules.push({
									regex: hasValidationRegex(theField),
									message: getValidationMessage(theField,' is not valid.')
								});
												
						}
						
						else if(validationType=='MATCH' 
								&& hasValidationMatchField(theField) && theValue != theForm[getValidationMatchField(theField)].value)
						{	
							rules.push({
								eq: theForm[getValidationMatchField(theField)].value,
								message: getValidationMessage(theField, ' must match' + getValidationMatchField(theField) + '.' )
							});
										
						}
						
						else if(validationType=='DATE' && theValue != '')
						{
							rules.push({
								dataType: 'DATE',
								message: getValidationMessage(theField, ' must be a valid date [MM/DD/YYYY].' )
							});
							 
						}
					}
					
					if(rules.length){
						validations.properties[prop]=rules;
					}
				}

				try{
					//alert(JSON.stringify(validations))
					$.ajax(
						{
							type: 'post',
							url: mura.apiEndpoint + 'validate/',
							data: {
									data: JSON.stringify($.extend(muraInlineEditor.data,data)),
									validations: JSON.stringify(validations)
								},
							success: function(resp) {
								if(typeof resp != 'object'){
									resp=data=eval('(' + resp + ')');
								}
		 				 		data=resp.data;

		 				 		if($.isEmptyObject(data)){
		 				 			$callback();
		 				 		} else {
			 				 		var msg='';
			 				 		for(var e in data){
			 				 			msg=msg + data[e] + '\n';
			 				 		}

			 				 		alert(msg);

			 				 		return false;
		 				 		}
							},
							error: function(resp) {
		 				 		
		 				 		alert(JSON.stringify(resp));
							}

						}		 
					);
				} 
				catch(err){ 
					console.log(err);

				}

				return false;

		},
		htmlEditorOnComplete: function(editorInstance) {
			var instance = $(editorInstance).ckeditorGet();
			instance.resetDirty();
			var totalInstances = CKEDITOR.instances;
			CKFinder.setupCKEditor(
			instance, {
				basePath: '#application.configBean.getContext()#/requirements/ckfinder/',
				rememberLastFolder: false
			});
		},
		<cfset csrfTokens=$.generateCSRFTokens(context=node.getContentHistID() & 'add')>
		data:{
			muraaction: 'carch.update',
			action: 'add',
			ajaxrequest: true,
			siteid: '#esapiEncode('javascript',node.getSiteID())#',
			contenthistid: '#esapiEncode('javascript',node.getContentHistID())#',
			contentid: '#esapiEncode('javascript',node.getContentID())#',
			parentid: '#esapiEncode('javascript',node.getParentID())#',
			moduleid: '#esapiEncode('javascript',node.getModuleID())#',
			approved: 0,
			changesetid: '',
			bean: 'content',
			loadby: 'contenthistid',
			approvalstatus: '#esapiEncode('javascript',node.getApprovalStatus())#',
			csrf_token: '#csrfTokens.token#',
			csrf_token_expires: '#csrfTokens.expires#'
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
				writeOutput("'#esapiEncode('javascript',lcase(attribute))#':'#esapiEncode('javascript',trim(nodeCollection[attribute]))#'");
				started=true;
			}
		</cfscript>
		}
	};

</cfif>
</cfif>