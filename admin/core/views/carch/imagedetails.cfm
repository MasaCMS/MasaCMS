
<cfset $=application.serviceFactory.getBean('$').init(session.siteID)>
<cfset rc.contentBean=$.getBean('content').loadBy(contentHistID=rc.contentHistID)>

<cfif not (isDefined('rc.fileID') and len(rc.fileID))>
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

<cfsavecontent variable="rc.headertext">
<cfoutput>
  <script src="#$.globalConfig('content')#/tasks/widgets/jcrop/js/jquery.Jcrop.js" type="text/javascript"></script>
    <link rel="stylesheet" href="#$.globalConfig('content')#/tasks/widgets/jcrop//css/jquery.Jcrop.css" type="text/css" />
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#rc.headertext#">

<cfoutput>
<h2>Image Details</h2>

<ul class="navTask nav nav-pills">
	<li><a href="./index.cfm?muraAction=cArch.edit&contenthistid=#rc.contentBean.getContentHistID()#&contentid=#rc.contentBean.getContentID()#&type=#rc.contentBean.getType()#&parentid=#rc.contentBean.getParentID()#&siteid=#rc.contentBean.getSiteID()#&moduleid=00000000000000000000000000000000000&startrow=1">Back to Content Form</a></li>
</ul>

<cfif len(rc.fileID)>

	<cfloop list="#rc.fileID#" index="f">	
		<cfset rc.sourceImage=$.getURLForImage(fileID=f,size='source')>
		<cfif len(rc.sourceImage)>		
			<cfset rc.rsMeta=$.getBean('fileManager').readMeta(fileID=f)>
			<h3>#HTMLEditFormat(rc.rsMeta.filename)#</h3>
			<div class="control-group">
			<label class="control-label">Small</label>
			<div class="controls">
				<img id="small#f#" src="#$.getURLForImage(fileID=f,size='small')#?cacheID=#createUUID()#"/>
				<a href="##" class="cropper" data-fileid="#f#" data-src="#rc.sourceImage#" data-filename="#rc.rsMeta.filename#" data-ratio="#rc.smallImageRatio#" data-size="small">Re-Crop</a>
			</div>
			</div>
			<div class="control-group">
			<label class="control-label">Medium</label>
			<div class="controls">
				<img id="medium#f#" src="#$.getURLForImage(fileID=f,size='medium')#?cacheID=#createUUID()#"/>
				<a href="##" class="cropper" data-fileid="#f#" data-src="#rc.sourceImage#" data-filename="#rc.rsMeta.filename#" data-ratio="#rc.mediumImageRatio#" data-size="medium">Re-Crop</a>
			</div>
			</div>		
			<div class="control-group">
			<label class="control-label">Large</label>
			<div class="controls">
				<img id="large#f#" src="#$.getURLForImage(fileID=f,size='large')#?cacheID=#createUUID()#"/>
				<a href="##" class="cropper" data-fileid="#f#" data-src="#rc.sourceImage#" data-filename="#rc.rsMeta.filename#" data-ratio="#rc.largeImageRatio#" data-size="large">Re-Crop</a>
			</div>
			</div>
		</cfif>
	</cfloop>

	<!-- Hidden dialog 
   	<div style="display:none;" id="jc-container" >
		<div class="jc-dialog">
		   	<img id="jc-source-image"/>
		</div>
    </div>
    -->
  
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
	   var date = new Date();
	   obj.src = src + '?v=' + date.getTime();
	   return false;
	}

    function saveCoords(c){currentCoords=c};

    function applyCropping(){
    	$('##applyingCoords').show();
    	$('##applyCoords').hide();
 
    	jQuery.get('./index.cfm?muraAction=carch.cropimage&fileid=' + currentFileID + '&size=' + currentSize + '&x=' + currentCoords.x + '&y=' + currentCoords.y + '&width=' + currentCoords.w + '&height=' + currentCoords.h + '&siteid=' + siteid,
							function(data) {
								//alert(data);
								reloadImg(currentSize + currentFileID);
								$('##cropper').remove()
							}
						);		
    }

    $('.cropper').click(
    	function(){

    		currentFileID=$(this).attr('data-fileid');
			currentSize=$(this).attr('data-size');

    		var jcrop_api; 
    		var $dialogHTML='<div id="cropper"><div class="jc-dialog">';
    			$dialogHTML+='<img id="crop-target" src="' + $(this).attr('data-src') + '" /> '; 
    			$dialogHTML+='<br/><input type="hidden" name="coords" value="" id="coords">'; 
    			$dialogHTML+='<input class="btn" type="button"id="applyCoords" value="Apply Cropping" onclick="applyCropping();">';
    			$dialogHTML+='<img id="applyingCoords" src="./assets/images/progress_bar.gif" style="display:none">';
    			$dialogHTML+='</div></div>';

	        var $dialog = $($dialogHTML);
	        var title=$(this).attr('data-filename');
	        var scaleby=$(this).attr('data-scaleby');
	        var aspectRatio=$(this).attr('data-ratio');
	        $dialog.find('##crop-target').Jcrop({ boxHeight:600,boxWidth:600,aspectRatio:aspectRatio,onSelect:saveCoords,onChange:saveCoords},function(){
		        jcrop_api = this;
		        $dialog.dialog({
		            modal: true,
		            title: title,
		            close: function(){ $dialog.remove(); },
		            width: jcrop_api.getWidgetSize()[0]+4,
		            resizable: false,
		        });
    		});
    });
	</script>
	
    <!-- /Hidden dialog -->
<cfelse>
	<p class="notice">This content does not have any image attached to it.</p>
</cfif>
</cfoutput>