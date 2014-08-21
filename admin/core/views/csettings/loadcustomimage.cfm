 <cfset request.layout=false>
 <cfset rc.customImage=application.serviceFactory.getBean('imageSize').loadBy(sizeid=rc.sizeid)>
 <cfoutput>
 <div id="custom-image-form" data-sizeid="#rc.customImage.getSizeID()#" class="fieldset-wrap row-fluid">
	 <div class="fieldset">
      	<div class="control-group">
            <label class="control-label">Name</label>
            <div class="controls">
                <input id="custom-image-name" type="text" class="span12" value="#esapiEncode('html_attr',rc.customImage.getName())#"  onchange="removePunctuation(this);" maxlength="50"/>
             </div>
        </div>
         <div class="control-group">
            <label class="control-label">Height</label>
            <div class="controls">
                <input id="custom-image-height" class="span4" type="text" value="#rc.customImage.getHeight()#" maxlength="20"/>
            </div>
        </div>
       	<div class="control-group">
            <label class="control-label">Width</label>
            <div class="controls">
                <input id="custom-image-width" class="span4" type="text" value="#rc.customImage.getWidth()#" maxlength="20"/>
             </div>
        </div>
	</div>
</div>
</cfoutput>