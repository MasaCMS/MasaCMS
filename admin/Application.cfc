<cfcomponent extends="framework">

	<cfinclude template="../config/applicationSettings.cfm">
	
	<cfif not hasMainMappings>
		<!--- Try and include global mappings --->
		<cfset canWriteMode=true>
		<cfset canWriteMappings=true>
		<cfset hasMappings=true>
		
		<cftry>
			<cfinclude template="../config/mappings.cfm">
			<cfcatch>
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
			<cfcatch>
				<cfset hasMappings=false>
			</cfcatch>
		</cftry>
		
		<cfif not hasMappings>
			<cfinclude template="../config/buildPluginMappings.cfm">
		</cfif>
		
	</cfif>
	
	<cfset variables.framework=structNew()>
	<cfset variables.framework.home = "home.redirect">
	<cfset variables.framework.action="fuseaction">
	<cfset variables.framework.base="/muraWRM/admin/fw1">
	<cfset variables.framework.applicationKey="muraAdmin">

	<cffunction name="setupApplication" output="false">
		<cfset var framework=structNew()>
		
		<cfif not structKeyExists(application,"serviceFactory")>
			<cfinclude template="../config/settings.cfm">
			<cfscript>
				framework.cache = structNew();
				framework.cache.lastReload = now();
				framework.cache.controllers = structNew();
				framework.cache.services = structNew();
				application[variables.framework.applicationKey] = framework;
			</cfscript>
			<cfset structDelete(url,application.appreloadKey)>
		</cfif>
		
		<cfset variables.framework.password=application.appreloadkey>
		<cfset setBeanFactory( application.serviceFactory )>
	</cffunction>
	
	<cffunction name="setupRequest" output="false">
	
		<cfif right(cgi.script_name, Len("index.cfm")) NEQ "index.cfm" and right(cgi.script_name, Len("error.cfm")) NEQ "error.cfm" AND right(cgi.script_name, 3) NEQ "cfc">
			<cflocation url="index.cfm" addtoken="false">
		</cfif>

		<cfinclude template="../config/settings.cfm">
	
		<cfscript>
			StructAppend(request.context, url, "no");
			StructAppend(request.context, form, "no");
		</cfscript>
		
		<cfparam name="request.context.moduleid" default="">
		<cfparam name="request.context.siteid" default="">
		<cfparam name="request.context.fuseaction" default="">
		<cfparam name="request.context.layout" default=""/>
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
				<cfset application.rbFactory.resetSessionLocale()>
			</cfif>
		<cfelseif not len(session.siteID)>
			<cfset session.siteID="default">
			<cfset session.userFilesPath = "#application.configBean.getAssetPath()#/default/assets/">
		</cfif>
		
		<cfif not structKeyExists(request.context,"siteid")>
			<cfset request.context.siteID=session.siteID>
		</cfif>
		
		<cfset request.event=createObject("component", "mura.event").init(request.context)>
		
		<cfif request.context.moduleid neq ''>
			<cfset session.moduleid = request.context.moduleid>
		</cfif>
		
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
		
		<cfif application.configBean.getAdminSSL() and  cgi.https eq 'Off'  and request.context.compactDisplay eq '' and request.context.closeCompactDisplay eq ''>
			<cfif cgi.query_string eq ''>
					<cfset page='#cgi.script_name#'>
			<cfelse>
					<cfset page='#cgi.script_name#?#cgi.QUERY_STRING#'>
			</cfif>
			
			<cflocation addtoken="false" url="https://#listFirst(cgi.http_host,":")##page#">
		</cfif>
		
		<cfset application.rbFactory.setAdminLocale()>
		
	</cffunction>
	
	<cffunction name="onSessionStart" output="false">
		<cfset request.doMuraGlobalSessionStart=true>
		<cfset  super.onSessionStart()>
	</cffunction>
	
	<cffunction name="onSessionEnd" returnType="void">
	   	<cfargument name="SessionScope" required=True/>
	    <cfargument name="ApplicationScope" required=False/>
		<cfset var pluginEvent=createoObject("component","mura.event")>
		<cfset pluginEvent.setValue("ApplicationScope",arguments.ApplicationScope)>	 
		<cfset pluginEvent.setValue("SessionScope",arguments.SessionScope)>
		
		<cfif structKeyExists(arguments.SessionScope,"mura") and len(arguments.SessionScope.mura.siteid)>
			<cfset pluginEvent.setValue("siteid",arguments.SessionScope.siteid)>
			<cfset arguments.ApplicationScope.pluginManager.announceEvent("onSiteSessionEnd",pluginEvent)>
		</cfif>	
		<cfset arguments.ApplicationScope.pluginManager.announceEvent("onGlobalSessionEnd",pluginEvent)>
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

	<cffunction name="verifyMappings" output="false">
		<!--- Try and include global mappings --->
		<cfset canWriteMode=true>
		<cfset canWriteMappings=true>
		<cfset hasMappings=true>
		<cftry>
			<cfinclude template="mappings.cfm">
			<cfcatch>
				<cfset hasMappings=false>
			</cfcatch>
		</cftry>
	
		<cfif not hasMappings>	
			<cftry>
				<cffile action="write" file="#baseDir#/config/mappings.cfm" output="<!--- Add Custom Mappings Here --->" addnewline="true" mode="775">
				<cfcatch>
					<cfset canWriteMode="false">
					<cftry>
						<cffile action="write" file="#baseDir#/config/mappings.cfm" output="<!--- Add Custom Mappings Here --->" addnewline="true">
						<cfcatch>
							<cfset canWriteMappings=false>
						</cfcatch>
					</cftry>
				</cfcatch>
			</cftry>
	
			<cfdirectory action="list" directory="#baseDir#/requirements/" name="rsRequirements">
			
			<cfloop query="rsRequirements">
				<cfif rsRequirements.type eq "dir" and rsRequirements.name neq '.svn'>
					<cfif canWriteMappings>
						<cffile action="append" file="#baseDir#/config/mappings.cfm" output='<cfset this.mappings["/#rsRequirements.name#"] = mapPrefix & BaseDir & "/requirements/#rsRequirements.name#">' mode="775">	
					<cfelseif canWriteMappings>
						<cffile action="append" file="#baseDir#/config/mappings.cfm" output='<cfset this.mappings["/#rsRequirements.name#"] = mapPrefix & BaseDir & "/requirements/#rsRequirements.name#">'>	
					</cfif>
					<cfset this.mappings["/#rsRequirements.name#"] = mapPrefix & rsRequirements.directory & "/" & rsRequirements.name>
				</cfif>
			</cfloop>	
		</cfif>
		
		<cfset canWriteMode=true>
		<cfset hasMappings=true>
		<cfset canWriteMappings=true>
		<cftry>
			<cfinclude template="../plugins/mappings.cfm">
			<cfcatch>
				<cfset hasMappings=false>
			</cfcatch>
		</cftry>
		
		<cfif not hasMappings>
			<cftry>
				<cffile action="write" file="#baseDir#/plugins/mappings.cfm" output="<!--- Do Not Edit --->" addnewline="true" mode="775">
				<cfcatch>
					<cfset canWriteMode=false>
					<cftry>
						<cffile action="write" file="#baseDir#/plugins/mappings.cfm" output="<!--- Do Not Edit --->" addnewline="true">
						<cfcatch>
							<cfset canWriteMappings=false>
						</cfcatch>
					</cftry>
				</cfcatch>
			</cftry>
			
			<cfdirectory action="list" directory="#baseDir#/plugins/" name="rsRequirements">
			
			<cfloop query="rsRequirements">
				<cfif rsRequirements.type eq "dir" and rsRequirements.name neq '.svn'>
					<cfset m=listFirst(rsRequirements.name,"_")>
					<cfif not isNumeric(m) and not structKeyExists(this.mappings,m)>
						<cfif canWriteMode>
							<cffile action="append" file="#baseDir#/plugins/mappings.cfm" output='<cfset this.mappings["/#m#"] = mapPrefix & BaseDir & "/plugins/#rsRequirements.name#">' mode="775">
						<cfelseif canWriteMappings>
							<cffile action="append" file="#baseDir#/plugins/mappings.cfm" output='<cfset this.mappings["/#m#"] = mapPrefix & BaseDir & "/plugins/#rsRequirements.name#">'>		
						</cfif>
						<cfset this.mappings["/#m#"] = mapPrefix & rsRequirements.directory & "/" & rsRequirements.name>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
	</cffunction>
	
	<cffunction name="onError"  returnType="void"  output="true">
      	<cfargument name="exception" required="true">
      	<cfargument name="eventname" type="string" required="true">
		<cfset var pluginEvent="">
		
		<cfif structKeyExists(application,"pluginManager")>
			<cfif structKeyExists(request,"servletEvent")>
				<cfset pluginEvent=request.servletEvent>
			<cfelseif structKeyExists(request,"event")>
				<cfset pluginEvent=request.event>
			<cfelse>
				<cfset pluginEvent=createObject("component","mura.event")>
			</cfif>
			<cfset pluginEvent.setValue("exception",arguments.exception)>
			<cfset pluginEvent.setValue("eventname",arguments.eventname)>
			<cfif len(pluginEvent.getValue("siteID"))>
				<cfset application.pluginManager.announceEvent("onSiteError",pluginEvent)>
			</cfif>	
			<cfset application.pluginManager.announceEvent("onGlobalError",pluginEvent)>
		</cfif>
		
		<cfif structKeyExists(application,"configBean")>
			<cfif not application.configBean.getDebuggingEnabled()>
				<cferror 
					template="error.html"
					mailto="#application.configBean.getMailserverusername()#"
					type="Exception">
			</cfif>
		</cfif>
		
		<cfdump var="#arguments.exception#">
		<cfabort>
	</cffunction>
	
</cfcomponent>