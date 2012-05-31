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

<cffunction name="setMailingListManager" output="false">
	<cfargument name="mailingListManager">
	<cfset variables.mailingListManager=arguments.mailingListManager>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">
	
	<cfif (not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(arguments.rc.siteid).getPrivateUserPoolID()#;0') and not listFind(session.mura.memberships,'S2')) and not ( variables.permUtility.getModulePerm('00000000000000000000000000000000009','#rc.siteid#') and variables.permUtility.getModulePerm('00000000000000000000000000000000000','#rc.siteid#'))>
		<cfset secure(arguments.rc)>
	</cfif>
	<cfparam name="arguments.rc.startrow" default="1" />
</cffunction>

<cffunction name="list" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.rslist=variables.mailinglistManager.getList(arguments.rc.siteid) />
</cffunction>

<cffunction name="edit" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.listBean=variables.mailinglistManager.read(arguments.rc.mlid,arguments.rc.siteid) />
</cffunction>

<cffunction name="listmembers" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.listBean=variables.mailinglistManager.read(arguments.rc.mlid,arguments.rc.siteid) />
	<cfset arguments.rc.rslist=variables.mailinglistManager.getListMembers(arguments.rc.mlid,arguments.rc.siteid) />
	<cfset arguments.rc.nextn=variables.utility.getNextN(arguments.rc.rslist,30,arguments.rc.startrow) />
</cffunction>

<cffunction name="update" output="false">
	<cfargument name="rc">
	
	<cfif arguments.rc.action eq 'add'>
		<cfset arguments.rc.listBean=variables.mailinglistManager.create(arguments.rc) />
		<cfset arguments.rc.mlid= rc.listBean.getMLID() />
	</cfif>
			
	<cfif arguments.rc.action eq 'update'>
		<cfset variables.mailinglistManager.update(arguments.rc) />
	</cfif>
	
	<cfif arguments.rc.action eq 'delete'>
		<cfset variables.mailinglistManager.delete(arguments.rc.mlid,arguments.rc.siteid) />
	</cfif>
			
	<cfif arguments.rc.action eq 'delete'>
		<cfset variables.fw.redirect(action="cMailingList.list",append="siteid")>
	<cfelse>
		<cfset variables.fw.redirect(action="cMailingList.listmembers",append="siteid,mlid")>
	</cfif>
</cffunction>

<cffunction name="updatemember" output="false">
	<cfargument name="rc">
	
	<cfif arguments.rc.action eq 'add'>
		<cfset variables.mailinglistManager.createMember(arguments.rc) />
	</cfif>
		
	<cfif arguments.rc.action eq 'delete'>
		<cfset variables.mailinglistManager.deleteMember(arguments.rc) />
	</cfif>
	
	<cfset variables.fw.redirect(action="cMailingList.listmembers",append="siteid,mlid")>
</cffunction>

<cffunction name="download" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.listBean=variables.mailinglistManager.read(arguments.rc.mlid,arguments.rc.siteid) />
	<cfset arguments.rc.rslist=variables.mailinglistManager.getListMembers(arguments.rc.mlid,arguments.rc.siteid) />
</cffunction>

</cfcomponent>