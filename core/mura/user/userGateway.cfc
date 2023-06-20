<!---
	
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the  
same licensing model. It is, therefore, licensed under the Gnu General Public License 
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing 
notice set out below. That exception is also granted by the copyright holders of Masa CMS 
also applies to this file and Masa CMS in general. 

This file has been modified from the original version received from Mura CMS. The 
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright 
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained 
only to ensure software compatibility, and compliance with the terms of the GPLv2 and 
the exception set out below. That use is not intended to suggest any commercial relationship 
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa. 

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com  

Masa CMS is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, Version 2 of the License. 
Masa CMS is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>. 

The original complete licensing notice from the Mura CMS version of this file is as 
follows: 

This file is part of Mura CMS.

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
	 /core/mura/
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
<cfcomponent extends="mura.cfobject" output="false" hint="This provides user gateway queries">

	<cfset variables.fieldList="tusers.userID, tusers.GroupName, tusers.Fname, tusers.Lname, tusers.UserName, tusers.PasswordCreated, tusers.Email, tusers.Company, tusers.JobTitle, tusers.MobilePhone, tusers.Website, tusers.Type, tusers.subType, tusers.ContactForm, tusers.S2, tusers.LastLogin, tusers.LastUpdate, tusers.LastUpdateBy, tusers.LastUpdateByID, tusers.Perm, tusers.InActive, tusers.IsPublic, tusers.SiteID, tusers.Subscribe, tusers.Notes, tusers.description, tusers.Interests, tusers.keepPrivate, tusers.PhotoFileID, tusers.IMName, tusers.IMService, tusers.Created, tusers.RemoteID, tusers.Tags, tusers.tablist, tfiles.fileEXT photoFileExt">

	<cffunction name="init" output="false">
		<cfargument name="configBean" type="any" required="yes"/>
		<cfargument name="settingsManager" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.classExtensionManager=variables.configBean.getClassExtensionManager()>
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfreturn this />
	</cffunction>

	<cffunction name="getUserGroups" output="false">
		<cfargument name="siteid" type="string" default="" />
		<cfargument name="isPublic" type="numeric" default="0" />
		<cfset var rsUserGroups = "" />

		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsUserGroups')#">
		SELECT tusers.UserID, tusers.Email, tusers.GroupName, tusers.Type, tusers.LastLogin, tusers.LastUpdate, tusers.LastUpdateBy,
		tusers.LastUpdateByID, memberQuery.Counter, tusers.Perm, tusers.isPublic
		FROM tusers LEFT JOIN
		(select tusersmemb.groupID, count(tusersmemb.groupID) Counter
		from tusersmemb inner join tusers on (tusersmemb.userID=tusers.userID)
		where
		tusers.siteid = <cfif arguments.isPublic eq 0 >
			'#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#'
			<cfelse>
			'#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#'
			</cfif>
		group by tusersmemb.groupID
		) memberQuery ON tusers.UserID = memberQuery.GroupID
		WHERE tusers.Type=1 and tusers.isPublic=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isPublic#"> and
		tusers.siteid = <cfif arguments.isPublic eq 0 >
			'#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#'
			<cfelse>
			'#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#'
			</cfif>
		Order by tusers.perm desc, tusers.GroupName
		</cfquery>

		<cfreturn rsUserGroups />
	</cffunction>

	<cffunction name="getSearch" output="false">
		<cfargument name="search" type="string" default="" />
		<cfargument name="siteid" type="string" default="" />
		<cfargument name="isPublic" type="numeric" default="0" />
		<cfset var rsUserSearch = "" />
		<cfset var maxrows=2100>
		<cfset var sessionData=getSession()>

		<cfif variables.configBean.getDbType() eq 'Oracle'>
			<cfset maxrows=990>
		</cfif>

		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsUserSearch',maxrows=maxrows)#">
		Select #variables.fieldList# from tusers
		left join tfiles on tusers.photofileID=tfiles.fileID
		where tusers.type=2 and tusers.isPublic = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isPublic#"> and
		tusers.siteid = <cfif arguments.isPublic eq 0 >
			'#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#'
			<cfelse>
			'#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#'
			</cfif>

		<cfif arguments.search eq ''>
			and 0=1
		</cfif>

		 and (
		 		tusers.lname like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%">
		 		or tusers.fname like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%">
		 		or tusers.company like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%">
		 		or tusers.username like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%">
		 		or tusers.email like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%">
		 		or tusers.jobtitle like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%">)

		<cfif not listFind(sessionData.mura.memberships,'S2')> and tusers.s2=0 </cfif> order by tusers.lname
		</cfquery>

		<cfreturn rsUserSearch />
	</cffunction>

	<cffunction name="getAdvancedSearch" output="false">
		<cfargument name="data" type="any" default="" hint="This can be a struct or an instance of userFeedBean."/>
		<cfargument name="siteid" type="any" hint="deprecated, use userFeedBean.setSiteID()" default=""/>
		<cfargument name="isPublic" type="any" hint="deprecated, use userFeedBean.setIsPublic()" default=""/>
		<cfargument name="countOnly" default="false">

		<cfset var i = 1 />
		<cfset var params=""  />
		<cfset var param=createObject("component","mura.queryParam") />
		<cfset var paramNum=0 />
		<cfset var started=false />
		<cfset var jointables="" />
		<cfset var jointable="">
		<cfset var openGrouping =false />
		<cfset var userPoolID="">
		<cfset var rsAdvancedUserSearch=""/>
		<cfset var rsParams="">
		<cfset var sortOptions="fname,lname,username,company,lastupdate,created,isPubic,email">
		<cfset var isExtendedSort="">
		<cfset var isListParam=false>
		<cfset var join="">
		<cfset var dbtype=variables.configBean.getDbType()>
		<cfset var tableModifier="">
		<cfset var castfield="attributeValue">
		<cfset var sessionData=getSession()>

		<cfif dbtype eq "MSSQL">
		 	<cfset tableModifier="with (nolock)">
		 </cfif>

		<cfif not isObject(arguments.data)>
			<cfset params=getBean("userFeedBean")>
			<cfset params.setParams(data)>
			<cfif isNumeric(arguments.isPublic)>
				<cfset params.setIsPublic(arguments.isPublic)>
			</cfif>
		<cfelse>
			<cfset params=arguments.data>
		</cfif>


		<cfset isExtendedSort=(not listFindNoCase(sortOptions,params.getSortBy())) and not len(params.getSortTable())>

		<cfif len(arguments.siteID)>
			<cfset params.setSiteID(arguments.siteID)>
		</cfif>

		<cfif isNumeric(arguments.isPublic)>
			<cfset params.setIsPublic(arguments.isPublic)>
		</cfif>

		<cfif params.getIsPublic() eq 0 >
			<cfset userPoolID=variables.settingsManager.getSite(params.getSiteID()).getPrivateUserPoolID()>
		<cfelseif params.getIsPublic() eq 1 >
			<cfset userPoolID=variables.settingsManager.getSite(params.getSiteID()).getPublicUserPoolID()>
		<cfelseif variables.settingsManager.getSite(params.getSiteID()).getPublicUserPoolID() neq variables.settingsManager.getSite(params.getSiteID()).getPrivateUserPoolID()>
			<cfset userPoolID=listAppend(variables.settingsManager.getSite(params.getSiteID()).getPublicUserPoolID(),variables.settingsManager.getSite(params.getSiteID()).getPrivateUserPoolID())>
		<cfelse>
			<cfset userPoolID=variables.settingsManager.getSite(params.getSiteID()).getPublicUserPoolID()>
		</cfif>

		<cfset rsParams=params.getParams() />

		<cfloop query="rsParams">
			<cfif listLen(rsParams.field,".") eq 2>
				<cfset jointable=REReplace(listFirst(rsParams.field,"."),"[^0-9A-Za-z_,\- ]","","all") >
				<cfif jointable neq "tusers" and not listFind(jointables,jointable) and not params.hasJoin(jointable)>
					<cfset jointables=listAppend(jointables,jointable)>
				</cfif>
			</cfif>
		</cfloop>

		<!--- Generate a sorted (if specified) list of baseIDs with additional fields --->
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsAdvancedUserSearch',cachedWithin=params.getCachedWithin())#">
		<cfif not arguments.countOnly and dbType eq "oracle" and params.getMaxItems()>select * from (</cfif>
		select <cfif not arguments.countOnly and dbtype eq "mssql" and params.getMaxItems()>top #params.getMaxItems()# </cfif>

		<cfif not arguments.countOnly>
			<cfif len(params.getFields())>
				#REReplace(params.transformFields(params.getFields()),"[^0-9A-Za-z\._,\- ]","","all")#
			<cfelseif params.isAggregateQuery()>
				<cfset started=false>
				<cfif arrayLen(params.getGroupByArray())>
					<cfloop array="#params.getGroupByArray()#" index="local.i">
						<cfif started>, <cfelse><cfset started=true></cfif>
						#sanitizedValue(local.i)#
					</cfloop>
				</cfif>
				<cfif arrayLen(params.getSumValArray())>
					<cfloop array="#params.getSumValArray()#" index="local.i">
						<cfif started>, <cfelse><cfset started=true></cfif>
						sum(#sanitizedValue(local.i)#) as sum_#sanitizedValue(local.i)#
					</cfloop>
				</cfif>
				<cfif arrayLen(params.getCountValArray())>
					<cfloop array="#params.getCountValArray()#" index="local.i">
						<cfif started>, <cfelse><cfset started=true></cfif>
						<cfif listLast(local.i,'.') eq '*'>count(*) as count<cfelse>count(#sanitizedValue(local.i)#) as count_#sanitizedValue(listLast(local.i,'.'))#</cfif>
					</cfloop>
				</cfif>
				<cfif arrayLen(params.getAvgValArray())>
					<cfloop array="#params.getAvgValArray()#" index="local.i">
						<cfif started>, <cfelse><cfset started=true></cfif>
						avg(#sanitizedValue(local.i)#) as avg_#sanitizedValue(listLast(local.i,'.'))#
					</cfloop>
				</cfif>
				<cfif arrayLen(params.getMinValArray())>
					<cfloop array="#params.getMinValArray()#" index="local.i">
						<cfif started>, <cfelse><cfset started=true></cfif>
						min(#sanitizedValue(local.i)#) as min_#sanitizedValue(listLast(local.i,'.'))#
					</cfloop>
				</cfif>
				<cfif arrayLen(params.getMaxValArray())>
					<cfloop array="#params.getMaxValArray()#" index="local.i">
						<cfif started>, <cfelse><cfset started=true></cfif>
						max(#sanitizedValue(local.i)#) as max_#sanitizedValue(listLast(local.i,'.'))#
					</cfloop>
				</cfif>
				<cfset started=false>
			<cfelse>
				#variables.fieldList# <cfif len(params.getAdditionalColumns())>,#params.getAdditionalColumns()#</cfif>
			</cfif>
		<cfelse>
			count(*) as count
		</cfif>

		from tusers
		left join tfiles on tusers.photofileID=tfiles.fileID

		<cfset local.specifiedjoins=params.getJoins()>

		<!--- Join to implied tables based on field prefix --->
		<cfloop list="#jointables#" index="jointable">
			<cfset joinTable=sanitizedValue(jointable)>
			<cfset started=false>

			<cfif arrayLen(params.getJoins())>
				<cfloop from="1" to="#arrayLen(local.specifiedjoins)#" index="local.i">
					<cfif local.specifiedjoins[local.i].table eq jointable>
						<cfset started=true>
						<!--- has explicit join clause--->
						<cfbreak>
					</cfif>
				</cfloop>
			</cfif>
			<cfif not started>
				inner join #jointable# #tableModifier# on (tusers.userid=#jointable#.userid)
			</cfif>
		</cfloop>

		<!--- Join to explicit tables based on join clauses --->
		<cfloop from="1" to="#arrayLen(local.specifiedjoins)#" index="local.i">
			<cfif len(local.specifiedjoins[local.i].clause)>
				#sanitizedValue(local.specifiedjoins[local.i].jointype)# join #sanitizedValue(local.specifiedjoins[local.i].table)# #tableModifier# on (#sanitizedValue(local.specifiedjoins[local.i].clause)#)
			</cfif>
		</cfloop>

		<cfif not arguments.countOnly and isExtendedSort>
		left Join (select
				#variables.classExtensionManager.getCastString(params.getSortBy(),params.getSiteID())# extendedSort
				 ,tclassextenddatauseractivity.baseID
				from tclassextenddatauseractivity inner join tclassextendattributes
				on (tclassextenddatauseractivity.attributeID=tclassextendattributes.attributeID)
				where tclassextendattributes.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#params.getSiteID()#">
				and tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#params.getSortBy()#">
		) qExtendedSort

		on (tusers.userID=qExtendedSort.baseID)
		</cfif>

		where tusers.type=#params.getType()#
		<cfif isNumeric(params.getIsPublic())>
			and tusers.isPublic =#params.getIsPublic()#
		</cfif>
		<cfif listLen(userPoolID) gt 1>
			and tusers.siteid in ( <cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#userPoolID#"> )
		<cfelse>
			and tusers.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userPoolID#">
		</cfif>


		<cfif rsParams.recordcount>
			<cfset started=false>
			<cfset openGrouping=false />
			<cfloop query="rsParams">
				<cfset param.init(rsParams.relationship,
						rsParams.field,
						rsParams.dataType,
						rsParams.condition,
						rsParams.criteria
					) />

				<cfif param.getIsValid() and param.getField() neq 'tusers.siteid'>
					<cfset isNullVal = param.getCriteria() eq 'null' ? true : false />

					<cfif not started>
						<cfset openGrouping=true />
						and (
					</cfif>

					<cfif listFindNoCase("openGrouping,(",param.getRelationship())>
						<cfif not openGrouping>and</cfif> (
						<cfset openGrouping=true />
					<cfelseif listFindNoCase("orOpenGrouping,or (",param.getRelationship())>
						<cfif not openGrouping>or</cfif> (
						<cfset openGrouping=true />
					<cfelseif listFindNoCase("andOpenGrouping,and (",param.getRelationship())>
						<cfif not openGrouping>and</cfif> (
						<cfset openGrouping=true />
					<cfelseif listFindNoCase("and not (",param.getRelationship())>
						<cfif not openGrouping>and</cfif> not (
						<cfset openGrouping=true />
					<cfelseif listFindNoCase("or not (",param.getRelationship())>
						<cfif not openGrouping>or</cfif> not (
						<cfset openGrouping=true />
					<cfelseif listFindNoCase("closeGrouping,)",param.getRelationship())>
						)
						<cfset openGrouping=false />
					<cfelseif not openGrouping>
						#param.getRelationship()#
					</cfif>

					<cfset isListParam=param.isListParam()>
					<cfset started=true>

					<cfif listLen(param.getField(),".") gt 1>
						#param.getFieldStatement()#
						<cfif param.getCriteria() eq 'null'>
							#param.getCondition()# NULL
						<cfelse>
							#param.getCondition()#
							<cfif isListParam>(</cfif>
							<cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#">
							<cfif isListParam>)</cfif>
						</cfif>
						<cfset started=true>
						<cfset openGrouping=false />
					<cfelseif len(param.getField())>
						<cfif not ((param.getCriteria() eq 'null' or param.getCriteria() eq '') and param.getCondition() eq 'is')>
							<cfset castfield="attributeValue">
							tusers.userid IN (
								select tclassextenddatauseractivity.baseID from tclassextenddatauseractivity #tableModifier#
								<cfif isNumeric(param.getField())>
									where tclassextenddatauseractivity.attributeID=<cfqueryparam cfsqltype="cf_sql_numeric" value="#param.getField()#">
								<cfelse>
									inner join tclassextendattributes on (tclassextenddatauseractivity.attributeID = tclassextendattributes.attributeID)
									where
									<cfif listLen(userPoolID) gt 1>
										tclassextendattributes.siteid in ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#userPoolID#"> )
									<cfelse>
										tclassextendattributes.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#userPoolID#">
									</cfif>

									and tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#param.getField()#">
								</cfif>
								and
								<cfif param.getCondition() neq "like">
									<cfset castfield=variables.configBean.getClassExtensionManager().getCastString(param.getField(),params.getsiteid())>
									<cfif castfield eq 'datetimevalue'>
										<cfset param.setDatatype('datetime')>
									<cfelseif castfield eq 'numericvalue'>
										<cfset param.setDatatype('Numeric')>
									</cfif>
								</cfif>
								<cfif param.getCondition() eq "like" and variables.configBean.getDbCaseSensitive()>
									upper(#castfield#)
								<cfelse>
									#castfield#
								</cfif>
								#param.getCondition()#
								<cfif isListParam>
									(
								</cfif>
								<cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#" null="#iif(param.getCriteria() eq 'null',de('true'),de('false'))#">
								<cfif isListParam>
									)
								</cfif>
							)
							<cfset openGrouping=false />
						<cfelse>
							<cfset castfield="attributeValue">
							(
								tusers.userid NOT IN (
									select tclassextenddatauseractivity.baseID from tclassextenddatauseractivity #tableModifier#
									<cfif isNumeric(param.getField())>
										where tclassextenddatauseractivity.attributeID=<cfqueryparam cfsqltype="cf_sql_numeric" value="#param.getField()#">
									<cfelse>
										inner join tclassextendattributes on (tclassextenddatauseractivity.attributeID = tclassextendattributes.attributeID)
										where
										<cfif listLen(userPoolID) gt 1>
											tclassextendattributes.siteid in ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#userPoolID#"> )
										<cfelse>
											tclassextendattributes.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#userPoolID#">
										</cfif>

										and tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#param.getField()#">
									</cfif>
								)

								or

								tusers.userid IN (
									select tclassextenddatauseractivity.baseID from tclassextenddatauseractivity #tableModifier#
									<cfif isNumeric(param.getField())>
										where tclassextenddatauseractivity.attributeID=<cfqueryparam cfsqltype="cf_sql_numeric" value="#param.getField()#">
									<cfelse>
										inner join tclassextendattributes on (tclassextenddatauseractivity.attributeID = tclassextendattributes.attributeID)
										where
										<cfif listLen(userPoolID) gt 1>
											tclassextendattributes.siteid in ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#userPoolID#"> )
										<cfelse>
											tclassextendattributes.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#userPoolID#">
										</cfif>

										and tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#param.getField()#">
									</cfif>
									AND tclassextenddatauseractivity.attributeValue is null
								)
							)
							<cfset openGrouping=false />
						</cfif>
					</cfif>
				</cfif>
			</cfloop>
			<cfif started>)</cfif>
		</cfif>

		<!---
		<cfif arrayLen(paramArray)>
			<cfloop from="1" to="#arrayLen(paramArray)#" index="i">
					<cfset param=paramArray[i] />
			 		<cfif not started ><cfset started = true />and (<cfelse>#param.getRelationship()#</cfif>
			 		#param.getField()# #param.getCondition()# <cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#">
			</cfloop>
			<cfif started>)</cfif>
		</cfif>
		--->

	  	<cfif len(params.getCategoryID())>
		<cfset paramNum=listLen(params.getCategoryID())>
		and tusers.userID in (select userID from tusersinterests
								where categoryID in
								(<cfqueryparam cfsqltype="cf_sql_varchar" value="#listFirst(params.getCategoryID())#">
								<cfif paramNum gt 1>
								<cfloop from="2" to="#paramNum#" index="i">
								,<cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(params.getCategoryID(),i)#">
								</cfloop>
								</cfif>
								)
								)
		</cfif>

		<cfif len(params.getGroupID())>
		<cfset paramNum=listLen(params.getGroupID())>
		and tusers.userID in (select userID from tusersmemb
								where groupID in
								(<cfqueryparam cfsqltype="cf_sql_varchar" value="#listFirst(params.getGroupID())#">
								<cfif paramNum gt 1>
								<cfloop from="2" to="#paramNum#" index="i">
								,<cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(params.getGroupID(),i)#">
								</cfloop>
								</cfif>
								)
								)
		</cfif>

		<cfif isNumeric(params.getInActive())>
			and tusers.inactive=#params.getInActive()#
		</cfif>

		<cfif not listFind(sessionData.mura.memberships,'S2')> and tusers.s2=0 </cfif>

		<cfset started=false>
		<cfif arrayLen(params.getGroupByArray())>
			group by
			<cfloop array="#params.getGroupByArray()#" index="local.i">
				<cfif started>, <cfelse><cfset started=true></cfif>
				#sanitizedValue(llocal.i,'.')#
			</cfloop>
		</cfif>
		<cfset started=false>

		order by

		<cfif not arguments.countOnly>
			<cfif len(params.getOrderBy())>
					#REReplace(params.getOrderBy(),"[^0-9A-Za-z\._,\-%//""'' ]","","all")#
			<cfelseif len(params.getSortTable())>
				#REReplace("#params.getSortTable()#.#params.getSortBy()# #params.getSortDirection()#","[^0-9A-Za-z\._,\- ]","","all")#
			<cfelseif isExtendedSort>
				qExtendedSort.extendedSort #REReplace(params.getSortDirection(),"[^0-9A-Za-z\._,\- ]","","all")#
			<cfelse>
				<cfif variables.configBean.getDbType() neq "oracle" or listFindNoCase("lastUpdate,created,isPublic",params.getSortBy())>
					#REReplace("tusers.#params.getSortBy()# #params.getSortDirection()#","[^0-9A-Za-z\._,\- ]","","all")#
				<cfelse>
					lower(tusers.#REReplace(params.getSortBy(),"[^0-9A-Za-z\._,\- ]","","all")#) #REReplace(params.getSortDirection(),"[^A-Za-z]","","all")#
				</cfif>
			</cfif>

			<cfif dbType eq "nuodb" and params.getMaxItems()>fetch <cfqueryparam cfsqltype="cf_sql_integer" value="#params.getMaxItems()#" /> </cfif>
			<cfif listFindNoCase("mysql,postgresql", dbType) and params.getMaxItems()>limit <cfqueryparam cfsqltype="cf_sql_integer" value="#params.getMaxItems()#" /> </cfif>
			<cfif dbType eq "oracle" and params.getMaxItems()>) where ROWNUM <= <cfqueryparam cfsqltype="cf_sql_integer" value="#params.getMaxItems()#" /> </cfif>
		</cfif>

		</cfquery>

		<cfreturn rsAdvancedUserSearch />
	</cffunction>

	<cffunction name="getPrivateGroups" output="false">
		<cfargument name="siteid" type="string" default="" />
		<cfset var rsPrivateGroups = "" />
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsPrivateGroups')#">
		SELECT tsettings.Site, #variables.fieldList#
		FROM tsettings INNER JOIN tusers ON tsettings.SiteID = tusers.SiteID
		LEFT JOIN tfiles on tusers.photofileID=tfiles.fileID
		WHERE tusers.Type=1 AND tusers.isPublic=0
		and tsettings.PrivateUserPoolID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#">
		and tusers.siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#">
		ORDER BY tsettings.Site, tusers.Perm DESC, tusers.GroupName
		</cfquery>
		<cfreturn rsPrivateGroups />
	</cffunction>

	<cffunction name="getPublicGroups" output="false">
		<cfargument name="siteid" type="string" default="" />
		<cfset var rsPublicGroups = "" />
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsPublicGroups')#">
		SELECT tsettings.Site, #variables.fieldList#
		FROM tsettings INNER JOIN tusers ON tsettings.SiteID = tusers.SiteID
		LEFT JOIN tfiles on tusers.photofileID=tfiles.fileID
		WHERE tusers.Type=1 AND tusers.isPublic=1
		and tsettings.PublicUserPoolID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#">
		and tusers.siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#">
		ORDER BY tsettings.Site, tusers.Perm DESC, tusers.GroupName
		</cfquery>
		<cfreturn rsPublicGroups />
	</cffunction>

	<cffunction name="getCreatedMembers" output="false">
		<cfargument name="siteid" type="string" default="" />
		<cfargument name="startDate" type="string" required="true" default="">
		<cfargument name="stopDate" type="string" required="true" default="">

		<cfset var rsCreatedMembers = "" />
		<cfset var start = "" />
		<cfset var stop = "" />
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsCreatedMembers')#">
		SELECT Count(*) as theCount
		FROM tusers
		WHERE tusers.Type=2 AND tusers.isPublic=1
		and siteID = '#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#'
		<cfif lsisdate(arguments.stopDate)>
			<cfset stop=lsParseDateTime(arguments.stopDate)/>
			and created <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(stop),month(stop),day(stop),23,59,0)#"></cfif>
		<cfif lsisdate(arguments.startDate)>
			<cfset start=lsParseDateTime(arguments.startDate)/>
			and created >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(start),month(start),day(start),0,0,0)#"></cfif>
		</cfquery>
		<cfreturn rsCreatedMembers.theCount />
	</cffunction>

	<cffunction name="getTotalMembers" output="false">
		<cfargument name="siteid" type="string" default="" />


		<cfset var rsTotalMembers = "" />
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsTotalMembers')#">
		SELECT Count(*) as theCount
		FROM tusers
		WHERE tusers.Type=2 AND tusers.isPublic=1
		and siteID = '#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#'
		and inActive=0

		</cfquery>
		<cfreturn rsTotalMembers.theCount />
	</cffunction>

	<cffunction name="getTotalAdministrators" output="false">
		<cfargument name="siteid" type="string" default="" />


		<cfset var rsTotalAdministrators = "" />
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsTotalAdministrators')#">
		SELECT Count(*) as theCount
		FROM tusers
		WHERE tusers.Type=2 AND tusers.isPublic=0
		and siteID = '#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#'
		and inActive=0

		</cfquery>
		<cfreturn rsTotalAdministrators.theCount />
	</cffunction>

	<cffunction name="getUsers" output="false">
		<cfargument name="siteid" default="" />
		<cfargument name="ispublic" default="" />
		<cfargument name="isunassigned" default="" />
		<cfargument name="showsuperusers" default="0" />

		<cfset var rsUsers = '' />
		<cfset var rsUsersMemb = getUsersMemb() />
		<cfset var dbtype=variables.configBean.getDbType() />

		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsUsers')#">
			SELECT UserID, GroupName, Fname, Lname, UserName, Email, Type, subType, Admin, S2, LastUpdate, LastUpdateBy, isPublic, SiteID
			FROM tusers
			WHERE 0=0
				AND tusers.type = 2
				<cfif Len(arguments.siteid)>
					AND tusers.siteid =
						<cfif arguments.isPublic eq 0 >
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#" />
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#" />
						</cfif>
				</cfif>
				<cfif Len(arguments.isPublic)>
					AND tusers.ispublic = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ispublic#" />
				</cfif>
				<cfif IsBoolean(arguments.isunassigned) and arguments.isunassigned>
					AND userid NOT IN (SELECT DISTINCT userid FROM tusersmemb)
				</cfif>
				<cfif IsBoolean(arguments.showsuperusers) and arguments.showsuperusers>
					AND s2 <> 1
				</cfif>

			ORDER BY
				tusers.lname asc, tusers.fname asc
		</cfquery>
		<cfreturn rsUsers />
	</cffunction>

	<cffunction name="getUsersMemb" output="false">
		<cfset var rsUsersMemb = '' />
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsUsersMemb')#">
			SELECT UserID, GroupID
			FROM tusersmemb
		</cfquery>
		<cfreturn rsUsersMemb />
	</cffunction>

	<cfscript>
	function sanitizedValue(value) output=false {
		return REReplace(value,"[^0-9A-Za-z\._,\-\*]","","all");
	}
	</cfscript>

</cfcomponent>
