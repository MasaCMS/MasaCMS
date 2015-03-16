<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.configBean="">

<cffunction name="setConfigBean" output="false">
<cfargument name="configBean">
<cfset variables.configBean=arguments.configBean>
</cffunction>

<cffunction name="empty" output="false">
	<cfset var rs=getQuery(argumentCollection=arguments)>
	<cfset var pluginEvent = createObject("component","mura.MuraScope") />
	<cfset var i="">
	<cfset pluginEvent=pluginEvent.init(arguments).getEvent()>
	<cfset pluginEvent.setValue("rsTrash",rs)>
	
	<cfif isdefined("arguments.siteID") and len(arguments.siteID)>
		<cfset getBean("pluginManager").announceEvent("onBeforeSiteEmptyTrash",pluginEvent)>
	<cfelse>
		<cfset getBean("pluginManager").announceEvent("onBeforeGlobalEmptyTrash",pluginEvent)>
	</cfif>
	
	<cftransaction>
	<cfset request.muratransaction=request.muratransaction+1>

	<cfloop query="rs">
		<!--- CONTENT --->
		 <cfquery>
			delete from tcontentratings
			where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.objectID#">
		</cfquery>
		
		<cfquery>
			delete from tcontenteventreminders
			where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.objectID#">
		</cfquery>
		
		<cfquery>
			delete from tcontentassignments
			where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.objectID#">
			or userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.objectID#">
		</cfquery>
		
		<cfquery>
			delete from tcontentcomments
			where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.objectID#">
		</cfquery>
		
		<cfquery>
			delete from tformresponsepackets
			where formID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.objectID#">
		</cfquery>
		
		<cfquery>
			delete from tformresponsequestions
			where formID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.objectID#">
		</cfquery>
		
		<!--- CATEGORIES --->
		<cfquery>
			delete from tcontentcategoryassign
			where categoryID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.objectID#">
		</cfquery>
		
		<!--- CONTENT USERGROUPS RELATIONSHIPS --->
		<cfquery>
			delete from tpermissions
			where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.objectID#">
			or groupID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.objectID#">
		</cfquery>
		
		<!--- USERS CATEGORY RELATIONSHIP--->
		<cfquery>
			delete from tusersinterests
			where userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.objectID#">
			or categoryID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.objectID#">
		</cfquery>
		
		<!--- USERS --->
		<cfquery>
			delete from tuseraddresses
			where userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.objectID#">
		</cfquery>
		
		<cfquery>
			delete from tusersfavorites
			where userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.objectID#">
		</cfquery>
		
		<cfquery>
			delete from tusersmemb
			where userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.objectID#">
			or groupID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.objectID#">
		</cfquery>
		
		<!---MAILINGLISTS --->
		<cfquery>
			delete from tmailinglistmembers
			where mlid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.objectID#">
		</cfquery>
		
		<!---FEEDS --->
		<cfquery>
			delete from tcontentfeeditems
			where feedID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.objectID#">
		</cfquery>

		<cfquery>
			delete from tcontentfeedadvancedparams
			where feedID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.objectID#">
		</cfquery>

		<!--- ADVERTISING --->
		<cftry>
			<cfquery>
				delete from tadplacements
				where campaignID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.objectID#">
			</cfquery>

			<cfquery>
				delete from tadplacements
				where placementID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.objectID#">
			</cfquery>
			<cfcatch></cfcatch>
		</cftry>
			
		<!--- EMPTY TRASH TABLE--->
		<cfquery>
			delete from ttrash
			where objectID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.objectID#">
		</cfquery>

		<cfset getBean('contentDAO').deleteVersionedObjects(contentID=rs.objectid,siteID=rs.siteid)>

	</cfloop>

	<cftry>
		<cfquery>
			delete from tadplacementdetails
			where placementID not in (select placementID from tadplacements)
		</cfquery>

		<cfquery>
			delete from tadplacementcategoryassign
			where placementID not in (select placementID from tadplacements)
		</cfquery>

		<cfquery>
			delete from tadstats
			where placementID not in (select placementID from tadplacements)
		</cfquery>
		<cfcatch></cfcatch>
	</cftry>
	</cftransaction>
	
	<cfset request.muratransaction=request.muratransaction-1>
	
	<!--- FILES --->
	<cfif isdefined("arguments.siteID") and len(arguments.siteID)>
		<cfset getBean('fileManager').purgeDeleted(arguments.siteID)>
	<cfelse>
		<cfset getBean('fileManager').purgeDeleted("")>
	</cfif>
	
	<cfif isdefined("arguments.siteID") and len(arguments.siteID)>
		<cfset getBean("pluginManager").announceEvent("onAfterSiteEmptyTrash",pluginEvent)>
	<cfelse>
		<cfset getBean("pluginManager").announceEvent("onAfterGlobalEmptyTrash",pluginEvent)>
	</cfif>
	
