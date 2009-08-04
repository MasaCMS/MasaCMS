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
	<cfset variables.instance.LastUpdateBy = "" />
	<cfset variables.instance.LastUpdateByID = "" />
	<cfset variables.instance.perm=0 />
	<cfset variables.instance.inactive=0 />
	<cfset variables.instance.ispublic=0 />
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
	<cfset variables.instance.keepPrivate=0 />
	<cfset variables.instance.IMName="" />
	<cfset variables.instance.IMService="" />
	<cfset variables.instance.tags="" />
	<cfset variables.instance.hKey="" />
	<cfset variables.instance.uKey="" />
	<cfset variables.instance.extendData="" />
	<cfset variables.instance.extendSetID="" />
    <cfset variables.instance.errors=structnew() />
	
	<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="configBean" type="any" required="yes"/>
	<cfargument name="settingsManager" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.settingsManager=arguments.settingsManager />
	<cfreturn this />
	</cffunction>

 <cffunction name="set" returnType="void" output="false" access="public">
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
			<cfset setLastUpdateBy(arguments.user.LastUpdateBy) />
			<cfset setLastUpdateByID(arguments.user.LastUpdateByID) />
			<cfset setPerm(arguments.user.Perm) />
			<cfset setInActive(arguments.user.InActive) />
			<cfset setIsPublic(arguments.user.IsPublic) />
			<cfset setSubscribe(arguments.user.Subscribe) />
			<cfset setDescription(arguments.user.description) />
			<cfset setInterests(arguments.user.Interests) />
			<cfset setPhotoFileID(arguments.user.photoFileID) />
			<cfset setKeepPrivate(arguments.user.keepPrivate) />
			<cfset setIMName(arguments.user.IMName) />
			<cfset setIMService(arguments.user.IMService) />
			<cfset setTags(arguments.user.tags) />
			
			<cfset setNotes(arguments.user.Notes) />
			
		<cfelseif isStruct(arguments.user)>
		
			<cfloop collection="#arguments.user#" item="prop">
				<cfif prop neq 'siteID' and structKeyExists(this,"set#prop#")>
					<cfset evaluate("set#prop#(arguments.user[prop])") />
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
		
  </cffunction>

  <cffunction name="getAllValues" access="public" returntype="struct" output="false">
		<cfreturn variables.instance />
  </cffunction>
	
 <cffunction name="setUserID" returnType="void" output="false" access="public">
    <cfargument name="UserID" type="string" required="true">
    <cfset variables.instance.UserID = trim(arguments.UserID) />
  </cffunction>

  <cffunction name="getUserID" returnType="string" output="false" access="public">
    <cfif not len(variables.instance.UserID)>
		<cfset variables.instance.UserID = createUUID() />
	</cfif>
	<cfreturn variables.instance.UserID />
  </cffunction>
  
  <cffunction name="setRemoteID" returnType="void" output="false" access="public">
    <cfargument name="RemoteID" type="string" required="true">
    <cfset variables.instance.RemoteID = arguments.RemoteID />
  </cffunction>
  
  <cffunction name="getRemoteID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.RemoteID />
  </cffunction>

 <cffunction name="setGroupName" returnType="void" output="false" access="public">
    <cfargument name="GroupName" type="string" required="true">
    <cfset variables.instance.GroupName = trim(arguments.GroupName) />
  </cffunction>

  <cffunction name="getGroupName" returnType="string" output="false" access="public">
    <cfreturn variables.instance.GroupName />
  </cffunction>

 <cffunction name="setFname" returnType="void" output="false" access="public">
    <cfargument name="Fname" type="string" required="true">
    <cfset variables.instance.Fname = trim(arguments.Fname) />
  </cffunction>

  <cffunction name="getFname" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Fname />
  </cffunction>
  
 <cffunction name="setLname" returnType="void" output="false" access="public">
    <cfargument name="Lname" type="string" required="true">
    <cfset variables.instance.Lname = trim(arguments.Lname) />
  </cffunction>

  <cffunction name="getLname" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Lname />
  </cffunction>

 <cffunction name="setUsername" returnType="void" output="false" access="public">
    <cfargument name="Username" type="string" required="true">
    <cfset variables.instance.Username = trim(arguments.Username) />
  </cffunction>
  
   <cffunction name="setUsernameNoCache" returnType="void" output="false" access="public">
    <cfargument name="Username" type="string" required="true">
    <cfset variables.instance.Username = trim(arguments.Username) />
  </cffunction>

  <cffunction name="getUsername" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Username />
  </cffunction>
  
 <cffunction name="setPassword" returnType="void" output="false" access="public">
    <cfargument name="Password" type="string" required="true">
    <cfset variables.instance.Password = trim(arguments.Password) />
  </cffunction>
  
   <cffunction name="setPasswordNoCache" returnType="void" output="false" access="public">
    <cfargument name="Password" type="string" required="true">
    <cfset variables.instance.Password = trim(arguments.Password) />
  </cffunction>

  <cffunction name="getPassword" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Password />
  </cffunction>
  
 <cffunction name="setEmail" returnType="void" output="false" access="public">
    <cfargument name="Email" type="string" required="true">
    <cfset variables.instance.Email = trim(arguments.Email) />
  </cffunction>

  <cffunction name="getEmail" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Email />
  </cffunction>

 <cffunction name="setMobilePhone" returnType="void" output="false" access="public">
    <cfargument name="MobilePhone" type="string" required="true">
    <cfset variables.instance.MobilePhone = trim(arguments.MobilePhone) />
  </cffunction>

  <cffunction name="getMobilePhone" returnType="string" output="false" access="public">
    <cfreturn variables.instance.MobilePhone />
  </cffunction>
  
 <cffunction name="setCompany" returnType="void" output="false" access="public">
    <cfargument name="Company" type="string" required="true">
    <cfset variables.instance.Company = trim(arguments.Company) />
  </cffunction>

  <cffunction name="getCompany" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Company />
  </cffunction>
  
 <cffunction name="setJobTitle" returnType="void" output="false" access="public">
    <cfargument name="JobTitle" type="string" required="true">
    <cfset variables.instance.JobTitle = trim(arguments.JobTitle) />
  </cffunction>


  <cffunction name="getJobTitle" returnType="string" output="false" access="public">
    <cfreturn variables.instance.JobTitle />
  </cffunction>

 <cffunction name="setWebsite" returnType="void" output="false" access="public">
    <cfargument name="Website" type="string" required="true">
    <cfset variables.instance.Website = trim(arguments.Website) />
  </cffunction>
  
  <cffunction name="getWebsite" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Website />
  </cffunction>
  
 <cffunction name="setType" returnType="void" output="false" access="public">
    <cfargument name="Type" type="numeric" required="true">
    <cfset variables.instance.Type = arguments.Type />
  </cffunction>
  
  <cffunction name="getType" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.Type />
  </cffunction>
 
  <cffunction name="setSubType" returnType="void" output="false" access="public">
    <cfargument name="SubType" type="string" required="true">
    <cfset variables.instance.SubType = trim(arguments.SubType) />
  </cffunction>

  <cffunction name="getSubType" returnType="string" output="false" access="public">
    <cfreturn variables.instance.SubType />
  </cffunction>
   
 <cffunction name="setContactForm" returnType="void" output="false" access="public">
    <cfargument name="ContactForm" type="string" required="true">
    <cfset variables.instance.ContactForm = arguments.ContactForm />
  </cffunction>
  
  <cffunction name="getContactForm" returnType="string" output="false" access="public">
    <cfreturn variables.instance.ContactForm />
  </cffunction>
  
 <cffunction name="setS2" returnType="void" output="false" access="public">
    <cfargument name="S2" type="numeric" required="true">
    <cfset variables.instance.S2 = arguments.S2 />
  </cffunction>
  
  <cffunction name="getS2" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.S2 />
  </cffunction>
  
 <cffunction name="setLastLogin" returnType="void" output="false" access="public">
    <cfargument name="LastLogin" type="String" required="true">
	<cfif isDate(arguments.LastLogin)>
    <cfset variables.instance.LastLogin = parseDateTime(arguments.LastLogin) />
	</cfif>
  </cffunction>
  
  <cffunction name="getLastLogin" returnType="String" output="false" access="public">
    <cfreturn variables.instance.LastLogin />
  </cffunction>
  
  <cffunction name="setLastUpdateBy" returnType="void" output="false" access="public">
    <cfargument name="LastUpdateBy" type="string" required="true">
    <cfset variables.instance.LastUpdateBy = left(trim(arguments.LastUpdateBy),50) />
  </cffunction>

  <cffunction name="getLastUpdateBy" returnType="string" output="false" access="public">
    <cfreturn variables.instance.LastUpdateBy />
  </cffunction>
  
  <cffunction name="setLastUpdateByID" returnType="void" output="false" access="public">
    <cfargument name="LastUpdateByID" type="string" required="true">
    <cfset variables.instance.LastUpdateByID = trim(arguments.LastUpdateByID) />
  </cffunction>

  <cffunction name="getLastUpdateByID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.LastUpdateByID />
  </cffunction>
  
 <cffunction name="setPerm" returnType="void" output="false" access="public">
    <cfargument name="Perm" type="numeric" required="true">
    <cfset variables.instance.Perm = arguments.Perm />
  </cffunction>
  
  <cffunction name="getPerm" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.Perm />
  </cffunction>
  
 <cffunction name="setInActive" returnType="void" output="false" access="public">
    <cfargument name="InActive" type="numeric" required="true">
    <cfset variables.instance.InActive = arguments.InActive />
  </cffunction>
  
  <cffunction name="getInActive" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.InActive />
  </cffunction>
  
 <cffunction name="setIsPublic" returnType="void" output="false" access="public">
    <cfargument name="IsPublic" type="numeric" required="true">
    <cfset variables.instance.IsPublic = arguments.IsPublic />
  </cffunction>
  
  <cffunction name="getIsPublic" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.IsPublic />
  </cffunction>
  
 <cffunction name="setSubscribe" returnType="void" output="false" access="public">
    <cfargument name="Subscribe" type="numeric" required="true">
    <cfset variables.instance.Subscribe = arguments.Subscribe />
  </cffunction>
  
  <cffunction name="getSubscribe" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.Subscribe />
  </cffunction>
  
  <cffunction name="setSiteID" returnType="void" output="false" access="public">
    <cfargument name="SiteID" type="string" required="true">
    <cfset variables.instance.SiteID = trim(arguments.SiteID) />
  </cffunction>

  <cffunction name="getSiteID" returnType="string" output="false" access="public">
	<cfreturn variables.instance.SiteID />
  </cffunction>
  
  <cffunction name="setNotes" returnType="void" output="false" access="public">
    <cfargument name="Notes" type="string" required="true">
    <cfset variables.instance.Notes = trim(arguments.Notes) />
  </cffunction>

  <cffunction name="getNotes" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Notes />
  </cffunction>
  
  <cffunction name="setGroupid" returnType="void" output="false" access="public">
    <cfargument name="Groupid" type="string" required="true">
    <cfset variables.instance.Groupid = trim(arguments.Groupid) />
  </cffunction>
  
  <cffunction name="getGroupid" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Groupid />
  </cffunction>

  <cffunction name="setPrimaryAddressID" returnType="void" output="false" access="public">
    <cfargument name="PrimaryAddressID" type="string" required="true">
    <cfset variables.instance.PrimaryAddressID = trim(arguments.PrimaryAddressID) />
  </cffunction>
  
  <cffunction name="getPrimaryAddressID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.PrimaryAddressID />
  </cffunction>

  <cffunction name="setAddressID" returnType="void" output="false" access="public">
    <cfargument name="AddressID" type="string" required="true">
    <cfset variables.instance.AddressID = trim(arguments.AddressID) />
  </cffunction>
  
  <cffunction name="getAddressID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.AddressID />
  </cffunction>
  
   <cffunction name="setCategoryID" returnType="void" output="false" access="public">
    <cfargument name="CategoryID" type="string" required="true">
    <cfset variables.instance.CategoryID = trim(arguments.CategoryID) />
  </cffunction>
  
  <cffunction name="getCategoryID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.CategoryID />
  </cffunction>

 <cffunction name="setAddresses" returnType="void" output="false" access="public">
    <cfargument name="addresses" type="query" required="true">
    <cfset variables.instance.addresses = arguments.addresses />
  </cffunction>
  
  <cffunction name="getAddresses" returnType="query" output="false" access="public">
    <cfreturn variables.instance.Addresses />
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
   

