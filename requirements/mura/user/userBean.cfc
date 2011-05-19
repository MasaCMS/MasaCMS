<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. �See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. �If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (�GPL�) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, �the copyright holders of Mura CMS grant you permission
to combine Mura CMS �with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the �/trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2 �without this exception. �You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false">
	<cfset variables.instance=structnew() />
	<cfset variables.instance.userid="" />
	<cfset variables.instance.remoteID="" />
	<cfset variables.instance.groupname="" />
	<cfset variables.instance.fname="" />
	<cfset variables.instance.lname="" />
	<cfset variables.instance.username="" />
	<cfset variables.instance.password="" />
	<cfset variables.instance.passwordCreated="#now()#" />
	<cfset variables.instance.email="" />
	<cfset variables.instance.company="" />
	<cfset variables.instance.jobtitle="" />
	<cfset variables.instance.website="" />
	<cfset variables.instance.MobilePhone="" />
	<cfset variables.instance.type=2 />
	<cfset variables.instance.subType='Default' />
	<cfset variables.instance.S2=0 />
	<cfset variables.instance.contactform="" />
	<cfset variables.instance.lastlogin="" />
	<cfset variables.instance.LastUpdate = now() />
	<cfset variables.instance.LastUpdateBy = "" />
	<cfset variables.instance.LastUpdateByID = "" />
	<cfset variables.instance.perm=0 />
	<cfset variables.instance.inactive=0 />
	<cfset variables.instance.ispublic=1 />
	<cfset variables.instance.siteid="" />
	<cfset variables.instance.subscribe=1 />
	<cfset variables.instance.notes="" />
	<cfset variables.instance.groupid="" />
	<cfset variables.instance.categoryid="" />
	<cfset variables.instance.primaryAddressID="" />
	<cfset variables.instance.addressID="" />
	<cfset variables.instance.addresses=queryNew("addressid,userid,siteid,address1,address2,city,state,zip,country,isPrimary,addressName,addressNotes,phone,fax,addressURL,longitude,latitude,addressEmail,hours") />
	<cfset variables.instance.description="" />
	<cfset variables.instance.interests="" />
	<cfset variables.instance.photoFileID="" />
	<cfset variables.instance.photoFileExt="" />
	<cfset variables.instance.keepPrivate=0 />
	<cfset variables.instance.IMName="" />
	<cfset variables.instance.IMService="" />
	<cfset variables.instance.tags="" />
	<cfset variables.instance.hKey="" />
	<cfset variables.instance.uKey="" />
	<cfset variables.instance.passedProtect=true />
	<cfset variables.instance.extendData="" />
	<cfset variables.instance.extendSetID="" />
    <cfset variables.instance.errors=structnew() />
	<cfset variables.instance.isNew=1 />
	<cfset variables.instance.tablist="" />
	<cfset variables.instance.newFile="" />
	<cfset variables.newAddresses = arrayNew(1) />
	
	<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="configBean" type="any" required="yes"/>
	<cfargument name="settingsManager" type="any" required="yes"/>
	<cfargument name="userManager" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.userManager=arguments.userManager />
	<cfreturn this />
	</cffunction>

 <cffunction name="set" returnType="any" output="false" access="public">
		<cfargument name="user" type="any" required="true">

		<cfset var prop="" />
		
		<cfif isquery(arguments.user)>
		
			<cfset setUserID(arguments.user.UserID) />
			<cfset setRemoteID(arguments.user.RemoteID) />
			<cfset setGroupname(arguments.user.Groupname) />
			<cfset setemail(arguments.user.email) />
			<cfset setFname(arguments.user.Fname) />
			<cfset setLname(arguments.user.Lname) />
			<cfset setUsername(arguments.user.Username) />
			<cfset setPasswordCreated(arguments.user.PasswordCreated) />
			<cfset setCompany(arguments.user.Company) />
			<cfset setMobilePhone(arguments.user.MobilePhone) />
			<cfset setJobTitle(arguments.user.JobTitle) />
			<cfset setWebsite(arguments.user.Website) />
			<cfset setType(arguments.user.Type) />
			<cfset setSubType(arguments.user.subType) />
			<cfset setS2(arguments.user.S2) />
			<cfset setContactForm(arguments.user.ContactForm) />
			<cfset setLastLogin(arguments.user.LastLogin) />
			<cfset setLastUpdate(arguments.user.LastUpdate) />
			<cfset setLastUpdateBy(arguments.user.LastUpdateBy) />
			<cfset setLastUpdateByID(arguments.user.LastUpdateByID) />
			<cfset setPerm(arguments.user.Perm) />
			<cfset setInActive(arguments.user.InActive) />
			<cfset setIsPublic(arguments.user.IsPublic) />
			<cfset setSubscribe(arguments.user.Subscribe) />
			<cfset setDescription(arguments.user.description) />
			<cfset setInterests(arguments.user.Interests) />
			<cfset setPhotoFileID(arguments.user.photoFileID) />
			<cfset setPhotoFileExt(arguments.user.photoFileExt) />
			<cfset setKeepPrivate(arguments.user.keepPrivate) />
			<cfset setIMName(arguments.user.IMName) />
			<cfset setIMService(arguments.user.IMService) />
			<cfset setTags(arguments.user.tags) />
			<cfset setTabList(arguments.user.tablist) />
			
			<cfset setNotes(arguments.user.Notes) />
			
		<cfelseif isStruct(arguments.user)>
		
			<cfloop collection="#arguments.user#" item="prop">
				<cfif prop neq 'siteID'>
					<cfset setValue(prop,arguments.user[prop]) />
				</cfif>
			</cfloop>
			
		</cfif>
		
		<cfif isdefined('arguments.user.siteid') and trim(arguments.user.siteid) neq ''>
			<cfif isdefined('arguments.user.switchToPublic') and trim(arguments.user.switchToPublic) eq '1'>
				<cfset setSiteID(variables.settingsManager.getSite(arguments.user.siteid).getPublicUserPoolID()) />
				<cfset setIsPublic(1) />
			<cfelseif isdefined('arguments.user.switchToPrivate') and trim(arguments.user.switchToPrivate) eq '1'>
				<cfset setSiteID(variables.settingsManager.getSite(arguments.user.siteid).getPrivateUserPoolID()) />
				<cfset setIsPublic(0) />
			<cfelseif getIsPublic() eq 0>
				<cfset setSiteID(variables.settingsManager.getSite(arguments.user.siteid).getPrivateUserPoolID()) />
			<cfelse>
				<cfset setSiteID(variables.settingsManager.getSite(arguments.user.siteid).getPublicUserPoolID()) />
			</cfif>
		</cfif>

		<cfset validate() />
		<cfreturn this />
  </cffunction>

