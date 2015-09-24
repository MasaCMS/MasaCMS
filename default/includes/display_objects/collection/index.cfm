<cfparam name="objectParams.layout" default="default">
<cfparam name="objectParams.addlabel" default="false">
<cfparam name="objectParams.label" default="Placeholder">
<cfparam name="objectParams.sourcetype" default="">
<cfparam name="objectParams.sourceid" default="">
<cfset objectParams.layout=listFirst(listLast(replace(objectParams.layout, "\", "/", "ALL"),'/'),'.')>
<div class="mura-meta">
	<cfoutput>#$.dspObject_Include(thefile='meta/index.cfm',params=objectParams)#</cfoutput>
</div>
<div class="mura-content">
<cfif fileExists(getDirectoryFromPath(getCurrentTemplatePath()) & 'layouts/#objectParams.layout#.cfm')>
	<cfinclude template="layouts/#objectParams.layout#.cfm">
<cfelse>
	<cfinclude template="layouts/default.cfm">
</cfif>
</div>