<cffunction name="validate" access="public" output="false" returntype="void">
		<cfset variables.instance.errors=structnew() />
		
		<cfif trim(variables.instance.siteid) neq "">
		
			<cfif variables.instance.type eq 2 and (variables.instance.username eq "" or not checkUsername())>
			<cfset variables.instance.errors.username=variables.settingsManager.getSite(getSiteID()).getRBFactory().getResourceBundle().messageFormat( variables.settingsManager.getSite(getSiteID()).getRBFactory().getKey("user.usernamevalidate") , getusername() ) />
			</cfif>
			
			<cfif variables.instance.type eq 2 and variables.instance.email eq "" >
			<cfset variables.instance.errors.username=variables.settingsManager.getSite(getSiteID()).getRBFactory().getKey("user.emailrequired") />
			</cfif>
			
			<!--- If captcha data has been submitted validate it --->
			<cfif not (not len(variables.instance.hKey) or variables.instance.hKey eq hash(variables.instance.uKey))>
			<cfset variables.instance.errors.SecurityCode=variables.settingsManager.getSite(getSiteID()).getRBFactory().getKey("captcha.error")/>
			</cfif>
		
		<cfelse>
			<cfset variables.instance.errors.siteid="The 'SiteID' variable is missing." />
		</cfif>
		
	</cffunction>
 

  <cffunction name="getAddressByID" returnType="query" output="false" access="public">
	<cfargument name="addressID" type="string" required="true">
	
	<cfset var rs="" />
	
	<cfquery name="rs" dbtype="query">
	select * from variables.instance.addresses where addressID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.addressID#">  
	</cfquery>
	
	<cfreturn rs />
  </cffunction>

  <cffunction name="getAddressBeanByID" returnType="any" output="false" access="public">
	<cfargument name="addressID" type="string" required="true">
	
	<cfset var rs="" />
	<cfset var addressBean=application.serviceFactory.getBean("addressBean") />
	
	<cfquery name="rs" dbtype="query">
	select * from variables.instance.addresses where addressID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.addressID#">  
	</cfquery>
	
	<cfset addressBean.set(rs)>
	<cfset addressBean.setUserID(getUserID())>
	<cfset addressBean.setSiteID(getSiteID())>
	<cfreturn addressBean />
  </cffunction>

  <cffunction name="setDescription" returnType="void" output="false" access="public">
    <cfargument name="Description" type="string" required="true">
    <cfset variables.instance.Description = trim(arguments.Description) />
  </cffunction>
  
  <cffunction name="getDescription" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Description />
  </cffunction>

  <cffunction name="setInterests" returnType="void" output="false" access="public">
    <cfargument name="Interests" type="string" required="true">
    <cfset variables.instance.Interests = trim(arguments.Interests) />
  </cffunction>
  
  <cffunction name="getInterests" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Interests />
  </cffunction>

  <cffunction name="setPhotoFileID" returnType="void" output="false" access="public">
    <cfargument name="PhotoFileID" type="string" required="true">
    <cfset variables.instance.PhotoFileID = trim(arguments.PhotoFileID) />
  </cffunction>
  
  <cffunction name="getPhotoFileID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.PhotoFileID />
  </cffunction>

 <cffunction name="setKeepPrivate" returnType="void" output="false" access="public">
    <cfargument name="KeepPrivate" type="any" required="true">
	<cfif isNumeric(arguments.keepPrivate)>
    		<cfset variables.instance.KeepPrivate = arguments.KeepPrivate />
	</cfif>
  </cffunction>
  
  <cffunction name="getKeepPrivate" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.KeepPrivate />
  </cffunction>

  <cffunction name="setIMName" returnType="void" output="false" access="public">
    <cfargument name="IMName" type="string" required="true">
    <cfset variables.instance.IMName = trim(arguments.IMName) />
  </cffunction>
  
  <cffunction name="getIMName" returnType="string" output="false" access="public">
    <cfreturn variables.instance.IMName />
  </cffunction>

  <cffunction name="setIMService" returnType="void" output="false" access="public">
    <cfargument name="IMService" type="string" required="true">
    <cfset variables.instance.IMService = trim(arguments.IMService) />
  </cffunction>
  
  <cffunction name="getIMService" returnType="string" output="false" access="public">
    <cfreturn variables.instance.IMService />
  </cffunction>
  
  <cffunction name="setPasswordCreated" returnType="void" output="false" access="public">
    <cfargument name="PasswordCreated" type="string" required="true">
	<cfif isDate(arguments.PasswordCreated)>
    	<cfset variables.instance.PasswordCreated = parseDateTime(arguments.PasswordCreated) />
	</cfif>
  </cffunction>
  
  <cffunction name="getPasswordCreated" returnType="string" output="false" access="public">
    <cfreturn variables.instance.PasswordCreated />
  </cffunction>


 <cffunction name="getExtendedData" returntype="any" output="false" access="public">
	<cfif not isObject(variables.instance.extendData)>
	<cfset variables.instance.extendData=variables.configBean.getClassExtensionManager().getExtendedData(getUserID(),'tclassextenddatauseractivity')/>
	</cfif> 
	<cfreturn variables.instance.extendData />
 </cffunction>

