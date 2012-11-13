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
<cfcomponent output="false">
<cfset variables.translator=""/>

<cffunction name="init" returntype="any" access="public" output="false">
	<cfreturn this />
</cffunction>	

<cffunction name="setValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="propertyValue" default="" >

	<cfset variables["#arguments.property#"]=arguments.propertyValue />
	<cfreturn this>
</cffunction>

<cffunction name="getValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="defaultValue">
	
	<cfif structKeyExists(variables,"#arguments.property#")>
		<cfreturn variables["#arguments.property#"] />
	<cfelseif structKeyExists(arguments,"defaultValue")>
		<cfset variables["#arguments.property#"]=arguments.defaultValue />
		<cfreturn variables["#arguments.property#"] />
	<cfelse>
		<cfreturn "" />
	</cfif>

</cffunction>

<cffunction name="valueExists" returntype="any" access="public" output="false">
	<cfargument name="property" type="string" required="true">
		<cfreturn structKeyExists(variables,arguments.property) />
</cffunction>

<cffunction name="removeValue" access="public" output="false">
	<cfargument name="property" type="string" required="true"/>
		<cfset structDelete(variables,arguments.property) />
		<cfreturn this>
</cffunction>

<cffunction name="getConfigBean" returntype="any" access="public" output="false">
	<cfreturn application.configBean />	
</cffunction>
 
<cffunction name="getServiceFactory" returntype="any" access="public" output="false">
	<cfreturn application.serviceFactory />	
</cffunction>

<cffunction name="getBean" returntype="any" access="public" output="false">
	<cfargument name="beanName">
	<cfargument name="siteID" default="">
	<cfset var bean="">
	
	<cfset bean=getServiceFactory().getBean(arguments.beanName) />

	<cfif structKeyExists(bean,"setSiteID")>		
		<cfif len(arguments.siteID)>
			<cfset bean.setSiteID(arguments.siteID)>			
		<cfelseif isDefined("getSiteID")>
			<cfset bean.setSiteID(getSiteID())>
		<cfelseif len(getValue("siteID"))>
			<cfset bean.setSiteID(getValue("siteID"))>		
		</cfif>		
	</cfif>
	
	<cfreturn bean>
	
</cffunction>

<cffunction name="getPluginManager" returntype="any" access="public" output="false">
	<cfreturn application.pluginManager />	
</cffunction>

<cffunction name="getEventManager" returntype="any" access="public" output="false" hint="The eventManager is the same as the pluginManager.">
	<cfreturn application.eventManager />	
</cffunction>

<cffunction name="getCurrentUser" returntype="any" access="public" output="false">
	<cfif not structKeyExists(request,"currentUser")>
		<cfset request.currentUser=createObject("component","mura.user.sessionUserFacade").init() />
	</cfif>
	<cfreturn request.currentUser>	
</cffunction>

<cffunction name="getPlugin" returntype="any" access="public" output="false">
	<cfargument name="ID">
	<cfargument name="siteID" required="true" default="">
	<cfargument name="cache" required="true" default="true">
	
	<cfreturn application.pluginManager.getConfig(arguments.ID, arguments.siteID, arguments.cache) />	
</cffunction>

<cffunction name="injectMethod" access="public" output="false">
	<cfargument name="toObjectMethod" type="string" required="true" />
	<cfargument name="fromObjectMethod" type="any" required="true" />
	<cfset this[ arguments.toObjectMethod ] =  arguments.fromObjectMethod  />
	<cfset variables[ arguments.toObjectMethod ] =  arguments.fromObjectMethod />
	<cfreturn this>
</cffunction>

<cffunction name="deleteMethod" access="public" output="false">
	<cfargument name="methodName" type="any" required="true" />
	<cfset StructDelete(this,arguments.methodName)>
	<cfset StructDelete(variables,arguments.methodName)>
</cffunction>

<cffunction name="getAsJSON" access="public" output="false" returntype="String" >
	<cfset var data = getAsStruct() />
	<cfreturn serializeJSON( data ) />
</cffunction>

<cffunction name="getAsStruct" access="public" output="false" returntype="struct">
	<cfset var data			= "">
	<cfset var iiX			= "">
	<cfset var subBeans		= StructNew()>
	<cfset var subData		= StructNew()>
	<cfset var subItem		= "">
	<cfset var iiY			= "">

	<cfif not StructKeyExists(this,"getAllValues")>
		<cfreturn "" />
	</cfif>
	
	<cfset data = getAllValues() />

	<cfloop collection="#data#" item="iiX">
		<cfif isInstanceOf(data[iiX],"cfobject")>
			<cfset data[iiX] = data[iiX].getAsStruct() />
		<cfelseif isStruct( data[iiX] ) and StructCount( data[iiX] )>
			<cfset subBeans = data[iiX] />
			<cfset subData	= StructNew()>
			<cfloop collection="#subBeans#" item="iiY">
				<cfset subItem = subBeans[iiY] />
				<cfif isInstanceOf(subItem,"cfobject")>
					<cfset subData[iiY] = subItem.getAsStruct() />
				<cfelseif isStruct(subItem)>
					<cfset subData[iiY] = subItem />
				</cfif>
 			</cfloop>
			<cfif structCount( subData )>
				<cfset data[iiX] = subData />
			</cfif>
		<cfelseif isJSON(data[iiX])>
			<cfset data[iiX] = deserializeJSON( data[iiX] ) />
		</cfif> 
	</cfloop>
		
	<cfreturn data />
</cffunction>

<cffunction name="initTracePoint" output="false">
	<cfargument name="detail">
	<cfset var tracePoint=structNew()>
	<cfif not request.muraShowTrace>
		<cfreturn 0>
	</cfif>
	<cfset tracePoint.detail=arguments.detail>
	<cfset tracePoint.start=getTickCount()>
	<cfset arrayAppend(request.muraTraceRoute,tracePoint)> 
	<cfreturn arrayLen(request.muraTraceRoute)>
</cffunction>

<cffunction name="commitTracePoint" output="false">
	<cfargument name="tracePointID">
	<cfset var tracePoint="">
	<cfif arguments.tracePointID>
		<cfset tracePoint=request.muraTraceRoute[arguments.tracePointID]>
		<cfset tracePoint.stop=getTickCount()>
		<cfset tracePoint.duration=tracePoint.stop-tracePoint.start>
		<cfset tracePoint.total=tracePoint.stop-request.muraRequestStart>
	</cfif>	
</cffunction>

</cfcomponent>
