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
<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" returntype="any" access="public" output="false">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.settingsManager=arguments.settingsManager />
<cfreturn this />
</cffunction>

<cffunction name="getGroupPermVerdict" returntype="numeric" access="public" output="false">
		<cfargument name="ContentID" type="string" required="true">
		<cfargument name="GroupID" type="string" required="true">
		<cfargument name="Type" type="string" required="false" default="Editor">
		<cfargument name="siteid" type="string" required="true">
		<cfset var perm=0>
		<cfset var rsPermited="">
		
		<cfquery name="rsPermited" datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		Select GroupID from tpermissions where ContentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/> and type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#"/> and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> and groupid='#arguments.groupid#'
		</cfquery>
		
	<cfif rsPermited.recordcount>
	<cfset perm=1>
	</cfif>
		
		 <cfreturn perm>
	</cffunction>

<cffunction name="getGroupPerm" returntype="string" access="public" output="false">
		<cfargument name="GroupID" type="string" required="true">
		<cfargument name="ContentID" type="string" required="true">
		<cfargument name="siteid" type="string" required="true">
		<cfset var verdict="">
		
		<cfif getgrouppermverdict(arguments.contentid,arguments.groupid,'editor',arguments.siteid)>
				<cfset verdict='editor'>
			<cfelse>
				<cfif getgrouppermverdict(arguments.contentid,arguments.groupid,'author',arguments.siteid)>
					<cfset verdict='author'>
				<cfelseif getgrouppermverdict(arguments.contentid,arguments.groupid,'read',arguments.siteid)>
					<cfset verdict='read'>
				<cfelseif getgrouppermverdict(arguments.contentid,arguments.groupid,'deny',arguments.siteid)>
					<cfset verdict='deny'>
				<cfelse>
					<cfset verdict='none'>
				</cfif>
			</cfif>

		<cfreturn verdict>
</cffunction>

