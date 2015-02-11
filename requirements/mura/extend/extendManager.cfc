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

<cfset variables.definitionsQuery="">
<cfset variables.iconlookup={}>

<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="configBean">
	
	<cfset variables.configBean=arguments.configBean />
	
	<cfset buildIconClassLookup()>

	<cfreturn this />
</cffunction>

<cffunction name="getCustomIconClass" output="false">
	<cfargument name="type">
	<cfargument name="subtype">
	<cfargument name="siteid">

	<cfif StructKeyExists(variables.iconlookup, arguments.siteid) and StructKeyExists(variables.iconlookup[arguments.siteid], arguments.type & arguments.subtype)>
		<cfreturn variables.iconlookup['#arguments.siteid#']['#arguments.type##arguments.subtype#']>
	</cfif>

	<cfreturn ''>

</cffunction>

<cffunction name="getIconClass" returntype="String" access="public" output="false">
	<cfargument name="type">
	<cfargument name="subtype">
	<cfargument name="siteid">
	<cfset var returnVar = getCustomIconClass(argumentCollection=arguments)>
	
	<cfif not len(returnVar)>
		<cfswitch expression="#arguments.type#">
			<cfcase value="page">
				<cfset returnVar = "icon-file">
			</cfcase>
			<cfcase value="folder">
				<cfset returnVar = "icon-folder-open-alt">
			</cfcase>
			<cfcase value="file">
				<cfset returnVar = "icon-file-text-alt">
			</cfcase>
			<cfcase value="link">
				<cfset returnVar = "icon-link">
			</cfcase>
			<cfcase value="calendar">
				<cfset returnVar = "icon-calendar">
			</cfcase>
			<cfcase value="gallery">
				<cfset returnVar = "icon-th">
			</cfcase>
			<cfcase value="1">
				<cfset returnVar = "icon-group">
			</cfcase>
			<cfcase value="2">
				<cfset returnVar = "icon-user">
			</cfcase>
			<cfdefaultcase>
				<cfset returnVar = "icon-cog">
			</cfdefaultcase>
		</cfswitch> 
	</cfif>
	
	<cfreturn returnVar>
</cffunction>

<cffunction name="buildIconClassLookup" output="false">	
	<cfset var rs="">
	
	<cfquery name="rs">
		select siteID,type,subtype,iconclass from tclassextend
	</cfquery>

	<cfloop query="rs">
		<cfset setIconClass(type=rs.type,subtype=rs.subtype,siteid=rs.siteid,iconclass=rs.iconclass)>
	</cfloop>
</cffunction>

<cffunction name="setIconClass" output="false">	
	<cfargument name="type">
	<cfargument name="subtype">
	<cfargument name="siteid">
	<cfargument name="iconclass">

		<cfscript>
			if(listFindNoCase('Page,Folder,Calendar,Gallery,File,Link,Portal',arguments.type)){
				if(not structKeyExists(variables.iconlookup,'#arguments.siteid#')){
					variables.iconlookup['#arguments.siteid#']={};
				}

				variables.iconlookup['#arguments.siteid#']['#arguments.type##arguments.subtype#']=arguments.iconclass;
			}
		</cfscript>
	
</cffunction>

<cffunction name="getIconClassLookUp" output="false">
	<cfreturn variables.iconlookup>
</cffunction>

<cffunction name="buildDefinitionsQuery" output="false">
<cfargument name="datasource" required="true" default="#application.configBean.getDatasource()#">
<cfargument name="dbUsername" required="true" default="#application.configBean.getDbUsername()#">
<cfargument name="dbPassword" required="true" default="#application.configBean.getDbPassword()#">
	<cfset var rs="">
	
	<cfif arguments.datasource neq variables.configBean.getDatasource()>
		<cfset arguments.dbUsername="">
		<cfset arguments.dbPassword="">
	</cfif>

	<cfif variables.configBean.getDBType() eq 'MSSQL'>
		<cfset var tableModifier="with (nolock)">
	<cfelse>
		<cfset var tableModifier="">
	</cfif>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	select tclassextend.subtypeid, tclassextend.siteid, tclassextend.basekeyfield, tclassextend.datatable, tclassextend.type, 
	tclassextend.subtype, tclassextendsets.extendsetid, tclassextendsets.categoryid, tclassextendsets.name extendsetname, 
	tclassextendsets.container, tclassextendattributes.attributeid, tclassextendattributes.name attributename, 
	<cfif variables.configBean.getDBType() eq "oracle">
		to_char(tclassextendattributes.label) as label
	<cfelse>
		tclassextendattributes.label
	</cfif>, 
	tclassextendattributes.hint, tclassextendattributes.type inputtype, tclassextendattributes.required, 
	tclassextendattributes.validation, tclassextendattributes.regex, tclassextendattributes.message, tclassextendattributes.optionlist, 
	tclassextendattributes.optionlabellist, tclassextendattributes.defaultvalue,
	tclassextend.hasSummary,tclassextend.hasBody,
	<cfif variables.configBean.getDBType() eq "oracle">
		to_char(tclassextend.description) as description
	<cfelse>
		tclassextend.description
	</cfif>,
	<cfif variables.configBean.getDBType() eq "oracle">
		to_char(tclassextend.availableSubTypes) as availableSubTypes
	<cfelse>
		tclassextend.availableSubTypes
	</cfif>
	,tclassextend.iconclass
	from tclassextend #tableModifier#
	inner join tclassextendsets #tableModifier# on (tclassextend.subtypeid=tclassextendsets.subtypeid)
	inner join tclassextendattributes #tableModifier# on (tclassextendsets.extendsetid=tclassextendattributes.extendsetid)
	order by tclassextend.siteID, tclassextend.type, tclassextend.subtype, tclassextendsets.orderno, tclassextendattributes.orderno 
	</cfquery>

	<cfreturn rs>

</cffunction>

<cffunction name="getDefinitionsQuery" output="false">
	<cfif not isQuery(variables.definitionsQuery)>
		<cfset variables.definitionsQuery=buildDefinitionsQuery()>
	</cfif>
	<cfreturn variables.definitionsQuery>
</cffunction>

<cffunction name="purgeDefinitionsQuery" output="false">
	<cfset variables.definitionsQuery="">
</cffunction>

<cffunction name="setConfigBean" access="public" returntype="void">
<cfargument name="configBean">
<cfset variables.configBean=arguments.configBean />
</cffunction>

<cffunction name="getSubTypeBean" returnType="any">
<cfset var subtype=createObject("component","mura.extend.extendSubType").init(variables.configBean) />
<cfreturn subtype />
</cffunction>

<cffunction name="getSubTypeByName" access="public" returntype="any">
<cfargument name="type">
<cfargument name="subtype">
<cfargument name="siteid">

	<cfset var _subtype=getSubTypeBean() />
	<cfset _subtype.setSiteID(arguments.siteID)/>
	<cfset _subtype.setType(arguments.type)/>
	<cfset _subtype.setSubType(arguments.SubType)/>
	<cfset _subtype.load() />
	<cfreturn _subtype />
</cffunction>

<cffunction name="getSubTypeByID" access="public" returntype="any">
<cfargument name="subTypeID">

	<cfset var subtype=getSubTypeBean() />
	<cfset subtype.setSubTypeID(arguments.SubTypeID)/>
	<cfset subtype.load() />
	
	<cfreturn subtype />
</cffunction>

<cffunction name="deleteSubType" access="public" returntype="array">
<cfargument name="subTypeID">
	<cfset var subtype=getSubTypeBean() />
	<cfset subtype.setSubTypeID(arguments.subtypeID)/> 
	<cfset subType.delete() />		
</cffunction>

<cffunction name="getExtendedData" access="public" returntype="any">
	<cfargument name="baseID">
	<cfargument name="dataTable" required="true" default="tclassextenddata"/>
	<cfargument name="type">
	<cfargument name="subtype">
	<cfargument name="siteid">
	<cfargument name="sourceIterator" default="">
	
	<cfif structKeyExists(arguments,"type") and  structKeyExists(arguments,"subtype") and  structKeyExists(arguments,"siteID")>
		<cfreturn createObject("component","mura.extend.extendData").init(
			configBean=variables.configBean,
			baseID=arguments.baseID,
			dataTable=arguments.dataTable,
			type=arguments.type,
			subType=arguments.subType,
			siteID=arguments.siteID,
			sourceIterator=arguments.sourceIterator
			) />	
	<cfelse>
		<cfreturn createObject("component","mura.extend.extendData").init(
			configBean=variables.configBean,
			baseID=arguments.baseID,
			dataTable=arguments.dataTable,
			sourceIterator=arguments.sourceIterator
			) />
	</cfif>
</cffunction>

<cffunction name="validateExtendedData" returntype="any" output="false">
<cfargument name="data">

