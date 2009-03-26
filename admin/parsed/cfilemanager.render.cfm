<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: cFilemanager --->
<!--- fuseaction: render --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "cFilemanager">
<cfset myFusebox.thisFuseaction = "render">
<cfset attributes.siteid = "#session.siteid#" />
<cfif not isUserInRole('S2IsPrivate')>
<cflocation url="index.cfm?fuseaction=cLogin.main&returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false">
<cfabort>
</cfif>
<cfif not isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') and not isUserInRole('S2')>
<cflocation url="index.cfm" addtoken="false">
<cfabort>
</cfif>
<cftry>
<cfoutput><cfinclude template="../controller/cFilemanager/render.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 10 and right(cfcatch.MissingFileName,10) is "render.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse render.cfm in circuit cFilemanager which does not exist (from fuseaction cFilemanager.render).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfcatch><cfrethrow></cfcatch>
</cftry>

