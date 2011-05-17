<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. �See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. �If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (�GPL�) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, �the copyright holders of Mura CMS grant you permission
to combine Mura CMS �with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the �/trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2 �without this exception. �You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" access="public" returntype="any" output="false">
<cfargument name="configBean" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.dsn=variables.configBean.getDatasource()/>
	<cfreturn this />
</cffunction>

<cffunction name="getBean" access="public" returntype="any">
	<cfreturn createObject("component","mura.mailinglist.memberBean").init()>
</cffunction>

<cffunction name="create" access="public" output="false" returntype="void" >
	<cfargument name="memberBean" type="any" />
	<cfset var L=""/>
	<cfset var currBean=read(arguments.memberBean.getEmail(),arguments.memberBean.getSiteID()) />
	
		<cfif REFindNoCase("^[^@%*<>' ]+@[^@%*<>' ]{1,255}\.[^@%*<>' ]{2,5}", trim(arguments.memberBean.getEmail())) neq 0>
					
				
			<cfloop list="#arguments.memberBean.getMLID()#" index="L">
				<cfif not listfind(currBean.getMLID(),L)>
					<cftry>
					<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
					insert into tmailinglistmembers (mlid,email,siteid,fname,lname,company,isVerified,created)
					values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#L#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.memberBean.getEmail())#" />
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.memberBean.getSiteID()#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.memberBean.getFName() neq '',de('no'),de('yes'))#" value="#arguments.memberBean.getFName()#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.memberBean.getLName() neq '',de('no'),de('yes'))#" value="#arguments.memberBean.getLName()#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.memberBean.getCompany() neq '',de('no'),de('yes'))#" value="#arguments.memberBean.getCompany()#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.memberBean.getIsVerified()#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					)
					</cfquery>
					<cfcatch type="database"></cfcatch>
					</cftry>
				</cfif>
			</cfloop>
		</cfif>
		
</cffunction>

<cffunction name="read" access="public" output="false" returntype="any" >
	<cfargument name="email" type="string" />
	<cfargument name="siteID" type="string" />
	<cfset var memberBean=getBean() />
	<cfset var rs ="" />
	<cfset var data =structNew() />
	
	<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	Select mlid,siteid,email,fname,lname,company,isVerified,created from tmailinglistmembers where 
	siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.siteID)#">
	and email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.email)#" />
	</cfquery>
	
	<cfset data.siteid=arguments.siteid>
	<cfset data.email=arguments.email>
	<cfset data.lName=rs.lName>
	<cfset data.fName=rs.fName>
	<cfset data.company=rs.company>
	<cfset data.mlid=valueList(rs.mlid)>
	<cfset data.isVerified=rs.isVerified>
	
	<cfif rs.recordcount>
	<cfset memberBean.set(data) />
	</cfif>
	
	<cfreturn memberBean />
</cffunction>

<cffunction name="update" access="public" output="false" returntype="void" >
	<cfargument name="memberBean" type="any" />

	<cfif REFindNoCase("^[^@%*<> ]+@[^@%*<> ]{1,255}\.[^@%*<> ]{2,5}", trim(arguments.memberBean.getEmail())) neq 0>
		<cftry>
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
		update tmailinglistmembers 
		set 
		fName= <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.memberBean.getFName() neq '',de('no'),de('yes'))#" value="#arguments.memberBean.getFName()#">
		,lName= <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.memberBean.getLName() neq '',de('no'),de('yes'))#" value="#arguments.memberBean.getLName()#">
		,company= <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.memberBean.getCompany() neq '',de('no'),de('yes'))#" value="#arguments.memberBean.getCompany()#">
		,isVerified= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.memberBean.getIsVerified()#">
		where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.memberBean.getSiteID())#">
		and email= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.memberBean.getEmail())#" />
		</cfquery>
		<cfcatch type="database"></cfcatch>
		</cftry>
	</cfif>

</cffunction>

<cffunction name="deleteAll" access="public" output="false" returntype="void" >
	<cfargument name="memberBean" type="any" />

	<cfif REFindNoCase("^[^@%*<> ]+@[^@%*<> ]{1,255}\.[^@%*<> ]{2,5}", trim(arguments.memberBean.getEmail())) neq 0>
		<cftry>
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from tmailinglistmembers where email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.memberBean.getEmail())#" /> and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.memberBean.getsiteID())#" />
		</cfquery>
		<cfcatch type="database"></cfcatch>
		</cftry>
	</cfif>

</cffunction>

<cffunction name="delete" access="public" output="false" returntype="void" >
	<cfargument name="memberBean" type="any" />
	
	<cfif REFindNoCase("^[^@%*<> ]+@[^@%*<> ]{1,255}\.[^@%*<> ]{2,5}", trim(arguments.memberBean.getEmail())) neq 0>
		<cftry>
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
		delete from tmailinglistmembers where mlid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.memberBean.getMLID()#" /> and email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.memberBean.getEmail())#" /> and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.memberBean.getSiteID()#" />
		</cfquery>
		<cfcatch type="database"></cfcatch>
		</cftry>
	</cfif>

</cffunction>


</cfcomponent>