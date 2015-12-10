<cfparam name="arguments.objectParams.imageSize" default="small">
<cfparam name="arguments.objectParams.imageHeight" default="auto">
<cfparam name="arguments.objectParams.imageWidth" default="auto">
<cfoutput>
<div id="svIndex" class="mura-index #this.folderWrapperClass#">
#variables.$.dspObject_include(
	theFile='dsp_content_list.cfm', 
	type=arguments.objectParams.sourcetype, 
	iterator=variables.iterator,
	imageSize=arguments.objectParams.imageSize,
	imageWidth=arguments.objectParams.imageWidth,
	imageHeight=arguments.objectParams.imageHeight,
	fields=arguments.objectParams.displaylist
)#
</div>
</cfoutput>