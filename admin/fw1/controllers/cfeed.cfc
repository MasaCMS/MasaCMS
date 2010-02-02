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
	
	<cfif not variables.settingsManager.getSite(rc.siteid).getHasfeedManager() or (not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') and not listFind(session.mura.memberships,'S2')) and not ( variables.permUtility.getModulePerm('00000000000000000000000000000000011',rc.siteid) and variables.permUtility.getModulePerm('00000000000000000000000000000000000',rc.siteid))>
		<cfset secure(rc)>
	</cfif>
	
	<cfparam name="rc.startrow" default="1" />
	<cfparam name="rc.keywords" default="" />
	<cfparam name="rc.categoryID" default="" />
	<cfparam name="rc.contentID" default="" />
	<cfparam name="rc.restricted" default="0" />
	<cfparam name="rc.closeCompactDisplay" default="" />
	<cfparam name="rc.compactDisplay" default="" />
	<cfparam name="rc.homeID" default="" />
	<cfparam name="rc.action" default="" />
</cffunction>

<cffunction name="list" output="false">
	<cfargument name="rc">
	<cfset rc.rsLocal=variables.feedManager.getFeeds(rc.siteID,'Local') />
	<cfset rc.rsRemote=variables.feedManager.getFeeds(rc.siteID,'Remote') />
</cffunction>

<cffunction name="edit" output="false">
	<cfargument name="rc">

	<cfset rc.rsRestrictGroups=variables.contentUtility.getRestrictGroups(rc.siteid) />
	<cfset rc.feedBean=variables.feedManager.read(rc.feedID) />
	<cfset rc.rslist=variables.feedManager.getcontentItems(rc.feedID,rc.feedBean.getcontentID()) />
</cffunction>

<cffunction name="update" output="false">
	<cfargument name="rc">
	
	<cfif rc.action eq 'update'>
		<cfset rc.feedBean=variables.feedManager.update(rc)>
	</cfif>

	<cfif rc.action eq 'delete'>
		<cfset variables.feedManager.delete(rc.feedID)>
	</cfif>
  	
	<cfif rc.action eq 'add'>
		<cfset rc.feedBean=variables.feedManager.create(rc)>
		<cfif structIsEmpty(rc.feedBean.getErrors())>
			<cfset rc.feedID=rc.feedBean.getFeedID()>
		</cfif>
	</cfif>
	  
	 
	 <cfif rc.closeCompactDisplay neq 'true'>
			<cfif not (rc.action neq  'delete' and not structIsEmpty(rc.feedBean.getErrors()))>
				<cfset variables.fw.redirect(action="cFeed.list",append="siteid",path="")>
			</cfif>
	</cfif>
	  
</cffunction>

<cffunction name="import2" output="false">
	<cfargument name="rc">	
	<cfset rc.import=variables.feedManager.import(rc) />
</cffunction>

</cfcomponent>