<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: cPerm --->
<!--- fuseaction: updatemodule --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "cPerm">
<cfset myFusebox.thisFuseaction = "updatemodule">
<cfif not isUserInRole('S2IsPrivate')>
<cflocation url="index.cfm?fuseaction=cLogin.main&returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false">
<cfabort>
</cfif>
<cfif not isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') and not isUserInRole('S2')>
<cfset application.utility.backUp() >
</cfif>
<cfset application.permUtility.updateModule(attributes) >
<cfif attributes.moduleid eq '00000000000000000000000000000000004'>
<cflocation url="index.cfm?fuseaction=cPrivateUsers.list&siteid=#attributes.siteid#" addtoken="false">
<cfabort>
</cfif>
<cfif attributes.moduleid eq '00000000000000000000000000000000005'>
<cflocation url="index.cfm?fuseaction=cEmail.list&siteid=#attributes.siteid#" addtoken="false">
<cfabort>
</cfif>
<cfif attributes.moduleid eq '00000000000000000000000000000000007'>
<cflocation url="index.cfm?fuseaction=cForm.list&siteid=#attributes.siteid#" addtoken="false">
<cfabort>
</cfif>
<cfif attributes.moduleid eq '00000000000000000000000000000000008'>
<cflocation url="index.cfm?fuseaction=cPublicUsers.list&siteid=#attributes.siteid#" addtoken="false">
<cfabort>
</cfif>
<cfif attributes.moduleid eq '00000000000000000000000000000000009'>
<cflocation url="index.cfm?fuseaction=cMailingList.list&siteid=#attributes.siteid#" addtoken="false">
<cfabort>
</cfif>
<cfif attributes.moduleid eq '00000000000000000000000000000000000'>
<cflocation url="index.cfm?fuseaction=cArch.list&siteid=#attributes.siteid#&moduleid=00000000000000000000000000000000000&topid=00000000000000000000000000000000001" addtoken="false">
<cfabort>
</cfif>
<cfif attributes.moduleid eq '00000000000000000000000000000000006'>
<cflocation url="index.cfm?fuseaction=cAdvertising.listAdvertisers&siteid=#attributes.siteid#" addtoken="false">
<cfabort>
</cfif>
<cfif attributes.moduleid eq '00000000000000000000000000000000010'>
<cflocation url="index.cfm?fuseaction=cCategory.list&siteid=#attributes.siteid#" addtoken="false">
<cfabort>
</cfif>
<cfif attributes.moduleid eq '00000000000000000000000000000000011'>
<cflocation url="index.cfm?fuseaction=cFeed.list&siteid=#attributes.siteid#" addtoken="false">
<cfabort>
</cfif>
<cflocation url="index.cfm?fuseaction=cPlugins.list&siteid=#attributes.siteid#" addtoken="false">
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

