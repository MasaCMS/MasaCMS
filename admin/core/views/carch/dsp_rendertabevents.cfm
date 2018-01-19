<cfset $=request.event.getValue('MuraScope')>
<cfoutput>
<cftry>
<cfif ListFindNoCase(application.contentManager.getTreeLevelList(),$.content('type'))>			
	#$.renderEvent("onContent#attributes.tab##attributes.context#Render")#
	#$.renderEvent("onBaseDefault#attributes.tab##attributes.context#Render")#
	<cfif $.content('subtype') neq "Default">
		#$.renderEvent("onBase#$.content('subtype')##attributes.tab##attributes.context#Render")#
	</cfif>
</cfif>
#$.renderEvent("on#$.content('type')##attributes.tab##attributes.context#Render")#	
#$.renderEvent("on#$.content('type')##$.content('subtype')##attributes.tab##attributes.context#Render")#
<cfcatch>
	#cfcatch.message#
</cfcatch>
</cftry>
</cfoutput>
