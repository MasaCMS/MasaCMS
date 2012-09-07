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

<cfset variables.fieldList="tusers.userID, tusers.GroupName, tusers.Fname, tusers.Lname, tusers.UserName,tusers.PasswordCreated, tusers.Email, tusers.Company, tusers.JobTitle, tusers.MobilePhone, tusers.Website, tusers.Type, tusers.subType, tusers.ContactForm, tusers.S2, tusers.LastLogin, tusers.LastUpdate, tusers.LastUpdateBy, tusers.LastUpdateByID, tusers.Perm, tusers.InActive, tusers.IsPublic, tusers.SiteID, tusers.Subscribe, tusers.Notes, tusers.description, tusers.Interests, tusers.keepPrivate, tusers.PhotoFileID, tusers.IMName, tusers.IMService, tusers.Created, tusers.RemoteID, tusers.Tags, tusers.tablist, tfiles.fileEXT photoFileExt">

<cffunction name="init" returntype="any" output="false" access="public">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>

		<cfset variables.configBean=arguments.configBean />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.utility=arguments.utility />
		
<cfreturn this />
</cffunction>

<cffunction name="read" access="public" returntype="any" output="false">
		<cfargument name="userid" type="string" required="yes" />
		<cfargument name="userBean" type="any" default=""/>
		<cfset var rsuser = 0 />
		<cfset var rsmembs = "" />
		<cfset var rsInterests = "" />
		<cfset var bean=arguments.userBean/>

		<cfif not isObject(bean)>
			<cfset bean=getBean("user")>	
		</cfif>
		
		<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#" name="rsUser">
			select #variables.fieldList#
			from tusers 
			left join tfiles on tusers.photoFileId=tfiles.fileid
			where tusers.userid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
		</cfquery>
	
		<cfif rsUser.recordCount eq 1>
			<cfset bean.set(rsUser) />
			<cfset setUserBeanMetaData(bean)>
			<cfset bean.setIsNew(0)>
		<cfelse>
			<cfset bean.setIsNew(1)>
		</cfif>
		
		<cfreturn bean />
</cffunction>

<cffunction name="readByUsername" access="public" returntype="any" output="false">
		<cfargument name="username" type="string" required="yes" />
		<cfargument name="siteid" type="string" required="yes" />
		<cfargument name="userBean" type="any" default=""/>
		<cfset var rsuser = 0 />
		<cfset var rsmembs = "" />
		<cfset var rsInterests = "" />
		<cfset var beanArray=arrayNew(1)>
		<cfset var utility="">
		<cfset var bean=arguments.userBean/>

		<cfif not isObject(bean)>
			<cfset bean=getBean("user")>	
		</cfif>
			
		<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#" name="rsUser">
			select #variables.fieldList#
			from tusers 
			left join tfiles on tusers.photoFileId=tfiles.fileid
			where tusers.username=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
			and (tusers.siteid='#application.settingsManager.getSite(arguments.siteID).getPublicUserPoolID()#'
				or  
				tusers.siteid='#application.settingsManager.getSite(arguments.siteID).getPrivateUserPoolID()#'
				) 
		</cfquery>
		
		<cfif rsUser.recordcount gt 1>
			<cfset utility=getBean("utility")>
			<cfloop query="rsUser">
				<cfset bean=getBean("user").set(utility.queryRowToStruct(rsUser,rsUser.currentrow))>
				<cfset bean.setIsNew(0)>
				<cfset rsmembs=readMembershipIDs(bean.getUserId()) />
				<cfset rsInterests=readInterestGroupIDs(bean.getUserId()) />
				<cfset bean.setGroupId(valuelist(rsmembs.groupid))/>
				<cfset bean.setCategoryId(valuelist(rsInterests.categoryid))/>
				<!---<cfset userBean.setAddresses(getAddresses(userBean.getUserID()))/>--->	
				<cfset arrayAppend(beanArray,bean)>	
			</cfloop>
			<cfreturn beanArray>
		<cfelseif rsUser.recordCount eq 1>
			<cfset bean.set(rsUser) />
			<cfset rsmembs=readMembershipIDs(bean.getUserId()) />
			<cfset rsInterests=readInterestGroupIDs(bean.getUserId()) />
			<cfset bean.setGroupId(valuelist(rsmembs.groupid))/>
			<cfset bean.setCategoryId(valuelist(rsInterests.categoryid))/>
			<!--- <cfset userBean.setAddresses(getAddresses(userBean.getUserID()))/> --->
			<cfset bean.setIsNew(0)>
		<cfelse>
			<cfset bean.setIsNew(1)>
		</cfif>
		
		<cfreturn bean />
