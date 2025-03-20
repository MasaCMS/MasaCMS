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
<cfcomponent extends="mura.bean.beanExtendable" entityName="user" table="tusers" output="false" hint="This provides the User bean">

<cfproperty name="userID" fieldtype="id" type="string" />
<cfproperty name="remoteID" type="string" default="" />
<cfproperty name="groupname" type="string" default="" />
<cfproperty name="fname" type="string" default=""/>
<cfproperty name="lname" type="string" default=""/>
<cfproperty name="username" type="string" default=""/>
<cfproperty name="password" type="string" default="" />
<cfproperty name="passwordCreated" type="date" default="" />
<cfproperty name="email" type="string" default=""/>
<cfproperty name="company" type="string" default="" />
<cfproperty name="jobTitle" type="string" default="" />
<cfproperty name="website" type="string" default="" />
<cfproperty name="mobilePhone" type="string" default="" />
<cfproperty name="type" type="numeric" default="2"/>
<cfproperty name="subType" type="string" default="Default"/>
<cfproperty name="s2" type="numeric" default="0"/>
<cfproperty name="contactFormat" type="string" default="" />
<cfproperty name="lastLogin" type="date" default="" />
<cfproperty name="lastUpdate" type="date" default="" />
<cfproperty name="lastUpdateBy" type="string" default="" />
<cfproperty name="lastUpdateByID" type="string" default="" />
<cfproperty name="created" type="date" default="" />
<cfproperty name="perm" type="numeric" default="0" />
<cfproperty name="inActive" type="numeric" default="0" />
<cfproperty name="isPublic" type="numeric" default="1" />
<cfproperty name="siteID" type="string" default=""/>
<cfproperty name="subscribe" type="numeric" default="1"/>
<cfproperty name="notes" type="string" default=""/>
<cfproperty name="categoryID" type="string" default=""/>
<cfproperty name="primaryAddressID" type="string" default=""/>
<cfproperty name="addressID" type="string" default=""/>
<cfproperty name="addresses" type="query" default=""/>
<cfproperty name="description" type="string" default=""/>
<cfproperty name="interests" type="string" default=""/>
<cfproperty name="photoFileID" type="string" default=""/>
<cfproperty name="photoFileExt" type="string" default=""/>
<cfproperty name="keepPrivate" type="numeric" default="0"/>
<cfproperty name="IMName" type="string" default=""/>
<cfproperty name="IMService" type="string" default=""/>
<cfproperty name="extendDataTable" type="string" default="tclassextenddatauseractivity"/>
<cfproperty name="isNew" type="numeric" default="1" persistent="false"/>
<cfproperty name="tablist" type="string" default=""/>
<cfproperty name="newFile" type="string" default=""/>

<cfset variables.primaryKey = 'userid'>
<cfset variables.entityName = 'user'>
<cfset variables.instanceName = 'fullname'>

<cffunction name="init" output="false">

	<cfset super.init(argumentCollection=arguments)>

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
	<cfset variables.instance.created=now() />
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
	<cfset variables.instance.extendDataTable="tclassextenddatauseractivity" />
  <cfset variables.instance.errors=structnew() />
	<cfset variables.instance.isNew=1 />
	<cfset variables.instance.tablist="" />
	<cfset variables.instance.newFile="" />
	<cfset variables.newAddresses = arrayNew(1) />

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

<cffunction name="set" output="false">
	<cfargument name="property" required="true">
    <cfargument name="propertyValue">

    <cfif not isDefined('arguments.user')>
	    <cfif isSimpleValue(arguments.property)>
	      <cfreturn setValue(argumentCollection=arguments)>
	    </cfif>

	    <cfset arguments.user=arguments.property>
    </cfif>

	<cfset var prop="" />

	<cfif isQuery(arguments.user) and arguments.user.recordcount>
		<cfloop list="#arguments.user.columnlist#" index="prop">
			<cfset setValue(prop,arguments.user[prop][1]) />
		</cfloop>

	<cfelseif isStruct(arguments.user)>
		<cfloop collection="#arguments.user#" item="prop">
			<cfset setValue(prop,arguments.user[prop]) />
		</cfloop>
	</cfif>

	<cfif isdefined('arguments.user.siteid') and trim(arguments.user.siteid) neq ''>
		<cfif isdefined('arguments.user.switchToPublic') and trim(arguments.user.switchToPublic) eq '1'>
			<cfset variables.instance.siteID=variables.settingsManager.getSite(arguments.user.siteid).getPublicUserPoolID() />
			<cfset variables.instance.ispublic=1 />
		<cfelseif isdefined('arguments.user.switchToPrivate') and trim(arguments.user.switchToPrivate) eq '1'>
			<cfset variables.instance.siteID=variables.settingsManager.getSite(arguments.user.siteid).getPrivateUserPoolID() />
			<cfset variables.instance.ispublic=0 />
		<cfelseif variables.instance.ispublic eq 0>
			<cfset setSiteID(variables.settingsManager.getSite(arguments.user.siteid).getPrivateUserPoolID()) />
		<cfelse>
			<cfset setSiteID(variables.settingsManager.getSite(arguments.user.siteid).getPublicUserPoolID()) />
		</cfif>
	</cfif>

	<cfreturn this />
