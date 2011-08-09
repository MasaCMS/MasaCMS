
<cfparam name="session.copyContentID" default="">
<cfparam name="session.copySiteID" default="">
<cfparam name="session.copyAll" default="false">
<cfparam name="session.openSectionList" default="">

<cfset sectionFound=listFind(session.openSectionList,attributes.contentID)>

<cfif not sectionFound>

<cfset data=structNew()>

<cfif not isDefined("attributes.sortby") or attributes.sortby eq "">
	<cfset attributes.sortBy=request.rstop.sortBy>
</cfif>

<cfif not isDefined("attributes.sortdirection") or attributes.sortdirection eq "">
	<cfset attributes.sortdirection=request.rstop.sortdirection>
</cfif>
<cfparam name="attributes.sorted" default="false" />

<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>	
<cfset request.rowNum=0>
<cfset request.menulist=attributes.contentID>
<cfset crumbdata=application.contentManager.getCrumbList(attributes.contentID,attributes.siteid)>
<cfset perm=application.permUtility.getnodePerm(crumbdata)>
<cfset r=application.permUtility.setRestriction(crumbdata).restrict>
<cfset rsNext=application.contentManager.getNest(attributes.contentID,attributes.siteid,attributes.sortBy,attributes.sortDirection)>

<cfset session.openSectionList=listAppend(session.openSectionList,attributes.contentID)>

<cfsavecontent variable="data.html">
<cf_dsp_nest topid="#attributes.contentID#" parentid="#attributes.contentID#"  rsnest="#rsNext#" locking="#application.settingsManager.getSite(attributes.siteid).getlocking()#" nestlevel="1" perm="#perm#" siteid="#attributes.siteid#" moduleid="#attributes.moduleid#" restricted="#r#" viewdepth="1" nextn="#session.mura.nextN#" startrow="#attributes.startrow#" sortBy="#attributes.sortBy#" sortDirection="#attributes.sortDirection#" pluginEvent="#pluginEvent#" isSectionRequest="true">
</cfsavecontent>

<cfoutput>#createObject("component","mura.json").encode(data)#</cfoutput>

<cfelse>
	<cfset session.openSectionList=listDeleteAt(session.openSectionList,sectionFound)>
</cfif>