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

<cfset variables.instance.ExtendSetID="" />
<cfset variables.instance.subTypeID=""/>
<cfset variables.instance.siteID=""/>
<cfset variables.instance.name=""/>
<cfset variables.instance.orderno=1/>
<cfset variables.instance.isActive=1/>
<cfset variables.instance.categoryID=""/>
<cfset variables.instance.attributes=""/>
<cfset variables.instance.errors=structnew() />


<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="configBean">
	<cfargument name="contentRenderer">
	
	<cfset variables.configBean=arguments.configBean />
	<cfset variables.contentRenderer=arguments.contentRenderer />
	<cfset variables.dsn=variables.configBean.getDatasource()/>
	<cfreturn this />
</cffunction>

<cffunction name="getAttributeBean" returnType="any">
<cfset var attribute = createObject("component","mura.extend.extendAttribute").init(variables.configBean,variables.contentRenderer) />
<cfset attribute.setExtendSetID(getExtendSetID())/>
<cfreturn attribute />
</cffunction>

<cffunction name="set" returnType="void" output="false" access="public">
		<cfargument name="data" type="any" required="true">

		<cfset var prop=""/>
		
		<cfif isquery(arguments.data)>
			<cfset setSiteID(arguments.data.siteID) />
			<cfset setExtendSetID(arguments.data.ExtendSetID) />
			<cfset setName(arguments.data.name) />
			<cfset setSubTypeID(arguments.data.subTypeID) />
			<cfset setCategoryID(arguments.data.CategoryID) />
			<cfset setOrderNo(arguments.data.orderno) />
			<cfset setIsActive(arguments.data.isActive) />
			
		<cfelseif isStruct(arguments.data)>
		
			<cfloop collection="#arguments.data#" item="prop">
				<cfif isdefined("variables.instance.#prop#")>
					<cfset evaluate("set#prop#(arguments.data[prop])") />
				</cfif>
			</cfloop>
			
		</cfif>
		
		<cfset validate() />
		
</cffunction>
  
<cffunction name="validate" access="public" output="false" returntype="void">
	<cfset variables.instance.errors=structnew() />
</cffunction>

<cffunction name="getErrors" returnType="struct" output="false" access="public">
    <cfreturn variables.instance.errors />
</cffunction>

<cffunction name="getSiteID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.siteID />
</cffunction>

<cffunction name="setSiteID" access="public" output="false">
	<cfargument name="siteID" type="String" />
	<cfset variables.instance.siteID = trim(arguments.siteID) />
</cffunction>

<cffunction name="getExtendSetID" returntype="String" access="public" output="false">
	<cfif not len(variables.instance.ExtendSetID)>
		<cfset variables.instance.ExtendSetID = createUUID() />
	</cfif>
	<cfreturn variables.instance.ExtendSetID />
</cffunction>

<cffunction name="setExtendSetID" access="public" output="false">
	<cfargument name="ExtendSetID" type="String" />
	<cfset variables.instance.ExtendSetID = trim(arguments.ExtendSetID) />
</cffunction>

<cffunction name="getName" returntype="String" access="public" output="false">
	<cfreturn variables.instance.name />
</cffunction>

<cffunction name="setName" access="public" output="false">
	<cfargument name="name" type="String" />
	<cfset variables.instance.name = trim(arguments.name) />
</cffunction>

<cffunction name="getSubTypeID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.SubTypeID />
</cffunction>

<cffunction name="setSubTypeID" access="public" output="false">
	<cfargument name="SubTypeID" type="String" />
	<cfset variables.instance.SubTypeID = trim(arguments.SubTypeID) />
</cffunction>

<cffunction name="getOrderNo" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.OrderNo />
</cffunction>

<cffunction name="setOrderNo" access="public" output="false">
	<cfargument name="OrderNo" />
	<cfif isNumeric(arguments.OrderNo)>
	<cfset variables.instance.OrderNo = arguments.OrderNo />
	</cfif>
</cffunction>

<cffunction name="getCategoryID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.CategoryID />
</cffunction>

<cffunction name="setCategoryID" access="public" output="false">
	<cfargument name="CategoryID" type="String" />
	<cfset variables.instance.CategoryID = trim(arguments.CategoryID) />
</cffunction>

<cffunction name="getIsActive" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.IsActive />
</cffunction>

<cffunction name="setIsActive" access="public" output="false">
	<cfargument name="IsActive"/>
	<cfif isNumeric(arguments.isActive)>
		<cfset variables.instance.IsActive = arguments.IsActive />
	</cfif>
</cffunction>

<cffunction name="getAttributesQuery" access="public" returntype="query">
<cfset var rs=""/>

		<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		select *
		from tclassextendattributes 
		where tclassextendattributes.ExtendSetID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getExtendSetID()#">
		order by tclassextendattributes.orderno,tclassextendattributes.name
		</cfquery>
		
	<cfreturn rs />
</cffunction>


