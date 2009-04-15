<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfcomponent>

<cfset variables.LDAP_server= '' />
	
<cffunction name="init" returntype="any" access="public">
	<cfreturn this />
</cffunction>

<cffunction name="handleLogin" access="public" returntype="void">

	<cfif variables.LDAP_server eq ''>
		<cfset application.loginManager.login(request,'') />
	<cfelse>
		<cfset application.loginManager.login(request,this) />
	</cfif>


</cffunction>

<cffunction name="login" access="public" output="false">
	<cfargument name="username" type="string" required="true" default="">
	<cfargument name="password" type="string" required="true" default="">
	<cfargument name="siteid" type="string" required="false" default="">
	
	<cfset var checkAdmin = structNew() />
	<cfset var rsGroups = "" />
	<cfset var rsUser = "" />
	<cfset var userBean = "" />
	<cfset var rsMemberships = "" />
	<cfset var isNew = true />
	<cfset var rolelist="" />	
	
	<cfset checkAdmin.username = arguments.username />
	<cfset checkAdmin.password = arguments.password />
	<cfset checkAdmin.siteid = "" />	
	   	  
	   	  
				<!--- Get User --->
		<cftry>
			<cfldap action="QUERY"
				name="rsUser"
				attributes="dn,sn,givenname,mail"
				start="cn=users,dc=#listGetAt(variables.LDAP_server,2,'.')#,dc=#listLast(variables.LDAP_server,'.')#"
				maxrows="1"
				scope="subtree"
				filter="((objectclass=user)(samaccountname=#arguments.username#))"
				server="#variables.LDAP_server#"
				username="#arguments.username#@#listGetAt(variables.LDAP_server,2,'.')#.#listLast(variables.LDAP_server,'.')#"
				password="#arguments.password#">
						  
				 <cfcatch type="any">
					  <!--- The user is not a site member, check if administrative --->
				      <cfreturn application.loginManager.login(checkAdmin)>
			 	</cfcatch>
			 </cftry>
			 
			  <!--- Check if the user is a member of any Mura groups with the same name. --->
		<cftry>
			<cfldap
				 action="QUERY"
				 name="rsMemberships"
				 attributes="cn"
				 start="dc=#listGetAt(variables.LDAP_server,2,'.')#,dc=#listLast(variables.LDAP_server,'.')#"
				 scope="SUBTREE"
				 server="#variables.LDAP_server#"
				 filter="(&(objectClass=groupOfUniqueNames)(uniquemember=#rsUser.dn#))"
				 username="#rsUser.dn#"
				 password="#arguments.password#">
				            
									
				<cfset rsGroups=application.getPublicGroups(arguments.siteID) />     
				<cfloop query="rsGroups">
					<cfif listFind(valuelist(rsMemberships.cn),rsGroups.groupsname)>
						<cfset rolelist=listappend(rolelist,rsGroups.groupID)>
					</cfif>
				</cfloop>
							
				<cfcatch></cfcatch>
			</cftry>
		   
			  		
				<!--- Check to see if the user has previous login into the system --->
			<cfset userBean=application.userManager.readByUsername(arguments.username,arguments.siteid)>
					
			<cfif userBean.getUsername() neq ''>
				<cfset isNew=false />
			</cfif>
		
			<cfset userBean.setUsername(arguments.username) />
			<cfset userBean.setPassword(arguments.password) />
			<cfset userBean.setFname(rsUser.givenname) />
			<cfset userBean.setLname(rsUser.sn) />
			<cfset userBean.setEmail(rsUser.mail) />
			<cfset userBean.lastUpdateBy('System') />			
			<cfset userBean.setGroupID(rolelist) />
				
			<cfif isNew>
				<cfset application.serviceFactory.getBean("userDAO").create(userBean) />
			<cfelse>
				<cfset application.serviceFactory.getBean("userDAO").update(userBean) />
			</cfif>
					
			<!--- Now that we know that this is user has a vaild account pass the login on the the regular system --->
			<cfreturn application.loginManager.login(arguments)>
		
	</cffunction>

</cfcomponent>