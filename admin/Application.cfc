<cfcomponent extends="framework">

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
	<cfset variables.framework.action="fuseaction">
	<cfset variables.framework.base="/muraWRM/admin/fw1">
	<cfset variables.framework.applicationKey="muraAdmin">
	
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
		</cfscript>
		
		<cfparam name="request.context.moduleid" default="">
		<cfparam name="request.context.siteid" default="">
		<cfparam name="request.context.fuseaction" default="">
		<cfparam name="request.context.layout" default=""/>
		<cfparam name="request.context.activetab" default="0"/>
		<cfparam name="request.context.activepanel" default="0"/>
		<cfparam name="request.context.ajax" default="">
		<cfparam name="request.context.rb" default="">
		<cfparam name="request.context.closeCompactDisplay" default="false">
		<cfparam name="request.context.compactDisplay" default="false">
		<cfparam name="session.siteid" default="">
		<cfparam name="session.keywords" default="">
		<cfparam name="cookie.rb" default="">
	
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
			</cfif>
		<cfelseif not len(session.siteID)>
			<cfset session.siteID="default">
			<cfset session.userFilesPath = "#application.configBean.getAssetPath()#/default/assets/">	
		</cfif>
		
		<cfset application.rbFactory.resetSessionLocale()>
		
		<cfif not structKeyExists(request.context,"siteid")>
			<cfset request.context.siteID=session.siteID>
		</cfif>
		
		<cfset request.event=createObject("component", "mura.event").init(request.context)>
		
		<cfif request.context.moduleid neq ''>
			<cfset session.moduleid = request.context.moduleid>
		</cfif>
		
		<cfset application.serviceFactory.getBean("userUtility").returnLoginCheck(request.event.getValue("MuraScope"))>
		
		<cfif application.configBean.getAdminDomain() neq '' and application.configBean.getAdminDomain() neq listFirst(cgi.http_host,":") and request.context.compactDisplay eq '' and request.context.closeCompactDisplay eq ''>
			<cflocation url="#application.configBean.getContext()#/" addtoken="false">
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
			<cfelseif not len(request.context.fuseaction) or (len(request.context.fuseaction) and not listfindNoCase("clogin,cMessage,cEditprofile",listFirst(request.context.fuseaction,".")))>
				<cflocation url="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cMessage.noaccess" addtoken="false">
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
				<cfset session.paramCircuit=listFirst(request.context.fuseaction,'.') />
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
		
	</cffunction>
	
	<cffunction name="setupSession" output="false">
		<cfset var local = structNew() />
		<cfinclude template="../config/appcfc/onSessionStart_include.cfm">
	</cffunction>
	
	<cffunction name="onSessionEnd" output="false">
		<cfset var local = structNew() />
		<cfinclude template="../config/appcfc/onSessionEnd_include.cfm">
		<cfset super.onSessionEnd()>
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
		<cfset myfusebox.originalfuseaction = listLast(request.action,".")>
		<cfset  myfusebox.originalcircuit = listFirst(request.action,".")>
		
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
	
	<cffunction name="onMissingTemplate"  returnType="void"  output="true">
	    <cfargument name="targetPage" required="true">
		<cfset var local = structNew() />
		<cfinclude template="../config/appcfc/onMissingTemplate_include.cfm">
		<cfreturn false>
	</cffunction>
	
	<cffunction name="onRequestEnd"  returnType="void"  output="true">
	   <cfargument name="targetPage" required="true">
	  	<cfset var local = structNew() />
		<cfinclude template="../config/appcfc/onRequestEnd_include.cfm">
	</cffunction>
	
</cfcomponent>