<cffunction name="getAllValues" access="public" returntype="struct" output="false">
	<cfargument name="autocomplete" required="true" default="true">
		<cfset var i="">
		<cfset var extData="">
		
		<cfif arguments.autocomplete>
			<cfset extData=getExtendedData().getAllExtendSetData()>
			
			<cfif not structIsEmpty(extData)>
				<cfset structAppend(variables.instance,extData.data,false)>	
				<cfloop list="#extData.extendSetID#" index="i">
					<cfif not listFind(variables.instance.extendSetID,i)>
						<cfset variables.instance.extendSetID=listAppend(variables.instance.extendSetID,i)>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>	
		
		<cfset purgeExtendedData()>
		<cfreturn variables.instance />
</cffunction>
	
 <cffunction name="setUserID" output="false" access="public">
    <cfargument name="UserID" type="string" required="true">
    <cfset variables.instance.UserID = trim(arguments.UserID) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getUserID" returnType="string" output="false" access="public">
    <cfif not len(variables.instance.UserID)>
		<cfset variables.instance.UserID = createUUID() />
	</cfif>
	<cfreturn variables.instance.UserID />
  </cffunction>
  
  <cffunction name="setRemoteID" output="false" access="public">
    <cfargument name="RemoteID" type="string" required="true">
    <cfset variables.instance.RemoteID = arguments.RemoteID />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getRemoteID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.RemoteID />
  </cffunction>

 <cffunction name="setGroupName" output="false" access="public">
    <cfargument name="GroupName" type="string" required="true">
    <cfset variables.instance.GroupName = trim(arguments.GroupName) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getGroupName" returnType="string" output="false" access="public">
    <cfreturn variables.instance.GroupName />
  </cffunction>

 <cffunction name="setFname" output="false" access="public">
    <cfargument name="Fname" type="string" required="true">
    <cfset variables.instance.Fname = trim(arguments.Fname) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getFname" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Fname />
  </cffunction>
  
 <cffunction name="setLname" output="false" access="public">
    <cfargument name="Lname" type="string" required="true">
    <cfset variables.instance.Lname = trim(arguments.Lname) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getLname" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Lname />
  </cffunction>

 <cffunction name="setUsername" output="false" access="public">
    <cfargument name="Username" type="string" required="true">
    <cfset variables.instance.Username = trim(arguments.Username) />
	<cfreturn this>
  </cffunction>
  
   <cffunction name="setUsernameNoCache" output="false" access="public">
    <cfargument name="Username" type="string" required="true">
    <cfset variables.instance.Username = trim(arguments.Username) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getUsername" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Username />
  </cffunction>
  
 <cffunction name="setPassword" output="false" access="public">
    <cfargument name="Password" type="string" required="true">
    <cfset variables.instance.Password = trim(arguments.Password) />
	<cfreturn this>
  </cffunction>
  
   <cffunction name="setPasswordNoCache" output="false" access="public">
    <cfargument name="Password" type="string" required="true">
    <cfset variables.instance.Password = trim(arguments.Password) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getPassword" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Password />
  </cffunction>
  
 <cffunction name="setEmail" output="false" access="public">
    <cfargument name="Email" type="string" required="true">
    <cfset variables.instance.Email = trim(arguments.Email) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getEmail" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Email />
  </cffunction>

 <cffunction name="setMobilePhone" output="false" access="public">
    <cfargument name="MobilePhone" type="string" required="true">
    <cfset variables.instance.MobilePhone = trim(arguments.MobilePhone) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getMobilePhone" returnType="string" output="false" access="public">
    <cfreturn variables.instance.MobilePhone />
  </cffunction>
  
 <cffunction name="setCompany" output="false" access="public">
    <cfargument name="Company" type="string" required="true">
    <cfset variables.instance.Company = trim(arguments.Company) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getCompany" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Company />
  </cffunction>
  
 <cffunction name="setJobTitle" output="false" access="public">
    <cfargument name="JobTitle" type="string" required="true">
    <cfset variables.instance.JobTitle = trim(arguments.JobTitle) />
	<cfreturn this>
  </cffunction>


  <cffunction name="getJobTitle" returnType="string" output="false" access="public">
    <cfreturn variables.instance.JobTitle />
  </cffunction>

 <cffunction name="setWebsite" output="false" access="public">
    <cfargument name="Website" type="string" required="true">
    <cfset variables.instance.Website = trim(arguments.Website) />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getWebsite" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Website />
  </cffunction>
  
 <cffunction name="setType" output="false" access="public">
    <cfargument name="Type" type="numeric" required="true">
    <cfset variables.instance.Type = arguments.Type />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getType" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.Type />
  </cffunction>
 
  <cffunction name="setSubType" output="false" access="public">
    <cfargument name="SubType" type="string" required="true">
	<cfset arguments.subType=trim(arguments.subType)>
	<cfif len(arguments.subType) and variables.instance.SubType neq arguments.SubType>
    	<cfset variables.instance.SubType = arguments.SubType />
		<cfset purgeExtendedData()>
	</cfif>
	<cfreturn this>
  </cffunction>

  <cffunction name="getSubType" returnType="string" output="false" access="public">
    <cfreturn variables.instance.SubType />
  </cffunction>
   
 <cffunction name="setContactForm" output="false" access="public">
    <cfargument name="ContactForm" type="string" required="true">
    <cfset variables.instance.ContactForm = arguments.ContactForm />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getContactForm" returnType="string" output="false" access="public">
    <cfreturn variables.instance.ContactForm />
  </cffunction>
  
 <cffunction name="setS2" output="false" access="public">
    <cfargument name="S2" type="numeric" required="true">
    <cfset variables.instance.S2 = arguments.S2 />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getS2" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.S2 />
  </cffunction>
  
 <cffunction name="setLastLogin" output="false" access="public">
    <cfargument name="LastLogin" type="String" required="true">
	<cfif isDate(arguments.LastLogin)>
    <cfset variables.instance.LastLogin = parseDateTime(arguments.LastLogin) />
	</cfif>
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getLastLogin" returnType="String" output="false" access="public">
    <cfreturn variables.instance.LastLogin />
  </cffunction>

  <cffunction name="setLastUpdate" output="false" access="public">  
    <cfargument name="LastUpdate" type="string" required="true">
	<cfif lsisDate(arguments.LastUpdate)>
		<cftry>
		<cfset variables.instance.LastUpdate = lsparseDateTime(arguments.LastUpdate) />
		<cfcatch>
			<cfset variables.instance.LastUpdate = arguments.LastUpdate />
		</cfcatch>
		</cftry>
		<cfelse>
		<cfset variables.instance.LastUpdate = ""/>
	</cfif>
	<cfreturn this>
  </cffunction>

  <cffunction name="getLastUpdate" returnType="string" output="false" access="public">
    <cfreturn variables.instance.LastUpdate />
  </cffunction>

  <cffunction name="setLastUpdateBy" output="false" access="public">
    <cfargument name="LastUpdateBy" type="string" required="true">
    <cfset variables.instance.LastUpdateBy = left(trim(arguments.LastUpdateBy),50) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getLastUpdateBy" returnType="string" output="false" access="public">
    <cfreturn variables.instance.LastUpdateBy />
  </cffunction>
  
  <cffunction name="setLastUpdateByID" output="false" access="public">
    <cfargument name="LastUpdateByID" type="string" required="true">
    <cfset variables.instance.LastUpdateByID = trim(arguments.LastUpdateByID) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getLastUpdateByID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.LastUpdateByID />
  </cffunction>
  
 <cffunction name="setPerm" output="false" access="public">
    <cfargument name="Perm" type="numeric" required="true">
    <cfset variables.instance.Perm = arguments.Perm />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getPerm" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.Perm />
  </cffunction>
  
 <cffunction name="setInActive" output="false" access="public">
    <cfargument name="InActive" type="numeric" required="true">
    <cfset variables.instance.InActive = arguments.InActive />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getInActive" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.InActive />
  </cffunction>
  
 <cffunction name="setIsPublic" output="false" access="public">
    <cfargument name="IsPublic" type="numeric" required="true">
    <cfset variables.instance.IsPublic = arguments.IsPublic />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getIsPublic" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.IsPublic />
  </cffunction>
  
 <cffunction name="setSubscribe" output="false" access="public">
    <cfargument name="Subscribe" type="numeric" required="true">
    <cfset variables.instance.Subscribe = arguments.Subscribe />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getSubscribe" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.Subscribe />
  </cffunction>
  
  <cffunction name="setSiteID" output="false" access="public">
    <cfargument name="SiteID" type="string" required="true">
	<cfif len(arguments.siteID) and trim(arguments.siteID) neq variables.instance.siteID>
    <cfset variables.instance.SiteID = trim(arguments.SiteID) />
	<cfset purgeExtendedData()>
	</cfif>
	<cfreturn this>
  </cffunction>

  <cffunction name="getSiteID" returnType="string" output="false" access="public">
	<cfreturn variables.instance.SiteID />
  </cffunction>
  
  <cffunction name="setNotes" output="false" access="public">
    <cfargument name="Notes" type="string" required="true">
    <cfset variables.instance.Notes = trim(arguments.Notes) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getNotes" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Notes />
  </cffunction>
  
  <cffunction name="setGroupID" access="public" output="false">
	<cfargument name="groupID" type="String" />
	<cfargument name="append" type="boolean" default="false" required="true" />
	<cfset var i="">
	
    <cfif not arguments.append>
		<cfset variables.instance.groupID = trim(arguments.groupID) />
	<cfelse>
		<cfloop list="#arguments.groupID#" index="i">
		<cfif not listFindNoCase(variables.instance.groupID,trim(i))>
	    	<cfset variables.instance.groupID = listAppend(variables.instance.groupID,trim(i)) />
	    </cfif>
	    </cfloop> 
	</cfif>
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getGroupID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.groupID />
  </cffunction>

  <cffunction name="setPrimaryAddressID" output="false" access="public">
    <cfargument name="PrimaryAddressID" type="string" required="true">
    <cfset variables.instance.PrimaryAddressID = trim(arguments.PrimaryAddressID) />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getPrimaryAddressID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.PrimaryAddressID />
  </cffunction>

  <cffunction name="setAddressID" output="false" access="public">
    <cfargument name="AddressID" type="string" required="true">
    <cfset variables.instance.AddressID = trim(arguments.AddressID) />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getAddressID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.AddressID />
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

  <cffunction name="getCategoryID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.CategoryID />
  </cffunction>

 <cffunction name="setAddresses" output="false" access="public" hint="deprecated">
    <cfargument name="addresses" required="true">
    <cfif not isQuery(arguments.addresses)>
	<cfset variables.instance.addresses = arguments.addresses />
	</cfif>
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getAddresses" returnType="query" output="false" access="public">
    <cfreturn getAddressesQuery() />
  </cffunction>
	
  <cffunction name="getAddressesQuery" returnType="query" output="false" access="public">
   <cfreturn variables.userManager.getAddresses(getUserID()) />
  </cffunction>

  <cffunction name="getAddressesIterator" returnType="any" output="false" access="public">
   	<cfset var it=getServiceFactory().getBean("addressIterator").init()>
	<cfset it.setQuery(getAddressesQuery())>
	<cfreturn it />
  </cffunction>

 <cffunction name="getErrors" returnType="struct" output="false" access="public">
    <cfreturn variables.instance.errors />
 </cffunction>
  
 <cffunction name="setErrors" output="false" access="public">
  <cfargument name="errors"> 
	<cfif isStruct(arguments.errors)>
	 <cfset variables.instance.errors = arguments.errors />
	</cfif> 
	<cfreturn this>
 </cffunction>

  <cffunction name="checkUsername" returntype="boolean" output="false" access="public">

		<cfset var rsCheck=""/>
		<cfquery name="rsCheck" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		select username from tusers where type=2 and username=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.instance.username)#"> and UserID <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.instance.userID)#"> 
		</cfquery>
		
		<cfif not rscheck.recordcount>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
		
	</cffunction>
	
 <cffunction name="checkEmail" returntype="boolean" output="false" access="public">
		
		<cfset var rsCheck=""/>
		<cfquery name="rsCheck" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		select username from tusers where type=2 and email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.instance.email)#"> and UserID <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.instance.userID)#">  
		and (siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settingsManager.getSite(variables.instance.siteid).getPrivateUserPoolID()#">
			or 
			siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settingsManager.getSite(variables.instance.siteid).getPublicUserPoolID()#">
			) 
		</cfquery>
		
		<cfif not rscheck.recordcount>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
		
	</cffunction>
   

