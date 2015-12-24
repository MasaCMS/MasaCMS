<cfparam name="arguments.objectParams.imageSize" default="small">
<cfparam name="arguments.objectParams.imageHeight" default="auto">
<cfparam name="arguments.objectParams.imageWidth" default="auto">
<cfoutput>
#variables.$.dspObject_include(
	theFile='collection/layouts/list/index.cfm', 
	objectParams=arguments.objectParams
)#
</cfoutput>