</cffunction>

<cffunction name="readByGroupName" access="public" returntype="any" output="false">
		<cfargument name="groupname" type="string" required="yes" />
		<cfargument name="siteid" type="string" required="yes" />
		<cfargument name="isPublic" type="string" required="yes" default="both"/>
		<cfargument name="userBean" type="any" default=""/>
		<cfset var rsuser = 0 />
		<cfset var rsmembs = "" />
		<cfset var rsInterests = "" />
		<cfset var beanArray=arrayNew(1)>
		<cfset var utility="">
		<cfset var bean=arguments.userBean/>

		<cfif not isObject(bean)>
			<cfset bean=getBean("user")>	
		</cfif>
		
		<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#" name="rsUser">
			select #variables.fieldList#
			from tusers 
			left join tfiles on tusers.photoFileId=tfiles.fileid
			where 
			tusers.type=1
			and tusers.groupname=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupname#">
			and 
			<cfif not isBoolean(arguments.isPublic)>
				(tusers.siteid='#application.settingsManager.getSite(arguments.siteID).getPublicUserPoolID()#'
				or  
				tusers.siteid='#application.settingsManager.getSite(arguments.siteID).getPrivateUserPoolID()#'
				) 
			<cfelseif arguments.isPublic>
			(tusers.siteid='#application.settingsManager.getSite(arguments.siteID).getPublicUserPoolID()#'
				and
			tusers.isPublic=1
			) 
			<cfelse>
			(tusers.siteid='#application.settingsManager.getSite(arguments.siteID).getPrivateUserPoolID()#'
				and 
			tusers.isPublic=0
			) 
			</cfif>
		</cfquery>
		
		<cfif rsUser.recordcount gt 1>
			<cfset utility=getBean("utility")>
			<cfloop query="rsUser">
				<cfset bean=getBean("user").set(utility.queryRowToStruct(rsUser,rsUser.currentrow))>
				<cfset bean.setIsNew(0)>
				<cfset rsmembs=readMembershipIDs(bean.getUserId()) />
				<cfset rsInterests=readInterestGroupIDs(bean.getUserId()) />
				<cfset bean.setGroupId(valuelist(rsmembs.groupid))/>
				<cfset bean.setCategoryId(valuelist(rsInterests.categoryid))/>
				<!--- <cfset userBean.setAddresses(getAddresses(userBean.getUserID()))/> --->
				<cfset arrayAppend(beanArray,bean)>		
			</cfloop>
			<cfreturn beanArray>
		<cfelseif rsUser.recordCount eq 1>
			<cfset bean.set(rsUser) />
			<cfset rsmembs=readMembershipIDs(bean.getUserId()) />
			<cfset rsInterests=readInterestGroupIDs(bean.getUserId()) />
			<cfset bean.setGroupId(valuelist(rsmembs.groupid))/>
			<cfset bean.setCategoryId(valuelist(rsInterests.categoryid))/>
			<!--- <cfset userBean.setAddresses(getAddresses(bean.getUserID()))/> --->
			<cfset bean.setIsNew(0)>
		<cfelse>
			<cfset bean.setIsNew(1)>
		</cfif>
		
		<cfreturn bean />
</cffunction>

