<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->

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
			 
			  <!--- Check if the user is a member of any SAVA groups with the same name. --->
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