</cffunction>

<cffunction name="throwIn" output="false">
<cfargument name="deleted">
<cfargument name="objectClass" default="">
	<cfset var $="">	
	<cfset var idString="">
	<cfset var labelString="">
	<cfset var objectType="">
	<cfset var objectSubType="">
	<cfset var siteid="">
	<cfset var fixValues="">
	<cfset var allValues="">
	<cfset var rs="">
	<cfset var i="">
	<cfset var rsRelated="">
	<cfset var muraDeleteDateTime="">
	<cfset var deleteID="">
	<cfset var deleteIDHash="">
	<cfset var orderno="">

	<cfif not len(arguments.objectClass)>
		<cfset arguments.objectClass=arguments.deleted.getEntityName()>
	</cfif>
	
	<cfif not isDate(arguments.deleted.getValue("muraDeleteDateTime"))>
		<cfset arguments.deleted.setValue("muraDeleteDateTime",now())>
	</cfif>

	<cfset muraDeleteDateTime=arguments.deleted.getValue("muraDeleteDateTime")>

	<cfif not len(arguments.deleted.getValue("muraDeleteID"))>
		<cfset arguments.deleted.setValue("muraDeleteID",createUUID())>
	</cfif>

	<cfset deleteID=arguments.deleted.getValue("muraDeleteID")>
	<cfset deleteIDHash=Hash(deleteID)>

	<cfparam name="request.delete#deleteIDHash#" default="0">

	<cfset request["delete#deleteIDHash#"]=request["delete#deleteIDHash#"]+1>

	<cfif listFindNoCase("campaign,creative",arguments.objectClass)>
		<cfset siteid=getBean('userManager').read(arguments.deleted.getUserID()).getSiteID()>
	<cfelseif arguments.objectClass eq "placement">
		<cfset siteid=getBean('userManager').read( getBean('advertiserManager').readCampaign(arguments.deleted.getCampaignID()).getUserID() ).getSiteID()>	
	<cfelseif len(arguments.deleted.getValue('siteid'))>
		<cfset siteid=arguments.deleted.getValue('siteid')>
	<cfelse>
		<cfset siteid=session.siteid>
	</cfif>
	
	<cfset $=getBean('MuraScope').init(siteid)>
	
	<!--- Package up extra stuff related to the contentBean --->
	<cfif arguments.objectClass eq "content">
		
		<!--- Store display object assignments --->
		<cfloop from="1" to="8" index="i">
			<cfset arguments.deleted.getDisplayRegion(i)>
		</cfloop>
		
		<!--- Store related content --->
		<cfset rsRelated=arguments.deleted.getRelatedContentQuery()>
		<cfif rsRelated.recordcount>
			<cfset arguments.deleted.setValue(  "relatedContentID"  ,  valueList( rsRelated.contentID ) ) >
		</cfif>
		<!--- store categories --->
		<cfset arguments.deleted.setValue("categoriesFromMuraTrash",  getBean("contentManager").getCategoriesByHistID( arguments.deleted.getContentHistID() )  )>
	
		<cfif configBean.getDbType() eq 'Oracle'>
			<cfset fixValues = getBean('utility').fixOracleClobs(arguments.deleted.getAllValues().categoriesFromMuraTrash)>
			<cfset arguments.deleted = arguments.deleted.setValue('categoriesFromMuraTrash', fixValues)>
		</cfif>
		
	</cfif>
	
	<cfwddx action="cfml2wddx" input="#arguments.deleted.getAllValues()#" output="allValues">

	
	<cfset idString=getIdString(arguments.deleted)>
	
	<cfif arguments.deleted.valueExists('Type')>
		<cfset objectType=arguments.deleted.getType()>
	<cfelse>
		<cfset objectType=arguments.deleted.getEntityName()>
	</cfif>
	
	<cfif objectType eq "1">
		<cfset objectType="Group">
	<cfelseif objectType eq "2">
		<cfset objectType="User">
	</cfif>
	
	<cfif arguments.deleted.valueExists('subType')>
		<cfset objectSubType=arguments.deleted.getSubType()>
	<cfelse>
		<cfset objectSubType="Default">
	</cfif>
	
	<cfif len(idString)>
		<cfquery name="rs">
			select objectID from ttrash where objectID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deleted.getValue(IDString)#" />
		</cfquery>
		
		<cfif not rs.recordcount>
			<cfquery>
				insert into ttrash (objectID,parentID,siteID,objectClass,objectLabel,objectType,objectSubType,objectString,deletedDate,deletedBy,deleteID,orderno)
					values(	
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deleted.getValue(IDString)#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#getDeletedParentID(arguments.deleted)#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#siteid#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectClass#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deleted.getInstanceName()#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#objectType#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#objectSubType#" />,
						<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#allValues#" />,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#muraDeleteDateTime#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left($.currentUser('fullname'),50)#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#deleteID#" />,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#request['delete#deleteIDHash#']#" />
					)			
			</cfquery>
		</cfif>
	</cfif>

