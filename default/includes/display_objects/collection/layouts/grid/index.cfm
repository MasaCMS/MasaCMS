<cfsilent>
	<cfparam name="arguments.objectParams.gridstyle" default="layout-a">
	<cfparam name="arguments.objectParams.imageSize" default="medium">
	<cfparam name="arguments.objectParams.imageHeight" default="AUTO">
	<cfparam name="arguments.objectParams.imageWidth" default="AUTO">
	
	<cfset imageSizeArgs={
		size=arguments.objectParams.imageSize,
		height=arguments.objectParams.imageHeight,
		width=arguments.objectParams.imageWidth
	}>
	
	<cfif isDefined('this.contentGridStyleMap') and structKeyExists(this.contentGridStyleMap,'#arguments.objectParams.gridstyle#')>
		<cfset gridClasses=this.contentGridStyleMap['#arguments.objectParams.gridstyle#']>
	<cfelse>
		<cfset gridClasses="">
	</cfif>
</cfsilent>
<cfoutput>
<div class="mura-collection #gridClasses#">
	<cfloop condition="iterator.hasNext()">
	<cfsilent>
		<cfset item=arguments.iterator.next()>
	</cfsilent>
	<div class="mura-collection-item">
		
		<div class="mura-collection-item__holder">		
			<cfif listFindNoCase(arguments.objectParams.displaylist,'Image')>
			<div class="mura-item-content">
				<cfif item.hasImage()>
					<a href="#item.getURL()#"><img src="#item.getImageURL(argumentCollection=imageSizeArgs)#" alt="#esapiEncode('html_attr',item.getValue('title'))#"></a>
				</cfif>
			</div>
			</cfif>
			#variables.$.dspObject_include(
				theFile='collection/includes/dsp_meta_list.cfm', 
				item=item, 
				fields=arguments.objectParams.displaylist
			)#
		</div>
	</div>
	</cfloop>	
</div>

#variables.$.dspObject_include(
	theFile='collection/includes/dsp_pagination.cfm', 
	iterator=iterator, 
	nextN=iterator.getNextN(),
	source=arguments.objectParams.source
)#

<cfif len(arguments.objectParams.viewalllink)>
	<a class="view-all" href="#arguments.objectParams.viewalllink#">#HTMLEditFormat(arguments.objectParams.viewalllabel)#</a>
</cfif>
</cfoutput>