<cffunction name="readByRemoteID" access="public" returntype="any" output="false">
		<cfargument name="remoteid" type="string" required="yes" />
		<cfargument name="siteid" type="string" required="yes" />
		<cfargument name="userBean" type="any" default=""/>
		<cfset var rsuser = 0 />
		<cfset var rsmembs = "" />
		<cfset var rsInterests = "" />
		<cfset var beanArray=arrayNew(1)>
		<cfset var utility="">
		<cfset var bean=arguments.userBean/>

		<cfif not isObject(bean)>
			<cfset bean=getBean("user")>	
		</cfif>
				
		<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#" name="rsUser">
			select #variables.fieldList#
			from tusers 
			left join tfiles on tusers.photoFileId=tfiles.fileid
			where tusers.remoteid=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.remoteid#">
			and (tusers.siteid='#application.settingsManager.getSite(arguments.siteID).getPublicUserPoolID()#'
				or  
				tusers.siteid='#application.settingsManager.getSite(arguments.siteID).getPrivateUserPoolID()#'
				) 
		</cfquery>
		
		<cfif rsUser.recordcount gt 1>
			<cfset utility=getBean("utility")>
			<cfloop query="rsUser">
				<cfset bean=getBean("user").set(utility.queryRowToStruct(rsUser,rsUser.currentrow))>
				<cfset bean.setIsNew(0)>
				<cfset rsmembs=readMembershipIDs(bean.getUserId()) />
				<cfset rsInterests=readInterestGroupIDs(bean.getUserId()) />
				<cfset bean.setGroupId(valuelist(rsmembs.groupid))/>
				<cfset bean.setCategoryId(valuelist(rsInterests.categoryid))/>
				<!--- <cfset userBean.setAddresses(getAddresses(bean.getUserID()))/>		 --->
				<cfset arrayAppend(beanArray,bean)>
			</cfloop>
			<cfreturn beanArray>
		<cfelseif rsUser.recordCount eq 1>
			<cfset bean.set(rsUser) />
			<cfset rsmembs=readMembershipIDs(bean.getUserId()) />
			<cfset rsInterests=readInterestGroupIDs(bean.getUserId()) />
			<cfset bean.setGroupId(valuelist(rsmembs.groupid))/>
			<cfset bean.setCategoryId(valuelist(rsInterests.categoryid))/>
			<!--- <cfset userBean.setAddresses(getAddresses(bean.getUserID()))/> --->
			<cfset bean.setIsNew(0)>
		<cfelse>
			<cfset bean.setIsNew(1)>
		</cfif>
		
		<cfreturn bean />
</cffunction>

<cffunction name="create" returntype="void" access="public" output="false">
<cfargument name="userBean" type="any" />

 <cfquery  datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
        INSERT INTO tusers  (UserID, RemoteID, s2, Fname, Lname, Password, PasswordCreated,
		Email, GroupName, Type, subType, ContactForm, LastUpdate, lastupdateby, lastupdatebyid,InActive, username,  perm, isPublic,
		company,jobtitle,subscribe,siteid,website,notes,mobilePhone,
		description,interests,photoFileID,keepPrivate,IMName,IMService,created,tags, tablist)
     VALUES(
         '#arguments.userBean.getuserid()#',
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getRemoteID() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getRemoteID()#">,
		 #arguments.userBean.gets2()#, 
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getFname() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getFname()#">,
		  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getLname() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getLname()#">, 
         <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getPassword() neq '',de('no'),de('yes'))#" value="#iif(variables.configBean.getEncryptPasswords(),de('#variables.utility.toBCryptHash(arguments.userBean.getPassword())#'),de('#arguments.userBean.getPassword()#'))#">,
		 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getEmail() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getEmail()#">,
         <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getGroupName() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getGroupName()#">, 
         #arguments.userBean.getType()#,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getSubType() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getSubType()#">, 
        <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.userBean.getContactForm() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getContactForm()#">,
		 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getLastUpdateBy()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getLastUpdateById() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getLastUpdateByID()#">,
		 #arguments.userBean.getInActive()#,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getUsername() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getUsername()#">,
		  #arguments.userBean.getperm()#,
		  #arguments.userBean.getispublic()#,
		   <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getCompany() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getCompany()#">,
		   <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getJobTitle() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getJobTitle()#">, 
		  #arguments.userBean.getsubscribe()#,
		   <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getSiteID() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getSiteID()#">,
		  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getWebsite() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getWebsite()#">,
		 <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.userBean.getNotes() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getNotes()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getMobilePhone() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getMobilePhone()#">,
		  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getDescription() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getDescription()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getInterests() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getInterests()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getPhotoFileID() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getPhotoFileID()#">,
		#arguments.userBean.getKeepPrivate()#,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getIMName() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getIMName()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getIMService() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getIMService()#">,
		 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getTags() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getTags()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getTablist() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getTablist()#">
		 )
		 
   </CFQUERY>
   
  <!---  <cfif arguments.userBean.getType() eq 2> --->
   <cfset createUserMemberships(arguments.userBean.getUserID(),arguments.userBean.getGroupID()) />
   <cfset clearBadMembeships(arguments.userBean) />
   <cfset createUserInterests(arguments.userBean.getUserID(),arguments.userBean.getCategoryID()) />
   <cfset createTags(arguments.userBean) />
  <!---  </cfif> --->

