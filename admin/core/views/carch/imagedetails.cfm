
<cfsilent>
<cfparam name="rc.imagesize" default="">
<cfparam name="rc.found" default="false">
<cfparam name="rc.instanceid" default="">

<cfset $=application.serviceFactory.getBean('$').init(session.siteID)>
<cfif isDefined('url.userid')>
	<cfset rc.userBean=$.getBean('user').loadBy(userID=rc.userID,siteID=rc.siteID)>
<cfelseif isDefined('url.contentHistID')>
	<cfset rc.contentBean=$.getBean('content').loadBy(contentHistID=rc.contentHistID)>
</cfif>

<cfif (not (isDefined('rc.fileID') and len(rc.fileID))) and isDefined('rc.contentBean')>
	<cfset rc.rsfileAttributes=rc.contentBean.getExtendedData().getAttributesByType('File')>
	<cfset rc.fileID=listAppend(
				valueList(rc.rsfileAttributes.attributeValue),
				rc.contentBean.getFileID()
			)>
</cfif>

<cfif isNumeric($.siteConfig('smallImageHeight')) and isNumeric($.siteConfig('smallImageWidth'))>
	<cfset rc.smallImageRatio=$.siteConfig('smallImageWidth')/$.siteConfig('smallImageHeight')>
<cfelse>
	<cfset rc.smallImageRatio=''>
</cfif>

<cfif isNumeric($.siteConfig('mediumImageHeight')) and isNumeric($.siteConfig('mediumImageWidth'))>
	<cfset rc.mediumImageRatio=$.siteConfig('mediumImageWidth')/$.siteConfig('mediumImageHeight')>
<cfelse>
	<cfset rc.mediumImageRatio=''>
</cfif>

<cfif isNumeric($.siteConfig('largeImageHeight')) and isNumeric($.siteConfig('largeImageWidth'))>
	<cfset rc.largeImageRatio=$.siteConfig('largeImageWidth')/$.siteConfig('largeImageHeight')>
<cfelse>
	<cfset rc.largeImageRatio=''>
</cfif>

<cfset csrf=rc.$.renderCSRFTokens(context=rc.fileid,format='url')>

<cfsavecontent variable="rc.headertext">
<cfoutput>
<script src="#$.globalConfig('context')##$.globalConfig('adminDir')#/assets/js/jquery/jquery.Jcrop.min.js" type="text/javascript"></script>
<link rel="stylesheet" href="#$.globalConfig('context')##$.globalConfig('adminDir')#/assets/css/jquery/jquery.Jcrop.min.css" type="text/css" />
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#rc.headertext#">
</cfsilent>
<cfoutput>

<!--- mura-header --->
<div class="mura-header">
	<h1>Image Details</h1>

	<cfif rc.compactDisplay neq "true">

	<cfinclude template="dsp_secondary_menu.cfm">

	<div class="mura-item-metadata">
		<div class="label-group">
			<cfif not len(rc.imagesize)>

			<!---
			<cfelse>
				<div class="nav-module-specific btn-toolbar">
					<div class="btn-group">
						<a href="javascript:frontEndProxy.post({cmd:'close'});" class="btn"><i class="mi-arrow-circle-left"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.back'))#</a>
					</div>
				</div>
			--->
			</cfif>

		</div> <!-- /label-group -->
	</div> <!-- /metadata -->
	</cfif>

	<cfif not len(rc.imagesize) and  rc.compactDisplay neq "true" and isDefined('rc.contentBean')>
		#$.dspZoom(crumbdata=rc.contentBean.getCrumbArray(),class="breadcrumb")#
	</cfif>

</div>
<!--- /mura-header --->

