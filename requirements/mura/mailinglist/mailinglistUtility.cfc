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
	
	<cffile  action="upload" destination="#variables.configBean.getTempDir()#"  filefield="listfile" nameconflict="makeunique"  accept="text/*">
	
	<cffile 
	file="#variables.configBean.getTempDir()##cffile.serverfile#"
	ACTION="read" variable="tempList">
	
	<!---<cfset tempList=variables.utility.fixLineBreaks(tempList)>
	<cfset tempList = "#REReplace(tempList, chr(13) & chr(10), "|", "ALL")#">--->
	<cfset tempList = "#reReplace(tempList,"#chr(10)#|#chr(13)#|(#chr(13)##chr(10)#)|\n|(\r\n)","|","all")#">
	<cfif arguments.direction eq 'replace'>
		<cfset application.mailingListManager.deleteMembers(arguments.listBean.getMLID(),arguments.listBean.getSiteID()) />
	</cfif>
	
	<cfloop list="#templist#" index="I"  delimiters="|">
	<cfif REFindNoCase("^[^@%*<>' ]+@[^@%*<>' ]{1,255}\.[^@%*<>' ]{2,5}", trim(listFirst(i,chr(9)))) neq 0 > 

		<cfif arguments.direction eq 'add' or arguments.direction eq 'replace'>
		<cfset I = variables.utility.listFix(I,chr(9),"_null_")>
		<cftry>	
			<cfset data=structNew()>
			<cfset data.mlid=arguments.listBean.getMLID() />
			<cfset data.siteid=arguments.listBean.getsiteid() />
			<cfset data.isVerified=1 />
			<cfset data.email=listFirst(I,chr(9)) />
			<cfset data.fname=listgetat(I,2,chr(9)) />
			<cfif data.fname eq "_null_">
				<cfset data.fname="" />	
			</cfif>
			<cfset data.lname=listgetat(I,3,chr(9)) />
			<cfif data.lname eq "_null_">
				<cfset data.lname="" />	
			</cfif>
			<cfset data.company=listgetat(I,4,chr(9)) />	
			<cfif data.company eq "_null_">
				<cfset data.company="" />	
			</cfif>
		<cfcatch></cfcatch>
		</cftry>
		
		<cfset application.mailinglistManager.createMember(data) />
	
		<cfelseif  arguments.direction eq 'remove'>
			<cfquery>
			delete from tmailinglistmembers where email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#listFirst(i,chr(9))#" /> and mlid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listBean.getMLID()#" /> and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listBean.getSiteID()#" />
			</cfquery>
		</cfif>
	</cfif>
	</cfloop> 
	
	<cffile 
	file="#variables.configBean.getTempDir()##cffile.serverfile#"
	ACTION="delete">

</cffunction>
</cfcomponent>