<cffunction name="validate" access="public" output="false" >
		<cfset var extErrors=structNew() />
	
		<cfif len(getSiteID())>
			<cfset extErrors=variables.configBean.getClassExtensionManager().validateExtendedData(getAllValues())>
		</cfif>
		
		<cfset variables.instance.errors=structnew() />
		
		<cfif not structIsEmpty(extErrors)>
			<cfset structAppend(variables.instance.errors,extErrors)>
		</cfif>	
		
		<cfif trim(variables.instance.siteid) neq "">
		
			<cfif variables.instance.type eq 2 and (variables.instance.username eq "" or not checkUsername())>
			<cfset variables.instance.errors.username=variables.settingsManager.getSite(getSiteID()).getRBFactory().getResourceBundle().messageFormat( variables.settingsManager.getSite(getSiteID()).getRBFactory().getKey("user.usernamevalidate") , getusername() ) />
			</cfif>
			
			<cfif variables.instance.type eq 2 and variables.instance.email eq "" >
			<cfset variables.instance.errors.email=variables.settingsManager.getSite(getSiteID()).getRBFactory().getKey("user.emailrequired") />
			</cfif>
			
			<!--- If captcha data has been submitted validate it --->
			<cfif not (not len(variables.instance.hKey) or variables.instance.hKey eq hash(variables.instance.uKey))>
			<cfset variables.instance.errors.SecurityCode=variables.settingsManager.getSite(getSiteID()).getRBFactory().getKey("captcha.error")/>
			</cfif>
			
			<!--- If cfformprotect has been submitted validate it --->
			<cfif not variables.instance.passedProtect>
			<cfset variables.instance.errors.Spam=variables.settingsManager.getSite(getSiteID()).getRBFactory().getKey("captcha.spam")/>
			</cfif>
		
		<cfelse>
			<cfset variables.instance.errors.siteid="The 'SiteID' variable is missing." />
		</cfif>
		<cfreturn this>
	</cffunction>
 

  <cffunction name="getAddressByID" returnType="query" output="false" access="public">
	<cfargument name="addressID" type="string" required="true">
	<cfreturn variables.userManager.getAddressByID(arguments.addressID) />
  </cffunction>

  <cffunction name="getAddressBeanByID" returnType="any" output="false" access="public">
	<cfargument name="addressID" type="string" required="true">
	<cfset var addressBean=application.serviceFactory.getBean("addressBean") />
	
	<cfset addressBean.set(getAddressByID(arguments.addressID))>
	<cfset addressBean.setAddressID(arguments.addressID)>
	<cfset addressBean.setUserID(getUserID())>
	<cfset addressBean.setSiteID(getSiteID())>
	
	<cfreturn addressBean />
  </cffunction>

  <cffunction name="setDescription" output="false" access="public">
    <cfargument name="Description" type="string" required="true">
    <cfset variables.instance.Description = trim(arguments.Description) />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getDescription" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Description />
  </cffunction>

  <cffunction name="setInterests" output="false" access="public">
    <cfargument name="Interests" type="string" required="true">
    <cfset variables.instance.Interests = trim(arguments.Interests) />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getInterests" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Interests />
  </cffunction>

  <cffunction name="setPhotoFileID" output="false" access="public">
    <cfargument name="PhotoFileID" type="string" required="true">
    <cfset variables.instance.PhotoFileID = trim(arguments.PhotoFileID) />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getPhotoFileID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.PhotoFileID />
  </cffunction>

  <cffunction name="setPhotoFileExt" output="false" access="public">
    <cfargument name="PhotoFileExt" type="string" required="true">
    <cfset variables.instance.PhotoFileExt = trim(arguments.PhotoFileExt) />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getPhotoFileExt" returnType="string" output="false" access="public">
    <cfreturn variables.instance.PhotoFileExt />
  </cffunction>

  <cffunction name="setFileID" output="false" access="public">
    <cfargument name="PhotoFileID" type="string" required="true">
    <cfset variables.instance.PhotoFileID = trim(arguments.PhotoFileID) />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getFileID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.PhotoFileID />
  </cffunction>

  <cffunction name="setFileExt" output="false" access="public">
    <cfargument name="PhotoFileExt" type="string" required="true">
    <cfset variables.instance.PhotoFileExt = trim(arguments.PhotoFileExt) />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getFileExt" returnType="string" output="false" access="public">
    <cfreturn variables.instance.PhotoFileExt />
  </cffunction>

 <cffunction name="setKeepPrivate" output="false" access="public">
    <cfargument name="KeepPrivate" type="any" required="true">
	<cfif isNumeric(arguments.keepPrivate)>
    		<cfset variables.instance.KeepPrivate = arguments.KeepPrivate />
	</cfif>
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getKeepPrivate" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.KeepPrivate />
  </cffunction>

  <cffunction name="setIMName" output="false" access="public">
    <cfargument name="IMName" type="string" required="true">
    <cfset variables.instance.IMName = trim(arguments.IMName) />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getIMName" returnType="string" output="false" access="public">
    <cfreturn variables.instance.IMName />
  </cffunction>

  <cffunction name="setIMService" output="false" access="public">
    <cfargument name="IMService" type="string" required="true">
    <cfset variables.instance.IMService = trim(arguments.IMService) />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getIMService" returnType="string" output="false" access="public">
    <cfreturn variables.instance.IMService />
  </cffunction>
  
  <cffunction name="setPasswordCreated" output="false" access="public">
    <cfargument name="PasswordCreated" type="string" required="true">
	<cfif isDate(arguments.PasswordCreated)>
    	<cfset variables.instance.PasswordCreated = parseDateTime(arguments.PasswordCreated) />
	</cfif>
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getPasswordCreated" returnType="string" output="false" access="public">
    <cfreturn variables.instance.PasswordCreated />
  </cffunction>


 <cffunction name="getExtendedData" returntype="any" output="false" access="public">
	<cfif not isObject(variables.instance.extendData)>
	<cfset variables.instance.extendData=variables.configBean.getClassExtensionManager().getExtendedData(baseID:getUserID(), dataTable:'tclassextenddatauseractivity', type:getType(), subType:getSubType(), siteID:getSiteID())/>
	</cfif> 
	<cfreturn variables.instance.extendData />
 </cffunction>