</cffunction>

<cffunction name="delete" access="public" output="false" returntype="void">
		<cfargument name="UserID" type="String" />
		<cfargument name="Type" type="String" />

		<cfset deleteExtendData(arguments.UserID) />
		<cfset deleteTags(arguments.UserID) />
		
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		DELETE FROM tusers where userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userid#">
		</cfquery>

</cffunction>

<cffunction name="deleteUserFavorites" returntype="void" output="false" access="public">
	<cfargument name="userid" type="string" />
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
		DELETE FROM tusersfavorites where userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userid#">
	</cfquery>

</cffunction>

<cffunction name="deleteExtendData" returntype="void" output="false" access="public">
	<cfargument name="userid" type="string" />
	
	<cfset variables.configBean.getClassExtensionManager().deleteExtendedData(arguments.userID,'tclassextenddatauseractivity')/>
</cffunction>

<cffunction name="deleteUserRatings" returntype="void" output="false" access="public">
	<cfargument name="userid" type="string" />
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
		DELETE FROM tcontentratings where userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userid#">
	</cfquery>

</cffunction>

<cffunction name="update" returntype="void" access="public" output="false">
	<cfargument name="userBean" type="any" />
	<cfargument name="updateGroups" type="boolean" default="true" required="yes" />
	<cfargument name="updateInterests" type="boolean" default="true" required="yes" />
	<cfargument name="OriginID" type="string" default="" required="yes" />

 	<cfquery  datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      UPDATE tusers SET
		 RemoteID =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getRemoteID() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getRemoteID()#">,
	  	 Fname =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getFname() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getFname()#">,
	  	 Lname =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getLname() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getLname()#">,
	  	 GroupName =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getGroupname() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getGroupname()#">,  
         Email =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getEmail() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getEmail()#">,
        <cfif arguments.userBean.getPassword() neq ''>
		 Password = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getPassword() neq '',de('no'),de('yes'))#" value="#iif(variables.configBean.getEncryptPasswords(),de('#variables.utility.toBCryptHash(arguments.userBean.getPassword())#'),de('#arguments.userBean.getPassword()#'))#">,
		 passwordCreated =<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		 </cfif>
		 s2 =#arguments.userBean.gets2()#,
         Type = #arguments.userBean.getType()#,
		 subType = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getSubType() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getSubType()#">, 
         ContactForm = <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.userBean.getContactForm() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getContactForm()#">,
		 LastUpdate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		 LastUpdateBy =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getLastUpdateBy()#">,
		 LastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getLastUpdateById() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getLastUpdateById()#">,
		<!---  phone1 =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getPhone1() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getPhone1()#">,
		 phone2 =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getPhone2() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getPhone2()#">, --->
		 InActive = #arguments.userBean.getInActive()#,
		 username = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getUsername() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getUsername()#">,
		 isPublic = #arguments.userBean.getispublic()#,
		<!---  address1 =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getAddress1() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getAddress1()#">,
		 address2 =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getAddress2() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getAddress2()#">,
		 city =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getCity() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getCity()#">,
		 state =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getState() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getState()#">,
		 zip =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getZip() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getZip()#">,
		 fax =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getFax() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getFax()#">, --->
		 company =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getCompany() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getCompany()#">,
		 jobtitle =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getJobTitle() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getJobTitle()#">,
		 website =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getWebsite() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getWebsite()#">,
		 notes =  <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.userBean.getNotes() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getNotes()#">,
		 subscribe=#arguments.userBean.getsubscribe()#,
		 siteid = '#trim(arguments.userBean.getSiteID())#',
		 MobilePhone = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getMobilePhone() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getMobilePhone()#">,
		 Description = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getDescription() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getDescription()#">,
		 Interests = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getInterests() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getInterests()#">,
		 PhotoFileID = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getPhotoFileID() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getPhotoFileID()#">,
		 keepPrivate = #arguments.userBean.getKeepPrivate()#,
		 IMName = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getIMName() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getIMName()#">,
		 IMService = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getIMService() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getIMService()#">,
		 Tags = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getTags() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getTags()#">,
		 TabList= <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getTablist() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getTablist()#">
		 
       WHERE UserID = '#arguments.userBean.getUserID()#'  
   </CFQUERY>


	<!--- <cfif arguments.userBean.gettype() EQ 2 > --->
		<cfif arguments.updateGroups>
		<cfset deleteUserMemberships(arguments.userBean.getUserID(),arguments.originID) />
		<cfset createUserMemberships(arguments.userBean.getUserID(),arguments.userBean.getGroupID()) />
		<cfset clearBadMembeships(arguments.userBean) />
		</cfif>
		
		<cfif arguments.updateInterests>
		<cfset deleteUserInterests(arguments.userBean.getUserID(),arguments.originID) />
		<cfset createUserInterests(arguments.userBean.getUserID(),arguments.userBean.getCategoryID()) />
		</cfif>
		
		<cfif arguments.userBean.getPrimaryAddressID() neq ''>
		<cfset setPrimaryAddress(arguments.userBean.getUserID(),arguments.userBean.getPrimaryAddressID()) />
		</cfif>
		
		<cfset deleteTags(arguments.userBean.getUserID()) />
		<cfset createTags(arguments.userBean) />
	<!--- </cfif> --->

