<cfoutput>
<div class="mura-collection layout-a">
	<cfloop condition="iterator.hasNext()">
	<cfsilent>
		<cfset item=arguments.iterator.next()>
	</cfsilent>
	<div class="mura-collection-item">
		
		<div class="mura-collection-item__holder">		
			<cfif listFindNoCase(arguments.objectParams.displaylist,'Image')>
			<div class="mura-item-content">
				<cfif item.hasImage()>
					<a href="#item.getURL()#"><img src="#item.getImageURL(height=300,width=500)#" alt="#esapiEncode('html_attr',item.getValue('title'))#"></a>
				</cfif>
			</div>
			</cfif>
			#variables.$.dspObject_include(
				theFile='collection/dsp_meta_list.cfm', 
				propertyMap=arguments.propertyMap, 
				item=item, 
				fields=arguments.objectParams.displaylist
			)#
		</div>
	</div>
	</cfloop>	
</div>
</cfoutput>