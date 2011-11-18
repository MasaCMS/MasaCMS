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
<cfcomponent extends="mura.bean.beanExtendable" output="false">

<cfproperty name="addressID" type="string" default="" required="true" />
<cfproperty name="userID" type="string" default="" required="true" />
<cfproperty name="siteID" type="string" default="" required="true" />
<cfproperty name="isPrimary" type="numeric" default="0" required="true" />
<cfproperty name="address1" type="string" default="" required="true" />
<cfproperty name="address2" type="string" default="" required="true" />
<cfproperty name="fax" type="string" default="" required="true" />
<cfproperty name="city" type="string" default="" required="true" />
<cfproperty name="state" type="string" default="" required="true" />
<cfproperty name="zip" type="string" default="" required="true" />
<cfproperty name="phone" type="string" default="" required="true" />
<cfproperty name="country" type="string" default="" required="true" />
<cfproperty name="addressName" type="string" default="" required="true" />
<cfproperty name="addressEmail" type="string" default="" required="true" />
<cfproperty name="addressNotes" type="string" default="" required="true" />
<cfproperty name="addressURL" type="string" default="" required="true" />
<cfproperty name="hours" type="string" default="" required="true" />
<cfproperty name="longitude" type="numeric" default="0" required="true" />
<cfproperty name="latitude" type="numeric" default="0" required="true" />
<cfproperty name="extendDataTable" type="string" default="tclassextenddatauseractivity" required="true" />
<cfproperty name="isNew" type="numeric" default="0" required="true" />

<cffunction name="init" returntype="any" output="false" access="public">
	
	<cfset super.init(argumentCollection=arguments)>
	
	<cfset variables.instance.addressid="" />
	<cfset variables.instance.userid="" />
	<cfset variables.instance.siteid="" />
	<cfset variables.instance.isPrimary=0 />
	<cfset variables.instance.address1="" />
	<cfset variables.instance.address2="" />
	<cfset variables.instance.fax="" />
	<cfset variables.instance.city="" />
	<cfset variables.instance.state="" />
	<cfset variables.instance.zip="" />
	<cfset variables.instance.phone="" />
	<cfset variables.instance.country="" />
	<cfset variables.instance.addressID="" />
	<cfset variables.instance.addressName="" />
	<cfset variables.instance.addressEmail="" />
	<cfset variables.instance.addressNotes="" />
	<cfset variables.instance.addressURL="" />
	<cfset variables.instance.hours="" />
	<cfset variables.instance.longitude=0 />
	<cfset variables.instance.latitude=0 />
    <cfset variables.instance.errors=structnew() />
	<cfset variables.instance.extendDataTable="tclassextenddatauseractivity" />
	<cfset variables.instance.isNew=0 />
	<cfset variables.instance.type="Address" />
	<cfset variables.instance.subType="Default" />
	
	<cfreturn this />
</cffunction>

<cffunction name="setUserManager">
	<cfargument name="userManager">
	<cfset variables.userManager=arguments.userManager>
	<cfreturn this>
</cffunction>

<cffunction name="setSettingsManager">
	<cfargument name="settingsManager">
	<cfset variables.settingsManager=arguments.settingsManager>
	<cfreturn this>
</cffunction>

<cffunction name="setConfigBean">
	<cfargument name="configBean">
	<cfset variables.configBean=arguments.configBean>
	<cfreturn this>
</cffunction>

<cffunction name="set" returnType="any" output="false" access="public">
	<cfargument name="args" type="any" required="true">

	<cfset var prop=""/>
		
	<cfif isQuery(arguments.args) and arguments.args.recordcount>
		<cfloop list="#arguments.args.columnlist#" index="prop">
			<cfset setValue(prop,arguments.args[prop][1]) />
		</cfloop>
		
	<cfelseif isStruct(arguments.args)>
		<cfloop collection="#arguments.args#" item="prop">
			<cfset setValue(prop,arguments.args[prop]) />
		</cfloop>
	</cfif>
		
	<cfif isdefined('arguments.args.siteid') and trim(arguments.args.siteid) neq ''
		and isdefined('arguments.args.isPublic') and trim(arguments.args.isPublic) neq ''>
		<cfif arguments.args.isPublic eq 0>
			<cfset setSiteID(variables.settingsManager.getSite(arguments.args.siteid).getPrivateUserPoolID()) />
		<cfelse>
			<cfset setSiteID(variables.settingsManager.getSite(arguments.args.siteid).getPublicUserPoolID()) />
		</cfif>
	</cfif>

	<cfreturn this />
