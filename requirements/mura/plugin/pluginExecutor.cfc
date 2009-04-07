<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.configBean="">
<cfset variables.settingsManager="">
<cfset variables.pluginManager="">

<cffunction name="init" returntype="any" access="public" output="false">
	<cfargument name="configBean">
	<cfargument name="settingsManager">
	<cfargument name="pluginManager">
	
	<cfset variables.configBean=arguments.configBean />
	<cfset variables.settingsManager=arguments.settingsManager />
	<cfset variables.pluginManager=arguments.pluginManager />
	
<cfreturn this />
</cffunction>

<cffunction name="displayObject" output="true" returntype="any">
<cfargument name="objectID">
<cfargument name="_event">
<cfargument name="rsDisplayObject">
	<cfset var rs=""/>
	<cfset var str=""/>
	<cfset var pluginConfig=""/>
	
	<cfset request.pluginConfig=variables.pluginManager.getConfig(arguments.rsDisplayObject.pluginID)>
	<cfset request.pluginConfig.setSetting("pluginMode","object")/>
	<cfset pluginConfig=request.pluginConfig/>
	<cfset event=arguments._event/>
	<cftry>
	<cfif arguments.rsDisplayObject.location eq "global">
	
	<cfset pluginConfig.setSetting("pluginPath","#variables.configBean.getContext()#/plugins/#arguments.rsDisplayObject.pluginID#/")/>

	<cfsavecontent variable="str">
	<cfinclude template="/#variables.configBean.getWebRootMap()#/plugins/#arguments.rsDisplayObject.pluginID#/#arguments.rsDisplayObject.displayObjectFile#">
	</cfsavecontent>
	<cfelse>
	
	<cfset pluginConfig.setSetting("pluginPath","#variables.configBean.getContext()#/#variables.settingsManager.getSite(event.getValue('siteID')).getDisplayPoolID()#/includes/plugins/#arguments.rsDisplayObject.pluginID#/")/>
	<cfsavecontent variable="str">
	<cfinclude template="/#variables.configBean.getWebRootMap()#/#variables.settingsManager.getSite(event.getValue('siteID')).getDisplayPoolID()#/includes/plugins/#arguments.rsDisplayObject.pluginID#/#arguments.rsDisplayObject.displayObjectFile#">
	</cfsavecontent>
	</cfif>
	<cfcatch>
		 <cfsavecontent variable="str"><cfdump var="#cfcatch#"></cfsavecontent>
	</cfcatch>
	</cftry>
	
	<cfset structDelete(request,"pluginConfig")>
	
	<cfreturn trim(str) />
</cffunction>

<cffunction name="executeScript" output="false" returntype="any">
<cfargument name="runat">
<cfargument name="siteID" required="true" default="">
<cfargument name="_event" required="true" default="" type="any">
<cfargument name="scriptFile" required="true" default="" type="any">
<cfargument name="_pluginConfig" required="true" default="" type="any">
	
	<cfset request.pluginConfig=arguments._pluginConfig/>
	<cfset request.scriptEvent=arguments._event/>
	<cfset event=request.scriptEvent/>
	<cfset scriptEvent=request.scriptEvent/>
	<cfset pluginConfig=request.pluginConfig/>
	<cfinclude template="#arguments.scriptFile#">
	<cfset structDelete(request,"pluginConfig")>
	<cfset structDelete(request,"scriptEvent")>
	<cfreturn scriptEvent/>

</cffunction>

</cfcomponent>