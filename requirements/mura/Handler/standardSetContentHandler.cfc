<cfcomponent extends="Handler" output="false">
	
<cffunction name="handle" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfset var renderer=event.getValue("contentRenderer")>
	
	<cfif event.valueExists('previewID')>
		<cfset event.getHandler("standardSetPreview").handle(event)>
	<cfelse>
		<cfset event.getHandler("standardSetAdTracking").handle(event)>
		
		<cfif len(event.getValue('linkServID'))>
			<cfset event.setValue('contentBean',application.contentManager.getActiveContent(event.getValue('linkServID'),event.getValue('siteid'))) />
		<cfelse>
			<cfset event.setValue('contentBean',application.contentManager.getActiveContentByFilename(event.getValue('currentFilename'),event.getValue('siteid'))) />
		</cfif>
	</cfif>
	
	<cfset event.setValue('forceSSL',event.getValue('contentBean').getForceSSL())/>
	
	<cfset event.setValue('crumbdata',application.contentGateway.getCrumbList(event.getValue('contentBean').getcontentid(),event.getValue('siteid'),true,event.getValue('contentBean').getPath())) />
	
	<cfset renderer.crumbdata=event.getValue("crumbdata")>
	
</cffunction>

</cfcomponent>