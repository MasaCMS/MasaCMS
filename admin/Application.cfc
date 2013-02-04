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
<cfcomponent extends="framework" ouput="false">

	<cfsetting showdebugoutput="no">
	
	<cfinclude template="../config/applicationSettings.cfm">
	
	<cfif not hasMainMappings>
		<!--- Try and include global mappings --->
		<cfset canWriteMode=true>
		<cfset canWriteMappings=true>
		<cfset hasMappings=true>
		
		<cftry>
			<cfinclude template="../config/mappings.cfm">
			<cfcatch type="missingInclude">
				<cfset hasMappings=false>
			</cfcatch>
		</cftry>
		
		<cfif not hasMappings>	
			<cfinclude template="../config/buildMainMappings.cfm">
		</cfif>
		
	</cfif>
	
	<cfif not hasPluginMappings>
		<!--- Try and include plugin mappings --->
		<cfset canWriteMode=true>
		<cfset hasMappings=true>
		<cfset canWriteMappings=true>
		<cftry>
			<cfinclude template="../plugins/mappings.cfm">
			<cfcatch type="missingInclude">
				<cfset hasMappings=false>
			</cfcatch>
		</cftry>
		
		<cfif not hasMappings>
			<cfinclude template="../config/buildPluginMappings.cfm">
		</cfif>
		
	</cfif>
	
	<cfif not hasPluginCFApplication>
		<!--- Try and include plugin mappings --->
		<cfset canWriteMode=true>
		<cfset hasMappings=true>
		<cfset canWriteMappings=true>
		<cftry>
			<cfinclude template="../plugins/cfapplication.cfm">
			<cfcatch type="missingInclude">
				<cfset hasMappings=false>
			</cfcatch>
		</cftry>
		
		<cfif not hasMappings>
			<cfinclude template="../config/buildPluginCFApplication.cfm">
		</cfif>
		
	</cfif>
	
	<cfset variables.framework=structNew()>
	<cfset variables.framework.home = "home.redirect">
	<cfset variables.framework.action="muraAction">
	<cfset variables.framework.base="/muraWRM/admin/">
	<cfset variables.framework.defaultSubsystem="core">
	<cfset variables.framework.usingSubsystems=true>
	<cfset variables.framework.applicationKey="muraAdmin">
	<cfset variables.framework.siteWideLayoutSubsystem='common'>

	<cfif structKeyExists(form,"fuseaction")>
		<cfset form.muraAction=form.fuseaction>
	</cfif>

	<cfif structKeyExists(url,"fuseaction")>
		<cfset url.muraAction=url.fuseaction>
	</cfif>
	
	<cffunction name="setupApplication" output="false">
		<cfset var local = structNew() />
		
		<cfinclude template="../config/appcfc/onApplicationStart_include.cfm">
	
		<cfif not structKeyExists(application,"muraAdmin") or not hasBeanFactory()>
			<cfscript>
				variables.framework.cache = structNew();
				variables.framework.cache.lastReload = now();
				variables.framework.cache.controllers = structNew();
				variables.framework.cache.services = structNew();
				application[variables.framework.applicationKey] = variables.framework;
				variables.framework.password=application.appreloadkey;
				setBeanFactory( application.serviceFactory );
			</cfscript>
		</cfif>
		
	</cffunction>
	
	<cffunction name="setupRequest" output="false">
		
		<cfset var siteCheck="">
		<cfset var theParam="">
		<cfset var temp="">
		<cfset var page="">
		<cfset var i="">
		<cfset var site="">
		<cfset var local = structNew() />
		
		<cfinclude template="../config/appcfc/onRequestStart_include.cfm">
				
		<cfif right(cgi.script_name, Len("index.cfm")) NEQ "index.cfm" and right(cgi.script_name, Len("error.cfm")) NEQ "error.cfm" AND right(cgi.script_name, 3) NEQ "cfc">
			<cflocation url="index.cfm" addtoken="false">
		</cfif>	

		<cfscript>
			StructAppend(request.context, url, "no");
			StructAppend(request.context, form, "no");
			
			if (IsDefined("request.muraGlobalEvent")){
				StructAppend(request, request.muraGlobalEvent.getAllValues(), "no");
				StructDelete(request,"muraGlobalEvent");	
			}
		</cfscript>
		
		<cfparam name="request.context.moduleid" default="">
		<cfparam name="request.context.siteid" default="">
		<cfparam name="request.context.muraAction" default="">
		<cfparam name="request.context.layout" default=""/>
		<cfparam name="request.context.activetab" default="0"/>
		<cfparam name="request.context.activepanel" default="0"/>
		<cfparam name="request.context.ajax" default="">
		<cfparam name="request.context.rb" default="">
		<cfparam name="request.context.closeCompactDisplay" default="false">
		<cfparam name="request.context.compactDisplay" default="false">
		<cfparam name="session.siteid" default="">
		<cfparam name="session.keywords" default="">
		<cfparam name="session.alerts" default="#structNew()#">
		<cfparam name="cookie.rb" default="">
		<cfset request.context.currentURL="index.cfm?" & cgi.query_string>
	
		<cfif len(request.context.rb)>
			<cfset session.rb=request.context.rb>
			<cfcookie name="rb" value="#session.rb#" expires="never" />
		</cfif>
		
		<cfif not application.configBean.getSessionHistory()  or application.configBean.getSessionHistory() gte 30>
			<cfparam name="session.dashboardSpan" default="30">
		<cfelse>
			<cfparam name="session.dashboardSpan" default="#application.configBean.getSessionHistory()#">
		</cfif>
		
		<cfif not application.configBean.getSessionHistory()  or application.configBean.getSessionHistory() gte 30>
			<cfset session.dashboardSpan=30>
		<cfelse>
			<cfset session.dashboardSpan=application.configBean.getSessionHistory()>
		</cfif>
		
		<cfif request.context.siteid neq '' and (session.siteid neq request.context.siteID)>
			<cfset siteCheck=application.settingsManager.getSites()>
			<cfif structKeyExists(siteCheck,request.context.siteID)>
				<cfset session.siteid = request.context.siteid>
				<cfset session.userFilesPath = "#application.configBean.getAssetPath()#/#request.context.siteid#/assets/">
				<cfset session.topID="00000000000000000000000000000000001">
				<cfset session.openSectionList="">
			</cfif>
		<cfelseif not len(session.siteID)>
			<cfset session.siteID="default">
			<cfset session.userFilesPath = "#application.configBean.getAssetPath()#/default/assets/">	
			<cfset session.topID="00000000000000000000000000000000001">
			<cfset session.openSectionList="">
		</cfif>
		
		<cfset application.rbFactory.resetSessionLocale()>
		
		<cfif not structKeyExists(request.context,"siteid")>
			<cfset request.context.siteID=session.siteID>
		</cfif>

		<cfif not structKeyExists(session.alerts,'#session.siteid#')>
			<cfset session.alerts['#session.siteid#']=structNew()>
		</cfif>
		
		
		<cfset request.event=createObject("component", "mura.event").init(request.context)>
		<cfset request.context.$=request.event.getValue('MuraScope')>

		<cfif request.context.moduleid neq ''>
			<cfset session.moduleid = request.context.moduleid>
		</cfif>
		
		<cfif application.serviceFactory.containsBean("userUtility")>
			<cfset application.serviceFactory.getBean("userUtility").returnLoginCheck(request.event.getValue("MuraScope"))>
		</cfif>
		
		<!---<cfif application.configBean.getAdminDomain() neq '' and application.configBean.getAdminDomain() neq listFirst(cgi.http_host,":") and not yesNoFormat(request.context.compactDisplay) and not yesNoFormat(request.context.closeCompactDisplay)>--->
		<cfif application.configBean.getAdminDomain() neq '' and application.configBean.getAdminDomain() neq listFirst(cgi.http_host,":")>
			<cfset application.contentServer.renderFilename("/admin/",false)>
			<cfabort>
			<!---<cflocation url="#application.configBean.getContext()#/" addtoken="false">--->
		</cfif>
		
		<cfif session.mura.isLoggedIn and not structKeyExists(session,"siteArray")>
			<cfset session.siteArray=arrayNew(1) />
			<cfloop collection="#application.settingsManager.getSites()#" item="site">
				<cfif application.permUtility.getModulePerm("00000000000000000000000000000000000","#site#")>
					<cfset arrayAppend(session.siteArray,site) />
				</cfif>
			</cfloop>
		</cfif>
		
		<cfif session.mura.isLoggedIn and structKeyExists(session,"siteArray") and not arrayLen(session.siteArray)>
			<cfif not listFind(session.mura.memberships,'S2IsPrivate')>
				<cflocation url="#application.configBean.getContext()#/" addtoken="false">
			<cfelseif not len(request.context.muraAction) 
					or (
							len(request.context.muraAction) 
							and not listfindNoCase("clogin,cMessage,cEditprofile",listLast(listFirst(request.context.muraAction,"."),":") )
						)>
				<cflocation url="#application.configBean.getContext()#/admin/index.cfm?muraAction=cMessage.noaccess" addtoken="false">
			</cfif>
		</cfif>
		
		<cfif not structKeyExists(session,"siteArray")>
			<cfset session.siteArray=arrayNew(1) />
		</cfif>
			
		<cfparam name="session.paramArray" default="#arrayNew(1)#" />
		<cfparam name="session.paramCount" default="0" />
		<cfparam name="session.paramCircuit" default="" />
		<cfparam name="session.paramCategories" default="" />
		<cfparam name="session.paramGroups" default="" />
		<cfparam name="session.inActive" default="" />
		<cfparam name="session.membersOnly" default="false" />
		<cfparam name="session.visitorStatus" default="All" />
		<cfparam name="request.context.param" default="" />
		<cfparam name="request.context.inActive" default="0" />
		<cfparam name="request.context.categoryID" default="" />
		<cfparam name="request.context.groupID" default="" />
		<cfparam name="request.context.membersOnly" default="false" />
		<cfparam name="request.context.visitorStatus" default="All" />
		
			<cfif request.context.param neq ''>
				<cfset session.paramArray=arrayNew(1) />
				<cfset session.paramCircuit=listLast(listFirst(request.context.muraAction,'.'),':') />
				<cfloop from="1" to="#listLen(request.context.param)#" index="i">
					<cfset theParam=listGetAt(request.context.param,i) />
					<cfif evaluate('request.context.paramField#theParam#') neq 'Select Field'
					and evaluate('request.context.paramField#theParam#') neq ''
					and evaluate('request.context.paramCriteria#theParam#') neq ''>
					<cfset temp=structNew() />
					<cfset temp.Field=evaluate('request.context.paramField#theParam#') />
					<cfset temp.Relationship=evaluate('request.context.paramRelationship#theParam#') />
					<cfset temp.Criteria=evaluate('request.context.paramCriteria#theParam#') />
					<cfset temp.Condition=evaluate('request.context.paramCondition#theParam#') />
					<cfset arrayAppend(session.paramArray,temp) />
					</cfif>
				</cfloop>
				<cfset session.paramCount =arrayLen(session.paramArray)/>
				<cfset session.inActive = request.context.inActive />
				<cfset session.paramCategories = request.context.categoryID />
				<cfset session.paramGroups = request.context.groupID />
				<cfset session.membersOnly = request.context.membersOnly />
				<cfset session.visitorStatus = request.context.visitorStatus />
				
			</cfif>
		
		<cfif application.configBean.getAdminSSL() and  not application.utility.isHTTPS()>
			<cfif cgi.query_string eq ''>
					<cfset page='#cgi.script_name#'>
			<cfelse>
					<cfset page='#cgi.script_name#?#cgi.QUERY_STRING#'>
			</cfif>
			
			<cflocation addtoken="false" url="https://#listFirst(cgi.http_host,":")##page#">
		</cfif>
		
		<cfset application.rbFactory.setAdminLocale()>
		
		<cfset application.pluginManager.announceEvent("onAdminRequestStart",request.event)/>
		
	</cffunction>
	
	<cffunction name="setupSession" output="false">
		<cfset var local = structNew() />
		<cfinclude template="../config/appcfc/onSessionStart_include.cfm">
	</cffunction>
	
	<cffunction name="onSessionEnd" output="false">
		<cfset var local = structNew() />
		<cfinclude template="../config/appcfc/onSessionEnd_include.cfm">
	</cffunction>
	
	<cffunction name="doFBInclude" output="false" hint="Returns the UI generated by the named view. Can be called from layouts.">
		<cfargument name="path" />

		<cfset var rc = request.context />
		<cfset var response = '' />
		<cfset var local = structNew() />	
		<cfset var event=request.event>
		<cfset var attributes=rc>
		<cfset var fusebox=structNew()>
		<cfset var myfusebox=structNew()>
		<cfset var key="">
		<cfset var temp=structNew()>
		<cfset fusebox.ajax=rc.ajax>
		<cfset fusebox.layout=rc.layout>
		<cfset myfusebox.originalfuseaction = listLast(listLast(request.action,":"),".")>
		<cfset myfusebox.originalcircuit = listFirst(listLast(request.action,":"),".")>
		
		<cfif not structKeyExists(request,"requestappended")>
			<cfif structKeyExists(request, 'layout')>
				<cfset temp.layout=request.layout>
			</cfif>
			
			<cfset structAppend(request,rc,false)>
			
			<cfif structKeyExists(temp, 'layout')>
				<cfset request.layout=temp.layout>
			<cfelse>
				<cfset structDelete(request,"layout")>
			</cfif>
			
			<cfset request.requestappended=true>
		</cfif>
		
		<cfsavecontent variable='response'><cfinclude template="#arguments.path#"/></cfsavecontent>

		<cfreturn response />

	</cffunction>
	
	<cffunction name="onError"  returnType="void"  output="true">
	    <cfargument name="exception" required="true">
	   	<cfargument name="eventname" type="string" required="true">
	  	<cfset var local = structNew() />
		<cfinclude template="../config/appcfc/onError_include.cfm">
	</cffunction>
	
	<cffunction name="onMissingTemplate" output="true">
	    <cfargument name="targetPage" required="true">
		<cfset var local = structNew() />
		<cfinclude template="../config/appcfc/onMissingTemplate_include.cfm">
		<cfreturn false>
	</cffunction>
	
	<cffunction name="onRequestEnd"  returnType="void"  output="true">
	   <cfargument name="targetPage" required="true">
	  	<cfset var local = structNew() />
		 <cfif isdefined("request.event")>
			<cfset application.pluginManager.announceEvent("onAdminRequestEnd",request.event)/>
			<cfinclude template="../config/appcfc/onRequestEnd_include.cfm">
		 </cfif>
	</cffunction>
	
</cfcomponent>