<cffunction name="getExtendedAttribute" returnType="string" output="false" access="public">
 <cfargument name="key" type="string" required="true">
 <cfargument name="useMuraDefault" type="boolean" required="true" default="false"> 
	
  	<cfreturn getExtendedData().getAttribute(arguments.key,arguments.useMuraDefault) />
</cffunction>

 <cffunction name="purgeExtendedData" output="false" access="public">
	<cfset variables.instance.extendData=""/>
	<cfreturn this>
 </cffunction>

 <cffunction name="setTags" output="false" access="public">
    <cfargument name="tags" type="string" required="true">
    <cfset variables.instance.tags = trim(arguments.tags) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getTags" returnType="string" output="false" access="public">
    <cfreturn variables.instance.tags />
  </cffunction>

 <cffunction name="setTabList" output="false" access="public">
    <cfargument name="tablist" type="string" required="true">
    <cfset variables.instance.tablist = trim(arguments.tablist) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getTabList" returnType="string" output="false" access="public">
    <cfreturn variables.instance.tablist />
  </cffunction> 

 <cffunction name="setHkey" output="false" access="public">
    <cfargument name="hkey" type="string" required="true">
    <cfset variables.instance.hkey = trim(arguments.hkey) />
	<cfreturn this>
  </cffunction>

 <cffunction name="setUkey" output="false" access="public">
    <cfargument name="Ukey" type="string" required="true">
    <cfset variables.instance.Ukey = trim(arguments.Ukey) />
	<cfreturn this>
  </cffunction>

 <cffunction name="setPassedProtect" output="false" access="public">
    <cfargument name="passedProtect" required="true">
	<cfif isBoolean(arguments.passedProtect)>
    	<cfset variables.instance.passedProtect = arguments.passedProtect />
	</cfif>
	<cfreturn this>
  </cffunction>

