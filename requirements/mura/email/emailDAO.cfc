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

<cffunction name="init" access="public" returntype="any" output="false">
<cfargument name="configBean" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
<cfreturn this />
</cffunction>

<cffunction name="create" returntype="void" access="public" output="false">
<cfargument name="emailBean" type="any" />
 
 <cfquery  datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
        INSERT INTO temails  (EmailID, Subject,BodyText, BodyHtml,
		  CreatedDate, LastUpdateBy, LastUpdateByID, GroupList, Status, DeliveryDate, siteid, replyto,format,fromLabel)
     VALUES(
             <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailBean.getemailid()#" />,
		  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getSubject() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getSubject()#">, 
		 
		  <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.emailBean.getBodyText() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getBodyText()#">,
		  <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.emailBean.getBodyHtml() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getBodyHtml()#">,
		
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getLastUpdateBy()#">,
		  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getLastUpdateByID() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getLastUpdateByID()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getGroupID() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getGroupID()#">,
		0,
		<cfif isdate(arguments.emailBean.getdeliverydate())><cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.emailBean.getdeliverydate()),month(arguments.emailBean.getdeliverydate()),day(arguments.emailBean.getdeliverydate()),hour(arguments.emailBean.getdeliverydate()),minute(arguments.emailBean.getdeliverydate()),0)#"><cfelse>null</cfif>,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getSiteID() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getSiteID()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getReplyTo() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getReplyTo()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getFormat() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getFormat()#">,
		  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getFromLabel() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getFromLabel()#">
		
		)
		 
   </CFQUERY>
	
</cffunction> 

<cffunction name="read" access="public" output="false" returntype="any" >
	<cfargument name="emailID" type="string" />
	<cfset var emailBean=getBean("email") />
	<cfset var rs ="" />
	
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	Select * from temails where 
	emailid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailID#" />
	</cfquery>
	
	<cfif rs.recordcount>
	<cfset emailBean.set(rs) />
	</cfif>
	
	<cfreturn emailBean />
</cffunction>

<cffunction name="update" access="public" output="false" returntype="void" >
	<cfargument name="emailBean" type="any" />
	
 <cfquery  datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
        UPDATE temails set 
		 subject =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getSubject() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getSubject()#">, 
		
		 bodytext =  <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.emailBean.getBodyText() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getBodyText()#">,
		 bodyhtml = <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.emailBean.getBodyHtml() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getBodyHtml()#">,
		
		 createddate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
		 lastupdateby = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getLastUpdateBy()#">,
		 lastupdatebyid = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getLastUpdateByID() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getLastUpdateByID()#">,
		 grouplist =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getGroupID() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getGroupID()#">,
		 status = 0,
		 deliverydate = <cfif isdate(arguments.emailBean.getdeliverydate())><cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.emailBean.getdeliverydate()),month(arguments.emailBean.getdeliverydate()),day(arguments.emailBean.getdeliverydate()),hour(arguments.emailBean.getdeliverydate()),minute(arguments.emailBean.getdeliverydate()),0)#"><cfelse>null</cfif>,
		 siteid= <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getSiteID() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getSiteID()#">,
		 replyto=  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getReplyTo() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getReplyTo()#">,
		 format= <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getFormat() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getFormat()#">,
		 fromLabel= <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getFromLabel() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getFromLabel()#">
		where emailid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailBean.getemailID()#" />
		 
   </CFQUERY>
	
</cffunction>

<cffunction name="delete" access="public" output="false" returntype="void" >
	<cfargument name="emailid" type="string" />
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
	<!---DELETE FROM temails where emailid='#arguments.emailID#'  --->
	UPDATE temails
	SET isDeleted = 1
	where emailid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailID#" />
	</cfquery>
	
	<!--- need to track emails, so don't delete from this log
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
	DELETE FROM temailstats where emailid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailID#" />
	</cfquery>
	--->

</cffunction>

</cfcomponent>
