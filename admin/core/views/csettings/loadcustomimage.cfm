 <cfset request.layout=false>
 <cfset rc.customImage=application.serviceFactory.getBean('imageSize').loadBy(sizeid=rc.sizeid)>
 <cfoutput>
 <div id="custom-image-form" data-sizeid="#rc.customImage.getSizeID()#" class="mura-layout-row">
  	<div class="mura-control-group">
        <label>Name</label>
        <input id="custom-image-name" type="text" value="#esapiEncode('html_attr',rc.customImage.getName())#"  onchange="removePunctuation(this);" maxlength="50"/>
    </div>
     <div class="mura-control-group">
        <label>Height</label>
        <input id="custom-image-height" type="text" value="#rc.customImage.getHeight()#" maxlength="20"/>
    </div>
   	<div class="mura-control-group">
        <label>Width</label>
        <input id="custom-image-width" type="text" value="#rc.customImage.getWidth()#" maxlength="20"/>
    </div>
</div>
</cfoutput>