<cffunction name="setNewFile" output="false" access="public">
    <cfargument name="newFile" required="true">
	<cfset variables.instance.newFile = arguments.newFile />
	<cfreturn this>
</cffunction>
  
<cffunction name="getNewFile" returnType="any" output="false" access="public">
	<cfreturn variables.instance.newFile />
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
	<cfreturn this>
</cffunction>

<cffunction name="getValue" returntype="any" access="public" output="false">
	<cfargument name="property"  type="string" required="true">
	<cfif len(arguments.property)>
		<cfif isdefined("this.get#property#")>
			<cfreturn evaluate("get#property#()") />
		<cfelseif isdefined("variables.instance.#arguments.property#")>
			<cfreturn variables.instance["#arguments.property#"] />
		<cfelse>
			<cfreturn getExtendedAttribute(arguments.property) />
		</cfif>
	<cfelse>
		<cfreturn "">
	</cfif>
</cffunction>

<cffunction name="setAllValues" returntype="any" access="public" output="false">
	<cfargument name="instance">
	<cfset variables.instance=arguments.instance/>
	<cfreturn this>
</cffunction>

<cffunction name="save" output="false" access="public">
	<cfset var i="">
	<cfset var address="">
	<cfset setAllValues(variables.userManager.save(this).getAllValues())>
	
	<cfif arrayLen(variables.newAddresses)>
		<cfloop from="1" to="#arrayLen(variables.newAddresses)#" index="i">
			<cfset address=variables.newAddresses[i]>
			<cfset address.save()>
		</cfloop>
	</cfif>
	
	<cfset variables.newAddresses=arrayNew(1)>
	<cfreturn this>
