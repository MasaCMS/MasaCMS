<cfcomponent extends="controller" output="false">

<cffunction name="setChangesetManager" output="false">
	<cfargument name="changesetManager">
	<cfset variables.changesetManager=arguments.changesetManager>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">
	
	<cfif (not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(arguments.rc.siteid).getPrivateUserPoolID()#;0') and not listFind(session.mura.memberships,'S2')) and not ( variables.permUtility.getModulePerm('00000000000000000000000000000000014',arguments.rc.siteid) and variables.permUtility.getModulePerm('00000000000000000000000000000000000',arguments.rc.siteid))>
		<cfset secure(arguments.rc)>
	</cfif>
	<cfparam name="arguments.rc.startrow" default="1"/>
	<cfparam name="arguments.rc.page" default="1"/>
	<cfparam name="arguments.rc.keywords" default=""/>
</cffunction>

<cffunction name="list" output="false">
<cfargument name="rc">
<cfset rc.changesets=variables.changesetManager.getIterator(argumentCollection=rc)>
<cfset rc.changesets.setNextN(20)>
<cfset rc.changesets.setPage(rc.page)>
</cffunction>

<cffunction name="publish" output="false">
<cfargument name="rc">
<cfset variables.changesetManager.publish(rc.changesetID)>
<cfset variables.fw.redirect(action="cChangesets.edit",append="changesetID,siteID",path="")>
</cffunction>

<cffunction name="assignments" output="false">
<cfargument name="rc">
<cfset rc.assignments=variables.changesetManager.getAssignmentsIterator(rc.changesetID,rc.keywords)>
<cfset rc.changeset=variables.changesetManager.read(rc.changesetID)>
</cffunction>

<cffunction name="removeitem" output="false">
<cfargument name="rc">
<cfset variables.changesetManager.removeItem(rc.changesetID,rc.contenthistID)>
<cfset variables.fw.redirect(action="cChangesets.assignments",append="changesetID,siteID,keywords",path="")>
</cffunction>

<cffunction name="edit" output="false">
<cfargument name="rc">
<cfset rc.changeset=variables.changesetManager.read(rc.changesetID)>
</cffunction>

<cffunction name="save" output="false">
<cfargument name="rc">
<cfset rc.changeset=variables.changesetManager.read(rc.changesetID).set(rc).save()>
<cfset rc.changesetID=rc.changeset.getChangesetID()>
<cfset variables.fw.redirect(action="cChangesets.list",append="changesetID,siteID",path="")>
</cffunction>

<cffunction name="delete" output="false">
<cfargument name="rc">
<cfset rc.changeset=variables.changesetManager.read(rc.changesetID).delete()>
<cfset variables.fw.redirect(action="cChangesets.list",append="changesetID,siteID",path="")>
</cffunction>
</cfcomponent>