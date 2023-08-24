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
<cfcomponent extends="mura.cfobject" output="false" hint="Provide extend set CRUD functionality">

<cfset variables.instance.ExtendSetID="" />
<cfset variables.instance.subTypeID=""/>
<cfset variables.instance.siteID=""/>
<cfset variables.instance.container="Default"/>
<cfset variables.instance.name=""/>
<cfset variables.instance.orderno=1/>
<cfset variables.instance.isActive=1/>
<cfset variables.instance.categoryID=""/>
<cfset variables.instance.attributes=""/>
<cfset variables.instance.isNew=1/>
<cfset variables.instance.errors=structnew() />


<cffunction name="init" output="false">
	<cfargument name="configBean">
	<cfargument name="contentRenderer">

	<cfset variables.configBean=arguments.configBean />
	<cfset variables.contentRenderer=arguments.contentRenderer />
	<cfset variables.classExtensionManager=variables.configBean.getClassExtensionManager()>

	<cfreturn this />
</cffunction>

<cffunction name="getAttributeBean">
<cfset var attribute = createObject("component","mura.extend.extendAttribute").init(variables.configBean,variables.contentRenderer) />
<cfset attribute.setExtendSetID(getExtendSetID())/>
<cfset attribute.setSiteID(getSiteID())/>
<cfreturn attribute />
</cffunction>

<cffunction name="set" output="false">
		<cfargument name="property" required="true">
		<cfargument name="propertyValue">

		<cfif not isDefined('arguments.data')>
			<cfif isSimpleValue(arguments.property)>
				<cfreturn setValue(argumentCollection=arguments)>
			</cfif>

			<cfset arguments.data=arguments.property>
		</cfif>

		<cfset var prop=""/>
		<cfset var tempFunc="">

		<cfif isquery(arguments.data)>
			<cfset setSiteID(arguments.data.siteID) />
			<cfset setExtendSetID(arguments.data.ExtendSetID) />
			<cfset setName(arguments.data.name) />
			<cfset setSubTypeID(arguments.data.subTypeID) />
			<cfset setCategoryID(arguments.data.CategoryID) />
			<cfset setOrderNo(arguments.data.orderno) />
			<cfset setIsActive(arguments.data.isActive) />
			<cfset setContainer(arguments.data.container) />

		<cfelseif isStruct(arguments.data)>

			<cfloop collection="#arguments.data#" item="prop">
				<cfif isValid('variableName',prop) and isDefined("this.set#prop#")>
					<cfset tempFunc=this["set#prop#"]>
          			<cfset tempFunc(arguments.data['#prop#'])>
				</cfif>
			</cfloop>

		</cfif>

		<cfset validate() />
		<cfreturn this>
</cffunction>

<cffunction name="validate" output="false">
	<cfset variables.instance.errors=structnew() />
	<cfreturn this>
</cffunction>

<cffunction name="getErrors" returnType="struct" output="false">
    <cfreturn variables.instance.errors />
</cffunction>

<cffunction name="getSiteID" output="false">
	<cfreturn variables.instance.siteID />
</cffunction>

<cffunction name="setSiteID" output="false">
	<cfargument name="siteID" type="String" />
	<cfset variables.instance.siteID = trim(arguments.siteID) />
	<cfreturn this>
</cffunction>

<cffunction name="getExtendSetID" output="false">
	<cfif not len(variables.instance.ExtendSetID)>
		<cfset variables.instance.ExtendSetID = createUUID() />
	</cfif>
	<cfreturn variables.instance.ExtendSetID />
</cffunction>

<cffunction name="setExtendSetID" output="false">
	<cfargument name="ExtendSetID" type="String" />
	<cfset variables.instance.ExtendSetID = trim(arguments.ExtendSetID) />
	<cfreturn this>
</cffunction>

<cffunction name="getName" output="false">
	<cfreturn variables.instance.name />
</cffunction>

<cffunction name="setName" output="false">
	<cfargument name="name" type="String" />
	<cfset variables.instance.name = trim(arguments.name) />
	<cfreturn this>
</cffunction>

<cffunction name="getSubTypeID" output="false">
	<cfreturn variables.instance.SubTypeID />
</cffunction>

<cffunction name="setSubTypeID" output="false">
	<cfargument name="SubTypeID" type="String" />
	<cfset variables.instance.SubTypeID = trim(arguments.SubTypeID) />
	<cfreturn this>
</cffunction>

<cffunction name="getOrderNo" output="false">
	<cfreturn variables.instance.OrderNo />
</cffunction>

