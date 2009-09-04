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
<cfcomponent extends="mura.cfobject" output="false">
	<cfset variables.instance=structnew() />
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
	<cfset variables.instance.extendData="" />
	<cfset variables.instance.extendSetID="" />
	
<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="configBean" type="any" required="yes"/>
	<cfargument name="settingsManager" type="any" required="yes"/>
	<cfargument name="geoCoding" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.geoCoding=arguments.geoCoding />
	<cfreturn this />
	</cffunction>

 <cffunction name="set" returnType="void" output="false" access="public">
		<cfargument name="args" type="any" required="true">

		<cfset var prop=""/>
		
		<cfif isquery(arguments.args)>
		
			<cfset setUserID(arguments.args.UserID) />
			<cfset setAddress1(arguments.args.Address1) />
			<cfset setAddress2(arguments.args.Address2) />
			<cfset setCity(arguments.args.City) />
			<cfset setState(arguments.args.State) />
			<cfset setZip(arguments.args.Zip) />
			<cfset setPhone(arguments.args.Phone) />
			<cfset setSiteID(arguments.args.SiteID) />
			<cfset setFax(arguments.args.Fax) />
			<cfset setCountry(arguments.args.country) />
			<cfset setAddressID(arguments.args.addressID) />
			<cfset setAddressName(arguments.args.addressName) />
			<cfset setAddressNotes(arguments.args.addressNotes) />
			<cfset setIsPrimary(arguments.args.isPrimary) />
			<cfset setLongitude(arguments.args.Longitude) />
			<cfset setAddressEmail(arguments.args.AddressEmail) />
			<cfset setAddressURL(arguments.args.AddressURL) />
			<cfset setHours(arguments.args.hours) />
			
		<cfelseif isStruct(arguments.args)>
		
			<cfloop collection="#arguments.args#" item="prop">
				<cfif prop neq 'siteID'>
					<cfset setValue(prop,arguments.args[prop]) />
				</cfif>
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

		<cfset validate() />
		
  </cffunction>

<cffunction name="getAllValues" access="public" returntype="struct" output="false">
		<cfset var i="">
		<cfset var extData=getExtendedData().getAllExtendSetData()>
		<cfif not structIsEmpty(extData)>
			<cfset structAppend(variables.instance,extData.data,false)>	
			<cfloop list="#extData.extendSetID#" index="i">
				<cfif not listFind(variables.instance.extendSetID,i)>
					<cfset variables.instance.extendSetID=listAppend(variables.instance.extendSetID,i)>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn variables.instance />
</cffunction>

<cffunction name="setGeoCoding"  returnType="void" output="false" access="public">
<cfset var result=structNew() />
<cfset var address=""/>
<cfset var googleAPIKey="" />

<cfif len(getSiteID())>
	<cfset googleAPIKey=variables.settingsManager.getSite(getSiteID()).getGoogleAPIKey() />
	<cfif len(googleAPIKey)>
	
		<cfif len(getAddress1())>
			<cfset address=listAppend(address,trim("#getAddress1()# #getAddress2()#")) />
		</cfif>
		
		<cfif len(getState())>
			<cfset address=listAppend(address,getState()) />
		</cfif>
		
		<cfif len(getCountry())>
			<cfset address=listAppend(address,getCountry()) />
		</cfif>	
		
		<cfif len(getCity())>
			<cfset address=listAppend(address,getCity()) />
		</cfif>
		
		<cfif len(getZip())>
			<cfset address=listAppend(address,getZip()) />
		</cfif>				
			
		<cfset result = variables.geoCoding.geocode(googleAPIKey,trim(address))>
		
		<cfif structKeyExists(result, "latitude") and structKeyExists(result, "longitude")>
			<cfset setLongitude(result.longitude) />
			<cfset setLatitude(result.latitude) />
		</cfif>
	
	</cfif>

</cfif>
</cffunction>

