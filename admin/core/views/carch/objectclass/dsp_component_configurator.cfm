<cfset content=rc.$.getBean('content').loadBy(contentid=rc.objectid)>
<cfoutput>
<div id="availableObjectParams"
		data-object="#esapiEncode('html_attr',rc.classid)#" 
		data-name="#esapiEncode('html_attr',content.getTitle())#" 
		data-objectid="#esapiEncode('html_attr',rc.objectid)#">
	<h2>#esapiEncode('html',content.getTitle())#</h2>
	<cfif rc.configuratorMode eq "frontEnd"
			and application.permUtility.getDisplayObjectPerm(content.getSiteID(),"component",content.getContentID()) eq "editor">
	<ul class="navTask nav nav-pills">
		<li><a href="#content.getEditURL(compactDisplay=true)#&homeid=#esapiEncode('html_attr',rc.contentid)#">Edit Component</a></li>
	</ul>
	</cfif>
</div>
</cfoutput>