</cffunction>

<cffunction name="deleteUserMemberships" returntype="void" output="false" access="public">
	<cfargument name="userid" type="string" />
	<cfargument name="originID" type="string" required="yes" default=""/>
	
	<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#" >
		DELETE FROM tusersmemb where UserID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userid#">
		<cfif arguments.originID neq "">
			and groupID in (select userID from tusers 
							where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.originID#">
							<!--- and type=1 --->)
		</cfif>
		</cfquery>

</cffunction>

<cffunction name="deleteGroupMemberships" returntype="void" output="false" access="public">
	<cfargument name="groupid" type="string" />
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
		DELETE FROM tusersmemb where groupID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupID#">
		</cfquery>

</cffunction>

<cffunction name="deleteGroupPermissions" returntype="void" output="false" access="public">
	<cfargument name="groupid" type="string" />
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
		DELETE FROM tpermissions where groupID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupID#">
		</cfquery>

</cffunction>

<cffunction name="deleteUserFromGroup" returntype="void" output="false" access="public">
	<cfargument name="userid" type="string" />
	<cfargument name="groupid" type="string" />
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tusersmemb where userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"> and groupid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupID#"> 
	</cfquery>

</cffunction>

<cffunction name="createUserInGroup" returntype="void" output="false" access="public">
	<cfargument name="userid" type="string" />
	<cfargument name="groupid" type="string" />
	<cfset var checkmemb=""/>
	
	<cfquery name="checkmemb" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select * from tusersmemb where groupid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupID#"> and userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
	
	</cfquery>
	
	<cfif not checkmemb.recordcount>
		<cfset createUserMemberships(arguments.UserID,arguments.groupid) />
	</cfif>

</cffunction>

<cffunction name="createUserMemberships" returntype="void" output="false" access="public">
	<cfargument name="userid" type="string" />
	<cfargument name="groupid" type="string" />
	<cfset var I=""/>
	
	<cfloop list="#arguments.groupid#" index="I">
			<cfif I neq "">
			<cftry>
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				INSERT INTO tusersmemb (UserID, GroupID)
					VALUES(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#I#">
					)
				</cfquery>
				<cfcatch></cfcatch>
				</cftry>
			</cfif>
	</cfloop>
		
