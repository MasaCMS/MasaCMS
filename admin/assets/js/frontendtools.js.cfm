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
<cfcontent reset="true"><cfparam name="Cookie.fetDisplay" default=""><cfoutput>(function(){	
	var utility=jQuery;

	var adminProxy;
	var adminDomain=<cfif len($.globalConfig('admindomain'))>"#$.globalConfig('admindomain')#"<cfelse>location.hostname</cfif>;
	var adminProtocal=<cfif application.configBean.getAdminSSL() or application.utility.isHTTPS()>"https://";<cfelse>"http://"</cfif>;
	var adminProxyLoc=adminProtocal + adminDomain + "#$.globalConfig('serverPort')##$.globalConfig('context')#/admin/assets/js/porthole/proxy.html";
	var adminLoc=adminProtocal + adminDomain + "#$.globalConfig('serverPort')##$.globalConfig('context')#/admin/";
	var frontEndProxyLoc= location.protocol + "//" + location.hostname + "#$.globalConfig('serverPort')#";

	var onAdminMessage=function(messageEvent){

		if (messageEvent.origin == 'http://' + adminDomain + "#$.globalConfig('serverPort')#"
			|| messageEvent.origin == 'https://' + adminDomain + "#$.globalConfig('serverPort')#") {
			
			var parameters=messageEvent.data;
			
			if (parameters["cmd"] == "setWidth") {			
				if(parameters["width"]=='configurator'){
					frontEndModalWidth=frontEndModalWidthConfigurator;
				} else if(!isNaN(parameters["width"])){
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

	initAdminProxy=function(){
			adminProxy = new Porthole.WindowProxy(adminProxyLoc, 'frontEndToolsModaliframe');
			adminProxy.addEventListener(onAdminMessage);
	}

	var frontEndModalWidthStandard=990;
	var frontEndModalWidthConfigurator=600;
	var frontEndModalHeight=0;
	var frontEndModalWidth=0;
	var frontEndModalIE8=document.all && document.querySelector && !document.addEventListener;

	var autoScroll=function(y){
		var st = utility(window).scrollTop();
	    var o = utility('##frontEndToolsModalBody').offset().top;
	    var t = utility(window).scrollTop() + 80;
	    var b = utility(window).height() - 50 + utility(window).scrollTop();
	    var adjY = y + o;

		if (adjY > b) {
	        //Down
	        scrollTop(adjY, st + 35);
		} else if (adjY < t) {
	        //Up
	        scrollTop(adjY, st - 35);
	    }
	}

	var scrollTop=function(y, top){
		utility('html, body').each(function(el){
			el.scrolltop=top;
		});
	}

	var openFrontEndToolsModal=function(a){
		var src=a.href;
		var isModal=utility(a).attr("data-configurator");
		var width=utility(a).attr("data-modal-width");
		var ispreview=utility(a).attr("data-modal-preview");

		frontEndModalHeight=0;
		frontEndModalWidth=0;
		
		if(!isNaN(width)){
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


		utility("##frontEndToolsModalTarget").html('<div id="frontEndToolsModalContainer">' +
		'<div id="frontEndToolsModalBody">' + $tools +
		'<iframe src="' + src + '" id="frontEndToolsModaliframe" scrolling="false" frameborder="0" style="overflow:hidden" name="frontEndToolsModaliframe"></iframe>' +
		'</div>' +
		'</div>');
		
		if(ispreview){
			utility('##mura-preview-device-selector a').on('click', function () {
				var data=utility(this).data();

				frontEndModalWidth=data.width;
			   	frontEndModalHeight=data.height;

			   	utility('##frontEndToolsModaliframe').attr('src',src + '&mobileFormat=' + data.mobileformat);
			    utility('##mura-preview-device-selector a').removeClass('active');
			    utility(this).addClass('active');

			    resizeFrontEndToolsModal(data.height);
			    return false;
			});

			utility("##frontEndToolsModalBody").css("top",(utility(document).scrollTop()+80) + "px")
			resizeFrontEndToolsModal(frontEndModalHeight);
		} else{
			frontEndModalHeight=0;
			utility("##frontEndToolsModalBody").css("top",(utility(document).scrollTop()+50) + "px")
			resizeFrontEndToolsModal(0);
		}
	}

	var resizeFrontEndToolsModal=function(frameHeight){
		if (document.getElementById("frontEndToolsModaliframe")) {
			var frame = document.getElementById("frontEndToolsModaliframe");
			var frameContainer = document.getElementById("frontEndToolsModalContainer");
			
			//if (frameDoc.body != null) {
				var windowHeight = Math.max(frameHeight, utility(window).height());
		
				if (frontEndModalWidth==frontEndModalWidthStandard 
					&& frameHeight < utility(window).height()
					) {
					frameHeight= Math.max(utility(window).height() * .80,frameHeight);
				}

				utility('##frontEndToolsModalContainer ##frontEndToolsModalBody,##frontEndToolsModalContainer ##frontEndToolsModaliframe').width(frontEndModalWidth);
				
				frame.style.height = frameHeight + "px";
				frameContainer.style.position = "absolute";
				document.overflow = "auto"
				
				
				if(windowHeight > frontEndModalHeight){	
					frontEndModalHeight=windowHeight;
					if(frontEndModalIE8){
						frameContainer.style.height=Math.max(frameHeight,utility(document).height()) + "px";
					} else {
						frameContainer.style.height=utility(document).height() + "px";
					}
					setTimeout(function(){
						utility("##frontEndToolsModalClose").fadeIn("fast")
					},1000);			
				}
				
				
			//}
			//setTimeout(resizeFrontEndToolsModal, 250);
		}
		
	}

	var closeFrontEndToolsModal=function(){
		utility('##frontEndToolsModalContainer').remove();
	}	

	var checkToolbarDisplay=function() {
	<cfif Cookie.fetDisplay eq "none">
		utility('HTML').removeClass('mura-edit-mode');
		utility(".editableObject").addClass('editableObjectHide');
	<cfelse>
		utility('HTML').addClass('mura-edit-mode');
	</cfif>
	}

	var toggleAdminToolbar=function(){
		var tools=utility("##frontEndTools");
		if(typeof tools.animate == 'function'){
			utility("##frontEndTools").animate({opacity: "toggle"});
		} else {
			tools.toggle();
		}
		utility('HTML').toggleClass('mura-edit-mode');
		utility(".editableObject").toggleClass('editableObjectHide');
			
		if(typeof muraInlineEditor != 'undefined' && muraInlineEditor.inited){
			utility(".mura-editable").toggleClass('inactive');
		}
	}

	var resizeEditableObject=function(target){
		
		var display="inline";	
		var width=0;
		var float;

		utility(target).find(".editableObjectContents").each(
			function(){
				utility(this).find(".frontEndToolsModal").each(
					function(){
						utility(this).click(function(event){
							event.preventDefault();
							openFrontEndToolsModal(this);
						}
					);
				});
					
				utility(this).children().each(
					function(el){			
						if (utility(this).css("display") == "block") {
							display = "block";
							float=utility(this).css("float");
							width=utility(this).outerWidth();
						}											
					}	
				);
					
				utility(this).css("display",display).parent().css("display",display);
					
				if(width){
					utility(this).width(width).parent().width(width);
					utility(this).css("float",float).parent().css("float",float);
				}

		});

		if(utility('HTML').hasClass('mura-edit-mode')){
			utility(target).removeClass('editableObjectHide');
		} else {
			utility(target).addClass('editableObjectHide');
		}
		
	}

	utility(document).ready(		
		function(){

			checkToolbarDisplay();

			utility(".frontEndToolsModal").each(
				function(el){
					
					utility(this).on('click',function(event){
						event.preventDefault();
						openFrontEndToolsModal(this);
					}
				);
			});

			utility(".editableObject").each(function(){
				resizeEditableObject(this);
			});
			
			initAdminProxy();
			
			if(frontEndModalIE8){
				utility("##adminQuickEdit").remove();
			}
		}
	);
	/*
	utility(window).resize(function() {
			utility(".editableObjectContents").each(function(){
				resizeEditableObject(this);
		});
	});
	*/
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
			utility('##adminSave').show();
			utility('##adminStatus').hide();		
			utility('.mura-editable').removeClass('inactive');

			utility('.mura-editable-attribute').each(
			function(){
				var attribute=utility(this);
				var attributename=attribute.attr('data-attribute').toLowerCase();

				attribute.attr('contenteditable','true');
				attribute.attr('title','');

				utility(this).unbind('dblclick');

				utility(this).click(
					function(){
						var attributename=this.getAttribute('data-attribute').toLowerCase();
						
						if(!(attributename in muraInlineEditor.attributes)){
							if(attributename in muraInlineEditor.preprocessed){
								this.innerHtml=muraInlineEditor.preprocessed[attributename];
							}
							

							muraInlineEditor.attributes[attributename]=this;
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
							if(utility('##adminSave').css('display') == 'none'){
								utility('##adminSave').fadeIn();	
							}
						});
					}
								
				}
			});

			utility('.mura-inline-save').click(function(){
				var changesetid=utility(this).attr('data-changesetid');

				if(changesetid == ''){
					//alert(1 + " " + utility(this).attr('data-approved'))
					muraInlineEditor.data.approved=utility(this).attr('data-approved');
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

			utility('.mura-inline-cancel').click(function(){
				location.reload();
			});

			//clean instances
			for (var instance in CKEDITOR.instances) {
				if(!utility('##' + instance).length){
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
				return muraInlineEditor.stripHTML(muraInlineEditor.attributes[attribute].innerHTML.trim());
			}
		},
		save:function(){
			try{
				muraInlineEditor.validate(
					function(){
						var count=0;
						for (var prop in muraInlineEditor.attributes) {
							var attribute=muraInlineEditor.attributes[prop].getAttribute('data-attribute');
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

							utility.ajax({ 
					        type: "POST",
					        xhrFields: { withCredentials: true },
					        crossDomain:true,
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
				utility.ajax(
					{
						type: 'post',
						url: mura.apiEndpoint + 'validate/',
						data: {
								data: JSON.stringify(utility.extend(muraInlineEditor.data,data)),
								validations: JSON.stringify(validations)
							},
						success: function(resp) {
							if(typeof resp != 'object'){
								resp=data=eval('(' + resp + ')');
							}
						 		data=resp.data;

						 		if(utility.isEmptyObject(data)){
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
			var instance = utility(editorInstance).ckeditorGet();
			instance.resetDirty();
			var totalInstances = CKEDITOR.instances;
			CKFinder.setupCKEditor(
			instance, {
				basePath: '#application.configBean.getContext()#/requirements/ckfinder/',
				rememberLastFolder: true
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
			if(isSimpleValue(nodeCollection[attribute]) and reFindNoCase("(\{{|\[sava\]|\[mura\]|\[m\]).+?(\[/sava\]|\[/mura\]|}}|\[/m\])",nodeCollection[attribute])){
				if(started){writeOutput(",");}
				writeOutput("'#esapiEncode('javascript',lcase(attribute))#':'#esapiEncode('javascript',trim(nodeCollection[attribute]))#'");
				started=true;
			}
		</cfscript>
		}
	};
	window.muraInlineEditor=muraInlineEditor;
	</cfif>
	</cfif>
	window.toggleAdminToolbar=toggleAdminToolbar;
	window.closeFrontEndToolsModal=closeFrontEndToolsModal;
})();