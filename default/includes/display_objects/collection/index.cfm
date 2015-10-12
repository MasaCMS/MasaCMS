<cfsilent>
	<cfparam name="objectParams.sourcetype" default="">
	<cfparam name="objectParams.source" default="">
	<cfparam name="objectParams.layout" default="">
	<cfset objectParams.layout=listFirst(listLast(replace(objectParams.layout, "\", "/", "ALL"),'/'),'.')>
</cfsilent>
<cfoutput>
<div class="mura-meta">#$.dspObject_Include(thefile='meta/index.cfm',params=objectParams)#</div>
<div class="mura-content">
<cfif fileExists(getDirectoryFromPath(getCurrentTemplatePath()) & 'layouts/#objectParams.layout#.cfm')>
	<cfinclude template="layouts/#objectParams.layout#.cfm">
<cfelse>
	<cfinclude template="layouts/default.cfm">
</cfif>
</div>
</cfoutput>