</cffunction>

<cffunction name="deleteUserInterests" returntype="void" output="false" access="public">
	<cfargument name="userid" type="string" />
	<cfargument name="originID" type="string" required="yes" default="" />
	
	<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#" >
		DELETE FROM tusersinterests where UserID='#arguments.UserId#'
		<cfif arguments.originID neq "">
			and categoryID in (select categoryID from tcontentcategories where siteid='#arguments.originID#')
		</cfif>
	</cfquery>

</cffunction>

<cffunction name="createUserInterests" returntype="void" output="false" access="public">
	<cfargument name="userid" type="string" />
	<cfargument name="categoryid" type="string" />
	<cfset var I=""/>
	
	<cfloop list="#arguments.categoryid#" index="I">
			<cfif I neq "">
			<cftry>
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				INSERT INTO tusersinterests (UserID, categoryID)
					VALUES(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#I#">
					)
				</cfquery>
				<cfcatch></cfcatch>
				</cftry>
			</cfif>
	</cfloop>
		
</cffunction>

<cffunction name="readMemberships" returntype="query" output="false" access="public">
	<cfargument name="userid" type="string" />
	<cfset var rsMemberships =""/>
	
	<cfquery name="rsMemberships"  datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	Select tusers.userID AS groupID, #variables.fieldList# from tusers 
	inner join tusersmemb on tusers.userid=tusersmemb.groupid
	left join tfiles on tusers.photoFileId=tfiles.fileid
	where tusersmemb.userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
	order by tusers.groupname
	</cfquery>
	<cfreturn rsMemberships />
</cffunction>

<cffunction name="readMembershipIDs" returntype="query" output="false" access="public">
	<cfargument name="userid" type="string" />
	<cfset var rsMembershipIDs =""/>
	
	<cfquery name="rsMembershipIDs"  datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	Select tusers.userID AS groupID from tusers 
	inner join tusersmemb on tusers.userid=tusersmemb.groupid
	left join tfiles on tusers.photoFileId=tfiles.fileid
	where tusersmemb.userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
	order by tusers.groupname
	</cfquery>
	<cfreturn rsMembershipIDs />
</cffunction>

<cffunction name="readGroupMemberships" returntype="query" output="false" access="public">
	<cfargument name="userid" type="string" />
	<cfset var rsGroupMemberships =""/>
	
	<cfquery name="rsGroupMemberships" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	Select tusers.userID AS groupID, #variables.fieldList# from tusers
	inner join  tusersmemb on tusers.userid=tusersmemb.userid 
	left join tfiles on tusers.photoFileId=tfiles.fileid
	where tusersmemb.groupid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
	<cfif not listFind(session.mura.memberships,'S2')>and tusers.s2 =0</cfif> 
	order by lname</cfquery>
	
	<cfreturn rsGroupMemberships />
	</cffunction>

<cffunction name="readInterestGroups" returntype="query" access="public" output="false">
	<cfargument name="userid" type="string" default="" />

	<cfset var rsInterestGroups = "" />
	<cfquery name="rsInterestGroups" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	SELECT tcontentcategories.* from tcontentcategories
	Inner Join tusersinterests on tcontentcategories.categoryID=tusersinterests.categoryID
	where userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
	</cfquery>
	<cfreturn rsInterestGroups />
</cffunction>
		
<cffunction name="readInterestGroupIDs" returntype="query" access="public" output="false">
	<cfargument name="userid" type="string" default="" />

	<cfset var rsInterestGroupIDs = "" />
	<cfquery name="rsInterestGroupIDs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	SELECT categoryID from tusersinterests where userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
	</cfquery>
	<cfreturn rsInterestGroupIDs />
</cffunction>

<cffunction name="savePassword" returntype="void" output="false" access="public">
	<cfargument name="userid" type="string" />
	<cfargument name="password" type="string" />
	
	 <cfquery  datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      UPDATE tusers SET
	  	 password =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.password neq '',de('no'),de('yes'))#" value="#iif(variables.configBean.getEncryptPasswords(),de('#variables.utility.toBCryptHash(arguments.password)#'),de('#arguments.password#'))#">,
		 passwordCreated =<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
       WHERE UserID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"> 
   </CFQUERY>
