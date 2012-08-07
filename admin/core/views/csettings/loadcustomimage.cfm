 <cfset request.layout=false>
 <cfset rc.customImage=application.serviceFactory.getBean('imageSize').loadBy(sizeid=rc.sizeid)>
 <cfoutput>
 <div class="control-group" id="custom-image-form" data-sizeid="#rc.customImage.getSizeID()#">
      <div class="controls">
      	<div class="control-group">
            <label class="control-label">Name</label>
            <div class="controls">
                <input id="custom-image-name" class="text" value="#HTMLEditFormat(rc.customImage.getName())#" />
             </div>
        </div>
         <div class="control-group">
            <label class="control-label">Height</label>
            <div class="controls">
                <input id="custom-image-height" class="text" value="#rc.customImage.getHeight()#" />
            </div>
        </div>
       	<div class="control-group">
            <label class="control-label">Width</label>
            <div class="controls">
                <input id="custom-image-width" class="text" value="#rc.customImage.getWidth()#" />
             </div>
        </div>     
    </div>   
</div>
</cfoutput>