</cffunction>

<cffunction name="getAllValues" returntype="struct" output="false">
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

<cffunction name="getUserID" output="false">
    <cfif not len(variables.instance.UserID)>
		<cfset variables.instance.UserID = createUUID() />
	</cfif>
	<cfreturn variables.instance.UserID />
</cffunction>

<!---
<cffunction name="getGroupID" output="false">
	<cfif variables.instance.type eq 2>
		<cfreturn getUserID() />
	<cfelse>
		<cfparam name="variables.instance.groupid" default="">
		<cfreturn variables.instance.groupid>
	</cfif>
</cffunction>
--->

<cffunction name="setLastUpdateBy" output="false">
	<cfargument name="lastUpdateBy" type="String" />
	<cfset variables.instance.lastUpdateBy = left(trim(arguments.lastUpdateBy),50) />
	<cfreturn this>
</cffunction>

<cffunction name="setLastLogin" output="false">
    <cfargument name="LastLogin" type="String" required="true">
	<cfif isDate(arguments.LastLogin)>
    <cfset variables.instance.LastLogin = parseDateTime(arguments.LastLogin) />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setLastUpdate" output="false">
    <cfargument name="LastUpdate" type="string" required="true">
	<cfset variables.instance.LastUpdate = parseDateArg(arguments.LastUpdate) />
	<cfreturn this>
</cffunction>

<cffunction name="setCreated" output="false">
    <cfargument name="Created" type="string" required="true">
	<cfset variables.instance.Created = parseDateArg(arguments.Created) />
	<cfreturn this>
</cffunction>

<cffunction name="setGroupID" output="false">
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

<cffunction name="removeGroupID" output="false">
	<cfargument name="groupID" type="String" />
	<cfset var i = 0 />
	<cfset var listItem = 0 />

	<cfif Len(arguments.groupID)>
		<cfloop from="1" to="#ListLen(arguments.groupID)#" index="i">
			<cfif ListFindNoCase(variables.instance.groupID, ListGetAt(arguments.groupID, i))>
				<cfset listItem = ListFindNoCase(variables.instance.groupID, ListGetAt(arguments.groupID, i)) />
				<cfset variables.instance.groupID = ListDeleteAt(variables.instance.groupID, listItem) />
			</cfif>
	    </cfloop>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="setUsernameNoCache" output="false">
    <cfargument name="Username" type="string" required="true">
    <cfset variables.instance.Username = trim(arguments.Username) />
	<cfreturn this>
</cffunction>

<cffunction name="setPasswordNoCache" output="false">
    <cfargument name="Password" type="string" required="true">
    <cfset variables.instance.Password = trim(arguments.Password) />
	<cfreturn this>
</cffunction>

<cffunction name="setCategoryID" output="false">
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

<cffunction name="removeCategoryID" output="false">
	<cfargument name="categoryID" type="String" />
	<cfset var i=0>
	<cfset var offset=0>

	<cfif len(arguments.categoryID)>
		<cfloop from="1" to="#listLen(arguments.categoryID)#" index="i">
		<cfif listFindNoCase(variables.instance.categoryID,listGetAt(arguments.categoryID,i))>
	    	<cfset variables.instance.categoryID = listDeleteAt(variables.instance.categoryID,i-offset) /> />
	    	<cfset offset=offset+1>
	    </cfif>
	    </cfloop>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="setAddresses" output="false" hint="deprecated">
    <cfargument name="addresses" required="true">
    <cfif not isQuery(arguments.addresses)>
	<cfset variables.instance.addresses = arguments.addresses />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getAddresses" output="false">
    <cfreturn getAddressesQuery() />
</cffunction>

<cffunction name="getAddressesQuery" output="false">
   <cfreturn variables.userManager.getAddresses(getUserID()) />
