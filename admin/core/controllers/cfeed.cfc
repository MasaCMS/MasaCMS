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

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
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
	<cfparam name="arguments.rc.assignmentID" default="" />
	<cfparam name="arguments.rc.regionID" default="0" />
	<cfparam name="arguments.rc.orderno" default="0" />
	<cfparam name="arguments.rc.instanceParams" default="" />
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
	<cfset arguments.rc.rslist=variables.feedManager.getcontentItems(arguments.rc.feedBean) />
</cffunction>

<cffunction name="update" output="false">
	<cfargument name="rc">
	
	<cfif rc.$.validateCSRFTokens(context=arguments.rc.feedid)>
		<cfif arguments.rc.action eq 'update'>
			<cfif len(arguments.rc.assignmentID) and isJSON(arguments.rc.instanceParams)>
				<cfset getBean("contentManager").updateContentObjectParams(arguments.rc.assignmentID,arguments.rc.regionID,arguments.rc.orderno,arguments.rc.instanceParams)>
				<cfset arguments.rc.feedBean=variables.feedManager.read(feedID=arguments.rc.feedID)>
			<cfelse>
				<cfset arguments.rc.feedBean=variables.feedManager.update(arguments.rc)>
			</cfif>
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
		  
		 
		<cfif arguments.rc.closeCompactDisplay neq 'true' and not (arguments.rc.action neq  'delete' and not structIsEmpty(arguments.rc.feedBean.getErrors()))>
				<cfset variables.fw.redirect(action="cFeed.list",append="siteid",path="./")>
		</cfif>
	
	
		<cfif arguments.rc.action neq  'delete' and not structIsEmpty(arguments.rc.feedBean.getErrors())>
			<cfset arguments.rc.rsRestrictGroups=variables.contentUtility.getRestrictGroups(arguments.rc.siteid) />
			<cfset arguments.rc.rslist=variables.feedManager.getcontentItems(arguments.rc.siteID,arguments.rc.feedBean.getcontentID()) />
		</cfif>
	<cfelse>
		<cfset variables.fw.redirect(action="cFeed.list",append="siteid",path="./")>
	</cfif>
	  
</cffunction>

<cffunction name="import2" output="false">
	<cfargument name="rc">	
	<cfset arguments.rc.theImport=variables.feedManager.doImport(arguments.rc) />
</cffunction>

</cfcomponent>