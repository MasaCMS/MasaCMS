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

<cffunction name="setEmailManager" output="false">
	<cfargument name="emailManager">
	<cfset variables.emailManager=arguments.emailManager>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">
	
	<cfif (not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(arguments.rc.siteid).getPrivateUserPoolID()#;0') and not listFind(session.mura.memberships,'S2')) and not ( variables.permUtility.getModulePerm('00000000000000000000000000000000005',arguments.rc.siteid) and variables.permUtility.getModulePerm('00000000000000000000000000000000000',arguments.rc.siteid))>
		<cfset secure(arguments.rc)>
	</cfif>
	
	<cfset session.moduleID="00000000000000000000000000000000005">
	
	<cfparam name="arguments.rc.muraAction" default="list" />
	<cfparam name="arguments.rc.subject" default="" />
	<cfparam name="arguments.rc.bodytext" default="" />
	<cfparam name="arguments.rc.bodyhtml" default="" />
	<cfparam name="arguments.rc.createddate" default="" />
	<cfparam name="arguments.rc.deliverydate" default="" />
	<cfparam name="arguments.rc.grouplist" default="" />
	<cfparam name="arguments.rc.groupid" default="" />
	<cfparam name="arguments.rc.emailid" default="" />
	<cfparam name="arguments.rc.status" default="2" />
	<cfparam name="arguments.rc.lastupdatebyid" default="" />
	<cfparam name="arguments.rc.lastupdateby" default="" />
	
	<cfparam name="session.emaillist.status" default="2" />
	<cfparam name="session.emaillist.groupid" default="" />
	<cfparam name="session.emaillist.subject" default="" />
	<cfparam name="session.emaillist.dontshow" default="1" />
	
</cffunction>

<cffunction name="list" output="false">
<cfargument name="rc">
	<cfset arguments.rc.rsList=variables.emailManager.getList(arguments.rc) />
	<cfset arguments.rc.rsPrivateGroups=variables.emailManager.getPrivateGroups(arguments.rc.siteid) />
	<cfset arguments.rc.rsPublicGroups=variables.emailManager.getPublicGroups(arguments.rc.siteid) />
	<cfset arguments.rc.rsMailingLists=variables.emailManager.getMailingLists(arguments.rc.siteid) />
</cffunction>

<cffunction name="edit" output="false">
<cfargument name="rc">
	<cfset arguments.rc.emailBean=variables.emailManager.read(arguments.rc.emailid) />
	<cfset arguments.rc.rsPrivateGroups=variables.emailManager.getPrivateGroups(arguments.rc.siteid) />
	<cfset arguments.rc.rsPublicGroups=variables.emailManager.getPublicGroups(arguments.rc.siteid) />
	<cfset arguments.rc.rsMailingLists=variables.emailManager.getMailingLists(arguments.rc.siteid) />
	<cfset arguments.rc.rsTemplates=variables.emailManager.getTemplates(arguments.rc.siteid) />
</cffunction>

<cffunction name="update" output="false">
<cfargument name="rc">
	<cfset variables.emailManager.update(arguments.rc) />
	<cfset variables.fw.redirect(action="cEmail.list",append="siteid",path="./")>
</cffunction>

<cffunction name="showAllBounces" output="false">
<cfargument name="rc">
	<cfset arguments.rc.rsBounces=variables.emailManager.getAllBounces(arguments.rc) />
</cffunction>

<cffunction name="showBounces" output="false">
<cfargument name="rc">
	<cfset arguments.rc.rsBounces=variables.emailManager.getBounces(arguments.rc.emailid) />
</cffunction>

<cffunction name="showReturns" output="false">
<cfargument name="rc">
	<cfset arguments.rc.rsReturns=variables.emailManager.getReturns(arguments.rc.emailid) />
	<cfset arguments.rc.rsReturnsByUser=variables.emailManager.getReturnsByUser(arguments.rc.emailid) />
</cffunction>

<cffunction name="deleteBounces" output="false">
<cfargument name="rc">
	<cfset variables.emailManager.deleteBounces(arguments.rc)>
	<cflocation url="./?muraAction=cEmail.showAllBounces&siteid=#arguments.rc.siteid#">
</cffunction>

</cfcomponent>