</cffunction>

<cffunction name="readUserHash" returntype="query" output="false" access="public">
	<cfargument name="userid" type="string" />
	<cfset var rsUserHash="">
	<cfquery name="rsUserHash" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
      SELECT userID,password as userHash,siteID,isPublic from tusers
       WHERE UserID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"> 
   </cfquery>
	<cfif not variables.configBean.getEncryptPasswords()>
		<cfquery name="rsUserHash" dbtype="query">
	      SELECT userID,'#variables.utility.toBCryptHash(rs.userHash)#' as userHash,siteID,isPublic from rsUserHash
	   	</cfquery>
	</cfif>
	<cfreturn rsUserHash/>
</cffunction>
		
<cffunction name="readAddress" access="public" returntype="any" output="false">
		<cfargument name="addressid" type="string" required="yes" />
		<cfset var rs = getAddressByID(arguments.addressID) />
		<cfset var addressBean=super.getBean("address") />

		<cfif rs.recordCount eq 1>
			<cfset addressBean.set(rs) />
		</cfif>
		
		<cfreturn addressBean />
</cffunction>

<cffunction name="getAddressByID" access="public" returntype="any" output="false">
		<cfargument name="addressid" type="string" required="yes" />
		<cfset var rsAddressByID = 0 />
		
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" name="rsAddressByID">
			select *
			from tuseraddresses 
			where addressid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressID#"> 
		</cfquery>
			
		<cfreturn rsAddressByID />
</cffunction>

<cffunction name="updateAddress" returntype="void" access="public" output="false">
	<cfargument name="addressBean" type="any" />

 <cfquery  datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      UPDATE tuseraddresses SET
		phone =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getPhone() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getPhone()#">,
		address1 =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getAddress1() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddress1()#">,
		address2 =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getAddress2() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddress2()#">,
		city =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getCity() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getCity()#">,
		state =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getState() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getState()#">,
		zip =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getZip() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getZip()#">,
		fax =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getFax() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getFax()#">, 
		addressNotes =  <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.addressBean.getAddressNotes() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddressNotes()#">,
		siteid = '#trim(arguments.addressBean.getSiteID())#',
		UserID = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getUserID() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getUserID()#">,
		addressName=  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getAddressName() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddressName()#">,
		country=  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getCountry() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getCountry()#">,
		addressURL=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getAddressURL() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddressURL()#">,
		longitude = #arguments.addressBean.getLongitude()#,
		latitude = #arguments.addressBean.getLatitude()#,
		addressEmail=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getAddressEmail() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddressEmail()#">,
		hours =  <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.addressBean.getHours() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getHours()#">
       WHERE AddressID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressBean.getAddressID()#">
   </CFQUERY>

</cffunction>

<cffunction name="createAddress" returntype="void" access="public" output="false">
<cfargument name="addressBean" type="any" />

 <cfquery  datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
        INSERT INTO tuseraddresses  (AddressID,UserID,siteID,
		phone,fax,address1, address2, city, state, zip ,
		addressName,country,isPrimary,addressNotes,addressURL,
		longitude,latitude,addressEmail,hours)
     VALUES(
        '#arguments.addressBean.getAddressid()#',
		'#arguments.addressBean.getuserid()#',
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getSiteID() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getSiteID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getPhone() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getPhone()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getFax() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getFax()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getAddress1() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddress1()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getAddress2() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddress2()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getCity() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getCity()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getState() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getState()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getZip() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getZip()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getAddressName() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddressName()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getCountry() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getCountry()#">,
		#arguments.addressBean.getIsPrimary()#,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.addressBean.getAddressNotes() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddressNotes()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getAddressURL() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddressURL()#">,
		#arguments.addressBean.getLongitude()#,
		#arguments.addressBean.getLatitude()#,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getAddressEmail() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddressEmail()#">,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.addressBean.getHours() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getHours()#">
		  )
		 
   </CFQUERY>

</cffunction>

