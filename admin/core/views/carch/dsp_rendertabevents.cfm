<cfset $=request.event.getValue('MuraScope')>
<cfoutput>
<cftry>
<cfif  ListFindNoCase(application.contentManager.TreeLevelList,$.content('type'))>			
	#$.renderEvent("onContent#attributes.tab##attributes.context#Render")#	
</cfif>
#$.renderEvent("on#$.content('type')##attributes.tab##attributes.context#Render")#	
#$.renderEvent("on#$.content('type')##$.content('subtype')##attributes.tab##attributes.context#Render")#
<cfcatch>
	#cfcatch.message#
</cfcatch>
</cftry>
</cfoutput>	