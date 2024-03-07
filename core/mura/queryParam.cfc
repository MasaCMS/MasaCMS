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
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfcomponent output="false" extends="mura.cfobject" hint="This provides a utility to property bind an query attribute">

<cfset variables.relationship="" />
<cfset variables.field="" />
<cfset variables.dataType="" />
<cfset variables.condition="" />
<cfset variables.criteria="" />
<cfset variables.orderBy="" />
<cfset variables.isValid=true />
<cfset variables.grouprelationships="(,and (,or (,),and not (,or not (,openGrouping,orOpenGrouping,andOpenGrouping,closeGrouping">

<cffunction name="init">
	<cfargument name="relationship" default="">
	<cfargument name="field" default="">
	<cfargument name="dataType" default="">
	<cfargument name="condition" default="Equals">
	<cfargument name="criteria" default="">

	<cfset setIsValid(true) />
	<cfif isDefined('arguments.column')>
		<cfset setField(arguments.column) />
	<cfelse>
		<cfset setField(arguments.Field) />
	</cfif>
	<cfset setRelationship(arguments.relationship) />
	<cfset setDataType(arguments.dataType) />
	<cfset setCondition(arguments.condition) />
	<cfset setCriteria(arguments.criteria,arguments.condition) />

	<cfset validate()>
	<cfreturn this>
</cffunction>

<cffunction name="setRelationship">
	<cfargument name="relationship">
	<cfif listFindNoCase("or,and," & variables.grouprelationships,arguments.relationship)>
		<cfset variables.relationship=arguments.relationship />
	</cfif>
</cffunction>

<cffunction name="getRelationship">
	<cfreturn variables.relationship />
</cffunction>

<cffunction name="setField">
	<cfargument name="field">

	<cfset arguments.field=rereplacenocase(arguments.field, '[^\w\.]+', '', 'all')>

	<cfif arguments.field eq '' or arguments.field eq 'Select Field'>
		<cfset variables.field=""/>
		<cfset setIsValid(false) />
	<cfelse>
		<cfset variables.field=arguments.field />
	</cfif>
</cffunction>

<cffunction name="setColumn">
	<cfargument name="column">

	<cfset setField(arguments.column) />
</cffunction>

<cffunction name="getField">
	<cfreturn variables.field />
</cffunction>

<cffunction name="getFieldStatement">
	<cfif variables.condition eq 'like' and application.configBean.getDbCaseSensitive()>
		<cfreturn "upper(" & REReplace(variables.field,"[^0-9A-Za-z\._,\- ]\*","","all") & ")"/>
	<cfelse>
		<cfreturn REReplace(variables.field,"[^0-9A-Za-z\._,\- ]\*","","all") />
	</cfif>
</cffunction>

<cffunction name="getColumn">
	<cfreturn getField() />
</cffunction>

<cffunction name="getColumnStatment">
	<cfreturn getFieldStatement() />
</cffunction>

<cffunction name="setCondition">
	<cfargument name="condition">

	<cfswitch expression="#arguments.condition#">
 		<cfcase value="Equals,EQ,IS,=">
 			<cfset variables.condition="=" />
 		</cfcase>
 		<cfcase value="GT,>">
 			<cfset variables.condition=">" />
 		</cfcase>
 		<cfcase value="IN">
 			<cfset variables.condition="in" />
 		</cfcase>
 		<cfcase value="NOTIN,NOT IN">
 			<cfset variables.condition="not in" />
 		</cfcase>
 		<cfcase value="NEQ,!=">
 			<cfset variables.condition="!=" />
 		</cfcase>
 		<cfcase value="GTE,>=">
 			<cfset variables.condition=">=" />
 		</cfcase>
 		<cfcase value="LT,<">
 			<cfset variables.condition="<" />
 		</cfcase>
 		<cfcase value="LTE,<=">
 			<cfset variables.condition="<=" />
 		</cfcase>
 		<cfcase value="Begins,BeginsWith,Contains,ContainsValue,Like,Ends,EndsWith">
	 		<cfif listFindNoCase("varchar,longvarchar",getDataType()) >
				<cfset variables.condition="like" />
			<cfelse>
				<cfset variables.condition="=" />
			</cfif>
 		</cfcase>
 	</cfswitch>

</cffunction>

