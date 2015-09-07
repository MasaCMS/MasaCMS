<cfset content=rc.$.getBean('content').loadBy(contentid=rc.objectid)>
<cfoutput>
<div id="availableObjectParams"
		data-object="#esapiEncode('html_attr',rc.classid)#" 
		data-name="#esapiEncode('html_attr',content.getTitle())#" 
		data-objectid="#esapiEncode('html_attr',rc.objectid)#">
	
	<cfif listFindNoCase('Author,Editor',application.permUtility.getDisplayObjectPerm(content.getSiteID(),"component",content.getContentID()))>
		<script>
			window.location='#content.getEditURL(compactDisplay=true)#&homeid=#esapiEncode('url',rc.contentid)#';
		</script>
	<cfelse>
		<p class="alert alert-error">
			You do not have permission to edit this form.
		</p>	
	</cfif>

	<!---
	<cfif rc.configuratorMode eq "frontEnd"
			and application.permUtility.getDisplayObjectPerm(content.getSiteID(),"form",content.getContentID()) eq "editor">
	<ul class="navTask nav nav-pills">
		<li><a href="#content.getEditURL(compactDisplay=true)#&homeid=#esapiEncode('html_attr',rc.contentid)#">Edit Form</a></li>
	</ul>
	</cfif>
	--->
</div>
</cfoutput>