<cffunction name="setOrderNo" output="false">
	<cfargument name="OrderNo" />
	<cfif isNumeric(arguments.OrderNo)>
	<cfset variables.instance.OrderNo = arguments.OrderNo />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getCategoryID" output="false">
	<cfreturn variables.instance.CategoryID />
</cffunction>

<cffunction name="setCategoryID" output="false">
	<cfargument name="CategoryID" type="String" />
	<cfset variables.instance.CategoryID = trim(arguments.CategoryID) />
	<cfreturn this>
</cffunction>

<cffunction name="getIsActive" output="false">
	<cfreturn variables.instance.IsActive />
</cffunction>

<cffunction name="setIsActive" output="false">
	<cfargument name="IsActive"/>
	<cfif isBoolean(arguments.IsActive)>
		<cfif arguments.IsActive>
			<cfset variables.instance.IsActive = 1 />
		<cfelse>
			<cfset variables.instance.IsActive = 0 />
		</cfif>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getContainer" output="false">
	<cfreturn variables.instance.Container />
</cffunction>

<cffunction name="setContainer" output="false">
	<cfargument name="container" />
	<cfif len(arguments.container)>
		<cfset variables.instance.container = arguments.container />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getIsNew" output="false">
	<cfreturn variables.instance.isNew>
</cffunction>

<cffunction name="exists" output="false">
	<cfreturn not variables.instance.isNew>
</cffunction>

<cffunction name="setIsNew" output="false">
	<cfargument name="isNew">
	<cfset variables.instance.isNew=arguments.isNew>
	<cfreturn this>
</cffunction>

<cffunction name="getAttributesQuery">
<cfset var rs=""/>

		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
		select *
		from tclassextendattributes
		where tclassextendattributes.ExtendSetID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getExtendSetID()#">
		order by tclassextendattributes.orderno,tclassextendattributes.name
		</cfquery>

	<cfreturn rs />
</cffunction>

<cffunction name="load">
	<cfset var rs=""/>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
        select extendSetID,subTypeID,categoryID,siteID,name,orderno,isActive,container from tclassextendsets
        where
        <cfif len(getName()) and len(getSubTypeID())>
          name=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="50" value="#getName()#" />
          and SubTypeID=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#getSubTypeID()#" />
         <cfelse>
           ExtendSetID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getExtendSetID()#">
         </cfif>
    </cfquery>

    <cfif rs.recordcount>
          <cfset set(rs) />
          <cfset setIsNew(0)>
     </cfif>

	<cfreturn this>
</cffunction>

<cffunction name="loadAttributes">
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
			<cfset attribute.setIsNew(0)>
			<cfset arrayAppend(variables.instance.attributes,attribute)/>
		</cfloop>

	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getAttributes">
	<cfif not isArray(variables.instance.attributes)>
		<cfset loadAttributes()/>
	</cfif>
	<cfreturn variables.instance.attributes />
</cffunction>

<cffunction name="save"  output="false">
<cfset var rs=""/>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	select ExtendSetID from tclassextendsets where ExtendSetID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getExtendSetID()#">
	</cfquery>

	<cfif rs.recordcount>

		<cfquery>
		update tclassextendsets set
		siteID=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSiteID() neq '',de('no'),de('yes'))#" value="#getSiteID()#">,
		name=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getName() neq '',de('no'),de('yes'))#" value="#getName()#">,
		subtypeID=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSubTypeID() neq '',de('no'),de('yes'))#" value="#getSubTypeID()#">,
		categoryID=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getCategoryID() neq '',de('no'),de('yes'))#" value="#getCategoryID()#">,
		isActive=#getIsActive()#,
		orderno=#getOrderno()#,
		container=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getContainer()#">
		where ExtendSetID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getExtendSetID()#">
		</cfquery>

	<cfelse>

		<cfquery>
		Insert into tclassextendsets (ExtendSetID,siteID,name,subtypeid,isActive,orderno,categoryID,container)
		values(
		<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getExtendSetID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSiteID() neq '',de('no'),de('yes'))#" value="#getSiteID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getName() neq '',de('no'),de('yes'))#" value="#getName()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSubTypeID() neq '',de('no'),de('yes'))#" value="#getSubTypeID()#">,
		#getIsActive()#,
		#getOrderno()#,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getCategoryID() neq '',de('no'),de('yes'))#" value="#getCategoryID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getContainer()#">)
		</cfquery>
	</cfif>

	<cfset variables.classExtensionManager.purgeDefinitionsQuery()>

	<cfreturn this>
</cffunction>

