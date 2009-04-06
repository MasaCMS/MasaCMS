<cfcomponent extends="Validator" output="false">
	
<cffunction name="validate" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfif event.getValue('trackSession') and (len(event.getValue('contentBean').getcontentID()) 
			and not event.getValue('contentBean').getIsNew() eq 1 and not event.valueExists('previewID'))>
			<cfset event.getHandler("standardTrackSession").handle(event)>
	</cfif>
</cffunction>

</cfcomponent>