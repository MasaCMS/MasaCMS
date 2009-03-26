<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: vExtend --->
<!--- fuseaction: editAttributes --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "vExtend">
<cfset myFusebox.thisFuseaction = "editAttributes">
<cftry>
<cfoutput><cfinclude template="../view/vExtend/dsp_editAttributes.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 22 and right(cfcatch.MissingFileName,22) is "dsp_editAttributes.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_editAttributes.cfm in circuit vExtend which does not exist (from fuseaction vExtend.editAttributes).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfcatch><cfrethrow></cfcatch>
</cftry>

