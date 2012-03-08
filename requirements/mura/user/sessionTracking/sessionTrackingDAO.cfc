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
<cfcomponent extends="sessionTrackingDAOCF7" output="false">

<cffunction name="trackRequest" output="false">
	<cfargument name="remote_addr" type="string" required="yes"/>
	<cfargument name="script_name" type="string" required="yes"/>
	<cfargument name="query_string" type="string" required="yes"/>
	<cfargument name="server_name" type="string" required="yes"/>
	<cfargument name="referer" type="string" required="yes" default=""/>
	<cfargument name="user_agent" type="string" required="yes" default=""/>
	<cfargument name="keywords" type="string" required="yes" default="" />
	<cfargument name="urlToken" type="string" required="yes"/>
	<cfargument name="UserID" type="string" required="yes"/>
	<cfargument name="siteID" type="string" required="yes"/>
	<cfargument name="contentID" type="string" required="yes"/>
	<cfargument name="locale" type="string" required="yes"/>
	<cfargument name="originalURLToken" type="string" required="yes"/>

	<cfset var $ = createObject("component","mura.MuraScope") />

	<cfif trim(arguments.referer) eq ''>
		<cfset arguments.referer='Unknown' />
	<cfelseif findNoCase(arguments.server_name,arguments.referer)>
		<cfset arguments.referer="Internal" />
	</cfif>
	
	<!---
	<cfif arguments.user_agent neq ''>
		<cfset arguments.user_agent=arguments.user_agent />
	</cfif>
	--->

	<cfset $.init(arguments)>
	<cfset $.announceEvent("onSiteSessionTrack")>

	<cfif application.configBean.getTrackSessionInNewThread()>
		<cfthread action="run" name="track#hash(session.trackingID)#" context="#arguments#">
			<cfset super.trackRequest(argumentCollection=context)>
		</cfthread>
	<cfelse>
		 <cfset super.trackRequest(argumentCollection=arguments)>
	</cfif>
</cffunction>

</cfcomponent>