<cffunction name="deleteAddress" access="public" output="false" returntype="void">
		<cfargument name="addressID" type="String" />
		
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
		DELETE FROM tuseraddresses where addressID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressID#">
	</cfquery>
	
	<!--- sometimes apps allow addresses to be rated --->
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
		DELETE FROM tcontentratings where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressID#">
	</cfquery>
	
	<cfset deleteExtendData(arguments.addressID) />
	
</cffunction>

<cffunction name="deleteUserAddresses" access="public" output="false" returntype="void">
		<cfargument name="userID" type="String" />
	
	<cfset var rsUserAddresses=""/>
	<!--- sometimes apps allow addresses to be rated --->
	<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#" >
		DELETE FROM tcontentratings where contentID 
		in (select addressID from tuseraddresses where userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">)
	</cfquery>
	
	<cfquery name="rsUserAddresses" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#" >
		select addressID FROM tuseraddresses where userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
	</cfquery>
	
	<cfloop query="rsUserAddresses">
		<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#" >
			DELETE FROM tuseraddresses where addressID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUserAddresses.addressID#">
		</cfquery>
		
		<cfset deleteExtendData(rsUserAddresses.addressID) />
	</cfloop>
</cffunction>

<cffunction name="setPrimaryAddress" access="public" output="false" returntype="void">
		<cfargument name="userID" type="String" />
		<cfargument name="addressID" type="String" />
		
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
		UPDATE tuseraddresses set isPrimary=0 where userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
	</cfquery>
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
		UPDATE tuseraddresses set isPrimary=1 where addressID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressID#">
	</cfquery>
	
</cffunction>

<cffunction name="getAddresses" access="public" output="false" returntype="query">
		<cfargument name="userID" type="String" />
		<cfset var rsAddresses ="" />
	<cfquery name="rsAddresses" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#" >
		select * from tuseraddresses where userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
		order by isPrimary desc
	</cfquery>
	
	<cfreturn  rsAddresses />
</cffunction>

<cffunction name="clearBadMembeships" access="public" output="false" returntype="void">
		<cfargument name="userBean" type="any" />

	<cfif not arguments.userBean.getS2() and  arguments.userBean.getIsPublic()>
		<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#" >
			delete from tusersmemb where userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userBean.getUserID()#">
			and groupID not in 
			(select userID from tusers 
			where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userBean.getSiteID()#"> 
			and type=1 and isPublic=1
			<!--- and ((isPublic=1 and siteid='#variables.settingsManager.getSite(arguments.userBean.getSiteID()).getPublicUserPoolID()#')
				<cfif not arguments.userBean.getIsPublic()>
				or (isPublic=0 and siteid='#variables.settingsManager.getSite(arguments.userBean.getSiteID()).getPrivateUserPoolID()#')
				</cfif>) --->
			)
		</cfquery>
		
		
	</cfif>
	
</cffunction>

<cffunction name="createTags" access="public" returntype="void" output="false">
	<cfargument name="userBean" type="any" />
	<cfset var taglist  = "" />
	<cfset var t = "" />
		<cfif len(arguments.userBean.getTags())>
			<cfset taglist = arguments.userBean.getTags() />
			<cfloop list="#taglist#" index="t">
				<cfif len(trim(t))>
					<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
					insert into tuserstags (userid,siteid,tag)
					values(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userBean.getUserID()#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userBean.getSiteID()#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(t)#"/>
						)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
</cffunction>

<cffunction name="deleteTags" access="public" returntype="void" output="false">
	<cfargument name="userID"  type="string" />

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tuserstags where userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
	</cfquery>
</cffunction>

<cffunction name="setUserBeanMetaData" output="false" returntype="any">
	<cfargument name="userBean">
	<cfset var rsmembs=readMembershipIDs(userBean.getUserId()) />
	<cfset var rsInterests=readInterestGroupIDs(userBean.getUserId()) />
	<cfset userBean.setGroupId(valuelist(rsmembs.groupid))/>
	<cfset userBean.setCategoryId(valuelist(rsInterests.categoryid))/>
	<!--- <cfset userBean.setAddresses(getAddresses(userBean.getUserId()))/> --->
	
	<cfreturn userBean>
	</cffunction>
</cfcomponent>