<cfcomponent extends="Handler" output="false">
	
<cffunction name="execute" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfif event.valueExists('previewID')>
		<cfset event.setValue('isOnDisplay',1)>
	<cfelseif event.getValue('contentBean').getapproved() eq 0>
		<cfset event.setValue('track',0)>
		<cfset event.setValue('nocache',1)>
		<cfset event.setValue('isOnDisplay',0)>
	<cfelseif arrayLen(event.getValue('crumbData')) gt 1>
		<cfset crumbdata=event.getValue('crumbdata')>
		<cfset event.setValue('isOnDisplay',application.contentUtility.isOnDisplay(event.getValue('contentBean').getdisplay(),event.getValue('contentBean').getdisplaystart(),event.getValue('contentBean').getdisplaystop(),event.getValue('siteID'),event.getValue('contentBean').getparentid(),crumbdata[2].type))>
	<cfelse>
		<cfset event.setValue('isOnDisplay',1)>
	</cfif>
	
</cffunction>

</cfcomponent>