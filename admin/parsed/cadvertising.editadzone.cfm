<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: cAdvertising --->
<!--- fuseaction: editAdZone --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "cAdvertising">
<cfset myFusebox.thisFuseaction = "editAdZone">
<cfif not isDefined("attributes.startrow")><cfset attributes.startrow = "1" /></cfif>
<cfif not isDefined("attributes.keywords")><cfset attributes.keywords = "" /></cfif>
<cfif not isDefined("attributes.date1")><cfset attributes.date1 = "" /></cfif>
<cfif not isDefined("attributes.date2")><cfset attributes.date2 = "" /></cfif>
<cfif not isUserInRole('S2IsPrivate')>
<cflocation url="index.cfm?fuseaction=cLogin.main&returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false">
<cfabort>
</cfif>
<cfif not isUserInRole('S2IsPrivate')>
<cfset application.utility.backUp() >
</cfif>
<cfif (not isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') and not isUserInRole('S2')) and not application.permUtility.getModulePerm('00000000000000000000000000000000006','#attributes.siteid#')>
<cflocation url="#cgi.HTTP_REFERER#" addtoken="false">
<cfabort>
</cfif>
<cfset request.adZoneBean = application.advertiserManager.readAdZone(attributes.adZoneID) >
<!--- do action="vAdvertising.editAdZone" --->
<cfset myFusebox.thisCircuit = "vAdvertising">
<cfsavecontent variable="fusebox.layout">
<cfif not isDefined("attributes.date1")><cfset attributes.date1 = "" /></cfif>
<cfif not isDefined("attributes.date2")><cfset attributes.date2 = "" /></cfif>
<cfif not isDefined("attributes.keywords")><cfset attributes.keywords = "" /></cfif>
<cftry>
<cfoutput><cfinclude template="../view/vAdvertising/dsp_editAdZone.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 18 and right(cfcatch.MissingFileName,18) is "dsp_editAdZone.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_editAdZone.cfm in circuit vAdvertising which does not exist (from fuseaction vAdvertising.editAdZone).">
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