<cffunction name="delete"  output="false">
	<cfset var rs=getAttributesQuery() />
	<cfset var attribute=""/>

	<cfloop query="rs">
		<cfset attribute=getAttributeBean() />
		<cfset attribute.setAttributeID(rs.attributeID)/>
		<cfset attribute.delete() />
	</cfloop>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	delete from tclassextendsets where extendSetID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getExtendSetID()#">
	</cfquery>

	<cfset variables.classExtensionManager.purgeDefinitionsQuery()>

</cffunction>

<cffunction name="getAttributeByName" output="false">
<cfargument name="name">
<cfset var attributes=getAttributes()/>
<cfset var i=0/>
<cfset var attribute=""/>
	<cfif arrayLen(attributes)>
	<cfloop from="1" to="#arrayLen(attributes)#" index="i">
		<cfif attributes[i].getName() eq arguments.name>
			<cfreturn attributes[i]/>
		</cfif>
	</cfloop>
	</cfif>

	<cfset attribute=getAttributeBean()>
	<cfset attribute.setName(arguments.name)>
	<cfreturn attribute/>
</cffunction>

<cffunction name="addAttribute" output="false">
<cfargument name="rawdata">
<cfset var attribute=""/>
<cfset var data=arguments.rawdata />

	<cfif not isObject(data)>
		<cfset attribute=getAttributeBean() />
		<cfset attribute.set(data)/>
	<cfelse>
		<cfset attribute=data />
	</cfif>

	<cfset attribute.setExtendSetID(getExtendSetID())/>
	<cfset attribute.setSiteID(getSiteID())/>
	<cfset attribute.save()/>
	<cfset arrayAppend(getAttributes(),attribute)/>
	<cfreturn this>
</cffunction>

<cffunction name="deleteAttribute" output="false">
<cfargument name="attributeID">
<cfset var attribute=""/>

	<cfset attribute=getAttributeBean() />
	<cfset attribute.setAttributeID(arguments.attributeID)/>
	<cfset attribute.delete()/>
	<cfset loadAttributes()/>
	<cfreturn this>
</cffunction>

<cffunction name="getStyle" ouput="false">
<cfargument name="memberID" required="true" default=""/>

	<cfreturn ""/>
	<!---
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
	--->
</cffunction>

<cffunction name="getAllValues" ouput="false">

 	<cfset var extensionData = {} />
	<cfset var atts = getAttributes() />
	<cfset var attStruct = {} />
	<cfset var i = 0 />

	<cftry>
		<cfset extensionData = duplicate(variables.instance) />
		<cfset structDelete(extensionData,"errors") />
		<cfcatch></cfcatch>
	</cftry>

	<cfset extensionData.attributes = [] />

	<cfloop from="1" to="#ArrayLen(atts)#" index="i">
		<cfset attStruct = atts[i].getAllValues() />
		<cfset ArrayAppend(extensionData.attributes,attStruct ) />
	</cfloop>

	<cfreturn extensionData />
</cffunction>

<cffunction name="getAsXML" ouput="false" returntype="xml">
	<cfargument name="documentXML">
	<cfargument name="includeIDs" type="boolean" default="false" >

	<cfset var extensionData = {} />
	<cfset var atts = getAttributes() />
	<cfset var item = "" />
	<cfset var i = 0 />

	<cfset var xmlAttributeSet = XmlElemNew( documentXML, "", "attributeset" ) />
	<cfset var xmlAttributes = "" />

	<cfset extensionData = duplicate(variables.instance) />
	<cfset structDelete(extensionData,"errors") />

	<cfif not(arguments.includeIDs)>
		<cfset structDelete(extensionData,"extendsetID") />
		<cfset structDelete(extensionData,"subTypeID") />
	</cfif>

	<cfset structDelete(extensionData,"isNew") />
	<cfset structDelete(extensionData,"isActive") />
	<cfset structDelete(extensionData,"siteid") />
	<cfset structDelete(extensionData,"fromMuraCache") />
	<cfset structDelete(extensionData,"saveerrors") />

	<cfloop collection="#extensionData#" item="item">
		<cfif isSimpleValue(extensionData[item])>
			<cfset xmlAttributeSet.XmlAttributes[lcase(item)] = extensionData[item] />
		</cfif>
	</cfloop>

	<cfloop from="1" to="#ArrayLen(atts)#" index="i">
		<cfset var xmlAttributes = atts[i].getAsXML(documentXML) />
		<cfset ArrayAppend(
			xmlAttributeSet.XmlChildren,
			xmlAttributes
			) />
	</cfloop>

	<cfreturn xmlAttributeSet />
</cffunction>



</cfcomponent>
