<cfif not isdefined('$')>
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
	<cfset $=application.serviceFactory.getBean("MuraScope").init(url.siteID)>
	<cfparam name="session.siteid" default="#url.siteid#">
	<cfif not structKeyExists(session,"rb")>
		<cfset application.rbFactory.resetSessionLocale()>
	</cfif>
	<cfcontent reset="true"><cfparam name="Cookie.fetDisplay" default="">
	</cfif>
	<cfoutput>(function(window){
		window.Mura=window.Mura || window.mura || {};
		window.Mura.layoutmanager=#$.getContentRenderer().useLayoutManager()#;
	
		var utility=Mura;
	
		var adminProxy;
	
		<cfif len($.globalConfig('admindomain'))>
			var adminDomain="#$.globalConfig('admindomain')#";
		<cfelseif $.siteConfig().getValue('isRemote')>
			var adminDomain="#$.siteConfig().getValue('resourceDomain')#";
		<cfelse>
			var adminDomain="";
		</cfif>
	
		<cfif len($.globalConfig('admindomain')) or $.event('contenttype') eq 'variation' or ($.siteConfig('isRemote') and len($.siteConfig().getValue('resourceDomain')))>
			var adminProxyLoc="#$.siteConfig().getAdminPath(complete=1)#/assets/js/porthole/proxy.html?cacheid=" + Math.random();
			var adminLoc="#$.siteConfig().getAdminPath(complete=1)#/";
			var coreLoc="#$.siteConfig().getCorePath(complete=1)#/";
			var resourceLoc="#$.siteConfig().getResourcePath(complete=1)#/";
			var frontEndProxyLoc= location.protocol + "//" + location.hostname;
	
			if(location.port){
				frontEndProxyLoc+=':' + location.port;
			}
		<cfelse>
			var adminProxyLoc="#$.globalConfig('context')##$.globalConfig('adminDir')#/assets/js/porthole/proxy.html?cacheid=" + Math.random();
			var adminLoc="#$.globalConfig('context')##$.globalConfig('adminDir')#/";
			var coreLoc="#$.globalConfig('context')#/core/";
			var resourceLoc="#$.globalConfig('context')#/";
			var frontEndProxyLoc="";
		</cfif>
		var instanceid=Mura.createUUID();
	
		var onAdminMessage=function(messageEvent){
			//console.log(messageEvent)
			if (
				<cfif len($.globalConfig('admindomain'))>
					messageEvent.origin == 'http://' + adminDomain + "#$.globalConfig('serverPort')#"
					|| messageEvent.origin == 'https://' + adminDomain + "#$.globalConfig('serverPort')#"
				<cfelse>
					true
				</cfif>) {
	
				var parameters=messageEvent.data;
	
				if (parameters["cmd"] == "setWidth") {
					if(parameters["width"]=='configurator'){
						frontEndModalWidth=frontEndModalWidthConfigurator;
					} else if(!isNaN(parameters["width"])){
						frontEndModalWidth=parameters["width"];
					} else {
						frontEndModalWidth=getConfiguratorWidth();
					}
	
					if(parameters["targetFrame"]=='sidebar'){
						resizeFrontEndToolsSidebar(decodeURIComponent(parameters["height"]));
					} else {
						resizeFrontEndToolsModal(decodeURIComponent(parameters["height"]));
					}
				} else if(parameters["cmd"] == "openFileManager"){
						Mura.loader().loadjs(
						coreLoc +'vendor/ckfinder/ckfinder.js',
							function(){
								var target=parameters["target"];
								var finder = new CKFinder();
								finder.basePath = coreLoc + 'vendor/ckfinder/';
	
								<cfif $.siteConfig('isremote')>
									var completepath="true";
								<cfelse>
									var completepath=(typeof parameters["completepath"] != 'undefined') ? parameters.completepath.toString() : "true";
								</cfif>
	
								finder.selectActionFunction=function(fileURL){
	
									var item=Mura('[data-instanceid="' + parameters["instanceid"] + '"]');
	
									if(completepath.toString().toLowerCase() == 'true'){
										item.data(parameters["target"],webroot + fileDelim + fileURL)
									} else {
										item.data(parameters["target"],fileURL)
									}
	
									var data=item.data();
	
									delete data.runtime;
	
									if(item.is('div.mura-body-object,div.mura-object[data-targetattr]')){
										data.hasTargetAttr=true;
									}
	
									if(parameters["targetFrame"]=='sidebar' && document.getElementById('mura-sidebar-editor').style.display=='none'){
										Mura('##mura-sidebar-configurator').show();
									}
	
									if(typeof parameters.callback == 'undefined'){
										if(typeof parameters["targetFrame"] != 'undefined' && parameters["targetFrame"].toLowerCase()=='sidebar'){
											sidebarProxy.post({cmd:'setObjectParams',params:data});
										} else {
											modalProxy.post({cmd:'setObjectParams',params:data});
										}
									}
	
									Mura.processAsyncObject(item.node);
							}
	
							if(Mura(this).attr('data-resourcetype') =='root'){
								finder.resourceType='Application_Root';
							} else if(Mura(this).attr('data-resourcetype') == 'site'){
								finder.resourceType=Mura.siteid + '_Site_Files';
							} else {
								finder.resourceType=Mura.siteid + '_User_Assets';
							}
	
							finder.popup();
						}
					);
				} else if(parameters["cmd"] == "close"){
					closeFrontEndToolsModal();
	
				} else if(parameters["cmd"] == "cloneobject"){
					var source=Mura('div[data-instanceid="' + parameters["instanceid"] + '"]');
	
					if(source.data('object') == 'container'){
						Mura.resetAsyncObject(source.node);
						Mura.processDisplayObject(source,false,true);
					}
	
					var newinstanceid=Mura.createUUID();
					var newparams=Mura.extend(source.data(),{instanceid:newinstanceid,stylesupport:source.attr('data-stylesupport')})
					delete newparams.inited;
					newparams.transient=false;
					source.insertDisplayObjectAfter(newparams)
						.then(function(obj){
							obj.on('click',Mura.handleObjectClick);
							initFrontendUI(obj.node,true);
						});
	
				} else if(parameters["cmd"] == "setLocation"){
					var newLocation=decodeURIComponent(parameters["location"]);
					window.location=newLocation;
					if(newLocation.indexOf('##') > -1){
						MuraInlineEditor.reload();
					}
				} else if(parameters["cmd"] == "setHeight"){
					if(parameters["targetFrame"]=='sidebar'){
						resizeFrontEndToolsSidebar(decodeURIComponent(parameters["height"]));
					} else {
						resizeFrontEndToolsModal(decodeURIComponent(parameters["height"]));
					}
				} else if(parameters["cmd"] == "scrollToTop"){
					window.scrollTo(0, 0);
				} else if(parameters["cmd"] == "autoScroll"){
					autoScroll(parameters["y"]);
				} else if(parameters["cmd"] == "setCurrentPanel"){
					var item=Mura('[data-instanceid="' + parameters["instanceid"] + '"]');
					Mura(".mura-object-content,.mura-object-meta").removeClass('mura-object-selected')
					if(parameters["currentPanel"]=='content'){
						item.children('.mura-object-content').addClass('mura-object-selected');
					}	if(parameters["currentPanel"]=='meta'){
						var metaWrapper=item.children('.mura-object-meta-wrapper');
						if(metaWrapper.length){
							metaWrapper.children('.mura-object-meta').addClass('mura-object-selected');
						}
					}
				} else if(parameters["cmd"] == "requestObjectParams"){
					var item=Mura('[data-instanceid="' + parameters["instanceid"] + '"]');
					var data=item.data();
	
					delete data.runtime;
	
					if(item.is('div.mura-body-object,div.mura-object[data-targetattr]')){
						data.hasTargetAttr=true;
					}
	
					if(parameters["targetFrame"]=='sidebar' && document.getElementById('mura-sidebar-editor').style.display=='none'){
						Mura('##mura-sidebar-configurator').show();
					}
					if(typeof parameters.callback == 'undefined'){
						if(parameters["targetFrame"]=='sidebar'){
							sidebarProxy.post({cmd:'setObjectParams',params:data});
						} else {
							modalProxy.post({cmd:'setObjectParams',params:data});
						}
					} else{
						if(parameters["targetFrame"]=='sidebar'){
							sidebarProxy.post({cmd:parameters.callback,params:data});
						} else {
							modalProxy.post({cmd:parameters.callback,params:data});
						}
					}
				} else if(parameters["cmd"] == "deleteObject"){
					Mura('[data-instanceid="' + parameters["instanceid"] + '"]').remove();
					closeFrontEndToolsModal();
					MuraInlineEditor.sidebarAction('showobjects');
					MuraInlineEditor.isDirty=true;
				} else if(parameters["cmd"] == "showobjects"){
					MuraInlineEditor.sidebarAction('showobjects');
				} else if (parameters["cmd"]=="setObjectParams"){	
					if(typeof parameters["complete"] != 'undefined' && !parameters["complete"]){
						sidebarProxy.post(parameters);
						closeFrontEndToolsModal();
					} else {
						var item=Mura('[data-instanceid="' + parameters.instanceid + '"]');
	
						if(typeof parameters.params == 'object'){
	
							delete parameters.params.params;
	
							if(item.data('class')){
								var classes=item.data('class');
	
								if(typeof classes != 'Array'){
									classes=classes.split(' ');
								}
	
								for(var c=0;c<classes.length;c++){
									if(item.hasClass(classes[c])){
										item.removeClass(classes[c]);
									}
								}
	
								if(typeof parameters.params.class != 'undefined' && parameters.params.class){
	
									var incomingClasses=parameters.params.class;
	
									if(typeof incomingClasses != 'Array'){
										incomingClasses=incomingClasses.split(' ');
									}
	
									for(var c=0;c<incomingClasses.length;c++){
										if(!item.hasClass(incomingClasses[c])){
											item.addClass(incomingClasses[c]);
										}
									}
								}
							}
	
							for(var p in parameters.params){
								if(parameters.params.hasOwnProperty(p)){
									item.data(p,parameters.params[p]);
								}
							}
	
							if(item.data('trim-params') || item.data('trimparams')){
								var currentdata=item.data();
	
								for(var p in currentdata){
									if(currentdata.hasOwnProperty(p)){
										if(!(p=='inited' || p=='objecticonclass' || p=='async' || p=='instanceid' || p=='object' || p=='objectname' || p=='objectid') && typeof parameters.params[p] == 'undefined' ){
											item.removeAttr('data-' + p);
										}
									}
								}
							}
	
							item.removeAttr('data-trim-params');
							item.removeAttr('data-trimparams');
	
							MuraInlineEditor.isDirty=true;
						}
						var perm=item.data('perm');
						Mura.resetAsyncObject(item.node,false);
						if(perm){
							item.data('perm',perm);
						}
	
						item.addClass('mura-active');
						Mura.processAsyncObject(item.node,false).then(function(){
							closeFrontEndToolsModal();
							if(parameters.reinit && !item.data('notconfigurable')){
								openFrontEndToolsModal(item.node,true);
							}
						}).then(function(){
							if(parameters["currentPanel"]=='content'){
								item.children('.mura-object-content').addClass('mura-object-selected');
							}	if(parameters["currentPanel"]=='meta'){
								var metaWrapper=item.children('.mura-object-meta-wrapper');
								if(metaWrapper.length){
									metaWrapper.children('.mura-object-meta').addClass('mura-object-selected');
								}
							}
						});
					}
				} else if (parameters["cmd"]=='reloadObjectAndClose') {
					if(parameters.instanceid){
						var item=Mura('[data-instanceid="' + parameters.instanceid + '"]');
					} else {
						var item=Mura('[data-objectid="' + parameters.objectid + '"]');
					}
	
					Mura.resetAsyncObject(item.node);
					item.addClass('mura-active');
					Mura.processAsyncObject(item.node);
					closeFrontEndToolsModal();
					MuraInlineEditor.isDirty=true;
				} else if(parameters["cmd"] == "setImageSrc"){
					utility('img[data-instanceid="' + parameters.instanceid + '"]')
						.attr('src',parameters.src)
						.each(MuraInlineEditor.checkForImageCroppers);
				} else if (parameters["cmd"] == "openModal"){
					initFrontendUI({href:adminLoc + parameters["src"]});
				}
			}
		}
	
		initModalProxy=function(){
				modalProxy = new Porthole.WindowProxy(adminProxyLoc, 'frontEndToolsModaliframe');
				modalProxy.addEventListener(onAdminMessage);
		}
	
		initSidebarProxy=function(){
				sidebarProxy = new Porthole.WindowProxy(adminProxyLoc, 'frontEndToolsSidebariframe');
				sidebarProxy.addEventListener(onAdminMessage);
		}
	
		var frontEndModalWidthStandard=1140;
		var frontEndModalWidthConfigurator=600;
		var frontEndModalHeight=0;
		var frontEndModalWidth=0;
		var frontEndModalIE8=document.all && document.querySelector && !document.addEventListener;
	
		var getConfiguratorWidth=function(){
			var check=window.innerWidth-20;
			if(check < frontEndModalWidthStandard){
				return check;
			} else {
				return frontEndModalWidthStandard;
			}
		}
	
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
	
		var openFrontEndToolsModal=function(a,isnew){
			return initFrontendUI(a,isnew);
		};
	
		var openToolbar=function(event){
			if(!window.Mura.editing){
				return;
			}
			var source = Mura(event.target || event.srcElement);
	
			if(source.is('.frontEndToolsModal') ){
				event.preventDefault();
				event.stopPropagation();
				openFrontEndToolsModal(this);
			} else if(source.is('.mura-object') ){
				event.preventDefault();
				event.stopPropagation();
				openFrontEndToolsModal(source.node);
			} else if (!source.is('a, button, input, select, textarea')) {
				var parentObj=source.closest('.mura-object');
				if(parentObj.length){
					event.preventDefault();
					event.stopPropagation();
					openFrontEndToolsModal(parentObj.children('.frontEndToolsModal').node);
				}
			}
		};
	
		var initFrontendUI=function(a,isnew){
	
			if(typeof a=='undefined' || !a){
				return false;
			}
	
			var src=a.href;
			var editableObj=utility(a);
			var targetFrame='modal';
	
			//This is an advance look at the protential configurable object to see if it's a non-configurable component for form
			if(!src){
				if(editableObj.hasClass("mura-object")){
					var editableObj=editableObj;
				} else {
					var editableObj=editableObj.closest(".mura-object,.mura-async-object");
				}
				
				var lcaseObject=editableObj.data('object');
				if(typeof lcaseObject=='string'){
					lcaseObject=lcaseObject.toLowerCase();
				}
	
				//If the it's a form of component that's not configurable then go straight to edit it
				if((lcaseObject=='form' || lcaseObject=='component') && editableObj.data('notconfigurable')){
					MuraInlineEditor.sidebarAction('showobjects');
	
					if(Mura.isUUID(editableObj.data('objectid'))){
							src=adminLoc + '?muraAction=cArch.editLive&compactDisplay=true&contentid=' + encodeURIComponent(editableObj.data('objectid')) + '&type='+ encodeURIComponent(editableObj.data('object')) + '&siteid='+  Mura.siteid + '&instanceid=' + encodeURIComponent(editableObj.data('instanceid'));
					} else {
							src=adminLoc + '?muraAction=cArch.editLive&compactDisplay=true&title=' + encodeURIComponent(editableObj.data('objectid')) + '&type='+ encodeURIComponent(editableObj.data('object')) + '&siteid=' + Mura.siteid + '&instanceid=' + encodeURIComponent(editableObj.data('instanceid'));
					}
	
				}
			}
	
			//If there's no direct src to goto then we're going to assume it's a display object configurator
			
			if(!src){
	
				if(editableObj.hasClass("mura-object")){
					var editableObj=utility(a).closest(".mura-object,.mura-async-object");
				}
	
				var container=editableObj.parent().closest('div[data-object="container"]');
				if(container.length){
					if(container.children('.mura-object-content').css('display')=='block'){
						var isflex=0;
					} else {
						var isflex=1;
					}
				} else {
					var isflex=editableObj.parent().closest('div.mura-region-local[data-loose="false"]').length;
				}
				
				/*
					This reloads the element in the dom to ensure that all the latest
					values are present
				*/
				
				if(!isnew && typeof Mura.currentObjectInstanceID != 'undefined' && Mura.currentObjectInstanceID == editableObj.data('instanceid')){
					return;
				}
				
				Mura.currentObjectInstanceID= editableObj.data('instanceid');
	
				editableObj=Mura('[data-instanceid="' + editableObj.data('instanceid') + '"]');
				editableObj.hide().show();
	
				Mura('.mura-object-select').removeClass('mura-object-select');
				Mura('.mura-active-target').removeClass('mura-active-target');
				Mura('.mura-container-active').removeClass('mura-container-active');
	
				if(editableObj.data('object')=='container'){
					editableObj.addClass('mura-container-active');
				} else {
					var container=editableObj.closest('div[data-object="container"]');
					if(container.length){
						var finder=container.find('div[data-instanceid="' + Mura.currentObjectInstanceID + '"]')
						if(finder.length){
							container.addClass('mura-container-active');
						}
					}
				}
				editableObj.addClass('mura-object-select');
	
				var legacyMap={
					feed:true,
					feed_slideshow:true,
					feed_no_summary:true,
					feed_slideshow_no_summary:true,
					related_content:true,
					related_section_content:true,
					plugin:true
				}
	
				if(!legacyMap[editableObj.data('object')]){
					targetFrame='sidebar';
					if(MuraInlineEditor.commitEdit && Mura.currentId){
						MuraInlineEditor.commitEdit(Mura('##' + Mura.currentId));
					}
				}
	
				isnew=isnew || false;
	
				var src= adminLoc + '?muraAction=cArch.frontEndConfigurator&compactDisplay=true&siteid=' + Mura.siteid + '&instanceid=' +  editableObj.data('instanceid') + '&contenthistid=' + Mura.contenthistid + '&contentid=' + Mura.contentid + '&parentid=' + Mura.parentid + '&object=' +  editableObj.data('object') + '&objectid=' +  editableObj.data('objectid') + '&layoutmanager=' +  Mura.layoutmanager + '&objectname=' + encodeURIComponent(editableObj.data('objectname')) + '&contenttype=' + Mura.type + '&contentsubtype=' +encodeURIComponent(Mura.subtype) + '&sourceFrame=' + targetFrame + '&objecticonclass=' + encodeURIComponent(editableObj.data('objecticonclass')) + '&isnew=' + isnew + '&isflex=' + isflex;
				
				if(editableObj.is("div.mura-body-object,div.mura-object[data-targetattr]")){
					src+='&hasTargetAttr=true';
				}
			}
	
			if(targetFrame=='modal'){
				editableObj=Mura(a);
				var isModal=editableObj.attr("data-configurator");
	
				//These are for the preview iframes
				var width=editableObj.attr("data-modal-width");
				var ispreview=editableObj.attr("data-modal-preview");
	
				frontEndModalHeight=0;
				frontEndModalWidth=0;
	
				if(!isNaN(width)){
					frontEndModalWidth = width;
				}
	
				closeFrontEndToolsModal();
	
				if(ispreview){
	
					window.scrollTo(0, 0);
	
					if(src.indexOf("?") == -1) {
						src = src + '?muraadminpreview';
					} else {
						src = src + '&muraadminpreview';
					}
	
					frontEndModalHeight=600;
					frontEndModalWidth=1075;
	
					var $tools='<div id="mura-preview-device-selector">';
						$tools=$tools+'<p>Preview Mode</p>';
						$tools=$tools+'<a class="mura-device-standard active" title="Desktop" data-height="600" data-width="1075" data-mobileformat="false"><i class="mi-desktop"></i></a>';
						$tools=$tools+'<a class="mura-device-tablet" title="Tablet" data-height="600" data-width="768" data-mobileformat="false"><i class="mi-tablet"></i></a>';
						$tools=$tools+'<a class="mura-device-tablet-landscape" title="Tablet Landscape" data-height="480" data-width="1024" data-mobileformat="false"><i class="mi-tablet mi-rotate-270"></i></a>';
						$tools=$tools+'<a class="mura-device-phone" title="Phone" data-height="480" data-width="320" data-mobileformat="true"><i class="mi-mobile-phone"></i></a>';
						$tools=$tools+'<a class="mura-device-phone-landscape" title="Phone Landscape" data-height="250" data-width="520" data-mobileformat="true"><i class="mi-mobile-phone mi-rotate-270"></i></a>';
						$tools=$tools+'<a id="preview-close" title="Close" href="##" onclick="closeFrontEndToolsModal(); return false;"><i class="mi-times-circle"></i></a>';
						$tools=$tools+'</div>';
	
				} else {
					if(!frontEndModalHeight){
						if (isModal == undefined) {
							frontEndModalWidth = getConfiguratorWidth();
						} else if (isModal == "true") {
							frontEndModalWidth=frontEndModalWidthConfigurator;
						} else {
							frontEndModalWidth = getConfiguratorWidth();
						}
					}
	
					src=src + "&frontEndProxyLoc=" + frontEndProxyLoc;
					var $tools='';
				}
	
				if(ispreview){
					utility("##frontEndToolsModalTarget").html('<div id="frontEndToolsModalContainer">' +
					'<div id="frontEndToolsModalBody">' + $tools +
					'<iframe src="' + src + '" id="frontEndToolsModaliframe" class="frontEndToolsPreview" scrolling="false" frameborder="0" style="overflow:hidden" name="frontEndToolsModaliframe"></iframe>' +
					'</div>' +
					'</div>');
	
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
	
					utility("##frontEndToolsModalBody").css("top",(utility(document).scrollTop()+48) + "px");
					resizeFrontEndToolsModal(frontEndModalHeight);
				} else {
	
					if(Mura.type=='Variation' && Mura.remoteid){
						src+='&remoteid=' + encodeURIComponent(Mura.remoteid);
					}
	
					if(Mura.type=='Variation' && Mura.title){
						src+='&title=' + encodeURIComponent(Mura.title);
					}
	
					if(Mura.type=='Variation' && Mura.remoteurl){
						src+='&remoteurl=' + encodeURIComponent(Mura.remoteurl);
					}
	
					src+='&cacheid=' + Math.random();
	
					utility("##frontEndToolsModalTarget").html('<div id="frontEndToolsModalContainer">' +
					'<div id="frontEndToolsModalBody">' + $tools +
					'<iframe src="' + src + '" id="frontEndToolsModaliframe" scrolling="false" frameborder="0" style="overflow:hidden" name="frontEndToolsModaliframe"></iframe>' +
					'</div>' +
					'</div>');
	
					frontEndModalHeight=0;
					utility("##frontEndToolsModalBody").css("top",(utility(document).scrollTop()+48) + "px")
					resizeFrontEndToolsModal(0);
				}
			} else {
	
				Mura('.mura-object-selected').removeClass('mura-object-selected');
	
				editableObj.addClass('mura-object-selected');
				src+='&cacheid=' + Math.random();
	
				//console.log(src)
				utility('##frontEndToolsSidebariframe').attr('src',src);
				MuraInlineEditor.sidebarAction('showconfigurator');
			}
	
			return false;
		}
	
		var resizeFrontEndToolsSidebar=function(frameHeight){
			var iframe=document.getElementById("frontEndToolsSidebariframe");
			if (iframe){
				iframe.style.height=frameHeight + "px";
			}
	
		}
	
		var resizeFrontEndToolsModal=function(frameHeight){
		
			if (document.getElementById("frontEndToolsModaliframe")) {
	
				var frame = document.getElementById("frontEndToolsModaliframe");
				var frameContainer = document.getElementById("frontEndToolsModalContainer");
				var framesrc = frame.getAttribute('src');
				var appliedHeight = 0;
	
				var isEditText = false; //framesrc.includes('cArch.edittext');
				var isFullHeight = framesrc.includes('cArch.editLive');// || framesrc.includes('cArch.edit') || framesrc.includes('html.cfm');;
				var windowHeight = Math.max(frameHeight, utility(window).height());
	
				utility('##frontEndToolsModalContainer ##frontEndToolsModalBody,##frontEndToolsModalContainer ##frontEndToolsModaliframe').width(frontEndModalWidth);
	
				if (isEditText){
					appliedHeight = Math.min(760, utility(window).height()-96);
				} else if(isFullHeight) {
					appliedHeight = utility(window).height()-96;
				} else {
					appliedHeight = frameHeight;
				}
	
				frame.style.height = appliedHeight + "px";
				frameContainer.style.position = "absolute";
				document.overflow = "auto";
	
	//			console.log('appliedHeight: ' + appliedHeight);
	//			console.log('frameHeight: ' + frameHeight);
	//			console.log('isEditText: ' + isEditText);
	//			console.log('framesrc: ' + framesrc);
	//			console.log('isFullHeight: ' + isFullHeight);
	//			console.log('windowHeight: ' + windowHeight);
	//			console.log('frontEndModalHeight: ' + frontEndModalHeight);
	
				if(windowHeight > frontEndModalHeight){
					frontEndModalHeight=windowHeight;
					frameContainer.style.height=utility(document).height() + "px";
					setTimeout(function(){
						utility("##frontEndToolsModalClose").fadeIn("fast")
					},1000);
				}
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
	
			if(utility('HTML').hasClass('mura-edit-mode')){
				if(typeof tools.fadeOut == 'function'){
					utility("##frontEndTools").fadeOut();
				} else {
					utility("##frontEndTools").hide();
				}
	
				utility('HTML').removeClass('mura-edit-mode');
				utility(".editableObject").addClass('editableObjectHide');
	
				if(typeof MuraInlineEditor != 'undefined' && MuraInlineEditor.inited){
					MuraInlineEditor.sidebarAction('minimizesidebar');
					utility(".mura-editable").addClass('mura-inactive');
				}
	
			} else {
				if(typeof tools.fadeOut == 'function'){
					utility("##frontEndTools").fadeIn();
				} else {
					utility("##frontEndTools").show();
				}
	
				utility('HTML').addClass('mura-edit-mode');
				utility(".editableObject").removeClass('editableObjectHide');
	
				if(typeof MuraInlineEditor != 'undefined' && MuraInlineEditor.inited){
					MuraInlineEditor.sidebarAction('restoresidebar');
					utility(".mura-editable").removeClass('mura-inactive');
				}
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
	
		var initToolbar=function(){
	
			checkToolbarDisplay();
	
			utility(".frontEndToolsModal").each(
				function(el){
	
					var initToolbar=function(event){
						event.preventDefault();
						openFrontEndToolsModal(this);
					};
	
					utility(this).off('click',initToolbar).on('click',initToolbar);
			});
	
			utility(".editableObject").each(function(){
				resizeEditableObject(this);
			});
	
			if(typeof modalProxy == 'undefined'){
				initModalProxy();
			}
			<cfif $.getContentRenderer().useLayoutManager()>
			if(typeof sidebarProxy == 'undefined'){
				initSidebarProxy();
			}
			</cfif>
	
			if(frontEndModalIE8){
				utility("##adminQuickEdit").remove();
			}
		};
	
		initToolbar();
		</cfoutput>
		</cfif>
		<cfparam name="url.contenttype" default="">
		<cfif isDefined('url.siteID') and isDefined('url.contenthistid') and isDefined('url.showInlineEditor') and url.showInlineEditor>
	
		<cfset node=application.serviceFactory.getBean('contentManager').read(contentHistID=url.contentHistID,siteid=url.siteid)>
	
		<cfif url.contenttype eq 'Variation'>
			<cfset node.setIsNew(0)>
			<cfset node.setType('Variation')>
		</cfif>
	
		<cfif not node.getIsNew()>
		<cfoutput>
		editingVariations=false;
		targetingVariations=false;
	
		var MuraInlineEditor={
			inited: false,
			deInit: function(){
				if(MuraInlineEditor.inited){
					MuraInlineEditor.inited=false;
					if(window.Mura.layoutmanager){
						Mura.deInitLayoutManager();
					}
				}
			},
			init: function(){
				if(typeof Mura != 'undefined'){
					Mura(document).trigger('beforeLayoutManagerInit')
					var sheet=Mura.getStyleSheet('mura-inline-editor');
					sheet.insertRule(
						'.mura-region-local, .mura-region-inherited, .mura-object {	min-height: 30px;	}',
						sheet.cssRules.length
					);
	
				}
	
				utility(document)
					.trigger('muraContentEditInit')
					.trigger('ContentEditInit');
	
				<cfif node.getType() eq 'Variation'>
				if(!Mura('.mxp-editable').length){
					return false;
				}
				</cfif>
	
				if(targetingVariations){
					return false;
				}
	
				<cfif $.siteConfig('hasLockableNodes')>
					<cfset stats=node.getStats()>
					<cfif stats.getLockType() eq 'node' and stats.getLockID() neq session.Mura.userid>
						alert('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"sitemanager.draftprompt.contentislockedbyanotheruser"))#');
						return false;
					</cfif>
				</cfif>
	
				if(MuraInlineEditor.inited){
					return false;
				}
	
				Mura('##clientVariationTargeting').css('text-decoration','line-through');
				Mura('.mura-edit-toolbar-vartargeting').remove();
	
				CKEDITOR.disableAutoInline=true;
				MuraInlineEditor.inited=true;
				utility('##adminSave').show();
				utility('##adminStatus').hide();
	
				utility('##adminAddContent').hide();
				utility('##adminVersionHistory').hide();
				utility('##adminPreview').hide();
				utility('##adminAddContent-suspend').show();
				utility('##adminVersionHistory-suspend').show();
				utility('##adminPreview-suspend').show();
	
				utility('.mura-editable').removeClass('mura-inactive');
				window.Mura.editing=true;
	
				utility('##mura-deactivate-editors').click(function(){
					MuraInlineEditor.sidebarAction('showobjects');
				});
	
				<cfif node.getType() eq 'Variation'>
	
					Mura.finalVariations=[]
	
					Mura('.mxp-editable').each(function(){
						var item=Mura(this);
						Mura.finalVariations.push({
							original:item.html(),
							selector:item.selector()
						});
	
						item.addClass('mura-active');
	
					});
	
					var displayVariations=function(){
	
						//console.log(Mura.variations);
	
						if(Mura.variations.length){
							Mura(".mura-var-undo").show();
							//Mura(".mura-var-save").show();
							Mura(".mura-var-cancel").show();
						} else {
							Mura(".mura-var-undo").hide();
							//Mura(".mura-var-save").hide();
							Mura(".mura-var-cancel").hide();
						}
						Mura(".mura-var-undo").hide();
						Mura("##mura-var-details").html("");
					}
	
					var undoVariations=function(){
	
						if(Mura.variations.length){
							var current=Mura('.mura-var-current');
	
							if(current.length){
								for(var i=(Mura.variations.length-1);i>=0;i--){
									var target=Mura(Mura.variations[i].selector);
									if( current.attr('id')==target.attr('id') ){
										target.html(Mura.variations[i].original);
										i=-1;
									}
								}
							} else {
								var last=Mura.variations.length-1;
								Mura(Mura.variations[last].selector).html(Mura.variations[last].original);
								Mura.variations.pop();
							}
	
						}
	
						MuraInlineEditor.resetEditableAttributes();
						Mura(".mxp-editable").each(function(){
							Mura.processMarkup(this);
							Mura(this).find(Mura.looseDropTargets).each(function(){
								Mura.initLooseDropTarget(this);
							});
						});
						displayVariations();
					}
	
					var reset=function(){
						while(Mura.variations.length){
							undoVariations();
						}
						activeEdit=false;
						Mura.variations=Mura.origvariations;
						applyVariations();
						displayVariations();
					}
	
					var trimAttrs=function(e){
						if(!e.attr('class')){
							e.removeAttr('class');
						}
						if(!e.attr('style')){
							e.removeAttr('style');
						}
						if(!e.attr('id')){
							e.removeAttr('id');
						}
	
						e.removeAttr('contenteditable');
					}
	
					var compressVariations=function(){
						var vs=[];
	
						variations.reverse();
	
						for(var i=0;i<Mura.variations.length;i++){
							var item=Mura.variations[i], added=false;
	
							for(var v=0;v<vs.length;v++){
	
								if(vs[v].selector==item.selector){
	
									added=true;
									break;
								}
							}
	
							if(!added){
								vs.push(item);
							}
						}
	
						Mura.variations=vs.slice();
	
						editingVariations=false;
	
					}
	
					var activeEditorIndex=0;
					var activeEditorId='mura-var-editor0';
					var variation;
					var style;
	
					var commitEdit=function(currentEl){
	
						if(Mura.currentId && Mura.currentId==currentEl.attr('id')){
	
							currentEl.removeClass('mura-var-current');
	
							if(!currentEl.attr('class')){
								currentEl.removeAttr('class');
							}
	
							var instance=CKEDITOR.instances[currentEl.attr('id')];
	
							if(instance){
								instance.updateElement();
								variation.adjusted=instance.getData();
								instance.destroy();
								CKEDITOR.remove(instance);
							} else {
								variation.adjusted=currentEl.html();
							}
	
							currentEl.attr('contenteditable','false');
	
							Mura.processMarkup(currentEl)
	
							Mura.currentId='';
							/*
							currentEl.find('.mura-object').each(function(){
								Mura.initDraggableObject(this);
								Mura(this).addClass('mura-active')
								Mura(this).on('click',Mura.handleObjectClick);
							});
							*/
							currentEl.find(Mura.looseDropTargets).each(function(){
								Mura.initLooseDropTarget(this);
							});
	
	
							if(style){
								currentEl.attr('style',style);
							} else {
								currentEl.removeAttr('style');
							}
	
							if(variation.adjusted){
	
								if(variation.original != variation.adjusted){
									Mura.variations.push(variation);
									displayVariations();
								}
							}
						}
					}
	
					MuraInlineEditor.commitEdit=commitEdit;
	
					var editAction=function(){
	
						var currentEl=Mura('.mura-var-target');
	
						if(!currentEl.length){
							return;
						}
	
	
						Mura('.mura-var-target').each(function(){
							Mura(this).removeClass('mura-var-target');
							trimAttrs(Mura(this));
						});
	
	
						var style=currentEl.attr('style');
						var hasTempId=true;
	
						if(Mura.currentId && Mura.currentId==currentEl.attr('id')){
							return;
						}
	
						if(Mura.currentId!=''){
							commitEdit(Mura('##' + Mura.currentId));
						}
	
						Mura.currentId='';
	
						if(currentEl.attr('id')){
							Mura.currentId=currentEl.attr('id');
							hasTempId=false;
						}
	
						if(activeEditorId){
							Mura('##' + activeEditorId).attr('contenteditable',false);
						}
	
						if(hasTempId){
							activeEditorIndex++;
							Mura.currentId='mura-var-editor' + activeEditorIndex;
							currentEl.attr('id',Mura.currentId);
							currentEl.data('hastempid',true);
						}
	
						activeEditorId=Mura.currentId;
	
						var instance=CKEDITOR.instances[Mura.currentId];
						var editiorEnabled=true;
	
						MuraInlineEditor.sidebarAction('showeditor');
	
						utility('.mura-object[data-transient="true"], .mura-cta__item').remove();
	
						Mura('##' + Mura.currentId)
							.find('.mura-object')
							.each(function(){
								var item=Mura(this);
								if(item.data('transient')){
									item.remove();
								} else {
									Mura.resetAsyncObject(this);
								}	
							});
	
						variation={
							selector:currentEl.selector(),
							original:currentEl.html()
						};
	
						try{
							currentEl.attr('contenteditable',true);
	
							var instance=CKEDITOR.instances[Mura.currentId];
	
							if(!instance){
	
								Mura('##' + Mura.currentId).find('.mura-object').each(function(){
									Mura.resetAsyncObject(this);
								});
	
								CKEDITOR.disableAutoInline = true;
								var editor=CKEDITOR.inline(
									document.getElementById( Mura.currentId ),
									{
										toolbar: 'QuickEdit',
										width: "75%",
										customConfig: 'config.js.cfm',
										on: {
												'instanceReady':function(e){
													e.editor.updateElement();
													variation.original=e.editor.getData();
												},
												//'blur': function(){ onBlur()}
											}
									}
								);
	
							}
	
						} catch(err){
							console.log(err);
	
						}
	
						console.log('current Selector:' + variation.selector);
	
	
	
						/*
						currentEl.on('blur',function(){
							onBlur();
							currentEl.unbind('blur');
	
						});
						*/
	
						MuraInlineEditor.isDirty=true;
	
						currentEl.addClass('mura-var-current');
						return false;
					}
	
					var editVariations=function(){
						editingVariations=true;
						Mura('##adminStatus').hide();
						Mura('##adminSave').show();
						displayVariations();
	
						Mura(Mura.editableSelector).hover(function(){
							if(editingVariations){
								if(Mura.currentId != Mura(this).attr('id')){
									var prev=Mura('.mura-var-target');
									prev.removeClass('mura-var-target');
	
									if(!prev.attr('class')){
										prev.removeAttr('class');
									}
	
									Mura(this).addClass('mura-var-target');
								}
							}
						},
						function(){
							if(editingVariations){
								if(Mura.currentId != Mura(this).attr('id')){
									Mura(this).removeClass('mura-var-target');
									if(!Mura(this).attr('class')){
										Mura(this).removeAttr('class');
									}
								}
							}
						});
	
						Mura(Mura.editableSelector).on('dblclick',
							function(event){
								event.stopPropagation();
								if(editingVariations){
									editAction();
								}
								Mura(this).focus();
						});
	
						Mura(Mura.editableSelector + ' a, ' + Mura.editableSelector + ' button').each(
							function(){
								var self=Mura(this);
	
								if(!self.hasClass('mura')){
									Mura(this).on('click',function(event){
										if(editingVariations){
											event.preventDefault();
										}
									});
								}
	
							}
						);
	
						Mura(Mura.editableSelector).each(function(){
							Mura(this).closest('a').each(function(){
								var self=Mura(this);
	
								if(!self.hasClass('mura')){
									self.on('click',function(event){
										if(editingVariations){
											event.preventDefault();
										}
									});
								}
							});
						});
					}
	
					var exitVariations=function(){
						reset();
						Mura('##adminStatus').show();
						Mura('##adminSave').hide();
	
						var prev=Mura('.mura-var-target');
						prev.removeClass('mura-var-target');
	
						if(!prev.attr('class')){
							prev.removeAttr('class');
						}
	
						editingVariations=false;
					}
	
	
					Mura('.mura-inline-undo').on('click',function(){
						undoVariations();
						editVariations();
					});
	
					editVariations();
					displayVariations();
	
					var styles='<style type="text/css">';
						styles+='.mxp-editable {';
						styles+='    outline: ##ccc dotted 1px;';
						styles+='}';
						styles+='.mura-var-current {';
						styles+='	outline-width: 1px;';
						styles+='	outline-style: dotted;';
						styles+='   outline-color: red;';
						styles+='}';
						styles+='.mura-var-target {';
						styles+='    outline-width: 1px;';
						styles+='    outline-style: dotted;';
						styles+='    outline-color: blue;';
						styles+='}';
						styles+='</style>';
	
					document.head.innerHTML += styles;
				</cfif>
	
				<cfif $.getContentRenderer().useLayoutManager()>
				if(window.Mura.layoutmanager){
	
	
					Mura("img").each(function(){MuraInlineEditor.checkforImageCroppers(this);});
	
					MuraInlineEditor.setAnchorSaveChecks(document);
	
					utility('.mura-cta__item').remove();
	
					function initObject(){
						var item=Mura(this);
						var objectParams;
	
						if(item.data('transient')){
							item.remove();
						}
						
						item.addClass("mura-active");
	
						if(Mura.type =='Variation'){
							objectParams=item.data();
							item.children('.frontEndToolsModal').remove();
							item.children('.mura-fetborder').remove();
							item.prepend(window.Mura.layoutmanagertoolbar );
							if(item.data('objectname')){
								item.children('.frontEndToolsModal').children('.mura-edit-label').html(item.data('objectname'));
							} else {
								item.children('.frontEndToolsModal').children('.mura-edit-label').html(Mura.firstToUpperCase(item.data('object')));
							}
							if(item.data('objecticonclass')){
								item.children('.frontEndToolsModal').children('.mura-edit-label').addClass(item.data('objecticonclass'));
							}
							item.off("click",openToolbar)
								.on("click",openToolbar);
							item.find("img").each(function(){MuraInlineEditor.checkforImageCroppers(this);});
							item.find('.mura-object').each(initObject);
						} else {
							var lcaseObject=item.data('object');
							if(typeof lcaseObject=='string'){
								lcaseObject=lcaseObject.toLowerCase();
							}
							var region=item.closest('.mura-region-local');
							if(region && region.length ){
								if(region.data('perm')){
									objectParams=item.data();
									if(window.MuraInlineEditor.objectHasConfigurator(item) || (!window.Mura.layoutmanager && window.MuraInlineEditor.objectHasEditor(objectParams)) ){
										item.children('.frontEndToolsModal').remove();
										item.children('.mura-fetborder').remove();
										item.prepend(window.Mura.layoutmanagertoolbar);
										if(item.data('objectname')){
											item.children('.frontEndToolsModal').children('.mura-edit-label').html(item.data('objectname'));
										} else {
											item.children('.frontEndToolsModal').children('.mura-edit-label').html(Mura.firstToUpperCase(item.data('object')));
										}
										if(item.data('objecticonclass')){
											item.children('.frontEndToolsModal').children('.mura-edit-label').addClass(item.data('objecticonclass'));
										}
										item.off("click",openToolbar)
											.on("click",openToolbar);
										item.find("img").each(function(){MuraInlineEditor.checkforImageCroppers(this);});
										item.find('.mura-object').each(initObject);
									}
								}
	
							} else if (lcaseObject=='form' || lcaseObject=='component'){
								var entity=Mura.getEntity('content');
								var conditionalApply=function(){
									objectParams=item.data();
									if(window.MuraInlineEditor.objectHasConfigurator(item) || (!window.Mura.layoutmanager && window.MuraInlineEditor.objectHasEditor(objectParams)) ){
										item.addClass('mura-active');
										item.hover(
											Mura.initDraggableObject_hoverin,
											Mura.initDraggableObject_hoverout
										);
										item.data('notconfigurable',true);
										item.children('.frontEndToolsModal').remove();
										item.children('.mura-fetborder').remove();
										item.prepend(window.Mura.layoutmanagertoolbar);
										if(item.data('objectname')){
											item.children('.frontEndToolsModal').children('.mura-edit-label').html(item.data('objectname'));
										} else {
											item.children('.frontEndToolsModal').children('.mura-edit-label').html(Mura.firstToUpperCase(item.data('object')));
										}
										if(item.data('objecticonclass')){
											item.children('.frontEndToolsModal').children('.mura-edit-label').addClass(item.data('objecticonclass'));
										}
										item.off("click",openToolbar)
											.on("click",openToolbar);
										item.find("img").each(function(){MuraInlineEditor.checkforImageCroppers(this);});
										item.find('.mura-object').each(initObject);
									}
								}
								
								if(item.data('perm')){
									conditionalApply()
								} else {
									if(Mura.isUUID(item.data('objectid'))){
										entity.loadBy('contentid',item.data('objectid'),{type:lcaseObject}).then(function(bean){
											bean.get('permissions').then(function(permissions){
												if(permissions.get('save')){
													item.data('perm',true);
													conditionalApply()
												}
											});
										});
									} else {
										entity.loadBy('title',item.data('objectid'),{type:lcaseObject}).then(function(bean){
											bean.get('permissions').then(function(permissions){
												if(permissions.get('save')){
													item.data('perm',true);
													conditionalApply()
												}
											});
										});
									}
								}
	
							}
	
						}
					}
	
					Mura(".mura-object").each(initObject);
	
					Mura('div.mura-body-object,div.mura-object[data-targetattr]').each(function(){
						var item=Mura(this);
						item.addClass("mura-active");
						item.children('.frontEndToolsModal').remove();
						item.children('.mura-fetborder').remove();
						item.prepend(window.Mura.layoutmanagertoolbar);
						if(item.data('objectname')){
							item.children('.frontEndToolsModal').children('.mura-edit-label').html(item.data('objectname'));
						} else {
							item.children('.frontEndToolsModal').children('.mura-edit-label').html(Mura.firstToUpperCase(item.data('object')));
						}
						if(item.data('objecticonclass')){
							item.children('.frontEndToolsModal').children('.mura-edit-label').addClass(item.data('objecticonclass'));
						}
						item.off("click",openToolbar).on("click",openToolbar);
					});
	
					Mura.initLayoutManager();
				}
				</cfif>
	
	
				utility('.mura-editable-attribute').each(
					function(){
					var attribute=utility(this);
	
					if(attribute.data('attribute')){
	
						<cfif $.getContentRenderer().useLayoutManager()>
						if(attribute.attr('data-attribute')){
							MuraInlineEditor.initEditableObjectData.call(this);
							if(!utility(this).closest('.mura-object').length){
								utility(this)
								.off('dblclick')
								.on('dblclick',
									function(){
										MuraInlineEditor.initEditableAttribute.call(this);
										Mura(this).focus();
									}
								);
							}
						}
	
						<cfelse>
	
						var attributename=attribute.attr('data-attribute').toLowerCase();
	
						attribute.attr('contenteditable','true');
						attribute.attr('title','');
	
						utility(this)
						.unbind('click')
						.click(
							function(){
								MuraInlineEditor.initEditableObjectData.call(this);
							}
						);
	
						if(!(attributename in MuraInlineEditor.attributes)){
	
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
						</cfif>
					}
	
				});
	
				utility('.mura-inline-save').click(function(){
					var changesetid=utility(this).attr('data-changesetid');
					var isApproved=utility(this).data('approved');
	
					delete MuraInlineEditor.data.removePreviousChangeset;
					
					if(Mura.changesetid != '' && Mura.changesetid != changesetid){
						var proceed=false;
						if(isApproved){
							if(confirm('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.publishitemfromchangeset"))#')){
								proceed=true;
							}
						} else {
							if(confirm('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.changesetnotifyexport"))#')){
								proceed=true;
							}
						}
						
						if(!proceed){
							return;
						}
					}
					
					if(Mura.changesetid != '' && Mura.changesetid != changesetid){
						if(confirm('#esapiEncode('javascript',application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.removechangeset"),application.changesetManager.read(node.getChangesetID()).getName()))#')){
							MuraInlineEditor.data.removePreviousChangeset=true;
						}
					}
	
					if(changesetid == ''){
						//alert(1 + " " + utility(this).attr('data-approved'))
						MuraInlineEditor.data.approved=utility(this).attr('data-approved');
						MuraInlineEditor.data.changesetid='';
					} else {
						//alert(changesetid)
						MuraInlineEditor.data.changesetid=changesetid;
						MuraInlineEditor.data.approved=0;
					}
	
					MuraInlineEditor.save();
				});
	
				utility('.mura-inline-cancel').click(function(){
					MuraInlineEditor.reload();
				});
	
				//clean instances
				for (var instance in CKEDITOR.instances) {
					if(!utility('##' + instance).length){
						CKEDITOR.instances[instance].destroy(true);
					}
				}
	
				return false;
			},
			reload:function(){
				var queryParams=Mura.getQueryStringParams();
				if(typeof queryParams.editlayout == 'undefined'){
					location.reload();
				} else {
					var queryString=Object.keys(queryParams).map(function(key) {
						if(key!='editlayout'){
							return key + '=' + queryParams[key]
						}
					}).join('&');
					window.location = window.location.href.split("?")[0] + ((queryString) ? '?' + queryString : '') + window.location.hash;
				}	
			},
			resetEditableAttributes:function(){
				if(Mura.currentId && MuraInlineEditor.commitEdit){
					MuraInlineEditor.commitEdit(Mura('##' + Mura.currentId));
				}
	
				utility('.mura-editable-attribute').each(
					function(){
						var attribute=utility(this);
						
						if(attribute.attr('contenteditable') == 'true'){
	
							if(CKEDITOR.instances[attribute.attr('id')]){
								var instance =CKEDITOR.instances[attribute.attr('id')];
								instance.updateElement();
								instance.destroy(true)
							}
	
							attribute.attr('contenteditable','false');
							attribute.addClass('mura-active');
							attribute.data('manualedit',false);
							Mura.processMarkup(this);
	
							attribute.find('.mura-object').each(function(){
								Mura.initDraggableObject(this);
								Mura(this).addClass('mura-active')
								Mura(this).on('click',Mura.handleObjectClick);
							});
	
							attribute.find(Mura.looseDropTargets).each(function(){
								Mura.initLooseDropTarget(this);
							});
	
							attribute
							.off('dblclick')
							.on('dblclick',
								function(){
									MuraInlineEditor.initEditableAttribute.call(this);
								}
							);
	
						}
				});
			},
			initEditableObjectData:function(){
				var self=this;
				var attributename=this.getAttribute('data-attribute').toLowerCase();
	
				var attribute=document.getElementById('mura-editable-attribute-' + attributename);
	
				if(!(attributename in MuraInlineEditor.attributes)){
					if(attributename in MuraInlineEditor.preprocessed){
	
						attribute.innerHTML=MuraInlineEditor.preprocessed[attributename];
	
						if(Mura.processMarkup){
							Mura.processMarkup(this);
						}
					}
	
	
					MuraInlineEditor.attributes[attributename]=attribute;
				}
			},
			initEditableAttribute:function(){
				var attribute=utility(this);
				var attributename=attribute.attr('data-attribute').toLowerCase();
	
				MuraInlineEditor.sidebarAction('showeditor');
				attribute.attr('contenteditable','true');
				attribute.attr('title','');
				attribute.unbind('dblclick');
				attribute.find('.mura-object').each(function(){
					var self=utility(this);
	
					self.removeAttr('data-perm')
					.removeAttr('draggable');
	
					if(typeof mura !='undefined' && typeof Mura.resetAsyncObject=='function'){
						Mura.resetAsyncObject(this);
					} else {
						self.html('');
					}
	
				});
	
				if(!attribute.data('manualedit')){
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
	
					attribute.data('manualedit',true);
				}
	
				MuraInlineEditor.isDirty=true;
	
			},
			getAttributeValue: function(attribute){
				var attributeid='mura-editable-attribute-' + attribute;
	
				if(typeof MuraInlineEditor.attributes[attribute].innerHTML == 'undefined'){
					MuraInlineEditor.attributes[attribute]=document.getElementById(attributeid);
				}
				if(typeof CKEDITOR.instances[attributeid] != 'undefined') {
					CKEDITOR.instances[attributeid].updateElement();
					return CKEDITOR.instances[attributeid].getData();
				} else if (MuraInlineEditor.attributes[attribute].getAttribute('data-type').toLowerCase() == 'htmleditor') {
					return MuraInlineEditor.attributes[attribute].innerHTML;
				} else {
					return MuraInlineEditor.stripHTML(MuraInlineEditor.attributes[attribute].innerHTML.trim());
				}
			},
			save:function(){
				try{
	
					utility('##adminSave').addClass('mura-saving');
	
					utility('.mura-object-selected').removeClass('mura-object-selected');
	
					utility('.mura-object[data-transient="true"], .mura-cta__item').remove();
	
					utility(document)
						.trigger('muraBeforeContentSave')
						.trigger('MuraBeforeContentSave')
						.trigger('beforeContentSave')
						.trigger('BeforeContentSave');
	
					var nestedObjectAttributes={};
	
					utility('.mura-object .mura-editable-attribute').forEach(function(){
						var item=utility(this);
						
						if(item.data('attribute')){
							nestedObjectAttributes[item.data('attribute')]=item.html();
						}
	
					});
	
					MuraInlineEditor.validate(
						function(){
							var count=0;
	
							for (var prop in MuraInlineEditor.attributes) {
								var attribute=MuraInlineEditor.attributes[prop].getAttribute('data-attribute');
	
								utility(attribute)
									.find('.mura-object')
									.removeAttr('data-perm')
									.removeAttr('draggable');
	
								if(mura && Mura.resetAsyncObject){
									Mura(attribute)
										.find('.mura-object')
										.each(function()
										{
											Mura.resetAsyncObject(this)
										});
								} else {
									utility(attribute)
									.find('.mura-object')
									.html('');
								}
								
								MuraInlineEditor.data[attribute]=MuraInlineEditor.getAttributeValue(attribute);
								count++;
							}
	
							utility('.mxp-editable').each(function(){
								if(Mura && Mura.resetAsyncObject){
									Mura(this)
										.find('.mura-object')
										.each(function()
										{
											Mura.resetAsyncObject(this)
										});
								}
	
							});
							
							processedRegions={};
							
							utility('.mura-region-local[data-inited="true"]:not([data-loose="true"])').each(
								function(){
									if(typeof processedRegions['objectlist' + this.getAttribute('data-regionid')] =='undefined'){
										var objectlist=[];
	
										utility(this).children('.mura-object').each(function(){
	
											if(mura && Mura.resetAsyncObject){
												Mura.resetAsyncObject(this);
												var item=Mura(this);
											} else {
												var item=utility(this);
												item.html('');
											}
	
											if(!item.data('transient')){
												var params=item.data();
												var objectid='';
	
												delete params['instanceid'];
												delete params['objectid'];
												delete params['inited'];
												delete params['isconfigurator'];
												delete params['perm'];
												delete params['async'];
												delete params['forcelayout'];
												delete params['isbodyobject'];
												delete params['runtime'];
												delete params['startrow'];
												delete params['pagenum'];
												delete params['nextnid'];
												delete params['origininstanceid'];
	
												if(!item.data('objectname')){
													item.data('objectname',Mura.firstToUpperCase(item.data('object')));
												}
	
												objectid=item.data('objectid') || 'NA';
	
												objectlist.push([item.data('object'),item.data('objectname') , objectid , JSON.stringify(params)])
											}
										});
	
										processedRegions['objectlist' + this.getAttribute('data-regionid')]=true;
										MuraInlineEditor.data['objectlist' + this.getAttribute('data-regionid')]=JSON.stringify(objectlist);
										count++;
									}
								}
							);
	
							utility.extend(MuraInlineEditor.data,nestedObjectAttributes);
	
							utility('div.mura-body-object,div.mura-object[data-targetattr]').each(function(){
								var item=utility(this);
	
								if(item.data('targetattr')=='objectparams'){
									if(item.data('displaylist')){
										MuraInlineEditor.data['displaylist']=item.data('displaylist');
									}
									if(item.data('imagesize')){
										MuraInlineEditor.data['imagesize']=item.data('imagesize');
									}
									if(item.data('imagewidth')){
										MuraInlineEditor.data['imagewidth']=item.data('imagewidth');
									}
									if(item.data('imageheight')){
										MuraInlineEditor.data['imageheight']=item.data('imageheight');
									}
									if(item.data('nextn')){
										MuraInlineEditor.data['nextn']=item.data('nextn');
									}
									if(item.data('sortby')){
										MuraInlineEditor.data['sortby']=item.data('sortby');
									}
									if(item.data('sortdirection')){
										MuraInlineEditor.data['sortdirection']=item.data('sortdirection');
									}
								}
	
								var params=item.data();
								delete params['instanceid'];
								delete params['objectid'];
								delete params['inited'];
								delete params['isconfigurator'];
								delete params['perm'];
								delete params['async'];
								delete params['forcelayout'];
								delete params['isbodyobject'];
								delete params['runtime'];
								delete params['startrow'];
								delete params['pagenum'];
								delete params['nextnid'];
								delete params['origininstanceid'];
								
								if(item.is('div.mura-body-object')){
									MuraInlineEditor.data['objectparams']=encodeURIComponent(JSON.stringify(params));
								} else {
									MuraInlineEditor.data[item.data('targetattr')]=encodeURIComponent(JSON.stringify(params));
								}
								
	
							});
	
	
							//objectlistarguments.regionID=rs.object~rs.name~rs.objectID~rs.params^
	
							//alert(MuraInlineEditor.data.objectlist3);
							//return;
	
							<cfif node.getType() eq 'Variation'>
	
								count=1;
	
								if(MuraInlineEditor.commitEdit && Mura.currentId){
									MuraInlineEditor.commitEdit(Mura('##' + Mura.currentId));
								}
	
								Mura('.mxp-editable').each(function(){
									var item=Mura(this);
									var selector=item.selector();
									var instance=CKEDITOR.instances[item.attr('id')];
	
									for(var i=0;i<Mura.finalVariations.length;i++){
										if(Mura.finalVariations[i].selector==selector){
											if(instance){
												instance.updateElement();
	
												Mura(Mura.finalVariations[i].selector)
													.find('.mura-object').each(function(){
														Mura.resetAsyncObject(this);
													});
	
												Mura.finalVariations[i].adjusted=instance.getData();
											} else {
	
												Mura(Mura.finalVariations[i].selector)
													.find('.mura-object').each(function(){
														Mura.resetAsyncObject(this);
													});
	
												Mura.finalVariations[i].adjusted=item.html();
											}
	
										}
									}
	
								});
	
								MuraInlineEditor.data=Mura.extend(
									MuraInlineEditor.data,
									{
										moduleid:Mura.content.get('moduleid'),
										remoteid:Mura.content.get('remoteid'),
										remoteurl:Mura.content.get('remoteurl'),
										type:Mura.content.get('type'),
										subtype:Mura.content.get('subtype'),
										parentid:Mura.content.get('parentid'),
										title:Mura.content.get('title'),
										body:encodeURIComponent(JSON.stringify(Mura.finalVariations))
									}
								);
							</cfif>
							
							if(count){
								if(MuraInlineEditor.data.approvalstatus=='Pending'){
									if(confirm('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"approvalchains.cancelPendingApproval"))#')){
										MuraInlineEditor.data.cancelpendingapproval=true;
									} else {
										MuraInlineEditor.data.cancelpendingapproval=false;
									}
	
								}
	
								//console.log(MuraInlineEditor.data)
								//return;
	
								if(typeof $ != 'undefined' && $.support){
									$.support.cors = true;
								}
	
								utility.ajax({
								type: "POST",
								xhrFields: { withCredentials: true },
								crossDomain:true,
								url: adminLoc,
								data: MuraInlineEditor.data,
								success: function(data){
									var resp = eval('(' + data + ')');
	
									if(resp.success){
									<cfif node.getType() eq 'Variation'>
										if(MuraInlineEditor.requestedURL && location.href != MuraInlineEditor.requestedURL){
											location.href=MuraInlineEditor.requestedURL
										} else {
											MuraInlineEditor.reload();
										}
									<cfelse>
										var resp = eval('(' + data + ')');
										if(MuraInlineEditor.requestedURL   && MuraInlineEditor.requestedURL != location.href && !(MuraInlineEditor.requestedURL.indexOf('previewid') > -1) ){
											location.href=MuraInlineEditor.requestedURL;
											if(location.href.indexOf('##') > -1){
												MuraInlineEditor.reload();
											}
										} else if(location.href!=resp.location){
											location.href=resp.location;
											if(location.href.indexOf('##') > -1){
												MuraInlineEditor.reload();
											}
										} else {
											MuraInlineEditor.reload();
										}
									</cfif>
									} else {
	
										utility('##adminSave').removeClass('mura-saving');
	
										MuraInlineEditor.data['csrf_token']=resp['csrf_token'];
										MuraInlineEditor.data['csrf_token_expires']=resp['csrf_token_expires'];
	
										var msg='';
										for(var e in resp.errors){
											msg=msg + resp.errors[e] + '\n';
										}
	
										alert(msg);
									}
	
								},
								 error: function(data){
									utility('##adminSave').removeClass('mura-saving');
									alert("An server error occurred.  Please check js console for more information.");
									console.log(JSON.stringify(data));
	
								}
							   });
							} else {
								if(MuraInlineEditor.requestedURL && MuraInlineEditor.requestedURL != location.href){
									location.href=MuraInlineEditor.requestedURL;
									if(location.href.indexOf('##') > -1){
										MuraInlineEditor.reload();
									}
								} else {
									MuraInlineEditor.reload();
								}
	
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
	
				if(!Mura.apiEndpoint){
					Mura.apiEndpoint=Mura.context + '/index.cfm/_api/json/v1/';
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
	
				for (var prop in MuraInlineEditor.attributes) {
					data[prop]=MuraInlineEditor.getAttributeValue(prop);
				}
	
				var errors="";
				var setFocus=0;
				var started=false;
				var startAt;
				var firstErrorNode;
				var validationType='';
				var validations={properties:{}};
				var rules=new Array();
	
				for (var prop in MuraInlineEditor.attributes) {
					theField=MuraInlineEditor.attributes[prop];
					validationType=getValidationType(theField).toUpperCase();;
					theValue=MuraInlineEditor.getAttributeValue(prop);
	
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
							url: Mura.apiEndpoint + '/validate/',
							data: {
									data: encodeURIComponent(JSON.stringify(utility.extend(MuraInlineEditor.data,data))),
									validations: encodeURIComponent(JSON.stringify(validations))
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
				<cfif url.contenttype neq 'Variation'>
				CKFinder.setupCKEditor(
				instance, {
					basePath: '#application.configBean.getContext()#/core/vendor/ckfinder/',
					rememberLastFolder: true
				});
				</cfif>
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
	
			},
			pluginConfigurators:[],
			getPluginConfigurator: function(objectid) {
				for(var i = 0; i < window.MuraInlineEditor.pluginConfigurators.length; i++) {
					if(window.MuraInlineEditor.pluginConfigurators[i].objectid == objectid || window.MuraInlineEditor.pluginConfigurators[i].object == objectid) {
						return window.MuraInlineEditor.pluginConfigurators[i].init;
					}
				}
	
				return "";
			},
			<cfoutput>customtaggroups:#serializeJSON(listToArray($.siteConfig('customTagGroups')))#,
			allowopenfeeds:#application.configBean.getValue(property='allowopenfeeds',defaultValue=false)#,</cfoutput>
			objectHasEditor:function(displayObject){
				if(displayObject.object == 'form') {
					return true;
				} else if(displayObject.object == 'form_responses') {
					return true;
				} else if(displayObject.object == 'component') {
					return true;
				}
				return false;
			},'form':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
			configuratorMap:{
				'container':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'collection':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'text':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'embed':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'feed':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initFeedConfigurator(data);}},
				'form':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'component':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'folder':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'gallery':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'calendar':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'form_responses':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'plugin':{
					'condition':function(){
						return true;
					},
					'initConfigurator':function(data){
						if(data.objectid && data.objectid.toLowerCase() != 'none' && siteManager.getPluginConfigurator(data.objectid)){
							var configurator = siteManager.getPluginConfigurator(data.objectid);
							window[configurator](data)
						} else {
							siteManager.initGenericConfigurator(data);
						}
					}
				},
				'feed_slideshow':{condition:function(){return true;},'initConfigurator':function(data){MuraInlineEditor.initSlideShowConfigurator(data);}},
				'tag_cloud':{condition:function(){return MuraInlineEditor.customtaggroups.length;},'initConfigurator':function(data){siteManager.initTagCloudConfigurator(data);}},
				'category_summary':{condition:function(){return true;},'initConfigurator':function(data){if(siteManager.allowopenfeeds){siteManager.initCategorySummaryConfigurator(data);} else {siteManager.initGenericConfigurator(data);}}},
				'archive_nav':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'calendar_nav':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'category_summary_rss':{condition:function(){return MuraInlineEditor.allowopenfeeds;},'initConfigurator':function(data){siteManager.initCategorySummaryConfigurator(data);}},
				'site_map':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initSiteMapConfigurator(data);}},
				'related_content':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initRelatedContentConfigurator(data);}},
				'related_section_content':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initRelatedContentConfigurator(data);}},
				'system':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'comments':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'favorites':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'forward_email':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'event_reminder_form':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'rater':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'user_tools':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'goToFirstChild':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'navigation':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'sub_nav':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'peer_nav':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'standard_nav':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'portal_nav':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'folder_nav':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'multilevel_nav':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'seq_nav':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'top_nav':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'mailing_list':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}},
				'mailing_list_master':{condition:function(){return true;},'initConfigurator':function(data){siteManager.initGenericConfigurator(data);}}
			},
			objectHasConfigurator:function(displayObject){
				var lcaseObject=displayObject.data('object');
				if(typeof lcaseObject=='string'){
					lcaseObject=lcaseObject.toLowerCase();
				}
				var check;
	
				if(!displayObject.hasClass){
					return true;
				}
				if(displayObject.hasClass('mura-body-object') || displayObject.is('div.mura-object[data-targetattr]')){
					return true;
				}
	
				if(lcaseObject!='form' && lcaseObject!='component'){
					var check=displayObject.closest('.mura-region-local');
	
					if(!check.length){
						displayObject.removeClass('mura-active');
						return false
					}
				}
	
				check=displayObject.parent().closest('.mura-object');
	
				if(check.length && check.data('object')!='container'){
					displayObject.removeClass('mura-active');
					return false;
				}
	
				return true;
	
			},
			checkforImageCroppers:function(el){
	
				if(window.mura && window.Mura.editing){
					var img=Mura(el);
					var instanceid=Mura.createUUID();
						img.data('instanceid',instanceid);
	
					var path=img.attr('src');
	
					if(path){
						path=path.split( '?' )[0].split('/')
					} else {
						return;
					}
					var fileParts=path[path.length-1].split('.');
					var filename=fileParts[0];
	
					if(fileParts.length > 1){
						var fileext=fileParts[1].toLowerCase();
					}
	
					var fileInfo=filename.split('_');
					var fileid=fileInfo[0];
	
					if(fileid.length==35 && (fileext=='jpg' || fileext=='jpeg' || fileext=='png')){
						fileInfo.shift()
	
	
						img.css({display:'inline-block;'});
	
						var size=fileInfo.join('_');
	
						if(!size){
							size='large';
						}
	
						var actionhref=adminLoc + '?muraAction=cArch.imagedetails&siteid=' + Mura.siteid + '&fileid=' + fileid + '&imagesize=' + size + '&instanceid=' + img.data('instanceid') + '&compactDisplay=true';
	
						function initCropper(){
							openFrontEndToolsModal({
									href:actionhref
							});
						}
	
	
						var a=img.closest('a');
	
	
						if(a.length){
							a.click(function(e){e.preventDefault();});
							a.attr('onclick',"openFrontEndToolsModal({href:'" + actionhref + "'}); return false;");
							a.off();
						}
	
						img=Mura('img[data-instanceid="' + instanceid + '"]' );
						img.on('click',function(e){e.preventDefault();});
	
						Mura('img[data-instanceid="' + instanceid + '"]' ).on('click',function(){
							initCropper();
						});
					}
	
				}
			},
			reloadImg:function(img) {
	
			   var src = img.src;
	
			   var pos = img.indexOf('?');
			   if (pos >= 0) {
				  src = src.substr(0, pos);
			   }
	
			   img.src = src + '?v=' + Math.random();
	
			   return false;
			},
			sidebarAction:function(action){
	
				if(action=='showobjects'){
					Mura.currentObjectInstanceID='';
					MuraInlineEditor.resetEditableAttributes();
					Mura('.mura-object-selected').removeClass('mura-object-selected');
					Mura('.mura-object-select').removeClass('mura-object-select');
					Mura('.mura-editable-attribute.mura-active').removeClass('mura-active');
					Mura('.mura-container-active').removeClass('mura-container-active');
					Mura('#mura-sidebar-configurator').hide();
					Mura('#mura-sidebar-objects-legacy').hide();
					Mura('#mura-sidebar-objects').show();
					Mura('#mura-sidebar-editor').hide();
				} else if(action=='showlegacyobjects'){
					Mura.currentObjectInstanceID='';
					MuraInlineEditor.resetEditableAttributes();
					Mura('.mura-object-selected').removeClass('mura-object-selected');
					Mura('.mura-container-active').removeClass('mura-container-active');
					Mura('#mura-sidebar-configurator').hide();
					Mura('#mura-sidebar-objects-legacy').show();
					Mura('#mura-sidebar-objects').hide();
					Mura('#mura-sidebar-editor').hide();
				} else if(action=='showconfigurator'){
					MuraInlineEditor.resetEditableAttributes();
					Mura('#mura-sidebar-configurator').hide();
					Mura('#mura-sidebar-objects-legacy').hide();
					Mura('#mura-sidebar-objects').hide();
					Mura('#mura-sidebar-editor').hide();
				} else if(action=='showeditor'){
					Mura.currentObjectInstanceID='';
					Mura('.mura-object-selected').removeClass('mura-object-selected');
					Mura('.mura-container-active').removeClass('mura-container-active');
					Mura('#mura-sidebar-configurator').hide();
					Mura('#mura-sidebar-objects-legacy').hide();
					Mura('#mura-sidebar-objects').hide();
					Mura('#mura-sidebar-editor').show();
				} else if(action=='minimizesidebar'){
					Mura.currentObjectInstanceID='';
					Mura('#mura-sidebar-container').fadeOut();
					Mura('body').removeClass('mura-sidebar-state__pushed--right')
					Mura('body').removeClass('mura-editing')
					Mura('.mura-object').removeClass('mura-active').addClass("mura-active-min");
				} else if(action=='restoresidebar'){
					Mura.currentObjectInstanceID='';
					Mura('#mura-sidebar-container').fadeIn();
					Mura('body').addClass('mura-sidebar-state__pushed--right');
					Mura('body').addClass('mura-editing')
					Mura('.mura-object').removeClass('mura-active-min').addClass("mura-active");
					Mura('.mura-container-active').removeClass('mura-container-active');
	
				}
	
			},
			setAnchorSaveChecks:function(el){
				function handleEditCheck(){
					if(MuraInlineEditor.isDirty && !Mura(el).closest('.mura-object').length){
						<cfoutput>
						if(confirm("#esapiEncode('javascript',application.rbFactory.getKey('sitemanager.content.saveasdraftlm',session.rb))#")){
							MuraInlineEditor.requestedURL=window.location;
							MuraInlineEditor.save();
							return false;
						} else if(confirm("#esapiEncode('javascript',application.rbFactory.getKey('sitemanager.content.keepeditingconfirmlm',session.rb))#")){
							return false;
						}
						</cfoutput>
					} else {
						return true;
					}
				}
	
				var anchors=el.querySelectorAll('a');
	
				for(var i=0;i<anchors.length;i++){
					if(!Mura(anchors[i]).closest('.mura').length){
						try{
							if (typeof(anchors[i].onclick) != 'function'
								&& typeof(anchors[i].getAttribute('href')) == 'string'
								&& anchors[i].getAttribute('href').indexOf('#') == -1
								&& anchors[i].getAttribute('href').indexOf('mailto') == -1) {
								   anchors[i].onclick = handleEditCheck;
							}
						} catch(err){}
					}
				}
			},
			isDirty:false
		}
	
		<cfoutput>
		<cfset rsPluginDisplayObjects=application.pluginManager.getDisplayObjectsBySiteID(siteID=session.siteID,configuratorsOnly=true)>
		<cfset nonPluginDisplayObjects=$.siteConfig().getDisplayObjectLookup()>
		<cfloop query="rsPluginDisplayObjects">
		MuraInlineEditor.pluginConfigurators.push({'objectid':'#rsPluginDisplayObjects.objectid#','init':'#rsPluginDisplayObjects.configuratorInit#'});
		</cfloop>
		<cfloop item="i" collection="#nonPluginDisplayObjects#">
		<cfif len(nonPluginDisplayObjects[i].configuratorInit)>
			MuraInlineEditor.pluginConfigurators.push({'objectid':'#nonPluginDisplayObjects[i].objectid#','init':'#nonPluginDisplayObjects[i].configuratorInit#'});
		</cfif>
		</cfloop>
		</cfoutput>
		window.MuraInlineEditor=MuraInlineEditor;
		</cfif>
		</cfif>
		window.toggleAdminToolbar=toggleAdminToolbar;
		window.closeFrontEndToolsModal=closeFrontEndToolsModal;
		window.openFrontEndToolsModal=openFrontEndToolsModal;
		window.themepath=window.themepath || Mura.themepath;
		window.muraInlineEditor=window.MuraInlineEditor;
		Mura.handleObjectClick=openToolbar;
		Mura.initFrontendUI=initFrontendUI;
		Mura.lmv=2;
	
		<cfif url.contenttype eq 'Variation'>
			Mura('#mura-edit-var-targetingjs').click(function(e){
				e.preventDefault();
	
				if(editingVariations){
					return;
				}
	
				Mura('#adminQuickEdit').css('text-decoration','line-through');
				Mura('.mura-edit-toolbar-content').remove();
				Mura('#adminStatus').hide();
				Mura('#adminSave').show();
				Mura('.mura-inline-cancel').click(function(){
					MuraInlineEditor.reload();
				});
	
				editingVariations=false;
				window.muraInlineEditor.resetEditableAttributes();
	
				while(Mura.variations.length){
					var last=Mura.variations.length-1;
					Mura(Mura.variations[last].selector).html(Mura.variations[last].original);
					Mura.variations.pop();
				}
	
				Mura('.mxp-dynamic-id').each(function(){
					var item=Mura(this);
					item.removeAttr('id');
					item.removeClass('mxp-dynamic-id');
				});
	
	
				if(targetingVariations){
					return;
				}
	
				targetingVariations=true;
	
				styles='<style type="text/css">.mxp-editable,  .mxp-editable.mxp-editable-target {';
				styles+='	outline-width: 2px;';
				styles+='	outline-style: solid;';
				styles+='   outline-color: red;';
				styles+='}';
				styles+='.mxp-editable-target {';
				styles+='    outline-width: 2px;';
				styles+='    outline-style: solid;';
				styles+='    outline-color: blue;';
				styles+='}</style>';
	
				document.head.innerHTML += styles;
	
				Mura(function(){
					selectors=[];
	
					Mura('p,div,td,h1,h2,h3,h4,h5,article,nav,main,aside,header,footer,a,li,ul,ol,dl,dd,dt').hover(
						function(e){
							if(!editingVariations){
								var target=Mura(e.target);
								if(!target.closest('.mura').length && !target.closest(".mura-object").length){
									target.addClass('mxp-editable-target');
								}
							}
						},
						function(e){
							Mura(e.target).removeClass('mxp-editable-target');
						}
					)
	
				});
	
				Mura(document).click(function(e){
	
					if(!Mura(e.target).closest(".mura").length && !editingVariations){
						var item=Mura('.mxp-editable-target');
	
						if(item.length && !item.closest(".mura").length && !item.closest(".mura-object").length){
							if(item.hasClass('mxp-editable')){
								item.removeClass('mxp-editable');
							} else {
								var container=item.closest('.mxp-editable');
	
								if(container.length){
									container.removeClass('mxp-editable');
								}
	
								item.find('.mxp-editable').each(function(){
									Mura(this).removeClass('mxp-editable');
								});
	
								item.addClass('mxp-editable');
							}
	
						}
					}
				});
	
				Mura(document).on('click','a',function(e){
					if(!editingVariations){
						if(!Mura(this).closest(".mura").length){
							e.preventDefault();
						}
					}
				});
	
				Mura('.mura-inline-updatetargeting').click(function(){
					var selectors=[];
	
					Mura('.mxp-editable').each(function(){
						var item=Mura(this);
						selectors.push(item.selector());
					});
					
					function saveSelectors(){
						Mura.getFeed('variationTargeting')
							.where()
							.prop('contentid')
							.isEQ(Mura.contentid)
							.getQuery().then(function(collection){
								if(collection.length()){
									collection
										.item(0)
										.set('targetingjs',JSON.stringify(selectors))
										.save()
										.then(function(){
											MuraInlineEditor.reload();
										});
								} else {
									Mura.getEntity('variationTargeting')
										.set('targetingjs',JSON.stringify(selectors))
										.set('contentid',Mura.contentid)
										.save()
										.then(function(){
											MuraInlineEditor.reload();
										});
								}
							})
					}
	
					Mura.getEntity('content').loadBy('remoteid',Mura.remoteid).then(function(entity){
						if(entity.exists()){
							saveSelectors();
						} else {
							entity.set(
							{
								remoteid:Mura.remoteid,
								title:Mura.title,
								remoteurl:Mura.remoteurl,
								type: Mura.type,
								siteid: Mura.siteid,
								contenthistid: Mura.contenthistid,
								contentid: Mura.contentid,
								parentid: Mura.parentid,
								moduleid: Mura.moduleid,
								id: Mura.contenthistid,
								approved:1
							}
							).save().then(function(){
								saveSelectors();
							})
						}
					})
	
				})
			});
		</cfif>
		
		//This is only until we remove bs dropdowns from mura-toolbar
		if(typeof $ !='undefined'){
			$(function(){
				$("#frontEndTools .dropdown").hover(function(){
					$(this).toggleClass("show");
				});
			})
		}
	})(window);
	