</cffunction>

<cffunction name="delete" output="false" access="public">
	<cfset variables.userManager.delete(getUserID(),getType())>
</cffunction>

<cffunction name="getMembersQuery" returnType="query" output="false" access="public">
   <cfreturn variables.userManager.readGroupMemberships(getUserID()) />
</cffunction>

<cffunction name="getMembersIterator" returnType="any" output="false" access="public">
   	<cfset var it=getServiceFactory().getBean("userIterator").init()>
	<cfset it.setQuery(getMembersQuery())>
	<cfreturn it />
</cffunction>

<cffunction name="getMembershipsQuery" returnType="query" output="false" access="public">
   <cfreturn variables.userManager.readMemberships(getUserID()) />
</cffunction>

<cffunction name="getMembershipsIterator" returnType="any" output="false" access="public">
   	<cfset var it=getServiceFactory().getBean("userIterator").init()>
	<cfset it.setQuery(getMembershipsQuery())>
	<cfreturn it />
</cffunction>

<cffunction name="getInterestGroupsQuery" returnType="query" output="false" access="public">
   <cfreturn variables.userManager.readInterestGroups(getUserID()) />
</cffunction>

<cffunction name="getInterestGroupsIterator" returnType="any" output="false" access="public">
   	<cfset var it=getServiceFactory().getBean("categoryIterator").init()>
	<cfset it.setQuery(getInterestGroupsQuery())>
	<cfreturn it />
