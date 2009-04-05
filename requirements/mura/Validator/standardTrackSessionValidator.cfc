<cfcomponent extends="Validator" output="false">
	
<cffunction name="execute" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfif event.getValue('trackSession') and (len(event.getValue('contentBean').getcontentID()) 
			and not event.getValue('contentBean').getIsNew() eq 1 and not event.valueExists('previewID'))>
			<cfset event.getValue('HandlerFactory').get("standardTrackSession").execute(event)>
	</cfif>
</cffunction>

</cfcomponent>