<cffunction name="getCondition">
	<cfif variables.criteria eq "null">
		<cfif variables.condition eq "=">
			<cfreturn "is">
		<cfelseif variables.condition eq "!=">
			<cfreturn "is not">
		</cfif>
	<cfelse>
		<cfreturn variables.condition />
	</cfif>
</cffunction>

<cffunction name="getAllValues" output="false">
	<cfreturn variables>
</cffunction>

<cffunction name="setCriteria">
	<cfargument name="criteria">
	<cfargument name="condition">
	<cfset var tmp="" />

	<cfif not request.muraApiRequest>
		<cftry>
			<cfset tmp=getContentRenderer().setDynamicContent(arguments.criteria) />
		<cfcatch><cfset tmp=arguments.criteria /></cfcatch>
		</cftry>
	<cfelse>	
		<cfset tmp=arguments.criteria />	
	</cfif>

	<cfif not len(getDataType()) and len(tmp) and (LSIsDate(tmp) or IsDate(tmp))>
		<cfset setDataType('datetime') />
	</cfif>

	<cfif tmp eq "null">
		<cfset variables.criteria="null">
	<cfelse>
		<cfswitch expression="#getDataType()#">
		<cfcase value="varchar,longvarchar">
			<cfswitch expression="#arguments.condition#">
				<cfcase value="Begins,BeginsWith" >
					<cfset variables.criteria="#tmp#%" />
				</cfcase>
				<cfcase value="Ends,EndsWith" >
					<cfset variables.criteria="%#tmp#" />
				</cfcase>
				<cfcase value="Contains,ContainsValue,Like" >
					<cfset variables.criteria="%#tmp#%" />
				</cfcase>
				<cfdefaultcase>
					<cfset variables.criteria="#tmp#" />
				</cfdefaultcase>
			</cfswitch>
		</cfcase>
		<cfcase value="bit">
			<cfif isBoolean(tmp)>
				<cfset variables.criteria=tmp />
			<cfelse>
				<cfset variables.criteria="" />
				<cfset setIsValid(false) />
			</cfif>
		</cfcase>
		<cfcase value="date" >
			<cfif lsIsDate(tmp)>
				<cfset tmp=lsParseDateTime(tmp)>
				<cfset variables.criteria=createODBCDate(createDate(year(tmp),month(tmp),day(tmp))) />
			<cfelseif isDate(tmp)>
				<cfset tmp=parseDateTime(tmp)>
				<cfset variables.criteria=createODBCDate(createDate(year(tmp),month(tmp),day(tmp))) />
			<cfelse>
				<cfset variables.criteria="" />
				<cfset setIsValid(false) />
			</cfif>
		</cfcase>
		<cfcase value="timestamp,datetime">
			<cfif lsIsDate(tmp)>
				<cftry>
					<cfset tmp=lsParseDateTime(tmp)>
					<cfcatch><!--- already parsed ---></cfcatch>
				</cftry>
				<cfset variables.criteria=createODBCDateTime(tmp) />
			<cfelseif isDate(tmp)>
				<cftry>
					<cfset tmp=parseDateTime(tmp)>
					<cfcatch><!--- already parsed ---></cfcatch>
				</cftry>
				<cfset variables.criteria=createODBCDateTime(tmp) />
			<cfelse>
				<cfset variables.criteria="" />
				<cfset setIsValid(false) />
			</cfif>
		</cfcase>
		<cfcase value="time" >
			<cfif isDate(tmp)>
				<cfset variables.criteria=createODBCDateTime(tmp) />
			<cfelse>
				<cfset variables.criteria="" />
				<cfset setIsValid(false) />
			</cfif>
		</cfcase>
		<cfcase value="numeric" >
			<cfif isNumeric(tmp)>
				<cfset variables.criteria=tmp />
			<cfelse>
				<cfset variables.criteria="" />
				<cfset setIsValid(false) />
			</cfif>
		</cfcase>
		</cfswitch>
	</cfif>
</cffunction>

<cffunction name="getCriteria">
	<cfif variables.condition eq 'like' and application.configBean.getDbCaseSensitive()>
		<cfreturn ucase(variables.criteria) />
	<cfelse>
		<cfreturn variables.criteria />
	</cfif>
</cffunction>