<cfset var setLen=0/>
<cfset var key=""/>
<cfset var rs = ""/>
<cfset var theValue=""/>
<cfset var s=0/>
<cfset var tempDate=""/>
<cfset var errors=structNew()>
<cfset var site=application.settingsManager.getSite(arguments.data.siteID) />
<cfset var rbFactory=site.getRBFactory()>
<cfset var stricthtml=getBean('configBean').getValue(property='stricthtml',defaultValue=false)>
<cfset var stricthtmlexclude=getBean('configBean').getValue(property='stricthtmlexclude',defaultValue='')>

<cfif isDefined("arguments.data.extendSetID") and len(arguments.data.extendSetID)>
<cfset setLen=listLen(arguments.data.extendSetID)/>

<!--- process non-file attributes --->
<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
select attributeID,name,validation,message,type from tclassextendattributes where 
ExtendSetID in(<cfloop from="1" to="#setLen#" index="s">
		'#listgetat(arguments.data.extendSetID,s)#'<cfif s lt setlen>,</cfif>
		</cfloop>)
		and type <> 'File'
</cfquery>

<cfloop query="rs">
	<cfset key="ext#rs.attributeID#"/>
	
	<cfif structKeyExists(arguments.data,key)
		or structKeyExists(arguments.data,rs.name)>
		
		<cfif structKeyExists(arguments.data,key) and len(arguments.data[key])>
			<cfset theValue=arguments.data[key]>
		<cfelseif structKeyExists(arguments.data,rs.name) and len(arguments.data[rs.name])>
			<cfset theValue=arguments.data[rs.name]>
		<cfelse>
			<cfset theValue="">
		</cfif>

		<cfif len(theValue)>
			<cfif rs.validation eq "Date" or rs.validation eq "DateTime">
				<cfif not (lsisDate(theValue) or isDate(theValue))>
					<cfif len(rs.message)>
						<cfset errors[rs.name]=rs.message>
					<cfelse>
						<cfset errors[rs.name]=rbFactory.getResourceBundle().messageFormat(rbFactory.getKey("params.errordate"),ucase(rs.name))>
					</cfif>
				</cfif>
			<cfelseif rs.validation eq "Numeric">
				<cfif not isNumeric(theValue)>
					<cfif len(rs.message)>
						<cfset errors[rs.name]=rs.message>
					<cfelse>
						<cfset errors[rs.name]=rbFactory.getResourceBundle().messageFormat(rbFactory.getKey("params.errornumeric"),ucase(rs.name))>
					</cfif>
				</cfif>
			<cfelseif rs.validation eq "Email">
				<cfif REFindNoCase("^[^@%*<>' ]+@[^@%*<>' ]{1,255}\.[^@%*<>' ]{2,5}", trim(theValue)) eq 0>
					<cfif len(rs.message)>
						<cfset errors[rs.name]=rs.message>
					<cfelse>
						<cfset errors[rs.name]=rbFactory.getResourceBundle().messageFormat(rbFactory.getKey("params.erroremail"),ucase(rs.name))>
					</cfif>
				</cfif>
			<cfelseif stricthtml and rs.type neq 'HTMLEditor' and !(len(stricthtmlexclude) && listFind(stricthtmlexclude,rs.name)) && reFindNoCase("<[\/]?[^>]*>",theValue)>
				<cfset errors['#rs.name#encoding']="The field '#rs.name#' contains invalid characters.">
			</cfif>
		</cfif>
			
	</cfif>
</cfloop>
</cfif>
<cfreturn errors>
</cffunction>

<cffunction name="saveExtendedData" access="public" returntype="void">
<cfargument name="baseID">
<cfargument name="data">
<cfargument name="dataTable" required="true" default="tclassextenddata"/>

<cfset var setLen=0/>
<cfset var key=""/>
<cfset var fileManager=getBean("fileManager") />
<cfset var fileID = ""/>
<cfset var fileStruct = ""/>
<cfset var formField = ""/>
<cfset var deleteKey1 = ""/>
<cfset var deleteKey2 = ""/>
<cfset var rs = ""/>
<cfset var theFileStruct=""/>
<cfset var theValue=""/>
<cfset var s=0/>
<cfset var tempDate=""/>
<cfset var tempFile=""/>
<cfset var remoteID=""/>

<cfif isDefined("arguments.data.extendSetID") and len(arguments.data.extendSetID)>
<cfset setLen=listLen(arguments.data.extendSetID)/>

<cfif isdefined("arguments.data.remoteID")>
	<cfset remoteID=left(arguments.data.remoteID,35)>
</cfif>

<cfif not isdefined("arguments.data.moduleID")>
	<cfset arguments.data.moduleID="00000000000000000000000000000000004">
</cfif>

<cfif variables.configBean.getDBType() eq 'MSSQL'>
	<cfset var tableModifier="with (nolock)">
<cfelse>
	<cfset var tableModifier="">
</cfif>

<!--- process non-file attributes --->
<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
select attributeID,name,validation,message from tclassextendattributes #tableModifier# where 
ExtendSetID in(<cfloop from="1" to="#setLen#" index="s">
		'#listgetat(arguments.data.extendSetID,s)#'<cfif s lt setlen>,</cfif>
		</cfloop>)
		and type <> 'File'
</cfquery>

<cfloop query="rs">
	<cfset key="ext#rs.attributeID#"/>
	
	<cfif structKeyExists(arguments.data,key)
		or structKeyExists(arguments.data,rs.name)>
		
		<cfif structKeyExists(arguments.data,key) and len(arguments.data[key])>
			<cfset theValue=arguments.data[key]>
		<cfelseif structKeyExists(arguments.data,rs.name) and len(arguments.data[rs.name])>
			<cfset theValue=arguments.data[rs.name]>
		<cfelse>
			<cfset theValue="">
		</cfif>
		
		<cfquery>
			delete from #arguments.dataTable# 
			where baseID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.baseID#">
			and attributeID = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#rs.attributeID#">
		</cfquery>
			
		<cfquery>
			insert into #arguments.dataTable# (baseID,attributeID,siteID,stringvalue,attributeValue,datetimevalue,numericvalue,remoteID
			)
			values (
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.baseID#">,
			<cfqueryparam cfsqltype="cf_sql_integer"  value="#rs.attributeID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.data.siteID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#left(theValue,250)#">,
			
			<cfif len(theValue)>
				
				<cfif listFindNoCase("Date,DateTime",rs.validation)>
					<cfif lsisDate(theValue)>
						<cftry>
						<cfset theValue = lsparseDateTime(theValue) />
						<cfqueryparam cfsqltype="cf_sql_longvarchar"  value="#theValue#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#theValue#">,
						null						
						<cfcatch>
							<cfset theValue = parseDateTime(theValue) />
							<cfqueryparam cfsqltype="cf_sql_longvarchar"  value="#theValue#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#theValue#">,
							null
						</cfcatch>
						</cftry>
					<cfelseif isDate(theValue)>	
						<cfset theValue = parseDateTime(theValue) />
						<cfqueryparam cfsqltype="cf_sql_longvarchar"  value="#theValue#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#theValue#">,
						null
					<cfelse>
						null,
						null,
						null
					</cfif>
				<cfelseif rs.validation eq "Numeric">
					<cfif isNumeric(theValue)>
						<cfqueryparam cfsqltype="cf_sql_longvarchar"  value="#theValue#">,
						null,
						<cfqueryparam cfsqltype="cf_sql_numeric"  value="#theValue#">
					<cfelse>
						null,
						null,
						null
					</cfif>
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_longvarchar"  value="#theValue#">,
					null,
					null
				</cfif>	
			<cfelse>
				null,
				null,
				null
			</cfif>,
			<cfqueryparam cfsqltype="cf_sql_longvarchar"  value="#remoteID#">
			)
		</cfquery>
		
	</cfif>
</cfloop>

<!--- process file attributes --->
<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
select attributeID,name from tclassextendattributes #tableModifier# where 
ExtendSetID in(<cfloop from="1" to="#setLen#" index="s">
		'#listgetat(arguments.data.extendSetID,s)#'<cfif s lt setlen>,</cfif>
		</cfloop>)
		and type = 'File'
</cfquery>

