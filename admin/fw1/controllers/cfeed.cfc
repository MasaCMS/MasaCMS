<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
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
	<cfset arguments.rc.rslist=variables.feedManager.getcontentItems(arguments.rc.siteID,arguments.rc.feedBean.getcontentID()) />
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