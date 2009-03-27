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
				<cfif prop neq 'siteID' and isdefined("variables.instance.#prop#")>
					<cfset evaluate("set#prop#(arguments.args[prop])") />
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
		<cfreturn variables.instance />
</cffunction>

<cffunction name="setGeoCoding"  returnType="void" output="false" access="public">
<cfset var result=structNew() />
<cfset var address=""/>
<cfset var googleAPIKey=variables.settingsManager.getSite(getSiteID()).getGoogleAPIKey() />

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
    <cfargument name="IsPrimary" type="numeric" required="true">
	
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
</cfcomponent>