<cfloop query="rs">
	<cfset key="ext#rs.attributeID#"/>
	<cfset deletekey1="extDelete#rs.attributeID#"/>
	<cfset deletekey2="extDelete#rs.name#"/>
	
	<!--- if a new file has been submitted or a delete key exists, delete any existing file --->
	<cfif (structKeyExists(arguments.data,key) and len(arguments.data[key]))
		or (structKeyExists(arguments.data,rs.name) and len(arguments.data[rs.name]))
		or structKeyExists(arguments.data,deletekey1) 
		or structKeyExists(arguments.data,deletekey2)>
	
	
		<cfset fileID=getAttribute(arguments.baseID,rs.attributeID,arguments.dataTable)/>
		
		<cfif len(fileID)>
			
			<cfset fileManager.deleteIfNotUsed(fileID,arguments.baseID)/>
			
			<cfquery>
			delete from #arguments.dataTable# 
			where baseID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.baseID#">
			and attributeID = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#rs.attributeID#">
		 	</cfquery>
		 	
		 	<cfset fileID=""/>
		</cfif>	

	</cfif>
		
	<!--- if a new file has been submitted , save it --->
	<cfif (structKeyExists(arguments.data,key) and len(arguments.data[key]))
		or (structKeyExists(arguments.data,rs.name) and len(arguments.data[rs.name])) and not
		(structKeyExists(arguments.data,deletekey1) 
		or structKeyExists(arguments.data,deletekey2))>
		
		<cfif structKeyExists(arguments.data,key) and len(arguments.data[key])>
			<cfset formField=key />
		<cfelse>
			<cfset formField=rs.name />
		</cfif>
		
		<!--- Check to see if it's a posted binary file--->
		<cfif not isValid('UUID',arguments.data[formField])>
			<cfif fileManager.isPostedFile(arguments.data[formField])>
				<cffile action="upload" result="tempFile" filefield="#formField#" nameconflict="makeunique" destination="#variables.configBean.getTempDir()#">
			<!--- Else fake it to think it was a posted files--->
			<cfelse>
				<cfset tempFile=fileManager.emulateUpload(arguments.data[formField])>
			</cfif>
		
			<cfset theFileStruct=fileManager.process(tempFile,arguments.data.siteID) />
			<cfset fileID=fileManager.create(theFileStruct.fileObj,arguments.baseID,arguments.data.siteID,tempFile.ClientFile,tempFile.ContentType,tempFile.ContentSubType,tempFile.FileSize,arguments.data.moduleID,tempFile.ServerFileExt,theFileStruct.fileObjSmall,theFileStruct.fileObjMedium,createUUID(),theFileStruct.fileObjSource) />
		<cfelse>
			<cfset fileID=arguments.data[formField]>
		</cfif>	
		
		<cfquery >
			insert into #arguments.dataTable# (baseID,attributeID,siteID,attributeValue,stringvalue,remoteID)
			values (
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.baseID#">,
			<cfqueryparam cfsqltype="cf_sql_integer"  value="#rs.attributeID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.data.siteID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#fileID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#fileID#">,
			<cfqueryparam cfsqltype="cf_sql_longvarchar"  value="#remoteID#">	
			)
		</cfquery>
					
	</cfif>

</cfloop>


</cfif>

</cffunction>

<cffunction name="preserveExtendedData" access="public" returntype="void">
<cfargument name="baseID">
<cfargument name="preserveID" required="true" default="">
<cfargument name="data">
<cfargument name="dataTable" required="true" default="tclassextenddata"/>
<cfargument name="type" required="true" default=""/>
<cfargument name="subtype" required="true" default=""/>
<cfset var setLen=0/>
<cfset var rs=""/>
<cfset var rsItem=""/>
<cfset var deleteKey1 = ""/>
<cfset var deleteKey2 = ""/>
<cfset var key = ""/>
<cfset var s=0/>
<cfset var hasExtendSets=isDefined("arguments.data.extendSetID") and len(arguments.data.extendSetID)>
<cfset var remoteID="">
<cfif isdefined("arguments.data.remoteID")>
	<cfset remoteID=left(arguments.data.remoteID,35)>
</cfif>

<cfif variables.configBean.getDBType() eq 'MSSQL'>
	<cfset var tableModifier="with (nolock)">
<cfelse>
	<cfset var tableModifier="">
</cfif>

<!--- preserve data from extendsets that were'nt submitted --->
<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
select #arguments.dataTable#.dataID, #arguments.dataTable#.baseID, #arguments.dataTable#.attributeID,#arguments.dataTable#.siteID, #arguments.dataTable#.attributevalue, 
#arguments.dataTable#.datetimevalue, #arguments.dataTable#.numericvalue, #arguments.dataTable#.stringvalue, tclassextendattributes.name from #arguments.dataTable# #tableModifier#
inner join tclassextendattributes #tableModifier# on ( #arguments.dataTable#.attributeID=tclassextendattributes.attributeID)
inner join tclassextendsets #tableModifier# on (tclassextendattributes.extendsetID=tclassextendsets.extendsetID)
inner join tclassextend #tableModifier# on (tclassextendsets.subtypeID=tclassextend.subtypeID)
 where 
<!---
tclassextend.type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.type#">
and 
	(
		tclassextend.subtype=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.subtype#">
		<cfif arguments.subType neq "Default">
		or tclassextend.subtype=<cfqueryparam cfsqltype="cf_sql_varchar"  value="Default">
		</cfif>
	)
--->

(
	tclassextend.type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.type#">
	<cfif not listFindNoCase("1,2,User,Group,Address,Site,Component,Form",arguments.type)>
			or tclassextend.type='Base'
	</cfif>
)

and (
	<cfif arguments.subtype neq "Default">
		tclassextend.subtype=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.subtype#">
		or
	</cfif>
	tclassextend.subtype='Default'
)

and baseID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.preserveID#">
<cfif hasExtendSets>
<cfset setLen=listLen(arguments.data.extendSetID)/>
and tclassextendattributes.extendSetID not in (<cfloop from="1" to="#setLen#" index="s">
		'#listgetat(arguments.data.extendSetID,s)#'<cfif s lt setlen>,</cfif>
		</cfloop>)
</cfif>		
</cfquery>

<cfloop query="rs">
	<cfquery>
		insert into #arguments.dataTable# (baseID,attributeID,siteID,attributeValue,datetimevalue,numericvalue,stringvalue,remoteID)
		values (
		<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.baseID#">,
		<cfqueryparam cfsqltype="cf_sql_numeric"  value="#rs.attributeID#">,
		<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rs.siteID#">,
		<cfif len(rs.attributeValue)>
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rs.attributeValue#">	
		<cfelse>
			null
		</cfif>,
		<cfif len(rs.datetimevalue)>
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rs.datetimevalue#">	
		<cfelse>
			null
		</cfif>,
		<cfif len(rs.numericvalue)>
			<cfqueryparam cfsqltype="cf_sql_numeric"  value="#rs.numericvalue#">	
		<cfelse>
			null
		</cfif>,
		<cfif len(rs.stringvalue)>
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#left(rs.stringvalue,250)#">	
		<cfelse>
			null
		</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar"  value="#remoteID#">
		)
	</cfquery>
</cfloop>

<!--- preserve get non file attributes that were'nt submitted along with extendedset  --->
<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
select #arguments.dataTable#.dataID, #arguments.dataTable#.baseID, #arguments.dataTable#.attributeID,#arguments.dataTable#.siteID, #arguments.dataTable#.attributevalue, 
#arguments.dataTable#.datetimevalue, #arguments.dataTable#.numericvalue, #arguments.dataTable#.stringvalue, tclassextendattributes.name  from #arguments.dataTable# #tableModifier#
inner join tclassextendattributes #tableModifier# on ( #arguments.dataTable#.attributeID=tclassextendattributes.attributeID)
inner join tclassextendsets #tableModifier# on (tclassextendattributes.extendsetID=tclassextendsets.extendsetID)
inner join tclassextend #tableModifier# on (tclassextendsets.subtypeID=tclassextend.subtypeID)
 where 
 <!---
tclassextend.type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.type#">
and 
	(
		tclassextend.subtype=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.subtype#">
		<cfif arguments.subType neq "Default">
		or tclassextend.subtype=<cfqueryparam cfsqltype="cf_sql_varchar"  value="Default">
		</cfif>
	)
--->
(
	tclassextend.type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.type#">
	<cfif not listFindNoCase("1,2,User,Group,Address,Site,Component,Form",arguments.type)>
			or tclassextend.type='Base'
	</cfif>
)

and (
	<cfif arguments.subtype neq "Default">
		tclassextend.subtype=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.subtype#">
		or
	</cfif>
	tclassextend.subtype='Default'
)


and baseID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.preserveID#">
<cfif hasExtendSets>
<cfset setLen=listLen(arguments.data.extendSetID)/>
and tclassextendattributes.extendSetID in (<cfloop from="1" to="#setLen#" index="s">
		'#listgetat(arguments.data.extendSetID,s)#'<cfif s lt setlen>,</cfif>
		</cfloop>)
</cfif>		
and tclassextendattributes.type<>'File'
</cfquery>

<cfloop query="rs">
<cfset key="ext#rs.attributeID#"/>
<cfif not structKeyExists(arguments.data,key)
	and not structKeyExists(arguments.data,rs.name)>
		
		<cfquery>
			insert into #arguments.dataTable# (baseID,attributeID,siteID,attributeValue,datetimevalue,numericvalue,stringvalue,remoteID)
				values (
				<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.baseID#">,
				<cfqueryparam cfsqltype="cf_sql_numeric"  value="#rs.attributeID#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rs.siteID#">,
				<cfif len(rs.attributeValue)>
				<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rs.attributeValue#">	
				<cfelse>
				null
				</cfif>,
				<cfif len(rs.datetimevalue)>
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rs.datetimevalue#">	
				<cfelse>
					null
				</cfif>,
				<cfif len(rs.numericvalue)>
					<cfqueryparam cfsqltype="cf_sql_numeric"  value="#rs.numericvalue#">	
				<cfelse>
					null
				</cfif>,
				<cfif len(rs.stringvalue)>
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rs.stringvalue#">	
				<cfelse>
					null
				</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar"  value="#remoteID#">
				)
			</cfquery>
		
	</cfif>