</cffunction>

<cffunction name="getDeletedParentID" output="false">
	<cfargument name="deleted">

	<cfif arguments.deleted.valueExists("deletedParentID")>
		<cfreturn arguments.deleted.getDeletedParentID()>
	<cfelseif arguments.deleted.valueExists("parentID")>
		<cfreturn arguments.deleted.getParentID()>
	<cfelseif arguments.deleted.getEntityName() eq 'address'>
		<cfreturn arguments.deleted.getUserID()>
	<cfelseif arguments.deleted.getEntityName() eq 'placement'>
		<cfreturn arguments.deleted.getCampaignID()>
	<cfelse>
		<cfreturn "NA">
	</cfif>
</cffunction>

<cffunction name="getTrashItem" output="false">
<cfargument name="objectID">
<cfreturn getIterator(objectID=arguments.objectID).next()>
</cffunction>

<cffunction name="getObject" output="false">
<cfargument name="objectID">
	<cfset var rs="">
	<cfset var retrieved="">
	<cfset var allValues="">
	
	<cfquery name="rs">
		select objectID,parentID,siteID,objectClass,objectLabel,objectType,objectSubType,objectString,deletedDate,deletedBy,deleteID,orderno from ttrash where objectID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectID#" />				
	</cfquery>
	
	<cfif rs.recordcount>
		<cfset retrieved=getBean(rs.objectClass)>
		<cfwddx action = "wddx2cfml" input = "#rs.objectstring#" output = "allValues">
		<cfset allValues.fromMuraTrash=true>
		<cfset allValues.muraDeleteDateTime=rs.deletedDate>
		<cfset allValues.extendData="">
		<cfset allValues.muraDeleteID=rs.deleteID>
		<cfset allValues.muraDeleteOrderNO=rs.orderno>
		<cfset retrieved.setAllValues(allValues)>
	</cfif>
	
	<cfreturn retrieved>
	
</cffunction>

