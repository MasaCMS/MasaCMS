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
<cfcomponent output="false">

<cfset variables.relationship="" />
<cfset variables.field="" />
<cfset variables.dataType="" />
<cfset variables.condition="" />
<cfset variables.criteria="" />
<cfset variables.isValid=true />

<cffunction name="init" returntype="any" access="public">
	<cfargument name="relationship" default="">
	<cfargument name="field" default="">
	<cfargument name="dataType" default="varchar">
	<cfargument name="condition" default="Equals">
	<cfargument name="criteria" default="">
	
	<cfset setIsValid(true) />
	<cfset setField(arguments.Field) />
	<cfset setRelationship(arguments.relationship) />
	<cfset setDataType(arguments.dataType) />
	<cfset setCondition(arguments.condition) />
	<cfset setCriteria(arguments.criteria,arguments.condition) />
	
	<cfreturn this>
</cffunction>

<cffunction name="setRelationship">
	<cfargument name="relationship">
	<cfset variables.relationship=arguments.relationship />
</cffunction>

<cffunction name="getRelationship">
	<cfreturn variables.relationship />	
</cffunction>

<cffunction name="setField">
	<cfargument name="field">

	<cfset variables.field=arguments.field />
	<cfif arguments.field eq '' or arguments.field eq 'Select Field'>
		<cfset variables.field=""/>
		<cfset setIsValid(false) />
	</cfif>
</cffunction>

<cffunction name="getField">
	<cfreturn variables.field />
</cffunction>

<cffunction name="setCondition">
	<cfargument name="condition">
	
		<cfswitch expression="#arguments.condition#">
	 		<cfcase value="Equals,EQ,IS">
	 			<cfset variables.condition="=" />
	 		</cfcase>
	 		<cfcase value="GT">
	 			<cfset variables.condition=">" />
	 		</cfcase>
	 		<cfcase value="IN">
	 			<cfset variables.condition="in" />
	 		</cfcase>
	 		<cfcase value="NEQ">
	 			<cfset variables.condition="!=" />
	 		</cfcase>
	 		<cfcase value="GTE">
	 			<cfset variables.condition=">=" />
	 		</cfcase>
	 		<cfcase value="LT">
	 			<cfset variables.condition="<" />
	 		</cfcase>
	 		<cfcase value="LTE">
	 			<cfset variables.condition="<=" />
	 		</cfcase>
	 		<cfcase value="Begins,Contains">
		 		<cfif getDataType() eq "varchar">
					<cfset variables.condition="like" />
				<cfelse>
					<cfset variables.condition="=" />
				</cfif>
	 		</cfcase>
	 	</cfswitch>
	
</cffunction>

<cffunction name="getCondition">
	<cfreturn variables.condition />
</cffunction>

<cffunction name="setCriteria">
	<cfargument name="criteria">
	<cfargument name="condition">
	<cfset var tmp="" />
	
	<cftry>
		<cfset tmp=application.contentRenderer.setDynamicContent(arguments.criteria) />
	<cfcatch><cfset tmp=arguments.criteria /></cfcatch>
	</cftry>
	<cfswitch expression="#getDataType()#">
	<cfcase value="varchar">
		<cfswitch expression="#arguments.condition#">
			<cfcase value="Begins" >
				<cfset variables.criteria="#tmp#%" />
			</cfcase>
			<cfcase value="Contains" >
				<cfset variables.criteria="%#tmp#%" />
			</cfcase>
			<cfdefaultcase>
				<cfset variables.criteria="#tmp#" />
			</cfdefaultcase>
		</cfswitch>
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
	<cfcase value="timestamp" >
		<cfif lsIsDate(tmp)>
			<cfset tmp=lsParseDateTime(tmp)>
			<cfset variables.criteria=createODBCDateTime(createDateTime(year(tmp),month(tmp),day(tmp),hour(tmp),minute(tmp),0)) />
		<cfelseif isDate(tmp)>
			<cfset tmp=parseDateTime(tmp)>
			<cfset variables.criteria=createODBCDateTime(createDateTime(year(tmp),month(tmp),day(tmp),hour(tmp),minute(tmp),0)) />
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
	
</cffunction>

<cffunction name="getCriteria">
	<cfreturn variables.criteria />
</cffunction>

<cffunction name="setDataType">
	<cfargument name="dataType">
	<cfset variables.dataType=arguments.dataType />
</cffunction>

<cffunction name="getDataType">
	<cfreturn variables.dataType />
</cffunction>

<cffunction name="setIsValid">
	<cfargument name="IsValid">
	<cfset variables.isValid=arguments.isValid />
</cffunction>

<cffunction name="getIsValid">
	<cfreturn variables.isValid />
</cffunction>



</cfcomponent>