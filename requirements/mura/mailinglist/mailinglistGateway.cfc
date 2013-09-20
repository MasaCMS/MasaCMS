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
<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" access="public" returntype="any" output="false">
<cfargument name="configBean" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfreturn this />
</cffunction>

<cffunction name="getListMembers" access="public" output="false" returntype="query">
	<cfargument name="mlid" type="string" />
	<cfargument name="siteid" type="string" />
	<cfset var rs = ""/>
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	select mlid,email,siteid,fname,lname,company,isVerified,created from tmailinglistmembers where mlid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mlid#" /> and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#" /> order by email
	</cfquery>

	<cfreturn rs />
</cffunction>

<cffunction name="getList" access="public" output="false" returntype="query">
	<cfargument name="siteid" type="string" />
	<cfset var rs = ""/>
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	select tmailinglist.siteid, tmailinglist.name, tmailinglist.lastupdate, tmailinglist.mlid, tmailinglist.ispurge, tmailinglist.isPublic, count(tmailinglistmembers.mlid) as "Members" from tmailinglist LEFT JOIN tmailinglistmembers ON(tmailinglist.mlid=tmailinglistmembers.mlid and tmailinglist.siteid=tmailinglistmembers.siteid)
	WHERE tmailinglist.siteid =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" /> 
	GROUP By tmailinglist.siteid, tmailinglist.name, tmailinglist.mlid, tmailinglist.ispurge, tmailinglist.lastupdate,tmailinglist.isPublic
	ORDER BY tmailinglist.ispurge desc, tmailinglist.name
	</cfquery>
	
	<cfreturn rs />
</cffunction>


</cfcomponent>