<cffunction name="setAddressID" returnType="void" output="false" access="public">
    <cfargument name="addressID" type="string" required="true">
    <cfset variables.instance.addressID = trim(arguments.addressID) />
  </cffunction>
  
  <cffunction name="getAddressID" returnType="string" output="false" access="public">
    <cfif not len(variables.instance.addressID)>
		<cfset variables.instance.addressID = createUUID() />
	</cfif>
	<cfreturn variables.instance.addressID />
  </cffunction>

 <cffunction name="setUserID" returnType="void" output="false" access="public">
    <cfargument name="UserID" type="string" required="true">
    <cfset variables.instance.UserID = trim(arguments.UserID) />
  </cffunction>

  <cffunction name="getUserID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.UserID />
  </cffunction>
  
 <cffunction name="setSiteID" returnType="void" output="false" access="public">
    <cfargument name="SiteID" type="string" required="true">
    <cfset variables.instance.SiteID = trim(arguments.SiteID) />
  </cffunction>

  <cffunction name="getSiteID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.SiteID />
  </cffunction>

 <cffunction name="setAddress1" returnType="void" output="false" access="public">
    <cfargument name="Address1" type="string" required="true">
    <cfset variables.instance.Address1 = trim(arguments.Address1) />
  </cffunction>

  <cffunction name="getAddress1" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Address1 />
  </cffunction>
  
  <cffunction name="setAddress2" returnType="void" output="false" access="public">
    <cfargument name="Address2" type="string" required="true">
    <cfset variables.instance.Address2 = trim(arguments.Address2) />
  </cffunction>

  <cffunction name="getAddress2" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Address2 />
  </cffunction>
  
  <cffunction name="setCity" returnType="void" output="false" access="public">
    <cfargument name="City" type="string" required="true">
    <cfset variables.instance.City = trim(arguments.City) />
  </cffunction>

  <cffunction name="getCity" returnType="string" output="false" access="public">
    <cfreturn variables.instance.City />
  </cffunction>
  
 <cffunction name="setState" returnType="void" output="false" access="public">
    <cfargument name="State" type="string" required="true">
    <cfset variables.instance.State = trim(arguments.State) />
  </cffunction>

  <cffunction name="getState" returnType="string" output="false" access="public">
    <cfreturn variables.instance.State />
  </cffunction>
  
 <cffunction name="setZip" returnType="void" output="false" access="public">
    <cfargument name="Zip" type="string" required="true">
    <cfset variables.instance.Zip = trim(arguments.Zip) />
  </cffunction>

  <cffunction name="getZip" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Zip />
  </cffunction>
  
 <cffunction name="setPhone" returnType="void" output="false" access="public">
    <cfargument name="Phone" type="string" required="true">
    <cfset variables.instance.Phone= trim(arguments.Phone) />
  </cffunction>

  <cffunction name="getPhone" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Phone />
  </cffunction>
  
 <cffunction name="setFax" returnType="void" output="false" access="public">
    <cfargument name="Fax" type="string" required="true">
    <cfset variables.instance.Fax = trim(arguments.Fax) />
  </cffunction>
  
  <cffunction name="getFax" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Fax />
  </cffunction>

<cffunction name="setCountry" returnType="void" output="false" access="public">
    <cfargument name="country" type="string" required="true">
    <cfset variables.instance.country = trim(arguments.country) />
  </cffunction>
  
  <cffunction name="getCountry" returnType="string" output="false" access="public">
    <cfreturn variables.instance.country />
  </cffunction>

<cffunction name="setAddressName" returnType="void" output="false" access="public">
    <cfargument name="addressName" type="string" required="true">
    <cfset variables.instance.addressName = trim(arguments.addressName) />
  </cffunction>
  
  <cffunction name="getAddressName" returnType="string" output="false" access="public">
    <cfreturn variables.instance.addressName />
  </cffunction>
 
<cffunction name="setAddressNote" returnType="void" output="false" access="public">
    <cfargument name="addressNote" type="string" required="true">
    <cfset variables.instance.addressNote = trim(arguments.addressNote) />
  </cffunction>
  
  <cffunction name="getAddressNote" returnType="string" output="false" access="public">
    <cfreturn variables.instance.addressNote />
  </cffunction>

 <cffunction name="setIsPrimary" returnType="void" output="false" access="public">
    <cfargument name="IsPrimary" required="true">
	
	<cfif isNumeric(arguments.IsPrimary)>
    <cfset variables.instance.IsPrimary = arguments.IsPrimary />
	</cfif>
  </cffunction>
  
  <cffunction name="getIsPrimary" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.IsPrimary />
  </cffunction>
  
<cffunction name="getErrors" returnType="struct" output="false" access="public">
    <cfreturn variables.instance.errors />
 </cffunction>

 <cffunction name="setErrors" returnType="void" output="false" access="public">
  <cfargument name="errors"> 
	<cfif isStruct(arguments.errors)>
	 <cfset variables.instance.errors = arguments.errors />
	</cfif> 
 </cffunction>

<cffunction name="setAddressNotes" returnType="void" output="false" access="public">
    <cfargument name="AddressNotes" type="string" required="true">
    <cfset variables.instance.AddressNotes = trim(arguments.AddressNotes) />
  </cffunction>
  
  <cffunction name="getAddressNotes" returnType="string" output="false" access="public">
    <cfreturn variables.instance.AddressNotes />
 </cffunction>