</cfloop>	

<!--- preserve  Files from submitted extendset and make sure that is they were'nt newly submitted that the fileID is carried forward--->
<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
select #arguments.dataTable#.dataID, #arguments.dataTable#.baseID, #arguments.dataTable#.attributeID,#arguments.dataTable#.siteID, #arguments.dataTable#.attributevalue, 
#arguments.dataTable#.datetimevalue, #arguments.dataTable#.numericvalue, #arguments.dataTable#.stringvalue, tclassextendattributes.name from #arguments.dataTable# #tableModifier#
inner join tclassextendattributes #tableModifier# on ( #arguments.dataTable#.attributeID=tclassextendattributes.attributeID)
inner join tclassextendsets #tableModifier# on (tclassextendattributes.extendsetID=tclassextendsets.extendsetID)
inner join tclassextend #tableModifier# on (tclassextendsets.subtypeID=tclassextend.subtypeID)
 where 
 <!---
tclassextend.type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.type#">
and 
	(
		tclassextend.subtype=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.subtype#">
		<cfif arguments.subType neq "Default">
		or tclassextend.subtype=<cfqueryparam cfsqltype="cf_sql_varchar"  value="Default">
		</cfif>
	)
--->
(
	tclassextend.type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.type#">
	<cfif not listFindNoCase("1,2,User,Group,Address,Site,Component,Form",arguments.type)>
			or tclassextend.type='Base'
	</cfif>
)

and (
	<cfif arguments.subtype neq "Default">
		tclassextend.subtype=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.subtype#">
		or
	</cfif>
	tclassextend.subtype='Default'
)

and baseID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.preserveID#">
<cfif hasExtendSets>
<cfset setLen=listLen(arguments.data.extendSetID)/>
and tclassextendattributes.extendSetID in (<cfloop from="1" to="#setLen#" index="s">
		'#listgetat(arguments.data.extendSetID,s)#'<cfif s lt setlen>,</cfif>
		</cfloop>)
</cfif>		
and tclassextendattributes.type='File'
</cfquery>

<cfloop query="rs">
		<cfset key="ext#rs.attributeID#"/>
		<cfset deletekey1="extDelete#rs.attributeID#"/>
		<cfset deletekey2="extDelete#rs.name#"/> 
		
		<cfif not((structKeyExists(arguments.data,key) and len(arguments.data[key]))
			or (structKeyExists(arguments.data,rs.name) and len(arguments.data[rs.name]))
			or structKeyExists(arguments.data,deletekey1) 
			or structKeyExists(arguments.data,deletekey2))
			and len(rs.attributeValue)>
		
		
						<cfquery>
						insert into #arguments.dataTable# (baseID,attributeID,siteID,attributeValue,stringvalue,remoteID)
						values (
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.baseID#">,
						<cfqueryparam cfsqltype="cf_sql_numeric"  value="#rs.attributeID#">,
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rs.siteID#">,
						<cfif len(rs.attributeValue)>
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rs.attributeValue#">	
						<cfelse>
						null
						</cfif>,
						<cfif len(rs.stringvalue)>
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rs.stringvalue#">	
						<cfelse>
						null
						</cfif>,
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="#remoteID#">
						)
						</cfquery>

		</cfif>
</cfloop>

</cffunction>

<cffunction name="getTypeAsString" returntype="string">
<cfargument name="type">

<cfif isNumeric(arguments.type)>
	<cfif arguments.type eq 1>
	<cfreturn "User Group">
	<cfelse>
	<cfreturn "User">
	</cfif>
<cfelse>
	<cfreturn arguments.type />
</cfif>

</cffunction>

<cffunction name="getSubTypes" returntype="query">
<cfargument name="siteid">
<cfargument name="activeOnly" default="false">
<cfset var rs = ""/>
<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	select * from tclassextend 
	where 
	siteid=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.siteid#">
	<cfif arguments.activeOnly>
		and isActive=1
	</cfif>
	order by type,subtype
	</cfquery>

<cfreturn rs />
</cffunction>

<cffunction name="getSubTypesByType" returntype="query">
<cfargument name="type">
<cfargument name="siteid">
<cfargument name="activeOnly" default="false">
<cfset var rs = ""/>
<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	select * from tclassextend 
	where 
	siteid=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.siteid#">
	and	type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.type#">
	<cfif arguments.activeOnly>
		and isActive=1
	</cfif>
	order by type,subtype
	</cfquery>

<cfreturn rs />
</cffunction>

<cffunction name="saveAttributeSort" returntype="void">
<cfargument name="attributeID">
<cfset var rs = ""/>
<cfset var a=0/>
<cfloop from="1" to="#listlen(arguments.attributeID)#" index="a">
	<cfquery>
	update tclassextendattributes
	set orderno=#a#
	where 
	attributeID=<cfqueryparam cfsqltype="cf_sql_numeric"  value="#listGetAt(arguments.attributeID,a)#">
	</cfquery>
</cfloop>

</cffunction>

<cffunction name="saveExtendSetSort" returntype="void">
<cfargument name="extendSetID">
<cfset var rs = ""/>
<cfset var s=0/>
<cfloop from="1" to="#listlen(arguments.extendSetID)#" index="s">
	<cfquery>
	update tclassextendsets
	set orderno=#s#
	where 
	extendSetID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#listGetAt(arguments.extendSetID,s)#">
	</cfquery>
</cfloop>

</cffunction>

<cffunction name="saveRelatedSetSort" returntype="void">
<cfargument name="relatedContentSetID">
<cfset var rs = ""/>
<cfset var s=0/>
<cfloop from="1" to="#listlen(arguments.relatedContentSetID)#" index="s">
	<cfquery>
		update tclassextendrcsets
		set orderno=#s#
		where 
		relatedContentSetID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#listGetAt(arguments.relatedContentSetID,s)#">
	</cfquery>
</cfloop>

</cffunction>