<cffunction name="setDataType">
	<cfargument name="dataType">

	<cfif arguments.datatype eq 'datetime'>
		<cfset arguments.datatype="timestamp">
	<cfelseif arguments.datatype eq 'boolean'>
		<cfset arguments.datatype="bit">
	<cfelse>
		<cfset arguments.datatype=rereplacenocase(arguments.datatype, '\W', '', 'all')>
	</cfif>

	<cfset variables.dataType=arguments.dataType />
</cffunction>

<cffunction name="getDataType">
	<cfif not len(variables.dataType) and listlen(variables.field,".") eq 2>
		<cfset variables.dataType=getBean("dbUtility").columnParamType(column=listLast(variables.field,"."),table=listFirst(variables.field,"."))>
	</cfif>
	<cfreturn variables.dataType />
</cffunction>

<cffunction name="setIsValid">
	<cfargument name="IsValid">
	<cfset variables.isValid=arguments.isValid />
</cffunction>

<cffunction name="getIsValid">
	<cfreturn variables.isValid />
</cffunction>

<cffunction name="isGroupingParam" output="false">
	<cfreturn listFindNoCase(variables.grouprelationships,getRelationship()) >
</cffunction>

<cffunction name="validate">
	<cfif not isGroupingParam()
		and (variables.field eq '' or variables.field eq 'Select Field')>
		<cfset variables.field=""/>
		<cfset setIsValid(false) />
	<cfelse>
		<cfset setIsValid(true) />
	</cfif>
</cffunction>

<cffunction name="getContentRenderer" output="false">
	<cfset var sessionData=getSession()>
	<cfif structKeyExists(request,"servletEvent")>
		<cfreturn request.servletEvent.getContentRenderer()>
	<cfelseif structKeyExists(request,"event")>
		<cfreturn request.event.getContentRenderer()>
	<cfelseif isdefined('sessionData.siteID') and len(sessionData.siteID)>
		<cfreturn getBean("$").init(sessionData.siteID).getContentRenderer()>
	<cfelse>
		<cfreturn getBean("contentRenderer")>
	</cfif>

</cffunction>

<cffunction name="isListParam" output="false">
	<cfreturn listFindNoCase("IN,NOT IN",getCondition())>
</cffunction>

<cffunction name="getExtendedIDList" output="false">
	<cfargument name="table">
	<cfargument name="siteid">
	<cfargument name="tableModifier" default="">
	<cfset var maxrows=2100>
	<cfset var rs="">
	<cfset var castfield="attributeValue">

	<cfif application.configBean.getDbType() eq 'Oracle'>
		<cfset maxrows=990>
	</cfif>

	<cfset var isList=isListParam()>

	<cfquery attributeCollection="#application.configBean.getReadOnlyQRYAttrs(name='rs',maxrows=maxrows)#">
			select #arguments.table#.baseID from #arguments.table# #arguments.tableModifier#
			<cfif isNumeric(getField())>
				where #arguments.table#.attributeID=<cfqueryparam cfsqltype="cf_sql_numeric" value="#getField()#">
			<cfelse>
				inner join tclassextendattributes on (#arguments.table#.attributeID = tclassextendattributes.attributeID)
				where tclassextendattributes.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#">
				and tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getField()#">
			</cfif>
			and
			<cfif variables.condition neq "like">
				<cfset castfield=application.configBean.getClassExtensionManager().getCastString(getField(),arguments.siteid)>
			</cfif>
			<cfif variables.condition eq "like" and application.configBean.getDbCaseSensitive()>
				upper(#castfield#)
			<cfelse>
				#castfield#
			</cfif>
			#getCondition()#
			<cfif isList>
				(
			</cfif>
			<cfqueryparam cfsqltype="cf_sql_#getDataType()#" value="#getCriteria()#" list="#iif(isList,de('true'),de('false'))#" null="#iif(getCriteria() eq 'null',de('true'),de('false'))#">
			<cfif isList>
				)
			</cfif>
	</cfquery>

	<cfreturn valuelist(rs.baseid)>
</cffunction>

<cffunction name="setOrderBy">
	<cfargument name="orderby">
	<cfset variables.orderby=arguments.orderby />
</cffunction>

<cffunction name="getOrderBy" output="false">
	<cfreturn variables.orderby />
</cffunction>

</cfcomponent>
