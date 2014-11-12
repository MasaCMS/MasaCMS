
<cfsilent>
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
<script src="#$.globalConfig('context')#/admin/assets/js/jquery/jquery.Jcrop.min.js" type="text/javascript"></script>
<link rel="stylesheet" href="#$.globalConfig('context')#/admin/assets/css/jquery/jquery.Jcrop.min.css" type="text/css" />
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#rc.headertext#">
</cfsilent>
<cfoutput>
<h1>Image Details</h1>

<cfsavecontent variable="secondarynav">
	<cfinclude template="dsp_secondary_menu.cfm">
</cfsavecontent>

#secondarynav#

<cfif rc.compactDisplay neq "true" and isDefined('rc.contentBean')>
	#$.dspZoom(crumbdata=rc.contentBean.getCrumbArray(),class="navZoom alt")#
</cfif>

<div id="image-details" class="form-horizontal fieldset-wrap">
	<div class="fieldset">
	<cfif len(rc.fileID)>
		<cfloop list="#rc.fileID#" index="f">
			<cfset $.getBean('fileManager').touchSourceImage(f)>	
			<cfset rc.sourceImage=$.getURLForImage(fileID=f,size='source')>
			<cfif len(rc.sourceImage)>		
				<cfset rc.rsMeta=$.getBean('fileManager').readMeta(fileID=f)>
				<h2><i class="icon-picture"></i> #esapiEncode('html',rc.rsMeta.filename)#</h2>
				<div id="image-orientation" class="control-group">
					<label class="control-label">
						#esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.adjustimage'))#
					</label>
					<div class="controls">
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

						<input type="button" onclick="flipImage('#esapiEncode('javascript',f)#');" class="btn" value="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.apply'))#"/>
					</div>
				</div>

				<cfloop list="Small,Medium,Large" index="s">
					<div class="control-group">
						<label class="control-label">#s# (#$.siteConfig('#s#ImageWidth')#x#$.siteConfig('#s#ImageHeight')#)</label>
						<div class="controls">
							<div id="#lcase(s)##f#btns" class="btn-group">
								<button type="button" class="btn btn-small cropper-reset" data-fileid="#f#" data-size="#lcase(s)#"><i class="icon-refresh"></i> Reset</button>
								<button type="button" class="btn btn-small cropper" data-fileid="#f#" data-src="#rc.sourceImage#" data-filename="#rc.rsMeta.filename#" data-ratio="#evaluate('rc.#s#ImageRatio')#" data-size="#lcase(s)#"><i class="icon-screenshot"></i> Re-Crop</button>
							</div>
						</div>
						<div id="#lcase(s)##f#loader" class="load-inline" style="display:none"></div>
						<img id="#lcase(s)##f#" src="#$.getURLForImage(fileID=f,size=lcase(s))#?cacheID=#createUUID()#"/>
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
					<div class="control-group">
						<label class="control-label">#esapiEncode('html',customImage.getName())# (#customImage.getWidth()#x#customImage.getHeight()#)</label>
						<div class="controls">
							<div id="#lcase(customImage.getName())##f#btns" class="btn-group">
								<button type="button" class="btn btn-small cropper-reset" data-fileid="#f#" data-size="#lcase(customImage.getName())#"><i class="icon-refresh"></i> Reset</button>
								<button type="button" class="btn btn-small cropper" data-fileid="#f#" data-src="#rc.sourceImage#" data-filename="#rc.rsMeta.filename#" data-ratio="#rc.customImageRatio#" data-size="#lcase(customImage.getName())#"><i class="icon-screenshot"></i> Re-Crop</button>
							</div>
						</div>
						<div id="#lcase(customImage.getName())##f#loader" class="load-inline" style="display:none"></div>
						<img class="mura-custom-image" data-fileid="#f#" data-size="#lcase(customImage.getName())#" id="#lcase(customImage.getName())##f#" src="assets/images/ajax-loader.gif"/>
					</div>
				</cfloop>
			</cfif>
		</cfloop>
	
		<!-- Hidden dialog 
	   	<div style="display:none;" id="jc-container" >
			<div class="jc-dialog">
			   	<img id="jc-source-image"/>
			</div>
	    </div>
	    --->

	    <script>
	    var currentFileID='';
	    var currentCoords='';
		var currentSize='';
	
		function reloadImg(id) {
		   var obj = document.getElementById(id);
		   var src = obj.src;
		 
		   var pos = src.indexOf('?');
		   if (pos >= 0) {
		      src = src.substr(0, pos);
		   }
			
		   obj.src = src + '?v=' + Math.random();

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
				
				actionModal(function(){
				    $.ajax(
				    	{
				    		url:'./index.cfm?muraAction=carch.cropimage&fileid=' + resetFileID + '&size=' + resetSize + '&siteid=' + siteid + '#csrf#&cacheid=' + Math.random(),
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
		
	
	    $('.cropper').click(
	    	function(){
	
	    		currentFileID=$(this).attr('data-fileid');
				currentSize=$(this).attr('data-size');
				currentCoords='';
				
	    		var jcrop_api; 
	    		var $dialogHTML='<div id="cropper"><div class="jc-dialog">';
	    			$dialogHTML+='<img id="crop-target" src="' + $(this).attr('data-src') + '?cacheid=' + Math.random() +'" /> '; 
	    			$dialogHTML+='<input type="hidden" name="coords" value="" id="coords">'; 
	    			$dialogHTML+='<input class="btn" type="button" value="Cancel" onclick="$(\'##cropper\').remove();">';
	    			$dialogHTML+='<input class="btn" type="button"id="applyCoords" value="Apply Cropping" onclick="applyCropping();">';
	    			$dialogHTML+='</div></div>';
	
		        var $dialog = $($dialogHTML);
		        var title=$(this).attr('data-filename');
		        var scaleby=$(this).attr('data-scaleby');
		        var aspectRatio=$(this).attr('data-ratio');

		        actionModal(function(){
			       	 $dialog.find('##crop-target').Jcrop(
			       	 	{ 
			       	 		boxHeight:600,
			       	 		boxWidth:600,
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
					            width: jcrop_api.getWidgetSize()[0]+4,
					            resizable: false,
					        });
					        $('##action-modal').remove();
		    			});
		       	});
	    });

		
		$(document).ready(function(){
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
		
		</script>
		
	    <!-- /Hidden dialog -->
	</div>
</div>
<cfelse>
	<p class="alert">This content does not have any image attached to it.</p>
</cfif>

#secondarynav#
</cfoutput>