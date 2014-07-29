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
	<cfparam name="arguments.rc.startdate" default=""/>
	<cfparam name="arguments.rc.stopdate" default=""/>
	<cfparam name="arguments.rc.page" default="1"/>
	<cfparam name="arguments.rc.keywords" default=""/>
	<cfparam name="arguments.rc.categoryid" default=""/>
	<cfparam name="arguments.rc.tags" default=""/>
</cffunction>

<cffunction name="list" output="false">
<cfargument name="rc">
<cfset var feed=variables.changesetManager.getFeed(argumentCollection=arguments.rc)>

<cfset feed.setSiteID(arguments.rc.siteid)>

<cfif isDate(rc.startdate)>
	<cfset feed.addParam(column='publishdate',datatype='date',criteria=arguments.rc.startdate,condition=">=")>	
</cfif>

<cfif isDate(rc.stopdate)>
	<cfset feed.addParam(column='publishdate',datatype='date',criteria=arguments.rc.stopdate,condition="<=")>
	<cfif not isDate(rc.startdate)>
		<cfset feed.addParam(column='publishdate',datatype='date',criteria=dateAdd('yyyy',100,now()),condition=">=")>	
	</cfif>
</cfif>

<cfif len(rc.keywords)>
	<cfset feed.addParam(column='name',criteria=arguments.rc.keywords,condition="contains")>	
</cfif>

<cfif len(rc.tags)>
	<cfquery name="local.rstags">
		select changesetid from tchangesettagassign where tag in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.rc.tags#">)
	</cfquery>

	<cfif local.rstags.recordcount>
		<cfset feed.addParam(column='changesetid',criteria=valuelist(local.rstags.changesetid),condition="in")>	
	<cfelse>
		<cfset feed.addParam(column='changesetid',criteria='none')>	
	</cfif>	
</cfif>

<cfif len(rc.categoryid)>
	<cfquery name="local.rscats">
		select changesetid from tchangesetcategoryassign where categoryid in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.rc.categoryid#">)
	</cfquery>

	<cfif local.rscats.recordcount>
		<cfset feed.addParam(column='changesetid',criteria=valuelist(local.rscats.changesetid),condition="in")>	
	<cfelse>
		<cfset feed.addParam(column='changesetid',criteria='none')>	
	</cfif>
</cfif>



<cfset arguments.rc.changesets=feed.getIterator()>

<cfset arguments.rc.changesets.setNextN(20)>
<cfset arguments.rc.changesets.setPage(arguments.rc.page)>
</cffunction>

<cffunction name="publish" output="false">
<cfargument name="rc">
<cfset variables.changesetManager.publish(rc.changesetID)>
<cfset variables.fw.redirect(action="cChangesets.edit",append="changesetID,siteID",path="./")>
</cffunction>

<cffunction name="rollback" output="false">
<cfargument name="rc">
<cfif rc.$.validateCSRFTokens(context=arguments.rc.changesetid)>
	<cfset variables.changesetManager.rollback(rc.changesetID)>
</cfif>
<cfset variables.fw.redirect(action="cChangesets.edit",append="changesetID,siteID",path="./")>
</cffunction>

<cffunction name="assignments" output="false">
<cfargument name="rc">
<cfset arguments.rc.siteAssignments=variables.changesetManager.getAssignmentsIterator(arguments.rc.changesetID,arguments.rc.keywords,'00000000000000000000000000000000000')>
<cfset arguments.rc.componentAssignments=variables.changesetManager.getAssignmentsIterator(arguments.rc.changesetID,arguments.rc.keywords,'00000000000000000000000000000000003')>
<cfset arguments.rc.formAssignments=variables.changesetManager.getAssignmentsIterator(arguments.rc.changesetID,arguments.rc.keywords,'00000000000000000000000000000000004')>
<cfset arguments.rc.changeset=variables.changesetManager.read(arguments.rc.changesetID)>
</cffunction>

<cffunction name="removeitem" output="false">
<cfargument name="rc">
<cfif rc.$.validateCSRFTokens(context=arguments.rc.changesetid)>
	<cfset variables.changesetManager.removeItem(rc.changesetID,rc.contenthistID)>
</cfif>
<cfset variables.fw.redirect(action="cChangesets.assignments",append="changesetID,siteID,keywords",path="./")>
</cffunction>

<cffunction name="edit" output="false">
<cfargument name="rc">
<cfset arguments.rc.changeset=variables.changesetManager.read(arguments.rc.changesetID)>
</cffunction>

<cffunction name="save" output="false">
<cfargument name="rc">
<cfif rc.$.validateCSRFTokens(context=arguments.rc.changesetid)>
	<cfset arguments.rc.changeset=variables.changesetManager.read(arguments.rc.changesetID).set(arguments.rc).save()>
	<cfset arguments.rc.changesetID=arguments.rc.changeset.getChangesetID()>
</cfif>

<cfif isDefined('arguments.rc.changeset') and not arguments.rc.changeset.hasErrors()>
	<cfset variables.fw.redirect(action="cChangesets.list",append="changesetID,siteID",path="./")>
</cfif>
</cffunction>

<cffunction name="delete" output="false">
<cfargument name="rc">
<cfif rc.$.validateCSRFTokens(context=arguments.rc.changesetid)>
	<cfset arguments.rc.changeset=variables.changesetManager.read(arguments.rc.changesetID).delete()>
</cfif>
<cfset variables.fw.redirect(action="cChangesets.list",append="changesetID,siteID",path="./")>
</cffunction>
</cfcomponent>