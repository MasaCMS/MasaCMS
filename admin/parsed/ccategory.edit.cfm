<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: cCategory --->
<!--- fuseaction: edit --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "cCategory">
<cfset myFusebox.thisFuseaction = "edit">
<cfif not isUserInRole('S2IsPrivate')>
<cflocation url="index.cfm?fuseaction=cLogin.main&returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false">
<cfabort>
</cfif>
<cfif (not isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') and not isUserInRole('S2')) and not ( application.permUtility.getModulePerm('00000000000000000000000000000000010','#attributes.siteid#') and application.permUtility.getModulePerm('00000000000000000000000000000000000','#attributes.siteid#'))>
<cfset application.utility.backUp() >
</cfif>
<cfif not isDefined("attributes.startrow")><cfset attributes.startrow = "1" /></cfif>
<cfif not isDefined("attributes.keywords")><cfset attributes.keywords = "" /></cfif>
<cfset request.rsRestrictGroups = application.contentUtility.getRestrictGroups(attributes.siteid) >
<cfset request.categoryBean = application.categoryManager.read(attributes.categoryID) >
<!--- do action="vCategory.ajax" --->
<cfset myFusebox.thisCircuit = "vCategory">
<cfset myFusebox.thisFuseaction = "ajax">
<cfsavecontent variable="fusebox.ajax">
<cfif not isDefined("attributes.parentid")><cfset attributes.parentid = "" /></cfif>
<cftry>
<cfoutput><cfinclude template="../view/vCategory/ajax/dsp_javascript.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 23 and right(cfcatch.MissingFileName,23) is "ajax/dsp_javascript.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse ajax/dsp_javascript.cfm in circuit vCategory which does not exist (from fuseaction vCategory.ajax).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
</cfsavecontent>
<!--- do action="vCategory.edit" --->
<cfset myFusebox.thisFuseaction = "edit">
<cfsavecontent variable="fusebox.layout">
<cfif not isDefined("attributes.parentid")><cfset attributes.parentid = "" /></cfif>
<cftry>
<cfoutput><cfinclude template="../view/vCategory/dsp_form.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 12 and right(cfcatch.MissingFileName,12) is "dsp_form.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_form.cfm in circuit vCategory which does not exist (from fuseaction vCategory.Edit).">
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

