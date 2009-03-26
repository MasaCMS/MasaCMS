<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: vExtend --->
<!--- fuseaction: editSet --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "vExtend">
<cfset myFusebox.thisFuseaction = "editSet">
<cftry>
<cfoutput><cfinclude template="../view/vExtend/dsp_editSet.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 15 and right(cfcatch.MissingFileName,15) is "dsp_editSet.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_editSet.cfm in circuit vExtend which does not exist (from fuseaction vExtend.editSet).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfcatch><cfrethrow></cfcatch>
</cftry>