<cffunction name="getAttribute" returnType="string" output="false">
<cfargument name="baseID" required="true" default=""/>
<cfargument name="key" required="true" default=""/>
<cfargument name="dataTable" required="true" default="tclassextenddata"/>
	<cfset var rs =""/>
	<cfset var tempDate="">

	<cfif variables.configBean.getDBType() eq 'MSSQL'>
		<cfset var tableModifier="with (nolock)">
	<cfelse>
		<cfset var tableModifier="">
	</cfif>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	select #arguments.dataTable#.attributeValue,tclassextendattributes.defaultValue,#arguments.dataTable#.attributeID,tclassextendattributes.validation from tclassextendattributes #tableModifier#
	left join #arguments.dataTable# #tableModifier# ON (tclassextendattributes.attributeID=#arguments.dataTable#.attributeID)
	where 
	#arguments.dataTable#.baseID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.baseID#">
	and (
		<cfif isNumeric(arguments.key)>
		tclassextendattributes.attributeID=<cfqueryparam cfsqltype="cf_sql_numeric"  value="#arguments.key#">
		or</cfif>
		 tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.key#">)
	</cfquery>
	
	<cfif len(rs.attributeID)>
		<cfif listFindNoCase("Date,DateTime",rs.validation)>
			<cfset tempDate=rs.attributeValue>
			<cftry>
				<cfreturn parseDateTime(tempDate) />
				<cfcatch><cfreturn rs.attributeValue /></cfcatch>
			</cftry>
		<cfelse>
			<cfreturn rs.attributeValue />
		</cfif>
	<cfelse>
		<cfreturn getBean('contentRenderer').setDynamicContent(rs.defaultValue) />
	</cfif>
</cffunction>

<cffunction name="deleteExtendedData" output="false" returntype="void">
<cfargument name="baseid">
<cfargument name="dataTable" required="true" default="tclassextenddata">
	<cfset var rsFiles="">
	<cfset var fileManager=getBean("fileManager") />
	
	<cfif variables.configBean.getDBType() eq 'MSSQL'>
		<cfset var tableModifier="with (nolock)">
	<cfelse>
		<cfset var tableModifier="">
	</cfif>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsFiles')#">
		select attributeValue from #arguments.dataTable# #tableModifier#
		inner join tclassextendattributes on (#arguments.dataTable#.attributeID=tclassextendattributes.attributeID)
		where 
		tclassextendattributes.type='File'
		and #arguments.dataTable#.baseid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.baseid#"/>
		and #arguments.dataTable#.attributeValue is not null
	</cfquery>
		
	<cfloop query="rsFiles">
		<cfset fileManager.deleteIfNotUsed(rsFiles.attributeValue,arguments.baseID)/>
	</cfloop>

	<cfquery>
		delete from #arguments.dataTable# where 
	    baseid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.baseid#"/>
	</cfquery>		
		
</cffunction>

<cffunction name="getExtendedAttributeList" output="false" returntype="query">
<cfargument name="siteID">
<cfargument name="baseTable" required="true" default="tcontent">
<cfargument name="activeOnly" required="true" default="false">
	<cfset var rs="">
	
	<cfif variables.configBean.getDBType() eq 'MSSQL'>
		<cfset var tableModifier="with (nolock)">
	<cfelse>
		<cfset var tableModifier="">
	</cfif>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
		select tclassextend.type, tclassextend.subType, tclassextendattributes.attributeID, tclassextend.baseTable, tclassextend.baseKeyField, tclassextend.dataTable, tclassextendattributes.name AS attribute
		from tclassextendattributes #tableModifier#  
		inner join tclassextendsets #tableModifier# on (tclassextendsets.extendSetID=tclassextendattributes.extendSetID)
		inner join tclassextend #tableModifier# on (tclassextendsets.subTypeID=tclassextend.subTypeID)
		where tclassextend.siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#">
		and (
			tclassextend.baseTable= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.baseTable#">
			<cfif arguments.baseTable eq 'tcontent'>
			or tclassextend.type = 'Base'	
			</cfif>
		)
		<cfif arguments.activeOnly>
			and tclassextend.isActive=1
		</cfif>
		order by tclassextend.type, tclassextend.subType, tclassextendattributes.name
	</cfquery>
	
	<cfreturn rs>
</cffunction>

<cffunction name="getCastString" output="false">
<cfargument name="attribute">
<cfargument name="siteID">
<cfargument name="datatype">
<cfset var rs="">
<cfif variables.configBean.getStrictExtendedData()>
	<cfif not structKeyExists(arguments,"datatype")>
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
				select validation from tclassextendattributes 
				where 
				<cfif isNumeric(arguments.attribute)>
					attributeID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.attribute#">
				<cfelse>
					siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
					and name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.attribute#">
				</cfif>
		</cfquery>
		<cfset arguments.datatype=rs.validation>
	</cfif>
	<cfswitch expression="#arguments.datatype#">
	<cfcase value="Numeric">
		<cfreturn "numericvalue">
	</cfcase>
	<cfcase value="Date,DateTime,timestamp">
		<cfreturn "datetimevalue">
	</cfcase>
	<cfdefaultcase>
		<cfreturn "stringvalue">
	</cfdefaultcase>
	</cfswitch>
<cfelse>
	<cfreturn "stringvalue">
</cfif>
</cffunction>

<cffunction name="resetTypedData" output="false">
	<cfargument name="type" default="both">

		<cfif arguments.type eq "Both" or arguments.type eq "Content">
			<cfquery>
				<cfswitch expression="#variables.configBean.getDBType()#">
				<cfcase value="mysql">
				update tclassextenddata
				inner join tcontent on (tclassextenddata.baseID=tcontent.contentHistID
										and tcontent.active=1)
				set datetimevalue=null,
					numericvalue=null,
					stringvalue=null
				where attributeValue is not null
				</cfcase>
				<cfcase value="mssql">
				update tclassextenddata
				
				set datetimevalue=null,
					numericvalue=null,
					stringvalue=null
				
				from tclassextenddata 
				inner join tcontent on (tclassextenddata.baseID=tcontent.contentHistID
										and tcontent.active=1)
				where attributeValue is not null
				</cfcase>
				<cfcase value="postgresql">
				update tclassextenddata

				set datetimevalue=null,
					numericvalue=null,
					stringvalue=null

				from tcontent
				where tclassextenddata.baseID=tcontent.contentHistID
					and tcontent.active=1
					and attributeValue is not null
				</cfcase>
				<cfcase value="oracle">
				update tclassextenddata 				
				set datetimevalue=null,
					numericvalue=null,
					stringvalue=null
				where dataID in (Select 
						dataID
						from tclassextenddata 
						inner join tcontent on (tclassextenddata.baseID=tcontent.contentHistID
												and tcontent.active=1)
						where attributeValue is not null
					) 
				
				</cfcase>
				</cfswitch>
			</cfquery>
			
			<cfquery>
			<cfswitch expression="#variables.configBean.getDBType()#">
				<cfcase value="mysql">
				update tclassextenddata
				inner join tcontent on (tclassextenddata.baseID=tcontent.contentHistID
										and tcontent.active=1)
				set stringvalue=Left(attributeValue,255)
				where attributeValue is not null
				</cfcase>
				<cfcase value="mssql">
				update tclassextenddata
				
				set stringvalue=left(attributeValue,255)
					
				from tclassextenddata
				inner join tcontent on (tclassextenddata.baseID=tcontent.contentHistID
										and tcontent.active=1)
				where attributeValue is not null							
				</cfcase>
				<cfcase value="postgresql">
				update tclassextenddata

				set stringvalue=left(attributeValue,255)

				from tcontent
				where tclassextenddata.baseID=tcontent.contentHistID
					and tcontent.active=1
					and attributeValue is not null
				</cfcase>
				<cfcase value="oracle">
				update tclassextenddata 				
				set stringvalue=DBMS_LOB.SUBSTR(attributeValue,255,1)
				where dataID in (Select 
						dataID
						from tclassextenddata 
						inner join tcontent on (tclassextenddata.baseID=tcontent.contentHistID
												and tcontent.active=1)
						where attributeValue is not null
					) 
										
				</cfcase>
				</cfswitch>
			</cfquery>
			
			<cfif variables.configBean.getStrictExtendedData()>
				<cfquery>
					<cfswitch expression="#variables.configBean.getDBType()#">
					<cfcase value="mysql">
					update tclassextenddata
					inner join tclassextendattributes on (tclassextendattributes.attributeID=tclassextenddata.attributeID
														and (tclassextendattributes.validation='date' or tclassextendattributes.validation='datetime'))
					inner join tcontent on (tclassextenddata.baseID=tcontent.contentHistID
											and tcontent.active=1)
					set datetimevalue=STR_TO_DATE(subString(stringvalue,6,19),'%Y-%m-%d %T')
					where attributevalue is not null
					</cfcase>
					<cfcase value="mssql">
					update tclassextenddata
					
					set datetimevalue=cast(subString(stringvalue,6,19) as dateTime)
					
					from tclassextenddata 
					inner join tclassextendattributes on (tclassextendattributes.attributeID=tclassextenddata.attributeID
														and  (tclassextendattributes.validation='date' or tclassextendattributes.validation='datetime'))
					inner join tcontent on (tclassextenddata.baseID=tcontent.contentHistID
											and tcontent.active=1)
					where isDate(subString(stringvalue,6,19))=1
					</cfcase>
					<cfcase value="postgresql">
					update tclassextenddata

					set datetimevalue=subString(stringvalue from 6 for 19)::timestamp

					from tclassextendattributes,
						tcontent
					where tclassextendattributes.attributeID=tclassextenddata.attributeID
						and tclassextendattributes.validation='date'
						and tclassextenddata.baseID=tcontent.contentHistID
						and tcontent.active=1
						and subString(stringvalue from 6 for 19) ~ '^[12][0-9]{3}\-(0[1-9]|1[0-2])\-(0[1-9]|[12][0-9]|3[01]) ([01][0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])$'
					</cfcase>
					<cfcase value="oracle">
					update tclassextenddata 				
					set datetimevalue=to_date(subStr(stringvalue,6,19), 'YYYY-MM-DD HH24:MI:SS')
					where dataID in (Select 
							dataID
							from tclassextenddata 
							inner join tclassextendattributes on (tclassextendattributes.attributeID=tclassextenddata.attributeID
																and (lower(tclassextendattributes.validation)='date' or lower(tclassextendattributes.validation)='datetime'))
							inner join tcontent on (tclassextenddata.baseID=tcontent.contentHistID
													and tcontent.active=1)
							where attributeValue is not null
						) 
					</cfcase>
					</cfswitch>
				</cfquery>
				
				<!--- Make sure MySQL does not have any values set to '0000-00-00 00:00:00' --->
				<cfif variables.configBean.getDBType() eq "MYSQL">
					<cfquery>
					update tclassextenddata
					inner join tclassextendattributes on (tclassextendattributes.attributeID=tclassextenddata.attributeID
														and (tclassextendattributes.validation='date' or tclassextendattributes.validation='datetime'))
					inner join tcontent on (tclassextenddata.baseID=tcontent.contentHistID
											and tcontent.active=1)
					set datetimevalue=null
					where datetimevalue = '0000-00-00 00:00:00'
					</cfquery>
				</cfif>
				
				<cfquery>
					<cfswitch expression="#variables.configBean.getDBType()#">
					<cfcase value="mysql">
					update tclassextenddata
					inner join tclassextendattributes on (tclassextendattributes.attributeID=tclassextenddata.attributeID
														and tclassextendattributes.validation='numeric')
					inner join tcontent on (tclassextenddata.baseID=tcontent.contentHistID
											and tcontent.active=1)
					set numericvalue=0+stringvalue
					where attributeValue is not null
					</cfcase>
					<cfcase value="mssql">
					update tclassextenddata
					
					set numericvalue=cast(stringvalue as FLOAT)
					
					from tclassextenddata 
					inner join tclassextendattributes on (tclassextendattributes.attributeID=tclassextenddata.attributeID
														and  tclassextendattributes.validation='numeric')
					inner join tcontent on (tclassextenddata.baseID=tcontent.contentHistID
											and tcontent.active=1)
					where isNumeric(stringvalue)=1
					</cfcase>
					<cfcase value="postgresql">
					update tclassextenddata

					set numericvalue=stringvalue::real

					from tclassextendattributes,
						tcontent
					where tclassextendattributes.attributeID=tclassextenddata.attributeID
						and tclassextendattributes.validation='numeric'
						and tclassextenddata.baseID=tcontent.contentHistID
						and tcontent.active=1
						and stringvalue ~ '^[-]?([0-9]+[.]?[0-9]*|[.][0-9]+)$'
					</cfcase>
					<cfcase value="oracle">
					update tclassextenddata 				
					set numericvalue=cast(stringvalue as NUMBER)
					where dataID in (Select 
							dataID
							from tclassextenddata 
							inner join tclassextendattributes on (tclassextendattributes.attributeID=tclassextenddata.attributeID
																and lower(tclassextendattributes.validation)='numeric')
							inner join tcontent on (tclassextenddata.baseID=tcontent.contentHistID
													and tcontent.active=1)
							where attributeValue is not null
							and LENGTH(TRIM(TRANSLATE(stringvalue, ' +-.0123456789', ' '))) is null
						) 
					</cfcase>
					</cfswitch>
				</cfquery>
			</cfif>
			
		</cfif>
		
		<cfif arguments.type eq "Both" or arguments.type eq "User">
			
			<cfquery>
			<cfswitch expression="#variables.configBean.getDBType()#">
				<cfcase value="mysql">
				update tclassextenddatauseractivity
				set datetimevalue=null,
					numericvalue=null,
					stringvalue=null
				where attributeValue is not null
				</cfcase>
				<cfcase value="mssql">
				update tclassextenddatauseractivity
				set datetimevalue=null,
					numericvalue=null,
					stringvalue=null
				where attributeValue is not null
				</cfcase>
				<cfcase value="postgresql">
				update tclassextenddatauseractivity
				set datetimevalue=null,
					numericvalue=null,
					stringvalue=null
				where attributeValue is not null
				</cfcase>
				<cfcase value="oracle">
				update tclassextenddatauseractivity
				set datetimevalue=null,
					numericvalue=null,
					stringvalue=null
				where attributeValue is not null
				</cfcase>
				</cfswitch>
			</cfquery>
			
			<cfquery>
			<cfswitch expression="#variables.configBean.getDBType()#">
				<cfcase value="mysql">
				update tclassextenddatauseractivity
				set stringvalue=Left(attributeValue,255)
				where attributeValue is not null
				</cfcase>
				<cfcase value="mssql">
				update tclassextenddatauseractivity
				set stringvalue=left(attributeValue,255)
				where attributeValue is not null
				</cfcase>
				<cfcase value="postgresql">
				update tclassextenddatauseractivity
				set stringvalue=left(attributeValue,255)
				where attributeValue is not null
				</cfcase>
				<cfcase value="oracle">
				update tclassextenddatauseractivity
				set stringvalue=DBMS_LOB.SUBSTR(attributeValue,255,1)
				where attributeValue is not null
				</cfcase>
				</cfswitch>
			</cfquery>
			
			<cfif variables.configBean.getStrictExtendedData()>
				<cfquery>
					<cfswitch expression="#variables.configBean.getDBType()#">
					<cfcase value="mysql">
					update tclassextenddatauseractivity
					inner join tclassextendattributes on (tclassextendattributes.attributeID=tclassextenddatauseractivity.attributeID
														and tclassextendattributes.validation='date')
					set datetimevalue=STR_TO_DATE(subString(stringvalue,6,19),'%Y-%m-%d %T')
					where attributevalue is not null
					</cfcase>
					<cfcase value="mssql">
					update tclassextenddatauseractivity
					
					set datetimevalue=cast(subString(stringvalue,6,19) as dateTime)
					
					from tclassextenddatauseractivity 
					inner join tclassextendattributes on (tclassextendattributes.attributeID=tclassextenddatauseractivity.attributeID
														and  tclassextendattributes.validation='date')
					where isDate(subString(stringvalue,6,19))=1
					</cfcase>
					<cfcase value="postgresql">
					update tclassextenddatauseractivity

					set datetimevalue=subString(stringvalue from 6 for 19)::timestamp

					from tclassextendattributes
					where tclassextendattributes.attributeID=tclassextenddatauseractivity.attributeID
						and tclassextendattributes.validation='date'
						and subString(stringvalue from 6 for 19) ~ '^[12][0-9]{3}\-(0[1-9]|1[0-2])\-(0[1-9]|[12][0-9]|3[01]) ([01][0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])$'
					</cfcase>
					<cfcase value="oracle">
					update tclassextenddatauseractivity 				
					set datetimevalue=to_date(subStr(to_char(stringvalue),6,19), 'YYYY-MM-DD HH24:MI:SS')
					where dataID in (Select 
							dataID
							from tclassextenddatauseractivity 
							inner join tclassextendattributes on (tclassextendattributes.attributeID=tclassextenddatauseractivity.attributeID
																and lower(tclassextendattributes.validation)='date')
							where attributeValue is not null
						) 
					</cfcase>
					</cfswitch>
				</cfquery>
				
				<!--- Make sure MySQL does not have any values set to '0000-00-00 00:00:00' --->
				<cfif variables.configBean.getDBType() eq "MYSQL">
					<cfquery>
					update tclassextenddatauseractivity
					inner join tclassextendattributes on (tclassextendattributes.attributeID=tclassextenddatauseractivity.attributeID
														and tclassextendattributes.validation='date')
					set datetimevalue=null
					where datetimevalue = '0000-00-00 00:00:00'
					</cfquery>
				</cfif>
				
				<cfquery>
					<cfswitch expression="#variables.configBean.getDBType()#">
					<cfcase value="mysql">
					update tclassextenddatauseractivity
					inner join tclassextendattributes on (tclassextendattributes.attributeID=tclassextenddatauseractivity.attributeID
														and tclassextendattributes.validation='numeric')
					set numericvalue=0+stringvalue
					where attributeValue is not null
					</cfcase>
					<cfcase value="mssql">
					update tclassextenddatauseractivity
					
					set numericvalue=cast(stringvalue as FLOAT)
					
					from tclassextenddatauseractivity 
					inner join tclassextendattributes on (tclassextendattributes.attributeID=tclassextenddatauseractivity.attributeID
														and  tclassextendattributes.validation='numeric')
					where isNumeric(stringvalue)=1
					</cfcase>
					<cfcase value="postgresql">
					update tclassextenddatauseractivity

					set numericvalue=stringvalue::real

					from tclassextendattributes
					where tclassextendattributes.attributeID=tclassextenddatauseractivity.attributeID
						and tclassextendattributes.validation='numeric'
						and stringvalue ~ '^[-]?([0-9]+[.]?[0-9]*|[.][0-9]+)$'
					</cfcase>
					<cfcase value="oracle">
					update tclassextenddatauseractivity 				
					set numericvalue=cast(stringvalue as NUMBER)
					where dataID in (Select 
							dataID
							from tclassextenddatauseractivity 
							inner join tclassextendattributes on (tclassextendattributes.attributeID=tclassextenddatauseractivity.attributeID
																and lower(tclassextendattributes.validation)='numeric')
							where attributeValue is not null
							and LENGTH(TRIM(TRANSLATE(stringvalue, ' +-.0123456789', ' '))) is null
						) 
					</cfcase>
					</cfswitch>
				</cfquery>
			</cfif>
		</cfif>
	
</cffunction>

<cffunction name="syncDefinitions" output="false">
<cfargument name="fromSiteID" default="">
<cfargument name="toSiteID" default="">
<cfargument name="type" default="">
<cfargument name="subType" default="">	

<cfset var rsSubTypes=getSubTypes(arguments.fromSiteID)>
<cfset var extendSets="">
<cfset var sttributes="">
<cfset var sourceSubType="">
<cfset var destSubType="">
<cfset var sourceExtendSet="">
<cfset var destExtendSet="">
<cfset var sourceAttribute="">
<cfset var destAttribute="">
<cfset var s="">
<cfset var a="">
<cfset var attributes="">
<cfset var relatedSets="">
<cfset var sourceRelatedSet="">
<cfset var destRelatedSet="">

<cfif len(arguments.type)>
	<cfquery name="rsSubTypes" dbtype="query">	
		select * from rsSubTypes where type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#">
		<cfif len(arguments.subType)>
		and subtype=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.subtype#">
		</cfif> 
	</cfquery>
</cfif>

<cfloop query="rsSubTypes">
	<cfset sourceSubType=getSubTypeByID(rsSubTypes.subTypeID)>
	<cfset destSubType=getSubTypeByName(rsSubTypes.type,rsSubTypes.subType,arguments.toSiteID)>
	
	<cfset destSubType.setDataTable(sourceSubType.getDataTable())>
	<cfset destSubType.setBaseTable(sourceSubType.getBaseTable())>
	<cfset destSubType.setBaseKeyField(sourceSubType.getBaseKeyField())>
	<cfset destSubType.setIsActive(sourceSubType.getIsActive())>
	<cfset destSubType.setHasSummary(sourceSubType.getHasSummary())>
	<cfset destSubType.setHasBody(sourceSubType.getHasBody())>
	<cfset destSubType.setHasAssocFile(sourceSubType.getHasAssocFile())>
	<cfset destSubType.setHasConfigurator(sourceSubType.getHasConfigurator())>
	<cfset destSubType.setDescription(sourceSubType.getDescription())>
	<cfset destSubType.setAvailableSubTypes(sourceSubType.getAvailableSubTypes())>
	<cfset destSubType.setIconClass(sourceSubType.getIconClass())>
	<cfset destSubType.save()>
	
	<cfset extendSets=sourceSubType.getExtendSets(activeOnly=false)>
	
	<cfif arrayLen(extendSets)>
		<cfloop from="1" to="#arrayLen(extendSets)#" index="s">
			<cfset sourceExtendSet=extendSets[s]>
			<cfset destExtendSet=destSubType.getExtendSetByName(sourceExtendSet.getName())>
			<cfset destExtendSet.setContainer(sourceExtendSet.getContainer())>
			<cfset destExtendSet.setIsActive(sourceExtendSet.getIsActive())>
			<cfset destExtendSet.setOrderNo(sourceExtendSet.getOrderNo())>
			<cfset destExtendSet.save()>
			
			<cfset attributes=sourceExtendSet.getAttributes()>
			
			<cfif arrayLen(attributes)>
				<cfloop from="1" to="#arrayLen(attributes)#" index="a">
					<cfset sourceAttribute=attributes[a]>
					<cfset destAttribute=destExtendSet.getAttributeByName(sourceAttribute.getName())>
					
					<cfset destAttribute.setName(sourceAttribute.getName())>
					<cfset destAttribute.setHint(sourceAttribute.getHint())>
					<cfset destAttribute.setType(sourceAttribute.getType())>
					<cfset destAttribute.setOrderNo(sourceAttribute.getOrderNo())>
					<cfset destAttribute.setIsActive(sourceAttribute.getIsActive())>
					<cfset destAttribute.setRequired(sourceAttribute.getRequired())>
					<cfset destAttribute.setValidation(sourceAttribute.getValidation())>
					<cfset destAttribute.setRegex(sourceAttribute.getRegex())>
					<cfset destAttribute.setMessage(sourceAttribute.getMessage())>
					<cfset destAttribute.setLabel(sourceAttribute.getLabel())>
					<cfset destAttribute.setDefaultValue(sourceAttribute.getDefaultValue())>
					<cfset destAttribute.setOptionList(sourceAttribute.getOptionList())>
					<cfset destAttribute.setOptionLabelList(sourceAttribute.getOptionLabelList())>
					<cfset destAttribute.save()>
				</cfloop>
			</cfif>
			
		</cfloop>
	</cfif>

	<cfset relatedSets=sourceSubType.getRelatedContentSets(includeInheritedSets=false)>
	<cfif arrayLen(relatedSets)>
		<cfloop from="1" to="#arrayLen(relatedSets)#" index="s">
			<cfset sourceRelatedSet=relatedSets[s]>
			<cfset destRelatedSet=getBean('extendRelatedContentSetBean').loadBy(subTypeID=destSubType.getSubTypeID(),name=sourceRelatedSet.getName())>
			<cfset destRelatedSet.setAvailableSubTypes(sourceRelatedSet.getAvailableSubTypes())>
			<cfset destRelatedSet.setOrderNo(sourceRelatedSet.getOrderNo())>
			<cfset destRelatedSet.save()>
		</cfloop>
	</cfif>
</cfloop>
</cffunction>

<cffunction name="getSubTypeAsXML" returntype="xml">
	<cfargument name="type">
	<cfargument name="subtype">
	<cfargument name="siteid">
	<cfargument name="includeIDs" type="boolean" default="false" >
	
	<cfset var documentXML = xmlNew(false) />
	<cfset var extension = getSubTypeByName( argumentCollection=arguments) />
	<cfset var extensionXML = "" />
	<cfset var item = "" />

	<cfset var xmlRoot = XmlElemNew( documentXML, "", "MURA" ) />
	<cfset var xmlNode = XmlElemNew( documentXML, "", "EXTENSIONS" ) />

	<cfset documentXML.XmlRoot = xmlRoot />

	<cfset extensionXML = extension.getAsXML(documentXML,arguments.includeIDs) />

	<cfset ArrayAppend(
		documentXML.XmlRoot.XmlChildren,
		extensionXML
		) />

	<cfreturn documentXML />
</cffunction>

<cffunction name="getSubTypesAsXML">
	<cfargument name="subTypes" type="array" >
	<cfargument name="includeIDs" type="boolean" default="false" >
	
	<cfset var documentXML = xmlNew(false) />
	<cfset var extensionXML = "" />
	<cfset var i = 0 />
	<cfset var subType = "" />
	<cfset var xmlRoot = XmlElemNew( documentXML, "", "mura" ) />
	<cfset var xmlNode = XmlElemNew( documentXML, "", "extensions" ) />

	<cfset documentXML.XmlRoot = xmlRoot />

	<cfloop from="1" to="#ArrayLen(arguments.subTypes)#" index="i">
		<cfset subType = arguments.subTypes[i] />
		<!--- if is an id, get the bean --->
		<cfif isSimpleValue( subType ) and len(subType) eq 35>
			<cfset subType = getSubTypeByID( subType ) /> 
		</cfif>
		<cfif not subType.getIsNew()>
			<cfset extensionXML = subType.getAsXML(documentXML,arguments.includeIDs) />
		
			<cfset ArrayAppend(
				xmlNode.XmlChildren,
				extensionXML
				) />
		</cfif>
	</cfloop>
	<cfset ArrayAppend(
		xmlRoot.XmlChildren,
		xmlNode
		) />
	
	<cfreturn indentXml(toString(documentXML),"	") />
</cffunction>

<cffunction name="indentXml" output="false" returntype="string">
	<cfargument name="xml" type="string" required="true" />
	<cfargument name="indent" type="string" default="  " />

	  <cfset var lines = "" />
	  <cfset var depth = "" />
	  <cfset var line = "" />
	  <cfset var isCDATAStart = "" />
	  <cfset var isCDATAEnd = "" />
	  <cfset var isEndTag = "" />
	  <cfset var isSelfClose = "" />
	  
	  <cfset xml = trim(REReplace(xml, "(^|>)\s*(<|$)", "\1#chr(10)#\2", "all")) />
	  <cfset lines = listToArray(xml, chr(10)) />
	  <cfset depth = 0 />
	  <cfloop from="1" to="#arrayLen(lines)#" index="i">
	    <cfset line = trim(lines[i]) />
	    <cfset isCDATAStart = left(line, 9) EQ "<![CDATA[" />
	    <cfset isCDATAEnd = right(line, 3) EQ "]]>" />
	    <cfif NOT isCDATAStart AND NOT isCDATAEnd AND left(line, 1) EQ "<" AND right(line, 1) EQ ">">
	      <cfset isEndTag = left(line, 2) EQ "</" />
	      <cfset isSelfClose = right(line, 2) EQ "/>" OR REFindNoCase("<([a-z0-9_-]*).*</\1>", line) />
	      <cfif isEndTag>
	        <!--- use max for safety against multi-line open tags --->
	        <cfset depth = max(0, depth - 1) />
	      </cfif>
	      <cfset lines[i] = repeatString(indent, depth) & line />
	      <cfif NOT isEndTag AND NOT isSelfClose>
	        <cfset depth = depth + 1 />
	      </cfif>
	    <cfelseif isCDATAStart>
	      <!---
	      we don't indent CDATA ends, because that would change the
	      content of the CDATA, which isn't desirable
	      --->
	      <cfset lines[i] = repeatString(indent, depth) & line />
	    </cfif>
	  </cfloop>
	  <cfreturn arrayToList(lines, chr(10)) />
</cffunction>

<cffunction name="loadConfigXML" output="false">
	<cfargument name="configXML">
	<cfargument name="siteID">
	<cfset var documentXML="">
	<cfset var ext="">
	<cfset var subtype="">
	<cfset var extset="">
	<cfset var relset="">
	<cfset var at="">
	<cfset var attributesXML="">
	<cfset var attribute="">
	<cfset var attributeKeyList="">
	<cfset var ak="">
	<cfset var baseElement="">
	<cfset var imagesize="">
	<cfset var imagesizeXML="">
	<cfset var site=getBean('settingsManager').getSite(arguments.siteid)>
	<cfset var dirty=false>
	<cfset var extendset="">
	<cfset var extsetorder=0>
	<cfset var relsetorder=0>

	<cflock name="loadConfigXML#application.instanceID#" type="exclusive" timeout="200">
	<cfif isDefined("arguments.configXML.plugin")>
		<cfset baseElement="plugin">
	<cfelseif isDefined("arguments.configXML.theme")>
		<cfset baseElement="theme">
	<cfelseif isDefined("arguments.configXML.mura")>
		<cfset baseElement="mura">
	</cfif>	

	<cfif len(baseElement) 
		and (
			isDefined("arguments.configXML.#baseElement#.extensions") 
			and arraylen(arguments.configXML[baseElement].extensions)
		)>
	<cfscript>
		for(ext=1;ext lte arraylen(arguments.configXML[baseElement].extensions.xmlChildren); ext=ext+1){
						
			documentXML=arguments.configXML[baseElement].extensions.extension[ext];

			subType = application.classExtensionManager.getSubTypeBean();
			

			if(isDefined("documentXML.xmlAttributes.type")){
				if(documentXML.xmlAttributes.type eq 'User'){
					subType.setType( 2 );
				} else if(documentXML.xmlAttributes.type eq 'Group'){
					subType.setType( 1);
				} else {
					subType.setType( documentXML.xmlAttributes.type );
				}
			}
						
			if(isDefined("documentXML.xmlAttributes.subtype")){
				subType.setSubType( documentXML.xmlAttributes.subtype );
			}

			if(isDefined("documentXML.xmlAttributes.description")){
				subType.setDescription( documentXML.xmlAttributes.description );
			}

			if(isDefined("documentXML.xmlAttributes.availableSubTypes")){
				subType.setAvailableSubTypes( documentXML.xmlAttributes.availableSubTypes );
			}

			if(isDefined("documentXML.xmlAttributes.hassummary")){
				subType.setHasSummary( documentXML.xmlAttributes.hassummary );
			}

			if(isDefined("documentXML.xmlAttributes.hasassocfile")){
				subType.setHasAssocfile( documentXML.xmlAttributes.hasassocfile );
			}

			if(isDefined("documentXML.xmlAttributes.hasconfigurator")){
				subType.setHasConfigurator( documentXML.xmlAttributes.hasconfigurator );
			}

			if(isDefined("documentXML.xmlAttributes.hasbody")){
				subType.setHasBody( documentXML.xmlAttributes.hasbody );
			}

			if(isDefined("documentXML.xmlAttributes.isactive")){
				subType.setIsActive( documentXML.xmlAttributes.isactive );
			}

			if(isDefined("documentXML.xmlAttributes.iconClass")){
				subType.setIconClass( documentXML.xmlAttributes.iconClass );
			}
				      	
			subType.setSiteID( arguments.siteID );
			subType.load();

			if(subtype.getIsNew()){
				if(subtype.getType() eq "Site"){
			  		subType.setBaseTable( "tsettings" );
					subType.setBaseKeyField( "baseID" );
				} else if(listFindNoCase("1,2,Group,User",subtype.getType())){
					subType.setBaseTable( "tusers" );
					subType.setBaseKeyField( "userid" );
					subType.setDataTable("tclassextenddatauseractivity");
				} else if(subtype.getType() eq "Address"){
			  		subType.setBaseTable( "tusersaddresses" );
			  		subType.setDataTable("tclassextenddatauseractivity");
					subType.setBaseKeyField( "addressid" );	
				}

				subType.save();
			}

			for(extset=1;extset lte arraylen(documentXML.xmlChildren); extset=extset+1){
				      	
				extendSetXML=documentXML.xmlChildren[extset];

				if(extendSetXML.xmlName == 'attributeset' && isdefined('extendSetXML.xmlAttributes.name')){
					extsetorder=extsetorder+1;

					extendset= subType.getExtendSetByName(  extendSetXML.xmlAttributes.name );

					if(isDefined("extendSetXML.xmlAttributes.container")){
						extendset.setContainer( extendSetXML.xmlAttributes.container );
					}
								
					if(extendSet.getIsNew()){
						extendSet.setOrderNo(extsetorder);
						extendSet.save();
					}

					for(at=1;at lte arraylen(extendSetXML.xmlChildren); at=at+1){
						      		
						attributeXML=extendSetXML.xmlChildren[at];

						if(structKeyExists(attributeXML,"name")){
							attribute = extendSet.getAttributeByName(attributeXML.name.xmlText);
						} else {
							attribute = extendSet.getAttributeByName(attributeXML.xmlAttributes.name);
						}
						if(attribute.getIsNew()){
							attributeKeyList="label,type,optionlist,optionlabellist,defaultvalue,hint,required,validation,message,regex";
							
							for (ak=1;ak LTE listLen(attributeKeyList);ak=ak+1) {
							      			attrbuteKeyName=listGetAt(attributeKeyList,ak);
							    if(structKeyExists(attributeXML,attrbuteKeyName)){
									evaluate("attribute.set#attrbuteKeyName#(attributeXML[attrbuteKeyName].xmlText)");
								}else if(structKeyExists(attributeXML.xmlAttributes,attrbuteKeyName)) {
									evaluate("attribute.set#attrbuteKeyName#(attributeXML.xmlAttributes[attrbuteKeyName])");
								}
							}

							attribute.setOrderNo(at);
							attribute.save();
						}			
					}
				} else if(extendSetXML.xmlName == 'relatedcontentset' && isDefined("extendSetXML.xmlAttributes.name")){
					relsetorder=relsetorder+1;
					relset=getBean('extendRelatedContentSetBean').loadBy(siteID=subtype.getSiteID(),subTypeID=subType.getSubTypeID(),name=extendSetXML.xmlAttributes.name);
					if(isDefined("extendSetXML.xmlAttributes.AvailableSubTypes")){
						relset.setAvailableSubTypes(extendSetXML.xmlAttributes.AvailableSubTypes);
					}

					relset.setOrderNo(relsetorder);
					relset.save();
				}
			}
		}
	</cfscript>
	</cfif>

	<cfif len(baseElement) 
		and (
			isDefined("arguments.configXML.#baseElement#.imagesizes") 
			and arraylen(arguments.configXML[baseElement].imagesizes)
		)>
		<cfscript>
		for(ext=1;ext lte arraylen(arguments.configXML[baseElement].imagesizes.xmlChildren); ext=ext+1){
			imagesizeXML=arguments.configXML[baseElement].imagesizes.imagesize[ext];
			
			if(isDefined("imagesizeXML.xmlAttributes.name")){
				if(listFindNoCase('small,medium,large',imagesizeXML.xmlAttributes.name)){
					if(isDefined("imagesizeXML.xmlAttributes.height")
						and (isnumeric(imagesizeXML.xmlAttributes.height) or imagesizeXML.xmlAttributes.height eq "AUTO")
						and imagesizeXML.xmlAttributes.height neq evaluate('site.get#imagesizeXML.xmlAttributes.name#ImageHeight()')){	
						evaluate('site.set#imagesizeXML.xmlAttributes.name#ImageHeight(imagesizeXML.xmlAttributes.height)');
						dirty=true;
					}

					if(isDefined("imagesizeXML.xmlAttributes.width")
						and (isnumeric(imagesizeXML.xmlAttributes.width) or imagesizeXML.xmlAttributes.width eq "AUTO")
						and imagesizeXML.xmlAttributes.width neq evaluate('site.get#imagesizeXML.xmlAttributes.name#ImageWidth()')){						
						evaluate('site.set#imagesizeXML.xmlAttributes.name#ImageWidth(imagesizeXML.xmlAttributes.width)');
						dirty=true;
					}

				} else{ 
					imagesize=getBean('imagesize').loadBy(name=imagesizeXML.xmlAttributes.name,siteid=arguments.siteid);
					imagesize.setName(imagesizeXML.xmlAttributes.name);
					if(isDefined("imagesizeXML.xmlAttributes.height")){
						imagesize.setHeight(imagesizeXML.xmlAttributes.height);
					}
					if(isDefined("imagesizeXML.xmlAttributes.width")){
						imagesize.setWidth(imagesizeXML.xmlAttributes.width);
					}

					imagesize.setSiteID(arguments.siteid);
					imagesize.save();
				}
			}
			
			if(dirty){
				site.save();
			}

		}
		</cfscript>



	</cfif>
	</cflock>
</cffunction>

</cfcomponent>