</cffunction>

<cffunction name="getAddressesIterator" output="false">
   	<cfset var it=getBean("addressIterator").init()>
	<cfset it.setQuery(getAddressesQuery())>
	<cfreturn it />
</cffunction>

<cffunction name="checkUsername" returntype="boolean" output="false">
	<cfargument name="username" default="#trim(variables.instance.username)#">
	<cfset var rsCheck=""/>
	<cfquery name="rsCheck" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		select username from tusers where type=2 and username=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.username)#"> and UserID <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.instance.userID)#">
	</cfquery>

	<cfif not rscheck.recordcount>
		<cfreturn true />
	<cfelse>
		<cfreturn false />
	</cfif>

</cffunction>

<cffunction name="checkEmail" returntype="boolean" output="false">
	<cfargument name="email" default="#trim(variables.instance.email)#">
	<cfset var rsCheck=""/>
	<cfquery name="rsCheck" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		select username from tusers where type=2 and email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.email)#"> and UserID <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(getUserID())#">
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


<cffunction name="validate" output="false">
	<cfset var extErrors=structNew() />
	<cfset var passwordRegex="(?=^.{7,15}$)(?=.*\d)(?![.\n])(?=.*[a-zA-Z]).*$">

	<cfparam name="variables.instance.lockSupers" default="false">

	<cfset variables.instance.errors=structNew()>

	<cfif len(variables.instance.siteID)>
		<cfset extErrors=variables.configBean.getClassExtensionManager().validateExtendedData(getAllValues())>
	</cfif>

	<cfset super.validate()>

	<cfif not structIsEmpty(extErrors)>
		<cfset structAppend(variables.instance.errors,extErrors)>
	</cfif>

	<cfif trim(variables.instance.siteid) neq "">

		<cfif variables.instance.type eq 2 >

			<cfif len(variables.instance.password) and yesNoFormat(variables.configBean.getValue("strongPasswords"))>

				<cfif not reFind(variables.configBean.getValue("strongPasswordRegex"),variables.instance.password) or variables.instance.username eq variables.instance.password>
					<cfset variables.instance.errors.password=variables.settingsManager.getSite(variables.instance.siteID).getRBFactory().getKey("user.passwordstrengthvalidate") />
				</cfif>

			</cfif>

			<cfif(variables.instance.username eq "" or not checkUsername())>
				<cfset variables.instance.errors.username=variables.settingsManager.getSite(variables.instance.siteID).getRBFactory().getResourceBundle().messageFormat( variables.settingsManager.getSite(variables.instance.siteID).getRBFactory().getKey("user.usernamevalidate") , variables.instance.username ) />
			</cfif>

			<cfif variables.instance.email eq "" >
				<cfset variables.instance.errors.email=variables.settingsManager.getSite(variables.instance.siteID).getRBFactory().getKey("user.emailrequired") />
			</cfif>
	</cfif>

		<!--- If captcha data has been submitted validate it --->
		<cfif not (not len(variables.instance.hKey) or variables.instance.hKey eq hash(variables.instance.uKey,application.configBean.getDefaultHashAlgorithm()))>
		<cfset variables.instance.errors.SecurityCode=variables.settingsManager.getSite(variables.instance.siteID).getRBFactory().getKey("captcha.error")/>
		</cfif>

		<!--- If cfformprotect has been submitted validate it --->
		<cfif not variables.instance.passedProtect>
		<cfset variables.instance.errors.Spam=variables.settingsManager.getSite(variables.instance.siteID).getRBFactory().getKey("captcha.spam")/>
		</cfif>

	<cfelse>
		<cfset variables.instance.errors.siteid="The 'SiteID' variable is missing." />
	</cfif>

	<cfscript>
		var errorCheck={};
		var checknum=1;
		var checkfound=false;

		if(arrayLen(variables.instance.addObjects)){
			for(var obj in variables.instance.addObjects){
				errorCheck=obj.validate().getErrors();
				if(!structIsEmpty(errorCheck)){
					do{
						if( !structKeyExists(variables.instance.errors,obj.getEntityName() & checknum) ){
							variables.instance.errors[obj.getEntityName()  & checknum ]=errorCheck;
							checkfound=true;
						}
					} while (!checkfound);
				}

			}
		}
	</cfscript>

	<cfreturn this>
</cffunction>

<cffunction name="getAddressByID" output="false">
	<cfargument name="addressID" type="string" required="true">
	<cfreturn variables.userManager.getAddressByID(arguments.addressID) />
