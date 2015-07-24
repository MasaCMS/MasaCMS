<div id="availableObjectParams"
		data-object="#esapiEncode('html_attr',rc.classid)#" 
		data-name="#esapiEncode('html_attr',rc.name)#" 
		data-objectid="#esapiEncode('html_attr',rc.objectid)#">
<cfset content=rc.$.getBean('content').loadBy(contentid=rc.objectid)>

<cfif rc.configuratorMode eq "frontEnd"
		and application.permUtility.getDisplayObjectPerm(feed.getSiteID(),"feed",feed.getFeedD()) eq "editor">
<ul class="navTask nav nav-pills">
	<li><a href="#content.getEditURL(compactDisplay=true)#">Edit Form</a></li>
</ul>
</cfif>
</div>