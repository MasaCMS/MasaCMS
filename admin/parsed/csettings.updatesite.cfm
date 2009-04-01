<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: cSettings --->
<!--- fuseaction: updateSite --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "cSettings">
<cfset myFusebox.thisFuseaction = "updateSite">
<cfif not isUserInRole('S2IsPrivate')>
<cflocation url="index.cfm?fuseaction=cLogin.main&returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false">
<cfabort>
</cfif>
<cfif not isUserInRole('S2')>
<cflocation url="index.cfm" addtoken="false">
<cfabort>
</cfif>
<cfif attributes.action eq 'Update'>
<cfset application.settingsManager.update(attributes) >
<cfset application.clusterManager.reload() >
</cfif>
<cfif attributes.action eq 'Add'>
<cfset application.settingsManager.create(attributes) >
<cfset application.settingsManager.setSites() >
<cfset application.clusterManager.reload() >
</cfif>
<cfif attributes.action eq 'Delete'>
<cfset application.settingsManager.delete(attributes.siteid) >
<cfset session.siteid = "default" />
<cfset attributes.siteid = "default" />
</cfif>
<cflocation url="index.cfm?fuseaction=cSettings.list" addtoken="false">
<cfabort>
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

