<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: cAdvertising --->
<!--- fuseaction: listCreatives --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "cAdvertising">
<cfset myFusebox.thisFuseaction = "listCreatives">
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
<cfset request.rsList = application.advertiserManager.getCreativesBySiteID(attributes.siteid,attributes.keywords) >
<!--- do action="vAdvertising.listCreatives" --->
<cfset myFusebox.thisCircuit = "vAdvertising">
<cfsavecontent variable="fusebox.layout">
<cfif not isDefined("attributes.date1")><cfset attributes.date1 = "" /></cfif>
<cfif not isDefined("attributes.date2")><cfset attributes.date2 = "" /></cfif>
<cfif not isDefined("attributes.keywords")><cfset attributes.keywords = "" /></cfif>
<cftry>
<cfoutput><cfinclude template="../view/vAdvertising/dsp_listCreatives.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 21 and right(cfcatch.MissingFileName,21) is "dsp_listCreatives.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_listCreatives.cfm in circuit vAdvertising which does not exist (from fuseaction vAdvertising.listCreatives).">
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

