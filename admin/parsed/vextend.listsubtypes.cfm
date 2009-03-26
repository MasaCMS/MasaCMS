<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: vExtend --->
<!--- fuseaction: listSubTypes --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "vExtend">
<cfset myFusebox.thisFuseaction = "listSubTypes">
<cftry>
<cfoutput><cfinclude template="../view/vExtend/dsp_listSubTypes.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 20 and right(cfcatch.MissingFileName,20) is "dsp_listSubTypes.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_listSubTypes.cfm in circuit vExtend which does not exist (from fuseaction vExtend.listSubTypes).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfcatch><cfrethrow></cfcatch>
</cftry>