<cffunction name="getPermVerdict" returntype="numeric" access="public" output="false">
		<cfargument name="ContentID" type="string" required="true">
		<cfargument name="Type" type="string" required="false" default="Editor">
		<cfargument name="siteid" type="string" required="true">
		<cfset var rsPermited1="">
		<cfset var rsPermited2=""/>
		<cfset var perm=0>
		
		<cfquery name="rsPermited1" datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		Select GroupName, isPublic from tusers where userid in
		(Select GroupID from tpermissions where ContentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/> and type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#"/> and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>) 
		</cfquery>
		
		<cfloop query="rsPermited1">
		<cfif rsPermited1.isPublic>
		<cfif isUserInRole("#rsPermited1.groupname#;#application.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#;1")><cfset perm=1><cfbreak></cfif>
		<cfelse>
		<cfif isUserInRole("#rsPermited1.groupname#;#application.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#;0")><cfset perm=1><cfbreak></cfif>
		</cfif>
		</cfloop>
		<!---
		<cfif perm neq 1>
				<cfquery name="rsPermited2" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
				Select GroupName from tusers where userid in
				(Select GroupID from tpermissions where ContentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/> and type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#"/> and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>) 
				 and isPublic=0
				</cfquery>
				
				<cfloop query="rsPermited2">
				<cfif isUserInRole(rsPermited2.groupname)><cfset perm=1></cfif>
				</cfloop>
		
		</cfif>--->
		
		 <cfreturn perm>
</cffunction>

<cffunction name="getPerm" returntype="string" access="public" output="false">
		<cfargument name="ContentID" type="string" required="true">
		<cfargument name="siteid" type="string" required="true">
		<cfset var verdict="none">

		<cfif isUserInRole('Admin;#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#;0') or  isUserInRole('S2') >
			<cfset Verdict="editor">
		<cfelse>
			<cfif getpermverdict(arguments.contentid,'editor',arguments.siteid)>
				<cfset verdict='editor'>
			<cfelseif getpermverdict(arguments.contentid,'author',arguments.siteid)>
				<cfset verdict='author'>
			<cfelseif getpermverdict(arguments.contentid,'deny',arguments.siteid)>
				<cfset verdict='deny'>
			</cfif>
		</cfif>

	<cfreturn verdict>
</cffunction>

<cffunction name="getPermPublic" returntype="string" access="public" output="false">
		<cfargument name="ContentID" type="string" required="true">
		<cfargument name="siteid" type="string" required="true">
		<cfset var verdict="none">

		<cfif isUserInRole('Admin;#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#;0') or  isUserInRole('S2') >
			<cfset verdict="editor">
		<cfelse>
			<cfif getpermverdict(arguments.contentid,'editor',arguments.siteid)>
				<cfset verdict='editor'>
			<cfelseif getpermverdict(arguments.contentid,'author',arguments.siteid)>
				<cfset verdict='author'>
			<cfelseif getpermverdict(arguments.contentid,'read',arguments.siteid)>
				<cfset verdict='read'>
			<cfelseif getpermverdict(arguments.contentid,'deny',arguments.siteid)>
				<cfset verdict='deny'>
			</cfif>
		</cfif>

	<cfreturn verdict>
</cffunction>

<cffunction name="getNodePerm" output="false" returntype="string">
		<cfargument name="crumbdata" required="yes" type="array">
		<cfset var verdictlist="" />
		<cfset var verdict="" />
		<cfset var I = "" />
		
		<cfloop from="1" to="#arrayLen(arguments.crumbdata)#" index="I">
		<cfset verdict=getPerm(arguments.crumbdata[I].contentid,arguments.crumbdata[I].siteid)/>
		<cfif verdict neq 'none'><cfbreak></cfif>
		</cfloop>
		
		<cfif verdict eq 'deny' or verdict eq 'read' or verdict eq ''>
		<cfset verdict='none'>
		</cfif>
		
		<cfreturn verdict>
</cffunction>

<cffunction name="getNodePermPublic" output="false" returntype="string">
		<cfargument name="crumbdata" required="yes" type="array">
		<cfset var verdictlist="" />
		<cfset var verdict="" />
		<cfset var I = "" />
		<cfset var key= "perm" & arguments.crumbdata[1].siteid & arguments.crumbdata[1].contentID />
		<cfset var site=variables.settingsManager.getSite(arguments.siteid)/>
		<cfset var cacheFactory=site.getCacheFactory()>
		
		<cfif site.getCache()>
		
			<cfif NOT cacheFactory.has( key )>
			
				<cfset verdict=buildNodePermPublic(arguments.crumbData)>
				
				<cfreturn cacheFactory.get( key, verdict ) />
			<cfelse>
				<cfreturn cacheFactory.get( key ) />
			</cfif>
		<cfelse>
			<cfreturn buildNodePermPublic(arguments.crumbData)/>
		</cfif>
			
</cffunction>

<cffunction name="buildNodePermPublic" output="false" returntype="string">
		<cfargument name="crumbdata" required="yes" type="array">
		<cfset var verdictlist="" />
		<cfset var verdict="" />
		<cfset var I = "" />
	
		<cfloop from="1" to="#arrayLen(arguments.crumbdata)#" index="I">
			<cfset verdict=getPermPublic(arguments.crumbdata[I].contentid,arguments.crumbdata[I].siteid)/>
			<cfif verdict neq 'none'><cfbreak></cfif>
		</cfloop>
				
		<cfif verdict eq 'deny'>
			<cfset verdict='none'>
		</cfif>
		
		<cfreturn verdict/>
</cffunction>

<cffunction name="getModulePerm" returntype="boolean" access="public" output="false">
		<cfargument name="moduleID" type="string" required="true">
		<cfargument name="siteid" type="string" required="true">
		<cfset var Verdict=0>
		<cfset var key="mod" & arguments.siteid & arguments.moduleID />
		<cfset var site=variables.settingsManager.getSite(arguments.siteid)/>
		<cfset var cacheFactory=site.getCacheFactory()>
		
		<cfif site.getCache()>
			<cfif NOT cacheFactory.has( key )>
	
				<cfset verdict=buildModulePerm(arguments.moduleID,arguments.siteID)>
				
				<cfreturn cacheFactory.get( key, verdict ) />
			<cfelse>
				<cfreturn cacheFactory.get( key ) />
			</cfif>
		<cfelse>
			<cfreturn buildModulePerm(arguments.moduleID,arguments.siteID) />
		</cfif>

</cffunction>

<cffunction name="buildModulePerm" returntype="boolean" access="public" output="false">
		<cfargument name="moduleID" type="string" required="true">
		<cfargument name="siteid" type="string" required="true">
		<cfset var Verdict=0>
		<cfset var rsgroups="">

			<cfif isUserInRole('Admin;#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#;0') or  isUserInRole('S2') >
				<cfset Verdict=1>
			<cfelse>
				<cfquery datasource="#variables.configBean.getDatasource()#" name="rsgroups" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				select tusers.groupname,isPublic from tusers INNER JOIN tpermissions ON (tusers.userid = tpermissions.groupid) where tpermissions.contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#"/> and tpermissions.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> 
				</cfquery>
				
				<cfloop query="rsgroups">
				<cfif rsGroups.isPublic>
				<cfif isUserInRole("#rsgroups.groupname#;#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#;1")><cfset verdict=1></cfif>
				<cfelse>
				<cfif isUserInRole("#rsgroups.groupname#;#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#;0")><cfset verdict=1></cfif>
				</cfif>
				</cfloop>
			</cfif>
	
			<cfreturn verdict>

</cffunction>

<cffunction name="setRestriction" returntype="struct" access="public" output="false">
			<cfargument name="crumbdata" required="yes" type="array">
			<cfargument name="hasModuleAccess" required="yes" default="">
			<cfset var r=structnew() />
			<cfset var I = "">
			<cfset var G=0/>
			<cfset r.allow=1 />
			<cfset r.restrict=0 />
			<cfset r.loggedIn=1 />
			<cfset r.perm="read" />
			<cfset r.restrictGroups="" />
			<cfset r.hasModuleAccess=0 />
			
			<cfif not len(getAuthUser()) >
				<cfif cgi.HTTP_USER_AGENT eq 'vspider' and cgi.SERVER_NAME eq 'LOCALHOST' >
					<cfreturn r>
				</cfif>
				<cfset r.loggedIn=0>
			</cfif>
			
			<cfif not isBoolean(arguments.hasModuleAccess)>
				<cfset r.hasModuleAccess=getModulePerm('00000000000000000000000000000000000','#arguments.crumbdata[1].siteid#')>
			<cfelse>
				<cfset r.hasModuleAccess=arguments.hasModuleAccess>
			</cfif>
			
			<!--- Check to see if this node is restricted--->
			<cfloop from="1" to="#arrayLen(arguments.crumbdata)#" index="I" step="1">
				<cfif arguments.crumbdata[I].restricted eq 1>
					<cfset r.restrict=1>
					<cfset r.allow=0>
					<cfset r.perm="none" />
					<cfset r.restrictGroups=arguments.crumbdata[I].restrictGroups />
					<cfset r.siteid=arguments.crumbdata[I].siteid />
					<cfbreak>
				</cfif>
			</cfloop> 
			
			<!--- Super users can do anyting --->
			<cfif len(getAuthUser())>
				<cfif isuserinrole('S2')>
					<cfset r.allow=1>
					<cfset r.perm="editor" />
					<cfreturn r>
				
				<!--- If use had module access Check for  user assignments--->
				<cfelseif r.hasModuleAccess>
					<cfset r.perm=getNodePermPublic(arguments.crumbdata)>
					<cfif r.perm neq 'none' >
						<cfset r.allow=1>
						<cfreturn r>
					</cfif>
				</cfif>
			</cfif>	
			
			<!--- Check for member group restrictions set on the content node advanced tab--->
			<cfif r.restrict and r.loggedIn>			
					<cfif r.restrictGroups eq ''>
						<cfset r.allow=1>
						<cfset r.perm="read">
					<cfelseif r.restrictGroups neq ''>
						<cfloop list="#r.restrictGroups#" index="G">
							<cfif isUserInRole("#G#;#variables.settingsManager.getSite(r.siteid).getPublicUserPoolID()#;1")
									or isUserInRole("#G#;#variables.settingsManager.getSite(r.siteid).getPrivateUserPoolID()#;0")>
								<cfset r.allow=1>
								<cfset r.perm="read">
							</cfif>
						</cfloop>				
					</cfif>		
			</cfif>
	
			<cfreturn r>
</cffunction>

<cffunction name="getCategoryPerm" returntype="boolean" access="public" output="false">
			<cfargument name="groupList" required="yes" type="string">
			<cfargument name="siteid" required="yes" type="string">
			
			<cfset var groupArray = "" />
			<cfset var I = "" />
			
			
			<cfif arguments.groupList neq ''>
			
				<cfif isUserInRole('Admin;#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#;0')
					or isUserInRole('S2')>
					<cfreturn true />
				</cfif>
				
				<cfset groupArray = listtoarray(arguments.grouplist) />
				<cfloop from="1" to="#arrayLen(groupArray)#" index="I" step="1">
					<cfif isUserInRole('#groupArray[I]#;#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#;0')
							or isUserInRole('#groupArray[I]#;#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#;1')>
						<cfreturn true />
					</cfif>				
				</cfloop>
				
				<cfreturn false />
			</cfif>
		
			
			<cfreturn true />
</cffunction>

<cffunction name="getNodePermGroups"  output="false" returntype="struct" >
		<cfargument name="crumbdata" required="yes" type="array">
		<cfset var permStruct=structnew()>
		<cfset var editorlist=""/>
		<cfset var authorlist=""/>
		<cfset var rsGroups=""/>
		<cfset var deny=false />
		<cfset var author=false />
		<cfset var editor=false />
		<cfset var Verdictlist=""/>
		<cfset var I = "" />
		
		<cfquery name="rsGroups" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		select groupid from tpermissions where contentid='00000000000000000000000000000000000' and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.crumbdata[1].siteid#"/>
		</cfquery>
		
		<cfloop query="rsGroups">
		<cfset Verdictlist="">
			<cfloop from="#arrayLen(arguments.crumbdata)#" to="1" index="I" step="-1">
			<cfset verdictlist=listappend(verdictlist,getGroupPerm(rsgroups.groupid,arguments.crumbdata[I].contentid,arguments.crumbdata[I].siteid))>
			</cfloop>
			
			<cfset deny=listfind(verdictlist,'deny')>
			<cfset author=listfind(verdictlist,'author')>
			<cfset editor=listfind(verdictlist,'editor')>
			
			<cfif editor gt deny and editor gt author>
				<cfset editorList=listappend(editorList,rsgroups.groupid)>
			<cfelseif author gt deny and author gt editor>
				<cfset authorList=listappend(authorList,rsgroups.groupid)>
			</cfif>
			
		</cfloop>
		
		<cfset permStruct.authorList=authorList>
		<cfset permStruct.editorList=editorList>
		
		<cfreturn permStruct>
</cffunction>

<cffunction name="update" returntype="void" access="public" output="false">
<cfargument name="data" type="struct" />
<cfset var rsGroups=""/>

	<cfquery name="rsgroups" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select UserID from tusers where type =1 
	</cfquery> 
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	Delete From tpermissions where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.contentID#"/> and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.siteid#"/>
	</cfquery>
	
	<cfloop query="rsGroups">
<cfif isdefined('arguments.data.p#replacelist(rsGroups.userid,"-","")#') and (evaluate("form.p#replacelist(rsGroups.userid,"-","")#") eq 'Editor'
 or evaluate("arguments.data.p#replacelist(rsGroups.userid,"-","")#") eq 'Author'
 or evaluate("arguments.data.p#replacelist(rsGroups.userid,"-","")#") eq 'Read'  
 or evaluate("arguments.data.p#replacelist(rsGroups.userid,"-","")#") eq 'Deny')>
	<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	Insert Into tpermissions  (ContentID,GroupID,Type,siteid)
	values(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.ContentID#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGroups.UserID#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("arguments.data.p#replacelist(rsGroups.userid,"-","")#")#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.siteid#"/>
	)</cfquery>
	
	</cfif>

</cfloop>

	<cfset variables.settingsManager.getSite(arguments.data.siteid).purgeCache()>
</cffunction>

<cffunction name="updateGroup" returntype="void" access="public" output="true">
<cfargument name="data" type="struct" />
<cfset var rsContentlist=""/>
<cftransaction>
	<cfquery name="rsContentlist" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select contentID from tcontent where siteid='#arguments.data.siteid#' group by contentid
	</cfquery> 
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	Delete From tpermissions where groupid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.groupID#"/> and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.siteid#"/>
	</cfquery>
	
	<cfloop query="rsContentlist">
	<cfif isdefined('arguments.data.p#replacelist(rsContentlist.contentid,"-","")#')
	 and 
	 (evaluate("arguments.data.p#replacelist(rsContentlist.contentid,"-","")#") eq 'Editor' 
	 	or evaluate("arguments.data.p#replacelist(rsContentlist.contentid,"-","")#") eq 'Author'  
		or evaluate("arguments.data.p#replacelist(rsContentlist.contentid,"-","")#") eq 'Module')>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	Insert Into tpermissions  (ContentID,GroupID,Type,siteid)
	values(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsContentlist.ContentID#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.groupid#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("form.p#replacelist(rsContentlist.contentid,"-","")#")#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.siteid#"/>
	)</cfquery>
	
	</cfif>

	
</cfloop>

</cftransaction>

	<cfset variables.settingsManager.getSite(arguments.data.siteid).purgeCache()>
	
</cffunction>

<cffunction name="getModule" access="public" returntype="query" output="false">
<cfargument name="data" type="struct" />
<cfset var rs = "" />
<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
SELECT * FROM tcontent WHERE 
 ContentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.contentID#"/> and  siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.siteid#"/> and active=1
</cfquery>
<cfreturn rs />
</cffunction>
	
<cffunction name="getGroupList" access="public" returntype="struct" output="false">
<cfargument name="data" type="struct" />
<cfset var rs = "" />
<cfset var returnStruct=structNew() />
<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select userid, groupname from tusers where type=1 and groupname <>'Admin' and isPublic=0 
and siteid='#application.settingsManager.getSite(arguments.data.siteid).getPrivateUserPoolID()#' 
order by groupname
</cfquery>

<cfset returnStruct.privateGroups=rs />

<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select userid, groupname from tusers where type=1  and isPublic=1 
and siteid='#application.settingsManager.getSite(arguments.data.siteid).getPublicUserPoolID()#' 
order by groupname
</cfquery>

<cfset returnStruct.publicGroups=rs />

<cfreturn returnStruct />
</cffunction>

<cffunction name="getPermitedGroups"  access="public" returntype="query" output="false">
<cfargument name="data" type="struct" />
<cfset var rs = "" />
<cfquery name="rs" datasource="#variables.configBean.getDatasource()#"
username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select * from tpermissions where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.contentID#"/> and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.siteid#"/> and type='module'
</cfquery>
<cfreturn rs />
</cffunction>

<cffunction name="getcontent" access="public" returntype="query" output="false">
<cfargument name="data" type="struct" />
<cfset var rs = "" />
<cfquery name="rs" datasource="#variables.configBean.getDatasource()#"
username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
SELECT tcontent.*, tfiles.fileEXT FROM tcontent 
LEFT Join tfiles ON (tcontent.fileID=tfiles.fileID)
WHERE tcontent.ContentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.contentID#"/> and tcontent.active=1 and tcontent.siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.siteid#"/>
</cfquery>
<cfreturn rs />
</cffunction>

<cffunction name="updateModule" access="public"  returntype="void" output="false">
<cfargument name="data" type="struct" />
<cfset var I = "" />
<cfparam name="arguments.data.groupid" type="string" default="" />
<cftransaction>

<cfquery datasource="#variables.configBean.getDatasource()#"
username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	Delete From tpermissions where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.contentID#"/> and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.siteid#"/>
	</cfquery>
	
	
	<cfloop list="#arguments.data.groupid#" index="I">

	<cfquery datasource="#variables.configBean.getDatasource()#"
	username="#variables.configBean.getDBUsername()#" 				password="#variables.configBean.getDBPassword()#">
	Insert Into tpermissions  (ContentID,GroupID,Type,siteid)
	values(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.contentID#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#I#"/>,
	'module',
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.siteid#"/>
	)</cfquery>
	
	<cfset variables.settingsManager.getSite(arguments.data.siteid).purgeCache()>

</cfloop>

</cftransaction>

</cffunction>

<cffunction name="isPrivateUser" access="public" returntype="boolean" output="false">
<cfargument name="siteID" required="true" default="" />		
	
	<cfif arguments.siteID neq ''>
		<cfreturn isUserInRole('S2IsPrivate;#arguments.siteid#') />
	<cfelse>
		<cfreturn isUserInRole('S2IsPrivate') />
	</cfif>
	
</cffunction>

<cffunction name="isUserInGroup" access="public" returntype="boolean" output="false">	
<cfargument name="group" required="true" default="" />		
<cfargument name="siteID" required="true" default="" />
<cfargument name="isPublic" required="true" default="1" />
	
	<cfreturn isUserInRole('#arguments.group#;#arguments.siteid#;#arguments.isPublic#') />
		
</cffunction>

<cffunction name="isS2" access="public" returntype="boolean" output="false">
	
	<cfreturn isUserInRole('S2') />
	
</cffunction>

<cffunction name="queryPermFilter" returntype="query" access="public" output="false">
	<cfargument name="rawQuery" type="query">
	<cfargument name="resultQuery" type="query">
	<cfargument name="siteID" type="string">
	<cfargument name="hasModuleAccess" required="true" default="">
	
	<cfset var rows=0/>
	<cfset var r=""/>
	<cfset var rs=arguments.resultQuery />
	<cfset var hasPath=listFind(arguments.rawQuery.columnList,"PATH")/>
	<cfif not isBoolean(arguments.hasModuleAccess)>
		<cfset arguments.hasModuleAccess=getModulePerm('00000000000000000000000000000000000',arguments.siteID)>
	</cfif>
	
	<cfloop query="arguments.rawQuery">
	<cfif hasPath>
		<cfset r=setRestriction(application.contentGateway.getCrumblist('#arguments.rawQuery.contentid#','#arguments.siteid#',false,arguments.rawQuery.path))/>
	<cfelse>
		<cfset r=setRestriction(application.contentGateway.getCrumblist('#arguments.rawQuery.contentid#','#arguments.siteid#',false))/>
	</cfif>
	<cfif not r.restrict or r.restrict and r.allow>
	<cfset rows=rows+1/>
	<cfset queryAddRow(rs,1)/>
	<cfset querysetcell(rs,"contentid",arguments.rawQuery.contentid,rows)/>
	<cfset querysetcell(rs,"contentHistid",arguments.rawQuery.contentHistid,rows)/>
	<cfset querysetcell(rs,"siteid",request.siteid,rows)/>
	<cfset querysetcell(rs,"filename",arguments.rawQuery.filename,rows)/>
	<cfset querysetcell(rs,"menutitle",arguments.rawQuery.menutitle,rows)/>
	<cfset querysetcell(rs,"title",arguments.rawQuery.title,rows)/>
	<cfset querysetcell(rs,"targetParams",arguments.rawQuery.targetParams,rows)/>
	<cfset querysetcell(rs,"Summary",arguments.rawQuery.summary,rows)/>
	<cfset querysetcell(rs,"tags",arguments.rawQuery.tags,rows)/>
	<cfset querysetcell(rs,"restricted",arguments.rawQuery.restricted,rows)/>
	<cfset querysetcell(rs,"releasedate",arguments.rawQuery.releasedate,rows)/>
	<cfset querysetcell(rs,"type",arguments.rawQuery.type,rows)/>
	<cfset querysetcell(rs,"subtype",arguments.rawQuery.subtype,rows)/>
	<cfset querysetcell(rs,"restrictGroups",arguments.rawQuery.restrictGroups,rows)/>
	<cfset querysetcell(rs,"target",arguments.rawQuery.target,rows)/>
	<cfset querysetcell(rs,"displaystart",arguments.rawQuery.displaystart,rows)/>
	<cfset querysetcell(rs,"displaystop",arguments.rawQuery.displaystop,rows)/>
	<cfset querysetcell(rs,"fileid",arguments.rawQuery.fileid,rows)/>
	<cfset querysetcell(rs,"fileSize",arguments.rawQuery.fileSize,rows)/>
	<cfset querysetcell(rs,"fileExt",arguments.rawQuery.fileExt,rows)/>
	<cfset querysetcell(rs,"credits",arguments.rawQuery.credits,rows)/>
	<cfset querysetcell(rs,"remoteSource",arguments.rawQuery.remoteSource,rows)/>
	<cfset querysetcell(rs,"remoteSourceURL",arguments.rawQuery.remoteSourceURL,rows)/>
	<cfset querysetcell(rs,"remoteURL",arguments.rawQuery.remoteURL,rows)/>
	<cfset querysetcell(rs,"audience",arguments.rawQuery.audience,rows)/>
	<cfset querysetcell(rs,"keyPoints",arguments.rawQuery.keyPoints,rows)/>
	<cfset querysetcell(rs,"rating",arguments.rawQuery.rating,rows)/>
	<cfset querysetcell(rs,"comments",arguments.rawQuery.comments,rows)/>
	<cfset querysetcell(rs,"kids",arguments.rawQuery.kids,rows)/>
	<cfset querysetcell(rs,"upVotes",arguments.rawQuery.upVotes,rows)/>
	<cfset querysetcell(rs,"totalVotes",arguments.rawQuery.totalVotes,rows)/>
	<cfset querysetcell(rs,"downVotes",arguments.rawQuery.downVotes,rows)/>
	<cfset querysetcell(rs,"parentType",arguments.rawQuery.parentType,rows)/>
	</cfif>
	</cfloop>
	
	<cfreturn rs/>
</cffunction>
	
<cffunction name="newResultQuery" returntype="query" access="public" output="false">
<cfset var rs = "" />
		<cfswitch expression="#variables.configBean.getCompiler()#">
		<cfcase value="railo">
		<cfset rs=queryNew("contentid,contenthistid,siteid,title,menutitle,targetParams,filename,summary,tags,restricted,type,subType,restrictgroups,target,fileid,fileSize,fileExt,credits,remoteSource,remoteSourceURL,remoteURL,audience,keyPoints,rating,comments,kids,totalVotes,downVotes,upVotes,parentType,displaystart,displaystop,releasedate","VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,INTEGER,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR")/>
		</cfcase>
		<cfdefaultcase>
		<cfset rs=queryNew("contentid,contenthistid,siteid,title,menutitle,targetParams,filename,summary,tags,restricted,type,subType,restrictgroups,target,fileid,fileSize,fileExt,credits,remoteSource,remoteSourceURL,remoteURL,audience,keyPoints,rating,comments,kids,totalVotes,downVotes,upVotes,parentType,displaystart,displaystop,releasedate","CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_INTEGER,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_TIMESTAMP,CF_SQL_TIMESTAMP,CF_SQL_TIMESTAMP")/>
		</cfdefaultcase>
		</cfswitch>
	<cfreturn rs/>
</cffunction>
</cfcomponent>