<div class="block block-constrain">
<div id="image-details">
	<div class="block-content">
	<cfif len(rc.fileID)>
		<script>
			fileMap={};
		</script>
		<cfloop list="#rc.fileID#" index="f">
			<cfset $.getBean('fileManager').touchSourceImage(f)>
			<cfset rc.sourceImage=$.getURLForImage(fileID=f,size='source')>

			<cfif len(rc.sourceImage)>
				<cfset sourceImage=$.getBean('fileManager').readSourceImage(f)>
				<script>
					fileMap['#esapiEncode('javascript',f)#']={height:0,width:0};
					<cfif structKeyExists(sourceImage,'Image Height') and isNumeric(listFirst(sourceImage['Image Height'],' '))>
					fileMap['#esapiEncode('javascript',f)#'].height=#esapiEncode('javascript',listFirst(sourceImage['Image Height'],' '))#;
					</cfif>
					<cfif structKeyExists(sourceImage,'Image Width') and isNumeric(listFirst(sourceImage['Image Width'],' '))>
					fileMap['#esapiEncode('javascript',f)#'].width=#esapiEncode('javascript',listFirst(sourceImage['Image Width'],' '))#;
					</cfif>
				</script>
				<cfset rc.rsMeta=$.getBean('fileManager').readMeta(fileID=f)>
				<h2><i class="mi-picture-o"></i> #esapiEncode('html',rc.rsMeta.filename)#</h2>

				<cfif not len(rc.imagesize)>
					<div id="image-orientation" class="mura-control-group">
						<label class="mura-control-label">
							#esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.adjustimage'))#
						</label>
							<select id="image-actions#f#">
								<option value="">Please Select</option>
								<option value="90"> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.rotateimage'))# &ndash; 90&deg;</option>
								<option value="180"> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.rotateimage'))# &ndash; 180&deg;</option>
								<option value="270"> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.rotateimage'))# &ndash; 270&deg;</option>
								<option value="horizontal"> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.flipimage'))# &ndash; Horizontal</option>
								<option value="vertical"> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.flipimage'))# &ndash; Vertical</option>
								<option value="diagonal"> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.flipimage'))# &ndash; Diagonal</option>
								<option value="antidiagonal"> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.flipimage'))# &ndash; Anti-Diagonal</option>
							</select>
							<div class="mura-control justify">
								<input type="button" onclick="flipImage('#esapiEncode('javascript',f)#');" class="btn" value="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.apply'))#"/>
							</div>
						</div>

					<cfloop list="Small,Medium,Large" index="s">
						<div class="mura-control-group">
							<label class="mura-control-label">#s# (#$.siteConfig('#s#ImageWidth')#x#$.siteConfig('#s#ImageHeight')#)</label>

							<div id="#lcase(s)##f#btns" class="btn-group">
									<button type="button" class="btn btn-default btn-small cropper-reset" data-fileid="#f#" data-size="#lcase(s)#"><i class="mi-refresh"></i> Reset</button>
									<button type="button" class="btn btn-default btn-small cropper" data-fileid="#f#" data-src="#rc.sourceImage#" data-filename="#rc.rsMeta.filename#" data-height="#$.siteConfig('#s#ImageHeight')#" data-width="#$.siteConfig('#s#ImageWidth')#" data-ratio="#evaluate('rc.#s#ImageRatio')#" data-size="#lcase(s)#"><i class="mi-crop"></i> Re-Crop</button>
							</div>

							<div class="mura-control justify">
								<div id="#lcase(s)##f#loader" class="load-inline" style="display:none"></div>
								<img id="#lcase(s)##f#" class="img-responsive" style="max-width:#$.siteConfig('#s#ImageWidth')#px;" src="#$.getURLForImage(fileID=f,size=lcase(s),useProtocol=false)#?cacheID=#createUUID()#"/>
							</div>
						</div>
					</cfloop>
					<cfset imageSizes=application.settingsManager.getSite(rc.siteid).getCustomImageSizeIterator()>
					<cfloop condition="imageSizes.hasNext()">
						<cfset customImage=imageSizes.next()>
						<cfif isNumeric(customImage.getHeight()) and isNumeric(customImage.getWidth())>
							<cfset rc.customImageRatio=customImage.getWidth()/customImage.getHeight()>
						<cfelse>
							<cfset rc.customImageRatio=''>
						</cfif>
						<div class="mura-control-group">
							<label class="mura-control-label">#esapiEncode('html',customImage.getName())# (#customImage.getWidth()#x#customImage.getHeight()#)</label>

							<div id="#lcase(customImage.getName())##f#btns" class="btn-group">
									<button type="button" class="btn btn-default btn-small cropper-reset" data-fileid="#f#" data-size="#lcase(customImage.getName())#"><i class="mi-refresh"></i> Reset</button>
									<button type="button" class="btn btn-default btn-small cropper" data-fileid="#f#" data-src="#rc.sourceImage#" data-filename="#rc.rsMeta.filename#" data-height="#customImage.getHeight()#"  data-width="#customImage.getWidth()#" data-ratio="#rc.customImageRatio#" data-size="#lcase(customImage.getName())#"><i class="mi-crop"></i> Re-Crop</button>
							</div>

							<div class="mura-control justify">
								<div id="#lcase(customImage.getName())##f#loader" class="load-inline" style="display:none"></div>
								<img class="mura-custom-image img-responsive" data-fileid="#f#" data-size="#lcase(customImage.getName())#" id="#lcase(customImage.getName())##f#" style="max-width:#customImage.getWidth()#px;" src=""/>
							</div>
						</div>
					</cfloop>
				<cfelse>
					<cfset rc.found=false>
					<cfif listFindNoCase('Small,Medium,Large',rc.imagesize)>
						<cfset found=true>
						<cfset s=ucase(left(rc.imagesize,1)) & lcase(right(rc.imagesize,len(rc.imagesize)-1))>
						<div class="mura-control-group">
							<label class="mura-control-label">#s# (#$.siteConfig('#s#ImageWidth')#x#$.siteConfig('#s#ImageHeight')#)</label>

							<div id="#lcase(s)##f#btns" class="btn-group">
								<button type="button" class="btn btn-default btn-small cropper-reset" data-fileid="#f#" data-size="#lcase(s)#"><i class="mi-refresh"></i> Reset</button>
								<button type="button" class="btn btn-default btn-small cropper" data-fileid="#f#" data-src="#rc.sourceImage#" data-filename="#rc.rsMeta.filename#"  data-height="#$.siteConfig('#s#ImageHeight')#" data-width="#$.siteConfig('#s#ImageWidth')#" data-ratio="#evaluate('rc.#s#ImageRatio')#" data-size="#lcase(s)#"><i class="mi-crop"></i> Re-Crop</button>
							</div>

							<div class="mura-control justify">
								<div id="#lcase(s)##f#loader" class="load-inline" style="display:none"></div>
								<img id="#lcase(s)##f#" class="img-responsive" style="max-width:#$.siteConfig('#s#ImageWidth')#px" src="#$.getURLForImage(fileID=f,size=lcase(s),useProtocol=false)#?cacheID=#createUUID()#"/>
							</div>
						</div>
					<cfelse>
						<cfset imageSizes=application.settingsManager.getSite(rc.siteid).getCustomImageSizeIterator()>
						<cfloop condition="imageSizes.hasNext()">
							<cfset customImage=imageSizes.next()>
							<cfif customImage.getName() eq rc.imagesize>
								<cfif isNumeric(customImage.getHeight()) and isNumeric(customImage.getWidth())>
									<cfset rc.customImageRatio=customImage.getWidth()/customImage.getHeight()>
								<cfelse>
									<cfset rc.customImageRatio=''>
								</cfif>
								<div class="mura-control-group">
									<label class="mura-control-label">#esapiEncode('html',customImage.getName())# (#customImage.getWidth()#x#customImage.getHeight()#)</label>

									<div id="#lcase(customImage.getName())##f#btns" class="btn-group">
										<button type="button" class="btn btn-default btn-small cropper-reset" data-fileid="#f#" data-size="#lcase(customImage.getName())#"><i class="mi-refresh"></i> Reset</button>
										<button type="button" class="btn btn-default btn-small cropper" data-fileid="#f#" data-src="#rc.sourceImage#" data-filename="#rc.rsMeta.filename#" data-height="#customImage.getHeight()#"  data-width="#customImage.getWidth()#" data-ratio="#rc.customImageRatio#" data-size="#lcase(customImage.getName())#"><i class="mi-crop"></i> Re-Crop</button>
									</div>

									<div class="mura-control justify">
										<div id="#lcase(customImage.getName())##f#loader" class="load-inline" style="display:none"></div>
										<img class="mura-custom-image" data-fileid="#f#" data-size="#lcase(customImage.getName())#" id="#lcase(customImage.getName())##f#" src=""/>
									</div>
								</div>
								<cfset rc.found=true>
								<cfbreak>
							</cfif>
						</cfloop>

						<cfif not rc.found and listLen(rc.imagesize,'_') eq 2>
							<cfset customImage=rc.$.getBean('imageSize')>
							<cfset customImage.setName(rc.imagesize)>
							<cfset customImage.setHeight('AUTO')>
							<cfset customImage.setWidth('AUTO')>
							<cfset customImage.setSiteID(rc.siteid)>
							<cfset customImage.parseName()>

							<cfif isNumeric(customImage.getHeight()) and isNumeric(customImage.getWidth())>
								<cfset rc.customImageRatio=customImage.getWidth()/customImage.getHeight()>
							<cfelse>
								<cfset rc.customImageRatio=''>
							</cfif>
							<div class="mura-control-group">
								<label class="mura-control-label">#esapiEncode('html',customImage.getName())# (#customImage.getWidth()#x#customImage.getHeight()#)</label>

								<div id="#lcase(customImage.getName())##f#btns" class="btn-group">
									<button type="button" class="btn btn-default btn-small cropper-reset" data-fileid="#f#" data-size="#lcase(esapiEncode('html_attr',rc.imagesize))#" data-height="#customImage.getHeight()#"  data-width="#customImage.getWidth()#"><i class="mi-refresh"></i> Reset</button>
									<button type="button" class="btn btn-default btn-small cropper" data-fileid="#f#" data-src="#rc.sourceImage#" data-filename="#rc.rsMeta.filename#" data-height="#customImage.getHeight()#"  data-width="#customImage.getWidth()#" data-ratio="#rc.customImageRatio#" data-size="#lcase(esapiEncode('html_attr',rc.imagesize))#"><i class="mi-crop"></i> Re-Crop</button>
								</div>

								<div class="mura-control justify">
									<img id="#lcase(esapiEncode('html_attr',rc.imagesize))##f#"
									src="#$.getURLForImage(fileID=f,size='custom',height=customImage.getHeight(),width=customImage.getWidth(),useProtocol=false)#?cacheID=#createUUID()#"
									<cfif isNumeric(customImage.getWidth())> width="#customImage.getWidth()#"</cfif>
									<cfif isNumeric(customImage.getHeight())> width="#customImage.getHeight()#"</cfif>
									>
								</div>

							</div>
						</cfif>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>

    <script>
    var currentFileID='';
    var currentCoords='';
		var currentSize='';
		var instanceid='#esapiEncode("javascript",rc.instanceid)#';

		$('body').addClass('no-constrain');

		function reloadImg(id) {
		   var obj = document.getElementById(id);
		   var src = obj.src;

		   var pos = src.indexOf('?');
		   if (pos >= 0) {
		      src = src.substr(0, pos);
		   }

		   obj.src = src + '?v=' + Math.random();

		   if(instanceid && window.frontEndProxy){
		   		frontEndProxy.post({cmd:'setImageSrc',instanceid:instanceid,src:obj.src});
		   }

		   return false;
		}

		function setImg(id,src) {
		   var obj = document.getElementById(id);

		   var pos = src.indexOf('?');
		   if (pos >= 0) {
		      src = src.substr(0, pos);
		   }

		   obj.src = src + '?v=' + Math.random();

		   return false;
		}

		function resizeImg(id,w,h) {
		   $('##'+ id).css({'height':h,'width':w});
		   return false;
		}

    function flipImage(fileid){
			var _fileid=fileid;
			var transpose=$('##image-actions' + fileid).val()
    	//location.href='./index.cfm?muraAction=carch.flipimage&fileid=' + currentFileID + '&siteid=' + siteid;

    	if(transpose != ''){
    		//alert(transpose);
    		actionModal(
	    		function(){
			   		 $.get('./index.cfm?muraAction=carch.flipimage&fileid=' + _fileid + '&siteid=' + siteid + '&transpose=' + transpose + '#csrf#&cacheid=' + Math.random(),
						function(){
				    		$('##action-modal').remove();
								$(".cropper-reset[data-fileid='" + _fileid + "']").each(function(){
								var resetFileID=$(this).attr('data-fileid');
								var resetSize=$(this).attr('data-size');

								$.ajax(
							    	{
							    		url:'./index.cfm?muraAction=carch.cropimage&fileid=' + resetFileID + '&size=' + resetSize + '&siteid=' + siteid + '#csrf#&cacheid=' + Math.random(),
										success: function(data) {
												//alert(JSON.stringify(data));
												reloadImg(resetSize + resetFileID);
												resizeImg(resetSize + resetFileID,data.width,data.height);
												return false;
											}	,
										async:   false
									}
								);
							});
				    	}
						);
			   	}
				);
			}
			return false;
	  }

	    function saveCoords(c){currentCoords=c};

	    function applyCropping(){

	    	actionModal(function(){
			    //$('##cropper .btn').hide();
			 		//location.href='./index.cfm?muraAction=carch.cropimage&fileid=' + currentFileID + '&size=' + currentSize + '&x=' + currentCoords.x + '&y=' + currentCoords.y + '&width=' + currentCoords.w + '&height=' + currentCoords.h + '&siteid=' + siteid;
			 		if(typeof(currentCoords) == 'object'){
			    	$.get('./index.cfm?muraAction=carch.cropimage&fileid=' + currentFileID + '&size=' + currentSize + '&x=' + currentCoords.x + '&y=' + currentCoords.y + '&width=' + currentCoords.w + '&height=' + currentCoords.h + '&siteid=' + siteid + '#csrf#&cacheid=' + Math.random(),
							function(data) {
								//alert(JSON.stringify(data));
								reloadImg(currentSize + currentFileID);
								resizeImg(currentSize + currentFileID,data.width,data.height);
								$('##cropper').remove()
								$('##action-modal').remove();
							}
						);
					} else {
						$('##cropper').remove();
						$('##action-modal').remove();
					}
				}
			);
	    }

	    $('.cropper-reset').click(
	    	function(){
	    		$('##action-modal').remove();
	    		var resetFileID=$(this).attr('data-fileid');
					var resetSize=$(this).attr('data-size');
					//alert(resetSize + resetFileID);

		    		//location.href='./index.cfm?muraAction=carch.cropimage&fileid=' + resetFileID + '&size=' + resetSize + '&siteid=' + siteid;
					var url='./index.cfm?muraAction=carch.cropimage&fileid=' + resetFileID + '&size=' + resetSize + '&siteid=' + siteid + '#csrf#&cacheid=' + Math.random();

					if($(this).attr('data-height')){
						url= url + '&height=' + $(this).attr('data-height');
					}

					if($(this).attr('data-width')){
						url = url + '&width=' + $(this).attr('data-width');
					}

					actionModal(function(){
					    $.ajax(
					    	{
					    		url:url,
								success: function(data) {
											//alert(JSON.stringify(data));

											reloadImg(resetSize + resetFileID);
											resizeImg(resetSize + resetFileID,data.width,data.height);
							    			$('##action-modal').remove();
										},
								async:   true
							}
						)}
					);

		    });
		<!---
		<cfif not len(rc.imagesize)>
		--->
	    $('.cropper').click(
	    	function(){

	    	currentFileID=$(this).attr('data-fileid');
				currentSize=$(this).attr('data-size');
				currentCoords='';

    		var jcrop_api;
    		var $dialogHTML='<div id="cropper"><div class="jc-dialog">';
  			$dialogHTML+='<img id="crop-target" src="' + $(this).attr('data-src') + '?cacheid=' + Math.random() +'" /> ';
  			$dialogHTML+='<input type="hidden" name="coords" value="" id="coords">';
				$dialogHTML+='<div class="ui-dialog-buttonpane ui-widget-content ui-helper-clearfix"><div class="ui-dialog-buttonset"><button type="button" class="mura-cancel ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" role="button" onclick="$(this).closest(\'.ui-dialog-content\').dialog(\'close\');"><span class="ui-button-text">Cancel</span></button><button type="button" class="mura-primary ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" role="button" onclick="applyCropping();"><span class="ui-button-text">Apply Cropping</span></button></div></div>';

				$dialogHTML+='</div></div>';

        var $dialog = $($dialogHTML);
        var title=$(this).attr('data-filename');
        var scaleby=$(this).attr('data-scaleby');
        var aspectRatio=$(this).attr('data-ratio');
				var minSize=[];
				var height=$(this).attr('data-height');
				var width=$(this).attr('data-width')

				if(typeof width != 'undefined' && width.toString().toLowerCase() == 'auto'
					|| typeof height != 'undefined' && height.toString().toLowerCase() == 'auto'
				){
					if(typeof width == 'undefined' || width.toString().toLowerCase() == 'auto'){
						width=0;
					}
					if(typeof height == 'undefined' || height.toString().toLowerCase() == 'auto'){
						height=0;
					}
					var sizeArray=[width,height]
				} else {
					var sizeArray=[0,0]
				}

				if(sizeArray[0] && sizeArray[0] > fileMap[currentFileID].width ){
					sizeArray[0]=0;
				}

				if(sizeArray[1] && sizeArray[10] > fileMap[currentFileID].heigth ){
					sizeArray[1]=0;
				}

        actionModal(function(){
	       	 $dialog.find('##crop-target').Jcrop(
	       	 	{
	       	 		boxHeight:600,
	       	 		boxWidth:600,
							minSize:sizeArray,
	       	 		aspectRatio:aspectRatio,
	       	 		onSelect:saveCoords,
	       	 		onChange:saveCoords
	       	 	},
	       	 	function(){
			        jcrop_api = this;
			        $dialog.dialog({
			            modal: true,
			            title: title,
			            close: function(){ $dialog.remove(); },
			            width: jcrop_api.getWidgetSize()[0]+68,
			            resizable: false,
			            class: "cropper"
			        });
			        $('##action-modal').remove();
    			});
       	});
	    });


		$(document).ready(function(){

			$('.load-inline').spin(spinnerArgs2);

			var delay=0;

			$('.mura-custom-image').each(
				function(){
					var self=this;

					setTimeout(function(){
							$.getJSON('./?muraAction=carch.getImageSizeURL&siteid=#esapiEncode("url",rc.siteid)#&fileid=' + $(self).data('fileid') + '&size=' + $(self).data('size'))
							.then(function(data){
								var target=$(self).data('size') + $(self).data('fileid');
								setImg(target,data);
							});
						},
						delay
					)

					delay=delay + 5;

				}
			);

			<cfif rc.compactDisplay eq "true">
			if (top.location != self.location) {
				if(jQuery("##ProxyIFrame").length){
					jQuery("##ProxyIFrame").load(
						function(){
							frontEndProxy.post({cmd:'setWidth',width:'standard'});
						}
					);
				} else {
					frontEndProxy.post({cmd:'setWidth',width:'standard'});
				}
			}
			</cfif>
		});
		<!---
		<cfelse>
		$(document).ready(function(){
			var customImage=$('###lcase(esapiEncode('html_attr',rc.imagesize))##f#');

			/*
			$('.load-inline').spin(spinnerArgs2);

			$('.mura-custom-image').each(
				function(){
					var self=this;

					$.getJSON('./?muraAction=carch.getImageSizeURL&siteid=#esapiEncode("url",rc.siteid)#&fileid=' + $(this).data('fileid') + '&size=' + $(this).data('size'))
					.then(function(data){
						var target=$(self).data('size') + $(self).data('fileid');

						setImg(target,data);
					});

				}
			);
			*/

			customImage.Jcrop(
	       	 	{
	       	 		aspectRatio:customImage.attr('data-ratio'),
	       	 		onSelect:saveCoords,
	       	 		onChange:saveCoords
	       	 	}
    		);

			<cfif rc.compactDisplay eq "true">
			if (top.location != self.location) {
				if(jQuery("##ProxyIFrame").length){
					jQuery("##ProxyIFrame").load(
						function(){
							frontEndProxy.post({cmd:'setWidth',width:'standard'});
						}
					);
				} else {
					frontEndProxy.post({cmd:'setWidth',width:'standard'});
				}
			}
			</cfif>
		});
		</cfif>
		--->
		</script>

	    <!-- /Hidden dialog -->
	</div>
</div>
<cfelse>
	<div class="help-block-empty">This content does not have any image attached to it.</div>
</cfif>

<cfif isDefined("secondarynav")>
	<div class="mura-item-metadata">
		<div class="label-group">
	#secondarynav#
		</div> <!-- /label-group -->
	</div> <!-- /metadata -->
</cfif>

</div>
</cfoutput>
