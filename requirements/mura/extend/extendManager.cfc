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

<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="configBean">
	
	<cfset variables.configBean=arguments.configBean />
	
	<cfreturn this />
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
	
	<cfquery name="rs" datasource="#arguments.datasource#" username="#arguments.dbUsername#" password="#arguments.dbPassword#">
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
	from tclassextend
	inner join tclassextendsets on (tclassextend.subtypeid=tclassextendsets.subtypeid)
	inner join tclassextendattributes on (tclassextendsets.extendsetid=tclassextendattributes.extendsetid)
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

<cfif isDefined("arguments.data.extendSetID") and len(arguments.data.extendSetID)>
<cfset setLen=listLen(arguments.data.extendSetID)/>

<!--- process non-file attributes --->
<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
select attributeID,name,validation,message from tclassextendattributes where 
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
			<cfif rs.validation eq "Date">
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
<!--- process non-file attributes --->
<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
select attributeID,name,validation,message from tclassextendattributes where 
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
		
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			delete from #arguments.dataTable# 
			where baseID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.baseID#">
			and attributeID = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#rs.attributeID#">
		</cfquery>
			
		<cfquery  datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			insert into #arguments.dataTable# (baseID,attributeID,siteID,stringvalue,attributeValue,datetimevalue,numericvalue,remoteID
			)
			values (
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.baseID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rs.attributeID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.data.siteID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#left(theValue,255)#">,
			
			<cfif len(theValue)>
				
				<cfif rs.validation eq "Date">
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
<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
select attributeID,name from tclassextendattributes where 
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
			
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
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
		
		<cfquery  datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			insert into #arguments.dataTable# (baseID,attributeID,siteID,attributeValue,stringvalue,remoteID)
			values (
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.baseID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rs.attributeID#">,
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
<!--- preserve data from extendsets that were'nt submitted --->
<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
select #arguments.dataTable#.dataID, #arguments.dataTable#.baseID, #arguments.dataTable#.attributeID,#arguments.dataTable#.siteID, #arguments.dataTable#.attributevalue, 
#arguments.dataTable#.datetimevalue, #arguments.dataTable#.numericvalue, #arguments.dataTable#.stringvalue, tclassextendattributes.name from #arguments.dataTable#
inner join tclassextendattributes on ( #arguments.dataTable#.attributeID=tclassextendattributes.attributeID)
inner join tclassextendsets on (tclassextendattributes.extendsetID=tclassextendsets.extendsetID)
inner join tclassextend on (tclassextendsets.subtypeID=tclassextend.subtypeID)
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
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
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
</cfloop>

<!--- preserve get non file attributes that were'nt submitted along with extendedset  --->
<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
select #arguments.dataTable#.dataID, #arguments.dataTable#.baseID, #arguments.dataTable#.attributeID,#arguments.dataTable#.siteID, #arguments.dataTable#.attributevalue, 
#arguments.dataTable#.datetimevalue, #arguments.dataTable#.numericvalue, #arguments.dataTable#.stringvalue, tclassextendattributes.name  from #arguments.dataTable#
inner join tclassextendattributes on ( #arguments.dataTable#.attributeID=tclassextendattributes.attributeID)
inner join tclassextendsets on (tclassextendattributes.extendsetID=tclassextendsets.extendsetID)
inner join tclassextend on (tclassextendsets.subtypeID=tclassextend.subtypeID)
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
		
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
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
<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
select #arguments.dataTable#.dataID, #arguments.dataTable#.baseID, #arguments.dataTable#.attributeID,#arguments.dataTable#.siteID, #arguments.dataTable#.attributevalue, 
#arguments.dataTable#.datetimevalue, #arguments.dataTable#.numericvalue, #arguments.dataTable#.stringvalue, tclassextendattributes.name from #arguments.dataTable#
inner join tclassextendattributes on ( #arguments.dataTable#.attributeID=tclassextendattributes.attributeID)
inner join tclassextendsets on (tclassextendattributes.extendsetID=tclassextendsets.extendsetID)
inner join tclassextend on (tclassextendsets.subtypeID=tclassextend.subtypeID)
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
		
		
						<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
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
<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
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
<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
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
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
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
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tclassextendsets
	set orderno=#s#
	where 
	extendSetID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#listGetAt(arguments.extendSetID,s)#">
	</cfquery>
</cfloop>

</cffunction>

<cffunction name="getAttribute" returnType="string" output="false">
<cfargument name="baseID" required="true" default=""/>
<cfargument name="key" required="true" default=""/>
<cfargument name="dataTable" required="true" default="tclassextenddata"/>
<cfset var rs =""/>
<cfset var tempDate="">
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select #arguments.dataTable#.attributeValue,tclassextendattributes.defaultValue,#arguments.dataTable#.attributeID,tclassextendattributes.validation from tclassextendattributes
	left join #arguments.dataTable# ON (tclassextendattributes.attributeID=#arguments.dataTable#.attributeID)
	where 
	#arguments.dataTable#.baseID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.baseID#">
	and (
		<cfif isNumeric(arguments.key)>
		tclassextendattributes.attributeID=<cfqueryparam cfsqltype="cf_sql_numeric"  value="#arguments.key#">
		or</cfif>
		 tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.key#">)
	</cfquery>
	
	<cfif len(rs.attributeID)>
		<cfif rs.validation eq "Date">
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

	<cfquery name="rsFiles" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		select attributeValue from #arguments.dataTable#
		inner join tclassextendattributes on (#arguments.dataTable#.attributeID=tclassextendattributes.attributeID)
		where 
		tclassextendattributes.type='File'
		and #arguments.dataTable#.baseid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.baseid#"/>
		and #arguments.dataTable#.attributeValue is not null
	</cfquery>
		
	<cfloop query="rsFiles">
		<cfset fileManager.deleteIfNotUsed(rsFiles.attributeValue,arguments.baseID)/>
	</cfloop>

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from #arguments.dataTable# where 
	    baseid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.baseid#"/>
	</cfquery>		
		
</cffunction>

<cffunction name="getExtendedAttributeList" output="false" returntype="query">
<cfargument name="siteID">
<cfargument name="baseTable" required="true" default="tcontent">
<cfargument name="activeOnly" requierd="true" default="false">
	<cfset var rs="">
	
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		select tclassextend.type, tclassextend.subType, tclassextendattributes.attributeID, tclassextend.baseTable, tclassextend.baseKeyField, tclassextend.dataTable, tclassextendattributes.name attribute
		from tclassextendattributes 
		inner join tclassextendsets on (tclassextendsets.extendSetID=tclassextendattributes.extendSetID)
		inner join tclassextend on (tclassextendsets.subTypeID=tclassextend.subTypeID)
		where tclassextend.siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#">
		and tclassextend.baseTable= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.baseTable#">
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
		<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
				select validation from tclassextendattributes 
				where 
				<cfif isNumeric(arguments.attribute)>
				attributeID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.attribute#">
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
	<cfcase value="Date">
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
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
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
			
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
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
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
					<cfswitch expression="#variables.configBean.getDBType()#">
					<cfcase value="mysql">
					update tclassextenddata
					inner join tclassextendattributes on (tclassextendattributes.attributeID=tclassextenddata.attributeID
														and tclassextendattributes.validation='date')
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
														and  tclassextendattributes.validation='date')
					inner join tcontent on (tclassextenddata.baseID=tcontent.contentHistID
											and tcontent.active=1)
					where isDate(subString(stringvalue,6,19))=1
					</cfcase>
					<cfcase value="oracle">
					update tclassextenddata 				
					set datetimevalue=to_date(subStr(stringvalue,6,19), 'YYYY-MM-DD HH24:MI:SS')
					where dataID in (Select 
							dataID
							from tclassextenddata 
							inner join tclassextendattributes on (tclassextendattributes.attributeID=tclassextenddata.attributeID
																and lower(tclassextendattributes.validation)='date')
							inner join tcontent on (tclassextenddata.baseID=tcontent.contentHistID
													and tcontent.active=1)
							where attributeValue is not null
						) 
					</cfcase>
					</cfswitch>
				</cfquery>
				
				<!--- Make sure MySQL does not have any values set to '0000-00-00 00:00:00' --->
				<cfif variables.configBean.getDBType() eq "MYSQL">
					<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
					update tclassextenddata
					inner join tclassextendattributes on (tclassextendattributes.attributeID=tclassextenddata.attributeID
														and tclassextendattributes.validation='date')
					inner join tcontent on (tclassextenddata.baseID=tcontent.contentHistID
											and tcontent.active=1)
					set datetimevalue=null
					where datetimevalue = '0000-00-00 00:00:00'
					</cfquery>
				</cfif>
				
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
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
			
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
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
				<cfcase value="oracle">
				update tclassextenddatauseractivity
				set datetimevalue=null,
					numericvalue=null,
					stringvalue=null
				where attributeValue is not null
				</cfcase>
				</cfswitch>
			</cfquery>
			
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
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
				<cfcase value="oracle">
				update tclassextenddatauseractivity
				set stringvalue=DBMS_LOB.SUBSTR(attributeValue,255,1)
				where attributeValue is not null
				</cfcase>
				</cfswitch>
			</cfquery>
			
			<cfif variables.configBean.getStrictExtendedData()>
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
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
					<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
					update tclassextenddatauseractivity
					inner join tclassextendattributes on (tclassextendattributes.attributeID=tclassextenddatauseractivity.attributeID
														and tclassextendattributes.validation='date')
					set datetimevalue=null
					where datetimevalue = '0000-00-00 00:00:00'
					</cfquery>
				</cfif>
				
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
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
	<cfset destSubType.setDescription(sourceSubType.getDescription())>
	<cfset destSubType.setAvailableSubTypes(sourceSubType.getAvailableSubTypes())>
	
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
</cfloop>
</cffunction>

<cffunction name="loadConfigXML" output="false">
	<cfargument name="configXML">
	<cfargument name="siteID">
	<cfset var extXML="">
	<cfset var ext="">
	<cfset var subtype="">
	<cfset var extset="">
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

	<cfif isDefined("arguments.configXML.plugin")>
		<cfset baseElement="plugin">
	<cfelseif isDefined("arguments.configXML.theme")>
		<cfset baseElement="theme">
	</cfif>
	
	<cfif len(baseElement) 
		and (
			isDefined("arguments.configXML.#baseElement#.extensions") 
			and arraylen(arguments.configXML[baseElement].extensions)
		)>
	<cfscript>
		for(ext=1;ext lte arraylen(arguments.configXML[baseElement].extensions.xmlChildren); ext=ext+1){
						
			extXML=arguments.configXML[baseElement].extensions.extension[ext];

			subType = application.classExtensionManager.getSubTypeBean();
						
			if(isDefined("extXML.xmlAttributes.type")){
				subType.setType( extXML.xmlAttributes.type );
			}
						
			if(isDefined("extXML.xmlAttributes.subtype")){
				subType.setSubType( extXML.xmlAttributes.subtype );
			}

			if(isDefined("extXML.xmlAttributes.description")){
				subType.setDescription( extXML.xmlAttributes.description );
			}

			if(isDefined("extXML.xmlAttributes.availableSubTypes")){
				subType.setAvailableSubTypes( extXML.xmlAttributes.availableSubTypes );
			}

			if(isDefined("extXML.xmlAttributes.hassummary")){
				subType.setHasSummary( extXML.xmlAttributes.hassummary );
			}

			if(isDefined("extXML.xmlAttributes.hasbody")){
				subType.setHasBody( extXML.xmlAttributes.hasbody );
			}

			if(isDefined("extXML.xmlAttributes.isactive")){
				subType.setIsActive( extXML.xmlAttributes.isactive );
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

			for(extset=1;extset lte arraylen(extXML.xmlChildren); extset=extset+1){
				      	
				extendSetXML=extXML.xmlChildren[extset];

				 extendset= subType.getExtendSetByName(  extendSetXML.xmlAttributes.name );

				if(isDefined("extendSetXML.xmlAttributes.container")){
					extendset.setContainer( extendSetXML.xmlAttributes.container );
				}
							
				if(extendSet.getIsNew()){
					extendSet.setOrderNo(extset);
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
						imagesize.setHeight(imagesizeXML.xmlAttributes.width);
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
</cffunction>

</cfcomponent>