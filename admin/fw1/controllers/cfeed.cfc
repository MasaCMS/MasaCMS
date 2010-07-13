<cfcomponent extends="controller" output="false">

<cffunction name="setFeedManager" output="false">
	<cfargument name="feedManager">
	<cfset variables.feedManager=arguments.feedManager>
</cffunction>

<cffunction name="setContentUtility" output="false">
	<cfargument name="ContentUtility">
	<cfset variables.contentUtility=arguments.contentUtility>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">
	
	<cfif not variables.settingsManager.getSite(arguments.rc.siteid).getHasfeedManager() or (not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(arguments.rc.siteid).getPrivateUserPoolID()#;0') and not listFind(session.mura.memberships,'S2')) and not ( variables.permUtility.getModulePerm('00000000000000000000000000000000011',arguments.rc.siteid) and variables.permUtility.getModulePerm('00000000000000000000000000000000000',arguments.rc.siteid))>
		<cfset secure(arguments.rc)>
	</cfif>
	
	<cfparam name="arguments.rc.startrow" default="1" />
	<cfparam name="arguments.rc.keywords" default="" />
	<cfparam name="arguments.rc.categoryID" default="" />
	<cfparam name="arguments.rc.contentID" default="" />
	<cfparam name="arguments.rc.restricted" default="0" />
	<cfparam name="arguments.rc.closeCompactDisplay" default="" />
	<cfparam name="arguments.rc.compactDisplay" default="" />
	<cfparam name="arguments.rc.homeID" default="" />
	<cfparam name="arguments.rc.action" default="" />
</cffunction>

<cffunction name="list" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.rsLocal=variables.feedManager.getFeeds(arguments.rc.siteID,'Local') />
	<cfset arguments.rc.rsRemote=variables.feedManager.getFeeds(arguments.rc.siteID,'Remote') />
</cffunction>

<cffunction name="edit" output="false">
	<cfargument name="rc">

	<cfset arguments.rc.rsRestrictGroups=variables.contentUtility.getRestrictGroups(arguments.rc.siteid) />
	<cfset arguments.rc.feedBean=variables.feedManager.read(arguments.rc.feedID) />
	<cfset arguments.rc.rslist=variables.feedManager.getcontentItems(arguments.rc.feedID,arguments.rc.feedBean.getcontentID()) />
</cffunction>

<cffunction name="update" output="false">
	<cfargument name="rc">
	
	<cfif arguments.rc.action eq 'update'>
		<cfset arguments.rc.feedBean=variables.feedManager.update(arguments.rc)>
	</cfif>

	<cfif arguments.rc.action eq 'delete'>
		<cfset variables.feedManager.delete(arguments.rc.feedID)>
	</cfif>
  	
	<cfif arguments.rc.action eq 'add'>
		<cfset arguments.rc.feedBean=variables.feedManager.create(arguments.rc)>
		<cfif structIsEmpty(arguments.rc.feedBean.getErrors())>
			<cfset arguments.rc.feedID=rc.feedBean.getFeedID()>
		</cfif>
	</cfif>
	  
	 
	 <cfif arguments.rc.closeCompactDisplay neq 'true'>
			<cfif not (arguments.rc.action neq  'delete' and not structIsEmpty(arguments.rc.feedBean.getErrors()))>
				<cfset variables.fw.redirect(action="cFeed.list",append="siteid",path="")>
			</cfif>
	</cfif>
	  
</cffunction>

<cffunction name="import2" output="false">
	<cfargument name="rc">	
	<cfset arguments.rc.theImport=variables.feedManager.doImport(arguments.rc) />
</cffunction>

</cfcomponent>