</cffunction>

<cffunction name="getAddressBeanByID" output="false">
	<cfargument name="addressID" type="string" required="true">
	<cfset var addressBean=getBean("addressBean") />

	<cfset addressBean.set(getAddressByID(arguments.addressID))>
	<cfset addressBean.setAddressID(arguments.addressID)>
	<cfset addressBean.setUserID(getUserID())>
	<cfset addressBean.setSiteID(variables.instance.siteID)>

	<cfreturn addressBean />
</cffunction>

<cffunction name="setKeepPrivate" output="false">
    <cfargument name="KeepPrivate" type="any" required="true">
	<cfif isNumeric(arguments.keepPrivate)>
    		<cfset variables.instance.KeepPrivate = arguments.KeepPrivate />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setPasswordCreated" output="false">
    <cfargument name="PasswordCreated" type="string" required="true">
	<cfif isDate(arguments.PasswordCreated)>
    	<cfset variables.instance.PasswordCreated = parseDateTime(arguments.PasswordCreated) />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setPassedProtect" output="false">
    <cfargument name="passedProtect" required="true">
	<cfif isBoolean(arguments.passedProtect)>
    	<cfset variables.instance.passedProtect = arguments.passedProtect />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="save" output="false">
	<cfset var i="">
	<cfset var address="">
	<cfset var newAddressArr = variables.newAddresses>
	<cfset setAllValues(variables.userManager.save(this).getAllValues())>

	<cfif !structCount(getErrors()) and arrayLen(newAddressArr)>
		<cfloop from="1" to="#arrayLen(newAddressArr)#" index="i">
			<cfset address=newAddressArr[i]>
			<cfset address.save()>
		</cfloop>
	</cfif>

	<cfset variables.newAddresses=arrayNew(1)>
	<cfreturn this>
</cffunction>

<cffunction name="delete" output="false">
	<cfset variables.userManager.delete(getUserID(),variables.instance.type)>
</cffunction>

<cffunction name="getMembersQuery" output="false">
   <cfreturn variables.userManager.readGroupMemberships(getUserID()) />
</cffunction>

<cffunction name="getMembersIterator" output="false">
   	<cfset var it=getBean("userIterator").init()>
	<cfset it.setQuery(getMembersQuery())>
	<cfreturn it />
</cffunction>

<cffunction name="getMembershipsQuery" output="false">
   <cfreturn variables.userManager.readMemberships(getUserID()) />
</cffunction>

<cffunction name="getMembershipsIterator" output="false">
   	<cfset var it=getBean("userIterator").init()>
	<cfset it.setQuery(getMembershipsQuery())>
	<cfreturn it />
</cffunction>

<cffunction name="getInterestGroupsQuery" output="false">
   <cfreturn variables.userManager.readInterestGroups(getUserID()) />
</cffunction>

<cffunction name="getInterestGroupsIterator" output="false">
   	<cfset var it=getBean("categoryIterator").init()>
	<cfset it.setQuery(getInterestGroupsQuery())>
	<cfreturn it />
</cffunction>

<cffunction name="loadBy" output="false">
	<cfif not structKeyExists(arguments,"siteID")>
		<cfset arguments.siteID=variables.instance.siteID>
	</cfif>
	<cfif not structKeyExists(arguments,"isPublic")>
		<cfset arguments.isPublic="both">
	</cfif>

	<cfset arguments.userBean=this>

	<cfreturn variables.userManager.read(argumentCollection=arguments)>
</cffunction>

<cffunction name="addAddress" output="false">
	<cfargument name="address" hint="Instance of a addressBean">
	<cfset arguments.address.setSiteID(variables.instance.siteID)>
	<cfset arguments.address.setUserID(getUserID())>
	<cfset arrayAppend(variables.newAddresses,arguments.address)>
	<cfreturn this>
</cffunction>

<cffunction name="getContentTabAssignments" output="false">
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
				<cfreturn getBean('contentManager').getTabList()>
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn userlist>
</cffunction>

<cffunction name="readAddress" output="false">
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
		<cfset address.setSiteID(variables.instance.siteID)>
	</cfif>

	<cfreturn address>
</cffunction>

<cffunction name="isInGroup" output="false">
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

<cffunction name="getExtendBaseID" output="false">
	<cfreturn getUserID()>
</cffunction>

