<cfparam name="arguments.objectParams.imageSize" default="small">
<cfparam name="arguments.objectParams.imageHeight" default="auto">
<cfparam name="arguments.objectParams.imageWidth" default="auto">
<cfoutput>
<div id="svIndex" class="mura-index #this.folderWrapperClass#">
#variables.$.dspObject_include(
	theFile='collection/layouts/list/dsp_content_list.cfm', 
	type=arguments.objectParams.sourcetype, 
	iterator=variables.iterator,
	imageSize=arguments.objectParams.imageSize,
	imageWidth=arguments.objectParams.imageWidth,
	imageHeight=arguments.objectParams.imageHeight,
	fields=arguments.objectParams.displaylist
)#
</div>

#variables.$.dspObject_include(
	theFile='collection/dsp_pagination.cfm', 
	iterator=iterator, 
	nextN=iterator.getNextN(),
	source=arguments.objectParams.source
)#

<cfif len(arguments.objectParams.viewalllink)>
	<a class="view-all" href="#arguments.objectParams.viewalllink#">#HTMLEditFormat(arguments.objectParams.viewalllabel)#</a>
</cfif>
</cfoutput>