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

<cffunction name="setUserManager" output="false">
	<cfargument name="userManager">
	<cfset variables.userManager=arguments.userManager>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">
	
	<cfparam name="arguments.rc.Type" default="0" />
	<cfparam name="arguments.rc.ContactForm" default="0" />
	<cfparam name="arguments.rc.isPublic" default="0" />
	<cfparam name="arguments.rc.email" default="" />
	<cfparam name="arguments.rc.jobtitle" default="" />
	<cfparam name="arguments.rc.lastupdate" default="" />
	<cfparam name="arguments.rc.lastupdateby" default="" />
	<cfparam name="arguments.rc.lastupdatebyid" default="0" />
	<cfparam name="arguments.rc.rsGrouplist.recordcount" default="0" />
	<cfparam name="arguments.rc.groupname" default="" />
	<cfparam name="arguments.rc.fname" default="" />
	<cfparam name="arguments.rc.lname" default="" />
	<cfparam name="arguments.rc.address" default="" />
	<cfparam name="arguments.rc.city" default="" />
	<cfparam name="arguments.rc.state" default="" />
	<cfparam name="arguments.rc.zip" default="" />
	<cfparam name="arguments.rc.phone1" default="" />
	<cfparam name="arguments.rc.phone2" default="" />
	<cfparam name="arguments.rc.fax" default="" />
	<cfparam name="arguments.rc.perm" default="0" />
	<cfparam name="arguments.rc.groupid" default="" />
	<cfparam name="arguments.rc.routeid" default="" />
	<cfparam name="arguments.rc.InActive" default="0" />
	<cfparam name="arguments.rc.startrow" default="1" />
	<cfparam name="arguments.rc.categoryID" default="" />
	<cfparam name="arguments.rc.routeID" default="" />
	<cfparam name="arguments.rc.error" default="#structnew()#" />
	<cfparam name="arguments.rc.returnurl" default="" />
	
	<cfif not session.mura.isLoggedIn>
		<cfset secure(arguments.rc)>
	</cfif>
</cffunction>

<cffunction name="edit" output="false">
<cfargument name="rc">
	<cfif not isdefined('arguments.rc.userBean')>
		<cfset arguments.rc.userBean=variables.userManager.read(session.mura.userID)>
	</cfif>

	<!--- This is here for backward plugin compatibility--->
	<cfset appendRequestScope(arguments.rc)>

</cffunction>

<cffunction name="update" output="false">
	<cfargument name="rc">

	<cfset request.newImageIDList="">

	<cfset arguments.rc.userBean=variables.userManager.update(arguments.rc,false)>
	
	<cfif structIsEmpty(arguments.rc.userBean.getErrors())>
		<cfset structDelete(session.mura,"editBean")>

		<cfif len(request.newImageIDList)>
			<cfset rc.fileid=request.newImageIDList>
			<cfset rc.userid=arguments.rc.userBean.getUserID()>
			<cfset rc.siteID=arguments.rc.userBean.getSiteID()>
			<cfset variables.fw.redirect(action="cArch.imagedetails",append="userid,siteid,fileid,compactDisplay")>
		</cfif>

		 <cfset variables.fw.redirect(action="home.redirect")>
	</cfif>
</cffunction>

</cfcomponent>