<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: cSettings --->
<!--- fuseaction: list --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "cSettings">
<cfset myFusebox.thisFuseaction = "list">
<cfif not isUserInRole('S2IsPrivate')>
<cflocation url="index.cfm?fuseaction=cLogin.main&returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false">
<cfabort>
</cfif>
<cfif not isUserInRole('S2')>
<cflocation url="index.cfm" addtoken="false">
<cfabort>
</cfif>
<cfif not isDefined("attributes.orderID")><cfset attributes.orderID = "" /></cfif>
<cfif not isDefined("attributes.orderno")><cfset attributes.orderno = "" /></cfif>
<cfif not isDefined("attributes.deploy")><cfset attributes.deploy = "" /></cfif>
<cfif not isDefined("attributes.action")><cfset attributes.action = "" /></cfif>
<cfif not isDefined("attributes.siteid")><cfset attributes.siteid = "" /></cfif>
<cfif attributes.action eq 'deploy'>
<cfset application.settingsManager.publishSite(attributes.siteid) >
</cfif>
<cfset application.settingsManager.saveOrder(attributes.orderno,attributes.orderID) >
<cfset application.settingsManager.saveDeploy(attributes.deploy,attributes.orderID) >
<cfset request.rsSites = application.settingsManager.getList() >
<cfset request.rsPlugins = application.pluginManager.getAllPlugins() >
<!--- do action="vSettings.list" --->
<cfset myFusebox.thisCircuit = "vSettings">
<cfsavecontent variable="fusebox.layout">
<cftry>
<cfoutput><cfinclude template="../view/vSettings/dsp_list.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 12 and right(cfcatch.MissingFileName,12) is "dsp_list.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_list.cfm in circuit vSettings which does not exist (from fuseaction vSettings.list).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
</cfsavecontent>
<!--- do action="layout.display" --->
<cfset myFusebox.thisCircuit = "layout">
<cfset myFusebox.thisFuseaction = "display">
<cfif not isDefined("fusebox.ajax")><cfset fusebox.ajax = "" /></cfif>
<cfif not isDefined("fusebox.layout")><cfset fusebox.layout = "" /></cfif>
<cftry>
<cfoutput><cfinclude template="../view/layouts/template.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 12 and right(cfcatch.MissingFileName,12) is "template.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse template.cfm in circuit layout which does not exist (from fuseaction layout.display).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfcatch><cfrethrow></cfcatch>
</cftry>

