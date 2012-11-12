<cfset $=request.event.getValue('MuraScope')>
<cfoutput>
<cfif  ListFindNoCase(application.contentManager.TreeLevelList,$.content('type'))>			
	#$.announceEvent("onContent#attributes.tab#tab#attributes.context#Render")#	
</cfif>

#$.announceEvent("on#$.content('type')##attributes.tab#tab#attributes.context#Render")#	
#$.announceEvent("on#$.content('type')##$.content('subtype')##attributes.tab#tab#attributes.context#Render")#
</cfoutput>	