<cffunction name="getQuery" output="false">
	<cfset var rs="">
	
	<cfquery name="rs">
		select objectID,siteID,parentID,objectClass,objectType,objectSubType,objectLabel,deletedDate,deletedBy,deleteID,orderno 
		from ttrash where 
		1=1
		<cfif structKeyExists(arguments,"sinceDate")>
		and deletedDate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.sinceDate#">
		</cfif>	
		<cfif structKeyExists(arguments,"beforeDate")>
		and deletedDate <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.beforeDate#">
		</cfif>
		<cfif structKeyExists(arguments,"objectID")>
		and objectID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectID#">
		</cfif>
		<cfif structKeyExists(arguments,"parentID")>
		and parentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#">
		</cfif>	
		<cfif structKeyExists(arguments,"siteID")>
		and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
		</cfif>
		<cfif structKeyExists(arguments,"objectType")>
		and objectType=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectType#">
		</cfif>	
		<cfif structKeyExists(arguments,"objectSubType")>
		and objectSubType=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectSubType#">
		</cfif>	
		<cfif structKeyExists(arguments,"objectClass")>
		and objectClass=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectClass#">
		</cfif>	
		<cfif structKeyExists(arguments,"deletedBy")>
		and deletedBy=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deletedBy#">
		</cfif>
		<cfif structKeyExists(arguments,"deleteid")>
		and deleteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deleteid#">
		</cfif>
		<cfif structKeyExists(arguments,"objectLabel")>
		and objectClass=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectLabel#">
		</cfif>
		<cfif structKeyExists(arguments,"deletedDate") and isDate(arguments.deletedDate)>
		and deletedDate=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.deletedDate#">
		</cfif>		
		
		<cfif structKeyExists(arguments,"keywords") and len(arguments.keywords)>
			and (
			objectClass like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">
			or objectSubType like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">
			or objectType like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">
			or deletedBy like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">
			or siteID like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">
			or objectLabel like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">
			)
		</cfif>
		
		order by 

		<cfif isDefined('arguments.deleteID')>
			orderno desc
		<cfelse>
			deletedDate desc
		</cfif>
				
	</cfquery>
	
	<cfreturn rs>
	
</cffunction>

<cffunction name="getIterator" output="false">
	<cfset var rs=getQuery(argumentCollection=arguments)>
	<cfset var it=createObject("component","trashIterator").init()>
	<cfset it.setTrashManager(this)>
	<cfset it.setQuery(rs)>
	<cfreturn it>
</cffunction>

<cffunction name="takeOut" output="false">
<cfargument name="restored" hint="Object that has been pulled from trash and has since been saved">

	<cfset var data="">
	<cfset var i="">
	<cfset var objectClass=arguments.restored.getEntityName()>
	<cfset var idString=getIDString(arguments.restored)>
	<cfset var doPurge=false>
	<cfset var it="">
	<cfset var item="">
	

	<cfif arguments.restored.valueExists("fromMuraTrash")>
		<cfset doPurge=true>
	</cfif>
	
	<cfif doPurge>
		
		<cfset data=arguments.restored.getAllValues()>
		
		<cfloop collection="#data#" item="i">
			<!--- If the values is a uuid try an restore it just in case it's a fileid --->
			<cfif isSimpleValue(data[i]) and isValid("UUID",data[i])>
				<cfset getBean('fileManager').restoreVersion(data[i])>
			</cfif>
		</cfloop>
		
		<cfquery>
			delete from ttrash where objectID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('arguments.restored.get#IDString#()')#" />		
		</cfquery>
		
		<cfset it=getIterator(parentID=arguments.restored.getvalue(arguments.restored.getPrimaryKey()), deletedDate=arguments.restored.getvalue("muraDeleteDateTime"))>
		<cfset it.end()>
		<cfloop condition="it.hasPrevious()">
			<cfset item=it.previous().getObject().save()>
		</cfloop>
		
	</cfif>
</cffunction>

<cffunction name="getIDString" output="false">
<cfargument name="object">

	<cfif arguments.object.getEntityName(userProxyName=false) eq 'content'>
		<cfreturn "contentID">
	<cfelse>
		<cfreturn arguments.object.getPrimaryKey()>
	</cfif>
</cffunction>

</cfcomponent>
