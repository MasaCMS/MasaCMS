<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: cLogin --->
<!--- fuseaction: main --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "cLogin">
<cfset myFusebox.thisFuseaction = "main">
<cfif not isDefined("attributes.returnURL")><cfset attributes.returnURL = "" /></cfif>
<cfif isUserInRole('S2IsPrivate')>
<!--- do action="home.redirect" --->
<cfset myFusebox.thisCircuit = "home">
<cfset myFusebox.thisFuseaction = "redirect">
<cftry>
<cfoutput><cfinclude template="../home/redirect.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 12 and right(cfcatch.MissingFileName,12) is "redirect.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse redirect.cfm in circuit home which does not exist (from fuseaction home.redirect).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfset myFusebox.thisCircuit = "cLogin">
<cfset myFusebox.thisFuseaction = "main">
</cfif>
<!--- do action="vLogin.main" --->
<cfset myFusebox.thisCircuit = "vLogin">
<cfsavecontent variable="fusebox.layout">
<cfif not isDefined("attributes.contentid")><cfset attributes.contentid = "" /></cfif>
<cfif not isDefined("attributes.contenthistid")><cfset attributes.contenthistid = "" /></cfif>
<cfif not isDefined("attributes.topid")><cfset attributes.topid = "" /></cfif>
<cfif not isDefined("attributes.type")><cfset attributes.type = "" /></cfif>
<cfif not isDefined("attributes.moduleid")><cfset attributes.moduleid = "" /></cfif>
<cfif not isDefined("attributes.redirect")><cfset attributes.redirect = "" /></cfif>
<cfif not isDefined("attributes.parentid")><cfset attributes.parentid = "" /></cfif>
<cfif not isDefined("attributes.siteid")><cfset attributes.siteid = "" /></cfif>
<cfif not isDefined("attributes.status")><cfset attributes.status = "" /></cfif>
<cftry>
<cfoutput><cfinclude template="../view/vLogin/dsp_main.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 12 and right(cfcatch.MissingFileName,12) is "dsp_main.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_main.cfm in circuit vLogin which does not exist (from fuseaction vLogin.main).">
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

