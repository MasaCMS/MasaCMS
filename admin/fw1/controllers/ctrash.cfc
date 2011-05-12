<cfcomponent extends="controller" output="false">

<cffunction name="setTrashManager" output="false">
	<cfargument name="trashManager">
	<cfset variables.trashManager=arguments.trashManager>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">

	<cfif not listFind(session.mura.memberships,'S2')>
		<cfset secure(arguments.rc)>
	</cfif>
	
	<cfparam name="arguments.rc.pageNum" default="1">
	<cfparam name="arguments.rc.siteID" default="#session.siteID#">
	<cfparam name="arguments.rc.keywords" default="">
</cffunction>

<cffunction name="list" output="false">
	<cfargument name="rc">

	<cfset arguments.rc.trashIterator=variables.trashManager.getIterator(argumentCollection=arguments.rc)>
	<cfset arguments.rc.trashIterator.setNextN(20)>
	
</cffunction>

<cffunction name="empty" output="false">
	<cfargument name="rc">
	
	<cfset variables.trashManager.empty(argumentCollection=arguments.rc)>
	<cfset variables.fw.redirect(action="cTrash.list",append="siteID",path="")>
	
</cffunction>

<cffunction name="detail" output="false">
	<cfargument name="rc">
	
	<cfset arguments.rc.trashItem=variables.trashManager.getTrashItem(arguments.rc.objectID)>
	
</cffunction>

<cffunction name="restore" output="false">
	<cfargument name="rc">
	<cfset var obj="">
	<cfset obj=variables.trashManager.getTrashItem(arguments.rc.objectID).getObject()>
	<cfif structKeyExists(arguments.rc,"parentid") and len(arguments.rc.parentid) eq 35>
		<cfset obj.setParentID(arguments.rc.parentid)>
	</cfif>
	<cfset obj.save()>
	<cfset arguments.restoreID=arguments.rc.objectID>
	<cfset variables.fw.redirect(action="cTrash.list",append="restoreID,siteID,keywords,pageNum",path="")>
	
</cffunction>


</cfcomponent>