<cffunction name="getImageURL" output="false">
	<cfargument name="size" required="true" default="undefined">
	<cfargument name="direct" default="true"/>
	<cfargument name="complete" default="false"/>
	<cfargument name="height" default=""/>
	<cfargument name="width" default=""/>
	<cfargument name="default" default=""/>
	<cfscript>
		var image = variables.settingsManager.getSite(variables.instance.siteID).getContentRenderer().createHREFForImage(variables.instance.siteID, variables.instance.photofileid, variables.instance.photofileEXT, arguments.size, arguments.direct, arguments.complete, arguments.height, arguments.width);
		return Len(image) ? image : arguments.default;
	</cfscript>
</cffunction>

<cffunction name="getPrimaryKey" output="false">
	<cfreturn "userID">
</cffunction>

<cffunction name="getFullName" output="false">
	<cfif variables.instance.type eq 2>
		<cfreturn trim("#variables.instance.fname# # variables.instance.lname#")>
	<cfelse>
		<cfreturn variables.instance.groupname>
	</cfif>
</cffunction>

<cffunction name="setType" output="false">
	<cfargument name="type">
	<cfif not isNumeric(arguments.type)>
		<cfif arguments.type eq 'group'>
			<cfset variables.instance.type=1>
		<cfelse>
			<cfset variables.instance.type=2>
		</cfif>
	<cfelse>
		<cfset variables.instance.type=arguments.type>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="login" output="false">
	<cfset getBean('userUtility').loginByUserID(userid=getValue('userid'),siteid=getValue('siteid'))>
	<cfreturn this>
</cffunction>

<cffunction name="getFileMetaData" output="false">
	<cfargument name="property" default="fileid">
	<cfreturn getBean('fileMetaData').loadBy(contentid=getValue('userid'),contentHistID=getValue('userid'),siteID=getValue('siteid'),fileid=getValue(arguments.property))>
</cffunction>

<cffunction name="setFirstName" output="false">
	<cfargument name="firstname">
	<cfset setValue('fname',arguments.firstname)>
	<cfreturn this>
</cffunction>

<cffunction name="getFirstName" output="false">
	<cfreturn getValue('fname')>
</cffunction>

<cffunction name="setLastName" output="false">
	<cfargument name="lastname">
	<cfset setValue('lname',arguments.lastname)>
	<cfreturn this>
</cffunction>

<cffunction name="getLastName" output="false">
	<cfreturn getValue('lname')>
</cffunction>

<cfscript>
	function getEntityName(){

		param name="variables.entityName" default="user";
		param name="variables.instance.type" default=2;

		if(get('type')==1 && variables.entityName=='user'){
			variables.entityName='group';
		}
		if(get('type')==2 && variables.entityName=='group'){
			variables.entityName='user';
		}

		return variables.entityName;
	}

	function getEntityDisplayName(){
		return getEntityName();
	}

	function getEditURL(){
		if(get('type')==1){
			return getBean('settingsManager').getSite(get('siteid')).getAdminPath(complete=1) & '/?muraAction=cusers.editgroup&siteid=' & esapiEncode('url',get('siteid')) & '&userid=' & esapiEncode('url',get('userid'));
		} else {
			return getBean('settingsManager').getSite(get('siteid')).getAdminPath(complete=1) & '/?muraAction=cusers.edituser&siteid=' &esapiEncode('url',get('siteid')) & '&userid=' & esapiEncode('url',get('userid'));
		}
	}

	remote function pollState() {
		var current  = getSession();
		var response = {
			loggedin=false
		};
		if(isDefined('current.mura.isLoggedIn')) {
			response.loggedin = current.mura.isLoggedIn;
		}
		return response;
	}


</cfscript>

<cffunction name="getPasswordExpired" output="false">
	<cfif not getBean('configBean').passwordsExpire() or not exists()>
		<cfreturn false>
	</cfif>

	<cfif not isDate(get('passwordCreated'))>
		<cfreturn true>
	</cfif>

	<cfset var expireIn=getBean('configBean').getValue(property="expirePasswords", defaultValue=0)>

	<cfif not isNumeric(expireIn) or expireIn eq 0>
		<cfreturn false>
	<cfelse>
		<cfreturn getPasswordExpiration(expireIn) lt now()>
	</cfif>

</cffunction>

<cffunction name="getPasswordExpiration" output="false">
	<cfargument name="expiresIn" default="#getBean('configBean').getValue(property="expirePasswords", defaultValue=0)#">
	<cfreturn dateAdd('d',arguments.expiresIn,get('passwordCreated'))>
</cffunction>

</cfcomponent>
