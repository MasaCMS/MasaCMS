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

<cffunction name="init" access="public" returntype="any" output="false">
<cfargument name="configBean" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.dsn=variables.configBean.getdatasource()/>
<cfreturn this />
</cffunction>

<cffunction name="getBean" access="public" returntype="any">
	<cfreturn createObject("component","mura.email.emailBean").init()>
</cffunction>

<cffunction name="create" returntype="void" access="public" output="false">
<cfargument name="emailBean" type="any" />
 
 <cfquery  datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
        INSERT INTO temails  (EmailID, Subject,BodyText, BodyHtml,
		  CreatedDate, LastUpdateBy, LastUpdateByID, GroupList, Status, DeliveryDate, siteid, replyto,format,fromLabel)
     VALUES(
             <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailBean.getemailid()#" />,
		  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getSubject() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getSubject()#">, 
		 
		  <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.emailBean.getBodyText() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getBodyText()#">,
		  <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.emailBean.getBodyHtml() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getBodyHtml()#">,
		
		#createodbcdatetime(now())#, 
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getLastUpdateBy()#">,
		  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getLastUpdateByID() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getLastUpdateByID()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getGroupID() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getGroupID()#">,
		0,
		<cfif isdate(arguments.emailBean.getdeliverydate())>#createodbcdatetime(createDateTime(year(arguments.emailBean.getdeliverydate()),month(arguments.emailBean.getdeliverydate()),day(arguments.emailBean.getdeliverydate()),hour(arguments.emailBean.getdeliverydate()),minute(arguments.emailBean.getdeliverydate()),0))#<cfelse>null</cfif>,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getSiteID() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getSiteID()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getReplyTo() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getReplyTo()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getFormat() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getFormat()#">,
		  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getFromLabel() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getFromLabel()#">
		
		)
		 
   </CFQUERY>
	
</cffunction> 

<cffunction name="read" access="public" output="false" returntype="any" >
	<cfargument name="emailID" type="string" />
	<cfset var emailBean=getBean() />
	<cfset var rs ="" />
	
	<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
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
	
 <cfquery  datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
        UPDATE temails set 
		 subject =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getSubject() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getSubject()#">, 
		
		 bodytext =  <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.emailBean.getBodyText() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getBodyText()#">,
		 bodyhtml = <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.emailBean.getBodyHtml() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getBodyHtml()#">,
		
		 createddate = #createodbcdatetime(now())#, 
		 lastupdateby = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getLastUpdateBy()#">,
		 lastupdatebyid = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getLastUpdateByID() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getLastUpdateByID()#">,
		 grouplist =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getGroupID() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getGroupID()#">,
		 status = 0,
		 deliverydate = <cfif isdate(arguments.emailBean.getdeliverydate())>#createodbcdatetime(createDateTime(year(arguments.emailBean.getdeliverydate()),month(arguments.emailBean.getdeliverydate()),day(arguments.emailBean.getdeliverydate()),hour(arguments.emailBean.getdeliverydate()),minute(arguments.emailBean.getdeliverydate()),0))#<cfelse>null</cfif>,
		 siteid= <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getSiteID() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getSiteID()#">,
		 replyto=  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getReplyTo() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getReplyTo()#">,
		 format= <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getFormat() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getFormat()#">,
		 fromLabel= <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.emailBean.getFromLabel() neq '',de('no'),de('yes'))#" value="#arguments.emailBean.getFromLabel()#">
		where emailid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailBean.getemailID()#" />
		 
   </CFQUERY>
	
</cffunction>

<cffunction name="delete" access="public" output="false" returntype="void" >
	<cfargument name="emailid" type="string" />
	
	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
	<!---DELETE FROM temails where emailid='#arguments.emailID#'  --->
	UPDATE temails
	SET isDeleted = 1
	where emailid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailID#" />
	</cfquery>
	
	<!--- need to track emails, so don't delete from this log
	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
	DELETE FROM temailstats where emailid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailID#" />
	</cfquery>
	--->

</cffunction>

</cfcomponent>
