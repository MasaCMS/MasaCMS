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

<cffunction name="init" returntype="any" output="false" access="public">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="adZoneGateway" type="any" required="yes"/>
<cfargument name="adZoneDAO" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>
	<cfset variables.instance.configBean=arguments.configBean />
	<cfset variables.instance.gateway=arguments.adZoneGateway />
	<cfset variables.instance.DAO=arguments.adZoneDAO />
	<cfset variables.instance.globalUtility=arguments.utility />
	<cfreturn this />
</cffunction>

<cffunction name="getadzonesBySiteID" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="keywords"  type="string" required="true" default=""/>

	<cfreturn variables.instance.gateway.getadzonesBySiteID(arguments.siteid,arguments.keywords) />
</cffunction>

<cffunction name="create" access="public" returntype="any" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>		
	
	<cfset var adZoneBean=application.serviceFactory.getBean("adZoneBean") />
	<cfset adZoneBean.set(arguments.data) />
	
	<cfif structIsEmpty(adZoneBean.getErrors())>
		<cfset adZoneBean.setLastUpdateBy("#listGetAt(getAuthUser(),2,'^')#") />
		<cfset adZoneBean.setAdZoneID("#createUUID()#") />
		<cfset variables.instance.globalUtility.logEvent("AdZoneID:#adZoneBean.getAdZoneID()# Name:#adZoneBean.getName()# was created","sava-advertising","Information",true) />
		<cfset variables.instance.DAO.create(adZoneBean) />
	</cfif>
	
	<cfreturn adZoneBean />
</cffunction>

<cffunction name="read" access="public" returntype="any" output="false">
	<cfargument name="adZoneID" type="String" />		
	
	<cfreturn variables.instance.DAO.read(arguments.adZoneID) />

</cffunction>

<cffunction name="update" access="public" returntype="any" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>		
	
	<cfset var adZoneBean=variables.instance.DAO.read(arguments.data.adZoneID) />
	<cfset adZoneBean.set(arguments.data) />
	
	<cfif structIsEmpty(adZoneBean.getErrors())>
		<cfset variables.instance.globalUtility.logEvent("AdZoneID:#adZoneBean.getAdZoneID()# Name:#adZoneBean.getName()# was updated","sava-advertising","Information",true) />
		<cfset adZoneBean.setLastUpdateBy("#listGetAt(getAuthUser(),2,'^')#") />
		<cfset variables.instance.DAO.update(adZoneBean) />
	</cfif>
	
	<cfreturn adZoneBean />
</cffunction>

<cffunction name="delete" access="public" returntype="void" output="false">
	<cfargument name="adZoneID" type="String" />		
	
	<cfset var adZoneBean=read(arguments.adZoneID) />
	<cfset variables.instance.globalUtility.logEvent("AdZoneID:#arguments.adZoneID# Name:#adZoneBean.getName()# was created","sava-advertising","Information",true) />
	<cfset variables.instance.DAO.delete(arguments.adZoneID) />

</cffunction>
</cfcomponent>