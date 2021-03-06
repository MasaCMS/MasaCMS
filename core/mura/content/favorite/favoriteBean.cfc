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
<cfcomponent extends="mura.bean.bean" entityName="favorite" table="tusersfavorites" output="false" hint="This provides user favorites persistence">

<cfproperty name="favoriteID" fieldtype="id" type="string" default="" required="true" />
<cfproperty name="userID" type="string" default="" required="true" />
<cfproperty name="favoriteName" type="string" default="" required="true" />
<cfproperty name="favorite" type="string" default="" required="true" />
<cfproperty name="type" type="string" default="" required="true" />
<cfproperty name="siteID" type="string" default="" required="true" />
<cfproperty name="dateCreated" type="date" default="" required="true" />
<cfproperty name="columnNumber" type="numeric" default="0" required="true" />
<cfproperty name="rowNumber" type="numeric" default="0" required="true" />
<cfproperty name="maxRSSItems" type="numeric" default="0" required="true" />
<cfproperty name="isNew" type="numeric" default="1" required="true" persistent="false"/>

<cffunction name="init" output="false">
	<cfset super.init(argumentCollection=arguments)>

	<cfset variables.instance.favoriteID="" />
	<cfset variables.instance.userID=""/>
	<cfset variables.instance.favoriteName=""/>
	<cfset variables.instance.favorite=""/>
	<cfset variables.instance.type=""/>
	<cfset variables.instance.siteID=""/>
	<cfset variables.instance.dateCreated=now()/>
	<cfset variables.instance.columnNumber=0/>
	<cfset variables.instance.rowNumber=0/>
	<cfset variables.instance.maxRSSItems=0/>
	<cfset variables.instance.isNew=1/>

	<cfreturn this />
</cffunction>

<cffunction name="setConfigBean">
	<cfargument name="configBean">
	<cfset variables.configBean=arguments.configBean>
	<cfreturn this>
</cffunction>

<cffunction name="getFavoriteID" output="false">
	<cfif not len(variables.instance.favoriteID)>
		<cfset variables.instance.favoriteID = createUUID() />
	</cfif>
	<cfreturn variables.instance.favoriteID />
</cffunction>

<cffunction name="setColumnNumber" output="false">
	<cfargument name="ColumnNumber" />
	<cfif isNumeric(arguments.ColumnNumber)>
	<cfset variables.instance.ColumnNumber = arguments.ColumnNumber />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setRowNumber" output="false">
	<cfargument name="RowNumber" />
	<cfif isNumeric(arguments.RowNumber)>
	<cfset variables.instance.RowNumber = arguments.RowNumber />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMaxRSSItems" output="false">
	<cfargument name="MaxRSSItems" />
	<cfif isNumeric(arguments.MaxRSSItems)>
	<cfset variables.instance.MaxRSSItems = arguments.MaxRSSItems />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setDateCreated" output="false">
	<cfargument name="DateCreated" />
	<cfif isDate(arguments.DateCreated)>
	<cfset variables.instance.DateCreated = arguments.DateCreated />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="load"  output="false">
	<cfset var rs=getQuery(argumentcollection=arguments)>
	<cfif rs.recordcount>
		<cfset set(rs) />
	</cfif>
</cffunction>

<cffunction name="loadBy" output="false">
	<cfset var response="">

	<cfif not structKeyExists(arguments,"siteID")>
		<cfset arguments.siteID=variables.instance.siteID>
	</cfif>

	<cfif not structKeyExists(arguments,"userID")>
		<cfset arguments.userID=variables.instance.userID>
	</cfif>

	<cfset load(argumentCollection=arguments)>
	<cfreturn this>
</cffunction>

<cffunction name="getQuery"  output="false">
	<cfset var rs=""/>
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	select * from tusersfavorites
	where
	<cfif structKeyExists(arguments,"favoriteID")>
	favoriteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.favoriteID#">
	<cfelseif structKeyExists(arguments,"favorite")>
		siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">
		and favorite=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.favorite#">
		<cfif structKeyExists(arguments,"userID")>
			and userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
		<cfelse>
			and userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.userID#">
		</cfif>
	<cfelse>
	favoriteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getFavoriteID()#">
	</cfif>
	</cfquery>

	<cfreturn rs/>
</cffunction>

<cffunction name="delete">
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tusersfavorites
	where favoriteID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getFavoriteID()#">
	</cfquery>
</cffunction>

<cffunction name="save"  output="false">
	<cfset var rs=""/>

	<cfif getQuery().recordcount>

		<cfquery>
		update tusersfavorites set
		favoriteName=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.favoriteName neq '',de('no'),de('yes'))#" value="#variables.instance.favoriteName#">,
		favorite=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.favorite neq '',de('no'),de('yes'))#" value="#variables.instance.favorite#">,
		type=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.type neq '',de('no'),de('yes'))#" value="#variables.instance.type#">,
		siteID=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.siteID neq '',de('no'),de('yes'))#" value="#variables.instance.siteID#">,
		columnNumber=#variables.instance.columnNumber#,
		rowNumber=#variables.instance.rowNumber#,
		maxRSSItems=#variables.instance.maxRssItems#,
		dateCreated=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#variables.instance.dateCreated#">
		where favoriteID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getFavoriteID()#">
		</cfquery>

	<cfelse>

		<cfquery>
		insert into tusersfavorites (favoriteID,userID,favoriteName,favorite,type,siteID,columnNumber,rowNumber,maxRSSItems,dateCreated)
		values(
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getFavoriteID() neq '',de('no'),de('yes'))#" value="#getFavoriteID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.userID neq '',de('no'),de('yes'))#" value="#variables.instance.userID#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.favoriteName neq '',de('no'),de('yes'))#" value="#variables.instance.favoriteName#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.favorite neq '',de('no'),de('yes'))#" value="#variables.instance.favorite#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.type neq '',de('no'),de('yes'))#" value="#variables.instance.type#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.siteID neq '',de('no'),de('yes'))#" value="#variables.instance.siteID#">,
		#variables.instance.columnNumber#,
		#variables.instance.rowNumber#,
		#variables.instance.maxRssItems#,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#variables.instance.dateCreated#">
		)
		</cfquery>

	</cfif>

</cffunction>

<cffunction name="getFavoritesByUser" output="false">
	<cfargument name="userID">
	<cfargument name="type">
	<cfreturn variables.instance>
</cffunction>

<cffunction name="getUsersByFavorite" output="false">
	<cfargument name="favorite">
	<cfargument name="type">
	<cfreturn variables.instance>
</cffunction>

<cffunction name="getPrimaryKey" output="false">
	<cfreturn "favoriteID">
</cffunction>

</cfcomponent>
