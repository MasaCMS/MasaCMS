<cfoutput>
<div id="svIndex" class="mura-index #this.folderWrapperClass#">
#variables.$.dspObject_include(
	theFile='dsp_content_list.cfm', 
	type='Portal', 
	iterator= variables.iterator,
	imageSize='small',
	fields=arguments.objectParams.displaylist
)#
</div>
</cfoutput>