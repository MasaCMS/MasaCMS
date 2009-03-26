<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: cDashboard --->
<!--- fuseaction: sessionSearch --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "cDashboard">
<cfset myFusebox.thisFuseaction = "sessionSearch">
<cfif not isDefined("attributes.startrow")><cfset attributes.startrow = "1" /></cfif>
<cfif not isDefined("attributes.keywords")><cfset attributes.keywords = "" /></cfif>
<cfif not isDefined("attributes.limit")><cfset attributes.limit = "10" /></cfif>
<cfif not isDefined("attributes.threshold")><cfset attributes.threshold = "1" /></cfif>
<cfif not isDefined("attributes.siteID")><cfset attributes.siteID = "" /></cfif>
<cfif not isDefined("session.startDate")><cfset session.startDate = "#now()#" /></cfif>
<cfif not isDefined("session.stopDate")><cfset session.stopDate = "#now()#" /></cfif>
<cfif not isDefined("attributes.membersOnly")><cfset attributes.membersOnly = "false" /></cfif>
<cfif not isDefined("attributes.visitorStatus")><cfset attributes.visitorStatus = "All" /></cfif>
<cfif not isDefined("attributes.contentID")><cfset attributes.contentID = "" /></cfif>
<cfif not isDefined("attributes.direction")><cfset attributes.direction = "" /></cfif>
<cfif not isDefined("attributes.orderby")><cfset attributes.orderby = "" /></cfif>
<cfif not isDefined("attributes.page")><cfset attributes.page = "1" /></cfif>
<cfif not isDefined("attributes.span")><cfset attributes.span = "#session.dashboardSpan#" /></cfif>
<cfif not isDefined("attributes.spanType")><cfset attributes.spanType = "d" /></cfif>
<cfif not isDefined("attributes.startDate")><cfset attributes.startDate = "#dateAdd('#attributes.spanType#',-attributes.span,now())#" /></cfif>
<cfif not isDefined("attributes.stopDate")><cfset attributes.stopDate = "#now()#" /></cfif>
<cfif not isDefined("attributes.newSearch")><cfset attributes.newSearch = "false" /></cfif>
<cfif not isDefined("attributes.startSearch")><cfset attributes.startSearch = "false" /></cfif>
<cfif not isUserInRole('S2IsPrivate')>
<cflocation url="index.cfm?fuseaction=cLogin.main&returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false">
<cfabort>
</cfif>
<cfif (not isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') and not isUserInRole('S2')) and not application.permUtility.getModulePerm('00000000000000000000000000000000000','#attributes.siteid#')>
<cfset application.utility.backUp() >
</cfif>
<cfif not LSisDate(attributes.startDate) and not LSisDate(session.startDate)>
<cfset session.startDate = "#now()#" />
</cfif>
<cfif not LSisDate(attributes.stopDate) and not LSisDate(session.stopDate)>
<cfset session.stopDate = "#now()#" />
</cfif>
<cfif attributes.startSearch and LSisDate(attributes.startDate)>
<cfset session.startDate = "#attributes.startDate#" />
</cfif>
<cfif attributes.startSearch and LSisDate(attributes.stopDate)>
<cfset session.stopDate = "#attributes.stopDate#" />
</cfif>
<cfif attributes.newSearch>
<cfset session.startDate = "#now()#" />
<cfset session.stopDate = "#now()#" />
</cfif>
<cfset request.rsGroups = application.userManager.getPublicGroups('#attributes.siteid#',1) >
<!--- do action="vDashboard.ajax" --->
<cfset myFusebox.thisCircuit = "vDashboard">
<cfset myFusebox.thisFuseaction = "ajax">
<cfsavecontent variable="fusebox.ajax">
<cftry>
<cfoutput><cfinclude template="../view/vDashboard/ajax/dsp_javascript.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 23 and right(cfcatch.MissingFileName,23) is "ajax/dsp_javascript.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse ajax/dsp_javascript.cfm in circuit vDashboard which does not exist (from fuseaction vDashboard.ajax).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
</cfsavecontent>
<!--- do action="vDashboard.sessionSearch" --->
<cfset myFusebox.thisFuseaction = "sessionSearch">
<cfsavecontent variable="fusebox.layout">
<cftry>
<cfoutput><cfinclude template="../view/vDashboard/dsp_sessionSearch.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 21 and right(cfcatch.MissingFileName,21) is "dsp_sessionSearch.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_sessionSearch.cfm in circuit vDashboard which does not exist (from fuseaction vDashboard.sessionSearch).">
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

