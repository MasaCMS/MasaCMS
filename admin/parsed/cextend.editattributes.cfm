<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: cExtend --->
<!--- fuseaction: editAttributes --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "cExtend">
<cfset myFusebox.thisFuseaction = "editAttributes">
<cfif not isDefined("attributes.subTypeID")><cfset attributes.subTypeID = "" /></cfif>
<cfif not isDefined("attributes.extendSetID")><cfset attributes.extendSetID = "" /></cfif>
<cfif not isDefined("attributes.attibuteID")><cfset attributes.attibuteID = "" /></cfif>
<cfif not isDefined("attributes.siteID")><cfset attributes.siteID = "" /></cfif>
<cfif not isUserInRole('S2IsPrivate')>
<cflocation url="index.cfm?fuseaction=cLogin.main&returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false">
<cfabort>
</cfif>
<cfif not isUserInRole('S2')>
<cflocation url="index.cfm" addtoken="false">
<cfabort>
</cfif>
<!--- do action="vExtend.ajax" --->
<cfset myFusebox.thisCircuit = "vExtend">
<cfset myFusebox.thisFuseaction = "ajax">
<cfsavecontent variable="fusebox.ajax">
<cftry>
<cfoutput><cfinclude template="../view/vExtend/ajax/dsp_javascript.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 23 and right(cfcatch.MissingFileName,23) is "ajax/dsp_javascript.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse ajax/dsp_javascript.cfm in circuit vExtend which does not exist (from fuseaction vExtend.ajax).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
</cfsavecontent>
<!--- do action="vExtend.editAttributes" --->
<cfset myFusebox.thisFuseaction = "editAttributes">
<cfsavecontent variable="fusebox.layout">
<cftry>
<cfoutput><cfinclude template="../view/vExtend/dsp_editAttributes.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 22 and right(cfcatch.MissingFileName,22) is "dsp_editAttributes.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_editAttributes.cfm in circuit vExtend which does not exist (from fuseaction vExtend.editAttributes).">
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

