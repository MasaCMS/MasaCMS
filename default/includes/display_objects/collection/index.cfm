<cfparam name="objectParams.layout" default="default">
<cfparam name="objectParams.addlabel" default="false">
<cfparam name="objectParams.label" default="Placeholder">
<cfset objectParams.layout=listFirst(listLast(replace(objectParams.layout, "\", "/", "ALL"),'/'),'.')>
<cfif fileExists(getDirectoryFromPath(getCurrentTemplatePath()) & 'layouts/#objectParams.layout#.cfm')>
	<cfinclude template="layouts/#objectParams.layout#.cfm">
<cfelse>
	<cfinclude template="layouts/default.cfm">
</cfif>