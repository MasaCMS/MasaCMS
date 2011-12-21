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

<cfcomponent extends="mura.bean.bean" output="false">

<cfproperty name="placementID" type="string" default="" required="true" />
<cfproperty name="campaignID" type="string" default="" required="true" />
<cfproperty name="adzoneID" type="string" default="" required="true" />
<cfproperty name="creativeID" type="string" default="" required="true" />
<cfproperty name="dateCreated" type="date" default="" required="true" />
<cfproperty name="lastUpdate" type="date" default="" required="true" />
<cfproperty name="lastUpdateBy" type="string" default="" required="true" />
<cfproperty name="startDate" type="date" default="" required="true" />
<cfproperty name="endDate" type="date" default="" required="true" />
<cfproperty name="weekday" type="string" default="1,2,3,4,5,6,7" required="true" />
<cfproperty name="hour" type="string" default="0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23" required="true" />
<cfproperty name="costPerImp" type="numeric" default="0" required="true" />
<cfproperty name="costPerM" type="numeric" default="0" required="true" />
<cfproperty name="costPerClick" type="numeric" default="0" required="true" />
<cfproperty name="isExclusive" type="numeric" default="0" required="true" />
<cfproperty name="billable" type="numeric" default="0" required="true" />
<cfproperty name="budget" type="numeric" default="0" required="true" />
<cfproperty name="isActive" type="numeric" default="1" required="true" />
<cfproperty name="notes" type="string" default="" required="true" />
<cfproperty name="categoryID" type="string" default="" required="true" />

<cffunction name="init" returntype="any" output="false" access="public">
	
	<cfset super.init(argumentCollection=arguments)>
	
	<cfset variables.instance.placementID=""/>
	<cfset variables.instance.campaignID=""/>
	<cfset variables.instance.adZoneID=""/>
	<cfset variables.instance.creativeID=""/>
	<cfset variables.instance.dateCreated="#now()#"/>
	<cfset variables.instance.lastUpdate="#now()#"/>
	<cfset variables.instance.lastUpdateBy=""/>
	<cfset variables.instance.startDate=""/>
	<cfset variables.instance.endDate=""/>
	<cfset variables.instance.weekday="1,2,3,4,5,6,7" />
	<cfset variables.instance.hour="0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23" />
	<cfset variables.instance.CostPerImp=0 />
	<cfset variables.instance.CostPerM=0 />
	<cfset variables.instance.CostPerClick=0 />
	<cfset variables.instance.isExclusive=0 />
	<cfset variables.instance.billable=0 />
	<cfset variables.instance.budget=0 />
	<cfset variables.instance.isActive=1 />
	<cfset variables.instance.notes="" />
	<cfset variables.instance.categoryid="" />

	<cfreturn this />
</cffunction>

<cffunction name="setAdvertiserManager">
	<cfargument name="advertiserManager">
	<cfset variables.advertiserManager=arguments.advertiserManager>
	<cfreturn this>
</cffunction>

<cffunction name="set" returnType="void" output="false" access="public">
		<cfargument name="data" type="any" required="true">

		<cfset var prop="" />
		
		<cfif isQuery(arguments.data) and arguments.data.recordcount>
			<cfloop list="#arguments.data.columnlist#" index="prop">
				<cfset setValue(prop,arguments.data[prop][1]) />
			</cfloop>

			<cfset variables.instance.costPermM=variables.instance.costPerImp*1000 />
				
		<cfelseif isStruct(arguments.data)>
		
			<cfloop collection="#arguments.data#" item="prop">
				<cfset setValue(prop,arguments.data[prop])>
			</cfloop>
			
			<cfif isdefined("arguments.data.costPerM") and arguments.data.costPerM gt 0 >
				<cfset variables.instance.costPerImp= (arguments.data.costPerM/1000) />
			<cfelse>
				<cfset variables.instance.costPerImp= 0 />
			</cfif>
			
			<cfif not isdefined("arguments.data.hour")>
				<cfset variables.instance.hour= "" />
			</cfif>
			
			<cfif not isdefined("arguments.data.weekday")>
				<cfset variables.instance.weekday= "" />
			</cfif>

		</cfif>

</cffunction>

<cffunction name="setCategoryID" access="public" output="false">
	<cfargument name="categoryID" type="String" />
	<cfargument name="append" type="boolean" default="false" required="true" />
	<cfset var i="">
	
	<cfif not arguments.append>
		<cfset variables.instance.categoryID = trim(arguments.categoryID) />
	<cfelse>
		<cfloop list="#arguments.categoryID#" index="i">
		<cfif not listFindNoCase(variables.instance.categoryID,trim(i))>
	    	<cfset variables.instance.categoryID = listAppend(variables.instance.categoryID,trim(i)) />
	    </cfif> 
	    </cfloop>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setDateCreated" access="public" output="false">
	<cfargument name="dateCreated" type="String" />
	<cfif isDate(arguments.dateCreated)>
	<cfset variables.instance.dateCreated = parseDateTime(arguments.dateCreated) />
	<cfelse>
	<cfset variables.instance.dateCreated = ""/>
	</cfif>
</cffunction>

<cffunction name="setLastUpdate" access="public" output="false">
	<cfargument name="lastUpdate" type="String" />
	<cfif isDate(arguments.lastUpdate)>
	<cfset variables.instance.lastUpdate = parseDateTime(arguments.lastUpdate) />
	<cfelse>
	<cfset variables.instance.lastUpdate = ""/>
	</cfif>
</cffunction>

<cffunction name="setLastUpdateBy" access="public" output="false">
	<cfargument name="lastUpdateBy" type="String" />
	<cfset variables.instance.lastUpdateBy = left(trim(arguments.lastUpdateBy),50) />
</cffunction>

<cffunction name="setStartDate" access="public" output="false">
	<cfargument name="startDate" type="String" />
	<cfif lsisDate(arguments.startDate)>
		<cftry>
		<cfset variables.instance.startDate = lsparseDateTime(arguments.startDate) />
		<cfcatch>
			<cfset variables.instance.startDate = arguments.startDate />
		</cfcatch>
		</cftry>
		<cfelse>
		<cfset variables.instance.startDate = ""/>
	</cfif>
</cffunction>

<cffunction name="setEndDate" access="public" output="false">
	<cfargument name="endDate" type="String" />
	<cfif lsisDate(arguments.endDate)>
		<cftry>
		<cfset variables.instance.endDate = lsparseDateTime(arguments.endDate) />
		<cfcatch>
			<cfset variables.instance.endDate = arguments.endDate />
		</cfcatch>
		</cftry>
		<cfelse>
		<cfset variables.instance.endDate = ""/>
	</cfif>
</cffunction>

<cffunction name="save" output="false">
<cfset setAllValues(variables.advertiserManager.savePlacement(this).getAllValues())>
<cfreturn this>
</cffunction>

<cffunction name="delete" output="false">
<cfset variables.advertiserManager.deletePlacement(getPlacementID())>
</cffunction>

</cfcomponent>