</cffunction>

<cffunction name="setIsNew" output="false" access="public">
    <cfargument name="IsNew" type="numeric" required="true">
    <cfset variables.instance.IsNew = arguments.IsNew />
	<cfreturn this>
</cffunction>

<cffunction name="getIsNew" returnType="numeric" output="false" access="public">
   <cfreturn variables.instance.IsNew />
</cffunction>

<cffunction name="loadBy" returnType="any" output="false" access="public">
	<cfset var response="">
	
	<cfif not structKeyExists(arguments,"siteID")>
		<cfset arguments.siteID=getSiteID()>
	</cfif>
	<cfif not structKeyExists(arguments,"isPublic")>
		<cfset arguments.isPublic="both">
	</cfif>
	
	<cfset response=variables.userManager.read(argumentCollection=arguments)>

	<cfif isArray(response)>
		<cfset setAllValues(response[1].getAllValues())>
		<cfreturn response>
	<cfelse>
		<cfset setAllValues(response.getAllValues())>
		<cfreturn this>
	</cfif>
</cffunction>

<cffunction name="addAddress" output="false" >
	<cfargument name="address" hint="Instance of a addressBean">
	<cfset arguments.address.setSiteID(getSiteID())>
	<cfset arguments.address.setUserID(getUserID())>
	<cfset arrayAppend(variables.newAddresses,arguments.address)>
	<cfreturn this>	
