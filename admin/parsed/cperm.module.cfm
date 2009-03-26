<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: cPerm --->
<!--- fuseaction: module --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "cPerm">
<cfset myFusebox.thisFuseaction = "module">
<cfif not isUserInRole('S2IsPrivate')>
<cflocation url="index.cfm?fuseaction=cLogin.main&returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false">
<cfabort>
</cfif>
<cfif not isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') and not isUserInRole('S2')>
<cfset application.utility.backUp() >
</cfif>
<cfset request.groups = application.permUtility.getGrouplist(attributes) >
<cfset request.rsContent = application.permUtility.getModule(attributes) >
<!--- do action="vPerm.module" --->
<cfset myFusebox.thisCircuit = "vPerm">
<cfsavecontent variable="fusebox.layout">
<cfif not isDefined("attributes.parentid")><cfset attributes.parentid = "" /></cfif>
<cfif not isDefined("attributes.topid")><cfset attributes.topid = "" /></cfif>
<cfif not isDefined("attributes.contentid")><cfset attributes.contentid = "" /></cfif>
<cfif not isDefined("attributes.body")><cfset attributes.body = "" /></cfif>
<cfif not isDefined("attributes.Contentid")><cfset attributes.Contentid = "" /></cfif>
<cfif not isDefined("attributes.groupid")><cfset attributes.groupid = "" /></cfif>
<cfif not isDefined("attributes.url")><cfset attributes.url = "" /></cfif>
<cfif not isDefined("attributes.type")><cfset attributes.type = "" /></cfif>
<cfif not isDefined("attributes.startrow")><cfset attributes.startrow = "1" /></cfif>
<cfif not isDefined("attributes.siteid")><cfset attributes.siteid = "" /></cfif>
<cfif not isDefined("attributes.topid")><cfset attributes.topid = "00000000000000000000000000000000001" /></cfif>
<cftry>
<cfoutput><cfinclude template="../view/vPermissions/dsp_perm_module.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 19 and right(cfcatch.MissingFileName,19) is "dsp_perm_module.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_perm_module.cfm in circuit vPerm which does not exist (from fuseaction vPerm.module).">
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

