<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: cEmail --->
<!--- fuseaction: showReturns --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "cEmail">
<cfset myFusebox.thisFuseaction = "showReturns">
<cfif not isUserInRole('S2IsPrivate')>
<cflocation url="index.cfm?fuseaction=cLogin.main&returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false">
<cfabort>
</cfif>
<cfif (not isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') and not isUserInRole('S2')) and not ( application.permUtility.getModulePerm('00000000000000000000000000000000005','#attributes.siteid#') and application.permUtility.getModulePerm('00000000000000000000000000000000000','#attributes.siteid#'))>
<cfset application.utility.backUp() >
</cfif>
<cfset Session.moduleid = "00000000000000000000000000000000005" />
<cfset request.rsReturns = application.emailManager.getReturns(attributes.emailid) >
<cfset request.rsReturnsByUser = application.emailManager.getReturnsByUser(attributes.emailid) >
<!--- do action="vEmail.ajax" --->
<cfset myFusebox.thisCircuit = "vEmail">
<cfset myFusebox.thisFuseaction = "ajax">
<cfsavecontent variable="fusebox.ajax">
<cfif not isDefined("attributes.fuseaction")><cfset attributes.fuseaction = "list" /></cfif>
<cfif not isDefined("attributes.subject")><cfset attributes.subject = "" /></cfif>
<cfif not isDefined("attributes.bodytext")><cfset attributes.bodytext = "" /></cfif>
<cfif not isDefined("attributes.bodyhtml")><cfset attributes.bodyhtml = "" /></cfif>
<cfif not isDefined("attributes.createddate")><cfset attributes.createddate = "" /></cfif>
<cfif not isDefined("attributes.deliverydate")><cfset attributes.deliverydate = "" /></cfif>
<cfif not isDefined("attributes.grouplist")><cfset attributes.grouplist = "" /></cfif>
<cfif not isDefined("attributes.groupid")><cfset attributes.groupid = "" /></cfif>
<cfif not isDefined("attributes.emailid")><cfset attributes.emailid = "" /></cfif>
<cfif not isDefined("attributes.status")><cfset attributes.status = "2" /></cfif>
<cfif not isDefined("attributes.lastupdatebyid")><cfset attributes.lastupdatebyid = "" /></cfif>
<cfif not isDefined("attributes.lastupdateby")><cfset attributes.lastupdateby = "" /></cfif>
<cfif not isDefined("session.emaillist.status")><cfset session.emaillist.status = "2" /></cfif>
<cfif not isDefined("session.emaillist.groupid")><cfset session.emaillist.groupid = "" /></cfif>
<cfif not isDefined("session.emaillist.subject")><cfset session.emaillist.subject = "" /></cfif>
<cfif not isDefined("session.emaillist.dontshow")><cfset session.emaillist.dontshow = "1" /></cfif>
<cftry>
<cfoutput><cfinclude template="../view/vEmail_Broadcaster/ajax/dsp_javascript.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 23 and right(cfcatch.MissingFileName,23) is "ajax/dsp_javascript.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse ajax/dsp_javascript.cfm in circuit vEmail which does not exist (from fuseaction vEmail.ajax).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
</cfsavecontent>
<!--- do action="vEmail.showReturns" --->
<cfset myFusebox.thisFuseaction = "showReturns">
<cfsavecontent variable="fusebox.layout">
<cfif not isDefined("attributes.fuseaction")><cfset attributes.fuseaction = "list" /></cfif>
<cfif not isDefined("attributes.subject")><cfset attributes.subject = "" /></cfif>
<cfif not isDefined("attributes.bodytext")><cfset attributes.bodytext = "" /></cfif>
<cfif not isDefined("attributes.bodyhtml")><cfset attributes.bodyhtml = "" /></cfif>
<cfif not isDefined("attributes.createddate")><cfset attributes.createddate = "" /></cfif>
<cfif not isDefined("attributes.deliverydate")><cfset attributes.deliverydate = "" /></cfif>
<cfif not isDefined("attributes.grouplist")><cfset attributes.grouplist = "" /></cfif>
<cfif not isDefined("attributes.groupid")><cfset attributes.groupid = "" /></cfif>
<cfif not isDefined("attributes.emailid")><cfset attributes.emailid = "" /></cfif>
<cfif not isDefined("attributes.status")><cfset attributes.status = "2" /></cfif>
<cfif not isDefined("attributes.lastupdatebyid")><cfset attributes.lastupdatebyid = "" /></cfif>
<cfif not isDefined("attributes.lastupdateby")><cfset attributes.lastupdateby = "" /></cfif>
<cfif not isDefined("session.emaillist.status")><cfset session.emaillist.status = "2" /></cfif>
<cfif not isDefined("session.emaillist.groupid")><cfset session.emaillist.groupid = "" /></cfif>
<cfif not isDefined("session.emaillist.subject")><cfset session.emaillist.subject = "" /></cfif>
<cfif not isDefined("session.emaillist.dontshow")><cfset session.emaillist.dontshow = "1" /></cfif>
<cftry>
<cfoutput><cfinclude template="../view/vEmail_Broadcaster/dsp_returns.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 15 and right(cfcatch.MissingFileName,15) is "dsp_returns.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_returns.cfm in circuit vEmail which does not exist (from fuseaction vEmail.showReturns).">
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

