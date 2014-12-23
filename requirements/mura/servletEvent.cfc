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
<cfcomponent output="false" extends="mura.cfobject">

<cffunction name="init" returntype="any" access="public" output="false">
	
	
	<cfscript>
	if (NOT IsDefined("request"))
	    request=structNew();
	StructAppend(request, url, "no");
	StructAppend(request, form, "no");
	
	if (IsDefined("request.muraGlobalEvent")){
		StructAppend(request, request.muraGlobalEvent.getAllValues(), "no");
		StructDelete(request,"muraGlobalEvent");	
	}
	</cfscript>
	
	<cfparam name="request.doaction" default=""/>
	<cfparam name="request.month" default="#month(now())#"/>
	<cfparam name="request.year" default="#year(now())#"/>
	<cfparam name="request.display" default=""/>
	<cfparam name="request.startrow" default="1"/>
	<cfparam name="request.pageNum" default="1"/>
	<cfparam name="request.keywords" default=""/>
	<cfparam name="request.tag" default=""/>
	<cfparam name="request.mlid" default=""/>
	<cfparam name="request.noCache" default="0"/>
	<cfparam name="request.categoryID" default=""/>
	<cfparam name="request.relatedID" default=""/>
	<cfparam name="request.linkServID" default=""/>
	<cfparam name="request.track" default="1"/>
	<cfparam name="request.exportHTMLSite" default="0"/>
	<cfparam name="request.returnURL" default=""/>
	<cfparam name="request.showMeta" default="0"/>
	<cfparam name="request.forceSSL" default="0"/>
	<cfparam name="request.muraForceFilename" default="true"/>

	<cfset setValue('HandlerFactory',application.pluginManager.getStandardEventFactory(getValue('siteid')))>
	<cfset setValue("MuraScope",createObject("component","mura.MuraScope"))>
	<cfset getValue('MuraScope').setEvent(this)>
	<cfreturn this />
</cffunction>

<cffunction name="setValue" returntype="any" access="public" output="false">
	<cfargument name="property"  type="string" required="true">
	<cfargument name="propertyValue" default="" >
	<cfargument name="scope" default="request" required="true">
	
	<cfset var theScope=getScope(arguments.scope) />

	<cfset theScope["#arguments.property#"]=arguments.propertyValue />
	<cfreturn this>
</cffunction>

<cffunction name="set" output="false">
	<cfargument name="property"  type="string" required="true">
	<cfargument name="defaultValue">
	<cfargument name="scope" default="request" required="true">
	<cfreturn setValue(argumentCollection=arguments)>
</cffunction>

<cffunction name="getValue" returntype="any" access="public" output="false">
	<cfargument name="property"  type="string" required="true">
	<cfargument name="defaultValue">
	<cfargument name="scope" default="request" required="true">
	<cfset var theScope=getScope(arguments.scope)>
	
	<cfif structKeyExists(theScope,"#arguments.property#")>
		<cfreturn theScope["#arguments.property#"] />
	<cfelseif structKeyExists(arguments,"defaultValue")>
		<cfset theScope["#arguments.property#"]=arguments.defaultValue />
		<cfreturn theScope["#arguments.property#"] />
	<cfelse>
		<cfreturn "" />
	</cfif>

</cffunction>

<cffunction name="get" output="false">
	<cfargument name="property"  type="string" required="true">
	<cfargument name="defaultValue">
	<cfargument name="scope" default="request" required="true">
	<cfreturn getValue(argumentCollection=arguments)>
</cffunction>

<cffunction name="getAllValues" returntype="any" access="public" output="false">
<cfargument name="scope" default="request" required="true">
		<cfreturn getScope(arguments.scope)  />
</cffunction>

<cffunction name="getScope" returntype="struct" access="public" output="false">
<cfargument name="scope" default="request" required="true">
		
		<cfswitch expression="#arguments.scope#">
		<cfcase value="request">
			<cfreturn request />
		</cfcase>
		<cfcase value="form">
			<cfreturn form />
		</cfcase>
		<cfcase value="url">
			<cfreturn url />
		</cfcase>
		<cfcase value="session">
			<cfreturn session />
		</cfcase>
		<cfcase value="server">
			<cfreturn server />
		</cfcase>
		<cfcase value="application">
			<cfreturn application />
		</cfcase>
		<cfcase value="attributes">
			<cfreturn attributes />
		</cfcase>
		<cfcase value="cluster">
			<cfreturn cluster />
		</cfcase>
		</cfswitch>
		
</cffunction>

<cffunction name="valueExists" returntype="any" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfargument name="scope" default="request" required="true">
		<cfset var theScope=getScope(arguments.scope) />
		<cfreturn structKeyExists(theScope,arguments.property) />
</cffunction>

<cffunction name="removeValue" access="public" output="false">
	<cfargument name="property" type="string" required="true"/>
	<cfargument name="scope" default="request" required="true">
		<cfset var theScope=getScope(arguments.scope) />
		<cfset structDelete(theScope,arguments.property) />
</cffunction>

<cffunction name="getHandler" returntype="any" access="public" output="false">
	<cfargument name="handler">
	<cfreturn getValue('HandlerFactory').get(arguments.handler & "Handler",getValue("localHandler")) />	
</cffunction>

<cffunction name="getValidator" returntype="any" access="public" output="false">
	<cfargument name="validation">
	<cfreturn getValue('HandlerFactory').get(arguments.validation & "Validator",getValue("localHandler")) />	
</cffunction>

<cffunction name="getTranslator" returntype="any" access="public" output="false">
	<cfargument name="translator">
	<cfreturn getValue('HandlerFactory').get(arguments.translator & "Translator",getValue("localHandler")) />	
</cffunction>

<cffunction name="getContentRenderer" returntype="any" access="public" output="false">
	<cfreturn getValue('contentRenderer') />	
</cffunction>

<cffunction name="getThemeRenderer" returntype="any" access="public" output="false" hint="deprecated: use getContentRenderer()">
	<cfreturn getContentRenderer() />	
</cffunction>

<cffunction name="getContentBean" returntype="any" access="public" output="false">
	<cfreturn getValue('contentBean') />	
</cffunction>

<cffunction name="getCrumbData" returntype="any" access="public" output="false">
	<cfreturn getValue('crumbdata') />	
</cffunction>

<cffunction name="getSite" returntype="any" access="public" output="false">
	<cfreturn application.settingsManager.getSite(getValue('siteid')) />	
</cffunction>

<cffunction name="getMuraScope" returntype="any" access="public" output="false">
	<cfreturn getValue("MuraScope") />	
</cffunction>

<cffunction name="getBean" returntype="any" access="public" output="false">
	<cfargument name="beanName">
	<cfargument name="siteID" required="false">
	
	<cfif structKeyExists(arguments,"siteid")>
		<cfreturn super.getBean(arguments.beanName,arguments.siteID)>
	<cfelse>
		<cfreturn super.getBean(arguments.beanName,getValue('siteid'))>
	</cfif>
</cffunction>

</cfcomponent>

