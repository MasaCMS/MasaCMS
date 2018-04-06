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
<cfcomponent extends="mura.bean.bean" output="false" entityName="imageSize" table="timagesizes" hint="Site custom inage size bean">
<cfproperty name="siteID" type="string" default="" required="true">
<cfproperty name="sizeID" type="string" default="" required="true">
<cfproperty name="name" type="string" default="" required="true">
<cfproperty name="height" type="string" default="AUTO" required="true">
<cfproperty name="width" type="string" default="AUT0" required="true">
<cfproperty name="isNew" type="numeric" default="1" required="true">

<cfscript>

function init() output=false {
	super.init(argumentCollection=arguments);
	variables.instance.siteID="";
	variables.instance.name="";
	variables.instance.sizeID=createUUID();
	variables.instance.width="AUTO";
	variables.instance.height="AUTO";
	variables.instance.isNew=1;
	variables.primaryKey = 'sizeid';
	variables.entityName = 'imageSize';
	return this;
}

function setConfigBean(configBean) output=false {
	variables.configBean=arguments.configBean;
	return this;
}

function setName(name) output=false {
	variables.instance.name=getBean('contentUtility').formatFilename(arguments.name);
}

function setHeight(height) output=false {
	if ( isNumeric(arguments.height) || arguments.height == "AUTO" ) {
		variables.instance.height=arguments.height;
	}
	return this;
}

function setWidth(width) output=false {
	if ( isNumeric(arguments.width) || arguments.width == "AUTO" ) {
		variables.instance.width=arguments.width;
	}
	return this;
}

function loadBy(sizeID, name, siteID="#variables.instance.siteID#") output=false {
	if ( isDefined('arguments.name') ) {
		arguments.name=getBean('contentUtility').formatFilename(arguments.name);
	}
	variables.instance.isNew=1;
	var rs=getQuery(argumentCollection=arguments);
	if ( rs.recordcount ) {
		set(rs);
		variables.instance.isNew=0;
	}
	return this;
}

function parseName() output=false {
	var param=listFirst(getValue('name'),'-');
	if ( left(param,1) == 'H' ) {
		param=right(param,len(param)-1);
		if ( isNumeric(param) ) {
			setValue('height',param);
		}
	} else if ( left(param,1) == 'W' ) {
		param=right(param,len(param)-1);
		if ( isNumeric(param) ) {
			setValue('width',param);
		}
	}
	param=listLast(getValue('name'),'-');
	if ( left(param,1) == 'H' ) {
		param=right(param,len(param)-1);
		if ( isNumeric(param) ) {
			setValue('height',param);
		}
	} else if ( left(param,1) == 'W' ) {
		param=right(param,len(param)-1);
		if ( isNumeric(param) ) {
			setValue('width',param);
		}
	}
}
</cfscript>

<cffunction name="getQuery" output="false">

	<cfset var rs=""/>
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs',cachedwithin=createTimeSpan(0, 0, 0, 1))#">
	select * from timagesizes
	where
	<cfif structKeyExists(arguments,'sizeid')>
	sizeid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sizeID#">
	<cfelseif structKeyExists(arguments,"name") and structKeyExists(arguments,"siteid")>
	name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">
	and
	siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
	<cfelse>
	sizeid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.sizeID#">
	</cfif>

	</cfquery>

	<cfreturn rs/>
</cffunction>

<cffunction name="save"  output="false">
	<cfset var rs=""/>

	<cfif getQuery().recordcount>

		<cfquery>
		update timagesizes set
		siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">,
		name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.name#">,
		height=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.height#">,
		width=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.width#">
		where sizeid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.sizeID#">
		</cfquery>

	<cfelse>

		<cfquery>
		insert into timagesizes (sizeid,siteid,name,height,width) values(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.sizeID#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.name#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.height#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.width#">
		)
		</cfquery>

	</cfif>

	<cfset variables.instance.isNew=0/>

	<cfreturn this>
</cffunction>

<cffunction name="delete"  output="false">

	<cfquery>
		delete from timagesizes
		where sizeid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.sizeID#">
	</cfquery>

	<cfset variables.instance.isNew=1/>

	<cfreturn this>
</cffunction>

</cfcomponent>