</cffunction>

<cffunction name="getContentTabAssignments" output="false" >
	<cfset var it=getMemberShipsIterator()>
	<cfset var item="">
	<cfset var userlist="">
	<cfset var itemlist="">
	<cfset var i="">
	
	<cfif it.getRecordcount()>
		<cfloop condition="it.hasNext()">
			<cfset item=it.next()>
			<cfset itemlist=item.getTablist()>
			<cfif len(itemlist)>
				<cfloop list="#itemlist#" index="i">
					<cfif not listFindNoCase(userlist,i)>
						<cfset userlist=listAppend(userlist,i)>
					</cfif>
				</cfloop>
			<cfelse>
				<cfreturn "Basic,Meta Data,Content Objects,Categorization,Related Content,Extended Attributes,Advanced,Usage Report"> 
			</cfif>
		</cfloop>
	</cfif>
	
	<cfreturn userlist>
</cffunction>

<cffunction name="readAddress" returntype="any" output="false">
	<cfargument name="name" default="">
	<cfargument name="addressID" default="">
	<cfset var addressFound=false/>
	<cfset var addressIterator=""/>
	<cfset var address=""/>
	
	<cfif len(arguments.name) or len(arguments.addressID)>
		<cfset addressIterator=getAddressesIterator()>
		
		<cfloop condition="addressIterator.hasNext() and not addressFound">
			<cfset address=addressIterator.next()>
		
			<cfif len(arguments.name) and address.getAddressName() eq arguments.name>
				<cfset addressFound = true/>
			</cfif>
			<cfif len(arguments.addressID) and address.getAddressID() eq arguments.addressID>
				<cfset addressFound = true/>
			</cfif>
			
		</cfloop>
	</cfif>
	
	<cfif not addressFound>
		<cfset address=getBean("address")>
		<cfif len(arguments.name)>
			<cfset address.setAddressName(arguments.name)>
		</cfif>
		<cfset address.setUserID(getUserID())>
		<cfset address.setSiteID(getSiteID())>
	</cfif>
	
	<cfreturn address>
</cffunction>

<cffunction name="isInGroup" access="public" returntype="any" output="false">
	<cfargument name="group">
	<cfargument name="isPublic" hint="optional">
	
	<cfset var rsMemberships=getMembershipsQuery()>
	
	<cfquery name="rsMemberships" dbtype="query">
      SELECT
            userID
      FROM
            rsMemberships
      WHERE
            groupname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.group#">
		<cfif structKeyExists(arguments,"isPublic")>
			and isPublic=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.isPublic#">
		</cfif>
	</cfquery>
	
	<cfreturn rsMemberships.recordcount>
	
</cffunction>

<cffunction name="clone" output="false">
	<cfreturn getBean("user").setAllValues(structCopy(getAllValues()))>
</cffunction>
</cfcomponent>