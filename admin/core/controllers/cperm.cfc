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

<cffunction name="before" output="false">
	<cfargument name="rc">
	
	<cfif not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(arguments.rc.siteid).getPrivateUserPoolID()#;0') and not listFind(session.mura.memberships,'S2')>
		<cfset secure(arguments.rc)>
	</cfif>
	
	<cfparam name="arguments.rc.parentid" default="" />
	<cfparam name="arguments.rc.topid" default="" />
	<cfparam name="arguments.rc.contentid" default="" />
	<cfparam name="arguments.rc.body" default="" />
	<cfparam name="arguments.rc.Contentid" default="" />
	<cfparam name="arguments.rc.groupid" default="" />
	<cfparam name="arguments.rc.url" default="" />
	<cfparam name="arguments.rc.type" default="" />
	<cfparam name="arguments.rc.startrow" default="1" />
	<cfparam name="arguments.rc.siteid" default="" />
	<cfparam name="arguments.rc.approvalExempt" default="" />
	<cfparam name="arguments.rc.chainID" default="" />
	<cfparam name="arguments.rc.exemptID" default="" />
	<cfparam name="arguments.rc.topid" default="00000000000000000000000000000000001" />
</cffunction>

<cffunction name="update" output="false">
	<cfargument name="rc">

	<cfif rc.$.validateCSRFTokens(context=rc.contentid)>
		<cfset variables.permUtility.update(arguments.rc)  />
		<cfset getBean('approvalChainAssignment')
				.loadBy(siteID=arguments.rc.siteid, contentID=arguments.rc.contentID)
				.setChainID(arguments.rc.chainID)
				.setExemptID(arguments.rc.exemptID)
				.save()>
	</cfif>
	<cfset variables.fw.redirect(action="cArch.list",append="siteid,moduleid,startrow,topid",path="./")>
</cffunction>

<cffunction name="main" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.rscontent=variables.permUtility.getcontent(arguments.rc) />
</cffunction>

<cffunction name="module" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.groups=variables.permUtility.getGrouplist(arguments.rc) />
	<cfset arguments.rc.rsContent=variables.permUtility.getModule(arguments.rc) />
</cffunction>

<cffunction name="updatemodule" output="false">
	<cfargument name="rc">

	<cfif rc.$.validateCSRFTokens(context=rc.moduleid)>
		<cfset variables.permUtility.updateModule(arguments.rc) />
	</cfif>
	
	<cfif arguments.rc.moduleid eq '00000000000000000000000000000000004'>
		<cfset variables.fw.redirect(action="cUsers.list",append="siteid",path="./")>
	</cfif>
	 <cfif arguments.rc.moduleid eq '00000000000000000000000000000000005'>
		 <cfset variables.fw.redirect(action="cEmail.list",append="siteid",path="./")>
	</cfif>
	 <cfif arguments.rc.moduleid eq '00000000000000000000000000000000007'>
		 <cfset variables.fw.redirect(action="cForm.list",append="siteid",path="./")>
	</cfif>
	 <cfif arguments.rc.moduleid eq '00000000000000000000000000000000008'>
		 <cfset variables.fw.redirect(action="cUsers.list",append="siteid",path="./")>
	</cfif>
	 <cfif arguments.rc.moduleid eq '00000000000000000000000000000000009'>
		 <cfset variables.fw.redirect(action="cMailingList.list",append="siteid",path="./")>
	</cfif>
	  <cfif arguments.rc.moduleid eq '00000000000000000000000000000000000'>
		 <cfset arguments.rc.moduleid="00000000000000000000000000000000000">
		 <cfset arguments.rc.topid="00000000000000000000000000000000001">
		 <cfset variables.fw.redirect(action="cArch.list",append="siteid,topid,moduleid",path="./")>
	</cfif>
	  <cfif arguments.rc.moduleid eq '00000000000000000000000000000000006'>
		 <cfset variables.fw.redirect(action="cAdvertising.listAdvertisers",append="siteid",path="./")>
	</cfif>
	<cfif arguments.rc.moduleid eq '00000000000000000000000000000000010'>
	 	<cfset variables.fw.redirect(action="cCategory.list",append="siteid",path="./")>
	</cfif>
	 <cfif arguments.rc.moduleid eq '00000000000000000000000000000000011'>
		<cfset variables.fw.redirect(action="cFeed.list",append="siteid",path="./")>
	</cfif>
	 <cfif arguments.rc.moduleid eq '00000000000000000000000000000000014'>
		<cfset variables.fw.redirect(action="cChangesets.list",append="siteid",path="./")>
	</cfif>
	 <cfif arguments.rc.moduleid eq '00000000000000000000000000000000015'>
		<cfset variables.fw.redirect(action="cComments.default",append="siteid",path="./")>
	</cfif>
	
	 <cfset variables.fw.redirect(action="cPlugins.list",append="siteid",path="./")>
</cffunction>

</cfcomponent>