<cffunction name="validate" access="public" output="false" returntype="void">
	<cfset setGeoCoding()/>	
</cffunction>
  
 <cffunction name="setAddressURL" returnType="void" output="false" access="public">
    <cfargument name="addressURL" type="string" required="true">
    <cfset variables.instance.addressURL = trim(arguments.addressURL) />
  </cffunction>

  <cffunction name="getAddressURL" returnType="string" output="false" access="public">
    <cfreturn variables.instance.addressURL />
  </cffunction>

 <cffunction name="setHours" returnType="void" output="false" access="public">
    <cfargument name="Hours" type="string" required="true">
    <cfset variables.instance.Hours = trim(arguments.Hours) />
  </cffunction>

  <cffunction name="getHours" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Hours />
  </cffunction>

 <cffunction name="setLongitude" returnType="void" output="false" access="public">
    <cfargument name="Longitude" required="true">
    
	<cfif isNumeric(arguments.Longitude)>
		<cfset variables.instance.Longitude = arguments.Longitude />
	</cfif>
  </cffunction>
  
  <cffunction name="getLongitude" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.Longitude />
  </cffunction>

 <cffunction name="setLatitude" returnType="void" output="false" access="public">
    <cfargument name="Latitude" required="true">
    
	<cfif isNumeric(arguments.Latitude)>
		<cfset variables.instance.Latitude = arguments.Latitude />
	</cfif>
  </cffunction>
  
  <cffunction name="getLatitude" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.Latitude />
  </cffunction>

 <cffunction name="setAddressEmail" returnType="void" output="false" access="public">
    <cfargument name="AddressEmail" type="string" required="true">
    <cfset variables.instance.addressEmail = trim(arguments.AddressEmail) />
  </cffunction>

  <cffunction name="getAddressEmail" returnType="string" output="false" access="public">
    <cfreturn variables.instance.addressEmail />
  </cffunction>

 <cffunction name="getExtendedData" returntype="any" output="false" access="public">
	<cfif not isObject(variables.instance.extendData)>
	<cfset variables.instance.extendData=variables.configBean.getClassExtensionManager().getExtendedData(baseID:getAddressID(), dataTable:'tclassextenddatauseractivity')/>
	</cfif> 
	<cfreturn variables.instance.extendData />
 </cffunction>

<cffunction name="getExtendedAttribute" returnType="string" output="false" access="public">
 <cfargument name="key" type="string" required="true">
 <cfargument name="useMuraDefault" type="boolean" required="true" default="false"> 
	
  	<cfreturn getExtendedData().getAttribute(arguments.key,arguments.useMuraDefault) />
</cffunction>

<cffunction name="setValue" returntype="any" access="public" output="false">
	<cfargument name="property"  type="string" required="true">
	<cfargument name="propertyValue" default="" >
	
	<cfset var extData =structNew() />
	<cfset var i = "">	
	
	<cfif structKeyExists(this,"set#property#")>
		<cfset evaluate("set#property#(arguments.propertyValue)") />
	<cfelseif structKeyExists(variables.instance,arguments.property)>
		<cfset variables.instance["#arguments.property#"]=arguments.propertyValue />
	<cfelse>
		<cfset extData=getExtendedData().getExtendSetDataByAttributeName(arguments.property)>
		<cfif not structIsEmpty(extData)>
			<cfset structAppend(variables.instance,extData.data,false)>	
			<cfloop list="#extData.extendSetID#" index="i">
				<cfif not listFind(variables.instance.extendSetID,i)>
					<cfset variables.instance.extendSetID=listAppend(variables.instance.extendSetID,i)>
				</cfif>
			</cfloop>
		</cfif>
			
		<cfset variables.instance["#arguments.property#"]=arguments.propertyValue />
		
	</cfif>
	
</cffunction>

<cffunction name="getValue" returntype="any" access="public" output="false">
	<cfargument name="property"  type="string" required="true">
	
	<cfif structKeyExists(this,"get#property#")>
		<cfreturn evaluate("get#property#()") />
	<cfelseif structKeyExists(variables.instance,"#arguments.property#")>
		<cfreturn variables.instance["#arguments.property#"] />
	<cfelse>
		<cfreturn getExtendedAttribute(arguments.property) />
	</cfif>
</cffunction>

<cffunction name="setAllValues" returntype="any" access="public" output="false">
	<cfargument name="instance">
	<cfset variables.instance=arguments.instance/>
</cffunction>

<cffunction name="save" output="false" access="public">
	<cfset variables.userManager.updateAddress(this)>
</cffunction>

<cffunction name="delete" output="false" access="public">
	<cfset variables.userManager.deleteAddress(getAddressID())>
</cffunction>
</cfcomponent>