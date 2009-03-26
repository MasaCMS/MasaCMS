<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: cMailingList --->
<!--- fuseaction: download --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "cMailingList">
<cfset myFusebox.thisFuseaction = "download">
<cfif not isUserInRole('S2IsPrivate')>
<cflocation url="index.cfm?fuseaction=cLogin.main&returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false">
<cfabort>
</cfif>
<cfif (not isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') and not isUserInRole('S2')) and not ( application.permUtility.getModulePerm('00000000000000000000000000000000009','#attributes.siteid#') and application.permUtility.getModulePerm('00000000000000000000000000000000000','#attributes.siteid#'))>
<cfset application.utility.backUp() >
</cfif>
<cfif not isDefined("attributes.startrow")><cfset attributes.startrow = "1" /></cfif>
<cfset request.listBean = application.mailinglistManager.read(attributes.mlid,attributes.siteid) >
<cfset request.rslist = application.mailinglistManager.getListMembers(attributes.mlid,attributes.siteid) >
<!--- do action="vMailingList.download" --->
<cfset myFusebox.thisCircuit = "vMailingList">
<cfif not isDefined("attributes.mlid")><cfset attributes.mlid = "" /></cfif>
<cfif not isDefined("attributes.startrow")><cfset attributes.startrow = "1" /></cfif>
<cftry>
<cfoutput><cfinclude template="../view/vMailingList/dsp_download.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 16 and right(cfcatch.MissingFileName,16) is "dsp_download.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_download.cfm in circuit vMailingList which does not exist (from fuseaction vMailingList.download).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfset myFusebox.thisCircuit = "cMailingList">
<cfif myfusebox.originalfuseaction neq 'download'>
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
<cfset myFusebox.thisCircuit = "cMailingList">
<cfset myFusebox.thisFuseaction = "download">
</cfif>
<cfcatch><cfrethrow></cfcatch>
</cftry>

