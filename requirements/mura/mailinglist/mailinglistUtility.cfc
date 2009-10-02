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
<cfcomponent extends="mura.cfobject" output="false">
<cffunction name="init" access="public" returntype="any" output="false">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>
		<cfset var fileDelim="/"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.utility=arguments.utility />
		<cfset fileDelim=variables.configBean.getFileDelim() />
		<cfreturn this />
</cffunction>


<cffunction name="upload" access="public" returntype="void" output="false">
	<cfargument name="direction" type="string" />
	<cfargument name="listBean" type="any" />
	<cfset var templist ="" />
	<cfset var fieldlist ="" />
	<cfset var data="">
	<cfset var I=0/>
	
	<cffile  action="upload" destination="#getTempDirectory()#"  filefield="listfile" nameconflict="makeunique"  accept="text/*">
	
	<cffile 
	file="#getTempDirectory()##file.serverfile#"
	ACTION="read" variable="tempList">
	
	<cfset tempList=variables.utility.fixLineBreaks(tempList)>
	<cfset tempList = "#REReplace(tempList, chr(13) & chr(10), "|", "ALL")#">
	
	<cfif arguments.direction eq 'replace'>
		<cfset application.mailingListManager.deleteMembers(arguments.listBean.getMLID(),arguments.listBean.getSiteID()) />
	</cfif>
	
	<cfloop list="#templist#" index="I"  delimiters="|">
	<cfif REFindNoCase("^[^@%*<>' ]+@[^@%*<>' ]{1,255}\.[^@%*<>' ]{2,5}", trim(listFirst(i,chr(9)))) neq 0 > 

		<cfif arguments.direction eq 'add' or arguments.direction eq 'replace'>
		<cftry>	
			<cfset data=structNew()>
			<cfset data.mlid=arguments.listBean.getMLID() />
			<cfset data.siteid=arguments.listBean.getsiteid() />
			<cfset data.isVerified=1 />
			<cfset data.email=listFirst(I,chr(9)) />
			<cfset data.fname=listgetat(I,2,chr(9)) />
			<cfset data.lname=listgetat(I,3,chr(9)) />
			<cfset data.company=listgetat(I,4,chr(9)) />	
		<cfcatch></cfcatch>
		</cftry>
		
		<cfset application.mailinglistManager.createMember(data) />
	
		<cfelseif  arguments.direction eq 'remove'>
			<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			delete from tmailinglistmembers where email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#listFirst(i,chr(9))#" /> and mlid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listBean.getMLID()#" /> and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listBean.getSiteID()#" />
			</cfquery>
		</cfif>
	</cfif>
	</cfloop> 
	
	<cffile 
	file="#getTempDirectory()##file.serverfile#"
	ACTION="delete">

</cffunction>
</cfcomponent>