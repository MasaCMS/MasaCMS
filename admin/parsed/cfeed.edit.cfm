<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: cFeed --->
<!--- fuseaction: edit --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "cFeed">
<cfset myFusebox.thisFuseaction = "edit">
<cfif not isUserInRole('S2IsPrivate')>
<cflocation url="index.cfm?fuseaction=cLogin.main&returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false">
<cfabort>
</cfif>
<cfif not application.settingsManager.getSite(attributes.siteid).getHasfeedManager() or (not isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') and not isUserInRole('S2')) and not ( application.permUtility.getModulePerm('00000000000000000000000000000000010','#attributes.siteid#') and application.permUtility.getModulePerm('00000000000000000000000000000000000','#attributes.siteid#'))>
<cfset application.utility.backUp() >
</cfif>
<cfif not isDefined("attributes.startrow")><cfset attributes.startrow = "1" /></cfif>
<cfif not isDefined("attributes.keywords")><cfset attributes.keywords = "" /></cfif>
<cfif not isDefined("attributes.categoryID")><cfset attributes.categoryID = "" /></cfif>
<cfif not isDefined("attributes.contentID")><cfset attributes.contentID = "" /></cfif>
<cfif not isDefined("attributes.restricted")><cfset attributes.restricted = "0" /></cfif>
<cfset request.rsRestrictGroups = application.contentUtility.getRestrictGroups(attributes.siteid) >
<cfset request.feedBean = application.feedManager.read(attributes.feedID) >
<cfset request.rslist = application.feedManager.getcontentItems(attributes.feedID,request.feedBean.getcontentID()) >
<!--- do action="vFeed.ajax" --->
<cfset myFusebox.thisCircuit = "vFeed">
<cfset myFusebox.thisFuseaction = "ajax">
<cfsavecontent variable="fusebox.ajax">
<cftry>
<cfoutput><cfinclude template="../view/vFeed/ajax/dsp_javascript.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 23 and right(cfcatch.MissingFileName,23) is "ajax/dsp_javascript.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse ajax/dsp_javascript.cfm in circuit vFeed which does not exist (from fuseaction vFeed.ajax).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
</cfsavecontent>
<!--- do action="vFeed.edit" --->
<cfset myFusebox.thisFuseaction = "edit">
<cfsavecontent variable="fusebox.layout">
<cfif attributes.type eq 'Local'>
<cftry>
<cfoutput><cfinclude template="../view/vFeed/dsp_form_local.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 18 and right(cfcatch.MissingFileName,18) is "dsp_form_local.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_form_local.cfm in circuit vFeed which does not exist (from fuseaction vFeed.Edit).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfelse>
<cftry>
<cfoutput><cfinclude template="../view/vFeed/dsp_form_remote.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 19 and right(cfcatch.MissingFileName,19) is "dsp_form_remote.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_form_remote.cfm in circuit vFeed which does not exist (from fuseaction vFeed.Edit).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
</cfif>
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

