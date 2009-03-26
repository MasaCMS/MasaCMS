<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: vExtend --->
<!--- fuseaction: editSubType --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "vExtend">
<cfset myFusebox.thisFuseaction = "editSubType">
<cftry>
<cfoutput><cfinclude template="../view/vExtend/dsp_editSubType.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 19 and right(cfcatch.MissingFileName,19) is "dsp_editSubType.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_editSubType.cfm in circuit vExtend which does not exist (from fuseaction vExtend.editSubType).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfcatch><cfrethrow></cfcatch>
</cftry>

