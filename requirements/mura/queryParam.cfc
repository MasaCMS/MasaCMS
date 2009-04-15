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