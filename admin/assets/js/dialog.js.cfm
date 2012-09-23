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
	var adminProxyLoc=adminProtocal + adminDomain + "#$.globalConfig('serverPort')##$.globalConfig('context')#/admin/js/porthole/proxy.html";
	var frontEndProxyLoc= location.protocol + "//" + location.hostname + "#$.globalConfig('serverPort')#";
	
	function onAdminMessage(messageEvent){
		if (messageEvent.origin == adminProtocal + adminDomain + "#$.globalConfig('serverPort')#") {
			
			var parameters = Porthole.WindowProxy.splitMessageParameters(messageEvent.data);
			
			if (parameters["cmd"] == "setWindowMode") {			
				if(parameters["mode"]=='configurator'){
					frontEndModalWidth=frontEndModalWidthConfigurator;
				} else {
					frontEndModalWidth=frontEndModalWidthStandard;
				}
				resizeFrontEndToolsModal();	
			} else if(parameters["cmd"] == "resizeWindow") {			
				
				if(jQuery.isNumeric(parameters["width"])){
					frontEndModalWidth=parameters["width"];
				}
				if(jQuery.isNumeric(parameters["height"])){
					frontEndModalHeight=parameters["height"];
				}

				resizeFrontEndToolsModal();	
			} else if(parameters["cmd"] == "setLocation"){
				window.location=decodeURIComponent(parameters["location"]);
			} else if(parameters["cmd"] == "resizeFrontEndToolsModal"){
				resizeFrontEndToolsModal(decodeURIComponent(parameters["frameHeight"]));
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
		var width=jQuery(a).attr("data-configurator-width");
		var height=jQuery(a).attr("data-configurator-height");
		
		if(jQuery.isNumeric(width)){
			frontEndModalWidth = width;
		}
		if(jQuery.isNumeric(height)){
			frontEndModalHeight = height;
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
	
<cfif not isIeSix>
	function toggleAdminToolbar(){
		<cfif $.getJsLib() eq "jquery">
			$("##frontEndTools").animate({opacity: "toggle"});
			
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