</cffunction>

<cffunction name="setGeoCoding"   output="false" access="public">
	<cfset var result=structNew() />
	<cfset var address=""/>
	<cfset var googleAPIKey="" />
	
	<cfif len(variables.instance.siteID)>
		<cfset googleAPIKey=variables.settingsManager.getSite(variables.instance.siteID).getGoogleAPIKey() />
		<cfif len(googleAPIKey)>
		
			<cfif len(variables.instance.address1)>
				<cfset address=listAppend(address,trim("#variables.instance.address1# #variables.instance.address2#")) />
			</cfif>
			
			<cfif len(variables.instance.siteID)>
				<cfset address=listAppend(address,variables.instance.state) />
			</cfif>
			
			<cfif len(variables.instance.country)>
				<cfset address=listAppend(address,variables.instance.country) />
			</cfif>	
			
			<cfif len(variables.instance.city)>
				<cfset address=listAppend(address,variables.instance.city) />
			</cfif>
			
			<cfif len(variables.instance.zip)>
				<cfset address=listAppend(address,variables.instance.zip) />
			</cfif>				
				
			<cfset result = getBean("geoCoding").geocode(googleAPIKey,trim(address))>
			
			<cfif structKeyExists(result, "latitude") and structKeyExists(result, "longitude")>
				<cfset variables.instance.longitude=result.longitude />
				<cfset variables.instance.latitude=result.latitude />
			</cfif>
		
		</cfif>
	
	</cfif>
	<cfreturn this>
</cffunction>
  
<cffunction name="getAddressID" returnType="string" output="false" access="public">
    <cfif not len(variables.instance.addressID)>
		<cfset variables.instance.addressID = createUUID() />
	</cfif>
	<cfreturn variables.instance.addressID />
</cffunction>

<cffunction name="setIsPrimary" output="false" access="public">
    <cfargument name="IsPrimary" required="true">
	
	<cfif isNumeric(arguments.IsPrimary)>
    <cfset variables.instance.IsPrimary = arguments.IsPrimary />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="validate" access="public" output="false" >
	<cfset var extErrors=structNew() />
	
	<cfif len(variables.instance.siteID)>
		<cfset extErrors=variables.configBean.getClassExtensionManager().validateExtendedData(getAllValues())>
	</cfif>
	
	<cfset variables.instance.errors=structnew() />
		
	<cfif not structIsEmpty(extErrors)>
		<cfset structAppend(variables.instance.errors,extErrors)>
	</cfif>	
	
	<cfset setGeoCoding()/>	
	<cfreturn this>
</cffunction>

<cffunction name="setLongitude" output="false" access="public">
    <cfargument name="Longitude" required="true">
    
	<cfif isNumeric(arguments.Longitude)>
		<cfset variables.instance.Longitude = arguments.Longitude />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setLatitude" output="false" access="public">
    <cfargument name="Latitude" required="true">
    
	<cfif isNumeric(arguments.Latitude)>
		<cfset variables.instance.Latitude = arguments.Latitude />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getExtendBaseID" output="false">
	<cfreturn getAddressID()>
</cffunction>

<cffunction name="save" output="false" access="public" returntype="any">
	<cfset var rs="">
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select addressID from tuseraddresses where addressID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getAddressID()#">
	</cfquery>
	
	<cfif rs.recordcount>
		<cfset variables.userManager.updateAddress(this)>
	<cfelse>
		<cfset variables.userManager.createAddress(this)>
	</cfif>
	
	<cfreturn this>
</cffunction>

<cffunction name="delete" output="false" access="public">
	<cfset variables.userManager.deleteAddress(getAddressID())>
</cffunction>

<cffunction name="clone" output="false">
	<cfreturn getBean("addressBean").setAllValues(structCopy(getAllValues()))>
</cffunction>
</cfcomponent>