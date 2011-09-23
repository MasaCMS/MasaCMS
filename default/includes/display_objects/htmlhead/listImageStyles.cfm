<cfsilent>
<cfset addToHeight = 10> <!--- Total number of pixels to add for the final height of the DL --->
<cfset minHeight = $.siteConfig('gallerySmallScale') + addToHeight> <!--- padding + border + margin of the top and bottom of the image --->
<cfset addToWidth = 10> <!--- Total number of pixels to add for the final padding i.e. the "gutter" taht the image lives in --->
<cfset totalPadding = $.siteConfig('gallerySmallScale') + addToWidth> <!--- padding + border + margin after image  --->
</cfsilent>

<cfoutput>
<style>						
.svIndex dl.hasImage {
<!--- Conditional styles for images constrained by width --->
<cfif $.siteConfig('gallerySmallScaleBy') eq 'x'>
padding-left: #totalPadding#px;

<!--- Conditional styles for images constrained by height --->
<cfelseif $.siteConfig('gallerySmallScaleBy') eq 'y'>
min-height: #minHeight#px;
<cfelse>

<!--- Styles for images cropped to square --->
min-height: #minHeight#px;
padding-left: #totalPadding#px;
</cfif>
}

</style>
</cfoutput>