<cffunction name="load" access="public" returntype="any">
	<cfset var rs=""/>
	
	<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select extendSetID,subTypeID,categoryID,siteID,name,orderno,isActive from tclassextendsets
	where ExtendSetID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getExtendSetID()#">
	</cfquery>
	
	<cfif rs.recordcount>
		<cfset set(rs) />
	</cfif>

</cffunction>

<cffunction name="loadAttributes" access="public" returntype="void">
	<cfset var rsAttributes=""/>
	<cfset var tempArray=""/>
	<cfset var attribute=""/>
	<cfset var a=0/>

	<cfset variables.instance.attributes=arrayNew(1)/>

	<cfset rsAttributes=getAttributesQuery() />
	
	<cfif rsAttributes.recordcount>
		
		<cfset tempArray=createObject("component","mura.queryTool").init(rsAttributes).toArray() />
		
		<cfloop from="1" to="#rsAttributes.recordcount#" index="a">
			<cfset attribute=createObject("component","mura.extend.extendAttribute").init(variables.configBean,variables.contentRenderer) />
			<cfset attribute.set(tempArray[a]) />
			<cfset arrayAppend(variables.instance.attributes,attribute)/>
		</cfloop>
			
	</cfif>
	
</cffunction>

<cffunction name="getAttributes" access="public" returntype="any">
	<cfif not isArray(variables.instance.attributes)>
		<cfset loadAttributes()/>
	</cfif>
	<cfreturn variables.instance.attributes />
</cffunction>

<cffunction name="save"  access="public" output="false" returntype="void">
<cfset var rs=""/>

	<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select ExtendSetID from tclassextendsets where ExtendSetID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getExtendSetID()#">
	</cfquery>
	
	<cfif rs.recordcount>
		
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tclassextendsets set
		siteID=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSiteID() neq '',de('no'),de('yes'))#" value="#getSiteID()#">,
		name=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getName() neq '',de('no'),de('yes'))#" value="#getName()#">,
		subtypeID=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSubTypeID() neq '',de('no'),de('yes'))#" value="#getSubTypeID()#">,
		categoryID=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getCategoryID() neq '',de('no'),de('yes'))#" value="#getCategoryID()#">,
		isActive=#getIsActive()#,
		orderno=#getOrderno()#
		where ExtendSetID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getExtendSetID()#">
		</cfquery>
		
	<cfelse>
	
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		Insert into tclassextendsets (ExtendSetID,siteID,name,subtypeid,isActive,orderno,categoryID) 
		values(
		<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getExtendSetID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSiteID() neq '',de('no'),de('yes'))#" value="#getSiteID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getName() neq '',de('no'),de('yes'))#" value="#getName()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSubTypeID() neq '',de('no'),de('yes'))#" value="#getSubTypeID()#">,
		#getIsActive()#,
		#getOrderno()#,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getCategoryID() neq '',de('no'),de('yes'))#" value="#getCategoryID()#">)
		</cfquery>
	</cfif>
	
</cffunction>

<cffunction name="delete"  access="public" output="false" returntype="void">
	<cfset var rs=getAttributesQuery() />
	<cfset var attribute=""/>
	
	<cfloop query="rs">
		<cfset attribute=getAttributeBean() />
		<cfset attribute.setAttributeID(rs.attributeID)/>
		<cfset attribute.delete() />
	</cfloop>

	<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tclassextendsets where extendSetID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getExtendSetID()#">
	</cfquery>

</cffunction>

<cffunction name="addAttribute" access="public" output="false" returntype="void">
<cfargument name="rawdata">
<cfset var attribute=""/>
<cfset var data=arguments.rawdata />

	<cfset data.ExtendSetID=getExtendSetID()/>
	<cfset data.siteID=getSiteID()/>	
	<cfset attribute=getAttributeBean() />
	<cfset attribute.set(data)/>
	<cfset attribute.save()/>
	<cfset arrayApprend(variables.instance.attributes,attribute)/>
</cffunction>

<cffunction name="deleteAttribute" access="public" output="false" returntype="void">
<cfargument name="attributeID">
<cfset var attribute=""/>

	<cfset attribute=getAttributeBean() />
	<cfset attribute.setAttributeID(arguments.attributeID)/>
	<cfset attribute.delete()/>
	<cfset loadAttributes()/>
</cffunction>


<cffunction name="getStyle" ouput="false" returntype="string">
<cfargument name="memberID" required="true" default=""/>
<cfset var m=0/>
<cfif not len(getCategoryID())>
	<cfreturn ""/>
<cfelse>
	<cfif len(arguments.memberID)>
		<cfloop list="#arguments.memberID#" index="m">
			<cfif listFind(getCategotyID(),m)>
				<cfreturn ""/>	
			</cfif>
		</cfloop>
	</cfif>
	
	<cfreturn 'style="display:none;"'/>
</cfif>

</cffunction>
</cfcomponent>