<cffunction name="getExtendedAttribute" returnType="string" output="false" access="public">
 <cfargument name="key" type="string" required="true">
 <cfargument name="useMuraDefault" type="boolean" required="true" default="false"> 
	
  	<cfreturn getExtendedData().getAttribute(arguments.key,arguments.useMuraDefault) />
</cffunction>

 <cffunction name="setTags" returnType="void" output="false" access="public">
    <cfargument name="tags" type="string" required="true">
    <cfset variables.instance.tags = trim(arguments.tags) />
  </cffunction>

  <cffunction name="getTags" returnType="string" output="false" access="public">
    <cfreturn variables.instance.tags />
  </cffunction>

 <cffunction name="setHkey" returnType="void" output="false" access="public">
    <cfargument name="hkey" type="string" required="true">
    <cfset variables.instance.hkey = trim(arguments.hkey) />
  </cffunction>

 <cffunction name="setUkey" returnType="void" output="false" access="public">
    <cfargument name="Ukey" type="string" required="true">
    <cfset variables.instance.Ukey = trim(arguments.Ukey) />
  </cffunction>

<cffunction name="setValue" returntype="any" access="public" output="false">
	<cfargument name="property"  type="string" required="true">
	<cfargument name="propertyValue" default="" >
	
	<cfset var extData =structNew() />
	<cfset var i = "">	
	
	<cfif structKeyExists(this,"set#property#")>
		<cfset evaluate("set#property#(arguments.propertyValue") />
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
		<cfreturn evaluate("get#property#(arguments.propertyValue") />
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

</cfcomponent>